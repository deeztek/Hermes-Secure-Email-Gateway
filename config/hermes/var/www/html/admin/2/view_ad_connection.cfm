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
  <title>Hermes SEG | AD Integration</title>

  <cfinclude template="./inc/html_head.cfm" />
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
      [ 10, 25, 50, -1 ],
      [ '10 rows', '25 rows', '50 rows', 'Show all' ]

    ],
        "order": [[ 1, "asc" ]]
    } );
} );
  </script>

<!---

<script type="text/javascript" language="javascript">
  
  function eventCheckBox() {
	let checkbox1 = document.getElementById("check_1");
  checkbox1.checked = !checkbox1.checked;
  
  let checkbox2 = document.getElementById("check_2");
  checkbox2.checked = !checkbox2.checked;
}
  
  </script>
--->

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
            <h1 class="m-0">AD Integration</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">AD Integration</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

  <!--- Pro Edition License Check --->
  <cfinclude template="./inc/license_check.cfm" />
    
    <cfparam name = "errormessage" default = "0">
    
    <cfparam name = "m2" default = "0"> 
    <cfif StructKeyExists(url, "m2")>
    <cfif url.m2 is not "">
    <cfset m2 = url.m2>
  
      <!--- /CFIF for StructKeyExists --->
    </cfif>
  
    <!--- /CFIF for url.m2 is not "" --->
    </cfif>

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
  
        <!--- ERROR MESSAGES START HERE --->
  
        
  
        <cfif #m# is "2">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Connection deleted successfully</cfoutput><br>
        
          </div>

          <cfset session.m = 0>

        </cfif>
      
        
        
        <!--- ERROR MESSAGES END HERE --->
    
    
    
    
    <!-- CFML CODE ENDS HERE -->
    
    
    <!-- CFML APPLICATION ALERTS STARTS HERE -->
    
    <!---
    
        <cfif #errormessage# is "1">
    
            <div class="alert alert-success alert-dismissible">
              <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
              <h4><i class="icon fa fa-check"></i> Success!</h4>
              <cfoutput>Connection deleted.</cfoutput>
            </cfif>   
    
          --->
    
    <!-- CFML APPLICATION ALERTS ENDS HERE -->
    
    
    
<span>
  <p>       


<a href="./inc/create_new.cfm?type=adconnection" class="btn btn-primary" role="button"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Create Connection</a>
</p>



    <!-- ADD AD CONNECTION FORM STARTS HERE -->
    
    <cfquery name="getconnections" datasource="hermes">
      select * from ad_integration order by entry_name asc
      </cfquery>
    
    <cfif #getconnections.recordcount# GTE 1>
    
    <!--- READ ENCRYPTION KEY --->
    <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">
    
    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
         
            <th>Edit</th>
            <!---
            <th>Delete</th>
          --->
            <th>Friendly Name</th>
            <th>Domain Controller</th>
            <th>Distinguished Name</th>
            <th>Object Class</th>
            <th>Nebios Name</th>
            <th>Domain User</th>
            <th>Scheduled</th>


          

          </tr>
        </thead>
        <tbody>



      <cfoutput query="getconnections">
    
    <!-- DECRYPT USERNAME -->
    <cfset decryptedUsername=decrypt(username, #theKey#, "AES", "Base64")>

    
    
          <tr>
            <td>

              <a href="edit_ad_connection.cfm?id=#id#" class="btn btn-secondary" role="button"><i class="fa fa-edit"></i></a>

            </td>
      
            <!---
            <td>
            
              <input type="hidden" name="id" value="#id#">
              <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="##deleteProductModal" data-productid="#id#" data-productname="#entry_name#">
              <i class="fa fa-trash"></i></button>
            
            
           
            <!--- </form> --->
          </td>
        --->
            <td>#entry_name#</td>
            <td>#dc_name#</td>
            <td>#fqdn_domain#</td>
            <td>#objectclass#</td>
            <td>#netbios_domain#</td>
            <td>#decryptedUsername#</td>

            <cfif #scheduled# is "1">
            
              <cfquery name="getcrontabentry" datasource="hermes">
              select value, label from crontab_entries where value = '#scheduled_interval#'
              </cfquery>
              
              <cfif #getcrontabentry.recordcount# GTE 1>
              <td>#getcrontabentry.label#</td> 
              <cfelse>
                <td>N/A</td> 
  
              <!--- /CFIF FOR getcrontabentry.recordcount --->
              </cfif>
  
              <cfelse>
                <td>N/A</td> 
  
                <!--- /CFIF FOR #scheduled# is --->
              </cfif>

              

          
              
              
            
       

    
    
      
    
          </tr>

        </cfoutput>
        </tbody>
        
        <tfoot>
          <tr>
             
            <th>Edit</th>
            <!---
            <th>Delete</th>
          --->
            <th>Friendly Name</th>
            <th>Domain Controller</th>
            <th>Distinguished Name</th>
            <th>Object Class</th>
            <th>Nebios Name</th>
            <th>Domain User</th>
            <th>Scheduled</th>


          

          </tr>
        </tfoot>
       
      </table>
    
    
    <cfelseif #getconnections.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Active Directory Connections were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getconnections.recordcount --->
    </cfif>
    
    
    
    <!-- ADD AD CONNECTION FORM STARTS HERE -->
    
    
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
</main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->



</body>


</html>