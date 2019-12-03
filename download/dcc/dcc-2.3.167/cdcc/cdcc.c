/* Distributed Checksum Clearinghouse
 *
 * control dcc server
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
 * Rhyolite Software DCC 2.3.167-1.285 $Revision$
 */

#include "dcc_ck.h"
#include "dcc_xhdr.h"
#include "dcc_heap_debug.h"
#include "dcc_ids.h"
#ifndef DCC_WIN32
#include <arpa/inet.h>
#endif
#ifdef HAVE_EDITLINE
#include <histedit.h>
#endif

static DCC_EMSG dcc_emsg;
static DCC_FNM_LNO_BUF fnm_buf;

static DCC_CLNT_CTXT *ctxt;

static DCC_PATH info_map_nm = {DCC_MAP_NM_DEF};
static u_char dup_emsg;
static const char *ids_nm;
static time_t clock_kludge;
static const char *homedir;
static DCC_PASSWD passwd;
static u_char passwd_set;
static DCC_IP src4, src6;
static DCC_SRVR_NM srvr = DCC_SRVR_NM_DEF(DCC_SRVR_PORT_HO);
static u_char port_set;
static DCC_CLNT_ID srvr_clnt_id = DCC_ID_ANON;
static u_char anon_ids_complained;
static enum WHICH_MAP {MAP_TMP, MAP_INFO} which_map = MAP_INFO;
static u_char map_changed = 1;

static DCC_INFO_FGS info_fgs;

static u_char grey_set;
static DCC_CLNT_FGS grey_clnt_fgs;

static u_char quiet;


#ifdef HAVE_EDITLINE
/* Use editline() instead of readline() to avoid problems for those who
 * distribute DCC binaries such as FreeBSD DCC packages. */
static History *el_history;
static HistEvent el_event;
#else
#define EditLine void
#endif
static EditLine *el_e = 0;

static u_char do_cmds(char *);
static void set_which_map(enum WHICH_MAP);
static u_char init_map(u_char, u_char);

struct cmd_tbl_entry;
/* -1=display help message, 0=command failed, 1=success */
typedef int CMD (const char *, const struct cmd_tbl_entry *);
typedef struct cmd_tbl_entry {
    const char	*cmd;
    CMD		(*fnc);
    u_char	args;			/* 0=optional, 1=required, 2=none */
    u_char	privileged;		/* 1=anon, 2=not anon ID, 3=server-ID */
    u_char	write_map;		/* 1=write map, 2=write /var/dcc/map */
    const char	*help_str;
} CMD_TBL_ENTRY;

static CMD help_cmd;
static CMD exit_cmd;
static CMD grey_cmd;
static CMD file_cmd;
static CMD new_map_cmd;
static CMD delete_cmd;
static CMD add_cmd;
static CMD load_cmd;
static CMD host_cmd;
static CMD port_cmd;
static CMD passwd_cmd;
static CMD id_cmd;
static CMD homedir_cmd;
#ifndef DCC_WIN32
static CMD libexecdir_cmd;
#endif
static CMD debug_cmd;
static CMD quiet_cmd;
static CMD no_fail_cmd;
static CMD ckludge_cmd;
static CMD ipv6_cmd;
static CMD src_cmd;
static CMD socks_cmd;
static CMD info_cmd;
static CMD rtt_cmd;
static CMD delck_cmd;
static CMD sleep_cmd;
static CMD clients_cmd;
static CMD anon_cmd;
static CMD flod_rewind;
static CMD ffwd_in;
static CMD ffwd_out;
static CMD flod_stats;
static CMD stats_cmd;
static CMD clock_ck_cmd;
static CMD trace_def;

static const CMD_TBL_ENTRY cmds_tbl[] = {
    {"help",		help_cmd,   0, 0, 0, "help [cmd]"},
    {"?",		0,	    0, 0, 0, 0},
    {"exit",		exit_cmd,   2, 0, 0, "exit"},
    {"quit",		0,	    2, 0, 0, 0},
    {"grey",		grey_cmd,   0, 0, 0, "grey [on|off]"},
    {"homedir",		homedir_cmd,0, 0, 0, "homedir [path]"},
#ifndef DCC_WIN32
    {"libexecdir",   libexecdir_cmd,2, 0, 0, "libexecdir"},
#endif
    {"file",		file_cmd,   0, 0, 0, "file [mapfile]"},
    {"map",		0,	    0, 0, 0, 0},
    {"new map",		new_map_cmd,0, 0, 0, "new map [mapfile]"},
    {"delete",		delete_cmd, 1, 0, 2, "delete host[,port]"},
    {"add",		add_cmd,    1, 0, 2,
	    "add host,[port|-] [RTT+/-#] [ID [passwd]]"},
    {"load",		load_cmd,   1, 0, 2, "load {map.txtfile | -}"},
    {"host",		host_cmd,   0, 0, 0, "host [name]"},
    {"server",		0,	    0, 0, 0, 0},
    {"port",		port_cmd,   0, 0, 0, "port #"},
    {"password",	passwd_cmd, 0, 0, 0, "password secret"},
    {"passwd",		0,	    0, 0, 0, 0},
    {"id",		id_cmd,	    0, 0, 0, "id [ID]"},
    {"debug",		debug_cmd,  0, 0, 0, "debug [on|off|TTL=x|#]"},
    {"quiet",		quiet_cmd,  0, 0, 0, "quiet [on|off]"},
    {"no fail",		no_fail_cmd,2, 0, 2, "no fail"},
    {"clock kludge",	ckludge_cmd,0, 0, 0, "clock kludge +/-secs"},
    {"IPv6",		ipv6_cmd,   0, 0, 0, "IPv6 [on|off|only]"},
    {"src",		src_cmd,    0, 0, 0, "src [-|IPaddress[,IPv6address]"},
    {"SOCKS",		socks_cmd,  0, 0, 0, "SOCKS [on|off]"},
    {"info",		info_cmd,   0, 1, 0, "info [-N]"},
    {"RTT",		rtt_cmd,    0, 1, 0, "RTT [-N]"},
    {"delck",		delck_cmd,  1, 3, 0, "delck type hex1..4"},
    {"sleep",		sleep_cmd,  1, 0, 0, "sleep sec.onds"},
    {"clients",		clients_cmd,0, 2, 0,
	    "clients [-nsiaVAK] [-I id] [max [thold [addr/prefix]]]"},
    {"anon delay",	anon_cmd,   0, 1, 0, "\nanon delay [delay[,inflate]]"},
    {"flood rewind",	flod_rewind,1, 3, 0, "flood rewind ID"},
    {"flod rewind",	0,	    1, 3, 0, 0},
    {"flood FFWD in",	ffwd_in,    1, 3, 0, "flood FFWD in ID"},
    {"flod FFWD in",	0,	    1, 3, 0, 0},
    {"flood FFWD out",	ffwd_out,   1, 3, 0, "flood FFWD out ID"},
    {"flod FFWD out",	0,	    1, 3, 0, 0},
    {"flood stats",	flod_stats, 0, 3, 0, "flood stats [clear] {ID|all}"},
    {"flood status",	0,	    0, 3, 0, 0},
    {"stats",		stats_cmd,  0, 0, 0, "stats [clear|all]"},
    {"status",		0,	    0, 1, 0, 0},
    {"clock check",	clock_ck_cmd,2,1, 0, "clock check"},
    {"trace default",	trace_def,  2, 3, 0, "trace default"},
};


static DCC_OP_RESP aop_resp;
static struct timeval op_start, op_end;
static DCC_SOCKU op_result_su;

