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
  <title>Hermes SEG | Domains</title>

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


<!--- BACK TO TOP BUTTON STYLE STARTS HERE ---> 
<style>
  #btn-back-to-top {
    position: fixed;
    bottom: 20px;
    right: 20px;
    display: none;
  }
  </style>

  <!--- BACK TO TOP BUTTON STYLE ENDS HERE ---> 

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
            <h1 class="m-0">Domains</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Domains</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

<!-- BACK TO TO TOP BUTTON STARTS HERE -->
<button
type="button"
class="btn btn-danger btn-floating btn-lg"
id="btn-back-to-top"
>
<i class="fas fa-arrow-up"></i>
</button>
 
<!-- BACK TO TO TOP BUTTON ENDS HERE -->
    
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

  
    <cfparam name = "step" default = "0">
    
    <cfparam name = "action" default = ""> 
    <cfif IsDefined("form.action") is "True">
    <cfif form.action is not "">
    <cfset action = form.action>
    </cfif></cfif>  
    
  

  
<!--- ERROR MESSAGES START HERE --->

<cfif #m# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Unable to delete domain with existing Internal Recipients. Please delete the Internal Recipients and try again (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "2">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Unable to delete domain with existing Virtual Recipients. Please delete the virtual Recipients and try again (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "3">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Unable to delete domain with existing System Postmaster E-mail address. Please delete the System Postmaster E-mail address and try again (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>


<cfif #m# is "4">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>Unable to delete domain with existing DKIM Key(s). Please delete the DKIM Key(s) and try again (Error Code: #m#)</cfoutput>
  </div>

  <cfset session.m = 0>

</cfif>

<cfif #m# is "7">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Domain was deleted successfully</cfoutput><br>

    <cfset session.m = 0>

  </div>
</cfif>



<!--- ERROR MESSAGES END HERE --->


        
  <!--- DELETE RECIPIENT MODAL HTML STARTS HERE --->
 

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteRecipientModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <!---
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        --->
          <h4 class="modal-title">Delete Domains(s) </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you to delete this domain? This action is irreversible!</p>
  
      </div>
      <div class="modal-footer">
        <form name="delete_domains" method="post" action="">
  
          <input type="hidden" name="action" value="deletedomain">
          <input type="hidden" name="domain_id" value=""/>
       


          <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

            </form>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
  </div>
  <!--- DELETE RECIPIENT MODAL HTML ENDS HERE --->
    


         
  
      <cfif #action# is "deletedomain">

        <cfif NOT StructKeyExists(form, "domain_id")>

          <cfset m="Delete Domain: form.domain_id does not exist">
          <cfinclude template="./inc/error.cfm">
          <cfabort>
      

          <cfelseif StructKeyExists(form, "domain_id")>

          <cfif #form.domain_id# is "">

            <cfset m="Delete Domain: form.domain_id is blank">
            <cfinclude template="./inc/error.cfm">
            <cfabort>

          <cfelseif #form.domain_id# is not "">      

          <cfinclude template="./inc/deletedomain.cfm">

          <cfset session.m=7>

          <cfoutput>
            <cflocation url="view_domains.cfm" addtoken="no">
            </cfoutput>

        
<!--- /CFIF #form.domain_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "domain_id") --->
</cfif>
    
<!--- /CFIF #action# is --->     
</cfif> 
    




<form>
    
<span>
  <p>       


<a href="./inc/create_new.cfm?type=domain" class="btn btn-primary" role="button"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Create Domain</a>
&nbsp;&nbsp;



</p>

<p>

</p>
</span>



<br>

<!---

<span>
  <p>  
<button type="button" class="btn btn-default">Select All</button>
 <button type="button" class="btn btn-default">Clear</button>
</p>
</span>
--->


