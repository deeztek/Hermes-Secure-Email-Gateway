
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


<cfparam name = "session.invalid" default = "0">
<cfparam name = "session.invalid_entry" default = "">
<cfparam name = "session.exists" default = "0">
<cfparam name = "session.exists_entry" default = "">
<cfparam name = "session.success" default = "0">
<cfparam name = "session.success_entry" default = "">


  <!--- START LOOP --->
  <cfloop index="d" list="#form.domain#" delimiters="#chr(10)#">

    <!--- SET DOMAIN VARIABLE --->
    <cfoutput>
    <cfset domain = #LCase(d)#>
    <cfset domain = #trim(domain)#>
    </cfoutput>
    
    <!--- CHECK IF DOMAIN IS EMPTY --->
    <cfif #domain# is "">
    

    
    <cfelse>
    
      <!--- CHECK IF VALID DOMAIN --->
      <cfset tempemail="bob@#domain#">
    
      <cfif IsValid("email", tempemail)>
    
          <!--- CHECK IF DOMAIN EXISTS --->
        <cfoutput>
          <cfquery name="checkentry" datasource="hermes">
          select entry from dkim_bypass where entry = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain#">
          </cfquery>
          </cfoutput>
        
          <cfif #checkentry.recordcount# LT 1>
    
    
    <!--- INSERT DOMAIN --->
    <cfoutput>
    <cfquery name="insert" datasource="hermes">
    insert into dkim_bypass
    (entry, note, applied, action)
    values
    ('#domain#', '#form.note#', '1', 'NONE')
    </cfquery>
    </cfoutput>

    <cfset session.success=#session.success#+1>
    <cfset session.success_entry="#session.success_entry# #domain#<br>">
          
        
        
        <cfelseif #checkentry.recordcount# GTE 1>
       
          <cfset session.errormessage=3>
          <cfset session.exists=#session.exists#+1>
          <cfset session.exists_entry="#session.exists_entry# #domain#<br>">
        
           <!--- /CFIF #checkentry.recordcount# --->
          </cfif>
        
    
        <cfelseif NOT IsValid("email", tempemail)>
    
        <cfset session.errormessage=3>
        <cfset session.invalid=#session.invalid#+1>
        <cfset session.invalid_entry="#session.invalid_entry# #domain#<br>">
    
         <!--- /CFIF IsValid("email", recipient) --->
        </cfif>
        
    
    <!--- /CFIF #domain# is "" --->
    </cfif>
    
    <!--- /CFLOOP index="d" --->
    </cfloop>
  
 