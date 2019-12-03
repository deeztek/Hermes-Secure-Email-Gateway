/* Distributed Checksum Clearinghouse
 *
 * threaded version of client locking
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
 * Rhyolite Software DCC 2.3.167-1.83 $Revision$
 */

#include "cmn_defs.h"


/* many POSIX thread implementations have unexpected side effects on
 * ordinary system calls, so don't use the threaded version unless
 * necessary */

u_char clnt_threaded = 1;


/* protect the links among contexts and the miscellaneous global
 * variables in the DCC client library */
static pthread_mutex_t ctxts_mutex;
#ifdef DCC_DEBUG_LOCKS
static pthread_t ctxts_owner;
#endif

/* make syslog() thread-safe */
static pthread_mutex_t syslog_mutex;
static u_char syslog_threaded;

#ifdef DCC_DEBUG_HEAP
static pthread_mutex_t malloc_mutex;
static u_char malloc_threaded;
#endif

/* make gethostbyname() thread-safe */
static pthread_mutex_t host_mutex;

static pthread_t clnt_resolve_tid;
static pthread_cond_t clnt_resolve_cond;
static u_char clnt_resolve_stopping;

/* The threaded DNS blacklist support uses fork() to create helper processes
 * to wait for the typical single-threaded DNS resolver library. */
static pthread_mutex_t helper_mutex;
static pthread_t helper_owner;

/* create user logs in a burst while holding a lock
 *	this reduces the total number of file descriptors needed
 *	at a cost of stopping everything while copying from the main
 *	log file to the per-user log files */
pthread_mutex_t user_log_mutex;
pthread_t user_log_owner;


/* this is used only in the threaded DCC clients */
void
clnt_sigs_off(sigset_t *sigsold)
{
	sigset_t sigsnew;
	int error;

	sigemptyset(&sigsnew);
	sigaddset(&sigsnew, SIGHUP);
	sigaddset(&sigsnew, SIGINT);
	sigaddset(&sigsnew, SIGTERM);
	sigaddset(&sigsnew, SIGALRM);
	error = pthread_sigmask(SIG_BLOCK, &sigsnew, sigsold);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_sigmask(): %s",
			   ERROR_STR1(error));
}



void
dcc_ctxts_lock(void)
{
	int error;

#ifdef DCC_DEBUG_LOCKS
	if (ctxts_owner == pthread_self())
		dcc_logbad(EX_SOFTWARE, "already have ctxts lock");
#endif

	error = pthread_mutex_lock(&ctxts_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_lock(ctxts): %s",
			   ERROR_STR1(error));
#ifdef DCC_DEBUG_LOCKS
	ctxts_owner = pthread_self();
#endif
}



void
dcc_ctxts_unlock(void)
{
	int error;

#ifdef DCC_DEBUG_LOCKS
	ctxts_owner = 0;
#endif
	error = pthread_mutex_unlock(&ctxts_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_unlock(ctxts): %s",
			   ERROR_STR1(error));
}



#ifdef DCC_DEBUG_LOCKS
void
assert_ctxts_locked(void)
{
	if (ctxts_owner != pthread_self())
		dcc_logbad(EX_SOFTWARE, "don't have ctxts lock");
}



void
assert_ctxts_unlocked(void)
{
	if (ctxts_owner == pthread_self())
		dcc_logbad(EX_SOFTWARE, "have ctxts lock");
}
#endif



void
dcc_syslog_lock(void)
{
	int error;

	if (!clnt_threaded || !syslog_threaded)
		return;
	error = pthread_mutex_lock(&syslog_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_lock(syslog): %s",
			   ERROR_STR1(error));
}



void
dcc_syslog_unlock(void)
{
	int error;

	if (!clnt_threaded || !syslog_threaded)
		return;
	error = pthread_mutex_unlock(&syslog_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_unlock(syslog): %s",
			   ERROR_STR1(error));
}



/* gethostbyname() etc. are usually not reentrant */
u_char dcc_host_locked = 1;

/* do not worry about locking gethostbyname() until the locks have
 * been initialized */
