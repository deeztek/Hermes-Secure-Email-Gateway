/* Distributed Checksum Clearinghouse
 *
 * Handle DNS black and whitelists
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
 * Rhyolite Software DCC 2.3.167-1.125 $Revision$
 */

#include "helper.h"
#include "dcc_heap_debug.h"
#ifndef DCC_WIN32
#include <sys/wait.h>
#include <arpa/inet.h>
#endif
#ifdef HAVE__RES
#include <resolv.h>
#endif
#ifdef HAVE_ARPA_NAMESER_H
#include <arpa/nameser.h>
#endif

#if !defined(HAVE__RES) || !defined(HAVE_RES_INIT)
#undef HAVE__RES
#undef HAVE_RES_INIT
#endif

#define HAVE_RES_OPTIONS
#ifndef HAVE__RES
#undef HAVE_RES_OPTIONS
#endif
#if !defined(RES_DEFNAMES) || !defined(RES_DNSRCH) || !defined(RES_NOALIASES)
#undef HAVE_RES_OPTIONS
#endif

/* can check MX and NS addresses only with a standard resolver library */
#define MXNS_DNSBL
#ifndef HAVE_RES_OPTIONS
#undef MXNS_DNSBL
#endif
#if !defined (HAVE_RES_QUERY) || !defined(HAVE_DN_EXPAND)
#undef MXNS_DNSBL
#endif
#ifndef HAVE_HSTRERROR
#undef MXNS_DNSBL			/* MX lookups need raw hsterror() */
#endif
#if !defined(T_MX) || !defined(T_A) || !defined(T_AAAA) || !defined(T_NS)
#undef MXNS_DNSBL
#endif
#if !defined(C_IN) || !defined(C_IN) || !defined(PACKETSZ)
#undef MXNS_DNSBL
#endif

#ifdef MXNS_DNSBL
#define RES_ARG_UNUSED
#else
#define RES_ARG_UNUSED	    DCC_UNUSED
#endif


DNSBL *dnsbls;
u_char have_dnsbl_groups;

static struct {				/* what each group wants */
    DNSBL_HIT w[NUM_DNSBL_GROUPS];
    DNSBL_HIT b[NUM_DNSBL_GROUPS];
} group_tgt_hits;


HELPERS helpers;
u_char have_helpers;
DCC_PATH dnsbl_progpath;

static u_char is_helper;
static const char *helper_str = "";

static u_char have_ipv4_dnsbl;
static u_char have_ipv6_dnsbl;
static u_char have_name_dnsbl;

#ifndef RES_TIMEOUT
#define RES_TIMEOUT 3
#endif
#define MAX_MSG_SECS 1000
#define MIN_MSG_SECS 1
#define MIN_URL_SECS MIN_MSG_SECS
static int msg_secs = 25;		/* total seconds/mail message */
static time_t msg_us;
static int url_secs = 11;		/* total seconds/host name */
static time_t url_us;


static DNSBL_HIT parse_tgts = DNSBL_HIT_SRCS;
static u_char parse_mx_ok = 1;
static u_char parse_ns_ok = 1;
static const REPLY_TPLT *parse_reply = 0;
static int parse_dnum = 0;
static int parse_gnum = 0;
static DNSBL *parse_dp = 0;

static u_char
parse_dnsbl_addrs(DCC_EMSG *emsg, const char *entry, const char *tgt_ip)
{
	DCC_EMSG addr_emsg;
	DCC_SOCKU su;
	char *p;
	int val;
	u_char tgt_is_ipv6;

	p = strchr(tgt_ip, '&');
	if (!p) {
		memset(&parse_dp->ip_mask, 0xff, sizeof(parse_dp->ip_mask));
	} else {
		*p++ = '\0';
		if (!str2su(&su, p)) {
			dcc_pemsg(EX_NOHOST, emsg,
				  "invalid mask \"%s\" in DNS blacklist \"%s\"",
				  p, entry);
			return 0;
		}
		dcc_su2ipv6(&parse_dp->ip_mask, 1, &su);
	}

	if (!strcasecmp(tgt_ip, "any")) {
		/* That we get a result when we lookup up an address in the
		 * in the list is all that matters in this case.
		 * Whether it is IPv6 or IPv4 does not */
		parse_dp->tgt_use_ipv46 = DCC_GETH_DEF;
		memset(&parse_dp->ip_range.lo, 0,
		       sizeof(parse_dp->ip_range.lo));
		memset(&parse_dp->ip_range.hi, 0xff,
		       sizeof(parse_dp->ip_range.hi));
		return 1;
	}

	val = str2range(&addr_emsg, &parse_dp->ip_range, &tgt_is_ipv6,
			tgt_ip, 0, 0);
	if (val <= 0) {
		if (val < 0) {
			dcc_pemsg(EX_NOHOST, emsg,
				  "invalid DNS blacklist: %s: \"%s\"",
				  addr_emsg.c, entry);
		} else {
			dcc_pemsg(EX_NOHOST, emsg,
				  "invalid DNS blacklist: \"%s\"",
				  entry);
		}
		return 0;
	}

	parse_dp->tgt_use_ipv46 = tgt_is_ipv6 ? DCC_GETH_V6 : DCC_GETH_V4;
	return 1;
}



/* Parse a string of one of the forms:
 *	    "domain[,[any][,bltype]]
 *	    "domain[,[IPaddr[&IPmask]][,bltype]]
 *	    "domain[,[IPaddr[/xx][&IPmask]][,bltype]]
 *	    "domain[,[IPaddrLO-IPaddrHI[&IPmask]][,name|ipv4|ipv6]]
 *		where bltype is "name", "all-names", "IPv4", or "IPv6"
 *
 *	    set:[no-]client	client IP address checks
 *	    set:[no-]mail_host	envelope mail_from checks
 *	    set:[no-]URL	body URL checks
 *	    set:[no-]MX		MX checks
 *	    set:[no-]NS		NS checks
 *	    set:white		DNS whitelist
 *	    set:black		DNS blacklist
 *	    set:defaults	restore defaults
 *	    set:group=X		start group of lists
 *	    set:debug[=X]	more logging
 *	    set:helper-debug	log helper process
 *	    set:msg-secs=S	total seconds checking blacklists/message
 *	    set:url-secs=S	total seconds per host name
 *
 *	    set:rej-msg="rejection message"
 *	    set:progpath	path of helper program
 *	    set:max_helpers=X	override dccm or dccifd max_work
 *
 *	    set:[no-]body	body URL checks
 *	    set:[no-]envelope	obsolete mail host and client
 *
 *	    set:helper=soc,fd,X	start DNS resolver process
 */
