/* Distributed Checksum Clearinghouse
 *
 * helper processes for DNS white- and blacklists
 *
 * Using separate processes allows much finer control over timeout that
 * is possible with the common resolver library.
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
 * Rhyolite Software DCC 2.3.167-1.62 $Revision$
 */

#include "helper.h"
#include "dcc_heap_debug.h"
#include <signal.h>
#include <sys/wait.h>


#ifdef HAVE_HELPERS

#define HELPERS_DEBUG() (helpers.debug > 2 || helpers.helpers_debug)

static void new_gen(void);


/* add to the argv list for the helper processes */
void
helper_save_arg(const char *flag, const char *value)
{
	char const **new_arg;
	int i;

	if (helpers.free_args <= 1) {
		/* reserve space for the argv[0] and the null terminator */
		helpers.free_args += 5;
		i = (helpers.argc + 2*helpers.free_args) * sizeof(char *);
		new_arg = dcc_malloc(i);
		memset(new_arg, 0, i);
		if (helpers.argv) {
			for (i = 0; i < helpers.argc; ++i)
				new_arg[i] = helpers.argv[i];
			dcc_free(helpers.argv);
		} else {
			++helpers.argc;
		}
		helpers.argv = new_arg;
	}

	helpers.argv[helpers.argc] = flag;
	helpers.argv[++helpers.argc] = value;
	helpers.argv[++helpers.argc] = 0;
	--helpers.free_args;
}



/* initialize things for the parent */
void
helper_init(int max_helpers)
{
	helpers.sn = getpid() + time(0);

	/* If helpers.max_helpers was not set explicitly,
	 * then default to max_work from dccifd or dccm. */
	if (helpers.max_helpers == 0)
		helpers.max_helpers = max_helpers;

	have_helpers = helper_lock_init();

	helper_lock();
	new_gen();
	helper_unlock();
}



/* Work on killing a generation of helpers. */
static void
clean_gens(void)
{
	HELPER_GEN *gen, *next_gen;
	int pid_inx;

	assert_helper_locked();
	if (helpers.is_child)
		dcc_logbad(EX_SOFTWARE, "bad helper child");

	for (gen = helpers.gens; gen; gen = next_gen) {
		next_gen = gen->fwd;

		if (gen->ref_cnt > 0)
			continue;

		/* The children in an old generation should not phone home. */
		if (gen->fin_pipe[0] >= 0) {
			close(gen->fin_pipe[0]);
			gen->fin_pipe[0] = -1;
		}
		if (gen->fin_pipe[1] >= 0) {
			close(gen->fin_pipe[1]);
			gen->fin_pipe[1] = -1;
		}
		if (gen->soc != INVALID_SOCKET) {
			closesocket(gen->soc);
			gen->soc = INVALID_SOCKET;
		}

		/* Shut down the children. */
		for (pid_inx = 0; pid_inx < gen->num_pids; ++pid_inx) {
			if (gen->pids[pid_inx] != 0)
				kill(gen->pids[pid_inx], SIGTERM);
		}

		/* Delete an empty generation */
		if (gen->total_helpers == 0) {
			if (!gen->bak)
				dcc_logbad(EX_SOFTWARE, "bad gen link");
			gen->bak->fwd = gen->fwd;
			if (gen->fwd)
				gen->fwd->bak = gen->bak;
			if (gen->pids)
				dcc_free(gen->pids);
			dcc_free(gen);
		}
	}
}



/* Collect work-finished tokens */
static void
collect_idle(HELPER_GEN *gen)
{
	u_char buf[32];
	int i;

	assert_helper_locked();
	if (!gen || gen->fin_pipe[0] < 0)
		return;

	i = read(gen->fin_pipe[0], buf, sizeof(buf));
	if (i < 0) {
		if (!DCC_BLOCK_ERROR()) {
			dcc_error_msg("DNSBL collect_idle read(): %s",
				      ERROR_STR());
			new_gen();
		}
	} else {
		gen->idle_helpers += i;

		if (gen->idle_helpers > gen->total_helpers) {
			dcc_error_msg("DNSBL restart gen %d;"
				      " %d idle helpers but %d total helpers",
				      gen->num,
				      gen->idle_helpers,
				      gen->total_helpers);
			new_gen();
		}
	}
}



