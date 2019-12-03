/* Distributed Checksum Clearinghouse
 *
 * server rate limiting
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
 * Rhyolite Software DCC 2.3.167-1.183 $Revision$
 */

#include "dccd_defs.h"


RL_RATE rl_sub_rate;
RL_RATE rl_anon_rate;
RL_RATE rl_all_anon_rate;
RL_RATE rl_bugs_rate;

static RL rl_all_anon;			/* limit all or anonymous clients */

static u_int rl_max_blocks = DCC_RL_MAX;
static u_int rl_bins, rl_blocks;
static u_int rl_probes, rl_searches;
static DCC_PTIME rl_hash_checked;
#define RL_HASH_CHECK_SECS 30
static u_char rl_too_many;

static RL *rl_newest, *rl_oldest;
static RL **rl_hash;
static struct in6_addr rl_block4_mask, rl_block6_mask;
#define RL_PREFIX_LEN(_a) (DCC_ADDR6_V4MAPPED(_a)			\
			   ? (DCC_ADMN_RESP_CLIENTS_IPV4_BITS+96)/8	\
			   : DCC_ADMN_RESP_CLIENTS_IPV6_BITS/8)


DCC_PTIME clients_cleared;

time_t need_clients_save;

typedef struct ip_bl {			/* a line from /var/dcc/blacklist */
    struct ip_bl *hfwd;
    DCC_IP_RANGE range;
    struct in6_addr mask;
    u_char	flags;
#    define	 IP_BL_OK	0x01	/* punch hole in blacklist */
#    define	 IP_BL_BAD	0x02	/* bad actor */
#    define	 IP_BL_ANON	0x04	/* bad only if anonymous */
#    define	 IP_BL_TRACE    0x08
#    define	 IP_BL_FLOD_OK	0x10
} IP_BL;
static IP_BL *ip_bl_hash[251];

static void clients_load(void);



/* Hash individual addresses into the same bucket as their enclosing
 * IPv4 /16 or IPv6 /48 blocks. */
static IP_BL **
bl_hash_fnc(const struct in6_addr *addr)
{
	u_long sum;

	if (DCC_ADDR6_V4MAPPED(addr)) {
		sum = ntohl(addr->s6_addr32[3]) & 0xffff0000;
	} else {
		sum = addr->s6_addr32[0];
		sum += ntohl(addr->s6_addr32[1]) & 0xffff0000;
	}
	sum %= DIM(ip_bl_hash);
	return &ip_bl_hash[sum];
}



/* clear the IP address blacklist */
static void
clear_bl(void)
{
	IP_BL *bl, **hash;
	RL *rl;

	/* empty the blacklist */
	for (hash = ip_bl_hash; hash <= LAST(ip_bl_hash); ++hash) {
		while ((bl = *hash) != 0) {
			*hash = bl->hfwd;
			dcc_free(bl);
		}
	}

	/* all clients must be checked again */
	for (rl = rl_newest; rl != 0; rl = rl->older) {
		rl->d.fgs &= ~RL_FG_BLACK_SET;
	}
}



static int
ck_bl_word(const char **pp, const char *word, size_t len)
{
	const char *p;

	p = *pp;
	if (strncasecmp(p, word, len))
		return 0;
	p += len;
	len = strspn(p, ", \t");
	if (len == 0)
		return 0;
	*pp = p + len;
	return 1;
}



void
check_blacklist_file(void)
{
#define BL_NM "blacklist"
	DCC_FNM_LNO_BUF fnm_buf;
	static time_t prev_mtime, next_msg;
#define BL_RECHECK (2*60*60)
	static enum {CK_BL_STAT, CK_BL_FOPEN, CK_BL_FSTAT, CK_BL_FGETS} fnc;
	static int serrno;
	struct stat sb;
	FILE *f;
	char buf[180];
	IP_BL *bl, **hash;
	DCC_IP_RANGE range;
	u_char flags;
	char *p;
	const char *cp;
	int lno, entries, i;

	/* see if the file has changed */
	if (0 > stat(BL_NM, &sb)) {
		if (errno != ENOENT) {
			prev_mtime = 1;
			if (fnc != CK_BL_STAT
			    || serrno != errno
			    || DB_IS_TIME(next_msg, BL_RECHECK)) {
				dcc_error_msg("stat(%s): %s",
					      DB_NM2PATH_ERR(BL_NM),
					      ERROR_STR());
			}

		} else if (prev_mtime != 0) {
			prev_mtime = 0;
			next_msg = 0;
			dcc_error_msg("%s disappeared", DB_NM2PATH_ERR(BL_NM));
		}
		fnc = CK_BL_STAT;
		serrno = errno;
		next_msg = db_time.tv_sec + BL_RECHECK;
		clear_bl();
		return;
	}
	if (prev_mtime == sb.st_mtime
	    && (next_msg == 0 || !DB_IS_TIME(next_msg, BL_RECHECK)))
		return;

	/* the file has changed, so parse it */
	clear_bl();
	f = fopen(BL_NM, "r");
	if (!f) {
		if (fnc != CK_BL_FOPEN
		    || serrno != errno
		    || DB_IS_TIME(next_msg, BL_RECHECK))
			dcc_error_msg("fopen(%s): %s",
				      DB_NM2PATH_ERR(BL_NM), ERROR_STR());
		fnc = CK_BL_FOPEN;
		serrno = errno;
		next_msg = db_time.tv_sec + BL_RECHECK;
		prev_mtime = 1;
		return;
	}
	if (0 > fstat(fileno(f), &sb)) {
		if (fnc != CK_BL_STAT
		    || serrno != errno
		    || DB_IS_TIME(next_msg, BL_RECHECK))
			dcc_error_msg("fstat(%s): %s",
				      DB_NM2PATH_ERR(BL_NM), ERROR_STR());
		fnc = CK_BL_FSTAT;
		serrno = errno;
		next_msg = db_time.tv_sec + BL_RECHECK;
		prev_mtime = 1;
		return;
	}
	prev_mtime = sb.st_mtime;
	next_msg = 0;
	fnc = CK_BL_FGETS;
	serrno = 0;

	entries = 0;
	for (lno = 1; ; ++lno) {
		if (!fgets(buf, sizeof(buf), f)) {
			if (ferror(f)) {
				dcc_error_msg("fgets(%s): %s",
					      DB_NM2PATH_ERR(BL_NM),
					      ERROR_STR());
			}
			break;
		}
		/* reject lines that are too long */
		i = strlen(buf);
		if (buf[i-1] != '\n') {
			dcc_error_msg("syntax error%s",
				      dcc_fnm_lno(&fnm_buf,
						  DB_NM2PATH_ERR(BL_NM), lno));
			break;
		}

		/* ignore comments and blank lines */
		p = strchr(buf, '#');
		if (p)
			*p = '\0';
		cp = buf;
		cp += strspn(cp, DCC_WHITESPACE);
		if (*cp == '\0')
			continue;

		flags = 0;
		for (;;) {
			if (ck_bl_word(&cp, "trace", LITZ("trace"))) {
				flags |= IP_BL_TRACE;
				continue;
			}
			if (ck_bl_word(&cp, "ok", LITZ("ok"))) {
				flags &= ~IP_BL_BAD;
				flags |= IP_BL_OK;
				continue;
			}
			if (ck_bl_word(&cp, "bad", LITZ("bad"))) {
				flags |= IP_BL_BAD;
				continue;
			}
			if (ck_bl_word(&cp, "no-anon", LITZ("no-anon"))
			    || ck_bl_word(&cp, "no-anon", LITZ("no_anon"))) {
				flags |= IP_BL_ANON;
				continue;
			}
			if (ck_bl_word(&cp, "flod_ok", LITZ("flod_ok"))
			    || ck_bl_word(&cp, "flod-ok", LITZ("flod-ok"))
			    || ck_bl_word(&cp, "flood_ok", LITZ("flood_ok"))
			    || ck_bl_word(&cp, "flood-ok", LITZ("flood-ok"))) {
				flags |= IP_BL_FLOD_OK;
				continue;
			}
		      break;
		}
		if (!(flags & (IP_BL_OK | IP_BL_BAD | IP_BL_ANON))) {
			flags |= IP_BL_BAD;
		} else if ((flags & IP_BL_OK)
			   && (flags & (IP_BL_BAD | IP_BL_ANON))) {
			dcc_error_msg("conflicting \"OK\" and"
				      " \"BAD\" or \"NO-ANON\"%s",
				      dcc_fnm_lno(&fnm_buf,
						  DB_NM2PATH_ERR(BL_NM), lno));
			flags &= ~(IP_BL_BAD | IP_BL_ANON);
		}

		i = str2range(&dcc_emsg, &range, 0, cp, BL_NM, lno);
		if (i <= 0) {
			if (i < 0)
				dcc_error_msg("%s", dcc_emsg.c);
			else
				dcc_error_msg("syntax error%s",
					      dcc_fnm_lno(&fnm_buf,
							DB_NM2PATH_ERR(BL_NM),
							lno));
			continue;
		}

		/* The hash function assumes no entries are larger than
		 * an IPv4 /16 or IPv6 /48 block. */
		if ((DCC_ADDR6_V4MAPPED(&range.lo)
		     && memcmp(&range.lo, &range.hi, 14))
		    || (!DCC_ADDR6_V4MAPPED(&range.lo)
			&& memcmp(&range.lo, &range.hi, 6))) {
			dcc_error_msg("block too large%s",
				      dcc_fnm_lno(&fnm_buf,
						  DB_NM2PATH_ERR(BL_NM), lno));
			continue;
		}

		bl = dcc_malloc(sizeof(*bl));
		bl->range = range;
		bl->flags = flags;
		hash = bl_hash_fnc(&range.lo);
		bl->hfwd = *hash;
		*hash = bl;

		if (++entries == (DIM(ip_bl_hash)*9)/10) {
			dcc_error_msg("too many entries%s",
				      dcc_fnm_lno(&fnm_buf,
						  DB_NM2PATH_ERR(BL_NM), lno));
		}
	}
	fclose(f);

	if (entries)
		dcc_trace_msg("read %d entries from %s",
			      entries, DB_NM2PATH_ERR(BL_NM));

#undef BL_NM
#undef BL_RECHECK
}