u_char					/* 0=bad */
dcc_parse_dnsbl(DCC_EMSG *emsg, const char *entry, const char *progpath)
{
	DNSBL *dp1, **dpp;
	const char *tgt_ip_start;
	char tgt_ip_buf[INET6_ADDRSTRLEN*3+10];
	DNSBL_TYPE type;
	int dom_len, tgt_ip_len;
	char *p;
	int val;
	u_char seen_dp;
#ifdef HAVE_HELPERS
	int soc, fin_fd, gen, pid_inx;
#	define SAVE_ARG(arg) helper_save_arg("-B", arg)
#else
#	define SAVE_ARG(arg)
#endif

	if (progpath && dnsbl_progpath.c[0] == '\0') {
		const char *slash = strrchr(progpath, '/');
		if (slash)
			++slash;
		else
			slash = progpath;
		snprintf(dnsbl_progpath.c, sizeof(dnsbl_progpath),
			 "%.*sdns-helper", (int)(slash-progpath), progpath);
	}

	/* handle parameter settings */
	if (!CLITCMP(entry, "set:")) {
		const char *parm = entry+LITZ("set:");
#ifdef HAVE_HELPERS
		/* start running a helper process on the magic last -B */
		if (4 == sscanf(parm, HELPER_PAT,
				&soc, &fin_fd, &gen, &pid_inx)) {
			helper_child(soc, fin_fd, gen, pid_inx);
		}
#endif
		if (!strcasecmp(parm, "client")) {
			parse_tgts |= DNSBL_HIT_CLIENT;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "no-client")) {
			parse_tgts &= ~DNSBL_HIT_CLIENT;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "mail_host")
		    || !strcasecmp(parm, "mail-host")) {
			parse_tgts |= DNSBL_HIT_MHOST;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "no-mail_host")
		    || !strcasecmp(parm, "no-mail-host")) {
			parse_tgts &= ~DNSBL_HIT_MHOST;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "url")) {
			parse_tgts |= DNSBL_HIT_URL;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "no-URL")) {
			parse_tgts &= ~DNSBL_HIT_URL;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "mx")) {
#ifdef MXNS_DNSBL
			parse_mx_ok = 1;
			SAVE_ARG(entry);
			return 1;
#else
			dcc_pemsg(EX_USAGE, emsg,
				  "MX DNS blacklist checks"
				  " not supported on "DCC_TARGET_SYS);
			return 0;
#endif
		}
		if (!strcasecmp(parm, "no-mx")) {
			parse_mx_ok = 0;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "ns")) {
#ifdef MXNS_DNSBL
			parse_ns_ok = 1;
			SAVE_ARG(entry);
			return 1;
#else
			dcc_pemsg(EX_USAGE, emsg,
				  "NS DNS blacklist checks"
				  " not supported on "DCC_TARGET_SYS);
			return 0;
#endif
		}
		if (!strcasecmp(parm, "no-ns")) {
			parse_ns_ok = 0;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "white")) {
			parse_tgts |= DNSBL_HIT_WHITE;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "black")) {
			parse_tgts &= ~DNSBL_HIT_WHITE;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "defaults")) {
			parse_tgts = DNSBL_HIT_SRCS;
			parse_mx_ok = 1;
			parse_ns_ok = 1;
			parse_reply = 0;
			SAVE_ARG(entry);
			return 1;
		}
		if (!CLITCMP(parm, "rej-msg=")) {
			parm += LITZ("rej-msg=");
			if (*parm == '\0')
				parse_reply = 0;
			else
				parse_reply = dnsbl_parse_reply(parm);
			/* do not save for helpers */
			return 1;
		}
		if (!CLITCMP(parm, "msg-secs=")) {
			parm += LITZ("msg-secs=");
			val = strtoul(parm, &p, 10);
			if (*p != '\0'
			    || val < MIN_MSG_SECS || val > MAX_MSG_SECS) {
				dcc_pemsg(EX_USAGE, emsg,
					  "bad number of seconds in \"-B %s\"",
					  entry);
				return 0;
			}
			if (msg_secs != val) {
				msg_secs = val;
				SAVE_ARG(entry);
			}
			return 1;
		}
		if (!CLITCMP(parm, "url-secs=")) {
			parm += LITZ("url-secs=");
			val = strtoul(parm, &p, 10);
			if (*p != '\0'
			    || val < MIN_URL_SECS || val > MAX_MSG_SECS) {
				dcc_pemsg(EX_USAGE, emsg,
					  "bad number of seconds in \"-B %s\"",
					  entry);
				return 0;
			}
			if (url_secs != val) {
				url_secs = val;
				SAVE_ARG(entry);
			}
			return 1;
		}
		if (1 == sscanf(parm, "group=%d", &val)
		    && val >= 1 && val <= NUM_DNSBL_GROUPS) {
			parse_gnum = val-1;
			have_dnsbl_groups = 1;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "debug")) {
			++helpers.debug;
			SAVE_ARG(entry);
			return 1;
		}
		if (1 == sscanf(parm, "debug=%d", &val)) {
			helpers.debug = val;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "helpers-debug")) {
			++helpers.helpers_debug;
			SAVE_ARG(entry);
			return 1;
		}
		if (!CLITCMP(parm, "progpath=")) {
			BUFCPY(dnsbl_progpath.c, parm+LITZ("progpath="));
			return 1;
		}
		if (1 == sscanf(parm, "max_helpers=%d", &val)
		    && val >= 1 && val < 1000) {
			helpers.max_helpers = val;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "body")) {    /* obsolete */
			parse_tgts |= DNSBL_HIT_URL;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "no-body")) { /* obsolete */
			parse_tgts &= ~DNSBL_HIT_URL;
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "envelope")) {	/* obsolete */
			parse_tgts |= (DNSBL_HIT_CLIENT | DNSBL_HIT_MHOST);
			SAVE_ARG(entry);
			return 1;
		}
		if (!strcasecmp(parm, "no-envelope")) {	/* obsolete */
			parse_tgts &= ~(DNSBL_HIT_CLIENT | DNSBL_HIT_MHOST);
			SAVE_ARG(entry);
			return 1;
		}
		dcc_pemsg(EX_USAGE, emsg, "unrecognized  \"-B %s\"",
			  entry);
		return 0;
	}

	/* we have a DNSDBL specification instead of an option setting */
	if (!parse_dp)
		parse_dp = dcc_malloc(sizeof(*parse_dp));
	memset(parse_dp, 0, sizeof(*parse_dp));
	type = DNSBL_TYPE_IPV4;		/* assume it is a simple IPv4 list */
	tgt_ip_start = strchr(entry, ',');
	if (!tgt_ip_start) {
		dom_len = strlen(entry);
		have_ipv4_dnsbl = 1;
		tgt_ip_len = 0;
	} else {
		dom_len = tgt_ip_start - entry;
		++tgt_ip_start;

		/* notice trailing ",name" or ",IPv4" */
		p = strchr(tgt_ip_start, ',');
		if (!p) {
			tgt_ip_len = strlen(tgt_ip_start);
			have_ipv4_dnsbl = 1;
		} else {
			tgt_ip_len = p - tgt_ip_start;
			++p;
			if (!strcasecmp(p, "name")) {
				type = DNSBL_TYPE_NAME;
				have_name_dnsbl = 1;
			} else if (!strcasecmp(p, "all-names")
				   || !strcasecmp(p, "all_names")) {
				type = DNSBL_TYPE_ALL_NAMES;
				have_name_dnsbl = 1;
			} else if (!strcasecmp(p, "IPV4")) {
				type = DNSBL_TYPE_IPV4;
				have_ipv4_dnsbl = 1;
			} else if (!strcasecmp(p, "IPV6")) {
				type = DNSBL_TYPE_IPV6;
				have_ipv6_dnsbl = 1;
			} else {
				dcc_pemsg(EX_NOHOST, emsg,
					  "unknown DNSBL type in \"%s\"",
					  entry);
				return 0;
			}
		}
	}
	/* assume 127.0.0.2 if the target address is missing */
	if (tgt_ip_len == 0) {
		BUFCPY(tgt_ip_buf, "127.0.0.2");
	} else {
		if (tgt_ip_len > ISZ(tgt_ip_buf)-1)
			tgt_ip_len = ISZ(tgt_ip_buf)-1;
		memcpy(tgt_ip_buf, tgt_ip_start, tgt_ip_len);
		tgt_ip_buf[tgt_ip_len] = '\0';
	}

	if (entry[0] == '.') {
		++entry;
		--dom_len;
	}
	if (dom_len >= ISZ(DNSBL_DOM) - INET6_ADDRSTRLEN*2) {
		/* we cannot fit the list and target names or address
		 * into a DNSBL_DOM field.  We need to do DNS lookups of
		 * names like 33.22.11.10.dnsbl.example.com or
		 * domain.dom.bl.example.com */
		dcc_pemsg(EX_NOHOST, emsg, "DNSBL name \"%s\" too long", entry);
		return 0;
	}
	memcpy(&parse_dp->dom.c, entry, dom_len);
	parse_dp->dom.c[dom_len] = '\0';

	if (!parse_dnsbl_addrs(emsg, entry, tgt_ip_buf))
		return 0;

	parse_dp->type = type;
	parse_tgts &= ~(DNSBL_HIT_MHOST_MX | DNSBL_HIT_URL_MX
			| DNSBL_HIT_MHOST_NS | DNSBL_HIT_URL_NS);
#ifdef MXNS_DNSBL
	if (parse_mx_ok) {
		if (parse_tgts & DNSBL_HIT_MHOST)
			parse_tgts |= DNSBL_HIT_MHOST_MX;
		if (parse_tgts & DNSBL_HIT_URL)
			parse_tgts |= DNSBL_HIT_URL_MX;
	}
	if (parse_ns_ok) {
		if (parse_tgts & DNSBL_HIT_MHOST)
			parse_tgts |= DNSBL_HIT_MHOST_NS;
		if (parse_tgts & DNSBL_HIT_URL)
			parse_tgts |= DNSBL_HIT_URL_NS;
	}
