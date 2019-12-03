/* Distributed Checksum Clearinghouse
 *
 * decode MIME for checksums
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
 * Rhyolite Software DCC 2.3.167-1.44 $Revision$
 */

#include "dcc_ck.h"

/* Notice MIME headers */
void
ck_mime_hdr(GOT_CKS *cks,
	    const char *hdr,		/* entire header line or name only */
	    const char *str)		/* header value if not after name */
{
	/* parse at least the header name */
	cks->mhdr_st = CK_MHDR_ST_CE_CT;
	cks->mhdr_pos = 0;
	parse_mime_hdr(cks, hdr, strlen(hdr), 1);

	/* parse the header value if present and we care about the header */
	if (str
	    && cks->mhdr_st != CK_MHDR_ST_IDLE) {
		parse_mime_hdr(cks, ":", 1, 1);
		parse_mime_hdr(cks, str, strlen(str), 1);
	}

	/* force the end of the line */
	if (cks->mhdr_st != CK_MHDR_ST_IDLE)
		parse_mime_hdr(cks, "\n", 1, 1);

	if (cks->mime_nest != 0)
		cks->mp_st = CK_MP_ST_PREAMBLE;

	cks->flags |= CKS_MIME_BOL;
}



static u_char				/* 1=matched */
match(GOT_CKS *cks,
      enum CK_MHDR_ST ok, enum CK_MHDR_ST fail,
      const char *tgt_str, u_int tgt_len,
      const char **bp, u_int *bp_len)
{
	u_int len;

	len = min(tgt_len - cks->mhdr_pos, *bp_len);
	if (strncasecmp(tgt_str + cks->mhdr_pos, *bp, len)) {
		/* switch to failure state if there is enough of the
		 * string to know it does not match */
		cks->mhdr_st = fail;
		return 0;
	}

	*bp += len;
	*bp_len -= len;
	if ((u_int)(cks->mhdr_pos += len) >= tgt_len) {
		/* switch to the success state on a match */
		cks->mhdr_st = ok;
		cks->mhdr_pos = 0;
		return 1;
	}

	/* wait for more input */
	return 0;
}



/* ignore white space */
static u_char				/* 0=buffer empty */
span_ws(const char **bp, u_int *bp_len)
{
	char c;
	while ((c = **bp) == ' ' || c == '\t' || c == '\r' || c == '\n') {
		++*bp;
		if (--*bp_len == 0)
			return 0;
	}
	return 1;
}



/* skip to white space or after semicolon that precedes the next parameter */
static u_char				/* 0=buffer empty */
skip_param(const char **bp, u_int *bp_len)
{
	char c;
	while ((c = **bp) != ' ' && c != '\t' && c != '\r' && c != '\n') {
		++*bp;
		if (c == ';') {
			--*bp_len;
			return 1;
		}
		if (--*bp_len == 0)
			return 0;
	}
	return 1;
}



/* Parse MIME headers
 *	Look for (parts of) Content-Type and Content-Transfer-Encoding
 *	headers in a buffer.  There can be at most one significant (not part of
 *	folded whitespace) '\n' in the buffer and only as the last byte */
