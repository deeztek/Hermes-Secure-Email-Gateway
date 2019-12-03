/* Distributed Checksum Clearinghouse
 *
 * database definitions
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
 * Rhyolite Software DCC 2.3.167-1.162 $Revision$
 */

#ifndef DB_H
#define DB_H

#include "srvr_defs.h"
#include <math.h>

extern u_char grey_on;
extern u_char ssd_mode;			/* 1=ultra fast disk */

#define DB_DCC_NAME	"dcc_db"
#define DB_GREY_NAME	"grey_db"
#define DB_HASH_SUFFIX	".hash"
#define DB_LOCK_SUFFIX	".lock"

#define WHITELIST_NM(g) ((g) ? "grey_whitelist" : "whitelist")

#define DB_VERSION3_STR "DCC checksum database version 3"
#define DB_VERSION4_STR "DCC checksum database version 4"
#define DB_VERSION5_STR "DCC checksum database version 5"
#define DB_VERSION6_STR "DCC checksum database version 6"
#define DB_VERSION_STR	DB_VERSION6_STR

#define HASH_MAGIC_STR	 "DCC hash 8"


#define DB_CP3(x,v) do {u_int32_t _v = v; (x)[0] = _v>>16;		\
    (x)[1] = _v>>8; (x)[2] = _v;} while (0)
#define DB_CP4(x,v) do {u_int32_t _v = v; (x)[0] = _v>>24;		\
    (x)[1] = _v>>16; (x)[2] = _v>>8; (x)[3] = _v;} while (0)
#define DB_EX3(x) ((((u_int32_t)(x)[0])<<16) + ((x)[1]<<8) + (x)[2])
#define DB_EX4(x) ((((u_int32_t)(x)[0])<<24) + (((u_int32_t)(x)[1])<<16) \
		   + ((x)[2]<<8) + (x)[3])
/* the least significant byte should be tested first */
#define DB_ZERO3(x) ((x)[2] == 0 && (x)[1] == 0 && (x)[0] == 0)
#define DB_ZERO4(x) ((x)[3] == 0 && (x)[2] == 0 && (x)[1] == 0 && (x)[0] == 0)


/* a single checksum in a database record */
typedef u_char	    DB_TGTS[3];		/* a compressed count */
typedef u_int64_t   DB_PTR;		/* database record offset */
typedef u_int32_t   DB_PTR_C;		/*	compressed by DB_PTR_CP() */
typedef struct {
    DB_PTR_C	prev;			/* previous record for this checksum */
    DB_TGTS	tgts;			/* accumulated reported targets */
    DCC_CK_TYPE_B type_fgs;
#    define	 DB_CK_FG_JUNK	0x80
#     define	  DB_CK_JUNK(ck) ((ck)->type_fgs & DB_CK_FG_JUNK)
#    define	 DB_CK_FG_OSPAM 0x40	/* obsolete report of spam */
#     define	  DB_CK_OSPAM(ck) ((ck)->type_fgs & DB_CK_FG_OSPAM)
#    define	 DB_CK_MASK	0x0f
#    define	 DB_CK_TYPE(ck) ((DCC_CK_TYPES)((ck)->type_fgs & DB_CK_MASK))
    DCC_SUM	sum;
} DB_RCD_CK;
#define DB_TGTS_CK_SET(ck,v) DB_CP3((ck)->tgts,v)
#define DB_TGTS_CK(ck) DB_EX3((ck)->tgts)

/* shape of a checksum database entry */
typedef struct {
    DCC_TS	ts;			/* original server's creation date */
    DCC_SRVR_ID srvr_id;		/* initial server */
#    define	 DB_RCD_ID(r)	((r)->srvr_id)
    DB_TGTS	tgts_del;		/* # target addresses or delete flag */
    u_char	fgs_num_cks;		/* # of cksums | flags */
#    define	 DB_RCD_FG_TRIM	    0x80    /* some checksums deleted */
#     define	  DB_RCD_TRIMMED(r)  ((r)->fgs_num_cks & DB_RCD_FG_TRIM)
#    define	 DB_RCD_FG_SUMRY    0x40    /* fake summary record */
#     define	  DB_RCD_SUMRY(r)   ((r)->fgs_num_cks & DB_RCD_FG_SUMRY)
#    define	 DB_RCD_FG_DELAY    0x20    /* delayed for fake summary */
#     define	  DB_RCD_DELAY(r)   ((r)->fgs_num_cks & DB_RCD_FG_DELAY)
/* # define	 DB_RCD_FG_	    0x10       unused */
#    define	 DB_RCD_FG_MASK	    0x0f    /* depends on DCC_MAX_FLOD_PATHS */
#    define	 DB_NUM_CKS(r)	    ((r)->fgs_num_cks & DB_RCD_FG_MASK)
    DB_RCD_CK	cks[DCC_DIM_CKS];
} DB_RCD;

