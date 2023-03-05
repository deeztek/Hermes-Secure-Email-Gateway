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
  <title>Hermes SEG | System Updates</title>

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
<h1 class="m-0">System Updates</h1>
<!---
<h2 class="m-0">Group Member: #session.thegroups#</h2>
--->
    </cfoutput>

    </div><!-- /.col -->
    <div class="col-sm-6">
<ol class="breadcrumb float-sm-right">
  <li class="breadcrumb-item"><a href="#">Home</a></li>
  <li class="breadcrumb-item active">System Updates</li>
</ol>
    </div><!-- /.col -->
  </div><!-- /.row -->
</div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
<div class="container-fluid">

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


  
  <cfparam name = "dev_release" default = "2"> 

  <cfif StructKeyExists(form, "dev_release")>
  <cfif form.dev_release is not "">
  <cfset dev_release = form.dev_release>
  
<!--- /CFIF form.dev_release is --->
</cfif>

<!--- /CFIF StructKeyExists(form, "dev_release") --->
</cfif>

<cfoutput>
<cfset url.dev = #dev_release#>
</cfoutput>

<cfinclude template="./inc/check_system_update.cfm" />

   

<!--- ERROR MESSAGES START HERE --->

<cfif #m# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The IP Address you entered is invalid (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The IP Address you are attempting to edit already exists (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You cannot delete the IP that you are accessing the system with while the System Updates is enabled. Please disable the firewall and try the operation again (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "4">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You cannot edit the IP Address that you are accessing the system with while the Console Firewall is enabled. Please disable the firewall and try the operation again (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "5">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You cannot enable the System Updates unless the IP you are accessing the system with is in the allowed IP address list below and <strong>Allow to Hermes Admin</strong> is set to <strong>YES</strong>  (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "6">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The IP Address you are attempting to add already exists (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "7">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The IP Address you are attempting to add is invalid (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "33">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>IP Address Edited successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>

    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
                           
      <div class="text-center">
      <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
      </div>
      </form>

  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "34">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>IP Address Deleted successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>

    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
                           
      <div class="text-center">
      <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
      </div>
      </form>

  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "35">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>The System Updates was Enabled successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect. </cfoutput><br><br>

    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
                           
      <div class="text-center">
      <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
      </div>
      </form>

  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "36">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>The System Updates was Disabled successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect. </cfoutput><br><br>

    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
                           
      <div class="text-center">
      <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
      </div>
      </form>

  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "37">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>The IP Address was added successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect. </cfoutput><br><br>

    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
                           
      <div class="text-center">
      <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
      </div>
      </form>

  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "38">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>System Updates Settings applied successfully.</cfoutput>
  </div>

  <cfset session.m = 0>
  
</cfif>


<!--- ERROR MESSAGES END HERE --->



<div class="card col-sm-8">


<form name="SetDev" method="post">

  <input type="hidden" name="action" value="setdev">

  <div class="col-sm-6">

 

   <div class="form-group">
            <label><strong>Check for DEV Releases</strong></label>
            <div class="alert alert-warning">
         
              <p><i class="icon fas fa-exclamation-triangle"></i>Do Not install DEV Releases Unless Guided by Support</p>
              </div>
              
            <select class="form-control" name="dev_release" style="width: 100%;" id="dev_release">

              <cfif #dev_release# is "2">
               
                <option value="2" selected>NO</option>
                <option value="1">YES</option>

              <cfelseif #dev_release# is "1">

                <option value="1">YES</option>
                <option value="2" selected>NO</option>

              <cfelse>

                <cfset step=0>
                <cfset m="System Updates: dev_release is not 1 or 2">
                <cfinclude template="./inc/error.cfm">
                <cfabort>

              <!--- /CFIF #dev_release# is --->
              </cfif>
             
                </select>   
              
              </div>
    </div>
  
  
  <div class="col-sm-4">
  
  <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  </div>
    
  </form>
  <br>

    <!--- div class="card"  --->  
</div>



<!--- INSTAL UPDATE MODAL HTML STARTS HERE --->

<div class="modal fade" id="installupdate_modal" tabindex="-1" role="dialog" aria-labelledby="InstallUpdateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Install Update </h4>
</div>
  
