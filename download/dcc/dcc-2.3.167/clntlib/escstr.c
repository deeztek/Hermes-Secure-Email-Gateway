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
 * Rhyolite Software DCC 2.3.167-1.3 $Revision$
 */

#include "dcc_defs.h"


char *
escstr(char *buf0, int buf_len, const char *src, int src_len)
{
	char *buf, *buf_end;
	u_char ascii;
	u_char c;

	if (buf_len < 4)
		dcc_logbad(EX_SOFTWARE, "bad escstr() buffer");

	ascii = 1;
	buf = buf0;
	buf_end = buf+buf_len-4;
	while (--src_len >= 0) {
		c = *src++;
		if (buf >= buf_end) {
			strcpy(buf, "...");
			return buf0;
		}
		if (c >= ' ' && c <= 0x7f) {
			if (c == '\\' || c == '"')
				*buf++ = '\\';
			*buf++ = c;
			continue;
		}
		if (ascii && c == '\0' && !memcmp(src, src-1, src_len))
			break;
		buf += sprintf(buf, "\\%03o", c);
		ascii = 0;
	}
	*buf = '\0';
	return buf0;
}



/* not thread safe */
const char *
esc_magic(const char *src, int src_len)
{
	static char magic_buf[256];

	return escstr(magic_buf, sizeof(magic_buf), src, src_len);
}
