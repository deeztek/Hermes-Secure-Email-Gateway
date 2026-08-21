
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

  <cfinclude template="docker_get_directory.cfm">
  <cfinclude template="generate_customtrans.cfm">

<!--- acmeOutput is the contract with the caller (schedule/acme_validate_ip.cfm
     reads it immediately after this include). Set it first so that every exit
     path below, including the guards, leaves the caller something to record. --->
<cfset acmeOutput = "">

<!--- ACME ACCOUNT FLAGS.

     certbot registers an account on its first run against an endpoint. Without
     --agree-tos it stops to ask, and with no TTY it dies on EOFError before it
     ever attempts a challenge. The manual single-domain path
     (acme_request_certificate.cfm) has always passed --email/--agree-tos/
     --no-eff-email. This automated path never did, so it could only ever work
     on a box where the manual path had already registered an account. On a
     fresh install, where adding a mailbox domain is usually the first ACME
     action, it failed every time and, because the failure went to stderr, it
     failed invisibly.

     admin_email ships as the placeholder someone@otherdomain.tld
     (config/database/hermes_install.sql) and nothing outside the console ever
     writes it, so it is only used when it is a real address. Otherwise
     register without one: an ACME account is tied to its contact address and
     is awkward to correct later, so a missing address beats a fictional one.
     Let's Encrypt supports this explicitly. --->
<cfquery name="getacmeadminemail" datasource="hermes">
  SELECT value FROM system_settings WHERE parameter = 'admin_email'
</cfquery>

<cfset acmeAccountEmail = "">
<cfif getacmeadminemail.recordcount GTE 1>
  <cfset acmeAccountEmail = Trim(getacmeadminemail.value)>
</cfif>

<!--- Seed placeholders from hermes_install.sql. Never register against these. --->
<cfset acmePlaceholderEmails = "someone@otherdomain.tld,someone@domain.tld,postmaster@domain.tld,admin@domain.tld">

<cfset acmeAccountNote = "">
<cfif Len(acmeAccountEmail)
      AND IsValid("email", acmeAccountEmail)
      AND ListFindNoCase(acmePlaceholderEmails, acmeAccountEmail) EQ 0>
  <cfset acmeAccountFlags = "--non-interactive --agree-tos --no-eff-email -m " & acmeAccountEmail>
<cfelse>
  <cfset acmeAccountFlags = "--non-interactive --agree-tos --no-eff-email --register-unsafely-without-email">
  <cfset acmeAccountNote = "NOTE: registered without a contact address. Set a real Admin E-mail in System Settings to receive expiry warnings.">
</cfif>

<!--- A blank certificate name means the mailbox_sans row points at a
     system_certificates row that no longer exists. Requesting with an empty
     --cert-name makes certbot swallow the next flag as the lineage name.
     Stop here and say so instead. --->
<cfif NOT Len(Trim(theCertname))>

  <cfset acmeOutput = "ERROR: no certificate name. The SAN rows reference a certificate that no longer exists; delete the orphaned rows or rebind the mailbox domain.">

<cfelse>

<!--- Run through a temp script with 2>&1, the pattern used everywhere else in
     this codebase that shells out (see nextcloud_provision_user.cfm).

     certbot writes its failures to stderr. Running docker directly with only
     outputFile and no errorVariable meant Lucee threw on any failure, so the
     catch fired, mailed, and aborted the entire scheduled job without
     recording anything anywhere. A certbot SUCCESS was the only outcome this
     code could observe. Capturing both streams makes a failure a value rather
     than an exception. --->
<cfset acmeScript = "/opt/hermes/tmp/" & customtrans3 & "_request_cert.sh">

<cfscript>
    fileWrite(acmeScript,
        chr(35) & '!/bin/bash' & chr(10) &
        '/usr/local/bin/docker run --rm --name hermes_certbot --network host' &
        ' --dns 8.8.8.8 --dns 8.8.4.4' &
        ' -v ' & DockerDir & '/config/hermes/var/www/html:/var/www/certbot' &
        ' -v ' & DockerDir & '/config/certbot/conf:/etc/letsencrypt' &
        ' -v ' & DockerDir & '/config/certbot/logs:/var/log' &
        ' certbot/certbot:latest certonly --webroot --webroot-path /var/www/certbot' &
        ' ' & acmeAccountFlags &
        ' --cert-name "' & Trim(theCertname) & '"' &
        ' --expand ' & Trim(theSan) &
        ' 2>&1' & chr(10),
        "utf-8");
</cfscript>

<cfexecute name="/bin/chmod" arguments="+x #acmeScript#" timeout="10" />

<cfset acmeStdErr = "">

<cftry>

  <!--- 300s rather than 120s: a cold certbot/certbot image is pulled before
       the run begins, and a Lucee cfexecute timeout throws rather than
       returning the output it had collected so far. --->
  <cfexecute name = "#acmeScript#"
    variable = "acmeOutput"
    errorVariable = "acmeStdErr"
    timeout = "300">
  </cfexecute>

  <cfcatch type="any">
    <!--- Deliberately no operator e-mail here. Ofelia runs this every 30
         minutes, so mailing each failure reproduces the notifier flood fixed
         in v260723. The reason is recorded on the SAN rows by the caller and
         shown on the Certificates page instead. --->
    <cfset acmeOutput = "ERROR: could not run certbot. " & cfcatch.message & " " & cfcatch.detail>
  </cfcatch>

</cftry>

<cfif Len(Trim(acmeStdErr))>
  <cfset acmeOutput = Trim(acmeOutput) & chr(10) & Trim(acmeStdErr)>
</cfif>

<cfset acmeOutput = Trim(acmeOutput)>

<cfif Len(acmeAccountNote) AND NOT FindNoCase("Successfully received certificate", acmeOutput)>
  <cfset acmeOutput = acmeOutput & chr(10) & acmeAccountNote>
</cfif>

<!--- Clean up. The previous version wrote a _request_cert file it never
     executed and never deleted, and its _acme_output deletion was commented
     out, so every attempt left two files behind in /opt/hermes/tmp. --->
<cftry>
  <cffile action="delete" file="#acmeScript#">
  <cfcatch type="any"></cfcatch>
</cftry>

<!--- /CFIF NOT Len(Trim(theCertname)) --->
</cfif>
