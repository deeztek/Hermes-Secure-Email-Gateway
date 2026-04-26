<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!---
GENERATE iOS MOBILECONFIG (Phase 1 — unsigned XML, no token storage)

Builds an Apple .mobileconfig (XML plist) bundling IMAP / SMTP / CalDAV /
CardDAV configuration for one mailbox user. Profile signing is deferred to
a later phase — output here is unsigned plist XML.

Required inputs (caller sets in variables scope):
  - mcUserEmail        : the mailbox's full email (e.g., bob@deeztek.com).
                         Used as username in all four payloads.
  - mcDisplayName      : human-friendly name shown in iOS account list
                         (free text, e.g., "Bob Smith - Deeztek").
  - mcImapPassword     : password to embed in IMAP + SMTP payloads.
                         Local-auth: the user's mailbox password.
                         Remote-auth: their org password (Dovecot's LDAP
                         backend forwards to external AD/LDAP).
  - mcDavPassword      : password to embed in CalDAV + CardDAV payloads.
                         Local-auth: same value as mcImapPassword.
                         Remote-auth: NC app password (DAV can't speak OIDC,
                         so the org password won't work here).
  - mcMailHost         : mail server hostname (Hermes console host).
                         Used for IMAP, SMTP, CalDAV, CardDAV connect.

Outputs:
  - mcXml              : the raw plist XML string on success
  - mcResult           : "success" | "error: <reason>"
  - mcError            : detail message on error

Implementation notes:
  PayloadUUIDs are deterministic per (install-id, user, payload-type) so
  iOS recognizes a re-install as an UPDATE to the existing profile rather
  than a parallel install. We derive a stable id from mcUserEmail for v1;
  full install-id integration comes when wired into the wizard flow.
--->

<cfparam name="mcUserEmail"    default="">
<cfparam name="mcDisplayName"  default="">
<cfparam name="mcImapPassword" default="">
<cfparam name="mcDavPassword"  default="">
<cfparam name="mcMailHost"     default="">

<cfset mcResult = "">
<cfset mcError  = "">
<cfset mcXml    = "">

<!--- Validate inputs --->
<cfif mcUserEmail EQ "" OR NOT IsValid("email", mcUserEmail)>
    <cfset mcResult = "error: mcUserEmail missing or invalid">
    <cfset mcError  = "mcUserEmail must be a valid email address">
    <cfexit>
</cfif>
<cfif mcMailHost EQ "">
    <cfset mcResult = "error: mcMailHost missing">
    <cfset mcError  = "mcMailHost (mail server hostname) must be supplied">
    <cfexit>
</cfif>
<cfif mcImapPassword EQ "" OR mcDavPassword EQ "">
    <cfset mcResult = "error: passwords missing">
    <cfset mcError  = "both mcImapPassword and mcDavPassword must be supplied">
    <cfexit>
</cfif>
<cfif mcDisplayName EQ "">
    <cfset mcDisplayName = mcUserEmail>
</cfif>

<!--- Deterministic UUIDs per (user, payload-type). Lower-case the email
     and SHA-1 it to get a stable hex digest, then format into UUID v5
     style. iOS only requires uniqueness + stability — exact UUID version
     compliance isn't enforced. --->
<cfset emailLower = LCase(Trim(mcUserEmail))>
<cfset toUuid = function(seed) {
    var h = Hash(seed, "SHA");
    return Mid(h, 1, 8)  & "-" &
           Mid(h, 9, 4)  & "-" &
           Mid(h, 13, 4) & "-" &
           Mid(h, 17, 4) & "-" &
           Mid(h, 21, 12);
}>

<cfset profileUuid  = toUuid("hermes-mobileconfig:" & emailLower)>
<cfset mailUuid     = toUuid("hermes-mobileconfig:mail:"     & emailLower)>
<cfset caldavUuid   = toUuid("hermes-mobileconfig:caldav:"   & emailLower)>
<cfset carddavUuid  = toUuid("hermes-mobileconfig:carddav:"  & emailLower)>

<!--- XML escape any user-supplied strings before plist insertion. --->
<cfset esc = function(s) {
    s = Replace(s, "&", "&amp;", "ALL");
    s = Replace(s, "<", "&lt;",  "ALL");
    s = Replace(s, ">", "&gt;",  "ALL");
    return s;
}>

<cfset xUserEmail   = esc(mcUserEmail)>
<cfset xDisplayName = esc(mcDisplayName)>
<cfset xImapPass    = esc(mcImapPassword)>
<cfset xDavPass     = esc(mcDavPassword)>
<cfset xMailHost    = esc(mcMailHost)>

<!--- Build the plist. Indentation matters only for readability; iOS parses
     the XML structurally. Property keys come straight from Apple's
     Configuration Profile Reference (current as of iOS 17+). --->

<cfsavecontent variable="mcXml"><cfoutput><?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>PayloadDisplayName</key>
    <string>Hermes SEG - #xDisplayName#</string>
    <key>PayloadIdentifier</key>
    <string>com.hermesseg.mobileconfig.#emailLower#</string>
    <key>PayloadOrganization</key>
    <string>Hermes SEG</string>
    <key>PayloadDescription</key>
    <string>Configures Mail, Calendar, and Contacts for #xUserEmail#.</string>
    <key>PayloadType</key>
    <string>Configuration</string>
    <key>PayloadUUID</key>
    <string>#profileUuid#</string>
    <key>PayloadVersion</key>
    <integer>1</integer>
    <key>PayloadRemovalDisallowed</key>
    <false/>
    <key>PayloadContent</key>
    <array>

        <!-- Mail account: IMAP receive + SMTP submission -->
        <dict>
            <key>PayloadType</key>
            <string>com.apple.mail.managed</string>
            <key>PayloadVersion</key>
            <integer>1</integer>
            <key>PayloadIdentifier</key>
            <string>com.hermesseg.mobileconfig.mail.#emailLower#</string>
            <key>PayloadUUID</key>
            <string>#mailUuid#</string>
            <key>PayloadDisplayName</key>
            <string>Mail (#xUserEmail#)</string>
            <key>PayloadDescription</key>
            <string>Mail account for #xUserEmail#</string>

            <key>EmailAccountDescription</key>
            <string>#xUserEmail#</string>
            <key>EmailAccountName</key>
            <string>#xDisplayName#</string>
            <key>EmailAccountType</key>
            <string>EmailTypeIMAP</string>
            <key>EmailAddress</key>
            <string>#xUserEmail#</string>

            <!-- Incoming (IMAP, port 993, implicit TLS) -->
            <key>IncomingMailServerHostName</key>
            <string>#xMailHost#</string>
            <key>IncomingMailServerPortNumber</key>
            <integer>993</integer>
            <key>IncomingMailServerUseSSL</key>
            <true/>
            <key>IncomingMailServerAuthentication</key>
            <string>EmailAuthPassword</string>
            <key>IncomingMailServerUsername</key>
            <string>#xUserEmail#</string>
            <key>IncomingPassword</key>
            <string>#xImapPass#</string>

            <!-- Outgoing (SMTP, port 465, implicit TLS via ##210) -->
            <key>OutgoingMailServerHostName</key>
            <string>#xMailHost#</string>
            <key>OutgoingMailServerPortNumber</key>
            <integer>465</integer>
            <key>OutgoingMailServerUseSSL</key>
            <true/>
            <key>OutgoingMailServerAuthentication</key>
            <string>EmailAuthPassword</string>
            <key>OutgoingMailServerUsername</key>
            <string>#xUserEmail#</string>
            <key>OutgoingPasswordSameAsIncomingPassword</key>
            <true/>

            <key>SMIMEEnabled</key>
            <false/>
            <key>PreventMove</key>
            <false/>
            <key>PreventAppSheet</key>
            <false/>
            <key>SMIMEEnablePerMessageSwitch</key>
            <false/>
        </dict>

        <!-- CalDAV account (Nextcloud) -->
        <dict>
            <key>PayloadType</key>
            <string>com.apple.caldav.account</string>
            <key>PayloadVersion</key>
            <integer>1</integer>
            <key>PayloadIdentifier</key>
            <string>com.hermesseg.mobileconfig.caldav.#emailLower#</string>
            <key>PayloadUUID</key>
            <string>#caldavUuid#</string>
            <key>PayloadDisplayName</key>
            <string>Calendar (#xUserEmail#)</string>
            <key>PayloadDescription</key>
            <string>CalDAV account for #xUserEmail#</string>

            <key>CalDAVAccountDescription</key>
            <string>#xUserEmail# Calendar</string>
            <key>CalDAVHostName</key>
            <string>#xMailHost#</string>
            <key>CalDAVPort</key>
            <integer>443</integer>
            <key>CalDAVUseSSL</key>
            <true/>
            <key>CalDAVPrincipalURL</key>
            <string>/nc/remote.php/dav/principals/users/#xUserEmail#/</string>
            <key>CalDAVUsername</key>
            <string>#xUserEmail#</string>
            <key>CalDAVPassword</key>
            <string>#xDavPass#</string>
        </dict>

        <!-- CardDAV account (Nextcloud) -->
        <dict>
            <key>PayloadType</key>
            <string>com.apple.carddav.account</string>
            <key>PayloadVersion</key>
            <integer>1</integer>
            <key>PayloadIdentifier</key>
            <string>com.hermesseg.mobileconfig.carddav.#emailLower#</string>
            <key>PayloadUUID</key>
            <string>#carddavUuid#</string>
            <key>PayloadDisplayName</key>
            <string>Contacts (#xUserEmail#)</string>
            <key>PayloadDescription</key>
            <string>CardDAV account for #xUserEmail#</string>

            <key>CardDAVAccountDescription</key>
            <string>#xUserEmail# Contacts</string>
            <key>CardDAVHostName</key>
            <string>#xMailHost#</string>
            <key>CardDAVPort</key>
            <integer>443</integer>
            <key>CardDAVUseSSL</key>
            <true/>
            <key>CardDAVPrincipalURL</key>
            <string>/nc/remote.php/dav/principals/users/#xUserEmail#/</string>
            <key>CardDAVUsername</key>
            <string>#xUserEmail#</string>
            <key>CardDAVPassword</key>
            <string>#xDavPass#</string>
        </dict>

    </array>
</dict>
</plist>
</cfoutput></cfsavecontent>

<cfset mcResult = "success">
