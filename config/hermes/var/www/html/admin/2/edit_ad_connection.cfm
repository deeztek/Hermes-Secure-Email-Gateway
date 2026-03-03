<!DOCTYPE html>

  
  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
 
 --->
 
<html lang="en">


<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Edit Active Directory Connection</title>

  <cfinclude template="./inc/html_head.cfm" />
<!--- SCRIPT TO SHOW/HIDE DOMAIN USER PASSWORD --->
  <script>

    $(document).ready(function() {
        $("#domainuserpassword a").on('click', function(event) {
            event.preventDefault();
            if($('#domainuserpassword input').attr("type") == "text"){
                $('#domainuserpassword input').attr('type', 'password');
                $('#domainuserpassword i').addClass( "fa-eye-slash" );
                $('#domainuserpassword i').removeClass( "fa-eye" );
            }else if($('#domainuserpassword input').attr("type") == "password"){
                $('#domainuserpassword input').attr('type', 'text');
                $('#domainuserpassword i').removeClass( "fa-eye-slash" );
                $('#domainuserpassword i').addClass( "fa-eye" );
            }
        });
    });
    
      </script>

<!--- STYLE FOR EYE-SLASH STARTS HERE --->    
<style>
  td {
   word-break: break-all;
       },

body{
 padding:100px 0;
 background-color:#efefef
}

a, a:hover{
 color:#333
}

</style>
<!--- STYLE FOR EYE-SLASH ENDS HERE --->  

</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  
  


  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper. Contains page content -->
  <main class="app-main">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <cfoutput>
            <h1 class="m-0">Edit Active Directory Connection</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Edit Active Directory Connection</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

  <!--- Pro Edition License Check --->
  <cfinclude template="./inc/license_check.cfm" />

  <!--- PRO EDITION CHECK --->
  <cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
      <cfset proFeatureName = "AD Integration">
      <cfinclude template="./inc/license_pro_required.cfm">
      <cfabort>
  </cfif>

<!--- CFML CODE STARTS HERE --->

<cfparam name = "step" default = "0"> 

<cfparam name = "m" default = "0">
<cfif StructKeyExists(session, "m")>
<cfif session.m is not "">
<cfset m = session.m>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>#session.m#</cfoutput>
--->

<!--- /CFIF for session.m is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.m --->
</cfif>

<!---
<cfoutput>session M: #m#</cfoutput>
--->

<cfparam name = "action" default = ""> 
<cfif StructKeyExists(form, "action")>
<cfif form.action is not "">
<cfset action = form.action>

<!--- /CFIF form.action is not "" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "action")> --->
</cfif>

<cfparam name = "theID" default = ""> 
<cfif StructKeyExists(url, "id")>
<cfif url.id is not "">
<cfif IsValid("integer", url.id)>
<cfset theID = url.id>
<cfelse>
<cfset m="Edit AD Connection: url.id not valid interger">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF isValid("integer", form.id) --->
</cfif>

<cfelseif url.id is "">
  <cfset m="Edit AD Connection: url.id is blank">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF url.id is "" --->
</cfif>

<cfelseif NOT StructKeyExists(url, "id")>
<cfset m="Edit AD Connection: url.id does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF StructKeyExists(url, "id") --->
</cfif> 

<cfquery name="getadconnection" datasource="hermes">
select * from ad_integration where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getadconnection.recordcount# LT 1>

<cfset m="Edit AD Connection: getadconnection.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>
</cfif>

<cfparam name = "show_schedule" default = "#getadconnection.scheduled#"> 


<cfparam name = "show_interval" default = "#getadconnection.scheduled_interval#"> 

<cfparam name = "show_entry_name" default = "#getadconnection.entry_name#"> 

<cfparam name = "show_dc_name" default = "#getadconnection.dc_name#"> 

<cfparam name = "show_fqdn_domain" default = "#getadconnection.fqdn_domain#"> 

