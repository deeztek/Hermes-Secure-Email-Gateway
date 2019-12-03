/* Distributed Checksum Clearinghouse
 *
 * open, create, and check DCC server output flood mapped file
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
 * Rhyolite Software DCC 2.3.167-1.67 $Revision$
 */

#include "srvr_defs.h"
#include "dcc_xhdr.h"

FLOD_MMAPS *flod_mmaps;
DCC_PATH flod_mmap_path;
DCC_PATH flod_path;

static int mmap_fd = -1;


void
flod_mmap_path_set(void)
{
	dcc_fnm2rel_good(&flod_mmap_path,
			 grey_on ? GREY_FLOD_NM : DCCD_FLOD_NM,
			 ".map");
	dcc_fnm2rel_good(&flod_path,
			 grey_on ? GREY_FLOD_NM : DCCD_FLOD_NM,
			 0);
}



u_char
flod_mmap_sync(DCC_EMSG *emsg, u_char touch)
{
	u_char result = 1;

	if (flod_mmap_path.c[0] == '\0')
		flod_mmap_path_set();

	if (flod_mmaps
	    && 0 > MSYNC(flod_mmaps, sizeof(*flod_mmaps), MS_SYNC)) {
		dcc_pemsg(EX_IOERR, emsg, "msync(%s): %s",
			  flod_mmap_path.c, ERROR_STR());
		result = 0;
		emsg = 0;
	}

	if (touch) {
		if (mmap_fd >= 0
		    && 0 > fsync(mmap_fd)) {
			dcc_pemsg(EX_IOERR, emsg, "fsync(%s): %s",
				  flod_mmap_path.c, ERROR_STR());
			result = 0;
			emsg = 0;
		}

		/* Ensure that the mtime changes at least occassionally.
		 * Several systems do not update the mtimes of files modified
		 * with mmap().  Some like BSD/OS delay changing the mtime until
		 * the file is accessed with read().  Others including
		 * filesystems on some versions of Linux apparently never change
		 * the mtime. */
		if (!dcc_set_mtime(emsg, flod_mmap_path.c, mmap_fd, 0)) {
			result = 0;
			emsg = 0;
		}
	}

	return result;
}



u_char					/* 1=no problems, 0=complaints */
flod_unmap(DCC_EMSG *emsg, const DCCD_STATS *dccd_stats)
{
	u_char result = 1;

	if (!flod_mmap_sync(emsg, 0)) {
		result = 0;
		emsg = 0;
	}

	if (flod_mmaps) {
		if (dccd_stats)
			memcpy(&flod_mmaps->dccd_stats, dccd_stats,
			       sizeof(flod_mmaps->dccd_stats));
		if (0 > munmap((void *)flod_mmaps, sizeof(*flod_mmaps))) {
			dcc_pemsg(EX_IOERR, emsg, "munmap(%s,%d): %s",
				  flod_mmap_path.c,
				  ISZ(*flod_mmaps), ERROR_STR());
			result = 0;
			emsg = 0;
		}
		flod_mmaps = 0;
	}

	if (mmap_fd >= 0) {
		if (close(mmap_fd) < 0) {
			dcc_pemsg(EX_IOERR, emsg, "close(%s): %s",
				  flod_mmap_path.c, ERROR_STR());
			result = 0;
			emsg = 0;
		}
		mmap_fd = -1;
	}

	return result;
}



