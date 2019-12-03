/* Distributed Checksum Clearinghouse
 *
 * deal with incoming floods of checksums
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
 * Rhyolite Software DCC 2.3.167-1.307 $Revision$
 */

#include "dccd_defs.h"
#include <sys/wait.h>
#ifdef HAVE__RES
#include <resolv.h>
#endif


IFLODS iflods;

u_int complained_many_iflods;

time_t got_hosts;
pid_t resolve_hosts_pid = -1;

time_t iflods_ok_timer;			/* incoming flooding ok since then */

u_char flod_msg_gen;			/* unsuppress tracing */

static u_char iflod_write(IFLOD_INFO *, void *, int, const char *, u_char);


static DCC_TS future;			/* timestamp sanity */

#ifndef HAVE_GCC_INLINE
void
db_ptr2flod_pos(DCC_FLOD_POS bp, DB_PTR pos) _db_ptr2flod_pos(bp, pos)

DB_PTR
flod_pos2db_ptr(const DCC_FLOD_POS pos) { return _flod_pos2db_ptr(pos); }
#endif


ID_MAP_RESULT
id_map(DCC_SRVR_ID srvr, const SRVR_ID_MAPS *maps)
{
	ID_MAP_RESULT result;
	int i;

	/* pass special IDs unchanged */
	if (!DCC_ID_SRVR_NORMAL(srvr))
		return ID_MAP_NO;

	/* apply the first server-ID map that matches, if any */
	for (i = 0; i < maps->len; ++i) {
		if (maps->entry[i].lo <= srvr
		    && maps->entry[i].hi >= srvr) {
			result = maps->entry[i].result;
			if (result == ID_MAP_SELF
			    && srvr == my_srvr_id)
				return ID_MAP_NO;
			return result;
		}
	}
	return ID_MAP_NO;
}



static const char *
rem_str(const char *hostname, const DCC_SOCKU *su)
{
	static int bufno;
	static struct {
	    char    str[90];
	} bufs[4];
	char *s;
	char sustr[DCC_SU2STR_SIZE];
	int i;

	s = bufs[bufno].str;
	bufno = (bufno+1) % DIM(bufs);

	STRLCPY(s, hostname, sizeof(bufs[0].str));

	if (su->sa.sa_family == AF_UNSPEC
	    && DCC_SU_PORT(su) == 0)
		return s;

	dcc_su2str2(sustr, sizeof(sustr), su);
	if (strcmp(s, sustr)) {
		STRLCAT(s, " ", sizeof(bufs[0].str));
		STRLCAT(s, sustr, sizeof(bufs[0].str));
	}
	if (DCC_SU_PORT(su) != DCC_GREY2PORT(grey_on)) {
		i = strlen(s);
		snprintf(s+i, sizeof(bufs[0].str)-i,
			 ",%d", ntohs(DCC_SU_PORT(su)));
	}
	return s;
}



const char *
ifp_rem_str(const IFLOD_INFO *ifp)
{
	if (!ifp)
		return "(null ifp)";
	return rem_str(ifp->rem_hostname, &ifp->rem);
}



const char *
ofp_rem_str(const OFLOD_INFO *ofp)
{
	if (!ofp)
		return "(null ofp)";
	return rem_str(ofp->rem_hostname, &ofp->rem);
}



static const char *
rpt_id(const char *type,
       const DB_RCD* rcd,
       const IFLOD_INFO *ifp)
{
	static int bufno;
	static struct {
	    char    str[120];
	} bufs[4];
	char *s;
	char id_buf[30];

	s = bufs[bufno].str;
	bufno = (bufno+1) % DIM(bufs);

	snprintf(s, sizeof(bufs[0].str), "%s%s %s ID=%s %s%s",
		 type ? "flooded " : "",
		 type ? type : "",
		 ts2str_err(&rcd->ts),
		 id2str(id_buf, sizeof(id_buf), rcd->srvr_id),
		 ifp ? "from " : "",
		 ifp ? ifp_rem_str(ifp) : "");
	return s;
}



/* print an error message,
 *	followed by a note saying this is the last if it is.
 *	must always be preceded by CK_FLOD_CNTERR() */
void DCC_PF(2,3)
flod_cnterr(const FLOD_LIMCNT *lc, const char *p, ...)
{
	char buf[DCC_FLOD_MAX_RESP];
	va_list args;

	va_start(args, p);
	if (db_debug >= 2 || lc->cur < lc->lim + FLOD_LIM_COMPLAINTS) {
		dcc_verror_msg(p, args);
	} else {
		vsnprintf(buf, sizeof(buf), p, args);
		dcc_error_msg("%s; stop complaints", buf);
	}
	va_end(args);
}



static void
date_ferr_msg(FERR_MSG out, int len, const char *in)
{
	memcpy(out, in, len);
	if (len >= ISZ(FERR_MSG)-LITZ(" at hh:mm:ss")-1) {
		out[len] = '\0';
	} else {
		dcc_time2str(&out[len], ISZ(FERR_MSG)-len, " %b %d %X",
			     db_time.tv_sec);
	}
}



/* remove extra quotes and strings from a message to or from a peer */
static void
trim_ferr_msg(FERR_MSG out, const FERR_MSG in)
{
	char *q1, *q2;
	int len;

	q1 = strchr(in, '\'');
	if (q1) {
		q2 = strrchr(++q1, '\'');
		if (q2) {
			len = q2-q1;
			if (len > LITZ(DCC_FLOD_OK_STR)
			    && !LITCMP(q1, DCC_FLOD_OK_STR)) {
				len -= LITZ(DCC_FLOD_OK_STR);
				q1 += LITZ(DCC_FLOD_OK_STR);
			}
			date_ferr_msg(out, len, q1);
			return;
		}
	}
	date_ferr_msg(out, strlen(in), in);
}



/* report a flooding error */
void DCC_PF(5,6)
ferr(OFLOD_INFO *ofp,
     u_char in,				/* 0=output 1=input */
     FERR_TYPE etype,
     u_char trace,			/* 0=error, 1=trace, 2=no dup trace */
     const char *p, ...)
{
	LAST_FERR *ep;
	FERR_MSG tmp, trimmed;
	va_list args;

	va_start(args, p);
	vsnprintf(tmp, sizeof(tmp), p, args);
	va_end(args);

	if (ofp) {
		ep = in ? &ofp->mp->iflod_err : &ofp->mp->oflod_err;
	} else {
		ep = 0;
	}

	if (!trace) {
		dcc_error_msg("%s", tmp);
		if (ep) {
			trim_ferr_msg(ep->error_msg, tmp);
			ep->error_type = etype;
			ep->error_gen = flod_msg_gen-1;
			ep->trace_type = FERR_NONE;
		}
		return;
	}

	if (!ep) {
		TMSG_FLOD1(ofp, tmp);
		return;
	}

	trim_ferr_msg(trimmed, tmp);
	if (TMSG_FB1(ofp)
	    && (trace < 2
		|| ep->error_type != etype
		|| strcmp(trimmed, ep->trace_msg)
		|| ep->trace_gen != flod_msg_gen)) {
		/* suppress some duplicate flooding messages */
		dcc_trace_msg("%s", tmp);
		ep->trace_gen = flod_msg_gen;
	} else {
		ep->trace_gen = flod_msg_gen-1;
	}
	STRLCPY(ep->trace_msg, trimmed, sizeof(ep->trace_msg));
	ep->trace_type = etype;
}



/* forget error message when the problem is fixed */
void
ferr_clear(OFLOD_INFO *ofp, u_char in, FERR_TYPE etype)
{
	LAST_FERR *ep;

	ep = in ? &ofp->mp->iflod_err : &ofp->mp->oflod_err;
	if (ep->error_type != FERR_NONE
	    && (ep->error_type == etype || etype == FERR_NONE)) {
		ep->error_type = FERR_NONE;
		ep->trace_type = FERR_NONE;

	} else if (ep->trace_type == etype || etype == FERR_NONE) {
		ep->trace_type = FERR_NONE;
	}
}



void
ferr_clear_all(OFLOD_INFO *ofp, u_char in)
{
	ferr_clear(ofp, in, FERR_NONE);
}



u_char
set_flod_socket(OFLOD_INFO *ofp, u_char in, int s,
		const char *rem_hostname, const DCC_SOCKU *sup)
{
	int on;

	if (0 > fcntl(s, F_SETFD, FD_CLOEXEC))
		ferr(ofp, in, FERR_SOCK, 0,
		     "fcntl(%s, F_SETFD, FD_CLOEXEC): %s",
		     rem_str(rem_hostname, sup), ERROR_STR());

	if (-1 == fcntl(s, F_SETFL,
			fcntl(s, F_GETFL, 0) | O_NONBLOCK)) {
		ferr(ofp, in, FERR_SOCK, 0,
		     "fcntl(%s, O_NONBLOCK): %s",
		     rem_str(rem_hostname, sup), ERROR_STR());
		return 0;
	}

	on = 1;
	if (0 > setsockopt(s, SOL_SOCKET, SO_KEEPALIVE, &on, sizeof(on))) {
		ferr(ofp, in, FERR_SOCK, 0,
		     "setsockopt(flod %s, SO_KEEPALIVE): %s",
		     rem_str(rem_hostname, sup), ERROR_STR());
	}

	if (in) {
		/* Ensure that we have enough socket buffer space to send
		 * complaints about the input flood.  Normally little or
		 * nothing is sent upstream, but bad clocks or other
		 * problems can cause many complaints. */
		if (0 > setsockopt(s, SOL_SOCKET, SO_SNDBUF,
				   &socbuf, sizeof(socbuf)))
			ferr(ofp, in, FERR_SOCK, 0,
			     "setsockopt(%s, SO_SNDBUF): %s",
			     rem_str(rem_hostname, sup), ERROR_STR());
	}

	return 1;
}



void
bind_flod_socket(OFLOD_INFO *ofp, int s, const DCC_SOCKU *rem, const DNS *dns)
{
	DCC_SOCKU loc;
	const SRVR_SOC *sp;
	DCC_FNM_LNO_BUF fnm_buf;

	/* match local IPv6 or IPv4 to remote name */
	if (rem->sa.sa_family == dns->loc_v4.sa.sa_family) {
		ofp->flags &= ~OFLOD_FG_LOC_MSG;
		loc = dns->loc_v4;

	} else if (rem->sa.sa_family == dns->loc_v6.sa.sa_family) {
		ofp->flags &= ~OFLOD_FG_LOC_MSG;
		loc = dns->loc_v6;

	} else if (ofp->loc_hostname[0] == '\0') {
		ofp->flags &= ~OFLOD_FG_LOC_MSG;
		memset(&loc, 0, sizeof(loc));

	} else {
		if (!(ofp->flags & OFLOD_FG_LOC_MSG)) {
			/* after complaining, continue as if no
			 * local name had been specified */
			if (dns->loc_v4.sa.sa_family == AF_UNSPEC
			    && dns->loc_v6.sa.sa_family == AF_UNSPEC) {
				dcc_error_msg("flood local name %s: %s%s",
					      ofp->loc_hostname,
					      H_ERROR_STR1(dns->loc_h_errno),
					      dcc_fnm_lno(&fnm_buf, flod_path.c,
							ofp->lno));
			} else {
				dcc_error_msg("no IPv%c address for"
					      " flood local name %s %s %s",
					      rem->sa.sa_family == AF_INET
					      ? '4' : '6',
					      ofp->loc_hostname,
					      dcc_su2str_err(rem),
					      dcc_fnm_lno(&fnm_buf, flod_path.c,
							ofp->lno));
			}
			ofp->flags |= OFLOD_FG_LOC_MSG;
		}
		memset(&loc, 0, sizeof(loc));
	}

	/* If we did not find a local hostname for the connection
	 * and if there is a single "-a address" other than localhost
	 * and of the right family, then default to it. */
	if (loc.sa.sa_family == AF_UNSPEC) {
		for (sp = srvr_socs; sp; sp = sp->fwd) {
			if (dcc_su_is_loopback(&sp->udp_su))
				continue;
			if (sp->udp_su.sa.sa_family != rem->sa.sa_family)
				continue;
			if (loc.sa.sa_family != AF_UNSPEC) {
				/* more than one, so give up */
				memset(&loc, 0, sizeof(loc));
				break;
			}
			loc = sp->udp_su;
		}
	}

	/* if we have a local IP address for connection,
	 * try to bind() to it */
	if (loc.sa.sa_family != AF_UNSPEC
	    || ofp->loc_port != 0) {
		if (loc.sa.sa_family == AF_UNSPEC)
			dcc_mk_su(&loc, rem->sa.sa_family,
				  0, 0, ofp->loc_port);
		else
			DCC_SU_PORT(&loc) = ofp->loc_port;
		if (0 > bind(s, &loc.sa, DCC_SU_LEN(&loc)))
			dcc_error_msg("bind(flood %s%s): %s",
				      dcc_su2str_err(&loc),
				      dcc_fnm_lno(&fnm_buf,
						  flod_path.c, ofp->lno),
				      ERROR_STR());
	}
}



/* see if the host name resolution process is still running */
u_char					/* 1=not running 0=please wait */
flod_names_resolve_ck(void)
{
	int status;
	pid_t pid;

	if (resolve_hosts_pid < 0)
		return 1;

	pid = waitpid(resolve_hosts_pid, &status, WNOHANG);
	if (pid <= 0) {
		if (pid < 0 && errno != EINTR)
			dcc_error_msg("resolve waitpid(): %s", ERROR_STR());
		RUSH_NEXT_FLODS_CK();
		return 0;
	}

	resolve_hosts_pid = -1;
#if defined(WIFEXITED) && defined(WEXITSTATUS) && defined(WTERMSIG) && defined(WIFSIGNALED)
	if (WIFEXITED(status)) {
		status = WEXITSTATUS(status);
		if (status != 0)
			dcc_error_msg("resolver child exited with %d", status);
	} else if (WIFSIGNALED(status)) {
		status = WTERMSIG(status);
		dcc_error_msg("resolver child exited with signal %d", status);
	} else {
		dcc_error_msg("unknown resolve exit status %#x", status);
	}
#else
	if (status != EX_OK)
		dcc_error_msg("resolver child exited with status %d", status);
#endif

	return 1;
}



/* Resolve all needed host names, perhaps in a separate process.
 *	Leave the results in the file */
