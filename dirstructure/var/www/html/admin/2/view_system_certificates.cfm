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
  <title>Hermes SEG | System Certificates</title>

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

<!--- TEXT AREA STYLE ---> 
<style>
  textarea{
border:1px solid #999999;
width:100%;
margin:5px 0;
padding:3px;
  }
  .textareacontainer{
padding-right: 8px; /* 1 + 3 + 3 + 1 */
  }
    </style>

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
<h1 class="m-0">System Certificates</h1>
<!---
<h2 class="m-0">Group Member: #session.thegroups#</h2>
--->
    </cfoutput>

    </div><!-- /.col -->
    <div class="col-sm-6">
<ol class="breadcrumb float-sm-right">
  <li class="breadcrumb-item"><a href="#">Home</a></li>
  <li class="breadcrumb-item active">System Certificates</li>
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
<cfif form.action is not "">
<cfset action = form.action>

<!--- /CFIF form.action is not "" --->
</cfif>

<!--- /CFIF for StructKeyExists --->
</cfif>  


<cfquery name="getsystemcertificates" datasource="hermes">
select id, type, issuer, subject, friendly_name, serial, fingerprint, file_name from system_certificates
</cfquery>

<!--- ERROR MESSAGES START HERE --->

<cfif #m# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Country Code must be 2 characters only (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Common Name. Common Name can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), dashes (-), periods (.) and asterisks (*) (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error creating the certificate request (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "4">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>CSR completed successfully. Click Download CSR button below </cfoutput><br>

<div>&nbsp;</div>

<div class="text-center">
<!--- DOWNLOAD RAR BUTTON --->
<cfoutput>
  <a href="/admin/2/inc/download_csr.cfm?customtrans=#session.customtrans#" class="btn btn-secondary" role="button"><i class="fas fa-download fa-lg"></i>&nbsp;&nbsp;Download CSR</a>
  </cfoutput>
