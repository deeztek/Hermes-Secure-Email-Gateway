/* Distributed Checksum Clearinghouse
 *
 * DCC interface daemon
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
 * Rhyolite Software DCC 2.3.167-1.208 $Revision$
 */

#include "dcc_defs.h"
#include "dccif.h"
#include "dcc_paths.h"
#include "cmn_defs.h"
#include <signal.h>


static int stopping;

#define MAX_SMTP_LINE

static DCC_GETH use_ipv46 = DCC_GETH_DEF;
static u_char ipv4_works;
static u_char ipv6_works;

/* incoming proxy and bidirectional ASCII dccifd protocol connection */
static char *listen_addr;
static sa_family_t listen_family;
static struct sockaddr_un listen_sun;

static char lhost[MAXHOSTNAMELEN];
static in_port_t lport;
static const char *rhost;
static DCC_IP_RANGE rrange;
static DCC_SOCKET listen_soc = -1;

/* outgoing proxy connection */
static sa_family_t proxy_out_family;
static struct sockaddr_un proxy_out_sun;
static char proxy_out_host[DCC_MAXDOMAINLEN];
static in_port_t proxy_out_port;
static DCC_SOCKU proxy_out_su;

static const char *rundir = DCC_RUNDIR;
static DCC_PATH pidpath;
static const char *progpath = DCC_LIBEXECDIR"/dccifd";

static u_char background = 1;

static u_char proxy;

/* Only with the ASCII protocol can individual targets be trimmed
 *	after the SMTP DATA command, because there is nothing for
 *	us to do.  We need only say it was spam for a target.
 * Assume the ASCII protocol */
u_char can_discard_1 = 1;

/* only proxy mode can reject Rcpt_To commands */
u_char can_reject_1 = 0;

/* ASCII protocol does not use SMTP rejection messages */
u_char uses_reject_msg = 0;


/* message state or context */
typedef struct {			/* control an input buffer */
    char	*base;
    char	*in;
    char	*out;
    char	*next_line;
    int		size;
    int		line_len;
    int		*socp;
} IN_BC;
typedef struct {			/* control an ouput buffer */
    char	*base;
    char	*in;
    int		len;
    int		size;
    int		*socp;
} OUT_BC;
typedef struct work {
    int		proxy_in_soc;
    DCC_SOCKU   proxy_in_su;
    int		proxy_out_soc;
    char	buf1[HDR_CK_MAX*8];	/* >=HDR_CK_MAX*2 & MAX_RCPTS */
    char	buf2[HDR_CK_MAX*8];
    char	buf3[1024];
    char	buf4[1024];
    CMN_WORK    cw;
    enum {
	SMTP_ST_START,			/* expecting HELO */
	SMTP_ST_HELO,			/* seen HELO, expecting Mail_From */
	SMTP_ST_TRANS,			/* seen Mail_From */
	SMTP_ST_RCPT,			/* seen Rcpt_To */
	SMTP_ST_ERROR			/* no transaction until RSET or HELO */
    } smtp_state;
    /* from here down is zeroed when the structure is allocated */
#define WORK_ZERO fwd
    struct work *fwd;
    IN_BC       msg_rd;			/* incoming mail message */
    OUT_BC      msg_wt;			/* outoing mail message  */
    IN_BC       reply_in;		/* incoming SMTP replies */
    OUT_BC      reply_out;		/* outgoing SMTP replies */
    int		total_hdrs, cr_hdrs;
    int		parse_rcvd_num;		/* which received: header to parse */
    u_int       dfgs;
#    define      DFG_WORK_LOCK	    0x0001  /* hold the lock */
#    define      DFG_MISSING_BODY   0x0002  /* missing message body */
#    define      DFG_MTA_BODY	    0x0004  /* MTA wants the body */
#    define      DFG_MTA_HEADER	    0x0008  /* MTA wants the X-DCC header */
#    define      DFG_MTA_CKSUMS	    0x0010  /* MTA wants header and checksums */
#    define      DFG_SEEN_HDR	    0x0020  /* have at least 1 header */
#    define	 DFG_XCLIENT_NAME   0x0040  /* client name via XCLIENT */
#    define	 DFG_XCLIENT_ADDR   0x0080  /* client addresses via XCLIENT */
#    define	 DFG_XCLIENT_HELO   0x0100  /* HELO value via XCLIENT */
#    define	 DFG_RECYCLE (DFG_WORK_LOCK | DFG_MTA_BODY		\
			      | DFG_XCLIENT_NAME | DFG_XCLIENT_ADDR	\
			      | DFG_XCLIENT_HELO)
} WORK;

/* use a free list to avoid malloc() overhead */
static WORK *work_free;

/* each dccifd job involves
 *      a socket connected to the MTA or upstream proxy
 *      a socket connected to the downstream proxy if using SMTP
 *      a log file,
 *      and a socket to talk to the DCC server.
 * The file descriptors for the whitelists are accounted for in EXTRA_FILES */
#define FILES_PER_JOB   4
int max_max_work = MAX_SELECT_WORK;


typedef struct user_domain {
    struct user_domain *fwd;
    const char	*nm;
    int		len;
    u_char	wildcard;
} USER_DOMAIN;
static USER_DOMAIN *user_domains;
static char hostname[MAXHOSTNAMELEN+1] = "@";

/* max seconds to wait for MTA
 *      Longer than the longest timeout in RFC 2821 */
#define MAX_MTA_DELAY   (10*60+5)


static void sigterm(int);
static void setstack(pthread_attr_t *);
static u_char set_soc(DCC_EMSG *, int, sa_family_t, const char *);
static void bind_listen(void);
static void close_listen_soc(void);
static void unlink_listen_sun(void);
static void DCC_NORET *job_start(void *);
static void job_close(WORK *);
static void DCC_NORET job_exit(WORK *);
static void DCC_NORET msg_truncated(WORK *);
static void proxy_abort(WORK *, const char *);
static void add_work(int);


