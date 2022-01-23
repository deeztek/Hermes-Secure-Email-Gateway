
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

  <!--- FORGET MESSAGE PARAMETERS START HERE --->
  

  <cfparam name = "successforgetmessage" default = "0">
  <cfif StructKeyExists(session, "successforgetmessage")>
  <cfif session.successforgetmessage is not "">
  <cfset successforgetmessage = session.successforgetmessage>
  
  <!--- /CFIF for session.successforgetmessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successforgetmessage --->
  </cfif>

  <cfparam name = "successforgetmessage_email" default = "">
  <cfif StructKeyExists(session, "successforgetmessage_email")>
  <cfif session.successforgetmessage_email is not "">
  <cfset successforgetmessage_email = session.successforgetmessage_email>
  
  <!--- /CFIF for session.successforgetmessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successforgetmessage_email --->
  </cfif>

      <!--- DEBUG BELOW --->
  <!--- 
  <cfoutput>Success Ham Message: #successforgetmessage#</cfoutput><br>
  --->
  
  <cfparam name = "failureforgetmessage" default = "0">
  <cfif StructKeyExists(session, "failureforgetmessage")>
  <cfif session.failureforgetmessage is not "">
  <cfset failureforgetmessage = session.failureforgetmessage>
  
  <!--- /CFIF for session.failureforgetmessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failureforgetmessage --->
  </cfif>

        <!--- DEBUG BELOW --->
  <!--- 

  <cfoutput>Failure Ham Message: #failureforgetmessage#</cfoutput><br>
  --->
  
  <cfparam name = "failureforgetmessage_email" default = "">
  <cfif StructKeyExists(session, "failureforgetmessage_email")>
  <cfif session.failureforgetmessage_email is not "">
  <cfset failureforgetmessage_email = session.failureforgetmessage_email>
  
  <!--- /CFIF for session.failureforgetmessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failureforgetmessage_email --->
  </cfif>

  <!--- FORGET MESSAGE PARAMETERS END HERE --->

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
            arguments="--no-sync --forget #quarfile#">
            </cfexecute>
                        
                <cfcatch type="any">
                    
                <cfset m="Messages Forget Bayes: There was an error executing /usr/bin/sa-learn --forget">
                <cfinclude template="error.cfm">
                <cfabort>   
                    
                </cfcatch>
                </cftry>
        
        
         <!--- IF COMMAND OUTPUT CONTAINS Forgot tokens from 1 message(s) THEN TRAIN SUCCEEDED --->
         <cfif FindNoCase("Forgot tokens from 1 message(s)", salearnresult)>
                    
        <cfset session.successforgetmessage=#successforgetmessage#+1>
        <cfset session.successforgetmessage_email= successforgetmessage_email & "#getmsg.subject# <br>">
        
        <!--- IF COMMAND OUTPUT DOES NOT CONTAIN Forgot Tokens from 1 message(s) THEN TRAIN FAILED --->
        <cfelse>
                    
        <cfset session.failureforgetmessage=#failureforgetmessage#+1>
        <cfset session.failureforgetmessage_email= failureforgetmessage_email & "#getmsg.subject# <br>">
                    
        </cfif>
              
    
    <cfelseif NOT fileExists(quarfile)> 

    <cfset session.failureforgetmessage=#failureforgetmessage#+1>
    <cfset session.failureforgetmessage_email= failureforgetmessage_email & "#getmsg.subject# <br>">

    <!--- /CFIF fileExists(quarfile) --->
    </cfif>
    
    <cfelseif #getmsg.recordcount# LT 1>

    <cfset session.failureforgetmessage=#failureforgetmessage#+1>
    <cfset session.failureforgetmessage_email= failureforgetmessage_email & "#getmsg.subject# <br>">
    
    <!--- /CFIF #getmsg.recordcount# --->
    </cfif>