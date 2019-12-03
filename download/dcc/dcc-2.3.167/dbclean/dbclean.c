/* Distributed Clearinghouses Checksum database cleaner
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
 * Rhyolite Software DCC 2.3.167-1.300 $Revision$
 */

#include "srvr_defs.h"
#include "dcc_ck.h"
#include <signal.h>

static DCC_EMSG dcc_emsg;

static WF dbclean_wf;
static WHITE_TBL dbclean_white_tbl;
static DCC_CLNT_CTXT *ctxt;
static DCC_OP_RESP aop_resp;
static int flods_off;
static int dccd_unlocked;		/* dccd has been told to unlock	*/

static DCC_SRVR_NM server_def = DCC_SRVR_NM_DEF(0);
static DCC_SRVR_NM server;

static DCC_CLNT_ID server_id = DCC_ID_INVALID;
#ifdef DCC_USE_DBCLEAN_F
static DB_OPEN_MODES db_mode = DB_OPEN_WRITE | DB_OPEN_DCCD_DEFAULT;
#else
static DB_OPEN_MODES db_mode = DB_OPEN_MSYNC | DB_OPEN_DBCLEAN_DEFAULT;
#endif

static u_char cleardb;			/* 1=clear the database */
static enum {
    NORMAL_MODE,			/* started by cron */
    REPAIR_MODE,			/* server says: bad database */
    QUICK_MODE,				/* server says: too big for window */
    HASH_MODE,				/* server says: hash table full */
    FAILSAFE_MODE,			/* server says: no cron job */
    DEL_MODE				/* server says: record deletion */
} clean_mode = NORMAL_MODE;
static u_char standalone;		/* 1=don't talk to dccd */
static u_char keep_white;		/* 1=do not rebuild whitelist */
static u_char dbclean_ssd_mode;

static const char *homedir;
static const char *db_dir;
static const char *hash_dir;

typedef struct {
	DCC_PATH    link_dir;		/* "" or /tmpfs */
	DCC_PATH    base;		/* /var/dcc/dcc_db */
	DCC_PATH    next;		/* /{var/dcc,tmpfs}/dcc_db */
	DCC_PATH    new;		/* /{var/dcc,tmpfs}/dcc_db-new */
	DCC_PATH    prev;		/* /{var/dcc,tmpfs}/dcc_db */
	DCC_PATH    prev_old;		/* /{var/dcc,tmpfs}/dcc_db-old */
	char	    prev_msg[sizeof(DCC_PATH)+sizeof(" -> ")+sizeof(DCC_PATH)];
} paths_t;
static paths_t db_paths, hash_paths;

static int old_db_fd = -1;

static DB_HADDR prev_db_hash_used;
static DB_PARMS prev_db_parms;
static DB_PARMS new_db_parms;
static DB_PTR old_db_pos, prev_db_csize, new_db_csize;
static DB_PTR new_db_fsize;
static u_int new_db_blksize;
static FLOD_MMAPS new_flod_mmaps;
static u_char adj_delay_pos;
static DB_PTR min_confirm_pos;
static u_char cur_db_created;
static u_char new_db_created;
static int new_db_fd = -1;
static u_char new_hash_created;

static int expire_secs = -1;
static int def_expire_secs = DB_EXPIRE_SECS_DEF;
static int expire_spamsecs = -1;
static int def_expire_spamsecs = DB_EXPIRE_SPAMSECS_DEF;
static int have_expire_parms = 0;
static double def_exp_ratio = 0.0;
static DB_EX_SECS new_ex_secs;
static time_t new_all_secs[DCC_DIM_CKS];
static DB_EX_TS new_all_ts, new_spam_ts;
static DB_EX_TS ancient_ts, stale_ts;

static DB_HADDR new_hash_len;

static int expired_rcds, comp_rcds, obs_rcds, expired_cks;
static int white_cks, kept_cks;

static DCC_TS future_ts;

#define RESTART_DELAY	(60*5)
#define SHORT_DELAY	30

static struct timeval clean_start;

static struct timeval progress_rpt_last;    /* when previous progress report */
static struct timeval progress_rpt_checked; /* when last checked */
static struct timeval progress_rpt_start;   /* start of progress reporting */
#define REPORT_INTERVAL_SECS	    (5*60)
#define REPORT_INTERVAL_FAST_SECS   10
#define	UNLOCK_INTERVAL_USECS	    (DCC_US/2)
static int progress_rpt_cnt;		/* operations until next check */
static int progress_rpt_base;
static u_char progress_rpt_started;	/* 1=have started reporting progress */
static int progress_rpt_percent;

static const u_char zero_rcd[DB_RCD_LEN_MAX] = {0};

static void get_paths(u_char db);
static void write_new_flush(void);
static void write_new_rcd(const void *, int);
static void write_new_hdr(u_char);
static void rename_bail(const char *, const char *);
static u_char expire(DB_PTR);
static u_char copy_db(void);
static u_char catchup(DCC_EMSG *);
static void parse_white(void);
static void build_hash(void);
static u_char persist_aop(DCC_AOPS, u_int32_t, int);
static void dccd_new_db(const char *);
static void finish(void);
static void sigterm(int);


static void
usage(u_char die)
{
	const char str[] = {
		"usage: [-dfFNPSVqu] [-i id]"
		" [-a [server-addr][,server-port]] [-h homedir]\n"
		"   [-H hash-file-dir] [-D db-file-dir] [-G on]"
		" [-R mode] [-s hash-size]\n"
		"   [-e seconds] [-E spamsecs] [-L ltype,facility.level]"};
	static u_char complained;

	/* its important to try to run, so don't give up unless necessary */
	if (die) {
		dcc_logbad(EX_USAGE, complained ? "giving up" : str);
	} else if (!complained) {
		dcc_error_msg("%s\ncontinuing", str);
		complained = 1;
	}
}


int
main(int argc, char **argv)
{
	u_char print_version = 0;
	typedef struct srvr_nm_port {	/* -a hostname,port args */
	    struct srvr_nm_port *fwd;
	    in_port_t	port;
	    char	nm[DCC_MAXDOMAINLEN];
	} SRVR_NM_PORT;
	SRVR_NM_PORT *nms_ports;
	SRVR_NM_PORT *new_nm_port, **old_nm_port;
	struct stat cur_db_sb;
	const char *cp;
	char *p;
	u_long l;
	int i;

	gettimeofday(&db_time, 0);
	clean_start = db_time;

	timeval2ts(&future_ts, &clean_start, 24*60*60);

	dcc_syslog_init(1, argv[0], 0);

	nms_ports = 0;

	/* this must match DBCLEAN_GETOPTS in cron-dccd.in */
	while ((i = getopt(argc, argv,
			   "64dfFNPSVqui:a:h:H:D:G:R:s:e:E:L:")) != -1) {
		switch (i) {
		case '6':
		case '4':
			/* obsolete with *.3.104, but cannot be deleted because
			 * copied old versions of the cron script might copy
			 * -6 or -4 from old dcc_conf files */
			break;

		case 'd':
			if (db_debug++)
				++dcc_clnt_debug;
			break;

		case 'f':
			db_mode &= ~(DB_OPEN_MSYNC | DB_OPEN_WRITE
				     | DB_OPEN_DBCLEAN_DEFAULT);
			db_mode |= DB_OPEN_MSYNC;
			break;

		case 'F':
			db_mode &= ~(DB_OPEN_MSYNC | DB_OPEN_WRITE
				     | DB_OPEN_DBCLEAN_DEFAULT);
			db_mode |= DB_OPEN_WRITE;
			break;

		case 'N':		/* make a new, clear database */
			cleardb = 1;
			standalone = 1;
			break;

		case 'P':
			if (have_expire_parms > 0)
				dcc_logbad(EX_USAGE,
					   "do not use -P with -e or -E");
			have_expire_parms = -1;
			break;

		case 'S':
			standalone = 1;
			break;

		case 'V':
			dcc_version_print();
			print_version = 1;
			break;

		case 'q':
			trace_quiet = 1;
			break;

		case 'u':
			dbclean_ssd_mode = 1;
			break;

		case 'i':
			l = strtoul(optarg, &p, 10);
			if (*p != '\0'
			    || !DCC_ID_SRVR_NORMAL(l)) {
			    dcc_error_msg("invalid DCC ID \"-i %s\"", optarg);
			} else {
			    server_id = l;
			}
			break;

		case 'a':
			new_nm_port = malloc(sizeof(*new_nm_port));
			memset(new_nm_port, 0, sizeof(*new_nm_port));
			cp = dcc_parse_nm_port(&dcc_emsg, optarg, 0,
					       new_nm_port->nm,
					       sizeof(new_nm_port->nm),
					       &new_nm_port->port,
					       0, 0, 0, 0);
			if (!cp) {
				dcc_error_msg("%s", dcc_emsg.c);
				free(new_nm_port);
				break;
			}
			cp += strspn(cp, DCC_WHITESPACE);
			if (*cp != '\0') {
				dcc_error_msg("unrecognized port number in"
					      "\"-a %s\"", optarg);
				free(new_nm_port);
			} else {
				old_nm_port = &nms_ports;
				while (*old_nm_port) {
					old_nm_port = &(*old_nm_port)->fwd;
				}
				*old_nm_port = new_nm_port;
			}
			break;

		case 'h':
			homedir = optarg;
			break;

		case 'H':
#ifndef DCC_FSTATFS_COMPAT
			dcc_error_msg("dbclean -H usually needs a"
				      " compatible fstatfs()");
#endif
			hash_dir = optarg;
			break;

		case 'D':
#ifndef DCC_FSTATFS_COMPAT
			dcc_error_msg("dbclean -D usually needs a"
				      " compatible fstatfs()");
#endif
			db_dir = optarg;
			break;

		case 'G':
			dcc_syslog_init(1, argv[0], " grey");
			if (have_expire_parms > 0)
				dcc_logbad(EX_USAGE,
					   "do not use -G with -e or -E");
			if (strcasecmp(optarg, "on"))
				usage(0);   /* be generous and allow -Gxxx */
			grey_on = 1;
			have_expire_parms = -1;
			break;

		case 'R':
			if (!strcasecmp(optarg, "bad"))
				clean_mode = REPAIR_MODE;
			else if (!strcasecmp(optarg, "quick"))
				clean_mode = QUICK_MODE;
			else if (!strcasecmp(optarg, "hash"))
				clean_mode = HASH_MODE;
			else if (!strcasecmp(optarg, "failsafe"))
				clean_mode = FAILSAFE_MODE;
			else if (!strcasecmp(optarg, "del"))
				clean_mode = DEL_MODE;
			else
				dcc_logbad(EX_USAGE,
					   "unrecognized repair mode -R %s",
					   optarg);
			break;

		case 's':		/* hash table size in entries */
			new_hash_len = strtoul(optarg, &p, 0);
			if (*p != '\0'
			    || new_hash_len < MIN_HASH_ENTRIES
			    || new_hash_len > MAX_HASH_ENTRIES)
				dcc_logbad(EX_USAGE,
					   "invalid database size \"%s\"",
					   optarg);
			break;

		case 'e':		/* expiration for non-bulk checksums */
			if (grey_on)
				dcc_logbad(EX_USAGE,
					   "do not use -e with -G");
			if (have_expire_parms < 0)
				dcc_logbad(EX_USAGE,
					   "-e cannot be used with -P");
			have_expire_parms = 1;
			expire_secs = dcc_get_secs(optarg, 0,
						   DB_EXPIRE_SECS_MIN,
						   DB_EXPIRE_SECS_MAX, -1);
			if (expire_secs < 0)
				dcc_logbad(EX_USAGE,
					   "invalid expiration seconds"
					   " \"-e %s\"",
					   optarg);
			break;

		case 'E':		/* expiration for bulk checksums */
			if (grey_on)
				dcc_logbad(EX_USAGE,
					   "do not use -E with -G");
			if (have_expire_parms < 0)
				dcc_logbad(EX_USAGE,
					   "do not use -E with -P");
			have_expire_parms = 1;
			expire_spamsecs = dcc_get_secs(optarg, 0,
						       DB_EXPIRE_SECS_MIN,
						       DB_EXPIRE_SECS_MAX, -1);
			if (expire_spamsecs < 0)
				dcc_logbad(EX_USAGE,
					   "invalid spam expiration seconds"
					   " \"-E %s\"",
					   optarg);
			break;

		case 'L':
			dcc_parse_log_opt(optarg);
			break;

		default:
			usage(0);
		}
	}
	argc -= optind;
	argv += optind;
	if (argc != 0)
		usage(1);

	dcc_clnt_unthread_init();

	/* move to the target directory
	 * and set homedir for dcc_fnm2rel_good() */
	if (!dcc_cdhome(&dcc_emsg, homedir, 0))
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);

	/* compute the database file names */
	get_paths(1);
	get_paths(0);

	cp = "";
	switch (clean_mode) {
	case NORMAL_MODE: cp = "cleaning"; break;
	case REPAIR_MODE: cp = "repairing"; break;
	case QUICK_MODE: cp = "quick cleaning"; break;
	case HASH_MODE: cp = "expanding hash table in"; break;
	case FAILSAFE_MODE: cp = "work around missing cron job for"; break;
	case DEL_MODE: cp = "clean up deletion in"; break;
	}
	quiet_trace_msg(DCC_VERSION" %s %s", cp, db_paths.base.c);

	/* see if we can talk to the server */
	if (!standalone) {
		const ID_TBL *id_tbl;
		SRVR_NM_PORT *nm_port;

		/* we must have the server-ID to talk to the server */
		if (server_id == DCC_ID_INVALID && !standalone) {
			if (print_version)
				exit(EX_OK);
			usage(1);
		}
		i = load_ids(&dcc_emsg, server_id, &id_tbl, 1, db_debug > 1);
		if (!id_tbl)
			dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);
		/* merely complain about a sick file if we got a password */
		if (i <= 0)
			dcc_error_msg("%s", dcc_emsg.c);

		nm_port = nms_ports;
		for (;;) {
			DCC_CLNT_FGS clnt_fgs;

			memcpy(&server, &server_def, sizeof(server));
			server.port = DCC_GREY2PORT(grey_on);
			server.clnt_id = server_id;
			memcpy(server.passwd, id_tbl->cur_passwd,
			       sizeof(server.passwd));
			if (nm_port) {
				if (nm_port->nm[0] != '\0')
					memcpy(server.hostname, nm_port->nm,
					       sizeof(server.hostname));
				if (nm_port->port != 0)
					server.port = nm_port->port;
			}

			/* try hard to contact dccd */
			clnt_fgs = DCC_CLNT_FG_SLOW;
			if (grey_on)
				clnt_fgs |= DCC_CLNT_FG_GREY;
			if ((0 != (ctxt = dcc_tmp_clnt_init(&dcc_emsg, 0,
							&server, 0, 0,
							clnt_fgs, 0)))
			    || (0 != (ctxt = dcc_tmp_clnt_init(&dcc_emsg,0,
							&server, 0, 0,
							clnt_fgs, 0)))) {
				const DCC_SRVR_CLASS *class;

				/* after we find a working IP address,
				 * ensure that we never try another */
				class = DCC_GREY2CLASS(grey_on);
				dcc_ip2str(server.hostname,
					   sizeof(server.hostname),
					   &class->addrs[class->srvr_inx
							].ip);
				dcc_ctxts_lock();
				dcc_unmap_close_info(0);
				dcc_rel_ctxt(ctxt);
				dcc_ctxts_unlock();
				ctxt = dcc_tmp_clnt_init(&dcc_emsg, 0,
							&server, 0, 0,
							clnt_fgs, 0);
				if (ctxt)
					break;

				/* start over if that failed */
				nm_port = nms_ports;
				continue;
			}

			if (!nm_port)
				dcc_logbad(EX_DCC_RESTART,
					   "initial contact: %s", dcc_emsg.c);

			/* try the next port and IP address we've been given
			 * and eventually fall back on the default */
			nm_port = nm_port->fwd;
		}
	}

	atexit(finish);
	signal(SIGHUP, sigterm);
	signal(SIGTERM, sigterm);
	signal(SIGINT, sigterm);
