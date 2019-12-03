/* Distributed Checksum Clearinghouse
 *
 * server
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
 * Rhyolite Software DCC 2.3.167-1.352 $Revision$
 */

#include "dccd_defs.h"
#include <signal.h>			/* for Linux and SunOS */
#include <sys/uio.h>
#include <sys/wait.h>
#include "dcc_ifaddrs.h"

DCC_EMSG dcc_emsg;

static const char *homedir;
static char *aargs[10];
static char **aarg = &aargs[0];
static DCC_PATH dbclean_def = {DCC_LIBEXECDIR"/dbclean"};
static char *dbclean = dbclean_def.c;
static pid_t dbclean_pid = -1;
static char dbclean_str[] = "dbclean";
#define MAX_DBCLEAN_FLAGS 50
static char dbclean_flags[MAX_DBCLEAN_FLAGS+1+1] = "-Pq";
static int dbclean_flags_len = LITZ("-Pq");
#define MAX_DBCLEAN_ARGS 20
static const char *dbclean_argv[MAX_DBCLEAN_ARGS+2+1] = {
	dbclean_str, dbclean_flags
};
static int dbclean_argc = 2;
static char dbclean_args_str[200];
static int dbclean_args_str_len;

/* do not try to run dbclean too often */
time_t dbclean_limit_secs = DBCLEAN_LIMIT_SECS;
static time_t dbclean_failed;

static double wfix_quiet_rate = 1.0;	/* max load that allows window fixing */
static double wfix_busy_rate;		/* measured active rate */
static double wfix_rate_change = 0.4;	/* rate reduction to this allows fix */
static DB_PTR wfix_size;
static u_char wfix_size_set = 0;
DBCLEAN_WFIX_STATE dbclean_wfix_state = WFIX_DELAY;
static double wfix_ops;
static time_t wfix_check_start;
static time_t dbclean_wfix_secs;	/* window fixing timer */
static time_t dbclean_wfix_range;
#define WFIX_POST_CLEAN_SECS (2*60*60)	/* do not fix it soon after cleaning */
#define WFIX_PRE_CLEAN_SECS (2*60*60)	/*	or just before cleaning */
#define WFIX_RECHECK_SECS   (15*60)	/* between checks for window overflow */
#define WFIX_QUIET_SECS	    (5*60)	/* waiting for clients to flee */
#define	WFIX_MEASURE_SECS   (5*60)	/* counting clients */

const char *need_del_dbclean;
time_t del_dbclean_next;
time_t dbclean_limit;
static time_t next_failsafe_clean_secs;	/* timer for missing cron job */
static time_t next_failsafe_clean_delay;
static time_t last_cron_clean;

int iflod_dup_chain;			/* hitting gross duplicate chains */

DCC_TRACEMASK tracemask;

u_char background = 1;
int stopint;				/* <0=stopping  >0=stop signaled */

static time_t flods_ck_secs = FLODS_CK_SECS;

const char *brand = "";

static char *my_srvr_id_str;
DCC_SRVR_ID my_srvr_id;

DCC_GETH use_ipv46 = DCC_GETH_DEF;
u_char have_ipv6_peer;
static u_char ipv4_works;
static u_char ipv6_works;

in_port_t def_port;			/* default port #, network byte order */
typedef struct port_list {
    struct port_list *fwd;
    in_port_t	port;			/* network byte order */
} PORT_LIST;
static PORT_LIST *ports;
SRVR_SOC *srvr_socs;
static SRVR_SOC **srvr_socs_end = &srvr_socs;
int socbuf;
static u_char socbuf_set = 0;

#ifdef DCC_USE_DBCLEAN_F
static DB_OPEN_MODES db_mode = DB_OPEN_WRITE | DB_OPEN_DCCD_DEFAULT;
#else
static DB_OPEN_MODES db_mode = DB_OPEN_MSYNC | DB_OPEN_DCCD_DEFAULT;
#endif

int grey_embargo = DEF_GREY_EMBARGO;	/* seconds to delay new traffic */
int grey_window = DEF_GREY_WINDOW;	/* wait as long as this */
int grey_white = DEF_GREY_WHITE;	/* remember this long */

char our_hostname[MAXHOSTNAMELEN];
DCC_SUM host_id_sum;			/* advertised with our server-ID */
time_t host_id_next, host_id_range;	/* when to advertise */

u_char anon_off;			/* turn off anonymous access */
DCC_PTIME anon_delay_us = DCC_ANON_DELAY_US_DEF;    /* delay anonymous clients */
u_int anon_delay_inflate = DCC_ANON_INFLATE_OFF;

u_char stop_mode;			/* 0=normal  1=reboot  2=DB sync'ed */

static int total_ops;
static QUEUE *queue_free;
static QUEUE *queue_head;

/* assume or hope we can handle 500 requests/second */
u_int queue_max = 500*DCC_MAX_RTT_SECS;	/* ultimate bound on queue size */
static u_char queue_max_set = 0;
static u_int queue_cur;			/* current queue size */

struct timeval wake_time;		/* when we awoke from select() */
struct timeval req_recv_time;		/* when request arrived */

DCC_TS future;				/* timestamp sanity */


static DB_NOKEEP_CKS set_new_nokeep_cks, reset_new_nokeep_cks;

DCC_TGTS flod_tholds[DCC_DIM_CKS];	/* flood at or after these thresholds */

static const char *parse_rl_rate(RL_RATE *, float, const char *, const char *);
static void add_dbclean_flag(char);
static void add_dbclean_arg(const char *);
static void check_dbclean(int);
static void run_dbclean(const char *, const char *);
static void sigterm(int);
static void sighup(int);
static void stop_children(void);
static u_char get_if_changes(u_char);
static SRVR_SOC *add_srvr_soc(u_char, const DCC_SOCKU *, in_port_t);
static void add_srvr_soc_any(SRVR_SOC **, SRVR_SOC **, u_char, in_port_t);
static int open_srvr_socs(int);
static void wfix_later(time_t);
static void recv_job(void) DCC_NORET;
static u_char new_job(SRVR_SOC *);
static void dccd_quit(void);

static void
usage(const char* barg)
{
	static const char usage_str[] = {
	    "usage: [-dVbfFQ] -i server-ID [-n brand] [-h homedir]\n"
	    "   [-I [host-ID][,user]] [-a [server-addr][,server-port]]"
	    " [-q qsize]\n"
	    "   [-G [on,][weak-body,][weak-IP,]embargo],[window],[white]]\n"
	    "   [-W [rate][,chg][,dbsize]] [-K [no-]type] [-T [no-]tracemode]\n"
	    "   [-u anon-delay[,inflate] [-C dbclean]"
	    " [-L ltype,facility.level]\n"
	    "   [-R [RL_SUB],[RL_FREE],[RL_ALL_FREE],[RL_BUGS]]"
	};
	static u_char complained;

	if (!complained) {
		if (barg)
			dcc_error_msg("unrecognized \"%s\"\n%s\n..."
				      " continuing",
				      barg, usage_str);
		else
			dcc_error_msg("%s\n... continuing", usage_str);
		complained = 1;
	}
}


