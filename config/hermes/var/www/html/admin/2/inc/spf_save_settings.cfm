<!---
Hermes Secure Email Gateway - SPF Save Settings Action Handler
Validates and saves SPF settings to the database, generates policyd-spf.conf,
generates Postfix configuration, and restarts Postfix.
When SPF is disabled, DMARC is also disabled automatically.
Expects: form.spfenabled, and when enabled: form.debuglevel, form.testonly,
  form.helo_reject, form.mail_from_reject, form.permerror_reject, form.temperror_defer
--->

<!--- Load current settings for parent ID lookups --->
<cfinclude template="./get_spf_settings.cfm">

<cfset spfenabled = form.spfenabled>

<cfif spfenabled is "1">
  <!--- === ENABLE SPF === --->

  <!--- Validate all required fields exist --->
  <cfif NOT StructKeyExists(form, "debuglevel") OR NOT StructKeyExists(form, "testonly")
    OR NOT StructKeyExists(form, "helo_reject") OR NOT StructKeyExists(form, "mail_from_reject")
    OR NOT StructKeyExists(form, "permerror_reject") OR NOT StructKeyExists(form, "temperror_defer")>
    <cfset session.m = 20>
    <cflocation url="view_spf_settings.cfm" addtoken="no">
  </cfif>

  <!--- Update SPF enabled --->
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '1', applied = '1'
    WHERE parameter = 'check_policy_service unix:private/policy-spf'
      AND child = '1' AND parent = <cfqueryparam value="#get_smtpd_recipient_restrictions_id.id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Update SPF policy settings --->
  <cfquery datasource="hermes">
    UPDATE parameters2 SET value2 = <cfqueryparam value="#form.debuglevel#" cfsqltype="cf_sql_varchar">, applied = '1'
    WHERE parameter = 'debugLevel' AND module = 'spf'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters2 SET value2 = <cfqueryparam value="#form.testonly#" cfsqltype="cf_sql_varchar">, applied = '1'
    WHERE parameter = 'TestOnly' AND module = 'spf'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters2 SET value2 = <cfqueryparam value="#form.helo_reject#" cfsqltype="cf_sql_varchar">, applied = '1'
    WHERE parameter = 'HELO_reject' AND module = 'spf'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters2 SET value2 = <cfqueryparam value="#form.mail_from_reject#" cfsqltype="cf_sql_varchar">, applied = '1'
    WHERE parameter = 'Mail_From_reject' AND module = 'spf'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters2 SET value2 = <cfqueryparam value="#form.permerror_reject#" cfsqltype="cf_sql_varchar">, applied = '1'
    WHERE parameter = 'PermError_reject' AND module = 'spf'
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters2 SET value2 = <cfqueryparam value="#form.temperror_defer#" cfsqltype="cf_sql_varchar">, applied = '1'
    WHERE parameter = 'TempError_Defer' AND module = 'spf'
  </cfquery>

  <!--- Generate SPF config file --->
  <cfinclude template="./spf_generate_config_file.cfm">

  <!--- Generate Postfix configuration and reload (includes postfix reload in script) --->
  <cfinclude template="./generate_postfix_configuration.cfm">

  <cfset session.m = 9>

<cfelseif spfenabled is "2">
  <!--- === DISABLE SPF === --->

  <!--- Disable SPF in parameters --->
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '2', applied = '1'
    WHERE parameter = 'check_policy_service unix:private/policy-spf'
      AND child = '1' AND parent = <cfqueryparam value="#get_smtpd_recipient_restrictions_id.id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Also disable DMARC (DMARC requires SPF) --->
  <cfinclude template="./get_dmarc_settings.cfm">

  <!--- Disable DMARC milters in parameters --->
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '2', applied = '1'
    WHERE parameter LIKE 'inet:%:54321' AND child = '1'
      AND parent = <cfqueryparam value="#get_smtpd_milters_id.id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfquery datasource="hermes">
    UPDATE parameters SET enabled = '2', applied = '1'
    WHERE parameter LIKE 'inet:%:54321' AND child = '1'
      AND parent = <cfqueryparam value="#get_non_smtpd_milters_id.id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Disable DMARC failure reports --->
  <cfquery datasource="hermes">
    UPDATE parameters2 SET value2 = 'false', applied = '1'
    WHERE parameter = 'FailureReports' AND module = 'dmarc'
  </cfquery>

  <!--- Delete DMARC report script if exists --->
  <cfset FiletoDelete = "/opt/hermes/schedule/dmarc_report_script.sh">
  <cfif fileExists(FiletoDelete)>
    <cffile action="delete" file="#FiletoDelete#">
  </cfif>

  <!--- Disable DMARC report job in Ofelia --->
  <cfquery datasource="hermes">
    UPDATE ofelia_jobs SET active = '2' WHERE job_name = '[job-exec "hermes-dmarc-report"]'
  </cfquery>
  <cfinclude template="./ofelia_generate_config.cfm">

  <!--- Generate DMARC config file --->
  <cfset form.failurereports = "false">
  <cfset form.rejectfailures = "false">
  <cfset form.holdquarantinedmessages = "false">
  <cfinclude template="./dmarc_generate_config_file.cfm">

  <!--- Restart OpenDMARC --->
  <cfinclude template="./restart_opendmarc.cfm">

  <!--- Generate Postfix configuration and reload (includes postfix reload in script) --->
  <cfinclude template="./generate_postfix_configuration.cfm">

  <cfset session.m = 9>
</cfif>

<cflocation url="view_spf_settings.cfm" addtoken="no">