#ifdef SIGXFSZ
	signal(SIGXFSZ, SIG_IGN);
#endif

	/* exclude other instances of this program */
	if (!lock_dbclean(&dcc_emsg, db_paths.base.c))
		dcc_logbad(emsg_ex_code(&dcc_emsg),
			   "%s: dbclean already running?", dcc_emsg.c);

	/* create & the lock new database file */
	unlink_whine(0, db_paths.new.c, 1);
	new_db_fd = dcc_lock_open(&dcc_emsg, db_paths.new.c, O_RDWR|O_CREAT,
				  DCC_LOCK_OPEN_NOWAIT, DCC_LOCK_ALL_FILE, 0);
	if (new_db_fd == -1)
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);
	if (0 > ftruncate(new_db_fd, 0))
		dcc_logbad(EX_IOERR, "ftruncate(%s,0): %s",
			   db_paths.new.c, ERROR_STR());

	/* Look for an existing file and a hint about the new size. */
	old_db_fd = open(db_paths.base.c, O_RDONLY, 0);
	if (old_db_fd < 0) {
		if (errno != ENOENT)
			dcc_logbad(EX_IOERR, "open(%s): %s",
				   db_paths.prev_msg, ERROR_STR());
		/* empty a missing database */
		prev_db_csize = 0;
		cleardb = 1;
	} else {
		if (0 > fstat(old_db_fd, &cur_db_sb))
			dcc_logbad(EX_IOERR, "stat(%s): %s",
				   db_paths.prev.c, ERROR_STR());
		prev_db_csize = cur_db_sb.st_size;
		if (prev_db_csize == 0)
			cleardb = 1;	/* empty an empty database */
		close(old_db_fd);
		old_db_fd = -1;
	}
	new_db_blksize = get_db_blksize(prev_db_csize, 0);

	new_db_fsize = 0;
	new_db_created = 1;
	new_db_csize = DB_PTR_BASE;

	write_new_hdr(1);

	if (standalone) {
		u_char busy;

		/* Open and lock the current database to ensure
		 * the daemon is not running. */
		old_db_fd = dcc_lock_open(&dcc_emsg, db_paths.base.c, O_RDWR,
					  DCC_LOCK_OPEN_NOWAIT,
					  DCC_LOCK_ALL_FILE, &busy);
		if (busy)
			dcc_logbad(EX_USAGE, "database %s in use: %s",
				   db_paths.prev_msg, dcc_emsg.c);
		if (cleardb
		    && stat(db_paths.prev.c, &cur_db_sb) >= 0) {
			if (cur_db_sb.st_size != 0)
				dcc_logbad(EX_USAGE, "%s already exists",
					   db_paths.prev_msg);
			cur_db_created = 1;
		}

		/* create and lock the current database if it did not exist
		 * to ensure that the server daemon is not running */
		if (old_db_fd < 0) {
			old_db_fd = dcc_lock_open(&dcc_emsg, db_paths.base.c,
						  O_RDWR|O_CREAT,
						  DCC_LOCK_OPEN_NOWAIT,
						  DCC_LOCK_ALL_FILE, 0);
			if (old_db_fd < 0)
				dcc_logbad(emsg_ex_code(&dcc_emsg),
					   "%s", dcc_emsg.c);
			cur_db_created = 1;
		}

	} else {
		/* Tell the daemon to start turning off the flooding
		 * so we can adjust its positions in the flood map file
		 * Try very hard to talk to it because releasing the database
		 * can cause some UNIX flavors to stall dccd. */
		++flods_off;
		if (!persist_aop(DCC_AOP_FLOD, DCC_AOP_FLOD_SHUTDOWN,
				 SHORT_DELAY))
			dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);
	}

	/* resolve whitelisted host names before locking the old database */
	parse_white();

	/* Tell the daemon to unlock the database between operations
	 * and insist it stop flooding. */
	if (!standalone) {
		/* give the daemon a chance to stop pumping the floods */
		for (;;) {
			if (!persist_aop(DCC_AOP_FLOD, DCC_AOP_FLOD_CHECK,
					 SHORT_DELAY))
				dcc_logbad(EX_UNAVAILABLE, "%s", dcc_emsg.c);

			i = flod_running(aop_resp.resp.val.string);
			if (i < 0)
				dcc_logbad(EX_PROTOCOL,
					   "%s: unrecognized \"%s\"",
					   dcc_aop2str(0, 0,
						       DCC_AOP_FLOD,
						       DCC_AOP_FLOD_CHECK),
					   aop_resp.resp.val.string);
			if (i == 0)
				break;
			if (time(0) > clean_start.tv_sec+45) {
				if (flods_off < 2) {
					++flods_off;
					if (!persist_aop(DCC_AOP_FLOD,
							DCC_AOP_FLOD_HALT,
							SHORT_DELAY))
					    dcc_logbad(emsg_ex_code(&dcc_emsg),
						       "%s", dcc_emsg.c);
					continue;
				}
				if (time(0) > clean_start.tv_sec+60)
					dcc_logbad(EX_UNAVAILABLE,
						   "failed to stop floods: %s",
						   aop_resp.resp.val.string);
			}
			usleep(100*1000);
		}
		dccd_unlocked = 1;
		if (!persist_aop(DCC_AOP_DB_CLEAN, 0, SHORT_DELAY))
			dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);
		/* The daemon adds its own and removes our hold on flooding
		 * when we tell it to unlock the database after every
		 * operation. */
		--flods_off;
	}

	if (cleardb) {
		quiet_trace_msg(DCC_VERSION" %s database %s %s",
				cur_db_created ? "creating" : "clearing",
				db_paths.next.c, hash_paths.next.c);

	} else if (clean_mode == REPAIR_MODE) {
		dcc_error_msg("explicit repair of %s", db_paths.prev_msg);

	} else {
		if (!db_open(&dcc_emsg, old_db_fd, db_paths.base.c,
			     hash_paths.base.c, 0,
			     DB_OPEN_RDONLY
			     | (standalone
				? DB_OPEN_LOCK_NOWAIT : DB_OPEN_LOCK_WAIT))) {
			/* If the hash table is sick, check timestamps only
			 * as much as no hash table allows.
			 * Then rebuild the hash table. */
			dcc_error_msg("%s; must repair", dcc_emsg.c);
			clean_mode = REPAIR_MODE;

		} else {
			if (db_debug) {
				quiet_trace_msg("%d old hash entries total,"
						" %d or %d%% used in %s",
						ADJ_HLEN(db_hash_len),
						ADJ_HLEN(db_hash_used),
						(int)((ADJ_HLEN(db_hash_used)
						       * 100.0)
						      /ADJ_HLEN(db_hash_len)),
						hash_paths.prev.c);
			}
			prev_db_parms = db_parms;
			prev_db_hash_used = db_hash_used;

			/* save a handle on the old database to get
			 * reports that arrive while we expire it */
			old_db_fd = dup(db_fd);
			if (old_db_fd < 0)
				dcc_logbad(EX_OSERR, "dup(%s): %s",
					   db_paths.prev.c, ERROR_STR());

			/* read old and create new database files */
			if (!expire(db_csize)) {
				prev_db_hash_used = 0;
				clean_mode = REPAIR_MODE;
			}
		}

		if (clean_mode == REPAIR_MODE)
			dcc_error_msg("repairing %s", db_paths.prev_msg);
	}

	/* Copy the current file with minimal expiring
	 * if we are repairing the hash table (including now repairing
	 * after encountering problems while expiring). */
	if (clean_mode == REPAIR_MODE
	    && !cleardb
	    && !copy_db())
		exit(EX_UNAVAILABLE);
	build_hash();

	/* Push the checksums to the disk.  Do it now with dccd running as
	 * much as as it can despite our saturating the disk
	 * to minimize failures by dccd to answer. */
	if (!dbclean_flush(&dcc_emsg))
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);

	/* Copy any records from the old file to the new file that were
	 * added to the old file while we were creating the new file. */
	if (!cleardb
	    && !catchup(&dcc_emsg))
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);

	/* We have the new database locked.
	 *
	 * Delete the current hash file and its optional symbolic link.
	 * Install both new files and the optional symbolic links. */
	unlink_whine(0, hash_paths.prev.c, 1);
	unlink_whine(0, hash_paths.prev_old.c, 1);
	rename_bail(hash_paths.new.c, hash_paths.next.c);
	if (hash_paths.link_dir.c[0] != '\0') {
		unlink_whine(0, hash_paths.base.c, 1);
		if (0 > symlink(hash_paths.next.c, hash_paths.base.c))
			dcc_error_msg("symlink(%s, %s): %s",
				      hash_paths.next.c, hash_paths.base.c,
				      ERROR_STR());
	}
	new_hash_created = 0;
	if (db_hash_fd >= 0)
		strcpy(db_hash_nm.c, hash_paths.base.c);

	unlink_whine(0, db_paths.prev.c, 1);
	unlink_whine(0, db_paths.prev_old.c, 1);
	rename_bail(db_paths.new.c, db_paths.next.c);
	if (db_paths.link_dir.c[0] != '\0') {
		unlink_whine(0, db_paths.base.c, 1);
		if (0 > symlink(db_paths.next.c, db_paths.base.c))
			dcc_error_msg("symlink(%s, %s): %s",
				      db_paths.next.c, db_paths.base.c,
				      ERROR_STR());
	}
	new_db_created = 0;
	if (db_fd > 0)
		strcpy(db_nm.c, db_paths.base.c);
	cur_db_created = 0;

	if (cleardb) {
		flod_mmap_path_set();
		unlink_whine(0, flod_mmap_path.c, 1);
		if (!db_close(DB_CLOSE))
			exit(EX_UNAVAILABLE);
		exit(EX_OK);
	}

	/* if the daemon was not running, we're finished */
	if (standalone) {
		/* install the flood positions if things are ok */
		if (flod_mmaps) {
			memcpy(flod_mmaps, &new_flod_mmaps,
			       sizeof(new_flod_mmaps));
			flod_unmap(0, 0);
		}
		if (!db_close(DB_CLOSE))
			exit(EX_UNAVAILABLE);
		exit(EX_OK);
	}

	/* tell the daemon to switch to the new database.  This will leave
	 * the daemon stuck waiting for us to unlock the new database. */
	dccd_new_db("copy late arrivals");

	/* install the flood positions if things are ok */
	if (flod_mmaps) {
		memcpy(flod_mmaps, &new_flod_mmaps,
		       sizeof(new_flod_mmaps));
		flod_unmap(0, 0);
	}

	/* Copy any records from the old file to the new file in the
	 * race to tell the daemon to switch to the new file.
	 * The new file is still locked from build_hash().
	 * The daemon should be stuck waiting to open it in the
	 * DCC_AOP_DB_NEW request via the preceding dccd_new_db().
	 *
	 * Since the daemon has switched and probably cannot go back,
	 * ignore any errors */
	catchup(0);
	if (!db_close(DB_CLOSE))
		exit(EX_UNAVAILABLE);

	/* finish() will be called via exit() to tell the daemon to resume
	 * flooding if necessary.  However, in the normal case, we removed
	 * all counts against flooding before calling dccd_new_db() */
	exit(EX_OK);
}



/* compute the old and new database or hash table file names */
static void
get_paths(u_char db)
{
	char arg0, arg;
	const char *arg_dir;
	paths_t *paths;
	DCC_PATH rel, prev, prev_link_dir;
	struct stat sb;
	int i;

	if (db) {
		paths = &db_paths;
		arg0 = arg = 'D';
		arg_dir = db_dir;
	} else {
		paths = &hash_paths;
		arg0 = arg = 'H';
		arg_dir = hash_dir;
		/* by default the hash table follows the database */
		if (!arg_dir) {
			arg = 'D';
			arg_dir = db_dir;
		}
	}

	memset(paths, 0, sizeof(*paths));

	if (arg_dir && !dcc_fnm2abs(&paths->link_dir, arg_dir, 0))
		dcc_error_msg("\"-%c %s\" is too long", arg, arg_dir);

	snprintf(rel.c, sizeof(rel.c), "%s%s",
		 grey_on ? DB_GREY_NAME : DB_DCC_NAME,
		 db ? "" : DB_HASH_SUFFIX);
	if (!dcc_fnm2abs(&paths->base, rel.c, 0))
		dcc_logbad(EX_DATAERR, "impossibly long %s/%s",
			   dcc_homedir.c, rel.c);
	paths->prev = paths->base;
	STRLCPY(paths->prev_msg, paths->base.c, sizeof(paths->prev_msg));

	/* Find the previous file. */
	memset(&prev_link_dir, 0, sizeof(prev_link_dir));
	memset(&prev, 0, sizeof(prev));
	if ((0 > stat(paths->base.c, &sb)
	     ? (errno == ENOENT)
	     : S_ISREG(sb.st_mode))
	    && 0 <= lstat(paths->base.c, &sb)
	    && S_ISLNK(sb.st_mode)
	    && 0 < readlink(paths->base.c, prev.c, sizeof(prev.c))
	    && 1 < (i = strlen(prev.c) - strlen(rel.c))
	    && prev.c[i-1] == '/'
	    && !strcmp(rel.c, &prev.c[i])) {
		paths->prev = prev;
		memcpy(&prev_link_dir, &prev, i-1);
		snprintf(paths->prev_msg, sizeof(paths->prev_msg), "%s -> %s",
			 paths->base.c, paths->prev.c);
		if (db_debug
		    && (!arg_dir
			|| strcmp(prev_link_dir.c, arg_dir)))
			quiet_trace_msg("infer previous \"-%c %s\"",
					arg0, prev_link_dir.c);
	}

	/* assume -H or -D if started by dccd */
	if (paths->link_dir.c[0] == '\0' && clean_mode != NORMAL_MODE)
		paths->link_dir = prev_link_dir;

	if (!dcc_fnm2abs(&paths->prev_old, paths->prev.c, "-old"))
		dcc_logbad(EX_DATAERR, "impossibly long %s-old",
			   paths->prev.c);

	if (paths->link_dir.c[0] != '\0'
	    && 0 > stat(paths->link_dir.c, &sb)) {
		if (errno != ENOENT) {
			dcc_error_msg("-%c %s: %s",
				      arg, paths->link_dir.c, ERROR_STR());
			memset(&paths->link_dir, 0, sizeof(paths->link_dir));
		} else if (0 > mkdir(paths->link_dir.c, 0755)) {
			dcc_error_msg("-%c %s mkdir(): %s",
				      arg, paths->link_dir.c, ERROR_STR());
			memset(&paths->link_dir, 0, sizeof(paths->link_dir));
		} else if (0 > stat(paths->link_dir.c, &sb)) {
			memset(&paths->link_dir, 0, sizeof(paths->link_dir));
		}
	}
	if (paths->link_dir.c[0] != '\0'
	    && !S_ISDIR(sb.st_mode)) {
		dcc_error_msg("-%c %s: not a directory",
			      arg, paths->link_dir.c);
		memset(&paths->link_dir, 0, sizeof(paths->link_dir));
	}
	if (paths->link_dir.c[0] != '\0'
	    && 0 > access(paths->link_dir.c, W_OK)) {
		dcc_error_msg("-%c %s: %s",
			      arg, paths->link_dir.c, ERROR_STR());
		memset(&paths->link_dir, 0, sizeof(paths->link_dir));
	}

	if (paths->link_dir.c[0] != '\0'
	    && snprintf(paths->next.c, ISZ(paths->next), "%s/%s",
			paths->link_dir.c, rel.c) >= ISZ(paths->next)) {
		dcc_error_msg("%s/%s is too long",
			      paths->link_dir.c, rel.c);
		memset(&paths->link_dir, 0, sizeof(paths->link_dir));
	}
	if (paths->link_dir.c[0] != '\0'
	    && !dcc_fnm2abs(&paths->new, paths->next.c, "-new")) {
		dcc_error_msg("%s-new is too long",
			      paths->next.c);
		memset(&paths->link_dir, 0, sizeof(paths->link_dir));
	}

	if (paths->link_dir.c[0] == '\0') {
		paths->next = paths->base;
		if (!dcc_fnm2abs(&paths->new, paths->next.c, "-new")) {
			dcc_logbad(EX_DATAERR, "impossibly long %s-new",
				   paths->new.c);
		}
	}
}



