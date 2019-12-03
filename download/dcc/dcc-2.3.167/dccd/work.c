/* Distributed Checksum Clearinghouse
 *
 * work on a job in the server
 *
 * Copyright (c) 2019 by Rhyolite Software, LLC
 *
 * Permission to use, copy, modify, and distribute this software without
 * changes for any purpose with or without fee is hereby granted, provided
 * that the above copyright notice and this permission notice appear in all
 * copies and any distributed versions or copies are either unchanged
 * or not called anything similar to "DCC" or "Distributed Checksum
 * Clearinghouse".
 *
 * __________________________________________________
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND RHYOLITE SOFTWARE, LLC DISCLAIMS ALL
 * WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL RHYOLITE SOFTWARE, LLC
 * BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
 * OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
 * WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
 * ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * Rhyolite Software DCC 2.3.167-1.343 $Revision$
 */

#include "dccd_defs.h"

typedef struct {
    time_t us;
    u_int   ops;
} Q_DELAY_SEC;
static Q_DELAY_SEC q_delays[9];
static Q_DELAY_SEC q_delays_sum;	/* sum of all but q_delays[0] */
static time_t q_delays_start;		/* second for q_delays[0] */

DCCD_STATS dccd_stats;

u_char query_only;			/* 1=treat reports as queries */

u_char grey_weak_body;			/* 1=ignore bodies for greylisting */
u_char grey_weak_ip;			/* 1=a good triple whitelists addr */

u_char complained_missing_date;


/* report cache used to detect duplicate or retransmitted reports */
static RIDC *ridc_newest, *ridc_oldest;
static u_int ridc_blocks;
static RIDC_HASH *ridc_hash, *old_ridc_hash;
#define RIDC_HASH_CHECK_SECS 30

/* assume we cannot handle more than 10,000 reports/second. */
#define MAX_RIDC_BLOCKS (10*1000*RIDC_HASH_CHECK_SECS)

static inline RIDC **
ridc_hash_fnc(const QUEUE *q, RIDC_HASH *hash)
{
	u_long sum;

	/* The client's (ID,RID,HID,PID) should be unique and
	 * constant for retransmissions of a single request.
	 * We cannot trust it entirely, if only because of anonymous clients. */
	sum = q->pkt.hdr.sender;
	sum += q->pkt.hdr.op_nums.h;
	sum += q->pkt.hdr.op_nums.p;
	sum += q->pkt.hdr.op_nums.r;

	return &hash->bins[sum % hash->num_bins];
}



static inline u_char
ridc_cmp(const RIDC *ridc, const QUEUE *q)
{
	return (ridc->d.clnt_port == DCC_SU_PORT(&q->clnt_su)
		&& !memcmp(&ridc->d.hdr, &q->pkt.hdr,
			   sizeof(ridc->d.hdr)-sizeof(ridc->d.hdr.op_nums.t)));
}



/* make some (more) RID blocks and (re)build the hash table */
static void
ridc_make_blocks(void)
{
	u_int new_blocks, n;
	RIDC *ridc;
	double rate;

	new_blocks = (ridc_blocks != 0) ? ridc_blocks : 20;

	ridc = dcc_malloc(new_blocks*sizeof(*ridc));
	if (!ridc)
		dcc_logbad(EX_OSERR, "malloc(%d RIDC blocks) failed",
			   new_blocks);
	memset(ridc, 0, new_blocks*sizeof(*ridc));

	/* make the new blocks oldest */
	n = 0;
	if (!ridc_oldest) {
		ridc_oldest = ridc_newest = ridc;
		++n;
		++ridc;
	}
	while (n < new_blocks) {
		ridc_oldest->older = ridc;
		ridc->newer = ridc_oldest;
		ridc_oldest = ridc;
		++n;
		++ridc;
	}

	/* Complain if we are receiving an impossible number of requests/sec */
	if ((db_debug || ridc_blocks > MAX_RIDC_BLOCKS)
	    && ridc_hash) {
		rate = ridc_hash->probes;
		if (ridc_hash->searches != 0)
			rate /= ridc_hash->searches;
		dcc_trace_msg("increase from %d to %d RIDC blocks with"
			      " %d bins; average search length %.1f",
			      ridc_blocks, ridc_blocks+new_blocks,
			      ridc_hash->num_bins, rate);
	}

	ridc_blocks += new_blocks;

	/* hurry hash table size check */
	if (ridc_hash)
		ridc_hash->check_time = 0;
}



static inline void
ridc_chain_check_reset(void)
{
	ridc_hash->probes = 0;
	ridc_hash->searches = 0;
	ridc_hash->check_time = db_time.tv_sec + RIDC_HASH_CHECK_SECS;
}



static void
ridc_free_old_hash(void)
{
	RIDC **bin, *ridc;

	if (!old_ridc_hash)
		return;

	for (bin = &old_ridc_hash->bins[0];
	     bin < &old_ridc_hash->bins[old_ridc_hash->num_bins];
	     ++bin) {
		for (ridc = *bin; ridc; ridc = ridc->hfwd) {
			ridc->bin = 0;
			ridc->d.last_used = 0;
		}
	}

	dcc_free(old_ridc_hash);
	old_ridc_hash = 0;
}



static void
ridc_expand_hash(void)
{
	u_int old_bins, new_bins;
	size_t hsize;
	double rate;

	old_bins = ridc_hash ? ridc_hash->num_bins : 0;
	new_bins = old_bins/8 + old_bins;

	/* Most RIDC searches fail and so go to the end of the hash chain.
	 * So follow the old rules and make the hash table 10% larger
	 * than the number of blocks. */
	if (new_bins < (ridc_blocks*11)/10)
		new_bins = (ridc_blocks*11)/10;
	if (new_bins > MAX_RIDC_BLOCKS)
		new_bins = MAX_RIDC_BLOCKS;
	new_bins = hash_divisor(new_bins, 0);
	if (new_bins == old_bins) {
		dcc_trace_msg("%d RIDC blocks and %d bins are enough",
			      ridc_blocks, ridc_hash->num_bins);
		ridc_chain_check_reset();
	}

	ridc_free_old_hash();
	old_ridc_hash = ridc_hash;
	if (old_ridc_hash)
		old_ridc_hash->check_time = (db_time.tv_sec
					     + DCC_MAX_RETRANS_DELAY_SECS);

	hsize = sizeof(*ridc_hash) + (new_bins-1)*sizeof(ridc_hash->bins);
	ridc_hash = dcc_malloc(hsize);
	if (!ridc_hash)
		dcc_logbad(EX_OSERR, "malloc(%d RIDC hash table) failed",
			   new_bins);
	memset(ridc_hash, 0, hsize);
	ridc_hash->num_bins = new_bins;

	if (db_debug && old_ridc_hash) {
		rate = old_ridc_hash->probes;
		if (old_ridc_hash->searches != 0)
			rate /= old_ridc_hash->searches;
		dcc_trace_msg("increase from %d to %d RIDC bins for %d blocks;"
			      " average search length %.1f",
			      old_ridc_hash->num_bins, ridc_hash->num_bins,
			      ridc_blocks, rate);
	}

	ridc_chain_check_reset();
}



static void
ridc_ref(RIDC *ridc, RIDC **new_bin, u_int probes)
{
	ridc->d.last_used = db_time.tv_sec + DCC_MAX_RETRANS_DELAY_SECS;

	/* Make the entry most recently used. */
	if (ridc->newer) {
		ridc->newer->older = ridc->older;
		if (ridc->older)
			ridc->older->newer = ridc->newer;
		else
			ridc_oldest = ridc->newer;

		ridc->older = ridc_newest;
		ridc_newest->newer = ridc;
		ridc_newest = ridc;
		ridc->newer = 0;
	}

	/* Move the entry to the head of its hash chain. */
	if (*new_bin != ridc) {
		if (ridc->hfwd)
			ridc->hfwd->hbak = ridc->hbak;
		if (ridc->hbak) {
			ridc->hbak->hfwd = ridc->hfwd;
		} else if (ridc->bin) {
			*ridc->bin = ridc->hfwd;
		}

		ridc->hbak = 0;
		ridc->bin = new_bin;
		if ((ridc->hfwd = *new_bin) != 0)
			ridc->hfwd->hbak = ridc;
		*new_bin = ridc;
	}

	/* update the average search length
	 * and expand the hash bins if necessary */
	ridc_hash->probes += probes;
	++ridc_hash->searches;
	if (ridc_hash->searches > 100
	    && DB_IS_TIME(ridc_hash->check_time, RIDC_HASH_CHECK_SECS)
	    && (!old_ridc_hash || DB_IS_TIME(old_ridc_hash->check_time,
					     DCC_MAX_RETRANS_DELAY_SECS))) {
		if (ridc_hash->probes/ridc_hash->searches > 2)
			ridc_expand_hash();
		ridc_chain_check_reset();
	}
}



/* get the report cache block for an operation */
static u_char				/* 0=new operation, 1=retransmission */
ridc_get(QUEUE *q)
{
	RIDC *ridc, **bin;
	u_int probes;

	/* initialize on first use */
	if (ridc_blocks == 0) {
		ridc_make_blocks();
		ridc_expand_hash();
	}

	/* Look for the block in the current hash table. */
	bin = ridc_hash_fnc(q, ridc_hash);
	for (ridc = *bin, probes = 1; ridc; ridc = ridc->hfwd, ++probes) {
		/* Reports are relatively small, so we
		 * can afford to not trust the client's
		 * RID to be unique.  Compare all but the
		 * client's transmission #. */
		if (ridc_cmp(ridc, q)) {
			/* found it, so make it newest */
			ridc_ref(ridc, bin, probes);
			q->ridc = ridc;
			return 1;
		}
	}

	/* Look in the old hash table if we did not find the entry. */
	if (old_ridc_hash) {
		for (ridc = *ridc_hash_fnc(q, old_ridc_hash);
		     ridc;
		     ridc = ridc->hfwd) {
			if (ridc_cmp(ridc,q)) {
				ridc_ref(ridc, bin, probes);
				q->ridc = ridc;
				return 1;
			}
		}
		/* discard old hash table when all of its entries are old */
		if (DB_IS_TIME(old_ridc_hash->check_time,
			       DCC_MAX_RETRANS_DELAY_SECS))
			ridc_free_old_hash();
	}

	/* The block does not already exist, so create it from a recycled
	 * block or from new memory. */
	ridc = ridc_oldest;
	if (!DB_IS_TIME(ridc->d.last_used, DCC_MAX_RETRANS_DELAY_SECS)) {
		ridc_make_blocks();
		ridc = ridc_oldest;
	}

	memcpy(&ridc->d.hdr, &q->pkt.hdr, sizeof(ridc->d.hdr));
	ridc->d.clnt_port = DCC_SU_PORT(&q->clnt_su);
	ridc->d.op = DCC_OP_INVALID;
	ridc->d.bad = 1;
	ridc->d.len = 0;

	/* note that ridc_ref() can invalidate bin */
	ridc_ref(ridc, bin, probes);
	q->ridc = ridc;
	return 0;
}



#define RIDC_BAD(q) {if ((q)->ridc) (q)->ridc->d.bad = 1;}


/* update the average queue delay at the start of a new second */
static void
update_q_delay(void)
{
	time_t secs;
	Q_DELAY_SEC *src, *tgt;

	secs = db_time.tv_sec - q_delays_start;
	if (secs == 0)
		return;

	/* At the start of a new second,
	 * forget the delays for old seconds we no longer care about
	 * and start accumulating delays for the new second
	 * Slide accumulated delays and total operations previous seconds. */
	q_delays_start = db_time.tv_sec;
	q_delays_sum.us = 0;
	q_delays_sum.ops = 0;
	tgt = LAST(q_delays);
	if (secs > 0 && secs < DIM(q_delays)) {
		src = tgt - secs;
		do {
			q_delays_sum.us += (tgt->us = src->us);
			q_delays_sum.ops += (tgt->ops = src->ops);
			--tgt;
		} while (src-- != &q_delays[0]);
	}
	memset(q_delays, 0, sizeof(q_delays[0]) * (tgt+1 - q_delays));
}



/* compute the average queue delay this client should see */
static u_int
avg_q_delay_ms(const QUEUE *q)
{
	u_int ops;
	time_t us;

	/* get the average service delay excluding per-client-ID delays */
	update_q_delay();
	ops = q_delays[0].ops + q_delays_sum.ops;
	if (ops == 0)
		us = 0;
	else
		us = (q_delays[0].us + q_delays_sum.us + ops/2) / ops;

	/* add the per-client-ID penalty */
	us += q->delay_us;
	return (us + 500) / 1000;
}



/* get a unique timestamp */
void
new_ts(DCC_TS *ts)			/* put it here */
{
	static struct timeval prev_time;
	static int faked;

	/* if we have generated a lot of fake timestamps
	 * and our snapshot of the clock is old,
	 * then check the clock in the hope it has ticked */
	if (db_time.tv_usec <= prev_time.tv_usec
	    && db_time.tv_sec == prev_time.tv_sec
	    && faked > 100) {
		faked = 0;
		gettimeofday(&db_time, 0);
	}

	/* Try to make the next timestamp unique, but only as long
	 * as time itself marches forward.  This must work many times
	 * a second, or the resoltion of DCC timestaps.
	 * Worse, the increment can exhaust values from future seconds.
	 * Forget about it if the problem lasts for more than 5 minutes. */
	if (db_time.tv_sec > prev_time.tv_sec
	    || (db_time.tv_sec == prev_time.tv_sec
		&& db_time.tv_usec > prev_time.tv_usec)
	    || db_time.tv_sec < prev_time.tv_sec-5*60) {
		/* either the current time is good enough or we must
		 * give up and use it to make the timestamp */
		prev_time = db_time;
		faked = 0;

	} else {
		/* fudge the previous timestamp to make it good enough */
		prev_time.tv_usec += DCC_TS_USEC_MULT;
		if (prev_time.tv_usec >= DCC_US) {
			prev_time.tv_usec -= DCC_US;
			++prev_time.tv_sec;
		}
		++faked;
	}

	timeval2ts(ts, &prev_time, 0);
}



/* consume the timestamp in the queue entry or get a new one */
static void
use_ts(DCC_TS *ts, QUEUE *q)
{
	if ((q->flags & (Q_FG_HAVE_TS | Q_FG_USED_TS)) == Q_FG_HAVE_TS) {
		*ts = q->ts;
		q->flags |= Q_FG_USED_TS;
	} else {
		new_ts(ts);
	}
}



/* find database record for a server-ID */
static int				/* -1=broken database 0=no record */
find_srvr_rcd(const DCC_SUM *sum,
	      DCC_SRVR_ID id,
	      u_char match_id,		/* 1=an existing record must match id */
	      const char *str,
	      DB_ST *rcd_st0)
{
	DB_ST *rcd_st;
	DB_RCD_CK *found_ck;
	DB_PTR prev, loop_prev;

	rcd_st = rcd_st0 ? rcd_st0 : GET_DB_ST();
	switch (db_lookup(&dcc_emsg, DCC_CK_SRVR_ID, sum,
			  0, rcd_st, &found_ck)) {
	case DB_FOUND_SYSERR:
		DB_ERROR_MSG2(str, dcc_emsg.c);
		if (!rcd_st0)
			free_db_st(rcd_st);
		return -1;
	case DB_FOUND_IT:
		/* look for a record that is neither junk nor deleted
		 * and has the right server-ID */
		loop_prev = DB_PTR_MAX+1;
		for (;;) {
			if (!DB_CK_JUNK(found_ck)
			    && DB_TGTS_RCD(rcd_st->d.r) != 0
			    && (!match_id
				|| DB_RCD_ID(rcd_st->d.r) == id)) {
				if (!rcd_st0)
					free_db_st(rcd_st);
				return 1;
			}
			prev = DB_PTR_EX(found_ck->prev);
			if (prev == DB_PTR_NULL) {
				if (!rcd_st0)
					free_db_st(rcd_st);
				return 0;
			}
			if (DB_PTR_IS_BAD(prev, loop_prev)) {
				db_failure(__LINE__,__FILE__, EX_DATAERR,
					   &dcc_emsg,
					   "looping hash chain of "L_HxPAT
					   " at "L_HxPAT,
					   prev, loop_prev);
				DB_ERROR_MSG(dcc_emsg.c);
				if (!rcd_st0)
					free_db_st(rcd_st);
				return -1;
			}
			loop_prev = prev;

			found_ck = db_map_rcd_ck(&dcc_emsg, rcd_st, prev,
						 DCC_CK_SRVR_ID);
			if (!found_ck) {
				DB_ERROR_MSG2(str, dcc_emsg.c);
				if (!rcd_st0)
					free_db_st(rcd_st);
				return -1;
			}
		}
		break;
	case DB_FOUND_EMPTY:
	case DB_FOUND_CHAIN:
	case DB_FOUND_INTRUDER:
		break;
	}
	if (!rcd_st0)
		free_db_st(rcd_st);
	return 0;
}



/* find the database record of the type of a server */
int					/* -1=broken database 0=no record */
find_srvr_rcd_type(DCC_SRVR_ID tgt_id, DB_ST *rcd_st)
{
	DCC_SUM srvr_id_sum;
	int result;

	if (db_failed_line)
		return -1;
	DCC_ID_SRVR_TYPE_SET(&srvr_id_sum, tgt_id);
	result = find_srvr_rcd(&srvr_id_sum, DCC_ID_INVALID, 0,
			       "checking server-ID state", rcd_st);
	return result;
}



