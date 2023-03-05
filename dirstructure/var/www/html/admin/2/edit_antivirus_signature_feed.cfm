<!DOCTYPE html>

  
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

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
 
<html lang="en">


<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Edit Antivirus Signature Feed</title>

  <cfinclude template="./inc/html_head.cfm" />

     <!-- Preloader -->
     <div class="preloader flex-column justify-content-center align-items-center">
      <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
      </div>

      <!--- Sort Table Script  --->
<script>
  $(document).ready(function() {
      $('#sortTable').DataTable( {
  dom: 'Blfrtip',
    buttons: [
  'copy', 'csv', 'excel', 'pdf', 'print'
    ],
    lengthMenu: [
  [ 10, 25, 50, -1 ],
  [ '10 rows', '25 rows', '50 rows', 'Show all' ]
  
      ],
    "order": [[ 2, "asc" ]]
      } );
  } );
    </script>




<!--- TEXT AREA STYLE ---> 
<style>
  textarea{
border:1px solid #999999;
width:100%;
margin:5px 0;
padding:3px;
  }
  .textareacontainer{
padding-right: 8px; /* 1 + 3 + 3 + 1 */
  }
    </style>



<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW STARTS HERE --->  
<style>
  .alert a {
    color: #fff;
    text-decoration: none;
}
</style>
<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW ENDS HERE --->  

</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">

  
  


  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <cfoutput>
            <h1 class="m-0">Edit Antivirus Signature Feed</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Edit Antivirus Signature Feed</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

     
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
<cfset action = form.action>

<!--- /CFIF StructKeyExists(form, "action")> --->
</cfif>


<!---
<cfparam name = "applied" default = "1"> 
<cfquery name="getapplied" datasource="hermes">
select applied from system_users where applied = '2'
</cfquery>

<cfif #getapplied.recordcount# GTE 1>
<cfset applied = 2>
</cfif>
--->

<cfparam name = "theID" default = ""> 
<cfif StructKeyExists(url, "id")>
<cfif IsValid("integer", url.id)>
<cfset theID = url.id>
<cfelse>
<cfset m="Edit Antivirus Signature Feed: url.id not valid interger">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF isValid("integer", form.id) --->
</cfif>


<cfelseif NOT StructKeyExists(url, "id")>
<cfset m="Edit Antivirus Signature Feed: url.id does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF StructKeyExists(url, "id") --->
</cfif> 

<cfquery name="getfeed" datasource="hermes">
select id, name, enabled, update_int, description, applied from malware_feeds where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getfeed.recordcount# LT 1>
<cfset m="Edit Antivirus Signature Feed: getfeed.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>
</cfif>

<cfparam name = "theName" default = "#getfeed.name#"> 

<cfparam name = "theStatus" default = "#getfeed.enabled#"> 

<cfparam name = "theUpdateInt" default = "#getfeed.update_int#"> 

<cfparam name = "theDescription" default = "#getfeed.description#"> 

<cfquery name="getfeeditems" datasource="hermes">
  select id, name, filename, value, description, active, feed, fp, type from malware_databases where feed = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>


<!--- DEBUG --->
<!---
<cfoutput>Step: #step#<br>
Message: #m#<br>
Username: #theusername#<br>
first: #theFirstname#<br>
Last: #theLastname#<br>
Email: #theEmail#<br>
Password: #thePassword#<br>
SetPassword: #setPassword#<br>
hibp: #checkHibp#<br>
Action: #action#
</cfoutput>
--->

