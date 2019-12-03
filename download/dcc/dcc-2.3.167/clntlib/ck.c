/* Distributed Checksum Clearinghouse
 *
 * compute simple checksums
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
 * Rhyolite Software DCC 2.3.167-1.114 $Revision$
 */

#include "dcc_ck.h"
#include "dcc_heap_debug.h"
#include "dcc_xhdr.h"
#ifndef DCC_WIN32
#include <arpa/inet.h>
#endif


/* "substitute" or locally configured checksums */
typedef struct {
    u_int	nm_len;
    const char	*nm;			/* name of the checksum */
    u_char	first;			/* save first instead of last instance */
} SUB_CK;
static SUB_CK sub_cks[MAX_SUB_CKS];
static u_int num_sub_cks;


/* get the checksum of an IPv6 address */
void
ipv6tock(DCC_SUM *sum, const struct in6_addr *addr)
{
	MD5_CTX ctx;

	MD5Init(&ctx);
	MD5Update(&ctx, (void *)addr, sizeof(*addr));
	MD5Final(sum->b, &ctx);
}



/* add an IP address to the set of checksums */
void
get_ipv6_ck(GOT_CKS *cks, const struct in6_addr *addrp)
{
	cks->sums[DCC_CK_IP].type = DCC_CK_IP;
	cks->sums[DCC_CK_IP].rpt2srvr = 1;
	cks->sums[DCC_CK_IP].tgts = DCC_TGTS_INVALID;
	ipv6tock(&cks->sums[DCC_CK_IP].sum, addrp);

	cks->sums[DCC_CK_REP_TOTAL].type = DCC_CK_REP_TOTAL;
	cks->sums[DCC_CK_REP_TOTAL].rpt2srvr = 1;
	cks->sums[DCC_CK_REP_TOTAL].tgts = DCC_TGTS_INVALID;
	cks->sums[DCC_CK_REP_TOTAL].sum = cks->sums[DCC_CK_IP].sum;

	cks->sums[DCC_CK_REP_BULK].type = DCC_CK_REP_BULK;
	cks->sums[DCC_CK_REP_BULK].rpt2srvr = 1;
	cks->sums[DCC_CK_REP_BULK].tgts = DCC_TGTS_INVALID;
	cks->sums[DCC_CK_REP_BULK].sum = cks->sums[DCC_CK_IP].sum;

	if (&cks->ip_addr != addrp)
		cks->ip_addr = *addrp;
}



/* do not tell the server about the IP address, but include it in the logs */
void
no_ip_rpt2srvr(GOT_CKS *cks)
{
	cks->sums[DCC_CK_IP].rpt2srvr = 0;

	/* IP addresses that are not reportable do not have reputations */
	CLR_GOT_SUM(&cks->sums[DCC_CK_REP_TOTAL]);
	CLR_GOT_SUM(&cks->sums[DCC_CK_REP_BULK]);
}



/* forget the body and header checksums when an SMTP message is aborted */
void
unget_body_ck(GOT_CKS *cks)
{
	CLR_GOT_SUM(&cks->sums[DCC_CK_FROM]);
	CLR_GOT_SUM(&cks->sums[DCC_CK_MESSAGE_ID]);
	CLR_GOT_SUM(&cks->sums[DCC_CK_RECEIVED]);
	CLR_GOT_SUM(&cks->sums[DCC_CK_BODY]);
	CLR_GOT_SUM(&cks->sums[DCC_CK_FUZ1]);
	CLR_GOT_SUM(&cks->sums[DCC_CK_FUZ2]);
}



/* Get an IP address for a checksum structure from a string.
 *	Do not compute the checksum or mark it present */
void
su2cks(GOT_CKS *cks, const DCC_SOCKU *su)
{
	/* treat IPv4 addresses as IPv6 so that everyone computes
	 * the same checksum */
	dcc_su2ipv6(&cks->ip_addr, 1, su);

	get_ipv6_ck(cks, &cks->ip_addr);
}