/* Collect zombies of helpers that died from boredom or otherwise. */
void
reap_helpers(void)
{
	HELPER_GEN *gen;
	char msg[80];
	const char *msgp;
	u_char ok;
	int status;
	pid_t pid;
	int pid_inx;

	assert_helper_locked();
	if (helpers.is_child)
		dcc_logbad(EX_SOFTWARE, "bad helper child");

	gen = helpers.gens;
	if (!gen)
		return;
	collect_idle(gen);

	do {
		for (pid_inx = 0; pid_inx < gen->num_pids; ++pid_inx) {
			pid = gen->pids[pid_inx];
			if (pid == 0)
				continue;
			pid = waitpid(pid, &status, WNOHANG);
			if (pid <= 0) {
				if (pid < 0 && errno != EINTR)
					dcc_error_msg("helper waitpid(): %s",
						      ERROR_STR());
				continue;
			}
			gen->pids[pid_inx] = 0;

#ifdef WIFSTOPPED
			/* Ignore helpers being debugged. */
			if (WIFSTOPPED(status)) {
				dcc_error_msg("%ld helper stoppped", (long)pid);
				gen = helpers.gens;
				continue;
			}
#endif

			/* We cannot be certain that the helper that we reaped
			 * was idle, but it should have been. */
			--gen->idle_helpers;
			if (--gen->total_helpers < 0)
				dcc_logbad(EX_SOFTWARE,
					   "DNSBL total helpers=%d",
					   gen->total_helpers);

#if !defined(WIFEXITED) || !defined(WEXITSTATUS)
#undef WIFEXITED
#define WIFEXITED(s) 0
#undef WEXITSTATUS
#define WEXITSTATUS(s) 0
#endif

#if !defined(WTERMSIG) || !defined(WIFSIGNALED)
#undef WTERMSIG
#define WTERMSIG(s) 0
#undef WIFSIGNALED
#define WIFSIGNALED(s) 0
#endif

			if (WIFEXITED(status)) {
				if (WEXITSTATUS(status) == 0) {
					msgp = "quit";
					ok = 1;
				} else {
					snprintf(msg, sizeof(msg),
						 "quit with exit(%d)",
						 WEXITSTATUS(status));
					msgp = msg;
					ok = 0;
				}

			} else if (WIFSIGNALED(status)) {
				if (WTERMSIG(status) == SIGTERM) {
					snprintf(msg, sizeof(msg),
						 "was terminated");
					ok = 1;
				} else {
					snprintf(msg, sizeof(msg),
						 "was terminated by signal %d",
						 WTERMSIG(status));
					ok = 0;
				}
				msgp = msg;

			} else {
				snprintf(msg, sizeof(msg),
					 "quit with status %d", status);
				msgp = msg;
				ok = 0;
			}

			if (!ok)
				dcc_error_msg("DNSBL helper %ld gen %d #%d %s"
					      "  %d helpers  %d idle",
					      (long)pid, gen->num, pid_inx,
					      msgp,
					      gen->total_helpers,
					      gen->idle_helpers);
			else if (HELPERS_DEBUG())
				dcc_trace_msg("DNSBL helper %ld gen %d #%d %s,"
					      "  %d helpers  %d idle",
					      (long)pid, gen->num, pid_inx, msgp,
					      gen->total_helpers,
					      gen->idle_helpers);
		}
	} while ((gen = gen->fwd));

	clean_gens();
}