static void
flod_names_resolve(void)
{
	FLOD_MMAP *mp;
	DCC_GETH ipv6;
	u_char ok;
	DCC_SOCKU *sup, *sup2;

#ifdef HAVE_RES_INIT
	/* get new contents of /etc/resolv.conf */
	res_init();
#endif

	for (mp = flod_mmaps->mmaps; mp <= LAST(flod_mmaps->mmaps); ++mp) {
		if (mp->rem_hostname[0] == '\0'
		    || (mp->flags & FLODMAP_FG_PASSIVE))
			continue;

		if (mp->flags & FLODMAP_FG_IPv4)
			ipv6 = DCC_GETH_V4;
		else if (mp->flags & FLODMAP_FG_IPv6)
			ipv6 = DCC_GETH_V6;
		else if (use_ipv46 == DCC_GETH_V46 && !have_ipv6_peer)
			ipv6 = DCC_GETH_V4;
		else
			ipv6 = use_ipv46;

		memset(&mp->dns, 0, sizeof(mp->dns));

		dcc_host_lock();

		/* use first addresses for the local host name */
		if (mp->loc_hostname[0] != '\0') {
			if (mp->flags & FLODMAP_FG_SOCKS)
				ok = dcc_get_host_SOCKS(mp->loc_hostname, ipv6,
							&mp->dns.loc_h_errno);
			else
				ok = dcc_get_host(mp->loc_hostname, ipv6,
						  &mp->dns.loc_h_errno);
			if (!ok) {
				TMSG2(FLOD1, "failed to resolve %s: %s",
				      mp->loc_hostname,
				      H_ERROR_STR1(mp->dns.loc_h_errno));
			} else {
				/* save first local IP address of each family */
				for (sup = dcc_hostaddrs;
				     sup < dcc_hostaddrs_end;
				     ++sup) {
					sup2 = (sup->sa.sa_family == AF_INET
						? &mp->dns.loc_v4
						: &mp->dns.loc_v6);
					if (sup2->sa.sa_family
					    != sup->sa.sa_family)
					    *sup2 = *sup;
				}
				/* If we have only 1 local address, then prefer
				 * that family for the remote addresses.
				 * If we don't have an IPv6 address and we are
				 * not constrained to IPv6 for the remote
				 * address, look for an IPv4 remote address. */
				if (mp->dns.loc_v6.sa.sa_family == AF_UNSPEC
				    && ipv6 != DCC_GETH_V6)
					ipv6 = DCC_GETH_V4;
				else if (mp->dns.loc_v4.sa.sa_family==AF_UNSPEC
					 && ipv6 != DCC_GETH_V4)
					ipv6 = DCC_GETH_V6;
			}
		}

		/* resolve the remote host name into a bunch of addresses */
		if (mp->flags & FLODMAP_FG_SOCKS)
			ok = dcc_get_host_SOCKS(mp->rem_hostname, ipv6,
						&mp->dns.rem_h_errno);
		else
			ok = dcc_get_host(mp->rem_hostname, ipv6,
					  &mp->dns.rem_h_errno);
		if (!ok) {
			TMSG2(FLOD1, "failed to resolve %s: %s",
			      mp->rem_hostname,
			      H_ERROR_STR1(mp->dns.rem_h_errno));
		} else {
			sup2 = mp->dns.su;
			sup = dcc_hostaddrs;
			do {
				*sup2++ = *sup++;
			} while (++mp->dns.num < DIM(mp->dns.su)
				 && sup < dcc_hostaddrs_end);
		}
		dcc_host_unlock();

		flod_mmap_sync(0, 1);
	}
}



/* start a process to wait for the domain name system or other
 * hostname system to get the IP addresses of our flooding peers */
u_char					/* 1=finished 0=please wait */
flod_names_resolve_start(const OFLOD_INFO *ofp)
{
	if (!flod_mmaps)
		return 0;

	/* wait for background job to finish */
	if (!flod_names_resolve_ck())
		return 0;

	/* we're finished if we have recent address for all of the names */
	if (!DB_IS_TIME(got_hosts, FLOD_NAMES_RESOLVE_SECS))
		return 1;

	got_hosts = db_time.tv_sec + FLOD_NAMES_RESOLVE_SECS;
	flod_mmap_sync(0, 0);

	if (!background) {
		TMSG_FLOD1(ofp, "resolving host names in the foreground");
		flod_names_resolve();
		return 1;
	}

	resolve_hosts_pid = fork();
	if (resolve_hosts_pid > 0) {
		/* check again soon */
		RUSH_NEXT_FLODS_CK();
		return 0;
	}

	if (resolve_hosts_pid == -1) {
		dcc_error_msg("fork(flood names resolve start): %s;"
			      " fall back to foreground resolving",
			      ERROR_STR());
		flod_names_resolve();
		return 1;
	}

	TMSG_FLOD1(ofp, "resolving host names started");
	/* close files and sockets to avoid interfering with parent */
	after_fork();

	flod_names_resolve();

	TMSG_FLOD1(ofp, "resolving host names finished");

	exit(0);
}



static void
iflod_delay(OFLOD_INFO *ofp)
{
	FLOD_MMAP *mp;

	ofp->i_dns.num = 0;		/* start from 1st IP address next time */

	mp = ofp->mp;
	if (mp->itimers.retry_secs < FLOD_RETRY_SECS)
		mp->itimers.retry_secs = FLOD_RETRY_SECS;
	mp->itimers.retry = db_time.tv_sec + mp->itimers.retry_secs;
	if ((mp->flags & FLODMAP_FG_ACT) != 0)
		TMSG3_FLOD1(ofp,
			    "postpone restarting %s flood from"
			    " %s for %d seconds",
			    socks_type_str(mp),
			    ofp_rem_str(ofp), mp->itimers.retry_secs);
}



static void
iflod_socks_backoff(OFLOD_INFO *ofp)
{
	FLOD_MMAP *mp;

	ofp->i_dns.num = 0;		/* start from 1st IP address next time */

	mp = ofp->mp;
	mp->itimers.retry_secs *= 2;
	if (mp->itimers.retry_secs > FLOD_MAX_RETRY_SECS)
		mp->itimers.retry_secs = FLOD_MAX_RETRY_SECS;
	else if (mp->itimers.retry_secs < FLOD_RETRY_SECS)
		mp->itimers.retry_secs = FLOD_RETRY_SECS;
}



static void
iflod_clear(IFLOD_INFO *ifp,
	    u_char fail)		/* 1=problems so delay restart */
{
	OFLOD_INFO *ofp;

	ofp = ifp->ofp;
	if (fail && ofp != 0)
		iflod_delay(ifp->ofp);

	/* do not close the socket here, because it may be a passive outgoing
	 * stream that is being converted  */
	if (ifp->soc >= 0)
		--iflods.open;

	memset(ifp, 0, sizeof(*ifp));
	ifp->soc = -1;

	if (iflods.open == 0
	    && oflods.open == 0
	    && flods_st != FLODS_ST_ON)
		oflods_clear();
}



void DCC_PF(5,6)
iflod_close(IFLOD_INFO *ifp,
	    u_char fail,		/* 1=already sick; more is no problem */
	    u_char complain,		/* 1=error not just trace message */
	    u_char send_reason,
	    const char *pat, ...)
{
	struct {
	    DCC_FLOD_POS    last_pos;
	    DCC_FLOD_RESP   e;
	    u_char	    null;	/* to eat '\0' for e.msg */
	} resp;
	void *wp;
	va_list args;
	OFLOD_INFO *ofp;
	struct linger nowait;
	int wlen;

	ofp = ifp->ofp;

	db_ptr2flod_pos(resp.e.end.pos, DCC_FLOD_POS_END);
	va_start(args, pat);
	/* Throw away the last byte of resp.e.end.msg because the too smart
	 * by half gcc Fortify nonsense won't allow ISZ(resp.e.end.msg)+1.
	 * That put the would the unwanted '\0' from vsnprintf() into
	 * resp.null */
	wlen = vsnprintf(resp.e.end.msg, ISZ(resp.e.end.msg), pat, args);
	va_end(args);
	if (wlen > ISZ(resp.e.end.msg))
		wlen = ISZ(resp.e.end.msg);
	wlen += FLOD_END_OVHD;

	/* If useful, prefix our final message with our final position
	 * The peer will see our position and final operation as two
	 * separate responses. */
	if (memcmp(ifp->pos, ifp->pos_sent, ISZ(ifp->pos))) {
		memcpy(resp.last_pos, ifp->pos, ISZ(resp.last_pos));
		wlen += ISZ(resp.last_pos);
		wp = &resp.last_pos;
	} else {
		wp = &resp.e;
	}

	if (send_reason) {
		ferr(ofp, 1, FERR_CLOSE, !complain,
		     "stop incoming flood; %ssend '%s' to %s",
		     fail ? "error, " : "",
		     resp.e.end.msg,
		     ifp_rem_str(ifp));

		/* send the final status report to the sending flooder */
		iflod_write(ifp, wp, wlen, "stop incoming flood", fail ? 2 : 1);

	} else {
		ferr(ofp, 1, FERR_CLOSE, !complain,
		     "stop incoming flood; %s'%s'",
		     fail ? "error, " : "", resp.e.end.msg);
	}

	if (ifp->soc >= 0) {
		if (stopint
		    && !(ifp->flags & IFLOD_FG_FAST_LINGER)) {
			ifp->flags |= IFLOD_FG_FAST_LINGER;
			nowait.l_onoff = 1;
			nowait.l_linger = SHUTDOWN_DELAY;
			if (0 > setsockopt(ifp->soc, SOL_SOCKET, SO_LINGER,
					   &nowait, sizeof(nowait))
			    && !fail)
				dcc_error_msg("setsockopt(SO_LINGER %s): %s",
					      ifp_rem_str(ifp), ERROR_STR());
		}

		if (0 > close(ifp->soc)
		    && !fail) {
			if (errno == ECONNRESET)
				TMSG2_FLOD1(ofp, "close(flood from %s): %s",
					    ifp_rem_str(ifp), ERROR_STR());
			else
				dcc_error_msg("close(flood from %s): %s",
					      ifp_rem_str(ifp), ERROR_STR());
		}
	}

	/* If this was not a new bad connection being discarded,
	 * break the association with the outgoing stream. */
	if (ofp != 0 && ofp->ifp == ifp) {
		ofp->ifp = 0;
		save_flod_cnts(ofp);
	}

	iflod_clear(ifp, fail);
}



/* can close the incoming flood and so clear things */
static u_char				/* 0=failed & should be or is closed */
iflod_write(IFLOD_INFO *ifp,
	    void *buf, int buf_len,
	    const char *type,		/* string describing operation */
	    u_char close_it)		/* 0=iflod_close() on error, */
{					/* 1=complain, 2=ignore error */
	int i;

	if (!(ifp->flags & IFLOD_FG_CONNECTED))
		return 1;

	if (ifp->ofp
	    && (ifp->ofp->o_opts.flags & FLOD_OPT_SOCKS)) {
		i = Rsend(ifp->soc, buf, buf_len, 0);
	} else {
		/* If we don't know the corresponding output stream because we
		 * have not yet seen any authentication, we at least know the
		 * connection did not involve SOCKS because we did not
		 * originate it. */
		i = send(ifp->soc, buf, buf_len, 0);
	}
	if (i == buf_len) {
		ifp->iflod_alive = db_time.tv_sec;
		return 1;
	}

	if (i < 0) {
		if (close_it == 0) {
			iflod_close(ifp, 1, 0, 0, "send(%s %s): %s",
				    type, ifp_rem_str(ifp), ERROR_STR());
		} else if (close_it == 1) {
			dcc_error_msg("send(%s %s): %s",
				      type, ifp_rem_str(ifp), ERROR_STR());
		}
	} else {
		if (close_it == 0) {
			iflod_close(ifp, 1, 0, 0, "send(%s %s)=%d not %d",
				    type, ifp_rem_str(ifp), i, buf_len);
		} else if (close_it == 1) {
			dcc_error_msg("send(%s %s)=%d not %d",
				      type, ifp_rem_str(ifp), i, buf_len);
		}
	}
	return 0;
}



/* send our current position to the peer
 *	the peer must be well known so that ifp->ofp->mp!=0, usually
 *	    because (ifp->flags & IFLOD_FG_VERS_CK)
 *	can close the incoming flood and so clear things */
int					/* -1=fail 0=nothing to send, 1=sent */
iflod_send_pos(IFLOD_INFO *ifp,
	       u_char force)		/* say just anything */
{
	DCC_FLOD_POS req;
	OFLOD_INFO *ofp;
	FLOD_MMAP *mp;

	ofp = ifp->ofp;
	mp = ofp->mp;

	if (mp->flags & FLODMAP_FG_FFWD_IN) {
		mp->flags &= ~(FLODMAP_FG_FFWD_IN
			       | FLODMAP_FG_NEED_RWD);
		memcpy(ifp->pos_sent, ifp->pos, sizeof(ifp->pos_sent));
		db_ptr2flod_pos(req, DCC_FLOD_POS_FFWD_IN);
		dcc_trace_msg("ask %s to FFWD flood to us",
			      ifp_rem_str(ifp));
		if (!iflod_write(ifp, req, sizeof(req), "ffwd request", 0))
			return -1;
		return 1;
	}
	if (mp->flags & FLODMAP_FG_NEED_RWD) {
		mp->flags &= ~FLODMAP_FG_NEED_RWD;
		memcpy(ifp->pos_sent, ifp->pos, sizeof(ifp->pos_sent));
		db_ptr2flod_pos(req, DCC_FLOD_POS_REWIND);
		dcc_trace_msg("ask %s to rewind flood to us",
			      ifp_rem_str(ifp));
		if (!iflod_write(ifp, req, sizeof(req), "rewind request", 0))
			return -1;
		return 1;
	}

	if ((force && flod_pos2db_ptr(ifp->pos) >= DCC_FLOD_POS_MIN)
	    || memcmp(ifp->pos_sent, ifp->pos, sizeof(ifp->pos_sent))) {
		memcpy(ifp->pos_sent, ifp->pos, sizeof(ifp->pos_sent));
		if (!iflod_write(ifp, ifp->pos_sent, sizeof(ifp->pos_sent),
				 "confirmed pos", 0))
			return -1;

		/* reset the no-connection-from-peer complaint delay */
		mp->itimers.msg_secs = FLOD_IN_COMPLAIN1;
		mp->itimers.msg = db_time.tv_sec + FLOD_IN_COMPLAIN1;

		/* things are going well, so forget old input complaints */
		if (!(mp->flags & FLODMAP_FG_IN_SRVR))
			ferr_clear_all(ofp, 1);

		/* limit the backoff for outgoing connection attempts
		 * while the incoming connection is working */
		DB_ADJ_TIMER(&mp->otimers.retry, &mp->otimers.retry_secs,
			     FLOD_SUBMAX_RETRY_SECS);

		return 1;
	}

	/* Say just anything if we are doing a keepalive probe before
	 * any checksums have been sent by the peer and so before we
	 * have a position to confirm. */
	if (force) {
		DCC_FLOD_RESP buf;

		db_ptr2flod_pos(buf.note.op, DCC_FLOD_POS_NOTE);
		strcpy(buf.note.str, DCC_FLOD_AYT);
		buf.note.len = sizeof(DCC_FLOD_AYT) + FLOD_NOTE_OVHD;
		TMSG1_FLOD1(ofp, "send note to %s: \""DCC_FLOD_AYT"\"",
			    ifp_rem_str(ifp));
		if (!iflod_write(ifp, &buf.note, buf.note.len, buf.note.str, 0))
			return -1;
		return 1;
	}

	return 0;
}