#endif
	parse_dp->tgt_hits = parse_tgts;
	parse_dp->gnum = parse_gnum;
	if (parse_tgts & DNSBL_HIT_WHITE)
		group_tgt_hits.w[parse_dp->gnum] |= parse_tgts;
	else
		group_tgt_hits.b[parse_dp->gnum] |= parse_tgts;

	parse_dp->reply = parse_reply;
	parse_dp->dom_len = dom_len+1;	/* count trailing '\0' */
	parse_dp->num = ++parse_dnum;

	/* link the lists as they were declared except that
	 * all whitelist must precede all blacklists */
	for (dpp = &dnsbls; ; dpp = &dp1->fwd) {
		dp1 = *dpp;
		if (!dp1
		    || ((parse_tgts & DNSBL_HIT_WHITE)
			&& !(dp1->tgt_hits & DNSBL_HIT_WHITE))) {
			parse_dp->fwd = dp1;
			*dpp = parse_dp;
			break;
		}
	}

	/* notice lists that duplicate previous lists
	 * and so can use previous look-up results */
	seen_dp = 0;
	for (dp1 = dnsbls; dp1; dp1 = dp1->fwd) {
		if (dp1 == parse_dp) {
			seen_dp = 1;
			continue;
		}
		if (parse_dp->type == dp1->type
		    && parse_dp->tgt_use_ipv46 == dp1->tgt_use_ipv46
		    && parse_dp->dom_len == dp1->dom_len
		    && parse_dp->dom_len != 0
		    && !memcmp(parse_dp->dom.c, dp1->dom.c,
			       parse_dp->dom_len)) {
			if (seen_dp) {
				dp1->tgt_hits |= DNSBL_HIT_DUP;
				parse_dp->dup_fwd = dp1;
			} else {
				parse_dp->tgt_hits |= DNSBL_HIT_DUP;
				parse_dp->dup_fwd = dp1->dup_fwd;
				dp1->dup_fwd = parse_dp;
			}
			break;
		}
	}
	parse_dp = 0;

	SAVE_ARG(entry);
	return 1;
#undef SAVE_ARG
}



/* resolve inconsistencies among the -B parameters */
static void
fix_url_secs(void)
{
	if (url_secs > msg_secs)
		url_secs =  msg_secs;
	msg_us = msg_secs * DCC_US;
	url_us = url_secs * DCC_US;
}



static char *
type_str(char *buf0, int buf_len, const DNSBL_WORK *dlw, DNSBL_HIT hit)
{
	const char *type;
	char sustr[DCC_SU2STR_SIZE];
	char *buf;
	int i;

	buf = buf0;
	if (hit & DNSBL_HIT_WHITE) {
		hit &= ~DNSBL_HIT_WHITE;
		i = STRLCPY(buf, "whitelist ", buf_len);
		if (i > buf_len)
			i = buf_len;
		buf_len -= i;
		buf += i;
	}
	switch (hit) {
	case DNSBL_HIT_CLIENT:
		type = "SMTP client";
		if (dlw->tgt.dom.c[0] == '\0') {
			snprintf(buf, buf_len, "%s %s",
				 type, dcc_ipv6tostr2(sustr, sizeof(sustr),
						      &dlw->tgt.addr));
			return buf0;
		}
		break;
	case DNSBL_HIT_MHOST:
		type = "mail_host";
		break;
	case DNSBL_HIT_MHOST_MX :
		type = "mail_host MX";
		break;
	case DNSBL_HIT_MHOST_NS:
		type = "mail_host NS";
		break;
	case DNSBL_HIT_URL:
		type = "URL";
		break;
	case DNSBL_HIT_URL_MX:
		type = "URL MX";
		break;
	case DNSBL_HIT_URL_NS:
		type = "URL NS";
		break;

	default:
		dcc_logbad(EX_SOFTWARE, "impossible DNSBL hit type %#x", hit);
		break;
	}

	i = snprintf(buf, buf_len, "%s %s", type, dlw->tgt.dom.c);
	if (i >= buf_len && buf_len > 4)
		strcpy(&buf[buf_len-4], "...");
	return buf0;
}



static void DCC_PF(4,5)
dnsbl_log(const DNSBL_WORK *dlw,
	  const DNSBL_HGROUP *hg,
	  DNSBL_HIT hit,
	  const char *pat, ...)
{
	char type_buf[1+sizeof(hg->btype_buf)+LITZ(" whitelist")];
	const char *type;
	char gbuf[8];
	const char *gnum;
	char msg[256];
	va_list args;

	va_start(args, pat);
	vsnprintf(msg, sizeof(msg), pat, args);
	va_end(args);

	if (hit) {
		type_buf[0] = ' ';
		type_str(&type_buf[1], sizeof(type_buf)-1, dlw, hit);
		type = type_buf;
	} else {
		type = "";
	}
	if (!have_dnsbl_groups) {
		gnum = "";
	} else if (!hg) {
		gnum = "*";
	} else {
		snprintf(gbuf, sizeof(gbuf), "%d",
			 (int)(hg - dlw->hgroups)+1);
		gnum = gbuf;
	}

	if (helpers.debug) {
		if (dcc_no_syslog)
			thr_trace_msg(dlw->log_ctxt, "DNSBL%s%s%s %s",
				      gnum, helper_str, type, msg);
		else
			thr_trace_msg(dlw->log_ctxt, "%s DNSBL%s%s%s %s",
				      dlw->id,
				      gnum, helper_str, type, msg);
	} else {
		thr_log_print(dlw->log_ctxt, 1, "DNSBL%s%s%s %s\n",
			      helper_str, gnum, type, msg);
	}
}



void
dcc_dnsbl_result(ASK_ST *ask_stp, DNSBL_WORK *dlw)
{
	DNSBL_HGROUP *hg;
	int gnum;

	if (!dlw)
		return;

	for (gnum = 0, hg = dlw->hgroups;
	     gnum < NUM_DNSBL_GROUPS;
	     ++gnum, ++hg) {
		if ((hg->hit & ~DNSBL_HIT_TIMEO) != 0) {
			if (hg->hit & DNSBL_HIT_WHITE)
				*ask_stp |= ASK_ST_DNSBL_W(gnum);
			else
				*ask_stp |= (ASK_ST_DNSBL_B(gnum)
					     | ASK_ST_LOGIT);
			dnsbl_log(dlw, hg, 0, "%s %s=%s",
				  hg->btype, hg->probe.c, hg->ip);
		} else if (hg->hit & DNSBL_HIT_TIMEO) {
			*ask_stp |= ASK_ST_DNSBL_TIMEO(gnum);
		}
	}
}



/* There are several timing goals:
 *	- Do not spend too much time on any single URL or envelope value.
 *	- At helpers.debug >=1, log the first list check in a group
 *	    unfinished for lack of time.  Also log checks for single URLs that
 *	    are partially unfinished.
 *	- At helpers.debug >=2, log things that take a long time
 *	- Minimize log messages, because the noise can be deafening.
 *	- Mark unfinished groups */


/* A check has been abandoned or timed out. */
static void
set_timeo(DNSBL_WORK *dlw,
	  DNSBL_HIT hit)		/* we were trying this type */
{
	DNSBL *dp;
	DNSBL_HGROUP *hg;

	/* groups that are marked as having suffered timeouts can be
	 * hit by later URLs */
	for (dp = dnsbls; dp; dp = dp->fwd) {
		/* Mark all unhit groups if we don't know the type of request
		 * Only mark affected groups if we know the type */
		if (hit != 0 && (hit & dp->tgt_hits) == 0)
			continue;
		hg = &dlw->hgroups[dp->gnum];
		if (hg->hit != 0)
			continue;
		hg->hit = DNSBL_HIT_TIMEO;
	}

	/* no complaint if time remains */
	if (dlw->url_us >= dlw->url_us_used)
		return;

	/* no more log messages if everything has been complained about */
	if (dlw->url_us < 0 || dlw->msg_us < 0)
		return;

	/* only one final message/URL */
	dlw->url_us = -1;
	if (helpers.debug < 2)
		return;

	if (is_helper) {
		/* Messages from the helper process go to the system
		 * log but not the per-message log file.
		 * The helper works on a single URL or envelope value
		 * and so does not know about the time limit for the
		 * entire message. */
		dnsbl_log(dlw, 0, hit, "failed after %.1f url_secs used",
			  dlw->url_us_used / (DCC_US*1.0));

	} else if (dlw->msg_us > dlw->url_us_used) {
		/* time remains for later URLs */
		dnsbl_log(dlw, 0, hit,
			  "failed after using %.1f url-secs;"
			  " %.1f msg-secs remain",
			  dlw->url_us_used / (DCC_US*1.0),
			  (dlw->msg_us - dlw->url_us_used) / (DCC_US*1.0));

	} else {
		dnsbl_log(dlw, 0, hit, "failed after using %.1f url-secs;"
			  " out of time",
			  dlw->url_us_used / (DCC_US*1.0));
	}
}



