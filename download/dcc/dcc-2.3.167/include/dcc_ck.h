/* Distributed Checksum Clearinghouse
 *
 * checksum routines
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
 * Rhyolite Software DCC 2.3.167-1.212 $Revision$
 */

#ifndef DCC_CK_H
#define DCC_CK_H

#include "dcc_clnt.h"
#include "dcc_md5.h"


typedef struct {
    DCC_TGTS	t[DCC_DIM_CKS];
} CKSUM_THOLDS;
#define THOLD_NEVER	    (DCC_TGTS_TOO_MANY+1)
#define THOLD_UNSET	    (DCC_TGTS_INVALID)

extern CKSUM_THOLDS tholds_rej;


/* MIME boundary
 * RFC 1341 says boundaries can be 70 bytes, but handle non-conformant spam */
#define CK_BND_MAX	    94
#define CK_BND_DIM	(CK_BND_MAX+2)  /* including leading -- */
#define CK_BND_MISS	(CK_BND_DIM+1)
typedef struct {
    u_char	bnd_len;		/* length including leading "--" */
    u_char	cmp_len;		/* compared so far */
    char	bnd[CK_BND_DIM];	/* "--"boundary */
} CK_BND;


/* decide which characters are parts of words */
#define FC_A    'a'			/* letter in a word */
#define FC_SP   ' '			/* white space */
#define FC_JK   '#'			/* junk not part of a word */
#define FC_LT   '<'			/* start of HTML tag */
#define FC_SK   0			/* ignored punctuation */
typedef u_char CK_FC[256];
extern const CK_FC c8859_1, c8859_2;

#define MIN_CK_WLEN	3

typedef union {
    u_int32_t	w32[4];
    u_char	b[16];
} CK_WORD;

#define CK_WORD_HASH(w,hash_len) (ntohl((w)->w32[0] ^ (w)->w32[1]	\
					^ (w)->w32[2] ^ (w)->w32[3]) % hash_len)

#define	CK_WORD_CLEAR(w) ((w)->w32[0] = 0, (w)->w32[1] = 0,		\
			  (w)->w32[2] = 0, (w)->w32[3] = 0)


/* state machine for decode %-encoding and HTML character references */
typedef struct {
    enum {
	CREF_ST_IDLE = 0,
	CREF_ST_START,			/* get HTML character name */
	CREF_ST_NUM,			/*	hex or decimal */
	CREF_ST_DEC,
	CREF_ST_HEX,
	CREF_ST_NAME
    } st;
    CK_WORD	w;
    u_char	len;
    u_char	result;
} CK_CREF;


#define URL_HOST_MAX	    DCC_MAXDOMAINLEN
#define URL_LABEL_MAX	    63
#define	URL_HOST_MAX_SAVE   (1+URL_HOST_MAX)
#define URL_FAILSAFE	    2000	/* big bogus "username:password@" */

/* state machine for capturing and then ignoring parts of URLs */
typedef struct {
    CK_CREF	cref;
    enum {
	URL_ST_IDLE,			/* waiting for H or = or & */
	URL_ST_QUOTE,			/*    "     " '"' or 'H' after = */
	URL_ST_QH,			/*    "     "  H after quote */
	URL_ST_T1,			/*    "     "  T */
	URL_ST_T2,			/*    "     "  T */
	URL_ST_P,			/*    "     "  P */
	URL_ST_S,			/*    "     "  S */
	URL_ST_COLON,			/*    "     "  : */
	URL_ST_SLASH1,			/*    "     "  / */
	URL_ST_SLASH2,			/*    "     "  / */
	URL_ST_SLASH3_START,
	URL_ST_SLASH3,			/*    "     "  third / */
	URL_ST_SKIPPING_URL,		/* skipping rest of URL */
    } st;
    char	*start;			/* start of hostname in fuz1 buffer */
    const char	*tld;			/* top level label in fuz1 buffer */
    const char	*sld;			/* 2nd level label */
    u_short	url_total;		/* length of current URL */
    u_short	dom_start;		/* current domain in doms_buf[] */
    u_short	dom_end;
    u_short	dot2;			/* penultimate '.' */
    u_short	dot1;			/* index of last '.'  in doms_buf[] */
    u_short	label_start;		/* start of current label */
    u_short	punct;			/* colon or other punctuation */
    u_char	doms;			/* hosts in doms_buf[] */
    u_char	flags;
#    define	 URL_TOO_LONG	0x01
#    define	 URL_SQUOTED    0x02	/* single quoted (') URL */
#    define	 URL_DQUOTED    0x04	/* double quoted (") URL */
#    define	 URL_QUOTED	(URL_SQUOTED | URL_DQUOTED)
#    define	 URL_IDN	0x08	/* seem to have UTF8 in name */
#    define	 URL_DOT	0x10	/* delayed working on '.' */
#    define	 URL_USERNAME	0x20	/* have seen user name */
    char	doms_buf[URL_HOST_MAX_SAVE*2];
} CK_URL;

typedef enum {
    URL_RES_FWD,
    URL_RES_CK_SPACE,
    URL_RES_SKIP
} URL_RES;

