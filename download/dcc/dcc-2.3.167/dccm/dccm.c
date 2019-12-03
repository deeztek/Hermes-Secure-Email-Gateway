/* Distributed Checksum Clearinghouse
 *
 * sendmail milter interface
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
 * Rhyolite Software DCC 2.3.167-1.266 $Revision$
 */

#include "libmilter/mfapi.h"
#include "cmn_defs.h"

#undef NEW_MFAPI
#ifdef SM_LM_VRS_MAJOR
#if SM_LM_VRS_MAJOR(SMFI_VERSION) >= 1
#define NEW_MFAPI
#endif
#endif

u_char can_discard_1 = 1;		/* can trim targets after DATA */
u_char can_reject_1 = 1;		/* can reject Rcpt_To commands */
u_char uses_reject_msg = 1;

static u_char background = 1;
static DCC_PATH pidpath;

static const char *progpath = DCC_LIBEXECDIR"/dccm";

static DCC_PATH conn_def;
static char *milter_conn = conn_def.c;	/* MILTER socket specification */

/* DCC-milter state or context */
typedef struct work {
    SMFICTX	*milter_ctx;
#    define	 WORK_MILTER_CTX_IDLE ((SMFICTX *)DCC_SRVR_PORT)
    CMN_WORK	cw;
#    define	 NUM_XHDRS 5
    struct {				/* existing X-DCC headers */
	u_char	    num;
	u_char	    len;
	char	    brand[DCC_BRAND_MAXLEN];
    } xhdrs[NUM_XHDRS];
    REPLY_TPLT	sendmail_reply;
    /* from here down is zeroed when the structure is allocated */
#define WORK_ZERO fwd
    struct work *fwd;
    /* from here down is zeroed when the structure is used for a 2nd msg */
#define WORK_REZERO num_x_dcc
    u_char	num_x_dcc;
} WORK;

#define WORK_EXCESS ((WORK *)1)


/* use a free list to avoid malloc() overhead */
static WORK *work_free;
static int work_too_many;
static time_t work_msg_time;

/* each dccm job involves
 *	a socket connected to sendmail,
 *	a log file,
 *	and a socket to talk to the DCC server.
 * The file descriptors for the whitelists are accounted for in EXTRA_FILES */
#define FILES_PER_JOB	3
int max_max_work = MAX_SELECT_WORK;


static sfsistat dccm_conn(SMFICTX *, char *, _SOCK_ADDR *);
static sfsistat dccm_helo(SMFICTX *, char *);
static sfsistat dccm_envfrom(SMFICTX *, char **);
static sfsistat dccm_envrcpt(SMFICTX *, char **);
static sfsistat dccm_header(SMFICTX *, char *, char *);
static sfsistat dccm_eoh(SMFICTX *);
static sfsistat dccm_body(SMFICTX *, u_char *, size_t);
static sfsistat dccm_eom(SMFICTX *);
static sfsistat dccm_abort(SMFICTX *);
static sfsistat dccm_close(SMFICTX *);
#ifdef NEW_MFAPI
static sfsistat dccm_negotiate(SMFICTX *, unsigned long, unsigned long,
			       unsigned long, unsigned long,
			       unsigned long *, unsigned long *,
			       unsigned long *, unsigned long *);
#endif

static char dccm_name[] = {"DCC"};
static struct smfiDesc smfilter = {
    dccm_name,				/* filter name */
    SMFI_VERSION,			/* version code -- do not change */
    SMFIF_CHGHDRS | SMFIF_ADDHDRS | SMFIF_DELRCPT,  /* flags */
    dccm_conn,				/* connection info filter */
    dccm_helo,				/* SMTP HELO command filter */
    dccm_envfrom,			/* envelope sender filter */
    dccm_envrcpt,			/* envelope recipient filter */
    dccm_header,			/* header filter */
    dccm_eoh,				/* end of header */
    dccm_body,				/* body block filter */
    dccm_eom,				/* end of message */
    dccm_abort,				/* message aborted */
    dccm_close,				/* connection finished */
#ifdef NEW_MFAPI
    0,					/* unknown SMTP command */
    0,					/* xxfi_data */
    dccm_negotiate,			/* negotiate new milter options */
#endif
};


static REPLY_TPLT too_many_reply = {
	DCC_XHDR_TOO_MANY_RCPTS, {REPLY_TPLT_NULL},
	"452", "4.5.3", 0, DCC_XHDR_TOO_MANY_RCPTS};

static REPLY_TPLT incompat_wlist_reply = {
	DCC_XHDR_INCOMPAT_WLIST, {REPLY_TPLT_NULL},
	"452", "4.5.3", 0, DCC_XHDR_INCOMPAT_WLIST};

static REPLY_TPLT incompat_thold_reply = {
	DCC_XHDR_INCOMPAT_WLIST, {REPLY_TPLT_NULL},
	"452", "4.5.3", 0, DCC_XHDR_INCOMPAT_THOLD};


static void del_sock(void);
static void add_work(int);


static void
usage(const char* barg, const char *bvar)
{
	const char usage_str[] = {
	    "usage: [-VdbxANPQ] [-G on | off | noIP | IPmask/xx] [-h homedir]"
	    " [-I user]\n"
	    "    [-p protocol:filename | protocol:port@host] [-m map]\n"
	    "    [-w whiteclnt] [-U userdirs] [-a IGNORE | REJECT | DISCARD]\n"
	    "    [-t type,[log-thold,][spam-thold]]"
	    " [-g [not-]type] [-S header]\n"
	    "    [-l logdir] [-R rundir] [-r rejection-msg] [-j maxjobs]\n"
	    "    [-B dnsbl-option] [-L ltype,facility.level]"
	};
	static u_char complained;

	if (!complained) {
		if (barg)
			dcc_error_msg("unrecognized \"%s%s\"\n%s\n..."
				      " continuing",
				      barg, bvar, usage_str);
		else
			dcc_error_msg("%s\n... continuing", usage_str);
		complained = 1;
	}
}