/* see if we are out of time before doing something */
static u_char				/* 0=too late */
time_ck_pre(DNSBL_WORK *dlw, DNSBL_HIT hit)
{
	/* don't worry if there is plenty of time */
	if (dlw->url_us >= dlw->url_us_used)
		return 1;

	/* There is no more time. Ether previous operations succeeded slowly
	 * or failed and were logged.
	 * In the first case, log this operation and mark the groups. */
	set_timeo(dlw, hit);
	return 0;
}



/* see if we ran out of time after doing something */
static u_char				/* 0=out of time */
time_ck_post(DNSBL_WORK *dlw,
	     DNSBL_HIT hit,
	     u_char failed,		/* 1=DNS resolver failed */
	     const char *estr)
{
	struct timeval now;
	time_t used_us;
	float secs;

	if (dlw->url_us <= 0)
		return 0;			/* previously out of time */

	gettimeofday(&now, 0);
	used_us = tv_diff2us(&now, &dlw->url_start);

	if (helpers.debug > 1) {
		secs = (used_us - dlw->url_us_used) / (DCC_US*1.0);
		if (failed) {
			if (estr)
				dnsbl_log(dlw, 0, hit,
					  "failed after using %.1f url_secs"
					  ": %s",
					  secs, estr);
			else
				dnsbl_log(dlw, 0, hit,
					  "quit after using %.1f url_secs",
					  secs);
		} else if ((used_us - dlw->url_us_used) > url_us/4) {
			dnsbl_log(dlw, 0, hit,
				  "finished after using %.1f url_secs", secs);
		}
	}

	dlw->url_us_used = used_us;
	if (dlw->url_us > used_us)
		return 1;

	set_timeo(dlw, hit);
	return 0;
}



/* start timer before we start to check something in the DNS blacklists
 *	give up if we are already out of time */
static u_char				/* 0=already too much time spent */
msg_secs_start(DNSBL_WORK *dlw, DNSBL_HIT src)
{
	dlw->url_us_used = 0;
	dlw->url_us = min(url_us, dlw->msg_us);

	if (dlw->url_us <= 0) {
		/* out of time for next URL before we start it */
		if (dlw->msg_us == 0) {
			if (helpers.debug)
				dnsbl_log(dlw, 0, src,
					  "%d msg-secs already exhausted",
					  msg_secs);
			dlw->msg_us = -1;   /* only one log message */
			dlw->url_us = -1;
		}
		/* mark the groups but do not log anything */
		set_timeo(dlw, src);
		return 0;
	}

	gettimeofday(&dlw->url_start, 0);
	return 1;
}



/* account for time used */
static void
msg_secs_fin(DNSBL_WORK *dlw)
{
	if (dlw->msg_us < 0)
		return;			/* prevously out of time */

	dlw->msg_us -= dlw->url_us_used;
	if (dlw->msg_us > 0)
		return;

	if (dlw->url_us >= dlw->url_us_used) {
		/* The clock had no time for more DNS work for this
		 * name or address, but we finished and so it might
		 * not matter.
		 * Ensure a log message on the next check, if any */
		dlw->msg_us = 0;
	}
}



/* Limit resolver delays to as much as we are willing to wait
 *	We should be talking to a local caching resolver.  If it does not answer
 *	immediately, it is unlikely to later.  If it does eventually get an
 *	answer, the answer will probably ready the next time we ask.
 *  dcc_host_lock() must be held. */
static void
res_delays(const DNSBL_WORK *dlw RES_ARG_UNUSED)
{
#ifdef HAVE__RES
	static int init_res_retrans;
	static int init_res_retry;
	int res_retrans;		/* retransmition delay */
	int res_retry;			/* # of retransmissions */
	int budget;			/* seconds we can afford */
	int total;			/* retrans*retry = worst case delay */

	if (!dcc_host_locked)
		dcc_logbad(EX_SOFTWARE, "dcc_get_host() not locked");

	/* get the current value */
	if (!init_res_retry) {
#ifdef HAVE_BAD__RES
		/* NetBSD foists a broken resolver onto threaded programs. */
		if (clnt_threaded) {
#ifdef DCC_DEBUG_LOCKS
			dcc_logbad(EX_SOFTWARE, "_res used on "DCC_TARGET_SYS);
#endif
			return;
		}
#endif
		if (!(_res.options & RES_INIT))
			res_init();
		init_res_retry = _res.retry;
		if (!init_res_retry)
			init_res_retry = 4;
		init_res_retrans = _res.retrans;
		if (!init_res_retrans)
			init_res_retrans = RES_TIMEOUT;
	}
	res_retry = init_res_retry;
	res_retrans = init_res_retrans;

	/* assume binary exponential backoffs as in the BIND resolver */
	total = ((1<<res_retry) -1) * res_retrans;

	budget = (dlw->url_us - dlw->url_us_used) / DCC_US;
	if (budget < 1)
		budget = 1;

	if (total <= budget) {
		if (_res.retry != res_retry
		    || _res.retrans != res_retrans) {
			_res.retry = res_retry;
			_res.retrans = res_retrans;
			if (helpers.debug > 4)
				dnsbl_log(dlw, 0, 0,
					  "restore DNS delay  _res.retry=%d"
					  " _res.retrans=%d seconds",
					  res_retry, res_retrans);
		}
		return;
	}

	/* If the default values could take too long, then try 2 seconds.
	 * If that is still too long, go to 1 retransmission and an initial
	 * retransmission delay of 1/3 of the total allowed delay.
	 * 1/3 from one exponential backoff for a total of 2**2-1=3 times
	 * the initial delay.
	 * We should be using a local caching DNS server and so should not
	 * see many lost packets */

	if (total >= budget) {
		res_retry = 2;
		total = ((1<<res_retry) -1) * res_retrans;

		/* if 2 retries are not few enough,
		 * then reduce the retransmission delay to fit */
		if (total >= budget) {
			res_retrans = budget/3;
			if (res_retrans == 0)
				res_retrans = 1;
		}
	}

	if (_res.retry != res_retry
	    || _res.retrans != res_retrans) {
		_res.retry = res_retry;
		_res.retrans = res_retrans;
		if (helpers.debug > 4)
			dnsbl_log(dlw, 0, 0,
				  "set DNS delay budget=%d  _res.retry=%d"
				  " _res.retrans=%d seconds",
				  budget, res_retry, res_retrans);
	}
#endif /* HAVE__RES */
}



/* decide which sources of names and IP addresses are still interesting */
static void
fix_tgt_hits(DNSBL_WORK *dlw)
{
	const DNSBL_HGROUP *hg;
	int gnum;

	/* look at all of the groups */
	dlw->tgt_hits = 0;
	for (gnum = 0, hg = dlw->hgroups;
	     gnum < NUM_DNSBL_GROUPS;
	     ++gnum, ++hg) {
		/* this group is finished if it has a whitelist hit */
		if (hg->hit & DNSBL_HIT_WHITE)
			continue;

		/* add this group's possible whitelist hits to the total */
		dlw->tgt_hits |= group_tgt_hits.w[gnum];

		/* add this group's possible blacklist hits if it has not
		 * had a blacklist hit*/
		if (hg->hit & ~DNSBL_HIT_TIMEO)
			continue;
		dlw->tgt_hits |= group_tgt_hits.b[gnum];
	}
}



static void
dlw_clear(DNSBL_WORK *dlw)
{
	DNSBL_HGROUP *hg;

	dlw->tgt.dom.c[0] = '\0';
	for (hg = dlw->hgroups; hg <= LAST(dlw->hgroups); ++hg) {
		hg->dnsbl = 0;
		hg->hit = 0;
	}
}



/* get ready to handle a mail message */
void
dcc_dnsbl_init(GOT_CKS *cks,
	       DCC_CLNT_CTXT *dcc_ctxt, void *log_ctxt, const char *id)
{
	DNSBL_WORK *dlw;
	int i;

	if (!dnsbls)
		return;

	dlw = cks->dlw;
	if (!dlw) {
		dlw = dcc_malloc(sizeof(*dlw));
		memset(dlw, 0, sizeof(*dlw));
		cks->dlw = dlw;

		/* general initializations on the first use of DNS blacklists */
		fix_url_secs();
	}

	dlw->msg_us = msg_us;
	dlw->id = id;
	dlw->dcc_ctxt = dcc_ctxt;
	dlw->log_ctxt = log_ctxt;
	for (i = 0; i < DIM(dlw->tgt_cache); ++i)
		dlw->tgt_cache[i].dom.c[0] = '\0';
	dlw->tgt_cache_pos = 0;
	dlw_clear(dlw);
	fix_tgt_hits(dlw);
}