/* a template for generating a reply to an SMTP command */
typedef enum {
    REPLY_TPLT_NULL,
    REPLY_TPLT_ID,			/*  sendmail queue ID; fake for dccifd */
    REPLY_TPLT_CIP,			/* SMTP client IP address */
    REPLY_TPLT_BTYPE,			/* type of DNSBL hit */
    REPLY_TPLT_BTGT,			/* DNSBL hit IP address or name */
    REPLY_TPLT_BPROBE,			/* DNSBL probe domain name */
    REPLY_TPLT_BRESULT			/* DNSBL probe result */
} REPLY_TPLT_ARGS;
typedef struct {
    const char *log_result;		/* "reject" etc. for log */
#    define NUM_REPLY_TPLT_ARGS 6
    REPLY_TPLT_ARGS args[NUM_REPLY_TPLT_ARGS];
    char    rcode[sizeof("5yz")];
    char    xcode[sizeof("1.2.3")];
    u_char  is_pat;			/* template has %s references */
#    define  REPLY_BUF_LEN 256
    char    pat[REPLY_BUF_LEN];		/* pattern for SMTP message */
}  REPLY_TPLT;


typedef struct {			/* a DNS white- or blacklist domain */
    char    c[DCC_MAXDOMAINLEN];	/* null terminated */
} DNSBL_DOM;

/* type of DNS list hit */
typedef u_int32_t DNSBL_HIT;
#define DNSBL_HIT_DUP	    0x0001	/* list is a duplicate */
#define DNSBL_HIT_WHITE	    0x0002	/* whitelist */
#define	DNSBL_HIT_CLIENT    0x0004	/* check or hit client IP address */
#define	DNSBL_HIT_MHOST	    0x0008	/* check or hit env_from domain name */
#define	DNSBL_HIT_MHOST_MX  0x0010	/* involve MX for mail host */
#define	DNSBL_HIT_MHOST_NS  0x0020	/* involve NS for mail host */
#define	DNSBL_HIT_URL	    0x0040	/* check or hit URLs in message body */
#define	DNSBL_HIT_URL_MX    0x0080	/* involve MX for URL */
#define	DNSBL_HIT_URL_NS    0x0100	/* involve NS for URL */
#define DNSBL_HIT_TIMEO	    0x0200	/* timed out waiting for DNS */
# define DNSBL_HIT_SRCS	     (DNSBL_HIT_CLIENT | DNSBL_HIT_MHOST	    \
			      |	DNSBL_HIT_MHOST_MX | DNSBL_HIT_MHOST_NS	    \
			      | DNSBL_HIT_URL | DNSBL_HIT_URL_MX	    \
			      | DNSBL_HIT_URL_NS)

typedef enum DNSBL_TYPE {
    DNSBL_TYPE_IPV4,
    DNSBL_TYPE_IPV6,
    DNSBL_TYPE_NAME,
    DNSBL_TYPE_ALL_NAMES
} DNSBL_TYPE;

#define	NUM_DNSBL_GROUPS    4
typedef u_char DNSBL_GBITS;
#define DNSBL_GMASK  ((1U<<NUM_DNSBL_GROUPS)-1)
#define DNSBL_G2B(n) (1U<<(n))

#define DEF_DNSBL_BIT(n,b0)	((b0)*DNSBL_G2B(n))
#define	GET_DNSBL_BITS(w,b0)	(((w) / (b0)) & DNSBL_GMASK)
#define CHK_DNSBL_BITS(b0)	((b0) > 0x80000000/DNSBL_G2B(NUM_DNSBL_GROUPS))

typedef struct dnsbl {
    struct dnsbl *fwd;
    const struct dnsbl *dup_fwd;	/* shares DNS zone */
    u_char	gnum;			/* group # 0-indexed */
    DCC_IP_RANGE ip_range;		/* hit if DNS list matches this range */
    struct in6_addr ip_mask;		/*	after this mask */
    DCC_GETH	tgt_use_ipv46;		/* ipv4 vs. ipv6 result weighting */
    DNSBL_TYPE	type;			/* type of contents of list */
    int		num;
    int		dom_len;
    DNSBL_DOM	dom;
    const REPLY_TPLT *reply;
    DNSBL_HIT	tgt_hits;		/* desired hits */
} DNSBL;

/* how one group of lists was hit */
typedef struct {
    const char	*btype;			/* type of hit string */
    const DNSBL	*dnsbl;			/* hit DNS list */
    char	btype_buf[64];
    char	ip[DCC_SU2STR_SIZE];    /* IP address found in list */
    DNSBL_DOM	tgt;			/* IP address or name sought */
    DNSBL_DOM	probe;			/* what was actually looked up */
    DNSBL_HIT	hit;			/* type of hit found */
} DNSBL_HGROUP;

typedef struct {
    struct in6_addr addr;		/* IP address sought in list */
    DNSBL_DOM	dom;			/* and/or domain name */
} DNSBL_TGT;

