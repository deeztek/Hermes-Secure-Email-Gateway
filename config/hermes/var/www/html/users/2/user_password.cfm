<!DOCTYPE html>

  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

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
  <title>Hermes SEG | Change Password</title>

  <cfinclude template="./inc/html_head.cfm" />



<!--- SCRIPT TO SHOW/HIDE UPDATE PASSWORD --->

<!--- SCRIPT TO SHOW/HIDE UPDATE PASSWORD --->
<script>

  $(document).ready(function() {
      $("#oldpasswordfield a").on('click', function(event) {
          event.preventDefault();
          if($('#oldpasswordfield input').attr("type") == "text"){
              $('#oldpasswordfield input').attr('type', 'password');
              $('#oldpasswordfield i').addClass( "fa-eye-slash" );
              $('#oldpasswordfield i').removeClass( "fa-eye" );
          }else if($('#oldpasswordfield input').attr("type") == "password"){
              $('#oldpasswordfield input').attr('type', 'text');
              $('#oldpasswordfield i').removeClass( "fa-eye-slash" );
              $('#oldpasswordfield i').addClass( "fa-eye" );
          }
      });
  });
  
    </script>

<script>

  $(document).ready(function() {
      $("#newpasswordfield a").on('click', function(event) {
          event.preventDefault();
          if($('#newpasswordfield input').attr("type") == "text"){
              $('#newpasswordfield input').attr('type', 'password');
              $('#newpasswordfield i').addClass( "fa-eye-slash" );
              $('#newpasswordfield i').removeClass( "fa-eye" );
          }else if($('#newpasswordfield input').attr("type") == "password"){
              $('#newpasswordfield input').attr('type', 'text');
              $('#newpasswordfield i').removeClass( "fa-eye-slash" );
              $('#newpasswordfield i').addClass( "fa-eye" );
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
            <h1 class="m-0">Change Password</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Change Password</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

    
    
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

  
    <cfparam name = "step" default = "0">

    <cfparam name = "action" default = "">

<cfif StructKeyExists(form, "action")>

<cfif form.action is "setpassword">

<cfset action = form.action>


<cfelse>


<cfset m="User Change Password: form.action is not setpassword">
<cfinclude template="./inc/error.cfm">
<cfabort>



<!--- /CFIF for form.action is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists form.action --->
</cfif>

<cfparam name = "hibp" default = "YES">

<cfif StructKeyExists(form, "hibp")>

<cfif form.hibp is "YES" OR form.hibp is "NO">

<cfset action = form.action>


<cfelse>


<cfset m="User Change Password: form.hibp is not YES or NO">
<cfinclude template="./inc/error.cfm">
<cfabort>



<!--- /CFIF for form.hibp is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists form.hibp --->
</cfif>

  

  
        <!--- ERROR MESSAGES START HERE --->

        
  
        <cfif #m# is "1">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Existing Password field cannot be blank</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "2">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The New Password field cannot be blank</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "3">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The New Password must be between 8 and 64 characters</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "4">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The Existing Password you entered is incorrect</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "5">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>The New Password you are attempting to use has previously appeared in a data breach. Please use another password. Password was checked by <a href="https://haveibeenpwned.com/Passwords" target="_blank">haveibeenpwned.com</a></cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>

        <cfif #m# is "6">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>There was a problem checking your password against haveibeenpwned.com. Please set the <strong>Check Password Against haveibeenpwned.com</strong> field to NO and try again</cfoutput>
          </div>

          <cfset session.m = 0>
        
        </cfif>


          
        <cfif #m# is "7">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Your Password was changed successfully. Please ensure you use the new password to login from now on</cfoutput><br>



          </div>

          <cfset session.m = 0>

        </cfif>

        <cfif #m# is "8">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>Your account is not configured for password changes. Please contact your system administrator.</cfoutput>
          </div>

          <cfset session.m = 0>

        </cfif>

        <cfif #m# is "9">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>There was a problem changing your password. Please try again or contact your system administrator.</cfoutput>
          </div>

          <cfset session.m = 0>

        </cfif>

        <!--- ERROR MESSAGES END HERE --->

        
 
  
<cfif #action# is "setpassword">

<!--- VALIDATE FORM INPUTS STARTS HERE --->
<cfif NOT StructKeyExists(form, "oldpassword")>
  
  <cfset m="User Change Password: form.oldpassword does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelse>

<cfif #form.oldpassword# is "">
  
  <cfset step=0>
  <cfset session.m = 1>
  <cflocation url="user_password.cfm" addtoken="no">

<!--- /CFIF #form.oldpassword# is "" --->
</cfif>
  
  <!--- /CFIF StructKeyExists(form, "password") --->
  </cfif>

  <cfif NOT StructKeyExists(form, "newpassword")>
  
    <cfset m="User Change Password: form.newpassword does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

  <cfelse>

    <cfif #form.newpassword# is "">
  
      <cfset step=0>
      <cfset session.m = 2>
      <cflocation url="user_password.cfm" addtoken="no">
    
    <!--- /CFIF #form.newpassword# is "" --->
    </cfif>
    
    <!--- /CFIF StructKeyExists(form, "password") --->
    </cfif>
  


  <cfif NOT StructKeyExists(form, "hibp")>
  
    <cfset m="User Change Password: form.hibp does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
    <cfelse>
  
    <cfif form.hibp is "YES" OR form.hibp is "NO">
  
    <cfelse>
    
    <cfset m="Change User Password: form.hibp is not YES or NO">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    
    <!--- /CFIF form.hibp is "YES" OR form.hibp is "NO" --->
    </cfif>
    
    <!--- /CFIF StructKeyExists(form, "hibp") --->
    </cfif>


    
    <!--- VALIDATE FORM INPUTS ENDS HERE --->

      <!--- CODE TO ENFORCE MIN 8 CHARACTER LENGTH --->
    <cfif NOT ( len(form.newpassword) GTE 8)>

      <cfset step=0>
      <cfset session.m=3>
      <cflocation url="user_password.cfm" addtoken="no">
      
      <!--- CODE TO ENFORCE MIN 64 CHARACTER LENGTH --->
      <cfelseif NOT ( len(form.newpassword) LTE 64)>

      <cfset step=0>
      <cfset session.m=3>
      <cflocation url="user_password.cfm" addtoken="no">
        
      <cfelse>
      
      <cfset step=1>
      
      <!--- /CFIF NOT ( len(form.newpassword) GTE 8) --->
      </cfif>

      <cfif #step# is "1">

        <!--- GET LDAP USERNAME FOR THIS USER --->
        <!--- First check database, then fall back to LDAP query --->
        <cfquery name="getLdapUsername" datasource="hermes">
          SELECT ldap_username FROM user_settings WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.email#">
        </cfquery>

        <cfif getLdapUsername.recordcount EQ 1 AND getLdapUsername.ldap_username NEQ "">
            <!--- Found in database --->
            <cfset ldapUsername = getLdapUsername.ldap_username>
        <cfelse>
            <!--- Not in database - query LDAP directly by email --->
            <cfset userEmail = session.email>
            <cfinclude template="/user-auth/inc/ldap_get_user_groups.cfm">

            <cfif ldapUserFound AND ldapUsername NEQ "">
                <!--- Found in LDAP - use it --->
                <!--- ldapUsername is already set by the include --->
            <cfelse>
                <!--- No LDAP user found - cannot change password --->
                <cfset step=0>
                <cfset session.m=8>
                <cflocation url="user_password.cfm" addtoken="no">
            </cfif>
        </cfif>

        <!--- VERIFY OLD PASSWORD VIA LDAP BIND --->
        <!--- All users are in ou=users - role is determined by group membership --->
        <cfset ldapOU = "users">
        <cfset ldapBindDN = "cn=#ldapUsername#,ou=#ldapOU#,dc=hermes,dc=local">

        <!--- Attempt LDAP bind to verify old password using docker exec ldapwhoami --->
        <!--- This is more reliable than cfldap direct connection --->
        <cftry>
            <!--- Generate unique temp filename using standard method --->
            <cfinclude template="/admin/2/inc/generate_customtrans.cfm">

            <!--- Write password to temp file to avoid shell escaping issues --->
            <cfset tempPwdFile = "/opt/hermes/tmp/#customtrans3#_pwd.txt">
            <cffile action="write" file="#tempPwdFile#" output="#form.oldpassword#" addNewLine="no">

            <!--- Use ldapwhoami to verify password - binds and returns DN if successful --->
            <cfexecute name="/usr/local/bin/docker"
                arguments="exec hermes_ldap ldapwhoami -x -D '#ldapBindDN#' -y /opt/hermes/tmp/#customtrans3#_pwd.txt"
                variable="ldapWhoamiResult"
                errorVariable="ldapWhoamiError"
                timeout="30">
            </cfexecute>

            <!--- Cleanup temp password file --->
            <cfif fileExists(tempPwdFile)>
                <cffile action="delete" file="#tempPwdFile#">
            </cfif>

            <!--- Check if bind was successful --->
            <cfif ldapWhoamiResult CONTAINS "dn:" OR ldapWhoamiResult CONTAINS ldapUsername>
                <!--- Bind was successful - password is correct --->
                <cfset step=2>
            <cfelse>
                <!--- Bind failed - check error --->
                <cfif ldapWhoamiError CONTAINS "Invalid credentials" OR ldapWhoamiError CONTAINS "49">
                    <cfset step=0>
                    <cfset session.m=4>
                    <cflocation url="user_password.cfm" addtoken="no">
                <cfelse>
                    <!--- Other error - show details for debugging --->
                    <cfset step=0>
                    <cfset session.m=9>
                    <cflocation url="user_password.cfm" addtoken="no">
                </cfif>
            </cfif>

        <cfcatch type="any">
            <!--- Cleanup temp password file on error --->
            <cfif isDefined("tempPwdFile") AND fileExists(tempPwdFile)>
                <cffile action="delete" file="#tempPwdFile#">
            </cfif>
            <!--- LDAP bind failed --->
            <cfset step=0>
            <cfset session.m=4>
            <cflocation url="user_password.cfm" addtoken="no">
        </cfcatch>
        </cftry>

      <!--- /CFIF step 1 --->
      </cfif>
      

      
      <cfif step is "2">

        <cfif #form.hibp# is "YES">

          <cfinclude template="./inc/get_system_token.cfm">

            <cfif #getsystoken.recordcount# EQ 1>

            <cfif #getsystoken.token# is "">

            <cfset m="User Change Password: getsystoken.token is blank">
            <cfinclude template="./inc/error.cfm">
            <cfabort>
            
          <cfelse>

          <cfset THETOKEN = "#getsystoken.token#">

          <!--- #getsystoken.token# is --->
          </cfif>

            <cfelse>

            <cfset m="User Change Password: getsystoken.recordcount NEQ 1">
            <cfinclude template="./inc/error.cfm">
            <cfabort>

            <!--- /CFIF #getsystoken.recordcount# --->
            </cfif>


        <cfset urlencodedpassword=#URLEncodedFormat(Trim("#form.newpassword#"))#>
          
          <cfhttp method="POST" charset="utf-8" throwonerror="false" url="http://127.0.0.1:8888/hermes-api/">
          
          <cfhttpparam name="accept" type="header" value="accept: */*"> 
          
          <cfhttpparam name="X-Original-URL" type="header" value="/admin/2/inc/check_hibp.cfm?type=api&password=#urlencodedpassword#"> 
          
          <cfhttpparam name="X-Token" type="header" value="#THETOKEN#"> 
          
          </cfhttp>
          
    
          <cfoutput> 
          FileContent: #cfhttp.fileContent# 
          </cfoutput> 
          
          
          <cfif #cfhttp.fileContent# contains "Hash Not Found">

          <cfset step=3>

                  
          <cfelseif #cfhttp.fileContent# contains "Hash Found">
        
            <cfset step=0>
            <cfset session.m=5>
            <cflocation url="user_password.cfm" addtoken="no">

          
          <cfelseif #cfhttp.fileContent# contains "Hibp Unreachable">
        
            <cfset step=0>
            <cfset session.m=6>
            <cflocation url="user_password.cfm" addtoken="no">


          <cfelseif #cfhttp.fileContent# contains "Invalid Token LT 1">
        
            <cfset step=0>
            <cfset session.m=6>
             <cflocation url="user_password.cfm" addtoken="no">

          
            


          <cfelse>
       
            <cfset step=0>
            <cfset session.m=6>
            <cflocation url="user_password.cfm" addtoken="no">
        
          
            <!--- /CFIF #cfhttp.fileContent# contains --->
          </cfif>
               
        
        <cfelse>
        
        <cfset step=3>
        
        <!--- /CFIF form.hibp is YES or NO --->
        </cfif>
        
        <!--- /CFIF step 2 --->
        </cfif>

<cfif #step# is "3">

<!--- Set variables required by ldap_modify_user_password.cfm --->
<!--- ldapUsername and ldapOU are already set from step 1 --->
<cfset newPassword = form.newpassword>

<cfinclude template="/user-auth/inc/ldap_modify_user_password.cfm">

<cfif ldapPasswordModified>
    <cfinclude template="./inc/send_changed_password_email.cfm">
    <cfset step=0>
    <cfset session.m=7>
    <cflocation url="user_password.cfm" addtoken="no">
<cfelse>
    <!--- LDAP password change failed --->
    <cfset step=0>
    <cfset session.m=9>
    <cflocation url="user_password.cfm" addtoken="no">
</cfif>

<!--- /CFIF step is 3 --->
</cfif>

    
      <!--- /CFIF #action# is --->     
    </cfif> 
    
        <!--- CHANGE PASSWORD CARD --->
        <div class="card card-outline card-primary mb-4">
            <div class="card-header">
                <h3 class="card-title"><i class="fas fa-key me-2"></i>Change Password</h3>
            </div>
            <div class="card-body">
                <div class="alert alert-warning">
                    <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i>Enter your existing password in the <strong>Existing Password</strong> field, enter the new password in the <strong>New Password</strong> field and click the <strong>Submit</strong> button below. Click the <i class="fa fa-eye-slash" aria-hidden="true"></i> icon to show the password you've typed in order to verify accuracy. Passwords must be <strong>between 8 and 64 characters long.</strong> It's highly recommended to leave the <strong>Check against haveibeenpwned.com</strong> field set to <strong>YES</strong> in order to check your password against known data breaches.</p>
                </div>

                <form action="" method="post">
                    <input type="hidden" name="action" value="setpassword">

                    <div class="mb-3" id="oldpasswordfield">
                        <label for="oldpassword" class="form-label"><strong>Existing Password</strong></label>
                        <div class="input-group">
                            <input type="password" class="form-control" name="oldpassword" value="" id="oldpassword" placeholder="Enter Existing Password" maxLength="64">
                            <a href="" class="input-group-text"><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                        </div>
                    </div>

                    <div class="mb-3" id="newpasswordfield">
                        <label for="newpassword" class="form-label"><strong>New Password</strong></label>
                        <div class="input-group">
                            <input type="password" class="form-control" name="newpassword" value="" id="newpassword" placeholder="Enter New Password" maxLength="64">
                            <a href="" class="input-group-text"><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><strong>Check against haveibeenpwned.com</strong></label>
                        <select class="form-control" name="hibp" style="width: 100%;">
                            <cfif #hibp# is "NO">
                                <option value="NO" selected>NO</option>
                                <option value="YES">YES (Recommended)</option>
                            <cfelseif #hibp# is "YES">
                                <option value="YES" selected>YES (Recommended)</option>
                                <option value="NO">NO</option>
                            </cfif>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='Please wait...';this.form.submit();">
                        <i class="fas fa-save me-1"></i> Change Password
                    </button>
                </form>
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

  

  <!--- SCRIPT TO CHECK/UNCHECK ALL CHECKBOXES ON THE PAGE STARTS HERE --->
     <!--- THIS SCRIPT WILL NOT WORK IF PLACED IN THE <HEAD></HEAD> SECTION  --->
  <script>
    $('#selectAll').click(function() {
      if(this.checked) {
          $(':checkbox').each(function() {
              this.checked = true;                        
          });
      } else {
         $(':checkbox').each(function() {
              this.checked = false;                        
          });
      } 
    });
    </script>
  <!--- SCRIPT TO CHECK/UNCHECK ALL CHECKBOXES ON THE PAGE ENDS HERE --->

</html>