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
  <title>Hermes SEG | Admin Authentication</title>

  <cfinclude template="./inc/html_head.cfm" />

     <!-- Preloader -->
     <div class="preloader flex-column justify-content-center align-items-center">
      <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
      </div>


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
<!--- 
<style>
  .alert a {
    color: #fff;
    text-decoration: none;
}
</style>
--->
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
            <h1 class="m-0">Admin Authentication</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Admin Authentication</li>
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

<cfinclude template="./inc/get_authelia_settings.cfm">



<!--- DEBUG --->
<!---
<cfoutput>
Action: #action#<br>
</cfoutput>
--->



<cfif #action# is "edit">

<cfinclude template="./inc/edit_authelia_settings.cfm">


<cfoutput>
<cflocation url="view_authentication_settings.cfm" addtoken="no">
</cfoutput>  



<cfelseif #action# is "generatesessionsecret">
  <cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
  select random_letter as random from captcha_list_all2 order by RAND() limit 32
  </cfquery>
  
  <cfquery name="inserttrans" datasource="#datasource#" result="stResult">
  insert into salt
  (salt)
  values
  ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
  </cfquery>
  
  <cfquery name="gettrans" datasource="#datasource#">
  select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
  </cfquery>
  
  <cfquery name="deletetrans" datasource="#datasource#">
  delete from salt where id='#stResult.GENERATED_KEY#'
  </cfquery>

<cfset SessionSecret=#trim(gettrans.customtrans2)#>


<cfquery name="updatesecret" datasource="hermes">
update parameters2 set value2='#SessionSecret#' where parameter = 'session.secret' and module='authelia'
</cfquery>

<cfset session.m=29>


<cfoutput>
  <cflocation url="view_authentication_settings.cfm" addtoken="no">
  </cfoutput>  


<cfelseif #action# is "generatejwtsecret">
  <cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
  select random_letter as random from captcha_list_all2 order by RAND() limit 32
  </cfquery>
  
  <cfquery name="inserttrans" datasource="#datasource#" result="stResult">
  insert into salt
  (salt)
  values
  ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
  </cfquery>
  
  <cfquery name="gettrans" datasource="#datasource#">
  select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
  </cfquery>
  
  <cfquery name="deletetrans" datasource="#datasource#">
  delete from salt where id='#stResult.GENERATED_KEY#'
  </cfquery>

<cfset JwtSecret=#trim(gettrans.customtrans2)#>

<cfquery name="updatejwt" datasource="hermes">
update parameters2 set value2='#JwtSecret#' where parameter = 'jwt_secret' and module='authelia'
</cfquery>

<cfset session.m=28>

<cfoutput>
  <cflocation url="view_authentication_settings.cfm" addtoken="no">
  </cfoutput>  


<cfelseif #action# is "generatestorageencryptionkey">
  <cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
  select random_letter as random from captcha_list_all2 order by RAND() limit 32
  </cfquery>
  
  <cfquery name="inserttrans" datasource="#datasource#" result="stResult">
  insert into salt
  (salt)
  values
  ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
  </cfquery>
  
  <cfquery name="gettrans" datasource="#datasource#">
  select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
  </cfquery>
  
  <cfquery name="deletetrans" datasource="#datasource#">
  delete from salt where id='#stResult.GENERATED_KEY#'
  </cfquery>

<cfset StorageEncryptionKey=#trim(gettrans.customtrans2)#>

<cfquery name="updateStorageSecret" datasource="hermes">
update parameters2 set value2='#StorageEncryptionKey#' where parameter = 'storage.encryption_key' and module='authelia'
</cfquery>

<cfset session.m=30>

<cfoutput>
  <cflocation url="view_authentication_settings.cfm" addtoken="no">
  </cfoutput>  

<!--- /CFIF #action# --->
</cfif>

<!--- CFML CODE ENDS HERE --->


<!--- ERROR MESSAGES START HERE --->