/* unlink leaving invalid pointers in the block */
static inline void
rl_hash_unlink(RL *rl)
{
	if (rl->hfwd)
		rl->hfwd->hbak = rl->hbak;
	if (rl->hbak) {
		rl->hbak->hfwd = rl->hfwd;
	} else if (rl->bin) {
		*rl->bin = rl->hfwd;
	}
}



/* link a rate limit block into the head of its hash bin */
static inline void
rl_hash_link(RL *rl, RL **new_bin)
{
	/* quit if nothing to do */
	if (*new_bin == rl)
		return;

	rl_hash_unlink(rl);

	rl->hbak = 0;
	rl->bin = new_bin;
	if ((rl->hfwd = *new_bin) != 0)
		rl->hfwd->hbak = rl;
	*new_bin = rl;
}



/* Hash only the IP block address so that all rate limit blocks for
 * the IP address are in the same bucket */
static RL **
rl_hash_fnc(const struct in6_addr *addr)
{
	u_long sum;

	if (DCC_ADDR6_V4MAPPED(addr)) {
		sum = addr->s6_addr32[3] & rl_block4_mask.s6_addr32[3];
	} else {
		sum = addr->s6_addr32[0] & rl_block6_mask.s6_addr32[0];
		sum += addr->s6_addr32[1] & rl_block6_mask.s6_addr32[1];
		sum += addr->s6_addr32[2] & rl_block6_mask.s6_addr32[2];
		sum += addr->s6_addr32[3] & rl_block6_mask.s6_addr32[3];
	}
	sum %= rl_bins;
	return &rl_hash[sum];
}



static void
rl_make_blocks(u_int new_blocks)
{
	static time_t complained;
	RL *rl;
	u_int n;
	double rate;

	/* create a bunch of rate limit blocks */
	if (new_blocks == 0)
		new_blocks = rl_blocks/2;
	if (new_blocks < DCC_RL_INIT)
		new_blocks = DCC_RL_INIT;

	if (rl_blocks+new_blocks > rl_max_blocks) {
		if (rl_blocks > rl_max_blocks)
			dcc_logbad(EX_SOFTWARE,
				   "%d impossible # of RL blocks", rl_blocks);
		new_blocks = rl_max_blocks - rl_blocks;
	}

	rate = rl_probes;
	if (rl_searches != 0)
		rate /= rl_searches;
	if (new_blocks == 0) {
		if (DB_IS_TIME(complained, 24*60*60)) {
			dcc_trace_msg("cannot increase %d RL blocks with"
				      " %d bins;" " average search length %.1f",
				      rl_blocks, rl_bins, rate);
			complained = db_time.tv_sec + 24*60*60;
		}
		return;
	}
	if (db_debug && rl_blocks != 0) {
		dcc_trace_msg("increase from %d to %d RL blocks with"
			      " %d bins;" " average search length %.1f",
			      rl_blocks, rl_blocks+new_blocks,
			      rl_bins, rate);
	}

	rl = dcc_malloc(new_blocks*sizeof(*rl));
	if (!rl)
		dcc_logbad(EX_OSERR, "malloc(%d RL blocks) failed", new_blocks);
	memset(rl, 0, new_blocks*sizeof(*rl));

	/* make the new blocks oldest */
	n = 0;
	if (!rl_oldest) {
		rl_oldest = rl_newest = rl;
		++rl;
		++n;
	}
	while (n < new_blocks) {
		rl_oldest->older = rl;
		rl->newer = rl_oldest;
		rl_oldest = rl;
		 ++rl;
		 ++n;
	}

	rl_blocks += new_blocks;

}



static inline void
rl_chain_check_reset(void)
{
	rl_probes = 0;
	rl_searches = 0;
	rl_hash_checked = db_time.tv_sec + RL_HASH_CHECK_SECS;
}



static void
rl_expand_hash(void)
{
	static time_t complained;
	u_int old_bins;
	RL *rl, **old_hash, **bin;
	double rate;

	old_hash = rl_hash;
	old_bins = rl_bins;

	rl_bins += max(20, old_bins/8);
	if (rl_bins < rl_blocks/2)
		rl_bins = rl_blocks/2;
	if (rl_bins > rl_max_blocks*2)
		rl_bins = rl_max_blocks*2;
	rl_bins = hash_divisor(rl_bins, 0);

	rate = rl_probes;
	if (rl_searches != 0)
		rate /= rl_searches;
	if (rl_bins == old_bins) {
		if (DB_IS_TIME(complained, 24*60*60)) {
			dcc_trace_msg("cannot increase %d RL bins for"
				      " %d blocks; average search length %.1f",
				      old_bins, rl_blocks, rate);
			complained = db_time.tv_sec + 24*60*60;
		}
		return;
	}
	if (old_hash && db_debug) {
		dcc_trace_msg("increase from %d to %d RL bins for"
			      " %d blocks; average search length %.1f",
			      old_bins, rl_bins, rl_blocks, rate);
	}

	rl_hash = dcc_malloc(rl_bins*sizeof(*rl_hash));
	if (!rl_hash)
		dcc_logbad(EX_OSERR, "malloc(%d RL hash table) failed", rl_bins);
	memset(rl_hash, 0, rl_bins*sizeof(RL *));

	/* copy the active blocks to the new hash table of bins */
	if (old_hash) {
		for (rl = rl_oldest; rl; rl = rl->newer) {
			if (!rl->bin)
				continue;
			bin = rl_hash_fnc(&rl->d.addr);
			rl_hash_link(rl, bin);
		}
		dcc_free(old_hash);
	}

	rl_chain_check_reset();
}



void
rl_init(void)
{
	bits2mask(&rl_block4_mask, DCC_ADMN_RESP_CLIENTS_IPV4_BITS+96);
	bits2mask(&rl_block6_mask, DCC_ADMN_RESP_CLIENTS_IPV6_BITS);

	/* Public servers can have more than 1,000,000 clients.
	 * Public servers need at least 4 GByte of RAM and so 2 GByte
	 * of maximum resident set sizes. */
	if (rl_max_blocks == 0) {
		if (db_max_rss/(1024*1024) <= 1024) {
			rl_max_blocks = queue_max*2;
		} else if ((db_max_rss+1024*1024-1)/(1024*1024) <= 2*1024) {
			rl_max_blocks = 50*queue_max;
		} else {
			rl_max_blocks = 500*queue_max;
		}
		if (rl_max_blocks > DCC_RL_MAX_MAX)
			rl_max_blocks = DCC_RL_MAX_MAX;
	}

	clients_load();

	if (rl_bins == 0) {
		rl_make_blocks(0);
		rl_expand_hash();
	}
}



/* get a free, preferably stale rate limit block */
static RL *				/* block to use or 0 to make more */
rl_get_stale(void)
{
	RL *rl, *rl2;
	DCC_PTIME stale;

	/* find the oldest free block */
	rl = rl_oldest;
	for (;;) {
		/* Make the pool at least as large as the queue so that
		 * there is always at least one free block. */
		if (rl == 0) {
			rl_make_blocks(0);
			memset(&rl_oldest->d, 0, sizeof(rl_oldest->d));
			return rl_oldest;
		}
		if (rl->ref_cnt == 0)
			break;
		rl = rl->newer;
	}

	/* Use the oldest free block if it has never been used
	 * or is ancient. */
	stale = db_time.tv_sec;
	if (rl_blocks < rl_max_blocks)
		stale -= CLIENTS_SAVE_AGE;
	else
		stale -= RL_LIFE_SECS;
	if (rl->d.last_used < stale) {
		memset(&rl->d, 0, sizeof(rl->d));
		return rl;
	}

	/* make more if the oldest is new and we don't have too many */
	if (rl_blocks < rl_max_blocks) {
		rl_make_blocks(0);
		memset(&rl_oldest->d, 0, sizeof(rl_oldest->d));
		return rl_oldest;
	}

	/* Recycle a block. We cannot make more because we have too many.
	 *
	 * Try to find an old, little used block, so that we
	 * do not recycle a block used by a busy client that
	 * has only paused */
	if (rl->d.last_used > clients_cleared) {
		/* Notice when we recycle a block that is not obsolete
		 * to inform the `cdcc clients` command. */
		rl_too_many = 1;
		stale = db_time.tv_sec - CLIENTS_AGE/2;
		for (rl2 = rl; rl2; rl2 = rl2->newer) {
			if (rl2->ref_cnt != 0)
				continue;
			if (rl2->d.last_used > stale)
				continue;
			/* take the first tiny client or summary found */
			if (RL_REQS_AVG(&rl2->d) < 100) {
				memset(&rl2->d, 0, sizeof(rl2->d));
				return rl2;
			}
		}
	}

	/* Fall back on recycling the least recently used.
	 * We have enough blocks to know that it is not currently referenced. */
	memset(&rl->d, 0, sizeof(rl->d));
	return rl;
}



