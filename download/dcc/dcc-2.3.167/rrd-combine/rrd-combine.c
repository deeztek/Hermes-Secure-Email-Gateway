/* Distributed Checksum Clearinghouse
 *
 * combine RRD databases
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
 * Rhyolite Software DCC 2.3.167-1.12 $Revision$
 */

#include "dcc_defs.h"
#include <math.h>

#define PROGNAME "rrd-combine: "

/* *********************************************************************** */
/* copied from rrd.h and rrd_format.h */
typedef double       rrd_value_t;

typedef union unival {
    unsigned long u_cnt;
    rrd_value_t   u_val;
} unival;

typedef struct stat_head_t {
    char	    cookie[4];
    char	    version[5];
    double	    float_cookie;
    unsigned long   ds_cnt;
    unsigned long   rra_cnt;
    unsigned long   pdp_step;
    unival	    par[10];
} stat_head_t;

#define DS_NAM_SIZE   20
#define DST_SIZE   20
typedef struct ds_def_t {
    char	    ds_nam[DS_NAM_SIZE];
    char	    dst[DST_SIZE];
    unival	    par[10];
} ds_def_t;

#define CF_NAM_SIZE   20
#define MAX_RRA_PAR_EN 10
typedef struct rra_def_t {
    char	    cf_nam[CF_NAM_SIZE];
    unsigned long   row_cnt;
    unsigned long   pdp_cnt;
    unival	    par[MAX_RRA_PAR_EN];
} rra_def_t;


#define LAST_DS_LEN 30
typedef struct pdp_prep_t{
    char	    last_ds[LAST_DS_LEN];
    unival	    scratch[10];
} pdp_prep_t;

#define MAX_CDP_PAR_EN 10
typedef struct cdp_prep_t{
    unival	    scratch[MAX_CDP_PAR_EN];
} cdp_prep_t;

typedef struct rra_ptr_t {
    unsigned long   cur_row;
} rra_ptr_t;

typedef struct rrd_t {
    const char      *fnm;
    int		    fd;
    struct stat     sb;
    stat_head_t     *stat_head;		/* the static header */
    ds_def_t	    *ds_def;		/* list of data source definitions */
    rra_def_t       *rra_def;		/* list of round robin archive def */
    struct timeval  last_update;
    pdp_prep_t      *pdp_prep;		/* pdp data prep area */
    cdp_prep_t      *cdp_prep;		/* cdp prep area */
    rra_ptr_t       *rra_ptr;		/* list of rra pointers */
    rrd_value_t     *rrd_value;		/* list of rrd values */
} rrd_t;

/* *********************************************************************** */


static DCC_EMSG dcc_emsg;

static const char *ofile;
static u_char force;
static u_char keep_mtime;
static u_char verbose;


static void DCC_NORET
usage(void)
{
	dcc_logbad(EX_USAGE,
		   "usage: [-fkv] [-d dir] -o ofile ifile1 ifile2 ...");
}



static void
unmap_rrd(rrd_t *rrd)
{
	if (rrd->stat_head) {
		if (munmap(rrd->stat_head, rrd->sb.st_size) < 0)
			dcc_logbad(EX_IOERR,
				   PROGNAME"munmap(%s, "OFF_DPAT"): %s",
				   rrd->fnm, rrd->sb.st_size,
				   strerror(errno));
	}
}



static void
rrd_close(rrd_t *rrd)
{
	unmap_rrd(rrd);

	if (rrd->fd >= 0) {
		if (close(rrd->fd) < 0)
			dcc_logbad(EX_IOERR, PROGNAME"close(%s): %s",
				   rrd->fnm, strerror(errno));
		rrd->fd = -1;
	}
}



