/* Distributed Checksum Clearinghouse
 *
 * send a request from client to server
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
 * Rhyolite Software DCC 2.3.167-1.240 $Revision$
 */

#include "dcc_clnt.h"
#ifdef HAVE_ARPA_NAMESER_H
#include <arpa/nameser.h>
#endif
#ifdef HAVE_RESOLV_H
#include <resolv.h>
#endif

DCC_CLNT_INFO *dcc_clnt_info;		/* memory mapped shared data */
u_char dcc_all_srvrs = 0;		/* try to contact all servers */

#define CLNT_LOSSES 0
#if CLNT_LOSSES
static u_int clnt_losses;
#endif
#define SEND_FAIL 0
#define SEND_FAIL_ERRNO EPERM
#if SEND_FAIL
static int send_fail;
#endif
#define RECV_FAIL 0
#define RECV_FAIL_ERRNO EHOSTUNREACH
#if RECV_FAIL
static int recv_fail;
#endif

int dcc_debug_ttl;

u_char grey_on;


#define AGE_AVG(_v,_n,_a,_b) ((_v) = ((_v)*_a + (_n)*_b + (_a+_b)/2)/(_a+_b))

/* send NOPs to measure the RTTs to servers when the current server
 * becomes slow this often */
#define FAST_RTT_SECS    (15*60)


char dcc_clnt_hostname[MAXHOSTNAMELEN];	/* local host name */
static u_int32_t dcc_clnt_hid;		/* our DCC host-ID */


/* Each client knows about one or more servers, lest the current server
 * crash.  To ensure that counts of spam accumulate as quickly as possible,
 * all of the processes on a client try to use a single server.  The
 * closest (or fastest) server is preferred.  It is desirable for the
 * servers to convert the host names of the servers to IP addresses
 * frequently enough to track changes in address records, but not so
 * often that a lot of time is wasted on the DNS.
 *
 * All of that implies that independent processes on the client need to
 * cooperate in measuring the round trip time to the servers and maintaining
 * their IP addresses.  On UNIX systems, this is accomplished with mmap()
 * and a well known file.
 *
 * The DCC client uses 3 locks:
 * 1. mutex to ensure that only one thread in process sends bursts of NOPs
 *	to measure RTTs or resolves DNS server names
 * 2. mutex protecting the shared information in the map file for threads
 *	within a process
 * 3. fcntl() lock on the file to protect the shared information among processes
 *
 * To avoid ABBA deadlocks, the locks are always sought in that order.
 * For most operations, only #2/#3 is needed.  Sometimes only #2.
 *
 * Some systems have broken fcntl() locking (e.g. NFS in Solaris).
 * They lock the entire file. */


/* the contexts must be locked to read or change these values */
int info_fd = -1;
#ifdef DCC_WIN32
HANDLE info_map = INVALID_HANDLE_VALUE;
#endif
struct stat dcc_info_sb;
DCC_PATH dcc_info_nm;

/* info_locked is set when the file system lock on changing the mapped file is
 *	held.  The contexts must be locked while info_locked is set, as well as
 *	when it is checked or changed. */
static u_char info_locked;




/* Get the RTT used to pick servers.
 *	It includes the local bias and the penaltie for DCC protocol
 *	version mismatches and IP verison mismatches */
static int
effective_rtt(const DCC_SRVR_CLASS *class, const DCC_SRVR_ADDR *ap)
{
	int rtt;

	rtt = ap->rtt;
	if (rtt >= DCC_MAX_RTT)
		return DCC_RTT_BAD;

	rtt += class->nms[ap->nam_inx].rtt_adj;
	/* penalize servers with strange versions */
	if (ap->srvr_pkt_vers < DCC_PKT_VERS_CLNT_OK
	    && ap->srvr_id != DCC_ID_INVALID)
		rtt += DCC_RTT_VERS_ADJ;

	/* It is expensive to switch the socket between IPv4 and IP6
	 * when talking to the DCC and greylist servers.
	 * The greylist server is often on the local system and
	 * can be reached by both IPv4 and IPv6.  The two apparent
	 * greylist servers usually have RTTs that differ by small random
	 * amounts.
	 * So penalize greylist servers with a different IP version than
	 * the current DCC server */
	if (0 == (dcc_clnt_info->fgs & (DCC_INFO_FG_IPV4_OFF
					| DCC_INFO_FG_IPV6_OFF))
	    && DCC_IS_GREY(class)) {
		SRVR_INX srvr_inx;

		srvr_inx = dcc_clnt_info->dcc.srvr_inx;
		if (VALID_SRVR(&dcc_clnt_info->dcc, srvr_inx)
		    && (dcc_clnt_info->dcc.addrs[srvr_inx].ip.family
			!= ap->ip.family))
			rtt += 10*1000;	/* 10 milliseconds */
	}

	if (rtt >= DCC_RTT_BAD)
		return DCC_RTT_BAD-1;
	return rtt;
}



static inline u_char
good_rtt(const DCC_SRVR_CLASS *class)
{
	int rtt;

	if (!HAVE_CLASS_SRVR(class))
		return 0;

	rtt = effective_rtt(class, &class->addrs[class->srvr_inx]);
	if (rtt > class->avg_thold_rtt)
		return 0;

	return 1;
}



#define AP2CLASS(ap) DCC_GREY2CLASS(ap >= dcc_clnt_info->grey.addrs)

/* add an address and port number to a growing string of them */
int
dcc_ap2str_opt(char *buf, int buf_len,	/* into this buffer */
	       const DCC_SRVR_CLASS *class,
	       u_char inx,		/* which address in the class */
	       char port_str)		/* '\0' or '-' */
{
	const DCC_SRVR_ADDR *ap;
	char *buf1;
	int len;

	ap = &class->addrs[inx];
	dcc_ip2str(buf, buf_len, &ap->ip);

	len = strlen(buf);
	buf1 = buf+len;
	buf_len -= len;
	if (ap->ip.port == DCC_CLASS2PORT(class)) {
		if (port_str) {
			if (buf_len >= 1) {
				*buf1 = ',';
				if (buf_len >= 2)
					*++buf1 = port_str;
				*++buf1 = '\0';
			}
		}
	} else if (buf_len > 0) {
		len = snprintf(buf1, buf_len, ",%d", ntohs(ap->ip.port));
		if (len >= buf_len)
			len = buf_len-1;
		buf1 += len;
	}

	return buf1-buf;
}



static const char *
addr2str(char *buf, u_int buf_len, const DCC_SRVR_CLASS *class,
	 int addrs_gen, const DCC_SRVR_ADDR *ap, const DCC_SOCKU *sup)
{
	DCC_SOCKU su;
	char str[DCC_SU2STR_SIZE];
	const char *host;

	if (class->gen == addrs_gen) {
		if (!sup) {
			dcc_ip2su(&su, &ap->ip);
			sup = &su;
		}
		dcc_su2str(str, sizeof(str), sup);
		if (VALID_NAM(ap->nam_inx)
		    && (host = class->nms[ap->nam_inx].hostname,
			!str2su(0, host))) {
			snprintf(buf, buf_len, "%s (%s)", host, str);
		} else {
			snprintf(buf, buf_len, "%s", str);
		}

	} else if (sup) {
		dcc_su2str(buf, buf_len, sup);

	} else {
		snprintf(buf, buf_len, DCC_IS_GREY_STR(class));
	}
	return buf;
}



/* We are about to generate an error message that can justify failing
 *	or we are about to claim success.
 *	If we already had an error message and are debugging, display
 *	that one. */
static void
flush_emsg(DCC_EMSG *emsg)
{
	/* nothing to do if there is nothing to display */
	if (!emsg || emsg->c[0] == '\0')
		return;

	if (dcc_clnt_debug)
		dcc_trace_msg("%s", emsg->c);

	emsg->c[0] = '\0';
}



/* display or prepare a less interesting error message if we do not have
 *	a buffer or if there is no old, more important message*/
static void
extra_vpemsg(DCC_EMSG *emsg, const char *p, va_list args)
{
	if (!emsg) {
		dcc_vtrace_msg(p, args);
		return;
	}

	if (emsg->c[0] != '\0') {
		/* We already have a message. */
		if (emsg_ex_code(emsg) != EX_UNAVAILABLE) {
			/* It was more important, so treat this one as tracing */
			dcc_vtrace_msg(p, args);
			return;
		} else {
			/* It was also boring,
			 * so treat it as tracing and save this one. */
			if (dcc_clnt_debug)
				dcc_trace_msg("%s", emsg->c);
		}
	}

	dcc_vpemsg(EX_UNAVAILABLE, emsg, p, args);
}



static void DCC_PF(2,3)
extra_pemsg(DCC_EMSG *emsg, const char *p, ...)
{
	va_list args;

	va_start(args, p);
	extra_vpemsg(emsg, p, args);
	va_end(args);
}


static void
trace_perf(const char *msg, const DCC_SRVR_ADDR *ap)
{
	DCC_SRVR_CLASS *class;
	char abuf[60];
	char rbuf[30];

	class = AP2CLASS(ap);
	if (!VALID_NAM(ap->nam_inx)
	    || class->nms[ap->nam_inx].rtt_adj == 0) {
		rbuf[0] = 0;
	} else if (ap->srvr_pkt_vers < DCC_PKT_VERS_CLNT_OK
		   && ap->srvr_id != DCC_ID_INVALID) {
		snprintf(rbuf, sizeof(rbuf), "%+d+%d",
			 class->nms[ap->nam_inx].rtt_adj/1000,
			 DCC_RTT_VERS_ADJ/1000);
	} else {
		snprintf(rbuf, sizeof(rbuf), "%+d",
			 class->nms[ap->nam_inx].rtt_adj/1000);
	}

	if (ap->rtt == DCC_RTT_BAD) {
		dcc_trace_msg("%s %s server %s with unknown RTT",
			      msg, DCC_IS_GREY_STR(class),
			      addr2str(abuf, sizeof(abuf), class,
				       class->gen, ap, 0));
	} else if (ap->total_xmits == 0) {
		dcc_trace_msg("%s %s server %s with %.2f%s ms RTT,"
			      " %d ms queue wait",
			      msg, DCC_IS_GREY_STR(class),
			      addr2str(abuf, sizeof(abuf), class,
				       class->gen, ap, 0),
			      ap->rtt/1000.0, rbuf,
			      ap->srvr_wait/1000);
	} else {
		dcc_trace_msg("%s %s server %s with %.0f%%"
			      " of %d requests answered,"
			      " %.2f%s ms RTT, %d ms queue wait",
			      msg, DCC_IS_GREY_STR(class),
			      addr2str(abuf, sizeof(abuf), class,
				       class->gen, ap, 0),
			      (ap->total_resps*100.0)/ap->total_xmits,
			      ap->total_xmits,
			      ap->rtt/1000.0, rbuf,
			      ap->srvr_wait/1000);
	}
}



/* If the socket isn't always connected, it can receive
 * datagrams from almost everywhere (for example, a DNS
 * datagram could leak-in if the local port range is small
 * and the local port has been recently doing DNS queries
 * in its previous life).
 *
 * If the socket is connected, it can still receive datagrams that do not
 * belong to the connection.  Besides random Internet garbage,
 * this can happen if the socket has been disconnected recently and there
 * was data in flight.
 *
 * Before complaining, check that this datagram seems to be a response
 * to something we sent */
static void DCC_PF(5,6)
trace_bad_packet(DCC_CLNT_CTXT *ctxt, const DCC_SOCKU *su,
		 const DCC_OP_RESP *resp, int resp_len, const char *p, ...)
{
	DCC_XLENT *xlent;
	va_list args;
	char msgbuf[80];
	char pktbuf[9*10];

	/* consider not complaining */
	if (!dcc_clnt_debug && ctxt && su) {
		for (xlent = ctxt->xl.entries; ; ++xlent) {
			/* forget the error message if not from a DCC server */
			if (xlent >= ctxt->xl.next)
				return;

			/* The packet could not be for a transmission
			 * that has already been answered or forgotten */
			if (xlent->flags & DCC_XLFG_ANS)
				continue;

			/* complain if the packet from this server */
			if (DCC_SU_EQ(su, &xlent->su))
				break;
		}
		xlent->flags |= (DCC_XLFG_ANS | DCC_XLFG_FAKE);
		xlent->delay_us = DCC_RTT_BAD;
	}

	va_start(args, p);
	vsnprintf(msgbuf, sizeof(msgbuf), p, args);
	va_end(args);
	dcc_error_msg("%s; %s", msgbuf,
		      hdr2str(pktbuf, sizeof(pktbuf), &resp->hdr, resp_len));
}



/* Compute the delay before the next retransmission
 *      It always should be long enough for the DCC server to do some disk
 *	operations even if the server and network have usually been faster. */
static int
retrans_time(int rtt, u_int xmit_num)
{
	u_int backoff;

	if (rtt < DCC_MIN_RTT)
		rtt = DCC_MIN_RTT;
	backoff = rtt << xmit_num;	/* exponential backoff */
	backoff += DCC_DCCD_DELAY;	/* varying server & network load */
	if (backoff > DCC_MAX_RTT)
		backoff = DCC_MAX_RTT;
	return backoff;
}



static void
get_start_time(DCC_CLNT_CTXT *ctxt)
{
	gettimeofday(&ctxt->start, 0);
	ctxt->now = ctxt->start;
	ctxt->now_us = 0;
}



static u_char				/* 1=ok, 0=time jumped */
get_now(DCC_EMSG *emsg, DCC_CLNT_CTXT *ctxt)
{
	struct timeval now;

	gettimeofday(&now, 0);
	ctxt->now_us = tv_diff2us(&now, &ctxt->start);
	if (ctxt->now_us < FOREVER_US && ctxt->now_us >= 0) {
		ctxt->now = now;
		return 1;
	}

	/* ignore tiny reverse time jumps on some systems such as BSD/OS 4.1 */
	if (ctxt->now_us < 0 && ctxt->now_us > -1000)
		return 1;

	dcc_pemsg(EX_OSERR, emsg,
		  "clock changed an impossible %.6f or %.6f seconds",
		  (ctxt->now_us*1.0)/DCC_US,
		  (ctxt->now.tv_sec - ctxt->start.tv_sec) * 1.0
		  + ((ctxt->now.tv_usec - ctxt->start.tv_usec)*1.0)/DCC_US);
	ctxt->now = ctxt->start;
	ctxt->now_us = 0;
	return 0;
}



static double
get_age(const DCC_CLNT_CTXT *ctxt)
{
	struct timeval now;

	gettimeofday(&now, 0);
	return tv_diff2us(&now, &ctxt->start)/(DCC_US*1.0);
}



#ifdef DCC_DEBUG_LOCKS
void
assert_info_locked(void)
{
	assert_ctxts_locked();
	if (!info_locked)
		dcc_logbad(EX_SOFTWARE, "don't have info locked");
}



void
assert_info_unlocked(void)
{
	if (info_locked)
		dcc_logbad(EX_SOFTWARE, "have info locked");
}
#endif


/* Unlock the shared memory for other processes.
 *      The contexts must be locked */
u_char					/* 0=failed 1=ok */
dcc_info_unlock(DCC_EMSG *emsg)
{
	assert_ctxts_locked();
	assert_info_locked();

#ifndef DCC_DEBUG_LOCKS
	if (!info_locked)
		return 1;
#endif
	info_locked = 0;
	return dcc_unlock_fd(emsg, info_fd, DCC_LOCK_ALL_FILE,
			     "info ", dcc_info_nm.c);
}



/* Lock the shared memory so we can read and perhaps change it
 *      The contexts must be locked */
u_char					/* 0=failed, 1=ok */
dcc_info_lock(DCC_EMSG *emsg)
{
	assert_ctxts_locked();

	if (info_locked) {
#ifdef DCC_DEBUG_LOCKS
		dcc_logbad(EX_SOFTWARE, "info already locked");
#else
		return 1;
#endif
	}

	if (!dcc_exlock_fd(emsg, info_fd, DCC_LOCK_ALL_FILE, 60,
			   "info ", dcc_info_nm.c))
		return 0;

	info_locked = 1;
	return 1;
}



static u_char
unmap_info(DCC_EMSG *emsg)
{
#ifdef DCC_WIN32
	dcc_win32_unmap(&info_map, dcc_clnt_info, dcc_info_nm.c);
#else
	if (0 > munmap((void *)dcc_clnt_info, sizeof(*dcc_clnt_info))) {
		dcc_pemsg(EX_OSERR, emsg, "munmap(%s): %s",
			  dcc_info_nm.c, ERROR_STR());
		dcc_clnt_info = 0;
		return 0;
	}
#endif
	dcc_clnt_info = 0;
	return 1;
}



/* Unmap and close the shared info
 *      The contexts must be locked but not the info */
u_char					/* 0=something wrong, 1=all over */
dcc_unmap_close_info(DCC_EMSG *emsg)	/* cleared of stale messages */
{
	u_char result = 1;

	assert_ctxts_locked();
	assert_info_unlocked();

	if (!dcc_clnt_info)
		return result;

	if (!unmap_info(emsg))
		result = 0;

	if (0 > close(info_fd)) {
		extra_pemsg(emsg, "close(%s): %s",
			    dcc_info_nm.c, ERROR_STR());
		result = 0;
	}
	info_fd = -1;

	return result;
}