<div class="modal-body">


  <form name="InstallUpdate" autocomplete="off" method="post">

    <input type="hidden" name="action" value="installupdate">

   
      <p>Do you wish to install the following update?</p>

   

    <cfoutput>
      <div class="form-group">
        <label for="build"><strong>Build No</strong></label>
        <input type="text" class="form-control" name="build" value="" id="build" placeholder="Build No" maxLength="20" readonly="yes">
        <label for="date"><strong>Release Date</strong></label>
        <input type="text" class="form-control" name="released" value="" id="released" placeholder="Release Date" maxLength="20" readonly="yes">
        
        <input type="hidden" class="form-control" name="file" value="" id="file">
      </div>
      </cfoutput>

      <div class="alert alert-warning">
    
        <p><i class="icon fas fa-exclamation-triangle"></i>Please select <strong>YES</strong> from the drop-down below to verify that you have a <strong>System Backup</strong> and have read the <strong>Release Note</strong> for this update and agree that <strong>this update is provided with absolutely no guarantees or warranties of any kind explicitly or implied</strong>. Additionally, you agree that <strong>we are NOT liable for any damage that may occur to your system</strong>, service, cat, dog, car, house etc. <strong>You are installing this update at your own risk.</strong> Furthermore, you understand that this update may introduce breaking changes and additional steps may have to be performed manually after the update installs. Breaking changes and additional steps to be performed will be outlined in the Release Note.</p>
        </div>

        <div class="form-group">
          <!---
          <label><strong>I have a System Backup and have read the Release Note for this update</strong></label>
          --->
        <!---
          <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
        --->
        <select class="form-control" name="pdf_enabled" data-placeholder="pdf_enabled" style="width: 100%">                  
        <option value="2" selected="selected">NO</option>
        <option value="1">YES</option>
        
        </select> 
        </div>

      
        
    <div>&nbsp;</div>

    <input type="submit" value="Install" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  </form>

</div>


<div class="modal-footer">
 
<button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>

</div>
    </div>
  </div>
</div>
<!--- ADD IP MODAL HTML ENDS HERE --->




<!--- ACTIONS START HERE --->

<cfif #action# is "editip">

<!--- VALIDATE IP ADDRESS REGEX --->
<cfset pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">

  <!--- VALIDATE PARAMETERS BELOW --->

  <!--- FORM.IP_ID --->
  <cfif NOT StructKeyExists(form, "ip_id")>

    <cfset step=0>
    <cfset m="Edit Firewall IP: form.ip_id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "ip_id")>

      <cfif #form.ip_id# is "">

        
    <cfset step=0>
    <cfset m="Edit Firewall IP: form.ip_id is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif #form.ip_id# is not "">

      <cfquery name="getipaddress" datasource="hermes">
        select * from firewall where id=<cfqueryparam value = #form.ip_id# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>
        

    <cfif #getipaddress.recordcount# LT 1>

    <cfset step=0>
    <cfset m="Edit Firewall IP: getipaddress.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

  <!--- /CFIF  #getipaddress.recordcount# LT 1 --->
  </cfif>


    <!--- /CFIF   #form.ip_id# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "ip_id") --->
    </cfif>


  <!--- FORM.IP_ADDRESS --->
  
  <cfif NOT StructKeyExists(form, "ip_address")>
  
  <cfset m="Edit Firewall IP: form.ip_address does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <cfelseif StructKeyExists(form, "ip_address")>

<!--- COMPARE FORM.IP_ADDRESS AGAINST IP REGEX PATTERN FROM ABOVE  --->
<cfif REFind(pattern,form.ip_address) GT 0>

<cfquery name="checkipaddress" datasource="hermes">
select id, ip from firewall where ip = '#form.ip_address#' and id <> <cfqueryparam value = #form.ip_id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #checkipaddress.recordcount# GTE 1>

<cfset step=0>
<cfset session.m=2>
  
<cfoutput>
<cflocation url="view_console_firewall.cfm" addtoken="no">
</cfoutput>

<!--- /CFIF #checkipaddress.recordcount# GTE 1 --->
</cfif>

<cfelse>

