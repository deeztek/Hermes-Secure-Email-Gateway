/* Distributed Checksum Clearinghouse server
 *
 * report a message for such as procmail
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
 * Rhyolite Software DCC 2.3.167-1.216 $Revision$
 */

#include "dcc_ck.h"
#include "dcc_xhdr.h"
#include "dcc_heap_debug.h"
#include <signal.h>			/* for Linux and SunOS*/
#ifndef DCC_WIN32
#include <arpa/inet.h>
#endif


static DCC_EMSG dcc_emsg;

static const char *mapfile_nm = DCC_MAP_NM_DEF;

static u_char priv_logdir;
static DCC_PATH log_path;
static int lfd = -1;
static struct timeval ldate;

static u_char logging = 1;		/* 0=no log, 1=have file, 2=used it */
static size_t log_size;

static char id[MSG_ID_LEN+1];
static DCC_PATH tmp_nm;
static int tmp_fd = -1;
static u_char tmp_rewound;
static int hdrs_len, body_len;
static u_char seen_hdr;

static int exit_code = EX_NOUSER;
static DCC_TGTS local_tgts;
static u_char local_tgts_spam, local_tgts_set;
static int total_hdrs, cr_hdrs;

static const char* white_nm;
static const char *ifile_nm = "stdin", *ofile_nm = "stdout";
static FILE *ifile, *ofile;

static DCC_CLNT_CTXT *ctxt;
static char xhdr_fname[sizeof(DCC_XHDR_START)+sizeof(DCC_BRAND)+1];
static int xhdr_fname_len;
static u_char add_xhdr;			/* add instead of replace header */
static u_char cksums_only;		/* output only checksums */
static u_char x_dcc_only;		/* output only the X-DCC header */
static u_char fake_envelope;		/* fake envelope log lines */
static int std_received;		/* Received: line is standard */

static ASK_ST ask_st;
static FLTR_SWS rcpt_sws;
static GOT_CKS cks;
static CKS_WTGTS wtgts;
static char helo[HELO_MAX];
static char sender_name[DCC_MAXDOMAINLEN];
static char sender_str[INET6_ADDRSTRLEN];
static u_char sender_set;
static struct in6_addr clnt_addr;

static char env_from_buf[HDR_CK_MAX+1];
static const char *env_from = 0;

static char mail_host[DCC_MAXDOMAINLEN];

static DCC_HEADER_BUF header;

static EARLY_LOG early_log;

static void start_dccifd(void);
static u_char check_mx_listing(void);
static int get_hdr(char *, int);
static void add_hdr(void *, const char *, u_int);
static void tmp_write(const void *, int);
static void tmp_close(void);
static void scopy(int, u_char);
static void log_write(const void *, int);
static void log_body_write(const char *, u_int);
static void thr_log_write(void *, const char *, u_int);
static void log_late(void);
static int log_print(u_char, const char *, ...) DCC_PF(2,3);
#define LOG_CAPTION(s) log_write((s), LITZ(s))
#define LOG_EOL() LOG_CAPTION("\n")
static void log_fin(void);
static void log_ck(void *, const char *, u_int);
static void dccproc_error_msg(const char *, ...) DCC_PF(1,2);
static void sigterm(int);


static const char *usage_str =
"[-VdAQCHEPR]  [-h homedir] [-m map] [-w whiteclnt] [-T tmpdir]\n"
"   [-a IP-address] [-f env_from] [-t targets] [-x exitcode]\n"
"   [-c type,[log-thold,][spam-thold]] [-g [not-]type] [-S header]\n"
"   [-i infile] [-o outfile] [-l logdir] [-B dnsbl-option]\n"
"   [-L ltype,facility.level]";

static void DCC_NORET
usage(const char* barg)
{
	if (barg) {
		dcc_logbad(EX_USAGE, "unrecognized \"%s\"\nusage: %s\n",
			   barg, usage_str);
	} else {
		dcc_logbad(EX_USAGE, "%s\n", usage_str);
	}
}



