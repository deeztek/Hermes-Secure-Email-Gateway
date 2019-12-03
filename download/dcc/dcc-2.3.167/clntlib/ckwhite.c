/* Distributed Checksum Clearinghouse
 *
 * check checksums in the local whitelist
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
 * Rhyolite Software DCC 2.3.167-1.148 $Revision$
 */

#include "dcc_ck.h"


static const WHITE_MAGIC white_magic = WHITE_MAGIC_B_STR WHITE_MAGIC_V_STR;

#define EMPTY_WHITE_SIZE    (sizeof(WHITE_TBL) - sizeof(WHITE_ENTRY))
#define MAX_WHITE_ENTRIES   (WHITE_TBL_BINS*10)
#define ENTRIES2SIZE0(_l)   (sizeof(WHITE_TBL) - sizeof(WHITE_ENTRY)	\
			     + ((_l) * sizeof(WHITE_ENTRY)))
#ifdef DCC_WIN32
	/* Make the hash table files maximum size on WIN32.
	 * You cannot change the size of a WIN32 mapping object without
	 * getting all processes using it to release it so that it can be
	 * recreated.  This may cause problems if the size of hash table
	 * header changes.
	 * Since the file does not change size, there is no need to remap it */
#define ENTRIES2SIZE(_l)   ENTRIES2SIZE0(MAX_WHITE_ENTRIES)
#else
#define ENTRIES2SIZE(_l)   ENTRIES2SIZE0(_l)
#endif


WF cmn_wf, cmn_tmp_wf;


void
wf_init(WF *wf,
	u_int wf_flags)			/* WF_* */
{
	memset(wf, 0, sizeof(*wf));
	wf->ht_fd = -1;
	wf->wf_flags = wf_flags & ~WF_NOFILE;
}



/* this is needed only on systems without coherent mmap()/read()/write() */
static void
sync_white(WF *wf)
{
	if (wf->wtbl
	    && 0 > MSYNC(wf->wtbl, wf->wtbl_size, MS_SYNC))
		dcc_error_msg("msync(%s): %s", wf->ht_nm.c, ERROR_STR());
}



#define STILL_BROKE(wf,now) ((wf)->broken != 0				\
			     && !DCC_IS_TIME(now, (wf)->broken,		\
					     WHITE_BROKEN_DELAY))
static void
is_broken(WF *wf)
{
	wf->broken = time(0) + WHITE_BROKEN_DELAY;

	/* This is racy, but the worst that can happen is that
	 * another process races to set the retry timer */
	if (!(wf->wf_flags & WF_RO) && wf->wtbl) {
		wf->wtbl->hdr.broken = wf->broken;
		sync_white(wf);
	}
}



static void
unmap_white_ht(WF *wf)
{
	if (!wf->wtbl)
		return;

	sync_white(wf);
#ifdef DCC_WIN32
	dcc_win32_unmap(&wf->ht_map, wf->wtbl, wf->ht_nm);
#else
	if (0 > munmap((void *)wf->wtbl, wf->wtbl_size))
		dcc_error_msg("munmap(%s,%d): %s",
			      wf->ht_nm.c, wf->wtbl_size, ERROR_STR());
#endif
	wf->wtbl = 0;
}



static u_char				/* 1=done, 0=failed */
map_white_ht(DCC_EMSG *emsg, WF *wf, WHITE_INX entries)
{
	size_t size;
#ifndef DCC_WIN32
	void *p;
#endif

	unmap_white_ht(wf);

	if (entries > MAX_WHITE_ENTRIES) {
		dcc_pemsg(EX_IOERR, emsg, "%s should not contain %d entries",
			  wf->ht_nm.c, entries);
		return 0;
	}

	size = ENTRIES2SIZE(entries);
#ifdef DCC_WIN32
	if (!wf->wtbl) {
		wf->wtbl = dcc_win32_map(emsg, &wf->ht_map, wf->ht_nm.c,
					 wf->ht_fd, size);
		if (!wf->wtbl)
			return 0;
	}
#else
	p = mmap(0, size,
		 (wf->wf_flags & WF_RO)
		 ? PROT_READ : (PROT_READ|PROT_WRITE),
		 MAP_SHARED, wf->ht_fd, 0);
	if (p == MAP_FAILED) {
		dcc_pemsg(EX_IOERR, emsg, "mmap(%s,%d): %s",
			  wf->ht_nm.c, (int)size, ERROR_STR());
		return 0;
	}
	wf->wtbl = p;
#endif
	wf->wtbl_size = size;
	wf->wtbl_entries = entries;
	wf->wtbl_fgs = wf->wtbl->hdr.fgs;
	wf->wtbl_sws = wf->wtbl->hdr.sws;

	return 1;
}



static u_char
close_white_ht(DCC_EMSG *emsg, WF *wf)
{
	u_char result = 1;

	if (wf->ht_fd < 0)
		return result;

	wf->closed = 1;

	unmap_white_ht(wf);

#ifdef DCC_WIN32
	/* unlock the file before closing it to keep Win95 happy */
	if (!dcc_unlock_fd(emsg, wf->ht_fd, DCC_LOCK_ALL_FILE,
			   "whitelist ", wf->ht_nm.c))
		result = 0;
#endif
	if (0 > close(wf->ht_fd)) {
		dcc_pemsg(EX_IOERR, emsg, "close(%s): %s",
			  wf->ht_nm.c, ERROR_STR());
		result = 0;
	}

	wf->ht_fd = -1;
	memset(&wf->ht_sb, 0, sizeof(wf->ht_sb));
#ifndef DCC_WIN32
	wf->ht_sb.st_dev = -1;
	wf->ht_sb.st_ino = -1;
#endif
	return result;
}



int				/* 0=ok -1=failed */
unlink_white_ht(DCC_EMSG *emsg,
		WF *wf,
		time_t now)		/* 0=our own new file */
{
	int result;

	/* mark it bad if it is a brand new hash table */
	if (!now && wf->wtbl && !(wf->wf_flags & WF_RO))
		wf->wtbl->hdr.ascii_mtime = 0;

#ifdef DCC_WIN32
	/* racy but you cannot unlink an open file on WIN32 */
	close_white_ht(0, wf);
#endif
	result = -1;
	if (!(wf->wf_flags & WF_RO)) {
		if (0 <= unlink(wf->ht_nm.c) || errno == ENOENT) {
			result = 0;
#ifndef DCC_WIN32
		} else if ((errno == EACCES || errno == EPERM)
			   && dcc_get_priv_home(wf->ht_nm.c)) {
			if (0 <= unlink(wf->ht_nm.c))
				result = 0;
			dcc_rel_priv();
#endif
		}
		if (result < 0)
			dcc_pemsg(EX_IOERR, emsg,"unlink(%s): %s",
				  wf->ht_nm.c, ERROR_STR());
	}

	/* If we failed to unlink the old hash table,
	 * remember in core that things are broken but do not touch the file
	 * in case it is a link to /etc/passwd or something else dangerous */
	if (result < 0 && now)
		wf->broken = now + WHITE_BROKEN_DELAY;
#ifndef DCC_WIN32
	close_white_ht(0, wf);
#endif

	return result;
}



