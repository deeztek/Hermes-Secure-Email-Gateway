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
 * Rhyolite Software DCC 2.3.167-1.81 $Revision$
 */

#include "dcc_ck.h"
#include "dcc_xhdr.h"


const char *
wf_fnm(const WF *wf, int fno)
{
	if (!fno) {
		return wf->ascii_nm.c;
	} else {
		return wf->wtbl->hdr.white_incs[fno-1].nm.c;
	}
}



const char *
wf_fnm_lno(DCC_FNM_LNO_BUF *buf, const WF *wf)
{
	int fno;

	if (!wf)
		return "";

	fno = wf->fno;
	if (!fno)
		return dcc_fnm_lno(buf, wf->ascii_nm.c, wf->lno);

	snprintf(buf->b, sizeof(buf->b),
		 DCC_FNM_LNO_PAT" included in %s",
		 wf->lno, dcc_path2fnm(wf->wtbl->hdr.white_incs[fno-1].nm.c),
		 wf->ascii_nm.c);
	return buf->b;
}



DCC_TGTS
dcc_str2thold(DCC_CK_TYPES type, const char *str)
{
	u_long l;
	char *p;

	l = strtoul(str, &p, 10);
	if (*p != '\0') {
		if (*p == '%') {
			if (*++p != '\0' || type != DCC_CK_REP_BULK)
				return DCC_TGTS_INVALID;
		} else if (!strcasecmp(str, DCC_XHDR_TOO_MANY)) {
			l = DCC_TGTS_TOO_MANY;
		} else if (!strcasecmp(str, DCC_XHDR_THOLD_NEVER)) {
			l = THOLD_NEVER;
		} else {
			return DCC_TGTS_INVALID;
		}
	}

	if (l <= DCC_TGTS_TOO_MANY) {
		/* You cannot have a reputation worse than 100%.
		 * Use "never" to turn off reputation rejections or logging */
		if (type == DCC_CK_REP_BULK && l > 100)
			return DCC_TGTS_INVALID;
		/* the reputation threshold for "bulk" must be finite */
		if (type == DCC_CK_REP_TOTAL && l >= DCC_TGTS_TOO_MANY)
			return DCC_TGTS_INVALID;
	}

	return l;
}



/* look for a word followed by whitespace */
static const char *
ck_word_white(const char *p,
	      const char *word,
	      int word_len)
{
	int sps;

	if (strncasecmp(p, word, word_len))
		return 0;

	p += word_len;
	sps = strspn(p, DCC_WHITESPACE);
	if (sps == 0)
		return 0;

	return p+sps;
}



/* parse DCC thresholds */
static u_char
option_thold(DCC_EMSG *emsg, WF *wf,
	     const char *opt,
	     DCC_FNM_LNO_BUF *fnm_buf,
	     DCC_FNM_LNO_BUF *thold_fnm_buf)
{
	const char *thold_type, *thold;
	DCC_TGTS thold_tgts;
	DCC_CK_TYPES type, t2;
	u_char result;

	thold_type = ck_word_white(opt, "threshold", LITZ("threshold"));
	if (!thold_type) {
		/* it is not a threshold setting */
		dcc_pemsg(EX_DATAERR, emsg,
			  "unrecognized \"option %s\"%s",
			  opt, wf_fnm_lno(fnm_buf, wf));
		return 0;
	}

	thold = strchr(thold_type, ',');
	if (!thold_type) {
		dcc_pemsg(EX_DATAERR, emsg,
			  "no comma in \"option %s\"%s",
			  opt, wf_fnm_lno(fnm_buf, wf));
		return 0;
	}

	type = dcc_str2type_thold(thold_type, thold - thold_type);
	if (type == DCC_CK_INVALID) {
		dcc_pemsg(EX_DATAERR, emsg,
			  "unknown checksum type in \"option %s\"%s",
			  opt, wf_fnm_lno(fnm_buf, wf));
		return 0;
	}
	thold_tgts = dcc_str2thold(type, ++thold);
	if (thold_tgts == DCC_TGTS_INVALID) {
		dcc_pemsg(EX_DATAERR, emsg,
			  "unrecognized threshold in \"option %s\"%s",
			  opt, wf_fnm_lno(fnm_buf, wf));
		return 0;
	}


	wf_fnm_lno(thold_fnm_buf, wf);
	result = 1;
	for (t2 = DCC_CK_TYPE_FIRST; t2 <= DCC_CK_TYPE_LAST; ++t2) {
		if (!(t2 == type
		      || (type == SET_ALL_THOLDS && IS_ALL_CKSUM(t2))
		      || (type == SET_CMN_THOLDS && IS_CMN_CKSUM(t2))))
			continue;
		if (wf->wtbl->hdr.tholds_rej.t[t2] != THOLD_UNSET
		    && wf->wtbl->hdr.tholds_rej.t[t2] != thold_tgts) {
			if (result)
				dcc_pemsg(EX_DATAERR, emsg,
					  "conflicting threshold setting%s",
					  thold_fnm_buf->b);
			result = 0;
		} else {
			wf->wtbl->hdr.tholds_rej.t[t2] = thold_tgts;
			wf->wtbl_fgs |= WHITE_FG_HAVE_THOLDS;
			wf->wtbl->hdr.fgs = wf->wtbl_fgs;
		}
	}

	return result;
}



