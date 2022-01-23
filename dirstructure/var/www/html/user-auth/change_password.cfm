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
  <title>Hermes SEG | Change Password</title>

  <cfinclude template="./inc/html_head.cfm" />


<!-- CFML CODE STARTS HERE -->

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

<cfif form.action is "setpassword">

<cfset action = form.action>


<cfelse>


<cfset m="User Change Password: form.action is not setpassword">
<cfinclude template="error.cfm">
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
<cfinclude template="error.cfm">
<cfabort>



<!--- /CFIF for form.hibp is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists form.hibp --->
</cfif>


<cfif structKeyExists(url, 'token')>

<cfelse>

  <cfset m="User Change Password: url.token does not exist">
  <cfinclude template="error.cfm">
  <cfabort>

  <!--- /CFIF structKeyExists(url, 'token') --->
  </cfif>


<cfif #action# is "setpassword">

<!--- VALIDATE FORM INPUTS STARTS HERE --->
<cfif NOT StructKeyExists(form, "password")>
  
  <cfset m="User Change Password: form.password does not exist">
  <cfinclude template="error.cfm">
  <cfabort>
  
  <!--- /CFIF StructKeyExists(form, "password") --->
  </cfif>


  <cfif NOT StructKeyExists(form, "hibp")>
  
    <cfset m="User Change Password: form.hibp does not exist">
    <cfinclude template="error.cfm">
    <cfabort>
  
    <cfelse>
  
    <cfif form.hibp is "YES" OR form.hibp is "NO">
  
    <cfelse>
    
    <cfset m="Change User Password: form.hibp is not YES or NO">
    <cfinclude template="error.cfm">
    <cfabort>
    
    <!--- /CFIF form.hibp is "YES" OR form.hibp is "NO" --->
    </cfif>
    
    <!--- /CFIF StructKeyExists(form, "hibp") --->
    </cfif>
    
    <!--- VALIDATE FORM INPUTS ENDS HERE --->


<cfquery name="checkresetcode" datasource="hermes">
select id, reset_password_code, reset_password_datetime from user_settings where id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uid#"> and reset_password_code like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.token#"> and reset_password_datetime is not NULL
</cfquery>
  
<cfif #checkresetcode.recordcount# EQ 1>