u_char
new_ht_nm(DCC_EMSG *emsg, WF *wf, u_char new)
{
	if (wf->ascii_nm_len >= ISZ(wf->ht_nm) - LITZ(WHITE_SUFFIX)) {
		dcc_pemsg(EX_NOINPUT, emsg, "bad whitelist file name \"%s\"",
			  wf->ascii_nm.c);
		is_broken(wf);
		return 0;
	}

	memcpy(wf->ht_nm.c, wf->ascii_nm.c, wf->ascii_nm_len);
	strcpy(&wf->ht_nm.c[wf->ascii_nm_len],
	       new ? WHITE_NEW_SUFFIX : WHITE_SUFFIX);
	return 1;
}



u_char
dcc_new_white_nm(DCC_EMSG *emsg, WF *wf,
		 const char *new_white_nm)
{
	DCC_PATH new_path;
	const char *new;
	u_int len;
	int i;

	if (!strcmp(new_white_nm, wf->ascii_nm.c))
		return 1;

	close_white_ht(0, wf);
	wf_init(wf, wf->wf_flags);

	if (!dcc_fnm2rel(&new_path, new_white_nm, 0)) {
		dcc_pemsg(EX_USAGE, emsg, "bad whitelist name \"%s\"",
			  new_white_nm);
		return 0;
	}

	len = strlen(new_path.c);
	i = len - LITZ(WHITE_SUFFIX);
	if (i > 0 && (!strcmp(&new_path.c[i], WHITE_SUFFIX)
		      || !strcmp(&new_path.c[i], WHITE_NEW_SUFFIX))) {
		len = i;
		new_path.c[len] = '\0';
	}

	if (len > ISZ(wf->ht_nm) - ISZ(WHITE_SUFFIX)) {
		dcc_pemsg(EX_USAGE, emsg, "long whitelist name \"%s\"",
			  new_white_nm);
		return 0;
	}

	new = dcc_path2fnm(new_path.c);
	len = strlen(new);
	memcpy(wf->ascii_nm.c, new, len+1);
	wf->ascii_nm_len = len;
	return 1;
}



/* open and shared-lock a hash table file */
static int				/* -1=fatal 0=rebuild, 1=ok */
open_white_ht(DCC_EMSG *emsg, WF *wf)
{
	int size;
	WHITE_INX entries;

	close_white_ht(0, wf);

	if (!new_ht_nm(emsg, wf, 0))
		return -1;

	wf->ht_fd = dcc_lock_open(emsg, wf->ht_nm.c,
				  (wf->wf_flags & WF_RO)
				  ? O_RDONLY : O_RDWR,
				  DCC_LOCK_OPEN_SHARE,
				  DCC_LOCK_ALL_FILE, 0);
	if (wf->ht_fd < 0) {
		/* We failed to open the file.
		 * If this is a `wlist` command and neither -P nor -Q
		 * were specified, try to open the file read-only. */
		if ((wf->wf_flags & WF_WLIST)
		    && !(wf->wf_flags & (WF_WLIST_RO | WF_WLIST_RW))) {
			if (emsg)
				emsg->c[0] = '\0';
			wf->wf_flags |= WF_RO;
			wf->ht_fd = dcc_lock_open(emsg, wf->ht_nm.c,
						  O_RDONLY,
						  DCC_LOCK_OPEN_SHARE,
						  DCC_LOCK_ALL_FILE, 0);
		}
		if (wf->ht_fd < 0)
			return 0;
	}

	if (fstat(wf->ht_fd, &wf->ht_sb) < 0) {
		dcc_pemsg(EX_IOERR, emsg, "stat(%s): %s",
			  wf->ht_nm.c, ERROR_STR());
		close_white_ht(0, wf);
		is_broken(wf);
		return -1;
	}

	size = wf->ht_sb.st_size - EMPTY_WHITE_SIZE;
	if (size < 0) {
		dcc_pemsg(EX_NOINPUT, emsg,
			  "%s is too small to be a DCC whitelist hash table",
			  wf->ht_nm.c);
		return unlink_white_ht(0, wf, time(0));

	} else {
		entries = size / sizeof(WHITE_ENTRY);
		if (!map_white_ht(emsg, wf, entries))
			return unlink_white_ht(0, wf, time(0));
	}

	if (memcmp(&wf->wtbl->magic, &white_magic, sizeof(white_magic))) {
		/* rebuild old format files */
		if (!memcmp(&wf->wtbl->magic, WHITE_MAGIC_B_STR,
			    LITZ(WHITE_MAGIC_B_STR))) {
			if (dcc_clnt_debug)
				dcc_trace_msg("%s is obsolete %s",
					      wf->ht_nm.c, wf->wtbl->magic);
		} else {
			dcc_pemsg(EX_NOINPUT, emsg,
				  "%s is not a DCC whitelist hash file",
				  wf->ht_nm.c);
		}
		return unlink_white_ht(0, wf, time(0));
	}

	if ((size % sizeof(WHITE_ENTRY)) != 0
	    || entries > MAX_WHITE_ENTRIES
	    || entries < wf->wtbl->hdr.entries) {
		dcc_pemsg(EX_NOINPUT, emsg,
			  "invalid size of whitelist %s="OFF_DPAT,
			  wf->ht_nm.c, wf->ht_sb.st_size);
		return unlink_white_ht(0, wf, time(0));
	}

	if (wf->wtbl->hdr.ascii_mtime == 0) {
		close_white_ht(0, wf);
		return 0;		/* broken hash table */
	}

	/* we know the hash table is usable
	 * but we might want to rebuild it */
	wf->need_reopen = 0;
	wf->wtbl_fgs = wf->wtbl->hdr.fgs;
	wf->wtbl_sws = wf->wtbl->hdr.sws;

	/* wlist and dccproc work on both per-user and global whitelists,
	 * so do not change the nature of the file if it is already known */
	if (wf->wf_flags & WF_EITHER) {
		if (wf->wtbl_fgs & WHITE_FG_PER_USER)
			wf->wf_flags |= WF_PER_USER;
		else
			wf->wf_flags &= ~WF_PER_USER;
	}

	return 1;
}



static void
create_white_ht_sub(DCC_EMSG *emsg, WF *new_wf, const WF *wf,
		    u_char *busyp)
{
	/* do not use O_EXCL because we want to wait for any other
	 * process to finish
	 *
	 * wait if and only if we do not have a usable file open */

	new_wf->ht_fd = dcc_lock_open(emsg, new_wf->ht_nm.c,
			   O_RDWR | O_CREAT,
			   wf->ht_fd >= 0 ? DCC_LOCK_OPEN_NOWAIT : 0,
			   DCC_LOCK_ALL_FILE, busyp);
	if (new_wf->ht_fd < 0)
		return;

	/* a new hash table must be empty */
	if (0 > fstat(new_wf->ht_fd, &new_wf->ht_sb)) {
		dcc_pemsg(EX_IOERR, emsg, "stat(%s): %s",
			  new_wf->ht_nm.c, ERROR_STR());
		close_white_ht(emsg, new_wf);
		return;
	}

	if (new_wf->ht_sb.st_size != 0) {
		dcc_pemsg(EX_IOERR, emsg, "%s has non-zero size %d",
			  new_wf->ht_nm.c, (int)new_wf->ht_sb.st_size);
		close_white_ht(emsg, new_wf);
		return;
	}
}



