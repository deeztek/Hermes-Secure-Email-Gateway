/* Distributed Checksum Clearinghouse
 *
 * definitions internal to client libraries and servers
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
 * Rhyolite Software DCC 2.3.167-1.344 $Revision$
 */

#ifndef DCC_DEFS_H
#define DCC_DEFS_H

#if defined(DCC_TEST_FSTATFS) || defined(DCC_TEST_GETIFADDRS)
/* dcc_config.h is not valid until after ./configure has run */
#define DCC_UNIX
#else
#include "dcc_config.h"
#endif
#include "dcc_types.h"
#include "dcc_errlog.h"
#include "dcc_socket.h"
#include "dcc_proto.h"

/* even some UNIX systems have ancient, unusable versions of sysexits.h */
#include "sendmail-sysexits.h"

/* local definitions included via `./configure --with-kludge=FILE` */
#ifdef HAVE_KLUDGE_H
#include "kludge.h"
#endif

#ifdef DCC_NEED_STRINGS_H
#include <strings.h>
#endif

typedef char DCC_PASSWD[32];
#define DCC_PASSWD_PAT "%.32s"

/* deal with ancient UNIX */
#ifndef STDIN_FILENO
#define STDIN_FILENO 0
#endif
#ifndef STDOUT_FILENO
#define STDOUT_FILENO 1
#endif
#ifndef STDERR_FILENO
#define STDERR_FILENO 2
#endif

#ifdef DCC_UNIX
#ifndef MAP_FAILED
#define MAP_FAILED ((void *)-1)
#endif
#ifdef HAVE_OLD_MSYNC
#define MSYNC(addr,len,flags) msync((void *)(addr),(len))
#else
#define MSYNC(addr,len,flags) msync((void *)(addr),(len),(flags))
#endif

#ifndef FD_CLOEXEC
#define FD_CLOEXEC 1
#endif

#define WIN32_SOC_CAST

#define INVALID_SOCKET (-1)
#define SOCKET_ERROR (-1)
#define WSAAPI
#define closesocket close
#define ERROR_STR() ERROR_STR1(errno)
#define ERROR_STR1(e) strerror(e)

#define DELAY_ERROR() (errno == EINTR || errno == EAGAIN)

/* EWOULDBLOCK and EAGAIN differ on HP-UX */
#define DCC_BLOCK_ERROR() (errno == EWOULDBLOCK || errno == EAGAIN)

#else /* !DCC_UNIX or DCC_WIN32 */
extern void dcc_win32_init(void);

#undef errno
#define errno WSAGetLastError()
#define h_errno WSAGetLastError()
#define ERROR_STR() ERROR_STR1(errno)
#define ERROR_STR1(e) ws_strerror(e)
const char *ws_strerror(int);

#define DELAY_ERROR() (errno == WSAEINTR)
#define DCC_BLOCK_ERROR() (errno == WSAEWOULDBLOCK || errno == WSAEINTR)

/* some WIN32 versions lack snprintf() */
#define snprintf dcc_snprintf
extern int dcc_snprintf(char *, int, const char *, ...);
#define vsnprintf dcc_vsnprintf
extern int dcc_vsnprintf(char *, int, const char *, va_list);

extern char *optarg;
extern int optind, opterr, optopt;
extern int getopt(int, char * const [], const char *);

#define strcasecmp stricmp
#define strncasecmp strnicmp
extern int getpid(void);
#define usleep(us) Sleep((us+500)/1000)


#define LOG_ERR	    0
#define LOG_MAIL    0
#define LOG_NOTICE  0
#define LOG_PID	    0

#undef openlog
#define openlog dcc_openlog
extern void dcc_openlog(const char *, int, int);

#undef syslog
#define syslog dcc_syslog
extern void dcc_syslog(int, const char *, ...);

#undef closelog
#define closelog dcc_closelog
extern void dcc_closelog(void);


struct timezone {
    int     tz_minuteswest;		/* minutes west of Greenwich */
    int     tz_dsttime;			/* type of dst correction */
};
#undef gettimeofday
#define gettimeofday dcc_gettimeofday
extern int dcc_gettimeofday(struct timeval *, struct timezone *);


#ifndef HAVE_PID_T
#undef pid_t
#define pid_t int
#endif

/* FlushViewOfFile() on Win98 sometimes returns 0 with GetLastError()==0 */
#define MSYNC(addr,len,flags) (FlushViewOfFile(addr,0), 0)

#define R_OK	04
#define W_OK	02
#ifndef S_ISDIR
#define S_ISDIR(mode) (mode & _S_IFDIR)
#endif

extern u_char dcc_win32_lock(HANDLE, DWORD);
extern u_char dcc_win32_unlock(HANDLE);