<cfset step=0>
<cfset session.m=1>
  
<cfoutput>
<cflocation url="view_console_firewall.cfm" addtoken="no">
</cfoutput>

<!--- /CFIF REFind(pattern,form.ip_address) GT 0 --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "ip_address") --->  
</cfif>

<!--- FORM.IP_ADDRESS --->
  

<cfif NOT StructKeyExists(form, "ip_hermesadmin")>
  
  <cfset m="Edit Firewall IP: form.ip_hermesadmin does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "ip_hermesadmin")>

<cfif #form.ip_hermesadmin# is "yes" OR #form.ip_hermesadmin# is "no">

<cfelse>

  <cfset m="Edit Firewall IP: form.hermesadmin is not yes or no">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #form.ip_hermesadmin# is "yes" OR #form.ip_hermesadmin# is "no" --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "ip_hermesadmin") --->  
</cfif>


<cfif NOT StructKeyExists(form, "ip_ciphermailadmin")>
  
  <cfset m="Edit Firewall IP: form.ip_ciphermailadmin does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "ip_ciphermailadmin")>

<cfif #form.ip_ciphermailadmin# is "yes" OR #form.ip_ciphermailadmin# is "no">

<cfelse>

  <cfset m="Edit Firewall IP: form.ciphermailadmin is not yes or no">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #form.ip_ciphermailadmin# is "yes" OR #form.ip_ciphermailadmin# is "no" --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "ip_ciphermailadminadmin") --->  
</cfif>

  <!--- VALIDATE PARAMETERS ABOVE --->

<!--- GET FIREWALL IP --->

<cfquery name="getip" datasource="hermes">
  select ip from firewall
  where id = <cfqueryparam value = #form.ip_id# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

<cfif #getip.recordcount# GTE 1>

<cfset compare_ip = Compare(#getip.ip#, #ClientIP#)>

<cfif #compare_ip# is "1" OR #compare_ip# is "-1">

  <cfquery name="updateipaddress" datasource="hermes">
    update firewall
    set 
    ip = '#trim(form.ip_address)#',
    hermesadmin = '#form.ip_hermesadmin#',
    ciphermailadmin = '#form.ip_ciphermailadmin#',
    note = '#form.ip_note#'
    where id = <cfqueryparam value = #form.ip_id# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>

    
    <cfset session.m = 33>
    <cfoutput>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
    </cfoutput>

  <cfelse>

<cfif #dev_release# is "enabled">

    <cfset session.m = 4>
    <cfoutput>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
    </cfoutput>

  <cfelse>

    <cfquery name="updateipaddress" datasource="hermes">
      update firewall
      set 
      ip = '#trim(form.ip_address)#',
      hermesadmin = '#form.ip_hermesadmin#',
      ciphermailadmin = '#form.ip_ciphermailadmin#',
      note = '#form.ip_note#'
      where id = <cfqueryparam value = #form.ip_id# CFSQLType = "CF_SQL_INTEGER">
      </cfquery>
      
      <cfset session.m = 33>
      <cfoutput>
      <cflocation url="view_console_firewall.cfm" addtoken="no">
      </cfoutput>
      
<!--- /CFIF #dev_release# is --->
  </cfif>

<!--- /CFIF #compare_ip# is "1" or #compare_ip# is "-1" --->
  </cfif>

<!--- /CFIF #getip.recordcount# GTE 1 --->
</cfif>


<cfelseif #action# is "addip">

<!--- VALIDATE IP ADDRESS REGEX --->
<cfset pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">

  <!--- VALIDATE PARAMETERS BELOW --->

<!--- FORM.IP_ADDRESS --->
  
  <cfif NOT StructKeyExists(form, "ip_address")>
  
  <cfset m="Add Firewall IP: form.ip_address does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <cfelseif StructKeyExists(form, "ip_address")>

<!--- COMPARE FORM.IP_ADDRESS AGAINST IP REGEX PATTERN FROM ABOVE  --->
<cfif REFind(pattern,form.ip_address) GT 0>

<cfquery name="checkipaddress" datasource="hermes">
select ip from firewall where ip = '#form.ip_address#'
</cfquery>

<cfif #checkipaddress.recordcount# GTE 1>

<cfset step=0>
<cfset session.m=6>
  
<cfoutput>
<cflocation url="view_console_firewall.cfm" addtoken="no">
</cfoutput>

<!--- /CFIF #checkipaddress.recordcount# GTE 1 --->
</cfif>

<cfelse>

<cfset step=0>
<cfset session.m=7>
  
<cfoutput>
<cflocation url="view_console_firewall.cfm" addtoken="no">
</cfoutput>

<!--- /CFIF REFind(pattern,form.ip_address) GT 0 --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "ip_address") --->  
</cfif>