static void
usage(const char *barg, const char *bvar)
{
	const char usage_str[] = {
	    "usage: [-VdbxANPQ] [-G on | off | noIP | IPmask/xx] [-h homedir]"
	    " [-I user]\n"
	    "    [-p /sock | host,port,rhost/bits]"
	    " [-o /sock | host,port]\n"
	    "    [-D local-domain] [-r rejection-msg] [-m map] [-w whiteclnt]\n"
	    "    [-U userdirs] [-a IGNORE | REJECT | DISCARD]\n"
	    "    [-t type,[log-thold,][rej-thold]] [-g [not-]type]"
	    " [-S header]\n"
	    "    [-l logdir] [-R rundir] [-T tmpdir] [-j maxjobs]\n"
	    "    [-B dnsbl-option] [-L ltype,facility.level]\n"
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
	const char *homedir = 0;
	const char *logdir = 0;
	const char *tmpdir = 0;
	WORK *wp;
	pthread_t tid;
	pthread_attr_t attr;
	socklen_t namelen;
	const char *cp;
	USER_DOMAIN *udom, *udom2, **udomp;
	char *p;
	int error, i;

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

	while (-1 != (i = getopt(argc, argv, SLARGS"G:h:I:p:o:D:r:m:w:U:"
				 "a:t:g:S:l:R:T:j:B:L:"))) {
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
			break;

		case 'N':
			chghdr = NOHDR;
			break;

		case 'P':
			spamassassin_body_kludge = 0;
			break;

		case 'Q':
			dcc_query_only = 1;
			break;

		case 'G':
			if (!dcc_parse_client_grey(optarg))
				usage("-G", optarg);
			break;

		case 'W':		/* obsolete DCC off by default */
			to_white_only = 1;
			break;

		case 'h':
			homedir = optarg;
			break;

		case 'I':
			dcc_daemon_su(optarg);
			break;

		case 'p':
			listen_addr = optarg;
			break;

		case 'o':
			proxy = 1;
			can_discard_1 = 0;  /* cannot trim after DATA */
			can_reject_1 = 1;   /* can reject Rcpt_To commands */
			uses_reject_msg = 1;
			p = strchr(optarg, ',');
			if (!p) {
				/* recognize single-ended (not-really-)-proxy */
				if (!strcmp(optarg, _PATH_DEVNULL)) {
					proxy_out_family = AF_UNSPEC;
					break;
				}
				if (strlen(optarg)>=ISZ(proxy_out_sun.sun_path))
					dcc_logbad(EX_USAGE, "invalid UNIX"
						   " domain socket: -o %s",
						   optarg);
				strcpy(proxy_out_sun.sun_path, optarg);
#ifdef HAVE_SA_LEN
				proxy_out_sun.sun_len = SUN_LEN(&proxy_out_sun);
#endif
				proxy_out_sun.sun_family = AF_UNIX;
				proxy_out_family = AF_UNIX;
			} else {
				cp = dcc_parse_nm_port(&emsg, optarg,
						       DCC_GET_PORT_INVALID,
						       proxy_out_host,
						       sizeof(proxy_out_host),
						       &proxy_out_port, 0, 0,
						       0, 0);
				if (!cp)
					dcc_logbad(emsg_ex_code(&emsg),
						   "%s", emsg.c);
				if (*cp != '\0')
					dcc_logbad(EX_USAGE,
						   "invalid IP address: \"%s\"",
						   optarg);
				proxy_out_family = AF_INET; /* includes IPv6 */
			}
			break;

		case 'D':
			/* save user domain names sorted  by length
			 * so that we can apply the most restrictive */
			i = strlen(optarg);
			if (*optarg == '\0'
			    || ((optarg[0] == '@' || optarg[0] == '*')
				&& i < 2)
			    || strpbrk(optarg+1, "@*")) {
				dcc_logbad(EX_USAGE,
					   "invalid local-domain \"%s\"",
					   optarg);
				break;
			}
			udom2 = dcc_malloc(sizeof(*udom2));
			memset(udom2, 0, sizeof(*udom2));
			udom2->len = i;
			udom2->nm = optarg;
			if (optarg[0] == '*') {
				udom2->wildcard = 1;
				++udom2->nm;
				--udom2->len;
			}
			udomp = &user_domains;
			for (;;) {
				udom = *udomp;
				/* insert longer names before shorter names
				 * insert wildcard before same, non-wildcard
				 * because i includes the '*' */
				if (!udom || i > udom->len) {
					udom2->fwd = udom;
					*udomp = udom2;
					break;
				}
				udomp = &udom->fwd;
			}
			break;

		case 'r':
			parse_reply_arg(optarg);
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

		case 'T':
			tmpdir = optarg;
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
			break;
		}
	}
	argc -= optind;
	argv += optind;
	if (argc != 0)
		usage(argv[0], "");

	if (print_version)
		exit(EX_OK);

	/* delay checking IPv4 & IPv6 until debugging is known
	 * for the messages */
	if (ipv_check(&emsg, AF_INET, 0)) {
		ipv4_works = 1;
	} else {
		/* always complain about no IPv4 */
		dcc_error_msg("%s", emsg.c);
		ipv4_works = 0;
	}
	if (ipv_check(&emsg, AF_INET6, 0)) {
		ipv6_works = 1;
	} else {
		if (dcc_clnt_debug)
			dcc_error_msg("%s", emsg.c);
		ipv6_works = 0;
	}

	if (!ipv4_works && ipv6_works) {
		use_ipv46 = DCC_GETH_V6;
	} else if (ipv4_works && !ipv6_works) {
		use_ipv46 = DCC_GETH_V4;
	}

	/* default -D setting to the local host name */
	if (!user_domains) {
		if (0 > gethostname(hostname+1, sizeof(hostname)-2)) {
			dcc_error_msg("gethostname(): %s", ERROR_STR());
		} else if ((i = strlen(hostname)) > 1) {
			user_domains = dcc_malloc(sizeof(*user_domains));
			memset(user_domains, 0, sizeof(*user_domains));
			user_domains->len = i;
			user_domains->nm = hostname;
		}
	}

	if (!dcc_cdhome(0, homedir, 1) && homedir)
		dcc_cdhome(0, homedir = 0, 1);
	dcc_main_logdir_init(0, logdir);
	tmp_path_init(tmpdir, logdir);

	if (proxy_out_family == AF_INET) {
		if (proxy_out_host[0] == '\0'
		    || !strcmp(proxy_out_host, "@")) {
			/* null or "@" means incoming host */
			;
		} else {
			dcc_host_lock();
			if (!dcc_get_host(proxy_out_host, use_ipv46, &error))
				dcc_logbad(EX_NOHOST, "%s: %s",
					   proxy_out_host, H_ERROR_STR1(error));
			proxy_out_su = dcc_hostaddrs[0];
			DCC_SU_PORT(&proxy_out_su) = proxy_out_port;
			dcc_host_unlock();
		}
	}

	/* Open the incoming socket before our backgrounding fork() to
	 * minimize races and allow better error reporting. */
	bind_listen();

	if (dcc_main_logdir.c[0] == '\0') {
		if (log_tgts_set)
			dcc_error_msg("log thresholds set with -t"
				      " but no -l directory");
		if (userdirs != '\0')
			dcc_error_msg("no -l directory prevents per-user"
				      " logging with -U");
	}

#ifdef RLIMIT_NOFILE
	if (old_rlim_cur < (i = max_work*FILES_PER_JOB+EXTRA_FILES)) {
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

	if (background) {
		if (daemon(1, 0) < 0)
			dcc_logbad(EX_OSERR, "daemon(): %s", ERROR_STR());

		dcc_daemon_restart(rundir, 0, dcc_clnt_debug);
		dcc_pidfile(&pidpath, rundir);
	}

	signal(SIGPIPE, SIG_IGN);
	signal(SIGHUP, sigterm);
	signal(SIGTERM, sigterm);
	signal(SIGINT, sigterm);
#ifdef SIGXFSZ
	signal(SIGXFSZ, SIG_IGN);
#endif

	/* Be careful to start all threads only after the fork() in daemon(),
	 * because some POSIX threads packages (e.g. FreeBSD) get confused
	 * about threads in the parent.  */

	setstack(&attr);

	cmn_init();
	add_work(init_work);

	if (listen_family != AF_UNIX) {
		dcc_trace_msg(DCC_VERSION" listening to %s,%d from %s for %s",
			      lhost, ntohs(lport), rhost,
			      proxy ? "SMTP commands" : "ASCII protocol");
	} else {
		dcc_trace_msg(DCC_VERSION" listening to %s for %s",
			      listen_addr,
			      proxy ? "SMTP commands" : "ASCII protocol");
	}
	if (dcc_clnt_debug)
		dcc_trace_msg("init_work=%d max_work=%d max_max_work=%d (%s)",
			      total_work, max_work, max_max_work,
			      max_max_work_src);

	while (!stopping) {
		DCC_POLLFD pollfd;

		/* delay for 1 second instead of forever to notice
		 * when SIGTERM has said to stop */
		pollfd.fd = listen_soc;
		i = select_poll(&emsg, &pollfd, 1, 1, DCC_US);
		if (listen_soc < 0)
			break;
		if (i < 0)
			dcc_logbad(EX_OSERR, "%s", emsg.c);
		if (i == 0)
			continue;

		/* A new connection is ready.  Allocate a context
		 * block and create a thread */
		lock_work();
		wp = work_free;
		if (!wp) {
			if (total_work > max_work) {
				/* pretend we weren't listening if we
				 * are out of context blocks */
				unlock_work();
				sleep(1);
				continue;
			}
			if (dcc_clnt_debug > 1)
				dcc_trace_msg("add %d work blocks to %d",
					      init_work, total_work);
			add_work(init_work);
			wp = work_free;
		}
		work_free = wp->fwd;
		unlock_work();

		/* clear most of context block for the new connection */
		cmn_clear(&wp->cw, wp, 1);
		memset(&wp->WORK_ZERO, 0,
		       sizeof(*wp) - ((char*)&wp->WORK_ZERO - (char*)wp));

		namelen = sizeof(wp->proxy_in_su);
		wp->proxy_in_soc = accept(listen_soc,
					  &wp->proxy_in_su.sa, &namelen);
		if (wp->proxy_in_soc < 0) {
			dcc_error_msg("accept(): %s", ERROR_STR());
			job_close(wp);
			continue;
		}
		if (listen_family != AF_UNIX) {
			struct in6_addr addr6, *ap;

			if (wp->proxy_in_su.sa.sa_family == AF_INET6) {
				ap = &wp->proxy_in_su.ipv6.sin6_addr;
			} else {
				ap = &addr6;
				dcc_ipv4toipv6(ap,
					       wp->proxy_in_su.ipv4.sin_addr);
			}
			if (!in_range(ap, &rrange)) {
				char str[DCC_SU2STR_SIZE];
				dcc_error_msg("unauthorized client address %s",
					      dcc_su2str(str, sizeof(str),
							&wp->proxy_in_su));
				job_close(wp);
				continue;
			}
		}
		if (!set_soc(&emsg, wp->proxy_in_soc, listen_family, "MTA")) {
			dcc_error_msg("%s", emsg.c);
			job_close(wp);
			continue;
		}
		i = pthread_create(&tid, &attr, job_start, wp);
		if (i) {
			dcc_error_msg("pthread_create(): %s", ERROR_STR1(i));
			job_close(wp);
			continue;
		}
		i = pthread_detach(tid);
		if (i != 0) {
		   if (i != ESRCH)
			   dcc_error_msg("pthread_detach(): %s", ERROR_STR1(i));
		   else if (dcc_clnt_debug)
			   dcc_trace_msg("pthread_detach(): %s", ERROR_STR1(i));
		}
	}

	close_listen_soc();

	totals_stop();

	exit(stopping);
}



static void
setstack(pthread_attr_t *attr)
{
	size_t old_stacksize, new_stacksize;
	int i;

	pthread_attr_init(attr);
#if defined(HAVE_PTHREAD_ATTR_SETSTACKSIZE) && defined(PTHREAD_STACK_MIN)
	i = pthread_attr_getstacksize(attr, &old_stacksize);
	if (i != 0) {
		dcc_error_msg("pthread_attr_getstacksize(): %s", ERROR_STR1(i));
		return;
	}
	if (old_stacksize <= 512*1024) {
		if (dcc_clnt_debug)
			dcc_trace_msg("pthread stack size already=%d",
				      (int)old_stacksize);
	} else {
		new_stacksize = 512*1024;
		if (new_stacksize < PTHREAD_STACK_MIN)
			new_stacksize = PTHREAD_STACK_MIN;
		i = pthread_attr_setstacksize(attr, new_stacksize);
		if (i != 0) {
			dcc_error_msg("pthread_attr_setstacksize(%d): %s",
				      (int)new_stacksize, ERROR_STR1(i));
			return;
		}
		if (dcc_clnt_debug)
			dcc_trace_msg("change pthread stack size from %d to %d",
				      (int)old_stacksize, (int)new_stacksize);
	}
#endif
}



static void
unlink_listen_sun(void)
{
	if (listen_family != AF_UNIX)
		return;

	/* there is an unavoidable race here */
	if (0 > unlink(listen_sun.sun_path)
	    && errno != ENOENT)
		dcc_error_msg("unlink(%s): %s",
			      listen_sun.sun_path, ERROR_STR());
}



static void
bind_unix_listen(void)
{
	struct stat sb;
	int i;

#ifdef DCC_HP_UX_BAD_AF_UNIX
	dcc_logbad(EX_CONFIG, "HP-UX AF_UNIX does not support shutdown()");
#endif

	listen_family = AF_UNIX;

	if (!listen_addr) {
		/* use default UNIX domain socket */
		snprintf(listen_sun.sun_path, sizeof(listen_sun.sun_path),
			 "%s/"DCC_DCCIF_UDS, dcc_homedir.c);
		listen_addr = listen_sun.sun_path;
	} else {
		if (strlen(listen_addr) >= ISZ(listen_sun.sun_path))
			dcc_logbad(EX_USAGE, "invalid UNIX domain socket: %s",
				   listen_addr);
		strcpy(listen_sun.sun_path, listen_addr);
	}
	listen_sun.sun_family = AF_UNIX;
#ifdef HAVE_SA_LEN
	listen_sun.sun_len = SUN_LEN(&listen_sun);
#endif

	if (0 <= stat(listen_sun.sun_path, &sb)
	    && !(S_ISSOCK(sb.st_mode) || S_ISFIFO(sb.st_mode)))
		dcc_logbad(EX_CANTCREAT, "non-socket present at %s",
			   listen_sun.sun_path);

	/* Look for a daemon already using our socket.  Do not give up
	 * immediately in case a previous instance is slowly stopping. */
	i = 0;
	for (;;) {
		listen_soc = socket(AF_UNIX, SOCK_STREAM, 0);
		if (listen_soc < 0)
			dcc_logbad(EX_OSERR, "socket(AF_UNIX): %s",
				   ERROR_STR());
		/* unlink it only if it looks like a dead socket */
		if (0 > connect(listen_soc, (struct sockaddr *)&listen_sun,
				sizeof(listen_sun))) {
			if (errno == ECONNREFUSED || errno == ECONNRESET
			    || errno == EACCES) {
				unlink_listen_sun();
			} else if (dcc_clnt_debug > 2
				   && errno != ENOENT) {
				dcc_trace_msg("connect(old server %s): %s",
					      listen_sun.sun_path, ERROR_STR());
			}
			close(listen_soc);
			break;
		}
		/* connect() worked so the socket is alive */
		if (++i > 5*10)
			dcc_logbad(EX_CANTCREAT,
				   "something running with socket at %s",
				   listen_sun.sun_path);
		close(listen_soc);
		usleep(100*1000);
	}

	listen_soc = socket(AF_UNIX, SOCK_STREAM, 0);
	if (listen_soc < 0)
		dcc_logbad(EX_OSERR, "socket(AF_UNIX): %s", ERROR_STR());
	if (0 > bind(listen_soc, (struct sockaddr *)&listen_sun,
		     sizeof(listen_sun)))
		dcc_logbad(EX_IOERR, "bind(%s) %s",
			   listen_sun.sun_path, ERROR_STR());
	if (0 > chmod(listen_sun.sun_path, 0666))
		dcc_error_msg("chmod(%s, 0666): %s",
			      listen_sun.sun_path, ERROR_STR());
}



static void
bind_tcp_listen(void)
{
	DCC_EMSG emsg;
	DCC_SOCKU su;
	char *duparg, *lhost_port;
	const char *cp;
	u_char is_ipv6;
	int error, i;

	emsg.c[0] = '\0';

	lhost_port = strdup(listen_addr);
	duparg = strchr(lhost_port, ',');
	if (!duparg)
		dcc_logbad(EX_USAGE, "missing port number in \"%s\"",
			   listen_addr);

	duparg = strchr(duparg+1, ',');
	if (!duparg)
		dcc_logbad(EX_USAGE, "missing rhost in \"%s\"",
			   listen_addr);
	*duparg++ = '\0';

	rhost = duparg;
	if (0 >= str2range(&emsg, &rrange, &is_ipv6, rhost, 0, 0))
		dcc_logbad(EX_USAGE, "invalid rhost \"%s\": %s",
			   rhost, emsg.c);

	if (use_ipv46 == DCC_GETH_V6 || use_ipv46 == DCC_GETH_V64)
		listen_family = AF_INET6;
	else
		listen_family = AF_INET;
	if (is_ipv6) {
		if (use_ipv46 == DCC_GETH_V4)
			dcc_logbad(EX_USAGE, "IPv4 rhost \"%s\" not supported",
				   rhost);
		listen_family = AF_INET6;
	} else {
		if (use_ipv46 == DCC_GETH_V6)
			dcc_logbad(EX_USAGE, "IPv4 rhost \"%s\" not supported",
				   rhost);
		listen_family = AF_INET;
	}

	cp = dcc_parse_nm_port(&emsg, lhost_port, DCC_GET_PORT_INVALID,
			       lhost, sizeof(lhost), &lport, 0, 0, 0, 0);
	if (!cp)
		dcc_logbad(emsg_ex_code(&emsg), "%s", emsg.c);
	if (*cp != '\0')
		dcc_logbad(EX_USAGE, "invalid IP address: \"%s\"",
			   lhost_port);

	/* Null or "@" means INADDR_ANY
	 * should not use "@" because it conflicts with @=localhost
	 * but upward compatibility requires it be allowed
	 * The new idiom is "*" */
	if (lhost[0] == '\0' || !strcmp(lhost, "@"))
		strcpy(lhost, "*");

	dcc_host_lock();
	if (!dcc_get_host(lhost,
			  listen_family == AF_INET6 ? DCC_GETH_V6 : DCC_GETH_V4,
			  &error))
		dcc_logbad(EX_NOHOST, "%s: %s",
			   lhost, H_ERROR_STR1(error));
	su = dcc_hostaddrs[0];
	DCC_SU_PORT(&su) = lport;
	dcc_host_unlock();
	listen_family = su.sa.sa_family;

	/* Look for a daemon already using our socket.  Do not give up
	 * immediately in case a previous instance is slowly stopping. */
	i = 0;
	for (;;) {
		listen_soc = socket(listen_family, SOCK_STREAM, 0);
		if (listen_soc < 0)
			dcc_logbad(EX_OSERR, "socket(): %s", ERROR_STR());

		if (0 <= bind(listen_soc, &su.sa, DCC_SU_LEN(&su)))
			break;
		if (errno != EADDRINUSE || ++i > 5*10)
			dcc_logbad(EX_CANTCREAT, "bind(%s,%d) %s",
				   lhost, ntohs(lport), ERROR_STR());
		close(listen_soc);
		usleep(100*1000);
	}
}



static u_char
set_soc(DCC_EMSG *emsg, int s, sa_family_t family, const char *sname)
{
	int on;

	if (0 > fcntl(s, F_SETFD, FD_CLOEXEC)) {
		dcc_pemsg(EX_IOERR, emsg,
			  "fcntl(%s, F_SETFD, FD_CLOEXEC): %s",
			  sname, ERROR_STR());
		return 0;
	}

	if (family != AF_UNIX) {
		on = 1;
		if (0 > setsockopt(s, SOL_SOCKET, SO_KEEPALIVE,
				   &on, sizeof(on))) {
			dcc_pemsg(EX_IOERR, emsg,
				  "setsockopt(%s, SO_KEEPALIVE): %s",
				  sname, ERROR_STR());
			return 0;
		}
	}

	/* use non-blocking sockets so that we can read entire lines
	 * without knowing how big they are or expecting the operating
	 * system to allow peeking at its buffers */
	if (-1 == fcntl(s, F_SETFL,
			fcntl(s, F_GETFL, 0) | O_NONBLOCK)) {
		dcc_pemsg(EX_OSERR, emsg, "fcntl(%s, O_NONBLOCK): %s",
			  sname, ERROR_STR());
		return 0;
	}

	return 1;
}



static void
bind_listen(void)
{
	DCC_EMSG emsg;
	char *p;

	/* It is a TCP address if it has a local port number,
	 * a remote host name or address with an option prefix.
	 * Otherwise it is a UNIX domain socket.
	 */
	if (listen_addr != 0
	    && (p = strchr(listen_addr, ',')) != 0
	    && strchr(p, ',')) {
		bind_tcp_listen();
	} else {
		bind_unix_listen();
	}

	if (!set_soc(&emsg, listen_soc, listen_family, "main socket"))
		dcc_logbad(emsg_ex_code(&emsg), "%s", emsg.c);
	if (0 > listen(listen_soc, 10))
		dcc_logbad(EX_IOERR, "listen(): %s", ERROR_STR());
}



static u_char				/* 0=EOF, 1=read something */
soc_read(WORK *wp, IN_BC *bc)
{
	int fspace, len, total, i;

	if (bc->out >= bc->in)
		bc->out = bc->in = bc->base;

	fspace = &bc->base[bc->size] - bc->in;
	if (fspace < bc->size/8) {
		if (bc->out == bc->base) {
			thr_error_msg(&wp->cw, "buffer overrun; in=%d",
				      (int)(bc->in - bc->base));
			job_exit(wp);
		}
		len = bc->in - bc->out;
		memmove(bc->base, bc->out, len);
		bc->out = bc->base;
		bc->in = bc->out+len;
		fspace = bc->size - len;
	}

	if (wp->dfgs & DFG_WORK_LOCK)
		unlock_work();

	if (!bc->socp || *bc->socp < 0)
		dcc_logbad(EX_SOFTWARE, "attempt to read closed socket");

	for (;;) {
		DCC_POLLFD pollfd;

		pollfd.fd = *bc->socp;
		i = select_poll(&wp->cw.emsg, &pollfd, 1,
				1, MAX_MTA_DELAY*DCC_US);
		if (i > 0)
			break;
		if (i < 0) {
			thr_error_msg(&wp->cw, "%s", wp->cw.emsg.c);
		} else {
			thr_error_msg(&wp->cw, "MTA read timeout");
		}
		job_exit(wp);
	}
	total = read(*bc->socp, bc->in, fspace);
	if (total < 0) {
		if (!proxy || dcc_clnt_debug)
			thr_error_msg(&wp->cw, "read(sock): %s", ERROR_STR());
		if (proxy)
			return 0;
		job_exit(wp);
	}
	bc->in += total;

	if (wp->dfgs & DFG_WORK_LOCK)
		lock_work();
	return total != 0;
}



/* ensure there is another line in the buffer */
static u_char				/* 0=eof or buffer overflow */
msg_read_line(WORK *wp, IN_BC *bc)
{
	int i;
	char *p;

	for (;;) {
		p = bc->out;
		i = bc->in - p;
		if (i != 0) {
			/* look for <LF> for ASCII protocol
			 * or <CR><LF> for SMTP */
			p = memchr(p, '\n', i);
			if (p
			    && (!proxy
				|| (p > bc->out && *(p-1) == '\r'))) {
				bc->next_line = p+1;
				return 1;
			}
		}

		if (!soc_read(wp, bc))
			return 0;
	}
}



static void
buf_write_flush(WORK *wp, OUT_BC *bc)
{
	const char *buf;
	int len, i;

	len = bc->len;
	if (!len)
		return;
	bc->len = 0;

	if (!bc->socp || *bc->socp < 0)
		dcc_logbad(EX_SOFTWARE, "attempt to write closed socket");

	buf = bc->base;
	do {
		DCC_POLLFD pollfd;

		pollfd.fd = *bc->socp;
		i = select_poll(&wp->cw.emsg, &pollfd, 1,
				0, MAX_MTA_DELAY*DCC_US);
		if (i < 0) {
			thr_error_msg(&wp->cw, "%s", wp->cw.emsg.c);
			job_exit(wp);
		}
		if (i == 0) {
			thr_error_msg(&wp->cw, "MTA write timeout");
			job_exit(wp);
		}
		i = write(*bc->socp, buf, len);
		if (i < 0) {
			if (DCC_BLOCK_ERROR())
				continue;
			thr_error_msg(&wp->cw, "write(MTA socket,%d): %s",
				      len, ERROR_STR());
			job_exit(wp);
		}
		if (i == 0) {
			thr_error_msg(&wp->cw, "write(MTA socket,%d)=%d",
				      len, i);
			job_exit(wp);
		}
		buf += i;
		len -= i;
	} while (len > 0);
}



static void
buf_write(WORK *wp, OUT_BC *bc, const void *buf, u_int len)
{
	u_int n;

	for (;;) {
		n = bc->size - bc->len;
		if (n == 0)
			dcc_logbad(EX_SOFTWARE, "impossible buffer space");
		if (n > len)
			n = len;
		memcpy(&bc->base[bc->len], buf, n);
		if ((bc->len += n) >= bc->size)
			buf_write_flush(wp, bc);
		if ((len -= n) == 0)
			return;
		buf = (void *)((char *)buf + n);
	}
}



static void
buf_write_ck(WORK *wp, const char *buf, u_int buf_len)
{
	buf_write(wp, &wp->msg_wt, buf, buf_len);
}



static void
tmp_write(WORK *wp, const void *buf, int len)
{
	if (!cmn_write_tmp(&wp->cw, buf, len)) {
		thr_error_msg(&wp->cw, "%s", wp->cw.emsg.c);
		job_exit(wp);
	}
}



static int
tmp_read(WORK *wp, void *buf, int len)
{
	int i;

	if (wp->cw.tmp_fd < 0)
		return 0;

	i = read(wp->cw.tmp_fd, buf, len);
	if (i < 0) {
		thr_error_msg(&wp->cw, "read(%s,%d): %s",
			      wp->cw.tmp_nm.c, len, ERROR_STR());
		job_exit(wp);
	}
	return i;
}



/* fill MTA read buffer from temporary file */
static int
tmp_read_msg_in(WORK *wp)
{
	int i;

	/* preserving what is already in it */
	i = wp->msg_rd.in - wp->msg_rd.out;
	if (i > 0)
		memmove(wp->msg_rd.base, wp->msg_rd.out, i);
	wp->msg_rd.out = wp->msg_rd.base;
	wp->msg_rd.in = wp->msg_rd.out+i;

	wp->msg_rd.in += tmp_read(wp, wp->msg_rd.in, wp->msg_rd.size - i);
	return wp->msg_rd.in > wp->msg_rd.out;
}



/* Create the contexts. */
static void
add_work(int i)
{
	WORK *wp;

	total_work += i;

	wp = dcc_malloc(sizeof(*wp)*i);
	memset(wp, 0, sizeof(*wp)*i);

	while (i-- != 0) {
		wp->proxy_in_soc = -1;
		wp->proxy_out_soc = -1;
		cmn_create(&wp->cw);
		wp->fwd = work_free;
		work_free = wp;
		++wp;
	}
}



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



static void
job_close(WORK *wp)
{
	if (wp->dfgs & DFG_WORK_LOCK) {
		wp->dfgs &= ~DFG_WORK_LOCK;
		unlock_work();
	}

	wp->msg_rd.socp = 0;
	if (wp->msg_wt.socp) {
		buf_write_flush(wp, &wp->msg_wt);
		wp->msg_wt.socp = 0;
	}
	wp->reply_in.socp = 0;
	if (wp->reply_out.socp) {
		buf_write_flush(wp, &wp->reply_out);
		wp->reply_out.socp = 0;
	}

	cmn_close_tmp(&wp->cw);

	if (wp->proxy_in_soc >= 0) {
		if (0 > close(wp->proxy_in_soc)
		    && (dcc_clnt_debug
			|| (errno != ECONNRESET
			    && errno != ENOTCONN)))
			thr_error_msg(&wp->cw, "close(proxy input socket): %s",
				      ERROR_STR());
		wp->proxy_in_soc = -1;
	}
	if (wp->proxy_out_soc >= 0) {
		if (0 > close(wp->proxy_out_soc))
			thr_error_msg(&wp->cw, "close(proxy output socket): %s",
				      ERROR_STR());
		wp->proxy_out_soc = -1;
	}
	log_stop(&wp->cw);

	lock_work();
	free_rcpt_sts(&wp->cw, 0);
	wp->fwd = work_free;
	work_free = wp;
	unlock_work();
}



static void DCC_NORET
job_exit(WORK *wp)
{
	job_close(wp);
	pthread_exit(0);
	/* suppress warning on some systems */
	dcc_logbad(EX_OSERR, "pthread_exit() returned");
}



/* write headers or body data from the MTA read buffer to the MTA */
static void
mta_write(WORK *wp, char *end)
{
	int len;

	len = end - wp->msg_rd.out;
	if (len <= 0)
		return;
	buf_write(wp, &wp->msg_wt, wp->msg_rd.out, len);
	wp->msg_rd.out = end;
}



/* copy headers from the temporary file to the MTA */
static void
hdrs_copy(WORK *wp)
{
	enum {START_HDR, SKIP_HDR, COPY_HDR} cmode;
	const char *nl;
	char *bol, *eol;
	int i;

	if (-1 == lseek(wp->cw.tmp_fd, 0, SEEK_SET)) {
		thr_error_msg(&wp->cw, "rewind %s: %s",
			      wp->cw.tmp_nm.c, ERROR_STR());
		job_exit(wp);
	}

	cmode = START_HDR;
	wp->msg_rd.in = wp->msg_rd.out = wp->msg_rd.base;
	for (;;) {
		/* fill wp->msg_rd while keeping anything already present */
		if (!tmp_read_msg_in(wp))
			return;

		bol = wp->msg_rd.out;
		while ((i = wp->msg_rd.in - bol) > 0) {
			/* Find the end of the next line. */
			eol = memchr(bol, '\n', i);
			if (!eol) {
				/* Fill the buffer if we can't find '\n''
				 * and the buffer has room */
				if (i < wp->msg_rd.size
				    && wp->msg_rd.out != wp->msg_rd.base)
					break;
				/* pretend the header ended with the buffer
				 * if there is no room */
				eol = wp->msg_rd.in-1;
				nl = 0;
			} else if (eol+1 >= wp->msg_rd.in) {
				/* get the character after '\n' */
				if (i < wp->msg_rd.size
				    && wp->msg_rd.out != wp->msg_rd.base)
					break;
				/* pretend we could not find it if there
				 * is no room in the buffer
				 * or if we are at end of file.
				 * This will also end the headers */
				nl = 0;
			} else {
				nl = eol+1;
			}

			if (cmode == START_HDR) {
				/* We are at start of a header or the body.
				 * Quit before line of "\n" or "\r\n" */
				if (eol == bol
				    || (eol == bol+1 && *bol == '\r')) {
					/* write any preceding lines */
					mta_write(wp, bol);
					return;
				}

				/* Look for our header
				 * Assume the buffer is larger than the
				 * largest possible X-DCC field name. */
				if (chghdr == SETHDR
				    && is_xhdr(bol, eol-bol)) {
					/* skip it
					 * and copy any preceding headers. */
					mta_write(wp, bol);
					cmode = SKIP_HDR;
				} else {
					cmode = COPY_HDR;
				}
			}
			if (cmode == SKIP_HDR)
				wp->msg_rd.out = eol+1;

			/* Check the character after '\n' for
			 * whitespace indicating continuation */
			if (nl && *nl  != ' ' && *nl != '\t') {
				cmode = START_HDR;
				/* deal with SMTP transparency */
				if (proxy && *nl == '.')
					*eol-- = '.';
			}

			bol = eol+1;
		}

		mta_write(wp, bol);
	}
}



static void
add_hdr(void *wp0, const char *buf, u_int buf_len)
{
	WORK *wp = wp0;

	buf_write(wp, &wp->msg_wt, buf, buf_len);
}



static void
body_copy(WORK *wp)
{
	u_char seen_crlf;
	char *p;

	hdrs_copy(wp);

	if (chghdr != NOHDR && wp->cw.header.buf[0] != '\0') {
		/* write X-DCC header
		 *	end with "\r\n" if at least
		 *	half of the header lines ended that way */
		xhdr_write(add_hdr, wp, wp->cw.header.buf,
			   wp->cw.header.used,
			   wp->cr_hdrs > wp->total_hdrs/2);
	}

	/* copy body */
	seen_crlf = 2;
	do {
		p = wp->msg_rd.out;
		while (p < wp->msg_rd.in) {
			if (seen_crlf == 1) {
				seen_crlf = (*p++ == '\n') ? 2 : 0;
				continue;
			}
			if (seen_crlf == 2) {
				seen_crlf = 0;
				if (*p == '.' && proxy) {
					mta_write(wp, p);
					buf_write(wp, &wp->msg_wt, ".", 1);
				}
			}

			if (!proxy)
				break;
			p = memchr(p, '\r', wp->msg_rd.in-p);
			if (!p)
				break;
			seen_crlf = 1;
			++p;
		}
		mta_write(wp, wp->msg_rd.in);
	} while (tmp_read_msg_in(wp));
}



static void
close_listen_soc(void)
{
	if (pidpath.c[0] != '\0') {
		unlink(pidpath.c);
		pidpath.c[0] = '\0';
	}

	if (listen_soc >= 0) {
		unlink_listen_sun();
		if (0 > close(listen_soc))
			dcc_error_msg("close(main socket): %s",
				      ERROR_STR());
		listen_soc = -1;
	}
}



/* watch for fatal signals */
static void
sigterm(int sig)
{
	stopping = EX_DCC_SIGNAL + sig;
	unlink_listen_sun();
	close_listen_soc();
	dcc_clnt_stop_resolve();
	signal(sig, SIG_DFL);		/* quit on repeated signals */
}



void
user_reject_discard(CMN_WORK *cwp, DCC_UNUSED RCPT_ST *rcpt_st)
{
	/* There is nothing to do to trim a recipient with the ASCII
	 * protocol; just tell the MTA that the message is spam for
	 * this recipient. */
	if (!proxy)
		return;

	/* Dccifd in proxy mode has no way to tell the MTA to trim a
	 * recipient.  This should not happen. */
	thr_error_msg(cwp, "cannot discard an individual target");
}



static void
get_helo(WORK *wp, const char *vp, int len)
{
	if (len < HELO_MAX-1) {
		memcpy(wp->cw.helo, vp, len);
		wp->cw.helo[len] = '\0';
	} else {
		/* if the HELO value is too long, capture what we can
		 * and indicate that we got only part of it */
		len = HELO_MAX-1;
		memcpy(wp->cw.helo, vp, len);
		strcpy(&wp->msg_rd.out[HELO_MAX-ISZ(HELO_CONT)], HELO_CONT);
	}
}



/* Get the next header field
 *      The line is copied to the temporary file and then null terminated
 *      in the buffer */
static u_char				/* 1=have one, 0=end of headers */
get_hdr(WORK *wp)
{
	int tf_len;			/* header bytes written to temp file */
	int hdr_len;			/* total header length */
	int nlen;			/* length of next chunk of header */
	char *np;			/* next byte after field */
	char *p;
	u_char at_bol;			/* 1=at start of a line of header */

	tf_len = 0;
	hdr_len = 0;
	at_bol = 1;
	for (;;) {
		/* get another line of the header */
		np = wp->msg_rd.out + hdr_len;
		nlen = wp->msg_rd.in - np;
		if (nlen <= 1) {
			/* we do not have enough data */
read_more:;
			if (hdr_len > HDR_CK_MAX) {
				/* we already have more than HDR_CK_MAX
				 * bytes of the header.
				 * Keep only HDR_CK_MAX bytes of it
				 * in the buffer.  We will eventually
				 * return only the first HDR_CK_MAX
				 * bytes and an arbitrary part of the tail
				 * to our caller. */
				if (tf_len < hdr_len)
					tmp_write(wp, wp->msg_rd.out+tf_len,
						  hdr_len - tf_len);
				/* discard all but the first HDR_CK_MAX
				 * bytes of the header */
				hdr_len = HDR_CK_MAX;
				tf_len = HDR_CK_MAX;
				if (nlen != 0)
					wp->msg_rd.out[HDR_CK_MAX] = *np;
				wp->msg_rd.in = (wp->msg_rd.out + HDR_CK_MAX
						 + nlen);
			}
			/* Get more data, possibly sliding what we already
			 * have down in the buffer.  That would move
			 * wp->msg_rd.in to wp->msg_rd.base. */
			if (!soc_read(wp, &wp->msg_rd)) {
				/* EOF implies the message body including the
				 * separating blank line is missing.
				 * That is impossible for the ASCII dccifd
				 * protocol because there should be at least
				 * a Received header.
				 * When running as a proxy, we should get
				 * "\r\n.\r\n"
				 * Fake newlines until we get out of here
				 * so that we will log whatever we got */
				wp->dfgs |= DFG_MISSING_BODY;
				if (wp->cr_hdrs >= wp->total_hdrs/2)
					*wp->msg_rd.in++ = '\r';
				*wp->msg_rd.in++ = '\n';
			}
			continue;
		}

		if (at_bol) {
			/* deal with SMTP transparency */
			if (*np == '.' && proxy) {
				if (nlen < 3)
					goto read_more;
				if (np[1] != '\r' || np[2] != '\n') {
					memmove(np, np+1, --nlen);
				} else if (hdr_len == 0) {
					/* ".\r\n" at the start of a line
					 * ends the message. In this case
					 * the message body including the
					 * separating blank line is missing.
					 * Stop short before the ".\r\n" */
					return 0;
				}
			}

			/* stop before the next line if it is
			 * not a continuation of the current header */
			if (hdr_len != 0
			    && *np != ' '
			    && *np != '\t') {
				if (tf_len < hdr_len)
					tmp_write(wp, wp->msg_rd.out+tf_len,
						  hdr_len - tf_len);
				wp->msg_rd.out[hdr_len-1] = '\0';
				if (hdr_len > 1
				    && wp->msg_rd.out[hdr_len-2] == '\r')
					++wp->cr_hdrs;
				wp->msg_rd.next_line = &wp->msg_rd.out[hdr_len];
				return 1;
			}
		}

		/* find the end of the next line */
		p = memchr(np, '\n', nlen);
		if (p) {
			hdr_len += ++p - np;
			/* quit at the end of headers */
			if (hdr_len == 1
			    || (hdr_len == 2 && *wp->msg_rd.out == '\r'))
				return 0;
			at_bol = 1;
		} else {
			hdr_len += nlen;
			at_bol = 0;
		}
	}
}



static void
get_hdrs(WORK *wp)
{
	const char *p, *rh;

	for (;;) {
		/* stop at the separator between the body and headers */
		if (!get_hdr(wp))
			break;
		++wp->total_hdrs;

#define GET_HDR_CK(h,t) {						\
			if (!CLITCMP(wp->msg_rd.out, h)) {		\
				get_cks(&wp->cw.cks, DCC_CK_##t,	\
					&wp->msg_rd.out[LITZ(h)], 1);	\
				wp->dfgs |= DFG_SEEN_HDR;		\
				wp->msg_rd.out = wp->msg_rd.next_line;  \
				continue;}}
		GET_HDR_CK(DCC_XHDR_TYPE_FROM":", FROM);
		GET_HDR_CK(DCC_XHDR_TYPE_MESSAGE_ID":", MESSAGE_ID);
#undef GET_HDR_CK

		/* notice UNIX From_ line */
		if (!(wp->dfgs & DFG_SEEN_HDR)
		    && wp->cw.env_from[0] == '\0'
		    && parse_unix_from(wp->msg_rd.out, wp->cw.env_from,
				       sizeof(wp->cw.env_from))) {
			wp->dfgs |= DFG_SEEN_HDR;
			wp->msg_rd.out = wp->msg_rd.next_line;
			continue;
		}

		if (wp->cw.env_from[0] == '\0'
		    && parse_return_path(wp->msg_rd.out, wp->cw.env_from,
					 sizeof(wp->cw.env_from))) {
			wp->dfgs |= DFG_SEEN_HDR;
			wp->msg_rd.out = wp->msg_rd.next_line;
			continue;
		}

		if (!CLITCMP(wp->msg_rd.out, DCC_XHDR_TYPE_RECEIVED":")) {
			p = &wp->msg_rd.out[LITZ(DCC_XHDR_TYPE_RECEIVED":")];

			/* compute checksum of the last Received: header */
			get_cks(&wp->cw.cks, DCC_CK_RECEIVED, p, 1);

			wp->dfgs |= DFG_SEEN_HDR;
			wp->msg_rd.out = wp->msg_rd.next_line;

			/* pick IP address out of first Received: header */
			if (!(wp->cw.cmn_fgs & CMN_FG_PARSE_RCVD)
			    || --wp->parse_rcvd_num >= 0)
				continue;
			rh = parse_received(p, &wp->cw.cks,
					    (wp->cw.helo[0] == '\0')
					    ? wp->cw.helo : 0,
					    sizeof(wp->cw.helo),
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
				/* use this IP address if we do not have one */
				if (wp->cw.clnt_name[0] == '\0'
				    && wp->cw.clnt_str[0] == '\0') {
					strcpy(wp->cw.clnt_name,
					       wp->cw.sender_name);
					strcpy(wp->cw.clnt_str,
					       wp->cw.sender_str);
				}
				/* keep looking if this IP address is a relay */
				check_mx_listing(&wp->cw);
			}
			continue;
		}

		/* Notice MIME multipart boundary definitions */
		ck_mime_hdr(&wp->cw.cks, wp->msg_rd.out, 0);

		if (ck_get_sub(&wp->cw.cks, wp->msg_rd.out, 0))
			wp->dfgs |= DFG_SEEN_HDR;

		/* notice any sort of header */
		if (!(wp->dfgs & DFG_SEEN_HDR)) {
			for (p = wp->msg_rd.out; ; ++p) {
				if (*p == ':') {
					wp->dfgs |= DFG_SEEN_HDR;
					break;
				}
				if (*p <= ' ' || *p >= 0x7f)
					break;
			}
		}

		wp->msg_rd.out = wp->msg_rd.next_line;
	}

	/* Create a checksum for a null Message-ID header if there
	 * was no Message-ID header.  */
	if (wp->cw.cks.sums[DCC_CK_MESSAGE_ID].type != DCC_CK_MESSAGE_ID)
		get_cks(&wp->cw.cks, DCC_CK_MESSAGE_ID, "", 0);
}



