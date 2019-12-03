/* Distributed Checksum Clearinghouse
 *
 * parse a named checksum
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
 * Rhyolite Software DCC 2.3.167-1.80 $Revision$
 */

#include "dcc_ck.h"
#include "dcc_xhdr.h"
#ifndef DCC_WIN32
#include <arpa/inet.h>
#endif

static int				/* -1=fatal 0=problem */
dcc_host2ck(DCC_EMSG *emsg, WF *wf,
	    const char *ck,		/* string of an IP address */
	    DCC_TGTS tgts,		/* OK, MANY, etc. */
	    DCC_PARSED_CK_FNC fnc,	/* do something with each checksum */
	    DCC_PARSED_CK_RANGE_FNC range_fnc)
{
	int error;
	DCC_FNM_LNO_BUF fnm_buf;
	DCC_IP_RANGE range;
	DCC_SUM sum;
	DCC_SOCKU *sup;
	int ok;

	ok = str2range(emsg, &range, 0, ck, wf_fnm(wf, wf->fno), wf->lno);
	if (ok < 0)
		return 0;		/* bad range */

	if (ok > 0)			/* valid IP address range */
		return range_fnc(emsg, wf, &range, tgts);

	/* we have junk
	 * or a host name which is not allowed in a per-user whitelist */
	if (wf->wf_flags & WF_PER_USER) {
		dcc_pemsg(EX_NOHOST, emsg,
			  "host name checksum illegal in per-user whitelist%s",
			  wf_fnm_lno(&fnm_buf, wf));
		return 0;
	}

	if (wf->wtbl)			/* need future host name resolutions */
		wf->wtbl->hdr.fgs |= WHITE_FG_HOSTNAMES;

	dcc_host_lock();
	/* don't use SOCKS host name resolution because the host names that
	 * most need whitelisting are inside the SOCKS firewall and may not
	 * be known to outside DNS servers. */
	if (!dcc_get_host(ck, DCC_GETH_DEF, &error)) {
		dcc_pemsg(EX_NOHOST, emsg, "host name \"%s\": %s%s",
			  ck, H_ERROR_STR1(error), wf_fnm_lno(&fnm_buf, wf));
		dcc_host_unlock();
		return 0;
	}

	for (sup = dcc_hostaddrs; sup < dcc_hostaddrs_end; ++sup) {
		struct in6_addr addr6;

		ipv6tock(&sum, dcc_su2ipv6(&addr6, 0, sup));
		ok = fnc(emsg, wf, DCC_CK_IP, &sum, tgts);
		if (ok <= 0) {
			dcc_host_unlock();
			return ok;
		}
	}
	dcc_host_unlock();
	return 1;
}



