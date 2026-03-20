<!---
Hermes Secure Email Gateway - SPF Delete Whitelist Entries Action Handler
Deletes selected SPF whitelist entries, then regenerates config and restarts Postfix.
Expects: form.delete_id (comma-delimited list of IDs)
--->

<cfif NOT StructKeyExists(form, "delete_id") OR form.delete_id is "">
  <cfset session.m = 11>
  <cflocation url="view_spf_settings.cfm" addtoken="no">
</cfif>

<cfloop index="i" list="#form.delete_id#" delimiters=",">
  <cfif IsValid("integer", i)>
    <cfset delete_id = i>
    <cfinclude template="./spf_delete_host.cfm">
  </cfif>
</cfloop>

<cfset session.m = 12>

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
