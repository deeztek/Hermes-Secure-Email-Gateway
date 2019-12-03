/* Distributed Checksum Clearinghouse
 *
 * routines to make WIN32 look sort of reasonable
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
 * Rhyolite Software DCC 2.3.167-1.26 $Revision$
 */


#include "dcc_defs.h"

#ifdef DCC_WIN32

static DCC_PATH path_tmp;
const char *_PATH_TMP = path_tmp;

static u_char is_nt;


void
dcc_win32_init(void)
{
	OSVERSIONINFO ver;
	WSADATA WSAData;

	ver.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
	GetVersionEx(&ver);
	is_nt = (ver.dwPlatformId == VER_PLATFORM_WIN32_NT);

	if (WSAStartup(MAKEWORD(2, 0), &WSAData))
		dcc_logbad(EX_SOFTWARE, "WSAStartup(): %s", ERROR_STR());

	atexit((void(*)(void))WSACleanup);

	GetTempPath(sizeof(path_tmp), path_tmp);

#ifdef __BORLANDC__
	_fmode = O_BINARY;
#endif
}



int
dcc_gettimeofday(struct timeval *tv, struct timezone *tzp)
{
	static SYSTEMTIME epoch_st = {1970, 1, 0, 1, 0, 0, 0, 0};
	static LONGLONG epoch;		/* the first second of the UNIX epoch */
	LONGLONG now;

	if (epoch == 0)
		SystemTimeToFileTime(&epoch_st, (FILETIME *)&epoch);
	GetSystemTimeAsFileTime((FILETIME *)&now);
	now -= epoch;
	now /= 10;
	tv->tv_sec = now/(1000*1000);
	tv->tv_usec = now%(1000*1000);
	return 0;
}



void
dcc_win32_unmap(HANDLE *hp, void *p, const char *nm)
{
	if (!UnmapViewOfFile(p))
		dcc_error_msg("UnmapViewOfFile(%s): %s", nm, ERROR_STR());
	if (!CloseHandle(*hp))
		dcc_error_msg("CloseHandle(%s): %s", nm, ERROR_STR());
	*hp = INVALID_HANDLE_VALUE;
}



void *
dcc_win32_map(DCC_EMSG emsg,
	      HANDLE *map_handle,	/* put handle for the map here */
	      const char *nm,		/* for this resolved path name */
	      int fd,			/* with this C style file descriptor */
	      int size)			/* with this size (to extend file) */
{
	static char junk;		/* foil optimizer */
	DCC_PATH map_nm;
	HANDLE h;
	void *p;
	int i;

	/* make a name for the mapping */
	if (!dcc_fnm2abs(map_nm, nm, 0))
		STRLCPY(map_nm, nm, sizeof(DCC_PATH));
	for (i = 0; i < sizeof(DCC_PATH) && map_nm[i] != '\0'; ++i) {
		if (map_nm[i] == '/' || map_nm[i] == '\\')
			map_nm[i] = '-';
	}

	h = CreateFileMapping((HANDLE)_get_osfhandle(fd),
			      0, PAGE_READWRITE, 0, size, map_nm);
	if (!h) {
		dcc_pemsg(EX_IOERR, emsg, "CreateFileMapping(%s): %s",
			  nm, ERROR_STR());
		*map_handle = INVALID_HANDLE_VALUE;
		return 0;
	}
	p = MapViewOfFile(h, FILE_MAP_ALL_ACCESS, 0,0, size);
	if (!p) {
		dcc_pemsg(EX_IOERR, emsg, "MapViewOfFile(%s): %s",
			  nm, ERROR_STR());
		CloseHandle(h);
		*map_handle = INVALID_HANDLE_VALUE;
		return 0;
	}

	/* If you immediately lock the file, the mapping is garbage on Win98.
	 * It seems to help to poke at the mapping.
	 * One theory is that a page fault on a locked file fails */
	for (i = 0; i < size; i += 512)
		junk += ((char *)p)[i];

	*map_handle = h;
	return p;
}



