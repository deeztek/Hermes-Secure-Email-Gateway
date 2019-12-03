/* Distributed Checksum Clearinghouse
 *
 * open and lock database and whitelist files
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
 * Rhyolite Software DCC 2.3.167-1.68 $Revision$
 */

#include "dcc_defs.h"
#include <signal.h>


#ifndef DCC_WIN32
uid_t dcc_real_uid, dcc_effective_uid;
gid_t dcc_real_gid, dcc_effective_gid;
#endif

/* We must be SUID to read and write the system's common
 *	connection parameter memory mapped file.
 *	If the real UID is 0, then forget any SUID stuff and run as root.
 *	Otherwise remember the powerful UID and the real UID, and
 *	release the privilege of using the powerful UID */
void
dcc_init_priv(void)
{
#ifndef DCC_WIN32
	dcc_real_uid = getuid();
	if (dcc_real_uid == 0) {
		dcc_effective_uid = 0;
	} else {
		dcc_effective_uid = geteuid();
	}

	if (0 > seteuid(dcc_real_uid))
		dcc_error_msg("seteuid(%d): %s",
			      (int)dcc_real_uid, ERROR_STR());

	dcc_real_gid = getgid();
	if (dcc_real_gid == 0) {
		dcc_effective_gid = 0;
	} else {
		dcc_effective_gid = getegid();
	}

	if (0 > setegid(dcc_real_gid))
		dcc_error_msg("setegid(%d): %s",
			      (int)dcc_real_gid, ERROR_STR());
#endif
	dcc_rel_priv();
}



#ifndef DCC_WIN32
void
dcc_get_priv(void)
{
	if (dcc_real_uid != dcc_effective_uid
	    && 0 > seteuid(dcc_effective_uid))
		dcc_error_msg("seteuid(%d): %s",
			      (int)dcc_effective_uid, ERROR_STR());
	if (dcc_real_gid != dcc_effective_gid
	    && 0 > setegid(dcc_effective_gid))
		dcc_error_msg("setegid(%d): %s",
			      (int)dcc_effective_gid, ERROR_STR());
}
#endif



/* get set-UID privilege if the file is in the DCC home directory */
u_char					/* 0=bad idea, 1=have privilege */
dcc_get_priv_home(const char *nm)
{
#ifdef DCC_WIN32
	return 0;
#else
	DCC_PATH abs_nm;

	if (dcc_real_uid == dcc_effective_uid
	    && dcc_real_gid == dcc_effective_gid)
		return 0;

	if (!dcc_fnm2abs(&abs_nm, nm, 0)
	    || strncmp(abs_nm.c, DCC_HOMEDIR, LITZ(DCC_HOMEDIR)))
		return 0;

	dcc_get_priv();
	return 1;
#endif
}



void
dcc_rel_priv(void)
{
#ifndef DCC_WIN32
	int serrno;

	if (dcc_real_uid != dcc_effective_uid
	    || dcc_real_gid != dcc_effective_gid) {
		serrno = errno;
		if (0 > seteuid(dcc_real_uid))
			dcc_error_msg("seteuid(%d): %s",
				      (int)dcc_real_uid, ERROR_STR());
		if (0 > setegid(dcc_real_gid))
			dcc_error_msg("setegid(%d): %s",
				      (int)dcc_real_gid, ERROR_STR());
		errno = serrno;
	}
#endif
}



/* see if a file is private */
u_char
dcc_ck_private(DCC_EMSG *emsg, struct stat *sb, const char *nm, int fd)
{
	struct stat sb0;
	DCC_PATH path;
	int i;

	if (!sb)
		sb = &sb0;

	if (fd == -1) {
		i = stat(nm, sb);
	} else {
		i = fstat(fd, sb);
	}
	if (i < 0) {
		dcc_pemsg(EX_IOERR, emsg, "stat(%s): %s",
			  dcc_fnm2abs_msg(&path, nm), ERROR_STR());
		return 0;
	}
#ifdef HAVE_PRIVATE_FILES
	/* even on systems like Windows without private files,
	 * some callers want the results of the stat() */
	if ((sb->st_mode & (S_IRGRP|S_IWGRP|S_IWOTH|S_IXOTH)) != 0) {
		dcc_pemsg(EX_NOPERM, emsg,
			  "%s is not private", dcc_fnm2abs_msg(&path, nm));
		return 0;
	}
#endif
	return 1;
}