void
stop_helpers(void)
{
	HELPER_GEN *gen;
	int pid_inx;

	assert_helper_locked();
	for (gen = helpers.gens; gen; gen = gen->fwd) {
		for (pid_inx = 0; pid_inx < gen->num_pids; ++pid_inx) {
			if (gen->pids[pid_inx] != 0)
				kill(gen->pids[pid_inx], SIGTERM);
		}
	}
	usleep(1000);
	reap_helpers();
}



static void
alloc_pids(HELPER_GEN *gen, int new_num_pids)
{
	pid_t *new_pids;

	if (new_num_pids <= gen->num_pids)
		dcc_logbad(EX_SOFTWARE, "bad num_pids");

	new_pids = dcc_malloc(new_num_pids * sizeof(pid_t));
	memset(new_pids, 0, new_num_pids * sizeof(pid_t));
	if (gen->pids) {
		memcpy(new_pids, gen->pids,
		       gen->num_pids * sizeof(pid_t));
		dcc_free(gen->pids);
	}
	gen->pids = new_pids;
	gen->num_pids = new_num_pids;
}



/* Create a new gen of helpers. */
static void
new_gen(void)
{
	HELPER_GEN *gen, *old_gen;

	assert_helper_locked();

	gen = dcc_malloc(sizeof(*gen));
	memset(gen, 0, sizeof(*gen));
	gen->num = ++helpers.gen_num;
	gen->fin_pipe[0] = -1;
	gen->fin_pipe[1] = -1;
	gen->su.sa.sa_family = AF_UNSPEC;
	gen->soc = INVALID_SOCKET;

	alloc_pids(gen, 8);

	old_gen = helpers.gens;
	gen->fwd = old_gen;
	if (old_gen) {
		old_gen->bak = gen;
		--old_gen->ref_cnt;
		if (gen->ref_cnt < 0)
			dcc_logbad(EX_SOFTWARE, "bad main gen->ref_cnt=%d",
				   gen->ref_cnt);
	}
	helpers.gens = gen;
	gen->ref_cnt = 1;
}



/* The parent is finished with its helper. */
static void
help_finish(HELPER_GEN *gen, void *logp, u_char locked, u_char ok)
{
	if (!locked)
		helper_lock();

	collect_idle(gen);

	--gen->ref_cnt;
	if (gen->ref_cnt < 0)
		dcc_logbad(EX_SOFTWARE, "bad gen->ref_cnt=%d",
			   gen->ref_cnt);
	if (!ok && helpers.gens == gen) {
		if (HELPERS_DEBUG())
			thr_trace_msg(logp, "DNSBL restart; gen %d",
				      gen->num);
		new_gen();
	}

	clean_gens();
	helper_unlock();
}



static u_char
helper_clnt_soc_connect(DCC_EMSG *emsg, DCC_CLNT_CTXT *ctxt,
			const DCC_SOCKU *su)
{
	u_char result;

	dcc_ctxts_lock();
	if (!dcc_info_lock(emsg)) {
		dcc_ctxts_unlock();
		return 0;
	}
	if (su->sa.sa_family != AF_INET &&su->sa.sa_family != AF_INET6)
		dcc_logbad(EX_SOFTWARE, "bad helper socket");
	result = dcc_clnt_connect(emsg, ctxt, &ctxt->soc[0], su, AF_UNSPEC);
	dcc_clnt_soc_flush(&ctxt->soc[0]);
	if (!dcc_info_unlock(0))
		result = 0;
	dcc_ctxts_unlock();

	return result;
}



