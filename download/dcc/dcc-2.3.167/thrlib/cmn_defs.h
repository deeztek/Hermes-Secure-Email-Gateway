/* Distributed Checksum Clearinghouse
 *
 * common threaded client definitions
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
 * Rhyolite Software DCC 2.3.167-1.100 $Revision$
 */

#ifndef CLNT_DEFS_H
#define CLNT_DEFS_H

#include "dcc_ck.h"
#include "dcc_xhdr.h"
#include "dcc_heap_debug.h"
#ifdef HAVE_PTHREAD_H
#include <pthread.h>
#else
#include <sys/pthread.h>
#endif
#include <sys/un.h>
#include <sys/resource.h>
#include <arpa/inet.h>
#include <signal.h>


/* what to do about checksums whose counts say "spam" */
typedef enum {
    CMN_REJECT = 0,			/* tell sendmail to reject spam */
    CMN_DISCARD,			/* discard spam */
    CMN_IGNORE				/* ignore spam reports */
} CMN_ACTION;
extern CMN_ACTION action;

typedef enum {
    SETHDR, ADDHDR, NOHDR
} CHGHDR;
extern CHGHDR chghdr;

/* options for dccifd and dccm that do not take argument strings
 *	Fix cgi-bin/common* and misc/start-dccm if changed */
#define SLARGS "dbxANPQWV"

typedef struct {
    int	    msgs;			/* total messages */
    int	    tgts;			/* total addressees */
    int	    tgts_discarded;		/* discarded for this many addressess */
    int	    tgts_rejected;
    int	    tgts_ignored;
    int	    tgts_embargoed;
    int	    msgs_embargoed;
    int	    msgs_spam;
    time_t  msg_prev, msg_next;
} TOTALS;
extern TOTALS totals;


/* This is a wild guess of open files hidden in libraries and elsewhere.
 * Some systems such as Solaris seem to have an amazing number of them
 * Each whitelist context involves an open hash table file */
#define EXTRA_FILES	(32 + DCC_NUM_CWFS)

#define MAX_SELECT_WORK ((FD_SETSIZE-EXTRA_FILES)/FILES_PER_JOB)
/*  dccm and dccifd have differing values for FILES_PER_JOB */
#define MIN_MAX_WORK    2
extern int max_max_work;
extern const char *max_max_work_src;
extern int max_work;
extern int init_work;
extern int total_work;


typedef struct {
    const char *log_result;		/* "reject" etc. for log */
    const char *rcode;
    const char *xcode;
    const char *str;
    char    str_buf[REPLY_BUF_LEN];
} REPLY_STRS;
#define DCC_RCODE   "550"
#define DCC_XCODE   "5.7.1"
extern REPLY_TPLT reject_reply;
extern REPLY_TPLT grey_reply;
extern REPLY_TPLT reputation_reply;
extern REPLY_TPLT dcc_fail_reply;


/* Some of these flags are computed for all recipients (e.g. white- or
 *	blacklisting from the main whiteclnt file) in the common flags and
 *	then copied to individual recipient flags words.
 *	Others are kept only in the common word. */
typedef u_short RCPT_FGS;
#    define	 RCPT_FG_NULL_WHITECLNT	0x0001	/* no entries in it */
#    define	 RCPT_FG_REJ_FILTER	0x0002	/* rejected by dccifd or dccm */
#    define	 RCPT_FG_BAD_USERNAME	0x0004	/* user bad & rejected by MTA */
#    define	 RCPT_FG_WLIST_ISSPAM	0x0008	/* whiteclnt blacklisted */
#    define	 RCPT_FG_WLIST_NOTSPAM	0x0010	/* whiteclnt whitelisted */
#    define	 RCPT_FG_WHITE		0x0020
#    define	 RCPT_FG_BLACK		0x0040
#    define	 RCPT_FG_LOG_WTGTS	0x0080  /* log result from wlist */
#    define	 RCPT_FG_ISSPAM		0x0100	/* result for this target */
#    define	 RCPT_FG_GREY_END	0x0200	/* end of greylist embargo */
#    define	 RCPT_FG_GREY_WHITE	0x0400	/* whitelisted for greylist */
#    define	 RCPT_FG_INCOMPAT_REJ	0x0800  /* incompatible & so rejected */

