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
  <title>Hermes SEG | Recipient Certificates</title>

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
        "order": [[ 1, "asc" ]]
    } );
} );
  </script>

<!--- SCRIPT TO SHOW/HIDE PASSWORD ON CREATE CERTIFICATE MODAL --->
  <script>

$(document).ready(function() {
    $("#pfxpassword a").on('click', function(event) {
        event.preventDefault();
        if($('#pfxpassword input').attr("type") == "text"){
            $('#pfxpassword input').attr('type', 'password');
            $('#pfxpassword i').addClass( "fa-eye-slash" );
            $('#pfxpassword i').removeClass( "fa-eye" );
        }else if($('#pfxpassword input').attr("type") == "password"){
            $('#pfxpassword input').attr('type', 'text');
            $('#pfxpassword i').removeClass( "fa-eye-slash" );
            $('#pfxpassword i').addClass( "fa-eye" );
        }
    });
});

  </script>

  
<!--- SCRIPT TO SHOW/HIDE PASSWORD ON IMPORT CERTIFICATE MODAL--->
<script>

  $(document).ready(function() {
      $("#pfxpassword_1 a").on('click', function(event) {
          event.preventDefault();
          if($('#pfxpassword_1 input').attr("type") == "text"){
              $('#pfxpassword_1 input').attr('type', 'password');
              $('#pfxpassword_1 i').addClass( "fa-eye-slash" );
              $('#pfxpassword_1 i').removeClass( "fa-eye" );
          }else if($('#pfxpassword_1 input').attr("type") == "password"){
              $('#pfxpassword_1 input').attr('type', 'text');
              $('#pfxpassword_1 i').removeClass( "fa-eye-slash" );
              $('#pfxpassword_1 i').addClass( "fa-eye" );
          }
      });
  });
  
    </script>

  <!--- SCRIPT TO SHOW/HIDE PASSWORD ON SEND CERTIFICATE MODAL --->
  <script>

    $(document).ready(function() {
        $("#pfxpassword_2 a").on('click', function(event) {
            event.preventDefault();
            if($('#pfxpassword_2 input').attr("type") == "text"){
                $('#pfxpassword_2 input').attr('type', 'password');
                $('#pfxpassword_2 i').addClass( "fa-eye-slash" );
                $('#pfxpassword_2 i').removeClass( "fa-eye" );
            }else if($('#pfxpassword_2 input').attr("type") == "password"){
                $('#pfxpassword_2 input').attr('type', 'text');
                $('#pfxpassword_2 i').removeClass( "fa-eye-slash" );
                $('#pfxpassword_2 i').addClass( "fa-eye" );
            }
        });
    });
    
      </script>




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
            <h1 class="m-0">Recipient Certificates</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Recipient Certificates</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

    <!--- ENABLE FOR DEBUG ONLY --->
 <!--- 
        <cfdump var="#cgi#">
             
        <cfoutput>
       #cgi.http_referer#
      </cfoutput>
    --->
    
  <cfparam name = "errormessage" default = "0">

  <cfparam name = "m" default = "0">
  <cfif StructKeyExists(session, "m")>
  <cfif session.m is not "">
  <cfset m = session.m>

  <!--- /CFIF for session.m is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.m --->
  </cfif>

  <!---
  <cfoutput>session M: #m#</cfoutput>
  --->

    <cfparam name = "m2" default = "0"> 
    <cfif StructKeyExists(url, "m2")>
    <cfif url.m2 is not "">
    <cfset m2 = url.m2>
  
    <!--- /CFIF for url.m2 is not "" --->
    </cfif>
  
    <!--- /CFIF for StructKeyExists --->
    </cfif>

<cfparam name = "step" default = "0">
    
<cfparam name = "action" default = ""> 
<cfif StructKeyExists(form, "action")>
<cfif form.action is not "">
<cfset action = form.action>

<!--- /CFIF form.action is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists --->
</cfif>  


<cfif NOT StructKeyExists(url, "id")>

<cfset m="Recipient Certificates: url.id does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>
  
<cfelseif StructKeyExists(url, "id")>

