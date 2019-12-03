/* Distributed Checksum Clearinghouse
 *
 * compute fuzzy body checksum #2
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
 * Rhyolite Software DCC 2.3.167-1.61 $Revision$
 */

#include "dcc_ck.h"


#define FZ2 cks->fuz2

#define BUF_LEN 1024
typedef struct {
    char buf[BUF_LEN+sizeof(CK_WORD)+1];
    int blen;
} LBUF;


#ifdef DCC_DEBUG_CKSUM
static void
FUZ2(FUZ2_LANG *langp, void *buf, int len)
{
	if (dcc_clnt_debug >= 5)
		write(1, buf, len);
	MD5Update(&langp->md5, buf, len);
}
#else
#define FUZ2(langp, buf, len) MD5Update(&(langp)->md5, (void *)buf, len)
#endif


void
dcc_ck_fuz2_init(GOT_CKS *cks)
{
	FUZ2_LANG *lp;

	FZ2.wlen = 0;
	CK_WORD_CLEAR(&FZ2.w);
	FZ2.st = FUZ2_ST_WORD;
	FZ2.cref.st = CREF_ST_IDLE;

	cks->sums[DCC_CK_FUZ2].type = DCC_CK_FUZ2;

	FZ2.btotal = 0;
	FZ2.xsummed = 0;
	for (lp = FZ2.lang; lp <= LAST(FZ2.lang); ++lp) {
		lp->wsummed = 0;
		lp->wtotal = 0;
		MD5Init(&lp->md5);
	}
}



static inline u_char			/* 1=found it, 0=not a known word */
lookup_word(const CK_WORD *w, u_int wlen,
	    const char **word_tbl, u_int word_tbl_len)
{
	const char *p;
	u_int n;

	p = word_tbl[CK_WORD_HASH(w, word_tbl_len)];
	if (!p)
		return 0;
	for (;;) {
		n = *p++;
		if (!n)
			return 0;
		if (n == wlen && !memcmp(w->b, p, n))
			return 1;
		p += n;
	}
}



static void
add_word(GOT_CKS *cks, LBUF *lbp)
{
	FUZ2_LANG *lp;
	int tbl;

	tbl = 0;
	for (lp = FZ2.lang; lp < &FZ2.lang[FUZ2_LANG_NUM]; ++lp, ++lbp, ++tbl) {
		if (fuz2_tbls[tbl].cset != 0
		    && fuz2_tbls[tbl].cset != cks->mime_cset)
			continue;
		if (lookup_word(&FZ2.w, FZ2.wlen,
				fuz2_tbls[tbl].words, fuz2_tbls[tbl].len)) {
			++lp->wtotal;
			memcpy(&lbp->buf[lbp->blen], &FZ2.w, FZ2.wlen);
			if ((lbp->blen += FZ2.wlen) >= BUF_LEN) {
				lp->wsummed += lbp->blen;
				FUZ2(lp, lbp->buf, lbp->blen);
				lbp->blen = 0;
			}
		}
	}
}