u_char					/* 1=blank line */
parse_mime_hdr(GOT_CKS *cks,
	       const char *bp, u_int bp_len,
	       u_char in_hdrs)		/* 1=in RFC 822 headers */
{
#define MMATCH(str,ok,fail) match(cks,CK_MHDR_ST_##ok,CK_MHDR_ST_##fail,    \
				  str,sizeof(str)-1, &bp, &bp_len)
	char c;
	CK_BND *bndp;

	if ((cks->flags & CKS_MIME_BOL)
	    && !in_hdrs) {
		c = *bp;
		if (c == '\r') {
			/* ignore CR to ease detecting blank line */
			if (--bp_len == 0)
				return 0;
			c = *++bp;
		}
		if (c == '\n')
			return 1;	/* this line is blank */

		/* reset parser line without folded whitespace */
		if (c != ' ' && c != '\t') {
			cks->mhdr_st = CK_MHDR_ST_CE_CT;
			cks->mhdr_pos = 0;
		}
		cks->flags &= ~CKS_MIME_BOL;
	}

	do {
		switch (cks->mhdr_st) {
		case CK_MHDR_ST_IDLE:
			return 0;

		case CK_MHDR_ST_CE_CT:
			/* This state always preceeds the following states */
			if (MMATCH("Content-T", CT_WS, IDLE)) {
				switch (*bp) {
				case 'r':
				case 'R':
					cks->mhdr_st = CK_MHDR_ST_CE;
					break;
				case 'y':
				case 'Y':
					cks->mhdr_st = CK_MHDR_ST_CT;
					break;
				default:
					cks->mhdr_st = CK_MHDR_ST_IDLE;
					return 0;
				}
			}
			break;

		case CK_MHDR_ST_CE:
			MMATCH("ransfer-Encoding:", CE_WS, IDLE);
			break;
		case CK_MHDR_ST_CE_WS:
			if (!span_ws(&bp, &bp_len))
				return 0;
			switch (*bp) {
			case 'b':
			case 'B':
				cks->mhdr_st = CK_MHDR_ST_B64;
				break;
			case 'q':
			case 'Q':
				cks->mhdr_st = CK_MHDR_ST_QP;
				break;
			default:
				cks->mhdr_st = CK_MHDR_ST_IDLE;
				return 0;
			}
			break;
		case CK_MHDR_ST_QP:
			if (MMATCH("quoted-printable", IDLE, IDLE))
				cks->mime_ce = DCC_CK_CE_QP;
			break;
		case CK_MHDR_ST_B64:
			if (MMATCH("base64", IDLE, IDLE))
				cks->mime_ce = DCC_CK_CE_B64;
			break;

		case CK_MHDR_ST_CT:
			MMATCH("ype:", CT_WS, IDLE);
			break;
		case CK_MHDR_ST_CT_WS:
			/* We have matched "Content-type:" */
			if (!span_ws(&bp, &bp_len))
				return 0;
			switch (*bp) {
			case 't':
			case 'T':
				cks->mhdr_st = CK_MHDR_ST_TEXT;
				break;
			case 'm':
			case 'M':
				/* do not nest too deeply */
				if (in_hdrs
				    || cks->mime_nest < DIM(cks->mime_bnd)) {
					cks->mhdr_st = CK_MHDR_ST_MULTIPART;
				} else {
					cks->mhdr_st = CK_MHDR_ST_TEXT;
					cks->mhdr_st = CK_MHDR_ST_IDLE;
				}
				break;
			default:
				/* assume it is binary noise if it does
				 * not match "Content-type: [tTmM]" */
				cks->mime_ct = CK_CT_BINARY;
				cks->mhdr_st = CK_MHDR_ST_IDLE;
				return 0;
			}
			break;
		case CK_MHDR_ST_TEXT:
			/* we are looking for "Text" in "Content-type: Text" */
			if (MMATCH("text", HTML, IDLE))
				cks->mime_ct = CK_CT_TEXT;
			break;
		case CK_MHDR_ST_HTML:
			/* look for "Content-type: Text/html" */
			if (MMATCH("/html", CSET_SKIP_PARAM, CSET_SKIP_PARAM))
				cks->mime_ct = CK_CT_HTML;
			break;
		case CK_MHDR_ST_CSET_SKIP_PARAM:
			/* Look for semicolon or whitespace preceding next
			 * parameter after "Content-type: Text/html" */
			if (skip_param(&bp, &bp_len))
				cks->mhdr_st = CK_MHDR_ST_CSET_SPAN_WS;
			break;
		case CK_MHDR_ST_CSET_SPAN_WS:
			/* skip optional whitespace before next parameter */
			if (span_ws(&bp, &bp_len))
				cks->mhdr_st = CK_MHDR_ST_CSET;
			break;
		case CK_MHDR_ST_CSET:
			/* have matched "Content-Type: text...;"
			 * and are looking for a "charset=" parameter */
			MMATCH("charset=", CSET_ISO_8859, CSET_SKIP_PARAM);
			break;
		case CK_MHDR_ST_CSET_ISO_8859:
			/* We have matched "Content-Type: text...charset="
			 * and are looking for "ISO-8859-*".
			 * Ignore leading '"' */
			if (cks->mhdr_pos == 0
			    && bp_len > 0 && *bp == '"') {
				++bp;
				--bp_len;
			}
			MMATCH("iso-8859-", CSET_ISO_X, IDLE);
			break;
		case CK_MHDR_ST_CSET_ISO_X:
			for (;;) {
				if (bp_len == 0)
					return 0;
				--bp_len;
				c = *bp++;
				if (c < '0' || c > '9') {
					if ((c == '"' || c == ' ' || c == '\t'
					     || c == ';'
					     || c == '\r' || c == '\n')
					    && cks->mhdr_pos == 2)
					    cks->mime_cset = c8859_2;
					else
					    cks->mime_cset = c8859_1;
					cks->mhdr_st = CK_MHDR_ST_IDLE;
					return 0;
				}
				cks->mhdr_pos = cks->mhdr_pos*10 + c - '0';
				if (cks->mhdr_pos > 99) {
					cks->mhdr_st = CK_MHDR_ST_IDLE;
					return 0;
				}
			}
		case CK_MHDR_ST_MULTIPART:
			/* We are looking for "Content-type: Multipart"
			 * after having seen "Content-type: M".
			 * If it is not "ultipart", assume "essage" and that
			 * it is text. */
			cks->mhdr_st = CK_MHDR_ST_TEXT;
			MMATCH("multipart", BND_SKIP_PARAM, IDLE);
			break;
		case CK_MHDR_ST_BND_SKIP_PARAM:
			/* Look for semicolon or whitespace preceding next
			 * parameter after "Content-type: M" */
			if (skip_param(&bp, &bp_len))
				cks->mhdr_st = CK_MHDR_ST_BND_SPAN_WS;
			break;
		case CK_MHDR_ST_BND_SPAN_WS:
			/* skip optional whitespace before next parameter */
			if (span_ws(&bp, &bp_len))
				cks->mhdr_st = CK_MHDR_ST_BND;
			break;
		case CK_MHDR_ST_BND:
			/* we have matched "Content-type: multipart"
			 * and are looking for the "boundary" parameter */
			if (MMATCH("boundary=", BND_VALUE, BND_SKIP_PARAM)) {
				if (in_hdrs) {
					cks->mime_nest = 0;
					/* allow missing initial blank line */
					cks->mime_bnd_matches = 1;
				}
				bndp = &cks->mime_bnd[cks->mime_nest];
				cks->flags &= ~CKS_MIME_QUOTED;
				bndp->bnd[0] = '-';
				bndp->bnd[1] = '-';
				cks->mhdr_pos = 2;
			}
			break;
		case CK_MHDR_ST_BND_VALUE:
			/* collect the bounary string */
			bndp = &cks->mime_bnd[cks->mime_nest];
			/* this accepts a lot more than RFC 2046 allows,
			 * but spamware written by idiots doesn't comply */
			for (;;) {
				if (bp_len == 0)
					return 0;
				--bp_len;
				c = *bp++;
				if (c == '\n')
					break;
				if (c == '\r')
					continue;
				if ((c == ' ' || c == '\t' || c == ';')
				    && !(cks->flags & CKS_MIME_QUOTED))
					break;
				if (c == '"') {
					cks->flags ^= CKS_MIME_QUOTED;
					continue;
				}
				bndp->bnd[cks->mhdr_pos] = c;
				if (++cks->mhdr_pos >= CK_BND_MAX) {
					cks->mhdr_st = CK_MHDR_ST_IDLE;
					return 0;
				}
			}
			bndp->bnd_len = cks->mhdr_pos;
			bndp->cmp_len = 0;
			++cks->mime_nest;
			cks->mhdr_st = CK_MHDR_ST_IDLE;
			break;
		}
	} while (bp_len != 0);
	return 0;