/* adjust output flood positions */
static DB_PTR				/* next position to adjust */
adj_mmap(void)
{
	FLOD_MMAP *mp;
	DB_PTR delta, new_pos;

	delta = new_db_csize - old_db_pos;
	new_pos = 0;
	for (mp = new_flod_mmaps.mmaps;
	     mp <= LAST(new_flod_mmaps.mmaps);
	     ++mp) {
		/* do nothing to marks we have already adjusted */
		if (!(mp->flags & FLODMAP_FG_MARK))
			continue;
		if (mp->confirm_pos > old_db_pos) {
			/* note the next mark that will need adjusting
			 * but do not adjust it yet */
			if (new_pos == 0 || new_pos > mp->confirm_pos)
				new_pos = mp->confirm_pos;
		} else {
			/* adjust marks not past the current position */
			mp->confirm_pos += delta;
			mp->flags &= ~FLODMAP_FG_MARK;
		}
	}

	/* adjust the delay position if we just passed it */
	if (adj_delay_pos) {
		if (new_flod_mmaps.delay_pos > old_db_pos) {
			/* note the next mark that will need adjusting */
			if (new_pos == 0 || new_pos > new_flod_mmaps.delay_pos)
				new_pos = new_flod_mmaps.delay_pos;
		} else {
			new_flod_mmaps.delay_pos += delta;
			/* do it only once */
			adj_delay_pos = 0;
		}
	}

	return new_pos;			/* return next postion to adjust */
}



/* find a checksum */
static const char *			/* 0=broken database */
get_ck(DB_RCD_CK **ckp,			/* point this to the checksum */
       DCC_CK_TYPES type,
       const DCC_SUM *sum,
       DB_ST *hash_st,
       DB_ST *rcd2_st)			/* put the record or garbage here */
{
	DB_FOUND db_result;

	/* We must lock the file to keep the daemon from changing the
	 * internal hash table links. */
	if (!DB_IS_LOCKED()
	    && 0 > db_lock())
		return 0;

	db_result = db_lookup(&dcc_emsg, type, sum, hash_st, rcd2_st, ckp);
	switch (db_result) {
	case DB_FOUND_SYSERR:
		dcc_error_msg("hash lookup for \"%s\" from "L_HxPAT": %s",
			      DB_TYPE2STR(type), old_db_pos, dcc_emsg.c);
		break;

	case DB_FOUND_IT:
		return "";

	case DB_FOUND_EMPTY:
		return "empty";

	case DB_FOUND_CHAIN:
		return "chain";

	case DB_FOUND_INTRUDER:
		return "intruder";
	}

	return 0;
}



/* check the leading report for a not recent checksum */
static int				/* -1=broken database 0=expire 1=keep */
ck_lead(DCC_CK_TYPES type,
	const DB_RCD *rcd,		/* the record under consideration */
	const DB_RCD_CK *rcd_ck,
	DB_ST *hash_st,
	DB_ST *rcd2_st)
{
	DB_RCD_CK *lead_ck;
	DB_PTR prev;
	const char *ck_result;

	/* If the total for the checksum in the target record is so large
	 * that it ensures that the total will be large,
	 * and if the record is not ancient,
	 * then we do not need to spend time looking for the leader */
	if (DB_TGTS_CK(rcd_ck) >= db_tholds[type]
	    && !ts_older_ts(&rcd->ts, &new_spam_ts[type]))
		return 1;

	ck_result = get_ck(&lead_ck, type, &rcd_ck->sum, hash_st, rcd2_st);
	if (!ck_result)
		return -1;
	if (!lead_ck) {
		dcc_error_msg("no leader for %s %s at "L_HxPAT": %s",
			      DB_TYPE2STR(type),
			      ck2str_err(type, &rcd_ck->sum, 0),
			      old_db_pos, ck_result);
		return -1;
	}

	/* Servers with the same name but differing server-IDs
	 * are in a single hash chain. */
	while (type == DCC_CK_SRVR_ID
	       && rcd->srvr_id != rcd2_st->d.r->srvr_id) {
		prev = DB_PTR_EX(lead_ck->prev);
		if (prev == DB_PTR_NULL) {
			dcc_error_msg("null hash chain link"
				      " for %s %s %d at "L_HxPAT
				      " starting from %s %d at "L_HxPAT,
				      DB_TYPE2STR(type),
				      ck2str_err(type, &rcd_ck->sum, 0),
				      rcd2_st->d.r->srvr_id,
				      rcd2_st->s.rptr,
				      ck2str_err(type, &lead_ck->sum, 0),
				      rcd->srvr_id,
				      old_db_pos);
			return -1;
		}
		lead_ck = db_map_rcd_ck(&dcc_emsg, rcd2_st, prev, type);
		if (!lead_ck) {
			dcc_error_msg("leader checksum for %s %s %d"
				      " at "L_HxPAT": %s",
				      DB_TYPE2STR(type),
				      ck2str_err(type, &rcd_ck->sum, 0),
				      rcd->srvr_id,
				      old_db_pos, dcc_emsg.c);
			return -1;
		}
	}

	/* We know the target report is not recent.
	 * Forget the target report if the leader's total is trivial. */
	if (DB_TGTS_CK(lead_ck) < db_tholds[type])
		return 0;

	/* Forget the target if both the target and the leader are ancient.
	 * The leader might not be the newest checksum, but it usually is.
	 * The target might be the leader. */
	if (ts_older_ts(&rcd2_st->d.r->ts, &new_spam_ts[type])
	    && ts_older_ts(&rcd->ts, &new_spam_ts[type]))
		return 0;

	return 1;
}



static int				/* -1=broken database 0=expire 1=keep */
ck_lead_rep(DCC_CK_TYPES type,
	    const DB_RCD *rcd,		/* the record under consideration */
	    const DB_RCD_CK *rcd_ck,
	    const DB_RCD_CK *rcd_ck_lim,
	    DB_ST *hash_st,
	    DB_ST *rcd2_st)
{
	DB_RCD_CK *lead_ck;
	DCC_TGTS bulk_tgts, total_tgts;
	const char *ck_result;

	/* expire all reputation checksums older than 30 days */
	if (ts_older_ts(&rcd->ts, &new_spam_ts[type]))
		return 0;

	/* Keep reputation checksums
	 *	that are not ancient
	 *	and if the reputation is not zero
	 *	or if the total is large enough to be exculpatory
	 * This must be consistent with the summarizing in the server.
	 *
	 * We do not need to check the leader if the count
	 * in the target record is so large that it ensures
	 * that the leader's value will be non-trivial */
	if (type == DCC_CK_REP_TOTAL) {
		if (DB_TGTS_CK(rcd_ck) >= DCC_REP_TGTS_TOTAL_SIGNIF)
			return 1;
		/* the next checksum is often DCC_CK_REP_BULK */
		if (rcd_ck+1 < rcd_ck_lim
		    && DB_CK_TYPE(rcd_ck+1) == DCC_CK_REP_BULK
		    && DB_TGTS_CK(rcd_ck+1) >= DCC_REP_TGTS_BULK_SIGNIF)
			return 1;
	} else {
		if (DB_TGTS_CK(rcd_ck) >= DCC_REP_TGTS_BULK_SIGNIF)
			return 1;
		/* because the caller remembers our answer,
		 * and because a TOTAL checksum if present precedes a bulk
		 * checksum, we know the there is no TOTAL checksum in this
		 * record */
	}

	/* The known totals up to the target are not enough
	 * We must check one or both leaders */
	ck_result = get_ck(&lead_ck, DCC_CK_REP_BULK, &rcd_ck->sum,
			   hash_st, rcd2_st);
	if (!ck_result)
		return -1;
	if (!lead_ck) {
		if (type == DCC_CK_REP_BULK) {
			dcc_error_msg("no leader for %s %s at "L_HxPAT": %s",
				      DB_TYPE2STR(DCC_CK_REP_BULK),
				      ck2str_err(DCC_CK_REP_BULK,
						 &rcd_ck->sum, 0),
				      old_db_pos, ck_result);
			return -1;
		}
		/* with no reports of bulk mail,
		 * we know the reputation is zero */
		return 0;
	}
	bulk_tgts = DB_TGTS_CK(lead_ck);
	if (bulk_tgts >= DCC_REP_TGTS_BULK_SIGNIF)
		return 1;

	ck_result = get_ck(&lead_ck, DCC_CK_REP_TOTAL, &rcd_ck->sum,
			   hash_st, rcd2_st);
	if (!ck_result)
		return -1;
	if (!lead_ck) {
		if (type == DCC_CK_REP_TOTAL) {
			dcc_error_msg("no leader for %s %s at "L_HxPAT": %s",
				      DB_TYPE2STR(DCC_CK_REP_TOTAL),
				      ck2str_err(DCC_CK_REP_TOTAL,
						 &rcd_ck->sum, 0),
				      old_db_pos, ck_result);
			return -1;
		}
		return 0;		/* we know the reputation is 0 */
	}
	total_tgts = DB_TGTS_CK(lead_ck);
	if (total_tgts >= DCC_REP_TGTS_TOTAL_SIGNIF)
		return 1;

	if (total_tgts >= DCC_REP_TGTS_TOTAL_MIN
	    && get_reputation(bulk_tgts, total_tgts) != 0)
		return 1;

	return 0;
}



static void
report_progress_init(void)
{
	gettimeofday(&db_time, 0);
	progress_rpt_start.tv_sec = db_time.tv_sec;
	progress_rpt_checked = db_time;
	progress_rpt_last = db_time;
	progress_rpt_base = 100;
	progress_rpt_cnt = progress_rpt_base;
	progress_rpt_started = 0;
}



static time_t				/* us since last check */
report_progress(u_char final,
		const char *s1, const char *s2,
		DB_PTR done, DB_PTR total, DB_PTR scale)
{
	time_t reported_us, checked_us, secs, interval;
	double percent;

	if (!total)
		percent = 100.0;
	else
		percent = (done*100.0)/total;

	gettimeofday(&db_time, 0);
	checked_us = tv_diff2us(&db_time, &progress_rpt_checked);
	progress_rpt_checked = db_time;

	/* Check frequently enough to report or unlock the database.
	 * Adjust the number of operations until the next check
	 * based on the time spent on the previous */
	if (checked_us > 0)
		progress_rpt_base = ((progress_rpt_base * 0.5 * DCC_US
				      * min(REPORT_INTERVAL_FAST_SECS*DCC_US,
					    UNLOCK_INTERVAL_USECS))
				     / checked_us);
	else
		progress_rpt_base = 100;
	if (progress_rpt_base < 100)
		progress_rpt_base = 100;
	if (progress_rpt_base > 10*1000)
		progress_rpt_base = 10*1000;
	progress_rpt_cnt = progress_rpt_base;

	interval = ((db_debug > 1)
		    ? REPORT_INTERVAL_FAST_SECS
		    : REPORT_INTERVAL_SECS);

	/* try not to start reporting progress at the end */
	if (!progress_rpt_started
	    && (total*1.0 - done*1.0) / progress_rpt_base <= interval*1.0)
		return checked_us;

	reported_us = tv_diff2us(&db_time, &progress_rpt_last);
	if (reported_us >= interval * DCC_US
	    || (final && progress_rpt_percent != 100)) {
		progress_rpt_started = 1;
		progress_rpt_percent = percent;
		secs = db_time.tv_sec - progress_rpt_start.tv_sec;
		secs -= secs % interval;
		progress_rpt_last.tv_sec = progress_rpt_start.tv_sec + secs;
		if (db_debug > 1)
			quiet_trace_msg("%s "L_DPAT" of "L_DPAT" %s or %d%%"
					"    db_mmaps=%d hash=%d",
					s1, done/scale, total/scale,
					s2, progress_rpt_percent,
					db_stats.db_mmaps, db_stats.hash_mmaps);
		else
			quiet_trace_msg("%s "L_DPAT" of "L_DPAT" %s or %d%%",
					s1, done/scale, total/scale,
					s2, progress_rpt_percent);
	}


	if (clean_mode == QUICK_MODE
	    && !final) {
		if (db_time.tv_sec > clean_start.tv_sec + 15*60)
			dcc_logbad(EX_UNAVAILABLE, "quick cleaning too slow");
	}

	return checked_us;
}



/* delete old, less fuzzy checksums in the new record */
static void
trim_old_fuz(DB_RCD *new, DB_RCD_CK **end_ck)
{
	DB_RCD_CK *rcd_ck;
	DCC_CK_TYPES type;
	int len;

	rcd_ck = new->cks;
	while (rcd_ck < *end_ck) {
		type = DB_CK_TYPE(rcd_ck);
		if (!ts_older_ts(&new->ts, &new_all_ts[type])) {
			++rcd_ck;
			continue;
		}

		++obs_rcds;
		new->fgs_num_cks = (DB_NUM_CKS(new) - 1) | DB_RCD_FG_TRIM;
		--*end_ck;
		len = (char *)*end_ck - (char *)rcd_ck;
		if (len == 0)
			return;
		memmove(rcd_ck, rcd_ck+1, len);
	}
}



