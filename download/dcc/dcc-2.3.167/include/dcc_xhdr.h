/* Distributed Checksum Clearinghouse
 *
 * X-DCC-Warning header definitions
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
 * Rhyolite Software DCC 2.3.167-1.77 $Revision$
 */

#ifndef DCC_XHDR_H
#define DCC_XHDR_H

/* the DCC SMTP X- header is of the form
 *
 * X-DCC-name-Metrics: host_addr server-ID; [bulk] cknm1=cnt1 cknm2=cnt2 ...
 *
 * where
 *    chost		is the FQDN of the DCC client that added the header
 *    server-ID		is the ID of the DCC server providing the counts
 *    cknm1, cknm2, ...	are names of checksums
 *    cnt1, cnt2, ...	are counts or special counts
 */
#define DCC_XHDR_START		"X-DCC-"
#define DCC_XHDR_END		"-Metrics"
#define DCC_XHDR_PAT		DCC_XHDR_START"%.*s"DCC_XHDR_END

/* minimum length of X-DCC field name */
#define DCC_XHDR_WHITELIST_FNAME_LEN	LITZ(DCC_XHDR_START DCC_XHDR_END)

#define DCC_XHDR_BULK		"bulk"
#define DCC_XHDR_BULK_REP	"bulk rep"
#define	DCC_XHDR_WHITELIST	"whitelist"

#define	DCC_XHDR_REPORTED	"reported:" /* header for block of checksums */

/* names of checksums */
#define DCC_XHDR_TYPE_IP	    "IP"	    /* binary source IP addr */
#define DCC_XHDR_TYPE_ENV_FROM	    "env_From"	    /* envelope Mail From */
#define DCC_XHDR_TYPE_FROM	    "From"	    /* header line */
#define DCC_XHDR_TYPE_SUB	    "substitute"    /* random header line */
#define DCC_XHDR_TYPE_MESSAGE_ID    "Message-ID"    /* header line */
#define DCC_XHDR_TYPE_RECEIVED	    "Received"	    /* last header line */
#define DCC_XHDR_TYPE_BODY	    "Body"	    /* body */
#define DCC_XHDR_TYPE_FUZ1	    "Fuz1"	    /* filtered body */
#define DCC_XHDR_TYPE_FUZ2	    "Fuz2"	    /*   "       "   */
#define DCC_XHDR_TYPE_GREY_MSG	    "Grey_Msg"	    /* greylist msg checksum */
#define DCC_XHDR_TYPE_GREY_TRIPLE   "Grey3"	    /* greylist triple cksum */
#define DCC_XHDR_TYPE_REP_TOTAL	    "rep-total"
#define DCC_XHDR_TYPE_REP_BULK	    "rep"
#define DCC_XHDR_TYPE_SRVR_ID	    "server-ID"
#define DCC_XHDR_TYPE_ENV_TO	    "env_To"	    /* envelope Rcpt To */
#define DCC_XHDR_TYPE_FLOD_PATH	    "flood path"
#define DCC_XHDR_TYPE_UNKNOWN	    "type %d"
#define DCC_XHDR_MAX_TYPE_LEN	    10	/* ------------- fix if above change */
/* buffer length including ':' and '\0' */
#define DCC_XHDR_MAX_TYPE_LEN_BUF   (DCC_XHDR_MAX_TYPE_LEN+1+1)

/* special target values */
#define DCC_XHDR_TOO_MANY	"many"	    /* too many targets to number */
#define DCC_XHDR_THOLD_NEVER	"never"
#define DCC_XHDR_GREY_PASS	"pass"	    /* embargo has ended */
#define DCC_XHDR_OK		"ok"	    /* certified not spam */
#define DCC_XHDR_OK2		"ok2"	    /* half certified not spam */
#define DCC_XHDR_OK_MX		"mx"	    /* semi-trusted MX server */
#define DCC_XHDR_OK_MXDCC	"mxdcc"	    /* semi-trusted MX server w/DCC */
#define DCC_XHDR_SUBMIT_CLIENT	"submit"    /* SMTP submission client */
#define DCC_XHDR_DEL		"del-req"   /* delete request */
#define DCC_XHDR_TGTS_REP_ADJ	"rep-adj"   /* adjust reputation total */
#define DCC_XHDR_INVALID	"-"
#define DCC_XHDR_MAX_TGTS_LEN	12

