<!---
Hermes Secure Email Gateway - DKIM Edit Entry Action Handler
Routes to domain or host edit based on entry_type.
Expects: form.id, form.entry, form.note, form.entry_type ("domain" or "host")
--->

<!--- Validate required fields --->
<cfif NOT StructKeyExists(form, "id") OR NOT isValid("integer", form.id)
  OR NOT StructKeyExists(form, "entry_type") OR NOT ListFindNoCase("domain,host", form.entry_type)>
  <cfset session.m = 20>
  <cflocation url="view_dkim_settings.cfm" addtoken="no">
</cfif>

<cfif NOT StructKeyExists(form, "entry") OR trim(form.entry) is "">
  <cfset session.m = 16>
  <cflocation url="view_dkim_settings.cfm" addtoken="no">
</cfif>

<!--- IP/Network validation regex (for hosts) --->
<cfset network_cidr = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/(3[0-2]|[1-2][0-9]|[0-9]))$">
<cfset ip_cidr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">

<cfif form.entry_type is "domain">
  <!--- Validate domain format --->
  <cfset tempemail = "bob@#form.entry#">
  <cfif NOT IsValid("email", tempemail)>
    <cfset session.m = 17>
    <cflocation url="view_dkim_settings.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicates --->
  <cfquery name="checkexists" datasource="hermes">
    SELECT id FROM dkim_bypass
    WHERE entry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.entry#">
      AND id <> <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif checkexists.recordcount GTE 1>
    <cfset session.m = 14>
    <cflocation url="view_dkim_settings.cfm" addtoken="no">
  </cfif>

  <cfinclude template="./dkim_edit_domain.cfm">
  <cfinclude template="./dkim_generate_domains.cfm">

<cfelseif form.entry_type is "host">
  <!--- Validate host format (domain, IP, or CIDR) --->
  <cfset tempemail = "bob@#form.entry#">
  <cfif NOT (IsValid("email", tempemail) OR REFind(ip_cidr, form.entry) GT 0 OR REFind(network_cidr, form.entry) GT 0)>
    <cfset session.m = 17>
    <cflocation url="view_dkim_settings.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicates --->
  <cfquery name="checkexists" datasource="hermes">
    SELECT id FROM dkim_trusted_hosts
    WHERE host = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.entry#">
      AND id <> <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif checkexists.recordcount GTE 1>
    <cfset session.m = 14>
    <cflocation url="view_dkim_settings.cfm" addtoken="no">
  </cfif>

  <cfinclude template="./dkim_edit_host.cfm">
  <cfinclude template="./dkim_generate_hosts.cfm">
</cfif>

<cfinclude template="./restart_opendkim.cfm">
<cfinclude template="./restart_opendmarc.cfm">

<cfset session.m = 15>

<cflocation url="view_dkim_settings.cfm" addtoken="no">