static struct {
    const char	*op;
    const char	*help_str;
    DCC_AOPS	aop;
    u_char	privileged;		/* 1=anon, 2=not anon ID, 3=server-ID */
    u_int32_t	val;
} aops_tbl[] = {
#define TMAC1(s,h,b)						\
    {"trace "#s" on",   h, DCC_AOP_TRACE_ON,	1, DCC_TRACE_##b},\
    {"trace "#s" off",	0, DCC_AOP_TRACE_OFF,	1, DCC_TRACE_##b}
#define TMAC(s,b)   TMAC1(s,"trace "#s" {on|off}",b)
#define TMACQ(s,b)  TMAC1(s,0,b)
    TMAC(admn,ADMN_BIT),
    TMAC(anon,ANON_BIT),
    TMAC(clnt,CLNT_BIT),
    TMAC(rlim,RLIM_BIT),
    TMAC(query,QUERY_BIT),
    TMAC(ridc,RIDC_BIT),
    TMAC(flood1,FLOD1_BIT), TMACQ(flood,FLOD1_BIT), TMACQ(flod1,FLOD1_BIT),
    TMAC(flood2,FLOD2_BIT), TMACQ(flod2,FLOD2_BIT),
    /* TMAC(xx,_BIT), */
    TMAC(bl,BL_BIT),
    TMAC(db,DB_BIT),
    TMAC(wlist,WLIST_BIT),
#undef TMAC
    {"stop",		"",	DCC_AOP_STOP,	    3, 0},
    {"system stop",	"",	DCC_AOP_STOP,	    3, 1},
    {"clean stop",	"",	DCC_AOP_STOP,	    3, 2},
    {"flood check",	"",	DCC_AOP_FLOD,	    3, DCC_AOP_FLOD_CHECK},
    {"flod check",	0,	DCC_AOP_FLOD,	    3, DCC_AOP_FLOD_CHECK},
    {"flood shutdown",	"",	DCC_AOP_FLOD,	    3, DCC_AOP_FLOD_SHUTDOWN},
    {"flod shutdown",	0,	DCC_AOP_FLOD,	    3, DCC_AOP_FLOD_SHUTDOWN},
    {"flood halt",	"",	DCC_AOP_FLOD,	    3, DCC_AOP_FLOD_HALT},
    {"flod halt",	0,	DCC_AOP_FLOD,	    3, DCC_AOP_FLOD_HALT},
    {"flood resume",	"",	DCC_AOP_FLOD,	    3, DCC_AOP_FLOD_RESUME},
    {"flod resume",	0,	DCC_AOP_FLOD,	    3, DCC_AOP_FLOD_RESUME},
    {"flood list",	"",	DCC_AOP_FLOD,	    2, DCC_AOP_FLOD_LIST},
    {"flod list",	0,	DCC_AOP_FLOD,	    2, DCC_AOP_FLOD_LIST},
    {"DB clean",	"",	DCC_AOP_DB_CLEAN,   3, 0},
    {"DB new",		"",	DCC_AOP_DB_NEW,	    3, 0},
};


static void DCC_NORET
usage(void)
{
	dcc_logbad(EX_USAGE,
		   "usage: [-VBdq] [-h homedir] [-c ids] [op1 [op2] ... ]\n");
}



static void DCC_PF(1,2)
cdcc_error_msg(const char *p, ...)
{
	va_list args;

	if (dup_emsg) {
		va_start(args, p);
		vprintf(p, args);
		va_end(args);
	}

	/* On some systems you cannot use args twice after 1 va_start() */
	va_start(args, p);
	dcc_verror_msg(p, args);
	va_end(args);
}



static char *
prompt(EditLine *unused  DCC_UNUSED)
{
	static char buf[sizeof(DCC_PATH)+sizeof("cdcc >")];

	snprintf(buf, sizeof(buf), "cdcc %s> ",
		 which_map == MAP_INFO ? info_map_nm.c : "-");
	return buf;
}



#ifdef HAVE_EDITLINE
static void
get_editrc(void)
{
	const char *home;
	DCC_PATH editrc;
	struct stat sb;

	if (el_source(el_e, 0) >= 0)
		return;

	home = getenv("HOME");
	if (!home)
		return;
	if (STRLCPY(editrc.c, home, sizeof(editrc)) >= sizeof(editrc))
		return;
	if (STRLCAT(editrc.c, "/.editrc", sizeof(editrc)) >= sizeof(editrc))
		return;
	if (stat(editrc.c, &sb) < 0)
		return;
	if (sb.st_uid != dcc_real_uid)
		return;
	el_source(el_e, editrc.c);
}
#endif



int
main(int argc, char **argv)
{
	char cmd_buf[500];
	u_char print_version = 0;
	int i;

	dcc_init_priv();
	dcc_syslog_init(0, argv[0], 0);
#ifdef HAVE_EDITLINE
	if (isatty(STDIN_FILENO)) {
		const char *self;

		self = strrchr(argv[0], '/');
		if (self)
			++self;
		else
			self = argv[0];
		el_e = el_init(self, stdin, stdout, stderr);
	}
	if (el_e) {
		int mode;

		if (0 > el_get(el_e, EL_EDITMODE, &mode) || !mode) {
			el_end(el_e);
			el_e = 0;
		}
	}
	if (el_e) {
		/* prefer emacs mode but let the user choose in .editrc */
		el_set(el_e, EL_EDITOR, "emacs");
		/* bind emacs search to ^R */
		el_set(el_e, EL_BIND, "\022", "em-inc-search-prev", NULL);
		get_editrc();
		el_history = history_init();
		history(el_history, &el_event, H_SETSIZE, 800);
		el_set(el_e, EL_HIST, history, el_history);
		el_set(el_e, EL_PROMPT, prompt);
		el_set(el_e, EL_SIGNAL, 1);
	}
#endif

	while ((i = getopt(argc, argv, "VBdqh:c:")) != -1) {
		switch (i) {
		case 'V':
			dcc_version_print();
			print_version = 1;
			break;

		case 'B':
			dup_emsg = 1;
			break;

		case 'd':
			++dcc_clnt_debug;
			break;

		case 'q':
			++quiet;
			break;

		case 'h':
			homedir = optarg;
			break;

		case 'c':
			ids_nm = optarg;
			break;

		default:
			usage();
		}
	}
	argc -= optind;
	argv += optind;

	if (print_version && argc == 0)
		exit_cmd(0, 0);

	dcc_clnt_unthread_init();
	if (!dcc_cdhome(0, homedir, 1) && homedir)
		dcc_cdhome(0, homedir = 0, 1);
	set_ids_path(0, ids_nm);
	wf_init(&cmn_wf, 0);

	dcc_all_srvrs = 1;

	if (!init_map(!quiet, 0))
		set_which_map(MAP_TMP);

	/* with a list of commands, act as a batch utility */
	if (argc != 0) {
		for (;;) {
			/* a final arg of "-" says switch to interactive mode */
			if (argc == 1 && !strcmp(*argv, "-"))
				break;

#ifdef HAVE_EDITLINE
			if (el_e != NULL)
				history(el_history, &el_event, H_ENTER, *argv);
#endif

			if (!do_cmds(*argv)) {
				fputs(" ?\n", stderr);
				exit(EX_UNAVAILABLE);
			}
			assert_ctxts_unlocked();
			assert_info_unlocked();

			++argv;
			if (!--argc)
				exit_cmd(0, 0);
		}
	}

	/* Without an arg list of commands or after "-", look for commands
	 * from STDIN. Commands end with a semicolon or newline. */
	for (;;) {
		assert_ctxts_unlocked();
		assert_info_unlocked();

		fflush(stderr);
		fflush(stdout);
		if (el_e) {
#ifdef HAVE_EDITLINE
			const char *cmd;
			int cmd_len;

			cmd = el_gets(el_e, &cmd_len);
			if (!cmd) {
				fputc('\n', stdout);
				fflush(stderr);
				exit_cmd(0, 0);
			}
			if (*(cmd+strspn(cmd, DCC_WHITESPACE)) != '\0')
				history(el_history, &el_event, H_ENTER, cmd);
			STRLCPY(cmd_buf, cmd, sizeof(cmd_buf));
#endif
		} else {
			fputs(prompt(el_e), stdout);
			fflush(stdout);
			if (!fgets(cmd_buf, sizeof(cmd_buf), stdin)) {
				fputc('\n', stdout);
				fflush(stderr);
				exit_cmd(0, 0);
			}
		}
		if (!do_cmds(cmd_buf)) {
			fputs(" ?\n", stderr);
			fflush(stderr);
			if (which_map == MAP_TMP)
				no_fail_cmd(0, 0);
		}
	}
}



static void
get_passwd_fail(u_char privileged,
		const char *op,
		const char *type)
{
	const char *id_type;

	if (privileged < 3)
		id_type = "";
	else
		id_type = "server-";
	dcc_error_msg("\"%s\" is a privileged %s."
		      "   Use the \"id %sID\" command\n"
		      "   and \"password secret\" command or `su`"
		      " to read passwords from %s",
		      op, type, id_type, ids_path.c);
}



static u_char
load_ids_failed(u_char privileged,
		const char *op,
		const char *type)
{
	if (privileged < 2) {
		if (!anon_ids_complained) {
			anon_ids_complained = 1;
			dcc_error_msg("%s", dcc_emsg.c);
			dcc_error_msg("using the anonymous client-ID");
		}
		return 1;
	}

	dcc_error_msg("%s", dcc_emsg.c);
	get_passwd_fail(privileged, op, type);
	return 0;
}



/* see if we don't need a server-ID password, have one or if we can get it */
static u_char				/* 0=failed, 1=ok */
get_passwd(u_char privileged,		/* 1=anon, 2=not anon ID, 3=server-ID */
	   const char *op,
	   const char *type)
{
	const ID_TBL *srvr_clnt_tbl;
	DCC_PATH tmp;

	srvr.clnt_id = DCC_ID_ANON;
	memset(srvr.passwd, 0, sizeof(srvr.passwd));

	if (privileged == 0)
		return 1;

	if (passwd_set) {
		/* Using a manual password. */
		if (srvr_clnt_id == DCC_ID_ANON) {
			if (privileged > 1) {
				get_passwd_fail(privileged, op, type);
				return 0;
			}
			if (!anon_ids_complained) {
				dcc_error_msg("ID not specified,"
					      " so not using the password");
				anon_ids_complained = 1;
			}
			return 1;
		}
		if (srvr_clnt_id > DCC_SRVR_ID_MAX
		    && privileged > 2) {
			get_passwd_fail(privileged, op, type);
			return 0;
		}
		srvr.clnt_id = srvr_clnt_id;
		memcpy(srvr.passwd, passwd, sizeof(srvr.passwd));
		anon_ids_complained = 0;
		return 1;
	}

	if (srvr_clnt_id == DCC_ID_ANON) {
		if (privileged <= 1)
			return 1;
		get_passwd_fail(privileged, op, type);
		return 0;
	}

	/* Fetch the common server passwords only if we can read them without
	 * set-UID.  This keeps random local users from attacking local or
	 * remote servers with privileged commands, but does not slow privilege
	 * users who could use an editor to read the cleartext passwords. */
	dcc_rel_priv();
	if (0 > access(ids_path.c, R_OK) && errno == EACCES) {
		dcc_pemsg(EX_NOINPUT, &dcc_emsg, "access(%s): %s",
			  dcc_fnm2abs_msg(&tmp, ids_path.c), ERROR_STR());
		return load_ids_failed(privileged, op, type);
	}
	if (0 >= load_ids(&dcc_emsg, srvr_clnt_id, &srvr_clnt_tbl,
			  1, dcc_clnt_debug > 1)) {
		return load_ids_failed(privileged, op, type);
	}

	if (srvr_clnt_id > DCC_SRVR_ID_MAX
	    && privileged > 2) {
		get_passwd_fail(privileged, op, type);
		return 0;
	}

	srvr.clnt_id = srvr_clnt_id;
	memcpy(srvr.passwd, srvr_clnt_tbl->cur_passwd, sizeof(srvr.passwd));
	anon_ids_complained = 0;
	return 1;
}



static void
set_which_map(enum WHICH_MAP new)
{
	/* release things even if nothing seems to be changing
	 * to ensure that we bind a new socket and open a new map file */
	dcc_ctxts_lock();
	if (dcc_clnt_info)
		dcc_unmap_close_info(0);
	if (ctxt) {
		dcc_rel_ctxt(ctxt);
		ctxt = 0;
	}
	dcc_ctxts_unlock();

	map_changed = 1;
	which_map = new;
	if (new == MAP_INFO) {
		passwd_set = 0;
		src4.family = AF_UNSPEC;
		src6.family = AF_UNSPEC;
	}
}



static u_char
cdcc_unlock(u_char complain)
{
	u_char result;

	result = dcc_info_unlock(&dcc_emsg);
	dcc_ctxts_unlock();
	if (!result && complain)
		dcc_error_msg("%s", dcc_emsg.c);
	return result;
}



/* start talking to the local map file */
static u_char				/* 0=failed 1=mapped and locked */
init_map(u_char complain,
	 u_char lock)			/* 1=keep both locks on success */
{
	u_char result;

	dcc_emsg.c[0] = '\0';
	dcc_ctxts_lock();
	if (which_map == MAP_TMP) {
		result = (dcc_map_tmp_info(&dcc_emsg, &srvr,
					   &src4, &src6, info_fgs)
			  && dcc_info_lock(&dcc_emsg));
	} else {
		result = dcc_map_lock_info(&dcc_emsg, info_map_nm.c, -1);
	}
	if (result) {
		info_fgs = dcc_clnt_info->fgs;
		if (!lock)
			result = cdcc_unlock(complain);
	} else {
		dcc_ctxts_unlock();
		if (complain)
			dcc_error_msg("%s", dcc_emsg.c);
	}
	return result;
}



/* get ready to start talking to a DCC server
 *	on entry only the contexts are locked and only if we have a
 *	    context and the file is not mapped
 *	both locks are released on exit */
static u_char				/* 1=ok, 0=failed */
rdy_ctxt(DCC_CLNT_FGS fgs)
{
	u_char rdy_done;		/* 1=readied things enough */
	u_char need_unlock;
	u_char result;

	rdy_done = 0;
	need_unlock = 0;
	result = 0;

	if (grey_on)
		fgs |= DCC_CLNT_FG_GREY;
	else
		fgs &= ~DCC_CLNT_FG_GREY;
	fgs |= DCC_CLNT_FG_NO_FAIL;

	if (!ctxt) {
		if (which_map == MAP_TMP) {
			/* create a new temporary map */
			ctxt = dcc_tmp_clnt_init(&dcc_emsg, ctxt, &srvr,
						 &src4, &src6,
						 fgs, info_fgs);
		} else {
			/* open official map file */
			ctxt = dcc_clnt_init(&dcc_emsg, ctxt,
					     info_map_nm.c, fgs);
		}
		if (!ctxt) {
			dcc_error_msg("%s", dcc_emsg.c);
			return 0;
		}
		rdy_done = 1;
		result = 1;
	}

	/* if there is only a greylist server name, care only about it */
	if (!grey_set && dcc_clnt_info
	    && !grey_on
	    && dcc_clnt_info->dcc.nms[0].hostname[0] == '\0'
	    && dcc_clnt_info->grey.nms[0].hostname[0] != '\0') {
		grey_on = 1;
		fgs |= DCC_CLNT_FG_GREY;
		rdy_done = 0;
		result = 0;
	}

	dcc_ctxts_lock();
	if (!rdy_done) {
		dcc_emsg.c[0] = '\0';
		if (dcc_clnt_rdy(&dcc_emsg, ctxt, fgs)) {
			need_unlock = 1;
			result = 1;
		} else {
			dcc_error_msg("%s", dcc_emsg.c);
			result = 0;
		}
		/* we must give up now if we do not have the file */
		if (!dcc_clnt_info) {
			dcc_rel_ctxt(ctxt);
			ctxt = 0;
			dcc_ctxts_unlock();
			dcc_error_msg("%s", dcc_emsg.c);
			return 0;
		}
	}
	info_fgs = dcc_clnt_info->fgs;
	if (!(fgs & DCC_CLNT_FG_NO_MEASURE_RTTS))
		map_changed = 0;

	if (need_unlock && !dcc_info_unlock(0)) {
		dcc_rel_ctxt(ctxt);
		ctxt = 0;
		dcc_ctxts_unlock();
		dcc_error_msg("%s", dcc_emsg.c);
		return 0;
	}

	/* check the other (greylist or not) server */
	if (which_map == MAP_INFO) {
		dcc_emsg.c[0] = '\0';
		if (!dcc_clnt_rdy(&dcc_emsg, ctxt, fgs ^ DCC_CLNT_FG_GREY)) {
			if (dcc_clnt_debug > 1)
				dcc_error_msg("%s", dcc_emsg.c);
		} else {
			dcc_info_unlock(0);
		}
	}

	dcc_ctxts_unlock();
	return result;
}



/* should hold both locks on entry; both are released on exit */
static void
fix_info(u_char new_src)
{
	map_changed = 1;

	assert_ctxts_locked();
	assert_info_locked();

	dcc_force_measure_rtt(new_src);

	cdcc_unlock(1);
}



/* compare ignoring case */
static const char *			/* 0 or mismatch in str */
cmd_cmp(const char *user,		/* from the user */
	const char *op,			/* from command table entry */
	u_char *partial)		/* exact initial substring match */
{
	char op_c, user_c;
	int len;

	if (partial)
		*partial = 0;

	len = 0;
	for (;;) {
		op_c = *op;
		op_c = DCC_TO_LOWER(op_c);

		user_c = *user;
		if (user_c == '\t')
			user_c = ' ';
		else
			user_c = DCC_TO_LOWER(user_c);

		if (op_c != user_c) {
			/* compress bursts of blanks */
			if (user_c == ' ' && len != 0 && *(op-1) == ' ') {
				++user;
				continue;
			}

			/* Treat substring match without an arg
			 * as a complete match. */
			if (user_c == '\0') {
				if (partial)
					*partial = 1;
				return 0;
			}
			return user;
		}

		/* stop at an exact match */
		if (op_c == '\0')
			return 0;

		++op;
		++user;
		++len;
	}
}



/* Display our name for the server and its address,
 * while suppressing some duplicates */
static void
print_aop(SRVR_INX srvr_inx)		/* NO_SRVR or server index */
{
	const DCC_SRVR_CLASS *class;
	char date_buf[40];
	char sustr[DCC_SU2STR_SIZE];
	DCC_PATH tmp;
	const char *srvr_nm;
	NAM_INX nam_inx;

	dcc_su2str2(sustr, sizeof(sustr), &op_result_su);
	class = DCC_GREY2CLASS(grey_on);

	/* Display the currently chosen server
	 * if the specified srvr_inx is NO_SRVR */
	if (!VALID_SRVR(class, srvr_inx))
		srvr_inx = class->srvr_inx;

	if (VALID_SRVR(class, srvr_inx)
	    && (VALID_NAM(nam_inx = class->addrs[srvr_inx].nam_inx))) {
		srvr_nm = class->nms[nam_inx].hostname;
		if (strcmp(srvr_nm, sustr)
		    && strcmp(srvr_nm, DCC_LOCALHOST)) {
			fputs(srvr_nm, stdout);
			putchar(' ');
		}
		printf("%s\n        server-ID %d",
		       dcc_su2str_err(&op_result_su),
		       class->addrs[srvr_inx].srvr_id);
	} else {
		printf("%s\n                    ",
		       dcc_su2str_err(&op_result_su));
	}
	if (srvr.clnt_id != DCC_ID_ANON)
		printf("  client-ID %d", srvr.clnt_id);
	if (which_map == MAP_INFO)
		printf("  %s", dcc_fnm2abs_msg(&tmp, info_map_nm.c));
	dcc_time2str(date_buf, sizeof(date_buf), "  %X", op_start.tv_sec);
	fputs(date_buf, stdout);
	putchar('\n');
}



static u_char				/* 0=some kind of problem, 1=done */
start_aop(DCC_AOPS aop, u_int32_t val1, SRVR_INX srvr_inx)
{
	DCC_OPS result;

	if (!rdy_ctxt(0))
		return 0;

	gettimeofday(&op_start, 0);
	result = dcc_aop(&dcc_emsg, ctxt, grey_clnt_fgs, srvr_inx, clock_kludge,
			 aop, val1, 0, 0, 0, 0, 0, &aop_resp, &op_result_su);
	gettimeofday(&op_end, 0);

	if (result == DCC_OP_INVALID
	    || result == DCC_OP_ERROR) {
		cdcc_error_msg("%s", dcc_emsg.c);
		return 0;
	}

	return 1;
}



static void
fin_aop(SRVR_INX srvr_inx,		/* index of server */
	u_char psrvr)			/* 1=print server name */
{
	if (quiet && !dcc_clnt_debug)
		return;

	if (psrvr)
		print_aop(srvr_inx);

	/* say what the server had to say */
	if (aop_resp.resp.val.string[0] >= ' '
	    && aop_resp.resp.val.string[0] < 0x7f) {
		fputs(aop_resp.resp.val.string, stdout);
		putchar('\n');
	}

	if (dcc_clnt_debug) {
		printf("%.2f ms\n",
		       ((op_end.tv_sec-op_start.tv_sec)*1000.0
			+ (op_end.tv_usec-op_start.tv_usec)/1000.0));
	}
	putchar('\n');
}



static u_char				/* 0=some kind of problem, 1=done */
do_aop(DCC_AOPS aop, u_int32_t val1, SRVR_INX srvr_inx, u_char psrvr)
{
	if (!start_aop(aop, val1, srvr_inx))
		return 0;
	fin_aop(srvr_inx, psrvr);
	return 1;
}



static u_char				/* 0=not enough power */
ck_cmd_priv(const CMD_TBL_ENTRY *ce,
	    u_char privileged,		/* 0=anon ok 1=server-ID 2=client-ID */
	    u_char write_map)		/* 1=write map, 2=write /var/dcc/map */
{
	DCC_PATH tmp;

	/* always call get_passwd() so we have always fetched a password
	 * fail if this command needs a good server-ID and password */
	if (!get_passwd(privileged, ce->cmd, "server command"))
		return 0;

	if (!write_map)
		return 1;

	/* we can always write to our own throw-away map file */
	if (write_map == 1 && which_map == MAP_TMP)
		return 1;

	if (0 > access(info_map_nm.c, R_OK)
	    && errno != ENOENT && errno != ENOTDIR) {
		dcc_error_msg("\"%s\" is a privileged command changing %s",
			      ce->cmd, dcc_fnm2abs_msg(&tmp, info_map_nm.c));
		return 0;
	}
	return 1;
}



static u_char
run_cmd(const char *op, const char *arg, const CMD_TBL_ENTRY *ce)
{
	int i;

	if (!ck_cmd_priv(ce, ce->privileged, ce->write_map))
		return 0;
	i = ce->fnc(arg, ce);
	if (i > 0)
		return 1;
	if (i == 0)
		return 0;
	help_cmd(op, 0);
	return 0;
}



static u_char				/* 1=ok 0=bad command */
cmd(const char *op)
{
	const char *arg, *help_str;
	int op_num, op_num1, j;
	const CMD_TBL_ENTRY *ce, *ce1;
	u_char iss;

	/* look for the string as a command and execute it if we find it */
	ce1 = 0;
	ce = &cmds_tbl[0];
	for (op_num = 0; op_num < DIM(cmds_tbl); ++op_num) {
		if (cmds_tbl[op_num].fnc)
			ce = &cmds_tbl[op_num];
		arg = cmd_cmp(op, cmds_tbl[op_num].cmd, &iss);
		if (arg == op)
			continue;

		/* if the command table entry and the command completely
		 * matched, then infer a null argument */
		if (!arg) {
			if (iss) {
				/* continue searching after the 1st or a
				 * duplicate initial substring match */
				if (!ce1 || ce1 == ce) {
					ce1 = ce;
					continue;
				}
				help_cmd(op, 0);
				return 0;
			}
			if (ce->args != 1)
				return run_cmd(op, "", ce);
			help_cmd(op, 0);
			return 0;
		}
		/* If the command table entry is an initial substring of
		 * the user's command, then the rest of the command must
		 * start with white space or '='.  Allow '=' to let
		 * homedir/fix-map not need use `eval` to quote blanks
		 * `eval` in bash loses exit status.
		 *
		 * Trim blanks and use the rest of the string as the argument */
		j = strspn(arg, DCC_WHITESPACE"=");
		if (j) {
			if (ce->args == 2) {
				help_cmd(op, 0);    /* arg not allowed */
				return 0;
			}
			return run_cmd(op, arg+j, ce);
		}
	}
	/* run an unambigious partial command */
	if (ce1)
		return run_cmd(op, "", ce1);

	/* otherwise try to interpret it as a DCC administrative packet */
	op_num1 = -1;
	op_num = 0;
	help_str = "";
	for (;;) {
		if (op_num >= DIM(aops_tbl)) {
			/* allow previously seen unambiguous partial match */
			if (op_num1 != -1) {
				op_num = op_num1;
				break;
			}
			dcc_error_msg("unrecognized command \"%s\"", op);
			return 0;
		}
		/* do a command */
		if (aops_tbl[op_num].help_str) {
			help_str = aops_tbl[op_num].help_str;
			if (*help_str == '\0')
				help_str = aops_tbl[op_num].op;
		}
		if (!cmd_cmp(op, aops_tbl[op_num].op, &iss)) {
			if (!iss)
				break;
			if (op_num1 == -1) {
				/* continue searching after 1st partial match */
				op_num1 = op_num;
			} else {
				/* quit on 2nd partial match */
				help_cmd(op, 0);
				return 0;
			}
			break;
		}
		++op_num;
	}

	/* send an administrative request to the server */
	if (!get_passwd(aops_tbl[op_num].privileged, help_str, "operation"))
		return 0;

	/* try to send it */
	return do_aop(aops_tbl[op_num].aop, aops_tbl[op_num].val,
		      NO_SRVR, 1);
}



static u_char				/* 0=bad command, 1=ok */
do_cmds(char *cmd_buf)
{
	char *next_cmd, *cur_cmd, *cmd_end;
	char c;

	next_cmd = cmd_buf;
	for (;;) {
		cur_cmd = next_cmd + strspn(next_cmd, DCC_WHITESPACE";");

		if (*cur_cmd == '#' || *cur_cmd == '\0')
			return 1;

		next_cmd = cur_cmd + strcspn(cur_cmd, ";\n\r");
		cmd_end = next_cmd;
		next_cmd += strspn(next_cmd, ";\n\r");

		/* null terminate and trim trailing white space from
		 * command or arg */
		do {
			*cmd_end-- = '\0';
			c = *cmd_end;
		} while (cmd_end >= cur_cmd
			 && strchr(DCC_WHITESPACE";", c));

		if (*cur_cmd == '\0')	/* ignore blank commands */
			continue;

		if (!cmd(cur_cmd))
			return 0;
	}
}



static int
help_cmd_print(int pos, const char *str)
{
#define HELP_COL 24
	int col, nl;

	if (str[0] == '\n') {
		nl = 100;
		++str;
	} else {
		nl = 0;
	}
	col = strlen(str)+1;
	col += HELP_COL - (col % HELP_COL);
	pos += col;
	if (pos > 78) {
		putchar('\n');
		pos = col;
	}
	printf("%-*s", col, str);
	pos += nl;

	return pos;
#undef HELP_COL
}



static int
help_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	u_char iss;
	int found;			/* 0=partial ISS, 1=iss, 2=exact */
	const char *help_str;
	const char *p;
	int pos;
	int i;

	/* See if the request specifies one or more commands. */
	found = -1;
	if (arg && *arg != '\0') {
		for (i = 0; i < DIM(cmds_tbl); ++i) {
			p = cmd_cmp(arg, cmds_tbl[i].cmd, &iss);
			if (!p) {
				if (!iss)
					found = 2;
				else if (found < 1)
					found = 1;
			} else if (p != arg && found < 0) {
				found = 0;
			}
		}
		for (i = 0; i < DIM(aops_tbl); ++i) {
			p = cmd_cmp(arg, aops_tbl[i].op, &iss);
			if (!p) {
				if (!iss) {
					/* complete match */
					found = 2;
				} else if (found < 1) {
					/* target is initial substring of
					 * command; note if it is best so far */
					found = 1;
				}
			} else if (p != arg && found < 0) {
				/* target has an initial substring that
				 * matches initial substring of command */
				found = 0;
			}
		}
	}
	/* If we found something, show it */
	if (found >= 0) {
		help_str = 0;
		for (i = 0; i < DIM(cmds_tbl); ++i) {
			/* show the help string for a matching synonym */
			if (cmds_tbl[i].help_str)
				help_str = cmds_tbl[i].help_str;
			if (!help_str)
				continue;
			p = cmd_cmp(arg, cmds_tbl[i].cmd, &iss);
			/* don't show a command that does not match at all */
			if (p == arg)
				continue;
			/* don't show commands that share initial substring
			 * with target if we have better */
			if (p != NULL && found > 0)
				continue;
			/* show commands for which the target is an initial
			 * substring only if we do not have a exact match */
			if (found > 1 && iss)
				continue;
			/* skip a leading '\n' that signals a
			 * new line after this command */
			if (*help_str == '\n')
				++help_str;
			printf("usage: %s\n", help_str);
			help_str = 0;
		}
		help_str = 0;
		for (i = 0; i < DIM(aops_tbl); ++i) {
			if (aops_tbl[i].help_str) {
				help_str = aops_tbl[i].help_str;
				/* use the command itself if the string empty */
				if (*help_str == '\0')
					help_str = aops_tbl[i].op;
			}
			if (!help_str)
				continue;
			p = cmd_cmp(arg, aops_tbl[i].op, &iss);
			/* don't show a command that does not match at all */
			if (p == arg)
				continue;
			/* don't show commands that share initial substring
			 * with target if we have better */
			if (p != NULL && found > 0)
				continue;
			/* show commands for which the target is an initial
			 * substring only if we do not have a exact match */
			if (found > 1 && iss)
				continue;
			/* skip a leading '\n' that signals a
			 * new line after this command */
			if (*help_str == '\n')
				++help_str;
			printf("usage: %s\n", help_str);
			help_str = 0;
		}
		return 1;
	}

	/* talk about all of the commands */
	printf("   version "DCC_VERSION"\n");
	pos = 0;
	for (i = 0; i < DIM(cmds_tbl); ++i) {
		if (cmds_tbl[i].help_str)
			pos = help_cmd_print(pos, cmds_tbl[i].help_str);
	}
	for (i = 0; i < DIM(aops_tbl); ++i) {
		help_str = aops_tbl[i].help_str;
		if (!help_str)
			continue;
		if (*help_str == '\0')
			help_str = aops_tbl[i].op;
			pos = help_cmd_print(pos, help_str);
	}
	putchar('\n');

	return 1;
}



static int DCC_NORET
exit_cmd(const char *arg DCC_UNUSED, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
#ifdef HAVE_EDITLINE
	if (el_e) {
		if (el_history)
			history_end(el_history);
		el_end(el_e);
	}
#endif
	exit(EX_OK);
#ifndef HAVE_GCC_ATTRIBUTES
	return -1;
#endif
}


static int
grey_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	if (arg[0] == '\0') {
		printf("    Greylist mode %s%s\n",
		       grey_on ? "on" : "off",
		       grey_set ? "" : " by default");
		return 1;
	}
	if (!strcmp(arg, "off")) {
		grey_on = 0;
		grey_set = 1;
		grey_clnt_fgs &= ~DCC_CLNT_FG_GREY;
		set_which_map(which_map);
	} else if (!strcmp(arg, "on")) {
		grey_on = 1;
		grey_set = 1;
		grey_clnt_fgs |= DCC_CLNT_FG_GREY;
		set_which_map(which_map);
	} else {
		return -1;
	}
	if (!port_set)
		srvr.port = DCC_GREY2PORT(grey_on);
	return 1;
}



