<!---
Hermes Secure Email Gateway - System Certificates Action Handler
Routes to generate CSR, delete certificate, request ACME, or import certificate.
--->

<cfif action is "generatecsr">

  <!--- Validate required fields --->
  <cfloop list="country,state,locality,organization,department,commonname,encryption,algorithm" index="f">
    <cfif NOT StructKeyExists(form, f)>
      <cfset session.m = "Generate CSR: form.#f# does not exist">
      <cfset session.alerttype = "error">
      <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfif>
  </cfloop>

  <!--- Validate country code (2 chars) --->
  <cfif Len(form.country) NEQ 2>
    <cfset session.m = "The Country Code must be exactly 2 characters">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <!--- Validate common name --->
  <cfif trim(form.commonname) is "">
    <cfset session.m = "The Common Name cannot be blank">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfif REFind("[^A-Za-z0-9\.\-\*@]", form.commonname) GT 0>
    <cfset session.m = "Invalid Common Name. Only letters, numbers, dashes, periods, and asterisks allowed">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <!--- Validate encryption --->
  <cfif NOT ListFindNoCase("2048,4096", form.encryption)>
    <cfset session.m = "Invalid encryption length">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <!--- Validate algorithm --->
  <cfif NOT ListFindNoCase("sha256,sha384,sha512", form.algorithm)>
    <cfset session.m = "Invalid algorithm">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <!--- Cert purpose (#244). Informational only -- SAN sanitization is the
       same either way (CN auto-prepended for CAB Forum compliance). Kept
       for future use (telemetry / audit log of generated CSRs). --->
  <cfparam name="form.cert_purpose" default="mailbox">
  <cfif NOT ListFindNoCase("server,mailbox", form.cert_purpose)>
    <cfset form.cert_purpose = "mailbox">
  </cfif>

  <!--- Sanitize the SAN list (#243). The textarea is newline-separated.
       Per line: trim, lowercase, allow [a-z0-9.\-\*] (same chars as
       the CN validation above), reject anything else. Dedupe, and
       auto-prepend the CN so the cert always covers CN-as-SAN per
       CAB Forum baseline rules. --->
  <cfparam name="form.sans" default="">
  <cfset sanRaw = form.sans>
  <cfset sanClean = ArrayNew(1)>
  <cfset cnLower = LCase(trim(form.commonname))>
  <cfset ArrayAppend(sanClean, cnLower)>

  <cfloop list="#sanRaw#" index="oneSan" delimiters="#chr(10)#">
    <cfset oneSan = LCase(trim(ReplaceList(oneSan, chr(13), "")))>
    <cfif Len(oneSan) EQ 0>
      <cfcontinue>
    </cfif>
    <cfif REFind("[^a-z0-9\.\-\*]", oneSan) GT 0>
      <cfset session.m = "Invalid SAN entry '" & oneSan & "'. Only letters, numbers, dashes, periods, and asterisks allowed.">
      <cfset session.alerttype = "error">
      <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfif>
    <cfif NOT ArrayFind(sanClean, oneSan)>
      <cfset ArrayAppend(sanClean, oneSan)>
    </cfif>
  </cfloop>

  <cfset form.sans = ArrayToList(sanClean, chr(10))>

  <cfinclude template="./generate_csr.cfm">

<cfelseif action is "deletecertificate">

  <cfif NOT StructKeyExists(form, "certificate_id") OR NOT isValid("integer", form.certificate_id)>
    <cfset session.m = "Invalid certificate ID">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <!--- Cannot delete system-self-signed --->
  <cfif form.certificate_id is "1">
    <cfset session.m = "You cannot delete the system-self-signed certificate">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfquery name="getcertificate" datasource="hermes">
    SELECT id FROM system_certificates WHERE id = <cfqueryparam value="#form.certificate_id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfif getcertificate.recordcount LT 1>
    <cfset session.m = "Certificate not found">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfinclude template="./delete_system_certificate.cfm">

  <cfset session.m = "Certificate deleted successfully">
  <cfset session.alerttype = "success">
  <cflocation url="view_system_certificates.cfm" addtoken="no">

<cfelseif action is "requestacme">

  <!--- Pro Edition License Check --->
  <cfinclude template="./license_check.cfm">

  <!--- Validate certificate name --->
  <cfif NOT StructKeyExists(form, "certificate_name") OR trim(form.certificate_name) is "">
    <cfset session.m = "The Certificate Name field cannot be blank">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfif REFind("[^_a-zA-Z0-9\-\_\.]", form.certificate_name) GT 0>
    <cfset session.m = "Invalid Certificate Name. Only letters, numbers, dashes, underscores, and periods allowed">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfquery name="checkcertname" datasource="hermes">
    SELECT friendly_name FROM system_certificates
    WHERE friendly_name LIKE BINARY <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.certificate_name#">
  </cfquery>

  <cfif checkcertname.recordcount GTE 1>
    <cfset session.m = "The Certificate Name already exists. Please choose a different name">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <!--- Validate domain name --->
  <cfif NOT StructKeyExists(form, "domainname") OR trim(form.domainname) is "">
    <cfset session.m = "The Domain Name cannot be blank">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfset testDomain = "bob@#form.domainname#">
  <cfif NOT IsValid("email", testDomain)>
    <cfset session.m = "The Domain Name is invalid">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <!--- Validate email --->
  <cfif NOT StructKeyExists(form, "email") OR NOT IsValid("email", form.email)>
    <cfset session.m = "The Notifications E-mail address is invalid">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <!--- Validate acme server --->
  <cfif NOT StructKeyExists(form, "acmeserver") OR NOT ListFindNoCase("staging,production", form.acmeserver)>
    <cfset session.m = "Invalid ACME server selection">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfinclude template="./acme_request_certificate.cfm">

<cfelseif action is "importcertificate">

  <!--- Validate certificate name --->
  <cfif NOT StructKeyExists(form, "certificate_name") OR trim(form.certificate_name) is "">
    <cfset session.m = "The Certificate Name field cannot be blank">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfif REFind("[^_a-zA-Z0-9\-\_\.]", form.certificate_name) GT 0>
    <cfset session.m = "Invalid Certificate Name. Only letters, numbers, dashes, underscores, and periods allowed">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfquery name="checkcertname" datasource="hermes">
    SELECT friendly_name FROM system_certificates
    WHERE friendly_name LIKE BINARY <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.certificate_name#">
  </cfquery>

  <cfif checkcertname.recordcount GTE 1>
    <cfset session.m = "The Certificate Name already exists. Please choose a different name">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <!--- Validate PEM fields --->
  <cfif NOT StructKeyExists(form, "certificate") OR trim(form.certificate) is "">
    <cfset session.m = "The Certificate field cannot be blank">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfif NOT StructKeyExists(form, "key") OR trim(form.key) is "">
    <cfset session.m = "The Unencrypted Key field cannot be blank">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfif NOT StructKeyExists(form, "chain") OR trim(form.chain) is "">
    <cfset session.m = "The Root and Intermediate CA Certificates field cannot be blank">
    <cfset session.alerttype = "error">
    <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfif>

  <cfinclude template="./import_system_certificate.cfm">

</cfif>