/* find the server type in the table of IDs from the local ids file */
ID_TBL *
find_srvr_type(DCC_SRVR_ID tgt_id)
{
	ID_TBL *tp;
	DCC_SRVR_ID srvr_type;
	DB_ST *rcd_st;

	tp = find_id_tbl(tgt_id, db_debug != 0);

	/* check the database if it is not in the table */
	if (!tp) {
		rcd_st = GET_DB_ST();
		if (0 >= find_srvr_rcd_type(tgt_id, rcd_st)) {
			/* assume it is a simple server if there is
			 * no declaration in the database */
			srvr_type = DCC_ID_SRVR_SIMPLE;
		} else {
			srvr_type = DB_RCD_ID(rcd_st->d.r);
			if (!DCC_ID_SRVR_TYPE(srvr_type))
				srvr_type = DCC_ID_SRVR_SIMPLE;
		}
		/* cache it in the table */
		tp = add_id_tbl(tgt_id, 0, db_debug != 0);
		tp->srvr_type = srvr_type;
		free_db_st(rcd_st);
	}
	return tp;
}



/* refresh our claim to our server-ID or add some other housekeeping record */
void
refresh_srvr_rcd(const DCC_SUM *sum, DCC_SRVR_ID id,
		 time_t old,		/* record must be newer than this */
		 time_t next,		/* when next record needed */
		 const char *str)
{
	DB_ST *rcd_st;
	DB_RCD new;
	int i;

	rcd_st = GET_DB_ST();

	/* set the timer if it is not set or too far in the future */
	if (host_id_next == 0 || host_id_next > next) {
		host_id_range = next - db_time.tv_sec;
		host_id_next = next;
	}

	/* add a new record if needed */
	i = find_srvr_rcd(sum, DCC_ID_INVALID, 0, str, rcd_st);
	if (i < 0) {
		free_db_st(rcd_st);
		return;			/* broken database */
	}
	if (i > 0
	    && old != 0
	    && DB_RCD_ID(rcd_st->d.r) == id
	    && ts2secs(&rcd_st->d.r->ts) > old) {
		free_db_st(rcd_st);
		return;
	}

	memset(&new, 0, sizeof(new));
	new_ts(&new.ts);
	new.srvr_id = id;
	DB_TGTS_RCD_SET(&new, 1);
	new.fgs_num_cks = 1;
	new.cks[0].type_fgs = DCC_CK_SRVR_ID;
	new.cks[0].sum = *sum;
	new.cks[0].prev = DB_PTR_CP(DB_PTR_BAD);
	if (!db_add_rcd(&dcc_emsg, &new, rcd_st))
		DB_ERROR_MSG2(str, dcc_emsg.c);

	free_db_st(rcd_st);
}



/* make a key for a DCC_ID_SRVR_DATE record */
void
date_rcd_ck(DCC_SUM *ck, time_t secs)
{
	int days, hours, minutes;

	memset(ck, 0, sizeof(DCC_SUM));

	secs %= ((DATE_RCD_RANGE_DAYS*24*60*60 + DATE_RCD_REP_SECS-1)
		  / DATE_RCD_REP_SECS) * DATE_RCD_REP_SECS;
	secs -= secs % DATE_RCD_REP_SECS;

	minutes = secs / 60;
	hours = minutes/60;
	minutes = minutes % 60;
	days = hours/24;
	hours = hours % 24;

	snprintf((char *)ck->b, sizeof(ck->b), DATE_RCD_PAT,
		 days, hours, minutes);
}



/* Find a DCC_ID_SRVR_DATE record.
 * These are timestamp records in the database.  When we are searching the
 * database for a normal record with a given timestamp TS,
 * then we know it cannot have been received and so could not be in the
 * database before a timestamp record at TS-MAX_FLOD_CLOCK_SKEW,
 * where MAX_FLOD_CLOCK_SKEW is the maximum clock error at the source of
 * the normal record.
 */
int					/* <0 if broken database */
find_date_rcd(time_t tgt_secs,
	      DB_ST *rcd_st)		/* put the record or garbage here */
{
	DCC_SUM sum;

	date_rcd_ck(&sum, tgt_secs);
	switch (db_lookup(&dcc_emsg, DCC_CK_SRVR_ID, &sum, 0, rcd_st, 0)) {
	case DB_FOUND_SYSERR:
		return -1;
	case DB_FOUND_IT:
		return 1;
	case DB_FOUND_EMPTY:
	case DB_FOUND_CHAIN:
	case DB_FOUND_INTRUDER:
		if (!complained_missing_date) {
			complained_missing_date = 1;
			dcc_trace_msg("missing %s date record", (char *)sum.b);
		}
		break;
	}
	return 0;
}



static void
send_resp(const QUEUE *q,
	  DCC_HDR *hdr,			/* length in host byte order */
	  u_char no_msg)
{
	u_int save_len;
	char ob[DCC_OPBUF];
	int len, i;

	len = hdr->len;
	hdr->len = htons(len);
	/* callers must have dealt with the variations due to versions */
	if (q->pkt.hdr.pkt_vers < DCC_PKT_VERS_MIN)
		hdr->pkt_vers = DCC_PKT_VERS_MIN;
	else if (q->pkt.hdr.pkt_vers > DCC_PKT_VERS_MAX)
		hdr->pkt_vers = DCC_PKT_VERS_MAX;
	else
		hdr->pkt_vers = q->pkt.hdr.pkt_vers;
	hdr->sender = htonl(my_srvr_id);
	hdr->op_nums = q->pkt.hdr.op_nums;
	if (q->passwd[0] != '\0') {
		/* sign with the password that authenticated the client */
		dcc_sign(q->passwd, sizeof(q->passwd), hdr, len);
#ifdef DCC_PKT_VERS8
	} else if (q->pkt.hdr.pkt_vers <= DCC_PKT_VERS8) {
		/* Sign old protocol responses with the client's transaction
		 * numbers if we do not have a good password.
		 * This happens with anonymous clients */
		dcc_sign((char *)&q->pkt.hdr.op_nums,
			 sizeof(q->pkt.hdr.op_nums),
			 hdr, len);
#endif
	} else {
		memset((char *)hdr + (len-sizeof(DCC_SIGNATURE)), 0,
		       sizeof(DCC_SIGNATURE));
	}

	if (q->ridc) {
		save_len = len-sizeof(*hdr)-sizeof(DCC_SIGNATURE);
		if (save_len > ISZ(q->ridc->d.result)) {
			if (hdr->op == DCC_OP_ERROR)
				save_len = sizeof(q->ridc->d.result);
			else
				dcc_logbad(EX_SOFTWARE, "RIDC buffer overflow");
		}
		q->ridc->d.len = save_len;
		memcpy(&q->ridc->d.result, hdr+1, save_len);
		q->ridc->d.op = hdr->op;
		q->ridc->d.bad = 0;
	}

	i = sendto(q->sp->udp, hdr, len, 0,
		   &q->clnt_su.sa, DCC_SU_LEN(&q->clnt_su));
	if (i < 0) {
		clnt_msg(q, "sendto(%s, %s): %s",
			 dcc_hdr_op2str(ob, sizeof(ob), hdr), Q_CIP(q),
			 ERROR_STR());
	} else if (len != i) {
		clnt_msg(q, "sendto(%s, %s)=%d instead of %d",
			 dcc_hdr_op2str(ob, sizeof(ob), hdr), Q_CIP(q),
			 i, len);
	} else if (!no_msg
		   && ((hdr->op == DCC_OP_ANSWER || hdr->op == DCC_OP_NOP)
		       ? TMSG_BIT(QUERY)
		       : TMSG_BIT(ADMN))) {
		   dcc_trace_msg("sent %s to %s for %s",
			      dcc_hdr_op2str(ob, sizeof(ob), hdr),
			      Q_CIP(q), qop2str(q));
	}
}



/* do not send an error response to a client */
static void DCC_PF(2,3)
forget_error(QUEUE *q, const char *p, ...)
{
	va_list args;

	RIDC_BAD(q);

	q->ip_rl->d.fgs |= RL_FG_DROPPED;
	if (q->block_rl)
		q->block_rl->d.fgs |= RL_FG_DROPPED;

	/* count it, but only once */
	if (!(q->flags & Q_FG_BAD_OP)) {
		q->flags |= Q_FG_BAD_OP;
		++dccd_stats.bad_op;
	}

	va_start(args, p);
	vclnt_msg(q, p, args);
	va_end(args);
}



/* send an error response to a client */
static void
send_error(const QUEUE *q, const char *p, ...)
{
	DCC_ERROR buf;
	int slen;
	va_list args;


	/* build and log the message */
	va_start(args, p);
	slen = vsnprintf(buf.msg, sizeof(buf.msg), p, args);
	if (slen > ISZ(buf.msg)-1)
		slen = ISZ(buf.msg)-1;
	va_end(args);
	clnt_msg(q, "\"%s\" sent to %s", buf.msg, Q_CIP(q));

	/* send it */
	buf.hdr.len = sizeof(buf)-sizeof(buf.msg)+slen+1;
	buf.hdr.op = DCC_OP_ERROR;
	send_resp(q, &buf.hdr, 1);

	++dccd_stats.send_error;
}



#define NORESP_EMSG(q) noresp_emsg(q, __LINE__)

static void
noresp_emsg(const QUEUE *q, int linenum)
{
	dcc_error_msg("error near line %d in "DCC_VERSION" "__FILE__, linenum);
	RIDC_BAD(q);
}



/* tell client that a NOP or an administrative request was ok */
static void
send_ok(QUEUE *q)
{
	DCC_OK buf;
	time_t us;

	memset(&buf, 0, sizeof(buf));

	buf.max_pkt_vers = max(min(q->pkt.hdr.pkt_vers, DCC_PKT_VERS_MAX),
			       DCC_PKT_VERS_MIN);
	us = (q->delay_us + 500) / 1000;
	buf.qdelay_ms = htons(us);
	strncpy(buf.brand, brand, sizeof(buf.brand));
	buf.hdr.op = DCC_OP_OK;
	buf.hdr.len = sizeof(buf);

	send_resp(q, &buf.hdr, 0);
}



static void
repeat_resp(QUEUE *q)
{
	struct {
	    DCC_HDR hdr;
	    u_char  b[sizeof(q->ridc->d.result)];
	} buf;
	char ob[DCC_OPBUF];

	++dccd_stats.report_retrans;

	if (q->ridc->d.bad) {
		TMSG1(RIDC, "repeat drop of %s", from_id_ip(q, 1));
		return;
	}

	memcpy(&buf.hdr+1, &q->ridc->d.result, q->ridc->d.len);
	buf.hdr.op = q->ridc->d.op;
	buf.hdr.len = htons(q->ridc->d.len
			    + sizeof(buf.hdr) + sizeof(DCC_SIGNATURE));
	TMSG2(RIDC, "repeat previous response of %s for %s",
	      dcc_hdr_op2str(ob, sizeof(ob), &buf.hdr),
	      from_id_ip(q, 1));
	buf.hdr.len = ntohs(buf.hdr.len);
	send_resp(q, &buf.hdr, 0);
}



/* find a checksum in the database */
static DCC_TGTS				/* total or DCC_TGTS_INVALID */
get_ck_tgts(DB_RCD_CK **pfound_ck,
	    DCC_CK_TYPES type,
	    const DCC_SUM *sum,
	    u_char must_have_it,	/* 1=database broken if cksum absent */
	    DB_ST *rcd_st)		/* the result */
{
	DB_RCD_CK *found_ck;

	if (!pfound_ck)
		pfound_ck = &found_ck;
	switch (db_lookup(&dcc_emsg, type, sum, 0, rcd_st, pfound_ck)) {
	case DB_FOUND_SYSERR:
		DB_ERROR_MSG(dcc_emsg.c);
		return DCC_TGTS_INVALID;
	case DB_FOUND_IT:
		return DB_TGTS_CK(*pfound_ck);
	case DB_FOUND_EMPTY:
	case DB_FOUND_CHAIN:
	case DB_FOUND_INTRUDER:
		if (must_have_it) {
			db_error_msg(__LINE__,__FILE__,
				     "missing hash entry for %s %s ",
				     DB_TYPE2STR(type),
				     ck2str_err(type, sum, 0));
			return DCC_TGTS_INVALID;
		}
		return 0;
	}
	return DCC_TGTS_INVALID;
}



/* see if a count just passed a multiple of a threshold and so is
 *	worth flooding or summarizing */
static u_char				/* 1=time to summarize this checksum */
quick_sum_thold(DCC_CK_TYPES type,
		DCC_TGTS rpt_tgts,	/* targets in this report */
		DCC_TGTS ck_tgts)	/* grand total */
{
	DCC_TGTS thold;
	DCC_TGTS new_mult, old_mult;

	thold = flod_tholds[type];
	if (ck_tgts < thold
	    || thold >= DCC_TGTS_TOO_MANY)
		return 0;
	if (thold == 0)
		return 1;

	/* Did the grand total pass a multiple of the bulk threshold? */
	new_mult = ck_tgts / thold;
	old_mult = (ck_tgts - rpt_tgts) / thold;
	if (old_mult == new_mult)
		return 0;

	/* The interesting multiples are
	 * 1, 2, 3, 5, 10, 20, 40, 100, 200, 300, ... */
	if (old_mult <= 2)		/* handle most common case */
		return 1;
	if (new_mult >= 100) {
		return old_mult/100 != new_mult/100;
	} else if (new_mult >= 40) {
		return old_mult < 40;
	} else if (new_mult >= 20) {
		return old_mult < 20;
	} else if (new_mult >= 10) {
		return old_mult < 10;
	} else if (new_mult >= 5) {
		return old_mult < 5;
	}
	return 0;
}



/* find previous value for a reputation or reputation total
 * despite adjustments */
static DCC_TGTS				/* grand total or DCC_TGTS_INVALID */
get_rep_tgts(DCC_TGTS *rpt_tgtsp,	/* count in last report */
	     DCC_CK_TYPES type,		/* DCC_CK_REP_{BULK,TOTAL} */
	     const DCC_SUM *sum,	/* look for this IP address */
	     DB_ST *rcd_st0)		/* 0 or result here */
{
	DB_ST *rcd_st;
	int limit;
	DB_RCD_CK *found_ck;
	DB_PTR prev;
	DCC_TGTS tgts, rpt_tgts;

	if (rpt_tgtsp)
		*rpt_tgtsp = 0;
	rcd_st = rcd_st0 ? rcd_st0 : GET_DB_ST();

	tgts = get_ck_tgts(&found_ck, type, sum, 0, rcd_st);
	if (tgts == DCC_TGTS_INVALID) {
		if (!rcd_st0)
			free_db_st(rcd_st);
		return DCC_TGTS_INVALID;
	}
	if (tgts == 0) {		/* quit if no record of checksum */
		if (!rcd_st0)
			free_db_st(rcd_st);
		return 0;
	}

	/* skip a few reputation adjustments */
	for (limit = 0; limit < 3; ++limit) {
		rpt_tgts = DB_TGTS_RCD_RAW(rcd_st->d.r);
		if (rpt_tgts != DCC_TGTS_REP_ADJ) {
			if (rpt_tgtsp)
				*rpt_tgtsp = rpt_tgts;
			if (!rcd_st0)
				free_db_st(rcd_st);
			return tgts;
		}
		prev = DB_PTR_EX(found_ck->prev);
		if (prev == DB_PTR_NULL) {
			if (!rcd_st0)
				free_db_st(rcd_st);
			return 0;
		}
		found_ck = db_map_rcd_ck(&dcc_emsg, rcd_st, prev, type);
		if (!found_ck) {
			DB_ERROR_MSG(dcc_emsg.c);
			if (!rcd_st0)
				free_db_st(rcd_st);
			return DCC_TGTS_INVALID;
		}
		tgts = DB_TGTS_CK(found_ck);
	}
	db_error_msg(__LINE__,__FILE__,
		     "%d consecutive rep adjustments", limit);
	if (!rcd_st0)
		free_db_st(rcd_st);
	return DCC_TGTS_INVALID;
}



/* See if a bulk reputation count is above its threshold for flooding
 * or if a total reputation is exculpatory. */
static int				/* -1=broken database, 1=above thold */
rep_sum_thold(u_char dly,		/* 1=working on delayed record */
	      const DCC_SUM *sum,
	      DCC_TGTS bulk,		/* bulk reputation including latest */
	      DCC_TGTS bulk_rpt,	/* change by latest report */
	      DCC_TGTS total,		/* total reputation including latest */
	      DCC_TGTS total_rpt)
{
	u_int old, new;

	/* Local reputation thresholds matter little for flooding, except
	 * perhaps to make less busy servers flood reports of evil based on
	 * less evidence.  The goal is have all servers agree about the
	 * reputation of an IP addresse.  We need to flood
	 *	if the reputation is not zero
	 *	or if the total is large enough to be exculpatory
	 *
	 * Always flood periodic summaries of delayed data if it is non-trivial
	 * to keep all servers consistent.  Delayed data that is not
	 * summarized and flooded is lost.
	 *
	 * Flood new reports if they significant change things */

	if (dly) {
		/* flood delayed summaries of enough evidence of evil */
		if (bulk != DCC_TGTS_INVALID
		    && bulk >= DCC_REP_TGTS_BULK_SIGNIF)
			return 1;
		/* flood delayed exculatory evidence */
		if (total != DCC_TGTS_INVALID
		    && total >= DCC_REP_TGTS_TOTAL_SIGNIF)
			return 1;
	} else {
		/* do not flood until we have real data */
		if (total != DCC_TGTS_INVALID
		    && total < DCC_REP_TGTS_TOTAL_MIN)
		return 0;
	}

	/* Fetch current values if we don't have them */
	if (bulk == DCC_TGTS_INVALID
	    || bulk_rpt == DCC_TGTS_INVALID) {
		bulk = get_rep_tgts(bulk_rpt == DCC_TGTS_INVALID
				    ? &bulk_rpt : 0,
				    DCC_CK_REP_BULK, sum, 0);
		if (bulk == DCC_TGTS_INVALID)
			return -1;	/* broken database */
	}
	if (dly && bulk >= DCC_REP_TGTS_BULK_SIGNIF)
		return 1;

	if (total == DCC_TGTS_INVALID
	    || total_rpt == DCC_TGTS_INVALID) {
		total = get_rep_tgts(total_rpt == DCC_TGTS_INVALID
				     ? &total_rpt : 0,
				     DCC_CK_REP_TOTAL, sum, 0);
		if (total == DCC_TGTS_INVALID)
			return -1;	/* broken database */
	}
	if (dly) {
		if (total >= DCC_REP_TGTS_TOTAL_SIGNIF)
			return 1;
		/* flooding of summaries of delayed data depends on
		 * the current values and not how much they have changed */
		return 0;
	}

	/* do not flood until we have real data */
	if (total < DCC_REP_TGTS_TOTAL_MIN)
		return 0;

	/* flash flood when the reputation changes by 5% */
	old = get_reputation(bulk - bulk_rpt, total - total_rpt);
	new = get_reputation(bulk, total);
	if (new >= old + 5 || new + 5 <= old)
		return 1;
	return 0;
}



