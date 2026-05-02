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
ENFORCE-MFA RESTRICTION CHECK (#225 Phase 1.5)

Computes whether the current user-portal page should refuse to render
its main content because the user is in the "admin enforces 2FA, user
hasn't enabled it yet" bootstrap state.

The deliberate design: enforce_mfa is decoupled from LDAP cn=two_factor
membership. Admin sets recipients.enforce_mfa = 1 as policy. LDAP
two_factor membership only flips when the user themselves clicks
Enable 2FA in user_settings.cfm. Until the user enables, this gate
keeps them out of full portal features but lets them through the
bootstrap surfaces (Account Settings, My App Passwords, Set Up Your
Devices, Webmail) so they can set up a mail client, read the welcome
+ Authelia identity-verification emails, and then come back to enable
2FA themselves. Solves the chicken-and-egg where Authelia's first-time
2FA enrollment requires email access but the new mailbox has no
working mail client yet.

Sets variables in the calling page:
  - enforceMfaRestricted : boolean. true = render the restricted-access
                           panel instead of the page's main content.
  - enforceMfaRestrictionReason : string label for diagnostics.

Caller pattern (inside the page's main content area):

    <cfinclude template="./inc/check_enforce_mfa_restriction.cfm">
    <cfif enforceMfaRestricted>
      <cfinclude template="./inc/restricted_access_panel.cfm">
    <cfelse>
      <!--- normal page content --->
    </cfif>

Conditions to be restricted:
  1. User is a mailbox user (cn=mailboxes) OR a relay recipient
     (cn=relays). #225 Phase 2 extended this to relays so the
     bootstrap UX is consistent across both groups: admin enforces,
     user sees urgent banner, only Account Settings remains
     accessible until the user clicks Enable 2FA themselves.
  2. recipients.enforce_mfa = 1.
  3. User is NOT yet in cn=two_factor LDAP group.

Any of those false → no restriction. Group membership is read from
session.theGroups (set by Application.cfc on every request from the
remote-groups header).
--->

<cfset enforceMfaRestricted = false>
<cfset enforceMfaRestrictionReason = "">

<cfif (session.theGroups CONTAINS "mailboxes" OR session.theGroups CONTAINS "relays") AND NOT (session.theGroups CONTAINS "two_factor")>
    <cfquery name="checkEnforceMfaRestriction" datasource="hermes">
        SELECT enforce_mfa FROM recipients
        WHERE recipient = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkEnforceMfaRestriction.recordcount GTE 1 AND Val(checkEnforceMfaRestriction.enforce_mfa) EQ 1>
        <cfset enforceMfaRestricted = true>
        <cfset enforceMfaRestrictionReason = "admin enforces 2FA, user has not enabled yet">
    </cfif>
</cfif>