static int
homedir_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	if (arg[0] != '\0') {
		if (!dcc_cdhome(0, arg, 1))
			return 0;
		if (ids_nm && !set_ids_path(&dcc_emsg, ids_nm))
			dcc_error_msg("%s", dcc_emsg.c);
		set_which_map(MAP_INFO);
	}
	printf("    homedir=%s\n", dcc_homedir.c);
	return 1;
}



#ifndef DCC_WIN32
static int
libexecdir_cmd(const char *arg DCC_UNUSED, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	printf("    libexecdir=%s\n", DCC_LIBEXECDIR);
	return 1;
}
#endif



/* set name of map file */
static int
file_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_PATH tmp;

	if (arg[0] == '\0') {
		if (which_map == MAP_INFO)
			printf("    using map file %s\n",
			       dcc_fnm2abs_msg(&tmp, info_map_nm.c));
		else
			printf("    map file %s but using temporary file\n",
			       dcc_fnm2abs_msg(&tmp, info_map_nm.c));
		return 1;
	}

	BUFCPY(info_map_nm.c, arg);
	set_which_map(MAP_INFO);
	return 1;
}



/* create a new client map or parameter file */
static int
new_map_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_PATH tmp;

	if (arg[0] == '\0')
		arg = DCC_MAP_NM_DEF;

	dcc_rel_priv();
	if (!dcc_create_map(&dcc_emsg, arg, 0, 0, 0, 0, 0, 0, 0, info_fgs)) {
		dcc_error_msg("%s", dcc_emsg.c);
		return 0;
	}
	BUFCPY(info_map_nm.c, arg);
	set_which_map(MAP_INFO);
	if (!quiet)
		printf("    created %s\n", dcc_fnm2abs_msg(&tmp,
							info_map_nm.c));
	return 1;
}



static int
info_work(const char *arg, int fgs)
{
	DCC_CLNT_INFO info;
	u_char dcc, names;

	if (*arg == '\0') {
		names = 0;
	} else if (!strcmp(arg, "-N")) {
		names = 1;
	} else {
		return -1;
	}

	if (!rdy_ctxt(fgs | DCC_CLNT_FG_BAD_SRVR_OK))
		return 0;

	/* Snapshot the data and then release it while we print it. */
	dcc_ctxts_lock();
	if (!dcc_info_lock(0)) {
		dcc_ctxts_lock();
		return 0;
	}
	memcpy(&info, dcc_clnt_info, sizeof(info));
	cdcc_unlock(1);

	dcc_rel_priv();
	if (which_map == MAP_INFO) {
		if (info.dcc.nms[0].hostname[0] != '\0'
		    || !grey_on) {
			print_info(info_map_nm.c, &info,
				   quiet, 0, names,
				   0 <= access(info_map_nm.c, R_OK));
			dcc = 1;
		} else {
			dcc = 0;
		}
		if (info.grey.nms[0].hostname[0] != '\0'
		    || grey_on) {
			if (dcc && !quiet)
				fputs("\n################\n", stdout);
			print_info(info_map_nm.c, &info, quiet, 1, names,
				   0 <= access(info_map_nm.c, R_OK));
		}
	} else {
		print_info(0, &info, quiet, grey_on ? 2 : 0,
			   names, 1);
	}
	if (!quiet)
		putchar('\n');
	return 1;
}