int
main(int argc, char **argv)
{
	char *p;
	const char *rest;
	u_char print_version = 0;
	DCC_CK_TYPES type;
	DCC_SOCKU *sup;
	in_port_t port;
	char *addr_str;
	int new_embargo, new_window, new_white;
	DCC_TRACEMASK bit, trace_off = 0;
	int error, i;
	const char *cp;
	DCC_PATH msg_path;
	double d1, d2;
	u_long l;

	dcc_syslog_init(1, argv[0], 0);

	/* Ensure that arrays of DCC_CKs contain an even number
	 * so that structures containing them will have no structure packing */
	if (DCC_DIM_CKS != (DCC_DIM_CKS/2)*2)
		dcc_logbad(EX_SOFTWARE, "DCC_DIM_CKS is not even");

	/* get first bytes of our hostname to name our server-ID */
	memset(our_hostname, 0, sizeof(our_hostname));
	if (0 > gethostname(our_hostname, sizeof(our_hostname)-1))
		dcc_logbad(EX_NOHOST, "gethostname(): %s", ERROR_STR());
	our_hostname[sizeof(our_hostname)-1] = '\0';
	if (our_hostname[0] == '\0')
		dcc_logbad(EX_NOHOST, "null host name from gethostname()");
	strncpy((char *)host_id_sum.b, our_hostname, sizeof(host_id_sum));

	/* fix dccd.man if these change */
	parse_rl_rate(&rl_sub_rate, 0.5, "RL_SUB", "400");
	parse_rl_rate(&rl_anon_rate, RL_AVG_SECS, "RL_ANON", "50");
	parse_rl_rate(&rl_all_anon_rate, 0.5, "RL_ALL_ANON", "2000");
	parse_rl_rate(&rl_bugs_rate, RL_AVG_SECS, "RL_BUGS", "0.1");

	/* this must match DCCD_GETOPTS in cron-dccd.in */
	while ((i = getopt(argc, argv,
			   "64dVbfFQi:n:h:a:I:q:G:t:W:K:T:u:C:L:R:")) != -1) {
		switch (i) {
		case '6':
		case '4':
			/* obsolete with *.2.104 */
			break;

		case 'd':
			add_dbclean_flag('d');
			++db_debug;
			break;

		case 'V':
			dcc_version_print();
			print_version = 1;
			break;

		case 'b':
			background = 0;
			break;

		case 'f':
			db_mode &= ~(DB_OPEN_MSYNC | DB_OPEN_WRITE
				     | DB_OPEN_DCCD_DEFAULT);
			db_mode |= DB_OPEN_MSYNC;
			add_dbclean_flag('f');
			break;

		case 'F':
			db_mode &= ~(DB_OPEN_MSYNC | DB_OPEN_WRITE
				     | DB_OPEN_DCCD_DEFAULT);
			db_mode |= DB_OPEN_WRITE;
			add_dbclean_flag('F');
			break;

		case 'Q':
			query_only = 1;
			break;

		case 'i':
			my_srvr_id_str = optarg;
			if (!dcc_get_srvr_id(&dcc_emsg, &my_srvr_id,
					     my_srvr_id_str, 0, 0, 0))
				dcc_logbad(emsg_ex_code(&dcc_emsg),
					   "%s", dcc_emsg.c);
			add_dbclean_arg("-i");
			add_dbclean_arg(my_srvr_id_str);
			break;

		case 'n':
			/* RFC 2822 says "values between 33 and 126" */
			cp = optarg;
			while (*cp >= 33 && *cp <= 126 && *cp != ':')
				++cp;
			if (cp == optarg
			    || (cp - optarg) > ISZ(DCC_BRAND)
			    || *cp != '\0') {
				dcc_error_msg("invalid brand name \"-n %s\"",
					      optarg);
			} else {
				brand = optarg;
			}
			break;

		case 'h':
			homedir = optarg;
			/* Tell dbclean "-h ." because we will already
			 * be there and that allows our -h to be relative. */
			add_dbclean_arg("-h.");
			break;

		case 'I':
			p = strchr(optarg, ',');
			if (p) {
				*p++ = '\0';
				dcc_daemon_su(p);
				if (*optarg == '\0')
					break;
			}
			if (*optarg != '\0')
				strncpy((char *)host_id_sum.b, optarg,
					sizeof(host_id_sum));
			break;

		case 'a':
			/* postpone checking host names until we know -6 */
			if (aarg > LAST(aargs)) {
				dcc_error_msg("too many -a args");
				break;
			}
			optarg += strspn(optarg, DCC_WHITESPACE);
			*aarg++ = optarg;
			break;

		case 'q':
			l = strtoul(optarg, &p, 10);
			if (*p != '\0' || l < 2 || l > 1000) {
				dcc_error_msg("invalid queue length \"%s\"",
					      optarg);
			} else {
				queue_max = l;
				queue_max_set = 1;
			}
			break;

		case 'G':
			grey_on = 1;
			dcc_syslog_init(1, argv[0], " grey");
			add_dbclean_arg("-Gon");
			/* handle leading "on" "weak-body", and "weak-IP" */
			rest = optarg;
			while (*rest) {
				if (ck_word_comma(&rest, "weak-body")
				    || ck_word_comma(&rest, "weak_body")
				    || ck_word_comma(&rest, "weak")) {
					grey_weak_body = 1;
					continue;
				}
				if (ck_word_comma(&rest, "weak-IP")
				    || ck_word_comma(&rest, "weak_IP")) {
					grey_weak_ip = 1;
					continue;
				}
				if (!ck_word_comma(&rest, "on"))
					break;
			}
			new_embargo = dcc_get_secs(rest, &rest,
						   0, MAX_GREY_EMBARGO,
						   grey_embargo);
			if (new_embargo < 0) {
				dcc_error_msg("invalid greylist embargo"
					      " \"-G %s\"", optarg);
				break;
			}
			new_window = dcc_get_secs(rest, &rest,
						  new_embargo, MAX_GREY_WINDOW,
						  max(new_embargo,grey_window));
			if (new_window < 0) {
				dcc_error_msg("invalid greylist wait time"
					      " \"-G %s\"", optarg);
				break;
			}
			new_white = dcc_get_secs(rest, &rest,
						 new_window, MAX_GREY_WHITE,
						 max(new_window, grey_white));
			if (new_white < 0 || *rest != '\0') {
				dcc_error_msg("invalid greylist whitelist time"
					      " \"-G %s\"", optarg);
				break;
			}
			grey_embargo = new_embargo;
			grey_window = new_window;
			grey_white = new_white;
			break;

		case 't':		/* obsolete */
			break;

		case 'W':
			p = optarg;
			if (*p == '\0') {
				dcc_error_msg("unrecognized"
					      " \"-W %s\"", optarg);
				break;
			}
			d1 = wfix_quiet_rate;
			if (*p != '\0' && *p != ',') {
				d1 = strtod(p, &p);
				if ((*p != '\0' && *p != ',')
				    || d1 < 0.0 || d1 > 1000*1000.0) {
					dcc_error_msg("bad quiet rate in"
						      " \"-W %s\"", optarg);
					break;
				}
			}
			if (*p == ',')
				++p;
			d2 = wfix_rate_change;
			if (*p != '\0' && *p != ',') {
				d1 = strtod(p, &p);
				if ((*p != '\0' && *p != ',')
				    || d1 < 0.0 || d1 > 1.0) {
					dcc_error_msg("bad rate change in"
						      " \"-W %s\"", optarg);
					break;
				}
			}
			if (*p == ',')
				++p;
			l = wfix_size/(1024*1024);
			if (*p != '\0') {
				l = strtoul(p, &p, 10);
				if ((*p != '\0' || l < DB_MIN_MIN_MBYTE
				     || l > MAX_MAX_DB_MBYTE)
				    && l != wfix_size) {
					dcc_error_msg("bad database size in"
						      " \"-W %s\"", optarg);
					break;
				}
			}
			wfix_quiet_rate = d1;
			wfix_rate_change = d2;
			if (wfix_size/(1024*1024) != l) {
				wfix_size = ((DB_PTR)l)*(1024*1024);
				wfix_size_set = 1;
			}
			break;

		case 'K':
			if (!strcasecmp(optarg, "all")) {
				reset_new_nokeep_cks = -1;
				break;
			}
			if (!CLITCMP(optarg, "no-")
			    || !CLITCMP(optarg, "no_")) {
				optarg += LITZ("no-");
				i = 0;
			} else {
				i = 1;
			}
			type = dcc_str2type_db(optarg, -1);
			if (type == DCC_CK_INVALID) {
				dcc_error_msg("bad checksum type in"
					      " \"-K %s\"", optarg);
				break;
			}
			if (i)
				DB_SET_NOKEEP(reset_new_nokeep_cks, type);
			else
				DB_SET_NOKEEP(set_new_nokeep_cks, type);
			break;

		case 'T':
			if (!CLITCMP(optarg, "no-")) {
				optarg += LITZ("no-");
				i = 0;
			} else {
				i = 1;
			}
			bit = 0;
			if (!strcasecmp(optarg, "ADMN")) {
				bit = DCC_TRACE_ADMN_BIT;
			} else if (!strcasecmp(optarg, "ANON")) {
				bit = DCC_TRACE_ANON_BIT;
			} else if (!strcasecmp(optarg, "CLNT")) {
				bit = DCC_TRACE_CLNT_BIT;
			} else if (!strcasecmp(optarg, "RLIM")) {
				bit = DCC_TRACE_RLIM_BIT;
			} else if (!strcasecmp(optarg, "QUERY")) {
				bit = DCC_TRACE_QUERY_BIT;
			} else if (!strcasecmp(optarg, "RIDC")) {
				bit = DCC_TRACE_RIDC_BIT;
			} else if (!strcasecmp(optarg, "FLOOD1")
				   || !strcasecmp(optarg, "FLOOD")) {
				bit = DCC_TRACE_FLOD1_BIT;
			} else if (!strcasecmp(optarg, "FLOOD2")) {
				bit = DCC_TRACE_FLOD2_BIT;
			} else if (!strcasecmp(optarg, "IDS")) {
				;	/* obsolete */;
			} else if (!strcasecmp(optarg, "BL")) {
				bit = DCC_TRACE_BL_BIT;
			} else if (!strcasecmp(optarg, "DB")) {
				bit = DCC_TRACE_DB_BIT;
			} else if (!strcasecmp(optarg, "WLIST")) {
				bit = DCC_TRACE_WLIST_BIT;
			} else {
				dcc_error_msg("invalid trace mode \"%s\"",
					      optarg);
			}
			if (i) {
				tracemask |= bit;
				trace_off &= ~bit;
			} else {
				tracemask &= ~bit;
				trace_off |= bit;
			}
			break;

		case 'u':
			i = parse_dccd_delay(&dcc_emsg, &anon_delay_us,
					     &anon_delay_inflate, optarg,
					     0, 0);
			if (!i) {
				dcc_error_msg("%s", dcc_emsg.c);
			} else if (i == 2) {
				anon_off = 1;
			} else {
				anon_off = 0;
			}
			break;

		case 'C':
			if (*optarg == '\0') {
				dcc_error_msg("no path to dbclean \"-C %s\"",
					      optarg);
				break;
			}
			/* capture the path to the dbclean program */
			dbclean = optarg;
			/* capture any args following the program */
			for (p = strpbrk(optarg, DCC_WHITESPACE);
			     p != 0;
			     p = strpbrk(p, DCC_WHITESPACE)) {
				*p++ = '\0';
				p += strspn(p, DCC_WHITESPACE);
				if (*p == '\0')
					break;
				add_dbclean_arg(p);
			}
			break;

		case 'L':
			if (dcc_parse_log_opt(optarg)) {
				add_dbclean_arg("-L");
				add_dbclean_arg(optarg);
			}
			break;

		case 'R':
			rest = parse_rl_rate(&rl_sub_rate, -1.0,
					     "RL_SUB", optarg);
			rest = parse_rl_rate(&rl_anon_rate, -1.0,
					     "RL_ANON", rest);
			rest = parse_rl_rate(&rl_all_anon_rate, -1.0,
					     "RL_ALL_ANON", rest);
			rest = parse_rl_rate(&rl_bugs_rate, -1.0,
					     "RL_BUGS", rest);
			break;

		default:
			usage(optopt2str(optopt));
		}
	}
	argc -= optind;
	argv += optind;
	if (argc != 0)
		usage(argv[0]);

	if (my_srvr_id == DCC_ID_INVALID) {
		if (print_version)
			exit(EX_OK);
		dcc_logbad(EX_USAGE, "server-ID not set with -i");
	}

	if (grey_on) {
		anon_off = 1;
		tracemask |= (DCC_TRACE_GREY_DEF & ~trace_off);
	} else {
		tracemask |= (DCC_TRACE_DEF & ~trace_off);
	}

	/* delay checking IPv4 & IPv6 until debugging is known
	 * for the messages */
	if (ipv_check(&dcc_emsg, AF_INET, 0)) {
		ipv4_works = 1;
	} else {
		/* always complain about no IPv4 */
		dcc_error_msg("%s", dcc_emsg.c);
		ipv4_works = 0;
	}
	if (ipv_check(&dcc_emsg, AF_INET6, 0)) {
		ipv6_works = 1;
	} else {
		if (db_debug)
			dcc_error_msg("%s", dcc_emsg.c);
		ipv6_works = 0;
	}

	if (!ipv4_works && ipv6_works) {
		use_ipv46 = DCC_GETH_V6;
	} else if (ipv4_works && !ipv6_works) {
		use_ipv46 = DCC_GETH_V4;
	}

	/* parse addresses after we know whether IPv4 and IPv6 are disabled */
	addr_str = 0;
	for (aarg = &aargs[0]; aarg <= LAST(aargs) && *aarg; ++aarg) {
		char hostname[DCC_MAXDOMAINLEN];

		if (!addr_str)
			addr_str = *aarg;
		rest = dcc_parse_nm_port(&dcc_emsg, *aarg, 0,
					 hostname, sizeof(hostname),
					 &port, 0, 0, 0, 0);
		if (!rest) {
			dcc_error_msg("%s", dcc_emsg.c);
			continue;
		}
		rest += strspn(rest, DCC_WHITESPACE);
		if (*rest != '\0')
			dcc_error_msg("unrecognized port number in"
				      "\"-a %s\"", *aarg);
		/* null hostname = "separate sockets on all local interfaces" */
		if (hostname[0] == '\0') {
			PORT_LIST *pport = dcc_malloc(sizeof(*pport));
			pport->port = port;
			pport->fwd = ports;
			ports = pport;
			continue;
		}
		/* allow "@" for upward compatibility */
		if (!strcmp(hostname, "@"))
			hostname[0] = '*';
		dcc_host_lock();
		if (!dcc_get_host(hostname, use_ipv46, &error)) {
			dcc_host_unlock();
			dcc_error_msg("%s: %s", *aarg, H_ERROR_STR1(error));
			continue;
		}
		for (sup = dcc_hostaddrs; sup < dcc_hostaddrs_end; ++sup) {
			SRVR_SOC *sp;

			sp = add_srvr_soc(SRVR_SOC_ADDR | SRVR_SOC_NEW,
					  sup, port);
			if ((sp->flags & SRVR_SOC_NEW)
			    && db_debug != 0) {
				dcc_trace_msg("start request listening on %s",
					      dcc_su2str_err(&sp->udp_su));
				sp->flags &= ~SRVR_SOC_NEW;
			}
		}
		dcc_host_unlock();
	}
	if (addr_str) {
		/* tell dbclean about one "-a addr" */
		add_dbclean_arg("-a");
		add_dbclean_arg(addr_str);
	}

	if (!queue_max_set) {
		queue_max = rl_sub_rate.per_sec*2;
		if (!anon_off)
			queue_max += rl_all_anon_rate.per_sec;
		queue_max /= RL_SCALE;
		queue_max *= DCC_MAX_RTT_SECS;
	}

	dcc_clnt_unthread_init();
	if (!dcc_cdhome(&dcc_emsg, homedir, 0))
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);

	i = check_load_ids(1);
	if (i < 0)
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);
	else if (!i)
		dcc_error_msg("%s", dcc_emsg.c);

	if (!def_port)
		def_port = DCC_GREY2PORT(grey_on);
	if (!srvr_socs && !ports) {
		/* listen to at least one port */
		ports = dcc_malloc(sizeof(*ports));
		ports->fwd = 0;
		ports->port = def_port;
	}
	get_if_changes(db_debug != 0);

	/* make initial attempt to open the server UDP sockets */
	if (open_srvr_socs(45) <= 0)
		dcc_logbad(EX_OSERR, "failed to open any server sockets");

	if (background) {
		if (0 > daemon(1, 0))
			dcc_logbad(EX_OSERR, "daemon(): %s", ERROR_STR());
	}

	if (!background)
		signal(SIGHUP, sigterm);    /* SIGHUP fatal during debugging */
	else
		signal(SIGHUP, sighup);	/* speed configuration check */
	signal(SIGTERM, sigterm);
	signal(SIGINT, sigterm);
	signal(SIGPIPE, SIG_IGN);
