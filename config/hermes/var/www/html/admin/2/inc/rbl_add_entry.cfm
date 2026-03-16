
<!---
Hermes Secure Email Gateway - RBL Add Entry Action Handler
Adds a new RBL block/allow list entry to the parameters table.
Expects: form.rbl_host, form.rbl_weight, form.rbl_type
Requires: get_rbl_configuration.cfm (provides get_dnsbl_sites_id)
--->

<cfif NOT StructKeyExists(form, "rbl_host") OR trim(form.rbl_host) is "">
  <cfset session.m = 10>
  <cflocation url="view_rbl_configuration.cfm" addtoken="no">
</cfif>

<cfset rblHost = trim(form.rbl_host)>
<cfset rblWeight = 1>
<cfif StructKeyExists(form, "rbl_weight") AND IsNumeric(form.rbl_weight)>
  <cfset rblWeight = Int(form.rbl_weight)>
</cfif>
<cfset rblType = "block">
<cfif StructKeyExists(form, "rbl_type")><cfset rblType = form.rbl_type></cfif>

<!--- Validate hostname format --->
<cfset temp_email = "test@" & rblHost>
<cfif NOT IsValid("email", temp_email)>
  <cfset session.m = 11>
  <cflocation url="view_rbl_configuration.cfm" addtoken="no">
</cfif>

<!--- Check for duplicates --->
<cfquery name="checkDup" datasource="hermes">
  SELECT COUNT(*) as cnt FROM parameters
  WHERE parameter LIKE <cfqueryparam value="%#rblHost#%" cfsqltype="cf_sql_varchar">
    AND child = '1' AND parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif checkDup.cnt GT 0>
  <cfset session.m = 12>
  <cflocation url="view_rbl_configuration.cfm" addtoken="no">
</cfif>

<!--- Get next order --->
<cfquery name="getMaxOrder" datasource="hermes">
  SELECT COALESCE(MAX(order1), 0) as maxOrder FROM parameters
  WHERE parent = <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer"> AND child = '1'
</cfquery>
<cfset nextOrder = getMaxOrder.maxOrder + 1>

<!--- Set weight: positive for block, negative for allow --->
<cfif rblType is "allow">
  <cfset actualWeight = -Abs(rblWeight)>
  <cfset paramValue = rblHost>
<cfelse>
  <cfset actualWeight = Abs(rblWeight)>
  <cfset paramValue = rblHost & "*" & Abs(rblWeight)>
</cfif>

<cfquery datasource="hermes">
  INSERT INTO parameters (parameter, module, editable, conf_file, parent, child, order1, enabled, weight, applied, action)
  VALUES (
    <cfqueryparam value="#paramValue#" cfsqltype="cf_sql_varchar">,
    'postfix', '1', 'main.cf',
    <cfqueryparam value="#get_dnsbl_sites_id.id#" cfsqltype="cf_sql_integer">,
    '1',
    <cfqueryparam value="#nextOrder#" cfsqltype="cf_sql_integer">,
    '1',
    <cfqueryparam value="#actualWeight#" cfsqltype="cf_sql_integer">,
    '2', 'insert'
  )
</cfquery>

<cfset session.m = 1>
<cflocation url="view_rbl_configuration.cfm" addtoken="no">
