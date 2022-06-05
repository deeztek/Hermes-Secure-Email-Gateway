
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


<cfparam name = "successholdmessage" default = "0">
    <cfif StructKeyExists(session, "successholdmessage")>
    <cfif session.successholdmessage is not "">
    <cfset successholdmessage = session.successholdmessage>
    
    <!--- /CFIF for session.successholdmessage is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successholdmessage --->
    </cfif>
  
      <!--- DEBUG BELOW --->
<!---
    <cfoutput>Success Hold Message: #successholdmessage#</cfoutput><br>
--->
  
    <cfparam name = "successholdmessage_email" default = "">
    <cfif StructKeyExists(session, "successholdmessage_email")>
    <cfif session.successholdmessage_email is not "">
    <cfset successholdmessage_email = session.successholdmessage_email>
    
    <!--- /CFIF for session.successholdmessage_email is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.successholdmessage_email --->
    </cfif>
  
      <!--- DEBUG BELOW --->
<!---
     <cfoutput>Success Hold Message Email: #successholdmessage_email#</cfoutput><br>
--->


    <cfparam name = "failureholdmessage" default = "0">
    <cfif StructKeyExists(session, "failureholdmessage")>
    <cfif session.failureholdmessage is not "">
    <cfset failureholdmessage = session.failureholdmessage>
    
    <!--- /CFIF for session.failureholdmessage is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.failureholdmessage --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
    <cfoutput>Failure Hold Message: #failureholdmessage#</cfoutput><br>
    --->
  
    <cfparam name = "failureholdmessage_email" default = "">
    <cfif StructKeyExists(session, "failureholdmessage_email")>
    <cfif session.failureholdmessage_email is not "">
    <cfset failureholdmessage_email = session.failureholdmessage_email>
    
    <!--- /CFIF for session.failureholdmessage_email is not "" --->
    </cfif>
    
    <!--- /CFIF for StructKeyExists session.failureholdmessage_email --->
    </cfif>
  
      <!--- DEBUG BELOW --->
    <!--- 
     <cfoutput>Failure Hold Message: #failureholdmessage_email#</cfoutput><br>
    --->

<cftry>
  
    <cfoutput>
    <cfexecute name = "/usr/sbin/postsuper"
    timeout = "240"
    arguments="-h #i#"
    variable="holdmsg">
    </cfexecute>
    </cfoutput>
                            
    <cfcatch type="any">
                        
    
    </cfcatch>

     </cftry>

     <cfif #holdmsg# contains "1 message" OR #holdmsg# is "">

        <cfoutput>
        <cfset session.m=3>
        <cfset session.successholdmessage=#successholdmessage#+1>
        <cfset session.successholdmessage_email= #successholdmessage_email# & "#i# <br>">
    </cfoutput>

     <cfelse>

        <cfoutput>
        <cfset session.m=3>
        <cfset session.failureholdmessage=#failureholdmessage#+1>
        <cfset session.failureholdmessage_email= #failureholdmessage_email# & "#i# <br>">
    </cfoutput>

<!--- /CFIF #holdmsg# --->
     </cfif> 

  