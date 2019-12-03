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
 * Rhyolite Software DCC 2.3.167-1.67 $Revision$
 */

#include "dcc_defs.h"
#include "dcc_paths.h"
#ifdef DCC_UNIX
#include <syslog.h>
#endif

u_char dcc_clnt_debug;

u_char dcc_no_syslog;

int dcc_error_priority = LOG_ERR | LOG_MAIL;
int dcc_trace_priority = LOG_NOTICE | LOG_MAIL;

DCC_PATH dcc_progname;
int dcc_progname_len;

#ifdef HAVE___PROGNAME
extern const char *__progname;
#endif


const char LICENSE[] = 
"Copyright (c) 2019 by Rhyolite Software, LLC "
"\n"
"Permission to use, copy, modify, and distribute this software without "
"changes for any purpose with or without fee is hereby granted, provided "
"that the above copyright notice and this permission notice appear in all "
"copies and any distributed versions or copies are either unchanged "
"or not called anything similar to \"DCC\" or \"Distributed Checksum "
"Clearinghouse\". "
"\n"
"\n"
"THE SOFTWARE IS PROVIDED \"AS IS\" AND RHYOLITE SOFTWARE, LLC DISCLAIMS ALL "
"WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES "
"OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL RHYOLITE SOFTWARE, LLC "
"BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES "
"OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, "
"WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, "
"ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE. "
"\n"
"\n"
"Some parts including dcclib/getopt.c and include/sendmail-sysexits.h "
"Copyright (c) 1987, 1993, 1994 "
"	The Regents of the University of California.  All rights reserved. "
"\n"
"Some other parts including dcclib/inet_ntop.c "
"Copyright (c) 1996-1999 by Internet Software Consortium. "
"\n"
"Some other parts including autoconf/install-sh "
"	Copyright 1991 by the Massachusetts Institute of Technology "
"\n"
"Some other parts including getifaddrs() compatibility for Solaris "
"	Copyright (c) 2006 WIDE Project. All rights reserved \n";


void
dcc_syslog_init(u_char use_syslog,
		const char *argv0 DCC_UNUSED, const char *suffix)
{
	const char *p;

	/* Solaris defaults to "syslog" with a null identification string,
	 * but does not seem to have __progname set by crt0. */
#undef GOT_PROGNAME
#ifdef HAVE_GETPROGNAME
	p = getprogname();
#	define GOT_PROGNAME
#endif
#if defined(HAVE___PROGNAME) && !defined(GOT_PROGNAME)
	p = __progname;
#	define GOT_PROGNAME
#endif
#ifndef GOT_PROGNAME
	p = strrchr(argv0, '/');
#ifdef DCC_WIN32
	if (!p)
		p = strrchr(argv0, '\\');
#endif
	if (!p)
		p = argv0;
	else
		++p;
#ifdef DCC_WIN32
	/* strip ".exe" from Windows progam name */
	dcc_progname_len = strlen(p);
	if (dcc_progname_len > LITZ(".exe")
	    && !CLITCMP(&p[dcc_progname_len-LITZ(".exe")], ".exe")) {
		char *p1 = strdup(p);
		p1[dcc_progname_len-LITZ(".exe")] = '\0';
		p = p1;
	}
#endif /* DCC_WIN32 */
#endif /* !GOT_PROGNAME */
	snprintf(dcc_progname.c, sizeof(dcc_progname), "%s%s",
		 p, suffix ? suffix : "");
	dcc_progname_len = strlen(dcc_progname.c);

	/* ensure that stdout and stderr exist so that when we open
	 * database or other files, we don't get file descriptor 1 or 2
	 * and then later write error messages to them. */
	dcc_clean_stdio();

#ifdef DCC_WIN32
	dcc_no_syslog = 1;
#else
	/* Don't wait for the console if somehow we must use it,
	 * because that messes up dccm. */
#ifndef LOG_NOWAIT
#define LOG_NOWAIT 0
#endif
	openlog(dcc_progname.c, LOG_PID | LOG_NOWAIT, LOG_MAIL);
	if (!use_syslog)
		dcc_no_syslog = 1;
#endif /* DCC_WIN32 */
}


static void
clean_stdfd(int stdfd)
{
	struct stat sb;
	int fd;

	if (0 > fstat(stdfd, &sb) && errno == EBADF) {
		fd = open(_PATH_DEVNULL, 0, O_RDWR);
		if (fd < 0)		/* ignore errors we can't help */
			return;
		if (fd != stdfd) {
			dup2(fd, stdfd);
			close(fd);
		}
	}
}



/* prevent surprises from uses of stdio FDs by ensuring that the FDs are open */
void
dcc_clean_stdio(void)
{
	clean_stdfd(STDIN_FILENO);
	clean_stdfd(STDOUT_FILENO);
	clean_stdfd(STDERR_FILENO);
}



