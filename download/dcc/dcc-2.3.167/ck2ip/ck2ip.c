/* Distributed Checksum Clearinghouse checksum inverter
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
 * Rhyolite Software DCC 2.3.167-1.20 $Revision$
 */

#include "dcc_ck.h"
#include "dcc_xhdr.h"
#include <arpa/inet.h>


static DCC_EMSG dcc_emsg;

static int verbose;
#define LOOP_LIM_V  0x100000		/* progress report every /8 */
#define LOOP_LIM    (LOOP_LIM_V*32)

static u_char have_sum;
static DCC_SUM sum;

static in_addr_t begin, end;


static const char *cachedir;

#define LOG_NUM_FILES	12
#define	NUM_FILES	(1<<LOG_NUM_FILES)
#define CNAME_LEN	(LOG_NUM_FILES/4)
#if CNAME_LEN != 3
#error "fix cache name length"
#endif
#define CNAME_PAT   "%03x"
#define SUM2CNUM(s) ((((u_int)(s)->b[0])<<4) + ((s)->b[1]>>4))


typedef struct {
    char	magic[64];
#    define	 CACHE_MAGIC	"ck2ip cache file version 1"
    char	name[8];
} CACHE_HDR;

static int save_cksum(DCC_EMSG *, WF *, DCC_CK_TYPES, DCC_SUM *, DCC_TGTS);
static void direct(void);
static void build_cache(void);
static void search_cache(void);


static void DCC_NORET
usage(void)
{
	fprintf(stderr, "usage: [-vN] [-D cachedir]"
		" [-B IPv4-begin] [-E IPv4-end] [-C 'h1 h2 h3 h4']\n");
	exit(1);
}



int
main(int argc, char **argv)
{
	u_char have_range, new_cache;
	int error, i;

	dcc_syslog_init(0, argv[0], 0);
	dup2(1, 2);			/* put error messages in context */

	have_range = 0;
	new_cache = 0;
	begin = 0;
	end = -1;

	while ((i = getopt(argc, argv, "vND:B:E:C:")) != -1) {
		switch (i) {
		case 'v':
			++verbose;
			break;

		case 'N':
			new_cache = 1;
			break;

		case 'D':
			cachedir = optarg;
			break;

		case 'B':
			have_range = 1;
			dcc_host_lock();
			if (!dcc_get_host(optarg, DCC_GETH_V4, &error)) {
				fprintf(stderr, "\"-B %s\": %s\n",
					optarg, H_ERROR_STR1(error));
				exit(1);
			}
			begin = ntohl(dcc_hostaddrs[0].ipv4.sin_addr.s_addr);
			if (begin > end) {
				fprintf(stderr, "beginning after end\n");
				exit(1);
			}
			dcc_host_unlock();
			break;

		case 'E':
			have_range = 1;
			dcc_host_lock();
			if (!dcc_get_host(optarg, DCC_GETH_V4, &error)) {
				fprintf(stderr, "\"-E %s\": %s\n",
					optarg, H_ERROR_STR1(error));
				exit(1);
			}
			end = ntohl(dcc_hostaddrs[0].ipv4.sin_addr.s_addr);
			if (begin > end) {
				fprintf(stderr, "end before beginning\n");
				exit(1);
			}
			dcc_host_unlock();
			break;

		case 'C':
			if (0 >= dcc_parse_hex_ck(&dcc_emsg, 0,
						  DCC_XHDR_TYPE_IP, DCC_CK_IP,
						  optarg, 0, &save_cksum)) {
				fprintf(stderr, "%s\n", dcc_emsg.c);
				exit(1);
			}
			have_sum = 1;
			break;

		default:
			usage();
		}
	}
	argc -= optind;
	argv += optind;
	if (argc != 0)
		usage();

	if (new_cache) {
		if (!cachedir) {
			fprintf(stderr, "-N (new cache) requires -D\n");
			if (!have_sum)
				exit(1);
			new_cache = 0;
		}
	}
	if (!have_sum && !new_cache) {
		fprintf(stderr, "-C required except with -N (new cache)\n");
		usage();
	}
	if (cachedir && have_range)
		fprintf(stderr, "-D is incompatible with -B and -E\n");

	dcc_clnt_unthread_init();

	if (!cachedir || have_range) {
		direct();
	} else if (new_cache) {
		build_cache();
	} else {
		search_cache();
	}

	exit(EX_OK);
}



static int
save_cksum(DCC_EMSG *emsg DCC_UNUSED, WF *wf DCC_UNUSED,
	   DCC_CK_TYPES type DCC_UNUSED,
	   DCC_SUM *new_sum,
	   DCC_TGTS tgts DCC_UNUSED)
{
	sum = *new_sum;
	return 1;
}



