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
  <title>Hermes SEG | Authentication Settings</title>

  <cfinclude template="./inc/html_head.cfm" />
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

<!--- STYLE FOR GENERATE BUTTON TOP-RIGHT OF TEXTAREA STARTS HERE--->  
<style>

  #buttons{
    display:inline-block;
    vertical-align: top;
}

</style>

<!--- STYLE FOR GENERATE BUTTON TOP-RIGHT OF TEXTAREA ENDS HERE--->  

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
            <h1 class="m-0">Authentication Settings</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Authentication Settings</li>
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


<cfelseif #action# is "generatejwtsecret">
  <cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
  select random_letter as random from captcha_list_all2 order by RAND() limit 64
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

 <cffile action = "write"
        file = "/opt/hermes/keys/authelia_identity_validation_reset_password_jwt_secret_file"
        output = "#JwtSecret#" addnewline="no">


<cfset session.m=28>

<cfoutput>
  <cflocation url="view_authentication_settings.cfm" addtoken="no">
  </cfoutput>  


<cfelseif #action# is "generatesessionsecret">
  <cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
  select random_letter as random from captcha_list_all2 order by RAND() limit 64
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

 <cffile action = "write"
        file = "/opt/hermes/keys/authelia_session_secret_file"
        output = "#SessionSecret#" addnewline="no">


<cfset session.m=29>


<cfoutput>
  <cflocation url="view_authentication_settings.cfm" addtoken="no">
  </cfoutput>  


<cfelseif #action# is "generateoidchmacsecret">
  <cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
  select random_letter as random from captcha_list_all2 order by RAND() limit 64
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

<cfset HmacSecret=#trim(gettrans.customtrans2)#>

 <cffile action = "write"
        file = "/opt/hermes/keys/authelia_identity_providers_oidc_hmac_secret_file"
        output = "#HmacSecret#" addnewline="no">


<cfset session.m=42>


<cfoutput>
  <cflocation url="view_authentication_settings.cfm" addtoken="no">
  </cfoutput>  



  <cfelseif #action# is "generateredispassword">
  <cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
  select random_letter as random from captcha_list_all2 order by RAND() limit 64
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

<cfset RedisPassword=#trim(gettrans.customtrans2)#>

 <cffile action = "write"
        file = "/opt/hermes/keys/authelia_session_redis_password_file"
        output = "#RedisPassword#" addnewline="no">


<cfset session.m=41>


<cfoutput>
  <cflocation url="view_authentication_settings.cfm" addtoken="no">
  </cfoutput>  



  <cfelseif #action# is "generateoidckey">
 

<cftry>
    
      <cfexecute name = "/usr/bin/openssl"
      arguments=" genrsa -out /opt/hermes/keys/authelia_identity_providers_oidc_jwks_file 2048"
      timeout = "60">
      </cfexecute>
        
        <cfcatch type="any">
  
        <cfset m="view_authentication_settings.cfm: There was an error running /usr/bin/openssl genrsa -out /opt/hermes/keys/authelia_identity_providers_oidc_jwks_file 2048">
        <cfinclude template="error.cfm">
        <cfabort>   
  
        </cfcatch>
        </cftry>

<cfset session.m=40>


<cfoutput>
  <cflocation url="view_authentication_settings.cfm" addtoken="no">
  </cfoutput> 



  <cfelseif #action# is "generateoidcclientsecret">

  <cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
  select random_letter as random from captcha_list_all2 order by RAND() limit 64
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

<cfset OidcClientSecret=#trim(gettrans.customtrans2)#>

 <cffile action = "write"
        file = "/opt/hermes/keys/authelia_identity_providers_oidc_clients_client_secret_plain_file"
        output = "#OidcClientSecret#" addnewline="no">


<cftry>
    
      <cfexecute name = "/usr/local/bin/docker"
      arguments="exec hermes_authelia authelia crypto hash generate pbkdf2 --password #OidcClientSecret#"
      variable="OidcClientSecretDigest"
      timeout = "60">
      </cfexecute>
        
        <cfcatch type="any">
  
        <cfset m="view_authentication_settings.cfm: There was an error running /usr/local/bin/docker exec hermes_authelia authelia crypto hash generate pbkdf2">
        <cfinclude template="error.cfm">
        <cfabort>   
  
        </cfcatch>
        </cftry>        