/* server host name */
static int
host_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_SRVR_NM nm;

	if (arg[0] == '\0') {
		if (which_map == MAP_INFO)
			return info_work(arg, 0) ;

		printf("    %s server name \"%s\"\n",
		       grey_on ? "greylist" : "DCC", srvr.hostname);
		return 1;
	}
	if (!strcmp(arg, "-")) {
		set_which_map(MAP_INFO);
		if (!init_map(1, 0)) {
			set_which_map(MAP_TMP);
			return 0;
		}
		return 1;
	}

	arg = dcc_parse_nm_port(0, arg, 0,
				nm.hostname, sizeof(nm.hostname),
				&nm.port, 0, 0, 0, 0);
	if (!arg)
		return 0;
	arg += strspn(arg, DCC_WHITESPACE);
	if (*arg != '\0')
		return 0;

	set_which_map(MAP_TMP);
	memcpy(srvr.hostname, nm.hostname, sizeof(srvr.hostname));
	if (nm.port != 0) {
		srvr.port = nm.port;
		port_set = 1;
	}
	return 1;
}



/* server port # */
static int
port_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	u_int port;

	if (arg[0] == '\0') {
		if (which_map == MAP_INFO)
			return info_work(arg, 0) ;
		printf("    port=%d\n", ntohs(srvr.port));
		return 1;
	}

	port = dcc_get_port(0, arg, DCC_GREY2PORT(grey_on), 0, 0);
	if (port == DCC_GET_PORT_INVALID)
		return 0;

	srvr.port = port;
	port_set = 1;
	set_which_map(MAP_TMP);
	return 1;
}



static int
ipv6_cmd(const char *arg, const CMD_TBL_ENTRY *ce)
{
	DCC_INFO_FGS new_info_fgs;
	char sustr[DCC_SU2STR_SIZE];
	sa_family_t check_family;

	if (!init_map(1, 0))
		return 0;

	if (arg[0] == '\0') {
		printf("    %s\n",
		       (info_fgs & DCC_INFO_FG_IPV6_OFF)
		       ? DCC_INFO_TXT_IPV6_OFF
		       : (info_fgs & DCC_INFO_FG_IPV4_OFF)
		       ? DCC_INFO_TXT_IPV6_ONLY
		       : DCC_INFO_TXT_IPV6_ON);
		return 1;
	}

	if (!strcasecmp(arg, "on")) {
		/* "ON" means both IPv4 and IPv6 */
		new_info_fgs = 0;
		check_family = AF_INET6;
	} else if (!strcasecmp(arg, "off")) {
		new_info_fgs = DCC_INFO_FG_IPV6_OFF;
		check_family = AF_INET;
	} else if (!strcasecmp(arg, "only")) {
		new_info_fgs = DCC_INFO_FG_IPV4_OFF;
		check_family = AF_INET6;
	} else {
		return -1;
	}

	if (!ipv_check(&dcc_emsg, check_family, 1)) {
		if (new_info_fgs == DCC_INFO_FG_IPV4_OFF) {
			dcc_error_msg("%s", dcc_emsg.c);
			return 0;
		}
		dcc_error_msg("warning %s", dcc_emsg.c);
	}

	if (!ck_cmd_priv(ce, 0, 1))
		return 0;

	if (!init_map(1, 1))
		return 0;

	if ((new_info_fgs & DCC_INFO_FG_IPV4_OFF)
	    && dcc_clnt_info->src4.ip.family == AF_INET) {
		dcc_error_msg("IPv4 %s incompatible with "
			      DCC_INFO_TXT_USE_SRC"%s\n"
			      "    Remove the source addresses with 'src -'",
			      arg, dcc_ip2str(sustr, sizeof(sustr),
					      &dcc_clnt_info->src4.ip));
		cdcc_unlock(1);
		return 0;
	}
	if ((new_info_fgs & DCC_INFO_FG_IPV6_OFF)
	    && dcc_clnt_info->src6.ip.family == AF_INET6) {
		dcc_error_msg("IPv6 %s incompatible with "
			      DCC_INFO_TXT_USE_SRC"%s"
			      "\n    Remove the source addresses with 'src -'",
			      arg, dcc_ip2str(sustr, sizeof(sustr),
					      &dcc_clnt_info->src6.ip));
		cdcc_unlock(1);
		return 0;
	}

	new_info_fgs |= (info_fgs & ~(DCC_INFO_FG_IPV6_OFF
				      | DCC_INFO_FG_IPV4_OFF));
	if (info_fgs != new_info_fgs) {
		dcc_clnt_info->fgs = info_fgs = new_info_fgs;
		fix_info(0);
	} else if (!cdcc_unlock(1)) {
		return 0;
	}

	if (rdy_ctxt(0)
	    && 0 != ((new_info_fgs ^ dcc_clnt_info->fgs)
		     & (DCC_INFO_FG_IPV6_OFF | DCC_INFO_FG_IPV4_OFF))) {
#ifdef DCC_NO_IPV6
		dcc_error_msg("IPv6 switch not changed;"
			      " No IPv6 support in this system?");
#else
		dcc_error_msg("IPv6 switch not changed.");
#endif
		return 0;
	}

	return 1;
}



static u_char
ck_new_src(DCC_EMSG *emsg, DCC_IP *new_src4, DCC_IP *new_src6,
	   const char *addr, DCC_INFO_FGS fgs)
{
	DCC_SOCKU su;
	DCC_GETH geth;
	DCC_SOCKU *hp;
	int error;

	memset(&su, 0, sizeof(su));

	/* Allow host name.
	 * Disallow IPv4 or IPv6 if not allowed.
	 * Prefer IPv6 if we already have IPv4 (or the reverse).
	 */
	if (!str2su(&su, addr)) {
		if (fgs & DCC_INFO_FG_IPV6_OFF)
			geth = DCC_GETH_V4;
		else if (fgs & DCC_INFO_FG_IPV4_OFF)
			geth = DCC_GETH_V6;
		else
			geth = DCC_GETH_DEF;
		dcc_host_lock();
		if (!dcc_get_host(addr, geth, &error)) {
			dcc_host_unlock();
			dcc_pemsg(EX_NOHOST, emsg, "%s: %s",
				  addr, H_ERROR_STR1(error));
			return 0;
		}
		if (new_src4->family == AF_UNSPEC
		    && !(fgs & DCC_INFO_FG_IPV4_OFF)) {
			for (hp = dcc_hostaddrs; hp < dcc_hostaddrs_end; ++hp) {
				if (hp->sa.sa_family == AF_INET) {
					dcc_su2ip(new_src4, hp);
					break;
				}
			}
		}
		if (new_src6->family == AF_UNSPEC
		    && !(fgs & DCC_INFO_FG_IPV6_OFF)) {
			for (hp = dcc_hostaddrs; hp < dcc_hostaddrs_end; ++hp) {
				if (hp->sa.sa_family == AF_INET6) {
					dcc_su2ip(new_src6, hp);
					break;
				}
			}
		}
		dcc_host_unlock();
		return 1;
	}

	if (su.sa.sa_family == AF_INET) {
		if (fgs & DCC_INFO_FG_IPV4_OFF) {
			dcc_pemsg(EX_NOHOST, emsg,
				  "cannot use IPv4 source address"
				  " when IPv4 disabled");
			return 0;
		}
		if (new_src4->family == AF_UNSPEC)
			dcc_su2ip(new_src4, &su);
		return 1;
	}

	if (su.sa.sa_family == AF_INET6) {
		if (fgs & DCC_INFO_FG_IPV6_OFF) {
			dcc_pemsg(EX_NOHOST, emsg,
				  "cannot use IPv6 source address"
				  " when IPv6 disabled");
			return 0;
		}
		if (new_src6->family == AF_UNSPEC)
			dcc_su2ip(new_src6, &su);
		return 1;
	}

	dcc_pemsg(EX_NOHOST, emsg, "\"%s\" has unkown address family", addr);
	return 0;
}



static void
get_src_addr(char *addr, int addr_len, const char **argp)
{
	const char *arg, *p;

	arg = *argp + strspn(*argp, DCC_WHITESPACE);
	p = strpbrk(arg, ","DCC_WHITESPACE);
	if (!p) {
		*argp = arg+strlen(arg);
		STRLCPY(addr, arg, addr_len);
	} else {
		STRLCPY(addr, arg, min(p-arg+1, addr_len));
		p += strspn(p, DCC_WHITESPACE);
		if (!CLITCMP(p, DCC_INFO_TXT_USE_SRCBAD))
			p += LITZ(DCC_INFO_TXT_USE_SRCBAD);
		p += strspn(p, ","DCC_WHITESPACE);
		*argp = p;
	}
}



static u_char
ck_new_srcs(DCC_EMSG *emsg, DCC_IP *new_src4, DCC_IP *new_src6,
	    const char **argp, DCC_INFO_FGS fgs)
{
	DCC_SOCKU su;
	DCC_SOCKET soc;
	char addr1[MAXHOSTNAMELEN+1];
	char addr2[MAXHOSTNAMELEN+1];

	/* separate IPv4 and IPv6 addresses */
	get_src_addr(addr1, sizeof(addr1), argp);
	get_src_addr(addr2, sizeof(addr2), argp);

	memset(new_src4, 0, sizeof(*new_src4));
	memset(new_src6, 0, sizeof(*new_src6));

	if ((!strcmp(addr1, "-") || !strcmp(addr1, "*"))
	    && addr2[0] == '\0')
		return 1;

	if (!ck_new_src(emsg, new_src4, new_src6, addr1, fgs))
		return 0;
	if (addr2[0] != '\0'
	    && !ck_new_src(emsg, new_src4, new_src6, addr2, fgs))
		return 0;

	if (new_src4->family != AF_UNSPEC) {
		soc = INVALID_SOCKET;
		if (!udp_create(&dcc_emsg, &soc,
				dcc_ip2su(&su, new_src4), 1, 1, 0))
			return 0;
		closesocket(soc);
	}

	if (new_src6->family != AF_UNSPEC) {
		soc = INVALID_SOCKET;
		if (!udp_create(&dcc_emsg, &soc,
				dcc_ip2su(&su, new_src6), 1, 1, 0))
			return 0;
		closesocket(soc);
	}

	return 1;
}



static int
src_cmd(const char *arg, const CMD_TBL_ENTRY *ce)
{
	DCC_IP new_src4, new_src6;

	if (arg[0] == '\0') {
		if (!init_map(1, 0))
			return 0;

		if (dcc_clnt_info->src4.ip.family == AF_UNSPEC
		    && dcc_clnt_info->src6.ip.family == AF_UNSPEC) {
			printf("    no source address specified");
		} else {
			print_info_src(dcc_clnt_info, "src=");
		}
		putchar('\n');
		return 1;
	}

	if (!ck_cmd_priv(ce, 0, 1))
		return 0;

	if (!init_map(1, 1))
		return 0;

	/* check the host name after we have locked the IPv4 vs. IPv6 choice */
	if (!ck_new_srcs(&dcc_emsg, &new_src4, &new_src6,
			 &arg, dcc_clnt_info->fgs)) {
		dcc_error_msg("%s", dcc_emsg.c);
		cdcc_unlock(1);
		return 0;
	}
	if (*arg != '\0') {
		dcc_error_msg("unrecognized \"%s\"", arg);
		cdcc_unlock(1);
		return 0;
	}

	src4 = new_src4;
	dcc_clnt_info->src4.ip = new_src4;
	src6 = new_src6;
	dcc_clnt_info->src6.ip = new_src6;
	fix_info(1);
	return 1;
}



static int
socks_cmd(const char *arg, const CMD_TBL_ENTRY *ce)
{
	DCC_INFO_FGS new_use_socks;

	if (arg[0] == '\0') {
		if (!init_map(1, 0))
			return 0;
		printf("    SOCKS %s\n",
		       (info_fgs & DCC_INFO_FG_SOCKS) ? "on" : "off");
		return 1;
	}

	if (!strcmp(arg, "off")) {
		new_use_socks = 0;
	} else if (!strcmp(arg, "on")) {
		new_use_socks = DCC_INFO_FG_SOCKS;
	} else {
		return -1;
	}

	if (!ck_cmd_priv(ce, 0, 1))
		return 0;

	if (!init_map(1, 1))
		return 0;
	if ((dcc_clnt_info->fgs & DCC_INFO_FG_SOCKS) == new_use_socks)
		return cdcc_unlock(1);	/* nothing to do */

	dcc_clnt_info->fgs ^= DCC_INFO_FG_SOCKS;
	info_fgs = dcc_clnt_info->fgs;
	fix_info(1);
	return 1;
}



static int
passwd_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_PASSWD new_passwd;
	DCC_PATH tmp;

	if (arg[0] == '\0') {
		if (which_map == MAP_INFO) {
			printf("    using password in %s\n",
			       dcc_fnm2abs_msg(&tmp, info_map_nm.c));
			if (passwd_set)
				printf("    but the password for explicitly"
				       " named servers is "DCC_PASSWD_PAT"\n",
				       passwd);
		} else {
			if (passwd_set) {
				printf("    password "DCC_PASSWD_PAT"\n",
				       passwd);
			} else if (srvr.passwd[0] != '\0') {
				printf("    password not set;"
				       " using "DCC_PASSWD_PAT" from %s\n",
				       srvr.passwd,
				       dcc_fnm2abs_msg(&tmp, ids_path.c));
			} else {
				printf("    password not set\n");
			}
		}
		return 1;
	}

	arg = parse_passwd(0, new_passwd, arg, "password", 0, 0);
	if (!arg || *arg != '\0')
		return -1;
	memcpy(passwd, new_passwd, sizeof(passwd));
	passwd_set = 1;
	anon_ids_complained = 0;
	set_which_map(MAP_TMP);
	return 1;
}



static int
id_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_CLNT_ID id;

	if (arg[0] == '\0') {
		printf("    ID=%d\n", srvr_clnt_id);
		return 1;
	}

	id = dcc_get_id(0, arg, 0, 0);
	if (id == DCC_ID_INVALID)
		return -1;

	srvr_clnt_id = id;
	anon_ids_complained = 0;
	set_which_map(MAP_TMP);
	return 1;
}