void
iflod_listen_close(SRVR_SOC *sp)
{
	if (sp->listen < 0)
		return;

	TMSG1(FLOD1, "stop flood listening on %s",
	      dcc_su2str_err(&sp->listen_su));
	if (0 > close(sp->listen))
		TMSG2(FLOD1, "close(flood listen on %s): %s",
		      dcc_su2str_err(&sp->listen_su), ERROR_STR());
	sp->listen = -1;
}



/* send stop requests to DCC servers flooding to us
 *	can close the incoming flood and so clear things */
void
iflods_stop(const char *reason,
	    u_char force)		/* 1=now */
{
	SRVR_SOC *sp;
	IFLOD_INFO *ifp;
	DCC_FLOD_POS end_req;

	/* stop listening for new connections */
	for (sp = srvr_socs; sp; sp = sp->fwd) {
		iflod_listen_close(sp);
	}

	for (ifp = iflods.infos; ifp <= LAST(iflods.infos); ++ifp) {
		if (ifp->soc < 0)
			continue;

		/* start shutting down each real, still alive connection */
		if (!(ifp->flags & IFLOD_FG_END_REQ)
		    && (ifp->flags & IFLOD_FG_VERS_CK)) {
			if (!reason || !*reason)
				ferr(ifp->ofp, 1, FERR_STOP, 1,
				     "flood from %s stopping",
				     ifp_rem_str(ifp));
			else
				ferr(ifp->ofp, 1, FERR_STOP, 1,
				     "flood from %s stopping: '%s'",
				     ifp_rem_str(ifp), reason);

			/* send any delay position and then a stop request */
			if (0 <= iflod_send_pos(ifp, 0)) {
				db_ptr2flod_pos(end_req, DCC_FLOD_POS_END_REQ);
				iflod_write(ifp, end_req, sizeof(end_req),
					    "flood stop req", 0);
				ifp->flags |= IFLOD_FG_END_REQ;
			}

			/* done if the socket died */
			if (ifp->soc < 0)
				continue;
		}

		/* break the connection if forced or never authenticated */
		if (force || !(ifp->flags & IFLOD_FG_VERS_CK)) {
			if (!reason || !*reason)
				iflod_close(ifp, 1, 0, 1,
					    "flooding off at %s",
					    our_hostname);
			else
				iflod_close(ifp, 1, 0, 1,
					    "flooding off at %s; %s",
					    our_hostname, reason);
			continue;
		}

		/* break the conneciton if the peer is too slow */
		if ((ifp->flags & IFLOD_FG_END_REQ)
		    && IFP_DEAD(ifp, stopint
				? SHUTDOWN_DELAY : KEEPALIVE_IN_STOP)) {
			if (!reason || !*reason)
				iflod_close(ifp, 1, 0, 1,
					    DCC_FLOD_OK_STR" force close from"
					    " %s",
					    ifp_rem_str(ifp));
			else
				iflod_close(ifp, 1, 0, 1,
					    DCC_FLOD_OK_STR" force close from"
					    " %s; %s",
					    ifp_rem_str(ifp), reason);
			continue;
		}
	}
}



/* start receiving checksums from another DCC server */
void
iflod_start(SRVR_SOC *sp)
{
	IFLOD_INFO *ifp;
	socklen_t l;
	struct in6_addr peer_addr;
	int count;
	RL *ip_rl, *block_rl;

	/* accept all waiting connections to avoid starving any	*/
	for (count = 0; count <= DCCD_MAX_FLOODS; ++count) {
		/* find a free input flooding slot */
		for (ifp = iflods.infos; ifp->soc >= 0; ++ifp) {
			if (ifp > LAST(iflods.infos)) {
				if (!(complained_many_iflods++))
					dcc_error_msg("too many floods");
				goto again;
			}
		}

		l = sizeof(ifp->rem);
		ifp->soc = accept(sp->listen, &ifp->rem.sa, &l);
		if (ifp->soc < 0) {
			if (!DCC_BLOCK_ERROR() || count == 0)
				dcc_error_msg("accept(flood): %s", ERROR_STR());
			return;
		}

		/* use the IP address as the host name until we know which
		 * peer it is */
		dcc_su2str2(ifp->rem_hostname, sizeof(ifp->rem_hostname),
			    &ifp->rem);
		if (!set_flod_socket(0, 1, ifp->soc,
				     ifp->rem_hostname, &ifp->rem)) {
			close(ifp->soc);
			ifp->soc = -1;
			continue;
		}

		/* reset timer that delays responses to clients while flooding
		 * is stopped */
		if (++iflods.open == 1)
			iflods_ok_timer = db_time.tv_sec + IFLODS_OK_SECS;
		ifp->flags |= IFLOD_FG_CONNECTED;
		ifp->iflod_alive = db_time.tv_sec;

		/* quietly forget this peer if it is blacklisted */
		ip_rl = rl_get(&block_rl,
			       DCC_PKT_VERS_INVALID, DCC_ID_SRVR_ROGUE,
			       dcc_su2ipv6(&peer_addr, 0, &ifp->rem), 0);
		rl_inc2(ip_rl, &rl_sub_rate, block_rl);
		if ((ip_rl->d.fgs & RL_FG_BLACK_ADDR)
		    && !(ip_rl->d.fgs & RL_FG_FLOD_OK)) {
			u_char complain = 0;

			if (!(ip_rl->d.fgs & RL_FG_DROPPED)) {
				ip_rl->d.fgs |= RL_FG_DROPPED;
				complain = 1;
			}
			if (block_rl && !(block_rl->d.fgs & RL_FG_DROPPED)) {
				block_rl->d.fgs |= RL_FG_DROPPED;
				complain = 1;
			}
			iflod_close(ifp, 1,
				    (complain
				     || (ip_rl->d.fgs & RL_FG_TRACE) != 0
				     || TMSG_BIT(FLOD1)),
				    1, "blacklisted");
			continue;
		}

		TMSG1(FLOD1, "start flood from %s", ifp_rem_str(ifp));
again:;
	}
}



/* Start an incoming SOCKS flood by connecting to the other system.
 *	We will eventually turn the connection around and pretend that
 *	the other system initiated the TCP connection.
 *	This can close the flood and so clear things */
static int				/* -1=failure, 0=not yet, 1=done */
iflod_socks_connect(IFLOD_INFO *ifp)
{
	OFLOD_INFO *ofp;
	DCC_SRVR_ID id;
	DCC_FLOD_VERS_HDR buf;
	DCC_FNM_LNO_BUF fnm_buf;
	const char *emsg;
	int i;

	ofp = ifp->ofp;

	memset(&buf, 0, sizeof(buf));
	strcpy(buf.body.str, version_str(ofp));
	id = htons(my_srvr_id);
	memcpy(buf.body.sender_srvr_id, &id, sizeof(buf.body.sender_srvr_id));
	buf.body.turn = 1;
	emsg = flod_sign(ofp, 1, &buf, sizeof(buf));
	if (emsg) {
		iflod_socks_backoff(ofp);
		iflod_close(ifp, 1, 1, 1, "%s %d%s",
			    emsg, ofp->out_passwd_id,
			    dcc_fnm_lno(&fnm_buf, flod_path.c, ofp->lno));
		return -1;
	}

	if (ofp->o_opts.flags & FLOD_OPT_SOCKS) {
		i = Rconnect(ifp->soc, &ifp->rem.sa, DCC_SU_LEN(&ifp->rem));
	} else {
		/* must be NAT or assumed NAT */
		i = connect(ifp->soc, &ifp->rem.sa, DCC_SU_LEN(&ifp->rem));
	}
	if (0 > i && errno != EISCONN) {
		if (CONN_WAIT_ERRORS()) {
			ferr(ofp, 1, FERR_CONNECT, 1,
			     "waiting to connect %s flood from %s",
			     socks_type_str(ofp->mp), ifp_rem_str(ifp));
			return 0;
		}

		/* failure */
		ferr(ofp, 1, FERR_CONNECT, 1,
			"connect(%s %s): %s",
			socks_type_str(ofp->mp), ifp_rem_str(ifp), CONN_EMSG());

		close(ifp->soc);

		if (++ofp->i_dns.cur < ofp->i_dns.num) {
			/* Immediately try the next address */
			iflod_clear(ifp, 0);
		} else {
			/* Start over later if last IP address failed */
			iflod_socks_backoff(ofp);
			iflod_clear(ifp, 1);
		}
		return -1;
	}

	ifp->flags |= (IFLOD_FG_CONNECTED | IFLOD_FG_CLIENT);
	ofp->i_dns.num = 0;		/* start from 1st IP address next time */

	ferr(ofp, 1, FERR_CONNECT, 1,
	     "starting %s flood from %s",
	     socks_type_str(ofp->mp), ifp_rem_str(ifp));

	/* After the SOCKS incoming flood socket is connected,
	 *	send our authentication to convince the peer to send its
	 *	authentication and then its checksums. */
	if (!iflod_write(ifp, &buf, sizeof(buf),
			 "flood SOCKS or NAT authentication", 0))
		return -1;
	return 1;
}



/* Request the start of an input flood via SOCKS if it is not already flowing,
 *	by connecting to the remote system.
 *	This can close the flood and so clear things */
void
iflod_socks_start(OFLOD_INFO *ofp)
{
	DCC_FNM_LNO_BUF fnm_buf;
	IFLOD_INFO *ifp, *ifp1;

	/* try all host names */
	for (;;) {
		/* do nothing if it is already running or is not using SOCKS */
		if (ofp->ifp
		    || 0 == (ofp->mp->flags & FLODMAP_FG_ACT)
		    || IFLOD_OPT_OFF_ROGUE(ofp))
			return;

		/* wait if it is not time to try again */
		if (!DB_IS_TIME(ofp->mp->itimers.retry,
				ofp->mp->itimers.retry_secs))
			return;

		/* wait if output has not been running for a while to
		 * give peer a chance to connect to us before assuming NAT */
		if (ofp->mp->flags & FLODMAP_FG_NAT_AUTO) {
			if (!(ofp->flags & OFLOD_FG_CONNECTED)
			    || (ofp->flags & OFLOD_FG_NEW))
				return;
			ofp->mp->itimers.retry = (ofp->mp->cnts.out_conn_changed
						  + FLOD_AUTO_NAT_DELAY);
			ofp->mp->itimers.retry_secs = FLOD_AUTO_NAT_DELAY;
			if (!DB_IS_TIME(ofp->mp->itimers.retry,
					ofp->mp->itimers.retry_secs))
				return;
		}

		/* find free slot or an existing slot for the incoming flood */
		ifp = 0;
		for (ifp1 = iflods.infos; ifp1 <= LAST(iflods.infos); ++ifp1) {
			/* there is nothing to do if it already exists */
			if (ifp1->ofp == ofp)
				return;
			if (ifp1->soc < 0 && !ifp)
				ifp = ifp1; /* note first free slot */
		}
		if (!ifp) {
			ferr(ofp, 1, FERR_START,
			     ++complained_many_iflods == 1 ? 0 : 2,
			     "too many incoming floods to start"
			     " %s flood from %s",
			     socks_type_str(ofp->mp), ofp->rem_hostname);
			iflod_socks_backoff(ofp);
			iflod_delay(ofp);
			return;
		}

		if (ofp->i_dns.cur >= ofp->i_dns.num) {
			if (!flod_names_resolve_start(ofp))
				return;	/* wait for name resolution */

			/* snapshot new names */
			ofp->i_dns = ofp->mp->dns;

			if (ofp->i_dns.num == 0) {
				ferr(ofp, 1, FERR_DNS, 0,
				     "flood peer name %s: '%s'%s",
				     ofp->rem_hostname,
				     H_ERROR_STR1(ofp->i_dns.rem_h_errno),
				     dcc_fnm_lno(&fnm_buf, flod_path.c,
						 ofp->lno));
				iflod_socks_backoff(ofp);
				iflod_delay(ofp);
				return;
			}

			/* since we have addresses,
			 * forget old complaints about bad host names */
			ferr_clear(ofp, 1, FERR_DNS);
		}

		ifp->ofp = ofp;
		STRLCPY(ifp->rem_hostname, ofp->rem_hostname,
			sizeof(ifp->rem_hostname));
		ifp->rem = ofp->i_dns.su[ofp->i_dns.cur];
		DCC_SU_PORT(&ifp->rem) = ofp->rem_port;
		ifp->soc = socket(ifp->rem.sa.sa_family, SOCK_STREAM, 0);
		/* stop if we cannot open the socket */
		if (ifp->soc < 0) {
			ferr(ofp, 1, FERR_START, 0,
			     "socket(%s flood %s): %s",
			     socks_type_str(ofp->mp), ifp_rem_str(ifp),
			     ERROR_STR());
			iflod_socks_backoff(ofp);
			iflod_clear(ifp, 1);
			return;
		}

		if (!set_flod_socket(ofp, 1, ifp->soc,
				     ifp->rem_hostname, &ifp->rem)) {
			close(ifp->soc);
			ifp->soc = -1;
			iflod_socks_backoff(ofp);
			iflod_clear(ifp, 1);
			return;
		}

		bind_flod_socket(ofp, ifp->soc, &ifp->rem, &ofp->i_dns);

		/* reset timer that delays responses to clients while
		 * flooding is not working */
		if (++iflods.open == 1)
			iflods_ok_timer = db_time.tv_sec + IFLODS_OK_SECS;

		if (0 <= iflod_socks_connect(ifp))
			return;
	}
}