</div>

  </div>

  <cfset session.customtrans = "">
  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "5">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Certificate Name field cannot be blank (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "6">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You have entered an invalid Certificate Name. Certificate Name can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), dashes (-), underscores (_) (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "7">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Certificate field cannot be blank (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "8">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Certificate field is not Base64 encoded (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "9">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Unencrypted Key field cannot be blank (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "10">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Unencrypted Key field is not Base64 encoded (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "11">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Root and Intermediate CA Certificates field cannot be blank (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "12">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Root and Intermediate CA Certificates field is not Base64 encoded (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "13">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Certifcate and Root and Intermediate CA Certificates field have failed verification because the certificate is expired (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "14">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Certifcate and Root and Intermediate CA Certificates field have failed verification because they don't seem to be valid certificates (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "15">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Certifcate and Root and Intermediate CA Certificates field have failed verification with undefined exception (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "16">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error parsing certificate parameters (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "17">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Certificate Imported successfully. </cfoutput><br>

  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "18">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The certificate was not imported because it already exists (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "19">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Certificate Name already exists. Please choose a different Certificate Name (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "20">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error while attempting to request Acme Certificate. Domain name does not end with a valid public suffix (TLD)  (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "21">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Acme Certificate Requested successfully. </cfoutput><br>

  </div>

  <cfset session.m = 0>
  
</cfif>


<cfif #m# is "22">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error while attempting to request Acme Certificate. Domain Unauthorized (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "23">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error while attempting to request Acme Certificate. DNS Error (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "24">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error while attempting to request Acme Certificate. Ensure that ports 80 and 443 are forwarded to the public IP of Hermes SEG (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "25">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error while attempting to request Acme Certificate. The certificate already exists and is not yet due for renewal (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "26">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error while attempting to request Acme Certificate. Unhandled exception (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "27">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Domain Name is invalid (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "28">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Common Name cannot be blank (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "29">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Notifications E-mail address is invalid (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "30">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Certificate you are attempting to delete is assigned to the Web Service (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "31">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Certificate you are attempting to delete is assigned to the SMTP Service (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "32">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error deleting the Certificate (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "33">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Certificate Deleted successfully. </cfoutput><br>

  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "34">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You cannot delete the system-self-signed Certificate (Error Code: #m#)</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>

<!--- ERROR MESSAGES END HERE --->

<span>
  <p> 

<cfif #session.license# is "VALID">    

<!-- REQUEST ACME CERTIFICATE BUTTON -->
<cfoutput>
<a href="##request_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="" data-recipientemail=""><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Request Acme Certificate</a>
</cfoutput>

&nbsp;&nbsp;

<!--- REQUEST ACME CERTIFICATE ENDS HERE --->

<!--- /CFIF session.license is valid --->
</cfif>




    <!-- IMPORT CERTIFICATE BUTTON -->
    <cfoutput>
    <a href="##import_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="" data-recipientemail=""><i class="fa fa-upload fa-lg"></i>&nbsp;&nbsp;Import Certificate</a>
  </cfoutput>
  
  
  <!--- IMPORT CERTIFICATE BUTTON ENDS HERE --->

  &nbsp;&nbsp;


  <!-- GENERATE CSR BUTTON -->
  <cfoutput>
  <a href="##csr_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="" data-recipientemail=""><i class="fas fa-sync fa-lg"></i>&nbsp;&nbsp;Generate CSR</a>
</cfoutput>


<!--- GENERATE CSR BUTTON ENDS HERE --->


</p>


</span>


<!--- DELETE KEYRING MODAL HTML STARTS HERE --->
   

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
  <p>Are you sure you send to delete this Certificate? This action is irreversible! </p>

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
<!--- DELETE KEYRING MODAL HTML ENDS HERE --->

<!--- GENERATE CSR MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="csr_modal" tabindex="-1" role="dialog" aria-labelledby="CsrModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Generate CSR</h4>
</div>
  
<div class="modal-body">

  <!---
  <p>The system will publish the PGP Public Key indicated below to any PGP Key Servers you select. By default, the system automatically selects all the PGP Key Servers in the inventory. If you wish to only publish to selected servers, select only the servers you wish to publish to below and click the Publish Key button. </p>
  --->

  <form autocomplete="off" name="cratecsr" method="post">

    <input type="hidden" name="action" value="generatecsr">
    <input type="hidden" name="algorithm" value="sha512">
 
    <cfoutput>
<div class="form-group">
  <label for="username"><strong>Country Code</strong>&nbsp;(2 Letter Code, e.g. US)</label>
  <input type="text" class="form-control" name="country" value="" id="country" placeholder="Country Code" maxLength="2">
</div>
</cfoutput>

<cfoutput>
  <div class="form-group">
    <label for="username"><strong>State/Provice Name</strong>&nbsp;(Full Name, e.g. Texas)</label>
    <input type="text" class="form-control" name="state" value="" id="state" placeholder="State/Provice Name">
  </div>
  </cfoutput>

  <cfoutput>
    <div class="form-group">
<label for="username"><strong>Locality Name</strong>&nbsp;(Full Name, e.g. Houston)</label>
<input type="text" class="form-control" name="locality" value="" id="locality" placeholder="Locality Name">
    </div>
    </cfoutput>

    <cfoutput>
<div class="form-group">
  <label for="username"><strong>Organization Name</strong>&nbsp;(Full Name, e.g. Widgets, Inc)</label>
  <input type="text" class="form-control" name="organization" value="" id="organization" placeholder="Organization Name">
</div>
</cfoutput>

<cfoutput>
  <div class="form-group">
    <label for="username"><strong>Organization Department</strong>&nbsp;(Full Name, e.g. IT Department)</label>
    <input type="text" class="form-control" name="department" value="" id="department" placeholder="Organization Department">
  </div>
  </cfoutput>

  <cfoutput>
    <div class="form-group">
<label for="commonname"><strong>Common Name</strong>&nbsp;(Domain Name, e.g. widgets.tld)</label>
<input type="text" class="form-control" name="commonname" value="" id="commonname" placeholder="Common Name">
    </div>
    </cfoutput>

    <div class="form-group">
<label><strong>Encryption Length</strong></label>
  
<select class="form-control" name="encryption" data-placeholder="encryption" style="width: 100%;"  id="encryption">
   
    <option value="2048">2048 Bit (Medium Security)</option>
    <option value="4096" selected>4096 Bit (High Security)</option>
 
    </select>   
  
  </div>

  

  <div>&nbsp;</div>
     

    <input type="submit" value="Generate" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>

</div>

<div class="modal-footer">

  <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
</div>
    </div>
  </div>
</div>
<!--- GENERATE CSR MODAL HTML ENDS HERE --->

<!--- REQUEST ACME MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="request_modal" tabindex="-1" role="dialog" aria-labelledby="RequestAcmeModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Request Acme Certificate</h4>
</div>
  
<div class="modal-body">

  <!---
  <p>The system will publish the PGP Public Key indicated below to any PGP Key Servers you select. By default, the system automatically selects all the PGP Key Servers in the inventory. If you wish to only publish to selected servers, select only the servers you wish to publish to below and click the Publish Key button. </p>
  --->

  <form autocomplete="off" name="cratecsr" method="post">

    <input type="hidden" name="action" value="requestacme">
 
    <div class="alert alert-danger">
   
      <p><i class="icon fas fa-exclamation-triangle"></i>Before requesting <strong>Acme Certificates</strong> ensure you first read the <a href="##" onClick="window.open('https://docs.deeztek.com/books/hermes-seg-administrator-guide-v2/page/authentication-settings', '_blank')">System Certificates Documentation</a>. Ensure that <strong>BOTH</strong> ports TCP 80 and TCP 443 are open to Hermes SEG from the Internet and the domain you are requesting the certificate is pointing to the Internet IP address of your Hermes SEG. We recommend that you test using the <strong>Acme Staging</strong> server first to ensure the request works before attempting to use Acme Production</p>
      </div>

      
<div class="form-group">
  <label for="certificate_name"><strong>Certificate Name</strong></label>
  <input type="text" class="form-control" name="certificate_name" value="" id="certificate_name" placeholder="Enter a friendly name for this certificate">
</div>
    

    <div class="form-group">
<label for="commonname"><strong>Domain Name</strong>&nbsp;(e.g. domain.tld)</label>
<input type="text" class="form-control" name="domainname" value="" id="domainname" placeholder="Enter domain name. Do NOT include www. in front">
    </div>
   

 
      <div class="form-group">
  <label for="commonname"><strong>Notifications E-mail address</strong>&nbsp;(e.g. someone@domain.tld)</label>
  <input type="text" class="form-control" name="email" value="" id="email" placeholder="Used for renewal/revocation notifications ">
      </div>


    <div class="form-group">
<label><strong>Acme Server</strong></label>

  
<select class="form-control" name="acmeserver" data-placeholder="acmeserver" style="width: 100%;"  id="acmeserver">
   
    <option value="staging" selected>Acme Staging</option>
    <option value="production">Acme Production</option>
 
    </select>   
  
  </div>

  

  <div>&nbsp;</div>
     

    <input type="submit" value="Request" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>

</div>

<div class="modal-footer">

  <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
</div>
    </div>
  </div>
</div>
<!--- REQUEST ACME MODAL HTML ENDS HERE --->



<!--- IMPORT CERTIFICATE MODAL HTML STARTS HERE --->
   


<div class="modal fade" id="import_modal" tabindex="-1" role="dialog" aria-labelledby="ImportCertModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Import Certificate </h4>
</div>
  
<div class="modal-body">
 

  <form name="import_certificate" method="post" action="">
    
    <input type="hidden" name="action" value="importcertificate">
   

<div class="form-group">
  <label for="certificate_name"><strong>Certificate Name</strong></label>
  <input type="text" class="form-control" name="certificate_name" value="" id="certificate_name" placeholder="Enter a friendly name for this certificate">
</div>


  <div class="form-group">
    <label>Certificate</label>
    <div class="textareacontainer">
<textarea name="certificate" placeholder="Paste contents of Certificate. Include -----BEGIN CERTIFICATE----- &amp; -----END CERTIFICATE----- lines" wrap="physical" rows="10"></textarea>
</div>

  </div>

  <div class="form-group">
    <label>Unencrypted Key</label>
    <div class="textareacontainer">
<textarea name="key" placeholder="Paste content of unencrypted Key. Include -----BEGIN PRIVATE KEY----- &amp; -----END PRIVATE KEY----- lines" wrap="physical" rows="10"></textarea>
</div>

  </div>

  <div class="form-group">
    <label>Root and Intermediate CA Certificates</label>
    <div class="textareacontainer">
<textarea name="chain" placeholder="Paste contents of Root and Intermediate CA Certificates. Include -----BEGIN CERTIFICATE----- &amp; -----END CERTIFICATE----- lines" wrap="physical" rows="10"></textarea>
</div>

  </div>


 
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

<cfif #action# is "generatecsr">

  <!--- VALIDATE PARAMETERS BELOW --->

  <!--- FORM.COUNTRY --->
  
  <cfif NOT StructKeyExists(form, "country")>
  
    <cfset m="Generate CSR: form.country does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "country")>

<!--- CODE TO ENFORCE 2 CHARACTER LENGTH --->
<cfif NOT ( len(form.country) EQ 2)>
<cfset step=0>
<cfset session.m=1>

<cfoutput>
<cflocation url="view_system_certificates.cfm" addtoken="no">
</cfoutput>

<!--- /CFIF NOT ( len(form.country) EQ 2) --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "country") --->  
</cfif>

<!--- FORM.STATE --->
  
<cfif NOT StructKeyExists(form, "state")>
  
  <cfset m="Generate CSR: form.state does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF NOT StructKeyExists(form, "state") --->  
</cfif>

<!--- FORM.LOCALITY --->
  
<cfif NOT StructKeyExists(form, "locality")>
  
  <cfset m="Generate CSR: form.locality does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF NOT StructKeyExists(form, "locality") --->  
</cfif>

<!--- FORM.ORGANIZATION --->
  
<cfif NOT StructKeyExists(form, "organization")>
  
  <cfset m="Generate CSR: form.organization does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF NOT StructKeyExists(form, "organization") --->  
</cfif>

<!--- FORM.DEPARTMENT --->
  
<cfif NOT StructKeyExists(form, "department")>
  
  <cfset m="Generate CSR: form.department does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF NOT StructKeyExists(form, "department") --->  
</cfif>

<!--- FORM.COMMONNAME --->
  
<cfif NOT StructKeyExists(form, "commonname")>
  
  <cfset m="Generate CSR: form.commonname does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "commonname")>

<cfif #form.commonname# is "">
  <cfset step=0>
  <cfset session.m=28>
  
  <cfoutput>
  <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>

<cfelse>

<cfif REFind("[^A-Za-z0-9\.\-\*@]",form.commonname) gt 0>

<cfset step=0>
<cfset session.m=2>

<cfoutput>
<cflocation url="view_system_certificates.cfm" addtoken="no">
</cfoutput>

<!--- #form.commonname# is "" --->
</cfif>

<!--- /CFIF REFind("[^A-Za-z0-9\.\-\*]",form.commonname) gt 0 --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "commonname") --->  
</cfif>

<cfif NOT StructKeyExists(form, "encryption")>
  
  <cfset m="Generate CSR: form.encryption does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "encryption")>

<cfif #form.encryption# is "2048" OR #form.encryption# is "4096">

<cfelse>

  <cfset m="Generate CSR: form.encryption is not 2048 or 4096">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #form.encryption# is "2048" OR #form.encryption# is "4096" --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "encryption") --->  
</cfif>

<cfif NOT StructKeyExists(form, "algorithm")>
  
  <cfset m="Generate CSR: form.algorithm does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "algorithm")>

<cfif #form.algorithm# is "sha256" OR #form.algorithm# is "sha384" OR #form.algorithm# is "sha512">

<cfelse>

  <cfset m="Generate CSR: form.algorithm is not sha256 or sha385 or sha512">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #form.algorithm# is "sha256" OR #form.algorithm# is "sha384" OR #form.algorithm# is "sha512" --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "algorithm") --->  
</cfif>


  <!--- VALIDATE PARAMETERS ABOVE --->


<cfinclude template="./inc/generate_csr.cfm" />

<cfelseif #action# is "deletecertificate">

  <!--- FORM.CERTIFICATE_ID --->
  <cfif NOT StructKeyExists(form, "certificate_id")>

    <cfset step=0>
    <cfset m="Delete System Certificate: form.certificate_id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "certificate_id")>

      <cfif #form.certificate_id# is "">

    <cfset step=0>
    <cfset m="Delete System Certificate: form.certificate_id is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    
      <!--- IF CERTIFICATE ID IS 1 (SYSTEM-SELF-SIGNED) THEN THROW AN ERROR --->
      <cfelseif #form.certificate_id# is "1">

        <cfset session.m = 34>
        <cfoutput>
        <cflocation url="view_system_certificates.cfm" addtoken="no">
        </cfoutput>

    <cfelse>

      <cfquery name="getcertificate" datasource="hermes">
        select * from system_certificates where id=<cfqueryparam value = #form.certificate_id# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>
        

    <cfif #getcertificate.recordcount# LT 1>

    <cfset step=0>
    <cfset m="Delete System Certificate: getcertificate.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelse>

<!--- DELETE CERTIFICATE --->
<cfinclude template="./inc/delete_system_certificate.cfm">


  <cfset session.m = 33>
    <cfoutput>
    <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfoutput>



  <!--- /CFIF  #getcertificate.recordcount# LT 1 --->
  </cfif>


    <!--- /CFIF   #form.certificate_id# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "certificate_id") --->
    </cfif>

<cfelseif #action# is "requestacme">

  <!---LICENSE CHECK BELOW --->
  <cfif StructKeyExists(session, "license")>
    <cfif #session.license# is "VIOLATION">
    
    <cfinclude template="./inc/license_invalid.cfm">
    <cfabort>
    
    <cfelseif #session.license# is "NEW">
    
<cfinclude template="./inc/license_invalid.cfm">
<cfabort>

<!--- /CFIF #session.license# is  --->
</cfif>

<!--- /CFIF StructKeyExists(session, "license")> --->
</cfif>

<!---LICENSE CHECK ABOVE --->


  <!--- VALIDATE PARAMETERS BELOW --->
  
  <!--- FORM.CERTIFICATE_NAME --->
  <cfif NOT StructKeyExists(form, "certificate_name")>

    <cfset step=0>
    <cfset m="Request Acme Certificate: form.certificate_name does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

  <cfelseif StructKeyExists(form, "certificate_name")> 

      <cfif #form.certificate_name# is "">

        <cfset step=0>
        <cfset session.m = 5>
        
        <cfoutput>
        <cflocation url="view_system_certificates.cfm" addtoken="no">
        </cfoutput>
        
        <cfelse>
        
        <cfif REFind("[^_a-zA-Z0-9\-\_\.]",form.certificate_name) gt 0>
        
        <cfset step=0>
        <cfset session.m=6>
            
        <cfoutput>
        <cflocation url="view_system_certificates.cfm" addtoken="no">
        </cfoutput>
        
        <cfelse>
        
        <cfquery name="checkcertname" datasource="hermes">
        select friendly_name from system_certificates where friendly_name like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.certificate_name#">
        </cfquery>
        
        <cfif #checkcertname.recordcount# GTE 1>
        
        <cfset step=0>
        <cfset session.m=19>
            
        <cfoutput>
        <cflocation url="view_system_certificates.cfm" addtoken="no">
        </cfoutput>
              
        <!--- #checkcertname.recordcount# --->
        </cfif>
        
        <!--- REFind("[^_a-zA-Z0-9\-\_]",form.certificate_name) gt 0 --->
        </cfif>
        
        <!--- #form.certificate_name# is --->
        </cfif>
      
    <!--- /CFIF  StructKeyExists(form, "certificate_name") --->
    </cfif>

    

  <!--- FORM.DOMAINNAME --->
  
  <cfif NOT StructKeyExists(form, "domainname")>
  
    <cfset m="Request Acme Certificate: form.domainname does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "domainname")>

<cfoutput>
<cfset testDomain = "bob@#form.domainname#">
</cfoutput>

<cfif NOT IsValid("email", #testDomain#)>

<cfset step=0>
<cfset session.m=27>

<cfoutput>
<cflocation url="view_system_certificates.cfm" addtoken="no">
</cfoutput>


<!--- /CFIF NOT IsValid("email", #testEmail#) --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "domainname") --->  
</cfif>

<!--- FORM.EMAIL --->
  
<cfif NOT StructKeyExists(form, "email")>
  
  <cfset m="Request Acme Certificate: form.email does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "email")>
 
  <cfif NOT IsValid("email", #form.email#)>
  
  <cfset step=0>
  <cfset session.m=29>
  
  <cfoutput>
  <cflocation url="view_system_certificates.cfm" addtoken="no">
  </cfoutput>
  
  
  <!--- /CFIF NOT IsValid("email", #form.email#) --->  
</cfif>

<!--- /CFIF NOT StructKeyExists(form, "email") --->  
</cfif>

<cfif NOT StructKeyExists(form, "acmeserver")>
  
  <cfset m="Request Acme Certificate: form.acmeserver does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "acmeserver")>

<cfif #form.acmeserver# is "staging" OR #form.acmeserver# is "production">

<cfelse>

  <cfset m="Request Acme Certificate: form.acmeserver is not staging or production">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #form.acmeserver# is "staging" OR #form.acmeserver# is "production" --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "acmeserver") --->  
</cfif>


  <!--- VALIDATE PARAMETERS ABOVE --->


<cfinclude template="./inc/request_acme_certificate.cfm" />

  

<cfelseif #action# is "importcertificate">


<!--- VALIDATE FORM INPUTS STARTS HERE --->

<cfif NOT StructKeyExists(form, "certificate_name")>

<cfset step=0>
<cfset m="Import Certificate: form.certificate_name does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>
  
<!--- /CFIF  StructKeyExists(form, "certificate_name") --->
</cfif>

<cfif NOT StructKeyExists(form, "certificate")>

  <cfset step=0>
  <cfset m="Import Certificate: form.certificate does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
    
  <!--- /CFIF  StructKeyExists(form, "certificate") --->
  </cfif>

  <cfif NOT StructKeyExists(form, "key")>

    <cfset step=0>
    <cfset m="Import Certificate: form.key does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <!--- /CFIF  StructKeyExists(form, "key") --->
    </cfif>

    <cfif NOT StructKeyExists(form, "chain")>

<cfset step=0>
<cfset m="Import Certificate: form.chain does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>
  
<!--- /CFIF  StructKeyExists(form, "chain") --->
</cfif>


<cfif #form.certificate_name# is "">

<cfset step=0>
<cfset session.m = 5>

<cfoutput>
<cflocation url="view_system_certificates.cfm" addtoken="no">
</cfoutput>

<cfelse>

<cfif REFind("[^_a-zA-Z0-9\-\_\.]",form.certificate_name) gt 0>

<cfset step=0>
<cfset session.m=6>
    
<cfoutput>
<cflocation url="view_system_certificates.cfm" addtoken="no">
</cfoutput>

<cfelse>

<cfquery name="checkcertname" datasource="hermes">
select friendly_name from system_certificates where friendly_name like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.certificate_name#">
</cfquery>

<cfif #checkcertname.recordcount# GTE 1>

<cfset step=0>
<cfset session.m=19>
    
<cfoutput>
<cflocation url="view_system_certificates.cfm" addtoken="no">
</cfoutput>

<cfelse>

<cfset step = 1>

<!--- #checkcertname.recordcount# --->
</cfif>

<!--- REFind("[^_a-zA-Z0-9\-\_]",form.certificate_name) gt 0 --->
</cfif>

<!--- #form.certificate_name# is --->
</cfif>


<cfif #step# is "1">

  <cfif #form.certificate# is "">

    <cfset step=0>
    <cfset session.m = 7>
    
    <cfoutput>
    <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfoutput>
    
    <cfelse>
    
    <cfset step = 2>
    

    <!--- #form.certificate# is --->
    </cfif>

<!--- /CFIF step 1 --->
</cfif>


<cfif #step# is "2">

  <cfif #form.key# is "">

    <cfset step=0>
    <cfset session.m = 9>
    
    <cfoutput>
    <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfoutput>
    
    <cfelse>
    
    <cfset step = 3>
    
    <!--- #form.key# is --->
    </cfif>

<!--- /CFIF step 2 --->
</cfif>

<cfif #step# is "3">

  <cfif #form.chain# is "">

    <cfset step=0>
    <cfset session.m = 11>
    
    <cfoutput>
    <cflocation url="view_system_certificates.cfm" addtoken="no">
    </cfoutput>
    
    <cfelse>
    
    <cfset step = 4>
    
    <!--- #form.chain# is --->
    </cfif>

<!--- /CFIF step 3 --->
</cfif>

<cfif #step# is "4">
  
<cfinclude template="./inc/import_system_certificate.cfm" />

</cfif>

 <!--- /CFIF FOR ACTION ---> 
</cfif>

  <!--- ACTIONS END HERE --->


<cfif #getsystemcertificates.recordcount# GTE 1>
        
<table class="table table-striped"  id="sortTable" style="width:100%">
  <thead>
    <tr>
<th>Delete</th>    
<th>Type</th>
<th>Name</th>
<th>Web</th>
<th>SMTP</th>
<th>Subject</th>
<th>Issuer</th>
<th>Startdate</th>
<th>Enddate</th>
<th>Serial</th>
<th>Fingerprint</th>

    </tr>
  </thead>
  <tbody>

   
<cfloop query="getsystemcertificates">

  
  <cfoutput>
   
    
    <tr>


      <td>

        <button a href="##delete_modal"  type="button" id="delete" class="btn btn-danger" data-toggle="modal" data-certificate="#id#"><i class="fas fa-trash-alt"></i></button>

      </td>



<td>#type#</td>
<td>#friendly_name#</td>

<cfquery name="web" datasource="hermes">
 select parameter, value2 from parameters2 where parameter = 'console.certificate' and value2 = <cfqueryparam value = #id# CFSQLType = "CF_SQL_INTEGER"> and module = 'console'
</cfquery>

 

<cfif #web.recordcount# LT 1>
<td>NO</td>
<cfelse>
<td>YES</td>

<!--- /CFIF web.recordcount --->
</cfif>

<cfquery name="smtp" datasource="hermes">
  select parameter, value2 from parameters2 where parameter = 'smtp.certificate' and value2 = <cfqueryparam value = #id# CFSQLType = "CF_SQL_INTEGER"> and module = 'certificates'
 </cfquery>
 
 <cfif #smtp.recordcount# LT 1>
 <td>NO</td>
 <cfelse>
 <td>YES</td>
 
 <!--- /CFIF smtp.recordcount --->
 </cfif>

 <td>#subject#</td>
 <td>#issuer#</td>

<cfif #type# is "Imported">

<cfset path = "/opt/hermes/ssl/#file_name#_hermes.pem">

<cfelseif #type# is "Acme">

<cfset path = "/etc/letsencrypt/live/#file_name#/fullchain.pem">

<cfelse>

<cfset m="View System certifificates: certificate.type is not Imported or Acme">
<cfinclude template="./inc/error.cfm">
<cfabort>

 <!--- /CFIF #type# is --->
</cfif>

 <!--- PARSE STARTDATE FROM CERTIFICATE --->
 <cftry>
  
<cfexecute name = "/usr/bin/openssl"
arguments="x509 -in #path# -noout -startdate"
variable="thestartdate"
timeout = "120">
</cfexecute>

<cfoutput>
<cfset thestartdate = REReplace("#thestartdate#","notBefore=","","ALL")>
<cfset thestartdate = #trim(thestartdate)#>
</cfoutput>
  
<cfcatch type="any">

<cfset m="View System certifificates: there was an error parsing certificate startdate">
<cfinclude template="./inc/error.cfm">
<cfabort>
  
</cfcatch>
  
</cftry>

<!--- PARSE ENDDATE FROM CERTIFICATE --->
<cftry>
  
  <cfexecute name = "/usr/bin/openssl"
  arguments="x509 -in #path# -noout -enddate"
  variable="theenddate"
  timeout = "120">
  </cfexecute>
  
  <cfoutput>
  <cfset theenddate = REReplace("#theenddate#","notAfter=","","ALL")>
  <cfset theenddate = #trim(theenddate)#>
  </cfoutput>
    
  <cfcatch type="any">
  
  <cfset m="View System certifificates: there was an error parsing certificate enddate">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
    
  </cfcatch>
    
  </cftry>
  

 <td>#thestartdate#</td>
 <td>#theenddate#</td>

 
 
 <td>#serial#</td>
 <td>#fingerprint#</td>



    </cfoutput>



  </tr>


  </cfloop>
  </tbody>
  
  <tfoot>
    <tr>
    
       
      <th>Delete</th>    
      <th>Type</th>
      <th>Name</th>
      <th>Web</th>
      <th>SMTP</th>
      <th>Subject</th>
      <th>Issuer</th>
      <th>Startdate</th>
      <th>Enddate</th>
      <th>Serial</th>
      <th>Fingerprint</th>

    </tr>
  </tfoot>
 
</table>
    
    
    <cfelseif #getsystemcertificates.recordcount# LT 1>
    
<div class="alert alert-danger alert-dismissible">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-ban"></i> Oops!</h4>
  <cfoutput>No System Certificates were found</strong></cfoutput>
</div>
    
<!--- /CFIF FOR getsystemcertificates.recordcount --->
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



<!--- DELETE KEYRING MODAL SCRIPT STARTS HERE  --->
<script>
  $('#delete_modal').on('show.bs.modal', function(e) {
var certificate_id = $(e.relatedTarget).data('certificate');
$(e.currentTarget).find('input[name="certificate_id"]').val(certificate_id);
  });
    </script>

<!--- DELETE KEYRING PASSWORD MODAL SCRIPT ENDS HERE  --->



</html>