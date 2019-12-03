/* Distributed Checksum Clearinghouse
 *
 * internal client definitions
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
 * Rhyolite Software DCC 2.3.167-1.148 $Revision$
 */

#ifndef DCC_CLNT_H
#define DCC_CLNT_H

#include "dcc_defs.h"


#define	DCC_DCCD_DELAY	    (100*1000)	/* typical server delay */

/* The minimum assumed RTT should be long enough for the DCC server to do
 * some disk operations even if the server and network have usually
 * been faster. */
#define DCC_MIN_RTT	    (DCC_DCCD_DELAY + 150*1000)

#define DCC_MAX_XMITS	    4

/* worst client-->server-->client RTT
 * The total delay for N exponentially increasing delays starting with  X
 * is about X*(2**N).  With the delay limited to Y, it is Y*N.
 * The RTT measuring done with NOPs uses retransmission delays based on
 * DCC_MIN_RTT, and so will not find a server with a worse delay than
 * DCC_MAX_RTT */
#define DCC_MAX_RTT	    (DCC_MIN_RTT<<DCC_MAX_XMITS)
#define DCC_MAX_RTT_SECS    (DCC_MAX_RTT/DCC_US)

#define DCC_RTT_ADJ_MAX	    (DCC_MAX_RTT/2) /* limit manual RTT bias */
#define DCC_RTT_VERS_ADJ    (DCC_RTT_ADJ_MAX/3) /* penalize strange versions */
#define	DCC_RTT_BAD	    (DCC_MAX_RTT*2+1)

/* If DCC_MAX_XMITS and the retransmission delay limited to DCC_MAX_RTT_SECS,
 * the the worst case delay is DCC_MAX_XMITS*DCC_MAX_RTT_SECS=16 seconds */
#define DCC_MAX_DELAY	    (DCC_MAX_XMITS*DCC_MAX_RTT)
#define DCC_MAX_DELAY_SECS  (DCC_MAX_DELAY/DCC_US)


/* No client's retransmission can be delayed by more than this starting
 * from the initial intransmission and including network delays for the
 * last retransmission
 * This controls how long a DCC server must remember old requests
 * to recognize retransmissions.  */
#define DCC_MAX_RETRANS_DELAY_SECS  (DCC_MAX_DELAY_SECS*2)


#define	DCC_MAP_RESOLVE	    (2*60*60)	/* DNS re-resolve server host names */
#define	DCC_RESOLVE_RETRY   (5*60)	/* try again after failure */
#define	DCC_WHITECLNT_RESOLVE (2*60*60)	/* DNS re-resolve whitelist hosts */

#define DCC_MAX_SRVR_NMS    8		/* server hostnames */
#define DCC_MAX_SRVR_ADDRS  12		/* server IP addresses */

extern u_char dcc_clnt_debug;
extern u_char spamassassin_body_kludge;
extern int dcc_debug_ttl;

extern char dcc_clnt_hostname[MAXHOSTNAMELEN];

/* information kept by a client about a server */
typedef struct {
    int32_t	rtt_adj;
    DCC_CLNT_ID	clnt_id;		/* our client-ID sent to the server */
    in_port_t	port;			/* network byte order port # */
    u_char	defined;		/* name resolves into an IP address */
    char	hostname[DCC_MAXDOMAINLEN]; /* null terminated */
    DCC_PASSWD	passwd;			/* null filled but not terminated */
    u_char	pad;			/* preserve size%4 */
} DCC_SRVR_NM;
/* the port number must be installed in this before use */
#define DCC_SRVR_NM_DEF(p) {0, DCC_ID_ANON, (p), 0, {DCC_LOCALHOST}, {""}, 0}

