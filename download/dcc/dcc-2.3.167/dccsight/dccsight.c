/* Distributed Checksum Clearinghouse server
 *
 * report the previously computed checksums of a message
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
 * Rhyolite Software DCC 2.3.167-1.84 $Revision$
 */

#include "dcc_ck.h"
#include "dcc_xhdr.h"


static DCC_EMSG dcc_emsg;

static const char *homedir;
static const char *mapfile_nm = DCC_MAP_NM_DEF;

static char *local_tgts_str;
static DCC_TGTS local_tgts = 1;
static u_char local_tgts_spam, local_tgts_set;

static const char* white_nm;
static const char *ifile_nm;
static FILE *ifile;
static const char *grey_sum;

static DCC_CLNT_CTXT *ctxt;
static u_char print_cksums;

static ASK_ST ask_st;
static FLTR_SWS rcpt_sws;

static GOT_CKS cks;
static CKS_WTGTS wtgts;
static u_char have_sum;

static DCC_HEADER_BUF header;

/* kludges to avoid linking with dnsbl.c */
DNSBL *dnsbls;
u_char have_dnsbl_groups;

static void do_grey(void);
static int add_cksum(DCC_EMSG *, WF *, DCC_CK_TYPES, DCC_SUM *, DCC_TGTS);
static void print_ck(void *arg, const char *, u_int);


static void DCC_NORET
usage(void)
{
	dcc_logbad(EX_USAGE,
		   "usage: [-VdCPQ] [-h homedir] [-m map] [-w whiteclnt]"
		   " [-t targets]\n"
		   "   [-c type,[log-thold,][spam-thold]] [-g [not-]type]\n"
		   "   [-i infile] [-G grey-cksum] [-L ltype,facility.level]");
}