/* Assume for now that the sender is the SMTP client.  Received: headers
 * might challenge that assumption */
static void
get_sender(WORK *wp)
{
	strcpy(wp->cw.sender_name, wp->cw.clnt_name);
	strcpy(wp->cw.sender_str, wp->cw.clnt_str);
	check_mx_listing(&wp->cw);
}



static u_char				/* 0=temporary failure, 1=ok */
get_body(WORK *wp)
{
	char *p;
	char buf[1024];
	u_char bol;
	int buflen, i;

	/* We must make a copy of the entire message in a temporary file
	 * if the MTA wants a copy with the X-DCC header added
	 * Copy the headers to a temporary file because the official
	 * log file needs the SMTP client IP address and envelope information
	 * before the header lines.  The log file needs all of the header
	 * lines including stray X-DCC lines, but those lines must be removed
	 * from the output file. */
	if (!cmn_open_tmp(&wp->cw)) {
		if (wp->dfgs & DFG_MTA_BODY) {
			dcc_error_msg("fatal error: %s", wp->cw.emsg.c);
			return 0;
		}
		dcc_error_msg("%s", wp->cw.emsg.c);
	}

	get_hdrs(wp);

	/* log IP address and so forth that we may have collected from
	 * the headers or Postfix XFORWARD or XCLIENT ESTMP extension */
	thr_log_envelope(&wp->cw, 0);

	/* Check DNS blacklists for STMP client and envelope sender */
	cmn_ask_dnsbl(&wp->cw);

	/* copy headers from temporary file to log file */
	if (wp->cw.log_fd >= 0 && wp->cw.tmp_fd >= 0) {
		if (0 > lseek(wp->cw.tmp_fd, 0, SEEK_SET)) {
			thr_error_msg(&wp->cw, "rewind %s: %s",
				      wp->cw.tmp_nm.c, ERROR_STR());
			job_exit(wp);
		}
		for (;;) {
			buflen = tmp_read(wp, buf, sizeof(buf));
			if (buflen <= 0)
				break;
			log_body_write(&wp->cw, buf, buflen);
		}
	}

	if (wp->dfgs & DFG_MISSING_BODY) {
		if (proxy) {
			proxy_abort(wp, "SMTP session aborted");
			job_exit(wp);
		}
		thr_error_msg(&wp->cw, "missing message body");
	}

	/* collect the body */
	bol = 1;
	for (;;) {
		buflen = wp->msg_rd.in - wp->msg_rd.out;
		if (buflen <= 0) {
			if (!soc_read(wp, &wp->msg_rd)) {
				if (proxy)
					msg_truncated(wp);
				break;
			}
			buflen = wp->msg_rd.in - wp->msg_rd.out;
		}

		/* deal with SMTP transparency and detect end of message */
		if (proxy) {
			if (bol) {
				/* We are at the beginning of a line.
				 * There will always be at least 3 more bytes
				 * in the message, ".\r\n" */
				if (buflen < 3) {
					if (!soc_read(wp, &wp->msg_rd))
					    msg_truncated(wp);
					buflen = wp->msg_rd.in - wp->msg_rd.out;
				}
				/* Whether a '.' is the end of the data
				 * or an escaped '.', we will discard it. */
				if (*wp->msg_rd.out == '.'
				    && buflen >= 1) {
					++wp->msg_rd.out;
					--buflen;
					/* if it is followed by "\r\n", then
					 * we have the end of the message */
					if (buflen >= 2
					    && wp->msg_rd.out[0] == '\r'
					    && wp->msg_rd.out[1] == '\n') {
					    wp->msg_rd.out += 2;
					    break;
					}
				}
				/* we are still at the beginning of a line */
			}

			/* check all of the lines in the buffer */
			p = wp->msg_rd.out;
			for (;;) {
				i = p - wp->msg_rd.out;
				p = memchr(p, '\r', buflen-i);
				if (!p) {
					/* We have checked all of the buffer.
					 * It does not end near an end of line.
					 * So log the block of body lines
					 * and leave the part of a line
					 * ending the buffer for later. */
					bol = 0;
					break;
				}
				/* We have found '\r'
				 * Maybe it will be followed by '\n' */
				i = ++p - wp->msg_rd.out;
				if (i+2 >= buflen) {
					/* '\r' ends or almost ends buffer. */
					bol = 0;
					buflen = i-1;
					if (buflen > 0) {
					    /* The buffer ends with "\rX"
					     * and contains text before '\r'
					     * Process up to the '\r' */
					    break;
					}
					/* buffer starts with "\r" */
					if (!soc_read(wp, &wp->msg_rd))
					    msg_truncated(wp);
					p = wp->msg_rd.out;
					buflen = wp->msg_rd.in - p;

				} else if (*p == '\n') {
					/* We have "\r\n"
					 * If "\r\n" is followed by '.',
					 * then process up to the '.' */
					if (*++p == '.') {
					    buflen = i+1;
					    bol = 1;
					    break;
					}
				}
			}
		}

		/* Log the body block */
		log_body_write(&wp->cw, wp->msg_rd.out, buflen);

		if (wp->dfgs & DFG_MTA_BODY)
			tmp_write(wp, wp->msg_rd.out, buflen);

		ck_body(&wp->cw.cks, wp->msg_rd.out, buflen);
		wp->msg_rd.out += buflen;
	}
	cks_fin(&wp->cw.cks);

	LOG_CAPTION(wp, DCC_LOG_MSG_SEP);
	thr_log_late(&wp->cw);

	/* check the grey and white lists */
	cmn_ask_white(&wp->cw);

	/* In the ASCII protocol with a recipient,
	 * the DCC operation is usually a query.
	 * Make it a report if this was spam */
	if (!wp->cw.rcpt_st_first
	    && ((wp->cw.ask_st & ASK_ST_MTA_ISSPAM)
		|| (wp->cw.ask_st & ASK_ST_WLIST_ISSPAM)
		|| (wp->cw.init_sws & FLTR_SW_TRAP)))
	    ++wp->cw.tgts;

	wp->cw.header.buf[0] = '\0';
	wp->cw.header.used = 0;
	if (wp->cw.tgts > wp->cw.white_tgts) {
		/* Report to the DCC and add our header if allowed.
		 * After serious errors, act as if DCC server said not-spam
		 * but remove our X-DCC header */
		i = cmn_ask_dcc(&wp->cw);
		if (!i && try_extra_hard)
			return 0;

	} else {
		/* The message is whitelisted or the MTA told us there are 0
		 * recipients, so we cannot ask the DCC server.
		 * If it was whitelisted, add X-DCC header saying so. */
		if (wp->cw.tgts > 0)
			xhdr_whitelist(&wp->cw.header);
		/* Use the local target count to decide whether to log
		 * the mail message */
		dcc_honor_log_cnts(&wp->cw.ask_st, &wp->cw.cks, wp->cw.tgts);
	}

	totals.tgts += wp->cw.tgts;

	return 1;
}