static int				/* 1=success, 0=retry, -1=fatal */
flod_mmap_try(DCC_EMSG *emsg,
	      const DB_SN *sn,
	      u_char rw)		/* 0=rdonly/unlocked, 1=write/locked */
{
	int flags;
	struct stat sb;
	union {
	    FLOD_MMAPS	m;
	    u_char	b[1];
	} init;
	void *p;
	int i;

	if (flod_mmap_path.c[0] == '\0')
		flod_mmap_path_set();

	if (rw)
		mmap_fd = dcc_lock_open(emsg, flod_mmap_path.c, O_RDWR|O_CREAT,
					DCC_LOCK_OPEN_NOWAIT,
					DCC_LOCK_ALL_FILE, 0);
	else
		mmap_fd = dcc_lock_open(emsg, flod_mmap_path.c, O_RDONLY,
					DCC_LOCK_OPEN_NOLOCK, 0, 0);
	if (mmap_fd == -1)
		return (errno == EWOULDBLOCK) ? -1 : 0;

	if (fstat(mmap_fd, &sb) < 0) {
		dcc_pemsg(EX_IOERR, emsg, "stat(%s): %s",
			  flod_mmap_path.c, ERROR_STR());
		flod_unmap(0, 0);
		return 0;
	}
	if (0 > fcntl(mmap_fd, F_SETFD, FD_CLOEXEC)) {
		dcc_pemsg(EX_IOERR, emsg, "fcntl(%s, FD_CLOEXEC): %s",
			  flod_mmap_path.c, ERROR_STR());
		flod_unmap(0, 0);
		return 0;
	}

	if (sb.st_size == 0 && rw) {
		memset(&init, 0, sizeof(init));
		strcpy(init.m.magic, FLOD_MMAP_MAGIC);
		if (sn)
			init.m.sn = *sn;
		i = write(mmap_fd, &init, sizeof(init));
		if (i < 0) {
			dcc_pemsg(EX_IOERR, emsg, "write(%s, init): %s",
				  flod_mmap_path.c, ERROR_STR());
			flod_unmap(0, 0);
			return -1;
		}
		if (i != ISZ(init)) {
			dcc_pemsg(EX_IOERR, emsg,
				  "write(%s, init)=%d instead of %d",
				  flod_mmap_path.c, i, ISZ(init));
			flod_unmap(0, 0);
			return -1;
		}
	} else {
		i = read(mmap_fd, &init, sizeof(init));
		if (i < 0) {
			dcc_pemsg(EX_IOERR, emsg, "read(%s, init): %s",
				  flod_mmap_path.c, ERROR_STR());
			flod_unmap(0, 0);
			return -1;
		}
		if (i < ISZ(init)) {
			if (i < sb.st_size) {
				dcc_pemsg(EX_IOERR, emsg, "read(%s, init)=%d",
					  flod_mmap_path.c, i);
				flod_unmap(0, 0);
				return -1;
			}
		}
	}

	if (sb.st_size >= (off_t)sizeof(init.m.magic)
	    && strcmp(init.m.magic, FLOD_MMAP_MAGIC)) {
		dcc_pemsg(EX_IOERR, emsg, "wrong magic in %s;"
			  " \"%s\" instead of \""FLOD_MMAP_MAGIC"\"",
			  flod_mmap_path.c, esc_magic(init.m.magic,
						      sizeof(init.m.magic)));
		flod_unmap(0, 0);
		return 0;
	}

	flags = rw ? (PROT_READ|PROT_WRITE) : PROT_READ;
	p = mmap(0, sizeof(*flod_mmaps), flags, MAP_SHARED, mmap_fd, 0);
	if (p == MAP_FAILED) {
		dcc_pemsg(EX_IOERR, emsg, "mmap(%s): %s",
			  flod_mmap_path.c, ERROR_STR());
		flod_unmap(0, 0);
		return 0;
	}
	flod_mmaps = p;

	if (sb.st_size == 0) {
		dcc_pemsg(EX_IOERR, emsg, "%s (re)created", flod_mmap_path.c);
	} else if (sb.st_size != sizeof(FLOD_MMAPS)) {
		dcc_pemsg(EX_IOERR, emsg, "%s has size %d instead of %d",
			  flod_mmap_path.c, (int)sb.st_size, ISZ(FLOD_MMAPS));
		flod_unmap(0, 0);
		return 0;
	}

	if (sn
	    && memcmp(&flod_mmaps->sn, sn, sizeof(flod_mmaps->sn))) {
		char sn1_buf[30], sn2_buf[32];
		dcc_pemsg(EX_IOERR, emsg, "s/n %s instead of %s in %s",
			  ts2str(sn1_buf, sizeof(sn1_buf), &flod_mmaps->sn),
			  ts2str(sn2_buf, sizeof(sn2_buf), sn),
			  flod_mmap_path.c);
		flod_unmap(0, 0);
		return 0;
	}

	return 1;
}



