<!---
Hermes Secure Email Gateway - Console Firewall Action Handler
Handles add, edit, delete IP and firewall status toggle.
Auto-applies: regenerates Nginx config and redirects to preload_restart_nginx.cfm
--->

<cfinclude template="./validate_ip_address.cfm">

<!--- ClientIP is set globally in Application.cfc from X-Forwarded-For header --->

<!--- Get current firewall status --->
<cfquery name="checkstatus" datasource="hermes">
  SELECT value2 FROM parameters2 WHERE parameter = 'firewall_status' AND module = 'firewall' AND active = '1'
</cfquery>
<cfset firewall_status = checkstatus.value2>

<cfif action is "addip">

  <!--- Validate IP --->
  <cfif NOT StructKeyExists(form, "ip_address") OR NOT REFind(pattern, trim(form.ip_address))>
    <cfset session.m = 7>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
  </cfif>

  <!--- Check duplicate --->
  <cfquery name="checkdup" datasource="hermes">
    SELECT ip FROM firewall WHERE ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.ip_address)#">
  </cfquery>
  <cfif checkdup.recordcount GTE 1>
    <cfset session.m = 6>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
  </cfif>

  <!--- Validate hermesadmin/ciphermailadmin --->
  <cfparam name="form.ip_hermesadmin" default="yes">
  <cfparam name="form.ip_ciphermailadmin" default="yes">
  <cfparam name="form.ip_note" default="">

  <!--- Insert --->
  <cfquery datasource="hermes">
    INSERT INTO firewall (ip, hermesadmin, ciphermailadmin, note)
    VALUES (
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.ip_address)#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ip_hermesadmin#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ip_ciphermailadmin#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ip_note#">
    )
  </cfquery>

  <cfset session.m = 37>

<cfelseif action is "editip">

  <!--- Validate --->
  <cfif NOT StructKeyExists(form, "ip_id") OR NOT isValid("integer", form.ip_id)>
    <cfset session.m = 20>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
  </cfif>

  <cfif NOT StructKeyExists(form, "ip_address") OR NOT REFind(pattern, trim(form.ip_address))>
    <cfset session.m = 1>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
  </cfif>

  <!--- Check duplicate (excluding self) --->
  <cfquery name="checkdup" datasource="hermes">
    SELECT id FROM firewall WHERE ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.ip_address)#">
      AND id <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ip_id#">
  </cfquery>
  <cfif checkdup.recordcount GTE 1>
    <cfset session.m = 2>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
  </cfif>

  <!--- Safety check: can't edit own IP while firewall enabled --->
  <cfquery name="getip" datasource="hermes">
    SELECT ip FROM firewall WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ip_id#">
  </cfquery>
  <cfif getip.ip is ClientIP AND firewall_status is "enabled" AND trim(form.ip_address) is not ClientIP>
    <cfset session.m = 4>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
  </cfif>

  <cfparam name="form.ip_hermesadmin" default="yes">
  <cfparam name="form.ip_ciphermailadmin" default="yes">
  <cfparam name="form.ip_note" default="">

  <!--- Update --->
  <cfquery datasource="hermes">
    UPDATE firewall SET
      ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.ip_address)#">,
      hermesadmin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ip_hermesadmin#">,
      ciphermailadmin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ip_ciphermailadmin#">,
      note = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ip_note#">
    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ip_id#">
  </cfquery>

  <cfset session.m = 33>

<cfelseif action is "deleteip">

  <cfif NOT StructKeyExists(form, "ip_id") OR NOT isValid("integer", form.ip_id)>
    <cfset session.m = 20>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
  </cfif>

  <!--- Safety check: can't delete own IP while firewall enabled --->
  <cfquery name="getip" datasource="hermes">
    SELECT ip FROM firewall WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ip_id#">
  </cfquery>
  <cfif getip.ip is ClientIP AND firewall_status is "enabled">
    <cfset session.m = 3>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
  </cfif>

  <cfquery datasource="hermes">
    DELETE FROM firewall WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ip_id#">
  </cfquery>

  <cfset session.m = 34>

<cfelseif action is "setfirewall">

  <cfif NOT StructKeyExists(form, "firewall_status") OR NOT ListFindNoCase("enabled,disabled", form.firewall_status)>
    <cfset session.m = 20>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
  </cfif>

  <!--- Safety check: can't enable unless current IP is in the list with hermesadmin=yes --->
  <cfif form.firewall_status is "enabled">
    <cfquery name="checkcurrent" datasource="hermes">
      SELECT ip FROM firewall WHERE ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ClientIP#"> AND hermesadmin = 'yes'
    </cfquery>
    <cfif checkcurrent.recordcount LT 1>
      <cfset session.m = 5>
      <cflocation url="view_console_firewall.cfm" addtoken="no">
    </cfif>
  </cfif>

  <cfquery datasource="hermes">
    UPDATE parameters2 SET value2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.firewall_status#">
    WHERE parameter = 'firewall_status' AND module = 'firewall' AND active = '1'
  </cfquery>

  <cfif form.firewall_status is "enabled">
    <cfset session.m = 35>
  <cfelse>
    <cfset session.m = 36>
  </cfif>

</cfif>

<!--- Auto-apply: regenerate Nginx config and redirect to restart page --->
<cfinclude template="./generate_nginx_configuration.cfm">
<cflocation url="/admin/2/preload_restart_nginx.cfm?returnUrl=/admin/2/view_console_firewall.cfm" addtoken="no">
