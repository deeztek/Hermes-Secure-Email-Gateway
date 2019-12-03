/* Distributed Checksum Clearinghouse
 *
 * threaded version of client library
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
 * Rhyolite Software DCC 2.3.167-1.182 $Revision$
 */


#include "cmn_defs.h"
#include "dcc_paths.h"

CMN_ACTION action = CMN_REJECT;

CHGHDR chghdr = SETHDR;

const char *userdirs;
static DCC_PATH userdirs_path;
static int userdirs_len;

u_char dcc_query_only;
u_char try_extra_hard;			/* 0 or DCC_CLNT_FG_NO_FAIL */
u_char to_white_only;

u_int dcc_ctxt_sn = 1;			/* change X-DCC header server name */

const char *max_max_work_src = "FD_SETSIZE limit";
int max_work;
int init_work;
int total_work;

static int total_rcpt_sts;
RCPT_ST *rcpt_st_free;

/* cwf_mutex protects all CWF structures as well as the cmn_wf structure */
typedef struct cwf {			/* private whitelist state */
    struct cwf *older, *newer;
    WF	    wf;
} CWF;
static CWF *cur_cwf, cwfs[DCC_NUM_CWFS];

/* protected by user_log_mutex */
static int user_log_fd = -1;
static int log_fd2 = -1;


/* the work lock must be held or not yet exist */
static void
add_rcpt_sts(int i)
{
	RCPT_ST *rcpt_st;

	total_rcpt_sts += i;

	rcpt_st = dcc_malloc(sizeof(*rcpt_st)*i);
	memset(rcpt_st, 0, sizeof(*rcpt_st)*i);

	while (i-- != 0) {
		rcpt_st->fwd = rcpt_st_free;
		rcpt_st_free = rcpt_st;
		++rcpt_st;
	}
}



void
cmn_init(void)
{
	init_work = 50;
	if (init_work > max_max_work)
		init_work = max_max_work;
	add_rcpt_sts(init_work);

	finish_replies();

	/* start the client library threads and locks */
	dcc_clnt_thread_init();
	for (cur_cwf = cwfs; cur_cwf <= LAST(cwfs); ++cur_cwf) {
		cur_cwf->newer = cur_cwf-1;
		cur_cwf->older = cur_cwf+1;
		wf_init(&cur_cwf->wf, WF_PER_USER);
	}
	cur_cwf = cwfs;
	LAST(cwfs)->older = cur_cwf;
	cur_cwf->newer = LAST(cwfs);

	totals_init();
}



void
cmn_create(CMN_WORK *cwp)
{
	cwp->tmp_fd = -1;
	cwp->log_fd = -1;
}



u_char
cmn_open_tmp(CMN_WORK *cwp)
{
	cwp->tmp_fd = dcc_mkstemp(&cwp->emsg, &cwp->tmp_nm,
				  cwp->id, sizeof(cwp->id),
				  0, 0, DCC_TMP_LOG_PREFIX, 1, 0);

	return cwp->tmp_fd >= 0;
}



void
cmn_close_tmp(CMN_WORK *cwp)
{
	if (cwp->tmp_fd >= 0) {
		if (0 > close(cwp->tmp_fd))
			thr_error_msg(cwp, "close(%s): %s",
				      cwp->tmp_nm.c, ERROR_STR());
		cwp->tmp_fd = -1;
	}
	cwp->tmp_nm.c[0] = '\0';
}



u_char
cmn_write_tmp(CMN_WORK *cwp, const void *buf, int len)
{
	int i;

	if (cwp->tmp_fd < 0)
		return 1;

	i = write(cwp->tmp_fd, buf, len);
	if (i == len)
		return 1;

	if (i < 0)
		thr_error_msg(cwp, "write(%s,%d): %s",
			      cwp->tmp_nm.c, len, ERROR_STR());
	else
		thr_error_msg(cwp, "write(%s,%d)=%d",
			      cwp->tmp_nm.c, len, i);
	cmn_close_tmp(cwp);
	return 0;
}



/* If the immediate SMTP client is a listed MX server,
 *	then we must ignore its IP address and keep looking for the
 *	real SMTP client. */
void
check_mx_listing(CMN_WORK *cwp)
{
	DCC_TGTS tgts;
	u_char result;

	if (cwp->sender_str[0] == '\0') {
		cwp->cmn_fgs |= CMN_FG_PARSE_RCVD;
		return;
	}

	lock_wf();
	result = white_mx(&cwp->emsg, &tgts, &cwp->cks);
	unlock_wf();
	if (!result) {
		thr_error_msg(cwp, "%s", cwp->emsg.c);
		return;
	}

	if (tgts == DCC_TGTS_OK) {
		/* do not tell the server about the IP address */
		no_ip_rpt2srvr(&cwp->cks);
		cwp->cmn_fgs &= ~CMN_FG_PARSE_RCVD;
		return;
	}

	if (tgts == DCC_TGTS_SUBMIT_CLIENT) {
		/* Common SMTP submission clients are too dumb to do the
		 * right thing with 4yz rejections of individual Rcpt_To
		 * commands.  So reject the message for all or no recipients. */
		cwp->cmn_fgs |= CMN_FG_VIA_SUBMIT;
		thr_log_print(cwp, 1,
			      "%s is a listed 'submit' client\n",
			      dcc_trim_ffff(cwp->sender_str));
		/* do not tell the server about the IP address */
		no_ip_rpt2srvr(&cwp->cks);
		cwp->cmn_fgs &= ~CMN_FG_PARSE_RCVD;
		return;
	}

	if (tgts == DCC_TGTS_OK_MXDCC) {
		thr_log_print(cwp, 1,
			      "%s is a whitelisted MX server with DCC client\n",
			      dcc_trim_ffff(cwp->sender_str));
		cwp->ask_st |= ASK_ST_QUERY;

	} else if (tgts == DCC_TGTS_OK_MX) {
		thr_log_print(cwp, 1, "%s is a whitelisted MX server\n",
			      dcc_trim_ffff(cwp->sender_str));

	} else {
		/* not listed */
		cwp->cmn_fgs &= ~CMN_FG_PARSE_RCVD;
		return;
	}

	/* we should not greylist or reject through our MX servers */
	cwp->cmn_fgs |= (CMN_FG_VIA_MX | CMN_FG_PARSE_RCVD);
	if (cwp->action == CMN_REJECT)
		cwp->action = CMN_DISCARD;

	no_ip_rpt2srvr(&cwp->cks);
}



/* clear a common work area for a message, possibly not the first
 * in the session */
void
cmn_clear(CMN_WORK *cwp, struct work *wp,
	  u_char new_conn)		/* 1=first message for the connection */
{
	log_stop(cwp);

	cmn_close_tmp(cwp);

	if (cwp->num_rcpts)
		free_rcpt_sts(cwp, 1);

	memset(&cwp->CMN_WORK_ZERO, 0,
	       sizeof(*cwp) - ((char*)&cwp->CMN_WORK_ZERO - (char*)cwp));
	cwp->cmn_fgs = CMN_FG_LOG_EARLY;
	cwp->mail_host[0] = '\0';
	cwp->env_from[0] = '\0';
	cwp->early_log.len = 0;
	cwp->emsg.c[0] = '\0';
	cwp->id[0] = '\0';
	cwp->header.used = 0;
	if (dcc_query_only)
		cwp->ask_st |= (ASK_ST_QUERY | ASK_ST_QUERY_GREY);
	cwp->action = action;

	if (new_conn) {
		cwp->wp = wp;
		cwp->helo[0] = '\0';
		cwp->clnt_name[0] = '\0';
		cwp->clnt_str[0] = '\0';
	} else {
		/* assume for now that the sender is the current SMTP client */
		strcpy(cwp->sender_name, cwp->clnt_name);
		strcpy(cwp->sender_str, cwp->clnt_str);
	}
}



/* free all of the per-recipient state for a message */
void
free_rcpt_sts(CMN_WORK *cwp, u_char need_lock)
{
	RCPT_ST *rcpt_st, *next_rcpt_st;

	rcpt_st = cwp->rcpt_st_first;
	if (!rcpt_st)
		return;

	if (need_lock)
		lock_work();
	cwp->rcpt_st_first = 0;
	do {
		next_rcpt_st = rcpt_st->fwd;
		rcpt_st->fwd = rcpt_st_free;
		rcpt_st_free = rcpt_st;
	} while ((rcpt_st = next_rcpt_st) != 0);
	cwp->num_rcpts = 0;

	if (need_lock)
		unlock_work();
}



RCPT_ST *
alloc_rcpt_st(CMN_WORK *cwp,
	   u_char unlocked)		/* 1=unlocked on entry & exit */
{
	RCPT_ST *rcpt_st;

	if (cwp->num_rcpts >= MAX_RCPTS) {
		thr_error_msg(cwp, "too many recipients");
		return 0;
	}

	if (unlocked)
		lock_work();
	rcpt_st = rcpt_st_free;
	if (!rcpt_st) {
		if (dcc_clnt_debug > 1)
			thr_trace_msg(cwp,
				      "add %d recipient blocks to %d",
				      init_work, total_rcpt_sts);
		add_rcpt_sts(init_work);
		rcpt_st = rcpt_st_free;
	}
	rcpt_st_free = rcpt_st->fwd;
	if (unlocked)
		unlock_work();

	rcpt_st->fwd = 0;
	rcpt_st->log_pos_white = -1;
	rcpt_st->log_pos_to = -1;
	memset(&rcpt_st->wtgts, 0, sizeof(rcpt_st->wtgts));
	rcpt_st->env_to_tgts = 0;
	rcpt_st->user_tgts = 0;
	rcpt_st->grey_result = ASK_GREY_OFF;
	rcpt_st->embargo_num = 0;
	rcpt_st->fgs = 0;
	rcpt_st->global_env_to_fgs = 0;
	rcpt_st->env_to_fgs = 0;
	rcpt_st->sws = 0;
	rcpt_st->user[0] = '\0';
	rcpt_st->rej_msg[0] = '\0';
	rcpt_st->dir.c[0] = '\0';
	rcpt_st->user_log_nm.c[0] = '\0';

	rcpt_st->cwp = cwp;
	if (!cwp->rcpt_st_first) {
		cwp->rcpt_st_first = rcpt_st;
	} else {
		cwp->rcpt_st_last->fwd = rcpt_st;
	}
	cwp->rcpt_st_last = rcpt_st;
	++cwp->num_rcpts;

	return rcpt_st;
}



void
parse_userdirs(const char *arg)
{
	/* add '/' to end of the path without converting it to "/" */
	if (*arg == '\0') {
		userdirs_path.c[0] = '\0';
		userdirs_len = 0;
	} else {
		STRLCPY(userdirs_path.c, arg,
			sizeof(userdirs_path));
		userdirs_len = strlen(userdirs_path.c)-1;
		while (userdirs_len > 1 && userdirs_path.c[userdirs_len] == '/')
			--userdirs_len;
		userdirs_path.c[++userdirs_len] = '/';
		userdirs_path.c[++userdirs_len] = '\0';

	}
	userdirs = userdirs_path.c;
}



/* sanitize recipient mailbox and per-user log and whitelist directory */
u_char					/* 0=complain about something */
get_user_dir(RCPT_ST *rcpt_st,
	     const char *str1, int str1_len, const char *str2, int str2_len)
{
	char *p;
	char c;
	u_char seen_slash;
	int dots;
	int i;

	if (!userdirs) {
		rcpt_st->dir.c[0] = '\0';
		return 1;
	}

	memcpy(rcpt_st->dir.c, userdirs, userdirs_len);
	i = userdirs_len;
	if (i+str1_len < ISZ(rcpt_st->dir))
		memcpy(&rcpt_st->dir.c[i], str1, str1_len);
	i += str1_len;
	if (str2) {
		if (i+str2_len+1 < ISZ(rcpt_st->dir)) {
			rcpt_st->dir.c[i++] = '/';
			memcpy(&rcpt_st->dir.c[i], str2, str2_len);
		}
		i += str2_len;
	}
	if (i >= ISZ(rcpt_st->dir)) {
		dcc_pemsg(EX_DATAERR, &rcpt_st->cwp->emsg,
			  "recipient \"%s\" is too long", rcpt_st->dir.c);
		rcpt_st->dir.c[0] = '\0';
		return 0;
	}
	rcpt_st->dir.c[i] = '\0';

	/* To get a consistent directory name,
	 * convert ASCII upper to lower case.
	 * Be simplistic about international character sets and
	 * avoid locale and portability complications.
	 * Refuse insecure paths. */
	seen_slash = 1;			/* userdirs ends with '/' */
	dots = 0;
	p = &rcpt_st->dir.c[userdirs_len];
	for (;;) {
		c = *p;
		if (c == '/' || c == '\\' || c == '\0') {
			if (dots == 2) {
				dcc_pemsg(EX_DATAERR, &rcpt_st->cwp->emsg,
					  "path \"%s\" is insecure",
					  rcpt_st->dir.c);
				rcpt_st->dir.c[0] = '\0';
				return 0;
			}
			if (c == '\0')
				break;
			seen_slash = 1;
			dots = 0;
		} else if (c == '.' && seen_slash && dots <= 1) {
			++dots;
		} else {
			*p = DCC_TO_LOWER(c);
			seen_slash = 0;
			dots = 0;
		}
		++p;
	}

	return 1;
}



