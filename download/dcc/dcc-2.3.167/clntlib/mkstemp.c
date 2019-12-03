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
 * Rhyolite Software DCC 2.3.167-1.62 $Revision$
 */

#include "dcc_defs.h"
#include "dcc_paths.h"
#ifdef DCC_WIN32
#include <direct.h>
#else
#include <dirent.h>
#endif

static struct {
    DCC_PATH path;			/* has trailing '/' */
} tmp[3];
static int num_tmp_paths;

static u_char new_gen = 1;


static const char *
mkstr(char str[DCC_MKSTEMP_LEN+1])
{
	static const char digits[] = "0123456789"
#ifndef DCC_WIN32
				    "abcdefghijklmnopqrstuvwxyz"
#endif
				    "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	static u_int32_t gen;
	u_int32_t n;
	int pos;

	/* (re)start the generator and take a number
	 * There is a race among threads here to compute ++gen.
	 * However, it is rare and the worst that happens is that one thread
	 * will lose when it tries to create the file, just as it might lose
	 * to another process, and so need to come here again. */
	if (new_gen) {
		struct timeval now;
#ifdef DCC_WIN32
		u_int32_t r;
#else
		u_int64_t r;
#endif
		new_gen = 0;
		gettimeofday(&now, 0);
		r = now.tv_sec % (14*24*60*60);
		r *= now.tv_usec / 100;
		r *= getpid();
		gen = r;
		n = gen;
	} else {
		n = ++gen;
	}

	pos = DCC_MKSTEMP_LEN;
	str[pos] = '\0';
	do {
		str[--pos] = digits[n % (LITZ(digits))];
		n /= (LITZ(digits));
	} while (pos > 0);
	return str;
}



/* Some platforms have broken implementations of mkstemp() that generate
 * only 32 different names.
 * Given the main uses for mkstemp() in the DCC for log files in directories
 * used only by the DCC, it is nice to try to make the names sort of
 * sequential for a given dccm process.  That means nothing more than putting
 * the random bits in the most significant bits of the seed and using
 * a small constant for the addition in the random number generator that is
 * commonly used, and remembering the generator. */
