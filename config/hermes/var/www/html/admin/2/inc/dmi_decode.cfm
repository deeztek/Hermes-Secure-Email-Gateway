  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

 <cftry> 

    <cfexecute name = "/opt/hermes/scripts/dmidecode"
    arguments=""
    timeout = "60">
    </cfexecute>
    
    <cfcatch type="any">
 
        <cfset m="/inc/add_serial_number: Error running /opt/hermes/scripts/dmidecode">
        <cfinclude template="error.cfm">
        <cfabort>


    </cfcatch>
    </cftry>
    

  
  <cffile action="read" file="/usr/share/UUID" variable="uuid">
  
  <cfset temp="#REReplace("#uuid#","#chr(10)#","","ALL")#">

  <cfset temp="#REReplace("#temp#","#chr(13)#","","ALL")#">
  <cfset temp="#REReplace("#temp#","","","ALL")#">
  <cfset temp="#REReplace("#temp#","UUID:","","ALL")#">
  
  <cfset theUuid=#TRIM(temp)#>