<!DOCTYPE html>

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

<html lang="en">


<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | System Settings</title>

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

<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW STARTS HERE --->  
<style>
  .alert a {
    color: #fff;
    text-decoration: none;
}
</style>
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
            <h1 class="m-0">System Settings</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">System Settings</li>
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
<cfoutput>session.m: #session.m#<br></cfoutput>
--->

<!--- /CFIF for session.m is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.m --->
</cfif>

<!---
<cfoutput>session M: #m#</cfoutput>
--->


<cfparam name = "errordetail" default = "">
  <cfif StructKeyExists(session, "errordetail")>
  <cfif session.errordetail is not "">
  <cfset errordetail = session.errordetail>

  <!--- ENABLE FOR DEBUG BELOW --->
<!---
  <cfoutput>error detail: #errordetail#</cfoutput>
--->
  
  <!--- /CFIF for session.errordetail is not "" --->
  </cfif>
  
  <!--- /CFIF for StructKeyExists session.errordetail --->
  </cfif>


 

<cfparam name = "action" default = ""> 
<cfif StructKeyExists(form, "action")>
<cfset action = form.action>

<!--- /CFIF StructKeyExists(form, "action")> --->
</cfif>

<cfparam name = "tos" default = ""> 
<cfif StructKeyExists(form, "tos")>
<cfset tos = form.tos>

<!--- /CFIF StructKeyExists(form, "tos")> --->
</cfif>

<!--- CHECK IF HERMES.KEY IS BLANK AND IF BLANK GENERATE IT --->
<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="authkey">

<cfif #authkey# is "">

<!--- GENERATE HERMES KEY --->
<cfinclude template="./inc/generate_hermes_key.cfm">

<!--- #authkey# is "" --->
</cfif>

<!--- GET SYSTEM SETTINGS --->
<cfinclude template="./inc/get_system_settings.cfm">

<!--- GET CAPTCHA SETTINGS --->
<cfquery name="getCaptchaSettings" datasource="hermes">
    SELECT parameter, value FROM system_settings
    WHERE parameter IN ('captcha_provider', 'recaptcha_site_key', 'recaptcha_secret_key',
                        'hcaptcha_site_key', 'hcaptcha_secret_key',
                        'turnstile_site_key', 'turnstile_secret_key')
</cfquery>

<!--- SET DEFAULT CAPTCHA VALUES --->
<cfset captcha_provider = "builtin">
<cfset recaptcha_site_key = "">
<cfset recaptcha_secret_key = "">
<cfset hcaptcha_site_key = "">
<cfset hcaptcha_secret_key = "">
<cfset turnstile_site_key = "">
<cfset turnstile_secret_key = "">

<cfloop query="getCaptchaSettings">
    <cfswitch expression="#parameter#">
        <cfcase value="captcha_provider"><cfset captcha_provider = value></cfcase>
        <cfcase value="recaptcha_site_key"><cfset recaptcha_site_key = value></cfcase>
        <cfcase value="recaptcha_secret_key"><cfset recaptcha_secret_key = value></cfcase>
        <cfcase value="hcaptcha_site_key"><cfset hcaptcha_site_key = value></cfcase>
        <cfcase value="hcaptcha_secret_key"><cfset hcaptcha_secret_key = value></cfcase>
        <cfcase value="turnstile_site_key"><cfset turnstile_site_key = value></cfcase>
        <cfcase value="turnstile_secret_key"><cfset turnstile_secret_key = value></cfcase>
    </cfswitch>
</cfloop>

<!---
<!--- CHECK SYSTEM UPDATE --->
<cfinclude template="./inc/check_system_update.cfm">
--->

<cfif #action# is "edit">

<!--- EDIT CONSOLE SETTINGS --->
<cfinclude template="./inc/edit_system_settings.cfm">

<cfset session.m=27>

  
  <cfoutput>
  <cflocation url="https://#consoleHost#/admin/2/view_system_settings.cfm" addtoken="no">
  </cfoutput>
  
 


