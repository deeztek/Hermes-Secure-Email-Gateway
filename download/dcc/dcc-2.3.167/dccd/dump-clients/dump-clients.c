/* Distributed Checksum Clearinghouse
 *
 * dump list of dccd clients
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
 * Rhyolite Software DCC 2.3.167-1.44 $Revision$
 */

#include "dccd_defs.h"

static const char *homedir;

u_char grey_on;
static u_char nonames, quiet, verbose, avg;

struct total {
    u_int	clients;
    u_int	black_clients;
    DCC_SCNTR   reqs;
    DCC_SCNTR   nops;
    DCC_SCNTR   black_reqs;
    DCC_SCNTR   black_nops;
    DCC_SCNTR   reqs_avg;
    DCC_SCNTR   nops_avg;
    DCC_SCNTR   black_reqs_avg;
    DCC_SCNTR   black_nops_avg;
};


static void DCC_NORET
usage(void)
{
	fprintf(stderr, "usage: [-anqvg] [-h homedir] [ifile1 ifile2 ...]\n");
	exit(1);
}



static void DCC_PF(1,2)
error_msg(const char *p, ...)
{
	va_list args;

	fflush(stdout);

	va_start(args, p);
	vfprintf(stderr, p, args);
	va_end(args);
	putchar('\n');
	fflush(stderr);
}



static u_char
clients_read(const char *fname, FILE *f, off_t pos, void *buf, int buf_len)
{
	int i;

	if (fseeko(f, pos, 0)) {
		error_msg("fseeko(%s,%d): %s", fname, (int)pos, ERROR_STR());
		fclose(f);
		return 0;
	}

	i = fread(buf, buf_len, 1, f);
	if (i == 1)
		return 1;

	if (feof(f))
		return 0;

	error_msg("fread(%s): %s", fname, ERROR_STR());
	fclose(f);
	return 0;
}



#define PAT_TOTAL_H1	 "    %11s"
#define PAT_TOTAL_H1_AVG "    %11s                          average"
#define PAT_TOTAL_H2_AVG "version clients requests     nops   requests     nops"
#define PAT_TOTAL_H2     "version clients requests"
#define PAT_TOTAL	    L_DWPAT(8)
#define PAT_TOTALS_AVG	    PAT_TOTAL" "PAT_TOTAL"   "PAT_TOTAL" "PAT_TOTAL
#define PAT_TOTALS	    PAT_TOTAL" "PAT_TOTAL
#define PAT_TOTAL_LABEL	    "%6d "
#define PAT_TOTAL_LABEL_STR "%6s "
static void
print_total_heading(u_char blacklist)
{
	const char *b_str;

	if (blacklist)
		b_str = "blacklist";
	else
		b_str = "";
	if (avg) {
		printf(PAT_TOTAL_H1_AVG"\n"PAT_TOTAL_H2_AVG"\n", b_str);
	} else {
		printf(PAT_TOTAL_H1"\n"PAT_TOTAL_H2"\n", b_str);
	}
}



static void
print_total(struct total *tp, u_char blacklist)
{
	if (blacklist) {
		if (avg)
			printf("%8d "PAT_TOTALS_AVG"\n",
			       tp->black_clients,
			       tp->black_reqs, tp->black_nops,
			       tp->black_reqs_avg, tp->black_nops_avg);
		else
			printf("%8d "PAT_TOTALS"\n",
			       tp->black_clients,
			       tp->black_reqs, tp->black_nops);
	} else {
		if (avg)
			printf("%8d "PAT_TOTALS_AVG"\n",
			       tp->clients,
			       tp->reqs, tp->nops,
			       tp->reqs_avg, tp->nops_avg);
		else
			printf("%8d "PAT_TOTALS"\n",
			       tp->clients,
			       tp->reqs, tp->nops);
	}
}