/* immediate brute force search */
static void
direct(void)
{
	struct in_addr addr4;
	struct in6_addr addr6;
	DCC_SUM test_sum;
	char abuf[64];
	time_t now;
	char tbuf[12];

	addr4.s_addr = htonl(0);
	dcc_ipv4toipv6(&addr6, addr4);
	do {
		addr6.s6_addr32[3] = htonl(begin);
		ipv6tock(&test_sum, &addr6);
		if (!memcmp(&test_sum, &sum, sizeof(test_sum))) {
			printf("found %s\n",
			       dcc_trim_ffff(dcc_ipv6tostr(abuf, sizeof(abuf),
							&addr6)));
			return;
		}

		if (verbose ? (begin % (256*256) == 0xffff)
		    : (begin % (256*256*256) == 0xffffff)) {
			now = time(0);
			strftime(tbuf, sizeof(tbuf), "%X", localtime(&now));
			printf("    %s\t%s\n",
			       dcc_trim_ffff(dcc_ipv6tostr(abuf, sizeof(abuf),
							&addr6)),
			       tbuf);
		}
	} while (begin++ != end);

	printf("not found\n");
}



static void
cache_write(int fd, const void *buf, int buf_len,
	    int cnum, const char *msg)
{
	char cname[CNAME_LEN+1];
	int serrno, i;

	i = write(fd, buf, buf_len);
	if (i == buf_len)
		return;

	serrno = errno;
	if (i < 0)
		fprintf(stderr, "write(%s %s/"CNAME_PAT"): %s\n",
			msg, cachedir, cnum, strerror(errno));
	else
		fprintf(stderr, "write(%s %s/%s)=%d\n",
			msg, cachedir, cname, i);

	/* do not leave the file system overflowing */
	if (i >= 0 || serrno == ENOSPC) {
		for (i = 0; i <= cnum; ++i) {
			snprintf(cname, sizeof(cname), CNAME_PAT, i);
			unlink(cname);
		}
		rmdir(cachedir);
	}
	exit(1);
}



/* build a directory of cache files */
static void
build_cache(void)
{
	char cname[CNAME_LEN+1];
	in_addr_t a;
	struct in_addr addr4;
	struct in6_addr addr6;
	DCC_SUM test_sum;
	CACHE_HDR hdr;
	void *zeros;
	u_int64_t avg_file_size;
	int zero_len;
	typedef struct {
	    int		fd;
	    u_int	len;
	    u_int	total;
#	     define	 BUF_ADDRS (1024*32)
	    in_addr_t	addrs[BUF_ADDRS];
	} BUF;
	BUF *b, *bufs;
	char abuf[64];
	time_t now;
	char tbuf[12];
	int cnum;

	if (0 == chdir(cachedir)) {
		fprintf(stderr, "%s already exists\n", cachedir);
		exit(1);
	}
	if (0 > mkdir(cachedir, 0777)) {
		fprintf(stderr, "mkdir(%s): %s\n", cachedir, strerror(errno));
		exit(1);
	}
	if (0 > chdir(cachedir)) {
		fprintf(stderr, "%s: %s\n", cachedir, strerror(errno));
		exit(1);
	}

	/* create the files empty and generally contiguous */
	bufs = malloc(sizeof(BUF)*NUM_FILES);
	memset(bufs, 0, sizeof(BUF)*NUM_FILES);
	avg_file_size = 1;
	avg_file_size <<= 32;
	avg_file_size /= NUM_FILES;	/* average file size */
	zero_len = ((u_int)avg_file_size) * sizeof(in_addr_t);
	zeros = malloc(zero_len);
	memset(zeros, 0, zero_len);
	for (cnum = 0, b = bufs; cnum < NUM_FILES; ++cnum, ++b) {
		snprintf(cname, sizeof(cname), CNAME_PAT, cnum);
		b->fd = open(cname, O_WRONLY | O_CREAT, 0666);
		if (b->fd < 0) {
			fprintf(stderr, "open(%s/%s): %s\n",
				cachedir, cname, strerror(errno));
			exit(1);
		}
		cache_write(b->fd, zeros, zero_len, cnum, "zeros");
		if (sizeof(hdr) != lseek(b->fd, sizeof(hdr), SEEK_SET)) {
			fprintf(stderr, "lseek(%d %s/%s): %s",
				ISZ(hdr), cachedir, cname, strerror(errno));
			exit(1);
		}
		b->total = sizeof(hdr);
	}
	free(zeros);
	printf("empty files created in %s\n", cachedir);

	/* generate the data consisting of lists of IPv4 addresses */
	addr4.s_addr = htonl(0);
	dcc_ipv4toipv6(&addr6, addr4);
	a = 0;
	do {
		addr6.s6_addr32[3] = htonl(a);
		ipv6tock(&test_sum, &addr6);
		cnum = SUM2CNUM(&test_sum);
		b = &bufs[cnum];
		b->addrs[b->len] = addr6.s6_addr32[3];

		if (++b->len == BUF_ADDRS) {
			cache_write(b->fd, b->addrs, sizeof(b->addrs),
				    cnum, "addresses");
			b->total += sizeof(b->addrs);
			b->len = 0;
		}

		/* announce the completion of some addresses */
		if (verbose ? (a % (256*256*16) == 0xfffff)
		    : (a % (256*256*256) == 0xffffff)) {
			now = time(0);
			strftime(tbuf, sizeof(tbuf), "%X", localtime(&now));
			printf("    %s\t%s\n",
			       dcc_trim_ffff(dcc_ipv6tostr(abuf, sizeof(abuf),
							&addr6)),
			       tbuf);
		}
	} while (a++ != 0xffffffff);

	/* flush the buffers and write the magic string in each file */
	memset(&hdr, 0, sizeof(hdr));
	BUFCPY(hdr.magic, CACHE_MAGIC);
	for (cnum = 0, b = bufs; cnum < NUM_FILES; ++cnum, ++b) {
		snprintf(hdr.name, sizeof(hdr.name), CNAME_PAT, cnum);
		if (b->len != 0) {
			cache_write(b->fd, b->addrs, b->len*sizeof(b->addrs[0]),
				    cnum, "addresses");
			b->total += b->len*sizeof(b->addrs[0]);
			b->len = 0;
		}
		if (0 > ftruncate(b->fd, b->total)) {
			fprintf(stderr, "ftruncate(%s/%s): %s",
				cachedir, hdr.name, strerror(errno));
			exit(1);
		}
		if (0 != lseek(b->fd, 0, SEEK_SET)) {
			fprintf(stderr, "lseek(0 %s/%s): %s",
				cachedir, hdr.name, strerror(errno));
			exit(1);
		}
		cache_write(b->fd, &hdr, sizeof(hdr), cnum, "header");
		if (0 > fsync(b->fd)) {
			fprintf(stderr, "fsync(%s/%s): %s",
				cachedir, hdr.name, strerror(errno));
			exit(1);
		}
		if (0 > close(b->fd)) {
			fprintf(stderr, "close(%s/%s): %s",
				cachedir, hdr.name, strerror(errno));
			exit(1);
		}
	}
}



