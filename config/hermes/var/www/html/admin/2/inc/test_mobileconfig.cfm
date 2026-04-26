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
      ?email=bob@deeztek.com
      &display=Bob+Smith
      &imap=<actual-imap-password>
      &dav=<actual-dav-password>
      &host=mail.deeztek.com
      [&inline=1]            <- show in browser instead of downloading

Without `inline=1` the response sets Content-Type to
application/x-apple-aspen-config and Content-Disposition: attachment,
which makes the browser download a .mobileconfig file. Open that file
on an iPhone (AirDrop, email it to yourself, etc.) to test install.

NOT FOR PRODUCTION USE. Phase 2 replaces this with a token-protected
endpoint behind the wizard.
--->

<cfparam name="url.email"   default="">
<cfparam name="url.display" default="">
<cfparam name="url.imap"    default="">
<cfparam name="url.dav"     default="">
<cfparam name="url.host"    default="">
<cfparam name="url.inline"  default="0">

<!--- Quick guard: must have all required params --->
<cfif url.email EQ "" OR url.imap EQ "" OR url.dav EQ "" OR url.host EQ "">
    <cfcontent reset="true">
    <cfheader name="Content-Type" value="text/plain; charset=utf-8">
    <cfoutput>test_mobileconfig.cfm — missing required URL params.

Required: email, imap, dav, host
Optional: display (defaults to email), inline=1 (display XML in browser instead of downloading)

Example:
  ?email=bob@deeztek.com&display=Bob+Smith&imap=secret&dav=secret&host=mail.deeztek.com

Phase 1 of #224. Hand-invoke for DEV testing only.</cfoutput>
    <cfabort>
</cfif>

<!--- Map URL params → generator's expected variable names --->
<cfset mcUserEmail    = Trim(url.email)>
<cfset mcDisplayName  = Trim(url.display)>
<cfset mcImapPassword = url.imap>
<cfset mcDavPassword  = url.dav>
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

<!--- On success, either inline-display or trigger a download --->
<cfif url.inline EQ "1">
    <cfcontent reset="true">
    <cfheader name="Content-Type" value="text/plain; charset=utf-8">
    <cfoutput>#mcXml#</cfoutput>
<cfelse>
    <cfcontent reset="true" type="application/x-apple-aspen-config; charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=""hermes-#LCase(mcUserEmail)#.mobileconfig""">
    <cfoutput>#mcXml#</cfoutput>
</cfif>
