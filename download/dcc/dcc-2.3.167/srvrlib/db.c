/* Distributed Checksum Clearinghouse
 *
 * server database functions
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
 * Rhyolite Software DCC 2.3.167-1.252 $Revision$
 */

#include "srvr_defs.h"
#include <syslog.h>
#include <sys/resource.h>
#ifdef HAVE_HW_PHYSMEM
#include <sys/sysctl.h>
#endif
#ifdef HAVE_PSTAT_GETSTATIC		/* HP-UX */
#include <sys/pstat.h>
#endif


DB_STATS db_stats;

/* Have enough state blocks to never run out and avoid reusing blocks */
static DB_ST db_sts[12];
static DB_ST *db_sts_free_head;
static DB_ST *db_sts_free_tail;
static DB_ST *hctl_st;
static HCTL *hctl;
static DB_ST *db_parms_st;
static DB_PARMS *cur_db_parms;

#define DIRTY_HCTL()	    db_dirty_data(hctl_st, 0, sizeof(HCTL))
#define DIRTY_HE(st)	    db_dirty_data(st, 0, sizeof(HASH_ENTRY))

#define DB_ST_VALID(st, str) ((st)->fwd == DB_ST_BUSY			\
			      && (st)->bak == DB_ST_BUSY		\
			      ? (void)0					\
			      :dcc_logbad(EX_SOFTWARE, str" free DB_ST"))

DCC_PATH db_path_buf;

int db_fd = -1;
DCC_PATH db_nm;
DCC_PATH db_nm_path;
int db_hash_fd = -1;
DCC_PATH db_hash_nm;
DCC_PATH db_hash_nm_path;

struct timeval db_locked;		/* 1=database not locked */

struct timeval db_time;

int db_debug;

u_char grey_on;
u_char ssd_mode;

static u_char db_rdonly;		/* opened read-only */
int db_failed_line;			/* bad happened at this line # */
const char *db_failed_file;		/*	in this file */

u_char dbclean_running;			/* this is dccd & dbclean is running */


typedef enum {
    DB_BUF_MODE_PRIVATE,		/* use private mmap() and write() */
    DB_BUF_MODE_SHARED,			/* use shared mmap() */
} DB_BUF_MODE;
static DB_BUF_MODE db_buf_mode_hash, db_buf_mode_db;
/* Some systems will bog down doing nothing but flushing dirty shared hash
 * table mmap() pages.
 * Using write() or DB_BUF_MODE_PRIVATE buffers instead of letting the
 * virtual memory system helps.
 *
 * Limited coherence between changes in the buffer cache made with
 * DB_BUF_MODE_PRIVATE by one process and changes seen in the page cache
 * by another process in some systems make this a bad thing when two processes
 * are running.
 * So do not use DB_BUF_MODE_PRIVATE buffers in dccd when dbclean is running.
 * Dbclean does not change buffers that are shared with dccd, so this concern
 * does not restrict dbclean. */
#define DB_BUF_MODE_B(b) ((dbclean_running || db_rdonly || !DB_IS_LOCKED()) \
			  ? DB_BUF_MODE_SHARED				    \
			  : (b)->buf_type == DB_BUF_TYPE_HASH		    \
			  ? db_buf_mode_hash : db_buf_mode_db)


/* The database has degrees of inconsistency:
 *	!(hctl->flgs & HCTL_FG_KCACHE_OK) or !kcache_ok
 *	    The kernel buffer cache is wrong or inconsistent as seen by other
 *	    processes through mmap().  This happens with privately mapped
 *	    buffers or while the database is actively being changed.  This
 *	    state can reach the disk after dccd, dbclean, or kernel crashes.
 *
 *	!(hctl->flgs & HCTL_FG_SYNC_OK)
 *	    The kernel buffer cache was not synchronized to the disk, and so
 *	    read() or mmap() are unreliable if the system has been rebooted
 *	    since hctl->sync_sec.
 *
 *	    !disk_hash_ok or !disk_db_ok indicate that the hash table or the
 *	    checksums, respectively, have not have not been synchronized
 *	    with the disk.
 *
 *	(hctl->flgs & HCTL_FG_SYNC_OK)
 *	    The kernel buffer cache was synchronized with the disk at
 *	    hctl->sync_sec.
 */
static u_char kcache_ok;
static u_char disk_hash_ok;
static u_char disk_db_ok;

static char *wbuf;
static u_int wbuf_len;

time_t db_need_flush_secs;
static inline void
set_db_need_flush_secs(void)
{
	if (db_need_flush_secs == 0 && !dbclean_running)
		db_need_flush_secs = db_time.tv_sec + DB_NEED_FLUSH_SECS;
}



/* With MAP_NOSYNC and without an SSD, we can accumulate large amounts of data
 * in RAM that take too long time to be pushed to the disk when the system
 * is shutting down. So
 *	- hit only those chunks of memory with real data or changes to data
 *	    with msync().  Trust dbclean to rebuild everything else
 *	    including the hash table and hash links after a system crash.
 *
 *	- when it seems the system is being shut down, delete the hash table
 *	    and let it be rebuilt when the system is rebooted.  When the
 *	    hash table is rebuilt, any markings in the data file that
 *	    were lost will be remade.
 *
 * A third case involves dccd -F or dbclean -u.  It requires that all
 * changes be pushed to the disk whenever dccd unlocks the database so that
 * dbclean can see changes dccd makes.  It also requires that dbclean write
 * all of its changes so that dccd will find them when it reopens the database.
 *
 * The Linux mmap() does not have mmap(MAP_NOSYNC), but the man page says
 *	The  file  may  not  actually  be updated until msync(2) or munmap()
 *	is called.
 * That implies that we must treat mmap() on Linux as if it were called
 * with MAP_NOSYNC.
 */
#if !defined(MAP_NOSYNC) || defined(HAVE_OLD_MSYNC)
#define USE_MAP_NOSYNC 0
#else
#define USE_MAP_NOSYNC 1
#endif

#if defined(MADV_WILLNEED)
#define DCC_MADV_WILLNEED MADV_WILLNEED
#elif defined(POSIX_MADV_WILLNEED)
#define DCC_MADV_WILLNEED POSIX_MADV_WILLNEED
#else
#undef DCC_MADV_WILLNEED
#endif

#if defined(MADV_FREE)
#define DCC_MADV_FREE MADV_FREE
#elif defined(POSIX_MADV_FREE)
#define DCC_MADV_FREE POSIX_MADV_FREE
#elif defined(linux) && defined(MADV_DONTNEED)
/* Some people claim that it is just fine that the Linux notion of
 * MADV_DONTNEED implies discarding changes to data.  Worse, some versions of
 * Linux/GNU libc define POSIX_MADV_DONTNEED as the data-corrupting Linux
 * MADV_DONTNEED.
 * So use Linux MADV_DONTNEED for MADV_FREE, because it is on some systems. */
#define DCC_MADV_FREE MADV_DONTNEED
#else
#undef DCC_MADV_FREE
#endif

#if !defined(MAP_ANONYMOUS) && defined(MAP_ANON)
#define MAP_ANONYMOUS	MAP_ANON
#endif


#define BUF_OFFSET(b) ((off_t)(b)->blk_num * (off_t)db_blksize)

static DB_PTR db_buf_bytes;		/* current content size */
DB_PTR db_max_rss;			/* maximum db resident set size */
DB_PTR db_max_byte;			/* maximum db bytes in both files */

u_int sys_pagesize;			/* kernel page size */


static DB_BUF db_bufs[DB_BUF_NUM];
static DB_BUF *buf_oldest, *buf_newest;

/* A bit in these arrays says that the corresponding block was probably
 * not sent to the disk when the file was was previously used. */
#define NUM_ASSUME_BLKS		(DB_BUF_NUM*2)
#define NUM_ASSUME_BITS		(8*sizeof(DB_BIT))
#define ASSUME_DIRTY_NUM	((DB_MAX_BLK_NUM+1+DIRTY_DB_BLK_BITS-1)	    \
				 / DIRTY_DB_BLK_BITS)
static struct {
	DB_BIT db[NUM_ASSUME_BLKS];
	DB_BIT hash[NUM_ASSUME_BLKS];
} assume_dirty;
#define BLK_NUM2DIRTBIT(n)	(1 << ((n) % NUM_ASSUME_BITS))
#define BLK_NUM2DIRTWORD(n)	((n) /  NUM_ASSUME_BITS)


#if DB_BUF_NUM==128
#define DB_HASH_TOTAL 151		/* a prime number */
#else
#error "choose a prime larger than DB_BUF_NUM"
#endif
static DB_BUF *db_buf_hash[DB_HASH_TOTAL];
#define DB_BUF_HASH(pnum,type) &db_buf_hash[((pnum)*2 + (type)-1)	\
					    % DB_HASH_TOTAL]

const DB_VERSION_BUF db_version_buf = DB_VERSION_STR;
DB_PARMS db_parms;

DCC_TGTS db_tholds[DCC_DIM_CKS];

DB_BLK_OFF db_blksize;			/* size of an mmap()'ed block */
static DB_BLK_OFF bufpart_size;		/* part of a buffer */
static u_int bufpart_kbytes;
static u_int kbytes_per_flush;

DB_HOFF db_hash_fsize;			/* size of hash table file */
DB_HADDR db_hash_len;			/* # of hash table entries */
DB_HADDR db_hash_divisor;		/* hash function modulus */
DB_HADDR db_hash_used;			/* # of hash table entries in use */
u_int db_hash_blk_len;			/* # of HASH_ENTRYs per block */
DB_HADDR db_max_hash_entries;
DB_PTR db_fsize;			/* size of database file */
DB_PTR db_csize;			/* database file contents in bytes */
static char db_physmem_str[80];

static const u_char dcc_ck_fuzziness[DCC_DIM_CKS] = {
	0,				/* DCC_CK_INVALID */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_IP */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_ENV_FROM */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_FROM */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_SUB */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_MESSAGE_ID */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_RECEIVED */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_BODY */
	DCC_CK_FUZ_LVL1,		/* DCC_CK_FUZ1 */
	DCC_CK_FUZ_LVL2,		/* DCC_CK_FUZ2 */
	DCC_CK_FUZ_LVL_REP,		/* DCC_CK_REP_TOTAL */
	DCC_CK_FUZ_LVL_REP,		/* DCC_CK_REP_BULK */
	DCC_CK_FUZ_LVL2,		/* DCC_CK_SRVR_ID */
	DCC_CK_FUZ_LVL2			/* DCC_CK_ENV_TO */
};
static const u_char grey_ck_fuzziness[DCC_DIM_CKS] = {
	0,				/* DCC_CK_INVALID */
	DCC_CK_FUZ_LVL2,		/* DCC_CK_IP */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_ENV_FROM */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_FROM */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_SUB */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_MESSAGE_ID */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_RECEIVED */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_BODY */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_FUZ1 */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_FUZ2 */
	DCC_CK_FUZ_LVL_NO,		/* DCC_CK_GREY_MSG */
	DCC_CK_FUZ_LVL1,		/* DCC_CK_GREY_TRIPLE */
	DCC_CK_FUZ_LVL1,		/* DCC_CK_SRVR_ID */
	DCC_CK_FUZ_LVL1			/* DCC_CK_ENV_TO */
};
const u_char *db_ck_fuzziness = dcc_ck_fuzziness;


typedef enum {
    BUF_CLEAN_ALL,			/* all changes */
    BUF_CLEAN_URGENT,			/* only urgent changes */
    BUF_CLEAN_DB,			/* checksum but not hash changes */
} BUF_CLEAN_MODE;
static u_char buf_all_clean(DCC_EMSG *, u_int *, u_int, BUF_CLEAN_MODE);
static u_char buf_clean(DCC_EMSG *, DB_BUF *, u_int *, u_int, BUF_CLEAN_MODE);
typedef enum {
    BUF_UNMAP_SAVE_ALL,			/* write() & msync() all changes */
    BUF_UNMAP_RELEASE,			/* release buffers without msync() */
    BUF_UNMAP_INVALIDATE,		/* discard & invalidate the buffer */
} BUF_UNMAP_MODE;
static u_char buf_unmap(DCC_EMSG *, DB_BUF *, BUF_UNMAP_MODE, u_char);
static u_char make_db_dirty(DCC_EMSG *, DB_BUF_TYPE);
static u_char db_sync(DCC_EMSG *, u_char);
static void rel_db_st(DB_ST *);
static DB_BUF *find_st_buf(DCC_EMSG *, DB_BUF_TYPE, DB_ST *,
			   DB_BLK_NUM, u_char);
static DB_BUF *find_buf(DCC_EMSG *, DB_BUF_TYPE, DB_BLK_NUM);
static u_char map_hash(DCC_EMSG *, DB_HADDR, DB_ST *, u_char);
static u_char map_hctl(DCC_EMSG *, u_char);
static u_char map_db(DCC_EMSG *, DB_PTR, u_int, DB_ST *, u_char);
static u_char map_db_parms(DCC_EMSG *emsg);
static u_char db_set_sizes(DCC_EMSG *);

static u_char db_share(DCC_EMSG *);
static u_char fsync_type(DCC_EMSG *, DB_BUF_TYPE, u_char);


/* compute the least common multiple of two numbers */
static u_int
lcm(u_int n, u_int m)
{
	u_int r, x, gcd;

	/* first get the gcd of the two numbers */
	if (n >= m) {
		x = n;
		gcd = m;
	} else {
		x = m;
		gcd = n;
	}
	for (;;) {
		r = x % gcd;
		if (r == 0)
			return n * (m / gcd);
		x = gcd;
		gcd = r;
	}
}



static const char *
db_ptr2str(DB_PTR val)
{
	static int bufno;
	static struct {
	    char    str[16];
	} bufs[8];
	char *s;
	const char *units;

	if (val == 0)
		return "0";

	s = bufs[bufno].str;
	bufno = (bufno+1) % DIM(bufs);

	if (val % (1024*1024*1024) == 0) {
		val /= (1024*1024*1024);
		units = "GB";
	} else if (val % (1024*1024) == 0) {
		val /= (1024*1024);
		units = "MB";
	} else if (val % 1024 == 0) {
		val /= 1024;
		units = "KB";
	} else {
		units = "";
	}
	if (val > 1000*1000*1000)
		snprintf(s, sizeof(bufs[0].str), "%d,%03d,%03d,%03d%s",
			 (int)(val / (1000*1000*1000)),
			 (int)(val / (1000*1000)) % 1000,
			 (int)(val / 1000) % 1000,
			 (int)(val % 1000),
			 units);
	else if (val > 1000*1000)
		snprintf(s, sizeof(bufs[0].str), "%d,%03d,%03d%s",
			 (int)(val / (1000*1000)),
			 (int)(val / 1000) % 1000,
			 (int)(val % 1000),
			 units);
	else if (val > 1000*10)
		snprintf(s, sizeof(bufs[0].str), "%d,%03d%s",
			 (int)(val / 1000),
			 (int)(val % 1000),
			 units);
	else
		snprintf(s, sizeof(bufs[0].str), "%d%s",
			 (int)val,
			 units);
	return s;
}



static inline const char *
mbyte2str(DB_PTR val)
{
	return db_ptr2str(val*1024*1024);
}



const char *
size2str(char *buf, u_int buf_len,
	 double num, u_char bytes_or_entries)	/* 0=number 1=bytes */
{
	static int bufno;
	static struct {
	    char    str[16];
	} bufs[8];
	const char *units;
	double k;

	if (!buf || !buf_len) {
		buf = bufs[bufno].str;
		buf_len = sizeof(bufs[bufno].str);
		bufno = (bufno+1) % DIM(bufs);
	}

	k = bytes_or_entries ? 1024.0 : 1000.0;

	if (num < k) {
		units = "";
	} else if (num < k*k) {
		num /= k;
		units = bytes_or_entries ? "KB" : "K";
	} else if (num < k*k*k) {
		num /= k*k;
		units = bytes_or_entries ? "MB" : "M";
	} else {
		num /= k*k*k;
		units = bytes_or_entries ? "GB" : "G";
	}

	if ((int)num >= 100)
		snprintf(buf, buf_len, "%.0f%s", num, units);
	else
		snprintf(buf, buf_len, "%.2g%s", num, units);
	return buf;
}



void
db_vfailure(int linenum, const char *file,
	    int ex_code, DCC_EMSG *emsg, const char *p, va_list args)
{
	if (!db_failed_line) {
		db_failed_line = linenum;
		db_failed_file = file;
	}
	dcc_vpemsg(ex_code, emsg, p, args);
}



void DCC_PF(5,6)
db_failure(int linenum, const char *file,
	   int ex_code, DCC_EMSG *emsg, const char *p, ...)
{
	va_list args;

	va_start(args, p);
	db_vfailure(linenum, file, ex_code, emsg, p, args);
	va_end(args);
}



void DCC_PF(3,4)
db_error_msg(int linenum, const char *file, const char *p, ...)
{
	va_list args;

	if (!db_failed_line) {
		db_failed_line = linenum;
		db_failed_file = file;
	}
	va_start(args, p);
	dcc_verror_msg(p, args);
	va_end(args);
}



static inline double
rate_sub(time_t total_secs, double added,
	 time_t delta_secs, double cur, double prev)
{
	if (total_secs <= 0 || total_secs > DB_MAX_RATE_SECS
	    || added <= 0.0) {
		added = 0.0;
		total_secs = 0;
	}

	if (delta_secs > 0 && delta_secs <= DB_MAX_RATE_SECS
	    && cur > prev) {
		total_secs += delta_secs;
		added += cur - prev;
	}

	if (total_secs < DB_MIN_RATE_SECS || total_secs > DB_MAX_RATE_SECS)
		return -1.0;
	return added / total_secs;
}



double					/* hashes or bytes/second */
db_add_rate(const DB_PARMS *parms,
	    u_char hash_or_db,		/* 1=hash */
	    u_char vers)		/* 0=both, 1=cur only, 2=old only */
{
	time_t delta_secs;
	double cur_rate, prev_rate;

	delta_secs = parms->last_rate_sec - ts2secs(&parms->sn);

	if (hash_or_db) {
		cur_rate = rate_sub(parms->rate_secs, parms->hash_added,
				    delta_secs,
				    parms->hash_used, parms->old_hash_used);
		prev_rate = rate_sub(parms->prev_rate_secs,
				     parms->prev_hash_added, 0, 0, 0);
	} else {
		cur_rate = rate_sub(parms->rate_secs, parms->db_added,
				    delta_secs,
				    parms->db_csize, parms->old_db_csize);
		prev_rate = rate_sub(parms->prev_rate_secs,
				     parms->prev_db_added, 0, 0, 0);
	}

	/* answer with a single rate if required */
	if (vers == 1)
		return cur_rate;
	if (vers == 2)
		return prev_rate;

	/* Answer with our best guess.  That is the current data if the
	 * past data is not good enough.  Otherwise it is the larger
	 * rate. */
	if (prev_rate > 0.0 && parms->rate_secs+delta_secs < DB_GOOD_RATE_SECS)
		return prev_rate;
	return max(prev_rate, cur_rate);
}



