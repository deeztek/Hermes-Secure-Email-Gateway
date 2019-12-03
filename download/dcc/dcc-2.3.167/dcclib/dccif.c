/* Distributed Checksum Clearinghouse
 *
 * dccif(), a sample C interface to the DCC interface daemon, dccifd
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
 * Rhyolite Software DCC 2.3.167-1.41 $Revision$
 */


#include "dcc_defs.h"
#include "dccif.h"
#include "dcc_clnt.h"
#include "sys/uio.h"
#include <sys/un.h>
#ifndef DCC_WIN32
#include <arpa/inet.h>
#endif



static void
dccif_closes(int *fd1, int *fd2, int *fd3)
{
	if (fd1 && *fd1 >= 0) {
		close(*fd1);
		*fd1 = -1;
	}
	if (fd2 && *fd2 >= 0) {
		close(*fd2);
		*fd2 = -1;
	}
	if (fd3 && *fd3 >= 0) {
		close(*fd3);
		*fd3 = -1;
	}
}



static void DCC_PF(6,7)
dccif_pemsg(int ex_code, DCC_EMSG *emsg,
	    int *fd1, int *fd2, int *fd3,
	    const char *msg, ...)
{
	va_list args;

	if (emsg) {
		va_start(args, msg);
		dcc_vpemsg(ex_code, emsg, msg, args);
		va_end(args);
	}

	dccif_closes(fd1, fd2, fd3);
}



static u_char
dccif_sock(DCC_EMSG *emsg,
	   const char *srvr_addr,	/* home directory, FIFO, or host,port */
	   DCC_SOCKET *s, int* fd2, int* fd3)
{
	struct stat sb;
	char host[DCC_MAXDOMAINLEN];
	in_port_t port;
	DCC_SOCKU su;
	struct sockaddr_un sunsock;
	const char *cp;
	int error;

	/* srvr_addr should be a hostname,port if not a file or directory */
	if (0 > stat(srvr_addr, &sb)) {
		if (!strchr(srvr_addr, ',')) {
			dccif_pemsg(EX_IOERR, emsg, s, fd2, fd3,
				    "stat(%s): %s", srvr_addr, ERROR_STR());
			return 0;
		}

		cp = dcc_parse_nm_port(emsg, srvr_addr, DCC_GET_PORT_INVALID,
				       host, sizeof(host),
				       &port, 0, 0, 0, 0);
		if (!cp) {
			dccif_closes(0, fd2, fd3);
			return 0;
		}
		if (*cp != '\0') {
			dccif_pemsg(EX_USAGE, emsg, 0, fd2, fd3,
				    "invalid IP address: %s", srvr_addr);
			return 0;
		}
		if (host[0] == '\0') {
			dccif_pemsg(EX_NOHOST, emsg, 0, fd2, fd3,
				    "missing host name in \"%s\"", srvr_addr);
			return 0;
		}
		dcc_host_lock();
		if (!dcc_get_host(host, DCC_GETH_DEF, &error)) {
			dcc_host_unlock();
			dccif_pemsg(EX_NOHOST, emsg, 0, fd2, fd3,
				    "%s: %s", srvr_addr, H_ERROR_STR1(error));
			return 0;
		}
		su = dcc_hostaddrs[0];
		DCC_SU_PORT(&su) = port;
		dcc_host_unlock();

		*s = socket(su.sa.sa_family, SOCK_STREAM, 0);
		if (*s < 0) {
			dccif_pemsg(EX_IOERR, emsg, s, fd2, fd3,
				    "socket(AF_UNIX): %s", ERROR_STR());
			return 0;
		}

		if (0 > connect(*s, &su.sa, DCC_SU_LEN(&su))) {
			dccif_pemsg(EX_IOERR, emsg, s, fd2, fd3,
				    "connect(%s): %s", srvr_addr, ERROR_STR());
			return 0;
		}
		return 1;
	}

	*s = socket(AF_UNIX, SOCK_STREAM, 0);
	if (*s < 0) {
		dccif_pemsg(EX_IOERR, emsg, s, fd2, fd3,
			    "socket(AF_UNIX): %s", ERROR_STR());
		return 0;
	}
	memset(&sunsock, 0, sizeof(sunsock));
	sunsock.sun_family = AF_UNIX;
	if (S_ISDIR(sb.st_mode))
		snprintf(sunsock.sun_path, sizeof(sunsock.sun_path),
			 "%s/"DCC_DCCIF_UDS, srvr_addr);
	else
		BUFCPY(sunsock.sun_path, srvr_addr);
#ifdef HAVE_SA_LEN
	sunsock.sun_len = SUN_LEN(&sunsock);
#endif
	if (0 > connect(*s, (struct sockaddr *)&sunsock, sizeof(sunsock))) {
		dccif_pemsg(EX_IOERR, emsg, s, fd2, fd3,
			    "connect(%s): %s",
			    sunsock.sun_path, ERROR_STR());
		return 0;
	}
	return 1;
}



