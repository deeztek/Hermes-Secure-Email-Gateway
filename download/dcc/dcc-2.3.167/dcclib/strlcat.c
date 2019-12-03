/* compatibility hack
 *
 * Rhyolite Software DCC 2.3.167-1.4 $Revision$
 */

#include "dcc_defs.h"

size_t
dcc_strlcat(char *dst, const char *src, int dsize)
{
	int dlen, slen, clen;

	slen = strlen(src);
	if (--dsize < 0)
		return slen;

	dlen = strlen(dst);
	if (dlen >= dsize)
		dlen = dsize;

	clen = dsize - dlen;
	if (clen > slen)
		clen = slen;
	if (clen > 0) {
		memcpy(&dst[dlen], src, clen);
		dst[dlen+clen] = '\0';
	}

	return dlen+slen;
}