/* Compute a checksum from a string with matching but optional carets or
 * quotes, after stripping the quotes or carets.
 * Ignore case and white space */
void
str2ck(DCC_SUM *sum,
       const char *hdr,			/* substitute header type */
       u_int hdr_len,
       const char *str)			/* string to checksum */
{
	MD5_CTX ctx;
	u_int len;
	char *p;
	char c, cbuf[HDR_CK_MAX];

	/* ignore whitespace, [<>'",] and case
	 * do not ignore [.-_] to prevent confusing host names */
	p = cbuf;
	while ((c = *str++) != '\0' && p <= LAST(cbuf)) {
		if (DCC_IS_WHITE(c)
		    || c == '<' || c == '>'
		    || c == '\'' || c == '"' || c == ',')
			continue;
		*p++ = DCC_TO_LOWER(c);
	}
	str = cbuf;
	len = p - str;
	/* strip trailing periods, mostly for mail_host */
	while (len >= 1
	       && *(p-1) == '.') {
		--len;
		--p;
	}
	MD5Init(&ctx);
	if (hdr)
		MD5Update(&ctx, (void *)hdr, hdr_len);
	MD5Update(&ctx, (void *)str, len);
	MD5Final(sum->b, &ctx);
}



/* make checksum from a string for headers and envelope */
u_char					/* 1=ok 0=bad string */
get_cks(GOT_CKS *cks,			/* put checksum here */
	DCC_CK_TYPES type,
	const char *str,		/* checksum of this string */
	u_char rpt2srvr)
{
	GOT_SUM *g;

	g = &cks->sums[type];

	switch (type) {
	case DCC_CK_INVALID:
	case DCC_CK_IP:
	case DCC_CK_SUB:
	case DCC_CK_SRVR_ID:
	case DCC_CK_BODY:
	case DCC_CK_FUZ1:
	case DCC_CK_FUZ2:
	case DCC_CK_G_MSG_R_TOTAL:
	case DCC_CK_G_TRIPLE_R_BULK:
		dcc_logbad(EX_SOFTWARE, "invalid checksum %s",
			   type2str_err(type, 0, 0, 0));

	case DCC_CK_ENV_FROM:
	case DCC_CK_FROM:
	case DCC_CK_ENV_TO:
	case DCC_CK_RECEIVED:
	case DCC_CK_MESSAGE_ID:
		str2ck(&g->sum, 0, 0, str);
		break;
	}

	g->type = type;
	g->rpt2srvr = rpt2srvr;
	g->tgts = DCC_TGTS_INVALID;
	return 1;
}



/* make checksum for a locally configured header */
u_char					/* 1=done 0=failed */
ck_get_sub(GOT_CKS *cks,
	   const char *hdr,		/* header name, not '\0' terminated */
	   const char *str)		/* header value if not after hdr */
{
	GOT_SUM *g;
	const SUB_CK *sck;
	int type, i;

	/* look for the header name in the list of locally configured headers */
	sck = &sub_cks[0];
	for (i = num_sub_cks; ; ++sck, --i) {
		if (i <= 0)
			return 0;	/* this header is not in the list */
		if (!strncasecmp(hdr, sck->nm, sck->nm_len)
		    && (hdr[sck->nm_len] == '\0'
			|| hdr[sck->nm_len] == ':'))
			break;
	}

	/* Get the header value if the caller did not separate it.
	 * The colon is present if the header field was not separated */
	if (!str)
		str = hdr+sck->nm_len+1;

	/* find a free checksum slot
	 * or a slot already assigned to the header */
	type = DCC_CK_SUB;
	g = &cks->sums[type];
	for (;;) {
		if (type >= DIM(cks->sums))
			return 0;	/* none free */

		if (g->type == DCC_CK_INVALID
		    && (type > DCC_CK_TYPE_LAST
			|| type == DCC_CK_SUB))
			break;		/* found a free slot */

		if (g->type == DCC_CK_SUB
		    && g->hdr_nm == sck->nm) {
			/* found previously assigned slot
			 * quit if we want the first instance */
			if (sck->first)
				return 0;
			break;
		}
		++g;
		++type;
	}

	str2ck(&g->sum, sck->nm, sck->nm_len, str);
	g->type = DCC_CK_SUB;
	g->rpt2srvr = 1;
	g->tgts = DCC_TGTS_INVALID;
	g->hdr_nm = sck->nm;
	return 1;
}