/* Create the helper socket used by helpers to receive requests */
static u_char
create_helper_soc(HELPER_GEN *gen, DCC_CLNT_CTXT *ctxt, void *logp)
{
	sa_family_t soc_family;
	DCC_CLNT_SRC *src;
	socklen_t soc_len;
	static int rcvbuf;
	static u_char rcvbuf_set = 0;
	DCC_EMSG emsg;

	assert_helper_locked();
	if (helpers.is_child)
		dcc_logbad(EX_SOFTWARE, "bad helper child");

	/* We are finished if we already have a socket. */
	if (gen->soc != INVALID_SOCKET)
		return 1;

	/* We want to create a new socket with the same choice of
	 * IPv4 or IPv6 as the DCC client context's socket. */
	soc_family = ctxt->soc[0].loc.sa.sa_family;
	if (soc_family == AF_UNSPEC)
		soc_family = AF_INET;
	src = get_clnt_src(ctxt, soc_family);
	if (src != 0) {
		dcc_ip2su(&gen->su, &src->ip);
	} else {
		dcc_mk_loop_su(&gen->su, soc_family, 0);
	}
	if (!udp_create(&emsg, &gen->soc, &gen->su, 0, 0, 0)) {
		thr_error_msg(logp, "DNSBL udp_create(): %s", emsg.c);
		new_gen();
		return 0;
	}
	if (!set_rcvbuf(&emsg, gen->soc, &gen->su, &rcvbuf, &rcvbuf_set)) {
		thr_error_msg(logp, "DNSBL %s", emsg.c);
		new_gen();
		return 0;
	}
	soc_len = sizeof(gen->su);
	if (0 > getsockname(gen->soc, &gen->su.sa, &soc_len)) {
		thr_error_msg(logp, "DNSBL helper getsockname(%d): %s",
			      gen->soc, ERROR_STR());
		new_gen();
		return 0;
	}
	dcc_su2str(gen->su_name, sizeof(gen->su_name), &gen->su);

	if (HELPERS_DEBUG())
		dcc_trace_msg("DNSBL gen %d starting with %s",
			      gen->num, gen->su_name);
	return 1;
}



static u_char
open_pipe(int fds[2], void *logp)
{
	if (fds[0] >= 0)
		return 1;

	if (0 > pipe(fds)) {
		fds[0] = -1;
		fds[1] = -1;
		thr_error_msg(logp, "DNSBL helper pipe(): %s",
			      ERROR_STR());
		new_gen();
		return 0;
	}

	if (-1 == fcntl(fds[0], F_SETFL,
			fcntl(fds[0], F_GETFL, 0) | O_NONBLOCK)) {
		thr_error_msg(logp, "DNSBL helper fcntl(O_NONBLOCK): %s",
			      ERROR_STR());
		new_gen();
		return 0;
	}

	return 1;
}



/* Start a new helper. */
static u_char
new_helper(HELPER_GEN *gen, DCC_CLNT_CTXT *ctxt, void *logp,
	   const char *id)
{
	pid_t pid;
	char arg_buf[sizeof("set:")+sizeof(HELPER_PAT)+9+9+9];
	char trace_buf[200];
	char *bufp;
	int pid_inx, buf_len, i, j;

	assert_helper_locked();
	if (helpers.is_child)
		dcc_logbad(EX_SOFTWARE, "bad helper child");

	/* Give the helper child a pipe on which to signal the end
	 * of each job, even long after the original mail message has
	 * been handled and the parent thread is gone. */
	if (!open_pipe(gen->fin_pipe, logp))
		return 0;

	if (!create_helper_soc(gen, ctxt, logp))
		return 0;

	reap_helpers();
	for (pid_inx = 0; ; ++pid_inx) {
		if (pid_inx >= gen->num_pids) {
			alloc_pids(gen, gen->num_pids * 2);
			pid_inx = 0;
		}
		if (gen->pids[pid_inx] == 0)
			break;
	}

	fflush(stdout);
	fflush(stderr);
	pid = fork();
	if (pid < 0) {
		thr_error_msg(logp, "%s DNSBL helper fork(): %s",
			      id, ERROR_STR());
		return 0;
	}

	if (pid != 0) {
		/* this is the parent */
		gen->pids[pid_inx] = pid;
		++gen->total_helpers;
		++gen->idle_helpers;
		return 1;
	}

	/* This is the child. */

	dcc_rel_priv();
	dcc_clean_stdio();

	close(gen->fin_pipe[0]);

	snprintf(arg_buf, sizeof(arg_buf), "set:"HELPER_PAT,
		 gen->soc, gen->fin_pipe[1], gen->num, pid_inx);
	helper_save_arg("-B", arg_buf);
	helpers.argv[0] = dnsbl_progpath.c;
	buf_len = sizeof(trace_buf);
	bufp = trace_buf;
	for (i = 0; i < helpers.argc && buf_len > 2; ++i) {
		j = snprintf(bufp, buf_len, "%s ", helpers.argv[i]);
		buf_len -= j;
		bufp += j;
	}
	if (HELPERS_DEBUG()) {
		clnt_threaded = 0;
		dcc_trace_msg("DNSBL helper gen %d #%d exec %s",
			      gen->num, pid_inx, trace_buf);
	}

	execv(helpers.argv[0], (char * const *)helpers.argv);
	/* This process should continue at helper_child() via dnsbl.c */

	dcc_logbad(EX_UNAVAILABLE, "execv(%s): %s",
		   trace_buf, ERROR_STR());
	exit(1);
}



