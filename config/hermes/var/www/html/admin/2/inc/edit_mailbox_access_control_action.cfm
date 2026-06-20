
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
RESET 2FA DEVICES ACTION HANDLER (#225 Phase 1.5)

Was previously the "edit access control" handler with a one_factor /
two_factor radio. That radio is gone — the canonical admin policy
surface is the enforce_mfa checkbox in Edit Options, and LDAP group
membership is driven by the user's own toggle in user_settings.cfm.

Two modes:
- DEFAULT: clear TOTP and WebAuthn devices in Authelia so the user
  re-registers on next sign-in. "User lost their phone" recovery.
- NUCLEAR (form.also_remove_from_two_factor=1): also remove the user
  from cn=two_factor LDAP group, moving them back to cn=one_factor.
  Forces the user out of 2FA regardless of whether they self-enrolled
  before. Used for admin override of a voluntary enrollment, or full
  account reset. The per-mailbox enforce_mfa policy is left alone —
  if it's still 1, the user re-enters the bootstrap flow on next
  portal visit.

(Form action name kept as "edit_mailbox_access_control" so the
view_mailboxes.cfm dispatcher and modal markup don't need a rename
cascade. Filename / dispatcher renaming is a future cleanup.)
--->

<!--- VALIDATE MAILBOX ID --->
<cfif NOT StructKeyExists(form, "mailbox_id") OR NOT IsNumeric(form.mailbox_id)>
    <cfset session.m = 20>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- VALIDATE RECIPIENT EMAIL --->
<cfif NOT StructKeyExists(form, "recipient_email") OR trim(form.recipient_email) EQ "">
    <cfset session.m = 20>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfset recipientEmail = trim(form.recipient_email)>

<!--- VERIFY MAILBOX EXISTS --->
<cfquery name="getMailbox" datasource="hermes">
    SELECT m.id, m.username FROM mailboxes m
    WHERE m.id = <cfqueryparam value="#form.mailbox_id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfif getMailbox.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- GET LDAP USERNAME (for Authelia CLI calls) --->
<cfparam name="form.ldap_username" default="">
<cfset ldapUsername = form.ldap_username>
<cfif ldapUsername EQ "">
    <cfset ldapUsername = LCase(recipientEmail)>
</cfif>

<!--- DELETE TOTP DEVICES via Authelia CLI. Failure is non-critical
     (e.g., user had no TOTP enrolled — Authelia returns non-zero); the
     UI still reports success because the desired end-state ("no TOTP
     devices") is achieved either way. --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_authelia authelia storage user totp delete #ldapUsername# --config /config/configuration.yml"
        variable="totpResult"
        errorVariable="totpError"
        timeout="30">
    </cfexecute>
<cfcatch type="any">
    <!--- Non-critical --->
</cfcatch>
</cftry>

<!--- DELETE WEBAUTHN DEVICES via Authelia CLI. Same non-critical
     handling as TOTP. --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_authelia authelia storage user webauthn delete #ldapUsername# --all --config /config/configuration.yml"
        variable="webauthnResult"
        errorVariable="webauthnError"
        timeout="30">
    </cfexecute>
<cfcatch type="any">
    <!--- Non-critical --->
</cfcatch>
</cftry>

<!--- NUCLEAR OPTION: also remove user from cn=two_factor LDAP group.
     Driven by the opt-in checkbox on the Reset 2FA Devices modal.
     Forces the user out of 2FA enforcement at the LDAP layer
     regardless of whether they self-enrolled before. The
     ldap_change_user_access_control.cfm helper is idempotent on
     benign errors (e.g., user wasn't in two_factor to begin with).
     The per-mailbox enforce_mfa policy is left alone — if it's still
     1, the user re-enters the bootstrap flow on next portal visit. --->
<cfparam name="form.also_remove_from_two_factor" default="0">
<cfif form.also_remove_from_two_factor EQ "1">
    <cftry>
        <cfset ldapOldAccessControl = "two_factor">
        <cfset ldapNewAccessControl = "one_factor">
        <cfinclude template="ldap_change_user_access_control.cfm">
    <cfcatch type="any">
        <!--- Non-critical: device clear above already happened --->
    </cfcatch>
    </cftry>
</cfif>

<!--- SUCCESS --->
<cfset session.m = 5>
<cflocation url="view_mailboxes.cfm" addtoken="no">
