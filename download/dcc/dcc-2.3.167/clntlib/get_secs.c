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
 * Rhyolite Software DCC 2.3.167-1.25 $Revision$
 */

#include "dcc_defs.h"


/* because tv.tv_sec is not a time_t on all systems
 * and to be thread safe on WIN32 */
const struct tm *
dcc_localtime(time_t secs, struct tm *result)
{
#ifdef HAVE_LOCALTIME_R
	result = localtime_r(&secs, result);
#else
	dcc_localtime_lock();
	result = localtime(&secs);
	dcc_localtime_unlock();
#endif
	return result;
}



const char *
dcc_time2str(char *buf, size_t buf_len, const char *pat, time_t secs)
{
	struct tm tm;

	if (0 >= strftime(buf, buf_len, pat, dcc_localtime(secs, &tm)))
		STRLCPY(buf, "...?", buf_len);
	return buf;
}



int
dcc_get_secs(const char *s, const char **end, int min, int max, int def)
{
	const char *cp;
	char *p;
	int secs;

	if (*s == '\0' || *s == ',') {
		secs = def;
		cp = s;
	} else if (min > 0
		   && !CLITCMP(s, "never")) {
		cp = s+LITZ("never");
		secs = max;
	} else if ((secs = strtoul(s, &p, 10)) >= DCC_MAX_SECS/60) {
		return -1;
	} else if (*(cp = p) == '\0' || *cp == ',') {
		;
	} else if (!CLITCMP(cp, "seconds")) {
		cp += LITZ("seconds");
	} else if (!CLITCMP(cp, "s")) {
		cp += LITZ("s");

	} else if (!CLITCMP(cp, "minutes")) {
		cp += LITZ("minutes");
		secs *= 60;
	} else if (!CLITCMP(cp, "minute")) {
		cp += LITZ("minute");
		secs *= 60;
	} else if (!CLITCMP(cp, "m")) {
		cp += LITZ("m");
		secs *= 60;

	} else if (secs >= DCC_MAX_SECS/(60*60)) {
		return -1;
	} else if (!CLITCMP(cp, "hours")) {
		cp += LITZ("hours");
		secs *= 60*60;
	} else if (!CLITCMP(cp, "hour")) {
		cp += LITZ("hour");
		secs *= 60*60;
	} else if (!CLITCMP(cp, "h")) {
		cp += LITZ("h");
		secs *= 60*60;

	} else if (secs >= DCC_MAX_SECS/(24*60*60)) {
		return -1;
	} else if (!CLITCMP(cp, "days")) {
		cp += LITZ("days");
		secs *= 24*60*60;
	} else if (!CLITCMP(cp, "day")) {
		cp += LITZ("day");
		secs *= 24*60*60;
	} else if (!CLITCMP(cp, "d")) {
		cp += LITZ("d");
		secs *= 24*60*60;

	} else if (secs >= DCC_MAX_SECS/(7*24*60*60)) {
		return -1;
	} else if (!CLITCMP(cp, "weeks")) {
		cp += LITZ("weeks");
		secs *= 7*24*60*60;
	} else if (!CLITCMP(cp, "week")) {
		cp += LITZ("week");
		secs *= 7*24*60*60;
	} else if (!CLITCMP(cp, "w")) {
		cp += LITZ("w");
		secs *= 7*24*60*60;

	} else {
		return -1;
	}

	if (secs > max)
		return -1;
	if (secs < min && secs != 0)
		return -1;

	if (*cp != '\0') {
		if (*cp != ',' || !end)
			return -1;
		++cp;
	}
	if (end)
		*end = cp;
	return secs;
}



time_t
tv_diff2us(const struct timeval *tv1, const struct timeval *tv2)
{
	time_t us;

	/* prevent overflow */
	us = tv1->tv_sec - tv2->tv_sec;
	if (us <= -FOREVER_SECS)
		return -FOREVER_US;
	if (us >= FOREVER_SECS)
		return FOREVER_US;
	us = us*DCC_US + (tv1->tv_usec - tv2->tv_usec);
	return us;
}



void
tv_add(struct timeval *tgt,
       const struct timeval *a,
       const struct timeval *b)
{
	tgt->tv_sec = a->tv_sec + b->tv_sec;
	tgt->tv_usec = a->tv_usec + b->tv_usec;
	tgt->tv_sec += tgt->tv_usec / DCC_US;
	tgt->tv_usec %= DCC_US;
}



void
tv_add_us(struct timeval *tgt,
	  time_t us)
{
	time_t secs;

	us = tgt->tv_usec + us;
	if (us >= 0) {
		tgt->tv_sec += us / DCC_US;
		tgt->tv_usec = us % DCC_US;
	} else {
		secs = (DCC_US - 1 - us) / DCC_US;
		tgt->tv_sec -= secs;
		tgt->tv_usec = (secs * DCC_US) + us;
	}
}