/* discover our host ID if we do not already know it */
static u_char
get_clnt_hid(DCC_EMSG *emsg)
{
	struct timeval now;
	int i;
	u_char result;

	if (dcc_clnt_hid != 0)
		return 1;

#ifdef HAVE_GETHOSTID
	dcc_clnt_hid = gethostid();
#endif
	/* add the host name even if we have a hostid in case the hostid
	 * is a commonl used RFC 1918 IP address */
	if (0 > gethostname(dcc_clnt_hostname, sizeof(dcc_clnt_hostname)-1)) {
		dcc_pemsg(EX_NOHOST, emsg, "gethostname(): %s", ERROR_STR());
		/* do the best we can without a host name */
		gettimeofday(&now, 0);
		dcc_clnt_hid = now.tv_sec + now.tv_usec;
		result = 0;
	} else if (dcc_clnt_hostname[0] == '\0') {
		dcc_pemsg(EX_NOHOST, emsg, "null host name from gethostname()");
		/* do the best we can without a host name */
		gettimeofday(&now, 0);
		dcc_clnt_hid = now.tv_sec + now.tv_usec;
		result = 0;
	} else {
		for (i = 0; i < ISZ(dcc_clnt_hostname); ++i) {
			if (!dcc_clnt_hostname[i])
				break;
			dcc_clnt_hid += dcc_clnt_hostname[i]*i;
		}
		result = 1;
	}

	/* this should almost never happen, but it could */
	if (dcc_clnt_hid == 0)
		dcc_clnt_hid = 1;
	return result;
}



/* write a new DCC map file */
u_char
dcc_create_map(DCC_EMSG *emsg,
	       const char *map_nm0,
	       int *pfd,		/* leave open & unlocked FD here */
	       const DCC_SRVR_NM *dcc_nms, int dcc_nms_len,
	       const DCC_SRVR_NM *grey_nms, int grey_nms_len,
	       const DCC_IP *src4,
	       const DCC_IP *src6,
	       DCC_INFO_FGS info_fgs)	/* DCC_INFO_FG_* */
{
	static int op_nums_r;
	DCC_CLNT_INFO info_clear;
	int fd;
	u_char created;
	DCC_PATH map_nm;
	char sustr[DCC_SU2STR_SIZE];
	int i;

	if (pfd && (fd = *pfd) >= 0) {
		created = 0;
	} else {
		if (!dcc_fnm2abs(&map_nm, map_nm0, 0)) {
			dcc_pemsg(EX_IOERR, emsg, "long map name \"%s\"",
				  map_nm0);
			return 0;
		}
		fd = open(map_nm.c, O_RDWR|O_CREAT|O_EXCL, 0600);
		if (fd < 0) {
			dcc_pemsg(EX_IOERR, emsg, "open(%s): %s",
				  map_nm.c, ERROR_STR());
			return 0;
		}
		created = 1;
	}

	memset(&info_clear, 0, sizeof(info_clear));
	strcpy(info_clear.version, DCC_MAP_INFO_VERSION);

	if (dcc_nms_len != 0) {
		if (dcc_nms_len > DCC_MAX_SRVR_NMS)
			dcc_nms_len = DCC_MAX_SRVR_NMS;
		memcpy(info_clear.dcc.nms, dcc_nms,
		       sizeof(info_clear.dcc.nms[0])*dcc_nms_len);
	}
	info_clear.dcc.srvr_inx = NO_SRVR;

	if (grey_nms_len != 0) {
		if (grey_nms_len > DCC_MAX_SRVR_NMS)
			grey_nms_len = DCC_MAX_SRVR_NMS;
		memcpy(info_clear.grey.nms, grey_nms,
		       sizeof(info_clear.grey.nms[0])*grey_nms_len);
	}
	info_clear.grey.srvr_inx = NO_SRVR;

	if ((!src6 || src6->family == AF_UNSPEC)
	    && (src4 && src4->family == AF_INET6)) {
		src6 = src4;
		src4 = 0;
	}
	if (src4 && src4->family != AF_UNSPEC) {
		if (src4->family != AF_INET) {
			dcc_pemsg(EX_IOERR, emsg, "invalid IPv4 src %s in %s",
				  dcc_ip2str(sustr, sizeof(sustr), src4),
				  map_nm.c);
			return 0;
		}
		info_clear.src4.ip = *src4;
	}
	info_clear.src4.failed = 0;

	if (src6 != 0 && src6->family != AF_UNSPEC) {
		if (src6->family != AF_INET6) {
			dcc_pemsg(EX_IOERR, emsg, "invalid IPv6 src %s in %s",
				  dcc_ip2str(sustr, sizeof(sustr), src6),
				  map_nm.c);
			return 0;
		}
		info_clear.src6.ip = *src6;
	}
	info_clear.src6.failed = 0;

	info_clear.fgs = info_fgs;
#ifdef DCC_NO_IPV6
	info_clear.fgs |= DCC_INFO_FG_IPV6_OFF;
#endif
	if (!get_clnt_hid(emsg)) {
		close(fd);
		if (pfd)
			*pfd = -1;
		if (created)
			unlink(map_nm.c);
		return 0;
	}

	/* ensure that we have a new report ID even if we
	 * are repeatedly recreating a temporary map file */
	if (dcc_clnt_info)
		op_nums_r += dcc_clnt_info->proto_hdr.op_nums.r;
	info_clear.proto_hdr.op_nums.r = ++op_nums_r;

	i = write(fd, &info_clear, sizeof(info_clear));
	if (i != ISZ(info_clear)) {
		if (i < 0)
			dcc_pemsg(EX_SOFTWARE, emsg, "write(%s): %s",
				  map_nm.c, ERROR_STR());
		else
			dcc_pemsg(EX_IOERR, emsg,
				  "write(%s)=%d instead of %d",
				  map_nm.c, i, ISZ(info_clear));
		close(fd);
		if (pfd)
			*pfd = -1;
		if (created)
			unlink(map_nm.c);
		return 0;
	}

	if (created) {
		if (pfd)
			*pfd = fd;
		else
			close(fd);
	}
	return 1;
}



/* lock and read the contents of the old info file */
static int				/* -1=error, 0=wrong version, 1=done */
map_convert_start(DCC_EMSG *emsg,
		  void *old_info, int old_info_size,
		  const char *old_magic, int old_magic_size,
		  DCC_PATH *new_info_nm, const char *vstr)
{
	int i;

	assert_ctxts_locked();
	assert_info_unlocked();

	/* only one process or thread can fix the file so wait for
	 * exclusive access to the old file */
	if (!dcc_info_lock(emsg))
		return -1;

	i = read(info_fd, old_info, old_info_size);
	if (i != old_info_size) {
		if (i < 0) {
			dcc_pemsg(EX_IOERR, emsg, "read(%s): %s",
				  dcc_info_nm.c, ERROR_STR());
		} else {
			dcc_pemsg(EX_IOERR, emsg, "read(%s)=%d instead of %d",
				  dcc_info_nm.c, i, old_info_size);
		}
		dcc_info_unlock(0);
		return -1;
	}

	if (-1 == lseek(info_fd, SEEK_SET, 0)) {
		dcc_pemsg(EX_IOERR, emsg, "lseek(%s): %s",
			  dcc_info_nm.c, ERROR_STR());
		dcc_info_unlock(0);
		return -1;
	}

	if (memcmp(old_info, old_magic, old_magic_size)) {
		if (!dcc_info_unlock(emsg))
			return -1;
		if (dcc_clnt_debug)
			dcc_trace_msg("%s has the right length but wrong"
				      " magic for a version %s map file",
				      dcc_info_nm.c, vstr);
		return 0;
	}

	if (!dcc_fnm2rel(new_info_nm, dcc_info_nm.c, "-new")) {
		dcc_pemsg(EX_IOERR, emsg, "long map name \"%s\"",
			  dcc_info_nm.c);
		dcc_info_unlock(0);
		return -1;
	}
	unlink(new_info_nm->c);
	return 1;
}



/* the old file must be locked */
static int				/* -1=error, 1=done */
map_convert_fin(DCC_EMSG *emsg,
		const DCC_PATH *new_info_nm,
		const DCC_SRVR_NM *dcc_nms, int dcc_nms_len,
		const DCC_SRVR_NM *grey_nms, int grey_nms_len,
		const DCC_IP *src4, const DCC_IP *src6,
		DCC_INFO_FGS info_fgs)	/* DCC_INFO_FG_* */
{
	int new_fd;
#ifdef DCC_WIN32
	DCC_PATH old_info_nm;
#endif

	new_fd = -1;
	if (!dcc_create_map(emsg, new_info_nm->c, &new_fd,
			    dcc_nms, dcc_nms_len, grey_nms, grey_nms_len,
			    src4, src6, info_fgs)) {
		dcc_info_unlock(0);
		return -1;
	}

#ifdef DCC_WIN32
	/* there are at least two races here,
	 * but Windows does not allow renaming or unlinking (e.g. by
	 * rename()) open files */
	if (!dcc_fnm2rel(old_info_nm, dcc_info_nm.c, "-old")) {
		dcc_pemsg(EX_IOERR, emsg, "long map name \"%s\"",
			  dcc_info_nm.c);
		return -1;
	}
	unlink(old_info_nm.c);

	if (!dcc_info_unlock(emsg)) {
		close(new_fd);
		unlink(new_info_nm->c);
		return -1;
	}
	if (0 > close(info_fd)) {
		dcc_pemsg(EX_IOERR, emsg, "close(%s): %s",
			  dcc_info_nm.c, ERROR_STR());
		close(new_fd);
		unlink(new_info_nm->c);
		return -1;
	}
	info_fd = -1;

	if (0 > rename(dcc_info_nm.c, old_info_nm.c)) {
		dcc_pemsg(EX_IOERR, emsg, "rename(%s, %s): %s",
			  dcc_info_nm.c, old_info_nm.c, ERROR_STR());
		close(new_fd);
		unlink(new_info_nm->c);
		return -1;
	}

	close(new_fd);
	if (0 > rename(new_info_nm->c, dcc_info_nm.c)) {
		dcc_pemsg(EX_IOERR, emsg, "rename(%s, %s): %s",
			  new_info_nm->c, dcc_info_nm.c, ERROR_STR());
		unlink(new_info_nm->c);
		return -1;
	}
	return 1;
#else /* !DCC_WIN32 */
	/* if we are running as root,
	 * don't change the owner of the file */
	if (getuid() == 0
	    && 0 > fchown(new_fd, dcc_info_sb.st_uid, dcc_info_sb.st_gid)) {
		dcc_pemsg(EX_IOERR, emsg, "chown(%s,%d,%d): %s",
			  new_info_nm->c,
			  (int)dcc_info_sb.st_uid, (int)dcc_info_sb.st_gid,
			  ERROR_STR());
		unlink(new_info_nm->c);
		close(new_fd);
		return -1;
	}

	if (0 > rename(new_info_nm->c, dcc_info_nm.c)) {
		dcc_pemsg(EX_IOERR, emsg, "rename(%s, %s): %s",
			  new_info_nm->c, dcc_info_nm.c, ERROR_STR());
		unlink(new_info_nm->c);
		close(new_fd);
		return -1;
	}

	if (!dcc_info_unlock(emsg)) {
		close(new_fd);
		unlink(new_info_nm->c);
		return -1;
	}

	close(new_fd);
	return 1;
#endif /* DCC_WIN32 */
}



#ifdef DCC_MAP_INFO_VERSION_14
static const DCC_IP *
map_convert_v14_ip(DCC_IP *dst, const DCC_V14_IP *src)
{
	memset(dst, 0, sizeof(*dst));
	memcpy(&dst->u, &src->u, sizeof(dst->u));
	dst->scope_id = src->scope_id;
	dst->port = src->port;
	dst->family = src->family;
	return dst;
}



/* Convert an old map file.
 *      The contexts must be locked on entry.
 *      The old file may be locked on exit */
static int				/* -1=error, 0=wrong version, 1=done */
map_convert_v14(DCC_EMSG *emsg)
{
	DCC_PATH new_info_nm;
	DCC_V14_CLNT_INFO old;
	char old_magic[sizeof(old.version)] = DCC_MAP_INFO_VERSION_14;
	DCC_IP src4, src6;
	int i;

	if ((int)dcc_info_sb.st_size != ISZ(old))
		return 0;

	i = map_convert_start(emsg, &old, sizeof(old),
			      old_magic, sizeof(old_magic),
			      &new_info_nm, "14");
	if (i <= 0)
		return i;

	/* deal with Microsoft odd alignment */
	return map_convert_fin(emsg, &new_info_nm,
			       old.dcc.nms, DIM(old.dcc.nms),
			       old.grey.nms, DIM(old.grey.nms),
			       map_convert_v14_ip(&src4, &old.src4.ip),
			       map_convert_v14_ip(&src6, &old.src6.ip),
			       old.fgs);
}
#endif /* DCC_MAP_INFO_VERSION_14 */



#ifdef DCC_MAP_INFO_VERSION_13
/* Convert an old map file.
 *      The contexts must be locked on entry.
 *      The old file may be locked on exit */
static int				/* -1=error, 0=wrong version, 1=done */
map_convert_v13(DCC_EMSG *emsg)
{
	DCC_PATH new_info_nm;
	DCC_V13_CLNT_INFO old;
	char old_magic[sizeof(old.version)] = DCC_MAP_INFO_VERSION_13;
	DCC_IP src;
	int i;

	if ((int)dcc_info_sb.st_size != ISZ(old))
		return 0;

	i = map_convert_start(emsg, &old, sizeof(old),
			      old_magic, sizeof(old_magic),
			      &new_info_nm, "13");
	if (i <= 0)
		return i;

	return map_convert_fin(emsg, &new_info_nm,
			       old.dcc.nms, DIM(old.dcc.nms),
			       old.grey.nms, DIM(old.grey.nms),
			       map_convert_v14_ip(&src, &old.src),
			       0, old.fgs);
}
#endif /* DCC_MAP_INFO_VERSION_13 */



#ifdef DCC_MAP_INFO_VERSION_12
/* convert names from version #12 and preceding */
static void
map_convert_v12_nms(DCC_SRVR_NM new_nms[DCC_MAX_SRVR_NMS],
		    const DCC_V12_SRVR_NM old_nms[DCC_MAX_SRVR_NMS])
{
	int i;

	memset(new_nms, 0, sizeof(DCC_SRVR_NM)*DCC_MAX_SRVR_NMS);
	for (i = 0; i < DCC_MAX_SRVR_NMS; ++i) {
		new_nms[i].clnt_id = old_nms[i].clnt_id;
		new_nms[i].port = old_nms[i].port;
		STRLCPY(new_nms[i].hostname, old_nms[i].hostname,
			sizeof(new_nms[i].hostname));
		memcpy(new_nms[i].passwd, old_nms[i].passwd,
		       sizeof(new_nms[i].passwd));
		new_nms[i].rtt_adj = old_nms[i].rtt_adj;
	}
}



/* Convert an old map file.
 *      The contexts must be locked on entry.
 *      The old file may be locked on exit */
static int				/* -1=error, 0=wrong version, 1=done */
map_convert_v12(DCC_EMSG *emsg)
{
	DCC_PATH new_info_nm;
	DCC_V12_CLNT_INFO old;
	char old_magic[sizeof(old.version)] = DCC_MAP_INFO_VERSION_12;
	DCC_SRVR_NM new_nms[DCC_MAX_SRVR_NMS];
	DCC_SRVR_NM grey_nms[DCC_MAX_SRVR_NMS];
	DCC_IP src;
	int i;

	if ((int)dcc_info_sb.st_size != ISZ(old))
		return 0;

	i = map_convert_start(emsg, &old, sizeof(old),
			      old_magic, sizeof(old_magic),
			      &new_info_nm, "12");
	if (i <= 0)
		return i;

	map_convert_v12_nms(new_nms, old.dcc.nms);
	map_convert_v12_nms(grey_nms, old.grey.nms);

	return map_convert_fin(emsg, &new_info_nm,
			       new_nms, DIM(new_nms), grey_nms, DIM(grey_nms),
			       map_convert_v14_ip(&src, &old.src),
			       0, old.fgs);
}
#endif /* DCC_MAP_INFO_VERSION_12 */



#ifdef DCC_MAP_INFO_VERSION_11
static DCC_INFO_FGS
map_convert_v11_info_fgs(u_char old_flags)
{
	DCC_INFO_FGS new_fgs;

	new_fgs = 0;
	if (old_flags & DCC_V11_INFO_FG_SOCKS)
		new_fgs |= DCC_INFO_FG_SOCKS;
	if (old_flags & DCC_V11_INFO_FG_TMP)
		new_fgs |= DCC_INFO_FG_TMP;

	return new_fgs;
}



