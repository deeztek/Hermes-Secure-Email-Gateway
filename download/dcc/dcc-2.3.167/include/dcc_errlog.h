/* Distributed Checksum Clearinghouse
 *
 * error messages and logging
 *	helps reduce name space pollution for users of dccif()
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
 * Rhyolite Software DCC 2.3.167-1.6 $Revision$
 */

#ifndef DCC_ERRLOG_H
#define DCC_ERRLOG_H


extern u_char dcc_no_syslog;
extern int dcc_error_priority, dcc_trace_priority;
extern u_char dcc_parse_log_opt(const char *);
extern void dcc_syslog_init(u_char, const char *, const char *);
extern DCC_PATH dcc_progname;
extern int dcc_progname_len;
extern void dcc_vfatal_msg(const char *, va_list);
extern int dcc_verror_msg(const char *, va_list);
extern void dcc_error_msg(const char *, ...) DCC_PF(1,2);
extern void dcc_vtrace_msg(const char *, va_list);
extern void dcc_trace_msg(const char *, ...) DCC_PF(1,2);
extern u_char trace_quiet;
extern void quiet_trace_msg(const char *p, ...) DCC_PF(1,2);
#ifndef HAVE_VSYSLOG
#define vsyslog dcc_vsyslog
#endif
extern void dcc_vsyslog(int, const char *, va_list);

extern void dcc_version_print(void);

extern u_char dcc_host_locked;
extern void dcc_host_lock(void);
extern void dcc_host_unlock(void);
extern void dcc_syslog_lock(void);
extern void dcc_syslog_unlock(void);

extern void DCC_NORET dcc_logbad(int, const char *, ...) DCC_PF(2,3);

#define LOGBUF_SIZE	(DCC_MAXDOMAINLEN*2)

extern int emsg_ex_code(const DCC_EMSG *);
extern void dcc_pemsg(u_char, DCC_EMSG *, const char *, ...) DCC_PF(3,4);
extern void dcc_vpemsg(u_char, DCC_EMSG *, const char *, va_list);


#endif /* DCC_ERRLOG_H */