/* create and write-lock a new hash table file
 *	wait for lock if we don't have existing file open */
static int				/* 1=done, 0=file busy, -1=fatal */
create_white_ht(DCC_EMSG *emsg,
		WF *tmp_wf,		/* build with this */
		const WF *wf)		/* from this */
{
	u_char busy = 0;

	tmp_wf->ascii_nm_len = wf->ascii_nm_len;
	memcpy(tmp_wf->ascii_nm.c, wf->ascii_nm.c, wf->ascii_nm_len+1);
	if (!new_ht_nm(emsg, tmp_wf, 1)) {
		tmp_wf->ht_nm.c[0] = '\0';
		return -1;
	}

	if (tmp_wf->wf_flags & WF_RO) {
		dcc_pemsg(EX_IOERR, emsg,
			  "read only access; cannot create or update %s",
			  tmp_wf->ht_nm.c);
		tmp_wf->ht_nm.c[0] = '\0';
		return -1;
	}

#ifndef DCC_WIN32
	/* We want to create a private hash table if the ASCII file
	 * is private, but a hash table owned by the DCC user if the
	 * ASCII file is public */
	if (0 > access(tmp_wf->ascii_nm.c, R_OK | W_OK)
	    && dcc_get_priv_home(tmp_wf->ht_nm.c)) {
		/* first try to open a public hash table */
		create_white_ht_sub(emsg, tmp_wf, wf, &busy);
		if (tmp_wf->ht_fd < 0 && !busy) {
			if (emsg && dcc_clnt_debug > 2)
				dcc_error_msg("%s", emsg->c);
			unlink(tmp_wf->ht_nm.c);
			create_white_ht_sub(emsg, tmp_wf, wf, &busy);
		}
		dcc_rel_priv();
	}
#endif

	if (tmp_wf->ht_fd < 0 && !busy) {
		/* try to open or create a private hash table */
		create_white_ht_sub(emsg, tmp_wf, wf, &busy);
		if (tmp_wf->ht_fd < 0 && !busy) {
			if (emsg && dcc_clnt_debug > 2)
				dcc_error_msg("%s", emsg->c);
			unlink(tmp_wf->ht_nm.c);
			create_white_ht_sub(emsg, tmp_wf, wf, &busy);
		}
	}

#ifndef DCC_WIN32
	/* try one last time with privileges in case the ASCII file has
	 * mode 666 but the directory does not */
	if (tmp_wf->ht_fd < 0 && !busy) {
		if (dcc_get_priv_home(tmp_wf->ht_nm.c)) {
			if (emsg && dcc_clnt_debug > 2)
				dcc_error_msg("%s", emsg->c);
			unlink(tmp_wf->ht_nm.c);
			create_white_ht_sub(emsg, tmp_wf, wf, &busy);
			dcc_rel_priv();
		}
	}
#endif
	if (tmp_wf->ht_fd < 0) {
		tmp_wf->ht_nm.c[0] = '\0';
		if (busy)
			return 0;
		return -1;
	}
	return 1;
}



#define FIND_WHITE_BROKEN ((WHITE_ENTRY *)-1)
static WHITE_ENTRY *
find_white(DCC_EMSG *emsg, WF *wf, DCC_CK_TYPES type, const DCC_SUM *sum,
	   WHITE_INX *binp)
{
	u_long accum;
	WHITE_INX bin, inx;
	WHITE_ENTRY *e;
	int loop_cnt, i;

	if (!wf->wtbl || wf->wtbl->hdr.ascii_mtime == 0)
		return FIND_WHITE_BROKEN;

	accum = type;
	for (i = sizeof(DCC_SUM)-1; i >= 0; --i)
		accum = (accum >> 28) + (accum << 4) + sum->b[i];
	bin = accum % DIM(wf->wtbl->bins);
	if (binp)
		*binp = bin;
	inx = wf->wtbl->bins[bin];

	for (loop_cnt = wf->wtbl->hdr.entries+1;
	     loop_cnt >= 0;
	     --loop_cnt) {
		if (!inx)
			return 0;
		--inx;
		/* if necessary, expand the mapped window into the file */
		if (inx >= wf->wtbl_entries) {
			if (inx >= wf->wtbl->hdr.entries) {
				dcc_pemsg(EX_DATAERR, emsg,
					  "bogus index %u in %s",
					  inx, wf->ht_nm.c);
				if (!(wf->wf_flags & WF_RO))
					wf->wtbl->hdr.ascii_mtime = 0;
				sync_white(wf);
				return FIND_WHITE_BROKEN;
			}
			if (!map_white_ht(emsg, wf, wf->wtbl->hdr.entries))
				return 0;
		}
		e = &wf->wtbl->tbl[inx];
		if (e->type == type
		    && !memcmp(e->sum.b, sum->b, sizeof(e->sum)))
			return e;
		inx = e->fwd;
	}

	dcc_pemsg(EX_DATAERR, emsg, "chain length %d in %s"
		  " starting at %d near %d for %s %s",
		  wf->wtbl->hdr.entries+1,
		  wf->ht_nm.c,
		  (WHITE_INX)(accum % DIM(wf->wtbl->bins)), inx,
		  type2str_err(type, 0, 0, 0),
		  ck2str_err(type, sum, 0));

	if (!(wf->wf_flags & WF_RO))
		wf->wtbl->hdr.ascii_mtime = 0;
	sync_white(wf);
	return FIND_WHITE_BROKEN;
}



static int				/* 1=quit stat_white_nms() */
stat_1white_nm(int *resultp,		/* set=1 if (supposedly) no change */
	       WF *wf, const char *nm, time_t ascii_mtime)
{
	struct stat sb;
	time_t now;

	if (stat(nm, &sb) < 0) {
		if (errno != ENOENT
		    || !wf->wtbl
		    || (wf->wf_flags & WF_RO)) {
			dcc_trace_msg("stat(%s): %s", nm, ERROR_STR());
			is_broken(wf);
			*resultp = 0;
			return 1;
		}

		/* only complain if an ASCII file disappears temporarily */
		if (wf->broken == 0) {
			dcc_trace_msg("%s disappeared: %s", nm, ERROR_STR());
			is_broken(wf);
			*resultp = 1;
			return 1;
		}
		now = time(0);
		if (STILL_BROKE(wf, now)) {
			if (dcc_clnt_debug > 1)
				dcc_trace_msg("ignoring stat(%s): %s",
					      nm, ERROR_STR());
			*resultp = 1;
		} else {
			if (dcc_clnt_debug > 1)
				dcc_trace_msg("pay attention to stat(%s): %s",
					      nm, ERROR_STR());
			*resultp = 0;
		}
		return 1;
	}

	if (sb.st_mtime != ascii_mtime) {
		*resultp = 0;
		return 1;
	}

	return 0;
}