/* ensure there is another line, trim its terminal "\r\n",
 *      and add a terminal '\0'
 * This cannot be used with the proxy code because it often needs to
 *	send the original buffer downstream. */
static int				/* # of bytes available */
ascii_read_line(WORK *wp)
{
	char *p;

	if (!msg_read_line(wp, &wp->msg_rd)) {
		thr_error_msg(&wp->cw, "truncated request");
		job_exit(wp);
	}

	p = wp->msg_rd.next_line-1;
	for (;;) {
		*p-- = '\0';
		if (p < wp->msg_rd.out)
			return 0;
		if (*p != '\r')
			return p+1 - wp->msg_rd.out;
	}
}



/* Look for a string from the MTA
 *      while ignoring case and skipping whitespace
 *      The next line must already be in the buffer */
static u_char				/* 1=matched it */
ascii_opt_str(WORK *wp, const char *st, int stlen)
{
	/* skip initial white space */
	while (wp->msg_rd.out < wp->msg_rd.next_line
	       && (*wp->msg_rd.out == '\t' || *wp->msg_rd.out == ' '))
		++wp->msg_rd.out;

	if (stlen <= wp->msg_rd.next_line - wp->msg_rd.out
	    && !strncasecmp(wp->msg_rd.out, st, stlen)) {
		if (wp->msg_rd.out[stlen] == '\0') {
			wp->msg_rd.out += stlen;
			return 1;
		}

		/* skip trailing whitespace */
		if (wp->msg_rd.out[stlen] == '\t'
		    || wp->msg_rd.out[stlen] == ' ') {
			do {
				++stlen;
			} while (wp->msg_rd.out[stlen] == '\t'
				 || wp->msg_rd.out[stlen] == ' ');
			wp->msg_rd.out += stlen;
			return 1;
		}
	}

	return 0;
}



