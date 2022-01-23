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
  <title>Hermes SEG | Set Password</title>

  <cfinclude template="./inc/html_head.cfm" />

</head>

<!-- CFML CODE STARTS HERE -->

<cfparam name = "reason" default = "0">
<cfif StructKeyExists(session, "reason")>
<cfif session.reason is not "">
<cfset reason = session.reason>

<!--- /CFIF for session.reason is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.reason --->
</cfif>


<cfparam name = "action" default = "">

<cfif StructKeyExists(form, "action")>

<cfif form.action is "sendcode">

<cfset action = form.action>


<cfelse>


  <cfset m="User Forgot Password: form.action is not sendcode">
  <cfinclude template="error.cfm">
  <cfabort>



<!--- /CFIF for form.action is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists form.action --->
</cfif>




<cfif #action# is "sendcode">

  <cfquery name="checkresetcode" datasource="hermes">
    select id, reset_password_datetime from user_settings where id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uid#">
    </cfquery>
  
  <cfif #checkresetcode.reset_password_datetime# is not "">
  
  <cfset date=dateformat(Now(),"yyyy/mm/dd")>
  <cfset time=timeformat(Now(),"HH:MM:SS")>
  
  <cfif DateDiff("n", "#checkresetcode.reset_password_datetime#", "#date# #time#") lte 15>
  

    <CFSET session.reason = 1>

    <cfoutput>
    <cflocation url="set_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no"/>
    </cfoutput>
  
  <cfelse>

    <cfinclude template="send_reset_email.cfm">


  
    
<!--- DateDiff("n", "#checkresetcode.reset_password_datetime#", "#date# #time#") lte 5 --->
  </cfif>

<cfelse>

<cfinclude template="send_reset_email.cfm">

  <!--- #checkresetcode.reset_password_datetime# is not "" --->
</cfif>
  
  <!-- /CFIF FOR ACTION -->
  </cfif>

<!-- CFML CODE ENDS HERE -->




<body class="hold-transition login-page">
<div class="login-box">


  <!-- ERROR MESSAGES STARTS HERE -->

  <cfif #reason# is "1">

    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <!---
      <h4><i class="icon fa fa-exclamation"></i> Oops!</h4>
      --->
      <i class="icon fas fa-exclamation-triangle"></i><cfoutput>The system has detected that there is a pending password reset request. <br><strong>The system allows only one password reset request every 15 minutes.</strong> <br>Please check your e-mail and follow the instructions to reset your password.  Alternatively, you can wait 5 minutes before trying to reset your password again. <strong>You may close this browser window.</strong></cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>

  
<cfif #reason# is "2">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <!---
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    --->
    <i class="icon fa fa-check"></i><cfoutput>The System has sent a code and instructions to your e-mail address. Please follow the instructions in that e-mail to reset your password. <strong>You may close this browser window.</strong></cfoutput>
  </div>

  <cfset session.reason = 0>

</cfif>


<!-- ERROR MESSAGES ENDS HERE -->



  <!-- /.login-logo -->
  <div class="card card-outline card-primary">
    <div class="card-header text-center">
     <h2><b>Hermes</b>&nbsp;SEG</h2>
    </div>
    <div class="card-body">

    <cfif #session.UserPassword# is "0">

   <H4 class="text-center">Set Password</H5>

  <p class="text-center">The system has detected that this is the first time you are attempting to Sign In to the User Console or your password has expired. You must create a new password before you can Sign In. <br><br>Please click the <strong>Send Code</strong> button below and the system will send a password set code to your e-mail address. Follow the instructions in that e-mail to set your new password</p>

  <cfelseif #session.UserPassword# is "1">

    <H4 class="text-center">Reset Password</H5>

      <p class="text-center">Please click the <strong>Send Code</strong> button below and the system will send a password reset code to your e-mail address. Follow the instructions in that e-mail to reset your password</p>

    <cfelse>

      <cfset m="User Set Password: session.UserPassword is not 0 or 1">
      <cfinclude template="error.cfm">
      <cfabort>

      <!--- #session.UserPassword# is --->
    </cfif>


<cfoutput>
      <form action="set_password.cfm?uid=#url.uid#&dest=#url.dest#" method="post">
      </cfoutput>
        <input type="hidden" name="action" value="sendcode">
    

         
          <div>
 
            <input type="submit" class="btn btn-primary btn-block" name="" value="Send Code" class="form-control primary" onclick="this.disabled=true;this.value='Please wait';this.form.submit();">

    
          </div>

      
          <!-- /.col -->

      
      </form>




      <!---
      <div class="social-auth-links text-center mt-2 mb-3">
        <a href="#" class="btn btn-block btn-primary">
          <i class="fab fa-facebook mr-2"></i> Sign in using Facebook
        </a>
        <a href="#" class="btn btn-block btn-danger">
          <i class="fab fa-google-plus mr-2"></i> Sign in using Google+
        </a>
      </div>
      <!-- /.social-auth-links -->
    --->

    <!---
      <p class="mb-1">
        <a href="forgot-password.html">I forgot my password</a>
      </p>
    --->
      <!---
      <p class="mb-0">
        <a href="register.html" class="text-center">Register a new membership</a>
      </p>
    --->
    </div>
    <!-- /.card-body -->
  </div>
  <!-- /.card -->
</div>
<!-- /.login-box -->

<!-- jQuery -->
<script src="../../plugins/jquery/jquery.min.js"></script>
<!-- Bootstrap 4 -->
<script src="../../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<!-- AdminLTE App -->
<script src="../../dist/js/adminlte.min.js"></script>
</body>
</html>
