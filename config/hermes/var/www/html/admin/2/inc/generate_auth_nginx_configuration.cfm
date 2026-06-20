
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

 <!--- GENERATE CUSTOMTRANS --->
 <cfinclude template="generate_customtrans.cfm"> 

  <!--- GET CONSOLE HOST --->
<cfquery name = "getconsolehost" datasource = "hermes">
select value2 from parameters2 where module = 'console' and parameter = 'console.host'
</cfquery>

<cfset consoleHost = "#getconsolehost.value2#">
    
    <!--- GENERATE NGINX AUTH.CONF STARTS HERE --->

    <cffile action="read" file="/opt/hermes/templates/auth.conf" variable="nginx">
  
               
    <cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_auth.conf"
    output = "#REReplace("#nginx#","hermes_console_host","#trim(consoleHost)#","ALL")#" addnewline="no">
      
    
    <!--- Backup Nginx auth.conf --->
    <cffile action = "copy" source = "/etc/nginx/snippets/auth.conf" 
    destination = "/etc/nginx/snippets/auth.HERMES">
    
    <!--- Move #customtrans3#_auth.conf to /etc/nginx/snippets/auth.conf --->
    <cffile action = "move" source = "/opt/hermes/tmp/#customtrans3#_auth.conf" 
    destination = "/etc/nginx/snippets/auth.conf">

    <!--- GENERATE NGINX AUTH.CONF ENDS HERE --->
    
    
    