/* see if the ASCII files have changed */
static int				/* 1=same 0=changed or sick -1=broken */
stat_white_nms(DCC_EMSG *emsg, WF *wf)
{
	struct stat ht_sb;
	time_t now;
	int i, result;

	if (!wf->wtbl)
		return -1;

	now = time(0);
	wf->next_stat_time = now + WHITE_STAT_DELAY;

	/* Notice if the hash file has been unlinked */
	if (stat(wf->ht_nm.c, &ht_sb) < 0) {
		if (emsg && dcc_clnt_debug)
			dcc_error_msg("stat(%s): %s",
				      wf->ht_nm.c, ERROR_STR());
		return -1;
	}
#ifdef DCC_WIN32
	/* open files cannot be unlinked in WIN32, which lets us not
	 * worry about whether WIN32 files have device and i-numbers */
#else
	if (wf->ht_sb.st_dev != ht_sb.st_dev
	    || wf->ht_sb.st_ino != ht_sb.st_ino) {
		if (emsg && dcc_clnt_debug > 2)
			dcc_error_msg("%s disappeared", wf->ht_nm.c);
		return -1;
	}
#endif /* DCC_WIN32 */
	wf->ht_sb = ht_sb;

	/* delays on re-parsing and complaining in the file override */
	if (wf->reparse < wf->wtbl->hdr.reparse)
		wf->reparse = wf->wtbl->hdr.reparse;
	if (wf->broken < wf->wtbl->hdr.broken)
		wf->broken = wf->wtbl->hdr.broken;

	/* seriously broken hash tables are unusable */
	if (wf->wtbl->hdr.ascii_mtime == 0)
		return -1;

	/* pretend things are fine if they are recently badly broken */
	if (STILL_BROKE(wf, now))
		return 1;

	/* if the main ASCII file has disappeared,
	 * leave the hash file open and just complain,
	 * but only for a while */
	result = 1;
	if (stat_1white_nm(&result, wf, wf->ascii_nm.c,
			   wf->wtbl->hdr.ascii_mtime))
		return result;
	/* see if any of the included ASCII files are new */
	for (i = 0; i < DIM(wf->wtbl->hdr.white_incs); ++i) {
		if (wf->wtbl->hdr.white_incs[i].nm.c[0] == '\0')
			break;
		/* stop at the first missing or changed included file */
		if (stat_1white_nm(&result, wf,
				   wf->wtbl->hdr.white_incs[i].nm.c,
				   wf->wtbl->hdr.white_incs[i].mtime))
			return result;
	}

	/* force periodic reparsing of syntax errors to nag in system log */
	if (wf->reparse != 0
	    && DCC_IS_TIME(now, wf->reparse, WHITE_REPARSE_DELAY))
		return 0;

	if ((wf->wtbl_fgs & WHITE_FG_PER_USER)
	    && !(wf->wf_flags & WF_PER_USER)) {
		dcc_error_msg("%s is a per-user whitelist"
			      " used as a global whitelist",
			      wf->ht_nm.c);
		return 0;
	}
	if (!(wf->wtbl_fgs & WHITE_FG_PER_USER)
	    && (wf->wf_flags & WF_PER_USER)) {
		dcc_error_msg("%s is a global whitelist"
			      " used as a per-user whitelist",
			      wf->ht_nm.c);
		return 0;
	}

	/* Checksums of SMTP client IP addresses are compared against the
	 * checksums of the IP addresses of the host names in the ASCII file.
	 * Occassionaly check for changes in DNS A RR's for entries in
	 * the ASCII file, but only if there are host names or IP
	 * addresses in the file */
	if ((wf->wtbl->hdr.fgs & WHITE_FG_HOSTNAMES)
	    && DCC_IS_TIME(now, wf->ht_sb.st_mtime+DCC_WHITECLNT_RESOLVE,
			   DCC_WHITECLNT_RESOLVE)) {
		if (dcc_clnt_debug > 2)
			dcc_trace_msg("time to rebuild %s", wf->ht_nm.c);
		return 0;
	}

	return 1;
}



static u_char
write_white(DCC_EMSG *emsg, WF *wf, const void *buf, int buf_len, off_t pos)
{
	int i;

	if (wf->wtbl) {
#ifdef DCC_WIN32
		/* Windows disclaims coherence between ordinary writes
		 * and memory mapped writing.  The hash tables are
		 * fixed size on Windows because of problems with WIN32
		 * mapping objects, so we do not need to worry about
		 * extending the hash table file. */
		memcpy((char *)wf->wtbl+pos, buf, buf_len);
		return 1;
#else
		/* some UNIX systems have coherence trouble without msync() */
		if (0 > MSYNC(wf->wtbl, wf->wtbl_size, MS_SYNC)) {
			dcc_pemsg(EX_IOERR, emsg, "msync(%s): %s",
				  wf->ht_nm.c, ERROR_STR());
			return 0;
		}
#endif
	}

	i = lseek(wf->ht_fd, pos, SEEK_SET);
	if (i < 0) {
		dcc_pemsg(EX_IOERR, emsg, "lseek(%s,"OFF_DPAT"): %s",
			  wf->ht_nm.c, pos, ERROR_STR());
		return 0;
	}
	i = write(wf->ht_fd, buf, buf_len);
	if (i != buf_len) {
		if (i < 0)
			dcc_pemsg(EX_IOERR, emsg, "write(%s,%d): %s",
				  wf->ht_nm.c, buf_len, ERROR_STR());
		else
			dcc_pemsg(EX_IOERR, emsg, "write(%s,%d): %d",
				  wf->ht_nm.c, buf_len, i);
		return 0;
	}
	return 1;
}



/* add a checksum to a whiteclnt hash table */
static int				/* 1=ok,  0=bad entry, -1=fatal */
add_white(DCC_EMSG *emsg, WF *wf,
	  DCC_CK_TYPES type, DCC_SUM *sum, DCC_TGTS tgts)
{
	WHITE_ENTRY *e, new;
	WHITE_INX bin;
	DCC_FNM_LNO_BUF fnm_buf;
	off_t end;

	/* find the hash chain for the new entry */
	e = find_white(emsg, wf, type, sum, &bin);
	if (e == FIND_WHITE_BROKEN)
		return -1;

	/* ignore duplicates on this, the first pass */
	if (e)
		return 1;

	memset(&new, 0, sizeof(new));
	new.type = type;
	new.sum = *sum;
	new.tgts = tgts;
	new.fwd = wf->wtbl->bins[bin];
	new.lno = wf->lno;
	new.fno = wf->fno;

	/* Use a new entry at the end of the file
	 * It will be beyond the memory mapped window into the file */
	if (wf->wtbl->hdr.entries >= MAX_WHITE_ENTRIES) {
		dcc_pemsg(EX_DATAERR, emsg, "more than maximum %d entries%s",
			  wf->wtbl->hdr.entries, wf_fnm_lno(&fnm_buf, wf));
		return 0;
	}
	end = ENTRIES2SIZE(wf->wtbl->hdr.entries);
	wf->wtbl->bins[bin] = ++wf->wtbl->hdr.entries;
	return write_white(emsg, wf, &new, sizeof(new), end) ? 1 : -1;
}