<cfif #m# is "1"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The JWT Secret field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "2"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid JWT Secret. JWT Secret can only contain upper/lower case letters (A-Z, a-z) and numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The JWT Secret field should be at least 24 characters for best security</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "4"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Session Name field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "5"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Session Name. Session Name can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "6"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Session Secret field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "7">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Session Secret. Session Secret can only contain upper/lower case letters (A-Z, a-z) and numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "8">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Session Secret field should be at least 24 characters for best security</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "9"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Session Expiration field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "10">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Session Expiration. Session Expiration can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "11"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Session Inactivity field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "12">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Session Inactivity. Session Inactivity can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "13"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP Host field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "14">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid SMTP Host. SMTP Host can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_), dashes (-), brackets ([]) and periods (.)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "15"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP Port field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "16">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid SMTP Port. SMTP Port can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "17"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP From Address field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "18">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP From Address must be a valid e-mail address</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "19"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP E-mail Subject field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "20">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid SMTP E-mail Subject. SMTP E-mail Subject can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_), dashes (-), brackets ([]) and curly brackets ({})</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "21"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The No of Login Failures Before User is Banned field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "22">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid No of Login Failures Before User is Banned. No of Login Failures Before User is Banned can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "23"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Time for Failed Logins field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "24">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Time Between Failed Logins. Time Between Failed Logins can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "25"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Banned Time field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "26">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Banned Time. Banned Time can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "27">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Admin Authentication Settings saved successfully</cfoutput> 
      
  </div>
  
  <cfset session.m = 0>
  
  </cfif>

  <cfif #m# is "28">

    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      <cfoutput>The JWT Secret was generated successfully. You must click the <strong>Submit</strong> button on the bottom of the page to save the settings. You will be logged off while the system saves the settings.</cfoutput> 
        
    </div>
    
    <cfset session.m = 0>
    
    </cfif>

    <cfif #m# is "29">

      <div class="alert alert-warning alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>The Session Secret was generated successfully. You must click the <strong>Submit</strong> button on the bottom of the page to save the settings. You will be logged off while the system saves the settings.</cfoutput> 
          
      </div>
      
      <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "30">

        <div class="alert alert-warning alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>The Storage Encryption key was generated successfully. You must click the <strong>Submit</strong> button on the bottom of the page to save the settings. You will be logged off while the system saves the settings.</cfoutput> 
            
        </div>
        
        <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "31">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Storage Enryption Key field cannot be blank</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "32">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>You have entered an invalid Storage Encryption Key. Storage Encryption Key can only contain upper/lower case letters (A-Z, a-z) and numbers (0-9)</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "33">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Storage Encrytion Key field should be at least 24 characters for best security</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>


        <cfif #m# is "34">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Duo Hostname field cannot be blank</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "35">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Duo Hostname field is not a valid FQDN</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>


        <cfif #m# is "36">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Duo Integration Key field cannot be blank</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>


        <cfif #m# is "37">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>You have entered an invalid Duo Integration Key. Duo Integration Key can only contain upper/lower case letters (A-Z, a-z) and numbers (0-9)</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>



        <cfif #m# is "38">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Duo Secret Key Key field cannot be blank</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>


        <cfif #m# is "39">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>You have entered an invalid Duo Secret Key. Duo Secret Key can only contain upper/lower case letters (A-Z, a-z) and numbers (0-9)</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>


<!--- ERROR MESSAGES END HERE --->

<!--- GENERATE JWT SECRET MODAL HTML STARTS HERE --->

<div class="modal fade" id="generatejwt_modal" tabindex="-1" role="dialog" aria-labelledby="generateJwtModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate JWT Secret</h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you send to generate a new JWT Secret? </p>

</div>
<div class="modal-footer">
  <form name="GenerateJwtSecret" method="post">

    <input type="hidden" name="action" value="generatejwtsecret">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE JWT SECRET MODAL HTML HTML ENDS HERE --->

<!--- GENERATE SESSION SECRET MODAL HTML STARTS HERE --->

<div class="modal fade" id="generatesession_modal" tabindex="-1" role="dialog" aria-labelledby="generateSessionModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate Session Secret</h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you send to generate a new Session Secret? </p>

</div>
<div class="modal-footer">
  <form name="GenerateSessionSecret" method="post">

    <input type="hidden" name="action" value="generatesessionsecret">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE SESSION SECRET MODAL HTML HTML ENDS HERE --->


<!--- GENERATE STORAGE ENCRYPTION KEY MODAL HTML STARTS HERE --->