#define DB_RCD_HDR_LEN (ISZ(DB_RCD) - ISZ(DB_RCD_CK)*DCC_DIM_CKS)
#define DB_RCD_LEN(r) (DB_RCD_HDR_LEN + DB_NUM_CKS(r) * ISZ(DB_RCD_CK))
#define DB_RCD_LEN_MAX sizeof(DB_RCD)

#define DB_TGTS_RCD_SET(r,v) DB_CP3((r)->tgts_del,v)
#define DB_TGTS_RCD_RAW(r) DB_EX3((r)->tgts_del)

#define DB_COOK_TGTS(raw) ((raw) == DCC_TGTS_DEL ? 0 : (raw))
#ifdef HAVE_GCC_INLINE			/* no prototypes without inline */
static inline DCC_TGTS
DB_TGTS_RCD(const DB_RCD *rcd) {return DB_COOK_TGTS(DB_TGTS_RCD_RAW(rcd));}
#else
#define DB_TGTS_RCD(rcd) DB_COOK_TGTS(DB_TGTS_RCD_RAW(rcd))
#endif

/* this allows databases of up to 48 GBytes */
#define DB_PTR_MULT	    ((DB_PTR)12)    /* gcd of all sizes of DB_RCD */
#define DB_PTR_CP(v)	    ((u_int32_t)((v) / DB_PTR_MULT))
#define DB_PTR_EX(x)	    ((x) * DB_PTR_MULT)

/* The kludge to speed conversion of database addresses to block numbers
 * and offsets on 32-bit systems */
#define DB_PTR_SHIFT 8
#ifdef HAVE_64BIT_LONG
#define DB_PTR2BLK_NUM(bn,s) ((bn) / (s))
#else
#define DB_PTR2BLK_NUM(bn,s) ((u_int32_t)((bn) >> DB_PTR_SHIFT)		\
			      / (s >> DB_PTR_SHIFT))
#endif

#define DB_PTR_NULL	    ((DB_PTR)0)
#define DB_PTR_BASE	    ISZ(DB_HDR)
#define DB_PTR_MAX	    DB_PTR_EX((((DB_PTR)1)<<(sizeof(DB_PTR_C)*8))-2)
#define DB_PTR_BAD	    DB_PTR_EX((((DB_PTR)1)<<(sizeof(DB_PTR_C)*8))-1)
#define DB_PTR_IS_BAD(l,c)  ((l) < DB_PTR_BASE || (l) >= (c))


typedef DCC_TS DB_SN;			/* database serial number */

#define FLOD_STALE_SECS		    (24*60*60)
/* non-spam expiration */
#define DB_EXPIRE_SECS_DEF	    (24*60*60)
#define DB_EXPIRE_SECS_MAX	    DCC_MAX_SECS
#define DB_EXPIRE_SECS_MIN	    (60*60)
#define DB_EXPIRE_SECS_DEF_MIN	    (2*60*60)
/* spam expiration */
#define DB_EXPIRE_SPAMSECS_DEF	    (30*24*60*60)
#define DB_EXPIRE_SPAMSECS_DEF_MIN  (1*24*60*60)
/* reputations need consistent expirations */
#define DB_EXPIRE_REP_SECS_DEF	    (24*60*60)
#define DB_EXPIRE_REP_SPAMSECS_DEF  (30*24*60*60)
/* so do server-IDs */
#define DB_EXPIRE_SERVER_ID	    (30*24*60*60)

/* re-announce spam this often */
#define DCC_OLD_SPAM_SECS   (DB_EXPIRE_SPAMSECS_DEF_MIN/2)


