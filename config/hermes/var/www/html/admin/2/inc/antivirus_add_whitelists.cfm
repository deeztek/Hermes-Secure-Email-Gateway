
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->


<cfparam name = "errormessage" default = "0">
<cfif StructKeyExists(session, "errormessage")>
  <cfif session.errormessage is not "">
  <cfset errormessage = session.errormessage>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.errormessage#</cfoutput>
--->

  <!--- /CFIF for session.errormessage is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.errormessage --->
</cfif>


<cfparam name = "step" default = "0">
<cfparam name = "session.invalid" default = "0">
<cfparam name = "session.invalid_entry" default = "">
<cfparam name = "session.exists" default = "0">
<cfparam name = "session.exists_entry" default = "">
<cfparam name = "session.success" default = "0">
<cfparam name = "session.success_entry" default = "">


  <!--- START LOOP --->
  <cfloop index="w" list="#form.whitelist#" delimiters="#chr(10)#">

    <!--- SET HOST VARIABLE --->
    <cfoutput>
    <cfset whitelist = #trim(w)#>
    </cfoutput>
    
    <!--- CHECK IF HOST IS EMPTY --->
  <cfif #whitelist# is "">
    
  <cfelseif #whitelist# is not "">

   <cfset step=1>


<cfif #step# is "1">

    <!--- CHECK IF WHITELIST ENTRY EXISTS --->
    <cfoutput>
     <cfquery name="checkentry" datasource="hermes">
     select parameter, module from parameters2 where parameter = '#whitelist#' and module = 'clamav-bypass'
     </cfquery>
     </cfoutput>

     <cfif #checkentry.recordcount# LT 1>


<!--- INSERT WHITELIST --->
<cfoutput>
<cfquery name="insert" datasource="hermes">
insert into parameters2
(parameter, module, active, applied)
values
('#whitelist#', 'clamav-bypass', '1', '1')
</cfquery>
</cfoutput>

<cfset session.success=#session.success#+1>
<cfset session.success_entry="#session.success_entry# #whitelist#<br>">
         
   
   <cfelseif #checkentry.recordcount# GTE 1>

     <cfset step=0>
     <cfset session.errormessage=3>
     <cfset session.exists=#session.exists#+1>
     <cfset session.exists_entry="#session.exists_entry# #whitelist#<br>">
   

<cfelse>

<cfset session.errormessage=3>
<cfset session.invalid=#session.invalid#+1>
<cfset session.invalid_entry="#session.invalid_entry# #whitelist#<br>">

<!--- /CFIF checkentry.recordcount --->
</cfif>


<!--- /CFIF #step# is "1" --->
</cfif>




      <!--- /CFIF #whitelist# is "" --->
    </cfif>
    
    <!--- /CFLOOP index="w" --->
    </cfloop>
 