static DCC_IP *
map_convert_v11_src(DCC_IP *ip, const DCC_V11_IP *v11_ip)
{
	if (v11_ip->family == AF_UNSPEC) {
		memset(ip, 0, sizeof(*ip));
	} else {
		ip->family = v11_ip->family;
		memcpy(&ip->u, &v11_ip->u, sizeof(ip->u));
		ip->scope_id = 0;
	}
	ip->port = v11_ip->port;

	return ip;
}



/* Convert an old map file.
 *      The contexts must be locked on entry.
 *      The old file may be locked on exit */
static int				/* -1=error, 0=wrong version, 1=done */
map_convert_v11(DCC_EMSG *emsg)
{
	DCC_PATH new_info_nm;
	DCC_V11_CLNT_INFO old;
	char old_magic[sizeof(old.version)] = DCC_MAP_INFO_VERSION_11;
	DCC_SRVR_NM new_nms[DCC_MAX_SRVR_NMS];
	DCC_SRVR_NM grey_nms[DCC_MAX_SRVR_NMS];
	DCC_IP src;
	int i;

	if ((int)dcc_info_sb.st_size != ISZ(old))
		return 0;

	i = map_convert_start(emsg, &old, sizeof(old),
			      old_magic, sizeof(old_magic),
			      &new_info_nm, "11");
	if (i <= 0)
		return i;

	map_convert_v12_nms(new_nms, old.dcc.nms);
	map_convert_v12_nms(grey_nms, old.grey.nms);

	return map_convert_fin(emsg, &new_info_nm,
			       new_nms, DIM(new_nms), grey_nms, DIM(grey_nms),
			       map_convert_v11_src(&src, &old.src), 0,
			       map_convert_v11_info_fgs(old.flags));
}
#endif /* DCC_MAP_INFO_VERSION_11 */



#ifdef DCC_MAP_INFO_VERSION_10
/* convert names from version #10 and preceding */
static void
map_convert_v10_nms(DCC_SRVR_NM new_nms[DCC_MAX_SRVR_NMS],
		    const DCC_V10_SRVR_NM old_nms[DCC_MAX_SRVR_NMS])
{
	int i;

	memset(new_nms, 0, sizeof(DCC_SRVR_NM)*DCC_MAX_SRVR_NMS);
	for (i = 0; i < DCC_MAX_SRVR_NMS; ++i) {
		new_nms[i].clnt_id = old_nms[i].clnt_id;
		new_nms[i].port = old_nms[i].port;
		STRLCPY(new_nms[i].hostname, old_nms[i].hostname,
			sizeof(new_nms[i].hostname));
		memcpy(new_nms[i].passwd, old_nms[i].passwd,
		       sizeof(new_nms[i].passwd));
		new_nms[i].rtt_adj = old_nms[i].rtt_adj;
	}
}



/* Convert an old map file.
 *      The contexts must be locked on entry.
 *      The old file may be locked on exit */
static int				/* -1=error, 0=wrong version, 1=done */
map_convert_v10(DCC_EMSG *emsg)
{
	DCC_PATH new_info_nm;
	DCC_V10_CLNT_INFO old;
	char old_magic[sizeof(old.version)] = DCC_MAP_INFO_VERSION_10;
	DCC_SRVR_NM new_nms[DCC_MAX_SRVR_NMS];
	DCC_SRVR_NM grey_nms[DCC_MAX_SRVR_NMS];
	DCC_IP src;
	int i;

	if ((int)dcc_info_sb.st_size != ISZ(old))
		return 0;

	i = map_convert_start(emsg, &old, sizeof(old),
			      old_magic, sizeof(old_magic),
			      &new_info_nm, "10");
	if (i <= 0)
		return i;

	map_convert_v10_nms(new_nms, old.dcc.nms);
	map_convert_v10_nms(grey_nms, old.grey.nms);

	return map_convert_fin(emsg, &new_info_nm,
			       new_nms, DIM(new_nms), grey_nms, DIM(grey_nms),
			       map_convert_v11_src(&src, &old.src), 0,
			       map_convert_v11_info_fgs(old.flags));
}
#endif /* DCC_MAP_INFO_VERSION_10 */



#ifdef DCC_MAP_INFO_VERSION_9
/* Convert an old map file.
 *      The contexts must be locked on entry.
 *      The old file may be locked on exit */
static int				/* -1=error, 0=wrong version, 1=done */
map_convert_v9(DCC_EMSG *emsg)
{
	DCC_PATH new_info_nm;
	DCC_V9_CLNT_INFO old;
	char old_magic[sizeof(old.version)] = DCC_MAP_INFO_VERSION_9;
	DCC_SRVR_NM nms[DCC_MAX_SRVR_NMS];
	DCC_SRVR_NM grey_nms[DCC_MAX_SRVR_NMS];
	DCC_IP src;
	int i;

	if ((int)dcc_info_sb.st_size != ISZ(old))
		return 0;

	i = map_convert_start(emsg, &old, sizeof(old),
			      old_magic, sizeof(old_magic),
			      &new_info_nm, "9");
	if (i <= 0)
		return i;

	map_convert_v10_nms(nms, old.dcc.nms);
	map_convert_v10_nms(grey_nms, old.grey.nms);

	return map_convert_fin(emsg, &new_info_nm,
			       nms, DIM(nms), grey_nms, DIM(grey_nms),
			       map_convert_v11_src(&src, &old.src), 0,
			       map_convert_v11_info_fgs(old.flags));
}
#endif /* DCC_MAP_INFO_VERSION_9 */



#ifdef DCC_MAP_INFO_VERSION_8
/* Convert an old map file.
 *      The contexts must be locked on entry.
 *      The old file may be locked on exit */
static int				/* -1=error, 0=wrong version, 1=done */
map_convert_v8(DCC_EMSG *emsg)
{
	DCC_PATH new_info_nm;
	DCC_V8_CLNT_INFO old;
	char old_magic[sizeof(old.version)] = DCC_MAP_INFO_VERSION_8;
	DCC_SRVR_NM new_nms[DCC_MAX_SRVR_NMS];
	DCC_SRVR_NM grey_nms[DCC_MAX_SRVR_NMS];
	int i;

	if ((int)dcc_info_sb.st_size != ISZ(old))
		return 0;

	i = map_convert_start(emsg, &old, sizeof(old),
			      old_magic, sizeof(old_magic),
			      &new_info_nm, "8");
	if (i <= 0)
		return i;

	map_convert_v10_nms(new_nms, old.dcc.nms);
	map_convert_v10_nms(grey_nms, old.grey.nms);

	return map_convert_fin(emsg, &new_info_nm,
			       new_nms, DIM(new_nms), grey_nms, DIM(grey_nms),
			       0, 0, map_convert_v11_info_fgs(old.flags));
}
#endif /* DCC_MAP_INFO_VERSION_8 */



/* convert from a previous version
 *	The contexts must be locked.  The old file must be open and unlocked */
static u_char
map_convert(DCC_EMSG *emsg)
{
	static int (* const convert[])(DCC_EMSG*) = {
		map_convert_v8, map_convert_v9, map_convert_v10,
		map_convert_v11, map_convert_v12, map_convert_v13,
		map_convert_v14
	};
	int i, f;

	assert_ctxts_locked();
	assert_info_unlocked();

	for (f = 0; f < DIM(convert); ++f) {
		i = convert[f](emsg);
		if (i < 0) {
			dcc_unmap_close_info(0);
			return 0;
		}
		/* unlock old file and open & lock new file */
		if (i > 0)
			return 1;
	}

	dcc_pemsg(EX_DATAERR, emsg, "%s is not a DCC map file", dcc_info_nm.c);
	close(info_fd);
	info_fd = -1;
	return 0;
}



/* Ensure the shared information is available, but do not lock it.
 *      The contexts must be locked
 *      SUID privileges are often released */
u_char
dcc_map_info(DCC_EMSG *emsg,		/* cleared of stale messages */
	     const char *new_info_nm, int new_info_fd)
{
#ifndef DCC_WIN32
	void *p;
#endif

	for (;;) {
		assert_ctxts_locked();
		assert_info_unlocked();

		/* work only if needed */
		if (!(new_info_nm && strcmp(new_info_nm, dcc_info_nm.c))
		    && new_info_fd < 0
		    && dcc_clnt_info)
			return 1;

		if (!dcc_unmap_close_info(emsg)) {
			if (new_info_fd >= 0)
				close(new_info_fd);
			return 0;
		}

		if (new_info_nm) {
			if (!dcc_fnm2abs(&dcc_info_nm, new_info_nm, 0)) {
				dcc_pemsg(EX_IOERR, emsg, "bad map name \"%s\"",
					  new_info_nm);
				return 0;
			}
			/* don't change name if we convert the file
			 * and so come back here */
			new_info_nm = 0;
		}
		if (dcc_info_nm.c[0] == '\0') {
			dcc_pemsg(EX_USAGE, emsg, "missing map file name");
			return 0;
		}

		if (new_info_fd >= 0) {
			info_fd = new_info_fd;
			new_info_fd = -1;
		} else {
			info_fd = open(dcc_info_nm.c, O_RDWR, 0600);
#ifndef DCC_WIN32
			if (info_fd < 0
			    && dcc_get_priv_home(dcc_info_nm.c)) {
				info_fd = open(dcc_info_nm.c, O_RDWR, 0600);
				dcc_rel_priv();
			}
#endif
			if (info_fd < 0) {
				dcc_pemsg(EX_NOINPUT, emsg, "open(%s): %s",
					  dcc_info_nm.c, ERROR_STR());
				return 0;
			}
		}

		/* refuse to use the file if it is not private */
		if (!dcc_ck_private(emsg, &dcc_info_sb,
				    dcc_info_nm.c, info_fd)) {
			dcc_unmap_close_info(0);
			return 0;
		}

		if ((int)dcc_info_sb.st_size != ISZ(*dcc_clnt_info)) {
			if (map_convert(emsg))
				continue;
			return 0;
		}

#ifdef DCC_WIN32
		dcc_clnt_info = dcc_win32_map(emsg, &info_map, dcc_info_nm.c,
					      info_fd, sizeof(*dcc_clnt_info));
		if (!dcc_clnt_info) {
			close(info_fd);
			info_fd = -1;
			return 0;
		}
#else

		/* don't give it to children */
		if (0 > fcntl(info_fd, F_SETFD, FD_CLOEXEC)) {
			dcc_pemsg(EX_IOERR, emsg,
				  "fcntl(F_SETFD FD_CLOEXEC %s): %s",
				  dcc_info_nm.c, ERROR_STR());
			close(info_fd);
			info_fd = -1;
			return 0;
		}

		p = mmap(0, sizeof(*dcc_clnt_info),
			 PROT_READ|PROT_WRITE, MAP_SHARED, info_fd, 0);
		if (p == MAP_FAILED) {
			dcc_pemsg(EX_IOERR, emsg, "mmap(%s): %s",
				  dcc_info_nm.c, ERROR_STR());
			close(info_fd);
			info_fd = -1;
			return 0;
		}
		dcc_clnt_info = p;
#endif /* DCC_WIN32 */

		if (!strncmp(dcc_clnt_info->version, DCC_MAP_INFO_VERSION,
			     sizeof(dcc_clnt_info->version))) {
			/* The file is the right version.  Set our ID in case
			 * it has been copied from another system */
			if (!get_clnt_hid(emsg))
				return 0;
			dcc_clnt_info->proto_hdr.op_nums.h = dcc_clnt_hid;

			return 1;
		}

		unmap_info(0);
		if (!map_convert(emsg))
			return 0;
	}
}



/* SUID privileges are often released */
u_char					/* 0=something wrong, 1=mapped */
dcc_map_lock_info(DCC_EMSG *emsg,	/* cleared of stale messages */
		  const char *new_info_nm,
		  int new_info_fd)
{
	if (!dcc_map_info(emsg, new_info_nm, new_info_fd))
		return 0;

	if (!dcc_info_lock(emsg))
		return 0;

	return 1;
}



/* All servers are broken, so make a note to not try for a while.
 *      The contexts and the mapped information must be locked */
static void
fail_more(const DCC_CLNT_CTXT *ctxt, DCC_SRVR_CLASS *class)
{
	assert_info_locked();

	/* do not inflate the delay if we are already delaying */
	if (class->fail_exp != 0
	    && TIME_T(class->fail_time) >= ctxt->now.tv_sec)
		return;

	/* reset the backoff after a long quiet time */
	if (ctxt->now.tv_sec >= (TIME_T(class->fail_time)
				 + (DCC_INIT_FAIL_SECS << class->fail_exp)))
		class->fail_exp = 0;

	if (++class->fail_exp > DCC_MAX_FAIL_EXP)
		class->fail_exp = DCC_MAX_FAIL_EXP;
	class->fail_time = (ctxt->now.tv_sec
			    + (DCC_INIT_FAIL_SECS << class->fail_exp));

	/* force RTT measurement after the failure backoff */
	class->measure = 0;
}



static u_char				/* 0=failing */
ck_fail_time(DCC_EMSG *emsg, DCC_CLNT_CTXT *ctxt, DCC_SRVR_CLASS *class)
{
	int dt;

	assert_info_locked();

	if (class->fail_exp == 0)
		return 1;

	dt = TIME_T(class->fail_time) - ctxt->now.tv_sec;
	if (dt > 0 && dt <= DCC_MAX_FAIL_SECS) {
		dcc_pemsg(EX_IOERR, emsg,
			  "continue not asking %s %d seconds after %d failures",
			  DCC_IS_GREY_STR(class), dt, class->fail_exp);
		return 0;
	}

	return 1;
}



static void
dcc_force_measure_rtt_class(DCC_SRVR_CLASS *class)
{
	class->fail_exp = 0;		/* stop giving up */
	class->resolve = 0;		/* force name resolution */
	class->srvr_inx = NO_SRVR;
	class->measure = 0;		/* force RTT measurement */
}



void
dcc_force_measure_rtt(u_char new_src)
{
	assert_info_locked();
	dcc_force_measure_rtt_class(&dcc_clnt_info->dcc);
	dcc_force_measure_rtt_class(&dcc_clnt_info->grey);
	if (new_src) {
		dcc_clnt_info->src4.failed = 0;
		dcc_clnt_info->src6.failed = 0;
	}
}



static void DCC_PF(2,3)
pick_fail(DCC_EMSG *emsg, const char *p, ...)
{
	va_list args;

	if (!emsg || emsg->c[0] == '\0') {
		flush_emsg(emsg);

		va_start(args, p);
		dcc_vpemsg(EX_NOHOST, emsg, p, args);
		va_end(args);

	} else if (dcc_clnt_debug > 1) {
		va_start(args, p);
		extra_vpemsg(emsg, p, args);
		va_end(args);
	}
}



/* pick the best server
 *      The client information and the contexts must be exclusively locked. */
static u_char				/* 0=none or none good */
pick_srvr(DCC_EMSG *emsg,
	  DCC_SRVR_CLASS *class,
	  u_char complain)
{
	const DCC_SRVR_ADDR *ap, *min_ap;
	int rtt;
	int min_rtt;			/* smallest RTT	*/
	int min2_rtt;			/* second smallest RTT */
	SRVR_INX old_srvr_inx;

	assert_info_locked();

	old_srvr_inx = class->srvr_inx;
	class->srvr_inx = NO_SRVR;
	if (class->num_srvrs == 0) {
		if (complain) {
			if (class->nms[0].hostname[0] == '\0')
				pick_fail(emsg, "no %s server names",
					  DCC_IS_GREY_STR(class));
			else
				pick_fail(emsg, "no %s server addresses for %s",
					  DCC_IS_GREY_STR(class),
					  class->nms[0].hostname);
		}
		return 0;
	}

	min2_rtt = min_rtt = DCC_RTT_BAD*2;
	min_ap = 0;
	ap = &class->addrs[class->num_srvrs];
	while (ap > class->addrs) {
		--ap;
		if (!VALID_NAM(ap->nam_inx))
			continue;

		rtt = effective_rtt(class, ap);
		if (min_rtt > rtt) {
			if (min2_rtt > min_rtt)
				min2_rtt = min_rtt;
			min_rtt = rtt;
			min_ap = ap;
		} else if (min2_rtt > rtt) {
			min2_rtt = rtt;
		}
	}

	if (min_ap) {
		/* found a server */
		class->srvr_inx = (min_ap - class->addrs);
		if (class->srvr_inx != old_srvr_inx) {
			if (dcc_clnt_debug > 1 &&
			    VALID_SRVR(class, old_srvr_inx)) {
				flush_emsg(emsg);
				trace_perf("replacing",
					   &class->addrs[old_srvr_inx]);
				trace_perf("pick", min_ap);
			}
		}
	}

	if (min_rtt < DCC_RTT_BAD) {
		/* found a good server
		 *
		 * Compute the basic RTT to the server including a variance */
		class->base_rtt = min_rtt + DCC_DCCD_DELAY;
		if (class->base_rtt > DCC_MAX_RTT)
			class->base_rtt = DCC_MAX_RTT;
		/* Decide how bad the server must get before we check for
		 *	an alternative.
		 * If there is no good second choice, there is no point in a
		 *	threshold for switching to it */
		class->thold_rtt = min2_rtt + DCC_DCCD_DELAY;
		if (class->thold_rtt >= DCC_MAX_RTT)
			class->thold_rtt = DCC_RTT_BAD;

		return 1;
	}

	/* we failed to find a working server
	 *
	 * If there is not yet a reason for the failure, make one.
	 * If debugging, say something unless this is a new name. */
	if (complain && (!emsg || emsg->c[0] == '\0' || dcc_clnt_debug)) {
		char atstr[(DCC_SU2STR_SIZE+1+5+1)*3];
		const char *s, *h0;
		int l;

		if (str2su(0, class->nms[0].hostname)) {
			h0 = "";
			s = "";
		} else {
			h0 = class->nms[0].hostname;
			s = class->nms[1].hostname[0] ? "s " : " ";
		}

		l = dcc_ap2str_opt(atstr, sizeof(atstr), class, 0, '\0');
		if (class->num_srvrs > 1 && l < ISZ(atstr)-2) {
			atstr[l++] = ' ';
			l += dcc_ap2str_opt(&atstr[l], sizeof(atstr)-l,
					    class, 1, '\0');
		}
		if (class->num_srvrs > 2 && l < ISZ(atstr)-2) {
			atstr[l++] = ' ';
			dcc_ap2str_opt(&atstr[l], sizeof(atstr)-l,
				       class, 1, '\0');
		}
		pick_fail(emsg,
			  "no working %s server%s%s%s%s%s%s%s"
			  " at %s%s",
			  DCC_IS_GREY_STR(class),
			  s, h0,
			  class->nms[1].hostname[0] ? " " : "",
			  class->nms[1].hostname,
			  class->nms[2].hostname[0] ? " " : "",
			  class->nms[2].hostname,
			  class->nms[3].hostname[0] ? " ..." : "",

			  atstr,
			  class->num_srvrs > 3 ? " ..." : "");
	}
	return 0;
}



