<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition.
Distributed under the GNU AGPL v3 (or later). See https://www.gnu.org/licenses/agpl.html.
--->

<!---
TEST HARNESS for generate_mobileconfig.cfm  (Phase 1 of #224)

Hand-invoke during DEV testing. Lets us verify the generator produces
valid Apple plist XML that iOS will accept, before the wizard UI exists.

Usage from a browser (admin UI session, after Authelia login):

  /admin/2/inc/test_mobileconfig.cfm
      ?email=bob@domain.tld
      &display=Bob+Smith
      &imap=<actual-imap-password>
      &dav=<actual-dav-password>
      &host=mail.domain.tld
      [&inline=1]            <- show in browser instead of downloading

Without `inline=1` the response sets Content-Type to
application/x-apple-aspen-config and Content-Disposition: attachment,
which makes the browser download a .mobileconfig file. Open that file
on an iPhone (AirDrop, email it to yourself, etc.) to test install.

NOT FOR PRODUCTION USE. Phase 2 replaces this with a token-protected
endpoint behind the wizard.
--->

<cfparam name="url.email"    default="">
<cfparam name="url.display"  default="">
<cfparam name="url.password" default="">
<cfparam name="url.host"     default="">
<cfparam name="url.inline"   default="0">

<!--- Quick guard: must have all required params --->
<cfif url.email EQ "" OR url.password EQ "" OR url.host EQ "">
    <cfcontent reset="true">
    <cfheader name="Content-Type" value="text/plain; charset=utf-8">
    <cfoutput>test_mobileconfig.cfm — missing required URL params.

Required: email, password (single app password — used for IMAP/SMTP/CalDAV/CardDAV per ##197 Phase 1b), host
Optional: display (defaults to email), inline=1 (display XML in browser instead of downloading)

Example:
  ?email=bob@domain.tld&display=Bob+Smith&password=APP-PASSWORD&host=mail.domain.tld

##224 Phase 2 hand-invoke harness for DEV testing only. Will be
superseded by the user-portal wizard.</cfoutput>
    <cfabort>
</cfif>

<!--- Map URL params → generator's expected variable names --->
<cfset mcUserEmail    = Trim(url.email)>
<cfset mcDisplayName  = Trim(url.display)>
<cfset mcAppPassword  = url.password>
<cfset mcMailHost     = Trim(url.host)>

<cfinclude template="generate_mobileconfig.cfm">

<cfif mcResult NEQ "success">
    <cfcontent reset="true">
    <cfheader name="Content-Type" value="text/plain; charset=utf-8">
    <cfoutput>generate_mobileconfig.cfm reported failure:

result: #mcResult#
detail: #mcError#
</cfoutput>
    <cfabort>
</cfif>

<!--- On success, either inline-display or trigger a download. When
     signed, return the binary CMS envelope; otherwise fall back to
     the raw XML. --->
<cfif url.inline EQ "1">
    <cfcontent reset="true">
    <cfheader name="Content-Type" value="text/plain; charset=utf-8">
    <cfoutput>signing note: #mcSigningNote#

#mcXml#</cfoutput>
<cfelseif mcIsSigned>
    <cfheader name="Content-Disposition" value="attachment; filename=""hermes-#LCase(mcUserEmail)#.mobileconfig""">
    <cfcontent reset="true" type="application/x-apple-aspen-config" variable="mcSignedBytes">
<cfelse>
    <cfcontent reset="true" type="application/x-apple-aspen-config; charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=""hermes-#LCase(mcUserEmail)#.mobileconfig""">
    <cfoutput>#mcXml#</cfoutput>
</cfif>
