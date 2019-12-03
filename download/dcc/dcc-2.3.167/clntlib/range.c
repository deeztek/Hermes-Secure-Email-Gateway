/* Distributed Checksum Clearinghouse
 *
 * IP address ranges
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
 * Rhyolite Software DCC 2.3.167-1.20 $Revision$
 */

#include "dcc_defs.h"
#ifndef DCC_WIN32
#include <arpa/inet.h>			/* for AIX */
#endif



/* strip leading and trailing white space */
static const char *
strip_white(const char *str, u_int *lenp)
{
	const char *end;
	char c;

	str += strspn(str, DCC_WHITESPACE);
	end = str+strlen(str);
	while (end > str) {
		c = *(end-1);
		if (c != ' ' && c != '\t' && c != '\r' && c != '\n')
			break;
		--end;
	}
	*lenp = end-str;
	return str;
}



/* get a socket address from a dotted quad or IPv6 string */
u_char
str2su(DCC_SOCKU *sup, const char *str)
{
	char buf[INET6_ADDRSTRLEN];
	struct in_addr addr4;
	struct in6_addr addr6;
	u_int len, len2;
	const char *p;

	str = strip_white(str, &len);
	if (len == 0 || len >= INET6_ADDRSTRLEN)
		return 0;

	len2 = strspn(str, DCC_IPV4_CHARS);
	if (len2 == len && len2 < INET_ADDRSTRLEN) {
#ifdef HAVE_INET_ATON
		if (0 < inet_aton(str, &addr4)) {
			if (sup)
				dcc_mk_inet_su(sup, &addr4, 0);
			return 1;
		}
#else
		/* this fails on 0.0.0.0 */
		addr4.s_addr = inet_addr(str);
		if (addr4.s_addr != INADDR_NONE) {
			if (sup)
				dcc_mk_inet_su(sup, &addr4, 0);
			return 1;
		}
#endif
	}

	/* require at least one colon among valid IPv6 characters */
	len2 = strspn(str, DCC_IPV6_CHARS);
	if (len2 != len)
		return 0;
	p = strchr(str, ':');
	if (!p || p >= &str[len-1])
		return 0;

	/* Try IPv6 only after failing to understand the string as IPv4
	 * and making other quick checks.
	 * The quick checks can be fooled by junk such as 123:aaaaaaaa
	 *
	 * inet_pton() does not like blanks or terminal '\n'
	 * It is also too smart by half and assumes that its void* is a
	 * struct sockaddr*.
	 *
	 * inet_pton() does not know about scopes.
	 *
	 * When inet_pton() decodes an IPv4 address, it sticks it
	 * 4 bytes before the start of an IPv6 buffer it is given.
	 * Since we have already checked for IPv4, that should not be
	 * a problem. */
	if (str[len] != '\0') {
		memcpy(buf, str, len);
		buf[len] = '\0';
		str = buf;
	}
	if (0 < DCC_INET_PTON(AF_INET6, str, &addr6)) {
		if (sup)
			dcc_mk_inet6_su(sup, &addr6, 0, 0);
		return 1;
	}

	return 0;
}



void
bits2mask(struct in6_addr *mask, int bits)
{
	int wordno, i;

	for (wordno = 0; wordno < 4; ++wordno) {
		i = bits - wordno*32;
		if (i >= 32) {
			mask->s6_addr32[wordno] = 0xffffffff;
			continue;
		}
		if (i <= 0) {
			mask->s6_addr32[wordno] = 0;
			continue;
		}
		mask->s6_addr32[wordno] = htonl(0xffffffff << (32-i));
	}
}



u_char					/* 0=address not on boundary */
cidr2range(DCC_IP_RANGE *range, const struct in6_addr *addr, int bits)
{
	struct in6_addr mask;
	u_char result;
	int i;

	result = 1;
	bits2mask(&mask, bits);
	for (i = 0; i < 4; ++i) {
		if ((addr->s6_addr32[i] & ~mask.s6_addr32[i]) != 0)
			result = 0;

		if (&range->lo != addr)
			range->lo.s6_addr32[i] = (addr->s6_addr32[i]
						  & mask.s6_addr32[i]);
		range->hi.s6_addr32[i] = (addr->s6_addr32[i]
					  | ~mask.s6_addr32[i]);
	}
	return result;
}



