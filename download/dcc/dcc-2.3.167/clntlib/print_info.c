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
 * Rhyolite Software DCC 2.3.167-1.69 $Revision$
 */

#include "dcc_clnt.h"
#include "dcc_xhdr.h"


static void
print_srvr(const DCC_SRVR_CLASS *class,
	   const DCC_SRVR_ADDR *ap,
	   u_char print_name,
	   u_char have_rtt_adj)
{
	char srvr_nm[DCC_MAXDOMAINLEN];
	char a1[DCC_SU2STR_SIZE+1+5];
	DCC_SOCKU su;
	int addr_len, name_len, i, j;

	printf("# %1s", class->srvr_inx == ap - class->addrs ? "*" : "");
	if (print_name) {
		dcc_ip2su(&su, &ap->ip);
		dcc_su2name(srvr_nm, sizeof(srvr_nm), &su);
	} else {
		srvr_nm[0] = '\0';
	}
	addr_len = dcc_ap2str_opt(a1, sizeof(a1),
				  class, ap - class->addrs, '-');
	name_len = strlen(srvr_nm);
	i = 22 - (name_len-25);
	if (i < 1)
		i = 1;
	else if (i > 22)
		i = 22;
	j = 25 - (addr_len-22);
	if (j < 1)
		j = 1;
	else if (j > 25)
		j = 25;
	printf("%-*s %-*s", i, a1, j, srvr_nm);
	if (ap->srvr_id != DCC_ID_INVALID) {
		i = 16 - ((addr_len+name_len) - (22+25));
		if (i < 1)
			i = 1;
		else if (i > 16)
			i = 16;
		printf(" %*s ID %d", i, ap->brand, ap->srvr_id);
		if (ap->srvr_pkt_vers != DCC_PKT_VERS)
			printf("\n#     protocol version %d",
			       ap->srvr_pkt_vers);
	}
	putchar('\n');

	if (ap->rtt >= DCC_RTT_BAD) {
		fputs("#      not answering\n", stdout);
		return;
	}
	if (ap->total_xmits == 0) {
		printf("#     %22s", "");
	} else {
		printf("#     %3.0f%% of %2d requests ok",
		       (ap->total_resps*100.0)/ap->total_xmits,
		       ap->total_xmits);
	}
	if (have_rtt_adj) {
		if (ap->srvr_pkt_vers < DCC_PKT_VERS_CLNT_OK
		    && ap->srvr_id != DCC_ID_INVALID) {
			i = printf("%8.2f%+d+%d ms RTT",
				   ap->rtt/1000.0,
				   class->nms[ap->nam_inx].rtt_adj/1000,
				   DCC_RTT_VERS_ADJ/1000);
		} else {
			i = printf("%8.2f%+d ms RTT",
				   ap->rtt/1000.0,
				   class->nms[ap->nam_inx].rtt_adj/1000);
		}
	} else {
		i = printf("%8.2f ms RTT",
			   ap->rtt/1000.0);
	}
	i = (i >= 22) ? 1 : (22-i);
	printf("  %*s  %4d ms queue wait\n",
	       i, "", ap->srvr_wait/1000);
}



void
print_info_src(const DCC_CLNT_INFO *info, const char *label)
{
	char sustr[DCC_SU2STR_SIZE];
	const char *sep;

	sep = "   ";
	if (info->src4.ip.family != AF_UNSPEC) {
		printf("%s%s%s%s",
		       sep, label,
		       dcc_ip2str(sustr, sizeof(sustr), &info->src4.ip),
		       info->src4.failed != 0 ? " "DCC_INFO_TXT_USE_SRCBAD : "");
		sep = ",";
		label = "";
	}
	if (info->src6.ip.family != AF_UNSPEC) {
		printf("%s%s%s%s",
		       sep, label,
		       dcc_ip2str(sustr, sizeof(sustr), &info->src6.ip),
		       info->src6.failed != 0 ? " "DCC_INFO_TXT_USE_SRCBAD : "");
	}
}



