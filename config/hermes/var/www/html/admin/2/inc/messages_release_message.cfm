
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


<cfparam name = "successreleasemessage" default = "0">
  <cfif StructKeyExists(session, "successreleasemessage")>
  <cfif session.successreleasemessage is not "">
  <cfset successreleasemessage = session.successreleasemessage>
  
  <!--- /CFIF for session.successreleasemessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successreleasemessage --->
  </cfif>

  <cfparam name = "successreleasemessage_email" default = "">
  <cfif StructKeyExists(session, "successreleasemessage_email")>
  <cfif session.successreleasemessage_email is not "">
  <cfset successreleasemessage_email = session.successreleasemessage_email>
  
  <!--- /CFIF for session.successreleasemessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.successreleasemessage_email --->
  </cfif>

  <cfoutput>Success Release Message: #successreleasemessage#</cfoutput><br>
  
  <cfparam name = "failurereleasemessage" default = "0">
  <cfif StructKeyExists(session, "failurereleasemessage")>
  <cfif session.failurereleasemessage is not "">
  <cfset failurereleasemessage = session.failurereleasemessage>
  
  <!--- /CFIF for session.failurereleasemessage is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurereleasemessage --->
  </cfif>

  <cfoutput>Failure Release Message: #failurereleasemessage#</cfoutput><br>
  
  <cfparam name = "failurereleasemessage_email" default = "">
  <cfif StructKeyExists(session, "failurereleasemessage_email")>
  <cfif session.failurereleasemessage_email is not "">
  <cfset failurereleasemessage_email = session.failurereleasemessage_email>
  
  <!--- /CFIF for session.failurereleasemessage_email is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.failurereleasemessage_email --->
  </cfif>

<cfquery name="getmsg" datasource="hermes">
    select quar_loc, subject from msgs where mail_id like binary '#getemail.mail_id#' and secret_id like binary '#getemail.secret_id#'
    </cfquery>
    
    <cfquery name="getrid" datasource="hermes">
    select rid from msgrcpt where mail_id like binary '#getemail.mail_id#'
    </cfquery>
    
    <cfquery name="getrec" datasource="hermes">
    select email from maddr where id='#getrid.rid#'
    </cfquery>
    
    <cfif #getmsg.recordcount# GTE 1>

    <cfset quarfile="/mnt/data/amavis/#getmsg.quar_loc#">

    <cfif fileExists(quarfile)> 
    

        <cffile action="read" file="/opt/hermes/scripts/amavis_release_message.sh" variable="temp">

        <cffile action = "write"
            file = "/opt/hermes/tmp/#customtrans3#_amavis_release_message.sh"
            output = "#REReplace("#temp#","THE-QUAR-LOC","#getmsg.quar_loc#","ALL")#" addnewline="no">
        
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_release_message.sh" variable="temp">
        
        <cffile action = "write"
            file = "/opt/hermes/tmp/#customtrans3#_amavis_release_message.sh"
            output = "#REReplace("#temp#","THE-SECRET-ID","#getemail.secret_id#","ALL")#" addnewline="no">
        
        <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_amavis_release_message.sh" variable="temp">
        
        <cffile action = "write"
            file = "/opt/hermes/tmp/#customtrans3#_amavis_release_message.sh"
            output = "#REReplace("#temp#","THE-RECIPIENT","#getrec.email#","ALL")#" addnewline="no">
        
            <cftry>

                <cfexecute name = "/bin/chmod"
                arguments="+x /opt/hermes/tmp/#customtrans3#_amavis_release_message.sh"
                timeout = "60">
                </cfexecute>
                    
            <cfcatch type="any">
                
            <cfset m="Messages Release message: There was an error making /opt/hermes/amavis_release_message.sh executable">
            <cfinclude template="error.cfm">
            <cfabort>   
                
            </cfcatch>
            </cftry>
        
        
            <cftry>

                <cfexecute name = "/opt/hermes/tmp/#customtrans3#_amavis_release_message.sh"
                timeout = "240"
                variable ="release"
                arguments="">
                </cfexecute>
                    
            <cfcatch type="any">
                
            <cfset m="Messages Release message: There was an error executing /opt/hermes/tmp/amavis_release_message.sh">
            <cfinclude template="error.cfm">
            <cfabort>   
                
            </cfcatch>
            </cftry>
        
     
        <!--- DELETE SCRIPT --->
        <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_amavis_release_message.sh">
        
        <cfif fileExists(FiletoDelete)> 
        <cfoutput>
        <cffile action="delete" 
        file = "#FiletoDelete#">
        </cfoutput>
        
        <!--- /CFIF fileExists(FiletoDelete) --->
        </cfif>
        
        
         <!--- IF COMMAND OUTPUT CONTAINS Message received THEN RELEASE SUCCEEDED --->
         <cfif FindNoCase("Message received", release)>
                    
        <cfset session.successreleasemessage=#successreleasemessage#+1>
        <cfset session.successreleasemessage_email= successreleasemessage_email & "#getmsg.subject# <br>">
        
        <!--- IF COMMAND OUTPUT DOES NOT CONTAIN Message received THEN RELEASE FAILED --->
        <cfelse>
                    
        <cfset session.failurereleasemessage=#failurereleasemessage#+1>
        <cfset session.failurereleasemessage_email= failurereleasemessage_email & "#getmsg.subject# <br>">
                    
        </cfif>
              
    
    <cfelseif NOT fileExists(quarfile)> 

    <cfset session.failurereleasemessage=#failurereleasemessage#+1>
    <cfset session.failurereleasemessage_email= failurereleasemessage_email & "#getmsg.subject# <br>">

    <!--- /CFIF fileExists(quarfile) --->
    </cfif>
    
    <cfelseif #getmsg.recordcount# LT 1>

    <cfset session.failurereleasemessage=#failurereleasemessage#+1>
    <cfset session.failurereleasemessage_email= failurereleasemessage_email & "#getmsg.subject# <br>">
    
    <!--- /CFIF #getmsg.recordcount# --->
    </cfif>