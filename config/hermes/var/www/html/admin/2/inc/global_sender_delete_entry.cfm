<!---
Hermes Secure Email Gateway - Global Sender Block/Allow Delete Action Handler
Handles both single delete and bulk delete by staging entries for deletion (applied='2', action='delete').
Expects: form.delete_id (single) OR form.selected_ids (comma-delimited, bulk)
--->

<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <cfquery datasource="hermes">
      UPDATE amavis_sender_bypass SET action = 'delete', applied = '2'
      WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.m = 2>
  </cfif>
<cfelseif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <cfquery datasource="hermes">
          UPDATE amavis_sender_bypass SET action = 'delete', applied = '2'
          WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
      </cfif>
    </cfloop>
    <cfset session.m = 2>
  </cfif>
</cfif>
<cflocation url="view_global_sender_block_allow.cfm" addtoken="no">