int
main(int argc, char **argv)
{
	DCC_EMSG emsg;
	u_char print_version = 0;
#ifdef RLIMIT_NOFILE
	struct rlimit nofile;
	int old_rlim_cur;
#endif
	long l;
	u_char log_tgts_set = 0;
	time_t smfi_main_start;
	char *p;
	const char *rundir = DCC_RUNDIR;
	const char *homedir = 0;
	const char *logdir = 0;
	int result, i;

	emsg.c[0] = '\0';
	if (*argv[0] == '/')
		progpath = argv[0];
	dcc_syslog_init(1, argv[0], 0);
	dcc_clear_tholds();

#ifdef RLIMIT_NOFILE
	if (0 > getrlimit(RLIMIT_NOFILE, &nofile)) {
		dcc_error_msg("getrlimit(RLIMIT_NOFILE): %s", ERROR_STR());
		old_rlim_cur = 1000*1000;
	} else {
		old_rlim_cur = nofile.rlim_cur;
		if (nofile.rlim_max < 1000*1000) {
			i = nofile.rlim_max;
#ifndef DCC_USE_POLL
			if (i > (int)FD_SETSIZE)
				i = FD_SETSIZE;
#endif
			max_max_work = (i - EXTRA_FILES)/FILES_PER_JOB;
			max_max_work_src = "RLIMIT_NOFILE limit";
		}
	}
#endif /* RLIMIT_NOFILE */
	if (max_max_work <= 0) {
		dcc_error_msg("too few open files allowed");
		max_max_work = MIN_MAX_WORK;
	}
	max_work = max_max_work;

	while (EOF != (i = getopt(argc, argv, SLARGS"G:h:I:"
				  "p:m:w:U:a:t:g:S:l:R:r:j:B:L:"))) {
		switch (i) {
		case 'V':
			dcc_version_print();
			print_version = 1;
			break;

		case 'd':
			++dcc_clnt_debug;
			break;

		case 'b':
			background = 0;
			break;

		case 'x':
			try_extra_hard = DCC_CLNT_FG_NO_FAIL;
			break;

		case 'A':
			chghdr = ADDHDR;
			smfilter.xxfi_flags &= ~SMFIF_CHGHDRS;
			smfilter.xxfi_flags |= SMFIF_ADDHDRS;
			break;

		case 'N':
			chghdr = NOHDR;
			smfilter.xxfi_flags &= ~(SMFIF_ADDHDRS | SMFIF_CHGHDRS);
			break;

		case 'P':
			spamassassin_body_kludge = 0;
			break;

		case 'Q':
			dcc_query_only = 1;
			break;

		case 'W':		/* obsolete DCC off by default */
			to_white_only = 1;
			break;

		case 'G':
			if (!dcc_parse_client_grey(optarg))
				usage("-G", optarg);
			break;

		case 'h':
			homedir = optarg;
			break;

		case 'I':
			dcc_daemon_su(optarg);
			break;

		case 'p':
			milter_conn = optarg;
			break;

		case 'm':
			mapfile_nm = optarg;
			break;

		case 'w':
			main_white_nm = optarg;
			break;

		case 'U':
			parse_userdirs(optarg);
			break;

		case 'a':
			if (!strcasecmp(optarg, "IGNORE")) {
				action = CMN_IGNORE;
			} else if (!strcasecmp(optarg, "REJECT")) {
				action = CMN_REJECT;
			} else if (!strcasecmp(optarg, "DISCARD")) {
				action = CMN_DISCARD;
			} else {
				dcc_error_msg("unrecognized -a action: %s",
					      optarg);
			}
			break;

		case 't':
			if (dcc_parse_tholds("-t ", optarg))
				log_tgts_set = 1;
			break;

		case 'g':		/* honor not-spam "counts" */
			dcc_parse_honor(optarg);
			break;

		case 'S':
			dcc_add_sub_hdr(0, optarg);
			break;

		case 'l':		/* log rejected mail here */
			logdir = optarg;
			break;

		case 'R':
			rundir = optarg;
			break;

		case 'r':
			parse_reply_arg(optarg);
			break;

		case 'j':		/* maximum simultaneous jobs */
			l = strtoul(optarg, &p, 10);
			if (*p != '\0' || l < MIN_MAX_WORK) {
				dcc_error_msg("invalid queue length %s",
					      optarg);
			} else if (l > max_max_work) {
				dcc_error_msg("-j queue length %s"
					      " larger than %s; using %d",
					      optarg,
					      max_max_work_src, max_max_work);
				max_work = max_max_work;
			} else {
				max_work = l;
			}
			break;

		case 'B':
			if (!dcc_parse_dnsbl(&emsg, optarg, progpath))
				dcc_error_msg("%s", emsg.c);
			break;

		case 'L':
			if (dcc_parse_log_opt(optarg))
				helper_save_arg("-L", optarg);
			break;

		default:
			usage(optopt2str(optopt), "");
		}
	}
	if (argc != optind)
		usage(argv[optind], "");

	if (print_version)
		exit(EX_OK);

	snprintf(conn_def.c, sizeof(conn_def), "%s/%s", rundir, dcc_progname.c);

	if (!dcc_cdhome(0, homedir, 1) && homedir)
		dcc_cdhome(0, homedir = 0, 1);
	dcc_main_logdir_init(0, logdir);
	if (dcc_main_logdir.c[0] == '\0') {
		/* if not logging,
		 * tell sendmail to not bother with some stuff */
		smfilter.xxfi_helo = 0;

		if (log_tgts_set)
			dcc_error_msg("log thresholds set with -t"
				      " but no -l directory");
		if (userdirs != '\0')
			dcc_error_msg("no -l directory prevents per-user"
				      " logging with -U");
	}


#ifdef RLIMIT_NOFILE
	i = max_work*FILES_PER_JOB+EXTRA_FILES;
	if (old_rlim_cur < i) {
		nofile.rlim_cur = i;
		if (0 > setrlimit(RLIMIT_NOFILE, &nofile)) {
			dcc_error_msg("setrlimit(RLIMIT_NOFILE,%d): %s",
				      i, ERROR_STR());
			max_work = old_rlim_cur/FILES_PER_JOB - EXTRA_FILES;
			if (max_work <= 0) {
				dcc_error_msg("only %d open files allowed"
					      " by RLIMIT_NOFILE",
					      old_rlim_cur);
				max_work = MIN_MAX_WORK;
			}
		}
	}
#endif /* RLIMIT_NOFILE */

	helper_init(max_work);

	if (MI_SUCCESS != smfi_setconn(milter_conn))
		dcc_logbad(EX_USAGE, "illegal sendmail connection"
			   " \"%s\"\n", optarg);

	del_sock();

	if (smfi_register(smfilter) == MI_FAILURE)
		dcc_logbad(EX_UNAVAILABLE, "smfi_register failed\n");

	if (background) {
		if (daemon(1, 0) < 0)
			dcc_logbad(EX_OSERR, "daemon(): %s", ERROR_STR());

		dcc_daemon_restart(rundir, del_sock, dcc_clnt_debug);
		dcc_pidfile(&pidpath, rundir);
	}
	/* Be careful to start all threads only after the fork() in daemon(),
	 * because some POSIX threads packages (e.g. FreeBSD) get confused
	 * about threads in the parent.  */

	cmn_init();
	add_work(init_work);

	dcc_trace_msg(DCC_VERSION" listening to %s with %s",
		      milter_conn, dcc_homedir.c);
	if (dcc_clnt_debug)
		dcc_trace_msg("init_work=%d max_work=%d max_max_work=%d (%s)",
			      total_work, max_work, max_max_work,
			      max_max_work_src);

	/* It would be nice to remove the UNIX domain socket and PID file
	 * when smfi_main() returns, but we dare not because the library
	 * delays for several seconds after being signalled to stop.
	 * Our files might have been unlinked and the files now in
	 * the filesystem might belong to some other process. */
	smfi_main_start = time(0);
	result = smfi_main();

	if (pidpath.c[0] != '\0')
		unlink(pidpath.c);

	totals_stop();

	/* The sendmail libmilter machinery sometimes gets confused and
	 * gives up.  Try to start over if we had been running for at least
	 * 10 minutes */
	if (result != MI_SUCCESS
	    && time(0) > smfi_main_start+10*60) {
		dcc_error_msg("try to restart after smfi_main() = %d", result);
		exit(EX_DCC_RESTART);
	}

	if (result != MI_SUCCESS)
		dcc_error_msg("smfi_main() = %d", result);
	exit((result == MI_SUCCESS) ? EX_OK : EX_UNAVAILABLE);
}