<cfset resetdate=dateformat(#checkresetcode.reset_password_datetime#,"yyyy/mm/dd")>

<cfif isValid("date", #resetdate#)> 
  
  <cfset step=1>
  
  <cfelse>
  
  <cfset step=0>
  
  <cfset m="User Change Password: resetdate is not a valid date">
  <cfinclude template="error.cfm">
  <cfabort>
  
  
  <!--- /CFIF isValid("date", #resetdate#)> --->
  </cfif>
  
  <cfelse>
  
  <cfset step=0>
  
  <cfset m="User Change Password: checkresetcode.recordcount is not 1">
  <cfinclude template="error.cfm">
  <cfabort>
  
  <!--- /CFIF checkresetcode.recordcount --->
  </cfif>
  

  <cfif #step# is "1">

    <cfset date=dateformat(Now(),"yyyy/mm/dd")>
    <cfset time=timeformat(Now(),"HH:MM:SS")>
      
    <cfif DateDiff("n", "#checkresetcode.reset_password_datetime#", "#date# #time#") lte 15>
      
    <cfset step=2>
      
    <cfelse>
    
    <cfset step=0>
    <cfset session.reason=1>
    
    <!--- DateDiff("n", "#checkresetcode.reset_password_datetime#", "#date# #time#") lte 5 --->
    </cfif>
    
    <!--- /CFIF step is 1 --->
    </cfif>

    <cfif step is "2" and #form.password# is "">

    <cfset step=0>
    <cfset session.reason=2>
      
      <cfoutput>
      <cflocation url="change_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#&token=#url.token#" addtoken="no">
      </cfoutput>
      
      <cfelseif step is "2" and #form.password# is not "">
      
      <!--- CODE TO ENFORCE MIN 8 CHARACTER LENGTH --->
      <cfif NOT ( len(form.password) GTE 8)>
      <cfset step=0>
      <cfset session.reason=3>
      
      <cfoutput>
      <cflocation url="change_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#&token=#url.token#" addtoken="no">
      </cfoutput>
      
      <!--- CODE TO ENFORCE MIN 64 CHARACTER LENGTH --->
      <cfelseif NOT ( len(form.password) LTE 64)>
      <cfset step=0>
      <cfset session.reason=3>
      
      <cfoutput>
        <cflocation url="change_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#&token=#url.token#" addtoken="no">
        </cfoutput>
        
      <cfelse>
      
      <cfset step=3>
      
      <!--- /CFIF NOT ( len(form.password) GTE 8) --->
      </cfif>
      
      <!--- /CFIF step 2 --->
      </cfif>
      

      <cfif step is "3">

        <cfif #form.hibp# is "YES">

          <cfquery name="getsystoken" datasource="hermes">
            select token from api_tokens where system='1' and active='1'
            </cfquery>

            <cfif #getsystoken.recordcount# EQ 1>

            <cfif #getsystoken.token# is "">

            <cfset m="User Change Password: getsystoken.token is blank">
            <cfinclude template="error.cfm">
            <cfabort>
            
          <cfelse>

          <cfset THETOKEN = "#getsystoken.token#">

          <!--- #getsystoken.token# is --->
          </cfif>

            <cfelse>

            <cfset m="User Change Password: getsystoken.recordcount NEQ 1">
            <cfinclude template="error.cfm">
            <cfabort>

            <!--- /CFIF #getsystoken.recordcount# --->
            </cfif>


        <cfset urlencodedpassword=#URLEncodedFormat(Trim("#form.password#"))#>
          
          <cfhttp method="POST" charset="utf-8" throwonerror="false" url="http://127.0.0.1:8888/hermes-api/">
          
          <cfhttpparam name="accept" type="header" value="accept: */*"> 
          
          <cfhttpparam name="X-Original-URL" type="header" value="/admin/2/inc/check_hibp.cfm?type=api&password=#urlencodedpassword#"> 
          
          <cfhttpparam name="X-Token" type="header" value="#THETOKEN#"> 
          
          
       

          </cfhttp>
          
    
          <cfoutput> 
          FileContent: #cfhttp.fileContent# 
          </cfoutput> 
          
          
          <cfif #cfhttp.fileContent# contains "Hash Not Found">

          <cfset step=4>

                  
          <cfelseif #cfhttp.fileContent# contains "Hash Found">
        
            <cfset step=0>
            <cfset session.reason=4>
              
            <cfoutput>
            <cflocation url="change_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#&token=#url.token#" addtoken="no">
            </cfoutput>
          
          <cfelseif #cfhttp.fileContent# contains "Hibp Unreachable">
        
            <cfset step=0>
            <cfset session.reason=5>
              
            <cfoutput>
            <cflocation url="change_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#&token=#url.token#" addtoken="no">
            </cfoutput>

          <cfelseif #cfhttp.fileContent# contains "Invalid Token LT 1">
        
            <cfset step=0>
            <cfset session.reason=6>
              
            <cfoutput>
            <cflocation url="change_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#&token=#url.token#" addtoken="no">
            </cfoutput>
          
            


          <cfelse>
       
            <cfset step=0>
            <cfset session.reason=7>
              
            <cfoutput>
            <cflocation url="change_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#&token=#url.token#" addtoken="no">
            </cfoutput>
          
            <!--- /CFIF #cfhttp.fileContent# contains --->
          </cfif>
               
        
        <cfelse>
        
        <cfset step=4>
        
        <!--- /CFIF form.hibp is YES or NO --->
        </cfif>
        
        <!--- /CFIF step 3 --->
        </cfif>
        
    
  <cfif #step# is "4">

    <cfquery name="getrandom_512" datasource="hermes" result="getrandom_results">
      select random_letter as random_512 from captcha_list order by RAND() limit 30
      </cfquery>
      
      <cfquery name="insert_salt_512" datasource="hermes" result="stResult512">
      insert into salt
      (salt)
      values
      ('<cfoutput query="getrandom_512">#TRIM(random_512)#</cfoutput>')
      </cfquery>
      
      <cfquery name="getsalt_512" datasource="hermes">
      select salt as salt_512 from salt where id='#stResult512.GENERATED_KEY#'
      </cfquery>
      
      <cfset salt512=#getsalt_512.salt_512#>
      
      <cfquery name="deletesalt512" datasource="hermes">
      delete from salt where id='#stResult512.GENERATED_KEY#'
      </cfquery>
      
      <cfloop index="hashCount" from="1" to="10000">
      <cfset passwordHash512=Hash(form.password & salt512, 'SHA-512', 'UTF-8') />
      </cfloop>
      
      <cfset thePassword="#salt512##passwordHash512#" />

      <cfset resetdate=#DateAdd("h", -24, resetdate)#>

      <cfset resetdate=dateformat(#resetdate#,"yyyy/mm/dd")>

      <cfquery name="createpassword" datasource="hermes">
      update user_settings set password='#thePassword#', password_set = '1', reset_password_ip = '1', reset_password_datetime = '#resetdate#' where id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uid#">
      </cfquery>
    
    <cfset step=0>
    <cfset session.reason=8>

    <cfinclude template="send_changed_password_email.cfm">

      
    <cfoutput>
    <cflocation url="change_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#&token=#url.token#" addtoken="no">
    </cfoutput>
    
  <!--- /CFIF step 4 --->
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
      <i class="icon fas fa-exclamation-triangle"></i><cfoutput>The system has detected that your password reset token is expired/invalid. Tokens are only valid for 15 minutes. <strong>Please <a href="set_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#">click here</a> to re-try your password reset.</strong> (Error Code: #reason#)</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>

  <cfif #reason# is "2">

    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <!---
      <h4><i class="icon fa fa-exclamation"></i> Oops!</h4>
      --->
      <i class="icon fas fa-exclamation-triangle"></i><cfoutput>The password cannot be blank (Error Code: #reason#)</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>


  <cfif #reason# is "3">

    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <!---
      <h4><i class="icon fa fa-exclamation"></i> Oops!</h4>
      --->
      <i class="icon fas fa-exclamation-triangle"></i><cfoutput>The password must be between 8 and 64 characters (Error Code: #reason#)</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>

  <cfif #reason# is "4">

    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <!---
      <h4><i class="icon fa fa-exclamation"></i> Oops!</h4>
      --->
      <i class="icon fas fa-exclamation-triangle"></i><cfoutput>The Password you are attempting to use has previously appeared in a data breach. Please use another password. Password was checked by <a href="https://haveibeenpwned.com/Passwords" target="_blank">haveibeenpwned.com</a> (Error Code: #reason#)</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>

  <cfif #reason# is "5">

    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <!---
      <h4><i class="icon fa fa-exclamation"></i> Oops!</h4>
      --->
      <i class="icon fas fa-exclamation-triangle"></i><cfoutput>There was a problem accessing haveibeenpwned.com to check your password against previous data breaches. Either ensure Hermes SEG has outbound Internet access over 443 to <a href="https://api.pwnedpasswords.com">https://api.pwnedpasswords.com</a> OR set the <strong>Check Password Against haveibeenpwned.com</strong> field to NO and try again. (Error Code: #reason#)</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>

  <cfif #reason# is "6">

    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <!---
      <h4><i class="icon fa fa-exclamation"></i> Oops!</h4>
      --->
      <i class="icon fas fa-exclamation-triangle"></i><cfoutput>There was a problem checking your password against haveibeenpwned.com. Please set the <strong>Check Password Against haveibeenpwned.com</strong> field to NO and try again. (Error Code: #reason#)</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>

  
  <cfif #reason# is "7">

    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <!---
      <h4><i class="icon fa fa-exclamation"></i> Oops!</h4>
      --->
      <i class="icon fas fa-exclamation-triangle"></i><cfoutput>There was a problem checking your password against haveibeenpwned.com. Please set the <strong>Check Password Against haveibeenpwned.com</strong> field to NO and try again. (Error Code: #reason#)</cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>



  <cfif #reason# is "8">

    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <!---
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      --->
      <i class="icon fa fa-check"></i><cfoutput>Your password was set successfully. Please <a href="index.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#">click here</a> to login.</strong></cfoutput>
    </div>
  
    <cfset session.reason = 0>
  
  </cfif>


  
<cfif #reason# is "20">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <!---
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    --->
    <i class="icon fa fa-check"></i><cfoutput>The password cannot be blank</strong></cfoutput>
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



   <H4 class="text-center">Set New Password</H5>

  <p class="text-center">Enter your new password and click the <strong>Submit</strong> button below. Click the <i class="fa fa-eye-slash" aria-hidden="true"></i> icon to show the password you've typed in order to verify accuracy.</p>
  



<cfoutput>
      <form action="change_password.cfm?uid=#url.uid#&dest=#url.dest#&mid=#mid#&sid=#sid#&token=#url.token#" method="post">
      </cfoutput>


        <input type="hidden" name="action" value="setpassword">
    
        <div class="form-group" id="UserPassword">
 

            <cfoutput>
              <div class="form-group" id="userpasswordfield">
                <label for="password"><strong>Password</strong></label>
                <div class="input-group">
                <input type="password" class="form-control" name="password" value="" id="password" placeholder="Enter password" maxLength="64">
                <a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
              </div>
              </div>
              </cfoutput> 

              <label><strong>Check against haveibeenpwned.com</strong></label>
              <!---
                 <p class="help-block">Effective only when Schedule SMTP Address Import from AD is set to Yes above</p>
               --->
                 <select class="form-control select2" name="hibp" data-placeholder="hibp" style="width: 100%;">
                 
               <cfif #hibp# is "NO">                         
                   <option value="NO" selected>NO</option>
                   <option value="YES">YES (Recommended)</option>
                 <cfelseif #hibp# is "YES">
                   <option value="YES" selected>YES (Recommended)</option>
                   <option value="NO">NO</option>
                 </cfif>
                   </select>  

            </div>


         
          <div>
 
            <input type="submit" class="btn btn-primary btn-block" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait';this.form.submit();">

    
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
   
</body>
</html>
