<!---
Hermes Secure Email Gateway - SPF Add Whitelist Entries Action Handler
Validates and inserts SPF whitelist entries, then regenerates config and restarts Postfix.
Expects: form.entry_type (ip/helo/domain/ptr), form.host (newline-delimited), form.note
--->

<!--- Validate entry_type --->
<cfset validTypes = "ip,helo,domain,ptr">
<cfif NOT StructKeyExists(form, "entry_type") OR NOT ListFindNoCase(validTypes, form.entry_type)>
  <cfset session.m = 20>
  <cflocation url="view_spf_settings.cfm" addtoken="no">
</cfif>

<!--- Validate host field not empty --->
<cfif NOT StructKeyExists(form, "host") OR trim(form.host) is "">
  <cfset session.m = 13>
  <cflocation url="view_spf_settings.cfm" addtoken="no">
</cfif>

<!--- Process entries --->
<cfinclude template="./spf_add_hosts.cfm">

<!--- Regenerate config and restart --->
<cfinclude template="./get_spf_settings.cfm">
<cfset form.debuglevel = get_debugLevel.value2>
<cfset form.testonly = get_testonly.value2>
<cfset form.helo_reject = get_helo_reject.value2>
<cfset form.mail_from_reject = get_mail_from_reject.value2>
<cfset form.permerror_reject = get_permerror_reject.value2>
<cfset form.temperror_defer = get_temperror_defer.value2>

<cfinclude template="./spf_generate_config_file.cfm">
<cfinclude template="./restart_postfix.cfm">

<cflocation url="view_spf_settings.cfm" addtoken="no">
