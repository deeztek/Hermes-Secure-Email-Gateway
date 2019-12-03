/* Distributed Checksum Clearinghouse
 *
 * ask about a batch of checksums
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
 * Rhyolite Software DCC 2.3.167-1.166 $Revision$
 */

#include "dcc_ck.h"
#include "dcc_heap_debug.h"
#include "dcc_xhdr.h"

u_char spamassassin_body_kludge;

static CKSUM_THOLDS tholds_log;
CKSUM_THOLDS tholds_rej;
static u_char dcc_honor_nospam[DCC_DIM_CKS];

static u_char trim_grey_ip_addr;	/* remove IP address from grey triple */
static struct in6_addr grey_ip_mask;

static void honor_cnt(const GOT_CKS *cks, u_int *, DCC_CK_TYPES, DCC_TGTS);



#ifdef DCC_PKT_VERS5
/* figure old server's target count before our latest report */
static DCC_TGTS				/* return corrected current count */
save_p_tgts(GOT_SUM *g,			/* put previous count in g->tgts */
	    DCC_OPS op,
	    const u_char is_bulk,	/* computed with body counts */
	    const DCC_TGTS local_tgts,	/* real local target count */
	    const DCC_TGTS gross_tgts,	/* local count adjusted by blacklist */
	    DCC_TGTS c_tgts)		/* what the old DCC server said */
{
	DCC_CK_TYPES type = g->type;

	if (op == DCC_OP_QUERY) {
		/* if we switched servers and converted a report
		 * to a query, then guess the total that the
		 * server would have produced for a report
		 * instead of the query we sent.
		 *
		 * Assume the server is not running with -K.
		 * If the server's current value is 0 for a body checksum
		 * then assume the report we sent to the other server has not
		 * been flooded.
		 * Assume other checksums will always be zero/unknown. */
		if (DB_GLOBAL_NOKEEP(0, type))
			return 0;

		/* Assume the current value is really the previous value
		 * because flooding has not happened */
		g->tgts = c_tgts;

		if (c_tgts < DCC_TGTS_TOO_MANY
		    && (DCC_CK_IS_BODY(type)
			|| type == DCC_CK_REP_TOTAL
			|| (type == DCC_CK_REP_BULK && is_bulk))) {
			c_tgts += local_tgts;
			if (c_tgts > DCC_TGTS_TOO_MANY)
				c_tgts = DCC_TGTS_TOO_MANY;
		}
		return c_tgts;

	} else if (type == DCC_CK_REP_TOTAL) {
		if (c_tgts >= local_tgts)
			g->tgts = c_tgts - local_tgts;

	} else if (type == DCC_CK_REP_BULK) {
		if (!is_bulk)
			g->tgts = c_tgts;
		else if (c_tgts >= local_tgts)
			g->tgts = c_tgts - local_tgts;

	} else if (c_tgts >= gross_tgts
		   && gross_tgts < DCC_TGTS_TOO_MANY) {
		/* if possible infer server's value before our report */
		if (c_tgts >= DCC_TGTS_TOO_MANY)
			g->tgts = c_tgts;
		else
			g->tgts = c_tgts - gross_tgts;
	}

	return c_tgts;
}



