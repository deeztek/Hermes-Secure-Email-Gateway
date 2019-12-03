/* Distributed Checksum Clearinghouse
 *
 * SMTP reply strings
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
 * Rhyolite Software DCC 2.3.167-1.36 $Revision$
 */


#include "cmn_defs.h"

REPLY_TPLT reject_reply;
REPLY_TPLT reputation_reply;
REPLY_TPLT grey_reply;


/* default SMTP message templates */
typedef struct {
    REPLY_TPLT *reply;
    const char *rcode;			/* default value such as "550" */
    const char *xcode;			/* default value such as "5.7.1" */
    const char *def_pat;		/* default -r pattern */
    const char *log_result;		/* "accept ..." etc. for log */
} REPLY_DEF;

#define	DEF_REJ_MSG "mail %ID from %CIP rejected by DCC"
static REPLY_DEF rej_def = {&reject_reply, DCC_RCODE, DCC_XCODE,
	DEF_REJ_MSG,
	"reject"};

static REPLY_DEF grey_def = {&grey_reply, "452", "4.2.1",
	"mail %ID from %CIP temporary greylist embargoed",
	"temporary greylist embargo"};

static REPLY_DEF rep_def = {&reputation_reply, DCC_RCODE, DCC_XCODE,
	"%ID bulk mail reputation; see https://commercial-dcc.rhyolite.com/cgi-bin/reps.cgi?tgt=%CIP",
	"reject by DCC reputation"};

static REPLY_DEF dnsbl_def = {0, DCC_RCODE, DCC_XCODE,
	DEF_REJ_MSG,
	"reject"};


REPLY_TPLT dcc_fail_reply = {"temporary reject", {REPLY_TPLT_NULL},
	"451", "4.4.0", 0, DCC_XHDR_RESULT_DCC_FAIL};


/* Parse a string into RFC 821 and RFC 2034 codes and a pattern to make a
 * message, or generate the codes for a string that has a message
 * without codes.
 * The string should be something like "5.7.1 550 spammer go home"
 * or "spammer go home". */