int					/* -1 or FD of temporary file */
dcc_mkstemp(DCC_EMSG *emsg,
	    DCC_PATH *nm,		/* put the generated name here */
	    char *id, int id_len,	/* put unique name string here */
	    const char *old,		/* try this name first */
	    const char *tgtdir,		/* directory or 0 for tmp_path */
	    const char *p2,		/* rest of the name */
	    u_char close_del,		/* 1=delete on close */
	    int mode)			/* add these mode bits to 0600 */
{
	char str[DCC_MKSTEMP_LEN+1];
	int fd, limit, serrno;
	const char *p1;
	int i;
#ifdef DCC_WIN32
	HANDLE h;
	DWORD flags;
#else
	mode_t old_mask;
#endif

	if (!p2)
		p2 = "";
	p1 = tgtdir;
	if (!p1) {
		if (!num_tmp_paths)
			tmp_path_init(0, 0);
		p1 = tmp[0].path.c;
	}

	/* this loop should almost always need only a single pass */
	limit = 0;
	for (;;) {
		if (*p2 == '/') {	/* avoid "//" */
			i = strlen(p1);
			if (i > 0 && p1[i-1] == '/')
				++p2;
		}

		if (old) {
			i = snprintf(nm->c, sizeof(nm->c),
				     "%s%s%."DCC_MKSTEMP_LEN_STR"s",
				     p1, p2, old);
		} else {
			i = snprintf(nm->c, sizeof(nm->c),
				     "%s%s%s",
				     p1, p2, mkstr(str));
		}
		if (i >= ISZ(nm->c)) {
			dcc_pemsg(EX_SOFTWARE, emsg,
				  "temporary file name \"%s...\" too big",
				  nm->c);
			nm->c[0] = '\0';
			return -1;
		}

#ifdef DCC_WIN32
		/* Given the uses of this function, if the temporary
		 * file is open, then it has been abandoned.  All valid
		 * uses have the file renamed.  Windows does not allow
		 * open files to be unlinked.  FILE_FLAGS_DELETE_ON_CLOSE
		 * does not seem to be supported everywhere or it is
		 * unreliable.  So open existing files without sharing
		 * but truncated.
		 * Use CreateFile() because the Borland and Microsoft
		 * open(), _open(), and _sopen() functions differ */
		flags = (close_del
			 ? FILE_ATTRIBUTE_TEMPORARY | FILE_FLAG_DELETE_ON_CLOSE
			 : FILE_ATTRIBUTE_NORMAL);
		h = CreateFile(nm, GENERIC_READ | GENERIC_WRITE, 0,
			       0, CREATE_NEW, flags, 0);
		if (h == INVALID_HANDLE_VALUE)
			h = CreateFile(nm, GENERIC_READ | GENERIC_WRITE, 0,
				       0, TRUNCATE_EXISTING, flags, 0);
		if (h != INVALID_HANDLE_VALUE) {
			fd = _open_osfhandle((long)h, 0);
			if (fd >= 0) {
				if (id && *id == '\0')
					STRLCPY(id, str, id_len);
				return fd;
			}
			dcc_pemsg(EX_IOERR, emsg, "_open_osfhandle(%s): %s",
				  nm, ERROR_STR());
			CloseHandle(h);
			*nm = '\0';
			return -1;
		}
		serrno = errno;
#else
		old_mask = umask(02);
		fd = open(nm->c, O_RDWR | O_CREAT | O_EXCL,
			  (mode & 0777) | 0600);
		serrno = errno;
		umask(old_mask);
		if (fd >= 0) {
			if (close_del
			    && 0 > unlink(nm->c)) {
				dcc_pemsg(EX_IOERR, emsg, "unlink(%s): %s",
					  nm->c, ERROR_STR1(serrno));
				close(fd);
				nm->c[0] = '\0';
				return -1;
			}
			if (id && *id == '\0')
				STRLCPY(id, str, id_len);
			return fd;
		}
#endif

		if (errno != EEXIST) {
			if (tgtdir != 0 || p1 == tmp[num_tmp_paths-1].path.c) {
				dcc_pemsg(EX_IOERR, emsg, "open(%s): %s",
					  nm->c, ERROR_STR1(serrno));
				nm->c[0] = '\0';
				return -1;
			}
			p1 += sizeof(tmp[num_tmp_paths].path);
			continue;
		}
		if (++limit > 10) {
			dcc_pemsg(EX_IOERR, emsg, "open(%s) %d times: %s",
				  nm->c, limit, ERROR_STR1(EEXIST));
			nm->c[0] = '\0';
			return -1;
		}

		if (old) {
			old = 0;
		} else {
			/* There is already a file of the generated name.
			 * That implies that the current sequence of names
			 * has collided with an older sequence.
			 * So start a new sequence. */
			new_gen = 1;
		}
	}
}




DCC_PATH dcc_main_logdir;
static LOG_MODE dcc_main_log_mode;

/* see if a directory is a suitable for DCC client log files */
static int				/* 1=ok, -2=non-existent, -1=bad */
stat_logdir(DCC_EMSG *emsg,
	    const char *logdir,
	    struct stat *sb)
{
	int result;

	if (0 > stat(logdir, sb)) {
		if (errno == ENOTDIR || errno == ENOENT) {
			result = -2;
		} else {
			result = -1;
		}
		dcc_pemsg(EX_IOERR, emsg, "stat(log directory \"%s\"): %s",
			  logdir, ERROR_STR());
		return result;
	}

	if (!S_ISDIR(sb->st_mode)) {
		dcc_pemsg(EX_IOERR, emsg, "\"%s\" is not a log directory",
			  logdir);
		return -1;
	}
	return 1;
}