<cfelseif  #action# is "Add Serial">

<!--- ADD SERIAL NUMBER --->
<cfinclude template="./inc/add_serial_number.cfm">

<cfset session.m=27>

<cfelseif action EQ "save_captcha">

    <!--- VALIDATE CAPTCHA PROVIDER --->
    <cfif NOT StructKeyExists(form, "captcha_provider")>
        <cfset m = "System Settings: captcha_provider does not exist">
        <cfinclude template="./inc/error.cfm">
        <cfabort>
    </cfif>

    <cfset validProviders = "builtin,recaptcha,hcaptcha,turnstile">
    <cfif NOT ListFindNoCase(validProviders, form.captcha_provider)>
        <cfset m = "System Settings: captcha_provider is not valid">
        <cfinclude template="./inc/error.cfm">
        <cfabort>
    </cfif>

    <!--- Validate provider-specific keys --->
    <cfswitch expression="#form.captcha_provider#">
        <cfcase value="recaptcha">
            <cfif NOT StructKeyExists(form, "recaptcha_site_key") OR Len(Trim(form.recaptcha_site_key)) EQ 0>
                <cfset session.m = 30>
                <cflocation url="view_system_settings.cfm" addtoken="no">
            </cfif>
            <cfif NOT StructKeyExists(form, "recaptcha_secret_key") OR Len(Trim(form.recaptcha_secret_key)) EQ 0>
                <cfset session.m = 31>
                <cflocation url="view_system_settings.cfm" addtoken="no">
            </cfif>
        </cfcase>
        <cfcase value="hcaptcha">
            <cfif NOT StructKeyExists(form, "hcaptcha_site_key") OR Len(Trim(form.hcaptcha_site_key)) EQ 0>
                <cfset session.m = 32>
                <cflocation url="view_system_settings.cfm" addtoken="no">
            </cfif>
            <cfif NOT StructKeyExists(form, "hcaptcha_secret_key") OR Len(Trim(form.hcaptcha_secret_key)) EQ 0>
                <cfset session.m = 33>
                <cflocation url="view_system_settings.cfm" addtoken="no">
            </cfif>
        </cfcase>
        <cfcase value="turnstile">
            <cfif NOT StructKeyExists(form, "turnstile_site_key") OR Len(Trim(form.turnstile_site_key)) EQ 0>
                <cfset session.m = 34>
                <cflocation url="view_system_settings.cfm" addtoken="no">
            </cfif>
            <cfif NOT StructKeyExists(form, "turnstile_secret_key") OR Len(Trim(form.turnstile_secret_key)) EQ 0>
                <cfset session.m = 35>
                <cflocation url="view_system_settings.cfm" addtoken="no">
            </cfif>
        </cfcase>
    </cfswitch>

    <!--- UPDATE CAPTCHA PROVIDER --->
    <cfquery datasource="hermes">
        UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.captcha_provider#">
        WHERE parameter = 'captcha_provider'
    </cfquery>

    <!--- UPDATE ALL PROVIDER KEYS (store them all regardless of selected provider) --->
    <cfquery datasource="hermes">
        UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.recaptcha_site_key)#">
        WHERE parameter = 'recaptcha_site_key'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.recaptcha_secret_key)#">
        WHERE parameter = 'recaptcha_secret_key'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.hcaptcha_site_key)#">
        WHERE parameter = 'hcaptcha_site_key'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.hcaptcha_secret_key)#">
        WHERE parameter = 'hcaptcha_secret_key'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.turnstile_site_key)#">
        WHERE parameter = 'turnstile_site_key'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE system_settings SET value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.turnstile_secret_key)#">
        WHERE parameter = 'turnstile_secret_key'
    </cfquery>

    <cfset session.m = 29>
    <cflocation url="view_system_settings.cfm" addtoken="no">

<!--- /CFIF #action# --->
</cfif>