/* honor controls in client whitelists of the forms:
 *	option log-{all,normal}
 *	option log-subdirectory-{day,hour,minute}
 *	option greylist-{on,off,
 *			ignore-spam-on,ignore-spam-off,
 *			log-on,log-off}
 *	option DCC-{on,off}
 *	option DCC-rep-{on,off}
 *	option dnsbl {1,2,3}-{on,off}
 *	option dnsbl-{on,off}		obsolete
 *	option MTA-{first,last}
 *	option forced-discard-ok
 *	option no-forced-discard
 *	option forced-discard-nok	obsolete
 *	option threshold CKSUM,THOLD
 *	option spam-trap-discard
 *	option spam-trap-reject
 *	option not-spam-trap
 * change the sample whiteclnt file when this changes
 */
static u_char
parse_option(DCC_EMSG *emsg,
	     WF *wf,
	     const char *opt,
	     DCC_FNM_LNO_BUF *fnm_buf,
	     DCC_FNM_LNO_BUF *thold_fnm_buf)
{
	static const struct {
	    const char	*str;
	    int		len;
	    WHITE_SWS	on;		/* turn on this bit */
	    WHITE_SWS	conflicts;	/* conflict with these bits */
	} *tp, *tp1, tbl[] = {
#	    define DE(s,on,conflicts) {s, LITZ(s), on, conflicts},
#	    define DE_DNSBL(s,n) DE("DNSBL"s"-on", WHITE_SW_DNSBL_ON(n),    \
				    WHITE_SW_DNSBL_OFF(n) | WHITE_SW_TRAPS) \
		DE("DNSBL"s"-off", WHITE_SW_DNSBL_OFF(n),		    \
		   WHITE_SW_DNSBL_ON(n))
	    DE("log-all",
	       WHITE_SW_LOG_ALL,
	       WHITE_SW_LOG_NORMAL)
	    DE("log-normal",
	       WHITE_SW_LOG_NORMAL,
	       WHITE_SW_LOG_ALL)

	    DE("log-subdirectory-day",
	       WHITE_SW_LOG_D,
	       WHITE_SW_LOG_H | WHITE_SW_LOG_M)
	    DE("log-subdirectory-hour",
	       WHITE_SW_LOG_H,
	       WHITE_SW_LOG_D | WHITE_SW_LOG_M)
	    DE("log-subdirectory-minute",
	       WHITE_SW_LOG_M,
	       WHITE_SW_LOG_D | WHITE_SW_LOG_H)

	    DE("greylist-on",
	       WHITE_SW_GREY_ON,
	       WHITE_SW_GREY_OFF)
	    DE("greylist-off",
	       WHITE_SW_GREY_OFF,
	       WHITE_SW_GREY_ON)

	    DE("greylist-ignore-spam-on",
	       WHITE_SW_GREY_SPAM_ON,
	       WHITE_SW_GREY_SPAM_OFF)
	    DE("greylist-ignore-spam-off",
	       WHITE_SW_GREY_SPAM_OFF,
	       WHITE_SW_GREY_SPAM_ON)

	    DE("greylist-log-on",
	       WHITE_SW_GREY_LOG_ON,
	       WHITE_SW_GREY_LOG_OFF)
	    DE("greylist-log-off",
	       WHITE_SW_GREY_LOG_OFF,
	       WHITE_SW_GREY_LOG_ON)

	    DE("DCC-on",
	       WHITE_SW_DCC_ON,
	       WHITE_SW_DCC_OFF)
	    DE("DCC-off",
	       WHITE_SW_DCC_OFF,
	       WHITE_SW_DCC_ON
	       | WHITE_SW_TRAP_DIS | WHITE_SW_TRAP_REJ)

	    DE("forced-discard-ok",
	       WHITE_SW_DISCARD_OK,
	       WHITE_SW_DISCARD_NO)
	    DE("no-forced-discard",
	       WHITE_SW_DISCARD_NO,
	       WHITE_SW_DISCARD_OK
	       | WHITE_SW_TRAP_DIS | WHITE_SW_TRAP_REJ)
	    DE("no_forced-discard",	/* bug that might still be in use */
	       WHITE_SW_DISCARD_NO,
	       WHITE_SW_DISCARD_OK
	       | WHITE_SW_TRAP_DIS | WHITE_SW_TRAP_REJ)
	    DE("forced-discard-nok",	/* obsolete */
	       WHITE_SW_DISCARD_NO,
	       WHITE_SW_DISCARD_OK
	       | WHITE_SW_TRAP_DIS | WHITE_SW_TRAP_REJ)

	    DE("MTA-first",
	       WHITE_SW_MTA_FIRST,
	       WHITE_SW_MTA_LAST)
	    DE("MTA-last",
	       WHITE_SW_MTA_LAST,
	       WHITE_SW_MTA_FIRST)

	    DE("DCC-rep-on",
	       WHITE_SW_REP_ON,
	       WHITE_SW_REP_OFF)
	    DE("DCC-rep-off",
	       WHITE_SW_REP_OFF,
	       WHITE_SW_REP_ON)
	    DE("DCC-reps-on",		/* obsolete */
	       WHITE_SW_REP_ON,
	       WHITE_SW_REP_OFF)
	    DE("DCC-reps-off",		/* obsolete */
	       WHITE_SW_REP_OFF,
	       WHITE_SW_REP_ON)

	    DE_DNSBL("1",0)
	    DE_DNSBL("2",1)
	    DE_DNSBL("3",2)
	    DE_DNSBL("4",3)
	    DE_DNSBL(,0)		/* obsolete */

	    DE(DCC_XHDR_TRAP_NOT,
	       WHITE_SW_TRAP_NOT,
	       WHITE_SW_TRAPS)

	    DE(DCC_XHDR_TRAP_DIS,
	       WHITE_SW_TRAP_DIS,
	       WHITE_SW_TRAP_REJ | WHITE_SW_TRAP_NOT
	       | WHITE_SW_DCC_OFF | WHITE_SW_REP_OFF
	       | WHITE_SW_DNSBL_ON_M | WHITE_SW_DISCARD_NO)
	    DE("spam-trap-accept",	/* obsolete */
	       WHITE_SW_TRAP_DIS,
	       WHITE_SW_TRAP_REJ | WHITE_SW_TRAP_NOT
	       | WHITE_SW_DCC_OFF | WHITE_SW_REP_OFF
	       | WHITE_SW_DNSBL_ON_M | WHITE_SW_DISCARD_NO)

	    DE(DCC_XHDR_TRAP_REJ,
	       WHITE_SW_TRAP_REJ,
	       WHITE_SW_TRAP_DIS | WHITE_SW_TRAP_NOT
	       | WHITE_SW_DCC_OFF | WHITE_SW_REP_OFF
	       | WHITE_SW_DNSBL_ON_M)

#	    undef DE
	};

	int i;
	WHITE_FGS conflicts;

	i = strlen(opt);
	for (tp = tbl; ; ++tp) {
		/* try a threshold if not a boolean option */
		if (tp > LAST(tbl))
			return option_thold(emsg, wf, opt,
					    fnm_buf, thold_fnm_buf);
		if (i == tp->len && !strcasecmp(tp->str, opt))
			break;
	}

	conflicts = (wf->wtbl_sws & tp->conflicts);
	if (conflicts != 0) {
		wf->wtbl->hdr.sws = wf->wtbl_sws;
		for (tp1 = tbl; tp1 <= LAST(tbl); ++tp1) {
			if ((tp1->on & conflicts) != 0) {
				dcc_pemsg(EX_DATAERR, emsg,
					  "\"option %s\"%s conflicts with "
					  "\"option %s\"",
					  opt, wf_fnm_lno(fnm_buf, wf),
					  tp1->str);
				return 0;
			}
		}
		dcc_pemsg(EX_DATAERR, emsg,
			  "conflicting \"option %s\"%s",
			  opt, wf_fnm_lno(fnm_buf, wf));
		return 0;
	}

	wf->wtbl_sws |= tp->on;
	wf->wtbl->hdr.sws = wf->wtbl_sws;
	return 1;
}



