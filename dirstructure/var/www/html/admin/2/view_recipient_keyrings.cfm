<!DOCTYPE html>

<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Recipient Keyrings</title>

  <cfinclude template="./inc/html_head.cfm" />


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
        "order": [[ 8, "asc" ]]
    } );
} );
  </script>

<!--- SCRIPT TO SHOW/HIDE PASSWORD ON CREATE KEYRING MODAL --->
  <script>

$(document).ready(function() {
    $("#keyringpassword a").on('click', function(event) {
        event.preventDefault();
        if($('#keyringpassword input').attr("type") == "text"){
            $('#keyringpassword input').attr('type', 'password');
            $('#keyringpassword i').addClass( "fa-eye-slash" );
            $('#keyringpassword i').removeClass( "fa-eye" );
        }else if($('#keyringpassword input').attr("type") == "password"){
            $('#keyringpassword input').attr('type', 'text');
            $('#keyringpassword i').removeClass( "fa-eye-slash" );
            $('#keyringpassword i').addClass( "fa-eye" );
        }
    });
});

  </script>

  
<!--- SCRIPT TO SHOW/HIDE PASSWORD ON IMPORT KEYRING MODAL--->
<script>

  $(document).ready(function() {
      $("#importkeyringpassword a").on('click', function(event) {
          event.preventDefault();
          if($('#importkeyringpassword input').attr("type") == "text"){
              $('#importkeyringpassword input').attr('type', 'password');
              $('#importkeyringpassword i').addClass( "fa-eye-slash" );
              $('#importkeyringpassword i').removeClass( "fa-eye" );
          }else if($('#importkeyringpassword input').attr("type") == "password"){
              $('#importkeyringpassword input').attr('type', 'text');
              $('#importkeyringpassword i').removeClass( "fa-eye-slash" );
              $('#importkeyringpassword i').addClass( "fa-eye" );
          }
      });
  });
  
    </script>

