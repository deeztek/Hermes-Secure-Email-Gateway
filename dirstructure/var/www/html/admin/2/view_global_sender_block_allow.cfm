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
  <title>Hermes SEG | Global Sender Block/Allow</title>

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
  "order": [[ 2, "asc" ]]
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

<!--- ADJUST DATATABLE FONT SIZES --->
<style>
  th { font-size: 16px; }
td { font-size: 16px; }
</style>


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
<h1 class="m-0">Global Sender Block/Allow</h1>
<!---
<h2 class="m-0">Group Member: #session.thegroups#</h2>
--->
    </cfoutput>

    </div><!-- /.col -->
    <div class="col-sm-6">
<ol class="breadcrumb float-sm-right">
  <li class="breadcrumb-item"><a href="#">Home</a></li>
  <li class="breadcrumb-item active">Global Sender Block/Allow</li>
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

<!--- GET SMTP TLS SETTINGS TO BE USED AS FORM INPUTS BELOW --->
<cfinclude template="./inc/get_smtp_tls_settings.cfm">

<!--- GET SMTP TLS POLICIES TO BE USED AS FORM INPUTS BELOW --->
<cfinclude template="./inc/get_smtp_tls_policies.cfm">
  
  <cfparam name = "tls_mode" default = "#smtpd_tls_security_level.parameter#"> 
  <cfif StructKeyExists(form, "tls_mode")>
  <cfif form.tls_mode is not "">
  <cfset tls_mode = form.tls_mode>
  
<!--- /CFIF form.tls_mode is --->
</cfif>

<!--- StructKeyExists(form, "tls_mode") --->
  </cfif>

  <cfparam name = "smtpCertificate" default = "#smtpd_tls_certificate.value2#"> 


<!--- ERROR MESSAGES START HERE --->

