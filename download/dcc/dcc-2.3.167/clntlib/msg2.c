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
 * Rhyolite Software DCC 2.3.167-1.60 $Revision$
 */

#include "dcc_defs.h"
#include "dcc_paths.h"
#ifdef DCC_UNIX
#include <syslog.h>
#endif
#ifdef DCC_WIN32
#include <direct.h>
#endif

extern void dcc_syslog_lock(void);
extern void dcc_syslog_unlock(void);

u_char trace_quiet;


/* talk to stderr and the system log or only to system log if being quiet */
void DCC_PF(1,2)
quiet_trace_msg(const char *p, ...)
{
	va_list args;

	va_start(args, p);
	if (trace_quiet && !dcc_no_syslog) {
		dcc_syslog_lock();
		vsyslog(dcc_trace_priority, p, args);
		dcc_syslog_unlock();
	} else {
		dcc_vtrace_msg(p, args);
	}
	va_end(args);
}



int
vearly_log(EARLY_LOG *el, const char *p, va_list args)
{
#	define ELIPS_STR "...\n"
	int max_len, len;

	max_len = sizeof(el->buf) - el->len;
	if (max_len <= 0)
		return 0;

	len = vsnprintf(&el->buf[el->len], max_len, p, args);
	if (len < max_len) {
		el->len += len;
		return len;
	} else {
		memcpy(&el->buf[sizeof(el->buf)-LITZ(ELIPS_STR)],
		       ELIPS_STR, LITZ(ELIPS_STR));
		el->len = sizeof(el->buf);
		return max_len;
	}

#undef ELIPS_STR
}



/* not thread safe */
const char *
optopt2str(int i)
{
	static char b[] = "-x";

	b[1] = i;
	return b;
}



static inline u_char
bytes2str(char **bufp, u_int *buf_lenp, u_int bytes,
	  u_int blanks, const u_char **p, u_int *hdr_len)
{
	int i;

	while (bytes != 0 && *hdr_len != 0) {
		if (blanks+2+3 > *buf_lenp) {
			snprintf(*bufp, *buf_lenp, "%*s...", blanks, "");
			return 0;
		}
		i = snprintf(*bufp, *buf_lenp, "%*s%02x", blanks, "", **p);
		*bufp += i;
		*buf_lenp -= i;
		blanks = 0;
		++*p;
		--bytes;
		if (--*hdr_len == 0)
			return 0;
	}
	return 1;
}



char *
hdr2str(char *buf0, u_int buf_len, const DCC_HDR *hdr, u_int hdr_len)
{
	char *buf;
	const u_char *p;

	buf = buf0;
	*buf = '\0';
	p = (u_char *)hdr;

	if (!bytes2str(&buf, &buf_len, 2, 0, &p, &hdr_len)) /* hdr->len */
		return buf0;
	if (!bytes2str(&buf, &buf_len, 1, 1, &p, &hdr_len)) /* hdr->pkt_vers */
		return buf0;
	if (!bytes2str(&buf, &buf_len, 1, 1, &p, &hdr_len)) /* hdr->op */
		return buf0;

	while (hdr_len > 0) {
		if (!bytes2str(&buf, &buf_len, 4, 1, &p, &hdr_len))
			return buf0;
	}
	return buf0;
}