/* get an exclusive lock on a file */
u_char
dcc_win32_lock(HANDLE h, DWORD flags)
{
	OVERLAPPED olap;
	int e;

	if (is_nt) {
		memset(&olap, 0, sizeof(olap));
		return LockFileEx(h, flags, 0, 1,0, &olap);
	}

	/* this is ugly, but so is Win95 */
	for (;;) {
		if (LockFile(h, 0,0, 1,0))
			return 1;
		e = GetLastError();
		if (e != ERROR_LOCKED
		    && e != ERROR_LOCK_VIOLATION
		    && e != ERROR_SHARING_VIOLATION)
			return 0;
		Sleep(100);
	}
}



u_char
dcc_win32_unlock(HANDLE h)
{
	return UnlockFile(h, 0,0, 1,0);
}



/* not all WIN32 systems have snprintf
 *	At least some versions of FormatMessage() do not understand %f
 *	There should be no unsafe sprintf's, so worry only a little */
int
dcc_vsnprintf(char *tgt, int tgt_len, const char *pat, va_list args)
{
	char buf[32*1024];
	int len;

	len = vsprintf(buf, pat, args);
	STRLCPY(tgt, buf, tgt_len);
	return len;
}



int
dcc_snprintf(char *buf, int buf_len, const char *pat, ...)
{
	int len;
	va_list args;

	va_start(args, pat);
	len = dcc_vsnprintf(buf, buf_len, pat, args);
	va_end(args);
	return len;
}



/* in NT, this should probably have something to do with the event log */

char syslog_prefix[64];

#pragma argsused
void
dcc_openlog(const char *ident, int logopt, int facility)
{
	BUFCPY(syslog_prefix, ident);
}



#pragma argsused
void
dcc_vsyslog(int priority, const char *msg, va_list args)
{
	struct tm tm;
	char *bp, buf[sizeof(syslog_prefix)+256];

	if (dcc_no_syslog)
		return;

	strcpy(buf, syslog_prefix);
	bp = buf+strlen(buf);
	dcc_localtime(time(0), &tm);
	bp += strftime(bp, &buf[sizeof(buf)-3]-bp, " %D %H:%M:%S ", &tm);
	if (bp >= &buf[sizeof(buf)-3])
		bp = &buf[sizeof(buf)-3];

	bp += vsnprintf(bp, &buf[sizeof(buf)-3]-bp, msg, args);
	if (bp >= &buf[sizeof(buf)-3])
		bp = &buf[sizeof(buf)-3];
	strcpy(bp, "\r\n");

	puts(buf);
}



void
dcc_syslog(int priority, const char *msg, ...)
{
	va_list args;

	va_start(args, msg);
	dcc_vsyslog(priority, msg, args);
	va_end(args);
}



void
dcc_closelog(void)
{
	fflush(stdout);
	fflush(stderr);
}


/* Strip any CR or LF and convert the strange, non-ASCII
 *	garbage from Microsoft messages
 * Trim the trailing blanks and '.' from Borland messages */
static void
ws_strip(const char *begin, char *tgt, char *end)
{
	const char *src;
	char c;

	src = begin;
	do {
		if (tgt >= end) {
			*tgt++ = '\0';
			break;
		}
		c = *src++;
		if (c == '\r')		/* skip carriage return */
			continue;
		if (c == '\n')
			c = ' ';
		if ((c < ' ' && c != '\0') || c > 0x7e)
			c = '?';
		*tgt++ = c;
	} while (c != '\0');

	/* trim trailing whitespace */
	--tgt;
	while (--tgt >= begin
	       && ((c = *tgt) == ' ' || c == '\t' || c == '.')) {
		*tgt = '\0';
	}
}



