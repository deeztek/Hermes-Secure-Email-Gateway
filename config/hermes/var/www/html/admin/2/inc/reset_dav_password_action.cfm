
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
RESET DAV PASSWORD (NC APP PASSWORD) FOR A REMOTE-AUTH MAILBOX
Regenerates the "Hermes System" app password for the given mailbox,
invalidating any existing DAV clients using the previous token, and
returns the new plaintext via session so view_mailboxes.cfm can show
it in a one-time callout. The password is NOT emailed — admin delivers
out-of-band.

Only valid for remote-auth mailboxes with NC enabled. Local-auth
mailboxes don't use this token (their DAV works with the email
password directly), so we refuse with a benign error for them.
--->

<cfif NOT StructKeyExists(form, "reset_mailbox_id") OR NOT IsNumeric(form.reset_mailbox_id)>
    <cfset session.m = 20>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfquery name="getMailboxReset" datasource="hermes">
    SELECT m.id, m.username, m.nextcloud_enabled, r.auth_type
    FROM mailboxes m
    LEFT JOIN recipients r ON r.recipient = m.username
    WHERE m.id = <cfqueryparam value="#form.reset_mailbox_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getMailboxReset.recordcount LT 1>
    <cfset session.m = 21>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfif getMailboxReset.auth_type NEQ "remote">
    <cfset session.m = 40>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfif Val(getMailboxReset.nextcloud_enabled) NEQ 1>
    <cfset session.m = 41>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfset ncAppPasswordAction = "regenerate">
<cfset ncAppPasswordUser = getMailboxReset.username>
<cfinclude template="nextcloud_app_password.cfm">

<cfif ncAppPasswordResult EQ "success" AND Len(ncAppPassword) GT 0>
    <cfset session.resetDavUsername = getMailboxReset.username>
    <cfset session.resetDavPassword = ncAppPassword>
    <cfset session.m = 42>
<cfelse>
    <cfset session.resetDavError = ncAppPasswordResult & " / " & Left(ncAppPasswordError, 200)>
    <cfset session.m = 43>
</cfif>

<cflocation url="view_mailboxes.cfm" addtoken="no">