/* compute summarizable total for one checksum */
static DCC_TGTS				/* delta or DCC_TGTS_INVALID */
sum_total(DCC_CK_TYPES type,		/* look for this */
	  const DCC_SUM *sum,
	  u_char must_have_it,		/* 1=database broken if cksum absent */
	  DCC_TGTS *total,		/* total including summarizable delta */
	  DB_PTR *oldestp,		/* records included */
	  DB_PTR *newestp)
{
	DB_ST *rcd_st;
	DB_PTR newest, prev, loop_prev;
	DB_RCD_CK *oldest_ck;
	DCC_TGTS rcd_tgts, delta;
	int i;

	if (total)
		*total = 0;
	if (newestp)
		*newestp = DB_PTR_NULL;
	if (oldestp)
		*oldestp = DB_PTR_NULL;
	rcd_st = GET_DB_ST();

	rcd_tgts = get_ck_tgts(&oldest_ck, type, sum, must_have_it, rcd_st);
	if (rcd_tgts == DCC_TGTS_INVALID) {
		free_db_st(rcd_st);
		return DCC_TGTS_INVALID;    /* broken database */
	}
	if (rcd_tgts == 0) {
		free_db_st(rcd_st);
		return 0;
	}

	newest = rcd_st->s.rptr;

	delta = 0;
	loop_prev = DB_PTR_MAX+1;
	for (;;) {
		/* stop combining records at the first summary */
		if (DB_RCD_SUMRY(rcd_st->d.r))
			break;

		/* honor deletions */
		rcd_tgts = DB_TGTS_RCD(rcd_st->d.r);
		if (rcd_tgts == 0)
			break;

		/* We can summarize only our own delayed reports
		 * to prevent loops in the flooding topology from
		 * inflating totals. */
		if (DB_RCD_ID(rcd_st->d.r) == my_srvr_id) {
			/* Stop at the first record of our own for the
			 * checksum that was not delayed.  We always
			 * start to add our own records marked to be
			 * delayed.  If they are important enough, we
			 * generate a summary record, which often just
			 * turns off the bit */
			if (!DB_RCD_DELAY(rcd_st->d.r))
				break;

			if (newestp) {
				*newestp = newest;
				newestp = 0;
			}
			if (oldestp)
				*oldestp = rcd_st->s.rptr;
			if (rcd_tgts == DCC_TGTS_TOO_MANY) {
				delta = DCC_TGTS_TOO_MANY;
				if (total)
					*total = DCC_TGTS_TOO_MANY;
			} else {
				delta += rcd_tgts;
				if (total)
					*total = (DB_TGTS_CK(oldest_ck)
						  - rcd_tgts
						  + delta);
			}
		}

		/* A spam report will have made all previous non-spam reports
		 * of this checksum into junk when the spam report was added
		 * to the database. */
		if (rcd_tgts == DCC_TGTS_TOO_MANY)
			break;

		prev = DB_PTR_EX(oldest_ck->prev);
		if (prev == DB_PTR_NULL)
			break;
		if (DB_PTR_IS_BAD(prev, loop_prev)) {
			db_failure(__LINE__,__FILE__, EX_DATAERR, &dcc_emsg,
				   "looping hash chain of "L_HxPAT" at "L_HxPAT,
				   prev, loop_prev);
			DB_ERROR_MSG(dcc_emsg.c);
			free_db_st(rcd_st);
			return DCC_TGTS_INVALID;
		}
		loop_prev = prev;

		/* stop at the oldest record we might care about */
		if (summarize_limit_secs < db_time.tv_sec - (24*60*60+60*60)) {
			summarize_limit_secs = (db_time.tv_sec
						- DCC_OLD_SPAM_SECS);
#if DATE_RCD_RANGE_DAYS <= 1
#error "date rcd range too small"
#endif
			i = find_date_rcd(summarize_limit_secs, rcd_st);
			if (i < 0) {
				DB_ERROR_MSG(dcc_emsg.c);
				free_db_st(rcd_st);
				return DCC_TGTS_INVALID;
			}
			if (i > 0)
				summarize_limit = rcd_st->s.rptr;
		}
		if (prev <= summarize_limit)
			break;

		oldest_ck = db_map_rcd_ck(&dcc_emsg, rcd_st, prev, type);
		if (!oldest_ck) {
			DB_ERROR_MSG(dcc_emsg.c);
			free_db_st(rcd_st);
			return DCC_TGTS_INVALID;
		}
	}

	free_db_st(rcd_st);
	return delta;
}



/* We have already summarized one of the pair of reputation checksums
 *	named by 1 or 2 checksums.  We must summarize both,
 *	even if only one is the original record to protect their ratio.
 * The database must be locked. */
static u_char				/* 0=broken database */
summarize_rep(const DB_RCD_CK *rep_ck)
{
	DB_RCD new;
	DCC_TGTS total_delta, bulk_delta;
	DB_RCD_CK *new_ck;

	new.fgs_num_cks = DB_RCD_FG_SUMRY | 0;
	new_ck = new.cks;

	total_delta = sum_total(DCC_CK_REP_TOTAL, &rep_ck->sum, 0, 0, 0, 0);
	if (total_delta != 0) {
		if (total_delta == DCC_TGTS_INVALID)
			return 0;	/* broken database */
		DB_TGTS_RCD_SET(&new, total_delta);
		++new.fgs_num_cks;
		new_ck->type_fgs = DCC_CK_REP_TOTAL;
		new_ck->sum = rep_ck->sum;
		new_ck->prev = DB_PTR_CP(DB_PTR_BAD);
		++new_ck;
	}

	bulk_delta = sum_total(DCC_CK_REP_BULK, &rep_ck->sum, 0, 0, 0, 0);
	if (bulk_delta != 0) {
		if (bulk_delta == DCC_TGTS_INVALID)
			return 0;	/* broken database */
		/* use one record if the values are the same
		 * but two records if they differ */
		if (bulk_delta != total_delta && total_delta != 0) {
			new.srvr_id = my_srvr_id;
			new_ts(&new.ts);
			if (!db_add_rcd(&dcc_emsg, &new, 0)) {
				DB_ERROR_MSG(dcc_emsg.c);
				return 0;
			}
			/* start another new record */
			new.fgs_num_cks = DB_RCD_FG_SUMRY | 0;
			new_ck = new.cks;
		}
		DB_TGTS_RCD_SET(&new, bulk_delta);
		++new.fgs_num_cks;
		new_ck->type_fgs = DCC_CK_REP_BULK;
		new_ck->sum = rep_ck->sum;
		new_ck->prev = DB_PTR_CP(DB_PTR_BAD);
		++new_ck;
	}

	if (new_ck != new.cks) {
		new.srvr_id = my_srvr_id;
		new_ts(&new.ts);
		if (!db_add_rcd(&dcc_emsg, &new, 0)) {
			DB_ERROR_MSG(dcc_emsg.c);
			return 0;
		}
	}

	return 1;
}



/* how many reputation checksums end a report? */
static int
count_rep(const DB_RCD *new)
{
	const DB_RCD_CK *new_ck;
	DCC_CK_TYPES type;

	new_ck = &new->cks[DB_NUM_CKS(new)-1];
	type = DB_CK_TYPE(new_ck);
	if (!DCC_CK_IS_REP(grey_on, type))
		return 0;		/* none */

	if (new_ck == new->cks)
		return 1;		/* only one checksum in the report */
	--new_ck;
	type = DB_CK_TYPE(new_ck);
	if (DCC_CK_IS_REP(grey_on, type))
		return 2;
	return 1;
}



/* generate a summary record of checksum counts
 *	On entry sumrcd_st points to the record whose checksums are
 *	    being summarized.  It might be an incoming flooded record that
 *	    will not be part of the summary.
 *	On exit sumrcd_st points to the same record or the original
 *	    has been trashed and sumrcd_st points to a moved copy. */
static u_char				/* 0=sick db, 1=ok, 2=moved rcd */
summarize_rcd(DB_ST *sumrcd_st,
	      u_char dly)		/* 1=working on delayed records */
{
	DB_RCD new;
	DCC_TGTS rcd_tgts, new_tgts;
	DCC_TGTS tgts_total, tgts_delta;
	DCC_CK_TYPES type;
	DB_RCD_CK *cur_ck, *new_ck;
	int cur_num_cks;
	u_char rcd_needed;		/* 1=have created rcd to add */
	u_char move_ok;
	DB_PTR delay_ptr;
	DB_PTR rcd_pos;
	int rep_needed = -1;		/* 0=rep cksums unneeded, 1=needed */
	int rep_sumd = 0;
	const DB_RCD_CK *rep_ck = 0;

	if (db_lock() < 0)
		return 0;

	/* For each checksum whose flooding was delayed but is now needed,
	 * generate a fake record that will be flooded */
	cur_num_cks = DB_NUM_CKS(sumrcd_st->d.r);
	cur_ck = sumrcd_st->d.r->cks;
	new_tgts = 0;
	move_ok = 1;
	delay_ptr = DB_PTR_NULL;
	rcd_needed = 0;
	new_ck = new.cks;
	do {
		DB_PTR newest_ptr, oldest_ptr;
		u_char ck_needed;	/* 0=unneeded, 1=unsure, 2=needed */

		/* exclude this checksum if it is junk */
		type = DB_CK_TYPE(cur_ck);
		if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type))
			continue;

		if (DCC_CK_IS_REP(grey_on, type))
			rep_ck = cur_ck;
		ck_needed = !DB_CK_JUNK(cur_ck);

		/* Sum counts of delayed reports for this checksum */
		tgts_delta = sum_total(type, &cur_ck->sum, 1, &tgts_total,
				       &oldest_ptr, &newest_ptr);
		if (tgts_delta == DCC_TGTS_INVALID)
			return 0;	/* broken database */
		if (delay_ptr == DB_PTR_NULL)
			delay_ptr = newest_ptr;

		/* Deletions and summaries between our record and the head
		 * of the hash chain imply we should not flood this checksum. */
		if (tgts_delta == 0) {
			move_ok = 0;
			continue;
		}

		/* we cannot do the job by simply moving or un-delaying
		 * a single record if we summarize more than one record */
		if (newest_ptr != oldest_ptr
		    || newest_ptr != delay_ptr)
			move_ok = 0;

		if (ck_needed == 1) {
			/* investigate, because we are not sure if we should
			 * included or exclude this checksum */
			if (DCC_CK_IS_REP(grey_on, type)) {
				if (rep_needed < 0) {
					/* 1 per delay period */
					if (dly
					    && flod_mmaps != 0
					    && (oldest_ptr
						> flod_mmaps->delay_pos)) {
					    rep_needed = 1;
					} else {
					    DCC_TGTS bulk, bulk_rpt;
					    DCC_TGTS total, total_rpt;

					    /* We do this only once
					     * and the total checksum always
					     * precedes the bulk checksum.
					     * If we hit the bulk checksum,
					     * we know there was no total
					     * checksum and so the total delta
					     * is 0.
					     * If we hit the total checksum,
					     * then the bulk checksum is either
					     * next or absent */
					    if (DCC_CK_IS_REP_BULK(grey_on,
							type)) {
						bulk = tgts_total;
						bulk_rpt = tgts_delta;
						total = DCC_TGTS_INVALID;
						total_rpt = 0;
					    } else {
						total = tgts_total;
						total_rpt = tgts_delta;
						bulk = DCC_TGTS_INVALID;
						if (cur_num_cks <= 1
						    || (!DCC_CK_IS_REP_BULK(
							grey_on,
							DB_CK_TYPE(cur_ck+1))))
						    bulk_rpt = 0;
						else
						    bulk_rpt = tgts_delta;
					    }
					    rep_needed = rep_sum_thold(dly,
							&cur_ck->sum,
							bulk, bulk_rpt,
							total, total_rpt);
					}
					if (rep_needed < 0)
					    return 0;	/* broken database */
				}
				if (rep_needed)
					ck_needed = 2;

			} else if (dly) {
				/* 1 worthwhile summary per delay period */
				if ((flod_mmaps == 0
				     || oldest_ptr <= flod_mmaps->delay_pos)
				    && tgts_total >= flod_tholds[type])
					ck_needed = 2;
			} else {
				/* We are considering the need for a summary
				 * based on a report just received from a client
				 * or by flooding */
				if (quick_sum_thold(type,
						    tgts_delta, tgts_total))
					ck_needed = 2;
			}
		}

		if (new_ck != new.cks) {
			/* We have already begun a summary record. */

			if (tgts_delta == new_tgts) {
				/* extend it with this checksum even if we do
				 * not really need to flood this checksum */
				new_ck->type_fgs = type;
				new_ck->sum = cur_ck->sum;
				new_ck->prev = DB_PTR_CP(DB_PTR_BAD);
				++new.fgs_num_cks;
				++new_ck;
				if (ck_needed == 2)
					rcd_needed = 1;
				continue;
			}
			/* We cannot extend the current summary record
			 * with this checksum. */

			/* Forget this checksum if we don't really need it.
			 * Maybe we will be able to extend the current record
			 * with the next checksum or maybe we will run out
			 * checksums to summarize. */
			if (ck_needed != 2)
				continue;

			/* Add the current summary record to the database if
			 * it is needed. */
			if (rcd_needed) {
				if (!db_add_rcd(&dcc_emsg, &new, 0)) {
					DB_ERROR_MSG(dcc_emsg.c);
					return 0;
				}
				/* track # of reputation types summarized */
				rep_sumd += count_rep(&new);
			}

			/* start a new summary record with this checksum. */
			rcd_needed = 0;
			/* having added one summary record,
			 * we cannot use the un-delay or move shortcuts */
			move_ok = 0;
		}

		/* start a new summary record */
		new.srvr_id = my_srvr_id;
		new_ts(&new.ts);
		new_tgts = tgts_delta;
		DB_TGTS_RCD_SET(&new, new_tgts);
		new.fgs_num_cks = DB_RCD_FG_SUMRY | 1;
		new_ck = new.cks;
		new_ck->type_fgs = type;
		new_ck->sum = cur_ck->sum;
		new_ck->prev = DB_PTR_CP(DB_PTR_BAD);
		++new_ck;
		if (ck_needed == 2)
			rcd_needed = 1;
	} while (++cur_ck, --cur_num_cks > 0);

	/* finished if nothing more to summarize */
	if (!rcd_needed) {
		/* summarize other flavor of reputation */
		if (rep_sumd == 1)
			return summarize_rep(rep_ck);
		return 1;
	}

	/* Add the last summary record */
	if (move_ok) {
		/* This last summary record is the first and should
		 * be identical to a single old, delayed record.
		 *
		 * If possible, instead of adding a new record,
		 * change the original record to not be delayed
		 * Un-delaying is only possible if the original record
		 * has not been passed by any of the floods. */
		if (delay_ptr >= oflods_max_cur_pos
		    && oflods_max_cur_pos != DB_PTR_NULL) {
			sumrcd_st->d.r->fgs_num_cks &= ~DB_RCD_FG_DELAY;
			DIRTY_RCD(sumrcd_st, 1);
			/* summarize other flavor of reputation */
			rep_sumd += count_rep(sumrcd_st->d.r);
			if (rep_sumd == 1)
				return summarize_rep(rep_ck);
			return 1;
		}

		/* if we cannot un-delay the record, then move it by adding
		 * a new copy and deleting the original */
		memcpy(&new, sumrcd_st->d.r, DB_RCD_LEN(sumrcd_st->d.r));
		new.fgs_num_cks &= ~DB_RCD_FG_DELAY;

		/* delete the old record */
		DB_TGTS_RCD_SET(sumrcd_st->d.r, 0);
		sumrcd_st->d.r->fgs_num_cks &= ~DB_RCD_FG_DELAY;
		/* adjust the totals in the old record so
		 * that the totals in the new record will be right */
		rcd_tgts = DB_TGTS_RCD(&new);
		cur_num_cks = DB_NUM_CKS(sumrcd_st->d.r);
		cur_ck = sumrcd_st->d.r->cks;
		do {
			DCC_TGTS cur_tgts = DB_TGTS_CK(cur_ck);
			if (cur_tgts >= DCC_TGTS_TOO_MANY
			    || cur_tgts == 0)
				continue;
			cur_tgts -= rcd_tgts;
			DB_TGTS_CK_SET(cur_ck, cur_tgts);
		}  while (++cur_ck, --cur_num_cks > 0);
		DIRTY_RCD(sumrcd_st, 1);

		/* add the new record to the database */
		rcd_pos = db_add_rcd(&dcc_emsg, &new, sumrcd_st);
		if (rcd_pos == DB_PTR_NULL) {
			DB_ERROR_MSG(dcc_emsg.c);
			return 0;
		}

		/* summarize other flavor of reputation */
		rep_sumd += count_rep(&new);
		if (rep_sumd == 1)
			return summarize_rep(rep_ck);

		return 1;
	}

	/* no short cut is possible, so just add the record */
	if (!db_add_rcd(&dcc_emsg, &new, sumrcd_st)) {
		DB_ERROR_MSG(dcc_emsg.c);
		return 0;
	}

	/* summarize other flavor of reputation */
	rep_sumd += count_rep(&new);
	if (rep_sumd == 1)
		return summarize_rep(rep_ck);

	return 1;
}



