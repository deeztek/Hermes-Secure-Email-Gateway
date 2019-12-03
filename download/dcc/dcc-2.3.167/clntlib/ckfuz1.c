/* Distributed Checksum Clearinghouse
 *
 * compute fuzzy body checksum #1
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
 * Rhyolite Software DCC 2.3.167-1.73 $Revision$
 */

#include "dcc_ck.h"

#define FZ1  cks->fuz1

#define MAX_FUZ1_LEN	(4*1024)


/* Process more of a character reference
 *	-1=need more
 *	0=character in cref->result and c is the terminal ';'
 *	1=character in cref->result but stop short before c
 */
int
ck_cref(CK_CREF *cref, u_char uc)
{
	u_int n;

	switch (cref->st) {
	case CREF_ST_IDLE:
		cref->st = CREF_ST_START;
		return -1;

	case CREF_ST_START:
		/* start to get a HTML character reference. We have already
		 * passed the '&' and need '#' or a letter*/
		if (uc == '#') {
			cref->st = CREF_ST_NUM;
		} else if (DCC_IS_LOWER(uc) || DCC_IS_UPPER(uc)) {
			CK_WORD_CLEAR(&cref->w);
			cref->w.b[0] = uc;
			cref->len = 1;
			cref->st = CREF_ST_NAME;
		} else {
			cref->st = CREF_ST_IDLE;
			return -1;
		}
		break;

	case CREF_ST_NUM:
		/* we've seen "&#".  look for 'x' or the first digit */
		if (uc == 'x' || uc == 'X') {
			cref->result = 0;
			cref->st = CREF_ST_HEX;
		} else if (uc >= '0' && uc <= '9') {
			cref->result = uc - '0';
			cref->st = CREF_ST_DEC;
		} else {
			cref->result = '#';
			cref->st = CREF_ST_IDLE;
			return 1;
		}
		break;

	case CREF_ST_DEC:
		if (uc >= '0' && uc <= '9') {
			n = cref->result*10 + (uc - '0');
		} else {
			cref->st = CREF_ST_IDLE;
			return (uc != ';');
		}
		if (n > 255)
			n = 255;
		cref->result = n;
		break;

	case CREF_ST_HEX:
		if ((uc >= 'a' && uc <= 'f')
		    || (uc >= 'A' && uc <= 'F')) {
			n = (cref->result<<4) + (uc & 0xf) + 9;
		} else if (uc >= '0' && uc <= '9') {
			n = (cref->result<<4) + (uc - '0');
		} else {
			cref->st = CREF_ST_IDLE;
			return (uc != ';');
		}
		if (n > 255)
			n = 255;
		cref->result = n;
		break;

	case CREF_ST_NAME:
		if (DCC_IS_LOWER(uc) || DCC_IS_UPPER(uc) || DCC_IS_DIGIT(uc)) {
			/* If the word is too long, the final match will fail.
			 * This will consume the word safely. */
			if (cref->len < sizeof(CK_WORD))
				cref->w.b[cref->len++] = uc;
		} else {
			/* this character ends the cref */
			cref->result = lookup_cref(&cref->w, cref->len);
			cref->st = CREF_ST_IDLE;
			return (uc != ';');
		}
		break;
	}

	/* accept this character of the character reference and wait for more */
	return -1;
}



#define UTF8_MAX	0x10ffff
#define PUNY_PREFIX	"xn--"
#define PUNY_PREFIX_LEN LITZ(PUNY_PREFIX)
#define PUNY_BASE	36
#define	PUNY_TMIN	1
#define	PUNY_TMAX	26
#define	PUNY_SKEW	38
#define	PUNY_DAMP	700
#define	PUNY_INITIAL_BIAS 72
#define	PUNY_INITIAL_N	0x80
#define	PUNYCODE36	"abcdefghijklmnopqrstuvwxyz0123456789"

static inline int
puny_adapt(u_int delta, u_int numpoints, u_char firsttime)
{
	int k;

	if (firsttime) {
		delta /= PUNY_DAMP;
	} else {
		delta /= 2;
	}
	delta += (delta / numpoints);
	for (k = 0;
	     delta > ((PUNY_BASE-PUNY_TMIN) * PUNY_TMAX) / 2;
	     k += PUNY_BASE) {
		delta /= (PUNY_BASE - PUNY_TMIN);
	}
	return k + ((PUNY_BASE-PUNY_TMIN+1) * delta) / (delta+PUNY_SKEW);
}



