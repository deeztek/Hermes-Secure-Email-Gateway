/* Distributed Checksum Clearinghouse
 *
 * create a UDP socket
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

#include "dcc_defs.h"
#include "dcc_clnt.h"
#include "dcc_ifaddrs.h"
#ifndef DCC_WIN32
#include <arpa/inet.h>			/* for AIX */
#endif


/* mark socket for IPv6 only */
u_char
soc_v6only(DCC_EMSG *emsg UATTRIB,
	   DCC_SOCKET s UATTRIB, const DCC_SOCKU *sup UATTRIB)
{
#if !defined(DCC_NO_IPV6) && defined(IPV6_V6ONLY) && defined(IPPROTO_IPV6)
	int v6only;

	if (sup->sa.sa_family == AF_INET6) {
		/* try to avoid EADDRINUSE problems on systems that think
		 * a socket bound to an IPv4 INADDR_ANY port gets exclusive
		 * rights to that port */
		v6only = 1;
		if (0 > setsockopt(s, IPPROTO_IPV6, IPV6_V6ONLY,
				   &v6only, sizeof(v6only))) {
			dcc_pemsg(EX_OSERR, emsg,
				  "setsockopt(IPPROTO_IPV6): %s", ERROR_STR());
			return 0;
		}
	}
#endif
	return 1;
}



/* Create and bind a UDP socket */
u_char
udp_create(DCC_EMSG *emsg,
	   DCC_SOCKET *sp,		/* INVALID_SOCKET or existing socket */
	   const DCC_SOCKU *sup,
	   u_char nonblock,		/* 1=set non-blocking */
	   u_char cloexec,		/* 1=set close-on-exec */
	   int *retry_secsp)		/* -1=one retry for an anonymous port,
					 * 0=no retry, >0=seconds trying */
{
	DCC_SOCKU su;
#ifdef DCC_WIN32
	u_long on;
#endif
	int tenths;

	if (*sp == INVALID_SOCKET) {
#ifdef DCC_NO_IPV6
		if (sup->sa.sa_family == AF_INET6) {
			dcc_pemsg(EX_OSERR, emsg,
				  "attempted to create IPv6 UDP socket"
				  " without IPv6 support");
			return 0;
		}
#endif
		*sp = socket(sup->sa.sa_family, SOCK_DGRAM, 0);
		if (*sp == INVALID_SOCKET) {
			dcc_pemsg(EX_OSERR, emsg,
				  "socket(UDP IPv4): %s", ERROR_STR());
			return 0;
		}
	}

#ifdef DCC_WIN32
	on = 1;
	if (nonblock
	    && SOCKET_ERROR == ioctlsocket(*sp, FIONBIO, &on)) {
		dcc_pemsg(EX_OSERR, emsg, "ioctlsocket(UDP, FIONBIO): %s",
			  ERROR_STR());
		closesocket(*sp);
		*sp = INVALID_SOCKET;
		return 0;
	}
#else
	if (cloexec
	    && 0 > fcntl(*sp, F_SETFD, FD_CLOEXEC)) {
		dcc_pemsg(EX_OSERR, emsg, "fcntl(UDP, FD_CLOEXEC): %s",
			  ERROR_STR());
		closesocket(*sp);
		*sp = INVALID_SOCKET;
		return 0;
	}
	if (nonblock
	    && -1 == fcntl(*sp, F_SETFL,
			   fcntl(*sp, F_GETFL, 0) | O_NONBLOCK)) {
		dcc_pemsg(EX_OSERR, emsg, "fcntl(UDP O_NONBLOCK): %s",
			  ERROR_STR());
		closesocket(*sp);
		*sp = INVALID_SOCKET;
		return 0;
	}
#endif

	if (!soc_v6only(emsg, *sp, sup))
		dcc_trace_msg("UDP %s", emsg->c);

	tenths = 10;
	for (;;) {
		if (SOCKET_ERROR != bind(*sp, &sup->sa, DCC_SU_LEN(sup)))
			return 1;

		if (errno == EADDRINUSE
		    && retry_secsp && *retry_secsp < 0
		    && sup != &su
		    && DCC_SU_PORT(sup) != 0) {
			/* If the initial number of seconds to retry was <0,
			 * then make one last try for a new ephemeral port */
			su = *sup;
			DCC_SU_PORT(&su) = 0;
			sup = &su;
			continue;
		}

		if (errno != EADDRINUSE
		    || !retry_secsp || *retry_secsp <= 0) {
			/* no retries were allowed or we have exhasuted them */
			dcc_pemsg(EX_OSERR, emsg, "bind(UDP %s): %s",
				  dcc_su2str_err(sup), ERROR_STR());
			closesocket(*sp);
			*sp = INVALID_SOCKET;
			return 0;
		}

		usleep(100*1000);
		if (!--tenths) {
			--*retry_secsp;
			tenths = 10;
		}
	}
}



