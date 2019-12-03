/* Distributed Checksum Clearinghouse
 *
 * client-server and server-server protocols
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
 * Rhyolite Software DCC 2.3.167-1.165 $Revision$
 */

#ifndef DCC_PROTO_H
#define DCC_PROTO_H

#define DCC_PKT_VERS_INVALID	0
#define DCC_PKT_VERS_MULTI	1	/* multiple versions seen from client */

#define DCC_PKT_VERS4		4
#define	DCC_PKT_VERS5		5
#define	DCC_PKT_VERS6		6
#define	DCC_PKT_VERS7		7
#define	DCC_PKT_VERS8		8
#define	DCC_PKT_VERS9		9
#define	DCC_PKT_VERS10		10
#define	DCC_PKT_VERS11		11	/* same protocol as 10 */
#define	DCC_PKT_VERS12		12
#define	DCC_PKT_VERS		DCC_PKT_VERS12

#define	DCC_PKT_VERS_MIN	DCC_PKT_VERS4	/* oldest recognized */
#define	DCC_PKT_VERS_MAX	DCC_PKT_VERS	/* newest recognized */

/* penalize older servers by DCC_RTT_VERS_ADJ */
#define DCC_PKT_VERS_CLNT_OK	DCC_PKT_VERS9
/* accept these versions for NOPs while negotiating the version */
#define DCC_PKT_VERS_NOP_MIN	DCC_PKT_VERS_MIN
#define	DCC_PKT_VERS_NOP_MAX	32


#define DCC_SRVR_PORT	6277		/* default DCC server port # */
#define DCC_GREY_PORT	6276		/* grey listing server port */
#ifdef DCC_LITTLE_ENDIAN
#define DCC_SRVR_PORT_HO    0x8518
#define DCC_GREY_PORT_HO    0x8418
#else
#define DCC_SRVR_PORT_HO    0x1885
#define DCC_GREY_PORT_HO    0x1884
#endif


/* types of checksums */
typedef enum {
    DCC_CK_INVALID	    =0,		/* deleted from database when seen */
    DCC_CK_IP		    =1,		/* MD5 of binary source IPv6 address */
    DCC_CK_ENV_FROM	    =2,		/*  "  "  envelope Mail From value */
    DCC_CK_FROM		    =3,		/*  "  "  header From: line */
    DCC_CK_SUB		    =4,		/*  "  "  substitute header line */
    DCC_CK_MESSAGE_ID	    =5,		/*  "  "  header Message-ID: line */
    DCC_CK_RECEIVED	    =6,		/*  "  "  last header Received: line */
    DCC_CK_BODY		    =7,		/*  "  "  body */
    DCC_CK_FUZ1		    =8,		/*  "  "  filtered body */
    DCC_CK_FUZ2		    =9,		/*  "  "     "      "   */
    DCC_CK_G_MSG_R_TOTAL    =10,
#    define DCC_CK_GREY_MSG   DCC_CK_G_MSG_R_TOTAL
#    define DCC_CK_REP_TOTAL  DCC_CK_G_MSG_R_TOTAL
    DCC_CK_G_TRIPLE_R_BULK  =11,
#    define DCC_CK_GREY3      DCC_CK_G_TRIPLE_R_BULK
#    define DCC_CK_REP_BULK   DCC_CK_G_TRIPLE_R_BULK
    DCC_CK_SRVR_ID	    =12,	/* hostname for server-ID check */
    DCC_CK_ENV_TO	    =13		/* MD5 of envelope Rcpt To value */
#    define DCC_CK_FLOD_PATH  DCC_CK_ENV_TO /* flooding path in server-IDs */
} DCC_CK_TYPES;
typedef u_char DCC_CK_TYPE_B;		/* big enough */
#define DCC_CK_TYPE_FIRST   DCC_CK_IP
#define DCC_CK_TYPE_LAST    DCC_CK_ENV_TO

/* DCC_DIM_CKS dimensions arrays of checksum types including DCC_CK_INVALID
 * It also limits the number of checksums in a client-server request
 * via DCC_QUERY_MAX and the number checksums in a database record.
 * Beware that DCC_DIM_CKS is used in the database header. */
#define DCC_DIM_CKS	    (DCC_CK_TYPE_LAST+1)