#ifdef SIGXFSZ
	signal(SIGXFSZ, SIG_IGN);
#endif

	atexit(stop_children);

	gettimeofday(&db_time, 0);
	wake_time = db_time;

	flod_mmap_path_set();

	/* open the database, and try once to fix it */
	if (!dccd_db_open(DB_OPEN_LOCK_NOWAIT)) {
		dcc_error_msg("%s", dcc_emsg.c);
		run_dbclean("SRbad", "database initially broken");
		check_dbclean(0);	/* stall until dbclean finishes */
		if (!dccd_db_open(DB_OPEN_LOCK_NOWAIT)) {
			dcc_error_msg("%s", dcc_emsg.c);
			dcc_logbad(EX_NOINPUT,
				   "could not start database %s",
				   dcc_fnm2abs_msg(&msg_path, db_nm.c));
		}
	}
	/* do not start if dbclean is running */
	if (!lock_dbclean(&dcc_emsg, db_nm.c))
		dcc_logbad(emsg_ex_code(&dcc_emsg),
			   "%s: dbclean already running?", dcc_emsg.c);
	unlock_dbclean();

	host_id_next = db_time.tv_sec + (host_id_range = 5);
	check_blacklist_file();
	flods_init();
	rl_init();

	stats_clear();
	/* get counters from the file unless they have never been set */
	if (flod_mmaps != 0
	    && flod_mmaps->dccd_stats.reset != 0) {
		memcpy(&dccd_stats, &flod_mmaps->dccd_stats,
		       sizeof(dccd_stats));
	}
	dcc_trace_msg(DCC_VERSION" listening to port %d  %s",
		      ntohs(DCC_SU_PORT(&srvr_socs->udp_su)), dcc_homedir.c);

	recv_job();
}



static SRVR_SOC *			/* 0 or new entry */
add_srvr_soc(u_char flags,
	     const DCC_SOCKU *sup,
	     in_port_t port)
{
	SRVR_SOC *sp;

	/* notice duplicates or previously known interfaces */
	for (sp = srvr_socs; sp; sp = sp->fwd) {
		if (DCC_SUnP_EQ(&sp->udp_su, sup)
		    && DCC_SU_PORT(&sp->udp_su) == port)
			return sp;
	}

	sp = dcc_malloc(sizeof(*sp));
	memset(sp, 0, sizeof(*sp));
	sp->flags = flags;
	sp->udp = -1;
	sp->listen = -1;
	sp->udp_su = *sup;
	DCC_SU_PORT(&sp->udp_su) = port;

	*srvr_socs_end = sp;
	srvr_socs_end = &sp->fwd;

	return sp;
}



/* add one or two socket addresses for INADDR_ANY */
static void
add_srvr_soc_any(SRVR_SOC **sp1p, SRVR_SOC **sp2p, u_char flags, in_port_t port)
{
	DCC_SOCKU su;
	SRVR_SOC *sp;

	/* first create the IPv4 socket */
	if (use_ipv46 == DCC_GETH_V6) {
		sp = 0;
	} else {
		dcc_mk_su(&su, AF_INET, 0, 0, port);
		sp = add_srvr_soc(flags, &su, port);
	}
	if (sp1p)
		*sp1p = sp;

	/* then create the IPv6 socket */
	if (use_ipv46 == DCC_GETH_V4) {
		sp = 0;
	} else {
		dcc_mk_su(&su, AF_INET6, 0, 0, port);
		sp = add_srvr_soc(flags, &su, port);
	}
	if (sp2p)
		*sp2p = sp;
}



static int				/* # of sockets opened */
open_srvr_socs(int retry_secs)
{
	int *retry_secsp;
	SRVR_SOC *sp;
	int num_socs = 0;

	if (stopint)
		return -1;

	retry_secsp = retry_secs ? &retry_secs : 0;

	for (sp = srvr_socs; sp; sp = sp->fwd) {
		if (sp->udp >= 0) {
			++num_socs;
			continue;
		}

		/* resolve default port number if we finally know it */
		if (!DCC_SU_PORT(&sp->udp_su))
			DCC_SU_PORT(&sp->udp_su) = def_port;

		if (!udp_create(&dcc_emsg, &sp->udp,
				    &sp->udp_su, 1, 1, retry_secsp)) {
			dcc_error_msg("%s", dcc_emsg.c);
			continue;
		}

		if (!set_rcvbuf(&dcc_emsg, sp->udp, &sp->udp_su,
				&socbuf, &socbuf_set))
				dcc_error_msg("%s", dcc_emsg.c);

		++num_socs;
	}

	return num_socs;
}



