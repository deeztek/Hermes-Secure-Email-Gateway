divert(-1)

############################################################################
# NOTICE:  Unless your version of sendmail is ancient, use the standard
#   sendmail `FEATURE(dnsbl)' or `FEATURE(enhdnsbl)' and the hackmc script 
#   in the DCC source instead of this sendmail `FEATURE' file.
############################################################################


# Connect a DNS blacklist such as the RBL+ to the local DCCM daemon and so to
# a DCC server to report spam to the DCC database.
# The connection is by the sendmail "dcc_isspam" macro
#
# The first and required argument is the domain name of the DNS blacklist
# The second, optional argument is a log and SMTP status/rejection message.
#
# For example, with the following, mail from SMTP clients on the
#   relays.mail-abuse.org list would be rejected as well as reported as
#   extremely bulky to the DCC server:
# `FEATURE(dccdnsbl, `zen.spamhaus.org', `"Mail from " $`'&{client_addr} " reject to DCC - see http://www.spamhaus.org/zen/"')'
#
#   (Of course, the outer pair of `' quotes must be removed)
#
#   The `FEATURE(dccdnsbl)' line should be after the `FEATURE(dcc)' line
#   if the latter is present.
#
# If you see error messages from sendmail like "map macro not found", check
#   for the Kmacro definition in cf/m4/proto.m4 and consider the "dnl" comments
#   below.

divert(0)
VERSIONID(`dccdnsbl.m4 Rhyolite Software DCC 2.3.167-1.18 $Revision$')
divert(-1)

define(`_DCCDNSBL_SRV_', ifelse(len(X`'_ARG_),`1',`blackholes.mail-abuse.org',`_ARG_'))
define(`_DCCDNSBL_MSG_', ifelse(len(X`'_ARG2_),`1',`"Mail from " $`'&{client_addr} " refused by blackhole site '_DCCDNSBL_SRV_`"',`_ARG2_'))

dnl Remove the "dnl " strings (including the blanks) from the following 5 lines
dnl	up to the divert(8) line if your version of sendmail does not include
dnl	the Kmacro line by default.
dnl ifdef(`_DCCDNSBL_DEF_',`dnl',`dnl
dnl define(_DCCDNSBL_DEF_, 1)dnl
dnl LOCAL_CONFIG
dnl `# define macros map to communicate DNS black list results to DCC via dccm'
dnl Kmacro macro')
divert(8)
# DNS based IP address spam list _DCCDNSBL_SRV_ connected to DCCM
R$*			$: $&{client_addr}
R$-.$-.$-.$-		$: <?> $(host $4.$3.$2.$1._DCCDNSBL_SRV_. $: OK $)
R<?>OK			$: OKSOFAR
R<?>$+<TMP>		$: TMPOK
R<?>$+			$@ $(macro {dcc_isspam} $@ _DCCDNSBL_MSG_ $) TODCC
divert(-1)

ifdef(`_DCC_DEF_',`',`FEATURE(`dcc')')dnl
