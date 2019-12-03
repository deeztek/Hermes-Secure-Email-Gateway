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
 * Rhyolite Software DCC 2.3.167-1.28 $Revision$
 */


#include "dcc_defs.h"
#include "dcc_ifaddrs.h"


#undef EXPANDED

#if DCC_GETIFADDRS_COMPAT == DCC_GETIFADDRS_COMPAT_NATIVE || DCC_GETIFADDRS_COMPAT == DCC_GETIFADDRS_COMPAT_NONE
#define EXPANDED

/* Compile something to avoid warnings about empty files.
 * Make it global to suppress "defined but not used" warning. */
char dcc_getifaddrs_unneeded[] = "dcc_getifaddrs() unneeded";

#endif



#if DCC_GETIFADDRS_COMPAT == DCC_GETIFADDRS_COMPAT_SunOS
#define EXPANDED

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

/* this code includes several fixes--vjs */

#include <sys/sockio.h>
#include <net/if.h>


static int
get_lifreq(int fd, struct lifreq **ifr_ret)
{
	struct lifnum lifn;
	struct lifconf lifc;
	struct lifreq *lifrp;

	lifn.lifn_family = AF_UNSPEC;
	lifn.lifn_flags = 0;
	if (ioctl(fd, SIOCGLIFNUM, &lifn) == -1)
		lifn.lifn_count = 16;
	else
		lifn.lifn_count += 16;

	for (;;) {
		lifc.lifc_len = lifn.lifn_count * sizeof (*lifrp);
		lifrp = dcc_malloc(lifc.lifc_len);
		if (!lifrp)
			return (-1);

		lifc.lifc_family = AF_UNSPEC;
		lifc.lifc_flags = 0;
		lifc.lifc_buf = (char *)lifrp;
		if (ioctl(fd, SIOCGLIFCONF, &lifc) == -1) {
			dcc_free(lifrp);
			if (errno == EINVAL) {
				lifn.lifn_count <<= 1;
				continue;
			}
			return (-1);
		}
		if (lifc.lifc_len < (lifn.lifn_count - 1) * ISZ(*lifrp))
			break;
		dcc_free(lifrp);
		lifn.lifn_count <<= 1;
	}

	*ifr_ret = lifrp;

	return (lifc.lifc_len / sizeof (*lifrp));
}

static size_t
nbytes(const struct lifreq *lifrp, int nlif, size_t socklen)
{
	size_t len = 0;
	size_t slen;

	while (nlif > 0) {
		slen = strlen(lifrp->lifr_name) + 1;
		len += sizeof (struct ifaddrs) + ((slen + 3) & ~3);
		len += 3 * socklen;
		lifrp++;
		nlif--;
	}
	return (len);
}

static struct sockaddr *
addrcpy(struct sockaddr_storage *addr, char **bufp)
{
	char *buf = *bufp;
	size_t len;

	len = addr->ss_family == AF_INET ? sizeof (struct sockaddr_in) :
	    sizeof (struct sockaddr_in6);
	(void) memcpy(buf, addr, len);
	*bufp = buf + len;
	return ((struct sockaddr *)buf);
}

