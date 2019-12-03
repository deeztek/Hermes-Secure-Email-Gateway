/* Distributed Checksum Clearinghouse
 *
 * list whiteclnt hash table
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
 * Rhyolite Software DCC 2.3.167-1.86 $Revision$
 */

#include "dcc_defs.h"
#include "dcc_ck.h"
#include "dcc_xhdr.h"
#include <arpa/inet.h>

static DCC_EMSG dcc_emsg;
static const char *homedir;

static u_char quiet;

static const char *ts2buf(time_t);


static void DCC_NORET
usage(void)
{
	dcc_logbad(EX_USAGE, "usage: [-VPQ] [-h homedir] [-t env_to] file");
}



int
main(int argc, char **argv)
{
	const char *to = 0;
	u_char print_version = 0;
	u_char first;
	DCC_PATH tmp;
	WHITE_INX inx, inx2;
	const char *nm;
	DCC_SUM sum;
	struct stat ht_sb, ascii_sb, inc_sb;
	char tgts_buf[20];
	char range_buf[INET6_ADDRSTRLEN+1+INET6_ADDRSTRLEN+1];
	int col;
	u_char heading;
	DCC_TGTS tgts;
	WHITE_LISTING listing;
	DCC_CK_TYPES type;
	int i;

	dcc_syslog_init(0, argv[0], 0);
	dcc_clnt_debug = 99;

	wf_init(&cmn_wf, WF_WLIST | WF_EITHER);

	while ((i = getopt(argc, argv, "VPQqh:t:")) != EOF) {
		switch (i) {
		case 'V':
			dcc_version_print();
			print_version = 1;
			break;

		case 'P':		/* parse or rebuild hash table */
			cmn_wf.wf_flags &= ~WF_WLIST_RO;
			cmn_wf.wf_flags |= WF_WLIST_RW;
			break;

		case 'Q':		/* query; don't rebuild hash table */
			cmn_wf.wf_flags &= ~WF_WLIST_RW;
			cmn_wf.wf_flags |= WF_WLIST_RO;
			break;

		case 'q':
			quiet = 1;
			break;

		case 'h':
			homedir = optarg;
			break;

		case 't':
			to = optarg;
			break;

		default:
			usage();
		}
	}
	argc -= optind;
	argv += optind;
	if (argc == 0) {
		if (print_version)
			exit(EX_OK);
		usage();
	}

	if (!dcc_cdhome(0, homedir, 1) && homedir)
		dcc_cdhome(0, homedir = 0, 1);

	first = 1;
	while ((nm = *argv++) != 0) {
		if (first) {
			first = 0;
		} else {
			printf("\n\n--------------------------------\n");
		}

		if (cmn_wf.wf_flags & WF_WLIST_RO)
			cmn_wf.wf_flags |= WF_RO;
		else
			cmn_wf.wf_flags &= ~WF_RO;

		if (!dcc_new_white_nm(&dcc_emsg, &cmn_wf, nm)) {
			dcc_error_msg("%s", dcc_emsg.c);
			exit(EX_DATAERR);
		}
		printf("%s\n", dcc_fnm2abs_msg(&tmp, cmn_wf.ascii_nm.c));

		/* try to force re-parsing */
		if (cmn_wf.wf_flags & WF_WLIST_RW) {
			if (!new_ht_nm(&dcc_emsg, &cmn_wf, 0)
			    || 0 > unlink_white_ht(&dcc_emsg, &cmn_wf,
						   time(0))) {
				dcc_error_msg("-P failed to force re-parsing;"
					      " %s",
					      dcc_emsg.c);
				exit(EX_DATAERR);
			}
			if (!dcc_new_white_nm(&dcc_emsg, &cmn_wf, nm)) {
				dcc_error_msg("%s", dcc_emsg.c);
				exit(EX_DATAERR);
			}
		}

		switch (wf_rdy(&dcc_emsg, &cmn_wf, &cmn_tmp_wf)) {
		case WHITE_OK:
			break;
		case WHITE_NOFILE:
			dcc_error_msg("does %s exist?", nm);
			exit(EX_DATAERR);
			break;
		case WHITE_CONTINUE:
			dcc_error_msg("%s", dcc_emsg.c);
			break;
		case WHITE_SILENT:
		case WHITE_COMPLAIN:
			dcc_error_msg("%s", dcc_emsg.c);
			exit(EX_DATAERR);
			break;
		}
		printf("%s\n", cmn_wf.wtbl->magic);

		if (to) {
			str2ck(&sum, 0, 0, to);
			printf("%s\n%8s %s\t",
			       to,
			       type2str_err(DCC_CK_ENV_TO, 0, 0, 0),
			       ck2str_err(DCC_CK_ENV_TO, &sum, 0));
			if (WHITE_OK != wf_sum(&dcc_emsg, &cmn_wf,
					       DCC_CK_ENV_TO, &sum,
					       &tgts, &listing)) {
				dcc_error_msg("%s", dcc_emsg.c);
			}
			if (listing == WHITE_UNLISTED) {
				printf("unlisted\n");
			} else {
				printf("%s\n",
				       tgts2str(tgts_buf, sizeof(tgts_buf),
						tgts, 0));
			}
			continue;
		}

		printf("  %s whitelist  %d entries\n",
		       (cmn_wf.wtbl_fgs & WHITE_FG_PER_USER)
		       ? "per-user" : "global",
		       cmn_wf.wtbl->hdr.entries);

		if (0 > fstat(cmn_wf.ht_fd, &ht_sb)) {
			dcc_error_msg("stat(%s): %s",
				      cmn_wf.ht_nm.c, ERROR_STR());
			exit(EX_DATAERR);
		}

		if (0 > stat(cmn_wf.ascii_nm.c, &ascii_sb)) {
			dcc_error_msg("stat(%s): %s",
				      cmn_wf.ascii_nm.c, ERROR_STR());
		} else if (ht_sb.st_mtime < ascii_sb.st_mtime) {
			printf("    %s is older than %s\n",
			       cmn_wf.ht_nm.c, cmn_wf.ascii_nm.c);
		}

		if (cmn_wf.wtbl->hdr.ascii_mtime == 0) {
			printf("    %s broken\n", cmn_wf.ht_nm.c);
		} else if (cmn_wf.wtbl->hdr.ascii_mtime != ascii_sb.st_mtime) {
			printf("    %s has timestamp %s\n"
			       "\tfor %s which has mtime %s\n",
			       cmn_wf.ht_nm.c,
			       ts2buf(cmn_wf.wtbl->hdr.ascii_mtime),
			       cmn_wf.ascii_nm.c,
			       ts2buf(ascii_sb.st_mtime));
		}

		if (cmn_wf.wtbl->hdr.broken != 0)
			printf("    %s broken until %s\n",
			       cmn_wf.ht_nm.c,
			       ts2buf(cmn_wf.wtbl->hdr.broken));
		if (cmn_wf.wtbl->hdr.reparse != 0)
			printf("    re-parse %s for errors after %s\n",
			       cmn_wf.ascii_nm.c,
			       ts2buf(cmn_wf.wtbl->hdr.reparse));

		if (cmn_wf.wtbl->hdr.fgs & WHITE_FG_HOSTNAMES) {
			printf("    resolve host names after %s\n",
			       ts2buf(ht_sb.st_mtime + DCC_WHITECLNT_RESOLVE));
		} else if (!(cmn_wf.wtbl->hdr.fgs & WHITE_FG_PER_USER)) {
			printf("    contains no host names\n");
		}

		for (i = 0; i < DIM(cmn_wf.wtbl->hdr.white_incs); ++i) {
			if (cmn_wf.wtbl->hdr.white_incs[i].nm.c[0] == '\0')
				break;
			if (!i)
				printf("    includes\n");
			printf("      %s\n",
			       dcc_fnm2abs_msg(&tmp,
					       cmn_wf.wtbl ->hdr.white_incs[
							i].nm.c));
			if (0 > stat(cmn_wf.wtbl->hdr.white_incs[i].nm.c,
				     &inc_sb)) {
				dcc_error_msg("stat(%s): %s",
					      cmn_wf.ascii_nm.c, ERROR_STR());
			} else if (ht_sb.st_mtime < inc_sb.st_mtime) {
				printf("    %s is older than %s"
				       " and needs rebuilding\n",
				       cmn_wf.ht_nm.c,
				       dcc_path2fnm(cmn_wf.wtbl->hdr
						    .white_incs[i].nm.c));
			}
		}
		if (cmn_wf.wtbl_sws & WHITE_SW_DCC_ON)
			printf("    option DCC-on\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_DCC_OFF)
			printf("    option DCC-off\n");

		if (cmn_wf.wtbl_sws & WHITE_SW_REP_ON)
			printf("    option dcc-rep-on\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_REP_OFF)
			printf("    option dcc-rep-off\n");

		if (cmn_wf.wtbl_sws & WHITE_SW_GREY_ON)
			printf("    option greylist-on\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_GREY_OFF)
			printf("    option greylist-off\n");

		if (cmn_wf.wtbl_sws & WHITE_SW_GREY_SPAM_ON)
			printf("    option greylist-ignore-spam-on\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_GREY_SPAM_OFF)
			printf("    option greylist-ignore-spam-off\n");

		if (cmn_wf.wtbl_sws & WHITE_SW_LOG_ALL)
			printf("    option log-all\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_LOG_NORMAL)
			printf("    option log-normal\n");

		if (cmn_wf.wtbl_sws & WHITE_SW_LOG_D)
			printf("    option log-subdirectory-day\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_LOG_H)
			printf("    option log-subdirectory-hour\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_LOG_M)
			printf("    option log-subdirectory-minute\n");


		if (cmn_wf.wtbl_sws & WHITE_SW_GREY_LOG_ON)
			printf("    option greylist-log-on\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_GREY_LOG_OFF)
			printf("    option greylist-log-off\n");

		if (cmn_wf.wtbl_sws & WHITE_SW_MTA_FIRST)
			printf("    option MTA-first\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_MTA_LAST)
			printf("    option MTA-last\n");

		for (i = 0; i < NUM_DNSBL_GROUPS; ++i) {
			if (cmn_wf.wtbl_sws & WHITE_SW_DNSBL_ON(i))
				printf("    option DNSBL%d-on\n", i+1);
			if (cmn_wf.wtbl_sws & WHITE_SW_DNSBL_OFF(i))
				printf("    option DNSBL%d-off\n", i+1);
		}

		if (cmn_wf.wtbl_sws & WHITE_SW_DISCARD_OK)
			printf("    option forced-discard-ok\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_DISCARD_NO)
			printf("    option no-forced-discard\n");

		if (cmn_wf.wtbl_sws & WHITE_SW_TRAP_NOT)
			printf("    option "DCC_XHDR_TRAP_NOT"\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_TRAP_DIS)
			printf("    option "DCC_XHDR_TRAP_DIS"\n");
		if (cmn_wf.wtbl_sws & WHITE_SW_TRAP_REJ)
			printf("    option "DCC_XHDR_TRAP_REJ"\n");

		for (type = DCC_CK_TYPE_FIRST;
		     type <= DCC_CK_TYPE_LAST;
		     ++type) {
			tgts = cmn_wf.wtbl->hdr.tholds_rej.t[type];
			if (tgts == THOLD_UNSET)
				continue;
			printf("    option threshold %s,%s\n",
			       type2str_err(type, 0, 0, 0),
			       thold2str(tgts_buf, sizeof(tgts_buf),
					 type, tgts));
		}

		printf("\n    file checksum %s\n",
		       ck2str_err(0, &cmn_wf.wtbl->hdr.ck_sum, 0));

		if (quiet)
			continue;

		/* display ranges of IP addresses */
		heading = 0;
		for (i = 0; i < cmn_wf.wtbl->hdr.ranges.len; ++i) {
			WHITE_IP_RANGE *r;

			if (!heading) {
				heading = 1;
				fputs("\n IP address blocks\n", stdout);
			}
			r = &cmn_wf.wtbl->hdr.ranges.rs[i];
			printf("%6s  %s\n",
			       tgts2str(tgts_buf, sizeof(tgts_buf), r->tgts, 0),
			       range2str(range_buf, sizeof(range_buf),
					 &r->range));
		}
		if (heading)
			putchar('\n');

		/* first the hash table */
		fputs("\n hash table\n", stdout);
		col = 0;
		for (inx = 0; inx < DIM(cmn_wf.wtbl->bins); ++inx) {
			if (!cmn_wf.wtbl->bins[inx]
			    && col == 0
			    && inx != 0) {
				inx2 = inx;
				while (inx2 < DIM(cmn_wf.wtbl->bins)
				       && !cmn_wf.wtbl->bins[inx2])
					++inx2;
				i = inx2 - inx;
				i -= i % 4;
				if (i != 0) {
					printf(" ...\n");
					inx += i;
				}
			}
			printf("%4d:", inx);
			if (cmn_wf.wtbl->bins[inx]) {
				printf("%-4d", cmn_wf.wtbl->bins[inx]);
			} else {
				printf("    ");
			}
			col = (col + 1) % 4;
			putchar(col == 0 ? '\n' : '\t');
		}

		/* then the entries */
		printf("\n\n%4s->%-4s  %12s  %6s\n",
		       "slot", "next", "type", "count");
		for (inx = 0; inx < cmn_wf.wtbl_entries; ++inx) {
			WHITE_ENTRY *e = &cmn_wf.wtbl->tbl[inx];
			if (e->type == DCC_CK_INVALID)
				continue;
			printf("%4d->%-4d  %12s  %6s  %s\n",
			       inx, e->fwd,
			       type2str_err(e->type, 0, 0, 0),
			       tgts2str(tgts_buf, sizeof(tgts_buf), e->tgts, 0),
			       ck2str_err(e->type, &e->sum, 0));
		}
	}
	exit(EX_OK);
}



static const char *
ts2buf(time_t ts)
{
	static struct {
		char buf[26];
	} times[4];
	static int nbuf;

	nbuf = (nbuf+1) % DIM(times);
	return dcc_time2str(times[nbuf].buf, sizeof(times[nbuf].buf),
			    "%b %d %X %Z", ts);
}