DB_NOKEEP_CKS
def_nokeep_cks(void)
{
	DCC_CK_TYPES type;
	DB_NOKEEP_CKS nokeep = 0;

	for (type = DCC_CK_TYPE_FIRST; type <= DCC_CK_TYPE_LAST; ++type) {
		if (DB_GLOBAL_NOKEEP(grey_on, type))
			DB_SET_NOKEEP(nokeep, type);
	}
	DB_SET_NOKEEP(nokeep, DCC_CK_INVALID);
	DB_SET_NOKEEP(nokeep, DCC_CK_FLOD_PATH);

	return nokeep;
}



void
set_db_tholds(DB_NOKEEP_CKS nokeep)
{
	DCC_CK_TYPES type;

	for (type = 0; type < DIM(db_tholds); ++type) {
		db_tholds[type] = (DB_TEST_NOKEEP(nokeep, type)
				   ? DCC_TGTS_INVALID
				   : DCC_CK_IS_REP(grey_on, type)
				   ? DCC_TGTS_INVALID
				   : grey_on
				   ? 1
				   : type == DCC_CK_SRVR_ID
				   ? 1
				   : BULK_THRESHOLD);
	}
}



static const char *
buf_type2path(DB_BUF_TYPE type)
{
	switch (type) {
	case DB_BUF_TYPE_HASH:
		return db_hash_nm_path.c;
	case DB_BUF_TYPE_DB:
		return db_nm_path.c;
	case DB_BUF_TYPE_FREE:
	default:
		dcc_logbad(EX_SOFTWARE, "impossible buffer type");
	}
}


static const char *
buf2path(const DB_BUF *b)
{
	return buf_type2path(b->buf_type);
}



static int
type2fd(DB_BUF_TYPE type)
{
	switch (type) {
	case DB_BUF_TYPE_HASH:
		return db_hash_fd;
	case DB_BUF_TYPE_DB:
		return db_fd;
	case DB_BUF_TYPE_FREE:
	default:
		dcc_logbad(EX_SOFTWARE, "impossible buffer type %d for fd",
			   type);
	}
}



DB_ST *
get_db_st(const char *file, int lineno)
{
	DB_ST *st;

	st = db_sts_free_head;
	if (!st)
		dcc_logbad(EX_SOFTWARE, "no free DB_ST");

	if (st->file)
		dcc_logbad(EX_SOFTWARE, "duplicate DB_ST use?");

	db_sts_free_head = st->fwd;
	if (db_sts_free_head)
		db_sts_free_head->bak = 0;
	else
		db_sts_free_tail = 0;
	st->fwd = DB_ST_BUSY;
	st->bak = DB_ST_BUSY;
	st->file = file;
	st->lineno = lineno;

	return st;
}



void
free_db_st(DB_ST *st)
{
	DB_ST_VALID(st, "freeing");

	rel_db_st(st);

	if (hctl_st == st) {
		hctl_st = 0;
		hctl = 0;
	} else if (db_parms_st == st) {
		db_parms_st = 0;
		cur_db_parms = 0;
	}

	memset(st, 0, sizeof(*st));
	st->bak = db_sts_free_tail;
	if (db_sts_free_tail) {
		db_sts_free_tail->fwd = st;
	} else {
		db_sts_free_head = st;
	}
	db_sts_free_tail = st;
}



static inline void
free_db_sts(void)
{
	DB_ST *st;

	for (st = db_sts; st <= LAST(db_sts); ++st) {
		if (st->fwd == DB_ST_BUSY)
			free_db_st(st);
	}
}



static void
rel_db_st(DB_ST *st)
{
	DB_BUF *b;

	DB_ST_VALID(st, "releasing");

	b = st->b;
	if (!b)
		return;

	if (hctl_st == st)
		hctl = 0;
	else if (db_parms_st == st)
		cur_db_parms = 0;

	if (--b->lock_cnt < 0)
		dcc_logbad(EX_SOFTWARE, "negative database buffer lock");
	st->b = 0;
	st->d.c = 0;
	st->s.rptr = DB_PTR_BAD;
}



static void
rel_db_sts(void)
{
	DB_ST *st;

	for (st = db_sts; st <= LAST(db_sts); ++st) {
		if (st->fwd == DB_ST_BUSY)
			rel_db_st(st);
	}
}



/* Unmap blocks to
 *	1. reduce the footprint of an idle daemon
 *	2. make room for dbclean with the expectation that the files will
 *	    be discarded.
 *	3. forget old files and get ready to use newly cleaned files
 *	4. get ready to reboot with the expectation of rebuilding the
 *	    hash table and recomputing any non-urgent checksum changes.
 *	    Invalidate and discard the hash table to avoid spending seconds
 *	    writing it to disk unless we have an SSD or it is clean.
 *	5. get ready to reboot with both files clean
 *	6. ready to restart the daemon,
 *	    and so send all urgent changes to the disk
 */
static int					/* -1=problem else # flushed */
db_unload_sub(DCC_EMSG *emsg, int unloaded,
	      DB_BUF_TYPE type, DB_UNLOAD_MODE mode)
{
	BUF_UNMAP_MODE unmap_mode;
	DB_BUF *b;

	unmap_mode = BUF_UNMAP_RELEASE;
	switch (mode) {
	case DB_UNLOAD_RELEASE:		/* #6 */
		break;

	case DB_UNLOAD_INVALIDATE:	/* #3 */
		unmap_mode = BUF_UNMAP_INVALIDATE;
		break;

	case DB_UNLOAD_ONE:		/* #1 */
		unmap_mode = BUF_UNMAP_SAVE_ALL;
		break;

	case DB_UNLOAD_ENOUGH:		/* #2 */
		/* Send the entire buffer to the disk when unloading for
		 * dbclean, because we will probably not re-map it to
		 * invalidate it.  Avoid accumulating dirty pages of old
		 * versions of the database. */
		unmap_mode = BUF_UNMAP_SAVE_ALL;
		break;

	case DB_UNLOAD_REBOOT:		/* #4 */
	case DB_UNLOAD_REBOOT_CLEAN:	/* #5 */
		dcc_logbad(EX_SOFTWARE, "bad db_unload_sub() mode");
		break;
	}

	for (b = buf_oldest; b != 0; b = b->newer) {
		if (b->lock_cnt != 0)
			dcc_logbad(EX_SOFTWARE,
				   "locked buffer in db_unload_sub()");

		if (b->buf_type == DB_BUF_TYPE_FREE
		    || (b->buf_type != type && type != DB_BUF_TYPE_FREE))
			continue;

		/* If unloading only enough for dbclean, then
		 * stop if we have RAM for the current files
		 * plus the current resident set plus an extra buffer
		 * in case we are expanding the hash table.
		 * We cannot stop when we have enough RAM, because
		 * all private blocks must be published. */
		if (mode == DB_UNLOAD_ENOUGH
		    && !(b->flags & DB_BUF_FG_PRIVATE)
		    && db_max_rss > (db_fsize + db_hash_fsize
				     + db_buf_bytes
				     + db_blksize)
		    && (b->dirt.num != 0 || b->dirt_urgent.num != 0))
			continue;

		if (!buf_unmap(unloaded < 0 ? 0 : emsg, b, unmap_mode, 1)) {
			unloaded = -1;
		} else {
			++unloaded;
		}

		if (mode == DB_UNLOAD_ONE)
			return unloaded;
	}

	return unloaded;
}



/* Should the hash table be discarded befor rebooting?
 *	caller must use buf_all_clean(emsg, 0, 0, BUF_CLEAN_URGENT) */
static u_char				/* 1=discard it */
hash_discard(void)
{
	DB_BUF *b;
	u_int kbytes;

	/* Do not discard the hash table
	 *	if we have an SSD which can quickly receive the hash table
	 *	    and would have the hash table written to it by rebuild
	 *	    after the reboot
	 *	or if the disk is already up to date. */
	if (ssd_mode || disk_hash_ok)
		return 0;

	kbytes = 0;
	for (b = buf_oldest; b != 0; b = b->newer) {
		if (b->buf_type != DB_BUF_TYPE_HASH)
			continue;
		kbytes += b->dirt.num * bufpart_kbytes;

		/* Discard the hash table if too much writing
		 * would be needed to save it. */
		if (kbytes > kbytes_per_flush)
			return 1;
	}
	return 0;
}



/* Unmap blocks to
 *	1. reduce the footprint of an idle daemon
 *	2. make room for dbclean with the expectation that the files will
 *	    be discarded.
 *	3. forget old files and get ready to use newly cleaned files
 *	4. get ready to reboot with the expectation of rebuilding the
 *	    hash table and recomputing any non-urgent checksum changes.
 *	    Invalidate and discard the hash table to avoid spending seconds
 *	    writing it to disk unless we have an SSD or it is clean.
 *	5. get ready to reboot with both files clean
 *	6. ready to restart the daemon,
 *	    and so send all urgent changes to the disk
 */
int					/* -1=problem else # flushed */
db_unload(DCC_EMSG *emsg, DB_UNLOAD_MODE mode)
{
	int done;


	rel_db_sts();

	done = 0;

	switch (mode) {
	case DB_UNLOAD_RELEASE:		/* #6 */
	case DB_UNLOAD_INVALIDATE:	/* #3 */
	case DB_UNLOAD_ENOUGH:		/* #2 unload until dbclean has room */
		done = db_unload_sub(emsg, done, DB_BUF_TYPE_FREE, mode);
		break;

	case DB_UNLOAD_ONE:		/* #1 */
		done = db_unload_sub(emsg, 0, DB_BUF_TYPE_FREE,
				     DB_UNLOAD_ONE);
		/* fsync() a file when there are no more buffers to clean. */
		if (done == 0 && !db_sync(emsg, 0))
			done = -1;
		break;

	case DB_UNLOAD_REBOOT:		/* #4, start closing for reboot */
		/* Save the hash table only if we will keep it. */
		if (hash_discard()) {
			if (!buf_all_clean(emsg, 0, 0, BUF_CLEAN_DB))
				done = -1;
		} else {
			if (!buf_all_clean(emsg, 0, 0, BUF_CLEAN_ALL))
				done = -1;
		}
		break;

	case DB_UNLOAD_REBOOT_CLEAN:	/* #5 start closing for clean reboot */
		if (!buf_all_clean(emsg, 0, 0, BUF_CLEAN_ALL))
			done = -1;
		break;
	}

	return done;
}



static u_char
buf_write(DCC_EMSG *emsg, DB_BUF *b, u_int data_offset, void *data, int len)
{
	off_t offset;
	int i;

	offset = BUF_OFFSET(b) + data_offset;

	if (offset != lseek(type2fd(b->buf_type), offset, SEEK_SET)) {
		db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
			   "buf_write lseek(%s,"OFF_HPAT"): %s",
			   buf2path(b), offset, ERROR_STR());
		return 0;
	}
	i = write(type2fd(b->buf_type), data, len);
	if (i != len) {
		db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
			   "buf_write(%s,%u)=%d: %s",
			   buf2path(b), len, i, ERROR_STR());
		return 0;
	}

	return 1;
}



/* Send data in part of a block to the kernel buffer cache.  */
static u_char
buf_clean_part(DCC_EMSG *emsg, DB_BUF *b, u_int *kqueued, u_int pno)
{
	DB_BLK_OFF flush_start, flush_len;
	u_char result;

	/* Send a new buffer to the kernel buffer cache at once. */
	if (b->flags & DB_BUF_FG_ANON_EXTEND) {
		DB_BUF *b1, *b0;

		/* To give the file system a chance to make the hash table
		 * contiguous, first write all preceding new buffers. */
		do {
			/* Find the earliest block at or before the target. */
			b0 = b;
			for (b1 = buf_oldest; b1 != 0; b1 = b1->newer) {
				if (!(b1->flags & DB_BUF_FG_ANON_EXTEND)
				    || b1->buf_type != b0->buf_type
				    || b1->blk_num > b0->blk_num)
					continue;
				b0 = b1;
			}
			b0->flags &= ~DB_BUF_FG_ANON_EXTEND;
			if (!buf_write(emsg, b0, 0, b0->buf.c, db_blksize))
				return 0;
			if (kqueued)
				*kqueued += (db_blksize + 1023) / 1024;
			/* Clear the dirty bits and the counts of dirty bits. */
			memset(&b0->dirt, 0, sizeof(b0->dirt));
			memset(&b0->dirt_urgent, 0, sizeof(b0->dirt_urgent));
		} while (b0 != b);
		return 1;
	}

	result = 1;

	flush_start = bufpart_size * pno;
	flush_len = bufpart_size;
	if (flush_len > db_blksize - flush_start)
		flush_len = db_blksize - flush_start;

	if (b->flags & DB_BUF_FG_PRIVATE) {
		/* write() a changed part of a private buffers to the disk.
		 *
		 * On FreeBSD you cannot write() to the file beneath a
		 * mmap() region from the region. */
		if (wbuf_len < flush_len) {
			/* The block size for the current file
			 * might differ from that of the previous file. */
			if (wbuf)
				free(wbuf);
			wbuf_len = flush_len;
			if (wbuf_len < bufpart_size)
				wbuf_len = bufpart_size;
			wbuf = malloc(wbuf_len);
		}
		memcpy(wbuf, &b->buf.c[flush_start], flush_len);
		if (!buf_write(emsg, b, flush_start, wbuf, flush_len))
			result = 0;
	} else {
		/* Send a changed part of a buffer toward the disk.
		 * We will msync() whole system pages, because bufpart_size
		 * is a multiple of the system page size. */
		if (0 > MSYNC(&b->buf.c[flush_start], flush_len, MS_ASYNC)) {
			db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
				   "msync(%s,%#lx,%#x,MS_ASYNC): %s",
				   buf2path(b),
				   (long)&b->buf.c[flush_start],
				   flush_len, ERROR_STR());
			result = 0;
		}
	}

	if (GET_DIRT(b, pno))
		CLR_DIRT(b, pno);
	if (GET_DIRT_URGENT(b, pno))
		CLR_DIRT_URGENT(b, pno);
	if (kqueued)
		*kqueued += (flush_len + 1023) / 1024;

	return result;
}



static inline int
find_db_bit(DB_BIT w)
{
#if defined(HAVE_BUILTIN_FFSL)
	return __builtin_ffsl(w);
#elif defined(HAVE_FFSL)
	return ffsl(w);
#else
	int n;

	if (w == 0)
		return 0;
	w &= -w;			/* isolate the least significant bit */
	n = 1;
#ifdef HAVE_64BIT_LONG
	if (w & 0xffffffff00000000UL) {
		n += 32;
		w >>= 32;
	}
#endif
	if (w & 0xffff0000) {
		n += 16;
		w >>= 16;
	}
	if (w & 0xff00) {
		n += 8;
		w >>= 8;
	}
	if (w & 0xf0) {
		n += 4;
		w >>= 4;
	}
	if (w & 0xc) {
		n += 2;
		w >>= 2;
	}
	if (w & 0x2)
		n += 1;
	return n;
#endif
}



/* Publish the changed parts of a block to the kernel buffer cache
 * and toward the disk. */
static u_char
buf_clean(DCC_EMSG *emsg, DB_BUF *b, u_int *kqueued, u_int max_kbytes,
	  BUF_CLEAN_MODE mode)
{
	DB_BIT w;
	u_int wno;
	int bitno;
	u_char result;

	if (b->buf_type == DB_BUF_TYPE_FREE)
		dcc_logbad(EX_SOFTWARE, "cleaning free buffer");
	if (b->lock_cnt != 0)
		dcc_logbad(EX_SOFTWARE, "cleaning locked buffer");

	switch (mode) {
	case BUF_CLEAN_ALL:
		/* Send all changes to the disk with msync() or write(). */
		break;

	case BUF_CLEAN_URGENT:
		/* Send urgent changes to the disk with msync(). */
		break;

	case BUF_CLEAN_DB:
		/* Publish checksum changes with msync() or write(). */
		if (b->buf_type == DB_BUF_TYPE_DB)
			mode = BUF_CLEAN_ALL;
		else
			mode = BUF_CLEAN_URGENT;
		break;
	}

	result = 1;
	wno = 0;
	for (;;) {
		/* Clean one bit in the bit mask(s) per iteration. */
		w = b->dirt_urgent.w[wno];
		if (mode != BUF_CLEAN_URGENT)
			w |= b->dirt.w[wno];

		if (w == 0) {
			if (b->dirt_urgent.num == 0
			    && (mode == BUF_CLEAN_URGENT || b->dirt.num == 0))
				break;
			if (++wno >= DIM(b->dirt.w))
				dcc_logbad(EX_SOFTWARE, "bad buf dirt count");
			continue;
		}

		/* Clean one part of the buffer.
		 *
		 * A dirty, private buffer is not visible to other processes
		 * and so requires that the database be locked and marked
		 * inconsistent in the kernel buffer cache. */
		if (b->flags & DB_BUF_FG_PRIVATE) {
			if (!DB_IS_LOCKED())
				dcc_logbad(EX_SOFTWARE,
					   "dirty unlocked database");
			if (kcache_ok)
				dcc_logbad(EX_SOFTWARE,
					   "dirt in clean database");
		}

		bitno = find_db_bit(w);
		if (bitno == 0)
			dcc_logbad(EX_SOFTWARE, "bad buf_clean() bits");

		if (!buf_clean_part(emsg, b, kqueued, wno*PARTBITS + bitno-1))
			result = 0;

		if (kqueued && max_kbytes != 0
		    && *kqueued > max_kbytes
		    && !ssd_mode)
			break;
	}

	return result;
}



static u_char
buf_all_clean(DCC_EMSG *emsg, u_int *kqueued, u_int max_kbytes,
	      BUF_CLEAN_MODE mode)
{
	DB_BUF *b;
	u_char result;

	result = 1;

	for (b = buf_oldest; b != 0; b = b->newer) {
		if (b->buf_type == DB_BUF_TYPE_FREE)
			continue;
		if (kqueued && max_kbytes != 0
		    && *kqueued > max_kbytes
		    && !ssd_mode)
			break;
		if (!buf_clean(emsg, b, kqueued, max_kbytes, mode))
			result = 0;
	}

	return result;
}



/* Try to keep the data clean so that the fsync() when the file is unloaded
 * is not too expensive. Try to msync() frequently so that we don't stall
 * as long in msync().
 */
