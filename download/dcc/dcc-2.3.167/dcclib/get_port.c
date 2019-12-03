/* Distributed Checksum Clearinghouse
 *
 * convert a service name to a port number
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
 * Rhyolite Software DCC 2.3.167-1.95 $Revision$
 */

#include "dcc_clnt.h"
#ifndef DCC_WIN32
#include <arpa/inet.h>			/* for AIX */
#endif


/* these are protected by dcc_host_lock() and dcc_host_unlock() */
DCC_SOCKU dcc_hostaddrs[DCC_MAX_HOSTADDRS];
char dcc_host_canonname[DCC_MAXDOMAINLEN];
DCC_SOCKU *dcc_hostaddrs_end;



/* is this a loopback address */
u_char
dcc_su_is_loopback(const DCC_SOCKU *su)
{
	if (su->sa.sa_family == AF_INET)
		return su->ipv4.sin_addr.s_addr == htonl(INADDR_LOOPBACK);

	if (su->ipv6.sin6_addr.s6_addr32[0] != 0
	    || su->ipv6.sin6_addr.s6_addr32[1] != 0)
		return 0;

	if (su->ipv6.sin6_addr.s6_addr32[2] == 0)
		return su->ipv6.sin6_addr.s6_addr32[3] == htonl(1);

	return (su->ipv6.sin6_addr.s6_addr32[2] == htonl(0xffff)
		&& su->ipv6.sin6_addr.s6_addr32[3] == htonl(INADDR_LOOPBACK));
}



/* get port number
 *	uses dcc_host_lock() and dcc_host_unlock() */
u_int					/* DCC_GET_PORT_INVALID or port # */
dcc_get_port(DCC_EMSG *emsg,
	     const char *portname,
	     u_int def_port,		/* DCC_GET_PORT_INVALID or default */
	     const char *fnm, int lno)	/* source file name and line number */
{
	DCC_FNM_LNO_BUF fnm_buf;
	char *p;
	unsigned long l;
	struct servent *sp;
	u_int16_t port;


	if (portname[0] == '\0'
	    || !strcmp(portname, "-")) {
		if (def_port != DCC_GET_PORT_INVALID)
			return def_port;
		dcc_pemsg(EX_USAGE, emsg, "missing port%s",
			  dcc_fnm_lno(&fnm_buf, fnm, lno));
		return DCC_GET_PORT_INVALID;
	}

	/* first try a numeric port number, since that is common and
	 * the getservby* functions are so slow. */
	l = strtoul(portname, &p,0);
	if (*p == '\0' && l > 0 && l <= 65535)
		return htons((u_int16_t)l);

	dcc_host_lock();
	sp = getservbyname(portname, 0);
	if (sp) {
		port = sp->s_port;
		dcc_host_unlock();
		return port;
	}
	dcc_host_unlock();

	dcc_pemsg(EX_USAGE, emsg, "invalid port \"%s\"%s",
		  portname, dcc_fnm_lno(&fnm_buf, fnm, lno));
	return DCC_GET_PORT_INVALID;
}



static u_char				/* 0=table full */
add_hostaddrs(const DCC_SOCKU *new_sup)
{
	DCC_SOCKU *sup;

	/* add non-duplicates */
	sup = dcc_hostaddrs;
	for (;;) {
		if (sup == dcc_hostaddrs_end) {
			*sup = *new_sup;
			dcc_hostaddrs_end = ++sup;
			return dcc_hostaddrs_end <= LAST(dcc_hostaddrs);
		}
		if (DCC_SUnP_EQ(sup, new_sup))
			return dcc_hostaddrs_end <= LAST(dcc_hostaddrs);
		if (++sup > LAST(dcc_hostaddrs))
			return 0;
	}
}



