<!---
Hermes Secure Email Gateway - SMTP TLS Add Domain Action Handler
Validates and adds a domain to TLS policies table.
Expects: form.domain, form.domain_note
--->

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

<!--- Check for duplicates --->
<cfquery name="checkexists" datasource="hermes">
  SELECT domain FROM tls_policies
  WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.domain#">
</cfquery>

<cfif checkexists.recordcount GTE 1>
  <cfset session.m = 5>
  <cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfif>

<!--- Insert domain --->
<cfparam name="form.domain_note" default="">
<cfquery datasource="hermes">
  INSERT INTO tls_policies (domain, method, description, applied, action)
  VALUES (
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.domain#">,
    'encrypt',
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.domain_note#">,
    '1', 'add'
  )
</cfquery>

<!--- Generate TLS policy file and reload Postfix --->
<cfset datasource = "hermes">
<cfinclude template="./generate_tls_policy.cfm">
<cfinclude template="./generate_postfix_configuration.cfm">

<cfset session.m = 37>
<cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