#endif /* DCC_PKT_VERS5 */
int					/* 1=ok, 0=no answer, -1=fatal */
ask_dcc(DCC_EMSG *emsg,
	DCC_CLNT_CTXT *ctxt,
	DCC_CLNT_FGS clnt_fgs,		/* DCC_CLNT_FG_* */
	DCC_HEADER_BUF *hdr,		/* put results here */
	GOT_CKS *cks,			/*	and here */
	ASK_ST *ask_stp,		/*	and here */
	u_char spam,			/* spam==0 && local_tgts==0 --> query */
	u_char check_rep,		/* reputation makes spam for a target */
	DCC_TGTS total_tgts,		/* includes previous greylisted tgts */
	DCC_TGTS local_tgts)		/* report these targets to DCC server */
{
	union {
	    DCC_HDR	hdr;
	    DCC_REPORT	r;
	} rpt;
	DCC_OP_RESP resp;
	DCC_OPS op;
	DCC_CK *ck;
	GOT_SUM *g;
	DCC_TGTS gross_tgts;
	DCC_TGTS c_tgts;		/* server's current, total count */
	DCC_TGTS rep_total = 0;
	u_char is_bulk;
	u_char srvr_all_many;		/* all body counts are MANY */
	u_char srvr_one_many;		/* at least one MANY body count */
	CKS_WTGTS hdr_tgts;		/* values for X-DCC header */
	DCC_CK_TYPES type;
	DCC_SRVR_ID srvr_id;
	int pkt_len, recv_len, exp_len;
	int num_cks, ck_num, result;

	memset(&hdr_tgts, 0, sizeof(hdr_tgts));

	/* prepare a report for the nearest DCC server */
	if (local_tgts == 0 && !spam) {
		/* because of greylisting, we can have a target count of 0
		 * but need to report spam discovered by a DNS list */
		op = DCC_OP_QUERY;
		gross_tgts = 0;
		rpt.r.tgts = 0;
	} else {
		op = DCC_OP_REPORT;
		if (local_tgts == DCC_TGTS_TOO_MANY
		    || local_tgts == 0) {
			spam = 1;
			local_tgts = 1;
		}
		if (spam) {
			*ask_stp |= (ASK_ST_CLNT_ISSPAM | ASK_ST_LOGIT
				     | ASK_ST_RPT_SPAM);
			gross_tgts = DCC_TGTS_TOO_MANY;
			rpt.r.tgts = htonl(local_tgts | DCC_TGTS_SPAM);
		} else {
			gross_tgts = local_tgts;
			rpt.r.tgts = htonl(local_tgts);
		}
	}

	ck = rpt.r.cks;
	num_cks = 0;
	for (g = cks->sums; g <= &cks->sums[DCC_CK_TYPE_LAST]; ++g) {
		/* do not tell the DCC server about some checksums */
		if (!g->rpt2srvr)
			continue;
		ck->len = sizeof(*ck);
		ck->type = g->type;
		ck->sum = g->sum;
		++ck;
		++num_cks;
	}
	if (num_cks == 0) {
		/* pretend we always have at least a basic body checksum
		 * and guess that the DCC server would have answered 0 */
		xhdr_init(hdr, 0);
		xhdr_add_ck(hdr, DCC_CK_BODY, gross_tgts);
		honor_cnt(cks, ask_stp, DCC_CK_BODY, local_tgts);
		return 1;
	}

	/* send the report and see what the DCC server has to say */
	pkt_len = (sizeof(rpt.r) - sizeof(rpt.r.cks)
		   + num_cks * sizeof(rpt.r.cks[0]));
	result = dcc_clnt_op(emsg, ctxt, clnt_fgs, 0, &srvr_id, 0,
			     &rpt.hdr, pkt_len, op, &resp, sizeof(resp));

	/* try a query to different server if the first failed
	 * but a second was found */
	if (!result && srvr_id != DCC_ID_INVALID) {
		if (dcc_clnt_debug) {
			if (emsg && emsg->c[0] != '\0') {
				dcc_trace_msg("retry with different server"
					      " after: %s", emsg->c);
				emsg->c[0] = '\0';
			} else {
				dcc_trace_msg("retry with different server");
			}
		}
		op = DCC_OP_QUERY;
		result = dcc_clnt_op(emsg, ctxt, clnt_fgs | DCC_CLNT_FG_RETRY,
				     0, &srvr_id, 0,
				     &rpt.hdr, pkt_len,
				     op, &resp, sizeof(resp));
	}
	if (!result) {
		*ask_stp |= ASK_ST_LOGIT;
	} else {
		/* forget about it if the DCC server responded too strangely */
		recv_len = ntohs(resp.hdr.len);
#ifdef DCC_PKT_VERS5
		if (resp.hdr.pkt_vers <= DCC_PKT_VERS5)
			exp_len = (sizeof(resp.ans5) - sizeof(resp.ans5.b)
				   + num_cks*sizeof(DCC_TGTS));
		else
#endif
			exp_len = (sizeof(resp.ans) - sizeof(resp.ans.b)
				   + num_cks*sizeof(resp.ans.b[0]));
		if (recv_len != exp_len) {
			dcc_pemsg(EX_UNAVAILABLE, emsg,
				  "DCC %s: answered with %d instead of %d bytes",
				  dcc_srvr_nm(0), recv_len, exp_len);
			*ask_stp |= ASK_ST_LOGIT;
			result = -1;
		}
	}

	/* check the server's response to see if we have spam */
	is_bulk = (gross_tgts >= BULK_THRESHOLD);
	srvr_one_many = 0;
	srvr_all_many = 1;
	ck_num = 0;
	for (g = cks->sums; g <= &cks->sums[DCC_CK_TYPE_LAST]; ++g) {
		/* We did not have this checksum. */
		if (!g->rpt2srvr) {
			/* pretend we always have a basic body checksum */
			if (g == &cks->sums[DCC_CK_BODY])
				honor_cnt(cks, ask_stp,
					  DCC_CK_BODY, local_tgts);
			continue;
		}

		type = g->type;
		if (result <= 0) {
			c_tgts = (DCC_CK_IS_BODY(type)) ? gross_tgts : 0;

#ifdef DCC_PKT_VERS5
		} else if (resp.hdr.pkt_vers <= DCC_PKT_VERS5) {
			c_tgts = save_p_tgts(g, op,
					     is_bulk,
					     local_tgts, gross_tgts,
					     ntohl(resp.ans5.b[ck_num]));
		} else {
#endif /* DCC_PKT_VERS5 */
			/* server's total before our report */
			g->tgts = ntohl(resp.ans.b[ck_num].p);
			/* new total */
			c_tgts = ntohl(resp.ans.b[ck_num].c);
#ifdef DCC_PKT_VERS5
		}
#endif
		++ck_num;

		if (DCC_CK_IS_BODY(type)) {
			if (c_tgts >= BULK_THRESHOLD)
				is_bulk = 1;
			if (c_tgts < DCC_TGTS_TOO_MANY)
				srvr_all_many = 0;
			else
				srvr_one_many = 1;
		}

		/* only compute bulk ratio with enough data */
		if (type == DCC_CK_REP_TOTAL) {
			/* Never add to X-DCC header for IP address total.
			 * Total reputation tgts can cause logging but
			 * not rejection. */
			if (c_tgts >= tholds_log.t[DCC_CK_REP_TOTAL])
				*ask_stp |= ASK_ST_LOGIT;
			/* rejection threshold sets reputation significance */
			if (c_tgts >= cks->tholds_rej.t[DCC_CK_REP_TOTAL])
				rep_total = c_tgts;
			continue;
		}

		/* assume that DCC_CK_REP_BULK is the last checksum,
		 * and so all other checksums have been seen,
		 * and so rep_total and bulk are right */
		if (type == DCC_CK_REP_BULK) {
			if (rep_total != 0) {
				u_int rep = get_reputation(c_tgts, rep_total);
				hdr_tgts.v[type] = rep+1;

				if (cks->tholds_rej.t[DCC_CK_REP_BULK] <= rep
				    && !(*ask_stp & ASK_ST_SRVR_NOTSPAM)) {
					*ask_stp |= (ASK_ST_REP_ISSPAM
						     | ASK_ST_LOGIT);
				}

				if (tholds_log.t[DCC_CK_REP_BULK] <= rep)
					*ask_stp |= ASK_ST_LOGIT;
			}
			continue;
		}

		hdr_tgts.v[type] = c_tgts;

		/* notice DCC server's whitelist */
		if (dcc_honor_nospam[type]) {
			if (c_tgts == DCC_TGTS_OK) {
				*ask_stp |= ASK_ST_SRVR_NOTSPAM;

			} else if (c_tgts == DCC_TGTS_OK2) {
				/* if server says it is half ok,
				 * look for two halves */
				if (*ask_stp & ASK_ST_SRVR_OK2) {
					*ask_stp |= ASK_ST_SRVR_NOTSPAM;
				} else {
					*ask_stp |= ASK_ST_SRVR_OK2;
				}
			}
		}

		honor_cnt(cks, ask_stp, type, c_tgts);
	}

	/* honor server whitelist */
	if (*ask_stp & ASK_ST_SRVR_NOTSPAM)
		*ask_stp &= ~ASK_ST_SRVR_ISSPAM;

	/* Tell the DCC server if the message was not spam on its own counts
	 *	but the reputation of the sender made the message spam for
	 *	at least one recipient.
	 * If the message was spam, we still need to tell the DCC Reputation
	 *	server about targets that were counted during greylisting
	 *	before the embargo expired and not reported to the DCC server
	 *	this time.
	 */
	if ((!srvr_all_many && check_rep
	     && (*ask_stp & ASK_ST_REP_ISSPAM) && total_tgts != 0)
	    || (srvr_all_many && total_tgts > local_tgts)) {
		u_char send_rep, send_bodies;

		if (srvr_one_many)
			rpt.r.tgts = htonl(1 | DCC_TGTS_REP_SPAM);
		else
			rpt.r.tgts = htonl(1 | DCC_TGTS_REP_SPAM
					   | DCC_TGTS_SPAM);
		ck = rpt.r.cks;
		num_cks = 0;
		send_rep = 0;
		send_bodies = 0;
		for (g = cks->sums; g <= &cks->sums[DCC_CK_TYPE_LAST]; ++g) {
			if (!g->rpt2srvr)
				continue;
			if (g->type == DCC_CK_REP_TOTAL) {
				DCC_TGTS tgts;

				/* Try to make the database contents be the
				 * same as they would be if mail were delivered
				 * with one recipient per transaction and
				 * with the first recipient caring about
				 * reputations. */

				if (srvr_all_many) {
					/* Worsen sender's reputation with
					 * previously embargoed targets if
					 * the message is now spam.
					 * When it was embargoed, it was not
					 * spam or we would not have old
					 * embargo counts.
					 * However, it might have had counts
					 * above BULK_THRESHOLD and been bulk.
					 * This can over-report a spamming
					 * IP address, but let's hope rarely */
					tgts = total_tgts - local_tgts;

				} else if (!is_bulk) {
					/* If the message was addressed to >=2
					 * targets but was not known to be spam
					 * until now, then hit the IP address.
					 * Otherwise, there would be a
					 * difference between sending
					 * this message in one SMTP transaction
					 * or 2 or more transactions.
					 * Only later transactions would find
					 * the message marked bulk and would
					 * report the sender as a bulk mailer */
					tgts = total_tgts - 1;
				} else {
					continue;
				}
				if (tgts > 0)
					send_rep = 1;
				rpt.r.tgts = htonl(tgts
						   | DCC_TGTS_REP_SPAM
						   | DCC_TGTS_SPAM);
				/* Do not include this checksum and
				 * so increase the total reputation count
				 * with this extra DCC report, because all
				 * recipients have already been counted. */
				continue;
			} else if (g->type == DCC_CK_REP_BULK) {
				/* This checksum always comes after
				 * DCC_CK_REP_TOTAL.  One of the points of this
				 * exercise is tell the server about additional
				 * reasons for a reputation. */
				if (!send_rep)
					continue;
			} else if (DCC_CK_IS_BODY(g->type)) {
				/* Include the body checksums even if the server
				 * always knows they are spam to ease
				 * investigations of bulk mail reputations. */
				if (!srvr_all_many) {
					/* We need to send this report if server
					 * did not know the message is spam.
					 * Otherwise this checksum just tags
					 * along with the reputation report. */
					send_bodies = 1;
					/* Force X-DCC header counts to be "many"
					 * since that's what they are now. */
					hdr_tgts.v[g->type] = DCC_TGTS_TOO_MANY;
				}
			} else {
				continue;
			}
			ck->len = sizeof(*ck);
			ck->type = g->type;
			ck->sum = g->sum;
			++ck;
			++num_cks;
		}
		if ((send_rep || send_bodies) && result > 0) {
			pkt_len = (sizeof(rpt.r) - sizeof(rpt.r.cks)
				   + num_cks * sizeof(rpt.r.cks[0]));
			dcc_clnt_op(emsg, ctxt, clnt_fgs, 0, &srvr_id, 0,
				    &rpt.hdr, pkt_len, DCC_OP_REPORT,
				    &resp, sizeof(resp));
			*ask_stp |= ASK_ST_RPT_SPAM;
		}
	}

	/* generate the header line now that we have checked all of
	 * the counts against their thresholds and so know if we
	 * must add "bulk".  Add the header even if checking is turned off
	 * and we won't reject affected messages.  Say "many" for DNSBL
	 * or local blacklist spam even without an answer from the DCC server
	 * so that SpamAssassin gets the message. */
	xhdr_init(hdr, srvr_id);
	if (*ask_stp & ASK_ST_SRVR_ISSPAM) {
		xhdr_add_str(hdr, DCC_XHDR_BULK);
	} else if (*ask_stp & ASK_ST_CLNT_ISSPAM) {
		xhdr_add_str(hdr, DCC_XHDR_BULK);
		if (spamassassin_body_kludge)
			hdr_tgts.v[DCC_CK_BODY] = DCC_TGTS_TOO_MANY;
	} else if (*ask_stp & ASK_ST_REP_ISSPAM) {
		xhdr_add_str(hdr, DCC_XHDR_BULK_REP);
		if (spamassassin_body_kludge)
			hdr_tgts.v[DCC_CK_BODY] = DCC_TGTS_TOO_MANY;
	}

	for (g = cks->sums; g <= &cks->sums[DCC_CK_TYPE_LAST]; ++g) {
		if (!g->rpt2srvr) {
			/* pretend we always have a body checksum */
			if (g == &cks->sums[DCC_CK_BODY])
				xhdr_add_ck(hdr, DCC_CK_BODY,
					    hdr_tgts.v[DCC_CK_BODY]);
			continue;
		}
		/* Add interesing counts to the header.
		 * Body checksums are always interestig if we have them.
		 * Pretend we always have a basic body checksum. */
		type = g->type;
		if (DCC_CK_IS_BODY(type)) {
			xhdr_add_ck(hdr, type, hdr_tgts.v[type]);
			continue;
		}
		if (hdr_tgts.v[type] != 0)
			xhdr_add_ck(hdr, type, hdr_tgts.v[type]);
	}

	return result;
}



