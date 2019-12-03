/* Distributed Checksum Clearinghouse
 *
 * sockets and IP addresses
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
 * Rhyolite Software DCC 2.3.167-1.34 $Revision$
 */

#ifndef DCC_SOCKET_H
#define DCC_SOCKET_H

#ifdef DCC_USE_POLL
#include <poll.h>
#endif


#define DCC_MAXDOMAINLEN   256		/* limit host names; with \0 */

/* we need IPv6 addresses even without IPv6 support
 *	defend against lurking definitions */
#ifdef DCC_NO_IPV6
#undef in6_addr
#define in6_addr dcc_in6_addr
#undef s6_addr32
#define s6_addr32 __u6_addr.dcc_s6_addr32
#undef s6_addr
#define s6_addr __u6_addr.dcc_s6_addr
#undef sockaddr_in6
#define sockaddr_in6 dcc_sockaddr_in6
#endif /* DCC_NO_IPV6 */

/* 4.4BSD sockets */
#ifdef HAVE_SA_LEN
#define DCC_SU_LEN(s) ((s)->sa.sa_len)
#else
#define DCC_SU_LEN(s) (((s)->sa.sa_family == AF_INET)	\
		       ? sizeof((s)->ipv4) : sizeof((s)->ipv6))
#endif

#ifndef HAVE_SOCKLEN_T
typedef u_int32_t socklen_t;
#endif
#ifndef HAVE_IN_ADDR_T
typedef u_int32_t in_addr_t;
#endif
#ifndef HAVE_SA_FAMILY_T
typedef u_char sa_family_t;
#endif
#ifndef HAVE_IN_PORT_T
typedef u_int16_t in_port_t;
#endif

#ifdef DCC_UNIX
typedef int DCC_SOCKET;
#else
typedef SOCKET DCC_SOCKET;
#endif


#if !defined(HAVE_AF_LOCAL) && !defined(AF_LOCAL)
#define AF_LOCAL AF_UNIX
#endif


/* These are needed even when IPv6 is available to handle old map file
 *	formats in dcc_clnt.h */
struct dcc_in6_addr {
    union {
	u_int8_t    dcc_s6_addr[16];
	u_int32_t   dcc_s6_addr32[4];
    } __u6_addr;
};
typedef u_int32_t DCC_SCOPE_ID;
struct dcc_sockaddr_in6 {
    u_char	sin6_len;
    sa_family_t	sin6_family;
    in_port_t	sin6_port;
    u_int32_t	sin6_flowinfo;
    struct dcc_in6_addr sin6_addr;
    DCC_SCOPE_ID sin6_scope_id;
};

/* puzzle out something for the non-standard and often hidden s6_addr32 */
#if !defined(s6_addr32) && defined(DCC_CONF_S6_ADDR32)
#define s6_addr32 DCC_CONF_S6_ADDR32
#endif

typedef struct {
    struct in6_addr lo;
    struct in6_addr hi;
} DCC_IP_RANGE;

typedef union {
    struct sockaddr sa;
    struct sockaddr_in ipv4;
    struct sockaddr_in6 ipv6;
} DCC_SOCKU;

/* Some Linux uses 16 bits for sa_family_t */
typedef	u_int16_t DCC_IP_FAMILY;

/* we cannot always use DCC_SOCKU because sizeof(sockaddr_in6) is not defined
 * on systems without IPv6 and when they do get IPv6, the native sockaddr_in
 * often differs in size from the work-around version in the DCC source */
typedef struct {
    union {
	struct in_addr ipv4;
	struct in6_addr ipv6;
    } u;
    DCC_SCOPE_ID scope_id;
    in_port_t	port;
    DCC_IP_FAMILY family;
} DCC_IP;

#if !defined(HAVE_AF_INET6) && !defined(AF_INET6)
#define AF_INET6 24
#endif

#ifndef INET6_ADDRSTRLEN
#define INET6_ADDRSTRLEN 46		/* including terminal '\0' */
#endif
#ifndef INET_ADDRSTRLEN
#define INET_ADDRSTRLEN 16		/* including terminal '\0' */
#endif

#define DCC_IPV4_CHARS	".0123456789"
#define DCC_IPV6_CHARS	DCC_IPV4_CHARS":abcdefABCDEF"

#define DCC_SU_IS_LINKLOCAL(s) ((s)->sa.sa_family == AF_INET6		    \
				&& (s)->ipv6.sin6_addr.s6_addr[0] == 0xfe   \
				&& (((s)->ipv6.sin6_addr.s6_addr[1] & 0xc0) \
				    == 0x80))