<!--- CFML CODE ENDS HERE --->


<!--- ERROR MESSAGES START HERE --->

<cfif #m# is "1"> 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Host Name field must be a valid FQDN domain when Console Mode is set to Host Name (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Postmaster E-mail Address cannot be empty  (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Postmaster E-mail Address must be a valid e-mail address  (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "4">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Postmaster E-mail Address must be set to a domain that already exists in the system  (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "5">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Admin e-mail Address cannot be empty  (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "6">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Admin e-mail Address must be a valid e-mail address  (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "7">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The TimeZone cannot be empty (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "8">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The TimeZone you entered is invalid (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "9">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Serial Number field cannot be empty (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "10">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Serial Number you entered is  not valid. Serial Number can only contain upper/lower case letters and numbers (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "11">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must accept the License Agreement (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "12">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem attempting to reach the activation server. Specific error was: #session.errordetail#<br>Hermes SEG must have access to the URL <strong>activate.hermesseg.io</strong> over HTTPS (TCP/443) <strong>without SSL interception</strong> in order to activate your serial number. (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

  <cfset session.errordetail = 0>

</cfif>

<cfif #m# is "13">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem attempting to reach the activation server. Specific error was: #errordetail#<br>Hermes SEG must have access to the URL <strong>activate.hermesseg.io</strong> over HTTPS (TCP/443) <strong>without SSL interception</strong> in order to activate your serial number. (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

  <cfset session.errordetail = 0>

</cfif>



<cfif #m# is "14">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Serial Number you entered is  not valid. Please obtain a new Serial Number and try again. (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "15">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Serial Number was activated successfully</cfoutput> 
      
  </div>
  
  <cfset session.m = 0>
  
  </cfif>


<cfif #m# is "27">

<div class="alert alert-success alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-check"></i> Success!</h4>
  <cfoutput>System Settings were saved successfully</cfoutput> 
    
</div>

<cfset session.m = 0>

</cfif>


<cfif #m# is "28">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Generate DH Parameters File was started. This is going to take a long time to complete. Check back on this page for the Diffie-Hellman (DH) key-exchange drop-down option to appear. <strong>Do NOT</strong> start another Generate DH Parameters File process</cfoutput> 
      
  </div>
  
  <cfset session.m = 0>

  </cfif>

<cfif m EQ "29">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        Bot Protection (CAPTCHA) settings saved successfully
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "30">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        The Site Key field cannot be empty when Google reCAPTCHA is selected
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "31">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        The Secret Key field cannot be empty when Google reCAPTCHA is selected
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "32">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        The Site Key field cannot be empty when hCaptcha is selected
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "33">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        The Secret Key field cannot be empty when hCaptcha is selected
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "34">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        The Site Key field cannot be empty when Cloudflare Turnstile is selected
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "35">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        The Secret Key field cannot be empty when Cloudflare Turnstile is selected
    </div>
    <cfset session.m = 0>
</cfif>

<!--- ERROR MESSAGES END HERE --->

<span>
<p> 



<!--- GENERATE DH PARAMETERS BUTTON STARTS HERE --->
<cfoutput>
  <a href="##add_serial"  class="btn btn-primary" role="button" data-bs-toggle="modal" data-recipient="" data-recipientemail=""><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add Serial Number</a>
  </cfoutput>
<!--- GENERATE DH PARAMETERS ENDS HERE --->



</p>
</span>

<!--- GENERATE DH MODAL HTML STARTS HERE --->
   
<div class="modal fade" id="add_serial" tabindex="-1" role="dialog" aria-labelledby="AddSerialModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Add Serial Number</h4>
</div>
  