<!--- FORM.IP_ADDRESS --->
  

<cfif NOT StructKeyExists(form, "ip_hermesadmin")>
  
  <cfset m="Add Firewall IP: form.ip_hermesadmin does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "ip_hermesadmin")>

<cfif #form.ip_hermesadmin# is "yes" OR #form.ip_hermesadmin# is "no">

<cfelse>

  <cfset m="Add Firewall IP: form.hermesadmin is not yes or no">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #form.ip_hermesadmin# is "yes" OR #form.ip_hermesadmin# is "no" --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "ip_hermesadmin") --->  
</cfif>


<cfif NOT StructKeyExists(form, "ip_ciphermailadmin")>
  
  <cfset m="Add Firewall IP: form.ip_ciphermailadmin does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "ip_ciphermailadmin")>

<cfif #form.ip_ciphermailadmin# is "yes" OR #form.ip_ciphermailadmin# is "no">

<cfelse>

  <cfset m="Add Firewall IP: form.ciphermailadmin is not yes or no">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #form.ip_ciphermailadmin# is "yes" OR #form.ip_ciphermailadmin# is "no" --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "ip_ciphermailadminadmin") --->  
</cfif>

  <!--- VALIDATE PARAMETERS ABOVE --->


    <cfquery name="insertipaddress" datasource="hermes">
     insert into firewall
     (ip, hermesadmin, ciphermailadmin, note)
     values
     ('#form.ip_address#', '#form.ip_hermesadmin#', '#form.ip_ciphermailadmin#', '#form.ip_note#')
      </cfquery>
      
      <cfset session.m = 37>
      <cfoutput>
      <cflocation url="view_console_firewall.cfm" addtoken="no">
      </cfoutput>

<cfelseif #action# is "deleteip">

   <!--- FORM.IP_ID --->
   <cfif NOT StructKeyExists(form, "ip_id")>

    <cfset step=0>
    <cfset m="Delete Firewall IP: form.ip_id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "ip_id")>

      <cfif #form.ip_id# is "">

        
    <cfset step=0>
    <cfset m="Delete Firewall IP: form.ip_id is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif #form.ip_id# is not "">

      <cfquery name="getipaddress" datasource="hermes">
        select * from firewall where id=<cfqueryparam value = #form.ip_id# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>
        

    <cfif #getipaddress.recordcount# LT 1>

    <cfset step=0>
    <cfset m="Delete Firewall IP: getipaddress.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

  <!--- /CFIF  #getipaddress.recordcount# LT 1 --->
  </cfif>


    <!--- /CFIF   #form.ip_id# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "ip_id") --->
    </cfif>

<!--- GET FIREWALL IP --->

<cfquery name="getip" datasource="hermes">
  select ip from firewall
  where id = <cfqueryparam value = #form.ip_id# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>

<cfif #getip.recordcount# GTE 1>