<cfset OidcClientSecretDigest="#REReplace("#OidcClientSecretDigest#","Digest:","","ALL")#">
<cfset OidcClientSecretDigest="#trim(OidcClientSecretDigest)#">

 <cffile action = "write"
        file = "/opt/hermes/keys/authelia_identity_providers_oidc_clients_client_secret_digest_file"
        output = "#OidcClientSecretDigest#" addnewline="no">

<cfset session.m=42>


<cfoutput>
  <cflocation url="view_authentication_settings.cfm" addtoken="no">
  </cfoutput>  




<cfelseif #action# is "generatestorageencryptionkey">
  <cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
  select random_letter as random from captcha_list_all2 order by RAND() limit 64
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

 <cffile action = "write"
        file = "/opt/hermes/keys/authelia_storage_encryption_key_file"
        output = "#StorageEncryptionKey#" addnewline="no">

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
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The JWT Secret field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "2"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid JWT Secret. JWT Secret can only contain upper/lower case letters (A-Z, a-z) and numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The JWT Secret field should be at least 24 characters for best security</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "4"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Session Name field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "5"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Session Name. Session Name can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "6"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Session Secret field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "7">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Session Secret. Session Secret can only contain upper/lower case letters (A-Z, a-z) and numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "8">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Session Secret field should be at least 24 characters for best security</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "9"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Session Expiration field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "10">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Session Expiration. Session Expiration can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "11"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Session Inactivity field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "12">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Session Inactivity. Session Inactivity can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "13"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP Host field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "14">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid SMTP Host. SMTP Host can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_), dashes (-), brackets ([]) and periods (.)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "15"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP Port field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "16">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid SMTP Port. SMTP Port can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "17"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP From Address field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "18">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP From Address must be a valid e-mail address</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "19"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP E-mail Subject field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "20">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid SMTP E-mail Subject. SMTP E-mail Subject can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_), dashes (-), brackets ([]) and curly brackets ({})</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "21"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The No of Login Failures Before User is Banned field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "22">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid No of Login Failures Before User is Banned. No of Login Failures Before User is Banned can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "23"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Time for Failed Logins field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "24">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Time Between Failed Logins. Time Between Failed Logins can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "25"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Banned Time field cannot be blank</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "26">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Banned Time. Banned Time can only contain numbers (0-9)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "27">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Authentication Settings saved successfully</cfoutput> 
      
  </div>
  
  <cfset session.m = 0>
  
  </cfif>

  <cfif #m# is "28">

    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      <cfoutput>The JWT Secret was generated successfully. You must click the <strong>Submit</strong> button on the bottom of the page to save the settings. You will be logged off while the system saves the settings.</cfoutput> 
        
    </div>
    
    <cfset session.m = 0>
    
    </cfif>

    <cfif #m# is "29">

      <div class="alert alert-warning alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>The Session Secret was generated successfully. You must click the <strong>Submit</strong> button on the bottom of the page to save the settings. You will be logged off while the system saves the settings.</cfoutput> 
          
      </div>
      
      <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "30">

        <div class="alert alert-warning alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>The Storage Encryption key was generated successfully. You must click the <strong>Submit</strong> button on the bottom of the page to save the settings. You will be logged off while the system saves the settings.</cfoutput> 
            
        </div>
        
        <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "31">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Storage Enryption Key field cannot be blank</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "32">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>You have entered an invalid Storage Encryption Key. Storage Encryption Key can only contain upper/lower case letters (A-Z, a-z) and numbers (0-9)</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "33">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Storage Encrytion Key field should be at least 24 characters for best security</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>


        <cfif #m# is "34">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Duo Hostname field cannot be blank</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "35">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Duo Hostname field is not a valid FQDN</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>


        <cfif #m# is "36">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Duo Integration Key field cannot be blank</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>


        <cfif #m# is "37">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>You have entered an invalid Duo Integration Key. Duo Integration Key can only contain upper/lower case letters (A-Z, a-z) and numbers (0-9)</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>



        <cfif #m# is "38">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Duo Secret Key Key field cannot be blank</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>


        <cfif #m# is "39">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>You have entered an invalid Duo Secret Key. Duo Secret Key can only contain upper/lower case letters (A-Z, a-z) and numbers (0-9)</cfoutput>
          </div>
        
          <cfset session.m = 0>
        
        </cfif>

 <cfif #m# is "40">

      <div class="alert alert-warning alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>The Webmail OIDC Key was generated successfully . You must click the <strong>Submit</strong> button on the bottom of the page to save the settings. You will be logged off while the system saves the settings.</cfoutput> 
          
      </div>
      
      <cfset session.m = 0>
      
      </cfif>

 <cfif #m# is "41">

      <div class="alert alert-warning alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>The Session Provider Password was generated successfully . You must click the <strong>Submit</strong> button on the bottom of the page to save the settings. You will be logged off while the system saves the settings.</cfoutput> 
          
      </div>
      
      <cfset session.m = 0>
      
      </cfif>

 <cfif #m# is "42">

      <div class="alert alert-warning alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>The Webmail OIDC Client Secret was generated successfully . You must click the <strong>Submit</strong> button on the bottom of the page to save the settings. You will be logged off while the system saves the settings.</cfoutput> 
          
      </div>
      
      <cfset session.m = 0>
      
      </cfif>

 <cfif #m# is "43">

      <div class="alert alert-warning alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>The Webmail OIDC HMAC Secret was generated successfully . You must click the <strong>Submit</strong> button on the bottom of the page to save the settings. You will be logged off while the system saves the settings.</cfoutput> 
          
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
  <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate Password Reset JWT Secret</h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you want to generate a new Password Reset JWT Secret? </p>

