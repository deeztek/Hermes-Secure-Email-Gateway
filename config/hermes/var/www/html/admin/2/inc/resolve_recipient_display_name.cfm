
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
WORK OUT A HUMAN NAME FOR AN ADDRESS THAT ALREADY EXISTS

Converting relay recipients to mailboxes in bulk cannot ask the admin for
forty display names, and there is nowhere obvious to read them from: the
recipients table has no name column of any kind.

They are on file all the same. Auto provisioning records display_name,
first_name and last_name in directory_import_staging as it enumerates, taken
from Microsoft Graph or Google. Those rows persist: directory_sync.cfm clears
only 'pending' and 'failed' on a later run, because 'applied' and 'skipped'
record a decision rather than an attempt.

LDAP is not a source. ldap_add_user_relay.cfm never sets displayName, so
ldap_add_user.cfm defaults it to givenName plus sn, which for a relay user is
the email local part followed by the literal word "User".

Requires:
- recipientEmail

Sets:
- resolvedDisplayName
- resolvedFirstName
- resolvedLastName
- displayNameSource: "directory" or "localpart"

A hand added relay recipient was never enumerated, so it falls back to the
email local part, which is what Add Mailbox already does with a blank
Display Name field.
--->

<cfquery name="stagedName" datasource="hermes">
    SELECT display_name, first_name, last_name
      FROM directory_import_staging
     WHERE email = <cfqueryparam value="#recipientEmail#" cfsqltype="cf_sql_varchar">
       AND status IN ('applied', 'skipped')
     ORDER BY created_at DESC, id DESC
     LIMIT 1
</cfquery>

<cfset resolvedLocalPart = ListFirst(recipientEmail, "@")>

<cfif stagedName.recordcount GTE 1 AND Len(Trim(stagedName.display_name))>
    <cfset resolvedDisplayName = Trim(stagedName.display_name)>
    <cfset displayNameSource   = "directory">
<cfelse>
    <cfset resolvedDisplayName = resolvedLocalPart>
    <cfset displayNameSource   = "localpart">
</cfif>

<!--- first and last are recorded separately by the enumerator and are worth
     keeping on their own: mailboxes has first_name and last_name columns that
     the directory import can fill properly. Splitting the display name would
     be a guess, so it is only used when the directory gave nothing. --->
<cfif stagedName.recordcount GTE 1 AND Len(Trim(stagedName.first_name))>
    <cfset resolvedFirstName = Trim(stagedName.first_name)>
<cfelse>
    <cfset resolvedFirstName = resolvedLocalPart>
</cfif>

<cfif stagedName.recordcount GTE 1 AND Len(Trim(stagedName.last_name))>
    <cfset resolvedLastName = Trim(stagedName.last_name)>
<cfelse>
    <cfset resolvedLastName = "">
</cfif>