<cfset compare_ip = Compare(#getip.ip#, #ClientIP#)>

<cfif #compare_ip# is "1" OR #compare_ip# is "-1">

    <cfquery name="deleteip" datasource="hermes">
    delete from firewall
    where id = <cfqueryparam value = #form.ip_id# CFSQLType = "CF_SQL_INTEGER">
    </cfquery>
    
    <cfset session.m = 34>
    <cfoutput>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
    </cfoutput>

  <cfelse>

  <cfif #dev_release# is "enabled">

    <cfset session.m = 3>
    <cfoutput>
    <cflocation url="view_console_firewall.cfm" addtoken="no">
    </cfoutput>

  <cfelse>

    <cfquery name="deleteip" datasource="hermes">
      delete from firewall
      where id = <cfqueryparam value = #form.ip_id# CFSQLType = "CF_SQL_INTEGER">
      </cfquery>
      
      <cfset session.m = 34>
      <cfoutput>
      <cflocation url="view_console_firewall.cfm" addtoken="no">
      </cfoutput>   

  <!--- /CFIF #dev_release# is --->
  </cfif>

<!--- /CFIF #compare_ip# is "1" or #compare_ip# is "-1" --->
  </cfif>

<!--- /CFIF #getip.recordcount# GTE 1 --->
</cfif>

<cfelseif #action# is "setfirewall">

  <!--- VALIDATE PARAMETERS BELOW --->


<cfif NOT StructKeyExists(form, "dev_release")>
  
  <cfset m="Set System Updates: form.dev_release does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "dev_release")>

<cfif #form.dev_release# is "enabled" OR #form.dev_release# is "disabled">

<cfelse>

  <cfset m="Set System Updates: form.dev_release is not enabled or disabled">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #form.dev_release# is "enabled" OR #form.dev_release# is "disabled" --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "dev_release") --->  
</cfif>


  <!--- VALIDATE PARAMETERS ABOVE --->

<cfif #form.dev_release# is "enabled">

<cfquery name="checkcurrent" datasource="hermes">
select ip from firewall where ip='#ClientIP#' and hermesadmin = 'yes'
</cfquery>

<cfif #checkcurrent.recordcount# LT 1>

<cfset step=0>
<cfset session.m=5>
  
<cfoutput>
<cflocation url="view_console_firewall.cfm" addtoken="no">
</cfoutput>

<cfelse>

<cfquery name="updatestatus" datasource="hermes">
update parameters2 set value2='#form.dev_release#' where parameter='dev_release' and module='firewall' and active='1'
</cfquery>

<cfset step=0>
<cfset session.m=35>
  
<cfoutput>
<cflocation url="view_console_firewall.cfm" addtoken="no">
</cfoutput>

<!--- /CFIF checkcurrent.recordcount --->
</cfif>

<cfelseif #form.dev_release# is "disabled">

<cfquery name="updatestatus" datasource="hermes">
update parameters2 set value2='#form.dev_release#' where parameter='dev_release' and module='firewall' and active='1'
</cfquery>

<cfset step=0>
<cfset session.m=36>
  
<cfoutput>
<cflocation url="view_console_firewall.cfm" addtoken="no">
</cfoutput>

<!--- /CFIF #form.dev_release# is  --->
</cfif>
 

<cfelseif #action# is "apply">

<!--- Generate Nginx Configuration --->
<cfinclude template="./inc/generate_nginx_configuration.cfm">

<cfset step=0>
<cfset session.m=38>
  
<cfoutput>
<cflocation url="view_console_firewall.cfm" addtoken="no">
</cfoutput>



 <!--- /CFIF FOR ACTION ---> 
</cfif>

  <!--- ACTIONS END HERE --->


  <div class="alert alert-warning">
    
    <p><i class="icon fas fa-exclamation-triangle"></i>Please note that system updates are NOT cumulative. The system will only show one update at a time to be installed. You must install each update in the order the system presents them until all updates have been installed and your system is up-to-date.</p>
    </div>


<cfif #status# contains 'SUCCESS'>
      
    <cfset build = "#trim(ListGetAt(cfhttp.FileContent, 3, "#chr(64)#"))#">
    <cfset released = "#trim(ListGetAt(cfhttp.FileContent, 4, "#chr(64)#"))#">
    <cfset filename = "#trim(ListGetAt(cfhttp.FileContent, 5, "#chr(64)#"))#">
    <cfset releasenote = "#trim(ListGetAt(cfhttp.FileContent, 6, "#chr(64)#"))#">
    <cfset releasenotefile = "#trim(ListGetAt(cfhttp.FileContent, 7, "#chr(64)#"))#">
    <cfset mysqlroot = "#trim(ListGetAt(cfhttp.FileContent, 8, "#chr(64)#"))#">
    <cfset dev = "#trim(ListGetAt(cfhttp.FileContent, 9, "#chr(64)#"))#">
    <cfset remoteexpiration = "#trim(ListGetAt(cfhttp.FileContent, 10, "#chr(64)#"))#">
        
<table class="table table-striped"  style="width:100%">
  <thead>
    <tr>
      <th>Install</th>    
      <th>Release Note</th>
      <th>Build No</th>
      <th>Release Date</th>

      <th>MySQL Root</th>
      <th>DEV Release</th>

    </tr>
  </thead>
  <tbody>

   


  
  <cfoutput>
   
    
    <tr>

      <cfif #mysqlroot# is "1">

        <td>

          <button a href="##installupdatedev_modal"  type="button" id="install" class="btn btn-secondary" data-toggle="modal" data-file="hermes-#build#.tar.cfm"><i class="fas fa-download"></i></button>
  
        </td>

      <cfelse>

      <td>

        <button a href="##installupdate_modal"  type="button" id="install" class="btn btn-secondary" data-toggle="modal" data-file="hermes-#build#.tar.cfm" data-build="#build#" data-released="#released#"><i class="fas fa-download"></i></button>

      </td>

<!--- /CFIF #mysqlroot# is --->
    </cfif>

      <td>


        <button onClick="window.open('https://updates.deeztek.com/downloads/hermes-#build#-release.txt');" type="button" id="delete" class="btn btn-secondary" data-toggle="modal" data-ip="" data-address="" data-note="" data-hermesadmin="" data-ciphermailadmin=""><i class="fas fa-search"></i></button>
        
        
        </td>



<td>#build#</td>

<td>
#released#
</td>



<cfif #mysqlroot# is "1">
<td>YES</td>

<cfelse>
  <td>NO</td>

  <!--- /CFIF #mysqlroot# is --->
</cfif>


<cfif #dev# is "1">
  <td>YES</td>
  
  <cfelse>
    <td>NO</td>
  
    <!--- /CFIF #dev# is --->
  </cfif>

    </cfoutput>



  </tr>



  </tbody>
  
  <tfoot>
    <tr>
    
      <th>Install</th>   
      <th>Release Note</th> 
      <th>Build No</th>
      <th>Release Date</th>

      <th>MySQL Root</th>
      <th>DEV Release</th>

    </tr>
  </tfoot>
 
</table>
    
    
<cfelseif #status# contains 'Connection'>
      
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem attempting to reach the update server. Specific error was: #cfhttp.statuscode#<br>Hermes SEG must have access to the URL <strong>updates.deeztek.com</strong> over ports 80 and 443 <strong>without SSL interception</strong> in order to check for updates.</strong></cfoutput>
  </div>
  
  <cfelseif #status# contains 'INVALID'>

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>Unable to check updates. Your license is invalid.</strong></cfoutput>
    </div>
  
  
  <cfelseif #status# contains 'NOUPDATE'>




    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      <cfoutput>Your system is on the latest version. </cfoutput><br> 
    </div>

<cfelseif #status# contains 'INVALIDREQUEST'>

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem fetching updates.</strong></cfoutput>
  </div>

  <cfset hermesupdate = "INVALID REQUEST">

<cfelseif #status# contains 'EXPIRED'>

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Unable to check updates. Your license has expired.</strong></cfoutput>
  </div>



<!--- /CFIF #status# --->
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
  $('#installupdate_modal').on('show.bs.modal', function(e) {
var file = $(e.relatedTarget).data('file');
$(e.currentTarget).find('input[name="file"]').val(file);

var build = $(e.relatedTarget).data('build');
$(e.currentTarget).find('input[name="build"]').val(build);

var released = $(e.relatedTarget).data('released');
$(e.currentTarget).find('input[name="released"]').val(released);


  });


    </script>

<!--- EDIT IP MODAL SCRIPT ENDS HERE  --->

<!--- DELETE IP MODAL SCRIPT STARTS HERE  --->
<script>
  $('#delete_modal').on('show.bs.modal', function(e) {
var ip_id = $(e.relatedTarget).data('ip');
$(e.currentTarget).find('input[name="ip_id"]').val(ip_id);
  });
    </script>

<!--- DELETE IP MODAL SCRIPT ENDS HERE  --->



</html>