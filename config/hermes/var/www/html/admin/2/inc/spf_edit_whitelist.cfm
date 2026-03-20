<!---
Hermes Secure Email Gateway - SPF Edit Whitelist Entry Action Handler
Validates and updates an SPF whitelist entry, then regenerates config and restarts Postfix.
Expects: form.edit_id (integer), form.edit_entry (entry value), form.edit_note (note),
  form.edit_type (entry type: ip/helo/domain/ptr)
--->

<cfset network_cidr = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(3[0-2]|[1-2][0-9]|[0-9]))$">
<cfset ip_cidr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">

<cfif NOT StructKeyExists(form, "edit_id") OR NOT IsValid("integer", form.edit_id)>
  <cfset session.m = 20>
  <cflocation url="view_spf_settings.cfm" addtoken="no">
</cfif>

<cfif NOT StructKeyExists(form, "edit_entry") OR trim(form.edit_entry) is "">
  <cfset session.m = 16>
  <cflocation url="view_spf_settings.cfm" addtoken="no">
</cfif>

<!--- Validate entry format based on type --->
<cfset entryVal = trim(form.edit_entry)>
<cfset entryType = form.edit_type>

<cfif entryType is "ip">
  <cfif NOT (REFind(ip_cidr, entryVal) GT 0 OR REFind(network_cidr, entryVal) GT 0)>
    <cfset session.m = 17>
    <cflocation url="view_spf_settings.cfm" addtoken="no">
  </cfif>
<cfelse>
  <!--- helo/domain/ptr: validate as domain --->
  <cfset tempemail = "bob@" & entryVal>
  <cfif NOT IsValid("email", tempemail)>
    <cfset session.m = 17>
    <cflocation url="view_spf_settings.cfm" addtoken="no">
  </cfif>
</cfif>

<!--- Check for duplicates (exclude current record) --->
<cfquery name="checkExists" datasource="hermes">
  SELECT id FROM spf_bypass
  WHERE entry = <cfqueryparam value="#entryVal#" cfsqltype="cf_sql_varchar">
    AND entry_type = <cfqueryparam value="#entryType#" cfsqltype="cf_sql_varchar">
    AND id <> <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif checkExists.recordcount GTE 1>
  <cfset session.m = 14>
  <cflocation url="view_spf_settings.cfm" addtoken="no">
</cfif>

<!--- Update entry --->
<cfquery datasource="hermes">
  UPDATE spf_bypass
  SET entry = <cfqueryparam value="#entryVal#" cfsqltype="cf_sql_varchar">,
      entry_note = <cfqueryparam value="#trim(form.edit_note)#" cfsqltype="cf_sql_varchar">
  WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset session.m = 15>

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