/* add a block of IP address checksums to a whiteclnt hash table */
#define MIN_IP_RANGE_SIZE   (1<<8)	/* fix dcc.man if this changes */
static int				/* 1=ok,  0=bad entry, -1=fatal */
add_white_ip_range(DCC_EMSG *emsg, WF *wf,
		   const DCC_IP_RANGE *range, DCC_TGTS tgts)
{
	WHITE_IP_RANGE *r;
	DCC_FNM_LNO_BUF fnm_buf;
	u_int n, range_len;
	struct in6_addr addr;
	DCC_SUM sum;
	int result, j;

	/* use individual entries for smaller than MIN_IP_RANGE_SIZE blocks */
	range_len = len_ip_range(range);
	if (range_len < MIN_IP_RANGE_SIZE) {
		addr = range->lo;
		result = 1;
		for (n = 0; n < range_len; ++n) {
			ipv6tock(&sum, &addr);
			j = add_white(emsg, wf, DCC_CK_IP, &sum, tgts);
			if (j <= 0) {
				if (j < 0)
					return j;
				result = j;
			}
			inc_ip6(&addr);
		}
		return result;
	}

	n = wf->wtbl->hdr.ranges.len;
	for (r = wf->wtbl->hdr.ranges.rs; n > 0; ++r, --n) {
		/* ignore collisions on this, the first pass */
		if (!memcmp(&r->range, range, sizeof(r->range)))
			return 1;
	}

	if (wf->wtbl->hdr.ranges.len >= DIM(wf->wtbl->hdr.ranges.rs)) {
		dcc_pemsg(EX_DATAERR, emsg, "too many IP address blocks%s",
			  wf_fnm_lno(&fnm_buf, wf));
		return 0;
	}

	r->range = *range;
	r->len = range_len;
	r->tgts = tgts;
	r->lno = wf->lno;
	r->fno = wf->fno;
	++wf->wtbl->hdr.ranges.len;

	return 1;
}



static void
dup_msg(DCC_EMSG *emsg, WF *wf, int e_fno, int e_lno,
	DCC_TGTS e_tgts, DCC_TGTS tgts)
{
	char tgts_buf[30], e_tgts_buf[30];
	const char *fname1, *fname2;

	fname1 = wf_fnm(wf, wf->fno);
	fname2 = wf_fnm(wf, e_fno);
	dcc_pemsg(EX_DATAERR, emsg,
		  "\"%s\" in line %d%s%s conflicts with \"%s\" in line"
		  " %d of %s",
		  tgts2str(tgts_buf, sizeof(tgts_buf), tgts, 0),
		  wf->lno,
		  fname1 != fname2 ? " of " : "",
		  fname1 != fname2 ? fname1 : "",
		  tgts2str(e_tgts_buf, sizeof(e_tgts_buf), e_tgts, 0),
		  e_lno,
		  fname2);
}



static DCC_TGTS
combine_white_tgts(DCC_TGTS new, DCC_TGTS old)
{
	if (new < DCC_TGTS_TOO_MANY && old == DCC_TGTS_TOO_MANY)
		return new;

	if (new == DCC_TGTS_OK || old == DCC_TGTS_OK)
		return DCC_TGTS_OK;
	if (new == DCC_TGTS_OK2 || old == DCC_TGTS_OK2)
		return DCC_TGTS_OK2;
	if (new == DCC_TGTS_OK_MX || old == DCC_TGTS_OK_MX)
		return DCC_TGTS_OK_MX;
	if (new == DCC_TGTS_OK_MXDCC || old == DCC_TGTS_OK_MXDCC)
		return DCC_TGTS_OK_MXDCC;
	if (new == DCC_TGTS_TOO_MANY || old == DCC_TGTS_TOO_MANY)
		return DCC_TGTS_TOO_MANY;
	if (new == DCC_TGTS_SUBMIT_CLIENT || old == DCC_TGTS_SUBMIT_CLIENT)
		return DCC_TGTS_SUBMIT_CLIENT;

	return new;
}



static int			/* 1=ok,  0=bad entry, -1=fatal */
ck_dup_white(DCC_EMSG *emsg, WF *wf,
	     DCC_CK_TYPES type, DCC_SUM *sum, DCC_TGTS tgts, u_char complain)
{
	WHITE_ENTRY *e;
	DCC_FNM_LNO_BUF buf;
	const char *from;

	/* find the hash table entry */
	e = find_white(emsg, wf, type, sum, 0);
	if (e == FIND_WHITE_BROKEN)
		return -1;
	if (!e) {
		/* We failed to find the hash table entry.  Either the
		 * hash file is corrupt, the ASCII file is changing beneath
		 * our feet, or a host name that failed to resolve the first
		 * time we parsed the ASCII file is now resolving during
		 * this second parsing. */
		from = wf_fnm_lno(&buf, wf);
		if (type == DCC_CK_IP) {
			if (dcc_clnt_debug > 2)
				dcc_trace_msg("%s entry (dis)appeared in %s%s",
					      type2str_err(type, 0, 0, 0),
					      wf->ht_nm.c,
					      *from == '\0' ? "in ?" : from);
			return 0;
		}
		dcc_pemsg(EX_DATAERR, emsg, "%s entry (dis)appeared in %s%s",
			  type2str_err(type, 0, 0, 0),
			  wf->ht_nm.c,
			  *from == '\0' ? "in ?" : from);
		return -1;
	}

	/* ignore perfect duplicates */
	if (e->tgts == tgts)
		return 1;

	if (complain)
		dup_msg(emsg, wf, e->fno, e->lno, e->tgts, tgts);

	if (e->tgts != combine_white_tgts(tgts, e->tgts)) {
		e->tgts = tgts;
		e->lno = wf->lno;
		e->fno = wf->fno;
	}
	return 0;
}



static int			/* 1=ok,  0=bad entry, -1=fatal */
ck_dup_white_complain(DCC_EMSG *emsg, WF *wf,
	     DCC_CK_TYPES type, DCC_SUM *sum, DCC_TGTS tgts)
{
	return ck_dup_white(emsg, wf, type, sum, tgts, 1);
}



/* Without brute force checks that would take too long, it is impossible to
 * check that a new IP address block does not collide with individual entries
 * that are already in the hash table.  Without expanding a big block into
 * IP addresses and looking for each in the hash table, how can you check
 * whether it covers an entry for an individual address?  One way is to
 * parse the file twice and so check each individual IP address against
 * the blocks. */
static int				/* 1=ok,  0=bad entry, -1=fatal */
ck_dup_white_ip_range(DCC_EMSG *emsg DCC_UNUSED, WF *wf,
		      const DCC_IP_RANGE *range, DCC_TGTS tgts)
{
	WHITE_IP_RANGE *r;
	u_int range_len;
	struct in6_addr addr;
	DCC_SUM sum;
	int result, i, j;

	result = 1;

	/* Check for collisions between address blocks and other
	 * address blocks or individual addresses.  Individual addresses
	 * are sent here as /128 blocks. */
	i = wf->wtbl->hdr.ranges.len;
	for (r = wf->wtbl->hdr.ranges.rs; i > 0; ++r, --i) {
		if (!in_range(&range->lo, &r->range)
		    && !in_range(&range->hi, &r->range))
			continue;

		/* ignore simple duplicates */
		if (r->tgts == tgts)
			continue;

		dup_msg(emsg, wf, r->fno, r->lno, r->tgts, tgts);
		result = 0;

		/* fix direct collisions */
		if (!memcmp(&r->range, range, sizeof(r->range))
		    && r->tgts != combine_white_tgts(tgts, r->tgts)) {
			r->tgts = tgts;
			r->lno = wf->lno;
			r->fno = wf->fno;
		}
	}

	/* check and fix collisions among individual entries */
	range_len = len_ip_range(range);
	if (range_len < MIN_IP_RANGE_SIZE) {
		addr = range->lo;
		while (range_len-- != 0) {
			ipv6tock(&sum, &addr);
			j = ck_dup_white(emsg, wf, DCC_CK_IP, &sum, tgts,
					 result > 0);
			if (j < 0)
				return j;
			if (j == 0)
				result = j;
			inc_ip6(&addr);
		}
	}

	return result;
}