void
dccd_flush(u_char trace)
{
	DB_BUF *b;
	u_int kbytes, parts, urgent_parts;

	rel_db_sts();

	kbytes = 0;
	for (b = buf_oldest; b != 0; b = b->newer) {
		if (b->buf_type == DB_BUF_TYPE_FREE)
			continue;

		/* switch to the required buffer type. */
		if (DB_BUF_MODE_B(b) != ((b->flags & DB_BUF_FG_PRIVATE)
					 ? DB_BUF_MODE_PRIVATE
					 : DB_BUF_MODE_SHARED)) {
			buf_unmap(0, b, BUF_UNMAP_SAVE_ALL, 1);
			continue;
		}

		/* Push some urgent changes (which are changes that cannot be
		 * recreated by dbclean) to the disk. */
		buf_clean(0, b, &kbytes, kbytes_per_flush,
			  BUF_CLEAN_URGENT);
	}

	/* Limit the stall from writing non-urgent changes when the system
	 *	stops by pushing them to the disk now.  There is no stalling
	 *	with an SSD.
	 * Do not push non-urgent hash changes to the disk, in the hope
	 *	that they will be discarded without being sent to the disk. */
	if (!ssd_mode)
		buf_all_clean(0, &kbytes, kbytes_per_flush, BUF_CLEAN_DB);

	parts = 0;
	urgent_parts = 0;
	for (b = buf_oldest; b != 0; b = b->newer) {
		if (b->buf_type == DB_BUF_TYPE_DB) {
			parts += b->dirt.num;
			urgent_parts += b->dirt_urgent.num;
		}
	}

	if (trace && kbytes != 0)
		dcc_trace_msg("%s cleaned  %s %s dirty in %s",
			      size2str(0, 0, kbytes*1024, 1),
			      size2str(0, 0, urgent_parts*bufpart_size, 1),
			      size2str(0, 0, parts*bufpart_size, 1),
			      db_nm_path.c);

	db_need_flush_secs = 0;
	gettimeofday(&db_time, 0);
	if (kbytes != 0 || parts != 0 || urgent_parts != 0)
		set_db_need_flush_secs();
}



/* Push the checksums to the system buffer cache for dbclean. */
u_char
dbclean_flush(DCC_EMSG *emsg)
{
	return db_share(emsg);
}



/* The buffer used by one of the state blocks is dirty. */
static void
mark_st_dirty(DB_ST *st, u_char urgent, u_int len)
{
	DB_BLK_OFF mark_start, mark_end;
	u_int pno;

	if (db_rdonly)
		dcc_logbad(EX_SOFTWARE, "changing read-only data");
	if (!DB_IS_LOCKED())
		dcc_logbad(EX_SOFTWARE, "changing unlocked database");

	/* Mark all of the affected parts of the block.
	 * Never is more than the single buffer affected,
	 * but two parts can be. */
	mark_start = st->d.c - st->b->buf.c;
	mark_end = mark_start + len;
	if (mark_end > db_blksize)
		dcc_logbad(EX_SOFTWARE, "dirty data past end of buffer");

	pno = OFF2PNO(mark_start);
	do {
		if (urgent && !GET_DIRT_URGENT(st->b, pno))
			SET_DIRT_URGENT(st->b, pno);
		if (!GET_DIRT(st->b, pno))
			SET_DIRT(st->b, pno);
		++pno;
	} while (pno * bufpart_size < mark_end);

	set_db_need_flush_secs();
}



static u_char
set_hctl_clean(DCC_EMSG *emsg)
{
	DB_BUF *b;
	u_char changed, result;

	changed = 0;
	result = 1;

	if (!map_hctl(emsg, 0))
		return 0;

	if (!(hctl->fgs & HCTL_FG_KCACHE_OK)) {
		hctl->fgs |= HCTL_FG_KCACHE_OK;
		changed = 1;
	}

	if (disk_db_ok && disk_hash_ok && !(hctl->fgs & HCTL_FG_SYNC_OK)) {
		hctl->fgs |= HCTL_FG_SYNC_OK;
		hctl->sync_sec = time(0);
		changed = 1;
	}

	/* Mark hctl dirty so that we can change hctl->fgs
	 * without undoing what we are doing. */
	if (changed) {
		kcache_ok = 0;
		mark_st_dirty(hctl_st, 1, sizeof(HCTL));
	}

	b = hctl_st->b;
	rel_db_sts();
	if (changed) {
		if (b->flags & DB_BUF_FG_PRIVATE) {
			result = buf_unmap(emsg, b, BUF_UNMAP_SAVE_ALL, 1);
		} else {
			result = buf_clean(emsg, b, 0, 0, BUF_CLEAN_ALL);
		}
	}

	kcache_ok = 1;

	return result;
}



/* mark part of a buffer dirty or in need of being synchronized to the disk.
 *	"Urgent" changes are flushed by a timer.  Ordinary changes
 *	are often ignored and expected to be rebuilt if the system crashes. */
void
db_dirty_data(DB_ST *st, u_char urgent, u_int len)
{
	make_db_dirty(0, st->b->buf_type);
	mark_st_dirty(st, urgent, len);
}



/* see if (another) instance of dbclean is already running */
static int dbclean_lock_fd = -1;
static DCC_PATH dbclean_lock_nm;

u_char					/* 1=no (other) dbclean */
lock_dbclean(DCC_EMSG *emsg, const char *cur_db_nm)
{
	char pid[32];
	int i;

	dcc_fnm2rel_good(&dbclean_lock_nm, cur_db_nm, DB_LOCK_SUFFIX);
	dbclean_lock_fd = dcc_lock_open(emsg, dbclean_lock_nm.c,
					O_RDWR|O_CREAT,
					DCC_LOCK_OPEN_NOWAIT,
					DCC_LOCK_ALL_FILE, 0);
	if (dbclean_lock_fd < 0)
		return 0;

	i = 1+snprintf(pid, sizeof(pid), "%ld\n", (long)getpid());
	if (i != write(dbclean_lock_fd, pid, i))
		dcc_logbad(EX_IOERR, "write(%s, pid): %s",
			   dbclean_lock_nm.c, ERROR_STR());

	/* Let anyone write in it in case we are running as root
	 * and get interrupted by a crash or gdb.  A stray, stale
	 * private lock file cannot be locked */
	chmod(dbclean_lock_nm.c, 0666);

	return 1;
}



void
unlock_dbclean(void)
{
	if (dbclean_lock_fd >= 0) {
		unlink_whine(0, dbclean_lock_nm.c, 0);
		close(dbclean_lock_fd);
		dbclean_lock_fd = -1;
	}
}



/* This locking does only multiple-readers/single-writer */
int					/* -1=failed, 0=was not locked, 1=was */
db_lock(void)
{
	struct stat sb;

	if (DB_IS_LOCKED())
		return 1;

	if (!dcc_exlock_fd(0, db_fd, DCC_LOCK_ALL_FILE, 15*60, "", db_nm.c))
		return -1;
	if (0 > fstat(db_fd, &sb)) {
		db_failure(__LINE__,__FILE__, EX_IOERR, 0,
			   "stat(%s): %s", db_nm.c, ERROR_STR());
		return -1;
	}
	if (db_fsize != (DB_HOFF)sb.st_size) {
		if (db_fsize > (DB_HOFF)sb.st_size || !db_rdonly) {
			db_failure(__LINE__,__FILE__, EX_IOERR, 0,
				   "%s size unexpectedly changed from "
				   OFF_HPAT" to "OFF_HPAT,
				   db_nm.c, db_fsize, sb.st_size);
			return -1;
		}
		db_fsize = sb.st_size;
	}

	db_locked = db_time;
	return 0;
}



static u_char
fsync_type(DCC_EMSG *emsg, DB_BUF_TYPE type, u_char write_hctl)
{
	DB_BUF *b;
	u_char result;

	result = 1;
	for (b = buf_oldest; b != 0; b = b->newer) {
		/* Write private buffers, because fsync() only synchronizes
		 * data in the file buffer cache.  Incidentally msync()
		 * shared buffers and clear their dirty bits. */
		if (b->buf_type == type
		    && !buf_clean(emsg, b, 0, 0, BUF_CLEAN_ALL)) {
			emsg = 0;
			result = 0;
		}
	}

	/* Make the file on the disk consistent before marking it. */
	if (0 > fsync(type2fd(type))) {
		db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
			   "fsync(%s): %s", buf_type2path(type), ERROR_STR());
		return 0;
	}

	if (type == DB_BUF_TYPE_DB) {
		disk_db_ok = 1;
	} else {
		disk_hash_ok = 1;
	}

	/* Mark the kernel buffer cache consistent. */
	if (write_hctl && !set_hctl_clean(emsg)) {
		emsg = 0;
		result = 0;
	}

	return result;
}



/* Send the meta-data to disk (after writing any buffers that might
 * extend the files) so that other processes such as dbclean can find
 * the new length of the file.  Otherwise the file looks broken,
 * because its internally claimed data length can be larger than its
 * inode size on Solaris. */
static u_char
fix_meta(DCC_EMSG *emsg, DB_BUF_TYPE type)
{
	int fd;
	struct stat sb;
	DB_PTR fsize;
	u_char result, need_fsync;

	fd = type2fd(type);
	if (fd < 0)
		return 1;

	result = 1;
	need_fsync = 0;
	fsize = (type == DB_BUF_TYPE_DB) ? db_fsize : db_hash_fsize;
	if (0 > fstat(fd, &sb)) {
		dcc_error_msg("fstat(%s): %s",
			      buf_type2path(type), ERROR_STR());
		need_fsync = 1;
		result = 0;

	} else if (fsize != (DB_HOFF)sb.st_size) {
		if (db_debug)
			quiet_trace_msg("need fsync(%s) because fsize="
					OFF_HPAT" but stat="OFF_HPAT,
					buf_type2path(type), fsize,
					sb.st_size);
		need_fsync = 1;
	}

	if (need_fsync && !fsync_type(emsg, type, 0))
		result = 0;

	return result;
}



/* Mark the database consistent for concurrent read() or mmap() by sending all
 * changes to the kernel buffer cache but not necessarily toward the disk. */
static u_char
db_share(DCC_EMSG *emsg)
{
	DB_BUF *b;
	u_char result;

	result = !db_failed_line;

	if (kcache_ok)
		return result;

	/* Releasing all buffers declares that the kernel cache is accurate
	 * except for private buffers. */
	rel_db_sts();

	/* Share all private buffers.
	 * About MAP_PRIVATE the Linux mmap man page says
	 *	It is unspecified whether changes made to the file after the
	 *	mmap() call are visible in the mapped region.
	 * That implies that we must munmap() all MAP_PRIVATE blocks when
	 * we unlock the file and use mmap(MAP_SHARED) while the file is
	 * unlocked.
	 * dbclean_running and DB_BUF_MODE_B() enforce that
	 * when we re-mmap() blocks. */
	for (b = buf_oldest; b != 0; b = b->newer) {
		if (b->flags & DB_BUF_FG_PRIVATE) {
			if (!buf_unmap(emsg, b, BUF_UNMAP_SAVE_ALL, 1)) {
				emsg = 0;
				result = 0;
			}
		}
	}

	if (!set_hctl_clean(emsg)) {
		emsg = 0;
		result = 0;
	}

	/* Make stat() on each file give the right values. */
	if (!fix_meta(emsg, DB_BUF_TYPE_DB)) {
		emsg = 0;
		result = 0;
	}
	if (!fix_meta(emsg, DB_BUF_TYPE_HASH)) {
		emsg = 0;
		result = 0;
	}

	return result;
}


/* Make and mark the database and/or the hash table clean and stable against
 * crashes or rebooting. */
static u_char
db_sync(DCC_EMSG *emsg, u_char both)
{
	u_char fsync_hash, result;
	int was_locked;

	if (db_fd < 0)
		return 0;

	was_locked = db_lock();
	if (was_locked < 0)
		return 0;

	result = !db_failed_line;

	fsync_hash = !disk_hash_ok && db_hash_fd >= 0;

	if (!disk_db_ok) {
		if (!fsync_type(emsg, DB_BUF_TYPE_DB, 0)) {
			emsg = 0;
			result = 0;
		}
		if (!both)
			fsync_hash = 0;
	}
	if (fsync_hash) {
		if (!fsync_type(emsg, DB_BUF_TYPE_HASH, 1)) {
			emsg = 0;
			result = 0;
		}
	}

	rel_db_sts();

	if (!was_locked)
		db_unlock();
	return result;
}



/* Assume a new block, ordinary, not DB_BUF_FG_PRIVATE buffer is filled with
 * unknown changes the first time it is mapped.  The assumed hash table
 * changes are not urgent, but the assumed database changes are urgent. */
static void
assume_dirty_blk(DB_BUF *b)
{
	DB_BIT *bits, bit;
	u_int pno;
	u_char set_one;
	u_int n;

	if (db_rdonly)
		return;

	/* Rely on the kernel syncer for private or write() blocks */
	if (b->flags & DB_BUF_FG_PRIVATE)
		return;

	bit = BLK_NUM2DIRTBIT(b->blk_num);
	n = BLK_NUM2DIRTWORD(b->blk_num);
	switch (b->buf_type) {
	case DB_BUF_TYPE_DB:
		if (n < DIM(assume_dirty.db))
			bits = &assume_dirty.db[n];
		else
			bits = 0;
		break;

	case DB_BUF_TYPE_HASH:
		if (n < DIM(assume_dirty.hash))
			bits = &assume_dirty.hash[n];
		else
			bits = 0;
		break;

	case DB_BUF_TYPE_FREE:
	default:
		dcc_logbad(EX_SOFTWARE, "impossible buffer type");
		break;
	}

	/* Assume the ends of files too big to fit in RAM are dirty. */
	if (bits) {
		/* Do nothing if we have already sync'ed the block. */
		if (!(*bits & bit))
			return;
		*bits &= ~bit;
	}

	set_one = 0;
	for (pno = 0; pno * bufpart_size < db_blksize; ++pno) {
		if (b->buf_type == DB_BUF_TYPE_DB) {
			if (!GET_DIRT_URGENT(b, pno)) {
				SET_DIRT_URGENT(b, pno);
				set_one = 1;
			}
		} else {
			if (!GET_DIRT(b, pno)) {
				SET_DIRT(b, pno);
				set_one = 1;
			}
		}
	}
	if (set_one)
		set_db_need_flush_secs();
}



/* Update non-urgent dirtiness of currently mapped blocks after making a
 * change in the dirtiness assumptions. */
static void
assume_dirty_blks(void)
{
	DB_BUF *b;

	for (b = buf_oldest; b != 0; b = b->newer) {
		if (b->buf_type == DB_BUF_TYPE_FREE)
			continue;
		assume_dirty_blk(b);
	}
}



/* Mark a block as needing msync() if we later mmap() it. */
static void
set_assume_dirty(const DB_BUF *b)
{
	DB_BIT bit;
	u_int n;

	if ((b->flags & DB_BUF_FG_PRIVATE)
	    && (b->dirt.num != 0 || b->dirt_urgent.num != 0)) {
		bit = BLK_NUM2DIRTBIT(b->blk_num);
		n = BLK_NUM2DIRTWORD(b->blk_num);
		switch (b->buf_type) {
		case DB_BUF_TYPE_DB:
			if (n < DIM(assume_dirty.db))
				assume_dirty.db[n] |= bit;
			break;

		case DB_BUF_TYPE_HASH:
			if (n < DIM(assume_dirty.hash))
				assume_dirty.hash[n] |= bit;
			break;

		case DB_BUF_TYPE_FREE:
		default:
			dcc_logbad(EX_SOFTWARE, "impossible buffer type");
			break;
		}
	}
}



/* Mark the hash file inconsistent in the kernel buffer cache
 * and on the disk. */
static u_char
make_db_dirty(DCC_EMSG *emsg, DB_BUF_TYPE type)
{
	if (type == DB_BUF_TYPE_HASH) {
		if (!kcache_ok && !disk_hash_ok)
			return 1;
		disk_hash_ok = 0;
	} else {
		if (!kcache_ok && !disk_db_ok)
			return 1;
		disk_db_ok = 0;
	}

	if (!map_hctl(emsg, 0))
		return 0;
	mark_st_dirty(hctl_st, 1, sizeof(HCTL));
	hctl->fgs &= ~(HCTL_FG_KCACHE_OK | HCTL_FG_SYNC_OK);
	hctl->sync_sec = time(0);
	kcache_ok = 0;
	return buf_clean_part(emsg, hctl_st->b, 0, 0);
}



/* unlock the database */
u_char					/* 0=failed, 1=done */
db_unlock(void)
{
	int result;

	if (!DB_IS_LOCKED())
		return 1;

	/* Clear the dirty bit, because	dbclean needs to see that.  */
	result = db_share(0);

	if (!dcc_unlock_fd(0, db_fd, DCC_LOCK_ALL_FILE, "", db_nm.c))
		result = 0;

	db_locked.tv_sec = 0;
	return result;
}



u_char
unlink_whine(DCC_EMSG *emsg, const char *nm, u_char enoent_ok)
{
	if (0 > unlink(nm)
	    && (!enoent_ok || errno != ENOENT)) {
		db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
			   "unlink(%s): %s", nm, ERROR_STR());
		return 0;
	}
	return 1;
}



static u_char
close_hash(void)
{
	if (db_hash_fd >= 0) {
		if (0 > close(db_hash_fd)) {
			dcc_error_msg("close(%s): %s",
				      db_hash_nm_path.c, ERROR_STR());
			return 0;
		}
		db_hash_fd = -1;
	}
	return 1;
}



/* Shut the database down to one of the following states:
 *  DB_CLOSE_FORK
 *	Close the file descriptors without changing the files.
 *  DB_CLOSE
 *	The database is marked clean and all buffers are shared.
 *  DB_CLOSE_REBOOT
 *	same as DB_STABLE except that the hash table can be invalidated
 *	and deleted for speed.
 *  DB_CLOSE_STABLE
 *	Both files on stable storage and marked clean.
 *  DB_CLOSE_DISCARD_ALL
 *	all buffers should be invalidated.
 *  DB_CLOSE_NEW_DB
 *	switch dccd to cleaned database
 */
