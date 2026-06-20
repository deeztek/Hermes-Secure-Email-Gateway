<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<cfparam name="url.id" default="">
<cfparam name="url.filetype" default="">

<!--- Enforce security setting --->
<cfset allowCertDownload = false>
<cfset securityConfPath = "/opt/hermes/config/security.conf">
<cfif fileExists(securityConfPath)>
  <cftry>
    <cffile action="read" file="#securityConfPath#" variable="securityConf">
    <cfif REFindNoCase("ALLOW_CERT_DOWNLOAD\s*=\s*yes", securityConf)>
      <cfset allowCertDownload = true>
    </cfif>
    <cfcatch></cfcatch>
  </cftry>
</cfif>

<cfif NOT allowCertDownload>
  <cfset m = "Certificate downloads are disabled. Enable ALLOW_CERT_DOWNLOAD in /opt/hermes/config/security.conf">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<!--- Validate parameters --->
<cfif url.id is "" OR NOT isValid("integer", url.id)>
  <cfset m = "download_certificate.cfm: Invalid certificate ID">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<cfif NOT ListFindNoCase("cert,key,chain", url.filetype)>
  <cfset m = "download_certificate.cfm: Invalid file type">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<!--- Look up certificate record --->
<cfquery name="getCert" datasource="hermes">
  SELECT id, type, file_name, domain_name, friendly_name
  FROM system_certificates
  WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getCert.recordcount LT 1>
  <cfset m = "download_certificate.cfm: Certificate not found">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<!--- Determine file path based on cert type and requested file --->
<cfset filePath = "">
<cfset fileName = "">

<cfif getCert.type is "Acme">
  <cfswitch expression="#url.filetype#">
    <cfcase value="cert">
      <cfset filePath = "/etc/letsencrypt/live/#getCert.file_name#/fullchain.pem">
      <cfset fileName = "#getCert.file_name#_fullchain.pem">
    </cfcase>
    <cfcase value="key">
      <cfset filePath = "/etc/letsencrypt/live/#getCert.file_name#/privkey.pem">
      <cfset fileName = "#getCert.file_name#_privkey.pem">
    </cfcase>
    <cfcase value="chain">
      <cfset filePath = "/etc/letsencrypt/live/#getCert.file_name#/chain.pem">
      <cfset fileName = "#getCert.file_name#_chain.pem">
    </cfcase>
  </cfswitch>
<cfelseif getCert.type is "Imported">
  <cfswitch expression="#url.filetype#">
    <cfcase value="cert">
      <cfset filePath = "/opt/hermes/ssl/#getCert.file_name#_hermes.pem">
      <cfset fileName = "#getCert.file_name#_certificate.pem">
    </cfcase>
    <cfcase value="key">
      <cfset filePath = "/opt/hermes/ssl/#getCert.file_name#_hermes.key">
      <cfset fileName = "#getCert.file_name#_privkey.pem">
    </cfcase>
    <cfcase value="chain">
      <cfset filePath = "/opt/hermes/ssl/#getCert.file_name#_hermes.chain.pem">
      <cfset fileName = "#getCert.file_name#_chain.pem">
    </cfcase>
  </cfswitch>
</cfif>

<cfif filePath is "" OR NOT fileExists(filePath)>
  <cfset m = "download_certificate.cfm: File not found (#url.filetype# for #getCert.friendly_name#)">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<!--- Serve the file as a download --->
<cfheader name="Content-Disposition" value="attachment;filename=#fileName#">
<cfcontent file="#filePath#" type="application/x-pem-file">
