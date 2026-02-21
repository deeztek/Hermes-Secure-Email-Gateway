
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
GET LDAP USER GROUPS
Queries LDAP to find a user by email and determine their group membership.

Requires the following variable to be set before including:
- userEmail: The user's email address to look up

Returns:
- ldapUserFound: Boolean - whether the user was found in LDAP
- ldapUsername: The user's LDAP cn (username) if found
- isRelay: Boolean - member of relays group
- isMailbox: Boolean - member of mailboxes group
- isAdmin: Boolean - member of admins group
--->

<!--- INITIALIZE RETURN VARIABLES --->
<cfset ldapUserFound = false>
<cfset ldapUsername = "">
<cfset isRelay = false>
<cfset isMailbox = false>
<cfset isAdmin = false>

<!--- GENERATE CUSTOMTRANS FOR UNIQUE TEMP FILENAMES --->
<cfinclude template="generate_customtrans.cfm">

<cftry>

<!--- SEARCH FOR USER BY EMAIL IN LDAP --->
<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b 'dc=hermes,dc=local' '(mail=#userEmail#)' dn cn"
    variable="ldapSearchResult"
    errorVariable="ldapSearchError"
    timeout="60">
</cfexecute>

<!--- PARSE THE SEARCH RESULT TO GET THE USER'S DN AND CN --->
<cfif ldapSearchResult CONTAINS "dn: cn=">
    <cfset ldapUserFound = true>

    <!--- Extract CN from the DN line --->
    <!--- Format: dn: cn=username,ou=users,dc=hermes,dc=local --->
    <cfset dnLine = "">
    <cfloop list="#ldapSearchResult#" index="line" delimiters="#chr(10)#">
        <cfif line CONTAINS "dn: cn=">
            <cfset dnLine = line>
            <cfbreak>
        </cfif>
    </cfloop>

    <cfif dnLine NEQ "">
        <!--- Extract the cn value --->
        <cfset cnStart = FindNoCase("dn: cn=", dnLine) + 7>
        <cfset cnEnd = FindNoCase(",ou=", dnLine)>
        <cfif cnEnd GT cnStart>
            <cfset ldapUsername = Mid(dnLine, cnStart, cnEnd - cnStart)>
        </cfif>
    </cfif>
</cfif>

<!--- IF USER FOUND, CHECK GROUP MEMBERSHIP --->
<cfif ldapUserFound AND ldapUsername NEQ "">

    <!--- CHECK RELAYS GROUP --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b 'cn=relays,ou=groups,dc=hermes,dc=local' '(member=cn=#ldapUsername#,ou=users,dc=hermes,dc=local)' dn"
        variable="relaysResult"
        errorVariable="relaysError"
        timeout="60">
    </cfexecute>

    <cfif relaysResult CONTAINS "dn: cn=relays">
        <cfset isRelay = true>
    </cfif>

    <!--- CHECK MAILBOXES GROUP --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b 'cn=mailboxes,ou=groups,dc=hermes,dc=local' '(member=cn=#ldapUsername#,ou=users,dc=hermes,dc=local)' dn"
        variable="mailboxesResult"
        errorVariable="mailboxesError"
        timeout="60">
    </cfexecute>

    <cfif mailboxesResult CONTAINS "dn: cn=mailboxes">
        <cfset isMailbox = true>
    </cfif>

    <!--- CHECK ADMINS GROUP --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b 'cn=admins,ou=groups,dc=hermes,dc=local' '(member=cn=#ldapUsername#,ou=users,dc=hermes,dc=local)' dn"
        variable="adminsResult"
        errorVariable="adminsError"
        timeout="60">
    </cfexecute>

    <cfif adminsResult CONTAINS "dn: cn=admins">
        <cfset isAdmin = true>
    </cfif>

</cfif>

<cfcatch type="any">
    <!--- On error, user is not found --->
    <cfset ldapUserFound = false>
    <cfset ldapUsername = "">
    <cfset isRelay = false>
    <cfset isMailbox = false>
    <cfset isAdmin = false>
</cfcatch>

</cftry>