/* add either or both loopback addresses for the special non-name "@" */
static void
add_loopback(DCC_GETH use_ipv46)
{
	DCC_SOCKU su;

	if (use_ipv46 == DCC_GETH_V4) {
		add_hostaddrs(dcc_mk_loop_su(&su, AF_INET, 0));
	} else if (use_ipv46 == DCC_GETH_V6) {
		add_hostaddrs(dcc_mk_loop_su(&su, AF_INET6, 0));
	} else if (use_ipv46 == DCC_GETH_V64) {
		add_hostaddrs(dcc_mk_loop_su(&su, AF_INET6, 0));
		add_hostaddrs(dcc_mk_loop_su(&su, AF_INET, 0));
	} else {
		add_hostaddrs(dcc_mk_loop_su(&su, AF_INET, 0));
		add_hostaddrs(dcc_mk_loop_su(&su, AF_INET6, 0));
	}
}



/* add either or both INADDR_ANY addresses for the special non-name "*" */
static void
add_inaddr_any(DCC_GETH use_ipv46)
{
	DCC_SOCKU su;

	if (use_ipv46 == DCC_GETH_V4) {
		add_hostaddrs(dcc_mk_inet_su(&su, 0, 0));
	} else if (use_ipv46 == DCC_GETH_V6) {
		add_hostaddrs(dcc_mk_inet6_su(&su, 0, 0, 0));
	} else if (use_ipv46 == DCC_GETH_V64) {
		add_hostaddrs(dcc_mk_inet6_su(&su, 0, 0, 0));
		add_hostaddrs(dcc_mk_inet_su(&su, 0, 0));
	} else {
		add_hostaddrs(dcc_mk_inet_su(&su, 0, 0));
		add_hostaddrs(dcc_mk_inet6_su(&su, 0, 0, 0));
	}
}



static void
copy_hp_to_hostaddrs(const struct hostent *hp,
		     sa_family_t family, DCC_GETH use_ipv46)
{
	DCC_SOCKU su;
	int i;
	const void *v;

	if (hp->h_name && dcc_host_canonname[0] == '\0')
		BUFCPY(dcc_host_canonname, hp->h_name);

	for (i = 0; (v = hp->h_addr_list[i]) != 0; ++i) {
		/* getipnodebyname() does not handle scope IDs on
		 * at least some platforms */
		dcc_mk_su(&su, family, v, 0, 0);

		if ((family == AF_INET && use_ipv46 == DCC_GETH_V6)
		    || (family == AF_INET6 && use_ipv46 == DCC_GETH_V4))
			continue;

		if (DCC_SU_IS_ANY(&su))
			continue;

		if (!add_hostaddrs(&su))
			break;
	}
}



#ifdef DCC_USE_GETADDRINFO
static void
copy_ai_to_hostaddrs(const struct addrinfo *ai, DCC_GETH use_ipv46)
{
	DCC_SOCKU su;
	const struct sockaddr_in *ipv4;
	const struct sockaddr_in6 *ipv6;

	if (ai->ai_canonname && dcc_host_canonname[0] == '\0')
		BUFCPY(dcc_host_canonname, ai->ai_canonname);

	do {
		if (ai->ai_family == AF_INET) {
			ipv4 = (struct sockaddr_in *)ai->ai_addr;
			dcc_mk_inet_su(&su, &ipv4->sin_addr, 0);
		} else {
			ipv6 = (struct sockaddr_in6 *)ai->ai_addr;
			dcc_mk_inet6_su(&su, &ipv6->sin6_addr,
#ifdef HAVE_SIN6_SCOPE_ID
					ipv6->sin6_scope_id,
#else
					0,
#endif
					0);
		}

		if ((ai->ai_family == AF_INET && use_ipv46 == DCC_GETH_V6)
		    || (ai->ai_family != AF_INET && use_ipv46 == DCC_GETH_V4))
			continue;

		if (DCC_SU_IS_ANY(&su))
			continue;

		if (!add_hostaddrs(&su))
			break;
	} while ((ai = ai->ai_next) != 0);
}
#endif /* DCC_USE_GETADDRINFO */



/* Convert a host name to an IPv4 address by calling
 *	Rgethostbyname() or gethostbyname()
 * This must be protected with dcc_host_lock() and dcc_host_unlock(). */
static u_char
get_host_ipv4(const char *nm,		/* look for this name */
	      int *ep,			/* put errno or herrno here */
	      struct hostent *(WSAAPI fnc)(const char *))
{
	const struct hostent *hp;
	struct in_addr ipv4;
	DCC_SOCKU su;

