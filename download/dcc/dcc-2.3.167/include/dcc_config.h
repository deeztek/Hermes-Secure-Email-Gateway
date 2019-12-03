/* Distributed Checksum Clearinghouse
 *
 * configuration settings
			    *	modified for WIN32
			    *	Run ./configure on UNIX-like systems
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
 * Rhyolite Software DCC 2.3.167-1.182 $Revision$
 * @configure_input@
 */

#ifndef DCC_CONFIG_H
#define DCC_CONFIG_H

#define DCC_VERSION "2.3.167"
#undef DCC_CONFIGURE


#undef DCC_UNIX
/* #define DCC_WIN32 1 */		/* define DCC_WIN32 in the makefiles */
#if !defined(DCC_UNIX) && !defined(DCC_WIN32)
#error "you must run ./configure"
#endif

#define	DCC_TARGET_SYS "Win32"


#define DCC_HOMEDIR "c:\\Program Files\\DCC"
#undef DCC_LIBEXECDIR
#undef DCC_RUNDIR

/* use kludge file if asked */
#undef HAVE_KLUDGE_H

#define DCC_LITTLE_ENDIAN 1

/* some systems have uint32_t, others have u_int32_t, and some have both
 * and then there is u_*int64_t */
#define DCC_U_INT8_T unsigned char
#define DCC_U_INT16_T unsigned short
#define DCC_U_INT32_T unsigned int
#define DCC_U_INT64_T unsigned __int64

/* 64-bit long int */
#undef HAVE_64BIT_LONG

/* use %ll for 64-bit values */
#define DCC_USE_LL 1

#undef HAVE_INTTYPES_H

/* 64-bit void* */
#undef HAVE_64BIT_PTR

/* 64-bit time_t */
#undef HAVE_64BIT_TIME_T

/* ./configure does not check for pid_t on the grounds that only WIN32
 * lacks it, and Windows is handled by the genbundle script */
#undef HAVE_PID_T

/* maximum number of DCC server rate-limiting blocks */
#undef DCC_RL_MAX

/* turn off dccifd AF_UNIX sockets on HP-UX */
#undef DCC_HP_UX_BAD_AF_UNIX

/* Use poll() instead of select() because socket() can yield file descripters
 * larger than FD_SETSIZE. */
#undef DCC_USE_POLL

/* number of cached open per-user whitelist files */
#undef DCC_NUM_CWFS

#define DCC_TIME_WITH_SYS_TIME 1
#undef HAVE_UTIME_H
#undef HAVE_FUTIMES

#undef HAVE_SETPGID

#undef HAVE_GCC_ATTRIBUTES
#undef HAVE_GCC_INLINE

/* fill holes in the target */
#undef HAVE_DAEMON
#undef HAVE_VSYSLOG
#undef HAVE_HSTRERROR
#undef HAVE_INET_NTOP
#undef HAVE_INET_PTON
#undef HAVE_INET_ATON
#undef HAVE_GETHOSTID
#undef HAVE_LOCALTIME_R
#undef HAVE_GMTIME_R
#undef HAVE_TIMEGM
#undef HAVE_EACCESS
#undef HAVE_ALTZONE
#undef HAVE_BUILTIN_FFSL
#undef HAVE_FFSL

#undef DCC_NEED_STRINGS_H
#undef HAVE_STRLCPY
#undef HAVE_STRLCAT

/* A way to get the size of physical memory
 *  Linux and Solaris have sysconf(_SC_PHYS_PAGES)
 *  BSD systems have sysctl(HW_PHYSMEM)
 *  HP-UX has pstat_getstatic() */
#undef HAVE_PHYSMEM_TOTAL
#undef HAVE__SC_PHYS_PAGES
#undef HAVE_HW_PHYSMEM
#undef HAVE_PSTAT_GETSTATIC
#undef DCC_HAVE_PHYSMEM
/* use `dbclean -F` on Solaris to force less unneeded disk I/O */
#undef DCC_USE_DBCLEAN_F

/* can assume the hash table is junk after a reboot */
#undef HAVE_BOOTTIME


/* files with 64-bit offsets */
#undef HAVE_BIG_FILES

/* 0 or minimum size of server database buffer or window */
#undef DCC_DB_MIN_MBYTE
/* 0 or maximum size of server database buffer */
#undef DCC_DB_MAX_MBYTE


/* 4.4BSD sockets */
#define HAVE_SOCKLEN_T 1
#undef HAVE_SA_LEN
#undef HAVE_IN_ADDR_T
#undef HAVE_SA_FAMILY_T
#undef HAVE_IN_PORT_T
#undef HAVE_SIN6_SCOPE_ID
#undef HAVE_AF_LOCAL
#undef HAVE_AF_INET6

#undef HAVE_GETADDRINFO
#undef HAVE_GETNAMEINFO
#undef HAVE_FREEADDRINFO
#undef HAVE_GAI_STRERROR

#undef HAVE_GETIPNODEBYNAME
#undef HAVE_GETIPNODEBYADDR
#undef HAVE_FREEHOSTENT

#define DCC_NO_IPV6 1
#undef DCC_CONF_S6_ADDR32

#undef DCC_GETIFADDRS_COMPAT
#undef HAVE_GETIFADDRS
#undef HAVE_FREEIFADDRS

/* BIND resolver library */
#undef HAVE_RESOLV_H
#undef HAVE_ARPA_NAMESER_H
#undef HAVE__RES
#undef HAVE_RES_INIT
#undef HAVE_BAD__RES
#undef HAVE_RES_QUERY
#undef HAVE_DN_EXPAND

/* Solaris and WIN32 do not have paths.h */
#undef HAVE_PATHS_H

/* Some systems have their own MD5 libraries */
#undef HAVE_MD5

#undef HAVE_SIGINTERRUPT

#undef HAVE_PTHREADS
#undef HAVE_PTHREAD_ATTR_SETSTACKSIZE

/* HP_UX has sys/pthread.h instead of pthread.h */
#undef HAVE_PTHREAD_H

/* Windows systems lack UNIX permission bits */
#undef HAVE_PRIVATE_FILES

/* __progname defined by crt0 and so a reasonable default for syslog */
#undef HAVE___PROGNAME
/* slightly more portable way to get the program name */
#undef HAVE_GETPROGNAME

/* very old BSD/OS has only 2 parameters for msync()
 * and newer versions ignore the third parameter */
#undef HAVE_OLD_MSYNC

#undef DCC_FSTATFS_COMPAT

/* use SOCKS */
#undef HAVE_RSENDTO

/* save only this much of mail messages in log files */
#define MAX_LOG_KBYTE 32

#undef HAVE_EDITLINE

/* FUZ2 dictionaries */
#define DCC_LANG_ENGLISH 1
#define DCC_LANG_SPANISH 1
#define DCC_LANG_POLISH 1
#define DCC_LANG_DUTCH 1

#endif /* DCC_CONFIG_H */