static void
adj_def_expire(void)
{
	double new_dbsize, new_dbsize1, day_rate, db_ratio;
	int spam_secs, secs;
	char new_dbsize_buf[20], csize_buf[20], old_csize_buf[20];
	char day_rate_buf[20];

	/* do this only once */
	if (def_exp_ratio != 0.0)
		return;

	/* Compute the ratio of size of the database 24 hours from now
	 * to the size of the window. Assume:
	 *  - We will receive about the same number of reports in the next
	 *	24 hours as the last 24.  This is a good assumption for
	 *	weekdays, but as much as 30% wrong about weekends.
	 *  - Dbclean will be run once per day at the current time.
	 *  - The size of the database is a linear function of expiration
	 *	duration.  This is tenuous when the spam expiration duration
	 *	is less than 1 day.
	 * Use the maximum of two guesses for tomorrow's database size.
	 *	One guess is the current size, base on assuming that
	 *	we will use roughly the same expiration durations and
	 *	so the database will grow to about size it now has.
	 *	The other guess uses the previous database size and the
	 *	avarage data rate.  It compensates for short term changes
	 *	in the rate and for running dbclean more than once per day. */
	new_dbsize = db_parms.db_csize;
	size2str(csize_buf, sizeof(csize_buf), new_dbsize, 1);
	new_dbsize1 = db_parms.old_db_csize;
	size2str(old_csize_buf, sizeof(old_csize_buf), new_dbsize1, 1);
	day_rate = db_add_rate(&db_parms, 0, 0);
	if (day_rate >= 0.0)
		day_rate *= (24*60*60);
	size2str(day_rate_buf, sizeof(day_rate_buf), day_rate, 1);

	/* without information, be pessimistic and assume 1.4 GByte/day */
	if (day_rate <= 0.0 && !grey_on)
		day_rate = 1.4*1024.0*1024.0*1024.0;
	if (day_rate > 0.0) {
		new_dbsize1 += day_rate;
		if (new_dbsize < new_dbsize1)
			new_dbsize = new_dbsize1;
	}

	size2str(new_dbsize_buf, sizeof(new_dbsize_buf), new_dbsize, 1);
	if (db_debug)
		quiet_trace_msg("predict new_dbsize=%s from db_csize=%s"
				" old_db_csize=%s rate=%s",
				new_dbsize_buf,
				csize_buf, old_csize_buf, day_rate_buf);

	/* Assume there will be 20% as many bytes used in the hash table
	 * as in the database */
	new_dbsize *= 1.2;

	/* we cannot adjust the defaults
	 *  - the first time dbclean is run
	 *  - if the previous run used a larger than default value
	 *  - there is no need to reduce the default because the predicted
	 *	maximum size is smaller than the target maximum */
	spam_secs = db_parms.ex_secs[DCC_CK_FUZ2].spam;
	if (spam_secs != 0
	    && spam_secs <= DB_EXPIRE_SPAMSECS_DEF
	    && new_dbsize > db_max_byte
	    && (db_ratio = (db_max_byte / new_dbsize)) < 1.0
	    && ((def_exp_ratio = (spam_secs*db_ratio)/DB_EXPIRE_SPAMSECS_DEF)
		<= 0.99)) {

		/* change the two durations together and so with same errors */
		def_expire_spamsecs = DB_EXPIRE_SPAMSECS_DEF * def_exp_ratio;
		def_expire_secs = DB_EXPIRE_SECS_DEF * def_exp_ratio;

		def_expire_secs -= def_expire_secs % (60*60);
		if (def_expire_secs < DB_EXPIRE_SECS_DEF_MIN)
			def_expire_secs = DB_EXPIRE_SECS_DEF_MIN;

		def_expire_spamsecs -= def_expire_spamsecs % (24*60*60);
		if (def_expire_spamsecs < DB_EXPIRE_SPAMSECS_DEF_MIN)
			def_expire_spamsecs = DB_EXPIRE_SPAMSECS_DEF_MIN;

#if DCC_DB_MIN_MBYTE == 0 && !defined(DCC_HAVE_PHYSMEM)
		if (def_expire_secs == DB_EXPIRE_SECS_DEF_MIN
		    || def_expire_spamsecs == DB_EXPIRE_SPAMSECS_DEF_MIN)
			quiet_trace_msg("cannot determine physical RAM; rebuild"
					" with ./configure with-db-memory");
#endif
		return;
	}

	def_exp_ratio = 1.0;

	/* if the defaults do not need to be reduced now but they
	 * were reduced before, then relax them gently */
	if (spam_secs < DB_EXPIRE_SPAMSECS_DEF) {
		secs = (clean_start.tv_sec
			- ts2secs(&db_parms.ex_spam[DCC_CK_FUZ2]));
		if (secs > 0 && secs < DB_EXPIRE_SPAMSECS_DEF)
			def_expire_spamsecs = secs;

		secs = (clean_start.tv_sec
			- ts2secs(&db_parms.ex_all[DCC_CK_FUZ2]));
		if (secs > 0 && secs < DB_EXPIRE_SECS_DEF)
			def_expire_secs = secs;
	}
}



static u_char
expire_fail(void)
{
	/* Only stop copying the old database if we are repairing. */
	if (clean_mode == REPAIR_MODE)
		return 1;

	flod_unmap(0, 0);
	db_close(DB_CLOSE);
	return 0;
}



