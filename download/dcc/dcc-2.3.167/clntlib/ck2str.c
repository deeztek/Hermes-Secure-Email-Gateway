/* Distributed Checksum Clearinghouse
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
 * Rhyolite Software DCC 2.3.167-1.32 $Revision$
 */

#include "dcc_defs.h"

char *
ck2str(char *buf, u_int buf_len,
       DCC_CK_TYPES type, const DCC_SUM *sum, u_int32_t extra)
{
	u_int32_t n[sizeof(DCC_SUM)+3/4];
	u_char c;
	char *p;
	const char *type_str;
	char type_buf[32];
	int i;

	if (buf_len <= 1) {
		if (buf_len >= 1)
			buf[0] = '\0';
		return buf;
	}

	/* checksums other than server-ID declarations are easy */
	if (type != DCC_CK_SRVR_ID) {
		/* word-align the checksum--short but slow */
		memcpy(n, sum->b, sizeof(n));
		snprintf(buf, buf_len, "%08x %08x %08x %08x",
			 (int)ntohl(n[0]), (int)ntohl(n[1]),
			 (int)ntohl(n[2]), (int)ntohl(n[3]));
		return buf;
	}

	/* decode server sanity declarations */
	if (sum->b[0] == DCC_CK_SRVR_ID) {
		if (extra == 0)
			type_str = "server";
		else
			type_str = id2str(type_buf, sizeof(type_buf), extra);
		snprintf(buf, buf_len, "%s at %d",
			 type_str, DCC_ID_SRVR_TYPE_ID(sum));
		return buf;
	}

	/* Decode the string from server-ID assertions. */
	p = buf;
	*p++ = '"';
	--buf_len;
	for (i = 0; i < ISZ(DCC_SUM); ++i) {
		if (buf_len <= 1)
			break;
		c = sum->b[i];
		if (c == '\0')
			break;
		if (c >= ' ' && c < 0x7f) {
			/* simple ASCII is easy */
			*p++ = c;
			--buf_len;
			continue;
		}

		/* convert non-ASCII to an escape sequence */
		*p++ = '\\';
		if (--buf_len <= 1)
			break;
		*p++ = '0'+(c>>6);
		if (--buf_len <= 1)
			break;
		*p++ = '0'+((c>>3) & 7);
		if (--buf_len <= 1)
			break;
		*p++ = '0'+(c & 7);
		--buf_len;
	}
	if (buf_len > 1) {
		*p++ = '"';
		--buf_len;
	}
	if (buf_len != 0)
		*p = '\0';
	return buf;
}



/* this is not thread safe */
const char *
ck2str_err(DCC_CK_TYPES type, const DCC_SUM *sum, u_int32_t extra)
{
	static char ck_buf[CK2STR_LEN];

	return ck2str(ck_buf, sizeof(ck_buf), type, sum, extra);
}



/* compute ratio bulk to total mail
 *	the caller must check the total for sanity */
u_int
get_reputation(DCC_TGTS bulk, DCC_TGTS total)
{
	/* Flooding and other noise can make the reputation total less
	 * than the bulk count. */
	if (bulk >= total)
		return (total == 0) ? 0 : DCC_REP_TGTS_SCALE;

	/* avoid overflow */
	if (bulk >= (DCC_TGTS_TOO_MANY / DCC_REP_TGTS_SCALE)) {
		total = (total + DCC_REP_TGTS_SCALE-1) / DCC_REP_TGTS_SCALE;
	} else {
		bulk *= DCC_REP_TGTS_SCALE;
	}
	return bulk / total;
}