/* record of path taken by a report */
#define DCC_NUM_FLOD_PATH ((int)(sizeof(DCC_SUM)/sizeof(DCC_SRVR_ID)))
typedef struct DCC_PACKED {
    u_char	hi, lo;
} DCC_FLOD_PATH_ID;
/* DCC_MAX_FLOD_PATH assumes that among the maximum 14 possible slots for
 * checksums in a flooded report (dimension of cks in a DB_RCD or DCC_DIM_CKS),
 *	DCC_CK_INVALID is never used
 *	DCC_CK_SRVR_ID is never used when any real checksums are present,
 * is so there is always room for 2 extra DCC_CK_FLOD_PATH entries besides
 * the natural DCC_CK_FLOD_PATH entry.
 * DB_RCD_FG_MASK depends on this */
#define DCC_MAX_FLOD_PATHS 3
/* This must not be too large lest reports become larger than DCC_DIM_CKS */
#define DCC_MAX_FLOD_PATH (DCC_NUM_FLOD_PATH*DCC_MAX_FLOD_PATHS)


/* the number checksums in client-server protocol
 * This must be even to prevent structure padding */
#define	DCC_QUERY_MAX DCC_DIM_CKS

/* keep some checksums in the database longer than others */
#define DCC_CK_LONG_TERM(t) ((t) >= DCC_CK_FUZ1				\
			     && (t) <= DCC_CK_G_TRIPLE_R_BULK)

#define DCC_CK_IS_BODY(t) ((t) >= DCC_CK_BODY && (t) <= DCC_CK_FUZ2)

/* MD5 of greylist msg+sender+target */
#define DCC_CK_IS_GREY_MSG(g,t) ((g) && (t) == DCC_CK_GREY_MSG)
/* MD5 of greylisted triple */
#define DCC_CK_IS_GREY_TRIPLE(g,t) ((g) && (t) == DCC_CK_GREY3)
#define DCC_CK_IS_GREY(g,t) (DCC_CK_IS_GREY_MSG(g,t)			\
			     || DCC_CK_IS_GREY_TRIPLE(g,t))

/* total messages sent by an IP address */
#define DCC_CK_IS_REP_TOTAL(g,t)   (!(g) && (t) == DCC_CK_REP_TOTAL)
/* bulk messages sent by an IP address */
#define DCC_CK_IS_REP_BULK(g,t)    (!(g) && (t) == DCC_CK_REP_BULK)
#define DCC_CK_IS_REP(g,t)	    (DCC_CK_IS_REP_TOTAL(g,t)		\
				     || DCC_CK_IS_REP_BULK(g,t))

typedef enum {
    DCC_OP_INVALID	=0,
    DCC_OP_NOP		=1,		/* see if the server is alive */
    DCC_OP_REPORT	=2,		/* old client reporting and querying */
    DCC_OP_QUERY	=3,		/* client querying */
    DCC_OP_ANSWER	=4,		/* server responding */
    DCC_OP_ADMN		=5,		/* control the server */
    DCC_OP_OK		=6,		/* administrative operation ok */
    DCC_OP_ERROR	=7,		/* server failing or complaining */
    DCC_OP_DELETE	=8,		/* delete some checksums */
    DCC_OP_GREY_REPORT	=9,		/* greylist report */
    DCC_OP_GREY_QUERY	=10,		/*   "   "  query */
    DCC_OP_GREY_SPAM	=11,		/* forget greylisted spammer */
    DCC_OP_GREY_WHITE	=12		/* whitelisted greylist triple */
} DCC_OPS;

typedef u_int32_t DCC_CLNT_ID;
#define DCC_ID_INVALID	    0
#define DCC_ID_ANON	    1		/* anonymous (non-paying) client */
#define DCC_ID_WHITE	    2		/* whitelisted */
#define DCC_ID_COMP	    3		/* compressed */
/* #define DCC_ID_obsolete  4 */
#define	DCC_ID_SRVR_SIMPLE  5		/* simple server */
#define	DCC_ID_SRVR_IGNORE  6		/* ignore its flooded reports */
#define	DCC_ID_SRVR_ROGUE   7		/* crazy server */
#define DCC_ID_SRVR_TYPE(id) ((id) == DCC_ID_SRVR_SIMPLE		\
			      || (id) == DCC_ID_SRVR_IGNORE		\
			      || (id) == DCC_ID_SRVR_ROGUE)
