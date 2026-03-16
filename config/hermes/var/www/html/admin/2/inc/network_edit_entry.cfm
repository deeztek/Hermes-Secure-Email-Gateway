
<!---
Hermes Secure Email Gateway - Network Block/Allow Edit Entry Action Handler
Updates an existing network entry's sender, action, and note.
Expects: form.edit_id, form.edit_sender, form.edit_action, form.edit_note
--->

<cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)>
  <cfquery datasource="hermes">
    UPDATE postscreen_access
    SET sender = <cfqueryparam value="#trim(form.edit_sender)#" cfsqltype="cf_sql_varchar">,
        action = <cfqueryparam value="#form.edit_action#" cfsqltype="cf_sql_varchar">,
        note = <cfqueryparam value="#trim(form.edit_note)#" cfsqltype="cf_sql_varchar">,
        action2 = 'APPLY', applied = '2'
    WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfset session.m = 5>
</cfif>
<cflocation url="view_network_block_allow.cfm" addtoken="no">
