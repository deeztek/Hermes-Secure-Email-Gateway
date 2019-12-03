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
 * Rhyolite Software DCC 2.3.167-1.51 $Revision$
 */

#include "dcc_clnt.h"


/* get "hostname,port" string from the start of a line */
const char *				/* 0=bad, rest of line if ok */
dcc_parse_nm_port(DCC_EMSG *emsg,
		  const char *line0,
		  u_int def_port,	/* default or DCC_GET_PORT_INVALID */
		  char *hostname,	/* put host name here */
		  u_int hostname_len,
		  in_port_t *portp,	/* put port # in network byte order */
		  char *portname,	/* put port name here */
		  u_int portname_len,
		  const char *fnm, int lno) /* configuration file source */
{
	DCC_FNM_LNO_BUF fnm_buf;
	char buf[DCC_MAXDOMAINLEN+1+MAXPORTNAMELEN+1];	/* "name,#\0" */
	const char *line;
	const char *pstr;
	u_int port;
	u_int hlen;


	/* get both parameters */
	line = dcc_parse_word(emsg, buf, sizeof(buf), line0,
			      "hostname,port", fnm, lno);
	if (!line)
		return 0;

	/* get the hostname and separate the port number */
	pstr = strchr(buf, ',');
	if (!pstr) {
		if (def_port == DCC_GET_PORT_INVALID) {
			dcc_pemsg(EX_USAGE, emsg, "missing port in \"%s\"%s",
				  buf, dcc_fnm_lno(&fnm_buf, fnm, lno));
			return 0;
		}
		hlen = strlen(buf);
		pstr = "-";
	} else {
		hlen = pstr++ - buf;
	}

	if (hostname_len) {
		memset(hostname, 0, hostname_len);
		if (hlen >= hostname_len) {
			dcc_pemsg(EX_NOHOST, emsg,
				  "hostname \"%.16s...\" too long%s",
				  buf, dcc_fnm_lno(&fnm_buf, fnm, lno));
			return 0;
		}
		if (hlen)
			memcpy(hostname, buf, hlen);
	}
	if (portname_len) {
		memset(portname, 0, portname_len);
		STRLCPY(portname, pstr, portname_len);
	}

	/* get the port number */
	port = dcc_get_port(emsg, pstr, def_port, fnm, lno);
	if (port == DCC_GET_PORT_INVALID)
		return 0;

	if (portp)
		*portp = port;
	return line;
}