<cfif #action# is "editfeed">

  
<!--- VALIDATE FORM INPUTS STARTS HERE --->
<cfif NOT StructKeyExists(form, "username")>

  <cfset m="Edit Antivirus Signature Feed: form.username does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "username") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "password")>
  
  <cfset m="Edit Antivirus Signature Feed: form.password does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "password") --->
  </cfif>
  
  <cfif NOT StructKeyExists(form, "email")>
  
  <cfset m="Edit Antivirus Signature Feed: form.email does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "email") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "first_name")>
  
  <cfset m="Edit Antivirus Signature Feed: form.first_name does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "first_name") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "last_name")>
  
  <cfset m="Edit Antivirus Signature Feed: form.last_name does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "last_name") --->
  </cfif>

  <cfif NOT StructKeyExists(form, "access_control")>
  
    <cfset m="Edit Antivirus Signature Feed: form.access_control does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

  <cfelse>

  <cfif form.access_control is "one_factor" OR form.access_control is "two_factor">

  <cfelse>
  
  <cfset m="Edit Antivirus Signature Feed: form.access_control is not one_factor or two_factor">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF form.access_control is "one_factor" OR form.access_control is "two_factor" --->
  </cfif>
    
  <!--- /CFIF StructKeyExists(form, "access_control") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "setpassword")>
  
  <cfset m="Edit Antivirus Signature Feed: form.setpassword does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelse>

  <cfif form.setpassword is "YES" OR form.setpassword is "NO">

  <cfelse>

  <cfset m="Edit Antivirus Signature Feed: form.setpassword is not YES or NO">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <!--- /CFIF form.setpassword is "YES" OR form.setpassword is "NO" --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "setpassword") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "hibp")>
  
  <cfset m="Edit Antivirus Signature Feed: form.hibp does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelse>

  <cfif form.hibp is "YES" OR form.hibp is "NO">

  <cfelse>
  
  <cfset m="Edit Antivirus Signature Feed: form.hibp is not YES or NO">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF form.hibp is "YES" OR form.hibp is "NO" --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "hibp") --->
  </cfif>
  
  <!--- VALIDATE FORM INPUTS ENDS HERE --->
  

<cfif #form.username# is "">

<cfset step=0>
<cfset session.m=2>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

<cfset step=1>
  
<!--- /CFIF the username is/not ""  --->
</cfif>

<cfif #step# is "1">

<cfif REFind("[^A-Za-z0-9\_\.\-\@]",form.username) gt 0>

<cfset step=0>
<cfset session.m=1>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>
  

<cfelse>

<cfset step=2>

<!--- /CFIF REFind("[^_a-zA-Z0-9-]",form.username) gt 0>  --->
</cfif>

<!--- /CFIF step is 1 --->
</cfif>


<cfif #step# is "2">

<cfquery name="checkusername" datasource="hermes">
select username from system_users where username = '#form.username#' and id <> <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #checkusername.recordcount# LT 1>

<!--- UPDATE FIELD --->
<cfquery name = "updateuser" datasource="hermes">
update system_users set
username = '#form.username#',
applied='2'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfset step = 3>

<cfelse>

<cfset step=0>
<cfset session.m=13>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF checkusername.recordcount --->
</cfif>

<!--- /CFIF step is 2 --->
</cfif>


<cfif #step# is "3" and "#form.email#" is not "">

<cfif not IsValid("email", form.email)>

<cfset step=0>
<cfset session.m=3>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

<!--- UPDATE FIELD --->
<cfquery name = "updateuser" datasource="hermes">
  update system_users set
  email = '#form.email#',
  applied='2'
  where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

<cfset step=4>

<!--- /CFIF IsValid("email", form.email) --->
</cfif>

<cfelseif #step# is "3" and #form.email# is "">

<cfset step=0>
<cfset session.m=4>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF step 3 --->
</cfif>


<cfif #step# is "4" and #form.first_name# is "">

<cfset step=0>
<cfset session.m=6>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

<cfif REFind("[^A-Za-z0-9\_\-]",form.first_name) gt 0>

<cfset step=0>
<cfset session.m=5>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>

  <!--- UPDATE FIELD --->
<cfquery name = "updateuser" datasource="hermes">
  update system_users set
  first_name = '#form.first_name#',
  applied='2'
  where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

<cfset step=5>

<!--- /CFIF  REFind("[^A-Za-z0-9\_\-]",form.first_name) gt 0> --->
</cfif>

<!--- /CFIF step 4 --->
</cfif>

<cfif #step# is "5" and #form.last_name# is "">

<cfset step=0>
<cfset session.m=9>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>
  
<cfelse>
  
<cfif REFind("[^A-Za-z0-9\_\-]",form.last_name) gt 0>
<cfset step=0>
<cfset session.m=8>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>
  
<cfelse>

  <!--- UPDATE FIELD --->
<cfquery name = "updateuser" datasource="hermes">
  update system_users set
  last_name = '#form.last_name#',
  applied='2'
  where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

<cfset step=6>
  
<!--- /CFIF  REFind("[^A-Za-z0-9\_\-]",form.last_name) gt 0> --->
</cfif>
  