static int
debug_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	char debug_str[24];
	char ttl_str[24];
	u_long new_ttl, l, new_debug;
	char *p;

	if (arg[0] == '\0') {
		if (!dcc_clnt_debug)
			snprintf(debug_str, sizeof(debug_str),
				 "debug off");
		else if (dcc_clnt_debug == 1)
			snprintf(debug_str, sizeof(debug_str),
				 "debug on");
		else
			snprintf(debug_str, sizeof(debug_str),
				 "debug on+%d\n", dcc_clnt_debug-1);
		if (dcc_debug_ttl != 0)
			snprintf(ttl_str, sizeof(ttl_str),
				 "    TTL=%d", dcc_debug_ttl);
		else
			ttl_str[0] = '\0';
		printf("    %s%s\n", debug_str, ttl_str);
		return 1;
	}

	new_ttl = dcc_debug_ttl;
	new_debug = dcc_clnt_debug;
	for (;;) {
		if (!CLITCMP(arg, "off")) {
			new_debug = 0;
			arg += LITZ("off");
		} else if (!CLITCMP(arg, "on")) {
			++new_debug;
			arg += LITZ("on");
		} else if (!CLITCMP(arg, "ttl=")) {
			new_ttl = strtoul(arg+LITZ("ttl="), &p, 10);
#if defined(IPPROTO_IP) && defined(IP_TTL)
			if (new_ttl < 256)
				arg = p;
#else
			printf("    TTL setting not supported\n");
#endif
		} else if ((l = strtoul(arg, &p, 10)) > 0 && l < 10) {
			new_debug = l;
			arg = p;
		}

		if (*arg == '\0')
			break;
		if (*arg == ' ' || *arg == '\t') {
			arg += strspn(arg, DCC_WHITESPACE);
		} else {
			return -1;
		}
	}

	dcc_debug_ttl = new_ttl;
	if (dcc_debug_ttl != 0)
		set_which_map(MAP_TMP);

	dcc_clnt_debug = new_debug;
	if (dcc_clnt_debug > 1)
		printf("    debug on+%d\n", dcc_clnt_debug-1);
	return 1;
}



static int
no_fail_cmd(const char *arg DCC_UNUSED, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	if (!init_map(1, 1))
		return 0;
	DCC_GREY2CLASS(grey_on)->fail_time = 0;
	cdcc_unlock(1);
	return 1;
}



static int
quiet_cmd(const char *arg DCC_UNUSED, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	if (arg[0] == '\0') {
		printf("    %s\n", quiet ? "on" : "off");
		return 1;
	} else if (!CLITCMP(arg, "on")) {
		quiet = 1;
		return 1;
	} else if (!CLITCMP(arg, "off")) {
		quiet = 0;
		return 1;
	}
	return -1;
}



static int
ckludge_cmd(const char *arg DCC_UNUSED, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	char *p;
	long l;

	if (arg[0] == '\0') {
		printf("    clock kludge=%d\n", (int)clock_kludge);
		return 1;
	}

	l = strtol(arg, &p, 10);
	if (*p != '\0') {
		dcc_error_msg("invalid clock kludge \"%s\"", arg);
		return -1;
	}
	clock_kludge = l;
	return 1;
}



/* parse a line of the following form
 *	name[,port-#] [RTT+adj] [Greylist] [client-ID [password]]
 *  The port-# can be "-" to specifiy the default DCC server port.
 *  If both the client-ID and the password are absent, then the anonymous
 *  client-ID is used.
 *  A null string is assumed if the password is missing.
 */
static int				/* 0=minor, -1=can't add, -2=can't del */
parse_srvr_nm(DCC_EMSG *emsg,
	      DCC_SRVR_NM *nmp,		/* build this entry */
	      u_char *has_port,		/* 1=has non-null port # */
	      u_char *pgrey,		/* 1=for greylisting */
	      const char *line0,	/* from this string */
	      const char *fnm, int lno) /* that came from here */
{
	const char *line;
	char id_buf[12];
	char port_buf[3];
	int result;
	char *p;
	long l;

	result = 1;
	memset(nmp, 0, sizeof(DCC_SRVR_NM));

	line = dcc_parse_nm_port(emsg, line0, DCC_GREY2PORT(pgrey && *pgrey),
				 nmp->hostname, sizeof(nmp->hostname),
				 &nmp->port, port_buf, sizeof(port_buf),
				 fnm, lno);
	if (!line)
		return -2;
	if (has_port) {
		p = strchr(line0, ',');
		*has_port = (p && p < line);
	}

	/* look for RTT and greylist flag in either order */
	for (;;) {
		/* look for greylist flag */
		if (!CLITCMP(line, "greylist")
		    && (line[LITZ("greylist")] == '\0'
			|| line[LITZ("greylist")] == ' '
			|| line[LITZ("greylist")] == '\t')) {
			line += LITZ("greylist")+strspn(line+LITZ("greylist"),
							DCC_WHITESPACE);
			if (pgrey)
				*pgrey = 1;
			if (port_buf[0] == '\0' || !strcmp(port_buf, "-"))
				nmp->port = htons(DCC_GREY_PORT);
			continue;
		}

		/* look for optional RTT adjustment */
		if (CLITCMP(line, "rtt"))
			break;
		line += LITZ("rtt");
		line += strspn(line, DCC_WHITESPACE);
		l = strtol(line, &p, 10);
		if (p != line) {
			int wsp = strspn(p, DCC_WHITESPACE);
			if (!CLITCMP(p+wsp, "ms"))
				p += wsp+LITZ("ms");
		}
		if (p == line
		    || (*p != '\0' && *p != ' ' && *p != '\t')) {
			dcc_pemsg(EX_DATAERR, emsg,
				  "invalid RTT adjustment%s",
				  dcc_fnm_lno(&fnm_buf, fnm, lno));
			result = 0;
		} else {
			if (l < -DCC_RTT_ADJ_MAX/1000) {
				l = -DCC_RTT_ADJ_MAX/1000;
				dcc_pemsg(EX_DATAERR, emsg,
					  "invalid RTT adjustment%s",
					  dcc_fnm_lno(&fnm_buf, fnm, lno));
				result = 0;
			} else if (l > DCC_RTT_ADJ_MAX/1000) {
				l = DCC_RTT_ADJ_MAX/1000;
				dcc_pemsg(EX_DATAERR, emsg,
					  "invalid RTT adjustment%s",
					  dcc_fnm_lno(&fnm_buf, fnm, lno));
				result = 0;
			}
			nmp->rtt_adj = l*1000;
			line = p+strspn(p, DCC_WHITESPACE);
		}
	}

	/* get the client-ID */
	line = dcc_parse_word(emsg, id_buf, sizeof(id_buf),
			      line, "client-ID", fnm, lno);
	if (!line)
		return -2;
	if (id_buf[0] == '\0') {
		nmp->clnt_id = DCC_ID_ANON;
	} else {
		nmp->clnt_id = dcc_get_id(emsg, id_buf, fnm, lno);
		if (nmp->clnt_id == DCC_ID_INVALID)
			return -1;
		if (nmp->clnt_id < DCC_CLNT_ID_MIN
		    && nmp->clnt_id != DCC_ID_ANON) {
			dcc_pemsg(EX_DATAERR, emsg,
				  "server-ID %d is not a client-ID",
				  nmp->clnt_id);
			return -1;
		}
	}

	/* allow null password only for anonymous clients */
	if (*line == '\0') {
		if (nmp->clnt_id != DCC_ID_ANON) {
			dcc_pemsg(EX_DATAERR, emsg,
				  "invalid null password for client-ID %d"
				  " for %s%s",
				  nmp->clnt_id, nmp->hostname,
				  dcc_fnm_lno(&fnm_buf, fnm, lno));
			return -1;
		}
		return result;
	}

	line = parse_passwd(emsg, nmp->passwd, line, "passwd", fnm, lno);
	if (nmp->passwd[0] == '\0' || *line != '\0') {
		dcc_pemsg(EX_DATAERR, emsg,
			  "invalid password server %s, client-ID %d%s",
			  nmp->hostname, nmp->clnt_id,
			  dcc_fnm_lno(&fnm_buf, fnm, lno));
		if (nmp->clnt_id != DCC_ID_ANON)
			return -1;
		result = 0;
	}

	if (nmp->clnt_id == DCC_ID_ANON) {
		dcc_pemsg(EX_DATAERR, emsg,
			  "password invalid for %s with anonymous client-ID%s",
			  nmp->hostname,
			  dcc_fnm_lno(&fnm_buf, fnm, lno));
		result = 0;
	}

	return result;
}



static void
delete_error(const DCC_SRVR_NM *nmp, char has_port, const char *msg)
{
	if (has_port) {
		dcc_error_msg("server \"%s,%d\" %s",
			      nmp->hostname, ntohs(nmp->port), msg);
	} else {
		dcc_error_msg("server \"%s\" %s",
			      nmp->hostname, msg);
	}
	cdcc_unlock(1);
}



static int
delete_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_SRVR_CLASS *class;
	DCC_SRVR_NM nm, *nmp, *nmp2;
	DCC_SRVR_ADDR *addr;
	const char *zi;
	u_char del_grey, has_port;
	int i;

	del_grey = grey_on;
	if (-1 > parse_srvr_nm(&dcc_emsg, &nm, &has_port, &del_grey,
			       arg, 0, 0)) {
		dcc_error_msg("%s", dcc_emsg.c);
		return 0;
	}

	/* map and lock */
	set_which_map(MAP_INFO);
	if (!init_map(1, 1))
		return 0;

	class = DCC_GREY2CLASS(del_grey);
	nmp2 = 0;
	for (nmp = class->nms; nmp <= LAST(class->nms); ++nmp) {
		if (!strcasecmp(nmp->hostname, nm.hostname)) {
			/* found exact match */
			if (nmp->port == nm.port)
				break;

			/* matching all except port # is ok if
			 * there is only one possible match */
			if (!has_port) {
				if (!nmp2) {
					nmp2 = nmp;
				} else {
					nmp2 = LAST(class->nms)+1;
				}
			}
			continue;
		}

		zi = strchr(nmp->hostname, '%');
		if (!zi)
			continue;
		i = zi - nmp->hostname;
		if (!strncasecmp(nmp->hostname, nm.hostname, i)
		    && (int)strlen(nm.hostname) == i) {
			/* all of name except zone index matches */
			if (nmp->port == nm.port || !has_port) {
				if (!nmp2) {
					nmp2 = nmp;
				} else {
					nmp2 = LAST(class->nms)+1;
				}
				break;
			}
		}
	}


	if (nmp > LAST(class->nms)) {
		nmp = nmp2;
		if (!nmp) {
			delete_error(&nm, has_port, "not found");
			return 0;
		}
		if (nmp > LAST(class->nms)) {
			delete_error(&nm, has_port, "ambiguous");
			return 0;
		}
	}

	/* zap its IP addresses so they won't be used
	 * if resolving the remaining names fails */
	for (addr = class->addrs; addr <= LAST(class->addrs); ++addr) {
		if (addr->nam_inx == nmp - class->nms) {
			addr->rtt = DCC_RTT_BAD;
			addr->nam_inx = NO_NAM;
		}
	}
	if (nmp != LAST(class->nms))
		memmove(nmp, nmp+1, (LAST(class->nms) - nmp)*sizeof(*nmp));
	memset(LAST(class->nms), 0, sizeof(*nmp));
	++class->gen;
	fix_info(0);
	return 1;
}



static int
add_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_SRVR_CLASS *class;
	DCC_SRVR_NM nm, *nmp, *tgt_nmp;
	u_char add_grey;
	int i;

	add_grey = grey_set && grey_on;

	i = parse_srvr_nm(&dcc_emsg, &nm, 0, &add_grey, arg, 0, 0);
	if (i < 0) {
		dcc_error_msg("%s", dcc_emsg.c);
		return 0;
	}
	if (nm.clnt_id == DCC_ID_ANON && add_grey) {
		dcc_error_msg("anonymous client-ID invalid"
			      " for Greylist server %s",
			      nm.hostname);
		return 0;
	}
	if (i < 1)
		dcc_error_msg("    %s", dcc_emsg.c);

	/* map and lock the information */
	set_which_map(MAP_INFO);
	if (!init_map(1, 1))
		return 0;

	/* look for the old entry or a new, free entry */
	class = DCC_GREY2CLASS(add_grey);
	tgt_nmp = 0;
	for (nmp = class->nms; nmp <= LAST(class->nms); ++nmp) {
		if (nmp->hostname[0] == '\0') {
			if (!tgt_nmp)
				tgt_nmp = nmp;
			continue;
		}
		if (!strcmp(nmp->hostname, nm.hostname)
		    && nmp->port == nm.port) {
			printf("    overwriting existing entry\n");
			tgt_nmp = nmp;
			break;
		}
	}

	if (tgt_nmp) {
		memcpy(tgt_nmp, &nm, sizeof(*tgt_nmp));
		fix_info(0);
		return 1;
	}

	cdcc_unlock(1);
	if (add_grey)
		dcc_error_msg("too many Greylist server names");
	else
		dcc_error_msg("too many DCC server names");
	return 0;
}



static void
add_new_nms(const DCC_SRVR_NM new_nms[DCC_MAX_SRVR_NMS],
	    DCC_SRVR_NM old_nms[DCC_MAX_SRVR_NMS])
{
	const DCC_SRVR_NM *new_nmp;
	DCC_SRVR_NM *old_nmp;

	for (new_nmp = new_nms;
	     new_nmp < &new_nms[DCC_MAX_SRVR_NMS]
	     && new_nmp->hostname[0] != '\0';
	     ++new_nmp) {
		for (old_nmp = old_nms;
		     old_nmp <= &old_nms[DCC_MAX_SRVR_NMS];
		     ++old_nmp) {
			if (old_nmp->hostname[0] == '\0'
			    || (!strcmp(old_nmp->hostname, new_nmp->hostname)
				&& old_nmp->port == new_nmp->port)) {
				memcpy(old_nmp, new_nmp, sizeof(*old_nmp));
				break;
			}
		}
	}
}



/* open a file of server names, ports, and so forth */
static FILE *
open_map_txt(DCC_EMSG *emsg, const char *nm)
{
	FILE *f;
	DCC_PATH path;

	f = fopen(nm, "r");
	if (!f) {
		dcc_pemsg(EX_NOINPUT, emsg, "fopen(%s): %s",
			  dcc_fnm2abs_msg(&path, nm), ERROR_STR());
		return 0;
	}

	/* the file contains passwords,
	 * so refuse to use it if everyone can read it */
	if (!dcc_ck_private(emsg, 0, nm, fileno(f))) {
		fclose(f);
		return 0;
	}
	return f;
}