u_char					/* 0=failed, 1=mapped */
flod_mmap(DCC_EMSG *emsg,
	  const DB_SN *sn,
	  const DCCD_STATS *dccd_stats,
	  u_char rw)			/* 0=rdonly/unlocked, 1=write/locked */
{
	int i;

	if (!flod_unmap(emsg, dccd_stats) && emsg) {
		dcc_trace_msg("%s", emsg->c);
		emsg->c[0] = '\0';
	}

	/* try to open the existing file */
	i = flod_mmap_try(emsg, sn, rw);

	/* finished if that went well or we are not allowed to fix things */
	if (i != 0 || !rw)
		return i > 0;

	/* delete the file if it is broken */
	if (emsg && emsg->c[0] != '\0') {
		dcc_trace_msg("%s", emsg->c);
		emsg->c[0] = '\0';
	}
	if (0 > unlink(flod_mmap_path.c)
	    && errno != ENOENT) {
		dcc_pemsg(EX_IOERR, emsg, "unlink(%s): %s",
			  flod_mmap_path.c, ERROR_STR());
		flod_unmap(0, 0);
		return 0;
	}
	flod_unmap(0, 0);

	/* try to recreate the file */
	if (flod_mmap_try(emsg, sn, 1) > 0) {
		if (emsg) {
			dcc_trace_msg("%s", emsg->c);
			emsg->c[0] = '\0';
		}
		return 1;
	}

	flod_unmap(0, 0);
	return 0;
}



const char *
flod_stats_printf(char *buf, int buf_len,
		  int st,		/* 0=off, 1=restarting, 2=on */
		  int oflods_total,
		  int oflods_active,
		  int iflods_active)
{
	snprintf(buf, buf_len,
		 "flood %s %3d streams  %d out active %d in",
		 st == 0 ? "off" : st == 1 ? "restarting" : "on",
		 oflods_total, oflods_active, iflods_active);
	return buf;
}



#define FIELD_SEP "  "

static void
mmap_fg_sub(char **bufp, int *buf_lenp, const char *str)
{
	int i;

	if (*buf_lenp == 0)
		return;

	i = snprintf(*bufp, *buf_lenp, FIELD_SEP"%s", str);
	if (*buf_lenp <= i) {
		*buf_lenp = 0;
	} else {
		*bufp += i;
		*buf_lenp -= i;
	}
}


const char *
socks_type_str(const FLOD_MMAP *mp)
{
	if (!mp || (mp->flags & FLODMAP_FG_SOCKS))
		return "SOCKS";
	if (mp->flags & FLODMAP_FG_NAT)
		return "NAT";
	if (mp->flags & FLODMAP_FG_NAT_AUTO)
		return "auto-NAT";
	return "?socks?";
}



static void
mmap_id_map(char **bufp, int *buf_lenp, const SRVR_ID_MAPS *maps)
{
	const char *sep;
	const char *result;
	int m, i;

	sep = FIELD_SEP;
	for (m = 0; m < maps->len; ++m) {
		result = "???";
		switch ((ID_MAP_RESULT)maps->entry[m].result) {
		case ID_MAP_NO: result = "ok"; break;
		case ID_MAP_REJ: result = "reject"; break;
		case ID_MAP_SELF: result = "self"; break;
		}
		if (maps->entry[m].lo == maps->entry[m].hi) {
			i = snprintf(*bufp, *buf_lenp, "%s%d->%s", sep,
				     maps->entry[m].lo,
				     result);
		} else if (maps->entry[m].lo == DCC_SRVR_ID_MIN
			   && maps->entry[m].hi == DCC_SRVR_ID_MAX) {
			i = snprintf(*bufp, *buf_lenp, "%sall->%s", sep,
				     result);
		} else {
			i = snprintf(*bufp, *buf_lenp, "%s%d-%d->%s", sep,
				     maps->entry[m].lo, maps->entry[m].hi,
				     result);
		}
		if (*buf_lenp <= i) {
			*buf_lenp = 0;
			return;
		}
		*bufp += i;
		*buf_lenp -= i;
		sep = ",";
	}
}



