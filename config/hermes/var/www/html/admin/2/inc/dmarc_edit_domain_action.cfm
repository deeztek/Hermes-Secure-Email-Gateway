<!---
Hermes Secure Email Gateway - DMARC Edit Domain Action Handler
Expects: form.id, form.domain, form.note
--->

<cfif NOT StructKeyExists(form, "id") OR NOT isValid("integer", form.id)>
  <cfset session.m = 20>
  <cflocation url="view_dmarc_settings.cfm" addtoken="no">
</cfif>

<cfif NOT StructKeyExists(form, "domain") OR trim(form.domain) is "">
  <cfset session.m = 16>
  <cflocation url="view_dmarc_settings.cfm" addtoken="no">
</cfif>

<!--- Validate domain format --->
<cfset tempemail = "bob@#form.domain#">
<cfif NOT IsValid("email", tempemail)>
  <cfset session.m = 17>
  <cflocation url="view_dmarc_settings.cfm" addtoken="no">
</cfif>

<!--- Check for duplicates (excluding current entry) --->
<cfquery name="checkexists" datasource="hermes">
  SELECT id FROM dmarc_domains
  WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.domain#">
    AND id <> <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif checkexists.recordcount GTE 1>
  <cfset session.m = 14>
  <cflocation url="view_dmarc_settings.cfm" addtoken="no">
</cfif>

<cfinclude template="./dmarc_edit_domain.cfm">
<cfinclude template="./dmarc_generate_domains.cfm">
<cfinclude template="./restart_opendmarc.cfm">

<cfset session.m = 15>

<cflocation url="view_dmarc_settings.cfm" addtoken="no">
