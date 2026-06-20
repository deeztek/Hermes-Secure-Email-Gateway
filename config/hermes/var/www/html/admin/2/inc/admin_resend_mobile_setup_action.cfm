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
ADMIN — RESEND MOBILE SETUP PROFILE (#224 Phase 2c)

Server-side counterpart to the user-portal Apple wizard, for the case
where an admin wants to push a fresh setup profile to a user without
that user having to log in to /users themselves. Common scenarios:

  - User can't reach the portal but can read email
  - User is non-technical and needs a "click here to install" link
  - User onboarding flow where a desk-set tech preps the profile then
    hands the phone back to the user

Calls the shared mint+sign+stage helper (generate_mobile_setup_token.cfm),
then emails the user with the result-page URL. The token's
user_email = the mailbox owner (NOT the admin), so the
session-ownership check in get_mobileconfig.cfm protects the file
from being fetched by the admin's session.

The label on the just-minted app password is auto-generated
("Mobile setup <YYYY-MM-DD>") so the user can later see and revoke
it from My App Passwords. If the admin clicks Resend twice on the
same day, two rows show up with the same label — that's fine, both
revocable independently.
--->

<cfparam name="form.mailbox_id" default="">

<!--- Validate mailbox id --->
<cfif NOT IsNumeric(form.mailbox_id)>
    <cfset session.m = 81>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfquery name="_arsmGetMailbox" datasource="hermes">
    SELECT id, username, name
    FROM mailboxes
    WHERE id = <cfqueryparam value="#form.mailbox_id#" cfsqltype="cf_sql_integer">
      AND mailbox_type = 'user'
      AND active = 1
</cfquery>

<cfif _arsmGetMailbox.recordcount NEQ 1>
    <cfset session.m = 81>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfset _arsmTargetEmail   = _arsmGetMailbox.username>
<cfset _arsmTargetName    = (Len(Trim(_arsmGetMailbox.name)) GT 0) ? Trim(_arsmGetMailbox.name) : _arsmTargetEmail>
<cfset _arsmLabel         = "Mobile setup " & DateFormat(Now(), "yyyy-mm-dd")>

<!--- Run the shared helper. mstOwnerEmail is the mailbox owner, NOT
     the admin's session.email — the helper accepts the owner as a
     parameter so the same code path covers both wizards. --->
<cfset mstOwnerEmail   = _arsmTargetEmail>
<cfset mstLabel        = _arsmLabel>
<cfset mstDisplayName  = _arsmTargetName>
<cfinclude template="generate_mobile_setup_token.cfm">

<cfif mstResult NEQ "success">
    <cfset session.adminResendError = mstError>
    <cfset session.m = 82>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<!--- Resolve the canonical host for the result-page URL. The helper
     already validated console.host exists, so this query is just to
     pull the value back into wrapper scope. --->
<cfquery name="_arsmHostQ" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'console' AND parameter = 'console.host'
</cfquery>

<cfset _arsmResultUrl = "https://" & Trim(_arsmHostQ.value2) & "/users/2/setup_devices.cfm?device=apple-result&token=" & mstToken>

<!--- Email the user with the link. send_mobile_setup_email.cfm
     consumes _arsmTargetEmail / _arsmTargetName / _arsmResultUrl. --->
<cftry>
    <cfinclude template="send_mobile_setup_email.cfm">
<cfcatch type="any">
    <cfset session.adminResendError = "Profile generated but email could not be sent: " & cfcatch.message>
    <cfset session.m = 83>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfcatch>
</cftry>

<cfset session.adminResendTarget = _arsmTargetEmail>
<cfset session.m = 80>
<cflocation url="view_mailboxes.cfm" addtoken="no">