/* Fetch the exit code stashed after the end of an error message. */
int
emsg_ex_code(const DCC_EMSG *emsg)
{
	int len;

	len = strlen(emsg->c);
	if (len >= ISZ(DCC_EMSG)-2 || emsg->c[len+1] == 0)
		return EX_UNAVAILABLE;
	return emsg->c[len+1];
}



/* Generate an eorr message string in a buffer, if we have a buffer.
 *	Stash an exit code after the end of the test in the buffer.
 * Log or print the message if there is no buffer. */
void
dcc_vpemsg(u_char ex_code, DCC_EMSG *emsg, const char *msg, va_list args)
{
	int len;

	if (!emsg) {
		dcc_verror_msg(msg, args);
	} else {
		len = vsnprintf(emsg->c, sizeof(emsg->c), msg, args);
		if (len < ISZ(DCC_EMSG)-2)
			emsg->c[len+1] = ex_code;
	}
}



void DCC_PF(3,4)
dcc_pemsg(u_char ex_code, DCC_EMSG *emsg, const char *msg, ...)
{
	va_list args;

	va_start(args, msg);
	dcc_vpemsg(ex_code, emsg, msg, args);
	va_end(args);
}



int
dcc_verror_msg(const char *p, va_list args)
{
	char logbuf[LOGBUF_SIZE];
	int i;

	i = vsnprintf(logbuf, sizeof(logbuf), p, args);
	if (i >= ISZ(logbuf)) {
		strcpy(&logbuf[ISZ(logbuf)-sizeof("...")], "...");
		i = ISZ(logbuf)-1;
	} else if (i == 0) {
		i = snprintf(logbuf, sizeof(logbuf), "(empty error message)");
	}

	fflush(stdout);			/* keep stderr and stdout straight */
	(void)fwrite(logbuf, i, 1, stderr);
	if (logbuf[i-1] != '\n') {
		fputc('\n', stderr);
		++i;
	}

	if (!dcc_no_syslog) {
		dcc_syslog_lock();
		syslog(dcc_error_priority, "%s", logbuf);
		dcc_syslog_unlock();
	}

	fflush(stderr);			/* keep stderr and stdout straight */

	return i;
}



void DCC_PF(1,2)
dcc_error_msg(const char *p, ...)
{
	va_list args;

	va_start(args, p);
	dcc_verror_msg(p, args);
	va_end(args);
}



/* talk to stdout
 * and to the system log unless the system log is off */
void
dcc_vtrace_msg(const char *p, va_list args)
{
	char logbuf[LOGBUF_SIZE];
	int i;

	/* Some systems including Linux with gcc 3.4.2 on AMD 64 processors
	 * do not allow two uses of a va_list but requires va_copy()
	 * Other systems do not have any notion of va_copy(). */
	i = vsnprintf(logbuf, sizeof(logbuf), p, args);
	if (i >= ISZ(logbuf))
		strcpy(&logbuf[ISZ(logbuf)-sizeof("...")], "...");

	fflush(stdout);			/* keep stderr and stdout straight */
	fprintf(stderr, "%s\n", logbuf);

	if (!dcc_no_syslog) {
		dcc_syslog_lock();
		syslog(dcc_trace_priority, "%s", logbuf);
		dcc_syslog_unlock();
	}
	fflush(stderr);			/* keep stderr and stdout straight */
}



void DCC_PF(1,2)
dcc_trace_msg(const char *p, ...)
{
	va_list args;

	va_start(args, p);
	dcc_vtrace_msg(p, args);
	va_end(args);
}



void
dcc_vfatal_msg(const char *p, va_list args)
{
	char logbuf[LOGBUF_SIZE];
	int i;

	/* write the message with the "fatal error" addition as
	 * a single message to syslog */
	i = vsnprintf(logbuf, sizeof(logbuf), p, args);
	if (i >= ISZ(logbuf))
		strcpy(&logbuf[ISZ(logbuf)-sizeof("...")], "...");

	fflush(stdout);			/* keep stderr and stdout straight */
	fprintf(stderr, "%s; fatal error\n", logbuf);
	fflush(stderr);

	if (dcc_no_syslog)
		return;

	dcc_syslog_lock();
	syslog(dcc_error_priority, "%s; fatal error", logbuf);
	closelog();
	dcc_syslog_unlock();
}



void
dcc_version_print(void)
{
	static u_char seen_V = 0;

	if (!seen_V) {
		fputs(DCC_VERSION"\n", stderr);
		seen_V = 1;
	} else {
#ifndef DCC_CONFIGURE
		fputs("`configure` not used\n", stderr);
#else
		fputs("built with `configure "DCC_CONFIGURE"`\n", stderr);
#endif
	}
}
