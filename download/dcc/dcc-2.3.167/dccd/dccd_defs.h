/* Distributed Checksum Clearinghouse
 *
 * server daemon definitions
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
 * Rhyolite Software DCC 2.3.167-1.270 $Revision$
 */

#ifndef DCCD_DEFS_H
#define DCCD_DEFS_H

#include "srvr_defs.h"
#include "dcc_xhdr.h"

extern DCC_EMSG dcc_emsg;

extern u_char grey;
extern u_char background;
extern int stopint;

extern DCC_SRVR_ID my_srvr_id;

extern const char *brand;		/* our brand name */

extern DCC_GETH use_ipv46;
extern u_char use_ipv46_set;
extern u_char have_ipv6_peer;
extern in_port_t def_port;
typedef struct srvr_soc {
    struct srvr_soc *fwd;
    DCC_SOCKU	udp_su;			/* specified local address */
    DCC_SOCKU	listen_su;
    int		udp;			/* UDP socket */
    int		listen;			/* incoming flood connection socket */
    u_char	flags;
#    define	 SRVR_SOC_ADDR	    0x01    /* explicit IP address */
#    define	 SRVR_SOC_IF	    0x02    /* port on all interfaces */
#    define	 SRVR_SOC_ANY_LISTEN 0x4    /* need IN_ADDR_ANY listen socket */
#    define	 SRVR_SOC_MARK	    0X08
#    define	 SRVR_SOC_NEW	    0X10
} SRVR_SOC;
extern SRVR_SOC *srvr_socs;

extern int socbuf;


#define MAX_CMD_CLOCK_SKEW (DCC_MAX_RETRANS_DELAY_SECS*2)
#define MAX_FLOD_CLOCK_SKEW (2*60*60)	/* refuse reports this far in advance */


extern char our_hostname[MAXHOSTNAMELEN];
extern DCC_SUM host_id_sum;		/* advertised with our server-ID */
extern time_t host_id_next, host_id_range;
#define SRVR_ID_REP_SECS    (12*60*60)	/* advertise server-IDs this often */

#define	SRVR_ID_TYPE_SECS   (6*60*60)	/* keep rogue & rep data current */

#define	DATE_RCD_REP_SECS   (30*60)	/* timestamp records this often */
#define DATE_RCD_RANGE_DAYS 5		/* 5 days of timestamp/keepalives */
#define DATE_RCD_PAT	    "%d %02d:%02d"

extern u_char flod_msg_gen;		/* unsuppress tracing */

/* keepalive intervals
 *	An idle flooding link is kept alive, or known to be healthy, by the
 *	receiving server repeating its current position.  If the link is
 *	broken, the receiving server's transmissions of its position will fail
 *	and the	transmitting server will hear silence on the link. */
#define	KEEPALIVE_IN	    (10*60)
#define	KEEPALIVE_OUT	    (KEEPALIVE_IN+FLODS_CK_SECS)
/* Things should be quicker while we are shutting down flooding
 *	Some TCP/IP implementations have retransmission delays that can
 *	totals 7 seconds, so we must not be too quick */
#define KEEPALIVE_IN_STOP   30
#define	KEEPALIVE_OUT_STOP  (KEEPALIVE_IN_STOP+FLODS_CK_SECS)
/* be really quick if stopping the daemon */
#define SHUTDOWN_DELAY	    2

#define IFP_DEAD(p,secs)  DB_IS_TIME((p)->iflod_alive+(secs), secs)
#define OFP_DEAD(p,secs)  DB_IS_TIME((p)->oflod_alive+(secs), secs)


/* Delay our reports and summaries of our reports by this much.
 * It should be long enough to allow us to generate useful summaries, but
 * it cannot be so long that we won't flood the summary when we make it. */
extern int summarize_delay_secs;
extern DB_PTR summarize_limit;
extern time_t summarize_limit_secs;


extern u_int queue_max;

extern u_char anon_off;			/* turn off anonymous access */
extern u_char query_only;		/* 1=treat reports as queries */

extern u_int32_t anon_delay_us;		/* anonymous client delay */
extern u_int anon_delay_inflate;

extern struct timeval wake_time;	/* when we awoke from select() */
extern struct timeval req_recv_time;	/* when request arrived */