<div class="modal fade" id="generatestorage_modal" tabindex="-1" role="dialog" aria-labelledby="generateStorageModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate Storage Encryption key</h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you send to generate a new Storage Encryption Key? </p>

</div>
<div class="modal-footer">
  <form name="GenerateStorageEncryptionKey" method="post">

    <input type="hidden" name="action" value="generatestorageencryptionkey">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE STORAGE ENCRYPIPTION KEY MODAL HTML ENDS HERE --->



<!-- EDIT ADMIN AUTHENTICATION FORM STARTS HERE -->


<!-- form start -->
  <form name="edit_authentication" method="post" action="">


  <input type="hidden" name="action" value="edit">
  
    <div class="box-body">
       
      <cfoutput>
      <div class="form-group">
        <label for="jwt_secret"><strong>JWT Secret</strong></label>
        <div class="input-group">
        <input type="text" class="form-control" name="jwt_secret" value="#jwt_secret.value2#" id="jwt_secret" placeholder="JWT Secret" maxLength="64">

        <!-- GENERATE JWT SECRET BUTTON -->
<a href="##generatejwt_modal"  class="btn btn-secondary" role="button" data-toggle="modal"><i class="fas fa-sync"></i></a>
<!--- GENERATE JWT SECRET ENDS HERE --->

<!--- /div class="input-group" --->
</div> 

      </div>
      </cfoutput>


   
        <div class="form-group">
          <label for="storage_encryption_key"><strong>Storage Encryption Key</strong></label>

          <div class="alert alert-warning">
            <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
            <p><strong>DO NOT generate a new Storage Encryption Key unless it has been compromised. </strong> Generating a new Storage Encryption Key will break system authentication and will remove all user 2FA devices.  If you must generate a new Storage Encryption Key, make sure you follow the <a href="##" onClick="window.open('https://docs.deeztek.com/books/hermes-seg-administrator-guide-v2/page/system-users#bkmrk-access-control-polic', '_blank')">How to Generate a new Storage Encryption Key Documentation.</a> </p>
            </div>
            <cfoutput>

          <div class="input-group">
          <input type="text" class="form-control" name="storage_encryption_key" value="#storage_encryption_key.value2#" id="storage_encryption_key" placeholder="JWT Secret" maxLength="64">
  
          <!-- GENERATE STORAGE ENCRYPTION KEY BUTTON -->
  <a href="##generatestorage_modal"  class="btn btn-secondary" role="button" data-toggle="modal"><i class="fas fa-sync"></i></a>
  <!--- GENERATE STORAGE ENCRYPTION KEY ENDS HERE --->
  
  <!--- /div class="input-group" --->
  </div> 
  
        </div>
        </cfoutput>

      <!---
      <div class="form-group">
        <label><strong>Access Control Policy</strong></label>

        <div class="alert alert-danger">
          <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
          <p>Before setting Access Control Policy to <strong>Two Factor</strong> ensure you first read the <a href="##" onClick="window.open('https://docs.deeztek.com/books/hermes-seg-administrator-guide-v2/page/authentication-settings', '_blank')">Authentication Settings Documentation</a>. Ensure that e-mail delivery works as expected, the e-mail addresses for ALL system accounts are correct and you have an authenticator app such as <a href="##" onClick="window.open('https://freeotp.github.io', '_blank')">FreeOTP</a>, <a href="##" onClick="window.open('https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2', '_blank')">Google Authenticator</a>, <a href="##" onClick="window.open('https://authy.com/download/', '_blank')">Authy</a> etc installed on your mobile device <strong>PRIOR</strong> to setting the Access Control Policy to <strong>Two Factor</strong></p>
          </div>
    
        <select class="form-control" name="access_control_rules_policy" data-placeholder="access_control_rules_policy" style="width: 100%;"  id="setUserPassword">
          <cfif #access_control_rules_policy.value2# is "one_factor">                           
            <option value="one_factor" selected>One Factor</option>
            <option value="two_factor">Two Factor</option>

          <cfelseif #access_control_rules_policy.value2# is "two_factor">
            <option value="two_factor" selected>Two Factor</option>
            <option value="one_factor">One Factor</option>
         
          </cfif>
            </select>   
      
          </div> 

        --->

          <div class="form-group">
            <label><strong>Reset Password Function</strong></label>
        
            <select class="form-control" name="authentication_backend_disable_reset_password" data-placeholder="authentication_backend_disable_reset_password" style="width: 100%;"  id="setUserPassword">
              <cfif #authentication_backend_disable_reset_password.value2# is "false">                           
                <option value="false" selected>Enable</option>
                <option value="true">Disable</option>
              <cfelseif #authentication_backend_disable_reset_password.value2# is "true">
                <option value="true" selected>Disable</option>
                <option value="false">Enable</option>
              </cfif>
                </select>   
          
              </div> 

              <cfoutput>
                <div class="form-group">
                  <label for="session_name"><strong>Session Name</strong></label>
                  <input type="text" class="form-control" name="session_name" value="#session_name.value2#" id="session_name" placeholder="Session Name">
                </div>
                </cfoutput>

       
                
             

                <cfoutput>
                  <div class="form-group">
                    <label for="session_name"><strong>Session Secret</strong></label>
                    <div class="input-group">
                    <input type="text" class="form-control" name="session_secret" value="#session_secret.value2#" id="session_secret" placeholder="Session Secret" maxLength="64">