#ifndef DCC_WIN32
static void
set_fl(struct flock *fl, int type, int byte_num)
{
	memset(fl, 0, sizeof(*fl));
	fl->l_type = type;
	fl->l_whence = SEEK_SET;
	if (byte_num != DCC_LOCK_ALL_FILE) {
		fl->l_start = byte_num;
		fl->l_len = 1;
	}
}
#endif /* DCC_WIN32 */



/* open a file with a lock,
 *	The lock can optionally be a pretense. */
int					/* -1=failed & emsg set, >=0 if done */
dcc_lock_open(DCC_EMSG *emsg,
	      const char *nm,
	      int open_flags,		/* eg. O_CREAT */
	      u_char lock_mode,		/* DCC_LOCK_OPEN_* */
	      int lock_num,		/* which byte of the file to lock */
	      u_char *busyp)		/* 1=file is busy */
{
#ifdef DCC_WIN32
/* Win95 and Win98 do not include UNIX style file locking,
 * including non-blocking locks and upgrading locks from shared to exclusive.
 * In principle they could be constructed from the WIN32 synchronization
 * primitives and a few bytes of shared memory.  Win98 does not even
 * have a blocking file lock function.
 */
	HANDLE h;
	int fd;
	DCC_PATH path;

	h = CreateFile(nm,
		       (open_flags == O_RDONLY
			? GENERIC_READ
			: (GENERIC_READ | GENERIC_WRITE)),
		       FILE_SHARE_READ | FILE_SHARE_WRITE, 0,
		       ((open_flags & O_EXCL)
			? CREATE_NEW
			: (open_flags & O_CREAT)
			? CREATE_ALWAYS
			: OPEN_EXISTING),
		       FILE_ATTRIBUTE_NORMAL, 0);
	if (h == INVALID_HANDLE_VALUE) {
		dcc_pemsg(EX_IOERR, emsg, "CreateFile(%s): %s",
			  dcc_fnm2abs_msg(path, nm), ERROR_STR());
		if (busyp)
			*busyp = 0;
		return -1;
	}
	fd = _open_osfhandle((long)h, 0);
	if (fd < 0) {
		dcc_pemsg(EX_IOERR, emsg, "_open_osfhandle(%s): %s",
			  nm, ERROR_STR());
		CloseHandle(h);
		if (busyp)
			*busyp = 0;
		return -1;
	}
	if (!(lock_mode & DCC_LOCK_OPEN_NOLOCK)) {
		if (!dcc_win32_lock(h,
				    ((lock_mode & DCC_LOCK_OPEN_SHARE)
				     ? 0 : LOCKFILE_EXCLUSIVE_LOCK)
				    | (lock_mode & DCC_LOCK_OPEN_NOWAIT
				       ? 0 : LOCKFILE_FAIL_IMMEDIATELY))) {
			dcc_pemsg(EX_IOERR, emsg, "open LockFileEx(%s): %s",
				  dcc_fnm2abs_msg(path, nm), ERROR_STR());
			if (busyp)
				*busyp = (GetLastError() == ERROR_LOCK_VIOLATION
					  || GetLastError()==ERROR_LOCK_FAILED);
			close(fd);
			return -1;
		}
	}

#else /* !DCC_WIN32 */
	static u_char checked_stdio = 0;
	int fd;
	struct flock fl;
	DCC_PATH path;

	/* ensure 0, 1, and 2 are open so none of our real files get
	 * those file descriptors and are used as stdin, stdout, or stderr */
	if (!checked_stdio) {
		dcc_clean_stdio();
		checked_stdio = 1;
	}

	fd = open(nm, open_flags, 0666);
	if (fd < 0 && dcc_get_priv_home(nm)) {
		fd = open(nm, open_flags, 0666);
		dcc_rel_priv();
	}
	if (fd < 0) {
		if (errno == EACCES)
			dcc_pemsg(EX_NOINPUT, emsg,
				  "lock_open(%s): %s;"
				  " file not writeable for locking",
				  dcc_fnm2abs_msg(&path, nm), ERROR_STR());
		else
			dcc_pemsg(EX_NOINPUT, emsg,
				  "lock_open(%s): %s",
				  dcc_fnm2abs_msg(&path, nm), ERROR_STR());
		if (busyp)
			*busyp = DCC_BLOCK_ERROR();
		return -1;
	}

	if (0 > fcntl(fd, F_SETFD, FD_CLOEXEC)) {
		if (busyp)
			*busyp = 0;
		dcc_pemsg(EX_IOERR, emsg,
			  "fcntl(F_SETFD FD_CLOEXEC %s %d): %s",
			  dcc_fnm2abs_msg(&path, nm), lock_num, ERROR_STR());
		close(fd);
		return -1;
	}

	/* We may already have a lock on the file under a different file
	 * descriptor.  If not, try to get a lock */
	if (lock_mode != DCC_LOCK_OPEN_NOLOCK) {
		set_fl(&fl,
		       (lock_mode & DCC_LOCK_OPEN_SHARE) ? F_RDLCK : F_WRLCK,
		       lock_num);
		if (0 > fcntl(fd, (lock_mode & DCC_LOCK_OPEN_NOWAIT
				   ? F_SETLK : F_SETLKW),
			      &fl)) {
			dcc_pemsg(EX_NOINPUT, emsg,
				  "open fcntl(%s F_WRLCK %s %d): %s",
				  (lock_mode & DCC_LOCK_OPEN_NOWAIT
				   ? "F_SETLK" : "F_SETLKW"),
				  dcc_fnm2abs_msg(&path, nm), lock_num,
				  ERROR_STR());
			if (busyp)
				*busyp = (DCC_BLOCK_ERROR()
					 || errno == EACCES);	/* for SunOS */
			close(fd);
			return -1;
		}
	}
#endif /* !DCC_WIN32 or UNIX */

	if (busyp)
		*busyp = 0;
	return fd;
}