/* copy the existing database, discard junk and old entries */
static u_char				/* 1=done 0=database broken */
expire(DB_PTR old_db_csize)
{
#define EXPIRE_BAIL() {if (expire_fail()) goto copy_failed; return 0;}
	DCC_TS ts;
	u_char emptied, reduced_defaults, whines;
	u_char old_ok[DCC_DIM_CKS];
	DB_RCD rcd_buf, new;
	DB_ST *rcd_st, *hash_st, *rcd2_st;
	const DB_RCD *rcd;
	const DB_RCD_CK *rcd_ck, *rcd_ck_lim, *rcd_ck2;
	DB_RCD_CK *new_ck;
	DCC_TGTS tgts_raw, ck_tgts;
	u_char expire_rcd;		/* 1=expire entire record */
	u_char split_ok;		/* 1=split ok because not floodable */
	u_char obs_lvl;
	int rcd_num_cks, new_num_cks, nokeep_num_cks;
	DB_PTR rcd_prev, min_delay_pos, next_adj_pos;
	FLOD_MMAP *mp;
	DCC_CK_TYPES prev_type, type, type2;
	int rcd_len;
	struct stat sb;
	time_t need_unlock;
	DB_PTR rep_prev_db_pos = DB_PTR_NULL;
	int rep_prev_lead = 0;
	int i;

	reduced_defaults = 0;
	if (expire_secs < 0) {
		adj_def_expire();
		if (def_expire_secs > expire_spamsecs
		    && expire_spamsecs > 0) {
			expire_secs = expire_spamsecs;
		} else {
			if (def_expire_secs != DB_EXPIRE_SECS_DEF
			    && def_exp_ratio != 1.0)
				reduced_defaults = 1;
			expire_secs = def_expire_secs;
		}
	}
	if (expire_spamsecs < 0) {
		adj_def_expire();
		if (def_expire_spamsecs < expire_secs) {
			expire_spamsecs = expire_secs;
		} else {
			if (def_expire_spamsecs != DB_EXPIRE_SPAMSECS_DEF
			    && def_exp_ratio != 1.0)
				reduced_defaults = 1;
			expire_spamsecs = def_expire_spamsecs;
		}
	}

	if (expire_spamsecs > 0 && expire_spamsecs < expire_secs)
		dcc_logbad(EX_USAGE,
			   "spam expiration -E must be longer than -e");

	expired_rcds = 0;
	expired_cks = 0;
	kept_cks = white_cks;
	need_unlock = 0;
	report_progress_init();

	/* Compute timestamps for records we keep.
	 * Use the values from the previous use of dbclean as defaults
	 * unless they are bogus */
	memset(old_ok, 0, sizeof(old_ok));
	secs2ts(&ts, clean_start.tv_sec);
	for (type = DCC_CK_TYPE_FIRST; type <= DCC_CK_TYPE_LAST; ++type) {
		DB_EX_SEC *th = &db_parms.ex_secs[type];

		if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type))
			continue;
		if (DCC_CK_IS_REP(grey_on, type))
			continue;

		if (th->spam <= 0 || th->spam > DB_EXPIRE_SECS_MAX)
			continue;
		if (th->all <= 0 || th->all > th->spam)
			continue;

		if (ts_newer_ts(&db_parms.ex_spam[type], &ts))
			continue;
		if (ts_newer_ts(&db_parms.ex_all[type], &ts))
			continue;

		old_ok[type] = 1;	/* old values for this type are ok */
	}

	for (type = DCC_CK_TYPE_FIRST; type <= DCC_CK_TYPE_LAST; ++type) {
		DB_EX_SEC *new_th = &new_ex_secs[type];
		int old_all = db_parms.ex_secs[type].all;
		int old_spam = db_parms.ex_secs[type].spam;

		if (type == DCC_CK_SRVR_ID) {
			/* keep server-ID declarations */
			new_th->all = DB_EXPIRE_SERVER_ID;
			new_th->spam = DB_EXPIRE_SERVER_ID;

		} else if (grey_on) {
			if (old_ok[type]) {
				/* This is the path by which the dccd -G
				 * parameters are used. */
				new_th->all = old_all;
				new_th->spam = old_spam;
			} else if (DCC_CK_IS_GREY_TRIPLE(1, type)) {
				new_th->all = DEF_GREY_WINDOW;
				new_th->spam = DEF_GREY_WHITE;
			} else if (DCC_CK_IS_GREY_MSG(1, type)
				   || type == DCC_CK_BODY) {
				new_th->all = DEF_GREY_WINDOW;
				new_th->spam = DEF_GREY_WINDOW;
			} else {
				new_th->all = 1;
				new_th->spam = 1;
			}

		} else if (DCC_CK_IS_REP(grey_on, type)) {
			/* reputations need consistent expirations
			 * but allow "never" */
			if (expire_secs >= DB_EXPIRE_SECS_MAX) {
				new_th->all = DB_EXPIRE_SECS_MAX;
				new_th->spam = DB_EXPIRE_SECS_MAX;
			} else {
				new_th->all = DB_EXPIRE_REP_SECS_DEF;
				new_th->spam = DB_EXPIRE_REP_SPAMSECS_DEF;
			}

		} else if (have_expire_parms < 0 && old_ok[type]
			   && (db_parms.flags & DB_PARM_FG_EXP_SET)) {
			/* use the old durations they are valid
			 * and we have no expiriation parameters */
			new_th->all = old_all;
			new_th->spam = old_spam;

		} else {
			new_th->all = expire_secs;
			new_th->spam = (DCC_CK_LONG_TERM(type)
					? expire_spamsecs
					: expire_secs);
			if (reduced_defaults) {
				quiet_trace_msg("adjust default by"
						" %4.2f to -e%dhours"
						" -E%ddays",
						def_exp_ratio,
						expire_secs/(60*60),
						expire_spamsecs
						/ (24*60*60));
				reduced_defaults = 0;
			}
		}

		/* compute oldest timestamp for this type of checksum,
		 * without going crazy with "-Enever" */
		secs2ts(&new_spam_ts[type],
			clean_start.tv_sec - min(clean_start.tv_sec,
						 new_th->spam));
		new_all_secs[type] = clean_start.tv_sec - min(clean_start.tv_sec,
							new_th->all);
		secs2ts(&new_all_ts[type], new_all_secs[type]);
		secs2ts(&stale_ts[type],
			clean_start.tv_sec - min(clean_start.tv_sec,
						 max(DB_EXPIRE_SECS_DEF,
						     new_th->all)));
		secs2ts(&ancient_ts[type],
			clean_start.tv_sec - min(clean_start.tv_sec,
						 2*new_th->spam));
	}

	/* put the timestamps into the new file */
	write_new_hdr(1);

	/* if we are running as root,
	 * don't change the owner of the database */
	if (getuid() == 0) {
		if (0 > fstat(old_db_fd, &sb))
			dcc_logbad(EX_IOERR, "fstat(%s): %s",
				   db_paths.base.c, ERROR_STR());
		if (0 > fchown(new_db_fd, sb.st_uid, sb.st_gid))
			dcc_logbad(EX_IOERR, "fchown(%s,%d,%d): %s",
				   db_paths.new.c,
				   (int)sb.st_uid, (int)sb.st_gid,
				   ERROR_STR());
	}

	if (DB_PTR_BASE != lseek(old_db_fd, DB_PTR_BASE, SEEK_SET))
		dcc_logbad(EX_IOERR, "lseek(%s,%d): %s",
			   db_paths.prev.c, DB_PTR_BASE, ERROR_STR());
	read_rcd_invalidate(0);

	flod_mmap(0, &db_parms.sn, 0, 1);
	if (flod_mmaps)
		memcpy(&new_flod_mmaps, flod_mmaps, sizeof(new_flod_mmaps));
	min_confirm_pos = DB_PTR_NULL;
	min_delay_pos = DB_PTR_NULL;
	next_adj_pos = DB_PTR_BASE;
	for (mp = new_flod_mmaps.mmaps;
	     mp <= LAST(new_flod_mmaps.mmaps);
	     ++mp) {
		if (mp->rem_hostname[0] == '\0') {
			mp->flags &= ~FLODMAP_FG_MARK;
		} else {
			mp->flags |= FLODMAP_FG_MARK;
		}
	}
	adj_delay_pos = (new_flod_mmaps.delay_pos != 0) ? 1 : 0;

	emptied = 1;
	whines = 20;
	timeval2ts(&new_flod_mmaps.sn, &clean_start, 0);
	if (clean_mode != REPAIR_MODE) {
		rcd_st = GET_DB_ST();
		hash_st = GET_DB_ST();
		rcd2_st = GET_DB_ST();
	} else {
		rcd_st = 0;
		hash_st = 0;
		rcd2_st = 0;
	}

	/* copy the old file to the new,
	 * discarding and compressing old data as we go */
	for (old_db_pos = DB_PTR_BASE;
	     old_db_pos < old_db_csize;
	     old_db_pos += rcd_len) {
		if (--progress_rpt_cnt <= 0)
			need_unlock += report_progress(0, "  processed",
						       "MBytes",
						       old_db_pos, old_db_csize,
						       1024*1024);

		if (old_db_pos == next_adj_pos)
			next_adj_pos = adj_mmap();

		if (clean_mode != REPAIR_MODE) {
			/* read the record by mapping if not repairing */
			if (!db_map_rcd(0, rcd_st, old_db_pos, &rcd_len))
				EXPIRE_BAIL();
			rcd = rcd_st->d.r;
		} else {
			rcd_len = read_rcd(0, &rcd_buf, old_db_fd, old_db_pos,
					   db_paths.prev.c);
			if (rcd_len <= 0) {
				if (rcd_len == 0)
					dcc_error_msg("unexpected EOF in %s at "
						      L_HxPAT" instead of "
						      L_HxPAT,
						      db_paths.prev.c,
						      old_db_pos,
						      old_db_csize);
				/* give up and ask our neighbors to rewind */
				EXPIRE_BAIL();
			}
			rcd = &rcd_buf;
		}

		if (old_db_pos + rcd_len > old_db_csize) {
			dcc_error_msg("bad record length %d at "L_HxPAT" in %s",
				      rcd_len, old_db_pos, db_paths.prev.c);
			EXPIRE_BAIL();
		}

		/* skip end-of-page padding */
		if (rcd_len == sizeof(*rcd)-sizeof(rcd->cks)) {
			if (memcmp(rcd, zero_rcd, rcd_len)) {
				dcc_error_msg("non-zero end-of-page padding"
					      " at "L_HxPAT" in %s",
					      old_db_pos, db_paths.prev.c);
				EXPIRE_BAIL();
			}
			if (old_db_pos % sys_pagesize
			    < sys_pagesize - DB_RCD_LEN_MAX) {
				dcc_error_msg("stray end-of-page padding"
					      " at "L_HxPAT" in %s",
					      old_db_pos, db_paths.prev.c);
				EXPIRE_BAIL();
			}
			continue;
		}

		memcpy(&new, rcd, sizeof(new)-sizeof(new.cks));
		new.fgs_num_cks &= ~DB_RCD_FG_MASK;
		if (DB_RCD_ID(rcd) == DCC_ID_WHITE) {
			/* skip whitelist entries if whitelist source is ok */
			if (!keep_white)
				continue;
			/* refresh whitelist entries if source is bad */
			timeval2ts(&new.ts, &clean_start, 0);
		}

		rcd_num_cks = DB_NUM_CKS(rcd);

		/* expire or throw away deleted reports */
		tgts_raw = DB_TGTS_RCD_RAW(&new);
		if (tgts_raw == 0) {
			++expired_rcds;
			expired_cks += rcd_num_cks;
			continue;
		}
		if (tgts_raw > DCC_TGTS_MAX_DB) {
			dcc_error_msg("report at "L_HxPAT
				      " with bogus target count"
				      " %#x in %s",
				      old_db_pos, tgts_raw,
				      db_paths.prev.c);
			EXPIRE_BAIL();
		}

		if (ts_newer_ts(&new.ts, &future_ts)) {
			if (whines > 0)
				dcc_error_msg("discarding report at "L_HxPAT
					      " from the future %s%s",
					      old_db_pos,
					      ts2str_err(&new.ts),
					      --whines == 0
					      ? "; stop complaining"
					      : "");
			++expired_rcds;
			expired_cks += rcd_num_cks;
			continue;
		}


		expire_rcd = 1;		/* assume record will be deleted */
		obs_lvl = 0;
		split_ok = 1;		/* assume it cannot be flooded */
		nokeep_num_cks = 0;
		new_ck = new.cks;
		rcd_ck = rcd->cks;
		rcd_ck_lim = &rcd->cks[rcd_num_cks];
		for (prev_type = DCC_CK_INVALID;
		     rcd_ck < rcd_ck_lim;
		     prev_type = type, ++rcd_ck) {
			type = DB_CK_TYPE(rcd_ck);
			if (!DCC_CK_TYPE_DB_OK(type)) {
				dcc_error_msg("%s checksum at "L_HxPAT" in %s",
					      DB_TYPE2STR(type),
					      old_db_pos,
					      db_paths.prev.c);
				EXPIRE_BAIL();
			}

			/* A pointer of DB_PTR_BAD implies that dbclean
			 * or the system crashed before the cleaned database
			 * reached the disk and that we cannot trust any
			 * of the pointers and so must repair.
			 * A garbage pointer implies that the database is
			 * trash. */
			rcd_prev = DB_PTR_EX(rcd_ck->prev);
			if (rcd_prev == DB_PTR_NULL) {
				;
			} else if (DB_PTR_IS_BAD(rcd_prev, old_db_pos)) {
				if (whines > 0)
					dcc_error_msg("invalid link "L_HxPAT
						      " at "
						      L_HxPAT" in %s%s",
						      rcd_prev, old_db_pos,
						      db_paths.prev.c,
						      --whines == 0
						      ? "; stop complaining"
						      : "");
				if (clean_mode != REPAIR_MODE
				    || rcd_prev != DB_PTR_BAD)
					EXPIRE_BAIL();
			}

			if (type <= prev_type
			    && prev_type != DCC_CK_FLOD_PATH
			    && clean_mode != REPAIR_MODE) {
				dcc_error_msg("out of order %s"
					      " checksum at "L_HxPAT" in %s",
					      DB_TYPE2STR(type), old_db_pos,
					      db_paths.prev.c);
				EXPIRE_BAIL();
			}

			if (tgts_raw == DCC_TGTS_REP_ADJ) {
				if (!DCC_CK_IS_REP(grey_on, type)) {
					dcc_error_msg("discarding unauthorized"
						      " reputation adjustment"
						      " for %s at "L_HxPAT
						      " in %s",
						      DB_TYPE2STR(type),
						      old_db_pos,
						      db_paths.prev.c);
					++expired_cks;
					new.fgs_num_cks = (DB_NUM_CKS(&new)
							| DB_RCD_FG_TRIM);
					continue;
				}
				/* discard useless reputation scaling if the
				 * back-pointer reliably marks it useless */
				if (clean_mode != REPAIR_MODE
				    && DB_PTR_EX(rcd_ck->prev) == DB_PTR_NULL) {
					++expired_cks;
					continue;
				}
			}

			/* Silently discard junk from other servers,
			 * provided it is junk by default */
			if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type)
			    && DB_GLOBAL_NOKEEP(grey_on, type)
			    && type != DCC_CK_FLOD_PATH
			    && type != DCC_CK_SRVR_ID
			    && DB_RCD_ID(&new) != DCC_ID_WHITE) {
				++expired_cks;
				continue;
			}

			/* Keep paths except on old records or records that
			 * have been trimmed or compressed.
			 * Never remove paths from server-ID declarations. */
			if (type == DCC_CK_FLOD_PATH) {
				if (DB_RCD_TRIMMED(&new)
				    || DB_RCD_ID(&new) == DCC_ID_COMP)
					continue;
				/* forget line number on old whitelist entry */
				if (DB_RCD_ID(&new) == DCC_ID_WHITE)
					continue;
				rcd_ck2 = rcd_ck+1;
				for (;;) {
					type2 = DB_CK_TYPE(rcd_ck2);
					if (type2 == DCC_CK_SRVR_ID
					    || !ts_older_ts(&new.ts,
							&new_all_ts[type2])) {
					    /* keep this path since this report
					     * is a server-ID declaration
					     * or not old */
					    *new_ck = *rcd_ck;
					    ++new_ck;
					    ++new.fgs_num_cks;
					    ++nokeep_num_cks;
					    break;
					}
					if (++rcd_ck2 >= rcd_ck_lim) {
					    /* we are discarding this path */
					    new.fgs_num_cks = (DB_NUM_CKS(&new)
							| DB_RCD_FG_TRIM);
					    break;
					}
				}
				continue;
			}

			if (!ts_older_ts(&new.ts, &new_all_ts[type])) {
				/* This report is recent. However, junk
				 * doesn't make the report needed */
				if (DB_TEST_NOKEEP(db_parms.nokeep_cks, type)
				    && DB_RCD_ID(&new) != DCC_ID_WHITE) {
					++nokeep_num_cks;
				} else if (DB_CK_JUNK(rcd_ck)) {
					/* This checksum is obsolete.
					 * If it has the highest level of
					 * fuzziness, then it controls whether
					 * the whole report is needed,. */
					if (obs_lvl < db_ck_fuzziness[type]) {
					    obs_lvl = db_ck_fuzziness[type];
					    expire_rcd = 1;
					}
				} else {
					/* This checksum is not obsolete.
					 * If it is at least as fuzzy as any
					 * other checksum, then it can say
					 * the report is needed */
					if (obs_lvl <= db_ck_fuzziness[type]) {
					    obs_lvl = db_ck_fuzziness[type];
					    expire_rcd = 0;
					    split_ok = 0;   /* might flood it */
					}

					/* note 1st plausible delay and
					 * flooding positions */
					if (min_delay_pos == DB_PTR_NULL
					    && DB_RCD_DELAY(&new))
					    min_delay_pos = new_db_csize;
					if (min_confirm_pos == DB_PTR_NULL
					    && !DB_RCD_TRIMMED(&new))
					    min_confirm_pos = new_db_csize;
				}

			} else {
				/* This checksum is not recent,
				 * but it might not be old enough to expire.
				 *
				 * Throw away delete requests
				 * and other servers' useless checksums */
				if (tgts_raw == DCC_TGTS_DEL
				    || DB_TEST_NOKEEP(db_parms.nokeep_cks,
						      type)) {
					++expired_cks;
					new.fgs_num_cks = (DB_NUM_CKS(&new)
							| DB_RCD_FG_TRIM);
					continue;
				}
				/* Throw away old obsolete checksums
				 * and entire reports if the fuzziest
				 * checksum is obsolete.
				 * A checksum is obsolete if it was marked
				 * obsolete or if its total is spam
				 * or if should have
				 * been expired before.
				 * An old report of a less fuzzy but still
				 * common checksum that is not compressible
				 * with new reports can otherwise never
				 * expire. */
				if (DB_CK_JUNK(rcd_ck)
				    || (clean_mode != REPAIR_MODE
					&& ts_older_ts(&new.ts,
						       &ancient_ts[type]))) {
					if (obs_lvl < db_ck_fuzziness[type]) {
					    obs_lvl = db_ck_fuzziness[type];
					    expire_rcd = 1;
					}
					++expired_cks;
					new.fgs_num_cks = (DB_NUM_CKS(&new)
							| DB_RCD_FG_TRIM);
					continue;
				}

				/* old summaries are unneeded, because
				 * they have already been flooded.
				 * They do not contribute to local counts */
				if (DB_RCD_SUMRY(&new)
				    && ts_older_ts(&new.ts, &stale_ts[type]))
					continue;

				/* Discard this checksum if its ultimate total
				 * is low or ancient
				 * or if it reaches spam after this report.
				 * To determine the ultimate total, we must
				 * have a hash table to find the newest record,
				 * which contains the final total */
				if (clean_mode != REPAIR_MODE) {
					if (DCC_CK_IS_REP(grey_on, type)) {
					    /* use the answer for the previous
					     * reputation checksum if known */
					    if (rep_prev_db_pos == old_db_pos) {
						i = rep_prev_lead;
					    } else {
						rep_prev_db_pos = old_db_pos;
						i = ck_lead_rep(type,
							rcd_st->d.r, rcd_ck,
							rcd_ck_lim,
							hash_st, rcd2_st);
						rep_prev_lead = i;
					    }
					} else {
					    i = ck_lead(type,
							rcd_st->d.r, rcd_ck,
							hash_st, rcd2_st);
					}
					if (i < 0)
					    EXPIRE_BAIL();
					if (!i) {
					    ++expired_cks;
					    new.fgs_num_cks = (DB_NUM_CKS(&new)
							| DB_RCD_FG_TRIM);
					    continue;
					}
				}

				/* We did not delete this checksum and so
				 * it might be fuzzy enough to control whether
				 * the entire record should be expired */
				if (obs_lvl <= db_ck_fuzziness[type]) {
					expire_rcd = 0;
					split_ok = 1;
					/* If this is the fuzziest checksum we
					 * have seen, then preceding and so
					 * less fuzzy checksums are unneeded
					 * if they are old.
					 * Assume that checksums are ordered
					 * in the record by fuzziness. */
					if (obs_lvl < db_ck_fuzziness[type]) {
					    obs_lvl = db_ck_fuzziness[type];
					    if (obs_lvl != DCC_CK_FUZ_LVL_REP
						&& !grey_on)
						trim_old_fuz(&new, &new_ck);
					}
				}
			}

			/* Keep this checksum if we decide the whole report
			 * is needed, and unless we trim it in favor of a
			 * later checksum. */
			*new_ck = *rcd_ck;
			new_ck->prev = DB_PTR_CP(DB_PTR_BAD);

			++new_ck;
			++new.fgs_num_cks;
		}

		/* Occassionally let the daemon work with the old file.
		 * We are copying from the old database to the new dcc_db file.
		 * If we are repairing, we reading the old dcc_db file with
		 * read(); otherwise we have opened the database with
		 * db_open(DB_OPEN_RDONLY) and are using mmap().
		 */
		if (need_unlock >= UNLOCK_INTERVAL_USECS) {
			need_unlock = 0;
			if (!standalone && !db_unlock())
				EXPIRE_BAIL();
		}

		/* if none of its checksums are needed,
		 * then discard the entire record */
		if (expire_rcd) {
			expired_cks += DB_NUM_CKS(&new);
			++expired_rcds;
			continue;
		}

		new_num_cks = DB_NUM_CKS(&new);
		kept_cks += new_num_cks - nokeep_num_cks;

		/* Put the new record into the new file.
		 *
		 * If all of the record is recent, if it contains 1 checksum,
		 * or if all of its totals are the same, then simply add it.
		 *
		 * Otherwise, split it into records of identical counts
		 * to allow compression or combining with other records. */
		if (new_num_cks > 1
		    && (split_ok
			|| DB_RCD_ID(&new) == DCC_ID_COMP
			|| DB_RCD_TRIMMED(&new))) {
			for (;;) {
				/* skip the checksums that have the same total
				 * as the first checksum to leave them with the
				 * original new report */
				new_ck = new.cks;
				ck_tgts = DB_TGTS_CK(new_ck);
				for (i = 1; i < new_num_cks; ++i) {
					++new_ck;
					if (DB_TGTS_CK(new_ck) != ck_tgts)
					    break;
				}
				if (new_num_cks <= i)
					break;
				new_num_cks -= i;

				/* write the checksums with the common total */
				new.srvr_id = DCC_ID_COMP;
				new.fgs_num_cks = i;
				write_new_rcd(&new,
					      sizeof(new) - sizeof(new.cks)
					      + i*sizeof(new.cks[0]));

				/* handle the remaining checksums */
				new.fgs_num_cks = new_num_cks;
				memmove(&new.cks[0], &new.cks[i],
					new_num_cks*sizeof(new.cks[0]));
			}
		}

		/* write the rest (or all) of the new record */
		write_new_rcd(&new,
			      sizeof(new) - sizeof(new.cks)
			      + new_num_cks*sizeof(new.cks[0]));
	}
	emptied = cleardb;
copy_failed:;
	/* Act as if we copied the entire file on failure. */
	old_db_pos = old_db_csize;

	if (clean_mode != REPAIR_MODE) {
		free_db_st(rcd_st);
		free_db_st(hash_st);
		free_db_st(rcd2_st);
	}

	/* notice if there are no summarizable or floodable reports */
	if (min_delay_pos == DB_PTR_NULL)
		min_delay_pos = new_db_csize;
	if (min_confirm_pos == DB_PTR_NULL)
		min_confirm_pos = new_db_csize;

	/* do final adjustment of the flooding positions */
	adj_mmap();
	/* force flooding positions to be right if the system crashed with
	 * the flod.map file on the disk more up to date and so after the
	 * database file on the disk */
	for (mp = new_flod_mmaps.mmaps;
	     mp <= LAST(new_flod_mmaps.mmaps);
	     ++mp) {
		if (mp->rem_hostname[0] != '\0') {
			if (mp->confirm_pos > new_db_csize)
				mp->confirm_pos = new_db_csize;
			else if (mp->confirm_pos < min_confirm_pos)
				mp->confirm_pos = min_confirm_pos;
		}
	}
	if (new_flod_mmaps.delay_pos < min_delay_pos
	    || new_flod_mmaps.delay_pos > new_db_csize)
		new_flod_mmaps.delay_pos = min_delay_pos;

	/* We are finished with the old file.  */
	i = db_close(DB_CLOSE);

	write_new_hdr(emptied);

	report_progress(1, "  processed", "MBytes",
			old_db_pos, old_db_csize, 1024*1024);
	if (grey_on)
		quiet_trace_msg("expired %d records and %d checksums in %s",
				expired_rcds, expired_cks,
				db_paths.base.c);
	else
		quiet_trace_msg("expired %d records and %d checksums,"
				" obsoleted %d checksums in %s",
				expired_rcds, expired_cks, obs_rcds,
				db_paths.base.c);
	return i;
}



static void
copy_v5_ex_secs(DB_EX_SECS ex_secs, const DB_V5_EX_SECS v5_ex_secs)
{
	int i;

	for (i = 0; i < DCC_DIM_CKS; ++i) {
		ex_secs[i].all = v5_ex_secs[i].all;
		ex_secs[i].spam = v5_ex_secs[i].spam;
	}
}