extern u_char grey_weak_body;		/* 1=ignore bodies for greylisting */
extern u_char grey_weak_ip;		/* 1=one good triple whitelists addr */

extern int grey_embargo;
extern int grey_window;
extern int grey_white;


/* rate limiting
 *	One of these structures is maintained for every recent client,
 *	where "recent" is at least one day */
typedef u_int16_t RL_DATA_FG;
#    define	 RL_FG_MARKED	    0x0001  /* seen during `cdcc clients` */
#    define	 RL_FG_BLOCK	    0x0002  /* is an address block summary */
#    define	 RL_FG_BLACK_SET    0x0004
#    define	 RL_FG_BLOCK_SET    0x0008
#    define	 RL_FG_TRACE_ID	    0x0010  /* trace by ids file */
#    define	 RL_FG_TRACE_ADDR   0x0020  /* trace by address in flod file */
#    define	  RL_FG_TRACE	 (RL_FG_TRACE_ID | RL_FG_TRACE_ADDR)
#    define	 RL_FG_BLACK_ID	    0x0040  /* blacklisted client ID */
#    define	 RL_FG_BLACK_ADDR   0x0080  /* blacklisted by addr */
#    define	 RL_FG_FLOD_OK	    0x0100  /* do not blacklist for flooding */
#    define	 RL_FG_PASSWD	    0x0200  /* bad password */
#    define	 RL_FG_UKN_ID	    0x0400  /* bad ID for this request */
#    define	 RL_FG_NO_AUTH	    0x0800  /* no or bad passwd */
#    define	 RL_FG_BLOCK_BLACK  0x1000  /* block for this is blacklisted */
#    define	 RL_FG_DROPPED	    0x2000  /* something ignored sometime */
typedef struct {
    DCC_SCNTR   reqs;
    DCC_SCNTR   reqs_old;
    DCC_SCNTR   nops;
    DCC_SCNTR	nops_old;
    DCC_SCNTR	reqs_avg_total;
    DCC_SCNTR	nops_avg_total;
    u_int32_t	reqs_avg;
    u_int32_t	nops_avg;
#    define	 RL_REQS_AVG(d) max((d)->reqs_avg, (d)->reqs)
#    define	 RL_NOPS_AVG(d)	max((d)->nops_avg, (d)->nops)
    DCC_PTIME	last_used;
#    define	 CLIENTS_AGE	(24*60*60)
#    define	 CLIENTS_SAVE_AGE (14*CLIENTS_AGE)
    DCC_PTIME	avg_start;		/* effective start of averaging */
#    define	 RL_AVG_DAY	(24*60*60)
#    define	 RL_AVG_TERM	(2*RL_AVG_DAY)
    DCC_PTIME	avg_last_aged;		/* when last updated */
#    define	 RL_AVG_UPDATE	(10*60)
    int32_t	request_credits;	/* limit operations */
    union {
	int32_t	    bug_credits;	/* limit complaints about this client */
	DCC_PTIME   block_used;
    } u;
    struct in6_addr addr;
    DCC_CLNT_ID	id;
    u_char	pkt_vers;		/* client-server protocol version */
    RL_DATA_FG	fgs;
} RL_DATA;
typedef struct rl {
    struct rl	*hfwd, *hbak, **bin;	/* neighbors in hash chain & the bin */
    struct rl	*older, *newer;		/* global recently used chain */
    RL_DATA	d;
    u_short	ref_cnt;		/* in use by an entry in job queue */
} RL;


/* rate-limit parameters
 *	Decrease request_credits by RL_SCALE for each event.
 *	Increase request_credits by .per_sec for every second.
 *	When request_credits <= 0, there have been too many events.
 *	Clamp request_credits at .lo to limit the duration of a penalty.
 *	Clamp request_credits at .hi to limit the duration over which
 *	    the rate is averaged.
 */
typedef struct {
    float   penalty_secs;		/* drop excess events for this long */
    int	    per_sec;			/* allowed events/second * RL_SCALE */
    int	    lo;				/* clamp credit count at this */
    int	    hi;				/* reset credit count to this */
} RL_RATE;

extern RL_RATE rl_sub_rate;		/* X/sec/paying customer */
extern RL_RATE rl_anon_rate;		/* X/sec/freeloader */
extern RL_RATE rl_all_anon_rate;	/* X/sec for all freeloaders */
extern RL_RATE rl_bugs_rate;		/* X complaints/sec */