static void
rrd_stat(rrd_t *rrd)
{
	if (0 > fstat(rrd->fd, &rrd->sb))
		dcc_logbad(EX_IOERR, PROGNAME"stat(%s): %s",
			   rrd->fnm, strerror(errno));

	if (rrd->sb.st_size <= ISZ(rrd->stat_head)) {
		dcc_logbad(EX_DATAERR,
			   PROGNAME"%s has too small size "OFF_DPAT"",
			   rrd->fnm, rrd->sb.st_size);
	}
}



static void
map_rrd(rrd_t *rrd, u_char in)
{
	struct timeval *tv;
	unmap_rrd(rrd);

	rrd_stat(rrd);

	rrd->stat_head = (stat_head_t *)mmap(0, rrd->sb.st_size,
					     in
					     ? PROT_READ
					     :(PROT_READ | PROT_WRITE),
					     MAP_SHARED,
					     rrd->fd, 0);
	if (rrd->stat_head == (stat_head_t *)MAP_FAILED)
		dcc_logbad(EX_IOERR, PROGNAME"mmap(%s): %s",
			   ofile, strerror(errno));

	rrd->ds_def = (ds_def_t *)&rrd->stat_head[1];
	rrd->rra_def = (rra_def_t *)&rrd->ds_def[rrd->stat_head->ds_cnt];
	tv = (struct timeval *)&rrd->rra_def[rrd->stat_head->rra_cnt];
	rrd->last_update.tv_sec = tv->tv_sec;
	if (!strcmp(rrd->stat_head->version, "0001")) {
		rrd->last_update.tv_usec = 0;
		rrd->pdp_prep = (pdp_prep_t *)(&tv->tv_sec + 1);
	} else {
		rrd->last_update.tv_usec = tv->tv_usec;
		rrd->pdp_prep = (pdp_prep_t *)(tv + 1);
	}
	rrd->cdp_prep = (cdp_prep_t *)&rrd->pdp_prep[rrd->stat_head->ds_cnt];
	rrd->rra_ptr = (rra_ptr_t *)&rrd->cdp_prep[rrd->stat_head->rra_cnt
						   * rrd->stat_head->ds_cnt];
	rrd->rrd_value =(rrd_value_t*)&rrd->rra_ptr[rrd->stat_head->rra_cnt];
}



static void
map_ifile(rrd_t *rrd, const char *new_fnm, const rrd_t *o_rrd)
{
#       define PAD 128
	const rra_def_t *i_def, *o_def;
	const char *old_fnm;
	off_t old_len;
	u_int rrd_num;

	old_fnm = rrd->fnm;
	old_len = rrd->sb.st_size;


	if (rrd->fd >= 0)
		rrd_close(rrd);

	rrd->fnm = new_fnm;
	rrd->fd = open(rrd->fnm, O_RDONLY, 0);
	if (rrd->fd < 0)
		dcc_logbad(EX_USAGE, PROGNAME"open(%s): %s",
			   rrd->fnm, strerror(errno));

	rrd_stat(rrd);

	if (old_fnm && rrd->sb.st_size >= old_len + PAD)
		dcc_logbad(EX_DATAERR,
			   PROGNAME"%s has "OFF_DPAT" bytes, more than "
			   OFF_DPAT" in %s",
			   new_fnm, rrd->sb.st_size, old_len, old_fnm);

	map_rrd(rrd, 1);

	if (o_rrd) {
		if (rrd->stat_head->rra_cnt != o_rrd->stat_head->rra_cnt)
			dcc_logbad(EX_DATAERR,
				   PROGNAME"%ld instead of %ld RRAs in %s",
				   rrd->stat_head->rra_cnt,
				   o_rrd->stat_head->rra_cnt,
				   rrd->fnm);
		if (rrd->stat_head->ds_cnt != o_rrd->stat_head->ds_cnt)
			dcc_logbad(EX_DATAERR,
				   PROGNAME"%ld instead of %ld DSs in %s",
				   rrd->stat_head->ds_cnt,
				   o_rrd->stat_head->ds_cnt,
				   rrd->fnm);
		if (rrd->stat_head->pdp_step != o_rrd->stat_head->pdp_step)
			dcc_logbad(EX_DATAERR,
				   PROGNAME"%ld instead of %ld step in %s",
				   rrd->stat_head->pdp_step,
				   o_rrd->stat_head->pdp_step,
				   rrd->fnm);
		for (rrd_num = 0, i_def = rrd->rra_def, o_def = o_rrd->rra_def;
		     rrd_num < o_rrd->stat_head->rra_cnt;
		     ++rrd_num, ++i_def, ++o_def) {
			if (o_def->row_cnt != i_def->row_cnt)
				dcc_logbad(EX_DATAERR,
					   PROGNAME"%ld instead of %ld"
					   " rows in RRA #%d in %s",
					   i_def->row_cnt, o_def->row_cnt,
					   rrd_num, rrd->fnm);
			if (o_def->pdp_cnt != i_def->pdp_cnt)
				dcc_logbad(EX_DATAERR,
					   PROGNAME"%ld instead of %ld"
					   " data points in RRA #%d in %s",
					   i_def->pdp_cnt, o_def->pdp_cnt,
					   rrd_num, rrd->fnm);
		}
	}
}