typedef u_int32_t RESP_MEM;
typedef u_int16_t NAM_INX;
typedef struct {			/* a single server address */
    DCC_PTIME	rtt_updated;		/* when RTT last updated */
    DCC_IP	ip;
    int32_t	rtt;			/* round trip time in microseconds */
    int32_t	srvr_wait;		/* microseconds server penalizes us */
    RESP_MEM	resp_mem;		/* 1 bit per recent xmit */
#    define	 DCC_TOTAL_XMITS_MAX (sizeof(RESP_MEM)*8)
    NAM_INX	nam_inx;		/* DCC_NO_NM or DCC_SRVR_NM.nms index */
#    define	 NO_NAM		((NAM_INX)(-1))
#    define	 VALID_NAM(inx)	((inx) < DCC_MAX_SRVR_NMS)
    DCC_SRVR_ID	srvr_id;		/* the server's claimed ID */
    u_char	total_xmits;
    u_char	total_resps;
    u_char	srvr_pkt_vers;
    u_char	flags;
#    define	 DCC_SRVR_ADDR_MHOME 0x01   /* do not use connect */
    DCC_BRAND	brand;			/* the server's announced brand name */
} DCC_SRVR_ADDR;

typedef u_char SRVR_INX;
typedef struct {
    DCC_PTIME	resolve;		/* when names need to be resolved */
    DCC_PTIME	measure;		/* when RTT measurements need */
    DCC_PTIME	fail_time;		/* DCC broken until then */
    int32_t	gen;
    int32_t	base_rtt;		/* RTT to the chosen server */
    int32_t	thold_rtt;		/* threshold for switching */
    int32_t	avg_thold_rtt;		/* long term threshold */
    int32_t	num_srvrs;		/* addresses in .addrs */
    u_char	fail_exp;		/* backoff */
#    define	 DCC_INIT_FAIL_SECS  DCC_MAX_DELAY_SECS
#    define	 DCC_MAX_FAIL_EXP    5
#    define	 DCC_MAX_FAIL_SECS   (DCC_INIT_FAIL_SECS<<DCC_MAX_FAIL_EXP)
    SRVR_INX	srvr_inx;		/* NO_SRVR or index in .addrs */
#    define	 NO_SRVR	    ((SRVR_INX)(-1))
#    define	 VALID_SRVR(c,s)    ((s) < (c)->num_srvrs)
#    define	 HAVE_CLASS_SRVR(c) VALID_SRVR((c),(c)->srvr_inx)
    u_char	pad[2];			/* preserve size%4 */
    DCC_SRVR_NM	nms[DCC_MAX_SRVR_NMS];
    DCC_SRVR_ADDR addrs[DCC_MAX_SRVR_ADDRS];
} DCC_SRVR_CLASS;

/* Information about DCC servers shared among clients on a host
 *	This is the shape of the mmap()'ed file. */
typedef u_char DCC_INFO_FGS;
typedef struct {
    DCC_IP	ip;
    DCC_PTIME	failed;			/* bind() failed */
} DCC_CLNT_SRC;
#    define	 DCC_CTXT_REBIND_SECS 3600  /* check local interface hourly */
typedef struct {
#    define	 DCC_MAP_INFO_VERSION "DCC client mapped data version #15"
    char	version[40];
    DCC_PTIME	dccproc_last;
    DCC_PTIME	dccproc_dccifd_try;
    int32_t	dccproc_c;
#    define	 DCCPROC_TRY_DCCIFD    (60*60)	/* start dccifd once/hour */
#    define	 DCCPROC_MAX_CREDITS	500	/* at least 500 */
#    define	 DCCPROC_COST		 10	/*  and at least 0.1/second */
    u_int32_t	residue;		/* random # for picking addresses */
    DCC_HDR     proto_hdr;		/* prototype DCC request header */
    DCC_SRVR_CLASS dcc;			/* normal DCC services */
    DCC_SRVR_CLASS grey;		/* grey listing */
    DCC_CLNT_SRC src4, src6;		/* send from this local address */
    DCC_INFO_FGS fgs;
#    define	 DCC_INFO_FG_IPV4_OFF   0x01
#    define	 DCC_INFO_FG_IPV6_OFF   0x02
#    define	 DCC_INFO_FG_SOCKS	0x04
#    define	 DCC_INFO_FG_TMP	0x08    /* unnamed temporary file */
    u_char	pad[3];			/* preserve size%4 */
} DCC_CLNT_INFO;