/* check message's checksums in whiteclnt for dccproc or dccsight */
u_char					/* 1=ok 0=something to complain about */
unthr_ask_white(DCC_EMSG *emsg,
		ASK_ST *ask_stp,
		FLTR_SWS *swsp,
		const char *white_nm,
		GOT_CKS *cks,
		CKS_WTGTS *wtgts)
{
	WHITE_LISTING listing;
	int retval;

	/* assume DNS lists are on unless turned off, because there is no reason
	 * to use `dccproc -B` if you don't want to use them */
	*swsp |= FLTR_SW_DNSBL_M;

	/* fake whiteclnt if not specified */
	if (!white_nm) {
		merge_tholds(&cks->tholds_rej, &tholds_rej, 0);
		return 1;
	}

	/* don't filter if something is wrong with the file */
	if (!dcc_new_white_nm(emsg, &cmn_wf, white_nm)) {
		*ask_stp |= ASK_ST_WLIST_NOTSPAM | ASK_ST_LOGIT;
		return 0;
	}

	/* let whiteclnt file turn off the DCC and other filters */
	*swsp = wf2sws(*swsp, &cmn_wf);

	/* combine the command-line thresholds with the thresholds from
	 * from the common /var/dcc/whiteclnt file */
	merge_tholds(&cks->tholds_rej, &tholds_rej, cmn_wf.wtbl);

	retval = 1;
	switch (wf_cks(emsg, &cmn_wf, cks, wtgts, &listing)) {
	case WHITE_OK:
	case WHITE_NOFILE:
		break;
	case WHITE_SILENT:
		*ask_stp |= ASK_ST_LOGIT;
		break;
	case WHITE_COMPLAIN:
	case WHITE_CONTINUE:
		retval = 0;
		*ask_stp |= ASK_ST_LOGIT;
		break;
	}

	switch (listing) {
	case WHITE_LISTED:
		/* do not send whitelisted checksums to DCC server */
		*ask_stp |= ASK_ST_WLIST_NOTSPAM;
		break;
	case WHITE_USE_DCC:
	case WHITE_UNLISTED:
		if (*swsp & FLTR_SW_TRAP)
			*ask_stp |= (ASK_ST_CLNT_ISSPAM | ASK_ST_WLIST_ISSPAM
				     | ASK_ST_LOGIT);
		break;
	case WHITE_BLACK:
		*ask_stp |= (ASK_ST_WLIST_ISSPAM
			     | ASK_ST_CLNT_ISSPAM | ASK_ST_LOGIT);
		break;
	}

	if (*swsp & FLTR_SW_LOG_ALL)
		*ask_stp |= ASK_ST_LOGIT;

	return retval;
}