int
main(int argc, char **argv)
{
	u_char print_version = 0;
	char buf[200];
	const char *bufp;
	char type_str[DCC_XHDR_MAX_TYPE_LEN_BUF];
	DCC_CK_TYPES type;
	u_long l;
	int lineno;
	u_char skip_heading, result;
	char c1, c2, *p;
	int i;

	dcc_syslog_init(0, argv[0], 0);
	dcc_clear_tholds();

	/* we must be SUID to read and write the system's common connection
	 * parameter memory mapped file.  We also need to read the common
	 * local white list and write the mmap()'ed hash file */
	dcc_init_priv();

	ifile = stdin;
	while ((i = getopt(argc, argv, "VdCPQh:m:w:t:c:g:i:G:L:")) != -1) {
		switch (i) {
		case 'V':
			dcc_version_print();
			print_version = 1;
			break;

		case 'd':
			++dcc_clnt_debug;
			break;

		case 'P':
			spamassassin_body_kludge = 0;
			break;

		case 'Q':
			ask_st |= ASK_ST_QUERY;
			break;

		case 'C':
			print_cksums = 1;
			break;

		case 'h':
			homedir = optarg;
			break;

		case 'm':
			mapfile_nm = optarg;
			break;

		case 'w':
			white_nm = optarg;
			break;

		case 't':
			local_tgts_str = optarg;
			if (!strcasecmp(optarg, "many")) {
				local_tgts_spam = 1;
				local_tgts = 1;
				local_tgts_set = 1;
			} else {
				l = strtoul(optarg, &p, 10);
				if (*p != '\0' || l > 1000)
					dcc_error_msg("invalid count \"%s\"",
						      optarg);
				else
					local_tgts = l;
					local_tgts_spam = 0;
					local_tgts_set = 1;
			}
			break;

		case 'c':
			dcc_parse_tholds("-c ", optarg);
			break;

		case 'g':		/* honor not-spam "counts" */
			dcc_parse_honor(optarg);
			break;

		case 'i':
			/* open the input file now, before changing to the
			 * home DCC directory */
			ifile_nm = optarg;
			ifile = fopen(ifile_nm, "r");
			if (!ifile)
				dcc_logbad(EX_USAGE,
					   "bad input file \"%s\": %s",
					   ifile_nm, ERROR_STR());
			break;

		case 'G':
			grey_sum = optarg;
			break;

		case 'L':
			dcc_parse_log_opt(optarg);
			break;

		default:
			usage();
		}
	}
	argc -= optind;
	argv += optind;
	if (argc != 0)
		usage();

	if (print_version)
		exit(EX_OK);

	dcc_clnt_unthread_init();
	if (!dcc_cdhome(0, homedir, 1) && homedir)
		dcc_cdhome(0, homedir = 0, 1);

	/* open /var/dcc/map and start a connection to a DCC server */
	ctxt = dcc_clnt_init(&dcc_emsg, 0, mapfile_nm, DCC_CLNT_FG_NONE);
	if (!ctxt)
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);

	if (grey_sum) {
		if (ifile_nm)
			dcc_logbad(EX_USAGE, "-i and -G incompatible");
		do_grey();
	}

	/* get the checksums */
	skip_heading = 0;
	lineno = 0;
	for (;;) {
		bufp = fgets(buf, sizeof(buf), ifile);
		if (!bufp) {
			if (ferror(ifile))
				dcc_logbad(EX_DATAERR, "fgets(%s): %s",
					   ifile_nm ? ifile_nm : "stdin",
					   ERROR_STR());
			break;
		}

		++lineno;

		/* ignore blank lines */
		i = strlen(buf);
		if (!i) {
			skip_heading = 0;
			continue;
		}

		/* trim leading and trailing whitespace */
		p = &buf[i-1];
		bufp += strspn(bufp, DCC_WHITESPACE);
		c2 = *p;		/* should be '\n' */
		while (p > bufp) {
			c1 = *(p-1);
			if (c1 != '\r' && c1 != ' ' && c1 != '\t')
				break;
			*--p = c2;
		}
		if (*bufp == '\n' || *bufp == '\0') {
			skip_heading = 0;
			continue;
		}

		/* ignore DCC header lines such as in the output
		 * of `dccproc -C` */
		if (skip_heading == 0
		    && !CLITCMP(bufp, DCC_XHDR_START)) {
			skip_heading = 1;
			continue;
		}
		/* skip headings for the checksums */
		if (skip_heading <= 1
		    && !CLITCMP(bufp, DCC_XHDR_REPORTED)) {
			skip_heading = 2;
			continue;
		}

		/* handle the next checksum */
		bufp = dcc_parse_word(&dcc_emsg, type_str, sizeof(type_str),
				      bufp, "checksum type", ifile_nm, lineno);
		if (!bufp)
			dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);
		type = dcc_str2type_wf(type_str, -1);
		if (type != DCC_CK_ENV_TO
		    && 0 >= dcc_parse_hex_ck(&dcc_emsg, &cmn_wf,
					     type_str, type,
					     bufp, 1, add_cksum))
			dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);
	}
	fclose(ifile);

	if (!have_sum)
		dcc_logbad(EX_DATAERR, "no reportable checksums");

	wf_init(&cmn_wf, 0);
	if (!unthr_ask_white(&dcc_emsg, &ask_st, &rcpt_sws,
			     white_nm, &cks, &wtgts))
		dcc_error_msg("%s", dcc_emsg.c);

	if (!local_tgts_set) {
		local_tgts = (ask_st & ASK_ST_QUERY) ? 0 : 1;
		local_tgts_spam = 0;
	} else if (local_tgts == 0) {
		ask_st |= ASK_ST_QUERY;
		local_tgts_spam = 0;
	} else if (ask_st & ASK_ST_QUERY) {
		dcc_error_msg("\"-t %s\" is incompatible with \"-Q\"",
			      local_tgts_str);
		local_tgts = 0;
		local_tgts_spam = 0;
	}
	if (local_tgts == DCC_TGTS_TOO_MANY) {
		local_tgts = 1;
		local_tgts_spam = 1;
	}
	if (local_tgts != 0
	    && (ask_st & ASK_ST_CLNT_ISSPAM))
		local_tgts_spam = 1;

	result = unthr_ask_dcc(&dcc_emsg, ctxt, &header, &ask_st, 0,
			       &cks, local_tgts_spam, local_tgts);
	if (!result) {
		dcc_error_msg("%s", dcc_emsg.c);
	} else if (header.buf[0] != '\0') {
		printf("%s", header.buf);
	} else if (dcc_clnt_debug) {
		if (ask_st & ASK_ST_WLIST_NOTSPAM)
			printf("no header; checksums are locally whitelisted");
		else
			printf("no header");
	}

	if (print_cksums)
		print_cks(print_ck, 0, (ask_st & ASK_ST_RPT_SPAM) != 0,
			  local_tgts, &cks, &cks.tholds_rej, &wtgts);

	exit(EX_OK);
}