static void
tmpdir_ck(const char *dir, u_char complain)
{
#ifndef DCC_WIN32
	struct stat sb;
#endif
	DCC_PATH *path;

	if (!dir || *dir == '\0') {
		if (complain)
			dcc_error_msg("null -T temporary directory");
		return;
	}

	path = &tmp[num_tmp_paths].path;
	if (!dcc_fnm2abs(path, dir, "")
	    || strlen(path->c) > ISZ(*path)-DCC_MKSTEMP_LEN-2) {
		if (complain)
			dcc_error_msg("-T \"%s\" too long", dir);
		path->c[0] = '\0';
		return;
	}
	++num_tmp_paths;

#ifndef DCC_WIN32		/* stat(directory) fails on Windows XP */
	if (complain) {
		if (0 > stat(path->c, &sb)) {
			dcc_error_msg("stat(temporary directory \"%s\"): %s",
				      path->c, ERROR_STR());
			return;
		}
		if (!S_ISDIR(sb.st_mode)) {
			dcc_error_msg("\"%s\" is not a temporary directory",
				      path->c);
			return;
		}
#ifdef HAVE_EACCESS
		if (0 > eaccess(path->c, W_OK)) {
			dcc_error_msg("temporary directory \"%s\": %s",
				      path->c, ERROR_STR());
			return;
		}
#endif
	}
#endif /* !DCC_WIN32 */

	STRLCAT(path->c, "/", sizeof(path->c));
}



/* get the temporary directory ready */
void
tmp_path_init(const char *dir1,		/* prefer this & complain if bad */
	      const char *dir2)		/* then this but no complaint */
{
	if (dir1)
		tmpdir_ck(dir1, 1);

	if (dir2)
		tmpdir_ck(dir2, 0);

	tmpdir_ck(_PATH_TMP, 1);
}


/* Initialize the main DCC client log directory including parsing the
 *	prefix of subdirectory type.  In case the path is relative,
 *	this should be called after the change to the DCC home directory */
u_char					/* 0=failed 1=ok */
dcc_main_logdir_init(DCC_EMSG *emsg, const char *arg)
{
	struct stat sb;

	if (!arg)
		return 1;

	/* if the directory name starts with "D?", "H?", or "M?",
	 * automatically add subdirectories */
	if (!CLITCMP(arg, "D?")) {
		dcc_main_log_mode = LOG_MODE_DAY;
		arg += LITZ("D?");

	} else if (!CLITCMP(arg, "H?")) {
		dcc_main_log_mode = LOG_MODE_HOUR;
		arg += LITZ("H?");

	} else if (!CLITCMP(arg, "M?")) {
		dcc_main_log_mode = LOG_MODE_MINUTE;
		arg += LITZ("M?");

	} else {
		dcc_main_log_mode = LOG_MODE_FLAT;
	}

	if (!dcc_fnm2rel(&dcc_main_logdir, arg, 0)) {
		dcc_pemsg(EX_DATAERR, emsg, "bad log directry \"%s\"", arg);
		return 0;
	}

	return stat_logdir(emsg, dcc_main_logdir.c, &sb) > 0;
}