int
main(int argc, char **argv)
{
	u_char print_version = 0;
	char buf[20*HDR_CK_MAX];	/* at least HDR_CK_MAX*3 */
	u_char log_tgts_set = 0;
	u_char rep_tholds_set = 0;
	const char *homedir = 0;
	const char *logdir = 0;
	const char *tmpdir = 0;
	u_char ask_result;
	char *p;
	const char *p2;
	u_long l;
	int error, blen, i;

	/* because stderr is often mixed with stdout and effectively
	 * invisible, also complain to syslog */
	dcc_syslog_init(1, argv[0], 0);
	dcc_clear_tholds();

	/* get ready for the IP and From header checksums */
	cks_init(&cks);

	/* we must be SUID to read and write the system's common connection
	 * parameter memory mapped file.  We also need to read the common
	 * local white list and write the mmap()'ed hash file */
	dcc_init_priv();

	ofile = stdout;
	ifile = stdin;
	opterr = 0;
	while ((i = getopt(argc, argv, "VdAQCHEPR"
			   "r:h:m:w:T:a:f:g:S:t:x:c:i:o:l:B:L:")) != -1) {
		switch (i) {
		case 'V':
			dcc_version_print();
			print_version = 1;
			break;

		case 'd':
			++dcc_clnt_debug;
			break;

		case 'A':
			add_xhdr = 1;
			break;

		case 'Q':
			ask_st |= ASK_ST_QUERY;
			break;

		case 'C':
			cksums_only = 1;
			break;

		case 'H':
			x_dcc_only = 1;
			break;

		case 'E':
			fake_envelope = 1;
			break;

		case 'R':
			if (!std_received)
				std_received = 1;
			break;

		case 'P':
			spamassassin_body_kludge = 0;
			break;

		case 'r':		/* a bad idea replacment for -R */
			std_received = strtoul(optarg, &p, 10);
			if (*p != '\0' || i == 0) {
				dccproc_error_msg("invalid count"
						  " \"-e %s\"", optarg);
				std_received = 1;
			}
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

		case 'T':
			tmpdir = optarg;
			break;

		case 'a':
			/* ignore SpamAssassin noise */
			if (!strcmp("0.0.0.0", optarg))
				break;
			dcc_host_lock();
			if (!dcc_get_host(optarg, DCC_GETH_DEF, &error)) {
				dccproc_error_msg("\"-a %s\": %s",
						  optarg, H_ERROR_STR1(error));
			} else {
				get_ipv6_ck(&cks, dcc_su2ipv6(&clnt_addr, 1,
							&dcc_hostaddrs[0]));
				dcc_ipv6tostr(sender_str, sizeof(sender_str),
					      &clnt_addr);
				sender_set = 1;
			}
			dcc_host_unlock();
			break;

		case 'f':
			env_from = optarg;
			break;

		case 'g':		/* honor not-spam "counts" */
			dcc_parse_honor(optarg);
			break;

		case 'S':
			if (!dcc_add_sub_hdr(&dcc_emsg, optarg))
				dcc_logbad(EX_USAGE, "%s", dcc_emsg.c);
			break;

		case 't':
			if (!strcasecmp(optarg, "many")) {
				local_tgts = 1;
				local_tgts_spam = 1;
				local_tgts_set = 1;
			} else {
				l = strtoul(optarg, &p, 10);
				if (*p != '\0' || l > DCC_TGTS_RPT_MAX) {
					dccproc_error_msg("invalid count"
							" \"-t %s\"", optarg);
				} else {
					local_tgts = l;
					local_tgts_spam = 0;
					local_tgts_set = 1;
				}
			}
			break;

		case 'x':
			l = strtoul(optarg, &p, 10);
			if (*p != '\0') {
				dccproc_error_msg("invalid exit code \"-x %s\"",
						  optarg);
			} else {
				exit_code = l;
			}
			break;

		case 'c':
			if (dcc_parse_tholds("-c ", optarg))
				log_tgts_set = 1;
			if (tholds_rej.t[DCC_CK_REP_BULK] <= 100)
				rep_tholds_set = 1;
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

		case 'o':
			/* open the output file now, before changing to the
			 * home DCC directory */
			ofile_nm = optarg;
			ofile = fopen(ofile_nm, "w");
			if (!ofile)
				dcc_logbad(EX_USAGE,
					   "bad output file \"%s\": %s",
					   ofile_nm, ERROR_STR());
			break;

		case 'l':
			logdir = optarg;
			break;

		case 'B':
			if (!dcc_parse_dnsbl(&dcc_emsg, optarg, 0))
				dccproc_error_msg("%s", dcc_emsg.c);
			break;

#ifndef DCC_WIN32
		case 'L':
			dcc_parse_log_opt(optarg);
			break;
#endif

		default:
			usage(optopt2str(optopt));
		}
	}
	if (argc != optind)
		usage(argv[optind]);

	if (print_version)
		exit(EX_OK);

#ifdef SIGPIPE
	signal(SIGPIPE, SIG_IGN);
#endif
#ifdef SIGHUP
	signal(SIGHUP, sigterm);
#endif
	signal(SIGTERM, sigterm);
	signal(SIGINT, sigterm);
#ifdef SIGXFSZ
	signal(SIGXFSZ, SIG_IGN);
#endif

	/* Close STDERR to keep it from being mixed with the message,
	 * unless we are not going to output the message to STDOUT.
	 * Ensure that stderr and file descriptor 2 are open to something
	 * to prevent surprises from busybody libraries. */
	if (!dcc_clnt_debug && !cksums_only && !x_dcc_only && !ofile_nm) {
		close(STDERR_FILENO);
		dcc_clean_stdio();
	}

	dcc_clnt_unthread_init();
	if (!dcc_cdhome(0, homedir, 1) && homedir)
		dcc_cdhome(0, homedir = 0, 1);
	if (!dcc_main_logdir_init(&dcc_emsg, logdir)) {
		dcc_error_msg("%s", dcc_emsg.c);
		/* dccproc will not be around as a daemon
		 * when and if the log directory is created
		 * so forget about a directory that might
		 * someday be ok */
		dcc_main_logdir.c[0] = '\0';
	}
	tmp_path_init(tmpdir, logdir);

	if (dcc_main_logdir.c[0] == '\0') {
		if (log_tgts_set)
			dccproc_error_msg("log thresholds set with -c"
					  " but no -l directory");
		logging = 0;
	} else {
		/* use privileges to make log directories in the built-in home
		 * directory so that they have the right owner even if
		 * we are in a group such as www that could create directories */
		priv_logdir = dcc_get_priv_home(dcc_main_logdir.c);
		lfd = dcc_main_log_open(&dcc_emsg, &log_path, id, sizeof(id));
		if (priv_logdir)
			dcc_rel_priv();
		if (lfd < 0) {
			dccproc_error_msg("%s", dcc_emsg.c);
			logging = 0;
		}
	}

	if (fake_envelope && lfd >= 0) {
		char date_buf[40];

		gettimeofday(&ldate, 0);
		log_print(0, DCC_LOG_DATE_PAT"\n",
			  dcc_time2str(date_buf, sizeof(date_buf),
				       DCC_LOG_DATE_FMT, ldate.tv_sec));
	}

	if (!local_tgts_set) {
		local_tgts = (ask_st & ASK_ST_QUERY) ? 0 : 1;
		local_tgts_spam = 0;
	} else if (local_tgts == 0) {
		ask_st |= ASK_ST_QUERY;
		local_tgts_spam = 0;
	} else if (ask_st & ASK_ST_QUERY) {
		dcc_error_msg("\"-t %s\" is incompatible with \"-Q\"",
			      local_tgts_spam
			      ? "many"
			      : tgts2str(buf, sizeof(buf), local_tgts, 0));
		local_tgts = 0;
		local_tgts_spam = 0;
	}
	if (local_tgts == DCC_TGTS_TOO_MANY) {
		local_tgts = 1;
		local_tgts_spam = 1;
	}

	if (logging
	    || (!cksums_only && !x_dcc_only)) {
		tmp_fd = dcc_mkstemp(&dcc_emsg, &tmp_nm, id, sizeof(id), 0,
				     0, DCC_TMP_LOG_PREFIX, 1, 0);
		if (tmp_fd < 0)
			dcc_logbad(EX_IOERR, "%s", dcc_emsg.c);
	}

	/* start a connection to a DCC server
	 *	we need the server's name for the X-DCC header. */
	ctxt = dcc_clnt_start(&dcc_emsg, 0, mapfile_nm,
			      DCC_CLNT_FG_BAD_SRVR_OK
			      | DCC_CLNT_FG_NO_MEASURE_RTTS
			      | DCC_CLNT_FG_NO_FAIL);
	if (ctxt) {
		if (!homedir)
			start_dccifd();
		xhdr_fname_len = get_xhdr_fname(xhdr_fname, sizeof(xhdr_fname),
						dcc_clnt_info);
		dcc_emsg.c[0] = '\0';
		ctxt = dcc_clnt_start_fin(&dcc_emsg, ctxt);
	}
	if (!ctxt)
		dccproc_error_msg("%s", dcc_emsg.c);

	/* get the local whitelist ready */
	wf_init(&cmn_wf, WF_EITHER);
	if (white_nm
	    && !dcc_new_white_nm(&dcc_emsg, &cmn_wf, white_nm)) {
		dccproc_error_msg("%s", dcc_emsg.c);
		white_nm = 0;
	}
	/* Look past the SMTP client if it is a listed MX server
	 * Check even if we were not given the sender to ensure that
	 * the whiteclnt file is opened for its option switches even
	 * if we never find a good Received: header. */
	check_mx_listing();

	dcc_dnsbl_init(&cks, ctxt, 0, id);

	/* get the headers */
	for (;;) {
		int hlen;

		hlen = get_hdr(buf, sizeof(buf));
		if (hlen <= 2
		    && (buf[0] == '\n'
			|| (buf[0] == '\r' && buf[1] == '\n'))) {
			/* stop at the separator between the body and headers */
			if (!seen_hdr)
				dcc_logbad(EX_DATAERR,
					   "missing SMTP header lines");
			hdrs_len -= hlen;
			body_len = hlen;
			break;
		}

#define GET_HDR_CK(h,t) {						\
			if (!CLITCMP(buf, h)) {				\
				get_cks(&cks,DCC_CK_##t, &buf[LITZ(h)], 1);\
				seen_hdr = 1;				\
				continue;}}
		GET_HDR_CK(DCC_XHDR_TYPE_FROM":", FROM);
		GET_HDR_CK(DCC_XHDR_TYPE_MESSAGE_ID":", MESSAGE_ID);
#undef GET_HDR_CK

		/* notice UNIX From_ line */
		if (!seen_hdr
		    && !env_from
		    && parse_unix_from(buf, env_from_buf,
				       sizeof(env_from_buf))) {
			env_from = env_from_buf;
			seen_hdr = 1;
			continue;
		}

		if (!env_from && parse_return_path(buf, env_from_buf,
						   sizeof(env_from_buf))) {
			env_from = env_from_buf;
			seen_hdr = 1;
			continue;
		}

		if (!CLITCMP(buf, DCC_XHDR_TYPE_RECEIVED":")) {
			seen_hdr = 1;

			p2 = &buf[LITZ(DCC_XHDR_TYPE_RECEIVED":")];

			/* compute checksum of the last Received: header */
			get_cks(&cks, DCC_CK_RECEIVED, p2, 1);

			/* pick IP address out of Nth Received: header
			 * unless we had a good -a value */
			if (sender_set)
				continue;
			if (!std_received)
				continue;
			if (--std_received > 0)
				continue;

			p2 = parse_received(p2, &cks, helo, sizeof(helo),
					    sender_str, sizeof(sender_str),
					    sender_name, sizeof(sender_name));
			if (p2 == 0) {
				/* to avoid being fooled by forged Received:
				 * fields, do not skip unrecognized forms */
				std_received = 0;
			} else if (*p2 != '\0') {
				log_print(1, "skip %s Received: header\n", p2);
				std_received = 1;
			} else {
				std_received = check_mx_listing();
			}
			continue;
		}

		/* Notice MIME multipart boundary definitions */
		ck_mime_hdr(&cks, buf, 0);

		if (ck_get_sub(&cks, buf, 0))
			seen_hdr = 1;

		/* notice any sort of header */
		if (!seen_hdr) {
			for (p = buf; ; ++p) {
				if (*p == ':') {
					seen_hdr = 1;
					break;
				}
				if (*p <= ' ' || *p >= 0x7f)
					break;
			}
		}
	}
	/* Create a checksum for a null Message-ID header if there
	 * was no Message-ID header.  */
	if (cks.sums[DCC_CK_MESSAGE_ID].type != DCC_CK_MESSAGE_ID)
		get_cks(&cks, DCC_CK_MESSAGE_ID, "", 0);

	/* Check DNS blacklists for STMP client and envelope sender
	 * before collecting the body to avoid wasting time DNS resolving
	 * URLs if the envelope answers the question.  Much of the DNS
	 * work for the envelope has probably already been done. */
	if (cks.sums[DCC_CK_IP].type == DCC_CK_IP)
		dcc_client_dnsbl(cks.dlw, &cks.ip_addr, sender_name);

	if (env_from) {
		get_cks(&cks, DCC_CK_ENV_FROM, env_from, 1);
		if (parse_mail_host(env_from, mail_host, sizeof(mail_host))) {
			ck_get_sub(&cks, "mail_host", mail_host);
			dcc_mail_host_dnsbl(cks.dlw, mail_host);
		}
	}

	/* collect the body */
	do {
		blen = fread(buf, 1, sizeof(buf), ifile);
		if (blen != sizeof(buf)) {
			if (ferror(ifile))
				dcc_logbad(EX_DATAERR, "fgets(%s): %s",
					   ifile_nm, ERROR_STR());
			if (!blen)
				break;
		}

		tmp_write(buf, blen);
		body_len += blen;
		ck_body(&cks, buf, blen);
	} while (!feof(ifile));
	fclose(ifile);

	cks_fin(&cks);

	if (!unthr_ask_white(&dcc_emsg, &ask_st, &rcpt_sws,
			     white_nm, &cks, &wtgts))
		dccproc_error_msg("%s", dcc_emsg.c);

	dcc_dnsbl_result(&ask_st, cks.dlw);

	/* Unlike dccm and dccifd, no "option DNSBL-on" line is required in
	 * the whiteclnt file.  A -B argument is sufficient to show that
	 * DNS white- or blacklist filtering is wanted. */
	if (ASK_ST_DNSBL_B_BITS(ask_st) != 0)
		ask_st |= (ASK_ST_CLNT_ISSPAM | ASK_ST_LOGIT);
	if (ASK_ST_DNSBL_W_BITS(ask_st) != 0)
		ask_st |= ASK_ST_WLIST_NOTSPAM;

	/* Unlike dccm and dccifd, an "option DCC-rep-on" line is not required
	 * provided the reputation thresholds are set on the command line.
	 * Setting them in the -wwhiteclnt file is not enough, because
	 * the file might be shared with a dccifd or dccm user that wants
	 * reputations off. */
	if (rep_tholds_set && !(cmn_wf.wtbl_sws & WHITE_SW_REP_OFF))
		rcpt_sws |= FLTR_SW_REP_ON;

	if (ctxt) {
		if (ask_st & ASK_ST_QUERY) {
			local_tgts_spam = 0;
			local_tgts = 0;
		}
		if (local_tgts != 0
		    && (ask_st & ASK_ST_CLNT_ISSPAM))
			local_tgts_spam = 1;

		ask_result = unthr_ask_dcc(&dcc_emsg, ctxt, &header, &ask_st,
					   rcpt_sws,
					   &cks, local_tgts_spam, local_tgts);
		if (!ask_result)
			dccproc_error_msg("%s", dcc_emsg.c);
	}

	if (fake_envelope && lfd >= 0) {
		if (sender_str[0] != '\0') {
			LOG_CAPTION(DCC_LOG_IP1);
			log_write(sender_name, strlen(sender_name));
			LOG_CAPTION(DCC_LOG_IP2);
			log_write(sender_str, strlen(sender_str));
			LOG_EOL();
		}
		if (helo[0] != '\0') {
			LOG_CAPTION(DCC_LOG_HELO);
			log_write(helo, strlen(helo));
			LOG_EOL();
			ck_get_sub(&cks, "helo", helo);
		}
		if (env_from) {
			LOG_CAPTION(DCC_XHDR_TYPE_ENV_FROM": ");
			log_write(env_from, strlen(env_from));
			LOG_CAPTION(DCC_LOG_MAIL_HOST);
			log_write(mail_host, strlen(mail_host));
			LOG_EOL();
		}
		LOG_EOL();
	}

	/* copy the headers to the log file and the output */
	scopy(hdrs_len, 1);

	/* emit the X-DCC and external filter headers
	 *	End them with "\r\n" if at least half of the header lines
	 *	ended that way.  Otherwise use "\n" */
	if (header.buf[0] != '\0')
		xhdr_write(add_hdr, 0, header.buf, header.used,
			   cr_hdrs > total_hdrs/2);

	/* emit body */
	scopy(body_len, 1);

	LOG_CAPTION(DCC_LOG_MSG_SEP);

	log_late();

	/* make the log file look like a dccm or dccifd log file */
	if (fake_envelope) {
		DCC_PATH abs_nm;

		if (ask_st & ASK_ST_WLIST_NOTSPAM)
			log_print(0, "%s"DCC_XHDR_ISOK"\n",
				  dcc_fnm2abs_msg(&abs_nm, white_nm));
		else if (ask_st & ASK_ST_WLIST_ISSPAM)
			log_print(0, "%s%s\n",
				  dcc_fnm2abs_msg(&abs_nm, white_nm),
				  (rcpt_sws & FLTR_SW_TRAP_DIS)
				  ? "-->"DCC_XHDR_TRAP_DIS
				  : (rcpt_sws & FLTR_SW_TRAP_REJ)
				  ? "-->"DCC_XHDR_TRAP_REJ
				  : DCC_XHDR_ISSPAM);
		log_ask_st(thr_log_write, 0, ask_st, rcpt_sws, rcpt_sws,
			   0, &header);
	}

	/* log error message for most prematurely closed output pipes before
	 * logging the checksums or sending them to the pipe for -C */
	if (EOF == fflush(ofile)) {
		dcc_error_msg("fflush(%s): %s", ofile_nm, ERROR_STR());
		fclose(ofile);
		ofile = 0;
	}

	print_cks(log_ck, 0, (ask_st & ASK_ST_RPT_SPAM) != 0, local_tgts,
		  &cks, &cks.tholds_rej, &wtgts);

	if (ofile) {
		if (fclose(ofile))
			dcc_logbad(EX_IOERR, "fclose(%s): %s",
				   ofile_nm, ERROR_STR());
		ofile = 0;
	}

	/* Exit saying it was spam unless this is a discarding spam trap.
	 * Spam traps report all mail as spam, but expect to receive it for
	 * logging or analysis. */
	if (((ask_st & ASK_ST_CLNT_ISSPAM)
	     || ((ask_st & ASK_ST_SRVR_ISSPAM)
		 && !(rcpt_sws & FLTR_SW_DCC_OFF))
	     || ((ask_st & ASK_ST_REP_ISSPAM)
		 && (rcpt_sws & FLTR_SW_REP_ON)))
	    && !(rcpt_sws & FLTR_SW_TRAP_DIS)) {
		p2 = "\n"DCC_XHDR_RESULT DCC_XHDR_RESULT_REJECT"\n";

	} else {
		p2 = "\n"DCC_XHDR_RESULT DCC_XHDR_RESULT_ACCEPT"\n";
		exit_code = EX_OK;
	}
	if (fake_envelope)
		log_write(p2, strlen(p2));

	log_fin();
	exit(exit_code);

#ifdef DCC_WIN32
	return 0;
#endif
}