static u_char				/* bits or 0 if not a CIDR block */
range2cidr(const DCC_IP_RANGE *r)
{
	int byteno, bits;
	u_int8_t b, m;

	/* This could be done faster with various tricks, but this code
	 * is rarely used and this way is easier to understand and verify */

	bits = 0;
	m = 0x80;
	for (byteno = 0; byteno < 16; ++byteno) {
		/* skip the identical prefix of the ends of the range */
		b = r->hi.s6_addr[byteno] ^ r->lo.s6_addr[byteno];
		if (b == 0) {
			bits += 8;
			if (bits == 128)
				return 128;
			continue;
		}

		/* We have the byte containing the first host bit.
		 * Compute a mask for the host bits in the byte from a netmask
		 * for the byte. */
		while ((m & b) == 0) {
			m = (m >> 1) | 0x80;
			++bits;
		}
		m = ~(m << 1);
		break;
	}

	/* the host bits of the high end of the range must be 1s
	 * and the host bits of the low end must be 0s */
	do {
		if ((r->hi.s6_addr[byteno] & m) != m
		    || (~r->lo.s6_addr[byteno] & m) != m)
			return 0;
		m = 0xff;
	} while (++byteno < 16);

	return bits;
}



u_int
len_ip_range(const DCC_IP_RANGE *range)
{
	u_int len;

	if (range->hi.s6_addr32[0] != range->lo.s6_addr32[0]
	    || range->hi.s6_addr32[1] != range->lo.s6_addr32[1]
	    || range->hi.s6_addr32[2] != range->lo.s6_addr32[2])
		return (u_int)(-1);

	len = ntohl(range->hi.s6_addr32[3]) - ntohl(range->lo.s6_addr32[3]);
	if (len == (u_int)(-1))
		return (u_int)(-1);
	return len+1;
}



void
inc_ip6(struct in6_addr *a)
{
	int byteno;

	/* slow but rarely used */
	for (byteno = 15; byteno >= 0; --byteno) {
		if (++a->s6_addr[byteno] != 0)
			break;
	}
}



/* get an IPv6 address and netmask */
int					/* # of bits, 0=not address, -1 error */
str2cidr(DCC_EMSG *emsg,
	 struct in6_addr *addr6,
	 struct in6_addr *mask6,
	 const char *str)
{
	char addrstr[INET6_ADDRSTRLEN];
	DCC_SOCKU su;
	struct in6_addr mask6_loc;
	const char *bitsp;
	char *p;
	u_int str_len, addr_len, bits_len;
	u_long bits;
	int wordno;

	str = strip_white(str, &str_len);
	bitsp = strchr(str, '/');

	if (!bitsp) {
		addr_len = str_len;
	} else {
		addr_len = bitsp - str;
	}
	if (addr_len == 0 || addr_len >= ISZ(addrstr))
		return 0;		/* not an IP address */
	memcpy(addrstr, str, addr_len);
	addrstr[addr_len] = '\0';
	if (!str2su(&su, addrstr))
		return 0;		/* not an IP address */

	if (!bitsp) {
		if (su.sa.sa_family == AF_INET6) {
			bitsp = "128";
			bits_len = 3;
		} else {
			bitsp = "32";
			bits_len = 2;
		}
		bits = 128;
	} else {
		bits_len = str_len - addr_len - 1;
		bits = strtoul(++bitsp, &p, 10);
		if (su.sa.sa_family == AF_INET)
			bits += 128-32;
		if (p < bitsp+bits_len || bits > 128 || bits < 1) {
			dcc_pemsg(EX_NOHOST, emsg,
				  "invalid CIDR block length \"%.*s\"",
				  str_len, str);
			return -1;
		}
	}

	dcc_su2ipv6(addr6, 1, &su);

	if (!mask6)
		mask6 = &mask6_loc;
	bits2mask(mask6, bits);
	for (wordno = 0; wordno < 4; ++wordno) {
		if ((addr6->s6_addr32[wordno]
		     & ~mask6->s6_addr32[wordno]) != 0) {
			dcc_pemsg(EX_NOHOST, emsg,
				  "%s does not start on a"
				  " %.*s-bit CIDR boundary",
				  addrstr, bits_len, bitsp);
			return -1;
		}
	}

	return bits;
}