#define DCC_SU_IS_SITELOCAL(s) ((s)->sa.sa_family == AF_INET6		    \
				&& (s)->ipv6.sin6_addr.s6_addr[0] == 0xfe   \
				&& (((s)->ipv6.sin6_addr.s6_addr[1] & 0xc0) \
				    == 0xc0))


#define DCC_IPV6_ALIT	"IPv6:"		/* address literal prefix */

#define MAXPORTNAMELEN	64

#ifndef INADDR_LOOPBACK
#define	INADDR_LOOPBACK	(u_int32_t)0x7f000001
#endif
#ifndef INADDR_NONE
#define INADDR_NONE	0xffffffff
#endif


/* l-value
 *	use IPv4 port number if sa_family is AF_UNSPEC */
#define DCC_SU_PORT(su) (*((su)->sa.sa_family == AF_INET6		\
			   ? &(su)->ipv6.sin6_port			\
			   : &(su)->ipv4.sin_port))

#define DCC_ADDR6_V4MAPPED(ap) ((ap)->s6_addr32[0] == 0			\
				&& (ap)->s6_addr32[1] == 0		\
				&& (ap)->s6_addr32[2] == ntohl(0x0000ffff))

#define DCC_ADDR6_IS_ANY(ap) ((ap)->s6_addr32[0] == 0			\
			     && (ap)->s6_addr32[1] == 0			\
			     && (ap)->s6_addr32[2] == 0			\
			     && (ap)->s6_addr32[3] == 0)

#define DCC_SU_IS_ANY(su) ((su)->sa.sa_family == AF_INET		\
			   ? (su)->ipv4.sin_addr.s_addr == INADDR_ANY	\
			   : (su)->sa.sa_family == AF_INET6		\
			   ? DCC_ADDR6_IS_ANY(&(su)->ipv6.sin6_addr)	\
			   : 0)

/* zero port number if sa_family is AF_UNSPEC */
#define DCC_SU_PORT_Z(su) ((su)->sa.sa_family == AF_INET		\
			   ? (su)->ipv4.sin_port			\
			   : (su)->sa.sa_family == AF_INET6		\
			   ? (su)->ipv6.sin6_port			\
			   : 0)

#ifdef DCC_NO_IPV6
#undef HAVE_SIN6_SCOPE_ID
#endif

#ifdef HAVE_SIN6_SCOPE_ID
#define _DCC_IPV6_EQ(a1,s1,a2,s2) (!memcmp((a1),(a2), sizeof(struct in6_addr)) \
				   && (s1) == (s2))
#else
#define _DCC_IPV6_EQ(a1,s1,a2,s2) (!memcmp((a1),(a2), sizeof(struct in6_addr)))
#endif /* HAVE_SIN6_SCOPE_ID */
#ifdef HAVE_GCC_INLINE			   /* no prototypes without inline */
static inline u_char
DCC_IPV6_EQ(const struct in6_addr *a1, u_int32_t s1 DCC_UNUSED,
	    const struct in6_addr *a2, u_int32_t s2 DCC_UNUSED)
{ return _DCC_IPV6_EQ(a1,s1,a2,s2); }
#else
#define DCC_IPV6_EQ(a1,s1,a2,s2) _DCC_IPV6_EQ(a1,s1,a2,s2)
#endif

/* compare struc in6_addr */
#define _DCC_SU_IPV6_EQ(a,b) DCC_IPV6_EQ(&(a)->sin6_addr, (a)->sin6_scope_id, \
					 &(b)->sin6_addr, (b)->sin6_scope_id)

/* compare DCC_SOCKU addresses but not port numbers */
#define _DCC_SUnP_EQ(a,b) ((a)->sa.sa_family == (b)->sa.sa_family	\
			   && (((a)->sa.sa_family == AF_INET)		\
			       ? ((a)->ipv4.sin_addr.s_addr		\
				  == (b)->ipv4.sin_addr.s_addr)		\
			       : _DCC_SU_IPV6_EQ(&(a)->ipv6, &(b)->ipv6)))
#ifdef HAVE_GCC_INLINE			   /* no prototypes without inline */
static inline u_char
DCC_SUnP_EQ(const DCC_SOCKU *a, const DCC_SOCKU *b)
{ return _DCC_SUnP_EQ(a,b); }
#else
#define DCC_SUnP_EQ(a,b) _DCC_SUnP_EQ(a,b)
#endif

/* compare DCC_SOCKU to DCC_IP but not port numbers */
#define _DCC_SUnP_IP_EQ(s,i) ((s)->sa.sa_family == (i)->family		\
			     && (((s)->sa.sa_family == AF_INET)		\
				 ? ((s)->ipv4.sin_addr.s_addr		\
				    == (i)->u.ipv4.s_addr)		\
				 : DCC_IPV6_EQ(&(s)->ipv6.sin6_addr,	\
					       (s)->ipv6.sin6_scope_id,	\
					       &(i)->u.ipv6,		\
					       (i)->scope_id)))