u_char
db_close(DB_CLOSE_MODE mode)
{
	u_char result;

	if (db_fd < 0 && db_hash_fd < 0)
		return 1;

	result = 1;

	free_db_sts();

	switch (mode) {
	case DB_CLOSE_FORK:
		if (db_unload(0, DB_UNLOAD_RELEASE) < 0)
			result = 0;
		break;

	case DB_CLOSE:
		if (!db_share(0))
			result = 0;
		if (db_unload(0, DB_UNLOAD_RELEASE) < 0)
			result = 0;
		break;

	case DB_CLOSE_REBOOT:
		if (hash_discard()) {
			/* The database must be cleaned when it is reopened
			 * after the reboot, because there will be no
			 * the hash table */
			if (0 > db_unload_sub(0, 0, DB_BUF_TYPE_HASH,
					      DB_UNLOAD_INVALIDATE))
				result = 0;
			if (db_hash_nm.c[0] != '\0')
				unlink_whine(0, db_hash_nm.c, 0);
			if (!close_hash())
				result = 0;
		}
		if (!db_sync(0, 1))
			result = 0;
		if (!db_unload(0, DB_UNLOAD_RELEASE))
			result = 0;
		break;

	case DB_CLOSE_STABLE:
		/* Close and mark everything clean and synchronized
		 * so that no cleaning is needed after the reboot. */
		if (!db_sync(0, 1))
			result = 0;
		if (!db_unload(0, DB_UNLOAD_RELEASE))
			result = 0;
		break;

	case DB_CLOSE_DISCARD_ALL:
	case DB_CLOSE_NEW_DB:
		/* Invalidate all buffers */
		if (db_unload(0, DB_UNLOAD_INVALIDATE) < 0)
			result = 0;
		break;
	}

	/* Close the hash table first because the server is often
	 * waiting for the lock on the data file held by dbclean,
	 * and dbclean should close both files before dccd goes. */
	if (!close_hash())
		result = 0;

	if (db_fd >= 0) {
		if (0 > close(db_fd)) {
			dcc_error_msg("close(%s): %s",
				      db_nm_path.c, ERROR_STR());
			result = 0;
		}
		db_fd = -1;
	}

	if (wbuf) {
		free(wbuf);
		wbuf = 0;
		wbuf_len = 0;
	}

	kcache_ok = 1;
	disk_hash_ok = 1;
	disk_db_ok = 1;
	db_locked.tv_sec = 0;
	return result;
}



#if defined(RLIMIT_AS) || defined(RLIMIT_RSS) || defined(RLIMIT_FSIZE)
static DB_PTR
use_rlimit(int resource, const char *rlimit_nm,
	   DB_PTR cur_val, DB_PTR min_val, const char *val_nm)
{
	struct rlimit limit_old, limit_new;
	DB_PTR new_val;

	if (0 > getrlimit(resource, &limit_old)) {
		dcc_error_msg("getrlimit(%s): %s", rlimit_nm, ERROR_STR());
		return cur_val;
	}

	if ((DB_PTR)limit_old.rlim_cur >= cur_val+DB_PAD_BYTE)
		return cur_val;

	/* assume we are root and try to increase the hard limit */
	if ((DB_PTR)limit_new.rlim_max < cur_val+DB_PAD_BYTE) {
		limit_new = limit_old;
		limit_new.rlim_max = cur_val+DB_PAD_BYTE;
		if (0 > setrlimit(resource, &limit_new)) {
			if (db_debug)
				quiet_trace_msg("setrlimit(%s, "
						L_DPAT","L_DPAT"): %s",
						rlimit_nm,
						(DB_PTR)limit_new.rlim_cur,
						(DB_PTR)limit_new.rlim_max,
						ERROR_STR());
		} else {
			if (0 > getrlimit(resource, &limit_old)) {
				dcc_error_msg("getrlimit(%s): %s",
					      rlimit_nm, ERROR_STR());
				return cur_val;
			}
		}
	}

	limit_new = limit_old;
	if ((DB_PTR)limit_new.rlim_max < min_val+DB_PAD_BYTE)
		limit_new.rlim_max = min_val + DB_PAD_BYTE;
	limit_new.rlim_cur = limit_new.rlim_max;
	if ((DB_PTR)limit_new.rlim_cur > cur_val+DB_PAD_BYTE)
		limit_new.rlim_cur = cur_val+DB_PAD_BYTE;
	if (0 > setrlimit(resource, &limit_new)) {
		dcc_error_msg("setrlimit(%s, "L_DPAT","L_DPAT"): %s",
			      rlimit_nm,
			      (DB_PTR)limit_new.rlim_cur,
			      (DB_PTR)limit_new.rlim_max,
			      ERROR_STR());
		new_val = limit_old.rlim_cur - DB_PAD_BYTE;
		if (new_val < min_val)
			new_val = min_val;
	} else {
		if (limit_old.rlim_cur < limit_new.rlim_cur
		    && db_debug)
			quiet_trace_msg("increased %s from %s to %s",
					rlimit_nm,
					db_ptr2str(limit_old.rlim_cur),
#ifdef RLIM_INFINITY
					(limit_new.rlim_cur == RLIM_INFINITY)
					? "infinity" :
#endif
					db_ptr2str(limit_new.rlim_cur));
		new_val = limit_new.rlim_cur - DB_PAD_BYTE;
	}

	if (cur_val > new_val) {
		quiet_trace_msg("%s reduced %s from %s to %s",
				rlimit_nm, val_nm,
				db_ptr2str(cur_val),
				db_ptr2str(new_val));
		return new_val;
	}

	return cur_val;
}
#endif



static void
get_db_max_rss(void)
{
	DB_PTR old_val, new_val, db_min_mbyte, db_min_byte, db_max_mbyte;
	int physmem_str_len;
	DB_PTR physmem;
	u_char complain;

	complain = db_debug;

	/* use default maximum if maximum is bogus or unset by ./configure */
	db_max_mbyte = MAX_MAX_DB_MBYTE;
#if DCC_DB_MAX_MBYTE != 0
	db_max_mbyte = DCC_DB_MAX_MBYTE;
	if (db_max_mbyte < DB_MIN_MIN_MBYTE
	    || db_max_mbyte > MAX_MAX_DB_MBYTE) {
		quiet_trace_msg("ignore bad ./configure --with-max-db-mem=%d",
				DCC_DB_MAX_MBYTE);
		db_max_mbyte = MAX_MAX_DB_MBYTE;
	} else {
		if (db_max_mbyte < DB_NEEDED_MBYTE && !grey_on)
			complain = 1;
		if (complain) {
			quiet_trace_msg("DB max=%s"
					" from ./configure --with-max-db-mem=%d",
					mbyte2str(db_max_mbyte),
					DCC_DB_MAX_MBYTE);
		}
	}
#endif
#ifndef HAVE_BIG_FILES
	/* we need big off_t for files larger than 2 GBytes */
	if (db_max_mbyte > DB_MAX_2G_MBYTE) {
		old_val = db_max_mbyte;
		db_max_mbyte= DB_MAX_2G_MBYTE;
		if (complain)
			quiet_trace_msg("32-bit off_t reduced DB max from %s"
					" to %s",
					mbyte2str(old_val),
					mbyte2str(db_max_mbyte));
	}
#endif

	/* use default if ./configure --with-db-memory=MB is bogus or unset */
#if DCC_DB_MIN_MBYTE == 0
	db_min_mbyte = min(64, db_max_mbyte);
#else
	db_min_mbyte = DCC_DB_MIN_MBYTE;
	if (db_min_mbyte < DB_MIN_MIN_MBYTE) {
		quiet_trace_msg("ignore bad ./configure --with-db-memory=%d",
				DCC_DB_MIN_MBYTE);
		db_min_mbyte = DB_DEF_MIN_MBYTE;
	} else if (db_min_mbyte > db_max_mbyte) {
		quiet_trace_msg("ignore ./configure --with-db-memory=%d"
				" that is > DB max=%s",
				mbyte2str(db_max_mbyte));
		db_min_mbyte = DB_DEF_MIN_MBYTE;
	} else if (complain) {
		quiet_trace_msg("use ./configure --with-db-memory=%d",
				db_min_mbyte);
	}
#endif

	db_min_byte = db_min_mbyte * (1024*1024);
	db_max_byte = db_max_mbyte * (1024*1024);

#ifdef RLIMIT_FSIZE
	db_max_mbyte = (use_rlimit(RLIMIT_FSIZE, "RLIMIT_FSIZE",
				   db_max_byte, db_min_byte, "DB max")
			/ (1024*1024));
	db_max_byte = db_max_mbyte * (1024*1024);
#endif /* RLIMIT_FSIZE */

	physmem = 0;
#ifdef HAVE_PHYSMEM_TOTAL
	/* maybe someday physmem_total() will be widely available */
	physmem = physmem_total();
	if (physmem/(1024*1024) < DB_NEEDED_MBYTE && !grey_on)
		complain = 1;
	if (complain)
		quiet_trace_msg("real=%s from physmem_total()",
				db_ptr2str(physmem));
#endif
#ifdef HAVE__SC_PHYS_PAGES
	if (physmem == 0) {
		long pages, sizepage;

		if ((pages = sysconf(_SC_PHYS_PAGES)) == -1) {
			dcc_error_msg("sysconf(_SC_PHYS_PAGES): %s",
				      ERROR_STR());
		} else if ((sizepage = sysconf(_SC_PAGESIZE)) == -1) {
			dcc_error_msg("sysconf(_SC_PAGESIZE): %s",
				      ERROR_STR());
		} else {
			physmem = (DB_PTR)pages * (DB_PTR)sizepage;
			if (physmem/(1024*1024) < DB_NEEDED_MBYTE && !grey_on)
				complain = 1;
			if (complain)
				quiet_trace_msg("real=%s"
						" from sysconf(_SC_PHYS_PAGES)"
						" and sysconf(_SC_PAGESIZE)",
						db_ptr2str(physmem));
		}
	}
#endif
#ifdef HAVE_HW_PHYSMEM
	if (physmem == 0) {
		int mib[2] = {CTL_HW, HW_PHYSMEM};
		unsigned long int hw_physmem;
		size_t hw_physmem_len;

		hw_physmem_len = sizeof(hw_physmem);
		if (0 > sysctl(mib, 2, &hw_physmem, &hw_physmem_len, 0,0)) {
			dcc_error_msg("sysctl(HW_PHYSMEM): %s", ERROR_STR());
		} else {
			physmem = hw_physmem;
			if (physmem/(1024*1024) < DB_NEEDED_MBYTE && !grey_on)
				complain = 1;
			if (complain)
				quiet_trace_msg("real=%s from sysctl(mib)",
						db_ptr2str(physmem));
		}
	}
#endif
#ifdef HAVE_PSTAT_GETSTATIC
	if (physmem == 0) {
		struct pst_static pss;

		if (0 > pstat_getstatic(&pss, sizeof pss, 1, 0)) {
			dcc_error_msg("pstat_getstatic(): %s", ERROR_STR());
		} else if (pss.physical_memory <= 0
			   || pss.page_size < 0) {
			dcc_error_msg("pstat_getstatic() says"
				      " physical_memory=%d page_size=%d",
				      pss.physical_memory, pss.page_size);
		} else {
			physmem = ((DB_PTR)pss.physical_memory
				   * (DB_PTR)pss.page_size);
			if (physmem/(1024*1024) < DB_NEEDED_MBYTE && !grey_on)
				complain = 1;
			if (complain)
				quiet_trace_msg("real=%s"
						" from pstat_getstatic()",
						db_ptr2str(physmem));
		}
	}
#endif

	physmem_str_len = 0;
	db_physmem_str[0] = '\0';
	if (physmem == 0) {
		quiet_trace_msg("failed to get real memory size");
	} else {
		physmem_str_len = snprintf(db_physmem_str,
					   sizeof(db_physmem_str),
					   "  real=%s",
					   db_ptr2str(physmem));
		if (physmem_str_len >= ISZ(db_physmem_str))
			physmem_str_len = ISZ(db_physmem_str)-1;
		/* Try to use
		 *	half of physical memory if it is smaller than 2 GBytes
		 *	all except 512 MBytes if it is between 2 and 4 GBytes,
		 *	all but 1 GByte if there are more than 4 GBytes
		 * fix FAQ.html if this changes. */
		if (physmem/(1024*1024) < 2*1024)
			new_val = physmem/2;
		else if (physmem/(1024*1024) <= 4*1024)
			new_val = physmem - 512UL*(1024*1024);
		else
			new_val = physmem - 1024UL*(1024*1024);
		if (new_val < db_min_byte) {
			if (!grey_on)
				complain = 1;
			if (complain)
				quiet_trace_msg("real=%s would give DB max=%s"
						" smaller than minimum %s",
						db_ptr2str(physmem),
						db_ptr2str(new_val),
						mbyte2str(db_min_mbyte));
			new_val = db_min_byte;
		}
		if (db_max_byte > new_val) {
			old_val = db_max_byte;
			db_max_mbyte = new_val / (1024*1024);
			db_max_byte = db_max_mbyte * (1024*1024);
			if (db_max_byte < DB_NEEDED_MBYTE && !grey_on)
				complain = 1;
			if (complain)
				quiet_trace_msg("real=%s reduced DB max"
						" from %s to %s",
						db_ptr2str(physmem),
						db_ptr2str(old_val),
						db_ptr2str(db_max_byte));
		}
	}

	/* window need not be larger than the limit on the database size */
	db_max_rss = db_max_byte;

#ifdef RLIMIT_AS
	/* try not to break process virtual memory limit,
	 * but only if it is not ridiculously tiny */
	db_max_rss = use_rlimit(RLIMIT_AS, "RLIMIT_AS",
				db_max_rss, db_min_byte, "max RSS");
#endif /* RLIMIT_AS */
#ifdef RLIMIT_RSS
	/* try not to break process resident memory limit
	 * but only if it is not ridiculously tiny */
	db_max_rss = use_rlimit(RLIMIT_RSS, "RLIMIT_RSS",
				db_max_rss, db_min_byte, "max RSS");
#endif /* RLIMIT_RSS */

	/* limit the database to the window size */
	if (db_max_byte > db_max_rss) {
		old_val = db_max_mbyte;
		db_max_mbyte = db_max_rss / (1024*1024);
		db_max_byte = db_max_mbyte * (1024*1024);
		if (db_max_byte < DB_NEEDED_MBYTE && !grey_on)
			complain = 1;
		if (complain)
			quiet_trace_msg("max RSS reduced DB max from %s to %s",
					mbyte2str(old_val),
					mbyte2str(db_max_mbyte));
	}

#ifndef HAVE_64BIT_PTR
	/* We cannot use a window larger than 2 GBytes on most systems without
	 * big pointers.  Among the things that break is trying to mmap() more
	 * than 2 GBytes.  So limit the window on 32-bit systems to a little
	 * less than 2 GBytes and the database to not much more */
	if (db_max_rss > DB_MAX_2G_MBYTE*(1024*1024)) {
		if (complain)
			quiet_trace_msg("32-bit pointers reduced max RSS"
					" from %s to %s",
					db_ptr2str(db_max_rss),
					mbyte2str(DB_MAX_2G_MBYTE));
		db_max_rss = DB_MAX_2G_MBYTE*(1024*1024);
		new_val = db_max_rss+db_max_rss/4;
		if (db_max_byte > new_val) {
			old_val = db_max_mbyte;
			db_max_mbyte = new_val / (1024*1024);
			db_max_byte = db_max_mbyte * (1024*1024);
			if (complain)
				quiet_trace_msg("32-bit pointers reduced DB max"
						" from %s to %s",
						mbyte2str(old_val),
						mbyte2str(db_max_mbyte));
		}
	}
#endif

	snprintf(&db_physmem_str[physmem_str_len],
		 sizeof(db_physmem_str) - physmem_str_len,
		 "  max RSS=%s  DB max=%s",
		 db_ptr2str(db_max_rss), mbyte2str(db_max_mbyte));
}



/* Pick a block size that will hold an integral number of DB hash
 * table entries and is a multiple of system's page size.
 * The entire hash table should reside in memory
 * if the system has enough memory. */
u_int
get_db_blksize(DB_PTR csize,		/* size of existing file */
	       u_int old_blksize)	/* 0 or required block size */
{
	u_int min_blksize, max_blksize, blksize, i;

	/* Ask the operating system only once so we don't get differing
	 * answers and so compute a varying page size.
	 * Some systems can't keep their stories straight. */
	if (db_max_rss == 0)
		get_db_max_rss();

	sys_pagesize = getpagesize();

	/* Compute the least common multiple of the system page and
	 * the DB hash table entry size.
	 * This will give us the smallest block size that we can use. */
	min_blksize = lcm(sys_pagesize, sizeof(HASH_ENTRY));

	/* The kludge to speed conversion of database addresses to block
	 * numbers and offsets on 32-bit systems depends on the block size
	 * being a multiple of 256 */
	if ((min_blksize % (1<<DB_PTR_SHIFT)) != 0)
		dcc_logbad(EX_SOFTWARE, "block size not a multiple of 256");

	/* The DB block size must also be a multiple of the
	 * the end-of-block padding used in the main database file. */
	if (sizeof(DB_RCD) % DB_RCD_HDR_LEN != 0)
		dcc_logbad(EX_SOFTWARE,
			   "DB padding size %d"
			   " is not a divisor of DB entry size %d",
			   DB_RCD_HDR_LEN, ISZ(DB_RCD));
	if (DB_RCD_LEN_MAX % DB_RCD_HDR_LEN != 0)
		dcc_logbad(EX_SOFTWARE,
			   "DB record not a multiple of header size");
	min_blksize = lcm(min_blksize, DB_RCD_HDR_LEN);

	max_blksize = db_max_byte / (DB_BUF_NUM/2);
	max_blksize -= max_blksize % min_blksize;

	if (min_blksize > max_blksize)
		dcc_logbad(EX_SOFTWARE, "min_blksize %d > max_blksize %d",
			   min_blksize, max_blksize);

	/* Use the old block size when opening an existing database so
	 * that we are not confused by padding at the ends of the old pages.
	 * Fail if it is impossible.
	 * This causes dbclean to rebuild the database. */
	if (old_blksize != 0) {
		if ((old_blksize % min_blksize) != 0)
			return 0;
		return old_blksize;
	}

	if (csize != 0) {
		blksize = csize / (DB_BUF_NUM/2);
		i = blksize % min_blksize;
		if (i != 0)
			blksize += min_blksize - i;
		if (blksize > max_blksize)
			blksize = max_blksize;
		return blksize;
	}

	/* Without a preference from an existing file,
	 * choose a block size to handle the largest possible files.
	 * Make the conservative but wrong assumption that the hash file
	 * will be half as large as the database or checksum file. */
	blksize = min_blksize;
	while (blksize < ((db_max_byte*3)/2)/DB_BUF_NUM
	       && blksize*2 < max_blksize)
		blksize = blksize*2;

	return blksize;
}



/* (re)create the buffer pool
 * The buffers are small blocks that point to the real mmap()'ed memory.
 */
