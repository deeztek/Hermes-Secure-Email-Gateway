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
 * Rhyolite Software DCC 2.3.167-1.2 $Revision$
 */

#include "dcc_defs.h"


/* get a password */
const char *				/* 0 or remainder of line */
parse_passwd(DCC_EMSG *emsg,
	     DCC_PASSWD passwd,		/* copy password here */
	     const char *line,		/* line of words */
	     const char *fieldname,
	     const char *fnm, int lno)
{
	char buf[sizeof(DCC_PASSWD)+1];
	const char *result;

	memset(buf, 0, sizeof(buf));
	result = dcc_parse_word(emsg, buf, sizeof(buf),
				line, fieldname, fnm, lno);
	if (result)
		memcpy(passwd, buf, sizeof(DCC_PASSWD));
	else
		memset(passwd, 0, sizeof(DCC_PASSWD));
	return result;
}



/* see if a string starts with a word possibly followed by a comma */
u_char					/* 1=yes */
ck_word_comma(const char **parg, const char *word)
{
	u_int word_len = strlen(word);
	const char *arg = *parg;

	if (strncasecmp(arg, word, word_len))
		return 0;
	arg += word_len;
	if (*arg == '\0') {
		*parg = arg;
		return 1;
	}
	if (*arg == ',') {
		*parg = arg+1;
		return 1;
	}
	return 0;
}