/* ask the DCC for dccproc or dccsight but not dccifd or dccm */
u_char					/* 1=ok 0=something to complain about */
unthr_ask_dcc(DCC_EMSG *emsg,
	      DCC_CLNT_CTXT *ctxt,
	      DCC_HEADER_BUF *hdr,	/* put header here */
	      ASK_ST *ask_stp,		/* put state bites here */
	      FLTR_SWS sws,
	      GOT_CKS *cks,		/* these checksums */
	      u_char spam,		/* spam==0 && local_tgts==0 --> query */
	      DCC_TGTS local_tgts)	/* number of addressees */
{
	if (*ask_stp & ASK_ST_WLIST_NOTSPAM) {
		if (spam) {
			/* if dccproc says it is spam, then it is, even if
			 * the whiteclnt file says we cannot report it */
			*ask_stp |= (ASK_ST_CLNT_ISSPAM | ASK_ST_LOGIT);
			xhdr_init(hdr, 0);
			xhdr_add_ck(hdr, DCC_CK_BODY, DCC_TGTS_TOO_MANY);
		} else {
			xhdr_whitelist(hdr);
		}
		/* honor log threshold for whitelisted messages */
		dcc_honor_log_cnts(ask_stp, cks, local_tgts);
		return 1;

	} else {
		/* if allowed by whitelisting, report our checksums to the DCC
		 * and return with that result including setting logging */
		return (0 < ask_dcc(emsg, ctxt, DCC_CLNT_FG_NONE,
				    hdr, cks, ask_stp, spam,
				    sws & FLTR_SW_REP_ON, local_tgts,
				    local_tgts));
	}
}



/* parse -g for dccm and dccproc */
void
dcc_parse_honor(const char *arg0)
{
	const char *arg;
	DCC_CK_TYPES type, t2;
	int i;

	arg = arg0;
	if (!CLITCMP(arg, "not_") || !CLITCMP(arg, "not-")) {
		arg += LITZ("not_");
		i = 0;
	} else if (!CLITCMP(arg, "no_") || !CLITCMP(arg, "no-")) {
		arg += LITZ("no_");
		i = 0;
	} else {
		i = 1;
	}

	/* allow -g for ordinary checksums but not reputations or greylisting */
	type = dcc_str2type_thold(arg, -1);
	if (type == DCC_CK_INVALID) {
		dcc_error_msg("unrecognized checksum type in \"-g %s\"",
			      arg0);
		return;
	}
	for (t2 = DCC_CK_TYPE_FIRST; t2 <= DCC_CK_TYPE_LAST; ++t2) {
		if (t2 == type
		    || (type == SET_ALL_THOLDS && IS_ALL_CKSUM(t2))
		    || (type == SET_CMN_THOLDS && IS_CMN_CKSUM(t2)))
			dcc_honor_nospam[t2] = i;
	}
}



void
dcc_clear_tholds(void)
{
	DCC_CK_TYPES type;

	memset(dcc_honor_nospam, 0, sizeof(dcc_honor_nospam));
	dcc_honor_nospam[DCC_CK_IP] = 1;
	dcc_honor_nospam[DCC_CK_ENV_FROM] = 1;
	dcc_honor_nospam[DCC_CK_FROM] = 1;

	for (type = DCC_CK_TYPE_FIRST; type <= DCC_CK_TYPE_LAST; ++type) {
		tholds_log.t[type] = THOLD_UNSET;
		tholds_rej.t[type] = THOLD_UNSET;
	}

	tholds_rej.t[DCC_CK_REP_TOTAL] = DCC_REP_TOTAL_THOLD_DEF;
}



/* Merge thresholds from a whitelist into an existing set.
 *	All settings (as opposed to missing settings) from the
 *	whitelist are copied into the output, possibly overriding
 *	settings in the input. */
