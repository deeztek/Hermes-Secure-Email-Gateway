
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
ADD RELAY USER TO LDAP
Creates an LDAP user for an internal recipient (relay) with a random password.
The user must reset their password before logging in.

Requires the following variables to be set before including:
- recipientEmail: The recipient's email address

Returns:
- ldapUsername: The generated LDAP username (cn)
- ldapUserCreated: Boolean indicating success
--->

<!--- LDAP USERNAME IS THE EMAIL ADDRESS --->
<cfset ldapUsername = LCase(recipientEmail)>

<!--- EXTRACT NAME PARTS FROM EMAIL --->
<cfset emailLocalPart = ListFirst(recipientEmail, "@")>
<cfset ldapFirstName = emailLocalPart>
<cfset ldapLastName = "User">
<cfset ldapEmail = recipientEmail>

<!--- GENERATE RANDOM PASSWORD (24 characters) --->
<cfset _transLength = 24>
<cfinclude template="generate_customtrans.cfm">
<cfset generatedPassword = customtrans3>

<!--- GENERATE ARGON2 HASH FOR LDAP PASSWORD --->
<cfset form.password = generatedPassword>
<cfinclude template="generate_ldap_password.cfm">

<!--- INITIALIZE RESULT --->
<cfset ldapUserCreated = false>

<cftry>

    <!--- ADD USER TO LDAP --->
    <cfinclude template="ldap_add_user.cfm">

    <!--- CHECK IF USER WAS CREATED OR ALREADY EXISTS --->
    <cfif isDefined("ldapUserExists") AND ldapUserExists>
        <!--- User already exists in LDAP, that's OK for migration scenarios --->
        <cfset ldapUserCreated = true>
    <cfelse>
        <cfset ldapUserCreated = true>
    </cfif>

    <!--- ADD USER TO RELAY GROUPS --->
    <cfset ldapAccessControl = "one_factor">
    <cfinclude template="ldap_add_user_groups_relay.cfm">

    <!--- UPDATE USER_SETTINGS WITH LDAP USERNAME --->
    <cfquery name="updateUserSettings" datasource="hermes">
        UPDATE user_settings
        SET ldap_username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ldapUsername#">
        WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#recipientEmail#">
    </cfquery>

<cfcatch type="any">
    <!--- On error, mark as failed but don't abort (allows migration script to continue) --->
    <cfset ldapUserCreated = false>
</cfcatch>

</cftry>