typedef struct {
    union {
	struct in_addr ipv4;
	struct in6_addr ipv6;
    } u;
    DCC_SCOPE_ID scope_id;
    in_port_t	port;
    sa_family_t	family;
} DCC_V14_IP;
typedef struct {
    DCC_PTIME	rtt_updated;
    DCC_V14_IP	ip;
    int32_t	rtt;
    int32_t	srvr_wait;
    RESP_MEM	resp_mem;
    NAM_INX	nam_inx;
    DCC_SRVR_ID	srvr_id;
    u_char	total_xmits;
    u_char	total_resps;
    u_char	srvr_pkt_vers;
    u_char	flags;
    DCC_BRAND	brand;
} DCC_V14_SRVR_ADDR;
typedef struct {
    DCC_PTIME	resolve;
    DCC_PTIME	measure;
    DCC_PTIME	fail_time;
    int32_t	gen;
    int32_t	base_rtt;
    int32_t	thold_rtt;
    int32_t	avg_thold_rtt;
    int32_t	num_srvrs;
    u_char	fail_exp;
    SRVR_INX	srvr_inx;
    DCC_SRVR_NM	nms[DCC_MAX_SRVR_NMS];
    DCC_V14_SRVR_ADDR addrs[DCC_MAX_SRVR_ADDRS];
} DCC_V14_SRVR_CLASS;
typedef struct {
    DCC_V14_IP	ip;
    time_t	failed;
} DCC_V14_CLNT_SRC;
typedef struct {
#    define	 DCC_MAP_INFO_VERSION_14 "DCC client mapped data version #14"
    char	version[40];
    DCC_PTIME	dccproc_last;
    DCC_PTIME	dccproc_dccifd_try;
    int32_t	dccproc_c;
    u_int32_t	residue;
    DCC_INFO_FGS fgs;
    DCC_HDR     proto_hdr;
    DCC_V14_SRVR_CLASS dcc;
    DCC_V14_SRVR_CLASS grey;
    DCC_V14_CLNT_SRC src4, src6;
} DCC_V14_CLNT_INFO;


typedef struct {
#    define	 DCC_MAP_INFO_VERSION_13 "DCC client mapped data version #13"
    char	version[40];
    DCC_PTIME	dccproc_last;
    DCC_PTIME	dccproc_dccifd_try;
    int32_t	dccproc_c;
    u_int32_t	residue;
    DCC_INFO_FGS fgs;
    DCC_HDR     proto_hdr;
    DCC_V14_SRVR_CLASS dcc;
    DCC_V14_SRVR_CLASS grey;
    DCC_V14_IP	src;
} DCC_V13_CLNT_INFO;


#define	DCC_MAP_INFO_VERSION_12 "DCC client mapped data version #12"
#ifdef DCC_MAP_INFO_VERSION_12
typedef struct {
    int		rtt_adj;
    DCC_CLNT_ID	clnt_id;
    in_port_t	port;
    u_char	defined;
    char	hostname[DCC_MAXDOMAINLEN];
    u_char	pad;
    DCC_PASSWD	passwd;
} DCC_V12_SRVR_NM;

typedef struct {
    DCC_V14_IP	ip;
    time_t	rtt_updated;
    int		rtt;
    int		srvr_wait;
    RESP_MEM	resp_mem;
    NAM_INX	nam_inx;
    DCC_SRVR_ID	srvr_id;
    u_char	total_xmits;
    u_char	total_resps;
    u_char	srvr_pkt_vers;
    u_char	flags;
    DCC_BRAND	brand;
} DCC_V12_SRVR_ADDR;

