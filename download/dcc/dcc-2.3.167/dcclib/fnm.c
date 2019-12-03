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
 * Rhyolite Software DCC 2.3.167-1.31 $Revision$
 */

#include "dcc_defs.h"

DCC_PATH dcc_homedir;
int dcc_homedir_len = 2;		/* (ensure comparisons fail) */


#ifndef DCC_WIN32
static void
trimpath(DCC_PATH *path, const char *tmp)
{
	const char *s;
	char c, *t, *p;


	/* trim "//", "/./", "../", "/../", or trailing "/" */
	s = tmp;
	if (s[0] == '.' && s[1] == '/')
		s += 2;
	t = path->c;
	for (;;) {
		c = *s++;
		if (c != '/') {
			*t = c;
			if (c == '\0')
				break;
			++t;
			continue;
		}

		/* check character after '/' */
		c = *s;
		if (c == '/')		/* discard first '/' in "//" */
			continue;
		if (c == '\0'		/* discard trailing '/' */
		    && t != path->c)
			continue;

		if (c != '.') {
			*t++ = '/';
			continue;
		}

		/* we have seen "/." */
		c = *++s;
		if (c == '/')		/* discard "/." in "/./" */
			continue;

		/* trim trailing "/." */
		if (c == '\0')
			continue;

		if (c != '.'
		    || (*(s+1) != '/' && *(s+1) != '\0')) {
			*t++ = '/';
			*t++ = '.';
			continue;
		}

		/* we have "/../" or "/..\0", so remove last name in target */
		*t = '\0';
		p = strrchr(path->c, '/');
		if (p) {
			t = p;
			if (t == path->c)   /* convert "/.." to "/" */
				++t;
		} else {
			t = path->c;
		}
		++s;			/* advance to '\0' or 2nd '/' */
	}

	/* yield something reasonable if a bunch of "/../" or similar resulted
	 * in a null string */
	if (path->c[0] == '\0') {
		path->c[0] = tmp[0] == '/' ? '/' : '.';
		path->c[1] = '\0';
	}
}
#endif



/* Make a home directory relative pathname from a file name
 * and an optional suffix.
 *	An absolute path unrelated to the home directory remains absolute.
 *	The target path can be the input name. */
u_char					/* 0=too long */
dcc_fnm2rel(DCC_PATH *new_path, const char *nm, const char *suffix)
{
#ifdef DCC_WIN32
	return dcc_fnm2abs(new_path, nm, suffix);
#else
	DCC_PATH tmp;
	int i;
	const char *p, *p1;

	/* the answer is the input pathname if it is null */
	if (!nm || *nm == '\0') {
		if (new_path->c != nm)
			new_path->c[0] = '\0';
		return 0;
	}

	if (suffix || new_path->c == nm) {
		p = tmp.c;
		i = snprintf(tmp.c, sizeof(tmp.c), "%s%s",
			     nm, suffix ? suffix : "");
	} else {
		p = nm;
		i = strlen(p);
	}
	if (i >= ISZ(tmp.c)) {
		/* too long */
		if (new_path->c != nm)
			new_path->c[0] = '\0';
		return 0;
	}
	if (p[dcc_homedir_len] == '/'
	    && !strncmp(p, dcc_homedir.c, dcc_homedir_len)) {
		p1 = p + dcc_homedir_len;
		do {
			++p1;
		} while (*p1 == '/');
		if (*p1 != '\0')
			p = p1;
	}

	trimpath(new_path, p);
	return 1;
#endif
}



/* make pathname from an optional suffix and a file name relative to
 *	a path or the home directory
 * path and nm can be the same. */
u_char					/* 0=too long */
dcc_fnm2abs(DCC_PATH *path,		/* put it here */
	    const char *nm, const char *suffix)
{
	DCC_PATH tmp;
	int i;
#ifdef DCC_WIN32
	char *p;
	DWORD lasterror;
#endif

	/* the answer is "" if the input pathname is null */
	if (!nm || *nm == '\0') {
		path->c[0] = '\0';
		return 0;
	}

	if (!suffix)
		suffix = "";

#ifdef DCC_WIN32
	i = snprintf(tmp.c, sizeof(tmp), "%s%s", nm, suffix);
	if (i >= ISZ(tmp)) {
		path->c[0] = '\0';
		return 0;
	}
	lasterror = GetLastError();
	GetFullPathName(tmp.c, sizeof(tmp), path, &p);
	SetLastError(lasterror);
	return 1;
#else
	if (nm[0] == '/' || dcc_homedir.c[0] == '\0') {
		i = snprintf(tmp.c, sizeof(tmp), "%s%s", nm, suffix);
	} else {
		i = snprintf(tmp.c, sizeof(tmp), "%s/%s%s",
			     dcc_homedir.c, nm, suffix);
	}
	trimpath(path, tmp.c);

	if (i >= ISZ(tmp)) {
		/* too long */
		i = strlen(path->c);
		if (i > ISZ(DCC_PATH)-4)
			i = ISZ(DCC_PATH)-4;
		strcpy(&path->c[i], "...");
		return 0;
	}

	return 1;
#endif
}



/* make an absolute pathname from a file name for printing */
const char *
dcc_fnm2abs_msg(DCC_PATH *path, const char *nm)
{
	/* if the path cannot be made absolute without making it too long,
	 * then return the relative (?) name */
	if (dcc_fnm2abs(path, nm, 0))
		return path->c;
	return nm;
}



/* make a relative pathname from a file name that must not be too long */
void
dcc_fnm2rel_good(DCC_PATH *path, const char *nm, const char* suffix)
{
	if (!dcc_fnm2rel(path, nm, suffix))
		dcc_logbad(EX_DATAERR, "\"%s%s\" is too long",
			   nm, suffix ? suffix : "");
}



/* remove initial substring of the home directory */
const char *
dcc_path2fnm(const char *path)
{
	const char *p;

	if (path[dcc_homedir_len] != '/'
	    || strncmp(path, dcc_homedir.c, dcc_homedir_len))
		return path;

	p = path+dcc_homedir_len;
	do {
		++p;
	} while (*p == '/');
	if (*p == '\0')
		return path;
	return p;
}



const char *
dcc_fnm_lno(DCC_FNM_LNO_BUF *buf, const char *fnm, int lno)
{
	DCC_PATH tmp;

	if (!fnm || *fnm == '\0') {
		buf->b[0] = '\0';
	} else {
		dcc_fnm2abs(&tmp, fnm, "");
		snprintf(buf->b, sizeof(buf->b), DCC_FNM_LNO_PAT, lno, tmp.c);
	}
	return buf->b;
}