#define DCC_ID_CLIENTS_MULT 8

#define DCC_ID_SRVR_TYPE_ID(sum) (((sum)->b[1]<<8) + (sum)->b[2])
#define DCC_ID_SRVR_TYPE_SET(sum,id) do {				\
	memset((sum), 0, sizeof(*sum)); (sum)->b[0] = DCC_CK_SRVR_ID;	\
	(sum)->b[1] = (id)>>8; (sum)->b[2] = (id);} while (0)
#define DCC_ID_SRVR_DATE    99		/* timestamp or keepalive */
#define DCC_SRVR_ID_MIN	    100		/* < reserved for special uses */
#define	DCC_SRVR_ID_MAX	    32767	/* < are servers--must be 2**n-1 */
#define DCC_ID_SRVR_NORMAL(id) ((id) >= DCC_SRVR_ID_MIN			\
				&& (id) <= DCC_SRVR_ID_MAX)
#define DCC_CLNT_ID_MIN	    (DCC_SRVR_ID_MAX+1)
#define DCC_CLNT_ID_MAX	    0xffffff
typedef u_int16_t DCC_SRVR_ID;
#define	DCC_SRVR_ID_MASK    DCC_SRVR_ID_MAX

/* client's identification of its transaction */
typedef u_int32_t DCC_OP_NUM;
typedef struct {
    DCC_OP_NUM	h;			/* client host ID, e.g. IP address */
    DCC_OP_NUM	p;			/* process ID, serial #, timestamp */
    DCC_OP_NUM	r;			/* report ID */
    DCC_OP_NUM	t;			/* client (re)transmission # */
} DCC_OP_NUMS;

/* The inter-DCC server flooding algorithm depends on unique-per-server
 * timestamps to detect duplicates.  That demands timestamps with resolution
 * enough to separate reports from clients arriving at any single server.
 * The timestamps are 48 bits consisting of 17 bits of 8's of microseconds
 * and 31 bits of seconds.  That's sufficient for the UNIX epoch.
 * If the DCC is still around in the 2030's and in the unlikely case that
 * 8 microseconds are still fine enough, we can change the protocol number
 * and make the 31 bits an offset from a lator epoch.
 */
#define DCC_TS_EPOCH	    0		/* offset from UNIX epoch */
#define DCC_TS_USEC_SHIFT   3
#define DCC_TS_USEC_MULT    (1<<DCC_TS_USEC_SHIFT)
#define DCC_TS_SEC_SHIFT    17
#define DCC_TS_USEC_MASK    ((1<<DCC_TS_SEC_SHIFT) - 1)
typedef struct DCC_PACKED {
    u_char  b[6];
} DCC_TS;

/* The start of any DCC packet.
 *	The length and version are early, since they are the only fields
 *	constrained in future versions. */
typedef struct {
    u_int16_t	len;			/* total DCC packet length */
    u_char	pkt_vers;		/* packet protocol version */
    u_char	op;			/* one of DCC_OPS */
    /* Identify the transaction.
     *	    Each client can have many hosts, each host can be multi-homed,
     *	    and each host can be running many processes talking to the
     *	    server.  Each packet needs to be uniquely numbered, so that the
     *	    server can recognize as interchangable all of the (re)transmissions
     *	    of a single report (rid) from a client process (pid) on a single
     *	    host (hid), and the client can know which transmission (tid)
     *	    produced a given server response to maintain the client's RTT
     *	    value for the server. */
    DCC_CLNT_ID	sender;			/* client-ID or server-ID */
    DCC_OP_NUMS	op_nums;		/* op_num.t must be last */
} DCC_HDR;

typedef u_char DCC_SIGNATURE[16];

typedef struct {
    DCC_HDR	hdr;
    DCC_SIGNATURE signature;
} DCC_NOP;


/* DCC_OP_ADMN administrative requests from localhost
 *	Most of these can be changed, because the administrative tools
 *	should match the daemon. */