/* generate a delayed summary for checksums in a record if necessary */
u_char					/* 0=broken database */
summarize_dly(DB_ST *sumrcd_st)		/* summarize this; might change ptr */
{
	DB_ST *rcd2_st;
	DCC_CK_TYPES type;
	const DB_RCD_CK *cur_ck;
	int cur_num_cks;
	DCC_TGTS ck_tgts;
	const DB_RCD_CK *rep_ck = 0;
	DCC_TGTS total_tgts = DCC_TGTS_INVALID;
	DCC_TGTS bulk_tgts = DCC_TGTS_INVALID;

	rcd2_st = GET_DB_ST();

	/* look for a checksum that could be summarized */
	cur_num_cks = DB_NUM_CKS(sumrcd_st->d.r);
	cur_ck = sumrcd_st->d.r->cks;
	do {
		/* junk does not matter */
		type = DB_CK_TYPE(cur_ck);
		if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type))
			continue;

		/* nothing to do if the checksum has already been summarized */
		ck_tgts = get_ck_tgts(0, type, &cur_ck->sum, 1, rcd2_st);
		if (ck_tgts == DCC_TGTS_INVALID) {
			free_db_st(rcd2_st);
			return 0;
		}
		if (DB_RCD_SUMRY(rcd2_st->d.r))
			continue;

		/* spam reports are ignored or not delayed */
		if (ck_tgts == DCC_TGTS_TOO_MANY)
			continue;

		/* Generate a summary for a bulk checksum
		 * Records that are marked "delayed" are not flooded.
		 * If a summary record is not synthesized and if the delay
		 * marking not removed (instead of synthesizing a summary),
		 * then the counts for a checksum will not be flooded. */

		/* Summarize and so flood reputations if there is
		 * evidence of evil
		 * Postpone the decision until we are are sure we have
		 * seen both reputation checksums.  Either can be missing,
		 * but if both are present, waiting removes the need to
		 * look up one or the other to make the decision */
		if (DCC_CK_IS_REP_TOTAL(grey_on, type)) {
			total_tgts = ck_tgts;
			rep_ck = cur_ck;
			continue;
		}
		if (DCC_CK_IS_REP_BULK(grey_on, type)) {
			bulk_tgts = ck_tgts;
			rep_ck = cur_ck;
			continue;
		}

		/* summarize the whole record as soon as we find an interesting
		 * ckecksum */
		if (ck_tgts >= flod_tholds[type]) {
			free_db_st(rcd2_st);
			return summarize_rcd(sumrcd_st, 1);
		}
	}  while (++cur_ck, --cur_num_cks > 0);
	free_db_st(rcd2_st);

	if (rep_ck) {
		int rep_sum = rep_sum_thold(1, &rep_ck->sum,
					    bulk_tgts, 0, total_tgts, 0);
		if (rep_sum) {
			if (rep_sum < 0)
				return 0;
			return summarize_rcd(sumrcd_st, 1);
		}
	}

	return 1;
}



/* See if passing on a flooded report would be worthwhile.  It is worthwhile
 *	to pass on reports of spam that have not been flooded recently
 *	and of checksums that not yet or just barely reached spam. */
static u_char				/* 0=sick database */
flod_worth(u_char *pflod,		/* set =1 if report should be flooded */
	   const DB_RCD_CK *ck,		/* checksum in the new record */
	   const DCC_CK_TYPES type)
{
	DB_ST *tmp_st;
	DCC_TGTS total;
	int limit;
	DB_PTR delay_pos, prev;

	/* If the total with the new, incoming flooded report is small but
	 * not trivial, then we should flood it out. */
	total = DB_TGTS_CK(ck);
	if (total < REFLOOD_THRESHOLD) {
		/* our neighbors should not flood trivial reports,
		 * but bugs happen */
		if (total >= BULK_THRESHOLD/2)
			*pflod = 1;
		return 1;
	}

	tmp_st = GET_DB_ST();

	/* Look for a recent report for this checksum that has been
	 * or will be flooded.  If we find one, and if the total
	 * including it is large enough, we may not need to flood
	 * the incoming report.  If the total is too small, we
	 * must flood the report. */
	delay_pos = !flod_mmaps ? 0 : flod_mmaps->delay_pos;
	for (limit = 20; limit >= 0; --limit) {
		prev = DB_PTR_EX(ck->prev);
		if (prev == DB_PTR_NULL || prev < delay_pos)
			break;
		ck = db_map_rcd_ck(&dcc_emsg, tmp_st, prev, type);
		if (!ck) {
			DB_ERROR_MSG(dcc_emsg.c);
			free_db_st(tmp_st);
			return 0;
		}

		/* if the previous total was small,
		 * then we must flood the new report */
		if (DB_TGTS_CK(ck) < REFLOOD_SMALL_THRESHOLD) {
			*pflod = 1;
			free_db_st(tmp_st);
			return 1;
		}

		/* The old total is large.
		 * If this found old report is not very old and good,
		 * we will flood it and so the newest needed not be flooded
		 * and can be marked obsolete. */
		if (!DB_CK_JUNK(ck)
		    && DB_RCD_ID(tmp_st->d.r) != DCC_ID_COMP) {
			free_db_st(tmp_st);
			return 1;
		}
	}

	free_db_st(tmp_st);

	/* flood this one if we can't find a recent preceding report */
	*pflod = 1;
	return 1;
}



/* The database must be locked. */
static u_char
add_rep_adj(const DCC_SUM *sum)
{
	DB_RCD adj_rcd;

	memset(&adj_rcd, 0, sizeof(adj_rcd));
	new_ts(&adj_rcd.ts);
	DB_TGTS_RCD_SET(&adj_rcd, DCC_TGTS_REP_ADJ);
	adj_rcd.srvr_id = my_srvr_id;
	adj_rcd.fgs_num_cks = 2;
	adj_rcd.cks[0].type_fgs = DCC_CK_REP_TOTAL;
	adj_rcd.cks[0].sum = *sum;
	adj_rcd.cks[1].type_fgs = DCC_CK_REP_BULK;
	adj_rcd.cks[1].sum = *sum;

	if (!db_add_rcd(&dcc_emsg, &adj_rcd, 0)) {
		DB_ERROR_MSG2("add rep adjustment", dcc_emsg.c);
		return 0;
	}

	return 1;
}



/* Add a record and deal with delaying its flooding.
 *	We will delay flooding it if its totals are not interesting.
 *	The database must be locked */
u_char					/* 1=ok, delayed or not, 0=failure */
add_dly_rcd(DB_RCD *new,
	    u_char flod_in,		/* 1=flooded in */
	    DB_ST *new_st0)		/* 0 or the new record on exit */
{
	DB_ST *new_st;
	DB_PTR rcd_pos;
	int num_cks;
	DB_RCD_CK *new_ck;
	DCC_CK_TYPES type;
	DCC_TGTS rpt_tgts, ck_tgts;
	u_char flod_out;		/* 1=worth flooding out */
	u_char keeper = 0;		/* 1=worth delaying */
	u_char summarize = 0;
	const DB_RCD_CK *rep_ck = 0;
	u_char need_rep_adj = 0;
	DCC_TGTS total_tgts = DCC_TGTS_INVALID;
	DCC_TGTS total_rpt_tgts = 0;
	DCC_TGTS bulk_tgts = DCC_TGTS_INVALID;
	DCC_TGTS bulk_rpt_tgts = 0;

	new_st = new_st0 ? new_st0 : GET_DB_ST();

	/* put the record in the database */
	rcd_pos = db_add_rcd(&dcc_emsg, new, new_st);
	if (rcd_pos == DB_PTR_NULL) {
		DB_ERROR_MSG(dcc_emsg.c);
		if (!new_st0)
			free_db_st(new_st);
		return 0;
	}

	/* delete requests should not be delayed */
	rpt_tgts = DB_TGTS_RCD_RAW(new_st->d.r);
	if (rpt_tgts == DCC_TGTS_DEL) {
		if (!new_st0)
			free_db_st(new_st);
		return 1;
	}

	/* We always consider flooding our own reports
	 * and the greylist thresholds are zilch.
	 * Always flood big reports. */
	flod_out = !flod_in || grey_on || rpt_tgts >= REFLOOD_THRESHOLD;

	for (num_cks = DB_NUM_CKS(new_st->d.r),
	     new_ck = new_st->d.r->cks;
	     num_cks > 0;
	     ++new_ck, --num_cks) {
		/* ingore already obsolete reports */
		if (DB_CK_JUNK(new_ck))
			continue;
		/* ignore checksums we won't keep and so won't be flooded */
		type = DB_CK_TYPE(new_ck);
		if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type))
			continue;

		/* Server-ID declarations cannot be summarized and should
		 * not be delayed. */
		if (type == DCC_CK_SRVR_ID) {
			flod_out = 1;
			break;
		}

		ck_tgts = DB_TGTS_CK(new_ck);
		if (ck_tgts == DCC_TGTS_TOO_MANY) {
			/* This checksum has a total of TOO_MANY and so
			 * either the report has a target count of TOO_MANY
			 * or is a report of a checksum already known to
			 * be spam.  Since this report of this checksum
			 * was not marked obsolete as it was linked into the
			 * database, it should not be delayed.  */
			if (rpt_tgts == DCC_TGTS_TOO_MANY) {
				/* if the report is of spam, then all of its
				 * individual checksum totals will be
				 * DCC_TGTS_TOO_MANY.  The checksums will be
				 * obsolete, not kept, or the same as this.
				 * There will be no reputation checksums. */
				if (!new_st0)
					free_db_st(new_st);
				return 1;
			}
			/* it is worth sending on even if was not ours */
			flod_out = 1;
			continue;
		}

		/* This report has some potential value and should be delayed
		 * instead of forgotten */
		keeper = 1;

		if (DCC_CK_IS_REP(grey_on, type)) {
			rep_ck = new_ck;

			/* adjust the reputation counts (after we have
			 * finished comparing counts) to prevent overflow */
			if (ck_tgts >= DCC_REP_TGTS_ADJ_LIMIT) {
				need_rep_adj = 1;
				summarize = 1;
			}

			/* relay all reputations that flood in */
			flod_out = 1;

			if (type == DCC_CK_REP_TOTAL) {
				total_tgts = ck_tgts;
				total_rpt_tgts = rpt_tgts;
			} else {
				bulk_tgts = ck_tgts;
				bulk_rpt_tgts = rpt_tgts;
			}
			continue;
		}

		/* Summarize our records for the checksums in this record
		 * if we just passed the threshold for one checksum. */
		if (!summarize && !flod_in
		    && quick_sum_thold(type, rpt_tgts, ck_tgts)) {
			summarize = 1;
			flod_out = 1;
		}

		/* If this is an incoming flooded checksum,
		 * then pass it on if it is novel (has a low total)
		 * or if we have not passed it on recently. */
		if (!flod_out && !flod_worth(&flod_out, new_ck, type)) {
			if (!new_st0)
				free_db_st(new_st);
			return 0;	/* broken database */
		}
	}

	if (!summarize && !flod_in  && rep_ck) {
		/* Summarize and flood our delayed data
		 * if this report changed a reputation significantly */
		int rep_sum = rep_sum_thold(0, &rep_ck->sum,
					    bulk_tgts, bulk_rpt_tgts,
					    total_tgts, total_rpt_tgts);
		if (rep_sum) {
			if (rep_sum < 0) {
				if (!new_st0)
					free_db_st(new_st);
				return 0;
			}
			summarize = 1;
		}
	}

	/* Reports of spam or that are "trimmed" or "obsolete" noise
	 * should not be summarized or marked to be delayed.
	 * They will be flooded or skipped by the flooder */
	if (!keeper) {
		if (!new_st0)
			free_db_st(new_st);
		return 1;
	}

	if (!flod_in) {
		/* Delay and eventually summarize our own reports of non-spam.
		 * If this report is significant, we will have decided to
		 * summarize any older, delayed reports with it.  If it
		 * is alone, it will be converted and not delayed. */
		new_st->d.r->fgs_num_cks |= DB_RCD_FG_DELAY;
		DIRTY_RCD(new_st, 1);

	} else if (!flod_out) {
		/* We are dealing with a report flooded in from another
		 * server that is not (yet?) worth flooding out.
		 * We can't delay it, because we can't delay reports from
		 * other servers, because we cannot summarize them.
		 * Summarizing other servers' reports would allow
		 * loops in the flooding topology to inflate the totals.
		 * So mark it to be expired but not delayed. */
		for (num_cks = DB_NUM_CKS(new_st->d.r),
		     new_ck = new_st->d.r->cks;
		     num_cks > 0;
		     ++new_ck, --num_cks) {
			new_ck->type_fgs |= DB_CK_FG_JUNK;
		}
		DIRTY_RCD(new_st, 1);
	}

	if (summarize) {
		/* This record pushed us past a threshold for a checksum.
		 * Generate a summary of our own delayed reports even if
		 * this report was flooded in. */
		if (!summarize_rcd(new_st, 0)) {
			if (!new_st0)
				free_db_st(new_st);
			return 0;
		}
	}

	/* if necessary add a record to trim reputation values
	 * and prevent overflow */
	if (need_rep_adj) {
		if (!add_rep_adj(&rep_ck->sum)) {
			if (!new_st0)
				free_db_st(new_st);
			return 0;
		}
	}

	if (!new_st0)
		free_db_st(new_st);
	return 1;
}



/* the database must be locked */
static u_char
add_del(const DCC_CK *del_ck, QUEUE *q)
{
	DB_RCD del_rcd;

	memset(&del_rcd, 0, sizeof(del_rcd));
	use_ts(&del_rcd.ts, q);
	DB_TGTS_RCD_SET(&del_rcd, DCC_TGTS_DEL);
	del_rcd.srvr_id = my_srvr_id;
	del_rcd.fgs_num_cks = 1;
	del_rcd.cks[0].type_fgs = del_ck->type;
	del_rcd.cks[0].sum = del_ck->sum;
	if (!db_add_rcd(&dcc_emsg, &del_rcd, 0)) {
		DB_ERROR_MSG2("add delete", dcc_emsg.c);
		return 0;
	}

	return 1;
}



static const DCC_CK *
start_work(QUEUE *q)
{
	const DCC_CK *ck, *ck_lim;
	DCC_CK_TYPES type, prev_type;
	int num_cks;
	u_char no_rep_complained;

	num_cks = q->pkt_len - (sizeof(q->pkt.r) - sizeof(q->pkt.r.cks));
	if (num_cks < 0
	    || num_cks > ISZ(q->pkt.r.cks)
	    || num_cks % sizeof(DCC_CK) != 0) {
		forget_error(q, "packet length %d wrong for %s",
			     q->pkt_len, from_id_ip(q, 1));
		return 0;
	}
	num_cks /= sizeof(DCC_CK);

	/* send previous response if this is a retransmission */
	if (ridc_get(q)) {
		repeat_resp(q);
		return 0;
	}

	if (db_failed_line)		/* Silent while the database is bad */
		return 0;

	ck = q->pkt.r.cks;
	ck_lim = &q->pkt.r.cks[num_cks];

	/* check each checksum */
	no_rep_complained = 0;
	for (prev_type = DCC_CK_INVALID; ck < ck_lim; ++ck, prev_type = type) {
		if (ck->len != sizeof(*ck)) {
			forget_error(q, "unknown checksum length %d%s",
				     ck->len, from_id_ip(q, 0));
			return 0;
		}
		/* requiring that the checksums be ordered makes it easy
		 * to check for duplicates and for bogus long packets */
		type = ck->type;
		if (!DCC_CK_TYPE_CLNT_OK(type)) {
			forget_error(q, "unknown checksum %s%s",
				     DB_TYPE2STR(type), from_id_ip(q, 0));
			return 0;
		}
		if (prev_type >= type) {
			forget_error(q, "out of order %s checksum%s",
				     DB_TYPE2STR(ck->type), from_id_ip(q, 0));
			return 0;
		}

		/* Notice clients that want to but are not authorized to
		 * get reputation results. */
		if (DCC_CK_IS_REP(grey_on, type)
		    && !(q->flags & Q_FG_REPS_ANS_OK)
		    && !no_rep_complained) {
			no_rep_complained = 1;
			clnt_msg(q, "unauthorized reputation request %s",
				 from_id_ip(q, 0));
		}
	}

	if (db_lock() < 0) {
		NORESP_EMSG(q);
		return 0;
	}

	return ck_lim;
}



/* send the response and release q */
static void
fin_work(const QUEUE *q, DCC_HDR *answer)
{
	int delay_us;

	/* send the response */
	answer->op = DCC_OP_ANSWER;
	send_resp(q, answer, 0);

	/* update the average queue delay, unless it is crazy */
	gettimeofday(&db_time, 0);
	delay_us = tv_diff2us(&db_time, &q->answer);
	if (delay_us < 0)
		return;

	update_q_delay();
	q_delays[0].us += delay_us;
	++q_delays[0].ops;
}



