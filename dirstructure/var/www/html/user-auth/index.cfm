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
  <title>Hermes SEG | Login</title>

  <!-- Google Font: Source Sans Pro -->
  <!---
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  --->
  <!-- Font Awesome -->
  <link rel="stylesheet" href="./plugins/fontawesome-free/css/all.min.css">
  <!-- icheck bootstrap -->
  <link rel="stylesheet" href="./plugins/icheck-bootstrap/icheck-bootstrap.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="./dist/css/adminlte.min.css">
</head>

<!-- CFML CODE STARTS HERE -->

<cfparam name = "logoncount" default = "1">
<cfif StructKeyExists(session, "logoncount")>
<cfif session.logoncount is not "">
<cfset logoncount = session.logoncount>

<!--- /CFIF for session.logoncount is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.logoncount --->
</cfif>


<cfparam name = "action" default = "">

<cfif StructKeyExists(form, "action")>

<cfif form.action is "login">

<cfset action = form.action>


<cfelse>

  <cfset session.logoncount = #logoncount# + 5>
  <CFSET session.reason = 'The system has detected illegal activity (form.action is not login). The login failure count is increased by 5'>
  <CFLOCATION url="index.cfm" addtoken="no">  

<!--- /CFIF for form.action is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists form.action --->
</cfif>

<cfparam name = "reason" default = "">
<cfif StructKeyExists(session, "reason")>
<cfif session.reason is not "">
<cfset reason = session.reason>

<!--- /CFIF for session.reason is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.reason --->
</cfif>


<cfparam name = "loggedin" default = "false">
<cfif StructKeyExists(session, "loggedin")>
<cfif session.loggedin is not "">
<cfset loggedin = session.loggedin>

<!--- /CFIF for session.loggedin is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists session.loggedin --->
</cfif>

<cfif #action# is "login">

<cfparam name = "username" default = "">
<cfif StructKeyExists(form, "username")>
<cfif form.username is not "">
<cfset username = form.username>

<cfelse>

  <cfset session.logoncount = #logoncount# + 1>
  <CFSET session.reason = 'The Username cannot be blank. Logon attempt #logoncount# of 5'>
  <CFLOCATION url="index.cfm" addtoken="no">  

<!--- /CFIF for form.username is not "" --->
</cfif>

<cfelse>

  <cfset session.logoncount = #logoncount# + 5>
  <CFSET session.reason = 'The system has detected illegal activity (form.username does not exist). The login failure count is increased by 5'>
  <CFLOCATION url="index.cfm" addtoken="no">  

<!--- /CFIF for StructKeyExists form.username --->
</cfif>

<cfparam name = "password" default = "">
<cfif StructKeyExists(form, "password")>
<cfif form.password is not "">
<cfset password = form.password>

<cfelse>

  <cfset session.logoncount = #logoncount# + 1>
  <CFSET session.reason = 'The Password cannot be blank. Logon attempt #logoncount# of 5'>
  <CFLOCATION url="index.cfm" addtoken="no">  

<!--- /CFIF for form.usrname is not "" --->
</cfif>

<cfelse>

<cfset session.logoncount = #logoncount# + 5>
<CFSET session.reason = 'The system has detected illegal activity (form.password does not exist). The login failure count is increased by 5'>
<CFLOCATION url="index.cfm" addtoken="no">  

<!--- /CFIF for StructKeyExists form.password --->
</cfif>

<cfif #logoncount# GT 5>
<CFSET session.reason = 'You have exceeded the maximum number of logons. Please wait 1 hour before trying to login again'>
<CFLOCATION url="index.cfm" addtoken="no">

<cfelseif #logoncount# LTE 5>

<cfquery name="checkrestore" datasource="hermes">
select status from restore_jobs where status='running'
</cfquery>

<cfif #checkrestore.recordcount# GTE 1>
<CFSET session.reason = 'System Restore is in Progress. You will not be be able to log into the system until the process has completed'>
<CFLOCATION url="index.cfm" addtoken="no">
</cfif>

