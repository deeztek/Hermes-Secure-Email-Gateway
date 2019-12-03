/* Distributed Checksum Clearinghouse
 *
 * deal with outgoing floods of checksums
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
 * Rhyolite Software DCC 2.3.167-1.195 $Revision$
 */

#include "dccd_defs.h"
#include "dcc_ck.h"
#include <signal.h>


int flods_off;				/* # of reasons flooding is off */

time_t next_flods_ck;
time_t flod_mtime = 1;
enum FLODS_ST flods_st = FLODS_ST_OFF;
OFLODS oflods;

/* records after this have not been flooded
 *	0 if invalid */
DB_PTR oflods_max_cur_pos;

int summarize_delay_secs;		/* delay summaries by this */
DB_PTR summarize_limit;
time_t summarize_limit_secs;


static void oflod_fill(OFLOD_INFO *);


/* the socket must already be closed */
static void
oflod_clear(OFLOD_INFO *ofp)
{
	memset(ofp, 0, sizeof(*ofp));
	ofp->soc = -1;
}



void
oflods_clear(void)
{
	OFLOD_INFO *ofp;

	iflods_stop("", 1);		/* paranoia */

	flod_unmap(0, &dccd_stats);

	for (ofp = oflods.infos; ofp <= LAST(oflods.infos); ++ofp)
		oflod_clear(ofp);
	oflods.total = 0;
	complained_many_iflods = 0;
	oflods_max_cur_pos = 0;
}



/* parse ID1->tgt in a flood file entry */
static char
oflod_parse_map(FLOD_OPTS *opts, const char *str0, int lno)
{
	DCC_FNM_LNO_BUF fnm_buf;
	const char *str;
	SRVR_ID_MAP *imp;

	if (opts->maps.len >= DIM(opts->maps.entry)) {
		dcc_error_msg("too many ID mappings with\"%s\"%s",
			      str0, dcc_fnm_lno(&fnm_buf, flod_path.c, lno));
		return 0;
	}
	imp = &opts->maps.entry[opts->maps.len];

	if (!CLITCMP(str0, "self->")) {
		str = str0+LITZ("self->");
		imp->lo = imp->hi = my_srvr_id;
	} else if (!CLITCMP(str0, "all->")) {
		str = str0+LITZ("all->");
		imp->lo = DCC_SRVR_ID_MIN;
		imp->hi = DCC_SRVR_ID_MAX;
	} else {
		/* get ID1 */
		str = dcc_get_srvr_id(0, &imp->lo, str0, "-",
				      flod_path.c, lno);
		if (!str)
			return 0;
		if (str[0] == '-' && str[1] == '>') {
			/* ID1 is not a range */
			imp->hi = imp->lo;
		} else {
			/* ID1 is a range of IDs */
			str = dcc_get_srvr_id(0, &imp->hi,
					      str+1, "-", flod_path.c, lno);
			if (!str)
				return 0;
			if (imp->hi < imp->lo) {
				dcc_error_msg("invalid ID mapping range "
					      "\"%d-%d\"%s",
					      imp->lo, imp->hi,
					      dcc_fnm_lno(&fnm_buf,
							flod_path.c, lno));
				return 0;
			}
		}
		if (*str++ != '-' || *str++ != '>') {
			dcc_error_msg("invalid server-ID mapping \"%s\"%s",
				      str0,
				      dcc_fnm_lno(&fnm_buf, flod_path.c, lno));
			return 0;
		}
	}
	if (!strcasecmp(str, "self")) {
		imp->result = ID_MAP_SELF;
	} else if (!strcasecmp(str, "reject")) {
		imp->result = ID_MAP_REJ;
	} else if (!strcasecmp(str, "ok")) {
		imp->result = ID_MAP_NO;
	} else {
		dcc_error_msg("invalid ID mapping result \"%s\"%s",
			      str, dcc_fnm_lno(&fnm_buf, flod_path.c, lno));
		return 0;
	}

	++opts->maps.len;
	return 1;
}



static u_char
ck_socks_flags(OFLOD_INFO *ofp, OPT_FLAGS new,
	       DCC_FNM_LNO_BUF fnm_buf, int lno)
{
	if (0 != (ofp->o_opts.flags & (FLOD_OPT_PASSIVE | FLOD_OPT_SOCKS
				       | FLOD_OPT_NAT)
		  & ~new)) {
		dcc_error_msg("only one of \"passive\", \"SOCKS\", or \"NAT\""
			      " allowed%s",
			      dcc_fnm_lno(&fnm_buf, flod_path.c, lno));
		return 0;
	}

	ofp->o_opts.flags |= new;
	return 1;
}



/* parse remote or local options that can be any of
 *  a "off", "del", "no-del", "log-del", "passive", ID->map, etc. */
static const char *			/* rest of the line */
parse_flod_opts(OFLOD_INFO *ofp,
		FLOD_OPTS *opts,
		const char *buf, int lno)
{
	DCC_FNM_LNO_BUF fnm_buf;
	char opts_buf[200];
	char opt[20];
	const char *buf_ptr, *p;
	char *end;
	unsigned long l;
	u_int olen;

	/* suppress compiler false alarm uninitialized warning */
	fnm_buf.b[0] = '\0';

	/* pick out the blank delimited string of options */
	buf = dcc_parse_word(0, opts_buf, sizeof(opts_buf),
			     buf, "flood options", flod_path.c, lno);
	if (!buf)
		return 0;

	opts->path_len = DCC_MAX_FLOD_PATH;
	if (grey_on)
		opts->flags |= (FLOD_OPT_DEL_OK
				| FLOD_OPT_NO_LOG_DEL
				| FLOD_OPT_DEL_SET);

	/* parse the options */
	buf_ptr = opts_buf;
	while (*buf_ptr != '\0') {
		if (*buf_ptr == ',') {
			++buf_ptr;
			continue;
		}
		olen = strcspn(buf_ptr, ",");
		if (olen >= sizeof(opt))
			olen = sizeof(opt)-1;
		strncpy(opt, buf_ptr, olen);
		opt[olen] = '\0';
		buf_ptr += olen;

		/* ignore "-" */
		if (!strcmp(opt, "-"))
			continue;

		if (!strcasecmp(opt, "off")) {
			opts->flags |= FLOD_OPT_OFF;
			continue;
		}

		if (!grey_on) {
			if (!strcasecmp(opt, "traps"))	/* obsolete */
				continue;
			if (!strcasecmp(opt, "no-del")) {
				opts->flags &= ~FLOD_OPT_DEL_OK;
				opts->flags |= FLOD_OPT_DEL_SET;
				continue;
			}
			if (!strcasecmp(opt, "del")) {
				opts->flags |= FLOD_OPT_DEL_OK;
				opts->flags |= FLOD_OPT_DEL_SET;
				continue;
			}
		}

		/* put some options in one or the other flag word no matter
		 * for which they are specified */
		if (!strcasecmp(opt, "trace1") || !strcasecmp(opt, "trace")) {
			ofp->o_opts.flags |= FLOD_OPT_TRACE1;
			continue;
		}
		if (!strcasecmp(opt, "trace2")) {
			ofp->o_opts.flags |= FLOD_OPT_TRACE2;
			continue;
		}

		if (!strcasecmp(opt, "no-log-del")) {
			ofp->i_opts.flags |= FLOD_OPT_NO_LOG_DEL;
			continue;
		}
		if (!strcasecmp(opt, "log-del")) {
			ofp->i_opts.flags &= ~FLOD_OPT_NO_LOG_DEL;
			continue;
		}
		if (!strcasecmp(opt, "passive")) {
			if (!ck_socks_flags(ofp, FLOD_OPT_PASSIVE,
					    fnm_buf, lno))
				return 0;
			continue;
		}
		if (!strcasecmp(opt, "socks")) {
			if (!ck_socks_flags(ofp, FLOD_OPT_SOCKS,
					    fnm_buf, lno))
				return 0;
			continue;
		}
		if (!strcasecmp(opt, "nat")) {
			if (!ck_socks_flags(ofp, FLOD_OPT_NAT,
					    fnm_buf, lno))
				return 0;
			continue;
		}
		if (!strcasecmp(opt, "IPv4")) {
			if (ofp->o_opts.flags & FLOD_OPT_IPv6) {
				dcc_error_msg("\"IPv4\" and \"IPv6\";"
					      " cannot both be%s",
					      dcc_fnm_lno(&fnm_buf,
							flod_path.c, lno));
				return 0;
			}
			ofp->o_opts.flags |= FLOD_OPT_IPv4;
			continue;
		}
		if (!strcasecmp(opt, "IPv6")) {
			if (ofp->o_opts.flags & FLOD_OPT_IPv4) {
				dcc_error_msg("\"IPv4\" and \"IPv6\";"
					      " cannot both be%s",
					      dcc_fnm_lno(&fnm_buf,
							flod_path.c, lno));
				return 0;
			}
			ofp->o_opts.flags |= FLOD_OPT_IPv6;
			continue;
		}
		if (!CLITCMP(opt, "leaf=")
		    && (l = strtoul(opt+LITZ("leaf="), &end, 10),
			*end == '\0')) {
			if (l > DCC_MAX_FLOD_PATH) {
				dcc_error_msg("invalid maximum path length in"
					      " \"%s\"",
					      opt);
				return 0;
			}
			ofp->o_opts.path_len = l;
			continue;
		}

#ifdef DCC_FLOD_VERS7
		if (!strcasecmp(opt, "version7")) {
			ofp->oversion = DCC_FLOD_VERS7;
			continue;
		}

#endif
		/* parse an ID->map */
		p = strchr(opt, '>');
		if (p && p > opt && *(p-1) == '-') {
			if (!oflod_parse_map(opts, opt, lno))
				return 0;
			continue;
		}

		dcc_error_msg("unknown option \"%s\"%s",
			      opt, dcc_fnm_lno(&fnm_buf, flod_path.c, lno));
		return 0;
	}

	return buf;
}



static const char *			/* rest of a flod file line */
oflod_parse_id(DCC_SRVR_ID *id,
	       const char *buf, const char *type, int lno)
{
	char id_buf[20];

	buf = dcc_parse_word(0, id_buf, sizeof(id_buf),
			     buf, type, flod_path.c, lno);
	if (!buf)
		return 0;

	if (!strcmp(id_buf, "-")
	    || id_buf[0] == '\0') {
		*id = DCC_ID_INVALID;
		return buf;
	}

	if (!dcc_get_srvr_id(0, id, id_buf, 0, flod_path.c, lno))
		return 0;

	/* do not check whether we know the local ID here, because
	 * changes in the ids file can make that check moot */

	return buf;
}



/* compute the maximum position among all floods */
static void
get_oflods_max_cur_pos(void)
{
	OFLOD_INFO *ofp;

	oflods_max_cur_pos = DB_PTR_BASE;
	for (ofp = oflods.infos; ofp <= LAST(oflods.infos); ++ofp) {
		if (ofp->rem_hostname[0] != '\0'
		    && oflods_max_cur_pos < ofp->cur_pos)
			oflods_max_cur_pos = ofp->cur_pos;
		save_flod_cnts(ofp);
	}
}