u_char					/* 1=done 0=failed */
dcc_unlock_fd(DCC_EMSG *emsg DCC_UNUSED, int fd,
	      int lock_num,		/* which byte of the file to unlock */
	      const char *str, const char *nm)
{
#ifdef DCC_WIN32
	DCC_PATH path;

	if (!dcc_win32_unlock((HANDLE)_get_osfhandle(fd))) {
		dcc_pemsg(EX_NOINPUT, emsg,
			  "UnlockFileEx(%s%s): %s",
			  str, dcc_fnm2abs_msg(path, nm), ERROR_STR());
		return 0;
	}
	return 1;
#else
	struct flock fl;
	DCC_PATH path;

	set_fl(&fl, F_UNLCK, lock_num);
	if (0 > fcntl(fd, F_SETLK, &fl)) {
#ifdef DCC_DEBUG_LOCKS
		dcc_logbad(EX_SOFTWARE,
			   "fcntl(F_SETLK F_UNLCK %s%s %d): %s",
			   str, dcc_fnm2abs_msg(&path, nm), lock_num,
			   ERROR_STR());
#else
		dcc_pemsg(EX_NOINPUT, emsg,
			  "fcntl(F_SETLK F_UNLCK %s%s %d): %s",
			  str, dcc_fnm2abs_msg(&path, nm), lock_num, ERROR_STR());
		return 0;
#endif
	}
	return 1;
#endif /* DCC_WIN32 */
}



#ifndef DCC_WIN32
/* cause EINTR if we cannot get the lock */
static void
deadman(int s DCC_UNUSED)
{
#if 0
	dcc_logbad(EX_SOFTWARE, "exclusive lock deadman timer fired");
#endif
}
#endif