static void
rl_unref(RL *rl)
{
	if (rl->d.last_used == 0)
		return;

	rl_hash_unlink(rl);
	rl->hfwd = 0;
	rl->hbak = 0;
	rl->bin = 0;

	if (rl->older) {
		rl->older->newer = rl->newer;
		if (rl->newer) {
			rl->newer->older = rl->older;
		} else {
			rl_newest = rl->older;
		}

		rl->newer = rl_oldest;
		rl_oldest->older = rl;
		rl_oldest = rl;
		rl->older = 0;
	}

	rl->d.last_used = 0;
}



static void
rl_ref(RL *rl, RL **new_bin)
{
	/* make it the most recently used block if it is not already */
	if (rl->newer) {
		rl->newer->older = rl->older;
		if (rl->older) {
			rl->older->newer = rl->newer;
		} else {
			rl_oldest = rl->newer;
		}

		rl->older = rl_newest;
		rl_newest->newer = rl;
		rl_newest = rl;
		rl->newer = 0;
	}

	/* move it to the head of its hash bin */
	rl_hash_link(rl, new_bin);
}



/* age a rate limit */
static void
rl_age(RL *rl, const RL_RATE *credits)
{
	time_t secs;

	secs = db_time.tv_sec - rl->d.last_used;
	rl->d.last_used = db_time.tv_sec;

	if (secs >= RL_AVG_SECS) {
		/* reset idle counters */
		if (!(rl->d.fgs & RL_FG_BLOCK))
			rl->d.u.bug_credits = rl_bugs_rate.hi;
		rl->d.request_credits = credits->hi;

	} else if (secs > 0) {
		rl->d.request_credits += secs * credits->per_sec;
		if (rl->d.request_credits > credits->hi)
			rl->d.request_credits = credits->hi;

		if (!(rl->d.fgs & RL_FG_BLOCK)) {
			rl->d.u.bug_credits += secs * rl_bugs_rate.per_sec;
			if (rl->d.u.bug_credits > rl_bugs_rate.hi)
				rl->d.u.bug_credits = rl_bugs_rate.hi;
		}
	}
}



/* age and increment a rate limit */
static inline void
rl_inc(RL *rl, const RL_RATE *credits)
{
	rl_age(rl, credits);
	++rl->d.reqs;			/* increase total count of requests */

	if ((rl->d.request_credits -= RL_SCALE) < credits->lo)
		rl->d.request_credits = credits->lo;
}



void
rl_inc2(RL *ip_rl, const RL_RATE *credits, RL *block_rl)
{
	rl_inc(ip_rl, credits);
	if (block_rl)
		rl_inc(block_rl, &rl_all_anon_rate);
}



/* Update the request rate.
 *	reqs_avg is synthetic numbers of requests per day.
 *	It is synthesized by occassionally accumulating differences between
 *	reqs and reqs_old into reqs_avg_total and setting
 *	reqs_old to reqs.  avg_start is when averaging started.
 *
 *	When avg_start becomes more than RL_AVG_TERM seconds in the past,
 *	avg_start set to the current time minus RL_AVG_TERM seconds.
 *
 *	NOPs are counted in the same way.
 */
static void
rl_avg_reqs_age(RL *rl, u_char force)
{
	time_t secs;
	double trim;

	secs =  db_time.tv_sec - TIME_T(rl->d.avg_last_aged);
	if (secs < 0) {
		/* clear things if time has jumped backwards */
		rl->d.avg_start = 0;

	} else if (secs < RL_AVG_UPDATE) {
		/* Do nothing if it is not yet time and we are not forced
		 * or if no time has passed. */
		if (!force || secs == 0)
			return;
	}

	secs = db_time.tv_sec - rl->d.avg_start;
	if (secs > RL_AVG_TERM*2) {
		/* Clear if the average was not updated for too long */
		rl->d.reqs_old = rl->d.reqs;
		rl->d.reqs_avg_total = 0;
		rl->d.nops_old = rl->d.nops;
		rl->d.nops_avg_total = 0;
		rl->d.avg_start = db_time.tv_sec;
		trim = 1.0;

	} else if (secs < RL_AVG_DAY) {
		/* we have no average for the first day */
		trim = 1.0;

	} else if (secs <= RL_AVG_TERM) {
		trim = (RL_AVG_DAY * 1.0) / secs;

	} else {
		/* trim old counts if we have been averaging long enough */
		trim = secs - RL_AVG_TERM;
		trim /= (RL_AVG_TERM*2);
		rl->d.reqs_avg_total -= (rl->d.reqs_avg_total * trim);
		rl->d.nops_avg_total -= (rl->d.nops_avg_total * trim);
		rl->d.avg_start = db_time.tv_sec - RL_AVG_TERM;
		trim = (RL_AVG_DAY * 1.0) / RL_AVG_TERM;
	}

	rl->d.reqs_avg_total += rl->d.reqs - rl->d.reqs_old;
	rl->d.reqs_old = rl->d.reqs;
	rl->d.nops_avg_total += rl->d.nops - rl->d.nops_old;
	rl->d.nops_old = rl->d.nops;

	rl->d.reqs_avg = (u_int32_t)(rl->d.reqs_avg_total * trim);
	rl->d.nops_avg = (u_int32_t)(rl->d.nops_avg_total * trim);

	rl->d.avg_last_aged = db_time.tv_sec;
}



/* get a single rate limit block based on the IP address of the sender */
RL *
rl_get(RL **block_rlp,
       u_char pkt_vers, DCC_CLNT_ID id, const struct in6_addr *addr,
       RL_DATA_FG fgs)
{
	RL *rl, *ip_rl, *block_rl, *wrong_rl, **bin;
	int prefix;
	IP_BL *bl;
	struct in6_addr end_addr;
#	define MATCH_ANON(_rl) ((((_rl)->d.fgs ^ fgs) & RL_FG_NO_AUTH) == 0)

	++rl_searches;

	prefix = RL_PREFIX_LEN(addr);

	ip_rl = 0;
	block_rl = 0;
	wrong_rl = 0;
	bin = rl_hash_fnc(addr);
	for (rl = *bin; ; rl = rl->hfwd) {
		if (!rl) {
			ip_rl = rl_get_stale();
			ip_rl->d.addr = *addr;
			ip_rl->d.id = id;
			ip_rl->d.pkt_vers = pkt_vers;
			break;
		}

		/* Ignore irrelevant entries in the hash chain
		 * except to count them to know when to expand. */
		if (memcmp(addr, &rl->d.addr, prefix)
		    || !MATCH_ANON(rl)) {
			++rl_probes;
			continue;
		}

		/* notice the CIDR rate-limit block */
		if (rl->d.fgs & RL_FG_BLOCK) {
			if (!block_rl && MATCH_ANON(rl))
				block_rl = rl;
			continue;
		}

		/* with luck, the target is first in the bin */
		if (!memcmp(&addr->s6_addr[prefix],
			    &rl->d.addr.s6_addr[prefix],
			    sizeof(addr->s6_addr)-prefix)
		    && rl->d.id == id
		    && rl->d.pkt_vers == pkt_vers) {
			ip_rl = rl;
			break;
		}

		/* Note a related but wrong rate-limit block */
		wrong_rl = rl;
	}

	/* See if an IP address is evil
	 *	The blacklist is a simple linear list.  Entries from the file
	 *	are added to the front of the list, so that the last matching
	 *	entry determines the result.
	 *  This should be sped up if there are ever more than a few entries */
	if (!(ip_rl->d.fgs & RL_FG_BLACK_SET)) {
		fgs |= RL_FG_BLACK_SET;
		ip_rl->d.fgs &= ~(RL_FG_BLACK_ADDR | RL_FG_TRACE_ADDR
				  | RL_FG_FLOD_OK);
		for (bl = *bl_hash_fnc(addr); bl; bl = bl->hfwd) {
			if (in_range(addr, &bl->range)) {
				if ((bl->flags & IP_BL_BAD)
				    || ((bl->flags & IP_BL_ANON)
					&& (fgs & RL_FG_NO_AUTH)))
					fgs |= RL_FG_BLACK_ADDR;
				if (bl->flags & IP_BL_TRACE)
					fgs |= RL_FG_TRACE_ADDR;
				if (bl->flags & IP_BL_FLOD_OK)
					fgs |= RL_FG_FLOD_OK;
				break;
			}
		}
	}

	rl_avg_reqs_age(ip_rl, 0);
	rl_ref(ip_rl, bin);

	/* Copy the wrong individual address rate limit block to start the
	 * counts for the CDIR entry. */
	if (!block_rl && wrong_rl) {
		block_rl = rl_get_stale();
		block_rl->d = wrong_rl->d;
		memset(&block_rl->d.addr.s6_addr[prefix], 0,
		       sizeof(block_rl->d.addr.s6_addr)-prefix);
		block_rl->d.fgs = RL_FG_BLOCK | (fgs & RL_FG_NO_AUTH);
	}
	if (block_rl) {
		/* Reset multiple version and ID flags in normal entries
		 * (not for flooding) after clearing. */
		if (id != DCC_ID_SRVR_ROGUE) {
			if (!(block_rl->d.fgs & RL_FG_BLOCK_SET)) {
				block_rl->d.pkt_vers = pkt_vers;
				block_rl->d.id = id;
				block_rl->d.fgs |= RL_FG_BLOCK_SET;
			}
			if (block_rl->d.id != id)
				block_rl->d.id = DCC_ID_CLIENTS_MULT;
			if (block_rl->d.pkt_vers != pkt_vers)
				block_rl->d.pkt_vers = DCC_PKT_VERS_MULTI;
		}
		/* update after blacklist change */
		if (!(block_rl->d.fgs & RL_FG_BLACK_SET)) {
			block_rl->d.fgs |= RL_FG_BLACK_SET;
			end_addr = *addr;
			memset(&end_addr.s6_addr[prefix], 0xff,
			       sizeof(end_addr)-prefix);
			for (bl = *bl_hash_fnc(&block_rl->d.addr);
			     bl;
			     bl = bl->hfwd) {
				if (in_range(&block_rl->d.addr, &bl->range)
				    && in_range(&end_addr, &bl->range)
				    && ((bl->flags & IP_BL_BAD)
					|| ((bl->flags & IP_BL_ANON)
					    && (fgs & RL_FG_NO_AUTH)))) {
					block_rl->d.fgs |= RL_FG_BLACK_ADDR;
					break;
				}
			}
		}
		if (!(fgs & RL_FG_BLACK_ID)) {
			block_rl->d.fgs &= ~RL_FG_BLACK_ID;
		} else if (block_rl->d.id == id) {
			block_rl->d.fgs |= RL_FG_BLACK_ID;
		}
		if (block_rl->d.fgs & (RL_FG_BLACK_ID | RL_FG_BLACK_ADDR))
			fgs |= RL_FG_BLOCK_BLACK;
		if (wrong_rl)
			block_rl->d.u.block_used = db_time.tv_sec;
		rl_avg_reqs_age(block_rl, 0);
		rl_ref(block_rl, bin);
	}

	/* RL_FG_BLOCK_BLACK is missing here so it stays
	 *	set until clients_clear()
	 * RL_FG_BLACK_ADDR & RL_FG_TRACE_ID are set and cleared
	 *	with RL_FG_BLACK_SET.
	 * RL_FG_BLACK_ID is set by the caller.
	 */
	ip_rl->d.fgs &= ~(RL_FG_NO_AUTH
			  | RL_FG_PASSWD | RL_FG_UKN_ID
			  | RL_FG_BLACK_ID);
	ip_rl->d.fgs |= fgs;

	*block_rlp = block_rl;
	return ip_rl;
}



