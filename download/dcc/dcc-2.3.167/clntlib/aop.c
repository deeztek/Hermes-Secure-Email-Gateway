/* Distributed Checksum Clearinghouse
 *
 * ask for and administrative operation
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
 * Rhyolite Software DCC 2.3.167-1.46 $Revision$
 */

#include "dcc_clnt.h"


/* ask for an administrative operation */
DCC_OPS					/* DCC_OP_INVALID=failed, else result */
dcc_aop(DCC_EMSG *emsg,			/* result if DCC_OP_ERROR or _INVALID */
	DCC_CLNT_CTXT *ctxt,
	DCC_CLNT_FGS clnt_fgs,		/* DCC_CLNT_FG_* */
	SRVR_INX anum,			/* server index or NO_SRVR */
	time_t dsecs,			/* fudge timestamp by this */
	DCC_AOPS aop,
	u_int32_t val1, u_char val2, u_char val3,
	u_char val4,
	void *val5, u_int val5_len,
	DCC_OP_RESP *resp,
	DCC_SOCKU *resp_su)		/* IP address of server used */
{
	DCC_ADMN_REQ req;
	DCC_EMSG loc_emsg;
	DCC_OP_RESP resp0;
	char resp_buf[DCC_OPBUF];

	memset(&req, 0, sizeof(req));
	req.date = htonl(time(0) + dsecs);
	req.aop = aop;
	req.val1 = ntohl(val1);
	req.val2 = val2;
	req.val3 = val3;
	req.val4 = val4;
	if (val5_len != 0) {
		if (val5_len > DCC_MAX_ADMN_REQ_VAL5)
			dcc_logbad(EX_SOFTWARE, "bogus aop val5 length %d",
				   val5_len);
		memcpy(&req.val5, val5, val5_len);
	}
	if (!resp) {
		resp = &resp0;
	} else if (clnt_fgs & DCC_CLNT_FG_RETRANS) {
		req.hdr.op_nums.r = resp->hdr.op_nums.r;
	}
	memset(resp, 0, sizeof(*resp));
	if (!dcc_clnt_op(&loc_emsg, ctxt,
			 clnt_fgs | DCC_CLNT_FG_NO_FAIL, &anum, 0, resp_su,
			 &req.hdr, sizeof(req)-DCC_MAX_ADMN_REQ_VAL5+val5_len,
			 DCC_OP_ADMN,
			 resp, sizeof(*resp))) {
		dcc_pemsg(emsg_ex_code(&loc_emsg), emsg, "%s: %s",
			  dcc_aop2str(resp_buf, sizeof(resp_buf), aop, val1),
			  loc_emsg.c);
		return DCC_OP_INVALID;
	}

	if (resp->hdr.op ==  DCC_OP_OK)
		return DCC_OP_OK;
	if (resp->hdr.op == DCC_OP_ADMN) {
		/* clear signature after possible string */
		int len = (ntohs(resp->hdr.len)
			   - (sizeof(resp->resp)
			      - sizeof(resp->resp.val.string)));
		if (len < ISZ(resp->resp.val.string))
			resp->resp.val.string[len] = '\0';
		return DCC_OP_ADMN;
	}
	if (resp->hdr.op == DCC_OP_ERROR) {
		dcc_pemsg(emsg_ex_code(emsg), emsg, "%s: %s",
			  dcc_aop2str(resp_buf, sizeof(resp_buf), aop, val1),
			  resp->resp.val.string);
		return DCC_OP_ERROR;
	}
	dcc_pemsg(EX_PROTOCOL, emsg, "%s unexpected response: %s",
		  dcc_aop2str(0, 0, aop, val1),
		  dcc_hdr_op2str(resp_buf, sizeof(resp_buf), &resp->hdr));
	return DCC_OP_INVALID;
}



/* try for a long time or until the server hears */
u_char					/* 1=ok, 0=failed */
dcc_aop_persist(DCC_EMSG *emsg,
		DCC_CLNT_CTXT *ctxt,
		DCC_CLNT_FGS clnt_fgs,
		u_char debug,
		DCC_AOPS aop, u_int32_t val1,
		int secs,		/* try for this long */
		DCC_OP_RESP *aop_resp)	/* results here */
{
	struct timeval begin, now, op_start;
	char buf1[DCC_OPBUF];
	char buf2[DCC_OPBUF];
	u_char complained, fast;
	time_t us;
	DCC_OPS result;

	gettimeofday(&begin, 0);
	complained = 0;
	fast = 0;

	for (;;) {
		gettimeofday(&op_start, 0);
		result = dcc_aop(emsg, ctxt, clnt_fgs, NO_SRVR, 0,
				 aop, val1, 0, 0, 0, 0, 0, aop_resp, 0);

		/* finished if that worked */
		if (result == DCC_OP_ADMN || result == DCC_OP_OK)
			return 1;

		/* use the same transaction ID next time.
		 * This kludge on the transaction ID makes all of our
		 * requests appear to be retransmissions of a single request.
		 * This is nice for operations such as DCC_AOP_FLOD_SHUTDOWN
		 * that are not idempotent when the server has been stalled by
		 * the operating system. */
		if (aop_resp)
			clnt_fgs |= DCC_CLNT_FG_RETRANS;

		/* invent an error message if we do not have one */
		if (result != DCC_OP_ERROR && result != DCC_OP_INVALID)
			dcc_pemsg(EX_UNAVAILABLE, emsg, "%s: %s",
				  dcc_aop2str(buf1, sizeof(buf1), aop, val1),
				  aop_resp
				  ? dcc_hdr_op2str(buf2, sizeof(buf2),
						   &aop_resp->hdr)
				  : "");

		/* deal with time change */
		gettimeofday(&now, 0);
		us = tv_diff2us(&now, &begin);
		if (us < 0) {
			begin = op_start = now;

		} else if (us/DCC_US > secs) {
			return 0;	/* eventually give up */
		}

		us = tv_diff2us(&now, &op_start);
		if (us >= DCC_US) {
			fast = 0;
		} else {
			/* assume the server is dead if it persistently fails
			 * immediately */
			if ((result == DCC_OP_INVALID
			     || result == DCC_OP_INVALID)
			    && ++fast > 4) {
				if (debug)
					quiet_trace_msg("%s: assume dccd dead",
							dcc_aop2str(buf1,
							    sizeof(buf1),
							    aop, val1));
				return 0;
			}
			/* delay 50 ms since the request didn't delay */
			usleep(50*1000);
		}

		/* sometimes emit a message if we are going to try again */
		if ((result !=  DCC_OP_ERROR && result != DCC_OP_INVALID)
		    && (debug || !complained)) {
			complained = 1;
			dcc_error_msg("%s", emsg->c);
		}
	}
}
