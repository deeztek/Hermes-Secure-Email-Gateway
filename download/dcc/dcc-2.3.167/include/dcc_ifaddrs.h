/* Distributed Checksum Clearinghouse
 *
 * kludge replacement for getifaddrs(3) for systems that lack it
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
 * Rhyolite Software DCC 2.3.167-1.15 $Revision$
 */


#ifndef DCC_IFADDRS_H
#define DCC_IFADDRS_H

/* let the configure script decide which replacement works */
#ifdef DCC_TEST_GETIFADDRS
#undef DCC_GETIFADDRS_COMPAT
#define DCC_GETIFADDRS_COMPAT DCC_TEST_GETIFADDRS
#endif

#define DCC_GETIFADDRS_COMPAT_NONE	0
#define DCC_GETIFADDRS_COMPAT_NATIVE	1
#define DCC_GETIFADDRS_COMPAT_SunOS	2
#define DCC_GETIFADDRS_COMPAT_OTHER	3


#ifdef DCC_GETIFADDRS_COMPAT

#if DCC_GETIFADDRS_COMPAT == DCC_GETIFADDRS_COMPAT_NATIVE

/* use the native getifaddrs() */
#include <ifaddrs.h>
#include <net/if.h>
#endif


#if DCC_GETIFADDRS_COMPAT == DCC_GETIFADDRS_COMPAT_SunOS
/* Solaris compatibility */

/*
 * Copyright (c) 2006 WIDE Project. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the project nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PROJECT AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE PROJECT OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#include <net/if.h>
#include "dcc_heap_debug.h"

#undef ifa_broadaddr
#undef ifa_dstaddr
struct ifaddrs {
	struct ifaddrs	*ifa_next;	/* Pointer to next struct */
	char		*ifa_name;	/* Interface name */
	uint64_t	ifa_flags;	/* Interface flags */
	struct sockaddr	*ifa_addr;	/* Interface address */
	struct sockaddr	*ifa_netmask;	/* Interface netmask */
	struct sockaddr	*ifa_dstaddr;	/* P2P interface destination */
};
#define ifa_broadaddr   ifa_dstaddr

#define getifaddrs(pif) dcc_getifaddrs(pif)
extern int getifaddrs(struct ifaddrs **);
#define freeifaddrs(p) dcc_free(p)

#endif /* DCC_GETIFADDRS_COMPAT == DCC_GETIFADDRS_COMPAT_SunOS */

#endif /* defined(DCC_GETIFADDRS_COMPAT) */



#if DCC_GETIFADDRS_COMPAT == DCC_GETIFADDRS_COMPAT_OTHER

/* use the DCC getifaddrs() */

#include <net/if.h>
#include "dcc_heap_debug.h"

struct ifaddrs {
    struct ifaddrs  *ifa_next;
    char	    *ifa_name;
    u_int	    ifa_flags;
    struct sockaddr *ifa_addr;
};

#define getifaddrs(pif) dcc_getifaddrs(pif)
extern int getifaddrs(struct ifaddrs **);
#define freeifaddrs(p) dcc_free(p)

#endif /* DCC_GETIFADDRS_COMPAT == DCC_GETIFADDRS_COMPAT_OTHER */

#endif /* DCC_GETIFADDRS_H */