u_char
db_buf_init(DB_PTR dbsize,
	    u_int old_blksize)		/* 0 or required buffer size */
{
	DB_ST *st;
	DB_BUF *b, *bprev, *bnext;
	int i;

	db_unload(0, DB_UNLOAD_RELEASE);

	free_db_sts();
	memset(db_sts, 0, sizeof(db_sts));
	db_sts_free_head = 0;
	db_sts_free_tail = 0;
	for (st = db_sts; st <= LAST(db_sts); ++st) {
		st->fwd = DB_ST_BUSY;
		st->bak = DB_ST_BUSY;
		free_db_st(st);
	}

	db_blksize = get_db_blksize(dbsize, old_blksize);
	if (db_blksize == 0)
		return 0;

	bufpart_size = (db_blksize + DB_BUF_NUM_PARTS-1)/DB_BUF_NUM_PARTS;
	i = bufpart_size % sys_pagesize;
	if (i != 0)
		bufpart_size += sys_pagesize - i;
	bufpart_kbytes = (bufpart_size + 1024-1) / 1024;

	/* Assume the resident part of database can be written in 30 minutes,
	 * because we have problems if that assumption is wrong.
	 * That assumption also implies a size for the background flushing. */
	kbytes_per_flush = (((db_blksize / 1024) * DB_BUF_NUM)
			    / ((30 * 60) / DB_NEED_FLUSH_SECS));
	/* Assume the disk can do at least 1 MByte/sec */
	if (kbytes_per_flush < 1024*DB_NEED_FLUSH_SECS)
		kbytes_per_flush = 1024*DB_NEED_FLUSH_SECS;

	db_hash_blk_len = db_blksize/sizeof(HASH_ENTRY);

	db_max_hash_entries = (MAX_HASH_ENTRIES
			       - MAX_HASH_ENTRIES % db_hash_blk_len);

	memset(db_bufs, 0, sizeof(db_bufs));
	b = db_bufs;
	buf_oldest = b;
	bprev = 0;
	for (i = DB_BUF_NUM; i > 1; --i) {
		bnext = b+1;
		b->older = bprev;
		b->newer = bnext;
		bprev = b;
		b = bnext;
	}
	b->older = bprev;
	buf_newest = b;

	memset(db_buf_hash, 0, sizeof(db_buf_hash));

	return 1;
}



static u_char
make_new_hash(DCC_EMSG *emsg, DB_HADDR new_hash_len)
{
	struct stat sb;
	HASH_ENTRY *hash;
	DB_ST *free_st;
	DB_HADDR next_haddr, cur_haddr, prev_haddr;
	u_int pagenum;

	if (getuid() == 0) {
		/* if we are running as root,
		 * don't change the owner of the database */
		if (0 > fstat(db_fd, &sb)) {
			db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
				   "fstat(%s): %s",
				   db_nm_path.c, ERROR_STR());
			return 0;
		}
		if (0 > fchown(db_hash_fd, sb.st_uid, sb.st_gid)) {
			db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
				   "fchown(%s,%d,%d): %s",
				   db_hash_nm_path.c,
				   (int)sb.st_uid, (int)sb.st_gid,
				   ERROR_STR());
			return 0;
		}
	}

	if (new_hash_len < MIN_HASH_ENTRIES)
		new_hash_len = MIN_HASH_ENTRIES;

	/* Increase the requested hash table size to a multiple of the database
	 * buffer size.  The buffer size is chosen to be a multiple of the
	 * size of a single hash table entry. */
	db_hash_fsize = (((DB_HOFF)new_hash_len)*sizeof(HASH_ENTRY)
			 + db_blksize-1);
	db_hash_fsize -= db_hash_fsize % db_blksize;
	new_hash_len = db_hash_fsize / sizeof(HASH_ENTRY);

	if (new_hash_len > db_max_hash_entries)
		new_hash_len = db_max_hash_entries;

	/* create the empty hash table file */
	free_db_sts();
	if (0 > db_unload_sub(emsg, 0, DB_BUF_TYPE_HASH, DB_UNLOAD_INVALIDATE))
		return 0;
	if (0 > ftruncate(db_hash_fd, 0)) {
		db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
			   "ftruncate(%s,0): %s",
			   db_hash_nm_path.c, ERROR_STR());
		return 0;
	}

	db_hash_len = new_hash_len;
	db_hash_used = DB_HADDR_BASE;
	db_hash_divisor = hash_divisor(db_hash_len - DB_HADDR_BASE, 1);

	/* Clear new hash file by linking its entries into the free list. */
	/* Map and clear the first buffer */
	if (!map_hctl(emsg, 1))
		return 0;

	/* create the header */
	strcpy(hctl->magic, HASH_MAGIC_STR);
	hctl->free_fwd = DB_HADDR_BASE;
	hctl->free_bak = db_hash_len-1;
	hctl->len = db_hash_len;
	hctl->divisor = db_hash_divisor;
	hctl->used = DB_HADDR_BASE;
	hctl->fgs = 0;
	hctl->sync_sec = time(0);

	kcache_ok = 0;
	disk_hash_ok = 0;

	/* Link the hash table entries in the first and following pages.
	 * The buffer size is chosen to be a multiple of the size of a
	 * single hash table entry. */
	prev_haddr = FREE_HADDR_END;
	cur_haddr = DB_HADDR_BASE;
	next_haddr = cur_haddr+1;
	hash = &hctl_st->d.h[DB_HADDR_BASE];
	pagenum = 0;
	free_st = GET_DB_ST();
	for (;;) {
		do {
			DB_HADDR_CP(hash->bak, prev_haddr);
			if (next_haddr == db_hash_len)
				DB_HADDR_CP(hash->fwd, FREE_HADDR_END);
			else
				DB_HADDR_CP(hash->fwd, next_haddr);
			++hash;
			prev_haddr = cur_haddr;
			cur_haddr = next_haddr++;
		} while (cur_haddr % db_hash_blk_len != 0);

		mark_st_dirty(hctl_st, 0, db_hash_blk_len);

		if (++pagenum >= db_hash_fsize/db_blksize)
			break;

		if (!map_hash(emsg, cur_haddr, free_st, 1))
			return 0;
		hash = free_st->d.h;
	}
	free_db_sts();

	memset(&assume_dirty.hash, 0, sizeof(assume_dirty.hash));

	return 1;
}



static u_char
check_old_files(DCC_EMSG *emsg)
{
	static const u_char magic[sizeof(((HCTL*)0)->magic)] = HASH_MAGIC_STR;
	struct stat sb;
	u_char old_db;

	/* check the size of the existing hash file */
	if (0 > fstat(db_hash_fd, &sb)) {
		db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
			   "stat(%s): %s",
			   buf_type2path(DB_BUF_TYPE_HASH), ERROR_STR());
		return 0;
	}
	db_hash_fsize = sb.st_size;
	if ((db_hash_fsize % sizeof(HASH_ENTRY)) != 0) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s has size "OFF_DPAT","
			   " not a multiple of hash entry size %d",
			   buf_type2path(DB_BUF_TYPE_HASH), db_hash_fsize,
			   ISZ(HASH_ENTRY));
		return 0;
	}
	if ((db_hash_fsize % db_blksize) != 0) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s has size "OFF_DPAT","
			   " not a multiple of its buffer size %d",
			   buf_type2path(DB_BUF_TYPE_HASH), db_hash_fsize,
			   db_blksize);
		return 0;
	}

	db_hash_len = db_hash_fsize/sizeof(HASH_ENTRY);
	if (db_hash_len < MIN_HASH_ENTRIES) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s has too few records, "OFF_DPAT" bytes",
			   buf_type2path(DB_BUF_TYPE_HASH), db_hash_fsize);
		return 0;
	}

	/* check the magic number */
	if (!map_hctl(emsg, 0))
		return 0;
	if (memcmp(hctl->magic, &magic, sizeof(magic))) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s has the wrong magic \"%s\""
			   " instead of \""HASH_MAGIC_STR"\"",
			   buf_type2path(DB_BUF_TYPE_HASH),
			   esc_magic(hctl->magic, sizeof(HASH_ENTRY)));
		return 0;
	}

	/* We cannot use the hash table if it was not consistent in the
	 * system buffer cache. */
	if (!(hctl->fgs & HCTL_FG_KCACHE_OK)) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s was not closed cleanly",
			   buf_type2path(DB_BUF_TYPE_HASH));
		return 0;
	}

	/* The hash table is good if it is consistent.
	 * We must ignore disk inconsistencies if they appeared after the
	 * system was most recently rebooted, because HCTL_FG_KCACHE_OK=1
	 * implies that the hash table is consistent in the system buffer cache
	 * and we cannot detect any disk inconsistencies.  In other words,
	 * hctl->sync_sec lets us ignore HCTL_FG_SYNC_OK, because
	 * the inconsistencies flagged by HCTL_FG_SYNC_OK are invisible
	 * provide the system has not been rebooted since they appeared. */
	if (hctl->fgs & HCTL_FG_SYNC_OK) {
		disk_hash_ok = 1;
		disk_db_ok = 1;
	} else {
		struct timeval boottime;
		DCC_EMSG boot_emsg;

		disk_hash_ok = 0;
		disk_db_ok = 0;

		if (!get_boottime(&boottime, &boot_emsg)) {
			if (!have_boottime) {
				if (db_debug)
					quiet_trace_msg("%s", boot_emsg.c);
			} else {
				db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
					   "%s unsynchronized;"
					   " ts=%d, %s",
					   buf_type2path(DB_BUF_TYPE_HASH),
					   (int)hctl->sync_sec, boot_emsg.c);
				return 0;
			}

		} else if (TIME_T(hctl->sync_sec) <= boottime.tv_sec) {
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "%s unsynchronized;"
				   " ts=%d boottime=%d",
				   buf_type2path(DB_BUF_TYPE_HASH),
				   (int)hctl->sync_sec,
				   (int)boottime.tv_sec);
			return 0;
		}
	}

	if (DB_HADDR_INVALID(hctl->free_fwd)
	    && (hctl->free_fwd != FREE_HADDR_END
		|| hctl->free_fwd != hctl->free_bak)) {
		db_failure(__LINE__,__FILE__,
			   EX_DATAERR, emsg,
			   "%s has a broken free list head of %x",
			   buf_type2path(DB_BUF_TYPE_HASH),
			   hctl->free_fwd);
		return 0;
	}
	if (DB_HADDR_INVALID(hctl->free_bak)
	    && (hctl->free_bak != FREE_HADDR_END
		|| hctl->free_fwd != hctl->free_bak)) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s has a broken free list tail of %x",
			   buf_type2path(DB_BUF_TYPE_HASH),
			   hctl->free_bak);
		return 0;
	}

	if (db_hash_len != hctl->len) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s has %d entries but claims %d",
			    buf_type2path(DB_BUF_TYPE_HASH),
			    db_hash_len, hctl->len);
		return 0;
	}

	db_hash_divisor = hctl->divisor;
	if (db_hash_divisor < MIN_HASH_DIVISOR
	    || db_hash_divisor >= db_hash_len) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s has hash divisor %d",
			   buf_type2path(DB_BUF_TYPE_HASH),
			   db_hash_len);
		return 0;
	}

	db_hash_used = hctl->used;
	if (db_hash_used < DB_HADDR_BASE) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s contains impossible %u entries",
			   buf_type2path(DB_BUF_TYPE_HASH),
			   ADJ_HLEN(db_hash_used));
		return 0;
	}
	if (db_hash_used >= db_hash_len) {
		if (db_hash_used > db_hash_len)
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "%s contains only %u entries but %u used",
				   buf_type2path(DB_BUF_TYPE_HASH),
				   ADJ_HLEN(db_hash_len),
				   ADJ_HLEN(db_hash_used));
		else
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "%s is filled with %u entries",
				   buf_type2path(DB_BUF_TYPE_HASH),
				   ADJ_HLEN(db_hash_len));
		return 0;
	}

	/* old databases lack the growth values */
	old_db = 0;
	if (!db_rdonly
	    && db_parms.old_db_csize == 0
	    && db_parms.db_added == 0
	    && db_parms.hash_used == 0
	    && db_parms.old_hash_used == 0
	    && db_parms.hash_added == 0
	    && db_parms.rate_secs == 0
	    && db_parms.last_rate_sec == 0) {
		quiet_trace_msg("repair database growth measurements");
		db_parms.old_db_csize = db_parms.db_csize;
		old_db = 1;
	}

	if (db_hash_used != db_parms.hash_used
	    && db_hash_fsize != 0) {
		if (old_db) {
			quiet_trace_msg("repair db_parms.old hash_used"
					" and old_hash_used");
			db_parms.old_hash_used = db_hash_used;
			db_parms.hash_used = db_hash_used;
		} else {
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "%s contains %d"
				   " entries instead of the %d that %s claims",
				   buf_type2path(DB_BUF_TYPE_HASH),
				   db_hash_used, db_parms.hash_used,
				   dcc_path2fnm(db_nm.c));
			return 0;
		}
	}

	if (hctl->db_csize != db_csize
	    && db_hash_fsize != 0) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s contains "L_DPAT
			   " bytes instead of the "L_DPAT" that %s claims",
			   buf_type2path(DB_BUF_TYPE_DB), db_csize,
			   hctl->db_csize,
			   dcc_path2fnm(db_hash_nm.c));
		return 0;
	}

	if (db_rdonly || disk_hash_ok) {
		memset(&assume_dirty.hash, 0, sizeof(assume_dirty.hash));
	} else {
		/* If the file was not sync'ed when last closed,
		 * then assume it has many unknown changes. */
		memset(&assume_dirty.hash, -1, sizeof(assume_dirty.hash));
	}
	if (db_rdonly || disk_db_ok) {
		memset(&assume_dirty.db, 0, sizeof(assume_dirty.db));
	} else {
		memset(&assume_dirty.db, -1, sizeof(assume_dirty.db));
	}
	assume_dirty_blks();

	free_db_sts();
	return 1;
}



/* open the files and generally get ready to work */
u_char					/* 0=failed, 1=ok */
db_open(DCC_EMSG *emsg,
	int new_db_fd,			/* -1 or already open db_fd */
	const char *new_db_nm,
	const char *new_hash_nm,
	DB_HADDR new_hash_len,		/* 0 or # of entries */
	DB_OPEN_MODES db_mode)		/* DB_OPEN_* */
{
	u_int cur_blksize;
	int hash_flags, db_open_flags;
	struct stat db_sb;
#	define OPEN_BAIL() {if (new_db_fd >= 0) db_fd = -1;		\
		db_close(DB_CLOSE_DISCARD_ALL); return 0;}

	db_close(DB_CLOSE);
	db_failed_line = __LINE__;
	db_failed_file = __FILE__;
	dbclean_running = 0;
	kcache_ok = 1;
	db_locked.tv_sec = 0;

	db_rdonly = (db_mode & DB_OPEN_RDONLY) != 0;
	if (db_rdonly) {
		db_buf_mode_db = DB_BUF_MODE_SHARED;
		db_buf_mode_hash = DB_BUF_MODE_SHARED;
	} else if (db_mode & DB_OPEN_WRITE) {
		db_buf_mode_db = DB_BUF_MODE_PRIVATE;
		db_buf_mode_hash = DB_BUF_MODE_PRIVATE;
	} else {
		db_buf_mode_db = DB_BUF_MODE_SHARED;
		db_buf_mode_hash = DB_BUF_MODE_SHARED;
	}

	memset(&db_stats, 0, sizeof(db_stats));

	if (!new_db_nm && db_nm.c[0] == '\0')
		new_db_nm = grey_on ? DB_GREY_NAME : DB_DCC_NAME;
	if (new_db_nm) {
		if (!dcc_fnm2rel(&db_nm, new_db_nm, 0)) {
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "invalid DB nm \"%s\"", new_db_nm);
			return 0;
		}
		if ((!new_hash_nm || new_hash_nm[0] == '\0')
		    && !dcc_fnm2rel(&db_hash_nm, db_nm.c, DB_HASH_SUFFIX)) {
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "invalid DB nm \"%s\"", new_db_nm);
			return 0;
		}
	}
	if (new_hash_nm && new_hash_nm[0] != '\0') {
		if (!dcc_fnm2rel(&db_hash_nm, new_hash_nm, 0)) {
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "invalid DB hash nm \"%s\"", new_hash_nm);
			return 0;
		}
	}

	dcc_fnm2abs_msg(&db_nm_path, db_nm.c);
	dcc_fnm2abs_msg(&db_hash_nm_path, db_hash_nm.c);

	if (new_db_fd >= 0) {
		if (new_hash_len != 0)
			dcc_logbad(EX_SOFTWARE,
				   "extending db_open(%s) without locking",
				   db_nm_path.c);
		if (!db_rdonly)
			dcc_logbad(EX_SOFTWARE,
				   "db_open(%s) read/write without locking",
				   db_nm_path.c);
		db_open_flags = O_RDONLY;
		hash_flags = O_RDONLY;

		db_fd = new_db_fd;

	} else {
		db_open_flags = O_RDWR;
		if (new_hash_len != 0) {
			if (db_rdonly)
				dcc_logbad(EX_SOFTWARE,
					   "db_open(%s) creating read-only",
					   db_nm_path.c);
			hash_flags = O_RDWR | O_CREAT;
		} else {
			/* must open the file read/write to lock it */
			hash_flags = O_RDWR;
		}

		db_fd = dcc_lock_open(emsg, db_nm.c, db_open_flags,
				      (db_mode & DB_OPEN_LOCK_NOWAIT)
				      ? DCC_LOCK_OPEN_NOWAIT : 0,
				      DCC_LOCK_ALL_FILE, 0);
		if (db_fd == -1) {
			db_close(DB_CLOSE_DISCARD_ALL);
			return 0;
		}
	}
	gettimeofday(&db_time, 0);
	db_locked = db_time;
	if (0 > fstat(db_fd, &db_sb)) {
		db_failure(__LINE__,__FILE__, EX_IOERR, emsg, "stat(%s): %s",
			   buf_type2path(DB_BUF_TYPE_DB), ERROR_STR());
		OPEN_BAIL();
	}
	db_csize = db_fsize = db_sb.st_size;
	if (db_fsize < ISZ(DB_HDR)) {
		db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
			   "%s with %d bytes is too small to be a DCC database",
			   buf_type2path(DB_BUF_TYPE_DB), (int)db_fsize);
		OPEN_BAIL();
	}

	/* check the header of the database file by temporarily mapping it */
	db_buf_init(sizeof(DB_HDR), 0);
	if (!map_db_parms(emsg))
		OPEN_BAIL();
	db_parms = *cur_db_parms;

	if (memcmp(db_parms.version, db_version_buf, sizeof(db_version_buf))) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s contains the wrong magic \"%s\""
			   " instead of \""DB_VERSION_STR"\"",
			   buf_type2path(DB_BUF_TYPE_DB),
			   esc_magic(db_parms.version,
				     sizeof(db_parms.version)));
		OPEN_BAIL();
	}
	if (!(db_parms.flags & DB_PARM_FG_GREY) != !grey_on) {
		dcc_pemsg(EX_DATAERR, emsg,
			  "%s is%s a greylist database but must%s be",
			  buf_type2path(DB_BUF_TYPE_DB),
			  (db_parms.flags & DB_PARM_FG_GREY) ? "" : " not",
			  grey_on ? "" : " not");
		OPEN_BAIL();
	}

	ssd_mode = (db_parms.flags & DB_PARM_FG_SSD) ? 1 : 0;

	cur_blksize = db_parms.blksize;

	DB_SET_NOKEEP(db_parms.nokeep_cks, DCC_CK_INVALID);
	DB_SET_NOKEEP(db_parms.nokeep_cks, DCC_CK_FLOD_PATH);
	set_db_tholds(db_parms.nokeep_cks);

	db_ck_fuzziness = grey_on ? grey_ck_fuzziness : dcc_ck_fuzziness;

	db_csize = db_parms.db_csize;
	if (db_csize < sizeof(DB_HDR)) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s says it contains "L_DPAT" bytes"
			   " or fewer than the minimum of %d",
			   buf_type2path(DB_BUF_TYPE_DB),
			   db_csize, DB_PTR_BASE);
		/* that is a fatal error if we are not rebuilding */
		if (new_hash_len != 0)
			OPEN_BAIL();
	}
	if (db_csize > db_fsize) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s says it contains "L_DPAT" bytes"
			   " or more than the actual size of "OFF_DPAT,
			   buf_type2path(DB_BUF_TYPE_DB),
			   db_csize, db_fsize);
		/* that is a fatal error if we are not rebuilding */
		if (new_hash_len != 0)
			OPEN_BAIL();
	}

	/* The buffer size we use must be the buffer size used to
	 * write the files.  Try to change our size to match the file */
	if (cur_blksize != db_blksize
	    && !db_buf_init(db_csize, cur_blksize)) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s has block size %d incompatible with %d in %s",
			   buf_type2path(DB_BUF_TYPE_DB),
			   cur_blksize, get_db_blksize(db_csize, 0),
			   dcc_path2fnm(db_hash_nm.c));
		OPEN_BAIL();
	}

	db_hash_len = 0;
	db_hash_fd = open(db_hash_nm.c, hash_flags, 0666);
	if (db_hash_fd < 0) {
		db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
			   "open(%s): %s",
			   buf_type2path(DB_BUF_TYPE_HASH),
			   ERROR_STR());
		OPEN_BAIL();
	}
	if (0 > fcntl(db_hash_fd, F_SETFD, FD_CLOEXEC)) {
		db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
			   "fcntl(%s, FD_CLOEXEC): %s",
			   buf_type2path(DB_BUF_TYPE_HASH),
			   ERROR_STR());
		OPEN_BAIL();
	}

	if (new_hash_len != 0) {
		if (!make_new_hash(emsg, new_hash_len))
			OPEN_BAIL();
	} else {
		if (!check_old_files(emsg))
			OPEN_BAIL();
	}

	if (db_fsize % db_blksize != 0) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s has size "OFF_HPAT","
			   " not a multiple of its buffer size of %#x",
			   buf_type2path(DB_BUF_TYPE_DB),
			   db_fsize, db_blksize);
		OPEN_BAIL();
	}
	if (db_fsize > db_csize + db_blksize || db_csize > db_fsize) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "%s has size "OFF_HPAT" but claims "L_HxPAT,
			   buf_type2path(DB_BUF_TYPE_DB),
			   db_fsize, db_csize);
		OPEN_BAIL();
	}

	/* Consider overriding the default use of shared mmap()
	 * set by DB_OPEN_DBLCEAN_DEFAULT or DB_OPEN_DCCD_DEFAULT
	 * when we have lots of RAM and but do not have mmap(MAP_NOSYNC). */
	if (!USE_MAP_NOSYNC && !db_rdonly
	    && db_max_rss > db_fsize + db_hash_fsize
	    && ((db_mode & DB_OPEN_DBCLEAN_DEFAULT)
		|| (db_mode & DB_OPEN_DCCD_DEFAULT))) {
		/* With an SSD, use -F or write() instead of modifying mmap()
		 * pages on both the checksums and hash table, because the
		 * final burst of writes will be fewer than the syncer
		 * and fast enough. */
		if (ssd_mode
		    && (db_buf_mode_hash == DB_BUF_MODE_SHARED
			|| db_buf_mode_db == DB_BUF_MODE_SHARED)) {
			db_buf_mode_db = DB_BUF_MODE_PRIVATE;
			db_buf_mode_hash = DB_BUF_MODE_PRIVATE;
			if (db_debug)
				quiet_trace_msg("minimizing SSD wear with -F");
		}

		/* Use -F for dbclean on systems without mmap(MAP_NOSYNC)
		 * but with lots of RAM. Linux and SunOS otherwise waste too
		 * much time sync'ing the growing database.
		 * However, that is not a problem with a RAM file system.  */
		if (db_buf_mode_hash == DB_BUF_MODE_SHARED
		    && (db_mode & DB_OPEN_DBCLEAN_DEFAULT)
		    && !istmpfs(db_hash_fd, db_hash_nm.c)) {
			db_buf_mode_hash = DB_BUF_MODE_PRIVATE;
			db_buf_mode_db = DB_BUF_MODE_PRIVATE;
			if (db_debug)
				quiet_trace_msg("db_max_rss="OFF_HPAT
						" db_fsize+db_hash_fsize="
						OFF_HPAT"; use -F",
						db_max_rss,
						db_fsize+db_hash_fsize);
		}
	}

	free_db_sts();
	db_failed_line = 0;

	return 1;