static void
start_dccifd(void)
{
#ifndef DCC_WIN32
	time_t t;
	int c;
	pid_t pid;

	assert_info_locked();

	/* once an hour,
	 * start dccifd if dccproc is run more often than
	 * DCCPROC_MAX_CREDITS times at an average rate of at least
	 * DCCPROC_COST times per second */

	t = (ctxt->start.tv_sec/DCCPROC_COST
	     - dcc_clnt_info->dccproc_last/DCCPROC_COST);
	if (t > DCCPROC_MAX_CREDITS*2)	/* don't overflow */
		t = DCCPROC_MAX_CREDITS*2;
	else if (t < 0)
		t = 0;
	c = t + dcc_clnt_info->dccproc_c;
	if (c > DCCPROC_MAX_CREDITS)
		c = DCCPROC_MAX_CREDITS;
	--c;
	if (c < -DCCPROC_MAX_CREDITS)
		c = -DCCPROC_MAX_CREDITS;
	dcc_clnt_info->dccproc_c = c;
	dcc_clnt_info->dccproc_last = ctxt->start.tv_sec;

	if (dcc_clnt_info->dccproc_c >= 0)
		return;

	if (!DCC_IS_TIME(ctxt->start.tv_sec,
			 dcc_clnt_info->dccproc_dccifd_try,
			 DCCPROC_TRY_DCCIFD))
		return;
	dcc_clnt_info->dccproc_dccifd_try = (ctxt->start.tv_sec
					     + DCCPROC_TRY_DCCIFD);
	pid = fork();
	if (pid) {
		if (pid < 0)
			dccproc_error_msg("fork(): %s", ERROR_STR());
		return;
	}

	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	close(STDERR_FILENO);
	dcc_clean_stdio();

	dcc_get_priv();
	if (0 > setuid(dcc_effective_uid))
		dccproc_error_msg("setuid(dcc_effective_uid): %s", ERROR_STR());
	if (0 > setgid(dcc_effective_gid))
		dccproc_error_msg("setgid(dcc_effective_gid): %s", ERROR_STR());

	dcc_trace_msg("try to start dccifd");
	execl(DCC_LIBEXECDIR"/start-dccifd",
	      "start-dccifd", "-A", (const char *)0);
	dcc_trace_msg("exec("DCC_LIBEXECDIR"/start-dccifd): %s", ERROR_STR());
	exit(0);
#endif /* DCC_WIN32 */
}



