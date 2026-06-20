<!---
Hermes Secure Email Gateway - DKIM Add Entry Action Handler
Validates and adds domain or host entries based on entry_type.
Expects: form.entry_type ("domain" or "host"), form.entries (textarea, one per line), form.note
--->

<cfif NOT StructKeyExists(form, "entry_type") OR NOT ListFindNoCase("domain,host", form.entry_type)>
  <cfset session.m = 20>
  <cflocation url="view_dkim_settings.cfm" addtoken="no">
</cfif>

<cfif NOT StructKeyExists(form, "entries") OR trim(form.entries) is "">
  <cfset session.m = 13>
  <cflocation url="view_dkim_settings.cfm" addtoken="no">
</cfif>

<cfif form.entry_type is "domain">
  <!--- Map entries field to domain field expected by dkim_add_domains.cfm --->
  <cfset form.domain = form.entries>
  <cfinclude template="./dkim_add_domains.cfm">
  <cfinclude template="./dkim_generate_domains.cfm">
<cfelseif form.entry_type is "host">
  <!--- Map entries field to host field expected by dkim_add_hosts.cfm --->
  <cfset form.host = form.entries>
  <cfinclude template="./dkim_add_hosts.cfm">
  <cfinclude template="./dkim_generate_hosts.cfm">
</cfif>

<cfinclude template="./restart_opendkim.cfm">
<cfinclude template="./restart_opendmarc.cfm">

<cflocation url="view_dkim_settings.cfm" addtoken="no">
