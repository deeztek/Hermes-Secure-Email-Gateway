/* Distributed Checksum Clearinghouse
 *
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
 * Rhyolite Software DCC 2.3.167-1.5 $Revision$
 */

#include "dcc_defs.h"


#undef DEBUG_DIVISIONS
/* #define DEBUG_DIVISIONS */

/* Get a modulus for a hash function that is tolerably likely to be
 * relatively prime to most inputs.  We get a prime for for initial
 * values not larger than the square of the last prime.  We often get a prime
 * after that.
 * This works well in practice for hash tables up to at least 100
 * times the square of the last prime and better than a multiplicative hash. */
u_int32_t
hash_divisor(u_int32_t initial, u_char smaller)
{
	static u_int32_t primes[] = {
		  3,   5,   7,  11,  13,  17,  19,  23,  29,  31,  37,  41,
		 43,  47,  53,  59,  61,  67,  71,  73,  79,  83,  89,  97,
		101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157,
		163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227,
		229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283,
		293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367,
		373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439,
		443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509,
		521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599,
		601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661,
		673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751,
		757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829,
		839, 853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919,
		929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997,1009
	};
#ifdef DEBUG_DIVISIONS
	int divisions;
#endif
	u_int32_t delta, result;
	u_int32_t *pp, p;

	result = initial;

	if (primes[DIM(primes)-1] >= result) {
		pp = primes;
		while (*pp < result)
			++pp;
		if (smaller && *pp > result && pp > primes)
			--pp;
		return *pp;
	}

	if (smaller) {
		delta = -2;
		if (!(result & 1))
			--result;
	} else {
		delta = 2;
		if (!(result & 1))
			++result;
	}

#ifdef DEBUG_DIVISIONS
	divisions = 0;
#endif
	pp = primes;
	do {
		p = *pp++;
#ifdef DEBUG_DIVISIONS
		++divisions;
#endif
		if ((result % p) == 0) {
			result += delta;
			pp = primes;
		}
	} while (pp < &primes[DIM(primes)]);
#ifdef DEBUG_DIVISIONS
	if (divisions >= DIM(primes))
		dcc_trace_msg("%d hash_divisor() divisions to get %d from %d",
			      divisions, result, initial);
#endif
	return result;
}