/* get a rate limit block for a job */
static void
rl_get_q(QUEUE *q, u_char pkt_vers, DCC_CLNT_ID id, RL_DATA_FG fg_anon)
{
	struct in6_addr clnt_addr;

	/* expand the hash bins if necessary */
	if (rl_searches > 100
	    && DB_IS_TIME(rl_hash_checked, RL_HASH_CHECK_SECS)) {
		if (rl_probes/rl_searches > 2)
			rl_expand_hash();
		rl_chain_check_reset();
	}

	q->ip_rl = rl_get(&q->block_rl, pkt_vers, id,
			  dcc_su2ipv6(&clnt_addr, 0, &q->clnt_su), fg_anon);
	++q->ip_rl->ref_cnt;
	if (q->block_rl)
		++q->block_rl->ref_cnt;
}



static u_char
clients_write(FILE *f, const void *buf, int buf_len)
{
	if (1 == fwrite(buf, buf_len, 1, f))
		return 1;
	dcc_error_msg("fwrite(%s): %s",
		      DB_NM2PATH_ERR(CLIENTS_NM()), ERROR_STR());
	fclose(f);
	return 0;
}



/* dump the rate limit blocks into a file */
void
clients_save(void)
{
	int fd;
	FILE *f;
	CLIENTS_HEADER header;
	RL *rl, *rl_next;
	time_t secs;

	need_clients_save = db_time.tv_sec + CLIENTS_SAVE_SECS;

	/* prevent evil games with symbolic links */
	unlink(CLIENTS_NM_NEW());
	fd = open(CLIENTS_NM_NEW(), O_WRONLY|O_CREAT|O_EXCL, 0640);
	if (fd < 0) {
		dcc_error_msg("open(%s): %s",
			      DB_NM2PATH_ERR(CLIENTS_NM_NEW()), ERROR_STR());
		return;
	}
	f = fdopen(fd, "w");

	memset(&header, 0, sizeof(header));
	BUFCPY(header.magic, CLIENTS_MAGIC(grey_on));
	header.now = db_time.tv_sec;
	header.cleared = clients_cleared;
	if (anon_off) {
		header.anon_delay_us = DCC_ANON_DELAY_FOREVER;
	} else {
		header.anon_delay_us = anon_delay_us;
		header.anon_delay_inflate = anon_delay_inflate;
	}
	if (TIME_T(clients_cleared) > db_time.tv_sec)   /* fix time jump */
		clients_cleared = db_time.tv_sec;

	/* decide how many blocks we will write */
	rl_next = rl_oldest;
	while ((rl = rl_next) != 0) {
		rl_next = rl->newer;
		if (rl->d.last_used == 0)
			continue;
		secs = db_time.tv_sec - rl->d.last_used;
		if (secs < 0) {
			/* fix time jumps */
			rl->d.last_used = db_time.tv_sec;
		} else if (secs > CLIENTS_SAVE_AGE) {
			/* get ancient blocks off hash chains */
			rl_unref(rl);
			continue;
		}
		rl_avg_reqs_age(rl, 0);
		if (secs > RL_AVG_TERM
		    && rl->d.reqs == 0
		    && rl->d.reqs_avg_total == 0
		    && rl->d.nops == 0
		    && rl->d.nops_avg_total == 0) {
			/* forget clients that have disappeared */
			rl_unref(rl);
			continue;
		}
		if (rl->d.fgs & RL_FG_BLOCK) {
			secs = db_time.tv_sec - rl->d.u.block_used;
			if (secs < 0) {
				/* fix time jumps */
				rl->d.u.block_used = db_time.tv_sec;
			} else if (secs > CLIENTS_SAVE_AGE) {
				/* forget addresss blocks when there has been
				 * only one address in the block "forever" */
				rl_unref(rl);
				continue;
			}
		}
		++header.blocks;
	}
	if (!clients_write(f, &header, sizeof(header)))
		return;

	/* Write the oldest first so that the newest will be read last
	 * and so be at the start of the hash chains. */
	for (rl = rl_oldest; rl != 0; rl = rl->newer) {
		if (rl->d.last_used == 0)
			continue;
		if (!clients_write(f, &rl->d, sizeof(rl->d)))
			return;
	}

	/* install complete, consistent file */
	if (0 > rename(CLIENTS_NM_NEW(), CLIENTS_NM()))
		dcc_error_msg("rename(%s,%s): %s",
			      DB_NM2PATH_ERR(CLIENTS_NM_NEW()), CLIENTS_NM(),
			      ERROR_STR());
	fclose(f);
}



static u_char
clients_read(FILE *f, void *buf, int buf_len)
{
	int i;

	i = fread(buf, buf_len, 1, f);
	if (i == 1)
		return 1;

	if (feof(f))
		return 0;

	dcc_error_msg("fread(%s): %s",
		      DB_NM2PATH_ERR(CLIENTS_NM()), ERROR_STR());
	fclose(f);
	return 0;
}