/* seconds to greylist or delay new mail messages
 *  RFC 2821 says SMTP clients should wait at least 30 minutes to retry,
 *  but 15 minutes seems more common than 30 minutes.  Many retry after
 *  only 5 minutes, and some after only 1 (one!) second.  However,
 *  many of those that retry after a few seconds keep trying for a minute
 *  or two. */
#define DEF_GREY_EMBARGO    270
#define MAX_GREY_EMBARGO    (24*60*60)

#define DEF_GREY_WINDOW	    (7*24*60*60)    /* wait as long as this */
#define MAX_GREY_WINDOW	    (10*24*60*60)
#define DEF_GREY_WHITE	    (63*24*60*60)   /* remember this long */
#define MAX_GREY_WHITE	    DB_EXPIRE_SECS_MAX


typedef DCC_TS	DB_EX_TS[DCC_DIM_CKS];
typedef struct {
    int32_t	all;			/* allsecs */
    int32_t	spam;			/* spamsecs */
} DB_EX_SEC;
typedef DB_EX_SEC DB_EX_SECS[DCC_DIM_CKS];

#define DCC_CK_OK_GREY_CLNT(t) ((t) > DCC_CK_INVALID			    \
				&& t <= DCC_CK_G_TRIPLE_R_BULK)
#define DCC_CK_OK_GREY_FLOD(t) ((t) == DCC_CK_BODY			    \
				|| ((t) >= DCC_CK_G_MSG_R_TOTAL		    \
				    && (t) <= DCC_CK_FLOD_PATH)		    \
				|| ((t) == DCC_CK_IP && grey_weak_ip))

#define DEF_FLOD_THOLDS(g,t) ((g) ? 1					    \
			      : t == DCC_CK_SRVR_ID ? 1 : BULK_THRESHOLD)

#define DCC_CK_TYPE_CLNT_OK(t)	DCC_CK_OK_GREY_CLNT(t)

#define DCC_CK_TYPE_DB_OK(t)	((t) > DCC_CK_INVALID && t <= DCC_CK_TYPE_LAST)

#define DCC_CK_TYPE_FLOD_OK(g,t) ((g) ? DCC_CK_OK_GREY_FLOD(t)		    \
				  : ((t) > DCC_CK_INVALID		    \
				     && (t) <= DCC_CK_FLOD_PATH))

typedef u_int32_t DB_NOKEEP_CKS;	/* bitmask of ignored checksums */
#define DB_SET_NOKEEP(map,t)	((map) |= (1<<(t)))
#define DB_RESET_NOKEEP(map,t)	((map) &= ~(1<<(t)))
#define DB_TEST_NOKEEP(map,t)	((map) & (1<<(t)))

/* relative fuzziness of checksums */
#define DCC_CK_FUZ_LVL_NO   1		/* least fuzzy */
#define DCC_CK_FUZ_LVL1	    2		/* somewhat fuzzy */
#define DCC_CK_FUZ_LVL2	    3		/* fuzzier */
#define DCC_CK_FUZ_LVL3	    4		/* reputations */
#define DCC_CK_FUZ_LVL_REP  DCC_CK_FUZ_LVL3
extern const u_char *db_ck_fuzziness;


typedef DB_PTR		    DB_HOFF;	/* byte offset into hash table */
typedef u_int32_t	    DB_HADDR;	/* index of a hash table entry */
#define MAX_HASH_ENTRIES    ((DB_HADDR)-1)

#define MIN_FREE_HASH_ENTRIES	1024	/* run dbclean at this size */
#define MIN_HASH_ENTRIES    (8*MIN_FREE_HASH_ENTRIES)
#define MIN_HASH_DIVISOR    ((MIN_HASH_ENTRIES*7)/8)

typedef u_char DB_HADDR_C[4];		/* compressed hash chain link */
#define DB_HADDR_CP(x,v)    DB_CP4(x,v)
#define DB_HADDR_EX(x)	    DB_EX4(x)
#define DB_HADDR_NULL	    0		/* no-answer from hashing & linking */
#define DB_HADDR_C_NULL(x)  DB_ZERO4(x)
#define DB_HADDR_INVALID(h) ((h) < DB_HADDR_BASE || (h) >= db_hash_len)
#define DB_HADDR_C_INVALID(h) DB_HADDR_INVALID(DB_HADDR_EX(h))