typedef struct {
    time_t	resolve;
    time_t	measure;
    int		gen;
    int		base_rtt;
    int		thold_rtt;
    int		avg_thold_rtt;
    int		num_srvrs;
    time_t	fail_time;
    u_char	fail_exp;
    SRVR_INX	srvr_inx;
    DCC_V12_SRVR_NM nms[DCC_MAX_SRVR_NMS];
    DCC_V12_SRVR_ADDR addrs[DCC_MAX_SRVR_ADDRS];
} DCC_V12_SRVR_CLASS;

typedef struct {
    char	version[36];
    u_int	residue;
    DCC_INFO_FGS fgs;
    DCC_HDR     proto_hdr;
    DCC_V12_SRVR_CLASS dcc;
    DCC_V12_SRVR_CLASS grey;
    DCC_V14_IP	src;
    time_t	dccproc_last;
    time_t	dccproc_dccifd_try;
    int		dccproc_c;
} DCC_V12_CLNT_INFO;
#endif /* DCC_MAP_INFO_VERSION_12 */


#define	DCC_MAP_INFO_VERSION_11 "DCC client mapped data version #11"
#ifdef DCC_MAP_INFO_VERSION_11
typedef struct {
    union {
	struct in_addr v4;
	struct in6_addr v6;
    } u;
    in_port_t	port;
    u_char	family;
} DCC_V11_IP;

typedef struct {
    DCC_V11_IP	ip;
    time_t	rtt_updated;
    int		rtt;
    int		srvr_wait;
    u_int32_t	resp_mem;
    NAM_INX	nam_inx;
    DCC_SRVR_ID	srvr_id;
    u_char	total_xmits;
    u_char	total_resps;
    u_char	srvr_pkt_vers;
    u_char	flags;
    DCC_BRAND	brand;
} DCC_V11_SRVR_ADDR;

typedef struct {
    time_t	resolve;
    time_t	measure;
    int		gen;
    int		base_rtt;
    int		thold_rtt;
    int		avg_thold_rtt;
    int		num_srvrs;
    time_t	fail_time;
    u_char	fail_exp;
    SRVR_INX	srvr_inx;
    DCC_V12_SRVR_NM	nms[DCC_MAX_SRVR_NMS];
    DCC_V11_SRVR_ADDR addrs[DCC_MAX_SRVR_ADDRS];
} DCC_V11_SRVR_CLASS;

typedef struct {
    char	version[36];
    u_int	residue;
    u_char	flags;
#    define	 DCC_V11_INFO_FG_IPV6   0x01
#    define	 DCC_V11_INFO_FG_SOCKS  0x02
#    define	 DCC_V11_INFO_FG_TMP    0x04
    DCC_HDR     proto_hdr;
    DCC_V11_SRVR_CLASS dcc;
    DCC_V11_SRVR_CLASS grey;
    DCC_V11_IP	src;
    time_t	dccproc_last;
    time_t	dccproc_dccifd_try;
    int		dccproc_c;
} DCC_V11_CLNT_INFO;
#endif /* DCC_MAP_INFO_VERSION_11 */


#define	DCC_MAP_INFO_VERSION_10 "DCC client mapped data version #10"
#ifdef DCC_MAP_INFO_VERSION_10
typedef struct {
    int		rtt_adj;
    DCC_CLNT_ID	clnt_id;
    in_port_t	port;
    u_char	defined;
    char	hostname[MAXHOSTNAMELEN];
    u_char	pad;
    DCC_PASSWD	passwd;
} DCC_V10_SRVR_NM;
typedef struct {
    time_t	resolve;
    time_t	measure;
    int		gen;
    int		base_rtt;
    int		thold_rtt;
    int		avg_thold_rtt;
    int		num_addrs;
    time_t	fail_time;
    u_char	fail_exp;
    u_char	act_inx;
    DCC_V10_SRVR_NM nms[DCC_MAX_SRVR_NMS];
    DCC_V11_SRVR_ADDR addrs[DCC_MAX_SRVR_ADDRS];
} DCC_V10_SRVR_CLASS;
typedef struct {
    char	version[36];
    u_int	residue;
    u_char	flags;
    DCC_HDR     proto_hdr;
    DCC_V10_SRVR_CLASS dcc;
    DCC_V10_SRVR_CLASS grey;
    DCC_V11_IP	src;
    time_t	dccproc_last;
    time_t	dccproc_dccifd_try;
    int		dccproc_c;
} DCC_V10_CLNT_INFO;
#endif /* DCC_MAP_INFO_VERSION_10 */