<!-- GENERATE SESSION SECRET BUTTON -->
<a href="##generatesession_modal"  class="btn btn-secondary" role="button" data-toggle="modal"><i class="fas fa-sync"></i></a>
<!--- GENERATE SESSION SECRET BUTTON ENDS HERE --->

<!--- /div class="input-group" --->
</div>  
                  </div>
                  </cfoutput>

                 

                  <cfoutput>
                    <div class="form-group">
                      <label for="session_expiration"><strong>Session Expiration</strong>&nbsp;(In Seconds)</label>
                      <input type="text" class="form-control" name="session_expiration" value="#session_expiration.value2#" id="session_expiration" placeholder="Session Expiration in seconds">
                    </div>
                    </cfoutput>

                    <cfoutput>
                      <div class="form-group">
                        <label for="session_inactivity"><strong>Session Inactivity</strong>&nbsp;(In Seconds)</label>
                        <input type="text" class="form-control" name="session_inactivity" value="#session_inactivity.value2#" id="session_inactivity" placeholder="Session Inactivity in seconds">
                      </div>
                      </cfoutput>

                      <cfoutput>
                        <div class="form-group">
                          <label for="notifier_smtp_host"><strong>SMTP Host</strong></label>
                          <input type="text" class="form-control" name="notifier_smtp_host" value="#notifier_smtp_host.value2#" id="notifier_smtp_host" placeholder="SMTP Host">
                        </div>
                        </cfoutput>

                      <cfoutput>
                        <div class="form-group">
                          <label for="notifier_smtp_port"><strong>SMTP Port</strong></label>
                          <input type="text" class="form-control" name="notifier_smtp_port" value="#notifier_smtp_port.value2#" id="notifier_smtp_port" placeholder="SMTP Port">
                        </div>
                        </cfoutput>

                        <cfoutput>
                          <div class="form-group">
                            <label for="notifier_smtp_sender"><strong>SMTP From Address</strong></label>
                            <input type="text" class="form-control" name="notifier_smtp_sender" value="#notifier_smtp_sender.value2#" id="notifier_smtp_sender" placeholder="SMTP From Address">
                          </div>
                          </cfoutput>

<cfoutput>
<div class="form-group">
<label for="notifier_smtp_subject"><strong>SMTP E-mail Subject</strong></label>
<input type="text" class="form-control" name="notifier_smtp_subject" value="#notifier_smtp_subject.value2#" id="notifier_smtp_subject" placeholder="SMTP E-mail Subject">
</div>
</cfoutput>