#undef MMATCH
#undef MKSIP_WS
}



/* fetch bytes and convert from quoted-printable */
u_int					/* output length */
ck_qp_decode(GOT_CKS *cks, const char **ibufp, u_int *ibuf_lenp,
	     char *obuf, u_int obuf_len)
{
#	define GC(c) do {if (!ibuf_len) return result;		\
	--ibuf_len; (c) = *ibuf; ++ibuf;} while (0)
	u_int ibuf_len, result;
	const char *ibuf;
	u_char c = 0;

	if (obuf_len == 0)
		return 0;
	ibuf_len = *ibuf_lenp;
	ibuf = *ibufp;
	result = 0;
	while (ibuf_len != 0) {
		switch (cks->qp.state) {
		case CK_QP_IDLE:
			GC(c);
			if (c != '=')
				break;
			cks->qp.state = CK_QP_EQ;
			continue;

		case CK_QP_EQ:
			/* Consider first character after '=' */
			GC(c);
			cks->qp.x = c;
			if (c == '\r') {
				;
			} else if (c == '\n') {
				/* delete "=\n" like "=\r\n"
				 * so that dccproc and dccm agree */
				cks->qp.state = CK_QP_IDLE;
				continue;
			} else if (c >= '0' && c <= '9') {
				cks->qp.n = c-'0';
			} else if (c >= 'a' && c <= 'f') {
				cks->qp.n = c-('a'-10);
			} else if (c >= 'A' && c <= 'F') {
				cks->qp.n = c-('A'-10);
			} else {
				cks->qp.state = CK_QP_FAIL1;
				c = '=';
				break;
			}
			cks->qp.state = CK_QP_1;
			continue;

		case CK_QP_1:
			/* consider second character after '=' */
			GC(c);
			cks->qp.y = c;
			if (cks->qp.x == '\r') {
				if (c == '\n') {
					/* delete soft line-break */
					cks->qp.state = CK_QP_IDLE;
					continue;
				}
				cks->qp.state = CK_QP_FAIL2;
				c = '=';
				break;
			} else if (c >= '0' && c <= '9') {
				c -= '0';
			} else if (c >= 'a' && c <= 'f') {
				c -= ('a'-10);
			} else if (c >= 'A' && c <= 'F') {
				c -= ('A'-10);
			} else {
				cks->qp.state = CK_QP_FAIL2;
				c = '=';
				break;
			}
			cks->qp.state = CK_QP_IDLE;
			c = (cks->qp.n << 4) | c;
			break;

		case CK_QP_FAIL1:
			/* output character after '=' of a 2-character
			 * sequence that was not quoted-printable after all */
			cks->qp.state = CK_QP_IDLE;
			c = cks->qp.x;
			break;

		case CK_QP_FAIL2:
			/* output character after '=' of a 3-character
			 * sequence that was not quoted-printable after all */
			cks->qp.state = CK_QP_FAIL3;
			c = cks->qp.x;
			break;

		case CK_QP_FAIL3:
			/* output third character of a 3-character
			 * sequence that was not quoted-printable after all */
			cks->qp.state = CK_QP_IDLE;
			c = cks->qp.y;
			break;
		}

		*obuf++ = c;
		if (++result >= obuf_len)
			break;
	}
	*ibuf_lenp = ibuf_len;
	*ibufp = ibuf;
	return result;