/* If the immediate SMTP client is a listed MX server,
 *	then we must ignore its IP address and keep looking for the
 *	real SMTP client. */
static u_char				/* 1=listed MX server */
check_mx_listing(void)
{
	DCC_TGTS tgts;

	if (!white_mx(&dcc_emsg, &tgts, &cks))
		dccproc_error_msg("%s", dcc_emsg.c);

	if (tgts == DCC_TGTS_OK) {
		/* do not tell the server about the IP address */
		no_ip_rpt2srvr(&cks);
		return 0;
	}

	if (tgts == DCC_TGTS_SUBMIT_CLIENT) {
		log_print(1, "%s is a listed 'submit' client\n",
			  dcc_trim_ffff(sender_str));
		/* do not tell the server about the IP address */
		no_ip_rpt2srvr(&cks);
		return 0;
	}

	if (tgts == DCC_TGTS_OK_MXDCC) {
		log_print(1, "%s is a whitelisted MX server with DCC client\n",
			  dcc_trim_ffff(sender_str));
		ask_st |= ASK_ST_QUERY;

	} else if (tgts == DCC_TGTS_OK_MX) {
		log_print(1, "%s is a whitelisted MX server\n",
			  dcc_trim_ffff(sender_str));

	} else {
		/* not listed */
		return 0;
	}

	no_ip_rpt2srvr(&cks);

	/* tell caller to look at the next Received: header */
	return 1;
}