/* encode Punycode for one label, probably expanding the label in the buffer */
static void
punyencode(CK_URL *url)
{
#	define PUNY_OUT(_c) do {if (puny_len >= URL_LABEL_MAX) return;	\
		puny[puny_len++] = (_c);} while (0);
	u_char puny[URL_LABEL_MAX];
	u_int32_t unicode[URL_LABEL_MAX];
	u_int unicode_len;
	u_int idx, n, delta, bias, h, b;
	int puny_len;
	u_int32_t uc, uc2, uc3, uc4;
	int i;

	url->flags &= ~URL_IDN;

	/* decode UTF-8	*/
	i = url->label_start;
	unicode_len = 0;
	do {
		uc = (u_char)url->doms_buf[i++];
		if ((uc & 0x80) != 0) {
			if ((uc & 0xe0) == 0xc0) {
				uc &= 0x1f;
				/* give up on an invalid UTF-8 sequence */
				if (uc == 0 || i >= url->dom_end)
					return;
				uc2 = (u_char)url->doms_buf[i++] ^ 0x80;
				if (uc2 > 0x3f)
					return;
				uc = (uc << 6) | uc2;
			} else if ((uc & 0xf0) == 0xe0) {
				uc &= 0x0f;
				if (uc == 0 || i+1 >= url->dom_end)
					return;
				uc2 = (u_char)url->doms_buf[i++] ^ 0x80;
				uc3 = (u_char)url->doms_buf[i++] ^ 0x80;
				if (uc2 > 0x3f || uc3 > 0x3f)
					return;
				uc = (((uc << 6) | uc2) << 6) | uc3;
			} else if ((uc & 0xf8) == 0xf0) {
				uc &= 0x07;
				if (uc == 0 || i+2 >= url->dom_end)
					return;
				uc2 = (u_char)url->doms_buf[i++] ^ 0x80;
				uc3 = (u_char)url->doms_buf[i++] ^ 0x80;
				uc4 = (u_char)url->doms_buf[i++] ^ 0x80;
				if (uc2 > 0x3f || uc3 > 0x3f || uc4 > 0x3f)
					return;
				uc = (((((uc << 6) | uc2) << 6)
				       | uc3) << 6) | uc4;
			} else {
				return;
			}
			if (uc > UTF8_MAX)
				return;
		}
		if (unicode_len >= URL_LABEL_MAX)
			return;
		unicode[unicode_len++] = uc;
	} while (i != url->dom_end);

	/* Puny encode */
	puny_len = PUNY_PREFIX_LEN;
	memcpy(puny, PUNY_PREFIX, puny_len);

	n = PUNY_INITIAL_N;
	delta = 0;
	bias = PUNY_INITIAL_BIAS;
	b = 0;
	/* copy basic code points */
	for (idx = 0; idx < unicode_len; ++idx) {
		uc = unicode[idx];
		if (uc >= 0x80)
			continue;
		PUNY_OUT(uc);
		++b;
	}
	if (b != 0)
		PUNY_OUT('-');

	h = b;
	while (h < unicode_len) {
		u_int m;

		m = UTF8_MAX+1;
		for (idx = 0; idx <= unicode_len; ++idx) {
			if (unicode[idx] < m && unicode[idx] >= n)
				m = unicode[idx];
		}
		delta += (m - n) * (h + 1);
		n = m;
		for (idx = 0; idx < unicode_len; ++idx) {
			if (unicode[idx] < n) {
				++delta;
			} else if (unicode[idx] == n) {
				u_int k, q;

				q = delta;
				for (k = PUNY_BASE; ; k += PUNY_BASE) {
					u_int t;

					t = (k <= bias
					     ? PUNY_TMIN
					     : k >= bias + PUNY_TMAX
					     ? PUNY_TMAX
					     : k - bias);
					if (q < t)
					    break;
					PUNY_OUT(PUNYCODE36[t +
							(q-t) % (PUNY_BASE-t)]);
					q = (q-t) / (PUNY_BASE-t);
				}
				PUNY_OUT(PUNYCODE36[q]);
				bias = puny_adapt(delta, h+1, h == b);
				delta = 0;
				++h;
			}
		}
		++delta;
		++n;
	}

	if (url->label_start + puny_len <= URL_HOST_MAX) {
		url->dom_end = url->label_start + puny_len;
		memcpy(&url->doms_buf[url->label_start], puny, puny_len);
	}
}



