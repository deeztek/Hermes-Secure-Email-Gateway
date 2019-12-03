/* Distributed Checksum Clearinghouses
 *
 * wrapper for fstatfs() or fstatvfs() to get file system type
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
 * Rhyolite Software DCC 2.3.167-1.5 $Revision$
 */


/* help the configure script decide if fstatfs() works */
#ifdef DCC_TEST_FSTATFS
#undef DCC_FSTATFS_COMPAT
#define DCC_FSTATFS_COMPAT DCC_TEST_FSTATFS
#define DCC_UNIX 1
#include "dcc_types.h"

#else
#include "srvr_defs.h"
#endif



#define DCC_FSTATFS_COMPAT_BSD	    1
#define DCC_FSTATFS_COMPAT_Linux    2
#define DCC_FSTATFS_COMPAT_SunOS    3

#undef EXPANDED

#ifndef DCC_FSTATFS_COMPAT
#define EXPANDED 1
u_char
istmpfs(int fd DCC_UNUSED, const char *nm DCC_UNUSED)
{
	return 0;
}
#endif


#if !defined(EXPANDED) && DCC_FSTATFS_COMPAT == DCC_FSTATFS_COMPAT_BSD
#define EXPANDED 1
#include <sys/param.h>
#include <sys/mount.h>

u_char
istmpfs(int fd, const char *nm)
{
	struct statfs buf;

	if (0 > fstatfs(fd, &buf)) {
		dcc_error_msg("fstatfs(%s): %s", nm, ERROR_STR());
		return 0;
	}

	return !strncmp(buf.f_fstypename, "tmpfs", sizeof(buf.f_fstypename));
}
#endif



#if !defined(EXPANDED) && DCC_FSTATFS_COMPAT == DCC_FSTATFS_COMPAT_Linux
#define EXPANDED 1
#include <sys/vfs.h>

u_char
istmpfs(int fd, const char *nm)
{
	struct statfs buf;

	if (0 > fstatfs(fd, &buf)) {
		dcc_error_msg("fstatfs(%s): %s", nm, ERROR_STR());
		return 0;
	}

	return (buf.f_type == 0x01021994);
}
#endif


#if !defined(EXPANDED) && DCC_FSTATFS_COMPAT == DCC_FSTATFS_COMPAT_SunOS
#define EXPANDED 1
#include <sys/mntent.h>
#include <sys/statvfs.h>

u_char
istmpfs(int fd, const char *nm)
{
	struct statvfs buf;

	if (0 > fstatvfs(fd, &buf)) {
		dcc_error_msg("fstatvfs(%s): %s", nm, ERROR_STR());
		return 0;
	}

	return !strncmp(buf.f_basetype, MNTTYPE_TMPFS, sizeof(buf.f_basetype));
}
#endif


#ifndef EXPANDED
#error "bad configure value for DCC_FSTATFS_COMPAT"
#endif