typedef enum {
    DCC_AOP_OK		=-1,		/* never really sent */
    DCC_AOP_STOP	= 1,		/* stop gracefully */
    /* DCC_AOP_unused	= 2,		   unused; was DCC_AOP_DB_UNLOAD */
    DCC_AOP_FLOD	= 3,		/* start or stop flooding */
    DCC_AOP_DB_CLEAN	= 4,		/* start cleaning */
    DCC_AOP_DB_NEW	= 5,		/* finish switch to new database */
    DCC_AOP_STATS	= 6,		/* return counters--val=buffer size */
    DCC_AOP_STATS_CLEAR	= 7,		/* return and zero counters */
    DCC_AOP_TRACE_ON	= 8,
    DCC_AOP_TRACE_OFF	= 9,
    DCC_AOP_unused1	= 10,		/*	was dcc1-1-36 clients command */
    DCC_AOP_CLIENTS	= 11,		/* some client IP addresses */
    DCC_AOP_CLIENTS_ID	= 12,		/* some client IDs */
    DCC_AOP_ANON_DELAY	= 13,		/* anonymous delay parameters */
    DCC_AOP_CLOCK_CHECK	= 14
} DCC_AOPS;

/* for DCC_AOP_FLOD */
typedef enum {
    DCC_AOP_FLOD_CHECK=0,
    DCC_AOP_FLOD_SHUTDOWN,
    DCC_AOP_FLOD_HALT,
    DCC_AOP_FLOD_RESUME,
    DCC_AOP_FLOD_REWIND,
    DCC_AOP_FLOD_LIST,
    DCC_AOP_FLOD_STATS,
    DCC_AOP_FLOD_STATS_CLEAR,
#    define DCC_AOP_FLOD_STATS_ID   " server-ID %u "
    DCC_AOP_FLOD_FFWD_IN,
    DCC_AOP_FLOD_FFWD_OUT
} DCC_AOP_FLODS;

typedef struct {
	u_char addr6[sizeof(struct dcc_in6_addr)];
	u_char	bits;
} DCC_AOP_CLIENTS_VAL5_TGT_ADDR;
typedef struct {
    DCC_AOP_CLIENTS_VAL5_TGT_ADDR tgt_addr;
    u_char	tgt_id[sizeof(DCC_CLNT_ID)];
} DCC_AOP_CLIENTS_VAL5;

typedef struct {			/* with operation DCC_OP_ADMN */
    DCC_HDR	hdr;
    u_int32_t	date;			/* seconds since epoch on caller */
    u_int32_t	val1;			/* request type, buffer size, etc. */
    u_char	aop;			/* one of DCC_AOPS */
    u_char	val2;
    u_char	val3;
    u_char	val4;
#    define	 DCC_MAX_ADMN_REQ_VAL5	64
    union {
	u_char	b[DCC_MAX_ADMN_REQ_VAL5];
	DCC_AOP_CLIENTS_VAL5 clients;
    } val5;
    DCC_SIGNATURE signature;
} DCC_ADMN_REQ;
#define DCC_ADMN_REQ_MIN_SIZE (ISZ(DCC_ADMN_REQ) - DCC_MAX_ADMN_REQ_VAL5)


/* scale client's response buffer size in part of val1 by this */
#define DCC_ADMIN_CLIENTS_SHIFT		5
/* limit threshold in part of val1 */
#define DCC_ADMIN_CLIENTS_MAX_THOLD    ((1<<16)-1)

/* val2 for DCC_AOP_CLIENTS or DCC_AOP_CLIENTS_ID */
#define DCC_AOP_CLIENTS_AVG		0x01	/* want averages */
#define DCC_AOP_CLIENTS_VERS		0x02	/* want protocol version */
#define DCC_AOP_CLIENTS_ANON		0x04	/* only anonymous clients */
#define DCC_AOP_CLIENTS_NON_ANON	0x08	/* non-anonymous only */

#define DCC_AOP_CLIENTS_MAX_OFFSET	((1<<24)-1)

/* noisy response to DCC_AOP_CLIENTS or DCC_AOP_CLIENTS_ID */
typedef	u_char DCC_ADMN_RESP_CLIENTS_FLAGS;
#define	DCC_ADMN_RESP_CLIENTS_BLACK	0x01	/* this client blacklisted */
#define	DCC_ADMN_RESP_CLIENTS_IPV6	0x02	/* address is IPv6 */
#define	DCC_ADMN_RESP_CLIENTS_SKIP	0x04	/* last_used=clients skipped */
#define	DCC_ADMN_RESP_CLIENTS_ANON	0x08	/* suppressed ID=DCC_ID_ANON */
#define DCC_ADMN_RESP_CLIENTS_VERS	0x10	/* protocol version # present */
#define DCC_ADMN_RESP_CLIENTS_LAST	0x20
#define DCC_ADMN_RESP_CLIENTS_DROPPED	0x40	/* something dropped */
#define	DCC_ADMN_RESP_CLIENTS_BLOCK	0x80	/* CIDR block entry */

