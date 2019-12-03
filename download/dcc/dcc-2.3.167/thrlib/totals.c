/* Distributed Checksum Clearinghouse
 *
 * count work
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
 * Rhyolite Software DCC 2.3.167-1.22 $Revision$
 */


#include "cmn_defs.h"
#include "helper.h"
#include <signal.h>


TOTALS totals;
static time_t signaled;
static pthread_t totals_tid;
static u_char stopping;

static void totals_msg(void);
static void totals_msg_signal(int);
static void *totals_msg_thread(void *);



static void
totals_msg_signal(int sig DCC_UNUSED)
{
	time_t now;

	signal(SIGUSR1, totals_msg_signal);

	/* ignore signals faster than 60 seconds */
	now = time(0);
	if (!signaled || now > signaled+60) {
		signaled = now;
		totals.msg_next = signaled;
	}
}



static void * DCC_NORET
totals_msg_thread(void *ign DCC_UNUSED)
{
	time_t now, next, last_clean;
	struct tm tm, signaled_tm;
	int secs;

	clnt_sigs_off(0);

	last_clean = time(0);
	for (;;) {
		if (stopping)
			pthread_exit(0);

		helper_lock();
		reap_helpers();
		helper_unlock();

		now = time(0);
		next = totals.msg_next;
		if (now >= next && next != 0) {
			totals_msg();
			next = 0;
		}

		if (!next) {
			/* make a note to announce totals at midnight
			 * or 24 hours after the signal */
			dcc_localtime(totals.msg_prev, &tm);
			if (signaled != 0) {
				dcc_localtime(signaled, &signaled_tm);
				tm.tm_hour = signaled_tm.tm_hour;
				tm.tm_min = signaled_tm.tm_min;
			} else {
				tm.tm_hour = 0;
				tm.tm_min = 0;
			}
			tm.tm_sec = 0;
			++tm.tm_mday;
			next = mktime(&tm);
			if (next == -1) {
				dcc_error_msg("mktime() failed");
				next = now + 24*60*60;
			}
			totals.msg_next = next;

		}

		/* tell dccifd or dccm to close old sockets to recover
		 * from dictionary attacks */
		if (last_clean > now || last_clean+5*60 < now) {
			last_clean = now;
			work_clean();
		}

		secs = next - now;
		if (secs > 0) {
			/* reap helpers regularly */
			if (secs > HELPER_AUTO_REAP)
				secs = HELPER_AUTO_REAP;
			sleep(secs);
		}
	}
}



void
totals_init(void)
{
	int i;

	signal(SIGUSR1, totals_msg_signal);
	totals.msg_prev = time(0);

	i = pthread_create(&totals_tid, 0, totals_msg_thread, 0);
	if (i)
		dcc_logbad(EX_SOFTWARE, "pthread_create(totals msg): %s",
			   ERROR_STR1(i));
	i = pthread_detach(totals_tid);
	if (i)
		dcc_error_msg("pthread_detach(totals msg): %s",
			      ERROR_STR1(i));
}



void
totals_stop(void)
{
	stopping = 1;

	helper_lock();
	stop_helpers();
	helper_unlock();

	totals_msg();
}



/* brag about our accomplishments */
static void
totals_msg(void)
{
	time_t now;
	char tbuf[20];
	char gbuf[80];
	sigset_t sigsold;
	int error;

	clnt_sigs_off(&sigsold);

	lock_work();
	now = time(0);

	if (grey_on)
		snprintf(gbuf, sizeof(gbuf),
			 " greylist embargoed %d messages to %d targets;",
			 totals.msgs_embargoed, totals.tgts_embargoed);
	else
		gbuf[0] = '\0';

	dcc_trace_msg(DCC_VERSION
		      "%s detected %d spam, ignored for %d, rejected for %d,"
		      " and discarded for %d targets among"
		      " %d total messages for %d targets since %s",
		      gbuf,
		      totals.msgs_spam, totals.tgts_ignored,
		      totals.tgts_rejected, totals.tgts_discarded,
		      totals.msgs, totals.tgts,
		      dcc_time2str(tbuf, sizeof(tbuf), "%x %X",
				   totals.msg_prev));

	memset(&totals, 0, sizeof(totals));
	totals.msg_prev = now;
	unlock_work();

	error = pthread_sigmask(SIG_SETMASK, &sigsold, 0);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_sigmask(totals): %s",
			   ERROR_STR1(error));
}