static void
copy_opts2mp(OFLOD_INFO *ofp)
{
	FLOD_MMAP *mp;
	FLOD_MMAP_FLAGS mask, new_flags, delta_flags;
	u_char changed;

	mp = ofp->mp;
	changed = 0;

	/* these bits ar controlled here */
	mask = (FLODMAP_FG_NEED_RWD
		| FLODMAP_FG_FFWD_IN
		| FLODMAP_FG_ROGUE
		| FLODMAP_FG_OUT_OFF
		| FLODMAP_FG_IN_OFF
		| FLODMAP_FG_IPv6
		| FLODMAP_FG_IPv4
		| FLODMAP_FG_PASSIVE
		| FLODMAP_FG_SOCKS
		| FLODMAP_FG_NAT
		| FLODMAP_FG_NAT_AUTO
		| FLODMAP_FG_LEAF);
	new_flags = mp->flags & mask;

	/* these are off unless set by the flod file */
	new_flags &= ~(FLODMAP_FG_ROGUE
		       | FLODMAP_FG_OUT_OFF
		       | FLODMAP_FG_IN_OFF
		       | FLODMAP_FG_IPv4
		       | FLODMAP_FG_IPv6
		       | FLODMAP_FG_PASSIVE
		       | FLODMAP_FG_SOCKS
		       | FLODMAP_FG_NAT
		       | FLODMAP_FG_LEAF);

	if (db_parms.flags & DB_PARM_FG_NEED_RWD) {
		new_flags |= FLODMAP_FG_NEED_RWD;
		new_flags &= ~FLODMAP_FG_FFWD_IN;
		changed = 1;
	}

	if (ofp->o_opts.flags & FLOD_OPT_ROGUE)
		new_flags |= FLODMAP_FG_ROGUE;

	if ((ofp->o_opts.flags & FLOD_OPT_OFF))
		new_flags |= FLODMAP_FG_OUT_OFF;

	if (ofp->i_opts.flags & FLOD_OPT_OFF)
		new_flags |= FLODMAP_FG_IN_OFF;

	if (ofp->o_opts.flags & FLOD_OPT_IPv4) {
		new_flags |= FLODMAP_FG_IPv4;
	} else if (ofp->o_opts.flags & FLOD_OPT_IPv6) {
		new_flags |= FLODMAP_FG_IPv6;
	}

	if (ofp->o_opts.flags & FLOD_OPT_PASSIVE) {
		new_flags |= FLODMAP_FG_PASSIVE;
		new_flags &= ~FLODMAP_FG_NAT_AUTO;
	} else if (ofp->o_opts.flags & FLOD_OPT_SOCKS) {
		new_flags |= FLODMAP_FG_SOCKS;
		new_flags &= ~FLODMAP_FG_NAT_AUTO;
	} else if (ofp->o_opts.flags & FLOD_OPT_NAT) {
		new_flags |= FLODMAP_FG_NAT;
		new_flags &= ~FLODMAP_FG_NAT_AUTO;
	}

	if (ofp->o_opts.path_len != DCC_MAX_FLOD_PATH)
		new_flags |= FLODMAP_FG_LEAF;

	delta_flags = (mp->flags ^ new_flags) & mask;
	if (delta_flags != 0) {
		mp->flags ^= delta_flags;
		changed = 1;
		/* force name resolution for change in address family */
		if (delta_flags & (FLODMAP_FG_IPv6 | FLODMAP_FG_IPv4))
			got_hosts = 0;
	}

	memcpy(&mp->i_id_maps, &ofp->i_opts.maps, sizeof(mp->i_id_maps));
	memcpy(&mp->o_id_maps, &ofp->o_opts.maps, sizeof(mp->o_id_maps));

	/* get new host name if it changes */
	if (strcasecmp(mp->rem_hostname, ofp->rem_hostname)) {
		BUFCPY(mp->rem_hostname, ofp->rem_hostname);
		got_hosts = 0;		/* force name resolution for new name */
		changed = 1;
	}
	if (strcasecmp(mp->rem_portname, ofp->rem_portname)) {
		BUFCPY(mp->rem_portname, ofp->rem_portname);
		changed = 1;
	}

	if (strcasecmp(mp->loc_hostname, ofp->loc_hostname)) {
		BUFCPY(mp->loc_hostname, ofp->loc_hostname);
		/* force name resolution for new name */
		got_hosts = 0;
		changed = 1;
	}
	if (mp->loc_port != ofp->loc_port) {
		mp->loc_port = ofp->loc_port;
		changed = 1;
	}

	if (flod_mmaps->ids_mtime != ids_mtime) {
		mp->flags &= ~FLODMAP_FG_USE_2PASSWD;
		changed = 1;
	}

	if (mp->in_passwd_id != ofp->in_passwd_id) {
		mp->in_passwd_id = ofp->in_passwd_id;
		changed = 1;
	}
	if (mp->out_passwd_id != ofp->out_passwd_id) {
		mp->out_passwd_id = ofp->out_passwd_id;
		changed = 1;
	}

	if (changed)
		flod_try_again(ofp, 1);
}



/* Load the hostnames of DCC server peers and their output flood positions.
 *	flod_names_resolve_ck() must say ok before this function is called,
 *	to avoid races with changing host names.
 *
 *	Parse lines of the form
 *	  name,port;name,port rem-ID [passwd-id [out-opts [in-opts [versionX]]]]
 */