static void
populate(struct ifaddrs *ifa, int fd, struct lifreq *lifrp, int nlif,
    char **bufp)
{
	char *buf = *bufp;
	size_t slen;

	while (nlif > 0) {
		ifa->ifa_next = (nlif > 1) ? ifa + 1 : 0;
		(void) strcpy(ifa->ifa_name = buf, lifrp->lifr_name);
		slen = strlen(lifrp->lifr_name) + 1;
		buf += (slen + 3) & ~3;
		if (ioctl(fd, SIOCGLIFFLAGS, lifrp) == -1)
			ifa->ifa_flags = 0;
		else
			ifa->ifa_flags = lifrp->lifr_flags;
		if (ioctl(fd, SIOCGLIFADDR, lifrp) == -1)
			ifa->ifa_addr = 0;
		else
			ifa->ifa_addr = addrcpy(&lifrp->lifr_addr, &buf);
		if (ioctl(fd, SIOCGLIFNETMASK, lifrp) == -1)
			ifa->ifa_netmask = 0;
		else
			ifa->ifa_netmask = addrcpy(&lifrp->lifr_addr, &buf);
		if (ifa->ifa_flags & IFF_POINTOPOINT) {
			if (ioctl(fd, SIOCGLIFDSTADDR, lifrp) == -1)
				ifa->ifa_dstaddr = 0;
			else
				ifa->ifa_dstaddr =
				    addrcpy(&lifrp->lifr_dstaddr, &buf);
		} else if (ifa->ifa_flags & IFF_BROADCAST) {
			if (ioctl(fd, SIOCGLIFBRDADDR, lifrp) == -1)
				ifa->ifa_broadaddr = 0;
			else
				ifa->ifa_broadaddr =
				    addrcpy(&lifrp->lifr_broadaddr, &buf);
		} else {
			ifa->ifa_dstaddr = 0;
		}

		ifa++;
		nlif--;
		lifrp++;
	}
	*bufp = buf;
}

int
dcc_getifaddrs(struct ifaddrs **ifap)
{
	int fd4, fd6;
	int nif4, nif6 = 0;
	struct lifreq *ifr4 = 0;
	struct lifreq *ifr6 = 0;
	struct ifaddrs *ifa = 0;
	char *buf;

	if ((fd4 = socket(AF_INET, SOCK_DGRAM, 0)) == -1)
		return (-1);
	if ((fd6 = socket(AF_INET6, SOCK_DGRAM, 0)) == -1
	    && errno != EAFNOSUPPORT) {
		close(fd4);
		return (-1);
	}

	if ((nif4 = get_lifreq(fd4, &ifr4)) == -1 ||
	    (fd6 >= 0 && (nif6 = get_lifreq(fd6, &ifr6)) == -1))
		goto failure;

	if (nif4 == 0 && nif6 == 0) {
		close(fd4);
		if (fd6 >= 0)
			close(fd6);
		*ifap = 0;
		return (0);
	}

	ifa = dcc_malloc(nbytes(ifr4, nif4, sizeof (struct sockaddr_in)) +
	    nbytes(ifr6, nif6, sizeof (struct sockaddr_in6)));
	if (!ifa)
		goto failure;

	buf = (char *)(ifa + nif4 + nif6);

	populate(ifa, fd4, ifr4, nif4, &buf);
	if (nif4 > 0 && nif6 > 0)
		ifa[nif4 - 1].ifa_next = ifa + nif4;
	if (fd6 > 0)
		populate(ifa + nif4, fd6, ifr6, nif6, &buf);

	close(fd4);
	if (fd6 >= 0)
		close(fd6);
	if (ifr4)
		dcc_free(ifr4);
	if (ifr6)
		dcc_free(ifr6);
	*ifap = ifa;
	return (0);

failure:
	dcc_free(ifa);
	close(fd4);
	if (fd6 >= 0)
		close(fd6);
	if (ifr4)
		dcc_free(ifr4);
	if (ifr6)
		dcc_free(ifr6);
	*ifap = 0;
	return (-1);
}

#endif /* DCC_GETIFADDRS_COMPAT == DCC_GETIFADDRS_COMPAT_SunOS */



#if DCC_GETIFADDRS_COMPAT == DCC_GETIFADDRS_COMPAT_OTHER
/* Odd systems and strange versions of Solaris */
#define EXPANDED

#define BSD_COMP			/* for strange SunOS */
#define _IO_TERMIOS_H			/* OpenUNIX */
#include <sys/ioctl.h>

struct ifaddrs_all {
    struct ifaddrs  ifa;
    DCC_SOCKU	    addr;
    char	    name[IFNAMSIZ];
};