#define	DCC_ADMN_RESP_CLIENTS_IPV4_BITS	    24
#define	DCC_ADMN_RESP_CLIENTS_IPV6_BITS	    56

#define DCC_ADMN_RESP_CLIENTS_NO_AUTH	    (DCC_CLNT_ID_MAX+1)

#define DCC_ADMIN_CLIENTS_MAX_DELTA	0x1fffff
typedef u_int64_t DCC_SCNTR;
#define DCC_ADMIN_RESP_MAX_CLIENTS	(1000*1000)


#ifdef DCC_PKT_VERS6
typedef struct {
    u_char	clnt_id[4];
    u_char	last_used[4];
    u_char	reqs[3];
    u_char	nops[2];
    u_char	flags;
    union {
	u_char	ipv6[16];
	u_char	ipv4[4];
    } addr;
} DCC_ADMN_RESP_CLIENTSv6;
#endif /* DCC_PKT_VERS6 */

typedef struct {
    u_char	inflate[4];
    u_char	delay[2];
#    define	 DCC_ANON_DELAY_MAX	DCC_MAX_RTT
#    define	 DCC_ANON_DELAY_FOREVER	((u_int16_t)-1)
#    define	 DCC_NO_ANON_DELAY	((u_int16_t)-2)
} DCC_ADMN_RESP_ANON_DELAY;
typedef union {
    char	string[1460];		/* avoid UDP fragments vs. firewalls */
    u_char	clients[1];
#ifdef DCC_PKT_VERS6
    DCC_ADMN_RESP_CLIENTSv6 clientsV6[1];
#endif
    DCC_ADMN_RESP_ANON_DELAY anon_delay;
} DCC_ADMN_RESP_VAL;
typedef struct {
    DCC_HDR	hdr;
    DCC_ADMN_RESP_VAL val;
    DCC_SIGNATURE signature;
} DCC_ADMN_RESP;


typedef u_int32_t DCC_TRACEMASK;
#define DCC_TRACE_ADMN_BIT  0x0001	/* administrative requests */
#define DCC_TRACE_ANON_BIT  0x0002	/* anonymous client errors */
#define DCC_TRACE_CLNT_BIT  0x0004	/* authenticated client errors */
#define DCC_TRACE_RLIM_BIT  0x0008	/* rate limited messages */
#define DCC_TRACE_QUERY_BIT 0x0010	/* all queries and reports */
#define DCC_TRACE_RIDC_BIT  0x0020	/* RID cache messages */
#define DCC_TRACE_FLOD1_BIT 0x0040	/* general inter-server flooding */
#define DCC_TRACE_FLOD2_BIT 0x0080	/* individual flooded reports */
/* #define		    0x0100	   unused */
#define DCC_TRACE_BL_BIT    0x0200	/* blacklisted clients */
#define DCC_TRACE_DB_BIT    0x0400	/* odd database events */
#define DCC_TRACE_WLIST_BIT 0x0800	/* whitelisted checksums */
#define DCC_TRACE_BITS  (DCC_TRACE_ADMN_BIT | DCC_TRACE_ANON_BIT	\
			 | DCC_TRACE_CLNT_BIT | DCC_TRACE_RLIM_BIT	\
			 | DCC_TRACE_QUERY_BIT | DCC_TRACE_RIDC_BIT	\
			 | DCC_TRACE_FLOD1_BIT | DCC_TRACE_FLOD2_BIT	\
			 | DCC_TRACE_BL_BIT				\
			 | DCC_TRACE_DB_BIT | DCC_TRACE_WLIST_BIT)
#define DCC_TRACE_DEF (DCC_TRACE_ANON_BIT | DCC_TRACE_CLNT_BIT		\
		       | DCC_TRACE_WLIST_BIT)
#define DCC_TRACE_GREY_DEF DCC_TRACE_DEF


#define DCC_BRAND_MAXLEN 64
typedef char DCC_BRAND[DCC_BRAND_MAXLEN];