#define DCC_RL_INIT	20		/* private servers have few clients */
#define DCC_RL_MAX_MAX  (2*1000*1000)
#define DCC_RL_MAX_MIN  1000
#if DCC_RL_MAX != 0 && DCC_RL_MAX < DCC_RL_MAX_MIN
#undef DCC_RL_MAX
#define DCC_RL_MAX  DCC_RL_MAX_MIN
#endif
#if DCC_RL_MAX > DCC_RL_MAX_MAX
#undef DCC_RL_MAX
#define DCC_RL_MAX  DCC_RL_MAX_MAX
#endif
#define RL_AVG_SECS	10		/* average for this many seconds */
#define	RL_LIFE_SECS    (RL_AVG_SECS*2)	/* lifetime of rate limit block */

#define RL_OVF_CREDITS	0x7fffffff	/* fit {bug,request}_credits */
#define RL_SCALE	10
#define RL_MAX_CREDITS	(RL_OVF_CREDITS/RL_AVG_SECS/RL_SCALE/2)


extern DCC_PTIME clients_cleared;


/* file containing rate limit blocks */
#define CLIENTS_NM()	    (grey_on ? "grey_clients" : "dccd_clients")
#define CLIENTS_NM_NEW()    (grey_on ? "grey_clients-new" : "dccd_clients-new")
#define BAD_CLIENTS_NM()    (grey_on ? "grey_clients-bad" : "dccd_clients-bad")

typedef struct {
    char	magic[128];
    DCC_PTIME	now;
    DCC_PTIME	cleared;
    u_int32_t	anon_delay_us;
    u_int32_t	anon_delay_inflate;
    u_int32_t	blocks;
} CLIENTS_HEADER;
#define CLIENTS_MAGIC_VERSION	"14"
#define CLIENTS_MAGIC_STR	" client rate limit blocks version "
#define CLIENTS_MAGIC_BASE(g)	((g) ? "greylist" CLIENTS_MAGIC_STR	\
				 : "dccd" CLIENTS_MAGIC_STR)
#define CLIENTS_MAGIC_V(g,v)	((g) ? "greylist" CLIENTS_MAGIC_STR v	\
				 : "dccd" CLIENTS_MAGIC_STR v)
#define CLIENTS_MAGIC(g)	CLIENTS_MAGIC_V(g,CLIENTS_MAGIC_VERSION)



/* report cache used to detect duplicate reports
 *	One of these structures is maintained for every current operation */
typedef struct {
    time_t	last_used;
    DCC_HDR	hdr;
    in_port_t	clnt_port;
    int		len;
    u_char	op;
    u_char	bad;
    union {
	DCC_ANSWER_BODY_CKS b;
	DCC_ADMN_RESP_ANON_DELAY anon_delay;
	char		msg[DCC_ERROR_MSG_LEN];
    } result;
} RIDC_DATA;
typedef struct ridc {
    struct ridc *hfwd, *hbak, **bin;
    struct ridc *older, *newer;
    RIDC_DATA	d;
} RIDC;

typedef struct ridc_hash RIDC_HASH;
struct ridc_hash {
    time_t	check_time;
    u_int32_t   num_bins;
    u_int32_t   probes;
    u_int32_t   searches;
    RIDC	*bins[1];
};


/* entry in main job queue */
typedef struct dccd_queue {
    struct dccd_queue *later, *earlier;
    RL		*ip_rl, *block_rl;
    RIDC	*ridc;
    SRVR_SOC	*sp;
    DCC_CLNT_ID	clnt_id;
    DCC_SOCKU	clnt_su;		/* send answer here */
    u_int	pkt_len;
    time_t	delay_us;		/* how long to delay the answer */
    struct timeval answer;		/* when it should be answered */
    u_char	flags;
#    define	 Q_FG_RPT_OK	    0x01    /* override dccd -Q */
#    define	 Q_FG_TRUSTED	    0x02    /* good client-ID & password */
#    define	 Q_FG_REPS_RPT_OK   0x04    /* DCC reputation reports ok */
#    define	 Q_FG_REPS_ANS_OK   0x08    /* DCC reputation answers ok */
#    define	 Q_FG_HAVE_TS	    0x10
#    define	 Q_FG_USED_TS	    0x20
#    define	 Q_FG_TRACED	    0x40
#    define	 Q_FG_BAD_OP	    0x80
    DCC_TS	ts;
    DCC_PASSWD	passwd;			/* sign answers with this */
    union {
	DCC_HDR	    hdr;
	/* ************* everything above is zeroed ******* */
	DCC_REPORT  r;
	DCC_DELETE  d;
	DCC_GREY_SPAM gs;
	DCC_ADMN_REQ ad;
    } pkt;
} QUEUE;


