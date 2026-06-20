
<!---
Hermes Secure Email Gateway - RBL Delete Entry Action Handler
Handles single delete and bulk delete, immediately applies Postfix configuration.
Expects: form.delete_id (single) or form.selected_ids (bulk)
Requires: get_rbl_configuration.cfm (provides get_dnsbl_sites_id)
--->

<!--- Single delete --->
<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <cfquery datasource="hermes">
      DELETE FROM parameters
      WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
        AND parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
    </cfquery>
  </cfif>
</cfif>

<!--- Bulk delete --->
<cfif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <cfquery datasource="hermes">
          DELETE FROM parameters
          WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
            AND parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
        </cfquery>
      </cfif>
    </cfloop>
  </cfif>
</cfif>

<!--- Immediately generate and apply Postfix configuration --->
<cftry>
  <cfinclude template="generate_postfix_configuration.cfm">
  <cfset session.m = 2>
  <cfcatch type="any">
    <cfset session.m = 4>
  </cfcatch>
</cftry>
<cflocation url="view_rbl_configuration.cfm" addtoken="no">