static inline void
reset_doms_buf(CK_URL *url, char *url_start)
{
	url->start = url_start;
	url->tld = 0;
	url->sld = 0;

	url->dom_end = url->dom_start;
	url->label_start = url->dom_end;
	url->punct = 0;
	url->dot1 = 0;
	url->dot2 = 0;
	url->url_total = 0;
	url->flags &= ~(URL_IDN | URL_DOT);
}



/* save a byte of the host name */
static inline void
url_host_save(CK_URL *url, char uc)
{
	if (url->dom_end - url->dom_start >= URL_HOST_MAX) {
		reset_doms_buf(url, 0);
		url->flags |= URL_TOO_LONG;
		url->st = URL_ST_IDLE;
	}
	if (url->flags & URL_TOO_LONG)
		return;

	url->doms_buf[url->dom_end++] = uc;
}



/* DNSBL check the host name from a URL */
static inline void
url_host_end(GOT_CKS *cks)
{
	int len;

	CK_URL *url = &cks->url;

	/* forget port number */
	if (url->punct != 0)
		url->dom_end = url->punct;
	if (url->dom_end <= url->dom_start
	    || (url->flags & URL_TOO_LONG))
		return;

	if (url->flags & URL_IDN)
		punyencode(url);

	url->doms_buf[url->dom_end++] = '\0';
	url_dnsbl(cks->dlw, &url->doms_buf[url->dom_start]);

	/* delete 3rd level labels for the fuzzy checksums */
	if (url->dot2 != 0) {
		len = cks->fuz1.cp - url->sld;
		memmove(url->start, url->sld, len);
		if (cks->fuz1.eol >= cks->fuz1.cp)
			cks->fuz1.eol = url->start + len;
		cks->fuz1.cp = url->start + len;

		/* trim the name for the fuz2 checksum only if
		 * we might use it */
		if (cks->fuz2.lang[0].wtotal < FUZ2_MIN_WORDS) {
			len = url->dom_end - url->dot2;
			memmove(&url->doms_buf[url->dom_start],
				&url->doms_buf[url->dot2], len);
			url->dom_end = url->dom_start + len;
		}
	}

	url->dom_start = url->dom_end;
	++url->doms;
}



/* capture host name and skip parts of URLs
 *  We need
 *	parts of host names for fuz1 checksums
 *	some host names sometimes for fuz2 checksum
 *	all host names for DNS white- and blacklist checks
 */