void
make_tplt(REPLY_TPLT *tplt,		/* to here */
	  u_char mode,			/* 0=sendmail 1=dccid 2=dnsbl */
	  const char *xcode,		/* default value such as "5.7.1" */
	  const char *rcode,		/* default value such as "550" */
	  const char *arg,		/* using this pattern */
	  const char *log_result)	/* "reject" etc. for log */
{
	const char *p;
	char c, *new_pat;
	char sb[5+1+3+1];
	int p_cnt, i;

	arg += strspn(arg, DCC_WHITESPACE"\"");

	/* Does the message have a valid xcode and rcode?
	 * First check for sendmail.cf ERROR:### and ERROR:D.S.N:### */
	if (mode == 0 && !CLITCMP(arg, "ERROR:")) {
		p = dcc_parse_word(0, sb, sizeof(sb), arg+LITZ("ERROR:"),
				   0, 0, 0);
		if (p) {
			i = strlen(sb);
			if (i == 5+1+3 && sb[5] == ':') {
				memcpy(tplt->xcode, &sb[0], 5);
				memcpy(tplt->rcode, &sb[6], 3);
			} else if (i == 3) {
				BUFCPY(tplt->xcode, xcode);
				memcpy(tplt->rcode, &sb[0], 3);
			} else {
				p = 0;
			}
		}
	} else {
		p = dcc_parse_word(0, tplt->xcode, sizeof(tplt->xcode),
				   arg, 0, 0, 0);
		if (p)
			p = dcc_parse_word(0, tplt->rcode, sizeof(tplt->rcode),
					   p, 0, 0, 0);
	}
	if (!p
	    || tplt->rcode[0] < '4' || tplt->rcode[0] > '5'
	    || tplt->rcode[1] < '0' || tplt->rcode[1] > '9'
	    || tplt->rcode[2] < '0' || tplt->rcode[2] > '9'
	    || tplt->rcode[0] != tplt->xcode[0]
	    || tplt->xcode[1] != '.'
	    || tplt->xcode[2] < '0' || tplt->xcode[2] > '9'
	    || tplt->xcode[3] != '.'
	    || tplt->xcode[4] < '0' || tplt->xcode[4] > '9') {
		BUFCPY(tplt->xcode, xcode);
		BUFCPY(tplt->rcode, rcode);
		p = arg;
	} else {
		p += strspn(p, DCC_WHITESPACE);
	}

	tplt->is_pat = 0;
	p_cnt = 0;
	new_pat = tplt->pat;
	do {
		c = *p++;
		if (c == '\0')
			break;
		if (c == '%') {
			/* parse %x for x=
			 *  ID	    message queue ID
			 *  CIP	    SMTP client IP address
			 *  EMBARGO null or #%d of greylist embargo number
			 *  BTYPE   type of blacklist hit
			 *  BTGT    IP address or name sought in DNSBL
			 *  BPROBE  domain name found in blacklist
			 *  BRESULT value of domain name found in blacklist
			 *
			 *  BT	    obsolete equivalent of BTYPE
			 *  BIP	    obsolete equivalent of BTGT
			 *  s	    obsolete; 1st same as ID; 2nd same as CIP
			 */
			if (new_pat >= LAST(tplt->pat)-2)
				continue;   /* no room for "%s\0" */

			tplt->is_pat = 1;
			*new_pat++ = '%';
			if (mode == 0
			    || p_cnt >= NUM_REPLY_TPLT_ARGS || *p == '%') {
				/* translate %% and bad % to %% */
				++p;

			} else if (!LITCMP(p,"ID")) {
					p += LITZ("ID");
				tplt->args[p_cnt++] = REPLY_TPLT_ID;
				c = 's';
			} else if (!LITCMP(p,"CIP")) {
				p += LITZ("CIP");
				tplt->args[p_cnt++] = REPLY_TPLT_CIP;
				c = 's';
			} else if (mode == 2 && !LITCMP(p,"BTYPE")) {
				p += LITZ("BTYPE");
				tplt->args[p_cnt++] = REPLY_TPLT_BTYPE;
				c = 's';
			} else if (mode == 2 && !LITCMP(p,"BTGT")) {
				p += LITZ("BTGT");
				tplt->args[p_cnt++] = REPLY_TPLT_BTGT;
				c = 's';
			} else if (mode == 2 && !LITCMP(p,"BPROBE")) {
				p += LITZ("BPROBE");
				tplt->args[p_cnt++] = REPLY_TPLT_BPROBE;
				c = 's';
			} else if (mode == 2 && !LITCMP(p,"BRESULT")) {
				p += LITZ("BRESULT");
				tplt->args[p_cnt++] = REPLY_TPLT_BRESULT;
				c = 's';

			} else if (*p == 's' && p_cnt < 2) {
				/* obsolete
				 * translate 1st "%s" to REPLY_TPLT_ID
				 * 2nd to REPLY_TPLT_CIP */
				++p;
				tplt->args[p_cnt] = (p_cnt == 0
						     ? REPLY_TPLT_ID
						     : REPLY_TPLT_CIP);
				++p_cnt;
				c = 's';
			} else if (mode == 2 && !LITCMP(p,"BIP")) {
				/* obsolete */
				p += LITZ("BIP");
				tplt->args[p_cnt++] = REPLY_TPLT_BTGT;
				c = 's';
			} else if (mode == 2 && !LITCMP(p,"BT")) {
				/* obsolete */
				p += LITZ("BT");
				tplt->args[p_cnt++] = REPLY_TPLT_BTYPE;
				c = 's';
			}

		} else if (c == '"' && mode == 0) {
			/* Strip double quotes from sendmail rejection
			 * message. Sendmail needs quotes around the message
			 * so it won't convert blanks to dots. */
			continue;

		} else if (c < ' ' || c > '~') {
			/* sendmail does not like control characters in
			 * SMTP status messages */
			c = '.';
		}

		*new_pat++ = c;
	} while (new_pat < LAST(tplt->pat));
	*new_pat = '\0';
	while (p_cnt < NUM_REPLY_TPLT_ARGS)
		tplt->args[p_cnt++] = REPLY_TPLT_NULL;

	tplt->log_result = log_result;
}