static void DCC_NORET
do_grey(void)
{
	union {
	    u_int32_t n[4];
	    DCC_SUM sum;
	} u;
	DCC_REPORT rpt;
	DCC_OP_RESP resp;

	if (4 != sscanf(grey_sum, DCC_CKSUM_HEX_PAT,
			&u.n[0], &u.n[1], &u.n[2], &u.n[3]))
		dcc_logbad(EX_USAGE,
			   "unrecognized greylist checksum");
	u.n[0] = htonl(u.n[0]);
	u.n[1] = htonl(u.n[1]);
	u.n[2] = htonl(u.n[2]);
	u.n[3] = htonl(u.n[3]);

	memset(&rpt, 0, sizeof(rpt));
	rpt.cks[0].sum = u.sum;
	rpt.cks[0].type = DCC_CK_GREY3;
	rpt.cks[0].len = sizeof(rpt.cks[0]);
	if (!dcc_clnt_op(&dcc_emsg, ctxt, DCC_CLNT_FG_GREY, 0, 0, 0,
			 &rpt.hdr, (sizeof(rpt) - sizeof(rpt.cks)
				    + sizeof(rpt.cks[0])),
			 (ask_st & ASK_ST_QUERY)
			 ? DCC_OP_GREY_QUERY : DCC_OP_GREY_WHITE,
			 &resp, sizeof(resp)))
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);

	if (!dcc_ck_grey_answer(&dcc_emsg, &resp))
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);

	switch (ntohl(resp.gans.triple)) {
	case DCC_TGTS_OK:		/* embargo ended just now */
		printf(DCC_XHDR_EMBARGO_ENDED"\n");
		break;
	case DCC_TGTS_TOO_MANY:		/* no current embargo */
		printf(DCC_XHDR_EMBARGO_PASS"\n");
		break;
	case DCC_TGTS_GREY_WHITE:	/* whitelisted for greylisting */
		printf(DCC_XHDR_EMBARGO_OK"\n");
		break;
	default:			/* embargoed */
		printf(DCC_XHDR_EMBARGO"\n");
		break;
	}
	exit(EX_OK);
}



static int
add_cksum(DCC_EMSG *emsg, WF *wf DCC_UNUSED,
	  DCC_CK_TYPES type, DCC_SUM *sum, DCC_TGTS tgts)
{
	static DCC_SUM zero;

	if (cks.sums[type].type != DCC_CK_INVALID
	    && type != DCC_CK_SUB) {
		dcc_pemsg(EX_DATAERR, emsg, "duplicate %s checksum",
			  type2str_err(type, 0, 0, 0));
	}

	/* envelope Rcpt_To values are never sent to the server */
	if (type == DCC_CK_ENV_TO)
		return 1;

	/* do not send FUZ2 missing checksum */
	if (type == DCC_CK_FUZ2
	    && !memcmp(&sum, &zero, sizeof(zero)))
		return 1;

	cks.sums[type].sum = *sum;
	cks.sums[type].type = type;
	cks.sums[type].rpt2srvr = 1;
	cks.sums[type].tgts = DCC_TGTS_INVALID;
	if (tgts)
		have_sum = 1;
	return 1;
}



static void
print_ck(void *arg DCC_UNUSED, const char *buf, u_int buf_len)
{
	(void)fwrite(buf, buf_len, 1, stdout);
}
