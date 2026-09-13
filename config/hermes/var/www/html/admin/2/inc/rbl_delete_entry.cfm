
<!---
Hermes Secure Email Gateway - RBL Delete Entry Action Handler
Handles single delete and bulk delete, immediately applies Postfix configuration.
Expects: form.delete_id (single) or form.selected_ids (bulk)
Scopes by parent_name = postscreen_dnsbl_sites; no id lookup needed.
--->

<!--- Single delete --->
<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <cfquery datasource="hermes">
      DELETE FROM parameters
      WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
        AND parent_name = <cfqueryparam value="postscreen_dnsbl_sites" cfsqltype="cf_sql_varchar">
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
            AND parent_name = <cfqueryparam value="postscreen_dnsbl_sites" cfsqltype="cf_sql_varchar">
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
