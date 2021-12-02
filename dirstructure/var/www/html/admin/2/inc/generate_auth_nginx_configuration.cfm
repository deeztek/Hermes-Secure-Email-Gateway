
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
    
    <!--- GENERATE NGINX AUTH.CONF STARTS HERE --->

    <cfquery name = "getconsolemode" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='console.mode'
    </cfquery>


    <cffile action="read" file="/opt/hermes/templates/auth.conf" variable="nginx">
            
    <cfif #getconsolemode.value2# is "ip">

        
<cftry>
       
    <cfexecute name="/opt/hermes/scripts/getip.sh"
    variable="GenerateAuthNginxIp"
    timeout="10" />
      
      <cfcatch type="any">

      <cfset m="Generate Auth Nginx Configuration: There was an error executing /opt/hermes/scripts/getip.sh">
      <cfinclude template="error.cfm">
      <cfabort>   

      </cfcatch>
      </cftry>
        
    <cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_auth.conf"
    output = "#REReplace("#nginx#","hermes_console_host","#trim(GenerateAuthNginxIp)#","ALL")#" addnewline="no">
        
    <cfelseif #getconsolemode.value2# is "fqdn">
        
    <cfquery name="getconsolehost" datasource="hermes">
    select value2 from parameters2 where parameter='console.host' and module='console'
    </cfquery>   
        
    <cfif #getconsolehost.value2# is "">
        
    <cfset m="Generate Auth Nginx Configuration: getconsolehost.value is blank">
    <cfinclude template="error.cfm">
    <cfabort>
        
    <cfelse>
        
    <cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_auth.conf"
    output = "#REReplace("#nginx#","hermes_console_host","#getconsolehost.value2#","ALL")#" addnewline="no">
        
    <!--- /CFIF getconsolehost.value2 is --->
    </cfif>
        
        
    <!--- /CFIF #getconsolemode.value2# is --->
    </cfif>
    
    <!--- Backup Nginx auth.conf --->
    <cffile action = "copy" source = "/etc/nginx/snippets/auth.conf" 
    destination = "/etc/nginx/snippets/auth.HERMES">
    
    <!--- Move #customtrans3#_auth.conf to /etc/nginx/snippets/auth.conf --->
    <cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_auth.conf" 
    destination = "/etc/nginx/snippets/auth.conf">

    <!--- GENERATE NGINX AUTH.CONF ENDS HERE --->
    
    
    