/* remove the Unix domain socket of a previous instance of this daemon */
static void
del_sock(void)
{
	int s;
	struct stat sb;
	const char *conn;
	struct sockaddr_un conn_sun;
	int len, i;

	/* Ignore the sendmail milter "local|whatever:" prefix.
	 * If it is a UNIX domain socket, fine.  If not, no harm is done */
	conn = strchr(milter_conn, ':');
	if (conn)
		++conn;
	else
		conn = milter_conn;

	len = strlen(conn);
	if (len >= ISZ(conn_sun.sun_path))
		return;			/* perhaps not a UNIX domain socket */

	memset(&conn_sun, 0, sizeof(conn_sun));
	conn_sun.sun_family = AF_LOCAL;
	strcpy(conn_sun.sun_path, conn);
#ifdef HAVE_SA_LEN
	conn_sun.sun_len = SUN_LEN(&conn_sun);
#endif

	if (0 > stat(conn_sun.sun_path, &sb))
		return;
	if (!(S_ISSOCK(sb.st_mode) || S_ISFIFO(sb.st_mode)))
		dcc_logbad(EX_UNAVAILABLE, "non-socket present at %s",
			   conn_sun.sun_path);

	/* The sendmail libmilter seems to delay as long as 5 seconds
	 * before stopping.  It delays indefinitely if an SMTP client
	 * is stuck. */
	i = 0;
	for (;;) {
		s = socket(AF_UNIX, SOCK_STREAM, 0);
		if (s < 0) {
			dcc_logbad(EX_OSERR, "socket(AF_UNIX): %s",
				   ERROR_STR());
			return;
		}
		if (++i > 5*10)
			dcc_logbad(EX_UNAVAILABLE,
				   "DCCM or something already or still running"
				   " with socket at %s",
				   conn_sun.sun_path);
		if (0 > connect(s, (struct sockaddr *)&conn_sun,
				sizeof(conn_sun))) {
			/* unlink it only if it looks like a dead socket */
			if (errno == ECONNREFUSED || errno == ECONNRESET
			    || errno == EACCES) {
				if (0 > unlink(conn_sun.sun_path))
					dcc_error_msg("unlink(old %s): %s",
						      conn_sun.sun_path,
						      ERROR_STR());
			} else {
				dcc_error_msg("connect(old %s): %s",
					      conn_sun.sun_path, ERROR_STR());
			}
			close(s);
			break;
		}
		close(s);
		usleep(100*1000);
	}
}



/* create some contexts. */
static void
add_work(int i)
{
	WORK *wp;

	total_work += i;

	wp = dcc_malloc(sizeof(*wp)*i);
	memset(wp, 0, sizeof(*wp)*i);

	while (i-- != 0) {
		wp->milter_ctx = WORK_MILTER_CTX_IDLE;
		cmn_create(&wp->cw);
		wp->fwd = work_free;
		work_free = wp;
		++wp;
	}
}



static WORK *
work_alloc(void)
{
	WORK *wp;

	lock_work();
	wp = work_free;
	if (!wp) {
		if (total_work > max_work) {
			++work_too_many;
			unlock_work();
			return 0;
		}
		if (dcc_clnt_debug > 1)
			dcc_trace_msg("add %d work blocks to %d",
				      init_work, total_work);
		add_work(init_work);
		wp = work_free;
	}
	if (wp->milter_ctx != WORK_MILTER_CTX_IDLE)
		dcc_logbad(EX_SOFTWARE, "corrupt WORK area");
	work_free = wp->fwd;
	unlock_work();

	/* clear most of it */
	cmn_clear(&wp->cw, wp, 1);
	memset(&wp->WORK_ZERO, 0,
	       sizeof(*wp) - ((char*)&wp->WORK_ZERO - (char*)wp));

	return wp;
}



/* ocassionally close sockets to recover from dictionary attacks */
void
work_clean(void)
{
	WORK *wp;
	int keep, delete;

	lock_work();
	keep = 5;
	delete = init_work;
	for (wp = work_free; wp; wp = wp->fwd) {
		if (!wp->cw.dcc_ctxt)
			break;
		if (--keep > 0)
			continue;
		dcc_clnt_socs_close(wp->cw.dcc_ctxt);
		if (--delete <= 0)
			break;
	}
	unlock_work();
}



typedef enum {GET_WP_START,		/* not yet seen dccm_envfrom() */
	GET_WP_GOING,			/* have seen dccm_envfrom() */
	GET_WP_ABORT,			/* dccm_abort() */
	GET_WP_CLOSE			/* dccm_close() */
} GET_WP_MODE;
static WORK *
get_wp(SMFICTX *milter_ctx,
       GET_WP_MODE mode)
{
	WORK *wp;

	wp = (WORK *)smfi_getpriv(milter_ctx);
	if (!wp) {
		/* milter context is not active */
		if (mode == GET_WP_CLOSE || mode == GET_WP_ABORT)
			return 0;
		dcc_logbad(EX_SOFTWARE, "null SMFICTX pointer");
	} else if (wp == WORK_EXCESS) {
		if (mode == GET_WP_START || mode == GET_WP_GOING)
			dcc_logbad(EX_SOFTWARE, "tardy WORK_EXCESS");
		if (dcc_clnt_debug)
			dcc_trace_msg("%s for excessive message",
				      mode == GET_WP_ABORT
				      ? "abort" : "close");
		return 0;
	}
	if (wp->milter_ctx != milter_ctx)
		dcc_logbad(EX_SOFTWARE,
			   "bogus SMFICTX pointer or corrupt WORK area");

	if (!wp->cw.dcc_ctxt && (mode == GET_WP_START || mode == GET_WP_GOING))
		dcc_logbad(EX_SOFTWARE, "tardy failure to find ctxt");

	if (wp->cw.env_from[0] == '\0' && mode == GET_WP_GOING)
		dcc_logbad(EX_SOFTWARE, "work cleared?");

	return wp;
}