/* See if the new duplicate report contains exactly the same checksums as
 * the record that is already in the database.
 * Reputation checksums are trimmed from reports flooded to non-reputation
 * peers.  Otherwise all reports are the same. */
typedef enum {
    CK_DUP_BROKEN,			/* broken database & flood closed */
    CK_DUP_NOT,				/* not a duplicate report */
    CK_DUP_NEXT_CK,			/* not duplicate in this chain */
    CK_DUP_DISCARD,			/* discard duplicate report */
    CK_DUP_REPLACE			/* replace old record with new report */
} CK_DUP;
static CK_DUP
ck_dup_rcd(IFLOD_INFO *ifp, DB_RCD *new, DB_ST *old_st, DB_RCD *old)
{
	DB_RCD_CK *new_ck, *old_ck;
	int new_num_cks, old_num_cks;
	int new_unique, old_unique;

	/* See if one record is a subset of the other
	 *
	 * Because of varying db_parms.nokeep_cks or -K bits,
	 * the records might not have the same checksums.
	 *
	 * We do not need to compare the checksums, because the fact that
	 * the records have the same server-ID and timestamp implies that
	 * any checksums of the same type are the same. */
	old_unique = 0;
	old_num_cks = DB_NUM_CKS(old);
	old_ck = old->cks;
	new_unique = 0;
	new_num_cks = DB_NUM_CKS(new);
	new_ck = new->cks;
	while (old_num_cks != 0 && new_num_cks != 0) {
		if (DB_CK_TYPE(old_ck) == DCC_CK_FLOD_PATH) {
			/* skip paths in the old record */
			++old_ck;
			--old_num_cks;
		} else if (DB_CK_TYPE(new_ck) == DCC_CK_FLOD_PATH) {
			/* skip paths in the new record */
			++new_ck;
			--new_num_cks;
		} else if (DB_CK_TYPE(old_ck) == DB_CK_TYPE(new_ck)) {
			/* skip identical checksums,
			 * but do not even count duplicate server-ID
			 * declarations */
			if (DB_CK_TYPE(new_ck) == DCC_CK_SRVR_ID)
				return CK_DUP_DISCARD;
			++old_ck;
			--old_num_cks;
			++new_ck;
			--new_num_cks;
		} else if (DB_CK_TYPE(old_ck) < DB_CK_TYPE(new_ck)) {
			/* skip unique checksum in the old record,
			 * using the ordering of checksums in records */
			++old_unique;
			++old_ck;
			--old_num_cks;
		} else {
			/* skip unique checksum in the new record */
			++new_unique;
			++new_ck;
			--new_num_cks;
		}
	}

	/* forget the new record if it has nothing unique */
	if (new_unique+new_num_cks == 0) {
		if (TMSG_FB2(ifp->ofp) && CK_FLOD_CNTERR(&ifp->ofp->lc.dup))
			flod_cnterr(&ifp->ofp->lc.dup, "%sduplicate %s",
				    old_unique+old_num_cks == 0
				    ? "" : "subset ",
				    rpt_id("report", new, ifp));

		return CK_DUP_DISCARD;
	}

	/* Delete the original report if it has nothing unique
	 *	This results in doubling the contribution to the total for
	 *	each checksum from this report in our database until the
	 *	next time dbclean is run.  At worst this could push a
	 *	DCC client over its bulk threshold */
	if (old_unique+old_num_cks == 0) {
		if (TMSG_FB2(ifp->ofp) && CK_FLOD_CNTERR(&ifp->ofp->lc.dup))
			flod_cnterr(&ifp->ofp->lc.dup, "superset duplicate %s",
				    rpt_id("report", new, ifp));
		DB_TGTS_RCD_SET(old, 0);
		DIRTY_RCD(old_st, 1);
		return CK_DUP_REPLACE;
	}

	/* Keep the new record and delete the overlapping checksums in
	 * the old record.
	 *	This doubles counts until the next time dbclean is run. */
	if (TMSG_FB2(ifp->ofp) && CK_FLOD_CNTERR(&ifp->ofp->lc.dup))
		flod_cnterr(&ifp->ofp->lc.dup, "partial duplicate %s",
			    rpt_id("report", new, ifp));

	old_num_cks = DB_NUM_CKS(old);
	old_ck = old->cks;
	new_num_cks = DB_NUM_CKS(new);
	new_ck = new->cks;
	while (old_num_cks != 0 && new_num_cks != 0) {
		if (DB_CK_TYPE(old_ck) == DCC_CK_FLOD_PATH) {
			/* skip paths in the old record */
			++old_ck;
			--old_num_cks;
		} else if (DB_CK_TYPE(new_ck) == DCC_CK_FLOD_PATH) {
			/* skip paths in the new record */
			++new_ck;
			--new_num_cks;
		} else if (DB_CK_TYPE(old_ck) == DB_CK_TYPE(new_ck)) {
			/* zap an identical checksum in the old record,
			 * unless it is already dead, in which case
			 * the new checksum is also junk */
			if (DB_CK_JUNK(old_ck)) {
				new_ck->type_fgs |= DB_CK_FG_JUNK;
			} else {
				old_ck->type_fgs |= DB_CK_FG_JUNK;
				DIRTY_RCD(old_st, 1);
			}
			++old_ck;
			--old_num_cks;
			++new_ck;
			--new_num_cks;
		} else if (DB_CK_TYPE(old_ck) < DB_CK_TYPE(new_ck)) {
			/* skip unique checksum in the old record,
			 * using the ordering of checksums in records */
			++old_ck;
			--old_num_cks;
		} else {
			/* skip unique checksum in the new record */
			++new_ck;
			--new_num_cks;
		}
	}

	return CK_DUP_REPLACE;
}



/* See if two reports came via the same path */
static u_char
eq_paths(const DB_RCD *new, const DB_RCD *old)
{
	const DB_RCD_CK *new_ck, *old_ck;
	int new_num_cks, old_num_cks;

	new_num_cks = DB_NUM_CKS(new);
	new_ck = new->cks;
	while (new_num_cks != 0 && DB_CK_TYPE(new_ck) != DCC_CK_FLOD_PATH) {
		++new_ck;
		--new_num_cks;
	}

	old_num_cks = DB_NUM_CKS(old);
	old_ck = old->cks;
	while (old_num_cks != 0 && DB_CK_TYPE(old_ck) != DCC_CK_FLOD_PATH) {
		++old_ck;
		--old_num_cks;
	}

	/* Assume the path is in a contiguous set of checksums. */
	while (old_num_cks != 0 && new_num_cks != 0) {
		if (DB_CK_TYPE(new_ck) != DCC_CK_FLOD_PATH) {
			if (DB_CK_TYPE(old_ck) != DCC_CK_FLOD_PATH)
				return 1;
			return 0;
		}
		if (DB_CK_TYPE(old_ck) != DCC_CK_FLOD_PATH)
			return 0;
		if (memcmp(&old_ck->sum, &new_ck->sum, sizeof(old_ck->sum)))
			return 0;
		++new_ck;
		--new_num_cks;
		++old_ck;
		--old_num_cks;
	}
	return 0;
}



/* See if the new record is a duplicate of any existing records containing
 * the specified checksum */
static CK_DUP
ck_dup_ck_chain(IFLOD_INFO *ifp,
		DB_ST *old_st,
		DB_RCD *new,
		DCC_TGTS new_tgts_raw,
		DCC_CK_TYPES type,
		const DB_RCD_CK *found_ck)  /* checksum in initial record */
{
#define MAX_CHAIN 100
	DB_PTR limit, prev;
	time_t limit_secs;
	const char *limit_str;
	DB_RCD *old;
	DCC_TGTS prev_total;
	DCC_TGTS new_tgts;
	int cnt, deleted;
	const char *reason;
	CK_DUP result;
	int i;

	/* Compute a time before which a copy of the record could not be
	 * in the database.
	 * A duplicate of the record could not have been received here
	 * before TS+SKEW, where TS=timestamp in the record and
	 * SKEW=(true time - originating server's clock).
	 *
	 * Assume all of the servers in the path to the originating server
	 * have reasonable clocks, but the originating server's clock
	 * might be wrong by MAX_FLOD_CLOCK_SKEW seconds.
	 * So a duplicate of the record could not have been received here
	 * before TS-MAX_FLOD_CLOCK_SKEW.
	 */
	limit_secs = ts2secs(&new->ts) - MAX_FLOD_CLOCK_SKEW;
	if (limit_secs >= TIME_T(db_parms.cleaned)
	    && db_parms.cleaned != 0) {
		limit = db_parms.old_db_csize;
		limit_str = "expire limit ";
	} else {
		limit = DB_PTR_BASE;
		limit_str = "base ";
	}

	new_tgts = DB_COOK_TGTS(new_tgts_raw);

	/* Look at all reports for this checksum */
	reason = "";
	for (cnt = 1, deleted = 0; ; ++cnt) {
		old = old_st->d.r;
		if (DB_TGTS_RCD_RAW(old) == DCC_TGTS_DEL) {
			/* trigger a quick cleaning if we are hitting giant
			 * chains of old, compressed records */
			if (++deleted >= MAX_DUP_CHAIN
			    && iflod_dup_chain < cnt)
				iflod_dup_chain = cnt;

			/* Recent deletions of one of the target checksums
			 * make the flooded report stale.
			 * The timestamps in the new and existing deleted
			 * reports could be wrong. Regardless of those errors,
			 * if the new record had been in the database when
			 * dbclean compressed it or when a delete request
			 * arrived, we would have deleted it. */
			if (new_tgts_raw != DCC_TGTS_DEL
			    && !ts_newer_ts(&new->ts, &old->ts)) {
				reason = "deleted ";
				result = CK_DUP_DISCARD;
				break;
			}
		}

		if (DB_RCD_ID(old) == DB_RCD_ID(new)) {
			/* This old report came from the same server.
			 *
			 * If it has the same timestamp so is the same report,
			 * then save the copy that has the most checksums. */
			int t = tscmp(&new->ts, &old->ts);
			if (t == 0) {
				result = ck_dup_rcd(ifp, new, old_st, old);
				break;
			}
			/* If the reports came by the same path, then we know
			 * whether the new report is a duplicate by comparing
			 * timestamps, because both the new report and a
			 * possible duplicate would have been filtered by the
			 * same db_parms.nokeep_cks or -K bits.
			 * There is no re-ordering of reports within a path.
			 * If the new report is older than the existing report,
			 * then it is a duplicate or uninteresting.
			 * If the new report is newer, then it is not a
			 * duplicate. */
			if (eq_paths(new, old)) {
				reason = "newer report ";
				result = t < 0 ? CK_DUP_DISCARD : CK_DUP_NOT;
				break;
			}
		}

		/* If count in the new report is as large as the existing
		 * total, then the new report cannot be a duplicate
		 * for this checksum. */
		prev_total = DB_TGTS_CK(found_ck);
		if (prev_total < new_tgts
		    || (prev_total == new_tgts
			&& new_tgts != DCC_TGTS_TOO_MANY)) {
			reason = "big ";
			result = CK_DUP_NEXT_CK;
			break;
		}

		/* Look for a position in the database that precedes
		 * any existing (and so duplicate) copy of the record.
		 * Because hitting the hash table is expensive,
		 * and most duplicates are quickly found,
		 * do this only for chains that might be long. */
		if (cnt == 5) {
			DB_ST *rcd_st = GET_DB_ST();

			i = find_date_rcd(limit_secs, rcd_st);
			if (i < 0) {
				iflod_close(ifp, 1, 1, 1, "%s",
					    dcc_emsg.c);
				DB_ERROR_MSG(dcc_emsg.c);
				free_db_st(rcd_st);
				return CK_DUP_BROKEN;
			}
			if (i > 0 && limit < rcd_st->s.rptr) {
				limit = rcd_st->s.rptr;
				limit_str = "date limit ";
			}
			free_db_st(rcd_st);
		}
		if (old_st->s.rptr < limit) {
			reason = limit_str;
			result = CK_DUP_NEXT_CK;
			break;
		}

		/* Do only a cursory duplicate check on known spam.
		 * Rely on the database checks to mark it as junk
		 * if it is a duplicate. */
		if (cnt >= MAX_CHAIN && prev_total == DCC_TGTS_TOO_MANY) {
			reason = "spam ";
			result = CK_DUP_NEXT_CK;
			break;
		}

		/* try the preceding record */
		prev = DB_PTR_EX(found_ck->prev);
		if (prev == DB_PTR_NULL) {
			/* we know it is not a duplicate when we finally
			 * reach the end of the chain */
			reason = "end ";
			result = CK_DUP_NEXT_CK;
			break;
		}
		if (prev >= old_st->s.rptr) {
			dcc_pemsg(EX_DATAERR, &dcc_emsg,
				  "bad %s link of "L_HxPAT" at "L_HxPAT,
				  DB_TYPE2STR(type), prev, old_st->s.rptr);
			iflod_close(ifp, 1, 1, 1, "%s", dcc_emsg.c);
			DB_ERROR_MSG(dcc_emsg.c);
			return CK_DUP_BROKEN;
		}

		found_ck = db_map_rcd_ck(&dcc_emsg, old_st, prev, type);
		if (!found_ck) {
			iflod_close(ifp, 1, 1, 1, "%s", dcc_emsg.c);
			DB_ERROR_MSG(dcc_emsg.c);
			return CK_DUP_BROKEN;
		}
	}

	if (((cnt >= MAX_CHAIN && TMSG_BIT(DB)) || TMSG_FB2(ifp->ofp))
	    && CK_FLOD_CNTERR(&ifp->ofp->lc.dup)) {
		const char *rstr = 0;
		switch (result) {
		case CK_DUP_BROKEN:	rstr = "broken DB"; break;
		case CK_DUP_NOT:	rstr = "not duplicate"; break;
		case CK_DUP_NEXT_CK:	rstr = "next-ck"; break;
		case CK_DUP_DISCARD:	rstr = "discard"; break;
		case CK_DUP_REPLACE:	rstr = "replace"; break;
		}
		flod_cnterr(&ifp->ofp->lc.dup,
			    "stop looking with \"%s\" for %s in %s chain"
			    " after %d records at %s"L_HPAT,
			    rstr, rpt_id("report", new, ifp),
			    DB_TYPE2STR(type),
			    cnt, reason, old_st->s.rptr);
	}
	return result;
}