</div>
<div class="modal-footer">
  <form name="GenerateJwtSecret" method="post">

    <input type="hidden" name="action" value="generatejwtsecret">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
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
  <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate Session Secret</h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you want to generate a new Session Secret? </p>

</div>
<div class="modal-footer">
  <form name="GenerateSessionSecret" method="post">

    <input type="hidden" name="action" value="generatesessionsecret">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE SESSION SECRET MODAL HTML HTML ENDS HERE --->



<!--- GENERATE REDIS PASSWORD MODAL HTML STARTS HERE --->

<div class="modal fade" id="generateredispassword_modal" tabindex="-1" role="dialog" aria-labelledby="generateRedisPasswordlLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate Session Provider Password</h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you want to generate a new Session Provider Password? </p>

</div>
<div class="modal-footer">
  <form name="GenerateRedisPassword" method="post">

    <input type="hidden" name="action" value="generateredispassword">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE REDIS MODAL HTML HTML ENDS HERE --->



<!--- GENERATE OIDC KEY MODAL HTML STARTS HERE --->

<div class="modal fade" id="generateoidckey_modal" tabindex="-1" role="dialog" aria-labelledby="generateoidckeylLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate Webmail OIDC Key</h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you want to generate a new Webmail OIDC Key? </p>

</div>
<div class="modal-footer">
  <form name="GenerateOidcKey" method="post">

    <input type="hidden" name="action" value="generateoidckey">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE OIDC KEY MODAL HTML ENDS HERE --->


<!--- GENERATE OIDC HMAC SECRET MODAL HTML STARTS HERE --->

<div class="modal fade" id="generateoidchmacsecret_modal" tabindex="-1" role="dialog" aria-labelledby="generateoidchmacsecretLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate Webmail OIDC HMAC Secret</h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you want to generate a new Webmail OIDC HMAC Secret? </p>

</div>
<div class="modal-footer">
  <form name="GenerateOidcHmacSecret" method="post">

    <input type="hidden" name="action" value="generateoidchmacsecret">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE OIDC HMAC SECRET MODAL HTML ENDS HERE --->


<!--- GENERATE OIDC CLIENT SECRET MODAL HTML STARTS HERE --->

<div class="modal fade" id="generateoidcclientsecret_modal" tabindex="-1" role="dialog" aria-labelledby="generateoidcclientsecretLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate Webmail OIDC Client Secret</h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you want to generate a new Webmail OIDC Client Secret? </p>

</div>
<div class="modal-footer">
  <form name="GenerateOidcClientSecret" method="post">

    <input type="hidden" name="action" value="generateoidcclientsecret">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE OIDC CLIENT SECRET MODAL HTML ENDS HERE --->






<!--- GENERATE STORAGE ENCRYPTION KEY MODAL HTML STARTS HERE --->