<cfoutput>
  <div class="form-group">
  <label for="regulation_max_retries"><strong>No of Login Failures Before User is Banned</strong></label>
  <input type="text" class="form-control" name="regulation_max_retries" value="#regulation_max_retries.value2#" id="regulation_max_retries" placeholder="Number of Login Failures Before User is Banned">
  </div>
  </cfoutput>



  <cfoutput>
    <div class="form-group">
    <label for="regulation_find_time"><strong>Time Between Failed Logins</strong>&nbsp;(In Seconds)</label>
    <input type="text" class="form-control" name="regulation_find_time" value="#regulation_find_time.value2#" id="regulation_find_time" placeholder="Time Between Failed Logins in Minutes">
    </div>
    </cfoutput>
        

    <cfoutput>
      <div class="form-group">
      <label for="regulation_ban_time"><strong>Banned Time</strong>&nbsp;(In Seconds)</label>
      <input type="text" class="form-control" name="regulation_ban_time" value="#regulation_ban_time.value2#" id="regulation_ban_time" placeholder="Banned Time in Minutes">
      </div>
      </cfoutput>


      <div class="form-group">
        <label><strong>Log Level</strong></label>
    
        <select class="form-control" name="log_level" data-placeholder="log_level" style="width: 100%;"  id="log_level">
          <cfif #log_level.value2# is "trace">                           
            <option value="trace" selected>Trace</option>
            <option value="debug">Debug</option>
            <option value="info">Info</option>
            <option value="warn">Warn</option>
            <option value="error">error</option>

          <cfelseif #log_level.value2# is "debug">
            <option value="debug" selected>Debug</option>
            <option value="trace">Trace</option>
            <option value="info">Info</option>
            <option value="warn">Warn</option>
            <option value="error">error</option>
                        
          <cfelseif #log_level.value2# is "info">
            <option value="debug">Debug</option>
            <option value="trace">Trace</option>
            <option value="info" selected>Info</option>
            <option value="warn">Warn</option>
            <option value="error">error</option>

          <cfelseif #log_level.value2# is "warn">
            <option value="debug">Debug</option>
            <option value="trace">Trace</option>
            <option value="info">Info</option>
            <option value="warn" selected>Warn</option>
            <option value="error">error</option>

          <cfelseif #log_level.value2# is "error">
            <option value="debug">Debug</option>
            <option value="trace">Trace</option>
            <option value="info">Info</option>
            <option value="warn">Warn</option>
            <option value="error" selected>error</option>
                    

          </cfif>
            </select>   
      
          </div> 


          <div class="form-group">
            <label><strong>Log Format</strong></label>
        
            <select class="form-control" name="log_format" data-placeholder="log_format" style="width: 100%;"  id="log_format">
              <cfif #log_format.value2# is "json">                           
                <option value="json" selected>JSON</option>
                <option value="text">Text</option>
              <cfelseif #log_format.value2# is "text">
                <option value="text" selected>Text</option>
                <option value="json">JSON</option>
              </cfif>
                </select>   
          
              </div> 
      

                <!--- For the Duo Push field below the Duo Push variable in Authelia is set to disable:true for DISABLED and disable:false for ENABLED --->

                <div class="form-group">
                  <label><strong>Duo Security</strong></label>
              
                  <select class="form-control" name="duo_disable" data-placeholder="duo_disable" style="width: 100%;"  id="setDuo">

                    <cfif #duo_disable.value2# is "true">                           
                      <option value="true" selected>Disable</option>
                      <option value="false">Enable</option>
                    <cfelseif #duo_disable.value2# is "false">
                      <option value="false" selected>Enable</option>
                      <option value="true">Disable</option></option>
                    </cfif>
                      </select>   
              
                    </div>

   

                <cfif #duo_disable.value2# is "true">

                       

                  <div class="form-group" id="DuoDisable" style="display:none;">
            
                    <cfoutput>
                        <div class="form-group" id="duo_hostname">
                          <label for="duo_hostname"><strong>Duo Hostname</strong></label>
                          <div class="input-group">
                          <input type="text" class="form-control" name="duo_hostname" value="#duo_hostname.value2#" id="duo_hostname" placeholder="Enter the Duo Hostname" maxLength="64">
                                                        </div>
                        </div>
                        </cfoutput>  

 <cfoutput>
                        <div class="form-group" id="duo_integration_key">
                          <label for="duo_integration_key"><strong>Duo Integration Key</strong></label>
                          <div class="input-group">
                          <input type="text" class="form-control" name="duo_integration_key" value="#duo_integration_key.value2#" id="duo_integration_key" placeholder="Enter the Duo Integration Key" maxLength="64">
                                                        </div>
                        </div>
                        </cfoutput> 