/* dump the /var/dcc/map file */
void
print_info(const char *map_nm,		/* or null for temporary file */
	   const DCC_CLNT_INFO *info,
	   u_char quiet,
	   u_char grey,			/* 0=normal 1=grey 2=explict grey */
	   u_char names,
	   u_char show_passwd)
{
#define dcc_clnt_info info
	DCC_PATH path;
	char date_buf[40];
	int port;
	NAM_INX nam_inx;
	const DCC_SRVR_CLASS *class;
	const DCC_SRVR_ADDR *ap,*ap_prev, *ap_next;
	u_char printed_addr[DCC_MAX_SRVR_ADDRS];
	u_char have_rtt_adj;
	u_char need_blank_line;
	int i;

	class = grey ? &info->grey : &info->dcc;
	need_blank_line = 0;
	if (map_nm && !quiet) {
		time_t now;

		now = time(0);
		printf("# %-s  %s%s\n",
		       dcc_time2str(date_buf, sizeof(date_buf), "%x %X %Z",
				    now),
		       grey ? "greylist " : "",
		       dcc_fnm2abs_msg(&path, map_nm));
		fputs("# ", stdout);
		if ((time_t)class->resolve > now || dcc_clnt_debug)
			printf("Re-resolve names after %s  ",
			       dcc_time2str(date_buf, sizeof(date_buf), "%X",
					    class->resolve));
		if ((time_t)class->measure > now || dcc_clnt_debug)
			printf("Check RTTs after %s",
			       dcc_time2str(date_buf, sizeof(date_buf), "%X",
					    class->measure));
		putchar('\n');

		fputs("# ", stdout);
		i = 0;
		for (ap = class->addrs; ap <= LAST(class->addrs); ++ap) {
			if (ap->rtt != DCC_RTT_BAD
			    && ap->ip.family != AF_UNSPEC)
				++i;
		}
		if (i > 1 || dcc_clnt_debug)
			printf("%6.2f ms threshold, %4.2f ms average    ",
			       class->thold_rtt/1000.0,
			       class->avg_thold_rtt/1000.0);
		printf("%d total, %d working servers\n",
		       class->num_srvrs, i);
		if (class->fail_exp != 0) {
			int fail_time = class->fail_time - now;
			if (fail_time > 0
			    && fail_time <= DCC_MAX_FAIL_SECS) {
				printf("# continue not asking %s server"
				       " %d seconds after %d failures\n",
				       DCC_IS_GREY_STR(class),
				       fail_time, class->fail_exp);
			}
		}

		i = now/DCCPROC_COST - info->dccproc_last/DCCPROC_COST;
		if (i > DCCPROC_MAX_CREDITS*2)
			i = DCCPROC_MAX_CREDITS*2;
		else if (i < 0)
			i = 0;
		i += info->dccproc_c;
		if (i > DCCPROC_MAX_CREDITS)
			i = DCCPROC_MAX_CREDITS;
		else if (i < -DCCPROC_MAX_CREDITS)
			i = -DCCPROC_MAX_CREDITS;
		if (grey != 1 && (i < DCCPROC_MAX_CREDITS
				  || !DCC_IS_TIME(now, info->dccproc_dccifd_try,
						  DCCPROC_TRY_DCCIFD))) {
			printf("# %d dccproc balance since %s",
			       i, dcc_time2str(date_buf, sizeof(date_buf), "%X",
					       info->dccproc_last));
			if (!DCC_IS_TIME(now, info->dccproc_dccifd_try,
					 DCCPROC_TRY_DCCIFD))
				printf("; do not try to start dccifd until %s",
				       dcc_time2str(date_buf, sizeof(date_buf),
						    "%X",
						    info->dccproc_dccifd_try));
			putchar('\n');
		}

		need_blank_line = 1;
	}

	/* show IPv4/IPv6 and source only once and not at all unless
	 * not the default in an anonymous file */
	if (!map_nm || (map_nm && grey != 1)) {
		if (info->fgs & DCC_INFO_FG_IPV6_OFF) {
			fputs(DCC_INFO_TXT_IPV6_OFF, stdout);
			need_blank_line = 1;
		} else if (info->fgs & DCC_INFO_FG_IPV4_OFF) {
			fputs(DCC_INFO_TXT_IPV6_ONLY, stdout);
			need_blank_line = 1;
		} else if (map_nm && grey != 1) {
			fputs(DCC_INFO_TXT_IPV6_ON, stdout);
			need_blank_line = 1;
		}
		if (info->fgs & DCC_INFO_FG_SOCKS) {
			fputs("   "DCC_INFO_TXT_USE_SOCKS, stdout);
			need_blank_line = 1;
		}
		if (info->src4.ip.family != AF_UNSPEC
		    || info->src6.ip.family != AF_UNSPEC) {
			print_info_src(info, DCC_INFO_TXT_USE_SRC);
			need_blank_line = 1;
		}
		if (map_nm && grey != 1) {
			printf("   "DCC_INFO_TXT_VERSION"%d\n",
			       DCC_INFO_TXT_VERSION_CUR);
			need_blank_line = 1;
		}
	}

	/* see if any server has an RTT adjustment */
	have_rtt_adj = 0;
	for (nam_inx = 0; nam_inx < DIM(class->nms); ++nam_inx) {
		if (class->nms[nam_inx].hostname[0] == '\0')
			continue;
		if (class->nms[nam_inx].rtt_adj != 0) {
			have_rtt_adj = 1;
			break;
		}
	}
	if (!have_rtt_adj) {
		for (ap = class->addrs; ap<=LAST(class->addrs); ++ap) {
			if (ap->srvr_pkt_vers < DCC_PKT_VERS
			    && ap->srvr_id != DCC_ID_INVALID) {
				have_rtt_adj = 1;
				break;
			}
		}
	}

	memset(printed_addr, 0, sizeof(printed_addr));

	/* convert each non-null hostname */
	for (nam_inx = 0; nam_inx < DIM(class->nms); ++nam_inx) {
		if (class->nms[nam_inx].hostname[0] == '\0')
			continue;

		/* First display the main line for a host */
		if (class->nms[nam_inx].defined == 0)
			need_blank_line = 1;
		if (!need_blank_line && nam_inx != 0) {
			for (ap = class->addrs; ap<=LAST(class->addrs); ++ap) {
				if (ap->nam_inx == nam_inx) {
					need_blank_line = 1;
					break;
				}
			}
		}
		if (need_blank_line) {
			need_blank_line = 0;
			if (!quiet)
				putchar('\n');
		}
		i = printf("%s", class->nms[nam_inx].hostname);
		i = (i >= 26) ? 1 : (26-i);
		port = class->nms[nam_inx].port;
		if (port == DCC_GREY2PORT(grey))
			printf(",%-*s", i, "-   ");
		else
			printf(",%-*d", i, ntohs(port));

		if (grey)
			fputs(" Greylist", stdout);

		if (have_rtt_adj) {
			i = printf(" RTT%+d ms",
				   class->nms[nam_inx].rtt_adj/1000);
			i = (i >= 12) ? 1 : (12-i);
			printf("%*s", i, "");
		}

		/* Suppress the password if it does not exist or is secret */
		if (class->nms[nam_inx].clnt_id == DCC_ID_ANON) {
			fputs(" "DCC_XHDR_ID_ANON"\n", stdout);
		} else {
			printf(" %5d "DCC_PASSWD_PAT"\n",
			       class->nms[nam_inx].clnt_id,
			       show_passwd ? class->nms[nam_inx].passwd : "");
		}

		if (class->nms[nam_inx].defined == 0) {
			need_blank_line = 1;
			fputs("#   undefined name or wrong IP version\n",
			      stdout);
		}

		/* display operating information for each IP address
		 * kludge sort the IP addresses */
		for (ap_prev = 0, i = 0;
		     i < DCC_MAX_SRVR_ADDRS;
		     ap_prev = ap_next, ++i) {
			ap_next = 0;
			for (ap = class->addrs; ap<=LAST(class->addrs); ++ap) {
				if (ap->nam_inx != nam_inx
				    || ap->ip.family == AF_UNSPEC)
					continue;
				/* find smallest IP address not yet printed */
				if (printed_addr[ap - class->addrs])
					continue;
				if (ap_next
				    && ap->ip.family >= ap_next->ip.family
				    && 0 <= memcmp(&ap->ip.u, &ap_next->ip.u,
						   sizeof(ap->ip.u))
				    && ap->ip.port >= ap_next->ip.port)
					continue;
				if (!ap_prev
				    || ap->ip.family >= ap_prev->ip.family
				    || 0 <= memcmp(&ap->ip.u, &ap_prev->ip.u,
						   sizeof(ap->ip.u))
				    || ap->ip.port >= ap_prev->ip.port)
					ap_next = ap;
			}
			if (!ap_next)
				break;
			if (!quiet)
				print_srvr(class, ap_next, names, have_rtt_adj);
			printed_addr[ap_next - class->addrs] = 1;
			need_blank_line = 1;

		}
	}

	for (ap = class->addrs, i = 0; ap <= LAST(class->addrs); ++ap, ++i) {
		if (ap->ip.family == 0)
			continue;
		if (printed_addr[i])
			continue;
		printf("\n# stray address entry #%d, nam_inx %d:\n",
		       i, ap->nam_inx);
		print_srvr(class, ap, names, have_rtt_adj);
	}

#undef dcc_clnt_info
}
