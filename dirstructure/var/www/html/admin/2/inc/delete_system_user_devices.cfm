
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
    
<!--- DELETE ALL SYSTEM USER TOTP AND WEBAUTHN DEVICES --->

<cffile action="read" file="/opt/hermes/scripts/authelia_delete_user_device_all.sh" variable="delete">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_authelia_delete_user_device_all.sh"
output = "#REReplace("#delete#","THE-USER","#theUsername#","ALL")#" addnewline="no">


<cftry>


    <cfexecute name = "/bin/chmod"
    arguments="+x /opt/hermes/tmp/#customtrans3#_authelia_delete_user_device_all.sh"
    timeout = "60">
    </cfexecute>

    <cfcatch type="any">

        <!--- DEBUG --->
      <!---
      <cfdump var="#cfcatch#">
        --->
    
      </cfcatch>
    
    </cftry>
    

<cftry>
  
    <cfexecute name = "/opt/hermes/tmp/#customtrans3#_authelia_delete_user_device_all.sh"
    timeout = "240"
    outputfile ="/dev/null"
    arguments="-inputformat none">
    </cfexecute>

<cfcatch type="any">

    <!--- DEBUG --->
  <!---
  <cfdump var="#cfcatch#">
    --->

  </cfcatch>

</cftry>

  <!--- Delete File --->
  <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_authelia_delete_user_device_all.sh">
  <cfif fileExists(FiletoDelete)> 
  <cffile action="delete" 
  file = "#FiletoDelete#">
  
  <!--- /CFIF FiletoDelete --->
  </cfif>
        
            
    
    