/* special server-IDs */
#define DCC_XHDR_ID_INVALID	"invalid"	/* DCC_ID_INVALID */
#define DCC_XHDR_ID_ANON	"anon"		/* DCC_ID_ANON */
#define DCC_XHDR_ID_WHITE   DCC_XHDR_WHITELIST	/* DCC_ID_WHITE */
#define DCC_XHDR_ID_COMP	"compressed"	/* DCC_ID_COMP */
#define DCC_XHDR_ID_SIMPLE	"simple"	/* DCC_ID_SRVR_SIMPLE */
#define DCC_XHDR_ID_IGNORE	"ignore"	/* DCC_ID_SRVR_IGNORE */
#define DCC_XHDR_ID_ROGUE	"rogue"		/* DCC_ID_SRVR_ROGUE */
#define	DCC_XHDR_ID_DATE	"date"		/* DCC_ID_SRVR_DATE */

#define	DCC_XHDR_REJ_DATA_MSG	"rejection message: "
#define DCC_XHDR_RESULT		"result: "
#define DCC_XHDR_RESULT_I_A	"ignore and accept"
#define	DCC_XHDR_RESULT_A_GREY	"after greylist embargo"
#define	DCC_XHDR_RESULT_DISCARD	"discard"
#define	DCC_XHDR_RESULT_ACCEPT	"accept"
#define	DCC_XHDR_RESULT_REJECT	"reject"
#define DCC_XHDR_RESULT_FORCED	" forced by other recipients"
#define DCC_XHDR_RESULT_DCC_FAIL "DCC failure"
#define	DCC_XHDR_REJ_RCPT_PAT	"Rcpt To:%s: %s\n"
#define DCC_XHDR_INCOMPAT_WLIST	"reject temporarily for incompatible whitelists"
#define DCC_XHDR_INCOMPAT_THOLD	"reject temporarily for DCC threshold conflict"
#define DCC_XHDR_MTA_REJECTION	"(rejected by MTA)"
#define DCC_XHDR_TOO_MANY_RCPTS	"reject temporarily for too many recipients"

#define DCC_XHDR_ISOK		"-->OK"
#define DCC_XHDR_ISSPAM		"-->spam"

#define DCC_XHDR_TRAP_NOT	"not-spam-trap"
#define DCC_XHDR_TRAP_DIS	"spam-trap-discard"
#define DCC_XHDR_TRAP_REJ	"spam-trap-reject"

/* greylist embargo results that are recognized by other programs */
#define DCC_XHDR_GREY_RECIP	"greylist recipient"
#define DCC_XHDR_EMBARGO_FAIL	"Sys Failure"
#define DCC_XHDR_EMBARGO_ENDED	"Embargo Ended"
#define DCC_XHDR_EMBARGO	"Embargo"
#define DCC_XHDR_EMBARGO_NUM	"Embargo #%d"
#define DCC_XHDR_EMBARGO_PASS	"Pass"
#define DCC_XHDR_EMBARGO_OK	"Recognized OK"
#define DCC_XHDR_EMBARGO_RESET	"Embargo #%d reset"


#define DCC_LOG_DATE_PAT	"VERSION: 3\nDATE: %s"
#define DCC_LOG_DATE_FMT	"%x %X %Z"
#define DCC_LOG_IP1		DCC_XHDR_TYPE_IP": "
#define DCC_LOG_IP2		" "
#define DCC_LOG_HELO		"HELO: "
#define DCC_LOG_MAIL_HOST	"  mail_host="
#define DCC_LOG_MSG_SEP "\n### end of message body ########################\n"
#define DCC_LOG_TRN_MSG0 "### log truncated ######################"
#define DCC_LOG_TRN_MSG "\n"DCC_LOG_TRN_MSG0"\n"
#define DCC_LOG_TRN_MSG_CR "\r\n"DCC_LOG_TRN_MSG0"\r\n"

#endif /* DCC_XHDR_H	*/
