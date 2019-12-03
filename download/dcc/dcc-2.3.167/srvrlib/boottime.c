/* Distributed Checksum Clearinghouses
 *
 * Discover when the system was booted.
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
 * Rhyolite Software DCC 2.3.167-1.4 $Revision$
 */

#include "srvr_defs.h"
#ifdef HAVE_BOOTTIME
#include <sys/sysctl.h>
#endif


u_char have_boottime = 1;


u_char
get_boottime(struct timeval *boottime, DCC_EMSG *emsg)
{
#ifdef HAVE_BOOTTIME
	int mib[2] = {CTL_KERN, KERN_BOOTTIME};
	size_t boottime_len;
#else
	FILE *f_uptime;
	char uptime_buf[80];
	int uptime, x;
#endif
	u_char result;

	result = 0;
	have_boottime = 1;
#ifdef HAVE_BOOTTIME
	boottime_len = sizeof(*boottime);
	if (0 > sysctl(mib, 2, boottime, &boottime_len, 0, 0)) {
		dcc_pemsg(EX_OSERR, emsg,
			  "sysctl(KERN_BOOTTIME): %s", ERROR_STR());
		boottime->tv_sec = 0x7fffffff;
		boottime->tv_usec = 0;
	} else {
		result = 1;
	}
#else
	boottime->tv_sec = 0x7fffffff;
	boottime->tv_usec = 0;
	f_uptime = fopen("/proc/uptime", "r");
	if (f_uptime == NULL) {
		dcc_pemsg(EX_OSERR, emsg, "fopen(\"/proc/uptime\", \"r\"): %s",
			  ERROR_STR());
		if (errno == ENOENT)
			have_boottime = 0;
		return 0;
	}
	memset(uptime_buf, 0, sizeof(uptime_buf));
	if (!fread(uptime_buf, sizeof(uptime_buf), 1, f_uptime)
	    && ferror(f_uptime)) {
		dcc_pemsg(EX_OSERR, emsg, "fread(\"/proc/uptime\"): %s",
			  ERROR_STR());
	} else if (4 != sscanf(uptime_buf, "%d.%d %d.%d\n",
			       &uptime, &x, &x, &x)) {
		uptime_buf[sizeof(uptime_buf)-1] = '\0';
		dcc_pemsg(EX_OSERR, emsg, "\"/proc/uptime\" contains \"%s\"",
			  uptime_buf);
		boottime->tv_sec = 0x7fffffff;
		boottime->tv_usec = 0;
	} else {
		boottime->tv_sec = time(0) - uptime;
		boottime->tv_usec = 0;
		result = 1;
	}
	fclose(f_uptime);
#endif
	return result;
}