static URL_RES
ck_url(GOT_CKS *cks, u_char uc,		/* lower case character */
       const char **pbp)		/* uc in input buffer */
{
	CK_URL *url;
	int i;

	url = &cks->url;

	if (uc == '&' || url->cref.st != CREF_ST_IDLE) {
		i = ck_cref(&url->cref, uc);
		if (i < 0)
			return URL_RES_FWD;
		*pbp -= i;
		uc = url->cref.result;
	}

	switch (url->st) {
	case URL_ST_IDLE:
		if (uc == 'h') {
			/* start looking for 't' after 'h' in "http" */
			url->st = URL_ST_T1;
			url->flags = 0;
		} else if (uc == '=') {
			/* maybe found the '=' in "href=" "img src=" etc */
			url->st = URL_ST_QUOTE;
			url->flags = 0;
		}
		break;

	case URL_ST_QUOTE:
		/* look for '"' '\'' or 'H' after "href=", "img src=, etc.
		 * track quotes to help the FUZ1 checksum skip all of the end
		 * of a URL */
		if (uc == 'h') {
			url->st = URL_ST_T1;
		} else if (uc == '"') {
			url->flags |= URL_DQUOTED;
			url->st = URL_ST_QH;
		} else if (uc == '\'') {
			url->flags = URL_SQUOTED;
			url->st |= URL_ST_QH;
		} else {
			url->st = URL_ST_IDLE;
		}
		break;

	case URL_ST_QH:
		/* seen quote; looking for start of URL
		 * These states should ignore whitespace including '\n' among
		 * 'https://', but fixing that error would break checksum
		 * compatibility, albeit on very few URLs. */
		if (uc == 'h') {
			url->st = URL_ST_T1;
		} else {
			url->st = URL_ST_IDLE;
		}
		break;

	case URL_ST_T1:
		if (uc == 't')
			url->st = URL_ST_T2;
		else
			url->st = URL_ST_IDLE;
		break;

	case URL_ST_T2:
		if (uc == 't')
			url->st = URL_ST_P;
		else
			url->st = URL_ST_IDLE;
		break;

	case URL_ST_P:
		if (uc == 'p')
			url->st = URL_ST_S;
		else
			url->st = URL_ST_IDLE;
		break;

	case URL_ST_S:
		/* we are expecting the ':' or 's' after http */
		if (uc == 's')
			url->st = URL_ST_COLON;
		else if (uc == ':')
			url->st = URL_ST_SLASH1;
		else
			url->st = URL_ST_IDLE;
		break;

	case URL_ST_COLON:
		/* we are expecting the ':' after http or https */
		if (uc == ':')
			url->st = URL_ST_SLASH1;
		else
			url->st = URL_ST_IDLE;
		break;

	case URL_ST_SLASH1:
		if (uc == '/') {
			/* got the first '/' after http: */
			url->st = URL_ST_SLASH2;
		} else {
			url->st = URL_ST_IDLE;
		}
		break;

	case URL_ST_SLASH2:
		if (uc == '/') {
			/* Got the second '/' after http:/" */
			/* Make room in the host name buffer if we are too
			 * close to its end for a maximum sized name.
			 * Flush the buffer if we will not use the old names
			 * for the fuz2 checksum.  Otherwise discard the first
			 * name in the buffer. */
			if (cks->fuz2.lang[0].wtotal >= FUZ2_MIN_WORDS) {
				url->dom_start = 0;
			} else {
				while (url->dom_start > (ISZ(url->doms_buf)
							- URL_HOST_MAX_SAVE)) {
					char *p;

					p = memchr(url->doms_buf, '\0',
						   url->dom_start);
					if (!p) {
					    /* there must be >1 name in the
					     * buffer because it is large
					     * enough for at least 2 */
					    dcc_logbad(EX_SOFTWARE,
						       "bad url->doms_buf");
					}
					url->dom_start -= (++p - url->doms_buf);
					memmove(url->doms_buf, p,
						url->dom_start);
				}
			}
			url->st = URL_ST_SLASH3_START;
			/* tell the FUZ1 code to check for room in its buffer */
			return URL_RES_CK_SPACE;
		}
		url->st = URL_ST_IDLE;
		break;

	case URL_ST_SLASH3_START:
		reset_doms_buf(url, cks->fuz1.cp);
		url->st = URL_ST_SLASH3;
		/* fall through */
	case URL_ST_SLASH3:
		/* look for the end of the host name */
		if (++url->url_total > URL_FAILSAFE) {
			url->st = URL_ST_IDLE;
			break;
		}
		if (!((uc >= 'a' && uc <= 'z') || (uc >= '0' && uc <= '9')
		      || uc == '-' || uc == '_')) {
			if (uc == '.' && url->punct == 0) {
				if (url->flags & URL_DOT) {
					/* consecutive '.' are invalid  in
					 * host names, but can end URLs */
					url->punct = url->dom_end;
					break;
				}
				/* delay dealing with '.' until we are sure
				 * it is not at the end of the name */
				url->flags |= URL_DOT;
				break;
			}
			/* treat '\\' like '/' for Microsoft */
			if (uc == '/' || uc == '\\') {
				url_host_end(cks);
				url->st = URL_ST_SKIPPING_URL;
				break;
			}
			if (uc == '"') {
				url_host_end(cks);
				if (url->flags & URL_SQUOTED)
					url->st = URL_ST_SKIPPING_URL;
				else
					url->st = URL_ST_IDLE;
				break;
			}
			if (uc == '\'') {
				url_host_end(cks);
				if ((url->flags & URL_DQUOTED))
					url->st = URL_ST_SKIPPING_URL;
				else
					url->st = URL_ST_IDLE;
				break;
			}
			/* Whitespace ends the URL for old versions of Firefox
			 * and cannot be in a host name, user name, or
			 * password.
			 * Ignore the fact that newer versions and the standard
			 * ignores whitespace in quoted URLs.  Fixing this
			 * would break checksum compatibility on very few URLs.
			 * We must keep nulls out of URLs.
			 * So assume all control characters end things.*/
			if (uc == '<' || uc == '>' || uc <= ' '
			    || (uc == 0xa0 && !(url->flags & URL_IDN))) {
				url_host_end(cks);
				if (url->flags & URL_QUOTED)
					url->st = URL_ST_SKIPPING_URL;
				else
					url->st = URL_ST_IDLE;
				break;
			}
			/* ignore username and password */
			if (uc == '@' && !(url->flags & URL_USERNAME)) {
				url->flags |= URL_USERNAME;
				cks->fuz1.cp = url->start;
				url->st = URL_ST_SLASH3_START;
				break;
			}
			/* Note characters that can be in RFC 1738 user names
			 * and passwords but not host names
			 * or a port number after a host name.
			 * RFC 1738 said
			 * login    = [ user [ ":" password ] "@" ] hostport
			 * user	    = *[ uchar | ";" | "?" | "&" | "=" ]
			 * password = *[ uchar | ";" | "?" | "&" | "=" ]
			 * uchar    = unreserved | escape
			 * unreserved= alpha | digit | safe | extra
			 * safe	    = "$" | "-" | "_" | "." | "+"
			 * extra    = "!" | "*" | "'" | "(" | ")" | ","
			 */
			if (uc == ':'
			    || ((uc == ';' || uc == '?' || uc == '&'
				 || uc == '=' || uc == '$' || uc == '+'
				 || uc == '+' || uc == '!' || uc == '*'
				 || uc == '(' || uc == ')' || uc == ',')
				&& !(url->flags & URL_USERNAME))) {
				if (url->punct == 0)
					url->punct = url->dom_end;
			} else if ((uc & 0xc0) == 0xc0 && url->punct == 0) {
				/* possible UTF8 for Puny encoding */
				url->flags |= URL_IDN;
			} else {
				/* other strangeness probably ends the URL and
				 * certainly the host name */
				url_host_end(cks);
				if (url->flags & URL_QUOTED)
					url->st = URL_ST_SKIPPING_URL;
				else
					url->st = URL_ST_IDLE;
				break;
			}
		}
		/* Save this byte of the URL for the fuz2 checksum
		 * and DNSBL checks unless we might be in a password  */
		if (url->punct == 0) {
			if (url->flags & URL_DOT) {
				/* first deal with a delayed '.' */
				url->flags &= ~URL_DOT;
				if (url->flags & URL_IDN)
					punyencode(url);
				url_host_save(url, '.');
				url->dot2 = url->dot1;
				url->dot1 = url->dom_end;
				url->label_start = url->dom_end;
				url->sld = url->tld;
				url->tld = cks->fuz1.cp;
			}
			url_host_save(url, uc);
		}
		break;

	case URL_ST_SKIPPING_URL:
		/* skip the rest of the URL */
		++url->url_total;
		if ((uc == '"' && !(url->flags & URL_SQUOTED))
		    || (uc == '\'' && !(url->flags & URL_DQUOTED))
		    || (uc == '>' && !(url->flags & URL_QUOTED))
		    || uc == ' ' || uc == '\t' || uc == '\n' || uc == '\r'
		    || (uc == 0xA0 && !(url->flags & URL_IDN))
		    || url->url_total > URL_FAILSAFE)
			url->st = URL_ST_IDLE;
		return URL_RES_SKIP;
	}

	return URL_RES_FWD;
}