/* load the rate limit blocks from a previous instance */
static void
clients_load(void)
{
	struct stat sb;
	int fd;
	FILE *f;
	CLIENTS_HEADER header;
	u_int rl_size;
	u_int total, used, anon;
	DCC_PTIME prev_last_used;
#	define BAD_FILE() ((0 > rename(CLIENTS_NM(), BAD_CLIENTS_NM()))	    \
			   ? unlink(CLIENTS_NM()) : 0)

	clients_cleared = db_time.tv_sec;

	fd = open(CLIENTS_NM(), O_RDONLY, 0);
	if (fd < 0) {
		if (errno != ENOENT) {
			dcc_error_msg("open(%s): %s",
				      DB_NM2PATH_ERR(CLIENTS_NM()),
				      ERROR_STR());
		} else if (db_debug) {
			dcc_trace_msg("open(%s): %s",
				      DB_NM2PATH_ERR(CLIENTS_NM()),
				      ERROR_STR());
			BAD_FILE();
		}
		return;
	}
	f = fdopen(fd, "r");
	if (0 > fstat(fd, &sb)) {
		dcc_error_msg("stat(%s): %s",
			      DB_NM2PATH_ERR(CLIENTS_NM()), ERROR_STR());
		BAD_FILE();
		fclose(f);
		return;
	}
	if ((int)sb.st_size < ISZ(header)) {
		dcc_error_msg("%s has invalid size %d",
			      DB_NM2PATH_ERR(CLIENTS_NM()), (int)sb.st_size);
		BAD_FILE();
		fclose(f);
		return;
	}

	if (!clients_read(f, &header, sizeof(header)))
		return;

	/* try to save strange files but quietly ignore old files */
	if (strcmp(header.magic, CLIENTS_MAGIC(grey_on))) {
		if (strncmp(header.magic, CLIENTS_MAGIC_BASE(grey_on),
			    strlen(CLIENTS_MAGIC_BASE(grey_on)))) {
			dcc_error_msg("unrecognized magic in %s",
				      DB_NM2PATH_ERR(CLIENTS_NM()));
			BAD_FILE();
		}
		fclose(f);
		return;
	}

	if (((sb.st_size - ISZ(header)) % ISZ(RL_DATA)) != 0) {
		dcc_error_msg("%s has invalid size %d",
			      DB_NM2PATH_ERR(CLIENTS_NM()), (int)sb.st_size);
		BAD_FILE();
		fclose(f);
		return;
	}

	if (header.blocks > DCC_RL_MAX_MAX) {
		dcc_trace_msg("unrecognized blocks=%d in %s",
			      header.blocks, DB_NM2PATH_ERR(CLIENTS_NM()));
		fclose(f);
		return;
	}
	if (TIME_T(header.cleared) > db_time.tv_sec) {
		dcc_trace_msg("bad time %d in %s",
			      (int)header.cleared,
			      DB_NM2PATH_ERR(CLIENTS_NM()));
		fclose(f);
		return;
	}
	clients_cleared = header.cleared;
	rl_size = min(max((header.blocks*9)/8, DCC_RL_INIT), rl_max_blocks);
	rl_make_blocks(rl_size);
	rl_expand_hash();

	prev_last_used = 1;
	for (total = 0, used = 0, anon = 0; ; ++total) {
		RL *rl, **bin;
		RL_DATA d;

		if (!clients_read(f, &d, sizeof(d)))
			break;
		if (TIME_T(d.last_used) > db_time.tv_sec) {
			dcc_error_msg("bad timestamp %d"
				      " in entry #%d in %s",
				      d.last_used, total,
				      DB_NM2PATH_ERR(CLIENTS_NM()));
			if (total > used+50)
				break;
			continue;
		}
		if (prev_last_used > d.last_used) {
			dcc_error_msg("bad timestamp %d after %d"
				      " in entry #%d in %s",
				      d.last_used, prev_last_used, total,
				      DB_NM2PATH_ERR(CLIENTS_NM()));
			if (total > used+50)
				break;
			continue;
		}
		prev_last_used = d.last_used;

		rl = rl_get_stale();
		rl->d = d;
		rl->d.fgs &= ~RL_FG_BLACK_SET;	/* check current blacklist */

		++used;
		if ((rl->d.fgs & RL_FG_NO_AUTH)
		    && !(rl->d.fgs & RL_FG_BLOCK)
		    && TIME_T(rl->d.last_used) >= db_time.tv_sec-2*24*60*60)
			++anon;
		bin = rl_hash_fnc(&d.addr);
		rl_ref(rl, bin);
	}
	fclose(f);

	/* Start adapting the hash table size after it has been loaded. */
	rl_chain_check_reset();
	need_clients_save = db_time.tv_sec + CLIENTS_SAVE_SECS;

	if (total < header.blocks) {
		dcc_error_msg("%s has only %d instead of %d blocks",
			      DB_NM2PATH_ERR(CLIENTS_NM()),
			      total, header.blocks);
	}

	if (used != total
	    || total > 500
	    || anon != 0
	    || db_debug) {
		if (anon != 0)
			dcc_trace_msg("used %d of %d RL blocks,"
				      " %d for recent anonymous clients in %s",
				      used, total, anon,
				      DB_NM2PATH_ERR(CLIENTS_NM()));
		else
			dcc_trace_msg("used %d of %d RL blocks in %s",
				      used, total,
				      DB_NM2PATH_ERR(CLIENTS_NM()));
	}
}



static inline void
client_pack8(u_char **cpp, const u_char *cp_lim, u_char v)
{
	u_char *cp;

	cp = *cpp;
	if (cp < cp_lim) {
		*cp++ = v;
		*cpp = cp;
	}
}



/* pack up a 64 bit int in 1-10 bytes as part of an answer to a `cdcc clients`
 *	request */
static void
client_pack64(u_char **cpp, const u_char *cp_lim, u_int64_t v)
{
	while (v > 0x7f) {
		client_pack8(cpp, cp_lim, v | 0x80);
		v >>= 7;
	}
	client_pack8(cpp, cp_lim, v);
}



static u_char
client_pack(u_char **cpp,		/* pack into this byte first */
	    const u_char *cp_lim,
	    DCC_ADMN_RESP_CLIENTS_FLAGS flags,
	    DCC_CLNT_ID clnt_id,
	    int skip,
	    DCC_PTIME last_used,
	    DCC_PTIME *prev_last_used,
	    DCC_SCNTR reqs,
	    DCC_SCNTR nops,
	    u_char vers,
	    const struct in6_addr *clnt_addr)
{
	const u_char zero[4];
	const u_char *ap, *a_lim;
	u_char *cp;

	cp = *cpp;

	if (!clnt_addr) {
		ap = zero;
		a_lim = ap+4;
	} else {
		ap = (u_char *)clnt_addr;
		if (DCC_ADDR6_V4MAPPED(clnt_addr)) {
			ap += 12;
			a_lim = ap+4;
		} else {
			flags |= DCC_ADMN_RESP_CLIENTS_IPV6;
			a_lim = ap+16;
		}
	}

	if (vers != 0)
		flags |= DCC_ADMN_RESP_CLIENTS_VERS;
	client_pack8(&cp, cp_lim, flags);

	if (flags & DCC_ADMN_RESP_CLIENTS_VERS)
		client_pack8(&cp, cp_lim, vers);

	if (flags & DCC_ADMN_RESP_CLIENTS_SKIP) {
		client_pack64(&cp, cp_lim, skip);
	} else {
		u_int64_t v;

		v = last_used - *prev_last_used;
		if (v > DCC_ADMIN_CLIENTS_MAX_DELTA)
			v = last_used;
		*prev_last_used = last_used;
		client_pack64(&cp, cp_lim, v);
	}

	if (!(flags & DCC_ADMN_RESP_CLIENTS_ANON))
		client_pack64(&cp, cp_lim, clnt_id);

	client_pack64(&cp, cp_lim, reqs);
	client_pack64(&cp, cp_lim, nops);

	do {
		client_pack8(&cp, cp_lim, *ap++);
	} while (ap < a_lim);

	if (cp >= cp_lim)
		return 0;
	*cpp = cp;
	return 1;
}



/* get list of clients,
 *	treating clients with the same ID as if they were all the same system */