#define	DCC_MAP_INFO_VERSION_9 "DCC client mapped data version #9"
#ifdef DCC_MAP_INFO_VERSION_9
typedef struct {
    char	version[36];
    u_int	residue;
    u_char	flags;
    DCC_HDR     proto_hdr;
    DCC_V10_SRVR_CLASS dcc;
    DCC_V10_SRVR_CLASS grey;
    DCC_V11_IP	src;
} DCC_V9_CLNT_INFO;
#endif /* DCC_MAP_INFO_VERSION_9 */

#define	DCC_MAP_INFO_VERSION_8 "DCC client mapped data version #8"
#ifdef DCC_MAP_INFO_VERSION_8
typedef struct {
    char	version[36];
    u_int	residue;
    u_char	flags;
    DCC_HDR     proto_hdr;
    DCC_V10_SRVR_CLASS dcc;
    DCC_V10_SRVR_CLASS grey;
} DCC_V8_CLNT_INFO;
#endif /* DCC_MAP_INFO_VERSION_8 */


#define DCC_IS_GREY(class)  ((class) == &dcc_clnt_info->grey)
#define DCC_IS_GREY_STR(c)  (DCC_IS_GREY(c) ? "greylist" : "DCC")
#define	DCC_GREY2PORT(mode) ((mode) ? DCC_GREY_PORT_HO : DCC_SRVR_PORT_HO)
#define DCC_CLASS2PORT(c)   DCC_GREY2PORT(DCC_IS_GREY(c))
#define DCC_GREY2CLASS(g)   ((g) ? &dcc_clnt_info->grey : &dcc_clnt_info->dcc)

extern DCC_CLNT_INFO *dcc_clnt_info;    /* memory mapped shared data */
extern u_char dcc_all_srvrs;		/* try to contact all servers */
extern DCC_PATH dcc_info_nm;
extern struct stat dcc_info_sb;


/* transmission logs */
typedef struct {			/* record of 1 transmission */
    DCC_OP_NUMS	op_nums;
    time_t	sent_us;		/* microseconds since operation start */
    time_t	delay_us;
    DCC_CLNT_ID	id;
    int		addrs_gen;
    DCC_SOCKU	su;
    SRVR_INX	srvr_inx;
    u_char	flags;
#    define	 DCC_XLFG_ANS	0x01	/* transmission has been answered */
#    define	 DCC_XLFG_FAKE	0x04
    DCC_PASSWD  passwd;
} DCC_XLENT;
typedef struct {
    u_char	outstanding;		/* unheard responses */
    u_char	working_addrs;
    struct {
	u_char	    xmits;
	u_char	    resps;
	u_char	    failures;
    } cur[DCC_MAX_SRVR_ADDRS];
    DCC_XLENT	*next;			/* next entry to use */
    DCC_XLENT	entries[DCC_MAX_SRVR_ADDRS*DCC_MAX_XMITS];
} DCC_XLOG;


typedef struct {
    DCC_SOCKET	s;
    DCC_CLNT_SRC *src;
    DCC_SOCKU	loc;			/* socket bound to this address */
    DCC_SOCKU	rem;			/* socket connected to this address */
} DCC_CLNT_CTXT_SOC;

typedef struct dcc_clnt_ctxt {
    struct dcc_clnt_ctxt *fwd;
    struct timeval now;			/* current time */
    struct timeval start;		/* when operation started */
    int		now_us;			/* usecs since start of operation */
    DCC_CLNT_CTXT_SOC soc[2];
    DCC_XLOG	xl;
} DCC_CLNT_CTXT;

