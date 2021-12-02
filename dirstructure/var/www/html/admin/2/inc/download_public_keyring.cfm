
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

<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
    select random_letter as random from captcha_list_all2 order by RAND() limit 8
    </cfquery>
    
    <cfquery name="inserttrans" datasource="#datasource#" result="stResult">
    insert into salt
    (salt)
    values
    ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
    </cfquery>
    
    <cfquery name="gettrans" datasource="#datasource#">
    select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    <cfset customtrans3=#gettrans.customtrans2#>
    
    <cfquery name="deletetrans" datasource="#datasource#">
    delete from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    <cffile action="read" file="/opt/hermes/scripts/export_pgp_public_key.sh" variable="temp">
    
    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_export_pgp_public_key.sh"
        output = "#REReplace("#temp#","THE_KEY","#getkeyhex.pgp_key_id#","ALL")#" addnewline="no">
    
    <cfexecute name = "/bin/chmod"
    arguments="+x /opt/hermes/tmp/#customtrans3#_export_pgp_public_key.sh"
    timeout = "60">
    </cfexecute>
    
    
    <cfexecute name = "/opt/hermes/tmp/#customtrans3#_export_pgp_public_key.sh"
    timeout = "240"
    variable="thekeyid2"
    arguments="-inputformat none">
    </cfexecute>
    
    <!-- Delete File -->
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_export_pgp_public_key.sh">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF fileExists(FiletoDelete) --->
    </cfif>
    
    <cfset keyfile="/opt/hermes/tmp/#getkeyhex.pgp_key_id#_public.asc">
    
    
    <cfif NOT fileExists(keyfile)> 
    
        <cfset session.m = 17>
        <cfoutput>
        <cflocation url="#cgi.http_referer#" addtoken="no">
        </cfoutput>
        <cfabort>
    
    <cfelseif fileExists(keyfile)>
    
    <cfoutput>
    <cfheader name="Content-disposition" value="attachment;filename=#getkeyhex.pgp_key_id#_public.asc">
    <CFCONTENT FILE="/opt/hermes/tmp/#getkeyhex.pgp_key_id#_public.asc" type="application/unknown" DELETEFILE="Yes">
    </cfoutput>
    
    <!-- /cfif fileExists(keyfile) -->
    </cfif>
    

    