/* count IP addresses per host name and per second level domain name */
typedef struct name_addrs {
    const char *sld;			/* domain name */
    u_char     sld_addrs;		/* # of addresses for domain name */
    u_char     host_addrs;		/* # of addresses for a host name */
    u_char     sld_addrs_inx;
} NAME_ADDRS[DCC_MAX_SRVR_NMS];


/* delete an address from a growing list of addresses */
static void
del_new_addr(DCC_SRVR_CLASS *class,
	     NAME_ADDRS name_addrs,	/* addresses per server name */
	     int tgt)			/* delete this address */
{
	NAM_INX nam_inx;
	int i;

	/* adjust that host's and domain's numbers of addresses and our
	 * total number of addresses */
	nam_inx = class->addrs[tgt].nam_inx;
	--name_addrs[nam_inx].host_addrs;
	--name_addrs[name_addrs[nam_inx].sld_addrs_inx].sld_addrs;
	--class->num_srvrs;

	/* slide the array of addresses to get rid of the discarded address */
	i = class->num_srvrs - tgt;
	if (i > 0)
		memmove(&class->addrs[tgt], &class->addrs[tgt+1],
			i * sizeof(class->addrs[0]));
	memset(&class->addrs[class->num_srvrs], 0, sizeof(class->addrs[0]));
}



/* impose arbitrary local order on IP addresses */
#define DCC_SRVRS_MOD	    16381

static inline u_int
su_srvrs_mod(const DCC_SOCKU *sup)
{
	u_int su_res;

	if (sup->sa.sa_family == AF_INET) {
		su_res = sup->ipv4.sin_addr.s_addr % DCC_SRVRS_MOD;
		su_res *= dcc_clnt_info->residue;
		su_res %= DCC_SRVRS_MOD;
		su_res += DCC_SRVRS_MOD;    /* distinguish IPv4 from IPv6 */
	} else {
		su_res = (sup->ipv6.sin6_addr.s6_addr32[0] % DCC_SRVRS_MOD
			  + sup->ipv6.sin6_addr.s6_addr32[1] % DCC_SRVRS_MOD
			  + sup->ipv6.sin6_addr.s6_addr32[2] % DCC_SRVRS_MOD
			  + sup->ipv6.sin6_addr.s6_addr32[3] % DCC_SRVRS_MOD);
		su_res *= dcc_clnt_info->residue;
		su_res %= DCC_SRVRS_MOD;
	}
	return su_res;
}



/* partially order a pair of IP addresses with a reasonably unique ordering */
static int
sucmp(const DCC_SOCKU *sup1, const DCC_SOCKU *sup2)
{
	u_int su1_res, su2_res;
	int i;

	su1_res = su_srvrs_mod(sup1);
	su2_res = su_srvrs_mod(sup2);

	i = (int)su1_res - (int)su2_res;
	if (i)
		return i;
	return memcmp(sup1, sup2, sizeof(DCC_SOCKU));
}



/* Deal with a list of IP addresses or aliases for one DCC server host name.
 *	The contexts and the mmap()'ed info must be locked
 *	dcc_host_addrs is trashed */
static void
copy_addrs(DCC_SRVR_CLASS *class,
	   const DCC_SRVR_NM *nmp,	/* server name being resolved */
	   const int nam_inx,
	   NAME_ADDRS name_addrs)	/* addresses per server name */
{
	DCC_SRVR_ADDR *ap;
	const DCC_SRVR_NM *nmp2;
	DCC_SOCKU *np, *nxt;
	const DCC_SOCKU *prev;
	int i, j, k;

	/* Keep as many IP addresses as we have room, but for as many
	 * named servers as possible
	 * Sort the addresses to keep our list stable when we re-check.
	 * Otherwise, we would start from scratch when nothing changes
	 * but the order of responses from a DNS server.
	 * Sort by residue class to pick a random subset when there
	 * are too many servers to fit in our list. */

	for (nxt = 0; ; nxt->sa.sa_family = AF_UNSPEC) {
		/* Pick the next address in the newly resolved list
		 * to consider.  We want the smallest address larger
		 * than the previous address we considered.
		 * "Smallest" is defined using the local random ordering
		 * of addresses. */
		prev = nxt;
		nxt = 0;
		for (np = dcc_hostaddrs; np < dcc_hostaddrs_end; ++np) {
			if (np->sa.sa_family == AF_UNSPEC)
				continue;
			DCC_SU_PORT(np) = nmp->port;
			if ((!prev || sucmp(np, prev) > 0)
			    && (!nxt || sucmp(nxt, np) > 0))
				nxt = np;
		}
		/* quit if we've considered them all */
		if (!nxt)
			return;

		/* ignore duplicate IP addresses even for other host names,
		 * unless the port numbers differ */
		ap = &class->addrs[class->num_srvrs];
		while (--ap >= class->addrs) {
			if (DCC_SU_IP_EQ(nxt, &ap->ip)) {
				/* they are the same, so keep the one with
				 * the non-anonymous ID
				 * or smallest RTT adjustment */
				nmp2 = &class->nms[ap->nam_inx];
				i = (nmp->clnt_id == DCC_ID_ANON);
				j = (nmp2->clnt_id == DCC_ID_ANON);
				if (i != j) {
					/* one is anonymous & other is not */
					if (i)
					    goto next_addr;
				} else {
					/* pick smallest RTT adjustment */
					if (nmp->rtt_adj >= nmp2->rtt_adj)
					    goto next_addr;
				}
				/* delete the previous instance */
				del_new_addr(class, name_addrs,
					     ap - class->addrs);
				break;
			}
		}

		/* If we already have as many addresses as we will use,
		 * then pick one to discard. Discard the last address of
		 * the host in the second level domain with the most
		 * addresses but without eliminating all addresses for any
		 * host name.  Look for the domain with the most IP addresses
		 * and that has at least one host with at least two
		 * addersses. */
		if (class->num_srvrs == DCC_MAX_SRVR_ADDRS) {
			int host_max, sld_max;
			NAM_INX nam1_inx, sld1_inx, sld2_inx;

			host_max = -1;
			sld_max = -1;
			nam1_inx = NO_NAM;
			sld1_inx = NO_NAM;
			for (i = 0; i <= nam_inx; i++) {
				/* ignore hosts with only 1 IP address */
				j = name_addrs[i].host_addrs;
				if (j <= 1)
					continue;
				sld2_inx = name_addrs[i].sld_addrs_inx;
				k = name_addrs[sld2_inx].sld_addrs;
				if (sld_max <= k) {
					if (sld1_inx != sld2_inx) {
					    sld_max = k;
					    sld1_inx = sld2_inx;
					    host_max = j;
					    nam1_inx = i;
					} else if (host_max <= j) {
					    host_max = j;
					    nam1_inx = i;
					}
				}
			}
			/* no additional IP addresses for the target host if
			 * it has the most IP addresses */
			if (nam1_inx == nam_inx)
				return;

			/* find the last address of the host with the most */
			for (i = 0, j = 0; i < class->num_srvrs; i++) {
				if (class->addrs[i].nam_inx == nam1_inx)
					j = i;
			}
			/* and delete it */
			del_new_addr(class, name_addrs, j);
		}

		/* install the new address in the growing list */
		ap = &class->addrs[class->num_srvrs];
		ap->rtt = DCC_RTT_BAD;

		dcc_su2ip(&ap->ip, nxt);

		/* preserve what we already knew about this address if
		 * it is previously known */
		for (i = 0; i < class->num_srvrs; ++i) {
			if (DCC_SU_IP_EQ(nxt, &class->addrs[i].ip)) {
				*ap = class->addrs[i];
				break;
			}
		}
		ap->nam_inx = nam_inx;
		++class->num_srvrs;

		++name_addrs[nam_inx].host_addrs;
		++name_addrs[name_addrs[nam_inx].sld_addrs_inx].sld_addrs;
next_addr:;
	}
}



/* resolve one server name into a scratch array of addresses */
static void
resolve_nm(DCC_EMSG *emsg,
	   DCC_SRVR_CLASS *class,
	   int nm_inx,			/* name being resolved */
	   NAME_ADDRS name_addrs,	/* addresses per server name */
	   DCC_GETH use_ipv46)
{
	DCC_SRVR_NM *nmp;
	const char *domain, *p1, *p2;
	int error;
	u_char result;
	int i;

	nmp = &class->nms[nm_inx];
	nmp->defined = 0;
	if (nmp->hostname[0] == '\0')
		return;

	if (nmp->rtt_adj > DCC_RTT_ADJ_MAX)
		nmp->rtt_adj = DCC_RTT_ADJ_MAX;
	else if (nmp->rtt_adj < -DCC_RTT_ADJ_MAX)
		nmp->rtt_adj = -DCC_RTT_ADJ_MAX;

	/* find the total number of addresses for this domain name,
	 * if it is a name instead of an IPv4 or IPv6 address */
	domain = nmp->hostname;
	name_addrs[nm_inx].sld = domain;
	dcc_host_lock();
	if (str2su(&dcc_hostaddrs[0], domain)) {
		if ((dcc_hostaddrs[0].sa.sa_family == AF_INET
		     && use_ipv46 != DCC_GETH_V6)
		    || (dcc_hostaddrs[0].sa.sa_family == AF_INET6
			&& use_ipv46 != DCC_GETH_V4))
			dcc_hostaddrs_end = &dcc_hostaddrs[1];
		else
			dcc_hostaddrs_end = &dcc_hostaddrs[0];
		name_addrs[nm_inx].sld_addrs_inx = nm_inx;
	} else {
		p1 = strchr(domain, '.');
		if (p1) {
			for (;;) {
				p2 = strchr(++p1, '.');
				if (!p2)
					break;
				domain = p1;
				p1 = p2;
			}
		}
		for (i = 0; i < nm_inx; ++i) {
			if (name_addrs[i].sld != 0
			    && !strcmp(domain, name_addrs[i].sld))
				break;
		}
		name_addrs[nm_inx].sld_addrs_inx = i;

		if (dcc_clnt_info->fgs & DCC_INFO_FG_SOCKS) {
			result = dcc_get_host_SOCKS(nmp->hostname, use_ipv46,
						    &error);
		} else {
			result = dcc_get_host(nmp->hostname, use_ipv46, &error);
		}
		if (!result) {
			flush_emsg(emsg);
			dcc_pemsg(EX_NOHOST, emsg, "%s: %s",
				  nmp->hostname, H_ERROR_STR1(error));
			dcc_host_unlock();
			return;
		}
	}

	if (dcc_hostaddrs_end != &dcc_hostaddrs[0]) {
		nmp->defined = 1;
		copy_addrs(class, nmp, nm_inx, name_addrs);
	}
	dcc_host_unlock();
}



/* resolve server host names again
 *      both locks must be held on entry
 *      both will be released while working
 *      on success, both are held
 *      on failure only the contexts are locked
 */
static u_char				/* 0=no good addresses, 1=at least 1 */
resolve_nms(DCC_EMSG *emsg, DCC_CLNT_CTXT *ctxt, DCC_SRVR_CLASS *cur)
{
	DCC_SRVR_CLASS new;
	DCC_GETH use_ipv46;
	int nm_inx, a_inx;
	NAME_ADDRS name_addrs;
	DCC_SRVR_ADDR *new_ap, *cur_ap;
	u_char have_src4, have_src6;

	assert_info_locked();

	/* if we have at least one IP address
	 * let the special thread do the waiting */
	if (cur->num_srvrs != 0 && dcc_clnt_wake_resolve())
		return 1;

	if (dcc_clnt_debug > 1)
		dcc_trace_msg("resolve %s server host names",
			      DCC_IS_GREY_STR(cur));

#ifdef DCC_NO_IPV6
	if (!(dcc_clnt_info->fgs & DCC_INFO_FG_IPV6_OFF)) {
		dcc_clnt_info->fgs |= DCC_INFO_FG_IPV6_OFF;
		dcc_clnt_info->fgs &= ~DCC_INFO_FG_IPV4_OFF;
	}
#endif

	/* try not to resolve names too often
	 * and discourage other processes and threads from resolving
	 * or measuring RTTs until we finish */
	cur->resolve = ctxt->now.tv_sec+DCC_MAP_RESOLVE;
	cur->measure = ctxt->now.tv_sec+FAST_RTT_SECS;

	if (cur->nms[0].hostname[0] == '\0') {
		if (HAVE_CLASS_SRVR(cur)) {
			++cur->gen;
			cur->avg_thold_rtt = DCC_RTT_BAD;
			cur->srvr_inx = NO_SRVR;
		}
		cur->num_srvrs = 0;
		memset(cur->addrs, 0, sizeof(cur->addrs));
		extra_pemsg(emsg, "no %s server host names",
			    DCC_IS_GREY_STR(cur));
		dcc_info_unlock(0);
		return 0;
	}

	new = *cur;
	memset(new.addrs, 0, sizeof(new.addrs));
	new.num_srvrs = 0;
	memset(&name_addrs, 0, sizeof(name_addrs));

	if (dcc_clnt_info->residue == 0) {
		dcc_clnt_info->residue = dcc_clnt_hid % DCC_SRVRS_MOD;
		if (dcc_clnt_info->residue == 0)
			dcc_clnt_info->residue = 1;
	}

	have_src4 = (dcc_clnt_info && dcc_clnt_info->src4.ip.family == AF_INET);
	have_src6 = (dcc_clnt_info && dcc_clnt_info->src6.ip.family == AF_INET6);

	if (dcc_clnt_info
	    && (dcc_clnt_info->fgs & DCC_INFO_FG_IPV6_OFF)) {
		use_ipv46 = DCC_GETH_V4;
	} else if (dcc_clnt_info
		   && (dcc_clnt_info->fgs & DCC_INFO_FG_IPV4_OFF)) {
		use_ipv46 = DCC_GETH_V6;
	} else if (have_src4 && !have_src6) {
		use_ipv46 = DCC_GETH_V46;
	} else if (!have_src4 && have_src6) {
		use_ipv46 = DCC_GETH_V64;
	} else {
		/* look for IPv6 addresses if IPv6 is working */
		flush_emsg(emsg);
		if (ipv_check(emsg, AF_INET6, 1)) {
			use_ipv46 = DCC_GETH_DEF;
		} else {
			flush_emsg(emsg);
			use_ipv46 = DCC_GETH_V4;
		}
	}

	/* unlock everything while we wait for DNS */
	if (!dcc_info_unlock(emsg)) {
		cur->resolve = 0;
		return 0;
	}
	dcc_ctxts_unlock();
	for (nm_inx = 0; nm_inx < DIM(cur->nms); ++nm_inx)
		resolve_nm(emsg, &new, nm_inx, name_addrs, use_ipv46);
	dcc_ctxts_lock();
	if (!dcc_info_lock(0)) {
		cur->resolve = 0;
		return 0;
	}

	a_inx = new.num_srvrs;
	if (a_inx == 0) {
		/* try again but not too soon
		 * if we fail to resolve even one server host names */
		cur->resolve = ctxt->now.tv_sec+DCC_RESOLVE_RETRY;

	} else {
		/* measure RTTs when we get new addresses */
		cur->measure = 0;

		/* see if anything changed */
		for (nm_inx = 0; nm_inx < DIM(cur->nms); ++nm_inx) {
			if (cur->nms[nm_inx].defined != new.nms[nm_inx].defined)
				break;
		}
		if (nm_inx >= DIM(cur->nms)
		    && a_inx == cur->num_srvrs) {
			/* we have the same number of old and new names and
			 * addresses, so compare the old and new addresses */
			new_ap = new.addrs;
			cur_ap = cur->addrs;
			for (;;) {
				if (new_ap->nam_inx != cur_ap->nam_inx
				    || memcmp(&new_ap->ip, &cur_ap->ip,
					      sizeof(new_ap->ip))) {
					break;
				}
				++new_ap;
				++cur_ap;
				if (!--a_inx)
					return 1;   /* nothing changed */
			}
		}
	}

	/* Something changed */
	++cur->gen;
	cur->srvr_inx = NO_SRVR;
	cur->avg_thold_rtt = -DCC_RTT_BAD;

	memcpy(&cur->addrs, &new.addrs, sizeof(cur->addrs));
	cur->num_srvrs = new.num_srvrs;
	for (nm_inx = 0; nm_inx < DIM(cur->nms); ++nm_inx)
		cur->nms[nm_inx].defined = new.nms[nm_inx].defined;

	return 1;
}