void
clients_get_id(DCC_ADMN_RESP_VAL *val,	/* buffer */
	       int *lenp,		/* length>>DCC_ADMIN_CLIENTS_SHIFT */
	       u_int offset,		/* skip this many newer entries */
	       u_int thold,		/* skip clients with fewer requests */
	       u_char req_flags,
	       const DCC_IP_RANGE *tgt_range,
	       DCC_CLNT_ID tgt_id)
{
	RL *rl, *rl2, *rl_next, *rl_last, *rl_last2;
	DCC_CLNT_ID cur_id;
	DCC_ADMN_RESP_CLIENTS_FLAGS *prev_flags;    /* in previous record */
	u_char *cp, *cp_lim;
	DCC_SCNTR reqs, nops;
	DCC_PTIME prev_last_used;
	u_int skip;
	int i;
#undef PERF_DEBUG
#ifdef PERF_DEBUG
	int scanned = 0;
#endif

	/* write the file soon */
	if (need_clients_save > db_time.tv_sec + CLIENTS_QUICK_SAVE)
		need_clients_save = db_time.tv_sec + CLIENTS_QUICK_SAVE;

	i = *lenp << DCC_ADMIN_CLIENTS_SHIFT;
	if (i > ISZ(*val))
		i = ISZ(*val);
	cp = val->clients;
	cp_lim = cp+i;
	prev_flags = 0;
	prev_last_used = 0;
	skip = 0;
	if (thold == 0)
		thold = 1;
	for (rl = rl_newest; rl != 0; rl = rl->older) {
		if (rl->d.last_used == 0)
			rl->d.fgs |= RL_FG_MARKED;
		else if (rl->d.fgs & RL_FG_MARKED)
			rl->d.fgs &= ~RL_FG_MARKED;
	}

	rl_last = rl_last2 = 0;
	rl_next = rl_newest;
	for (;;) {
		rl = rl_next;
		if (!rl || rl == rl_last) {
			/* there are no more, so
			 * mark the previous record as the last */
			if (prev_flags)
				*prev_flags |= DCC_ADMN_RESP_CLIENTS_LAST;
			break;
		}

		if ((rl->d.fgs & (RL_FG_MARKED | RL_FG_BLOCK)) != 0) {
			rl_next = rl->older;
			continue;
		}
		if (tgt_range && !in_range(&rl->d.addr, tgt_range)) {
			rl_next = rl->older;
			continue;
		}

		cur_id = rl->d.id;
		if (cur_id != DCC_ID_ANON && cur_id < DCC_SRVR_ID_MIN) {
			/* ignore server entries */
			rl_next = rl->older;
			continue;
		}
		if (tgt_id != DCC_ID_INVALID && tgt_id != cur_id) {
			rl_next = rl->older;
			continue;
		}

		reqs = 0;
		nops = 0;
		rl2 = rl;
		rl_next = 0;
		for (;;) {
			if (req_flags & DCC_AOP_CLIENTS_AVG) {
				rl_avg_reqs_age(rl2, 0);
				reqs += RL_REQS_AVG(&rl2->d);
				nops += RL_NOPS_AVG(&rl2->d);
			} else {
				reqs += rl2->d.reqs;
				nops += rl2->d.nops;
			}

			for (;;) {
#ifdef PERF_DEBUG
				++scanned;
#endif
				rl2 = rl2->older;
				if (!rl2 || rl2 == rl_last) {
					rl_last = rl_last2;
					goto out;
				}
				if ((rl2->d.fgs & (RL_FG_MARKED
						   | RL_FG_BLOCK)) != 0)
					continue;
				if (tgt_range
				    && !in_range(&rl2->d.addr, tgt_range)) {
					rl2->d.fgs |= RL_FG_MARKED;
					continue;
				}

				if (cur_id == rl2->d.id) {
					/* found an entry to send */
					rl2->d.fgs |= RL_FG_MARKED;
					break;
				}

				/* Check these uncommon cases last
				 * but do check them to improve rl_last */
				if (rl2->d.last_used == 0
				    || (rl2->d.id < DCC_SRVR_ID_MIN
					&& rl2->d.id != DCC_ID_ANON))
					continue;

				/* remember first unmarked entry for next ID */
				if (!rl_next)
					rl_next = rl2;
				/* remember last unmarked entry */
				rl_last2 = rl2->older;
			}
		}
out:

#ifdef PERF_DEBUG
		dcc_trace_msg(" clients_get_id() scanned %d entries for %u",
			      scanned, cur_id);
		scanned = 0;
#endif

		/* get the part of the list that cdcc wants */
		if (offset != 0) {
			--offset;
			continue;
		}

		if (reqs < thold) {
			++skip;
			continue;
		}
		/* The threshold might be larger on the next request
		 * from cdcc, so tell cdcc the number skipped this time
		 * by inserting a fake entry. */
		if (skip
		    && !client_pack(&cp, cp_lim,
				    DCC_ADMN_RESP_CLIENTS_SKIP
				    | DCC_ADMN_RESP_CLIENTS_ANON,
				    DCC_ID_INVALID, skip, 0, 0, 0, 0, 0, 0))
			break;
		prev_flags = cp;
		if (!client_pack(&cp, cp_lim,
				 cur_id == DCC_ID_ANON
				 ? DCC_ADMN_RESP_CLIENTS_ANON : 0,
				 cur_id, 0,
				 rl->d.last_used, &prev_last_used,
				 reqs, nops, 0, 0))
			break;
	}
	*lenp = cp - val->clients;
}



/* get a list of the most recent clients */
int					/* +/- number of clients */
clients_get(DCC_ADMN_RESP_VAL *val,	/* buffer */
	    int *lenp,			/* length>>DCC_ADMIN_CLIENTS_SHIFT */
	    u_int offset,		/* skip this many newer entries */
	    u_int thold,		/* skip clients with fewer requests */
	    u_char req_flags,
	    const DCC_IP_RANGE *tgt_range,
	    DCC_CLNT_ID tgt_id)
{
	RL *rl;
	DCC_ADMN_RESP_CLIENTS_FLAGS flags;
	DCC_ADMN_RESP_CLIENTS_FLAGS *prev_flags;    /* in previous record */
	u_char *cp, *cp_lim;
	DCC_SCNTR reqs, nops;
	u_char prev_vers, vers;
	DCC_PTIME prev_last_used;
	int skip, total;
	DCC_CLNT_ID clnt_id;
	int i;

	/* write the file soon */
	if (need_clients_save > db_time.tv_sec + CLIENTS_QUICK_SAVE)
		need_clients_save = db_time.tv_sec + CLIENTS_QUICK_SAVE;

	if (!val || !lenp) {
		cp = cp_lim = 0;
	} else {
		i = *lenp << DCC_ADMIN_CLIENTS_SHIFT;
		if (i > ISZ(*val))
			i = ISZ(*val);
		cp = val->clients;
		cp_lim = cp+i;
	}
	prev_flags = 0;
	prev_vers = 0;
	prev_last_used = 0;
	if (!thold)
		thold = 1;
	skip = 0;
	total = 0;
	for (rl = rl_newest; ; rl = rl->older) {
		if (!rl) {
			/* there are no more, so
			 * mark the previous record as the last */
			if (prev_flags)
				*prev_flags |= DCC_ADMN_RESP_CLIENTS_LAST;
			break;
		}

		if (rl->d.id != DCC_ID_ANON
		    && rl->d.id < DCC_SRVR_ID_MIN
		    && rl->d.id != DCC_ID_INVALID)
			continue;
		if (rl->d.last_used == 0)
			continue;

		/* respect client IP address and client-ID limitations */
		if (tgt_range && !in_range(&rl->d.addr, tgt_range))
			continue;
		if (tgt_id != DCC_ID_INVALID && tgt_id != rl->d.id)
			continue;
		/*  Report only (non-)anonymous clients if asked. */
		if (req_flags & DCC_AOP_CLIENTS_NON_ANON) {
			if (rl->d.id == DCC_ID_ANON)
				continue;
		} else if (req_flags & DCC_AOP_CLIENTS_ANON) {
			if (!(rl->d.fgs & RL_FG_NO_AUTH))
				continue;
		}

		if (rl->d.reqs != 0
		    && !(rl->d.fgs & RL_FG_BLOCK))
			++total;

		/* compute only the total for `cdcc stats` if buffer is null */
		if (!cp)
			continue;

		if (offset != 0) {
			--offset;
			continue;
		}

		if (req_flags & DCC_AOP_CLIENTS_AVG) {
			rl_avg_reqs_age(rl, 0);
			reqs = RL_REQS_AVG(&rl->d);
			nops = RL_NOPS_AVG(&rl->d);
		} else {
			reqs = rl->d.reqs;
			nops = rl->d.nops;
		}

		/* Skip idle counters. and ok counters below the threshold */
		if (reqs < thold
		    && (rl->d.reqs == 0
			|| !(rl->d.fgs & RL_FG_DROPPED))) {
			++skip;
			continue;
		}
		/* Skip bad addresses covered by a blacklisted address block
		 * when they are not asked for explicitly. */
		if (!tgt_range && (rl->d.fgs & RL_FG_BLOCK_BLACK)) {
			++skip;
			continue;
		}

		/* The threshold might be larger on the next request
		 * from cdcc, so tell cdcc the number skipped this time
		 * by inserting a fake entry. */
		if (skip != 0) {
			if (!client_pack(&cp, cp_lim,
					 DCC_ADMN_RESP_CLIENTS_SKIP
					 | DCC_ADMN_RESP_CLIENTS_ANON,
					 DCC_ID_INVALID, skip,
					 0, 0, 0, 0, 0, 0))
				break;
			skip = 0;
		}

		/* send the version number if it is wanted and differs
		 * from the previous value */
		if ((req_flags & DCC_AOP_CLIENTS_VERS)
		    && rl->d.pkt_vers != prev_vers) {
			vers = rl->d.pkt_vers;
			prev_vers = vers;
		} else {
			vers = 0;
		}

		flags = 0;
		clnt_id = rl->d.id;
		if (rl->d.fgs & (RL_FG_BLACK_ID | RL_FG_BLACK_ADDR))
			flags |= DCC_ADMN_RESP_CLIENTS_BLACK;
		if (rl->d.fgs & RL_FG_DROPPED)
			flags |= DCC_ADMN_RESP_CLIENTS_DROPPED;
		if (rl->d.fgs & RL_FG_BLOCK)
			flags |= DCC_ADMN_RESP_CLIENTS_BLOCK;
		if (clnt_id == DCC_ID_ANON)
			flags |= DCC_ADMN_RESP_CLIENTS_ANON;
		else if (rl->d.fgs & RL_FG_NO_AUTH)
			clnt_id |= DCC_ADMN_RESP_CLIENTS_NO_AUTH;
		prev_flags = cp;
		if (!client_pack(&cp, cp_lim, flags, clnt_id, 0,
				 rl->d.last_used, &prev_last_used,
				 reqs, nops, vers, &rl->d.addr))
			break;
	}
	if (lenp)
		*lenp = cp - val->clients;

	/* return negative total if the oldest block is not very old and
	 * we have had to recycle a recent block */
	if (rl_too_many)
		return -total;
	return total;
}