typedef u_char DB_PTR_HC[4];
#define DB_HPTR_CP(x,v) {u_int32_t _v = DB_PTR_CP(v);			\
    (x)[0] = _v>>24; (x)[1] = _v>>16; (x)[2] = _v>>8; (x)[3] = _v;}
#define DB_HPTR_EX(x) DB_PTR_EX(((x)[0]<<24) + ((x)[1]<<16)		\
				+ ((x)[2]<<8) + (x)[3])


/* shape of the magic string that starts a database */
typedef char DB_VERSION_BUF[64];
typedef struct {
    DB_VERSION_BUF version;		/* see DB_VERSION_STR */
    DB_PTR	db_csize;		/* size of database contents in bytes */
    u_int32_t	blksize;		/* size of one DB block */
    DB_SN	sn;			/* creation or expiration serial # */
    DCC_PTIME	cleared;		/* when created */
    DCC_PTIME	cleaned;		/* real instead of repair cleaning */
    DCC_PTIME	cleaned_cron;		/* cleaned by cron */
    DB_EX_TS	ex_spam;		/* recent expiration timestamps */
    DB_EX_TS	ex_all;			/* recent expiration timestamps */
    DB_EX_SECS	ex_secs;		/* recent expiration durations */
    DB_NOKEEP_CKS nokeep_cks;		/* ignore these checksums */
    u_int32_t	flags;
#    define DB_PARM_FG_GREY	0x01	/* greylist database */
#    define DB_PARM_FG_NEED_RWD	0x02	/* need to rewind floods from peers */
#    define DB_PARM_FG_EXP_SET	0x04	/* have explicit expiration durations */
#    define DB_PARM_FG_NO_CLR	0x08
#    define DB_PARM_FG_SSD	0x10	/* using ultra fast disk */
    DB_PTR	old_db_csize;		/* byte size at end of last cleaning */
    DB_PTR	db_added;		/* bytes previously added to database */
    DB_HADDR	hash_used;		/* recent # of entries used */
    DB_HADDR	old_hash_used;		/* entries used at last cleaning */
    DB_HADDR	hash_added;		/* entries added */
    DCC_PTIME	rate_secs;		/* denominator of rates */
#    define	 DB_MIN_RATE_SECS (12*60*60)
#    define	 DB_NEW_RATE_SECS ((7*24-1)*60*60)
#    define	 DB_GOOD_RATE_SECS (2*24*60*60)
#    define	 DB_MAX_RATE_SECS (60*24*60*60)
    DCC_PTIME	last_rate_sec;
    DB_HADDR	old_kept_cks;		/* reported checksums at cleaning */
    DB_PTR	min_confirm_pos;	/* flood after this */
    u_int32_t	failsafe_cleanings;	/* consecutive cleanings by dccd */
    DB_PTR	prev_db_added;
    DB_HADDR	prev_hash_added;
    DCC_PTIME	prev_rate_secs;
} DB_PARMS;
typedef union {
    DB_PARMS	p;
    char	c[256*3];
} DB_HDR;

