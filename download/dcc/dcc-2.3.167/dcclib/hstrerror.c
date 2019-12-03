/* compatibility hack for old systems that don't have hstrerror()
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
 * Rhyolite Software DCC 2.3.167-1.6 $Revision$
 */

#include "dcc_defs.h"

#include <stdio.h>

static const char *h_errlist[] = {
	"Resolver Error 0 (no error)",
	"Unknown host",			/* 1 HOST_NOT_FOUND */
	"Host name lookup failure",	/* 2 TRY_AGAIN */
	"Unknown server error",		/* 3 NO_RECOVERY */
	"No address associated with name",  /* 4 NO_ADDRESS */
};
#define H_NERR ((int)(sizeof(h_errlist)/sizeof( h_errlist[0])))

const char *
dcc_hstrerror(int err)
{
    static char buf[64];

    if (err < 0 || err > H_NERR || h_errlist[err] == NULL) {
	snprintf(buf, sizeof(buf), "host name error %d", err);
	return buf;
    }
    return h_errlist[err];
}