typedef struct iflod_info IFLOD_INFO;

typedef struct {
    int	    cur, lim;			/* signed because lim can be <0 */
} FLOD_LIMCNT;
#define FLOD_LIM_CLEAR_SECS	(5*60)
#define FLOD_LIM_COMPLAINTS	10

typedef u_int OPT_FLAGS;
typedef struct {
    OPT_FLAGS	flags;
#    define	 FLOD_OPT_OFF		0x0001
#    define	 FLOD_OPT_TRACE1	0x0002
#    define	 FLOD_OPT_TRACE2	0x0004
#    define	 FLOD_OPT_ROGUE		0x0008
#     define	  IFLOD_OPT_OFF_ROGUE(o) (((o)->i_opts.flags & FLOD_OPT_OFF)  \
					  | ((o)->o_opts.flags&FLOD_OPT_ROGUE))
#     define	  OFLOD_OPT_OFF_ROGUE(o) ((o)->o_opts.flags & (FLOD_OPT_OFF \
							| FLOD_OPT_ROGUE))
#    define	 FLOD_OPT_IPv4		0x0010
#    define	 FLOD_OPT_IPv6		0x0020
#    define	 FLOD_OPT_PASSIVE	0x0040
#    define	 FLOD_OPT_SOCKS		0x0080
#    define	 FLOD_OPT_NAT		0x0100
#    define	 FLOD_OPT_DEL_OK	0x0200
#    define	 FLOD_OPT_DEL_SET	0x0400
#    define	 FLOD_OPT_NO_LOG_DEL	0x0800
    SRVR_ID_MAPS maps;
    int8_t	path_len;
} FLOD_OPTS;

typedef struct {
    FLOD_MMAP	*mp;
    DCC_SRVR_ID	rem_id, in_passwd_id, out_passwd_id;
    int		soc;			/* outgoing socket */
    int		lno;
    char	rem_hostname[DCC_MAXDOMAINLEN];
    char	rem_portname[MAXPORTNAMELEN+1];
    char	loc_hostname[DCC_MAXDOMAINLEN];
    in_port_t	rem_port;
    in_port_t	loc_port;
    DNS		o_dns;
    DNS		i_dns;
    DCC_SOCKU	rem;
    time_t	limit_reset;		/* when to reset complaint limits */
    time_t	oflod_alive;		/* when last active */
    struct {
	time_t	    saved;		/* last wrote counts to file */
	u_int	    out_reports;	/* total reports sent */
	u_int	    total;		/* total reports received */
	u_int	    accepted;		/* acceptable received reports */
    } cnts;
    struct {
	FLOD_LIMCNT stale;		/* bad timestamp */
	FLOD_LIMCNT dup;		/* already received */
	FLOD_LIMCNT wlist;		/* whitelisted */
	FLOD_LIMCNT not_deleted;	/* delete commands ignored */
	FLOD_LIMCNT bad_id;		/* unrecognized server-IDs */
	FLOD_LIMCNT complaint;		/* output complaint from peer */
	FLOD_LIMCNT iflod_bad;		/* generic bad report */
    } lc;
    DB_PTR	xmit_pos;		/* last transmitted position */
    DB_PTR	recv_pos;		/* heard this from target */
    DB_PTR	cur_pos;		/* completed to here */
    DB_PTR	rewind_pos;		/* will have rewound by here */
    int		ibuf_len;
    union {
	DCC_FLOD_RESP r;
	u_char	    b[sizeof(DCC_FLOD_RESP)*2];
    } ibuf;
    u_int	obuf_len;
    union {
	DCC_FLOD_STREAM s;
#	 define	     FLOD_BUF_SIZE 2048
	u_char	    b[FLOD_BUF_SIZE];
    } obuf;
    FLOD_OPTS	i_opts;
    FLOD_OPTS	o_opts;
    IFLOD_INFO	*ifp;
    u_int	flags;
#    define	 OFLOD_FG_CONNECTED	0x0001	/* connect() complete */
#    define	 OFLOD_FG_NEW		0x0002	/* new connection */
#    define	 OFLOD_FG_SHUTDOWN	0x0004	/* brakes applied */
#    define	 OFLOD_FG_SHUTDOWN_REQ	0x0008
#    define	 OFLOD_FG_HAVE_2PASSWD	0x0010	/* have a 2nd password */
#    define	 OFLOD_FG_I_USED_2PASSWD 0x020	/* used the 2nd password */
#    define	 OFLOD_FG_O_USED_2PASSWD 0x040
#    define	 OFLOD_FG_EAGAIN	0x0080	/* recent bogus EAGAIN */
#    define	 OFLOD_FG_LOC_MSG	0x0100
#    define	 OFLOD_FG_REP_SEND	0x0200	/* ok to send reputations */
#    define	 OFLOD_FG_REP_TRY	0x0400	/* ask for reputations */
	u_char	oversion;
} OFLOD_INFO;