void
dcc_ck_fuz1_init(GOT_CKS *cks)
{
	cks->sums[DCC_CK_FUZ1].type = DCC_CK_FUZ1;
	FZ1.total = 0;			/* bytes summed */
	FZ1.cp = FZ1.buf;
	FZ1.eol = 0;
	cks->url.st = URL_ST_IDLE;
	cks->url.cref.st = CREF_ST_IDLE;

	MD5Init(&FZ1.md5);
}



static inline u_char			/* 0=keep the line, 1=discard it */
dear_sucker(const char *cp, u_int llen)
{
#define DEAR_WORD(w) (llen >= sizeof(w) && !strncmp(cp, w, LITZ(w)))

	if (DEAR_WORD("dear"))
		return 1;
	if (DEAR_WORD("hello"))
		return 1;
	if (DEAR_WORD("greeting"))
		return 1;
	if (DEAR_WORD("date"))
		return 1;

	return 0;
#undef DEAR_WORD
}



static void
add_sum(CTX_FUZ1 *fz1, int len)
{
	int i;

	if (len == 0)
		return;

	/* limit fuz1 span */
	i = MAX_FUZ1_LEN - (fz1->total + len);
	if (i < 0)
		len += i;
	if (len == 0)
		return;

	MD5Update(&fz1->md5, (void *)fz1->buf, len);
	fz1->total += len;
}



