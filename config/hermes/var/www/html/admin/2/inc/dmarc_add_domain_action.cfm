<!---
Hermes Secure Email Gateway - DMARC Add Domain(s) Action Handler
Expects: form.domain (textarea, one per line), form.note
--->

<cfif NOT StructKeyExists(form, "domain") OR trim(form.domain) is "">
  <cfset session.m = 13>
  <cflocation url="view_dmarc_settings.cfm" addtoken="no">
</cfif>

<cfinclude template="./dmarc_add_domains.cfm">
<cfinclude template="./dmarc_generate_domains.cfm">
<cfinclude template="./restart_opendmarc.cfm">

<cflocation url="view_dmarc_settings.cfm" addtoken="no">