/* send a new header to the output and the log */
static void
add_hdr(void *wp0 DCC_UNUSED, const char *buf, u_int buf_len)
{
	u_int i;
	const char *estr;

	log_body_write(buf, buf_len);
	if (ofile) {
		i = fwrite(buf, 1, buf_len, ofile);
		if (i != buf_len) {
			estr = ERROR_STR();
			fclose(ofile);
			ofile = 0;
			dcc_logbad(EX_IOERR, "fwrite(add_hdr %s,%d)=%d: %s",
				   ofile_nm, buf_len, i, estr);
		}
	}
}



/* get the next header line */
static int				/* header length */
get_hdr(char *buf,
	int buflen)			/* >HDR_CK_MAX*3 */
{
	u_char no_copy;
	int hlen, wpos;
	const char *line;
	char c;
	int llen, i;

	no_copy = 0;
	hlen = wpos = 0;
	for (;;) {
		line = fgets(&buf[hlen], buflen-hlen, ifile);
		if (!line) {
			if (ferror(ifile))
				dcc_logbad(EX_DATAERR, "fgets(%s): %s",
					   ifile_nm, ERROR_STR());
			else
				dcc_logbad(EX_DATAERR, "missing message body");
		}
		llen = strlen(line);

		/* delete our X-DCC header at the start of a field */
		if (hlen == 0 && !add_xhdr
		    && is_xhdr(buf, llen)) {
			seen_hdr = 1;
			no_copy = 1;
		}

		/* do not crash on too-long headers */
		hlen += llen;
		if (hlen > HDR_CK_MAX*2) {
			/* truncate headers too big for our buffer */
			if (!no_copy
			    && ((i = (hlen - wpos)) > 0)) {
				tmp_write(&buf[wpos], i);
				hdrs_len += i;
			}
			c = buf[hlen-1];
			hlen = HDR_CK_MAX;
			buf[hlen++] = '\r';
			buf[hlen++] = '\n';
			wpos = hlen;
			if (c != '\n')
				continue;
		}

		/* get the next character after the end-of-line to see if
		 * the next line is a continuation */
		if (hlen > 2) {
			i = getc(ifile);
			if (i != EOF)
				ungetc(i, ifile);
			if (i == ' ' || i == '\t')
				continue;
		}

		/* not a continuation, so stop reading the field */
		++total_hdrs;
		/* notice if this line ended with "\r\n" */
		if (hlen > 1 && buf[hlen-2] == '\r')
			++cr_hdrs;

		if (!no_copy) {
			i = hlen - wpos;
			if (i > 0) {
				tmp_write(&buf[wpos], hlen-wpos);
				hdrs_len += i;
			}
			return hlen;
		}

		/* at the end of our X-DCC header, look for another */
		no_copy = 0;
		hlen = wpos = 0;
	}
}