<cfif #m# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP TLS Certificate cannot be blank when the SMTP TLS Mode is set to Opportunistic TLS or Mandatory TLS (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The SMTP TLS Certificate you entered is not valid (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You cannot select the system-self-signed Certificate for SMTP TLS (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "4">
  
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You entered an invalid domain (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "5">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Domain you are attempting to add already exists (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "6">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Domain you are attempting to edit already exists (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

  
<cfif #m# is "34">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>The Domain was deleted successfully.</cfoutput><br><br>


  </div>

  <cfset session.m = 0>
  
</cfif>


<cfif #m# is "35">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>The SMTP TLS Mode was set successfully.</cfoutput><br><br>


  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "36">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>The Global Sender Block/Allow was Disabled successfully.</cfoutput><br><br>

  </div>

  <cfset session.m = 0>
  
</cfif>

  
<cfif #m# is "37">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>The Domain was added successfully</cfoutput><br><br>



  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "38">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Global Sender Block/Allow Settings applied successfully.</cfoutput>
  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "39">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>The Domain was edited successfully</cfoutput><br><br>



  </div>

  <cfset session.m = 0>
  
</cfif>


<!--- ERROR MESSAGES END HERE --->


<!--- ADD DOMAIN MODAL HTML STARTS HERE --->

<div class="modal fade" id="adddomain_modal" tabindex="-1" role="dialog" aria-labelledby="AddDomainModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Add SMTP TLS Policy Domain </h4>
</div>
  
<div class="modal-body">

  <form name="AddDomain" autocomplete="off" method="post">

    <input type="hidden" name="action" value="adddomain">

  


    <cfoutput>
      <div class="form-group">
        <label for="domain"><strong>Domain</strong></label>
        <div class="alert alert-warning">
   
          <p><i class="icon fas fa-exclamation-triangle"></i>Adding a "." in front of the domain will encompass the domain and all subdomains Ex: .domain.tld</p>
          </div>
        <input type="text" class="form-control" name="domain" value="" id="Domain" placeholder="Domain" maxLength="64">
      </div>
      </cfoutput>

            

            <cfoutput>
              <div class="form-group">
                <label><strong>Note</strong></label>
                <input type="text" class="form-control" name="domain_note" value="" id="domain_note" placeholder="Enter Note" maxLength="255">
              </div>
              </cfoutput>

    <div>&nbsp;</div>

    <input type="submit" value="Submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  </form>

</div>


<div class="modal-footer">
 
<button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>

</div>
    </div>
  </div>
</div>
<!--- ADD DOMAIN MODAL HTML ENDS HERE --->



<!--- DELETE DOMAIN MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteCertificateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Delete Domain </h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you send to delete this Domain from the SMTP TLS Policy? This action is irreversible! </p>

</div>
<div class="modal-footer">
  <form name="DeleteDomain" method="post">

    <input type="hidden" name="action" value="Delete Domain">
    <input type="hidden" name="delete_id" value=""/>
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- DELETE DOMAIN MODAL HTML ENDS HERE --->


<!--- EDIT DOMAIN MODAL HTML STARTS HERE --->

<div class="modal fade" id="editdomain_modal" tabindex="-1" role="dialog" aria-labelledby="editDomainModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Edit Domain</h4>
</div>
  
<div class="modal-body">


  <form name="EditDomain" autocomplete="off" method="post">

    <input type="hidden" name="action" value="editdomain">
    <input type="hidden" name="data_id" value=""/>

    <cfoutput>
      <div class="form-group">
        <label for="username"><strong>Domain</strong></label>
        <div class="alert alert-warning">
   
          <p><i class="icon fas fa-exclamation-triangle"></i>Adding a "." in front of the domain will encompass the domain and all subdomains Ex: .domain.tld</p>
          </div>
        <input type="text" class="form-control" name="domain" value="" id="domain" placeholder="Domain" maxLength="20">
      </div>
      </cfoutput>

      
            

            <cfoutput>
              <div class="form-group">
                <label><strong>Note</strong></label>
                <input type="text" class="form-control" name="note" value="" id="note" placeholder="Enter Note" maxLength="255">
              </div>
              </cfoutput>

    <div>&nbsp;</div>

    <input type="submit" value="Submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  </form>

</div>


<div class="modal-footer">
 
<button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>

</div>
    </div>
  </div>
</div>
<!--- EDIT DOMAIN MODAL HTML ENDS HERE --->

<!--- ACTIONS START HERE --->

<cfif #action# is "editdomain">


  <!--- VALIDATE PARAMETERS BELOW --->

  <!--- FORM.data_id --->
  <cfif NOT StructKeyExists(form, "data_id")>

    <cfset step=0>
    <cfset m="Edit SMTP TLS Policy Domain: form.data_id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "data_id")>

      <cfif #form.data_id# is "">

        
    <cfset step=0>
    <cfset m="Edit SMTP TLS Policy Domain: form.data_id is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif #form.data_id# is not "">

      <cfquery name="getdomain" datasource="hermes">
        select * from tls_policies where id=<cfqueryparam value = #form.data_id# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>
        

    <cfif #getdomain.recordcount# LT 1>

    <cfset step=0>
    <cfset m="Edit SMTP TLS Policy Domain: getdomain.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

  <!--- /CFIF  #getdomain.recordcount# LT 1 --->
  </cfif>


    <!--- /CFIF   #form.data_id# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "data_id") --->
    </cfif>

<!--- FORM.domain --->
  
<cfif NOT StructKeyExists(form, "domain")>
  
  <cfset m="Edit SMTP TLS Policy Domain: form.domain does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <cfelseif StructKeyExists(form, "domain")>

<!--- CHECK IF FORM.DOMAIN CONTAINS A (.) IN FRONT --->

<cfif #trim(left(form.domain, 1))# EQ "."> 

<cfset testDomain = "bob@subdomain#form.domain#">

<cfelse>

<cfset testDomain = "bob@#form.domain#">

<!--- /CFIF #trim(left(form.domain, 1))# EQ "." --->
</cfif>

<cfif NOT IsValid("email", #testDomain#)>
            
<cfset step=0>
<cfset session.m=4>
          
<cfoutput>
<cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfoutput>

<cfelse>
  
<cfquery name="checkexists" datasource="hermes">
select domain from tls_policies where domain like <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.domain#"> and id <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.data_id#">
</cfquery>

<cfif #checkexists.recordcount# GTE 1>

<cfset step=0>
<cfset session.m=6>
          
<cfoutput>
<cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfoutput>

<cfelse>

<cfquery name="editdomain" datasource="hermes">
update tls_policies
set
domain = '#form.domain#',
description = '#note#'
where id=<cfqueryparam value = #form.data_id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<!--- GENERATE TLS POLICY --->
<cfinclude template="./inc/generate_tls_policy.cfm">

<!--- RESTART POSTFIX --->
<cfinclude template="./inc/restart_postfix.cfm">


<cfset step=0>
<cfset session.m=39>
          
<cfoutput>
<cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfoutput>

</cfif>




<!--- /CFIF IsValid("email", #testDomain#) --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "domain") --->  
</cfif>

<!--- FORM.DOMAIN --->
  


<cfelseif #action# is "adddomain">



  <!--- VALIDATE PARAMETERS BELOW --->

<!--- FORM.domain --->
  
  <cfif NOT StructKeyExists(form, "domain")>
  
  <cfset m="Add SMTP TLS Policy Domain: form.domain does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <cfelseif StructKeyExists(form, "domain")>

<!--- CHECK IF FORM.DOMAIN CONTAINS A (.) IN FRONT --->

<cfif #trim(left(form.domain, 1))# EQ "."> 

<cfset testDomain = "bob@subdomain#form.domain#">

<cfelse>

<cfset testDomain = "bob@#form.domain#">

<!--- /CFIF #trim(left(form.domain, 1))# EQ "." --->
</cfif>

<cfif NOT IsValid("email", #testDomain#)>
            
<cfset step=0>
<cfset session.m=4>
          
<cfoutput>
<cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfoutput>

<cfelse>
  
<cfquery name="checkexists" datasource="hermes">
select domain from tls_policies where domain like <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.domain#">
</cfquery>

<cfif #checkexists.recordcount# GTE 1>

<cfset step=0>
<cfset session.m=5>
          
<cfoutput>
<cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfoutput>

<cfelse>

<cfquery name="adddomain" datasource="hermes">
insert into tls_policies
(domain, method, description, applied, action)
values 
('#form.domain#', 'encrypt', '#form.domain_note#', '1', 'add')
</cfquery>

<!--- GENERATE TLS POLICY --->
<cfinclude template="./inc/generate_tls_policy.cfm">

<!--- RESTART POSTFIX --->
<cfinclude template="./inc/restart_postfix.cfm">


<cfset step=0>
<cfset session.m=37>
          
<cfoutput>
<cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfoutput>

</cfif>




<!--- /CFIF IsValid("email", #testDomain#) --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "domain") --->  
</cfif>

<!--- FORM.DOMAIN --->
  
<cfelseif #action# is "deletedomain">

   <!--- FORM.data_id --->
   <cfif NOT StructKeyExists(form, "data_id")>

    <cfset step=0>
    <cfset m="Delete SMTP TLS Policy Domain: form.data_id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "data_id")>

      <cfif #form.data_id# is "">

        
    <cfset step=0>
    <cfset m="Delete SMTP TLS Policy Domain: form.data_id is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif #form.data_id# is not "">

      <cfquery name="getdomain" datasource="hermes">
        select * from tls_policies where id=<cfqueryparam value = #form.data_id# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>
        

    <cfif #getdomain.recordcount# LT 1>

    <cfset step=0>
    <cfset m="Delete SMTP TLS Policy Domain: getdomain.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

  <!--- /CFIF  #getdomain.recordcount# LT 1 --->
  </cfif>


    <!--- /CFIF   #form.data_id# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "data_id") --->
    </cfif>



    <cfquery name="deletedomain" datasource="hermes">
    delete from tls_policies
    where id = <cfqueryparam value = #form.data_id# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>

    <!--- GENERATE TLS POLICY --->
<cfinclude template="./inc/generate_tls_policy.cfm">

<!--- RESTART POSTFIX --->
<cfinclude template="./inc/restart_postfix.cfm">
    
    <cfset session.m = 34>
    <cfoutput>
    <cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
    </cfoutput>

  

<cfelseif #action# is "setmode">

<!--- EDIT SMTP TLS SETTINGS --->
<cfinclude template="./inc/edit_smtp_tls_settings.cfm">

<!--- GENERATE POSTFIX CONFIGURATION --->
<cfinclude template="./inc/generate_postfix_configuration.cfm">

<!--- RESTART POSTFIX --->
<cfinclude template="./inc/restart_postfix.cfm">

<cfset session.m = 35>

<cfoutput>
<cflocation url="view_smtp_tls_settings.cfm" addtoken="no">
</cfoutput>   
 
 <!--- /CFIF FOR ACTION ---> 
</cfif>

  <!--- ACTIONS END HERE --->


<span>
  <p> 


<!--- ADD IP BUTTON STARTS HERE --->
<cfoutput>
<a href="##adddomain_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="" data-recipientemail=""><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add Domain</a>
</cfoutput>
<!--- ADD IP BUTTON ENDS HERE --->

</p>


</span>



<div class="card col-sm-8">

<form name="SetTlsMode" method="post">

  <input type="hidden" name="action" value="setmode">

  <cfoutput>
    <input type="hidden" name="certificateno_1" class="certificateno form-control" id="certificateno_1" value="#smtpCertificate#">
    </cfoutput>

  <div class="col-sm-6">

   <div class="form-group">
            <label><strong>SMTP TLS Mode</strong></label>
              
            <select class="form-control" name="tlsmode" style="width: 100%;" id="tlsmode">

      
              <cfif #tls_mode# is "">
               
                <option value="" selected>Disabled</option>
                <option value="may">Opportunistic TLS (Recommended)</option>
                <option value="encrypt">Mandatory TLS (NOT Recommended for Internet Facing Servers)</option>

              <cfelseif #tls_mode# is "may">

                <option value="">Disabled</option>
                <option value="may" selected>Opportunistic TLS (Recommended)</option>
                <option value="encrypt">Mandatory TLS (NOT Recommended for Internet Facing Servers)</option>

              <cfelseif #tls_mode# is "encrypt">

                <option value="">Disabled</option>
                <option value="may">Opportunistic TLS (Recommended)</option>
                <option value="encrypt" selected>Mandatory TLS (NOT Recommended for Internet Facing Servers)</option>

              <cfelse>

                <cfset step=0>
                <cfset m="Global Sender Block/Allow: tls_mode is not empty, may or encrypt">
                <cfinclude template="./inc/error.cfm">
                <cfabort>

              <!--- /CFIF #tls_mode# is --->
              </cfif>
             
                </select>   

              <!--- /DIV class="form-group" --->
              </div>

              <cfif #tls_mode# is "">

              <div class="form-group" id="tlscertificate" style="display:none;">

                <div class="alert alert-warning">
             
                  <p><i class="icon fas fa-exclamation-triangle"></i>Do <strong>NOT</strong> select the <strong>system-self-signed</strong> Certificate</p>
                  </div>

                <label>SMTP TLS Certificate</label>
                <div class="input-group">
                <cfoutput>
                <input type="text" name="certificate_1" class="certificate form-control" id="certificate_1" placeholder="Start typing to search..." value="#getcertdetails.friendly_name#" autocomplete="off">
                </cfoutput>
                
                <!--- /div class="input-group" --->
                </div>
                

           
                  <label>Certificate Subject</label>
                  <div class="input-group">
                  <cfoutput>
                  <input type="text" name="subject_1" class="subject form-control" id="subject_1" value="#getcertdetails.subject#" readonly>
                  </cfoutput>
                  
       
                  <!--- /div class="input-group" --->
                </div>
                       
       
                  <label>Certificate Issuer</label>
                  <div class="input-group">
                  <cfoutput>
                  <input type="text" name="issuer_1" class="issuer form-control" id="issuer_1" value="#getcertdetails.issuer#" readonly>
                  </cfoutput>
                  
       
                     <!--- /div class="input-group" --->
                    </div>
                  

               
                        <label>Certificate Serial</label>
                        <div class="input-group">
                        <cfoutput>
                        <input type="text" name="serial_1" class="serial form-control" id="serial_1" value="#getcertdetails.serial#" readonly>
                        </cfoutput>
                        
                        <!--- /div class="input-group" --->
                        </div>
         
                  <label>Certificate Type</label>
                  <div class="input-group">
                  <cfoutput>
                  <input type="text" name="type_1" class="type form-control" id="type_1" value="#getcertdetails.type#" readonly>
                  </cfoutput>
                  
                  <!--- /div class="input-group" --->
                  </div>
                  
                  <!--- /div class="form-group" id="tlscertificate" --->
                  </div>

  <cfelse>

    <div class="form-group" id="tlscertificate">

      <div class="alert alert-warning">
     
        <p><i class="icon fas fa-exclamation-triangle"></i>Do <strong>NOT</strong> select the <strong>system-self-signed</strong> Certificate</p>
        </div>

      <label>SMTP TLS Certificate</label>
      <div class="input-group">
      <cfoutput>
      <input type="text" name="certificate_1" class="certificate form-control" id="certificate_1" placeholder="Start typing to search..." value="#getcertdetails.friendly_name#" autocomplete="off">
      </cfoutput>
      
      <!--- /div class="input-group" --->
      </div>


        <label>Certificate Subject</label>
        <div class="input-group">
        <cfoutput>
        <input type="text" name="subject_1" class="subject form-control" id="subject_1" value="#getcertdetails.subject#" readonly>
        </cfoutput>
        
        <!--- /div class="input-group" --->
        </div>
        


        

        <label>Certificate Issuer</label>
        <div class="input-group">
        <cfoutput>
        <input type="text" name="issuer_1" class="issuer form-control" id="issuer_1" value="#getcertdetails.issuer#" readonly>
        </cfoutput>
        
        <!--- /div class="input-group" --->
        </div>
            

   
              <label>Certificate Serial</label>
              <div class="input-group">
              <cfoutput>
              <input type="text" name="serial_1" class="serial form-control" id="serial_1" value="#getcertdetails.serial#" readonly>
              </cfoutput>
              
              <!--- /div class="input-group" --->
              </div>



        <label>Certificate Type</label>
        <div class="input-group">
        <cfoutput>
        <input type="text" name="type_1" class="type form-control" id="type_1" value="#getcertdetails.type#" readonly>
        </cfoutput>
        
        <!--- /div class="input-group" --->
        </div>
        
    <!--- /div class="form-group" id="tlscertificate" --->
        </div>



<!--- /CFIF #tls_mode# is --->
</cfif>
  
    
  <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

</form>

  <!--- /div class="col-sm-6" --->
  </div>
    
<br>

    <!--- div class="card"  --->  
  </div>




  <div class="alert alert-warning">

    <p><i class="icon fas fa-exclamation-triangle"></i>Encryption for the domains listed below will not be in effect unless the <strong>SMTP TLS Mode</strong> is set to <strong>Opportunistic TLS</strong> and you have selected a valid <strong>SMTP TLS Certificate</strong> above </p>
    </div>

<cfif #getpolicies.recordcount# GTE 1>
        
<table class="table table-striped"  id="sortTable" style="width:100%">
  <thead>
    <tr>
      <th>Edit</th>    
      <th>Delete</th>
      <th>Domain</th>
      <th>Encyption Mode</th>
      <th>Note</th>

    </tr>
  </thead>
  <tbody>

   
<cfloop query="getpolicies">

  
  <cfoutput>
   
    
    <tr>


      <td>

        <button a href="##editdomain_modal"  type="button" id="delete" class="btn btn-secondary" data-toggle="modal" data-id="#id#" data-domain="#domain#" data-note="#description#"><i class="fas fa-edit"></i></button>

      </td>

      <td>

        <button a href="##delete_modal"  type="button" id="delete" class="btn btn-danger" data-toggle="modal" data-id="#id#"><i class="fas fa-trash-alt"></i></button>

      </td>



<td>#domain#</td>

<td>
  <cfif #method# is "encrypt">
MANDATORY
  <cfelse>
  N/A
  </cfif>
  
  </td>


<td>#description#</td>




    </cfoutput>



  </tr>


  </cfloop>
  </tbody>
  
  <tfoot>
    <tr>
    
      <th>Edit</th>    
      <th>Delete</th>
      <th>Domain</th>
      <th>Encyption Mode</th>
      <th>Note</th>

    </tr>
  </tfoot>
 
</table>
    
    
    <cfelseif #getpolicies.recordcount# LT 1>
    
<div class="alert alert-danger alert-dismissible">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-ban"></i> Oops!</h4>
  <cfoutput>No SMTP TLS Policies were found</strong></cfoutput>
</div>
    
<!--- /CFIF FOR getpolicies.recordcount --->
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

<!--- EDIT IP MODAL SCRIPT STARTS HERE  --->
<script>
  $('#editdomain_modal').on('show.bs.modal', function(e) {
var data_id = $(e.relatedTarget).data('id');
$(e.currentTarget).find('input[name="data_id"]').val(data_id);

var domain = $(e.relatedTarget).data('domain');
$(e.currentTarget).find('input[name="domain"]').val(domain);

var note = $(e.relatedTarget).data('note');
$(e.currentTarget).find('input[name="note"]').val(note);


  });

</script>

<!--- EDIT IP MODAL SCRIPT ENDS HERE  --->

<!--- DELETE IP MODAL SCRIPT STARTS HERE  --->
<script>
  $('#delete_modal').on('show.bs.modal', function(e) {
var data_id = $(e.relatedTarget).data('id');
$(e.currentTarget).find('input[name="data_id"]').val(data_id);
  });
    </script>

<!--- DELETE IP MODAL SCRIPT ENDS HERE  --->


<!--- SCRIPT TO SHOW/HIDE CERTIFICATE SCRIPT STARTS HERE  --->
<script>

  $('#tlsmode').on('change',function(){
    if( $(this).val()===""){
    $("#tlscertificate").hide()
    }
    else{
    $("#tlscertificate").show()
    }
  });
  
  </script>

  
<!--- SCRIPT TO SHOW/HIDE CERTIFICATE SCRIPT ENDS HERE  --->

 <!--- SCRIPT TO GET CERTIFICATES BELOW --->

<script type="text/javascript">
  $(document).ready(function(){

      $(document).on('keydown', '.certificate', function() {
          
          var id = this.id;
          var splitid = id.split('_');
          var index = splitid[1];

          $( '#'+id ).autocomplete({
              source: function( request, response ) {
                  $.ajax({
                      url: "./inc/getcertificates.cfm",
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
                      url: './inc/getcertificates.cfm',
                      type: 'post',
                      data: {id:id,request:2},
                      dataType: 'json',
                      success:function(response){
                          
                          var len = response.length;

                          if(len > 0){
                              var certificate_no = response[0]['id'];
                              var type = response[0]['type'];
                              var subject = response[0]['subject'];
                              var issuer = response[0]['issuer'];
                              var serial = response[0]['serial'];
                              var fingerprint = response[0]['fingerprint'];
                              var certstart = response[0]['certstart'];
                              var certend = response[0]['certend'];
                              var friendlyname = response[0]['friendly_name'];
                  
                              document.getElementById('certificateno_'+index).value = certificate_no;
                              document.getElementById('type_'+index).value = type;
                              document.getElementById('subject_'+index).value = subject;
                              document.getElementById('issuer_'+index).value = issuer;
                              document.getElementById('serial_'+index).value = serial;
                              document.getElementById('fingerprint_'+index).value = fingerprint;
                              document.getElementById('certstart_'+index).value = certstart;
                              document.getElementById('certend_'+index).value = certend;
                              document.getElementById('friendlyname_'+index).value = friendlyname;
             
                        
                              
                          }
                          
                      }
                  });

                  return false;
              }
          });
      });
      
      

  });

</script>




</html>