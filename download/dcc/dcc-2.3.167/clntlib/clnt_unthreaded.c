/* Distributed Checksum Clearinghouse
 *
 * unthreaded version of client locking
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
 * Rhyolite Software DCC 2.3.167-1.53 $Revision$
 */

#include "dcc_ck.h"


/* many POSIX thread implementations have unexpected side effects on
 * ordinary system calls, so don't use the threaded version unless
 * necessary */

u_char clnt_threaded = 0;


static u_char ctxts_locked;


void
dcc_ctxts_lock(void)
{
#ifdef DCC_DEBUG_LOCKS
	if (ctxts_locked)
		dcc_logbad(EX_SOFTWARE, "already have ctxts lock");
#endif
	++ctxts_locked;
}



void
dcc_ctxts_unlock(void)
{
	assert_ctxts_locked();
	--ctxts_locked;
}



#ifdef DCC_DEBUG_LOCKS
void
assert_ctxts_locked(void)
{
	if (!ctxts_locked)
		dcc_logbad(EX_SOFTWARE, "don't have ctxts lock");
}



void
assert_ctxts_unlocked(void)
{
	if (ctxts_locked)
		dcc_logbad(EX_SOFTWARE, "have ctxts lock");
}
#endif



#ifdef DCC_DEBUG_HEAP
void
dcc_malloc_lock(void)
{
}


void
dcc_malloc_unlock(void)
{
}
#endif /* DCC_DEBUG_HEAP */



#ifndef HAVE_LOCALTIME_R
void
dcc_localtime_lock(void)
{
}



void
dcc_localtime_unlock(void)
{
}
#endif /* HAVE_LOCALTIME_R */



void
dcc_clnt_unthread_init(void)
{
#ifdef DCC_WIN32
	dcc_win32_init();
#endif
}


u_char
dcc_clnt_wake_resolve(void)
{
	return 0;
}



#ifdef DCC_DEBUG_LOCKS
void
assert_cwf_locked(void)
{
}
#endif



static u_char helper_locked;

u_char
helper_lock_init(void)
{
	return 0;
}



void
helper_lock(void)
{
#ifdef DCC_DEBUG_LOCKS
	if (helper_locked)
		dcc_logbad(EX_SOFTWARE, "already have helper lock");
#endif
	++helper_locked;
}



void
helper_unlock(void)
{
	assert_helper_locked();
	--helper_locked;
}



#ifdef DCC_DEBUG_LOCKS
void
assert_helper_locked(void)
{
	if (!helper_locked)
		dcc_logbad(EX_SOFTWARE, "don't have helper lock");
}



void
assert_helper_unlocked(void)
{
	if (helper_locked)
		dcc_logbad(EX_SOFTWARE, "have helper lock");
}
#endif



/* dccproc and dccsight do not generate SMTP error messages */
const REPLY_TPLT *
dnsbl_parse_reply(const char *pat DCC_UNUSED)
{
	return 0;
}