<!--- SCRIPT TO SHOW/HIDE PASSWORD ON VIEW KEYRING MODAL--->
<script>

  $(document).ready(function() {
      $("#viewkeyringpassword a").on('click', function(event) {
          event.preventDefault();
          if($('#viewkeyringpassword input').attr("type") == "text"){
              $('#viewkeyringpassword input').attr('type', 'password');
              $('#viewkeyringpassword i').addClass( "fa-eye-slash" );
              $('#viewkeyringpassword i').removeClass( "fa-eye" );
          }else if($('#viewkeyringpassword input').attr("type") == "password"){
              $('#viewkeyringpassword input').attr('type', 'text');
              $('#viewkeyringpassword i').removeClass( "fa-eye-slash" );
              $('#viewkeyringpassword i').addClass( "fa-eye" );
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
            <h1 class="m-0">Recipient Keyrings</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Recipient Keyrings</li>
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

<cfset m="Recipient Keyrings: url.id does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>
  
<cfelseif StructKeyExists(url, "id")>

<cfif NOT IsValid("integer", #url.id#)>

<cfset m="Recipient Keyrings: url.id not valid integer">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- <cfif NOT IsValid("integer", #url.id#)> --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(url, "id") --->
</cfif>


<cfif NOT StructKeyExists(url, "type")>

<cfset m="Recipient Keyrings: url.type does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelseif StructKeyExists(url, "type")>

<cfif #url.type# is "1">

<cfquery name="getrecipientdetails" datasource="hermes">
select id, recipient from recipients where 
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getrecipientdetails.recordcount# LT 1>

<cfset m="Recipient Keyrings: getrecipinetdetails.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelseif #getrecipientdetails.recordcount# GTE 1>

  <cfquery name="getkeyrings" datasource="hermes">
  select * from recipient_keystores where user_id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER"> and master = '1'
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

<cfset m="Recipient Keyrings: getrecipinetdetails.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelseif #getrecipientdetails.recordcount# GTE 1>

<cfquery name="getkeyrings" datasource="hermes">
select * from recipient_keystores where user_id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER"> and master = '1'
</cfquery>

<cfset theRecipient = #url.id#>
  
<!--- /CFIF #getrecipientdetails.recordcount# --->
</cfif>

<cfelse>

<cfset m="Recipient Keyrings: url.type is not 1 or 2">
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
    <cfoutput>The Private Key Password cannot be blank (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The PGP Secret Key Password must be at least 10 characters (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "3">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Keyring was created successfully</cfoutput><br>

  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "4">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The PGP Key file you selected was not accepted (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "5">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must select a valid PGP Key file to import (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "6">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must select a valid PGP Key file to import (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "7">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Keyring was imported successfully</cfoutput><br>

  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "8">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error importing the PGP key you specified. This usually occurs because of any of the following reasons:<br>
You are attempting to import an invalid file<br> 
You are attempting to import a Private key when you have Public selected in the PGP Key Type field<br>
You are attempting to import a Public Key when you have Private selected in the PGP Key Type field. (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "9">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The PGP Key File was not successfully imported. A system error has occured. No valid file was found for import(Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "10">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The PGP Key File you are attempting to import is not for this recipient (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>


</cfif>

<cfif #m# is "11">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>the PGP Key File was not successfully imported. PGPException: checksum mismatch. The Private Key Password you supplied is most likely incorrect (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "12">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The PGP Key you are attempting to import already exists in the system (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "13">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The PGP Key File was not successfully imported. You have entered an incorrect password (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "14">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The PGP Key File was not successfully imported (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>
  
</cfif>

<cfif #m# is "15">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Keyring was deleted successfully</cfoutput><br>

    <cfset session.m = 0>

  </div>
</cfif>

<cfif #m# is "16">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem fetching the key ID (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>



<cfif #m# is "17">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem fetching the public keyring (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "18">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem fetching the private keyring (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "19">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was a problem getting recipient info while trying to delete (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "20">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>You must select at least one Key Server to publish the Public Key (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "21">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Public PGP key was published successfully</cfoutput><br>

    <cfset session.m = 0>

  </div>
</cfif>

<cfif #m# is "22">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error publishing the Public PGP Key Ring. Invalid Key Server (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "23">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error publishing the Public PGP Key Ring. Invalid Key Server  (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "24">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error publishing the Public PGP Key Ring. Invalid Key (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "25">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>There was an error publishing the Public PGP Key Ring. Invalid Key (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "26">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Recipient Real Name cannot be blank (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "27">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The The Key ID already exists (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "28">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Key ID already exists (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<!--- ERROR MESSAGES END HERE --->
    
<span>
  <p>       

    <a href="view_internal_recipients.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Recipients</a>

    &nbsp;&nbsp;

    <!-- CREATE KEYRING BUTTON -->
<cfoutput>
<a href="##create_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="#theRecipient#" data-recipientemail="#getrecipientdetails.recipient#"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Create Keyring</a>
</cfoutput>

&nbsp;&nbsp;

<!--- CREATE KEYRING BUTTON ENDS HERE --->

    <!-- IMPORT KEYRING BUTTON -->
    <cfoutput>
    <a href="##import_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="#theRecipient#" data-recipientemail="#getrecipientdetails.recipient#"><i class="fa fa-upload fa-lg"></i>&nbsp;&nbsp;Import Keyring</a>
  </cfoutput>
  
  
  <!--- IMPORT KEYRING BUTTON ENDS HERE --->


</p>


</span>


<!--- VIEW KEYRING PASSWORD MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="viewpassword_modal" tabindex="-1" role="dialog" aria-labelledby="viewPasswordModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">View Keyring Password </h4>
      </div>
        
      <div class="modal-body">
        <p>It is HIGHLY recommended that you do not relay  the password via any communications medium including telephone, SMS or unencrypted e-mail. All those mediums are considered unsecure.</p>

   
<form>
<!--- KEYRING PASSWORD STARTS HERE --->
           
<div class="form-group" id="viewkeyringpassword">
  <label><strong>Keyring Password</strong></label>


<div class="input-group">
<input type="password" name="password" value="" class="form-control" maxlength="64">

<a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
</div>

</div>

<!--- KEYRING PASSWORD PASSWORD ENDS HERE --->

</form>

            



      </div>
      <div class="modal-footer">
 
        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<!--- VIEW KEYRING PASSWORD MODAL ENDS HERE --->


<!--- DELETE KEYRING MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteCertificateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Delete keyring </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you send to delete this Keyring? This action is irreversible! If you delete the last keyring for a PGP enabled recipient, PGP encryption will no longer work until you generate or import another keyring for this recipient. </p>

      </div>
      <div class="modal-footer">
        <form name="DeleteKeyring" method="post">

          <input type="hidden" name="action" value="deletekeyring">
          <input type="hidden" name="keyring_id" value=""/>
          <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
          
            </form>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>
<!--- DELETE KEYRING MODAL HTML ENDS HERE --->

<!--- PUBLISH KEYRING MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="publish_modal" tabindex="-1" role="dialog" aria-labelledby="PublishKeyringModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Publish PGP Public Key </h4>
      </div>
        
      <div class="modal-body">

        <p>The system will publish the PGP Public Key indicated below to any PGP Key Servers you select. By default, the system automatically selects all the PGP Key Servers in the inventory. If you wish to only publish to selected servers, select only the servers you wish to publish to below and click the Publish Key button. </p>

        <form name="PublishKeyring" method="post">

          <input type="hidden" name="action" value="publishkeyring">
          <input type="hidden" name="keyring_id" value=""/>
          <div class="form-group">
            <label>Recipient</label>
          <input type="text" name="recipient" value="" class="form-control" readonly>
        </div>
        <div class="form-group">
          <label>PGP Key-ID</label>
          <input type="text" name="keyid" value="" class="form-control" readonly>
        </div>

          <cfquery name="getkeyservers" datasource="hermes">
            select * from pgp_keyservers order by keyserver asc
            </cfquery>

<cfif #getkeyservers.recordcount# GTE 1>

          <table class="table table-striped" style="width:100%">
            <thead>
              <tr>
                
                <th>Select</th>
                <th>Key Server</th>
                <th>Description</th>
              </tr>
            </thead>

            <tbody>
      <cfoutput query="getkeyservers">
        <tr>
      
            <td><input type="checkbox" name="keyserver_id" value="#id#" checked></td>
            <td>#keyserver#</td>
            <td>#note#</td>
    
          </tr>
          </cfoutput>

    
    </tbody>
            
           

          
    
          </table>

          <!--- /CFIF #getkeyservers.recordcount# --->
        </cfif>

        <div>&nbsp;</div>
     

          <input type="submit" value="Publish" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
          
            </form>

      </div>

      <div class="modal-footer">

        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
<!--- PUBLISH KEYRING MODAL HTML ENDS HERE --->




<!--- CREATE KEYRING MODAL HTML STARTS HERE --->
   


<div class="modal fade" id="create_modal" tabindex="-1" role="dialog" aria-labelledby="createKeyringModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Create Keyring </h4>
      </div>
        
      <div class="modal-body">
 

        <form name="create_keyring" method="post" action="" data-toggle="validator">
    
          <input type="hidden" name="action" value="createkeyring">
          <input type="hidden" name="recipient_id" value="">

          <div class="form-group">
            <label>Recipient</label>
          <input type="text" name="recipient_email" value="" class="form-control" readonly>
        </div>

        <div class="form-group">
          <label>Recipient Real Name</label>
          <input type="text" name="realname" value="" class="form-control" required>
        </div>

       
            
  
  
   <!--- PGP KEYRING SIZE STARTS HERE  --->
  
   
   <div class="form-group">
    <label>PGP Keyring Size</label>
  <!---
    <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
  --->
  <select class="form-control" name="encryption" data-placeholder="encryption" id="encryption" style="width: 100%">                  
  <option value="4096" selected="selected">4096-bits (High Security)</option>
  <option value="2048">2048-bits (Medium Security)</option>

  </select> 
  </div>

    <!--- PGP KEYRING SIZE STARTS HERE  --->
  
  
    <!--- AUTO-GENERATE PASSWORD STARTS HERE --->

            <div class="form-group">
              <label>Auto-Generate PGP Secret Key Password</label> 
    <select class="form-control select2" id="autopass" name="autopass" data-placeholder="autopass" style="width: 100%">                  
    <option value="yes" selected="selected">YES</option>
    <option value="no">NO</option>
     </select> 
    </div>

      <!--- AUTO-GENERATE PASSWORD STARTS HERE --->
  
<!--- PRIVATE KEY PASSWORD STARTS HERE --->
           
      <div class="form-group" id="keyringpassword" style="display:none;">
        <label><strong>PGP Secret Key Password</strong></label>

        <p class="help-block">Must be at least 10 characters long</p>

  <div class="input-group">
  <input type="password" name="password1" value="" class="form-control" maxlength="64">
  
    <a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
  </div>

</div>

<!--- PRIVATE KEY PASSWORD ENDS HERE --->

          <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

            </form>

      </div>
      <div class="modal-footer">

        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
<!--- CREATE KEYRING MODAL HTML STARTS HERE --->

           <!--- IMPORT KEYRING MODAL HTML STARTS HERE --->
   

           <div class="modal fade" id="import_modal" tabindex="-1" role="dialog" aria-labelledby="importModalLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header alert-primary">
                  <!---
                  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                  --->
                    <h4 class="modal-title">Import Keyring </h4>
                </div>
                  
                <div class="modal-body">
                
               

                  <form name="uploadDocument" enctype="multipart/form-data" method="post">
          
           
          <input type="hidden" name="action" value="importkeyring">
          <input type="hidden" name="recipient_id" value="">

            
       

          <div class="form-group">
          <label>Recipient</label>
          <input type="text" name="recipient_email" value="" class="form-control" readonly>
          </div>

          <div class="input-group">
          <input type="file" class="custom-file-input" id="customFile" name="fileUpload">
          <label class="custom-file-label" for="customFile">Choose PGP Key File</label>
          <p class="help-block">.asc, .pgp or .gpg files only</p>
          </div>
          
                       
    <!--- PUBLIC/PRIVATE KEY STARTS HERE --->

            <div class="form-group">
              <label>Key Type</label>
    <select class="form-control select2" id="keytype" name="keytype" data-placeholder="keytype" style="width: 100%">                  
    <option value="public" selected="selected">Public</option>
    <option value="private">Private</option>
     </select> 
    </div>

      <!--- PUBLIC/PRIVATE KEY ENDS HERE --->
  
<!--- PRIVATE KEY PASSWORD STARTS HERE --->
           
<div class="form-group" id="importkeyringpassword" style="display:none;">
  <label>Private Key Password</label>

<div class="input-group">
<input type="password" name="password1" value="" class="form-control" maxlength="64">

<a href=""><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
</div>

</div>

<!--- PRIVATE KEY PASSWORD ENDS HERE --->
                    
<input type="submit" class="btn btn-primary" name="" value="Import" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

</form>
          
                </div>
          
                <div class="modal-footer">
                 
                  <button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>
                </div>
              </div>
            </div>
          </div>
           <!--- IMPORT KEYRING MODAL HTML ENDS HERE --->
          


<!--- ACTIONS START HERE --->

<cfif #action# is "createkeyring">

  <!--- VALIDATE PARAMETERS BELOW --->



  <!--- FORM.REALNAME --->
  
  <cfif NOT StructKeyExists(form, "realname")>
  
    <cfset m="Create Recipient Keyring: form.realname does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
  <cfelseif StructKeyExists(form, "realname")>
  
<cfif #form.realname# is "">


<cfset session.m = 26>
<cfoutput>
<cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
</cfoutput>

<cfelse>

<cfset step=1>

<!--- /CFIF #form.realname# is --->
</cfif>

  
  <!--- /CFIF StructKeyExists(form, "realname") --->
  </cfif>


<cfif #step# is "1">
 
<!--- FORM.ENCRYPTION --->
<cfif NOT StructKeyExists(form, "encryption")>

  
  <cfset step=0>

  <cfset m="Create Recipient Keyring: form.encryption does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>


<cfelseif StructKeyExists(form, "encryption")>

<cfif #form.encryption# is "2048" OR #form.encryption# is "4096">

<cfset step=2>

<cfelse>

  <cfset step=0>

  <cfset m="Create Recipient Keyring: form.encryption is not 2048 or 4096">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.encryption# is "2048" OR #form.encryption# is "4096" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "encryption") --->
</cfif>

<!--- /CFIF #step# --->
</cfif>



<cfif #step# is "2">

<!--- FORM.AUTOPASS --->
<cfif NOT StructKeyExists(form, "autopass")>

  <cfset step=0>

  <cfset m="Create Recipient Keyring: form.autopass does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<cfelseif StructKeyExists(form, "autopass")>

<cfif #form.autopass# is "yes" OR #form.autopass# is "no">

<cfset step=3>

<cfelse>

  <cfset step=0>

  <cfset m="Create Recipient Keyring: form.autopass is not yes, or no">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- #form.autopass# is "yes" OR #form.autopass# is "no" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "autopass") --->
</cfif>

<!--- /CFIF #step# --->
</cfif>


<cfif #step# is "3">

<cfif #form.autopass# is "no">

  <!--- FORM.PASSWORD1 --->
  <cfif NOT StructKeyExists(form, "password1")>

    <cfset step=0>
  
  <cfset m="Create Recipient Keyring: form.password1 does not exist when form.autopass is no">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <cfelseif StructKeyExists(form, "password1")>
  
  <!--- ENSURE PASSWORD LENGTH IS AT LEAST 10 CHARACTERS --->
  <cfif NOT ( len(form.password1) GTE 10)>

  <cfset session.m = 2>
  <cfoutput>
  <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
  </cfoutput>

  <cfelse>
  
  <cfset password1=#form.password1#>

  <cfset step=4>
  
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

      <cfset step=4>
      
      <cfquery name="deletetrans" datasource="hermes">
      delete from salt where id='#stResult.GENERATED_KEY#'
      </cfquery>
  
  
  <!--- /CFIF #form.autopass# is --->
  </cfif>

  
<!--- /CFIF #step# --->
</cfif>

<cfif #step# is "4">

  <!--- FORM.RECIPIENT_ID --->
<cfif NOT StructKeyExists(form, "recipient_id")>

  <cfset step=0>

  <cfset m="Create Recipient Keyring: form.recipient_id does not exist">
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
  
  <cfset step=5>
  
  <cfelseif #getrecipient.recordcount# LT 1>

    <cfset step=0>
  
  <cfset m="Create Recipient Keyring: getrecipient.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
  
  <!--- /CFIF #getrecipient.recordcount# --->
  </cfif>
   
  <!--- /CFIF NOT/StructKeyExists(form, "recipient_id") --->
  </cfif>

<!--- /CFIF #step# --->
</cfif>
  
  <!--- VALIDATE PARAMETERS ABOVE --->

  <!--- CREATE KEYRING STARTS HERE --->

  <cfif #step# is "5">

  <cfinclude template="./inc/create_keyring.cfm">

  
  <!--- CREATE KEYRING ENDS HERE --->

  <cfset session.m = 3>
  <cfoutput>
  <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
  </cfoutput>

  <!--- /CFIF #step# --->
</cfif>
  


<cfelseif #action# is "importkeyring">



<!--- FORM.KEYTYPE --->
    <cfif NOT StructKeyExists(form, "keytype")>

      <cfset step=0>
      <cfset m="Import Recipient Keyring: form.keytype does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
  
      <cfelseif StructKeyExists(form, "keytype")>
  
        <cfif #form.keytype# is "private" OR #form.keytype# is "public">

        <cfset step=1>

        <cfelse>

          <cfset step=0>
          <cfset m="Import Recipient Keyring: form.keytype is not private or public">
          <cfinclude template="./inc/error.cfm">
          <cfabort>
  
      <!--- /CFIF   #form.keytype# is "private" or #form.keytype# is "public" --->
      </cfif>
  
      <!--- /CFIF  StructKeyExists(form, "keytype") --->
      </cfif>

<cfif #step# is "1">

  <cfif #form.keytype# is "private">

  <!--- FORM.PASSWORD1 --->
  <cfif NOT StructKeyExists(form, "password1")>

    <cfset step=0>
    <cfset m="Import Recipient Keyring: form.password1 does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "password1")>

      <cfif #form.password1# is "">

      <cfset step=0>
      <cfset session.m = 1>
      <cfoutput>
        <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
        </cfoutput>

    <cfelse>

      <cfset step=2>

    <cfset password1 = #form.password1#>

    <!--- /CFIF   #form.password1# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "password1") --->
    </cfif>

  <cfelseif #form.keytype# is "public">

    <cfset step=2>

    <!--- /CFIF #form.keytype# is "private"/is "public" --->
  </cfif>

      <!--- /CFIF #step# --->
</cfif>


<cfif #step# is "2">

<!--- FORM.RECIPIENT_ID --->
<cfif NOT StructKeyExists(form, "recipient_id")>

  <cfset step=0>

  <cfset m="Create Recipient Keyring: form.recipient_id does not exist">
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
  
  <cfset m="Create Recipient Keyring: getrecipient.recordcount LT 1">
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
    <cfset theKeyringName = rereplace(OriginalFileName, "[^A-Za-z0-9._]+", "", "all")>

    <cffile action="rename" 
    source="/opt/hermes/tmp/#OriginalFileName#" 
    destination="/opt/hermes/tmp/#theKeyringName#">
       
    <cfcatch>
    
    <cfif FindNoCase("not accepted", cfcatch.Message)>
      
    <cfset step=0>
    <cfset session.m = 4>
    <cfoutput>
    <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
    </cfoutput>

 <!---
    <cfdump var="#cfcatch#" abort />
 --->

    <cfelseif FindNoCase("doesn't exist", cfcatch.Message)>

      <cfset step=0>
      <cfset session.m = 5>
      <cfoutput>
      <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
      </cfoutput>

    <cfdump var="#cfcatch#" abort />
    <!--- looks like non-MIME error, handle separately  
    <cfdump var="#cfcatch#" abort /> --->
    
    <!--- /CFIF FindNoCase("", cfcatch.Message)> --->
    </cfif>
    
    </cfcatch>
    
    
    </cftry>
    
    <cfif #cffile.serverFileExt# is "asc" OR #cffile.serverFileExt# is "pgp" OR #cffile.serverFileExt# is "gpg">

    <cfset step=4>

    <cfelse>

    <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">

    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

    <!--- /CFIF fileExists(FiletoDelete) --->
    </cfif>

    <cfset step=0>
    <cfset session.m = 6>
    <cfoutput>
    <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
    </cfoutput>
  
    <!--- /CFIF #cffile.serverFileExt# is not "pfx" OR #cffile.serverFileExt# is not "p12" --->
  </cfif>
       
  <!--- /CFIF #step# --->
</cfif>



<cfif #step# is "4">

  <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
    select random_letter as random from captcha_list_all2 order by RAND() limit 8
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
    
    <cfset customtrans3=#gettrans.customtrans2#>
    
    <cfquery name="deletetrans" datasource="hermes">
    delete from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
   
  <cfif #form.keytype# is "public">

  <!--- GET PUBLIC KEY EMAIL STARTS HERE --->
    
 <cffile action="read" file="/opt/hermes/scripts/get_pgp_key_email.sh" variable="temp">
    
 <cffile action = "write"
     file = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_email.sh"
     output = "#REReplace("#temp#","THE-FILE","#theKeyringName#","ALL")#" addnewline="no">
 
 <cfexecute name = "/bin/chmod"
 arguments="+x /opt/hermes/tmp/#customtrans3#_get_pgp_key_email.sh"
 timeout = "60">
 </cfexecute>
 
 
 <cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_email.sh"
 timeout = "240"
 variable="thekeyemail2"
 arguments="-inputformat none">
 </cfexecute>
 
 
 <!--- delete /opt/hermes/tmp/#customtrans3#_get_pgp_key_email.sh --->
 <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_pgp_key_email.sh">
 <cfif fileExists(FiletoDelete)> 
 <cffile action="delete" 
 file = "#FiletoDelete#">

 <!--- /CFIF FiletoDelete --->
 </cfif>


 <cfif #thekeyemail2# is "">
 
 <!--- Delete File --->
 <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
 <cfif fileExists(FiletoDelete)> 
 <cffile action="delete" 
 file = "#FiletoDelete#">

  <!--- /CFIF FiletoDelete --->
 </cfif>

 
 <cfset step=0>
 <cfset session.m = 8>
 <cfoutput>
  <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
 </cfoutput>
 <cfabort>

 <cfelse>

 <cfset thekeyemail = #TRIM(htmlEditFormat(thekeyemail2))#>

<!--- CHECK TO SEE IF IT CONTAINS RECIPIENT EMAIL --->
       
<cfif  #thekeyemail# DOES NOT CONTAIN "#getrecipient.recipient#">
    

  <!--- Delete File --->
  <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
  <cfif fileExists(FiletoDelete)> 
  <cffile action="delete" 
  file = "#FiletoDelete#">

   <!--- /CFIF FiletoDelete --->
  </cfif>

  
  <cfset step=0>
  <cfset session.m = 9>
  <cfoutput>
  <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
  </cfoutput>
  <cfabort>

<!--- /CFIF #thekeyemail# DOES NOT CONTAIN "#getrecipient.recipient# --->
</CFIF>

<!--- /CFIF #thekeyemail2# is "" --->
</cfif>
 
 <!--- GET PUBLIC KEY EMAIL ENDS HERE --->

  
  <!--- GET PUBLIC KEY ID STARTS HERE --->
  
  <cffile action="read" file="/opt/hermes/scripts/get_pgp_key_id.sh" variable="temp">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_id.sh"
      output = "#REReplace("#temp#","THE-FILE","#theKeyringName#","ALL")#" addnewline="no">
  
  <cfexecute name = "/bin/chmod"
  arguments="+x /opt/hermes/tmp/#customtrans3#_get_pgp_key_id.sh"
  timeout = "60">
  </cfexecute>
  
  
  <cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_pgp_key_id.sh"
  timeout = "240"
  variable="thekeyid2"
  arguments="-inputformat none">
  </cfexecute>
  
  <!--- delete /opt/hermes/tmp/#customtrans3#_get_pgp_key_id.sh --->
  <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_pgp_key_id.sh">
  <cfif fileExists(FiletoDelete)> 
  <cffile action="delete" 
  file = "#FiletoDelete#">

   <!--- /CFIF FiletoDelete --->
  </cfif>

  
  <cfif #thekeyid2# is "">
  

  <!--- Delete File --->
  <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
  <cfif fileExists(FiletoDelete)> 
  <cffile action="delete" 
  file = "#FiletoDelete#">

   <!--- /CFIF FiletoDelete --->
  </cfif>

  

<cfset step=0>
<cfset session.m = 16>
<cfoutput>
<cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
</cfoutput>

  <cfelse>

  <cfset thekeyid = #TRIM(thekeyid2)#>

  <!--- SINCE PUBLIC CHECK IF IT EXISTS IN CM_KEYRING --->
  <cfquery name="checkkeyidexists" datasource="djigzo">
    select * from cm_keyring where cm_keyidhex='#thekeyid#'
    </cfquery>
    
    
  <cfif #checkkeyidexists.recordcount# LT 1>
  
    <cfset step=5>
    
  <cfelseif #checkkeyidexists.recordcount# GTE 1>
    
  
    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

     <!--- /CFIF FiletoDelete --->
    </cfif>

  
  <cfset step=0>
  <cfset session.m = 27>
  <cfoutput>
  <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
  </cfoutput>
  
  <!--- /CFIF #checkkeyidexists.recordcount# --->
    </cfif>

    <!--- /CFIF for thekeyid2 is "" --->
  </cfif>

 <!--- GET PUBLIC KEY ID ENDS HERE --->

 

  
  <cfelseif #form.keytype# is "private">

  <!--- GET PRIVATE KEY EMAIL STARTS HERE --->
    
  <cffile action="read" file="/opt/hermes/scripts/get_pgp_subkey_email.sh" variable="temp">
    
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_email.sh"
      output = "#REReplace("#temp#","THE-FILE","#theKeyringName#","ALL")#" addnewline="no">
  
  <cfexecute name = "/bin/chmod"
  arguments="+x /opt/hermes/tmp/#customtrans3#_get_pgp_subkey_email.sh"
  timeout = "60">
  </cfexecute>
  
  
  <cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_email.sh"
  timeout = "240"
  variable="thekeyemail2"
  arguments="-inputformat none">
  </cfexecute>
  
  
  <!--- delete /opt/hermes/tmp/#customtrans3#_get_pgp_subkey_email.sh --->
  <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_email.sh">
  <cfif fileExists(FiletoDelete)> 
  <cffile action="delete" 
  file = "#FiletoDelete#">

  <!--- /CFIF FiletoDelete --->
  </cfif>

  
  <cfif #thekeyemail2# is "">
  
  <!--- Delete File --->
  <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
  <cfif fileExists(FiletoDelete)> 
  <cffile action="delete" 
  file = "#FiletoDelete#">

   <!--- /CFIF FiletoDelete --->
  </cfif>

  
  <cfset step=0>
  <cfset session.m = 8>
  <cfoutput>
    <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
  </cfoutput>
  <cfabort>


  <cfelse>

  <cfset thekeyemail = #TRIM(htmlEditFormat(thekeyemail2))#>

  <!--- CHECK TO SEE IF IT CONTAINS RECIPIENT EMAIL --->
       
<cfif  #thekeyemail# DOES NOT CONTAIN "#getrecipient.recipient#">
    

<!--- Delete File --->
<cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

 <!--- /CFIF FiletoDelete --->
</cfif>


<cfset step=0>
<cfset session.m = 9>
<cfoutput>
<cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
</cfoutput>
<cfabort>

<!--- /CFIF #thekeyemail# DOES NOT CONTAIN "#getrecipient.recipient# --->
</CFIF>
  
  <!--- /CFIF #thekeyemail2# is "" --->
  </cfif>

  <!--- GET PRIVATE KEY EMAIL ENDS HERE --->
  
 
  <!--- GET PRIVATE KEY ID STARTS HERE --->
  
  <cffile action="read" file="/opt/hermes/scripts/get_pgp_subkey_id.sh" variable="temp">
  
  <cffile action = "write"
      file = "/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_id.sh"
      output = "#REReplace("#temp#","THE-FILE","#theKeyringName#","ALL")#" addnewline="no">
  
  <cfexecute name = "/bin/chmod"
  arguments="+x /opt/hermes/tmp/#customtrans3#_get_pgp_subkey_id.sh"
  timeout = "60">
  </cfexecute>
  
  
  <cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_id.sh"
  timeout = "240"
  variable="thekeyid2"
  arguments="-inputformat none">
  </cfexecute>



  <!--- delete /opt/hermes/tmp/#customtrans3#_get_pgp_subkey_id.sh --->
  <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_pgp_subkey_id.sh">
  <cfif fileExists(FiletoDelete)> 
  <cffile action="delete" 
  file = "#FiletoDelete#">

   <!--- /CFIF FiletoDelete --->
  </cfif>

  
  <cfif #thekeyid2# is "">
  

  <!--- Delete File --->
  <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
  <cfif fileExists(FiletoDelete)> 
  <cffile action="delete" 
  file = "#FiletoDelete#">

   <!--- /CFIF FiletoDelete --->
  </cfif>

  
<cfset step=0>
<cfset session.m = 16>
<cfoutput>
<cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
</cfoutput>

  <cfelse>

  <cfset thekeyid = #TRIM(thekeyid2)#>

  <!--- SINCE PRIVATE CHECK IF IT EXISTS IN CM_KEYRING --->
 <cfquery name="checkkeyidexists" datasource="djigzo">
  select * from cm_keyring where cm_keyidhex='#thekeyid#' and cm_private_key_alias is not NULL
  </cfquery>

    
    <cfif #checkkeyidexists.recordcount# LT 1>
  
    <cfset step=5>
  
    <cfelseif #checkkeyidexists.recordcount# GTE 1>
    
  
    <!--- Delete File --->
    <cfset FiletoDelete="/opt/hermes/tmp/#theKeyringName#">
    <cfif fileExists(FiletoDelete)> 
    <cffile action="delete" 
    file = "#FiletoDelete#">

     <!--- /CFIF FiletoDelete --->
    </cfif>

    
  <cfset step=0>
  <cfset session.m = 28>
  <cfoutput>
  <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
  </cfoutput>
  
    <!--- /CFIF for checkkeyidexists.recordcount --->
    </cfif>

    
  <!--- /CFIF for thekeyid2 is "" --->
  </cfif>

  <!--- GET PRIVATE KEY ID ENDS HERE --->

  
  <!--- /CFIF for form.keytype --->
  </cfif>
  
  <!--- /CFIF for step --->
  </cfif>
  


  <!--- IMPORT KEYRING STARTS HERE --->

  <cfif #step# is "5">

    <cfinclude template="./inc/import_keyring.cfm">
    
    <!--- IMPORT KEYRING ENDS HERE --->

    <cfset session.m = 7>
    <cfoutput>
    <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#form.recipient_id#" addtoken="no">
    </cfoutput>
  

<!--- /CFIF #step# --->
</cfif>


<cfelseif #action# is "deletekeyring">

  <!--- FORM.KEYRING_ID --->
  <cfif NOT StructKeyExists(form, "keyring_id")>

    <cfset step=0>
    <cfset m="Delete Recipient Keyring: form.keyring_id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "keyring_id")>

      <cfif #form.keyring_id# is "">

        
    <cfset step=0>
    <cfset m="Delete Recipient Keyring: form.keyring_id is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif #form.keyring_id# is not "">

      <cfquery name="getkeys" datasource="hermes">
        select * from recipient_keystores where id=<cfqueryparam value = #form.keyring_id# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>
        

    <cfif #getkeys.recordcount# LT 1>

    <cfset step=0>
    <cfset m="Delete Recipient Keyrings: getkeys.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelse>

<!--- DELETE KEYRING --->
<cfinclude template="./inc/delete_pgp_keyring.cfm">

  <cfset session.m = 15>
    <cfoutput>
    <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#url.id#" addtoken="no">
    </cfoutput>


  <!--- /CFIF  #getcerts.recordcount# LT 1 --->
  </cfif>


    <!--- /CFIF   #form.keyring_id# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "keyring_id") --->
    </cfif>

  <cfelseif #action# is "publishkeyring">

    <!--- FORM.KEYRING_ID --->
    <cfif NOT StructKeyExists(form, "keyring_id")>
  
      <cfset step=0>
      <cfset m="Publish Recipient Keyring: form.keyring_id does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
  
      <cfelseif StructKeyExists(form, "keyring_id")>
  
        <cfif #form.keyring_id# is "">
  
          
      <cfset step=0>
      <cfset m="Publish Recipient Keyring: form.keyring_id is blank">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
  
      <cfelseif #form.keyring_id# is not "">

        <cfquery name="getkeydetails" datasource="hermes">
          select user_id, pgp_key_id from recipient_keystores where id=<cfqueryparam value = #form.keyring_id# CFSQLType = "CF_SQL_INTEGER">
          </cfquery>
          
  
      <cfif #getkeydetails.recordcount# LT 1>
  
      <cfset step=0>
      <cfset m="Publish Recipient Keyrings: getkeydetails.recordcount LT 1">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
  
      <cfelse>

  <cfset step=1>

  <!--- /CFIF  #getkeydetails.recordcount# LT 1 --->
    </cfif>
  
  
    <!--- /CFIF   #form.keyring_id# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "keyring_id") --->
    </cfif>

  <cfif #step# is "1">
  
     <!--- FORM.KEYSERVER_ID --->
     <cfif NOT StructKeyExists(form, "keyserver_id")>
  
      <cfset session.m = 20>
      <cfoutput>
      <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#url.id#" addtoken="no">
      </cfoutput>
  
      <cfelseif StructKeyExists(form, "keyserver_id")>
  
        <cfif #form.keyserver_id# is "">
  
          
          <cfset session.m = 20>
          <cfoutput>
          <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#url.id#" addtoken="no">
          </cfoutput>
  
      <cfelseif #form.keyserver_id# is not "">

        <cfloop index="i" list="#form.keyserver_id#" delimiters=",">

          <cfif IsValid("integer", #i#)>
    
            <cfquery name="getkeyservername" datasource="hermes">
            select id, keyserver from pgp_keyservers where id = <cfqueryparam value = #i# CFSQLType = "CF_SQL_INTEGER">
            </cfquery>
    
            <cfif #getkeyservername.recordcount# GTE 1>
   
    
              <cfinclude template="./inc/publish_pgp_keyring.cfm">
    
              
              <cfset session.m = 21>
              <cfoutput>
              <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#url.id#" addtoken="no">
              </cfoutput>
            
            <cfelseif #getkeyservername.recordcount# LT 1>

                      
      <cfset step=0>
      <cfset m="getkeyservername.recordcount LT 1">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
    
              <!--- /CFIF #getkeyservername.recordcount# --->
            </cfif>
          
              <!--- /CFIF IsValid("integer", #i#) --->
            </cfif>
          
            
            </cfloop>


  
    <!--- /CFIF   #form.keyserver_id# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "keyserver_id") --->
    </cfif>
  

    <!--- /CFIF for #step# --->
  </cfif>

 
  


      <cfelseif #action# is "downloadpublic">

        <!--- FORM.CERTIFICATE_ID --->
        <cfif NOT StructKeyExists(form, "keyring_id")>
      
          <cfset step=0>
          <cfset m="Download Public Keyring: form.keyring_id does not exist">
          <cfinclude template="./inc/error.cfm">
          <cfabort>
      
          <cfelseif StructKeyExists(form, "keyring_id")>
      
            <cfif #form.keyring_id# is "">
      
              
          <cfset step=0>
          <cfset m="Download Public Keyring: form.keyring_id is blank">
          <cfinclude template="./inc/error.cfm">
          <cfabort>
      
          <cfelseif #form.keyring_id# is not "">
      
            <cfquery name="getkeyhex" datasource="hermes">
              select pgp_key_id from recipient_keystores where id = <cfqueryparam value = #form.keyring_id# CFSQLType = "CF_SQL_INTEGER">
              </cfquery>
              
      
          <cfif #getkeyhex.recordcount# LT 1>
      
          <cfset step=0>
          <cfset m="Download Public Keyring: getkeyhex.recordcount LT 1">
          <cfinclude template="./inc/error.cfm">
          <cfabort>
      
          <cfelse>

      <!--- DOWNLOAD PUBLIC KEYRING --->
      <cfinclude template="./inc/download_public_keyring.cfm">

      <!---
      <cfset session.m = 16>
      <cfoutput>
      <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#url.id#" addtoken="no">
      </cfoutput>
    --->
  
                
      <!--- /CFIF  #getkeyhex.recordcount# LT 1 --->
      </cfif>
    
      <!--- /CFIF   #form.keyring_id# is "" --->
      </cfif>
  
      <!--- /CFIF  StructKeyExists(form, "keyring_id") --->
      </cfif>
    

      
    <cfelseif #action# is "downloadprivate">

      <!--- FORM.CERTIFICATE_ID --->
      <cfif NOT StructKeyExists(form, "keyring_id")>
    
        <cfset step=0>
        <cfset m="Download Private Keyring: form.keyring_id does not exist">
        <cfinclude template="./inc/error.cfm">
        <cfabort>
    
        <cfelseif StructKeyExists(form, "keyring_id")>
    
          <cfif #form.keyring_id# is "">
    
            
        <cfset step=0>
        <cfset m="Download Private Keyring: form.keyring_id is blank">
        <cfinclude template="./inc/error.cfm">
        <cfabort>
    
        <cfelseif #form.keyring_id# is not "">

          <cfquery name="getkeyhex" datasource="hermes">
            select pgp_key_id, pgp_keystore_password from recipient_keystores where id = <cfqueryparam value = #form.keyring_id# CFSQLType = "CF_SQL_INTEGER">
            </cfquery>
            
    
        <cfif #getkeyhex.recordcount# LT 1>
    
        <cfset step=0>
        <cfset m="Download Private Keyring: getkeyhex.recordcount LT 1">
        <cfinclude template="./inc/error.cfm">
        <cfabort>
    
        <cfelse>

    <!--- DOWNLOAD PRIVATE KEYRING --->
    <cfinclude template="./inc/download_private_keyring.cfm">

    <!---
    <cfset session.m = 16>
    <cfoutput>
    <cflocation url="view_recipient_keyrings.cfm?type=#url.type#&id=#url.id#" addtoken="no">
    </cfoutput>
  --->

              
    <!--- /CFIF  #getkeyhex.recordcount# LT 1 --->
    </cfif>
  
    <!--- /CFIF   #form.keyring_id# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "keyring_id") --->
    </cfif>

 <!--- /CFIF FOR ACTION ---> 
</cfif>

  <!--- ACTIONS END HERE --->


    
    <cfif #getkeyrings.recordcount# GTE 1>
    

    
    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
          
            <th>Download Public</th>
            <th>Download Private</th>
            <th>View Password</th>
            <th>Publish Key</th>
            <th>Delete</th>
            <th>Type</th>
            <th>Size</th>
            <th>User-ID</th>
            <th>Created</th>
            <th>Expires</th>
            <th>Private Key</th>
            <th>Key-ID</th>
            <th>Parent-ID</th>

          

          </tr>
        </thead>
        <tbody>

          <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
         
           
    <cfquery name="getkeyservers" datasource="hermes">
      select id from pgp_keyservers
      </cfquery>

      <cfloop query="getkeyrings">

        <!--- OUTPUT MASTER KEY --->
        <cfoutput>

        <cfquery name="getprivatekeyalias" datasource="djigzo">
          select cm_private_key_alias from cm_keyring where cm_sha256fingerprint='#pgp_fingerprint_sha256#'
          </cfquery>
   
    
          <tr>
            <td>

              <form name="DownloadPublic" method="post">

                <input type="hidden" name="action" value="downloadpublic">
                <input type="hidden" name="keyring_id" value="#id#"/>

                <button type="submit" value="" class="btn btn-secondary" onclick="this.form.submit();"><i class="fas fa-download"></i></button>

              </form>
           
            </td>

            <cfif #getprivatekeyalias.cm_private_key_alias# is "">
            <td>No Private Key Available</td>

            <cfelse>

            <td>

              <form name="DownloadPrivate" method="post">

                <input type="hidden" name="action" value="downloadprivate">
                <input type="hidden" name="keyring_id" value="#id#"/>

                <button type="submit" value="" class="btn btn-secondary" onclick="this.form.submit();"><i class="fas fa-arrow-circle-down"></i></button>

              </form>
           
            </td>

            <!--- /CFIF #getprivatekeyalias.cm_private_key_alias# is "" --->
          </cfif>

            <td>
              
              <cfset decryptedPassword=decrypt(pgp_keystore_password, #theKey#, "AES", "Base64")>

              <button a href="##viewpassword_modal"  type="button" id="send" class="btn btn-secondary" data-toggle="modal" data-keyring="#id#" data-password="#decryptedPassword#"><i class="fas fa-search"></i></button>
              

            </td>

            <cfif #getkeyservers.recordcount# GTE 1>
            
              <td>

                <button a href="##publish_modal"  type="button" id="publish" class="btn btn-secondary" data-toggle="modal" data-keyring="#id#" data-keyusername="#htmlEditFormat(user_name)#" data-keyid="#pgp_key_id#"><i class="fas fa-share-alt"></i></button>

            </td>

          <cfelse>

            <td>NO Key Servers Available</td>

            <!--- /CFIF #getkeyservers.recordcount# --->
          </cfif>

            <td>

              <button a href="##delete_modal"  type="button" id="delete" class="btn btn-danger" data-toggle="modal" data-keyring="#id#"><i class="fas fa-trash-alt"></i></button>

            </td>
      
        
              <cfquery name="getchildkeys" datasource="hermes">
              select * from recipient_keystores where parent='#id#' and master = '0'
              </cfquery>
              
 

            <td>MASTER</td>


  
          <td>#encryption#</td>



       <td>#htmlEditFormat(user_name)#</td>

       
            <td> #DateFormat(pgp_keystore_creation, "yyyy-mm-dd")#</td>

            <cfif #pgp_keystore_expiration# is "">

              <td>N/A</td>

            <cfelse>

            <td> #DateFormat(pgp_keystore_expiration, "yyyy-mm-dd")#</td>

            <!--- /CFIF pgp_keystore_expiration is --->
          </cfif>

          <cfif #getprivatekeyalias.cm_private_key_alias# is "">

            <td>NO</td>

           <cfelse>

          <td>YES</td>

          <!--- /CFIF  #getprivatekeyalias.cm_private_key_alias# is "" --->
         </cfif>

         <td>#pgp_key_id#</td>
         <td>N/A</td>


         <!--- /CFOUTPUT MASTER KEY --->
        </cfoutput>

       
        <!--- OUTPUT SUB KEYS --->
        <cfoutput query="getchildkeys">

          <tr>

            <td>

          <form name="DownloadPublic" method="post">

            <input type="hidden" name="action" value="downloadpublic">
            <input type="hidden" name="keyring_id" value="#id#"/>

        
            
            <button type="submit" value="" class="btn btn-secondary" onclick="this.form.submit();"><i class="fas fa-download"></i></button>

          </form>
       
        </td>

        <cfif #getprivatekeyalias.cm_private_key_alias# is "">
        <td>No Private Key Available</td>

        <cfelse>

        <td>

          <form name="DownloadPrivate" method="post">

            <input type="hidden" name="action" value="downloadprivate">
            <input type="hidden" name="keyring_id" value="#id#"/>

            <button type="submit" value="" class="btn btn-secondary" onclick="this.form.submit();"><i class="fas fa-arrow-circle-down"></i></button>

          </form>
       
        </td>

        <!--- /CFIF #getprivatekeyalias.cm_private_key_alias# is "" --->
      </cfif>

      <td>
              
        <cfset decryptedPassword=decrypt(pgp_keystore_password, #theKey#, "AES", "Base64")>

        <button a href="##viewpassword_modal"  type="button" id="send" class="btn btn-secondary" data-toggle="modal" data-keyring="#id#" data-password="#decryptedPassword#"><i class="fas fa-search"></i></button>
        

      </td>

        <cfif #getkeyservers.recordcount# GTE 1>
        
          <td>

            <button a href="##publish_modal"  type="button" id="publish" class="btn btn-secondary" data-toggle="modal" data-keyring="#id#" data-keyusername="#htmlEditFormat(user_name)#" data-keyid="#pgp_key_id#"><i class="fas fa-share-alt"></i></button>

          </td>

        <cfelse>

          <td>NO Key Servers Available</td>

          <!--- /CFIF #getkeyservers.recordcount# --->
        </cfif>

          <td>

            <button a href="##delete_modal"  type="button" id="delete" class="btn btn-danger" data-toggle="modal" data-keyring="#id#"><i class="fas fa-trash-alt"></i></button>

          </td>
  
    
          <cfquery name="getchildkeys" datasource="hermes">
          select * from recipient_keystores where parent='#id#' and master = '0'
          </cfquery>
          


        <td>SUB</td>



      <td>#encryption#</td>



   <td>#htmlEditFormat(user_name)#</td>

   
        <td> #DateFormat(pgp_keystore_creation, "yyyy-mm-dd")#</td>

        <cfif #pgp_keystore_expiration# is "">

          <td>N/A</td>

        <cfelse>

        <td> #DateFormat(pgp_keystore_expiration, "yyyy-mm-dd")#</td>

        <!--- /CFIF pgp_keystore_expiration is --->
      </cfif>

      <cfif #getprivatekeyalias.cm_private_key_alias# is "">

        <td>NO</td>

       <cfelse>

      <td>YES</td>

      <!--- /CFIF  #getprivatekeyalias.cm_private_key_alias# is "" --->
     </cfif>

     <td>#pgp_key_id#</td>

     <cfquery name="getparentid" datasource="hermes">
      select pgp_key_id from recipient_keystores where id='#parent#'
      </cfquery>

     <td>#getparentid.pgp_key_id#</td>

                   


     <!--- /CFOUTPUT SUB KEYS --->
    </cfoutput>


    <!--- /TR OUTPUT MASTER --->
  </tr>

  <!--- /TR OUTPUT SUB --->
</tr>

        </cfloop>
        </tbody>
        
        <tfoot>
          <tr>
          
            <th>Download Public</th>
            <th>Download Private</th>
            <th>View Password</th>
            <th>Publish Key</th>
            <th>Delete</th>
            <th>Type</th>
            <th>Size</th>
            <th>User-ID</th>
            <th>Created</th>
            <th>Expires</th>
            <th>Private Key</th>
            <th>Key-ID</th>
            <th>Parent-ID</th>          

          </tr>
        </tfoot>
       
      </table>
    
    
    <cfelseif #getkeyrings.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Recipient Keyrings were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getkeyrings.recordcount --->
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

<!--- CREATE KEYRING RECIPIENT_ID MODAL SCRIPT STARTS HERE  --->
<script>
  $('#create_modal').on('show.bs.modal', function(e) {
      var recipient_id = $(e.relatedTarget).data('recipient');
      $(e.currentTarget).find('input[name="recipient_id"]').val(recipient_id);
  });
    </script>
<!--- CREATE KEYRING RECIPIENT_ID MODAL SCRIPT ENDS HERE  --->

<!--- CREATE KEYRING RECIPIENT_EMAIL MODAL SCRIPT STARTS HERE  --->
<script>
  $('#create_modal').on('show.bs.modal', function(e) {
      var recipient_email = $(e.relatedTarget).data('recipientemail');
      $(e.currentTarget).find('input[name="recipient_email"]').val(recipient_email);
  });
    </script>
<!--- CREATE KEYRING RECIPIENT_EMAIL MODAL SCRIPT ENDS HERE  --->

<!--- IMPORT KEYRING MODAL SCRIPT STARTS HERE  --->
<script>
  $('#import_modal').on('show.bs.modal', function(e) {
      var recipient_id = $(e.relatedTarget).data('recipient');
      $(e.currentTarget).find('input[name="recipient_id"]').val(recipient_id);
  });
    </script>
<!--- IMPORT KEYRING MODAL SCRIPT ENDS HERE  --->

<!--- IMPORT KEYRING MODAL SCRIPT STARTS HERE  --->
<script>
  $('#import_modal').on('show.bs.modal', function(e) {
      var recipient_email = $(e.relatedTarget).data('recipientemail');
      $(e.currentTarget).find('input[name="recipient_email"]').val(recipient_email);
  });
    </script>
<!--- IMPORT KEYRING MODAL SCRIPT ENDS HERE  --->

<!--- DELETE KEYRING MODAL SCRIPT STARTS HERE  --->
<script>
  $('#delete_modal').on('show.bs.modal', function(e) {
      var keyring_id = $(e.relatedTarget).data('keyring');
      $(e.currentTarget).find('input[name="keyring_id"]').val(keyring_id);
  });
    </script>

<!--- DELETE KEYRING PASSWORD MODAL SCRIPT ENDS HERE  --->

<!--- VIEW KEYRING PASSWORD MODAL SCRIPT STARTS HERE  --->
<script>
  $('#viewpassword_modal').on('show.bs.modal', function(e) {
      var password = $(e.relatedTarget).data('password');
      $(e.currentTarget).find('input[name="password"]').val(password);
  });
    </script>

<!--- VIEW KEYRING PASSWORD MODAL SCRIPT ENDS HERE  --->

<!--- PUBLISH KEYRING MODAL SCRIPT STARTS HERE  --->
<script>
  $('#publish_modal').on('show.bs.modal', function(e) {
      var keyring_id = $(e.relatedTarget).data('keyring');
      $(e.currentTarget).find('input[name="keyring_id"]').val(keyring_id);
  });
    </script>

<!--- PUBLISH KEYRING MODAL SCRIPT ENDS HERE  --->

<!--- PUBLISH KEYRING USERNAME MODAL SCRIPT STARTS HERE  --->
<script>
  $('#publish_modal').on('show.bs.modal', function(e) {
      var keyusername = $(e.relatedTarget).data('keyusername');
      $(e.currentTarget).find('input[name="recipient"]').val(keyusername);
  });
    </script>

<!--- PUBLISH KEYRING USERNAME MODAL SCRIPT ENDS HERE  --->

<!--- PUBLISH KEYRING USERNAME MODAL SCRIPT STARTS HERE  --->
<script>
  $('#publish_modal').on('show.bs.modal', function(e) {
      var keyid = $(e.relatedTarget).data('keyid');
      $(e.currentTarget).find('input[name="keyid"]').val(keyid);
  });
    </script>

<!--- PUBLISH KEYRING USERNAME MODAL SCRIPT ENDS HERE  --->

<script>
  // Add the following code if you want the name of the file appear on select
  $(".custom-file-input").on("change", function() {
    var fileName = $(this).val().split("\\").pop();
    $(this).siblings(".custom-file-label").addClass("selected").html(fileName);
  });
  </script>
  

  <script>
    // Add the following code if you want the name of the file appear on select
    $(".custom-file-input").on("change", function() {
      var fileName = $(this).val().split("\\").pop();
      $(this).siblings(".custom-file-label").addClass("selected").html(fileName);
    });
    </script>
    
  
  
   <!--- SCRIPT TO SHOW/HIDE CREATE KEYRING PASSWORD SCRIPT STARTS HERE  --->
     <!--- THIS SCRIPT WILL NOT WORK IF PLACED IN THE <HEAD></HEAD> SECTION  --->
  
     <script>
  
      $('#autopass').on('change',function(){
        if( $(this).val()==="yes" ){
        $("#keyringpassword").hide()
        }
        else{
        $("#keyringpassword").show()
        }
      });
      
      </script>
    
    <!--- SCRIPT TO SHOW/HIDE CREATE KEYRING PASSWORD SCRIPT ENDS HERE  --->
  

   <!--- SCRIPT TO SHOW/HIDE IMPORT KEYRING PASSWORD SCRIPT STARTS HERE  --->
     <!--- THIS SCRIPT WILL NOT WORK IF PLACED IN THE <HEAD></HEAD> SECTION  --->
  
     <script>
   
  $('#keytype').on('change',function(){
    if( $(this).val()==="public" ){
    $("#importkeyringpassword").hide()
    }
    else{
    $("#importkeyringpassword").show()
    }
  });
  
  </script>
    
    <!--- SCRIPT TO SHOW/HIDE IMPORT KEYRING PASSWORD SCRIPT ENDS HERE  --->

</html>