<!--- /CFIF step 5 --->
</cfif>

<cfif #step# is "6">

<!--- UPDATE FIELD --->
<cfquery name = "updateuser" datasource="hermes">
update system_users set
access_control = '#form.access_control#',
applied='2'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfset step=7>


<!--- /CFIF step 6 --->
</cfif>
  

<cfif step is "7">

<cfif #form.setpassword# is "NO">

<cfquery name="checkpasswordexists" datasource="hermes">
select id, password from system_users where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #checkpasswordexists.password# is "">
<cfset step=0>
<cfset session.m=12>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- IF SETPASSWORD IS "NO" AND PASSWORD EXISTS GOTO LAST STEP --->
<cfelse>

<cfset step=12>

<!--- /CFIF #checkpasswordexists.password# is "" --->
</cfif>

<cfelseif #form.setpassword# is "YES">

<cfset step = 8>

<!--- /CFIF form.setpassword is YES or NO --->
</cfif>


<!--- /CFIF step 7--->  
</cfif>


<cfif step is "8" and #form.password# is "">

<cfset step=0>
<cfset session.m=10>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelseif step is "8" and #form.password# is not "">

<!--- CODE TO ENFORCE MIN 8 CHARACTER LENGTH --->
<cfif NOT ( len(form.password) GTE 8)>
<cfset step=0>
<cfset session.m=11>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- CODE TO ENFORCE MIN 64 CHARACTER LENGTH --->
<cfelseif NOT ( len(form.password) LTE 64)>
<cfset step=0>
<cfset session.m=11>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>
  
<cfelse>

<cfset step=9>

<!--- /CFIF NOT ( len(form.password) GTE 8) --->
</cfif>

<!--- /CFIF step 8 --->
</cfif>

<cfif step is "9">

<cfif #form.hibp# is "YES">

<!--- SET NEXTSTEP VARIABLE TO BE PARSED BY CHECK_HIBP.CFM TEMPLATE --->
<cfset nextstep=10>

<!--- INVOKE HIBP TEMPLATE --->
<cfinclude template="./inc/check_hibp.cfm" />

<cfelse>

<cfset step=10>

<!--- /CFIF form.hibp is YES or NO --->
</cfif>

<!--- /CFIF step --->
</cfif>

<cfif step is "10">

<cfinclude template="./inc/generate_authelia_password.cfm">

<cfset step = 11>

<!--- /CFIF step is 10 --->
</cfif>

<cfif step is "11">

<cfquery name = "updateuser" datasource="hermes">
update system_users set
password = '#TRIM(autheliapass)#',
applied='1'
where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfinclude template="./inc/generate_authelia_users_database.cfm">

<cfset session.m=14>

<!--- SLEEP 5 SECONDS WAITING FOR AUTHELIA TO RESTART --->
<cfscript> 
  thread = CreateObject("java", "java.lang.Thread"); 
  thread.sleep(5000); 
  </cfscript> 
  
<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<!--- /CFIF for step 11 --->
</cfif>

<cfif step is "12">

  <cfquery name = "updateuser" datasource="hermes">
  update system_users set
  applied='1'
  where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>
  
<cfinclude template="./inc/generate_authelia_users_database.cfm">

<cfset session.m=14>

<!--- SLEEP 5 SECONDS WAITING FOR AUTHELIA TO RESTART --->
<cfscript> 
  thread = CreateObject("java", "java.lang.Thread"); 
  thread.sleep(5000); 
  </cfscript> 

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

  <!--- /CFIF for step 12 --->
  </cfif>


<cfelseif #action# is "deleteitem">

  <cfif NOT StructKeyExists(form, "id")>

    <cfset m="Delete Feed Item: form.id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "id")>
    
    <cfif #form.id# is "">
    <cfset m="Delete Feed Item: form.id blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    
    <cfelseif #form.id# is not "">
    <cfset theItem = #form.id#>

    <!--- /CFIF form.id is/is not "" --->
    </cfif>

    <!--- /CFIF StructKeyExists(form, "id") --->
    </cfif>

<cfquery name="getitem" datasource="hermes">
SELECT  id, value, type, feed from malware_databases where id = <cfqueryparam value = #theItem# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getitem.recordcount# GTE 1>

<cfset theValue="#getitem.value#">
<cfset theType="#getitem.type#">
<cfset theFeed="#getitem.feed#">