static void
set_sendmail_reply(WORK *wp,
		   const char *rcode, const char *xcode, const char *str)
{
	int i;

	/* kludge to fix lack of const declaration */
	typedef int (*SR)(SMFICTX *, const char *, const char *, const char *);
	static SR sr = (SR)smfi_setreply;
	i = (*sr)(wp->milter_ctx, rcode, xcode, str);

	if (i != MI_SUCCESS)
		thr_error_msg(&wp->cw, "smfi_setreply(\"%s\",\"%s\",\"%s\")=%d",
			      rcode, xcode, str, i);
}



/* refuse one recipient */
static sfsistat
rcpt_tempfail(WORK *wp, RCPT_ST *rcpt_st, const REPLY_TPLT *tplt)
{
	REPLY_STRS strs;

	make_reply(&strs, tplt, &wp->cw, 0);
	set_sendmail_reply(wp, strs.rcode, strs.xcode, strs.str);
	wp->cw.ask_st |= ASK_ST_LOGIT;
	if (rcpt_st) {
		snprintf(rcpt_st->rej_msg, sizeof(rcpt_st->rej_msg),
			 "%s %s %s", strs.rcode, strs.xcode, strs.str);
		rcpt_st->fgs |= RCPT_FG_REJ_FILTER;
	}
	return SMFIS_TEMPFAIL;
}



static void
msg_clear(WORK *wp)
{
	cmn_clear(&wp->cw, wp, 0);
	memset(&wp->WORK_REZERO, 0,
	       sizeof(*wp) - ((char*)&wp->WORK_REZERO - (char*)wp));
}



/* we are finished with one SMTP message.
 * get ready for the next from the same connection to an SMTP client */
static void
msg_done(WORK *wp, const char *result)
{
	LOG_CAPTION(wp, DCC_XHDR_RESULT);
	log_write(&wp->cw, result ? result : DCC_XHDR_RESULT_ACCEPT, 0);
	LOG_EOL(wp);

	msg_clear(wp);
}



/* give up on entire message */
static sfsistat
msg_tempfail(WORK *wp, const REPLY_TPLT *tplt)
{
	make_reply(&wp->cw.reply, tplt, &wp->cw, 0);
	set_sendmail_reply(wp, wp->cw.reply.rcode, wp->cw.reply.xcode,
			   wp->cw.reply.str);

	wp->cw.ask_st |= ASK_ST_LOGIT;
	log_smtp_reply(&wp->cw);
	msg_done(wp, wp->cw.reply.log_result);
	return SMFIS_TEMPFAIL;
}



static sfsistat
msg_reject(WORK *wp)
{
	sfsistat result;

	/* temporize if we have not figured out what to say */
	if (!wp->cw.reply.log_result) {
		thr_error_msg(&wp->cw, "rejection reason undecided");
		make_reply(&wp->cw.reply, &dcc_fail_reply, &wp->cw, 0);
	}

	set_sendmail_reply(wp, wp->cw.reply.rcode, wp->cw.reply.xcode,
			   wp->cw.reply.str);
	log_smtp_reply(&wp->cw);

	result = (wp->cw.reply.rcode[0] == '4') ? SMFIS_TEMPFAIL : SMFIS_REJECT;
	msg_done(wp, wp->cw.reply.log_result);
	return result;
}



/* see what sendmail had to say about the message */
static void
ask_sm(SMFICTX *milter_ctx, WORK *wp)
{
	static char sm_isspam_macro_def[] = "{dcc_isspam}";
	static char *sm_isspam_macro = sm_isspam_macro_def;
	static char sm_notspam_macro_def[] = "{dcc_notspam}";
	static char *sm_notspam_macro = sm_notspam_macro_def;

	const char *m;

	/* keep checking for evil until we get a relaying attack result */
	if (!(wp->cw.cmn_fgs & CMN_FG_BAD_RELAY)
	    && 0 != (m = smfi_getsymval(milter_ctx, sm_isspam_macro))
	    && *m != '\0') {
		make_tplt(&wp->sendmail_reply, 0, DCC_XCODE, DCC_RCODE, m,
			  DCC_XHDR_RESULT_REJECT);
		make_reply(&wp->cw.reply, &wp->sendmail_reply, &wp->cw, 0);

		/* do not leak relay attacks */
		if (!CLITCMP(wp->cw.reply.str, "DISCARD: Relaying denied")
		    || !CLITCMP(wp->cw.reply.str, "REJECT: Relaying denied")) {
			wp->cw.cmn_fgs |= CMN_FG_BAD_RELAY;
			wp->cw.ask_st &= ~ASK_ST_MTA_ISSPAM;
		}

		/* log only one copy of the sendmail.cf result */
		if (!(wp->cw.ask_st & ASK_ST_MTA_ISSPAM))
			thr_log_print(&wp->cw, 1, "sendmail.cf-->%s: \"%s\"\n",
				      sm_isspam_macro, wp->sendmail_reply.pat);

		wp->cw.ask_st |= (ASK_ST_MTA_ISSPAM | ASK_ST_LOGIT);
		wp->cw.ask_st &= ~ASK_ST_MTA_NOTSPAM;

		/* follow any discard/reject advice in the rejection message */
		if (!CLITCMP(wp->cw.reply.str, "DISCARD")) {
			wp->cw.action = CMN_DISCARD;
			wp->cw.reply.str += LITZ("DISCARD");
			wp->cw.reply.str += strspn(wp->cw.reply.str,
						   DCC_WHITESPACE":");
		} else {
			wp->cw.action = CMN_REJECT;
			if (!CLITCMP(wp->cw.reply.str, "REJECT")) {
				wp->cw.reply.str += LITZ("REJECT");
				wp->cw.reply.str += strspn(wp->cw.reply.str,
							DCC_WHITESPACE":");
			}
		}

	} else if (!(wp->cw.ask_st & ASK_ST_MTA_ISSPAM)
		   && !(wp->cw.ask_st & ASK_ST_MTA_NOTSPAM)
		   && 0 != (m = smfi_getsymval(milter_ctx, sm_notspam_macro))
		   && *m != '\0') {
		/* Sendmail has not said the message is bad,
		 * and the macro that indicates a whitelisting from
		 *	sendmail rules and databases is set.
		 * So announce the virtue of this message. */
		wp->cw.ask_st |= ASK_ST_MTA_NOTSPAM;

		make_tplt(&wp->sendmail_reply, 0, DCC_XCODE, DCC_RCODE, m,
			  DCC_XHDR_RESULT_REJECT);
		thr_log_print(&wp->cw, 1, "sendmail.cf-->%s: \"%s\"\n",
			      sm_notspam_macro, wp->sendmail_reply.pat);
	}
}



