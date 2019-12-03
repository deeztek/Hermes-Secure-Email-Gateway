/* Distributed Checksum Clearinghouse
 *
 * convert a DCC opcode to a string
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
 *
 * Rhyolite Software DCC 2.3.167-1.38 $Revision$
 */

#include "dcc_defs.h"



const char *
dcc_aop2str(char *buf, int buf_len,
	    DCC_AOPS aop,
	    u_int32_t val1)		/* host byte order */
{
	switch (aop) {
	case DCC_AOP_OK:	    return "ADMN";
	case DCC_AOP_STOP:	    return "ADMN STOP";
	case DCC_AOP_FLOD:
		switch ((DCC_AOP_FLODS)(val1 % 256)) {
#			define RFS(s) return "ADMN FLOD "s
		case DCC_AOP_FLOD_CHECK:    RFS("CHECK");
		case DCC_AOP_FLOD_SHUTDOWN: RFS("SHUTDOWN");
		case DCC_AOP_FLOD_HALT:	    RFS("HALT");
		case DCC_AOP_FLOD_RESUME:   RFS("RESUME");
		case DCC_AOP_FLOD_REWIND:   RFS("REWIND");
		case DCC_AOP_FLOD_LIST:	    RFS("LIST");
		case DCC_AOP_FLOD_STATS:    RFS("STATS");
		case DCC_AOP_FLOD_STATS_CLEAR:RFS("STATS CLEAR");
		case DCC_AOP_FLOD_FFWD_IN:  RFS("FFWD IN");
		case DCC_AOP_FLOD_FFWD_OUT: RFS("FFWD OUT");
#			undef RFS
		}
		break;
	case DCC_AOP_DB_CLEAN:	    return "ADMN DB CLEAN";
	case DCC_AOP_DB_NEW:	    return "ADMN DB NEW";
	case DCC_AOP_STATS:	    return "ADMN STATS";
	case DCC_AOP_STATS_CLEAR:   return "ADMN STATS CLEAR";
	case DCC_AOP_TRACE_ON:
		if (!buf || !buf_len)
			return "ADMN TRACE ON";
		snprintf(buf, buf_len, "ADMN TRACE ON %#x", val1);
		return buf;
	case DCC_AOP_TRACE_OFF:
		if (!buf || !buf_len)
			return "ADMN TRACE OFF";
		snprintf(buf, buf_len, "ADMN TRACE OFF %#x", val1);
		return buf;
	case DCC_AOP_unused1:	    break;
	case DCC_AOP_CLIENTS:	    return "ADMN CLIENTS";
	case DCC_AOP_CLIENTS_ID:    return "ADMN CLIENTS BY ID";
	case DCC_AOP_ANON_DELAY:    return "ADMN ANON DELAY";
	case DCC_AOP_CLOCK_CHECK:   return "ADMN CLOCK CHECK";
	}

	if (!buf || !buf_len)
		return "ADMN UNKNOWN ???";
	snprintf(buf, buf_len,
		 "ADMN UNKNOWN #%d %#x", aop, val1);
	return buf;
}



const char *
dcc_hdr_op2str(char *buf, int buf_len,
	       const DCC_HDR *hdr)	/* all in network byte order */
{
	const char *p;
	int len, slen, i;

	switch ((DCC_OPS)hdr->op) {
	case DCC_OP_INVALID:	return "INVALID";
	case DCC_OP_NOP:	return "NOP";
	case DCC_OP_REPORT:	return "REPORT";
	case DCC_OP_QUERY:	return "QUERY";
	case DCC_OP_ANSWER:	return "ANSWER";
	case DCC_OP_ADMN:
		/* display ASCII results */
		len = ntohs(hdr->len);
		slen = len - (sizeof(*hdr) + sizeof(DCC_SIGNATURE));
		if (slen > 0) {
			for (p = (char *)(hdr+1), i = slen;
			     i > 0;
			     --i, ++p) {
				if ((*p < ' ' || *p >= 0x7f)
				    && *p != '\n' && *p != '\t')
					break;
			}
			if (i == 0) {
				if (!buf || buf_len <= ISZ("ADMN \"...\""))
					return "ADMN \"...\"";
				if (slen+ISZ("ADMN \"\"") > buf_len) {
					slen = buf_len - ISZ("ADMN \"...\"");
					snprintf(buf, buf_len,
						 "ADMN \"%.*s...\"",
						 slen, (char *)(hdr+1));
				} else {
					snprintf(buf, buf_len,
						 "ADMN \"%.*s\"",
						 slen, (char *)(hdr+1));
				}
				return buf;
			}
		}
		if (len < DCC_ADMN_REQ_MIN_SIZE)
			return "ADMIN ???";
		return dcc_aop2str(buf, buf_len, ((DCC_ADMN_REQ *)hdr)->aop,
				   ntohl(((DCC_ADMN_REQ *)hdr)->val1));
	case DCC_OP_OK:		return "OK";
	case DCC_OP_ERROR:	return "ERROR";
	case DCC_OP_DELETE:	return "DELETE";
	case DCC_OP_GREY_REPORT:return "GREYLIST REPORT";
	case DCC_OP_GREY_QUERY:	return "GREYLIST QUERY";
	case DCC_OP_GREY_SPAM:	return "GREYLIST SPAM";
	case DCC_OP_GREY_WHITE:	return "GREYLIST WHITELIST";
	}

	if (!buf || !buf_len)
		return "unknown op ???";
	snprintf(buf, buf_len, "unknown op #%d", hdr->op);
	return buf;
}