#ifdef DB_VERSION5_STR
typedef struct {
    DCC_TGTS	unused;
    int32_t	all;
    int32_t	spam;
} DB_V5_EX_SEC;
typedef DB_V5_EX_SEC DB_V5_EX_SECS[DCC_DIM_CKS];
typedef struct {
    DB_VERSION_BUF version;
    DB_PTR	db_csize;
    u_int32_t	blksize;
    DB_SN	sn;
    time_t	cleared;
    time_t	cleaned;
    time_t	cleaned_cron;
    DB_EX_TS	ex_spam;
    DB_EX_TS	ex_all;
    DB_V5_EX_SECS ex_secs;
    DB_NOKEEP_CKS nokeep_cks;
    u_int	flags;
    DB_PTR	old_db_csize;
    DB_PTR	db_added;
    DB_HADDR	hash_used;
    DB_HADDR	old_hash_used;
    DB_HADDR	hash_added;
    time_t	rate_secs;
    time_t	last_rate_sec;
    DB_HADDR	old_kept_cks;
    DB_PTR	min_confirm_pos;
    u_int	failsafe_cleanings;
} DB_V5_PARMS;
#endif
#ifdef DB_VERSION4_STR
typedef struct {
    DB_VERSION_BUF version;
    DB_PTR	db_csize;
    u_int32_t	blksize;
    DB_SN	sn;
    time_t	cleared;
    time_t	cleaned;
    time_t	cleaned_cron;
    DB_EX_TS	ex_spam;
    DB_V5_EX_SECS ex_secs;
    DB_NOKEEP_CKS nokeep_cks;
    u_int	flags;
    DB_PTR	old_db_csize;
    DB_PTR	db_added;
    DB_HADDR	hash_used;
    DB_HADDR	old_hash_used;
    DB_HADDR	hash_added;
    time_t	rate_secs;
    time_t	last_rate_sec;
    DB_HADDR	old_kept_cks;
} DB_V4_PARMS;
#endif
#ifdef DB_VERSION3_STR
typedef struct {
    DB_VERSION_BUF version;
    DB_PTR	db_csize;
    u_int32_t	blksize;
    DB_SN	sn;
    DB_EX_TS	ex_spam;
    DB_V5_EX_SECS ex_secs;
    DB_NOKEEP_CKS nokeep_cks;
    DCC_TGTS	unused[DCC_DIM_CKS];
    u_int	flags;
#    define DB_PARM_V3_FG_GREY		0x01
#    define DB_PARM_V3_FG_SELF_CLEAN	0x02
#    define DB_PARM_V3_FG_SELF_CLEAN2	0x04
#    define DB_PARM_V3_FG_NEED_RWD	0x08
    DB_PTR	old_db_csize;
    DB_PTR	db_added;
    DB_HADDR	hash_used;
    DB_HADDR	old_hash_used;
    DB_HADDR	hash_added;
    time_t	rate_secs;
    time_t	last_rate_sec;
    DB_HADDR	old_kept_cks;
} DB_V3_PARMS;
#endif

/* shape of a database hash table entry */
typedef struct {
    DB_HADDR_C	fwd, bak;		/* hash collision chain */
    u_char	hv_type[2];		/* checksum type + some hash bits */
#    define	 HE_TYPE(e)	 ((DCC_CK_TYPES)((e)->hv_type[0] & 0xf))
#    define	 HE_IS_FREE(e)	 ((e)->hv_type[0] == 0)
#    define	 HE_MERGE(e,t,s) ((e)->hv_type[0] = ((((s)->b[0])<<4) + t),\
				  (e)->hv_type[1] = (s)->b[1])
#    define	 HE_CMP(e,t,s)	 ((e)->hv_type[1] == (s)->b[1]		\
				  && ((e)->hv_type[0]			\
				      == (u_char)((((s)->b[0])<<4) + t)))

    DB_PTR_HC	rcd;			/* record for this hash table entry */
} HASH_ENTRY;



/* the start of the hash table file */
typedef u_int32_t HCTL_FGS;
typedef struct {
    char	magic[16];
    HCTL_FGS	fgs;
#    define	 HCTL_FG_KCACHE_OK  0x1 /* 1=kernal cache contents valid */
#    define	 HCTL_FG_SYNC_OK    0x2	/* 1=disk contents valid */
    DB_HADDR    free_fwd;		/* hash table internal free list */
    DB_HADDR    free_bak;
#    define	 FREE_HADDR_END 1
    DB_HADDR    len;			/* size of file in entries */
    DB_HADDR    used;			/* entries actually used */
    DB_HADDR    divisor;		/* hash modulus */
    DB_PTR	db_csize;		/* copy of size of the database file */
    DCC_PTIME   sync_sec;
} HCTL;


/* index of the first real hash entry after the control data at the base */
#define DB_HADDR_BASE	((DB_HADDR)((sizeof(HCTL)+sizeof(HASH_ENTRY)-1) \
				    / sizeof(HASH_ENTRY)))

/* Adjust a hash table index by the control data at the base.
 * This is required when computing ratios of entries used to free entries
 * so that the ratio does not include the control data. */
#define ADJ_HLEN(l)	((int)((l)-DB_HADDR_BASE))  /* offset to length */


