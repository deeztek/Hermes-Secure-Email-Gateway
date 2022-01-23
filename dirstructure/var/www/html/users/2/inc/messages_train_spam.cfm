
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

  <!--- TRAIN SPAM MESSAGE PARAMETERS START HERE --->
  

  <cfparam name = "successspammessage" default = "0">
  <cfif StructKeyExists(session, "successspammessage")>
  <cfif session.successspammessage is not "">
  <cfset successspammessage = session.successspammessage>
  
  <!--- /CFIF for session.successspammessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successspammessage --->
  </cfif>

  <cfparam name = "successspammessage_email" default = "">
  <cfif StructKeyExists(session, "successspammessage_email")>
  <cfif session.successspammessage_email is not "">
  <cfset successspammessage_email = session.successspammessage_email>
  
  <!--- /CFIF for session.successspammessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successspammessage_email --->
  </cfif>

      <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Success Ham Message: #successspammessage#</cfoutput><br>
  --->
  
  <cfparam name = "failurespammessage" default = "0">
  <cfif StructKeyExists(session, "failurespammessage")>
  <cfif session.failurespammessage is not "">
  <cfset failurespammessage = session.failurespammessage>
  
  <!--- /CFIF for session.failurespammessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurespammessage --->
  </cfif>

        <!--- DEBUG BELOW --->
  <!--- 

  <cfoutput>Failure Ham Message: #failurespammessage#</cfoutput><br>
  --->
  
  <cfparam name = "failurespammessage_email" default = "">
  <cfif StructKeyExists(session, "failurespammessage_email")>
  <cfif session.failurespammessage_email is not "">
  <cfset failurespammessage_email = session.failurespammessage_email>
  
  <!--- /CFIF for session.failurespammessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurespammessage_email --->
  </cfif>

  <!--- TRAIN SPAM MESSAGE PARAMETERS END HERE --->

<cfquery name="getmsg" datasource="hermes">
    select quar_loc, subject from msgs where mail_id like binary '#getemail.mail_id#' and secret_id like binary '#getemail.secret_id#'
    </cfquery>
    
    
    <cfif #getmsg.recordcount# GTE 1>

    <cfset quarfile="/mnt/data/amavis/#getmsg.quar_loc#">

    <cfif fileExists(quarfile)> 
    
<cftry>

    <cfexecute name = "/usr/bin/sa-learn"
    timeout = "240"
    variable ="salearnresult"
    arguments="--no-sync --spam #quarfile#">
    </cfexecute>
                
        <cfcatch type="any">
            
        <cfset m="Messages Train Spam: There was an error executing /usr/bin/sa-learn">
        <cfinclude template="error.cfm">
        <cfabort>   
            
        </cfcatch>
        </cftry>
        
        
         <!--- IF COMMAND OUTPUT CONTAINS Learned tokens from 1 message(s) THEN TRAIN SUCCEEDED --->
         <cfif FindNoCase("Learned tokens from 1 message(s)", salearnresult)>
                    
        <cfset session.successspammessage=#successspammessage#+1>
        <cfset session.successspammessage_email= successspammessage_email & "#getmsg.subject# <br>">
        
        <!--- IF COMMAND OUTPUT DOES NOT CONTAIN Learned Tokens from 1 message(s) THEN TRAIN FAILED --->
        <cfelse>
                    
        <cfset session.failurespammessage=#failurespammessage#+1>
        <cfset session.failurespammessage_email= failurespammessage_email & "#getmsg.subject# <br>">
                    
        </cfif>
              
    
    <cfelseif NOT fileExists(quarfile)> 

    <cfset session.failurespammessage=#failurespammessage#+1>
    <cfset session.failurespammessage_email= failurespammessage_email & "#getmsg.subject# <br>">

    <!--- /CFIF fileExists(quarfile) --->
    </cfif>
    
    <cfelseif #getmsg.recordcount# LT 1>

    <cfset session.failurespammessage=#failurespammessage#+1>
    <cfset session.failurespammessage_email= failurespammessage_email & "#getmsg.subject# <br>">
    
    <!--- /CFIF #getmsg.recordcount# --->
    </cfif>