static void
soc_close(DCC_CLNT_CTXT_SOC *soc)
{
	if (soc->s != INVALID_SOCKET) {
		if (SOCKET_ERROR == closesocket(soc->s)
		    && dcc_clnt_debug)
			dcc_trace_msg("soc_close(): %s", ERROR_STR());
		soc->s = INVALID_SOCKET;
		soc->rem.sa.sa_family = AF_UNSPEC;
		soc->loc.sa.sa_family = AF_UNSPEC;
		soc->src = 0;
	}
}



void
dcc_clnt_socs_close(DCC_CLNT_CTXT *ctxt)
{
	soc_close(&ctxt->soc[0]);
	soc_close(&ctxt->soc[1]);
}



/* close extra socket used to measure RTTs to mixed IPv4 and IPv6 servers
 *	Do not keep it open to avoid problems with too many sockets
 *	in dccm or dccifd. */
static void
clean_socs(DCC_CLNT_CTXT *ctxt, const DCC_SRVR_CLASS *class)
{
	const DCC_SRVR_ADDR *cur_addr;

	/* no work if we have at most one socket */
	if (ctxt->soc[1].s == INVALID_SOCKET)
		return;

	/* replace the first socket with the second if there is no first */
	if (ctxt->soc[0].s != INVALID_SOCKET) {
		/* close the second socket if it is not connected */
		if (ctxt->soc[1].rem.sa.sa_family == AF_UNSPEC) {
			soc_close(&ctxt->soc[1]);
			return;
		}

		/* close the second socket if we have not chosen a server */
		if (!class || !HAVE_CLASS_SRVR(class)) {
			soc_close(&ctxt->soc[1]);
			return;
		}

		/* close the second socket if it is wrong for chosen server */
		cur_addr = &class->addrs[class->srvr_inx];
		if (cur_addr->ip.family != ctxt->soc[1].loc.sa.sa_family) {
			soc_close(&ctxt->soc[1]);
			return;
		}
	}

	/* otherwise replace the first socket with the second */
	soc_close(&ctxt->soc[0]);
	ctxt->soc[0] = ctxt->soc[1];
	ctxt->soc[1].s = INVALID_SOCKET;
	ctxt->soc[1].rem.sa.sa_family = AF_UNSPEC;
	ctxt->soc[1].loc.sa.sa_family = AF_UNSPEC;
	ctxt->soc[1].src = 0;
}



static u_char
make_soc(DCC_EMSG *emsg,
	 const DCC_CLNT_CTXT *ctxt,
	 DCC_CLNT_CTXT_SOC *soc,
	 DCC_CLNT_SRC *src,
	 sa_family_t family)
{
	DCC_SOCKU su;
	int retries;

	/* try to use the same port as before */
	soc->src = src;
	if (src) {
		dcc_ip2su(&su, &src->ip);
		DCC_SU_PORT(&su) = DCC_SU_PORT_Z(&ctxt->soc[0].loc);
	} else {
		dcc_mk_su(&su, family, 0, 0, DCC_SU_PORT_Z(&ctxt->soc[0].loc));
	}

	retries = -1;
	if (udp_create(emsg, &soc->s, &su, 1, 1, &retries)) {
		if (src)
			src->failed = 0;
		return 1;
	} else {
		if (src)
			src->failed = ctxt->now.tv_sec + DCC_CTXT_REBIND_SECS;
		return 0;
	}
}



DCC_CLNT_SRC *
get_clnt_src(const DCC_CLNT_CTXT *ctxt, sa_family_t family)
{
	DCC_CLNT_SRC *src;

	if (family == AF_INET)
		src = &dcc_clnt_info->src4;
	else if (family == AF_INET6)
		src = &dcc_clnt_info->src6;
	else
		return 0;
	if (src->ip.family != family)
		return 0;
	if (src->failed && !DCC_IS_TIME(ctxt->start.tv_sec, src->failed,
					DCC_CTXT_REBIND_SECS))
		return 0;
	return src;
}



/* Close and (re)open a client socket.
 *	The contexts and shared information must be locked on entry
 *	and both are locked on exit */
u_char					/* 0=failed to open the socket */
dcc_clnt_soc_reopen(DCC_EMSG *emsg,
		    DCC_CLNT_CTXT *ctxt,
		    DCC_CLNT_CTXT_SOC *soc,
		    sa_family_t family)
{
	socklen_t soc_len;
	SRVR_INX srvr_inx;
	DCC_CLNT_SRC *src;
	u_char failed4 ,failed6;
	sa_family_t try6, hint6;

	assert_info_locked();

	if (emsg)
		emsg->c[0] = '\0';

	hint6 = soc->loc.sa.sa_family;
	soc_close(soc);
	failed4 = 0;
	failed6 = 0;

	/* try to bind to the specified local address
	 * unless we recently tried and failed. */
	if ((family == AF_INET || family == AF_UNSPEC)
	    && (src = get_clnt_src(ctxt, AF_INET)) != 0) {
		if (!make_soc(emsg, ctxt, soc, src, AF_UNSPEC))
			failed4 = 1;
	}
	if (soc->s == INVALID_SOCKET
	    && (family == AF_INET6 || family == AF_UNSPEC)
	    && (src = get_clnt_src(ctxt, AF_INET6)) != 0) {
		flush_emsg(emsg);
		if (!make_soc(emsg, ctxt, soc, src, AF_UNSPEC))
			failed6 = 1;
	}

	/* Make and bind a new socket if we still do not have a bound socket. */
	while (soc->s == INVALID_SOCKET) {
		if (failed4 && failed6)
			return 0;

		/* keep guessing until we pick a family that works */
		if (family == AF_UNSPEC
		    && ((!failed4 && hint6 == AF_INET)
			|| (!failed6 && hint6 == AF_INET6)))
			family = hint6;
		if (family == AF_UNSPEC) {
			if (dcc_clnt_info->fgs & DCC_INFO_FG_IPV6_OFF)
				family = AF_INET;
			else if (dcc_clnt_info->fgs & DCC_INFO_FG_IPV4_OFF)
				family = AF_INET6;
		}
		if (family == AF_UNSPEC) {
			srvr_inx = dcc_clnt_info->dcc.srvr_inx;
			if (!VALID_SRVR(&dcc_clnt_info->dcc, srvr_inx))
				srvr_inx = 0;
			try6 = dcc_clnt_info->dcc.addrs[srvr_inx].ip.family;
			if ((!failed4 && try6 == AF_INET)
			    && (!failed6 && try6 == AF_INET6))
				family = try6;
		}
		if (family == AF_UNSPEC) {
			srvr_inx = dcc_clnt_info->grey.srvr_inx;
			if (!VALID_SRVR(&dcc_clnt_info->grey, srvr_inx))
				srvr_inx = 0;
			try6 = dcc_clnt_info->grey.addrs[srvr_inx].ip.family;
			if ((!failed4 && try6 == AF_INET)
			    && (!failed6 && try6 == AF_INET6))
				family = try6;
		}
		if (family == AF_UNSPEC) {
			/* if we have no hint, we're probably trying to talk
			 * to localhost */
			flush_emsg(emsg);
			if (ipv_check(emsg, AF_INET6, 1)) {
				family = AF_INET6;
			} else {
				failed6 = 1;
				family = AF_INET;
			}
		}
		flush_emsg(emsg);
		if (make_soc(emsg, ctxt, soc, 0, family))
			break;
		if (family == AF_INET)
			failed4 = 1;
		else
			failed6 = 1;
	}
	flush_emsg(emsg);

#if !defined(DCC_USE_POLL) && !defined(DCC_WIN32)
	if (soc->s >= (int)FD_SETSIZE) {
		dcc_info_unlock(0);
		dcc_pemsg(EX_IOERR, emsg, "socket FD %d > FD_SETSIZE %d",
			  soc->s, FD_SETSIZE);
		soc_close(soc);
		return 0;
	}
#endif

#if defined(IPPROTO_IP) && defined(IP_TTL)
	if (dcc_debug_ttl != 0
	    && 0 > setsockopt(soc->s, IPPROTO_IP, IP_TTL,
			      (void *)&dcc_debug_ttl, sizeof(dcc_debug_ttl))) {
		dcc_pemsg(EX_IOERR, emsg, "setsockopt(TTL=%d):%s",
			  dcc_debug_ttl, ERROR_STR());
		soc_close(soc);
		return 0;
	}
#endif

	soc_len = sizeof(soc->loc);
	if (0 > getsockname(soc->s, &soc->loc.sa, &soc_len)) {
		dcc_pemsg(EX_IOERR, emsg, "getsockname(): %s", ERROR_STR());
		soc_close(soc);
		return 0;
	}
	return 1;
}



static int
do_recv(DCC_CLNT_CTXT_SOC *soc, DCC_OP_RESP *resp, int resp_len, DCC_SOCKU *sup)
{
	socklen_t su_len;
	int result;

	su_len = sizeof(*sup);
	sup->sa.sa_family = AF_UNSPEC;
	if (dcc_clnt_info->fgs & DCC_INFO_FG_SOCKS)
		result = Rrecvfrom(soc->s, WIN32_SOC_CAST resp, resp_len, 0,
				   &sup->sa, &su_len);
	else
		result = recvfrom(soc->s, WIN32_SOC_CAST resp, resp_len, 0,
				  &sup->sa, &su_len);
#if RECV_FAIL
	if (result > 0 && !(++recv_fail % RECV_FAIL)) {
		dcc_trace_msg("force recv failure");
		errno = RECV_FAIL_ERRNO;
		result = -1;
	}
#endif
	return result;
}



/* clear the socket buffer */
u_char
dcc_clnt_soc_flush(DCC_CLNT_CTXT_SOC *soc)
{
	DCC_OP_RESP pkt;
	DCC_SOCKU su;
	char sbuf[DCC_SU2STR_SIZE];
	char rbuf[30];
	char ob[DCC_OPBUF];
	int pkt_len, pkt_num;

	if (soc->s == INVALID_SOCKET)
		return 1;

	for (pkt_num = 1; pkt_num <= 50; ++pkt_num) {
		pkt_len = do_recv(soc, &pkt, sizeof(pkt), &su);
		if (0 <= pkt_len) {
			if (dcc_clnt_debug == 0 && pkt_num < 10)
				continue;
			dcc_su2str(sbuf, sizeof(sbuf), &su);
			if (pkt_num > 1)
				snprintf(rbuf, sizeof(rbuf), " #%d", pkt_num);
			else
				rbuf[0] = '\0';
			if (pkt_len < ISZ(DCC_HDR)+ISZ(DCC_SIGNATURE)
			    || pkt_len != ntohs(pkt.hdr.len)
			    || pkt.hdr.pkt_vers < DCC_PKT_VERS_MIN
			    || pkt.hdr.pkt_vers > DCC_PKT_VERS_NOP_MAX) {
				trace_bad_packet(0, &su, &pkt, pkt_len,
						 "flush%s %d stray bytes from"
						 " %s",
						 rbuf, pkt_len, sbuf);
			} else {
				dcc_trace_msg("flush%s %s from %s"
					      " ID=%d h=%x p=%x r=%x t=%x",
					      rbuf,
					      dcc_hdr_op2str(ob, sizeof(ob),
							&pkt.hdr),
					      sbuf,
					      ntohl(pkt.hdr.sender),
					      pkt.hdr.op_nums.h,
					      pkt.hdr.op_nums.p,
					      pkt.hdr.op_nums.r,
					      pkt.hdr.op_nums.t);

			}
			continue;
		}
		if (DCC_BLOCK_ERROR())
			return 1;
		if (UNREACHABLE_ERRORS()) {
			if (dcc_clnt_debug > 1 || pkt_num > 10)
				dcc_trace_msg("ignore flushed error: %s",
					      ERROR_STR());
			continue;
		}
		dcc_trace_msg("flush recvfrom(%s): %s",
			      su.sa.sa_family != AF_UNSPEC
			      ? dcc_su2str(sbuf, sizeof(sbuf), &su) : "",
			      ERROR_STR());
		return 0;
	}

	dcc_trace_msg("too many flushed packets or errors");
	return 0;
}



int					/* 1=no error -1=getsockopt  0=socket */
clear_soc_error(DCC_EMSG *emsg, DCC_CLNT_CTXT_SOC *soc, const char *which)
{
	int err;
	socklen_t errlen;

	errlen = sizeof(err);
	if (0 > getsockopt(soc->s, SOL_SOCKET, SO_ERROR,
			   WIN32_SOC_CAST &err, &errlen)) {
		dcc_pemsg(EX_IOERR, emsg, "getsockopt(SO_ERROR): %s",
			  ERROR_STR());
		return -1;
	} else if (err) {
		dcc_pemsg(EX_IOERR, emsg, "%s SO_ERROR: %s",
			  which, ERROR_STR1(err));
		return 0;
	}
	return 1;
}



/* connect() to the server
 *	The contexts and shared information must be locked on entry
 *	They are locked on exit */
u_char
dcc_clnt_connect(DCC_EMSG *emsg,
		 DCC_CLNT_CTXT *ctxt,
		 DCC_CLNT_CTXT_SOC *soc,
		 const DCC_SOCKU *su,	/* 0=disconnect */
		 sa_family_t family)	/* ignored if su valid */
{
	int i;

	assert_info_locked();

	/* The family of a valid address overrides. */
	if (su) {
		if (su->sa.sa_family != AF_UNSPEC)
			family = su->sa.sa_family;
		else
			su = 0;
	}

	if (soc->s == INVALID_SOCKET
	    || (family != AF_UNSPEC && soc->loc.sa.sa_family != family)) {
		/* (re)open the socket if necessary */
		if (!dcc_clnt_soc_reopen(emsg, ctxt, soc, family))
			return 0;
		/* finished if we were only disconnecting */
		if (!su)
			return 1;

	} else if (!su) {
		/* disconnect if asked
		 *	In theory you can use connect() with a "null address."
		 *	In practice on some systems there is more than one or
		 *	even no notion of an effective "null" address. */
		if (soc->rem.sa.sa_family == AF_UNSPEC) {
			/* already disconnected
			 *
			 * Some flavors of Linux say "Connection refused" on
			 * sendto() on a not-connected socket when a previous
			 * use of sendto() hit a closed port, particularly
			 * via loopback */
			i = clear_soc_error(emsg, soc, "Linux connect");
			if (i < 0)
				dcc_error_msg("%s", emsg->c);
			else if (i == 0 && dcc_clnt_debug > 3)
				dcc_trace_msg("%s", emsg->c);
			return 1;
		}
		/* Close and re-open to disconnect. */
		return dcc_clnt_soc_reopen(emsg, ctxt, soc, family);
	}

	/* We now know that the socket exists and we want it connected.
	 * We are finished if it is already connected to the correct address. */
	if (DCC_SU_EQ(&soc->rem, su))
		return 1;

	/* At least some versions of Linux do not allow	connsecutive valid
	 *	calls to connect().
	 *	So always close and reopen the socket for Linux.
	 * At least some versions of FreeBSD unbind a socket when reconnecting.
	 *	So if the socket was bound to specified local address,
	 *	close and reopen it.
	 */
	if (soc->rem.sa.sa_family != AF_UNSPEC
#ifndef linux
	    && soc->src
#endif /* linux */
	    ) {
		if (!dcc_clnt_soc_reopen(emsg, ctxt, soc, family))
			return 0;
	}

	if (SOCKET_ERROR == connect(soc->s, &su->sa, DCC_SU_LEN(su))) {
		char sustr[DCC_SU2STR_SIZE];

		extra_pemsg(emsg, "connect(%s): %s",
			    dcc_su2str(sustr, sizeof(sustr), su), ERROR_STR());
		/* Maybe the socket is actually connected or in some other
		 * wierd state. This happens with EINVAL and FreeBSD jails.
		 * So try to ensure that it is sane even as we fail. */
		dcc_clnt_soc_reopen(emsg, ctxt, soc, su->sa.sa_family);
		return 0;
	}

	soc->rem = *su;

	/* clear ICMP Unreachable errors from previous transmissions */
	if (soc->rem.sa.sa_family != AF_UNSPEC) {
		i = clear_soc_error(emsg, soc, "connect");
		if (i < 0)
			dcc_error_msg("%s", emsg->c);
		else if (i == 0 && dcc_clnt_debug > 3)
			dcc_trace_msg("%s", emsg->c);
	}

	return 1;
}



