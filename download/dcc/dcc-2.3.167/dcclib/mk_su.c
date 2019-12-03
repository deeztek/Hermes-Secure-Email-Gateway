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
 * Rhyolite Software DCC 2.3.167-1.6 $Revision$
 */

#include "dcc_defs.h"


/* make socket address from an IPv4 address and a port number */
DCC_SOCKU *
dcc_mk_inet_su(DCC_SOCKU *su,		/* put it here */
	       const struct in_addr *addrp, /* 0=INADDR_ANY */
	       in_port_t port)
{
	in_addr_t addr4;

	/* Save the value of the source,
	 * so that the source can be part of the target.
	 * Assume INADDR_ANY=0 */
	addr4 = addrp ? addrp->s_addr : 0;

	memset(su, 0, sizeof(*su));
	su->sa.sa_family = AF_INET;
#ifdef HAVE_SA_LEN
	su->sa.sa_len = sizeof(struct sockaddr_in);
#endif
	su->ipv4.sin_addr.s_addr = addr4;
	su->ipv4.sin_port = port;

	return su;
}



/* make socket address from an IPv6 address, a scope ID, and a port number */
DCC_SOCKU *
dcc_mk_inet6_su(DCC_SOCKU *su,		/* put it here */
		const struct in6_addr *addrp,	/* 0=INADDR_ANY */
#ifndef HAVE_SIN6_SCOPE_ID
		DCC_UNUSED
#endif
		DCC_SCOPE_ID scope_id,
		in_port_t port)
{
	memset(su, 0, sizeof(*su));	/* assume INADDR_ANY=0 */
	su->sa.sa_family = AF_INET6;
#ifdef HAVE_SA_LEN
	su->sa.sa_len = sizeof(struct sockaddr_in6);
#endif
	su->ipv6.sin6_port = port;
	if (addrp)
		su->ipv6.sin6_addr = *addrp;
#ifdef HAVE_SIN6_SCOPE_ID
	su->ipv6.sin6_scope_id = scope_id;
#endif
	return su;
}



/* make socket address from an IP address, a family, and a port number */
DCC_SOCKU *
dcc_mk_su(DCC_SOCKU *su,		/* put it here */
	  sa_family_t family,		/* AF_INET or AF_INET6 */
	  const void *addrp,		/* this IP address; 0=INADDR_ANY */
	  DCC_SCOPE_ID scope_id,
	  in_port_t port)
{
	if (family == AF_INET6)
		return dcc_mk_inet6_su(su, addrp, scope_id, port);
	else
		return dcc_mk_inet_su(su, addrp, port);
}



DCC_SOCKU *
dcc_mk_loop_su(DCC_SOCKU *su,
	       sa_family_t family,
	       in_port_t port)
{
	static DCC_SOCKU ipv4_su, ipv6_su;
	static struct in6_addr in6;

	/* initialize the addresses on first use */
	if (ipv4_su.sa.sa_family != AF_INET) {
		ipv4_su.ipv4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
		dcc_mk_inet_su(&ipv4_su, &ipv4_su.ipv4.sin_addr, 0);
		in6.s6_addr[15] = 1;
		dcc_mk_inet6_su(&ipv6_su, &in6, 0, 0);
	}

	if (family == AF_INET6) {
		*su = ipv6_su;
	} else {
		*su = ipv4_su;
	}
	DCC_SU_PORT(su) = port;

	return su;
}



DCC_SOCKU *
dcc_ip2su(DCC_SOCKU *su,		/* put it here */
	  const DCC_IP *ip)
{
	if (ip->family == AF_INET)
		return dcc_mk_inet_su(su, &ip->u.ipv4, ip->port);
	else
		return dcc_mk_inet6_su(su, &ip->u.ipv6, ip->scope_id, ip->port);
}
