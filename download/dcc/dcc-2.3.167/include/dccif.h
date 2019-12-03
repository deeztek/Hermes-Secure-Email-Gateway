/* Distributed Checksum Clearinghouse
 *
 * external definitions for DCC interface daemon
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
 * Rhyolite Software DCC 2.3.167-1.31 $Revision$
 */

#ifndef DCCIF_H
#define DCCIF_H

#include "dcc_config.h"
#include "dcc_types.h"
#include "dcc_socket.h"


/* The DCC interface daemon is intended for use with programs that
 * need a more efficient DCC client than dccproc.  The dccif daemon
 * receives messages containing SMTP messages including their envelopes,
 * checks the messages' checksums with a DCC server, and answers
 * with indications of what to do with the mail messages.
 *
 * The protocol used by dccif is simple and easily implemented even
 * in shell scripts.  The protocol uses ASCII strings delimited by '\n'
 * despite their reduced efficiency, because strings are quicker and
 * easier to handle in scripts.  There are Perl and C implementations of the
 * interface that are useful in common situations.
 *
 * The interface daemon is given
 *	optional information including whether the message is spam: */
#define DCCIF_OPT_LOG	    "log"	/* log the transaction */
#define DCCIF_OPT_SPAM	    "spam"	/* message is known to be spam */
#define DCCIF_OPT_BODY	    "body"	/* daemon should return the body */
#define DCCIF_OPT_HEADER    "header"    /* return only the header */
#define DCCIF_OPT_CKSUMS    "cksums"    /* return only the header & checksums */
#define DCCIF_OPT_QUERY	    "query"	/* `dccifd -Q` for this message */
#define	DCCIF_OPT_GREY_OFF  "grey-off"	/* no greylisting for this message */
#define	DCCIF_OPT_GREY_OFF2 "no-grey"	/* no greylisting for this message */
#define DCCIF_OPT_GREY_QUERY "grey-query"   /* `dccifd -Gquery` */
#define DCCIF_OPT_NO_REJECT "no-reject" /* ignore DCC result; greylist only */
#define DCCIF_OPT_RCVD_NXT  "rcvd-nxt"	/* skip to next Received: header */
#define DCCIF_OPT_RCVD_NEXT "rcvd-next"	/*	confused duplicate */
/*
 *	optional IP address as an ASCII string
 *	    optionally followed by '\r' and the name of the
 *	    SMTP client.  The IP address must be present if the name is.
 *	    If neither is present, the IP address is sought in the first
 *	    Received header.
 *	the HELO value without ESMTP options,
 *	the complete sender without ESMTP options,
 *	the complete recipient strings without ESMTP options but with
 *	    optional local user name for per-user logging.  The local user
 *	    name follows a '\r' character after the SMTP Rcpt_To value,
 *	    Only something like an MTA can decide whether user@domain
 *	    example.com, user@example.com, and user@domain.com are the same
 *	    or different mailboxes and so should have one, two, or three
 *	    per-user logs.  Without a local user name, dccifd can do no per-user
 *	    logging or whitelisting.
 *	    With no recipients, dccifd will assume a query is intended.
 *	and the body of the message or text after the DATA command
 *	    up to but not including the period, with any escaping
 *	    of leading periods removed. */

/* The daemon responds with
 *	a line that is the overall result: */
typedef enum {
    DCCIF_RESULT_OK	= 'A',		/* accept for all recipients */
    DCCIF_RESULT_GREY	= 'G',		/* greylist temporary rejection */
    DCCIF_RESULT_REJECT = 'R',		/* reject the message */
    DCCIF_RESULT_SOME   = 'S',		/* no longer used */
    DCCIF_RESULT_TEMP   = 'T'		/* temporary failure by DCC system */
} DCCIF_RESULT_CHAR;
/*
 *	followed by a line of characters indicating which recipients should
 *	    receive the message */
#define DCCIF_RCPT_ACCEPT   'A'
#define DCCIF_RCPT_REJECT   'R'
#define DCCIF_RCPT_GREY	    'G'
/*
 *	followed by the body, usually with an added X-DCC header and any
 *	    spurious copies of the X-DCC header removed.
 *	    MTAs that need a copy of the body must say so with the
 *	    DCCIF_OPT_BODY string among the options in the first line.
 */



/* sample C interface routine */

#define DCC_DCCIF_UDS	    "dccifd"	/* name of UNIX domain socket */

/* Put parameters for the daemon into the dcc_conf file in home directory. */
#define DCC_START_DCCIFD "start-dccifd"  /* script to (re)start daemon */

typedef struct dccif_rcpt {
    struct dccif_rcpt *next;
    const char	    *addr;		/* SMTP Rcpt_To value */
    const char	    *user;		/* local user name */
    unsigned char   ok;			/* 0=do not receive for this one */
} DCCIF_RCPT;				/* chain of target addresses */


extern unsigned char dccif(DCC_EMSG *,	/* put error message here */
	int,				/* -1 or write body to here */
	char **,			/* 0 or pointer to resulting body */
	const char *,			/* string of options */
	const DCC_SOCKU *,		/* SMTP client IPv4 or IPv6 address */
	const char *,			/* optional client name */
	const char *,			/* HELO string */
	const char *,			/* envelope sender or Mail_from value */
	DCCIF_RCPT *,			/* envelope recipients */
	int,				/* -1 or read body from here */
	const char *,			/* incoming body */
	const char *);			/* home directory */

#endif /* DCCIF_H */