/* administrative or NOP ok */
typedef struct {
    DCC_HDR	hdr;
    u_char	max_pkt_vers;		/* server can handle this version */
    u_char	unused;
    u_int16_t	qdelay_ms;
    DCC_BRAND	brand;			/* identity or brandname of sender */
    DCC_SIGNATURE signature;
} DCC_OK;


typedef u_int32_t DCC_TGTS;		/* database is limited to 24 bits */
#define	DCC_TGTS_TOO_MANY   0x00fffff0	/* >= 16777200 targets */
#define	DCC_TGTS_OK	    0x00fffff1	/* certified not spam */
#define	DCC_TGTS_OK2	    0x00fffff2	/* half certified not spam */
#define DCC_TGTS_GREY_WHITE DCC_TGTS_OK2    /* whitelisted for greylisting */
#define	DCC_TGTS_DEL	    0x00fffff3	/* a deleted checksum */
#define DCC_TGTS_REP_ADJ    0x00fffff4	/* scale a reputation */
#define DCC_TGTS_OK_MX	    0x00fffff5	/* partly whitelist MX secondary */
#define DCC_TGTS_OK_MXDCC   0x00fffff6	/* MX secondary with DCC client */
#define DCC_TGTS_SUBMIT_CLIENT 0xfffff7	/* SMTP submission client */
#define DCC_TGTS_MAX_DB	    DCC_TGTS_REP_ADJ
#define DCC_TGTS_INVALID    0x01000000
#define DCC_TGTS_SPAM	    DCC_TGTS_INVALID	/* mail was spam for client */
#define DCC_TGTS_REP_SPAM   0x02000000	/* reputation made mail spam */
#define DCC_TGTS_MASK	    0x00ffffff

#define DCC_TGTS_RPT_MAX	2000
#define DCC_TGTS_FLOD_RPT_MAX	DCC_TGTS_TOO_MANY
#define BULK_THRESHOLD		10
#define	REFLOOD_THRESHOLD	300
#define REFLOOD_SMALL_THRESHOLD	(REFLOOD_THRESHOLD*4)
/* change man pages and CGI scripts if DCC_REP_TOTAL_THOLD_DEF changes */
#define DCC_REP_TOTAL_THOLD_DEF	20
#define DCC_REP_TGTS_SCALE  100		/* as in 100% */
#define DCC_REP_TGTS_BULK_SIGNIF    BULK_THRESHOLD
#define DCC_REP_TGTS_TOTAL_MIN	    DCC_REP_TOTAL_THOLD_DEF
#define DCC_REP_TGTS_TOTAL_SIGNIF (DCC_REP_TGTS_SCALE*DCC_REP_TGTS_BULK_SIGNIF)
#define DCC_REP_TGTS_MAX	    (DCC_TGTS_TOO_MANY-1)
#define DCC_REP_TGTS_ADJ_VAL	    (DCC_TGTS_RPT_MAX*1000*2)
#if DCC_REP_TGTS_ADJ_VAL > DCC_TGTS_TOO_MANY/2
#error "DCC_REP_TGTS_ADJ_VAL > DCC_TGTS_TOO_MANY/2"
#endif
#define DCC_REP_TGTS_ADJ_LIMIT   (DCC_TGTS_TOO_MANY - DCC_REP_TGTS_ADJ_VAL)
#define DCC_REP_TGTS_ADJ_FRAC    3

/* checksums kept by most servers */
#define DCC_CK_IS_GREY_BODY(g,t) ((g) ? ((t)==DCC_CK_BODY) : DCC_CK_IS_BODY(t))
#define DB_GLOBAL_NOKEEP(g,t) (!DCC_CK_IS_GREY_BODY(g,t)		\
			       && (t) != DCC_CK_SRVR_ID			\
			       && (t) != DCC_CK_G_MSG_R_TOTAL		\
			       && (t) != DCC_CK_G_TRIPLE_R_BULK)

/* checksums subject to thresholds */
#define DCC_CK_THOLD_OK(t)  ((t) > DCC_CK_INVALID			\
			     && (t) <= DCC_CK_G_TRIPLE_R_BULK)

#define IS_ALL_CKSUM(t)	(DCC_CK_THOLD_OK(t) && !DCC_CK_IS_REP(0, t))
#define IS_CMN_CKSUM(t)	DCC_CK_IS_BODY(t)