static u_char				/* 0=bad recipient */
check_addr(WORK *wp,
	   const char **addrp, int *addr_lenp,
	   const char **userp, int *user_lenp)
{
	USER_DOMAIN *udom;
	const char *atchr, *addr, *cp;
	int addr_len, i;

	addr = *addrp;
	addr_len = *addr_lenp;
	if (addr_len > RCTP_MAXNAME-1)
		addr_len = *addr_lenp = RCTP_MAXNAME-1;
	if (*addr == '<' && addr_len >= 2 && addr[addr_len-1] == '>') {
		++addr;
		addr_len -= 2;
		if (addr_len == 0) {
			if (wp->dfgs & DFG_WORK_LOCK)
				unlock_work();
			thr_error_msg(&wp->cw, "null recipient address");
			if (wp->dfgs & DFG_WORK_LOCK)
				lock_work();
			return 0;
		}
	}

	/* strip source route from recipient */
	while (addr_len != 0
	       && (cp = memchr(addr, ',', addr_len)) != 0) {
		++cp;
		addr_len -= cp-addr;
		addr = cp;
		*addr_lenp = addr_len;
		*addrp = addr;
	}

	if (addr_len >= RCTP_MAXNAME) {
		if (wp->dfgs & DFG_WORK_LOCK)
			unlock_work();
		thr_error_msg(&wp->cw, "recipient \"%s\" is too long", addr);
		if (wp->dfgs & DFG_WORK_LOCK)
			lock_work();
		return 0;
	}
	if (addr_len <= 0) {
		if (wp->dfgs & DFG_WORK_LOCK)
			unlock_work();
		thr_error_msg(&wp->cw, "null recipient");
		if (wp->dfgs & DFG_WORK_LOCK)
			lock_work();
		return 0;
	}

	if (*user_lenp) {
		if (*user_lenp > RCTP_MAXNAME-1)
			*user_lenp = RCTP_MAXNAME-1;
	} else {
		/* Use the list of local domain names to guess a user name
		 * from the recipient address
		 * Take the whole recipient name if it does not
		 * include a domain name */
		atchr = memchr(addr, '@', addr_len);
		if (!atchr) {
			*userp = addr;
			*user_lenp = addr_len;
			return 1;
		}

		for (udom = user_domains; udom; udom = udom->fwd) {
			i = addr_len - udom->len;
			if (i > 0 && !strncasecmp(addr+i, udom->nm,
						  udom->len)) {
				if (*udom->nm == '@'
				    || *udom->nm == '.') {
					;   /* got it */
				} else {
					/* match must start at '.' or '@'
					 * if target did not start with
					 * '.' or '@' then the name must
					 * end with '.' or '@' */
					if (i-- < 2
					    || (addr[i] != '.'
						&& addr[i] != '@'))
					    continue;
				}
				/* we have something like user or user@sub
				 * from user@sub.domain.com */
				*userp = addr;
				if (!udom->wildcard) {
					*user_lenp = i;
				} else {
					*user_lenp = atchr - addr;
				}
				return 1;
			}
		}
	}

	return 1;
}



/* The mutex must be locked */
static RCPT_ST *
set_rcpt(WORK *wp,
	 const char *rcpt, int rcpt_len,
	 const char *user, int user_len)
{
	RCPT_ST *rcpt_st;

	rcpt_st = alloc_rcpt_st(&wp->cw, 0);
	if (!rcpt_st)
		return 0;

	++wp->cw.tgts;
	memcpy(rcpt_st->env_to, rcpt, rcpt_len);
	rcpt_st->env_to[rcpt_len] = '\0';
	if (user_len)
		memcpy(rcpt_st->user, user, user_len);
	rcpt_st->user[user_len] = '\0';

	rcpt_st->dir.c[0] = '\0';
	if (user_len != 0
	    && !get_user_dir(rcpt_st, user, user_len, 0, 0))
		thr_trace_msg(&wp->cw, "%s", wp->cw.emsg.c);

	return rcpt_st;
}



/* read lines of pairs if (env_To, username) values from the MTA */
static void
get_ascii_rcpts(WORK *wp)
{
	const char *addr, *user, *user_end;
	char c;
	int addr_len, user_len;
	RCPT_ST *rcpt_st;

	lock_work();
	wp->dfgs |= DFG_WORK_LOCK;
	for (;;) {
		ascii_read_line(wp);

		/* stop after the empty line */
		addr = wp->msg_rd.out;
		if (*addr == '\0') {
			wp->msg_rd.out = wp->msg_rd.next_line;
			break;
		}

		user_end = wp->msg_rd.next_line;
		while (user_end > addr
		       && ((c = *(user_end-1)) == ' ' || c == '\t'))
			--user_end;

		/* bytes up to '\r' are the env_To value
		 * and bytes after are the local recipient */
		user = strchr(addr, '\r');
		if (!user) {
			addr_len = user_end - wp->msg_rd.out;
			user = user_end;
		} else {
			addr_len  = user - addr;
			++user;
		}

		user_len = user_end - user;
		if (!check_addr(wp, &addr, &addr_len, &user, &user_len))
			job_exit(wp);
		rcpt_st = set_rcpt(wp, addr, addr_len, user, user_len);
		if (!rcpt_st)
			job_exit(wp);

		/* Don't worry if this recipient is incompatible with preceding
		 * recipients, because there is nothing we can do.
		 * We cannot reject a recipient when the ASCII protocol is used,
		 * but side effects of the check are required */
		cmn_compat_whitelist(&wp->cw, rcpt_st);

		wp->msg_rd.out = wp->msg_rd.next_line;
	}
	unlock_work();
	wp->dfgs &= ~DFG_WORK_LOCK;

	if (wp->cw.tgts== 0)
		thr_error_msg(&wp->cw, "no recipients specified");
}



/* We are finished with one SMTP message with the ASCII protocol
 *      Send the result to the MTA and end this thread */
static void DCC_NORET
ascii_done(WORK *wp, DCCIF_RESULT_CHAR result_char)
{
	const char *result_str;
	RCPT_ST *rcpt_st;
	char *p;

	result_str = wp->cw.reply.log_result;
	if (!result_str)
		thr_error_msg(&wp->cw, "rejection reason undecided");
	else
		thr_log_print(&wp->cw, 0, DCC_XHDR_RESULT"%s\n", result_str);

	/* tell MTA the overall result */
	p = wp->msg_rd.base;
	*p++ = result_char;
	*p++ = '\n';

	/* output list of recipients */
	for (rcpt_st = wp->cw.rcpt_st_first; rcpt_st; rcpt_st = rcpt_st->fwd) {
		if (p >= &wp->msg_rd.base[wp->msg_rd.size-1]) {
			buf_write(wp, &wp->msg_wt,
				  wp->msg_rd.base, wp->msg_rd.size-1);
			p = wp->msg_rd.base;
		}
		if (result_char == DCCIF_RESULT_GREY) {
			*p++ = DCCIF_RCPT_GREY;
		} else if (wp->cw.deliver_tgts == 0
			   || (rcpt_st->fgs & RCPT_FG_ISSPAM)) {
			*p++ = DCCIF_RCPT_REJECT;
		} else {
			*p++ = DCCIF_RCPT_ACCEPT;
		}
	}
	*p++ = '\n';
	buf_write(wp, &wp->msg_wt, wp->msg_rd.base, p-wp->msg_rd.base);

	/* send the body from the temporary file to the MTA */
	if (wp->dfgs & DFG_MTA_BODY) {
		body_copy(wp);

	} else if (wp->dfgs & DFG_MTA_HEADER) {
		/* Give the MTA the header if it wants it and we have it */
		if (wp->cw.header.used != 0)
			buf_write(wp, &wp->msg_wt, wp->cw.header.buf,
				  wp->cw.header.used);

		/* Give the MTA the checksums if it wants them */
		if (wp->dfgs & DFG_MTA_CKSUMS)
			print_cks((LOG_WRITE_FNC)buf_write_ck, wp,
				  (wp->cw.ask_st & ASK_ST_RPT_SPAM) != 0,
				  wp->cw.local_tgts,
				  &wp->cw.cks, &wp->cw.cks.tholds_rej,
				  (wp->cw.rcpt_fgs & RCPT_FG_LOG_WTGTS)
				  ? &wp->cw.wtgts : 0);

		/* blank line before the results */
		buf_write(wp, &wp->msg_wt, "\n", 1);
	}

	job_exit(wp);
}