/* fix configure script if this changes */
#define DB_MIN_MIN_MBYTE    32
#define DB_DEF_MIN_MBYTE    64		/* a reasonable tiny default */
#define DB_PAD_MBYTE	    128		/* RAM for rate limiting blocks etc */
#define DB_PAD_BYTE	(DB_PAD_MBYTE*1024*1024)
#define DB_MAX_2G_MBYTE (2048-DB_PAD_MBYTE) /* <2 GByte on 32 bit machines */
#define DB_NEEDED_MBYTE	    DB_MAX_2G_MBYTE /* need at least this much RAM */
/* the database cannot exceed 48 GBytes because of DB_PTR_CP */
#define MAX_MAX_DB_MBYTE    (48*1024)
/*	fix INSTALL.html if those change */

/* Both database files are divided into blocks.
 * Each block is mmap()ed into one of DB_BUF_NUM buffers. */
typedef u_int DB_BLK_NUM;		/* index of a DB block */
typedef u_int32_t DB_BLK_OFF;		/* byte or hash entry offset */

typedef enum {
    DB_BUF_TYPE_FREE = 0,
    DB_BUF_TYPE_HASH,
    DB_BUF_TYPE_DB
} DB_BUF_TYPE;

/* 5 seconds between flushes ==> 2^16 flushes/day
 * 2^31 bytes flooded/day ==> 2^15 bytes/flush
 * 2^32 bytes of checksums + 2^31 bytes of hash table = 2^33 bytes/database
 * 2^33 bytes/database & 2^7 blocks ==> 2^26 bytes/block
 * 2^15 bytes/flush & 2^26 bytes/block ==> 2^11 parts/block
 * 2^6 bytes/dirty mask word & 2^11 parts/block ==> 2^5 dirty mask words
 * round up to 2^6 dirty mask words
 */
typedef u_long DB_BIT;
#define PARTBITS    (8*sizeof(DB_BIT))
#define	PARTWORDS   64
#define DB_BUF_NUM_PARTS (PARTWORDS*PARTBITS)

/* This bits show the need for write() in DB_BUF_FG_PRIVATE buffers
 * or the need for msync() in ordinary mmap() buffers. */
typedef struct {
    DB_BIT	    w[PARTWORDS];
    u_int	    num;
} DB_PART_MAP;
#define OFF2PNO(off)		((off) / bufpart_size)
#define PNO2WNO(pno)		((pno) / PARTBITS)
#define PNO2BIT(pno)		(((DB_BIT)1) << ((pno) % PARTBITS))
#define PNO2WORD(b,pno)		(&(b)->dirt.w[PNO2WNO(pno)])
#define PNO2WORD_URGENT(b,pno)	(&(b)->dirt_urgent.w[PNO2WNO(pno)])
#define GET_DIRT(b,pno)		((*PNO2WORD(b,pno)	  & PNO2BIT(pno)) != 0)
#define GET_DIRT_URGENT(b,pno)	((*PNO2WORD_URGENT(b,pno) & PNO2BIT(pno)) != 0)
#define SET_DIRT(b,pno)		(*PNO2WORD(b,pno)	 |= PNO2BIT(pno),   \
				 ++(b)->dirt.num)
#define SET_DIRT_URGENT(b,pno)	(*PNO2WORD_URGENT(b,pno) |= PNO2BIT(pno),   \
				 ++(b)->dirt_urgent.num)
#define CLR_DIRT(b,pno)		(*PNO2WORD(b,pno)	 &= ~PNO2BIT(pno),  \
				 --(b)->dirt.num)
#define CLR_DIRT_URGENT(b,pno)	(*PNO2WORD_URGENT(b,pno) &= ~PNO2BIT(pno),  \
				 --(b)->dirt_urgent.num)

typedef struct db_buf {
    struct db_buf *addr_fwd, *addr_bak, **hash;
    struct db_buf *older, *newer;
    union {
	void	    *v;
	HASH_ENTRY  *h;
	char	    *c;
    } buf;
    DB_BLK_NUM	blk_num;		/* block # in file */
    int		lock_cnt;
    DB_BUF_TYPE	buf_type;
    DB_PART_MAP	dirt;
    DB_PART_MAP	dirt_urgent;
    u_int	flags;
#    define	 DB_BUF_FG_PRIVATE	0x01	/* mmap(MAP_PRIVATE) used */
#    define	 DB_BUF_FG_ANON_EXTEND	0x02	/* new block in anon. memory */
} DB_BUF;