static void
dump_file(const char *fname0)
{
#	define PAT_REQS		L_DWPAT(6)" "L_DWPAT(6)" "
#	define PAT_REQS_B	"%6s %6s "
#	define PAT_AVGS		"%7u %7u %2d "
#	define PAT_AVGS_B	"%15s %3s"
#	define PAT_DATE		"%-14s"
#	define PAT_ID		" %6u "
#	define PAT_ID_STR	" %6s "
#	define PAT_VERS		"%2d "
#	define PAT_VERS_B	"%2s "
#	define PAT_DELAY	"%-5s "

	DCC_PATH fname;
	FILE *f;
	struct stat sb;
	CLIENTS_HEADER header;
	RL_DATA d;
	struct total total_x, totals[DCC_PKT_VERS_NOP_MAX+1];
	struct tm tm;
	char date_buf[40];
	char date_buf2[40];
	double delay_us;
	DCC_SOCKU su;
	char name[DCC_MAXDOMAINLEN];
	char sustr[DCC_SU2STR_SIZE];
	char flags[30];
	off_t pos;
	int total_clients, active_clients, i;

	if (!dcc_fnm2abs(&fname, fname0, 0)) {
		error_msg("name \"%s\" too long", fname0);
		exit(1);
	}

	printf("%s\n", fname.c);

	f = fopen(fname.c, "r");
	if (!f) {
		error_msg("stat(%s): %s",
			  fname.c, ERROR_STR());
		exit(1);
	}
	if (0 > fstat(fileno(f), &sb)) {
		error_msg("stat(%s): %s", fname.c, ERROR_STR());
		exit(1);
	}
	pos = sb.st_size;
	if (pos < ISZ(header)
	    || ((pos - ISZ(header)) % ISZ(RL_DATA)) != 0) {
		error_msg("%s has invalid size %d", fname.c, (int)pos);
		exit(1);
	}

	if (!clients_read(fname.c, f, 0, &header, sizeof(header)))
		exit(1);
	if (strcmp(header.magic, CLIENTS_MAGIC(0))
	    && strcmp(header.magic, CLIENTS_MAGIC(1))) {
		error_msg("unrecognized magic in %s", fname.c);
		exit(1);
	}
	if (header.blocks > DCC_RL_MAX_MAX) {
		error_msg("unrecognized blocks=%d in %s",
			  header.blocks, fname.c);
		exit(1);
	}
	if ((int)(header.blocks*sizeof(RL_DATA) + sizeof(header)) != (int)pos) {
		error_msg("%s has wrong size of %d instead of %d",
			  fname.c,
			  (int)(header.blocks*sizeof(RL_DATA) + sizeof(header)),
			  (int)pos);
		exit(1);
	}

	DCC_GMTIME(header.now, &tm);
	strftime(date_buf, sizeof(date_buf), "%m/%d %X", &tm);
	DCC_GMTIME(header.cleared, &tm);
	strftime(date_buf2, sizeof(date_buf2), "%m/%d %X", &tm);
	printf("recorded %s  cleared %s  anon delay=", date_buf, date_buf2);
	if (header.anon_delay_us == DCC_ANON_DELAY_FOREVER) {
		printf("forever");
	} else {
		printf("%d", header.anon_delay_us/1000);
		if (header.anon_delay_inflate != DCC_ANON_INFLATE_OFF)
			printf(",%d", header.anon_delay_inflate);
	}
	putchar('\n');

	if (avg) {
		if (verbose)
			printf(PAT_REQS_B
			       PAT_AVGS_B
			       PAT_DATE" "
			       PAT_DATE
			       PAT_ID_STR
			       PAT_VERS_B
			       PAT_DELAY "\n",
			       "ops", "nops",
			       " averages ", "hrs",
			       "  block used",
			       "   last seen", "ID",
			       "V",
			       "delay");
		else
			printf(PAT_REQS_B
			       PAT_AVGS_B
			       PAT_DATE
			       PAT_ID_STR
			       PAT_VERS_B
			       PAT_DELAY "\n",
			       "ops", "nops",
			       " averages ", "hrs",
			       "   last seen", "ID",
			       "V",
			       "delay");
	} else {
		if (verbose)
			printf(PAT_REQS_B
			       PAT_DATE" "
			       PAT_DATE
			       PAT_ID_STR
			       PAT_VERS_B
			       PAT_DELAY "\n",
			       "ops", "nops",
			       "  block used",
			       "   last seen", "ID",
			       "V",
			       "delay");
		else
			printf(PAT_REQS_B
			       PAT_DATE
			       PAT_ID_STR
			       PAT_VERS_B
			       PAT_DELAY "\n",
			       "ops", "nops",
			       "   last seen", "ID",
			       "V",
			       "delay");
	}

	total_clients = 0;
	active_clients = 0;
	memset(totals, 0, sizeof(totals));
	/* read the file backwards because it was written that way */
	while ((pos -= ISZ(RL_DATA)) >= ISZ(header)) {
		if (!clients_read(fname.c, f, pos, &d, sizeof(d)))
			break;

		++total_clients;
		if (d.reqs != 0 || d.nops != 0)
			++active_clients;

		if (!(d.fgs & RL_FG_BLOCK)
		    && d.pkt_vers != DCC_PKT_VERS_INVALID
		    && d.pkt_vers != DCC_PKT_VERS_MULTI
		    && (d.reqs != 0 || d.nops != 0
			|| (avg && (d.reqs_avg != 0 || d.nops_avg != 0)))) {
			if (d.pkt_vers < DIM(totals))
				i = d.pkt_vers;
			else
				i = 0;
			++totals[i].clients;
			if (d.fgs & (RL_FG_BLACK_ID | RL_FG_BLACK_ADDR)) {
				++totals[i].black_clients;
				totals[i].black_reqs += d.reqs;
				totals[i].black_nops += d.nops;
				if (avg) {
					totals[i].black_reqs_avg += d.reqs_avg;
					totals[i].black_nops_avg += d.nops_avg;
				}
			} else {
				++totals[i].clients;
				totals[i].reqs += d.reqs;
				totals[i].nops += d.nops;
				if (avg) {
					totals[i].reqs_avg += d.reqs_avg;
					totals[i].nops_avg += d.nops_avg;
				}
			}
		}

		if (quiet)
			continue;

		if (d.reqs != 0) {
			printf(PAT_REQS, d.reqs, d.nops);
		} else {
			printf(PAT_REQS_B, "", "");
		}

		if (avg) {
			if (d.reqs_avg != 0 || d.nops_avg != 0) {
				printf(PAT_AVGS,
				       d.reqs_avg,
				       d.nops_avg,
				       (int)((header.now - d.avg_start)
					     / (60*60*1.0)));
			} else {
				printf(PAT_AVGS_B, "", "");
			}
		}

		if (verbose) {
			if (d.fgs & RL_FG_BLOCK) {
				DCC_GMTIME(d.u.block_used, &tm);
				strftime(date_buf, sizeof(date_buf),
					 "%m/%d %X", &tm);
				printf(PAT_DATE" ", date_buf);
			} else {
				printf(PAT_DATE" ", "");
			}
		}
		DCC_GMTIME(d.last_used, &tm);
		strftime(date_buf, sizeof(date_buf),
			 "%m/%d %X", &tm);
		printf(PAT_DATE, date_buf);
		if (d.id == DCC_ID_ANON)
			printf(PAT_ID_STR, "");
		else if (d.id == DCC_ID_CLIENTS_MULT)
			printf(PAT_ID_STR, "mult");
		else if (d.id == DCC_ID_SRVR_ROGUE)
			printf(PAT_ID_STR, "server");
		else
			printf(PAT_ID, d.id);

		if (d.pkt_vers == DCC_PKT_VERS_MULTI)
			printf(PAT_VERS_B, "m");
		else if (d.pkt_vers == DCC_PKT_VERS_INVALID)
			printf(PAT_VERS_B, "");
		else
			printf(PAT_VERS, d.pkt_vers);

		flags[0] = '\0';
		if ((d.fgs & RL_FG_NO_AUTH)
		    && !(d.fgs & RL_FG_BLACK_ADDR)
		    && header.anon_delay_inflate != 0
		    && RL_REQS_AVG(&d) >= header.anon_delay_inflate) {
			u_int32_t inflate;

			inflate = 1 + (RL_REQS_AVG(&d)
				       / header.anon_delay_inflate);
			if (inflate > (DCC_ANON_DELAY_MAX
				       / header.anon_delay_us)) {
				delay_us = DCC_ANON_DELAY_MAX;
			} else {
				delay_us = inflate*header.anon_delay_us;
			}
			i = strlen(flags);
			snprintf(flags+i, sizeof(flags)-i,
				 "%2.1f", delay_us/DCC_US);
		}
		if (d.fgs & RL_FG_BLACK_ADDR)
			STRLCAT(flags, " A-BL", sizeof(flags));
		if (d.fgs & RL_FG_BLACK_ID)
			STRLCAT(flags, " ID-BL", sizeof(flags));
		if (d.fgs & RL_FG_BLOCK_BLACK)
			STRLCAT(flags, " BB", sizeof(flags));
		if (d.fgs & RL_FG_DROPPED)
			STRLCAT(flags, " BAD", sizeof(flags));
#if 0
		if (verbose) {
			if (d.fgs & RL_FG_BLOCK) {
				if (!(d.fgs & RL_FG_BLOCK_SET))
					STRLCAT(flags, " UNSET", sizeof(flags));
			} else {
				if (!(d.fgs & RL_FG_BLACK_SET))
					STRLCAT(flags, " UNSET", sizeof(flags));
			}
		}
#endif
		printf(PAT_DELAY, flags);

		dcc_mk_inet6_su(&su, &d.addr, 0, 0);
		dcc_ipv6su2ipv4su(&su, &su);
		dcc_su2str2(sustr, sizeof(sustr), &su);
		if (d.fgs & RL_FG_BLOCK) {
			printf("%s/%d\n", sustr,
			       su.sa.sa_family == AF_INET
			       ? DCC_ADMN_RESP_CLIENTS_IPV4_BITS
			       : DCC_ADMN_RESP_CLIENTS_IPV6_BITS);
		} else if (nonames) {
			printf("%s\n", sustr);
		} else {
			printf("%-16s %s\n", sustr,
			       dcc_su2name(name, sizeof(name), &su));
		}
	}

	fclose(f);

	printf("%d of %d records active\n\n", active_clients, total_clients);

	print_total_heading(0);
	memset(&total_x, 0, sizeof(total_x));
	for (i = 0; i < DIM(totals); ++i) {
		if (totals[i].clients == 0
		    && totals[i].black_clients == 0)
			continue;
		total_x.clients += totals[i].clients;
		total_x.reqs += totals[i].reqs;
		total_x.nops += totals[i].nops;
		total_x.reqs_avg += totals[i].reqs_avg;
		total_x.nops_avg += totals[i].nops_avg;
		printf(PAT_TOTAL_LABEL, i);
		print_total(&totals[i], 0);
	}
	printf(PAT_TOTAL_LABEL_STR, "total");
	print_total(&total_x, 0);

	fputs("\n", stdout);
	print_total_heading(1);
	memset(&total_x, 0, sizeof(total_x));
	for (i = 0; i < DIM(totals); ++i) {
		if (totals[i].clients == 0
		    && totals[i].black_clients == 0)
			continue;
		total_x.black_clients += totals[i].black_clients;
		total_x.black_reqs += totals[i].black_reqs;
		total_x.black_nops += totals[i].black_nops;
		total_x.black_reqs_avg += totals[i].black_reqs_avg;
		total_x.black_nops_avg += totals[i].black_nops_avg;
		printf(PAT_TOTAL_LABEL, i);
		print_total(&totals[i], 1);
	}
	printf(PAT_TOTAL_LABEL_STR, "total");
	print_total(&total_x, 1);

	printf("\n    pass  bad password\n");
	printf("      ID  unknown ID\n");
	printf("    A-BL  address blacklist\n");
	printf("   ID-BL  ID blacklist\n");
	printf("     BAD  too many requests or otherwise bad\n");
}



int
main(int argc, char **argv)
{
	int i;

	avg = 0;
	nonames = 0;
	quiet = 0;

	while ((i = getopt(argc, argv, "anvqgh:")) != -1) {
		switch (i) {
		case 'a':
			++avg;
			break;

		case 'n':
			nonames = 1;
			break;

		case 'q':
			quiet = 1;
			break;

		case 'v':
			verbose = 1;
			break;

		case 'g':
			grey_on = 1;
			break;

		case 'h':
			homedir = optarg;
			break;

		default:
			usage();
		}
	}
	argc -= optind;
	argv += optind;

	if (verbose && quiet) {
		fprintf(stderr, "-q and -v are incompatible\n");
		exit(1);
	}

	if (!dcc_cdhome(0, homedir, 1) && homedir)
		dcc_cdhome(0, homedir = 0, 1);

	if (argc == 0) {
		dump_file(CLIENTS_NM());
	} else {
		for (i = 0; i < argc; ++i) {
			dump_file(argv[i]);
		}
	}

	exit(0);
}