/* add to the list of locally configured or substitute headers */
u_char
dcc_add_sub_hdr(DCC_EMSG *emsg, const char *hdr)
{
	const char *p;
	char c, *q;
	u_char first;
	u_int n, len;

	if (num_sub_cks >= DIM(sub_cks)) {
		dcc_pemsg(EX_USAGE, emsg,
			  "too many substitute headers with \"%s\"", hdr);
		return 0;
	}

	if (*hdr == '+') {
		first = 1;
		++hdr;
	} else {
		first = 0;
	}
	p = hdr;
	for (;;) {
		if (*p == '\0')
			break;
		if (*p == ':' && p[1] == '\0') {
			--p;
			break;
		}
		if (*p <= ' ' || *p >= 0x7f || *p == ':') {
			dcc_pemsg(EX_USAGE, emsg,
				  "illegal SMTP field name character in \"%s\"",
				  hdr);
			return 0;
		}
		++p;
	}

	len = p - hdr;
	if (len == 0) {
		dcc_pemsg(EX_USAGE, emsg, "illegal empty field name");
		return 0;
	}

	/* ignore duplicates */
	for (n = 0; n < num_sub_cks; ++n) {
		if (len == sub_cks[n].nm_len
		    && !strncasecmp(hdr, sub_cks[n].nm, len))
			return 1;
	}

	sub_cks[num_sub_cks].first = first;
	sub_cks[num_sub_cks].nm_len = len;
	q = dcc_malloc(len+1);
	sub_cks[num_sub_cks].nm = q;
	do {
		c = *hdr++;
		*q++ = DCC_TO_LOWER(c);
	} while (--len > 0);
	*q = '\0';
	++num_sub_cks;

	return 1;
}



/* buffer used first to make a null-terminated string to compute checksum
 * and later an SMTP address literal for the SMTP client name */
typedef struct {
    DCC_SOCKU	su;
    int		strlen;
    char	*str;
    char	b[1+LITZ(DCC_IPV6_ALIT)	/* address literal without '\0' if */
		  +INET6_ADDRSTRLEN+1+1];   /* needed for SMTP client name */
} ADDR_BUF;

/* match an IPv4 or IPv6 address */
static int				/* 0 or bytes skipped */
get_ipaddr(ADDR_BUF *addr_buf, const char *ptr)
{
	char *str;
	int skiplen, addrlen;

	/* ignore "IPv6:" tag if present */
	if (!CLITCMP(ptr, DCC_IPV6_ALIT)) {
		skiplen = LITZ(DCC_IPV6_ALIT);
		ptr += skiplen;
	} else {
		skiplen = 0;
	}

	/* try to parse the address whatever it is */
	addrlen = strspn(ptr, DCC_IPV6_CHARS);
	if (addrlen < 2 || addrlen > INET6_ADDRSTRLEN)
		return 0;

	str = &addr_buf->b[1+LITZ(DCC_IPV6_ALIT)];
	memcpy(str, ptr, addrlen);
	str[addrlen] = '\0';
	if (!str2su(&addr_buf->su, str))
		return 0;

	/* generate a proper SMTP address literal string */
	if (addr_buf->su.sa.sa_family == AF_INET6) {
		addr_buf->str = &addr_buf->b[0];
		memcpy(&addr_buf->str[1], DCC_IPV6_ALIT, LITZ(DCC_IPV6_ALIT));
		addr_buf->strlen = 1+LITZ(DCC_IPV6_ALIT)+addrlen+1;
	} else {
		addr_buf->str = &addr_buf->b[LITZ(DCC_IPV6_ALIT)];
		addr_buf->strlen = 1+addrlen+1;
	}
	addr_buf->str[0] = '[';
	addr_buf->str[addr_buf->strlen-1] = ']';
	addr_buf->str[addr_buf->strlen] = '\0';
	return skiplen+addrlen;
}