const char *
flodmap_fg(char *buf, int buf_len, const FLOD_MMAP *mp)
{
	char *buf0 = buf;

	if (!buf_len)
		return "";
	*buf = '\0';
	if (!mp)
		return buf0;

	if ((mp->flags & FLODMAP_FG_IN_OFF)
	    && (mp->flags & FLODMAP_FG_OUT_OFF)) {
		mmap_fg_sub(&buf, &buf_len, "off");
	} else {
		if (mp->flags & FLODMAP_FG_IN_OFF)
			mmap_fg_sub(&buf, &buf_len, "in off");
		if (mp->flags & FLODMAP_FG_OUT_OFF)
			mmap_fg_sub(&buf, &buf_len, "out off");
	}

	if (mp->flags & FLODMAP_FG_ROGUE)
		mmap_fg_sub(&buf, &buf_len, DCC_XHDR_ID_ROGUE);

	if (mp->flags & FLODMAP_FG_REWINDING)
		mmap_fg_sub(&buf, &buf_len, "rewinding");

	if (mp->flags & FLODMAP_FG_NEED_RWD)
		mmap_fg_sub(&buf, &buf_len, "need rewind");
	else if (mp->flags & FLODMAP_FG_FFWD_IN)
		mmap_fg_sub(&buf, &buf_len, "need FFWD");

	if (mp->flags & FLODMAP_FG_PASSIVE)
		mmap_fg_sub(&buf, &buf_len, "passive");
	if ((mp->flags & FLODMAP_FG_OUT_SRVR)
	    && !(mp->flags & FLODMAP_FG_PASSIVE))
		mmap_fg_sub(&buf, &buf_len, "forced passive");

	if (!(mp->flags & FLODMAP_FG_IN_SRVR)) {
		if (mp->flags & (FLODMAP_FG_SOCKS | FLODMAP_FG_NAT
				 | FLODMAP_FG_NAT_AUTO))
			mmap_fg_sub(&buf, &buf_len, socks_type_str(mp));
	} else {
		if (mp->flags & FLODMAP_FG_SOCKS)
			mmap_fg_sub(&buf, &buf_len, "rejected SOCKS");
		if (mp->flags & FLODMAP_FG_NAT)
			mmap_fg_sub(&buf, &buf_len, "rejected NAT");
	}

	if (mp->flags & FLODMAP_FG_LEAF)
		mmap_fg_sub(&buf, &buf_len, "leaf");

	if (mp->flags & FLODMAP_FG_FFWD_IN)
		mmap_fg_sub(&buf, &buf_len, "want fast-forward");

	if (mp->flags & FLODMAP_FG_USE_2PASSWD)
		mmap_fg_sub(&buf, &buf_len, "2nd password");

	if (mp->flags & FLODMAP_FG_IPv4)
		mmap_fg_sub(&buf, &buf_len, "IPv4");

	if (mp->flags & FLODMAP_FG_IPv6)
		mmap_fg_sub(&buf, &buf_len, "IPv6");

	if (!grey_on) {
		if (mp->flags & FLODMAP_FG_REP_PEER_REJ)
			mmap_fg_sub(&buf, &buf_len, "rej reps");
		else if (!(mp->flags & FLODMAP_FG_REP_PEER_ON)
			 && (mp->flags & FLODMAP_FG_IN_CONN))
			mmap_fg_sub(&buf, &buf_len, "broken reps");
	} else {
		if (mp->flags & FLODMAP_FG_REP_PEER_ON)
			mmap_fg_sub(&buf, &buf_len, "bad reps");
		else if (!grey_on)
			mmap_fg_sub(&buf, &buf_len, "no reps");
	}

	mmap_id_map(&buf, &buf_len, &mp->o_id_maps);
	mmap_id_map(&buf, &buf_len, &mp->i_id_maps);

	return buf0;
}



/* this function lets clients such as dbclean know when flooding is quiet */
int					/* -1=sick, 0=off, 1=not off */
flod_running(const char *st)
{
	char off_buf[11];
	int out, active, in;

	if (4 != sscanf(st, "flood %10s %d streams %d out active %d in",
			off_buf, &out, &active, &in))
		return 1;

	if (strcmp(off_buf, "off"))
		return 1;
	return active != 0 || in != 0;
}
