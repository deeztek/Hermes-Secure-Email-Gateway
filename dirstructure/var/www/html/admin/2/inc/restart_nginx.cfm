
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



<cftry>
  

    <cfexecute name = "/bin/systemctl reload nginx"
    timeout = "240"
    outputfile ="/dev/null">
    </cfexecute>

    <cfcatch type="any">
                
    <cfset m="Reload Nginx: There was an error re-loading Nginx ">
    <cfinclude template="error.cfm">
    <cfabort>   
                
    </cfcatch>
    </cftry>


<!--- SLEEP 5 SECONDS WAITING FOR NGINX TO RESTART --->
<cfscript> 
thread = CreateObject("java", "java.lang.Thread"); 
thread.sleep(5000); 
</cfscript> 
      
