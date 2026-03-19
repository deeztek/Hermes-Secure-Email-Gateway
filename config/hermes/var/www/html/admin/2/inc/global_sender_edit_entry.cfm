<!---
Hermes Secure Email Gateway - Global Sender Block/Allow Edit Entry Action Handler
Updates the sender and type for an existing amavis_sender_bypass entry and stages it for apply.
Expects: form.edit_id (integer), form.edit_sender (new sender value), form.edit_type (block/allow)
--->

<cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)>
  <cfquery datasource="hermes">
    UPDATE amavis_sender_bypass
    SET sender  = <cfqueryparam value="#trim(form.edit_sender)#" cfsqltype="cf_sql_varchar">,
        type    = <cfqueryparam value="#form.edit_type#"         cfsqltype="cf_sql_varchar">,
        action  = 'add',
        applied = '2'
    WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfset session.m = 5>
</cfif>
<cflocation url="view_global_sender_block_allow.cfm" addtoken="no">