u_char					/* 1=merged from whiteclnt wtbl */
merge_tholds(CKSUM_THOLDS *out,
	     const CKSUM_THOLDS *in,
	     const WHITE_TBL *wtbl)
{
	DCC_CK_TYPES type;
	DCC_TGTS tgts;
	u_char result;

	if (in != out)
		*out = *in;
	if (!wtbl)
		return 0;

	result = 0;
	for (type = DCC_CK_TYPE_FIRST; type <= DCC_CK_TYPE_LAST; ++type) {
		tgts = wtbl->hdr.tholds_rej.t[type];
		if (tgts != THOLD_UNSET) {
			out->t[type] = tgts;
			result = 1;
		}
	}
	return result;
}



/* parse type,[log-thold,]rej-thold */
u_char					/* 1=need a log directory */
dcc_parse_tholds(const char *f,		/* "-c " or "-t " */
		 const char *arg)	/* optarg */
{
	DCC_CK_TYPES type;
	DCC_TGTS log_tgts, rej_tgts;
	char *thold_rej, *thold_log;
	u_char log_tgts_set, rej_tgts_set, have_thold_log;

	thold_log = strchr(arg, ',');
	if (!thold_log) {
		dcc_error_msg("missing comma in \"%s%s\"", f, arg);
		return 0;
	}
	type = dcc_str2type_thold(arg, thold_log-arg);
	if (type == DCC_CK_INVALID) {
		dcc_error_msg("unrecognized checksum type in \"%s%s\"", f, arg);
		return 0;
	}

	thold_log = dcc_strdup(++thold_log);

	/* if there is only one threshold, take it as the spam threshold */
	thold_rej = strchr(thold_log, ',');
	if (!thold_rej) {
		thold_rej = thold_log;
		have_thold_log = 0;
	} else {
		*thold_rej++ = '\0';
		have_thold_log = 1;
	}

	log_tgts_set = log_tgts = 0;
	if (have_thold_log && *thold_log != '\0') {
		log_tgts = dcc_str2thold(type, thold_log);
		if (log_tgts == DCC_TGTS_INVALID)
			dcc_error_msg("unrecognized logging threshold"
				      " \"%s\" in \"%s%s\"",
				      thold_log, f, arg);
		else
			log_tgts_set = 1;
	}


	rej_tgts_set = rej_tgts = 0;
	if (!thold_rej || *thold_rej == '\0') {
		if (!have_thold_log || *thold_log == '\0')
			dcc_error_msg("no thresholds in \"%s%s\"", f, arg);
	} else {
		rej_tgts = dcc_str2thold(type, thold_rej);
		if (rej_tgts == DCC_TGTS_INVALID)
			dcc_error_msg("unrecognized rejection threshold"
				      " \"%s\" in \"%s%s\"",
				      thold_rej, f, arg);
		else
			rej_tgts_set = 1;
	}


	if (log_tgts_set || rej_tgts_set) {
		DCC_CK_TYPES t2;

		for (t2 = DCC_CK_TYPE_FIRST; t2 <= DCC_CK_TYPE_LAST; ++t2) {
			if (t2 == type
			    || (type == SET_ALL_THOLDS && IS_ALL_CKSUM(t2))
			    || (type == SET_CMN_THOLDS && IS_CMN_CKSUM(t2))) {
				if (log_tgts_set)
					tholds_log.t[t2] = log_tgts;
				if (rej_tgts_set)
					tholds_rej.t[t2] = rej_tgts;
			}
		}
	}

	dcc_free(thold_log);
	return log_tgts_set;
}



static void
honor_cnt(const GOT_CKS *cks,
	  ASK_ST *ask_stp,		/* previous flag bits */
	  DCC_CK_TYPES type,		/* which kind of checksum */
	  DCC_TGTS type_tgts)		/* total count for the checksum */
{
	if (type >= DIM(dcc_honor_nospam))
		return;

	/* reject and log spam */
	if (cks->tholds_rej.t[type] <= DCC_TGTS_TOO_MANY
	    && cks->tholds_rej.t[type] <= type_tgts
	    && type_tgts <= DCC_TGTS_TOO_MANY) {
		*ask_stp |= (ASK_ST_SRVR_ISSPAM | ASK_ST_LOGIT);
		return;
	}

	/* log messages that are bulkier than the log threshold */
	if (tholds_log.t[type] <= DCC_TGTS_TOO_MANY
	    && tholds_log.t[type] <= type_tgts)
		*ask_stp |= ASK_ST_LOGIT;
}



/* honor log threshold for local counts and white-/blacklists */
void
dcc_honor_log_cnts(ASK_ST *ask_stp,	/* previous flag bits */
		   const GOT_CKS *cks,  /* these server counts */
		   DCC_TGTS tgts)
{
	const GOT_SUM *g;
	DCC_CK_TYPES type;

	if (*ask_stp & ASK_ST_LOGIT)
		return;

	if (tgts == DCC_TGTS_TOO_MANY) {
		*ask_stp |= ASK_ST_LOGIT;
		return;
	}

	/* pretend we always have a body checksum for the log threshold */
	if (tholds_log.t[DCC_CK_BODY] <= DCC_TGTS_TOO_MANY
	    && tholds_log.t[DCC_CK_BODY] <= tgts) {
		*ask_stp |= ASK_ST_LOGIT;
		return;
	}

	for (g = cks->sums; g <= LAST(cks->sums); ++g) {
		type = g->type;
		if (type == DCC_CK_INVALID
		    || type == DCC_CK_ENV_TO)
			continue;
		if (tholds_log.t[type] > DCC_TGTS_TOO_MANY)
			continue;
		if (tholds_log.t[type] <= tgts) {
			*ask_stp |= ASK_ST_LOGIT;
			return;
		}
	}
}