/* get ready to bind to local IP addreses */
static u_char				/* 1=added an interface */
add_ifs(u_char not_quiet)
{
	u_char added;
	PORT_LIST *pport;
	static u_char complained;
#ifdef HAVE_GETIFADDRS
	struct ifaddrs *ifap0, *ifap;
	int num_ifs;
#endif

	/* look at the interfaces only if there is at least one port number
	 * without an associated IP addresses */
	if (!ports)
		return 0;

	added = 0;

#ifdef HAVE_GETIFADDRS
	if (0 > getifaddrs(&ifap0)) {
		dcc_error_msg("getifaddrs(): %s", ERROR_STR());
		ifap0 = 0;
	}

	/* Assume we have only site- or link-local IPv6 interfaces.
	 * Prefer IPv4 until we find a non-trivial IPv6 interface. */
	if (use_ipv46 == DCC_GETH_V64)
		use_ipv46 = DCC_GETH_V46;

	num_ifs = 0;
	for (pport = ports; pport; pport = pport->fwd) {
		const DCC_SOCKU *sup;
		const SRVR_SOC *ipv4_any_listener = 0;
		const SRVR_SOC *ipv6_any_listener = 0;
		const SRVR_SOC **any_listenerp = 0;

		for (ifap = ifap0; ifap; ifap = ifap->ifa_next) {
			SRVR_SOC *sp;

			if (!(ifap->ifa_flags & IFF_UP))
				continue;
			sup = (DCC_SOCKU *)ifap->ifa_addr;
			if (!sup)
				continue;
			switch (sup->sa.sa_family) {
			case AF_INET:
				if (use_ipv46 == DCC_GETH_V6)
					continue;
				++num_ifs;
				any_listenerp = &ipv4_any_listener;
				break;
			case AF_INET6:
				if (use_ipv46 == DCC_GETH_V4)
					continue;
				++num_ifs;
				any_listenerp = &ipv6_any_listener;
				break;
			default:
				continue;
			}

			sp = add_srvr_soc(SRVR_SOC_IF | SRVR_SOC_NEW,
					  sup, pport->port);
			if (sp->flags & SRVR_SOC_NEW) {
				added = 1;
				if (not_quiet)
					dcc_trace_msg("start request listening"
						      " on %s",
						      dcc_su2str_err(&sp
							  ->udp_su));
			}
			sp->flags &= ~(SRVR_SOC_MARK | SRVR_SOC_NEW);

			/* The first IPv4 and IPv6 UDP sockets have associated
			 * TCP INADDR_ANY sockets listening for incoming
			 * flood connections */
			if (*any_listenerp == sp) {
				/* Interfaces can have duplicate addresses */
				continue;
			}
			if (!*any_listenerp) {
				*any_listenerp = sp;
				if (!(sp->flags & SRVR_SOC_ANY_LISTEN)) {
					sp->flags |= SRVR_SOC_ANY_LISTEN;
					added = 1;
				}
				continue;
			}

			if (sp->flags & SRVR_SOC_ANY_LISTEN) {
				sp->flags &= ~SRVR_SOC_ANY_LISTEN;
				added = 1;
			}
		}
	}
#ifdef HAVE_FREEIFADDRS
	/* since this is done only a few times when HAVE_FREEIFADDRS is not
	 * defined, don't worry if we cannot release the list of interfaces */
	if (ifap0)
		freeifaddrs(ifap0);
#endif

	if (num_ifs > 0) {
		complained = 0;
		return added;
	}
#endif /* HAVE_GETIFADDRS */

	if (!complained) {
		dcc_error_msg("failed to find any network interfaces"
			      " with getifaddrs()");
		complained = 1;
	}

	/* we got no joy from getifaddrs(), so add INADDR_ANY sockets */
	for (pport = ports; pport; pport = pport->fwd) {
		SRVR_SOC *sp1, *sp2;

		add_srvr_soc_any(&sp1, &sp2,
				 SRVR_SOC_NEW
				 | SRVR_SOC_IF | SRVR_SOC_ANY_LISTEN,
				 pport->port);
		if (sp1) {
			if (sp1->flags & SRVR_SOC_NEW) {
				added = 1;
				if (not_quiet)
					dcc_trace_msg("request listening on %s",
						      dcc_su2str_err(&sp1
							  ->udp_su));
			}
			sp1->flags &= ~(SRVR_SOC_MARK | SRVR_SOC_NEW);
		}

		if (sp2) {
			if (sp2->flags & SRVR_SOC_NEW) {
				added = 1;
				if (not_quiet)
					dcc_trace_msg("request listening on %s",
						      dcc_su2str_err(&sp2
							  ->udp_su));
			}
			sp2->flags &= ~(SRVR_SOC_MARK | SRVR_SOC_NEW);
		}
	}

	return added;
}



/* deal with changes to network interfaces */
static u_char				/* 1=something changed */
get_if_changes(u_char not_quiet)
{
	SRVR_SOC *sp, **spp;
	u_char changed;

	for (sp = srvr_socs; sp; sp = sp->fwd) {
		if (sp->flags & SRVR_SOC_IF)
			sp->flags |= SRVR_SOC_MARK;
	}

	changed = add_ifs(not_quiet);

	have_ipv6_peer = 0;

	spp = &srvr_socs;
	while ((sp = *spp) != 0) {
		/* an interface recognized by add_srvr_soc() will have
		 * its SRVR_SOC_MARK cleared */
		if (!(sp->flags & SRVR_SOC_MARK)) {
			/* switch to prefering IPv6 if this is a
			 * non-trivial IPv6 address */
			if (sp->udp_su.sa.sa_family == AF_INET6
			    && !dcc_su_is_loopback(&sp->udp_su)
			    && !DCC_SU_IS_LINKLOCAL(&sp->udp_su)
			    && !DCC_SU_IS_SITELOCAL(&sp->udp_su)) {
				have_ipv6_peer = 1;
				if (use_ipv46 == DCC_GETH_V46)
					use_ipv46 = DCC_GETH_V64;
			}

			spp = &sp->fwd;

		} else {
			/* Forget interfaces that have disappeared. */
			dcc_trace_msg("stop listening on %s",
				      dcc_su2str_err(&sp->udp_su));
			changed = 1;
			if (srvr_socs_end == &sp->fwd)
				srvr_socs_end = spp;
			*spp = sp->fwd;

			if (sp->udp >= 0)
				close(sp->udp);
			if (sp->listen >= 0)
				close(sp->listen);
			dcc_free(sp);
		}
	}

	return changed;
}



static const char *
parse_rl_rate(RL_RATE *rate, float penalty_secs,
	      const char *label, const char *arg)
{
	char *p;
	int per_sec, hi;

	if (penalty_secs >= 0.0)
		rate->penalty_secs = penalty_secs;

	if (*arg == '\0')
		return arg;

	if (*arg == ',')
		return ++arg;

	per_sec = strtod(arg, &p) * RL_SCALE;
	hi = per_sec*RL_AVG_SECS;
	if ((*p != '\0' && *p != ',')
	    || hi < RL_SCALE || per_sec > RL_MAX_CREDITS) {
		dcc_error_msg("invalid %s value in \"%s\"",
			      label, arg);
		return "";
	}

	/* maximum events/second * RL_SCALE */
	rate->per_sec = per_sec;

	/* maximum allowed accumulated credits */
	rate->hi = hi;

	/* minimum credit account balance */
	rate->lo = -per_sec * rate->penalty_secs;

	return (*p == ',') ? p+1 : p;
}



static void
add_dbclean_flag(char flag)
{
	if (dbclean_flags_len >= MAX_DBCLEAN_FLAGS)
		dcc_logbad(EX_SOFTWARE, "too many flags for dbclean");
	dbclean_flags[dbclean_flags_len++] = flag;
}



static void
add_dbclean_arg(const char *arg)
{
	int i;

	if (dbclean_argc >= MAX_DBCLEAN_ARGS)
		dcc_logbad(EX_SOFTWARE, "too many args for dbclean");
	dbclean_argv[dbclean_argc++] = arg;
	i = snprintf(dbclean_args_str+dbclean_args_str_len,
		     sizeof(dbclean_args_str)-dbclean_args_str_len,
		     " %s", arg);
	dbclean_args_str_len += i;
	if (dbclean_args_str_len >= ISZ(dbclean_args_str)-2)
		dcc_logbad(EX_SOFTWARE, "too many args for dbclean");
}



/* check effort to repair database */
static void
check_dbclean(int options)
{
	int status;
	pid_t pid;
	u_char ok;

	if (dbclean_pid < 0)
		return;

	pid = waitpid(dbclean_pid, &status, options);
	if (pid != dbclean_pid)
		return;

	dbclean_pid = -1;

	/* do not try failing dbclean too often */
#if defined(WIFEXITED) && defined(WEXITSTATUS) && defined(WTERMSIG) && defined(WIFSIGNALED)
	ok = 1;
	if (WIFSIGNALED(status)) {
		dcc_error_msg("dbclean exited with signal %d",
			      WTERMSIG(status));
		ok = 0;
	} else if (WIFEXITED(status)) {
		status = WEXITSTATUS(status);
		if (status != EX_OK) {
			if (status > 100 && status < 130)
				dcc_error_msg("dbclean stopped after signal %d",
					      status-100);
			else
				dcc_error_msg("dbclean exited with status %d",
					      status);
			ok = 0;
		}
	}
#else
	if (status == EX_OK) {
		ok = 1;
	} else {
		dcc_error_msg("dbclean exited with status %d", status);
		ok = 0;
	}
#endif
	if (ok) {
		dbclean_failed = 0;
		dbclean_limit_secs = DBCLEAN_LIMIT_SECS;
	} else {
		dbclean_failed = db_time.tv_sec;
		dbclean_limit_secs *= 2;
		if (dbclean_limit_secs > DEL_DBCLEAN_SECS)
			dbclean_limit_secs = DEL_DBCLEAN_SECS;
	}

	/* don't restart dbclean until after it has stopped running
	 * and cooled for a while */
	dbclean_limit = db_time.tv_sec + dbclean_limit_secs;
}



/* try to repair the database */
static void
run_dbclean(const char *mode,		/* combination of '', R, S, and W */
	    const char *reason)
{
	int i;

	check_dbclean(0);		/* wait until previous ends */

	wfix_later(WFIX_RECHECK_SECS);

	i = snprintf(&dbclean_flags[dbclean_flags_len],
		     ISZ(dbclean_flags)-dbclean_flags_len, "%s%s%s",
		     ssd_mode ? "u" : "",
		     (use_ipv46 == DCC_GETH_V4) ? "4"
		     : (use_ipv46 == DCC_GETH_V6) ? "6"
		     : "",
		     mode);
	if (i+dbclean_flags_len >= ISZ(dbclean_flags))
		dcc_logbad(EX_SOFTWARE, "too many flags for dbclean");

	dbclean_pid = fork();
	if (dbclean_pid < 0) {
		dcc_error_msg("dbclean fork(): %s", ERROR_STR());
	} else if (dbclean_pid == 0) {
		dcc_trace_msg("%s; starting `%s %s%s`",
			      reason, dbclean, dbclean_flags, dbclean_args_str);
		after_fork();
		execv(dbclean, (char **)dbclean_argv);
		dcc_error_msg("execv(%s %s%s): %s",
			      dbclean, dbclean_flags, dbclean_args_str,
			      ERROR_STR());
		exit(-1);
	}

	need_del_dbclean = 0;
	dbclean_limit = db_time.tv_sec + dbclean_limit_secs;
}