<div class="modal-body">


  <form name="addserial" method="post">

    <input type="hidden" name="action" value="Add Serial">

  
    <div class="form-group">
      <label for="certificate_name"><strong>Serial Number</strong></label>
      <input type="text" class="form-control" name="serial_number" value="" id="serial_number" placeholder="Enter the Serial Number that was provided to you">
    </div>


    <div class="form-group">
      <label for="tos">By entering a serial number and checking the box below, you acknowledge that the license of this software will convert from the free AGPLv3 license to the non-free proprietary Hermes SEG Pro license and you acknowledge that you have read and accept to be bound by  the Hermes SEG Pro License.</label>
   
      <cfif #tos# is "">

    
      <cfoutput>
      <input type="checkbox" name="tos" value="1">
      </cfoutput>
   

      <cfelseif #tos# is not "">

   
      <cfoutput>
      <input type="checkbox" name="tos" checked="checked" value="1">
      </cfoutput>
 
      </cfif>

    </div>

    <input type="submit" value="Submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
    
  </form>


</div>
<div class="modal-footer">
  

   
    

  <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Cancel</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE DH MODAL HTML ENDS HERE --->


<!--- SYSTEM SETTINGS CARD --->
<div class="card card-outline card-primary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-cogs me-2"></i>General Settings</h3>
    </div>
    <div class="card-body">
        <form name="edit_system_settings.cfm" method="post" action="">
            <input type="hidden" name="action" value="edit">

            <div class="mb-3">
                <label class="form-label"><strong>Postmaster E-mail Address</strong></label>
                <cfoutput>
                <input type="text" name="postmaster" class="postmaster form-control" id="postmaster" placeholder="Enter Postmaster E-mail Address" value="#get_postmaster.value#" autocomplete="off">
                </cfoutput>
            </div>

            <div class="mb-3">
                <label class="form-label"><strong>Admin E-mail Address</strong></label>
                <cfoutput>
                <input type="text" name="admin_email" class="admin_email form-control" id="admin_email" placeholder="Enter Admin E-mail Address" value="#get_admin_email.value#" autocomplete="off">
                </cfoutput>
            </div>

            <div class="mb-3">
                <label class="form-label"><strong>TimeZone</strong></label>
                <cfoutput>
                <input type="text" name="timezone" class="timezone form-control" id="timezone" placeholder="Start typing to search..." value="#get_timezone.value#" autocomplete="off">
                </cfoutput>
            </div>

            <div class="mb-3">
                <label class="form-label"><strong>Serial Number</strong></label>
                <cfoutput>
                <input type="text" name="serial_number" class="admin_email form-control" id="serial_number" placeholder="Serial Number" value="#get_serial.value#" autocomplete="off" readonly>
                </cfoutput>
            </div>

            <div class="mb-3">
                <label class="form-label"><strong>Daily Update Check</strong></label>
                <select class="form-control" name="update_check" style="width: 100%;" id="update_check">
                    <cfif #get_update.value# is "1">
                        <option value="1" selected>Enable (Recommended)</option>
                        <option value="2">Disable</option>
                    <cfelseif #get_update.value# is "2">
                        <option value="2" selected>Disable</option>
                        <option value="1">Enable (Recommended)</option>
                    </cfif>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label"><strong>Telemetry</strong></label>
                <div class="alert alert-warning">
                    <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i>Telemetry sends anonymized data to our servers in order to improve Hermes SEG and our services. <strong>We do NOT share or sell this data!!</strong> The data is strictly used for internal purposes. We appreciate leaving it enabled. For a detailed explanation of the data we collect, please <a href="https://docs.deeztek.com/books/hermes-seg-administrator-guide/page/system-settings" target="_blank">click here</a>.</p>
                </div>
                <select class="form-control" name="telemetry" style="width: 100%;" id="telemetry">
                    <cfif #get_telemetry.value# is "1">
                        <option value="1" selected>Enable (Recommended)</option>
                        <option value="2">Disable</option>
                    <cfelseif #get_telemetry.value# is "2">
                        <option value="2" selected>Disable</option>
                        <option value="1">Enable (Recommended)</option>
                    </cfif>
                </select>
            </div>

            <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='Please wait...';this.form.submit();">
                <i class="fas fa-save me-1"></i> Save Settings
            </button>
        </form>
    </div>