extern void dcc_win32_unmap(HANDLE *, void *, const char *);
extern void *dcc_win32_map(DCC_EMSG *, HANDLE *, const char *, int, int);
#endif /* !DCC_UNIX or DCC_WIN32 */



#ifndef HAVE_DAEMON
#define daemon dcc_daemon
#endif
extern int dcc_daemon(int, int);
extern void dcc_daemon_restart(const char *, void(*)(void), u_char);
extern void dcc_daemon_su(const char *);
extern void dcc_pidfile(DCC_PATH *, const char *);

/* AIX is missing some prototypes or has them #ifdef'ed with strange switches */
#ifdef _AIX41
#include <sys/select.h>
typedef unsigned long long int uint64_t;
typedef unsigned int uint32_t;
typedef int int32_t;
typedef unsigned short uint16_t;

extern void openlog(const char *, int, int);
extern int snprintf(char *, int, const char *, ...);
extern int vsnprintf(char *, int, const char *, const char *, ...);
extern int seteuid(uid_t);
extern int flock(int, int);
#define	AF_LOCAL AF_UNIX
#endif /* _AIX41 */

#ifdef __hpux
#define seteuid(euid) setresuid(-1,euid,-1)
#define setegid(egid) setresgid(-1,egid,-1)
#endif /* __hpux */



/* printf patterns for 64-bit values */
#ifdef HAVE_INTTYPES_H
#include <inttypes.h>
#endif
#if defined(PRId64) && defined(PRIx64)
#define LLPATd	    PRId64
#define LLPATx	    PRIx64
#else
#ifdef DCC_USE_LL
#define LLPATd	    "lld"
#define LLPATx	    "llx"
#else
#define LLPATd	    "ld"
#define LLPATx	    "lx"
#endif
#endif
#define	L_HxPAT	    "%#"LLPATx
#define	L_HPAT	    "%"LLPATx
#define	L_HxWPAT(w) "%#"#w LLPATx	/* specified width hex with 0x */
#define	L_HWPAT(w)  "%"#w LLPATx	/* hex without hex without 0x */
#define L_DPAT	    "%"LLPATd
#define L_DWPAT(w)  "%"#w LLPATd	/* decimal with specified width */

/* printf pattern for size_t and off_t */
#ifdef HAVE_BIG_FILES
#define OFF_HPAT    L_HxPAT
#define OFF_DPAT    L_DPAT
#else
#define OFF_HPAT    "%#lx"
#define OFF_DPAT    "%ld"
#endif

#define DIM(_a)	    ((int)(sizeof(_a) / sizeof((_a)[0])))
#define LAST(_a)    (&(_a)[DIM(_a)-1])
/* abbreviation to silence common compiler warnings */
#define ISZ(_s)	    ((int)sizeof(_s))

#ifdef HAVE_STRLCAT
#define STRLCAT(d,s,lim) strlcat(d,s,lim)
#else
#define STRLCAT(d,s,lim) dcc_strlcat(d,s,lim)
#endif
extern size_t dcc_strlcat(char *, const char *, int);

#ifdef HAVE_STRLCPY
#define STRLCPY(d,s,lim) strlcpy(d,s,lim)
#else
#define STRLCPY(d,s,lim) dcc_strlcpy(d,s,lim)
#endif
extern size_t dcc_strlcpy(char *, const char *, int);

#define BUFCPY(d,s) ((void)STRLCPY(d,s,sizeof(d)))

#define LITZ(_s)	(ISZ(_s)-1)
#define CLITCMP(b,_s)	strncasecmp(b, _s, LITZ(_s))
#define LITCMP(b,_s)	strncmp(b, _s, LITZ(_s))


#ifndef HAVE___PROGNAME
#define __progname dcc_progname
#endif

#undef max
#define max(a,b) ((a) > (b) ? (a) : (b))
#undef min
#define min(a,b) ((a) < (b) ? (a) : (b))

/* positive numbers of seconds in files that should not change when the
 * system switches between 64 and 32 bits. */
typedef u_int32_t DCC_PTIME;
#define TIME_T(ptime) ((time_t)(ptime))

/* Is it time or has the local clock been changed?
 *	Is the clock after the target date or earlier than the original date? */
#define DCC_IS_TIME(now,tgt,lim) (TIME_T(now) >= TIME_T(tgt)	\
				  || TIME_T(now)+(lim) < TIME_T(tgt))

/* adjust the bound on a timer, usually to shorten it */
#define DCC_ADJ_TIMER(now,tgt,lim,new_lim) {				\
	if (TIME_T(*(tgt)) > TIME_T(now)+(new_lim))			\
		*(tgt) = (now)+(new_lim);				\
	*(lim) = (new_lim);						\
}

#define DCC_US	(1000*1000)

#define DCC_EPOCH_WEEK	(4*24*60*60)    /* the epoch started on Thursday */

