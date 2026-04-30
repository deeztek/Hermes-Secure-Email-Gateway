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
GENERATE MOBILE SETUP TOKEN — shared mint+sign+stage helper (#224 Phase 2c/2e)

Single source of truth for the five-step pipeline that produces a
token-gated mobileconfig download:

  1. Mint NC oc_authtoken (Phase 1b dual-write) for the mailbox owner
  2. Hash the plaintext via doveadm pw (ARGON2ID) for Dovecot's lua passdb
  3. INSERT into hermes.app_passwords with the hash + nc_token_id
  4. Generate + sign the .mobileconfig (openssl cms via active console cert)
  5. INSERT into hermes.mobile_setup_tokens with the bytes + 30-min expiry

Both the user-portal Apple wizard (users/2/inc/setup_apple_action.cfm)
and the admin "Send setup profile" action (admin/2/inc/
admin_resend_mobile_setup_action.cfm) share this helper. They differ
only in the post-success step: user wizard cflocations the browser to
the result page; admin action emails the URL to the user.

Required inputs:
  - mstOwnerEmail     : full email of the mailbox owner whose profile
                        is being generated (NOT the admin if invoked
                        from the admin path).
  - mstLabel          : 1–100 char label for the new app password.
                        Shown in My App Passwords for revocation.
  - mstDisplayName    : optional display name to embed in the profile;
                        falls back to the owner's email if blank.

Optional inputs:
  - mstExpiryMinutes  : token expiry window. Defaults to 30.

Outputs (set by this include):
  - mstResult       : "success" | "error"
  - mstError        : human-readable error message when result="error"
  - mstToken        : 64-char hex token on success; empty on error
  - mstFilename     : suggested download filename ("hermes-<email>-<label>.mobileconfig")
  - mstAppPasswordPlain : plaintext of the app password just minted
                         (callers may want it for an info message;
                          do NOT log or persist beyond this request)

This helper only stages state — it does NOT serve content, redirect,
or send email. Wrappers handle their own UX flow.
--->

<cfparam name="mstOwnerEmail"    type="string">
<cfparam name="mstLabel"         type="string">
<cfparam name="mstDisplayName"   type="string"  default="">
<cfparam name="mstExpiryMinutes" type="numeric" default="30">

<cfset mstResult           = "error">
<cfset mstError            = "">
<cfset mstToken            = "">
<cfset mstFilename         = "">
<cfset mstAppPasswordPlain = "">

<!--- ===== Validate inputs ===== --->
<cfset _mstOwner        = Trim(mstOwnerEmail)>
<cfset _mstLabel        = Trim(mstLabel)>
<cfset _mstDisplayName  = Trim(mstDisplayName)>

<cfif _mstOwner EQ "" OR REFind("^[^@\s]+@[^@\s]+\.[^@\s]+$", _mstOwner) EQ 0>
    <cfset mstError = "Owner email is missing or invalid.">
    <cfexit method="exitTemplate">
</cfif>

<cfif _mstLabel EQ "" OR Len(_mstLabel) GT 100>
    <cfset mstError = "Label must be 1–100 characters.">
    <cfexit method="exitTemplate">
</cfif>

<!--- ===== Resolve the canonical mail host ===== --->
<cfquery name="_mstHostQ" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'console' AND parameter = 'console.host'
</cfquery>

<cfif _mstHostQ.recordcount NEQ 1 OR Trim(_mstHostQ.value2) EQ "">
    <cfset mstError = "console.host parameter is not set on the server.">
    <cfexit method="exitTemplate">
</cfif>

<cfset _mstMailHost = Trim(_mstHostQ.value2)>

<!--- ===== Step 1: mint NC oc_authtoken =====
     The helper resets oc_users.password as a side effect (defense-in-
     depth), runs occ user:auth-tokens:add, then verifies via
     SHA-512(plaintext + secret) hash lookup against oc_authtoken.token. --->
<cfset ncAppPasswordAction = "create">
<cfset ncAppPasswordUser   = _mstOwner>
<cfset ncAppPasswordName   = _mstLabel>
<cfinclude template="nextcloud_app_password.cfm">

<cfif ncAppPasswordResult NEQ "success" OR Len(ncAppPassword) EQ 0>
    <cfset mstError = "Could not create app password in Nextcloud: " & Left(ncAppPasswordError, 200)>
    <cfexit method="exitTemplate">
</cfif>

<cfset _mstNewPlain  = ncAppPassword>
<cfset _mstNcTokenId = ncAppPasswordTokenId>

<!--- ===== Step 2: hash the plaintext via doveadm pw ===== --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_dovecot doveadm pw -s ARGON2ID -p #_mstNewPlain#"
        variable="_mstHash"
        timeout="60">
    </cfexecute>
    <cfset _mstHash = Trim(_mstHash)>

    <cfif _mstHash EQ "" OR NOT FindNoCase("{ARGON2ID}", _mstHash)>
        <cfthrow message="doveadm pw returned unexpected output: #_mstHash#">
    </cfif>
<cfcatch type="any">
    <cfset mstError = "Could not hash app password via doveadm: " & cfcatch.message>
    <cfexit method="exitTemplate">
</cfcatch>
</cftry>

<!--- ===== Step 3: INSERT into hermes.app_passwords ===== --->
<cftry>
    <cfquery datasource="hermes">
        INSERT INTO app_passwords (username, label, password, nc_token_id)
        VALUES (
            <cfqueryparam value="#_mstOwner#"     cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#_mstLabel#"     cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#_mstHash#"      cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#_mstNcTokenId#" cfsqltype="cf_sql_varchar" null="#(_mstNcTokenId EQ '')#">
        )
    </cfquery>
<cfcatch type="any">
    <cfset mstError = "Could not save app password to database: " & cfcatch.message>
    <cfexit method="exitTemplate">
</cfcatch>
</cftry>

<!--- ===== Step 4: generate + sign the .mobileconfig ===== --->
<cfset mcUserEmail   = _mstOwner>
<cfset mcDisplayName = (_mstDisplayName EQ "") ? _mstOwner : _mstDisplayName>
<cfset mcAppPassword = _mstNewPlain>
<cfset mcMailHost    = _mstMailHost>
<cfinclude template="generate_mobileconfig.cfm">

<cfif mcResult NEQ "success">
    <cfset mstError = "Could not generate setup profile: " & mcError>
    <cfexit method="exitTemplate">
</cfif>

<!--- ===== Step 5: stage in mobile_setup_tokens =====
     Filename includes user + sanitized label so simultaneous tokens
     for two devices on one user don't suggest the same install file. --->
<cfset _mstSafeLabel = REReplace(_mstLabel, "[^A-Za-z0-9._\-]+", "_", "all")>
<cfset _mstFilename  = "hermes-" & LCase(_mstOwner) & "-" & _mstSafeLabel & ".mobileconfig">

<!--- Normalize the payload to bytes for LONGBLOB storage. Signed CMS
     output is binary; raw XML needs UTF-8 encoding. --->
<cfif mcIsSigned>
    <cfset _mstPayloadBytes = mcSignedBytes>
    <cfset _mstContentType  = "application/x-apple-aspen-config">
<cfelse>
    <cfset _mstPayloadBytes = charsetDecode(mcXml, "utf-8")>
    <cfset _mstContentType  = "application/x-apple-aspen-config; charset=utf-8">
</cfif>

<!--- 32 bytes of CSPRNG → 64-char lowercase hex. Same shape the
     download endpoint validates. --->
<cfset _mstTokenBytes = CreateObject("java", "java.security.SecureRandom").init().generateSeed(JavaCast("int", 32))>
<cfset _mstToken      = LCase(BinaryEncode(_mstTokenBytes, "hex"))>

<cftry>
    <cfquery datasource="hermes">
        INSERT INTO mobile_setup_tokens (token, user_email, payload_blob, filename, content_type, expires_at)
        VALUES (
            <cfqueryparam value="#_mstToken#"        cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#_mstOwner#"        cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#_mstPayloadBytes#" cfsqltype="cf_sql_longvarbinary">,
            <cfqueryparam value="#_mstFilename#"     cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#_mstContentType#"  cfsqltype="cf_sql_varchar">,
            DATE_ADD(NOW(), INTERVAL <cfqueryparam value="#mstExpiryMinutes#" cfsqltype="cf_sql_integer"> MINUTE)
        )
    </cfquery>
<cfcatch type="any">
    <cfset mstError = "Could not stage setup profile for download: " & cfcatch.message>
    <cfexit method="exitTemplate">
</cfcatch>
</cftry>

<!--- ===== Success ===== --->
<cfset mstResult           = "success">
<cfset mstToken            = _mstToken>
<cfset mstFilename         = _mstFilename>
<cfset mstAppPasswordPlain = _mstNewPlain>
