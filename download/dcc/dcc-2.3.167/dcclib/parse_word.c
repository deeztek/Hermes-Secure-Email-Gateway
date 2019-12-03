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
 * Rhyolite Software DCC 2.3.167-1.29 $Revision$
 */

#include "dcc_defs.h"


/* Get a "word" ended by whitespace, while honoring backslashes
 *	on exit the remainder of the line is trimmed of leading whitespace.
 *	fail if the word is missing or too long. */
const char *				/* 0 or remainder of line */
dcc_parse_word(DCC_EMSG *emsg,
	       char *tgt,		/* copy word to here if not null */
	       int tgt_len,		/* includes trailing '\0' */
	       const char *line,	/* line of words */
	       const char *fieldname,
	       const char *fnm, int lno)
{
	DCC_FNM_LNO_BUF fnm_buf;
	const char *p;
	char c;

	if (!tgt_len && tgt)
		dcc_logbad(EX_SOFTWARE, "bad tgt_len for dcc_parse_word(%s)%s",
			   fieldname, dcc_fnm_lno(&fnm_buf, fnm, lno));

	if (!line) {
		if (tgt)
			*tgt = '\0';
		if (fieldname)
			dcc_pemsg(EX_USAGE, emsg, "%s missing%s",
				  fieldname, dcc_fnm_lno(&fnm_buf, fnm, lno));
		return 0;
	}

	line = line+strspn(line, DCC_WHITESPACE);   /* skip leading blanks */

	p = line;
	do {
		c = *p;

		if (c != '\0') {
			++p;
			if (c == '\\' && *p != '\0') {
				/* recognize and convert escape sequences to
				 * their real equivalents */
				if ((c = *p++) == 'n') {
					c = '\n';
				} else if (c == 'r') {
					c = '\r';
				} else if (c == 't') {
					c = '\t';
				} else if (c == 'b') {
					c = '\b';
				} else if (c >= '0' && c <= '7') {
					c -= '0';
					if (*p >= '0' && *p <= '7') {
					    c = (c<<3)+(*p++ - '0');
					    if (*p >= '0' && *p <= '7')
						c = (c<<3)+(*p++ - '0');
					}
				}
			} else if (strchr(DCC_WHITESPACE, c)) {
				/* Stop on the first whitespace or delimiter */
				c = '\0';
				/* Skip trailing whitespace */
				p += strspn(p, DCC_WHITESPACE);
			}
		}

		if (tgt) {
			if (!tgt_len) {
				if (fieldname || fnm)
					dcc_pemsg(EX_USAGE, emsg,
						  "%s \"%.*s...\" too long%s",
						  fieldname ? fieldname : "",
						  min(16, (int)(p-line)), line,
						  dcc_fnm_lno(&fnm_buf,
							fnm, lno));
				return 0;
			}
			*tgt++ = c;
			--tgt_len;
		}
	} while (c != '\0');

	return p;
}