typedef struct {
    int		total;			/* known peers */
    int		open;			/* active outgoing streams */
    OFLOD_INFO  infos[DCCD_MAX_FLOODS];
} OFLODS;
extern OFLODS oflods;
extern DB_PTR oflods_max_cur_pos;

extern enum FLODS_ST {
	FLODS_ST_OFF, FLODS_ST_RESTART, FLODS_ST_ON
} flods_st;

extern DCC_TGTS flod_tholds[DCC_DIM_CKS];


struct iflod_info {
    int		soc;			/* incoming socket */
    char	rem_hostname[DCC_MAXDOMAINLEN];
    DCC_SOCKU	rem;
    DCC_FLOD_POS pos, pos_sent;
    OFLOD_INFO	*ofp;
    time_t	iflod_alive;		/* when last active */
    int		ibuf_len;
    u_char	flags;
#    define	 IFLOD_FG_CONNECTED	0x01
#    define	 IFLOD_FG_CLIENT	0x02	/* outgoing connection */
#    define	 IFLOD_FG_VERS_CK	0x04
#    define	 IFLOD_FG_END_REQ	0x08
#    define	 IFLOD_FG_FAST_LINGER	0x10
    union {
	DCC_FLOD_STREAM	s;
	u_char		b[FLOD_BUF_SIZE];
    } ibuf;
};

typedef struct {
    int		open;
    IFLOD_INFO	infos[DCCD_MAX_FLOODS];
} IFLODS;
extern IFLODS iflods;

extern int flods_off;			/* # of reasons flooding is off */
#define FLODS_OK()	(!flods_off && !dbclean_running)
#define FLODS_OK_ON()	(FLODS_OK() && flods_st == FLODS_ST_ON)
extern u_int complained_many_iflods;

typedef enum {
    WFIX_DELAY,				/* waiting for window overflow */
    WFIX_BUSY,				/* measuring active load */
    WFIX_QUIET,				/* waiting for clients to flee */
    WFIX_CHECK,				/* counting clients that stayed */
} DBCLEAN_WFIX_STATE;
extern DBCLEAN_WFIX_STATE dbclean_wfix_state;

extern u_char stop_mode;		/* 0=normal  1=reboot  2=DB clean */
extern time_t next_flods_ck;
#define FLODS_CK_SECS	    5
#define RUSH_NEXT_FLODS_CK() {if (next_flods_ck > db_time.tv_sec + 1)	\
	next_flods_ck = db_time.tv_sec + 1;}
#define MISC_CK_SECS	    FLODS_CK_SECS
#define CLIENTS_SAVE_SECS   (30*60)
#define CLIENTS_QUICK_SAVE  30

/* mtime of /var/dcc/flod or 0 if we have complained about bad file */
extern time_t flod_mtime;

#define FLOD_RETRY_SECS		(5*60)	/* retry connection no sooner */
#define FLOD_SUBMAX_RETRY_SECS	(60*60)	/* retry when peer can't poke us */
#define FLOD_MAX_RETRY_SECS (24*60*60)	/* maximum backoff */
#define	FLOD_SOCKS_IRETRY	(FLODS_CK_SECS*2+1)