static void
update_rtt(DCC_CLNT_CTXT *ctxt, DCC_SRVR_CLASS *class, DCC_XLENT *xlent, int us)
{
	DCC_SRVR_ADDR *ap;

	/* compute new RTT only if the map data structure is locked,
	 * the clock did not jump,
	 * and we're talking about the same hosts */
	if (!info_locked
	    || xlent->addrs_gen != class->gen)
		return;

	ap = &class->addrs[xlent->srvr_inx];

	if (us < 0)
		us = 0;
	if (us > DCC_RTT_BAD)
		us = DCC_RTT_BAD;

	if (ap->rtt == DCC_RTT_BAD) {
		/* just set the RTT if this is a newly working server */
		ap->rtt = us;
		ap->total_xmits = 0;
		ap->total_resps = 0;
		ap->resp_mem = 0;
		ap->rtt_updated = 0;

	} else if (ctxt->now.tv_sec < TIME_T(ap->rtt_updated) + FAST_RTT_SECS) {
		/* adjust the RTT quickly if this is the first
		 * measurement in a long time */
		AGE_AVG(ap->rtt, us, 2, 1);
		ap->rtt_updated = ctxt->now.tv_sec;

	} else {
		AGE_AVG(ap->rtt, us, 9, 1);
		ap->rtt_updated = ctxt->now.tv_sec;
	}

	if (ap->rtt > DCC_MAX_RTT)
		ap->rtt = DCC_MAX_RTT;
}



static inline void
clear_xl(DCC_CLNT_CTXT *ctxt)
{
	memset(&ctxt->xl, 0, sizeof(ctxt->xl) - sizeof(ctxt->xl.entries));
	ctxt->xl.next = ctxt->xl.entries;
}



/* Update response rate and penalize the RTT of servers that failed to respond.
 *	the data must be locked */
static void
resp_rates(DCC_CLNT_CTXT *ctxt, DCC_SRVR_CLASS *class,
	   u_char measuring)
{
	DCC_SRVR_ADDR *ap;
	DCC_XLENT *xlent;
	const DCC_XLENT *xlent2;
	int us, us2;
	int resps, xmits;
	int i;

	assert_info_locked();

	/* increase the RTT for unanswered transmissions */
	for (xlent = ctxt->xl.entries; xlent < ctxt->xl.next; ++xlent) {
		/* ignore transmissions that were answered
		 * or were for some other IP address */
		if (xlent->flags & DCC_XLFG_ANS)
			continue;

		/* Update the RTT of this server as if we would have received
		 * a response for this logged transmission if we had waited
		 * a little longer, unless we would be assuming a faster RTT
		 * than its current average.
		 *
		 * Use the longest of the time spent waiting for this request
		 * and the delays of any requests that were answered by the
		 * server. */
		us = ctxt->now_us - xlent->sent_us;
		us2 = 0;
		for (xlent2 = ctxt->xl.entries;
		     xlent2 < ctxt->xl.next;
		     ++xlent2) {
			if (!(xlent2->flags & DCC_XLFG_ANS)
			    || (xlent2->flags & DCC_XLFG_FAKE)
			    || xlent2->srvr_inx != xlent->srvr_inx)
				continue;
			us2 = xlent2->delay_us;
			if (us < us2)
				us = us2;
		}
		xlent->flags |= (DCC_XLFG_ANS | DCC_XLFG_FAKE);
		us += DCC_DCCD_DELAY;
		xlent->delay_us = us;
		/* update the RTT
		 * if we waited at least as long as the current RTT
		 * or we received at least one response */
		if (us2 != 0 || us >= class->addrs[xlent->srvr_inx].rtt)
			update_rtt(ctxt, class, xlent, us);
	}

	/* maintain the response rate */
	for (i = 0, ap = class->addrs; i < DIM(ctxt->xl.cur); ++i, ++ap) {
		if (ap->rtt == DCC_RTT_BAD
		    || ctxt->xl.cur[i].xmits == 0)
			continue;
		if (measuring) {
			if (ctxt->xl.cur[i].resps != 0) {
				++ctxt->xl.working_addrs;
			} else if (!(ap->resp_mem & ((1<<DCC_MAX_XMITS)-1))) {
				/* this server is bad if there were no answers
				 * at all for this mesurement cycle */
				ap->rtt = DCC_RTT_BAD;
				continue;
			}
		}

		/* record the number of transmissions to this server */
		ap->total_xmits += ctxt->xl.cur[i].xmits;
		if (ap->total_xmits > DCC_TOTAL_XMITS_MAX)
			ap->total_xmits = DCC_TOTAL_XMITS_MAX;

		/* record the number of responses for the last
		 * DCC_TOTAL_XMITS_MAX transmissions  */
		xmits = ctxt->xl.cur[i].xmits;
		resps = ctxt->xl.cur[i].resps;
		do {
			/* forget the response to the DCC_TOTAL_XMITS_MAX+1
			 * transmission */
			ap->total_resps -= (ap->resp_mem
					    >> (DCC_TOTAL_XMITS_MAX-1));

			ap->resp_mem <<= 1;
			if (resps != 0) {
				ap->resp_mem |= 1;
				++ap->total_resps;
				--resps;
			}
		} while (--xmits != 0);
	}
}



/* send a single DCC message
 * the contexts and the shared information must be locked on entry
 * nothing is unlocked */
static void
clnt_xmit(DCC_EMSG *emsg,
	  DCC_CLNT_CTXT *ctxt,
	  DCC_SRVR_CLASS *class, const DCC_SRVR_ADDR *ap,
	  DCC_HDR *msg, int msg_len,
	  u_char connect_ok)
{
	DCC_XLENT *xlent;
#	define FSTR " from "
	char tgt_abuf[80], src_abuf[LITZ(FSTR)+INET6_ADDRSTRLEN+1];
	char ob[DCC_OPBUF];
	DCC_CLNT_CTXT_SOC *soc;
	int slen;

	msg->len = htons(msg_len);

	xlent = ctxt->xl.next++;
	if (xlent > LAST(ctxt->xl.entries))
		dcc_logbad(EX_SOFTWARE, "xlent > LAST(ctxt->xl.entries)");
	++msg->op_nums.t;
	xlent->op_nums = msg->op_nums;
	xlent->sent_us = ctxt->now_us;
	xlent->delay_us = 0;
	dcc_ip2su(&xlent->su, &ap->ip);
	xlent->srvr_inx = ap - class->addrs;
	if (!VALID_NAM(ap->nam_inx))
		dcc_logbad(EX_SOFTWARE, "clnt_xmit: bad nam_inx");
	xlent->id = class->nms[ap->nam_inx].clnt_id;
	xlent->addrs_gen = class->gen;
	xlent->flags = 0;

	++ctxt->xl.cur[xlent->srvr_inx].xmits;

	msg->sender = htonl(xlent->id);
	if (xlent->id == DCC_ID_ANON) {
		xlent->passwd[0] = '\0';
		memset((char *)msg + (msg_len-sizeof(DCC_SIGNATURE)), 0,
		       sizeof(DCC_SIGNATURE));
	} else {
		if (xlent->id == 0) {
			if (dcc_clnt_debug)
				dcc_logbad(EX_SOFTWARE, "zero client-ID for %s",
					   class->nms[ap->nam_inx].hostname);
			else
				dcc_trace_msg("zero client-ID for %s",
					      class->nms[ap->nam_inx].hostname);
			class->nms[ap->nam_inx].clnt_id = DCC_ID_ANON;
		} else if (class->nms[ap->nam_inx].passwd[0] == '\0') {
			if (dcc_clnt_debug)
				dcc_logbad(EX_SOFTWARE, "null password for %s",
					   class->nms[ap->nam_inx].hostname);
			else
				dcc_trace_msg("null password for %s",
					      class->nms[ap->nam_inx].hostname);
			class->nms[ap->nam_inx].clnt_id = DCC_ID_ANON;
		}
		strncpy(xlent->passwd, class->nms[ap->nam_inx].passwd,
			sizeof(xlent->passwd));
		dcc_sign(xlent->passwd, sizeof(xlent->passwd), msg, msg_len);
	}

	/* use the socket with the right IPv4/IPv6 family if available,
	 * or the first free socket */
	if (ctxt->soc[0].loc.sa.sa_family == xlent->su.sa.sa_family)
		soc = &ctxt->soc[0];
	else if (ctxt->soc[1].loc.sa.sa_family == xlent->su.sa.sa_family)
		soc = &ctxt->soc[1];
	else if (ctxt->soc[0].s == INVALID_SOCKET)
		soc = &ctxt->soc[0];
	else
		soc = &ctxt->soc[1];

	/* if necessary, open and perhaps connect the socket */
	if (!dcc_clnt_connect(emsg, ctxt, soc, connect_ok ? &xlent->su : 0,
			      xlent->su.sa.sa_family)) {
		++ctxt->xl.cur[xlent->srvr_inx].failures;
		/* act as if this transmission was eventually answered */
		xlent->delay_us = DCC_RTT_BAD;
		update_rtt(ctxt, class, xlent, DCC_RTT_BAD);
		return;
	}

#if SEND_FAIL
	if (!(++send_fail % SEND_FAIL)) {
		dcc_trace_msg("force send failure");
		slen = -1;
		errno = SEND_FAIL_ERRNO;
	} else
#endif
	if (soc->rem.sa.sa_family != AF_UNSPEC) {
		if (dcc_clnt_info->fgs & DCC_INFO_FG_SOCKS)
			slen = Rsend(soc->s, WIN32_SOC_CAST msg, msg_len, 0);
		else
			slen = send(soc->s, WIN32_SOC_CAST msg, msg_len, 0);

	} else {
		if (dcc_clnt_info->fgs & DCC_INFO_FG_SOCKS)
			slen = Rsendto(soc->s, WIN32_SOC_CAST msg, msg_len, 0,
				       &xlent->su.sa, DCC_SU_LEN(&xlent->su));
		else
			slen = sendto(soc->s, WIN32_SOC_CAST msg, msg_len, 0,
				      &xlent->su.sa, DCC_SU_LEN(&xlent->su));
	}
	if (slen == msg_len) {
		if (dcc_clnt_debug > 3 || SEND_FAIL) {
			if (soc->loc.sa.sa_family == AF_UNSPEC) {
				src_abuf[0] = '\0';
			} else {
				memcpy(src_abuf, FSTR, LITZ(FSTR));
				dcc_su2str(&src_abuf[LITZ(FSTR)],
					   sizeof(src_abuf)-LITZ(FSTR),
					   &soc->loc);
			}
			dcc_trace_msg("%8.6f sent %s r=%x t=%x%s to %s%s",
				      get_age(ctxt),
				      dcc_hdr_op2str(ob, sizeof(ob), msg),
				      xlent->op_nums.r, xlent->op_nums.t,
				      connect_ok ? " by connection" : "",
				      addr2str(tgt_abuf, sizeof(tgt_abuf),
					       class, class->gen, ap,
					       &xlent->su),
				      src_abuf);
		}
		++ctxt->xl.outstanding;
		return;
	}

	/* failed */
	++ctxt->xl.cur[xlent->srvr_inx].failures;
	xlent->delay_us = DCC_RTT_BAD;
	update_rtt(ctxt, class, xlent, DCC_RTT_BAD);

	if (slen >= 0 || !UNREACHABLE_ERRORS() || dcc_clnt_debug) {
		if (soc->loc.sa.sa_family == AF_UNSPEC) {
			src_abuf[0] = '\0';
		} else {
			memcpy(src_abuf, FSTR, LITZ(FSTR));
			dcc_su2str(&src_abuf[LITZ(FSTR)],
				   sizeof(src_abuf)-LITZ(FSTR),
				   &soc->loc);
		}
		if (slen < 0) {
			dcc_trace_msg("%s(%s)%s: %s",
				      connect_ok ? "send" : "sendto",
				      addr2str(tgt_abuf, sizeof(tgt_abuf),
					       class,
					       class->gen, ap, &xlent->su),
				      src_abuf, ERROR_STR());
			/* stop using a socket that might have been driven
			 * crazy by a FreeBSD jail */
			if (!UNREACHABLE_ERRORS()) {
				flush_emsg(emsg);
				dcc_clnt_soc_reopen(emsg, ctxt, soc,
						    soc->loc.sa.sa_family);
			}
		} else {
			dcc_trace_msg("%s(%s%s)=%d instead of %d",
				      connect_ok ? "send" : "sendto",
				      addr2str(tgt_abuf, sizeof(tgt_abuf),
					       class,
					       class->gen, ap, &xlent->su),
				      src_abuf, slen, msg_len);
		}
	}

	/* assume initial errors such as EOPNOTSUPP mean that
	 * the local address is bad */
	if (slen < 0 && soc->src && !UNREACHABLE_ERRORS()
	    && ctxt->xl.cur[xlent->srvr_inx].xmits == 1) {
		soc->src->failed = ctxt->now.tv_sec + DCC_CTXT_REBIND_SECS;
		soc_close(soc);
	}
#undef FSTR
}



/* receive a single DCC response
 *      The contexts must be locked.
 *      The mapped or common info ought to be locked, but reception
 *      works if it is not. */