/* working storage for all DNS lists */
typedef struct {
    DCC_CLNT_CTXT *dcc_ctxt;
    void	*log_ctxt;
    const char	*id;
    time_t	msg_us;			/* microseconds remaining for msg */
    struct timeval url_start;
    time_t	url_us;			/* microseconds to look up URL */
    time_t	url_us_used;
    DNSBL_TGT	tgt;
    struct {
	DNSBL_DOM   dom;
    } tgt_cache[8];
    int		tgt_cache_pos;
    DNSBL_HGROUP hgroups[NUM_DNSBL_GROUPS];
    DNSBL_HIT	tgt_hits;		/* types not yet hit */
} DNSBL_WORK;

extern DNSBL *dnsbls;
extern u_char have_dnsbl_groups;
extern u_char have_helpers;
extern DCC_PATH dnsbl_progpath;



/* accumulated checksums for an SMTP message */
typedef struct {
    const char *hdr_nm;			/* name if substitute checksum */
    DCC_TGTS	tgts;			/* server's answer or previous total */
    DCC_CK_TYPE_B type;
    u_char	rpt2srvr;		/* 1=report to server */
    DCC_SUM	sum;
} GOT_SUM;
#define CLR_GOT_SUM(g) ((g)->hdr_nm = 0, (g)->tgts = DCC_TGTS_INVALID,	\
			(g)->type = DCC_CK_INVALID, (g)->rpt2srvr = 0)

typedef struct {
    u_int	total;			/* bytes */
    char	*cp;			/* end of bytes to sum in buf */
    char	*eol;			/* most recent eol */
#    define	 FUZ1_MAX_LINE	78
#    define	 FUZ1_BUF_MAX	(FUZ1_MAX_LINE*4) /* >DCC_MAXDOMAINLEN */
#    define	 HTTPS_STR	"https"
#    define	 HTTPS_LEN	LITZ(HTTPS_STR)
    char	buf[FUZ1_BUF_MAX+HTTPS_LEN];
    MD5_CTX	md5;
} CTX_FUZ1;


#define FUZ2_LANG_NUM (DCC_LANG_ENGLISH+DCC_LANG_SPANISH		\
		       +DCC_LANG_POLISH+DCC_LANG_DUTCH)
typedef struct {
    const char **words;
    u_int	len;
    const u_char *cset;
} FUZ2_TBL;
extern FUZ2_TBL fuz2_tbls[FUZ2_LANG_NUM];

typedef struct {			/* per-language counts */
    u_int	wsummed;		/* bytes of words summed */
    u_int	wtotal;			/* words summed */
#    define	 FUZ2_FEW_WORDS	100
#    define	 FUZ2_MIN_WORDS	8
    MD5_CTX	md5;
} FUZ2_LANG;

typedef struct {
    u_int	btotal;			/* total non-whitespace bytes seen */
    u_int	xsummed;		/* non-word bytes checksummed */
    u_int	wlen;			/* length of current word */
    u_int	tag_len;		/* HTML tag length */
    CK_CREF	cref;
    CK_WORD	w;
    CK_WORD	tag;
    enum {
	FUZ2_ST_WORD = 0,		/* gathering word */
	FUZ2_ST_START_TAG,		/* gathering start of HTML tag */
	FUZ2_ST_SKIP_TAG,		/* skipping HTML tag */
	FUZ2_ST_SKIP_COMMENT		/* skipping HTML comment */
    } st;
    FUZ2_LANG	lang[FUZ2_LANG_NUM];
} CTX_FUZ2;

/* The maximum length of a checksumed HELO value and the continuation string
 * need to be the same for all users of the local white-/blacklist */
#define HELO_MAX	(DCC_MAXDOMAINLEN+8)
#define	HELO_CONT	"..."

/* local-part maximum in RFC 2821 */
#define LOCAL_PART_MAX  64
#define ENV_FROM_MAX    (LOCAL_PART_MAX+DCC_MAXDOMAINLEN)

#define MSG_ID_LEN	24

/* do not checksum more than this much of a header line */
#define HDR_CK_MAX	1024

/* substitute or locally configured checksums */
#define MAX_SUB_CKS	8

