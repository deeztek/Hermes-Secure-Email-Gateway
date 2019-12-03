/* Distributed Checksum Clearinghouse
 *
 * client-ID and password parsing
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
 * Rhyolite Software DCC 2.3.167-1.65 $Revision$
 */

#include "dcc_clnt.h"
#include "dcc_ids.h"
#include "dcc_xhdr.h"
#include "dcc_heap_debug.h"


DCC_PATH ids_path;

time_t ids_mtime;


static ID_TBL **id_tbl_hash;
static u_int id_tbl_bins, id_tbl_blocks;
static ID_TBL *id_tbl_free;
#define ID_HASH_ENTRY(id) id_tbl_hash[(id) % id_tbl_bins]
static u_int id_probes, id_searches;


/* Make more ID blocks.
 * IDs come from either the local /var/dcc/ids file or
 * server IDs in floods.  There are fewer than 65536 possible
 * server-IDs.  It would be bad but should not crash a system
 * to see 65536 server-IDs. */
static void
id_make_blocks(u_char debug)
{
	ID_TBL *tp;
	double rate;
	int i;

	i = 128;
	if (debug && id_searches != 0) {
		rate = id_probes / id_searches;
		dcc_trace_msg("increase from %d to %d ID entries with"
			      " %d bins; average search length %.1f",
			      id_tbl_blocks, id_tbl_blocks+i,
			      id_tbl_bins, rate);
	}

	id_tbl_blocks += i;
	tp = dcc_malloc(i*sizeof(*tp));
	do {
		tp->hfwd = id_tbl_free;
		id_tbl_free = tp;
	} while (++tp, --i > 0);
}



/* link an ID block into the head of its hash bin */
static void
id_tbl_link(ID_TBL *tp, ID_TBL **bin)
{
	if (*bin == tp)
		return;

	if (tp->hbak != 0)
		tp->hbak->hfwd = tp->hfwd;
	if (tp->hfwd != 0)
		tp->hfwd->hbak = tp->hbak;

	tp->hbak = 0;
	tp->hfwd = *bin;
	if (tp->hfwd != 0)
		tp->hfwd->hbak = tp;
	*bin = tp;
}



static void
id_tbl_expand_hash(u_char debug)
{
	u_int old_bins;
	ID_TBL *tp, **old_bin, **old_hash;
	double rate;
	int i;

	old_hash = id_tbl_hash;
	old_bins = id_tbl_bins;

	i = (max(id_tbl_blocks, id_tbl_bins)*3)/2;
	id_tbl_bins = hash_divisor(i, 0);

	if (id_tbl_bins != old_bins) {
		id_tbl_hash = dcc_malloc(id_tbl_bins*sizeof(*id_tbl_hash));
		if (!id_tbl_hash)
			dcc_logbad(EX_OSERR, "malloc(%d ID hash table) failed",
				   id_tbl_bins);
		memset(id_tbl_hash, 0, id_tbl_bins*sizeof(ID_TBL *));

		if (old_hash) {
			if (debug) {
				rate = id_probes;
				if (id_searches != 0)
					rate /= id_searches;
				dcc_trace_msg("increase from %d to %d"
					      " ID bins for %d blocks;"
					      " average search length %.1f",
					      old_bins, id_tbl_bins,
					      id_tbl_blocks, rate);
			}
			/* copy the blocks to the new hash table of bins */
			for (old_bin = &old_hash[0];
			     old_bin < &old_hash[old_bins];
			     ++old_bin) {
				while ((tp = *old_bin) != 0) {
					*old_bin = tp->hfwd;
					tp->hbak = 0;
					tp->hfwd = 0;
					id_tbl_link(tp, &ID_HASH_ENTRY(tp->id));
				}
			}
			dcc_free(old_hash);
		}
	}

	id_probes = 0;
	id_searches = 0;
}



