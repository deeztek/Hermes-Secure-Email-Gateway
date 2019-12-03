/* Distributed Checksum Clearinghouse
 *
 * compute simple body checksum
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
 * Rhyolite Software DCC 2.3.167-1.62 $Revision$
 */

#include "dcc_ck.h"


static void
ck_body0(GOT_CKS *cks, const char *bp, u_int bp_len)
{
#	define BUF_LEN 1024
	char buf[BUF_LEN+5];
	u_char flen;
	int blen;
	char c;

	if (cks->sums[DCC_CK_BODY].type != DCC_CK_BODY)
		return;

	flen = cks->ctx_body.flen;
	blen = 0;
	for (;;) {
		if (bp_len == 0) {
			if (blen != 0) {
				cks->ctx_body.total += blen;
				MD5Update(&cks->ctx_body.md5,
					  (void *)buf, blen);
			}
			cks->ctx_body.flen = flen;
			return;
		}
		--bp_len;
		c = *bp++;

		/* Ignore the '>' in the sequence "\n>From" because
		 * it is sometimes added for old UNIX MUAs.
		 * As a side effect, ignore '\n' */
		if (flen != 0) {
			if (c == "\n>From"[flen]) {
				if (++flen >= 6) {
					memcpy(&buf[blen], "From", 4);
					if ((blen += 4) >= BUF_LEN) {
					    cks->ctx_body.total += blen;
					    MD5Update(&cks->ctx_body.md5,
						      (void *)buf, blen);
					    blen = 0;
					}
					flen = 0;
				}
				continue;
			}
			if (--flen != 0) {
				memcpy(&buf[blen], ">From", flen);
				if ((blen += flen) >= BUF_LEN) {
					cks->ctx_body.total += blen;
					MD5Update(&cks->ctx_body.md5,
						  (void *)buf, blen);
					blen = 0;
				}
				flen = 0;
			}
		}
		if (c == '\n') {
			flen = 1;
			continue;
		}

		/* Ignore whitespace to avoid being confused by
		 * varying line endings added and removed by
		 * various MUAs and MTAs.
		 * As a side effect, ignore entirely blank messages. */
		if (c == ' ' || c == '\t' || c == '\r')
			continue;

		/* Ignore '=' to minimize but not entirely avoid being
		 * confused by some some sequences that look like
		 * quoted-printable triples but that are not.
		 */
		if (c == '=')
			continue;

		buf[blen] = c;
		if (++blen >= BUF_LEN) {
			cks->ctx_body.total += blen;
			MD5Update(&cks->ctx_body.md5, (void *)buf, blen);
			blen = 0;
		}
	}
}



static void
ck_body0_fin(GOT_CKS *cks)
{
	/* always generate the MD5 checksum so that grey listing has it */
	MD5Final(cks->sums[DCC_CK_BODY].sum.b, &cks->ctx_body.md5);

	if (cks->sums[DCC_CK_BODY].type != DCC_CK_BODY)
		return;

	if (cks->ctx_body.total < 30) {
		cks->sums[DCC_CK_BODY].type = DCC_CK_INVALID;
		return;
	}

	cks->sums[DCC_CK_BODY].rpt2srvr = 1;
}



static void
decoders_init(GOT_CKS *cks)
{
	cks->mime_bnd_matches = 0;

	cks->flags |= CKS_MIME_BOL;
	cks->mime_ct = CK_CT_TEXT;
	cks->mime_cset = c8859_1;
	cks->mime_ce = DCC_CK_CE_ASCII;
	cks->qp.state = CK_QP_IDLE;
	cks->b64.quantum_cnt = 0;
}