/* use the dccifd ASCII protocol to talk to an MTA */
static void DCC_NORET
ascii_job(WORK *wp)
{
#	define AOPT(s) ascii_opt_str(wp, s, LITZ(s))
	DCC_SOCKU su;
	char *p;
	int i;

	log_start(&wp->cw);

	wp->msg_rd.base = wp->buf1;
	wp->msg_rd.size = sizeof(wp->buf1);
	wp->msg_rd.socp = &wp->proxy_in_soc;

	wp->msg_wt.base = wp->buf2;
	wp->msg_wt.size = sizeof(wp->buf2);
	wp->msg_wt.socp = &wp->proxy_in_soc;

	/* get any options */
	ascii_read_line(wp);
	while (*wp->msg_rd.out != '\0') {
		if (AOPT(DCCIF_OPT_HEADER)) {
			wp->dfgs |= DFG_MTA_HEADER;
			continue;
		}
		if (AOPT(DCCIF_OPT_CKSUMS)) {
			wp->dfgs |= (DFG_MTA_HEADER | DFG_MTA_CKSUMS);
			continue;
		}
		if (AOPT(DCCIF_OPT_LOG)) {
			wp->cw.ask_st |= ASK_ST_LOGIT;
			continue;
		}
		if (AOPT(DCCIF_OPT_SPAM)) {
			wp->cw.ask_st |= ASK_ST_MTA_ISSPAM;
			continue;
		}
		if (AOPT(DCCIF_OPT_BODY)) {
			wp->dfgs |= DFG_MTA_BODY;
			continue;
		}
		if (AOPT(DCCIF_OPT_QUERY)) {
			wp->cw.ask_st |= ASK_ST_QUERY;
			continue;
		}
		if (AOPT(DCCIF_OPT_GREY_OFF)
		    || AOPT(DCCIF_OPT_GREY_OFF2)) {
			wp->cw.ask_st |= ASK_ST_GREY_OFF;
			continue;
		}
		if (AOPT(DCCIF_OPT_GREY_QUERY)) {
			wp->cw.ask_st |= ASK_ST_QUERY_GREY;
			continue;
		}
		if (AOPT(DCCIF_OPT_NO_REJECT)) {
			wp->cw.action = CMN_IGNORE;
			continue;
		}
		if (AOPT(DCCIF_OPT_RCVD_NXT)
		    || AOPT(DCCIF_OPT_RCVD_NEXT)) {
			++wp->parse_rcvd_num;
			continue;
		}

		thr_error_msg(&wp->cw, "unrecognized option value: \"%s\"",
			      wp->msg_rd.out);
		job_exit(wp);
	}
	if ((!grey_on
	     || (wp->cw.ask_st & ASK_ST_GREY_OFF))
	    && (wp->cw.ask_st & ASK_ST_QUERY_GREY)) {
		/* DCCIF_OPT_GREY_QUERY or "grey-query" is only available when
		 * greylisting is enabled with -G and not disabled with
		 * "grey-off".  Do not complain because the old SpamAssassin
		 * DCC.pm use the combination. */
		wp->cw.ask_st &= ~ASK_ST_QUERY_GREY;
	}
	if ((wp->cw.ask_st & ASK_ST_MTA_ISSPAM)
	    && (wp->cw.ask_st & ASK_ST_QUERY)) {
		thr_error_msg(&wp->cw, DCCIF_OPT_SPAM" and "DCCIF_OPT_QUERY
			      " are incompatible");
		wp->cw.ask_st &= ~ASK_ST_MTA_ISSPAM;
	}
	if ((wp->cw.ask_st & ASK_ST_MTA_ISSPAM)
	    && (wp->cw.ask_st & ASK_ST_QUERY_GREY)) {
		thr_error_msg(&wp->cw, DCCIF_OPT_SPAM" and "DCCIF_OPT_GREY_QUERY
			      " are incompatible");
		wp->cw.ask_st &= ~ASK_ST_MTA_ISSPAM;
	}
	if ((wp->cw.ask_st & ASK_ST_QUERY)
	    && (wp->cw.ask_st & ASK_ST_MTA_ISSPAM)) {
		thr_error_msg(&wp->cw, DCCIF_OPT_SPAM" is incompatible with"
			      "-Q or the MTA \"query\" option");
		wp->cw.ask_st &= ~ASK_ST_MTA_ISSPAM;
	}
	wp->msg_rd.out = wp->msg_rd.next_line;

	/* open the connection to the nearest DCC server
	 * and figure out our X-DCC header */
	if (!ck_dcc_ctxt(&wp->cw)) {
		/* failed to create context */
		make_reply(&wp->cw.reply,  &dcc_fail_reply, &wp->cw, 0);
		ascii_done(wp, DCCIF_RESULT_TEMP);
	}

	cks_init(&wp->cw.cks);
	dcc_dnsbl_init(&wp->cw.cks, wp->cw.dcc_ctxt, &wp->cw, wp->cw.id);
	wp->cw.cmn_fgs |= CMN_FG_LOG_EARLY;

	/* get the SMTP client IP address and host name */
	i = ascii_read_line(wp);
	if (i == 0
	    || !strcmp("0.0.0.0", wp->msg_rd.out)
	    || !strcmp("0.0.0.0\r0.0.0.0", wp->msg_rd.out)) {
		/* try a Received header if it is absent
		 * or the SpamAssassin junk */
		wp->cw.cmn_fgs |= CMN_FG_PARSE_RCVD;
	} else {
		/* the host name follows the IP address if present */
		p = strchr(wp->msg_rd.out, '\r');
		if (p) {
			*p++ = '\0';
			if (!str2su(&su, p)) {
				BUFCPY(wp->cw.clnt_name, p);
			} else {
				/* the name is really an IP address so
				 * make it an address literal */
				if (su.sa.sa_family == AF_INET6) {
					strcpy(&wp->cw.clnt_name[0],
					       "["DCC_IPV6_ALIT);
					i = LITZ("["DCC_IPV6_ALIT);
				} else {
					wp->cw.clnt_name[0] = '[';
					wp->cw.clnt_name[1] = '\0';
					i = 1;
				}
				STRLCPY(&wp->cw.clnt_name[i], p,
					sizeof(wp->cw.clnt_name)-i);
				STRLCAT(&wp->cw.clnt_name[i], "]",
					sizeof(wp->cw.clnt_name)-i);
			}
		}
		/* convert ASCCI representation of IP address to a
		 * canonical form and to a checksum */
		if (!str2su(&su, wp->msg_rd.out)) {
			thr_error_msg(&wp->cw, "unrecognized IP address \"%s\"",
				      wp->msg_rd.out);
		} else {
			su2cks(&wp->cw.cks, &su);
			/* convert IPv6 address to a canonical string */
			wp->cw.clnt_addr = wp->cw.cks.ip_addr;
			dcc_ipv6tostr(wp->cw.clnt_str, sizeof(wp->cw.clnt_str),
				      &wp->cw.clnt_addr);
		}
	}
	wp->msg_rd.out = wp->msg_rd.next_line;

	/* get the HELO value */
	i = ascii_read_line(wp);
	get_helo(wp, wp->msg_rd.out, i);
	wp->msg_rd.out = wp->msg_rd.next_line;

	/* get the envelope Mail_From value */
	i = ascii_read_line(wp);
	if (i > ISZ(wp->cw.env_from)-1)
		i = ISZ(wp->cw.env_from)-1;
	memcpy(wp->cw.env_from, wp->msg_rd.out, i);
	wp->cw.env_from[i] = '\0';
	wp->msg_rd.out = wp->msg_rd.next_line;

	get_sender(wp);

	/* get the list of recipients from the MTA */
	get_ascii_rcpts(wp);

	if (!get_body(wp)) {
		/* something wrong while collecting the message body
		 * such as contacting the DCC server */
		ascii_done(wp, DCCIF_RESULT_TEMP);
	}

	/* get consensus of targets' wishes */
	users_process(&wp->cw);
	totals.tgts_rejected += wp->cw.reject_tgts;
	/* log the consensus & generate SMTP rejection message if needed */
	users_log_result(&wp->cw, 0);

	if (wp->cw.ask_st & ASK_ST_GREY_EMBARGO) {
		totals.tgts_embargoed += wp->cw.tgts;
		ascii_done(wp, DCCIF_RESULT_GREY);
	}

	if (wp->cw.reject_tgts != 0
	    || (wp->cw.tgts == 0 && (wp->cw.ask_st & ASK_ST_CLNT_ISSPAM))) {
		if (wp->cw.action != CMN_IGNORE) {
			if (!wp->cw.reply.log_result)
				wp->cw.reply.log_result=DCC_XHDR_RESULT_REJECT;
			ascii_done(wp, DCCIF_RESULT_REJECT);
		} else {
			wp->cw.reply.log_result = DCC_XHDR_RESULT_I_A;
			ascii_done(wp, DCCIF_RESULT_OK);
		}
	}

	wp->cw.reply.log_result = DCC_XHDR_RESULT_ACCEPT;
	ascii_done(wp, DCCIF_RESULT_OK);

#	undef AOPT
}



#define SMTP_REPLY_221		"221 dccifd closing connection"
#define SMTP_REPLY_220		"220 dccifd proxy ready"
#define SMTP_REPLY_250_DATA	"250 dccifd mail ok"
#define SMTP_REPLY_250_RSET	"250 dccifd RSET ok"
#define SMTP_REPLY_250_HELO	"250 dccifd HELO ok"
#define SMTP_REPLY_250_POSTFIX	"250 dccifd Postfix extension ok"
#define SMTP_REPLY_250_RCPT	"250 dccifd Recipient ok"
#define SMTP_REPLY_250_MAIL	"250 dccifd Sender ok"
#define SMTP_REPLY_350		"354 Enter mail to dccifd"
#define SMTP_REPLY_452_WLIST	"452 4.5.3 "DCC_XHDR_INCOMPAT_WLIST
#define SMTP_REPLY_452_2MANY	"452 4.5.3 "DCC_XHDR_TOO_MANY_RCPTS
#define SMTP_REPLY_500		"500 5.0.0 dccifd command unrecognized"
#define SMTP_REPLY_501_NO_ARG	"501 5.5.4 dccifd command arg required"
#define SMTP_REPLY_501_BAD_ARG	"501 5.5.1 dccifd command unrecognized"
#define SMTP_REPLY_501_RCPT	"501 5.5.2 dccifd RCPT command syntax error"
#define SMTP_REPLY_501_POSTFIX	"501 5.5.2 dccifd Postfix extension syntax error"
#define SMTP_REPLY_503_DATA	"503 5.0.0 dccifd need RCPT"
#define SMTP_REPLY_503		"503 5.0.0 bad dccifd command sequence"

#define SMTP_DEBUG_TRACE 3


static void
smtp_trace(WORK *wp, const char *type, const char *buf, int len)
{
	if (dcc_clnt_debug < SMTP_DEBUG_TRACE)
		return;

	log_start(&wp->cw);
	if (len > 0 && buf[len-1] == '\n')
		--len;
	if (len > 0 && buf[len-1] == '\r')
		--len;
	thr_trace_msg(&wp->cw, "%s %s: %.*s", wp->cw.id, type, len, buf);
}



/* send an SMTP reply upstream to the SMTP client of our proxy */
static void
smtp_send_reply(WORK *wp, const char *reply, int len)
{
	if (dcc_clnt_debug >= SMTP_DEBUG_TRACE)
		smtp_trace(wp, "SMTP response", reply, len);
	buf_write(wp, &wp->reply_out, reply, len);
	buf_write(wp, &wp->reply_out, "\r\n", 2);
}

#define SMTP_REPLY(r) smtp_send_reply(wp,SMTP_REPLY_##r,LITZ(SMTP_REPLY_##r))

static void
smtp_reply_error(WORK *wp, const char *reply, int len)
{
	smtp_send_reply(wp, reply, len);
	wp->msg_rd.out = wp->msg_rd.next_line;
	wp->smtp_state = SMTP_ST_ERROR;
	if (dcc_clnt_debug)
		wp->cw.ask_st |= ASK_ST_LOGIT;
	/* depend on '\n' ending the SMTP message */
	thr_log_print(&wp->cw, 1, "%s", reply);
}

#define SMTP_ERROR(r) smtp_reply_error(wp,SMTP_REPLY_##r,LITZ(SMTP_REPLY_##r))



/* look for an SMTP verb */
typedef enum {
    SMTP_VERB_ERR,			/* bad command */
    SMTP_VERB_UNREC,			/* unrecognized command */
    SMTP_VERB_RSET,
    SMTP_VERB_HELO,
    SMTP_VERB_XCLIENT,			/* Postfix extension */
    SMTP_VERB_XFORWARD,			/* Postfix extension */
    SMTP_VERB_MAIL,			/* Mail From */
    SMTP_VERB_RCPT,			/* Rcpt To */
    SMTP_VERB_DATA,
    SMTP_VERB_QUIT
} VERB_SMTP;
typedef struct {
    const char	*str;
    int		str_len;
    const char	*parm;
    int		parm_len;
    VERB_SMTP	verb;
    u_char	arg_required;
} PT;
PT pt[] = {
#define PT_M(s,p,v,r) {s,LITZ(s),p,LITZ(p),SMTP_VERB_##v,r}
    PT_M("HELO","", HELO, 1),
    PT_M("EHLO","", HELO, 1),
    PT_M("Mail","From:", MAIL, 1),
    PT_M("Rcpt","To:", RCPT, 1),
    PT_M("DATA","", DATA, 0),
    PT_M("XFORWARD","", XFORWARD, 1),
    PT_M("XCLIENT","", XCLIENT, 1),
    PT_M("RSET","", RSET, 0),
    PT_M("QUIT","", QUIT, 0),
#undef PT_M
};

#define RESP_DIGIT(c) ((c) >= '0' && (c) <= '9')

static VERB_SMTP
get_smtp_verb(WORK *wp,
	      const char **ppp,		/* parameter after command */
	      const char **pep)		/* end of parameter */
{
	PT *ptp;
	const char *lp, *pp;
	int i, len;

	/* skip leading whitespace */
	wp->msg_rd.out += strspn(wp->msg_rd.out, " \t");
	lp = wp->msg_rd.out;

	if (dcc_clnt_debug >= SMTP_DEBUG_TRACE)
		smtp_trace(wp, "SMTP command", lp, wp->msg_rd.next_line - lp);

	for (ptp = pt; ptp < &pt[DIM(pt)]; ++ptp) {
		len = ptp->str_len;
		pp = lp+len;
		if (pp+2 > wp->msg_rd.next_line
		    || strncasecmp(lp, ptp->str, len))
			continue;

		if (pp+2 == wp->msg_rd.next_line) {
			/* SMTP command by itself on the line */
			*ppp = 0;
			*pep = 0;
			if (ptp->arg_required) {
				SMTP_REPLY(501_NO_ARG);
				return SMTP_VERB_ERR;
			}
			/* finished, having matched the command */
			return ptp->verb;
		}

		/* all other commands require following text separated
		 * from the command with whitespace, as in "Mail From:" */
		i = strspn(pp, " \t");
		if (i == 0)
			continue;
		pp += i;

		/* skip the initial part of the parameter, such as "From:" */
		if (ptp->parm_len) {
			if (*pp == '\r') {
				SMTP_REPLY(501_NO_ARG);
				return SMTP_VERB_ERR;
			}
			if (strncasecmp(pp, ptp->parm, ptp->parm_len)) {
				SMTP_REPLY(501_BAD_ARG);
				return SMTP_VERB_ERR;
			}
			pp += ptp->parm_len;
			pp += strspn(pp, " \t");
		}

		*ppp = pp;
		*pep = strpbrk(pp, " \t\r");
		return ptp->verb;
	}

	*ppp = 0;
	return SMTP_VERB_UNREC;
}



/* reset and restart the SMTP proxy state */
static void
proxy_rset(WORK *wp)
{
	if (wp->smtp_state == SMTP_ST_START)
		return;

	cmn_clear(&wp->cw, wp, 0);
	wp->dfgs &= DFG_RECYCLE;
	wp->smtp_state = SMTP_ST_START;

	cks_init(&wp->cw.cks);
	dcc_dnsbl_init(&wp->cw.cks, wp->cw.dcc_ctxt, &wp->cw, wp->cw.id);
	wp->cw.cmn_fgs |= CMN_FG_LOG_EARLY;

	/* Values from the Postfix XCLIENT ESMTP extension endure for the
	 * entire session.  Values from the XFORWARD extension or guesses from
	 * a HELO command are cleared at the end of the SMTP transaction. */
	if (!(wp->dfgs & DFG_XCLIENT_NAME))
		wp->cw.clnt_name[0] = '\0';
	if (wp->dfgs & DFG_XCLIENT_ADDR) {
		get_ipv6_ck(&wp->cw.cks, &wp->cw.clnt_addr);
	} else {
		memset(&wp->cw.clnt_addr, 0, sizeof(wp->cw.clnt_addr));
		wp->cw.clnt_str[0] = '\0';
	}
	if (!(wp->dfgs & DFG_XCLIENT_HELO))
		wp->cw.helo[0] = '\0';
}