/* Delay starting auto-NAT until the peer has given up trying to connect.
 * That can be at least 80 seconds */
#define FLOD_AUTO_NAT_DELAY	(2*60)

#define	FLOD_IN_COMPLAIN    (24*60*60)  /* complain daily about input */
#define	FLOD_IN_COMPLAIN1   (2*60*60)	/* 1st normal input complaint */
#define	FLOD_IN_COMPLAIN_NOW	(5*60)	/* complain as soon as possible */

extern time_t iflods_ok_timer;		/* incoming flooding ok since then */
#define IFLODS_OK_SECS	    (5*60)	/* 5 minutes to catch up */

extern time_t need_clients_save;

extern time_t got_hosts;		/* resolve hostnames */
#define FLOD_NAMES_RESOLVE_SECS	(5*60)	/*	at most every 5 minutes */
extern pid_t resolve_hosts_pid;

extern const char *need_del_dbclean;
extern time_t del_dbclean_next;
#define DEL_DBCLEAN_SECS	(30*60)	/* limit dbclean if not urgent */
extern time_t dbclean_limit;
#define DBCLEAN_LIMIT_SECS	15	/* not too often for any reason */
extern time_t dbclean_limit_secs;

#define MAX_DUP_CHAIN	    1000
extern int iflod_dup_chain;		/* hitting gross duplicate chains */
extern u_char complained_missing_date;

extern DCCD_STATS dccd_stats;


extern DCC_TRACEMASK tracemask;

/* Avoid the costs of generating and passing the args to a logging functin by
 * checking bits in the caller.
 * If the server ran only on modern Unix, we could use gcc's macro varargs. */
#define TMSG_BIT(t) ((DCC_TRACE_##t##_BIT & tracemask) != 0)
#define TMSG_BLOCK(t,args) do {if TMSG_BIT(t) dcc_trace_msg args;} while (0)
#define TMSG(t,p)	TMSG_BLOCK(t,("%s", p))
#define TMSG1(t,p,arg)	TMSG_BLOCK(t,(p,arg))
#define TMSG2(t,p,a1,a2) TMSG_BLOCK(t,(p,a1,a2))
#define TMSG3(t,p,a1,a2,a3) TMSG_BLOCK(t,(p,a1,a2,a3))
#define TMSG4(t,p,a1,a2,a3,a4) TMSG_BLOCK(t,(p,a1,a2,a3,a4))
#define TMSG5(t,p,a1,a2,a3,a4,a5) TMSG_BLOCK(t,(p,a1,a2,a3,a4,a5))

#define TMSG_OP(t,q) do {if (TMSG_BIT(t) && !(q->flags & Q_FG_TRACED))	\
			     log_op(q);} while (0);


/* these can only be used when we know the flooding peer */
#define TMSG_FB1(ofp) ((DCC_TRACE_FLOD1_BIT & tracemask) != 0		\
		      || ((ofp && (ofp->o_opts.flags & FLOD_OPT_TRACE1))))
#define TMSG_F1sub(ofp,args) do {if (TMSG_FB1(ofp)) dcc_trace_msg args;} while(0)
#define TMSG_FLOD1(ofp,p) TMSG_F1sub(ofp,("%s", p))
#define TMSG1_FLOD1(ofp,p,arg) TMSG_F1sub(ofp,(p,arg))
#define TMSG2_FLOD1(ofp,p,a1,a2) TMSG_F1sub(ofp,(p,a1,a2))
#define TMSG3_FLOD1(ofp,p,a1,a2,a3) TMSG_F1sub(ofp,(p,a1,a2,a3))
#define TMSG4_FLOD1(ofp,p,a1,a2,a3,a4) TMSG_F1sub(ofp,(p,a1,a2,a3,a4))
#define TMSG5_FLOD1(ofp,p,a1,a2,a3,a4,a5) TMSG_F1sub(ofp,(p,a1,a2,a3,a4,a5))

#define TMSG_FB2(ofp) ((DCC_TRACE_FLOD2_BIT & tracemask) != 0		\
		       || ((ofp && (ofp->o_opts.flags & FLOD_OPT_TRACE2))))