/* context for searching for or adding a record */
typedef struct db_st {
    struct db_st *fwd, *bak;
#	define DB_ST_BUSY ((struct db_st *)1)
    union {				/* pointer to data in buffer */
	char	    *c;
	void	    *v;
	HASH_ENTRY  *h;
	DB_RCD	    *r;
    } d;
    union {				/* database address */
	DB_HADDR    haddr;
	DB_PTR	    rptr;
    } s;
    DB_BUF	*b;
    const char	*bufend;
    const char	*file;
    int		lineno;
} DB_ST;

extern int db_failed_line;
extern const char *db_failed_file;
#define DB_ERROR_MSG(s) db_error_msg(__LINE__,__FILE__, "%s", s)
#define DB_ERROR_MSG2(s1,s2) db_error_msg(__LINE__,__FILE__, "%s: %s", s1,s2)

extern struct timeval db_time;
#define DB_IS_TIME(tgt,lim) DCC_IS_TIME(db_time.tv_sec, tgt, lim)
#define DB_ADJ_TIMER(tgt,lim,new) DCC_ADJ_TIMER(db_time.tv_sec, tgt, lim, new)

extern u_char dbclean_running;		/* this is dccd & dbclean is running */
extern int db_fd, db_hash_fd;
extern DCC_PATH db_nm, db_nm_path;
extern DCC_PATH db_hash_nm, db_hash_nm_path;
extern struct timeval db_locked;	/* 0 or when database was locked */
extern int db_debug;
extern DB_SN db_sn;

extern u_int sys_pagesize;

extern DB_HOFF db_hash_fsize;		/* size of hash table file */
extern DB_HADDR db_hash_len;		/* # of hash table entries */
extern DB_HADDR db_hash_divisor;	/* hash function modulus */
extern DB_HADDR db_hash_used;		/* # of hash table entries in use */
extern u_int db_hash_blk_len;		/* # of HASH_ENTRYs per block */
extern DB_HADDR db_max_hash_entries;	/* max size of hash table */
extern DB_PTR db_fsize;			/* size of database file */
extern DB_PTR db_csize;			/* size of database contents in bytes */
extern const DB_VERSION_BUF db_version_buf;
extern DB_PARMS db_parms;
extern DCC_TGTS db_tholds[DCC_DIM_CKS];
extern u_int db_blksize;		/* size of one DB block */

typedef struct {
    u_int   db_mmaps;
    u_int   hash_mmaps;
    u_int   adds;			/* reports added */
} DB_STATS;
extern DB_STATS db_stats;


/* If the two files were smaller than the typical mmap() limit of a fraction
 * of a GByte, they could be mmap()'ed directly.  They are often too large.
 *
 * Use a modest pool of buffers to map the DB hash table
 * and the checksum database.
 *
 * Most of the DB hash table is expected to fit in the application's memory.
 *
 * Use the same modest pool of buffers to map the database itself.
 * References to the database have a lot of locality, so the commonly used
 * checksums and counts should remain in memory.
 *
 * Common operating system limits on the number of mapped segments are
 * below 256 and so that is a bound on DB_BUF_NUM */
#define DB_BUF_NUM 128			/* maximum # of buffers */

extern DB_PTR db_max_rss;		/* maximum db resident set size */
extern DB_PTR db_max_byte;

extern time_t db_need_flush_secs;
#define DB_NEED_FLUSH_SECS	5


/* srvrlib/db.c */
extern void db_vfailure(int, const char *, int, DCC_EMSG *,
			const char *, va_list);
extern void db_failure(int, const char *, int, DCC_EMSG *,
		       const char *, ...) DCC_PF(5,6);
