/* Distributed Checksum Clearinghouse
 *
 * test dccifd via dccif()
 *
 * This is probably not the right way to use dccif(), because it uses
 * too much internal DCC code.
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
 * Rhyolite Software DCC 2.3.167-1.35 $Revision$
 */


#include "dccif.h"

#if 0
/* to test simple compiling */
int
main(int argc, char **argv)
{
	dccif(0,
	      0, 0,
	      0, 0, 0, 0, 0,
	      0, 0, 0, 0);
}

#else

#include "dcc_errlog.h"
#include "sendmail-sysexits.h"


static void DCC_NORET
usage(void)
{
	dcc_logbad(EX_USAGE,
		   "usage: [-VP] [-h FIFO | homedir | hostname,port] [-o opts]"
		   " [-c clnt-name]\n"
		   "    [-l heLo] [-f env_from] [-I ifile] [-O ofile]"
		   " [-r rcpt1[,user1]] [...]\n");
}



int
main(int argc, char **argv)
{
	DCC_EMSG emsg;
	u_char print_version = 0;
	const char *srvr_addr;
	const char *opts;
	DCC_SOCKU su, *sup;
	const char *clnt_nm;
	const char *helo;
	const char *env_from;
	DCCIF_RCPT *rcpts, *rcpt;
	int in_body_fd, out_body_fd;
	u_char dccproc;
	u_char result;
	char *p;
	int i, error;

	srvr_addr = 0;
	opts = 0;
	sup = 0;
	clnt_nm = 0;
	dccproc = 0;
	helo = 0;
	env_from = 0;
	in_body_fd = STDIN_FILENO;
	out_body_fd = dup(STDOUT_FILENO);
	rcpts = 0;

	dcc_syslog_init(0, argv[0], 0);

	while (EOF != (i = getopt(argc, argv, "VPh:o:c:l:f:I:O:r:"))) {
		switch (i) {
		case 'V':
			dcc_version_print();
			print_version = 1;
			break;

		case 'P':
			dccproc = 1;
			dcc_no_syslog = 1;
			break;

		case 'h':
			srvr_addr = optarg;
			break;

		case 'o':
			/* convert commas that users like to type to blanks */
			while ((p = strchr(optarg, ',')) != 0)
				*p = ' ';
			opts = optarg;
			break;

		case 'c':
			if (strcmp("0.0.0.0", optarg)) {
				dcc_host_lock();
				if (!dcc_get_host(optarg, DCC_GETH_DEF,
						  &error)) {
					dcc_logbad(EX_USAGE, "%s: %s\n",
						   optarg, H_ERROR_STR1(error));
				}
				dcc_ipv4su2ipv6su(&su, &dcc_hostaddrs[0]);
				dcc_host_unlock();
				sup = &su;
			}
			clnt_nm = optarg;
			break;

		case 'l':
			helo = optarg;
			break;

		case 'f':
			env_from = optarg;
			break;

		case 'I':
			close(in_body_fd);
			in_body_fd = open(optarg, O_RDONLY, 0);
			if (in_body_fd < 0)
				dcc_logbad(EX_IOERR, "open(%s): %s\n",
					optarg, strerror(errno));
			break;

		case 'O':
			close(out_body_fd);
			out_body_fd = open(optarg, O_WRONLY | O_CREAT, 0666);
			if (out_body_fd < 0) {
				fprintf(stderr, "open(%s): %s\n",
					optarg, strerror(errno));
				exit(1);
			}
			break;

		case 'r':
			rcpt = malloc(sizeof(*rcpt));
			memset(rcpt, 0, sizeof(*rcpt));
			rcpt->next = rcpts;
			rcpt->addr = optarg;
			p = strchr(optarg, ',');
			if (!p) {
				rcpt->user = "";
			} else {
				*p++ = '\0';
				rcpt->user = p;
			}
			rcpt->ok = '?';
			rcpts = rcpt;
			break;

		default:
			usage();
			break;
		}
	}
	argc -= optind;
	argv += optind;
	if (argc != 0)
		usage();

	if (print_version)
		exit(EX_OK);

	if (!rcpts)
		fprintf(stderr, "no recipients specified\n");

	result = dccif(&emsg,
		       out_body_fd, 0,
		       opts, sup, clnt_nm, helo, env_from,
		       rcpts, in_body_fd, 0, srvr_addr);

	if (!dccproc) {
		if (!result) {
			printf("result 0: %s\n", emsg.c);
			exit(0);
		}
		printf("overall result = '%c'\n", result);
		for (rcpt = rcpts; rcpt; rcpt = rcpt->next) {
			printf("    %s%s%s: '%c'\n",
			       rcpt->addr,
			       (rcpt->user[0] != '\0') ? "," : "",
			       rcpt->user,
			       rcpt->ok);
		}
		putchar('\n');
	}
	exit(0);
}
#endif /* 0 */