u_char					/* 1=start floods, 0=try again later */
load_flod(u_char diag, u_char complain)
{
	DCC_FNM_LNO_BUF fnm_buf;
	OFLOD_INFO *ofp, *ofp1;
	FILE *f;
	struct stat sb;
	int lno;
	char buf[200];
	char hostname[60];
	const char *bufp, *bufp1;
	FLOD_MMAP *mp, *mp1;
	union {
	    OFLOD_INFO	info;
	    FLOD_MMAP	map;
	} swap;
	DB_ST *rcd_st;
	char *p;
	int i;

	/* The caller should use RUSH_NEXT_FLODS_CK() or similar,
	 * but be sure because we don't want to fight with the resolving
	 * process. */
	if (!flod_names_resolve_ck())
		return 0;

	/* forget everything about flooding */
	oflods_clear();

	/* keep the map open and locked most of the time */
	if (!flod_mmap(&dcc_emsg, &db_parms.sn, &dccd_stats, 1)) {
		if (complain)
			dcc_error_msg("%s", dcc_emsg.c);
		flod_mtime = 0;
		return 0;
	}

	f = fopen(flod_path.c, "r");
	if (!f) {
		if (flod_mtime != 0) {
			dcc_error_msg("fopen(%s): %s",
				      DB_NM2PATH_ERR(flod_path.c), ERROR_STR());
			flod_mtime = 0;
		}

		flod_unmap(0, &dccd_stats);
		return 0;
	}
	if (0 > fstat(fileno(f), &sb)) {
		if (flod_mtime != 0)
			dcc_error_msg("stat(%s): %s",
				      DB_NM2PATH_ERR(flod_path.c), ERROR_STR());
		fclose(f);
		flod_unmap(0, &dccd_stats);
		flod_mtime = 0;
		return 0;
	}
	flod_mtime = sb.st_mtime;

	/* Parse the ASCII file of names and parameters first so that we do not
	 * destroy the position information if there is a host name problem. */
	ofp = oflods.infos;
	lno = 0;
	for (;;) {
		/* clear the entry in case we started to set it with the
		 * preceding line from the /var/dcc/flod file */
		if (ofp <= LAST(oflods.infos))
			oflod_clear(ofp);

		++lno;
		bufp = fgets(buf, sizeof(buf), f);
		if (!bufp) {
			if (ferror(f)) {
				dcc_error_msg("fgets(%s): %s",
					      DB_NM2PATH_ERR(flod_path.c),
					      ERROR_STR());
				break;
			}
			if (fclose(f) == EOF) {
				dcc_error_msg("fclose(%s): %s",
					      DB_NM2PATH_ERR(flod_path.c),
					      ERROR_STR());
			}
			f = 0;
			break;
		}
		i = strlen(bufp);
		if (i >= ISZ(buf)-1) {
			dcc_error_msg("too many characters%s",
				      dcc_fnm_lno(&fnm_buf, flod_path.c, lno));
			do {
				i = getc(f);
			} while (i != '\n' && i != EOF);
			continue;
		}
		/* ignore comments */
		p = strchr(bufp, '#');
		if (p)
			*p = '\0';
		else
			p = &buf[i];
		/* trim trailing blanks */
		while (--p > bufp && (*p == ' ' || *p == '\t' || *p == '\n'))
			*p = '\0';
		/* skip blank lines */
		bufp += strspn(bufp, DCC_WHITESPACE);
		if (*bufp == '\0')
			continue;

		if (oflods.total >= DIM(oflods.infos)) {
			dcc_error_msg("too many DCC peers in %s; max=%d",
				      DB_NM2PATH_ERR(flod_path.c),
				      DIM(oflods.infos));
			continue;
		}

		ofp->lno = lno;

		/* get IP address and port number of remote DCC server */
		bufp1 = bufp+strcspn(bufp, DCC_WHITESPACE";");
		if (*bufp1 != ';') {
			bufp1 = 0;
		} else {
			/* Allow the local or client TCP IP address and
			 * port number to be specified. */
			buf[bufp1++ - buf] = '\0';
		}
		bufp = dcc_parse_nm_port(0, bufp, def_port,
					 ofp->rem_hostname,
					 sizeof(ofp->rem_hostname),
					 &ofp->rem_port,
					 ofp->rem_portname,
					 sizeof(ofp->rem_portname),
					 flod_path.c, lno);
		if (!bufp)
			continue;
		if (bufp1) {
			/* parse the local IP address first */
			bufp = dcc_parse_nm_port(0, bufp1, 0,
						 ofp->loc_hostname,
						 sizeof(ofp->loc_hostname),
						 &ofp->loc_port, 0, 0,
						 flod_path.c, lno);
			if (!bufp)
				continue;
		}

		bufp = oflod_parse_id(&ofp->rem_id, bufp,
				      "rem-id", lno);
		if (!bufp)
			continue;
		if (ofp->rem_id == DCC_ID_INVALID) {
			dcc_error_msg("missing rem-id%s",
				      dcc_fnm_lno(&fnm_buf, flod_path.c, lno));
			continue;
		}

		bufp = oflod_parse_id(&ofp->out_passwd_id, bufp,
				      "passwd-id", lno);
		if (!bufp)
			continue;
		if (ofp->out_passwd_id == DCC_ID_INVALID) {
			ofp->out_passwd_id = my_srvr_id;
			ofp->in_passwd_id = ofp->rem_id;
		} else {
			ofp->in_passwd_id = ofp->out_passwd_id;
		}

		ofp->oversion = DCC_FLOD_VERS_DEF;
		bufp = parse_flod_opts(ofp, &ofp->o_opts, bufp, lno);
		if (!bufp) {
			ofp->o_opts.flags |= FLOD_OPT_OFF;
			ofp->i_opts.flags |= FLOD_OPT_OFF;
		} else {
			bufp = parse_flod_opts(ofp, &ofp->i_opts, bufp, lno);
		}
		if (!bufp) {
			ofp->o_opts.flags |= FLOD_OPT_OFF;
			ofp->i_opts.flags |= FLOD_OPT_OFF;
		} else if (*bufp != '\0') {
			dcc_error_msg("trailing garbage \"%s\" ignored%s",
				      bufp,
				      dcc_fnm_lno(&fnm_buf, flod_path.c, lno));
			ofp->o_opts.flags |= FLOD_OPT_OFF;
			ofp->i_opts.flags |= FLOD_OPT_OFF;
		}

		rcd_st = GET_DB_ST();
		if (0 < find_srvr_rcd_type(ofp->rem_id, rcd_st)) {
			switch (DB_RCD_ID(rcd_st->d.r)) {
			case DCC_ID_SRVR_SIMPLE:
				break;
			case DCC_ID_SRVR_ROGUE:
				ofp->o_opts.flags |= FLOD_OPT_ROGUE;
				break;
			default:
				dcc_error_msg("unknown state for server-ID %d",
					      ofp->rem_id);
				break;
			}
		}
		free_db_st(rcd_st);

		for (ofp1 = oflods.infos; ofp1 < ofp; ++ofp1) {
			if ((!strcmp(ofp1->rem_hostname, ofp->rem_hostname)
			     && ofp1->rem_port == ofp->rem_port)
			    || ofp1->rem_id == ofp->rem_id)
				break;
		}
		if (ofp1 != ofp) {
			dcc_error_msg("duplicate DCC peer%s and line %d",
				      dcc_fnm_lno(&fnm_buf, flod_path.c, lno),
				      ofp1->lno);
			continue;
		}

		/* ignore ourself */
		if (ofp->rem_id == my_srvr_id)
			continue;

		ofp->limit_reset = db_time.tv_sec + FLOD_LIM_CLEAR_SECS;

		++ofp;
		++oflods.total;
	}
	if (f)
		fclose(f);

	/* sort new list by server-ID so that `cdcc "flood list"` is sorted */
	ofp = oflods.infos;
	while (ofp < LAST(oflods.infos)) {
		ofp1 = ofp+1;
		if (ofp1->rem_hostname[0] == '\0')
			break;
		if (ofp->rem_id <= ofp1->rem_id) {
			ofp = ofp1;
			continue;
		}
		/* bubble sort because the list is usually already
		 * ordered and almost always tiny */
		memcpy(&swap.info, ofp1, sizeof(swap.info));
		memcpy(ofp1, ofp, sizeof(*ofp1));
		memcpy(ofp, &swap.info, sizeof(*ofp));
		ofp = oflods.infos;
	}

	mp = flod_mmaps->mmaps;

	/* Bubble sort the list in the /var/dcc/flod/map file so that is
	 * sorted for `dblist -Hv`.  The file will usually already be sorted
	 * and is tiny. */
	mp1 = mp+1;
	while (mp1 <= LAST(flod_mmaps->mmaps)) {
		if (mp1->rem_hostname[0] == '\0') {
			++mp1;
			continue;
		}
		if (mp->rem_hostname[0] == '\0'
		    || mp->rem_id <= mp1->rem_id) {
			mp = mp1++;
			continue;
		}
		memcpy(&swap.map, mp1, sizeof(swap.map));
		memcpy(mp1, mp, sizeof(*mp1));
		memcpy(mp, &swap.map, sizeof(*mp));
		mp = flod_mmaps->mmaps;
		mp1 = mp+1;
	}

	/* combine our list that is based on the ASCII file /var/dcc/flod
	 * with the memory mapped /var/dcc/flod.map list of what has
	 * been sent to each peer */
	for (mp = flod_mmaps->mmaps; mp <= LAST(flod_mmaps->mmaps); ++mp)
		mp->flags &= ~FLODMAP_FG_MARK;

	/* make one pass matching old names with their slots in the
	 * mapped file */
	mp = flod_mmaps->mmaps;
	for (ofp = oflods.infos; ofp <= LAST(oflods.infos); ++ofp) {
		if (ofp->rem_hostname[0] == '\0')
			break;
		for (i = 0; i < DIM(flod_mmaps->mmaps); ++i) {
			if (++mp > LAST(flod_mmaps->mmaps))
				mp = flod_mmaps->mmaps;
			if (mp->rem_hostname[0] == '\0')
				continue;
			if (!(mp->flags & FLODMAP_FG_MARK)
			    && ofp->rem_id == mp->rem_id) {
				/* found the old slot */
				if (DB_PTR_IS_BAD(mp->confirm_pos, DB_PTR_MAX+1)
				    || mp->confirm_pos > db_csize) {
					dcc_error_msg("bogus position "L_HxPAT
						    " for %s in %s",
						    mp->confirm_pos,
						    ofp->rem_hostname,
						    flod_mmap_path.c);
					mp->rem_hostname[0] = '\0';
					continue;
				}
				ofp->cur_pos = mp->confirm_pos;
				ofp->rewind_pos = db_csize;
				ofp->mp = mp;
				copy_opts2mp(ofp);
				mp->flags |= FLODMAP_FG_MARK;
				break;
			}
		}
	}


	/* use a free or obsolete slot in the mapped file for new entries */
	mp = flod_mmaps->mmaps;
	for (ofp = oflods.infos; ofp <= LAST(oflods.infos); ++ofp) {
		/* find the next new peer without a mapped file slot */
		if (ofp->rem_hostname[0] == '\0')
			break;
		if (ofp->mp != 0)
			continue;

		/* find a free or no longer used slot */
		while (mp->flags & FLODMAP_FG_MARK) {
			if (++mp > LAST(flod_mmaps->mmaps)) {
				bad_stop("too few oflod mmap slots");
				goto out;
			}
		}
		if (mp->rem_hostname[0] != '\0')
			dcc_error_msg("forget flood to %s %d",
				      dcc_host_portname(hostname,
							sizeof(hostname),
							mp->rem_hostname,
							mp->rem_portname),
				      mp->rem_id);

		/* we have found a free slot */
		memset(mp, 0, sizeof(*mp));
		ofp->mp = mp;
		mp->rem_id = ofp->rem_id;
		copy_opts2mp(ofp);

		mp->cnts.cnts_cleared = db_time.tv_sec;

		/* normally flood from start, but avoid rewinding if not
		 * repairing a broken mapped flod file */
		if (flod_mmaps->dccd_stats.reset != 0) {
			mp->confirm_pos = db_parms.min_confirm_pos;
		} else {
			mp->confirm_pos = db_csize;
		}
		ofp->cur_pos = mp->confirm_pos;
		ofp->recv_pos = ofp->xmit_pos = mp->confirm_pos;

		mp->flags |= FLODMAP_FG_MARK;

		dcc_error_msg("initialize flood to %s %d%s",
			      dcc_host_portname(hostname, sizeof(hostname),
						mp->rem_hostname,
						mp->rem_portname),
			      mp->rem_id,
			      dcc_fnm_lno(&fnm_buf, flod_path.c, ofp->lno));
	}
out:;

	flod_mmaps->ids_mtime = ids_mtime;

	/* clear the slots that contain forgotten hosts */
	for (mp = flod_mmaps->mmaps; mp <= LAST(flod_mmaps->mmaps); ++mp) {
		if (!(mp->flags & FLODMAP_FG_MARK)) {
			if (mp->rem_hostname[0] != '\0')
				dcc_error_msg("forget flood to %s %d",
					      dcc_host_portname(hostname,
							sizeof(hostname),
							mp->rem_hostname,
							mp->rem_portname),
					      mp->rem_id);
			memset(mp, 0, sizeof(*mp));
		}
	}

	flod_mmap_sync(0, 1);

	get_oflods_max_cur_pos();

	if (!diag) {
		db_parms.flags &= ~DB_PARM_FG_NEED_RWD;
		db_flush_parms(0);
	}

	return 1;
}



/* put the flood counters in stable storage */
void
save_flod_cnts(OFLOD_INFO *ofp)
{
	FLOD_MMAP *mp;
	time_t delta;
	FLOD_LIMCNT *lc;

	dccd_stats.iflod_total += ofp->cnts.total;
	dccd_stats.iflod_accepted += ofp->cnts.accepted;
	dccd_stats.iflod_stale += ofp->lc.stale.cur;
	dccd_stats.iflod_dup += ofp->lc.dup.cur;
	dccd_stats.iflod_wlist += ofp->lc.wlist.cur;
	dccd_stats.iflod_not_deleted += ofp->lc.not_deleted.cur;

	mp = ofp->mp;
	if (mp) {
		if (ofp->xmit_pos == ofp->recv_pos)
			ofp->mp->confirm_pos = ofp->cur_pos;

		mp->cnts.total += ofp->cnts.total;
		mp->cnts.accepted += ofp->cnts.accepted;
		mp->cnts.stale += ofp->lc.stale.cur;
		mp->cnts.dup += ofp->lc.dup.cur;
		mp->cnts.wlist += ofp->lc.wlist.cur;
		mp->cnts.not_deleted += ofp->lc.not_deleted.cur;

		mp->cnts.out_reports += ofp->cnts.out_reports;

		delta = db_time.tv_sec - ofp->cnts.saved;
		if (delta < 0 || delta > 60*60)
			delta = 0;
		if (ofp->ifp) {
			if (mp->flags & FLODMAP_FG_IN_CONN) {
				mp->cnts.in_total_conn += delta;
			} else {
				mp->flags |= FLODMAP_FG_IN_CONN;
				mp->cnts.in_conn_changed = db_time.tv_sec;
			}
		} else {
			if (mp->flags & FLODMAP_FG_IN_CONN) {
				mp->cnts.in_total_conn += delta;
				mp->flags &= ~FLODMAP_FG_IN_CONN;
				mp->cnts.in_conn_changed = db_time.tv_sec;
			}
		}

		if (ofp->flags & OFLOD_FG_CONNECTED) {
			if (mp->flags & FLODMAP_FG_OUT_CONN) {
				mp->cnts.out_total_conn += delta;
			} else {
				mp->flags |= FLODMAP_FG_OUT_CONN;
				mp->cnts.out_conn_changed = db_time.tv_sec;
			}
		} else {
			if (mp->flags & FLODMAP_FG_OUT_CONN) {
				mp->flags &= ~FLODMAP_FG_OUT_CONN;
				mp->cnts.out_conn_changed = db_time.tv_sec;
			}
		}
	}

	memset(&ofp->cnts, 0, sizeof(ofp->cnts));
	for (lc = (FLOD_LIMCNT *)&ofp->lc;
	     lc < (FLOD_LIMCNT *)(sizeof(ofp->lc)+(char *)&ofp->lc);
	     ++lc) {
		lc->lim -= lc->cur;
		lc->cur = 0;
	}

	ofp->cnts.saved = db_time.tv_sec;
}



void
oflod_close(OFLOD_INFO *ofp,
	    int mode)			/* 1=backoff failure, 0=ok, -1=retry */
{
	u_char need_oflods_clear = 0;

	if (ofp->rem_hostname[0] == '\0')
		return;

	if (ofp->soc >= 0) {
		if (0 > close(ofp->soc)
		    && !mode) {
			if (errno == ECONNRESET)
				TMSG2_FLOD1(ofp, "close(flood to %s): %s",
					    ofp_rem_str(ofp), ERROR_STR());
			else
				dcc_error_msg("close(flod to %s): %s",
					      ofp_rem_str(ofp), ERROR_STR());
		}
		ofp->soc = -1;
		ofp->flags &= ~(OFLOD_FG_CONNECTED
				| OFLOD_FG_SHUTDOWN_REQ
				| OFLOD_FG_SHUTDOWN);
		ofp->obuf_len = 0;
		ofp->cnts.out_reports = 0;

		save_flod_cnts(ofp);

		if (--oflods.open == 0
		    && iflods.open == 0
		    && flods_st != FLODS_ST_ON)
			need_oflods_clear = 1;
	}

	if (mode >= 0)
		ofp->o_dns.num = 0;	/* start from 1st IP address next time */

	if (mode > 0) {
		if (ofp->mp->otimers.retry_secs < FLOD_RETRY_SECS/2)
			ofp->mp->otimers.retry_secs = FLOD_RETRY_SECS/2;
		ofp->mp->otimers.retry = (db_time.tv_sec
					  + ofp->mp->otimers.retry_secs);
		if (!(ofp->mp->flags & FLODMAP_FG_PASSIVE))
			TMSG2_FLOD1(ofp,
				    "postpone restarting flood to %s"
				    " for %d seconds",
				    ofp_rem_str(ofp),
				    ofp->mp->otimers.retry_secs);
	}

	if (need_oflods_clear)
		oflods_clear();
}



