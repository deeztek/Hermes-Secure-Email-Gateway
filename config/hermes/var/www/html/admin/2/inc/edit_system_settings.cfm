
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<cfif NOT StructKeyExists(form, "postmaster")>

<cfset m="Edit System Settings: form.postmaster does not exist">
<cfinclude template="error.cfm">
<cfabort>

<cfelseif StructKeyExists(form, "postmaster")>
  
  <cfif #form.postmaster# is "">

    <cfset step=0>
    <cfset session.m=2>
            
    <cfoutput>
    <cflocation url="view_system_settings.cfm" addtoken="no">
    </cfoutput>
  
  <cfelseif #form.postmaster# is not "">
      
  <cfif IsValid("email", form.postmaster)>

  <cfset domainpart = #trim(ListGetAt(form.postmaster, 2, "@"))#>

  <cfquery name="checkdomain" datasource="hermes">
select domain from domains where domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domainpart#">
  </cfquery>

<cfif #checkdomain.recordcount# GTE 1>

<cfset step=1>

<cfelseif #checkdomain.recordcount# LT 1>
      
  <cfset step=0>
  <cfset session.m=4>
          
  <cfoutput>
  <cflocation url="view_system_settings.cfm" addtoken="no">
  </cfoutput>

<!--- /CFIF #checkdomain.recordcount# --->
</cfif>
      
<cfelseif not IsValid("email", form.postmaster)>

  <cfset step=0>
  <cfset session.m=3>
          
  <cfoutput>
  <cflocation url="view_system_settings.cfm" addtoken="no">
  </cfoutput>

<!--- /CFIF IsValid("email", form.postmaster) --->
</cfif>
  
<!--- /CFIF  #form.postmaster# is --->
</cfif>
    
<!--- /CFIF StructKeyExists(form, "postmaster") --->
</cfif>

<cfif #step# is "1">

  <cfif NOT StructKeyExists(form, "admin_email")>

    <cfset m="Edit System Settings: form.admin_email does not exist">
    <cfinclude template="error.cfm">
    <cfabort>
    
    <cfelseif StructKeyExists(form, "admin_email")>
      
      <cfif #form.admin_email# is "">
    
        <cfset step=0>
        <cfset session.m=5>
                
        <cfoutput>
        <cflocation url="view_system_settings.cfm" addtoken="no">
        </cfoutput>
      
      <cfelseif #form.admin_email# is not "">
          
      <cfif IsValid("email", form.admin_email)>
    
    <cfset step=2>
             
    <cfelseif not IsValid("email", admin_email)>
    
      <cfset step=0>
      <cfset session.m=6>
              
      <cfoutput>
      <cflocation url="view_system_settings.cfm" addtoken="no">
      </cfoutput>
    
    <!--- /CFIF IsValid("email", admin_email) --->
    </cfif>
      
    <!--- /CFIF  #form.admin_email# is --->
    </cfif>
        
    <!--- /CFIF StructKeyExists(form, "admin_email") --->
    </cfif>

<!--- /CFIF step is 1 --->
</cfif>


<cfif #step# is "2">


  <cfif NOT StructKeyExists(form, "timezone")>

    <cfset m="Edit System Settings: form.timezone does not exist">
    <cfinclude template="error.cfm">
    <cfabort>
    
    <cfelseif StructKeyExists(form, "timezone")>
      
      <cfif #form.timezone# is "">
    
        <cfset step=0>
        <cfset session.m=7>
                
        <cfoutput>
        <cflocation url="view_system_settings.cfm" addtoken="no">
        </cfoutput>
      
      <cfelseif #form.timezone# is not "">
          
  <cfquery name="checktimezone" datasource="hermes">
  select timezone from timezones where timezone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.timezone#">
  </cfquery>

<cfif #checktimezone.recordcount# GTE 1>

    <cfset step=3>
             
    <cfelseif  #checktimezone.recordcount# LT 1>
    
      <cfset step=0>
      <cfset session.m=8>
              
      <cfoutput>
      <cflocation url="view_system_settings.cfm" addtoken="no">
      </cfoutput>
    
    <!--- /CFIF #checktimezone.recordcount# --->
    </cfif>
      
    <!--- /CFIF  #form.timezone# is --->
    </cfif>
        
    <!--- /CFIF StructKeyExists(form, "timezone") --->
    </cfif>
  
  <!--- /CFIF for step 2 --->
  </cfif>


  <cfif #step# is "3">


    <cfif NOT StructKeyExists(form, "update_check")>
  
      <cfset m="Edit System Settings: form.update_check does not exist">
      <cfinclude template="error.cfm">
      <cfabort>
      
      <cfelseif StructKeyExists(form, "update_check")>
        
<cfif #form.update_check# is "1" OR #form.update_check# is "2">
      
<cfset step=4>
        
        <cfelse>
            
          <cfset m="Edit System Settings: form.update_check is not 1 or 2">
          <cfinclude template="error.cfm">
          <cfabort>
        
      <!--- /CFIF  #form.update_check# is --->
      </cfif>
          
      <!--- /CFIF StructKeyExists(form, "update_check") --->
      </cfif>
    
    <!--- /CFIF for step 3 --->
    </cfif>
  

    <cfif #step# is "4">


      <cfif NOT StructKeyExists(form, "telemetry")>
    
        <cfset m="Edit System Settings: form.telemetry does not exist">
        <cfinclude template="error.cfm">
        <cfabort>
        
        <cfelseif StructKeyExists(form, "telemetry")>
          
  <cfif #form.telemetry# is "1" OR #form.telemetry# is "2">
        
  <cfset step=5>
          
          <cfelse>
              
            <cfset m="Edit System Settings: form.telemetry is not 1 or 2">
            <cfinclude template="error.cfm">
            <cfabort>
          
        <!--- /CFIF  #form.telemetry# is --->
        </cfif>
            
        <!--- /CFIF StructKeyExists(form, "telemetry") --->
        </cfif>
      
      <!--- /CFIF for step 4 --->
      </cfif>
    
  

<cfif #step# is "5">
  
<cfinclude template="update_system_email_addresses.cfm">
<cfinclude template="update_system_timezone.cfm">
<cfinclude template="update_system_update_check.cfm">
<cfinclude template="update_telemetry.cfm">

<!--- /CFIF for step 4 --->
</cfif>





    
  
