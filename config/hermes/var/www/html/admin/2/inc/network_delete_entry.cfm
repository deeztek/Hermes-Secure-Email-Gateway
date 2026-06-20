
<!---
Hermes Secure Email Gateway - Network Block/Allow Delete Entry Action Handler
Deletes single or bulk entries immediately and regenerates Postfix configuration.
Expects: form.delete_id (single) or form.selected_ids (bulk)
--->

<!--- Single delete --->
<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <cfquery datasource="hermes">
      DELETE FROM postscreen_access
      WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cftry>
      <cfinclude template="generate_postscreen_access.cfm">
      <cfset session.m = 2>
      <cfcatch type="any">
        <cfset session.m = 4>
      </cfcatch>
    </cftry>
  </cfif>
  <cflocation url="view_network_block_allow.cfm" addtoken="no">
</cfif>

<!--- Bulk delete --->
<cfif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <cfquery datasource="hermes">
          DELETE FROM postscreen_access
          WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
      </cfif>
    </cfloop>
    <cftry>
      <cfinclude template="generate_postscreen_access.cfm">
      <cfset session.m = 2>
      <cfcatch type="any">
        <cfset session.m = 4>
      </cfcatch>
    </cftry>
  </cfif>
  <cflocation url="view_network_block_allow.cfm" addtoken="no">
</cfif>
