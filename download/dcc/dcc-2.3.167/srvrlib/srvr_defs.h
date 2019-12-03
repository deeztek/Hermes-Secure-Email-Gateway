/* Distributed Checksum Clearinghouse
 *
 * common server definitions
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
 * Rhyolite Software DCC 2.3.167-1.105 $Revision$
 */

#ifndef SRVR_DEFS_H
#define SRVR_DEFS_H

#include "dcc_clnt.h"
#include "dcc_ids.h"
#include "dcc_heap_debug.h"
#include "db.h"

typedef struct {
    DCC_SCNTR	nops;			/* DCC_OP_NOP packets */
    DCC_SCNTR	reports;		/* DCC_OP_REPORT or DCC_OP_REPORT_REP */
    DCC_SCNTR	report_retrans;		/* duplicate reports */
    DCC_SCNTR	report_reject;		/* reports ignored by -Q */
    DCC_SCNTR	report10;		/* reports of >10 targets */
    DCC_SCNTR	report100;		/* reports of >100 targets */
    DCC_SCNTR	report1000;		/* reports of >1000 targets */
    DCC_SCNTR	reportmany;		/* reports of spam */
    DCC_SCNTR	queries;		/* DCC_OP_QUERY */
    DCC_SCNTR	resp10;			/* responses of >10 targets */
    DCC_SCNTR	resp100;		/*   "       " >100 targets */
    DCC_SCNTR	resp1000;		/*   "       " >1000 targets */
    DCC_SCNTR	respmany;		/*   "       " spam */
    DCC_SCNTR	respwhite;		/* whitelisted responses */
    DCC_SCNTR	bad_op;			/* unknown, blacklisted, over active */
    DCC_SCNTR	bad_passwd;		/* requests with bad passwords */
    DCC_SCNTR	blist;			/* blacklisted requests */
    DCC_SCNTR	send_error;		/* error responses sent */
    DCC_SCNTR	admin;			/* DCC_OP_ADMN */
    DCC_SCNTR	rl;			/* responses rate-limited */
    DCC_SCNTR	anon_rl;		/* anonymous responses rate-limited */
    DCC_SCNTR	adds;			/* reports added */
    DCC_SCNTR	iflod_total;		/* total reports received */
    DCC_SCNTR	iflod_accepted;		/* timely and properly signed */
    DCC_SCNTR	iflod_stale;
    DCC_SCNTR	iflod_dup;
    DCC_SCNTR	iflod_wlist;		/* locally whitelisted */
    DCC_SCNTR	iflod_not_deleted;	/* delete commands ignored */
    DCC_SCNTR	norep;
    DCC_SCNTR	rep1;
    DCC_SCNTR	rep10;
    DCC_SCNTR	rep20;
    DCC_SCNTR	rep30;
    DCC_SCNTR	rep60;
    DCC_SCNTR	report_reps;		/* DCC_OP_REPORT_REP packets */
    DCC_PTIME	reset;
} DCCD_STATS;


typedef enum {
    FERR_NONE,
    FERR_SOCK,				/* setting up socket */
    FERR_CLOSE,				/* closing socket */
    FERR_STOP,
    FERR_START,
    FERR_DNS,
    FERR_CONNECT,
    FERR_DUP,
    FERR_IO
} FERR_TYPE;
typedef char FERR_MSG[DCC_FLOD_MAX_RESP];
typedef struct {
    int		error_gen;
    int		trace_gen;
    FERR_TYPE	error_type:8;
    FERR_TYPE	trace_type:8;
    FERR_MSG	error_msg;
    FERR_MSG	trace_msg;
} LAST_FERR;


/* memory mapped file of flooding information
 *  it is memory mapped so that dblist can report the state of flooding
 *  and so dbclean can see when flooding has stopped */

#define GREY_FLOD_NM	"grey_flod"
#define DCCD_FLOD_NM	"flod"
extern DCC_PATH flod_mmap_path, flod_path;

#ifndef DCCD_MAX_FLOODS
#define DCCD_MAX_FLOODS	32
#endif

/* map server-IDs */
typedef enum {
    ID_MAP_NO,				/* do not translate this server-ID */
    ID_MAP_REJ,				/* reject reports to or from this ID */
    ID_MAP_SELF,			/* translate this ID to our ID */
} ID_MAP_RESULT;
typedef struct {
    DCC_SRVR_ID lo;
    DCC_SRVR_ID hi;
    u_char	result;			/* ID_MAP_RESULT */
} SRVR_ID_MAP;
typedef struct {
    SRVR_ID_MAP	entry[10];
    u_char	len;
} SRVR_ID_MAPS;


