/* Copyright (C) 1991-2, RSA Data Security, Inc. Created 1991. All
 * rights reserved.
 *
 * License to copy and use this software is granted provided that it
 * is identified as the "RSA Data Security, Inc. MD5 Message-Digest
 * Algorithm" in all material mentioning or referencing this software
 * or this function.
 *
 * License is also granted to make and use derivative works provided
 * that such works are identified as "derived from the RSA Data
 * Security, Inc. MD5 Message-Digest Algorithm" in all material
 * mentioning or referencing the derived work.
 *
 * RSA Data Security, Inc. makes no representations concerning either
 * the merchantability of this software or the suitability of this
 * software for any particular purpose. It is provided "as is"
 * without express or implied warranty of any kind.
 *
 * These notices must be retained in any copies of any part of this
 * documentation and/or software.
 */

/*  Rhyolite Software DCC 2.3.167-1.4 $Revision$ */

#ifndef DCC_MD5_H
#define DCC_MD5_H

#define MD5_DIGEST_LEN 16
typedef u_char MD5_DIGEST[MD5_DIGEST_LEN];

typedef struct {
    u_int32_t state[4];			/* state (ABCD) */
    u_int32_t count[2];			/* # of bits, modulo 2^64 (LSB 1st) */
    unsigned char buffer[64];		/* input buffer */
} DCC_MD5_CTX;

extern void DCC_MD5Init(DCC_MD5_CTX *);
extern void DCC_MD5Update(DCC_MD5_CTX *, const void *, u_int);
extern void DCC_MD5Final(u_char[16], DCC_MD5_CTX *);


#ifdef HAVE_MD5
#include <md5.h>
#else
#define MD5_CTX DCC_MD5_CTX
#define MD5Init DCC_MD5Init
#define MD5Update DCC_MD5Update
#define MD5Final DCC_MD5Final
#endif


#endif	/* DCC_MD5_H */