/* start all of the checksums */
void
cks_init(GOT_CKS *cks)
{
	GOT_SUM *g;

	for (g = cks->sums; g <= LAST(cks->sums); ++g) {
		CLR_GOT_SUM(g);
	}

	cks->flags = 0;
	cks->mime_nest = 0;
	cks->mhdr_st = CK_MHDR_ST_IDLE;
	cks->mp_st = CK_MP_ST_TEXT;
	decoders_init(cks);

	cks->url.doms = 0;
	cks->url.dom_start = 0;

	cks->sums[DCC_CK_BODY].type = DCC_CK_BODY;
	cks->ctx_body.total = 0;
	cks->ctx_body.flen = 1;
	MD5Init(&cks->ctx_body.md5);

	dcc_ck_fuz1_init(cks);
	dcc_ck_fuz2_init(cks);
}



/* decode quoted-printable and base64 and then compute the body checksums */
static void
decode_sum(GOT_CKS *cks, const char *bp, u_int bp_len)
{
	char tbuf[1024];
	const char *tbufp;
	int len;

	/* Decode quoted-printable and base64 and make fuzzy sumes
	 * only while in the body of a MIME entity.
	 * Changing from the text, image, html, etc. requires a '\n'
	 * to flush the URL and other decoders in the checksummers.
	 * None of the checksums count whitespace. */
	if (cks->mp_st != CK_MP_ST_TEXT) {
		if (bp_len == 0)
			return;
#ifdef DCC_DEBUG_CKSUM
		if (dcc_clnt_debug == 4)
			write(1, bp, bp_len);
#endif
		ck_body0(cks, bp, bp_len);
		dcc_ck_fuz1(cks, "\n", 1);
		dcc_ck_fuz2(cks, "\n", 1);
		return;
	}

	while (bp_len != 0) {
		switch (cks->mime_ce) {
		case DCC_CK_CE_ASCII:
		default:
			len = bp_len;
			tbufp = bp;
			bp_len = 0;
			break;
		case DCC_CK_CE_QP:
			tbufp = tbuf;
			len = ck_qp_decode(cks, &bp, &bp_len,
					   tbuf, sizeof(tbuf));
			break;
		case DCC_CK_CE_B64:
			tbufp = tbuf;
			len = ck_b64_decode(cks, &bp, &bp_len,
					    tbuf, sizeof(tbuf));
			break;
		}

		if (len != 0) {
#ifdef DCC_DEBUG_CKSUM
			if (dcc_clnt_debug == 4)
				write(1, tbufp, len);
#endif
			ck_body0(cks, tbufp, len);
			dcc_ck_fuz1(cks, tbufp, len);
			if (cks->mime_ct != CK_CT_BINARY)
				dcc_ck_fuz2(cks, tbufp, len);
		}
	}
}