/* compute switch settings from bits in a whiteclnt file */
FLTR_SWS
wf2sws(FLTR_SWS sws, const WF *wf)
{
	static time_t complained;
	time_t now;
	DCC_PATH abs_nm;
	int i;

	if (!grey_on
	    && (wf->wtbl_sws & (WHITE_SW_GREY_ON | WHITE_SW_GREY_LOG_ON))
	    && (now = time(0)) > complained+24*60*60) {
		complained = now;
		dcc_error_msg("%s wants greylisting"
			      " but it is turned off",
			      dcc_fnm2abs_msg(&abs_nm, wf->ascii_nm.c));
	}

	/* compute switch values from whiteclnt bits */

	if (wf->wtbl_sws & WHITE_SW_DISCARD_NO)
		sws |= FLTR_SW_DISCARD_NO;
	else if (wf->wtbl_sws & WHITE_SW_DISCARD_OK)
		sws &= ~FLTR_SW_DISCARD_NO;

	if ((wf->wtbl_sws & WHITE_SW_DCC_OFF))
		sws |= FLTR_SW_DCC_OFF;
	else if (wf->wtbl_sws & WHITE_SW_DCC_ON)
		sws &= ~FLTR_SW_DCC_OFF;

	if (grey_on && (wf->wtbl_sws & WHITE_SW_GREY_ON)) {
		sws &= ~FLTR_SW_GREY_OFF;
	} else if (!grey_on || (wf->wtbl_sws & WHITE_SW_GREY_OFF)) {
		sws |= FLTR_SW_GREY_OFF;
	}

	if (wf->wtbl_sws & WHITE_SW_GREY_SPAM_ON) {
		sws |= FLTR_SW_GREY_IGN_SPAM;
	} else if (wf->wtbl_sws & WHITE_SW_GREY_SPAM_OFF) {
		sws &= ~FLTR_SW_GREY_IGN_SPAM;
	}

	if (wf->wtbl_sws & WHITE_SW_LOG_ALL) {
		sws |= FLTR_SW_LOG_ALL;
	} else if (wf->wtbl_sws & WHITE_SW_LOG_NORMAL) {
		sws &= ~FLTR_SW_LOG_ALL;
	}

	if (wf->wtbl_sws & WHITE_SW_GREY_LOG_ON) {
		sws &= ~FLTR_SW_GREY_LOG_OFF;
	} else if (wf->wtbl_sws & WHITE_SW_GREY_LOG_OFF) {
		sws |= FLTR_SW_GREY_LOG_OFF;
	}

	if (wf->wtbl_sws & WHITE_SW_LOG_M) {
		sws |= FLTR_SW_LOG_M;
	} else if (wf->wtbl_sws & WHITE_SW_LOG_H) {
		sws |= FLTR_SW_LOG_H;
	} else if (wf->wtbl_sws & WHITE_SW_LOG_D) {
		sws |= FLTR_SW_LOG_D;
	}

	if (wf->wtbl_sws & WHITE_SW_MTA_FIRST) {
		sws |= FLTR_SW_MTA_FIRST;
	} else if (wf->wtbl_sws & WHITE_SW_MTA_LAST) {
		sws &= ~FLTR_SW_MTA_FIRST;
	}

	for (i = 0; i < NUM_DNSBL_GROUPS; ++i) {
		if ((wf->wtbl_sws & WHITE_SW_DNSBL_ON(i))
		    && dnsbls) {
			sws |= FLTR_SW_DNSBL(i);
		} else if (wf->wtbl_sws & WHITE_SW_DNSBL_OFF(i)) {
			sws &= ~FLTR_SW_DNSBL(i);
		}
	}

	if (wf->wtbl_sws & WHITE_SW_REP_ON) {
		sws |= FLTR_SW_REP_ON;
	} else if (wf->wtbl_sws & WHITE_SW_REP_OFF) {
		sws &= ~FLTR_SW_REP_ON;
	}

	if (wf->wtbl_sws & WHITE_SW_TRAP_DIS) {
		sws |= FLTR_SW_TRAP | FLTR_SW_TRAP_DIS;
		sws &= ~FLTR_SW_TRAP_REJ;
	} else if (wf->wtbl_sws & WHITE_SW_TRAP_REJ) {
		sws &= ~FLTR_SW_TRAP_DIS;
		sws |= FLTR_SW_TRAP | FLTR_SW_TRAP_REJ;
	} else if (wf->wtbl_sws & WHITE_SW_TRAP_NOT) {
		sws &= ~(FLTR_SW_TRAP | FLTR_SW_TRAP_DIS | FLTR_SW_TRAP_REJ);
	}

	/* adjust other switches for trapping */
	if (sws & FLTR_SW_TRAP) {
		sws |= (FLTR_SW_GREY_OFF | FLTR_SW_REP_ON);
		/* always report trapped spam
		 * DNS lists are redundant for traps */
		sws &= ~(FLTR_SW_DCC_OFF | FLTR_SW_DNSBL_M);
	}

	return sws | FLTR_SW_SET;
}



#define LOG_ASK_ST_BLEN	    160
#define LOG_ASK_ST_OFF	    "(off)"
#define LOG_ASK_ST_OVF	    " ...\n\n"
static int
log_ask_st_sub(char *buf, int blen,
	       const char *s, int slen,
	       u_char off)
{
	int dlen, tlen;

	/* quit if no room at all in the log */
	if (blen >= LOG_ASK_ST_BLEN)
		return LOG_ASK_ST_BLEN;

	/* quit if nothing to say */
	if (!s || !slen)
		return blen;

	dlen = LOG_ASK_ST_BLEN - blen;
	tlen = LITZ(LOG_ASK_ST_OVF)+2+slen;
	if (off)			/* notice if we need to say "(off)" */
		tlen += LITZ(LOG_ASK_ST_OFF);
	if (dlen <= tlen) {
		/* show truncation of the message with "..." */
		memcpy(&buf[blen], LOG_ASK_ST_OVF, LITZ(LOG_ASK_ST_OVF));
		blen += LITZ(LOG_ASK_ST_OVF);
		if (blen < LOG_ASK_ST_BLEN)
			memset(&buf[blen], ' ', LOG_ASK_ST_BLEN-blen);
		return LOG_ASK_ST_BLEN;
	}

	if (blen > 0 && buf[blen-1] != '\n') {
		buf[blen++] = ' ';
		buf[blen++] = ' ';
	}
	memcpy(buf+blen, s, slen);
	blen += slen;
	if (off) {
		memcpy(buf+blen, LOG_ASK_ST_OFF, LITZ(LOG_ASK_ST_OFF));
		blen += LITZ(LOG_ASK_ST_OFF);
	}
	return blen;
}