/* get ready to shut down */
static void
start_shutdown(OFLOD_INFO *ofp)
{
	if (ofp->flags & (OFLOD_FG_SHUTDOWN_REQ
			  | OFLOD_FG_SHUTDOWN))
		return;

	/* arrange to ask the peer to ask us to stop */
	ofp->flags |= OFLOD_FG_SHUTDOWN_REQ;
	ofp->flags &= ~OFLOD_FG_NEW;
	oflod_fill(ofp);

	/* oflod_write() might set this again, but that will either be soon
	 * or a good thing if delayed */
	ofp->oflod_alive = db_time.tv_sec;
}



/* Half-close the TCP connection.
 *	The other DCC server will notice and send our final position
 *	to acknowledge dealing with our reports. */
static void
oflod_shutdown(OFLOD_INFO *ofp)
{
	struct linger nowait;

	/* wait until the output buffer is empty */
	if (ofp->obuf_len != 0)
		return;

	/* do it only once */
	if ((ofp->flags & OFLOD_FG_SHUTDOWN))
		return;
	ofp->flags |= OFLOD_FG_SHUTDOWN;

	/* on Solaris and Linux you must set SO_LINGER before shutdown() */
	nowait.l_onoff = 1;
	nowait.l_linger = SHUTDOWN_DELAY;
	if (0 > setsockopt(ofp->soc, SOL_SOCKET, SO_LINGER,
			   &nowait, sizeof(nowait)))
		ferr(ofp, 0, FERR_STOP, 0,
		     "setsockopt(SO_LINGER flood to %s): %s",
		     ofp_rem_str(ofp), ERROR_STR());

	if (0 > shutdown(ofp->soc, 1)) {
		ferr(ofp, 0, FERR_STOP, errno==ECONNRESET,
		     "shutdown(flood to %s): %s",
		     ofp_rem_str(ofp), ERROR_STR());
		oflod_close(ofp, 1);
	}
}



/* see if a report should be put into the output buffer for a flood
 *  ofp->cur_pos has already been advanced */
static u_char				/* 1=flood this report, 0=don't */
oflod_ck_put(const DB_ST *rcd_st)
{
	const DB_RCD_CK *cur_rcd_ck;
	DCC_TGTS rcd_tgts, ck_tgts;
	int num_cks;
	DCC_CK_TYPES type;
	u_char obs_lvl, result;

	/* skip padding, whitelisted, compressed, trimmed
	 * and deleted entries */
	if (DB_RCD_ID(rcd_st->d.r) == DCC_ID_WHITE
	    || DB_RCD_ID(rcd_st->d.r) == DCC_ID_COMP
	    || (rcd_tgts = DB_TGTS_RCD_RAW(rcd_st->d.r)) == 0
	    || ts2secs(&rcd_st->d.r->ts) < db_time.tv_sec - FLOD_STALE_SECS
	    || rcd_tgts == DCC_TGTS_REP_ADJ
	    || DB_RCD_TRIMMED(rcd_st->d.r))
		return 0;

	/* Skip reports that should not be flooded yet
	 * The flooding thresholds are used to set the delay flag.
	 * Small reports are marked with the delay flag when they are added
	 * to the database.  If later it seems they should be flooded,
	 * they are summarized in a new report that is flooded. */
	if (DB_RCD_DELAY(rcd_st->d.r))
		return 0;

	result = 0;
	obs_lvl = 0;
	cur_rcd_ck = rcd_st->d.r->cks;
	for (num_cks = DB_NUM_CKS(rcd_st->d.r);
	     num_cks != 0;
	     ++cur_rcd_ck, --num_cks) {
		type = DB_CK_TYPE(cur_rcd_ck);

		/* ignore junk for deciding whether we can send this report. */
		if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type))
			continue;

		if (DB_CK_JUNK(cur_rcd_ck)) {
			/* an obsolete fuzzier checksum
			 * makes less fuzzy checksums obsolete */
			if (obs_lvl < db_ck_fuzziness[type]) {
				obs_lvl = db_ck_fuzziness[type];
				result = 0;
			}
			continue;
		}

		/* send server-ID declarations
		 * unless they are delete requests */
		if (type == DCC_CK_SRVR_ID) {
			if (rcd_tgts == DCC_TGTS_DEL)
				continue;
			return 1;
		}

		/* do not send whitelisted reports */
		ck_tgts = DB_TGTS_CK(cur_rcd_ck);
		if (ck_tgts == DCC_TGTS_OK || ck_tgts == DCC_TGTS_OK2)
			return 0;

		/* send non-obsolete results */
		if (obs_lvl <= db_ck_fuzziness[type]) {
			obs_lvl = db_ck_fuzziness[type];
			result = 1;
		}
	}
	return result;
}



/* put report into the output buffer for a flood if appropriate
 *  ofp->cur_pos has already been advanced */
static void
put_rcd_obuf(OFLOD_INFO *ofp, const DB_ST *rcd_st)
{
	DCC_FLOD_RPT *rp;
	DCC_TGTS tgts;
	DCC_SRVR_ID srvr;
	const DB_RCD *cur_rcd;
	const DB_RCD_CK *cur_rcd_ck;
	DCC_CK *buf_ck;
	DCC_FLOD_PATH_ID *new_path_idp, *new_path_id_limp;
	const DCC_FLOD_PATH_ID *rcd_path_id;
	int path_ids;
	DCC_CK_TYPES type;
	ID_MAP_RESULT srvr_mapped;
	u_char reflecting;		/* 1=report is pointed at its source */
	u_char non_path, all_spam;
	int num_cks, j;

	/* decide whether to send this report */
	if (!oflod_ck_put(rcd_st))
		return;			/* skip it */

	rp = (DCC_FLOD_RPT *)&ofp->obuf.b[ofp->obuf_len];
	db_ptr2flod_pos(rp->pos, ofp->cur_pos);
	cur_rcd = rcd_st->d.r;
	tgts = DB_TGTS_RCD_RAW(cur_rcd);

	/* don't send delete requests to systems that don't want them */
	if (tgts == DCC_TGTS_DEL
	    && !(ofp->o_opts.flags & FLOD_OPT_DEL_OK))
		return;

	srvr = DB_RCD_ID(cur_rcd);
	/* translate the source server-ID */
	srvr_mapped = id_map(srvr, &ofp->o_opts.maps);
	switch (srvr_mapped) {
	case ID_MAP_NO:
		break;
	case ID_MAP_REJ:
		return;
	case ID_MAP_SELF:
		srvr = my_srvr_id;
		break;
	}
	rp->srvr_id[0] = srvr>>8;
	rp->srvr_id[1] = srvr;

	reflecting = (srvr == ofp->rem_id);
	non_path = 0;

	rp->ts = cur_rcd->ts;

	cur_rcd_ck = cur_rcd->cks;

	/* Add a path if we are not the source of the report
	 * or if it already has a path */
	buf_ck = rp->cks;
	if (srvr != my_srvr_id
	    || DB_CK_TYPE(cur_rcd_ck) == DCC_CK_FLOD_PATH) {
		/* Add a checksum entry for a path consisting of only our
		 * server-ID.  If the report contains a path, we will
		 * concatenate to this entry */
		memset(buf_ck, 0, sizeof(*buf_ck));
		buf_ck->len = sizeof(*buf_ck);
		buf_ck->type = DCC_CK_FLOD_PATH;
		new_path_idp = buf_ck->sum.p;
		new_path_idp->hi = my_srvr_id>>8;
		new_path_idp->lo = my_srvr_id;
		new_path_id_limp = new_path_idp + DCC_NUM_FLOD_PATH;
		path_ids = 1;
		++new_path_idp;
		++buf_ck;
		rp->num_cks = 1;
	} else {
		/* do not add a new path to our own reports */
		new_path_idp = new_path_id_limp = 0;
		path_ids = 0;
		rp->num_cks = 0;
	}

	all_spam = 1;
	for (num_cks = DB_NUM_CKS(cur_rcd);
	     num_cks != 0;
	     ++cur_rcd_ck, --num_cks) {
		type = DB_CK_TYPE(cur_rcd_ck);

		/* deal with paths */
		if (type == DCC_CK_FLOD_PATH) {
			rcd_path_id = cur_rcd_ck->sum.p;
			for (j = 0; j < DCC_NUM_FLOD_PATH; ++j, ++rcd_path_id) {
				DCC_SRVR_ID psrvr = ((rcd_path_id->hi<<8)
						     | rcd_path_id->lo);
				/* stop copying the path at its end */
				if (psrvr == DCC_ID_INVALID)
					break;
				/* don't send report if its path is too long */
				if (++path_ids > DCC_MAX_FLOD_PATH)
					return;
				/* add another "checksum" to continue path */
				if (new_path_idp >= new_path_id_limp) {
					memset(buf_ck, 0, sizeof(*buf_ck));
					buf_ck->len = sizeof(*buf_ck);
					buf_ck->type = DCC_CK_FLOD_PATH;
					new_path_idp = buf_ck->sum.p;
					new_path_id_limp = (new_path_idp
							+ DCC_NUM_FLOD_PATH);
					++buf_ck;
					++rp->num_cks;
				}
				/* Do not send reports from the target back
				 * to the target unless the report is a
				 * server-ID declaration. */
				if (psrvr == ofp->rem_id)
					reflecting = 1;
				switch (id_map(psrvr, &ofp->o_opts.maps)) {
				case ID_MAP_NO:
				case ID_MAP_REJ:
					break;
				case ID_MAP_SELF:
					psrvr = my_srvr_id;
					break;
				}
				new_path_idp->hi = psrvr>>8;
				new_path_idp->lo = psrvr;
				++new_path_idp;
			}
			continue;
		}

		/* Deal with all other checksums.
		 *
		 * Do not send translated server-ID declarations
		 * or checksums in our own or in translated server-ID
		 * reports that we wouldn't have kept if we had
		 * received the original reports */
		if (srvr_mapped == ID_MAP_SELF) {
			if (type == DCC_CK_SRVR_ID)
				return;
			if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type))
				continue;
		}

		if (type == DCC_CK_SRVR_ID) {
			/* do not send types of mapped server-IDs */
			if (DCC_ID_SRVR_TYPE(srvr)) {
				switch (id_map(DCC_ID_SRVR_TYPE_ID
					       (&cur_rcd_ck->sum),
					       &ofp->o_opts.maps)) {
				case ID_MAP_NO:
				case ID_MAP_REJ:
					break;
				case ID_MAP_SELF:
					return;
				}
			}
		} else {
			/* Do not send reports from the target to the target
			 * or reports wtih paths that are too long
			 * unless the report is a Server-ID declaration */
			if (reflecting
			    || path_ids >= ofp->o_opts.path_len)
				return;
		}


		if (DCC_CK_IS_REP(grey_on,type)) {
			/* do not send reputation checksumss to peers
			 * that do not understand them */
			if (!(ofp->flags & OFLOD_FG_REP_SEND))
				continue;
			/* do not send useless bulk reputation counts */
			if (DB_CK_JUNK(cur_rcd_ck)
			    && DCC_CK_IS_REP_BULK(grey_on, type))
				continue;
		}

		/* send everything else */
		buf_ck->type = type;
		buf_ck->len = sizeof(*buf_ck);
		buf_ck->sum = cur_rcd_ck->sum;
		++buf_ck;
		++rp->num_cks;

		non_path = 1;
		if (all_spam
		    && DB_TGTS_CK(cur_rcd_ck) != DCC_TGTS_TOO_MANY)
			all_spam = 0;
	}

	/* quit if we found nothing but the path to send */
	if (!non_path)
		return;

	if (all_spam && srvr == my_srvr_id)
		tgts = DCC_TGTS_TOO_MANY;
	tgts = htonl(tgts);
	memcpy(&rp->tgts, &tgts, sizeof(rp->tgts));

	ofp->obuf_len += (char *)buf_ck - (char *)rp;
	++ofp->cnts.out_reports;
	ofp->xmit_pos = ofp->cur_pos;
}



