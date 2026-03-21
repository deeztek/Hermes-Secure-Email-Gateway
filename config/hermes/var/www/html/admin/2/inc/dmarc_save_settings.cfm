<!---
Hermes Secure Email Gateway - DMARC Save Settings Action Handler
Validates and saves DMARC settings. DMARC requires both SPF and DKIM enabled.
When failure reports are enabled, validates email and org fields.
Expects: form.dmarcenabled, and when enabled: form.rejectfailures,
  form.holdquarantinedmessages, form.failurereports,
  and when reports enabled: form.report_email, form.report_org
--->

<!--- Load current settings for parent ID lookups --->
<cfinclude template="./get_dmarc_settings.cfm">

<cfset dmarcenabled = form.dmarcenabled>

<cfif dmarcenabled is "1">
  <!--- === ENABLE DMARC === --->

  <!--- Check SPF and DKIM are enabled --->
  <cfinclude template="./get_spf_settings.cfm">
  <cfinclude template="./get_dkim_settings.cfm">

  <cfif get_spf.enabled is not "1" OR get_dkim.enabled is not "1">
    <cfset session.m = 1>
    <cflocation url="view_dmarc_settings.cfm" addtoken="no">
  </cfif>

  <!--- Validate required fields --->
  <cfif NOT StructKeyExists(form, "rejectfailures") OR NOT StructKeyExists(form, "holdquarantinedmessages")
    OR NOT StructKeyExists(form, "failurereports")>
    <cfset session.m = 20>
    <cflocation url="view_dmarc_settings.cfm" addtoken="no">
  </cfif>

  <!--- Validate field values --->
  <cfif NOT ListFindNoCase("true,false", form.rejectfailures)
    OR NOT ListFindNoCase("true,false", form.holdquarantinedmessages)
    OR NOT ListFindNoCase("true,false", form.failurereports)>
    <cfset session.m = 20>
    <cflocation url="view_dmarc_settings.cfm" addtoken="no">
  </cfif>

  <!--- If failure reports enabled, validate email and org --->
  <cfif form.failurereports is "true">
    <cfif NOT StructKeyExists(form, "report_email") OR trim(form.report_email) is "">
      <cfset session.m = 2>
      <cflocation url="view_dmarc_settings.cfm" addtoken="no">
    </cfif>
    <cfif NOT IsValid("email", form.report_email)>
      <cfset session.m = 3>
      <cflocation url="view_dmarc_settings.cfm" addtoken="no">
    </cfif>
    <cfif NOT StructKeyExists(form, "report_org") OR trim(form.report_org) is "">
      <cfset session.m = 4>
      <cflocation url="view_dmarc_settings.cfm" addtoken="no">
    </cfif>
    <cfif REFind("[^A-Za-z0-9]", form.report_org) GT 0>
      <cfset session.m = 5>
      <cflocation url="view_dmarc_settings.cfm" addtoken="no">
    </cfif>
  </cfif>

  <!--- Save settings (dmarc_set_settings handles DB + config + OpenDMARC restart) --->
  <cfinclude template="./dmarc_set_settings.cfm">

  <!--- Generate Postfix configuration and reload --->
  <cfinclude template="./generate_postfix_configuration.cfm">

  <cfset session.m = 9>

<cfelseif dmarcenabled is "2">
  <!--- === DISABLE DMARC === --->

  <cfset form.failurereports = "false">
  <cfset form.rejectfailures = "false">
  <cfset form.holdquarantinedmessages = "false">

  <!--- Save settings (dmarc_set_settings handles DB + config + OpenDMARC restart) --->
  <cfinclude template="./dmarc_set_settings.cfm">

  <!--- Generate Postfix configuration and reload --->
  <cfinclude template="./generate_postfix_configuration.cfm">

  <cfset session.m = 9>
</cfif>

<cflocation url="view_dmarc_settings.cfm" addtoken="no">