/* a reported checksum from a client */
typedef union DCC_PACKED {
    u_char b[16];
    DCC_FLOD_PATH_ID p[8];
} DCC_SUM;
typedef struct DCC_PACKED {
    DCC_CK_TYPE_B type;
    u_char	len;			/* total length of this checksum */
    DCC_SUM	sum;
} DCC_CK;

/* most packets from client to server */
typedef struct {
    DCC_HDR	hdr;
    DCC_TGTS	tgts;			/* # of addressees */
    DCC_CK	cks[DCC_QUERY_MAX];	/* even to prevent structure padding */
    DCC_SIGNATURE signature;
} DCC_REPORT;

/* most responses */
typedef struct {
    DCC_TGTS	c;			/* current value, with this report */
    DCC_TGTS	p;			/* previous value, before this report */
} DCC_ANSWER_BODY_CKS;
typedef struct {
    DCC_HDR	hdr;
    DCC_ANSWER_BODY_CKS b[DCC_QUERY_MAX];
    DCC_SIGNATURE signature;
} DCC_ANSWER;

#ifdef DCC_PKT_VERS5
typedef struct {
    DCC_HDR	hdr;
    DCC_TGTS	b[DCC_QUERY_MAX];	/* current values */
    DCC_SIGNATURE signature;
} DCC_ANSWERv5;
#endif

typedef struct {
    DCC_HDR	hdr;
    DCC_TGTS	msg;
    DCC_TGTS	triple;
    DCC_SIGNATURE signature;
} DCC_GREY_ANSWER;


/* DCC_OP_DELETE request to delete checksums */
typedef struct {
    DCC_HDR	hdr;
    int32_t	date;			/* seconds since epoch on client */
    DCC_CK	ck;
    u_char	pad[2];
    DCC_SIGNATURE signature;
} DCC_DELETE;


/* DCC_OP_GREY_SPAM restore greylist embargo */
typedef struct {
    DCC_HDR	hdr;
    DCC_CK	ip;
    DCC_CK	msg;
    DCC_CK	triple;
    DCC_SIGNATURE signature;
} DCC_GREY_SPAM;


/* error response from server to client */
typedef struct {
    DCC_HDR	hdr;
#    define	 DCC_ERROR_MSG_LEN  128
    char	msg[DCC_ERROR_MSG_LEN];
    DCC_SIGNATURE signature;
} DCC_ERROR;


typedef union {
    DCC_HDR	hdr;
    DCC_ANSWER	ans;
#ifdef DCC_PKT_VERS5
    DCC_ANSWERv5 ans5;
#endif
    DCC_GREY_ANSWER gans;
    DCC_OK	ok;
    DCC_ERROR	error;
    DCC_ADMN_RESP resp;
    int		w[6];
} DCC_OP_RESP;




/* ************** server-to-server flooding protocol ************ */

/* This protocol is the sort of botch of a mess that results from assuming
 * a considered protocol is not necessary and then extending it. */

/* A flooding connection starts with the TCP client or connection originator
 * sending an ASCII "magic" string including a version number, the connection
 * originator's server-ID, whether SOCKS is involved, and a cryptographic
 * hash of the fixed-length message.  In the common case, the connection
 * orginator will send a flood of DCC reports.  If SOCKS is involved, the
 * connection is immediately turned around. */
#define DCC_FLOD_VERS_BASE	"DCC flod version "
#define DCC_FLOD_VERS7		7
/* in the next version, add a length to DCC_FLOD_END */
#define DCC_FLOD_VERS7_NUM	"7"
#define DCC_FLOD_VERS7_STR	DCC_FLOD_VERS_BASE DCC_FLOD_VERS7_NUM
#define DCC_FLOD_VERS_DEF	0
#define DCC_FLOD_VERS_CUR	DCC_FLOD_VERS7
#define DCC_FLOD_VERS_CUR_STR	DCC_FLOD_VERS7_STR
#define DCC_FLOD_REP_VERS_BASE	DCC_FLOD_VERS_BASE"rep "
#define DCC_FLOD_REP_VERS7_STR	DCC_FLOD_REP_VERS_BASE  DCC_FLOD_VERS7_NUM
#define DCC_FLOD_REP_VERS_CUR	DCC_FLOD_VERS7
#define DCC_FLOD_REP_VERS_CUR_STR DCC_FLOD_REP_VERS7_STR
typedef struct DCC_PACKED {
#    define DCC_FLOD_VERS_STR_LEN 64
    char	str[DCC_FLOD_VERS_STR_LEN];
    u_char	sender_srvr_id[sizeof(DCC_SRVR_ID)];
    u_char	turn;			/* 1=turn connection around for SOCKS */
    u_char	unused[3];
} DCC_FLOD_VERS_BODY;
typedef struct DCC_PACKED {
    DCC_FLOD_VERS_BODY body;
    char	pad[256-sizeof(DCC_FLOD_VERS_BODY)-sizeof(DCC_SIGNATURE)];
    DCC_SIGNATURE signature;
} DCC_FLOD_VERS_HDR;