#define DCC_WSUMS (DCC_DIM_CKS+MAX_SUB_CKS) /* max whitelist checksums */
typedef struct {
    GOT_SUM	sums[DCC_WSUMS];
    struct in6_addr ip_addr;		/* SMTP client IP address */
    struct {				/*  quoted-printable state machine */
	int	    x;
	int	    y;
	u_char	    n;
	enum {
	    CK_QP_IDLE,			/* waiting for '=' */
	    CK_QP_EQ,			/* seen "=" */
	    CK_QP_1,			/* seen "=X" of "=XY" */
	    CK_QP_FAIL1,		/* have output '=' after bad =X */
	    CK_QP_FAIL2,		/* have output '=' after bad =XY */
	    CK_QP_FAIL3			/* have output 'X' after bad =XY */
	} state;
    } qp;
    struct {				/* base64 state machine */
	u_int32_t   quantum;
	int	    quantum_cnt;
    } b64;
    enum {
	CK_MP_ST_PREAMBLE,		/* preamble before first boundary */
	CK_MP_ST_BND,			/* MIME boundary */
	CK_MP_ST_HDRS,			/* headers after a boundary */
	CK_MP_ST_TEXT,			/* body or entity */
	CK_MP_ST_EPILOGUE		/* text after last boundary */
    } mp_st;
    enum CK_MHDR_ST {			/* parse entity fields */
	CK_MHDR_ST_IDLE,
	CK_MHDR_ST_CE_CT,		/* matching "Content-T" */
	CK_MHDR_ST_CE,			/*	"ransfer-Encoding:" */
	CK_MHDR_ST_CE_WS,		/* white space after "encoding:" */
	CK_MHDR_ST_CT,			/*	"ype:" */
	CK_MHDR_ST_CT_WS,		/* white space after "type:" */
	CK_MHDR_ST_QP,			/*	"quoted-printable" */
	CK_MHDR_ST_B64,			/*	"base64" */
	CK_MHDR_ST_TEXT,		/*	"text" */
	CK_MHDR_ST_HTML,		/*	"/html" */
	CK_MHDR_ST_CSET_SKIP_PARAM,	/*	skip to ";" after "text" */
	CK_MHDR_ST_CSET_SPAN_WS,	/*	skip blanks before "charset" */
	CK_MHDR_ST_CSET,		/* match "charset=" */
	CK_MHDR_ST_CSET_ISO_8859,	/*	"ISO-8859-" */
	CK_MHDR_ST_CSET_ISO_X,		/* find the 8859 type number */
	CK_MHDR_ST_MULTIPART,		/* match "multipart" */
	CK_MHDR_ST_BND_SKIP_PARAM,	/* skip "/alternative;" or similar */
	CK_MHDR_ST_BND_SPAN_WS,		/* skip whitespace before "boundary" */
	CK_MHDR_ST_BND,			/* match "boundary=" */
	CK_MHDR_ST_BND_VALUE		/* collecting boundary */
    } mhdr_st;
    u_char	mhdr_pos;
    u_char	mime_nest;		/* # of nested MIME entities */
    u_char	mime_bnd_matches;	/* # of active boundary matches */
    CK_BND	mime_bnd[3];
    enum {
	CK_CT_TEXT = 0,
	CK_CT_HTML,
	CK_CT_BINARY
    } mime_ct;
    const u_char *mime_cset;
    enum {
	DCC_CK_CE_ASCII = 0,
	DCC_CK_CE_QP,
	DCC_CK_CE_B64
    } mime_ce;
    struct {
	u_int	    total;		/* non-whitespace text */
	u_char	    flen;		/* bytes of ">From" seen */
	MD5_CTX	    md5;
    } ctx_body;
    CK_URL	url;
    CTX_FUZ1	fuz1;
    CTX_FUZ2	fuz2;
    DNSBL_WORK	*dlw;			/* pointer to malloc()'ed state */
    CKSUM_THOLDS tholds_rej;
    u_char	flags;
#    define	 CKS_MIME_BOL	    0x01    /* header decoder is at BOL */
#    define	 CKS_MIME_QUOTED    0x02    /* quoted boundary */
} GOT_CKS;

typedef struct {
    DCC_TGTS v[DCC_WSUMS];
} CKS_WTGTS;


/* sscanf() a checksum */
#define DCC_CKSUM_HEX_PAT	"%8x %8x %8x %8x"


/* whiteclnt files */

#define WHITE_SUFFIX	    ".dccw"
#define WHITE_NEW_SUFFIX    ".dccx"	/* hash table under construction */

typedef char WHITE_MAGIC[128];
#define WHITE_MAGIC_B_STR "DCC client whitelist hash table version "
#define WHITE_MAGIC_V_STR "27"

typedef struct {
    DCC_IP_RANGE range;
    DCC_TGTS	tgts;
    u_int	len;
    u_short	lno;
    u_char	fno;
} WHITE_IP_RANGE;

typedef struct {
    u_char	len;
#    define	 WHITE_IP_RANGES_MAX 64	/* fix dcc.man if this changes */
    WHITE_IP_RANGE rs[WHITE_IP_RANGES_MAX];
} WHITE_IP_RANGES;

typedef u_int WHITE_INX;		/* 1-based index into hash table */

typedef struct {
    WHITE_INX	fwd;
    DCC_TGTS	tgts;
    u_short	lno;
    u_char	fno;
    DCC_CK_TYPE_B type;
    DCC_SUM	sum;
} WHITE_ENTRY;

