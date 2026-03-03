
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

<cfinclude template="generate_customtrans.cfm">

<!--- Read the generate_dkim.sh template and substitute values --->
<cffile action="read" file="/opt/hermes/scripts/generate_dkim.sh" variable="temp">

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_generate_dkim.sh"
    output="#REReplace(temp, 'THE-KEY', form.dkimkey, 'ALL')#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_dkim.sh" variable="temp">

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_generate_dkim.sh"
    output="#REReplace(temp, 'THE-DOMAIN', getdomain.domain, 'ALL')#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_generate_dkim.sh" variable="temp">

<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_generate_dkim.sh"
    output="#REReplace(temp, 'THE-SELECTOR', form.selector, 'ALL')#" addnewline="no">

<!--- CHMOD the script via Docker --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_postfix_dkim /bin/chmod +x /opt/hermes/tmp/#customtrans3#_generate_dkim.sh"
        timeout="60">
    </cfexecute>

    <cfcatch type="any">
        <cfset m="/inc/dkim_create_key.cfm: There was an error running chmod +x /opt/hermes/tmp/#customtrans3#_generate_dkim.sh">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<!--- Execute the script via Docker --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_postfix_dkim /opt/hermes/tmp/#customtrans3#_generate_dkim.sh"
        timeout="240">
    </cfexecute>

    <cfcatch type="any">
        <cfset m="/inc/dkim_create_key.cfm: There was an error executing /opt/hermes/tmp/#customtrans3#_generate_dkim.sh">
        <cfinclude template="error.cfm">
        <cfabort>
    </cfcatch>
</cftry>

<!--- Delete the temp script --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_generate_dkim.sh">
<cfif fileExists(FiletoDelete)>
    <cffile action="delete" file="#FiletoDelete#">
</cfif>

<!--- CHECK KEY FILES EXIST --->
<cfset PrivateFile="/opt/hermes/dkim/keys/#form.selector#_#getdomain.domain#.dkim.private">
<cfset PublicFile="/opt/hermes/dkim/keys/#form.selector#_#getdomain.domain#.dkim.txt">

<cfif fileExists(PrivateFile) AND fileExists(PublicFile)>

    <cfquery name="insertkey" datasource="hermes">
        insert into dkim_sign (domain, applied, public, private, enabled, generated, selector)
        values ('#getdomain.domain#', '1', '#form.selector#_#getdomain.domain#.dkim.txt', '#form.selector#_#getdomain.domain#.dkim.private', '2', '1', '#form.selector#')
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
  
 