/* flood sender's position or serial number
 *	Only the sender understands sender positions except for these
 *	special values.  However, the special values imply that the position
 *	must be big endian. */
typedef u_char DCC_FLOD_POS[8];
/* special cases sent by the receiver back to the sender */
typedef enum {
    DCC_FLOD_POS_END	    =0,		/* receiver closing with message */
    DCC_FLOD_POS_END_REQ    =1,		/* receiver wants to stop */
    DCC_FLOD_POS_NOTE	    =2,		/* receiver has a tracing message */
    DCC_FLOD_POS_COMPLAINT  =3,		/* receiver has a problem message */
    DCC_FLOD_POS_REWIND	    =4,		/* receiver's database emptied */
    DCC_FLOD_POS_FFWD_IN    =5		/* receiver wants fast-forward */
} DCC_FLOD_POS_OPS;
#define DCC_FLOD_POS_MIN    10

#define DCC_FLOD_OK_STR	    "DCC flod ok: "

/* final result sent from flood receiver to flood sender
 *	This structure always ends the TCP stream.  The length of the msg is
 *	obtain from the number of buts to the end of the stream.  It should
 *	have had an explicit length in the structure.  */
typedef struct DCC_PACKED {
    DCC_FLOD_POS pos;			/* one of DCC_FLOD_POS_* */
#    define DCC_FLOD_MAX_RESP   200
    char	msg[DCC_FLOD_MAX_RESP];	/* no '\0'; uses length to EOF */
} DCC_FLOD_END;
#define FLOD_END_OVHD ISZ(((DCC_FLOD_END*)0)->pos)

/* report forwarded among servers */
typedef struct DCC_PACKED {
    DCC_FLOD_POS pos;
    u_char	tgts[sizeof(DCC_TGTS)];
    u_char	srvr_id[sizeof(DCC_SRVR_ID)];	/* receiving server */
    DCC_TS	ts;			/* date reported */
    u_char	num_cks;
    DCC_CK	cks[DCC_QUERY_MAX];
} DCC_FLOD_RPT;
#define DCC_FLOD_RPT_LEN(n) (ISZ(DCC_FLOD_RPT) - ISZ(DCC_CK)*DCC_QUERY_MAX  \
			     + ISZ(DCC_CK)*(n))

/* what can appear in the stream of flooded reports */
typedef union DCC_PACKED {
    DCC_FLOD_VERS_HDR v;
    DCC_FLOD_END    e;
    DCC_FLOD_RPT    r;
} DCC_FLOD_STREAM;


/* a response to flooded reports */
typedef union DCC_PACKED {
    DCC_FLOD_POS    pos;
    DCC_FLOD_END    end;		/* final result */
    struct DCC_PACKED {
	DCC_FLOD_POS    op;		/* one of DCC_FLOD_POS_* */
	u_char		len;		/* total length */
	char		str[DCC_FLOD_MAX_RESP]; /* includes trailing '\0' */
    } note;
} DCC_FLOD_RESP;
#define FLOD_NOTE_OVHD (ISZ(((DCC_FLOD_RESP*)0)->note) - DCC_FLOD_MAX_RESP)


/* parts of error messages sent between flooding peers */
#define DCC_FLOD_BAD_VER_MSG	"unrecognized flod version"
#define DCC_FLOD_BAD_ID_MSG	"unauthorized ID"
#define DCC_FLOD_BAD_AUTH_MSG	"bad authentication for ID"
#define DCC_FLOD_PASSWD_ID_MSG	"unknown passwd-ID"
#define DCC_FLOD_AYT		"are you there?"


#endif /* DCC_PROTO_H	*/