#define TMSG_F2sub(ofp,args) do {if (TMSG_FB2(ofp))dcc_trace_msg args;} while(0)
#define TMSG_FLOD2(ofp,p) TMSG_F2sub(ofp,(p))
#define TMSG1_FLOD2(ofp,p,arg) TMSG_F2sub(ofp,(p,arg))
#define TMSG2_FLOD2(ofp,p,a1,a2) TMSG_F2sub(ofp,(p,a1,a2))
#define TMSG3_FLOD2(ofp,p,a1,a2,a3) TMSG_F2sub(ofp,(p,a1,a2,a3))
#define TMSG4_FLOD2(ofp,p,a1,a2,a3,a4) TMSG_F2sub(ofp,(p,a1,a2,a3,a4))
#define TMSG5_FLOD2(ofp,p,a1,a2,a3,a4,a5) TMSG_F2sub(ofp,(p,a1,a2,a3,a4,a5))

#define Q_CIP(q) dcc_su2str_err(&(q)->clnt_su)


#define _db_ptr2flod_pos(bp, pos) {					\
	(bp)[7] = pos;     (bp)[6] = pos>>8;				\
	(bp)[5] = pos>>16; (bp)[4] = pos>>24;				\
	(bp)[3] = pos>>32; (bp)[2] = pos>>40;				\
	(bp)[1] = pos>>48; (bp)[0] = pos>>56; }
#ifdef HAVE_GCC_INLINE
static inline void
db_ptr2flod_pos(DCC_FLOD_POS bp, DB_PTR pos) _db_ptr2flod_pos(bp, pos)
#else
extern void db_ptr2flod_pos(DCC_FLOD_POS bp, DB_PTR pos);
#endif


#define _flod_pos2db_ptr(pos) (						\
	(DB_PTR)pos[7]	     + (((DB_PTR)pos[6])<<8)			\
    + (((DB_PTR)pos[5])<<16) + (((DB_PTR)pos[4])<<24)			\
    + (((DB_PTR)pos[3])<<32) + (((DB_PTR)pos[2])<<40)			\
    + (((DB_PTR)pos[1])<<48) + (((DB_PTR)pos[0])<<56))
#ifdef HAVE_GCC_INLINE
static inline DB_PTR
flod_pos2db_ptr(const DCC_FLOD_POS pos) { return _flod_pos2db_ptr(pos); }
#else
extern DB_PTR flod_pos2db_ptr(const DCC_FLOD_POS pos);
#endif


/* It is lame to not report EINVAL, but several UNIX-like
 * systems return EINVAL for the second connect() after a
 * Unreachable ICMP message or after a timeout. */
#define CONN_EMSG() (errno != EINVAL ? ERROR_STR() :			\
		     "EINVAL--likely connection refused, timed out, or firewall")

/* dccd.c */
extern void free_q(QUEUE *);
extern void after_fork(void);
extern void set_dbclean_timer(void);
extern void bad_stop(const char *, ...) DCC_PF(1,2);

/* iflod.c */
extern ID_MAP_RESULT id_map(DCC_SRVR_ID, const SRVR_ID_MAPS *);
extern const char * ifp_rem_str(const IFLOD_INFO *);
#define CK_FLOD_CNTERR(lc) (++(lc)->cur <= (lc)->lim + FLOD_LIM_COMPLAINTS  \
			    || db_debug >= 2)
extern void flod_cnterr(const FLOD_LIMCNT *, const char *, ...) DCC_PF(2,3);
extern const char * ofp_rem_str(const OFLOD_INFO *);
extern void ferr(OFLOD_INFO *, u_char, FERR_TYPE, u_char,
		 const char *, ...) DCC_PF(5,6);
extern void ferr_clear(OFLOD_INFO *, u_char, FERR_TYPE);
extern void ferr_clear_all(OFLOD_INFO *, u_char);
extern u_char set_flod_socket(OFLOD_INFO *, u_char, int,
			      const char *, const DCC_SOCKU *);
