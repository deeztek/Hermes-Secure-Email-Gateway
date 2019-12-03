/* Distributed Checksum Clearinghouse
 *
 * connect to a DCC server for an administrative program
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
 * Rhyolite Software DCC 2.3.167-1.56 $Revision$
 */

#include "dcc_clnt.h"
#include "dcc_heap_debug.h"


static DCC_CLNT_CTXT *ctxt_free;
static int ctxts_active;


/* current DCC server host name
 *	This can give the wrong answer if another thread sneaks in and
 *	switches servers */
const char *
dcc_srvr_nm(u_char grey)
{
	const DCC_SRVR_CLASS *class;
	SRVR_INX srvr_inx;
	const DCC_SRVR_ADDR *cur_addr;
	NAM_INX nam_inx;

	if (!dcc_clnt_info)
		return "???";
	class = grey ? &dcc_clnt_info->dcc : &dcc_clnt_info->grey;
	srvr_inx = class->srvr_inx;
	if (VALID_SRVR(class, srvr_inx)) {
		cur_addr = &class->addrs[srvr_inx];
		nam_inx = cur_addr->nam_inx;
		if (VALID_NAM(nam_inx))
			return class->nms[nam_inx].hostname;
	}
	return grey ? "greylist server" : "DCC server";
}



/* Create a DCC client context
 *	The contexts must be locked */
DCC_CLNT_CTXT *				/* 0=failed */
dcc_alloc_ctxt(void)
{
	DCC_CLNT_CTXT *ctxt;

	assert_ctxts_locked();

	ctxt = ctxt_free;
	if (ctxt) {
		ctxt_free = ctxt->fwd;
	} else {
		ctxt = dcc_malloc(sizeof(*ctxt));
	}
	memset(ctxt, 0, sizeof(*ctxt));
	ctxt->soc[0].s = INVALID_SOCKET;
	ctxt->soc[1].s = INVALID_SOCKET;
	++ctxts_active;

	return ctxt;
}



/* the contexts must be locked */
void
dcc_rel_ctxt(DCC_CLNT_CTXT *ctxt)
{
	assert_ctxts_locked();

	dcc_clnt_socs_close(ctxt);

	ctxt->fwd = ctxt_free;
	ctxt_free = ctxt;

	if (--ctxts_active < 0)
		abort();
}



/* create a temporary an anonymous map file
 *	The contexts must be locked.
 *	On failure, everything is undone.
 *	On success, the file is initialized and mapped. */
u_char					/* 0=failed; 1=mapped & locked */
dcc_map_tmp_info(DCC_EMSG *emsg,	/* cleared of stale messages */
		 const DCC_SRVR_NM *nm,
		 const DCC_IP *src4, const DCC_IP *src6,
		 DCC_INFO_FGS info_fgs)	/* DCC_INFO_FG_* */
{
	DCC_PATH tmp_info_nm;
	int fd;

	assert_ctxts_locked();

	fd = dcc_mkstemp(emsg, &tmp_info_nm, 0, 0, 0, 0, "map", 1, 0);
	if (fd < 0)
		return 0;

	if (!dcc_create_map(emsg, tmp_info_nm.c, &fd, nm, 1, nm, 1,
			    src4, src6, info_fgs | DCC_INFO_FG_TMP))
		return 0;

	return dcc_map_info(emsg, tmp_info_nm.c, fd);
}



/* start to get ready for an operation
 *	on entry, nothing is locked,
 *	on success, the contexts and info are locked
 *	on failure, nothing is locked */
DCC_CLNT_CTXT *				/* 0=failed */
dcc_clnt_start(DCC_EMSG *emsg, DCC_CLNT_CTXT *ctxt,
	       const char *new_info_map_nm,
	       DCC_CLNT_FGS clnt_fgs)
{
	dcc_ctxts_lock();

	if (!ctxt)
		ctxt = dcc_alloc_ctxt();

	if (emsg)
		emsg->c[0] = '\0';
	if (!dcc_map_info(emsg, new_info_map_nm, -1)) {
		dcc_rel_ctxt(ctxt);
		dcc_ctxts_unlock();
		return 0;
	}

	if (!dcc_clnt_rdy(emsg, ctxt, clnt_fgs)) {
		if (!(clnt_fgs & DCC_CLNT_FG_BAD_SRVR_OK)) {
			dcc_unmap_close_info(0);
			dcc_rel_ctxt(ctxt);
			dcc_ctxts_unlock();
			return 0;
		}
		if (emsg && dcc_clnt_debug)
			dcc_trace_msg("%s", emsg->c);

		/* try to lock the shared information since we are not
		 * admitting that dcc_clnt_rdy() failed */
		if (!dcc_info_lock(emsg)) {
			dcc_rel_ctxt(ctxt);
			dcc_ctxts_unlock();
			return 0;
		}
	}

	return ctxt;
}



/* release both locks */
DCC_CLNT_CTXT *				/* 0=failed */
dcc_clnt_start_fin(DCC_EMSG *emsg,	/* cleared of stale messages */
		   DCC_CLNT_CTXT *ctxt)
{
	if (!dcc_info_unlock(emsg)) {
		dcc_unmap_close_info(0);
		dcc_rel_ctxt(ctxt);
		dcc_ctxts_unlock();
		return 0;
	}
	dcc_ctxts_unlock();
	return ctxt;
}



/* on entry, nothing is locked
 * on success the info file is mapped, but nothing is locked
 * on failure, nothing is mapped or locked */
DCC_CLNT_CTXT *				/* 0=failed */
dcc_clnt_init(DCC_EMSG *emsg, DCC_CLNT_CTXT *ctxt,
	      const char *new_info_map_nm,
	      DCC_CLNT_FGS clnt_fgs)
{
	ctxt = dcc_clnt_start(emsg, ctxt, new_info_map_nm, clnt_fgs);
	if (ctxt)
		ctxt = dcc_clnt_start_fin(emsg, ctxt);
	return ctxt;
}



/* start talking to a DCC server using an temporary parameter file
 *	on entry nothing is locked
 *	on success the info file is mapped, but nothing is locked
 *	on failure, nothing is mapped or locked */
DCC_CLNT_CTXT *				/* 0=failed, 1=ready */
dcc_tmp_clnt_init(DCC_EMSG *emsg, DCC_CLNT_CTXT *ctxt,
		  const DCC_SRVR_NM *new_srvr,
		  const DCC_IP *src4,
		  const DCC_IP *src6,
		  DCC_CLNT_FGS clnt_fgs,
		  DCC_INFO_FGS info_fgs)    /* DCC_INFO_FG_* */
{
	if (emsg)
		emsg->c[0] = '\0';

	dcc_ctxts_lock();
	if (!dcc_map_tmp_info(emsg, new_srvr, src4, src6, info_fgs)) {
		if (ctxt)
			dcc_rel_ctxt(ctxt);
		dcc_ctxts_unlock();
		return 0;
	}
	dcc_ctxts_unlock();

	ctxt = dcc_clnt_init(emsg, ctxt, 0, clnt_fgs | DCC_CLNT_FG_NO_FAIL);
	if (!ctxt) {
		dcc_ctxts_lock();
		dcc_unmap_close_info(0);
		dcc_ctxts_unlock();
	}
	return ctxt;
}
