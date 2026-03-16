
<!---
Hermes Secure Email Gateway - RBL Edit Entry Action Handler
Updates an existing RBL entry's hostname and weight.
Expects: form.edit_id, form.edit_host, form.edit_weight
Requires: get_rbl_configuration.cfm (provides get_dnsbl_sites_id)
--->

<cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)
  AND StructKeyExists(form, "edit_host") AND trim(form.edit_host) is not "">

  <cfset editHost = trim(form.edit_host)>
  <cfset editWeight = 1>
  <cfif StructKeyExists(form, "edit_weight") AND IsNumeric(form.edit_weight)>
    <cfset editWeight = Int(form.edit_weight)>
  </cfif>

  <!--- Determine parameter value based on weight sign --->
  <cfif editWeight LT 0>
    <cfset editParam = editHost>
  <cfelse>
    <cfset editParam = editHost & "*" & Abs(editWeight)>
  </cfif>

  <cfquery datasource="hermes">
    UPDATE parameters
    SET parameter = <cfqueryparam value="#editParam#" cfsqltype="cf_sql_varchar">,
        weight = <cfqueryparam value="#editWeight#" cfsqltype="cf_sql_integer">,
        action = 'APPLY', applied = '2'
    WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
      AND parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfset session.m = 5>
</cfif>
<cflocation url="view_rbl_configuration.cfm" addtoken="no">