/* add an ID_TBL entry that is known to be absent */
ID_TBL *
add_id_tbl(DCC_CLNT_ID id, ID_TBL ***binp, u_char debug)
{
	ID_TBL *tp, **bin;

	if (binp)
		bin = *binp;
	else
		bin = &ID_HASH_ENTRY(id);

	tp = id_tbl_free;
	if (!tp) {
		id_make_blocks(debug);
		bin = &ID_HASH_ENTRY(id);
		if (binp)
			*binp = bin;
		tp = id_tbl_free;
	}
	id_tbl_free = tp->hfwd;

	memset(tp, 0, sizeof(*tp));
	tp->id = id;
	id_tbl_link(tp, bin);

	return tp;
}



/* find an ID_TBL entry
 * on success, expand the hash table if searching has been slow */
ID_TBL *
find_id_tbl(DCC_CLNT_ID id, u_char debug)
{
	ID_TBL *tp, **bin;

	++id_searches;

	bin = &ID_HASH_ENTRY(id);
	for (tp = *bin; tp != 0; tp = tp->hfwd) {
		++id_probes;
		if (tp->id == id) {
			if ((id_probes*10)/id_searches > 11) {
				if (id_searches > 100) {
					id_tbl_expand_hash(debug);
				} else {
					/* move hot IDs to head of bins */
					id_tbl_link(tp, bin);
				}
			} else if (id_searches > 10000) {
				/* prevent overflow */
				id_probes /= 2;
				id_searches /= 2;
			}
			return tp;
		}
	}

	return 0;
}



/* enumerate ID_TBL entries */
ID_TBL *
enum_ids(ID_TBL *tp)
{
	ID_TBL **tpp;

	if (!tp) {
		/* start at the beginning if we have not already started */
		tpp = &id_tbl_hash[0];
	} else {
		/* return the next entry in the current chain if there is one */
		if (tp->hfwd)
			return tp->hfwd;
		/* otherwise find the next chain */
		tpp = &ID_HASH_ENTRY(tp->id)+1;
	}
	while (tpp < &id_tbl_hash[id_tbl_bins]) {
		tp = *tpp;
		if (tp)
			return tp;
		++tpp;
	}
	return 0;
}



u_char					/* 0=bad 1=ok 2=forever */
parse_dccd_delay(DCC_EMSG *emsg,
		 u_int32_t *delay_usp,
		 u_int *delay_inflatep,
		 const char *val,
		 const char *fnm, int lno)
{
	DCC_FNM_LNO_BUF fnm_buf;
	u_int32_t delay_ms;
	u_long l;
	char *p1, *p2;

	*delay_usp = DCC_ANON_DELAY_US_BLACKLIST;
	*delay_inflatep = DCC_ANON_INFLATE_OFF;
	if (!strcasecmp(val, "forever"))
		return 2;

	delay_ms = strtoul(val, &p1, 10);

	if (delay_ms > DCC_ANON_DELAY_US_BLACKLIST/1000) {
		dcc_pemsg(EX_DATAERR, emsg, "invalid delay \"%s\"%s > %d", val,
			  dcc_fnm_lno(&fnm_buf, fnm, lno),
			  DCC_ANON_DELAY_US_BLACKLIST/1000);
		return 0;
	} else if (*p1 == '\0') {
		*delay_inflatep = DCC_ANON_INFLATE_OFF;
	} else if (*p1 != ',' && *p1 != '*') {
		dcc_pemsg(EX_DATAERR, emsg, "unrecognized delay \"%s\"%s", val,
			  dcc_fnm_lno(&fnm_buf, fnm, lno));
		return 0;
	} else {
		l = strtoul(++p1, &p2, 10);
		if (*p2 != '\0') {
			dcc_pemsg(EX_DATAERR, emsg,
				  "unrecognized delay inflation \"%s\"%s",
				  p1,
				  dcc_fnm_lno(&fnm_buf, fnm, lno));
			return 0;
		}
		if (l == 0)
			l = DCC_ANON_INFLATE_OFF;
		*delay_inflatep = l;
	}

	*delay_usp = delay_ms*1000;
	return 1;
}