static int				/* -1=bad line 0=not option line 1=ok */
get_options(DCC_EMSG *emsg, const char *cp,
	    DCC_INFO_FGS *new_info_fgs, DCC_IP *new_src4, DCC_IP *new_src6)
{
	u_char option_line;
	sa_family_t check_family;
	char *p;
	int version;

	option_line = 0;
	version = 0;
	for (;;) {
		cp += strspn(cp, DCC_WHITESPACE);
		if (*cp == '\0')
			break;

		if (!CLITCMP(cp, DCC_INFO_TXT_IPV6)) {
			if (!CLITCMP(cp, DCC_INFO_TXT_IPV6_OFF)) {
				cp += LITZ(DCC_INFO_TXT_IPV6_OFF);
				*new_info_fgs &= ~DCC_INFO_FG_IPV4_OFF;
				*new_info_fgs |= DCC_INFO_FG_IPV6_OFF;
				check_family = AF_INET;

			} else if (!CLITCMP(cp, DCC_INFO_TXT_IPV6_ON)) {
				cp += LITZ(DCC_INFO_TXT_IPV6_ON);
				*new_info_fgs &= ~(DCC_INFO_FG_IPV4_OFF
						   | DCC_INFO_FG_IPV6_OFF);
				check_family = AF_INET6;

			} else if (!CLITCMP(cp, DCC_INFO_TXT_IPV6_ONLY)) {
				cp += LITZ(DCC_INFO_TXT_IPV6_ONLY);
				*new_info_fgs &= ~DCC_INFO_FG_IPV6_OFF;
				*new_info_fgs |= DCC_INFO_FG_IPV4_OFF;
				check_family = AF_INET6;
			} else {
				break;
			}

			if (dcc_clnt_debug
			    && !ipv_check(&dcc_emsg, check_family, 1))
				dcc_error_msg("warning %s", dcc_emsg.c);

			option_line = 1;
			continue;
		}

		if (!CLITCMP(cp, DCC_INFO_TXT_USE_SOCKS)) {
			cp += LITZ(DCC_INFO_TXT_USE_SOCKS);
			cp += strspn(cp, DCC_WHITESPACE);
			*new_info_fgs |= DCC_INFO_FG_SOCKS;
			option_line = 1;
			continue;
		}

		if (!CLITCMP(cp, DCC_INFO_TXT_USE_SRC)) {
			cp += LITZ(DCC_INFO_TXT_USE_SRC);
			if (!ck_new_srcs(&dcc_emsg, new_src4, new_src6,
					 &cp, *new_info_fgs))
				return -1;
			option_line = 1;
			continue;
		}

		if (!CLITCMP(cp, DCC_INFO_TXT_VERSION)) {
			cp += LITZ(DCC_INFO_TXT_VERSION);
			version = strtol(cp, &p, 10);
			if (version != DCC_INFO_TXT_VERSION_CUR
			    || (*p != '\0' && *p != ' ' && *p != '\t'
				&& *p != '\n' && *p != '\r')){
				dcc_pemsg(EX_DATAERR, emsg,
					  "unrecognized text version number");
				return -1;
			}
			cp = p;
			option_line = 1;
			continue;
		}

		if (option_line)
			break;
		return 0;
	}

	if (option_line && *cp != '\0') {
		dcc_pemsg(EX_DATAERR, emsg, "unrecognized option \"%s\"", cp);
		return -1;
	}

	/* ignore IPv6 settings in old files */
	if (version < 3)
		*new_info_fgs &= ~(DCC_INFO_FG_IPV4_OFF | DCC_INFO_FG_IPV6_OFF);

	return 1;
}



static int
load_cmd(const char *lfile, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_INFO_FGS new_info_fgs;
	u_char load_grey;
	DCC_SRVR_NM new_nm;
	DCC_SRVR_NM dcc_nms[DCC_MAX_SRVR_NMS];
	int num_dcc_nms;
	DCC_SRVR_NM grey_nms[DCC_MAX_SRVR_NMS];
	int num_grey_nms;
	int got_options;
	DCC_IP new_src4, new_src6;
	char buf[sizeof(DCC_SRVR_NM)*3];
	const char *bufp;
	DCC_PATH tmp;
	FILE *f;
	int fd, lno;
	int i;

	if (*lfile == '\0')
		return -1;

	dcc_rel_priv();
	if (!strcmp(lfile,"-")) {
		lfile = 0;
		fd = dup(fileno(stdin));
		if (fd < 0) {
			dcc_error_msg("dup(stdin): %s", ERROR_STR());
			return 0;
		}
		f = fdopen(fd, "r");
		if (!f) {
			dcc_error_msg("fdopen(): %s", ERROR_STR());
			return 0;
		}
	} else {
		f = open_map_txt(&dcc_emsg, lfile);
		if (!f) {
			dcc_error_msg("%s", dcc_emsg.c);
			return 0;
		}
	}

	/* parse the text file to create a pair of lists of server names */
	new_info_fgs = info_fgs;
	got_options = -1;
	num_dcc_nms = 0;
	memset(dcc_nms, 0, sizeof(dcc_nms));
	num_grey_nms = 0;
	memset(grey_nms, 0, sizeof(grey_nms));
	memset(&new_src4, 0, sizeof(new_src4));
	memset(&new_src6, 0, sizeof(new_src6));
	lno = 0;
	for (;;) {
		bufp = fgets(buf, sizeof(buf), f);
		if (!bufp) {
			if (ferror(f)) {
				dcc_error_msg("fgets(%s): %s",
					      !lfile
					      ? "STDIN"
					      : dcc_fnm2abs_msg(&tmp, lfile),
					      ERROR_STR());
				fclose(f);
				return 0;
			}
			break;
		}
		i = strlen(bufp);
		if (buf[i-1] == '\n')
			buf[i-1] = '\0';
		++lno;

		/* skip blank lines and comments */
		bufp += strspn(bufp, DCC_WHITESPACE);
		if (*bufp == '\0' || *bufp == '#')
			continue;

		/* look for version # and flags in the first non-comment line */
		if (got_options < 0) {
			got_options = get_options(&dcc_emsg,
						  bufp, &new_info_fgs,
						  &new_src4, &new_src6);
			if (got_options < 0) {
				dcc_error_msg("%s%s", dcc_emsg.c,
					      dcc_fnm_lno(&fnm_buf, lfile, lno));
				fclose(f);
				return 0;
			}
			if (got_options > 0)
				continue;
		}

		load_grey = 0;
		i = parse_srvr_nm(&dcc_emsg, &new_nm, 0, &load_grey,
				  bufp, lfile, lno);
		if (i < 0) {
			dcc_error_msg("%s", dcc_emsg.c);
			fclose(f);
			return 0;
		}
		if (i < 1)
			dcc_error_msg("    %s", dcc_emsg.c);
		if (load_grey) {
			if (new_nm.clnt_id == DCC_ID_ANON) {
				dcc_error_msg("anonymous client-ID invalid"
					      " for Greylist server %s%s",
					      new_nm.hostname,
					      dcc_fnm_lno(&fnm_buf, lfile, lno));
				fclose(f);
				return 0;
			}
			if (num_grey_nms >= DIM(grey_nms)) {
				dcc_error_msg("too many Greylist server names"
					      "%s",
					      dcc_fnm_lno(&fnm_buf, lfile, lno));
				fclose(f);
				return 0;
			}
			grey_nms[num_grey_nms++] = new_nm;
		} else {
			if (num_dcc_nms >= DIM(dcc_nms)) {
				dcc_error_msg("too many DCC server names%s",
					      dcc_fnm_lno(&fnm_buf, lfile, lno));
				fclose(f);
				return 0;
			}
			dcc_nms[num_dcc_nms++] = new_nm;
		}
	}
	fclose(f);
	if (!got_options && num_grey_nms == 0 && num_dcc_nms == 0) {
		dcc_error_msg("no DCC server names or options in %s",
			      dcc_fnm2abs_msg(&tmp, lfile));
		return 0;
	}

	/* create the map, without set-UID powers to prevent games,
	 * and then lock, install, and unlock the information */
	dcc_rel_priv();

	if (which_map != MAP_INFO)
		set_which_map(MAP_INFO);
	if (!init_map(0, 1)) {
		/* create a new map */
		if (!dcc_create_map(0, info_map_nm.c, 0,
				    0, 0, 0, 0, &new_src4, &new_src6,
				    new_info_fgs))
			return 0;
		printf("    created %s\n", dcc_fnm2abs_msg(&tmp,
							info_map_nm.c));
		if (!init_map(1, 1))
			return 0;
	}

	/* merge the old and new entries */
	add_new_nms(grey_nms, dcc_clnt_info->grey.nms);
	add_new_nms(dcc_nms, dcc_clnt_info->dcc.nms);
	dcc_clnt_info->fgs = info_fgs = new_info_fgs;
	if (new_src4.family == AF_INET)
		dcc_clnt_info->src4.ip = new_src4;
	if (new_src6.family == AF_INET6)
		dcc_clnt_info->src6.ip = new_src6;

	fix_info(1);

	if (!quiet) {
		if (!lfile)
			printf("##################\n\n");
		return info_work("", 0) ;
	}
	return 1;
}



static int
info_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	/* map, copy, and unlock the information
	 * prefer to talk to the server, but don't wait
	 * unless we have changed the file and are not being quiet */
	return info_work(arg,
			 (!map_changed || quiet)
			 ? DCC_CLNT_FG_NO_MEASURE_RTTS :  0);
}



static int
rtt_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	if (!init_map(1, 1))
		return 0;
	dcc_force_measure_rtt(1);
	cdcc_unlock(1);

	/* wait to talk to the server, but don't insist */
	return info_work(arg, 0);
}


/* delete a checksum */
static int				/* 1=ok, 0=bad checksum, -1=fatal */
delck_sub(DCC_EMSG *emsg, WF *wf DCC_UNUSED,
	  DCC_CK_TYPES type, DCC_SUM *sum, DCC_TGTS tgts DCC_UNUSED)
{
	struct timeval cmd_start, cmd_end;
	char type_buf[DCC_XHDR_MAX_TYPE_LEN_BUF];
	char ck_buf[sizeof(DCC_SUM)*3+2];
	DCC_DELETE del;
	DCC_OP_RESP resp;
	char ob[DCC_OPBUF];
	u_char result;

	printf(" deleting %s  %s\n",
	       type2str(type_buf, sizeof(type_buf), type, 0, 1, grey_on),
	       ck2str(ck_buf, sizeof(ck_buf), type, sum, 0));

	memset(&del, 0, sizeof(del));
	gettimeofday(&cmd_start, 0);
	del.date = htonl(cmd_start.tv_sec);
	del.ck.type = type;
	del.ck.len = sizeof(del.ck);
	memcpy(&del.ck.sum, sum, sizeof(DCC_SUM));
	result = dcc_clnt_op(emsg, ctxt, grey_clnt_fgs | DCC_CLNT_FG_NO_FAIL,
			     0, 0, 0, &del.hdr, sizeof(del),
			     DCC_OP_DELETE, &resp, sizeof(resp));
	gettimeofday(&cmd_end, 0);
	if (!result) {
		dcc_error_msg("%s", dcc_emsg.c);
	} else {
		switch (resp.hdr.op) {
		case DCC_OP_OK:
			break;

		case DCC_OP_ERROR:
			cdcc_error_msg("   %.*s",
				       (ntohs(resp.hdr.len)
					-(int)(sizeof(resp.error)
					       - sizeof(resp.error.msg))),
				       resp.error.msg);
			result = 0;
			break;

		default:
			dcc_error_msg("unexpected response: %s",
				      dcc_hdr_op2str(ob,sizeof(ob), &resp.hdr));
			result = 0;
			break;
		}
	}

	if (dcc_clnt_debug) {
		printf("%.2f ms\n",
		       ((cmd_end.tv_sec-cmd_start.tv_sec)*1000.0
			+ (cmd_end.tv_usec-cmd_start.tv_usec)/1000.0));
	}
	return result;
}



/* delete a simple checksum */
static int
delck_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	char type_str[DCC_XHDR_MAX_TYPE_LEN_BUF];

	if (*arg == '\0')
		return -1;
	arg = dcc_parse_word(0, type_str, sizeof(type_str),
			     arg, 0, 0, 0);
	if (!arg)
		return -1;

	if (!rdy_ctxt(0))
		return 0;
	return 0 < dcc_parse_hex_ck(0, &cmn_wf,
				    type_str, dcc_str2type_del(type_str, -1),
				    arg, 0, delck_sub);
}



static int
sleep_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	double s;
	char *p;

	s = strtod(arg, &p);
	if (*p != '\0' || s < 0.001 || s > 1000)
		return -1;
	usleep((u_int)(s*1000000.0));
	return 1;
}




static const u_char *
client_unpack64(const u_char *cp, DCC_SCNTR *vp)
{
	u_char c;
	DCC_SCNTR v;
	int shift;

	v = 0;
	shift = 0;
	do {
		c = *cp++;
		v |= ((DCC_SCNTR)(c & 0x7f)) << shift;
		shift += 7;
	} while (c & 0x80);

	*vp = v;
	return cp;
}