#ifdef HAVE_GCC_INLINE			   /* no prototypes without inline */
static inline u_char
DCC_SUnP_IP_EQ(const DCC_SOCKU *s, const DCC_IP *i)
{
	return _DCC_SUnP_IP_EQ(s,i);
}
#else
#define DCC_SUnP_IP_EQ(s,i) _DCC_SUnP_IP_EQ(s,i)
#endif

/* compare DCC_SOCKU addresses */
#define _DCC_SU_EQ(a,b) (DCC_SU_PORT(a) == DCC_SU_PORT(b) && DCC_SUnP_EQ(a,b))
#ifdef HAVE_GCC_INLINE			   /* no prototypes without inline */
static inline u_char
DCC_SU_EQ(const DCC_SOCKU *a, const DCC_SOCKU *b) { return _DCC_SU_EQ(a,b); }
#else
#define DCC_SU_EQ(a,b) _DCC_SU_EQ(a,b)
#endif

/* compare DCC_SOCKU to DCC_IP */
#define _DCC_SU_IP_EQ(s,i) (DCC_SU_PORT(s) == (i)->port && _DCC_SUnP_IP_EQ(s,i))
#ifdef HAVE_GCC_INLINE			   /* no prototypes without inline */
static inline u_char
DCC_SU_IP_EQ(const DCC_SOCKU *s, const DCC_IP *i) { return _DCC_SU_IP_EQ(s,i); }
#else
#define DCC_SU_IP_EQ(s,i) _DCC_SU_IP_EQ(s,i)
#endif

#if !defined(HAVE_INET_NTOP) || defined(DCC_NO_IPV6)
#define DCC_INET_NTOP dcc_inet_ntop
#else
#define DCC_INET_NTOP inet_ntop
#endif
extern const char *dcc_inet_ntop(int, const void *, char *, size_t);

#if !defined(HAVE_INET_PTON) || defined(DCC_NO_IPV6)
#define DCC_INET_PTON dcc_inet_pton
#else
#define DCC_INET_PTON inet_pton
#endif
extern int dcc_inet_pton(int, const char *, void *);


#ifdef DCC_UNIX
/* at least some filters including IPFW say EACCES on hits,
 * so treat EACCES like Unreachables */
#define UNREACHABLE_ERRORS() (errno == ECONNREFUSED			\
			      || errno == EHOSTUNREACH			\
			      || errno == ENETUNREACH			\
			      || errno == EHOSTDOWN			\
			      || errno == ENETDOWN			\
			      || errno == EACCES)

#define CONN_WAIT_ERRORS() (errno == EAGAIN || errno == EINPROGRESS	\
			    || errno == EALREADY)
#define CONN_ERRORS() (UNREACHABLE_ERRORS() || errno == EINVAL		\
		       || errno == ECONNABORTED || errno == ECONNRESET	\
		       || errno == ETIMEDOUT || errno == ECONNREFUSED)

#else /* !DCC_UNIX or DCC_WIN32 */
#define UNREACHABLE_ERRORS() (errno == WSAECONNREFUSED			\
			      || errno == WSAEHOSTUNREACH		\
			      || errno == WSAENETUNREACH		\
			      || errno == WSAEHOSTDOWN			\
			      || errno == WSAENETDOWN)
#define EADDRINUSE	WSAEADDRINUSE

#define MAXHOSTNAMELEN   256

/* Microsoft sendto() and recvfrom() want (char *) buffers */
#define WIN32_SOC_CAST (char *)

/* Microsoft expects ints where other systems want socklen_t, which is usually
 * unsigned */
typedef int32_t socklen_t;

#endif /* DCC_WIN32 */



extern void dcc_ipv4toipv6(struct in6_addr *, const struct in_addr);
extern u_char dcc_ipv6toipv4(struct in_addr *, const struct in6_addr *);
extern void dcc_su2ip(DCC_IP *, const DCC_SOCKU *);
extern u_char dcc_ipv6su2ipv4su(DCC_SOCKU *, const DCC_SOCKU *);
extern u_char dcc_ipv4su2ipv6su(DCC_SOCKU *, const DCC_SOCKU *);
extern const struct in6_addr *dcc_su2ipv6(struct in6_addr *, u_char,
					  const DCC_SOCKU *);