/* send reports from the database to a peer DCC server
 *	This routine only fills the buffer.  The buffer is eventually
 *	written by oflod_write(). */
static void
oflod_fill(OFLOD_INFO *ofp)
{
	DB_ST *rcd_st;
	int cur_rcd_len;

	/* stop when things are not ready or shutting down */
	if (!(ofp->flags & OFLOD_FG_CONNECTED)
	    || (ofp->flags & OFLOD_FG_SHUTDOWN)
	    || (ofp->flags & OFLOD_FG_NEW))
		return;

	/* stop when we are about to clean the database for a deletion so
	 * that we will not be shut down cleaning along with our neighbors */
	if (need_del_dbclean)
		return;

	if (db_failed_line)
		return;

	rcd_st = GET_DB_ST();
	while (ofp->obuf_len < sizeof(ofp->obuf) - sizeof(DCC_FLOD_RPT)) {
		/* start a new entry unless we are shutting down */
		if (ofp->flags & OFLOD_FG_SHUTDOWN_REQ) {
			oflod_shutdown(ofp);
			break;
		}

		if (ofp->cur_pos < db_parms.min_confirm_pos)
			ofp->cur_pos = db_parms.min_confirm_pos;
		if (ofp->cur_pos >= db_csize) {
			/* nothing to send, so shut down if needed */
			if (ofp->xmit_pos == ofp->recv_pos)
				ofp->mp->confirm_pos = ofp->cur_pos;
			if (ofp->mp->confirm_pos >= ofp->rewind_pos)
				ofp->mp->flags &= ~FLODMAP_FG_REWINDING;
			break;
		}

		if (!db_map_rcd(&dcc_emsg, rcd_st, ofp->cur_pos,
				&cur_rcd_len)) {
			dcc_error_msg("oflod_fill() starting at "L_HxPAT
				      " for %s: %s",
				      ofp->cur_pos, ofp_rem_str(ofp),
				      dcc_emsg.c);
			ofp->cur_pos = db_csize;
			break;
		}

		if (DB_NUM_CKS(rcd_st->d.r) > DCC_DIM_CKS) {
			dcc_error_msg("impossible %d checksums in cur_pos="
				      L_HxPAT" for %s",
				      DB_NUM_CKS(rcd_st->d.r),
				      ofp->cur_pos, ofp_rem_str(ofp));
			ofp->cur_pos = db_csize;
			break;
		}

		/* send the record */
		ofp->cur_pos += cur_rcd_len;
		put_rcd_obuf(ofp, rcd_st);
	}
	free_db_st(rcd_st);

	if (oflods_max_cur_pos < ofp->cur_pos)
		oflods_max_cur_pos = ofp->cur_pos;
}



/* figure out what version to tell the peer */
const char *
version_str(OFLOD_INFO *ofp)
{
	/* If the peer has not refused to do reputations today
	 * and if they are enabled on our end,
	 * then try reputations */
	if (!grey_on
	    && (!(ofp->mp->flags & FLODMAP_FG_REP_PEER_REJ)
		|| DB_IS_TIME(ofp->mp->reps_rejected+24*60*60, 24*60*60)))
		ofp->flags |= OFLOD_FG_REP_TRY;

	if (ofp->flags & OFLOD_FG_REP_TRY) {
		if (ofp->oversion == 0)
			return DCC_FLOD_REP_VERS_CUR_STR;
#ifdef DCC_FLOD_VERS7
		if (ofp->oversion == DCC_FLOD_VERS7)
			return DCC_FLOD_REP_VERS7_STR;
#endif
		dcc_logbad(EX_SOFTWARE, "unknown ofp->oversion=%d",
			   ofp->oversion);
	}

	if (ofp->oversion == 0)
		return DCC_FLOD_VERS_CUR_STR;
#ifdef DCC_FLOD_VERS7
	if (ofp->oversion == DCC_FLOD_VERS7)
		return DCC_FLOD_VERS7_STR;
#endif
	dcc_logbad(EX_SOFTWARE, "unknown ofp->oversion=%d", ofp->oversion);
}



/* reset connect() or daily complaint timers */
void
flod_try_again(OFLOD_INFO *ofp, u_char reset_backoff)
{
	FLOD_MMAP *mp = ofp->mp;

	mp = ofp->mp;
	if (!mp)
		return;

	if (reset_backoff) {
		mp->otimers.retry_secs = 0;
	} else {
		/* compensate for a doubling to keep backoff steady */
		mp->otimers.retry_secs /= 2;
	}
	/* ordinary connect() timer should fire immediately */
	mp->otimers.retry = 0;

	/* delay complaints for passive connections */
	if (DCC_IS_TIME(db_time.tv_sec+FLOD_IN_COMPLAIN_NOW,
			mp->otimers.msg, mp->otimers.msg_secs)) {
		mp->otimers.msg_secs = FLOD_IN_COMPLAIN_NOW;
		mp->otimers.msg = db_time.tv_sec + FLOD_IN_COMPLAIN_NOW;
	}

	if (reset_backoff) {
		ferr_clear_all(ofp, 1);
		ferr_clear_all(ofp, 0);
		mp->itimers.retry_secs = 0;
	} else {
		/* compensate for a doubling to keep backoff steady */
		mp->itimers.retry_secs /= 2;
	}

	if (DCC_IS_TIME(db_time.tv_sec+FLOD_IN_COMPLAIN_NOW,
			mp->itimers.msg, mp->itimers.msg_secs)) {
		mp->itimers.msg_secs = FLOD_IN_COMPLAIN_NOW;
		mp->itimers.msg = db_time.tv_sec + FLOD_IN_COMPLAIN_NOW;
	}
}



/* authenticate the outgoing start of a flood */
const char *				/* error message */
flod_sign(OFLOD_INFO *ofp, u_char in, void *buf, int buf_len)
{
	const ID_TBL *tp;

	tp = find_id_tbl(ofp->out_passwd_id, db_debug != 0);
	if (!tp)
		return DCC_FLOD_PASSWD_ID_MSG;
	if (tp->cur_passwd[0] == '\0')
		return "no password for passwd-ID";

	if (tp->next_passwd[0] != '\0') {
		ofp->flags |= OFLOD_FG_HAVE_2PASSWD;
	} else {
		ofp->flags &= ~OFLOD_FG_HAVE_2PASSWD;
		ofp->mp->flags &= ~FLODMAP_FG_USE_2PASSWD;
	}
	if (ofp->mp->flags & FLODMAP_FG_USE_2PASSWD) {
		if (in)
			ofp->flags |= OFLOD_FG_I_USED_2PASSWD;
		else
			ofp->flags |= OFLOD_FG_O_USED_2PASSWD;
		TMSG1_FLOD1(ofp, "try 2nd password to %s", ofp_rem_str(ofp));
		dcc_sign(tp->next_passwd, sizeof(tp->next_passwd),
			 buf, buf_len);
	} else {
		if (in)
			ofp->flags &= ~OFLOD_FG_I_USED_2PASSWD;
		else
			ofp->flags &= ~OFLOD_FG_O_USED_2PASSWD;
		dcc_sign(tp->cur_passwd, sizeof(tp->cur_passwd),
			 buf, buf_len);
	}
	return 0;
}



/* finish connecting output flood by sending our version number and signature
 *	to authenticate ourself */
u_char					/* 1=ok, 0=close output stream */
oflod_connect_fin(OFLOD_INFO *ofp)
{
	FLOD_MMAP *mp;
	DCC_SRVR_ID id;
	DCC_FNM_LNO_BUF fnm_buf;
	const char *emsg;

	mp = ofp->mp;

	ofp->o_dns.num = 0;		/* start from 1st IP address next time */

	ofp->oflod_alive = db_time.tv_sec;
	ofp->flags |= (OFLOD_FG_CONNECTED | OFLOD_FG_NEW);

	ofp->recv_pos = ofp->xmit_pos = ofp->cur_pos = mp->confirm_pos;
	get_oflods_max_cur_pos();

	ofp->ibuf_len = 0;

	/* convince the peer we're sane by sending our version string */
	ofp->obuf_len = sizeof(ofp->obuf.s.v);
	memset(&ofp->obuf.s.v, 0, sizeof(ofp->obuf.s.v));
	strcpy(ofp->obuf.s.v.body.str, version_str(ofp));
	id = htons(my_srvr_id);
	memcpy(ofp->obuf.s.v.body.sender_srvr_id, &id,
	       sizeof(ofp->obuf.s.v.body.sender_srvr_id));

	emsg = flod_sign(ofp, 0, &ofp->obuf.s.v, ofp->obuf_len);
	if (emsg) {
		ferr(ofp, 0, FERR_START, 0, "%s %d%s",
		     emsg, ofp->out_passwd_id,
		     dcc_fnm_lno(&fnm_buf, flod_path.c, ofp->lno));
		return 0;
	}

	if (ofp->flags & OFLOD_FG_REP_TRY) {
		/* send reputations because the peer accepted our
		 * reputation version string */
		mp->flags &= ~FLODMAP_FG_REP_PEER_REJ;
		mp->reps_rejected = 0;
		ofp->flags |= OFLOD_FG_REP_SEND;

		/* reputations imply accepting deletes by default */
		if (!(ofp->o_opts.flags & FLOD_OPT_DEL_SET))
			ofp->o_opts.flags |= FLOD_OPT_DEL_OK;

	} else {
		ofp->flags &= ~OFLOD_FG_REP_SEND;

		/* If the delete-sending option has not been set,
		 * clear the default set with reputations */
		if (!(ofp->o_opts.flags & FLOD_OPT_DEL_SET))
			ofp->o_opts.flags &= ~FLOD_OPT_DEL_OK;

	}

	TMSG1_FLOD1(ofp, "flood connected to %s", ofp_rem_str(ofp));

	/* All is well, so forget old complaints,
	 * unless we have been forced passive */
	if (!(mp->flags & FLODMAP_FG_OUT_SRVR)
	    || (mp->flags & FLODMAP_FG_PASSIVE))
		ferr_clear_all(ofp, 0);

	oflod_write(ofp);		/* send our authentication */

	/* if that worked, ensure that we try the auto-NAT kludge soon */
	if (ofp->soc >= 0
	    && !ofp->ifp
	    && !DCC_IS_TIME(db_time.tv_sec+FLOD_IN_COMPLAIN_NOW,
			    mp->itimers.msg, mp->itimers.msg_secs)) {
		mp->itimers.msg_secs = FLOD_IN_COMPLAIN_NOW;
		mp->itimers.msg = db_time.tv_sec + FLOD_IN_COMPLAIN_NOW;
	}

	return 1;
}



