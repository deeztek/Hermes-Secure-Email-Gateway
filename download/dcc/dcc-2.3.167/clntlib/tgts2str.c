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
 * Rhyolite Software DCC 2.3.167-1.26 $Revision$
 */

#include "dcc_ck.h"
#include "dcc_xhdr.h"


char *
tgts2str(char *buf, u_int buf_len, DCC_TGTS tgts, u_char grey)
{
	switch (tgts) {
	case DCC_TGTS_TOO_MANY:
		if (grey)
			STRLCPY(buf, DCC_XHDR_GREY_PASS, buf_len);
		else
			STRLCPY(buf, DCC_XHDR_TOO_MANY, buf_len);
		break;
	case DCC_TGTS_OK:
		STRLCPY(buf, DCC_XHDR_OK, buf_len);
		break;
	case DCC_TGTS_OK2:
		if (grey)		/* DCC_TGTS_GREY_WHITE */
			STRLCPY(buf, DCC_XHDR_OK, buf_len);
		else
			STRLCPY(buf, DCC_XHDR_OK2, buf_len);
		break;
	case DCC_TGTS_DEL:
		STRLCPY(buf, DCC_XHDR_DEL, buf_len);
		break;
	case DCC_TGTS_REP_ADJ:
		STRLCPY(buf, DCC_XHDR_TGTS_REP_ADJ, buf_len);
		break;
	case DCC_TGTS_OK_MX:
		STRLCPY(buf, DCC_XHDR_OK_MX, buf_len);
		break;
	case DCC_TGTS_OK_MXDCC:
		STRLCPY(buf, DCC_XHDR_OK_MXDCC, buf_len);
		break;
	case DCC_TGTS_SUBMIT_CLIENT:
		STRLCPY(buf, DCC_XHDR_SUBMIT_CLIENT, buf_len);
		break;
	case DCC_TGTS_INVALID:
		STRLCPY(buf, DCC_XHDR_INVALID, buf_len);
		break;
	default:
		if (tgts & DCC_TGTS_SPAM)
			snprintf(buf, buf_len, "%d spam",
				 tgts & ~DCC_TGTS_SPAM);
		else
			snprintf(buf, buf_len, "%d",
				 tgts);
		break;
	}

	return buf;
}



char *
thold2str(char *buf, u_int buf_len, DCC_CK_TYPES type, DCC_TGTS tgts)
{
	if (tgts == THOLD_NEVER) {
		STRLCPY(buf, DCC_XHDR_THOLD_NEVER, buf_len);
		return buf;
	}

	if (type == DCC_CK_REP_BULK) {
		snprintf(buf, buf_len, "%u%%", tgts);
		return buf;
	}

	return tgts2str(buf, buf_len, tgts, 0);
}