int
dcc_getifaddrs(struct ifaddrs **pif)
{
	struct ifconf ifc;
	int buf_size;
	char *buf;
	struct ifreq *ifrp, *ifrp_next, ifr_f;
	struct ifaddrs_all *result0, *result, *rp;
	int i, serrno, s;

	if ((s = socket(AF_INET, SOCK_STREAM, 0)) < 0)
		return -1;

	/* get the list of interface names and addresses */
	buf_size = 1024;
	for (;;) {
		buf = dcc_malloc(buf_size);
		if (!buf) {
			serrno = errno;
			close(s);
			errno = serrno;
			return -1;
		}
		ifc.ifc_buf = buf;
		ifc.ifc_len = buf_size;
		memset(buf, 0, buf_size);
		if (0 > ioctl(s, SIOCGIFCONF, (char *)&ifc)
		    && errno != EINVAL) {
			serrno = errno;
			close(s);
			errno = serrno;
			*pif = 0;
			return -1;
		}
		if (ifc.ifc_len < buf_size && ifc.ifc_len != 0)
			break;

		/* double the size of our temporary buffer and try again
		 * if the list of interfaces did not fit */
		dcc_free(buf);
		buf_size *= 2;
	}

	/* start to build the list of interfaces */
	i = (ifc.ifc_len/sizeof(struct ifreq)) * sizeof(*result);
	result = (struct ifaddrs_all *)dcc_malloc(i);
	if (!result) {
		serrno = errno;
		dcc_free(buf);
		close(s);
		errno = serrno;
		*pif = 0;
		return -1;
	}
	memset(result, 0, i);
	result0 = result;
	*pif = &result->ifa;

	for (ifrp = ifc.ifc_req;
	     (void *)ifrp < (void *)&ifc.ifc_buf[ifc.ifc_len];
	     ifrp = ifrp_next) {
#ifdef HAVE_SA_LEN
		i = ifrp->ifr_addr.sa_len + sizeof(ifrp->ifr_name);
		if (i < ISZ(*ifrp))
			ifrp_next = ifrp + 1;
		else
			ifrp_next = (struct ifreq *)((char *)ifrp + i);
#else
		ifrp_next = ifrp + 1;
#endif

		if (ifrp->ifr_addr.sa_family != AF_INET
#ifdef AF_INET6
		&& ifrp->ifr_addr.sa_family != AF_INET6
#endif
		    )
			continue;

		memset(&ifr_f, 0, sizeof(ifr_f));
		STRLCPY(ifr_f.ifr_name, ifrp->ifr_name, sizeof(ifr_f.ifr_name));
		if (0 > ioctl(s, SIOCGIFFLAGS, (char *)&ifr_f)) {
			if (errno == ENXIO)
				continue;
			serrno = errno;
			close(s);
			dcc_free(buf);
			dcc_free(*pif);
			*pif = 0;
			errno = serrno;
			return -1;
		}

		memset(result, 0, sizeof(*result));

		/* save the name only for debugging */
		STRLCPY(result->name, ifrp->ifr_name, sizeof(result->name));
		result->ifa.ifa_name = result->name;

#ifdef HAVE_SA_LEN
		memcpy(&result->addr.sa, &ifrp->ifr_addr,
		       ifrp->ifr_addr.sa_len);
#else
		result->addr.sa = ifrp->ifr_addr;
#endif
		result->ifa.ifa_addr = &result->addr.sa;
		result->ifa.ifa_flags = ifr_f.ifr_flags;
		result->ifa.ifa_next = &(result+1)->ifa;

		/* skip duplicate addresses */
		rp = result0;
		for (;;) {
			if (rp >= result) {
				++result;
				break;
			}
			if (DCC_SUnP_EQ(&rp->addr, &result->addr))
				break;
			++rp;
		}
	}

	if (&result->ifa == *pif) {
		*pif = 0;
	} else {
		(result-1)->ifa.ifa_next = 0;
	}
	dcc_free(buf);
	close(s);

	return 0;
}
#endif /* DCC_GETIFADDRS_COMPAT == DCC_GETIFADDRS_COMPAT_OTHER */


#ifndef EXPANDED
#error "bad configure value for DCC_GETIFADDRS_COMPAT"
#endif
