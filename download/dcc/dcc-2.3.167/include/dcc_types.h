/* Distributed Checksum Clearinghouse
 *
 * basic types
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
 * Rhyolite Software DCC 2.3.167-1.8 $Revision$
 */

#ifndef DCC_TYPES_H
#define DCC_TYPES_H

/* work on WIN32 and any reasonable UNIX platform */
#ifdef DCC_UNIX
#include <stdarg.h>
#include <stdio.h>			/* for FreeBSD */
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#if DCC_TIME_WITH_SYS_TIME
# include <sys/time.h>
# include <time.h>
#else
# if HAVE_SYS_TIME_H
#  include <sys/time.h>
# else
#  include <time.h>
# endif
#endif
#ifdef HAVE_UTIME_H
#include <utime.h>
#endif
#undef EX_OK				/* IRIX defines EX_OK in unistd.h */
#include <limits.h>			/* for FreeBSD */
#include <netdb.h>
#include <netinet/in.h>
#include <sys/param.h>			/* for FreeBSD */
#include <sys/socket.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>
#else /* !UNIX or DCC_WIN32 */
#define STRICT
#define WIN32_LEAN_AND_MEAN
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <winerror.h>
#include <limits.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <io.h>

typedef signed int	int32_t;
typedef __int64		int64_t;
#endif /* !UNIX or DCC_WIN32 */


/* Some systems have uint32_t, others have u_int32_t, and some have both
 * So use u_int32_t */
#ifdef DCC_U_INT8_T
#undef u_int8_t
#define u_int8_t DCC_U_INT8_T
#endif
#ifdef DCC_U_INT16_T
#undef u_int16_t
#define u_int16_t DCC_U_INT16_T
#endif
#ifdef DCC_U_INT32_T
#undef u_int32_t
#define u_int32_t DCC_U_INT32_T
#endif
#ifdef DCC_U_INT64_T
#undef u_int64_t
#define u_int64_t DCC_U_INT64_T
#endif


typedef struct {
    char	c[120];
} DCC_EMSG;

/* PATH_MAX is an over generous 1024 on many UNIX varients,
 * but an incredible, ridiculous waste of 4096 on some Linux flavors.
 * Each of the hundreds of dccm and dccifd recipient structures contain
 * 2 paths.  Then there are the 8 paths in .dccw files.  So this matters . */
typedef struct {
	char	c[768];
} DCC_PATH;


#ifdef HAVE_GCC_ATTRIBUTES
#define DCC_UNUSED  __attribute__((unused))
#define DCC_PF(f,l) __attribute__((format (printf,f,l)))
#define DCC_NORET   __attribute__((__noreturn__))
/* override ARM default -mstructure-size-boundary=8 on the wire */
#define DCC_PACKED __attribute__((__packed__))
#else
#define DCC_UNUSED
#define DCC_PF(f,l)
#define DCC_NORET
#define DCC_PACKED
#endif

/* These should be replaced with DCC_UNUSED, DCC_PATTRIB, DCC_NRET.
 *	They still exist because some users of dccif() might be using them */
#ifdef HAVE_GCC_ATTRIBUTES
#define UATTRIB __attribute__((unused))
#define PATTRIB(f,l) __attribute__((format (printf,f,l)))
#define NRATTRIB __attribute((__noreturn__))
#else
#define UATTRIB
#define PATTRIB(f,l)
#define NRATTRIB
#endif

#ifndef HAVE_GCC_INLINE
#define inline
#endif


#endif /* DCC_TYPES_H */