/* release q on failure */
static u_char
make_answer(QUEUE *q,
	    const DCC_CK *ck_lim,
	    u_char have_rcd,		/* rcd_st is new record */
	    DB_ST *rcd_st,
	    DCC_ANSWER *answer,
	    DCC_TGTS gross_tgts,	/* total for this report, maybe MANY */
	    DCC_TGTS net_tgts,		/* real total for this report */
	    u_char is_bulk,
	    int *rep,
	    DCC_TGTS* max_tgts)		/* statistics */
{
	DB_ST *ck_st;
	const DCC_CK *ck;
	DCC_TGTS c_tgts;		/* current count with this report */
	DCC_TGTS p_tgts;		/* count before this report */
	DCC_ANSWER_BODY_CKS *b;
	DCC_CK_TYPES type;
	const DB_RCD_CK *rcd_ck, *prev_rcd_ck;
	int num_rcd_cks;
	DB_PTR prev;
	DCC_TGTS rep_total = 0;

	if (rep)
		*rep = -1;
	*max_tgts = 0;

	ck_st = GET_DB_ST();

	if (have_rcd) {
		rcd_ck = rcd_st->d.r->cks;
		num_rcd_cks = DB_NUM_CKS(rcd_st->d.r);
	} else {
		num_rcd_cks = 0;
		rcd_ck = 0;
	}
	b = answer->b;
	for (ck = q->pkt.r.cks; ck < ck_lim; ++ck) {
		type = ck->type;
		if (num_rcd_cks > 0
		    && type == DB_CK_TYPE(rcd_ck)) {
			/* try to copy answer from report's new record */
			c_tgts = DB_TGTS_CK(rcd_ck);
			if (c_tgts < DCC_TGTS_TOO_MANY) {
				/* here c_tgts<DCC_TGTS_TOO_MANY,
				 * so net_tgts==gross_tgts */
				if (DCC_CK_IS_REP(grey_on, type)) {
					if (!(q->flags & Q_FG_REPS_ANS_OK)) {
					    /* no reputation responses
					     * without authorization */
					    c_tgts = 0;
					    p_tgts = DCC_TGTS_INVALID;
					} else if (type == DCC_CK_REP_TOTAL) {
					    p_tgts = c_tgts - gross_tgts;
					} else if (type == DCC_CK_REP_BULK) {
					    if (is_bulk)
						p_tgts = c_tgts - gross_tgts;
					    else
						p_tgts = c_tgts;
					} else {
					    p_tgts = c_tgts - gross_tgts;
					}
				} else {
					p_tgts = c_tgts - gross_tgts;
				}
			} else if (prev = DB_PTR_EX(rcd_ck->prev),
				   prev == DB_PTR_NULL) {
				p_tgts = 0;
			} else {
				prev_rcd_ck = db_map_rcd_ck(&dcc_emsg,
							ck_st, prev, type);
				if (!prev_rcd_ck) {
					DB_ERROR_MSG(dcc_emsg.c);
					RIDC_BAD(q);
					free_db_st(ck_st);
					return 0;
				}
				p_tgts = DB_TGTS_CK(prev_rcd_ck);
			}
			--num_rcd_cks;
			++rcd_ck;

		} else {
			p_tgts = get_ck_tgts(0, type, &ck->sum, 0, ck_st);
			if (p_tgts == DCC_TGTS_INVALID) {
				NORESP_EMSG(q);
				RIDC_BAD(q);
				free_db_st(ck_st);
				return 0;   /* broken database */
			}
			if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type)) {
				/* uninteresting checksums have no value
				 * unless they are whitelisted */
				c_tgts = p_tgts;
				if (p_tgts == 0)
					p_tgts = DCC_TGTS_INVALID;

			} else if (DCC_CK_IS_REP(grey_on, type)) {
				if (!(q->flags & Q_FG_REPS_ANS_OK)) {
					c_tgts = 0;
					p_tgts = DCC_TGTS_INVALID;
				} else if (type == DCC_CK_REP_TOTAL) {
					c_tgts = db_sum_ck(p_tgts,
							net_tgts, type);
				} else if (type == DCC_CK_REP_BULK) {
					    if (is_bulk)
						c_tgts = db_sum_ck(p_tgts,
							net_tgts, type);
					    else
						c_tgts = p_tgts;
				} else {
					c_tgts = db_sum_ck(p_tgts,
							net_tgts, type);
				}

			} else {
				c_tgts = db_sum_ck(p_tgts, gross_tgts, type);
			}
		}

		b->c = htonl(c_tgts);
		b->p = htonl(p_tgts);
#ifdef DCC_PKT_VERS5
		if (q->pkt.hdr.pkt_vers <= DCC_PKT_VERS5)
			b = (DCC_ANSWER_BODY_CKS *)&b->p;
		else
#endif
		++b;

		/* compute the reputation for the totals for `cdcc stats` */
		if (DCC_CK_IS_REP_TOTAL(grey_on, type)) {
			if (q->flags & Q_FG_REPS_ANS_OK) {
				rep_total = c_tgts;
				continue;
			}
		}
		if (DCC_CK_IS_REP_BULK(grey_on, type)) {
			/* treat insufficient data the same as no bad
			 * reputation because both will soon expire */
			if (rep_total >= DCC_REP_TGTS_TOTAL_MIN
			    && (q->flags & Q_FG_REPS_ANS_OK))
				*rep = get_reputation(c_tgts, rep_total);
			else
				*rep = 0;
			continue;
		}

		if (*max_tgts < c_tgts
		    && c_tgts <= DCC_TGTS_OK2) {
			*max_tgts = c_tgts;
			/* Complain about failures to whitelist by
			 * trusted clients.  The main use of this is
			 * to detect whitelisting failures of IP addresses
			 * such as 127.0.0.1 for reputations, and those
			 * matter only for known clients.  */
			if ((p_tgts >= DCC_TGTS_OK)
			    && (q->flags & Q_FG_TRUSTED))
				TMSG4(WLIST, "%s whitelisted %s %s%s",
				      qop2str(q),
				      DB_TYPE2STR(type),
				      ck2str_err(type, &ck->sum, 0),
				      from_id_ip(q, 0));
		}
	}
	answer->hdr.len = (sizeof(*answer) - sizeof(answer->b)
			   + ((char *)b - (char *)answer->b));
	free_db_st(ck_st);
	return 1;
}



/* release q on failure
 *	the database must be locked */
static u_char
do_report(QUEUE *q,
	  DCC_TGTS tgts0, const DCC_CK *ck_lim,
	  DCC_ANSWER *answer,
	  int *rep,
	  DCC_TGTS *max_tgts)
{
	const DCC_CK *ck;
	const DCC_CK *rep_total_ck = 0;
	const DCC_CK *rep_bulk_ck = 0;
	u_char is_bulk = 0;
	DB_ST *sumrcd_st;
	DCC_TGTS tgts;
	DCC_TGTS gross_tgts;		/* DCC_TGTS_TOO_MANY if spam */
	DB_PTR rcd_pos;
	DB_RCD new;
	DB_RCD_CK *new_ck;
	DCC_CK_TYPES type;
	char tgts_buf[DCC_XHDR_MAX_TGTS_LEN];
	u_char result;

	tgts = tgts0;
	if (tgts & (DCC_TGTS_SPAM | DCC_TGTS_REP_SPAM)) {
		tgts &= DCC_TGTS_MASK;
		if (tgts == 0)
			tgts = 1;
		gross_tgts = DCC_TGTS_TOO_MANY;
	} else if (tgts == DCC_TGTS_TOO_MANY) {
		tgts = 1;
		gross_tgts = DCC_TGTS_TOO_MANY;
	} else if (tgts > DCC_TGTS_RPT_MAX) {
		forget_error(q, "bogus target count %s%s",
			     tgts2str(tgts_buf, sizeof(tgts_buf), tgts, grey_on),
			     from_id_ip(q, 0));
		return 0;
	} else {
		gross_tgts = tgts;
	}

	if (gross_tgts < 10) {
		;
	} else if (tgts0 & DCC_TGTS_REP_SPAM) {
		;
	} else if (gross_tgts == DCC_TGTS_TOO_MANY) {
		++dccd_stats.reportmany;
	} else if (gross_tgts > 1000) {
		++dccd_stats.report1000;
	} else if (gross_tgts > 100) {
		++dccd_stats.report100;
	} else if (gross_tgts > 10) {
		++dccd_stats.report10;
	}

	/* Get ready to add the report to the database,
	 * and as a side effect, find the data to answer the query.
	 * Start by creating the record to add to the database. */
	use_ts(&new.ts, q);
	new.srvr_id = my_srvr_id;
	DB_TGTS_RCD_SET(&new, gross_tgts);

	/* copy checksums to the new record */
	new.fgs_num_cks = 0;
	new_ck = new.cks;
	for (ck = q->pkt.r.cks; ck < ck_lim; ++ck) {
		type = ck->type;
		if (type == DCC_CK_IP) {
			/* Do not record reputation changes for notices
			 * from commercial clients that a previous report
			 * is now known to be of bulk mail as the result of
			 * a reputation hit. */
			if (tgts0 & DCC_TGTS_REP_SPAM)
				continue;
			/* Record reputation data from authorized clients. */
			if (q->flags & Q_FG_REPS_RPT_OK) {
				rep_total_ck = ck;
				rep_bulk_ck = ck;
			}
		}
		if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type))
			continue;
		if (DCC_CK_IS_BODY(type)) {
			if (is_bulk) {
				;
			} else if (gross_tgts >= BULK_THRESHOLD) {
				is_bulk = 1;
			} else {
				DB_ST *ck_st;
				DCC_TGTS ck_tgts;

				ck_st = GET_DB_ST();
				ck_tgts = get_ck_tgts(0, type, &ck->sum,
						      0, ck_st);
				free_db_st(ck_st);
				if (ck_tgts == DCC_TGTS_INVALID) {
					NORESP_EMSG(q);
					return 0;
				}
				ck_tgts = db_sum_ck(tgts, ck_tgts, type);
				if (ck_tgts >= BULK_THRESHOLD
				    && ck_tgts <= DCC_TGTS_TOO_MANY)
					is_bulk = 1;
			}

		} else if (DCC_CK_IS_REP_TOTAL(grey_on, type)) {
			/* Do not record reputation data if
			 * the client is not authorized
			 * or if this is a body adjustment resulting
			 * from a reputation hit. */
			if (!(q->flags & Q_FG_REPS_RPT_OK)
			    || (tgts0 & DCC_TGTS_REP_SPAM)) {
				rep_total_ck = 0;
				continue;
			}
			if (gross_tgts >= BULK_THRESHOLD
			    && gross_tgts <= DCC_TGTS_TOO_MANY)
				is_bulk = 1;
			if (gross_tgts == DCC_TGTS_TOO_MANY) {
				/* Reputation records require real target counts
				 * and so must be separate from spam reports.
				 * Make a note of the IP address to create
				 * a separate report */
				rep_total_ck = ck;
				continue;
			}
			/* take care of the total reputation in main record */
			rep_total_ck = 0;

		} else if (DCC_CK_IS_REP_BULK(grey_on, type)) {
			/* do not record reputation data if
			 * the client is not authorized
			 * or if this is a body adjustment resulting
			 * from a reputation hit */
			if (!(q->flags & Q_FG_REPS_RPT_OK)
			    || (tgts0 & DCC_TGTS_REP_SPAM)) {
				rep_bulk_ck = 0;
				continue;
			}
			if (!is_bulk) {
				/* if it is not bulk,
				 * then forget the bulk reputation checksum */
				rep_bulk_ck = 0;
				continue;
			}
			if (gross_tgts == DCC_TGTS_TOO_MANY) {
				/* Reputation records require real target counts
				 * and so must be separate from spam reports.
				 * Make a note of the IP address to create
				 * a separate report */
				rep_bulk_ck = ck;
				continue;
			}
			/* take care of the bulk reputation in main record */
			rep_bulk_ck = 0;
		}

		new_ck->sum = ck->sum;
		new_ck->type_fgs = type;
		new_ck->prev = DB_PTR_CP(DB_PTR_BAD);
		++new_ck;
		++new.fgs_num_cks;
	}

	if (!(q->flags & Q_FG_RPT_OK)) {
		/* finished if this is a query */
		return make_answer(q, ck_lim, 0, 0, answer, gross_tgts,
				   tgts, is_bulk, rep, max_tgts);
	}

	if (new.fgs_num_cks == 0) {
		sumrcd_st = 0;
		rcd_pos = DB_PTR_NULL;
	} else {
		/* Add the record to the database.
		 * That will update the totals for each checksum */
		sumrcd_st = GET_DB_ST();
		if (!add_dly_rcd(&new, 0, sumrcd_st)) {
			NORESP_EMSG(q);
			free_db_st(sumrcd_st);
			return 0;
		}
		rcd_pos = sumrcd_st->s.rptr;
	}

	/* add a separate reputation record if we did not already handle
	 * the reputation checksums,
	 * and we have either or both reputation checksums
	 * and the client is authenticated. */
	new.fgs_num_cks = 0;
	new_ck = new.cks;
	if (rep_total_ck) {
		new_ck->type_fgs = DCC_CK_REP_TOTAL;
		new_ck->sum = rep_total_ck->sum;
		new_ck->prev = DB_PTR_CP(DB_PTR_BAD);
		++new_ck;
		++new.fgs_num_cks;
	}
	if (rep_bulk_ck && is_bulk) {
		new_ck->type_fgs = DCC_CK_REP_BULK;
		new_ck->sum = rep_bulk_ck->sum;
		new_ck->prev = DB_PTR_CP(DB_PTR_BAD);
		++new_ck;
		++new.fgs_num_cks;
	}
	if (new.fgs_num_cks != 0) {
		DB_TGTS_RCD_SET(&new, tgts);
		use_ts(&new.ts, q);
		if (!add_dly_rcd(&new, 0, sumrcd_st)) {
			NORESP_EMSG(q);
			if (sumrcd_st)
				free_db_st(sumrcd_st);
			return 0;
		}
		/* recover the main record to speed the answer */
		if (rcd_pos != DB_PTR_NULL
		    && !db_map_rcd(&dcc_emsg, sumrcd_st, rcd_pos, 0)) {
			DB_ERROR_MSG(dcc_emsg.c);
			RIDC_BAD(q);
			free_db_st(sumrcd_st);
			return 0;
		}
	}

	/* generate the response, perhaps from the new record(s) */
	result = make_answer(q, ck_lim, rcd_pos!=DB_PTR_NULL, sumrcd_st,
			     answer, gross_tgts, tgts, is_bulk, rep, max_tgts);

	if (sumrcd_st)
		free_db_st(sumrcd_st);
	return result;
}



/* process a single real request */
void
do_work(QUEUE *q)
{
	const DCC_CK *ck_lim;
	DCC_ANSWER answer;
	DCC_TGTS max_tgts, tgts;
	int rep;

	ck_lim = start_work(q);
	if (!ck_lim)
		return;

	tgts = 0;
	switch (q->pkt.hdr.op) {
	case DCC_OP_QUERY:
		++dccd_stats.queries;
		q->flags &= ~Q_FG_RPT_OK;
		break;

	case DCC_OP_REPORT:
		if (!(q->flags & Q_FG_RPT_OK)) {
			++dccd_stats.report_reject;
			clnt_msg(q, "treat %s as query", from_id_ip(q, 1));
			++dccd_stats.queries;
		} else {
			tgts = ntohl(q->pkt.r.tgts);
			/* do not count 2nd operation for reputations hit */
			if (!(tgts & DCC_TGTS_REP_SPAM))
				++dccd_stats.reports;
		}
		break;

	case DCC_OP_INVALID:
	case DCC_OP_NOP:
	case DCC_OP_ANSWER:
	case DCC_OP_ADMN:
	case DCC_OP_OK:
	case DCC_OP_ERROR:
	case DCC_OP_DELETE:
	case DCC_OP_GREY_REPORT:
	case DCC_OP_GREY_QUERY:
	case DCC_OP_GREY_SPAM:
	case DCC_OP_GREY_WHITE:
		dcc_logbad(EX_SOFTWARE, "impossible queued operation");
		break;
	}

	if (!do_report(q, tgts, ck_lim, &answer, &rep, &max_tgts)) {
		/* ensure that the clock ticks so rate limits don't stick */
		gettimeofday(&db_time, 0);
	} else {
		/* notice the size of our answer */
		if (max_tgts == DCC_TGTS_OK || max_tgts == DCC_TGTS_OK2) {
			++dccd_stats.respwhite;
		} else if (tgts & DCC_TGTS_REP_SPAM) {
			;		/* do not count 2nd op for rep hit */
		} else if (max_tgts == DCC_TGTS_TOO_MANY) {
			++dccd_stats.respmany;
		} else if (max_tgts > 1000) {
			++dccd_stats.resp1000;
		} else if (max_tgts > 100) {
			++dccd_stats.resp100;
		} else if (max_tgts > 10) {
			++dccd_stats.resp10;
		}

		if (tgts & DCC_TGTS_REP_SPAM) {
			if (tgts & DCC_TGTS_SPAM)
				++dccd_stats.report_reps;
		} else if (rep > 60) {
			++dccd_stats.rep60;
		} else if (rep > 30) {
			++dccd_stats.rep30;
		} else if (rep > 20) {
			++dccd_stats.rep20;
		} else if (rep > 10) {
			++dccd_stats.rep10;
		} else if (rep > 0) {
			++dccd_stats.rep1;
		} else if (rep == 0 && (q->flags & Q_FG_REPS_ANS_OK)) {
			++dccd_stats.norep;
		}

		fin_work(q, &answer.hdr);
	}
}



/* return 0 for a new embargo,
 *	embargo count	for an existing embargo,
 *	DCC_TGTS_TOO_MANY   no embargo
 *	DCC_TGTS_OK	    a newly expired embargo
 *	DCC_TGTS_INVALID    broken database */