/* complete the lame strerror() from Borland for WIN95 */
const char *
ws_strerror(int eno)
{
	static struct {
	    char    s[256];
	} ebufs[8];
	static int ebuf_num;
	int bn;
	const char *src;
	char *begin;

	/* Borland fopen() and who knows what else does not set
	 * the WIN32 GetLastError() value */
#ifdef __BORLANDC__
	/* sometimes the Borland wrapper for errno works better */
	if (eno == 0)
		eno = *__errno();
#endif
	if (eno == 0)
		return "unknown error";

	/* Use an array of static buffers to kludge around problems with
	 * threads */
	bn = ebuf_num;
	ebuf_num = (bn+1) % DIM(ebufs);
	begin = ebufs[bn].s;

	/* Use the Microsoft message if it is not silly. */
	if (FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,
			  0, eno, 0, begin, sizeof(ebufs[bn].s), 0)) {

		/* strip any CR or LF and convert the strange, non-ASCII
		 * garbage from Microsoft messages */
		ws_strip(begin, begin, begin+sizeof(ebufs[bn].s)-1);
		if (strlen(begin) < 128)
			return begin;
	}

	/* If Microsoft fails, try the Borland messages,
	 * and use anything other than "unknown error" */
	src = strerror(eno);
	if (strcmp(src, "Unknown error\n")) {
		ws_strip(src, begin, begin+sizeof(ebufs[bn].s)-1);
		return begin;
	}

	/* MicroSoft has only some of the BSD standard error messages */
	switch (eno) {
	case WSAEACCES:		return "SO_BROADCAST not enabled";
	case WSAEADDRINUSE:	return "address already in use";
	case WSAEADDRNOTAVAIL:	return "address not available";
	case WSAEAFNOSUPPORT:	return "Address family not supported";
	case WSAEALREADY:	return "nonblocking connect in progress";
	case WSAEBADF:		return "Bad file descriptor";
	case WSAECONNABORTED:	return "Software caused connection abort";
	case WSAECONNREFUSED:	return "Connection refused";
	case WSAECONNRESET:	return "Connection reset by peer";
	case WSAEDESTADDRREQ:	return "Destination address required";
	case WSAEDQUOT:		return "Disc quota exceeded";
	case WSAEFAULT:		return "WS bad address";
	case WSAEHOSTDOWN:	return "Host is down";
	case WSAEHOSTUNREACH:	return "No route to host";
	case WSAEINPROGRESS:	return "winsock 1.1 call in progress";
	case WSAEINTR:		return "cancelled by WSACancelBlockingCall";
	case WSAEINVAL:		return "WS invalid argument";
	case WSAEISCONN:	return "Socket is already connected";
	case WSAELOOP:		return "Too many levels of symbolic links";
	case WSAEMFILE:		return "Too many open files";
	case WSAEMSGSIZE:	return "Message too long";
	case WSAENAMETOOLONG:	return "File name too long";
	case WSAENETDOWN:	return "network is down";
	case WSAENETRESET:	return "Network dropped connection on reset";
	case WSAENETUNREACH:	return "network is unreachable";
	case WSAENOBUFS:	return "No buffer space available";
	case WSAENOPROTOOPT:	return "Protocol not available";
	case WSAENOTCONN:	return "Socket is not connected";
	case WSAENOTEMPTY:	return "Directory not empty";
	case WSAENOTSOCK:	return "socket operation on non-socket";
	case WSAEOPNOTSUPP:	return "Operation not supported";
	case WSAEPFNOSUPPORT:	return "Protocol family not supported";
	case WSAEPROCLIM:	return "Too many processes";
	case WSAEPROTONOSUPPORT:return "Protocol not supported";
	case WSAEPROTOTYPE:	return "Protocol wrong type for socket";
	case WSAEREMOTE:	return "Too many levels of remote in path";
	case WSAESHUTDOWN:	return "Can't send after socket shutdown";
	case WSAESOCKTNOSUPPORT:return "Socket type not supported";
	case WSAESTALE:		return "Stale NFS file handle";
	case WSAETIMEDOUT:	return "Operation timed out";
	case WSAETOOMANYREFS:	return "Too many references: can't splice";
	case WSAEUSERS:		return "Too many users";
	case WSAEWOULDBLOCK:	return "Operation would block";
	case WSANOTINITIALISED:	return "WSAStartup not done";
	case WSAHOST_NOT_FOUND:	return "Unknown host";
	case WSATRY_AGAIN:	return "Host name lookup failure";
	case WSANO_RECOVERY:	return "Unknown server error";
	case WSANO_DATA:	return "No address associated with name";
	}

	/* fall back on Borland's "unkonwn error", but admit the error # */
	snprintf(begin, sizeof(ebufs[bn].s), "Unknown error %d", eno);
	return begin;
}
#endif /* !DCC_WIN32 */