#ifdef DCC_WIN32
#define WHITE_TBL_BINS 521		/* should be prime */
#else
#define WHITE_TBL_BINS 8209		/* should be prime */
#endif
typedef u_int32_t WHITE_FGS;
typedef u_int32_t WHITE_SWS;
typedef struct {
    WHITE_MAGIC magic;			/* WHITE_MAGIC_* in ckwhite.c */
    struct {
	WHITE_INX	entries;	/* # of entries in the file */
	WHITE_FGS	fgs;
#	 define	 WHITE_FG_PER_USER	0x00000001
#	 define	 WHITE_FG_HAVE_THOLDS	0x00000002  /* have some */
#	 define	 WHITE_FG_HOSTNAMES	0x00000004  /* have some */
	WHITE_SWS	sws;
#	 define	 WHITE_SW_GREY_ON	0x00000001
#	 define	 WHITE_SW_GREY_OFF	0x00000002
#	 define  WHITE_SW_GREY_SPAM_ON  0x00000004
#	 define  WHITE_SW_GREY_SPAM_OFF 0x00000008
#	 define	 WHITE_SW_GREY_LOG_ON   0x00000010
#	 define	 WHITE_SW_GREY_LOG_OFF  0x00000020
#	 define	 WHITE_SW_LOG_ALL	0x00000040
#	 define	 WHITE_SW_LOG_NORMAL    0x00000080
#	 define	 WHITE_SW_DISCARD_OK    0x00000100
#	 define	 WHITE_SW_DISCARD_NO    0x00000200
#	 define	 WHITE_SW_DCC_ON	0x00000400
#	 define	 WHITE_SW_DCC_OFF	0x00000800
#	 define	 WHITE_SW_REP_ON	0x00001000
#	 define	 WHITE_SW_REP_OFF	0x00002000
#	 define	 WHITE_SW_MTA_FIRST	0x00004000
#	 define	 WHITE_SW_MTA_LAST	0x00008000
#	 define	 WHITE_SW_LOG_D		0x00010000
#	 define	 WHITE_SW_LOG_H		0x00020000
#	 define	 WHITE_SW_LOG_M		0x00040000
#	 define	 WHITE_SW_TRAP_NOT	0x00080000  /* not a spam trap */
#	 define	 WHITE_SW_TRAP_DIS	0x00100000  /* discard spam trap */
#	 define	 WHITE_SW_TRAP_REJ	0x00200000  /* reject spam trap */
#	  define  WHITE_SW_TRAPS	(WHITE_SW_TRAP_DIS | WHITE_SW_TRAP_REJ)
#	 define  WHITE_SW_DNSBL_ON(n)	DEF_DNSBL_BIT(n, 0x00400000)
#	 define  WHITE_SW_DNSBL_ON_M	(WHITE_SW_DNSBL_ON(0) * DNSBL_GMASK)
#	 define	 WHITE_SW_DNSBL_OFF(n)	DEF_DNSBL_BIT(n,		    \
					    WHITE_SW_DNSBL_ON(NUM_DNSBL_GROUPS))
#	  if CHK_DNSBL_BITS(WHITE_SW_DNSBL_OFF(0))
#	    error "too many WHITE_SW bits"
#	  endif
	/* enough switches to make file not empty */
#	 define	 WHITE_SET(f,s) (0 != ((f) & WHITE_FG_HAVE_THOLDS) || (s) != 0)

	time_t	reparse;		/* re-parse after this */
	time_t	broken;			/* serious broken until then */
	time_t	ascii_mtime;		/* ASCII file mtime at last parsing */
	struct {			/* included files */
	    time_t	mtime;
	    DCC_PATH	nm;
	} white_incs[8];

	CKSUM_THOLDS tholds_rej;

	DCC_SUM	    ck_sum;		/* checksum of following contents */
	WHITE_IP_RANGES ranges;
    } hdr;
    WHITE_INX bins[WHITE_TBL_BINS];	/* 1-based indeces or 0 for empty */
    WHITE_ENTRY tbl[1];
} WHITE_TBL;


/* a ASCII whiteclnt file (including the files it includes) can be
 *	OK
 *	unreadable or otherwise badly broken
 *	missing
 *	    if permanent, the hash table should be removed, but
 *	    it might be temporary as an editor changes it
 * a hash table can be
 *	OK
 *	out of date compared to the ASCII file(s)
 *	badly broken but not removable (e.g. bad directory permissions).
 *
 * Do not stat() the files iand so do not complain on every message by
 *	using wf->next_stat_time
 * Avoid generating a complaint on every error message using wf->broken
 * Reparse ASCII files with errors using wf->reparse or when their mtimes
 *	change, but not more often than we use stat() to check mtimes..
 * Reparse the main ASCII file if it contains host names by noticing the
 *	WHITE_FG_HOSTNAMES bit and that the mtime of the hash table is
 *	more than DCC_WHITECLNT_RESOLVE seconds old
 */
#define WHITE_REPARSE_DELAY	(30*60)	/* look for new DNS values */
#define WHITE_BROKEN_DELAY	(5*60)	/* do not complain more often */
#define WHITE_STAT_DELAY	10	/* don't stat() more often */