static int      /* -1=fatal error, 0=no data, 1=unreachable, 2=ok */
clnt_recv(DCC_CLNT_CTXT *ctxt,
	  DCC_POLLFD pollfds[2],
	  DCC_SRVR_CLASS *class,
	  DCC_OP_RESP *resp,		/* the response */
	  int resp_len,
	  const DCC_HDR *msg,		/* the original request */
	  DCC_XLENT **xlentp)
{
	int snm;
	DCC_SOCKU su;
	DCC_XLENT *xlent, *xlent1;
	DCC_SRVR_ADDR *ap;
	char sustr[DCC_SU2STR_SIZE+50];
	char sustr2[DCC_SU2STR_SIZE];
	char ob[DCC_OPBUF];
	char ob2[DCC_OPBUF];
	int pkt_len;

	*xlentp = 0;
	for (;;) {
next_pkt:;
		if (pollfds[0].revents) {
			snm = 0;
		} else if (pollfds[1].revents) {
			snm = 1;
		} else {
			return 0;
		}
		pkt_len = do_recv(&ctxt->soc[snm], resp, resp_len, &su);
		if (pkt_len < 0) {
			if (DCC_BLOCK_ERROR()) {
				pollfds[snm].revents = 0;
				continue;
			}

			/* ignore ICMP Unreachables unless we have connected
			 * to a server.
			 * If so, forget all outstanding requests */
			if (ctxt->soc[snm].rem.sa.sa_family != AF_UNSPEC
			    && UNREACHABLE_ERRORS()) {
				/* find one relevant request
				 * as we mark all of them finished */
				for (xlent1 = ctxt->xl.entries, xlent = 0;
				     xlent1 < ctxt->xl.next;
				     ++xlent1) {
					if (xlent1->flags & DCC_XLFG_ANS)
					    continue;
					if (xlent1->su.sa.sa_family
					    != ctxt->soc[snm].rem.sa.sa_family)
					    continue;
					xlent = xlent1;
					xlent1->flags |= (DCC_XLFG_ANS
							| DCC_XLFG_FAKE);
					xlent->delay_us = DCC_RTT_BAD;
				}
				if (!xlent) {
					if (dcc_clnt_debug)
					    dcc_trace_msg("ignore unmatched:"
							" %s", ERROR_STR());
					continue;
				}
				if (dcc_clnt_debug)
					dcc_trace_msg("recvfrom(%s): %s",
						      dcc_su2str(sustr,
							  sizeof(sustr),
							  &ctxt->soc[snm].rem),
						      ERROR_STR());
				ctxt->xl.outstanding = 0;
				++ctxt->xl.cur[xlent->srvr_inx].failures;
				ap = &class->addrs[xlent->srvr_inx];
				ap->rtt = DCC_RTT_BAD;
				return 1;
			}
			dcc_trace_msg( "clnt_recv recvfrom(%s): %s",
				      su.sa.sa_family != AF_UNSPEC
				      ? dcc_su2str(sustr, sizeof(sustr), &su)
				      : "",
				      ERROR_STR());
			return -1;
		}

		if (pkt_len > resp_len) {
			trace_bad_packet(ctxt, &su, resp, pkt_len,
					 "recv(%s)=%d>%d",
					 dcc_su2str(sustr, sizeof(sustr), &su),
					 pkt_len, resp_len);
			continue;
		}
		if (pkt_len < ISZ(DCC_HDR)+ISZ(DCC_SIGNATURE)) {
			trace_bad_packet(ctxt, &su, resp, pkt_len,
					 "recv(%s)=%d<%d",
					 dcc_su2str(sustr, sizeof(sustr), &su),
					 pkt_len,
					 ISZ(DCC_HDR)+ISZ(DCC_SIGNATURE));
			continue;
		}
		if (pkt_len != ntohs(resp->hdr.len)) {
			trace_bad_packet(ctxt, &su, resp, pkt_len,
					 "recv(%s)=%d but hdr len=%d",
					 dcc_su2str(sustr, sizeof(sustr), &su),
					 pkt_len,
					 ntohs(resp->hdr.len));
			continue;
		}

		if (resp->hdr.pkt_vers < DCC_PKT_VERS_MIN
		    || resp->hdr.pkt_vers > DCC_PKT_VERS_MAX) {
			trace_bad_packet(ctxt, &su, resp, pkt_len,
					 "unrecognized version #%d from %s",
					 resp->hdr.pkt_vers,
					 dcc_su2str(sustr, sizeof(sustr), &su));
			continue;
		}

		/* We cannot use the server's apparent IP address because it
		 * might be multi-homed and respond with an address other than
		 * the address to which we sent.  So use our records of
		 * which OP_NUMS was sent to which server address. */
		if (resp->hdr.op_nums.r != msg->op_nums.r
		    || resp->hdr.op_nums.p != msg->op_nums.p
		    || resp->hdr.op_nums.h != msg->op_nums.h) {
			if (dcc_clnt_debug)
				dcc_trace_msg("unmatched response from %s"
					      " ID=%d h=%x/%x p=%x/%x"
					      " r=%x/%x t=%x",
					      dcc_su2str(sustr, sizeof(sustr),
							&su),
					      ntohl(resp->hdr.sender),
					      resp->hdr.op_nums.h,
					      msg->op_nums.h,
					      resp->hdr.op_nums.p,
					      msg->op_nums.p,
					      resp->hdr.op_nums.r,
					      msg->op_nums.r,
					      resp->hdr.op_nums.t);
			continue;
		}

		/* Everything matches except perhaps the transmission #
		 * So search the log for an unanswered transmision */
		for (xlent = ctxt->xl.entries; ; ++xlent) {
			if (xlent >= ctxt->xl.next) {
				if (dcc_clnt_debug)
					dcc_trace_msg("stray %d"
						      " byte response from %s"
						      " ID=%d h=%x p=%x"
						      " r=%x t=%x/%x",
						      pkt_len,
						      dcc_su2str(sustr,
							  sizeof(sustr),
							  &su),
						      ntohl(resp->hdr.sender),
						      resp->hdr.op_nums.h,
						      resp->hdr.op_nums.p,
						      resp->hdr.op_nums.r,
						      msg->op_nums.t,
						      resp->hdr.op_nums.t);
				goto next_pkt;
			}
			if (!(xlent->flags & DCC_XLFG_ANS)
			    && resp->hdr.op_nums.t == xlent->op_nums.t)
				break;
		}
		ap = &class->addrs[xlent->srvr_inx];

		if (xlent->passwd[0] != '\0'
		    && !dcc_ck_signature(xlent->passwd, sizeof(xlent->passwd),
					 resp, pkt_len)) {
			if (!dcc_clnt_debug)
				dcc_error_msg("%s ID=%d rejected our password"
					      " for ID %d",
					      addr2str(sustr, sizeof(sustr),
						       class, xlent->addrs_gen,
						       ap, &su),
					      ntohl(resp->hdr.sender),
					      xlent->id);
			else
				dcc_error_msg("%s ID=%d rejected our password"
					      " for ID %d and %s with %s"
					      " h=%x p=%x r=%x t=%x",
					      addr2str(sustr, sizeof(sustr),
						       class, xlent->addrs_gen,
						       ap, &su),
					      ntohl(resp->hdr.sender),
					      xlent->id,
					      dcc_hdr_op2str(ob, sizeof(ob),
							msg),
					      dcc_hdr_op2str(ob2, sizeof(ob2),
							&resp->hdr),
					      resp->hdr.op_nums.h,
					      resp->hdr.op_nums.p,
					      resp->hdr.op_nums.r,
					      resp->hdr.op_nums.t);
		}

		if (dcc_clnt_debug > 3 || CLNT_LOSSES)
			dcc_trace_msg("%8.6f %d byte response from %s ID=%d"
				      " h=%x p=%x r=%x t=%x",
				      get_age(ctxt),
				      pkt_len,
				      dcc_su2str(sustr, sizeof(sustr), &su),
				      ntohl(resp->hdr.sender),
				      resp->hdr.op_nums.h,
				      resp->hdr.op_nums.p,
				      resp->hdr.op_nums.r,
				      resp->hdr.op_nums.t);

#if CLNT_LOSSES
		if (!(++clnt_losses % CLNT_LOSSES)) {
			dcc_trace_msg("dropped answer");
			continue;
		}
#endif

		/* don't find the record of this transmission again */
		xlent->flags |= DCC_XLFG_ANS;
		xlent->delay_us = ctxt->now_us - xlent->sent_us;
		if (ctxt->xl.outstanding != 0)
			--ctxt->xl.outstanding;
		++ctxt->xl.cur[xlent->srvr_inx].resps;
		*xlentp = xlent;

		/* Notice if multi-homing is involved
		 * That is true if the address from which the client answered
		 * differs from the address to which we sent */
		if (!(ap->flags & DCC_SRVR_ADDR_MHOME)
		    && !DCC_SUnP_IP_EQ(&su, &ap->ip)) {
			if (dcc_clnt_debug)
				dcc_trace_msg("%s multi-homed at %s",
					      addr2str(sustr, sizeof(sustr),
						       class, xlent->addrs_gen,
						       ap, 0),
					      dcc_su2str(sustr2, sizeof(sustr2),
							&su));
			ap->flags |= DCC_SRVR_ADDR_MHOME;
		}

		return 2;
	}
}



/* Estimate the RTT to all known servers
 *      The RTT's help the client pick a server that will respond quickly and
 *      reliably and to know when to retransmit a request that is lost due
 *      to network congestion or bit rot.
 * Both locks must be held on entry.
 * Both are released while working.
 * Both locks are held on success.
 * Only the contexts are locked on failure. */
static u_char				/* 0=failed, 1=at least 1 good server */
measure_rtt(DCC_EMSG *emsg, DCC_CLNT_CTXT *ctxt,
	    DCC_CLNT_FGS clnt_fgs)	/* DCC_CLNT_FG_* */
{
	DCC_SRVR_CLASS *class;
	DCC_SRVR_ADDR *ap;
	DCC_NOP nop;
	DCC_OP_RESP resp;
	int delay_us, next_xmit;
	int nfds, xmit_num;
	int addrs_gen;
	int tgt_addrs;
	char ob[DCC_OPBUF], abuf[80];
	u_char vers;
	u_char ipv4_connect_ok, ipv6_connect_ok, connect_ok;
	int ipv4_tgts, ipv6_tgts;
	DCC_POLLFD pollfds[2];
	u_int n;
	int i;

	assert_info_locked();

	/* Send NOP's to all addresses and wait for responses to
	 * measure each server's health and RTT.
	 * Treat all addresses as if they are of independent hosts */

	class = DCC_GREY2CLASS(clnt_fgs & DCC_CLNT_FG_GREY);
	if (class->num_srvrs == 0) {
		class->srvr_inx = NO_SRVR;
		flush_emsg(emsg);
		dcc_pemsg(EX_NOHOST, emsg, "no %s server %s",
			  DCC_IS_GREY_STR(class),
			  class->nms[0].hostname[0] == '\0'
			  ? "names" : "addresses");
		fail_more(ctxt, class);
		dcc_info_unlock(0);
		return 0;
	}

	++dcc_clnt_info->proto_hdr.op_nums.r;
	memcpy(&nop.hdr, &dcc_clnt_info->proto_hdr, sizeof(nop.hdr));
	/* servers ignore the version on NOPs except to guess the version
	 * we will accept */
	nop.hdr.pkt_vers = DCC_PKT_VERS;
	nop.hdr.op_nums.p = getpid();
	nop.hdr.op = DCC_OP_NOP;
	/* Do not change the transaction ID so that dbclean can kludge it.
	 * Dccd does not care about the transaction ID on NOPs. */

	if (!get_now(emsg, ctxt)) {
		dcc_info_unlock(0);
		return 0;
	}

	/* discourage competition from other processes and threads */
	class->measure = ctxt->now.tv_sec+FAST_RTT_SECS;

	addrs_gen = class->gen;

	/* stop waiting for responses when we have enough working servers */
	tgt_addrs = class->num_srvrs;
	if (!dcc_all_srvrs && tgt_addrs > 4)
		tgt_addrs = 4;

	for (i = 0, ap = class->addrs; ap <= LAST(class->addrs); ++i, ++ap) {
		if (ap->ip.family == AF_UNSPEC || !VALID_NAM(ap->nam_inx))
			++ctxt->xl.cur[i].failures;
	}
	clear_xl(ctxt);
	ipv4_connect_ok = 1;
	ipv6_connect_ok = 1;
	delay_us = 0;
	next_xmit = 0;
	xmit_num = 0;
	/* wait for the responses to the NOPs and retransmit as needed */
	for (;;) {
		/* wait quietly until time to retransmit */
		if (delay_us <= 0) {
			if (xmit_num >= DCC_MAX_XMITS)
				break;
			if (ctxt->xl.working_addrs >= tgt_addrs) {
				/* do not retransmit if we have heard from
				 *	enough servers
				 * quit if we have waited at least one RTT */
				if (xmit_num > 0)
					break;
				delay_us = 0;
				next_xmit = ctxt->now_us;

			} else {
				/* get delay & time of next transmission */
				delay_us = retrans_time((clnt_fgs
							& DCC_CLNT_FG_SLOW)
							? DCC_MAX_RTT
							: DCC_MIN_RTT,
							xmit_num++);
				next_xmit = delay_us + ctxt->now_us;

				/* Count targets of the next NOP and whether
				 * any of them are known to be multi-homed.
				 * Use a connected socket early to get
				 *	ICMP error messages from single server.
				 * No connection later to detect multi-homing
				 *	that makes a server appear deaf.
				 * No connection if we are expecting responses
				 *	from previous transmissions to more than
				 *	one server. */
				if (ctxt->xl.outstanding == 0) {
					ipv4_connect_ok = 1;
					ipv6_connect_ok = 1;
				}
				if (xmit_num > DCC_MAX_XMITS/2) {
					ipv4_connect_ok = 0;
					ipv6_connect_ok = 0;
				}
				ipv4_tgts = 0;
				ipv6_tgts = 0;
				for (n = 0, ap = class->addrs;
				     ap <= LAST(class->addrs);
				     ++n, ++ap) {
					if (ap->ip.family == AF_UNSPEC)
					    break;
					if (ctxt->xl.cur[n].resps != 0
					    || ctxt->xl.cur[n].failures != 0)
					    continue;
					if (ap->ip.family == AF_INET) {
					    if (ap->flags & DCC_SRVR_ADDR_MHOME)
						ipv4_connect_ok = 0;
					    ++ipv4_tgts;
					} else {
					    if (ap->flags & DCC_SRVR_ADDR_MHOME)
						ipv6_connect_ok = 0;
					    ++ipv6_tgts;
					}
				}
				if (ipv4_tgts > 1)
					ipv4_connect_ok = 0;
				if (ipv6_tgts > 1)
					ipv6_connect_ok = 0;
				for (n = 0, ap = class->addrs;
				     ipv4_tgts + ipv6_tgts > 0
				     && ap <= LAST(class->addrs);
				     ++n, ++ap) {
					if (ctxt->xl.cur[n].resps != 0
					    || ctxt->xl.cur[n].failures != 0)
					    continue;
					if (ap->ip.family == AF_INET) {
					    --ipv4_tgts;
					    connect_ok = ipv4_connect_ok;
					} else {
					    --ipv6_tgts;
					    connect_ok = ipv6_connect_ok;
					}
					clnt_xmit(emsg, ctxt, class, ap,
						  &nop.hdr, sizeof(nop),
						  connect_ok);
				}
			}

			/* stop if nothing to wait for */
			if (ctxt->xl.outstanding == 0)
				break;
		}

		if (ctxt->soc[0].s == INVALID_SOCKET
		    && ctxt->soc[1].s == INVALID_SOCKET) {
			nfds = 0;
		} else {
			pollfds[0].fd = ctxt->soc[0].s;
			pollfds[1].fd = ctxt->soc[1].s;
			if (!dcc_info_unlock(emsg))
				return 0;
			dcc_ctxts_unlock();
			nfds = select_poll(emsg, pollfds, 2, 1, delay_us);
			dcc_ctxts_lock();
			if (nfds < 0)
				return 0;
			if (!dcc_info_lock(emsg))
				return 0;
			/* update pointer into mapped info
			 * in case another thread moved it */
			class = DCC_GREY2CLASS(clnt_fgs & DCC_CLNT_FG_GREY);
		}

		i = get_now(emsg, ctxt);
		if (!i) {		/* give up if the clock jumped */
			class->measure = 0;
			dcc_info_unlock(0);
			return 0;
		}
		if (addrs_gen != class->gen) {
			extra_pemsg(emsg, "competition stopped RTT measurement");
			/* if we have at least one address,
			 * hope the other process will finish the job */
			if (HAVE_CLASS_SRVR(class)
			    || pick_srvr(emsg, class, 0)) {
				return 1;
			}

			/* fail, but hope the other process will finish */
			dcc_info_unlock(0);
			return 0;
		}

		if (nfds > 0) {
			DCC_XLENT *xlent;

			i = clnt_recv(ctxt, pollfds, class, &resp, sizeof(resp),
				      &nop.hdr, &xlent);
			if (i < 0)	/* stop on serious error */
				break;
			if (i <= 1)	/* ignore Unreachables and no data */
				continue;

			/* record the results of a probe, and notice
			 * if the server is the best so far */
			ap = &class->addrs[xlent->srvr_inx];

			if (resp.hdr.op != DCC_OP_OK) {
				if (dcc_clnt_debug)
					dcc_trace_msg("RTT NOP answered"
						      " with %s by %s",
						      dcc_hdr_op2str(ob,
							  sizeof(ob),
							  &resp.hdr),
						      addr2str(abuf,
							  sizeof(abuf),
							  class,
							  xlent->addrs_gen,
							  ap, 0));
				ap->rtt = DCC_RTT_BAD;
				continue;
			}

			vers = resp.ok.max_pkt_vers;
			if (vers >= DCC_PKT_VERS_MAX)
				vers = DCC_PKT_VERS_MAX;
			else if (vers < DCC_PKT_VERS_MIN)
				vers = DCC_PKT_VERS_MIN;
			ap->srvr_pkt_vers = vers;
			ap->srvr_id = ntohl(resp.hdr.sender);
			memcpy(ap->brand, resp.ok.brand,
			       sizeof(ap->brand));
			ap->srvr_wait = ntohs(resp.ok.qdelay_ms)*1000;

			update_rtt(ctxt, class, xlent,
				   xlent->delay_us + ap->srvr_wait);
		}

		if (ctxt->xl.outstanding == 0
		    || (ctxt->xl.working_addrs >= tgt_addrs
			&& xmit_num > 1))
			next_xmit = ctxt->now_us;
		delay_us = next_xmit - ctxt->now_us;
	}
	/* the contexts and the shared information are locked */
	resp_rates(ctxt, class, 1);

	if (!pick_srvr(emsg, class, 1)) {
		fail_more(ctxt, class);
		dcc_info_unlock(0);
		return 0;
	}

	/* maintain the long term average that is used to switch back to
	 * a good server that temporarily goes bad */
	if (class->thold_rtt == DCC_RTT_BAD) {
		/* There is no point in trying to change servers
		 * Maybe we have only 1 */
		class->avg_thold_rtt = DCC_RTT_BAD;
	} else if (class->avg_thold_rtt == -DCC_RTT_BAD) {
		/* We are being forced to consider changing servers.
		 * The threshold for changing will be based on the RTT
		 * for the new server */
		class->avg_thold_rtt = class->base_rtt;
	} else {
		AGE_AVG(class->avg_thold_rtt, class->base_rtt, 9, 1);
	}

	class->measure = ctxt->now.tv_sec+FAST_RTT_SECS;

	/* Several systems do not update the mtime of a file modified with
	 * mmap().  Some like BSD/OS delay changing the mtime until the file
	 * accessed with read().  Others including filesystems on some
	 * versions of Linux apparently never change the mtime.
	 * Do not bother temporary map files that have already been unlinked
	 * to avoid problems on systems that do not have futimes() */
	if (!(dcc_clnt_info->fgs & DCC_INFO_FG_TMP))
		dcc_set_mtime(emsg, dcc_info_nm.c, info_fd, 0);
	flush_emsg(emsg);

	return 1;
}



/* Get and write-lock common info
 *      The contexts but not the info must be locked.
 *      The contexts remain locked on failure.  The shared information
 *	    is locked only on success. */