/* check for IPv4 or IPv6 sockets */
u_char
ipv_check(DCC_EMSG *emsg,		/* ignore if null */
	  sa_family_t family,
	  u_char check_interfaces
#if defined(DCC_NO_IPV6) || (!defined(HAVE_GETIFADDRS) || !defined(HAVE_FREEIFADDRS))
	  DCC_UNUSED
#endif
	  )
{
#ifdef DCC_NO_IPV6
	/* assume that a system without IPv6 always has IPv4 */
	if (family == AF_INET6) {
		if (emsg)
			dcc_pemsg(EX_OSERR, emsg, "IPv6 support not built");
		return 0;
	}
	return 1;
#else
	DCC_SOCKU su;
	DCC_SOCKET s;

	/* try to create a UDP socket of the target version */
	s = socket(family, SOCK_DGRAM, 0);
	if (s == INVALID_SOCKET) {
		dcc_pemsg(EX_OSERR, emsg,
			  "no IPv%c support, socket(): %s",
			  (family == AF_INET) ? '4' : '6', ERROR_STR());
		return 0;
	}

	/* bind to an ephemeral port of the target version */
	dcc_mk_su(&su, family, 0, 0, 0);
	if (SOCKET_ERROR == bind(s, &su.sa, DCC_SU_LEN(&su))) {
		dcc_pemsg(EX_OSERR, emsg,
			  "no IPv%c support, bind(): %s",
			  (family == AF_INET) ? '4' : '6', ERROR_STR());
		close(s);
		return 0;
	}

	/* finally try to connect to through the loopback interface */
	dcc_mk_loop_su(&su, family, DCC_SRVR_PORT_HO);
	if (SOCKET_ERROR == connect(s, &su.sa, DCC_SU_LEN(&su))) {
		dcc_pemsg(EX_OSERR, emsg,
			  "no IPv%c support, connect(): %s",
			  (family == AF_INET) ? '4' : '6', ERROR_STR());
		close(s);
		return 0;
	}

	close(s);

	/* It seems likely that we can use IPv6 or IPv4 locally, but
	 * it might not reach the Internet.  Many systems let IPv6 work
	 * through loopback or a link-local interface.  A DCC server
	 * should listen on all families that seem to work, but
	 * a client should usually only try to send using families that are
	 * routed to the Internet. */
#if defined(HAVE_GETIFADDRS) && defined(HAVE_FREEIFADDRS)
	if (check_interfaces) {
		struct ifaddrs *ifap0, *ifap;
		const DCC_SOCKU *sup;

		if (0 > getifaddrs(&ifap0)) {
			dcc_error_msg("getifaddrs(): %s", ERROR_STR());
			return 1;
		}

		for (ifap = ifap0; ifap; ifap = ifap->ifa_next) {
			if (!(ifap->ifa_flags & IFF_UP))
				continue;
			sup = (DCC_SOCKU *)ifap->ifa_addr;
			if (!sup)
				continue;
			if (sup->sa.sa_family == family
			    && !dcc_su_is_loopback(sup)
			    && !DCC_SU_IS_LINKLOCAL(sup)
			    && !DCC_SU_IS_SITELOCAL(sup)) {
				freeifaddrs(ifap0);
				return 1;
			}
		}
		dcc_pemsg(EX_OSERR, emsg,
			  "no IPv%c interface addresses",
			  (family == AF_INET) ? '4' : '6');
		return 0;
	}
#endif


	return 1;
#endif
}



/* set socket receive buffer size as large as possible */
u_char
set_rcvbuf(DCC_EMSG *emsg, int s, const DCC_SOCKU *sup,
	   int *socbuf, u_char *socbuf_set)
{
	char sustr[DCC_SU2STR_SIZE];

	if (!*socbuf_set)
		*socbuf = 4*1024*1024;

	for (;;) {
		if (!setsockopt(s, SOL_SOCKET, SO_RCVBUF,
				socbuf, sizeof(*socbuf))) {
				*socbuf_set = 1;
			return 1;
		}
		if (*socbuf_set || *socbuf <= 4096) {
			dcc_pemsg(EX_OSERR, emsg,
				  "setsockopt(%s,SO_RCVBUF=%d): %s",
				  dcc_su2str(sustr, sizeof(sustr), sup),
				  *socbuf, ERROR_STR());
			return 0;
		}
		if (*socbuf > 256*1024)
			*socbuf /= 2;
		else
			*socbuf -= 4096;
	}
}