static inline void
finish_reply(const REPLY_DEF *def, const char *pat)
{
	make_tplt(def->reply, 1, def->xcode, def->rcode, pat,
		  def->log_result);
}



void
finish_replies(void)
{
	/* make SMTP status strings for cases not set with -rPATTERN */
	if (reject_reply.rcode[0] == '\0')
		finish_reply(&rej_def, rej_def.def_pat);
	if (reputation_reply.rcode[0] == '\0')
		finish_reply(&rep_def, rep_def.def_pat);
	if (grey_reply.rcode[0] == '\0')
		finish_reply(&grey_def, grey_def.def_pat);
}



/* parse another "-r pattern" argument */
void
parse_reply_arg(const char *arg)
{
	/* a blank string implies the default */
	arg += strspn(arg, DCC_WHITESPACE);

	/* each -r finishes the next SMTP rejection message */

	if (reject_reply.rcode[0] == '\0') {
		if (*arg == '\0')
			finish_reply(&rej_def, rej_def.def_pat);
		else
			finish_reply(&rej_def, arg);
		return;
	}

	if (grey_reply.rcode[0] == '\0') {
		if (*arg == '\0') {
			finish_reply(&grey_def, grey_def.def_pat);
			return;
		}
		finish_reply(&grey_def, arg);
		if (grey_reply.rcode[0] != '4'
		    || grey_reply.xcode[0] != '4') {
			dcc_error_msg("invalid greylist message: %s", arg);
			finish_reply(&grey_def, grey_def.def_pat);
		}
		return;
	}

	if (reputation_reply.rcode[0] == '\0') {
		if (*arg == '\0')
			finish_reply(&rep_def, rep_def.def_pat);
		else
			finish_reply(&rep_def, arg);
		return;
	}

	dcc_error_msg("more than 3 -r settings");
}



/* set up the DNSBL SMTP error message template for all threads based on
 *	a -B arg.  Allow % patterns and so forth */
const REPLY_TPLT *
dnsbl_parse_reply(const char *pat)
{
	REPLY_TPLT *tplt;

	tplt = malloc(sizeof(REPLY_TPLT));
	memset(tplt, 0, sizeof(REPLY_TPLT));
	make_tplt(tplt, 2, dnsbl_def.xcode, dnsbl_def.rcode, pat,
		  dnsbl_def.log_result);
	return tplt;
}



void
make_reply(REPLY_STRS *strs, const REPLY_TPLT *tplt,
	   const CMN_WORK *cwp, const DNSBL_HGROUP *hg)
{
	strs->rcode = tplt->rcode;
	strs->xcode = tplt->xcode;
	if (!tplt->is_pat) {
		strs->str = tplt->pat;
	} else {
		const char *args[NUM_REPLY_TPLT_ARGS];
		int i;

		memset(args, 0, sizeof(args));
		for (i = 0; i < NUM_REPLY_TPLT_ARGS; ++i) {
			switch (tplt->args[i]) {
			case REPLY_TPLT_NULL:
				args[i] = "";
				break;
			case REPLY_TPLT_ID:
				args[i] = cwp->id;
				break;
			case REPLY_TPLT_CIP:
				args[i] = dcc_trim_ffff(cwp->clnt_str);
				break;
			case REPLY_TPLT_BTYPE:
				args[i] = (hg && hg->btype) ? hg->btype : "";
				break;
			case REPLY_TPLT_BTGT:
				args[i] = hg ? hg->tgt.c : "";
				break;
			case REPLY_TPLT_BPROBE:
				args[i] = hg ? hg->probe.c : "";
				break;
			case REPLY_TPLT_BRESULT:
				args[i] = hg ? hg->ip : "";
				break;
			}
		}
		snprintf(strs->str_buf, sizeof(strs->str_buf), tplt->pat,
			 args[0], args[1], args[2], args[3], args[4], args[5]);
		strs->str = strs->str_buf;
	}

	strs->log_result = tplt->log_result;
}