/* per-recipient state */
typedef struct rcpt_st {
    struct rcpt_st  *fwd;
    struct cmn_work *cwp;
    off_t	    log_pos_to;		/* env_To line in main log file */
    off_t	    log_pos_white;
    CKS_WTGTS	    wtgts;
    DCC_TGTS	    env_to_tgts, user_tgts;
    ASK_GREY_RESULT grey_result;
    u_int	    embargo_num;
    DCC_SUM	    wf_sum;
    CKSUM_THOLDS    tholds;
    FLTR_SWS	    sws;
    RCPT_FGS	    fgs;
    RCPT_FGS	    global_env_to_fgs;	/* global whiteclnt env_to result */
    RCPT_FGS	    env_to_fgs;		/* per-user whiteclnt env_to result */
#    define	     RCTP_MAXNAME 257	/* sendmail MAXNAME limit */
    char	    env_to[RCTP_MAXNAME];   /* env_to */
    char	    user[RCTP_MAXNAME];	/* mailbox */
    char	    rej_msg[REPLY_BUF_LEN];
    DCC_SUM	    env_to_sum;
    DCC_SUM	    user_sum;
    DCC_SUM	    msg_sum;
    DCC_SUM	    triple_sum;
    DCC_PATH	    dir;		/* recipient's whitelist and logdir */
    DCC_PATH	    user_log_nm;
} RCPT_ST;


/* per message state common to threaded DCC clients */
typedef struct cmn_work {
    struct work	*wp;
    DCC_CLNT_CTXT *dcc_ctxt;
    u_int	dcc_ctxt_sn;
    struct timeval ldate;
    CMN_ACTION	action;
    u_int	xhdr_fname_len;
    char	xhdr_fname[sizeof(DCC_XHDR_START)+sizeof(DCC_BRAND)+1];
    char	clnt_name[DCC_MAXDOMAINLEN];	/* SMTP client */
    char	clnt_str[INET6_ADDRSTRLEN+1];
    struct in6_addr clnt_addr;
    char	sender_name[DCC_MAXDOMAINLEN];	/* source of mail message */
    char	sender_str[INET6_ADDRSTRLEN+1];
    char	helo[HELO_MAX];
    char	env_from[ENV_FROM_MAX+1];
    char	mail_host[DCC_MAXDOMAINLEN];  /* Mail_From host name */
    char	id[MSG_ID_LEN+1];
    DCC_EMSG	emsg;
    DCC_PATH    tmp_nm;
    DCC_PATH	log_nm;			/* log file for this message */
    int		num_rcpts;
#    define	 MAX_RCPTS 1024
    RCPT_ST	*rcpt_st_first, *rcpt_st_last;
    int		log_fd;			/* -1=none */
    int		tmp_fd;			/* copy of entire message */
    DCC_HEADER_BUF header;
    EARLY_LOG	early_log;

    u_short	cmn_fgs;
#    define	 CMN_FG_ENV_LOGGED  0x0001  /* have logged the envelope */
#    define	 CMN_FG_LOG_EARLY   0x0002  /* too early to write to log file */
#    define	 CMN_FG_CHECK_REP   0x0004  /* check DCC reputations */
#    define	 CMN_FG_VIA_MX	    0x0008  /* don't reject MX secondary */
#    define	 CMN_FG_VIA_SUBMIT  0x0010  /* SMTP submission clients */
#    define	 CMN_FG_PARSE_RCVD  0x0020  /* parse Received: for source */
#    define	 CMN_FG_BAD_RELAY   0x0040  /* relay attack */
#    define	 CMN_FG_LOCAL_SPAM  0x0080

    GOT_CKS	cks;
    CKSUM_THOLDS tholds_base;

#define CMN_WORK_ZERO log_ip_pos	/* here down cleared for each msg */

    off_t	log_ip_pos;		/* position and length of IP: line */
    int		log_ip_len;
    off_t	log_pos_to_first;	/* first env_To line in log file */
    off_t	log_pos_to_end;		/* end of env_To lines in log file */
    off_t	log_pos_white_first;	/* first whitelist result */
    off_t	log_pos_white_last;	/* last whitelist result */
    off_t	log_pos_ask_error;	/* final DCC errors */
    u_int	max_embargo_num;
    REPLY_STRS	reply;
    DCC_TGTS	tgts;			/* total accepted Mail_From values */
    DCC_TGTS	white_tgts;		/* # of ->tgts whitelisting message */
    DCC_TGTS	reject_tgts;		/* # of ->tgts rejecting message */
    DCC_TGTS	deliver_tgts;		/* # of ->tgts wanting the message */
    DCC_TGTS	mta_rej_tgts;		/* not accepted by order of MTA */
    DCC_TGTS	early_grey_tgts;	/* report to DCC if embargoed */
    DCC_TGTS	late_grey_tgts;		/* don't report to DCC if delivered */
    DCC_TGTS	local_tgts;		/* what we told the DCC server */
    size_t	log_size;
    CKS_WTGTS	wtgts;
    FLTR_SWS	init_sws;		/* initial value for rcpt_st->sws */
    FLTR_SWS	and_sws, or_sws;
    RCPT_FGS	rcpt_fgs;
    ASK_ST	ask_st;			/* ASK_ST_* */
} CMN_WORK;