/* bail out on creating a whiteclnt hash table file */
static WHITE_RESULT
make_white_hash_bail(WHITE_RESULT result, WF *wf, WF *tmp_wf)
{
	if (tmp_wf->ht_nm.c[0] != '\0') {
		unlink_white_ht(0, tmp_wf, 0);
		tmp_wf->ht_nm.c[0] = '\0';
	}

	/* we have a usable file open */
	if (wf->wtbl)
		return WHITE_CONTINUE;
	return result;
}



/* (re)create the hash table file */
static WHITE_RESULT
make_white_hash(DCC_EMSG *emsg, WF *wf, WF *tmp_wf)
{
	static const u_char zero = 0;
	int ascii_fd;
	struct stat ascii_sb;
	DCC_PATH path;
	WHITE_RESULT result;
	DCC_CK_TYPES type;
	int part_result, i;

	if (dcc_clnt_debug > 2)
		dcc_trace_msg("start parsing %s", wf->ascii_nm.c);

	/* Do not wait to create a new, locked hash table file if we have
	 *	a usable file.  Assume some other process is re-parsing
	 *	the ASCII file.
	 * If we should wait to create a new file, then we don't have a
	 *	usable hash table and so there is no reason to unlock the
	 *	WF structure. */

#ifdef DCC_DEBUG_LOCKS
	if (tmp_wf == &cmn_tmp_wf)
		assert_cwf_locked();
#endif

	wf_init(tmp_wf, wf->wf_flags);

	if (0 > stat(wf->ascii_nm.c, &ascii_sb)) {
		result = ((errno == ENOENT || errno == ENOTDIR)
			  ? WHITE_NOFILE
			  : WHITE_COMPLAIN);

		dcc_pemsg(EX_IOERR, emsg, "stat(%s): %s",
			  wf->ascii_nm.c, ERROR_STR());

		/* Delete the hash table if the ASCII file has disappeared.
		 * stat_white_nms() delays forcing a re-build if the ASCII
		 * file disappears only temporarily */
		if (wf->ht_nm.c[0] != '\0') {
			close_white_ht(0, wf);
			i = unlink(wf->ht_nm.c);
			if (i < 0) {
				if (errno != ENOENT && errno != ENOTDIR)
					dcc_trace_msg("%s missing,:unlink(%s):"
						      " %s",
						      wf->ascii_nm.c,
						      dcc_fnm2abs_msg(&path,
							  wf->ht_nm.c),
						      ERROR_STR());
			} else if (dcc_clnt_debug > 1) {
				dcc_trace_msg("delete %s after %s missing",
					      dcc_fnm2abs_msg(&path,
							wf->ht_nm.c),
					      wf->ascii_nm.c);
			}
		}
		return make_white_hash_bail(result, wf, tmp_wf);
	}

	part_result = create_white_ht(emsg, tmp_wf, wf);
	if (part_result == 0) {
		/* The new hash table file is busy.
		 * Do not complain if we have a usable open hash table file */
		if (!dcc_clnt_debug && wf->wtbl)
			return WHITE_OK;
		/* at least ignore the need to reparse */
		return WHITE_CONTINUE;
	}
	if (part_result < 0)
		return make_white_hash_bail(WHITE_COMPLAIN, wf, tmp_wf);

	/* clear the new hash table */
	if (!write_white(emsg, tmp_wf, white_magic, sizeof(white_magic), 0)
	    || !write_white(emsg, tmp_wf, &zero, 1, EMPTY_WHITE_SIZE-1)
	    || !map_white_ht(emsg, tmp_wf, 0))
		return make_white_hash_bail(WHITE_COMPLAIN, wf, tmp_wf);
	if (tmp_wf->wf_flags & WF_PER_USER)
		tmp_wf->wtbl->hdr.fgs = WHITE_FG_PER_USER;
	tmp_wf->wtbl_fgs = tmp_wf->wtbl->hdr.fgs;
	tmp_wf->wtbl_sws = tmp_wf->wtbl->hdr.sws;
	for (type = 0; type <= DCC_CK_TYPE_LAST; ++type)
		tmp_wf->wtbl->hdr.tholds_rej.t[type] = THOLD_UNSET;

	ascii_fd = dcc_lock_open(emsg, tmp_wf->ascii_nm.c, O_RDONLY,
				 DCC_LOCK_OPEN_NOWAIT | DCC_LOCK_OPEN_SHARE,
				 DCC_LOCK_ALL_FILE, 0);
	if (ascii_fd == -1)
		return make_white_hash_bail(WHITE_COMPLAIN, wf, tmp_wf);

	tmp_wf->wtbl->hdr.ascii_mtime = ascii_sb.st_mtime;
	part_result = parse_whitefile(emsg, tmp_wf, ascii_fd,
				      add_white, add_white_ip_range);
	if (part_result > 0) {
		/* parse again to detect colliding definitions among
		 * host names and IP address blocks */
		if (0 != lseek(ascii_fd, 0, SEEK_SET)) {
			dcc_pemsg(EX_IOERR, emsg, "lseek(%s, 0, SEEK_SET): %s",
				  wf->ascii_nm.c, ERROR_STR());
			part_result = -1;
		} else {
			part_result = parse_whitefile(emsg, tmp_wf, ascii_fd,
						      ck_dup_white_complain,
						      ck_dup_white_ip_range);
		}
	}

	/* if the hash table is tolerable, compute a checksum of it
	 * to detect differing per-user hash tables */
	if (part_result >= 0
	    && map_white_ht(emsg, tmp_wf, tmp_wf->wtbl->hdr.entries)) {
		MD5_CTX ctx;

		MD5Init(&ctx);
		MD5Update(&ctx, (u_char *)&tmp_wf->wtbl->hdr.ranges,
			  sizeof(tmp_wf->wtbl->hdr.ranges));
		i = tmp_wf->wtbl->hdr.entries;
		while (--i >= 0) {
			MD5Update(&ctx, &tmp_wf->wtbl->tbl[i].type,
				  sizeof(tmp_wf->wtbl->tbl[i].type));
			MD5Update(&ctx, tmp_wf->wtbl->tbl[i].sum.b,
				  sizeof(tmp_wf->wtbl->tbl[i].sum.b));
		}
		MD5Final(tmp_wf->wtbl->hdr.ck_sum.b, &ctx);
	}
#ifdef DCC_WIN32
	/* unlock the file before closing it to keep Win95 happy */
	dcc_unlock_fd(0, ascii_fd, DCC_LOCK_ALL_FILE,
		      "whitelist ", tmp_wf->ascii_nm.c);
#endif
	if (close(ascii_fd) < 0)
		dcc_trace_msg("close(%s): %s", wf->ascii_nm.c, ERROR_STR());
	if (part_result < 0)
		return make_white_hash_bail(WHITE_COMPLAIN, wf, tmp_wf);
	result = (part_result > 0) ? WHITE_OK : WHITE_CONTINUE;

	/* ensure continued complaints about errors */
	if (result == WHITE_CONTINUE)
		tmp_wf->wtbl->hdr.reparse = time(0) + WHITE_REPARSE_DELAY;
	sync_white(tmp_wf);

#ifdef DCC_WIN32
	/* WIN32 prohibits renaming open files
	 * and there is little or no concurrency on WIN32 DCC clients
	 * So lock the original file and copy to it. */
	close_white_ht(0, wf);
	wf->ht_fd = dcc_lock_open(emsg, wf->ht_nm.c, O_RDWR | O_CREAT,
				  0, DCC_LOCK_ALL_FILE, 0);
	if (wf->ht_fd < 0)
		return make_white_hash_bail(WHITE_COMPLAIN, wf, tmp_wf);
	if (!map_white_ht(emsg, wf, tmp_wf->wtbl_entries))
		return make_white_hash_bail(WHITE_COMPLAIN, wf, tmp_wf);
	memcpy(wf->wtbl, tmp_wf->wtbl, tmp_wf->wtbl_size);
	close_white_ht(emsg, tmp_wf);
	unlink(tmp_wf->ht_nm.c);
#else
	part_result = rename(tmp_wf->ht_nm.c, wf->ht_nm.c);
	if (0 > part_result
	    && dcc_get_priv_home(wf->ht_nm.c)) {
		part_result = rename(tmp_wf->ht_nm.c, wf->ht_nm.c);
		dcc_rel_priv();
	}
	if (0 > part_result) {
		dcc_pemsg(EX_IOERR, emsg, "rename(%s, %s): %s",
			  tmp_wf->ht_nm.c, wf->ht_nm.c, ERROR_STR());
		return make_white_hash_bail(WHITE_COMPLAIN, wf, tmp_wf);
	}
#endif

	close_white_ht(0, tmp_wf);
	if (dcc_clnt_debug > 1)
		dcc_trace_msg("finished parsing %s", wf->ascii_nm.c);
	part_result = open_white_ht(emsg, wf);
	if (part_result < 0)
		result = WHITE_COMPLAIN;
	else if (part_result == 0 && result == WHITE_OK)
		result = WHITE_CONTINUE;

	wf->next_stat_time = time(0) + WHITE_STAT_DELAY;

	return result;
}



