/* Distributed Checksum Clearinghouse heap debugging
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
 * Rhyolite Software DCC 2.3.167-1.25 $Revision$
 */

#include "dcc_defs.h"
#include "dcc_heap_debug.h"
#include <stdio.h>

void dcc_malloc_lock(void);
void dcc_malloc_unlock(void);

#ifndef DCC_UNIX
#include "malloc.h"
#endif /* !DCC_UNIX */


typedef u_long SENTINEL;
#define HEAD_SENTINEL_VALUE 0xdeadbeaf
#define TAIL_SENTINEL_VALUE 0xbeafdead

typedef struct mdbg{
    SENTINEL	head;
    struct mdbg *fwd, *bak;
    SENTINEL	*tail;
} MDBG;

u_int dcc_num_mdbg;			/* global to suppress warnings */
MDBG *dcc_mdbg_chain;			/*	when not used */
MDBG *bad_mp;
int bad_i;

/* leave a few names outside to make some `ar`s happy */
#ifdef DCC_DEBUG_HEAP


/* This needs to do as little as possible to avoid calling malloc().
 *	Global and no DCC_NORET to avoid confusion in dumps. */
void
dcc_heap_abort(const char *m)
{
#ifdef DCC_UNIX
	static int die;			/* suppress no-return warning */

	write(STDERR_FILENO, m, strlen(m));
	if (++die)
		abort();
#else
	bad_message_box("heap_debug", 1, m);
#endif
}



char *
dcc_strdup(const char *s)
{
	char *p;

	p = dcc_malloc(strlen(s)+1);
	strcpy(p, s);
	return p;
}



void
dcc_malloc_check(void)
{
	MDBG *mp;
	u_int i;

	i = dcc_num_mdbg;
	if (!i)
		return;

	mp = dcc_mdbg_chain;
	for (;;) {
		if (mp->head != HEAD_SENTINEL_VALUE
		    || *mp->tail != TAIL_SENTINEL_VALUE)
			dcc_heap_abort("trashed heap sentinel");
		if (mp->bak->fwd != mp
		    || mp->fwd->bak != mp) {
			bad_mp = mp;
			bad_i = i;
			dcc_heap_abort("malloc chain trashed");
		}
		if (--i == 0) {
			if (mp->fwd != dcc_mdbg_chain) {
				bad_mp = mp;
				bad_i = i;
				dcc_heap_abort("wrong malloc chain too long");
			}
#ifndef DCC_UNIX
			i = _heapchk();
			if (i != _HEAPOK && i != _HEAPEMPTY)
				dcc_heap_abort("heapchk() failed");
#endif
			return;
		} else if (mp->fwd == dcc_mdbg_chain) {
			bad_mp = mp;
			bad_i = i;
			dcc_heap_abort("wrong malloc chain too short");
		}
		mp = mp->fwd;
	}
}



void *
dcc_malloc(size_t len)
{
	MDBG *mp;

	dcc_malloc_lock();
	dcc_malloc_check();

	if (!len)
		dcc_heap_abort("malloc(0)");

	len += sizeof(MDBG) + sizeof(mp->tail);
	len += (sizeof(mp->tail) - len) & (sizeof(mp->tail)-1); /* align tail */

	mp = malloc(len);
	if (!mp)
		return mp;

	if (!dcc_num_mdbg) {
		mp->fwd = mp->bak = mp;
	} else {
		mp->bak = dcc_mdbg_chain;
		mp->fwd = dcc_mdbg_chain->fwd;
		mp->bak->fwd = mp;
		mp->fwd->bak = mp;
	}
	dcc_mdbg_chain = mp;
	mp->head = HEAD_SENTINEL_VALUE;
	mp->tail = (SENTINEL *)((u_char *)mp+len-sizeof(mp->tail));
	*mp->tail = TAIL_SENTINEL_VALUE;
	dcc_num_mdbg++;
	dcc_malloc_unlock();

	return (mp+1);
}



void *
dcc_calloc(size_t n, size_t s)
{
	void *p;

	s *= n;
	if (s == 0)
		dcc_heap_abort("zero calloc() size");
	p = dcc_malloc(s);
	if (!p)
		return p;
	memset(p, 0, s);
	return p;
}



void
dcc_free(void *p)
{
	int i;
	MDBG *mp;

	dcc_malloc_lock();
	dcc_malloc_check();
	i = dcc_num_mdbg;
	mp = dcc_mdbg_chain;
	for (;;) {
		if (!i)
			dcc_heap_abort("freeing non-malloc");
		if (mp+1 == p)
			break;
		mp = mp->fwd;
		i--;
	}

	if (dcc_mdbg_chain == mp)
		dcc_mdbg_chain = mp->fwd;
	mp->bak->fwd = mp->fwd;
	mp->fwd->bak = mp->bak;
	dcc_num_mdbg--;
	memset(mp, 0xf1, (u_char *)mp->tail+sizeof(mp->tail)-(u_char *)mp);
	dcc_malloc_check();
	dcc_malloc_unlock();

	free(mp);
}
#endif /* DCC_DEBUG_HEAP */
