/* Distributed Checksum Clearinghouse
 *
 * build and parse headers
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
 * Rhyolite Software DCC 2.3.167-1.43 $Revision$
 */

#include "dcc_clnt.h"
#include "dcc_xhdr.h"


/* add text to the growing X-DCC header line */
void
xhdr_add_str(DCC_HEADER_BUF *hdr, const char *p, ...)
{
	char *hp;
	u_int lim, n;
	va_list args;

	lim = sizeof(hdr->buf) - hdr->used;
	if (lim <= 0)
		return;
	hp = &hdr->buf[hdr->used];
	if (*(hp-1) == '\n') {
		*(hp-1) = ' ';
		++hdr->col;
	}
	va_start(args, p);
	n = vsnprintf(hp, lim, p, args);
	va_end(args);
	if (n >= lim-3) {
		dcc_error_msg("header buffer too small");
		hdr->buf[lim-1] = '\n';
		hdr->used = sizeof(hdr->buf);
		return;
	}
	hdr->col += n;
	hp[n++] = '\n';
	hp[n] = '\0';
	hdr->used += n;

	/* Follow RFC 2822 and limit lines to 78.
	 * Help SpamAssassin and others by using a single \t for
	 * folded whitespace. */
	if (hdr->col > DCC_MAX_HDR_LINE	/* if pushed past line end, */
	    && *(hp-1) == ' '		/* & not the first cksum report, */
	    && hdr->used < sizeof(hdr->buf)-2) {    /* & have space */
		memmove(hp+1, hp, n+1);	/* then break the line */
		*(hp-1) = '\n';
		*hp = '\t';
		hdr->col = n+8;
		++hdr->used;
	}
}



/* generate X-DCC field name */
int					/* bytes put into buffer */
get_xhdr_fname(char *xhdr, int xhdr_len, const DCC_CLNT_INFO *info)
{
	SRVR_INX srvr_inx;
	const char *brand;
	int i;

	if (!info
	    || (srvr_inx = info->dcc.srvr_inx,
		!VALID_SRVR(&info->dcc, srvr_inx))) {
		brand = "";
		i = 0;
	} else {
		brand = info->dcc.addrs[srvr_inx].brand;
		i = xhdr_len-sizeof(DCC_XHDR_START);
		if (i < 0)
			i = 0;
		if (i > ISZ(DCC_BRAND))
			i = ISZ(DCC_BRAND);
	}

	i = snprintf(xhdr, xhdr_len, DCC_XHDR_PAT, i, brand);
	if (i >= xhdr_len)
		i = xhdr_len-1;
	return i;
}



/* get ready to generate an X-DCC header including generating the
 * field name */
void
xhdr_init(DCC_HEADER_BUF *hdr, DCC_SRVR_ID srvr_id)
{
	if (!DCC_ID_SRVR_NORMAL(srvr_id)) {
		hdr->used = get_xhdr_fname(hdr->buf, sizeof(hdr->buf)-8,
					   0);
	} else {
		hdr->used = get_xhdr_fname(hdr->buf, sizeof(hdr->buf)-8,
					   dcc_clnt_info);
	}
	hdr->col = hdr->used;
	hdr->start_len = hdr->used;

	xhdr_add_str(hdr, ": %s %d;", dcc_clnt_hostname, srvr_id);
}



/* add a checksum and its counts to a growing X-DCC-Warning header line */
void
xhdr_add_ck(DCC_HEADER_BUF *hdr,
	    DCC_CK_TYPES type,		/* which kind of checksum */
	    DCC_TGTS tgts)
{
	char tbuf[30], ckcnt[10];

	if (type == DCC_CK_G_TRIPLE_R_BULK
	    && tgts < DCC_TGTS_TOO_MANY) {
		xhdr_add_str(hdr, "%s=%d%%",
			     type2str(tbuf, sizeof(tbuf), type, 0, 0, 0),
			     tgts-1);
		return;
	}

	xhdr_add_str(hdr, "%s=%s",
		     type2str(tbuf, sizeof(tbuf), type, 0, 0, 0),
		     tgts2str(ckcnt, sizeof(ckcnt), tgts, 0));
}



/* write header with lines ending with either "\n" or "\r\n"
 *	the buffer must already contain '\n' as needed */
void
xhdr_write(LOG_WRITE_FNC fnc, void *wctxt,
	   const char *hdr, int hdr_len,
	   u_char crlf)			/* 1=use "\r\n" instead of "\n" */
{
	char c;
	int i;

	if (hdr_len == 0)
		return;

	i = 0;
	for (;;) {
		c = hdr[i];
		if (c == '\n' && crlf) {
			if (i != 0)
				fnc(wctxt, hdr, i);
			fnc(wctxt, "\r\n", 2);
			++i;
			hdr += i;
			hdr_len -= i;
			if (hdr_len <= 0)
				return;
			i = 0;
			continue;
		}
		if (++i >= hdr_len) {
			fnc(wctxt, hdr, i);
			return;
		}
	}
}



/* create a special X-DCC header for a whitelist mail message
 *	it lacks a DCC server-ID because there is none and to let
 *	DCC clients distinguish it from real X-DCC headers */
void
xhdr_whitelist(DCC_HEADER_BUF *hdr)
{
	hdr->col = 0;
	hdr->start_len = 0;
	hdr->used = 0;
	xhdr_add_str(hdr, DCC_XHDR_START DCC_XHDR_END": %s; "DCC_XHDR_WHITELIST,
		     dcc_clnt_hostname);
}



/* see if an X-DCC header looks like one of our own and so should
 * be deleted */
u_char					/* 1=is an X-DCC-...-metrics header */
is_xhdr(const char *buf,		/* complete header */
	int buf_len)
{
	const char *e;

	if (buf[0] != 'X' && buf[0] != 'x')
		return 0;
	if (buf_len <= LITZ(DCC_XHDR_START DCC_XHDR_END":")
	    || CLITCMP(buf, DCC_XHDR_START))
		return 0;

	buf += LITZ(DCC_XHDR_START);
	buf_len -= LITZ(DCC_XHDR_START);

	/* look for the end of header field name */
	e = memchr(buf, ':', buf_len);
	if (e) {
		buf_len = e - buf;
		if (buf_len < LITZ(DCC_XHDR_END))
			return 0;
	}

	buf_len -= LITZ(DCC_XHDR_END);
	buf += buf_len;
	if (!CLITCMP(buf, DCC_XHDR_END))
		return 1;

	return 0;
}
