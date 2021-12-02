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
  <title>Hermes SEG | Edit System User</title>

  <cfinclude template="./inc/html_head.cfm" />

<!--- SCRIPT TO SHOW/HIDE UPDATE PASSWORD --->
<script>

  $(document).ready(function() {
      $("#userpasswordfield a").on('click', function(event) {
          event.preventDefault();
          if($('#userpasswordfield input').attr("type") == "text"){
              $('#userpasswordfield input').attr('type', 'password');
              $('#userpasswordfield i').addClass( "fa-eye-slash" );
              $('#userpasswordfield i').removeClass( "fa-eye" );
          }else if($('#userpasswordfield input').attr("type") == "password"){
              $('#userpasswordfield input').attr('type', 'text');
              $('#userpasswordfield i').removeClass( "fa-eye-slash" );
              $('#userpasswordfield i').addClass( "fa-eye" );
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
            <h1 class="m-0">Edit System User</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Edit System User</li>
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
<cfset m="Edit System User: url.id not valid interger">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF isValid("integer", form.id) --->
</cfif>


<cfelseif NOT StructKeyExists(url, "id")>
<cfset m="Edit System User: url.id does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF StructKeyExists(url, "id") --->
</cfif> 

<cfquery name="getuser" datasource="hermes">
select * from system_users where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getuser.recordcount# LT 1>
<cfset m="Edit System User: getuser.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>
</cfif>

<cfparam name = "theUsername" default = "#getuser.username#"> 

<cfparam name = "thePassword" default = ""> 

<cfparam name = "theEmail" default = "#getuser.email#"> 

<cfparam name = "theFirstName" default = "#getuser.first_name#"> 

<cfparam name = "theLastName" default = "#getuser.last_name#"> 

<cfparam name = "setPassword" default = "NO"> 

<cfquery name="checkpasswordexists" datasource="hermes">
  select id, password from system_users where id = <cfqueryparam value = #theID# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>
  
<cfif #checkpasswordexists.password# is "">
<cfset setPassword = "YES">
  </cfif>




<cfparam name = "checkHibp" default = "YES"> 

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

<cfif #action# is "edituser">

  
<!--- VALIDATE FORM INPUTS STARTS HERE --->
<cfif NOT StructKeyExists(form, "username")>

  <cfset m="Edit System User: form.username does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "username") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "password")>
  
  <cfset m="Edit System User: form.password does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "password") --->
  </cfif>
  
  <cfif NOT StructKeyExists(form, "email")>
  
  <cfset m="Edit System User: form.email does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "email") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "first_name")>
  
  <cfset m="Edit System User: form.first_name does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "first_name") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "last_name")>
  
  <cfset m="Edit System User: form.last_name does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "last_name") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "setpassword")>
  
  <cfset m="Edit System User: form.setpassword does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelse>

  <cfif form.setpassword is "YES" OR form.setpassword is "NO">

  <cfelse>

  <cfset m="Edit System User: form.setpassword is not YES or NO">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <!--- /CFIF form.setpassword is "YES" OR form.setpassword is "NO" --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "setpassword") --->
  </cfif>
  
  
  <cfif NOT StructKeyExists(form, "hibp")>
  
  <cfset m="Edit System User: form.hibp does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelse>

  <cfif form.hibp is "YES" OR form.hibp is "NO">

  <cfelse>
  
  <cfset m="Edit System User: form.hibp is not YES or NO">
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
  

<cfif step is "6">

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

<cfelse>

<cfset step=11>

<!--- /CFIF #checkpasswordexists.password# is "" --->
</cfif>

<cfelseif #form.setpassword# is "YES">

<cfset step = 7>

<!--- /CFIF form.setpassword is YES or NO --->
</cfif>


<!--- /CFIF step --->  
</cfif>


<cfif step is "7" and #form.password# is "">

<cfset step=0>
<cfset session.m=10>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelseif step is "7" and #form.password# is not "">

<!--- CODE TO ENFORCE 8 CHARACTER LENGTH --->
<cfif NOT ( len(form.password) GTE 8)>
<cfset step=0>
<cfset session.m=11>

<cfoutput>
<cflocation url="edit_system_user.cfm?id=#theID#" addtoken="no">
</cfoutput>

<cfelse>
<cfset step=8>

<!--- /CFIF NOT ( len(form.password) GTE 8) --->
</cfif>

<!--- /CFIF step --->
</cfif>

<cfif step is "8">

<cfif #form.hibp# is "YES">

<!--- SET NEXTSTEP VARIABLE TO BE PARSED BY CHECK_HIBP.CFM TEMPLATE --->
<cfset nextstep=9>

<!--- INVOKE HIBP TEMPLATE --->
<cfinclude template="./inc/check_hibp.cfm" />

<cfelse>

<cfset step=9>

<!--- /CFIF form.hibp is YES or NO --->
</cfif>

<!--- /CFIF step --->
</cfif>

<cfif step is "9">

<cfinclude template="./inc/generate_authelia_password.cfm">

<cfset step = 10>

<!--- /CFIF step is 9 --->
</cfif>

<cfif step is "10">

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

<!--- /CFIF for step 10 --->
</cfif>

<cfif step is "11">

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

  <!--- /CFIF for step 11 --->
  </cfif>


<cfelseif #action# is "deleteuser">

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
    <cfset theUser = #form.user#>

    <!--- /CFIF form.user is/is not "" --->
    </cfif>

    <!--- /CFIF StructKeyExists(form, "user") --->
    </cfif>

<cfquery name="getuser" datasource="hermes">
SELECT  id, system from system_users where id = <cfqueryparam value = #theUser# CFSQLType = "CF_SQL_INTEGER"> and system <> '1' and id <> '#session.userid#'
</cfquery>

  <cfif #getuser.recordcount# GTE 1>

  <cfquery name="delete" datasource="hermes">
  delete from system_users where id = <cfqueryparam value = #theUser# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>
  
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

  <cfset m="Delete System User: getuser.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #getconnection.recordcount# GTE 1 --->
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
    <cfoutput>The Password must be between 8 and 40 characters long</cfoutput>
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
<a href="view_system_users.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to System Users</a>

<!--- BACK TO SYSTEM USERS CONNECTIONS BUTTON ENDS HERE --->


<!--- DELETE USER BUTTON STARTS HERE --->

<!--- IF USER TO EDIT ID IS THE SAME AS USER LOGGED IN ID OR USER TO EDIT ID IS BUILT-IN USER THEN DON'T SHOW DELETE USER BUTTON --->
<cfif #session.userid# is "#theID#" OR #getuser.system# is "1">

<cfelse>

<cfoutput>
<!-- Delete User Button-->
<a href="##delete_modal"  class="btn btn-danger" role="button" data-toggle="modal" data-user="#theId#"><i class="fa fa-trash"></i>&nbsp;&nbsp;Delete User</a>
</cfoutput>

<!--- /CFIF #session.userid# is "#theID#" OR #getuser.system# is "1" --->
</cfif>



<!--- DELETE USER BUTTON ENDS HERE --->

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
          <h4 class="modal-title">Delete System User </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you send to delete this System User? This action is irreversible!</p>

      </div>
      <div class="modal-footer">
        <form name="delete_user" method="post">

          <input type="hidden" name="action" value="deleteuser">
          <input type="hidden" name="user" value=""/>

          
          <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

          
          
            </form>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>
<!--- DELETE USER MODAL HTML ENDS HERE --->




<!-- EDIT SYSTEM USER FORM STARTS HERE -->


<!-- form start -->
  <form name="edit_system_users.cfm" method="post" action="">

  <input type="hidden" name="action" value="edituser">

    <div class="box-body">
       
      <cfoutput>
      <div class="form-group">
        <label for="username"><strong>Username</strong></label>
        <input type="text" class="form-control" name="username" value="#theUsername#" id="username" placeholder="Username">
      </div>
      </cfoutput>

      
        <cfoutput>
            <div class="form-group">
              <label for="email"><strong>E-Mail Address</strong></label>
              <input type="text" class="form-control" name="email" value="#theEmail#" id="email" placeholder="E-Mail Address">
            </div>
            </cfoutput>

            <cfoutput>
              <div class="form-group">
                <label for="first_name"><strong>First Name</strong></label>
                <input type="text" class="form-control" name="first_name" value="#theFirstName#" id="first_name" placeholder="First Name">
              </div>
              </cfoutput>       

              <cfoutput>
                <div class="form-group">
                  <label for="last_name"><strong>Last Name</strong></label>
                  <input type="text" class="form-control" name="last_name" value="#theLastName#" id="last_name" placeholder="Last Name">
                </div>
                </cfoutput>      
  

  <div class="form-group">
    <label><strong>Set User Password</strong></label>

    <select class="form-control" name="setpassword" data-placeholder="setpassword" style="width: 100%;"  id="setUserPassword">
      <cfif #setPassword# is "NO">                           
        <option value="NO" selected>NO</option>
        <option value="YES">YES</option>
      <cfelseif #setPassword# is "YES">
        <option value="YES" selected>YES</option>
        <option value="NO">NO</option>
      </cfif>
        </select>   

      </div>



<cfif #setPassword# is "NO">

                       

                          <div class="form-group" id="UserPassword" style="display:none;">
                            <label><strong>Check Password Against haveibeenpwned.com</strong></label>
                         <!---
                            <p class="help-block">Effective only when Schedule SMTP Address Import from AD is set to Yes above</p>
                          --->
                            <select class="form-control select2" name="hibp" data-placeholder="hibp" style="width: 100%;">
                            
                          <cfif #checkHibp# is "NO">                         
                              <option value="NO" selected>NO</option>
                              <option value="YES">YES</option>
                            <cfelseif #checkHibp# is "YES">
                              <option value="YES" selected>YES</option>
                              <option value="NO">NO</option>
                            </cfif>
                              </select>   

                              
                              <cfoutput>
                                <div class="form-group" id="userpasswordfield">
                                  <label for="password"><strong>User Password</strong></label>
                                  <div class="input-group">
                                  <input type="password" class="form-control" name="password" value="#thePassword#" id="password" placeholder="Enter the password for Username above" maxLength="40">
                                  <a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                                </div>
                                </div>
                                </cfoutput> 

                              </div>


                            <cfelse>
                            

                              <div class="form-group" id="UserPassword">
                                <label><strong>Check Password Against haveibeenpwned.com</strong></label>
                             <!---
                                <p class="help-block">Effective only when Schedule SMTP Address Import from AD is set to Yes above</p>
                              --->
                                <select class="form-control select2" name="hibp" data-placeholder="hibp" style="width: 100%;">
                                
                              <cfif #checkHibp# is "NO">                         
                                  <option value="NO" selected>NO</option>
                                  <option value="YES">YES</option>
                                <cfelseif #checkHibp# is "YES">
                                  <option value="YES" selected>YES</option>
                                  <option value="NO">NO</option>
                                </cfif>
                                  </select>  

                                  <cfoutput>
                                    <div class="form-group" id="userpasswordfield">
                                      <label for="password"><strong>User Password</strong></label>
                                      <div class="input-group">
                                      <input type="password" class="form-control" name="password" value="#thePassword#" id="password" placeholder="Enter the password for Username above">
                                      <a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                                    </div>
                                    </div>
                                    </cfoutput> 

                                  </div>

                  <!--- /CFIF for #setpassword# is YES or NO --->
                </cfif>



<!--- <p class="help-block">Help Block Text</p> --->


<input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">


  </form>

  <div>&nbsp;</div>


<!-- EDIT SYSTEM USER FORM ENDS HERE -->

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
<!--- SCRIPT TO SHOW/HIDE SET USER PASSWORD SCRIPT STARTS HERE  --->
<script>

  $('#setUserPassword').on('change',function(){
    if( $(this).val()==="YES"){
    $("#UserPassword").show()
    }
    else{
    $("#UserPassword").hide()
    }
  });
  
  </script>
   <!--- SCRIPT TO SHOW/HIDE SET USER PASSWORD SCRIPT ENDS HERE  --->


     <!--- DELETE CONNECTION MODAL SCRIPT STARTS HERE  --->
<script>
  $('#delete_modal').on('show.bs.modal', function(e) {
      var user = $(e.relatedTarget).data('user');
      $(e.currentTarget).find('input[name="user"]').val(user);
  });
    </script>
<!--- DELETE CONNECTION MODAL SCRIPT ENDS HERE  --->

 


</html>