/* computed from WHITE_FGS */
typedef u_int32_t FLTR_SWS;
#define	FLTR_SW_SET		0x00000001
#define FLTR_SW_DISCARD_NO	0x00000002  /* always reject spam */
#define	FLTR_SW_DCC_OFF		0x00000004  /* no DCC check */
#define	FLTR_SW_REP_ON		0x00000008  /* honor DCC reputation */
#define	FLTR_SW_LOG_ALL		0x00000010
#define	FLTR_SW_GREY_OFF	0x00000020  /* greylisting off */
#define FLTR_SW_GREY_IGN_SPAM	0x00000040  /* greylist even spam */
#define	FLTR_SW_GREY_LOG_OFF	0x00000080  /* log greylist embargos */
#define FLTR_SW_LOG_D		0x00000100
#define FLTR_SW_LOG_H		0x00000200
#define FLTR_SW_LOG_M		0x00000400
#define	FLTR_SW_MTA_FIRST	0x00000800  /* MTA IS/NOTSPAM checked first */
#define FLTR_SW_TRAP		0x00001000  /* either type of trap */
#define	FLTR_SW_TRAP_DIS	0x00002000  /* discarding spam trap */
#define	FLTR_SW_TRAP_REJ	0x00004000  /* rejecting spam trap */
#define	FLTR_SW_DNSBL(n)	DEF_DNSBL_BIT(n,0x00008000)
# define FLTR_SW_DNSBL_M	(FLTR_SW_DNSBL(0) * DNSBL_GMASK)
# define FLTR_SW_DNSBL_BITS(sws) GET_DNSBL_BITS(sws,FLTR_SW_DNSBL(0))
#if CHK_DNSBL_BITS(FLTR_SW_DNSBL(0))
# error "too many FILTR_SW bits"
#endif

/* get potentially conflicting bits */
#define FLTR_SWS_CONFLICT(sws) ((sws) & (FLTR_SW_DCC_OFF		\
					 | FLTR_SW_GREY_OFF		\
					 | FLTR_SW_MTA_FIRST		\
					 | FLTR_SW_REP_ON		\
					 | FLTR_SW_DNSBL_M		\
					 | FLTR_SW_TRAP_DIS		\
					 | FLTR_SW_TRAP_REJ		\
					 | FLTR_SW_TRAP))


/* everything there is to know about a currently active whitelist file */
typedef struct {
    WHITE_TBL	*wtbl;
    int		ht_fd;			/* hash table file */
    struct stat ht_sb;
    WHITE_FGS	wtbl_fgs;
    WHITE_SWS	wtbl_sws;
    u_int	wtbl_entries;		/* # of entries mapped window */
    u_int	wtbl_size;		/* bytes in mapped window */
    time_t	next_stat_time;
    time_t	reparse;		/* when to re-parse file */
    time_t	broken;			/* something very sick until then */
#ifdef DCC_WIN32
    HANDLE	ht_map;			/* WIN32 hash table map handle */
#endif
    u_int	ascii_nm_len;
    DCC_PATH	ascii_nm;
    DCC_PATH	ht_nm;
    int		fno, lno;		/* currently being parsed */
    u_char	wf_flags;
#    define	 WF_PER_USER    0x01    /* hostnames not allowed */
#    define	 WF_NOFILE	0x02    /* no whiteclnt file */
#    define	 WF_EITHER	0x04    /* either global or per-user ok */
#    define	 WF_RO		0x08	/* read only access */
#    define	 WF_WLIST	0x10    /* wlist command */
#    define	 WF_WLIST_RO    0x20    /* read-only wlist command */
#    define	 WF_WLIST_RW    0x40    /* read/write wlist command */
    u_char	closed;
    u_char	need_reopen;		/* lock-safe change flag */
} WF;

extern WF cmn_wf, cmn_tmp_wf;

typedef enum {				/* greylist result */
    ASK_GREY_FAIL,			/* greylist server or other failure */
    ASK_GREY_OFF,			/* client whitelist or blacklist */
    ASK_GREY_EMBARGO,
    ASK_GREY_EMBARGO_END,		/* first time server says ok */
    ASK_GREY_PASS,			/* greylist server says ok */
    ASK_GREY_WHITE,			/* greylist server says whitelisted */
    ASK_GREY_SPAM			/* reported as spam to server */
} ASK_GREY_RESULT;

extern u_char grey_on;

extern u_int ck_qp_decode(GOT_CKS *, const char **, u_int *, char *, u_int);
extern u_int ck_b64_decode(GOT_CKS *, const char **, u_int *, char *, u_int);

extern char lookup_cref(CK_WORD *, u_int);

extern int ck_cref(CK_CREF *, u_char);
extern void dcc_ck_fuz1_init(GOT_CKS *);
extern void dcc_ck_fuz1(GOT_CKS *, const char *, u_int);
extern void dcc_ck_fuz1_fin(GOT_CKS *);

extern void dcc_ck_fuz2_init(GOT_CKS *);
extern void dcc_ck_fuz2(GOT_CKS *, const char *, u_int);
extern void dcc_ck_fuz2_fin(GOT_CKS *);


extern void wf_init(WF *, u_int);
extern void wf_lock(WF *);
extern void wf_unlock(WF *);