/* forget old clients, but keep their averages  */
void
clients_clear()
{
	RL *rl;

	for (rl = rl_oldest; rl != 0; rl = rl->newer) {
		rl_avg_reqs_age(rl, 1);
		rl->d.reqs = 0;
		rl->d.reqs_old = 0;
		rl->d.nops = 0;
		rl->d.nops_old = 0;
		rl->d.fgs &= ~(RL_FG_BLACK_SET | RL_FG_BLOCK_SET
			       | RL_FG_DROPPED | RL_FG_BLOCK_BLACK
			       | RL_FG_PASSWD
			       | RL_FG_BLACK_ADDR | RL_FG_BLACK_ID);
	}

	clients_cleared = db_time.tv_sec;
	rl_too_many = 0;
	rl_chain_check_reset();
	if (need_clients_save > db_time.tv_sec + CLIENTS_QUICK_SAVE)
		need_clients_save = db_time.tv_sec + CLIENTS_QUICK_SAVE;
}



u_char					/* 0=bad passwd, 1=1st passwd, 2=2nd */
ck_sign(const ID_TBL **tpp,		/* return ID table entry here */
	DCC_PASSWD passwd,		/* return matching password here */
	DCC_CLNT_ID id,
	const void *buf, u_int buf_len)
{
	ID_TBL *tp;

	tp = find_id_tbl(id, db_debug != 0);
	if (tpp)
		*tpp = tp;
	if (!tp)
		return 0;

	if (tp->delay_us >= DCC_ANON_DELAY_US_BLACKLIST)
		return 0;

	if (tp->cur_passwd[0] != '\0'
	    && dcc_ck_signature(tp->cur_passwd, sizeof(tp->cur_passwd),
				buf, buf_len)) {
		if (passwd)
			memcpy(passwd, tp->cur_passwd, sizeof(DCC_PASSWD));
		return 1;
	}
	if (tp->next_passwd[0] != '\0'
	    && dcc_ck_signature(tp->next_passwd, sizeof(tp->next_passwd),
				buf, buf_len)) {
		if (passwd)
			memcpy(passwd, tp->next_passwd, sizeof(DCC_PASSWD));
		return 2;
	}
	return 0;
}



/* decide how long a request should be delayed */
static u_char
tp2delay(QUEUE *q, time_t delay_us, u_int delay_inflate)
{
	int reqs, inflate;

	if (delay_us != 0) {
		if (q->block_rl)
			reqs = RL_REQS_AVG(&q->block_rl->d);
		else
			reqs = RL_REQS_AVG(&q->ip_rl->d);
		inflate = 1 + reqs/delay_inflate;
		if (inflate > DCC_ANON_DELAY_MAX / delay_us /* no overflow */
		    || (delay_us *= inflate) >= DCC_ANON_DELAY_MAX) {
			q->delay_us = DCC_ANON_DELAY_MAX;
			return 0;
		}
	}

	if ((dbclean_running || anon_off)
	    && (q->ip_rl->d.fgs & RL_FG_NO_AUTH)) {
		/* Do not answer anonymous clients while we are cleaning
		 * the database.  Do not fail, because this is not the
		 * client's fault. */
		q->delay_us = DCC_ANON_DELAY_MAX;
		return 1;
	}

	if (flods_off > 0
	    || flods_st != FLODS_ST_ON
	    || (iflods.open == 0 && (oflods.total != 0 || !grey_on))
	    || !DB_IS_TIME(iflods_ok_timer, IFLODS_OK_SECS)) {
		/* Increase the delay when flooding is off, broken,
		 * or just starting after being off
		 * Greylist servers without any flooding peers can be isolated
		 * but not DCC servers */
		delay_us += 400*1000;

	} else if (dbclean_wfix_state == WFIX_QUIET
		   || dbclean_wfix_state == WFIX_CHECK) {
		/* increase the delay if we are testing to see if clients
		 * have a alternative so we can do a quick window fix. */
		delay_us += 1000*1000;
	}

	if (delay_us >= DCC_ANON_DELAY_MAX) {
		q->delay_us = DCC_ANON_DELAY_MAX;
		return 0;
	}
	q->delay_us = delay_us;
	return 1;
}



/* check the message authentication code and rate limit requests */
static u_char				/* 0=forget request, 1=go ahead */
ck_id(QUEUE *q,
      DCC_CLNT_ID id,			/* what the client claimed */
      DCC_CLNT_ID min_id,
      u_char drop_bad_id)
{
#define RL_CNT2AVG(cur,lims) ((lims.hi - cur) / (RL_SCALE*RL_AVG_SECS*1.0))
	const ID_TBL *tp;
	RL *ip_rl, *block_rl;
	RL_DATA_FG rl_d_fgs;
	char result2_buf[30];
	const char *result_str, *result2_str;

	result_str = 0;
	q->clnt_id = id;

	if (id == DCC_ID_ANON) {
		tp = 0;
		rl_d_fgs = RL_FG_NO_AUTH;
		q->flags |= Q_FG_REPS_ANS_OK;

	} else if (!ck_sign(&tp, q->passwd, id, &q->pkt, q->pkt_len)
		   || id < min_id) {
		/* failed to authenticate the ID */
		rl_d_fgs = RL_FG_NO_AUTH;
		q->flags |= Q_FG_REPS_ANS_OK;
		if (!tp) {
			/* unknown ID */
			rl_d_fgs |= RL_FG_UKN_ID;
		} else {
			/* known ID but bad password */
			if (tp->flags & ID_FLG_TRACE)
				rl_d_fgs |= RL_FG_TRACE_ID;
			if (tp->delay_us >= DCC_ANON_DELAY_US_BLACKLIST) {
				rl_d_fgs |= RL_FG_BLACK_ID;
			} else {
				rl_d_fgs |= RL_FG_PASSWD;
			}
			tp = 0;
		}

	} else {
		if (tp->flags & ID_FLG_TRACE)
			rl_d_fgs = RL_FG_TRACE_ID;
		if (tp->delay_us >= DCC_ANON_DELAY_US_BLACKLIST) {
			rl_d_fgs = RL_FG_BLACK_ID;
		} else {
			q->flags |= Q_FG_TRUSTED;
			if (!(tp->flags & ID_FLG_NO_REPS)) {
				q->flags |= Q_FG_REPS_RPT_OK;
				q->flags |= Q_FG_REPS_ANS_OK;
			}
			rl_d_fgs = 0;
		}
	}

	rl_get_q(q,  q->pkt.hdr.pkt_vers, id, rl_d_fgs);
	ip_rl = q->ip_rl;
	block_rl = q->block_rl;

	if (tp) {
		if (!query_only || (tp->flags & ID_FLG_RPT_OK))
			q->flags |= Q_FG_RPT_OK;

		rl_inc2(ip_rl, &rl_sub_rate, block_rl);

		if (!tp2delay(q, tp->delay_us, tp->delay_inflate))
			result_str = "max delay drop ";

		if (ip_rl->d.request_credits <= 0) {
			clnt_msg(q, "%.1f requests/sec are too many%s",
				 RL_CNT2AVG(ip_rl->d.request_credits,
					    rl_sub_rate),
				 from_id_ip(q, 0));
			++dccd_stats.rl;
			result_str = "IP request rate limit drop ";
		}

	} else {
		if (!query_only)
			q->flags |= Q_FG_RPT_OK;

		rl_inc2(ip_rl, &rl_anon_rate, block_rl);
		rl_inc(&rl_all_anon, &rl_all_anon_rate);

		if (!tp2delay(q, anon_delay_us, anon_delay_inflate))
			result_str = "max anon delay drop ";

		if (ip_rl->d.request_credits <= 0) {
			clnt_msg(q, "%.1f requests/sec are too many%s",
				 RL_CNT2AVG(ip_rl->d.request_credits,
					    rl_anon_rate),
				 from_id_ip(q, 0));
			++dccd_stats.anon_rl;
			result_str = "anon IP request rate limit drop ";

		} else if (rl_all_anon.d.request_credits <= 0) {
			clnt_msg(q, "%s contributed to %.1f"
				 " anonymous requests/sec",
				 Q_CIP(q),
				 RL_CNT2AVG(rl_all_anon.d.request_credits,
					    rl_all_anon_rate));
			++dccd_stats.anon_rl;
			result_str = "all anon request rate limit drop ";
		}
	}

	if (!result_str) {
		if (ip_rl->d.fgs & RL_FG_BLACK_ID) {
			result_str = "drop ";
		} else if (ip_rl->d.fgs & RL_FG_BLACK_ADDR) {
			result_str = "drop ";
		} else if ((ip_rl->d.fgs & RL_FG_PASSWD) && drop_bad_id) {
			result_str = "bad password drop ";
		} else if ((ip_rl->d.fgs & RL_FG_UKN_ID) && drop_bad_id) {
			result_str = "ID unknown drop ";
		}
	}

	if (result_str)
		++dccd_stats.bad_op;

	if (ip_rl->d.fgs & (RL_FG_BLACK_ID | RL_FG_BLACK_ADDR))
		++dccd_stats.blist;
	if ((ip_rl->d.fgs & (RL_FG_PASSWD | RL_FG_UKN_ID))
	    && !(ip_rl->d.fgs & (RL_FG_BLACK_ID | RL_FG_BLACK_ADDR)))
		++dccd_stats.bad_passwd;

	/* complain if tracing blacklisted clients
	 * or if tracing this client
	 * or if this client is not blacklisted	& used a bad password or ID */
	if (((ip_rl->d.fgs & (RL_FG_BLACK_ID | RL_FG_BLACK_ADDR))
	     && (DCC_TRACE_BL_BIT & tracemask))
	    || (ip_rl->d.fgs & RL_FG_TRACE)
	    || ((ip_rl->d.fgs & (RL_FG_UKN_ID | RL_FG_PASSWD))
		&& !(ip_rl->d.fgs & (RL_FG_BLACK_ID | RL_FG_BLACK_ADDR))
		&& !(ip_rl->d.fgs & RL_FG_DROPPED)
		&& (!block_rl || !(block_rl->d.fgs & RL_FG_DROPPED)))) {

		if (result_str || q->delay_us == 0) {
			if (ip_rl->d.fgs & RL_FG_BLACK_ADDR)
				result2_str = "blacklisted ";
			else if (ip_rl->d.fgs & RL_FG_BLACK_ID)
				result2_str = "ID blacklisted ";
			else
				result2_str = 0;
		} else {
			snprintf(result2_buf, sizeof(result2_buf),
				 "delay %.3f ",
				 q->delay_us/(DCC_US*1.0));
			result2_str = result2_buf;
		}
		if (!result_str && !result2_str) {
			log_op(q);
		} else {
			dcc_trace_msg("%s%s%s",
				      result_str ? result_str : "",
				      result2_str ? result2_str : "",
				      from_id_ip(q, 1));
			q->flags |= Q_FG_TRACED;
		}
	}

	if (result_str) {
		ip_rl->d.fgs |= RL_FG_DROPPED;
		if (block_rl)
			block_rl->d.fgs |= RL_FG_DROPPED;
		return 0;
	}
	return 1;
}