static u_char dcc_host_threaded = 0;

/* This function is mentioned in dccifd/dccif-test/dccif-test.c
 *	and so cannot change lightly. */
void
dcc_host_lock(void)
{
	int error;

	if (!dcc_host_threaded)
		return;

	error = pthread_mutex_lock(&host_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_lock(host): %s",
			   ERROR_STR1(error));
	dcc_host_locked = 1;
}



/* This function is mentioned in dccifd/dccif-test/dccif-test.c
 *	and so cannot change lightly. */
void
dcc_host_unlock(void)
{
	int error;

	if (!dcc_host_threaded)
		return;

	dcc_host_locked = 0;
	error = pthread_mutex_unlock(&host_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_unlock(host): %s",
			   ERROR_STR1(error));
}



#ifdef DCC_DEBUG_HEAP
void
dcc_malloc_lock(void)
{
	int error;

	if (!malloc_threaded)		/* no locking until locks created */
		return;
	error = pthread_mutex_lock(&malloc_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_lock(malloc): %s",
			   ERROR_STR1(error));
}


void
dcc_malloc_unlock(void)
{
	int error;

	if (!malloc_threaded)		/* no locking until locks created */
		return;
	error = pthread_mutex_unlock(&malloc_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_unlock(malloc): %s",
			   ERROR_STR1(error));
}
#endif /* DCC_DEBUG_HEAP */



#ifndef HAVE_LOCALTIME_R
/* make localtime() thread safe */
static pthread_mutex_t localtime_mutex;
static u_char localtime_threaded;

void
dcc_localtime_lock(void)
{
	int error;

	if (!localtime_threaded)
		return;
	error = pthread_mutex_lock(&localtime_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_lock(localtime): %s",
			   ERROR_STR1(error));
}



void
dcc_localtime_unlock(void)
{
	int error;

	if (!localtime_threaded)
		return;
	error = pthread_mutex_unlock(&localtime_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_unlock(localtime): %s",
			   ERROR_STR1(error));
}
#endif /* HAVE_LOCALTIME_R */



const char *main_white_nm;
const char *mapfile_nm = DCC_MAP_NM_DEF;

/* resolve things */
static DCC_CLNT_CTXT *
resolve_sub(DCC_CLNT_CTXT *ctxt,	/* 0=allocate and initialize */
	    WF *wf, WF *tmp_wf)
{
	DCC_EMSG emsg;

	if (!ctxt) {
		wf_init(wf, 0);
		if (main_white_nm)
			dcc_new_white_nm(&emsg, wf, main_white_nm);

		emsg.c[0] = '\0';
		if (!dcc_map_info(&emsg, mapfile_nm, -1))
			dcc_logbad(EX_USAGE, "%s", emsg.c);

		ctxt = dcc_alloc_ctxt();
	}

	if (wf->ascii_nm.c[0] != '\0') {
		if (clnt_resolve_stopping)
			return ctxt;
		dcc_ctxts_unlock();
		switch (wf_rdy(&emsg, wf, tmp_wf)) {
		case WHITE_OK:
		case WHITE_NOFILE:
		case WHITE_SILENT:
			break;
		case WHITE_CONTINUE:
		case WHITE_COMPLAIN:
			dcc_error_msg("%s", emsg.c);
			break;
		}
		dcc_ctxts_lock();

		/* Tell the other threads that the whitelist hash table
		 * in the disk file has changed.
		 * This kludge lets this thread use its own
		 * wf structure without hogging the lock on cmn_wf. */
		if (wf->closed) {
			wf->closed = 0;
			cmn_wf.need_reopen = 1;
		}
	}

	return ctxt;
}