typedef struct {
    /* timer and backoff for ordinary connect() */
    DCC_PTIME	retry;
    int32_t	retry_secs;
    /* timer for complaints about missing incoming connection */
    DCC_PTIME	msg;
    int32_t	msg_secs;
} CONN_TIMERS;
typedef u_int32_t FLOD_MMAP_FLAGS;
typedef struct {
    u_int32_t	num;
    u_int32_t	cur;
    DCC_SOCKU	su[DCC_MAX_HOSTADDRS];
    int32_t	rem_h_errno;
    DCC_SOCKU	loc_v4;
    DCC_SOCKU	loc_v6;
    int32_t	loc_h_errno;
} DNS;
typedef struct {
    char	rem_hostname[DCC_MAXDOMAINLEN];
    char	rem_portname[MAXPORTNAMELEN+1];
    char	loc_hostname[DCC_MAXDOMAINLEN];	/* bind to this */
    in_port_t	loc_port;
    DNS		dns;			/* IP addresses */
    DB_PTR	confirm_pos;		/* confirmed sent to here */
    DCC_SRVR_ID	rem_id, in_passwd_id, out_passwd_id;
    CONN_TIMERS	otimers, itimers;
    DCC_PTIME	reps_rejected;		/* when reputations last rejected */
    SRVR_ID_MAPS i_id_maps, o_id_maps;
    FLOD_MMAP_FLAGS flags;
#    define	 FLODMAP_FG_MARK	0x00000001
#    define	 FLODMAP_FG_IN_OFF	0x00000002
#    define	 FLODMAP_FG_OUT_OFF	0x00000004
#    define	 FLODMAP_FG_ROGUE	0x00000008  /* evil server */
#    define	 FLODMAP_FG_IN_CONN	0x00000010  /* input connected */
#    define	 FLODMAP_FG_OUT_CONN	0x00000020  /* output connected */
#    define	 FLODMAP_FG_IPv4	0x00000100  /* override IPv6 choice */
#    define	 FLODMAP_FG_IPv6	0x00000200  /* override IPv6 choice */
#    define	 FLODMAP_FG_PASSIVE	0x00000400  /* peer uses SOCKS */
#    define	 FLODMAP_FG_SOCKS	0x00000800
#    define	 FLODMAP_FG_NAT		0x00001000  /* SOCKS without library */
#    define	 FLODMAP_FG_NAT_AUTO	0x00002000  /* assumed NAT */
#     define	  FLODMAP_FG_ACT (FLODMAP_FG_SOCKS | FLODMAP_FG_NAT	\
				  | FLODMAP_FG_NAT_AUTO)
#    define	 FLODMAP_FG_OUT_SRVR	0x00004000  /* connected by peer */
#    define	 FLODMAP_FG_IN_SRVR	0x00008000  /* connected by peer */
#    define	 FLODMAP_FG_REWINDING	0x00010000  /* answering rewind */
#    define	 FLODMAP_FG_NEED_RWD	0x00020000  /* database purged */
#    define	 FLODMAP_FG_FFWD_IN	0x00040000  /* want fastforward */
#    define	 FLODMAP_FG_USE_2PASSWD	0x00080000
#    define	 FLODMAP_FG_LEAF	0x00100000  /* path length restricted */
/* #    define	 FLODMAP_FG_obsolete	0x00200000 */
#    define	 FLODMAP_FG_REP_PEER_ON	0x00400000  /* turned on by peer */
#    define	 FLODMAP_FG_REP_PEER_REJ 0x0800000  /* rejected by peer */
    u_char	iversion;		/* incoming flood protocol */
    struct {
	DCC_SCNTR   out_reports;	/* total reports sent */
	DCC_SCNTR   total;		/*		received */
	DCC_SCNTR   accepted;
	DCC_SCNTR   stale;		/* too old or in the future */
	DCC_SCNTR   dup;		/* already received */
	DCC_SCNTR   wlist;		/* whitelisted */
	DCC_SCNTR   not_deleted;	/* delete commands ignored */
	DCC_PTIME   cnts_cleared;
	DCC_PTIME   in_conn_changed;
	DCC_PTIME   out_conn_changed;
	u_int32_t   out_total_conn;	/* seconds connected */
	u_int32_t   in_total_conn;
	u_int32_t   pad;		/* preserve %8 length */
    } cnts;
    LAST_FERR	    oflod_err;
    LAST_FERR	    iflod_err;
} FLOD_MMAP;

typedef struct {
    char	magic[32];
#    define	 FLOD_MMAP_MAGIC	"DCC flod map version 26"
    char	pad[32-sizeof(DB_PTR)];
    DB_PTR	delay_pos;		/* delay flooding newer than this */
    DB_SN	sn;			/* ensure match with database */
    time_t	ids_mtime;		/* ids file mtime when we checked */
    FLOD_MMAP	mmaps[DCCD_MAX_FLOODS];
    DCCD_STATS	dccd_stats;
} FLOD_MMAPS;
extern FLOD_MMAPS *flod_mmaps;


#define _secs2ts(ts,secs) {						\
	u_int64_t ticks = (((u_int64_t)(secs) - DCC_TS_EPOCH)		\
			   << DCC_TS_SEC_SHIFT);			\
	(ts)->b[0] = ticks>>40; (ts)->b[1] = ticks>>32;			\
	(ts)->b[2] = ticks>>24; (ts)->b[3] = ticks>>16;			\
	(ts)->b[4] = ticks>>8; (ts)->b[5] = ticks; }