static void
close_srvr_socs(void)
{
	SRVR_SOC *sp;

	for (sp = srvr_socs; sp; sp = sp->fwd) {
		if (sp->udp >= 0) {
			close(sp->udp);
			sp->udp = -1;
		}
		iflod_listen_close(sp);
	}
}



/* close files and otherwise clean up after being forked as a helper */
void
after_fork(void)
{
	IFLOD_INFO *ifp;
	OFLOD_INFO *ofp;

	resolve_hosts_pid = -1;
	dbclean_pid = -1;

	db_close(DB_CLOSE_FORK);

	close_srvr_socs();
	for (ifp = iflods.infos; ifp <= LAST(iflods.infos); ++ifp) {
		if (ifp->soc >= 0)
			close(ifp->soc);
	}
	for (ofp = oflods.infos; ofp <= LAST(oflods.infos); ++ofp) {
		if (ofp->soc >= 0)
			close(ofp->soc);
	}

	signal(SIGHUP, SIG_DFL);
	signal(SIGTERM, SIG_DFL);
	signal(SIGINT, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
#ifdef SIGXFSZ
	signal(SIGXFSZ, SIG_DFL);
#endif
}



/* do not worry about cleaning to fix a window overflow for a while */
static void
wfix_later(time_t delay)
{
	dbclean_wfix_state = WFIX_DELAY;
	dbclean_wfix_secs = db_time.tv_sec + delay;
	dbclean_wfix_range = delay;
}



/* measure load to see if the clients flee */
static double				/* <0.0 if not enough time to say */
wfix_measure(u_char force)
{
	double secs;

	secs = db_time.tv_sec - wfix_check_start;
	if (force || secs <= 0.0 || secs > WFIX_MEASURE_SECS*2
	    || total_ops < wfix_ops) {
		wfix_check_start = db_time.tv_sec;
		dbclean_wfix_secs = db_time.tv_sec + WFIX_MEASURE_SECS;
		dbclean_wfix_range = WFIX_MEASURE_SECS;
		wfix_ops = total_ops;
		return -1.0;
	}
	return (total_ops - wfix_ops) / secs;
}



static u_char
wfix_ck_timer(time_t secs)
{
	if (secs == 0)
		return 1;

	if (db_time.tv_sec >= secs - WFIX_PRE_CLEAN_SECS) {
		dbclean_wfix_secs = secs + WFIX_POST_CLEAN_SECS;
		dbclean_wfix_range = (WFIX_POST_CLEAN_SECS
				      + secs - db_time.tv_sec);
		if (!DB_IS_TIME(dbclean_wfix_secs, dbclean_wfix_range))
			return 0;
	}

	return 1;
}



static u_char				/* 1=need dbclean now */
wfix(char *reason, u_int reason_len)
{
	double rate;
	time_t sn_secs;
	DB_PTR cur_size, tgt_size;
	char cause[100];
	int cause_len;

	/* stop everything if dbclean is running */
	if (dbclean_running || wfix_quiet_rate <= 0.0) {
		wfix_later(WFIX_RECHECK_SECS);
		return 0;
	}

	switch (dbclean_wfix_state) {
	case WFIX_DELAY:		/* just checking */
		if (!DB_IS_TIME(dbclean_wfix_secs, dbclean_wfix_range))
			return 0;

		/* no quick cleaning soon after the database was created,
		 * cleaned or repaired */
		sn_secs = ts2secs(&db_parms.sn);
		if (sn_secs > db_time.tv_sec)
			sn_secs = 0;
		if (sn_secs < dbclean_failed
		    && dbclean_failed <= db_time.tv_sec)
			sn_secs = dbclean_failed;
		if (!wfix_ck_timer(sn_secs))
			return 0;

		/* Check later if dbclean might run soon.
		 * Dbclean should run 1 day after cron last ran it or when
		 * the failsafe timer expires. */
		if (!wfix_ck_timer(next_failsafe_clean_secs))
			return 0;
		if (!wfix_ck_timer(last_cron_clean + 24*60*60))
			return 0;

		/* check later if the database does not have bad duplicate
		 * chains and is not too large */
		if (iflod_dup_chain == 0
		    && (db_fsize + db_hash_fsize
			< (wfix_size_set ? wfix_size : db_max_byte))) {
			wfix_later(WFIX_RECHECK_SECS);
			break;
		}
		/* the database is too big, so try to chase the clients
		 * to the other DCC server (if any) */
		dbclean_wfix_state = WFIX_BUSY;
		wfix_measure(1);
		break;

	case WFIX_BUSY:
		rate = wfix_measure(0);
		if (rate >= 0.0) {
			wfix_busy_rate = rate;
			dbclean_wfix_state = WFIX_QUIET;
			dbclean_wfix_secs = db_time.tv_sec + WFIX_QUIET_SECS;
			dbclean_wfix_range = WFIX_QUIET_SECS;
		}
		break;

	case WFIX_QUIET:		/* waiting for clients to flee */
		dbclean_wfix_state = WFIX_CHECK;
		wfix_measure(1);
		break;

	case WFIX_CHECK:		/* counting clients */
		rate = wfix_measure(0);
		if (rate < 0.0)
			break;
		cur_size = db_fsize + db_hash_fsize;
		tgt_size = wfix_size_set ? wfix_size : db_max_byte;
		cause_len = 0;
		cause[0] = '\0';
		if (iflod_dup_chain != 0)
			cause_len = snprintf(cause, sizeof(cause),
					     "flooding duplicate chain of %d",
					     iflod_dup_chain);
		if (cause_len == 0
		    || (cause_len < ISZ(cause)-1
			&& cur_size > tgt_size))
			cause_len += snprintf(&cause[cause_len],
					      sizeof(cause) - cause_len,
					      "%sdatabase size "L_DPAT">"L_DPAT,
					      cause_len ? " and " : "",
					      cur_size, tgt_size);
		if (rate <= wfix_quiet_rate
		    || rate <= wfix_busy_rate * wfix_rate_change) {
			snprintf(reason, reason_len,
				 "%s; load changed from %0.1f to %0.1f",
				 cause, wfix_busy_rate, rate);
			return 1;
		}
		/* Other DCC servers did not take over the load. Maybe later */
		if (db_debug)
			dcc_trace_msg("%s but load changed from %0.1f to %0.1f",
				      cause, wfix_busy_rate, rate);
		wfix_later(WFIX_RECHECK_SECS);
		break;
	}

	return 0;
}



/* check for changes or other interesting events when the flood timer expires */
static time_t				/* microseconds to wait */
check_changes(void)
{
	static time_t misc_timer, files_timer;
	time_t secs;
	const char *mode;
	const char *reason;
	char reason_buf[100];

	reason = 0;
	mode = 0;

	if (db_failed_line) {
		snprintf(reason_buf, sizeof(reason_buf),
			 "database broken at line %d in %s "DCC_VERSION,
			 db_failed_line, db_failed_file);
		reason = reason_buf;
		mode = "Rbad";
	}

	if (!reason) {
		DB_HADDR hash_free;

		hash_free = db_hash_len - db_hash_used;
		if (hash_free < MIN_FREE_HASH_ENTRIES
		    || hash_free < db_hash_len/20) {
			/* try to expand the hash table when there are few
			 * free slots or the load factor rises above .95 */
			if (hash_free < MIN_HASH_ENTRIES)
				snprintf(reason_buf, sizeof(reason_buf),
					 "%d free hash entries",
					 hash_free);
			else
				snprintf(reason_buf, sizeof(reason_buf),
					 "%d free hash entries among %d total",
					 hash_free, db_hash_len);
			reason = reason_buf;
			mode = "Rhash";
		}
	}

	/* check nothing else if it is not yet time */
	if (!reason) {
		secs = next_flods_ck - db_time.tv_sec;
		if (secs > 0 && secs <= flods_ck_secs)
			return secs * DCC_US;
	}

	next_flods_ck = db_time.tv_sec + flods_ck_secs;

	/* do not make some checks too often even when flood checking is
	 * being rushed */
	if (DB_IS_TIME(misc_timer, MISC_CK_SECS)) {
		misc_timer = db_time.tv_sec + MISC_CK_SECS;

		/* Shrink our memory footprint and send changes to the disk
		 * if we are so idle that we have nothing to flush,
		 * unless dbclean is running
		 * we are avoiding writing to an SSD disk.  */
		if (DB_IS_LOCKED() && db_need_flush_secs == 0
		    && !dbclean_running && !ssd_mode)
			db_unload(0, DB_UNLOAD_ONE);

		if (DB_IS_TIME(files_timer, 30)) {
			files_timer = db_time.tv_sec + 30;

			if (0 >= check_load_ids(0))
				dcc_error_msg("check/reload: %s", dcc_emsg.c);

			check_blacklist_file();

#if defined(HAVE_GETIFADDRS) && defined(HAVE_FREEIFADDRS)
			/* check again for network interface changes, but only
			 * if we can release the result of getifaddrs() */
			if (get_if_changes(1)) {
				int socs = open_srvr_socs(0);
				if (!socs)
					bad_stop("no server sockets");
				else if (socs > 0)
					flods_restart("new network interfaces",
						      1);
			}
#endif
		}

		if (DB_IS_TIME(need_clients_save, CLIENTS_SAVE_SECS))
			clients_save();

		/* add server-ID and kludge records */
		if (DB_IS_TIME(host_id_next, host_id_range)
		    && DB_IS_LOCKED()
		    && !db_failed_line) {
			DCC_SUM ck;
			time_t datestamp;

			host_id_next = 0;   /* need a new timer */

			/* broadcast a claim to our server-ID */
			datestamp = db_time.tv_sec;
			datestamp -= datestamp % SRVR_ID_REP_SECS;
			refresh_srvr_rcd(&host_id_sum, my_srvr_id,
					 datestamp,
					 datestamp + SRVR_ID_REP_SECS,
					 "adding server-ID claim");

			/* Install keepalive or date records.
			 * They are sent to ensure that there is always
			 * a position to acknowledge even with a server-ID
			 * mapping that stops all reports.
			 * They are also used to limit checks for duplicate
			 * incoming flooded records.  For that purpose, it
			 * is more important that they be present than
			 * that they be accurate.  They must be present
			 * before any locally added record with a timestamp
			 * after their key (checksum) value. */
			datestamp = db_time.tv_sec + DATE_RCD_REP_SECS;
			datestamp -= datestamp % DATE_RCD_REP_SECS;
			date_rcd_ck(&ck, datestamp);
			refresh_srvr_rcd(&ck, DCC_ID_SRVR_DATE,
					 datestamp - DATE_RCD_REP_SECS-1,
					 datestamp,
					 "adding timestamp");
		}
	}

	/* collect zombies */
	flod_names_resolve_ck();
	check_dbclean(WNOHANG);

	if (!reason
	    && DB_IS_TIME(next_failsafe_clean_secs,
			  next_failsafe_clean_delay)) {
		reason = "work around broken cron job";
		mode = "Rfailsafe";
	}

	if (!reason
	    && DB_IS_TIME(next_failsafe_clean_secs,
			  next_failsafe_clean_delay)
	    && (!dbclean_running
		|| DB_IS_TIME(dbclean_limit+4*60*60,
			      4*60*60+dbclean_limit_secs))) {
		/* try to failsafe clean even if dbclean seems to be running
		 * if it seems to have running more than 4 hours */
		reason = "work around broken cron job and stuck dbclean";
		mode = "Rfailsafe";
	}

	if (!reason
	    && need_del_dbclean != 0
	    && DB_IS_TIME(del_dbclean_next, DEL_DBCLEAN_SECS)) {
		/* the deletion of a report needs to be cleaned up */
		reason = need_del_dbclean;
		mode = "Rdel";
	}

	if (!reason
	    && DB_IS_TIME(dbclean_wfix_secs, dbclean_wfix_range)
	    && wfix(reason_buf, sizeof(reason_buf))) {
		reason = reason_buf;
		mode = "Rquick";
	}

	if (reason) {
		if (!DB_IS_TIME(dbclean_limit, dbclean_limit_secs)) {
			if (next_flods_ck > dbclean_limit)
				next_flods_ck = dbclean_limit;
		} else if (dbclean_pid < 0 && !stopint) {
			run_dbclean(mode, reason);
		} else {
			RUSH_NEXT_FLODS_CK();
		}
	} else {
		flods_ck(0);
	}

	/* we probably delayed */
	gettimeofday(&db_time, 0);

	secs = next_flods_ck - db_time.tv_sec;
	return secs >= 0 ? secs*DCC_US : 0;
}



static void DCC_NORET
recv_job(void)
{
	fd_set rfds, *prfds, wfds, *pwfds;
#	define PFD_SET(_fd0,_fds) {int _fd = _fd0;	    \
		p##_fds = &_fds; FD_SET(_fd,p##_fds);	    \
		if (max_fd < _fd) max_fd = _fd;}
	int max_fd, nfds;
	IFLOD_INFO *ifp;
	OFLOD_INFO *ofp;
	struct timeval delay;
	time_t delay_us, slept_us, was_too_busy, us;
	struct timeval iflods_read, busy_time, extra_time;
	u_char db_has_failed;
#	define QUANTUM (DCC_US/10)	/* try to use only ~50% of the system */
	SRVR_SOC *sp;
	QUEUE *q;
	int bad_select;
	u_char worked;
	int fd, i;

	bad_select = 3;
	was_too_busy = 0;
	gettimeofday(&db_time, 0);
	iflods_read = db_time;
	busy_time = db_time;
	extra_time = db_time;
	delay_us = flods_ck_secs*DCC_US;
	db_has_failed = 0;
	for (;;) {
		dcc_emsg.c[0] = '\0';

		if (stopint)
			dccd_quit();

		if (db_has_failed != db_failed_line) {
			db_has_failed = db_failed_line;
			if (db_failed_line) {
				++flods_off;
				flods_stop("database corrupt", 1);
			}
		}

		FD_ZERO(&rfds);
		prfds = 0;
		FD_ZERO(&wfds);
		pwfds = 0;
		max_fd = -1;

		/* look for client requests */
		for (sp = srvr_socs; sp; sp = sp->fwd) {
			if (sp->udp >= 0)
				PFD_SET(sp->udp, rfds);
		}

		if (was_too_busy > 0)
			was_too_busy = QUANTUM - tv_diff2us(&db_time,
							&busy_time);
		if (was_too_busy > 0
		    && (tv_diff2us(&db_time, &extra_time)
			< min(30, min(KEEPALIVE_IN, KEEPALIVE_OUT)/2))
		    && FLODS_OK()) {
			/* if we have been too busy,
			 * then do nothing extra for a while */
			if (delay_us > was_too_busy)
				delay_us = was_too_busy;
		} else {
			extra_time = db_time;

			/* Accept new incoming flood connections
			 * if flooding is on
			 * and we don't already have too many floods. */
			if (iflods.open < DCCD_MAX_FLOODS) {
				for (sp = srvr_socs; sp; sp = sp->fwd) {
					if (sp->listen >= 0)
					    PFD_SET(sp->listen, rfds);
				}
			}

			/* pump floods out */
			for (ofp = oflods.infos, i = 0;
			     i < oflods.open;
			     ++ofp) {
				if (ofp->soc < 0)
					continue;
				++i;
				if (ofp->flags & OFLOD_FG_CONNECTED) {
					PFD_SET(ofp->soc, rfds);
					if (!(ofp->flags & OFLOD_FG_EAGAIN)
					    && ofp->obuf_len != 0)
					    PFD_SET(ofp->soc, wfds);
				} else {
					PFD_SET(ofp->soc, wfds);
				}
			}

			/* pump floods in */
			for (ifp = iflods.infos, i = 0;
			     i < iflods.open;
			     ++ifp) {
				if (ifp->soc < 0)
					continue;
				++i;
				if (ifp->flags & IFLOD_FG_CONNECTED) {
					PFD_SET(ifp->soc, rfds);
				} else {
					PFD_SET(ifp->soc, wfds);
				}
			}
		}

		/* push data to the disk */
		if (db_need_flush_secs != 0) {
			if (DB_IS_TIME(db_need_flush_secs, DB_NEED_FLUSH_SECS))
				dccd_flush(TMSG_BIT(DB));
			if (db_need_flush_secs != 0) {
				us = db_need_flush_secs - db_time.tv_sec;
				if (us >= 0) {
					us *= DCC_US;
					if (delay_us > us)
					    delay_us = us;
				}
			}
		}

		/* let dbclean run if we have run out of work
		 * or if we have been holding the lock for 0.1 seconds */
		if (dbclean_running
		    && DB_IS_LOCKED()
		    && (delay_us != 0
			|| tv_diff2us(&db_time, &db_locked) >= DCC_US/10)) {
			db_unload(0, DB_UNLOAD_ENOUGH);
			db_unlock();
		}

		/* delay until it is time to answer the oldest anonymous
		 * request or something else that needs doing */
		delay.tv_sec = delay_us/DCC_US;
		delay.tv_usec = delay_us%DCC_US;
		nfds = select(max_fd+1, prfds, pwfds, 0, &delay);
		if (nfds < 0) {
			if (errno != EINTR) {
				if (--bad_select < 0)
					bad_stop("give up after select(): %s",
						 ERROR_STR());
				else
					dcc_error_msg("select(): %s",
						      ERROR_STR());
			}
			/* ignore EINTR but recompute timers */
			FD_ZERO(&rfds);
			FD_ZERO(&wfds);
		} else {
			bad_select = 3;
		}

		gettimeofday(&wake_time, 0);
		slept_us = tv_diff2us(&wake_time, &db_time);
		if (slept_us >= 500) {
			/* If select() paused for at least 0.5 millisecond,
			 * then the waiting request has just now arrived. */
			req_recv_time = wake_time;
		} else {
			/* If select() did not pause, then assume the waiting
			 * requests arrived when we were half finished working
			 * on flooding and other work besides ordinary requests
			 * before calling select(). */
			tv_add_us(&req_recv_time,
				  tv_diff2us(&wake_time, &req_recv_time) / 2);
		}
		db_time = wake_time;

		worked = 0;
		for (sp = srvr_socs; sp; sp = sp->fwd) {
			/* queue a new anonymous request
			 * or answer a new authenticated request */
			fd = sp->udp;
			if (fd >= 0 && FD_ISSET(fd, &rfds)) {
				--nfds;
				worked = 1;
				while (new_job(sp))
					continue;
			}

			/* start a new incoming flood */
			fd = sp->listen;
			if (fd >= 0 && FD_ISSET(fd, &rfds)) {
				--nfds;
				worked = 1;
				iflod_start(sp);
			}
		}
		if (worked)
			gettimeofday(&db_time, 0);
		/* reset request receipt clock for next time */
		req_recv_time = db_time;

		/* Accept new flood data or start new SOCKS floods.
		 * Listen to all peers to prevent starvation */
		worked = 0;
		for (ifp = iflods.infos, i = 0;
		     nfds > 0 && i < iflods.open;
		     ++ifp) {
			if (ifp->soc < 0)
				continue;
			++i;
			if (FD_ISSET(ifp->soc, &rfds)
			    || FD_ISSET(ifp->soc, &wfds)) {
				--nfds;
				iflod_read(ifp);
				worked = 1;
			}
		}
		if (worked) {
			gettimeofday(&db_time, 0);
			iflods_read = db_time;
		} else if (was_too_busy <= 0) {
			/* if incoming floods have been quiet for
			 * awhile, then assume flooding has caught up
			 * after having been turned off */
			if (tv_diff2us(&wake_time, &iflods_read) > 2*DCC_US)
				iflods_ok_timer = db_time.tv_sec;
		}

		/* pump output flood data and receive confirmations
		 * talk to all peers to prevent starvation */
		worked = 0;
		for (ofp = oflods.infos, i = 0;
		     nfds > 0 && i < oflods.open;
		     ++ofp) {
			if (ofp->soc < 0)
				continue;
			++i;
			if (FD_ISSET(ofp->soc, &rfds)) {
				--nfds;
				oflod_read(ofp);
				if (ofp->soc < 0)
					continue;
			}
			if (FD_ISSET(ofp->soc, &wfds)) {
				--nfds;
				oflod_write(ofp);
				worked = 1;
			}
		}
		if (worked)
			gettimeofday(&db_time, 0);

		/* process delayed jobs when their times arrive */
		worked = 0;
		for (;;) {
			q = queue_head;
			if (!q) {
				delay_us = flods_ck_secs*DCC_US;
				break;
			}

			/* decide whether this job's time has come
			 * while defending against time jumps */
			delay_us = tv_diff2us(&q->answer, &db_time);
			if (delay_us >= 1000
			    && delay_us <= DCC_MAX_RTT
			    && !stopint)
				break;  /* not yet time for next job */

			queue_head = q->later;
			if (queue_head)
				queue_head->earlier = 0;
			--queue_cur;
			do_work(q);
			worked = 1;
			free_q(q);
		}
		if (worked)
			gettimeofday(&db_time, 0);

		/* check configuration changes etc. */
		us = check_changes();
		if (delay_us >= us)
			delay_us = us;

		us = tv_diff2us(&db_time, &wake_time);
		if (us >= QUANTUM && !stopint) {
			gettimeofday(&db_time, 0);
			busy_time = db_time;
			was_too_busy = QUANTUM;
		}
	}
}