/* find IP address, client host name, and HELO string in a Received:
 *	    header of forms:
 *  #1	Received: from helo (hostname [addr] ...
 *	Received: from helo ([addr] ...
 *  #2	Received: from hostname [addr] ...
 *	Received: from  [addr] ...
 *  #3	Received: from qmailheloandhostname (addr) ...
 *  #4	Received: from qmailhostname (HELO qmailhelo) (addr) ...
 *   or	Received: from qmailhostname (HELO qmailhelo) ([addr]) ...
 *
 * ignore these forms:
 *  #5	Received: from localhost by hostname with LMTP
 *  #6	Received  (qmail 4824 invoked by uid 1000); 8 Nov 2005 12:13:33 -0000
 *  #7	Received: (qmail 21530 invoked from network); 29 Aug 2005 16:05:04 -0000
 *  #8	Received: (from user@localhost) by lochost (8.12.10/8.12.10/Submit) ...
 *  #9  Received: by hostname (Postfix) id ...
 *  #10 Received: by hostname with SMTP id ...
 *
 * This should be called only with Received: headers that are known to
 *	have been added by trustworthy code such as the local system
 *	or an MX secondary.
 * Return 0 for unknown header, "" if IP address found, or stupid type string
 */
const char *
parse_received(const char *hdr,		/* the null terminated header */
	       GOT_CKS *cks,		/* put address checksum here */
	       char *helo,		/* optionally put HELO value here */
	       int helo_len,
	       char *clnt_str, int clnt_str_len,
	       char *clnt_name, int clnt_name_len)
{
	ADDR_BUF addr_buf;
	const char *h, *h1, *n;
	int h_len, n_len, a_len;
	int i;

	/* make the field name optional */
	if (!CLITCMP(hdr, "Received:"))
		hdr += LITZ("Received");
	hdr += strspn(hdr, " \t\r\n");

/* #define DCC_DEBUG_PARSE_RECEIVED */
#ifdef DCC_DEBUG_PARSE_RECEIVED
	printf("\n\nReceived: %s\n", hdr);
#endif

	if (CLITCMP(hdr, "from")) {
		/* It does not match "Received: from" in #1, #2, #3, #4, and #5
		 * Recognize #6 and #7 */
		if (!LITCMP(hdr, "(qmail ")) {
			hdr += LITZ("(qmail ");
			i = strspn(hdr, "0123456789");
			if (i == 0)
				return 0;
			hdr += i;
			if (!LITCMP(hdr, " invoked from network)")
			    || !LITCMP(hdr, " invoked by uid "))
				return "qmail";
			return 0;
		}
		/* recognize #8 */
		if (!LITCMP(hdr, "(from ")) {
			hdr += LITZ("(from ");
			hdr = strpbrk(hdr, DCC_WHITESPACE"@");
			if (!hdr || *hdr != '@')
				return 0;
			hdr = strpbrk(hdr, DCC_WHITESPACE")");
			if (!hdr || *hdr != ')')
				return 0;
			hdr += 1+strspn(hdr+1, DCC_WHITESPACE);
			if (LITCMP(hdr, "by "))
				return 0;
			hdr += LITZ("by ");
			if (strstr(hdr, "/Submit"))
				return "sendmail Submit";
			return 0;
		}
		/* recognize #9 and #10 */
		if (!LITCMP(hdr, "by ")) {
			hdr += LITZ("by ");
			hdr = strpbrk(hdr, DCC_WHITESPACE);
			if (!hdr)
				return 0;
			++hdr;
			if (!LITCMP(hdr, "(Postfix)"))
				return "postfix";
			if (!LITCMP(hdr, "with SMTP id"))
				return "gmail";
			return 0;
		}
		/* unrecognized */
		return 0;
	}

	hdr += LITZ("from");
	i = strspn(hdr, DCC_WHITESPACE);
	if (i == 0)
		return 0;
	hdr += i;

	/* We have "Received: from "
	 * get the host name or HELO value before '(' or '[' in
	 * #1, #2, #3, and #5 */
	h = hdr;
	hdr = strpbrk(h, DCC_WHITESPACE"([");
	if (!hdr)
		return 0;		/* unrecognized */

	/* h and h_len should be the HELO name, but
	 * don't be fooled by a spammer HELO value like [127.0.0.1]
	 * while allowing a missing HELO value. */
	if (h == hdr && *h == '['
	    && (h1 = strpbrk(h+1, DCC_WHITESPACE"([")) != 0)
		hdr = h1;
	h_len = hdr - h;
	hdr += strspn(hdr, DCC_WHITESPACE);

	if (*hdr == '(') {
		/* look for client host name of #1
		 * or IPv4 address of #3
		 * or HELO value and IPv4 address of #4 */
		++hdr;

		if ((a_len = get_ipaddr(&addr_buf, hdr)) > 0
		    && hdr[a_len] == ')') {
			/* we have the IP address of #3 in addr_buf */
			n = h;
			n_len = h_len;

		} else if (!LITCMP(hdr, "HELO ")
			   && hdr[LITZ("HELO ")] != '[') {
			/* we have the #4 qmail HELO form when reverse DNS name
			 * and helo value differ or unrecognizable */
			n = h;
			n_len = h_len;
			h = hdr + LITZ("HELO ");
			hdr = strpbrk(h, " \t'\"()[]");
			if (!hdr)
				return 0;
			h_len = hdr - h;
			if (!h_len
			    || LITCMP(hdr, ") ("))
			    return 0;
			hdr += LITZ(") (");
			if ((a_len = get_ipaddr(&addr_buf, hdr)) > 0
			    && hdr[a_len] == ')') {
				;	/* got the IP address */
			} else if (hdr[0] == '['
				   && (a_len = get_ipaddr(&addr_buf, hdr+1)) > 0
				   && hdr[1+a_len] == ']'
				   && hdr[2+a_len] == ')') {
				;	/* got the IP address */
			} else {
				return 0;
			}

		} else {
			/* it is #1 or unrecognizable */
			n = hdr;
			hdr = strpbrk(hdr, DCC_WHITESPACE"[");
			if (!hdr)
				return 0;   /* unrecognizable */

			n_len = hdr - n;    /* n & n_len are reverse DNS name */
			hdr += strspn(hdr, DCC_WHITESPACE);
			if (*hdr != '[')
				return 0;
			a_len = get_ipaddr(&addr_buf, hdr+1);
			if (!a_len)
				return 0;
		}

	} else if (*hdr == '[') {
		/* format #2; we have possibly null client name and no HELO */
		n = h;
		n_len = h_len;
		h_len = 0;
		a_len = get_ipaddr(&addr_buf, hdr+1);
		if (!a_len)
			return 0;

	} else if (!CLITCMP(hdr, "by ")) {
		/* recognize #5 */
		hdr += LITZ("by ");
		n = strchr(hdr, ' ');
		if (!n || n > hdr+DCC_MAXDOMAINLEN)
			return 0;
		if (!CLITCMP(n, " with LMTP"))
			return "LMTP";	/* stupid type string */
		return 0;

	} else {
		return 0;
	}

	/* it looks ok so release the answers */
	su2cks(cks, &addr_buf.su);
	dcc_ipv6tostr(clnt_str, clnt_str_len, &cks->ip_addr);

	if (clnt_name && clnt_name_len) {
		if (n_len == 0) {
			/* we must use address as the client host name and
			 * so need the official SMTP address literal form */
			n = addr_buf.str;
			n_len = addr_buf.strlen;
		}
		if (clnt_name_len > n_len+1)
			clnt_name_len = n_len+1;
		STRLCPY(clnt_name, n, clnt_name_len);
	}

	if (helo && helo_len) {
		if (helo_len > h_len+1)
			helo_len = h_len+1;
		STRLCPY(helo, h, helo_len);
	}

#ifdef DCC_DEBUG_PARSE_RECEIVED
	printf("helo=%s  clnt_str=%s  clnt_name=%s\n",
	       helo, clnt_str, clnt_name);
#endif

	return "";
}