/* copy the database copy while doing minimal expiring */
static u_char
copy_db(void)
{
#ifdef DB_VERSION5_STR
	static DB_VERSION_BUF old_version5 = DB_VERSION5_STR;
#endif
#ifdef DB_VERSION4_STR
	static DB_VERSION_BUF old_version4 = DB_VERSION4_STR;
#endif
#ifdef DB_VERSION3_STR
	static DB_VERSION_BUF old_version3 = DB_VERSION3_STR;
#endif
	union {
	    DB_HDR	hdr;
#ifdef DB_VERSION5_STR
	    DB_V5_PARMS	v5;
#endif
#ifdef DB_VERSION4_STR
	    DB_V4_PARMS	v4;
#endif
#ifdef DB_VERSION3_STR
	    DB_V3_PARMS v3;
#endif
	} old_db;
	struct timeval sn;

	/* do not lock the old database because the daemon must continue
	 * to answer requests */
	if (old_db_fd < 0) {
		old_db_fd = open(db_paths.base.c, O_RDONLY, 0);
		if (old_db_fd == -1)
			dcc_logbad(EX_IOERR, "open(%s): %s",
				   db_paths.prev_msg, ERROR_STR());
	}

	if (!read_db_hdr(&dcc_emsg, &old_db.hdr, old_db_fd, db_paths.prev_msg))
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);
	if (!memcmp(old_db.hdr.p.version, db_version_buf,
		    sizeof(old_db.hdr.p.version))) {
		prev_db_parms = old_db.hdr.p;
#ifdef DB_VERSION5_STR
	} else if (!memcmp(old_db.v5.version, old_version5,
			   sizeof(old_db.v5.version))) {
		memset(&prev_db_parms, 0,
		       sizeof(prev_db_parms));
		memcpy(prev_db_parms.version, db_version_buf,
		       sizeof(prev_db_parms.version));

		prev_db_parms.db_csize = old_db.v5.db_csize;
		prev_db_parms.blksize = old_db.v5.blksize;
		prev_db_parms.sn = old_db.v5.sn;
		prev_db_parms.cleared = old_db.v5.cleared;
		prev_db_parms.cleaned = old_db.v5.cleaned;
		prev_db_parms.cleaned_cron = old_db.v5.cleaned_cron;
		memcpy(prev_db_parms.ex_spam, old_db.v5.ex_spam,
		       sizeof(prev_db_parms.ex_spam));
		memcpy(prev_db_parms.ex_all, old_db.v5.ex_spam,
		       sizeof(prev_db_parms.ex_all));
		copy_v5_ex_secs(prev_db_parms.ex_secs, old_db.v5.ex_secs);
		prev_db_parms.nokeep_cks = old_db.v5.nokeep_cks;
		prev_db_parms.flags = old_db.v5.flags;
		prev_db_parms.old_db_csize = old_db.v5.old_db_csize;
		prev_db_parms.db_added = old_db.v5.db_added;
		prev_db_parms.hash_used = old_db.v5.hash_used;
		prev_db_parms.old_hash_used = old_db.v5.old_hash_used;
		prev_db_parms.hash_added = old_db.v5.hash_added;
		prev_db_parms.rate_secs = old_db.v5.rate_secs;
		prev_db_parms.last_rate_sec = old_db.v5.last_rate_sec;
		prev_db_parms.old_kept_cks = old_db.v5.old_kept_cks;
		prev_db_parms.min_confirm_pos = old_db.v5.min_confirm_pos;
		prev_db_parms.failsafe_cleanings = old_db.v5.failsafe_cleanings;
#endif
#ifdef DB_VERSION4_STR
	} else if (!memcmp(old_db.v4.version, old_version4,
			   sizeof(old_db.v4.version))) {
		memset(&prev_db_parms, 0, sizeof(prev_db_parms));
		memcpy(prev_db_parms.version, db_version_buf,
		       sizeof(prev_db_parms.version));

		prev_db_parms.db_csize = old_db.v4.db_csize;
		prev_db_parms.blksize = old_db.v4.blksize;
		prev_db_parms.sn = old_db.v4.sn;
		prev_db_parms.cleared = old_db.v4.cleared;
		prev_db_parms.cleaned = old_db.v4.cleaned;
		prev_db_parms.cleaned_cron = old_db.v4.cleaned_cron;
		memcpy(prev_db_parms.ex_spam, old_db.v4.ex_spam,
		       sizeof(prev_db_parms.ex_spam));
		memcpy(prev_db_parms.ex_all, old_db.v4.ex_spam,
		       sizeof(prev_db_parms.ex_all));
		copy_v5_ex_secs(prev_db_parms.ex_secs, old_db.v4.ex_secs);
		prev_db_parms.nokeep_cks = old_db.v4.nokeep_cks;
		prev_db_parms.flags = old_db.v4.flags;
		prev_db_parms.old_db_csize = old_db.v4.old_db_csize;
		prev_db_parms.db_added = old_db.v4.db_added;
		prev_db_parms.hash_used = old_db.v4.hash_used;
		prev_db_parms.old_hash_used = old_db.v4.old_hash_used;
		prev_db_parms.hash_added = old_db.v4.hash_added;
		prev_db_parms.rate_secs = old_db.v4.rate_secs;
		prev_db_parms.last_rate_sec = old_db.v4.last_rate_sec;
		prev_db_parms.old_kept_cks = old_db.v4.old_kept_cks;
#endif
#ifdef DB_VERSION3_STR
	} else if (!memcmp(old_db.v3.version, old_version3,
			   sizeof(old_db.v3.version))) {
		memset(&prev_db_parms, 0, sizeof(prev_db_parms));
		memcpy(prev_db_parms.version, db_version_buf,
		       sizeof(prev_db_parms.version));

		prev_db_parms.db_csize = old_db.v3.db_csize;
		prev_db_parms.blksize = old_db.v3.blksize;
		prev_db_parms.sn = old_db.v3.sn;
		memcpy(prev_db_parms.ex_spam, old_db.v3.ex_spam,
		       sizeof(prev_db_parms.ex_spam));
		copy_v5_ex_secs(prev_db_parms.ex_secs, old_db.v3.ex_secs);
		prev_db_parms.nokeep_cks = old_db.v3.nokeep_cks;
		if (old_db.v3.flags & DB_PARM_V3_FG_GREY)
			prev_db_parms.flags |= DB_PARM_FG_GREY;
		if (old_db.v3.flags & DB_PARM_V3_FG_NEED_RWD)
			prev_db_parms.flags |= DB_PARM_FG_NEED_RWD;
		prev_db_parms.old_db_csize = old_db.v3.old_db_csize;
		prev_db_parms.db_added = old_db.v3.db_added;
		prev_db_parms.hash_used = old_db.v3.hash_used;
		prev_db_parms.old_hash_used = old_db.v3.old_hash_used;
		prev_db_parms.hash_added = old_db.v3.hash_added;
		prev_db_parms.rate_secs = old_db.v3.rate_secs;
		prev_db_parms.last_rate_sec = old_db.v3.last_rate_sec;
		prev_db_parms.old_kept_cks = old_db.v3.old_kept_cks;

		ts2timeval(&sn, &prev_db_parms.sn);
		prev_db_parms.cleared = sn.tv_sec;
		prev_db_parms.cleaned = sn.tv_sec;
		if (old_db.v3.flags & DB_PARM_V3_FG_SELF_CLEAN2) {
			prev_db_parms.cleared -= 2*24*60*60;
			prev_db_parms.cleaned -= 24*60*60;
		}
#endif
	} else {
		dcc_logbad(EX_IOERR, "%s has the wrong magic \"%.*s\"",
			   db_paths.prev_msg,
			   ISZ(DB_VERSION_BUF), old_db.hdr.p.version);
	}

	db_parms.sn = prev_db_parms.sn;
	db_parms.cleared = prev_db_parms.cleared;
	db_parms.cleaned = prev_db_parms.cleaned;
	db_parms.cleaned_cron = prev_db_parms.cleaned_cron;
	memcpy(db_parms.ex_all, prev_db_parms.ex_all,
	       sizeof(db_parms.ex_all));
	memcpy(db_parms.ex_spam, prev_db_parms.ex_spam,
	       sizeof(db_parms.ex_spam));
	memcpy(&db_parms.ex_secs, &prev_db_parms.ex_secs,
	       sizeof(db_parms.ex_secs));
	db_parms.nokeep_cks = prev_db_parms.nokeep_cks;
	db_parms.flags = prev_db_parms.flags;

	set_db_tholds(db_parms.nokeep_cks);

	return expire(prev_db_parms.db_csize);
}



/* Copy any records from the old file to the new file that were
 * added to the old file while we were creating the new file. */
static u_char
catchup(DCC_EMSG *emsg)
{
	DB_HDR old_db_hdr;
	DB_RCD rcd;
	int rcd_len;
	u_char result;
	int count, old_count;

	/* Because dccd knows dbclean is running, dccd will have been
	 * keeping its header block more accurate than usual. */
	result = 1;
	count = 0;
	do {
		old_count = count;
		if (!read_db_hdr(&dcc_emsg, &old_db_hdr,
				old_db_fd, db_paths.prev.c)) {
			emsg = 0;
			result = 0;
			break;
		}
		if (old_db_hdr.p.db_csize < old_db_pos) {
			dcc_error_msg("%s mysteriously truncated",
				      db_paths.prev.c);
			result = 0;
			break;
		}
		if ((off_t)old_db_pos != lseek(old_db_fd, old_db_pos,
					       SEEK_SET)) {
			dcc_pemsg(EX_IOERR, emsg, "lseek(%s, "L_HxPAT"): %s",
				  db_paths.prev.c, old_db_pos, ERROR_STR());
			emsg = 0;
			result = 0;
			break;
		}
		read_rcd_invalidate(0);
		while (old_db_pos < old_db_hdr.p.db_csize) {
			rcd_len = read_rcd(emsg, &rcd, old_db_fd, old_db_pos,
					   db_paths.prev.c);
			if (rcd_len <= 0) {
				if (rcd_len == 0)
					dcc_pemsg(EX_IOERR, emsg,
						  "premature EOF in %s"
						  " at "L_HxPAT
						  " instead of "L_HxPAT,
						  db_paths.prev.c,
						  old_db_pos,
						  old_db_hdr.p.db_csize);
				emsg = 0;
				result = 0;
				break;
			}
			/* If something bad happens, we may not be able to
			 * go back to the old file.  Carry on to get as much
			 * data as we can although we know the dccd daemon
			 * may croak when we release it */
			if (!db_add_rcd(emsg, &rcd, 0)) {
				emsg = 0;
				result = 0;
				break;
			}
			old_db_pos += rcd_len;
			++count;
		}
	} while (result && old_count != count);

	if (count > 0 && db_debug >= 1)
		quiet_trace_msg("copied %d late reports%s",
				count, result ? "" : " with problems");

	if (!dbclean_flush(emsg))
		result = 0;

	return result;
}



/* try to compress an old report with a predecessor */
static void
compress_old(DB_ST *rcd_st, DB_ST *rcd2_st)
{
	DB_PTR prev;
	DB_RCD *cur_rcd, *prev_rcd;
	DB_RCD_CK *cur_ck, *prev_ck;
	int cur_ck_num, prev_ck_num;
	DCC_TGTS cur_tgts, prev_tgts;
	DCC_CK_TYPES cur_type, prev_type;
	time_t cur_secs, prev_secs;
	int retries = 0;

	cur_rcd = rcd_st->d.r;

	/* can't compress with whitelisting, reputation adjustment
	 * or other special values */
	cur_tgts = DB_TGTS_RCD_RAW(cur_rcd);
	if (cur_tgts > DCC_TGTS_TOO_MANY)
		return;

	cur_secs = ts2secs(&cur_rcd->ts);

	/* Before spending the time to map a preceding checksum,
	 * find at least one checksum worth keeping and that might
	 * be combined or compressed with its predecessor. */
	prev = DCC_CK_INVALID;
	for (cur_ck_num = DB_NUM_CKS(cur_rcd), cur_ck = cur_rcd->cks;
	     cur_ck_num != 0;
	     --cur_ck_num, ++cur_ck) {
		if (DB_CK_JUNK(cur_ck))
			continue;
		cur_type = DB_CK_TYPE(cur_ck);
		/* cannot compressed server-ID assertions because that
		 * changes the server-ID */
		if (cur_type == DCC_CK_SRVR_ID)
			return;
		if (DB_TEST_NOKEEP(db_parms.nokeep_cks, cur_type))
			continue;
		/* all of the checksums in the current record must be old */
		if (cur_secs >= new_all_secs[cur_type])
			return;

		/* note the first, probably least fuzzy candidate */
		if (prev == DB_PTR_NULL)
			prev = DB_PTR_EX(cur_ck->prev);
	}

again:;
	if (prev == DB_PTR_NULL)
		return;


	/* Check that the current and previous records are old
	 * and contain the same useful checksums. */
	if (!db_map_rcd(&dcc_emsg, rcd2_st, prev, 0))
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);
	prev_rcd = rcd2_st->d.r;
	prev_secs = 0;
	prev_ck_num = DB_NUM_CKS(prev_rcd);
	prev_ck = prev_rcd->cks;
	cur_ck_num = DB_NUM_CKS(cur_rcd);
	cur_ck = cur_rcd->cks;
	for (;;) {
		/* we must run out of checksums in the two reports at the
		 * same time */
		if (prev_ck_num == 0 || cur_ck_num == 0) {
			if (prev_ck_num == cur_ck_num)
				break;
			return;
		}

		/* ignore paths and other junk */
		if (DB_CK_JUNK(prev_ck)) {
			--prev_ck_num;
			++prev_ck;
			continue;
		}
		prev_type = DB_CK_TYPE(prev_ck);
		if (DB_TEST_NOKEEP(db_parms.nokeep_cks, prev_type)) {
			--prev_ck_num;
			++prev_ck;
			continue;
		}
		if (DB_CK_JUNK(cur_ck)) {
			--cur_ck_num;
			++cur_ck;
			continue;
		}
		cur_type = DB_CK_TYPE(cur_ck);
		if (DB_TEST_NOKEEP(db_parms.nokeep_cks, cur_type)) {
			--cur_ck_num;
			++cur_ck;
			continue;
		}

		/* because the checksums are ordered, we know to
		 * give up at the first mismatch */
		if (cur_type != prev_type
		    || memcmp(&cur_ck->sum, &prev_ck->sum, sizeof(cur_ck->sum)))
			return;

		if (prev_secs == 0)
			prev_secs = ts2secs(&prev_rcd->ts);
		if (prev_secs >= new_all_secs[cur_type]) {
			/* This previous record is new enough to be valuable
			 * and so the current record is out of order.
			 * It must have been delayed among the floods.
			 * Try to compress it with a preceding record. */
			if (++retries > 4)
				return;
			prev = DB_PTR_EX(prev_ck->prev);
			goto again;
		}

		/* Expirations change reputations, so do not compress
		 * reputation reports from different eras.
		 * Check only the first of the 1 or 2 reputation checksums
		 * in the two records, because they share the timestamps of
		 * their records.
		 * Start 1-week eras at midnight Sunday in phase with the
		 * weekly variation in spam. */
		if (DCC_CK_IS_REP(grey_on, cur_type)
		    && ((cur_secs + DCC_EPOCH_WEEK) / (7*24*60*60)
			!= (prev_secs + DCC_EPOCH_WEEK) / (7*24*60*60))) {
			if (cur_secs > prev_secs)
				return;
			/* Start again with preceding record if
			 * this pair is out of order and cannot
			 * be compressed.  This can be necessary around
			 * midnight at the ends of eras. */
			if (++retries > 4)
				return;
			prev = DB_PTR_EX(prev_ck->prev);
			goto again;
		}

		--prev_ck_num;
		++prev_ck;
		--cur_ck_num;
		++cur_ck;
	}

	/* The current and previous records are compatible.
	 * Add the count of the previous record to the current record
	 * and mark the previous record useless.
	 * The individual totals in the current record are already correct,
	 * so postpone worrying about the deleted record. */
	if (cur_tgts < DCC_TGTS_TOO_MANY) {
		prev_tgts = DB_TGTS_RCD(prev_rcd);
		/* can't compress with whitelisting, reputation adjustment
		 * or other special values */
		if (prev_tgts > DCC_TGTS_TOO_MANY
		    || prev_tgts == 0)
			return;
		if (prev_tgts == DCC_TGTS_TOO_MANY) {
			cur_tgts = DCC_TGTS_TOO_MANY;
		} else {
			cur_tgts += prev_tgts;
			if (cur_tgts > DCC_TGTS_TOO_MANY)
				cur_tgts = DCC_TGTS_TOO_MANY;
		}
		DB_TGTS_RCD_SET(cur_rcd, cur_tgts);
	}

	/* Mark the previous record to be deleted next time. */
	DB_TGTS_RCD_SET(prev_rcd, 0);
	DIRTY_RCD(rcd2_st, 0);

	cur_rcd->srvr_id = DCC_ID_COMP;
	cur_rcd->fgs_num_cks = DB_NUM_CKS(cur_rcd);
	/* use the newest timestamp */
	if (ts_older_ts(&cur_rcd->ts, &prev_rcd->ts))
		cur_rcd->ts = prev_rcd->ts;
	DIRTY_RCD(rcd_st, 0);

	++comp_rcds;
}