/* check the message authentication code for a client of our server-ID
 * and rate limit its messages */
u_char					/* 0=forget it, 1=go ahead */
ck_clnt_srvr_id(QUEUE *q, DCC_CLNT_ID id, u_char drop_bad_id)
{
	/* require a client-ID, a server-ID, or the anonymous client-ID
	 * to consider allowing an administrative request */
	return ck_id(q, id, DCC_SRVR_ID_MIN, drop_bad_id);
}



/* check the message authentication code of a request,
 * and rate limit the source */
u_char					/* 0=forget it, 1=go ahead */
ck_clnt_id(QUEUE *q, DCC_CLNT_ID id, u_char drop_bad_id)
{
	/* require a client-ID that is not a server-ID to discourage server
	 * operators from leaking server-ID's */
	return ck_id(q, id, DCC_CLNT_ID_MIN, drop_bad_id);
}



const char *
qop2str(const QUEUE *q)
{
	static int bufno;
	static struct {
	    char    str[DCC_OPBUF];
	} bufs[4];
	char *s;

	s = bufs[bufno].str;
	bufno = (bufno+1) % DIM(bufs);

	return dcc_hdr_op2str(s, DCC_OPBUF, &q->pkt.hdr);
}



const char *
from_id_ip(const QUEUE *q,
	   u_char print_op)		/* 1=include operation */
{
	static char buf[DCC_OPBUF+ISZ(" from ")+40+ISZ(" at ")
			+ DCC_SU2STR_SIZE];
	char ob[DCC_OPBUF];
	const char *op;

	op = !print_op ? "" : dcc_hdr_op2str(ob, sizeof(ob), &q->pkt.hdr);

	if (q->clnt_id == DCC_ID_ANON)
		snprintf(buf, sizeof(buf),
			 "%s from anonymous at %s",
			 op, dcc_su2str_err(&q->clnt_su));
	else if (q->ip_rl && (q->ip_rl->d.fgs & RL_FG_UKN_ID))
		snprintf(buf, sizeof(buf),
			 "%s from unknown ID %d at %s",
			 op, q->clnt_id, dcc_su2str_err(&q->clnt_su));
	else if (q->ip_rl && (q->ip_rl->d.fgs & RL_FG_PASSWD))
		snprintf(buf, sizeof(buf),
			 "%s from ID %d at %s with bad password ",
			 op, q->clnt_id, dcc_su2str_err(&q->clnt_su));
	else if (!(q->flags & Q_FG_TRUSTED))
		snprintf(buf, sizeof(buf),
			 "%s from bad ID %d at %s",
			 op, q->clnt_id, dcc_su2str_err(&q->clnt_su));
	else if (q->ip_rl && (q->ip_rl->d.fgs & RL_FG_BLACK_ID))
		snprintf(buf, sizeof(buf),
			 "%s from blacklisted ID %d at %s",
			 op, q->clnt_id, dcc_su2str_err(&q->clnt_su));
	else if (q->ip_rl && (q->ip_rl->d.fgs & RL_FG_BLACK_ADDR))
		snprintf(buf, sizeof(buf),
			 "%s from ID %d at blacklisted %s",
			 op, q->clnt_id, dcc_su2str_err(&q->clnt_su));
	else
		snprintf(buf, sizeof(buf),
			 "%s from ID %d at %s",
			 op, q->clnt_id, dcc_su2str_err(&q->clnt_su));

	return buf;
}



const char *
op_id_ip(QUEUE *q)
{
	static char buf[3+14+4+DCC_SU2STR_SIZE];
	char ob[DCC_OPBUF];

	if (!(q->flags & Q_FG_HAVE_TS)) {
		new_ts(&q->ts);
		q->flags |= Q_FG_HAVE_TS;
	}
	snprintf(buf, sizeof(buf), "%s from ID %d at %s %s",
		 dcc_hdr_op2str(ob, sizeof(ob), &q->pkt.hdr),
		 (DCC_CLNT_ID)ntohl(q->pkt.hdr.sender), Q_CIP(q),
		 ts2str_err(&q->ts));
	return buf;
}



void
log_op(QUEUE *q)
{
	if (q->flags & Q_FG_TRACED)
		return;

	dcc_trace_msg("%s", op_id_ip(q));

	q->flags |= Q_FG_TRACED;
}



/* complain about an anonymous, non-paying client */
void
vanon_msg(const char *p, va_list args)
{
	rl_age(&rl_all_anon, &rl_all_anon_rate);
	if ((DCC_TRACE_ANON_BIT & tracemask)
	    && (rl_all_anon.d.u.bug_credits > 0
		|| (DCC_TRACE_RLIM_BIT & tracemask))) {
		rl_all_anon.d.u.bug_credits -= RL_SCALE;
		dcc_vtrace_msg(p, args);
	}
}



void
anon_msg(const char *p, ...)
{
	va_list args;

	va_start(args, p);
	vanon_msg(p, args);
	va_end(args);
}



/* complain about a client */
void
vclnt_msg(const QUEUE *q, const char *p, va_list args)
{
	RL *ip_rl;

	ip_rl = q->ip_rl;

	if (!(q->flags & Q_FG_TRUSTED) || !ip_rl) {
		vanon_msg(p, args);
		return;
	}

	if ((DCC_TRACE_CLNT_BIT & tracemask) || (ip_rl->d.fgs & RL_FG_TRACE)) {
		rl_age(ip_rl, &rl_sub_rate);
		if (ip_rl->d.u.bug_credits >= 0
		    || (DCC_TRACE_RLIM_BIT & tracemask)) {
			ip_rl->d.u.bug_credits -= RL_SCALE;
			if (ip_rl->d.u.bug_credits < rl_bugs_rate.lo)
				ip_rl->d.u.bug_credits = rl_bugs_rate.lo;
			dcc_vtrace_msg(p, args);
		}
	}
}



/* complain about a client */
void
clnt_msg(const QUEUE *q, const char *p, ...)
{
	va_list args;

	va_start(args, p);
	vclnt_msg(q, p, args);
	va_end(args);
}



void
junk_msg(QUEUE *q, u_char print, const char *pat, ...)
{
	char log_msg[80], hdr_buf[80];
	u_char complain;
	va_list args;

	rl_get_q(q, DCC_PKT_VERS_INVALID, DCC_ID_ANON, RL_FG_NO_AUTH);

	rl_inc2(q->ip_rl, &rl_anon_rate, q->block_rl);
	rl_inc(&rl_all_anon, &rl_all_anon_rate);

	complain = 0;
	if (!(q->ip_rl->d.fgs & RL_FG_DROPPED)) {
		q->ip_rl->d.fgs |= RL_FG_DROPPED;
		complain = 1;
	}
	if (q->block_rl && !(q->block_rl->d.fgs & RL_FG_DROPPED)) {
		q->block_rl->d.fgs |= RL_FG_DROPPED;
		complain = 1;
	}
	if (complain
	    || (q->ip_rl->d.fgs & RL_FG_TRACE)
	    || (!(q->ip_rl->d.fgs & (RL_FG_BLACK_ID | RL_FG_BLACK_ADDR))
		&& (print || db_debug != 0))) {
		va_start(args, pat);
		vsnprintf(log_msg, sizeof(log_msg), pat, args);
		va_end(args);
		anon_msg("drop %s from %s (%s)", log_msg, Q_CIP(q),
			 hdr2str(hdr_buf, sizeof(hdr_buf),
				 &q->pkt.hdr, q->pkt_len));
	}
}