u_char					/* 0=failed 1=ok */
dcc_clnt_rdy(DCC_EMSG *emsg,		/* cleared of stale messages */
	     DCC_CLNT_CTXT *ctxt,
	     DCC_CLNT_FGS clnt_fgs)	/* DCC_CLNT_FG_* */
{
	DCC_SRVR_CLASS *class;
	u_char result;

	if (emsg)
		emsg->c[0] = '\0';

	if (!dcc_info_lock(emsg))
		return 0;

	get_start_time(ctxt);

	/* Close the socket so that it will be re-opened
	 * if the local address has changed
	 * or if the local address was broken a long time ago. */
	if (ctxt->soc[0].s != INVALID_SOCKET) {
		const DCC_CLNT_SRC *src;

		src = get_clnt_src(ctxt, ctxt->soc[0].loc.sa.sa_family);
		if (src != ctxt->soc[0].src
		    || (src && !DCC_SUnP_IP_EQ(&ctxt->soc[0].loc, &src->ip)))
			soc_close(&ctxt->soc[0]);
	}

	class = DCC_GREY2CLASS(clnt_fgs & DCC_CLNT_FG_GREY);

	/* just fail if things were broken and it's too soon to try again */
	if (!(clnt_fgs & DCC_CLNT_FG_NO_FAIL)
	    && !ck_fail_time(emsg, ctxt, class)) {
		dcc_info_unlock(0);
		return 0;
	}

	/* Check for new IP addresses occassionally */
	if (DCC_IS_TIME(ctxt->now.tv_sec, class->resolve, DCC_MAP_RESOLVE)
	    && !resolve_nms(emsg, ctxt, class))
		return 0;

	/* We might have switched to the current server when our
	 * best server became slow.
	 * If it has been a while, see if our best server is back
	 * by sending NOPs to all servers. */
	if ((class->measure == 0
	     || DCC_IS_TIME(ctxt->now.tv_sec, class->measure, FAST_RTT_SECS))
	    && !(clnt_fgs & DCC_CLNT_FG_NO_MEASURE_RTTS)) {
		result = measure_rtt(emsg, ctxt, clnt_fgs);
		/* another thread might have moved the mapped file */
		class = DCC_GREY2CLASS(clnt_fgs & DCC_CLNT_FG_GREY);
		clean_socs(ctxt, class);
		if (!result) {
			if (!(clnt_fgs & DCC_CLNT_FG_BAD_SRVR_OK)
			    || !HAVE_CLASS_SRVR(class))
				return 0;
			/* try to recover the lock on the file
			 * if we cannot give up on a bad server */
			if (!dcc_info_lock(emsg))
				return 0;
		}

	} else if (!good_rtt(class)) {
		/* Try to pick a new server if we do not have a server
		 * or if the current server has become slow or unreliable. */
		if (clnt_fgs & DCC_CLNT_FG_BAD_SRVR_OK) {
			pick_srvr(emsg, class, 0);

		} else if (!pick_srvr(emsg, class, 1)) {
			/* We do not have a good IP address
			 * and it is not time to resolve names
			 * We could always resolve when we have no server
			 * if DNS resolutions were fast, but DNS resolution
			 * can take many seconds. */
			fail_more(ctxt, class);
			dcc_info_unlock(0);
			return 0;
		}
	}

	/* minimize later debugging noise
	 * if the caller is not going to call before real work */
	if (!dcc_clnt_debug
	    && !(clnt_fgs & DCC_CLNT_FG_NO_MEASURE_RTTS))
		dcc_clnt_soc_flush(&ctxt->soc[0]);

	/* we are going to claim success, so see that no messages are lost */
	flush_emsg(emsg);

	return 1;
}



/* send an operation to the server and get a response
 *      The operation and response buffers must be distinct, because the
 *	    response buffer is changed before the last use of the operation
 *	    buffer */
u_char					/* 0=failed 1=ok */
dcc_clnt_op(DCC_EMSG *emsg,
	    DCC_CLNT_CTXT *ctxt,
	    DCC_CLNT_FGS clnt_fgs,	/* DCC_CLNT_FG_* */
	    const SRVR_INX *srvr_inxp,	/* 0 or ptr to server index */
	    DCC_SRVR_ID *srvr_idp,	/* ID of server used */
	    DCC_SOCKU *resp_su,		/* IP address of server used */
	    DCC_HDR *msg, int msg_len, DCC_OPS op,
	    DCC_OP_RESP *resp, int resp_max_len)
{
	DCC_SRVR_CLASS *class;
	DCC_SRVR_ADDR *cur_addr;
#ifdef DCC_PKT_VERS7
	DCC_REPORT  old_report;
#endif
	char addr_buf[80];
	int addrs_gen;
	DCC_OP_NUM op_num_r;
	SRVR_INX srvr_inx;
	int xmit_num;
	int next_xmit, us, remaining, nfds;
	u_char gotit, stop;
	DCC_POLLFD pollfds[2];
	int i;

	dcc_ctxts_lock();
	if (!dcc_clnt_info
	    && !dcc_map_info(emsg, 0, -1)) {
		dcc_ctxts_unlock();
		if (srvr_idp)
			*srvr_idp = DCC_ID_INVALID;
		return 0;
	}
	/* Get & lock common info.
	 * insist on a server to talk to so that class->srvr_inx is sane */
	if (!dcc_clnt_rdy(emsg, ctxt,
			  clnt_fgs & ~(DCC_CLNT_FG_BAD_SRVR_OK
				       | DCC_CLNT_FG_NO_MEASURE_RTTS))) {
		dcc_ctxts_unlock();
		if (srvr_idp)
			*srvr_idp = DCC_ID_INVALID;
		return 0;
	}
	class = DCC_GREY2CLASS(clnt_fgs & DCC_CLNT_FG_GREY);

	if (resp_max_len > ISZ(*resp))
		resp_max_len = ISZ(*resp);
	else if (resp_max_len < ISZ(resp->hdr))
		dcc_logbad(EX_SOFTWARE, "dcc_clnt_op(resp_max_len=%d)",
			   resp_max_len);

	/* use server that the caller wants,
	 * if the caller specified the valid index of a server */
	if (!srvr_inxp
	    || (srvr_inx = *srvr_inxp, !VALID_SRVR(class, srvr_inx)))
		srvr_inx = class->srvr_inx;

	cur_addr = &class->addrs[srvr_inx];
	if (srvr_idp)
		*srvr_idp = cur_addr->srvr_id;
	if (resp_su)
		dcc_ip2su(resp_su, &cur_addr->ip);
	addrs_gen = class->gen;

	++dcc_clnt_info->proto_hdr.op_nums.r;
	op_num_r = msg->op_nums.r;
	memcpy(msg, &dcc_clnt_info->proto_hdr, sizeof(*msg));
	/* old transaction ID for retransmissions */
	if (clnt_fgs & DCC_CLNT_FG_RETRANS)
		msg->op_nums.r = op_num_r;
	if (cur_addr->srvr_pkt_vers > DCC_PKT_VERS_MAX
	    || cur_addr->srvr_pkt_vers < DCC_PKT_VERS_MIN) {
		dcc_pemsg(EX_DATAERR, emsg, "impossible pkt_vers %d for %s",
			  cur_addr->srvr_pkt_vers,
			  addr2str(addr_buf, sizeof(addr_buf), class,
				   addrs_gen, cur_addr, 0));
		dcc_info_unlock(0);
		dcc_ctxts_unlock();
		if (srvr_idp)
			*srvr_idp = DCC_ID_INVALID;
		return 0;
	}

#ifdef DCC_PKT_VERS7
	/* convert new report to old */
	if (cur_addr->srvr_pkt_vers <= DCC_PKT_VERS7
	    && op == DCC_OP_REPORT) {
		DCC_TGTS tgts;

		tgts = ntohl(((DCC_REPORT *)msg)->tgts);
		if (tgts & DCC_TGTS_REP_SPAM) {
			memcpy(&old_report, msg, msg_len);
			tgts &= ~DCC_TGTS_REP_SPAM;
			tgts |= DCC_TGTS_SPAM;
#ifdef DCC_PKT_VERS4
			if (cur_addr->srvr_pkt_vers == DCC_PKT_VERS4)
				tgts = DCC_TGTS_TOO_MANY;
#endif /* DCC_PKT_VERS4 */
			old_report.tgts = htonl(tgts);
			msg = &old_report.hdr;
		}

#ifdef DCC_PKT_VERS4
		if (cur_addr->srvr_pkt_vers == DCC_PKT_VERS4
		    && (tgts & DCC_TGTS_SPAM)) {
			memcpy(&old_report, msg, msg_len);
			old_report.tgts = htonl(DCC_TGTS_TOO_MANY);
			msg = &old_report.hdr;
		}
#endif
	}
#endif /* DCC_PKT_VERS7 */

	msg->pkt_vers = cur_addr->srvr_pkt_vers;
	msg->op_nums.p = getpid();
	msg->op = op;
	gotit = 0;
	stop = 0;

	/* The measured RTTs to servers helps the client pick a server
	 * that will respond quickly and reliably and to know when to
	 * retransmit a request that is lost due to network congestion or
	 * bit rot.
	 *
	 * It is desirable for a client to concentrate its reports to
	 * a single server.  That makes detecting spam by this and other
	 * clients quicker.
	 *
	 * A client should retransmit when its initial transmission is lost
	 * due to bit rot or congestion.  In case the loss is due to
	 * congestion, it should retransmit only a limited number of
	 * times and with increasing delays between retransmissions.
	 *
	 * It is more important that some requests from clients reach
	 * a DCC server than others.  Most DCC checksum reports are not about
	 * spam, and so it is best to not spend too much network bandwidth
	 * retransmitting checksum reports or to delay the processing of the
	 * messages. Administrative commands must be tried harder.
	 * Therefore, let the caller of this routine decide whether to retry.
	 * This routine merely increases the measured RTT after failures. */

	clear_xl(ctxt);
	xmit_num = 0;
	next_xmit = ctxt->now_us;

	/* Transmit, wait for a response, and repeat if needed.
	 * The initial transmission is done as if it were a retransmission. */
	do {
		us = next_xmit - ctxt->now_us;
		if (us <= 0 || ctxt->xl.outstanding == 0) {
			/* We have delayed long enough for each outstanding
			 * transmission.  We are done if we have sent enough */
			if (xmit_num >= DCC_MAX_XMITS)
				break;

			/* stop if we don't have enough time to wait */
			us = retrans_time(cur_addr->rtt, xmit_num);
			remaining =  DCC_MAX_DELAY - ctxt->now_us;
			if (us > remaining) {
				if (remaining < DCC_MIN_RTT)
					break;
				us = remaining;
			}

			/* wait as long as possible on the last try */
			if (++xmit_num == DCC_MAX_XMITS
			    && us < DCC_MAX_RTT) {
				if (remaining > DCC_MAX_RTT)
					us = DCC_MAX_RTT;
				else
					us = remaining;
			}
			next_xmit = us + ctxt->now_us;

			/* Because of the flooding algorithm among DCC servers,
			 * it is important that only a single server receive
			 * reports of the checksums for a mail message.
			 * That implies that retransmissions of reports must
			 * go to the original server, even if some other local
			 * client has re-resolved host names or switched
			 * to a better server.
			 * Otherwise our retransmissions to different servers
			 * would not be recognized as retransmissions but
			 * reports about separate copies of the mail message.
			 * Sp we should not retransmit if the server
			 * address table changes. */
			if (addrs_gen != class->gen
			    && op == DCC_OP_REPORT
			    && !(clnt_fgs & DCC_CLNT_FG_GREY)) {
				if (dcc_clnt_debug)
					dcc_trace_msg("server address"
						      " generation changed");
				break;
			}

			if (!VALID_NAM(cur_addr->nam_inx)) {
				if (dcc_clnt_debug)
					dcc_trace_msg("server deleted");
				break;
			}

			/* use a connected socket early to get
			 * port unreachable ICMP error messages,
			 * but do not later to detect multi-homing */
			clnt_xmit(emsg, ctxt, class, cur_addr,
				  msg, msg_len,
				  (!(cur_addr->flags & DCC_SRVR_ADDR_MHOME)
				   && xmit_num < DCC_MAX_XMITS/2
				   && ctxt->now_us <= DCC_MAX_DELAY/2));
		}

		if (ctxt->xl.outstanding == 0
		    || (ctxt->soc[0].s == INVALID_SOCKET
			&& ctxt->soc[1].s == INVALID_SOCKET)) {
			nfds = 0;

		} else {
			pollfds[0].fd = ctxt->soc[0].s;
			pollfds[1].fd = ctxt->soc[1].s;

			/* release the mapped info while waiting */
			if (!dcc_info_unlock(emsg)) {
				dcc_ctxts_unlock();
				if (srvr_idp)
					*srvr_idp = DCC_ID_INVALID;
				return 0;
			}
			dcc_ctxts_unlock();
			nfds = select_poll(emsg, pollfds, 2, 1, us);
			/* recover lock to record answer in mapped file */
			dcc_ctxts_lock();
			/* update pointer into mapped info
			 * in case another thread moved it */
			class = DCC_GREY2CLASS(clnt_fgs & DCC_CLNT_FG_GREY);
			if (!dcc_info_lock(emsg)) {
				dcc_ctxts_unlock();
				if (srvr_idp)
					*srvr_idp = DCC_ID_INVALID;
				return 0;
			}
		}

		/* give up if time jumped */
		if (!get_now(emsg, ctxt)) {
			dcc_info_unlock(0);
			dcc_ctxts_unlock();
			return 0;
		}

		if (nfds > 0) {
			for (;;) {
				DCC_XLENT *xlent;
				DCC_OP_RESP buf;

				i = clnt_recv(ctxt, pollfds, class, &buf,
					      min(ISZ(buf), resp_max_len),
					      msg, &xlent);
				if (i < 0) {	/* serious problem */
					stop = 1;
					break;
				}
				if (i == 0) /* no more data */
					break;
				if (i == 1) {
					/* stop sending after the first
					 * ICMP Unreachable message,
					 * but collect everything that has
					 * already arrived */
					stop = 1;
					continue;
				}

				/* Update the average RTT with this response.
				 * Compensate for an unusual request that
				 * escaped the server's normal queuing delay */
				update_rtt(ctxt, class, xlent,
					   ctxt->now_us - xlent->sent_us
					   + ((op != DCC_OP_REPORT
					       && op != DCC_OP_QUERY)
					      ? cur_addr->srvr_wait : 0));

				/* save the last answer we get */
				memcpy(resp, &buf, ntohs(buf.hdr.len));
				gotit = 1;
				stop = 1;
			}
		}
	} while (!stop);
	/* the contexts and the shared information are locked */

	/* penalize server for lost packets */
	resp_rates(ctxt, class, 0);

	/* there should be only 1 useful socket,
	 * but we might have switched address families */
	clean_socs(ctxt, class);

	/* fail if the server did not answer at all */
	if (!gotit) {
#if 0
		system("./abort_dccd");
#endif
		flush_emsg(emsg);
		dcc_pemsg(EX_TEMPFAIL, emsg, "no %s answer from %s after %d ms",
			  DCC_IS_GREY_STR(class),
			  addr2str(addr_buf, sizeof(addr_buf), class,
				   addrs_gen, cur_addr, 0),
			  ctxt->now_us/1000);
		/* Since we got no answer at all, look for a different server.
		 * If we can't find any server or a different server
		 * or if we have already spent too much time,
		 * then don't try again for a while to not delay the MTA.
		 * If we find another server, then return the valid server-ID
		 * of the non-responsive server to let the caller know that it
		 * can try again immediately. */
		if (srvr_inxp && srvr_inx == *srvr_inxp) {
			/* but only if not using a caller specified server */
			if (srvr_idp)
				*srvr_idp = DCC_ID_INVALID;
		} else if (!pick_srvr(emsg, class, 1)
			   || srvr_inx == class->srvr_inx) {
			if (srvr_idp) {
				if (dcc_clnt_debug)
					dcc_trace_msg("no better alternate"
						      " for retry");
				*srvr_idp = DCC_ID_INVALID;
			}
			fail_more(ctxt, class);
		} else if (srvr_idp
			   && (i = retrans_time(class->addrs[class ->srvr_inx
							].rtt, 0),
			       ctxt->now_us + i >= DCC_MAX_DELAY)) {
			/* discourage the caller from trying the other server
			 * if the total delay after trying the other server
			 * would be excessive */
			if (dcc_clnt_debug)
				dcc_trace_msg("alternate too slow for retry"
					      " with rtt %d ms after %d ms",
					      i/1000,
					      ctxt->now_us/1000);
			*srvr_idp = DCC_ID_INVALID;
		}
		dcc_info_unlock(0);
		dcc_ctxts_unlock();
		return 0;
	}

	/* reset failure backoff */
	class->fail_exp = 0;

	if (!dcc_info_unlock(emsg)) {
		dcc_ctxts_unlock();
		if (srvr_idp)
			*srvr_idp = DCC_ID_INVALID;
		return 0;
	}
	dcc_ctxts_unlock();

	clean_socs(ctxt, class);

	flush_emsg(emsg);
	return 1;
}
