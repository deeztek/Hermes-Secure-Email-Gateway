
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

<cfparam name = "successhammessage" default = "0">
  <cfif StructKeyExists(session, "successhammessage")>
  <cfif session.successhammessage is not "">
  <cfset successhammessage = session.successhammessage>
  
  <!--- /CFIF for session.successhammessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successhammessage --->
  </cfif>

  <cfparam name = "successhammessage_email" default = "">
  <cfif StructKeyExists(session, "successhammessage_email")>
  <cfif session.successhammessage_email is not "">
  <cfset successhammessage_email = session.successhammessage_email>
  
  <!--- /CFIF for session.successhammessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successhammessage_email --->
  </cfif>

  <cfoutput>Success Release Message: #successhammessage#</cfoutput><br>
  
  <cfparam name = "failurehammessage" default = "0">
  <cfif StructKeyExists(session, "failurehammessage")>
  <cfif session.failurehammessage is not "">
  <cfset failurehammessage = session.failurehammessage>
  
  <!--- /CFIF for session.failurehammessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurehammessage --->
  </cfif>

  <cfoutput>Failure Release Message: #failurehammessage#</cfoutput><br>
  
  <cfparam name = "failurehammessage_email" default = "">
  <cfif StructKeyExists(session, "failurehammessage_email")>
  <cfif session.failurehammessage_email is not "">
  <cfset failurehammessage_email = session.failurehammessage_email>
  
  <!--- /CFIF for session.failurehammessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurehammessage_email --->
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
  arguments="--no-sync --ham #quarfile#">
  </cfexecute>
              
      <cfcatch type="any">
          
      <cfset m="Messages Train Ham: There was an error executing /usr/bin/sa-learn">
      <cfinclude template="error.cfm">
      <cfabort>   
          
      </cfcatch>
      </cftry>
        
        
         <!--- IF COMMAND OUTPUT CONTAINS Learned tokens from 1 message(s) THEN TRAIN SUCCEEDED --->
         <cfif FindNoCase("Learned tokens from 1 message(s)", salearnresult)>
                    
        <cfset session.successhammessage=#successhammessage#+1>
        <cfset session.successhammessage_email= successhammessage_email & "#getmsg.subject# <br>">
        
        <!--- IF COMMAND OUTPUT DOES NOT CONTAIN Learned Tokens from 1 message(s) THEN TRAIN FAILED --->
        <cfelse>
                    
        <cfset session.failurehammessage=#failurehammessage#+1>
        <cfset session.failurehammessage_email= failurehammessage_email & "#getmsg.subject# <br>">
                    
        </cfif>
              
    
    <cfelseif NOT fileExists(quarfile)> 

    <cfset session.failurehammessage=#failurehammessage#+1>
    <cfset session.failurehammessage_email= failurehammessage_email & "#getmsg.subject# <br>">

    <!--- /CFIF fileExists(quarfile) --->
    </cfif>
    
    <cfelseif #getmsg.recordcount# LT 1>

    <cfset session.failurehammessage=#failurehammessage#+1>
    <cfset session.failurehammessage_email= failurehammessage_email & "#getmsg.subject# <br>">
    
    <!--- /CFIF #getmsg.recordcount# --->
    </cfif>