/* deal with aborted SMTP sessions */
static void
proxy_abort(WORK *wp, const char *log_msg)
{
	if (dcc_clnt_debug >= SMTP_DEBUG_TRACE)
		smtp_trace(wp, "reset", log_msg, strlen(log_msg));

	if (wp->smtp_state != SMTP_ST_START
	    && wp->smtp_state != SMTP_ST_HELO
	    && wp->smtp_state != SMTP_ST_ERROR) {

		wp->cw.ask_st |= ASK_ST_INVALID_MSG;

		if (!(wp->cw.cmn_fgs & CMN_FG_ENV_LOGGED))
			thr_log_envelope(&wp->cw, 0);
		unget_body_ck(&wp->cw.cks);
		cks_fin(&wp->cw.cks);
		LOG_CAPTION(wp, "\n"DCC_LOG_MSG_SEP);
		thr_log_late(&wp->cw);
		cmn_ask_white(&wp->cw);

		/* fix the sender's reputation if the message whatever it would
		 * have been would be locally marked as spam */
		if ((wp->cw.ask_st & ASK_ST_CLNT_ISSPAM)
		    && !(wp->cw.ask_st & ASK_ST_QUERY_GREY))
			cmn_ask_dcc(&wp->cw);

		users_process(&wp->cw);
		users_log_result(&wp->cw, log_msg);

		/* create log files for -d
		 * and without any recipents but with "option log-all" */
		if (dcc_clnt_debug
		    || (wp->cw.init_sws & FLTR_SW_LOG_ALL))
			wp->cw.ask_st |= ASK_ST_LOGIT;

		if (wp->cw.ask_st & ASK_ST_LOGIT)
			thr_log_print(&wp->cw, 0,
				      DCC_XHDR_RESULT"%s\n", log_msg);
	}
	proxy_rset(wp);
}



/* quit a truncated message */
static void DCC_NORET
msg_truncated(WORK *wp)
{
	if (!proxy) {
		thr_error_msg(&wp->cw, "truncated message");
	} else {
		proxy_abort(wp, "SMTP session aborted");
	}
	job_exit(wp);
}



/* pass a line from the downstream proxy to our upstream */
static void
smtp_pass_line(WORK *wp)
{
	int len;

	len = wp->reply_in.next_line - wp->reply_in.out;
	if (dcc_clnt_debug >= SMTP_DEBUG_TRACE)
		smtp_trace(wp, "pass SMTP response", wp->reply_in.out, len);

	buf_write(wp, &wp->reply_out, wp->reply_in.out,
		  wp->reply_in.next_line - wp->reply_in.out);

	wp->reply_in.out = wp->reply_in.next_line;
}



static int				/* -1 or 1st digit of response */
smtp_get_resp(WORK *wp,
	      u_char pass,		/* 1=pass it upstream */
	      char *logbuf,		/* log response here */
	      int logbuflen)
{
	int len;
	char dig, cont;

	for (;;) {
		if (!msg_read_line(wp, &wp->reply_in)) {
			if (pass)
				job_exit(wp);
			return -1;
		}
		len = wp->reply_in.next_line - wp->reply_in.out;
		if (len < 5) {
			thr_error_msg(&wp->cw, "short SMTP response"
				      " \"%s\" from proxy server",
				      wp->reply_in.out);
			return -1;
		}
		dig = wp->reply_in.out[0];
		cont = wp->reply_in.out[3];
		if ((dig < '1' || dig > '5')
		    || !RESP_DIGIT(wp->reply_in.out[1])
		    || !RESP_DIGIT(wp->reply_in.out[2])
		    || (cont != ' ' && cont != '-')) {
			*wp->reply_in.next_line = '\0';
			thr_error_msg(&wp->cw, "unrecognized SMTP response"
				      " \"%s\" from proxy",
				      wp->reply_in.out);
			return -1;
		}

		if (logbuflen != 0) {
			if (logbuflen > len)
				logbuflen = len;
			memcpy(logbuf, wp->reply_in.out, logbuflen);
			while (logbuflen > 0
			       && (logbuf[logbuflen-1] == '\r'
				   || logbuf[logbuflen-1] == '\n'))
				--logbuflen;
			logbuf[logbuflen] = '\0';

			/* log only the first line */
			logbuflen = 0;
		}

		if (pass) {
			/* pass the next line upstream */
			smtp_pass_line(wp);
			if (cont == ' ')
				return dig;
		} else {
			/* we don't like multi-line responses */
			if (cont == ' ')
				return dig;

			*wp->reply_in.next_line = '\0';
			thr_error_msg(&wp->cw, "unacceptable multi-line"
				      " SMTP response"
				      " \"%s\" from proxy",
				      wp->reply_in.out);
			return -1;
		}
	}
}



/* pass an SMTP command from upstream or the SMTP client of our proxy
 *	downstream to the SMTP server of our proxy.
 *	Then relay the SMTP server's response upstream to the SMTP client */
static u_char				/* 0=server was unhappy */
smtp_pass_cmd(WORK *wp,
	      const char *reply,	/* send this response upstream if */
	      int reply_len,		/*	if downstream is happy */
	      char *logbuf,		/* logbuf response here */
	      int logbuflen)
{
	int len, result;

	/* fake it if the SMTP server is /dev/null */
	if (proxy_out_family == AF_UNSPEC) {
		smtp_send_reply(wp, reply, reply_len);
		return 1;
	}

	len = wp->msg_rd.next_line - wp->msg_rd.out;
	if (len != 0) {
		buf_write(wp, &wp->msg_wt, wp->msg_rd.out, len);
		buf_write_flush(wp, &wp->msg_wt);
	}

	/* wait for & pass on response */
	result = smtp_get_resp(wp, 1, logbuf, logbuflen);
	if (result < 0)
		job_exit(wp);
	return (result == reply[0]);
}

#define SMTP_PASS_CMD(r) smtp_pass_cmd(wp,SMTP_REPLY_##r,LITZ(SMTP_REPLY_##r), \
				       0, 0)



/* parse Postfix XFORWARD and XCLIENT commands
 * see http://www.postfix.org/XCLIENT_README.html
 * and http://www.postfix.org/XFORWARD_README.html
 *	Depend on the Postfix downstream to answer EHLO with XFORWRD */
static void
smtp_xpostfix(WORK *wp,
	      VERB_SMTP verb,		/* SMTP_VERB_XFORWARD or _XCLIENT */
	      const char *parm)
{
	const char *val, *end_parm;
	char addr[INET6_ADDRSTRLEN+1];
	DCC_SOCKU su;
	int i;

	wp->smtp_state = SMTP_ST_HELO;

	for (; ; parm = end_parm + strspn(end_parm, " \t")) {
		if (*parm == '\r' || *parm == '\n') {
			SMTP_PASS_CMD(250_POSTFIX);
			break;
		}

		/* find the value */
		val = strpbrk(parm, "= \t\r\n");
		if (*val++ != '=') {
			SMTP_REPLY(501_POSTFIX);
			break;
		}

		end_parm = strpbrk(val, " \t\r\n");

		if (!CLITCMP(parm, "NAME=")) {
			if (!CLITCMP(val, "[UNAVAILABLE]")
			    || !CLITCMP(val, "[TEMPUNAVAIL]")) {
				wp->cw.clnt_name[0] = '\0';
				continue;
			}
			i = min(ISZ(wp->cw.clnt_name)-1, end_parm-val);
			memcpy(wp->cw.clnt_name, val, i);
			wp->cw.clnt_name[i] = '\0';
			if (verb == SMTP_VERB_XCLIENT)
				wp->dfgs |= DFG_XCLIENT_NAME;
			else
				wp->dfgs &= ~DFG_XCLIENT_NAME;
			continue;
		}

		if (!CLITCMP(parm, "ADDR=")) {
			if (!CLITCMP(val, "[UNAVAILABLE]")
			    || !CLITCMP(val, "[TEMPUNAVAIL]")) {
				wp->cw.clnt_str[0] = '\0';
				continue;
			}
			if (!CLITCMP(val, DCC_IPV6_ALIT))
				val += LITZ(DCC_IPV6_ALIT);
			i = min(ISZ(addr)-1, end_parm-val);
			memcpy(addr, val, i);
			addr[i] = '\0';
			/* try to convert ASCCI representation of IP address to
			 * a canonical form and to a checksum */
			if (!str2su(&su, addr)) {
				thr_error_msg(&wp->cw,
					      "unrecognized IP address \"%s\"",
					      addr);
				wp->cw.clnt_str[0] = '\0';
				continue;
			}
			su2cks(&wp->cw.cks, &su);
			wp->cw.clnt_addr = wp->cw.cks.ip_addr;
			dcc_ipv6tostr(wp->cw.clnt_str, sizeof(wp->cw.clnt_str),
				      &wp->cw.clnt_addr);
			if (verb == SMTP_VERB_XCLIENT) {
				wp->dfgs |= DFG_XCLIENT_ADDR;
			} else {
				wp->dfgs &= ~DFG_XCLIENT_ADDR;
			}
			continue;
		}

		if (!CLITCMP(parm, "HELO=")) {
			if (!CLITCMP(val, "[UNAVAILABLE]")
			    || !CLITCMP(val, "[TEMPUNAVAIL]")) {
				wp->cw.helo[0] = '\0';
			} else {
				get_helo(wp, val, end_parm-val);
			}
			if (verb == SMTP_VERB_XCLIENT)
				wp->dfgs |= DFG_XCLIENT_HELO;
			else
				wp->dfgs &= ~DFG_XCLIENT_HELO;
			continue;
		}
	}

	wp->msg_rd.out = wp->msg_rd.next_line;
}



/* parse SMTP Rcpt_To command */
static u_char				/* 1=now seen >=1 good Rcpt command*/
get_smtp_rcpt(WORK *wp,
	      const char *path,
	      const char *epath)
{
	const char *user;
	int path_len, user_len;
	RCPT_ST *rcpt_st;

	path_len = epath - path;
	user = "";
	user_len = 0;
	if (!check_addr(wp, &path, &path_len, &user, &user_len)) {
		SMTP_REPLY(501_RCPT);
		wp->msg_rd.out = wp->msg_rd.next_line;
		return 0;
	}

	lock_work();
	wp->dfgs |= DFG_WORK_LOCK;
	rcpt_st = set_rcpt(wp, path, path_len, user, user_len);
	unlock_work();
	wp->dfgs &= ~DFG_WORK_LOCK;
	if (!rcpt_st) {
		SMTP_REPLY(452_2MANY);
		wp->msg_rd.out = wp->msg_rd.next_line;
		return 0;
	}

	/* if this recipient is incompatible with preceding recipients
	 * then reject it and remember to put something into the log */
	if (0 > cmn_compat_whitelist(&wp->cw, rcpt_st)) {
		--wp->cw.tgts;
		SMTP_REPLY(452_WLIST);
		wp->msg_rd.out = wp->msg_rd.next_line;
		BUFCPY(rcpt_st->rej_msg, SMTP_REPLY_452_WLIST);
		rcpt_st->fgs |= RCPT_FG_REJ_FILTER;
		return 0;
	}

	/* Try to pass the command in the buffer downstream.
	 * Forget this recipient if it is not good enough downstream.
	 * Let the downstream proxy do its own logging.
	 *	That way we need save only one bit instead of an SMTP
	 *	rejection message for our eventual per-user log file. */
	if (!smtp_pass_cmd(wp, SMTP_REPLY_250_RCPT, LITZ(SMTP_REPLY_250_RCPT),
			   rcpt_st->rej_msg, sizeof(rcpt_st->rej_msg))) {
		--wp->cw.tgts;
		wp->msg_rd.out = wp->msg_rd.next_line;
		if (rcpt_st->rej_msg[0] != '4')
			++wp->cw.mta_rej_tgts;
		wp->cw.ask_st |= ASK_ST_LOGIT;
		rcpt_st->fgs |= RCPT_FG_REJ_FILTER;
		return 0;
	}

	/* there was no problem if the downstream was happy */
	rcpt_st->rej_msg[0] = '\0';

	wp->msg_rd.out = wp->msg_rd.next_line;
	return 1;
}



static void
smtp_data_abort(WORK *wp)
{
	/* After a rejection Postfix wants a before-queue proxy to
	 * "abort the connnection"  to the SMTP server downstream.
	 * That might mean a simple TCP shutdown, but for testing with
	 * sendmail, send an SMTP RSET command. */
	if (proxy_out_family != AF_UNSPEC) {
		buf_write(wp, &wp->msg_wt, "RSET\r\n", LITZ("RSET\r\n"));
		buf_write_flush(wp, &wp->msg_wt);
		/* sendmail will respond, but what about Postfix? */
		if (smtp_get_resp(wp, 0, 0, 0) >= 0
		    && dcc_clnt_debug >= SMTP_DEBUG_TRACE) {
			smtp_trace(wp, "ignore response to RSET",
				   wp->reply_in.out,
				   wp->reply_in.next_line
				   - wp->reply_in.out);
			wp->reply_in.out = wp->reply_in.next_line;
		}
	}
}



/* We are rejecting the transaction with our generated reply */
static void
smtp_trans_reject(WORK *wp)
{
	if (dcc_clnt_debug >= SMTP_DEBUG_TRACE)
		thr_trace_msg(&wp->cw, "%s SMTP response: %s %s %s",
			      wp->cw.id,
			      wp->cw.reply.rcode, wp->cw.reply.xcode,
			      wp->cw.reply.str);

	if (wp->proxy_in_soc >= 0) {
		buf_write(wp, &wp->reply_out,
			  wp->cw.reply.rcode, strlen(wp->cw.reply.rcode));
		buf_write(wp, &wp->reply_out, " ", 1);
		buf_write(wp, &wp->reply_out,
			  wp->cw.reply.xcode, strlen(wp->cw.reply.xcode));
		buf_write(wp, &wp->reply_out, " ", 1);
		buf_write(wp, &wp->reply_out,
			  wp->cw.reply.str, strlen(wp->cw.reply.str));
		buf_write(wp, &wp->reply_out, "\r\n", 2);
		buf_write_flush(wp, &wp->reply_out);
		log_smtp_reply(&wp->cw);
	}

	if (wp->proxy_out_soc >= 0)
		smtp_data_abort(wp);
}