static u_char
dccif_writev(DCC_EMSG *emsg,
	     int *out_fd, int *fd2, int *fd3,
	     const struct iovec *iovs,
	     int num_iovs,
	     int wtotal)
{
	int i;

	i = writev(*out_fd, iovs, num_iovs);
	if (i == wtotal)
		return 1;
	if (i < 0)
		dccif_pemsg(EX_IOERR, emsg, out_fd, fd2, fd3,
			    "dccif writev(%d): %s", wtotal, ERROR_STR());
	else
		dccif_pemsg(EX_IOERR, emsg, out_fd, fd2, fd3,
			    "dccif writev(%d)=%d", wtotal, i);
	return 0;
}



static u_char
dccif_write(DCC_EMSG *emsg,
	    int *out_fd, int *fd2, int *fd3,
	    const void *buf, int buf_len)
{
	int i;

	i = write(*out_fd, buf, buf_len);
	if (i == buf_len)
		return 1;
	if (i < 0)
		dccif_pemsg(EX_IOERR, emsg, out_fd, fd2, fd3,
			    "dccif writev(%d): %s", buf_len, ERROR_STR());
	else
		dccif_pemsg(EX_IOERR, emsg, out_fd, fd2, fd3,
			    "dccif writev(%d)=%d",
			    buf_len, i);
	return 0;
}



static int
dccif_read(DCC_EMSG *emsg,
	   int *in_fd, int *fd2, int *fd3,
	   char *buf, int buf_len, int min_read)
{
	int total, i;

	total = 0;
	for (;;) {
		i = read(*in_fd, &buf[total], buf_len-total);
		if (i < 0) {
			dccif_pemsg(EX_IOERR, emsg, in_fd, fd2, fd3,
				    "dccif read(): %s", ERROR_STR());
			return -1;
		}
		total += i;
		if (total >= min_read)
			return total;
		if (i == 0) {
			dccif_pemsg(EX_IOERR, emsg, in_fd, fd2, fd3,
				    "dccif read(): premature EOF");
			return -1;
		}
	}
}



/* This function is mentioned in dccifd/dccif-test/dccif-test.c
 *	and so cannot change lightly. */