/* see if a list is still interesting */
static inline DNSBL_HGROUP *
dp_interesting(DNSBL_WORK *dlw, const DNSBL *dp, DNSBL_HIT src)
{
	DNSBL_HGROUP *hg;

	if (!(dp->tgt_hits & src))
		return 0;		/* wrong lookup type for this list */

	/* list is interesting if its group has not been hit at all */
	hg = &dlw->hgroups[dp->gnum];
	if (hg->hit == 0)
		return hg;

	/* The list's group has past a white or black hit.  If the list
	 * is a blacklist, then it is unneeded in ether case */
	if (!(dp->tgt_hits & DNSBL_HIT_WHITE))
		return 0;

	/* It is a whitelist,
	 * and so interesting only without a past white hit */
	if (!(hg->hit & DNSBL_HIT_WHITE))
		return hg;
	return 0;
}



/* See if at least one of a family of duplicates still wants a lookup.
 *	We decide whether to ask the DNS server for the family at the
 *	head of the family to avoid asking the server more than once.
 */
static u_char
lookup_needed(DNSBL_WORK *dlw,
	      const DNSBL *dp,
	      DNSBL_HIT src)		/* source of name or address */
{
	if (dp->tgt_hits & DNSBL_HIT_DUP)
		return 0;		/* not the head of the family */

	do {
		if (dp_interesting(dlw, dp, src))
			return 1;
	} while ((dp = dp->dup_fwd) != 0);
	return 0;
}



/* look for a host name or IP address in a DNS list and its duplicates */
static u_char				/* 0=no more time or blacklists */
lookup(DNSBL_WORK *dlw,
       const char *probe,		/* look for this */
       const DNSBL *dp,			/* check this blacklist & its dups */
       DNSBL_HIT src,			/* type of lookup */
       const void *tgt)			/* name or IP address */
{
#	define NUM_SUSTRS 3
	char sustrs[DCC_SU2STR_SIZE*NUM_SUSTRS+1+sizeof("...")];
	const DCC_SOCKU *hap;
	struct in6_addr addr;
	DNSBL_HGROUP *hg;
	int error;
#ifdef HAVE_RES_OPTIONS
	u_long save_options;
#endif
	char *p;
	int lists, i;

	if (!time_ck_pre(dlw, src))
		return 0;

	/* resolve a list of IP addresses for the probe in the list */
	dcc_host_lock();
	res_delays(dlw);
#ifdef HAVE_RES_OPTIONS
	save_options = _res.options;
	_res.options &= ~(RES_DEFNAMES | RES_DNSRCH);
	_res.options |= RES_NOALIASES;
#endif
	i = dcc_get_host(probe, dp->tgt_use_ipv46, &error);
#ifdef HAVE_RES_OPTIONS
	_res.options = save_options;
#endif
	if (!i) {
		dcc_host_unlock();
		if (helpers.debug > 1)
			dnsbl_log(dlw, 0, src, DCC_GETHOSTBYNAME_NAME"(%s): %s",
				  probe, H_ERROR_STR1(error));
		return time_ck_post(dlw, src, DCC_HERRNO_TRY_AGAIN(error),
				    H_ERROR_STR1(error));
	}

	/* check each address obtained for the probe for a hit by one of
	 * the family of duplicate references to this list */
	lists = 0;
	do {
		/* skip this list if it does not care */
		hg = dp_interesting(dlw, dp, src);
		if (!hg)
			continue;

		/* check all of the addresses for a hit with this list */
		for (hap = dcc_hostaddrs; hap < dcc_hostaddrs_end; ++hap) {
			apply_ipmask(&addr, dcc_su2ipv6(&addr, 0, hap),
				     &dp->ip_mask);
			if (!in_range(&addr, &dp->ip_range))
				continue;

			/* got a hit for this list */
			hg->dnsbl = dp;
			hg->hit = src;
			if (dp->tgt_hits & DNSBL_HIT_WHITE)
				hg->hit |= DNSBL_HIT_WHITE;
			fix_tgt_hits(dlw);

			++lists;

			if (dp->type == DNSBL_TYPE_IPV4)
				dcc_ipv4tostr(hg->tgt.c, sizeof(hg->tgt), tgt);
			else if (dp->type == DNSBL_TYPE_IPV6)
				dcc_ipv6tostr(hg->tgt.c, sizeof(hg->tgt), tgt);
			else if (dp->type == DNSBL_TYPE_NAME
				 || dp->type == DNSBL_TYPE_ALL_NAMES)
				BUFCPY(hg->tgt.c, tgt);
			hg->btype = type_str(hg->btype_buf,
					     sizeof(hg->btype_buf),
					     dlw, hg->hit);
			BUFCPY(hg->probe.c, probe);
			dcc_su2str2(hg->ip, sizeof(hg->ip), hap);
			if (helpers.debug > 1
			    && (is_helper || !have_helpers))
				dnsbl_log(dlw, hg, hg->hit, "hit %s=%s",
					  probe, dcc_su2str2(sustrs,
							sizeof(sustrs),
							hap));
			break;
		}

		/* check the results in all (duplicate) references to the
		 * underlying list */
	} while ((dp = dp->dup_fwd) != 0);

	if (lists != 0 || helpers.debug < 2) {
		dcc_host_unlock();
		return time_ck_post(dlw, src, 0, 0);
	}

	/* complain about a complete miss if debugging is high enough */
	p = sustrs;
	i = 0;
	do {
		dcc_su2str2(p, DCC_SU2STR_SIZE, &dcc_hostaddrs[i]);
		p += strlen(p);
		*p++ = ' ';
		*p = '\0';
		if (p >= &sustrs[DCC_SU2STR_SIZE*NUM_SUSTRS]) {
			strcpy(p, "...");
			break;
		}
	} while (dcc_hostaddrs_end > &dcc_hostaddrs[++i]);
	dcc_host_unlock();
	dnsbl_log(dlw, 0, src, "miss; "DCC_GETHOSTBYNAME_NAME"(%s)=%s",
		  probe, sustrs);
	return time_ck_post(dlw, src, 0, 0);

#undef NUM_SUSTRS
}



/* check one IP address against the DNS blacklists */
static u_char				/* 0=no more time or blacklists */
ip_lookup(DNSBL_WORK *dlw,
	  DNSBL_TYPE tgt_ip_type,
	  const void *tgt_ip,		/* in_addr* or in6_addr*, not aligned */
	  DNSBL_HIT src)		/* where the address was found */
{
	const DNSBL *dp;
	const u_char *bp;
	DNSBL_DOM probe;

	for (dp = dnsbls; dp; dp = dp->fwd) {
		/* check IP address in this list if it is the right type */
		if (dp->type != tgt_ip_type)
			continue;

		/* check the IP address in this list if it or one of its
		 * fellow duplicates wants this type of lookup */
		if (!lookup_needed(dlw, dp, src))
			continue;

		bp = (u_char *)tgt_ip;
		if (tgt_ip_type == DNSBL_TYPE_IPV4)
			snprintf(probe.c, sizeof(probe.c),
				 "%d.%d.%d.%d.%s",
				 bp[3], bp[2], bp[1], bp[0],
				 dp->dom.c);
		else
			snprintf(probe.c, sizeof(probe.c),
				 "%d.%d.%d.%d.%d.%d.%d.%d"
				 ".%d.%d.%d.%d.%d.%d.%d.%d.%s",
				 bp[15], bp[14], bp[13], bp[12],
				 bp[11], bp[10], bp[9], bp[8],
				 bp[7], bp[6], bp[5], bp[4],
				 bp[3], bp[2], bp[1], bp[0],
				 dp->dom.c);

		if (!lookup(dlw, probe.c, dp, src, tgt_ip))
			return 0;
	}
	return 1;
}



/* convert a name to one or more IP addresses to be checked in a DNS blacklist.
 *  dcc_host_lock() must be held.
 *	These DNS operations need RES_DEFNAMES and RES_DNSRCH off and
 *	RES_NOALIASES on when the name is an MX or NS server name.
 */