static void
tmp_write(const void *buf, int len)
{
	int i;

	if (tmp_fd < 0)
		return;

	if (tmp_rewound)
		dcc_logbad(EX_SOFTWARE, "writing to rewound temp file");

	i = write(tmp_fd, buf, len);
	if (i != len) {
		if (i < 0)
			dcc_logbad(EX_IOERR, "write(%s,%d): %s",
				   tmp_nm.c, len, ERROR_STR());
		else
			dcc_logbad(EX_IOERR, "write(%s,%d)=%d",
				   tmp_nm.c, len, i);
	}
}



static void
tmp_close(void)
{
	if (tmp_fd >= 0) {
		if (0 < close(tmp_fd))
			dcc_error_msg("close(%s): %s", tmp_nm.c, ERROR_STR());
		tmp_fd = -1;
	}
}



/* copy some of the temporary file to the output */
static void
scopy(int total_len,			/* copy this much of temporary file */
      u_char complain)			/* 1=ok to complain about problems */
{
	char buf[BUFSIZ];
	const char *estr;
	int buf_len, data_len, i;

	if (tmp_fd < 0)
		return;

	/* if the temporary file has not been rewound,
	 * then rewind it now */
	if (!tmp_rewound) {
		tmp_rewound = 1;
		if (0 > lseek(tmp_fd, 0, SEEK_SET)) {
			estr = ERROR_STR();
			tmp_close();
			if (complain)
				dcc_logbad(EX_IOERR, "rewind(%s): %s",
					   tmp_nm.c, estr);
		}
	}

	while (total_len > 0) {
		buf_len = sizeof(buf);
		if (buf_len > total_len) {
			buf_len = total_len;
		}

		data_len = read(tmp_fd, buf, buf_len);
		if (data_len <= 0) {
			estr = ERROR_STR();
			tmp_close();
			if (data_len < 0)
				dcc_logbad(EX_IOERR, "read(%s, %d): %s",
					   tmp_nm.c, data_len, estr);
			if (complain)
				dcc_logbad(EX_IOERR, "premature end of %s",
					   tmp_nm.c);
			return;
		}

		log_body_write(buf, data_len);

		if (ofile && (!cksums_only && !x_dcc_only)) {
			i = fwrite(buf, 1, data_len, ofile);
			if (i != data_len) {
				estr = ERROR_STR();
				fclose(ofile);
				ofile = 0;
				if (complain)
					dcc_logbad(EX_IOERR,
						   "fwrite(scopy %s, %d)=%d:"
						   " %s",
						   ofile_nm, data_len, i, estr);
				tmp_close();
				return;
			}
		}

		total_len -= data_len;
	}
}