<!-- DELETE ITEM FROM DATABASE -->
<cfinclude template="./inc/delete_feed_item_database.cfm">

<cfif #theType# is "feedurl">

<!-- DISABLE THE FEED -->
<cfinclude template="./inc/disable_malware_feed.cfm">

<cfelseif #theType# is "database">

  <!-- DELETE DATABASE FILE FROM FILESYSTEM -->
<cfinclude template="./inc/delete_feed_item_filesystem.cfm">
          
<!--- /CFIF #theType# is --->
</cfif>

<cfinclude template="./inc/delete_system_user_devices.cfm">
  
  <cfinclude template="./inc/generate_authelia_users_database.cfm">

  <cfset session.m=1>

  
<!--- SLEEP 5 SECONDS WAITING FOR AUTHELIA TO RESTART --->
<cfscript> 
  thread = CreateObject("java", "java.lang.Thread"); 
  thread.sleep(5000); 
  </cfscript> 

<cfoutput>
<cflocation url="view_system_users.cfm" addtoken="no">
</cfoutput>



<cfelse>

  <cfset m="Delete System User: getfeed.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #getfeed.recordcount# GTE 1 --->
</cfif>

<cfelseif #action# is "deleteuserdevices">

  <cfif NOT StructKeyExists(form, "user")>

    <cfset m="Delete System User: form.user does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "user")>
    
    <cfif #form.user# is "">
    <cfset m="Delete System User: form.user blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    
    <cfelseif #form.user# is not "">
    <cfset theUser = "#form.user#">

    <!--- /CFIF form.user is/is not "" --->
    </cfif>

    <!--- /CFIF StructKeyExists(form, "user") --->
    </cfif>

<cfquery name="getuser" datasource="hermes">
SELECT  id, username, system from system_users where username = <cfqueryparam value = #theUser# CFSQLType = "cf_sql_varchar">
</cfquery>

<cfif #getfeed.recordcount# GTE 1>

<cfset theUsername="#getfeed.name#">
<cfset theUserid="#getfeed.id#">

<cfinclude template="./inc/delete_system_user_devices.cfm">

<cfset session.m=15>

<!--- SLEEP 5 SECONDS WAITING FOR AUTHELIA TO RESTART --->
<cfscript> 
  thread = CreateObject("java", "java.lang.Thread"); 
  thread.sleep(5000); 
  </cfscript> 

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>



<cfelse>

  <cfset m="Delete System User: getfeed.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #getfeed.recordcount# GTE 1 --->
</cfif>
 
 

<!--- /CFIF #action# --->
</cfif>

<!--- CFML CODE ENDS HERE --->


<!--- ERROR MESSAGES START HERE --->

<cfif #m# is "1"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Username. Usernames can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_), dashes (-), periods (.) and at signs (@)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Username field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The E-mail Address field is not a valid e-mail address</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "4">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The E-mail Address field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "5">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid First Name. First Names can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "6">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The First Name field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "8">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Last Name. Last Names can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>




<cfif #m# is "9">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Last Name field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "10">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Password field cannot blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "11">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Password must be between 8 and 64 characters long</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "12">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>No password has been set for this user. You must set the <strong>Set User Password</strong> field to YES in order to continue</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "13">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Username you are attempting to use already exists</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "14">

<div class="alert alert-success alert-dismissible">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-check"></i> Success!</h4>
  <cfoutput>System User was saved successfully</cfoutput> 
    
</div>

<cfset session.m = 0>

</cfif>

<cfif #m# is "15">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>System User 2FA devices were deleted successfully</cfoutput> 
      
  </div>
  
  <cfset session.m = 0>
  
  </cfif>



  
<cfif #m# is "99">

      <div class="alert alert-danger alert-dismissible">
                  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                  <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                  <cfoutput>The Password you are attempting to use has previously appeared in a data breach. Please use another password. Password was checked by <a href="https://haveibeenpwned.com/Passwords" target="_blank">haveibeenpwned.com</a></cfoutput>
                </div>

                <cfset session.m = 0>
</cfif>


