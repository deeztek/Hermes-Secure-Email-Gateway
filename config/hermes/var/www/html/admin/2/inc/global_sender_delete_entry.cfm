<!---
Hermes Secure Email Gateway - Global Sender Rules Delete Action Handler
Deletes single or multiple entries, then immediately writes config files and reloads services.
Expects: form.delete_id (single) OR form.selected_ids (comma-delimited, bulk)
--->

<cfset deleted = false>

<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <cfquery datasource="hermes">
      DELETE FROM amavis_sender_bypass
      WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset deleted = true>
  </cfif>
<cfelseif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <cfquery datasource="hermes">
          DELETE FROM amavis_sender_bypass
          WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfset deleted = true>
      </cfif>
    </cfloop>
  </cfif>
</cfif>

<!--- Write config files and reload services --->
<cfif deleted>
  <cfinclude template="./global_sender_write_and_reload.cfm">
  <cfif session.applySuccess>
    <cfset session.m = 2>
  <cfelse>
    <cfset session.m = 4>
  </cfif>
<cfelse>
  <cfset session.m = 2>
</cfif>
<cflocation url="view_global_sender_block_allow.cfm" addtoken="no">
