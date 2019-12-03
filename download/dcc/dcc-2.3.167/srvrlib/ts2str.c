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

#define TS_PAT "%y/%m/%d %H:%M:%S"


/* not necessarily thread safe because gmtime_r() might be gmtime() */
char *
tv2str(char *ts_buf, u_int ts_buf_len, const struct timeval *tv,
       u_char show_usecs)
{
	struct tm tm;
	char time_buf[30];

	DCC_GMTIME(tv->tv_sec, &tm);
	if (!show_usecs) {
		strftime(ts_buf, ts_buf_len, TS_PAT, &tm);
	} else {
		strftime(time_buf, sizeof(time_buf), TS_PAT, &tm);
		snprintf(ts_buf, ts_buf_len, "%s.%06d",
			 time_buf, (int)tv->tv_usec);
	}
	return ts_buf;
}



/* not necessarily thread safe because gmtime_r() might be gmtime() */
char *
ts2str(char *ts_buf, u_int ts_buf_len, const DCC_TS *ts)
{
	struct timeval tv;

	ts2timeval(&tv, ts);
	return tv2str(ts_buf, ts_buf_len, &tv, 1);
}



/* not thread safe but good enough for error messages */
const char *
ptime2str_err(DCC_PTIME secs)
{
	static int bufno;
	static struct {
	    char    str[40];
	} bufs[4];
	char *s;
	struct timeval tv;

	s = bufs[bufno].str;
	bufno = (bufno+1) % DIM(bufs);

	tv.tv_sec = secs;
	tv.tv_usec = 0;
	return tv2str(s, sizeof(bufs[0].str), &tv, 0);
}



/* not thread safe but good enough for error messages */
const char *
ts2str_err(const DCC_TS *ts)
{
	static int bufno;
	static struct {
	    char    str[40];
	} bufs[4];
	char *s;

	s = bufs[bufno].str;
	bufno = (bufno+1) % DIM(bufs);

	return ts2str(s, sizeof(bufs[0].str), ts);
}