static void * DCC_NORET
clnt_resolve_thread(void *arg DCC_UNUSED)
{
	WF wf, tmp_wf;
	DCC_CLNT_CTXT *ctxt;
#ifndef DCC_WIN32
	struct stat sb;
#endif
	DCC_EMSG emsg;
	int error;

	/* let the thread in charge of signals deal with them */
	clnt_sigs_off(0);

	ctxt = 0;
	dcc_ctxts_lock();
	for (;;) {
		if (clnt_resolve_stopping) {
			if (ctxt) {
				dcc_rel_ctxt(ctxt);
				ctxt = 0;
			}
			dcc_ctxts_unlock();
			pthread_exit(0);
		}

#ifndef DCC_WIN32
		/* Notice if the file has been unlinked and try to reopen it.
		 * Open files cannot be unlinked in WIN32, which lets us not
		 * worry about whether WIN32 files have device and i-numbers */
		if (ctxt && !(dcc_clnt_info->fgs & DCC_INFO_FG_TMP)) {
			if (!dcc_ck_private(0, &sb, dcc_info_nm.c, -1)
			    || sb.st_dev != dcc_info_sb.st_dev
			    || sb.st_ino != dcc_info_sb.st_ino) {
				dcc_error_msg("%s disappeared",
					      dcc_info_nm.c);
				if (ctxt) {
					dcc_rel_ctxt(ctxt);
					ctxt = 0;
				}
				dcc_unmap_close_info(0);
			}
		}
#endif

		ctxt = resolve_sub(ctxt, &wf, &tmp_wf);

		if (clnt_resolve_stopping) {
			if (ctxt) {
				dcc_rel_ctxt(ctxt);
				ctxt = 0;
			}
			dcc_ctxts_unlock();
			pthread_exit(0);
		}
		emsg.c[0] = '\0';
		if (!dcc_clnt_rdy(&emsg, ctxt, DCC_CLNT_FG_NO_FAIL))
			dcc_error_msg("%s", emsg.c);
		else if (!dcc_info_unlock(&emsg))
			dcc_logbad(emsg_ex_code(&emsg), "%s", emsg.c);

		if (grey_on) {
			if (clnt_resolve_stopping) {
				if (ctxt) {
					dcc_rel_ctxt(ctxt);
					ctxt = 0;
				}
				dcc_ctxts_unlock();
				pthread_exit(0);
			}
			emsg.c[0] = '\0';
			if (!dcc_clnt_rdy(&emsg, ctxt, (DCC_CLNT_FG_GREY
						       | DCC_CLNT_FG_NO_FAIL)))
				dcc_error_msg("%s", emsg.c);
			else if (!dcc_info_unlock(&emsg))
				dcc_logbad(emsg_ex_code(&emsg), "%s", emsg.c);
		}

#ifdef DCC_DEBUG_LOCKS
		ctxts_owner = 0;
#endif
		error = pthread_cond_wait(&clnt_resolve_cond, &ctxts_mutex);
		if (error != 0)
			dcc_logbad(EX_SOFTWARE,
				   "pthread_cond_wait(resolve): %s",
				   ERROR_STR1(error));
#ifdef DCC_DEBUG_LOCKS
		ctxts_owner = pthread_self();
#endif
	}
}



u_char					/* 1=awoke the resolver thread */
dcc_clnt_wake_resolve(void)
{
	int error;

	/* we cannot awaken ourself or awaken the thread before it starts */
	if (clnt_resolve_tid == 0
	    || pthread_equal(pthread_self(), clnt_resolve_tid))
		return 0;

	error = pthread_cond_signal(&clnt_resolve_cond);
	if (error != 0)
		dcc_logbad(EX_SOFTWARE, "pthread_cond_signal(resolve): %s",
			   ERROR_STR1(error));
	return 1;
}



void
dcc_clnt_stop_resolve(void)
{
	if (clnt_resolve_stopping)
		return;
	clnt_resolve_stopping = 1;
	if (pthread_equal(pthread_self(), clnt_resolve_tid))
		return;
	pthread_cond_signal(&clnt_resolve_cond);
}



/* some pthreads implementations (e.g. AIX) don't like static
 * initializations */
static void
dcc_mutex_init(void *mutex, const char *nm)
{
	int error = pthread_mutex_init(mutex, 0);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_init(%s): %s",
			   nm, ERROR_STR1(error));
}



static pthread_mutex_t work_mutex;
static pthread_t cwf_owner;