/* compute all of the body checksums on a chunk of raw text */
void
ck_body(GOT_CKS *cks, const void *bp, u_int bp_len)
{
	CK_BND *bndp;
	const char *sum;		/* 1st input byte not swallowed */
	const char *cmp;		/* 1st not parsed for MIME */
	const char *cp;
	char c;
	int len, matched_len, i, j;

	sum = bp;
	cmp = sum;
	while (bp_len != 0) {
		/* if we have no multipart hassles
		 * then pass buffer to qp/base64 decoder and quit */
		if (cks->mime_nest == 0) {
			decode_sum(cks, sum, bp_len);
			return;
		}

		/* look for start of next line to start matching boundaries */
		if (cks->mime_bnd_matches == 0) {
			cp = memchr(cmp, '\n', bp_len);
			if (!cp) {
				cp = cmp+bp_len;
			} else {
				++cp;
			}

			/* look for a MIME entity header in the text before
			 * the next line and possible start of a boundary */
			i = cp - cmp;
			if (cks->mp_st == CK_MP_ST_HDRS) {
				if (parse_mime_hdr(cks, cmp, i, 0)) {
					/* blank header line ends the headers */
					j = cp-sum;
					if (j) {
					    decode_sum(cks, sum, j);
					    sum = cp;
					}
					cks->mp_st = CK_MP_ST_TEXT;
				}
			}
			/* We found the end of a line.  Reset positions to
			 * start looking for a MIME boundary after it */
			if (*(cp-1) == '\n') {
				cks->flags |= CKS_MIME_BOL;
				cks->mime_bnd_matches = cks->mime_nest;
				for (bndp = cks->mime_bnd;
				     bndp <= LAST(cks->mime_bnd);
				     ++bndp) {
					bndp->cmp_len = 0;
				}
			}
			cmp = cp;
			if ((bp_len -= i) == 0)
				break;
		}

		/* look for (rest of) one of the active MIME boundaries */
		matched_len = 0;
		for (bndp = cks->mime_bnd;
		     bndp < &cks->mime_bnd[cks->mime_nest];
		     ++bndp) {

			if (bndp->cmp_len == CK_BND_MISS)
				continue;   /* already mismatched boundary */

			j = bndp->bnd_len - bndp->cmp_len;
			len = bp_len;
			if (j > len)
				j = len;
			cp = cmp;
			if (j > 0) {
				if (memcmp(cp, &bndp->bnd[bndp->cmp_len], j)) {
					bndp->cmp_len = CK_BND_MISS;
					--cks->mime_bnd_matches;
					continue;
				}
				/* this boundary matches so far */
				bndp->cmp_len += j;
				cp += j;
				if ((len -= j) <= 0) {
					matched_len = bp_len;
					continue;
				}
				/* since we did not exhaust len, we know
				 * we matched the entire boundary */
				j = 0;
			}

			/* look for 1st '-' of trailing "--" */
			if (j == 0
			    && *cp == '-') {
				++bndp->cmp_len;
				if (--len <= 0) {
					matched_len = bp_len;
					continue;
				}
				++cp;
				j = -1;
			}
			/* look for 2nd '-' of trailing "--" */
			if (j == -1) {
				if (*cp == '-') {
					++bndp->cmp_len;
					if (--len <= 0) {
					    matched_len = bp_len;
					    continue;
					}
					++cp;
				} else {
					bndp->cmp_len = CK_BND_MISS;
					--cks->mime_bnd_matches;
					continue;
				}
			}
			/* check for trailing whitespace & '\n' */
			if ((c = *cp) == ' ' || c == '\t' || c == '\r') {
				do {
					++cp;
				} while (--len > 0
					 && ((c = *cp) == ' ' || c == '\t'
					     || c == '\r'));
				if (len <= 0) {
					matched_len = bp_len;
					continue;
				}
			}
			if (*cp != '\n') {
				/* mismatch after the end of the boundary */
				bndp->cmp_len = CK_BND_MISS;
				--cks->mime_bnd_matches;
				continue;
			}

			/* We have found a MIME boundary.
			 * Flush b64 & qp decoders and fuzzy checksummers */
			j = cmp-sum;
			if (j)
				decode_sum(cks, sum, j);

			/* pass the boundary in the buffer */
			matched_len = ++cp - cmp;
			cmp = sum = cp;

			/* Body checksum the boundary */
			cks->mp_st = CK_MP_ST_BND;
			decode_sum(cks, bndp->bnd, bndp->bnd_len);
			if (bndp->cmp_len != bndp->bnd_len) {
				/* checksum trailing "--" of final boundary */
				decode_sum(cks, "--", 2);
				/* end the current & inner entities */
				cks->mp_st = CK_MP_ST_EPILOGUE;
			} else {
				/* intermediate boundaries end inner entities */
				cks->mp_st = CK_MP_ST_HDRS;
				++bndp;
			}
			cks->mime_nest = bndp - cks->mime_bnd;
			decoders_init(cks);
			break;
		}
		bp_len -= matched_len;
	}

	j = cmp-sum;
	if (j)
		decode_sum(cks, sum, j);
}



/* finish all of the body checksums */
void
cks_fin(GOT_CKS *cks)
{
	dcc_ck_fuz1(cks, "\n", 1);	/* flush URL decoders & line buffers */
	dcc_ck_fuz2(cks, "\n", 1);

	ck_body0_fin(cks);
	dcc_ck_fuz1_fin(cks);
	dcc_ck_fuz2_fin(cks);
}