/* write a parsed whitelist checksum
 *	This does not detect duplicate entries */
static int
white_write(DCC_EMSG *emsg, WF *wf,
	    DCC_CK_TYPES type, DCC_SUM *sum, DCC_TGTS tgts)
{
	DB_RCD rcd;
	int rcd_len;
	char buf[30];
	DCC_FNM_LNO_BUF fnm_buf;

	/* ignore checksums that clients are never supposed to send
	 * to the server or for some other reason cannot be whitelisted */
	switch (type) {
	case DCC_CK_INVALID:
	case DCC_CK_ENV_TO:
	case DCC_CK_G_MSG_R_TOTAL:
	case DCC_CK_G_TRIPLE_R_BULK:
	case DCC_CK_SRVR_ID:
		dcc_pemsg(EX_DATAERR, emsg,
			  "%s checksum cannot be used%s",
			  type2str_err(type, 0, 0, grey_on),
			  wf_fnm_lno(&fnm_buf, wf));
		return 0;

	case DCC_CK_IP:
	case DCC_CK_ENV_FROM:
	case DCC_CK_FROM:
	case DCC_CK_MESSAGE_ID:
	case DCC_CK_RECEIVED:
	case DCC_CK_SUB:
	case DCC_CK_BODY:
	case DCC_CK_FUZ1:
	case DCC_CK_FUZ2:
		break;			/* these are ok */
	}

	if (tgts == DCC_TGTS_OK_MX
	    || tgts == DCC_TGTS_OK_MXDCC) {
		tgts = DCC_TGTS_OK;
	} else if (tgts == DCC_TGTS_SUBMIT_CLIENT) {
		if (db_debug > 1)
			quiet_trace_msg("\"%s\" ignored%s",
					tgts2str(buf, sizeof(buf), tgts, 0),
					wf_fnm_lno(&fnm_buf, wf));
		return 1;
	}

	/* Greylist whitelist entries cannot involve blacklisting.
	 * They use DCC_TGTS_GREY_WHITE to signal whitelisting */
	if (grey_on) {
		/* ignore anything except whitelisting */
		if (tgts != DCC_TGTS_OK) {
			dcc_pemsg(EX_DATAERR, emsg, "\"%s\" ignored%s",
				  tgts2str(buf, sizeof(buf), tgts, 0),
				  wf_fnm_lno(&fnm_buf, wf));
			return 0;
		}
		tgts = DCC_TGTS_GREY_WHITE;
	}

	memset(&rcd, 0, sizeof(rcd));
	timeval2ts(&rcd.ts, &clean_start, 0);
	rcd.srvr_id = DCC_ID_WHITE;
	DB_TGTS_RCD_SET(&rcd, tgts);

	rcd.cks[0].type_fgs = DCC_CK_FLOD_PATH;
	memcpy(rcd.cks[0].sum.b, &wf->lno, sizeof(wf->lno));
	rcd.cks[0].sum.b[sizeof(wf->lno)] = wf->fno;

	rcd.cks[1].type_fgs = type;
	rcd.cks[1].sum = *sum;

	rcd_len = sizeof(rcd) - sizeof(rcd.cks) + 2*sizeof(rcd.cks[0]);
	rcd.fgs_num_cks = 2;

	write_new_rcd(&rcd, rcd_len);

	++white_cks;
	return 1;
}



#define MAX_IP_RANGE_LEN    (1<<16)	/* fix dcc.man if this changes */

static int				/* 1=ok,  0=bad entry, -1=fatal */
white_range(DCC_EMSG *emsg, WF *wf,
	    const DCC_IP_RANGE *range, DCC_TGTS tgts)
{
	u_int range_len;
	struct in6_addr addr;
	DCC_SUM sum;
	DCC_FNM_LNO_BUF fnm_buf;
	int result;

	/* Allow only class-B sized blocks of addresses,
	 * because server whitelist entries for an address block
	 * require one checksum per IP address in the block.
	 * A line in a server whitelist file specifying a
	 * class-B or MAX_IP_RANGE_LEN address block requires adding
	 * 65,536 checksums to the server database.
	 * Instead, use client whiteclnt block entries. */

	range_len = len_ip_range(range);
	if (range_len > MAX_IP_RANGE_LEN) {
		dcc_pemsg(EX_NOHOST, emsg, "address block too large%s",
			  wf_fnm_lno(&fnm_buf, wf));
		return 0;
	}

	result = 0;
	addr = range->lo;
	while (range_len-- != 0) {
		ipv6tock(&sum, &addr);
		result = white_write(emsg, wf, DCC_CK_IP, &sum, tgts);
		if (result <= 0)
			return result;
		inc_ip6(&addr);
	}
	return 1;
}



/* Add the whitelist of certified non-spam and non-spammers
 *	and otherwise start the database */
static void
parse_white(void)
{
	DCC_CK_TYPES type;
	int white_fd;

	white_cks = 0;

	if (!keep_white) {
		memset(&dbclean_white_tbl, 0,sizeof(dbclean_white_tbl));
		for (type = 0; type <= DCC_CK_TYPE_LAST; ++type)
			dbclean_white_tbl.hdr.tholds_rej.t[type] = THOLD_UNSET;
		wf_init(&dbclean_wf, 0);
		dcc_fnm2rel_good(&dbclean_wf.ascii_nm,
				 WHITELIST_NM(grey_on), 0);
		dbclean_wf.wtbl = &dbclean_white_tbl;
		white_fd = open(dbclean_wf.ascii_nm.c, O_RDONLY, 0);
		if (white_fd < 0) {
			/* worry only if the file exists but can't be used */
			if (errno != ENOENT) {
				dcc_error_msg("open(%s): %s",
					      dbclean_wf.ascii_nm.c,
					      ERROR_STR());
				keep_white = 1;
			}
		} else {
			if (0 > parse_whitefile(0, &dbclean_wf, white_fd,
						white_write, white_range))
				keep_white = 1;
			if (0 > close(white_fd))
				dcc_error_msg("close(%s): %s",
					      dbclean_wf.ascii_nm.c,
					      ERROR_STR());
		}
	}
	if (keep_white) {
		/* If the whitelist was bad, purge the new database of
		 * the bad new whitelist.  We will use the existing
		 * whitelist */
		write_new_flush();
		new_db_csize = DB_PTR_BASE;
		if (0 > ftruncate(new_db_fd, DB_PTR_BASE))
			dcc_logbad(EX_IOERR, "truncate(%s,%d): %s",
				   db_paths.new.c, DB_PTR_BASE, ERROR_STR());
		new_db_fsize = DB_PTR_BASE;
		white_cks = 0;
	}

	/* update the counts in the database file */
	write_new_hdr(1);
}



/* check for conflicts in the whitelist file */
static void
check_white(const DB_RCD *rcd, DB_ST *rcd2_st)
{
	static int msgs;
	static int prev_lno1, prev_lno2;
	static int prev_fno1, prev_fno2;
	const DB_RCD_CK *rcd_ck, *prev_ck;
	int lno1, lno2;
	int fno1, fno2;
	DCC_TGTS tgts1, tgts2;
	char tgts1_buf[30], tgts2_buf[30];
	const char *fname1, *fname2;
	DCC_CK_TYPES type;
	DB_PTR prev;

	/* don't check if we have already complained enough */
	if (msgs > 20)
		return;

	rcd_ck = rcd->cks;

	/* it is pointless without line numbers, which are lacking only
	 * if we saved the old whitelist entries because the file is
	 * broken */
	if (DB_NUM_CKS(rcd) != 2
	    || DB_CK_TYPE(rcd_ck) != DCC_CK_FLOD_PATH)
		return;

	/* conflict is impossible with a single line */
	++rcd_ck;
	prev = DB_PTR_EX(rcd_ck->prev);
	if (prev == DB_PTR_NULL)
		return;

	type = DB_CK_TYPE(rcd_ck);
	prev_ck = db_map_rcd_ck(&dcc_emsg, rcd2_st, prev, type);
	if (!prev_ck)
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);

	tgts1 = DB_TGTS_RCD(rcd2_st->d.r);
	tgts2 = DB_TGTS_RCD(rcd);
	if (tgts1 == tgts2)
		return;			/* no conflict */

	memcpy(&lno1, rcd2_st->d.r->cks[0].sum.b, sizeof(lno1));
	fno1 = rcd2_st->d.r->cks[0].sum.b[sizeof(lno1)];
	memcpy(&lno2, rcd->cks[0].sum.b, sizeof(lno2));
	fno2 = rcd->cks[0].sum.b[sizeof(lno2)];

	if (lno1 == prev_lno1 && fno1 == prev_fno1
	    && lno2 == prev_lno2 && fno2 == prev_fno2)
		return;

	fname1 = wf_fnm(&dbclean_wf, fno1);
	fname2 = wf_fnm(&dbclean_wf, fno2);
	if (fname1 == fname2) {
		fname1 = "";
	} else {
		fname1 = dcc_path2fnm(fname1);
	}
	dcc_error_msg("\"%s\" in line %d%s%s conflicts with \"%s\""
		      " in line %d of %s",
		      tgts2str(tgts1_buf, sizeof(tgts1_buf),
			       tgts1, grey_on),
		      lno1,
		      *fname1 != '\0' ? " of " : "", fname1,
		      tgts2str(tgts2_buf, sizeof(tgts2_buf),
			       tgts2, grey_on),
		      lno2,
		      fname2);
	++msgs;
	prev_lno1 = lno1;
	prev_fno1 = fno1;
	prev_lno2 = lno2;
	prev_fno2 = fno2;
}



/* rebuild the hash table and the totals and links within the database file
 *	finish with the file locked */
static void
build_hash(void)
{
	DB_ST *rcd_st, *rcd2_st;
	DB_PTR rcd_pos;
	int rcd_len;
	int rcd_cks, rcd_sums;
	DB_PTR rcds, sums;
	const DB_RCD_CK *rcd_ck;
	DB_HADDR guess_hash_len;
	double db_rate, hash_ratio;

	if (!db_buf_init(0, new_db_blksize))
		dcc_logbad(EX_SOFTWARE, "bad new blksize");

	if (new_hash_len == 0) {
		/* Try to choose a hash table size now so that when it
		 * is next time to rebuild after 24 hours of incoming
		 * checksums, the alpha or load factor will still be 0.9.
		 * We probably ran 24 hours ago, so the old hash size
		 * is an estimate of the size tomorrow.
		 *
		 * Guess the number of distinct checksums added
		 * tomorrow based on the current average rate */

		db_rate = db_add_rate(&new_db_parms, 1, 0);
		if (db_rate > 0.0) {
			/* Increase the average rate by 10% to account
			 * for the 30% decrease often seen on weekends. */
			guess_hash_len = db_rate * 1.1 * 24*60*60;

			/* predict # of distinct checksums in current data */
			hash_ratio = prev_db_parms.old_kept_cks;
			if (hash_ratio == 0.0) {
				hash_ratio = 1.0;
			} else {
				hash_ratio = (ADJ_HLEN(prev_db_parms
						       .old_hash_used)
					      / hash_ratio);
				if (hash_ratio > 1.0 || hash_ratio < 0.3)
					hash_ratio = 1.0;
			}
			guess_hash_len += (kept_cks * hash_ratio) + white_cks;

			if (db_debug)
				quiet_trace_msg("old hash size %d"
						"  predict %d from db_rate %.1f"
						"  hash_ratio %.1f=%d/%d"
						"  kept %d  white %d",
						prev_db_hash_used,
						guess_hash_len,
						db_rate, hash_ratio,
						ADJ_HLEN(prev_db_parms
							.old_hash_used),
						prev_db_parms.old_kept_cks,
						kept_cks, white_cks);

		} else {
			/* guess if we do not have a good measure
			 * of the recent rate */
			guess_hash_len = kept_cks+white_cks;
			guess_hash_len += guess_hash_len/5;
		}

		/* Double the hash size if it was exhausted */
		new_hash_len = prev_db_hash_used;
		if (new_hash_len <= prev_db_parms.old_hash_used)
			new_hash_len = 2 * prev_db_parms.old_hash_used;

		if (new_hash_len < guess_hash_len)
			new_hash_len = guess_hash_len;

		/* load factor 0.9 */
		new_hash_len += new_hash_len/10 + MIN_HASH_ENTRIES;

		if (new_hash_len > db_max_hash_entries) {
			quiet_trace_msg("default hash size %d"
					" > maximum %d entries",
					new_hash_len, db_max_hash_entries);
			new_hash_len = db_max_hash_entries;
		}

		if (new_hash_len < MIN_HASH_ENTRIES)
			new_hash_len = MIN_HASH_ENTRIES;
	}

	/* Open and lock the new database */
	unlink_whine(0, hash_paths.new.c, 1);
	new_hash_created = 1;
	if (!db_open(&dcc_emsg, -1, db_paths.new.c,
		     hash_paths.new.c, new_hash_len,
		     DB_OPEN_LOCK_NOWAIT | db_mode)) {
		dcc_error_msg("%s", dcc_emsg.c);
		dcc_logbad(emsg_ex_code(&dcc_emsg),
			   "could not start database %s", db_paths.new.c);
	}

	/* guess which checksums we will keep so that we can count them */
	if (prev_db_parms.nokeep_cks != 0)
		db_parms.nokeep_cks = prev_db_parms.nokeep_cks;

	/* add every record in the database file to the hash table and
	 * fix its accumulated counts and reverse links */
	comp_rcds = 0;
	sums = 0;
	rcds = 0;
	report_progress_init();

	rcd_st = GET_DB_ST();
	rcd2_st = GET_DB_ST();

	for (rcd_pos = DB_PTR_BASE; rcd_pos < db_csize; rcd_pos += rcd_len) {
		if (--progress_rpt_cnt <= 0) {
			report_progress(0, "  hash rebuilt", "checksums",
					sums, kept_cks, 1);
		}

		if (!db_map_rcd(&dcc_emsg, rcd_st, rcd_pos, &rcd_len)) {
			dcc_error_msg("%s", dcc_emsg.c);
			dcc_logbad(emsg_ex_code(&dcc_emsg),
				   "hash build failed reading"
				   " record at "L_HxPAT,
				   rcd_pos);
		}

		/* skip end of block padding */
		if (rcd_st->d.r->fgs_num_cks == 0)
			continue;

		++rcds;

		/* count the checksums we'll link in this record */
		rcd_cks = DB_NUM_CKS(rcd_st->d.r);
		rcd_sums = 0;
		for (rcd_ck = rcd_st->d.r->cks;
		     rcd_ck < &rcd_st->d.r->cks[rcd_cks];
		     ++rcd_ck) {
			if (!DB_TEST_NOKEEP(db_parms.nokeep_cks,
					    DB_CK_TYPE(rcd_ck)))
				++rcd_sums;
		}
		sums += rcd_sums;

		if (!db_link_rcd(&dcc_emsg, rcd_st)) {
			dcc_logbad(emsg_ex_code(&dcc_emsg),
				   "relinking record at "L_HxPAT": %s",
				   rcd_pos, dcc_emsg.c);
		}
		DIRTY_RCD(rcd_st, 0);

		/* check for conflicts in the whitelist file */
		if (DB_RCD_ID(rcd_st->d.r) == DCC_ID_WHITE)
			check_white(rcd_st->d.r, rcd2_st);
		else
			compress_old(rcd_st, rcd2_st);
	}

	free_db_st(rcd_st);
	free_db_st(rcd2_st);

	report_progress(1, "  hash rebuilt", "checksums", sums, kept_cks, 1);

	db_parms.old_hash_used = db_hash_used;
	db_parms.old_kept_cks = kept_cks;
	db_parms.hash_used = db_hash_used;
	db_parms.old_db_csize = db_csize;
	if (!db_flush_parms(&dcc_emsg))
		dcc_logbad(emsg_ex_code(&dcc_emsg), "%s", dcc_emsg.c);

	quiet_trace_msg("hashed "L_DPAT" records containing "L_DPAT" checksums,"
			" compressed %d records", rcds, sums, comp_rcds);

	quiet_trace_msg("%d hash entries total, %d or %d%% used",
			ADJ_HLEN(db_hash_len),
			ADJ_HLEN(db_hash_used),
			(int)((ADJ_HLEN(db_hash_used)*100.0)
			      / ADJ_HLEN(db_hash_len)));
}