/* complain about a received flooded report,
 *	and possibly close and so clear things */
static u_char DCC_PF(6,7)		/* 0=flood closed */
iflod_rpt_complain(IFLOD_INFO *ifp,
		   const DB_RCD *new,	/* complain about this report */
		   u_char serious,	/* 0=send mere note, 1=send complaint */
		   FLOD_LIMCNT *lc,	/* limit complaints with this */
		   const char *str,	/* type of report */
		   const char *pat,...)	/* the complaint */
{
	DCC_FLOD_RESP buf;
	const char *sc;
	va_list args;
	int i, len;

	if (!lc && ifp->ofp)
		lc = &ifp->ofp->lc.iflod_bad;
	if (!lc || db_debug >= 2) {
		sc = "";
	} else {
		i = ++lc->cur - (lc->lim + FLOD_LIM_COMPLAINTS);
		if (i > 0)
			return 1;
		sc = i < 0 ? "" : "; stop complaints";
	}

	va_start(args, pat);
	len = vsnprintf(buf.note.str, sizeof(buf.note.str), pat, args);
	if (len >= ISZ(buf.note.str))
		len = sizeof(buf.note.str)-1;
	va_end(args);

	if (serious) {
		dcc_error_msg("%s %s%s",
			      buf.note.str, rpt_id(str, new, ifp), sc);
		db_ptr2flod_pos(buf.note.op, DCC_FLOD_POS_COMPLAINT);
	} else {
		TMSG3_FLOD2(ifp->ofp, "%s %s%s",
			    buf.note.str, rpt_id(str, new, ifp), sc);
		db_ptr2flod_pos(buf.note.op, DCC_FLOD_POS_NOTE);
	}

	len += snprintf(&buf.note.str[len], sizeof(buf.note.str)-len, " %s%s",
			rpt_id(str, new, 0), sc);
	if (len >= ISZ(buf.note.str))
		len = ISZ(buf.note.str)-1;

	buf.note.len = len+1 + FLOD_NOTE_OVHD;
	return iflod_write(ifp, &buf, buf.note.len, buf.note.str, 0);
}



/* consider a server-ID in an incoming report */
static u_char				/* 0=discard it */
iflod_rpt_id(const DB_RCD_CK *ck,
	     const IFLOD_INFO *ifp,
	     const DB_RCD *new,
	     DCC_SRVR_ID srvr_id)
{
	DCC_SRVR_ID tgt_id, type_id;
	char buf1[24];
	const OFLOD_INFO *ofp1;
	ID_TBL *tp;

	/* notice claims by other servers to our ID */
	if (srvr_id == my_srvr_id) {
		if (memcmp(&host_id_sum, &ck->sum, sizeof(host_id_sum)))
			dcc_error_msg("host %s claimed our server-ID %d at %s",
				      ck2str_err(DCC_CK_SRVR_ID, &ck->sum, 0),
				      my_srvr_id,
				      ts2str_err(&new->ts));
		return 0;
	}

	/* accept it if it is not a server-ID type announcement */
	if (!DCC_ID_SRVR_TYPE(srvr_id))
		return 1;

	/* discard type announcements for mapped server-IDs */
	tgt_id = DCC_ID_SRVR_TYPE_ID(&ck->sum);
	switch (id_map(tgt_id, &ifp->ofp->i_opts.maps)) {
	case ID_MAP_NO:
	case ID_MAP_REJ:
		break;
	case ID_MAP_SELF:
		return 0;
	}

	type_id = srvr_id;
	switch (type_id) {
	case DCC_ID_SRVR_SIMPLE:
	case DCC_ID_SRVR_ROGUE:
	case DCC_ID_SRVR_IGNORE:
		break;
	default:
		return 0;
	}

	if (ck->sum.b[0] != DCC_CK_SRVR_ID) {
		return 0;
	}

	tp = find_srvr_type(tgt_id);
	/* Restart flooding if the announced type of a peer changes. */
	for (ofp1 = oflods.infos; ofp1 <= LAST(oflods.infos); ++ofp1) {
		/* Wait a bit for more announcements before restarting flooding.
		 * When we restart flooding, we will check the database. */
		if (ofp1->rem_id == tgt_id) {
			if ((type_id == DCC_ID_SRVR_ROGUE)
			    != ((ofp1->o_opts.flags & FLOD_OPT_ROGUE) != 0)) {
				if (TMSG_FB1(ifp->ofp) || TMSG_FB1(ofp1))
					dcc_trace_msg("server-ID %d for %s"
						      " changed to \"%s\""
						      " in %s",
						      tgt_id,
						      ofp1->rem_hostname,
						      id2str(buf1, sizeof(buf1),
							  type_id),
						      rpt_id("report",new,ifp));
				if (flod_mtime > 1)
					flod_mtime = 1;
			}
			break;
		}
	}

	/* accept changes to our records */
	tp->srvr_type = type_id;

	return 1;
}



/* consider an incoming flooded report */
static int				/* -1=failed, 0=not yet, else length */
iflod_rpt(IFLOD_INFO *ifp, OFLOD_INFO *ofp,
	  const DCC_FLOD_STREAM *stream, int max_len, DB_ST *rcd_st)
{
	DB_PTR pos;
	DCC_TGTS new_tgts, found_tgts;
	DB_RCD new;
	DCC_SRVR_ID old_srvr;
	const DCC_CK *ck_lim, *ck;
	const DB_RCD_CK *srvr_id_ck;
	DB_RCD_CK  *found_ck, *new_ck;
	DCC_CK_TYPES type, prev_type;
	DCC_FLOD_PATH_ID *new_path_id;
	int num_path_blocks;
	char tgts_buf[DCC_XHDR_MAX_TGTS_LEN];
	int ok2;
	int rpt_len;
	u_char timely;
	ID_MAP_RESULT srvr_mapped;
	ID_TBL *tp;
	CK_DUP r;
	u_char *not_dup_class, not_dup_global, not_dup_nokeep;
	u_char not_dup_rep;

	pos = flod_pos2db_ptr(stream->r.pos);
	if (pos < DCC_FLOD_POS_MIN) {
		iflod_close(ifp, 1, 1, 1,
			    "bogus position "L_HxPAT" in flooded report #%d",
			    pos, ofp->cnts.total);
		return -1;
	}

	if (max_len < DCC_FLOD_RPT_LEN(0))
		return 0;

	if (stream->r.num_cks == 0 || stream->r.num_cks > DCC_QUERY_MAX) {
		iflod_close(ifp, 1, 1, 1,
			    "impossible %d checksums in report #%d",
			    stream->r.num_cks, ofp->cnts.total);
		return -1;
	}
	rpt_len = DCC_FLOD_RPT_LEN(stream->r.num_cks);
	if (rpt_len > max_len)
		return 0;		/* wait for more */

	if (db_failed_line)
		return rpt_len;		/* can do nothing if database broken */

	/* save the position to return to the sender */
	memcpy(ifp->pos, stream->r.pos, sizeof(ifp->pos));

	new.ts = stream->r.ts;
	memcpy(&new.srvr_id, stream->r.srvr_id, sizeof(new.srvr_id));
	/* DCC_SRVR_ID_AUTH is obsolete but can be seen from ancient peers */
	old_srvr = ntohs(new.srvr_id) & DCC_SRVR_ID_MASK;

	/* ignore keepalives
	 *	They are sent only to ensure that there is always a position
	 *	to acknowledge even with a server-ID mapping that stops all
	 *	reports */
	if (old_srvr == DCC_ID_SRVR_DATE)
		return rpt_len;

	new.srvr_id = old_srvr;
	new.fgs_num_cks = 0;

	memcpy(&new_tgts, stream->r.tgts, sizeof(new_tgts));
	new_tgts = ntohl(new_tgts);
	if (new_tgts == DCC_TGTS_DEL) {
		if (!(ofp->i_opts.flags & FLOD_OPT_DEL_OK)) {
			if (!iflod_rpt_complain(ifp, &new, 1,
						&ofp->lc.not_deleted,
						"delete request", "refuse"))
				return -1;
			return rpt_len;
		}
	} else if (new_tgts == 0
		   || new_tgts > DCC_TGTS_FLOD_RPT_MAX) {
		iflod_close(ifp, 1, 1, 1, "bogus target count %s in %s",
			    tgts2str(tgts_buf, sizeof(tgts_buf),
				     new_tgts, grey_on),
			    rpt_id("report", &new, 0));
		return -1;
	}

	/* notice reports from the distant future */
	if (ts_newer_ts(&new.ts, &future)) {
		if (!iflod_rpt_complain(ifp, &new, 1, &ofp->lc.stale,
					"report", "future"))
			return -1;
		return rpt_len;
	}

	DB_TGTS_RCD_SET(&new, new_tgts);
	new.fgs_num_cks = 0;
	srvr_id_ck = 0;
	timely = 0;
	ck_lim = &stream->r.cks[stream->r.num_cks];
	new_ck = new.cks;
	num_path_blocks = 0;

	tp = 0;
	srvr_mapped = id_map(old_srvr, &ofp->i_opts.maps);
	switch (srvr_mapped) {
	case ID_MAP_NO:
		tp = find_srvr_type(old_srvr);
		break;
	case ID_MAP_REJ:
		if (!iflod_rpt_complain(ifp, &new, 0, 0,
					"rejected server-ID in", "refuse"))
			return -1;
		return rpt_len;
	case ID_MAP_SELF:
		new.srvr_id = my_srvr_id;
		/* create path pointing to ourself if we translate the ID */
		memset(new_ck, 0, sizeof(*new_ck));
		new_ck->type_fgs = DCC_CK_FLOD_PATH;
		new_path_id = new_ck->sum.p;
		/* start the path with the ID of the previous hop because
		 * we know it is defined */
		new_path_id->hi = ofp->rem_id>>8;
		new_path_id->lo = ofp->rem_id;
		new.fgs_num_cks = 1;
		++new_ck;
		break;
	}

	for (prev_type = type = DCC_CK_INVALID, ck = stream->r.cks;
	     ck < ck_lim;
	     prev_type = type, ++ck) {
		type = ck->type;
		if (!DCC_CK_TYPE_FLOD_OK(grey_on, type)) {
			if (!iflod_rpt_complain(ifp, &new, 1, 0,
						"report",
						"unknown checksum type %s in",
						DB_TYPE2STR(type)))
				return -1;
			continue;
		}
		if (ck->len != sizeof(*ck)) {
			iflod_close(ifp, 1, 1, 1,
				    "unknown checksum length %d in %s",
				    ck->len, rpt_id("report", &new, 0));
			return -1;
		}
		if (type <= prev_type && prev_type != DCC_CK_FLOD_PATH) {
			if (!iflod_rpt_complain(ifp, &new, 1, 0,
						"report",
						"out of order %s checksum in",
						DB_TYPE2STR(type)))
				return -1;
			return rpt_len;
		}

		new_ck->type_fgs = type;
		new_ck->prev = DB_PTR_CP(DB_PTR_NULL);
		new_ck->sum = ck->sum;
		if (type == DCC_CK_FLOD_PATH) {
			/* discard report if path is too long */
			if (++num_path_blocks > DCC_MAX_FLOD_PATHS) {
				TMSG2_FLOD1(ofp, "%d path blocks in %s",
					    num_path_blocks,
					    rpt_id("report", &new, ifp));
				return rpt_len;
			}
			/* don't add this path if we translated the origin */
			if (srvr_mapped == ID_MAP_SELF)
				continue;

		} else {
			/* discard this checksum if we would not have kept
			 * it if we had received the original report
			 * and either its server-ID is translated
			 * or it is not kept by default */
			if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type)
			    && (srvr_mapped == ID_MAP_SELF
				|| DB_GLOBAL_NOKEEP(grey_on, type)))
				continue;

			if (DCC_CK_IS_REP(grey_on, type)
			    && new_tgts > DCC_REP_TGTS_MAX
			    && new_tgts != DCC_TGTS_DEL) {
				iflod_close(ifp, 1, 1, 1, "bogus target count"
					    " %s for %s in %s",
					    tgts2str(tgts_buf, sizeof(tgts_buf),
						     new_tgts, grey_on),
					    DB_TYPE2STR(type),
					    rpt_id("report", &new, 0));
				return -1;
			}

			/* server-ID declarations are never stale */
			if (type == DCC_CK_SRVR_ID) {
				timely = 1;
				srvr_id_ck = new_ck;
			}

			/* Notice if this checksum makes the report timely
			 * We cannot detect duplicates of reports that
			 * have expired, so consider stale anything older
			 * than our expiration.
			 * Ignore reports of checksums from crazy servers */
			if (!timely) {
				if ((tp != 0
				     && (tp->srvr_type == DCC_ID_SRVR_ROGUE
					 || tp->srvr_type == DCC_ID_SRVR_IGNORE))
				    || ts2secs(&new.ts) < (db_time.tv_sec
							- FLOD_STALE_SECS)) {
					if (TMSG_FB2(ofp)
					    && CK_FLOD_CNTERR(&ofp->lc.stale))
					    flod_cnterr(&ofp->lc.stale,
							"stale %s",
							rpt_id("report",
							    &new, ifp));
					return rpt_len;
				}
				if (ts_newer_ts(&new.ts,
						new_tgts >= db_tholds[type]
						? &db_parms.ex_spam[type]
						: &db_parms.ex_all[type]))
					timely = 1;
			}
		}

		++new_ck;
		++new.fgs_num_cks;
	}
	if (!timely) {
		if (TMSG_FB2(ofp) && CK_FLOD_CNTERR(&ofp->lc.stale))
			flod_cnterr(&ofp->lc.stale, "stale %s",
				    rpt_id("report", &new, ifp));
		return rpt_len;
	}

	if (!DB_NUM_CKS(&new)) {
		iflod_close(ifp, 1, 1, 1, "no known checksum types in %s",
			    rpt_id("report", &new, 0));
		return -1;
	}

	/* only now might we look at the database */
	if (db_lock() < 0) {
		iflod_close(ifp, 1, 1, 1, "iflod lock failure");
		return -1;
	}

	/* See if the report is a duplicate.
	 * Divide the checksums into classes, and check one chain in each.
	 * Each class is of checksums that can be separated from the
	 * original report as the report is flooded. */
	ok2 = 0;
	not_dup_global = 0;
	not_dup_nokeep = 0;
	not_dup_rep = 0;

	/* check body checksum first because its chain is usually shortest */
	for (new_ck = new.cks; new_ck < &new.cks[DB_NUM_CKS(&new)]; ++new_ck) {
		type = DB_CK_TYPE(new_ck);
		if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type))
			continue;

		/* chase each class of chain only once */
		if (DB_GLOBAL_NOKEEP(grey_on, type))
			not_dup_class = &not_dup_nokeep;
		else if (DCC_CK_IS_REP(grey_on, type))
			not_dup_class = &not_dup_rep;
		else
			not_dup_class = &not_dup_global;
		if (*not_dup_class)
			continue;

		switch (db_lookup(&dcc_emsg, type, &new_ck->sum,
				  0, rcd_st, &found_ck)) {
		case DB_FOUND_SYSERR:
			iflod_close(ifp, 1, 1, 1, "%s", dcc_emsg.c);
			DB_ERROR_MSG(dcc_emsg.c);
			return -1;

		case DB_FOUND_IT:
			found_tgts = DB_TGTS_CK(found_ck);
			/* This checksum is already in the database.
			 * The report might or might not be a duplicate. */
			r = ck_dup_ck_chain(ifp, rcd_st,
					    &new, new_tgts, type, found_ck);
			switch (r) {
			case CK_DUP_BROKEN:
				return -1;

			case CK_DUP_NOT:
				goto keep;

			case CK_DUP_DISCARD:
				return rpt_len;

			case CK_DUP_REPLACE:
				goto keep;

			case CK_DUP_NEXT_CK:
				/* The report is not a duplicate in this
				 * checksum chain.  It might be a superset
				 * of a report on some other chain because
				 * of varying db_parms.nokeep_cks or -K bits.
				 *
				 * Notice reports of checksums on the local
				 * server's whitelist.
				 * An ordinary checksum is whitelisted by
				 * DCC_TGTS_OK or two reports with DCC_TGTS_OK2.
				 * Greylisting uses
				 * DCC_TGTS_GREY_WHITE=DCC_TGTS_OK2
				 * and so one report of DCC_TGTS_GREY_WHITE is
				 * enough */
				if (found_tgts == DCC_TGTS_OK
				    || (found_tgts == DCC_TGTS_GREY_WHITE
					&& (++ok2 >= 2 || grey_on))) {
					iflod_rpt_complain(ifp, &new, 0,
							&ofp->lc.wlist,
							"report","whitelisted");
					return rpt_len;
				}
				*not_dup_class = 1;
				break;
			}
			break;

		case DB_FOUND_EMPTY:
		case DB_FOUND_CHAIN:
		case DB_FOUND_INTRUDER:
			/* We will fail to find this checksum in our database
			 * if the new report is not a duplicate
			 * or if it is a duplicate superset report */
			*not_dup_class = 1;
			break;
		}
	}