static void
search_cache(void)
{
	char cname[CNAME_LEN+1];
	int fd;
	CACHE_HDR hdr;
	in_addr_t fbuf[1024*(1024*12/10)];
	struct in_addr addr4;
	struct in6_addr addr6;
	DCC_SUM test_sum;
	char abuf[80];
	int total, len, i;

	if (0 > chdir(cachedir)) {
		fprintf(stderr, "%s: %s\n", cachedir, strerror(errno));
		exit(1);
	}

	snprintf(cname, sizeof(cname), CNAME_PAT, SUM2CNUM(&sum));
	fd = open(cname, O_RDONLY, 0);
	if (fd < 0) {
		fprintf(stderr, "%s/%s: %s\n", cachedir, cname, strerror(errno));
		exit(1);
	}

	i = read(fd, &hdr, sizeof(hdr));
	if (i != sizeof(hdr)) {
		if (i < 0)
			fprintf(stderr, "read(header %s/%s): %s\n",
				cachedir, cname, strerror(errno));
		else
			fprintf(stderr, "read(header %s/%s)=%d\n",
				cachedir, cname, i);
		exit(1);
	}

	if (strncmp(hdr.magic, CACHE_MAGIC, sizeof(hdr.magic))) {
		fprintf(stderr, "unrecognized magic in %s/%s\n",
			cachedir, cname);
		exit(1);
	}
	if (strncmp(hdr.name, cname, sizeof(hdr.name))) {
		fprintf(stderr, "wrong name in %s/%s\n",
			cachedir, cname);
		exit(1);
	}

	total = 0;
	for (;;) {
		len = read(fd, fbuf, sizeof(fbuf));
		if (len < 0) {
			fprintf(stderr, "read(data %s/%s): %s\n",
				cachedir, cname, strerror(errno));
			exit(1);
		}
		if (total+len == 0 || len % (sizeof fbuf[0]) != 0) {
			fprintf(stderr, "%s/%s truncated at %d bytes\n",
				cachedir, cname, total+len);
			exit(1);
		}
		if (len == 0) {
			fprintf(stderr, "checksum not found in %s/%s\n",
				cachedir, cname);
			exit(1);
		}
		total += len;

		addr4.s_addr = 0;
		dcc_ipv4toipv6(&addr6, addr4);
		i = 0;
		do {
			addr6.s6_addr32[3] = fbuf[i];
			ipv6tock(&test_sum, &addr6);
			if (!memcmp(&test_sum, &sum, sizeof(test_sum))) {
				printf("found %s\n",
				       dcc_trim_ffff(dcc_ipv6tostr(abuf,
							sizeof(abuf),
							&addr6)));
				return;
			}
		} while (++i, (len -= sizeof(fbuf[0])) >0);
	}
}