static int
client_unpack(const u_char *cp0,
	      DCC_ADMN_RESP_CLIENTS_FLAGS *flagsp,
	      DCC_CLNT_ID *clnt_idp,
	      u_int *offsetp,
	      DCC_PTIME *last_usedp,
	      DCC_PTIME *prev_last_usedp,
	      DCC_SCNTR *reqsp,
	      DCC_SCNTR *nopsp,
	      u_char *versp,
	      DCC_SOCKU *su)
{
	const u_char *cp;
	DCC_ADMN_RESP_CLIENTS_FLAGS flags;
	DCC_SCNTR v;
	struct in6_addr in6_addr;
	struct in_addr in_addr;

#ifdef DCC_PKT_VERS6
	if (aop_resp.hdr.pkt_vers <= DCC_PKT_VERS6) {
#define CPY2(s) ((s[0]<<8) | s[1])
#define CPY3(s) ((s[0]<<16) | (s[1]<<8) | s[2])
#define CPY4(s) ((s[0]<<24) | (s[1]<<16) | (s[2]<<8) | s[3])
		const DCC_ADMN_RESP_CLIENTSv6 *cl;

		cl = (DCC_ADMN_RESP_CLIENTSv6 *)cp0;
		flags = cl->flags;
		*flagsp = flags & (DCC_ADMN_RESP_CLIENTS_BLACK
				   | DCC_ADMN_RESP_CLIENTS_SKIP);
		*clnt_idp = CPY4(cl->clnt_id);
		if (flags & DCC_ADMN_RESP_CLIENTS_SKIP) {
			/* skip place keepers */
			*offsetp += CPY3(cl->reqs);
			*last_usedp = 0;
			*reqsp = 0;
		} else {
			*last_usedp = CPY4(cl->last_used);
			*reqsp = CPY3(cl->reqs);
		}
		*prev_last_usedp = 0;
		*nopsp = CPY2(cl->nops);
		if (flags & DCC_ADMN_RESP_CLIENTS_IPV6) {
			memcpy(&in6_addr, &cl->addr, sizeof(in6_addr));
			dcc_mk_inet6_su(su, &in6_addr, 0, 0);
			return (sizeof(*cl) - sizeof(cl->addr)
				+ sizeof(cl->addr.ipv6));
		}
		memcpy(&in_addr, &cl->addr, sizeof(in_addr));
		dcc_mk_inet_su(su, &in_addr, 0);
		return (sizeof(*cl) - sizeof(cl->addr)
			+ sizeof(cl->addr.ipv4));
	}
#undef CPY2
#undef CPY3
#undef CPY4
#endif

	cp = cp0;
	flags = *cp++;
	*flagsp = flags & (DCC_ADMN_RESP_CLIENTS_BLACK
			   | DCC_ADMN_RESP_CLIENTS_DROPPED
			   | DCC_ADMN_RESP_CLIENTS_SKIP
			   | DCC_ADMN_RESP_CLIENTS_LAST
			   | DCC_ADMN_RESP_CLIENTS_BLOCK);
	/* if the version is absent,
	 * then it must be the same as the previous value */
	if (flags & DCC_ADMN_RESP_CLIENTS_VERS)
		*versp = *cp++;
#ifdef DCC_PKT_VERS9
	if (aop_resp.hdr.pkt_vers <= DCC_PKT_VERS9) {
		v = *cp++ << 24;
		v |= *cp++ << 16;
		v |= *cp++ << 8;
		v |= *cp++;
		*prev_last_usedp = 0;
	} else
#endif
	cp = client_unpack64(cp, &v);
	if (flags & DCC_ADMN_RESP_CLIENTS_SKIP) {
		*offsetp += v;
		*last_usedp = 0;
	} else {
		if (v <= DCC_ADMIN_CLIENTS_MAX_DELTA)
			v += *prev_last_usedp;
		*prev_last_usedp = v;
		*last_usedp = v;
	}

	if (flags & DCC_ADMN_RESP_CLIENTS_ANON)
		v = DCC_ID_ANON;
	else
		cp = client_unpack64(cp, &v);
	*clnt_idp = v;

	cp = client_unpack64(cp, reqsp);
	cp = client_unpack64(cp, nopsp);

	if (flags & DCC_ADMN_RESP_CLIENTS_IPV6) {
		memcpy(&in6_addr, cp, sizeof(in6_addr));
		dcc_mk_inet6_su(su, &in6_addr, 0, 0);
		cp += 16;
	} else {
		memcpy(&in_addr, cp, sizeof(in_addr));
		dcc_mk_inet_su(su, &in_addr, 0);
		cp += 4;
	}

	return cp - cp0;
}



typedef struct ct {
    struct ct	*lt, *gt;	/* sorted order */
    DCC_PTIME	last_used;
    DCC_SCNTR	reqs;
    DCC_SCNTR	nops;
    u_char	fgs;
#    define CT_FG_EARLY	    0x01
#    define CT_FG_BLACK	    0x02
#    define CT_FG_DROPPED   0x04
#    define CT_FG_BLOCK	    0x08
    u_char	vers;
    DCC_CLNT_ID	clnt_id;
    DCC_SOCKU	su;
} CT;

static void
print_ct_id(const CT *ct)
{
	char buf[22+1];
	DCC_CLNT_ID id;

	id = ct->clnt_id & ~DCC_ADMN_RESP_CLIENTS_NO_AUTH;
	if (id == DCC_ID_CLIENTS_MULT) {
		strcpy(buf, "multi");
	} else if (id == DCC_ID_SRVR_ROGUE) {
		strcpy(buf, "server");
	} else {
		snprintf(buf, sizeof(buf), "%d", id);
	}
	if (ct->clnt_id & DCC_ADMN_RESP_CLIENTS_NO_AUTH)
		STRLCAT(buf, "*", sizeof(buf));
	printf(" %6s", buf);
}



/* get the server's list of recent clients */
static int
clients_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	u_char nonames, sort, ids, req_flags;
	DCC_CLNT_ID tgt_id;
	u_char passed_flags, passed_max_clients, passed_thold, passed_cidr;
	struct in6_addr addr6;
	DCC_AOP_CLIENTS_VAL5 val5;
	u_int val5_len;
	u_int max_clients, thold;
	u_int total, subtotal;
	DCC_SCNTR max_ops, max_nops;
	int ops_width, nops_width;
	u_int offset;			/* next client wanted from server */
	u_int num_clients, list_len;
	DCC_SOCKU su;
	CT *cttop, *ctbot, *ctnew, *ct;
	struct {
		u_int	    clients;
		DCC_SCNTR   reqs;
		DCC_SCNTR   nops;
		DCC_SCNTR   black_reqs;
		DCC_SCNTR   black_nops;
	} totals[DCC_PKT_VERS_NOP_MAX+1];
	char date_buf[40];
	struct tm last, now;
	char *p;
	const char *ac;
	u_char need_head;
	u_int n;
	int i;

	passed_flags = 0;
	thold = 0;
	passed_thold = 0;
	max_clients = DCC_ADMIN_RESP_MAX_CLIENTS;
	passed_max_clients = 0;
	passed_cidr = 0;
	memset(&val5, 0, sizeof(val5));
	val5_len = 0;

	ac = strpbrk(arg, "/.:");

	/* look for "-n", "-ns", "-n -s", etc. */
	nonames = 0;
	sort = 0;
	ids = 0;
	tgt_id = DCC_ID_INVALID;
	req_flags = 0;
	while (*arg != 0) {
		arg += strspn(arg, " \t");
		if (*arg == '-' && !passed_flags) {
			++arg;
			do {
				switch (*arg) {
				case 'n':
					nonames = 1;
					break;
				case 's':
					sort = 1;
					break;
				case 'i':
					ids = 1;
					break;
				case 'I':
					arg += 1+strspn(arg+1, " \t");
					tgt_id = strtoul(arg, &p, 10);
					if (tgt_id < DCC_SRVR_ID_MIN
					    || tgt_id > DCC_CLNT_ID_MAX
					    || (*p != '\0' && *p != ' '
						&& *p != '\t')) {
					    help_cmd("clients", 0);
					    return -1;
					}
					arg = p-1;
					break;
				case 'a':
					req_flags |= DCC_AOP_CLIENTS_AVG;
					break;
				case 'V':
					req_flags |= DCC_AOP_CLIENTS_VERS;
					break;
				case 'A':
					req_flags |= DCC_AOP_CLIENTS_ANON;
					req_flags &= ~DCC_AOP_CLIENTS_NON_ANON;
					break;
				case 'K':
					req_flags |= DCC_AOP_CLIENTS_NON_ANON;
					req_flags &= ~DCC_AOP_CLIENTS_ANON;
					break;
				default:
					help_cmd("clients", 0);
					return -1;
				}
			} while (*++arg != ' ' && *arg != '\t' && *arg != '\0');
			continue;
		}
		if (!passed_cidr && ac && !strpbrk(arg, DCC_WHITESPACE)) {
			int bits;

			bits = str2cidr(0,  &addr6, 0, arg);
			if (bits <= 0)
				return -1;
			memcpy(val5.tgt_addr.addr6, &addr6, sizeof(addr6));
			val5.tgt_addr.bits = bits;
			if (val5_len < sizeof(val5.tgt_addr))
				val5_len = sizeof(val5.tgt_addr);
			arg = "";
			passed_cidr = 1;
			passed_flags = 1;
			passed_max_clients = 1;
			passed_thold = 1;
			continue;
		}
		if (!passed_max_clients
		    && (i = strtoul(arg, &p, 10)) != 0
		    && (*p == ' ' || *p == '\t' || *p == '\0')) {
			max_clients = i;
			arg = p;
			passed_max_clients = 1;
			passed_flags = 1;
			continue;
		}
		if (!passed_thold
		    && (i = strtoul(arg, &p, 10)) > 0
		    && (*p == ' ' || *p == '\t' || *p == '\0')
		    && i <= DCC_ADMIN_CLIENTS_MAX_THOLD) {
			thold = i;
			arg = p;
			passed_thold = 1;
			passed_max_clients = 1;
			passed_flags = 1;
			continue;
		}
		help_cmd("clients", 0);
		return -1;
	}

	if (ids)
		req_flags &= ~DCC_AOP_CLIENTS_VERS;

	/* decide which server to use and its protocol */
	if (!rdy_ctxt(0))
		return 0;
	if (tgt_id != DCC_ID_INVALID) {
		const DCC_SRVR_CLASS *class;
		SRVR_INX srvr_inx;
		DCC_CLNT_ID tgt_id_net;

		dcc_ctxts_lock();
		if (!dcc_info_lock(0)) {
			dcc_ctxts_lock();
			return 0;
		}
		class = DCC_GREY2CLASS(grey_on);
		srvr_inx = class->srvr_inx;
		if (VALID_SRVR(class, srvr_inx)
		    && class->addrs[srvr_inx].srvr_pkt_vers >= DCC_PKT_VERS12) {
			tgt_id_net = htonl(tgt_id);
			memcpy(&val5.tgt_id, &tgt_id_net, sizeof(val5.tgt_id));
			val5_len = sizeof(DCC_AOP_CLIENTS_VAL5);
		}
		if (!cdcc_unlock(1))
			return 0;
	}

	/* Collect all of the information before printing it to minimize
	 * the changes in the position of hosts and so deleted or missing
	 * entries. */
	total = 0;
	subtotal = 0;
	max_ops = 0;
	max_nops = 0;
	memset(totals, 0, sizeof(totals));
	offset = 0;
	num_clients = 0;
	list_len = 0;
	cttop = 0;
	ctbot = 0;
	for (;;) {
		DCC_OPS result;
		int done, result_len;
		u_char vers;
		DCC_ADMN_RESP_CLIENTS_FLAGS resp_flags;
		DCC_CLNT_ID clnt_id;
		DCC_PTIME last_used;
		DCC_PTIME prev_last_used;
		DCC_SCNTR reqs, nops;

		if (offset > DCC_AOP_CLIENTS_MAX_OFFSET) {
			dcc_error_msg("%d are too many clients", offset);
			break;
		}

		gettimeofday(&op_start, 0);
		result = dcc_aop(&dcc_emsg, ctxt, grey_clnt_fgs,
				 NO_SRVR, clock_kludge,
				 ids ? DCC_AOP_CLIENTS_ID : DCC_AOP_CLIENTS,
				 (offset << 16) + thold,
				 ISZ(aop_resp.resp.val.string
				     ) >> DCC_ADMIN_CLIENTS_SHIFT,
				 req_flags,
				 offset >> 16,
				 &val5, val5_len,
				 &aop_resp, &op_result_su);
		if (result == DCC_OP_INVALID || result == DCC_OP_ERROR) {
			cdcc_error_msg("%s", dcc_emsg.c);
			break;
		}

		/* print heading before the first chunk */
		if (!offset)
			print_aop(NO_SRVR);

		result_len = (ntohs(aop_resp.hdr.len)
			      - (sizeof(aop_resp.resp)
				 - sizeof(aop_resp.resp.val.string)));
		/* stop when the server had nothing to add */
		if (result_len <= 1)
			break;

		done = 0;
		vers = 0;
		prev_last_used = 0;
		do {
			done += client_unpack(&aop_resp.resp.val.clients[done],
					      &resp_flags, &clnt_id, &offset,
					      &last_used, &prev_last_used,
					      &reqs, &nops, &vers, &su);
			if (resp_flags & DCC_ADMN_RESP_CLIENTS_SKIP)
				continue;

			/* quit if we are in some kind of loop */
			if (++num_clients > DCC_ADMIN_RESP_MAX_CLIENTS) {
				dcc_error_msg("assume looping after %d"
					      " responses", num_clients);
				goto stop;
			}
			++offset;

			/* forget this entry if it is for the wrong ID */
			if (tgt_id != DCC_ID_INVALID
			    && tgt_id != (clnt_id
					  & ~DCC_ADMN_RESP_CLIENTS_NO_AUTH))
				continue;

			/* add the new entry to the possibly sorted list */

			if (list_len <= max_clients) {
				ctnew = dcc_malloc(sizeof(*ctnew));
			} else {
				ctnew = ctbot;
				ctbot = ctbot->gt;
				if (ctbot)
					ctbot->lt = 0;
				--list_len;
			}
			memset(ctnew, 0, sizeof(*ctnew));
			ctnew->vers = vers;
			ctnew->clnt_id = clnt_id;
			ctnew->last_used = last_used;
			ctnew->reqs = reqs;

			if (resp_flags & DCC_ADMN_RESP_CLIENTS_DROPPED)
				ctnew->fgs |= (CT_FG_EARLY | CT_FG_DROPPED);
			if (resp_flags & DCC_ADMN_RESP_CLIENTS_BLOCK)
				ctnew->fgs |= CT_FG_BLOCK;
			if (resp_flags & DCC_ADMN_RESP_CLIENTS_BLACK) {
				ctnew->fgs |= (CT_FG_EARLY | CT_FG_BLACK);
				/* clients in blacklisted address blocks
				 * are not reported separately */
				if (vers < DIM(totals)) {
					++totals[vers].clients;
					totals[vers].black_reqs += reqs;
					totals[vers].black_nops += nops;
				} else {
					++totals[0].clients;
					totals[0].reqs += reqs;
					totals[0].nops += nops;
				}
			}
			if (vers != DCC_PKT_VERS_INVALID
			    && vers != DCC_PKT_VERS_MULTI
			    && !(resp_flags & DCC_ADMN_RESP_CLIENTS_BLOCK)
			    && !(resp_flags & DCC_ADMN_RESP_CLIENTS_BLACK)) {
				if (vers < DIM(totals)) {
					++totals[vers].clients;
					totals[vers].reqs += reqs;
					totals[vers].nops += nops;
				} else {
					++totals[0].clients;
					totals[0].reqs += reqs;
					totals[0].nops += nops;
				}
			}

			total += reqs;
			if (max_ops < reqs)
				max_ops = reqs;
			ctnew->nops = nops;
			if (max_nops < nops)
				max_nops = nops;
			ctnew->su = su;

			ct = ctbot;
			n = list_len;
			while (ct) {
				if (!sort
				    || ((ct->fgs & CT_FG_EARLY)
					&& !(ctnew->fgs & CT_FG_EARLY))
				    || (!((ct->fgs ^ ctnew->fgs) & CT_FG_EARLY)
					&& ct->reqs >= ctnew->reqs))
					break;

				/* We will insert the new entry above this one
				 * in the sorted list.
				 * Increase the theshold for next batch from
				 * the server if we have enough entries */
				if (--n >= max_clients
				    && thold < ct->reqs
				    && thold > 1)
					thold = min(ct->reqs,
						    DCC_ADMIN_CLIENTS_MAX_THOLD);
				ct = ct->gt;
			}
			if (!ct) {
				ctnew->lt = cttop;
				if (cttop) {
					cttop->gt = ctnew;
				} else {
					ctbot = ctnew;
				}
				cttop = ctnew;
			} else {
				ctnew->gt = ct;
				ctnew->lt = ct->lt;
				if (ct->lt)
					ct->lt->gt = ctnew;
				else
					ctbot = ctnew;
				ct->lt = ctnew;
			}
			++list_len;
		} while (done < result_len);
		if (done != result_len) {
			dcc_error_msg("wrong sized clients response; %d != %d",
				      result_len, done);
			break;
		}

		/* quit if the server ran out of things to say */
		if (resp_flags & DCC_ADMN_RESP_CLIENTS_LAST)
			break;

		/* Quit if we want only part of the list and we have it.
		 * We must get everything the server sends if we are sorting.
		 * The server uses our threshold to avoid sending everything
		 * it knows. */
		if (!sort && offset >= max_clients)
			break;
	}