static u_char helper_alarm_hit;
static void
helper_alarm(int s DCC_UNUSED)
{
	helper_alarm_hit = 1;
}



static void
send_idle(int fin_fd)
{
	int i;

	i = write(fin_fd, "x", 1);
	if (i == 1)
		return;

	if (i < 0) {
		dcc_error_msg("DNSBL helper send_idle write(): %s",
			      ERROR_STR());
	} else if (i != 1) {
		dcc_error_msg("DNSBL helper send_idle write()=%d",
			      i);
	}
	exit(1);
}



/* helpers start here via fork()/exec() in the parent  */
void DCC_NORET
helper_child(int soc, int fin_fd, int gen, int helper_num)
{
	sigset_t sigs;
	DCC_SOCKU su;
	socklen_t su_len;
	char su_name[DCC_SU2STR_SIZE];
	DNSBL_REQ req;
	int req_len;
	DNSBL_RESP resp;
	DCC_SOCKU req_su;
	struct timeval now;
	int secs, i;

	helpers.is_child = 1;

	su_len = sizeof(su);
	if (0 > getsockname(soc, &su.sa, &su_len))
		dcc_logbad(EX_IOERR, "getsockname(%d): %s",
			   soc, ERROR_STR());
	dcc_su2str(su_name, sizeof(su_name), &su);
	if (HELPERS_DEBUG())
		dcc_trace_msg("helper gen %d #%d starting on %s",
			      gen, helper_num, su_name);

	/* this process inherits via exec() from dccm or dccifd odd signal
	 * blocking from some pthreads implementations including FreeBSD 5.* */
	signal(SIGHUP, SIG_DFL);
	signal(SIGINT, SIG_DFL);
	signal(SIGTERM, SIG_DFL);
	signal(SIGPIPE, SIG_IGN);
	sigemptyset(&sigs);
	sigaddset(&sigs, SIGHUP);
	sigaddset(&sigs, SIGINT);
	sigaddset(&sigs, SIGTERM);
	sigaddset(&sigs, SIGALRM);
	sigprocmask(SIG_UNBLOCK, &sigs, 0);

	helper_alarm_hit = 0;
	for (;;) {
		/* Use SIGALRM to watch for excessive idle time. */
		signal(SIGALRM, helper_alarm);
#ifdef HAVE_SIGINTERRUPT
		siginterrupt(SIGALRM, 1);
#endif
		secs = HELPER_IDLE_STOP_SECS / (helper_num + 1);
		if (secs < 60)
			secs = 60;
		alarm(secs);
		for (;;) {
			if (helper_alarm_hit) {
				if (HELPERS_DEBUG())
					dcc_trace_msg("idle exit by #%d on %s",
						      helper_num, su_name);
				exit(0);
			}

			su_len = sizeof(req_su);
			req_len = recvfrom(soc, &req, ISZ(req), 0,
					   &req_su.sa, &su_len);
			if (req_len == 0)
				dcc_logbad(EX_IOERR, "recvfrom()=0");
			if (req_len < 0) {
				if (errno != EINTR && !DCC_BLOCK_ERROR())
					dcc_logbad(EX_IOERR, "recvfrom(): %s",
						   ERROR_STR());
				continue;
			}

			/* We might get stray UDP packets. */
			if (!DCC_SUnP_EQ(&su, &req_su)) {
				if (HELPERS_DEBUG())
					dcc_trace_msg("DNSBL helper"
						    " request from"
						    " %s instead of %s",
						    dcc_su2str_err(&req_su),
						    su_name);
				continue;
			}

			if (req_len != sizeof(DNSBL_REQ)) {
				if (HELPERS_DEBUG())
					dcc_trace_msg("DNSBL helper"
						      " recvfrom(%s)=%d"
						      " instead of %d",
						      dcc_su2str_err(&req_su),
						      req_len,
						      ISZ(DNSBL_REQ));
				continue;
			}

			if (req.hdr.magic != HELPER_MAGIC_REQ
			    || req.hdr.version != HELPER_VERSION) {
				if (HELPERS_DEBUG())
					dcc_trace_msg("DNSBL helper"
						      " recvfrom from %s"
						      " has bad magic=%#08x",
						      dcc_su2str_err(&req_su),
						      req.hdr.magic);
				continue;
			}
			break;
		}
		alarm(0);

		gettimeofday(&now, 0);

		/* do not bother working if it is already too late to answer,
		 * perhaps because a previous helper died */
		i = tv_diff2us(&now, &req.hdr.start);
		if (i >= req.hdr.avail_us) {
			if (HELPERS_DEBUG())
				dcc_trace_msg("%s DNSBL helper"
					      " already too late to start;"
					      " used %.1f of %.1f seconds",
					      req.hdr.id, i / (DCC_US*1.0),
					      req.hdr.avail_us / (DCC_US*1.0));
			send_idle(fin_fd);
			continue;
		}

		memset(&resp, 0, sizeof(resp));
		resp.hdr.magic = HELPER_MAGIC_RESP;
		resp.hdr.version = HELPER_VERSION;
		resp.hdr.sn = req.hdr.sn;

		/* do the work and send an answer if we have one */
		if (!dnsbl_helper_work(&req, &resp)) {
			send_idle(fin_fd);
			continue;
		}

		/* do not answer if it is too late */
		gettimeofday(&now, 0);
		i = tv_diff2us(&now, &req.hdr.start);
		if (i > (req.hdr.avail_us + DCC_US/2)) {
			if (HELPERS_DEBUG())
				dcc_trace_msg("%s DNSBL helper"
					      " too late to answer;"
					      " used %.1f of %.1f seconds",
					      req.hdr.id, i / (DCC_US*1.0),
					      req.hdr.avail_us / (DCC_US*1.0));
			send_idle(fin_fd);
			continue;
		}

		/* Send the answer. */
		i = sendto(soc, &resp, sizeof(resp), 0,
			   &req_su.sa, DCC_SU_LEN(&req_su));
		if (i != sizeof(resp) && helpers.debug) {
			if (i < 0)
				dcc_error_msg("%s helper sendto(%s): %s",
					      req.hdr.id,
					      dcc_su2str_err(&req_su),
					      ERROR_STR());
			else
				dcc_error_msg("%s helper sendto(%s)=%d",
					      req.hdr.id,
					      dcc_su2str_err(&req_su), i);
		}
		send_idle(fin_fd);
	}
}