</div>

<!--- BOT PROTECTION SETTINGS CARD --->
<div class="card card-outline card-primary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-shield-alt me-2"></i>Bot Protection (CAPTCHA)</h3>
    </div>
    <div class="card-body">
        <div class="alert alert-info">
            <p class="mb-0"><i class="icon fas fa-info-circle"></i>
            CAPTCHA protects public-facing forms (Forgot Password, etc.) from automated abuse.
            Choose a provider below. The <strong>Built-in</strong> option uses a simple math question and requires no external service.
            </p>
        </div>

        <form name="captcha_settings" method="post" action="">
            <input type="hidden" name="action" value="save_captcha">

            <div class="mb-3">
                <label class="form-label"><strong>CAPTCHA Provider</strong></label>
                <select class="form-control" name="captcha_provider" id="captcha_provider" style="width: 100%">
                    <option value="builtin" <cfif captcha_provider EQ "builtin">selected</cfif>>Built-in (Math Question)</option>
                    <option value="recaptcha" <cfif captcha_provider EQ "recaptcha">selected</cfif>>Google reCAPTCHA v2</option>
                    <option value="hcaptcha" <cfif captcha_provider EQ "hcaptcha">selected</cfif>>hCaptcha</option>
                    <option value="turnstile" <cfif captcha_provider EQ "turnstile">selected</cfif>>Cloudflare Turnstile</option>
                </select>
                <div class="form-text">Select the CAPTCHA provider to use on public forms</div>
            </div>

            <!--- GOOGLE RECAPTCHA FIELDS --->
            <div id="recaptcha_fields" class="captcha-provider-fields" <cfif captcha_provider NEQ "recaptcha">style="display:none;"</cfif>>
                <div class="alert alert-secondary">
                    <small>Get your reCAPTCHA v2 keys from <a href="https://www.google.com/recaptcha/admin" target="_blank">Google reCAPTCHA Admin</a>.
                    Choose <strong>reCAPTCHA v2 "I'm not a robot" Checkbox</strong> when creating your keys.</small>
                </div>
                <div class="mb-3">
                    <label class="form-label"><strong>Site Key</strong></label>
                    <cfoutput>
                    <input type="text" class="form-control" name="recaptcha_site_key" value="#recaptcha_site_key#" placeholder="Enter your reCAPTCHA Site Key">
                    </cfoutput>
                </div>
                <div class="mb-3">
                    <label class="form-label"><strong>Secret Key</strong></label>
                    <cfoutput>
                    <input type="password" class="form-control" name="recaptcha_secret_key" value="#recaptcha_secret_key#" placeholder="Enter your reCAPTCHA Secret Key">
                    </cfoutput>
                </div>
            </div>

            <!--- HCAPTCHA FIELDS --->
            <div id="hcaptcha_fields" class="captcha-provider-fields" <cfif captcha_provider NEQ "hcaptcha">style="display:none;"</cfif>>
                <div class="alert alert-secondary">
                    <small>Get your hCaptcha keys from <a href="https://dashboard.hcaptcha.com" target="_blank">hCaptcha Dashboard</a>.
                    hCaptcha is a privacy-focused alternative to reCAPTCHA.</small>
                </div>
                <div class="mb-3">
                    <label class="form-label"><strong>Site Key</strong></label>
                    <cfoutput>
                    <input type="text" class="form-control" name="hcaptcha_site_key" value="#hcaptcha_site_key#" placeholder="Enter your hCaptcha Site Key">
                    </cfoutput>
                </div>
                <div class="mb-3">
                    <label class="form-label"><strong>Secret Key</strong></label>
                    <cfoutput>
                    <input type="password" class="form-control" name="hcaptcha_secret_key" value="#hcaptcha_secret_key#" placeholder="Enter your hCaptcha Secret Key">
                    </cfoutput>
                </div>
            </div>

            <!--- CLOUDFLARE TURNSTILE FIELDS --->
            <div id="turnstile_fields" class="captcha-provider-fields" <cfif captcha_provider NEQ "turnstile">style="display:none;"</cfif>>
                <div class="alert alert-secondary">
                    <small>Get your Turnstile keys from <a href="https://dash.cloudflare.com/?to=/:account/turnstile" target="_blank">Cloudflare Dashboard</a>.
                    Turnstile is a user-friendly, privacy-preserving alternative that often doesn't require user interaction.</small>
                </div>
                <div class="mb-3">
                    <label class="form-label"><strong>Site Key</strong></label>
                    <cfoutput>
                    <input type="text" class="form-control" name="turnstile_site_key" value="#turnstile_site_key#" placeholder="Enter your Turnstile Site Key">
                    </cfoutput>
                </div>
                <div class="mb-3">
                    <label class="form-label"><strong>Secret Key</strong></label>
                    <cfoutput>
                    <input type="password" class="form-control" name="turnstile_secret_key" value="#turnstile_secret_key#" placeholder="Enter your Turnstile Secret Key">
                    </cfoutput>
                </div>
            </div>

            <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='Please wait...';this.form.submit();">
                <i class="fas fa-save me-1"></i> Save CAPTCHA Settings
            </button>
        </form>
    </div>