void
lock_work(void)
{
	int result = pthread_mutex_lock(&work_mutex);
	if (result)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_lock(work_free): %s",
			   ERROR_STR1(result));
}



void
unlock_work(void)
{
	int result = pthread_mutex_unlock(&work_mutex);
	if (result)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_unlock(work_free): %s",
			   ERROR_STR1(result));
}



/* lock all CWF structures as well as the cmn_wf structure */
static pthread_mutex_t cwf_mutex;

void
lock_wf(void)
{
	int error = pthread_mutex_lock(&cwf_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_lock(cwf): %s",
			   ERROR_STR1(error));
	cwf_owner = pthread_self();
}



void
unlock_wf(void)
{
	int error;
	cwf_owner = 0;
	error = pthread_mutex_unlock(&cwf_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_unlock(cwf): %s",
			   ERROR_STR1(error));
}



#ifdef DCC_DEBUG_LOCKS
void
assert_cwf_locked(void)
{
	if (cwf_owner != pthread_self())
		dcc_logbad(EX_SOFTWARE, "don't have cwf lock");
}
#endif



void
dcc_clnt_thread_init(void)
{
	DCC_CLNT_CTXT *ctxt;
	int error;

	/* Some pthreads implementations (e.g. AIX) don't like static
	 * POSIX thread initializations */

	dcc_mutex_init(&ctxts_mutex, "ctxt");
	dcc_mutex_init(&syslog_mutex, "syslog");
	syslog_threaded = 1;
#ifdef DCC_DEBUG_HEAP
	dcc_mutex_init(&malloc_mutex, "heap");
	malloc_threaded = 1;
#endif
#ifndef HAVE_LOCALTIME_R
	dcc_mutex_init(&localtime_mutex, "localtime");
	localtime_threaded = 1;
#endif
	dcc_mutex_init(&host_mutex, "host");
	dcc_host_threaded = 1;
	dcc_host_locked = 0;

	dcc_mutex_init(&user_log_mutex, "user_log");

	dcc_mutex_init(&work_mutex, "work_mutex");
	dcc_mutex_init(&cwf_mutex, "cwf_mutex");

	/* prevent race between resolver thread and other threads to
	 * initialize things by doing it before starting the thread */
	lock_wf();
	dcc_ctxts_lock();
	ctxt = resolve_sub(0, &cmn_wf, &cmn_tmp_wf);
	dcc_rel_ctxt(ctxt);
	ctxt = 0;
	dcc_ctxts_unlock();
	unlock_wf();

	error = pthread_cond_init(&clnt_resolve_cond, 0);
	if (error)
		dcc_logbad(EX_SOFTWARE, "phtread_cond_init(resolve): %s",
			   ERROR_STR1(error));
	error = pthread_create(&clnt_resolve_tid, 0, clnt_resolve_thread, 0);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_create(resolve): %s",
			   ERROR_STR1(error));
	error = pthread_detach(clnt_resolve_tid);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_detach(resolve): %s",
			   ERROR_STR1(error));
}



/* protect DNS blacklist helper channels */
u_char
helper_lock_init(void)
{
	dcc_mutex_init(&helper_mutex, "helper");
	return 1;
}



void
helper_lock(void)
{
	int error;

	assert_helper_unlocked();
	error =  pthread_mutex_lock(&helper_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_lock(helper): %s",
			   ERROR_STR1(error));
	helper_owner = pthread_self();
}



void
helper_unlock(void)
{
	int error;

	assert_helper_locked();
	helper_owner = 0;
	error = pthread_mutex_unlock(&helper_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_unlock(helper): %s",
			   ERROR_STR1(error));
}



#ifdef DCC_DEBUG_LOCKS
void
assert_helper_locked(void)
{
	if (helper_owner != pthread_self())
		dcc_logbad(EX_SOFTWARE, "don't have helper lock");
}



void
assert_helper_unlocked(void)
{
	if (helper_owner == pthread_self())
		dcc_logbad(EX_SOFTWARE, "have helper lock");
}
#endif
