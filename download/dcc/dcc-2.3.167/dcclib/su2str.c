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
 * Rhyolite Software DCC 2.3.167-1.51 $Revision$
 */

#include "dcc_defs.h"
#ifndef DCC_WIN32
#include <arpa/inet.h>
#endif



/* strip IPv6 prefix from ::ffff:10.2.3.4 */
const char *
dcc_trim_ffff(const char *str)
{
	return strncmp("::ffff:", str, 7) ? str : (str+7);
}



const char *
dcc_ipv4tostr(char *buf, int buf_len, const struct in_addr *addr4)
{
	if (addr4->s_addr == INADDR_ANY)
		STRLCPY(buf, DCC_INADDRANY, buf_len);
	else if (!DCC_INET_NTOP(AF_INET, addr4, buf, buf_len))
		STRLCPY(buf, "???", buf_len);
	return buf;
}



const char *
dcc_ipv6tostr(char *buf, int buf_len, const struct in6_addr *addr6)
{
	if (!DCC_INET_NTOP(AF_INET6, addr6, buf, buf_len))
		STRLCPY(buf, "???", buf_len);
	return buf;
}



const char *
dcc_ipv6tostr2(char *buf, int buf_len, const struct in6_addr *addr6)
{
	struct in_addr addr4;

	if (dcc_ipv6toipv4(&addr4, addr6))
		return dcc_ipv4tostr(buf, buf_len, &addr4);

	return dcc_ipv6tostr(buf, buf_len, addr6);
}



const char *
dcc_ip2str(char *buf, int buf_len, const DCC_IP *ip)
{
#if defined(HAVE_SIN6_SCOPE_ID) && defined(DCC_USE_GETADDRINFO)
	DCC_SOCKU su;
#endif

	if (ip->family == AF_INET)
		return dcc_ipv4tostr(buf, buf_len, &ip->u.ipv4);

#if defined(HAVE_SIN6_SCOPE_ID) && defined(DCC_USE_GETADDRINFO)
	/* try to use getnameinfo() to deal with scope_id
	 * ignore it if we do not have getnameinfo() */
	dcc_ip2su(&su, ip);
	if (!getnameinfo(&su.sa, DCC_SU_LEN(&su), buf, buf_len,
			 0, 0, NI_NUMERICHOST))
		return buf;
#endif
	return dcc_ipv6tostr(buf, buf_len, &ip->u.ipv6);
}



/* convert to a string including the port number.
 *	try to make a short IPv4 string */
const char *
dcc_su2str(char *buf, int buf_len, const DCC_SOCKU *su)
{
	int i;

	if (su->sa.sa_family == AF_INET) {
		dcc_ipv4tostr(buf, buf_len, &su->ipv4.sin_addr);
	} else {
#if defined(HAVE_SIN6_SCOPE_ID) && defined(DCC_USE_GETADDRINFO)
		if (getnameinfo(&su->sa, DCC_SU_LEN(su), buf, buf_len,
				0, 0, NI_NUMERICHOST))
#endif
			dcc_ipv6tostr2(buf, buf_len, &su->ipv6.sin6_addr);
	}
	i = strlen(buf);
	snprintf(buf+i, buf_len-i, ",%d", ntohs(DCC_SU_PORT(su)));
	return buf;
}



/* convert to a string without the port number.
 *	try to make a short IPv4 string */
const char *
dcc_su2str2(char *buf, int buf_len, const DCC_SOCKU *su)
{
	if (su->sa.sa_family == AF_INET)
		return dcc_ipv4tostr(buf, buf_len, &su->ipv4.sin_addr);

#if defined(HAVE_SIN6_SCOPE_ID) && defined(DCC_USE_GETADDRINFO)
	if (!getnameinfo(&su->sa, DCC_SU_LEN(su), buf, buf_len,
			 0, 0, NI_NUMERICHOST))
		return buf;
#endif
	return dcc_ipv6tostr2(buf, buf_len, &su->ipv6.sin6_addr);
}



/* convert to a string without a boring port number
 *	try to make a short IPv4 string */
const char *
dcc_su2str3(char *buf, int buf_len, const DCC_SOCKU *su, u_short port)
{
	if (DCC_SU_PORT(su) != port) {
		return dcc_su2str(buf, buf_len, su);
	} else {
		return dcc_su2str2(buf, buf_len, su);
	}
}



/* Convert IP address to a string, but not into a single buffer
 *	This is not thread safe but good enough for error messages */
const char *
dcc_su2str_err(const DCC_SOCKU *su)
{
	static int bufno;
	static struct {
	    char    str[DCC_SU2STR_SIZE];
	} bufs[4];
	char *s;

	s = bufs[bufno].str;
	bufno = (bufno+1) % DIM(bufs);
	return dcc_su2str(s, sizeof(bufs[0].str), su);
}



const char *
dcc_host_portname(char *buf, int buf_len,
		  const char *hostname, const char *portname)
{
	if (!portname || *portname == '\0' || !strcmp(portname, "-")) {
		STRLCPY(buf, hostname, buf_len);
	} else {
		snprintf(buf, buf_len, "%s,%s", hostname, portname);
	}
	return buf;
}



/* Convert IP address to a name */
const char *
dcc_su2name(char *name, int name_len, const DCC_SOCKU *su)
{
#undef EXPANDED
#ifdef DCC_USE_GETADDRINFO
#define EXPANDED
	/* assume getnameinfo() is thread safe */
	if (0 != getnameinfo(&su->sa, DCC_SU_LEN(su),
			     name, name_len, 0, 0, NI_NAMEREQD)
	    && name_len > 0)
		*name = '\0';
#endif
#ifdef DCC_USE_GETIPNODEBYNAME
#define EXPANDED
	struct hostent *hp;
	int error;

	dcc_host_lock();
	if (su->sa.sa_family == AF_INET)
		hp = getipnodebyaddr(&su->ipv4.sin_addr,
				     sizeof(su->ipv4.sin_addr),
				     su->sa.sa_family, &error);
	else
		hp = getipnodebyaddr(&su->ipv6.sin6_addr,
				     sizeof(su->ipv6.sin6_addr),
				     su->sa.sa_family, &error);
	if (!hp) {
		if (name_len > 0)
			*name = '\0';
	} else {
		if (name_len > 0)
			STRLCPY(name, hp->h_name, name_len);
		freehostent(hp);
	}
	dcc_host_unlock();
#endif
#ifdef DCC_USE_GETHOSTBYNAME
#define EXPANDED
	struct hostent *hp;
	DCC_SOCKU su4;

	dcc_host_lock();
	if (dcc_ipv6su2ipv4su(&su4, su)) {
		hp = gethostbyaddr((char *)&su4.ipv4.sin_addr,
				   sizeof(su4.ipv4.sin_addr),
				   AF_INET);
	} else {
		hp = 0;
	}
	if (name_len > 0)
		STRLCPY(name, hp ? hp->h_name : "", name_len);
	dcc_host_unlock();
#endif
#ifndef EXPANDED
#error no DNS service?
#endif
#undef EXPANDED

	return name;
}
