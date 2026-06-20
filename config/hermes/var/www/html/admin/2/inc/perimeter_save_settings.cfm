
<!---
Hermes Secure Email Gateway - Perimeter Checks Save Settings Action Handler
Validates and saves all perimeter check settings, then regenerates Postfix config.
Requires: get_perimeter_checks.cfm (provides parent IDs)
--->

<!--- Validate DNSBL threshold --->
<cfif NOT StructKeyExists(form, "dnsbl_threshold") OR NOT IsValid("integer", form.dnsbl_threshold)>
  <cfset session.m = 2>
  <cflocation url="view_perimeter_checks.cfm" addtoken="no">
</cfif>

<!--- Validate message size --->
<cfif NOT StructKeyExists(form, "message_size_limit") OR NOT IsValid("float", form.message_size_limit) OR form.message_size_limit LTE 0>
  <cfset session.m = 3>
  <cflocation url="view_perimeter_checks.cfm" addtoken="no">
</cfif>

<!--- Update DNSBL Threshold --->
<cfquery datasource="hermes">
  UPDATE parameters SET parameter = <cfqueryparam value="#form.dnsbl_threshold#" cfsqltype="cf_sql_varchar">, applied = '2'
  WHERE parent = <cfqueryparam value="#get_dnsbl_threshold_id.id#" cfsqltype="cf_sql_integer"> AND child = '1' AND enabled = '1'
</cfquery>

<!--- Update Message Size Limit (convert MB to bytes) --->
<cfset messageSizeBytes = form.message_size_limit * 1024 * 1024>
<cfquery datasource="hermes">
  UPDATE parameters SET parameter = <cfqueryparam value="#Int(messageSizeBytes)#" cfsqltype="cf_sql_varchar">, applied = '2'
  WHERE parent = <cfqueryparam value="#get_message_size_id.id#" cfsqltype="cf_sql_integer"> AND child = '1' AND enabled = '1'
</cfquery>

<!--- Update Postscreen Pipelining Enable --->
<cfset pipeVal = "no">
<cfif StructKeyExists(form, "postscreen_pipelining") AND form.postscreen_pipelining is "yes"><cfset pipeVal = "yes"></cfif>
<cfquery datasource="hermes">
  UPDATE parameters SET parameter = <cfqueryparam value="#pipeVal#" cfsqltype="cf_sql_varchar">, applied = '2'
  WHERE parent = <cfqueryparam value="#get_postscreen_pipelining_id.id#" cfsqltype="cf_sql_integer"> AND child = '1'
</cfquery>

<!--- Update Postscreen Non-SMTP Command Enable --->
<cfset nonSmtpVal = "no">
<cfif StructKeyExists(form, "postscreen_non_smtp") AND form.postscreen_non_smtp is "yes"><cfset nonSmtpVal = "yes"></cfif>
<cfquery datasource="hermes">
  UPDATE parameters SET parameter = <cfqueryparam value="#nonSmtpVal#" cfsqltype="cf_sql_varchar">, applied = '2'
  WHERE parent = <cfqueryparam value="#get_postscreen_non_smtp_id.id#" cfsqltype="cf_sql_integer"> AND child = '1'
</cfquery>

<!--- Update Postscreen Bare Newline Enable --->
<cfset bareVal = "no">
<cfif StructKeyExists(form, "postscreen_bare_newline") AND form.postscreen_bare_newline is "yes"><cfset bareVal = "yes"></cfif>
<cfquery datasource="hermes">
  UPDATE parameters SET parameter = <cfqueryparam value="#bareVal#" cfsqltype="cf_sql_varchar">, applied = '2'
  WHERE parent = <cfqueryparam value="#get_postscreen_bare_newline_id.id#" cfsqltype="cf_sql_integer"> AND child = '1'
</cfquery>

<!--- Update HELO Required --->
<cfset heloVal = "2">
<cfif StructKeyExists(form, "helo_required") AND form.helo_required is "1"><cfset heloVal = "1"></cfif>
<cfquery datasource="hermes">
  UPDATE parameters SET enabled = <cfqueryparam value="#heloVal#" cfsqltype="cf_sql_varchar">, applied = '2'
  WHERE parent = <cfqueryparam value="#get_helo_required_id.id#" cfsqltype="cf_sql_integer"> AND child = '1'
</cfquery>

<!--- Update Recipient Restrictions --->
<cfset restrictionList = "reject_unauth_destination,reject_unauth_pipelining,reject_invalid_hostname,reject_non_fqdn_sender,reject_unknown_sender_domain,reject_non_fqdn_recipient,reject_unknown_recipient_domain">
<cfloop list="#restrictionList#" index="restriction">
  <cfset restrictVal = "2">
  <cfif StructKeyExists(form, restriction) AND form[restriction] is "1"><cfset restrictVal = "1"></cfif>
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = <cfqueryparam value="#restrictVal#" cfsqltype="cf_sql_varchar">, applied = '2'
    WHERE parameter = <cfqueryparam value="#restriction#" cfsqltype="cf_sql_varchar">
      AND child = '1' AND parent = <cfqueryparam value="#get_recipient_restrictions_id.id#" cfsqltype="cf_sql_integer">
  </cfquery>
</cfloop>

<!--- Generate and apply Postfix configuration --->
<cftry>
  <cfinclude template="generate_postfix_configuration.cfm">
  <cfset session.m = 1>
  <cfcatch type="any">
    <cfset session.m = 4>
    <cfset session.postfix_error = cfcatch.message & " " & cfcatch.detail>
  </cfcatch>
</cftry>

<cflocation url="view_perimeter_checks.cfm" addtoken="no">