#ifdef HAVE_GCC_INLINE			/* no prototypes without inline */
static inline void
secs2ts(DCC_TS *ts, time_t secs) _secs2ts(ts, secs)
#else
#define secs2ts(ts, secs) _secs2ts(ts, secs)
#endif

#define _timeval2ts(ts, tv, delta_secs) {				\
	u_int64_t ticks = ((u_int64_t)(tv)->tv_sec - DCC_TS_EPOCH	\
			   +(delta_secs)) << DCC_TS_SEC_SHIFT;		\
	ticks += (tv)->tv_usec >> DCC_TS_USEC_SHIFT;			\
	(ts)->b[0] = ticks>>40; (ts)->b[1] = ticks>>32;			\
	(ts)->b[2] = ticks>>24; (ts)->b[3] = ticks>>16;			\
	(ts)->b[4] = ticks>>8; (ts)->b[5] = ticks; }
#ifdef HAVE_GCC_INLINE			/* no prototypes without inline */
static inline void
timeval2ts(DCC_TS *ts, const struct timeval *tv, int delta_secs)
_timeval2ts(ts, tv, delta_secs)
#else
#define timeval2ts(ts, tv, delta_secs) _timeval2ts(ts, tv, delta_secs)
#endif

#define _ts2ticks(ts) ((((u_int64_t)(ts)->b[0])<<40)			\
		       + (((u_int64_t)(ts)->b[1])<<32)			\
		       + (((u_int64_t)(ts)->b[2])<<24)			\
		       + (((u_int64_t)(ts)->b[3])<<16)			\
		       + (((u_int64_t)(ts)->b[4])<<8)			\
		       + (ts)->b[5] + DCC_TS_EPOCH)

#define _ts2secs(ts) ((time_t)(_ts2ticks(ts) >> DCC_TS_SEC_SHIFT))
#ifdef HAVE_GCC_INLINE			/* no prototypes without inline */
static inline time_t
ts2secs(const DCC_TS *ts) {return _ts2secs(ts);}
#else
#define ts2secs(ts) _ts2secs(ts)
#endif

#define _ts2timeval(tv, ts) {						\
	u_int64_t ticks = _ts2ticks(ts);				\
	(tv)->tv_sec = ticks >> DCC_TS_SEC_SHIFT;			\
	(tv)->tv_usec = ((ticks &  DCC_TS_USEC_MASK) << DCC_TS_USEC_SHIFT); }
#ifdef HAVE_GCC_INLINE			/* no prototypes without inline */
static inline void
ts2timeval(struct timeval *tv, const DCC_TS *ts) _ts2timeval(tv, ts)
#else
#define ts2timeval(tv, ts) _ts2timeval(tv, ts)
#endif

#ifdef HAVE_GCC_INLINE			/* no prototypes without inline */
static inline int
tscmp(const DCC_TS *ts1, const DCC_TS *ts2)
{ return memcmp(ts1, ts2, sizeof(DCC_TS)); }
#else
#define tscmp(ts1, ts2) memcmp(ts1, ts2, sizeof(DCC_TS))
#endif

#define ts_newer_ts(ts1, ts2) (tscmp(ts1, ts2) > 0)
#define ts_older_ts(ts1, ts2) (tscmp(ts1, ts2) < 0)


#define DB_TYPE2STR(t) type2str_err(t,0,1,grey_on)

/* not thread safe */
extern DCC_PATH db_path_buf;
#define DB_NM2PATH_ERR(nm) dcc_fnm2abs_msg(&db_path_buf, nm)


extern void flod_mmap_path_set(void);
extern u_char flod_mmap_sync(DCC_EMSG *, u_char);
extern u_char flod_unmap(DCC_EMSG *, const DCCD_STATS *);
extern u_char flod_mmap(DCC_EMSG *, const DB_SN *, const DCCD_STATS *, u_char);
extern const char *flod_stats_printf(char *, int, int, int, int, int);
extern const char *socks_type_str(const FLOD_MMAP *);
extern const char *flodmap_fg(char *, int, const FLOD_MMAP *);
extern int flod_running(const char *);

extern int read_db(DCC_EMSG *, void *, u_int, int, off_t, const char *);
extern u_char read_db_hdr(DCC_EMSG *, DB_HDR *, int fd, const char *);
extern void read_rcd_invalidate(u_int);
extern int read_rcd(DCC_EMSG *, DB_RCD *, int, off_t, const char *);

extern char *tv2str(char *, u_int, const struct timeval *, u_char);
extern char *ts2str(char *, u_int, const DCC_TS *);
extern const char *ptime2str_err(DCC_PTIME);
extern const char *ts2str_err(const DCC_TS *);

extern char *dcc_srvr_id2str(char *, u_int, DCC_SRVR_ID);

extern u_char have_boottime;
extern u_char get_boottime(struct timeval *, DCC_EMSG *);

extern u_char istmpfs(int, const char *);


#endif /* SRVR_DEFS_H */