static void
log_write(const void *buf, int len)
{
	int i;

	if (lfd < 0)
		return;

	i = write(lfd, buf, len);
	if (i == len) {
		logging = 2;
		log_size += len;
	} else {
		dcc_error_msg("write(log %s): %s", log_path.c, ERROR_STR());
		dcc_log_close(0, log_path.c, lfd, &ldate);
		lfd = -1;
		logging = 0;
		log_path.c[0] = '\0';
	}
}



static void
log_body_write(const char *buf, u_int buflen)
{
	int trimlen;
	const char *p, *lim;

	if (lfd < 0)
		return;

	/* just write if there is room */
	trimlen = MAX_LOG_KBYTE*1024 - log_size;
	if (trimlen >= (int)buflen) {
		log_write(buf, buflen);
		return;
	}

	/* do nothing if too much already written */
	if (trimlen < 0)
		return;

	/* look for and end-of-line near the end of the buffer
	 * so that we can make the truncation pretty */
	lim = buf;
	p = lim+trimlen;
	if (trimlen > 90)
		lim += trimlen-90;
	while (--p > lim) {
		if (*p == '\n') {
			trimlen = p-buf+1;
			break;
		}
	}
	log_write(buf, trimlen);
	if (buf[trimlen-1] != '\n')
		LOG_EOL();
	LOG_CAPTION(DCC_LOG_TRN_MSG_CR);
	log_size = MAX_LOG_KBYTE*1024+1;
}



static void
thr_log_write(void *context DCC_UNUSED, const char *buf, u_int len)
{
	log_write(buf, len);
}