#define DCC_INFO_TXT_VERSION	"version="
#define DCC_INFO_TXT_VERSION_CUR 3	/* differs from contents version # */
#define DCC_INFO_TXT_IPV6	"IPv6 "
#define DCC_INFO_TXT_IPV6_OFF	DCC_INFO_TXT_IPV6"off"
#define DCC_INFO_TXT_IPV6_ON	DCC_INFO_TXT_IPV6"on"
#define DCC_INFO_TXT_IPV6_ONLY	DCC_INFO_TXT_IPV6"only"
#define DCC_INFO_TXT_USE_SOCKS	"use SOCKS"
#define DCC_INFO_TXT_USE_SRC	"src="
#define DCC_INFO_TXT_USE_SRCBAD	"but unused"


/* many POSIX thread implementations have unexpected side effects on
 * ordinary system calls, so allow the calling application
 * to not use threads by having both threaded and unthreaded
 * DCC client interfaces */

extern u_char clnt_threaded;

extern void dcc_ctxts_lock(void);
extern void dcc_ctxts_unlock(void);
extern u_char dcc_clnt_wake_resolve(void);
extern void dcc_clnt_stop_resolve(void);
extern void dcc_clnt_unthread_init(void);
extern void dcc_clnt_thread_init(void);
extern void lock_work(void);
extern void unlock_work(void);
extern void lock_wf(void);
extern void unlock_wf(void);
#ifdef DCC_DEBUG_LOCKS
extern void assert_ctxts_locked(void);
extern void assert_ctxts_unlocked(void);
extern void assert_info_locked(void);
extern void assert_info_unlocked(void);
extern void assert_cwf_locked(void);
#else
#define assert_ctxts_locked()
#define assert_ctxts_unlocked()
#define assert_info_locked()
#define assert_info_unlocked()
#define assert_cwf_locked()
#endif /* DCC_DEBUG_LOCKS */

extern u_char helper_lock_init(void);
extern void helper_lock(void);
extern void helper_unlock(void);
#ifdef DCC_DEBUG_LOCKS
extern void assert_helper_locked(void);
extern void assert_helper_unlocked(void);
#else
#define assert_helper_locked()
#define assert_helper_unlocked()
#endif /* DCC_DEBUG_LOCKS */


extern const char *dcc_ap2str(const DCC_SRVR_ADDR *);
extern int dcc_ap2str_opt(char *, int,
			  const DCC_SRVR_CLASS *, u_char inx, char);

extern const char *dcc_parse_nm_port(DCC_EMSG *, const char *, u_int,
				     char *, u_int, in_port_t *, char *, u_int,
				     const char *, int);
extern const char *dcc_srvr_nm(u_char);
extern DCC_CLNT_CTXT *dcc_alloc_ctxt(void);
extern void dcc_rel_ctxt(DCC_CLNT_CTXT *);
extern u_char dcc_info_unlock(DCC_EMSG *);
extern u_char dcc_info_lock(DCC_EMSG *);
extern void dcc_force_measure_rtt(u_char);
extern u_char dcc_create_map(DCC_EMSG *, const char *, int *,
			     const DCC_SRVR_NM *, int, const DCC_SRVR_NM *, int,
			     const DCC_IP *, const DCC_IP *, DCC_INFO_FGS);
extern u_char dcc_unmap_close_info(DCC_EMSG *);
extern u_char dcc_map_info(DCC_EMSG *, const char *, int);
extern u_char dcc_map_lock_info(DCC_EMSG *, const char *, int);
extern u_char dcc_map_tmp_info(DCC_EMSG *, const DCC_SRVR_NM *,
			       const DCC_IP *, const DCC_IP *, DCC_INFO_FGS);