/* see that a local whitelist is ready
 *	on failure the file is not locked
 *	The caller must lock the WF if necessary */
WHITE_RESULT
wf_rdy(DCC_EMSG *emsg, WF *wf, WF *tmp_wf)
{
	time_t now;
	int i;

	if (wf->need_reopen) {
		/* The resolver thread has change the hash table in the file
		 * and possibly renamed it.
		 * We need to re-open the hash table */
		wf->broken = 0;
		wf->reparse = 0;
		close_white_ht(0, wf);
	}

	now = time(0);
	if (emsg)
		emsg->c[0] = '\0';

	if (wf->ht_fd >= 0) {
		/* The hash table is open.
		 * If we have checked recently, assume everything is good. */
		if (!DCC_IS_TIME(now, wf->next_stat_time, WHITE_STAT_DELAY))
			return WHITE_OK;
		i = stat_white_nms(emsg, wf);
		if (i > 0)
			return WHITE_OK;
		if (i < 0) {
			/* Things are broken or not open, so try to open the
			 * hash table.
			 * We may be racing here.  Be happy if another process
			 * fixes the hash table while we stall trying to open
			 * it locked. */
			i = open_white_ht(emsg, wf);
			if (i < 0)
				return WHITE_COMPLAIN;
			if (i > 0)
				i = stat_white_nms(emsg, wf);
		}

	} else {
		if (wf->ascii_nm.c[0] == '\0') {
			dcc_pemsg(EX_NOINPUT, emsg, "no whitelist");
			return WHITE_NOFILE;
		}

		if (STILL_BROKE(wf, now)) {
			/* only check for a missing file occassionally */
			if (wf->wf_flags & WF_NOFILE) {
				dcc_pemsg(EX_NOINPUT, emsg, "%s does not exist",
					  wf->ascii_nm.c);
				return WHITE_NOFILE;
			}

			/* If things are broken, and it has not been a while,
			 * then assume things are still broken. */
			dcc_pemsg(EX_DATAERR, emsg,
				  "%s still broken", wf->ascii_nm.c);
			return (dcc_clnt_debug > 2
				? WHITE_COMPLAIN
				: WHITE_SILENT);
		}

		i = open_white_ht(emsg, wf);
		if (i < 0)
			return WHITE_COMPLAIN;
		if (i > 0)
			i = stat_white_nms(emsg, wf);
	}

	if (i > 0)
		return WHITE_OK;

	/* Try to let the resolver thread wait for the DNS chitchat
	 * for host names that might now be in the ASCII file.
	 * To avoid racing with the resolver thread to delete the main
	 * hash files, fail if there is no hash table and this is not
	 * the resolver thread. */
	if (i == 0
	    && !(wf->wf_flags & WF_PER_USER)
	    && dcc_clnt_wake_resolve()) {
		if (wf->wtbl)
			return WHITE_OK;
		return (dcc_clnt_debug > 2
			? WHITE_COMPLAIN : WHITE_SILENT);
	}

	if (STILL_BROKE(wf, now)) {
		dcc_pemsg(EX_DATAERR, emsg, "%s still broken", wf->ascii_nm.c);
		if (i == 0 && wf->wtbl)
			return (dcc_clnt_debug > 2
				? WHITE_CONTINUE : WHITE_SILENT);
		return (dcc_clnt_debug > 2
			? WHITE_COMPLAIN : WHITE_SILENT);
	}

	if (emsg && emsg->c[0] != '\0') {
		if (i < 0) {
			dcc_error_msg("%s", emsg->c);
		} else if (dcc_clnt_debug > 2) {
			dcc_trace_msg("%s", emsg->c);
		}
		emsg->c[0] = '\0';
	}

	switch (make_white_hash(emsg, wf, tmp_wf)) {
	case WHITE_OK:
		wf->wf_flags &= ~WF_NOFILE;
		return WHITE_OK;	/* all is good */
	case WHITE_CONTINUE:		/* minor syntax error or bad host name */
		wf->wf_flags &= ~WF_NOFILE;
		return WHITE_CONTINUE;
	case WHITE_SILENT:		/* no new message */
		wf->wf_flags &= ~WF_NOFILE;
		return WHITE_CONTINUE;
	case WHITE_NOFILE:
		wf->wf_flags |= WF_NOFILE;
		return WHITE_NOFILE;
	case WHITE_COMPLAIN:
	default:
		is_broken(wf);
		wf->wf_flags &= ~WF_NOFILE;
		return WHITE_COMPLAIN;
	}
}