void
user_reject_discard(CMN_WORK *cwp, RCPT_ST *rcpt_st)
{
	int i;

	/* one of the other targets wants this message,
	 * try to remove this address from sendmail's list */
	i = smfi_delrcpt(cwp->wp->milter_ctx, rcpt_st->env_to);
	if (MI_SUCCESS != i)
		thr_error_msg(cwp, "delrcpt(%s)=%d", rcpt_st->env_to, i);
}



#ifdef NEW_MFAPI
/* ask sendmail to tell us about rejected recipients */
static sfsistat
dccm_negotiate(SMFICTX *milter_ctx DCC_UNUSED,
	       unsigned long f0, unsigned long f1,
	       unsigned long f2 DCC_UNUSED, unsigned long f3 DCC_UNUSED,
	       unsigned long *pf0, unsigned long *pf1 DCC_UNUSED,
	       unsigned long *pf2 DCC_UNUSED, unsigned long *pf3 DCC_UNUSED)
{
	*pf0 = f0;
	*pf1 = SMFIP_RCPT_REJ & f1;

	return SMFIS_CONTINUE;
}
#endif /* NEW_MFAPI */



/* start a new connection to an SMTP client */
static sfsistat
dccm_conn(SMFICTX *milter_ctx,
	  char *name,			/* SMTP client hostname */
	  _SOCK_ADDR *sender)
{
	WORK *wp;

	wp = (WORK *)smfi_getpriv(milter_ctx);
	if (wp) {
		dcc_error_msg("bogus initial SMFICTX pointer");
		smfi_setpriv(milter_ctx, 0);
		return SMFIS_TEMPFAIL;
	}
	wp = work_alloc();
	if (!wp) {
		smfi_setpriv(milter_ctx, WORK_EXCESS);
		return SMFIS_TEMPFAIL;
	}
	smfi_setpriv(milter_ctx, wp);
	wp->milter_ctx = milter_ctx;

	log_start(&wp->cw);

	if (!name) {
		if (dcc_clnt_debug)
			thr_trace_msg(&wp->cw, "null sender name");
		strcpy(wp->cw.clnt_name, "(null name)");
	} else {
		BUFCPY(wp->cw.clnt_name, name);
	}

	if (!sender) {
		if (!strcasecmp(wp->cw.clnt_name, "localhost")) {
			wp->cw.clnt_addr.s6_addr32[0] = 0;
			wp->cw.clnt_addr.s6_addr32[1] = 0;
			wp->cw.clnt_addr.s6_addr32[2] = htonl(0xffff);
			wp->cw.clnt_addr.s6_addr32[3] = htonl(INADDR_LOOPBACK);
			strcpy(wp->cw.clnt_str, "127.0.0.1");
		} else {
			if (dcc_clnt_debug)
				thr_trace_msg(&wp->cw,
					      "null sender address for \"%s\"",
					      wp->cw.clnt_name);
			wp->cw.clnt_str[0] = '\0';
		}
	} else if (sender->sa_family != AF_INET
		   && sender->sa_family != AF_INET6) {
		dcc_error_msg("unexpected sender address family %d",
			      sender->sa_family);
		wp->cw.clnt_str[0] = '\0';
	} else {
		if (sender->sa_family == AF_INET) {
			dcc_ipv4toipv6(&wp->cw.clnt_addr,
				       ((struct sockaddr_in*)sender)->sin_addr);
			dcc_ipv6tostr(wp->cw.clnt_str, sizeof(wp->cw.clnt_str),
				      &wp->cw.clnt_addr);
		} else if (sender->sa_family == AF_INET6) {
			memcpy(&wp->cw.clnt_addr,
			       &((struct sockaddr_in6 *)sender)->sin6_addr,
			       sizeof(wp->cw.clnt_addr));
			dcc_ipv6tostr(wp->cw.clnt_str, sizeof(wp->cw.clnt_str),
				  &wp->cw.clnt_addr);
		} else {
			dcc_error_msg("unknown address family for \"%s\"",
				      wp->cw.clnt_name);
			wp->cw.clnt_str[0] = '\0';
		}
	}

	/* quit now if we cannot find a free client context */
	if (!ck_dcc_ctxt(&wp->cw))
		return msg_tempfail(wp, &dcc_fail_reply);

	/* This much is common for all of the messages that might
	 * arrive through this connection to the SMTP client */

	return SMFIS_CONTINUE;
}



/* log HELO */
static sfsistat
dccm_helo(SMFICTX *milter_ctx, char *helo)
{
	WORK *wp;
	int i;

	wp = get_wp(milter_ctx, GET_WP_START);

	i = strlen(helo);
	if (i < ISZ(wp->cw.helo)) {
		memcpy(wp->cw.helo, helo, i+1);
	} else {
		memcpy(wp->cw.helo, helo, ISZ(wp->cw.helo)-ISZ(HELO_CONT));
		strcpy(&wp->cw.helo[ISZ(wp->cw.helo)-ISZ(HELO_CONT)], HELO_CONT);
	}

	return SMFIS_CONTINUE;
}