static void
oflod_backoff(OFLOD_INFO *ofp, u_char fast)
{
	FLOD_MMAP *mp;
	time_t max;

	mp = ofp->mp;
	mp->otimers.retry_secs *= 2;
	max = fast ? FLOD_SUBMAX_RETRY_SECS : FLOD_MAX_RETRY_SECS;
	if (mp->otimers.retry_secs > max)
		mp->otimers.retry_secs = max;
	else if (mp->otimers.retry_secs < FLOD_RETRY_SECS)
		mp->otimers.retry_secs = FLOD_RETRY_SECS;
}



/* start to connect an out-going flood */
static int				/* -1=give up, 0=not yet, 1=done */
oflod_connect_start(OFLOD_INFO *ofp)
{
	DCC_FNM_LNO_BUF fnm_buf;
	int i;

	/* We are starting over, so problems with previous attempts.
	 * If this attempt fails, we will have new complaints. */
	ferr_clear_all(ofp, 0);

	ofp->mp->flags &= ~FLODMAP_FG_OUT_SRVR;

	if (ofp->o_opts.flags & FLOD_OPT_SOCKS) {
		i = Rconnect(ofp->soc, &ofp->rem.sa, DCC_SU_LEN(&ofp->rem));
	} else {
		i = connect(ofp->soc, &ofp->rem.sa, DCC_SU_LEN(&ofp->rem));
	}
	if (0 > i && errno != EISCONN) {
		if (CONN_WAIT_ERRORS()) {
			ferr(ofp, 0, FERR_START, 1,
			     "waiting to connect flood to %s",
			     ofp_rem_str(ofp));
			return 0;
		}

		/* failure */
		ferr(ofp, 0, FERR_START, CONN_ERRORS(),
		     "connect(%s%s): %s",
		     ofp_rem_str(ofp),
		     dcc_fnm_lno(&fnm_buf, flod_path.c, ofp->lno),
		     CONN_EMSG());

		if (++ofp->o_dns.cur < ofp->o_dns.num) {
			/* immediately try the next address */
			oflod_close(ofp, -1);
		} else {
			/* After the last IP address, increase the delay.
			 * Limit the back-off for SOCKS or NAT because the peer
			 * cannot trigger anything by connecting to us */
			oflod_backoff(ofp,
				      (ofp->mp->flags & FLODMAP_FG_ACT) != 0);
			oflod_close(ofp, 1);
		}
		return -1;
	}

	if (!oflod_connect_fin(ofp)) {
		oflod_close(ofp, 1);
		return -1;
	}

	return 1;
}



void
oflod_open(OFLOD_INFO *ofp)
{
	DCC_FNM_LNO_BUF fnm_buf;
	FLOD_MMAP *mp;

	mp = ofp->mp;

	/* try the next host name */
	for (;;) {
		if (ofp->soc >= 0
		    || ofp->rem_hostname[0] == '\0'
		    || OFLOD_OPT_OFF_ROGUE(ofp)
		    || flods_st != FLODS_ST_ON
		    || (ofp->mp->flags & FLODMAP_FG_PASSIVE))
			return;

		if (!DB_IS_TIME(ofp->mp->otimers.retry,
				ofp->mp->otimers.retry_secs))
			return;

		if (ofp->o_dns.cur >= ofp->o_dns.num) {
			if (!flod_names_resolve_start(ofp))
				return;	/* wait for name resolution */
			ofp->o_dns = mp->dns;

			if (ofp->o_dns.num == 0) {
				ferr(ofp, 0, FERR_DNS, 0,
				     "flood peer name %s: '%s'%s",
				     ofp->rem_hostname,
				     H_ERROR_STR1(ofp->o_dns.rem_h_errno),
				     dcc_fnm_lno(&fnm_buf, flod_path.c,
						 ofp->lno));
				oflod_backoff(ofp, 0);
				oflod_close(ofp, 1);
				return;
			}

			/* since we have addresses,
			 * forget old complaints about bad host names */
			ferr_clear(ofp, 0, FERR_DNS);
		}

		/* stop if we cannot open the socket */
		ofp->rem = ofp->o_dns.su[ofp->o_dns.cur];
		DCC_SU_PORT(&ofp->rem) = ofp->rem_port;
		ofp->soc = socket(ofp->rem.sa.sa_family, SOCK_STREAM, 0);
		if (ofp->soc < 0) {
			ferr(ofp, 0, FERR_START, 0,
			     "socket(flood %s): %s",
			     ofp_rem_str(ofp), ERROR_STR());
			oflod_close(ofp, 1);
			return;
		}
		++oflods.open;

		if (!set_flod_socket(ofp, 0, ofp->soc,
				     ofp->rem_hostname, &ofp->rem)) {
			oflod_close(ofp, 1);
			return;
		}

		bind_flod_socket(ofp, ofp->soc, &ofp->rem, &ofp->o_dns);

		if (0 <= oflod_connect_start(ofp))
			return;
	}
}



void
oflod_write(OFLOD_INFO *ofp)
{
	int i;

	if (ofp->obuf_len == 0) {
		if (!(ofp->flags & OFLOD_FG_CONNECTED)
		    && 0 >= oflod_connect_start(ofp))
			return;
		oflod_fill(ofp);
		if (ofp->obuf_len == 0)
			return;
	}

	if (ofp->o_opts.flags & FLOD_OPT_SOCKS)
		i = Rsend(ofp->soc, &ofp->obuf.b, ofp->obuf_len, 0);
	else
		i = send(ofp->soc, &ofp->obuf.b, ofp->obuf_len, 0);
	if (i > 0) {
		ofp->obuf_len -= i;
		if (ofp->obuf_len != 0)
			memmove(&ofp->obuf.b[0], &ofp->obuf.b[i],
				ofp->obuf_len);
		ofp->oflod_alive = db_time.tv_sec;

		/* fill buffer so that the main loop will
		 * ask select() when we can send again */
		oflod_fill(ofp);
		return;
	}

	/* we had an error or EOF */
	if (i < 0) {
		/* oflod_write() is called only when select() has said that
		 * we can send() and so we should never see the non-blocking
		 * send() fail.
		 * However, Solaris nevertheless sometimes says EAGAIN */
		if (DCC_BLOCK_ERROR()) {
			ofp->flags |= OFLOD_FG_EAGAIN;
			TMSG2_FLOD1(ofp, "pause after send(flood to %s): %s",
				    ofp_rem_str(ofp), ERROR_STR());
			return;
		}

		ferr(ofp, 0, FERR_IO, 0, "send(flood to %s): %s",
		     ofp_rem_str(ofp), ERROR_STR());
	} else {
		ferr(ofp, 0, FERR_IO, 0, "premature end of flood to %s",
		     ofp_rem_str(ofp));
	}
	oflod_read(ofp);		/* get any last error message */
	oflod_close(ofp, 1);
}


/* parse end of transmission message for familiar complaints
 *	to adjust retry timer */
int					/* 1=try again soon, 0=ok, -1=failure */
oflod_parse_eof(OFLOD_INFO *ofp, u_char in,
		const DCC_FLOD_END *end, int msg_len)
{
	if (msg_len >= LITZ(DCC_FLOD_OK_STR)
	    && !strncmp(end->msg, DCC_FLOD_OK_STR,
			LITZ(DCC_FLOD_OK_STR))) {
		return 0;		/* success */
	}

	if (msg_len >= LITZ(DCC_FLOD_BAD_AUTH_MSG)
	    && !strncmp(end->msg, DCC_FLOD_BAD_AUTH_MSG,
			LITZ(DCC_FLOD_BAD_AUTH_MSG))) {
		/* try the second password if available
		 * after the peer rejects the first */
		if (in) {
			if ((ofp->flags & OFLOD_FG_HAVE_2PASSWD)
			    && !(ofp->flags & OFLOD_FG_I_USED_2PASSWD)) {
				ofp->flags |= OFLOD_FG_I_USED_2PASSWD;
				ofp->mp->flags |= FLODMAP_FG_USE_2PASSWD;
				return 1;   /* try again soon */
			}
		} else {
			if ((ofp->flags & OFLOD_FG_HAVE_2PASSWD)
			    && !(ofp->flags & OFLOD_FG_O_USED_2PASSWD)) {
				ofp->flags |= OFLOD_FG_O_USED_2PASSWD;
				ofp->mp->flags |= FLODMAP_FG_USE_2PASSWD;
				return 1;   /* try again soon */
			}
		}
		return -1;
	}

	if (msg_len > LITZ(DCC_FLOD_BAD_VER_MSG)
	    && !strncmp(end->msg, DCC_FLOD_BAD_VER_MSG,
			LITZ(DCC_FLOD_BAD_VER_MSG))) {
		/* notice if this peer demands a version
		 * other than what we have been trying */
		if (ofp->oversion != ofp->mp->iversion) {
			ofp->oversion = ofp->mp->iversion;
			return 1;	/* try again soon */
		}

		/* guess that this peer does not like reputations
		 * and try an ordinary flood */
		if (ofp->flags & OFLOD_FG_REP_TRY) {
			ofp->mp->reps_rejected = db_time.tv_sec;
			ofp->mp->flags |= FLODMAP_FG_REP_PEER_REJ;
			ofp->flags &= ~OFLOD_FG_REP_TRY;
			return 1;	/* try again soon */
		}

		return -1;
	}

	return -1;
}



