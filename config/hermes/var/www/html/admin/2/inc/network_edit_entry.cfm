
<!---
Hermes Secure Email Gateway - Network Block/Allow Edit Entry Action Handler
Updates an existing network entry and applies configuration immediately.
Expects: form.edit_id, form.edit_sender, form.edit_action, form.edit_note
--->

<cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)>
  <cfquery datasource="hermes">
    UPDATE postscreen_access
    SET sender = <cfqueryparam value="#trim(form.edit_sender)#" cfsqltype="cf_sql_varchar">,
        action = <cfqueryparam value="#form.edit_action#" cfsqltype="cf_sql_varchar">,
        note = <cfqueryparam value="#trim(form.edit_note)#" cfsqltype="cf_sql_varchar">,
        action2 = 'NONE', applied = '1'
    WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cftry>
    <cfinclude template="generate_postscreen_access.cfm">
    <cfset session.m = 5>
    <cfcatch type="any">
      <cfset session.m = 4>
    </cfcatch>
  </cftry>
</cfif>
<cflocation url="view_network_block_allow.cfm" addtoken="no">