/* deal with Mail From envelope value */
static sfsistat
dccm_envfrom(SMFICTX *milter_ctx, char **from)
{
	static char dollar_i[] = "i";
	static char mail_host_macro[] = "{mail_host}";
	static char dcc_mail_host_macro[] = "{dcc_mail_host}";
	const char *id, *mail_host;
	WORK *wp;

	wp = get_wp(milter_ctx, GET_WP_START);

	log_start(&wp->cw);

	cks_init(&wp->cw.cks);
	dcc_dnsbl_init(&wp->cw.cks, wp->cw.dcc_ctxt, &wp->cw, wp->cw.id);

	/* Assume for now (and again if this is not the first transaction
	 * for this SMTP session) that the sender is the current SMTP client.
	 * Received: headers might have the real sender */
	strcpy(wp->cw.sender_name, wp->cw.clnt_name);
	strcpy(wp->cw.sender_str, wp->cw.clnt_str);

	/* see if the SMTP client is one of our MX forwarders */
	if (wp->cw.sender_str[0] == '\0') {
		wp->cw.cmn_fgs |= CMN_FG_PARSE_RCVD;
	} else {
		/* we need the IP checksum in the usual place to look in
		 * the whitelist for it */
		get_ipv6_ck(&wp->cw.cks, &wp->cw.clnt_addr);
		check_mx_listing(&wp->cw);
	}

	/* replace the message ID generated when the log file was started
	 * with the sendmail message ID */
	id = smfi_getsymval(milter_ctx, dollar_i);
	if (id)
		BUFCPY(wp->cw.id, id);

	BUFCPY(wp->cw.env_from, from[0]);

	/* Prefer the ${dcc_mail_host} macro because the standard mail_host
	 * macro can be wrong if a smart relay is used.  Older versions
	 * of the dcc.m4 file do not set it.
	 * Even if sendmail.cf sets the ${dcc_mail_host} macro,
	 * FEATURE(delay_checks) can delay its setting until after
	 * the MAIL command has been processed and this milter function
	 * has been called. */
	mail_host = smfi_getsymval(milter_ctx, dcc_mail_host_macro);
	/* fall back to the ${mail_host} macro */
	if (!mail_host || !*mail_host)
		mail_host = smfi_getsymval(milter_ctx, mail_host_macro);
	if (mail_host)
		BUFCPY(wp->cw.mail_host, mail_host);

	return SMFIS_CONTINUE;
}



/* note another recipient */
static sfsistat
dccm_envrcpt(SMFICTX *milter_ctx, char **rcpt)
{
	static char rcpt_mailer[] = "{rcpt_mailer}";
	static char rcpt_addr[] = "{rcpt_addr}";
	static char dcc_userdir[] = "{dcc_userdir}";
	const char *mailer, *addr, *dir;
	WORK *wp;
	RCPT_ST *rcpt_st;
	int i;

	wp = get_wp(milter_ctx, GET_WP_GOING);

	rcpt_st = alloc_rcpt_st(&wp->cw, 1);
	if (!rcpt_st)
		return rcpt_tempfail(wp, 0, &too_many_reply);

	BUFCPY(rcpt_st->env_to, rcpt[0]);

	addr = smfi_getsymval(milter_ctx, rcpt_addr);
	if (addr)
		BUFCPY(rcpt_st->user, addr);

	mailer = smfi_getsymval(milter_ctx, rcpt_mailer);
#ifdef NEW_MFAPI
	/* count rejected recipient as if the message would have been
	 * delivered to it unless there is a temporary error status */
	if (mailer && !strcmp(mailer, "error")) {
		rcpt_st->fgs |= RCPT_FG_BAD_USERNAME;
		if (!addr || addr[0] != '4')
			++wp->cw.mta_rej_tgts;
		return SMFIS_CONTINUE;
	}
#endif

	/* pick a per-user whitelist and log directory */
	dir = smfi_getsymval(milter_ctx, dcc_userdir);
	if (dir) {
		if (!get_user_dir(rcpt_st, dir, strlen(dir), 0, 0))
			thr_trace_msg(&wp->cw, "%s", wp->cw.emsg.c);
	} else if (mailer && addr) {
		if (!get_user_dir(rcpt_st, mailer, strlen(mailer),
				  addr, strlen(addr)))
			thr_trace_msg(&wp->cw, "%s", wp->cw.emsg.c);
	}

	/* sendmail might need to force discarding */
	ask_sm(milter_ctx, wp);
	i = cmn_compat_whitelist(&wp->cw, rcpt_st);
	if (i < 0) {
		if (i == -2)
			return rcpt_tempfail(wp, rcpt_st,
					     &incompat_thold_reply);
		return rcpt_tempfail(wp, rcpt_st, &incompat_wlist_reply);
	}

	++wp->cw.tgts;

	return SMFIS_CONTINUE;
}