static void
add_queue(QUEUE *q, DCC_CLNT_ID id)
{
	QUEUE *qnext, **qp;

	if (!ck_clnt_id(q, id, anon_off)) {
		TMSG_OP(QUERY, q);
		free_q(q);
		return;
	}
	TMSG_OP(QUERY, q);

	++total_ops;

	/* immediately process requests from authenticated clients
	 * if flooding is working */
	if (q->delay_us == 0) {
		do_work(q);
		free_q(q);
		return;
	}

	/* don't let the queue of delayed requests get too large */
	if (queue_cur >= queue_max) {
		clnt_msg(q, "after %d, drop queued %s", queue_cur, op_id_ip(q));
		free_q(q);
		return;
	}

	tv_add_us(&q->answer, q->delay_us);

	/* add the new job to the queue */
	++queue_cur;
	qp = &queue_head;
	for (;;) {
		qnext = *qp;
		if (!qnext) {
			*qp = q;
			break;
		}
		if (qnext->answer.tv_sec > q->answer.tv_sec
		    || (qnext->answer.tv_sec == q->answer.tv_sec
			&& qnext->answer.tv_usec > q->answer.tv_usec)) {
			q->later = qnext;
			qnext->earlier = q;
			*qp = q;
			break;
		}
		q->earlier = qnext;
		qp = &qnext->later;
	}
}



