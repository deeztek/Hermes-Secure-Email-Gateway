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
 * Rhyolite Software DCC 2.3.167-1.8 $Revision$
 */

#include "dcc_clnt.h"
#ifdef HAVE_ARPA_NAMESER_H
#include <arpa/nameser.h>
#endif
#ifdef HAVE_RESOLV_H
#include <resolv.h>
#endif

int					/* -1=error, 0=timeout, 1=ready */
select_poll(DCC_EMSG *emsg,
	    DCC_POLLFD *pollfds, int nfds,
	    u_char rd,			/* 1=read 0=write */
	    int us)			/* <0=forever until signal */
{
#ifdef DCC_USE_POLL
	int delay;
	int result;
	int n;

	for (;;) {
		if (us < 0)
			delay = INFTIM;
		else
			delay = (us+999)/1000;

		n = 0;
		do {
			if (nfds <= 0)
				dcc_logbad(EX_SOFTWARE, "no select_poll() FDs");

			/* At least some versions of Linux have POLLRDNORM etc.
			 * in asm/poll.h, but with definitions of POLLIN,
			 * POLLPRI, etc. that conflict with their definitions
			 * in sys/poll.h.
			 * Perhaps it is not necessary to check for high or
			 * low priority data, but the poll() documentation on
			 * some systems says that asking about POLLIN does not
			 * say anything about other data */
#define POLL_ERRORS (POLLERR | POLLHUP | POLLNVAL)
#ifdef POLLRDNORM
			if (rd)
				pollfds[n].events = (POLLIN
						     | POLLRDNORM | POLLRDBAND
						     | POLLPRI
						     | POLL_ERRORS);
			else
				pollfds[n].events = (POLLOUT
						     | POLLWRNORM | POLLWRBAND
						     | POLLPRI
						     | POLL_ERRORS);
#else
			if (rd)
				pollfds[n].events = (POLLIN
						     | POLL_ERRORS);
			else
				pollfds[n].events = (POLLOUT
						     | POLL_ERRORS);
#endif /* POLLRDNORM */
#undef POLL_ERRORS
			pollfds[n].revents = 0;

			/* the initial FDs or the last FD can be invalid */
			if (pollfds[n].fd != INVALID_SOCKET) {
				++n;
			} else {
				--nfds;
				if (n == 0) {
					++pollfds;
					continue;
				}
				if (n == nfds)
					break;
				dcc_logbad(EX_SOFTWARE,
					   "too few select_poll() FDs");
			}
		} while (n < nfds);

		result = poll(pollfds, nfds, delay);
		if (result >= 0)
			return result;
		if (DELAY_ERROR()) {
			if (us < 0)	/* stop forever on a signal */
				return 0;
			continue;
		}
		dcc_pemsg(EX_OSERR, emsg, "poll(): %s", ERROR_STR());
		return -1;
	}
#else /* !DCC_USE_POLL */
	struct timeval delay, *delayp;
	fd_set fds;
#ifdef DCC_WIN32
	u_int max_fd;
#else
	int max_fd;
#endif
	int result;
	int i, j;

	for (;;) {
		if (us < 0) {
			delayp = 0;
		} else {
			us2tv(&delay, us);
			delayp = &delay;
		}

		FD_ZERO(&fds);
		max_fd = 0;
		for (i = 0; i < nfds; ++i) {
			pollfds[i].revents = 0;
			if (pollfds[i].fd == INVALID_SOCKET)
				continue;
			if (max_fd < pollfds[i].fd)
				max_fd = pollfds[i].fd;
			FD_SET(pollfds[i].fd, &fds);
		}
		if (rd)
			result = select(max_fd+1, &fds, 0, 0, delayp);
		else
			result = select(max_fd+1, 0, &fds, 0, delayp);
		if (result == 0)
			return 0;
		if (result > 0) {
			j = result;
			i = 0;
			do {
				if (FD_ISSET(pollfds[i].fd, &fds)) {
					pollfds[i].revents = 1;
					--j;
				}
			} while (++i, j != 0);
			return result;
		}
		if (DELAY_ERROR()) {
			if (us < 0)	/* stop forever on a signal */
				return 0;
			continue;
		}
		dcc_pemsg(EX_OSERR, emsg, "select(): %s", ERROR_STR());
		return -1;
	}
#endif /* !DCC_USE_POLL */
}
