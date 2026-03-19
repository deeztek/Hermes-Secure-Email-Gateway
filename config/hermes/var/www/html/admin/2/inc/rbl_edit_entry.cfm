
<!---
Hermes Secure Email Gateway - RBL Edit Entry Action Handler
Updates an existing RBL entry's hostname and weight.
Expects: form.edit_id, form.edit_host, form.edit_weight (positive integer), form.edit_type (block/allow)
Requires: get_rbl_configuration.cfm (provides get_dnsbl_sites_id)
--->

<cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)
  AND StructKeyExists(form, "edit_host") AND trim(form.edit_host) is not "">

  <cfset editHost = trim(form.edit_host)>
  <cfset editWeight = 1>
  <cfif StructKeyExists(form, "edit_weight") AND IsNumeric(form.edit_weight)>
    <cfset editWeight = Abs(Int(form.edit_weight))>
  </cfif>
  <cfset editType = "block">
  <cfif StructKeyExists(form, "edit_type")><cfset editType = form.edit_type></cfif>

  <!--- Validate hostname portion only (strip optional Postfix return-code filter: hostname=127.x.x.x) --->
  <cfset eqPos = Find("=", editHost)>
  <cfset hostPart = (eqPos GT 0) ? Left(editHost, eqPos - 1) : editHost>
  <cfif NOT IsValid("email", "test@" & hostPart)>
    <cfset session.m = 11>
    <cflocation url="view_rbl_configuration.cfm" addtoken="no">
  </cfif>

  <!--- Derive signed weight and parameter value from type --->
  <cfif editType is "allow">
    <cfset actualWeight = -editWeight>
    <cfset editParam = editHost>
  <cfelse>
    <cfset actualWeight = editWeight>
    <cfset editParam = editHost & "*" & editWeight>
  </cfif>

  <cfquery datasource="hermes">
    UPDATE parameters
    SET parameter = <cfqueryparam value="#editParam#" cfsqltype="cf_sql_varchar">,
        weight = <cfqueryparam value="#actualWeight#" cfsqltype="cf_sql_integer">,
        action = 'NONE', applied = '1'
    WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
      AND parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Immediately generate and apply Postfix configuration --->
  <cftry>
    <cfinclude template="generate_postfix_configuration.cfm">
    <cfset session.m = 5>
    <cfcatch type="any">
      <cfset session.m = 4>
    </cfcatch>
  </cftry>
</cfif>
<cflocation url="view_rbl_configuration.cfm" addtoken="no">
