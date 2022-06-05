
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

<cfparam name = "successrequeuemessage" default = "0">
<cfif StructKeyExists(session, "successrequeuemessage")>
<cfif session.successrequeuemessage is not "">
<cfset successrequeuemessage = session.successrequeuemessage>

<!--- /CFIF for session.successrequeuemessage is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.successrequeuemessage --->
</cfif>

  <!--- DEBUG BELOW --->
<!--- 
<cfoutput>Success Re-queue Message: #successrequeuemessage#</cfoutput><br>
--->

<cfparam name = "successrequeuemessage_email" default = "">
<cfif StructKeyExists(session, "successrequeuemessage_email")>
<cfif session.successrequeuemessage_email is not "">
<cfset successrequeuemessage_email = session.successrequeuemessage_email>

<!--- /CFIF for session.successrequeuemessage_email is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.successrequeuemessage_email --->
</cfif>

  <!--- DEBUG BELOW --->
<!--- 
 <cfoutput>Success Re-Queue Message: #successrequeuemessage_email#</cfoutput><br>
--->



<cfparam name = "failurerequeuemessage" default = "0">
<cfif StructKeyExists(session, "failurerequeuemessage")>
<cfif session.failurerequeuemessage is not "">
<cfset failurerequeuemessage = session.failurerequeuemessage>

<!--- /CFIF for session.failurerequeuemessage is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.failurerequeuemessage --->
</cfif>

<!--- DEBUG BELOW --->
<!--- 
<cfoutput>Failure Re-queue Message: #failurerequeuemessage#</cfoutput><br>
--->

<cfparam name = "failurerequeuemessage_email" default = "">
<cfif StructKeyExists(session, "failurerequeuemessage_email")>
<cfif session.failurerequeuemessage_email is not "">
<cfset failurerequeuemessage_email = session.failurerequeuemessage_email>

<!--- /CFIF for session.failurerequeuemessage_email is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.failurerequeuemessage_email --->
</cfif>

<!--- DEBUG BELOW --->
<!--- 
<cfoutput>Failure Re-Queue Message: #failurerequeuemessage_email#</cfoutput><br>
--->


<cftry>
  
    <cfoutput>
    <cfexecute name = "/usr/sbin/postsuper"
    timeout = "240"
    arguments="-r #i#"
    variable="requeuemsg">
    </cfexecute>
    </cfoutput>
                            
    <cfcatch type="any">
                        
    
    </cfcatch>

     </cftry>

     <cfif #requeuemsg# contains "1 message" OR #requeuemsg# is "">

        <cfoutput>
        <cfset session.m=4>
        <cfset session.successrequeuemessage=#successrequeuemessage#+1>
        <cfset session.successrequeuemessage_email= #successrequeuemessage_email# & "#i# <br>">
    </cfoutput>

     <cfelse>

        <cfoutput>
        <cfset session.m=4>
        <cfset session.failurerequeuemessage=#failurerequeuemessage#+1>
        <cfset session.failurerequeuemessage_email= #failurerequeuemessage_email# & "#i# <br>">
    </cfoutput>

<!--- /CFIF #requeuemsg# --->
     </cfif> 

  