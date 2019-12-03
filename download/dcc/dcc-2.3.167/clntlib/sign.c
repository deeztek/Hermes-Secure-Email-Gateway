/* Distributed Checksum Clearinghouse
 *
 * message authentication
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
 * Rhyolite Software DCC 2.3.167-1.14 $Revision$
 */

#include "dcc_defs.h"
#include "dcc_md5.h"
#include <string.h>


/* sign a DCC packet */
void
dcc_sign(const void *passwd,
	 int passwd_len,
	 void *pkt,
	 u_int pkt_len)			/* including signature */
{
	MD5_CTX ctx;

	MD5Init(&ctx);
	MD5Update(&ctx, passwd, passwd_len);
	MD5Update(&ctx, pkt, pkt_len-sizeof(DCC_SIGNATURE));
	MD5Final(&((u_char*)pkt)[pkt_len-sizeof(DCC_SIGNATURE)], &ctx);
}



/* check the signature of a DCC packet */
u_char					/* 0=forgery, 1=good signature */
dcc_ck_signature(const void *passwd,
		 int passwd_len,
		 const void *pkt,
		 u_int pkt_len)		/* including signature */
{
	MD5_CTX ctx;
	DCC_SIGNATURE signature;

	MD5Init(&ctx);
	MD5Update(&ctx, passwd, passwd_len);
	MD5Update(&ctx, pkt, pkt_len-sizeof(DCC_SIGNATURE));
	MD5Final(signature, &ctx);
	return !memcmp(signature, &((char*)pkt)[pkt_len-sizeof(DCC_SIGNATURE)],
		       sizeof(signature));
}