#define FOREVER_SECS	1000
#define FOREVER_US	(FOREVER_SECS*DCC_US)
#define us2tv(tvp,us)	((tvp)->tv_sec = (us) / DCC_US,			\
			 (tvp)->tv_usec = (us) % DCC_US)
extern time_t tv_diff2us(const struct timeval *, const struct timeval *);
extern void tv_add(struct timeval *,
		   const struct timeval *, const struct timeval *);
extern void tv_add_us(struct timeval *, time_t);

/* prefer gmtime_r even where we don't really care */
#ifdef HAVE_GMTIME_R
#define DCC_GMTIME(src,tgt) {time_t _src = (src); gmtime_r(&_src, tgt);}
#else
#define DCC_GMTIME(src,tgt) {time_t _src = (src);			\
	memcpy(tgt, gmtime(&_src), sizeof(struct tm));}
#endif


#define DCC_WHITESPACE " \t\n\r"

/* ctype() is now a slow mess that does not give constant results on all
 * systems */
#define DCC_IS_WHITE(c) ((c) == ' ' || (c) == '\t' || (c) == '\r' || (c)== '\n')
#define DCC_IS_UPPER(c) ((c) >= 'A' && (c) <= 'Z')
#define DCC_IS_LOWER(c) ((c) >= 'a' && (c) <= 'z')
#define DCC_IS_DIGIT(c)	((c) >= '0' && (c) <= '9')
#define DCC_TO_LOWER(c) (DCC_IS_UPPER(c) ? ((c) + ('a'-'A')) : (c))
#define DCC_TO_UPPER(c) (DCC_IS_LOWER(c) ? ((c) - ('a'-'A')) : (c))

extern char *escstr(char *, int, const char *, int);
extern const char *esc_magic(const char *, int);



#define DCC_MAX_HDR_LINE    78		/* by RFC 2822 */
#define DCC_MAX_XHDR_LEN    240		/* largest possible X-DCC header */
typedef struct {
    u_int	start_len;		/* length of start up to ':' */
    u_int	used;			/* bytes of buffer used */
    int		col;			/* current column */
    char	buf[DCC_MAX_XHDR_LEN];
} DCC_HEADER_BUF;

#define DCC_MAP_NM_DEF	    "map"


#ifndef HAVE_PTHREADS
#undef HAVE_HELPERS
#else
#define HAVE_HELPERS 1
#endif


typedef void(*LOG_WRITE_FNC)(void *context, const char *buf, u_int buflen);


extern u_int32_t hash_divisor(u_int32_t, u_char);

extern void dcc_sign(const void *, int, void *, u_int);
extern u_char dcc_ck_signature(const void *, int, const void *, u_int);

extern DCC_PATH dcc_homedir;
extern int dcc_homedir_len;
extern u_char dcc_cdhome(DCC_EMSG *, const char *, u_char);

extern u_char dcc_fnm2rel(DCC_PATH *, const char *, const char *);
extern void dcc_fnm2rel_good(DCC_PATH *, const char *, const char *);
extern u_char dcc_fnm2abs(DCC_PATH *, const char *, const char *);
extern const char *dcc_fnm2abs_msg(DCC_PATH *, const char *);
extern const char *dcc_path2fnm(const char *);
#define DCC_FNM_LNO_PAT " in line %d of %s"
typedef struct {
	char b[sizeof(DCC_PATH)+sizeof(DCC_FNM_LNO_PAT)+8];
} DCC_FNM_LNO_BUF;
extern const char *dcc_fnm_lno(DCC_FNM_LNO_BUF *, const char *, int);

extern uid_t dcc_real_uid, dcc_effective_uid;
extern gid_t dcc_real_gid, dcc_effective_gid;
extern void dcc_get_priv(void);
extern u_char dcc_get_priv_home(const char *);
extern void dcc_rel_priv(void);
extern void dcc_init_priv(void);
extern u_char dcc_ck_private(DCC_EMSG *, struct stat *, const char *, int);
extern int dcc_lock_open(DCC_EMSG *, const char *, int, u_char, int, u_char *);
# define DCC_LOCK_OPEN_NOWAIT	0x1	/* don't wait to get lock */
# define DCC_LOCK_OPEN_NOLOCK	0x2	/* already locked */
# define DCC_LOCK_OPEN_SHARE	0x4
#define DCC_LOCK_ALL_FILE   (-1)
extern u_char dcc_unlock_fd(DCC_EMSG *, int, int, const char *, const char *);
extern u_char dcc_exlock_fd(DCC_EMSG *, int, int, int,
			    const char *, const char *);
extern u_char dcc_set_mtime(DCC_EMSG *, const char *, int,
			    const struct timeval *);