static DCC_TGTS
search_grey(const DCC_CK *req_ck3,	/* triple checksum */
	    const DCC_CK *req_ckb,	/* body seen with it */
	    u_char body_known)
{
	DB_ST *rcd_st;
	DB_RCD_CK *ck3, *ckb;
	DB_PTR prev3;
	DCC_TS old_ts;
	DCC_TGTS result_tgts;
	int i;

	/* look for the triple checksum */
	rcd_st = GET_DB_ST();
	switch (db_lookup(&dcc_emsg, DCC_CK_GREY3, &req_ck3->sum,
			  0, rcd_st, &ck3)) {
	case DB_FOUND_EMPTY:
	case DB_FOUND_CHAIN:
	case DB_FOUND_INTRUDER:
		free_db_st(rcd_st);
		return 0;

	case DB_FOUND_IT:
		/* We found the triple checksum.
		 * If it is marked ok (MANY) or deleted,
		 * then we have our answer */
		result_tgts = DB_TGTS_CK(ck3);
		if (result_tgts == DCC_TGTS_TOO_MANY || result_tgts == 0) {
			free_db_st(rcd_st);
			return result_tgts;
		}

		/* Otherwise look for a report of the triple with
		 * the right body checksum that is old enough. */
		result_tgts = 0;
		timeval2ts(&old_ts, &db_time, -grey_embargo);
		for (;;) {
			ckb = rcd_st->d.r->cks;
			for (i = DB_NUM_CKS(rcd_st->d.r);
			     i > 0;
			     --i, ++ckb) {
				/* try the next report in the database
				 * if it has the wrong body checksum
				 *
				 * If we are weak on bodies,
				 * act as if all reports of the triple checksums
				 * are with the right body checksum. */
				if (!grey_weak_body && req_ckb) {
					if (DB_CK_TYPE(ckb) != DCC_CK_BODY)
					    continue;
					if (memcmp(&req_ckb->sum, &ckb->sum,
						   sizeof(req_ckb->sum)))
					    break;
				}

				/* We found the right body checksum in
				 * chain of the triple checksum
				 * or we don't care.
				 *
				 * If the report is old enough, then
				 * the embargo is over. */
				if (ts_newer_ts(&old_ts, &rcd_st->d.r->ts)) {
					free_db_st(rcd_st);
					return DCC_TGTS_OK;
				}

				/* If it is not old enough,
				 * then we know this is not a new embargo for
				 * this body (i.e. the reported target count
				 * will be >0) and we must keep looking for an
				 * old enough report with the body checksum. */
				++result_tgts;
				break;
			}

			/* If we know the body checksum is not in the database,
			 * then there is no profit in looking at other reports
			 * of the triple checksum to try to find an old enough
			 * report that is with the right body checksum.
			 * We know this is a new embargo. */
			if (!body_known) {
				free_db_st(rcd_st);
				return 0;
			}

			/* If we reach the end of the chain of the
			 * triple checksum without finding an old
			 * enough report for the right body,
			 * then the embargo is not over. */
			prev3 = DB_PTR_EX(ck3->prev);
			if (prev3 == DB_PTR_NULL) {
				free_db_st(rcd_st);
				return result_tgts;
			}

			/* examine the timestamp of the preceding report
			 * of the triple */
			ck3 = db_map_rcd_ck(&dcc_emsg, rcd_st,
					    prev3, DCC_CK_GREY3);
			if (!ck3) {
				free_db_st(rcd_st);
				return DCC_TGTS_INVALID;
			}
		}
		break;

	case DB_FOUND_SYSERR:
		DB_ERROR_MSG(dcc_emsg.c);
		free_db_st(rcd_st);
		return DCC_TGTS_INVALID;
	}

	free_db_st(rcd_st);
	return DCC_TGTS_INVALID;
}



void
do_grey(QUEUE *q, DCC_CLNT_ID id)
{
	DCC_OPS op;
	DB_ST *rcd_st;
	DB_RCD new;
	const DCC_CK *req, *req_lim;
	const DCC_CK *req_ck_ip, *req_ck_triple, *req_ck_msg, *req_ck_body;
	u_char body_known;
	DB_RCD_CK *new_ck, *found_ck;
	DCC_GREY_ANSWER resp;
	DCC_TGTS tgts;
	DCC_TGTS ip_tgts;		/* existing count for DCC_CK_IP */
	DCC_TGTS triple_tgts;		/*   "   count for GREY_TRIPLE */
	DCC_TGTS msg_tgts;		/*   "   count for GREY_MSG */
	DCC_TGTS eff_msg_tgts;		/* effective value: 0=reported to DCC */
	DCC_TGTS new_msg_tgts;		/* value after this */
	DCC_TGTS result_tgts;		/* no embargo, ending, whitelist or # */

	TMSG_OP(QUERY, q);
	if (!ck_clnt_id(q, id, anon_off))
		return;
	if (!(q->flags & Q_FG_TRUSTED)) {
		clnt_msg(q, "drop %s", from_id_ip(q, 1));
		return;
	}

	/* an embargo of 0 seconds means we should only collect names */
	op = q->pkt.hdr.op;
	if (op == DCC_OP_GREY_REPORT && grey_embargo == 0)
		op = DCC_OP_GREY_WHITE;

	req_lim = start_work(q);
	if (!req_lim)
		return;

	rcd_st = GET_DB_ST();

	/* Require
	 *	the body checksum,
	 *	the checksum of the (body,sender,target),
	 *	and the checksum of the (source,sender,target) triple.
	 * Allow other checksums for whitelisting. */
	ip_tgts = 0;
	body_known = grey_weak_body;
	req_ck_ip = 0;
	req_ck_body = 0;
	req_ck_triple = 0;
	req_ck_msg = 0;
	msg_tgts = eff_msg_tgts = 0;
	for (req = q->pkt.r.cks; req < req_lim; ++req) {
		/* Note our main checksums of the greylist triple and
		 * the message body.  Search the database for it later */
		if (DCC_CK_IS_GREY_TRIPLE(1, req->type)) {
			req_ck_triple = req;
			continue;
		}

		if (!DCC_CK_OK_GREY_CLNT(req->type))
			continue;	/* ignore unknown checksums */
		switch (req->type) {
		case DCC_CK_IP:
			req_ck_ip = req;
			break;
		case DCC_CK_BODY:
			req_ck_body = req;
			break;
		case DCC_CK_GREY_MSG:
			req_ck_msg = req;
			break;
		}
		/* check for whitelisting and whether this is a new embargo */
		switch (db_lookup(&dcc_emsg, req->type, &req->sum,
				 0, rcd_st, &found_ck)) {
		case DB_FOUND_SYSERR:
			DB_ERROR_MSG(dcc_emsg.c);
			RIDC_BAD(q);
			free_db_st(rcd_st);
			return;
		case DB_FOUND_IT:
			/* ignore deleted checksums */
			tgts = DB_TGTS_CK(found_ck);
			if (tgts == 0)
				continue;

			/* honor whitelisting */
			if (tgts == DCC_TGTS_GREY_WHITE
			    && op != DCC_OP_GREY_WHITE) {
				op = DCC_OP_GREY_WHITE;
				++dccd_stats.respwhite;
			}

			switch (req->type) {
			case DCC_CK_BODY:
				/* notice if the target body exists at all */
				body_known = 1;
				break;
			case DCC_CK_GREY_MSG:
				msg_tgts = tgts;
				if (msg_tgts != DCC_TGTS_TOO_MANY) {
					/* this is an old embargo that has
					 * already been reported by the client
					 * to a normal DCC server */
					eff_msg_tgts = 1;
				}
				break;
			case DCC_CK_IP:
				ip_tgts = tgts;
				break;
			default:
				break;
			}
			break;
		case DB_FOUND_EMPTY:
		case DB_FOUND_CHAIN:
		case DB_FOUND_INTRUDER:
			break;
		}
	}
	if (!req_ck_triple) {
		send_error(q, "missing %s checksum for %s",
			   DB_TYPE2STR(DCC_CK_GREY3), qop2str(q));
		free_db_st(rcd_st);
		return;
	}
	if (op == DCC_OP_GREY_REPORT && !grey_weak_body) {
		if (!req_ck_body) {
			send_error(q, "missing body checksum for %s",
				   qop2str(q));
			free_db_st(rcd_st);
			return;
		}
		if (!req_ck_msg) {
			send_error(q, "missing %s checksum for %s",
				   DB_TYPE2STR(DCC_CK_GREY_MSG), qop2str(q));
			free_db_st(rcd_st);
			return;
		}
	}

	/* decide if the embargo should end */
	triple_tgts = search_grey(req_ck_triple, req_ck_body, body_known);
	if (triple_tgts == DCC_TGTS_INVALID) {
		NORESP_EMSG(q);		/* broken database */
		free_db_st(rcd_st);
		return;
	}
	/* End existing embargo on a newly whitelisted sender so its
	 *	messages are logged.
	 * Quietly prevent future embargos of whitelisted senders that have
	 *	not been greylisted.
	 * Honor grey_weak_ip whitelisting even after it is turned off */
	if (triple_tgts >= DCC_TGTS_TOO_MANY) {
		result_tgts = triple_tgts;
	} else if (op == DCC_OP_GREY_WHITE) {
		result_tgts = eff_msg_tgts ? DCC_TGTS_OK : DCC_TGTS_TOO_MANY;
	} else if (ip_tgts == DCC_TGTS_TOO_MANY) {
		result_tgts = DCC_TGTS_TOO_MANY;
	} else {
		result_tgts = triple_tgts;
	}

	if (op == DCC_OP_GREY_QUERY) {
		++dccd_stats.queries;

	} else if (!(q->flags & Q_FG_RPT_OK)) {
		++dccd_stats.report_reject;
		clnt_msg(q, "treat %s as query", from_id_ip(q, 1));
		++dccd_stats.queries;

	} else {
		/* add a report for this message */
		++dccd_stats.reports;
		new.srvr_id = my_srvr_id;
		new_ck = new.cks;
		new.fgs_num_cks = 0;
		if (result_tgts < DCC_TGTS_TOO_MANY) {
			if (req_ck_body) {
				new_ck->type_fgs = DCC_CK_BODY;
				new_ck->sum = req_ck_body->sum;
				new_ck->prev = DB_PTR_CP(DB_PTR_BAD);
				++new.fgs_num_cks;
				++new_ck;
			}
			new_msg_tgts = 1;
			DB_TGTS_RCD_SET(&new, 1);
		} else {
			/* embargo now ending (DCC_TGTS_TOO_OK)
			 * or no embargo (DCC_TGTS_TOO_MANY) */
			if (grey_weak_ip && req_ck_ip) {
				new_ck->type_fgs = DCC_CK_IP;
				new_ck->sum = req_ck_ip->sum;
				new_ck->prev = DB_PTR_CP(DB_PTR_BAD);
				++new.fgs_num_cks;
				++new_ck;
			}
			new_msg_tgts = 0;
			DB_TGTS_RCD_SET(&new, DCC_TGTS_TOO_MANY);
		}

		/* Include the GREY_MSG checksum in the database
		 * record for a new embargo.
		 * The message checksum lets an SMTP server report an
		 * embargoed message to the DCC before the embargo is over,
		 * but not report it more than once even if more than one
		 * SMTP client retransmits the message.
		 *
		 * If the GREY_MSG checksum does not exist in the
		 * database, then tell the DCC client the message is new
		 * and should be reported to the DCC server.  We must put the
		 * the _GREY_MSG into the database so we will recognize
		 * the message as not new when it is retransmitted.
		 *
		 * If the GREY_MSG checksum exists and is not MANY,
		 * then we may have a retransmission of the message
		 * from another IP address.
		 * We need to tell the DCC client to not report to the
		 * DCC server. The new value for the CK_GREY_MSG checksum
		 * should be whatever we are using for the triple checksum.
		 *
		 * If the existing count for the GREY_MSG checksum is
		 * MANY, and the new value for triple checksum is not MANY,
		 * then we have a new copy of the message and a new embargo.
		 * We have a spammer with multiple senders instead of a
		 * legitimate multihomed SMTP client.  We need to tell the
		 * DCC client to report to the DCC server.  To remember
		 * that we told the DCC client to report to the DCC server,
		 * we must first delete the existing MANY report of the
		 * GREY_MSG checksum. */
		if (eff_msg_tgts != new_msg_tgts
		    && req_ck_msg) {
			if (msg_tgts == DCC_TGTS_TOO_MANY
			    && !add_del(req_ck_msg, q)) {
				NORESP_EMSG(q);
				free_db_st(rcd_st);
				return;
			}
			new_ck->type_fgs = DCC_CK_GREY_MSG;
			new_ck->sum = req_ck_msg->sum;
			new_ck->prev = DB_PTR_CP(DB_PTR_BAD);
			++new.fgs_num_cks;
			++new_ck;
		}

		/* Add the triple checksum if we are not whitelisting
		 *	by the IP address
		 * or triple checksum is not new.
		 * We do not want to leave any dangling triples in the
		 * database */
		if (!(grey_weak_ip && req_ck_ip)
		    || result_tgts != DCC_TGTS_TOO_MANY) {
			new_ck->type_fgs = DCC_CK_GREY3;
			new_ck->sum = req_ck_triple->sum;
			new_ck->prev = DB_PTR_CP(DB_PTR_BAD);
			++new.fgs_num_cks;
		}

		use_ts(&new.ts, q);
		if (!db_add_rcd(&dcc_emsg, &new, 0)) {
			DB_ERROR_MSG(dcc_emsg.c);
			RIDC_BAD(q);
			free_db_st(rcd_st);
			return;
		}
	}

	/* In the result sent to the DCC client,
	 * the triple checksum is preceeded by the message checksum
	 * with a count of 0 if this is a new embargo.
	 * Targets of messages of new embargos should be counted among
	 * total targets in reports sent to DCC servers.  After they
	 * have been included in such an early report to a DCC server,
	 * they should never be included again, except for bulk reputations. */
	resp.msg = htonl(eff_msg_tgts);

	/* Answer SMTP DATA command greylist operations with the target
	 * count of the triple checksum:
	 *	DCC_TGTS_OK if the embargo is just now being removed
	 *	DCC_TGTS_TOO_MANY if there is no current embargo
	 *	DCC_TGTS_GREY_WHITE if whitelisted.
	 *	embargo # otherwise */
	resp.triple = htonl(result_tgts);
	resp.hdr.len = sizeof(resp);

	fin_work(q, &resp.hdr);
	free_db_st(rcd_st);
}



static time_t
picky_time(const QUEUE *q)
{
	time_t ts, delta;

	/* If the request arrived while we were asleep, then the client's
	 * timestamp ought to be smaller than when select() finished and
	 * we think the request arrived. */
	ts = ntohl(q->pkt.d.date);
	delta = ts - q->answer.tv_sec;
	if (delta <= 0)
		return delta;

	/* If the request arrived while we were handling some other request,
	 * then its timestamp can be larger than the select() wake-up time
	 * but should not be in the future. */
	delta = ts - db_time.tv_sec;
	if (delta < 0)
		delta = 0;
	return delta;
}



static u_char				/* 0=refuse the bad guy, 1=continue */
picky_admn(QUEUE *q, u_char any_id, u_char any_time)
{
	time_t delta;

	if (!(q->flags & Q_FG_TRUSTED)
	    || (q->clnt_id != my_srvr_id && !any_id)) {
		forget_error(q, "drop %s", from_id_ip(q, 1));
		return 0;
	}

	if (any_id && any_time)
		return 1;

	/* Demand a current timestamp to guard against replay attacks.
	 * This requires that administrators have clocks close to servers',
	 * and that network and server delays be reasonable. */
	delta = picky_time(q);
	if (delta < -MAX_CMD_CLOCK_SKEW || delta > MAX_CMD_CLOCK_SKEW) {
		send_error(q, "drop %s; timestamp off by %d seconds",
			   qop2str(q), (int)delta);
		return 0;
	}

	return 1;
}



/* the database must be locked */
static u_char				/* 1=ok, 0=error sent to client */
delete_sub(QUEUE *q, DCC_CK *del_ck,
	   u_char grey_spam)
{
	DB_ST *rcd_st;
	DB_RCD_CK *rcd_ck;
	char buf[80];
	DB_PTR prev;
	DCC_TGTS tgts;

	rcd_st = GET_DB_ST();
	buf[0] = '\0';
	switch (db_lookup(&dcc_emsg, del_ck->type, &del_ck->sum,
			  0, rcd_st, &rcd_ck)) {
	case DB_FOUND_EMPTY:
	case DB_FOUND_CHAIN:
	case DB_FOUND_INTRUDER:
		/* finished if we have not greylisted the spammer */
		if (grey_spam) {
			free_db_st(rcd_st);
			return 1;
		}

		/* ordinary deletions need a delete request added
		 * to the database and flooded */
		snprintf(buf, sizeof(buf), "\"%s %s\" not found to delete",
			 DB_TYPE2STR(del_ck->type),
			 ck2str_err(del_ck->type, &del_ck->sum, 0));

		if (del_ck->type == DCC_CK_SRVR_ID) {
			send_error(q, "%s", buf);
			free_db_st(rcd_st);
			return 0;
		}
		break;

	case DB_FOUND_IT:
		tgts = DB_TGTS_CK(rcd_ck);
		/* handle an ordinary delete request */
		if (!grey_spam) {
			if (tgts == 0)
				snprintf(buf, sizeof(buf),
					 "%s %s already deleted",
					 DB_TYPE2STR(del_ck->type),
					 ck2str_err(del_ck->type,
						    &del_ck->sum, 0));
			break;
		}
		/* We are deleting a greylist checksum.
		 * If we are deleting very new greylist records,
		 * we can cheat and avoid adding to the database
		 * by scribbling over the records.
		 * If there is an older record that might have been flooded,
		 * we must add a delete request to the database
		 * that will itself be flooded. */
		for (;;) {
			/* finished if the target has already been deleted */
			if (tgts == 0) {
				free_db_st(rcd_st);
				return 1;
			}
			if (rcd_st->s.rptr < oflods_max_cur_pos
			    || oflods_max_cur_pos == 0) {
				/* We need to add a delete request, because
				 * the record might have been flooded */
				break;
			}
			prev = DB_PTR_EX(rcd_ck->prev);
			/* try to delete the entire greylist entry
			 * starting with the target triple checksum */
			do {
				/* only if the embargo is not over */
				if (DB_TGTS_CK(rcd_ck) >= DCC_TGTS_TOO_MANY)
					goto need_rcd;
				DB_TGTS_CK_SET(rcd_ck, 0);
			} while (--rcd_ck >= rcd_st->d.r->cks);
			DB_TGTS_RCD_SET(rcd_st->d.r, 0);
			DIRTY_RCD(rcd_st, 1);

			/* stop after the last record */
			if (prev == DB_PTR_NULL) {
				free_db_st(rcd_st);
				return 1;
			}

			rcd_ck = db_map_rcd_ck(&dcc_emsg, rcd_st,
					       prev, del_ck->type);
			if (!rcd_ck) {
				NORESP_EMSG(q);
				free_db_st(rcd_st);
				return 0;
			}
			tgts = DB_TGTS_CK(rcd_ck);
		}
need_rcd:;
		break;

	case DB_FOUND_SYSERR:
		DB_ERROR_MSG(dcc_emsg.c);
		RIDC_BAD(q);
		free_db_st(rcd_st);
		return 0;
	}

	/* Add the delete request to the database even if the
	 * checksum seems deleted or absent so that we will
	 * flood the delete request.  This is required to ensure that
	 * records get deleted when they are created at one DCC server
	 * and deleted at another. */
	if (!add_del(del_ck, q))
		BUFCPY(buf, dcc_emsg.c);

	if (buf[0] != '\0') {
		send_error(q, "%s", buf);
		free_db_st(rcd_st);
		return 0;
	}

	TMSG3(ADMN, "deleted %s %s%s",
	      DB_TYPE2STR(del_ck->type),
	      ck2str_err(del_ck->type, &del_ck->sum, 0),
	      from_id_ip(q, 0));
	free_db_st(rcd_st);
	return 1;
}



