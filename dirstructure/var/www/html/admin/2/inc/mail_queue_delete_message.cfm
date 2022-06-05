
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

<cfparam name = "successdeletemessage" default = "0">
<cfif StructKeyExists(session, "successdeletemessage")>
<cfif session.successdeletemessage is not "">
<cfset successdeletemessage = session.successdeletemessage>

<!--- /CFIF for session.successdeletemessage is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.successdeletemessage --->
</cfif>

  <!--- DEBUG BELOW --->
<!--- 
<cfoutput>Success Re-queue Message: #successdeletemessage#</cfoutput><br>
--->

<cfparam name = "successdeletemessage_email" default = "">
<cfif StructKeyExists(session, "successdeletemessage_email")>
<cfif session.successdeletemessage_email is not "">
<cfset successdeletemessage_email = session.successdeletemessage_email>

<!--- /CFIF for session.successdeletemessage_email is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.successdeletemessage_email --->
</cfif>

  <!--- DEBUG BELOW --->
<!--- 
 <cfoutput>Success Re-Queue Message: #successdeletemessage_email#</cfoutput><br>
--->



<cfparam name = "failuredeletemessage" default = "0">
<cfif StructKeyExists(session, "failuredeletemessage")>
<cfif session.failuredeletemessage is not "">
<cfset failuredeletemessage = session.failuredeletemessage>

<!--- /CFIF for session.failuredeletemessage is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.failuredeletemessage --->
</cfif>

<!--- DEBUG BELOW --->
<!--- 
<cfoutput>Failure Re-queue Message: #failuredeletemessage#</cfoutput><br>
--->

<cfparam name = "failuredeletemessage_email" default = "">
<cfif StructKeyExists(session, "failuredeletemessage_email")>
<cfif session.failuredeletemessage_email is not "">
<cfset failuredeletemessage_email = session.failuredeletemessage_email>

<!--- /CFIF for session.failuredeletemessage_email is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.failuredeletemessage_email --->
</cfif>

<!--- DEBUG BELOW --->
<!--- 
<cfoutput>Failure Re-Queue Message: #failuredeletemessage_email#</cfoutput><br>
--->


<cftry>
  
    <cfoutput>
    <cfexecute name = "/usr/sbin/postsuper"
    timeout = "240"
    arguments="-d #i#"
    variable="deletemsg">
    </cfexecute>
    </cfoutput>
                            
    <cfcatch type="any">
                        
    
    </cfcatch>

     </cftry>

     <cfif #deletemsg# contains "1 message" OR #deletemsg# is "">

        <cfoutput>
        <cfset session.m=6>
        <cfset session.successdeletemessage=#successdeletemessage#+1>
        <cfset session.successdeletemessage_email= #successdeletemessage_email# & "#i# <br>">
    </cfoutput>

     <cfelse>

        <cfoutput>
        <cfset session.m=6>
        <cfset session.failuredeletemessage=#failuredeletemessage#+1>
        <cfset session.failuredeletemessage_email= #failuredeletemessage_email# & "#i# <br>">
    </cfoutput>

<!--- /CFIF #requeuemsg# --->
     </cfif> 

  