static void DCC_NORET
smtp_temp_fail(WORK *wp)
{
	make_reply(&wp->cw.reply, &dcc_fail_reply, &wp->cw, 0);
	smtp_trans_reject(wp);
	job_exit(wp);
}



/* Send the mail message to the SMTP server for our proxy. */
static const char *
smtp_data_send(WORK *wp)
{
	int class;
	int len;
	const char *result;

	/* First send the DATA command. */
	buf_write(wp, &wp->msg_wt, "DATA\r\n", LITZ("DATA\r\n"));
	buf_write_flush(wp, &wp->msg_wt);

	/* the server should respond with a 350 result */
	class = smtp_get_resp(wp, 0, 0, 0);
	if (class < 0)
		job_exit(wp);

	if (class == '3') {
		wp->reply_in.out = wp->reply_in.next_line;

		/* send the mail message to the SMTP server */
		body_copy(wp);
		buf_write(wp, &wp->msg_wt, ".\r\n", 3);
		buf_write_flush(wp, &wp->msg_wt);

		/* see what it has to say */
		class = smtp_get_resp(wp, 0, 0, 0);

	} else if (class != '4' && class != '5') {
		/* or quit if response to DATA was not 4yz or 5yz */
		thr_error_msg(&wp->cw, "unrecognized SMTP response"
			      " \"%s\" from proxy to DATA command",
			      wp->reply_in.out);
		job_exit(wp);
	}

	if (class == '2') {
		result = DCC_XHDR_RESULT_ACCEPT;
	} else {
		len = wp->reply_in.next_line - wp->reply_in.out;
		while (len > 0 && (wp->reply_in.out[len-1] == '\r'
				   || wp->reply_in.out[len-1] == '\n'))
			--len;
		if (len > ISZ(wp->cw.reply.str)-2)
			len = ISZ(wp->cw.reply.str)-2;
		memcpy(wp->cw.reply.str_buf, wp->reply_in.out, len);
		wp->cw.reply.str_buf[len++] = '\n';
		wp->cw.reply.str_buf[len] = '\0';
		wp->cw.reply.str = wp->cw.reply.str_buf;
		thr_log_print(&wp->cw, 0,
			      "SMTP server "DCC_XHDR_REJ_DATA_MSG"%.*s",
			      len, wp->cw.reply.str);
		if (dcc_clnt_debug)
			wp->cw.ask_st |= ASK_ST_LOGIT;
		result = "rejected by SMTP server";
	}

	/* pass SMTP server's response to the SMTP client */
	smtp_pass_line(wp);

	return result;
}



static void
smtp_data(WORK *wp)
{
	const char *global_result, *user_result;

	if (!wp->cw.num_rcpts) {
		/* never got SMTP DATA command */
		SMTP_ERROR(503_DATA);
		return;
	}

	/* tell STMP client to send the mail message */
	wp->msg_rd.out = wp->msg_rd.next_line;
	SMTP_REPLY(350);
	buf_write_flush(wp, &wp->reply_out);

	if (!get_body(wp)) {
		/* something went wrong while collecting the message body
		 * such as contacting the DCC server */
		smtp_temp_fail(wp);
		return;
	}

	/* get consensus of targets' wishes */
	users_process(&wp->cw);

	if (wp->cw.ask_st & ASK_ST_GREY_EMBARGO) {
		totals.tgts_embargoed += wp->cw.tgts;
		smtp_trans_reject(wp);
		global_result = wp->cw.reply.log_result;
		user_result = global_result;

	} else if (wp->cw.reject_tgts != 0) {
		switch (wp->cw.action) {
		case CMN_IGNORE:
			totals.tgts_ignored += wp->cw.reject_tgts;
			++totals.msgs_spam;
			if (proxy_out_family == AF_UNSPEC) {
				SMTP_REPLY(250_DATA);
				global_result = DCC_XHDR_RESULT_I_A;
			} else {
				global_result = smtp_data_send(wp);
			}
			user_result = global_result;
			break;

		case CMN_DISCARD:
			totals.tgts_discarded += wp->cw.reject_tgts;
			++totals.msgs_spam;
			/* discard the message by aborting the downstream
			 * SMTP session and telling the upstream 250-OK */
			if (proxy_out_family != AF_UNSPEC)
				smtp_data_abort(wp);
			SMTP_REPLY(250_DATA);
			global_result = DCC_XHDR_RESULT_DISCARD;
			user_result = global_result;
			break;

		case CMN_REJECT:
		default:
			totals.tgts_rejected += wp->cw.reject_tgts;
			++totals.msgs_spam;
			smtp_trans_reject(wp);
			global_result = wp->cw.reply.log_result;
			user_result = 0;
			break;
		}

	} else if (proxy_out_family == AF_UNSPEC) {
		SMTP_REPLY(250_DATA);
		global_result = DCC_XHDR_RESULT_ACCEPT;
		user_result = 0;

	} else {
		global_result = smtp_data_send(wp);
		user_result = 0;
	}

	/* log the consensus & generate SMTP rejection message if needed */
	users_log_result(&wp->cw, user_result);
	thr_log_print(&wp->cw, 0, DCC_XHDR_RESULT"%s\n", global_result);

	proxy_rset(wp);
}



/* use a subset of SMTP to talk to an MTA */
static void DCC_NORET
proxy_job(WORK *wp)
{
	char str[DCC_SU2STR_SIZE];
	DCC_SOCKU su;
	int out_soc;
	VERB_SMTP verb;
	const char *parmp, *eparmp;
	int i;

	wp->msg_rd.base = wp->buf1;
	wp->msg_rd.size = sizeof(wp->buf1);
	wp->msg_rd.socp = &wp->proxy_in_soc;

	wp->msg_wt.base = wp->buf2;
	wp->msg_wt.size = sizeof(wp->buf2);
	wp->msg_wt.socp = &wp->proxy_out_soc;

	wp->reply_in.base = wp->buf3;
	wp->reply_in.size = sizeof(wp->buf3);
	wp->reply_in.socp = &wp->proxy_out_soc;

	wp->reply_out.base = wp->buf4;
	wp->reply_out.size = sizeof(wp->buf4);
	wp->reply_out.socp = &wp->proxy_in_soc;

	if (proxy_out_family == AF_UNSPEC) {
		/* single-ended */
		;

	} else if (proxy_out_family == AF_UNIX) {
		out_soc = socket(AF_UNIX, SOCK_STREAM, 0);
		if (out_soc < 0) {
			thr_error_msg(&wp->cw, "proxy_out socket(AF_UNIX): %s",
				      ERROR_STR());
			smtp_temp_fail(wp);
		}
		if (0 > connect(out_soc,
				(struct sockaddr *)&proxy_out_sun,
				sizeof(listen_sun))) {
			thr_error_msg(&wp->cw,
				      "proxy_out connect(AF_UNIX,%s): %s",
				      proxy_out_sun.sun_path,
				      ERROR_STR());
			close(out_soc);
			smtp_temp_fail(wp);
		}
		if (!set_soc(&wp->cw.emsg, out_soc, AF_UNIX,
			     "proxy output")) {
			thr_error_msg(&wp->cw, "%s", wp->cw.emsg.c);
			close(out_soc);
			smtp_temp_fail(wp);
		}
		wp->proxy_out_soc = out_soc;
		wp->dfgs |= DFG_MTA_BODY;

	} else {
		if (proxy_out_su.sa.sa_family == AF_UNSPEC) {
			/* use SMTP client's IP address */
			if (wp->proxy_in_su.sa.sa_family == AF_INET)
				dcc_mk_inet_su(&su,
					       &wp->proxy_in_su.ipv4.sin_addr,
					       proxy_out_port);
			else
				dcc_mk_inet6_su(&su,
						&wp->proxy_in_su.ipv6.sin6_addr,
						0, proxy_out_port);
		} else {
			su = proxy_out_su;
		}
		out_soc = socket(su.sa.sa_family, SOCK_STREAM, 0);
		if (out_soc < 0) {
			thr_error_msg(&wp->cw, "proxy_out socket(%s): %s",
				      dcc_su2str(str, sizeof(str), &su),
				      ERROR_STR());
			close(out_soc);
			smtp_temp_fail(wp);
		}
		if (0 > connect(out_soc, &su.sa, DCC_SU_LEN(&su))) {
			thr_error_msg(&wp->cw,
				      "proxy_out connect(%s): %s",
				      dcc_su2str(str, sizeof(str), &su),
				      ERROR_STR());
			close(out_soc);
			smtp_temp_fail(wp);
		}
		if (!set_soc(&wp->cw.emsg, out_soc, su.sa.sa_family,
			     "proxy output")) {
			thr_error_msg(&wp->cw, "%s", wp->cw.emsg.c);
			close(out_soc);
			smtp_temp_fail(wp);
		}
		wp->proxy_out_soc = out_soc;
		wp->dfgs |= DFG_MTA_BODY;
	}

	/* open the connection to the nearest DCC server
	 * and figure out our X-DCC header */
	if (!ck_dcc_ctxt(&wp->cw)) {
		/* failed to create context */
		smtp_temp_fail(wp);
	}
	cks_init(&wp->cw.cks);
	dcc_dnsbl_init(&wp->cw.cks, wp->cw.dcc_ctxt, &wp->cw, wp->cw.id);
	wp->cw.cmn_fgs |= CMN_FG_LOG_EARLY;

	/* pass the banner upstream */
	wp->smtp_state = SMTP_ST_START;
	SMTP_PASS_CMD(220);

	/* assume for now that the IP address is the SMTP client to our proxy */
	if (wp->proxy_in_su.sa.sa_family != AF_UNIX) {
		if (wp->proxy_in_su.sa.sa_family == AF_INET) {
			dcc_ipv4toipv6(&wp->cw.clnt_addr,
				       wp->proxy_in_su.ipv4.sin_addr);
		} else {
			wp->cw.clnt_addr = (wp->proxy_in_su.ipv6.sin6_addr);
		}
		dcc_ipv6tostr(wp->cw.clnt_str, sizeof(wp->cw.clnt_str),
			      &wp->cw.clnt_addr);
	}

	for (;;) {
		buf_write_flush(wp, &wp->reply_out);
		if (!msg_read_line(wp, &wp->msg_rd)) {
			proxy_abort(wp, "SMTP session aborted");
			job_exit(wp);
		}
		verb = get_smtp_verb(wp, &parmp, &eparmp);

		/* deal with common SMTP commands */
		switch (verb) {
		case SMTP_VERB_ERR:
			wp->msg_rd.out = wp->msg_rd.next_line;
			continue;
		case SMTP_VERB_UNREC:
			/* pass anything we don't recognize to the SMTP server
			 * for our proxy.
			 * If we don't have a server, reject it */
			SMTP_PASS_CMD(500);
			wp->msg_rd.out = wp->msg_rd.next_line;
			continue;
		case SMTP_VERB_QUIT:
			SMTP_PASS_CMD(221);
			proxy_abort(wp, "SMTP session aborted with QUIT");
			job_exit(wp);
		case SMTP_VERB_RSET:
			SMTP_PASS_CMD(250_RSET);
			proxy_abort(wp, "SMTP transaction aborted with RSET");
			wp->msg_rd.out = wp->msg_rd.next_line;
			continue;
		case SMTP_VERB_HELO:
			proxy_abort(wp, "SMTP transaction aborted with HELO");
			wp->smtp_state = SMTP_ST_HELO;
			/* save helo value in case there is no XPOSTFIX */
			if (SMTP_PASS_CMD(250_HELO)
			    && wp->cw.helo[0] == '\0'
			    && !(wp->dfgs & DFG_XCLIENT_HELO))
				get_helo(wp, parmp, eparmp - parmp);
			wp->msg_rd.out = wp->msg_rd.next_line;
			continue;
		case SMTP_VERB_XCLIENT:
		case SMTP_VERB_XFORWARD:
		case SMTP_VERB_MAIL:
		case SMTP_VERB_RCPT:
		case SMTP_VERB_DATA:
			break;
		}

		switch (wp->smtp_state) {
		case SMTP_ST_START:	/* expecting HELO or perhaps MAIL */
		case SMTP_ST_HELO:	/* seen HELO */
			if (verb == SMTP_VERB_XCLIENT
			    || verb == SMTP_VERB_XFORWARD) {
				smtp_xpostfix(wp, verb, parmp);
				continue;
			}
			if (verb == SMTP_VERB_MAIL) {
				/* This might be a second message for the
				 * connection.
				 * Get sender, start logging, etc. at
				 * the Mail_From command. */
				if (SMTP_PASS_CMD(250_MAIL)) {
					log_start(&wp->cw);
					i = eparmp - parmp;
					if (i > ISZ(wp->cw.env_from)-1)
					    i = ISZ(wp->cw.env_from)-1;
					memcpy(wp->cw.env_from, parmp, i);
					wp->cw.env_from[i] = '\0';
					wp->smtp_state = SMTP_ST_TRANS;
				}
				wp->msg_rd.out = wp->msg_rd.next_line;
				get_sender(wp);
				continue;
			}
			break;

		case SMTP_ST_TRANS:	/* seen Mail_From */
			if (verb ==  SMTP_VERB_RCPT) {
				if (get_smtp_rcpt(wp, parmp, eparmp))
					wp->smtp_state = SMTP_ST_RCPT;
				continue;
			}
			break;

		case SMTP_ST_RCPT:	/* seen Rctp_To */
			if (verb == SMTP_VERB_RCPT) {
				get_smtp_rcpt(wp, parmp, eparmp);
				continue;
			}
			if (verb == SMTP_VERB_DATA) {
				smtp_data(wp);
				continue;
			}
			break;

		case SMTP_ST_ERROR:	/* no transaction until RSET or HELO */
			break;
		}

		/* reject anything out of sequence */
		SMTP_ERROR(503);
	}
}



/* start a new connection to an MTA */
static void * DCC_NORET
job_start(void *wp0)
{
	WORK *wp = wp0;

	/* working threads do not deal with signals */
	clnt_sigs_off(0);

	if (proxy)
		proxy_job(wp);
	else
		ascii_job(wp);
}
