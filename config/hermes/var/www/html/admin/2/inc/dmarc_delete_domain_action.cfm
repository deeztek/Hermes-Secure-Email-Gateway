<!---
Hermes Secure Email Gateway - DMARC Delete Domain(s) Action Handler
Expects: form.delete_id (comma-separated list of integer IDs)
--->

<cfif NOT StructKeyExists(form, "delete_id") OR trim(form.delete_id) is "">
  <cfset session.m = 11>
  <cflocation url="view_dmarc_settings.cfm" addtoken="no">
</cfif>

<cfloop index="i" list="#form.delete_id#" delimiters=",">
  <cfif IsValid("integer", i)>
    <cfquery name="getdomain" datasource="hermes">
      SELECT id FROM dmarc_domains WHERE id = <cfqueryparam value="#i#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getdomain.recordcount GTE 1>
      <cfset delete_id = i>
      <cfinclude template="./dmarc_delete_domain.cfm">
    </cfif>
  </cfif>
</cfloop>

<cfset session.m = 12>

<cfinclude template="./dmarc_generate_domains.cfm">
<cfinclude template="./restart_opendmarc.cfm">

<cflocation url="view_dmarc_settings.cfm" addtoken="no">