<cfquery name="getdomains" datasource="hermes">
  select id, domain, policy_id, senders_id, recipients_id, action_taken from domains order by domain asc
  </cfquery>
    
    <cfif #getdomains.recordcount# GTE 1>

    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
    
            
            <th>Edit</th>
            <th>Edit DKIM</th>
            <th>Delete</th>
            <th>Domain</th>
            <th>Recipient Delivery</th>
            <th>Destination Address</th>
            <th>Destination Port</th>
            <th>Destination Use MX</th>
            <th>Internal Recipients</th>
            <th>Virtual Recipients</th>
            <th>Postmaster Address</th>
            <th>DKIM Key(s)</th>
           
          

          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getdomains">

  <cfquery name="gettransports" datasource="hermes">
    select domain, destination, port, mx from transport where domain='#domain#'
    </cfquery>

  <cfquery name="checkrecipients" datasource="hermes">
    select recipient, domain from recipients where recipient like '%#domain#%' and domain is NULL
    </cfquery>
    
    <cfquery name="checkvirtual" datasource="hermes">
    select virtual_address from virtual_recipients where virtual_address like '%#domain#%'
    </cfquery>
    
    <cfquery name="checkpostmaster" datasource="hermes">
    select parameter, value from system_settings where parameter = 'postmaster' and value like '%#domain#%'
    </cfquery>
    
    <cfquery name="checkdkim" datasource="hermes">
    select domain from dkim_sign where domain like '%#domain#%'
    </cfquery>


         <td><a href="edit_domain.cfm?id=#id#" class="btn btn-secondary" role="button"><i class="fas fa-edit"></i></a></td>

         <td><a href="edit_domain_dkim.cfm?id=#id#" class="btn btn-secondary" role="button"><i class="fas fa-lock"></i></a></td>

         <td>

          <button a href="##delete_modal"  type="button" id="delete" class="btn btn-danger" data-toggle="modal" data-domain="#id#"><i class="fas fa-trash-alt"></i></button>

        </td>

        <td>#domain#</td>

        <cfquery name="domainrecpolicy" datasource="hermes">
        select recipient, status from recipients where recipient = '@#domain#'
        </cfquery>

        <cfif #domainrecpolicy.status# is "">
        <td>SPECIFIED</td>
        <cfelseif #domainrecpolicy.status# is "OK">
          <td>ANY</td>
        <cfelse>
          <td>N/A</td>

          <!--- /CFIF #domainrecpolicy.status# --->
        </cfif>

<td>#gettransports.destination#</td>  

<td>#gettransports.port#</td>

<td>#gettransports.mx#</td>
        

  <cfif #checkrecipients.recordcount# GTE 1>
    <td>YES</td>
  <cfelse>
    <td>NO</td>

   <!--- /CFIF #checkrecipients.recordcount# --->
  </cfif>

  
  <cfif #checkvirtual.recordcount# GTE 1>
    <td>YES</td>
  <cfelse>
    <td>NO</td>

  <!--- /CFIF #checkvirtual.recordcount# --->
  </cfif>

  <cfif #checkpostmaster.recordcount# GTE 1>
    <td>YES</td>
  <cfelse>
    <td>NO</td>

  <!--- /CFIF #checkpostmaster.recordcount# --->
  </cfif>

  <cfif #checkdkim.recordcount# GTE 1>
    <td>YES</td>
  <cfelse>
    <td>NO</td>

  <!--- /CFIF #checkdkim.recordcount# --->
  </cfif>


    

          </tr>

        </cfoutput>

        </tbody>
        
       
        <tfoot>
          <tr>
      
            <th>Edit</th>
            <th>Edit DKIM</th>
            <th>Delete</th>
            <th>Domain</th>
            <th>Recipient Delivery</th>
            <th>Destination Address</th>
            <th>Destination Port</th>
            <th>Destination Use MX</th>
            <th>Internal Recipients</th>
            <th>Virtual Recipients</th>
            <th>Postmaster Address</th>
            <th>DKIM Signature</th>
           
          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    <cfelseif #getdomains.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Domains were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getdomains.recordcount --->
    </cfif>
    
    

    <div>&nbsp;</div>

    
    
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

  <!--- SCRIPT TO SHOW/HIDE SCHEDULE IMPORT FREQUENCY SCRIPT STARTS HERE  --->
   <!--- THIS SCRIPT WILL NOT WORK IF PLACED IN THE <HEAD></HEAD> SECTION  --->

  <script>

    $('#reports').on('change',function(){
      if( $(this).val()==="NO" ){
      $("#reportsfrequency").hide()
      }
      else{
      $("#reportsfrequency").show()
      }
    });
    
    </script>
  
  <!--- SCRIPT TO SHOW/HIDE SCHEDULE IMPORT FREQUENCY SCRIPT ENDS HERE  --->

 <!--- DELETE CERTIFICATE MODAL SCRIPT STARTS HERE  --->
<script>
  $('#delete_modal').on('show.bs.modal', function(e) {
      var domain_id = $(e.relatedTarget).data('domain');
      $(e.currentTarget).find('input[name="domain_id"]').val(domain_id);
  });
    </script>
<!--- DELETE CERTIFICATE MODAL SCRIPT ENDS HERE  --->

<!--- BACK TO TOP BUTTON SCRIPT STARTS HERE  --->

<script>

  //Get the button
  let mybutton = document.getElementById("btn-back-to-top");
  
  // When the user scrolls down 20px from the top of the document, show the button
  window.onscroll = function () {
    scrollFunction();
  };
  
  function scrollFunction() {
    if (
      document.body.scrollTop > 200 ||
      document.documentElement.scrollTop > 200
    ) {
      mybutton.style.display = "block";
    } else {
      mybutton.style.display = "none";
    }
  }
  // When the user clicks on the button, scroll to the top of the document
  mybutton.addEventListener("click", backToTop);
  
  function backToTop() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
  }
  
  </script>
  
  <!--- BACK TO TOP BUTTON SCRIPT ENDS HERE  --->



</html>