keep:;

	/* If the new report is a delete request,
	 * then we need to run dbclean to fix all of the
	 * totals affected by the deleted reports. */
	if (new_tgts == DCC_TGTS_DEL) {
		if (!(ofp->i_opts.flags & FLOD_OPT_NO_LOG_DEL))
			dcc_trace_msg("accept %s",
				      rpt_id("delete request", &new, ifp));
		if (!DCC_CK_IS_REP(grey_on, type) && !grey_on)
			need_del_dbclean = "flood checksum deletion";
	}

	if (srvr_id_ck) {
		/* discard mapped server-ID assertions */
		if (srvr_mapped == ID_MAP_SELF) {
			TMSG2_FLOD1(ofp,
				    "mapped server-ID assertion from %d in %s",
				    old_srvr, rpt_id("report", &new, ifp));
			return rpt_len;
		}

		if (!iflod_rpt_id(srvr_id_ck, ifp, &new, old_srvr)) {
			return rpt_len;
		}
	}

	if (srvr_mapped == ID_MAP_NO && !tp
	    && DCC_ID_SRVR_NORMAL(old_srvr)
	    && grey_on			/* no anonymous greylist clients */
	    && CK_FLOD_CNTERR(&ifp->ofp->lc.bad_id))
		flod_cnterr(&ifp->ofp->lc.bad_id,
			    "unknown server-ID in %s",
			    rpt_id("report", &new, ifp));

	/* the report is ok and not a duplicate, so add it to our database */
	if (!add_dly_rcd(&new, 1, rcd_st)) {
		iflod_close(ifp, 1, 1, 1, "%s", dcc_emsg.c);
		return -1;
	}

	++ofp->cnts.accepted;
	return rpt_len;
}



static void
bad_vers(IFLOD_INFO *ifp,
	 u_char fail)			/* 1=complain */
{
	iflod_close(ifp, fail, fail, 1,
		    DCC_FLOD_BAD_VER_MSG
		    "; expected \"" DCC_FLOD_VERS_CUR_STR "\" not \"%.*s\"",
		    LITZ(DCC_FLOD_VERS_BASE)+10,
		    ifp->ibuf.s.v.body.str);
}



/* authenticate and otherwise check a new incoming flood */
static u_char				/* 0=closed or switched to output */
check_iflod_vers(IFLOD_INFO *ifp)
{
	DCC_FNM_LNO_BUF fnm_buf;
	const DCC_FLOD_VERS_HDR *vp;
	OFLOD_INFO *ofp;
	IFLOD_INFO *ifp1;
	FLOD_MMAP *mp;
	const ID_TBL *tp;
	DCC_SRVR_ID rem_id;
	u_char peer_rep_on = 0;
	int iversion;
	u_int n;
	int i;

	vp = &ifp->ibuf.s.v;
	if (!strcmp(vp->body.str, DCC_FLOD_VERS_CUR_STR)) {
		iversion = DCC_FLOD_VERS_CUR;
		ifp->flags |= IFLOD_FG_VERS_CK;

#ifdef DCC_FLOD_VERS7
	} else if (!strcmp(vp->body.str, DCC_FLOD_VERS7_STR)) {
		iversion = DCC_FLOD_VERS7;
		ifp->flags |= IFLOD_FG_VERS_CK;

#endif /* DCC_FLOD_VERS7 */
	} else if (!strcmp(vp->body.str, DCC_FLOD_REP_VERS_CUR_STR)) {
		iversion = DCC_FLOD_VERS_CUR;
		ifp->flags |= IFLOD_FG_VERS_CK;
		peer_rep_on = 1;

#ifdef DCC_FLOD_VERS7
	} else if (!strcmp(vp->body.str, DCC_FLOD_REP_VERS7_STR)) {
		iversion = DCC_FLOD_VERS_CUR;
		ifp->flags |= IFLOD_FG_VERS_CK;
#endif /* DCC_FLOD_VERS7 */

	} else if (!strncmp(vp->body.str, DCC_FLOD_VERS_BASE,
			    LITZ(DCC_FLOD_VERS_BASE))) {
		/* it seems to be a DCC server,
		 * so complain after identifying the peer */
		iversion = 1;

	} else {
		/* junk, so complain and give up */
		bad_vers(ifp, 1);
		return 0;
	}

	/* require a sane and familiar server-ID from the prospective peer */
	memcpy(&rem_id, vp->body.sender_srvr_id, sizeof(rem_id));
	rem_id = ntohs(rem_id);
	if (!DCC_ID_SRVR_NORMAL(rem_id)) {
		iflod_close(ifp, 1, 1, 1, DCC_FLOD_BAD_ID_MSG" %d",
			    rem_id);
		return 0;
	}
	for (ofp = oflods.infos; ; ++ofp) {
		if (ofp > LAST(oflods.infos)) {
			iflod_close(ifp, 1, 1, 1, DCC_FLOD_BAD_ID_MSG" %d",
				    rem_id);
			return 0;
		}
		if (ofp->rem_id == rem_id) {
			ifp->ofp = ofp;
			STRLCPY(ifp->rem_hostname, ofp->rem_hostname,
				sizeof(ifp->rem_hostname));
			break;
		}
	}

	/* ofp and ofp->mp are not null, because we now know which peer
	 * it claims to be */
	mp = ofp->mp;

	/* check that the peer knows the password */
	i = ck_sign(&tp, 0, ofp->in_passwd_id, vp, sizeof(*vp));
	if (!i) {
		if (!tp)
			iflod_close(ifp, 1, 1, 1, DCC_FLOD_PASSWD_ID_MSG" %d%s",
				    ofp->in_passwd_id,
				    dcc_fnm_lno(&fnm_buf, flod_path.c,
						ofp->lno));
		else
			iflod_close(ifp, 1, 1, 1, DCC_FLOD_BAD_AUTH_MSG" %d",
				    ofp->in_passwd_id);
		return 0;
	}
	if (i == 1)
		mp->flags &= ~FLODMAP_FG_USE_2PASSWD;
	else
		mp->flags |= FLODMAP_FG_USE_2PASSWD;

	/* no more auto-NAT if it contacted us */
	if (!(ifp->flags & IFLOD_FG_CLIENT))
		mp->flags &= ~FLODMAP_FG_NAT_AUTO;

	/* Note the version of the protocol it is using so that we can use that
	 * version when connecting to it. */
	mp->iversion = iversion;
	/* if we do not like its version, reject the connection and hope
	 * that it will retry  with a version we like */
	if (!(ifp->flags & IFLOD_FG_VERS_CK)) {
		bad_vers(ifp, 0);
		return 0;
	}

	if (peer_rep_on) {
		/* the peer wants to use DCC Reputations */
		if (iversion != DCC_FLOD_REP_VERS_CUR)
			TMSG2_FLOD1(ofp, "version %d from %s",
				    iversion, ifp_rem_str(ifp));

		mp->flags |= FLODMAP_FG_REP_PEER_ON;

		if (!grey_on) {
			/* try reputations next time we try to connect */
			ofp->flags |= OFLOD_FG_REP_TRY;

			/* Reputations implies accepting deletes by default so
			 * that we can fix reputations */
			if (!(ofp->i_opts.flags & FLOD_OPT_DEL_SET))
				ofp->i_opts.flags |= FLOD_OPT_DEL_OK;
		}
	} else {
		/* the peer said nothing about wanting DCC Reputations */

		if (iversion != DCC_FLOD_VERS_CUR)
			TMSG2_FLOD1(ofp, "version %d from %s",
				    iversion, ifp_rem_str(ifp));

		mp->flags &= ~FLODMAP_FG_REP_PEER_ON;

		/* no reputations implies no deletes by default */
		if (!(ofp->i_opts.flags & FLOD_OPT_DEL_SET))
			ofp->i_opts.flags &= ~FLOD_OPT_DEL_OK;
	}

	/* convert to a passive output flood as requested by the peer
	 *	This works even if the peer is configured to use SOCKS or NAT
	 *	but we are not using PASSIVE */
	if (vp->body.turn) {
		if (OFLOD_OPT_OFF_ROGUE(ofp)) {
			iflod_close(ifp, 1, 0, 1,
				    "passive output flooding off from %s%s",
				    ifp_rem_str(ifp),
				    dcc_fnm_lno(&fnm_buf, flod_path.c,
						ofp->lno));
			return 0;
		}

		/* We have a duplicate passive outgoing flood.
		 * See whether the old stream has broken. */
		if (ofp->soc >= 0)
			oflod_read(ofp);
		/* If we still have a duplicate and we sent a shutdown request,
		 * assume the response got lost */
		if (ofp->soc >= 0
		    && (ofp->flags & OFLOD_FG_SHUTDOWN_REQ)) {
			ferr(ofp, 0, FERR_DUP, 1,
			     " assume response to shutdown lost from %s",
			     ofp_rem_str(ofp));
			oflod_close(ofp, 0);
		}
		if (ofp->soc >= 0) {
			/* We still have a duplicate.
			 * Assume we missed the shutdown and the connection is
			 * not from a fraud if the IP address of the prospective
			 * peer is the address of the old peer. */
			if (!DCC_SU_EQ(&ofp->rem, &ifp->rem)) {
				iflod_close(ifp, 1, 0, 1,
					    "reject duplicate passive output"
					    " flood from %s",
					    ifp_rem_str(ifp));
				return 0;
			}
			ferr(ofp, 0, FERR_DUP, 1,
			     "accept duplicate passive output flood from %s",
			     ifp_rem_str(ifp));
			oflod_close(ofp, 0);
		}

		ofp->soc = ifp->soc;
		ofp->rem = ifp->rem;
		++oflods.open;
		if (!(mp->flags & FLODMAP_FG_PASSIVE)) {
			dcc_trace_msg("convert incoming flood to forced passive"
				      " outgoing to %s",
				      ofp_rem_str(ofp));
		} else {
			TMSG1_FLOD1(ofp,
				    "convert incoming flood to passive"
				    " outgoing to %s",
				    ofp_rem_str(ofp));
		}
		iflod_clear(ifp, 0);
		mp->flags |= FLODMAP_FG_OUT_SRVR;

		if (!oflod_connect_fin(ofp))
			oflod_close(ofp, 0);

		return 0;
	}

	if (IFLOD_OPT_OFF_ROGUE(ofp)) {
		iflod_close(ifp, 1, 0, 1, "flood from %s turned off%s",
			    ifp_rem_str(ifp),
			    dcc_fnm_lno(&fnm_buf, flod_path.c, ofp->lno));
		return 0;
	}

	/* detect duplicate incoming floods */
	for (ifp1 = iflods.infos; ifp1 <= LAST(iflods.infos); ++ifp1) {
		if (ifp1->ofp != ofp || ifp1 == ifp)
			continue;

		/* We have a duplicate.  Either two servers are using the
		 * same server-ID or the peer has restarted flooding without
		 * our seeing a clean shutdown.
		 * If socket is in CLOSE_WAIT, then sending something will fail
		 * immediately.  If the peer was rebooted, then sending will
		 * not fail for at least a round trip time and possibly longer
		 * if the peer has moved.
		 *
		 * Before trying to send anything, check for a FIN waiting
		 * on the other socket */
		for (i = 65536/FLOD_BUF_SIZE; i >= 0; --i) {
			if (iflod_read(ifp1))
				break;
		}
		/* forget it if reading closed the other stream */
		if (ifp1->ofp != ofp)
			goto start_flood;

		/* assume the it is ok if we have sent an end request */
		if (ifp1->flags & IFLOD_FG_END_REQ) {
			iflod_close(ifp1, 0, 0, 1,
				    "missing end response;"
				    " have replacement for flood from %s",
				    ifp_rem_str(ifp1));
			goto start_flood;
		}

		/* Assume we missed the shutdown and the connection is not
		 * from a fraud if the IP address of the prospective peer
		 * is an address of the old peer. */
		if (DCC_SUnP_EQ(&ifp1->rem, &ifp->rem)) {
			iflod_close(ifp1, 0, 0, 1,
				    "assumed dead link and replacement"
				    " for flood from %s",
				    ifp_rem_str(ifp1));
			goto start_flood;
		}
		for (n = 0; n < ofp->i_dns.num; ++n) {
			if (DCC_SUnP_EQ(&ifp1->rem, &ofp->i_dns.su[n])) {
				iflod_close(ifp1, 0, 0, 1,
					    "assumed dead link and replacement"
					    " for flood from %s",
					    ifp_rem_str(ifp1));
				goto start_flood;
			}
		}

		/* assume we do not have a duplicate server-ID and switch to
		 * the new connection if sending a position or note
		 * fails immediately, */
		if (0 >= iflod_send_pos(ifp1, 1)) {
			iflod_close(ifp1, 0, 0, 1,
				    "have replacement for flood from %s",
				    ifp_rem_str(ifp1));
			goto start_flood;
		}

		/* Otherwise, kill the new flood.  If it was legitimate,
		 * sending the note will eventually kill the old stream
		 * and the peer will get through with it tries later */
		iflod_close(ifp, 1, 1, 1, "duplicate flood from %s",
			    ifp_rem_str(ifp));
		return 0;
	}
start_flood:

	ofp->ifp = ifp;
	if (ifp->flags & IFLOD_FG_CLIENT)
		mp->flags &= ~FLODMAP_FG_IN_SRVR;
	else
		mp->flags |= FLODMAP_FG_IN_SRVR;
	save_flod_cnts(ofp);
	ifp->iflod_alive = db_time.tv_sec;

	TMSG1_FLOD1(ofp, "flood from %s authenticated", ifp_rem_str(ifp));

	/* Try to restart the corresponding output flood because a new
	 * incoming flood might indicate that peer has awakened. */
	if (ofp->soc < 0
	    && !(ofp->o_opts.flags & FLOD_OPT_PASSIVE)) {
		mp->otimers.retry_secs = FLOD_RETRY_SECS;
		mp->otimers.retry = 0;
		oflod_open(ofp);
	}

	/* Send a rewind or fast forward request immediately if needed.
	 * If not, send a keepalive message so that peer knows we have
	 * accepted the connection and it can stop worrying about an
	 * immediate rejection. */
	if (0 > iflod_send_pos(ifp, 1))
		return 0;

	return 1;
}