<!--- DECRYPTION MECHANISM FOR USERNAME/PASSWORD --->

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<!-- DECRYPT USERNAME & PASSWORD -->
<cfset decryptedUsername=decrypt(getadconnection.username, #theKey#, "AES", "Base64")>
<cfset decryptedPassword=decrypt(getadconnection.password, #theKey#, "AES", "Base64")>

<cfparam name = "show_username" default = "#decryptedUsername#"> 

<cfparam name = "show_password" default = "#decryptedPassword#"> 

<cfparam name = "show_netbios" default = "#getadconnection.netbios_domain#"> 

<cfparam name = "show_objectclass" default = "#getadconnection.objectclass#"> 


<cfif #action# is "edit">

<!--- VALIDATE FORM INPUTS STARTS HERE --->
<cfif NOT StructKeyExists(form, "entry_name")>

  <cfset m="Edit Active Directory Connection: form.entry_name does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "entry_name") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "dc_name")>
  
  <cfset m="Edit Active Directory Connection: form.dc_name does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "dc_name") --->
  </cfif>

    
  <cfif NOT StructKeyExists(form, "fqdn_domain")>
  
  <cfset m="Edit Active Directory Connection: form.fqdn_domain does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
    
  <!--- /CFIF StructKeyExists(form, "fqdn_domain") --->
  </cfif>
    
  
    
<cfif NOT StructKeyExists(form, "object_class")>
  
<cfset m="Edit Active Directory Connection: form.object_class does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelse>

<cfif form.object_class is "user" OR form.object_class is "organizationalPerson" OR form.object_class is "person" OR form.object_class is "top">

<cfelse>
  
<cfset m="Edit Active Directory Connection: form.object_class is not user, organizationalPerson, person or top">
<cfinclude template="./inc/error.cfm">
<cfabort>
  
<!--- /CFIF form.object_class is "user" OR form.object_class is "organizationalPerson" OR form.object_class is "person" OR form.object_class is "top" --->
</cfif>
      
<!--- /CFIF StructKeyExists(form, "object_class") --->
</cfif>

<cfif NOT StructKeyExists(form, "netbios")>
  
<cfset m="Edit Active Directory Connection: form.netbios does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>
    
<!--- /CFIF StructKeyExists(form, "netbios") --->
</cfif>

<cfif NOT StructKeyExists(form, "username")>
  
<cfset m="Edit Active Directory Connection: form.username does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>
      
<!--- /CFIF StructKeyExists(form, "username") --->
</cfif>

<cfif NOT StructKeyExists(form, "password")>
  
<cfset m="Edit Active Directory Connection: form.password does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>
        
<!--- /CFIF StructKeyExists(form, "password") --->
</cfif>

<cfif NOT StructKeyExists(form, "schedule")>
  
  <cfset m="Edit Active Directory Connection: form.schedule does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <cfelse>
  
  <cfif form.schedule is "1" OR form.schedule is "2">
  
  <cfelse>
    
  <cfset m="Edit Active Directory Connection: form.schedule is not 1 or 2">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
    
  <!--- /CFIF form.schedule is "1" OR form.schedule is "2" --->
  </cfif>
        
  <!--- /CFIF StructKeyExists(form, "schedule") --->
  </cfif>

  <cfif NOT StructKeyExists(form, "interval")>
  
    <cfset m="Edit Active Directory Connection: form.interval does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    
    <cfelse>
    
    <cfif form.interval is "15 */1 * * *" OR form.interval is "15 */2 * * *" OR form.interval is "15 */4 * * *" OR form.interval is "15 */8 * * *" OR form.interval is "15 */12 * * *" OR form.interval is "30 0 * * *">
    
    <cfelse>
      
    <cfset m="Edit Active Directory Connection: form.interval is not set to 1, 2, 4, 8, 12 or 24 Hours">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
      
    <!--- /CFIF form.interval is "15 */1 * * *" OR form.interval is "15 */2 * * *" OR form.interval is "15 */4 * * *" OR form.interval is "15 */8 * * *" OR form.interval is "15 */12 * * *" OR form.interval is "30 0 * * *" --->
    </cfif>
          
    <!--- /CFIF StructKeyExists(form, "interval") --->
    </cfif>
  

<!--- VALIDATE FORM INPUTS ENDS HERE --->

<cfif #form.entry_name# is not "">

<cfif REFind("[^_a-zA-Z0-9\-\_]",form.entry_name) gt 0>

<cfset step=0>
<cfset session.m=6>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>
  
<!--- UPDATE FIELD --->
<cfquery name = "updateconnection" datasource="hermes">
update ad_integration set
entry_name = '#form.entry_name#'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfset step=1>

<!--- REFind("[^_a-zA-Z0-9\-\_]",form.entry_name) gt 0 --->
</cfif>

<cfelseif #form.entry_name# is "">

<cfset step=0>
<cfset session.m=7>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF #form.entry_name# is/is not "" --->
</cfif>




<cfif #step# is "1" and #form.dc_name# is not "">

<cfif REFind("[^_a-zA-Z0-9\_\-\.]",form.dc_name) gt 0>

<cfset step=0>
<cfset session.m=8>


<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

 <!--- UPDATE FIELD --->
<cfquery name = "updateconnection" datasource="hermes">
update ad_integration set
dc_name = '#form.dc_name#'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfset step=2>

</cfif>

<cfelseif #step# is "1" and #form.dc_name# is "">

<cfset step=0>
<cfset session.m=9>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF #step# is "1" --->
</cfif>


<cfif #step# is "2" and #form.fqdn_domain# is not "">

<cfif REFind("[^_a-zA-Z0-9\_\-\=\,\.]",form.fqdn_domain) gt 0>

<cfset step=0>
<cfset session.m=10>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

 <!--- UPDATE FIELD --->
 <cfquery name = "updateconnection" datasource="hermes">
  update ad_integration set
  fqdn_domain = '#form.fqdn_domain#'
  where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>
  

<cfset step=3>


</cfif>

<cfelseif #step# is "2" and #form.fqdn_domain# is "">
<cfset step=0>
<cfset session.m=11>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF #step# is "2 --->"
</cfif>

<cfif #step# is "3">

<cfquery name = "updateconnection" datasource="hermes">
update ad_integration set
objectclass = '#form.object_class#'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfset step = 4>

<!--- /CFIF for step --->
</cfif>

<cfif #step# is "4" and #form.netbios# is not "">
<cfif REFind("[^_a-zA-Z0-9\_\-\.]",form.netbios) gt 0>

<cfset step=0>
<cfset session.m=18>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

<!--- UPDATE FIELD --->
<cfquery name = "updateconnection" datasource="hermes">
update ad_integration set
netbios_domain = '#form.netbios#'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfset step=5>

</cfif>

<cfelseif #step# is "4" and #form.netbios# is "">

<cfset step=0>
<cfset session.m=19>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

</cfif>


<cfif #step# is "5" and #form.username# is not "">

<cfif REFind("[^_a-zA-Z0-9\_\-\.]",form.username) gt 0>

<cfset step=0>
<cfset session.m=12>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

<!--- ENCRYPTION MECHANISM FOR USERNAME/PASSWORD --->

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<!-- ENCRYPT USERNAME -->
<cfset encryptedUsername=encrypt(form.username, #theKey#, "AES", "Base64")>

<!--- UPDATE FIELD --->
<cfquery name = "updateconnection" datasource="hermes">
  update ad_integration set
  username = '#encryptedUsername#'
  where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

<cfset step=6>

</cfif>

<cfelseif #step# is "5" and #form.username# is "">
<cfset step=0>
<cfset session.m=13>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

</cfif>




<cfif #step# is "6" and #form.password# is not "">

<cfset step=7>

<cfelseif #step# is "6" and  #form.password# is "">

<cfset step=0>
<cfset session.m=14>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

</cfif>


<cfif step is "7">

<cftry>

<cfldap action="query" name="adresult"
attributes = "mail"
START="#form.fqdn_domain#"
filter="(&(objectClass=#form.object_class#)(mail=*))"
server="#form.dc_name#"
port="389"
username="#form.netbios#\#form.username#"
password="#form.password#">


<cfcatch type="any">

<cfif #cfcatch.type# contains "javax.naming.AuthenticationException">
<cfset step=0>
<cfset session.m=1>
<cfelseif #cfcatch.type# contains "javax.naming.CommunicationException">
<cfset step=0>
<cfset session.m=2>
<cfelseif #cfcatch.type# contains "javax.naming.InvalidNameException">
<cfset step=0>
<cfset session.m=15>
<cfelseif #cfcatch.type# contains "javax.naming.NamingException">
<cfset step=0>
<cfset session.m=15> 	
<cfelse>
<cfset step=0>
<cfset session.m=4>
</cfif>

</cfcatch>

<cfif #adresult.recordcount# GTE 1>

<cfset step=8>

<cfelseif #adresult.recordcount# LT 1>

<cfset step=0>
<cfset session.m=3>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

</cfif>

</cftry>



<!--- /CFIF STEP is "7" --->
</cfif>

<cfif step is "8">
  
<cfquery name="check" datasource="hermes">
select id, entry_name from ad_integration where entry_name='#form.entry_name#' and id <> '#theID#'
</cfquery>

<cfif #check.recordcount# LT 1>

<!--- ENCRYPTION MECHANISM FOR USERNAME/PASSWORD --->

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<!-- ENCRYPT PASSWORD -->
<cfset encryptedPassword=encrypt(form.password, #theKey#, "AES", "Base64")>


<cfquery name="updatead" datasource="hermes" result="adResult">
update ad_integration
set
password='#encryptedPassword#'
where id='#theID#'
</cfquery>

<cfif #form.schedule# is "1">

<cfquery name="schedulead" datasource="hermes">
update ad_integration set
scheduled='1',
scheduled_interval='#form.interval#'
where id='#theID#'
</cfquery>

<cfinclude template="./inc/set_crontab.cfm">

<cfinclude template="./inc/generate_customtrans.cfm">


<cffile action="read" file="/opt/hermes/templates/ad_scheduled_task.cfm" variable="adtask">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_ad_scheduled_task.cfm"
    output = "#REReplace("#adtask#","DN_NAME","#form.fqdn_domain#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_ad_scheduled_task.cfm" variable="adtask">


<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_ad_scheduled_task.cfm"
    output = "#REReplace("#adtask#","SERVER_NAME","#form.dc_name#","ALL")#"> 

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_ad_scheduled_task.cfm" variable="adtask">
    
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_ad_scheduled_task.cfm"
    output = "#REReplace("#adtask#","USER_NAME","#form.netbios#\#form.username#","ALL")#"> 
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_ad_scheduled_task.cfm" variable="adtask">

<!--- CREATE AD CONNECTION CRON FILE --->
<cfinclude template="./inc/create_ad_connection_cron_file.cfm">

<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_ad_scheduled_task.cfm">

<cfif fileExists(FiletoDelete)>
<cffile action = "delete" file = "#FiletoDelete#"> 
<!--- /CFIF fileExists --->
</cfif>

<cfelseif #form.schedule# is "2">

<cfquery name="schedulead" datasource="hermes">
  update ad_integration set
  scheduled=2,
  scheduled_interval=NULL
  where id='#theID#'
  </cfquery>

<!--- DELETE EXISTING /ETC/CRON.D/ AD JOB STARTS HERE ---> 
<cfset FiletoDelete="/etc/cron.d/hermes_adjob_#show_entry_name#">

<cfif fileExists(FiletoDelete)>
<cffile action = "delete" file = "#FiletoDelete#"> 
<!--- /CFIF fileExists --->
</cfif>

<!--- DELETE EXISTING /ETC/CRON.D/ AD JOB ENDS HERE ---> 
  
<cfinclude template="./inc/set_crontab.cfm">
  

<!--- /CFIF form.schedule# --->
</cfif>

<cfset action="">
<cfset session.m=16>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelseif #check.recordcount# GTE 1>

<cfset session.m=17>

<cfoutput>
<cflocation url="edit_ad_connection.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF check.recordcount --->
</cfif>

<!--- /CFIF step is 8 --->
</cfif>

<cfelseif #action# is "deleteconnection">

  <cfif NOT StructKeyExists(form, "connection")>
    <cfset m="Delete AD Connection: form.connection does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    <cfelseif StructKeyExists(form, "connection")>
    <cfif #form.connection# is "">
    <cfset m="Delete AD Connection: form.connection is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    <cfelseif #form.connection# is not "">
    <cfset theConnection = #form.connection#>
    </cfif>
    </cfif>

    
    <cfquery name="getconnection" datasource="hermes">
      SELECT  id, entry_name, scheduled from ad_integration where id = <cfqueryparam value = #theConnection# CFSQLType = "CF_SQL_INTEGER">
      </cfquery>

  <cfif #getconnection.recordcount# GTE 1>

  <cfif #getconnection.scheduled# is "1">

      <!--- DELETE AD CONNECTION CRON FILE --->
      <cfinclude template="./inc/delete_ad_connection_cron_file.cfm">

    <!--- DELETE /ETC/CRON.D/ HERMES_ADJOB --->
  <cfset testfile="/etc/cron.d/hermes_adjob_#getconnection.entry_NAME#">
  <cfif fileExists(testfile)>
  <cffile 
  action = "delete"
  file = "#testfile#">
  </cfif>
  
  <cfquery name="delete" datasource="hermes">
  delete from ad_integration where id = <cfqueryparam value = #theConnection# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>
  
  <cfinclude template="./inc/set_crontab.cfm">
  
  <cfset session.m = 2>

<cflocation url="view_ad_connection.cfm" addtoken="no">


<cfelseif #getconnection.scheduled# is not "1">

  <cfquery name="delete" datasource="hermes">
  delete from ad_integration where id = <cfqueryparam value = #theConnection# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

<cfset session.m = 2>

<cflocation url="view_ad_connection.cfm" addtoken="no">
  
  <!--- /CFIF #getconnection.scheduled# --->
    </cfif>

<cfelse>

<cfset session.m=20>

<!--- /CFIF #getconnection.recordcount# GTE 1 --->
    </cfif>

<!--- /CFIF #action# --->
</cfif>

<!--- CFML CODE ENDS HERE --->


<!--- ERROR MESSAGES START HERE --->

<cfif #m# is "1"> 

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>You have entered an invalid Domain Username and/or Password</cfoutput>
    </div>

    <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Domain Controller cannot be reached. Please check the IP/Host Name and ensure it's reachable via port 389</cfoutput>
    </div>

    
    <cfset session.m = 0>

</cfif>

<cfif #m# is "3">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>Unable to retrieve any SMTP addresses from Active Directory. Please check that you have entered the correct Domain Distinguished Name Root and try again</cfoutput>
    </div>

    
    <cfset session.m = 0>

</cfif>


<cfif #m# is "4">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>An undefined error has occured. Please contact support</cfoutput>
    </div>

    
    <cfset session.m = 0>

</cfif>


<cfif #m# is "5">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Connection validated. The system was able to contact the domain and obtain SMTP addresses. Please select the Save Connection radio box on top and click Submit button to permanently save you entry</cfoutput>
  </div>
      
  <cfset session.m = 0>

</cfif>

<cfif #m# is "6">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>You have entered an invalid Connection Name. Connection Name can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)</cfoutput>
    </div>

        
    <cfset session.m = 0>

</cfif>


<cfif #m# is "7">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Connection Name field cannot be empty</cfoutput>
    </div>

        
    <cfset session.m = 0>

</cfif>

<cfif #m# is "8">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>You have entered an invalid Domain Controller. The Domain Controller can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_), dashes (-) and periods (.)</cfoutput>
    </div>

        
    <cfset session.m = 0>

</cfif>


<cfif #m# is "9">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Domain Controller field must not be empty</cfoutput>
    </div>

        
    <cfset session.m = 0>

</cfif>

<cfif #m# is "10">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>You have entered an invalid Distinguished Name. The Distinguished Name can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_), dashes (-), commas (,), periods (.) and equal signs (=)</cfoutput>
    </div>

        
    <cfset session.m = 0>

</cfif>

<cfif #m# is "11">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Distinguished Name field must not be empty</cfoutput>
    </div>

        
    <cfset session.m = 0>

</cfif>



<cfif #m# is "12">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>You have entered an invalid Username. Username can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_), periods (.) and dashes (-)</cfoutput>
    </div>

        
    <cfset session.m = 0>

</cfif>


<cfif #m# is "13">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Username field must not be empty</cfoutput>
    </div>

        
    <cfset session.m = 0>

</cfif>



<cfif #m# is "14">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Password field must not be empty</strong></cfoutput>
    </div>

        
    <cfset session.m = 0>

</cfif>


<cfif #m# is "15">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Domain Distinguished Name Root you entered is invalid</strong></cfoutput>
  </div>

      
  <cfset session.m = 0>

</cfif>


    <cfif #m# is "16">

        <div class="alert alert-success alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>Changes saved.</cfoutput>
       
    </div>

        
    <cfset session.m = 0>

    </cfif>

        <cfif #m# is "17">

            <div class="alert alert-danger alert-dismissible">
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
              <h4><i class="icon fa fa-ban"></i> Oops!</h4>
              <cfoutput>The Connection you are attempting to add already exists</strong></cfoutput>
            </div>

                
    <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "18">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>You have entered an invalid Netbios Domain Name. Netbios Domain Name can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)</strong></cfoutput>
          </div>

              
    <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "19">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Netbios Domain name cannot be blank</strong></cfoutput>
        </div>

            
    <cfset session.m = 0>
    
    </cfif>

    
  <cfif #m# is "20">

    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>The Connection is not valid</cfoutput>
      </div>

          
    <cfset session.m = 0>

  </cfif>


<!--- ERROR MESSAGES END HERE --->

<span>
  <p>       

<!--- BACK TO AD CONNECTIONS BUTTON STARTS HERE --->
<a href="view_ad_connection.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to AD Connections</a>

<!--- BACK TO AD CONNECTIONS BUTTON ENDS HERE --->



<!--- DELETE CONNECTION BUTTON STARTS HERE --->



<cfoutput>
<!-- Delete Connection Button-->
<a href="##delete_modal"  class="btn btn-danger" role="button" data-bs-toggle="modal" data-connection="#theId#"><i class="fa fa-trash"></i>&nbsp;&nbsp;Delete AD Connection</a>
</cfoutput>


<!--- DELETE CONNECTION BUTTON ENDS HERE --->

</p>


</span>


<!--- DELETE CONNECTION MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteConnectionModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <!---
        <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Delete AD Connection </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you send to delete this AD Connection? This action is irreversible!</p>

      </div>
      <div class="modal-footer">
        <form name="delete_connection" method="post">

          <input type="hidden" name="action" value="deleteconnection">
          <input type="hidden" name="connection" value=""/>
          <button type="input" class="btn btn-danger" onclick="this.form.submit();">Yes</button>
          
            </form>
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>
<!--- DELETE CONNECTION MODAL HTML ENDS HERE --->





<!-- ADD AD CONNECTION FORM STARTS HERE -->


<!-- form start -->
<form name="edit_ad_connection" method="post" action="">

  <input type="hidden" name="action" value="edit">
  <cfoutput>
  <input type="hidden" name="id" value="#theID#">
  </cfoutput>
    <div class="box-body">
       
      <cfoutput>
      <div class="form-group">
        <label for="server_name"><strong>Connection Name</strong></label>
        <input type="text" class="form-control" name="entry_name" value="#show_entry_name#" id="entry_name" placeholder="Enter a friendly name for this connection">
      </div>
      </cfoutput>

      
        <cfoutput>
            <div class="form-group">
              <label for="server_domain"><strong>Domain Controller</strong></label>
              <input type="text" class="form-control" name="dc_name" value="#show_dc_name#" id="dc_name" placeholder="Enter an IP or FQDN of Domain Controller (Ex: dc1.domain.tld)">
            </div>
            </cfoutput>

            <cfoutput>
              <div class="form-group">
                <label for="fqdn_domain"><strong>Distinguished Name</strong></label>
                <input type="text" class="form-control" name="fqdn_domain" value="#show_fqdn_domain#" id="fqdn_domain" placeholder="Enter Distinguished Name (Ex: DC=domain,DC=tld)">
              </div>
              </cfoutput>       

              
            <cfif #show_objectclass# is "user">
              <div class="form-group">
                <label><strong>Object Class</strong></label>
                <select class="form-control select2" name="object_class" data-placeholder="Object Class"
                        style="width: 100%;">
                  <cfoutput><option value="user" selected="selected">user</option></cfoutput>
                  <option value="organizationalPerson">organizationalPerson</option>
                  <option value="person">person</option>
                  <option value="top">top</option>
                    </select> 
                    
                  <cfelseif #show_objectclass# is "organizationalPerson">
                      <div class="form-group">
                        <label><strong>Object Class</strong></label>
                        <select class="form-control select2" name="object_class" data-placeholder="Object Class"
                                style="width: 100%;">
                          <cfoutput><option value="organizationalPerson" selected="selected">organizationalPerson</option></cfoutput>
                          <option value="user">user</option>
                          <option value="person">person</option>
                          <option value="top">top</option>
                            </select> 

                          <cfelseif #show_objectclass# is "person">
                            <div class="form-group">
                              <label><strong>Object Class</strong></label>
                              <select class="form-control select2" name="object_class" data-placeholder="Object Class"
                                      style="width: 100%;">
                                <cfoutput><option value="person" selected="selected">person</option></cfoutput>
                                <option value="user">user</option>
                                <option value="organizationalPerson">person</option>
                                <option value="top">top</option>
                                  </select>         
                                  
                                <cfelseif #show_objectclass# is "top">
                                  <div class="form-group">
                                    <label><strong>Object Class</strong></label>
                                    <select class="form-control select2" name="object_class" data-placeholder="Object Class"
                                            style="width: 100%;">
                                      <cfoutput><option value="top" selected="selected">top</option></cfoutput>
                                      <option value="user">user</option>
                                      <option value="organizationalPerson">person</option>
                                      <option value="person">top</option>
                                        </select>           
            
                <!--- /CFIF for #show_objectclass# is --->
                </cfif>
                
                <cfoutput>
                  <div class="form-group">
                    <label for="netbios"><strong>Netbios Domain Name</strong></label>
                    <input type="text" class="form-control" name="netbios" value="#show_netbios#" id="netbios" placeholder="Enter Netbios Domain Name (Ex: MYDOMAIN)">
                  </div>
                  </cfoutput> 

                  <cfoutput>
                    <div class="form-group">
                      <label for="username"><strong>Domain User Username</strong></label>
                      <input type="text" class="form-control" name="username" value="#show_username#" id="username" placeholder="Enter a Username for a user that can enumerate objects in the Directory">
                    </div>
                    </cfoutput> 
  
                    <cfoutput>
                      <div class="form-group" id="domainuserpassword">
                        <label for="password"><strong>Domain User Password</strong></label>
                        <div class="input-group">
                        <input type="password" class="form-control" name="password" value="#show_password#" id="password" placeholder="Enter the password for Username above">
                        <a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                      </div>
                      </div>
                      </cfoutput> 




  <div class="form-group">
    <label><strong>Schedule SMTP Address Import from AD</strong></label>

    <select class="form-control" name="schedule" data-placeholder="Schedule" style="width: 100%;"  id="scheduledAd">
      <cfif #show_schedule# is "2">                           
        <option value="2" selected>No</option>
        <option value="1">Yes</option>
      <cfelseif #show_schedule# is "1">
        <option value="1" selected>Yes</option>
        <option value="2">No</option>
      </cfif>
        </select>   

      </div>



<cfif #show_schedule# is "2">

                       

                          <div class="form-group" id="importFrequency" style="display:none;">
                            <label><strong>Schedule Import Frequency</strong></label>
                         <!---
                            <p class="help-block">Effective only when Schedule SMTP Address Import from AD is set to Yes above</p>
                          --->
                            <select class="form-control select2" name="interval" data-placeholder="Interval" style="width: 100%;">
                            
                          <cfif #show_interval# is "">
                            <cfquery name="getcrontabentry" datasource="hermes">
                            select value, label from crontab_entries
                            </cfquery>
                            
                            <cfoutput query="getcrontabentry">
                              <option value="#value#">#label#</option>
                            </cfoutput>
                          
                            

                            <cfelse>
                            
                              
                                
                                <cfquery name="getcrontabentry" datasource="hermes">
                                select value, label from crontab_entries where value != '#show_interval#'
                                </cfquery>
                                  
                                <cfquery name="getdefaultcrontabentry" datasource="hermes">
                                select value, label from crontab_entries where value = '#show_interval#'
                                </cfquery>
                                <cfoutput>
                                <option value="#getdefaultcrontabentry.value#" selected="selected">#getdefaultcrontabentry.label#</option>
                                </cfoutput>

                                <cfoutput query="getcrontabentry">
                                <option value="#value#">#label#</option>
                                </cfoutput>

                                                        
                            <!--- /CFIF for #show_interval# is --->
                            </cfif>


                                </select> 

                        
                  </div>

                <cfelse>

                  <div class="form-group" id="importFrequency">
                    <label><strong>Schedule Import Frequency</strong></label>
                 <!---
                    <p class="help-block">Effective only when Schedule SMTP Address Import from AD is set to Yes above</p>
                  --->
                    <select class="form-control select2" name="interval" data-placeholder="Interval" style="width: 100%;">
                    
                  <cfif #show_interval# is "">
                    <cfquery name="getcrontabentry" datasource="hermes">
                    select value, label from crontab_entries
                    </cfquery>
                    
                    <cfoutput query="getcrontabentry">
                      <option value="#value#">#label#</option>
                    </cfoutput>
                  
                    

                    <cfelse>
                    
                      
                        
                        <cfquery name="getcrontabentry" datasource="hermes">
                        select value, label from crontab_entries where value != '#show_interval#'
                        </cfquery>
                          
                        <cfquery name="getdefaultcrontabentry" datasource="hermes">
                        select value, label from crontab_entries where value = '#show_interval#'
                        </cfquery>
                        <cfoutput>
                        <option value="#getdefaultcrontabentry.value#" selected="selected">#getdefaultcrontabentry.label#</option>
                        </cfoutput>

                        <cfoutput query="getcrontabentry">
                        <option value="#value#">#label#</option>
                        </cfoutput>

                                                
                    <!--- /CFIF for #show_interval# is --->
                    </cfif>


                        </select> 

                
          </div>

                  <!--- /CFIF for #show_schedule# is --->
                </cfif>



<!--- <p class="help-block">Help Block Text</p> --->

<input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">


  </form>

  <div>&nbsp;</div>


<!-- ADD AD CONNECTION FORM STARTS HERE -->

</div>
</div>

</div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
</main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->



</body>

<!--- SCRIPT TO SHOW/HIDE SCHEDULE IMPORT FREQUENCY SCRIPT STARTS HERE  --->
<script>

  $('#scheduledAd').on('change',function(){
    if( $(this).val()==="1"){
    $("#importFrequency").show()
    }
    else{
    $("#importFrequency").hide()
    }
  });
  
  </script>
   <!--- SCRIPT TO SHOW/HIDE SCHEDULE IMPORT FREQUENCY SCRIPT ENDS HERE  --->

     <!--- DELETE CONNECTION MODAL SCRIPT STARTS HERE  --->
<script>
  $('#delete_modal').on('show.bs.modal', function(e) {
      var connection = $(e.relatedTarget).data('connection');
      $(e.currentTarget).find('input[name="connection"]').val(connection);
  });
    </script>
<!--- DELETE CONNECTION MODAL SCRIPT ENDS HERE  --->

 


</html>