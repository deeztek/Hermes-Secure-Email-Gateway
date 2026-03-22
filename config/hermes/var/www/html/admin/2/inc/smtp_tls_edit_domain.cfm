<!---
Hermes Secure Email Gateway - SMTP TLS Edit Domain Action Handler
Validates and updates a TLS policy domain entry.
Expects: form.edit_id, form.domain, form.note
--->

<cfif NOT StructKeyExists(form, "edit_id") OR NOT isValid("integer", form.edit_id)>
  <cfset session.m = 20>
  <cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfif>

<cfif NOT StructKeyExists(form, "domain") OR trim(form.domain) is "">
  <cfset session.m = 4>
  <cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfif>

<!--- Validate domain format (allow leading dot for wildcard) --->
<cfif trim(left(form.domain, 1)) EQ ".">
  <cfset testDomain = "bob@subdomain#form.domain#">
<cfelse>
  <cfset testDomain = "bob@#form.domain#">
</cfif>

<cfif NOT IsValid("email", testDomain)>
  <cfset session.m = 4>
  <cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfif>

<!--- Check for duplicates (excluding current entry) --->
<cfquery name="checkexists" datasource="hermes">
  SELECT domain FROM tls_policies
  WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.domain#">
    AND id <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.edit_id#">
</cfquery>

<cfif checkexists.recordcount GTE 1>
  <cfset session.m = 6>
  <cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfif>

<!--- Update domain --->
<cfparam name="form.note" default="">
<cfquery datasource="hermes">
  UPDATE tls_policies
  SET domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.domain#">,
      description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.note#">
  WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.edit_id#">
</cfquery>

<!--- Generate TLS policy file and reload Postfix --->
<cfset datasource = "hermes">
<cfinclude template="./generate_tls_policy.cfm">
<cfinclude template="./generate_postfix_configuration.cfm">

<cfset session.m = 39>
<cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