extern u_int dcc_ctxt_sn;		/* change X-DCC header server name */

extern RCPT_ST *rcpt_st_free;

const char *userdirs;

extern u_char dcc_query_only;
extern u_char can_discard_1;		/* 1=can trim targets after DATA */
extern u_char can_reject_1;		/* 1=can reject Rcpt_To commands */
extern u_char uses_reject_msg;		/* not dccifd ASCII protocol */
extern u_char try_extra_hard;		/* 0 or DCC_CLNT_FG_NO_FAIL */
extern u_char to_white_only;
extern const char *mapfile_nm;
extern const char *main_white_nm;

extern pthread_mutex_t user_log_mutex;
extern pthread_t user_log_owner;

extern void clnt_sigs_off(sigset_t *);

extern void parse_userdirs(const char *);
extern u_char get_user_dir(RCPT_ST *, const char *, int, const char *, int);
extern void make_tplt(REPLY_TPLT *, u_char,
		      const char *, const char *, const char *, const char *);
extern void parse_reply_arg(const char *);
extern void make_reply(REPLY_STRS *, const REPLY_TPLT *,
		       const CMN_WORK *, const DNSBL_HGROUP *);
extern void finish_replies(void);
extern void cmn_init(void);
extern void cmn_create(CMN_WORK *);
extern u_char cmn_open_tmp(CMN_WORK *);
extern void cmn_close_tmp(CMN_WORK *);
extern u_char cmn_write_tmp(CMN_WORK *cwp, const void *, int);
extern void check_mx_listing(CMN_WORK *);
extern void cmn_clear(CMN_WORK *, struct work *, u_char);
extern void free_rcpt_sts(CMN_WORK *, u_char);
extern RCPT_ST *alloc_rcpt_st(CMN_WORK *, u_char);
extern void log_start(CMN_WORK *);
extern void log_stop(CMN_WORK *);
extern void log_write(CMN_WORK *, const void *, u_int);
extern void log_body_write(CMN_WORK *, const char *, u_int);
#define LOG_CMN_CAPTION(cwp, s) log_write(cwp, s, LITZ(s))
#define LOG_CMN_EOL(cwp) LOG_CMN_CAPTION(cwp, "\n")
#define LOG_CAPTION(wp, s) LOG_CMN_CAPTION(&(wp)->cw, s)
#define LOG_EOL(wp) LOG_CAPTION(wp, "\n")
extern off_t log_lseek_get(CMN_WORK *);
extern void thr_log_late(CMN_WORK *);
extern void thr_log_envelope(CMN_WORK *, u_char);
extern u_char ck_dcc_ctxt(CMN_WORK *);
extern int cmn_compat_whitelist(CMN_WORK *, RCPT_ST *);
void cmn_ask_dnsbl(CMN_WORK *);
extern void cmn_ask_white(CMN_WORK *);
extern int cmn_ask_dcc(CMN_WORK *);
extern void users_process(CMN_WORK *);
extern void users_log_result(CMN_WORK *, const char *);

extern void user_reject_discard(CMN_WORK *, RCPT_ST *);
extern void log_smtp_reply(CMN_WORK *);

extern void totals_init(void);
extern void totals_stop(void);
extern void work_clean(void);


#endif /* CLNT_DEFS_H */