<cfif #m# is "100">

  <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>There was a problem accessing haveibeenpwned.com to check your password against previous data breaches. Either ensure Hermes SEG has outbound Internet access over 443 to <a href="https://api.pwnedpasswords.com">https://api.pwnedpasswords.com</a> OR set the <strong>Check Password Against haveibeenpwned.com</strong> field to NO</cfoutput>
    </div>

    <cfset session.m = 0>

</cfif>



<!--- ERROR MESSAGES END HERE --->


<span>
  <p>       

<!--- BACK TO SYSTEM USERS BUTTON STARTS HERE --->
<a href="view_antivirus_signature_feeds.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Antivirus Signature Feeds</a>

<!--- BACK TO SYSTEM USERS CONNECTIONS BUTTON ENDS HERE --->

<!--- DELETE USER 2FA DEVICES BUTTON STARTS HERE --->

<cfoutput>
  <!-- Delete User devices Button-->
  <a href="##delete_devices_modal"  class="btn btn-danger" role="button" data-toggle="modal" data-user="#getfeed.name#"><i class="fa fa-mobile"></i>&nbsp;&nbsp;Delete 2FA Devices</a>
  </cfoutput>
<!--- DELETE USER 2FA DEVICES BUTTON STARTS HERE --->





</p>


</span>


<!--- DELETE USER MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Delete Feed Item(s) </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you send to delete this item(s)? This action is irreversible! If you click <strong>Yes</strong>, the item(s). If among the item(s) you delete is the Feed URL, the Signature Feed will be disabled automatically.</p>

      </div>
      <div class="modal-footer">
        <form name="delete_item" method="post">

          <input type="hidden" name="action" value="deleteitem">
          <input type="hidden" name="id" value=""/>

          
          <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

          
          
            </form>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>
<!--- DELETE USER MODAL HTML ENDS HERE --->

<!-- EDIT SYSTEM USER FORM STARTS HERE -->


<div class="card col-sm-8">


  <!-- form start -->
    <form name="edit_antivirus_signare_feeds.cfm" method="post" action="">
  
    <input type="hidden" name="action" value="editfeed">
  
      <div class="box-body">
         
      
        <div class="form-group">
          <label for="feedname"><strong>Name</strong></label>
  
  
            <cfoutput>
          <input type="text" class="form-control" name="feedname" value="#theName#" id="feedname" placeholder="Feed Name">
        </div>
        </cfoutput>
  
        
        <div class="form-group">
          <label><strong>Status</strong></label>
  
  
      
          <select class="form-control" name="feedstatus" data-placeholder="feedstatus" style="width: 100%;"  id="access_control">
            <cfif #theStatus# is "no">                           
              <option value="no" selected>Disabled</option>
              <option value="yes">Enabled</option>
  
            <cfelseif #theStatus# is "yes">
              <option value="yes" selected>Enabled</option>
              <option value="no">Disabled</option>
           
            </cfif>
              </select>   
        
            </div> 
  
            
   

                <cfoutput>
                <div class="form-group" id="updateint">
                  <label><strong>Update Interval</strong></label>
               <!---
                  <p class="help-block">Effective only when Schedule SMTP Address Import from AD is set to Yes above</p>
                --->
                  <select class="form-control select2" name="updateint" data-placeholder="updateint" style="width: 100%;">
                  
                <cfif #theUpdateInt# is "">
                  <cfquery name="getcrontabentry" datasource="hermes">
                  select value, label from crontab_entries
                  </cfquery>
                  
                  <cfoutput query="getcrontabentry">
                    <option value="#value#">#label#</option>
                  </cfoutput>
                
                  

                  <cfelse>
                  
                    
                      
                      <cfquery name="getcrontabentry" datasource="hermes">
                      select value, label from crontab_entries where value != '#theUpdateInt#'
                      </cfquery>
                        
                      <cfquery name="getdefaultcrontabentry" datasource="hermes">
                      select value, label from crontab_entries where value = '#theUpdateInt#'
                      </cfquery>
                      <cfoutput>
                      <option value="#getdefaultcrontabentry.value#" selected="selected">#getdefaultcrontabentry.label#</option>
                      </cfoutput>

                      <cfoutput query="getcrontabentry">
                      <option value="#value#">#label#</option>
                      </cfoutput>

                                              
                  <!--- /CFIF for #theUpdateInt# is --->
                  </cfif>


                      </select> 

              
        </div>





                </cfoutput>       
  
                
               <cfoutput>
                  <div class="form-group">
                    <label>Description</label>
                    <div class="textareacontainer">
                <textarea name="description" placeholder="Enter Feed Description" wrap="physical" rows="5">#theDescription#</textarea>
                </div>   
              </cfoutput> 
                  
                      </div> 
      </div>
    
    
    <div class="col-sm-4">
    
    <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
    </div>
      
    </form>
    <br>
  
      <!--- div class="card"  --->  
  </div>
          

