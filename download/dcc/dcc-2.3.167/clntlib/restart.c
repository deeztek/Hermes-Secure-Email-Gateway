/* Distributed Checksum Clearinghouse
 *
 * continually restart a daemon
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

#include "dcc_defs.h"
#include <sys/wait.h>
#include <signal.h>
#include <pwd.h>

#if defined(WIFEXITED) && defined(WTERMSIG) && defined(WIFSIGNALED)
#define HAVE_POSIX_WAIT
#else
#undef HAVE_POSIX_WAIT
#endif


#ifdef HAVE_POSIX_WAIT

static pid_t start_pid = -1;

static void
restart_sigterm(int sig)
{
	if (start_pid > 0
	    && 0 <= kill(start_pid, sig))
		return;
	exit(-1);
}
#endif /* HAVE_POSIX_WAIT */


#define MIN_RESTART_DELAY   5
#define MAX_RESTART_DELAY   (5*60)

/* stay alive despite core dumps
 *	Restart immediately, but not more often than every MINRESTART_DELAY
 *	seconds.  If the restarts are happening at the maximum rate,
 *	halve the rate. */
void
dcc_daemon_restart(const char *rundir DCC_UNUSED, void(reconn)(void) DCC_UNUSED,
		   u_char debug)
{
#ifdef HAVE_POSIX_WAIT
	pid_t pid;
	time_t next_restart, restart_delay;
	int status;
	const char *etype;
	DCC_PATH pidpath;

	signal(SIGHUP, restart_sigterm);
	signal(SIGTERM, restart_sigterm);
	signal(SIGINT, restart_sigterm);

	restart_delay = MIN_RESTART_DELAY;
	next_restart = 0;
	for (;;) {
		start_pid = fork();
		if (!start_pid) {
#ifdef HAVE_SETPGID
			if (0 > setpgid(0, 0))
				dcc_error_msg("setpgid(): %s", ERROR_STR());
#endif
			/* reconnect sockets or whatever except first time */
			if (next_restart != 0
			    && reconn)
				reconn();
			return;
		}

		if (start_pid < 0)
			dcc_logbad(EX_OSERR, "(re)start fork(): %s",
				   ERROR_STR());

		next_restart = time(0)+restart_delay;
		pid = waitpid(start_pid, &status, 0);
		if (pid < 0) {
			if (errno != EINTR)
				dcc_logbad(EX_OSERR, "restart waitpid(): %s",
					   ERROR_STR());
			exit(0);
		}

		start_pid = -1;
		if (WIFEXITED(status)) {
			status = WEXITSTATUS(status);
			if (status == EX_DCC_RESTART) {
				etype = "exit ";
			} else {
				if (debug) {
					if (status >= EX_DCC_SIGNAL
					    && status <= EX_DCC_SIGNAL_MAX)
					    dcc_error_msg("do not restart after"
							" signal %d",
							status - EX_DCC_SIGNAL);
					else
					    dcc_error_msg("do not restart after"
							" exit(%d)",
							status);
				}
				exit(status);
			}

		} else if (WIFSIGNALED(status)) {
			status = WTERMSIG(status);
			etype = "signal ";
			if (status != SIGILL
			    && status != SIGSEGV
#ifdef SIGBUS
			    && status != SIGBUS
#endif
#ifdef SIGFPE
			    && status != SIGFPE
#endif
#ifdef SIGSYS
			    && status != SIGSYS
#endif
#ifdef SIGTRAP
			    && status != SIGTRAP
#endif
#ifdef SIGXCPU
			    && status != SIGXCPU
#endif
#ifdef SIGXFSZ
			    && status != SIGXFSZ
#endif
			    && status != SIGQUIT
			    && status != SIGABRT) {
				if (debug)
					dcc_error_msg("do not restart after"
						      " signal %d",
						      status);
				exit(0);
			}

		} else {
			dcc_logbad(EX_OSERR, "unknown exit status %#x", status);
		}

		next_restart -= time(0);
		if (next_restart > 0 && next_restart <= MAX_RESTART_DELAY) {
			restart_delay *= 2;
			if (restart_delay > MAX_RESTART_DELAY)
				restart_delay = MAX_RESTART_DELAY;

			/* while we wait, become the designated target */
			dcc_error_msg("delay %d seconds to restart after %s%d",
				      (int)next_restart, etype, status);
			dcc_pidfile(&pidpath, rundir);
			sleep(next_restart);
			unlink(pidpath.c);

		} else {
			restart_delay -= next_restart-1;
			if (restart_delay < MIN_RESTART_DELAY)
				restart_delay = MIN_RESTART_DELAY;
		}
		dcc_error_msg("restart after %s%d", etype, status);
	}
#endif /* HAVE_POSIX_WAIT */
}



/* change to the UID and GID of a daemon */
void
dcc_daemon_su(const char *user)
{
	struct passwd *pw;

	pw = getpwnam(user);
	if (!pw) {
		dcc_error_msg("getpwnam(%s): %s", user, ERROR_STR());
		return;
	}

	if (0 > setgid(pw->pw_gid))
		dcc_error_msg("setgid(%d %s): %s",
			      (int)pw->pw_gid, user, ERROR_STR());
	if (0 > setuid(pw->pw_uid))
		dcc_error_msg("setuid(%d %s): %s",
			      (int)pw->pw_uid, user, ERROR_STR());
}



void
dcc_pidfile(DCC_PATH *pidpath, const char *rundir)
{
	FILE *f;

	snprintf(pidpath->c, sizeof(DCC_PATH), "%s/%s.pid",
		 rundir, dcc_progname.c);
	unlink(pidpath->c);
	f = fopen(pidpath->c, "w");
	if (!f) {
		dcc_error_msg("fopen(%s): %s", pidpath->c, ERROR_STR());
	} else {
#ifdef linux
		/* Linux threads are broken.  Signals given the
		 * original process are delivered to only the
		 * thread that happens to have that PID.  The
		 * sendmail libmilter thread that needs to hear
		 * SIGINT and other signals is known only to the milter.
		 * Unless you put its PID into the file, it will not hear
		 * the signals.  That breaks scripts that need to stop dccm.
		 * However, signaling the process group works. */
		fprintf(f, "-%d\n", (u_int)getpgrp());
#else
		fprintf(f, "%d\n", (u_int)getpid());
#endif
		fclose(f);
	}
}
