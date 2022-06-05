
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

<cfparam name = "successunholdmessage" default = "0">
    <cfif StructKeyExists(session, "successunholdmessage")>
    <cfif session.successunholdmessage is not "">
    <cfset successunholdmessage = session.successunholdmessage>
    
    <!--- /CFIF for session.successunholdmessage is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successunholdmessage --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
    <cfoutput>Success Unhold Message: #successunholdmessage#</cfoutput><br>
    --->
  
    <cfparam name = "successunholdmessage_email" default = "">
    <cfif StructKeyExists(session, "successunholdmessage_email")>
    <cfif session.successunholdmessage_email is not "">
    <cfset successunholdmessage_email = session.successunholdmessage_email>
    
    <!--- /CFIF for session.successunholdmessage_email is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successunholdmessage_email --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
     <cfoutput>Success Unhold Message: #successunholdmessage_email#</cfoutput><br>
    --->


    <cfparam name = "failureunholdmessage" default = "0">
    <cfif StructKeyExists(session, "failureunholdmessage")>
    <cfif session.failureunholdmessage is not "">
    <cfset failureunholdmessage = session.failureunholdmessage>
    
    <!--- /CFIF for session.failureunholdmessage is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.failureunholdmessage --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
    <cfoutput>Failure Unhold Message: #failureunholdmessage#</cfoutput><br>
    --->
  
    <cfparam name = "failureunholdmessage_email" default = "">
    <cfif StructKeyExists(session, "failureunholdmessage_email")>
    <cfif session.failureunholdmessage_email is not "">
    <cfset failureunholdmessage_email = session.failureunholdmessage_email>
    
    <!--- /CFIF for session.failureunholdmessage_email is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.failureunholdmessage_email --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
     <cfoutput>Failure Unhold Message: #failureunholdmessage_email#</cfoutput><br>
    --->


<cftry>
  
    <cfoutput>
    <cfexecute name = "/usr/sbin/postsuper"
    timeout = "240"
    arguments="-H #i#"
    variable="unholdmsg">
    </cfexecute>
    </cfoutput>
                            
    <cfcatch type="any">
                        
    
    </cfcatch>

     </cftry>

     <cfif #unholdmsg# contains "1 message" OR #unholdmsg# is "">

        <cfoutput>
        <cfset session.m=5>
        <cfset session.successunholdmessage=#successunholdmessage#+1>
        <cfset session.successunholdmessage_email= #successunholdmessage_email# & "#i# <br>">
    </cfoutput>

     <cfelse>

        <cfoutput>
        <cfset session.m=5>
        <cfset session.failureunholdmessage=#failureunholdmessage#+1>
        <cfset session.failureunholdmessage_email= #failureunholdmessage_email# & "#i# <br>">
    </cfoutput>

<!--- /CFIF #unholdmsg# --->
     </cfif> 

  