static u_char				/* 0=failed */
dnsbl_get_host(DNSBL_WORK *dlw,
	       const DNSBL_DOM *dom,
	       DCC_GETH use_ipv46,
	       int *errorp,		/* put error number here */
	       DNSBL_HIT src RES_ARG_UNUSED)
{
#ifdef MXNS_DNSBL
	u_long save_options;
#endif
	u_char result;

#ifdef MXNS_DNSBL
	save_options = _res.options;
	if (src & (DNSBL_HIT_MHOST_MX | DNSBL_HIT_MHOST_NS
		   | DNSBL_HIT_URL_MX | DNSBL_HIT_URL_NS)) {
		_res.options &= ~(RES_DEFNAMES | RES_DNSRCH);
		_res.options |= RES_NOALIASES;
	}
#endif
	res_delays(dlw);
	result = dcc_get_host(dom->c, use_ipv46, errorp);
#ifdef MXNS_DNSBL
	_res.options = save_options;
#endif
	return result;
}



/* look for a domain name in the DNS lists */
static u_char				/* 0=no more time or blacklists */
name_lookup(DNSBL_WORK *dlw,
	    const DNSBL_DOM *tgt,
	    DNSBL_HIT src)		/* where the name was found */
{
	const DNSBL *dp;
	DNSBL_DOM probe;
	const char *p;
	int offset, tgt_len, probe_len;

	if (!have_name_dnsbl)
		return 1;

	/* trim trailing '.' from names */
	tgt_len = strlen(tgt->c);
	if (tgt_len > 0 && tgt->c[tgt_len-1] == '.')
		--tgt_len;

	for (dp = dnsbls; dp; dp = dp->fwd) {
		/* check IP address in this list if it is the right type */
		if (dp->type != DNSBL_TYPE_NAME
		    && dp->type != DNSBL_TYPE_ALL_NAMES)
			continue;

		/* check the name in this list if it or one of its
		 * fellow duplicates wants this type of lookup */
		if (!lookup_needed(dlw, dp, src))
			continue;

		/* truncate long names on the left and complain */
		offset = (tgt_len + dp->dom_len) - (sizeof(probe.c) - 1);
		if (offset <= 0) {
			offset = 0;
			probe_len = tgt_len;
		} else {
			if (helpers.debug) {
				dnsbl_log(dlw, 0, 0,
					  "target \"%.*s%s\""
					  " is %d bytes too long",
					  50, tgt->c,  tgt_len>50 ? "..." : "",
					  offset);
			}
			probe_len = tgt_len - offset;
		}
		memcpy(probe.c, &tgt->c[offset], probe_len);
		if (dp->dom_len != 0)
			probe.c[probe_len] = '.';
		memcpy(&probe.c[probe_len+1], dp->dom.c, dp->dom_len);

		offset = 0;
		while (offset < probe_len) {
			if (!lookup(dlw, &probe.c[offset], dp, src, tgt))
				return 0;

			/* on a miss, check parent domains if asked
			 * and a hit is still possible */
			if (dp->type != DNSBL_TYPE_ALL_NAMES)
				break;

			p = strchr(&probe.c[offset], '.');
			if (!p)
				break;
			offset = (p+1) - probe.c;
		}
	}

	return 1;
}



/* look for a domain name and its IP addresses in the DNS blacklists */
static u_char				/* 0=no more time or blacklists */
name_ip_lookup(DNSBL_WORK *dlw,
	       const DNSBL_DOM *tgt,
	       DNSBL_HIT src)		/* DNSBL_HIT_MHOST or DNSBL_HIT_URL */
{
	const DCC_SOCKU *sup;
	struct in_addr ipv4[8];
	struct in6_addr ipv6[4];
	int i, error;

	/* check the name */
	if (!name_lookup(dlw, tgt, src))
		return 0;

	/* cannot resolve a null name into an address to try in the lists */
	if (tgt->c[0] == '\0')
		return 1;

	if (!time_ck_pre(dlw, src))
		return 0;

	/* check IPv4 addresses for the name in IPv4 lists */
	if (have_ipv4_dnsbl) {
		dcc_host_lock();
		/* first resolve IPv4 addresses for the URL or client name */
		if (!dnsbl_get_host(dlw, tgt, DCC_GETH_V4, &error, src)) {
			dcc_host_unlock();
			if (helpers.debug > 1)
				dnsbl_log(dlw, 0, src,
					 DCC_GETHOSTBYNAME_NAME"(%s): %s",
					 tgt->c, H_ERROR_STR1(error));
			if (!time_ck_post(dlw, src,
					  DCC_HERRNO_TRY_AGAIN(error), 0))
				return 0;
		} else {
			/* Try several of the IP addresses for the domain.
			 * Save any IP addresses we want to check before we
			 * check them, because checking changes the array
			 * of addresses. */
			for (sup = dcc_hostaddrs, i = 0;
			     sup < dcc_hostaddrs_end && i < DIM(ipv4);
			     ++sup, ++i) {
				ipv4[i] = sup->ipv4.sin_addr;
			}
			dcc_host_unlock();
			if (!time_ck_post(dlw, src, 0, 0))
				return 0;
			/* check the addresses in all of the DNS blacklists */
			do {
				if (!ip_lookup(dlw, DNSBL_TYPE_IPV4,
					       &ipv4[--i], src))
					return 0;
			} while (i > 0);
		}
	}

	/* finally try IPv6 addresses for the name */
	if (have_ipv6_dnsbl) {
		dcc_host_lock();
		if (!dnsbl_get_host(dlw, tgt, DCC_GETH_V6, &error, src)) {
			dcc_host_unlock();
			if (helpers.debug > 1)
				dnsbl_log(dlw, 0, src,
					  DCC_GETHOSTBYNAME_NAME"(%s): %s",
					  tgt->c, H_ERROR_STR1(error));
			if (!time_ck_post(dlw, src, DCC_HERRNO_TRY_AGAIN(error),
					  H_ERROR_STR1(error)))
				return 0;
		} else {
			for (sup = dcc_hostaddrs, i = 0;
			     sup < dcc_hostaddrs_end && i < DIM(ipv6);
			     ++sup, ++i) {
				ipv6[i] = sup->ipv6.sin6_addr;
			}
			dcc_host_unlock();
			if (!time_ck_post(dlw, src, 0, 0))
				return 0;
			do {
				if (!ip_lookup(dlw, DNSBL_TYPE_IPV6,
					       &ipv4[--i], src))
					return 0;
			} while (i > 0);
		}
	}

	return 1;
}



/* check an SMTP client IP address and name */
static void
dnsbl_client(DNSBL_WORK *dlw)
{
	struct in_addr ipv4;

	/* check the SMTP client IP address in IPv4 DNS lists if it
	 * can be converted to an IPv4 address */
	if (have_ipv4_dnsbl
	    && dcc_ipv6toipv4(&ipv4, &dlw->tgt.addr)) {
		if (!ip_lookup(dlw, DNSBL_TYPE_IPV4,
			       &ipv4, DNSBL_HIT_CLIENT))
			return;
	}

	if (have_ipv6_dnsbl
	    && !ip_lookup(dlw, DNSBL_TYPE_IPV6,
			  &dlw->tgt.addr, DNSBL_HIT_CLIENT))
		return;

	/* check the name if we have it */
	if (dlw->tgt.dom.c[0] != '\0'
	    && dlw->tgt.dom.c[0] != '[')
		name_lookup(dlw, &dlw->tgt.dom, DNSBL_HIT_CLIENT);
}




#ifdef MXNS_DNSBL
/* Look directly at DNS resource records.
 *	The first time or two we are called it will be to get and
 *	check the IPv4 and IPv6 address of a name.
 *	We also check the DNS servers for the name using the authority
 *	section of the DNS response for its IPv4 addresses.  Do not ask
 *	explicitly for NS RRs because evil DNS servers might not answer. */
/* look directly at DNS resource records to check the IP address of a name
 * and the MX and NS recordes for the name */