void
dcc_ck_fuz1(GOT_CKS *cks, const char *bp, u_int bp_len)
{
#define CLEAN_FUZ1_BUF
	const char *bp_lim;
	int len;
	URL_RES url_res;
	char *cp, c;

	if (cks->sums[DCC_CK_FUZ1].type != DCC_CK_FUZ1)
		return;

	bp_lim = bp+bp_len;
	cp = FZ1.cp;

	for (;;) {
		if (bp >= bp_lim) {
			/* Sum the buffer if it ends with a line.
			 * Every message always ends with an artificial "\n". */
			if (cp != FZ1.buf && FZ1.eol == cp) {
				add_sum(&FZ1, cp - FZ1.buf);
				cp = FZ1.buf;
				FZ1.eol = 0;
#ifdef CLEAN_FUZ1_BUF
				memset(cp, 0, sizeof(FZ1.buf));
#endif
			}
			FZ1.cp = cp;
			return;
		}
		c = *bp++;

		/* convert ASCII upper to lower case */
		c = DCC_TO_LOWER(c);

		/* Look for start of a URL.  Do not worry about HTML character
		 * references because Thunderbird does not recognize
		 * <a href&#61http://example.com>asdf</A>
		 * or &#72http://domain.com */
		if (c == 'h' || c == '=' || cks->url.st != URL_ST_IDLE) {
			FZ1.cp = cp;
			url_res = ck_url(cks, c, &bp);
			cp = FZ1.cp;
			switch (url_res) {
			case URL_RES_FWD:
				/* add character to buffer for eventual sum */
				break;
			case URL_RES_CK_SPACE:
				/* Make room before starting a URL
				 * if we are too close to the end of
				 * the buffer for the most that we will
				 * save and then checksum of a URL. */
				while (cp >= &FZ1.buf[sizeof(FZ1.buf)
						      - URL_HOST_MAX]) {
					if (!FZ1.eol) {
					    add_sum(&FZ1, cp - FZ1.buf);
					    cp = FZ1.buf;
					    FZ1.eol = 0;    /* no more EOL */
					} else {
					    len = FZ1.eol - FZ1.buf;
					    add_sum(&FZ1, len);
					    memmove(FZ1.buf, FZ1.eol,
						    cp - FZ1.eol);
					    cp -= len;
					    FZ1.eol = 0;
					}
#ifdef CLEAN_FUZ1_BUF
					memset(cp, 0,
					       sizeof(FZ1.buf) - (cp-FZ1.buf));
#endif
				}
				break;
			case URL_RES_SKIP:
				continue;
			}
		}

		/* collect only ASCII letters */
		if (DCC_IS_LOWER(c)) {
			/* Collect more of a new line */
			*cp = c;
			if (++cp < &FZ1.buf[sizeof(FZ1.buf)])
				continue;

			/* We are at the end of the buffer,
			 * so add it to the checksum */
			add_sum(&FZ1, cp - FZ1.buf);
			cp = FZ1.buf;
			FZ1.eol = 0;	/* no more EOL */
#ifdef CLEAN_FUZ1_BUF
			memset(cp, 0, sizeof(FZ1.buf));
#endif
			cks->url.st = URL_ST_IDLE;
			continue;
		}

		if (c == '\n') {
			/* Ignore short lines starting with some strings
			 * This should not be done if cks->url.st=URL_ST_SLASH3
			 * or cks->url_st=SLASH3_START_START, but fixing that
			 * would break checksum compatibility, albeit on
			 * very few URLS. */
			if (FZ1.eol
			    && (len = cp - FZ1.eol) > 0
			    && len <= FUZ1_MAX_LINE
			    && dear_sucker(FZ1.eol, len)) {
				cp = FZ1.eol;
				cks->url.st = URL_ST_IDLE;
				continue;
			}

			/* Add the line to the checksum if we do not
			 * have room in the buffer for another line */
			if (cp >= &FZ1.buf[sizeof(FZ1.buf) - (FUZ1_MAX_LINE
							+ HTTPS_LEN)]) {
				add_sum(&FZ1, cp - FZ1.buf);
				cp = FZ1.buf;
				FZ1.eol = 0;    /* no more EOL */
#ifdef CLEAN_FUZ1_BUF
				memset(cp, 0, sizeof(FZ1.buf));
#endif
				cks->url.st = URL_ST_IDLE;
				continue;
			}

			FZ1.eol = cp;
		}
	}
}



void
dcc_ck_fuz1_fin(GOT_CKS *cks)
{
	if (cks->sums[DCC_CK_FUZ1].type != DCC_CK_FUZ1)
		return;

	/* we cannot compute a checksum on an empty or nearly empty message */
	if (FZ1.total < 30) {
		cks->sums[DCC_CK_FUZ1].type = DCC_CK_INVALID;
		return;
	}

	MD5Final(cks->sums[DCC_CK_FUZ1].sum.b, &FZ1.md5);
	cks->sums[DCC_CK_FUZ1].rpt2srvr = 1;
}
