
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
ADD MAILBOX USER TO LDAP WITH REMOTE AUTHENTICATION
Creates an LDAP user for a mailbox recipient using RemoteAuth.
No password is set - authentication is handled by the remote AD/LDAP server
via the OpenLDAP remoteauth overlay (seeAlso + associatedDomain).

Requires the following variables to be set before including:
- recipientEmail: The recipient's email address
- remoteauthDomain: The RemoteAuth domain name (from remoteauth_mappings)

Returns:
- ldapUsername: The generated LDAP username (cn)
- ldapUserCreated: Boolean indicating success
--->

<!--- LDAP USERNAME IS THE EMAIL ADDRESS --->
<cfset ldapUsername = LCase(recipientEmail)>

<!--- givenName/sn feed the seeAlso DN pattern via {firstname}/{lastname}
     placeholders (ldap_add_user_remoteauth.cfm). When the remoteauth DN
     pattern requires them (typical AD default), the admin supplies real
     values via the form and they arrive here as remoteFirstName/remoteLastName.
     Otherwise we fall back to email-derived values. --->
<cfset emailLocalPart = ListFirst(recipientEmail, "@")>
<cfif isDefined("remoteFirstName") AND Len(Trim(remoteFirstName)) GT 0>
    <cfset ldapFirstName = Trim(remoteFirstName)>
<cfelse>
    <cfset ldapFirstName = emailLocalPart>
</cfif>
<cfif isDefined("remoteLastName") AND Len(Trim(remoteLastName)) GT 0>
    <cfset ldapLastName = Trim(remoteLastName)>
<cfelse>
    <cfset ldapLastName = "User">
</cfif>

<!--- displayName attribute = admin-entered display name (or derived from
     the real AD First/Last, or email local part as a last resort). This
     feeds the Authelia OIDC `name` claim and the Nextcloud display name. --->
<cfif isDefined("displayName") AND Len(Trim(displayName)) GT 0>
    <cfset ldapDisplayName = Trim(displayName)>
<cfelseif (isDefined("remoteFirstName") AND Len(Trim(remoteFirstName)) GT 0)
       OR (isDefined("remoteLastName")  AND Len(Trim(remoteLastName))  GT 0)>
    <cfset ldapDisplayName = Trim(ldapFirstName & " " & ldapLastName)>
<cfelse>
    <cfset ldapDisplayName = emailLocalPart>
</cfif>
<cfset ldapEmail = recipientEmail>

<!--- SET THE REMOTEAUTH DOMAIN FOR THE LDAP TEMPLATE --->
<cfset ldapRemoteauthDomain = remoteauthDomain>

<!--- INITIALIZE RESULT --->
<cfset ldapUserCreated = false>

<cftry>

    <!--- ADD USER TO LDAP VIA REMOTEAUTH (no password, seeAlso + associatedDomain) --->
    <cfinclude template="ldap_add_user_remoteauth.cfm">

    <!--- CHECK IF USER WAS CREATED OR ALREADY EXISTS --->
    <cfif isDefined("ldapUserExists") AND ldapUserExists>
        <!--- User already exists in LDAP, that's OK for migration scenarios --->
        <cfset ldapUserCreated = true>
    <cfelse>
        <cfset ldapUserCreated = true>
    </cfif>

    <!--- ADD USER TO MAILBOX GROUPS --->
    <cfset ldapAccessControl = "one_factor">
    <cfinclude template="ldap_add_user_groups_mailbox.cfm">

    <!--- UPDATE USER_SETTINGS WITH LDAP USERNAME --->
    <cfquery name="updateUserSettings" datasource="hermes">
        UPDATE user_settings
        SET ldap_username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ldapUsername#">
        WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#recipientEmail#">
    </cfquery>

<cfcatch type="any">
    <!--- On error, mark as failed but don't abort --->
    <cfset ldapUserCreated = false>
</cfcatch>

</cftry>