/* ask a helper to do some filtering */
u_char					/* 1=got an answer */
ask_helper(DNSBL_WORK *dlw,
	   HELPER_REQ_HDR *req,		/* request sent to helper */
	   int req_len,
	   HELPER_RESP_HDR *resp,	/* put answer here */
	   int resp_len)
{
	DCC_CLNT_CTXT *ctxt;
	time_t avail_us;		/* spend at most this much time */
	DCC_EMSG emsg;
	HELPER_GEN *gen;
	socklen_t su_len;
	DCC_SOCKU recv_su;
	char sustr[DCC_SU2STR_SIZE];
	char sustr2[DCC_SU2STR_SIZE];
	struct timeval now;
	time_t us;
	DCC_POLLFD pollfd;
	int serrno;
	int i;

	if (helpers.is_child)
		dcc_logbad(EX_SOFTWARE, "bad helper child");

	avail_us = dlw->url_us;
	emsg.c[0] = '\0';

	/* keep the lock until we have sent our request and wake-up call
	 * to ensure that some other thread does not shut down all of
	 * the helpers. */
	helper_lock();
	gettimeofday(&now, 0);
	gen = helpers.gens;
	++gen->ref_cnt;

	req->sn = ++helpers.sn;

	ctxt = dlw->dcc_ctxt;
	if (gen->soc != INVALID_SOCKET
	    && (gen->su.sa.sa_family != ctxt->soc[0].loc.sa.sa_family
		|| (0 != get_clnt_src(ctxt, ctxt->soc[0].loc.sa.sa_family)
		    && !DCC_SUnP_EQ(&ctxt->soc[0].loc, &gen->su)))) {
		/* Restart all of the helpers if our source IP address has
		 * changed.
		 * That happens when the client context socket switches between
		 * between IPv4 and IPv6 or when the client source IP address is
		 * changed. */
		if (HELPERS_DEBUG())
			thr_trace_msg(dlw->log_ctxt,
				      "%s DNSBL IP source change", req->id);
		new_gen();
		--gen->ref_cnt;
		gen = helpers.gens;
		++gen->ref_cnt;

	} else if (DCC_IS_TIME(now.tv_sec, gen->idle_restart,
			HELPER_IDLE_RESTART)
	    && gen->idle_helpers > 0) {
		/* If it has been a long time since we used a helper,
		 * then the last of them might be about to die of boredom.
		 * Fix that race by restarting all of them. */
		if (HELPERS_DEBUG())
			thr_trace_msg(dlw->log_ctxt,
				      "%s DNSBL idle restart", req->id);
		new_gen();
		--gen->ref_cnt;
		gen = helpers.gens;
		++gen->ref_cnt;
	}

	/* Start another helper if necessary,
	 * after collecting job-finished tokens from helpers that took
	 * too much time. */
	if (gen->idle_helpers <= 0)
		collect_idle(gen);
	if (gen->idle_helpers <= 0) {
		if (gen->total_helpers >= helpers.max_helpers) {
			thr_error_msg(dlw->log_ctxt,
				      "%s DNSBL %d idle  %d total helpers",
				      req->id,
				      gen->idle_helpers, gen->total_helpers);
		} else if (!new_helper(gen, ctxt,
				       dlw->log_ctxt, req->id)) {
			help_finish(gen, dlw->log_ctxt, 1, 0);
			return 0;
		}
	}

	/* Connect the client context socket to the helper's socket. */
	if (!DCC_SU_EQ(&ctxt->soc[0].rem, &gen->su)
	    && !helper_clnt_soc_connect(&emsg, ctxt, &gen->su)) {
		thr_error_msg(dlw->log_ctxt,
			      "DNSBL soc_connect(): %s", emsg.c);
		help_finish(gen, dlw->log_ctxt, 1, 0);
		return 0;
	}

	/* The resolutions of the limits on the resolver timeout is seconds,
	 * so even on systems where the timeout limits work,
	 * the helper might delay a second or two.
	 * To keep the count of idle helpers as accurate as possible, always
	 * wait at least 1 second for an answer. */
	req->avail_us = avail_us;
	avail_us += DCC_US;
	gettimeofday(&now, 0);
	req->start = now;
	req->magic = HELPER_MAGIC_REQ;
	req->version = HELPER_VERSION;

	/* Send the request. */
	i = send(ctxt->soc[0].s, req, req_len, 0);
	if (i != req_len) {
		if (i < 0) {
			serrno = errno;
			thr_error_msg(dlw->log_ctxt,
				      "%s DNSBL send(to %s): %s",
				      req->id, dcc_su2str(sustr, sizeof(sustr),
							&gen->su),
				      ERROR_STR1(serrno));
		} else {
			thr_error_msg(dlw->log_ctxt,
				      "%s DNSBL send(to %s)=%d != %d",
				      req->id, dcc_su2str(sustr, sizeof(sustr),
							&gen->su),
				      i, req_len);
		}
		help_finish(gen, dlw->log_ctxt, 1, 0);
		return 0;
	}

	--gen->idle_helpers;
	helper_unlock();

	/* Wait for the answer. */
	for (;;) {
		us = avail_us - tv_diff2us(&now, &req->start);
		if (us < 0)
			us = 0;
		pollfd.fd = ctxt->soc[0].s;
		i = select_poll(&emsg, &pollfd, 1, 1, us);
		if (i < 0) {
			thr_error_msg(dlw->log_ctxt, "%s DNSBL %s",
				      req->id, emsg.c);
			help_finish(gen, dlw->log_ctxt, 0, 0);
			return 0;
		}
		gettimeofday(&now, 0);

		if (i == 0) {
			if (HELPERS_DEBUG())
				thr_trace_msg(dlw->log_ctxt,
					      "%s DNSBL"
					      " no helper answer for %s"
					      " after %1.f sec",
					      req->id, dlw->tgt.dom.c,
					      tv_diff2us(&now, &req->start)
					      / (DCC_US*1.0));
			help_finish(gen, dlw->log_ctxt, 0, 1);
			return 0;
		}


		su_len = sizeof(recv_su);
		i = recvfrom(ctxt->soc[0].s, resp, resp_len,
			     0, &recv_su.sa, &su_len);
		if (i < 0) {
			if (DCC_BLOCK_ERROR())
				continue;
			thr_error_msg(dlw->log_ctxt, "%s DNSBL recvfrom(): %s",
				      req->id, ERROR_STR());
			help_finish(gen, dlw->log_ctxt, 0, 0);
			return 0;
		}
		/* because we are using UDP, we might get stray packets */
		if (i != resp_len) {
			if (HELPERS_DEBUG())
				thr_error_msg(dlw->log_ctxt,
					      "%s DNSBL recvfrom(%s)=%d",
					      req->id,
					      dcc_su2str(sustr, sizeof(sustr),
							&recv_su),
					      i);
			continue;
		}
		if (!DCC_SUnP_EQ(&gen->su, &recv_su)) {
			if (HELPERS_DEBUG())
				thr_trace_msg(dlw->log_ctxt, "%s DNSBL"
					      " result from %s instead of %s",
					      req->id,
					      dcc_su2str(sustr, sizeof(sustr),
							&recv_su),
					      dcc_su2str(sustr2, sizeof(sustr2),
							&gen->su));
			continue;
		}
		if (resp->magic != HELPER_MAGIC_RESP
		    || resp->version != HELPER_VERSION
		    || resp->sn != req->sn) {
			if (HELPERS_DEBUG())
				thr_trace_msg(dlw->log_ctxt, "%s DNSBL"
					      " recvfrom(%s) magic=%#08x sn=%d",
					      req->id,
					      dcc_su2str(sustr, sizeof(sustr),
							&recv_su),
					      resp->magic, resp->sn);
			continue;
		}

		gen->idle_restart = now.tv_sec + HELPER_IDLE_RESTART;
		if (helpers.debug > 2)
			thr_trace_msg(dlw->log_ctxt,"%s DNSBL answer from"
				      " %s for %s",
				      req->id, dcc_su2str(sustr, sizeof(sustr),
							&recv_su),
				      dlw->tgt.dom.c);
		help_finish(gen, dlw->log_ctxt, 0, 1);
		return 1;
	}
}
#endif /* HAVE_HELPERS */