/* start main log file */
void
log_start(CMN_WORK *cwp)
{
	char date_buf[40];

	/* don't even whine if there is no log directory */
	if (dcc_main_logdir.c[0] == '\0')
		return;

	/* nothing to do if we already have a log file */
	if (cwp->log_fd >= 0)
		return;

	cwp->log_size = 0;
	cwp->log_fd = dcc_main_log_open(&cwp->emsg, &cwp->log_nm,
					cwp->id, sizeof(cwp->id));
	if (cwp->log_fd < 0) {
		static time_t whined;
		time_t now;

		/* complain about not being able to open log files
		 * only occassionally */
		now = time(0);
		if (now < whined || now > whined+5*60 || dcc_clnt_debug)
			dcc_error_msg("%s", cwp->emsg.c);
		whined = now;
		cwp->emsg.c[0] = '\0';
		return;
	}

	gettimeofday(&cwp->ldate, 0);

	thr_log_print(cwp, 0, DCC_LOG_DATE_PAT"\n",
		      dcc_time2str(date_buf, sizeof(date_buf), DCC_LOG_DATE_FMT,
				   cwp->ldate.tv_sec));
}



/* get an independent FD for the main log file that can be
 * repositioned without affecting additional output to the main log. */
static u_char
log2_start(CMN_WORK *cwp)
{
	DCC_PATH abs_nm;

#ifdef DCC_DEBUG_LOCKS
	if (user_log_owner != pthread_self())
		dcc_logbad(EX_SOFTWARE, "don't have user_log lock");
#endif

	if (log_fd2 >= 0)
		return 1;

	/* give up if things are already broken */
	if (log_fd2 != -1
	    || cwp->log_fd < 0)
		return 0;

	/* Some systems don't synchronize the meta data among FDs for
	 * a file, causing the second FD to appear to be truncated. */
	if (fsync(cwp->log_fd) < 0)
		thr_error_msg(cwp, "log_fd fsync(%s): %s",
			      dcc_fnm2abs_msg(&abs_nm, cwp->log_nm.c),
			      ERROR_STR());

	log_fd2 = open(cwp->log_nm.c, O_RDWR, 0);
	if (log_fd2 < 0) {
		thr_error_msg(cwp, "log_fd2 open(%s): %s",
			      dcc_fnm2abs_msg(&abs_nm, cwp->log_nm.c),
			      ERROR_STR());
		log_fd2 = -2;
		return 0;
	}

	return 1;
}



static void
log_fd2_close(int flag)
{
	if (user_log_owner == pthread_self()) {
		if (log_fd2 >= 0)
			close(log_fd2);
		log_fd2 = flag;
	}
}



void
log_stop(CMN_WORK *cwp)
{
	thr_log_late(cwp);
	log_fd2_close(-1);

	if (cwp->log_fd < 0)
		return;

	/* Close before renaming to accomodate WIN32 foolishness.
	 * Assuming dcc_mkstemp() works properly, there is no race */
	dcc_log_close(0, cwp->log_nm.c, cwp->log_fd, &cwp->ldate);
	if (!(cwp->ask_st & ASK_ST_LOGIT)) {
		/* Delete the log file if it is not interesting */
		unlink(cwp->log_nm.c);
	} else {
		/* give it a permanent name if it is interesting */
		dcc_log_keep(0, &cwp->log_nm);
	}
	cwp->log_nm.c[0] = '\0';
	cwp->log_fd = -1;
}



void
log_write(CMN_WORK *cwp, const void *buf, u_int buflen)
{
	int result;

	if (cwp->log_fd < 0)
		return;

	if (!buflen)
		buflen = strlen(buf);
	cwp->log_size += buflen;

	result = write(cwp->log_fd, buf, buflen);
	if (buflen == (u_int)result)
		return;

	if (result < 0)
		dcc_error_msg("write(%s): %s", cwp->log_nm.c, ERROR_STR());
	else
		dcc_error_msg("write(%s,%d)=%d", cwp->log_nm.c, buflen, result);
	dcc_log_close(0, cwp->log_nm.c, cwp->log_fd, &cwp->ldate);
	cwp->log_fd = -1;
}



