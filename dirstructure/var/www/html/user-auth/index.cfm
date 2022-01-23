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

<!---
<cfoutput>#reason#</cfoutput>
--->

<cfif #session.UserPassword# is "0">

<cfoutput>
<cflocation url="set_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no">
</cfoutput>

<!--- /CFIF #session.UserPassword# is "0" --->
</cfif>

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
  <CFSET session.reason = 8>

  <cfoutput>
  <cflocation url="/user-auth/?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no"/>
  </cfoutput>



<!--- /CFIF for form.action is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists form.action --->
</cfif>


<cfif #action# is "login">

<cfparam name = "username" default = "">
<cfif StructKeyExists(form, "username")>
<cfif form.username is not "">
<cfset username = form.username>

<cfelse>

  <cfset session.logoncount = #logoncount# + 1>
  <CFSET session.reason = 1>

   <cfoutput>
  <cflocation url="/user-auth/?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no"/>
  </cfoutput>
 

<!--- /CFIF for form.username is not "" --->
</cfif>

<cfelse>

  <cfset session.logoncount = #logoncount# + 5>
  <CFSET session.reason = 2>

  <cfoutput>
  <cflocation url="/user-auth/?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no"/>
  </cfoutput>


<!--- /CFIF for StructKeyExists form.username --->
</cfif>

<cfparam name = "password" default = "">
<cfif StructKeyExists(form, "password")>
<cfif form.password is not "">
<cfset password = form.password>

<cfelse>

  <cfset session.logoncount = #logoncount# + 1>
  <CFSET session.reason = 3>

   <cfoutput>
  <cflocation url="/user-auth/?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no"/>
  </cfoutput>


<!--- /CFIF for form.usrname is not "" --->
</cfif>

<cfelse>

<cfset session.logoncount = #logoncount# + 5>
<CFSET session.reason = 4>

<cfoutput>
  <cflocation url="/user-auth/?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no"/>
  </cfoutput>
 

<!--- /CFIF for StructKeyExists form.password --->
</cfif>

<cfif #logoncount# GT 5>
<CFSET session.reason = 5>

<cfoutput>
  <cflocation url="/user-auth/?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no"/>
  </cfoutput>


<cfelseif #logoncount# LTE 5>

<cfquery name="checkrestore" datasource="hermes">
select status from restore_jobs where status='running'
</cfquery>

<cfif #checkrestore.recordcount# GTE 1>
<CFSET session.reason = 6>

<cfoutput>
  <cflocation url="/user-auth/?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no"/>
  </cfoutput>

<!--- /CFIF #checkrestore.recordcount# GTE 1 --->
</cfif>

<CFSET SESSION.LOGGEDIN = FALSE>

<cfparam name = "step" default = "0"> 

<cfquery name="getpassword" datasource="#datasource#">
  select email, password from user_settings where id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uid#">
  </cfquery>
  

<cfset theSalt="#Left(getpassword.password, 30)#">

<cfloop index="hashCount" from="1" to="10000">
<cfset passwordHash512=Hash(form.password & theSalt, 'SHA-512', 'UTF-8') />
</cfloop>


<cfset thePassword="#theSalt##passwordHash512#" />

