<!---
Hermes Secure Email Gateway - Global Sender Rules Edit Entry Action Handler
Updates the sender and type for an existing entry, then immediately writes config files and reloads services.
Expects: form.edit_id (integer), form.edit_sender (new sender value), form.edit_type (block/allow)
--->

<cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)>
  <!--- Update the transport based on type --->
  <cfset newTransport = "">
  <cfif form.edit_type is "allow">
    <cfset newTransport = "FILTER amavis:[127.0.0.1]:10030">
  </cfif>

  <!--- Auto-prepend @ for bare domains --->
  <cfset editSender = trim(form.edit_sender)>
  <cfset isAtDomain = Left(editSender, 1) is "@">
  <cfset isDotDomain = Left(editSender, 1) is ".">
  <cfset isEmail = NOT isAtDomain AND REFind("[@]", editSender) GT 0>
  <cfif NOT isAtDomain AND NOT isDotDomain AND NOT isEmail AND Len(editSender) GT 0>
    <cfset editSender = "@" & editSender>
  </cfif>

  <cfquery datasource="hermes">
    UPDATE amavis_sender_bypass
    SET sender    = <cfqueryparam value="#editSender#" cfsqltype="cf_sql_varchar">,
        type      = <cfqueryparam value="#form.edit_type#"         cfsqltype="cf_sql_varchar">,
        transport = <cfqueryparam value="#newTransport#"           cfsqltype="cf_sql_varchar">
    WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Write config files and reload services --->
  <cfinclude template="./global_sender_write_and_reload.cfm">
  <cfif session.applySuccess>
    <cfset session.m = 5>
  <cfelse>
    <cfset session.m = 4>
  </cfif>
</cfif>
<cflocation url="view_global_sender_block_allow.cfm" addtoken="no">