/* see what the target has to say about the reports we have been sending */
void
oflod_read(OFLOD_INFO *ofp)
{
	int used, req_len, recv_len;
	DB_PTR pos;
	int fail;

again:;
	req_len = sizeof(ofp->ibuf) - ofp->ibuf_len;
	if (ofp->o_opts.flags & FLOD_OPT_SOCKS)
		recv_len = Rrecv(ofp->soc, &ofp->ibuf.b[ofp->ibuf_len],
				 req_len, 0);
	else
		recv_len = recv(ofp->soc, &ofp->ibuf.b[ofp->ibuf_len],
				req_len, 0);
	if (recv_len != 0) {
		if (recv_len < 0) {
			if (!DCC_BLOCK_ERROR()) {
				ferr(ofp, 0, FERR_IO, 1,
				     "recv(outgoing flood %s): %s",
				     ofp_rem_str(ofp), ERROR_STR());
				oflod_close(ofp, 1);
			}
			return;
		}

		/* the connection is active */
		ofp->flags &= ~OFLOD_FG_NEW;
		if (!(ofp->flags & (OFLOD_FG_SHUTDOWN_REQ | OFLOD_FG_SHUTDOWN)))
			ofp->oflod_alive = db_time.tv_sec;

		/* Limit the backoff for incoming SOCKS connection
		 * attempts while the outgoing connection is working. */
		DB_ADJ_TIMER(&ofp->mp->itimers.retry,
			     &ofp->mp->itimers.retry_secs, FLOD_RETRY_SECS);
	}

	ofp->ibuf_len += recv_len;
	while (ofp->ibuf_len >= ISZ(ofp->ibuf.r.pos)) {
		used = sizeof(ofp->ibuf.r.pos);

		pos = flod_pos2db_ptr(ofp->ibuf.r.pos);
		switch ((DCC_FLOD_POS_OPS)pos) {
		case DCC_FLOD_POS_END:
			/* Wait for all of the final status message or
			 * until the target closes the TCP connection.
			 * Do not worry if the target stops without
			 * asking nicely, since at worst we will
			 * resend whatever was in the pipe next time. */
			if (ofp->ibuf_len <= ISZ(ofp->ibuf.r.end)
			    && recv_len != 0)
				goto again;
			/* shut down after trying to recognize
			 * a complaint from the target */
			fail = oflod_parse_eof(ofp, 0,
					       &ofp->ibuf.r.end,
					       ofp->ibuf_len - FLOD_END_OVHD);
			ferr(ofp, 0, FERR_IO, fail>=0,
			     "outgoing flood end 'status from %s \"%.*s\"'",
			     ofp_rem_str(ofp),
			     ofp->ibuf_len - FLOD_END_OVHD,
			     ofp->ibuf.r.end.msg);
			if (fail < 0)
				oflod_backoff(ofp, 0);
			oflod_close(ofp, fail<0);
			return;

		case DCC_FLOD_POS_END_REQ:
			/* try to update our pointers and shutdown() */
			start_shutdown(ofp);
			ofp->mp->otimers.retry_secs = FLOD_RETRY_SECS;
			ofp->mp->otimers.retry = (db_time.tv_sec
						  + FLOD_RETRY_SECS);
			if (ofp->mp->flags & FLODMAP_FG_PASSIVE) {
				ferr(ofp, 1, FERR_IO, 1,
				     "outgoing end request from %s;"
				     " passive output",
				     ofp_rem_str(ofp));
			} else {
				ferr(ofp, 1, FERR_IO, 1,
				     "outgoing end request from %s;"
				     " postpone restarting for %d seconds",
				     ofp_rem_str(ofp), FLOD_RETRY_SECS);
			}
			break;

		case DCC_FLOD_POS_NOTE:
			/* wait until we get the length of the complaint */
			if (ofp->ibuf_len < FLOD_NOTE_OVHD)
				goto again;
			used = ofp->ibuf.r.note.len;
			if (used > ISZ(ofp->ibuf.r.note)
			    || used <= FLOD_NOTE_OVHD) {
				ferr(ofp, 0, FERR_IO, 0,
				     "bogus outgoing flood note length"
				     " %d from %s",
				     used, ofp_rem_str(ofp));
				oflod_close(ofp, 1);
				return;
			}
			if (ofp->ibuf_len < used)
				goto again;
			TMSG3_FLOD1(ofp, "received outgoing flood note from"
				    " %s: \"%.*s\"",
				    ofp_rem_str(ofp),
				    used-FLOD_NOTE_OVHD, ofp->ibuf.r.note.str);
			break;

		case DCC_FLOD_POS_COMPLAINT:
			/* wait until we get the length of the complaint */
			if (ofp->ibuf_len < FLOD_NOTE_OVHD)
				goto again;
			used = ofp->ibuf.r.note.len;
			if (used > ISZ(ofp->ibuf.r.note)
			    || used <= FLOD_NOTE_OVHD) {
				ferr(ofp, 0, FERR_IO, 0,
				     "bogus outgoing flood complaint length"
				     " %d from %s",
				     used, ofp_rem_str(ofp));
				oflod_close(ofp, 1);
				return;
			}
			if (ofp->ibuf_len < used)
				goto again;
			if (CK_FLOD_CNTERR(&ofp->lc.complaint))
				flod_cnterr(&ofp->lc.complaint,
					    "outgoing flood complaint from %s:"
					    " %.*s",
					    ofp_rem_str(ofp),
					    used - FLOD_NOTE_OVHD,
					    ofp->ibuf.r.note.str);
			break;

		case DCC_FLOD_POS_REWIND:
			dcc_trace_msg("flood rewind request from %s",
				      ofp_rem_str(ofp));
			ofp->mp->flags |= FLODMAP_FG_REWINDING;
			ofp->cur_pos = ofp->mp->confirm_pos = DB_PTR_BASE;
			ofp->recv_pos = ofp->xmit_pos = DB_PTR_BASE;
			ofp->rewind_pos = db_csize;
			get_oflods_max_cur_pos();
			oflod_fill(ofp);
			break;

		case DCC_FLOD_POS_FFWD_IN:
			dcc_trace_msg("received FFWD output from %s",
				      ofp_rem_str(ofp));
			ofp->cur_pos = db_csize;
			get_oflods_max_cur_pos();
			break;


		default:
			/* The position from the peer must be one we sent,
			 * and in the window we expect unless our
			 * window has been broken by rewinding.
			 * Even if our window is broken, the position must
			 * be reasonable. */
			if ((pos < ofp->recv_pos
			     || pos > ofp->xmit_pos)
			    && (!(ofp->mp->flags & FLODMAP_FG_REWINDING)
				|| pos < DCC_FLOD_POS_MIN
				|| pos > db_csize)) {
				ferr(ofp, 0, FERR_IO, 0,
				     "bogus confirmed flood position"
				     " "L_HxPAT" from %s;"
				     " recv_pos="L_HxPAT"  xmit_pos="L_HxPAT,
				     pos, ofp_rem_str(ofp),
				     ofp->recv_pos, ofp->xmit_pos);
				oflod_close(ofp, 1);
				return;
			}
			ofp->recv_pos = pos;
			if (ofp->xmit_pos == ofp->recv_pos)
				ofp->mp->confirm_pos = ofp->cur_pos;
			else if (ofp->mp->confirm_pos < ofp->recv_pos)
				ofp->mp->confirm_pos = ofp->recv_pos;

			/* things are going ok, so reset the connect() backoff
			 * and the no-connection complaint */
			ofp->mp->otimers.retry_secs = 0;
			ofp->mp->otimers.msg_secs = FLOD_IN_COMPLAIN1;
			ofp->mp->otimers.msg = (db_time.tv_sec
						+ FLOD_IN_COMPLAIN1);
			break;
		}

		ofp->ibuf_len -= used;
		if (ofp->ibuf_len == 0)
			return;
		if (ofp->ibuf_len < 0)
			dcc_logbad(EX_SOFTWARE, "ofp->ibuf_len=%d",
				   ofp->ibuf_len);
		/* assume there will rarely be more than one position
		 * in the buffer */
		memmove(ofp->ibuf.b, &ofp->ibuf.b[used], ofp->ibuf_len);
	}

	if (recv_len == 0) {
		/* before closing, the peer is supposed to send a
		 * "position" of DCC_FLOD_POS_END followed by
		 * an ASCII message */
		if (ofp->ibuf_len != 0)
			ferr(ofp, 0, FERR_IO, 0,
			     "truncated outgoing flood response from %s",
			     ofp_rem_str(ofp));
		else
			ferr(ofp, 0, FERR_IO, 0,
			     "missing outgoing flood response from %s",
			     ofp_rem_str(ofp));
		oflod_close(ofp, 1);

		/* Quit without touching anything more if flooding is
		 * shutting down and that was the last connection. */
		if (!ofp->mp)
			return;
	}
}



static void
oflods_ck(void)
{
	OFLOD_INFO *ofp;

	for (ofp = oflods.infos; ofp <= LAST(oflods.infos); ++ofp) {
		if (ofp->rem_hostname[0] == '\0')
			break;

		if (ofp->flags & OFLOD_FG_EAGAIN) {
			TMSG1_FLOD1(ofp, "resume flooding %s after EAGAIN",
				    ofp->rem_hostname);
			ofp->flags &= ~OFLOD_FG_EAGAIN;
		}

		if (!(ofp->flags & OFLOD_FG_CONNECTED))
			continue;

		/* the peer has failed to respond to a shutdown request */
		if (ofp->flags & (OFLOD_FG_SHUTDOWN_REQ | OFLOD_FG_SHUTDOWN)) {
			if (stopint && OFP_DEAD(ofp, SHUTDOWN_DELAY)) {
				ferr(ofp, 0, FERR_STOP, 1,
				     "stopping; forced close flood to %s",
				     ofp_rem_str(ofp));
				oflod_close(ofp, 0);

			} else if (OFP_DEAD(ofp, KEEPALIVE_OUT_STOP)) {
				ferr(ofp, 0, FERR_STOP, 1,
				     "off; forced close flood to %s",
				     ofp_rem_str(ofp));
				oflod_close(ofp, 0);
			}
			continue;
		}

		/* Shut down any streams that have been quiet for too long.
		 * If the TCP connection is healthy we should at least have
		 * received keep alive position repetitions or "are you there?"
		 * notes from the peer. */
		if (OFP_DEAD(ofp, KEEPALIVE_OUT)) {
			ferr(ofp, 0, FERR_STOP, 1,
			     "keepalive start shutdown flood to %s",
			     ofp_rem_str(ofp));
			start_shutdown(ofp);
			continue;
		}
	}
}



static void
oflods_stop(u_char force)
{
	OFLOD_INFO *ofp;

	if (!flod_mmaps)
		return;

	for (ofp = oflods.infos; ofp <= LAST(oflods.infos); ++ofp) {
		if (ofp->rem_hostname[0] == '\0')
			break;
		if (ofp->soc < 0)
			continue;
		if (force || !(ofp->flags & OFLOD_FG_CONNECTED)) {
			ferr(ofp, 0, FERR_STOP, 1, "halting flood to %s",
			     ofp_rem_str(ofp));
			oflod_close(ofp, 0);
		} else if (!(ofp->flags & (OFLOD_FG_SHUTDOWN_REQ
					   | OFLOD_FG_SHUTDOWN))) {
			ferr(ofp, 0, FERR_STOP, 1, "stopping flood to %s",
			     ofp_rem_str(ofp));
			start_shutdown(ofp);
		}
	}

	if (resolve_hosts_pid > 0)
		kill(resolve_hosts_pid, SIGINT);
	flod_names_resolve_ck();

	if (oflods.open == 0 && iflods.open == 0)
		oflods_clear();
}



void
flods_stop(const char *iflod_msg, u_char force)
{
	flods_st = FLODS_ST_OFF;
	iflods_stop(iflod_msg, force);
	oflods_stop(force);
}



/* (re)start listening for incoming floods and sending outgoing floods */
void
flods_restart(const char *msg, u_char force_ck)
{
	if (FLODS_OK())
		flods_st = FLODS_ST_RESTART;
	iflods_stop(msg, 0);
	flods_ck(force_ck);
}



/* load the ids file if it has changed */
int					/* -1=our ID missing,  0=sick file */
check_load_ids(u_char mode)		/* 0=if needed, 1=reboot, 2=new db */
{
	const ID_TBL *tp;
	int result;

	result = load_ids(&dcc_emsg, my_srvr_id, &tp,
			  mode != 0, db_debug != 0);
	if (result == 2)
		return 1;
	if (result <= 0)
		return result;

	if (mode == 0 || ( mode == 2 && db_debug))
		dcc_trace_msg("reloaded %s", ids_path.c);

	if (mode == 0)
		flods_restart("restart flooding with new IDs", 0);

	if (flod_mtime > 1)
		flod_mtime = 1;

	return 1;
}