u_char
set_ids_path(DCC_EMSG *emsg, const char *ids_nm)
{
	if (!ids_nm || ids_nm[0] == '\0')
		ids_nm = IDS_NM_DEF;
	if (!dcc_fnm2rel(&ids_path, ids_nm, 0)) {
		dcc_pemsg(EX_DATAERR, emsg, "\"%s\" is a bad ids file name",
			  ids_nm);
		return 0;
	}
	return 1;
}




static u_char				/* 1=id is an acceptable ID */
client_server(DCC_EMSG *emsg,
	      u_char srvrs_only,	/* 1=no client-IDs */
	      DCC_CLNT_ID id,		/* target number */
	      const char *str, int lno)
{
	DCC_FNM_LNO_BUF fnm_buf;

	if (id >= DCC_CLNT_ID_MIN && id <= DCC_CLNT_ID_MAX) {
		/* we have a client-ID */
		if (!srvrs_only)
			return 1;
		dcc_pemsg(EX_DATAERR, emsg, "\"%s\" only for server-IDs%s",
			  str, dcc_fnm_lno(&fnm_buf, ids_path.c, lno));
		return 0;
	}

	/* we have a server-ID */
	if (srvrs_only)
		return 1;

	dcc_pemsg(EX_DATAERR, emsg, "%s only for client-IDs%s",
		  str, dcc_fnm_lno(&fnm_buf, ids_path.c, lno));
	return 0;
}



/* (re)load the client-ID and password database
 * -1=failed to find target,  0=sick file,  1=ok,  2=file unchanged */