void
dcc_ck_fuz2(GOT_CKS *cks, const char *bp, u_int bp_len)
{
#define SKIP_WORD() (FZ2.wlen = sizeof(CK_WORD)+1)
#define JUNK() (SKIP_WORD(), FZ2.st = FUZ2_ST_WORD)
	LBUF *lbp, lbufs[FUZ2_LANG_NUM];
	FUZ2_LANG *lp;
	int i;
	u_char c;

	if (cks->sums[DCC_CK_FUZ2].type != DCC_CK_FUZ2)
		return;

	for (lbp = lbufs; lbp <= LAST(lbufs); ++lbp)
		lbp->blen = 0;

	while (bp_len != 0) {
		switch (FZ2.st) {
		case FUZ2_ST_WORD:
			/* gathering a word */
			do {
				--bp_len;
				c = *bp++;
				if (FZ2.cref.st != CREF_ST_IDLE
				    || (c == '&'
					&& cks->mime_ct == CK_CT_HTML)) {
					i = ck_cref(&FZ2.cref, c);
					if (i < 0)
					    continue;
					bp_len += i;
					bp -= i;
					c = FZ2.cref.result;
				}

				c = cks->mime_cset[c];
				if (c >= FC_A) {
					++FZ2.btotal;
					if (FZ2.wlen < sizeof(CK_WORD))
					    FZ2.w.b[FZ2.wlen++] = c;
					else
					    SKIP_WORD();
					continue;
				}

				if (c == FC_SP) {
					if (FZ2.wlen >= MIN_CK_WLEN
					    && FZ2.wlen <=sizeof(CK_WORD))
					    add_word(cks, lbufs);
					FZ2.wlen = 0;
					CK_WORD_CLEAR(&FZ2.w);
					continue;
				}
				++FZ2.btotal;

				if (c == FC_LT) {
					FZ2.tag_len = 0;
					CK_WORD_CLEAR(&FZ2.tag);
					FZ2.st = FUZ2_ST_START_TAG;
					break;
				}

				JUNK();
			} while (bp_len != 0);
			break;

		case FUZ2_ST_START_TAG:
			/* collecting an HTML tag or comment
			 * We've passed the '<' */
			c = *bp;
			c = DCC_TO_LOWER(c);
			if (((DCC_IS_LOWER(c) || DCC_IS_DIGIT(c))
			     && FZ2.tag_len < sizeof(FZ2.tag))
			    || ((c == '/'   /* end-tag */
				 || c == '!')   /* start of comment */
				&& FZ2.tag_len == 0)
			    || (c == '-'    /* comment */
				&& FZ2.tag_len >= 1 && FZ2.tag_len <= 2)) {
				FZ2.tag.b[FZ2.tag_len++] = c;
				++FZ2.btotal;
				++bp;
				--bp_len;
				break;
			}

			/* notice an <html> tag while in text/plain
			 * and switch to text/html */
			if (FZ2.tag_len == 4
			    && cks->mime_ct != CK_CT_HTML
			    && !memcmp(FZ2.tag.b, "html", 4))
				cks->mime_ct = CK_CT_HTML;

			if (cks->mime_ct == CK_CT_HTML
			    && FZ2.tag_len > 0) {
				/* if we are in an HTML document and we
				 * have at least one character after '<',
				 * assume it is some kind of HTML tag */
				FZ2.xsummed += FZ2.tag_len+1;	/* count '<' */
				if (c == '>') {
					/* optimize common simple tags */
					++FZ2.xsummed;
					++FZ2.btotal;
					++bp, --bp_len;
					FZ2.st = FUZ2_ST_WORD;
					break;
				}
				if (FZ2.tag_len >= 3
				    && !memcmp(FZ2.tag.b, "!--", 3)) {
					FZ2.st = FUZ2_ST_SKIP_COMMENT;
				} else {
					FZ2.st = FUZ2_ST_SKIP_TAG;
				}
			} else {
				/* assume it is not an HTML tag and
				 * mark the whole word as junk */
				JUNK();
			}
			break;

		case FUZ2_ST_SKIP_TAG:
			/* Skip rest of boring HTML tag
			 * We ought to ignore '>' in quotes */
			do {
				++FZ2.btotal;
				--bp_len;
				c = *bp++;
				if (FZ2.cref.st != CREF_ST_IDLE || c == '&') {
					i = ck_cref(&FZ2.cref, c);
					if (i < 0)
					    continue;
					bp_len += i;
					bp -= i;
					c = FZ2.cref.result;
				}
				if (c == '>') {
					++FZ2.xsummed;
					++FZ2.btotal;
					FZ2.st = FUZ2_ST_WORD;
					break;
				}
				if (cks->mime_cset[c] != FC_SP) {
					++FZ2.xsummed;
					++FZ2.btotal;
					/* don't let wild tags run forever */
					if (++FZ2.tag_len > URL_FAILSAFE) {
					    JUNK();
					    break;
					}
				}
			} while (bp_len != 0);
			break;

		case FUZ2_ST_SKIP_COMMENT:
			/* HTML comments can include HTML tags,
			 * but spammers don't understand HTML comment syntax
			 * and Netscape and IE treat (and ignore) broken
			 * comments like strange tags. */
			do {
				--bp_len;
				c = *bp++;
				if (c == '>') {
					++FZ2.xsummed;
					++FZ2.btotal;
					FZ2.st = FUZ2_ST_WORD;
					break;
				}
				if (cks->mime_cset[c] != FC_SP) {
					++FZ2.xsummed;
					++FZ2.btotal;
					/* don't let wild tags run forever */
					if (++FZ2.tag_len > URL_FAILSAFE) {
					    JUNK();
					    break;
					}
				}
			} while (bp_len != 0);
			break;
		}
	}
	for (lbp = lbufs, lp = FZ2.lang; lbp <= LAST(lbufs); ++lbp, ++lp) {
		if (lbp->blen != 0) {
			lp->wsummed += lbp->blen;
			FUZ2(lp, lbp->buf, lbp->blen);
		}
	}
#undef SKIP_WORD
#undef JUNK
#undef BUF_LEN
}



void
dcc_ck_fuz2_fin(GOT_CKS *cks)
{
	FUZ2_LANG *lp, *lp1;

	if (cks->sums[DCC_CK_FUZ2].type != DCC_CK_FUZ2)
		return;

	/* pick the language checksum of the most words */
	lp = FZ2.lang;
	for (lp1 = lp+1; lp1 <= LAST(FZ2.lang); ++lp1) {
		if (lp->wtotal < lp1->wtotal)
			lp = lp1;
	}

#ifdef DCC_DEBUG_CKSUM
	if (dcc_clnt_debug > 3)
		printf("\n***fuz2: wtotal[%d]=%d summed=%d+%d btotal=%d\n",
		       (int)(lp-FZ2.lang),
		       lp->wtotal, lp->wsummed, FZ2.xsummed, FZ2.btotal);
#endif
	/* The FUZ2 checksum is not valid if it is on a few words and
	 * less than 10% of a big, binary file */
	if (lp->wtotal < FUZ2_FEW_WORDS
	    && (lp->wsummed+FZ2.xsummed)*10 < FZ2.btotal) {
		cks->sums[DCC_CK_FUZ2].type = DCC_CK_INVALID;
		return;
	}
	/* We cannot compute a checksum on a nearly empty message */
	if (lp->wtotal < FUZ2_MIN_WORDS) {
		if (lp->wtotal + cks->url.doms*(FUZ2_MIN_WORDS/2)
		    >= FUZ2_MIN_WORDS) {
			/* use host names if we lack words */
#ifdef DCC_DEBUG_CKSUM
			if (dcc_clnt_debug > 3) {
				char escbuf[sizeof(cks->url.doms_buf)+20];

				printf("         add domains \"%s\"\n",
				       escstr(escbuf, sizeof(escbuf),
					      cks->url.doms_buf,
					      cks->url.dom_start-1));
			}
#endif
			FUZ2(lp, cks->url.doms_buf, cks->url.dom_start-1);
		} else {
			cks->sums[DCC_CK_FUZ2].type = DCC_CK_INVALID;
			return;
		}
	}

	MD5Final(cks->sums[DCC_CK_FUZ2].sum.b, &lp->md5);
	cks->sums[DCC_CK_FUZ2].rpt2srvr = 1;
}