extern void str2ck(DCC_SUM *, const char *, u_int, const char *);
extern u_char get_cks(GOT_CKS *, DCC_CK_TYPES, const char *, u_char);
extern u_char ck_get_sub(GOT_CKS *, const char *, const char *);
extern u_char dcc_add_sub_hdr(DCC_EMSG *, const char *);
extern void ipv6tock(DCC_SUM *, const struct in6_addr *);
extern void get_ipv6_ck(GOT_CKS *, const struct in6_addr *);
extern void no_ip_rpt2srvr(GOT_CKS *);
extern void unget_body_ck(GOT_CKS *);
extern void su2cks(GOT_CKS *, const DCC_SOCKU *);
extern const char *parse_received(const char *, GOT_CKS *,
				  char *, int, char *, int, char *, int);
extern u_char parse_return_path(const char *,  char *, int);
extern u_char parse_unix_from(const char *, char *, int);
extern u_char parse_mail_host(const char *, char *, int);

extern void print_cks(LOG_WRITE_FNC, void *, u_char, DCC_TGTS,
		      const GOT_CKS *, const CKSUM_THOLDS *,
		      const CKS_WTGTS *);
#define PRINT_CK_TYPE_LEN	25
#define PRINT_CK_SUM_LEN	35
#define PRINT_CK_PAT_CK		"%25s: %-35s"
#define PRINT_CK_PAT_LIM_CK	"%25.*s%c %-35.*s"
#define PRINT_CK_PAT_SRVR	" %7s"
#define PRINT_CK_PAT_SRVR_LEN   8
#define PRINT_CK_PAT_WLIST	" %5s"
#define PRINT_CK_PAT_WLIST_LEN	6
#define PRINT_CK_PAT_THOLD	PRINT_CK_PAT_WLIST

extern void cks_init(GOT_CKS *);
extern void ck_mime_hdr(GOT_CKS *, const char *, const char *);
extern u_char parse_mime_hdr(GOT_CKS *, const char *, u_int, u_char);
extern void ck_body(GOT_CKS *, const void *, u_int);
extern void cks_fin(GOT_CKS *);

extern u_char dcc_get_white(DCC_EMSG *, WHITE_INX);

typedef int (*DCC_PARSED_CK_FNC)(DCC_EMSG *, WF *,
				DCC_CK_TYPES,	/* type of checksum */
				DCC_SUM *,  /* computed checksum */
				DCC_TGTS);  /* "OK2" etc */
typedef int (*DCC_PARSED_CK_RANGE_FNC)(DCC_EMSG *, WF *,
				       const DCC_IP_RANGE *, DCC_TGTS);
extern int dcc_parse_ck(DCC_EMSG *, WF *wf,
			const char *, DCC_CK_TYPES, const char *, DCC_TGTS,
			DCC_PARSED_CK_FNC, DCC_PARSED_CK_RANGE_FNC);
extern int dcc_parse_hex_ck(DCC_EMSG *, WF *wf,
			    const char *, DCC_CK_TYPES, const char *, DCC_TGTS,
			    DCC_PARSED_CK_FNC);
extern const char *wf_fnm(const WF *, int);
extern const char *wf_fnm_lno(DCC_FNM_LNO_BUF *, const WF *);
extern DCC_TGTS dcc_str2thold(DCC_CK_TYPES, const char *);
extern int parse_whitefile(DCC_EMSG *, WF *, int,
			   DCC_PARSED_CK_FNC, DCC_PARSED_CK_RANGE_FNC);

typedef enum {
    WHITE_USE_DCC,
    WHITE_LISTED,
    WHITE_UNLISTED,
    WHITE_BLACK
} WHITE_LISTING;

typedef enum {
    WHITE_OK,
    WHITE_NOFILE,			/* no ASCII file */
    WHITE_CONTINUE,			/* modest error or bad host name */
    WHITE_COMPLAIN,			/* bad hash table */
    WHITE_SILENT			/* no more complaints */
} WHITE_RESULT;
#define WHITE_RESULT_FAILURE WHITE_UNLISTED

extern u_char dcc_new_white_nm(DCC_EMSG *, WF *, const char *);
extern u_char new_ht_nm(DCC_EMSG *, WF *, u_char);
extern int unlink_white_ht(DCC_EMSG *, WF *, time_t);
extern WHITE_RESULT wf_rdy(DCC_EMSG *, WF *, WF *);
extern WHITE_RESULT wf_cks(DCC_EMSG *, WF *, GOT_CKS *,
			   CKS_WTGTS *, WHITE_LISTING *);
extern WHITE_RESULT wf_sum(DCC_EMSG *, WF *, DCC_CK_TYPES, const DCC_SUM *,
			   DCC_TGTS *, WHITE_LISTING *);
extern u_char white_mx(DCC_EMSG *, DCC_TGTS *, const GOT_CKS *);