int
load_ids(DCC_EMSG *emsg,
	 DCC_CLNT_ID tgt_id,		/* DCC_ID_ANON or needed ID */
	 const ID_TBL **tgt_tbl,
	 u_char force,
	 u_char debug)
{
	DCC_PATH tmp;
	DCC_FNM_LNO_BUF fnm_buf;
	ID_TBL t, *tp, **tpp, **bin;
	FILE *f;
	int lno, passwords;
	u_char found_it;
	int result;
	char buf[sizeof(ID_TBL)*2+1];
	const char *bufp, *passbuf;
	char id_buf[30];
	struct stat sb;
	char *p, *p1;

	if (!id_tbl_blocks) {
		id_make_blocks(debug);
		id_tbl_expand_hash(debug);
	}

	if (tgt_tbl)
		*tgt_tbl = 0;

	if (!set_ids_path(emsg, 0))
		return -1;

	if (!force) {
		if (!dcc_ck_private(emsg, &sb, ids_path.c, -1)) {
			ids_mtime = 0;
			return -1;
		}

		if (ids_mtime == sb.st_mtime)
			return 2;
	}

	f = fopen(ids_path.c, "r");
	if (!f) {
		dcc_pemsg(EX_NOINPUT, emsg, "fopen(%s): %s",
			  dcc_fnm2abs_msg(&tmp, ids_path.c), ERROR_STR());
		return -1;
	}

	/* the file contains passwords, so refuse to use it if anyone else
	 * can read it */
	if (!dcc_ck_private(emsg, &sb, ids_path.c, fileno(f))) {
		fclose(f);
		ids_mtime = 0;
		return -1;
	}

	/* empty the table by making all entries into placeholders */
	memset(&t, 0, sizeof(t));
	for (tpp = &id_tbl_hash[0]; tpp < &id_tbl_hash[id_tbl_bins]; ++tpp) {
		for (tp = *tpp; tp; tp = tp->hfwd) {
			t.hfwd = tp->hfwd;
			t.hbak = tp->hbak;
			t.id = tp->id;
			*tp = t;
		}
	}

	ids_mtime = sb.st_mtime;

	passwords = 0;
	lno = 0;
	result = 1;
	found_it = (tgt_id == DCC_ID_ANON);
	for (;;) {
		/* read and parse a line contain a client-ID and key(s) */
		bufp = fgets(buf, sizeof(buf), f);
		if (!bufp) {
			if (ferror(f) && result > 0) {
				dcc_pemsg(EX_IOERR, emsg, "fgets(%s): %s",
					  dcc_fnm2abs_msg(&tmp, ids_path.c),
					  ERROR_STR());
				result = 0;
			}
			break;
		}
		++lno;

		/* Ignore blank lines and lines starting with '#'.
		 * Note that '#' flags a comment only at the start of
		 * the line to avoid dealing with the escaping hassles
		 * of allowing '#' in passwords. */
		bufp += strspn(bufp, DCC_WHITESPACE);
		if (*bufp == '\0' || *bufp == '#')
			continue;

		memset(&t, 0, sizeof(t));
		t.delay_inflate = DCC_ANON_INFLATE_OFF;

		/* Each substantive line has the form:
		 *	ID[,trace][,rpt-ok][,no-reps]
		 *			[,delay=ms[*inflate]] passwd1 passwd2
		 *	ID,delay=forever
		 *
		 * Placeholders have the from
		 *	ID
		 * or for servers on masters
		 *	ID,simple|ignore|rogue|commerical
		 *
		 *  Both passwords are always accepted.  They are intended
		 *  to be the previous and current or the current and
		 *  next to allow the password to be changed at both the
		 *  client and the server without loss of service. */

		passbuf = dcc_parse_word(emsg, id_buf, sizeof(id_buf),
					 bufp, "ID", ids_path.c, lno);
		if (!passbuf) {
			result = 0;	/* line too long */
			continue;
		}

		/* stop parsing the line if the server-ID is bad */
		p = strchr(id_buf, ',');
		if (p)
			*p++ = '\0';
		t.id = dcc_get_id(emsg, id_buf, ids_path.c, lno);
		if (t.id == DCC_ID_INVALID) {
			result = 0;
			continue;
		}
		if (t.id == DCC_ID_ANON) {
			dcc_pemsg(EX_DATAERR, emsg,
				  "invalid ID \"%s\"%s",
				  id_buf, dcc_fnm_lno(&fnm_buf,
						      ids_path.c, lno));
			result = 0;
			continue;
		}

		/* parse the options */
		for (; p; p = p1) {
			p1 = strchr(p, ',');
			if (p1)
				*p1++ = '\0';

			if (!strcasecmp(p, "trace")) {
				if (!client_server(emsg, 0, t.id, p, lno)) {
					result = 0;
				} else {
					t.flags |= ID_FLG_TRACE;
				}
				continue;
			}

			if (!strcasecmp(p, "rpt-ok")
			    || !strcasecmp(p, "rpt_ok")) {
				if (!client_server(emsg, 0, t.id, p, lno)) {
					result = 0;
				} else {
					t.flags |= ID_FLG_RPT_OK;
				}
				continue;
			}

			if (!strcasecmp(p, "no-reps")
			    || !strcasecmp(p, "no_reps")) {
				if (!client_server(emsg, 0, t.id, p, lno)) {
					result = 0;
				} else {
					t.flags |= ID_FLG_NO_REPS;
				}
				continue;
			}

			if (!CLITCMP(p, "delay=")) {
				if (!client_server(emsg, 0, t.id, p, lno)) {
					result = 0;
				} else if (!parse_dccd_delay(emsg, &t.delay_us,
							&t.delay_inflate,
							p+LITZ("delay="),
							ids_path.c, lno)) {
					result = 0;
				} else {
					t.flags |= ID_FLG_DELAY_SET;
				}
				continue;
			}

			if (!strcasecmp(p, DCC_XHDR_ID_SIMPLE)) {
				if (!client_server(emsg, 1, t.id, p, lno)) {
					result = 0;
				} else {
				}
				continue;
			}
			if (!strcasecmp(p, DCC_XHDR_ID_IGNORE)) {
				if (!client_server(emsg, 1, t.id, p, lno)) {
					result = 0;
				}
				continue;
			}
			if (!strcasecmp(p, DCC_XHDR_ID_ROGUE)) {
				if (!client_server(emsg, 1, t.id, p, lno)) {
					result = 0;
				}
				continue;
			}

			dcc_pemsg(EX_DATAERR, emsg,
				  "invalid option \"%s\"%s", p,
				  dcc_fnm_lno(&fnm_buf, ids_path.c, lno));
			result = 0;
		}

		if (*passbuf != '\0') {
			passbuf = parse_passwd(emsg, t.cur_passwd,
					       passbuf, "current password",
					       ids_path.c, lno);
			if (!passbuf) {
				result = 0; /* line too long */
				continue;
			}
			passbuf = parse_passwd(emsg, t.next_passwd,
					       passbuf, "next password",
					       ids_path.c, lno);
			if (!passbuf) {
				result = 0; /* line too long */
				continue;
			}
			if (*passbuf != '\0') {
				dcc_pemsg(EX_DATAERR, emsg,
					  "invalid next password%s",
					  dcc_fnm_lno(&fnm_buf,
						      ids_path.c, lno));
				result = 0;
				continue;
			}
		}

		/* put the entry into the hash table if not already present */
		bin = &ID_HASH_ENTRY(t.id);
		tp = *bin;
		for (;;) {
			if (tp == 0) {
				tp = add_id_tbl(t.id, &bin, debug);
				break;
			} else if (tp->id == t.id) {
				break;
			}
			tp = tp->hfwd;
		}

		/* If the ID is already present, the file is bad unless
		 * the previous or current line is only a placeholder
		 * showing that the ID exists.
		 * Merge from the old entry to the new entry. */
		if (!(t.flags & ID_FLG_DELAY_SET)) {
			t.delay_us = tp->delay_us;
			t.delay_inflate = tp->delay_inflate;
			if (tp->flags & ID_FLG_DELAY_SET)
				t.flags |= ID_FLG_DELAY_SET;
		} else if ((tp->flags & ID_FLG_DELAY_SET)
			   && (t.delay_us != tp->delay_us
			       || t.delay_inflate != tp->delay_inflate)) {
			dcc_pemsg(EX_DATAERR, emsg,
				  "conflicting delays for ID %d%s",
				  t.id, dcc_fnm_lno(&fnm_buf,
						    ids_path.c, lno));
			result = 0;
			continue;
		}
		if (t.cur_passwd[0] == '\0') {
			memcpy(t.cur_passwd, tp->cur_passwd,
			       sizeof(t.cur_passwd));
			memcpy(t.next_passwd, tp->next_passwd,
			       sizeof(t.next_passwd));
		} else {
			if (tp->cur_passwd[0] != '\0'
			    && (memcmp(t.cur_passwd, tp->cur_passwd,
				       sizeof(t.cur_passwd))
				|| memcmp(t.next_passwd, tp->next_passwd,
					  sizeof(t.next_passwd)))) {
				dcc_pemsg(EX_DATAERR, emsg,
					  "conflicting passwords for ID %d%s",
					  t.id,
					  dcc_fnm_lno(&fnm_buf,
						      ids_path.c, lno));
				result = 0;
				continue;
			}
			++passwords;

			/* remember the target */
			if (t.id == tgt_id) {
				found_it = 1;
				if (tgt_tbl)
					*tgt_tbl = tp;
			}
		}
		t.flags |= (tp->flags & (ID_FLG_TRACE | ID_FLG_RPT_OK));
		t.hfwd = tp->hfwd;
		t.hbak = tp->hbak;
		*tp = t;
	}
	fclose(f);

	if (!passwords) {
		if (result > 0)
			dcc_pemsg(EX_DATAERR, emsg, "%s contains no passwords",
				  dcc_fnm2abs_msg(&tmp, ids_path.c));
		result = -1;
	}
	if (!found_it) {
		if (result > 0)
			dcc_pemsg(EX_DATAERR, emsg,
				  "%s does not contain the password for ID %d",
				  dcc_fnm2abs_msg(&tmp, ids_path.c), tgt_id);
		result = -1;
	}

	id_probes = 0;
	id_searches = 0;

	return result;
}