/* generate checksum value from the name of the checksum and a string */
int					/* 1=ok 0=problem -1=fatal */
dcc_parse_ck(DCC_EMSG *emsg,		/* failure message here */
	     WF *wf,
	     const char *type_nm,
	     DCC_CK_TYPES type,
	     const char *str,		/* ASCII string to generate checksum */
	     DCC_TGTS tgts,		/* # of targets */
	     DCC_PARSED_CK_FNC add_fnc,	/* do something with the checksum */
	     DCC_PARSED_CK_RANGE_FNC range_fnc)
{
	DCC_FNM_LNO_BUF fnm_buf;
	char *phdr, c, hdr_buf[80];
	DCC_SUM sum;
	const char *pstr;

	/* compute the checksum */
	switch (type) {
	case DCC_CK_IP:
		return dcc_host2ck(emsg, wf, str, tgts, add_fnc, range_fnc);

	case DCC_CK_ENV_FROM:
	case DCC_CK_FROM:
	case DCC_CK_MESSAGE_ID:
	case DCC_CK_RECEIVED:
	case DCC_CK_ENV_TO:
		str2ck(&sum, 0, 0, str);
		return add_fnc(emsg, wf, type, &sum, tgts);

	case DCC_CK_SUB:
		str += strspn(str, DCC_WHITESPACE);
		pstr = str;
		phdr = hdr_buf;
		for (;;) {
			c = *pstr++;
			if (c == '\0' || c == ':'
			    || DCC_IS_WHITE(c))
				break;
			c = DCC_TO_LOWER(c);
			*phdr++ = c;
			if (phdr >= &hdr_buf[sizeof(hdr_buf)]) {
				dcc_pemsg(EX_DATAERR, emsg,
					  " imposible substitute header name"
					  " in \"%s\"%s",
					  str, wf_fnm_lno(&fnm_buf, wf));
				return 0;
			}
		}
		pstr += strspn(pstr, DCC_WHITESPACE);
		if (*pstr == '\0' || phdr == hdr_buf) {
			dcc_pemsg(EX_DATAERR, emsg,
				  " substitute header name absent in \"%s\"%s",
				  str, wf_fnm_lno(&fnm_buf, wf));
			return 0;
		}
		str2ck(&sum, hdr_buf, phdr-hdr_buf, pstr);
		return add_fnc(emsg, wf, type, &sum, tgts);

	case DCC_CK_INVALID:
	case DCC_CK_BODY:
	case DCC_CK_FUZ1:
	case DCC_CK_FUZ2:
	case DCC_CK_G_MSG_R_TOTAL:
	case DCC_CK_G_TRIPLE_R_BULK:
	case DCC_CK_SRVR_ID:
		break;
	}

	dcc_pemsg(EX_DATAERR, emsg, "unrecognized checksum type \"%s\"%s",
		  type_nm, wf_fnm_lno(&fnm_buf, wf));
	return 0;
}



/* generate checksum value from the name of the checksum and hex values */
int					/* 1=ok 0=syntax -1=fatal */
dcc_parse_hex_ck(DCC_EMSG *emsg,	/* failure message here */
		 WF *wf,
		 const char *type_nm,
		 DCC_CK_TYPES type,
		 const char *str,	/* ASCII string to generate checksum */
		 DCC_TGTS tgts,		/* # of targets */
		 DCC_PARSED_CK_FNC add_fnc) /* do something with the checksum */
{
	union {
	    u_int32_t n[4];
	    DCC_SUM sum;
	} u;
	DCC_FNM_LNO_BUF fnm_buf;
	int id;

	if (type == DCC_CK_INVALID) {
		dcc_pemsg(EX_DATAERR, emsg,
			  "unrecognized checksum type \"%s\"%s",
			  type_nm, wf_fnm_lno(&fnm_buf, wf));
		return 0;
	}

	if (4 == sscanf(str, DCC_CKSUM_HEX_PAT"\n",
			&u.n[0], &u.n[1], &u.n[2], &u.n[3])
	    || (type == DCC_CK_SUB
		&& 4 == sscanf(str, "%*s "DCC_CKSUM_HEX_PAT"\n",
			       &u.n[0], &u.n[1], &u.n[2], &u.n[3]))) {
		/* recognize simple hex checksums */
		u.n[0] = htonl(u.n[0]);
		u.n[1] = htonl(u.n[1]);
		u.n[2] = htonl(u.n[2]);
		u.n[3] = htonl(u.n[3]);

	} else if (1 == sscanf(str, DCC_XHDR_ID_SIMPLE" at %d", &id)
		   || 1 == sscanf(str, DCC_XHDR_ID_IGNORE" at %d", &id)
		   || 1 == sscanf(str, DCC_XHDR_ID_ROGUE" at %d", &id)) {
		/* parse server-ID declarations */
		DCC_ID_SRVR_TYPE_SET(&u.sum, id);

	} else {
		dcc_pemsg(EX_DATAERR, emsg,
			  "unrecognized checksum value \"%s\"%s",
			  str, wf_fnm_lno(&fnm_buf, wf));
		return 0;
	}

	/* apply the function to the checksum */
	return add_fnc(emsg, wf, type, &u.sum, tgts);
}
