/* Distributed Checksum Clearinghouse
 *
 * talk to DNS resolver libraries that are not thread safe
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
 * Rhyolite Software DCC 2.3.167-1.13 $Revision$
 */

#include "dcc_defs.h"
#include "helper.h"


static DCC_EMSG dcc_emsg;

static void DCC_NORET
usage(void)
{
	dcc_logbad(EX_USAGE, "usage: [-V] -B...");
}



int
main(int argc, char **argv)
{
	u_char print_version = 0;
	int i;

	dcc_syslog_init(1, argv[0], 0);

	while ((i = getopt(argc, argv, "VB:L:")) != -1) {
		switch (i) {
		case 'V':
			dcc_version_print();
			print_version = 1;
			break;

		case 'B':
			/* This arg will be either something about DNSBL
			 * checking or a final magic "-B set:helper=soc,fd,#" */
			if (!print_version
			    && !dcc_parse_dnsbl(&dcc_emsg, optarg, 0))
				dcc_error_msg("%s", dcc_emsg.c);
			break;

		case 'L':
			dcc_parse_log_opt(optarg);
			break;

		default:
			usage();
		}
	}
	if (print_version)
		exit(EX_OK);
	usage();
}



int
thr_error_msg(void *cp DCC_UNUSED, const char *p, ...)
{
	va_list args;
	int i;

	va_start(args, p);
	i = dcc_verror_msg(p, args);
	va_end(args);
	return i;
}



void
thr_trace_msg(void *cp DCC_UNUSED, const char *p, ...)
{
	va_list args;

	va_start(args, p);
	dcc_verror_msg(p, args);
	va_end(args);
}



/* appends '\n', but since it is ony for errors, do not worry about it */
int
thr_log_print(void *cp DCC_UNUSED, u_char error DCC_UNUSED, const char *p, ...)
{
	va_list args;
	int i;

	va_start(args, p);
	i = dcc_verror_msg(p, args);
	va_end(args);
	return i;
}