static u_char				/* 1=continue 0=stop looking */
rr_lookup(DNSBL_WORK *dlw,
	  const char *name,		/* see if this domain is blacklisted */
	  int req_type,			/* T_A, T_AAAA, or T_MX */
	  DNSBL_HIT src,		/* DNSBL_HIT_{MHOST,URL}{,_MX} */
	  DNSBL_HIT ns_src)		/* DNSBL_HIT_{MHOST,URL}_NS */
{
	union {
	    u_char  buf[PACKETSZ+20];
	    HEADER  hdr;
	} answer;
	DNSBL_DOM dom;
	const u_char *ap, *ap1, *eom;
	int cnt, skip;
	u_short resp_type;
	u_short resp_class, rdlength;
	int res_len;

	if (!time_ck_pre(dlw, src | ns_src))
		return 0;

	/* Get a set of RRs of the desired type for a name. */
	res_delays(dlw);
	dcc_host_lock();
	res_len = res_query(name, C_IN, req_type,
			    answer.buf, sizeof(answer.buf));
	dcc_host_unlock();
	if (res_len < 0) {
		/* use raw hstrerror() here because we are using the
		 * raw resolver */
		if (helpers.debug > 1) {
#ifdef HAVE__RES
			if (helpers.debug > 4)
				dnsbl_log(dlw, 0, src,
					  "retrans=%d retry=%d "
					  "res_query(%s): %s",
					  _res.retrans, _res.retry,
					  name, hstrerror(h_errno));
			else
#endif
				dnsbl_log(dlw, 0, src, "res_query(%s): %s",
					  name, hstrerror(h_errno));
		}
		/* stop looking after too much time or NXDOMAIN */
		return (time_ck_post(dlw, src, DCC_HERRNO_TRY_AGAIN(h_errno),
				     H_ERROR_STR1(h_errno))
			&& h_errno != HOST_NOT_FOUND);
	}
	if (!time_ck_post(dlw, src, 0, 0))
		return 0;

	ap = &answer.buf[HFIXEDSZ];
	if (res_len > ISZ(answer.buf))
		res_len = ISZ(answer.buf);
	eom = &answer.buf[res_len];

	/* skip the question */
	cnt = ntohs(answer.hdr.qdcount);
	while (--cnt >= 0) {
		skip = dn_skipname(ap, eom);
		if (skip < 0) {
			if (helpers.debug > 1)
				dnsbl_log(dlw, 0, src, "dn_skipname(%s)=%d",
					 name, skip);
			/* look for other RRs */
			return 1;
		}
		ap += skip+QFIXEDSZ;
	}


	/* check each name or address RR in the answer section */
	for (cnt = ntohs(answer.hdr.ancount);
	     --cnt >= 0 && ap < eom;
	     ap += rdlength) {
		/* get the name */
		skip = dn_expand(answer.buf, eom, ap, dom.c, sizeof(dom.c));
		if (skip < 0) {
			if (helpers.debug > 1)
				dnsbl_log(dlw, 0, src,
					  "answer dn_expand(%s)=%d",
					  name, skip);
			return 1;
		}
		ap += skip;

		/* get RR type and class and skip strange RRs */
		GETSHORT(resp_type, ap);
		GETSHORT(resp_class, ap);
		ap += 4;		/* skip TTL */
		GETSHORT(rdlength, ap);	/* get rdlength */

		/* we care only about relevant answers */
		if (resp_type != req_type
		    || resp_class != C_IN)
			continue;

		if (req_type == T_MX) {
			/* check MX name */
			ap1 = ap + 2;	/* skip MX preference */
			skip = dn_expand(answer.buf, eom, ap1,
					 dom.c, sizeof(dom.c));
			if (skip < 0) {
				if (helpers.debug > 1)
					dnsbl_log(dlw, 0, src,
						  "MX dn_expand(%s)=%d",
						  name, skip);
				return 1;
			}

			if (dom.c[0] == '\0'
			    && helpers.debug > 1)
				dnsbl_log(dlw, 0, src, "null MX name");

			if (!name_ip_lookup(dlw, &dom, src))
				return 0;

		} else if (req_type == T_A) {
			if (!ip_lookup(dlw, DNSBL_TYPE_IPV4, ap, src))
				return 0;
#ifndef DCC_NO_IPV6
		} else if (req_type == T_AAAA) {
			if (!ip_lookup(dlw, DNSBL_TYPE_IPV6, ap, src))
				return 0;
#endif
		}
	}

	/* check the authority section if we care about name servers */
	if (ns_src == 0)
		return 1;

	/* we could look at the additional section, but it can be incomplete */
	for (cnt = ntohs(answer.hdr.nscount);
	     --cnt >= 0 && ap < eom;
	     ap += rdlength) {
		/* get the name */
		skip = dn_expand(answer.buf, eom, ap, dom.c, sizeof(dom.c));
		if (skip < 0) {
			if (helpers.debug > 1)
				dnsbl_log(dlw, 0, ns_src, "ns dn_expand(%s)=%d",
					  name, skip);
			return 1;
		}
		ap += skip;

		/* get RR type and class */
		GETSHORT(resp_type, ap);
		GETSHORT(resp_class, ap);
		ap += 4;		/* skip TTL */
		GETSHORT(rdlength, ap);	/* get rdlength */

		/* we care only about NS RRs */
		if (resp_type != T_NS
		    || resp_class != C_IN)
			continue;

		skip = dn_expand(answer.buf, eom, ap, dom.c, sizeof(dom.c));
		if (skip < 0) {
			if (helpers.debug > 1)
				dnsbl_log(dlw, 0, ns_src,
					  "ns answer dn_expand(%s)=%d",
					  name, skip);
			return 1;
		}

		if (dom.c[0] == '\0'
		    && helpers.debug > 1)
			dnsbl_log(dlw, 0, src, "null NS name");

		if (!name_ip_lookup(dlw, &dom, ns_src))
			return 0;
	}

	return 1;
}
#endif /* MXNS_DNSBL */



/* look for an env_From Mail_host or URL domain in the DNS blacklists,
 * including the names and IP addresses of its MX & NS servers */
static void
dnsbl_name_url_mhost(DNSBL_WORK *dlw,
		     DNSBL_HIT src)	/* DNSBL_HIT_MHOST or DNSBL_HIT_URL */
{
	DCC_SOCKU su;
#ifdef MXNS_DNSBL
	DNSBL_HIT ns_src;
#endif

	/* recognize an ASCII IP address */
	if (str2su(&su, dlw->tgt.dom.c)) {
		if (su.sa.sa_family == AF_INET)
			ip_lookup(dlw, DNSBL_TYPE_IPV4, &su.ipv4.sin_addr, src);
		else
			ip_lookup(dlw, DNSBL_TYPE_IPV6, &su.ipv6.sin6_addr, src);
		return;
	}

#ifndef MXNS_DNSBL
	/* check name and its addresses */
	name_ip_lookup(dlw, &dlw->tgt.dom, src);

#else /* MXNS_DNSBL */
	/* first check only the name */
	if (!name_lookup(dlw, &dlw->tgt.dom, src))
		return;

	/* Check the IP addresses of the name.  Also check NS records by
	 * looking in the authority section for A and AAAA RRs. */
	if (src == DNSBL_HIT_MHOST)
		ns_src = dlw->tgt_hits & DNSBL_HIT_MHOST_NS;
	else
		ns_src = dlw->tgt_hits & DNSBL_HIT_URL_NS;
	if (have_ipv4_dnsbl) {
		if (!rr_lookup(dlw, dlw->tgt.dom.c, T_A, src, ns_src))
			return;
		ns_src = 0;
	}
#ifndef DCC_NO_IPV6
	if (have_ipv6_dnsbl) {
		if (!rr_lookup(dlw, dlw->tgt.dom.c, T_AAAA, src, ns_src))
			return;
		ns_src = 0;
	}
#endif

	/* check the MX names
	 * and DNS servers for name if we have not already */
	if (src == DNSBL_HIT_MHOST
	    && (dlw->tgt_hits & DNSBL_HIT_MHOST_MX)) {
		rr_lookup(dlw, dlw->tgt.dom.c,
			  T_MX, DNSBL_HIT_MHOST_MX, ns_src);
	} else if (src == DNSBL_HIT_URL
		   && (dlw->tgt_hits & DNSBL_HIT_URL_MX)) {
		rr_lookup(dlw, dlw->tgt.dom.c,
			  T_MX, DNSBL_HIT_URL_MX, ns_src);
	}
#endif /* MXNS_DNSBL */
}