/* does not append '\n' */
static int
vlog_print(u_char error, const char *p, va_list args)
{
	char logbuf[LOGBUF_SIZE];
	int i;

	/* buffer the message if we cannot write to the log file */
	if (error &&  (lfd < 0 || !tmp_rewound))
		return vearly_log(&early_log, p, args);

	if (lfd < 0)
		return 0;
	i = vsnprintf(logbuf, sizeof(logbuf), p, args);
	if (i >= ISZ(logbuf))
		i = sizeof(logbuf)-1;
	log_write(logbuf, i);
	return i;
}



static void
log_late(void)
{
	if (early_log.len) {
		log_write(early_log.buf, early_log.len);
		early_log.len = 0;
	}
}



/* does not append '\n' */
static int DCC_PF(2,3)
log_print(u_char error, const char *p, ...)
{
	va_list args;
	int i;

	va_start(args, p);
	i = vlog_print(error, p, args);
	va_end(args);
	return i;
}



/* does not append '\n' */
int
thr_log_print(void *cp DCC_UNUSED, u_char error, const char *p, ...)
{
	va_list args;
	int i;

	va_start(args, p);
	i = vlog_print(error, p, args);
	va_end(args);
	return i;
}



static void
log_fin(void)
{
	if (log_path.c[0] == '\0')
		return;

	/* Close before renaming to accomodate WIN32 foolishness.
	 * Assuming dcc_mkstemp() works properly, there is no race */
	dcc_log_close(0, log_path.c, lfd, &ldate);
	lfd = -1;
	if (priv_logdir)
		dcc_get_priv_home(dcc_main_logdir.c);
	if (!(ask_st & ASK_ST_LOGIT)
	    || !dcc_log_keep(0, &log_path)) {
		if (0 > unlink(log_path.c))
			dccproc_error_msg("unlink(%s): %s",
					  log_path.c, ERROR_STR());
		log_path.c[0] = '\0';
	}
	if (priv_logdir)
		dcc_rel_priv();
}



static void
log_ck(void *arg DCC_UNUSED, const char *buf, u_int buf_len)
{
	if (cksums_only && ofile)
		fputs(buf, ofile);
	log_write(buf, buf_len);
}



/* try to send error message to dccproc log file as well as sendmail */
static int
dccproc_verror_msg(const char *p, va_list args)
{
	char logbuf[LOGBUF_SIZE];

	/* Some systems including Linux with gcc 3.4.2 on AMD 64 processors
	 * do not allow two uses of a va_list but requires va_copy()
	 * Other systems do not have any notion of va_copy(). */
	if (vsnprintf(logbuf, sizeof(logbuf), p, args) >= ISZ(logbuf))
		strcpy(&logbuf[ISZ(logbuf)-sizeof("...")], "...");

	dcc_error_msg("%s", logbuf);

	ask_st |= ASK_ST_LOGIT;
	return log_print(1, "%s\n", logbuf);
}



/* try to send error message to dccproc log file as well as sendmail */
static void DCC_PF(1,2)
dccproc_error_msg(const char *p, ...)
{
	va_list args;

	va_start(args, p);
	dccproc_verror_msg(p, args);
	va_end(args);
}



int
thr_error_msg(void *cp DCC_UNUSED, const char *p, ...)
{
	va_list args;
	int i;

	va_start(args, p);
	i = dccproc_verror_msg(p, args);
	va_end(args);

	return i;
}



void
thr_trace_msg(void *cp DCC_UNUSED, const char *p, ...)
{
	va_list args;

	va_start(args, p);
	dccproc_verror_msg(p, args);
	va_end(args);
}



/* things are so sick that we must bail out */
void DCC_NORET
dcc_logbad(int ex_code, const char *p, ...)
{
	char buf[BUFSIZ];
	va_list args;
	size_t len;

	log_late();
	if (*p >= ' ' && !tmp_rewound) {
		va_start(args, p);
		dcc_vfatal_msg(p, args);
		va_end(args);

		ask_st |= ASK_ST_LOGIT;
		if (logging > 1)
			log_write("\n", 1);
		/* on some systems cannot use args twice after 1 va_start() */
		va_start(args, p);
		vlog_print(0, p, args);
		va_end(args);
		log_write("\n\n", 2);
		p = 0;
	}

	/* copy first from the temporary file and then the input
	 * to try to ensure that we don't lose mail */
	scopy(INT_MAX, 0);
	if (ifile && ofile && !cksums_only && !x_dcc_only) {
		do {
			len = fread(buf, 1, sizeof(buf), ifile);
			if (!len)
				break;
			log_write(buf, len);
		} while (len == fwrite(buf, 1, len, ofile));
	}

	if (p && *p >= ' ') {
		va_start(args, p);
		dcc_vfatal_msg(p, args);
		va_end(args);

		log_write("\n\n", 2);
		va_start(args, p);
		vlog_print(0,p, args);
		va_end(args);
		log_write("\n", 1);
	}
	log_fin();

	if (ex_code == EX_SOFTWARE)
		abort();
	exit(EX_OK);			/* don't tell procmail to reject mail */
}



/* watch for fatal signals */
static void DCC_NORET
sigterm(int sig)
{
	log_fin();
	exit(-sig);
}
