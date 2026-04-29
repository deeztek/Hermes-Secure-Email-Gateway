<!---
SETUP DEVICES — APPLE BRANCH ACTION HANDLER (#224 Phase 2)

Handles form POST when the user clicks "Generate Setup Profile" on the
Apple branch of the Set Up Your Devices wizard. Single-shot flow:

  1. Validate the user-supplied device label
  2. Mint a fresh app password (Phase 1b dual-write into oc_authtoken)
  3. Generate the .mobileconfig with that plaintext, signed via
     openssl cms using the active console cert (skipped if snakeoil)
  4. Serve the .mobileconfig as a download response and cfabort

On any failure: set session.setupDevicesError and session.m=60, redirect
back to the wizard's Apple page so the parent template renders the
error banner. No cleanup of the just-minted app password row on failure
— the user can revoke it from My App Passwords.

The mint logic mirrors the create branch in app_password_actions.cfm
verbatim. Refactoring both into a shared mint_app_password.cfm helper
is a clean follow-up but not blocking — the Apple wizard ships and
the mint logic stays in lockstep with the user-portal create flow
because they're side by side in the same directory.
--->

<cfparam name="form.label" default="">
<cfparam name="form.display_name" default="">

<cfset _setupLabel = Trim(form.label)>
<cfset _setupDisplayName = Trim(form.display_name)>
<cfset _setupUsername = session.email>

<!--- Validate label --->
<cfif _setupLabel EQ "" OR Len(_setupLabel) GT 100>
    <cfset session.setupDevicesError = "Label must be 1–100 characters.">
    <cfset session.m = 60>
    <cflocation url="setup_devices.cfm?device=apple" addtoken="no">
</cfif>

<!--- Resolve mail server hostname from parameters2 — same source as
     the autoconfig.xml endpoint at /autodiscover/autoconfig.cfm. --->
<cfquery name="_setupMailHost" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'console' AND parameter = 'console.host'
</cfquery>

<cfif _setupMailHost.recordcount NEQ 1 OR Trim(_setupMailHost.value2) EQ "">
    <cfset session.setupDevicesError = "console.host parameter is not set on the server. Contact your administrator.">
    <cfset session.m = 60>
    <cflocation url="setup_devices.cfm?device=apple" addtoken="no">
</cfif>

<cfset _setupMailHostValue = Trim(_setupMailHost.value2)>

<!--- 1. Mint NC oc_authtoken first. The helper resets oc_users.password
     as a side effect (defense-in-depth), runs occ user:auth-tokens:add,
     then verifies via SHA-512(plaintext + secret) hash lookup against
     oc_authtoken.token. --->
<cfset ncAppPasswordAction = "create">
<cfset ncAppPasswordUser   = _setupUsername>
<cfset ncAppPasswordName   = _setupLabel>
<cfinclude template="../../../admin/2/inc/nextcloud_app_password.cfm">

<cfif ncAppPasswordResult NEQ "success" OR Len(ncAppPassword) EQ 0>
    <cfset session.setupDevicesError = "Could not create app password in Nextcloud: " & Left(ncAppPasswordError, 200)>
    <cfset session.m = 60>
    <cflocation url="setup_devices.cfm?device=apple" addtoken="no">
</cfif>

<cfset _setupNewPlain = ncAppPassword>
<cfset _setupNcTokenId = ncAppPasswordTokenId>

<!--- 2. Hash via doveadm pw so Dovecot's lua passdb can verify it on
     IMAP/SMTP login. ARGON2ID matches the rest of the table. --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_dovecot doveadm pw -s ARGON2ID -p #_setupNewPlain#"
        variable="_setupHash"
        timeout="60">
    </cfexecute>
    <cfset _setupHash = Trim(_setupHash)>

    <cfif _setupHash EQ "" OR NOT FindNoCase("{ARGON2ID}", _setupHash)>
        <cfthrow message="doveadm pw returned unexpected output: #_setupHash#">
    </cfif>
<cfcatch type="any">
    <cfset session.setupDevicesError = "Could not hash app password via doveadm: " & cfcatch.message>
    <cfset session.m = 60>
    <cflocation url="setup_devices.cfm?device=apple" addtoken="no">
</cfcatch>
</cftry>

<!--- 3. INSERT into Hermes app_passwords with the hash + nc_token_id. --->
<cftry>
    <cfquery datasource="hermes">
        INSERT INTO app_passwords (username, label, password, nc_token_id)
        VALUES (
            <cfqueryparam value="#_setupUsername#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#_setupLabel#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#_setupHash#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#_setupNcTokenId#" cfsqltype="cf_sql_varchar" null="#(_setupNcTokenId EQ '')#">
        )
    </cfquery>
<cfcatch type="any">
    <cfset session.setupDevicesError = "Could not save app password to database: " & cfcatch.message>
    <cfset session.m = 60>
    <cflocation url="setup_devices.cfm?device=apple" addtoken="no">
</cfcatch>
</cftry>

<!--- 4. Generate (and sign) the mobileconfig with the plaintext. --->
<cfset mcUserEmail   = _setupUsername>
<cfset mcDisplayName = (_setupDisplayName EQ "") ? _setupUsername : _setupDisplayName>
<cfset mcAppPassword = _setupNewPlain>
<cfset mcMailHost    = _setupMailHostValue>
<cfinclude template="../../../admin/2/inc/generate_mobileconfig.cfm">

<cfif mcResult NEQ "success">
    <cfset session.setupDevicesError = "Could not generate setup profile: " & mcError>
    <cfset session.m = 60>
    <cflocation url="setup_devices.cfm?device=apple" addtoken="no">
</cfif>

<!--- 5. Serve the file as a download. If signed, send the binary CMS
     envelope; otherwise send the raw XML. Filename includes the user
     and the label so re-installs don't conflict on the device. --->
<cfset _setupSafeLabel = REReplace(_setupLabel, "[^A-Za-z0-9._\-]+", "_", "all")>
<cfset _setupFilename = "hermes-" & LCase(_setupUsername) & "-" & _setupSafeLabel & ".mobileconfig">

<cfheader name="Content-Disposition" value="attachment; filename=""#_setupFilename#""">

<cfif mcIsSigned>
    <cfcontent reset="true" type="application/x-apple-aspen-config" variable="mcSignedBytes">
<cfelse>
    <cfcontent reset="true" type="application/x-apple-aspen-config; charset=utf-8">
    <cfoutput>#mcXml#</cfoutput>
</cfif>

<cfabort>