typedef u_int32_t ASK_ST;
#define ASK_ST_INVALID_MSG	0x00000001  /* incomplete SMTP transaction */
#define	ASK_ST_QUERY		0x00000002  /* ask but do not report */
#define	ASK_ST_QUERY_GREY	0x00000004
#define	ASK_ST_GREY_OFF		0x00000008
#define	ASK_ST_SRVR_OK2		0x00000010  /* have honored DCC_TGTS_OK2 */
#define	ASK_ST_SRVR_NOTSPAM	0x00000020  /* not spam by DCC server */
#define	ASK_ST_SRVR_ISSPAM	0x00000040  /* spam by DCC server & threshold */
#define ASK_ST_REP_ISSPAM	0x00000080  /* spam by reputation & threshold */
#define	ASK_ST_MTA_NOTSPAM	0x00000100  /* MTA says it is not spam */
#define	ASK_ST_MTA_ISSPAM	0x00000200  /* MTA says it is spam */
#define	ASK_ST_WLIST_NOTSPAM	0x00000400  /* locally whitelisted message */
#define	ASK_ST_WLIST_ISSPAM	0x00000800  /* locally blacklisted message */
#define	ASK_ST_CLNT_ISSPAM	0x00001000  /* report to DCC server as spam */
#define	ASK_ST_GREY_EMBARGO	0x00002000  /* embargo this message */
#define	ASK_ST_GREY_LOGIT	0x00004000  /* greylist logging indicated */
#define	ASK_ST_LOGIT		0x00008000  /* log message for all recipients */
#define ASK_ST_RPT_SPAM		0x00010000  /* reported as spam to server */
#define	ASK_ST_DNSBL_B(n)	DEF_DNSBL_BIT(n,0x00020000)
# define ASK_ST_DNSBL_B_BITS(st) GET_DNSBL_BITS(st, ASK_ST_DNSBL_B(0))
#define	ASK_ST_DNSBL_W(n)	DEF_DNSBL_BIT(n,ASK_ST_DNSBL_B(NUM_DNSBL_GROUPS))
# define ASK_ST_DNSBL_W_BITS(st) GET_DNSBL_BITS(st, ASK_ST_DNSBL_W(0))
#define	ASK_ST_DNSBL_TIMEO(n)	DEF_DNSBL_BIT(n,ASK_ST_DNSBL_W(NUM_DNSBL_GROUPS))
# define ASK_ST_DNSBL_TIMEO_BITS(st) GET_DNSBL_BITS(st, ASK_ST_DNSBL_TIMEO)
#if CHK_DNSBL_BITS(ASK_ST_DNSBL_TIMEO(0))
# error "too many ASK_ST bits"
#endif


extern u_char dcc_ck_grey_answer(DCC_EMSG *, const DCC_OP_RESP *);
extern int ask_dcc(DCC_EMSG *, DCC_CLNT_CTXT *, u_char,
		   DCC_HEADER_BUF *, GOT_CKS *, ASK_ST *, u_char,
		   u_char, DCC_TGTS, DCC_TGTS);
extern u_char unthr_ask_white(DCC_EMSG *, ASK_ST *, FLTR_SWS *, const char *,
			      GOT_CKS *, CKS_WTGTS *);
extern u_char unthr_ask_dcc(DCC_EMSG *, DCC_CLNT_CTXT *, DCC_HEADER_BUF *,
			    ASK_ST *, FLTR_SWS, GOT_CKS *, u_char, DCC_TGTS);
extern void dcc_clear_tholds(void);
extern u_char merge_tholds(CKSUM_THOLDS *,
			   const CKSUM_THOLDS *, const WHITE_TBL *);
extern void dcc_parse_honor(const char *);
extern u_char dcc_parse_tholds(const char *, const char *);
extern void dcc_honor_log_cnts(ASK_ST *, const GOT_CKS *, DCC_TGTS);
extern FLTR_SWS wf2sws(FLTR_SWS, const WF *);
extern void log_ask_st(LOG_WRITE_FNC, void *, ASK_ST, FLTR_SWS, FLTR_SWS,
		       u_char, const DCC_HEADER_BUF *);
extern u_char dcc_parse_client_grey(const char *);
extern ASK_GREY_RESULT ask_grey(DCC_EMSG *, DCC_CLNT_CTXT *, DCC_OPS,
				DCC_SUM *, DCC_SUM *,
				const GOT_CKS *, const DCC_SUM *,
				DCC_TGTS *, DCC_TGTS *, DCC_TGTS *);

extern u_char dcc_parse_dnsbl(DCC_EMSG *, const char *, const char *);
extern const REPLY_TPLT *dnsbl_parse_reply(const char *);
extern void helper_save_arg(const char *, const char *);
extern void helper_init(int);
extern void dcc_dnsbl_init(GOT_CKS *, DCC_CLNT_CTXT *, void *, const char *);
extern void url_dnsbl(DNSBL_WORK *, const char *);
extern void dcc_mail_host_dnsbl(DNSBL_WORK *, const char *);
extern void dcc_client_dnsbl(DNSBL_WORK *,
			     const struct in6_addr *, const char *);
extern void dcc_dnsbl_result(ASK_ST *, DNSBL_WORK *);
extern int DCC_PF(3,4) thr_log_print(void *, u_char, const char *, ...);
extern int DCC_PF(2,3) thr_error_msg(void *, const char *, ...);
extern void DCC_PF(2,3) thr_trace_msg(void *, const char *, ...);

#endif /* DCC_CK_H */