#ifdef HAVE_HELPERS
/* do some work in a helper process */
u_char					/* 1=try to send the response */
dnsbl_helper_work(const DNSBL_REQ *req, DNSBL_RESP *resp)
{
	DNSBL_WORK dlw;
	DNSBL_RESP_HGROUP *rhg;
	DNSBL_HGROUP *hg;
	int gnum;

	dlw_clear(&dlw);
	dlw.url_start = req->hdr.start;
	dlw.msg_us = MAX_MSG_SECS*DCC_US*2;
	dlw.url_us = req->hdr.avail_us;
	dlw.url_us_used = 0;
	dlw.id = req->hdr.id;
	dlw.dcc_ctxt = 0;
	dlw.log_ctxt = 0;

	if (!is_helper) {
		/* this must be the first job for this helper process */
		is_helper = 1;
		helper_str = " helper";
		fix_url_secs();
	}

	/* figure out the request */
	for (gnum = 0, hg = dlw.hgroups;
	     gnum < NUM_DNSBL_GROUPS;
	     ++gnum, ++hg) {
		hg->hit = req->ghits[gnum] & ~DNSBL_HIT_TIMEO;
	}
	fix_tgt_hits(&dlw);

	/* do the work */
	switch (req->src) {
	case DNSBL_HIT_CLIENT:		/* SMTP client IP address */
		dlw.tgt.addr = req->tgt.addr;
		BUFCPY(dlw.tgt.dom.c, req->tgt.dom.c);
		dnsbl_client(&dlw);
		break;
	case DNSBL_HIT_MHOST:		/* envelope mail_from */
	case DNSBL_HIT_URL:		/* URL in body */
		BUFCPY(dlw.tgt.dom.c, req->tgt.dom.c);
		dnsbl_name_url_mhost(&dlw, req->src);
		break;
	default:
		dcc_logbad(EX_SOFTWARE, "%s DNSBL%s unknown type %d",
			   req->hdr.id, helper_str, req->src);
	}

	/* send the results */
	for (gnum = 0, hg = dlw.hgroups, rhg = resp->hgroups;
	     gnum < NUM_DNSBL_GROUPS;
	     ++gnum, ++hg, ++rhg) {
		if ((req->ghits[gnum] & ~DNSBL_HIT_TIMEO) != 0) {
			rhg->hit = 0;
			continue;
		}
		rhg->hit = hg->hit;
		if ((rhg->hit & ~DNSBL_HIT_TIMEO) == 0)
			continue;
		rhg->num = hg->dnsbl->num;
		BUFCPY(rhg->tgt.c, hg->tgt.c);
		BUFCPY(rhg->probe.c, hg->probe.c);
		BUFCPY(rhg->ip, hg->ip);
	}

	return 1;
}



/* ask a helper process to check for something in the DNS blacklists */
static void
use_helper(DNSBL_WORK *dlw,
	   DNSBL_HIT src)		/* where name or address was found */
{
	DNSBL_REQ req;
	DNSBL_RESP resp;
	DNSBL_RESP_HGROUP *rhg;
	DNSBL_HGROUP *hg;
	const DNSBL *dp;
	u_char result;
	int gnum;

	/* prepare and send the request to a helper */
	memset(&req, 0, sizeof(req));

	BUFCPY(req.hdr.id, dlw->id);
	req.src = src;
	switch (src) {
	case DNSBL_HIT_CLIENT:
		BUFCPY(req.tgt.dom.c, dlw->tgt.dom.c);
		req.tgt.addr = dlw->tgt.addr;
		break;
	case DNSBL_HIT_MHOST:
	case DNSBL_HIT_URL:
		BUFCPY(req.tgt.dom.c, dlw->tgt.dom.c);
		break;
	default:
		dcc_logbad(EX_SOFTWARE, "unknown DNSBL type %#x", src);
	}

	result = ask_helper(dlw,
			    &req.hdr, sizeof(req), &resp.hdr, sizeof(resp));
	time_ck_post(dlw, src, !result, 0);
	msg_secs_fin(dlw);
	if (!result)
		return;

	/* digest the helper's answer */

	for (gnum = 0, hg = dlw->hgroups, rhg = resp.hgroups;
	     gnum < NUM_DNSBL_GROUPS;
	     ++gnum, ++hg, ++rhg) {
		if (rhg->hit == 0)
			continue;

		/* This group has a new hit. */
		hg->hit = rhg->hit;
		if ((hg->hit & ~DNSBL_HIT_TIMEO) == 0)
			continue;

		/* Discover the responsible list so we can use the right
		 * template for the SMTP status message */
		for (dp = dnsbls; ; dp = dp->fwd) {
			if (!dp)
				dcc_logbad(EX_SOFTWARE, "bad helper DNSBL #%d",
					   rhg->num);
			if (dp->num == rhg->num)
				break;
		}
		hg->dnsbl = dp;
		BUFCPY(hg->tgt.c, rhg->tgt.c);
		BUFCPY(hg->probe.c, rhg->probe.c);
		BUFCPY(hg->ip, rhg->ip);
		hg->btype = type_str(hg->btype_buf, sizeof(hg->btype_buf),
				    dlw, hg->hit);
	}
	fix_tgt_hits(dlw);
}
#endif /* HAVE_HELPERS */


void
dcc_client_dnsbl(DNSBL_WORK *dlw, const struct in6_addr *addr, const char *name)
{
	/* nothing to do if no client DNS blacklists have been configured */
	if (!dlw
	    || !(dlw->tgt_hits & DNSBL_HIT_CLIENT))
		return;

	/* or if we have already spent too much time checking blacklists */
	if (!msg_secs_start(dlw, DNSBL_HIT_CLIENT))
		return;

	BUFCPY(dlw->tgt.dom.c, name);
	dlw->tgt.addr = *addr;

#ifdef HAVE_HELPERS
	if (have_helpers) {
		use_helper(dlw, DNSBL_HIT_CLIENT);
		return;
	}
#endif

	dnsbl_client(dlw);
	time_ck_post(dlw, DNSBL_HIT_CLIENT, 0, 0);
	msg_secs_fin(dlw);
}



void
dcc_mail_host_dnsbl(DNSBL_WORK *dlw, const char *host)
{
	/* nothing to do if no DNS blacklists have been configured */
	/* or no still active lists care about the Mail_From host name
	 * or we do not have an envelope Mail_From host name */
	if (!dlw
	    || !(dlw->tgt_hits & DNSBL_HIT_MHOST)
	    || !host || *host == '\0')
		return;

	/* or if we have already spent too much time checking blacklists */
	if (!msg_secs_start(dlw, DNSBL_HIT_MHOST))
		return;

	BUFCPY(dlw->tgt.dom.c, host);

#ifdef HAVE_HELPERS
	if (have_helpers) {
		use_helper(dlw, DNSBL_HIT_MHOST);
		return;
	}
#endif

	dnsbl_name_url_mhost(dlw, DNSBL_HIT_MHOST);
	time_ck_post(dlw, DNSBL_HIT_MHOST, 0, 0);
	msg_secs_fin(dlw);
}



void
url_dnsbl(DNSBL_WORK *dlw, const char *dom)
{
	int i;

	/* nothing to do if no body URL lists have been configured
	 * or if we already have hits for all lists */
	if (!dlw || !(dlw->tgt_hits & DNSBL_HIT_URL))
		return;

	i = strspn(dom, "-_.abcdefghijklmnopqrstuvwxyz0123456789");
	if (dom[i] != '\0') {
		if (helpers.debug > 1)
			dnsbl_log(dlw, 0, 0, "invalid domain name \"%s\"",
				  escstr(dlw->tgt.dom.c, sizeof(dlw->tgt.dom.c),
					 dom, strlen(dom)));
		return;
	}

	/* or if we have already spent too much time checking blacklists */
	if (!msg_secs_start(dlw, DNSBL_HIT_URL))
		return;

	/* avoid checking the same names */
	for (i = 0; i < DIM(dlw->tgt_cache); ++i) {
		if (!strcmp(dom, dlw->tgt_cache[i].dom.c)) {
			if (helpers.debug > 2)
				dnsbl_log(dlw, 0, DNSBL_HIT_URL,
					  "tgt_cache hit %s", dom);
			dlw->tgt_cache_pos = i;
			return;
		}
	}
	BUFCPY(dlw->tgt_cache[dlw->tgt_cache_pos].dom.c, dom);
	dlw->tgt_cache_pos = (dlw->tgt_cache_pos + 1) % DIM(dlw->tgt_cache);

	BUFCPY(dlw->tgt.dom.c, dom);

#ifdef HAVE_HELPERS
	if (have_helpers) {
		use_helper(dlw, DNSBL_HIT_URL);
		return;
	}
#endif

	dnsbl_name_url_mhost(dlw, DNSBL_HIT_URL);
	time_ck_post(dlw, DNSBL_HIT_URL, 0, 0);
	msg_secs_fin(dlw);
}