void
do_delete(QUEUE *q, DCC_CLNT_ID id)
{
	if (!ck_clnt_srvr_id(q, id, 1))
		return;
	if (!picky_admn(q, 0, 0))
		return;
	/* if we've already answered, then just repeat ourselves */
	if (ridc_get(q)) {
		repeat_resp(q);
		return;
	}

	log_op(q);			/* always log delete operations */

	++dccd_stats.admin;

	if (q->pkt_len != sizeof(q->pkt.d)) {
		send_error(q, "wrong packet length %d for %s",
			   q->pkt_len, qop2str(q));
		return;
	}
	if (q->pkt.d.ck.len != sizeof(q->pkt.d.ck)) {
		send_error(q, "unknown checksum length %d", q->pkt.d.ck.len);
		return;
	}
	if (!DCC_CK_TYPE_DB_OK(q->pkt.d.ck.type)) {
		send_error(q, "unknown checkksum type %d", q->pkt.d.ck.type);
		return;
	}

	if (db_lock() < 0) {
		NORESP_EMSG(q);
		return;
	}
	if (delete_sub(q, &q->pkt.d.ck, 0)) {
		/* We need to clean the database after a deletion
		 * to correct the totals of other checksums.
		 * Don't bother for reputations or server-ID declarations. */
		if (!DCC_CK_IS_REP(grey_on, q->pkt.d.ck.type)
		    && q->pkt.d.ck.type != DCC_CK_SRVR_ID)
			need_del_dbclean = "checksum deleted";

		send_ok(q);
	}
}



/* restore the embargo against a sender of spam */
void
do_grey_spam(QUEUE *q, DCC_CLNT_ID id)
{
	TMSG_OP(QUERY, q);
	if (!ck_clnt_id(q, id, 1))
		return;
	if (!(q->flags & Q_FG_TRUSTED)) {
		clnt_msg(q, "drop %s", from_id_ip(q, 1));
		return;
	}

	/* require the checksum of the (source,sender,target) triple */
	if (q->pkt_len != sizeof(q->pkt.gs)) {
		send_error(q, "wrong packet length %d for %s",
			   q->pkt_len, qop2str(q));
		return;
	}
	if (q->pkt.gs.triple.type != DCC_CK_GREY3) {
		send_error(q, "%s instead of %s for %s",
			   DB_TYPE2STR(q->pkt.gs.msg.type),
			   DB_TYPE2STR(DCC_CK_GREY3),
			   qop2str(q));
		return;
	}
	if (q->pkt.gs.triple.len != sizeof(q->pkt.gs.triple)) {
		send_error(q, "unknown triple checksum length %d",
			   q->pkt.gs.ip.len);
		return;
	}
	if (q->pkt.gs.msg.type != DCC_CK_GREY_MSG) {
		send_error(q, "%s instead of %s for %s",
			   DB_TYPE2STR(q->pkt.gs.msg.type),
			   DB_TYPE2STR(DCC_CK_GREY_MSG),
			   qop2str(q));
		return;
	}
	if (q->pkt.gs.msg.len != sizeof(q->pkt.gs.msg)) {
		send_error(q, "unknown msg checksum length %d",
			   q->pkt.gs.ip.len);
		return;
	}
	if (q->pkt.gs.ip.type != DCC_CK_IP) {
		send_error(q, "%s instead of %s for %s",
			   DB_TYPE2STR(q->pkt.gs.msg.type),
			   DB_TYPE2STR(DCC_CK_IP),
			   qop2str(q));
		return;
	}
	if (q->pkt.gs.ip.len != sizeof(q->pkt.gs.ip)) {
		send_error(q, "unknown IP checksum length %d",
			   q->pkt.gs.ip.len);
		return;
	}

	if (db_lock() < 0) {
		NORESP_EMSG(q);
		return;
	}
	if (delete_sub(q, &q->pkt.gs.ip, 1)
	    && delete_sub(q, &q->pkt.gs.triple, 1)
	    && delete_sub(q, &q->pkt.gs.msg, 1))
		send_ok(q);
}



static void
do_flod(QUEUE *q)
{
	DCC_ADMN_RESP check;
	int print_len;
	u_int32_t val, arg;
	DCC_AOP_FLODS fop;
	FLOD_MMAP *mp;
	OFLOD_INFO *ofp;
	u_char loaded, found_it;

	val = ntohl(q->pkt.ad.val1);
	fop = val % 256;
	arg = val / 256;

	if (fop != DCC_AOP_FLOD_LIST) {
	    if (!picky_admn(q, fop == DCC_AOP_FLOD_STATS, 0))
		    return;
	}

	switch (fop) {
	case DCC_AOP_FLOD_CHECK:
		/* `cdcc "flood check"` forces occasional defenses of
		 * our server-ID */
		if (host_id_next > db_time.tv_sec + 60)
			host_id_next = db_time.tv_sec;

		next_flods_ck = 0;
		got_hosts = 0;
		if (0 >= check_load_ids(0)) {
			send_error(q, "%s", dcc_emsg);
			return;
		}
		flod_stats_printf(check.val.string, sizeof(check.val.string),
				  (!FLODS_OK() || flods_st == FLODS_ST_OFF)
				  ? 0
				  : (flods_st != FLODS_ST_ON) ? 1
				  : 2,
				  oflods.total, oflods.open, iflods.open);
		check.hdr.len = (strlen(check.val.string)
				 + sizeof(check)-sizeof(check.val));
		check.hdr.op = DCC_OP_ADMN;
		send_resp(q, &check.hdr, 0);
		flods_ck(1);
		check_blacklist_file();
		return;

	case DCC_AOP_FLOD_SHUTDOWN:
		if (ridc_get(q)) {
			repeat_resp(q);
			return;
		}
		++flods_off;
		flods_stop("shutdown flooding", 0);
		send_ok(q);
		return;

	case DCC_AOP_FLOD_HALT:
		if (ridc_get(q)) {
			repeat_resp(q);
			return;
		}
		++flods_off;
		flods_stop("stop flooding", 1);
		send_ok(q);
		return;

	case DCC_AOP_FLOD_RESUME:
		if (ridc_get(q)) {
			repeat_resp(q);
			return;
		}
		if (0 >= check_load_ids(0)) {
			send_error(q, "%s", dcc_emsg);
			return;
		}
		if (flods_off) {
			flods_off = 0;
			flods_restart("resume flooding", 0);
		}
		send_ok(q);
		flods_ck(0);
		return;

	case DCC_AOP_FLOD_REWIND:
		if (ridc_get(q)) {
			repeat_resp(q);
			return;
		}
		if (flod_mmaps) {
			loaded = 0;
		} else if (!load_flod(0, 0)) {
			send_error(q, "too busy to rewind floods");
			return;
		} else {
			loaded = 1;
		}
		found_it = (arg == DCC_ID_INVALID);
		for (mp = flod_mmaps->mmaps;
		     mp <= LAST(flod_mmaps->mmaps);
		     ++mp) {
			if (arg == DCC_ID_INVALID
			    || mp->rem_id == arg) {
				mp->flags |= FLODMAP_FG_NEED_RWD;
				mp->flags &= ~FLODMAP_FG_FFWD_IN;
				dcc_trace_msg("rewind flood from server-ID %d",
					      arg);
				found_it = 1;
			}
		}
		if (!found_it) {
			send_error(q, "unknown server-ID %d for %s",
				   arg, qop2str(q));
		} else {
			send_ok(q);
			flods_ck(0);
		}
		if (loaded)
			oflods_clear();
		return;

	case DCC_AOP_FLOD_LIST:
		loaded = !flod_mmaps && load_flod(1, 0);
		if (flod_mmaps) {
			print_len = flods_list(check.val.string,
					       sizeof(check.val.string),
					       (q->flags & Q_FG_TRUSTED)==0);
		} else {
			/* it is not an error if map is locked, because
			 * dbclean uses this operation to see if we are
			 * listening */
			print_len = snprintf(check.val.string,
					     ISZ(check.val.string),
					     "too busy to list floods");
			if (print_len >= ISZ(check.val.string))
				print_len = ISZ(check.val.string)-1;
		}
		check.hdr.len = (print_len
				 + sizeof(check)-sizeof(check.val));
		check.hdr.op = DCC_OP_ADMN;
		send_resp(q, &check.hdr, 0);
		if (loaded)
			oflods_clear();
		return;

	case DCC_AOP_FLOD_STATS:
	case DCC_AOP_FLOD_STATS_CLEAR:
		print_len = flod_stats(check.val.string,
				       sizeof(check.val.string),
				       arg,
				       fop == DCC_AOP_FLOD_STATS_CLEAR);
		if (print_len < 0) {
			send_error(q, "too busy to find flood stats");
			return;
		}
		check.hdr.len = print_len + sizeof(check)-sizeof(check.val);
		check.hdr.op = DCC_OP_ADMN;
		send_resp(q, &check.hdr, 0);
		flods_ck(0);
		return;

	case DCC_AOP_FLOD_FFWD_IN:
	case DCC_AOP_FLOD_FFWD_OUT:
		if (ridc_get(q)) {
			repeat_resp(q);
			return;
		}
		if (flod_mmaps) {
			loaded = 0;
		} else if (!load_flod(0, 0)) {
			send_error(q, "too busy to fast-forward floods");
			return;
		} else {
			loaded = 1;
		}
		ofp = oflods.infos;
		for (;;) {
			mp = ofp->mp;
			if (mp && mp->rem_id == arg) {
				/* found the target */
				if (fop == DCC_AOP_FLOD_FFWD_OUT) {
					ofp->cur_pos = db_csize;
					if (ofp->soc < 0)
					    mp->confirm_pos = db_csize;
					dcc_trace_msg("fast forward flood to %s",
						      ofp->rem_hostname);
				} else {
					mp->flags |= FLODMAP_FG_FFWD_IN;
					mp->flags &= ~FLODMAP_FG_NEED_RWD;
				}
				send_ok(q);
				if (!loaded)
					flods_ck(0);
				break;
			}
			if (++ofp > LAST(oflods.infos)) {
				send_error(q, "unknown server-ID %d for %s",
					   arg, qop2str(q));
				break;
			}
		}
		if (loaded)
			oflods_clear();
		return;
	}

	send_error(q, "unrecognized %s value %d", qop2str(q), fop);
}



void
stats_clear(void)
{
	OFLOD_INFO *ofp;

	memset(&dccd_stats, 0, sizeof(dccd_stats));
	for (ofp = oflods.infos; ofp <= LAST(oflods.infos); ++ofp) {
		if (ofp->rem_hostname[0] == '\0')
			continue;

		/* The counts reported to `cdcc stats` are sums
		 * of the dccd_stats and ofp->cnts values.  Bias
		 * the dccd_stats values by the current ofp->cnts values
		 * so the reported counts will be zero.  When the flooding
		 * connection is closed, the ofp->cnts values will be added
		 * to the dccd_stats values. */
		dccd_stats.iflod_total -= ofp->cnts.total;
		dccd_stats.iflod_accepted -= ofp->cnts.accepted;
		dccd_stats.iflod_stale -= ofp->lc.stale.cur;
		dccd_stats.iflod_dup -= ofp->lc.dup.cur;
		dccd_stats.iflod_wlist -= ofp->lc.wlist.cur;
		dccd_stats.iflod_not_deleted -= ofp->lc.not_deleted.cur;
	}

	q_delays_start = 0;

	memset(&db_stats, 0, sizeof(db_stats));
	dccd_stats.reset = db_time.tv_sec;
}