	if (!dcc_host_locked)
		dcc_logbad(EX_SOFTWARE, "dcc_get_host() not locked");

	/* First see if it is a number to avoid the MicroStupid stall
	 * by gethostbyname() on an address literal */
	ipv4.s_addr = inet_addr(nm);
	if (ipv4.s_addr != INADDR_NONE && ipv4.s_addr != INADDR_ANY) {
		if (dcc_host_canonname[0] == '\0')
			BUFCPY(dcc_host_canonname, nm);
		add_hostaddrs(dcc_mk_inet_su(&su, &ipv4, 0));

	} else {
		hp = fnc(nm);
		if (!hp) {
			*ep = h_errno;
			return 0;
		}
		copy_hp_to_hostaddrs(hp, AF_INET, 0);
	}

	if (dcc_hostaddrs_end == &dcc_hostaddrs[0]) {
		if (*ep == 0)
			*ep = NO_DATA;
		return 0;
	}
	return 1;
}



static u_char				/* 0=failed */
dcc_get_host_sub(const char *nm,	/* look for this name */
		 DCC_GETH use_ipv46,
		 int *ep)		/* put errno or herrno here */
{
#undef EXPANDED
#ifdef DCC_USE_GETADDRINFO
#define EXPANDED
	struct addrinfo hints;
	struct addrinfo *ai;
	int new_error, error;

	error = 0;

	memset(&hints, 0, sizeof(hints));
	hints.ai_flags = AI_CANONNAME;

	/* the FreeBSD version stutters trying to provide both UDP and
	 * TCP if you do not choose */
	hints.ai_protocol = IPPROTO_TCP;

	/* AF_UNSPEC does not get both IPv4 and IPv6 in at least the FreeBSD
	 * version, unless both flavors are in /etc/hosts.
	 * So make 1 or 2 searches to get the results in the right order */
	if (use_ipv46 == DCC_GETH_V4 || use_ipv46 == DCC_GETH_V46) {
		hints.ai_family = AF_INET;
		new_error = getaddrinfo(nm, 0, &hints, &ai);
		if (new_error) {
			error = DCC_GAI_ERRNO(new_error);
		} else {
			copy_ai_to_hostaddrs(ai, use_ipv46);
			freeaddrinfo(ai);
		}
	}
	if (use_ipv46 != DCC_GETH_V4) {
		hints.ai_family = AF_INET6;
		new_error = getaddrinfo(nm, 0, &hints, &ai);
		if (new_error) {
			error = DCC_GAI_ERRNO(new_error);
		} else {
			copy_ai_to_hostaddrs(ai, use_ipv46);
			freeaddrinfo(ai);
		}
	}
	/* look for IPv4 after IPv6 if we need both but prefer IPv6 */
	if (use_ipv46 == DCC_GETH_V64
	    || (use_ipv46 == DCC_GETH_V6
		&& dcc_hostaddrs_end == &dcc_hostaddrs[0])) {
		hints.ai_family = AF_INET;
		new_error = getaddrinfo(nm, 0, &hints, &ai);
		if (new_error) {
			error = DCC_GAI_ERRNO(new_error);
		} else {
			copy_ai_to_hostaddrs(ai, use_ipv46);
			freeaddrinfo(ai);
		}
	}
	if (dcc_hostaddrs_end != &dcc_hostaddrs[0]) {
		*ep = 0;
		return 1;
	}
	if (error == 0)
		error = NO_DATA;
	*ep = error;
	return 0;
#endif
#ifdef DCC_USE_GETIPNODEBYNAME
#define EXPANDED
	struct hostent *hp;
	int error, error2;

	error = 0;
	/* given a choice, return both IPv4 and IPv6 addresses */
	if (use_ipv46 == DCC_GETH_V4 || use_ipv46 == DCC_GETH_V46) {
		hp = getipnodebyname(nm, AF_INET, 0, &error2);
		if (hp) {
			copy_hp_to_hostaddrs(hp, AF_INET, use_ipv46);
			freehostent(hp);
		} else {
			error = error2;
		}
	}
	if (use_ipv46 != DCC_GETH_V4) {
		hp = getipnodebyname(nm, AF_INET6, 0, &error2);
		if (hp) {
			copy_hp_to_hostaddrs(hp, AF_INET6, use_ipv46);
			freehostent(hp);
		} else {
			error = error2;
		}
	}
	/* look for IPv4 after IPv6
	 * if we need both but prefer IPv6
	 * or if we want only IPv6 but got nothing and might have 127.0.0.1
	 *	that should cause us to find ::1 */
	if (use_ipv46 == DCC_GETH_V64
	    || (use_ipv46 == DCC_GETH_V6
		&& dcc_hostaddrs_end == &dcc_hostaddrs[0])) {
		hp = getipnodebyname(nm, AF_INET, 0, &error2);
		if (hp) {
			copy_hp_to_hostaddrs(hp, AF_INET, use_ipv46);
			freehostent(hp);
		} else {
			error = error2;
		}
	}
	/* return both flavors of loopback if we return either */
	if (dcc_hostaddrs_end != &dcc_hostaddrs[0]) {
		*ep = 0;
		return 1;
	}
	*ep = error;
	return 0;
#endif
#ifdef DCC_USE_GETHOSTBYNAME
#define EXPANDED
	/* this platform can only handle IPv4 */
	if (use_ipv46 == DCC_GETH_V6) {
		*ep = HOST_NOT_FOUND;
		return 0;
	}
	return get_host_ipv4(nm, ep, gethostbyname);
#endif
#ifndef EXPANDED
#error no DNS service?
#endif
#undef EXPANDED
}