static u_char
mklogsubdir(DCC_EMSG *emsg,
	    DCC_PATH *dir,		/* put directory name here */
	    struct stat *dir_sb,
	    const char *grandparent,
	    const char *parent,
	    const struct stat *parent_sb,
	    u_char day_pat, u_int dirnum)
{
	int stat_result;
	int i;

	if (day_pat)
		i = snprintf(dir->c, sizeof(DCC_PATH), "%s/%03d",
			     parent, dirnum);
	else
		i = snprintf(dir->c, sizeof(DCC_PATH), "%s/%02d",
			     parent, dirnum);
	if (i >= ISZ(DCC_PATH)) {
		dcc_pemsg(EX_DATAERR, emsg, "long log directry name \"%s\"",
			  grandparent);
		return 0;
	}

	/* see if it already exists */
	stat_result = stat_logdir(emsg, dir->c, dir_sb);
	if (stat_result == -1)
		return 0;

#ifdef DCC_WIN32
	if (stat_result == -2 && 0 > mkdir(dir->c)) {
		dcc_pemsg(EX_IOERR, emsg, "mkdir(%s): %s",
			  dir->c, ERROR_STR());
		/* ok after all if another process raced us to create it */
		stat_result = stat_logdir(emsg, dir->c, dir_sb);
		if (stat_result <= 0)
			return 0;
	}
	return 1;
#else
	if (stat_result == -2) {
		mode_t old_mask;

		old_mask = umask(02);
		i = mkdir(dir->c, (parent_sb->st_mode & 0775) | 0700);
		umask(old_mask);
		if (0 > i) {
			dcc_pemsg(EX_IOERR, emsg, "mkdir(%s): %s",
				  dir->c, ERROR_STR());
			/* ok after all if another process raced us */
			stat_result = stat_logdir(emsg, dir->c, dir_sb);
			if (stat_result <= 0)
				return 0;
		}
		stat_result = stat_logdir(emsg, dir->c, dir_sb);
		if (stat_result < 0)
			return 0;
	}
	/* set GID if necessary */
	if (dir_sb->st_gid != parent_sb->st_gid) {
		if (0 > chown(dir->c, dir_sb->st_uid, parent_sb->st_gid)) {
			/* this is expected to be needed and to work
			 * only for root */
			if (errno == EPERM)
				return 1;
			dcc_pemsg(EX_IOERR, emsg, "chown(%s,%d,%d): %s",
				  dir->c, (int)dir_sb->st_uid,
				  (int)parent_sb->st_gid,
				  ERROR_STR());
			return 0;
		}
		dir_sb->st_gid = parent_sb->st_gid;
	}
	return 1;
#endif /* DCC_WIN32 */
}



/* create and open a DCC client log file */
int					/* fd -1=no directory -2=serious */
dcc_log_open(DCC_EMSG *emsg,
	     DCC_PATH *log_path,	/* put the log file name here */
	     char *id, int id_len,	/* put log ID string here */
	     const char *old,		/* try this name first */
	     const char *logdir,
	     const char *prefix,	/* DCC_*_LOG_PREFIX */
	     LOG_MODE log_mode)
{
	time_t now;
	struct tm tm;
	DCC_PATH dir_a, dir_b;
	struct stat sb_a, sb_b;
#ifndef DCC_WIN32
	struct stat sb_f;
#endif
	const struct stat *sb;
	int stat_result, fd;

	log_path->c[0] = '\0';

	stat_result = stat_logdir(emsg, logdir, &sb_b);
	if (stat_result < 0)
		return stat_result;

	if (log_mode == LOG_MODE_FLAT) {
		sb = &sb_b;

	} else {
		now = time(0);
		dcc_localtime(now, &tm);

		if (!mklogsubdir(emsg, &dir_a, &sb_a,
				 logdir, logdir, &sb_b, 1, tm.tm_yday+1))
			return -2;

		if (log_mode == LOG_MODE_DAY) {
			logdir = dir_a.c;
			sb = &sb_a;
		} else {
			if (!mklogsubdir(emsg, &dir_b, &sb_b,
					 logdir, dir_a.c, &sb_a,
					 0, tm.tm_hour))
				return -2;

			if (log_mode == LOG_MODE_HOUR) {
				logdir = dir_b.c;
				sb = &sb_b;
			} else {
				if (!mklogsubdir(emsg, &dir_a, &sb_a,
						 logdir, dir_b.c, &sb_b,
						 0, tm.tm_min))
					return -2;
				logdir = dir_a.c;
				sb = &sb_a;
			}
		}
	}

	fd = dcc_mkstemp(emsg, log_path, id, id_len, old,
			 logdir, prefix, 0, sb->st_mode & 0640);
	if (fd < 0)
		return -2;

#ifndef DCC_WIN32
	/* give it the right GID */
	if (0 > fstat(fd, &sb_f)) {
		dcc_pemsg(EX_IOERR, emsg, "fstat(%s): %s",
			  log_path->c, ERROR_STR());
		close(fd);
		return -2;
	}
	if (sb->st_gid != sb_f.st_gid
	    && 0 > fchown(fd, sb_f.st_uid, sb->st_gid)
	    && errno != EPERM) {
		/* this is expected to be needed and to work only for root */
		dcc_pemsg(EX_IOERR, emsg, "chown(%s,%d,%d): %s",
			  log_path->c, (int)sb_f.st_uid, (int)sb->st_gid,
			  ERROR_STR());
		close(fd);
		return -2;
	}
#endif
	return fd;
}



