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
 *
 * Rhyolite Software DCC 2.3.167-1.12 $Revision$
 */

#ifndef DCC_HEAP_DEBUG_H
#define DCC_HEAP_DEBUG_H

#ifdef DCC_DEBUG_HEAP
extern void *dcc_malloc(size_t);
extern void *dcc_calloc(size_t, size_t);
extern void dcc_malloc_check(void);
extern char *dcc_strdup(const char *);
extern void dcc_free(void *);
#ifdef DCC_UNIX
extern char *malloc_options;
#endif

#else /* !DCC_DEBUG_HEAP */
#define dcc_malloc(l) malloc(l)
#define dcc_calloc(l,n) calloc(l,n)
#define dcc_malloc_check()
#define dcc_strdup(s) strdup(s)
#define dcc_free(p) free(p)
#endif /* !DCC_DEBUG_HEAP */

#endif /* DCC_HEAP_DEBUG_H */