extern const char *dcc_trim_ffff(const char *);
#define DCC_SU2STR_SIZE (INET6_ADDRSTRLEN+1+6+1)
extern const char *dcc_ipv4tostr(char *, int, const struct in_addr *);
extern const char *dcc_ipv6tostr(char *, int, const struct in6_addr *);
extern const char *dcc_ipv6tostr2(char *, int, const struct in6_addr *);
extern const char *dcc_ip2str(char *, int, const DCC_IP *);
extern const char *dcc_su2str(char *, int, const DCC_SOCKU *);
extern const char *dcc_su2str2(char *, int, const DCC_SOCKU *);
extern const char *dcc_su2str3(char *, int, const DCC_SOCKU *, u_short);
extern const char *dcc_su2str_err(const DCC_SOCKU *);
extern const char *dcc_host_portname(char *, int, const char *, const char *);
extern const char *dcc_su2name(char *, int, const DCC_SOCKU *);


/* use very old fashioned gethostbyname() if we are not doing any IPv6 */
#ifdef DCC_NO_IPV6
#undef HAVE_GETIPNODEBYNAME
#undef HAVE_GETADDRINFO
#endif

#if !defined(HAVE_GETIPNODEBYNAME) || !defined(HAVE_FREEHOSTENT) || !defined(HAVE_GETIPNODEBYADDR)
#undef HAVE_GETIPNODEBYNAME
#endif

#if !defined(HAVE_GETADDRINFO) || !defined(HAVE_FREEADDRINFO) || !defined(HAVE_GAI_STRERROR) || !defined(HAVE_GETNAMEINFO)
#undef HAVE_GETADDRINFO
#endif

/* prefer getaddrinfo() for IPv6 resolution */
#ifdef HAVE_GETADDRINFO
#define DCC_USE_GETADDRINFO
#define DCC_GETHOSTBYNAME_NAME "getaddrinfo"
#endif
#if defined(HAVE_GETIPNODEBYNAME) && !defined(DCC_USE_GETADDRINFO)
#define DCC_USE_GETIPNODEBYNAME
#define DCC_GETHOSTBYNAME_NAME "getaddrinfo"
#endif
#if !defined(DCC_USE_GETIPNODEBYNAME) && !defined(DCC_USE_GETADDRINFO)
#define DCC_USE_GETHOSTBYNAME
#define DCC_GETHOSTBYNAME_NAME "gethostbyname"
#endif


#ifdef HAVE_HSTRERROR
#define DCC_HSTRERROR(e) hstrerror(e)
#else
#ifdef DCC_WIN32
#define DCC_HSTRERROR(e) ws_strerror(e)
#else
#define DCC_HSTRERROR(e) dcc_hstrerror(e)
#endif
#endif

/* deal with inconsistent error numbers between hsterror() and gai_strerror() */
#ifdef DCC_USE_GETADDRINFO
/* encode the small positive error numbers used in BSD style getaddrinfo()
 * and the small negative numbers used in Linux style getaddrinfo() */
#define DCC_GAI_ERRNO(e) ((e)+0x2000)
#define H_ERROR_STR1(e) (((unsigned)(e) >= (unsigned)0x1000)		\
			 ? gai_strerror((e)-0x2000)			\
			 : DCC_HSTRERROR(e))
#define DCC_HERRNO_TRY_AGAIN(e) ((e) == DCC_GAI_ERRNO(EAI_AGAIN)	\
				 || (e) == TRY_AGAIN)
#else /* !DCC_USE_GETADDRINFO */
#define H_ERROR_STR1(e) DCC_HSTRERROR(e)
#ifdef DCC_WIN32
#define DCC_HERRNO_TRY_AGAIN(e) ((e) == WSATRY_AGAIN)
#else
#define DCC_HERRNO_TRY_AGAIN(e) ((e) == TRY_AGAIN)
#endif
#endif /* !DCC_USE_GETADDRINFO */


extern u_char dcc_su_is_loopback(const DCC_SOCKU *);
extern u_int dcc_get_port(DCC_EMSG *, const char *, u_int, const char *, int);
#define DCC_GET_PORT_INVALID	0x10000
#define DCC_MAX_HOSTADDRS	20	/* must be > DCC_MAX_SRVR_ADDRS */
extern DCC_SOCKU dcc_hostaddrs[DCC_MAX_HOSTADDRS];
extern char dcc_host_canonname[DCC_MAXDOMAINLEN];
extern DCC_SOCKU *dcc_hostaddrs_end;
typedef enum {				/* gethostby*() preferences */
    DCC_GETH_V4 = 0,			/*    get IPv4 address */
    DCC_GETH_V6 = 1,			/*    get IPv6 */
    DCC_GETH_V64 = 2,			/*    both but prefer IPv6 */
    DCC_GETH_V46 = 3			/*    both but prefer IPv4 */
} DCC_GETH;
#define DCC_GETH_DEF DCC_GETH_V46
#define DCC_LOCALHOST		"@"	/* kludge for 127.1 and ::1 */
#define DCC_INADDRANY		"*"
extern u_char dcc_get_host(const char *, DCC_GETH, int *);
extern u_char dcc_get_host_SOCKS(const char *, DCC_GETH, int *);
extern const char *dcc_hstrerror(int);