static sfsistat
dccm_header(SMFICTX *milter_ctx, char *headerf, char *headerv)
{
	WORK *wp;
	int f_len, v_len;
	const char *cp;
	int i, j;

	wp = get_wp(milter_ctx, GET_WP_GOING);

	if (!(wp->cw.cmn_fgs & CMN_FG_ENV_LOGGED))
		thr_log_envelope(&wp->cw, 1);

	f_len = strlen(headerf);
	v_len = strlen(headerv);
	if (wp->cw.log_fd >= 0) {
		log_body_write(&wp->cw, headerf, f_len);
		log_body_write(&wp->cw, ": ", LITZ(": "));
		log_body_write(&wp->cw, headerv, v_len);
		log_body_write(&wp->cw, "\n", 1);
	}

	/* compute DCC checksums for favored headers */
	if (!strcasecmp(headerf, DCC_XHDR_TYPE_FROM)) {
		get_cks(&wp->cw.cks, DCC_CK_FROM, headerv, 1);
		return SMFIS_CONTINUE;
	}
	if (!strcasecmp(headerf, DCC_XHDR_TYPE_MESSAGE_ID)) {
		get_cks(&wp->cw.cks, DCC_CK_MESSAGE_ID, headerv, 1);
		return SMFIS_CONTINUE;
	}
	if (!strcasecmp(headerf, DCC_XHDR_TYPE_RECEIVED)) {
		get_cks(&wp->cw.cks, DCC_CK_RECEIVED, headerv, 1);

		/* parse Received: headers if we do not have a
		 * non-MX-whitelisted sender IP address
		 * and sendmail gave us a valid address so that
		 * there is a slot in the log file for an address.
		 * Parsing a Received header offered by a spammer is
		 * prevented by only parsing those added by MX-whitelisted
		 * IP addresses */
		if ((wp->cw.cmn_fgs & CMN_FG_PARSE_RCVD)
		    && wp->cw.log_ip_pos != 0) {
			const char *rh;
			int old_eof;

			rh = parse_received(headerv, &wp->cw.cks,
					    0, 0,   /* already have HELO */
					    wp->cw.sender_str,
					    sizeof(wp->cw.sender_str),
					    wp->cw.sender_name,
					    sizeof(wp->cw.sender_name));
			if (rh == 0) {
				/* to avoid being fooled by forged headers,
				 * stop at a strange one */
				wp->cw.cmn_fgs &= ~CMN_FG_PARSE_RCVD;

			} else if (*rh != '\0') {
				thr_log_print(&wp->cw, 1,
					      "skip %s Received: header\n", rh);

			} else {
				/* Put the IP address in the log file.
				 * It will be overwritten if it is a
				 * whitelisted MX server and if it is acting
				 * as a relay instead of the source */
				old_eof = log_lseek_get(&wp->cw);
				if (old_eof == 0) {
					;
				} else if (-1 == lseek(wp->cw.log_fd,
						       wp->cw.log_ip_pos,
						       SEEK_SET)) {
					thr_error_msg(&wp->cw,
						      "lseek(%s,%d,SEEK_SET):"
						      " %s",
						      wp->cw.log_nm.c,
						      (int)wp->cw.log_ip_pos,
						      ERROR_STR());
				} else {
					/* Include new host name if it is
					 * not an address literal and if
					 * all of it fit in wp->cw.sender_name
					 * and if there is room for it. */
					i = strlen(wp->cw.sender_name);
					j = strlen(wp->cw.sender_str);
					if (wp->cw.sender_name[0] != '['
					    && i < ISZ(wp->cw.sender_name)
					    && i+j < wp->cw.log_ip_len)
					    thr_log_print(&wp->cw, 0,
							"%s"DCC_LOG_IP2"%-*s",
							wp->cw.sender_name,
							wp->cw.log_ip_len-i,
							wp->cw.sender_str);
					else
					    thr_log_print(&wp->cw, 0, "%-*s",
							wp->cw.log_ip_len,
							wp->cw.sender_str);
					/* cannot log errors from the second
					 * lseek() because the file
					 * is at the wrong position */
					lseek(wp->cw.log_fd, old_eof, SEEK_SET);
				}
				/* keep looking if this IP address is a relay */
				check_mx_listing(&wp->cw);
			}
		}
		return SMFIS_CONTINUE;
	}

	/* remember existing X-DCC headers so that we can delete them */
	if (chghdr == SETHDR
	    && (j = f_len - LITZ(DCC_XHDR_START DCC_XHDR_END)) >= 0
	    && !CLITCMP(headerf, DCC_XHDR_START)
	    && !CLITCMP(headerf+f_len-LITZ(DCC_XHDR_END), DCC_XHDR_END)) {
		cp = headerf+LITZ(DCC_XHDR_START);
		for (i = 0; ; ++i) {
			if (i >= wp->num_x_dcc) {
				if (i < NUM_XHDRS) {
					++wp->num_x_dcc;
					wp->xhdrs[i].num = 1;
					wp->xhdrs[i].len = j;
					memcpy(wp->xhdrs[i].brand, cp, j);
				}
				break;
			}

			if (j == wp->xhdrs[i].len
			    && !strncasecmp(cp, wp->xhdrs[i].brand, j)) {
				/* this is a familiar X-DCC header */
				if (wp->xhdrs[i].num < 255)
					++wp->xhdrs[i].num;
				break;
			}
		}
	}

	ck_get_sub(&wp->cw.cks, headerf, headerv);

	/* Notice MIME multipart boundary definitions */
	ck_mime_hdr(&wp->cw.cks, headerf, headerv);

	return SMFIS_CONTINUE;
}



static sfsistat
dccm_eoh(SMFICTX *milter_ctx)
{
	WORK *wp;

	wp = get_wp(milter_ctx, GET_WP_GOING);

	/* finish logging the envelope on the first header,
	 * but if there were no headers we must do it now */
	if (!(wp->cw.cmn_fgs & CMN_FG_ENV_LOGGED))
		thr_log_envelope(&wp->cw, 1);

	/* Create a checksum for a null Message-ID header if there
	 * was no Message-ID header.  */
	if (wp->cw.cks.sums[DCC_CK_MESSAGE_ID].type != DCC_CK_MESSAGE_ID)
		get_cks(&wp->cw.cks, DCC_CK_MESSAGE_ID, "", 0);

	/* log the blank line between the header and the body */
	log_body_write(&wp->cw, "\n", 1);

	/* Check DNS blacklists for STMP client and envelope sender */
	cmn_ask_dnsbl(&wp->cw);

	return SMFIS_CONTINUE;
}



static sfsistat
dccm_body(SMFICTX *milter_ctx, u_char *bodyp, size_t bodylen)
{
	WORK *wp;

	wp = get_wp(milter_ctx, GET_WP_GOING);

	/* Log the body block */
	log_body_write(&wp->cw, (const char *)bodyp, bodylen);

	ck_body(&wp->cw.cks, bodyp, bodylen);

	return SMFIS_CONTINUE;
}



static void
msg_fin(SMFICTX *milter_ctx, WORK *wp)
{
	cks_fin(&wp->cw.cks);

	LOG_CAPTION(wp, DCC_LOG_MSG_SEP);
	thr_log_late(&wp->cw);

	/* get sendmail's final say */
	ask_sm(milter_ctx, wp);

	/* check the grey and white lists */
	cmn_ask_white(&wp->cw);
}



/* spend the cycles to tell sendmail to install the X-DCC header when
 *	we know the message will be delivered */
static void
addheader(WORK *wp, int xhdr_fname_len)
{
	char *hdr;
	int i;

	if (chghdr == NOHDR || wp->cw.header.buf[0] == '\0')
		return;

	/* kludge the trailing '\n' that sendmail hates */
	wp->cw.header.buf[wp->cw.header.used-1] = '\0';
	hdr = &wp->cw.header.buf[xhdr_fname_len];
	i = smfi_addheader(wp->milter_ctx, wp->cw.xhdr_fname, hdr);
	if (MI_SUCCESS != i)
		thr_error_msg(&wp->cw,
			      "smfi_addheader(\"%s\",\"%s\")=%d",
			      wp->cw.xhdr_fname, hdr, i);
	wp->cw.header.buf[wp->cw.header.used-1] = '\n';
}