extern void bind_flod_socket(OFLOD_INFO *, int, const DCC_SOCKU *, const DNS *);
extern u_char flod_names_resolve_ck(void);
extern u_char flod_names_resolve_start(const OFLOD_INFO *);
extern void iflod_listen_close(SRVR_SOC *);
extern void iflods_stop(const char *, u_char);
extern void iflod_start(SRVR_SOC *);
extern void iflods_listen(void);
extern void iflod_socks_start(OFLOD_INFO *);
extern u_char dccd_db_open(u_char);
extern void iflod_close(IFLOD_INFO *, u_char, u_char, u_char,
			const char *, ...) DCC_PF(5,6);
extern u_char iflod_read(IFLOD_INFO *);
extern int iflod_send_pos(IFLOD_INFO *, u_char);
extern int flods_list(char *, int, u_char);
extern int flod_stats(char *, int, u_int32_t, u_char);

/* oflod.c */
extern void oflods_clear(void);
extern void oflod_open(OFLOD_INFO *);
extern u_char load_flod(u_char, u_char);
extern void save_flod_cnts(OFLOD_INFO *);
extern void oflod_close(OFLOD_INFO *, int);
extern int oflod_parse_eof(OFLOD_INFO *, u_char, const DCC_FLOD_END *, int);
extern void oflod_read(OFLOD_INFO *);
extern void oflod_write(OFLOD_INFO *);
extern void flods_stop(const char *, u_char);
extern const char *version_str(OFLOD_INFO *);
extern void flod_try_again(OFLOD_INFO *, u_char);
extern const char *flod_sign(OFLOD_INFO *, u_char, void *, int);
extern u_char oflod_connect_fin(OFLOD_INFO *);
extern void flods_restart(const char *, u_char);
extern int check_load_ids(u_char);
extern void flods_ck(u_char);
extern void flods_init(void);

/* rl.c */
extern void rl_init(void);
extern void rl_inc2(RL *, const RL_RATE *, RL *);
extern void clients_save(void);
extern RL *rl_get(RL **, u_char, DCC_CLNT_ID, const struct in6_addr *,
		  RL_DATA_FG);
extern void clients_get_id(DCC_ADMN_RESP_VAL *, int *, u_int, u_int, u_char,
			   const DCC_IP_RANGE *, DCC_CLNT_ID);
extern int clients_get(DCC_ADMN_RESP_VAL *, int *, u_int, u_int, u_char,
		       const DCC_IP_RANGE *, DCC_CLNT_ID);
extern void clients_clear(void);
extern u_char ck_sign(const ID_TBL **, DCC_PASSWD, DCC_CLNT_ID,
		      const void *, u_int);
extern u_char ck_clnt_id(QUEUE *, DCC_CLNT_ID, u_char);
extern u_char ck_clnt_srvr_id(QUEUE *, DCC_CLNT_ID, u_char);
extern const char *qop2str(const QUEUE *);
extern void check_blacklist_file(void);

extern const char *from_id_ip(const QUEUE *, u_char);
extern const char *op_id_ip(QUEUE *);
extern void log_op(QUEUE *);
extern void vanon_msg(const char *, va_list);
extern void anon_msg(const char *, ...) DCC_PF(1,2);
extern void vclnt_msg(const QUEUE *, const char *, va_list);
extern void clnt_msg(const QUEUE *, const char *, ...) DCC_PF(2,3);
extern void junk_msg(QUEUE *, u_char, const char *, ...) DCC_PF(3,4);

/* work.c */
extern void new_ts(DCC_TS *);
extern int find_srvr_rcd_type(DCC_SRVR_ID, DB_ST *);
extern ID_TBL *find_srvr_type(DCC_SRVR_ID);
extern void refresh_srvr_rcd(const DCC_SUM *, DCC_SRVR_ID, time_t, time_t,
			     const char *);
extern void date_rcd_ck(DCC_SUM *, time_t);
extern int find_date_rcd(time_t, DB_ST *);
extern void stats_clear(void);
extern u_char summarize_dly(DB_ST *);
extern u_char add_dly_rcd(DB_RCD *, u_char, DB_ST *);
extern void do_work(QUEUE *);
extern void do_grey(QUEUE *, DCC_CLNT_ID);
extern void do_grey_spam(QUEUE *, DCC_CLNT_ID);
extern void do_nop(QUEUE *, DCC_CLNT_ID);
extern void do_admn(QUEUE *, DCC_CLNT_ID);
extern void do_delete(QUEUE *, DCC_CLNT_ID);


#endif /* DCCD_DEFS_H */