extern DCC_SOCKU *dcc_mk_inet_su(DCC_SOCKU *,
				 const struct in_addr *, in_port_t);
extern DCC_SOCKU *dcc_mk_inet6_su(DCC_SOCKU *,
				  const struct in6_addr *, u_int32_t, in_port_t);
extern DCC_SOCKU *dcc_mk_su(DCC_SOCKU *, sa_family_t,
			    const void *, DCC_SCOPE_ID, in_port_t);
extern DCC_SOCKU *dcc_mk_loop_su(DCC_SOCKU *s, sa_family_t, in_port_t);
extern DCC_SOCKU *dcc_ip2su(DCC_SOCKU *, const DCC_IP *);

extern u_char soc_v6only(DCC_EMSG *, DCC_SOCKET, const DCC_SOCKU *);
extern u_char udp_create(DCC_EMSG *, DCC_SOCKET *, const DCC_SOCKU *,
			 u_char, u_char, int *);
extern u_char ipv_check(DCC_EMSG *, sa_family_t, u_char);
extern u_char set_rcvbuf(DCC_EMSG *, int, const DCC_SOCKU *, int *, u_char *);

extern u_int len_ip_range(const DCC_IP_RANGE *);
extern void inc_ip6(struct in6_addr *);
#define _IN_RANGE(t,r) (memcmp((t), &(r)->lo, sizeof(struct in6_addr)) >= 0  \
		       && memcmp((t), &(r)->hi, sizeof(struct in6_addr)) <= 0)
#ifdef HAVE_GCC_INLINE			/* no prototypes without inline */
static inline u_char
in_range(const struct in6_addr *tgt, const DCC_IP_RANGE *range)
{return _IN_RANGE(tgt,range);}
#else
#define in_range(t,r) _IN_RANGE(t,r)
#endif
extern u_char cidr2range(DCC_IP_RANGE *, const struct in6_addr *, int);
extern int str2range(DCC_EMSG *, DCC_IP_RANGE *, u_char *,
		     const char *, const char *, int);
extern const char *range2str(char *, int, const DCC_IP_RANGE *);
extern u_char str2su(DCC_SOCKU *, const char *);
extern void bits2mask(struct in6_addr *, int);
#define apply_ipmask(_r, _a, _m) (					\
	(_r)->s6_addr32[0] = (_a)->s6_addr32[0] & (_m)->s6_addr32[0],	\
	(_r)->s6_addr32[1] = (_a)->s6_addr32[1] & (_m)->s6_addr32[1],	\
	(_r)->s6_addr32[2] = (_a)->s6_addr32[2] & (_m)->s6_addr32[2],	\
	(_r)->s6_addr32[3] = (_a)->s6_addr32[3] & (_m)->s6_addr32[3])
extern int str2cidr(DCC_EMSG *, struct in6_addr *, struct in6_addr *,
		    const char *);

#ifdef DCC_USE_POLL
typedef struct pollfd DCC_POLLFD;
#ifndef INFTIM
#define INFTIM (-1)
#endif
#else
typedef struct {
#ifdef DCC_WIN32
    u_int   fd;
#else
    int	    fd;
#endif
    short   events;
    short   revents;
} DCC_POLLFD;
#endif
extern int select_poll(DCC_EMSG *, DCC_POLLFD *, int, u_char, int);


#ifdef HAVE_RSENDTO
extern int Rconnect(int, const struct sockaddr *, socklen_t);
extern ssize_t Rsend(int, const void *, size_t, int);
extern ssize_t Rsendto(int, const void *, size_t, int,
		       const struct sockaddr *, size_t);
extern ssize_t Rrecv(int, void *, size_t, int);
extern ssize_t Rrecvfrom(int, void *, size_t, int,
			 struct sockaddr *, socklen_t *);
extern struct hostent *Rgethostbyname(const char *);
#else
#define Rconnect    connect
#define Rsend	    send
#define Rsendto	    sendto
#define Rrecv	    recv
#define Rrecvfrom   recvfrom
#define Rgethostbyname gethostbyname
#endif


#endif /* DCC_SOCKET_H */