#undef OPEN_BAIL
}



/* Unmap a block to
 *	1. reduce the footprint of an idle daemon
 *	2. make room for dbclean with the expectation that the files will
 *	    be discarded.
 *	3. forget old files and get ready to use newly cleaned files
 *	4. get ready to reboot with the expectation of rebuilding the
 *	    hash table and recomputing any non-urgent checksum changes.
 *	    Invalidate and discard the hash table to avoid spending seconds
 *	    writing it to disk unless we have an SSD or it is clean.
 *	5. get ready to reboot with both files clean
 *	6. ready to restart the daemon,
 *	    and so send all urgent changes to the disk
 */
static u_char
buf_unmap(DCC_EMSG *emsg, DB_BUF *b, BUF_UNMAP_MODE mode, u_char make_oldest)
{
	u_char result;

	if (b->buf_type == DB_BUF_TYPE_FREE)
		dcc_logbad(EX_SOFTWARE, "unmapping free buffer");
	if (b->lock_cnt != 0)
		dcc_logbad(EX_SOFTWARE, "unmapping locked buffer");

	result = 1;

	switch (mode) {
	case BUF_UNMAP_SAVE_ALL:
		/* Send to all changes to the disk for #1 or #5. */
		if (!buf_clean(emsg, b, 0, 0, BUF_CLEAN_ALL))
			result = 0;
		break;

	case BUF_UNMAP_RELEASE:
		/* Deal with changes for #2, #4, or #6. */
		if (!buf_clean(emsg, b, 0, 0,
			       (b->flags & DB_BUF_FG_PRIVATE)
			       ? BUF_CLEAN_ALL
			       : BUF_CLEAN_URGENT))
			result = 0;
		break;

	case BUF_UNMAP_INVALIDATE:
		/* Forget changes for #3. */
#ifdef DCC_MADV_FREE
		/* Invalidate the kernel buffer cache block if it might
		 * differ from the disk and we are trying to not save something.
		 * Do not trust msync(MS_ASYNC) to work when followed by
		 * madvise(MADV_FREE) or madvise(MADV_DONTNEED).  Linux
		 * documentation says that madvise(MADV_DONTNEED) overrides
		 * msync(MS_ASYNC). */
		if (0 > madvise((b)->buf.v, db_blksize, DCC_MADV_FREE)) {
			db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
				   "madvise(%s,%#x, FREE): %s",
				   buf2path(b), db_blksize, ERROR_STR());
			result = 0;
		}
#endif
		break;
	}

	/* Mark private blocks in need of msync() when we later mmap() them. */
	set_assume_dirty(b);

	if (0 > munmap(b->buf.v, db_blksize)) {
		db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
			   "munmap(%s,%d): %s",
			   buf2path(b), db_blksize, ERROR_STR());
		result = 0;
	}
	b->flags = 0;
	b->buf.v = 0;
	b->blk_num = -1;
	b->buf_type = DB_BUF_TYPE_FREE;

	/* Make it oldest */
	if (make_oldest && buf_oldest != b) {
		/* unlink it */
		b->older->newer = b->newer;
		if (b->newer)
			b->newer->older = b->older;
		else
			buf_newest = b->older;
		/* insert it at the tail of the MRU list */
		b->older = 0;
		b->newer = buf_oldest;
		buf_oldest->older = b;
		buf_oldest = b;
	}

	db_buf_bytes -= db_blksize;

	return result;
}



static u_char
buf_map(DCC_EMSG *emsg, DB_BUF *b,
	u_char extend)			/* adding to the end of the file */
{
	int prot, flags;
	off_t offset;
	int fd;
	void *p;
	int retry;


	if (extend) {
		offset = 0;
#ifdef MAP_ANONYMOUS
		/* Prefer using anonymous memory to hold a
		 * block being appended to the data */
		fd = -1;
		b->flags |= (DB_BUF_FG_PRIVATE | DB_BUF_FG_ANON_EXTEND);
		flags = MAP_ANONYMOUS| MAP_PRIVATE;
#else
		fd = type2fd(b->buf_type);
		b->flags |= DB_BUF_FG_PRIVATE;
		flags = MAP_PRIVATE;
#endif
	} else {
		offset = BUF_OFFSET(b);
		fd = type2fd(b->buf_type);
		if (db_rdonly) {
			flags = MAP_SHARED;
		} else if (DB_BUF_MODE_B(b) == DB_BUF_MODE_PRIVATE) {
			b->flags |= DB_BUF_FG_PRIVATE;
			flags = MAP_PRIVATE;
		} else {
#if USE_MAP_NOSYNC
			flags = MAP_SHARED | MAP_NOSYNC;
#else
			flags = MAP_SHARED;
#endif
		}
	}

	prot = db_rdonly ? PROT_READ : (PROT_READ | PROT_WRITE);
	for (retry = 1; ; ++retry) {
		p = mmap(0, db_blksize, prot, flags, fd, offset);

		if (p == MAP_FAILED) {
			if (errno == EACCES
			    || errno == EBADF
			    || errno == EINVAL
			    || errno == ENODEV
			    || retry > 20) {
				db_failure(__LINE__,__FILE__, EX_IOERR, emsg,
					   "fail on try #%d"" mmap(%s"
					   " %#x,%#x,%#x,%d,"OFF_HPAT"): %s",
					   retry,
					   buf2path(b),
					   db_blksize, prot,
					   flags, fd, offset,
					   ERROR_STR());
				return 0;
			}
			dcc_error_msg("try #%d mmap(%s"
				      " %#x,%#x,%#x,%d,"OFF_HPAT"): %s",
				      retry,
				      buf2path(b),
				      db_blksize, prot, flags, fd, offset,
				      ERROR_STR());
/* #define MMAP_FAIL_DEBUG 3 */
#ifdef MMAP_FAIL_DEBUG
		} else if (((u_int)random() % MMAP_FAIL_DEBUG) == 0) {
			/* pretend mmap() failed randomly */
			dcc_error_msg(" test fail #%d mmap(%s,%#x,"OFF_HPAT")",
				      retry,
				      buf2path(b), db_blksize, offset);
			if (0 > munmap(p, db_blksize))
				dcc_error_msg( "test munmap(): %s",
					      ERROR_STR());
#endif
		} else {
			/* It worked.
			 * Say so if it was not the first attempt. */
			if (retry != 1)
				dcc_error_msg("ok after try #%d"
					      " mmap(%s,%#x,"OFF_HPAT") ok",
					      retry, buf2path(b),
					      db_blksize, offset);
			break;
		}

		/* mmap() fails occassionally on some systems,
		 * so try to release at least one buffer and try again.  */
		if (0 >= db_unload(emsg, DB_UNLOAD_ONE))
			return 0;
	}


	b->buf.v = p;

	db_buf_bytes += db_blksize;

	if (extend) {
#ifndef MAP_ANONYMOUS
		memset(b->buf.v, 0, db_blksize);
#endif
		memset(b->dirt.w, -1, sizeof(b->dirt_urgent.w));
		b->dirt.num = DB_BUF_NUM_PARTS;
		memset(b->dirt_urgent.w, -1, sizeof(b->dirt_urgent.w));
		b->dirt_urgent.num = DB_BUF_NUM_PARTS;
		set_db_need_flush_secs();
		return 1;
	}

	/* Assume a newly opened file has many unknown changes.
	 * Mark each block dirty the first time we map it. */
	assume_dirty_blk(b);

#ifdef DCC_MADV_WILLNEED
	/* Try to make the block resident. */
	if (0 > madvise((b)->buf.v, db_blksize, DCC_MADV_WILLNEED))
		dcc_error_msg("madvise(WILLNEED %s,%#x): %s",
			      buf2path(b), db_blksize, ERROR_STR());
#endif

	return 1;
}



/* get a free buffer for a chunk of either the hash table or database files */
static DB_BUF *
get_free_buf(DCC_EMSG *emsg, DB_BUF **bh)
{
	DB_BUF *b;

	/* Look for an unlocked buffer.
	 * We know there is one because we have more buffers than
	 * can be locked simultaneously. */
	b = buf_oldest;
	for (;;) {
		if (!b)
			dcc_logbad(EX_SOFTWARE, "broken DB buffer MRU chain");
		if (b->lock_cnt == 0)
			break;
		b = b->newer;
	}

	/* Found an unlocked buffer.
	 * Clean it and then unlink it from its hash chain. */
	if (b->buf_type != DB_BUF_TYPE_FREE) {
		if (!buf_unmap(emsg, b, BUF_UNMAP_SAVE_ALL, 0))
			return 0;
	}
	if (b->addr_fwd)
		b->addr_fwd->addr_bak = b->addr_bak;
	if (b->addr_bak)
		b->addr_bak->addr_fwd = b->addr_fwd;
	else if (b->hash)
		*b->hash = b->addr_fwd;

	b->flags = 0;
	memset(&b->dirt, 0, sizeof(b->dirt));
	memset(&b->dirt_urgent, 0, sizeof(b->dirt_urgent));

	/* put it on the new hash chain */
	b->addr_bak = 0;
	b->hash = bh;
	b->addr_fwd = *bh;
	*bh = b;
	if (b->addr_fwd)
		b->addr_fwd->addr_bak = b;

	return b;
}



static DB_BUF *
find_buf(DCC_EMSG *emsg, DB_BUF_TYPE buf_type, DB_BLK_NUM blk_num)
{
	DB_BUF *b, **bh;

	bh = DB_BUF_HASH(blk_num, buf_type);
	b = *bh;
	for (;;) {
		if (!b) {
			/* We ran off the end of the buffer hash chain,
			 * so allocate a free buffer.  */
			b = get_free_buf(emsg, bh);
			if (!b)
				return 0;
			b->buf_type = buf_type;
			b->blk_num = blk_num;
			break;
		}
		if (b->buf_type == buf_type
		    && b->blk_num == blk_num)
			break;		/* found the buffer we need */

		b = b->addr_fwd;
	}

	/* make the buffer newest */
	if (buf_newest != b) {
		/* unlink it */
		b->newer->older = b->older;
		if (b->older)
			b->older->newer = b->newer;
		else
			buf_oldest = b->newer;
		/* insert it at the head of the MRU list */
		b->newer = 0;
		b->older = buf_newest;
		buf_newest->newer = b;
		buf_newest = b;
	}

	return b;
}



static DB_BUF *
find_st_buf(DCC_EMSG *emsg, DB_BUF_TYPE buf_type, DB_ST *st,
	    DB_BLK_NUM blk_num, u_char extend)
{
	DB_BUF *b;

	DB_ST_VALID(st, "using");

	/* release previous buffer unless it is the right one */
	b = st->b;
	if (b) {
		if (b->blk_num == blk_num
		    && b->buf_type == buf_type)
			return b;	/* already have the target buffer */

		/* Free the previous buffer */
		rel_db_st(st);
	}

	/* Look for an existing buffer for the block. */
	b = find_buf(emsg, buf_type, blk_num);
	if (!b)
		return 0;

	++b->lock_cnt;
	st->b = b;

	if (!b->buf.v) {
		/* Map the block into an empty buffer. */
		if (b->lock_cnt != 1)
			dcc_logbad(EX_SOFTWARE, "locked free buffer");
		if (!buf_map(emsg, b, extend)) {
			b->buf_type = DB_BUF_TYPE_FREE;
			b->blk_num = -1;
			b->lock_cnt = 0;
			return 0;
		}
		if (buf_type == DB_BUF_TYPE_DB)
			++db_stats.db_mmaps;
		else
			++db_stats.hash_mmaps;
	}

	return b;
}



/* mmap() a hash table entry */
static u_char
map_hash(DCC_EMSG *emsg,
	 DB_HADDR haddr,		/* this entry */
	 DB_ST *st,			/* point this to the entry */
	 u_char new)
{
	DB_BLK_NUM blk_num;
	DB_BLK_OFF blk_off;
	DB_BUF *b;

	if (haddr >= db_hash_len || haddr < DB_HADDR_BASE) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "invalid hash address %x in %s",
			   haddr, db_hash_nm_path.c);
		return 0;
	}

	blk_num = haddr / db_hash_blk_len;
	blk_off = haddr % db_hash_blk_len;

	b = find_st_buf(emsg, DB_BUF_TYPE_HASH, st, blk_num, new);
	if (!b)
		return 0;
	st->s.haddr = haddr;
	st->d.h = &b->buf.h[blk_off];
	return 1;
}



/* Find the control bits in the hash table. */
static u_char
map_hctl(DCC_EMSG *emsg, u_char new)
{
	DB_BUF *b;

	if (hctl)
		return 1;

	if (!hctl_st)
		hctl_st = GET_DB_ST();

	b = find_st_buf(emsg, DB_BUF_TYPE_HASH, hctl_st, 0, new);
	if (!b)
		return 0;
	hctl = hctl_st->d.v = b->buf.v;
	return 1;
}



/* Find the parameters in the database. */
static u_char
map_db_parms(DCC_EMSG *emsg)
{
	DB_BUF *b;

	if (cur_db_parms)
		return 1;

	if (!db_parms_st)
		db_parms_st = GET_DB_ST();

	b = find_st_buf(emsg, DB_BUF_TYPE_DB, db_parms_st, 0, 0);
	if (!b)
		return 0;
	cur_db_parms = db_parms_st->d.v = b->buf.v;
	return 1;
}



static void
bad_hash_fwd(int linenum, const char *file,
	      DCC_EMSG *emsg, const char *type,
	     DB_HADDR bak, DB_HADDR haddr, DB_HADDR fwd,
	     DB_HADDR fwd_bak)
{
	db_failure(linenum, file, EX_DATAERR, emsg,
		   "%x<--bad %s fwd %x-->%x, but %x<--%x"
		   " in %s",
		   bak, type, haddr, fwd,
		   fwd, fwd_bak,
		   db_hash_nm_path.c);
}



