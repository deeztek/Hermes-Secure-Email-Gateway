
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

<cfinclude template="/admin/2/inc/generate_customtrans.cfm">


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
    select quar_loc, subject from msgs where mail_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ToString(getemail.mail_id)#"> and secret_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ToString(getemail.secret_id)#">
    </cfquery>
    
    <cfquery name="getrid" datasource="hermes">
    select rid from msgrcpt where mail_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ToString(getemail.mail_id)#">
      AND rid = <cfqueryparam cfsqltype="cf_sql_integer" value="#getemail.rid#"> <!--- the signed-in user's own row --->
    </cfquery>
    
    <cfquery name="getrec" datasource="hermes">
    select email from maddr where id=<cfqueryparam cfsqltype="cf_sql_integer" value="#getrid.rid#">
    </cfquery>
    
    <cfif #getmsg.recordcount# GTE 1>

    <cfset quarfile="/mnt/data/amavis/#getmsg.quar_loc#">

    <cfif fileExists(quarfile)> 
    

        <!--- SECURITY: amavisd-release is called directly with an argument array:
             no script, no shell. The recipient comes from the message envelope
             and may legally contain ` | $ &, so every value is also checked
             against a strict pattern; anything else counts as a failed release. --->
        <cfset release = "">
        <cfset relQ = ToString(getmsg.quar_loc)>
        <cfset relS = ToString(getemail.secret_id)>
        <!--- not lowercased: amavisd-release only releases to a recipient that
             matches the original exactly, case included --->
        <cfset relR = Trim(ToString(getrec.email))>
        <cfif REFind("^[A-Za-z0-9._/+-]{1,255}$", relQ) GT 0 AND Find("..", relQ) EQ 0
              AND REFind("^[A-Za-z0-9+/_=-]{1,64}$", relS) GT 0
              AND REFind("^[A-Za-z0-9._%+=-]{1,64}@[A-Za-z0-9.-]{1,253}$", relR) GT 0
              AND Left(relR, 1) NEQ "-">
            <cftry>
                <!--- The three values are passed as $1 $2 $3: the shell never parses
                     them. The shell is only there for 2>&1, because Lucee 6.2 drops
                     errorVariable (and can throw) when a program writes to stderr,
                     and amavisd-release reports its result there. --->
                <cfset relCmd = 'exec /usr/local/bin/docker exec hermes_mail_filter /usr/sbin/amavisd-release "$1" "$2" "$3" 2>&1'>
                <cfexecute name="/bin/sh"
                    arguments="#['-c', relCmd, 'amavisd-release', relQ, relS, relR]#"
                    timeout="240" variable="release" />
            <cfcatch type="any">
            <cflog file="hermes" type="error" text="amavisd-release failed for user release: #cfcatch.message# #cfcatch.detail#">
            <cfset m="Messages Release message: There was an error executing amavisd-release">
            <cfinclude template="error.cfm">
            <cfabort>
            </cfcatch>
            </cftry>
        </cfif>

        
        
         <!--- Check for success: amavisd-release returns "250 2.0.0" on success via docker exec --->
         <cfif FindNoCase("250 2.0.0", release)>
        <cfset session.successreleasemessage=#successreleasemessage#+1>
        <cfset session.successreleasemessage_email= successreleasemessage_email & "#EncodeForHTML(getmsg.subject)# <br>">
         <cfelse>
        <cfset session.failurereleasemessage=#failurereleasemessage#+1>
        <cfset session.failurereleasemessage_email= failurereleasemessage_email & "#EncodeForHTML(getmsg.subject)# <br>">
         </cfif>
              
    
    <cfelseif NOT fileExists(quarfile)> 

    <cfset session.failurereleasemessage=#failurereleasemessage#+1>
    <cfset session.failurereleasemessage_email= failurereleasemessage_email & "#EncodeForHTML(getmsg.subject)# <br>">

    <!--- /CFIF fileExists(quarfile) --->
    </cfif>
    
    <cfelseif #getmsg.recordcount# LT 1>

    <cfset session.failurereleasemessage=#failurereleasemessage#+1>
    <cfset session.failurereleasemessage_email= failurereleasemessage_email & "#EncodeForHTML(getmsg.subject)# <br>">
    
    <!--- /CFIF #getmsg.recordcount# --->
    </cfif>