u_char					/* 1=done 0=failed */
dcc_exlock_fd(DCC_EMSG *emsg, int fd,
	      int lock_num,		/* which byte of the file to lock */
	      int max_delay,
	      const char *str, const char *nm)
{
#ifdef DCC_WIN32
	DCC_PATH path;

	if (!dcc_win32_lock((HANDLE)_get_osfhandle(fd),
			    LOCKFILE_EXCLUSIVE_LOCK)) {
		dcc_pemsg(EX_IOERR, emsg, "LockFileEx(%s %s): %s",
			  str, dcc_fnm2abs_msg(&path, nm), ERROR_STR());
		return 0;
	}
	return 1;

#else /* !DCC_WIN32 */
	struct flock fl;
	DCC_PATH path;
	time_t start;
	u_char result;

	start = time(0);
	if (max_delay) {
#ifdef HAVE_SIGINTERRUPT
		siginterrupt(SIGALRM, 1);
#endif
		signal(SIGALRM, deadman);
		alarm(max_delay+1);
	}

	for (;;) {

		set_fl(&fl, F_WRLCK, lock_num);
		if (0 <= fcntl(fd, F_SETLKW, &fl)) {
			result = 1;
			break;
		}

		/* EINTR means something is hogging the lock */
		if (DELAY_ERROR()) {
			time_t delta = time(0) - start;
			if (delta < max_delay) {
				if (delta < 0) {    /* handle time jump */
					start = time(0);
					delta = 0;
				}
				alarm(max_delay-delta+1);
				continue;
			}
			dcc_pemsg(EX_NOINPUT, emsg,
				  "fcntl(F_SETLKW F_WRLCK %s%s %d)"
				  " failed after %d seconds",
				  str, dcc_fnm2abs_msg(&path, nm), lock_num,
				  (int)delta);
			result = 0;
			break;
		}
#ifdef DCC_DEBUG_LOCKS
		if (errno == EDEADLK) {
			struct flock fl2;
			pid_t our_pid;

			our_pid = getpid();
			fl2 = fl;
			if (0 > fcntl(fd, F_GETLK, &fl2))
				dcc_pemsg(EX_NOINPUT, emsg,
					  "fcntl(F_GETLK): %s", ERROR_STR());
			dcc_logbad(EX_SOFTWARE,
				   "%d %d fcntl(F_SETLKW F_WRLCK %s%s %d): %s",
				   (int)our_pid, (int)fl2.l_pid,
				   str, dcc_fnm2abs_msg(&path, nm), lock_num,
				   strerror(EDEADLK));
		}
		if (errno == EBADF) {
			dcc_logbad(EX_SOFTWARE,
				   "fcntl(F_SETLKW F_WRLCK %s%s %d): %s",
				   str, dcc_fnm2abs_msg(&path, nm), lock_num,
				   ERROR_STR());
		}
#endif
		dcc_pemsg(EX_NOINPUT, emsg,
			  "fcntl(F_SETLKW F_WRLCK %s%s %d): %s",
			  str, dcc_fnm2abs_msg(&path, nm), lock_num,
			  ERROR_STR());
		result = 0;
		break;
	}

	if (max_delay) {
		signal(SIGALRM, SIG_DFL);
		alarm(0);
	}
	return result;
#endif /* DCC_WIN32 */
}



/* Several systems do not update the mtimes of files modified with mmap().
 * Some like BSD/OS delay changing the mtime until the file accessed with
 * read().  Others including filesystems on some versions of Linux
 * apparently never change the mtime. */
u_char
dcc_set_mtime(DCC_EMSG *emsg, const char *nm, int fd DCC_UNUSED,
	      const struct timeval *mtime)
{
#undef DIDIT
#if defined(HAVE_FUTIMES) && !defined(linux) && !defined(DIDIT)
	/* some Linux systems have a broken futimes implementation that does
	 * not work for programs started as root but that release privileges */
	struct timeval tbuf[2], *tbufp;
	DCC_PATH path;
	int result;

	if (mtime) {
		tbuf[0] = *mtime;
		tbuf[1] = *mtime;
		tbufp = tbuf;
	} else {
		tbufp = 0;
	}
	result = futimes(fd, tbufp);
	if (result < 0
	    && (errno == EACCES || errno == EPERM)
	    && dcc_real_uid != dcc_effective_uid) {
		dcc_get_priv();
		result = futimes(fd, tbufp);
		dcc_rel_priv();
	}
	if (result < 0)
		dcc_pemsg(EX_IOERR, emsg,"futimes(%s): %s",
			  dcc_fnm2abs_msg(&path, nm), ERROR_STR());
#define DIDIT
#endif /* HAVE_FUTIMES */
#if defined(HAVE_UTIME_H) && !defined(DIDIT)
	struct utimbuf tbuf, *tbufp;
	DCC_PATH path;
	int result;

	if (mtime) {
		tbuf.actime = tbuf.modtime = mtime->tv_sec;
		tbufp = &tbuf;
	} else {
		tbufp = 0;
	}
	result = utime(nm, tbufp);
	if (result < 0
	    && dcc_real_uid != dcc_effective_uid) {
		dcc_get_priv();
		result = utime(nm, tbufp);
		dcc_rel_priv();
	}
	if (result < 0)
		dcc_pemsg(EX_IOERR, emsg,"utime(%s): %s",
			  dcc_fnm2abs_msg(&path, nm), ERROR_STR());
#define DIDIT
#endif /* HAVE_UTIME_H */

#ifdef DIDIT
	return result >= 0;
#undef DIDIT
#else
	return 1;			/* WIN32 */
#endif
}