<cfoutput>
                        <div class="form-group" id="duo_secret_key">
                          <label for="duo_secret_key"><strong>Duo Secret Key</strong></label>
                          <div class="input-group">
                          <input type="text" class="form-control" name="duo_secret_key" value="#duo_secret_key.value2#" id="duo_secret_key" placeholder="Enter the Duo Secret Key" maxLength="64">
                                                        </div>
                        </div>
                        </cfoutput>   

                      
                   <div class="form-group" id="duo_self_enrollment">
                        <label><strong>Duo Self Enrollment</strong></label>
                   
                        <select class="form-control select2" name="duo_self_enrollment" data-placeholder="duo_self_enrollment" style="width: 100%;">
                        
                      <cfif #duo_self_enrollment.value2# is "false">                         
                          <option value="false" selected>Disable</option>
                          <option value="true">Enable</option>
                        <cfelseif #duo_self_enrollment.value2# is "true">
                          <option value="true" selected>Enable</option>
                          <option value="false">Disable</option>
                        </cfif>
                          </select>  

                      </div>

                          <!--- /DIV  <div class="form-group" id="DuoDisable"> --->            
                          </div>


                    <cfelseif #duo_disable.value2# is "false">

                      <div class="form-group" id="DuoDisable">
                    
                      <cfoutput>
                        <div class="form-group" id="duo_hostname">
                          <label for="duo_hostname"><strong>Duo Hostname</strong></label>
                          <div class="input-group">
                          <input type="text" class="form-control" name="duo_hostname" value="#duo_hostname.value2#" id="duo_hostname" placeholder="Enter the Duo Hostname" maxLength="64">
                                                        </div>
                        </div>
                        </cfoutput>  

 <cfoutput>
                        <div class="form-group" id="duo_integration_key">
                          <label for="duo_integration_key"><strong>Duo Integration Key</strong></label>
                          <div class="input-group">
                          <input type="text" class="form-control" name="duo_integration_key" value="#duo_integration_key.value2#" id="duo_integration_key" placeholder="Enter the Duo Integration Key" maxLength="64">
                                                        </div>
                        </div>
                        </cfoutput> 

<cfoutput>
                        <div class="form-group" id="duo_secret_key">
                          <label for="duo_secret_key"><strong>Duo Secret Key</strong></label>
                          <div class="input-group">
                          <input type="text" class="form-control" name="duo_secret_key" value="#duo_secret_key.value2#" id="duo_secret_key" placeholder="Enter the Duo Secret Key" maxLength="64">
                                                        </div>
                        </div>
                        </cfoutput>   

                      
                   <div class="form-group" id="duo_self_enrollment">
                        <label><strong>Duo Self Enrollment</strong></label>
                   
                        <select class="form-control select2" name="duo_self_enrollment" data-placeholder="duo_self_enrollment" style="width: 100%;">
                        
                      <cfif #duo_self_enrollment.value2# is "false">                         
                          <option value="false" selected>Disable</option>
                          <option value="true">Enable</option>
                        <cfelseif #duo_self_enrollment.value2# is "true">
                          <option value="true" selected>Enable</option>
                          <option value="false">Disable</option>
                        </cfif>
                          </select>  

                      </div>

                         <!--- /DIV  <div class="form-group" id="DuoDisable"> --->            
                         </div>


          <!--- /CFIF for #DuoDisable# is true or false --->
        </cfif>

<!--- <p class="help-block">Help Block Text</p> --->


<input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  </form>

  <div>&nbsp;</div>


<!-- EDIT AUTHENTICATION SETTINGS FORM ENDS HERE -->

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


    <!--- SCRIPT TO SHOW/HIDE DUO SECURITY SCRIPT STARTS HERE  --->
<script>

  $('#setDuo').on('change',function(){
    if( $(this).val()==="false"){
    $("#DuoDisable").show()
    }
    else{
    $("#DuoDisable").hide()
    }
  });
  
  </script>
   <!--- SCRIPT TO SHOW/HIDE DUO SECURITY ENDS HERE  --->



</html>