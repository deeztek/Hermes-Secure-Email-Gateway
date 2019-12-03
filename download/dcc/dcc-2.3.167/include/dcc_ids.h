/* Distributed Checksum Clearinghouse
 *
 * server-IDs
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
 * Rhyolite Software DCC 2.3.167-1.37 $Revision$
 */

#ifndef DCC_IDS_H
#define DCC_IDS_H

/* IDs file used by server, server utilities, and cdcc */
extern DCC_PATH ids_path;
extern time_t ids_mtime;
#define IDS_NM_DEF  "ids"


/* authenticated client database */
typedef u_char ID_TBL_FLGS;
typedef struct id_tbl {
    struct id_tbl *hfwd, *hbak;
    DCC_CLNT_ID	id;
    u_int32_t	delay_us;
    /* fix dccd man page if this changes */
#    define	 DCC_ANON_DELAY_US_DEF	(50*1000)
#    define	 DCC_ANON_DELAY_US_BLACKLIST DCC_ANON_DELAY_MAX
    u_int32_t	delay_inflate;
#    define	 DCC_ANON_INFLATE_OFF	((u_int)(-1))
    ID_TBL_FLGS	flags;
#    define	 ID_FLG_RPT_OK		0x01    /* override dccd -Q */
#    define	 ID_FLG_NO_REPS		0x02
#    define	 ID_FLG_TRACE		0x04
#    define	 ID_FLG_DELAY_SET	0x08
    u_char	srvr_type;		/* DCC_ID_SRVR_* */
    DCC_PASSWD	cur_passwd;
    DCC_PASSWD	next_passwd;
} ID_TBL;

extern u_char parse_dccd_delay(DCC_EMSG *, u_int32_t *, u_int *,
			       const char *, const char *, int);
extern ID_TBL *find_id_tbl(DCC_CLNT_ID, u_char);
extern ID_TBL *add_id_tbl(DCC_CLNT_ID, ID_TBL ***, u_char);
extern ID_TBL *enum_ids(ID_TBL *);
extern u_char set_ids_path(DCC_EMSG *, const char *);
extern int load_ids(DCC_EMSG *, DCC_CLNT_ID, const ID_TBL **, u_char, u_char);

#endif /* DCC_IDS_H */