u_char					/* 1=found env_From value */
parse_return_path(const char *hdr, char *buf, int buf_len)
{
	int i;

	if (CLITCMP(hdr, "Return-Path:"))
	    return 0;

	hdr += LITZ("Return-Path:");
	hdr += strspn(hdr, " \t");
	i = strlen(hdr);
	while (i > 0 && (hdr[i-1] == '\r' || hdr[i-1] == '\n'))
		--i;
	if (i >= buf_len-1)
		i = buf_len-1;
	if (i <= 0)
		return 0;
	memcpy(buf, hdr, i);
	buf[i] = '\0';

	return 1;
}



u_char					/* 1=found env_From value */
parse_unix_from(const char *hdr, char *buf, int buf_len)
{
	const char *p;
	int i;

	if (strncmp(hdr, "From ", LITZ("From ")))
		return 0;

	hdr += LITZ("From ");
	hdr += strspn(hdr, " ");
	p = strchr(hdr, ' ');
	if (p == 0)
		return 0;

	i = p-hdr;
	if (i >= buf_len)
		i = buf_len-1;
	if (i <= 0)
		return 0;
	memcpy(buf, hdr, i);
	buf[i] = '\0';
	return 1;
}



u_char
parse_mail_host(const char *env_from, char *buf, int buf_len)
{
	const char *p, *p2, *p3;
	int i;

	p = strchr(env_from, '@');
	if (!p)
		return 0;
	p2 = strchr(++p, '>');
	if (!p2)
		p2 = p+strlen(p);

	/* do not try to figure out source routes */
	p3 = strpbrk(p, ";@,");
	if (p3 && p3 < p2)
		return 0;

	i = p2-p;
	if (i >= buf_len)
		i = buf_len-1;
	if (i <= 0)
		return 0;
	memcpy(buf, p, i);
	buf[i] = '\0';
	return 1;
}



