
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
GENERATE LDAP ARGON2 PASSWORD
Requires: form.password to be set before including this template
Returns: ldapPassword variable containing the Argon2 hash
--->

<cftry>

<cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_ldap slappasswd -o module-load=argon2.la -h {ARGON2} -s #form.password#"
    variable="ldapPassword"
    timeout="60">
</cfexecute>

<!--- Trim any whitespace/newlines from the output --->
<cfset ldapPassword = TRIM(ldapPassword)>

<cfcatch type="any">
    <cfset m="Generate LDAP Password: There was an error generating the LDAP Argon2 password">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>

</cftry>