/* create and open a main DCC client log file */
int					/* fd -1=no directory -2=serious */
dcc_main_log_open(DCC_EMSG *emsg,
		  DCC_PATH *log_path,	/* put the log file name here */
		  char *id, int id_len)	/* put log ID string here */
{
	return dcc_log_open(emsg, log_path, id, id_len, 0,
			    dcc_main_logdir.c, DCC_TMP_LOG_PREFIX,
			    dcc_main_log_mode);
}


/* rename a DCC client log file to a unique name */
u_char
dcc_log_keep(DCC_EMSG *emsg, DCC_PATH *cur_path)
{
	DCC_PATH new_path;
	char str[DCC_MKSTEMP_LEN+1];
	int path_len;
	int limit;

	path_len = strlen(cur_path->c);
	if (path_len < LITZ(DCC_TMP_LOG_PREFIX)+DCC_MKSTEMP_LEN)
		dcc_logbad(EX_SOFTWARE,
			   "dcc_log_keep(%s): path too short", cur_path->c);
	if (path_len >= ISZ(new_path))
		dcc_logbad(EX_SOFTWARE,
			   "dcc_log_keep(%s): path too long", cur_path->c);

	/* start by trying the current name with "tmp" replaced by "msg" */
	memcpy(new_path.c, cur_path->c, path_len+1);
	memcpy(&new_path.c[path_len - (LITZ(DCC_TMP_LOG_PREFIX)
				       +DCC_MKSTEMP_LEN)],
	       DCC_FIN_LOG_PREFIX, LITZ(DCC_FIN_LOG_PREFIX));
	limit = 0;
	for (;;) {
#ifdef DCC_WIN32
		/* Windows does not have hard links */
		if (!rename(cur_path, new_path)) {
			memcpy(cur_path, new_path, path_len);
			return 1;
		}
		if (limit > 10 || errno != EACCES) {
			dcc_pemsg(EX_IOERR, emsg, "rename(%s,%s) %d times: %s",
				  cur_path, new_path, limit, ERROR_STR());
			return 0;
		}
#else
		/* rename() on some UNIX systems deletes a pre-existing
		 * target, so we must use link() and unlink() */
		if (link(cur_path->c, new_path.c) >= 0) {
			/* we made the link, so unlink the old name */
			if (unlink(cur_path->c) < 0) {
				dcc_pemsg(EX_IOERR, emsg, "unlink(%s): %s",
					  cur_path->c, ERROR_STR());
				return 0;
			}
			memcpy(cur_path->c, new_path.c, path_len);
			return 1;
		}
		if (limit > 10 || errno != EEXIST) {
			dcc_pemsg(EX_IOERR, emsg, "link(%s,%s) %d times: %s",
				  cur_path->c, new_path.c, limit, ERROR_STR());
			return 0;
		}
#endif

		 /* look for another sequence of names
		  * if our new choice for a name was taken */
		if (++limit > 1)
			new_gen = 1;
		memcpy(&new_path.c[path_len-DCC_MKSTEMP_LEN],
		       mkstr(str), DCC_MKSTEMP_LEN);
	}
}



u_char
dcc_log_close(DCC_EMSG *emsg, const char *nm, int fd,
	      const struct timeval *ldate)
{
	DCC_PATH path;
	u_char result;

	result = dcc_set_mtime(emsg, nm, fd, ldate);
	if (0 > close(fd)
	    && result) {
		dcc_pemsg(EX_IOERR, emsg,"close(%s): %s",
			  dcc_fnm2abs_msg(&path, nm), ERROR_STR());
		result = 0;
	}
	return result;
}