<!--- <p class="help-block">Help Block Text</p> --->


  <div>&nbsp;</div>

  <cfif #getfeeditems.recordcount# GTE 1>
        
    <table class="table table-striped"  id="sortTable" style="width:100%">
      <thead>
        <tr>
          <th>Edit</th>    
          <th>Delete</th>
          <th>Name</th>
          <th>Save As</th>
          <th>Value</th>
          <th>Description</th>
          <th>Active</th>
          <th>FP Risk</th>
          <th>Type</th>
    
        </tr>
      </thead>
      <tbody>
    
       
    <cfloop query="getfeeditems">
    
      
      <cfoutput>
       
        
        <tr>
    
    
          <td>
    
            <button a href="##edititem_modal"  type="button" id="delete" class="btn btn-secondary" data-toggle="modal" data-id="#id#" data-name="#name#" data-value="#value#" data-type="#type#" data-fp="#fp#"><i class="fas fa-edit"></i></button>
    
          </td>
    
          <td>
    
            <button a href="##delete_modal"  type="button" id="delete" class="btn btn-danger" data-toggle="modal" data-id="#id#"><i class="fas fa-trash-alt"></i></button>
    
          </td>
    
    
    
    
    
    <td>#name#</td>

    <td>
    <cfif #type# is "database">
    <cfif #filename# is "">
     #name#
       <cfelse>
   
        #filename#
   
          <!--- /CFIF #filename# is --->
         </cfif>

        <cfelse>
          N/A
 <!--- /CFIF #type# is "database" --->
        </cfif>

      </td>


    <td>#value#</td>

    <td>#description#</td>
    
    <td>

  
    <cfif #type# is "database">
      <cfif #active# is "true">
        YES
    <cfelse>
    NO

       <!--- /CFIF #active# is --->
      </cfif>

    <cfelse>
      N/A

 

        <!--- /CFIF #type# is --->
      </cfif>



    
    </td>

    <td>

    <cfif #fp# is "">
    N/A

    <cfelseif #fp# is "low">
      LOW

    <cfelseif #fp# is "medium">
      MEDIUM

    <cfelseif #fp# is "high">
      HIGH

      <!--- /CFIF #fp# is --->
    </cfif>

    </td>
    
    <td>

    <cfif #type# is "database">
      DATABASE

    <cfelseif #type# is "feedurl">
      FEED URL

    <cfelseif #type# is "variable">
      VARIABLE


      <!--- CFIF #type# is --->
      </cfif>

    </td>
    
   
    
    
    
        </cfoutput>
    
    
    
      </tr>
    
    
      </cfloop>
      </tbody>
      
      <tfoot>
        <tr>
        
          <th>Edit</th>    
          <th>Delete</th>
          <th>Name</th>
          <th>Save As</th>
          <th>Value</th>
          
          <th>Description</th>
          <th>Active</th>
          <th>FP Risk</th>
          <th>Type</th>
    
        </tr>
      </tfoot>
     
    </table>
        
        
        <cfelseif #getfeeditems.recordcount# LT 1>
        
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>No Malware Feed Items were found</strong></cfoutput>
    </div>
        
    <!--- /CFIF FOR getfeeditems.recordcount --->
  </cfif>


</div>
</div>

</div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- Control Sidebar -->
<aside class="control-sidebar control-sidebar-dark">
<!-- Control sidebar content goes here -->
<div class="p-3">
  <h5>Title</h5>
  <p>Sidebar content</p>
</div>
</aside>
<!-- /.control-sidebar -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->



</body>




     <!--- DELETE ITEM SCRIPT STARTS HERE  --->
<script>
  $('#delete_modal').on('show.bs.modal', function(e) {
      var id = $(e.relatedTarget).data('id');
      $(e.currentTarget).find('input[name="id"]').val(id);
  });
    </script>
<!--- DELETE USER MODAL SCRIPT ENDS HERE  --->



 


</html>