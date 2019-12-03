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
 *
 * Rhyolite Software DCC 2.3.167-1.15 $Revision$
 */

#include "dcc_defs.h"
#include "dcc_xhdr.h"


DCC_TGTS
dcc_str2cnt(const char *str)
{
	u_long l;
	char *p;

	l = strtoul(str, &p, 0);
	if (*p == '\0') {
		if (l > DCC_TGTS_TOO_MANY)
			l = DCC_TGTS_TOO_MANY;
		return l;
	}
	if (!strcasecmp(str, DCC_XHDR_TOO_MANY))
		return DCC_TGTS_TOO_MANY;
	if (!strcasecmp(str, DCC_XHDR_OK))
		return DCC_TGTS_OK;
	if (!strcasecmp(str, DCC_XHDR_OK2))
		return DCC_TGTS_OK2;
	if (!strcasecmp(str, DCC_XHDR_OK_MX))
		return DCC_TGTS_OK_MX;
	if (!strcasecmp(str, DCC_XHDR_OK_MXDCC))
		return DCC_TGTS_OK_MXDCC;
	if (!strcasecmp(str, DCC_XHDR_SUBMIT_CLIENT))
		return DCC_TGTS_SUBMIT_CLIENT;
	return DCC_TGTS_INVALID;
}