/* generate log file line of results */
void
log_ask_st(LOG_WRITE_FNC fnc, void *cp,
	   ASK_ST ask_st,
	   FLTR_SWS and_sws,
	   FLTR_SWS or_sws,
	   u_char log_type,		/* 0="" 1="per-user" 2="global" */
	   const DCC_HEADER_BUF *hdr)
{
	char buf[LOG_ASK_ST_BLEN+3];
	int blen, len, i;
#define S(str,off) (blen = log_ask_st_sub(buf, blen, str, LITZ(str), (off) != 0))
#define S0(bit,off,str) (((ask_st & bit) != 0) ? S(str,off) : 0)
#define S1(bit,off,str) S0(bit,off,str)
#define S2(bit,str) S0(bit,0,str)

	blen = 0;
	S2(ASK_ST_QUERY, "query");

	/* the CGI scripts want to know why */
	if (or_sws & FLTR_SW_MTA_FIRST) {
		S2(ASK_ST_MTA_ISSPAM,	"MTA"DCC_XHDR_ISSPAM);
		S2(ASK_ST_MTA_NOTSPAM,	"MTA"DCC_XHDR_ISOK);
	}

	S2(ASK_ST_WLIST_NOTSPAM,	"wlist"DCC_XHDR_ISOK);
	S2(ASK_ST_WLIST_ISSPAM,		"wlist"DCC_XHDR_ISSPAM);

	S1(ASK_ST_SRVR_ISSPAM, and_sws & FLTR_SW_DCC_OFF, "DCC"DCC_XHDR_ISSPAM);
	S1(ASK_ST_SRVR_NOTSPAM,	and_sws & FLTR_SW_DCC_OFF, "DCC"DCC_XHDR_ISOK);
	S1(ASK_ST_REP_ISSPAM, !(or_sws & FLTR_SW_REP_ON), "Rep"DCC_XHDR_ISSPAM);

	for (i = 0; i < NUM_DNSBL_GROUPS; ++i) {
		char mbuf[24];
		const char *res;

		if (ask_st & (ASK_ST_DNSBL_W(i) | ASK_ST_DNSBL_B(i))) {
			/* log "DNSBLx-->spam" "DNSBLx-->spam(off)"
			*  "DNSBLx-->ok" or "DNSBLx-->ok(off)" */
			res = ((ask_st & ASK_ST_DNSBL_W(i))
			       ? DCC_XHDR_ISOK : DCC_XHDR_ISSPAM);
			if (have_dnsbl_groups)
				len = snprintf(mbuf, sizeof(mbuf),
					       "DNSBL%d%s", i+1, res);
			else
				len = snprintf(mbuf, sizeof(mbuf),
					       "DNSBL%s", res);
			if (len >= ISZ(mbuf))
				len = ISZ(mbuf)-1;
			blen = log_ask_st_sub(buf, blen, mbuf, len,
					      0 == (or_sws & FLTR_SW_DNSBL(i)));
		} else if (ask_st & ASK_ST_DNSBL_TIMEO(i)) {
			if (have_dnsbl_groups)
				len = snprintf(mbuf, sizeof(mbuf),
					       "DNSBL%d(timeout)", i+1);
			else
				len = snprintf(mbuf, sizeof(mbuf),
					       "DNSBL(timeout)");
			if (len >= ISZ(mbuf))
				len = ISZ(mbuf)-1;
			blen = log_ask_st_sub(buf, blen, mbuf, len, 0);
		}
	}

	if (!(or_sws & FLTR_SW_MTA_FIRST)) {
		S2(ASK_ST_MTA_ISSPAM,	"MTA"DCC_XHDR_ISSPAM);
		S2(ASK_ST_MTA_NOTSPAM,  "MTA"DCC_XHDR_ISOK);
	}
	blen = log_ask_st_sub(buf, blen, dcc_progname.c, dcc_progname_len, 0);
	if (log_type == 1) {
		blen = log_ask_st_sub(buf, blen,
				      "per-user-log", LITZ("per-user-log"), 0);
	} else if (log_type == 2) {
		blen = log_ask_st_sub(buf, blen,
				      "global-log", LITZ("global-log"), 0);
	}
	blen = log_ask_st_sub(buf, blen, "\n\n", 2, 0);
	fnc(cp, buf, blen);

	if (hdr->used != 0)
		xhdr_write(fnc, cp, hdr->buf, hdr->used, 0);
#undef S
#undef S0
#undef S1
#undef S2
}



/* parse -G options for DCC clients */
u_char					/* 0=bad */
dcc_parse_client_grey(const char *arg)
{
	int bits;
	const char *p;

	while (*arg != '\0') {
		if (ck_word_comma(&arg, "on")) {
			grey_on = 1;
			continue;
		}
		if (ck_word_comma(&arg, "off")) {
			grey_on = 0;
			continue;
		}
		if (ck_word_comma(&arg, "noIP")) {
			grey_on = 1;
			trim_grey_ip_addr = 1;
			memset(&grey_ip_mask, 0, sizeof(grey_ip_mask));
			continue;
		}
		if (!CLITCMP(arg, "IPmask/")) {
			bits = 0;
			for (p = arg+LITZ("IPmask/");
			     *p >= '0' && *p <= '9';
			     ++p)
				bits = bits*10 + *p - '0';
			if (bits > 0 && bits < 128
			    && (*p == '\0' || *p == ',')) {
				arg = p;
				if (*p == ',')
					++arg;
				grey_on = 1;
				trim_grey_ip_addr = 1;
				/* assume giant blocks are really IPv4 */
				if (bits <= 32)
					bits += 128-32;
				bits2mask(&grey_ip_mask, bits);
				continue;
			}
		}
		return 0;
	}
	return 1;
}



/* sanity check the DCC server's answer */
u_char
dcc_ck_grey_answer(DCC_EMSG *emsg, const DCC_OP_RESP *resp)
{
	int recv_len;

	recv_len = ntohs(resp->hdr.len);
	if (resp->hdr.op != DCC_OP_ANSWER) {
		dcc_pemsg(EX_UNAVAILABLE, emsg, "DCC %s: %s %*s",
			  dcc_srvr_nm(1),
			  dcc_hdr_op2str(0, 0, &resp->hdr),
			  (resp->hdr.op == DCC_OP_ERROR
			   ? (recv_len - (ISZ(resp->error)
					  - ISZ(resp->error.msg)))
			   : 0),
			  resp->error.msg);
		return 0;
	}

	if (recv_len != sizeof(DCC_GREY_ANSWER)) {
		dcc_pemsg(EX_UNAVAILABLE, emsg,
			  "greylist server %s answered with %d instead of"
			  " %d bytes",
			  dcc_srvr_nm(1), recv_len, ISZ(DCC_GREY_ANSWER));
		return 0;
	}

	return 1;
}