stop:
	if (!total)
		total = 1;

	dcc_localtime(time(0), &now);

	if (max_ops > 99*1000*1000)
		ops_width = 9;
	else if (max_ops > 9*1000*1000)
		ops_width = 8;
	else
		ops_width = 7;
	if (max_nops > 99*1000)
		nops_width = 6;
	else if (max_nops > 9*1000)
		nops_width = 5;
	else
		nops_width = 4;

	/* print the list */
	num_clients = 0;
	for (ct = cttop; ct; ct = ctnew) {
		ctnew = ct->lt;
		if (num_clients == 0) {
			if (sort) {
				printf("          %*s %*s ",
				       ops_width, "ops",
				       nops_width, "nops");
				if (ids)
					fputs("   ID ", stdout);
				fputs("   last       ", stdout);
				if (req_flags & DCC_AOP_CLIENTS_VERS)
					fputs("  v", stdout);
			} else {
				printf("%*s %*s    last           ID ",
				       ops_width, "ops",
				       nops_width, "nops");
				if (req_flags & DCC_AOP_CLIENTS_VERS)
					fputs("  v", stdout);
			}
			putchar('\n');
		}
		if (++num_clients <= max_clients) {
			if (sort) {
				subtotal += ct->reqs;
				printf("%3d%% %3d%% ",
				       (int)(ct->reqs*100.0/total),
				       (int)(subtotal*100.0/total));
			}
			printf(L_DWPAT(*)" "L_DWPAT(*),
			       ops_width, ct->reqs,
			       nops_width, ct->nops);
			if (sort && ids)
				print_ct_id(ct);
			/* print year and no time if it was long ago */
			dcc_localtime(ct->last_used, &last);
			if (last.tm_year != now.tm_year
			    && (last.tm_mon < 6 || now.tm_mon > 2))
				dcc_time2str(date_buf, sizeof(date_buf),
					     " %Y/%m/%d    ", ct->last_used);
			else
				dcc_time2str(date_buf, sizeof(date_buf),
					     " %m/%d %X", ct->last_used);
			fputs(date_buf, stdout);
			if (!sort)
				print_ct_id(ct);
			if (req_flags & DCC_AOP_CLIENTS_VERS) {
				if ((ct->fgs & CT_FG_BLOCK)
				    && ct->vers == DCC_PKT_VERS_MULTI)
					printf(" %2s", "m");
				else if (ct->vers == DCC_PKT_VERS_INVALID)
					printf(" %2s", "");
				else
					printf(" %2d", ct->vers);
			}
			if (ct->fgs & CT_FG_BLACK) {
				fputs(" BLACKLIST", stdout);
				n = 16-LITZ(" BLACKLIST");
			} else if (ct->fgs & CT_FG_DROPPED) {
				fputs(" BAD", stdout);
				n = 16-LITZ(" BAD");
			} else {
				n = 16;
			}
			if (!ids) {
				char name[DCC_MAXDOMAINLEN];
				char sustr[DCC_SU2STR_SIZE];

				dcc_su2str2(sustr, sizeof(sustr), &ct->su);
				if (ct->fgs & CT_FG_BLOCK) {
					if (ct->su.sa.sa_family == AF_INET)
					    i = DCC_ADMN_RESP_CLIENTS_IPV4_BITS;
					else
					    i = DCC_ADMN_RESP_CLIENTS_IPV6_BITS;
					printf(" %s/%d", sustr, i);
				} else if (nonames) {
					printf(" %s", sustr);
				} else {
					printf(" %-*s %s", n, sustr,
					       dcc_su2name(name,
							sizeof(name), &ct->su));
				}
			}
			putchar('\n');
		}

		memset(ct, 0, sizeof(*ct));
		dcc_free(ct);
	}
	putchar('\n');


	need_head = 1;
	for (i = 0; i < DIM(totals); ++i) {
		if (totals[i].clients == 0)
			continue;
		if (need_head) {
			need_head = 0;
			fputs("                               blacklisted\n",
			      stdout);
			fputs("version requests     nops   requests     nops\n",
			      stdout);
			/*     dddddd  dddddddd dddddddd   dddddddd dddddddd */
		}
		/* do not show numbers of clients because our number is
		 * wrong for blacklisted address blocks */
		printf("%6d  "
		       L_DWPAT(8)" "L_DWPAT(8)"   "L_DWPAT(8)" "L_DWPAT(8)"\n",
		       i,
		       totals[i].reqs, totals[i].nops,
		       totals[i].black_reqs, totals[i].black_nops);
	}
	if (!need_head)
		putchar('\n');

	return 1;
}



/* get and set the server's default anonymous client delay */
static int
anon_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	int new_delay, old_delay, inflate;
	DCC_OPS result;
	char *inflate_str, *p;

	inflate = 0;
	if (*arg == '\0') {
		new_delay = DCC_NO_ANON_DELAY;
	} else {
		if (!strcasecmp(arg, "forever")) {
			new_delay = DCC_ANON_DELAY_FOREVER;
		} else {
			new_delay = strtoul(arg, &inflate_str, 10);
			if (new_delay > DCC_ANON_DELAY_MAX
			    || (*inflate_str != '\0' && *inflate_str != ','
				&& *inflate_str != '*')) {
				dcc_error_msg("invalid delay: \"%s\"", arg);
				return 0;
			}
			if (*inflate_str != '\0') {
				++inflate_str;
				inflate_str += strspn(inflate_str,
						      DCC_WHITESPACE);
			}
			if (*inflate_str != '\0'
			    && strcasecmp(inflate_str, "none")) {
				inflate = strtoul(inflate_str, &p, 10);
				if (*p != '\0') {
					dcc_error_msg("invalid delay inflation:"
						      " \"%s\"", inflate_str);
					return 0;
				}
			}
		}
		if (!ck_cmd_priv(ce, 1, 0))
			return 0;
	}

	if (!rdy_ctxt(0))
		return 0;

	gettimeofday(&op_start, 0);
	result = dcc_aop(&dcc_emsg, ctxt, grey_clnt_fgs,
			 NO_SRVR, clock_kludge, DCC_AOP_ANON_DELAY,
			 inflate, new_delay>>8, new_delay, 0, 0, 0,
			 &aop_resp, &op_result_su);
	if (result == DCC_OP_INVALID
	    || result == DCC_OP_ERROR) {
		cdcc_error_msg("%s", dcc_emsg.c);
		return 0;
	}

	old_delay = ((aop_resp.resp.val.anon_delay.delay[0]<<8)
		     + aop_resp.resp.val.anon_delay.delay[1]);
	if (old_delay == DCC_ANON_DELAY_FOREVER) {
		printf("    anon delay %s FOREVER\n",
		       new_delay != DCC_NO_ANON_DELAY ? "was" : "is");
	} else {
		printf("    anon delay %s %d",
		       new_delay != DCC_NO_ANON_DELAY ? "was" : "is",
		       old_delay);
		inflate = ((aop_resp.resp.val.anon_delay.inflate[0]<<24)
			   +(aop_resp.resp.val.anon_delay.inflate[1]<<16)
			   +(aop_resp.resp.val.anon_delay.inflate[2]<<8)
			   +aop_resp.resp.val.anon_delay.inflate[3]);
		if (inflate != 0)
			printf(",%d", inflate);
		putchar('\n');
	}
	return 1;
}



/* rewind the flood from a single server */
static int
flod_rewind(const char *arg DCC_UNUSED, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_CLNT_ID id;

	if (!arg)
		return -1;
	id = dcc_get_id(0, arg, 0, 0);
	if (id == DCC_ID_INVALID)
		return -1;

	return do_aop(DCC_AOP_FLOD, id*256 + DCC_AOP_FLOD_REWIND, NO_SRVR, 1);
}



/* fast forward the flood to a single server */
static int
ffwd_out(const char *arg DCC_UNUSED, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_CLNT_ID id;

	if (!arg)
		return -1;
	id = dcc_get_id(0, arg, 0, 0);
	if (id == DCC_ID_INVALID)
		return -1;

	return do_aop(DCC_AOP_FLOD, id*256 + DCC_AOP_FLOD_FFWD_OUT, NO_SRVR, 1);
}



/* fast forward the flood to a single server */
static int
ffwd_in(const char *arg DCC_UNUSED, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_CLNT_ID id;

	if (!arg)
		return -1;
	id = dcc_get_id(0, arg, 0, 0);
	if (id == DCC_ID_INVALID)
		return -1;

	return do_aop(DCC_AOP_FLOD, id*256 + DCC_AOP_FLOD_FFWD_IN, NO_SRVR, 1);
}



/* get the flood counts for a server */
static int
flod_stats(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_AOP_FLODS op;
	char id_buf[12];
	u_char all;
	u_int32_t id, next_id;
	u_char heading;
	int sresult;

	if (!arg)
		return -1;

	op = DCC_AOP_FLOD_STATS;
	id = DCC_ID_INVALID;
	all = 0;
	while (*arg != '\0') {
		arg = dcc_parse_word(&dcc_emsg, id_buf, sizeof(id_buf),
				     arg, "server-ID", 0, 0);
		if (!arg) {
			dcc_error_msg("%s", dcc_emsg.c);
			return 0;
		}
		if (!all && id == DCC_ID_INVALID
		    && id_buf[0] >= '1' && id_buf[0] <= '9') {
			id = dcc_get_id(&dcc_emsg, id_buf, 0, 0);
			if (id != DCC_ID_INVALID)
				continue;
		}
		if (id == DCC_ID_INVALID && !strcasecmp(id_buf, "all")) {
			all = 1;
			continue;
		}
		if (!strcasecmp(id_buf, "clear")) {
			op = DCC_AOP_FLOD_STATS_CLEAR;
			continue;
		}

		return -1;
	}
	if (!all && id == DCC_ID_INVALID)
		all = 1;

	heading = 1;
	if (all) {
		id = DCC_SRVR_ID_MAX+1;
		for (;;) {
			if (!start_aop(DCC_AOP_FLOD, id*256 + op, NO_SRVR))
				return 0;
			sresult = sscanf(aop_resp.resp.val.string,
					 DCC_AOP_FLOD_STATS_ID, &next_id);
			if (1 == sresult
			    && id == next_id) {
				if (id == DCC_SRVR_ID_MAX+1) {
					BUFCPY(aop_resp.resp.val.string,
					       " (no flooding peers)");
					fin_aop(NO_SRVR, 1);
				}
				return 1;
			}
			fin_aop(NO_SRVR, heading);
			heading = 0;
			if (1 != sresult)
				return 0;
			id = next_id+DCC_SRVR_ID_MAX+1;
		}
	}

	return do_aop(DCC_AOP_FLOD, id*256 + op, NO_SRVR, heading);
}



/* get the statistics from all known servers */
static int
stats_cmd(const char *arg, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	DCC_SRVR_CLASS *class;
	SRVR_INX srvr_inx;
	int srvrs_gen;
	DCC_AOPS aop;

	/* look for "clear" or "clear all" */
	srvr_inx = NO_SRVR;
	aop = DCC_AOP_STATS;
	while (*arg != 0) {
		arg += strspn(arg, " \t");
		if (srvr_inx == NO_SRVR
		    && !CLITCMP(arg, "clear")) {
			arg += LITZ("clear");
			aop = DCC_AOP_STATS_CLEAR;
			if (!get_passwd(3, "stats clear", "operation"))
				return 0;
		} else if (aop == DCC_AOP_STATS && !CLITCMP(arg, "all")) {
			arg += LITZ("all");
			srvr_inx = 0;
		}
		if (*arg != '\0' && *arg != ' ' && *arg != '\t')
			return -1;
	}

	if (!get_passwd(1, "stats clear", "operation"))
		return 0;
	if (!rdy_ctxt(0))
		return 0;
	class = DCC_GREY2CLASS(grey_on);
	srvrs_gen = class->gen;
	do {
		if (srvrs_gen != class->gen) {
			dcc_error_msg("list of servers changed");
			return 0;
		}
		/* skip servers that have never answered a NOP */
		if (srvr_inx != NO_SRVR
		    && class->addrs[srvr_inx].srvr_id == DCC_ID_INVALID )
			continue;

		do_aop(aop, sizeof(aop_resp.resp.val.string), srvr_inx, 1);
		fflush(stderr);
		fflush(stdout);
	} while (srvr_inx != NO_SRVR && ++srvr_inx < class->num_srvrs);

	return 1;
}



static int
clock_ck_cmd(const char *arg DCC_UNUSED, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	do_aop(DCC_AOP_CLOCK_CHECK, sizeof(aop_resp.resp.val.string),
	       NO_SRVR, 1);

	return 1;
}



/* restore tracing to default */
static int
trace_def(const char *arg DCC_UNUSED, const CMD_TBL_ENTRY *ce DCC_UNUSED)
{
	return (do_aop(DCC_AOP_TRACE_ON,
		       grey_on ? DCC_TRACE_GREY_DEF : DCC_TRACE_DEF,
		       NO_SRVR, 1)
		&& do_aop(DCC_AOP_TRACE_OFF,
			  DCC_TRACE_BITS
			  & ~(grey_on ? DCC_TRACE_GREY_DEF : DCC_TRACE_DEF),
			  NO_SRVR, 1));
}