static u_char
lookup_white(DCC_EMSG *emsg,
	     DCC_TGTS *tgtsp,		/* value if hit else DCC_TGTS_INVALID */
	     WF *wf,
	     const GOT_CKS *cks, const GOT_SUM *g)
{
	const WHITE_ENTRY *e;
	WHITE_IP_RANGE *r;
	u_int r_len;

	e = find_white(emsg, wf, g->type, &g->sum, 0);
	if (e == FIND_WHITE_BROKEN) {
		*tgtsp = DCC_TGTS_OK;
		return 0;
	}

	if (!e) {
		if (g->type != DCC_CK_IP) {
			*tgtsp = DCC_TGTS_INVALID;
			return 1;
		}

		/* check the IP address ranges
		 * if we had no hit and it is an IP address */
		r_len = 0;
		r = &wf->wtbl->hdr.ranges.rs[wf->wtbl->hdr.ranges.len];
		while (r != wf->wtbl->hdr.ranges.rs) {
			--r;
			/* look for the first longest match */
			if (r->len <= r_len)
				continue;
			if (in_range(&cks->ip_addr, &r->range)) {
				*tgtsp = r->tgts;
				r_len = r->len;
			}
		}
		if (r_len == 0)
			*tgtsp = DCC_TGTS_INVALID;
		return 1;
	}

	*tgtsp = e->tgts;
	return 1;
}



/* check a local whitelist for a single checksum
 *	on exit the file is locked except after an error */
WHITE_RESULT
wf_sum(DCC_EMSG *emsg,
       WF *wf,				/* in this whitelist */
       DCC_CK_TYPES type,		/* look for this checksum */
       const DCC_SUM *sum,
       DCC_TGTS *tgtsp,			/* set only if we find the checksum */
       WHITE_LISTING *listingp)
{
	WHITE_ENTRY *e;
	WHITE_RESULT result;

	result = wf_rdy(emsg, wf, &cmn_tmp_wf);
	switch (result) {
	case WHITE_OK:
	case WHITE_CONTINUE:
		break;
	case WHITE_SILENT:
	case WHITE_NOFILE:
	case WHITE_COMPLAIN:
		*listingp = WHITE_RESULT_FAILURE;
		return result;
	}

	e = find_white(emsg, wf, type, sum, 0);
	if (e == FIND_WHITE_BROKEN) {
		*listingp = WHITE_RESULT_FAILURE;
		return WHITE_COMPLAIN;
	}

	if (!e) {
		*listingp = WHITE_UNLISTED;
	} else if (e->tgts == DCC_TGTS_OK2
		   && type == DCC_CK_ENV_TO) {
		/* deprecated mechanism for turn DCC checks on and off for
		 * individual targets */
		*tgtsp = e->tgts;
		*listingp = WHITE_USE_DCC;
	} else if (e->tgts == DCC_TGTS_OK) {
		*tgtsp = e->tgts;
		*listingp = WHITE_LISTED;
	} else if (e->tgts == DCC_TGTS_TOO_MANY) {
		*tgtsp = e->tgts;
		*listingp = WHITE_BLACK;
	} else {
		*listingp = WHITE_UNLISTED;
	}

	return result;
}



/* see if an IP addess is that of one of our MX servers
 *	the caller must lock cmn_wf if necessray */
u_char					/* 0=problems */
white_mx(DCC_EMSG *emsg,
	     DCC_TGTS *tgtsp,		/* !=0 if listed */
	     const GOT_CKS *cks)	/* this IP address checksum */
{
	u_char result;

	result = 1;
	switch (wf_rdy(emsg, &cmn_wf, &cmn_tmp_wf)) {
	case WHITE_OK:
		break;
	case WHITE_CONTINUE:
		result = 0;
		break;
	case WHITE_NOFILE:
		*tgtsp = 0;
		return 1;
	case WHITE_SILENT:
	case WHITE_COMPLAIN:
		*tgtsp = 0;
		return 0;
	}

	if (cks->sums[DCC_CK_IP].type != DCC_CK_IP) {
		*tgtsp = 0;
		return result;
	}

	if (!lookup_white(emsg, tgtsp, &cmn_wf, cks, &cks->sums[DCC_CK_IP]))
		return 0;

	return result;
}



/* See what a local whitelist file says about the checksums for a message.
 *	The message is whitelisted if at least one checksum is in the local
 *	whitelist or if there are two or more OK2 values.
 *	Otherwise it is blacklisted if at least one checksum is.
 *	The caller must lock the WF if necessary. */
WHITE_RESULT				/* whether the lookup worked */
wf_cks(DCC_EMSG *emsg, WF *wf,
       GOT_CKS *cks,			/* these checksums */
       CKS_WTGTS *wtgts,		/* whitelist targets, each cks->sums */
       WHITE_LISTING *listingp)		/* the answer found */
{
	const GOT_SUM *g;
	int inx;
	DCC_TGTS tgts, prev_tgts;
	WHITE_RESULT result;

	result = wf_rdy(emsg, wf, &cmn_tmp_wf);
	switch (result) {
	case WHITE_OK:
	case WHITE_CONTINUE:
		break;
	case WHITE_NOFILE:
	case WHITE_COMPLAIN:
	case WHITE_SILENT:
		*listingp = WHITE_RESULT_FAILURE;
		return result;
	}

	/* look for each checksum in the hash file */
	*listingp = WHITE_UNLISTED;
	prev_tgts = DCC_TGTS_INVALID;
	tgts = DCC_TGTS_INVALID;
	for (g = &cks->sums[inx = DCC_CK_TYPE_FIRST];
	     g <= LAST(cks->sums);
	     ++g, ++inx) {
		/* ignore checksums we don't have */
		if (g->type == DCC_CK_INVALID)
			continue;

		if (!lookup_white(emsg, &tgts, wf, cks, g)) {
			*listingp = WHITE_RESULT_FAILURE;
			return WHITE_COMPLAIN;
		}
		if (tgts == DCC_TGTS_INVALID) {
			/* report any body checksums as spam for a spam trap */
			if ((wf->wtbl_sws & WHITE_SW_TRAPS)
			    && DCC_CK_IS_BODY(g->type))
				tgts = DCC_TGTS_TOO_MANY;
			else
				continue;
		}

		if (wtgts)
			wtgts->v[inx] = tgts;

		if (tgts == DCC_TGTS_OK
		    || tgts == DCC_TGTS_OK_MX
		    || tgts == DCC_TGTS_OK_MXDCC) {
			/* We found the checksum in our whitelist,
			 * so we have the answer.  Mail from an MX relay
			 * itself is assumed good. */
			*listingp = WHITE_LISTED;

		} else if (tgts == DCC_TGTS_OK2) {
			if (prev_tgts == DCC_TGTS_OK2) {
				/* two half-white checksums count the same
				 * as a single pure white checksum
				 * and gives the answer */
				*listingp = WHITE_LISTED;
				continue;
			}
			prev_tgts = DCC_TGTS_OK2;

		} else if (tgts == DCC_TGTS_TOO_MANY) {
			if (*listingp == WHITE_UNLISTED)
				*listingp = WHITE_BLACK;
		}
	}

	return result;
}