static void
flod_msg(LAST_FERR *ep, const char *str, const char *arg)
{
	const char *msg;

	if (ep->error_type != FERR_NONE
	    && ep->error_gen != flod_msg_gen) {
		msg = ep->error_msg;
		ep->error_gen = flod_msg_gen;
	} else if (ep->trace_type != FERR_NONE
		   && ep->trace_gen != flod_msg_gen) {
		msg = ep->trace_msg;
		ep->trace_gen = flod_msg_gen;
	} else {
		msg = "";
	}
	dcc_error_msg("no %s %s%s%s%s", str, arg,
		      msg[0] ? ": \"" : "",
		      msg,
		      msg[0] ? "\"" : "");
}



/* called periodically and at need */
void
flods_ck(u_char force)
{
	static int map_delayed;
	DB_ST *rcd_st;
	IFLOD_INFO *ifp;
	OFLOD_INFO *ofp;
	struct stat flod_sb;
	time_t us;
	DCC_TS past;
	int rcd_len;
	int work;
	u_char loaded;			/* mapped flod.map file just for this */

	if (force)			/* force hostname resolution */
		got_hosts = 0;

	for (ifp = iflods.infos; ifp <= LAST(iflods.infos); ++ifp) {
		if (ifp->soc < 0)
			continue;

		/* end incoming connections that are not completed in time */
		ofp = ifp->ofp;
		if (!ofp) {
			iflod_read(ifp);
			if (ifp->soc < 0)
				continue;
			ofp = ifp->ofp;
			if (!ofp) {
				if (IFP_DEAD(ifp, KEEPALIVE_IN_STOP))
					iflod_close(ifp, 1, 1, 0,
						    "no authentication from %s",
						    ifp_rem_str(ifp));
				continue;
			}
		}

		/* allow more complaints */
		if (DB_IS_TIME(ofp->limit_reset, FLOD_LIM_CLEAR_SECS)
		    || force) {
			FLOD_LIMCNT *lc;

			complained_many_iflods = 0;
			for (lc = (FLOD_LIMCNT *)&ofp->lc;
			     lc < (FLOD_LIMCNT *)(sizeof(ofp->lc)
						  +(char *)&ofp->lc);
			     ++lc) {
				lc->lim = lc->cur;
			}
			ofp->limit_reset = db_time.tv_sec+FLOD_LIM_CLEAR_SECS;
		}

		if (!(ifp->flags & IFLOD_FG_VERS_CK))
			continue;	/* done if peer not really known */

		save_flod_cnts(ofp);

		if (!IFP_DEAD(ifp, KEEPALIVE_IN)) {
			/* The link is warm.
			 * Send a delayed position update if needed. */
			iflod_send_pos(ifp, 0);

		} else if (ifp->flags & IFLOD_FG_END_REQ) {
			/* The link is cold. If we have asked the peer to
			 * stop but it has not, then break the link. */
			iflod_close(ifp, 1, 0, 0, "%s ignored close request",
				    ifp_rem_str(ifp));

		} else {
			/* The link is cold., so repeat our position or
			 * send a note as a keepalive.
			 * The connection will be closed if that fails. */
			iflod_send_pos(ifp, 1);
		}
	}

	if (FLODS_OK()) {
		/* stop and restart the pumps if the list of peers has
		 * changed or if our map has disappeared
		 * and if dbclean is not running */
		if (0 > stat(flod_path.c, &flod_sb)) {
			if (errno != ENOENT
			    && flod_mtime != 0)
				dcc_error_msg("stat(%s): %s",
					      DB_NM2PATH_ERR(flod_path.c),
					      ERROR_STR());
			flod_sb.st_mtime = 0;
		}
		if (flod_mtime != 0
		    && 0 > access(flod_mmap_path.c, W_OK | R_OK)) {
			if (errno != ENOENT)
				dcc_error_msg("access(%s): %s",
					      DB_NM2PATH_ERR(flod_mmap_path.c),
					      ERROR_STR());
			flod_sb.st_mtime = 0;
		}
		if (flods_st != FLODS_ST_RESTART
		    && flod_sb.st_mtime != flod_mtime) {
			if (flod_mtime > 1) {
				dcc_trace_msg("%s has changed",
					      DB_NM2PATH_ERR(flod_path.c));
				flod_mtime = 0;
			}
			flods_st = FLODS_ST_RESTART;
		}
	}

	if (flods_st != FLODS_ST_ON) {
		flods_stop("", 0);

		/* wait until the previous floods have stopped and dbclean
		 * is not running to restart flooding */
		if (FLODS_OK() && DB_IS_LOCKED()) {
			if (oflods.open != 0 || iflods.open != 0
			    || !flod_names_resolve_ck()) {
				flods_st = FLODS_ST_RESTART;
				/* check again soon but not immediately */
				RUSH_NEXT_FLODS_CK();
			} else {
				if (load_flod(0, 1))
					flods_st = FLODS_ST_ON;
			}
		}
	}

	/* try to reap the hostname resolving child */
	flod_names_resolve_ck();

	/* that is all we can do if flooding is off or dbclean is running */
	if (!FLODS_OK_ON()) {
		oflods_ck();
		return;
	}

	iflods_listen();

	/* generate summaries of some of our delayed reports */
	if (flod_mmaps && !dbclean_running) {
		timeval2ts(&past, &db_time, -summarize_delay_secs);
		if (flod_mmaps->delay_pos > db_csize
		    || flod_mmaps->delay_pos < DB_PTR_BASE)
			flod_mmaps->delay_pos = DB_PTR_BASE;
		work = 0;
		rcd_st = GET_DB_ST();
		while (flod_mmaps->delay_pos < db_csize) {
			if (!db_map_rcd(0, rcd_st, flod_mmaps->delay_pos,
					&rcd_len)) {
				flod_mmaps->delay_pos = db_csize;
				break;
			}
			/* only our own reports are delayed */
			if (DB_RCD_DELAY(rcd_st->d.r)) {
				struct timeval trace_time;

				/* wait until it is time */
				if (ts_newer_ts(&rcd_st->d.r->ts, &past))
					break;
				if (TMSG_BIT(DB))
					gettimeofday(&trace_time, 0);
				if (!summarize_dly(rcd_st)) {
					flod_mmaps->delay_pos = db_csize;
					break;
				}
				if (TMSG_BIT(DB)) {
					gettimeofday(&db_time, 0);
					us = tv_diff2us(&db_time, &trace_time);
					if (us >= DCC_US/10)
					    dcc_trace_msg("spent %.3f"
							" seconds summarizing "
							L_HxPAT,
							us/(DCC_US*1.0),
							flod_mmaps->delay_pos);
				}
			}
			flod_mmaps->delay_pos += rcd_len;

			/* spend at most 0.25 second at this
			 * and then let other processes run*/
			if (++work >= 50) {
				gettimeofday(&db_time, 0);
				us = tv_diff2us(&db_time, &wake_time);
				if (us > DCC_US/4) {
					next_flods_ck = 0;
					break;
				}
				work = 0;
			}
		}
		free_db_st(rcd_st);

		/* prime the outgoing pumps */
		for (ofp = oflods.infos;
		     ofp <= LAST(oflods.infos)
		     && ofp->rem_hostname[0] != '\0';
		     ++ofp) {
			if (ofp->soc >= 0) {
				/* The connection is no longer new if it has
				 * been a while since it was completed */
				if ((ofp->flags & OFLOD_FG_NEW)
				    && DB_IS_TIME(ofp->mp->cnts.out_conn_changed
						  + FLODS_CK_SECS,
						  FLODS_CK_SECS))
					ofp->flags &= ~OFLOD_FG_NEW;
				oflod_fill(ofp);
			} else {
				oflod_open(ofp);
			}

			iflod_socks_start(ofp);
		}
	}

	/* complain once per day about incoming links that are not working
	 * even if dbclean is continually running. */
	loaded = 0;
	if (flod_mmaps) {
		map_delayed = 0;
	} else if ((force || ++map_delayed > 10) && load_flod(0, 0)) {
		loaded = 1;
		map_delayed = 0;
	}
	for (ofp = oflods.infos;
	     ofp <= LAST(oflods.infos)
	     && ofp->rem_hostname[0] != '\0'
	     && flod_mmaps;
	     ++ofp) {
		FLOD_MMAP *mp;

		if (force) {
			/* Force new outgoing connection attempts.  Also force
			 * incoming error messages soon but not now to give new
			 * connetions a chance to be triggered by outgoing
			 * connections.  */
			flod_try_again(ofp, 0);
		}

		mp = ofp->mp;
		if (ofp->soc < 0
		    && (mp->flags & FLODMAP_FG_PASSIVE)
		    && !OFLOD_OPT_OFF_ROGUE(ofp)
		    && DB_IS_TIME(mp->otimers.msg, mp->otimers.msg_secs)) {
			flod_msg(&mp->oflod_err,
				 "passive connection to", ofp->rem_hostname);
			mp->otimers.msg_secs = FLOD_IN_COMPLAIN;
			mp->otimers.msg = db_time.tv_sec + FLOD_IN_COMPLAIN;
		}

		/* consider missing inputs */
		if (ofp->ifp)
			continue;

		if ((mp->flags & FLODMAP_FG_ACT) == 0
		    && !IFLOD_OPT_OFF_ROGUE(ofp)
		    && DB_IS_TIME(mp->itimers.msg, mp->itimers.msg_secs)) {
			flod_msg(&mp->iflod_err,
				 "incoming connection from", ofp->rem_hostname);
			mp->itimers.msg_secs = FLOD_IN_COMPLAIN;
			mp->itimers.msg = db_time.tv_sec + FLOD_IN_COMPLAIN;
		}

		/* try NAT kludge around a firewall if output is working
		 * but input is dead */
		if ((ofp->flags & OFLOD_FG_CONNECTED)
		    && DB_IS_TIME(ofp->mp->cnts.out_conn_changed
				  + FLOD_AUTO_NAT_DELAY,
				  FLOD_AUTO_NAT_DELAY)
		    && DB_IS_TIME(ofp->mp->cnts.in_conn_changed
				  + FLOD_AUTO_NAT_DELAY,
				  FLOD_AUTO_NAT_DELAY)
		    && !(ofp->flags & (OFLOD_FG_NEW
				       | OFLOD_FG_SHUTDOWN_REQ
				       | OFLOD_FG_SHUTDOWN))
		    && !(mp->flags & (FLODMAP_FG_NAT_AUTO
				      | FLODMAP_FG_OUT_SRVR
				      | FLODMAP_FG_PASSIVE
				      | FLODMAP_FG_ACT))) {
			dcc_trace_msg("try auto-NAT work-around from %s",
				      ofp->rem_hostname);
			mp->flags |= FLODMAP_FG_NAT_AUTO;
		}
	}
	if (loaded)
		oflods_clear();

	oflods_ck();
}



void
flods_init(void)
{
	IFLOD_INFO *ifp;

	for (ifp = iflods.infos; ifp <= LAST(iflods.infos); ++ifp)
		ifp->soc = -1;
	oflods_clear();

	flods_restart("", 1);
}
