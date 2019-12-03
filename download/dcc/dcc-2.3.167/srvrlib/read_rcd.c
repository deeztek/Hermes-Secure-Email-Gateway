/* Distributed Checksum Clearinghouse
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
 * Rhyolite Software DCC 2.3.167-1.29 $Revision$
 */

#include "srvr_defs.h"

static int read_rcd_fd = -1;
#define BUF_SIZE    (64*1024)
static u_char read_rcd_buf[BUF_SIZE];
static u_int read_rcd_bufsize = BUF_SIZE;
static off_t read_rcd_base;
static u_int read_rcd_buflen;



int
read_db(DCC_EMSG *emsg, void *buf, u_int buf_len,
	int fd, off_t pos, const char *file_nm)
{
	int i;

	if (-1 == lseek(fd, pos, SEEK_SET)) {
		dcc_pemsg(EX_IOERR, emsg, "lseek(%s, 0): %s",
			  DB_NM2PATH_ERR(file_nm), ERROR_STR());
		return -1;
	}

	i = read(fd, buf, buf_len);
	if (i >= 0)
		return i;

	dcc_pemsg(EX_IOERR, emsg, "read(%s): %s",
		  DB_NM2PATH_ERR(file_nm), ERROR_STR());
	return -1;
}



u_char
read_db_hdr(DCC_EMSG *emsg, DB_HDR *hdrp,
	   int fd, const char *file_nm)
{
	int i;

	i = read_db(emsg, hdrp, sizeof(*hdrp), fd, 0, file_nm);
	if (i == sizeof(*hdrp))
		return 1;
	if (i >= 0)
		dcc_pemsg(EX_DATAERR, emsg, "found only %d bytes in %s",
			  i, file_nm);
	return 0;
}



/* invalidate the read_rcd() read-ahead cache */
void
read_rcd_invalidate(u_int bufsize)
{
	read_rcd_fd = -1;

	/* Set the size of the buffer for the next read_rcd()
	 * to bufsize rounded up to an even system page size
	 * but not larger than BUF_SIZE,
	 * and BUF_SIZE if bufsize was 0. */
	if (sys_pagesize == 0)
		sys_pagesize = getpagesize();
	bufsize += sys_pagesize-1;
	bufsize -= bufsize % sys_pagesize;
	if (bufsize == 0 || bufsize > BUF_SIZE)
		bufsize = BUF_SIZE;
	read_rcd_bufsize = bufsize;
}



static int
read_rcd_sub(DCC_EMSG *emsg, void *buf, u_int buflen,
	     int fd, off_t pos, const char *file_nm)
{
	int i;

	if (fd != read_rcd_fd
	    || pos < read_rcd_base
	    || pos+buflen > read_rcd_base+read_rcd_buflen) {
		if (sys_pagesize == 0)
			sys_pagesize = getpagesize();
		read_rcd_base = pos - (pos % sys_pagesize);

		i = read_db(emsg, read_rcd_buf, read_rcd_bufsize,
			    read_rcd_fd = fd,
			    read_rcd_base, file_nm);
		if (i <= 0) {
			read_rcd_fd = -1;
			return i;
		}
		read_rcd_buflen = i;
		if (buflen > read_rcd_buflen)
			buflen = read_rcd_buflen;
	}

	memcpy(buf, &read_rcd_buf[pos-read_rcd_base], buflen);
	return buflen;
}



int					/* -1=error 0=eof >0=record length */
read_rcd(DCC_EMSG *emsg, DB_RCD *rcd,
	 int fd, off_t pos, const char *file_nm)
{
	int i, cks_len, num_cks;

	/* read a record, starting with its beginning */
	i = read_rcd_sub(emsg, rcd, DB_RCD_HDR_LEN,
			 fd, pos, file_nm);
	if (DB_RCD_HDR_LEN != i) {
		if (i == 0)
			return 0;
		if (i > 0) {
			dcc_pemsg(EX_DATAERR, emsg,
				  "header of record at "OFF_HPAT" of %s"
				  " truncated by %d bytes",
				  lseek(fd, 0, SEEK_CUR) - i,
				  DB_NM2PATH_ERR(file_nm), DB_RCD_HDR_LEN-i);
		}
		return -1;
	}

	num_cks = DB_NUM_CKS(rcd);
	if (num_cks > DIM(rcd->cks)) {
		dcc_pemsg(EX_DATAERR, emsg,
			  "bogus checksum count %#x at "OFF_HPAT" of %s",
			  rcd->fgs_num_cks, lseek(fd, 0, SEEK_CUR),
			  DB_NM2PATH_ERR(file_nm));
		return -1;
	}
	cks_len = num_cks * sizeof(rcd->cks[0]);
	if (cks_len != 0) {
		i = read_rcd_sub(emsg, rcd->cks, cks_len,
				 fd, pos+DB_RCD_HDR_LEN, file_nm);
		if (i != cks_len) {
			if (i < 0)
				return -1;
			if (!i)
				dcc_pemsg(EX_DATAERR, emsg,
					  "record at "OFF_HPAT" of %s"
					  " truncated after header",
					  lseek(fd, 0, SEEK_CUR),
					  DB_NM2PATH_ERR(file_nm));
			else
				dcc_pemsg(EX_DATAERR, emsg,
					  "record at "OFF_HPAT" of %s"
					  " truncated by %d bytes",
					  lseek(fd, 0, SEEK_CUR),
					  DB_NM2PATH_ERR(file_nm), cks_len-i);
			return 0;
		}
	}

	return DB_RCD_HDR_LEN+cks_len;
}
