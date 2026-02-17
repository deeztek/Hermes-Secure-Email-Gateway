
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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

<!--- Set variables for key generation --->
<cfset keysDir = "/opt/hermes/dkim/keys">
<cfset selectorName = form.selector>
<cfset domainName = getdomain.domain>
<cfset keyBits = form.dkimkey>

<!--- Final filenames --->
<cfset PrivateFileName = "#selectorName#_#domainName#.dkim.private">
<cfset PublicFileName = "#selectorName#_#domainName#.dkim.txt">
<cfset dstPrivate = "#keysDir#/#PrivateFileName#">
<cfset dstPublic = "#keysDir#/#PublicFileName#">

<!--- Generate DKIM key using opendkim-genkey inside Docker container --->
<!--- Run via bash: cd to keys dir, generate key, rename files to final names --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_postfix_dkim /bin/bash -c 'cd #keysDir# && /usr/bin/opendkim-genkey -b #keyBits# -s #selectorName# -d #domainName# && mv #selectorName#.private #PrivateFileName# && mv #selectorName#.txt #PublicFileName#'"
        timeout="60"
        variable="genKeyOutput"
        errorVariable="genKeyError">
    </cfexecute>

    <cfcatch type="any">
        <cfset m="/inc/dkim_create_key.cfm: There was an error running opendkim-genkey: #cfcatch.message#">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

    <!--- CHECK KEY FILES EXIST --->
    <cfset PrivateFile = dstPrivate>
    <cfset PublicFile = dstPublic>
    <cfset PrivateFileName = "#selectorName#_#domainName#.dkim.private">
    <cfset PublicFileName = "#selectorName#_#domainName#.dkim.txt">

    <cfif fileExists(PrivateFile) AND fileExists(PublicFile)>

        <cfquery name="insertkey" datasource="hermes">
            INSERT INTO dkim_sign (domain, applied, public, private, enabled, generated, selector)
            VALUES ('#domainName#', '1', '#PublicFileName#', '#PrivateFileName#', '2', '1', '#selectorName#')
        </cfquery>

        <!--- SET OWNERSHIP OF NEWLY CREATED DKIM KEY FILES --->
        <cftry>
            <cfexecute name="/usr/local/bin/docker"
                arguments="exec hermes_postfix_dkim /bin/chown opendkim:opendkim #PrivateFile# #PublicFile#"
                timeout="60">
            </cfexecute>
            <cfcatch type="any">
                <cfset m="/inc/dkim_create_key.cfm: There was an error setting ownership on DKIM key files">
                <cfinclude template="error.cfm">
                <cfabort>
            </cfcatch>
        </cftry>

    <cfelse>

        <cfset m="/inc/dkim_create_key.cfm: PublicFile and/or PrivateFile does not exist">
        <cfinclude template="error.cfm">
        <cfabort>

    </cfif>
  
 