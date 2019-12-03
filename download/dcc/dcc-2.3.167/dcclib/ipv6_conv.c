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
 * Rhyolite Software DCC 2.3.167-1.28 $Revision$
 */

#include "dcc_defs.h"


/* convert IPv4 address to IPv6 */
void
dcc_ipv4toipv6(struct in6_addr *dst, const struct in_addr src)
{
	/* do it in an order that allows dst==src */
	dst->s6_addr32[3] = src.s_addr;
	dst->s6_addr32[2] = htonl(0xffff);
	dst->s6_addr32[1] = 0;
	dst->s6_addr32[0] = 0;
}



/* try to convert IPv6 address to IPv4 address */
u_char					/* 1=did it */
dcc_ipv6toipv4(struct in_addr *dst, const struct in6_addr *src)
{
	if (!DCC_ADDR6_V4MAPPED(src))
		return 0;
	dst->s_addr = src->s6_addr32[3];
	return 1;
}



void
dcc_su2ip(DCC_IP *ip, const DCC_SOCKU *su)
{
	memset(ip, 0, sizeof(*ip));
	if ((ip->family = su->sa.sa_family) == AF_UNSPEC)
		return;
	ip->port = DCC_SU_PORT(su);
	if (su->sa.sa_family == AF_INET) {
		ip->u.ipv4 = su->ipv4.sin_addr;
	} else {
		ip->u.ipv6 = su->ipv6.sin6_addr;
#ifdef HAVE_SIN6_SCOPE_ID
		ip->scope_id = su->ipv6.sin6_scope_id;
#endif
	}
}



/* try to convert IPv6 DCC_SOCKU to IPv4 DCC_SOCKU */
u_char					/* 1=did it */
dcc_ipv6su2ipv4su(DCC_SOCKU *dst, const DCC_SOCKU *src)
{
	struct in_addr addr4;

	if (src->sa.sa_family != AF_INET6) {
		if (src != dst)
			*dst = *src;
		return (src->sa.sa_family == AF_INET);
	}

	if (!dcc_ipv6toipv4(&addr4, &src->ipv6.sin6_addr)) {
		if (src != dst)
			*dst = *src;
		return 0;
	}

	dcc_mk_inet_su(dst, &addr4, DCC_SU_PORT(src));
	return 1;
}



const struct in6_addr *
dcc_su2ipv6(struct in6_addr *buf, u_char set_buf, const DCC_SOCKU *su)
{
	if (su->sa.sa_family == AF_INET6) {
		if (!set_buf)
			return &su->ipv6.sin6_addr;
		*buf = su->ipv6.sin6_addr;
		return buf;
	}

	dcc_ipv4toipv6(buf, su->ipv4.sin_addr);
	return buf;
}



/* try to convert IPv4 DCC_SOCKU to IPv6 DCC_SOCKU
 *	This function is mentioned in dccifd/dccif-test/dccif-test.c
 *	and so cannot change lightly. */
u_char					/* 1=did it */
dcc_ipv4su2ipv6su(DCC_SOCKU *dst, const DCC_SOCKU *src)
{
	struct in6_addr addr6;

	if (src->sa.sa_family != AF_INET) {
		if (src != dst)
			*dst = *src;
		return (src->sa.sa_family == AF_INET6);
	}

	dcc_ipv4toipv6(&addr6, src->ipv4.sin_addr);

	dcc_mk_inet6_su(dst, &addr6, 0, DCC_SU_PORT(src));
	return 1;
}