/* deal with the end of the SMTP message as announced by sendmail */
static sfsistat
dccm_eom(SMFICTX *milter_ctx)
{
	static char null[] = "";	/* libmilter doesn't know about const */
	WORK *wp;
	char delbuf[LITZ(DCC_XHDR_START)+DCC_BRAND_MAXLEN+LITZ(DCC_XHDR_END)+1];
	int xhdr_fname_len;
	int i, j;

	wp = get_wp(milter_ctx, GET_WP_GOING);

	msg_fin(milter_ctx, wp);

	/* delete pre-existing X-DCC headers to prevent tricks on MUAs that
	 * pay attention to them */
	if (chghdr == SETHDR) {
		for (i = 0; i < wp->num_x_dcc; ++i) {
			snprintf(delbuf, sizeof(delbuf), DCC_XHDR_PAT,
				 wp->xhdrs[i].len, wp->xhdrs[i].brand);
			do {
				j = smfi_chgheader(wp->milter_ctx, delbuf,
						   wp->xhdrs[i].num, null);
				if (MI_SUCCESS != j) {
					thr_error_msg(&wp->cw,
						      "smfi_delheader(\"%s\","
						      "\"\")=%d",
						      delbuf, j);
				}
			} while (--wp->xhdrs[i].num > 0);
		}
	}

	wp->cw.header.buf[0] = '\0';
	wp->cw.header.used = 0;
	if (wp->cw.tgts <= wp->cw.white_tgts) {
		/* it is whitelisted for all targets,
		 * so add X-DCC header saying so */
		if (chghdr != NOHDR)
			xhdr_whitelist(&wp->cw.header);
		xhdr_fname_len = DCC_XHDR_WHITELIST_FNAME_LEN+2;

		/* log it if the target count is high enough */
		dcc_honor_log_cnts(&wp->cw.ask_st, &wp->cw.cks, wp->cw.tgts);

	} else {
		/* Report to the DCC
		 * Request a temporary failure if the DCC failed and we
		 * are trying hard */
		i = cmn_ask_dcc(&wp->cw);
		if (i <= 0) {
			if (!i && try_extra_hard)
				return msg_tempfail(wp, &dcc_fail_reply);

			/* after unrecoverable errors without even a fake
			 * header from local blacklisting, act as if the
			 * DCC server said not-spam but without a header */
		}
		xhdr_fname_len = wp->cw.xhdr_fname_len+2;
	}

	++totals.msgs;
	totals.tgts += wp->cw.tgts;

	/* get consensus of targets' wishes */
	users_process(&wp->cw);
	/* log the consensus & generate SMTP rejection message if needed */
	users_log_result(&wp->cw, 0);

	if (wp->cw.ask_st & ASK_ST_GREY_EMBARGO) {
		totals.tgts_embargoed += wp->cw.tgts;
		++totals.msgs_embargoed;
		return msg_reject(wp);
	}

	/* tell sendmail to deliver it if all (remaining) targets want it */
	if (wp->cw.reject_tgts == 0) {
		/* do not leak relay attacks even with DCC whitelisting */
		if (wp->cw.cmn_fgs & CMN_FG_BAD_RELAY)
			return msg_reject(wp);
		addheader(wp, xhdr_fname_len);
		msg_done(wp, 0);
		return SMFIS_ACCEPT;
	}

	/* it is rejectable spam unless we are ignoring results */
	switch (wp->cw.action) {
	case CMN_IGNORE:
		/* do not leak relay attacks even with DCC whitelisting */
		if (wp->cw.cmn_fgs & CMN_FG_BAD_RELAY)
			return msg_reject(wp);
		addheader(wp, xhdr_fname_len);
		if (wp->cw.reject_tgts != 0) {
			totals.tgts_ignored += wp->cw.reject_tgts;
			++totals.msgs_spam;
		}
		msg_done(wp, DCC_XHDR_RESULT_I_A);
		return SMFIS_ACCEPT;

	case CMN_DISCARD:
		/* discard it if that is our choice
		 * or if sendmail said to */
		if (wp->cw.reject_tgts != 0) {
			totals.tgts_discarded += wp->cw.reject_tgts;
			++totals.msgs_spam;
		}
		msg_done(wp, DCC_XHDR_RESULT_DISCARD);
		return SMFIS_DISCARD;

	case CMN_REJECT:
		if (wp->cw.reject_tgts != 0) {
			totals.tgts_rejected += wp->cw.reject_tgts;
			++totals.msgs_spam;
		}
	}

	/* tell sendmail what to do with it */
	return msg_reject(wp);
}



/* deal with an aborted SMTP transaction */
static void
msg_abort(WORK *wp)
{
	/* quit quietly if mail has not been started
	 * or at the end of an SMTP transaction */
	if (wp->cw.env_from[0] == '\0')
		return;

	wp->cw.ask_st |= ASK_ST_INVALID_MSG;
	if (!(wp->cw.cmn_fgs & CMN_FG_ENV_LOGGED)) {
		/* report a likely dictionary probe if there was no body */
		wp->cw.ask_st |= ASK_ST_CLNT_ISSPAM;
		thr_log_envelope(&wp->cw, 0);
	}
	unget_body_ck(&wp->cw.cks);
	msg_fin(wp->milter_ctx, wp);

	/* fix the sender's reputation if the message
	 * would have been locally marked as spam */
	if ((wp->cw.ask_st & ASK_ST_CLNT_ISSPAM)
	    && !(wp->cw.ask_st & ASK_ST_QUERY))
		cmn_ask_dcc(&wp->cw);

	users_process(&wp->cw);
	users_log_result(&wp->cw, "STMP message aborted");

	/* create log files for -d
	 * and without any recipents but with "option log-all" */
	if (dcc_clnt_debug
	    || (wp->cw.init_sws & FLTR_SW_LOG_ALL))
		wp->cw.ask_st |= ASK_ST_LOGIT;

	if (wp->cw.ask_st & ASK_ST_LOGIT)
		LOG_CAPTION(wp, DCC_XHDR_RESULT"STMP message aborted\n");
}



/* end of the SMTP session */
static sfsistat
dccm_close(SMFICTX *milter_ctx)
{
	int msg_cnt;
	struct timeval tv;
	WORK *wp;

	wp = get_wp(milter_ctx, GET_WP_CLOSE);
	if (!wp) {
		smfi_setpriv(milter_ctx, 0);
		return SMFIS_TEMPFAIL;
	}

	msg_abort(wp);

	/* finished with the context */
	log_stop(&wp->cw);
	lock_work();
	free_rcpt_sts(&wp->cw, 0);

	wp->milter_ctx = WORK_MILTER_CTX_IDLE;
	wp->fwd = work_free;
	work_free = wp;

	msg_cnt = work_too_many;
	if (msg_cnt != 0) {
		gettimeofday(&tv, 0);
		if (work_msg_time == tv.tv_sec) {
			msg_cnt = 0;
		} else {
			work_msg_time = tv.tv_sec;
			work_too_many = 0;
		}
	}
	unlock_work();
	if (msg_cnt != 0)
		dcc_error_msg("%d too many simultaneous mail messages", msg_cnt);

	smfi_setpriv(milter_ctx, 0);

	return SMFIS_CONTINUE;
}



static sfsistat
dccm_abort(SMFICTX *milter_ctx)
{
	WORK *wp;

	wp = get_wp(milter_ctx, GET_WP_ABORT);
	if (!wp)
		return SMFIS_TEMPFAIL;

	msg_abort(wp);

	/* get ready for possible new message */
	msg_clear(wp);
	return SMFIS_CONTINUE;
}
