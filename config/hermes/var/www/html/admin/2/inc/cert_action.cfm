<!---
Hermes Secure Email Gateway - System Certificates Action Handler
Routes to generate CSR, delete certificate, request ACME, or import certificate.
--->

<cfif action is "generatecsr">

  <!--- Validate required fields. commonname is conditional (mailbox certs
       auto-derive it from the mailbox_domain + first additional_sans prefix
       per #247) so it's checked separately below. --->
  <cfloop list="country,state,locality,organization,department,encryption,algorithm" index="f">
    <cfif NOT StructKeyExists(form, f)>
      <cfset session.m = "Generate CSR: form.#f# does not exist">
      <cfset session.alerttype = "error">
      <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfif>
  </cfloop>
  <cfparam name="form.commonname" default="">

  <!--- Validate country code (2 chars) --->
  <cfif Len(form.country) NEQ 2>
    <cfset session.m = "The Country Code must be exactly 2 characters">
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

  <!--- Cert purpose (#244 / #246). Server vs Mailbox drives the
       mandatory-SAN expansion below + the CN derivation strategy. --->
  <cfparam name="form.cert_purpose" default="mailbox">
  <cfif NOT ListFindNoCase("server,mailbox", form.cert_purpose)>
    <cfset form.cert_purpose = "mailbox">
  </cfif>

  <!--- Mailbox domain (#246). Required when cert_purpose=mailbox; ignored
       for server certs. Sanitize same as CN. The mandatory autoconfig +
       autodiscover + custom-prefix SANs are derived from this domain. --->
  <cfparam name="form.mailbox_domain" default="">
  <cfset mailboxDomainClean = LCase(trim(form.mailbox_domain))>
  <cfif form.cert_purpose IS "mailbox">
    <cfif Len(mailboxDomainClean) EQ 0>
      <cfset session.m = "Generate CSR: Mailbox domain is required when generating a mailbox certificate.">
      <cfset session.alerttype = "error">
      <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfif>
    <cfif REFind("[^a-z0-9\.\-]", mailboxDomainClean) GT 0>
      <cfset session.m = "Generate CSR: Invalid mailbox domain. Only letters, numbers, dashes, and periods are allowed.">
      <cfset session.alerttype = "error">
      <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfif>
  </cfif>

  <!--- Fetch SAN prefixes once -- used for both CN derivation (mailbox)
       and the mandatory-SAN expansion (mailbox). Sorted alphabetically;
       index 0 is the prefix that also becomes the CN. --->
  <cfquery name="getMandatoryPrefixes" datasource="hermes">
    SELECT san FROM additional_sans ORDER BY san
  </cfquery>

  <!--- CN derivation (#247). For mailbox certs, the CN is auto-derived
       as <first-prefix>.<mailbox_domain> -- matches Pro ACME's
       first-`-d`-flag behavior (inc/acme_request_san_certificate.cfm)
       so the resulting cert is byte-for-byte identical to Pro Auto mode.
       For server certs, the admin-supplied form.commonname stands. --->
  <cfif form.cert_purpose IS "mailbox">
    <cfif getMandatoryPrefixes.recordcount EQ 0>
      <cfset session.m = "Generate CSR: No SAN prefixes configured in SAN Management. Cannot generate a mailbox certificate without at least autoconfig + autodiscover.">
      <cfset session.alerttype = "error">
      <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfif>
    <cfset form.commonname = LCase(getMandatoryPrefixes.san[1]) & "." & mailboxDomainClean>
  </cfif>

  <!--- Validate the (now-resolved) CN -- blank check + char check apply
       to both auto-derived (mailbox) and admin-supplied (server) CNs. --->
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

  <!--- Build the final SAN list. Order:
         1. CN (always, CAB Forum requires CN-as-SAN since 2017). For
            mailbox certs this IS the first mandatory prefix.<domain>.
         2. Mandatory SANs for mailbox certs: remaining <prefix>.<domain>
            entries from additional_sans. Non-negotiable.
         3. Admin-supplied "Additional SANs" textarea entries, sanitized
            per line and deduped against the above.
       Per line: trim, lowercase, allow [a-z0-9.\-\*]. Dedupe is silent:
       if admin types one of the mandatory SANs, it's dropped without
       error. --->
  <cfparam name="form.sans" default="">
  <cfset sanClean = ArrayNew(1)>
  <cfset cnLower = LCase(trim(form.commonname))>
  <cfset ArrayAppend(sanClean, cnLower)>

  <cfif form.cert_purpose IS "mailbox">
    <cfloop query="getMandatoryPrefixes">
      <cfset mandatoryFqdn = LCase(getMandatoryPrefixes.san) & "." & mailboxDomainClean>
      <cfif NOT ArrayFind(sanClean, mandatoryFqdn)>
        <cfset ArrayAppend(sanClean, mandatoryFqdn)>
      </cfif>
    </cfloop>
  </cfif>

  <!--- Process Additional SANs textarea (#247 cont.). For mailbox certs,
       smart-expand bare prefixes (no dot) against the mailbox domain so
       the admin doesn't have to retype it for each entry. Full FQDNs
       (has dot) pass through as-is, supporting cross-domain vanity SANs.
       For server certs, only FQDNs are accepted (no mailbox domain to
       attach a bare prefix to). --->
  <cfloop list="#form.sans#" index="oneSan" delimiters="#chr(10)#">
    <cfset oneSan = LCase(trim(ReplaceList(oneSan, chr(13), "")))>
    <cfif Len(oneSan) EQ 0>
      <cfcontinue>
    </cfif>
    <cfif REFind("[^a-z0-9\.\-\*]", oneSan) GT 0>
      <cfset session.m = "Invalid Additional SAN entry '" & oneSan & "'. Only letters, numbers, dashes, periods, and asterisks allowed.">
      <cfset session.alerttype = "error">
      <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfif>
    <cfif form.cert_purpose IS "mailbox" AND REFind("\.", oneSan) EQ 0>
      <!--- Bare prefix on mailbox cert: smart-expand against mailbox_domain. --->
      <cfset oneSan = oneSan & "." & mailboxDomainClean>
    <cfelseif REFind("\.", oneSan) EQ 0>
      <!--- Bare prefix on server cert: no mailbox domain to attach to,
           reject and route the admin to the right field. --->
      <cfset session.m = "Invalid Additional SAN entry '" & oneSan & "'. Server certs require fully-qualified domain names (e.g. admin.widgets.tld), not bare prefixes.">
      <cfset session.alerttype = "error">
      <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfif>
    <cfif NOT ArrayFind(sanClean, oneSan)>
      <cfset ArrayAppend(sanClean, oneSan)>
    </cfif>
  </cfloop>

  <cfset form.sans = ArrayToList(sanClean, chr(10))>

  <cfinclude template="./generate_csr.cfm">

<cfelseif action is "discardcsr">

  <!--- Discard the pending CSR bundle (#249). Clears session.customtrans
       AND deletes the .rar from /opt/hermes/tmp so the persistent
       "Pending CSR" callout disappears on next render. Idempotent. --->
  <cfif StructKeyExists(session, "customtrans") AND Len(session.customtrans) GT 0>
    <cfset discardRar = "/opt/hermes/tmp/" & session.customtrans & "_csr_key.rar">
    <cfif fileExists(discardRar)>
      <cffile action="delete" file="#discardRar#">
    </cfif>
    <cfset session.customtrans = "">
  </cfif>
  <cflocation url="view_system_certificates.cfm" addtoken="no">

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
