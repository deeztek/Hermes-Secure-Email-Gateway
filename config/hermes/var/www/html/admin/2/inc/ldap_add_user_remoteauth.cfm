
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
ADD REMOTE AUTH USER TO LDAP
Requires the following variables to be set before including:
- ldapUsername: The username (cn and uid)
- ldapFirstName: User's first name (givenName)
- ldapLastName: User's last name (sn)
- ldapEmail: User's email address (mail)
- ldapRemoteauthDomain: The remoteauth domain for seeAlso/associatedDomain

This creates an LDAP user WITHOUT a password - authentication is handled by the remote server
via the remoteauth overlay. The seeAlso attribute points to the remote DN.
--->

<!--- GENERATE CUSTOMTRANS FOR UNIQUE TEMP FILENAMES --->
<cfinclude template="generate_customtrans.cfm">

<!--- INITIALIZE ERROR VARIABLES --->
<cfset ldapAddResult = "">
<cfset ldapAddError = "">

<!--- GET THE REMOTE DN PATTERN FOR THIS DOMAIN --->
<cfquery name="getRemoteMapping" datasource="hermes">
    SELECT server_address, remote_dn_pattern FROM remoteauth_mappings WHERE domain_name = <cfqueryparam value="#ldapRemoteauthDomain#" cfsqltype="cf_sql_varchar">
</cfquery>

<!--- BUILD THE SEEALSO DN - This points to the remote user DN --->
<!--- Replace placeholders in the DN pattern with actual user values --->
<cfset ldapSeeAlso = getRemoteMapping.remote_dn_pattern>
<cfset ldapSeeAlso = ReplaceNoCase(ldapSeeAlso, "{username}", ldapUsername, "ALL")>
<cfset ldapSeeAlso = ReplaceNoCase(ldapSeeAlso, "{firstname}", ldapFirstName, "ALL")>
<cfset ldapSeeAlso = ReplaceNoCase(ldapSeeAlso, "{lastname}", ldapLastName, "ALL")>
<cfset ldapSeeAlso = ReplaceNoCase(ldapSeeAlso, "{email}", ldapEmail, "ALL")>

<cftry>

<!--- READ THE LDAP ADDUSER REMOTEAUTH TEMPLATE --->
<cffile action="read" file="/opt/hermes/templates/ldap_adduser_remoteauth.ldif" variable="ldapUserTemplate">

<!--- REPLACE PLACEHOLDERS WITH ACTUAL VALUES --->
<cfset ldapUserLdif = ldapUserTemplate>
<cfset ldapUserLdif = REReplace(ldapUserLdif, "THE_USERNAME", ldapUsername, "ALL")>
<cfset ldapUserLdif = REReplace(ldapUserLdif, "THE_FIRSTNAME", ldapFirstName, "ALL")>
<cfset ldapUserLdif = REReplace(ldapUserLdif, "THE_LASTNAME", ldapLastName, "ALL")>
<cfset ldapUserLdif = REReplace(ldapUserLdif, "THE_EMAIL", ldapEmail, "ALL")>
<cfset ldapUserLdif = REReplace(ldapUserLdif, "THE_SEEALSO", ldapSeeAlso, "ALL")>
<cfset ldapUserLdif = REReplace(ldapUserLdif, "THE_DOMAIN", ldapRemoteauthDomain, "ALL")>

<!--- WRITE THE POPULATED LDIF TO THE CUSTOM DIRECTORY (MOUNTED IN LDAP CONTAINER) --->
<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_adduser_remoteauth.ldif"
    output="#ldapUserLdif#"
    addNewLine="no">

<!--- EXECUTE LDAPADD IN THE LDAP CONTAINER --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap ldapadd -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -f /opt/hermes/tmp/#customtrans3#_adduser_remoteauth.ldif"
    variable="ldapAddResult"
    errorVariable="ldapAddError"
    timeout="60">
</cfexecute>

<!--- CLEANUP: DELETE THE TEMP LDIF FILE --->
<cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_adduser_remoteauth.ldif">
<cfif fileExists(fileToDelete)>
    <cffile action="delete" file="#fileToDelete#">
</cfif>

<!--- CHECK FOR ERRORS --->
<cfif ldapAddError CONTAINS "Already exists">
    <cfset ldapUserExists = true>
<cfelse>
    <cfset ldapUserExists = false>
</cfif>

<cfcatch type="any">
    <!--- CLEANUP ON ERROR --->
    <cfset fileToDelete = "/opt/hermes/tmp/#customtrans3#_adduser_remoteauth.ldif">
    <cfif fileExists(fileToDelete)>
        <cffile action="delete" file="#fileToDelete#">
    </cfif>

    <!--- Safely get ldapAddError if it exists --->
    <cfset errorDetail = "">
    <cfif isDefined("ldapAddError")>
        <cfset errorDetail = ldapAddError>
    </cfif>

    <!--- CHECK IF USER ALREADY EXISTS - This is not a fatal error --->
    <cfif errorDetail CONTAINS "Already exists" OR cfcatch.detail CONTAINS "Already exists">
        <cfset ldapUserExists = true>
        <!--- Don't abort - let calling code handle the existing user --->
    <cfelse>
        <cfset m="LDAP Add User RemoteAuth: #cfcatch.message# | Detail: #cfcatch.detail# | LDAP Error: #errorDetail#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfif>
</cfcatch>

</cftry>