extern void db_error_msg(int, const char *, const char *, ...) DCC_PF(3,4);
extern void db_dirty_data(DB_ST *, u_char, u_int);
#define DIRTY_RCD(st,u)	    db_dirty_data(st,u, DB_RCD_LEN((st)->d.r))
extern DB_ST *get_db_st(const char *, int);
#define GET_DB_ST() get_db_st(__FILE__, __LINE__)
extern void free_db_st(DB_ST *);
typedef enum {
    DB_UNLOAD_RELEASE,			/* release buffers without msync() */
    DB_UNLOAD_INVALIDATE,		/* invalidate buffers & contents */
    DB_UNLOAD_ONE,			/* reduce resident set */
    DB_UNLOAD_ENOUGH,			/* unload until dbclean has room */
    DB_UNLOAD_REBOOT,			/* start closing for reboot */
    DB_UNLOAD_REBOOT_CLEAN,		/* start closing for clean reboot */
} DB_UNLOAD_MODE;
extern int db_unload(DCC_EMSG *, DB_UNLOAD_MODE);
extern u_char dbclean_flush(DCC_EMSG *);
typedef enum {
    DB_CLOSE_FORK,			/* clean after a fork */
    DB_CLOSE,				/* flush buffers to the kernel */
    DB_CLOSE_REBOOT,			/* discard the hash table */
    DB_CLOSE_STABLE,			/* fsync() */
    DB_CLOSE_DISCARD_ALL,		/* discard and invalidate all buffers */
    DB_CLOSE_NEW_DB,			/* switch to cleaned database */
} DB_CLOSE_MODE;
extern u_char unlink_whine(DCC_EMSG *, const char *, u_char);
extern u_char db_close(DB_CLOSE_MODE);
extern u_char lock_dbclean(DCC_EMSG *, const char *);
extern void unlock_dbclean(void);
extern u_int get_db_blksize(DB_PTR, u_int);
extern u_char db_buf_init(DB_PTR, u_int);
typedef u_int DB_OPEN_MODES;
# define DB_OPEN_RDONLY		    0x01
# define DB_OPEN_LOCK_WAIT	    0x02    /* wait to get lock */
# define DB_OPEN_LOCK_NOWAIT	    0x04    /* get lock but don't wait */
# define DB_OPEN_MSYNC		    0x08    /* use msync() instead of write() */
# define DB_OPEN_WRITE		    0x10    /* use write() instead of msync() */
# define DB_OPEN_DBCLEAN_DEFAULT    0x20    /* use default dbclean choices  */
# define DB_OPEN_DCCD_DEFAULT	    0x40    /* use default dccd choices  */
extern u_char db_open(DCC_EMSG *, int, const char *, const char *,
		      DB_HADDR, DB_OPEN_MODES);
extern u_char db_flush_parms(DCC_EMSG *);
#define DB_IS_LOCKED() (db_locked.tv_sec != 0)
extern int db_lock(void);
extern u_char db_unlock(void);
extern void dccd_flush(u_char);
extern DCC_TGTS db_sum_ck(DCC_TGTS, DCC_TGTS, DCC_CK_TYPES);
extern const char *size2str(char *, u_int, double, u_char);
extern double db_add_rate(const DB_PARMS *, u_char, u_char);
extern DB_NOKEEP_CKS def_nokeep_cks(void);
extern void set_db_tholds(DB_NOKEEP_CKS);
extern u_char db_map_rcd(DCC_EMSG *, DB_ST *, DB_PTR, int *);
extern DB_RCD_CK *db_map_rcd_ck(DCC_EMSG *, DB_ST *, DB_PTR, DCC_CK_TYPES);
extern DB_HADDR db_hash(DCC_CK_TYPES, const DCC_SUM *);
typedef enum {
    DB_FOUND_SYSERR=0,			/* fatal error */
    DB_FOUND_IT,
    DB_FOUND_EMPTY,			/* home slot empty */
    DB_FOUND_CHAIN,			/* not in chain--have last entry */
    DB_FOUND_INTRUDER			/* intruder in home slot */
} DB_FOUND;
extern DB_FOUND db_lookup(DCC_EMSG *, DCC_CK_TYPES, const DCC_SUM *,
			  DB_ST *, DB_ST *, DB_RCD_CK **);
extern u_char db_link_rcd(DCC_EMSG *, DB_ST *);
extern DB_PTR db_add_rcd(DCC_EMSG *, const DB_RCD *, DB_ST *);

#endif /* DB_H */