</div>

<!-- SYSTEM SETTINGS FORM ENDS HERE -->

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


<!--- SCRIPT TO SHOW/HIDE SET CONSOLE HOST SCRIPT STARTS HERE  --->
<script>

  $('#console_mode').on('change',function(){
    if( $(this).val()==="fqdn"){
    $("#console_host").show()
    }
    else{
    $("#console_host").hide()
    }
  });
  
  </script>
   <!--- SCRIPT TO SHOW/HIDE SET CONSOLE HOST SCRIPT ENDS HERE  --->

 <!--- SCRIPT TO GET CERTIFICATES BELOW --->

<script type="text/javascript">
  $(document).ready(function(){

      $(document).on('keydown', '.timezone', function() {
          
          var id = this.id;
          var splitid = id.split('_');
          var index = splitid[1];

          $( '#'+id ).autocomplete({
              source: function( request, response ) {
                  $.ajax({
                      url: "./inc/gettimezones.cfm",
                      type: 'post',
                      dataType: "json",
                      data: {
                          search: request.term,request:1
                      },
                      success: function( data ) {
                          response( data );
                      }
                  });
              },
              select: function (event, ui) {
                  $(this).val(ui.item.label); // display the selected text
                  var id = ui.item.value; // selected id to input

                  // AJAX
                  $.ajax({
                      url: './inc/gettimezones.cfm',
                      type: 'post',
                      data: {id:id,request:2},
                      dataType: 'json',
                      success:function(response){
                          
                          var len = response.length;

                          if(len > 0){
                              var timezone_id = response[0]['id'];
                              var timezone = response[0]['timezone'];
                                       
                              document.getElementById('timezoneid_'+index).value = timezone_id;
                              document.getElementById('timezone_'+index).value = timezone;
                                                
                        
                              
                          }
                          
                      }
                  });

                  return false;
              }
          });
      });
      
      

  });

</script>

<!--- SCRIPT TO SHOW/HIDE CAPTCHA PROVIDER FIELDS --->
<script>
$('#captcha_provider').on('change', function(){
    // Hide all provider fields
    $('.captcha-provider-fields').hide();

    // Show fields for selected provider
    var provider = $(this).val();
    if(provider === "recaptcha"){
        $("#recaptcha_fields").show();
    } else if(provider === "hcaptcha"){
        $("#hcaptcha_fields").show();
    } else if(provider === "turnstile"){
        $("#turnstile_fields").show();
    }
    // 'builtin' doesn't need any fields
});
</script>

</html>