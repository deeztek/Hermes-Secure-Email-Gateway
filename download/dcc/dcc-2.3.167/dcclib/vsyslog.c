/* compatibility hack for old systems that don't have vsyslog() */

#include "dcc_defs.h"

#include <syslog.h>


/* this is not thread safe */
void
dcc_vsyslog(int pri, const char *fmt, va_list args)
{
    char buf[512];

    vsnprintf(buf, sizeof(buf), fmt, args);
    syslog(pri, "%s", buf);
}
