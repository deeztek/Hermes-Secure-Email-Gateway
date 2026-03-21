<!---
Hermes Secure Email Gateway - DKIM Save Settings Action Handler
Validates and saves DKIM settings to the database, generates OpenDKIM config,
restarts OpenDKIM, generates Postfix configuration, and reloads Postfix.
When DKIM is disabled, DMARC is also disabled automatically.
Expects: form.dkimenabled, and when enabled: form.body_canonicalization,
  form.headers_canonicalization, form.default_action, form.badsignature_action,
  form.dnserror_action, form.internalerror_action, form.nosignature_action,
  form.security_action, form.signature_algorithm
--->

<!--- Load current settings for parent ID lookups --->
<cfinclude template="./get_dkim_settings.cfm">

<cfset dkimenabled = form.dkimenabled>

<!--- Valid action values for DKIM policies --->
<cfset validActions = "accept,discard,reject,tempfail,quarantine">

<cfif dkimenabled is "1">
  <!--- === ENABLE DKIM === --->

  <!--- Validate all required fields exist --->
  <cfif NOT StructKeyExists(form, "body_canonicalization") OR NOT StructKeyExists(form, "headers_canonicalization")
    OR NOT StructKeyExists(form, "default_action") OR NOT StructKeyExists(form, "badsignature_action")
    OR NOT StructKeyExists(form, "dnserror_action") OR NOT StructKeyExists(form, "internalerror_action")
    OR NOT StructKeyExists(form, "nosignature_action") OR NOT StructKeyExists(form, "security_action")
    OR NOT StructKeyExists(form, "signature_algorithm")>
    <cfset session.m = 20>
    <cflocation url="view_dkim_settings.cfm" addtoken="no">
  </cfif>

  <!--- Validate field values --->
  <cfif NOT ListFindNoCase("simple,relaxed", form.body_canonicalization)
    OR NOT ListFindNoCase("simple,relaxed", form.headers_canonicalization)
    OR NOT ListFindNoCase(validActions, form.default_action)
    OR NOT ListFindNoCase(validActions, form.badsignature_action)
    OR NOT ListFindNoCase(validActions, form.dnserror_action)
    OR NOT ListFindNoCase(validActions, form.internalerror_action)
    OR NOT ListFindNoCase(validActions, form.nosignature_action)
    OR NOT ListFindNoCase(validActions, form.security_action)
    OR NOT ListFindNoCase("rsa-sha256,rsa-sha1", form.signature_algorithm)>
    <cfset session.m = 20>
    <cflocation url="view_dkim_settings.cfm" addtoken="no">
  </cfif>

  <!--- Save settings and apply (dkim_set_settings handles DB + config + OpenDKIM restart) --->
  <cfinclude template="./dkim_set_settings.cfm">

  <!--- Generate Postfix configuration and reload --->
  <cfinclude template="./generate_postfix_configuration.cfm">

  <cfset session.m = 9>

<cfelseif dkimenabled is "2">
  <!--- === DISABLE DKIM (also disables DMARC) === --->

  <!--- Save settings (dkim_set_settings handles DMARC disable + OpenDKIM restart) --->
  <cfinclude template="./dkim_set_settings.cfm">

  <!--- Generate Postfix configuration and reload --->
  <cfinclude template="./generate_postfix_configuration.cfm">

  <cfset session.m = 9>
</cfif>

<cflocation url="view_dkim_settings.cfm" addtoken="no">