/* get a new job in a datagram */
static u_char				/* 1=call again */
new_job(SRVR_SOC *sp)
{
	QUEUE *q;
	static struct iovec iov = {0, sizeof(q->pkt)};
	static struct msghdr msg;
	char ob[DCC_OPBUF];
	DCC_CLNT_ID id;
	int recvlen, i, j;

	/* Find a free queue entry for the job.
	 * Because we don't check for incoming jobs unless we think the
	 * queue is not full, there must always be a free entry or
	 * permission to make more entries. */
	q = queue_free;
	if (q) {
		queue_free = q->later;
	} else {
		i = 16;
		q = dcc_malloc(i * sizeof(*q));
		if (!q)
			dcc_logbad(EX_UNAVAILABLE,
				   "malloc(%d queue entries) failed", i);
		/* put all but the last new queue entry on the free list */
		while (--i > 0) {
			q->later = queue_free;
			queue_free = q;
			++q;
		}
	}

	memset(q, 0, sizeof(*q)-sizeof(q->pkt)+sizeof(q->pkt.hdr));
	q->pkt.hdr.sender = DCC_ID_ANON;    /* for truncated packets */
	q->sp = sp;
	iov.iov_base = &q->pkt;
	msg.msg_name = &q->clnt_su;
	msg.msg_namelen = sizeof(q->clnt_su);
	msg.msg_iov = &iov;
	msg.msg_iovlen = 1;
	recvlen = recvmsg(sp->udp, &msg, 0);
	if (recvlen < 0) {
		/* ignore some results of ICMP unreachables for UDP
		 * retransmissions seen on some platforms */
		if (DCC_BLOCK_ERROR()) {
			;
		} else if (UNREACHABLE_ERRORS()) {
			TMSG2(QUERY, "recvmsg(%s): %s",
			      dcc_su2str_err(&sp->udp_su), ERROR_STR());
		} else {
			dcc_error_msg("recvmsg(%s): %s",
				      dcc_su2str_err(&sp->udp_su), ERROR_STR());
		}
		free_q(q);
		return 0;
	}
	if (q->clnt_su.sa.sa_family != sp->udp_su.sa.sa_family
	    && !dcc_ipv4su2ipv6su(&q->clnt_su, &q->clnt_su)) {
		dcc_error_msg("recvmsg address family %d instead of %d",
			      q->clnt_su.sa.sa_family,
			      sp->udp_su.sa.sa_family);
		free_q(q);
		return 1;
	}

	q->pkt_len = recvlen;
	if (DCC_SU_PORT(&q->clnt_su) == 0) {
		junk_msg(q, 1, "source port 0");
		free_q(q);
		return 1;
	}

	if (recvlen < ISZ(DCC_HDR)) {
		junk_msg(q, 0, "short request of %d bytes", recvlen);
		free_q(q);
		return 1;
	}
	j = ntohs(q->pkt.hdr.len);
	if (j != recvlen) {
		junk_msg(q, 0, "request with header length %d instead of %d",
			 j, recvlen);
		free_q(q);
		return 1;
	}

	if (q->pkt.hdr.pkt_vers > DCC_PKT_VERS_NOP_MAX
	    || q->pkt.hdr.pkt_vers < DCC_PKT_VERS_NOP_MIN
	    || (q->pkt.hdr.op != DCC_OP_NOP
		&& (q->pkt.hdr.pkt_vers > DCC_PKT_VERS_MAX
		    || q->pkt.hdr.pkt_vers < DCC_PKT_VERS_MIN))) {
		junk_msg(q, 1, "%s in unrecognized protocol version #%d",
			 qop2str(q), q->pkt.hdr.pkt_vers);
		free_q(q);
		return 1;
	}

	id = ntohl(q->pkt.hdr.sender);
	if (id != DCC_ID_ANON
	    && (id < DCC_SRVR_ID_MIN || id > DCC_CLNT_ID_MAX)) {
		junk_msg(q, 1, "invalid ID %d for %s", id, qop2str(q));
		free_q(q);
		return 1;
	}

	q->answer = req_recv_time;

	switch ((DCC_OPS)q->pkt.hdr.op) {
	case DCC_OP_NOP:
		do_nop(q, id);
		free_q(q);
		return 1;

	case DCC_OP_REPORT:
		if (db_parms.flags & DB_PARM_FG_GREY)
			break;		/* not valid for greylist servers */
		add_queue(q, id);
		return 1;

	case DCC_OP_QUERY:
		add_queue(q, id);
		return 1;

	case DCC_OP_ADMN:
		do_admn(q, id);
		free_q(q);
		return 1;

	case DCC_OP_DELETE:
		do_delete(q, id);
		free_q(q);
		return 1;

	case DCC_OP_GREY_REPORT:
	case DCC_OP_GREY_QUERY:
	case DCC_OP_GREY_WHITE:
		if (!(db_parms.flags & DB_PARM_FG_GREY))
			break;		/* valid only for greylist servers */
		do_grey(q, id);
		free_q(q);
		return 1;

	case DCC_OP_GREY_SPAM:
		if (!(db_parms.flags & DB_PARM_FG_GREY))
			break;		/* valid only for greylist servers */
		do_grey_spam(q, id);
		free_q(q);
		return 1;

	case DCC_OP_INVALID:
	case DCC_OP_ANSWER:
	case DCC_OP_OK:
	case DCC_OP_ERROR:
		break;
	}

	junk_msg(q, 1, "invalid %s, ID %d",
		 dcc_hdr_op2str(ob, sizeof(ob), &q->pkt.hdr),
		 (DCC_CLNT_ID)ntohl(q->pkt.hdr.sender));
	free_q(q);
	return 1;
}



void
free_q(QUEUE *q)
{
	if (q->ip_rl)
		--q->ip_rl->ref_cnt;
	if (q->block_rl)
		--q->block_rl->ref_cnt;
	q->later = queue_free;
	queue_free = q;
}



