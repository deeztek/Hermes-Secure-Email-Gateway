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
  <title>Hermes SEG | Edit Domain DKIM Configuration</title>
  
  <cfinclude template="./inc/html_head.cfm" />

     <!-- Preloader -->
     <div class="preloader flex-column justify-content-center align-items-center">
      <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
      </div>

      <!--- Sort Table Script Default Sort by Column 4 Desc --->


<!--- Sort Table Script  --->
<script>
  $(document).ready(function() {
      $('#sortTable').DataTable( {
        dom: 'Blfrtip',
          buttons: [
              'copy', 'csv', 'excel', 'pdf', 'print'
          ],
          stateSave: true,
          lengthMenu: [
            [ 25, 50, 100, -1 ],
      [ '25 rows', '50 rows', '100 rows', 'Show all' ]
  
      ],
      
          "order": [[ 2, "asc" ]]
      } );
  } );
    </script>

<!--- SCRIPT TO SHOW/HIDE PASSWORD ON VIEW KEYRING MODAL--->
<script>

  $(document).ready(function() {
      $("#viewdestinationpassword a").on('click', function(event) {
          event.preventDefault();
          if($('#viewdestinationpassword input').attr("type") == "text"){
              $('#viewdestinationpassword input').attr('type', 'password');
              $('#viewdestinationpassword i').addClass( "fa-eye-slash" );
              $('#viewdestinationpassword i').removeClass( "fa-eye" );
          }else if($('#viewdestinationpassword input').attr("type") == "password"){
              $('#viewdestinationpassword input').attr('type', 'text');
              $('#viewdestinationpassword i').removeClass( "fa-eye-slash" );
              $('#viewdestinationpassword i').addClass( "fa-eye" );
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
            <h1 class="m-0">Edit Domain DKIM Configuration
            </h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Edit Domain DKIM Configuration</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">


<!-- CFML CODE STARTS HERE -->

<cfparam name = "step" default = "0"> 

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

<cfparam name = "action" default = ""> 
<cfif StructKeyExists(form, "action")>
<cfset action = form.action>

<!--- /CFIF StructKeyExists(form, "action")> --->
</cfif>


<cfparam name = "theDomainID" default = ""> 

<cfif StructKeyExists(url, "id")>
<cfif IsValid("integer", url.id)>
<cfset theDomainID = url.id>
<cfelse>
<cfset m="Edit Domain DKIM Configuration: url.id not valid integer">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF isValid("integer", form.id) --->
</cfif>


<cfelseif NOT StructKeyExists(url, "id")>
<cfset m="Edit Domain DKIM Configuration: url.id does not exist">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF StructKeyExists(url, "id") --->
</cfif> 

<cfquery name="getdomain" datasource="hermes">
select id, domain from domains where id = <cfqueryparam value = #theDomainID# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getdomain.recordcount# LT 1>
<cfset m="Edit Domain DKIM Configuration: getdomain.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>


<cfelse>

<cfquery name="getdomaindkim" datasource="hermes">
  select id, domain from dkim_sign where domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdomain.domain#"> 
  </cfquery>


<cfparam name = "dkimdomain" default = "#getdomaindkim.domain#"> 


<!--- /CFIF #getdomain.recordcount# --->
</cfif>

<!--- ADD DOMAIN MODAL HTML STARTS HERE --->

<div class="modal fade" id="adddkimkey_modal" tabindex="-1" role="dialog" aria-labelledby="AddDkimKeyModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
    <h4 class="modal-title">Add DKIM Key </h4>
</div>
  
<div class="modal-body">

  <form name="AddDomain" autocomplete="off" method="post">

    <input type="hidden" name="action" value="Add DKIM Key">
    <input type="hidden" name="domain_id" value=""/>

    <div class="form-group">
      <label><strong>DKIM Key Size</strong></label>
        
      <select class="form-control" name="dkimkey" data-placeholder="dkimkey" style="width: 100%;" id="dkimkey">
         
          <option value="2048" selected>2048-Bit (Recommended)</option>
          <option value="1024">1024-Bit</option>
       
          </select>   

        </div>

        <div class="form-group">

          <label><strong>DKIM Selector</strong></label>

        

  


          <cfoutput>
          <input type="text" name="selector" class="selector form-control" id="selector" placeholder="Enter a unique alpha string to use as a DKIM Selector" value="" autocomplete="off">
          </cfoutput>

        
        </div>



 

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

<!--- VIEW PUBLIC KEY MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="viewPublickey_modal" tabindex="-1" role="dialog" aria-labelledby="viewPublicKeyModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">View Public Key </h4>
      </div>
        
      <div class="modal-body">
        <p>Please copy and paste the key below into your DKIM DNS record.</p>

   
        <form name="EditDomain" autocomplete="off" method="post">

   

          <div class="form-group">
            <label>Public Key</label>
            <div class="textareacontainer">

   
              <div id="publickeyarea"></div>
         

   

        </div>
        
          </div>

        </form>



      </div>
      <div class="modal-footer">
 
        <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
<!---  VIEW PUBLIC KEY MODAL HTML ENDS HERE --->


<!--- VIEW PRIVATE KEY MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="viewPrivatekey_modal" tabindex="-1" role="dialog" aria-labelledby="viewPrivateKeyModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">View Private Key </h4>
      </div>
        
      <div class="modal-body">
        <p>The Private Key below is shown for reference. It should be kept in a safe place and not shared. <strong>Do NOT</strong> attempt to enter the key below into your DKIM DNS Record.</p>

   
        <form name="EditDomain" autocomplete="off" method="post">

   

          <div class="form-group">
            <label>Private Key</label>
            <div class="textareacontainer">

   
              <div id="privatekeyarea"></div>
         

   

        </div>
        
          </div>

        </form>



      </div>
      <div class="modal-footer">
 
        <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
<!---  VIEW PRIVATE KEY MODAL HTML ENDS HERE --->



<!--- DELETE KEY MODAL HTML STARTS HERE --->
   

<div class="modal fade" id="deletekey_modal" tabindex="-1" role="dialog" aria-labelledby="deleteKeyModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Delete DKIM Key </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you send to delete this DKIM Key? This action is irreversible! If you delete the DKIM Key used for signing then DKIM Sign will be disabled for this domain. </p>

      </div>
      <div class="modal-footer">
        <form name="DeleteKey" method="post">

          <input type="hidden" name="action" value="Delete Key">
          <input type="hidden" name="key_id" value=""/>
          <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
          
            </form>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>
<!--- DELETE KEY MODAL HTML ENDS HERE --->




<cfif #action# is "Set DKIM Sign">

<!--- FORM.domain_id --->
<cfif NOT StructKeyExists(form, "domain_id")>

  <cfset step=0>
  <cfset m="Set DKIM Sign: form.domain_id does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelseif StructKeyExists(form, "domain_id")>

    <cfif #form.domain_id# is "">

      
  <cfset step=0>
  <cfset m="Set DKIM Sign: form.domain_id is blank">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelseif #form.domain_id# is not "">

    <cfquery name="getdomaindkimsign" datasource="hermes">
      select id, domain from domains where id=<cfqueryparam value = #form.domain_id# CFSQLType = "CF_SQL_INTEGER">
      </cfquery>
      

  <cfif #getdomaindkimsign.recordcount# LT 1>

  <cfset step=0>
  <cfset m="Set DKIM Sign: getdomaindkimsign.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelseif #getdomaindkimsign.recordcount# GTE 1>

<cfset step = 1>

<!--- /CFIF  #getdomaindkimsign.recordcount#  --->
</cfif>


<!--- /CFIF   #form.domain_id# is "" --->
</cfif>

<!--- /CFIF  StructKeyExists(form, "domain_id") --->
</cfif>


<cfif #step# is "1">

<!--- FORM.dkimsignenable --->
<cfif NOT StructKeyExists(form, "dkimsignenable")>

  <cfset step=0>
  <cfset m="Set DKIM Sign: form.dkimsignenable does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelseif StructKeyExists(form, "dkimsignenable")>

    <cfif #form.dkimsignenable# is "">

      
  <cfset step=0>
  <cfset m="DKIM Sign Enable: form.dkimsignenable is blank">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <cfelseif #form.dkimsignenable# is not "">

<cfif #form.dkimsignenable# is "1">

<cfset step = 2>

<cfelseif #form.dkimsignenable# is "2">

<cfset step = 4>


<cfelse>


<cfset step=0>
<cfset m="DKIM Sign Enable: form.dkimsignenable is not 1 or 2">
<cfinclude template="./inc/error.cfm">
<cfabort>


<!--- /CFIF  #dkimsignenable# is "1" OR #dkimsignenable# is "2" --->
</cfif>
      

<!--- /CFIF   #form.dkimsignenable# is "" --->
</cfif>

<!--- /CFIF  StructKeyExists(form, "dkimsignenable") --->
</cfif>



<!--- /CFIF #step# is "1" --->
</cfif>

<cfif #step# is "2">

  <!--- FORM.dkimsignenable --->
  <cfif NOT StructKeyExists(form, "dkim_selector")>
  
    <cfset step=0>
    <cfset m="Set DKIM Sign: form.dkim_selector does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
    <cfelseif StructKeyExists(form, "dkim_selector")>
  
      <cfif #form.dkim_selector# is "">
  
        
    <cfset step=0>
    <cfset m="DKIM Sign Enable: form.dkim_selector is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  
<cfelseif #form.dkim_selector# is not "">
  
<cfquery name="getselector" datasource="hermes">
select id, domain, selector from dkim_sign where id = <cfqueryparam value = #form.dkim_selector# CFSQLType = "CF_SQL_INTEGER"> and domain =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdomaindkimsign.domain#">
</cfquery>

<cfif #getselector.recordcount# GTE 1>
  
  
  <cfset step = 3>
  
  <cfelseif #getselector.recordcount# LT 1>
 
  
  <cfset step=0>
  <cfset m="DKIM Sign Enable: getselector.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

  <!--- /CFIF #getselector.recordcount# --->
  </cfif>
  
  
  <!--- /CFIF  #form.dkim_selector# is --->
  </cfif>
        
  
  <!--- /CFIF  StructKeyExists(form, "dkim_selector") --->
  </cfif>


<!--- /CFIF #step# is "2" --->
</cfif>


<cfif #step# is "3">

 <!--- ENABLE DKIM SIGN --->
 <cfinclude template="./inc/dkim_enable_dkim_sign.cfm">

 <!--- GENERATE KEYTABLE --->
 <cfinclude template="./inc/dkim_generate_keytable.cfm">
 
 
 <!--- GENERATE SIGNING TABLE --->
 <cfinclude template="./inc/dkim_generate_signingtable.cfm">
 
 <!--- RESTART OPENDKIM --->
 <cfinclude template="./inc/restart_opendkim.cfm">
 
   <cfset session.m = 6>
 
     <cfoutput>
     <cflocation url="edit_domain_dkim.cfm?id=#url.id#" addtoken="no">
     </cfoutput>
 


<!--- /CFIF #step# is "3" --->
</cfif>


<cfif #step# is "4">

  <!--- DISABLE DKIM SIGN --->
  <cfinclude template="./inc/dkim_disable_dkim_sign.cfm">
 
  <!--- GENERATE KEYTABLE --->
  <cfinclude template="./inc/dkim_generate_keytable.cfm">
  
  
  <!--- GENERATE SIGNING TABLE --->
  <cfinclude template="./inc/dkim_generate_signingtable.cfm">
  
  <!--- RESTART OPENDKIM --->
  <cfinclude template="./inc/restart_opendkim.cfm">
  
    <cfset session.m = 7>
  
      <cfoutput>
      <cflocation url="edit_domain_dkim.cfm?id=#url.id#" addtoken="no">
      </cfoutput>
  
 
 <!--- /CFIF #step# is "4" --->
 </cfif>

<!--- VALIDATE PARAMETERS ABOVE --->


<cfelseif #action# is "Add DKIM Key">

  <!--- FORM.domain_id --->
  <cfif NOT StructKeyExists(form, "domain_id")>

    <cfset step=0>
    <cfset m="Add DKIM Key: form.domain_id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "domain_id")>

      <cfif #form.domain_id# is "">

        
    <cfset step=0>
    <cfset m="Domain DKIM Key: form.domain_id is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif #form.domain_id# is not "">

      <cfquery name="getdomain" datasource="hermes">
        select id, domain from domains where id=<cfqueryparam value = #form.domain_id# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>
        

    <cfif #getdomain.recordcount# LT 1>

    <cfset step=0>
    <cfset m="Add DKIM Keys: getdomain.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif #getdomain.recordcount# GTE 1>

<cfset step = 1>

  <!--- /CFIF  #domain.recordcount#  --->
</cfif>


<!--- /CFIF   #form.domain_id# is "" --->
</cfif>

<!--- /CFIF  StructKeyExists(form, "domain_id") --->
</cfif>


<cfif #step# is "1">

  <!--- FORM.dkimkey --->
  <cfif NOT StructKeyExists(form, "dkimkey")>

    <cfset step=0>
    <cfset m="Add DKIM Key: form.dkimkey does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "dkimkey")>

      <cfif #form.dkimkey# is "">

        
    <cfset step=0>
    <cfset m="Domain DKIM Key: form.dkimkey is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif #form.dkimkey# is not "">

<cfif #form.dkimkey# is "2048" OR #form.dkimkey# is "1024">

<cfset step = 2>

<cfelse>

  
  <cfset step=0>
  <cfset m="Add DKIM Keys: form.dkimkey is not 1024 or 2048">
  <cfinclude template="./inc/error.cfm">
  <cfabort>


<!--- /CFIF  #dkimkey# is "2048" OR #dkimkey# is "1024" --->
</cfif>
        

<!--- /CFIF   #form.dkimkey# is "" --->
</cfif>

<!--- /CFIF  StructKeyExists(form, "dkimkey") --->
</cfif>



<!--- /CFIF #step# is "1" --->
</cfif>


<cfif #step# is "2">

  <!--- FORM.selector --->
  <cfif NOT StructKeyExists(form, "selector")>

    <cfset step=0>
    <cfset m="Add DKIM Key: form.selector does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "selector")>

      <cfif #form.selector# is "">

        
        <cfset session.m = 2>
        <cfoutput>
        <cflocation url="edit_domain_dkim.cfm?id=#url.id#" addtoken="no">
        </cfoutput>

    <cfelseif #form.selector# is not "">

<cfif REFind("[^_a-zA-Z0-9\-\_\.]",form.selector) gt 0>

  <cfset session.m = 3>
  <cfoutput>
  <cflocation url="edit_domain_dkim.cfm?id=#url.id#" addtoken="no">
  </cfoutput>

<cfelse>

<cfset step = 3>

<!--- /CFIF REFind("[^_a-zA-Z0-9\-\_\.]",form.selector) gt 0 --->

</cfif>

<!--- /CFIF   #form.selector# is "" --->
</cfif>

<!--- /CFIF  StructKeyExists(form, "selector") --->
</cfif>




<!--- /CFIF #step# is "2" --->
</cfif>


<cfif #step# is "3">

<cfquery name="checkexists" datasource="hermes">
select selector, domain from dkim_sign where domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdomain.domain#"> and selector = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.selector#">
</cfquery>

<cfif #checkexists.recordcount# GTE 1>

  
  <cfset session.m = 4>
  <cfoutput>
  <cflocation url="edit_domain_dkim.cfm?id=#url.id#" addtoken="no">
  </cfoutput>

<cfelseif #checkexists.recordcount# LT 1>

  <!--- CREATE KEY --->
<cfinclude template="./inc/dkim_create_key.cfm">

<!--- GENERATE KEYTABLE --->
<cfinclude template="./inc/dkim_generate_keytable.cfm">

<!--- GENERATE SIGNING TABLE --->
<cfinclude template="./inc/dkim_generate_signingtable.cfm">

<!--- RESTART OPENDKIM --->
<cfinclude template="./inc/restart_opendkim.cfm">

  <cfset session.m = 5>

    <cfoutput>
    <cflocation url="edit_domain_dkim.cfm?id=#url.id#" addtoken="no">
    </cfoutput>

<!--- /CFIF checkexits.recordcount --->
</cfif>

<!--- /CFIF #step# is "3" --->
</cfif>



<cfelseif #action# is "Delete Key">

  <!--- FORM.key_id --->
  <cfif NOT StructKeyExists(form, "key_id")>

    <cfset step=0>
    <cfset m="Delete DKIM Key: form.key_id does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif StructKeyExists(form, "key_id")>

      <cfif #form.key_id# is "">

        
    <cfset step=0>
    <cfset m="Delete DKIM Key: form.key_id is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelseif #form.key_id# is not "">

      <cfquery name="getdkimkey" datasource="hermes">
        select id, domain, public, private from dkim_sign where id=<cfqueryparam value = #form.key_id# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>
        

    <cfif #getdkimkey.recordcount# LT 1>

    <cfset step=0>
    <cfset m="Delete DKIM Keys: getdkimkey.recordcount LT 1">
    <cfinclude template="./inc/error.cfm">
    <cfabort>

    <cfelse>

<!--- DELETE KEY --->
<cfinclude template="./inc/dkim_delete_key.cfm">

<!--- GENERATE KEYTABLE --->
<cfinclude template="./inc/dkim_generate_keytable.cfm">

<!--- GENERATE SIGNING TABLE --->
<cfinclude template="./inc/dkim_generate_signingtable.cfm">

<!--- RESTART OPENDKIM --->
<cfinclude template="./inc/restart_opendkim.cfm">

  <cfset session.m = 1>
    <cfoutput>
    <cflocation url="edit_domain_dkim.cfm?id=#url.id#" addtoken="no">
    </cfoutput>


  <!--- /CFIF  #getcerts.recordcount# LT 1 --->
  </cfif>


    <!--- /CFIF   #form.key_id# is "" --->
    </cfif>

    <!--- /CFIF  StructKeyExists(form, "key_id") --->
    </cfif>


<!--- /CFIF #action# --->
</cfif> 




<!-- ERROR MESSAGES STARTS HERE -->



<cfif #m# is "1">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>DKIM Key was deleted successfully</cfoutput> 
      
  </div>
  
  <cfset session.m = 0>
  
  </cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Error adding DKIM Key. The DKIM Selector field cannot be empty</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Error adding DKIM Key. The DKIM Selector field is invalid. The DKIM Selector field can only contain uppercase/lowercase letters (A-Z, a-z) underscores (_), dahes (-) and periods (.)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "4">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Error adding DKIM Key. The DKIM Selector field you are attempting to use already exists</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "5">

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>DKIM Key was added successfully</cfoutput> 
      
  </div>
  
  <cfset session.m = 0>
  
  </cfif>

  <cfif #m# is "6">

    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      <cfoutput>DKIM Sign was enabled successfully</cfoutput> 
        
    </div>
    
    <cfset session.m = 0>
    
    </cfif>

    <cfif #m# is "7">

      <div class="alert alert-success alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>DKIM Sign was disabled successfully</cfoutput> 
          
      </div>
      
      <cfset session.m = 0>
      
      </cfif>



<!-- ERROR MESSAGES ENDS HERE -->

<span>
  <p>       

<!--- BACK TO RECIPIENTS BUTTON STARTS HERE --->
<a href="view_domains.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Domains</a>

<!--- BACK TO RECIPIENTS BUTTON ENDS HERE --->
&nbsp;
<!--- ADD DKIM KEY BUTTON STARTS HERE --->
<cfoutput>
  <a href="##adddkimkey_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-domainid="#getdomain.id#"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add DKIM Key</a>
  </cfoutput>
  <!--- ADD DKIM KEY BUTTON ENDS HERE --->





</p>


</span>

<cfinclude template="./inc/get_dkim_settings.cfm" />

<cfquery name="getdomainkeys" datasource="hermes">
  select id, domain, private, public, selector, enabled, generated from dkim_sign where domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdomain.domain#"> 
  </cfquery>


<!-- EDIT DOMAIN DKIM FORM STARTS HERE -->

<div class="card col-sm-8">

<!-- form start -->

  <form name="enable_dkim_sign" method="post" action="">
    <input type="hidden" name="action" value="Set DKIM Sign">

    <cfoutput>
    <input type="hidden" name="domain_id" value="#url.id#">
  </cfoutput>
       
      <div class="col-sm-6">
        <div class="form-group">

    
        <label><strong>Domain Name</strong></label>

         <cfoutput>
        <input type="text" name="domain_name" class="domain_name form-control" id="domain_name" value="#getdomain.domain#" readonly>
        </cfoutput>



        <cfif #getdomainkeys.recordcount# LT 1 OR #dkimenabled# is "2">

   

        <label><strong>Enable DKIM Sign</strong></label>

        <div class="alert alert-warning">
             
          <p><i class="icon fas fa-exclamation-triangle"></i>DKIM must be enabled AND you must have DKIM Key(s) generated before you can enable DKIM Sign for this domain</p>
          </div>
        
        <select class="form-control" name="dkimsignenable" data-placeholder="dkimsignenable" style="width: 100%;" id="dkimsignenable" disabled="disabled">

          <option value="2" selected >NO</option>
            <option value="1">YES (Recommended)</option>
          
            </select>   

                 <!-- class="form-group" -->  
                </div>

                <!--  class="col-sm-6" -->
                </div>

            <cfelseif #getdomainkeys.recordcount# GTE 1 AND #dkimenabled# is "1">

              <cfquery name="getenabledkey" datasource="hermes">
                select id, domain, private, public, selector, enabled, generated from dkim_sign where domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdomain.domain#"> and enabled='1' 
                </cfquery>

      
          <cfif #getenabledkey.recordcount# GTE 1>

            <cfquery name="getotherdomainkeys" datasource="hermes">
              select id, domain, private, public, selector, enabled, generated from dkim_sign where domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getdomain.domain#"> and id <> '#getenabledkey.id#' 
              </cfquery>

            <label><strong>Enable DKIM Sign</strong></label>

            <div class="alert alert-warning">
             
              <p><i class="icon fas fa-exclamation-triangle"></i>Ensure that the Public DKIM Key is in DNS <strong>BEFORE</strong> enabling DKIM Sign. Failure to do so may results in e-mail delivery issues</p>
              </div>
     
            <select class="form-control" name="dkimsignenable" data-placeholder="dkimsignenable" style="width: 100%;" id="dkimsignenable">
        
            <option value="1" selected>YES (Recommended)</option>
            <option value="2">NO</option>

          </select>  

          
      <div class="form-group" id="dkimsign">


        <label>DKIM Selector</label>
                               
        <select class="form-control" name="dkim_selector" data-placeholder="dkim_selector" style="width: 100%;" id="dkim_selector">
        
        <cfoutput>
        <option value="#getenabledkey.id#" selected>#getenabledkey.selector#</option>
        </cfoutput>

      <cfoutput query="getotherdomainkeys">
        <option value="#id#">#selector#</option>
      </cfoutput>

     
        </select>   
 

    <!--- class="form-group" class="form-group" id="dkimsign"  --->  
      </div>

          
                 <!-- class="form-group" -->  
                </div>

                <!--  class="col-sm-6" -->
                </div>

          <cfelseif #getenabledkey.recordcount# LT 1>

            <label><strong>Enable DKIM Sign</strong></label>

            <div class="alert alert-warning">
             
              <p><i class="icon fas fa-exclamation-triangle"></i>Ensure that the Public DKIM Key is in DNS <strong>BEFORE</strong> enabling DKIM Sign. Failure to do so may results in e-mail delivery issues</p>
              </div>
     

            <select class="form-control" name="dkimsignenable" data-placeholder="dkimsignenable" style="width: 100%;" id="dkimsignenable">

            <option value="2" selected>NO</option>
            <option value="1">YES (Recommended)</option>

          </select>  

          <div class="form-group" id="dkimsign" style="display:none;">


            <label>DKIM Selector</label>
                                   
            <select class="form-control" name="dkim_selector" data-placeholder="dkim_selector" style="width: 100%;" id="dkim_selector">
        
      
            <cfoutput query="getdomainkeys">
              <option value="#id#">#selector#</option>
            </cfoutput>
      
           
              </select>   
       
     
    
        <!--- class="form-group" class="form-group" id="dkimsign"  --->  
          </div>
    

                 <!-- class="form-group" -->  
                </div>

                <!--  class="col-sm-6" -->
                </div>


          
        <!--- #getenabledkey.recordcount# --->
          </cfif>
         
           
           <!--- /CFIF #getdomainkeys.recordcount#  --->
      </cfif>

                
  
      <div class="col-sm-6">
  
        <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
      
        <!--- div class="col-sm-6" --->
        </div>
 
    
        </form>  

        <br>

        <!--- div class="card col-sm-8" --->
      </div>





<!-- EDIT DOMAIN DKIM FORM ENDS HERE -->

<cfif #getdomainkeys.recordcount# GTE 1>


<form>


 
      
                  
        <table class="table table-striped"  id="sortTable" style="width:100%">
          <thead>
            <tr>
         
         <th>Delete</th>   
              <th>View Public Key</th>    
        <th>View Private Key</th>
   <th>DKIM Selector</th>

   <th>DNS Record</th>

   <th>DKIM Sign</th></th>
     
            
  
            </tr>
          </thead>
          <tbody>
  
          
  
  
  <cfoutput query="getdomainkeys">

    <cfif #generated# is "1" AND #private# is not "" AND #public# is not "">
  
      <!--- CHECK FOR EXISTENCE OF /OPT/HERMES/DKIM/domain.dkim.txt --->
      <cfset PublicFiletoRead="/opt/hermes/dkim/keys/#public#">
      <cfif fileExists(PublicFiletoRead)> 
      <cffile action="read" file="#PublicFiletoRead#" variable="dkimpublicfile">

      <cfelse>

      <cfset m="Edit Domain DKIM Configuration: #PublicFiletoRead# does NOT exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

      
      <!--- /CFIF fileExists(PublicFiletoRead) --->
      </cfif>

      <cfset rightPublic = "#trim(ListGetAt(dkimpublicfile, 2, "("))#">
      <cfset publicKey = "#trim(ListGetAt(rightPublic, 1, ")"))#">
      
      <!--- CHECK FOR EXISTENCE OF /OPT/HERMES/DKIM/domain.dkim.private --->
      <cfset PrivateFiletoRead="/opt/hermes/dkim/keys/#private#">
      <cfif fileExists(PrivateFiletoRead)> 
      <cffile action="read" file="#PrivateFiletoRead#" variable="dkimprivatefile">

      <cfelse>

      <cfset m="Edit Domain DKIM Configuration: #PrivateFiletoRead# does NOT exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      
      <!--- /CFIF fileExists(PrivateFiletoRead) --->
      </cfif>
    
    <!--- /CFIF #generated# is "1" AND #private# is not "" AND #public# is not "" --->
    </cfif>
      

 
  
    <td>
  
      <button a href="##deletekey_modal"  type="button" id="delete" class="btn btn-danger" data-toggle="modal" data-keyid="#id#"><i class="fa fa-trash"></i></button>
  
    </td>
  
  
    <td>
  
      <button a href="##viewPublickey_modal"  type="button" id="view" class="btn btn-secondary" data-toggle="modal" data-key='#publicKey#'><i class="fas fa-search"></i></button>
  
    </td>
  
  
    <td>
  
      <button a href="##viewPrivatekey_modal"  type="button" id="view" class="btn btn-secondary" data-toggle="modal" data-key='#dkimprivatefile#'><i class="fas fa-search"></i></button>
  
    </td>
  
    
  
  
  
  <td>#selector#</td>  

  <td>#selector#._domainkey.#getdomain.domain#</td>
  
  <cfif #enabled# is "1">

  <td>YES</td>

  <cfelse>
    <td>NO</td>

 <!--- /CFIF #enabled# is "1" --->
  </cfif>
  

  
  </tr>
  
  <!--- /CFOUTPUT query="getdomainkeys" --->
  </cfoutput>
  
          </tfoot>
        
  
        </table>


      
      </form> 


      
      <cfelseif #getdomainkeys.recordcount# LT 1>
      
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>No DKIM Keys were found</strong></cfoutput>
        </div>
      
        <!--- /CFIF FOR #getdomainkeys.recordcount# LT --->
      </cfif>
      
  

  
      <div>&nbsp;</div>
  






<div id="loader"></div>

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



<script>

$('#viewPublickey_modal').on('show.bs.modal', function(e) {
  var key = $(e.relatedTarget).data('key');
      $("#publickeyarea").html('<textarea rows="10" id="publickeyarea" name="publickeyarea">' + key + '</textarea>');
      });

  
  </script>


<script>

  $('#viewPrivatekey_modal').on('show.bs.modal', function(e) {
    var key = $(e.relatedTarget).data('key');
        $("#privatekeyarea").html('<textarea rows="10" id="privatekeyarea" name="privatekeyarea">' + key + '</textarea>');
        });
  
    
    </script>

<!--- DELETE KEY MODAL SCRIPT STARTS HERE  --->
<script>
  $('#deletekey_modal').on('show.bs.modal', function(e) {
      var key_id = $(e.relatedTarget).data('keyid');
      $(e.currentTarget).find('input[name="key_id"]').val(key_id);
  });
    </script>

<!--- DELETE KEY MODAL SCRIPT ENDS HERE  --->

<!--- ADD KEY MODAL SCRIPT STARTS HERE  --->
<script>
  $('#adddkimkey_modal').on('show.bs.modal', function(e) {
      var domain_id = $(e.relatedTarget).data('domainid');
      $(e.currentTarget).find('input[name="domain_id"]').val(domain_id);
  });
    </script>

<!--- ADD KEY MODAL SCRIPT ENDS HERE  --->


   <!--- SCRIPT TO DKIM SIGN ENABLE SCRIPT STARTS HERE  --->
   <script>

    $('#dkimsignenable').on('change',function(){
      if( $(this).val()==="2"){
      $("#dkimsign").hide()
      }
      else{
      $("#dkimsign").show()
      }
    });
    
    </script>

   



</html>