int					/* -1=fatal 0=problems 1=ok */
parse_whitefile(DCC_EMSG *emsg,
		WF *wf,
		int main_fd,		/* main file */
		DCC_PARSED_CK_FNC add_fnc,
		DCC_PARSED_CK_RANGE_FNC range_fnc)
{
	struct f {
	    int	    fd;
	    char    *start;
	    char    *eob;
	    DCC_PATH path;
	    char    c[1024];
	} main_buf, inc_buf, *cur_buf;
	char tgts_buf[16];
	char *bol, *eol, *type_nm, *ck;
	const char *nmp, *opt;
	DCC_FNM_LNO_BUF fnm_buf;
	DCC_FNM_LNO_BUF white_fnm_buf;
	DCC_FNM_LNO_BUF thold_fnm_buf;
	DCC_TGTS new_tgts;
	DCC_CK_TYPES type;
	struct stat sb;
	int white_fno;
	int main_lno;
	u_char result, hex;
	int i, j;

	result = 1;
	white_fnm_buf.b[0] = '\0';
	thold_fnm_buf.b[0] = '\0';
	main_buf.fd = main_fd;
	main_buf.eob = main_buf.c;
	main_buf.start = main_buf.c;
	cur_buf = &main_buf;
	wf->fno = white_fno = 0;
	wf->lno = main_lno = 0;
	new_tgts = DCC_TGTS_INVALID;
	for (;;) {
next_line:;
		/* Each substantive line has one of the forms:
		 *	tgts	[hex] type	string
		 *		[hex] type	string
		 *	include	pathname
		 *	option ...
		 * A missing number of targets means the line has the
		 * same number of targets as the previous line */

		++wf->lno;
		for (;;) {
			/* continue getting more text until we have an
			 * end-of-line in the buffer */
			if (cur_buf->start < cur_buf->eob) {
				eol = memchr(cur_buf->start, '\n',
					     cur_buf->eob - cur_buf->start);
				if (eol)
					break;
			}

			if (cur_buf->start != cur_buf->c) {
				i = cur_buf->eob - cur_buf->start;
				if (i > 0)
					memmove(cur_buf->c, cur_buf->start, i);
				cur_buf->start = cur_buf->c;
				cur_buf->eob = &cur_buf->c[i];
			}
			j = &cur_buf->c[sizeof(cur_buf->c)] - cur_buf->eob;
			if (j <= 0) {
				dcc_pemsg(EX_DATAERR, emsg,
					  "line too long%s",
					  wf_fnm_lno(&fnm_buf, wf));
				result = 0;
			} else {
				i = read(cur_buf->fd, cur_buf->eob, j);
				if (i > 0) {
					cur_buf->eob += i;
					continue;
				}

				if (i < 0) {
					dcc_pemsg(EX_IOERR, emsg,
						  "read(%s, %d): %s",
						  wf_fnm(wf, wf->fno), j,
						  ERROR_STR());
					result = 0;
				}
				/* act as if the last line in the file ends
				 * with '\n' even if it does not */
				if (cur_buf->start < cur_buf->eob) {
					eol = cur_buf->eob++;
					break;
				}
			}
			if (cur_buf == &main_buf)
				return result;
			if (0 > close(cur_buf->fd)) {
				dcc_pemsg(EX_IOERR, emsg, "close(%s): %s",
					  wf_fnm(wf, wf->fno), ERROR_STR());
				result = 0;
			}
			/* return to the main file at end of included file */
			cur_buf = &main_buf;
			wf->fno = 0;
			wf->lno = main_lno;
			new_tgts = DCC_TGTS_INVALID;
			continue;
		}
		bol = cur_buf->start;
		cur_buf->start = eol+1;

		/* trim trailing blanks */
		do {
			*eol-- = '\0';
		} while (eol > bol
			 && (*eol == ' ' || *eol == '\t' || *eol == '\r'));

		/* Ignore blank lines and lines starting with '#' */
		type_nm = bol+strspn(bol, DCC_WHITESPACE);
		if (*type_nm == '\0' || *type_nm == '#')
			goto next_line;

		/* parse
		 *	include	pathname */
		nmp = ck_word_white(type_nm, "include", LITZ("include"));
		if (nmp) {
			DCC_PATH nm;

			/* can't continue list of identical/missing target
			 * counts into included file */
			new_tgts = DCC_TGTS_INVALID;

			if (cur_buf != &main_buf) {
				dcc_pemsg(EX_DATAERR, emsg,
					  "nested \"include\" not allowed%s",
					  wf_fnm_lno(&fnm_buf, wf));
				result = 0;
				goto next_line;
			}

			/* trim quotes if present from the file name */
			i = strlen(nmp);
			if (i > 1
			    && ((nmp[0] == '"' && nmp[i-1] == '"')
				|| (nmp[0] == '<' &&
				    i > 1 && nmp[i-1] == '>'))) {
				++nmp;
				i -= 2;
			}

			if (i == 0) {
				dcc_pemsg(EX_DATAERR, emsg,
					  "missing file name%s",
					  wf_fnm_lno(&fnm_buf, wf));
				result = 0;
				goto next_line;
			}
			if (i >= ISZ(DCC_PATH)) {
				dcc_pemsg(EX_DATAERR, emsg,
					  "file name too long in"
					  " \"include %.32s...\"%s",
					  nmp, wf_fnm_lno(&fnm_buf, wf));
				result = 0;
				goto next_line;
			}
			memcpy(nm.c, nmp, i);
			nm.c[i] = '\0';
			if (white_fno >= DIM(wf->wtbl->hdr.white_incs)) {
				dcc_pemsg(EX_DATAERR, emsg,
					  "too many \"include\" files%s",
					  wf_fnm_lno(&fnm_buf, wf));
				result = 0;
				goto next_line;
			}

			if (!dcc_fnm2rel(&wf->wtbl->hdr.white_incs[white_fno
							].nm,
					 nm.c, 0)) {
				dcc_pemsg(EX_DATAERR, emsg,
					  "name \"%s\" too long%s",
					  nm.c, wf_fnm_lno(&fnm_buf, wf));
				result = 0;
				goto next_line;
			}

			inc_buf.fd = open(nm.c, O_RDONLY, 0);
			if (inc_buf.fd < 0) {
				dcc_pemsg(EX_DATAERR, emsg,
					  "\"include %s\": %s%s",
					  nm.c, ERROR_STR(),
					  wf_fnm_lno(&fnm_buf, wf));
				result = 0;
				goto next_line;
			}
			inc_buf.eob = inc_buf.c;
			inc_buf.start = inc_buf.c;
			cur_buf = &inc_buf;

			if (0 > fstat(inc_buf.fd, &sb)) {
				wf->wtbl->hdr.white_incs[white_fno].mtime = 0;
			} else {
				wf->wtbl->hdr.white_incs[white_fno
							].mtime = sb.st_mtime;
			}

			wf->fno = ++white_fno;
			main_lno = wf->lno+1;
			wf->lno = 0;
			goto next_line;
		}

		/* honor "option" lines in whiteclnt files */
		opt = ck_word_white(type_nm, "option", LITZ("option"));
		if (opt) {
			/* stop continuation lines when we hit an option */
			new_tgts = DCC_TGTS_INVALID;

			if (!wf->wtbl) {
				dcc_pemsg(EX_DATAERR, emsg, "\"%s\""
					  " not legal in server whitelist%s",
					  type_nm, wf_fnm_lno(&fnm_buf, wf));
				result = 0;
				goto next_line;
			}

			if (!parse_option(emsg, wf, opt, &fnm_buf,
					  &thold_fnm_buf))
				result = 0;
			goto next_line;
		}


		/* Look for the number of targets in a simple line */
		if (type_nm != bol) {
			/* If the line started with white space, the number
			 * of targets is the same as the previous line. */
			*bol = '\0';
		} else {
			type_nm += strcspn(type_nm, DCC_WHITESPACE);
			if (*type_nm == '\0') {
				dcc_pemsg(EX_DATAERR, emsg,
					  "missing type in \"%s\"%s",
					  bol, wf_fnm_lno(&fnm_buf, wf));
				result = 0;
				goto next_line;
			}
			*type_nm++ = '\0';
			/* bol now starts with null-terminated
			 * number of targets, "include", or "log" */
			type_nm += strspn(type_nm, DCC_WHITESPACE);
		}

		ck = type_nm+strcspn(type_nm, DCC_WHITESPACE);

		if (*ck != '\0') {
			/* null terminate the type */
			*ck++ = '\0';
			ck += strspn(ck, DCC_WHITESPACE);
		}

		if (strcasecmp(type_nm, "hex")) {
			hex = 0;
		} else {
			hex = 1;
			type_nm = ck;
			ck = type_nm+strcspn(type_nm, DCC_WHITESPACE);
			if (*ck != '\0') {
				*ck++ = '\0';
				ck += strspn(ck, DCC_WHITESPACE);
			}
		}

		/* parse the target count if it is present instead of blank */
		if (*bol != '\0')
			new_tgts = dcc_str2cnt(bol);
		if (new_tgts == 0 || new_tgts == DCC_TGTS_INVALID) {
			dcc_pemsg(EX_DATAERR, emsg,
				  "missing or invalid # of targets \"%s\"%s",
				  bol, wf_fnm_lno(&fnm_buf, wf));
			new_tgts = DCC_TGTS_INVALID;
			result = 0;
			goto next_line;
		}

		if (*ck == '\0') {
			dcc_pemsg(EX_DATAERR, emsg, "missing value%s",
				  wf_fnm_lno(&fnm_buf, wf));
			new_tgts = DCC_TGTS_INVALID;
			result = 0;
			goto next_line;
		}

		type = dcc_str2type_wf(type_nm, -1);

		if (new_tgts == DCC_TGTS_OK_MX
		    || new_tgts == DCC_TGTS_OK_MXDCC
		    || new_tgts == DCC_TGTS_SUBMIT_CLIENT) {
			if (type != DCC_CK_IP) {
				dcc_pemsg(EX_DATAERR, emsg,
					  new_tgts == DCC_TGTS_SUBMIT_CLIENT
					  ? "client must be an IP address%s"
					  : "MX server must be an IP address%s",
					  wf_fnm_lno(&fnm_buf, wf));
				new_tgts = DCC_TGTS_INVALID;
				result = 0;
				goto next_line;
			}
			if (wf->wf_flags & WF_PER_USER) {
				dcc_pemsg(EX_DATAERR, emsg,
					  "%s illegal in per-user whitelist%s",
					  tgts2str(tgts_buf, sizeof(tgts_buf),
						   new_tgts, 0),
					  wf_fnm_lno(&fnm_buf, wf));
				new_tgts = DCC_TGTS_INVALID;
				result = 0;
				goto next_line;
			}
		}

		/* Look for the type of the checksum, compute the checksum,
		 * and write the checksum to the hash table file.
		 * Write all of its aliases if it is a host name. */
		if (hex) {
			i = dcc_parse_hex_ck(emsg, wf,
					     type_nm, type, ck, new_tgts,
					     add_fnc);
		} else {
			i = dcc_parse_ck(emsg, wf,
					 type_nm, type, ck, new_tgts,
					 add_fnc, range_fnc);
		}
		/* give up on a fatal problem adding a checksum to the file */
		if (i < 0)
			break;
		if (i == 0)
			result = 0;
		else if (new_tgts == DCC_TGTS_OK || new_tgts == DCC_TGTS_OK2)
			wf_fnm_lno(&white_fnm_buf, wf);
	}

	/* fatal problem such as writing to the file */
	if (cur_buf != &main_buf)
		close(cur_buf->fd);
	return -1;
}