u_char
dccd_db_open(u_char lock_mode)
{
	DCC_CK_TYPES type;
	time_t tgt_sec;
	DCC_TGTS tgts;
	int i;

	if (!db_open(&dcc_emsg, -1, 0, 0, 0, lock_mode | db_mode))
		return 0;

	gettimeofday(&db_time, 0);

	if (grey_on) {
		/* for greylisting, ignore the args an silently impose our
		 * notion of which checksums to keep and flooding thresholds */
		db_parms.nokeep_cks = def_nokeep_cks();
		if (grey_weak_ip)
			DB_RESET_NOKEEP(db_parms.nokeep_cks, DCC_CK_IP);

		for (type = DCC_CK_TYPE_FIRST;
		     type <= DCC_CK_TYPE_LAST;
		     ++type) {
			if (type == DCC_CK_SRVR_ID) {
				flod_tholds[type] = 1;
				continue;
			}

			if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type))
				flod_tholds[type] = DCC_TGTS_INVALID;
			else
				flod_tholds[type] = 1;

			if (DCC_CK_IS_GREY_TRIPLE(grey_on,type)
			    || type == DCC_CK_IP) {
				db_parms.ex_secs[type].all = grey_window;
				db_parms.ex_secs[type].spam = grey_white;
			} else if (type == DCC_CK_BODY
				   || DCC_CK_IS_GREY_MSG(grey_on,type)) {
				db_parms.ex_secs[type].all = grey_window;
				db_parms.ex_secs[type].spam = grey_window;
			} else {
				db_parms.ex_secs[type].all = 1;
				db_parms.ex_secs[type].spam = 1;
			}
		}

		summarize_delay_secs = grey_embargo - FLODS_CK_SECS*2;
		if (summarize_delay_secs < 1)
			summarize_delay_secs = 1;

	} else {
		/* impose our notion of which normal checksums to keep */
		DB_SET_NOKEEP(set_new_nokeep_cks, DCC_CK_FLOD_PATH);
		DB_SET_NOKEEP(set_new_nokeep_cks, DCC_CK_INVALID);
		db_parms.nokeep_cks = ((def_nokeep_cks()
					& ~reset_new_nokeep_cks)
				       | set_new_nokeep_cks);

		for (type = DCC_CK_TYPE_FIRST;
		     type <= DCC_CK_TYPE_LAST;
		     ++type) {
			if (type == DCC_CK_SRVR_ID) {
				flod_tholds[type] = 1;
				continue;
			}

			if (type == DCC_CK_REP_TOTAL)
				tgts = DCC_TGTS_INVALID;
			if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type))
				tgts = DCC_TGTS_INVALID;
			else if (DCC_CK_IS_REP(0, type))
				tgts = DCC_TGTS_INVALID;
			else
				tgts = BULK_THRESHOLD;
			flod_tholds[type] = tgts;
		}

		/* We should not delay reports or summaries so much that
		 * dbclean might expire them before we can summarize them. */
		summarize_delay_secs = min(DCC_OLD_SPAM_SECS, 4*60*60);
		for (type = DCC_CK_TYPE_FIRST;
		     type <= DCC_CK_TYPE_LAST;
		     ++type) {
			if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type))
				continue;
			i = db_parms.ex_secs[type].spam;
			if (i != 0 && summarize_delay_secs > i)
				summarize_delay_secs = i;
		}
		if (summarize_delay_secs < DB_EXPIRE_SECS_DEF_MIN)
			summarize_delay_secs = DB_EXPIRE_SECS_DEF_MIN;
	}
	summarize_limit = DB_PTR_NULL;
	summarize_limit_secs = 0;

	/* adjust the thresholds after possible changes to kept checksums */
	set_db_tholds(db_parms.nokeep_cks);

	last_cron_clean = db_parms.cleaned_cron;
	if (last_cron_clean > db_time.tv_sec)
		last_cron_clean = 0;

	/* If we instead of cron asked for the last cleaning, make a note
	 * to clean the database during the graveyard shift.
	 * Otherwise the database will bloat while the cron job is broken.
	 *
	 * Compute 1 day + 15 minutes after cron should have last cleaned the
	 *	database, if it has been cleaned by cron within the last 3 days
	 * or when it was last cleaned by this mechanism
	 * or 3 minutes past a random quarter hour between 01:00 and 04:45 */
#   define FS_CLEAN_HOUR_START  1
#   define FS_CLEAN_HOURS	4
#   define FS_CLEAN_HOUR_END	(FS_CLEAN_HOUR_START+FS_CLEAN_HOURS-1)
#   define FS_CLEAN_MIN_START	3
#   define FS_CLEAN_MIN_INTERVAL 15
#   define FS_CLEAN_INTS	((FS_CLEAN_HOURS*60)/FS_CLEAN_MIN_INTERVAL)

	/* Schedule failsafe cleaning 15 minutes after the cron job in case
	 * it runs on some days of the week,
	 * except once every sixth fail safe cleaning. */
	tgt_sec = last_cron_clean;
	if (tgt_sec != 0
	    && db_parms.failsafe_cleanings % 6 != 5) {
		tgt_sec += 15*60;
		/* coordinate greylist and DCC cleaning */
		if (!grey_on)
			tgt_sec += 15*60;

	} else {
		struct tm tm;
		u_int rnum;

		/* pick an arbitrary quarter hour that depends
		 * unpredictably on the host and usually differs
		 * by 1 for the greylist server */
		rnum = db_time.tv_sec / (24*60*60);
		if (ports)		/* this includes greylist difference */
			rnum += ntohs(ports->port);
		for (i = 0; i < ISZ(our_hostname); ++i) {
			if (!our_hostname[i])
				break;
			rnum += our_hostname[i]*i;
		}
		rnum %= FS_CLEAN_INTS;

		dcc_localtime(db_time.tv_sec, &tm);
		tm.tm_hour = (rnum%FS_CLEAN_HOURS
			      + FS_CLEAN_HOUR_START);
		rnum /= FS_CLEAN_HOURS;
		tm.tm_min = (rnum*FS_CLEAN_MIN_INTERVAL
			     + FS_CLEAN_MIN_START);
		tgt_sec = mktime(&tm);
	}

	/* Round down to a minute to prevent creep due to
	 * delays starting dbclean. */
	tgt_sec -= tgt_sec % 60;

	tgt_sec %= (24*60*60);

	/* Start to schedule the failsafe cleaning at the target second
	 * in the next 24 hours */
	next_failsafe_clean_secs = db_time.tv_sec;
	next_failsafe_clean_secs -= (next_failsafe_clean_secs % (24*60*60));
	next_failsafe_clean_secs += tgt_sec;
	if (next_failsafe_clean_secs <= db_time.tv_sec)
		next_failsafe_clean_secs += 24*60*60;
	next_failsafe_clean_delay = next_failsafe_clean_secs - db_time.tv_sec;

	/* The next failsafe cleaning should happen a day after the
	 * most recent failsafe cleaning, so skip today if a new failsafe
	 * time is within 12 hours of the last failsafe cleaning. */
	if (TIME_T(next_failsafe_clean_secs) < (TIME_T(db_parms.cleaned)
						+ 12*60*60)
	    && TIME_T(db_parms.cleaned) <= db_time.tv_sec) {
		next_failsafe_clean_secs += 24*60*60;
		next_failsafe_clean_delay += 24*60*60;
	}

	/* Delay failsafe cleaning at least 36 hours after the last cron job
	 * in case the cron job runs at different times on different days.
	 * Failsafe cleaning should never be running when the cron job starts.
	 * Do not failsafe clean during the first 2 days after the
	 * database was created to give the cron job a chance. */
	while (TIME_T(next_failsafe_clean_secs) < last_cron_clean + 36*60*60
	       || (TIME_T(next_failsafe_clean_secs) <= (TIME_T(db_parms.cleared)
							+ 2*24*60*60)
		   && TIME_T(db_parms.cleared) <= db_time.tv_sec)) {
		next_failsafe_clean_secs += 24*60*60;
		next_failsafe_clean_delay += 24*60*60;
	}

	total_ops = 0;

	iflod_dup_chain = 0;
	complained_missing_date = 1;

	/* push our thresholds and flags to the file */
	return db_flush_parms(0);
}



/* clean shut down */
static void
dccd_quit(void)
{
	static u_char second_time;
	DB_UNLOAD_MODE unload_mode;
	DB_CLOSE_MODE close_mode;
	int exitcode;

	if (stopint < 0) {
		flods_ck_secs = SHUTDOWN_DELAY;
		if (!second_time) {
			second_time = 1;
			flods_off = 100000;
			flods_stop("server stopping", 0);
			check_dbclean(WNOHANG);
			if (dbclean_pid > 0) {
				kill(dbclean_pid, SIGINT);
				dbclean_pid = -1;
				usleep(100*1000);
			}
		}

		/* Start flushing the database
		 * while we wait for flooding to stop. */
		dbclean_running = 1;
		if (stop_mode == 2) {
			unload_mode = DB_UNLOAD_REBOOT_CLEAN;
			if (!second_time)
				dcc_trace_msg("gracefully stopping cleanly");
		} else if (stop_mode == 1) {
			unload_mode = DB_UNLOAD_REBOOT;
			if (!second_time)
				dcc_trace_msg("gracefully stopping for reboot");
		} else {
			unload_mode = DB_UNLOAD_RELEASE;
			if (!second_time)
				dcc_trace_msg("gracefully stopping");
		}
		db_unload(0, unload_mode);

		/* Return to stop flooding. */
		if (oflods.total != 0)
			return;

		/* get serious when the floods have stopped */
		exitcode = 0;
		if (stop_mode == 1) {
			dcc_trace_msg("gracefully stopping for reboot");
			close_mode = DB_CLOSE_REBOOT;
		} else if (stop_mode == 2) {
			dcc_trace_msg("gracefully stopping cleanly");
			close_mode = DB_CLOSE_STABLE;
		} else {
			dcc_trace_msg("gracefully stopping");
			close_mode = DB_CLOSE;
		}

	} else {
		exitcode = stopint | 128;
		if (stopint == SIGTERM) {
			dcc_error_msg("exiting for reboot with signal %d",
				      stopint);
			close_mode = DB_CLOSE_REBOOT;
		} else {
			dcc_error_msg("exiting with signal %d",
				      stopint);
			close_mode = DB_CLOSE;
		}
	}

	/* db_close() can take a long time, so close some things early. */
	stop_children();
	clients_save();

	db_close(close_mode);

	if (exitcode)
		dcc_error_msg("stopped");
	else
		dcc_trace_msg("stopped");
	exit(exitcode);
}



/* watch for fatal signals */
static void
sigterm(int sig)
{
	stopint = sig;
	stop_mode = 1;
	next_flods_ck = 0;
	(void)signal(sig, SIG_DFL);	/* catch it only once */
}



/* SIGHUP hurries checking the configuration files */
static void
sighup(int sig DCC_UNUSED)
{
	next_flods_ck = 0;
	got_hosts = 0;
}



/* emergency shutdown but close the database cleanly */
void
bad_stop(const char *pat, ...)
{
	va_list args;

	if (stopint)
		return;

	va_start(args, pat);
	dcc_verror_msg(pat, args);
	va_end(args);

	stopint = -1;
	next_flods_ck = 0;
}



static void
stop_children(void)
{
	if (resolve_hosts_pid > 0)
		kill(resolve_hosts_pid, SIGKILL);
	flod_names_resolve_ck();

	if (dbclean_pid > 0)
		kill(dbclean_pid, SIGKILL);
	check_dbclean(WNOHANG);
}