static void
bad_hash_bak(int linenum, const char *file,
	     DCC_EMSG *emsg, const char *type,
	     DB_HADDR bak, DB_HADDR haddr, DB_HADDR fwd,
	     DB_HADDR bak_fwd)
{
	db_failure(linenum, file, EX_DATAERR, emsg,
		   "%x<--bad %s bak %x-->%x, but %x-->%x"
		   " in %s",
		   bak, type, haddr, fwd,
		   bak, bak_fwd,
		   db_hash_nm_path.c);
}



/* unlink a hash table entry from the free list
 *	The hash table entry is marked dirty2. */
static DB_ST *
unlink_free_hash(DCC_EMSG *emsg,
		 DB_ST *tgt_st)		/* remove this from the free list */
{
	DB_ST *tmp_st;
	DB_HADDR fwd, bak, ptr;
	DB_PTR rcd_ptr;

	if (!map_hctl(emsg, 0))
		return 0;

	fwd = DB_HADDR_EX(tgt_st->d.h->fwd);
	bak = DB_HADDR_EX(tgt_st->d.h->bak);
	rcd_ptr = DB_HPTR_EX(tgt_st->d.h->rcd);
	if (!HE_IS_FREE(tgt_st->d.h)
	    || (DB_HADDR_INVALID(fwd) && fwd != FREE_HADDR_END)
	    || (DB_HADDR_INVALID(bak) && bak != FREE_HADDR_END)
	    || rcd_ptr != DB_PTR_NULL) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "bad %sfree hash entry"
			   " %x<--%x-->%x rcd-->"L_HPAT" free=%x,%x in %s",
			   HE_IS_FREE(tgt_st->d.h) ? "" : "not ",
			   bak, tgt_st->s.haddr, fwd, rcd_ptr,
			   hctl->free_bak, hctl->free_fwd,
			   db_hash_nm_path.c);
		return 0;
	}

	tmp_st = GET_DB_ST();

	if (fwd != FREE_HADDR_END) {
		if (!map_hash(emsg, fwd, tmp_st, 0))
			return 0;
		ptr = DB_HADDR_EX(tmp_st->d.h->bak);
		if (ptr != tgt_st->s.haddr) {
			bad_hash_fwd(__LINE__,__FILE__, emsg, "free",
				     bak, tgt_st->s.haddr, fwd, ptr);
			return 0;
		}
		DB_HADDR_CP(tmp_st->d.h->bak, bak);
		DIRTY_HE(tmp_st);
	} else {
		if (hctl->free_bak != tgt_st->s.haddr) {
			bad_hash_fwd(__LINE__,__FILE__, emsg, "free",
				     bak, tgt_st->s.haddr, fwd, hctl->free_bak);
			return 0;
		}
		hctl->free_bak = bak;
		DIRTY_HCTL();
	}

	if (bak != FREE_HADDR_END) {
		if (!map_hash(emsg, bak, tmp_st, 0)) {
			return 0;
		}
		ptr = DB_HADDR_EX(tmp_st->d.h->fwd);
		if (ptr != tgt_st->s.haddr) {
			bad_hash_bak(__LINE__,__FILE__, emsg, "free",
				     bak, tgt_st->s.haddr, fwd, ptr);
			return 0;
		}
		DB_HADDR_CP(tmp_st->d.h->fwd, fwd);
		DIRTY_HE(tmp_st);
	} else {
		if (hctl->free_fwd != tgt_st->s.haddr) {
			bad_hash_bak(__LINE__,__FILE__, emsg, "free",
				     bak, tgt_st->s.haddr, fwd, hctl->free_fwd);
			return 0;
		}
		hctl->free_fwd = fwd;
		DIRTY_HCTL();
	}

	free_db_st(tmp_st);

	++db_hash_used;

	memset(tgt_st->d.h, 0, sizeof(HASH_ENTRY));
	DIRTY_HE(tgt_st);
	return tgt_st;
}



/* Get a free hash table entry.
 *	The free entry is unlinked and marked dirty. */
static DB_ST *
get_free_hash(DCC_EMSG *emsg,
	      const DB_ST *cur_st)	/* look near here */
{
	static DB_HADDR r;
	DB_ST *free_st;
	DB_BLK_OFF blk_off, search_base_off, off;
	DB_HADDR avail, probe, trial, blk_base, search_base, search_len;
	u_int n;

	avail = db_hash_len - db_hash_used;
	if (avail == 0) {
		db_failure(__LINE__,__FILE__, EX_OSFILE, emsg,
			   "no free hash table entry;"
			   " %d of %d used", db_hash_used, db_hash_len);
		return 0;
	}

	if (!map_hctl(emsg, 0))
		return 0;

	free_st = GET_DB_ST();

	/* Look at random for a free entry if there are so many free that there
	 * is probably one that can be found in a few probes. */
	if (avail >= db_hash_len/16) {
		/* Start looking near the previous entry in the hash chain.
		 * if we are not at the start chain.
		 * Otherwise look near the current entry. */
		probe = DB_HADDR_EX(cur_st->d.h->bak);
		if (probe == DB_HADDR_NULL)
			probe = cur_st->s.haddr;

		blk_off = probe % db_hash_blk_len;
		blk_base = probe - blk_off;

		search_base_off = blk_off * sizeof(HASH_ENTRY);
		off = search_base_off % sys_pagesize;
		search_base_off -= off;
		search_base = search_base_off / sizeof(HASH_ENTRY);
		search_base += blk_base;
		search_len = sys_pagesize / sizeof(HASH_ENTRY);
		/* Look in both system pages if the hash entry crosses
		 * a system page boundary. */
		if (off > sys_pagesize - sizeof(HASH_ENTRY))
			search_len *= 2;

		n = 0;
		do {
			/* Get the next linear congruential random number. */
			r = r*1664525 + 1013904223;
			trial = (r % search_len) + search_base;
			if (trial < DB_HADDR_BASE)
				continue;

			if (!map_hash(emsg, trial, free_st, 0))
				return 0;
			if (HE_IS_FREE(free_st->d.h))
				return unlink_free_hash(emsg, free_st);

			if (++n == 6) {
				search_len = db_hash_blk_len;
				search_base = blk_base;
			}
		} while (n < 10);
	}

	/* Allocate from the free list if we cannot find a nearby free entry */
	trial = hctl->free_fwd;
	if (DB_HADDR_INVALID(trial)) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "broken hash free list head of %x", trial);
		return 0;
	}
	if (!map_hash(emsg, trial, free_st, 0))
		return 0;

	return unlink_free_hash(emsg, free_st);
}



/* mmap() a database entry
 *	We assume that no database entry spans buffers,
 *	and that there are enough buffers to accomodate all possible
 *	concurrent requests. */
static u_char
map_db(DCC_EMSG *emsg,
       DB_PTR rptr,			/* address of the record */
       u_int tgt_len,			/* its length */
       DB_ST *st,			/* point this to the record */
       u_char extend)
{
	DB_BLK_NUM blk_num;
	DB_BLK_OFF blk_off;
	DB_BUF *b;

	if (rptr+tgt_len > db_fsize) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "invalid database address "L_HxPAT" or length %d"
			   " past db_fsize "OFF_HPAT" in %s",
			   rptr, tgt_len, db_fsize,
			   buf_type2path(DB_BUF_TYPE_DB));
		return 0;
	}

	blk_num = DB_PTR2BLK_NUM(rptr, db_blksize);
#ifdef HAVE_64BIT_LONG
	blk_off = rptr % db_blksize;
#else
	/* Avoid udivdi3() and umoddi3() here.  They are otherwise a
	 * major time sink here on 32-bit systems. */
	blk_off = rptr - blk_num*(DB_PTR)db_blksize;
#endif

	if (tgt_len+blk_off > db_blksize) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "invalid database address "L_HxPAT
			   " or length %#x crosses block boundary in %s",
			   rptr, tgt_len, buf_type2path(DB_BUF_TYPE_DB));
		return 0;
	}

	b = find_st_buf(emsg, DB_BUF_TYPE_DB, st, blk_num, extend);
	if (!b)
		return 0;
	st->s.rptr = rptr;
	st->d.r = (DB_RCD *)&b->buf.c[blk_off];
	st->bufend = &b->buf.c[db_blksize];
	return 1;
}



u_char					/* 0=failed, 1=got it */
db_map_rcd(DCC_EMSG *emsg,
	   DB_ST *rcd_st,		/* point this to the record */
	   DB_PTR rptr,			/* that is here */
	   int *rcd_lenp)		/* put its length here */
{
	u_int rcd_len;

	if (DB_PTR_IS_BAD(rptr, DB_PTR_MAX+1)) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "getting bogus record at "L_HxPAT", in %s",
			   rptr, buf_type2path(DB_BUF_TYPE_DB));
		return 0;
	}

	if (!map_db(emsg, rptr, DB_RCD_HDR_LEN, rcd_st, 0))
		return 0;
	rcd_len = DB_RCD_LEN(rcd_st->d.r);

	if (&rcd_st->d.c[rcd_len] > rcd_st->bufend) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			   "invalid checksum count %d at "L_HxPAT" in %s",
			   DB_NUM_CKS(rcd_st->d.r), rptr,
			   buf_type2path(DB_BUF_TYPE_DB));
		return 0;
	}

	if (rcd_lenp)
		*rcd_lenp = rcd_len;
	return 1;
}



/* write the new sizes of the files into the files */
static u_char
db_set_sizes(DCC_EMSG *emsg)
{
	u_char result = 1;

	if (db_hash_fd != -1) {
		if (!map_hctl(emsg, 0)) {
			result = 0;
		} else if (hctl->db_csize != db_csize
			   || hctl->used != db_hash_used) {
			hctl->db_csize = db_csize;
			hctl->used = db_hash_used;

			DIRTY_HCTL();
		}
	}

	if (db_fd != -1) {
		if (!map_db_parms(emsg)) {
			result = 0;
		} else if (cur_db_parms->db_csize != db_csize
			   || cur_db_parms->hash_used != db_hash_used) {
			cur_db_parms->db_csize = db_csize;
			db_parms.db_csize = db_csize;

			cur_db_parms->hash_used = db_hash_used;
			db_parms.hash_used = db_hash_used;

			cur_db_parms->last_rate_sec = db_time.tv_sec;
			db_parms.last_rate_sec = db_time.tv_sec;

			db_dirty_data(db_parms_st, 1, sizeof(DB_PARMS));
		}
	}

	return result;
}



/* write the database parameters into the magic number headers of the files */
u_char
db_flush_parms(DCC_EMSG *emsg)
{
	if (!db_set_sizes(emsg))
		return 0;

	if (db_fd == -1)
		return 1;
	if (!map_db_parms(emsg))
		return 0;

	db_parms.blksize = db_blksize;
	if (memcmp(&db_parms, cur_db_parms, sizeof(db_parms))) {
		*cur_db_parms = db_parms;
		db_dirty_data(db_parms_st, 1, sizeof(DB_PARMS));
	}

	return 1;
}



/* find a checksum type known to be in a record */
DB_RCD_CK *				/* 0=it's not there */
db_map_rcd_ck(DCC_EMSG *emsg,
	      DB_ST *rcd_st,		/* point this to the record */
	      DB_PTR rptr,		/* that is here */
	      DCC_CK_TYPES type)	/* find this type of checksum */
{
	DB_RCD_CK *rcd_ck;
	int i;

	if (!db_map_rcd(emsg, rcd_st, rptr, 0))
		return 0;

	rcd_ck = rcd_st->d.r->cks;
	i = DB_NUM_CKS(rcd_st->d.r);
	if (i > DCC_DIM_CKS) {
		db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
			  "impossible %d checksums in "L_HxPAT" in %s",
			  i, rptr, buf_type2path(DB_BUF_TYPE_DB));
		return 0;
	}

	for (; i != 0; --i, ++rcd_ck) {
		if (DB_CK_TYPE(rcd_ck) == type)
			return rcd_ck;
	}

	db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
		   "missing \"%s\" checksum in "L_HxPAT" in %s",
		   DB_TYPE2STR(type), rptr, buf_type2path(DB_BUF_TYPE_DB));
	return 0;
}



DB_HADDR
db_hash(DCC_CK_TYPES type, const DCC_SUM *sum)
{
	u_int64_t accum, wrap;
	const u_int32_t *wp;
	union {
	    DCC_SUM	sum;
	    u_int32_t	words[4];
	} buf;
	u_int  align;
	DB_HADDR haddr;

#ifdef HAVE_64BIT_PTR
	align = (u_int64_t)sum & 3;
#else
	align = (u_int32_t)sum & 3;
#endif
	if (align == 0) {
		/* We almost always take this branch because database
		 * records contain 12+N*24 bytes.  That also implies that
		 * we should not hope for better than 4 byte alignment. */
		wp = (u_int32_t *)sum;
	} else {
		buf.sum = *sum;
		wp = buf.words;
	}

	/* MD5 checksums are uniformly distributed, and so DCC_SUMs are
	 * directly useful for hashing except when they are server-IDs */
	accum = *wp++;
	accum += *wp++;
	wrap = accum >>32;
	accum <<= 32;
	accum += wrap + type;
	accum += *wp++;
	accum += *wp;

	haddr = accum % db_hash_divisor;
	haddr += DB_HADDR_BASE;

	return haddr;
}



/* look for a checksum in the hash table
 *	return with an excuse, the home slot, or the last entry on
 *	the collision chain */
DB_FOUND
db_lookup(DCC_EMSG *emsg,
	  DCC_CK_TYPES type,
	  const DCC_SUM *sum,
	  DB_ST *hash_st0,		/* hash block for record or related */
	  DB_ST *rcd_st,		/* put the record or garbage here */
	  DB_RCD_CK **prcd_ck)		/* point to cksum if found */
{
	DB_ST *hash_st;
	DB_HADDR haddr, haddr_fwd, haddr_bak;
	DB_PTR db_ptr;
	DB_RCD_CK *found_ck;
	DB_HADDR failsafe;

	hash_st = hash_st0 ? hash_st0 : GET_DB_ST();

	haddr = db_hash(type, sum);

	if (prcd_ck)
	    *prcd_ck = 0;

	if (!map_hash(emsg, haddr, hash_st, 0))
		return DB_FOUND_SYSERR;

	if (HE_IS_FREE(hash_st->d.h)) {
		if (!hash_st0)
			free_db_st(hash_st);
		return DB_FOUND_EMPTY;
	}

	if (!DB_HADDR_C_NULL(hash_st->d.h->bak)) {
		if (!hash_st0)
			free_db_st(hash_st);
		return DB_FOUND_INTRUDER;
	}

	/* We know that the current hash table entry is in its home slot.
	 * It might be for the key or checksum we are looking for
	 * or it might be for some other checksum with the same hash value. */
	for (failsafe = 0; failsafe <= 1000*100; ++failsafe) {
		if (HE_CMP(hash_st->d.h, type, sum)) {
			/* This hash table entry could be for our target
			 * checksum.  Read the corresponding record so we
			 * decide whether we have a hash collision or we
			 * have found a record containing our target checksum.
			 *
			 * find right type of checksum in the record */
			db_ptr = DB_HPTR_EX(hash_st->d.h->rcd);
			found_ck = db_map_rcd_ck(emsg, rcd_st, db_ptr, type);
			if (!found_ck)
				return DB_FOUND_SYSERR;
			if (!memcmp(sum, &found_ck->sum, sizeof(*sum))) {
				if (prcd_ck)
					*prcd_ck = found_ck;
				if (!hash_st0)
					free_db_st(hash_st);
				return DB_FOUND_IT;
			}
		}

		/* This DB record was a hash collision.
		 * Fail if this is the end of the hash chain */
		haddr_fwd = DB_HADDR_EX(hash_st->d.h->fwd);
		if (haddr_fwd == DB_HADDR_NULL) {
			if (!hash_st0)
				free_db_st(hash_st);
			return DB_FOUND_CHAIN;
		}

		if (DB_HADDR_INVALID(haddr_fwd)) {
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "broken hash chain fwd-link"
				   " #%d %x at %x in %s",
				   failsafe, haddr_fwd, haddr,
				   buf_type2path(DB_BUF_TYPE_HASH));
			return DB_FOUND_SYSERR;
		}

		if (!map_hash(emsg, haddr_fwd, hash_st, 0))
			return DB_FOUND_SYSERR;

		haddr_bak = DB_HADDR_EX(hash_st->d.h->bak);
		if (haddr_bak != haddr) {
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "broken hash chain links #%d,"
				   " %x-->%x but %x<--%x in %s",
				   failsafe,
				   haddr, haddr_fwd, haddr_bak, haddr_fwd,
				   buf_type2path(DB_BUF_TYPE_HASH));
			return DB_FOUND_SYSERR;
		}
		haddr = haddr_fwd;
	}
	db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
		   "infinite hash chain at %x in %s",
		   haddr, buf_type2path(DB_BUF_TYPE_HASH));
	return DB_FOUND_SYSERR;
}



/* combine checksums */
DCC_TGTS
db_sum_ck(DCC_TGTS prev,		/* previous sum */
	  DCC_TGTS rcd_tgts,		/* from the record */
	  DCC_CK_TYPES type DCC_UNUSED)
{
	DCC_TGTS res;

	/* This arithmetic must be commutative (after handling deleted
	 * values), because inter-server flooding causes records to appear in
	 * the database out of temporal order.
	 *
	 * DCC_TGTS_TOO_MANY can be thought of as a count of plus infinity.
	 * DCC_TGTS_OK is like minus infinity.
	 * DCC_TGTS_OK2 like half of minus infinity
	 * DCC_TGTS_TOO_MANY (plus infinity) added to DCC_TGTS_OK (minus
	 *	infinity) or DCC_TGTS_OK2 yields DCC_TGTS_OK or DCC_TGTS_OK2.
	 *
	 * Reputations never reach infinity.
	 *
	 * Claims of not-spam from all clients are discarded as they arrive
	 * and before here. They can only come from the local whitelist
	 */
#define SUM_OK_DEL(p,r) {						    \
		if (rcd_tgts == DCC_TGTS_OK || prev == DCC_TGTS_OK)	    \
			return DCC_TGTS_OK;				    \
		if (rcd_tgts == DCC_TGTS_OK2 || prev == DCC_TGTS_OK2)	    \
			return DCC_TGTS_OK2;				    \
		if (rcd_tgts == DCC_TGTS_DEL)				    \
			return prev;					    \
	}

	res = prev+rcd_tgts;
	if (res <= DCC_REP_TGTS_MAX
	    || (res <= DCC_TGTS_TOO_MANY
		&& !DCC_CK_IS_REP(grey_on, type)))
		return res;

	SUM_OK_DEL(prev, rcd_tgts);

	if (!DCC_CK_IS_REP(grey_on, type))
		return DCC_TGTS_TOO_MANY;

	/* adjust or handle overflowing reputations */
	if (rcd_tgts == DCC_TGTS_REP_ADJ)
		return prev - ((prev + DCC_REP_TGTS_ADJ_FRAC - 1)
			       / DCC_REP_TGTS_ADJ_FRAC);
	return DCC_REP_TGTS_MAX;
