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
 *
 * Rhyolite Software DCC 2.3.167-1.20 $Revision$
 */

#include "dcc_clnt.h"
#include "dcc_heap_debug.h"
#ifdef DCC_UNIX
#include <syslog.h>
#endif


static int
parse_level(const char *level)
{
	static struct {
	    const char *str;
	    int level;
	} level_tbl[] = {
	    {"EMERG",	LOG_EMERG},
	    {"ALERT",	LOG_ALERT},
	    {"CRIT",	LOG_CRIT},
	    {"ERR",	LOG_ERR},
	    {"WARNING",	LOG_WARNING},
	    {"NOTICE",	LOG_NOTICE},
	    {"INFO",	LOG_INFO},
	    {"DEBUG",	LOG_DEBUG},
	};
	int i;

	for (i = 0; i < DIM(level_tbl); ++i) {
		if (!strcasecmp(level, level_tbl[i].str))
			return level_tbl[i].level;
	}
	return -1;
}



static int
parse_facility(const char *facility)
{
	static struct {
	    const char *str;
	    int facility;
	} facility_tbl[] = {
	    {"AUTH",	LOG_AUTH},
#ifdef LOG_AUTHPRIV
	    {"AUTHPRIV",LOG_AUTHPRIV},
#endif
	    {"CRON",	LOG_CRON},
	    {"DAEMON",	LOG_DAEMON},
#ifdef LOG_FTP
	    {"FTP",	LOG_FTP},
#endif
	    {"KERN",	LOG_KERN},
	    {"LPR",	LOG_LPR},
	    {"MAIL",	LOG_MAIL},
	    {"NEWS",	LOG_NEWS},
	    {"USER",	LOG_USER},
	    {"UUCP",	LOG_UUCP},
	    {"LOCAL0",	LOG_LOCAL0},
	    {"LOCAL1",	LOG_LOCAL1},
	    {"LOCAL2",	LOG_LOCAL2},
	    {"LOCAL3",	LOG_LOCAL3},
	    {"LOCAL4",	LOG_LOCAL4},
	    {"LOCAL5",	LOG_LOCAL5},
	    {"LOCAL6",	LOG_LOCAL6},
	    {"LOCAL7",	LOG_LOCAL7},
	};
	int i;

	for (i = 0; i < DIM(facility_tbl); ++i) {
		if (!strcasecmp(facility, facility_tbl[i].str))
			return facility_tbl[i].facility;
	}
	return -1;
}



u_char
dcc_parse_log_opt(const char *arg)
{
	char *duparg, *facility, *level;
	int priority, *resultp;

	if (!LITCMP(arg, "off")) {
		dcc_no_syslog = 1;
		return 1;
	}

	duparg = dcc_strdup(arg);
	facility = strpbrk(duparg, ".,");
	if (!facility) {
		dcc_error_msg("missing syslog facility in \"-L %s\"", arg);
		dcc_free(duparg);
		return 0;
	}
	*facility++ = '\0';

	if (!strcasecmp(duparg, "info")) {
		resultp = &dcc_trace_priority;
	} else if (!strcasecmp(duparg, "error")) {
		resultp = &dcc_error_priority;
	} else {
		dcc_error_msg("\"%s\" in \"-L %s\""
			      " is neither \"info\" nor \"error\"",
			      duparg,arg);
		dcc_free(duparg);
		return 0;
	}

	level = strpbrk(facility, ".,");
	if (!level) {
		dcc_error_msg("missing syslog level in \"-L %s\"", arg);
		dcc_free(duparg);
		return 0;
	}
	*level++ = '\0';

	/* allow both level.facility and facility.level */
	priority = parse_facility(facility);
	if (priority >= 0) {
		priority |= parse_level(level);
	} else {
		priority = parse_facility(level);
		if (priority < 0) {
			dcc_error_msg("unrecognized facility in \"%s\"", arg);
			dcc_free(duparg);
			return 0;
		}
		priority |= parse_level(facility);
	}
	if (priority < 0) {
		dcc_error_msg("unrecognized level in \"%s\"", arg);
		dcc_free(duparg);
		return 0;
	}

	*resultp = priority;
	dcc_free(duparg);
	return 1;
}
