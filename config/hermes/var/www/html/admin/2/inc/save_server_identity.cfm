<!---
Hermes Secure Email Gateway - Save Server Identity Action Handler
Updates Postfix myorigin (domain) and myhostname (FQDN) in the parameters table,
then regenerates Postfix configuration and reloads.
Expects: form.server_domain, form.server_hostname
--->

<!--- Validate required fields --->
<cfif NOT StructKeyExists(form, "server_domain") OR trim(form.server_domain) is "">
  <cfset session.m = 2>
  <cflocation url="view_server_identity.cfm" addtoken="no">
</cfif>

<cfif NOT StructKeyExists(form, "server_hostname") OR trim(form.server_hostname) is "">
  <cfset session.m = 3>
  <cflocation url="view_server_identity.cfm" addtoken="no">
</cfif>

<!--- Validate domain format (use email trick) --->
<cfset tempemail = "test@#trim(form.server_domain)#">
<cfif NOT IsValid("email", tempemail)>
  <cfset session.m = 4>
  <cflocation url="view_server_identity.cfm" addtoken="no">
</cfif>

<!--- Validate hostname format (must be FQDN) --->
<cfset tempemail2 = "test@#trim(form.server_hostname)#">
<cfif NOT IsValid("email", tempemail2)>
  <cfset session.m = 5>
  <cflocation url="view_server_identity.cfm" addtoken="no">
</cfif>

<!--- Validate host IP if provided --->
<cfparam name="form.host_ip" default="">
<cfif trim(form.host_ip) is not "" AND NOT REFind("^(\d{1,3}\.){3}\d{1,3}$", trim(form.host_ip))>
  <cfset session.m = 6>
  <cflocation url="view_server_identity.cfm" addtoken="no">
</cfif>

<cfset ServerDomain = trim(form.server_domain)>
<cfset ServerName = trim(form.server_hostname)>
<cfset HostIP = trim(form.host_ip)>

<!--- Update host IP in parameters2 --->
<cfquery datasource="hermes">
  UPDATE parameters2 SET value2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HostIP#">
  WHERE parameter = 'server_ip' AND module = 'network'
</cfquery>

<!--- Ensure parent parameters are enabled --->
<cfquery datasource="hermes">
  UPDATE parameters SET enabled = '1'
  WHERE parameter IN ('myorigin', 'myhostname')
    AND child = '2' AND module = 'postfix'
</cfquery>

<!--- Update child parameter values --->
<cfquery datasource="hermes">
  UPDATE parameters SET parameter = <cfqueryparam value="#ServerDomain#" cfsqltype="cf_sql_varchar">
  WHERE parent_name = 'myorigin' AND child = '1' AND module = 'postfix' AND conf_file = 'main.cf'
</cfquery>

<cfquery datasource="hermes">
  UPDATE parameters SET parameter = <cfqueryparam value="#ServerName#" cfsqltype="cf_sql_varchar">
  WHERE parent_name = 'myhostname' AND child = '1' AND module = 'postfix' AND conf_file = 'main.cf'
</cfquery>

<!--- Generate Postfix configuration and reload --->
<cfinclude template="./generate_postfix_configuration.cfm">

<cfset session.m = 1>
<cflocation url="view_server_identity.cfm" addtoken="no">