void
log_body_write(CMN_WORK *cwp, const char *buf, u_int buflen)
{
	int trimlen;
	const char *p, *lim;

	if (cwp->log_fd < 0)
		return;

	/* just write if there is room */
	trimlen = MAX_LOG_KBYTE*1024 - cwp->log_size;
	if (trimlen >= (int)buflen) {
		log_write(cwp, buf, buflen);
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
	log_write(cwp, buf, trimlen);
	if (buf[trimlen-1] != '\n')
		LOG_CMN_EOL(cwp);
	LOG_CMN_CAPTION(cwp, DCC_LOG_TRN_MSG_CR);
	cwp->log_size = MAX_LOG_KBYTE*1024+1;
}



off_t
log_lseek_get(CMN_WORK *cwp)
{
	off_t result;

	if (cwp->log_fd < 0)
		return 0;
	result = lseek(cwp->log_fd, 0, SEEK_END);
	if (result == -1) {
		thr_error_msg(cwp, "lseek(%s, 0, SEEK_END): %s",
			      cwp->log_nm.c, ERROR_STR());
		dcc_log_close(0, cwp->log_nm.c, cwp->log_fd, &cwp->ldate);
		cwp->log_fd = -1;
		return 0;
	}
	return result;
}



static u_char
log_lseek_set(CMN_WORK *cwp, off_t pos)
{
#ifdef DCC_DEBUG_LOCKS
	if (user_log_owner != pthread_self())
		dcc_logbad(EX_SOFTWARE, "don't have user_log lock");
#endif

	if (log_fd2 < 0)
		return 0;

	if (-1 == lseek(log_fd2, pos, SEEK_SET)) {
		thr_error_msg(cwp, "lseek(%s,%d,SEEK_SET): %s",
			      cwp->log_nm.c, (int)pos, ERROR_STR());
		log_fd2_close(-2);
		return 0;
	}

	return 1;
}



/* put something into a log file
 * does not append '\n' */
static int				/* bytes written */
vthr_log_print(CMN_WORK *cwp,
	       u_char error,		/* 1=important enough to buffer */
	       const char *p, va_list args)
{
	char logbuf[LOGBUF_SIZE*2];
	int i;

	if (cwp->log_fd < 0
	    || (error && (cwp->cmn_fgs & CMN_FG_LOG_EARLY))) {
		return vearly_log(&cwp->early_log, p, args);
	}

	i = vsnprintf(logbuf, sizeof(logbuf), p, args);
	if (i >= ISZ(logbuf)) {
		i = strlen(p);
		if (i != 0 && p[i-1] == '\n')
			memcpy(&logbuf[ISZ(logbuf)-LITZ("...\n")], "...\n",
			       LITZ("...\n"));
		else
			memcpy(&logbuf[ISZ(logbuf)-LITZ("...")], "...",
			       LITZ("..."));
		i = ISZ(logbuf);
	}
	log_write(cwp, logbuf, i);
	return i;
}



/* does not append '\n' */
int DCC_PF(3,4)				/* bytes written */
thr_log_print(void *cwp, u_char error, const char *pat, ...)
{
	va_list args;
	int i;

	va_start(args, pat);
	i = vthr_log_print(cwp, error, pat, args);
	va_end(args);
	return i;
}



int					/* bytes written */
thr_error_msg(void *cwp0, const char *pat, ...)
{
	CMN_WORK *cwp = cwp0;
	va_list args;
	int i;

	va_start(args, pat);
	dcc_verror_msg(pat, args);
	va_end(args);

	va_start(args, pat);
	i = vthr_log_print(cwp, 1, pat, args);
	va_end(args);
	thr_log_print(cwp, 1, "\n");

	cwp->ask_st |= ASK_ST_LOGIT;

	return i+1;
}



void
thr_trace_msg(void *cwp0, const char *p, ...)
{
	va_list args;

	va_start(args, p);
	dcc_vtrace_msg(p, args);
	va_end(args);

	if (cwp0) {
		CMN_WORK *cwp = cwp0;
		va_start(args, p);
		vthr_log_print(cwp, 1, p, args);
		va_end(args);
		thr_log_print(cwp, 1, "\n");

		cwp->ask_st |= ASK_ST_LOGIT;
	}
}



void
thr_log_late(CMN_WORK *cwp)
{
	cwp->cmn_fgs &= ~CMN_FG_LOG_EARLY;
	if (cwp->early_log.len) {
		log_write(cwp, cwp->early_log.buf, cwp->early_log.len);
		cwp->early_log.len = 0;
	}
}



void
thr_log_envelope(CMN_WORK *cwp,
		 u_char dccm_placekeeper)   /* leave room to replace IP */
{
	RCPT_ST *rcpt_st;
	off_t cur_pos;
	int i;

	cwp->cmn_fgs |= CMN_FG_ENV_LOGGED;

	/* install the sender in blank area in the log file that we skipped */
	cwp->log_ip_pos = log_lseek_get(cwp) + LITZ(DCC_XHDR_TYPE_IP": ");
	if (cwp->sender_str[0] != '\0') {
		/* Dccm will not have computed the checksum
		 * if there were no envelope Mail_From commands
		 * On a second message in a session, dccm will not have
		 * looked at cwp->clnt_addr */
		if (cwp->cks.sums[DCC_CK_IP].type == DCC_CK_INVALID)
			get_ipv6_ck(&cwp->cks, &cwp->clnt_addr);

		/* pad host name & IP address with blanks for replacement
		 * by dccm */
		if (!dccm_placekeeper) {
			i = 0;
		} else {
			i = 80 - (strlen(cwp->sender_name)
				  + LITZ(DCC_LOG_IP1 DCC_LOG_IP2 "\n"));
		}
		i = thr_log_print(cwp, 0, DCC_LOG_IP1"%s"DCC_LOG_IP2"%-*s\n",
				  cwp->sender_name, i, cwp->sender_str);
		i -= LITZ(DCC_LOG_IP1 DCC_LOG_IP2 "\n");
		cwp->log_ip_len = i > 0 ? i : 0;
	} else {
		cwp->log_ip_len = 0;
	}

	/* log HELO value if we have it
	 * make checksum of it or of null string if we don't */
	if (cwp->helo[0] != '\0')
		thr_log_print(cwp, 0, DCC_LOG_HELO"%s\n", cwp->helo);
	ck_get_sub(&cwp->cks, "helo", cwp->helo);

	if (cwp->env_from[0] != '\0') {
		LOG_CMN_CAPTION(cwp, DCC_XHDR_TYPE_ENV_FROM": ");
		log_write(cwp, cwp->env_from, 0);
		get_cks(&cwp->cks, DCC_CK_ENV_FROM, cwp->env_from, 1);

		if (cwp->mail_host[0] == '\0')
			parse_mail_host(cwp->env_from, cwp->mail_host,
					sizeof(cwp->mail_host));

		LOG_CMN_CAPTION(cwp, DCC_LOG_MAIL_HOST);
		log_write(cwp, cwp->mail_host, 0);
		if (cwp->mail_host[0] != '\0')
			ck_get_sub(&cwp->cks, "mail_host", cwp->mail_host);
		LOG_CMN_EOL(cwp);
	}

	cwp->log_pos_to_first = cur_pos = log_lseek_get(cwp);
	for (rcpt_st = cwp->rcpt_st_first; rcpt_st; rcpt_st = rcpt_st->fwd) {
		rcpt_st->log_pos_to = cur_pos;
		LOG_CMN_CAPTION(cwp, DCC_XHDR_TYPE_ENV_TO": ");
		log_write(cwp, rcpt_st->env_to, 0);
		LOG_CMN_CAPTION(cwp, "  addr=");
		log_write(cwp, rcpt_st->user, 0);
		LOG_CMN_CAPTION(cwp, "  dir=");
		log_write(cwp, rcpt_st->dir.c, 0);
		if (rcpt_st->fgs & RCPT_FG_BAD_USERNAME) {
			LOG_CMN_CAPTION(cwp, "  "DCC_XHDR_MTA_REJECTION"\n");
		} else {
			LOG_CMN_EOL(cwp);
		}
		cur_pos = log_lseek_get(cwp);
	}
	cwp->log_pos_to_end = cur_pos;

	/* log the blank line between the log file header and mail message */
	LOG_CMN_EOL(cwp);
}



/* open the connection to the nearest DCC server */
u_char
ck_dcc_ctxt(CMN_WORK *cwp)
{
	if (cwp->dcc_ctxt_sn != dcc_ctxt_sn) {
		cwp->dcc_ctxt_sn = dcc_ctxt_sn;
		cwp->dcc_ctxt = dcc_clnt_init(&cwp->emsg, cwp->dcc_ctxt, 0,
					      DCC_CLNT_FG_BAD_SRVR_OK
					      | DCC_CLNT_FG_NO_MEASURE_RTTS
					      | DCC_CLNT_FG_NO_FAIL);
		if (!cwp->dcc_ctxt) {
			/* failed to create context */
			thr_error_msg(cwp, "%s", cwp->emsg.c);
			cwp->dcc_ctxt_sn = 0;
			return 0;
		}
		cwp->xhdr_fname_len = get_xhdr_fname(cwp->xhdr_fname,
						     sizeof(cwp->xhdr_fname),
						     dcc_clnt_info);
	}
	return 1;
}



/* find and lock a per-user WF
 *	it is locked by grabbing the mutex for the main whiteclnt file */
static CWF *
find_cwf(RCPT_ST *rcpt_st)
{
	CWF *cwf;
	DCC_PATH white_nm_buf;
	const char *white_nm_ptr;

	if (rcpt_st->dir.c[0] == '\0') {
		rcpt_st->fgs |= RCPT_FG_NULL_WHITECLNT;
		return 0;
	}

	/* canonicalize the key */
	if (!dcc_fnm2rel(&white_nm_buf, rcpt_st->dir.c, "/whiteclnt")) {
		thr_error_msg(rcpt_st->cwp,
			      "long user whiteclnt name \"%s/whiteclnt\"",
			      rcpt_st->dir.c);
		rcpt_st->fgs |= RCPT_FG_NULL_WHITECLNT;
		return 0;
	}
	white_nm_ptr = dcc_path2fnm(white_nm_buf.c);

	lock_wf();
	cwf = cur_cwf;
	for (;;) {
		if (!strcmp(white_nm_ptr, cwf->wf.ascii_nm.c))
			break;		/* found old WF for target file */

		if (cwf->older == cur_cwf) {
			/* We do not know this file.
			 * Recycle the oldest WF */
			if (!dcc_new_white_nm(&rcpt_st->cwp->emsg, &cwf->wf,
					      white_nm_ptr)) {
				thr_error_msg(rcpt_st->cwp, "%s",
					      rcpt_st->cwp->emsg.c);
				unlock_wf();
				rcpt_st->fgs |= RCPT_FG_NULL_WHITECLNT;
				return 0;
			}
			break;
		}

		cwf = cwf->older;
	}

	/* move to front */
	if (cwf != cur_cwf) {
		cwf->older->newer = cwf->newer;
		cwf->newer->older = cwf->older;
		cwf->older = cur_cwf;
		cwf->newer = cur_cwf->newer;
		cwf->newer->older = cwf;
		cwf->older->newer = cwf;
		cur_cwf = cwf;
	}

	switch (wf_rdy(&rcpt_st->cwp->emsg, &cwf->wf, &cmn_tmp_wf)) {
	case WHITE_CONTINUE:
		thr_error_msg(rcpt_st->cwp, "%s", rcpt_st->cwp->emsg.c);
		/* fall through */
	case WHITE_OK:
		/* notice if the file contains no checksums or IP address blocks
		 * or flag bits that make the file differ from an empty
		 * or non-existent file */
		if (cwf->wf.wtbl->hdr.entries == 0
		    && cwf->wf.wtbl->hdr.ranges.len == 0
		    && WHITE_SET(cwf->wf.wtbl_fgs, cwf->wf.wtbl_sws)) {
			rcpt_st->fgs |= RCPT_FG_NULL_WHITECLNT;
		} else {
			rcpt_st->fgs &= ~RCPT_FG_NULL_WHITECLNT;
			rcpt_st->wf_sum = cwf->wf.wtbl->hdr.ck_sum;
		}
		return cwf;
	case WHITE_NOFILE:
		break;
	case WHITE_SILENT:
		if (dcc_clnt_debug)
			thr_error_msg(rcpt_st->cwp, "%s", rcpt_st->cwp->emsg.c);
		break;
	case WHITE_COMPLAIN:
		thr_error_msg(rcpt_st->cwp, "%s", rcpt_st->cwp->emsg.c);
		break;
	}

	unlock_wf();
	rcpt_st->fgs |= RCPT_FG_NULL_WHITECLNT;
	return 0;
}



/* digest the results of one recipient's whitelist */
static RCPT_FGS
white_results(RCPT_ST *rcpt_st,
	      CMN_WORK *cwp,
	      RCPT_FGS *fgsp,
	      WHITE_RESULT result,
	      WHITE_LISTING listing)
{
	u_char have_wlist_tgts;
	RCPT_FGS new_cwp_rcpt_fgs;

	/* override if the result of the whitelist lookup was bad */
	switch (result) {
	case WHITE_OK:
		break;
	case WHITE_SILENT:
	case WHITE_NOFILE:
		listing = WHITE_UNLISTED;
		break;
	case WHITE_COMPLAIN:
	case WHITE_CONTINUE:
		thr_error_msg(cwp, "%s", cwp->emsg.c);
		return 0;
	}

	have_wlist_tgts = 0;
	new_cwp_rcpt_fgs = 0;

	switch (listing) {
	case WHITE_USE_DCC:
		/* "OK2" for the env_to checksum in the local whitelist
		 * does not mean the address is half whitelisted,
		 * but that it is ok to reject or discard spam for it based
		 * on DCC results.
		 * It is the original, deprecated mechanism for turn DCC checks
		 * on and off for individual targets
		 * We get this value only from wf_sum() */
		if (rcpt_st)
			rcpt_st->sws &= ~FLTR_SW_DCC_OFF;
		break;

	case WHITE_UNLISTED:
		break;

	case WHITE_LISTED:
		*fgsp &= ~RCPT_FG_BLACK;
		*fgsp |= (RCPT_FG_WHITE | RCPT_FG_WLIST_NOTSPAM);
		new_cwp_rcpt_fgs |= RCPT_FG_WLIST_NOTSPAM;
		have_wlist_tgts = 1;
		break;

	case WHITE_BLACK:
		if (!(*fgsp & RCPT_FG_WHITE))
			*fgsp |= RCPT_FG_BLACK;
		*fgsp |= RCPT_FG_WLIST_ISSPAM;
		new_cwp_rcpt_fgs |= RCPT_FG_WLIST_ISSPAM;
		have_wlist_tgts = 1;
		break;
	}

	/* a spam trap marks everything a spam and rejects or accepts it */
	if (!(*fgsp & RCPT_FG_WHITE)
	    && rcpt_st && (rcpt_st->sws & FLTR_SW_TRAP)) {
		*fgsp |= RCPT_FG_BLACK;
		*fgsp |= RCPT_FG_WLIST_ISSPAM;
		new_cwp_rcpt_fgs |= RCPT_FG_WLIST_ISSPAM;
		listing = WHITE_BLACK;

	} else if (have_wlist_tgts) {
		if (rcpt_st)
			rcpt_st->fgs |= RCPT_FG_LOG_WTGTS;
		new_cwp_rcpt_fgs |= RCPT_FG_LOG_WTGTS;
	}

	return new_cwp_rcpt_fgs;
}



static void
rcpt_fgs2ask_st(CMN_WORK *cwp, FLTR_SWS sws, RCPT_FGS *fgs)
{
	/* notice DNS whitelist hits */
	if (0 != (FLTR_SW_DNSBL_BITS(sws) & ASK_ST_DNSBL_W_BITS(cwp->ask_st))
	    && !(*fgs & RCPT_FG_BLACK))
		*fgs |= RCPT_FG_WHITE;

	/* We need to know if all targets are whitelisted for the DCC
	 * before we ask the DCC server.  Mail sent only to whitelisted
	 * targets should not be reported to the DCC server.
	 * For that we need a count of whitelisted targets */
	if (*fgs & RCPT_FG_WHITE) {
		++cwp->white_tgts;
		return;
	}

	/* it is spam if it is blacklisted by any target */
	if (*fgs & RCPT_FG_BLACK) {
		cwp->ask_st |= (ASK_ST_CLNT_ISSPAM | ASK_ST_LOGIT);
		return;
	}

	/* If we had a DNS blacklist hit
	 * and if this recipient believes the DNS blacklist,
	 * then it is spam to report to DCC server.
	 * We need to know if it is spam for at least one target before
	 * deciding what to do for each target. */
	if (0 != (FLTR_SW_DNSBL_BITS(sws) & ASK_ST_DNSBL_B_BITS(cwp->ask_st)))
		cwp->ask_st |= (ASK_ST_CLNT_ISSPAM | ASK_ST_LOGIT);
}



static FLTR_SWS
get_sws(const CMN_WORK *cwp, WF *wf)
{
	FLTR_SWS sws;

	sws = cwp->init_sws;

	if (wf)
		sws = wf2sws(sws, wf);

	/* greylisting our MX secondaries makes no sense
	 * and browsers cannot handle temporary rejections */
	if (cwp->cmn_fgs & (CMN_FG_VIA_MX | CMN_FG_VIA_SUBMIT))
		sws |= FLTR_SW_GREY_OFF;

	/* Discard traps should discard but can leak.
	 * Refusing to discard for discard traps makes no sense.
	 * Reject traps should act like no-such-user errors.
	 * A dccifd SMTP proxy cannot discard for 1 recipient.
	 * If we will discard spam and can discard for individual recipients,
	 * then we cannot have conflicts among recipients about discarding. */
	if (sws & FLTR_SW_TRAP_DIS) {
		sws &= ~FLTR_SW_DISCARD_NO;
	} else if (!can_discard_1
		   && (cwp->action != CMN_IGNORE || (sws & FLTR_SW_TRAP_REJ))) {
		sws |= FLTR_SW_DISCARD_NO;
	} else if (cwp->action == CMN_DISCARD) {
		sws &= ~FLTR_SW_DISCARD_NO;
	}

	return sws;
}



static void
init_sws(CMN_WORK *cwp, u_char locked)
{
	/* set defaults */
	cwp->init_sws = 0;
	if (cwp->action == CMN_REJECT)
		cwp->init_sws = FLTR_SW_DISCARD_NO;
	if (to_white_only)
		cwp->init_sws |= FLTR_SW_DCC_OFF;

	if (!locked)
		lock_wf();
	cwp->init_sws = get_sws(cwp, &cmn_wf);
	if (!locked)
		unlock_wf();

	merge_tholds(&cwp->tholds_base, &tholds_rej, cmn_wf.wtbl);

	cwp->or_sws = cwp->and_sws = cwp->init_sws & ~FLTR_SW_SET;
	cwp->cks.tholds_rej = cwp->tholds_base;
}



/* set per-user switches and compute env_to whitelisting
 *	If we return a pointer, then we grabbed and have kept the lock */
static RCPT_FGS
rcpt_sws_env_to(CMN_WORK *cwp, RCPT_ST *rcpt_st, CWF **cwfp)
{
	CWF *cwf;
	WHITE_RESULT result;
	WHITE_LISTING listing;
	RCPT_FGS new_cwp_rcpt_fgs;

	new_cwp_rcpt_fgs = cwp->rcpt_fgs;

	/* We are finished after finding the recipient's whitelist if we
	 * have already checked its settings.
	 *
	 * In this case, we have been here before for this recipient
	 * and fetched the global as well as this recipient's switch settings
	 * and action.
	 *
	 * If we found that the file was empty of checksums or non-existent
	 * before, then assume it is still is and so repeat the previous 0
	 * answer without wasting time looking.  This is an extremely
	 * common case that deserves optimizing. */
	if (rcpt_st->fgs & RCPT_FG_NULL_WHITECLNT) {
		if (cwfp)
			*cwfp = 0;
		return new_cwp_rcpt_fgs;
	}

	/* after mapping this per-recipient whiteclnt file,
	 * do not repeat the work of examining it if we have already done it */
	cwf = find_cwf(rcpt_st);
	if (rcpt_st->sws & FLTR_SW_SET) {
		if (cwfp)
			*cwfp = cwf;
		else if (cwf)
			unlock_wf();
		return new_cwp_rcpt_fgs;
	}

	/* We must get the global switch settings the first time for the
	 * first recipient.
	 * If we have a per-user whitelist, then we have locked cmn_wf
	 * to protect the per-user whitelist data structures */
	if (!(cwp->init_sws & FLTR_SW_SET))
		init_sws(cwp, cwf != 0);

	/* get flags and filter settings for recipient,
	 * including setting FLTR_SW_SET so that we won't do this again */
	rcpt_st->sws = get_sws(cwp, cwf ? &cwf->wf : 0);
	merge_tholds(&rcpt_st->tholds, &cwp->tholds_base,
		     cwf ? cwf->wf.wtbl : 0);

	/* if we have a per-user whitelist, then we have already locked cmn_wf
	 * to protect the per-user whitelist data structures */
	if (!cwf)
		lock_wf();

	str2ck(&rcpt_st->env_to_sum, 0, 0, rcpt_st->env_to);

	/* check the env_to address in the global whitelist */
	result = wf_sum(&cwp->emsg, &cmn_wf,
			DCC_CK_ENV_TO, &rcpt_st->env_to_sum,
			&rcpt_st->env_to_tgts, &listing);
	new_cwp_rcpt_fgs = white_results(rcpt_st, cwp,
					 &rcpt_st->global_env_to_fgs,
					 result, listing);

	/* check the mailbox name (after aliases etc.) in the global whitelist
	 * if we did not just check it as the envelope Rcpt_To value */
	if (rcpt_st->user[0] != '\0'
	    && strcmp(rcpt_st->env_to, rcpt_st->user)) {
		str2ck(&rcpt_st->user_sum, 0, 0, rcpt_st->user);
		result = wf_sum(&cwp->emsg, &cmn_wf,
				DCC_CK_ENV_TO, &rcpt_st->user_sum,
				&rcpt_st->user_tgts, &listing);
		new_cwp_rcpt_fgs |= white_results(rcpt_st, cwp,
						  &rcpt_st->global_env_to_fgs,
						  result, listing);
	}

	if (!cwf) {
		unlock_wf();
	} else {
		/* save per-user envelope Rcpt_To value and mailbox name
		 * (after aliases etc.) for white- or blacklisting
		 * and the WHITE_USE_DCC setting */
		result = wf_sum(&cwp->emsg, &cwf->wf,
				DCC_CK_ENV_TO, &rcpt_st->env_to_sum,
				&rcpt_st->env_to_tgts, &listing);
		new_cwp_rcpt_fgs |= white_results(rcpt_st, cwp,
						  &rcpt_st->env_to_fgs,
						  result, listing);
		if (rcpt_st->user[0] != '\0'
		    && strcmp(rcpt_st->env_to, rcpt_st->user)) {
			result = wf_sum(&cwp->emsg, &cwf->wf,
					DCC_CK_ENV_TO,&rcpt_st->user_sum,
					&rcpt_st->user_tgts, &listing);
			new_cwp_rcpt_fgs |= white_results(rcpt_st, cwp,
							&rcpt_st->env_to_fgs,
							result, listing);
		}
	}

	if (cwfp)
		*cwfp = cwf;
	else if (cwf)
		unlock_wf();
	return new_cwp_rcpt_fgs;
}



static inline void
merge_rcpt(CMN_WORK *cwp, RCPT_FGS new_cwp_rcpt_fgs,
	   FLTR_SWS new_and_sws, FLTR_SWS new_or_sws,
	   const CKSUM_THOLDS *new_tholds_rej)
{
	cwp->rcpt_fgs = new_cwp_rcpt_fgs;
	cwp->and_sws = new_and_sws;
	cwp->or_sws = new_or_sws;
	cwp->cks.tholds_rej = *new_tholds_rej;
}



/* either tell the caller of cmn_compat_whitelist() to reject a recipient
 * or complain that it cannot be done */
static u_char
rej_rcpt(CMN_WORK *cwp, RCPT_ST *rcpt_st2, RCPT_FGS new_cwp_rcpt_fgs,
	 FLTR_SWS new_and_sws, FLTR_SWS new_or_sws,
	 const CKSUM_THOLDS *new_tholds_rej)
{
	/* if the new recipient cannot be rejected
	 * then whine and integrate its preferences */
	if (!can_reject_1
	    || (cwp->cmn_fgs & CMN_FG_VIA_SUBMIT)) {
		if (!(cwp->rcpt_fgs & RCPT_FG_INCOMPAT_REJ)) {
			cwp->rcpt_fgs |= RCPT_FG_INCOMPAT_REJ;
			thr_log_print(cwp, 1, "incompatible whitelists\n");
		}
		merge_rcpt(cwp, new_cwp_rcpt_fgs, new_and_sws, new_or_sws,
			   new_tholds_rej);
		return 1;
	}

	cwp->ask_st |= ASK_ST_LOGIT;
	rcpt_st2->fgs |= RCPT_FG_INCOMPAT_REJ;
	return 0;
}



/* See if a recipient's whitelist decision is certain to be the same
 *	as all preceding recipients.  At the end of the DATA command,
 *	we can only reject the message for all recipients or in some cases
 *	deliver to some recipients and discard for the rest.
 *	When using CMN_DISCARD and individual recipients can be trimmed,
 *	only conflicting thresholds are incompatible.  Individual whiteclnt
 *	files affect only individual recipients.
 *	When using CMN_REJECT, the entire message must be accepted or
 *	rejected for all recipients, and so individual whiteclnt files conflict
 *	if they differ.
 *	CMN_IGNORE must be treated like CMN_REJECT, because the X-DCC header
 *	is often used later to discard mail.  All recipients see the same
 *	X-DCC header, just all all recipients share the single SMTP OK
 *	or rejection after the DATA command. */
int					/* 1=ok -1=whitelist -2=thold conflict */
cmn_compat_whitelist(CMN_WORK *cwp,
		     RCPT_ST *rcpt_st2)
{
	const RCPT_ST *rcpt_st1;
	RCPT_FGS new_cwp_rcpt_fgs;
	FLTR_SWS new_and_sws, new_or_sws;
	CKSUM_THOLDS new_tholds;
	DCC_CK_TYPES type;
	u_char found_trap;

	new_cwp_rcpt_fgs = rcpt_sws_env_to(cwp, rcpt_st2, 0);

	/* The first recipient's preferences set the global defaults.
	 * We are finished for now if this is the first recipient. */
	if (!(cwp->or_sws & FLTR_SW_SET)) {
		merge_rcpt(cwp, new_cwp_rcpt_fgs, rcpt_st2->sws, rcpt_st2->sws,
			   &rcpt_st2->tholds);
		return 1;
	}

	for (type = 0; type < DCC_DIM_CKS; ++type) {
		new_tholds.t[type] = min(rcpt_st2->tholds.t[type],
					 cwp->cks.tholds_rej.t[type]);
	}
	new_and_sws = cwp->and_sws & rcpt_st2->sws;
	new_or_sws = cwp->or_sws | rcpt_st2->sws;

	/* find the first recipient that was not rejected
	 * and is not a discarding spam trap */
	found_trap = 0;
	for (rcpt_st1 = cwp->rcpt_st_first; ; rcpt_st1 = rcpt_st1->fwd) {
		if (!rcpt_st1)
			dcc_logbad(EX_SOFTWARE, "broken recipient chain");
		if (rcpt_st1 == rcpt_st2) {
			/* do not worry if all other recipients are
			 * discarding spam traps */
			if (found_trap) {
				merge_rcpt(cwp, new_cwp_rcpt_fgs,
					   new_and_sws, new_or_sws,
					   &new_tholds);
				return 1;
			}
			dcc_logbad(EX_SOFTWARE, "failed to find 1st recipient");
		}

		if ((rcpt_st1->fgs & (RCPT_FG_REJ_FILTER
				      | RCPT_FG_BAD_USERNAME)))
			continue;
		if (!(rcpt_st1->sws & FLTR_SW_TRAP_DIS))
			break;
		found_trap = 1;
	}

	/* See if the mail might be accepted for this recipient
	 * but rejected for a preceding recipient that does not want
	 * forced discarding or if this recipient does not want forced
	 * discarding and has weaker filtering than preceding recipients.
	 * If so, reject this recipient.
	 *
	 * If this recipient's thresholds could affect the result for it
	 * and if they differ, then they could conflict. */
	if (0 == (new_cwp_rcpt_fgs & (RCPT_FG_WLIST_ISSPAM
				      | RCPT_FG_WLIST_NOTSPAM))
	    && memcmp(&cwp->cks.tholds_rej, &new_tholds,
		      sizeof(cwp->cks.tholds_rej))) {
		if (rej_rcpt(cwp, rcpt_st2, new_cwp_rcpt_fgs,
			     new_and_sws, new_or_sws, &new_tholds))
			return 1;
		return -2;
	}

	/* Everything other than relevant differing thesholds is compatible
	 * if discarding is ok for all recipients.
	 */
	if (!(new_or_sws & FLTR_SW_DISCARD_NO)) {
		merge_rcpt(cwp, new_cwp_rcpt_fgs, new_and_sws, new_or_sws,
			   &new_tholds);
		return 1;
	}

	/* Two whitelists are incompatible if they give differing
	 * reject/accept answers and the mailbox that does not want the
	 * message also does not want it discarded.
	 *
	 * Check the other recipients individually */
	do {
		/* ignore already rejected recipients */
		if (rcpt_st1->fgs & (RCPT_FG_REJ_FILTER | RCPT_FG_BAD_USERNAME))
			continue;

		/* Differing whitelists make it possible that the message
		 * could need to be rejected for one recipient but accepted
		 * for another */
		if ((!(rcpt_st1->fgs & FLTR_SW_DISCARD_NO)
		     || !(rcpt_st2->fgs & FLTR_SW_DISCARD_NO))
		    && (0 != FLTR_SWS_CONFLICT(rcpt_st1->sws ^ rcpt_st2->sws)
			|| (0 != ((rcpt_st1->fgs ^rcpt_st2->fgs)
				  & RCPT_FG_NULL_WHITECLNT))
			|| (!(rcpt_st1->fgs & RCPT_FG_NULL_WHITECLNT)
			    && memcmp(&rcpt_st1->wf_sum, &rcpt_st2->wf_sum,
				      sizeof(rcpt_st1->wf_sum))))) {
			if (rej_rcpt(cwp, rcpt_st2, new_cwp_rcpt_fgs,
				     new_and_sws, new_or_sws, &new_tholds))
				return 1;
			return -1;
		}
	} while ((rcpt_st1 = rcpt_st1->fwd) != rcpt_st2);

	return 1;
}



/* check the whitelists for a single user or recipient */
static void
ask_white_rcpt(CMN_WORK *cwp,
	       RCPT_ST *rcpt_st,
	       RCPT_FGS global_fgs)
{
	WHITE_RESULT result;
	WHITE_LISTING listing;
	DCC_PATH fnm;
	CWF *cwf;

	rcpt_st->log_pos_white = log_lseek_get(cwp);

	/* Quit after capturing the log position if the recipient has
	 * been rejected.
	 * We cannot do more because dccm does not have the mailer and so
	 * cannot find the likely userdirs/local/user/whiteclnt file */
	if (rcpt_st->fgs & (RCPT_FG_REJ_FILTER | RCPT_FG_BAD_USERNAME))
		return;

	/* map the per-user whiteclnt file to check the rest of the checksums */
	rcpt_sws_env_to(cwp, rcpt_st, &cwf);

	/* Compute white- or blacklisting.
	 *	The per-user whiteclnt file overrides the global file.
	 *	The whiteclnt files override the MTA with "option MTA-first".
	 *	    Without, the MTA controls.
	 *	Within each category, whitelisting overrides blacklisting.
	 *
	 *	The global whitelist's answer for message's checksums other
	 *	    than the env_to checksums have already been computed in
	 *	    global_fgs. */

	if (global_fgs != 0) {
		rcpt_st->fgs &= ~(RCPT_FG_WHITE | RCPT_FG_BLACK);
		rcpt_st->fgs |= global_fgs;
	}

	if (rcpt_st->sws & FLTR_SW_MTA_FIRST) {
		if (cwp->ask_st & ASK_ST_MTA_NOTSPAM) {
			rcpt_st->fgs |= RCPT_FG_WHITE;
			rcpt_st->fgs &= ~RCPT_FG_BLACK;
		} else if (cwp->ask_st & ASK_ST_MTA_ISSPAM) {
			rcpt_st->fgs |= RCPT_FG_BLACK;
			rcpt_st->fgs &= ~RCPT_FG_WHITE;
		}
	}

	/* apply the previously computed env_to global whitelist results
	 * as well as the other global whitelist results */
	if ((rcpt_st->global_env_to_fgs | global_fgs) & RCPT_FG_WHITE) {
		rcpt_st->fgs &= ~RCPT_FG_BLACK;
		rcpt_st->fgs |= RCPT_FG_WHITE;
	} else if ((rcpt_st->global_env_to_fgs | global_fgs) & RCPT_FG_BLACK) {
		rcpt_st->fgs &= ~RCPT_FG_WHITE;
		rcpt_st->fgs |= RCPT_FG_BLACK;
	}

	if (!cwf) {
		/* Without a per-user whitelist or without any entries in
		 * the per-user whitelist, we will be using the
		 * global whitelist for the other messages checksums.
		 * Arrange to include those results in the per-user log file */
		memcpy(&rcpt_st->wtgts, &cwp->wtgts,
		       sizeof(rcpt_st->wtgts));

	} else {
		/* Check other message checksums in per-user whitelist */
		result = wf_cks(&cwp->emsg, &cwf->wf, &cwp->cks,
				&rcpt_st->wtgts, &listing);
		cwp->rcpt_fgs |= white_results(rcpt_st, cwp,
					       &rcpt_st->env_to_fgs,
					       result, listing);

		/* release common lock that protected the per-user whitelist
		 * because we are finished with the per-user whitelist */
		unlock_wf();

		if (rcpt_st->env_to_fgs == 0) {
			/* Without an answer from the per-user whitelist,
			 * we will be using the global whitelist.
			 * So arrange to include those results in the per-user
			 * log file */
			memcpy(&rcpt_st->wtgts, &cwp->wtgts,
			       sizeof(rcpt_st->wtgts));

		} else {
			rcpt_st->fgs &= ~(RCPT_FG_WHITE | RCPT_FG_BLACK);
			rcpt_st->fgs |= rcpt_st->env_to_fgs;
		}
	}

	/* announce result from the whitelist */
	if (rcpt_st->fgs & (RCPT_FG_WHITE | RCPT_FG_BLACK))
		thr_log_print(cwp, 0, "%s%s\n",
			      rcpt_st->user[0] ? rcpt_st->user
			      : rcpt_st->env_to[0] ? rcpt_st->env_to
			      : cwf ? dcc_fnm2abs_msg(&fnm, cwf->wf.ascii_nm.c)
			      : "",

			      (rcpt_st->fgs & RCPT_FG_WHITE)
			      ? DCC_XHDR_ISOK
			      : (rcpt_st->sws & FLTR_SW_TRAP_DIS)
			      ? "-->"DCC_XHDR_TRAP_DIS
			      : (rcpt_st->sws & FLTR_SW_TRAP_REJ)
			      ? "-->"DCC_XHDR_TRAP_REJ
			      : DCC_XHDR_ISSPAM);

	if (!(rcpt_st->sws & FLTR_SW_MTA_FIRST)) {
		if (cwp->ask_st & ASK_ST_MTA_NOTSPAM) {
			rcpt_st->fgs |= RCPT_FG_WHITE;
			rcpt_st->fgs &= ~RCPT_FG_BLACK;
		} else if (cwp->ask_st & ASK_ST_MTA_ISSPAM) {
			rcpt_st->fgs |= RCPT_FG_BLACK;
			rcpt_st->fgs &= ~RCPT_FG_WHITE;
		}
	}

	/* If any recipient cares about reputations, then report mail from
	 * IP addresses with bulk mail reputations with counts of "MANY" */
	if ((rcpt_st->sws & FLTR_SW_REP_ON)
	    && !(rcpt_st->fgs & RCPT_FG_WHITE))
		cwp->cmn_fgs |= CMN_FG_CHECK_REP;
}



/* Check DNS white- and blacklists for STMP client and envelope sender
 * after knowing all of the recipients. */
void
cmn_ask_dnsbl(CMN_WORK *cwp)
{
	if (!cwp->cks.dlw)
		return;

	/* turn off DNS lists for traps */
	if (cwp->and_sws & FLTR_SW_TRAP) {
		memset(&cwp->cks.dlw->tgt_hits, 0,
		       sizeof(cwp->cks.dlw->tgt_hits));
		return;
	}

	if (cwp->cks.sums[DCC_CK_IP].type == DCC_CK_IP)
		dcc_client_dnsbl(cwp->cks.dlw, &cwp->cks.ip_addr,
				cwp->sender_name);
	if (cwp->mail_host[0] != '\0')
		dcc_mail_host_dnsbl(cwp->cks.dlw, cwp->mail_host);
}



/* check the whitelists for all recipients at the end of the message */
void
cmn_ask_white(CMN_WORK *cwp)
{
	RCPT_ST *rcpt_st;
	RCPT_FGS global_fgs;
	DCC_OPS grey_op;
	WHITE_RESULT result;
	WHITE_LISTING listing;

	/* log sendmail access_db spam */
	if (cwp->ask_st & ASK_ST_MTA_ISSPAM)
		cwp->ask_st |= ASK_ST_LOGIT;

	dcc_dnsbl_result(&cwp->ask_st, cwp->cks.dlw);

	cwp->log_pos_white_first = log_lseek_get(cwp);

	/* Use the main whitelist only for recipients whose individual
	 * whitelists don't give a black or white answer.
	 * Check the main whitelist first (and so even if not necessary)
	 * so that problems with it are in all of the logs and to simplify
	 * merging the global and per-user whitelist results. */
	lock_wf();
	global_fgs = 0;
	result = wf_cks(&cwp->emsg, &cmn_wf, &cwp->cks, &cwp->wtgts, &listing);
	cwp->rcpt_fgs |= (white_results(0, cwp, &global_fgs, result, listing)
			  & RCPT_FG_LOG_WTGTS);

	/* get the defaults for the options if there were no valid recipients */
	if (!(cwp->init_sws & FLTR_SW_SET))
		init_sws(cwp, 1);
	unlock_wf();

	/* kludge similar to ask_white_rcpt() for no recipients for dccifd with
	 * the ASCII protocol */
	if ((rcpt_st = cwp->rcpt_st_first) == 0) {
		/* announce result from the whitelist */
		if (cwp->rcpt_fgs & (RCPT_FG_WHITE | RCPT_FG_BLACK))
			thr_log_print(cwp, 0, "whiteclnt%s\n",
				      (cwp->rcpt_fgs & RCPT_FG_WHITE)
				      ? DCC_XHDR_ISOK
				      : (cwp->init_sws & FLTR_SW_TRAP_DIS)
				      ? "-->"DCC_XHDR_TRAP_DIS
				      : (cwp->init_sws & FLTR_SW_TRAP_REJ)
				      ? "-->"DCC_XHDR_TRAP_REJ
				      : DCC_XHDR_ISSPAM);

		if (cwp->init_sws & FLTR_SW_MTA_FIRST) {
			if (cwp->ask_st & ASK_ST_MTA_NOTSPAM) {
				cwp->rcpt_fgs |= RCPT_FG_WHITE;
				cwp->rcpt_fgs &= ~RCPT_FG_BLACK;
			} else if (cwp->ask_st & ASK_ST_MTA_ISSPAM) {
				cwp->rcpt_fgs |= RCPT_FG_BLACK;
				cwp->rcpt_fgs &= ~RCPT_FG_WHITE;
			}
		}
		if (global_fgs != 0) {
			cwp->rcpt_fgs &= ~(RCPT_FG_WHITE | RCPT_FG_BLACK);
			cwp->rcpt_fgs |= global_fgs;
		}

		if (!(cwp->init_sws & FLTR_SW_MTA_FIRST)) {
			if (cwp->ask_st & ASK_ST_MTA_NOTSPAM) {
				cwp->rcpt_fgs |= RCPT_FG_WHITE;
				cwp->rcpt_fgs &= ~RCPT_FG_BLACK;
			} else if (cwp->ask_st & ASK_ST_MTA_ISSPAM) {
				cwp->rcpt_fgs |= RCPT_FG_BLACK;
				cwp->rcpt_fgs &= ~RCPT_FG_WHITE;
			}
		}

		rcpt_fgs2ask_st(cwp, cwp->init_sws, &cwp->rcpt_fgs);
	}

	for (; rcpt_st; rcpt_st = rcpt_st->fwd) {
		/* maybe this recipient is whitelisted or a spam trap
		 * or has per-user option settings */
		ask_white_rcpt(cwp, rcpt_st, global_fgs);

		rcpt_fgs2ask_st(cwp, rcpt_st->sws, &rcpt_st->fgs);

		/* no greylist check if it is off or should not be done */
		if ((rcpt_st->sws & FLTR_SW_GREY_OFF)
		    || (cwp->ask_st & ASK_ST_GREY_OFF)
		    || (rcpt_st->fgs & (RCPT_FG_REJ_FILTER
					| RCPT_FG_BAD_USERNAME))
		    || (cwp->ask_st & ASK_ST_INVALID_MSG))
			continue;

		if (rcpt_st->fgs & RCPT_FG_BLACK) {
			if (cwp->cks.sums[DCC_CK_IP].type != DCC_CK_IP
			    || (cwp->cks.sums[DCC_CK_ENV_FROM].type
				!= DCC_CK_ENV_FROM))
				continue;
			grey_op = DCC_OP_GREY_QUERY;
		} else if (cwp->ask_st & ASK_ST_QUERY_GREY) {
			grey_op = DCC_OP_GREY_QUERY;
		} else if (rcpt_st->fgs & RCPT_FG_WHITE) {
			grey_op = DCC_OP_GREY_WHITE;
		} else {
			grey_op = DCC_OP_GREY_REPORT;
		}
		rcpt_st->grey_result = ask_grey(&cwp->emsg, cwp->dcc_ctxt,
						grey_op,
						&rcpt_st->msg_sum,
						&rcpt_st->triple_sum,
						&cwp->cks,
						&rcpt_st->env_to_sum,
						&rcpt_st->embargo_num,
						&cwp->early_grey_tgts,
						&cwp->late_grey_tgts);

		switch (rcpt_st->grey_result) {
		case ASK_GREY_OFF:
		case ASK_GREY_SPAM:
			dcc_logbad(EX_SOFTWARE,
				   "cmn_ask_white grey_result=%d",
				   rcpt_st->grey_result);
			break;
		case ASK_GREY_FAIL:
			thr_error_msg(cwp, "%s", cwp->emsg.c);
			/* If we are trying hard, assume the
			 * message would have been embargoed */
			if (try_extra_hard)
				cwp->ask_st |= (ASK_ST_GREY_EMBARGO
						| ASK_ST_GREY_LOGIT
						| ASK_ST_LOGIT);
			break;
		case ASK_GREY_EMBARGO:
			if (rcpt_st->embargo_num == 1
			    && (rcpt_st->fgs & RCPT_FG_BLACK)) {
				/* don't bother revoking non-existent entry */
				rcpt_st->grey_result = ASK_GREY_OFF;
			} else {
				cwp->ask_st |= (ASK_ST_GREY_EMBARGO
						| ASK_ST_GREY_LOGIT
						| ASK_ST_LOGIT);
				if (cwp->max_embargo_num < rcpt_st->embargo_num)
				    cwp->max_embargo_num = rcpt_st->embargo_num;
			}
			break;
		case ASK_GREY_EMBARGO_END:
			cwp->ask_st |= (ASK_ST_GREY_LOGIT | ASK_ST_LOGIT);
			cwp->rcpt_fgs |= RCPT_FG_GREY_END;
			break;
		case ASK_GREY_PASS:
			break;
		case ASK_GREY_WHITE:
			rcpt_st->fgs |= RCPT_FG_GREY_WHITE;
			break;
		}
	}

	cwp->log_pos_white_last = log_lseek_get(cwp);
	cwp->log_pos_ask_error = cwp->log_pos_white_last;
}



/* ask a DCC server */
int					/* <0=big problem, 0=retryable, 1=ok */
cmn_ask_dcc(CMN_WORK *cwp)
{
	int i;
	DCC_TGTS total_tgts = 0;

	/* Talk to the DCC server and make the X-DCC header.
	 * If we have blacklist entries for it, then we'll tell the DCC
	 * server it is spam and say so in the X-DCC header.
	 * Note that a recipient count of 0 is a query. */
	if (cwp->ask_st & ASK_ST_QUERY) {
		cwp->cmn_fgs &= ~CMN_FG_LOCAL_SPAM;
		cwp->local_tgts = 0;
	} else if (cwp->ask_st & ASK_ST_CLNT_ISSPAM) {
		cwp->cmn_fgs |= CMN_FG_LOCAL_SPAM;
		cwp->local_tgts = cwp->tgts + cwp->mta_rej_tgts;
	} else if (cwp->ask_st & ASK_ST_GREY_EMBARGO) {
		/* if the message is under a greylist embargo,
		 * then report to the DCC only the recipients for
		 * which it is an initial transmission or embargo #1 */
		cwp->cmn_fgs &= ~CMN_FG_LOCAL_SPAM;
		cwp->local_tgts = cwp->early_grey_tgts + cwp->mta_rej_tgts;
		total_tgts = cwp->tgts + cwp->mta_rej_tgts;
	} else {
		/* if this is the end of a greylist embargo
		 * then do not tell the DCC about recipients that were
		 * counted with previous transmissions.  Those recipients
		 * are counted in late_grey_tgts this time, but were
		 * counted in early_grey_tgts for previous transmissions */
		cwp->cmn_fgs &= ~CMN_FG_LOCAL_SPAM;
		cwp->local_tgts = (cwp->tgts - cwp->late_grey_tgts
				   + cwp->mta_rej_tgts);
		total_tgts = cwp->tgts + cwp->mta_rej_tgts;
	}

	/* talk to the DCC server */
	i = ask_dcc(&cwp->emsg, cwp->dcc_ctxt, try_extra_hard,
		    &cwp->header, &cwp->cks, &cwp->ask_st,
		    (cwp->cmn_fgs & CMN_FG_LOCAL_SPAM) != 0,
		    (cwp->cmn_fgs & CMN_FG_CHECK_REP) != 0,
		    total_tgts,
		    cwp->local_tgts);
	if (i <= 0) {
		cwp->log_pos_ask_error += thr_error_msg(cwp, "%s", cwp->emsg.c);
		return i;
	}

	/* if we are talking to a new server,
	 * remember to fix the X-DCC headers of the other contexts */
	if (cwp->xhdr_fname_len != cwp->header.start_len
	    || strncmp(cwp->header.buf, cwp->xhdr_fname, cwp->xhdr_fname_len)) {
		if (dcc_clnt_debug > 1)
			thr_trace_msg(cwp, DCC_XHDR_START
				      "header changed from %s to %.*s",
				      cwp->xhdr_fname,
				      (int)cwp->header.start_len,
				      cwp->header.buf);
		cwp->xhdr_fname_len = get_xhdr_fname(cwp->xhdr_fname,
						     sizeof(cwp->xhdr_fname),
						     dcc_clnt_info);
		if (++dcc_ctxt_sn == 0)
			dcc_ctxt_sn = 1;
		cwp->dcc_ctxt_sn = dcc_ctxt_sn;
	}

	return 1;
}


#define USER_LOG_CAPTION(rcpt_st, s) user_log_write((rcpt_st), (s), LITZ(s))
#define USER_LOG_EOL(rcpt_st) USER_LOG_CAPTION((rcpt_st), "\n")

static u_char
user_log_write(RCPT_ST *rcpt_st, const void *buf, u_int len)
{
	DCC_PATH abs_nm;
	int result;

	if (user_log_fd < 0)
		return 0;

	if (!len)
		len = strlen(buf);
	result = write(user_log_fd, buf, len);
	if (result == (int)len)
		return 1;

	if (result < 0)
		thr_error_msg(rcpt_st->cwp, "write(%s): %s",
			      dcc_fnm2abs_msg(&abs_nm, rcpt_st->user_log_nm.c),
			      ERROR_STR());
	else
		thr_error_msg(rcpt_st->cwp,
			      "write(%s)=%d instead of %d",
			      dcc_fnm2abs_msg(&abs_nm, rcpt_st->user_log_nm.c),
			      result, (int)len);
	dcc_log_close(0, rcpt_st->user_log_nm.c, user_log_fd,
		      &rcpt_st->cwp->ldate);
	user_log_fd = -1;
	return 0;
}



static void DCC_PF(2,3)
user_log_print(RCPT_ST *rcpt_st, const char *p, ...)
{
	char logbuf[LOGBUF_SIZE*2];
	int i;
	va_list args;

	if (user_log_fd < 0)
		return;

	va_start(args, p);
	i = vsnprintf(logbuf, sizeof(logbuf), p, args);
	va_end(args);
	if (i < ISZ(logbuf)) {
		user_log_write(rcpt_st, logbuf, i);
		return;
	}
	user_log_write(rcpt_st, logbuf, sizeof(logbuf));
	user_log_write(rcpt_st, "...", 3);
}



static void
user_log_block(RCPT_ST *rcpt_st,	/* copy from main log file to this */
	       off_t start,		/* starting here */
	       off_t stop)		/* and ending here */
{
	CMN_WORK *cwp;
	char buf[4096];
	int len;
	int result;

	if (user_log_fd < 0)
		return;

	if (start == stop)
		return;

	cwp = rcpt_st->cwp;

	if (start == -1 || stop == -1 || start > stop) {
		thr_error_msg(cwp, "bogus user_log_block position %d to %d",
			      (int)start, (int)stop);
		return;
	}

	if (!log_lseek_set(cwp, start))
		return;

	while ((len = stop - start) != 0) {
		if (len > ISZ(buf))
			len = ISZ(buf);
		result = read(log_fd2, buf, len);
		if (result != len) {
			if (result < 0)
				thr_error_msg(cwp,
					      "user_log_block read(%s,%d): %s",
					      cwp->log_nm.c, len, ERROR_STR());
			else
				thr_error_msg(cwp, "user_log_block"
					      " read(%s,%d)=%d",
					      cwp->log_nm.c, len, result);
			log_fd2_close(-2);
			return;
		}
		if (!user_log_write(rcpt_st, buf, len))
			return;
		start += len;
	}
}


/* print
 *	      env_To: user@example.com			    ok
 *  user@example.com: f7a48ff4 70d29d39 4ed1e36f 104e4fa0
 *		      86e0517b b455b130 4cfccc8c f1a1ff37 Pass
 */
static void
print_addr_sum(LOG_WRITE_FNC out, void *arg,
	       const char *addr,
	       int addr_len,		/* trim trailing '>' from grey addr */
	       const char *sum,
	       int sum_len,		/* trim trailing '>' from env_To */
	       const char *tgts,
	       int tgts_width)		/* to right-justify env_To tgts */
{
	char buf[100];
	int i;

	i = snprintf(buf, sizeof(buf), PRINT_CK_PAT_LIM_CK" %*s\n",
		     addr_len, addr,
		     addr_len > 0 ? ':' : ' ',
		     sum_len, sum,
		     tgts_width, tgts);
	if (i >= ISZ(buf)) {
		i = sizeof(buf);
		buf[i-1] = '\n';
	}
	out(arg, buf, i);
}



static void
print_env_to(LOG_WRITE_FNC out, void *arg, const RCPT_ST *rcpt_st)
{
	const char *addr;
	int addr_len;
	char tgts_buf[16];

	if (rcpt_st->env_to_tgts != 0) {
		addr = rcpt_st->env_to;
		addr_len = strlen(addr);
		if (addr_len > 1 && addr[0] == '<' && addr[addr_len-1] == '>') {
			++addr;
			addr_len -= 2;
		}
		print_addr_sum(out, arg,
			       DCC_XHDR_TYPE_ENV_TO, LITZ(DCC_XHDR_TYPE_ENV_TO),
			       addr, addr_len,
			       tgts2str(tgts_buf, sizeof(tgts_buf),
					rcpt_st->env_to_tgts, 0),
			       PRINT_CK_PAT_SRVR_LEN+PRINT_CK_PAT_WLIST_LEN);
	}

	if (rcpt_st->user_tgts != 0) {
		addr = rcpt_st->user;
		addr_len = strlen(addr);
		if (addr_len > 1 && addr[0] == '<' && addr[addr_len-1] == '>') {
			++addr;
			addr_len -= 2;
		}
		print_addr_sum(out, arg,
			       DCC_XHDR_TYPE_ENV_TO, LITZ(DCC_XHDR_TYPE_ENV_TO),
			       addr, addr_len,
			       tgts2str(tgts_buf, sizeof(tgts_buf),
					rcpt_st->user_tgts, 0),
			       PRINT_CK_PAT_SRVR_LEN+PRINT_CK_PAT_WLIST_LEN);
	}
}



static void
print_grey(LOG_WRITE_FNC out, void *arg,
	   const RCPT_ST *rcpt_st, u_char *headed)
{
#define CK_HEADING	    "       "DCC_XHDR_GREY_RECIP"\n"
#define CK_HEADING_QUERY    "       "DCC_XHDR_GREY_RECIP" query\n"
	char cbuf[CK2STR_LEN];
	char embargo_buf[20];
	const char *addr;
	int addr_len;
	const char *embargo;

	embargo = 0;
	switch (rcpt_st->grey_result) {
	case ASK_GREY_FAIL:
		embargo = DCC_XHDR_EMBARGO_FAIL;
		break;
	case ASK_GREY_OFF:
		return;
	case ASK_GREY_EMBARGO:
		if (rcpt_st->embargo_num > 0) {
			snprintf(embargo_buf, sizeof(embargo_buf),
				 DCC_XHDR_EMBARGO_NUM, rcpt_st->embargo_num);
			embargo = embargo_buf;
		} else {
			embargo = DCC_XHDR_EMBARGO;
		}
		break;
	case ASK_GREY_EMBARGO_END:
		embargo = DCC_XHDR_EMBARGO_ENDED;
		break;
	case ASK_GREY_PASS:
		embargo = DCC_XHDR_EMBARGO_PASS;
		break;
	case ASK_GREY_WHITE:
		embargo = DCC_XHDR_EMBARGO_OK;
		break;
	case ASK_GREY_SPAM:
		snprintf(embargo_buf, sizeof(embargo_buf),
			 DCC_XHDR_EMBARGO_RESET, rcpt_st->embargo_num);
		embargo = embargo_buf;
		break;
	}

	if (!headed || !*headed) {
		if (headed)
			*headed = 1;
		if (rcpt_st->cwp->ask_st & ASK_ST_QUERY)
			out(arg, CK_HEADING_QUERY, LITZ(CK_HEADING_QUERY));
		else
			out(arg, CK_HEADING, LITZ(CK_HEADING));
	}

	addr = rcpt_st->env_to;
	addr_len = strlen(addr);
	if (addr_len > 1 && addr[0] == '<' && addr[addr_len-1] == '>') {
		++addr;
		addr_len -= 2;
	}
	print_addr_sum(out, arg, addr, addr_len,
		       ck2str(cbuf, sizeof(cbuf), DCC_CK_GREY_MSG,
			      &rcpt_st->msg_sum, 0),
		       PRINT_CK_SUM_LEN,
		       "", 0);
	print_addr_sum(out, arg, "", 0,
		       ck2str(cbuf, sizeof(cbuf), DCC_CK_GREY3,
			      &rcpt_st->triple_sum, 0),
		       PRINT_CK_SUM_LEN,
		       embargo, 0);

	if (!headed)
		out(arg, "\n", 1);

#undef CK_HEADING
}



/* log external header, X-DCC header, and DCC results */
static void
log_isspam(LOG_WRITE_FNC fnc, void *cp, CMN_WORK *cwp,
	   u_char log_type,		/* 0="" 1="per-user" 2="global" */
	   FLTR_SWS and_sws, FLTR_SWS or_sws, RCPT_FGS rcpt_fgs)
{
	ASK_ST ask_st;

	ask_st = cwp->ask_st;
	if (rcpt_fgs & RCPT_FG_WLIST_NOTSPAM)
		ask_st |= ASK_ST_WLIST_NOTSPAM;
	if (rcpt_fgs & RCPT_FG_WLIST_ISSPAM)
		ask_st |= ASK_ST_WLIST_ISSPAM;
	log_ask_st(fnc, cp, ask_st, and_sws, or_sws,
		   log_type, &cwp->header);
}



/* log the message for one user */
static void
user_log_msg(CMN_WORK *cwp, RCPT_ST *rcpt_st)
{
	DCC_PATH rcpt_logdir;
	const char *old_log;

	/* since the user wants a log file, make one for the system */
	cwp->ask_st |= ASK_ST_LOGIT;

	/* we need the main log file to create per-user log files */
	if (rcpt_st->dir.c[0] == '\0'
	    || dcc_main_logdir.c[0] == '\0')
		return;

	if (!log2_start(cwp))
		return;

	/* create the user's log file */
	snprintf(rcpt_logdir.c, sizeof(rcpt_logdir), "%s/log", rcpt_st->dir.c);
	/* try to use the same name as the main log file */
	old_log = strrchr(cwp->log_nm.c, '.');
	if (old_log) {
		if (strlen(++old_log) != DCC_MKSTEMP_LEN)
			old_log = 0;
	}
	user_log_fd = dcc_log_open(&cwp->emsg, &rcpt_st->user_log_nm,
				   cwp->id, sizeof(cwp->id), old_log,
				   rcpt_logdir.c, DCC_FIN_LOG_PREFIX,
				   (rcpt_st->sws & FLTR_SW_LOG_M)
				   ? LOG_MODE_MINUTE
				   : (rcpt_st->sws & FLTR_SW_LOG_H)
				   ? LOG_MODE_HOUR
				   : (rcpt_st->sws & FLTR_SW_LOG_D)
				   ? LOG_MODE_DAY
				   : LOG_MODE_FLAT);
	if (user_log_fd < 0) {
		if (user_log_fd == -1)
			thr_error_msg(cwp, "%s", cwp->emsg.c);
		return;
	}

	user_log_block(rcpt_st,		/* copy envelope before env_To line */
		       0, cwp->log_pos_to_first);
	user_log_block(rcpt_st,		/* copy this env_To line */
		       rcpt_st->log_pos_to,
		       rcpt_st->fwd
		       ? rcpt_st->fwd->log_pos_to
		       : cwp->log_pos_to_end);
	user_log_block(rcpt_st,		/* copy the body of the message */
		       cwp->log_pos_to_end,
		       cwp->log_pos_white_first);
	user_log_block(rcpt_st,		/* copy whitelist error messages */
		       rcpt_st->log_pos_white,
		       rcpt_st->fwd
		       ? rcpt_st->fwd->log_pos_white
		       : cwp->log_pos_white_last);
	user_log_block(rcpt_st,		/* copy DCC error messages */
		       cwp->log_pos_white_last,
		       cwp->log_pos_ask_error);

	/* log external header, X-DCC header, and DCC results */
	log_isspam((LOG_WRITE_FNC)user_log_write, rcpt_st, cwp, 1,
		   rcpt_st->sws, rcpt_st->sws, rcpt_st->fgs);

	/* log the checksums and their counts */
	print_cks((LOG_WRITE_FNC)user_log_write, rcpt_st,
		  (cwp->ask_st & ASK_ST_RPT_SPAM) != 0, cwp->local_tgts,
		  &cwp->cks, &rcpt_st->tholds,
		  ((cwp->rcpt_fgs & RCPT_FG_LOG_WTGTS)
		   || (rcpt_st->fgs & RCPT_FG_LOG_WTGTS))
		  ? &rcpt_st->wtgts : 0);
	print_env_to((LOG_WRITE_FNC)user_log_write, rcpt_st, rcpt_st);
	USER_LOG_EOL(rcpt_st);
	print_grey((LOG_WRITE_FNC)user_log_write, rcpt_st, rcpt_st, 0);
}



void
log_smtp_reply(CMN_WORK *cwp)
{
	thr_log_print(cwp, 1, DCC_XHDR_REJ_DATA_MSG"%s %s %s\n",
		      cwp->reply.rcode, cwp->reply.xcode, cwp->reply.str);
}



static void
user_log_smtp_reply(CMN_WORK *cwp, RCPT_ST *rcpt_st)
{
	if (uses_reject_msg)
		user_log_print(rcpt_st, DCC_XHDR_REJ_DATA_MSG"%s %s %s\n",
			       cwp->reply.rcode, cwp->reply.xcode,
			       cwp->reply.str);
}



/* tell the grey list to restore the embargo on a triple */
static void
grey_spam(CMN_WORK *cwp, RCPT_ST *rcpt_st)
{
	DCC_GREY_SPAM gs;
	DCC_OP_RESP resp;

	switch (rcpt_st->grey_result) {
	case ASK_GREY_FAIL:
	case ASK_GREY_OFF:
	case ASK_GREY_WHITE:
		return;
	case ASK_GREY_EMBARGO:
		if (rcpt_st->embargo_num == 0) {
			rcpt_st->grey_result = ASK_GREY_OFF;
			return;
		}
		break;
	case ASK_GREY_EMBARGO_END:
	case ASK_GREY_PASS:
		break;
	case ASK_GREY_SPAM:
		dcc_logbad(EX_SOFTWARE, "cmn_ask_white grey_result=%d",
			   rcpt_st->grey_result);
		return;
	}

	/* do not restore the embargo for traps
	 * or when greylisting is ignoring spam */
	if ((rcpt_st->sws & FLTR_SW_TRAP)
	    || (rcpt_st->sws & FLTR_SW_GREY_IGN_SPAM))
		return;

	memset(&gs, 0, sizeof(gs));

	if (cwp->cks.sums[DCC_CK_IP].type != DCC_CK_IP) {
		thr_error_msg(cwp, "missing IP checksum for grey_spam()");
		return;
	}

	gs.ip.type = DCC_CK_IP;
	gs.ip.len = sizeof(gs.ip);
	memcpy(&gs.ip.sum, &cwp->cks.sums[DCC_CK_IP].sum, sizeof(DCC_SUM));

	gs.triple.type = DCC_CK_GREY3;
	gs.triple.len = sizeof(gs.triple);
	gs.triple.sum = rcpt_st->triple_sum;

	gs.msg.type = DCC_CK_GREY_MSG;
	gs.msg.len = sizeof(gs.msg);
	gs.msg.sum = rcpt_st->msg_sum;

	if (!dcc_clnt_op(&cwp->emsg, cwp->dcc_ctxt, DCC_CLNT_FG_GREY,
			   0, 0, 0, &gs.hdr, sizeof(gs),
			   DCC_OP_GREY_SPAM, &resp, sizeof(resp))) {
		thr_error_msg(cwp, "%s", cwp->emsg.c);
	}

	rcpt_st->grey_result = ASK_GREY_SPAM;
}



/* process the message for each user to decide what to do with it */
void
users_process(CMN_WORK *cwp)
{
	RCPT_ST *rcpt_st;
	u_char need_eol, discard_ok;
	DCC_TGTS trap_dis;
	DNSBL_GBITS common_dnsbl_hits;
	const REPLY_TPLT *reply;
	u_char rep_brag;		/* 2=brag, 1=might brag, 0=no brag */
	int i;

	/* log the DCC results and headers in the common log file */
	log_isspam((LOG_WRITE_FNC)log_write, cwp, cwp, 2,
		   cwp->and_sws, cwp->or_sws, cwp->rcpt_fgs);

	/* log the checksums, DCC server counts and global whitelist values */
	print_cks((LOG_WRITE_FNC)log_write, cwp,
		  (cwp->ask_st & ASK_ST_RPT_SPAM) != 0, cwp->local_tgts,
		  &cwp->cks, &cwp->cks.tholds_rej,
		  (cwp->rcpt_fgs & RCPT_FG_LOG_WTGTS) ? &cwp->wtgts : 0);
	if (cwp->rcpt_fgs & RCPT_FG_LOG_WTGTS) {
		for (rcpt_st = cwp->rcpt_st_first;
		     rcpt_st;
		     rcpt_st = rcpt_st->fwd) {
			print_env_to((LOG_WRITE_FNC)log_write, cwp, rcpt_st);
		}
	}
	LOG_CMN_EOL(cwp);

	/* mark recipients who won't receive it */
	need_eol = 0;
	trap_dis = 0;
	discard_ok = 1;
	common_dnsbl_hits = DNSBL_GMASK;
	rep_brag = 1;
	for (rcpt_st = cwp->rcpt_st_first;
	     rcpt_st;
	     rcpt_st = rcpt_st->fwd) {
		/* Ignore recipients whose RCPT_TO commands were rejected */
		if (rcpt_st->fgs & RCPT_FG_REJ_FILTER)
			continue;

		/* We cannot decide whether the message might be spam
		 * for recipients rejected by the MTA because dccm does not
		 * have the mailer and so cannot find the likely
		 * userdirs/local/user/whiteclnt file */
		if (rcpt_st->fgs & RCPT_FG_BAD_USERNAME)
			continue;

		if (rcpt_st->fgs & RCPT_FG_WHITE) {
			common_dnsbl_hits = 0;
		} else {
			DNSBL_GBITS dnsbl_hits;

			dnsbl_hits = (FLTR_SW_DNSBL_BITS(rcpt_st->sws)
				      & ASK_ST_DNSBL_B_BITS(cwp->ask_st));
			common_dnsbl_hits &= dnsbl_hits;
			if (dnsbl_hits != 0)
				rcpt_st->fgs |= RCPT_FG_ISSPAM;

			/* decide whether it is spam for this recipient */
			if ((rcpt_st->fgs & RCPT_FG_BLACK)
			    || ((cwp->ask_st & ASK_ST_SRVR_ISSPAM)
				&& !(rcpt_st->sws & FLTR_SW_DCC_OFF)))
				rcpt_st->fgs |= RCPT_FG_ISSPAM;

			if ((cwp->ask_st & ASK_ST_REP_ISSPAM)
			    && (rcpt_st->sws & FLTR_SW_REP_ON)) {
				if (rep_brag)
					rep_brag = 2;
				rcpt_st->fgs |= RCPT_FG_ISSPAM;
			}
		}

		/* if one recipient is not using DNS Reputations,
		 * then do not brag about them */
		if (!(rcpt_st->sws & FLTR_SW_REP_ON))
			rep_brag = 0;
		if (rcpt_st->fgs & RCPT_FG_ISSPAM) {
			if (rcpt_st->sws & FLTR_SW_TRAP_DIS) {
				/* spam to a discarding trap */
				++trap_dis;
			} else if ((rcpt_st->sws & FLTR_SW_GREY_IGN_SPAM)
				   && (cwp->ask_st & ASK_ST_GREY_EMBARGO)) {
				/* spam to recipient that greylists even spam */
				 ++cwp->deliver_tgts;
			} else {
				/* normal spam */
				++cwp->reject_tgts;
				if (!(rcpt_st->sws & FLTR_SW_DISCARD_NO)) {
					discard_ok = 0;
				} else if (rcpt_st->sws & FLTR_SW_TRAP_REJ) {
					/* Reject traps should act like
					 * no-such-user errors. */
					cwp->action = CMN_REJECT;
				}
			}
		} else {
			/* normal mail */
			++cwp->deliver_tgts;
		}

		/* Tell greylist to restore the embargo for recipients that
		 * believe the message was spam
		 * and did not white- or blacklist it */
		if ((rcpt_st->fgs & RCPT_FG_ISSPAM)
		    && cwp->action != CMN_IGNORE)
			grey_spam(cwp, rcpt_st);

		print_grey((LOG_WRITE_FNC)log_write, cwp, rcpt_st, &need_eol);
	}
	if (need_eol)
		LOG_CMN_EOL(cwp);

	if (cwp->action == CMN_IGNORE) {
		cwp->deliver_tgts += cwp->reject_tgts;
		cwp->reject_tgts = 0;
	}

	if (cwp->reject_tgts != 0 && cwp->deliver_tgts != 0) {
		/* The mail should be rejected or discarded for some targets
		 * but delivered to others.
		 * We can give the DATA command only one answer. */
		if (!discard_ok) {
			/* Reject the SMTP transaction if at least one of
			 * recipient for which it is spam refuses to let it be
			 * discarded. */
			thr_log_print(cwp, 0, "forced reject for %d targets\n",
				      cwp->deliver_tgts);
			cwp->reject_tgts += cwp->deliver_tgts;
			cwp->deliver_tgts = 0;
		} else {
			/* Otherwise accept the SMTP transaction and discard
			 * the message for recipients that don't want it. */
			thr_log_print(cwp, 0, "forced discard for %d targets\n",
				      cwp->reject_tgts);
			cwp->deliver_tgts += cwp->reject_tgts;
			cwp->reject_tgts = 0;
		}
	}

	/* Prefer to accept the SMTP transaction for discard traps, but let
	 * them leak. */
	if (trap_dis != 0) {
		if (cwp->reject_tgts != 0) {
			cwp->reject_tgts += trap_dis;
		} else if (cwp->deliver_tgts == 0) {
			/* discard mail sent only to discard traps with one
			 * operation */
			cwp->action = CMN_DISCARD;
			cwp->reject_tgts += trap_dis;
		} else {
			cwp->deliver_tgts += trap_dis;
		}
	}

	/* do not greylist embargo the message if no target wants it */
	if (cwp->deliver_tgts == 0)
		cwp->ask_st &= ~ASK_ST_GREY_EMBARGO;
	if (cwp->ask_st & ASK_ST_GREY_EMBARGO) {
		make_reply(&cwp->reply, &grey_reply, cwp, 0);
		return;
	}

	/*  finished if it is not spam or we won't do anything about it */
	if (cwp->reject_tgts == 0 || cwp->action != CMN_REJECT)
		return;

	/* make an SMTP rejection message unless we have already have one */
	if (cwp->reply.log_result)
		return;

	/* brag about reputations */
	if (rep_brag > 1) {
		make_reply(&cwp->reply, &reputation_reply, cwp, 0);
		return;
	}

	/* if possible, use a DNSBL rejection message that applies
	 * to all recipients */
	if (common_dnsbl_hits != 0) {
		const DNSBL_HGROUP *hg;

		for (i = 0; i < NUM_DNSBL_GROUPS; ++i) {
			if (!(common_dnsbl_hits & DNSBL_G2B(i)))
				continue;
			hg = &cwp->cks.dlw->hgroups[i];
			reply = hg->dnsbl->reply;
			if (reply) {
				make_reply(&cwp->reply, reply, cwp, hg);
				return;
			}
		}
	}

	/* use the generic DCC rejection message */
	make_reply(&cwp->reply, &reject_reply, cwp, 0);
}



/* after having checked each user or recipient,
 *	dispose of the message for one of them */
static void
user_log_result(CMN_WORK *cwp, RCPT_ST *rcpt_st, const char *mta_msg)
{
	if (rcpt_st->rej_msg[0] != '\0') {
		/* log rejection result for this recipient in the main log */
		thr_log_print(cwp, 0, DCC_XHDR_REJ_RCPT_PAT,
			      rcpt_st->env_to, rcpt_st->rej_msg);

		/* per-user log file */
		if (!(rcpt_st->fgs & RCPT_FG_REJ_FILTER)
		    || (rcpt_st->sws & FLTR_SW_LOG_ALL)) {
			user_log_msg(cwp, rcpt_st);

			user_log_print(rcpt_st, DCC_XHDR_REJ_RCPT_PAT,
				       rcpt_st->env_to, rcpt_st->rej_msg);
			if (rcpt_st->rej_msg[0] == '4')
				USER_LOG_CAPTION(rcpt_st,
						 DCC_XHDR_RESULT
						 DCC_XHDR_RESULT_REJECT
						 " temporarily\n");
			else
				USER_LOG_CAPTION(rcpt_st,
						 DCC_XHDR_RESULT
						 DCC_XHDR_RESULT_REJECT);
		}
		return;
	}

	/* create the per-user log file */
	if ((rcpt_st->fgs & RCPT_FG_ISSPAM)
	    || ((cwp->ask_st & ASK_ST_GREY_LOGIT)
		&& !(rcpt_st->sws & FLTR_SW_GREY_LOG_OFF))
	    || (rcpt_st->sws & FLTR_SW_LOG_ALL))
		user_log_msg(cwp, rcpt_st);

	if (cwp->ask_st & ASK_ST_INVALID_MSG) {
		user_log_print(rcpt_st, DCC_XHDR_RESULT"%s\n", mta_msg);
		return;
	}

	if (cwp->ask_st & ASK_ST_GREY_EMBARGO) {
		user_log_smtp_reply(cwp, rcpt_st);
		if (rcpt_st->embargo_num != 0) {
			user_log_print(rcpt_st,
				       DCC_XHDR_RESULT"%s #%d\n",
				       cwp->reply.log_result,
				       rcpt_st->embargo_num);
		} else {
			user_log_print(rcpt_st, DCC_XHDR_RESULT"%s\n",
				       cwp->reply.log_result);
		}
		return;
	}

	if (!(rcpt_st->fgs & RCPT_FG_ISSPAM)) {
		/* It is not spam for this target.
		 *
		 * If it was rejected late, e.g. by the SMTP server for dccifd
		 * in proxy, mode, then log the rejection message */
		if (mta_msg) {
			if (cwp->reply.str && cwp->reply.str[0] != '\0')
				user_log_print(rcpt_st,
					       DCC_XHDR_REJ_DATA_MSG"%s\n",
					       cwp->reply.str);
			user_log_print(rcpt_st, DCC_XHDR_RESULT"%s\n",
				       mta_msg);
			return;
		}

		/* Log the rejection if it was spam for some other target */
		if (cwp->reject_tgts != 0) {
			user_log_smtp_reply(cwp, rcpt_st);
			USER_LOG_CAPTION(rcpt_st,
					 DCC_XHDR_RESULT
					 DCC_XHDR_RESULT_REJECT
					 DCC_XHDR_RESULT_FORCED"\n");
			return;
		}

		if (cwp->ask_st & (ASK_ST_CLNT_ISSPAM
				   | ASK_ST_SRVR_ISSPAM
				   | ASK_ST_REP_ISSPAM)) {
			if (cwp->rcpt_fgs & RCPT_FG_GREY_END)
				USER_LOG_CAPTION(rcpt_st,
						 DCC_XHDR_RESULT
						 DCC_XHDR_RESULT_I_A
						 " "DCC_XHDR_RESULT_A_GREY"\n");
			else
				USER_LOG_CAPTION(rcpt_st,
						 DCC_XHDR_RESULT
						 DCC_XHDR_RESULT_I_A"\n");
			return;
		}
		if (cwp->rcpt_fgs & RCPT_FG_GREY_END) {
			USER_LOG_CAPTION(rcpt_st,
					 DCC_XHDR_RESULT
					 DCC_XHDR_RESULT_ACCEPT
					 " "DCC_XHDR_RESULT_A_GREY"\n");
			return;
		}
		if (rcpt_st->fgs & RCPT_FG_GREY_WHITE) {
			USER_LOG_CAPTION(rcpt_st,
					 DCC_XHDR_RESULT
					 DCC_XHDR_RESULT_ACCEPT
					 ";  greylist whitelist\n");
			return;
		}
		USER_LOG_CAPTION(rcpt_st,
				 DCC_XHDR_RESULT DCC_XHDR_RESULT_ACCEPT"\n");
		return;
	}


	/* spam for this target */

	if (cwp->deliver_tgts != 0
	    && cwp->action != CMN_IGNORE) {
		/* other recipients do not want the SMTP transaction rejected
		 * or the message discarded by the MTA */
		if (can_discard_1) {
			++totals.tgts_discarded;
			user_reject_discard(cwp, rcpt_st);

			if (cwp->action == CMN_DISCARD
			    || (rcpt_st->sws & FLTR_SW_TRAP)) {
				USER_LOG_CAPTION(rcpt_st, DCC_XHDR_RESULT
						 DCC_XHDR_RESULT_DISCARD"\n");
				return;
			}

			if (cwp->action == CMN_REJECT) {
				thr_log_print(cwp, 0,
					      DCC_XHDR_RESULT
					      DCC_XHDR_RESULT_DISCARD
					      " forced for %s\n",
					      rcpt_st->env_to);
				USER_LOG_CAPTION(rcpt_st,
						 DCC_XHDR_RESULT
						 DCC_XHDR_RESULT_DISCARD
						 DCC_XHDR_RESULT_FORCED"\n");
				return;
			}
		}

		thr_log_print(cwp, 0,
			      DCC_XHDR_RESULT
			      DCC_XHDR_RESULT_I_A
			      " forced for %s\n",
			      rcpt_st->env_to);
		USER_LOG_CAPTION(rcpt_st,
				 DCC_XHDR_RESULT
				 DCC_XHDR_RESULT_I_A
				 DCC_XHDR_RESULT_FORCED"\n");
		return;
	}

	/* spam for all targets including this one */

	if (cwp->action == CMN_DISCARD) {
		if (rcpt_st->sws & FLTR_SW_TRAP_REJ) {
			USER_LOG_CAPTION(rcpt_st, DCC_XHDR_RESULT
					 DCC_XHDR_RESULT_DISCARD
					 DCC_XHDR_RESULT_FORCED"\n");
		} else {
			USER_LOG_CAPTION(rcpt_st, DCC_XHDR_RESULT
					 DCC_XHDR_RESULT_DISCARD"\n");
		}
		return;
	}

	if (cwp->action == CMN_IGNORE) {
		if (rcpt_st->sws & FLTR_SW_TRAP) {
			USER_LOG_CAPTION(rcpt_st, DCC_XHDR_RESULT
					 DCC_XHDR_RESULT_I_A
					 DCC_XHDR_RESULT_FORCED"\n");
		} else {
			USER_LOG_CAPTION(rcpt_st, DCC_XHDR_RESULT
					 DCC_XHDR_RESULT_I_A"\n");
		}
		return;
	}

	user_log_smtp_reply(cwp, rcpt_st);
	if (rcpt_st->sws & FLTR_SW_TRAP_DIS) {
		user_log_print(rcpt_st, DCC_XHDR_RESULT
			       "%s"DCC_XHDR_RESULT_FORCED"\n",
			       cwp->reply.log_result);
	} else {
		user_log_print(rcpt_st, DCC_XHDR_RESULT"%s\n",
			       cwp->reply.log_result);
	}
}



/* log the consensus in each target's log file */
void
users_log_result(CMN_WORK *cwp,
		 const char *mta_msg)	/* 0 or reject by MTA */
{
	RCPT_ST *rcpt_st;
	int error;

	error = pthread_mutex_lock(&user_log_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_lock(user_log): %s",
			   ERROR_STR1(error));
	user_log_owner = pthread_self();

	/* create individual log files and trim target list */
	for (rcpt_st = cwp->rcpt_st_first; rcpt_st; rcpt_st = rcpt_st->fwd) {
		if (rcpt_st->fgs & RCPT_FG_BAD_USERNAME)
			continue;
		if ((cwp->ask_st & ASK_ST_INVALID_MSG)
		    && !(rcpt_st->sws & FLTR_SW_LOG_ALL))
			continue;

		user_log_result(cwp, rcpt_st, mta_msg);

		if (user_log_fd >= 0) {
			dcc_log_close(0, rcpt_st->user_log_nm.c,
				      user_log_fd, &cwp->ldate);
			user_log_fd = -1;
		}
	}

	log_fd2_close(-1);

	user_log_owner = 0;
	error = pthread_mutex_unlock(&user_log_mutex);
	if (error)
		dcc_logbad(EX_SOFTWARE, "pthread_mutex_unlock(user_log): %s",
			   ERROR_STR1(error));
}
