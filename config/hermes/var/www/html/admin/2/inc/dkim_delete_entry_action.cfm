<!---
Hermes Secure Email Gateway - DKIM Delete Entry Action Handler
Deletes selected domain/host entries. Entries are identified by "id|type" format.
Expects: form.delete_id (comma-separated list of "id|type" pairs)
--->

<cfif NOT StructKeyExists(form, "delete_id") OR trim(form.delete_id) is "">
  <cfset session.m = 11>
  <cflocation url="view_dkim_settings.cfm" addtoken="no">
</cfif>

<cfloop index="i" list="#form.delete_id#" delimiters=",">
  <cfset theType = listGetAt(i, 2, "|")>
  <cfset theId = listGetAt(i, 1, "|")>

  <cfif theType is "host">
    <cfquery name="gethost" datasource="hermes">
      SELECT id FROM dkim_trusted_hosts WHERE id = <cfqueryparam value="#theId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif gethost.recordcount GTE 1>
      <cfset delete_id = theId>
      <cfinclude template="./dkim_delete_host.cfm">
    </cfif>

  <cfelseif theType is "domain">
    <cfquery name="getdomain" datasource="hermes">
      SELECT id FROM dkim_bypass WHERE id = <cfqueryparam value="#theId#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getdomain.recordcount GTE 1>
      <cfset delete_id = theId>
      <cfinclude template="./dkim_delete_domain.cfm">
    </cfif>
  </cfif>
</cfloop>

<cfset session.m = 12>

<cfinclude template="./dkim_generate_hosts.cfm">
<cfinclude template="./dkim_generate_domains.cfm">
<cfinclude template="./restart_opendkim.cfm">
<cfinclude template="./restart_opendmarc.cfm">

<cflocation url="view_dkim_settings.cfm" addtoken="no">