#undef SUM_OK_DEL
}



/* delete all reports that contain the given checksum */
static u_char				/* 1=done, 0=broken database */
del_ck(DCC_EMSG *emsg,
       DCC_TGTS *res,			/* residual targets after deletion */
       const DB_RCD *new,		/* delete reports older than this one */
       DCC_CK_TYPES type,		/* delete this type of checksum */
       DB_RCD_CK *prev_ck,		/* starting with this one */
       DB_ST *prev_st)			/*	in this block */
{
	DB_PTR prev, loop_prev;

	*res = 0;
	loop_prev = DB_PTR_MAX+1;
	for (;;) {
		/* delete reports that are older than the delete request */
		if (ts_newer_ts(&new->ts, &prev_st->d.r->ts)
		    && DB_RCD_ID(prev_st->d.r) != DCC_ID_WHITE) {
			DB_TGTS_RCD_SET(prev_st->d.r, 0);
			DB_TGTS_CK_SET(prev_ck, 0);
			DIRTY_RCD(prev_st, 1);

		} else {
			/* sum reports that are not deleted */
			*res = db_sum_ck(*res, DB_TGTS_RCD(prev_st->d.r), type);
		}

		prev = DB_PTR_EX(prev_ck->prev);
		if (prev == DB_PTR_NULL)
			return 1;

		/* All pointers in the database point to reports at
		 * numerically smaller locations. */
		if (DB_PTR_IS_BAD(prev, loop_prev)) {
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "looping hash chain of "L_HxPAT" at "L_HxPAT,
				   prev, loop_prev);
			return 0;
		}
		loop_prev = prev;

		prev_ck = db_map_rcd_ck(emsg, prev_st, prev, type);
		if (!prev_ck)
			return 0;
	}
}



/* Mark reports made obsolete by a new spam report
 *	A new report of spam makes sufficiently old spam reports obsolete.
 *
 *	Sufficiently recent non-obsolete reports make a new report not worth
 *	keeping or flooding.
 *	"Sufficiently recent" should be defined so that this server and
 *	its downstream flooding peers always have reports of the checksums
 *	in the report.  So we want to keep (not make obsolete) at least one
 *	report per expiration duration.  We cannot know the expiration durations
 *	of our peers, but we known DB_EXPIRE_SPAMSECS_DEF_MIN which influences
 *	DCC_OLD_SPAM_SECS.
 *
 *	However, if another checksum in the new report was kept, then
 *	prefer marking old checksums obsolete.
 */
static u_char				/* 1=done, 0=broken database */
ck_obs_spam(DCC_EMSG *emsg,
	    const DB_RCD *new,
	    DCC_TGTS new_tgts,
	    DB_RCD_CK *new_ck,
	    DCC_CK_TYPES type,		/* check this type of checksum */
	    DB_RCD_CK *prev_ck,		/* starting with this one */
	    DCC_TGTS prev_ck_tgts,
	    DB_ST *new_st,
	    DB_ST *prev_st)
{
	DB_PTR prev, loop_prev;

	/* quit if the new report is already junk */
	if (DB_CK_JUNK(new_ck))
		return 1;

	loop_prev = DB_PTR_MAX+1;
	for (;;) {
		/* preceding whitelisted entries make new entries junk */
		if (DB_RCD_ID(prev_st->d.r) == DCC_ID_WHITE) {
			new_ck->type_fgs |= DB_CK_FG_JUNK;
			DIRTY_RCD(new_st, 0);
			return 1;
		}

		if (DB_TGTS_RCD(prev_st->d.r) == 0) {
			/* skip deleted predecessors unless it was this
			 * checksum that was deleted */
			if (prev_ck_tgts == 0)
				return 1;

		} else if (prev_ck_tgts != DCC_TGTS_TOO_MANY) {
			/* This predecessor is obsolete because it
			 * was before the checksum became spam.
			 * We are finished if it has already been marked. */
			if (DB_CK_OSPAM(prev_ck))
				return 1;

			/* Mark it and its non-spam predecessors. */
			prev_ck->type_fgs |= (DB_CK_FG_OSPAM | DB_CK_FG_JUNK);
			DIRTY_RCD(prev_st, 0);

		} else if ((ts2secs(&prev_st->d.r->ts) / DCC_OLD_SPAM_SECS)
			   != (ts2secs(&new->ts) / DCC_OLD_SPAM_SECS)) {
			/* This predecessor reporting spam is much older
			 * than the new report.
			 * If the new report is not of spam, it will eventually
			 * be compressed with a preceding spam report,
			 * but not before being flooded and refreshing
			 * other servers' records of this checksum.
			 * We're finished, because all older preceding reports
			 * were marked obsolete when this older predecessor
			 * reporting spam was linked.
			 * The predecessor is not needed if the new record
			 * is for spam */
			if (new_tgts == DCC_TGTS_TOO_MANY) {
				prev_ck->type_fgs |= (DB_CK_FG_OSPAM |
						      DB_CK_FG_JUNK);
				DIRTY_RCD(prev_st, 0);
			}
			return 1;

		} else {
			/* This predecessor reporting spam is about as new as
			 * the new record, so the new record is unneeded and
			 * would bloat other servers' databases. */
			new_ck->type_fgs |= (DB_CK_FG_OSPAM | DB_CK_FG_JUNK);
			DIRTY_RCD(new_st, 0);
			return 1;
		}

		prev = DB_PTR_EX(prev_ck->prev);
		if (prev == DB_PTR_NULL)
			return 1;
		if (DB_PTR_IS_BAD(prev, loop_prev)) {
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "looping hash chain of "L_HxPAT" at "L_HxPAT,
				   prev, loop_prev);
			return 0;
		}
		loop_prev = prev;

		prev_ck = db_map_rcd_ck(emsg, prev_st, prev, type);
		if (!prev_ck)
			return 0;
		prev_ck_tgts = DB_TGTS_CK(prev_ck);
	}
}



/* mark extra server-ID state declarations obsolete */
static u_char				/* 1=done, 0=broken database */
srvr_id_ck(DCC_EMSG *emsg,
	   const DB_RCD *new,
	   DB_RCD_CK *new_ck,
	   DB_RCD_CK *prev_ck,		/* starting with this one */
	   DB_ST *new_st,
	   DB_ST *prev_st)
{
	DB_PTR prev, loop_prev;

	/* quit if already obsolete */
	if (DB_CK_JUNK(new_ck))
		return 1;

	loop_prev = DB_PTR_MAX+1;
	for (;;) {
		/* Zap the new server-ID declaration and stop
		 * if the new declaration is older than the predecessor.
		 * Keep conflicting ID assertions. */
		if (DCC_ID_SRVR_TYPE(DB_RCD_ID(new))
		    || DB_RCD_ID(new) == DB_RCD_ID(prev_st->d.r)) {
			/* stop at a deletion */
			if (DB_TGTS_RCD(prev_st->d.r) == 0)
				return 1;

			if (ts_newer_ts(&prev_st->d.r->ts, &new->ts)) {
				new_ck->type_fgs |= DB_CK_FG_JUNK;
				DIRTY_RCD(new_st, 0);
				return 1;
			}

			/* continue zapping preceding declarations */
			prev_ck->type_fgs |= DB_CK_FG_JUNK;
			DIRTY_RCD(prev_st, 0);
		}

		prev = DB_PTR_EX(prev_ck->prev);
		if (prev == DB_PTR_NULL)
			return 1;
		if (DB_PTR_IS_BAD(prev, loop_prev)) {
			db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
				   "looping hash chain of "L_HxPAT" at "L_HxPAT,
				   prev, loop_prev);
			return 0;
		}
		loop_prev = prev;

		prev_ck = db_map_rcd_ck(emsg, prev_st, prev, DCC_CK_SRVR_ID);
		if (!prev_ck)
			return 0;
	}
}



/* Install pointers in the hash table for a record and fix the accumulated
 *	The caller must deal with make_db_dirty() */
u_char					/* 0=failed, 1=done */
db_link_rcd(DCC_EMSG *emsg, DB_ST *new_st)
{
	DCC_TGTS res;
	DB_RCD *rcd;
	DB_RCD_CK *prev_ck;
	DB_RCD_CK *rcd_ck;
	DCC_CK_TYPES rcd_type;
	DCC_TGTS rcd_tgts, prev_ck_tgts;
	int ck_num;
	DB_ST *hash_st, *prev_st, *free_st, *tmp_st;
	DB_HADDR prev, next, prev_fwd, next_bak;

	prev_st = GET_DB_ST();
	hash_st = GET_DB_ST();
	rcd = new_st->d.r;
	rcd_tgts = DB_TGTS_RCD_RAW(rcd);
	rcd_ck = rcd->cks;
	ck_num = DB_NUM_CKS(rcd);
	if (ck_num > DIM(rcd->cks)) {
		db_failure(__LINE__,__FILE__, EX_OSFILE, emsg,
			   "bogus checksum count %#x at "L_HPAT" in %s",
			   rcd->fgs_num_cks, new_st->s.rptr,
			   buf_type2path(DB_BUF_TYPE_DB));
		return 0;
	}
	for (; ck_num > 0; --ck_num, ++rcd_ck) {
		rcd_type = DB_CK_TYPE(rcd_ck);
		if (!DCC_CK_TYPE_DB_OK(rcd_type)) {
			db_failure(__LINE__,__FILE__, EX_OSFILE, emsg,
				   "invalid checksum %s at "L_HxPAT" in %s",
				   DB_TYPE2STR(rcd_type),
				   new_st->s.rptr,
				   buf_type2path(DB_BUF_TYPE_DB));
			return 0;
		}

		rcd_ck->prev = DB_PTR_CP(DB_PTR_NULL);

		/* Do not link paths or whitelist file and line numbers */
		if (rcd_type == DCC_CK_FLOD_PATH) {
			DB_TGTS_CK_SET(rcd_ck, 0);
			continue;
		}

		/* Do not link or total some checksums unless they are
		 * whitelist entries.  If they are whitelist entries, they
		 * will eventually get set to DCC_TGTS_OK or DCC_TGTS_OK2.
		 * Blacklist entries are noticed later by server-ID
		 * or do not matter DCC_TGTS_TOO_MANY. */
		if (DB_TEST_NOKEEP(db_parms.nokeep_cks, rcd_type)
		    && DB_RCD_ID(rcd) != DCC_ID_WHITE) {
			DB_TGTS_CK_SET(rcd_ck, 1);
			continue;
		}

		res = (rcd_tgts == DCC_TGTS_DEL) ? 0 : rcd_tgts;

		switch (db_lookup(emsg, rcd_type, &rcd_ck->sum,
				  hash_st, prev_st, &prev_ck)) {
		case DB_FOUND_SYSERR:
			return 0;

		case DB_FOUND_IT:
			/* We found the checksum
			 * Update the hash table to point to the new record */
			DB_HPTR_CP(hash_st->d.h->rcd, new_st->s.rptr);
			DIRTY_HE(hash_st);
			/* link new record to existing record */
			rcd_ck->prev = DB_PTR_CP(prev_st->s.rptr);

			/* delete predecessors to a delete request
			 * and compute the remaining sum */
			if (rcd_tgts == DCC_TGTS_DEL) {
				if (!del_ck(emsg, &res, rcd, rcd_type,
					    prev_ck, prev_st))
					return 0;
				/* delete requests are obsolete if the
				 * checksum is whitelisted */
				if (res == DCC_TGTS_OK
				    || res == DCC_TGTS_OK2)
					rcd_ck->type_fgs |= DB_CK_FG_JUNK;
				break;
			}

			/* Simple checksum with a predecessor
			 * This does not do the substantial extra work
			 * of noticing all delete requests that arrived early.
			 * That problem is handled by the incoming flood
			 * duplicate report detection mechanism.
			 * We must detect predecessors that were deleted because
			 * they are partial duplicates of the new record. */
			prev_ck_tgts = DB_TGTS_CK(prev_ck);
			if (DB_RCD_SUMRY(rcd))
				res = prev_ck_tgts;
			else
				res = db_sum_ck(prev_ck_tgts, res, rcd_type);
			if ((res == DCC_TGTS_OK || res == DCC_TGTS_OK2
			     || (DB_RCD_ID(prev_st->d.r) == DCC_ID_WHITE))
			    && DB_RCD_ID(rcd) != DCC_ID_WHITE){
				/* obsolete whitelisted checksums */
				rcd_ck->type_fgs |= DB_CK_FG_JUNK;
				break;
			}
			if (res == DCC_TGTS_TOO_MANY) {
				/* mark unneeded reports of spam */
				if (!ck_obs_spam(emsg, rcd, rcd_tgts,
						 rcd_ck, rcd_type,
						 prev_ck, prev_ck_tgts,
						 new_st, prev_st))
					return 0;   /* (broken database) */
			} else if (rcd_type == DCC_CK_SRVR_ID) {
				/* mark obsolete server-ID assertions */
				if (!srvr_id_ck(emsg, rcd, rcd_ck, prev_ck,
						new_st, prev_st))
					return 0;   /* (broken database) */
			}
			break;

		case DB_FOUND_EMPTY:
			/* We found an empty hash table slot.
			 * Update the slot to point to our new record
			 * after removing it from the free list,
			 * which marks it dirty. */
			if (!unlink_free_hash(emsg, hash_st))
				return 0;
			DB_HPTR_CP(hash_st->d.h->rcd, new_st->s.rptr);
			HE_MERGE(hash_st->d.h,rcd_type, &rcd_ck->sum);
			break;

		case DB_FOUND_CHAIN:
			/* We found a hash collision, a chain of 1 or more
			 * records with the same hash value.
			 * Get a free slot, link it to the end of the
			 * existing chain, and point it to the new record.
			 * The buffer containing the free slot is marked
			 * dirty when it is removed from the free list. */
			free_st = get_free_hash(emsg, hash_st);
			if (!free_st)
				return 0;
			DB_HPTR_CP(free_st->d.h->rcd, new_st->s.rptr);
			HE_MERGE(free_st->d.h,rcd_type, &rcd_ck->sum);
			DB_HADDR_CP(free_st->d.h->bak, hash_st->s.haddr);
			DB_HADDR_CP(hash_st->d.h->fwd, free_st->s.haddr);
			DIRTY_HE(hash_st);
			free_db_st(free_st);
			break;

		case DB_FOUND_INTRUDER:
			/* The home hash slot for our key contains an intruder.
			 * Copy it to a new free slot. */
			free_st = get_free_hash(emsg, hash_st);
			if (!free_st)
				return 0;
			*free_st->d.h = *hash_st->d.h;

			prev = DB_HADDR_EX(hash_st->d.h->bak);
			next = DB_HADDR_EX(hash_st->d.h->fwd);

			/* re-link predecessor of the intruder */
			if (prev == DB_HADDR_NULL) {
				db_failure(__LINE__,__FILE__, EX_DATAERR, emsg,
					   "bad hash bak link %x<--%x in %s",
					   prev, hash_st->s.haddr,
					   db_hash_nm_path.c);
				return 0;
			}
			tmp_st = GET_DB_ST();
			if (!map_hash(emsg, prev, tmp_st, 0))
				return 0;
			prev_fwd = DB_HADDR_EX(tmp_st->d.h->fwd);
			if (prev_fwd != hash_st->s.haddr) {
				bad_hash_bak(__LINE__,__FILE__,
					     emsg, "hash",
					     prev, hash_st->s.haddr, next,
					     prev_fwd);
				return 0;
			}
			DB_HADDR_CP(tmp_st->d.h->fwd, free_st->s.haddr);
			DIRTY_HE(tmp_st);

			/* re-link successor of the intruder */
			if (next != DB_HADDR_NULL) {
				if (!map_hash(emsg, next, tmp_st, 0))
					return 0;
				next_bak = DB_HADDR_EX(tmp_st->d.h->bak);
				if (next_bak != hash_st->s.haddr) {
					bad_hash_fwd(__LINE__,__FILE__,
						     emsg, "hash",
						     prev, hash_st->s.haddr,
						     next, next_bak);
					return 0;
				}
				DB_HADDR_CP(tmp_st->d.h->bak, free_st->s.haddr);
				DIRTY_HE(tmp_st);
			}
			free_db_st(tmp_st);
			free_db_st(free_st);

			/* Install the new entry in its home slot. */
			DB_HADDR_CP(hash_st->d.h->fwd, DB_HADDR_NULL);
			DB_HADDR_CP(hash_st->d.h->bak, DB_HADDR_NULL);
			DB_HPTR_CP(hash_st->d.h->rcd, new_st->s.rptr);
			HE_MERGE(hash_st->d.h,rcd_type, &rcd_ck->sum);
			DIRTY_HE(hash_st);
			break;
		}

		/* Fix the checksum's total in the record */
		DB_TGTS_CK_SET(rcd_ck, res);
	}
	free_db_st(hash_st);
	free_db_st(prev_st);

	return db_set_sizes(emsg);
}



/* Add a record to the database and the hash table
 *	The record must be known to be valid */
DB_PTR					/* 0=failed */
db_add_rcd(DCC_EMSG *emsg,
	   const DB_RCD *new,		/* the new record */
	   DB_ST *new_st0)		/* 0 or the new record on exit */
{
	DB_ST *new_st;
	u_int new_len, pad_len;
	DB_PTR rcd_pos;

	new_st = new_st0 ? new_st0 : GET_DB_ST();
	DB_ST_VALID(new_st, "using");

	pad_len = db_fsize - db_csize;
	if (pad_len < DB_RCD_LEN_MAX) {
		/* Pad with zeros to the next block if we are too close to the
		 * end of the current block. */
		if (!map_db(emsg, db_csize, pad_len, new_st, 0))
			return 0;
		memset(new_st->d.r, 0, pad_len);
		db_dirty_data(new_st, 1, pad_len);
		db_csize += pad_len;

		/* Extend the file by writing a full block with write(). */
		db_fsize = (DB_PTR2BLK_NUM(db_csize+db_blksize, db_blksize)
			    * db_blksize);
		if (!map_db(emsg, db_csize, db_blksize, new_st, 1))
			return 0;
	}

	rcd_pos = db_csize;

	/* install the record */
	new_len = DB_RCD_LEN(new);
	if (!map_db(emsg, rcd_pos, new_len, new_st, 0))
		return 0;
	memcpy(new_st->d.r, new, new_len);

	/* Mark its buffer to be sent to the disk to keep the database
	 * as good as possible even if we crash.  We don't need to worry
	 * about later changes to the hash links because dbclean will
	 * rebuild them if we crash. */
	db_dirty_data(new_st, 1, new_len);
	db_csize = rcd_pos + new_len;

	/* install pointers in the hash table
	 * and update the total counts in the record */
	if (!db_link_rcd(emsg, new_st))
		return 0;

	++db_stats.adds;

	if (!new_st0)
		free_db_st(new_st);

	return rcd_pos;
}