<CFSET SESSION.LOGGEDIN = FALSE>
<cfparam name = "step" default = "0"> 

<CFQUERY NAME="checkuser" DATASOURCE="hermes">
	SELECT username, password
	FROM system_users
	WHERE username='#username#'
</CFQUERY>

<!-- is the username present in the database? -->

<cfif checkuser.recordcount LTE 0>

<cfset session.logoncount = #logoncount# + 1>
<CFSET session.reason = 'The username/password combination you typed is invalid. Please try again. Logon attempt #logoncount# of 5'>
<CFLOCATION url="index.cfm" addtoken="no">

<cfelseif checkuser.recordcount GT 0>

<cfset theSalt="#Left(checkuser.password, 30)#">

<cfloop index="hashCount" from="1" to="5000">
<cfset passwordHash512=Hash(form.password & theSalt, 'SHA-512', 'UTF-8') />
</cfloop>


<cfset thePassword="#theSalt##passwordHash512#" />

<cfset compare_password = Compare(#thePassword#, #checkuser.password#)>

<cfif #compare_password# is "1">

<cfset session.logoncount = #logoncount# + 1>
<CFSET session.reason = 'The username/password combination you typed is invalid. Please try again. Logon attempt #logoncount# of 5'>
<CFLOCATION url="index.cfm" addtoken="no">


<cfelseif #compare_password# is "-1">
<cfset session.logoncount = #logoncount# + 1>
<CFSET session.reason = 'The username/password combination you typed is invalid. Please try again. Logon attempt #logoncount# of 5'>
<CFLOCATION url="index.cfm" addtoken="no">

<cfelseif #compare_password# is "0">
<cfset session.loggedin = true>
<cfset session.logoncount = 1>

<cfexecute name = "/opt/hermes/scripts/dmidecode"
arguments=""
timeout = "60">
</cfexecute>

<cffile action="read" file="/usr/share/UUID" variable="temp1">

<cfset temp2="#REReplace("#temp1#","#chr(10)#","","ALL")#">

<cfset temp3="#REReplace("#temp2#","#chr(13)#","","ALL")#">
<cfset temp4="#REReplace("#temp3#","","","ALL")#">
<cfset temp5="#REReplace("#temp4#","UUID:","","ALL")#">

<cffile action = "write"
    file = "/usr/share/UUID"
    output = "#TRIM(temp5)#" addnewline="no">

<cfset uuid2_file="/usr/share/UUID2">
<cfif fileExists(uuid2_file)> 

<cffile action="read" file="/usr/share/UUID" variable="uuid">
<cffile action="read" file="/usr/share/UUID2" variable="uuid2">
<cfset compare_uuid = Compare(#uuid#, #uuid2#)>

<cfif #compare_uuid# is "0">

<cffile action="read" file="/usr/share/lt" variable="lt">

<cfset lt2=#TRIM(lt)#>

<cfif #lt2# is "1">
<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH:mm:ss")#">
<cffile action="read" file="/usr/share/djigzo/ADDITIONAL-NOTES.TXT" variable="date">
<cfset difference = #datediff("d", '#datenow# #timenow#', '#date#')#>

<cfif #difference# LT 1>

<cfquery name="getserial" datasource="hermes">
select parameter, value from system_settings where parameter='serial'
</cfquery>

<cffile action = "write"
    file = "/usr/share/UUID3"
    output = "#TRIM(getserial.value)#" addnewline="no">

<cffile action = "delete"
    file = "/usr/share/UUID2">

<cfset session.license="NEW">
<cfset session.edition="Community">
<CFSET session.reason = "">
<CFLOCATION url="../admin/index.cfm" addtoken="no">

<cfelseif #difference# GTE 1>
<cfset session.license="VALID">
<cfset session.edition="Pro">
<CFSET session.reason = "">

<CFLOCATION url="../admin/index.cfm" addtoken="no">

</cfif>

<cfelseif #lt2# is "2">
<cfset session.license="VALID">
<cfset session.edition="Pro">
<CFSET session.reason = "">

<CFLOCATION url="../admin/index.cfm" addtoken="no">

</cfif>

<cfelseif #compare_uuid# is "1">
<cfquery name="getserial" datasource="hermes">
select parameter, value from system_settings where parameter='serial'
</cfquery>

<cffile action = "write"
    file = "/usr/share/UUID3"
    output = "#TRIM(getserial.value)#" addnewline="no">

<cfset session.license="VIOLATION">
<cfset session.edition="Pro">
<CFSET session.reason = "">

<CFLOCATION url="../admin/index.cfm" addtoken="no">

<cfelseif #compare_uuid# is "-1">
<cfquery name="getserial" datasource="hermes">
select parameter, value from system_settings where parameter='serial'
</cfquery>


<cffile action = "write"
    file = "/usr/share/UUID3"
    output = "#TRIM(getserial.value)#" addnewline="no">

<cfset session.license="VIOLATION">
<cfset session.edition="Pro">
<CFSET session.reason = "">

<CFLOCATION url="../admin/index.cfm" addtoken="no">

</cfif>

<cfelseif NOT fileExists(uuid2_file)> 
<cfset session.license="NEW">
<cfset session.edition="Community">
<CFSET session.reason = "">

<CFLOCATION url="../admin/index.cfm" addtoken="no">

</cfif>


</cfif>
</cfif>

<!-- /CFIF FOR LOGONCOUNT -->
</cfif>

<!-- /CFIF FOR ACTION -->
</cfif>

<!-- CFML CODE ENDS HERE -->




<body class="hold-transition login-page">
<div class="login-box">

  <cfif #loggedin# is "false">

  <!-- ERROR MESSAGES STARTS HERE -->

<cfif #reason# is "">

<cfelse>


  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>#reason#</cfoutput>
  </div>

  <CFSET session.reason = "">

  <!--- /CFIF session.reason is  --->
</cfif>


<!-- ERROR MESSAGES ENDS HERE -->


  <!-- /.login-logo -->
  <div class="card card-outline card-primary">
    <div class="card-header text-center">
      <a href="../../index2.html" class="h1"><b>Hermes</b>&nbsp;SEG</a>
    </div>
    <div class="card-body">
      <p class="login-box-msg">Administration Console</p>

      <form action="" method="post">
        <input type="hidden" name="action" value="login">
        <div class="input-group mb-3">
          <input type="text" name="username" class="form-control" placeholder="Username">
          <div class="input-group-append">
            <div class="input-group-text">
              <span class="fas fa-user"></span>
            </div>
          </div>
        </div>
        <div class="input-group mb-3">
          <input type="password" name="password" class="form-control" placeholder="Password">
          <div class="input-group-append">
            <div class="input-group-text">
              <span class="fas fa-lock"></span>
            </div>
          </div>
        </div>
        
        <div class="row">
          <div class="col-8">
            <div class="icheck-primary">
              <!---
              <input type="checkbox" id="remember">
              <label for="remember">
                Remember Me
              </label>
            --->
            </div>
          </div>

          <!-- /.col -->
          <div class="col-4">

            <input type="submit" class="btn btn-primary btn-block" name="" value="Sign In" class="form-control primary" onclick="this.disabled=true;this.value='Please wait';this.form.submit();">

            <!---
            <button type="submit" class="btn btn-primary btn-block" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Sign In</button>
            --->

          </div>
          <!-- /.col -->
        </div>
      </form>

    <cfelseif #loggedin# is "true">

      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Logged In!</h4>
        <cfoutput>You are already logged in to the system. Access the <a href="../admin/">Administration Console</a> or <a href="../admin/logout.cfm">Logout</a></cfoutput><br> 
      </div>

      <!--- /CFIF #loggedin# is --->
    </cfif>

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