int
main(int argc, char **argv)
{
	rrd_t o_rrd, i_rrd;
	int fno, len;
	rrd_value_t *i_base, *o_base;
	u_long rrd;
	int rows, cols, row, i_row, o_row, col;
	rrd_value_t i_val, o_val;
	struct timeval tv;
	int newest;
	char tbuf[30];
	int i;

	memset(&i_rrd, 0, sizeof(i_rrd));
	i_rrd.fd = -1;
	memset(&o_rrd, 0, sizeof(o_rrd));
	o_rrd.fd = -1;

	while ((i = getopt(argc, argv, "fkvd:o:")) != -1) {
		switch (i) {
		case 'f':
			force = 1;
			break;
		case 'k':
			keep_mtime = 1;
			break;
		case 'v':
			++verbose;
			break;
		case 'd':
			if (0 > chdir(optarg))
				dcc_logbad(EX_USAGE, "chdir(%s): %s",
					   optarg, strerror(errno));
			break;
		case 'o':
			ofile = optarg;
			break;
		default:
			usage();
		}
	}
	argc -= optind;
	argv += optind;
	if (argc < 2 || !ofile)
		usage();

	/* find the newest file */
	map_ifile(&i_rrd, argv[0], 0);
	tv = i_rrd.last_update;
	newest = 0;
	if (verbose > 1)
		dcc_trace_msg(PROGNAME"%s last updated %s.%06d",
			      argv[0],
			      dcc_time2str(tbuf, sizeof(tbuf), "%X", tv.tv_sec),
			      (int)tv.tv_usec);
	for (fno = 1; fno < argc; ++fno) {
		map_ifile(&i_rrd, argv[fno], 0);
		if (tv.tv_sec > i_rrd.last_update.tv_sec
		    || (tv.tv_sec == i_rrd.last_update.tv_sec
			&& tv.tv_usec > i_rrd.last_update.tv_usec))
			continue;

		if (verbose > 1)
			dcc_trace_msg("%40s last updated %s.%06d",
				      argv[fno],
				      dcc_time2str(tbuf, sizeof(tbuf),
						   "%X",
						   i_rrd.last_update.tv_sec),
				      (int)i_rrd.last_update.tv_usec);
		tv = i_rrd.last_update;
		newest = fno;
	}
	if (verbose > 1)
		dcc_trace_msg("    %s is newest", argv[newest]);

	/* create and mmap() the output file */
	o_rrd.fd = open(ofile,
			O_RDWR | O_CREAT | (force ? O_TRUNC : O_EXCL),
			0666);
	if (o_rrd.fd < 0)
		dcc_logbad(EX_IOERR, PROGNAME"open(%s): %s",
			   ofile, strerror(errno));

	/* copy the newest input file to the output file */
	map_ifile(&i_rrd, argv[newest], 0);
	len = write(o_rrd.fd, i_rrd.stat_head, i_rrd.sb.st_size);
	if (len != i_rrd.sb.st_size)
		dcc_logbad(EX_IOERR, PROGNAME"write(%s, "OFF_DPAT") = %d: %s",
			   o_rrd.fnm, i_rrd.sb.st_size, len, strerror(errno));

	map_rrd(&o_rrd, 0);

	for (fno = 0; fno < argc; ++fno) {
		if (fno == newest)
			continue;

		map_ifile(&i_rrd, argv[fno], &o_rrd);

		i_base = i_rrd.rrd_value;
		o_base = o_rrd.rrd_value;
		for (rrd = 0; rrd < o_rrd.stat_head->rra_cnt; ++rrd) {
			rows = o_rrd.rra_def[rrd].row_cnt;
			cols = i_rrd.stat_head->ds_cnt;

			/* find last row in the two RRDs numbered as
			 * data consolidation moments since the UNIX epoch */
			i_row = (i_rrd.last_update.tv_sec
				 / (i_rrd.rra_def[rrd].pdp_cnt
				    * i_rrd.stat_head->pdp_step));

			o_row = (o_rrd.last_update.tv_sec
				 / (o_rrd.rra_def[rrd].pdp_cnt
				    * o_rrd.stat_head->pdp_step));

			/* Find the number of rows to combine. */
			i = o_row - i_row;
			if (i >= 0) {
				/* If the output RRD is newer than the input,
				 * then we will add only some of the input
				 * rows. */
				row = rows - i;
			} else {
				/* we have problems if the output is older */
				dcc_error_msg(PROGNAME
					      "%s newer than %s",
					      argv[fno], argv[1]);
				dcc_error_msg("    i_rrd.last_update.tv_sec"
					      " / (rra_def[%lu].pdp_cnt"
					      " * stat_head->pdp_step)"
					      "\n\t= %d / (%lu * %lu) = %d",
					      rrd,
					      (int)i_rrd.last_update.tv_sec,
					      i_rrd.rra_def[rrd].pdp_cnt,
					      i_rrd.stat_head->pdp_step,
					      i_row);
				dcc_logbad(EX_DATAERR,
					   "    o_rrd.last_update.tv_sec"
					   " / (rra_def[%lu].pdp_cnt"
					   " * stat_head->pdp_step)"
					   "\n\t= %d / (%lu * %lu) = %d",
					   rrd,
					   (int)o_rrd.last_update.tv_sec,
					   o_rrd.rra_def[rrd].pdp_cnt,
					   o_rrd.stat_head->pdp_step,
					   o_row);
			}

			i_row = (i_rrd.rra_ptr[rrd].cur_row + 1) * cols;
			o_row = (o_rrd.rra_ptr[rrd].cur_row + 1) * cols;
			do {
				/* wrap to the start at the last row */
				if (i_row >= rows*cols)
					i_row = 0;
				if (o_row >= rows*cols)
					o_row = 0;

				for (col = 0;
				     col < cols;
				     ++col, ++i_row, ++o_row) {
					i_val = i_base[i_row];
					if (isnan(i_val))
					    continue;
					o_val = o_base[o_row];
					if (isnan(o_val)) {
					    o_val = i_val;
					} else {
					    o_val += i_val;
					}
					o_base[o_row] = o_val;
				}
			} while (--row > 0);

			i_base += rows * cols;
			o_base += rows * cols;
		}
	}


	unmap_rrd(&o_rrd);
	fsync(o_rrd.fd);
	if (!keep_mtime
	    && !dcc_set_mtime(dcc_emsg, ofile, o_rrd.fd, &o_rrd.last_update)) {
		dcc_logbad(EX_IOERR, PROGNAME"%s", dcc_emsg);
		exit(1);
	}

	exit(0);
}