<div class="modal fade" id="generatestorage_modal" tabindex="-1" role="dialog" aria-labelledby="generateStorageModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate Storage Encryption key</h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you want to generate a new Storage Encryption Key? </p>

</div>
<div class="modal-footer">
  <form name="GenerateStorageEncryptionKey" method="post">

    <input type="hidden" name="action" value="generatestorageencryptionkey">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE STORAGE ENCRYPIPTION KEY MODAL HTML ENDS HERE --->



<!-- EDIT AUTHENTICATION SETTINGS FORM STARTS HERE -->


<!-- form start -->
  <form name="edit_authentication" method="post" action="">


  <input type="hidden" name="action" value="edit">
  
    <div class="box-body">
       
      <cfoutput>
      <div class="form-group">
        <label for="jwt_secret"><strong>Password Reset JWT Secret</strong></label>
        <div class="input-group">
        <input type="text" class="form-control" name="jwt_secret" value="#jwt_secret#" id="jwt_secret" placeholder="JWT Secret" maxLength="64" disabled="disabled">

        <!-- GENERATE JWT SECRET BUTTON -->
<a href="##generatejwt_modal"  class="btn btn-secondary" role="button" data-bs-toggle="modal"><i class="fas fa-sync"></i></a>
<!--- GENERATE JWT SECRET ENDS HERE --->

<!--- /div class="input-group" --->
</div> 

      </div>
      </cfoutput>


   
        <div class="form-group">
          <label for="storage_encryption_key"><strong>Storage Encryption Key</strong></label>

          <div class="alert alert-warning">
            <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
            <p><strong>DO NOT generate a new Storage Encryption Key unless it has been compromised. </strong> Generating a new Storage Encryption Key will break system authentication and will remove all user 2FA devices.  If you must generate a new Storage Encryption Key, make sure you follow the <a href="##" onClick="window.open('https://docs.deeztek.com/books/hermes-seg-administrator-guide/page/admin-authentication#bkmrk-storage-encryption-k', '_blank')">How to Generate a new Storage Encryption Key Documentation.</a> </p>
            </div>
            <cfoutput>

          <div class="input-group">
          <input type="text" class="form-control" name="storage_encryption_key" value="#storage_encryption_key#" id="storage_encryption_key" placeholder="JWT Secret" maxLength="64" disabled="disabled">
  
          <!-- GENERATE STORAGE ENCRYPTION KEY BUTTON -->
  <a href="##generatestorage_modal"  class="btn btn-secondary" role="button" data-bs-toggle="modal"><i class="fas fa-sync"></i></a>
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
                    <input type="text" class="form-control" name="session_secret" value="#session_secret#" id="session_secret" placeholder="Session Secret" maxLength="64" disabled="disabled">

<!-- GENERATE SESSION SECRET BUTTON -->
<a href="##generatesession_modal"  class="btn btn-secondary" role="button" data-bs-toggle="modal"><i class="fas fa-sync"></i></a>
<!--- GENERATE SESSION SECRET BUTTON ENDS HERE --->


<!--- /div class="input-group" --->
</div>  
                  </div>
                  </cfoutput>


 <cfoutput>
                  <div class="form-group">
                    <label for="redis_password"><strong>Session Provider Password (Redis)</strong></label>
                    <div class="input-group">
                    <input type="text" class="form-control" name="redis_password" value="#redis_password#" id="redis_password" placeholder="Session Provider Password" maxLength="64" disabled="disabled">

<!-- GENERATE REDIS PASSWORD BUTTON -->
<a href="##generateredispassword_modal"  class="btn btn-secondary" role="button" data-bs-toggle="modal"><i class="fas fa-sync"></i></a>
<!--- GENERATE REDIS _ASSWORD BUTTON ENDS HERE --->

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
  <label for="regulation_max_retries"><strong>Number of Login Failures Before User is Banned</strong></label>
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

                  <div class="alert alert-warning">
                    <h5><i class="icon fas fa-exclamation-triangle"></i> Important - Duo Licensing</h5>
                    <p>Enabling Duo Security makes <strong>Duo Push notifications available to ALL users</strong> in the system, including:</p>
                    <ul class="mb-2">
                      <li>System Users (Admins)</li>
                      <li>Relay Recipients</li>
                      <li>Mailbox Users</li>
                    </ul>
                    <p class="mb-0">Ensure you have <strong>sufficient Duo licenses</strong> to accommodate all users who may use Duo Push for two-factor authentication before enabling this feature.</p>
                  </div>

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
                          <input type="text" class="form-control" name="duo_integration_key" value="#duo_integration_key#" id="duo_integration_key" placeholder="Enter the Duo Integration Key" maxLength="64">
                                                        </div>
                        </div>
                        </cfoutput> 

