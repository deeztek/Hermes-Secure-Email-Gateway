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
 * Rhyolite Software DCC 2.3.167-1.25 $Revision$
 */

#include "dcc_defs.h"
#include "dcc_xhdr.h"

char *
type2str(char *buf, u_int buf_len,	/* put it here */
	 DCC_CK_TYPES type,		/* this type */
	 const char *sub_str,		/* sub-type for DCC_CK_SUB */
	 u_char is_db,			/* 0=whitelist 1=database */
	 u_char is_grey_db)		/* 1=greylist DB */
{
#define PCK(t) case DCC_CK_##t:					\
	STRLCPY(buf,DCC_XHDR_TYPE_##t,buf_len);			\
	return buf;
#define PCK2(c,sw,t1,t2) case DCC_CK_##c:			\
	if (!sw)						\
		STRLCPY(buf,DCC_XHDR_TYPE_##t1,buf_len);	\
	else							\
		STRLCPY(buf,DCC_XHDR_TYPE_##t2,buf_len);	\
	return buf;

	switch (type) {
	PCK(IP)
	PCK(ENV_FROM)
	PCK(FROM)
	PCK(MESSAGE_ID)
	PCK(RECEIVED)
	PCK(BODY)
	PCK(FUZ1)
	PCK(FUZ2)
	PCK2(G_MSG_R_TOTAL, is_grey_db, REP_TOTAL, GREY_MSG)
	PCK2(G_TRIPLE_R_BULK, is_grey_db, REP_BULK, GREY_TRIPLE)
	PCK(SRVR_ID)
	PCK2(FLOD_PATH, is_db, ENV_TO, FLOD_PATH)
	case DCC_CK_SUB:
		if (sub_str)
			snprintf(buf, buf_len, DCC_XHDR_TYPE_SUB" %s",
				 sub_str);
		else
			snprintf(buf, buf_len, DCC_XHDR_TYPE_SUB);
		return buf;
	case DCC_CK_INVALID:
		break;
	}

	snprintf(buf, buf_len, DCC_XHDR_TYPE_UNKNOWN, type);
	return buf;
#undef PCK
#undef PCK2
}



/* use sparingly for error messages since it is not thread safe */
const char *
type2str_err(DCC_CK_TYPES type,		/* type to convert to a string */
	     const char *sub_str,	/* sub-type for DCC_CK_SUB */
	     u_char is_db,		/* 0=whitelist 1=database */
	     u_char is_grey_db)		/* 1=greylist DB */
{
	static int bufno;
	static struct {
	    char    str[DCC_XHDR_MAX_TYPE_LEN_BUF];
	} bufs[4];
	char *s;

	s = bufs[bufno].str;
	bufno = (bufno+1) % DIM(bufs);

	return type2str(s, sizeof(bufs[0].str),
			type, sub_str, is_db, is_grey_db);
}