/* This must be protected with dcc_host_lock()and dcc_host_unlock().
 *	It does not assme that gethostbyname() or whatever is thread safe.
 *	This function is mentioned in dccifd/dccif-test/dccif-test.c
 *	and so cannot change lightly. */
u_char					/* 0=failed */
dcc_get_host(const char *nm,		/* look for this name */
	     DCC_GETH use_ipv46,
	     int *ep)			/* put errno or herrno here */
{
	if (!dcc_host_locked)
		dcc_logbad(EX_SOFTWARE, "dcc_get_host() not locked");

	dcc_host_canonname[0] = '\0';
	dcc_hostaddrs_end = &dcc_hostaddrs[0];

	if (!strcmp(nm, DCC_LOCALHOST)) {
		add_loopback(use_ipv46);
		return 1;
	}

	if (!strcmp(nm, DCC_INADDRANY)) {
		add_inaddr_any(use_ipv46);
		return 1;
	}

	return dcc_get_host_sub(nm, use_ipv46, ep);
}



/* This must be protected with dcc_host_lock()and dcc_host_unlock(). */
u_char					/* 0=failed */
dcc_get_host_SOCKS(const char *nm,	/* look for this name */
		   DCC_GETH use_ipv46,
		   int *ep)		/* put errno or herrno here */
{
	int error;

	/* since there is no Rgetaddrinfo() or equivalent,
	 * use getaddrinfo() only if we need IPv6 addresses */
	if (use_ipv46 == DCC_GETH_V6)
		return dcc_get_host(nm, 1, ep);

	if (!dcc_host_locked)
		dcc_logbad(EX_SOFTWARE, "dcc_get_host() not locked");

	dcc_host_canonname[0] = '\0';
	dcc_hostaddrs_end = &dcc_hostaddrs[0];

	if (!strcmp(nm, DCC_LOCALHOST)) {
		add_loopback(use_ipv46);
		return 1;
	}

	if (!strcmp(nm, DCC_INADDRANY)) {
		add_inaddr_any(use_ipv46);
		return 1;
	}

	error = 0;
	if (use_ipv46 == DCC_GETH_V4 || use_ipv46 == DCC_GETH_V46)
		get_host_ipv4(nm, &error, Rgethostbyname);

	if (use_ipv46 != DCC_GETH_V4)
		dcc_get_host_sub(nm, 1, &error);

	/* use Rgethostbyname for IPv4 addresses in case it differs */
	if (use_ipv46 == DCC_GETH_V64)
		get_host_ipv4(nm, &error, Rgethostbyname);

	if (dcc_hostaddrs_end != &dcc_hostaddrs[0]) {
		*ep = 0;
		return 1;
	}
	*ep = error;
	return 0;
}
