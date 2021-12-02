
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

<cfif #url.type# is "1">

<cfquery name="getinfo" datasource="hermes">
    select * from recipients where id='#getkeydetails.user_id#'
    </cfquery>

<cfelseif #url.type# is "2">

    <cfquery name="getinfo" datasource="hermes">
        select email as recipient from external_recipients where id='#getkeydetails.user_id#'
        </cfquery>

        
<!--- </CFIF #url.type# is "1"/"2" --->
    </cfif>

<cfif #getinfo.recordcount# GTE 1>
        
    <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
        select random_letter as random from captcha_list_all2 order by RAND() limit 8
        </cfquery>
        
        <cfquery name="inserttrans" datasource="hermes" result="stResult">
        insert into salt
        (salt)
        values
        ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
        </cfquery>
        
        <cfquery name="gettrans" datasource="hermes">
        select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
        </cfquery>
        
        <cfset customtrans3=#gettrans.customtrans2#>
        
        <cfquery name="deletetrans" datasource="hermes">
        delete from salt where id='#stResult.GENERATED_KEY#'
        </cfquery>

<!-- PUBLISH GPG KEY STARTS HERE -->
<cffile action="read" file="/opt/hermes/scripts/publish_pgp_key.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh"
    output = "#REReplace("#temp#","THE_KEY_ID","#getkeydetails.pgp_key_id#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh"
    output = "#REReplace("#temp#","THE-KEY-SERVER","#getkeyservername.keyserver#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh"
timeout = "240"
variable="publishresults"
arguments="">
</cfexecute>

<!-- delete /opt/hermes/tmp//opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_publish_pgp_key.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF FiletoDelete --->
</cfif>


<!--- IF COMMAND OUTPUT IS 0 NEW KEY(S) IMPORTED PROBABLY ALREADY EXISTS  --->
<cfif FindNoCase("Server indicated a failure", publishresults)>

    
<cfset session.m = 22>
<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>
<cfabort>

<cfelseif FindNoCase("No name", publishresults)>

        
<cfset session.m = 23>
<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>
<cfabort>

<cfelseif FindNoCase("Not found", publishresults)>

        
    <cfset session.m = 24>
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
    <cfabort>

<cfelseif FindNoCase("Not a key ID", publishresults)>

        
    <cfset session.m = 25>
    <cfoutput>
    <cflocation url="#cgi.http_referer#" addtoken="no">
    </cfoutput>
    <cfabort>

<cfelse>

<!--- /CFIF FindNoCase --->
</cfif>

<!-- PUBLISH GPG KEY ENDS HERE -->

        
        
<cfelseif #getinfo.recordcount# LT 1>
    
    <cfset m="Publish Recipient Keyring: getinfo.recordcount LT 1">
    <cfinclude template="error.cfm">
    <cfabort>
    
    <!--- /CFIF #getinfo.recordcount# LT 1 --->
        </cfif>