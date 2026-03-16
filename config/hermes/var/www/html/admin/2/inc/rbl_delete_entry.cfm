
<!---
Hermes Secure Email Gateway - RBL Delete Entry Action Handler
Handles single delete and bulk delete (marks entries for deletion).
Expects: form.delete_id (single) or form.selected_ids (bulk)
Requires: get_rbl_configuration.cfm (provides get_dnsbl_sites_id)
--->

<!--- Single delete --->
<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <cfquery datasource="hermes">
      UPDATE parameters SET action = 'delete', applied = '2'
      WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
        AND parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.m = 2>
  </cfif>
  <cflocation url="view_rbl_configuration.cfm" addtoken="no">
</cfif>

<!--- Bulk delete --->
<cfif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <cfquery datasource="hermes">
          UPDATE parameters SET action = 'delete', applied = '2'
          WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
            AND parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
        </cfquery>
      </cfif>
    </cfloop>
    <cfset session.m = 2>
  </cfif>
  <cflocation url="view_rbl_configuration.cfm" addtoken="no">
</cfif>