extern DCC_PATH dcc_main_logdir;
extern void tmp_path_init(const char *, const char *);
#define	DCC_TMP_LOG_PREFIX "/tmp."	/* must be the same length */
#define	DCC_FIN_LOG_PREFIX "/msg."
#define DCC_MKSTEMP_LEN 6		/* characters added by dcc_mkstemp() */
#define DCC_MKSTEMP_LEN_STR "6"
extern int dcc_mkstemp(DCC_EMSG *, DCC_PATH *, char *, int,
		       const char *, const char *, const char *, u_char, int);
extern u_char dcc_main_logdir_init(DCC_EMSG *, const char *);
typedef enum {				/* type of log subdirector */
    LOG_MODE_FLAT,			/*	logdir/ */
    LOG_MODE_DAY,			/*	logdir/ddd/ */
    LOG_MODE_HOUR,			/*	logdir/ddd/hh/ */
    LOG_MODE_MINUTE			/*	logdir/ddd/hh/mm/ */
} LOG_MODE;
extern int dcc_log_open(DCC_EMSG *, DCC_PATH *, char *, int,
			const char *, const char *, const char *, LOG_MODE);
extern int dcc_main_log_open(DCC_EMSG *, DCC_PATH *log_path, char *, int);
extern u_char dcc_log_keep(DCC_EMSG *, DCC_PATH *cur_path);
extern u_char dcc_log_close(DCC_EMSG *, const char *, int,
			    const struct timeval *);
typedef struct {
    int	    len;
    char    buf[500];
} EARLY_LOG;
extern int vearly_log(EARLY_LOG *, const char *, va_list);
extern const char *optopt2str(int);
extern char *hdr2str(char *, u_int, const DCC_HDR *, u_int);


extern const struct tm *dcc_localtime(time_t, struct tm *);
#ifndef HAVE_LOCALTIME_R
extern void dcc_localtime_lock(void);
extern void dcc_localtime_unlock(void);
#endif
const char *dcc_time2str(char *, size_t, const char *, time_t);
#ifdef HAVE_TIMEGM
#define DCC_TIMEGM(tm) timegm(tm)
#else
#ifdef HAVE_ALTZONE
#define DCC_TIMEGM(tm) ((tm)->tm_isdst=-1, mktime(tm) - altzone)
#else
#define DCC_TIMEGM(tm) ((tm)->tm_isdst=-1, mktime(tm))
#endif
#endif

extern int dcc_get_secs(const char *, const char **, int, int, int);
#define DCC_MAX_SECS 0x7fffffff

extern DCC_CLNT_ID dcc_get_id(DCC_EMSG *, const char *, const char *, int);
extern const char *dcc_get_srvr_id(DCC_EMSG *, DCC_SRVR_ID *,
				   const char *, const char *,
				   const char *, int);

extern const char *dcc_parse_word(DCC_EMSG *, char *, int,
				  const char *, const char *,
				  const char *, int);

extern const char *parse_passwd(DCC_EMSG *, DCC_PASSWD, const char *,
				const char *, const char *, int);
extern u_char ck_word_comma(const char **, const char *);

extern void dcc_clean_stdio(void);

u_int get_reputation(DCC_TGTS, DCC_TGTS);
extern const char *id2str(char *, u_int, DCC_CLNT_ID);
extern char *ck2str(char *, u_int, DCC_CK_TYPES, const DCC_SUM *, u_int32_t);
#define CK2STR_LEN (sizeof(DCC_SUM)*2+sizeof(DCC_SUM)/4+1)
extern const char *ck2str_err(DCC_CK_TYPES, const DCC_SUM *, u_int32_t);
extern char *tgts2str(char *, u_int, DCC_TGTS, u_char);
extern char *thold2str(char *, u_int, DCC_CK_TYPES, DCC_TGTS);
extern char *type2str(char *, u_int, DCC_CK_TYPES, const char *, u_char, u_char);
extern const char *type2str_err(DCC_CK_TYPES, const char *, u_char, u_char);
#define SET_ALL_THOLDS	(DCC_CK_TYPE_LAST+1)
#define SET_CMN_THOLDS	(SET_ALL_THOLDS+1)
extern DCC_CK_TYPES dcc_str2type_del(const char *, int);
extern DCC_CK_TYPES dcc_str2type_db(const char *, int);
extern DCC_CK_TYPES dcc_str2type_thold(const char *, int);
extern DCC_CK_TYPES dcc_str2type_wf(const char *, int);
extern DCC_TGTS dcc_str2cnt(const char *);

extern const char *dcc_aop2str(char *, int, DCC_AOPS, u_int32_t);
extern const char *dcc_hdr_op2str(char *, int, const DCC_HDR *);
#define DCC_OPBUF 32

#endif /* DCC_DEFS_H */
