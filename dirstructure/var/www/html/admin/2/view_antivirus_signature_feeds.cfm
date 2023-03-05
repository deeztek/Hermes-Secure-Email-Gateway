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
  <title>Hermes SEG | Antivirus Signature Feeds</title>

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
<h1 class="m-0">Antivirus Signature Feeds</h1>
<!---
<h2 class="m-0">Group Member: #session.thegroups#</h2>
--->
    </cfoutput>

    </div><!-- /.col -->
    <div class="col-sm-6">
<ol class="breadcrumb float-sm-right">
  <li class="breadcrumb-item"><a href="#">Home</a></li>
  <li class="breadcrumb-item active">Antivirus Signature Feeds</li>
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

<cfquery name="checkstatus" datasource="hermes">
select value2 from parameters2 where parameter='firewall_status' and module='firewall' and active='1'
</cfquery>
  
  <cfparam name = "firewall_status" default = "#checkstatus.value2#"> 
  <cfif StructKeyExists(form, "firewall_status")>
  <cfif form.firewall_status is not "">
  <cfset firewall_status = form.firewall_status>
  
<!--- /CFIF form.firewall_status is --->
</cfif>

<!--- StructKeyExists(form, "firewall_status") --->
  </cfif>


<cfquery name="getsignaturefeeds" datasource="hermes">
select id, name, enabled, update_int, description from malware_feeds
</cfquery>

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
    <cfoutput>You cannot delete the IP that you are accessing the system with while the Antivirus Signature Feeds is enabled. Please disable the firewall and try the operation again (Error Code: #m#)</cfoutput>
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
    <cfoutput>You cannot enable the Antivirus Signature Feeds unless the IP you are accessing the system with is in the allowed IP address list below and <strong>Allow to Hermes Admin</strong> is set to <strong>YES</strong>  (Error Code: #m#)</cfoutput>
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
    <cfoutput>The Antivirus Signature Feeds was Enabled successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect. </cfoutput><br><br>

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
    <cfoutput>The Antivirus Signature Feeds was Disabled successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect. </cfoutput><br><br>

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
    <cfoutput>Antivirus Signature Feeds Settings applied successfully.</cfoutput>
  </div>

  <cfset session.m = 0>
  
</cfif>


<!--- ERROR MESSAGES END HERE --->



<span>
  <p> 


<!--- ADD IP BUTTON STARTS HERE --->
<cfoutput>
<a href="##addip_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="" data-recipientemail=""><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add IP Address</a>
</cfoutput>
<!--- ADD IP BUTTON ENDS HERE --->

</p>


</span>





<!--- ADD IP MODAL HTML STARTS HERE --->

<div class="modal fade" id="addip_modal" tabindex="-1" role="dialog" aria-labelledby="AddIpModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Add IP Address </h4>
</div>
  
<div class="modal-body">
  <!---
  <p>Are you sure you send to delete this Certificate? This action is irreversible! </p>
  --->

  <form name="AddIpAddress" autocomplete="off" method="post">

    <input type="hidden" name="action" value="addip">

    <cfoutput>
      <div class="form-group">
        <label for="username"><strong>IP Address</strong></label>
        <input type="text" class="form-control" name="ip_address" value="" id="ip_address" placeholder="IP Address" maxLength="20">
      </div>
      </cfoutput>

      
        <div class="form-group">
          <label><strong>Allow to Hermes Admin</strong></label>
            
          <select class="form-control" name="ip_hermesadmin" data-placeholder="hermesadmin" style="width: 100%;" id="hermesadmin">
             
              <option value="yes" selected>YES</option>
              <option value="no">NO</option>
           
              </select>   
            
            </div>

                  
        <div class="form-group">
          <label><strong>Allow to Ciphermail Admin</strong></label>
            
          <select class="form-control" name="ip_ciphermailadmin" data-placeholder="ciphermailadmin" style="width: 100%;"  id="ciphermailadmin">
             
              <option value="yes" selected>YES</option>
              <option value="no">NO</option>
           
              </select>   
            
            </div>
            

            <cfoutput>
              <div class="form-group">
                <label><strong>Note</strong></label>
                <input type="text" class="form-control" name="ip_note" value="" id="ip_note" placeholder="Enter Note" maxLength="255">
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
<!--- ADD IP MODAL HTML ENDS HERE --->



<!--- DELETE IP MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteCertificateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Delete IP Address </h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you send to delete this IP Address from the Antivirus Signature Feeds? This action is irreversible! </p>

</div>
<div class="modal-footer">
  <form name="DeleteIpAddress" method="post">

    <input type="hidden" name="action" value="deleteip">
    <input type="hidden" name="ip_id" value=""/>
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- DELETE IP MODAL HTML ENDS HERE --->


<!--- EDIT IP MODAL HTML STARTS HERE --->

<div class="modal fade" id="editip_modal" tabindex="-1" role="dialog" aria-labelledby="editIpModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Edit IP Address </h4>
</div>
  
<div class="modal-body">
  <!---
  <p>Are you sure you send to delete this Certificate? This action is irreversible! </p>
  --->

  <form name="EditIpAddress" autocomplete="off" method="post">

    <input type="hidden" name="action" value="editip">
    <input type="hidden" name="ip_id" value=""/>

    <cfoutput>
      <div class="form-group">
        <label for="username"><strong>IP Address</strong></label>
        <input type="text" class="form-control" name="ip_address" value="" id="ip_address" placeholder="IP Address" maxLength="20">
      </div>
      </cfoutput>

      
        <div class="form-group">
          <label><strong>Allow to Hermes Admin</strong></label>
            
          <select class="form-control" name="ip_hermesadmin" data-placeholder="hermesadmin" style="width: 100%;" id="hermesadmin">
             
              <option value="yes" selected>YES</option>
              <option value="no">NO</option>
           
              </select>   
            
            </div>

                  
        <div class="form-group">
          <label><strong>Allow to Ciphermail Admin</strong></label>
            
          <select class="form-control" name="ip_ciphermailadmin" data-placeholder="ciphermailadmin" style="width: 100%;"  id="ciphermailadmin">
             
              <option value="yes" selected>YES</option>
              <option value="no">NO</option>
           
              </select>   
            
            </div>
            

            <cfoutput>
              <div class="form-group">
                <label><strong>Note</strong></label>
                <input type="text" class="form-control" name="ip_note" value="" id="ip_note" placeholder="Enter Note" maxLength="255">
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
<!--- EDIT IP MODAL HTML ENDS HERE --->

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

<cfif #firewall_status# is "enabled">

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
      
<!--- /CFIF #firewall_status# is --->
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

  <cfif #firewall_status# is "enabled">

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

  <!--- /CFIF #firewall_status# is --->
  </cfif>

<!--- /CFIF #compare_ip# is "1" or #compare_ip# is "-1" --->
  </cfif>

<!--- /CFIF #getip.recordcount# GTE 1 --->
</cfif>

<cfelseif #action# is "setfirewall">

  <!--- VALIDATE PARAMETERS BELOW --->


<cfif NOT StructKeyExists(form, "firewall_status")>
  
  <cfset m="Set Antivirus Signature Feeds: form.firewall_status does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "firewall_status")>

<cfif #form.firewall_status# is "enabled" OR #form.firewall_status# is "disabled">

<cfelse>

  <cfset m="Set Antivirus Signature Feeds: form.firewall_status is not enabled or disabled">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF #form.firewall_status# is "enabled" OR #form.firewall_status# is "disabled" --->  
</cfif>

<!--- /CFIF StructKeyExists(form, "firewall_status") --->  
</cfif>


  <!--- VALIDATE PARAMETERS ABOVE --->

<cfif #form.firewall_status# is "enabled">

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
update parameters2 set value2='#form.firewall_status#' where parameter='firewall_status' and module='firewall' and active='1'
</cfquery>

<cfset step=0>
<cfset session.m=35>
  
<cfoutput>
<cflocation url="view_console_firewall.cfm" addtoken="no">
</cfoutput>

<!--- /CFIF checkcurrent.recordcount --->
</cfif>

<cfelseif #form.firewall_status# is "disabled">

<cfquery name="updatestatus" datasource="hermes">
update parameters2 set value2='#form.firewall_status#' where parameter='firewall_status' and module='firewall' and active='1'
</cfquery>

<cfset step=0>
<cfset session.m=36>
  
<cfoutput>
<cflocation url="view_console_firewall.cfm" addtoken="no">
</cfoutput>

<!--- /CFIF #form.firewall_status# is  --->
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





<cfif #getsignaturefeeds.recordcount# GTE 1>
        
<table class="table table-striped"  id="sortTable" style="width:100%">
  <thead>
    <tr>
      <th>Edit</th>    
      <th>Delete</th>
      <th>Name</th>
      <th>Description</th>
      <th>Status</th>
      <th>Update Interval</th>

    </tr>
  </thead>
  <tbody>

   
<cfloop query="getsignaturefeeds">

  
  <cfoutput>
   
    
    <tr>


      <td><a href="edit_antivirus_signature_feed.cfm?id=#id#" class="btn btn-secondary" role="button"><i class="fas fa-edit"></i></a></td>

      <td>

        <button a href="##delete_modal"  type="button" id="delete" class="btn btn-danger" data-toggle="modal" data-ip="#id#"><i class="fas fa-trash-alt"></i></button>

      </td>





<td>#name#</td>
<td>#description#</td>
<td>
<cfif #enabled# is "yes">
ENABLED
<cfelse>
DISABLED
</cfif>

</td>

<cfquery name="getcrontabentry" datasource="hermes">
  select value, label from crontab_entries where value = '#update_int#'
  </cfquery>
  
  <cfif #getcrontabentry.recordcount# GTE 1>
  <td>#getcrontabentry.label#</td> 
  <cfelse>
    <td>N/A</td> 

  <!--- /CFIF FOR getcrontabentry.recordcount --->
  </cfif>






    </cfoutput>



  </tr>


  </cfloop>
  </tbody>
  
  <tfoot>
    <tr>
    
      <th>Edit</th>    
      <th>Delete</th>
      <th>Name</th>
      <th>Description</th>
      <th>Status</th>
      <th>Update Interval</th>

    </tr>
  </tfoot>
 
</table>
    
    
    <cfelseif #getsignaturefeeds.recordcount# LT 1>
    
<div class="alert alert-danger alert-dismissible">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-ban"></i> Oops!</h4>
  <cfoutput>No Antivirus Signature Feeds IPs were found</strong></cfoutput>
</div>
    
<!--- /CFIF FOR getsignaturefeeds.recordcount --->
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
  $('#editip_modal').on('show.bs.modal', function(e) {
var ip_id = $(e.relatedTarget).data('ip');
$(e.currentTarget).find('input[name="ip_id"]').val(ip_id);

var ip_address = $(e.relatedTarget).data('address');
$(e.currentTarget).find('input[name="ip_address"]').val(ip_address);

var ip_note = $(e.relatedTarget).data('note');
$(e.currentTarget).find('input[name="ip_note"]').val(ip_note);

var ip_hermesadmin = $(e.relatedTarget).data('hermesadmin');
$(e.currentTarget).find('input[name="ip_hermesadmin"]').val(ip_hermesadmin);

var ip_ciphermailadmin = $(e.relatedTarget).data('ciphermailadmin');
$(e.currentTarget).find('input[name="ip_ciphermailadmin"]').val(ip_ciphermailadmin);

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