ASK_GREY_RESULT
ask_grey(DCC_EMSG *emsg,
	 DCC_CLNT_CTXT *ctxt,
	 DCC_OPS op,			/* DCC_OP_GREY_{REPORT,QUERY,WHITE} */
	 DCC_SUM *msg_sum,		/* put msg+sender+target cksum here */
	 DCC_SUM *triple_sum,		/* put greylist triple checksum here */
	 const GOT_CKS *cks,
	 const DCC_SUM *env_to_sum,
	 DCC_TGTS *pembargo_num,
	 DCC_TGTS *pearly_tgts,		/* ++ report to DCC even if embargoed */
	 DCC_TGTS *plate_tgts)		/* ++ don't report to DCC */
{
	MD5_CTX ctx;
	DCC_REPORT rpt;
	DCC_OP_RESP resp;
	DCC_CK *ck;
	DCC_CK_TYPES type;
	const GOT_SUM *g;
	DCC_TGTS result_tgts;
	int num_cks;

	if (cks->sums[DCC_CK_IP].type != DCC_CK_IP) {
		dcc_pemsg(EX_UNAVAILABLE, emsg,
			  "IP address not available for greylisting");
		memset(triple_sum, 0, sizeof(*triple_sum));
		memset(msg_sum, 0, sizeof(*msg_sum));
		return ASK_GREY_FAIL;
	}
	if (cks->sums[DCC_CK_ENV_FROM].type != DCC_CK_ENV_FROM) {
		dcc_pemsg(EX_UNAVAILABLE, emsg,
			  "env_From not available for greylisting");
		memset(triple_sum, 0, sizeof(*triple_sum));
		memset(msg_sum, 0, sizeof(*msg_sum));
		return ASK_GREY_FAIL;
	}

	/* Check the common checksums for whitelisting at the greylist server.
	 * This assumes DCC_CK_GREY_TRIPLE > DCC_CK_GREY_MSG > other types */
	ck = rpt.cks;
	num_cks = 0;
	for (type = 0, g = cks->sums;
	     type <= DCC_CK_TYPE_LAST;
	     ++type, ++g) {
		/* greylisting needs a body checksum, even if
		 * it is the fake checksum for a missing body */
		if (!g->rpt2srvr && type != DCC_CK_BODY)
			continue;

		/* do not ask the greylist server about reputations */
		if (DCC_CK_IS_REP(0, type))
			continue;

		ck->type = type;
		ck->len = sizeof(*ck);
		ck->sum = g->sum;
		++ck;
		++num_cks;
	}

	/* include in the request the grey message checksum as the checksum
	 * of the body, the env_From sender, and env_To target checksums */
	MD5Init(&ctx);
	MD5Update(&ctx, cks->sums[DCC_CK_BODY].sum.b, sizeof(DCC_SUM));
	MD5Update(&ctx, cks->sums[DCC_CK_ENV_FROM].sum.b, sizeof(DCC_SUM));
	MD5Update(&ctx, env_to_sum->b, sizeof(DCC_SUM));
	MD5Final(msg_sum->b, &ctx);
	ck->type = DCC_CK_GREY_MSG;
	ck->len = sizeof(*ck);
	ck->sum = *msg_sum;
	++ck;
	++num_cks;

	/* include the triple checksum of the sender, the sender's IP
	 * address, and the target */
	MD5Init(&ctx);
	if (trim_grey_ip_addr) {
		struct in6_addr addr;
		DCC_SUM sum;
		apply_ipmask(&addr, &cks->ip_addr, &grey_ip_mask);
		ipv6tock(&sum, &addr);
		MD5Update(&ctx, sum.b, sizeof(DCC_SUM));
	} else {
		MD5Update(&ctx, cks->sums[DCC_CK_IP].sum.b, sizeof(DCC_SUM));
	}
	MD5Update(&ctx, cks->sums[DCC_CK_ENV_FROM].sum.b, sizeof(DCC_SUM));
	MD5Update(&ctx, env_to_sum->b, sizeof(DCC_SUM));
	MD5Final(triple_sum->b, &ctx);
	ck->type = DCC_CK_GREY3;
	ck->len = sizeof(*ck);
	ck->sum = *triple_sum;
	++num_cks;

	if (!dcc_clnt_op(emsg, ctxt, DCC_CLNT_FG_GREY, 0, 0, 0,
			 &rpt.hdr, (sizeof(rpt) - sizeof(rpt.cks)
				    + num_cks*sizeof(rpt.cks[0])),
			 op, &resp, sizeof(resp))) {
		return ASK_GREY_FAIL;
	}

	if (!dcc_ck_grey_answer(emsg, &resp))
		return ASK_GREY_FAIL;

	/* see what the greylist server had to say */
	result_tgts = ntohl(resp.gans.triple);
	switch (result_tgts) {
	case DCC_TGTS_OK:		/* embargo ended just now */
		/* if we have previously included this target in a count of
		 * targets sent to the DCC, then do not include it now */
		if (resp.gans.msg != 0 && plate_tgts)
			++*plate_tgts;
		if (pembargo_num)
			*pembargo_num = 0;
		return ASK_GREY_EMBARGO_END;

	case DCC_TGTS_TOO_MANY:		/* no current embargo */
		if (pembargo_num)
			*pembargo_num = 0;
		return ((resp.gans.msg != 0)
			? ASK_GREY_EMBARGO_END
			: ASK_GREY_PASS);

	case DCC_TGTS_GREY_WHITE:	/* whitelisted for greylisting */
		if (pembargo_num)
			*pembargo_num = 0;
		return ASK_GREY_WHITE;

	default:			/* embargoed */
		/* if this is a brand new embargo,
		 * then count this target in the DCC report */
		if (resp.gans.msg == 0 && pearly_tgts)
			++*pearly_tgts;
		if (pembargo_num)
			*pembargo_num = result_tgts+1;
		return ASK_GREY_EMBARGO;
	}
}