<cfset compare_password = Compare(#thePassword#, #getpassword.password#)>

<cfif #compare_password# is "1">

<cfset session.logoncount = #logoncount# + 1>

<CFSET session.reason = 7>

<cfoutput>
<cflocation url="/user-auth/?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no"/>
</cfoutput>



<cfelseif #compare_password# is "-1">

<cfset session.logoncount = #logoncount# + 1>

<CFSET session.reason = 7>

<cfoutput>
  <cflocation url="/user-auth/?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#" addtoken="no"/>
  </cfoutput>


<cfelseif #compare_password# is "0">

  <cfset session.UserLoggedin = true>
  <cfset session.logoncount = 1>
  
  <cfquery name="getid" datasource="#datasource#">
  select id from maddr where email='#getpassword.email#'
  </cfquery>
  
  <cfset session.owner = #getid.id#>
  <cfset session.email = #getemail.email#>
  <cfset session.uid = #uid#>
  <cfset session.train_bayes = #getemail.train_bayes#>
  <cfset session.download_msg = #getemail.download_msg#>
  <cfset session.reason = "0">
  
  <cfquery name="getdestination" datasource="#datasource#">
  select destination from user_destinations where id='#dest#'
  </cfquery>
  
  <cfif #dest# is "7">
  <cflocation url="/users/#getdestination.destination#?mid=#URLEncodedFormat(Trim(mid))#" addtoken="no">
  <cfelseif #dest# is "8">
  <cflocation url="/users/#getdestination.destination#?mid=#URLEncodedFormat(Trim(mid))#&sid=#URLEncodedFormat(Trim(sid))#" addtoken="no">
  <cfelse>
  <cflocation url="/users/#getdestination.destination#" addtoken="no">
  </cfif>
  
  <!-- /CFIF FOR COMPAREPASSWORD -->
  </cfif>
  
  
  <!-- /CFIF FOR LOGONCOUNT -->
  </cfif>
  
  <!-- /CFIF FOR ACTION -->
  </cfif>

<!-- CFML CODE ENDS HERE -->




<body class="hold-transition login-page">
<div class="login-box">

  <cfif #session.UserLoggedin# is "false">

  <!-- ERROR MESSAGES STARTS HERE -->

  <cfif #reason# is "1">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Username cannot be blank. Logon attempt #logoncount# of 5</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>
  
  <cfif #reason# is "2">
  
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The system has detected illegal activity (form.username does not exist). The login failure count is increased by 5</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>
  
  
  <cfif #reason# is "3">
  
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The Password cannot be blank. Logon attempt #logoncount# of 5</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>
  
  
  <cfif #reason# is "4">
  
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The system has detected illegal activity (form.password does not exist). The login failure count is increased by 5</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>
  
  <cfif #reason# is "5">
  
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>You have exceeded the maximum number of login attempts. Please wait 1 hour before trying to login again</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>
  
  <cfif #reason# is "6">
  
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>System Restore is in Progress. You will not be be able to log into the system until the process has completed</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>
  
  <cfif #reason# is "7">
  
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The username/password combination you typed is invalid. Please try again. Logon attempt #logoncount# of 5</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>
  
  <cfif #reason# is "8">
  
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>The system has detected illegal activity (form.action is not login). The login failure count is increased by 5</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>


<!-- ERROR MESSAGES ENDS HERE -->


  <!-- /.login-logo -->
  <div class="card card-outline card-primary">
    <div class="card-header text-center">
      <a href="../../index2.html" class="h1"><b>Hermes</b>&nbsp;SEG</a>
    </div>
    <div class="card-body">
      <p class="login-box-msg">User Console</p>

      <form action="" method="post">
        <input type="hidden" name="action" value="login">
        <div class="input-group mb-3">

          <cfoutput>
          <input type="text" name="username" value="#getemail.email#" class="form-control" placeholder="Username" readonly>
        </cfoutput>

          <div class="input-group-append">
            <div class="input-group-text">
              <span class="fas fa-user"></span>
            </div>
          </div>
        </div>
        <div class="input-group mb-3">
          <input type="password" name="password" class="form-control" placeholder="Password" maxLength="64">
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
<div>&nbsp;</div>
      <div style="float: right;">
        <cfoutput>
        <a href="set_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#">Forgot Password?</a>
      </cfoutput>
      </div>

    <cfelseif #session.UserLoggedin# is "true">

      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Logged In!</h4>
        <cfoutput>You are already logged in to the system. Access the <a href="/users/2/">User Console</a> or <a href="/users/2/logout.cfm">Logout</a></cfoutput><br> 
      </div>

      <!--- /CFIF #session.UserLoggedin# is --->
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