/* A new SOCKS incoming stream that we originated has been closed by the
 * peer without authenticating itself.  It could have responded to our
 * authentication with an error message. */
static void
parse_socks_error(OFLOD_INFO *ofp, IFLOD_INFO *ifp)
{
	const DCC_FLOD_STREAM *stream;
	int i, msg_len;
	int fail;

	stream = (DCC_FLOD_STREAM *)&ifp->ibuf.b[0];
	msg_len = ifp->ibuf_len - FLOD_END_OVHD;

	/* it must look like an end request with an entirely ASCII message */
	if (flod_pos2db_ptr(stream->r.pos) != DCC_FLOD_POS_END
	    || msg_len < 1 || msg_len > ISZ(stream->e.msg)) {
		iflod_close(ifp, 1, 1, 1, "%s rejected with \"%.*s\"",
			    socks_type_str(ofp->mp), msg_len, stream->e.msg);
		return;
	}

	for (i = 0; i < msg_len; ++i) {
		if (stream->e.msg[i] < ' ' || stream->e.msg[i] > '~') {
			iflod_close(ifp, 1, 1, 1, "%s rejected with \"%.*s\"",
				    socks_type_str(ofp->mp),
				    msg_len, stream->e.msg);
			return;
		}
	}

	fail = oflod_parse_eof(ifp->ofp, 1, &stream->e, msg_len);
	if (fail <= 0) {
		iflod_socks_backoff(ifp->ofp);
	} else {
		/* try again immediately
		 * with another protocol version or the 2nd password */
		ifp->ofp->mp->itimers.retry = 0;
	}
	iflod_close(ifp, fail<=0, fail<=0, 0, "%s rejected by %s with \"%.*s\"",
		    socks_type_str(ofp->mp), ifp_rem_str(ifp),
		    msg_len, stream->e.msg);
}



/* see what a distant flooder is telling us
 *	can close the flood and so clear things */
u_char					/* 1=kernel buffers empty */
iflod_read(IFLOD_INFO *ifp)
{
	OFLOD_INFO *ofp;
	int off, req_len, recv_len;
	const DCC_FLOD_STREAM *stream;
	DB_ST *rcd_st;
	int len, i;

	/* if this is an incoming SOCKS or NAT stream that we originated,
	 * and if Rconnect() said "not yet" when we first tried to connect,
	 * then we must be here because select() says it is time to
	 * try Rconnect() again to finish the connection */
	if (!(ifp->flags & IFLOD_FG_CONNECTED)
	    && 0 >= iflod_socks_connect(ifp))
		return 1;

	/* read only once before returning
	 * to ensure we pay attention to other work */

	req_len = sizeof(ifp->ibuf) - ifp->ibuf_len;
	ofp = ifp->ofp;
	if (ofp && (ofp->o_opts.flags & FLOD_OPT_SOCKS))
		recv_len = Rrecv(ifp->soc, &ifp->ibuf.b[ifp->ibuf_len],
				 req_len, 0);
	else
		recv_len = recv(ifp->soc, &ifp->ibuf.b[ifp->ibuf_len],
				req_len, 0);
	if (recv_len < 0) {
		/* If kernel ran out of data, stop for now.
		 * Give up on an I/O error */
		if (!DCC_BLOCK_ERROR()) {
			iflod_close(ifp, 1, 0, 0, "incoming flood recv(%s): %s",
				    ifp_rem_str(ifp), ERROR_STR());
		}
		return 1;
	}
	ifp->ibuf_len += recv_len;

	off = 0;

	/* deal with a new connection */
	if (!(ifp->flags & IFLOD_FG_VERS_CK)) {
		if (ifp->ibuf_len >= ISZ(DCC_FLOD_VERS_HDR)) {
			if (!check_iflod_vers(ifp))
				return 1;   /* stream closed or converted */
			ofp = ifp->ofp;
			off = ISZ(DCC_FLOD_VERS_HDR);

		} else if (recv_len != 0) {
			return 1;	/* wait for rest of authentication */

		} else if (ofp && ofp->mp
			   && (ofp->mp->flags & FLODMAP_FG_ACT) != 0) {
			parse_socks_error(ofp, ifp);
			return 1;

		} else {
			iflod_close(ifp, 1, 1, 0, "garbage connection from %s",
				    ifp_rem_str(ifp));
			return 1;
		}
	}
	/* we know ofp != 0 because check_iflod_vers() has found the peer
	 * ofp->mp != because oflods.infos is either clear or the file
	 * is mapped */

	/* deal with the data */
	timeval2ts(&future, &db_time, MAX_FLOD_CLOCK_SKEW);
	rcd_st = GET_DB_ST();
	while ((len = ifp->ibuf_len - off) >= DCC_FLOD_RPT_LEN(0)) {
		stream = (DCC_FLOD_STREAM *)&ifp->ibuf.b[off];
		if (len < ISZ(stream->r.pos))
			break;		/* need at least the position */
		i = iflod_rpt(ifp, ofp, stream, len, rcd_st);
		if (i < 0) {
			free_db_st(rcd_st);
			return 1;	/* stream closed */
		}
		if (i == 0)
			break;		/* wait for rest of report */
		off += i;
		++ofp->cnts.total;
	}
	free_db_st(rcd_st);

	/* save unprocessed bytes for next time */
	if (off != 0) {
		ifp->ibuf_len -= off;
		if (ifp->ibuf_len < 0)
			dcc_logbad(EX_SOFTWARE, "ifp->ibuf_len=%d",
				   ifp->ibuf_len);
		if (ifp->ibuf_len > 0)
			memmove(&ifp->ibuf.b[0], &ifp->ibuf.b[off],
				ifp->ibuf_len);
	}

	if (recv_len == 0) {
		/* We are at EOF and have processed all input that we can. */
		if (ifp->ibuf_len != 0) {
			/* Something is wrong if any input remains,  */
			iflod_close(ifp, 1, 0, 1,
				    "report %d truncated after %d bytes at EOF",
				    ofp->cnts.total, ifp->ibuf_len);
		} else if (flods_st != FLODS_ST_ON
			   || IFLOD_OPT_OFF_ROGUE(ofp)) {
			iflod_close(ifp, 0, 0, 1, DCC_FLOD_OK_STR"%s EOF",
				    our_hostname);
		} else {
			iflod_close(ifp, 0, 0, 1, DCC_FLOD_OK_STR"%s EOF",
				    ifp_rem_str(ifp));
		}
		return 1;
	}

	/* things are going ok, so reset the SOCKS restart backoff
	 * and the no-connection complaint */
	ofp->mp->itimers.retry_secs = FLOD_SOCKS_IRETRY;
	ofp->mp->itimers.msg_secs = FLOD_IN_COMPLAIN1;
	ofp->mp->itimers.msg = db_time.tv_sec + FLOD_IN_COMPLAIN1;

	/* Limit the backoff for outgoing connection attempts while
	 * receiving data. */
	if (!(ofp->o_opts.flags & FLOD_OPT_PASSIVE))
		DB_ADJ_TIMER(&ofp->mp->otimers.retry,
			     &ofp->mp->otimers.retry_secs, FLOD_RETRY_SECS);

	return (req_len > recv_len);
}



void
iflods_listen(void)
{
	SRVR_SOC *sp;
	int i, on;

	for (sp = srvr_socs; sp; sp = sp->fwd) {
		if (sp->listen >= 0)
			continue;

		/* don't need to listen if there is no flooding */
		if (!oflods.total) {
			iflod_listen_close(sp);
			continue;
		}

		if (sp->flags & SRVR_SOC_ADDR) {
			/* need to open a TCP listen socket for incoming floods
			 * for each explicitly configured IP address */
			sp->listen_su = sp->udp_su;
		} else if (sp->flags & SRVR_SOC_ANY_LISTEN) {
			/* need to open one TCP INADDR_ANY listen socket for
			 * the first implicitly configured interface */
			dcc_mk_su(&sp->listen_su, sp->udp_su.sa.sa_family,
				  0, 0, DCC_SU_PORT(&sp->udp_su));
		} else {
			/* otherwise close unneeded listen socket */
			iflod_listen_close(sp);
			continue;
		}

		TMSG1(FLOD1, "start flood listening on %s",
		      dcc_su2str_err(&sp->listen_su));

		sp->listen = socket(sp->listen_su.sa.sa_family, SOCK_STREAM, 0);
		if (sp->listen < 0) {
			dcc_error_msg("socket(flood listen %s): %s",
				      dcc_su2str_err(&sp->listen_su),
				      ERROR_STR());
			continue;
		}

		if (!soc_v6only(&dcc_emsg, sp->listen, &sp->listen_su))
			dcc_trace_msg("UDP %s", dcc_emsg.c);

		if (0 > fcntl(sp->listen, F_SETFD, FD_CLOEXEC))
			dcc_error_msg("fcntl(flood listen %s FD_CLOEXEC): %s",
				      dcc_su2str_err(&sp->listen_su),
				      ERROR_STR());

		if (-1 == fcntl(sp->listen, F_SETFL,
				fcntl(sp->listen, F_GETFL, 0) | O_NONBLOCK)) {
			dcc_error_msg("fcntl(flood listen %s, O_NONBLOCK): %s",
				      dcc_su2str_err(&sp->listen_su),
				      ERROR_STR());
		}

		on = 1;
		if (0 > setsockopt(sp->listen, SOL_SOCKET, SO_REUSEADDR,
				   &on, sizeof(on)))
			dcc_error_msg("setsockopt(flood listen %s,"
				      " SO_REUSADDR): %s",
				      dcc_su2str_err(&sp->listen_su),
				      ERROR_STR());

		i = bind(sp->listen, &sp->listen_su.sa,
			 DCC_SU_LEN(&sp->listen_su));
		if (0 > i) {
			dcc_error_msg("bind(flood listen %s): %s",
				      dcc_su2str_err(&sp->listen_su),
				      ERROR_STR());
			close(sp->listen);
			sp->listen = -1;
			continue;
		}

		if (0 > listen(sp->listen, DCCD_MAX_FLOODS+1)) {
			dcc_error_msg("flood listen(%s): %s",
				      dcc_su2str_err(&sp->listen_su),
				      ERROR_STR());
			close(sp->listen);
			sp->listen = -1;
		}
	}
}



static const char *
oflod_state_str(char outstr[DCC_SU2STR_SIZE], const OFLOD_INFO *ofp,
		u_char *distinct_inp)
{
	if (ofp->soc >= 0) {
		if (ofp->flags & (OFLOD_FG_SHUTDOWN_REQ
				  | OFLOD_FG_SHUTDOWN))
			return "  (shutting)";
		if (!(ofp->flags & OFLOD_FG_CONNECTED)) {
			*distinct_inp = 1;
			return "  (connecting)";
		}
		return dcc_su2str2(outstr, DCC_SU2STR_SIZE, &ofp->rem);
	}

	if (OFLOD_OPT_OFF_ROGUE(ofp))
		return "  (output off)";
	if (flods_st != FLODS_ST_ON)
		return "  (flood off)";
	return "  (no output)";
}



static const char *
iflod_state_str(char instr[DCC_SU2STR_SIZE],
		const OFLOD_INFO *ofp, const IFLOD_INFO *ifp,
		u_char have_in, u_char distinct_in)
{

	if (have_in) {
		if (!(ifp->flags & IFLOD_FG_VERS_CK))
			return "  (connecting)";
		if (distinct_in)
			return dcc_su2str2(instr, DCC_SU2STR_SIZE, &ifp->rem);
		return "";
	}
	if (IFLOD_OPT_OFF_ROGUE(ofp))
	    return "  (input off)";
	if (flods_st != FLODS_ST_ON)
		return "  (flood off)";
	return "  (no input)";
}