<cfoutput>
                        <div class="form-group" id="duo_secret_key">
                          <label for="duo_secret_key"><strong>Duo Secret Key</strong></label>
                          <div class="input-group">
                          <input type="text" class="form-control" name="duo_secret_key" value="#duo_secret_key#" id="duo_secret_key" placeholder="Enter the Duo Secret Key" maxLength="64">
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
                          <input type="text" class="form-control" name="duo_integration_key" value="#duo_integration_key#" id="duo_integration_key" placeholder="Enter the Duo Integration Key" maxLength="64">
                                                        </div>
                        </div>
                        </cfoutput> 

<cfoutput>
                        <div class="form-group" id="duo_secret_key">
                          <label for="duo_secret_key"><strong>Duo Secret Key</strong></label>
                          <div class="input-group">
                          <input type="text" class="form-control" name="duo_secret_key" value="#duo_secret_key#" id="duo_secret_key" placeholder="Enter the Duo Secret Key" maxLength="64">
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


<cfoutput>
                  <div class="form-group">
                    <label for="oidc_hmac_secret"><strong>Webmail OIDC HMAC Secret</strong></label>
                    <div class="input-group">
                    <input type="text" class="form-control" name="oidc_hmac_secret" value="#oidc_hmac_secret#" id="oidc_hmac_secret" placeholder="Webmail OIDC HMAC Secret" maxLength="64" disabled="disabled">

<!-- GENERATE OIDC HMAC SECRET BUTTON STARTS HERE -->
<a href="##generateoidchmacsecret_modal"  class="btn btn-secondary" role="button" data-bs-toggle="modal"><i class="fas fa-sync"></i></a>
<!--- GENERATE OIDC HMAC SECRET BUTTON ENDS HERE --->

<!--- /div class="input-group" --->
</div>  
                  </div>
                  </cfoutput>



<cfoutput>
                  <div class="form-group">
                    <label for="oidc_key"><strong>Webmail OIDC Key (Nextcloud)  </strong></label>
                    <div class="textareacontainer">

<textarea name="oidc_key" placeholder="Paste content of unencrypted Key. Include -----BEGIN PRIVATE KEY----- &amp; -----END PRIVATE KEY----- lines" wrap="physical" rows="10" id="oidc_key" style="width: 50%;" disabled="disabled">#oidc_key#</textarea>

<!-- GENERATE OIDC KEY BUTTON -->
<div id="buttons">
<a href="##generateoidckey_modal" class="btn btn-secondary" role="button" data-bs-toggle="modal"><i class="fas fa-sync"></i></a>

<!--- /div id="buttons" --->
</div>
<!--- GENERATE OIDC KEY BUTTON ENDS HERE --->

<!--- /div class="textareacontainer" --->
</div>

<!--- /div class="form-group" --->
</div>  

                  </cfoutput>


<cfoutput>
                  <div class="form-group">
                    <label for="oidc_client_secret"><strong>Webmail OIDC Client Secret (Nextcloud)</strong></label>
                    <div class="input-group">
                    <input type="text" class="form-control" name="oidc_client_secret" value="#oidc_client_secret#" id="oidc_client_secret" placeholder="Webmail OIDC Client Secret" maxLength="64" disabled="disabled">

<!-- GENERATE OIDC CLIENT SECRET BUTTON STARTS HERE -->
<a href="##generateoidcclientsecret_modal"  class="btn btn-secondary" role="button" data-bs-toggle="modal"><i class="fas fa-sync"></i></a>
<!--- GENERATE OIDC CLIENT SECRET BUTTON ENDS HERE --->

<!--- /div class="input-group" --->
</div>  
                  </div>
                  </cfoutput>




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
</main><!-- replaced content-wrapper -->


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