/* get an IPv6 address or a range of addresses */
int					/* -1=bad range, 0=possible name, 1=ok */
str2range(DCC_EMSG *emsg,
	  DCC_IP_RANGE *range,
	  u_char *is_ipv6,
	  const char *str,
	  const char *fnm, int lno)
{
	DCC_FNM_LNO_BUF fnm_buf;
	char addrbuf[INET6_ADDRSTRLEN];
	const char *addrp;
	DCC_SOCKU su_lo, su_hi;
	const char *slash_dash;
	const char *bitsp;
	char *p;
	u_int str_len, addr_len, bits_len;
	int n, bits;

	str = strip_white(str, &str_len);
	slash_dash = strpbrk(str, "/-");

	if (!slash_dash) {
		addr_len = str_len;
	} else {
		addr_len = slash_dash - str;
	}
	if (addr_len == 0 || addr_len >= sizeof(addrbuf))
		return 0;		/* not an IP address */
	if (str[addr_len] == '\0') {
		addrp = str;
	} else {
		memcpy(addrbuf, str, addr_len);
		addrbuf[addr_len] = '\0';
		addrp = addrbuf;
	}
	if (!str2su(&su_lo, addrp))
		return 0;		/* not an IP address */

	/* we use IPv6, but often need to know if the original was IPv4 */
	dcc_su2ipv6(&range->lo, 1, &su_lo);
	if (is_ipv6)
		*is_ipv6 = (su_lo.sa.sa_family == AF_INET6);

	if (!slash_dash) {
		/* assume it is a single IP address without '/' or '-' */
		range->hi = range->lo;
		return 1;
	}

	if (*slash_dash == '/') {
		/* assume CIDR block with '/' */
		bits_len = str_len - addr_len - 1;
		n = strtoul(bitsp = slash_dash+1, &p, 10);
		bits = n;
		if (su_lo.sa.sa_family == AF_INET)
			bits += 128-32;
		if (p < bitsp+bits_len || bits > 128 || n == 0) {
			dcc_pemsg(EX_DATAERR, emsg,
				  "invalid CIDR block length \"%.*s\"%s",
				  str_len, str, dcc_fnm_lno(&fnm_buf, fnm, lno));
			return -1;
		}

		if (!cidr2range(range, &range->lo, bits)) {
			dcc_pemsg(EX_DATAERR, emsg,
				  "%s does not start on a"
				  " %.*s-bit CIDR boundary%s",
				  addrp, bits_len, bitsp,
				  dcc_fnm_lno(&fnm_buf, fnm, lno));
			return -1;
		}
		return 1;
	}

	/* try address range with - */
	if (!str2su(&su_hi, slash_dash+1))
		return 0;
	if (su_lo.sa.sa_family != su_hi.sa.sa_family) {
		dcc_pemsg(EX_DATAERR, emsg,
			  "mixture of IPv4 and IPv6 in \"%.*s\"%s",
			  str_len, str, dcc_fnm_lno(&fnm_buf, fnm, lno));
		return -1;
	}
	dcc_su2ipv6(&range->hi, 1, &su_hi);
	if (memcmp(&range->lo, &range->hi, sizeof(range->hi)) > 0) {
		dcc_pemsg(EX_DATAERR, emsg,
			  "first address after second in \"%.*s\"%s",
			  str_len, str, dcc_fnm_lno(&fnm_buf, fnm, lno));
		return -1;
	}
	return 1;
}



const char *
range2str(char *buf, int buf_len, const DCC_IP_RANGE *range)
{
	char lo_buf[INET6_ADDRSTRLEN];
	char hi_buf[INET6_ADDRSTRLEN];
	char cidr_buf[INET6_ADDRSTRLEN];
	struct in_addr addr4;
	int bits;

	/* recognize individual addresses and CIDR blocks */
	bits = range2cidr(range);
	if (bits == 128) {
		dcc_ipv6tostr2(buf, buf_len, &range->lo);
		return buf;
	}

	if (bits > 0) {
		snprintf(buf, buf_len, "%s/%d",
			 dcc_ipv6tostr2(cidr_buf, sizeof(cidr_buf), &range->lo),
			 dcc_ipv6toipv4(&addr4, &range->lo) ? bits-96 : bits);
		return buf;
	}

	if (!memcmp(&range->lo, &range->hi, sizeof(range->lo))) {
		snprintf(buf, buf_len, "%s",
			 dcc_ipv6tostr2(lo_buf, sizeof(lo_buf), &range->lo));
		return buf;
	}

	snprintf(buf, buf_len, "%s-%s",
		 dcc_ipv6tostr2(lo_buf, sizeof(lo_buf), &range->lo),
		 dcc_ipv6tostr2(hi_buf, sizeof(hi_buf), &range->hi));
	return buf;
}