#undef GC
}




#define B64B	0100			/* bad */
#define B64EQ	0101			/* '=' */
static u_char base64_decode[128] = {
    B64B, B64B, B64B, B64B, B64B, B64B, B64B, B64B, /* 0x00 */
    B64B, B64B, B64B, B64B, B64B, B64B, B64B, B64B, /* 0x08 */
    B64B, B64B, B64B, B64B, B64B, B64B, B64B, B64B, /* 0x10 */
    B64B, B64B, B64B, B64B, B64B, B64B, B64B, B64B, /* 0x18 */

    B64B, B64B, B64B, B64B, B64B, B64B, B64B, B64B, /* 0x20   ! " # $ % & ' */
    B64B, B64B, B64B, 62,   B64B, B64B, B64B, 63,   /* 0x28 ( ) * + , - . / */

    52,	  53,	54,   55,   56,   57,   58,   59,   /* 0x30 0 1 2 3 4 5 6 7 */
    60,   61,   B64B, B64B, B64B, B64EQ,B64B, B64B, /* 0x38 8 9 : ; < = > ? */

    B64B, 0,    1,    2,    3,    4,    5,    6,    /* 0x40 @ A B C D E F G */
    7,    8,    9,    10,   11,   12,   13,   14,   /* 0x48 H I J K L M N O */

    15,   16,   17,   18,   19,   20,   21,   22,   /* 0x50 P Q R S T U V W */
    23,   24,   25,   B64B, B64B, B64B, B64B, B64B, /* 0x58 X Y Z [ \ ] ^ _ */

    B64B, 26,   27,   28,   29,   30,   31,   32,   /* 0x60 ` a b c d e f g */
    33,   34,   35,   36,   37,   38,   39,   40,   /* 0x68 h i j k l m n o */

    41,   42,   43,   44,   45,   46,   47,   48,   /* 0x70 p q r s t u v w */
    49,   50,   51,   B64B, B64B, B64B, B64B, B64B, /* 0x78 x y z { | } ~ del */
};

u_int					/* output length */
ck_b64_decode(GOT_CKS *cks, const char **ibufp, u_int *ibuf_lenp,
	      char *obuf, u_int obuf_len)
{
	u_char c;
	const char *ibuf;
	u_int ibuf_len, result;

	if (obuf_len < 3)
		return 0;
	obuf_len -= 3;
	ibuf_len = *ibuf_lenp;
	ibuf = *ibufp;
	result = 0;
	while (ibuf_len != 0) {
		--ibuf_len;
		c = *ibuf++;
		c = base64_decode[c];
		if (c == B64B)
			continue;

		if (c == B64EQ) {
			switch (cks->b64.quantum_cnt) {
			case 2:
				*obuf++ = cks->b64.quantum>>4;
				++result;
				break;
			case 3:
				*obuf++ = cks->b64.quantum>>10;
				*obuf++ = cks->b64.quantum>>2;
				result += 2;
				break;
			}
			cks->b64.quantum_cnt = 0;
			if (result >= obuf_len)
				break;
		}

		cks->b64.quantum = (cks->b64.quantum << 6) | c;
		if (++cks->b64.quantum_cnt >= 4) {
			cks->b64.quantum_cnt = 0;
			*obuf++ = cks->b64.quantum>>16;
			*obuf++ = cks->b64.quantum>>8;
			*obuf++ = cks->b64.quantum;
			result += 3;
			if (result >= obuf_len)
				break;
		}
	}
	*ibuf_lenp = ibuf_len;
	*ibufp = ibuf;
	return result;
}
