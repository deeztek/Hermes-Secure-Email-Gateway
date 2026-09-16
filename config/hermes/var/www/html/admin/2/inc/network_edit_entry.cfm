
<!---
Hermes Secure Email Gateway - Network Block/Allow Edit Entry Action Handler
Updates an existing network entry and applies configuration immediately.
Expects: form.edit_id, form.edit_sender, form.edit_action, form.edit_note
--->

<cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)>
  <!--- An alias row holds the alias NAME in `sender`, and editing it could only
       break the reference or turn it into a literal that stops tracking the
       alias. The Edit button is hidden on those rows, so reaching here means a
       hand-made POST. Refuse it rather than overwrite the name. Ranges are
       changed on the Network Aliases page; here the row is a reference you
       either keep or delete. --->
  <cfquery name="check_edit_is_alias" datasource="hermes">
    SELECT id FROM postscreen_access
    WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
      AND entry_type = 'alias'
  </cfquery>
  <cfif check_edit_is_alias.recordcount GTE 1>
    <cfset session.m = 31>
    <cflocation url="view_network_block_allow.cfm" addtoken="no">
  </cfif>

  <!--- Validate the address. This path had none at all: whatever was typed went
       into the UPDATE and then into postscreen_access.cidr. The add path checks
       the shape and the host bits, and an edit can write exactly the same value,
       so it has to check the same things. See inc/cidr_validate.cfm. --->
  <cfinclude template="cidr_validate.cfm">
  <cfset editCheck = cidrCheck(trim(form.edit_sender))>
  <cfif NOT editCheck.ok>
    <cfset session.entry_errors = EncodeForHTML(trim(form.edit_sender)) & ": " & EncodeForHTML(editCheck.error)>
    <cfif Len(editCheck.suggest)>
      <cfset session.entry_errors = session.entry_errors & ". Did you mean " & EncodeForHTML(editCheck.suggest) & "?">
    </cfif>
    <cfset session.m = 36>
    <cflocation url="view_network_block_allow.cfm" addtoken="no">
  </cfif>

  <cfquery datasource="hermes">
    UPDATE postscreen_access
    SET sender = <cfqueryparam value="#editCheck.cidr#" cfsqltype="cf_sql_varchar">,
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