void
print_cks(LOG_WRITE_FNC out, void *arg,
	  u_char is_spam, DCC_TGTS local_tgts,
	  const GOT_CKS *cks,
	  const CKSUM_THOLDS *tholds,
	  const CKS_WTGTS *wtgts)
{
	char tgts_buf[16], type_buf[26], cbuf[CK2STR_LEN];
#	define LINE_LEN 81
	char buf[LINE_LEN*6];
	const GOT_SUM *g;
	u_char have_server, have_thold, have_wlist;
	u_char headed;
	DCC_TGTS tgts;
	int cklen, buflen, inx, i;

	/* decide which column headings are needed */
	have_server = 0;
	have_thold = 0;
	have_wlist = 0;
	for (g = cks->sums, inx = 0; g <= LAST(cks->sums); ++g, ++inx) {
		if (g->type == DCC_CK_INVALID)
			continue;
		if (g->tgts != DCC_TGTS_INVALID)
			have_server = 1;
		if (wtgts && wtgts->v[inx] != 0)
			have_wlist = 1;
		if (tholds && tholds->t[g->type] != THOLD_UNSET
		    && g->type != DCC_CK_REP_TOTAL)
			have_thold = 1;
	}
	if (have_wlist)
		have_thold = 0;

	headed = 0;
	buflen = 0;
	for (g = cks->sums, inx = 0; g <= LAST(cks->sums); ++g, ++inx) {
		if (g->type == DCC_CK_INVALID)
			continue;

		if (!headed) {
			/* Print the first line including column headings
			 * for the checksums.  Never start with '\t' to
			 * ease parsing of dccproc -C output by SpamAssassin */
			headed = 1;
			tgts2str(tgts_buf, sizeof(tgts_buf)-LITZ("spam"),
				 local_tgts, 0);
			if (is_spam)
				STRLCAT(tgts_buf, " spam", sizeof(tgts_buf));
			buflen += snprintf(buf+buflen, sizeof(buf)-buflen,
					   "                            "
					   DCC_XHDR_REPORTED" %-15s checksum",
					   tgts_buf);
			if (buflen >= ISZ(buf))
				buflen = ISZ(buf)-1;

			if (have_server || have_wlist || have_thold) {
				buflen += snprintf(buf+buflen,
						   sizeof(buf)-buflen,
						   PRINT_CK_PAT_SRVR,
						   have_server ? "server" : "");
				if (buflen >= ISZ(buf))
					buflen = ISZ(buf)-1;
			}

			if (have_wlist)
				buflen += snprintf(buf+buflen,
						   sizeof(buf)-buflen,
						   PRINT_CK_PAT_WLIST,
						   "wlist");
			else if (have_thold)
				buflen += snprintf(buf+buflen,
						   sizeof(buf)-buflen,
						   PRINT_CK_PAT_THOLD,
						   "thold");
			if (buflen >= ISZ(buf))
				buflen = ISZ(buf)-1;
			if (ISZ(buf)-buflen > 1)
				buf[buflen++] = '\n';

		} else if (buflen >= ISZ(buf)-LINE_LEN) {
			out(arg, buf, buflen);
			buflen = 0;
		}

		cklen = snprintf(buf+buflen, sizeof(buf)-buflen,
				 PRINT_CK_PAT_CK,
				 type2str(type_buf, sizeof(type_buf),
					  g->type, g->hdr_nm, 0, 0),
				 ck2str(cbuf, sizeof(cbuf),
					g->type, &g->sum, 0));
		buflen += cklen;

		if (g->rpt2srvr && g->tgts != DCC_TGTS_INVALID) {
			if (buflen < ISZ(buf))
				buflen += snprintf(buf+buflen,
						   sizeof(buf)-buflen,
						   PRINT_CK_PAT_SRVR,
						   tgts2str(tgts_buf,
							sizeof(tgts_buf),
							g->tgts, 0));
		} else if ((have_wlist && wtgts->v[inx] != 0)
			   || (have_thold
			       && tholds->t[g->type]!=THOLD_UNSET)) {
			/* steal space from counts for
			 * long substitute checksums */
			i = (PRINT_CK_PAT_SRVR_LEN - (cklen - (PRINT_CK_TYPE_LEN
							+2 +PRINT_CK_SUM_LEN)));
			if (i > PRINT_CK_PAT_SRVR_LEN)
				i = PRINT_CK_PAT_SRVR_LEN;
			if (i > ISZ(buf)-buflen)
				i = ISZ(buf)-buflen;
			if (i < 0)
				i = 0;
			if (i > ISZ(buf))
				i = ISZ(buf);
			while (--i >= 0) {
				buf[buflen++] = ' ';
			}
		}

		if (buflen >= ISZ(buf)) {
			;
		} else if (have_wlist && wtgts->v[inx] != 0) {
			buflen += snprintf(buf+buflen, sizeof(buf)-buflen,
					   PRINT_CK_PAT_WLIST,
					   wtgts->v[inx] == 0
					   ? ""
					   : tgts2str(tgts_buf, sizeof(tgts_buf),
						      wtgts->v[inx], 0));
		} else if (have_thold
			   && (tgts = tholds->t[g->type]) != THOLD_UNSET) {
			buflen += snprintf(buf+buflen, sizeof(buf)-buflen,
					   PRINT_CK_PAT_THOLD,
					   thold2str(tgts_buf, sizeof(tgts_buf),
						     g->type, tgts));
		}

		if (buflen >= ISZ(buf)-1)
			buflen = sizeof(buf)-2;
		buf[buflen] = '\n';
		buf[++buflen] = '\0';
	}

	if (buflen != 0)
		out(arg, buf, buflen);

#undef LINE_LEN
}