typedef u_char	DCC_CLNT_FGS;
#define DCC_CLNT_FG_NONE	    0x00
#define DCC_CLNT_FG_GREY	    0x01
#define DCC_CLNT_FG_BAD_SRVR_OK	    0x02
#define DCC_CLNT_FG_NO_MEASURE_RTTS 0x04
#define DCC_CLNT_FG_NO_FAIL	    0x08
#define DCC_CLNT_FG_RETRY	    0x10    /* retrying with different server */
#define DCC_CLNT_FG_SLOW	    0x20    /* slow timeouts */
#define DCC_CLNT_FG_RETRANS	    0x40    /* use old op_nums.r */
extern u_char dcc_clnt_rdy(DCC_EMSG *, DCC_CLNT_CTXT *, DCC_CLNT_FGS);
extern DCC_CLNT_CTXT *dcc_tmp_clnt_init(DCC_EMSG *, DCC_CLNT_CTXT *,
					const DCC_SRVR_NM *,
					const DCC_IP *, const DCC_IP *,
					DCC_CLNT_FGS, DCC_INFO_FGS);
extern DCC_CLNT_CTXT *dcc_clnt_start(DCC_EMSG *, DCC_CLNT_CTXT *,
				     const char *, DCC_CLNT_FGS);
extern DCC_CLNT_CTXT *dcc_clnt_start_fin(DCC_EMSG *, DCC_CLNT_CTXT *);
extern DCC_CLNT_CTXT *dcc_clnt_init(DCC_EMSG *, DCC_CLNT_CTXT *,
				    const char *, DCC_CLNT_FGS);
extern u_char dcc_clnt_soc_flush(DCC_CLNT_CTXT_SOC *);
extern int clear_soc_error(DCC_EMSG *, DCC_CLNT_CTXT_SOC *, const char *);
extern u_char dcc_clnt_connect(DCC_EMSG *, DCC_CLNT_CTXT *, DCC_CLNT_CTXT_SOC *,
			       const DCC_SOCKU *, sa_family_t);
extern void dcc_clnt_socs_close(DCC_CLNT_CTXT *);
extern DCC_CLNT_SRC *get_clnt_src(const DCC_CLNT_CTXT *ctxt,sa_family_t family);
extern u_char dcc_clnt_soc_reopen(DCC_EMSG *, DCC_CLNT_CTXT *,
				  DCC_CLNT_CTXT_SOC *, sa_family_t);
extern u_char dcc_clnt_op(DCC_EMSG *, DCC_CLNT_CTXT *, DCC_CLNT_FGS,
			  const SRVR_INX *, DCC_SRVR_ID *, DCC_SOCKU *,
			  DCC_HDR *, int, DCC_OPS, DCC_OP_RESP *, int);

extern DCC_OPS dcc_aop(DCC_EMSG *, DCC_CLNT_CTXT *,
		       DCC_CLNT_FGS, SRVR_INX, time_t,
		       DCC_AOPS, u_int32_t, u_char, u_char, u_char,
		       void *, u_int, DCC_OP_RESP *, DCC_SOCKU *);
extern u_char dcc_aop_persist(DCC_EMSG *, DCC_CLNT_CTXT *, DCC_CLNT_FGS, u_char,
			      DCC_AOPS, u_int32_t, int, DCC_OP_RESP *);

extern void print_info_src(const DCC_CLNT_INFO *, const char *);
extern void print_info(const char *, const DCC_CLNT_INFO *,
		       u_char, u_char, u_char, u_char);

extern int get_xhdr_fname(char *, int, const DCC_CLNT_INFO *);
extern void xhdr_init(DCC_HEADER_BUF *, DCC_SRVR_ID);
extern void xhdr_add_str(DCC_HEADER_BUF *, const char *,  ...) DCC_PF(2,3);
extern void xhdr_add_ck(DCC_HEADER_BUF *, DCC_CK_TYPES, DCC_TGTS);
extern void xhdr_write(LOG_WRITE_FNC, void *, const char *, int, u_char);
extern void xhdr_whitelist(DCC_HEADER_BUF *);
extern u_char is_xhdr(const char *, int);


#endif /* DCC_CLNT_H */
