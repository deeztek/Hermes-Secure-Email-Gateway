dnl Milter
dnl	add Milter for DCC Rhyolite Software DCC 2.3.167-1.5 $Revision$
dnl
dnl	For version 8.11 of sendmail, use something like this in a file in
dnl	the sendmail*/devtools/Site directory in a file named site.config.m4,
dnl	site.OS.$SENDMAIL_SUFFIX.m4, or site.OS.m4, as described in
dnl	devtools/Site/README
APPENDDEF(`conf_sendmail_ENVDEF', `-D_FFR_MILTER=1')
APPENDDEF(`conf_libmilter_ENVDEF', `-D_FFR_MILTER=1')
dnl
dnl	For version 8.12 of sendmail, use something like the following:
APPENDDEF(`conf_sendmail_ENVDEF', `-DMILTER')
dnl
dnl	Verion 8.11 and later benefit from
APPENDDEF(`conf_libmilter_ENVDEF', `-DSM_CONF_POLL=1 -DFFR_USE_POLL')