u_char					/* 0=failed or DCCIF_RESULT_* */
dccif(DCC_EMSG *emsg,			/* put error message here */
      int out_body_fd,			/* -1 or write body to here */
      char **out_body,			/* 0 or pointer for resulting body */
      const char *opts,			/* blank separated string DCCIF_OPT_* */
      const DCC_SOCKU *clnt_addr,	/* SMTP client IPv4 or IPv6 address */
      const char *clnt_name,		/* optional SMTP client name */
      const char *helo,
      const char *env_from,		/* envelope sender */
      DCCIF_RCPT *rcpts,		/* pruned envelope recipients */
      int in_body_fd,			/* -1 or read body from here */
      const char *in_body,		/* 0 or start of incoming body */
      const char *srvr_addr)		/* home directory, FIFO, or host,port */
{
	static const char nl = '\n';
	static const char cr = '\r';
	int s;
	char clnt_str[INET6_ADDRSTRLEN+1+1];
	struct iovec iovs[50], *iovp;
	int wtotal;
#	define ADD_IOV(b,l) {int _l = (l); iovp->iov_base = (char *)(b); \
		iovp->iov_len = _l; ++iovp; wtotal += _l;}
	DCCIF_RCPT *rcpt;
	char buf[4*1024];
	char result;
	int read_len, in_body_len, max_body_len, nxt;
	int i, j;

	if (!srvr_addr || *srvr_addr == '\0')
		srvr_addr = DCC_HOMEDIR;

	if (emsg)
		emsg->c[0] = '\0';

	if (!clnt_addr) {
		clnt_str[0] = '\0';
	} else {
		dcc_su2str2(clnt_str, sizeof(clnt_str), clnt_addr);
	}

	if (!dccif_sock(emsg, srvr_addr, &s, &in_body_fd, &out_body_fd))
		return 0;

	/* first line of request */
	iovp = iovs;
	wtotal = 0;
	if (opts)
		ADD_IOV(opts, strlen(opts));
	ADD_IOV(&nl, 1);

	i = strlen(clnt_str);
	clnt_str[i++] = '\r';
	ADD_IOV(clnt_str, i);
	if (i > 1 && clnt_name)
		ADD_IOV(clnt_name, strlen(clnt_name));
	ADD_IOV(&nl, 1);

	if (helo)
		ADD_IOV(helo, strlen(helo));
	ADD_IOV(&nl, 1);

	if (env_from)
		ADD_IOV(env_from, strlen(env_from));
	ADD_IOV(&nl, 1);

	for (rcpt = rcpts; rcpt; rcpt = rcpt->next) {
		ADD_IOV(rcpt->addr, strlen(rcpt->addr));
		ADD_IOV(&cr, 1);
		if (rcpt->user)
			ADD_IOV(rcpt->user, strlen(rcpt->user));
		ADD_IOV(&nl, 1);
		if (iovp >= &iovs[DIM(iovs)-4-1]) {
			if (!dccif_writev(emsg, &s, &in_body_fd, &out_body_fd,
					  iovs, iovp - iovs, wtotal))
				return 0;
			iovp = iovs;
			wtotal = 0;
		}
	}
	ADD_IOV(&nl, 1);

	/* copy (some of) the body from the buffer to the daemon */
	if (in_body) {
		in_body_len = strlen(in_body);
		ADD_IOV(in_body, in_body_len);
	} else {
		in_body_len = 0;
	}

	if (!dccif_writev(emsg, &s, &in_body_fd, &out_body_fd,
			  iovs, iovp - iovs, wtotal))
		return 0;

	/* copy (the rest of) the body from input file to the daemon */
	if (in_body_fd >= 0) {
		for (;;) {
			i = read(in_body_fd, buf, sizeof(buf));
			if (i <= 0) {
				if (i == 0)
					break;
				dccif_pemsg(EX_IOERR, emsg,
					    &s, &in_body_fd, &out_body_fd,
					    "read(body): %s", ERROR_STR());
				return 0;
			}
			if (!dccif_write(emsg, &s, &in_body_fd, &out_body_fd,
					 buf, i))
				return 0;
			in_body_len += i;
		}
		if (0 > close(in_body_fd)) {
			dccif_pemsg(EX_IOERR, emsg,
				    &s, &in_body_fd, &out_body_fd,
				    "close(in_body_fd): %s", ERROR_STR());
			return 0;
		}
		in_body_fd = -1;
	}

	/* tell the daemon it has all of the body */
	if (0 > shutdown(s, 1)) {
		dccif_pemsg(EX_IOERR, emsg, &s, &in_body_fd, &out_body_fd,
			    "shutdown(): %s", ERROR_STR());
		return 0;
	}

	/* get the overall result */
	read_len = dccif_read(emsg, &s, &in_body_fd, &out_body_fd,
			      buf, sizeof(buf), 2);
	if (read_len < 0)
		return 0;
	result = buf[0];
	if (result != DCCIF_RESULT_OK
	    && result != DCCIF_RESULT_GREY
	    && result != DCCIF_RESULT_REJECT
	    && result != DCCIF_RESULT_SOME
	    && result != DCCIF_RESULT_TEMP) {
		dccif_pemsg(EX_SOFTWARE, emsg, &s, &in_body_fd, &out_body_fd,
			  "unrecognized dccifd result \"%.*s\"", 1, buf);
		return 0;
	}

	/* read the vector of results from the daemon */
	nxt = 1;			/* skip '\n' after result */
	for (rcpt = rcpts; rcpt != 0; rcpt = rcpt->next) {
		if (++nxt >= read_len) {
			read_len = dccif_read(emsg,
					      &s, &in_body_fd, &out_body_fd,
					      buf, sizeof(buf), 2);
			if (read_len < 0)
				return 0;
			nxt = 0;
		}
		switch (buf[nxt]) {
		case DCCIF_RCPT_ACCEPT:
		case DCCIF_RCPT_REJECT:
		case DCCIF_RCPT_GREY:
			rcpt->ok = buf[nxt];
			break;
		default:
			dccif_pemsg(EX_SOFTWARE, emsg,
				    &s, &in_body_fd, &out_body_fd,
				    "unrecognized dccifd recipient result"
				    " \"%c\" for %s",
				    buf[nxt], rcpt->addr);
			return 0;
		}
	}
	if (++nxt >= read_len) {
		read_len = dccif_read(emsg, &s, &in_body_fd, &out_body_fd,
				      buf, 1, 1);
		if (read_len < 0)
			return 0;
		nxt = 0;
	}
	if (buf[nxt++] != '\n') {
		dccif_pemsg(EX_SOFTWARE, emsg, &s, &in_body_fd, &out_body_fd,
			  "unrecognized dccifd text after results: \"%c\"",
			  buf[nxt]);
		return 0;
	}

	/* copy the body from the daemon to the output buffer for file */
	if (out_body_fd >= 0) {
		for (;;) {
			j = read_len - nxt;
			if (j <= 0) {
				j = dccif_read(emsg, &s,
					       &in_body_fd, &out_body_fd,
					       buf, sizeof(buf), 0);
				if (j < 0)
					return 0;
				if (j == 0)
					break;
				read_len = j;
				nxt = 0;
			}
			if (!dccif_write(emsg, &out_body_fd,
					 &s, &in_body_fd,
					 &buf[nxt], j))
				return 0;
			read_len = 0;
		}
		if (0 > close(out_body_fd)) {
			dccif_pemsg(EX_IOERR, emsg,
				    &s, &in_body_fd, &out_body_fd,
				    "close(out_body_fd): %s",
				    ERROR_STR());
			return 0;
		}
		out_body_fd = -1;

	} else if (out_body) {
		char *body;

		max_body_len = in_body_len + DCC_MAX_XHDR_LEN+1;
		body = malloc(max_body_len);
		*out_body = body;
		j = read_len - nxt;
		if (j > 0) {
			if (j > max_body_len)
				j = max_body_len;
			memcpy(body, &buf[nxt], j);
			body += j;
			max_body_len -= j;
		}
		for (;;) {
			if (max_body_len <= 0) {
				dccif_pemsg(EX_SOFTWARE, emsg,
					    &s, &in_body_fd, &out_body_fd,
					    "too much body from dccifd");
				free(*out_body);
				return 0;
			}

			j = dccif_read(emsg, &s, &in_body_fd, &out_body_fd,
				       body, max_body_len, 0);
			if (j < 0) {
				free(*out_body);
				return 0;
			}
			if (j == 0)
				break;
			body += j;
			max_body_len -= j;
		}
		*body = '\0';
	}

	if (0 > close(s)) {
		dccif_pemsg(EX_IOERR, emsg, &s, &in_body_fd, &out_body_fd,
			    "close(socket): %s", ERROR_STR());
		return 0;
	}
	return result;
#undef ADD_IOV
}