<cfif NOT IsValid("integer", #url.id#)>

<cfset m="Recipient Certificates: url.id not valid integer">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- <cfif NOT IsValid("integer", #url.id#)> --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(url, "id") --->
</cfif>


<cfif NOT StructKeyExists(url, "type")>

<cfset m="Recipient Certificates: url.type does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelseif StructKeyExists(url, "type")>

<cfif #url.type# is "1">

<cfquery name="getrecipientdetails" datasource="hermes">
select id, recipient from recipients where 
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getrecipientdetails.recordcount# LT 1>

<cfset m="Recipient Certificates: getrecipinetdetails.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelseif #getrecipientdetails.recordcount# GTE 1>

<cfquery name="getcertificates" datasource="hermes">
select * from recipient_certificates where user_id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfset theRecipient = #url.id#>

<!--- /CFIF #getrecipientdetails.recordcount# --->
</cfif>

<cfelseif #url.type# is "2">

<cfquery name="getrecipientdetails" datasource="hermes">
select id, email as recipient from external_recipients where 
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getrecipientdetails.recordcount# LT 1>

<cfset m="Recipient Certificates: getrecipinetdetails.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelseif #getrecipientdetails.recordcount# GTE 1>

<cfquery name="getcertificates" datasource="hermes">
select * from recipient_certificates where user_id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfset theRecipient = #url.id#>
  
<!--- /CFIF #getrecipientdetails.recordcount# --->
</cfif>

<cfelse>

<cfset m="Recipient Certificates: url.type is not 1 or 2">
<cfinclude template="./inc/error.cfm">
<cfabort>
  

<!--- /CFIF #url.type# is --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(url, "type") --->
</cfif>
  

<!--- ERROR MESSAGES START HERE --->

<cfif #m# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The .p12/.pfx File Password cannot be blank (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The certificate password must be at least 10 characters (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "3">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Certificate was created successfully</cfoutput><br>

  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "4">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The .p12/.pfx file you selected was not accepted (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "5">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must select a valid .p12/.pfx file to import (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "6">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must select a valid .p12/.pfx file to import (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "7">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Certificate was imported successfully</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "8">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You entered an incorrect password or the .p12/.pfx file is corrupt (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "9">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The .p12/.pfx file was not imported. This is usually due to the fact the certificate was imported previously (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "10">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The .p12/.pfx file was not imported. Unhandled exception (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>


</cfif>

<cfif #m# is "11">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error attempting to move the .p12/.pfx file from /opt/hermes/tmp to /opt/hermes/HermesExternalCACerts. The file was not found (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "12">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem creating the certificate. The password you specified was not accepted (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "13">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem creating the certificate. Unhandled exception (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "14">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem creating the certificate. 0 new key(s) imported (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "15">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Certificate was deleted successfully</cfoutput><br>

    <cfset session.m = 0>

  </div>
</cfif>


<cfif #m# is "16">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Certificate was sent successfully</cfoutput><br>

    <cfset session.m = 0>

  </div>
</cfif>


<cfif #m# is "17">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem fetching the .pfx certificate file (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<!--- ERROR MESSAGES END HERE --->
        
    
<span>
  <p>       

    <a href="view_internal_recipients.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Recipients</a>

    &nbsp;&nbsp;

    <!-- CREATE CERTIFICATE BUTTON -->
<cfoutput>
<a href="##create_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="#theRecipient#"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Create Certificate</a>
</cfoutput>

&nbsp;&nbsp;

<!--- CREATE CERTIFICATE BUTTON ENDS HERE --->

    <!-- IMPORT CERTIFICATE BUTTON -->
    <cfoutput>
    <a href="##import_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="#theRecipient#"><i class="fa fa-upload fa-lg"></i>&nbsp;&nbsp;Import Certificate</a>
  </cfoutput>
  
  
  <!--- IMPORT CERTIFICATE BUTTON ENDS HERE --->


</p>


</span>


<!--- SEND CERTIFICATE MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="send_modal" tabindex="-1" role="dialog" aria-labelledby="sendCertificateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Send Certificate </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you send to send this Certificate? The system will send the PFX Certificate File to the recipient via e-mail. The PFX Certificate File password is shown below in order to relay to the recipient. It is HIGHLY recommended that you do not relay  the password via any communications medium including telephone, SMS or unencrypted e-mail. All those mediums are considered unsecure.</p>

        <form name="SendCertificate" method="post">

          <input type="hidden" name="action" value="sendcertificate">
          <input type="hidden" name="certificate_id" value=""/>
   

        <!--- PFX/P12 FILE PASSWORD STARTS HERE --->
           
<div class="form-group" id="pfxpassword_2">
  <label><strong>.pfx/.p12 File Password</strong></label>


<div class="input-group">
<input type="password" name="password" value="" class="form-control" maxlength="64">

<a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
</div>

</div>

<!--- PFX/P12 FILE PASSWORD PASSWORD ENDS HERE --->

<input type="submit" value="Send" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

            
</form>


      </div>
      <div class="modal-footer">
 
        <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
<!--- SEND CERTIFICATE MODAL HTML ENDS HERE --->


<!--- DELETE CERTIFICATE MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteCertificateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Delete Certificate </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you send to delete this Certificate? This action is irreversible! If you delete the last certificate for an S/MIME enabled recipient, S/MIME encryption will no longer work until you generate or import another certificate for this recipient. </p>

      </div>
      <div class="modal-footer">
        <form name="DeleteCertificate" method="post">

          <input type="hidden" name="action" value="deletecertificate">
          <input type="hidden" name="certificate_id" value=""/>
          <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
          
            </form>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>
<!--- DELETE CERTIFICATE MODAL HTML ENDS HERE --->



<!--- CREATE CERTIFICATE MODAL HTML STARTS HERE --->
   


<div class="modal fade" id="create_modal" tabindex="-1" role="dialog" aria-labelledby="createcertificateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Create Certificate </h4>
      </div>
        
      <div class="modal-body">
        <!---
        <p>Are you sure you create a recipient certificate?</p>
        --->

        <form name="create_certificate" method="post" action="">
    
          <input type="hidden" name="action" value="createcertificate">
          <input type="hidden" name="recipient_id" value="">
       
             <!--- CERTIFICATE AUTHORITY STARTS HERE --->

             <cfquery name="getdefaultca" datasource="hermes">
              select id, ca_commonname from ca_settings where default2='1'
              </cfquery>
              
                         
              <cfquery name="getotherca" datasource="hermes">
                select * from ca_settings where id <> '#getdefaultca.id#' order by ca_commonname asc
                </cfquery>

  <cfoutput>
  
  
  
              <div class="form-group">
                  <label><strong>Certificate Authority</strong></label>
                  <select class="form-control select2" name="ca" data-placeholder="Certificate Authority"
                          style="width: 100%;">
                    <cfoutput><option value="#getdefaultca.id#" selected="selected">#getdefaultca.ca_commonname#</option></cfoutput>
                    <cfoutput query="getotherca">
                      <option value="#id#">#ca_commonname#</option>
                      </cfoutput>
                      </select>
  
            
        </div>
        </cfoutput>
  
         <!--- CERTIFICATE AUTHORITY ENDS HERE --->
  
  
  
   <!--- CERTIFICATE VALIDITY PERIOD STARTS HERE  --->
  
   
   <div class="form-group">
    <label><strong>Certificate Validity Period</strong></label>
  <!---
    <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
  --->
  <select class="form-control" name="validity" data-placeholder="validity" id="validity" style="width: 100%">                  
  <option value="1825" selected="selected">5 Years</option>
  <option value="1460">4 Years</option>
  <option value="1095">3 Years</option>
  <option value="730">2 Years</option>
  <option value="365">1 Year</option>
  </select> 
  </div>

      <!--- CERTIFICATE VALIDITY PERIOD ENDS HERE --->
  
         <!--- CERTIFICATE KEY LENGTH STARTS HERE  --->
  
   
   <div class="form-group">
    <label><strong>Certificate Key Length</strong></label>
  <!---
    <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
  --->
  <select class="form-control" name="encryption" data-placeholder="encryption" id="encryption" style="width: 100%">                  
  <option value="4096" selected="selected">4096 Bits (High Security)</option>
  <option value="2048">2048 Bits (Medium Security)</option>

  </select> 
  </div>

      <!--- CERTIFICATE KEY LENGTH ENDS HERE --->
  
    <!--- CERTIFICATE HASH ALGORITHM STARTS HERE  --->
  
   
   <div class="form-group">
    <label><strong>Certificate Hash Algorithm</strong></label>
  <!---
    <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
  --->
  <select class="form-control" name="algorithm" data-placeholder="algorithm" id="algorithm" style="width: 100%">                  
  <option value="sha512" selected="selected">SHA-512 (High Security)</option>
  <option value="sha256">SHA-256 (Medium Security)</option>
  <option value="sha1">SHA-1 (Low Security)</option>
  </select> 
  </div>

      <!--- CERTIFICATE HASH ALGORITHM ENDS HERE --->

    <!--- AUTO-GENERATE PASSWORD STARTS HERE --->

            <div class="form-group">
              <label><strong>Auto-Generate Certificate and Private Key PFX Password </strong></label>
  <!---
              <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
  --->
  
    <select class="form-control select2" id="autopass" name="autopass" data-placeholder="autopass" style="width: 100%">                  
    <option value="yes" selected="selected">YES</option>
    <option value="no">NO</option>
     </select> 
    </div>

      <!--- AUTO-GENERATE PASSWORD STARTS HERE --->
  
<!--- CERTIFICATE AND PRIVATE KEY PASSWORD STARTS HERE --->
           
      <div class="form-group" id="pfxpassword" style="display:none;">
        <label><strong>Certificate and Private Key PFX Password</strong></label>

        <p class="help-block">Must be at least 10 characters long</p>

  <div class="input-group">
  <input type="password" name="password1" value="" class="form-control" maxlength="64">
  
    <a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
  </div>

</div>

<!--- CERTIFICATE AND PRIVATE KEY PASSWORD ENDS HERE --->

          <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

            </form>

      </div>
      <div class="modal-footer">

        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
<!--- CREATE CERTIFICATE MODAL HTML STARTS HERE --->

           <!--- IMPORT CERTIFICATE MODAL HTML STARTS HERE --->
   

           <div class="modal fade" id="import_modal" tabindex="-1" role="dialog" aria-labelledby="importModalLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header alert-primary">
                  <!---
                  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                  --->
                    <h4 class="modal-title">Import Certificate </h4>
                </div>
                  
                <div class="modal-body">
                
               

                  <form name="uploadDocument" enctype="multipart/form-data" method="post">
          
           
          <input type="hidden" name="action" value="importcertificate">
          <input type="hidden" name="recipient_id" value="">
          

                    
     
                    <input type="file" class="custom-file-input" id="customFile" name="fileUpload">
                    <label class="custom-file-label" for="customFile">Choose .pfx/.p12 file</label>
          
                    <!---
                    <div class="text-center">
          
                    <button type="input" class="btn btn-primary" onclick="this.form.submit();">Upload</button>
                    </div>
               

                    <div>&nbsp;&nbsp;</div>
                  --->


                        <!--- ADD TO CTL STARTS HERE --->

            <div class="form-group">
              <label><strong>Add to Certificate Trust List (CTL) </strong></label>
  <!---
              <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
  --->
  
    <select class="form-control select2" name="ctl" data-placeholder="ctl" style="width: 100%">                  
    <option value="1" selected="selected">YES</option>
    <option value="2">NO</option>
     </select> 
    </div>

       <!--- ADD TO CTL ENDS HERE --->
  
<!--- PFX/P12 FILE PASSWORD STARTS HERE --->
           
<div class="form-group" id="pfxpassword_1">
  <label><strong>.pfx/.p12 File Password</strong></label>


<div class="input-group">
<input type="password" name="password1" value="" class="form-control" maxlength="64">

<a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
</div>

</div>

<!--- PFX/P12 FILE PASSWORD PASSWORD ENDS HERE --->
                    
<input type="submit" class="btn btn-primary" name="" value="Import" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

</form>
          
                </div>
          
                <div class="modal-footer">
                 
                  <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                </div>
              </div>
            </div>
          </div>
           <!--- IMPORT CERTIFICATE MODAL HTML ENDS HERE --->
          


<!--- ACTIONS START HERE --->

<cfif #action# is "createcertificate">

  <!--- VALIDATE PARAMETERS BELOW --->



  <!--- FORM.CA --->
  
  <cfif NOT StructKeyExists(form, "ca")>
  
    <cfset m="Create Recipient Certificate: form.ca does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "ca")>
  
  <cfquery name="getcadetails" datasource="hermes">
    select * from ca_settings where id = <cfqueryparam value = #form.ca# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>
  
  <cfif #getcadetails.recordcount# LT 1>
  
    <cfset m="Create Recipient Certificate: getcadetails.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

  <cfelse>

  <cfset step=1>
  
  <!--- /CFIF #getcadetails.recordcount# --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "ca") --->
  </cfif>

<cfif #step# is "1">
  
<!--- FORM.VALIDITY --->
<cfif NOT StructKeyExists(form, "validity")>

  <cfset step=0>

  <cfset m="Create Recipient Certificate: form.validity does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "validity")>

<cfif #form.validity# is "1825" OR #form.validity# is "1460" OR #form.validity# is "1095" OR #form.validity# is "730" OR #form.validity# is "365">

<cfset step=2>

<cfelse>

  <cfset step=0>

  <cfset m="Create Recipient Certificate: form.validity is not 1825, 1460, 1095, 730 or 365">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.validity# is "1825" OR #form.validity# is "1460" OR #form.validity# is "1095" OR #form.validity# is "730" OR #form.validity# is "365" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "validity") --->
</cfif>

<!--- /CFIF #step# --->
</cfif>

<cfif #step# is "2">
 
<!--- FORM.ENCRYPTION --->
<cfif NOT StructKeyExists(form, "encryption")>

  
  <cfset step=0>

  <cfset m="Create Recipient Certificate: form.encryption does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>


<cfelseif StructKeyExists(form, "encryption")>

<cfif #form.encryption# is "2048" OR #form.encryption# is "4096">

<cfset step=3>

<cfelse>

  <cfset step=0>

  <cfset m="Create Recipient Certificate: form.encryption is not 2048 or 4096">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.encryption# is "2048" OR #form.encryption# is "4096" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "encryption") --->
</cfif>

<!--- /CFIF #step# --->
</cfif>

<cfif #step# is "3">

<!--- FORM.ALGORITHM --->
<cfif NOT StructKeyExists(form, "algorithm")>

  <cfset step=0>

  <cfset m="Create Recipient Certificate: form.algorithm does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "algorithm")>

<cfif #form.algorithm# is "sha1" OR #form.algorithm# is "sha256" OR #form.algorithm# is "sha512">

<cfset step=4>

<cfelse>

  <cfset step=0>

  <cfset m="Create Recipient Certificate: form.algorithm is not sha1, sha256 or sha512">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.algorithm# is "sha1" OR #form.algorithm# is "sha256" OR #form.algorithm# is "sha512" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "algorithm") --->
</cfif>

<!--- /CFIF #step# --->
</cfif>

<cfif #step# is "4">

<!--- FORM.AUTOPASS --->
<cfif NOT StructKeyExists(form, "autopass")>

  <cfset step=0>

  <cfset m="Create Recipient Certificate: form.autopass does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "autopass")>

<cfif #form.autopass# is "yes" OR #form.autopass# is "no">

<cfset step=5>

<cfelse>

  <cfset step=0>

  <cfset m="Create Recipient Certificate: form.autopass is not yes, or no">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.autopass# is "yes" OR #form.autopass# is "no" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "autopass") --->
</cfif>

<!--- /CFIF #step# --->
</cfif>


<cfif #step# is "5">

<cfif #form.autopass# is "no">

  <!--- FORM.PASSWORD1 --->
  <cfif NOT StructKeyExists(form, "password1")>

    <cfset step=0>
  
  <cfset m="Create Recipient Certificate: form.password1 does not exist when form.autopass is no">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <cfelseif StructKeyExists(form, "password1")>
  
  <!--- ENSURE PASSWORD LENGTH IS AT LEAST 10 CHARACTERS --->
  <cfif NOT ( len(form.password1) GTE 10)>

  <cfset session.m = 2>
  <cfoutput>
  <cflocation url="view_recipient_certificates.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
  </cfoutput>


 
  <cfelse>
  
  <cfset password1=#form.password1#>
  <cfset step=6>
  
  <!--- /CFIF NOT ( len(form.password1) GTE 10) --->
  </cfif>
  
  <!--- /CFIF StructKeyExists(form, "password1") --->
  </cfif>
  
  <cfelseif #form.autopass# is "yes">
  
    <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
      select random_letter as random from captcha_list_all2 order by RAND() limit 16
      </cfquery>
      
      <cfquery name="inserttrans" datasource="hermes" result="stResult">
      insert into salt
      (salt)
      values
      ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
      </cfquery>
      
      <cfquery name="gettrans" datasource="hermes">
      select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
      </cfquery>
      
      <cfset password1=#gettrans.customtrans2#>
      <cfset step=6>
      
      <cfquery name="deletetrans" datasource="hermes">
      delete from salt where id='#stResult.GENERATED_KEY#'
      </cfquery>
  
  
  <!--- /CFIF #form.autopass# is --->
  </cfif>

  
<!--- /CFIF #step# --->
</cfif>

<cfif #step# is "6">

  <!--- FORM.RECIPIENT_ID --->
<cfif NOT StructKeyExists(form, "recipient_id")>

  <cfset step=0>

  <cfset m="Create Recipient Certificate: form.recipient_id does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <cfelseif StructKeyExists(form, "recipient_id")>

  <cfif #url.type# is "1">
  
  <cfquery name="getrecipient" datasource="hermes">
  select id, recipient from recipients as recipient where id = <cfqueryparam value = #form.recipient_id# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

<cfelseif #url.type# is "2">

  <cfquery name="getrecipient" datasource="hermes">
    select id, email from external_recipients as recipient where id = <cfqueryparam value = #form.recipient_id# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>
    
  <!--- /CFIF url.type is --->
  </cfif>


  <cfif #getrecipient.recordcount# GTE 1>
  
  <cfset recipient = #getrecipient.recipient#>
  <cfset step=7>
  
  <cfelseif #getrecipient.recordcount# LT 1>

    <cfset step=0>
  
  <cfset m="Create Recipient Certificate: getrecipient.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF #getrecipient.recordcount# --->
  </cfif>
   
  <!--- /CFIF NOT/StructKeyExists(form, "recipient_id") --->
  </cfif>

<!--- /CFIF #step# --->
</cfif>
  
  <!--- VALIDATE PARAMETERS ABOVE --->

  <!--- CREATE CERTIFICATE STARTS HERE --->

  <cfif #step# is "7">

  <cfinclude template="./inc/create_certificate.cfm">

  
  <!--- CREATE CERTIFICATE ENDS HERE --->

  <cfset session.m = 3>
  <cfoutput>
  <cflocation url="view_recipient_certificates.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
  </cfoutput>

  <!--- /CFIF #step# --->
</cfif>
  


<cfelseif #action# is "importcertificate">

  <!--- FORM.PASSWORD1 --->
  <cfif NOT StructKeyExists(form, "password1")>

    <cfset step=0>
    <cfset m="Import Recipient Certificate: form.password1 does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "password1")>

      <cfif #form.password1# is "">

      <cfset step=0>
      <cfset session.m = 1>
      <cfoutput>
        <cflocation url="view_recipient_certificates.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
        </cfoutput>

    <cfelseif #form.password1# is not "">

      <cfset step=1>

    <cfset password1 = #form.password1#>

    <!--- /CFIF   #form.password1# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "password1") --->
    </cfif>

    <cfif #step# is "1">

<!--- FORM.CTL --->
    <cfif NOT StructKeyExists(form, "ctl")>

      <cfset step=0>
      <cfset m="Import Recipient Certificate: form.ctl does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
  
      <cfelseif StructKeyExists(form, "ctl")>
  
        <cfif #form.ctl# is "1" OR #form.ctl# is "2">

        <cfset step=2>

        <cfelse>

          <cfset step=0>
          <cfset m="Import Recipient Certificate: form.ctl is not 1 or 2">
          <cfinclude template="./inc/error.cfm">
          <cfabort>
  
      <!--- /CFIF   #form.ctl# is "1" or #form.ctl# is "2" --->
      </cfif>
  
      <!--- /CFIF  StructKeyExists(form, "ctl") --->
      </cfif>

      <!--- /CFIF #step# --->
</cfif>


<cfif #step# is "2">

<!--- FORM.RECIPIENT_ID --->
<cfif NOT StructKeyExists(form, "recipient_id")>

  <cfset step=0>

  <cfset m="Create Recipient Certificate: form.recipient_id does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <cfelseif StructKeyExists(form, "recipient_id")>
  
    <cfif #url.type# is "1">
  
      <cfquery name="getrecipient" datasource="hermes">
      select id, recipient from recipients as recipient where id = <cfqueryparam value = #form.recipient_id# CFSQLType = "CF_SQL_INTEGER">
      </cfquery>
    
    <cfelseif #url.type# is "2">
    
      <cfquery name="getrecipient" datasource="hermes">
        select id, email from external_recipients as recipient where id = <cfqueryparam value = #form.recipient_id# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>
        
      <!--- /CFIF url.type is --->
      </cfif>
    
  <cfif #getrecipient.recordcount# GTE 1>
  
  <cfset recipient = #getrecipient.recipient#>

  <cfset step=3>
  
  <cfelseif #getrecipient.recordcount# LT 1>

  <cfset step=0>
  
  <cfset m="Create Recipient Certificate: getrecipient.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF #getrecipient.recordcount# --->
  </cfif>
   
  <!--- /CFIF NOT/StructKeyExists(form, "recipient_id") --->
  </cfif>

<!--- /CFIF #step# --->
</cfif>


<cfif #step# is "3">

<!--- UPLOAD FILE --->
    <cftry>

      <cffile action="upload"
         fileField="fileUpload"
         destination="/opt/hermes/tmp"
         nameconflict="makeunique">
         
    <cfset OriginalFileName = #cffile.serverFile# />
    <cfset theCertificateName = rereplace(OriginalFileName, "[^A-Za-z0-9._]+", "", "all")>

    <cffile action="rename" 
    source="/opt/hermes/tmp/#OriginalFileName#" 
    destination="/opt/hermes/tmp/#theCertificateName#">
       
    <cfcatch>
    
    <cfif FindNoCase("not accepted", cfcatch.Message)>
      
    <cfset step=0>
    <cfset session.m = 4>
    <cfoutput>
    <cflocation url="view_recipient_certificates.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
    </cfoutput>

 <!---
    <cfdump var="#cfcatch#" abort />
 --->

    <cfelseif FindNoCase("doesn't exist", cfcatch.Message)>

      <cfset step=0>
      <cfset session.m = 5>
      <cfoutput>
      <cflocation url="view_recipient_certificates.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
      </cfoutput>

    <cfdump var="#cfcatch#" abort />
    <!--- looks like non-MIME error, handle separately  
    <cfdump var="#cfcatch#" abort /> --->
    
    <!--- /CFIF FindNoCase("", cfcatch.Message)> --->
    </cfif>
    
    </cfcatch>
    
    
    </cftry>
    
    <cfif #cffile.serverFileExt# is "pfx" OR #cffile.serverFileExt# is "p12" >

    <cfset step=4>

    <cfelse>

    <cfset FiletoDelete="/opt/hermes/tmp/#theCertificateName#">

    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF fileExists(FiletoDelete) --->
    </cfif>

    <cfset step=0>
    <cfset session.m = 6>
    <cfoutput>
    <cflocation url="view_recipient_certificates.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
    </cfoutput>
  
    <!--- /CFIF #cffile.serverFileExt# is not "pfx" OR #cffile.serverFileExt# is not "p12" --->
  </cfif>
       
  <!--- /CFIF #step# --->
</cfif>

  <!--- IMPORT CERTIFICATE STARTS HERE --->

  <cfif #step# is "4">

    <cfinclude template="./inc/import_certificate.cfm">
    
    <!--- IMPORT CERTIFICATE ENDS HERE --->

    <cfset session.m = 7>
    <cfoutput>
    <cflocation url="view_recipient_certificates.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
    </cfoutput>
  

<!--- /CFIF #step# --->
</cfif>


<cfelseif #action# is "deletecertificate">

  <!--- FORM.CERTIFICATE_ID --->
  <cfif NOT StructKeyExists(form, "certificate_id")>

    <cfset step=0>
    <cfset m="Delete Recipient Certificate: form.certificate_id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "certificate_id")>

      <cfif #form.certificate_id# is "">

        
    <cfset step=0>
    <cfset m="Delete Recipient Certificate: form.certificate_id is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif #form.certificate_id# is not "">

    <cfquery name="getcerts" datasource="hermes">
    select * from recipient_certificates where id = <cfqueryparam value = #form.certificate_id# CFSQLType = "CF_SQL_INTEGER"> and user_id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>

    <cfif #getcerts.recordcount# LT 1>

    <cfset step=0>
    <cfset m="Delete Recipient Certificate: getcerts.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelse>

<!--- DELETE CERTIFICATE --->
<cfinclude template="./inc/delete_smime_certificate.cfm">

  <cfset session.m = 15>
    <cfoutput>
    <cflocation url="view_recipient_certificates.cfm?type=#url.type#&id=#url.id#" addtoken="no">
    </cfoutput>


  <!--- /CFIF  #getcerts.recordcount# LT 1 --->
  </cfif>


    <!--- /CFIF   #form.certificate_id# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "certificate_id") --->
    </cfif>


  <cfelseif #action# is "sendcertificate">

    <!--- FORM.CERTIFICATE_ID --->
    <cfif NOT StructKeyExists(form, "certificate_id")>
  
      <cfset step=0>
      <cfset m="Send Recipient Certificate: form.certificate_id does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
  
      <cfelseif StructKeyExists(form, "certificate_id")>
  
        <cfif #form.certificate_id# is "">
  
          
      <cfset step=0>
      <cfset m="Send Recipient Certificate: form.certificate_id is blank">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
  
      <cfelseif #form.certificate_id# is not "">
  
      <cfquery name="getcerts" datasource="hermes">
      select * from recipient_certificates where id = <cfqueryparam value = #form.certificate_id# CFSQLType = "CF_SQL_INTEGER"> and user_id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
      </cfquery>
  
      <cfif #getcerts.recordcount# LT 1>
  
      <cfset step=0>
      <cfset m="Send Recipient Certificate: getcerts.recordcount LT 1">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
  
      <cfelse>

        <!--- SEND CERTIFICATE --->
      <cfinclude template="./inc/send_smime_certificate.cfm">

        <cfset session.m = 16>
        <cfoutput>
        <cflocation url="view_recipient_certificates.cfm?type=#url.type#&id=#url.id#" addtoken="no">
        </cfoutput>
    
    
      <!--- /CFIF  #getcerts.recordcount# LT 1 --->
      </cfif>
    
        <!--- /CFIF   #form.certificate_id# is "" --->
        </cfif>
    
        <!--- /CFIF  StructKeyExists(form, "certificate_id") --->
        </cfif>


      <cfelseif #action# is "downloadcertificate">

        <!--- FORM.CERTIFICATE_ID --->
        <cfif NOT StructKeyExists(form, "certificate_id")>
      
          <cfset step=0>
          <cfset m="Download Recipient Certificate: form.certificate_id does not exist">
          <cfinclude template="./inc/error.cfm">
          <cfabort>
      
          <cfelseif StructKeyExists(form, "certificate_id")>
      
            <cfif #form.certificate_id# is "">
      
              
          <cfset step=0>
          <cfset m="Download Recipient Certificate: form.certificate_id is blank">
          <cfinclude template="./inc/error.cfm">
          <cfabort>
      
          <cfelseif #form.certificate_id# is not "">
      
          <cfquery name="getcerts" datasource="hermes">
          select * from recipient_certificates where id = <cfqueryparam value = #form.certificate_id# CFSQLType = "CF_SQL_INTEGER"> and user_id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
          </cfquery>
      
          <cfif #getcerts.recordcount# LT 1>
      
          <cfset step=0>
          <cfset m="Send Recipient Certificate: getcerts.recordcount LT 1">
          <cfinclude template="./inc/error.cfm">
          <cfabort>
      
          <cfelse>

      <!--- DOWNLOAD CERTIFICATE --->
      <cfinclude template="./inc/download_smime_certificate.cfm">

      <!---
      <cfset session.m = 16>
      <cfoutput>
      <cflocation url="view_recipient_certificates.cfm?type=#url.type#&id=#url.id#" addtoken="no">
      </cfoutput>
    --->
  
                
      <!--- /CFIF  #getcerts.recordcount# LT 1 --->
      </cfif>
    
      <!--- /CFIF   #form.certificate_id# is "" --->
      </cfif>
  
      <!--- /CFIF  StructKeyExists(form, "certificate_id") --->
      </cfif>
    

 <!--- /CFIF FOR ACTION ---> 
</cfif>

  <!--- ACTIONS END HERE --->


    
    <cfif #getcertificates.recordcount# GTE 1>
    

    
    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
         
            <th>Download</th>
            <th>Send</th>
            <th>Delete</th>
            <th>Recipient</th>
            <th>CA</th>
            <th>Expires</th>
            <th>Thumbprint</th>
            <th>Length</th>
            <th>Algorithm</th>
       


          

          </tr>
        </thead>
        <tbody>

          <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
         
          

      <cfoutput query="getcertificates">
    
    
          <tr>
            <td>

              <form name="SendCertificate" method="post">

                <input type="hidden" name="action" value="downloadcertificate">
                <input type="hidden" name="certificate_id" value="#id#"/>

                <button type="submit" value="" class="btn btn-secondary" onclick="this.form.submit();"><i class="fas fa-download"></i></button>

              </form>
           
            </td>

            <td>
              
              <cfset decryptedPassword=decrypt(smime_certificate_password, #theKey#, "AES", "Base64")>

              <button a href="##send_modal"  type="button" id="send" class="btn btn-secondary" data-toggle="modal" data-certificate="#id#" data-password="#decryptedPassword#"><i class="fas fa-share-alt"></i></button>
              

            </td>

            <td>

              <button a href="##delete_modal"  type="button" id="delete" class="btn btn-danger" data-toggle="modal" data-certificate="#id#"><i class="fas fa-trash-alt"></i></button>

            </td>
      
            <td>#getrecipientdetails.recipient#</td>
            <!---
            <td>
            
              <input type="hidden" name="id" value="#id#">
              <button type="button" class="btn btn-danger" data-toggle="modal" data-target="##deleteProductModal" data-productid="#id#" data-productname="#entry_name#">
              <i class="fa fa-trash"></i></button>
            
            
           
            <!--- </form> --->
          </td>
        --->

        <cfif #external_ca# is "1">
          <td>#external_ca_name#</td>

        <cfelse>
          <cfquery name="getca" datasource="hermes">
            select * from ca_settings where id='#ca_id#'
            </cfquery>

       <td>#getca.ca_commonname#</td>

        <!--- #external_ca# is/not 1 --->    
        </cfif>
       
            <td> #DateFormat(smime_certificate_expiration, "yyyy-mm-dd")#</td>
            <td>#thumbprint#</td>


           
            <cfif #external_ca# is 1>
            <td>N/A</td>
            <cfelse>
            <td>#encryption#</td>

               <!--- /CFIF #external_ca# is/not 1 --->
              </cfif>

            <cfif #external_ca# is 1>
            <td>N/A</td>
            <cfelse>
            <td>#algorithm#</td>

            <!--- /CFIF #external_ca# is/not 1 --->
            </cfif>

                       
          </tr>

        </cfoutput>
        </tbody>
        
        <tfoot>
          <tr>
             
            <th>Download</th>
            <th>Send</th>
            <th>Delete</th>
            <th>Recipient</th>
            <th>CA</th>
            <th>Expires</th>
            <th>Thumbprint</th>
            <th>Length</th>
            <th>Algorithm</th>


          

          </tr>
        </tfoot>
       
      </table>
    
    
    <cfelseif #getcertificates.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Recipient Certificates were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getcertificates.recordcount --->
    </cfif>
    
    
   
    
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

<!--- CREATE CERTIFICATE MODAL SCRIPT STARTS HERE  --->
<script>
  $('#create_modal').on('show.bs.modal', function(e) {
      var recipient_id = $(e.relatedTarget).data('recipient');
      $(e.currentTarget).find('input[name="recipient_id"]').val(recipient_id);
  });
    </script>
<!--- CREATE CERTIFICATE MODAL SCRIPT ENDS HERE  --->

<!--- IMPORT CERTIFICATE MODAL SCRIPT STARTS HERE  --->
<script>
  $('#import_modal').on('show.bs.modal', function(e) {
      var recipient_id = $(e.relatedTarget).data('recipient');
      $(e.currentTarget).find('input[name="recipient_id"]').val(recipient_id);
  });
    </script>
<!--- IMPORT CERTIFICATE MODAL SCRIPT ENDS HERE  --->

<!--- DELETE CERTIFICATE MODAL SCRIPT STARTS HERE  --->
<script>
  $('#delete_modal').on('show.bs.modal', function(e) {
      var certificate_id = $(e.relatedTarget).data('certificate');
      $(e.currentTarget).find('input[name="certificate_id"]').val(certificate_id);
  });
    </script>
<!--- DELETE CERTIFICATE MODAL SCRIPT ENDS HERE  --->

<!--- SEND CERTIFICATE MODAL SCRIPT STARTS HERE  --->
<script>
  $('#send_modal').on('show.bs.modal', function(e) {
      var certificate_id = $(e.relatedTarget).data('certificate');
      $(e.currentTarget).find('input[name="certificate_id"]').val(certificate_id);
  });
    </script>

<!--- SEND CERTIFICATE MODAL SCRIPT ENDS HERE  --->

<!--- SEND CERTIFICATE MODAL SCRIPT STARTS HERE  --->
<script>
  $('#send_modal').on('show.bs.modal', function(e) {
      var password = $(e.relatedTarget).data('password');
      $(e.currentTarget).find('input[name="password"]').val(password);
  });
    </script>

<!--- SEND CERTIFICATE MODAL SCRIPT ENDS HERE  --->

<script>
  // Add the following code if you want the name of the file appear on select
  $(".custom-file-input").on("change", function() {
    var fileName = $(this).val().split("\\").pop();
    $(this).siblings(".custom-file-label").addClass("selected").html(fileName);
  });
  </script>
  


 <!--- SCRIPT TO SHOW/HIDE CERTIFICATE PASSWORD SCRIPT STARTS HERE  --->
   <!--- THIS SCRIPT WILL NOT WORK IF PLACED IN THE <HEAD></HEAD> SECTION  --->

   <script>

    $('#autopass').on('change',function(){
      if( $(this).val()==="yes" ){
      $("#pfxpassword").hide()
      }
      else{
      $("#pfxpassword").show()
      }
    });
    
    </script>
  
  <!--- SCRIPT TO SHOW/HIDE CERTIFICATE PASSWORD SCRIPT ENDS HERE  --->


</html>