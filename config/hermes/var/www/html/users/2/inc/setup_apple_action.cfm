<!---
SETUP DEVICES — APPLE BRANCH ACTION HANDLER (#224 Phase 2c)

Thin wrapper around generate_mobile_setup_token.cfm (the shared
mint+sign+stage helper). This handler runs when the user submits the
"Generate Setup Profile" form on the Apple branch of the wizard. The
helper does all five steps (NC oc_authtoken, doveadm hash, INSERT
app_passwords, generate+sign mobileconfig, INSERT mobile_setup_tokens)
and returns either a token (on success) or a friendly error message.

On success: cflocation to the result page so the user sees the QR /
download UI with the just-staged token.

On any failure: set session.setupDevicesError and session.m=60, redirect
back to the wizard's Apple page so the parent template renders the
error banner. The helper does NOT roll back on partial failures — if
the app password row was already created and a later step failed, the
user can revoke it from My App Passwords.
--->

<cfparam name="form.label"        default="">
<cfparam name="form.display_name" default="">

<cfset mstOwnerEmail   = session.email>
<cfset mstLabel        = Trim(form.label)>
<cfset mstDisplayName  = Trim(form.display_name)>
<cfinclude template="../../../admin/2/inc/generate_mobile_setup_token.cfm">

<cfif mstResult NEQ "success">
    <cfset session.setupDevicesError = mstError>
    <cfset session.m = 60>
    <cflocation url="setup_devices.cfm?device=apple" addtoken="no">
</cfif>

<cflocation url="setup_devices.cfm?device=apple-result&token=#mstToken#" addtoken="no">