/* use a large buffer to encourage the file system to avoid fragmentation */
static union {
    u_char  c[DB_MIN_MIN_MBYTE*1024*1024];
    DB_HDR  hdr;
} write_new_db_buf;
static u_int write_new_db_buflen = 0;
static DB_PTR write_new_base;

static void
write_new_flush(void)
{
	int i;

	if (write_new_db_buflen != 0) {
		if (write_new_base != (DB_PTR)lseek(new_db_fd, write_new_base,
						    SEEK_SET)) {
			dcc_logbad(EX_IOERR, "lseek(%s, 0): %s",
				   db_paths.new.c, ERROR_STR());
		}

		i = write(new_db_fd, &write_new_db_buf, write_new_db_buflen);
		if ((DB_PTR)i != write_new_db_buflen) {
			if (i < 0)
				dcc_logbad(EX_IOERR,
					   "write(%s): %s",
					   db_paths.new.c, ERROR_STR());
			else
				dcc_logbad(EX_IOERR,
					   "write(%s)=%d instead of %d",
					   db_paths.new.c, i,
					   write_new_db_buflen);
		}
		if (new_db_fsize < write_new_base+(DB_PTR)i)
			new_db_fsize = write_new_base+i;
	}

	write_new_base = new_db_csize;
	write_new_db_buflen = 0;
}


static void
write_new_buf(const void *buf, int buflen)
{
	if (write_new_db_buflen + buflen > ISZ(write_new_db_buf))
		write_new_flush();
	memcpy(&write_new_db_buf.c[write_new_db_buflen], buf, buflen);
	write_new_db_buflen += buflen;
}



/* add a record to the new file */
static void
write_new_rcd(const void *buf, int buflen)
{
	DB_PTR new_blk_num;
	int pad, i;

	/* pad accross block boundaries */
	new_blk_num = DB_PTR2BLK_NUM(new_db_csize + buflen, new_db_blksize);
	if (new_blk_num != DB_PTR2BLK_NUM(new_db_csize, new_db_blksize)) {
		pad = new_blk_num*new_db_blksize - new_db_csize;
		pad = (((pad + DB_RCD_HDR_LEN-1) / DB_RCD_HDR_LEN)
		       * DB_RCD_HDR_LEN);
		do {
			i = sizeof(zero_rcd);
			if (i > pad)
				i = pad;
			write_new_buf(zero_rcd, i);
			pad -= i;
			new_db_csize += i;
		} while (pad != 0);
	}

	write_new_buf(buf, buflen);
	new_db_csize += buflen;
}



/* write the magic string at the head of the database file */
static void
write_new_hdr(u_char emptied)
{
	DB_HDR *new;
	time_t new_rate_secs;
	DCC_CK_TYPES type;
	int i;

	write_new_flush();

	memset(&write_new_db_buf, 0, sizeof(write_new_db_buf));
	write_new_base = 0;
	if (new_db_fsize > ISZ(DB_HDR)
	    || new_db_blksize == 0) {
		write_new_db_buflen = sizeof(DB_HDR);
	} else {
		write_new_db_buflen = new_db_blksize;
		if (write_new_db_buflen > ISZ(write_new_db_buf))
			write_new_db_buflen = ISZ(write_new_db_buf);
	}

	new = &write_new_db_buf.hdr;
	memset(new, 0, sizeof(*new));
	memcpy(new->p.version, db_version_buf, sizeof(new->p.version));

	timeval2ts(&new->p.sn, &clean_start, 0);
	if (emptied) {
		new->p.cleared = clean_start.tv_sec;
	} else {
		if (TIME_T(prev_db_parms.cleared) < clean_start.tv_sec
		    && prev_db_parms.cleared >= 30*365*24*60*60) {
			/* after 2000 and before now */
			new->p.cleared = prev_db_parms.cleared;
		} else {
			new->p.cleared = clean_start.tv_sec;
			new->p.flags |= DB_PARM_FG_NO_CLR;
		}
		switch (clean_mode) {
		case NORMAL_MODE:
			new->p.cleaned = clean_start.tv_sec;
			new->p.cleaned_cron = new->p.cleaned;
			new->p.failsafe_cleanings = 0;
			break;
		case FAILSAFE_MODE:
			new->p.cleaned = clean_start.tv_sec;
			new->p.cleaned_cron = prev_db_parms.cleaned_cron;
			new->p.failsafe_cleanings = 1+(prev_db_parms
						       .failsafe_cleanings);
			break;
		case REPAIR_MODE:
		case QUICK_MODE:
		case HASH_MODE:
		case DEL_MODE:
			new->p.cleaned = prev_db_parms.cleaned;
			new->p.cleaned_cron = prev_db_parms.cleaned_cron;
			new->p.failsafe_cleanings = (prev_db_parms
						     .failsafe_cleanings);
			break;
		}
	}

	if (grey_on)
		new->p.flags |= DB_PARM_FG_GREY;
	if (dbclean_ssd_mode)
		new->p.flags |= DB_PARM_FG_SSD;
	if (emptied
	    || (prev_db_parms.flags & DB_PARM_FG_NEED_RWD))
		new->p.flags |= DB_PARM_FG_NEED_RWD;
	if (have_expire_parms > 0
	    || (have_expire_parms < 0
		&& (prev_db_parms.flags & DB_PARM_FG_EXP_SET)))
		new->p.flags |= DB_PARM_FG_EXP_SET;
	if (prev_db_parms.flags & DB_PARM_FG_NO_CLR)
		new->p.flags |= DB_PARM_FG_NO_CLR;

	new->p.nokeep_cks = (emptied || prev_db_parms.nokeep_cks == 0
			     ? def_nokeep_cks()
			     : prev_db_parms.nokeep_cks);

	new->p.blksize = new_db_blksize;
	new->p.db_csize = new_db_csize;

	/* update the traffic counts */
	if (!emptied
	    && prev_db_parms.db_csize != 0
	    && prev_db_parms.db_csize >= prev_db_parms.old_db_csize
	    && prev_db_parms.hash_used != 0
	    && prev_db_parms.hash_used >= prev_db_parms.old_hash_used) {
		if (prev_db_parms.rate_secs > 0
		    && prev_db_parms.rate_secs <= DB_MAX_RATE_SECS) {
			new->p.db_added = prev_db_parms.db_added;
			new->p.hash_added = prev_db_parms.hash_added;
			new->p.rate_secs = prev_db_parms.rate_secs;
		}
		if (prev_db_parms.prev_rate_secs > 0
		    && prev_db_parms.prev_rate_secs <= DB_MAX_RATE_SECS) {
			new->p.prev_db_added = prev_db_parms.prev_db_added;
			new->p.prev_hash_added = prev_db_parms.prev_hash_added;
			new->p.prev_rate_secs = prev_db_parms.prev_rate_secs;
		}
		new->p.last_rate_sec = clean_start.tv_sec;
		new_rate_secs = clean_start.tv_sec - ts2secs(&prev_db_parms.sn);
		if (new_rate_secs > 0 && new_rate_secs <= DB_MAX_RATE_SECS) {
			new_rate_secs += new->p.rate_secs;
			new->p.db_added += (prev_db_parms.db_csize
					    - prev_db_parms.old_db_csize);
			new->p.hash_added += (prev_db_parms.hash_used
					      - prev_db_parms.old_hash_used);
			new->p.rate_secs = new_rate_secs;
			if (new_rate_secs >= DB_NEW_RATE_SECS) {
				new->p.prev_db_added = new->p.db_added;
				new->p.prev_hash_added = new->p.hash_added;
				new->p.prev_rate_secs = new->p.rate_secs;
				new->p.db_added = 0;
				new->p.hash_added = 0;
				new->p.rate_secs = 0;
			}
		}
	}

	for (type = DCC_CK_TYPE_FIRST; type <= DCC_CK_TYPE_LAST; ++type) {
		if (new_ex_secs[type].all != 0) {
			new->p.ex_secs[type].all = new_ex_secs[type].all;
			new->p.ex_secs[type].spam = new_ex_secs[type].spam;
			new->p.ex_all[type] = new_all_ts[type];
			new->p.ex_spam[type] = new_spam_ts[type];
		} else {
			new->p.ex_secs[type].all = def_expire_secs;
			new->p.ex_secs[type].spam = (DCC_CK_LONG_TERM(type)
						     ? def_expire_spamsecs
						     : def_expire_secs);
		}
	}

	new->p.min_confirm_pos = min_confirm_pos;

	new_db_parms = new->p;

	/* ensure that the last block of the file is complete */
	for (;;) {
		write_new_flush();

		if (new_db_blksize == 0)
			break;
		i = new_db_fsize % new_db_blksize;
		if (i == 0)
			break;

		write_new_db_buflen = new_db_blksize - i;
		if (write_new_db_buflen > ISZ(write_new_db_buf))
			write_new_db_buflen = ISZ(write_new_db_buf);
		memset(&write_new_db_buf, 0, write_new_db_buflen);
		write_new_base = new_db_fsize;
	}
}



static void
rename_bail(const char *from, const char *to)
{
	if (0 > rename(from, to))
		dcc_logbad(EX_IOERR, "rename(%s, %s): %s",
			   from, to, ERROR_STR());
}



/* try for a long time or until the server hears */
static u_char				/* 1=ok, 0=failed */
persist_aop(DCC_AOPS aop, u_int32_t val1,
	    int secs)			/* try for this long */
{
	DCC_CLNT_FGS clnt_fgs;

	clnt_fgs = DCC_CLNT_FG_NO_FAIL;
	if (grey_on)
		clnt_fgs |= DCC_CLNT_FG_GREY;

	return dcc_aop_persist(&dcc_emsg, ctxt, clnt_fgs, db_debug != 0,
			       aop, val1, secs, &aop_resp);
}



/* tell the daemon to switch to the new database */
static void
dccd_new_db(const char *msg)
{
	/* Send a round of NOPs and ask about status to ensure the server
	 * has dealt with requests that arrived while we had the database
	 * locked and otherwise caught up.  We want to try to ensure that
	 * the server is listening when we re-open the database so that
	 * it does not leave flooding off.
	 * On some systems with lame mmap() support including BSD/OS, the
	 * the daemon can stall for minutes in close().  If that or something
	 * else makes the daemon stall, this can appear to fail. */
	if (!persist_aop(DCC_AOP_FLOD, DCC_AOP_FLOD_LIST, RESTART_DELAY))
		dcc_error_msg("%s: %s; continuing", msg, dcc_emsg.c);

	dccd_unlocked = 0;
	if (!persist_aop(DCC_AOP_DB_NEW, 0, RESTART_DELAY)) {
		/* This cannot be a fatal error,
		 * lest we leave the database broken */
		dcc_error_msg("%s: %s; continuing", msg, dcc_emsg.c);
	}
}



static void
finish(void)
{
	DB_CLOSE_MODE bailing = DB_CLOSE;

	/* Delete created but not installed files. */
	if (new_db_created) {
		unlink_whine(0, db_paths.new.c, 1);
		new_db_created = 0;
		bailing = DB_CLOSE_DISCARD_ALL;
	}
	/* We don't really know if a new hash file was created,
	 * so don't worry about problems */
	if (new_hash_created) {
		unlink_whine(0, hash_paths.new.c, 1);
		new_hash_created = 0;
		bailing = DB_CLOSE_DISCARD_ALL;
	}
	if (cur_db_created) {
		unlink_whine(0, db_paths.base.c, 1);
		unlink_whine(0, db_paths.next.c, 1);
		unlink_whine(0, hash_paths.base.c, 1);
		unlink_whine(0, hash_paths.next.c, 1);
		cur_db_created = 0;
		bailing = DB_CLOSE_DISCARD_ALL;
	}

	if (new_db_fd >= 0) {
		if (0 > close(new_db_fd))
			dcc_error_msg("close(%s): %s",
				      db_paths.new.c, ERROR_STR());
		new_db_fd = -1;
	}
	if (old_db_fd >= 0) {
		if (0 > close(old_db_fd))
			dcc_error_msg("close(%s): %s",
				      db_paths.base.c, ERROR_STR());
		old_db_fd = -1;
	}
	flod_unmap(0, 0);

	/* release the daemon, but if the database is still open, it's bad */
	db_close(bailing);
	/* tell the daemon to switch databases */
	if (dccd_unlocked)
		dccd_new_db("finish");

	while (flods_off > 0) {
		--flods_off;
		if (!persist_aop(DCC_AOP_FLOD, DCC_AOP_FLOD_RESUME,
				 RESTART_DELAY))
			dcc_error_msg("%s", dcc_emsg.c);
	}

	unlock_dbclean();
}



/* terminate with a signal */
static void DCC_NORET
sigterm(int s)
{
	dcc_error_msg("interrupted by signal %d", s);
	exit(s+EX_DCC_SIGNAL);
}