/* list the current flooders */
int
flods_list(char *buf, int buf_len, u_char anon)
{
#define FLODS_LIST_TOO_SHORT "buffer too short\n"
#define FLODS_LIST_ALLOC(i) {					\
	p += (i);						\
	if ((buf_len -= (i)) <= 0) {				\
		strcpy(p, FLODS_LIST_TOO_SHORT);		\
		return (p-buf)+ISZ(FLODS_LIST_TOO_SHORT);	\
	}}
	IFLOD_INFO *ifp;
	OFLOD_INFO *ofp;
	char inbuf[DCC_SU2STR_SIZE], outbuf[DCC_SU2STR_SIZE];
	const char *inp, *outp;
	char hostname[60], fg_buf[120];
	int l1, l2, s0, s1, s2;
	DCC_SOCKU in, out;
	u_char have_in, distinct_in;
	int i;
	char *p;

	if (buf_len < ISZ(FLODS_LIST_TOO_SHORT) +INET6_ADDRSTRLEN+1)
		return 0;

	buf_len -= ISZ(FLODS_LIST_TOO_SHORT);
	p = buf;
	for (ofp = oflods.infos; ofp <= LAST(oflods.infos); ++ofp) {
		if (ofp->rem_hostname[0] == '\0')
			break;
		have_in = 0;
		distinct_in = 0;
		for (ifp = iflods.infos; ifp <= LAST(iflods.infos); ++ifp) {
			if (ifp->ofp == ofp) {
				if (ifp->soc >= 0) {
					have_in = 1;
					dcc_ipv6su2ipv4su(&in, &ifp->rem);
					dcc_ipv6su2ipv4su(&out, &ofp->rem);
					if (ofp->soc < 0
					    || !DCC_SUnP_EQ(&in, &out))
					    distinct_in = 1;
				}
				break;
			}
		}
		if (anon) {
			/* do not tell anonymous users IP addresses, names
			 * or flags */
			inp = "";
			outp = "";
			hostname[0] = '\0';
			fg_buf[0] = '\0';
		} else {
			outp = oflod_state_str(outbuf, ofp, &distinct_in);
			inp = iflod_state_str(inbuf, ofp, ifp,
					      have_in, distinct_in);
			dcc_host_portname(hostname, sizeof(hostname),
					  ofp->rem_hostname,
					  ofp->rem_port == def_port
					  ? 0 : ofp->rem_portname),
			flodmap_fg(fg_buf, sizeof(fg_buf), ofp->mp);
		}

		l1 = strlen(outp);
		s0 = 15 - l1;
		if (s0 < 0)
			s0 = 0;
		s1 = 15+2 - (s0+l1);
		if (s1 < 0)
			s1 = 0;
		l2 = strlen(inp);
		s2 = 13+2 - l2;
		if (s2 < 0)
			s2 = 0;
		if (s0+l1+s1+l2+s2 > (15+2+13+2)) {
			s2 -= (s0+l1+s1+l2+s2 - (15+2+13+2));
			if (s2 < 0)
				s2 = 0;
		}
		if (s0+l1+s1+l2+s2 > (15+2+13+2)) {
			s1 -= (s0+l1+s1+l2+s2 - (15+2+13+2));
			if (s1 < 0)
				s1 = 0;
		}
		if (s0+l1+s1+l2+s2 > (15+2+13+2)) {
			s0 -= (s0+l1+s1+l2+s2 - (15+2+13+2));
			if (s0 < 0)
				s0 = 0;
		}

		i = snprintf(p, buf_len,
			     "%5d %*s%s%*s %s%*s %-22s%s\n",
			     ofp->rem_id,
			     s0,"", outp, s1,"", inp, s2,"",
			     hostname,
			     fg_buf);
		FLODS_LIST_ALLOC(i);
	}

	for (ifp = iflods.infos; ifp <= LAST(iflods.infos); ++ifp) {
		if (ifp->soc < 0 || ifp->ofp != 0)
			continue;	/* already handled this one */

		/* say something about an incomplete connection */
		i = snprintf(p, buf_len, " ?    %s\n", ifp->rem_hostname);
		FLODS_LIST_ALLOC(i);
	}
	if (p > buf)
		--p;			/* trim trailing '\n' */
	return p-buf;
#undef FLODS_LIST_TOO_SHORT
#undef FLODS_LIST_ALLOC
}



static DCC_PF(3,4) u_char		/* 0=no room */
flod_stats_str(char **buf, int *buf_len,
		const char *pat, ...)
{
	int i;
	va_list args;

	if (*buf_len <= 0)
		return 0;

	va_start(args, pat);
	i = vsnprintf(*buf, *buf_len, pat, args);
	va_end(args);

	if ((*buf_len -= i) <= 0) {
		*buf_len = 0;
		return 0;
	}
	*buf += i;
	return 1;
}




static u_char				/* 0=no room */
flod_stats_time(char **buf, int *buf_len,
		const char *str, const char *timepat, time_t when)
{
	char timebuf[40];

	return flod_stats_str(buf, buf_len, "%s %s", str,
			      dcc_time2str(timebuf, sizeof(timebuf), timepat,
					   when));
}



static void
flod_stats_conn_total(char **buf, int *buf_len,
		      const char *label, int connected)
{
	int i;

	if (*buf_len <= 0)
		return;

	i = snprintf(*buf, *buf_len,
		     "\n  %s connected a total of %d days %d:%02d:%02d\n",
		     label,
		     connected/(24*60*60),
		     (connected/(60*60)) % 24,
		     (connected/60) % 60,
		     connected % 60);
	*buf += i;
	*buf_len -= i;
}



static u_char
flod_stats_conn_emsg(char **buf, int *buf_len, const LAST_FERR *ep)
{
	const char *msg;

	if (ep->error_type != FERR_NONE)
		msg = ep->error_msg;
	else if (ep->trace_type != FERR_NONE)
		msg = ep->trace_msg;
	else
		return 1;
	return flod_stats_str(buf, buf_len, "\n\t%s", msg);
}



static void
flod_stats_conn_cur(char **buf, int *buf_len, const OFLOD_INFO *ofp, u_char in)
{
	u_char connected;
	time_t conn_changed;
	time_t flod_alive;
	const FLOD_MMAP *mp;
	DCC_FNM_LNO_BUF fnm_buf;
	time_t deadline;
	u_char passive;

	if (*buf_len <= 0)
		return;

	mp = ofp->mp;

	if (in) {
		connected = ofp->ifp != 0;
		conn_changed = ofp->mp->cnts.in_conn_changed;
		flod_alive = ofp->ifp ? ofp->ifp->iflod_alive : 0;
	} else {
		connected = (ofp->flags & OFLOD_FG_CONNECTED) != 0;
		conn_changed = ofp->mp->cnts.out_conn_changed;
		flod_alive = ofp->oflod_alive;
	}

	if (connected) {
		if (conn_changed >= TIME_T(mp->cnts.cnts_cleared)
		    && !flod_stats_time(buf, buf_len, "     connected since",
					"%b %d %X", conn_changed))
			return;
		flod_stats_time(buf, buf_len, "     last active", "%X",
				flod_alive);

		/* show the last active error messages
		 * if we are forced passive */
		if (!in
		    && (mp->flags & FLODMAP_FG_OUT_SRVR)
		    && !(mp->flags & FLODMAP_FG_PASSIVE))
			flod_stats_conn_emsg(buf, buf_len, &mp->oflod_err);
		return;
	}

	if ((in && (mp->flags & FLODMAP_FG_IN_OFF))
	    || (!in && (mp->flags & FLODMAP_FG_OUT_OFF))) {
		flod_stats_str(buf, buf_len, "     off%s",
			       dcc_fnm_lno(&fnm_buf, flod_path.c, ofp->lno));
		return;
	}

	if (!flod_stats_str(buf, buf_len, "     not connected"))
		return;
	if (conn_changed >= TIME_T(mp->cnts.cnts_cleared)) {
		if (!flod_stats_time(buf, buf_len, " since",
				     "%b %d %X", conn_changed))
			return;
	}

	if (!flod_stats_conn_emsg(buf, buf_len,
				  in ? &mp->iflod_err : &mp->oflod_err))
		return;

	if (!FLODS_OK_ON()) {
		flod_stats_str(buf, buf_len, "\n     flooding off");
		return;
	}

	if (in) {
		if ((ofp->mp->flags & FLODMAP_FG_ACT) != 0) {
			passive = 0;
			deadline = ofp->mp->itimers.retry;
			if (DB_IS_TIME(deadline, ofp->mp->itimers.retry_secs))
				deadline = 0;

		} else {
			passive = 1;
			deadline = ofp->mp->itimers.msg;
			if (DB_IS_TIME(deadline, ofp->mp->itimers.msg_secs))
				deadline = 0;
		}
	} else {
		if (ofp->mp->flags & FLODMAP_FG_PASSIVE) {
			passive = 1;
			deadline = ofp->mp->otimers.msg;
			if (DB_IS_TIME(deadline, ofp->mp->otimers.msg_secs))
				deadline = 0;
		} else {
			passive = 0;
			deadline = ofp->mp->otimers.retry;
			if (DB_IS_TIME(deadline, ofp->mp->otimers.retry_secs))
				deadline = 0;
		}
	}
	if (deadline != 0) {
		char socks_buf[40];
		const char *pat;
		if (passive) {
			pat = "\n     complain after";
		} else if (in) {
			snprintf(socks_buf, sizeof(socks_buf),
				 "\n     try %s again after",
				 socks_type_str(mp));
			pat = socks_buf;
		} else {
			pat = "\n     try again after";
		}
		flod_stats_time(buf, buf_len, pat, "%b %d %X", deadline);
	}
}



/* list the counts for a flood */
int					/* -1 or buffer length */
flod_stats(char *buf, int buf_len, u_int32_t tgt, u_char clear)
{
#define FLOD_STATS_TOO_SHORT "buffer too short\n"
#define FLOD_STATS_ALLOC(i) (p += (i), len -= (i))
	OFLOD_INFO *ofp, *ofp1;
	FLOD_MMAP *mp;
	char now_buf[26], time_buf[26], fg_buf[120];
	DCC_SRVR_ID min_srvr, max_srvr;
	u_char loaded;
	int len, i;
	char *p;

	if (buf_len < ISZ(FLOD_STATS_TOO_SHORT))
		return 0;
	len = buf_len - ISZ(FLOD_STATS_TOO_SHORT);
	p = buf;

	if (flod_mmaps) {
		loaded = 0;
	} else if (!load_flod(1, 0)) {
		return -1;
	} else {
		loaded = 1;
	}

	if (tgt <= DCC_SRVR_ID_MAX) {
		/* an explicit target server-ID was specified */
		min_srvr = max_srvr = tgt;
	} else {
		/* look for next server-ID after the target value */
		min_srvr = tgt - DCC_SRVR_ID_MAX;
		max_srvr = DCC_SRVR_ID_MAX;
	}
	ofp = 0;
	for (ofp1 = oflods.infos; ofp1 <= LAST(oflods.infos); ++ofp1) {
		if (ofp1->rem_hostname[0] != '\0'
		    && ofp1->rem_id >= min_srvr
		    && ofp1->rem_id <= max_srvr) {
			/* This peer fits and is the best so far. */
			ofp = ofp1;
			max_srvr = ofp->rem_id-1;
		}
	}
	if (!ofp) {
		i = snprintf(p, len,
			     DCC_AOP_FLOD_STATS_ID"unknown remote server-ID",
			     tgt);
		FLOD_STATS_ALLOC(i);
		if (loaded)
			oflods_clear();
		return p-buf;
	}
	mp = ofp->mp;

	save_flod_cnts(ofp);
	i = snprintf(p, len,
		     DCC_AOP_FLOD_STATS_ID" %s%s  %s\n  status start %s",
		     ofp->rem_id, mp->rem_hostname,
		     flodmap_fg(fg_buf, sizeof(fg_buf), mp),
		     dcc_time2str(now_buf, sizeof(now_buf), "%b %d %X %Z",
				  db_time.tv_sec),
		     dcc_time2str(time_buf, sizeof(time_buf), "%b %d %X %Z",
				  mp->cnts.cnts_cleared));
	FLOD_STATS_ALLOC(i);

	flod_stats_conn_total(&p, &len, "output", mp->cnts.out_total_conn);
	i = snprintf(p, len, "     "L_DPAT" reports sent\n",
		     mp->cnts.out_reports+ofp->cnts.out_reports);
	FLOD_STATS_ALLOC(i);
	flod_stats_conn_cur(&p, &len, ofp, 0);
	i = snprintf(p, len, "\n     position "L_HxPAT, mp->confirm_pos);
	FLOD_STATS_ALLOC(i);
	if (ofp->mp->reps_rejected != 0)
		flod_stats_time(&p, &len, "\n     reputations rejected at",
				"%b %d %X", ofp->mp->reps_rejected);

	flod_stats_conn_total(&p, &len, "input", mp->cnts.in_total_conn);
	i = snprintf(p, len,
		     "     "L_DPAT" reports received  "L_DPAT" accepted"
		     "  "L_DPAT" duplicate  "L_DPAT" stale\n"
		     "     "L_DPAT" bad whitelist  "L_DPAT" not deleted\n",
		     mp->cnts.total+ofp->cnts.total,
		     mp->cnts.accepted+ofp->cnts.accepted,
		     mp->cnts.dup+ofp->lc.dup.cur,
		     mp->cnts.stale+ofp->lc.stale.cur,
		     mp->cnts.wlist+ofp->lc.wlist.cur,
		     mp->cnts.not_deleted+ofp->lc.not_deleted.cur);
	FLOD_STATS_ALLOC(i);
	flod_stats_conn_cur(&p, &len, ofp, 1);

	if (len <= 0) {
		strcpy(buf, FLOD_STATS_TOO_SHORT);
		if (loaded)
			oflods_clear();
		return ISZ(FLOD_STATS_TOO_SHORT);
	}

	if (clear) {
		flod_try_again(ofp, 1);
		save_flod_cnts(ofp);
		ofp->limit_reset = 0;
		memset(&mp->cnts, 0, sizeof(mp->cnts));
		mp->cnts.cnts_cleared = db_time.tv_sec;
	}

	if (loaded)
		oflods_clear();
	return p-buf;
#undef FLOD_STATS_TOO_SHORT
#undef FLOD_STATS_ALLOC
}