static u_char				/* 1=sent 0=something wrong */
stats_send(QUEUE *q)
{
	DCC_ADMN_RESP stats;
	char tbuf[80];
	OFLOD_INFO *ofp;
	IFLOD_INFO *ifp;
	int oflods_connecting, iflods_connecting;
	DCC_SCNTR iflod_total, iflod_accepted, iflod_stale;
	DCC_SCNTR iflod_dup, iflod_wlist, iflod_not_deleted;
	char flod_buf[60];
	char clients_reset[40], reset_buf[36], now_buf[36];
	int clients;
	int age;
	const char *client_ovf;
	int blen, plen, len;

	tbuf[0] = '\0';
	if (TMSG_BIT(ADMN))
		strcat(tbuf, "ADMN ");
	if (TMSG_BIT(ANON))
		strcat(tbuf, "ANON ");
	if (TMSG_BIT(CLNT))
		strcat(tbuf, "CLNT ");
	if (TMSG_BIT(RLIM))
		strcat(tbuf, "RLIM ");
	if (TMSG_BIT(QUERY))
		strcat(tbuf, "QUERY ");
	if (TMSG_BIT(RIDC))
		strcat(tbuf, "RIDC ");
	if (TMSG_BIT(FLOD1))
		strcat(tbuf, "FLOOD1 ");
	if (TMSG_BIT(FLOD2))
		strcat(tbuf, "FLOOD2 ");
/*	if (TMSG_BIT(xxx))
		strcat(tbuf, "xxx "); */
	if (TMSG_BIT(BL))
		strcat(tbuf, "BL ");
	if (TMSG_BIT(DB))
		strcat(tbuf, "DB ");
	if (TMSG_BIT(WLIST))
		strcat(tbuf, "WLIST ");

	clients = clients_get(0, 0, 0, 0, 0, 0, DCC_ID_INVALID);
	if (clients >= 0) {
		client_ovf = "";
	} else {
		client_ovf = ">";
		clients = -clients;
	}
	age = db_time.tv_sec - clients_cleared;
	if (age <= 24*60*60) {
		dcc_time2str(clients_reset, sizeof(clients_reset),
			     "since %X", clients_cleared);
	} else if (age <= 3*24*60*60) {
		snprintf(clients_reset, sizeof(clients_reset),
			 "in %d hours", (age + 60*60/2) / (60*60));
	} else {
		snprintf(clients_reset, sizeof(clients_reset),
			 "in %d days", (age + 24*60*60/2) / (24*60*60));
	}

	oflods_connecting = 0;
	iflod_total = dccd_stats.iflod_total;
	iflod_accepted = dccd_stats.iflod_accepted;
	iflod_stale = dccd_stats.iflod_stale;
	iflod_dup = dccd_stats.iflod_dup;
	iflod_wlist = dccd_stats.iflod_wlist;
	iflod_not_deleted = dccd_stats.iflod_not_deleted;
	for (ofp = oflods.infos; ofp <= LAST(oflods.infos); ++ofp) {
		if (ofp->soc >= 0 && !(ofp->flags & OFLOD_FG_CONNECTED))
			++oflods_connecting;
		iflod_total += ofp->cnts.total;
		iflod_accepted += ofp->cnts.accepted;
		iflod_stale += ofp->lc.stale.cur;
		iflod_dup += ofp->lc.dup.cur;
		iflod_wlist += ofp->lc.wlist.cur;
		iflod_not_deleted += ofp->lc.not_deleted.cur;
	}
	iflods_connecting = 0;
	for (ifp = iflods.infos; ifp <= LAST(iflods.infos); ++ifp) {
		if (ifp->soc >= 0 && !(ifp->flags & IFLOD_FG_VERS_CK))
			++iflods_connecting;
	}
	dcc_time2str(reset_buf, sizeof(reset_buf),"%b %d %X",
		     dccd_stats.reset);
	dcc_time2str(now_buf, sizeof(now_buf), "%b %d %X %Z",
		     db_time.tv_sec);

	blen = min(sizeof(stats.val.string), ntohl(q->pkt.ad.val1));
	plen = snprintf(stats.val.string, blen,
	    "    version "DCC_VERSION"  %s%s%stracing %s\n"
	    "%7d hash entries %6d used "L_DWPAT(9)" DB bytes\n"
	    "%5d ms delay  "L_DPAT" NOPs  "L_DPAT""
	    " ADMN  "L_DPAT" query  %s%d clients %s\n",

	    dbclean_running ? "DB UNLOCKED  " : "",
	    query_only ? "Q-mode  " : "",
	    grey_on ? "greylist  " : "",
	    tbuf[0] ? tbuf : "nothing",

	    ADJ_HLEN(db_hash_len), ADJ_HLEN(db_hash_used), db_csize,

	    avg_q_delay_ms(q),

	    dccd_stats.nops, dccd_stats.admin, dccd_stats.queries,
	    client_ovf, clients, clients_reset);
	if (plen >= blen)
		plen = blen-1;
	blen -= plen;

	if (grey_on) {
		len = snprintf(&stats.val.string[plen], blen,
	    L_DWPAT(7)" reports "L_DWPAT(2)" whitelisted\n",

	    dccd_stats.reports,
	    dccd_stats.respwhite);

	} else {
		len = snprintf(&stats.val.string[plen], blen,
			       L_DWPAT(8)" reports "
			       L_DWPAT(7)">10 "
			       L_DWPAT(7)">100 "
			       L_DWPAT(7)">1000 "
			       L_DWPAT(7)" many\n"
			       "         answers "L_DWPAT(7)">10 "
			       L_DWPAT(7)">100 "
			       L_DWPAT(7)">1000 "
			       L_DWPAT(7)" many\n",

	    dccd_stats.reports,
	    (dccd_stats.report10 + dccd_stats.report100
	     + dccd_stats.report1000 + dccd_stats.reportmany),
	    (dccd_stats.report100 + dccd_stats.report1000
	     + dccd_stats.reportmany),
	    dccd_stats.report1000 + dccd_stats.reportmany,
	    dccd_stats.reportmany,

	    (dccd_stats.resp10 + dccd_stats.resp100
	     + dccd_stats.resp1000 + dccd_stats.respmany),
	    dccd_stats.resp100 + dccd_stats.resp1000 + dccd_stats.respmany,
	    dccd_stats.resp1000 + dccd_stats.respmany,
	    dccd_stats.respmany);
	}
	if (len >= blen)
		len = blen-1;
	blen -= len;
	plen += len;

	len = snprintf(&stats.val.string[plen], blen,
	    L_DWPAT(8)" bad op "
	    L_DWPAT(4)" passwd "
	    L_DWPAT(6)" blist "
	    L_DWPAT(4)" reject "
	    L_DWPAT(6)" retrans\n",
	    dccd_stats.bad_op, dccd_stats.bad_passwd, dccd_stats.blist,
	    dccd_stats.send_error,  dccd_stats.report_retrans);
	if (len >= blen)
		len = blen-1;
	blen -= len;
	plen += len;

	if (!grey_on) {
		len = snprintf(&stats.val.string[plen], blen,
	    L_DWPAT(8)" answers rate-limited "
	    L_DWPAT(4)" anon "
	    L_DWPAT(5)" reports rejected\n",
	    dccd_stats.rl, dccd_stats.anon_rl,  dccd_stats.report_reject);
		if (len >= blen)
			len = blen-1;
		blen -= len;
		plen += len;
	}

	len = snprintf(&stats.val.string[plen], blen,
	    "    %s "
	    L_DWPAT(8)" total flooded in\n"
	    L_DWPAT(8)" accepted "
	    L_DWPAT(6)" stale "
	    L_DWPAT(8)" dup  "
	    L_DWPAT(5)" white    "
	    L_DPAT" delete\n"
	    L_DWPAT(8)" reports added between %s and %s",
	    flod_stats_printf(flod_buf, sizeof(flod_buf),
			      (dbclean_running || flods_st == FLODS_ST_OFF) ? 0
			      : (flods_st != FLODS_ST_ON) ? 1
			      : 2,
			      oflods.total,
			      oflods.open - oflods_connecting,
			      iflods.open - iflods_connecting),
	    iflod_total,
	    iflod_accepted, iflod_stale, iflod_dup,
	    iflod_wlist, iflod_not_deleted,

	    dccd_stats.adds+db_stats.adds, reset_buf, now_buf);
	if (len >= blen)
		len = blen-1;
	blen -= len;
	plen += len;

	if (!grey_on) {
		len = snprintf(&stats.val.string[plen], blen,
			       "\n"L_DWPAT(8)" no rep "
			       L_DWPAT(5)">0%% "
			       L_DWPAT(5)">10%% "
			       L_DWPAT(5)">20%% "
			       L_DWPAT(5)">30%% "
			       L_DWPAT(5)">60%%"
			       " bad "L_DPAT,
			       dccd_stats.norep,
			       (dccd_stats.rep1 + dccd_stats.rep10
				+ dccd_stats.rep20 + dccd_stats.rep30
				+ dccd_stats.rep60),
			       (dccd_stats.rep10 + dccd_stats.rep20
				+ dccd_stats.rep30 + dccd_stats.rep60),
			       dccd_stats.rep20 + dccd_stats.rep30
			       + dccd_stats.rep60,
			       dccd_stats.rep30 + dccd_stats.rep60,
			       dccd_stats.rep60,
			       dccd_stats.report_reps);
		if (len >= blen)
			len = blen-1;
		blen -= len;
		plen += len;
	}

	stats.hdr.len = plen + sizeof(stats)-sizeof(stats.val);
	stats.hdr.op = DCC_OP_ADMN;
	send_resp(q, &stats.hdr, 0);
	return 1;
}



static void
timestamp_send(const QUEUE *q)
{
	time_t delta;
	DCC_ADMN_RESP msg;
	int blen, plen;

	delta = picky_time(q);

	blen = min(sizeof(msg.val.string), ntohl(q->pkt.ad.val1));
	if (delta < -MAX_CMD_CLOCK_SKEW || delta > MAX_CMD_CLOCK_SKEW) {
		if (delta < -MAX_FLOD_CLOCK_SKEW
		    || delta > MAX_FLOD_CLOCK_SKEW) {
			plen = snprintf(msg.val.string, blen,
					"    clocks differ by about %d seconds"
					"\n    which is more than the"
					" %d allowed for flooding",
					(int)delta, MAX_FLOD_CLOCK_SKEW);
		} else {
			plen = snprintf(msg.val.string, blen,
					"    clocks differ by about %d seconds"
					"\n    which is more than the"
					" %d allowed for commands",
					(int)delta, MAX_CMD_CLOCK_SKEW);
		}
	} else {
		plen = snprintf(msg.val.string, blen,
				"    clocks differ by about %d seconds",
				(int)delta);
	}
	if (plen >= blen)
		plen = blen-1;

	msg.hdr.len = plen + sizeof(msg)-sizeof(msg.val);
	msg.hdr.op = DCC_OP_ADMN;
	send_resp(q, &msg.hdr, 0);
}



void
do_nop(QUEUE *q, DCC_CLNT_ID id)
{
	/* respond immediately to even anonymous NOPs so that clients
	 * that are confused about passwords and whether they are anonymous
	 * do not retransmit unnecessarily */
	TMSG_OP(ADMN, q);
	++dccd_stats.nops;

	if (!ck_clnt_srvr_id(q, id, anon_off)) {
		++q->ip_rl->d.nops;
		if (q->block_rl)
			++q->block_rl->d.nops;
		return;
	}

	++q->ip_rl->d.nops;
	if (q->block_rl)
		++q->block_rl->d.nops;
	send_ok(q);
}



/* deal with an adminstative request */
void
do_admn(QUEUE *q, DCC_CLNT_ID id)
{
	u_int32_t val1;
	DCC_ADMN_RESP resp;
	int len, offset;
	u_int32_t adelay_ms;
	struct in6_addr addr6;
	u_int val5_len;
	DCC_IP_RANGE tgt_range, *tgt_rangep;
	DCC_CLNT_ID tgt_id;

	val1 = ntohl(q->pkt.ad.val1);
	if (TMSG_BIT(ADMN) && !(q->flags & Q_FG_TRACED)) {
		if (!(q->flags & Q_FG_HAVE_TS)) {
			new_ts(&q->ts);
			q->flags |= Q_FG_HAVE_TS;
		}
		dcc_trace_msg("received val2=%#x val3=%#x in %s",
			      q->pkt.ad.val2, q->pkt.ad.val3, op_id_ip(q));
		q->flags |= Q_FG_TRACED;
	}

	++dccd_stats.admin;

	if (!ck_clnt_srvr_id(q, id, anon_off))
		return;

	val5_len = q->pkt_len - DCC_ADMN_REQ_MIN_SIZE;
	if (val5_len != 0
	    && val5_len <= DCC_MAX_ADMN_REQ_VAL5
	    && ((val5_len != sizeof(DCC_AOP_CLIENTS_VAL5_TGT_ADDR)
		 && val5_len != sizeof(DCC_AOP_CLIENTS_VAL5))
		|| (q->pkt.ad.aop != DCC_AOP_CLIENTS
		    && q->pkt.ad.aop != DCC_AOP_CLIENTS_ID))) {
		send_error(q, "%s size = %d", qop2str(q), q->pkt_len);
		return;
	}

	switch ((DCC_AOPS)q->pkt.ad.aop) {
	case DCC_AOP_STOP:		/* stop gracefully */
		if (!picky_admn(q, 0, 0))
			return;
		if (ridc_get(q)) {
			repeat_resp(q);
			return;
		}
		if (!stopint) {
			stopint = -1;
			if (val1 != 0)
				stop_mode = val1;
			next_flods_ck = 0;
		}
		send_ok(q);
		return;

	case DCC_AOP_FLOD:		/* control flooding */
		do_flod(q);
		return;

	case DCC_AOP_DB_CLEAN:		/* start switch to new database */
		if (!picky_admn(q, 0, 0))
			return;
		/* repeat previous response to repeated question */
		if (ridc_get(q)) {
			repeat_resp(q);
			return;
		}
		if (!flods_off || oflods.total != 0) {
			send_error(q, "flooding not stopped before %s",
				   qop2str(q));
			return;
		}
		send_ok(q);		/* asnwer now before we stall */
		dcc_trace_msg("database cleaning begun");
		next_flods_ck = 0;
		/* don't start our own cleaning */
		del_dbclean_next = db_time.tv_sec + DEL_DBCLEAN_SECS;
		dbclean_limit = db_time.tv_sec + dbclean_limit_secs;
		/* Dbclean expects us to remove its separate hold on flooding
		 * so that it will not need to talk to us after telling us
		 * to close the old database.  This because we might stall
		 * on some systems with lame mmap() support including BSD/OS,
		 * for minutes in close().
		 * It might be nice to be able to turn off flooding before
		 * dbclean is run and have it remain off when dbclean
		 * finishes.  However, the need for that is very rare
		 * and there are mysterious cases where flooding gets
		 * turned off by dbclean and never restored. */
		flods_off = 0;
		/* release and unmap buffers, possibly stalling */
		dbclean_running = 1;
		db_unload(0, DB_UNLOAD_ENOUGH);
		if (need_clients_save > db_time.tv_sec + CLIENTS_QUICK_SAVE)
			need_clients_save = db_time.tv_sec + CLIENTS_QUICK_SAVE;
		return;

	case DCC_AOP_DB_NEW:		/* finish switch to new database */
		if (!picky_admn(q, 0, 0))
			return;
		if (ridc_get(q)) {
			repeat_resp(q);
			return;
		}
		if (!dbclean_running) {
			send_error(q, "%s received before %s",
				   qop2str(q),
				   dcc_aop2str(0, 0, DCC_AOP_DB_CLEAN, 0));
			return;
		}
		/* send "ok" now because we may stall waiting to reopen */
		send_ok(q);
		db_close(DB_CLOSE_NEW_DB);
		dccd_stats.adds += db_stats.adds;
		if (!dccd_db_open(DB_OPEN_LOCK_WAIT))
			dcc_logbad(emsg_ex_code(&dcc_emsg),
				   "could not restart database %s: %s",
				   db_nm_path.c, dcc_emsg.c);
		flods_off = 0;
		/* get IDs before we resume flooding */
		if (0 >= check_load_ids(2))
			dcc_error_msg("%s", dcc_emsg.c);
		flods_restart("database reopened", 0);
		next_flods_ck = 0;	/* possibly reap dbclean child */
		dcc_trace_msg(DCC_VERSION" database %s reopened",
			      db_nm_path.c);
		return;

	case DCC_AOP_STATS:		/* return counters */
		/* we cannot just repeat ourselves for retransmissions,
		 * because the answer is too big to save */
		stats_send(q);
		return;

	case DCC_AOP_STATS_CLEAR:	/* return and then zero counters */
		if (!picky_admn(q, 0, 0))
			return;
		/* we cannot just repeat ourselves for retransmissions,
		 * because the answer is too big to save */
		if (stats_send(q)) {
			clients_clear();
			stats_clear();
		}
		return;

	case DCC_AOP_TRACE_ON:
	case DCC_AOP_TRACE_OFF:
		if (!picky_admn(q, 0, 0))
			return;
		/* it is idempotent, but suppress duplicate trace messages */
		if (ridc_get(q)) {
			repeat_resp(q);
			return;
		}
		/* log trace changes even when tracing is off */
		if (!(DCC_TRACE_ADMN_BIT & tracemask))
			dcc_trace_msg("received %s", op_id_ip(q));
		if ((val1 & ~DCC_TRACE_BITS) != 0 || val1 == 0) {
			send_error(q, "invalid trace bits %#x", val1);
			return;
		}
		if (q->pkt.ad.aop == DCC_AOP_TRACE_OFF) {
			tracemask &= ~val1;
		} else {
			tracemask |= val1;
			/* do not suppress the next duplicated flood message */
			if (val1 & DCC_TRACE_FLOD1_BIT)
				++flod_msg_gen;
		}
		send_ok(q);
		return;

	case DCC_AOP_CLIENTS:
	case DCC_AOP_CLIENTS_ID:
		if (!picky_admn(q, 1, 1))
			return;
		/* We cannot repeat previous responses for retransmissions,
		 * because answers are not saved.  They are often too big. */
		offset = (val1 >> 16) + (((u_int)q->pkt.ad.val4) << 16);
		val1 &= DCC_ADMIN_CLIENTS_MAX_THOLD;
		len = q->pkt.ad.val2;
		/* get the target CIDR block if present */
		if (val5_len != 0
		    && q->pkt.ad.val5.clients.tgt_addr.bits != 0) {
			memcpy(&addr6, &q->pkt.ad.val5.clients.tgt_addr.addr6,
			       sizeof(addr6));
			if (!cidr2range(tgt_rangep = &tgt_range,
					&addr6,
					q->pkt.ad.val5.clients.tgt_addr.bits)) {
				char ibuf[INET6_ADDRSTRLEN+1];

				send_error(q, "invalid CIDR block %s/%d",
					   dcc_ipv6tostr(ibuf, sizeof(ibuf),
							&addr6),
					   q->pkt.ad.val5.clients.tgt_addr.bits);
				return;
			}
		} else {
			tgt_rangep = 0;
		}
		if (val5_len == sizeof(DCC_AOP_CLIENTS_VAL5)) {
			memcpy(&tgt_id, &q->pkt.ad.val5.clients.tgt_id,
			       sizeof(tgt_id));
			tgt_id = ntohl(tgt_id);
		} else {
			tgt_id = DCC_ID_INVALID;
		}
		if (q->pkt.ad.aop == DCC_AOP_CLIENTS)
			clients_get(&resp.val, &len, offset,
				    val1, q->pkt.ad.val3,
				    tgt_rangep, tgt_id );
		else
			clients_get_id(&resp.val, &len, offset,
				       val1, q->pkt.ad.val3,
				       tgt_rangep, tgt_id);
		resp.hdr.len = len + sizeof(resp)-sizeof(resp.val);
		resp.hdr.op = DCC_OP_ADMN;
		send_resp(q, &resp.hdr, 0);
		return;

	case DCC_AOP_ANON_DELAY:
		/* get and set the anonymous client delay
		 *
		 * repeat answer to identical question */
		if (ridc_get(q)) {
			repeat_resp(q);
			return;
		}
		if (anon_off)
			adelay_ms = DCC_ANON_DELAY_FOREVER;
		else
			adelay_ms = anon_delay_us/1000;
		resp.val.anon_delay.delay[0] = adelay_ms>>8;
		resp.val.anon_delay.delay[1] = adelay_ms;
		if (anon_delay_inflate == DCC_ANON_INFLATE_OFF) {
			resp.val.anon_delay.inflate[0] = 0;
			resp.val.anon_delay.inflate[1] = 0;
			resp.val.anon_delay.inflate[2] = 0;
			resp.val.anon_delay.inflate[3] = 0;
		} else {
			resp.val.anon_delay.inflate[0] = anon_delay_inflate>>24;
			resp.val.anon_delay.inflate[1] = anon_delay_inflate>>16;
			resp.val.anon_delay.inflate[2] = anon_delay_inflate>>8;
			resp.val.anon_delay.inflate[3] = anon_delay_inflate;
		}
		adelay_ms = (q->pkt.ad.val2<<8) + q->pkt.ad.val3;
		if (adelay_ms != DCC_NO_ANON_DELAY
		    && picky_admn(q, 0, 0)) {
			if (adelay_ms == DCC_ANON_DELAY_FOREVER) {
				anon_off = 1;
				anon_delay_us = DCC_ANON_DELAY_US_BLACKLIST;
				anon_delay_inflate = DCC_ANON_INFLATE_OFF;
			} else {
				anon_off = 0;
				if (adelay_ms > DCC_ANON_DELAY_MAX/1000)
					adelay_ms = DCC_ANON_DELAY_MAX/1000;
				anon_delay_us = adelay_ms*1000;
				if (val1 == 0)
					val1 = DCC_ANON_INFLATE_OFF;
				anon_delay_inflate = val1;
			}
		}
		resp.hdr.len = (sizeof(resp)-sizeof(resp.val)
				+ sizeof(resp.val.anon_delay));
		resp.hdr.op = DCC_OP_ADMN;
		send_resp(q, &resp.hdr, 0);
		return;

	case DCC_AOP_CLOCK_CHECK:
		timestamp_send(q);
		return;

	case DCC_AOP_OK:
	case DCC_AOP_unused1:
	default:
		break;
	}

	send_error(q, "invalid %s", qop2str(q));
}
