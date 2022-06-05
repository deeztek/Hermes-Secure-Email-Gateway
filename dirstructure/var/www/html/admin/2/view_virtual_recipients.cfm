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
  <title>Hermes SEG | Virtual Recipients</title>

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
      
          "order": [[ 0, "asc" ]]
      } );
  } );
    </script>

  

<script>

  $(document).ready(function() {
    $("#delete").click(function() {
      var deleterecipient = [];
      $.each($("input[name='id']:checked"), function() {
        deleterecipient.push($(this).val());
      });
      $('#delete_modal').modal('show').on('shown.bs.modal', function() {
      $("#deleteid").html('<input type="hidden" name="recipient_id" value=' + deleterecipient + '>');
      });
    });
  });
  
  </script>


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
            <h1 class="m-0">Virtual Recipients</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Virtual Recipients</li>
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
  
        <cfif #m# is "3">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Recipient(s) edited successfully</cfoutput><br>

       
        
          </div>

          <cfset session.m = 0>

        </cfif>
        
  
        <cfif #m# is "2">
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
            <cfoutput>Recipient(s) deleted successfully</cfoutput><br>
        
          </div>

          <cfset session.m = 0>

        </cfif>

        <cfif #m# is "1">

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
            <cfoutput>You must first select recipient(s) before clicking the Delete button</cfoutput>
          </div>

          <cfset session.m = 0>
        
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
          <h4 class="modal-title">Delete Recipient(s) </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you to delete the recipient(s) you have selected? This action is irreversible!</p>
  
      </div>
      <div class="modal-footer">
        <form name="delete_recipients" method="post" action="">
  
          <input type="hidden" name="action" value="deleterecipient">
          <div id="deleteid"></div>
       
  
<!---
          <button type="input" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Yes</button>
          --->

          <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

            </form>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
  </div>
  <!--- DELETE RECIPIENT MODAL HTML ENDS HERE --->
    



      
  
      <cfif #action# is "deleterecipient">

        <cfif NOT StructKeyExists(form, "recipient_id")>

          <cfset session.m = 1>

        <cflocation url="view_virtual_recipients.cfm" addtoken="no">
      
          <!---
          <cfinclude template="./inc/error.cfm">
          <cfabort>
          --->

          <cfelseif StructKeyExists(form, "recipient_id")>

          <cfif #form.recipient_id# is "">

            <cfset session.m = 1>

          <cflocation url="view_virtual_recipients.cfm" addtoken="no">
              
          <!---
          <cfinclude template="./inc/error.cfm">
          <cfabort>
          --->

          <cfelseif #form.recipient_id# is not "">      

<cfloop index="i" list="#form.recipient_id#" delimiters=",">

      <cfif IsValid("integer", #i#)>

        <cfquery name="getrecipient" datasource="hermes">
        select id, virtual_address, maps from virtual_recipients where id = <cfqueryparam value = #i# CFSQLType = "CF_SQL_INTEGER">
        </cfquery>

        <cfif #getrecipient.recordcount# GTE 1>

          <cfset delete_id = #getrecipient.id#>

          <cfinclude template="./inc/delete_virtual_recipients.cfm">

          
            <cfoutput>
            #i#<br>
          </cfoutput>
        

          <!--- /CFIF #getrecipient.recordcount# --->
        </cfif>
      
          <!--- /CFIF IsValid("integer", #i#) --->
        </cfif>
      
        
        </cfloop>
  
        <cfset session.m = 2>


  <cflocation url="view_virtual_recipients.cfm" addtoken="no">
 

<!--- /CFIF #form.recipient_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "recipient_id") --->
</cfif>

    
      <!--- /CFIF #action# is --->     
    </cfif> 
    

  <!--- DEBUGGING CODE BELOW --->
  <!---
  <cfif #action# is "deleterecipient">

    <cfif NOT StructKeyExists(form, "recipient_id")>
    
      <cfset m="recipient_id does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
       <cfelseif StructKeyExists(form, "recipient_id")>
      <cfif #form.recipient_id# is "">
      <cfset m="recipient_id is blank">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
      <cfelseif #form.recipient_id# is not "">
      <cfset theCustId = #form.recipient_id#>
      </cfif>
      </cfif>

      
   
        <cfoutput>
       TheCustID: #theCustId#<br>
      </cfoutput>
  
      

<cfloop index="i" list="#form.recipient_id#" delimiters=",">

  <cfif IsValid("integer", #i#)>
  

      
        <cfoutput>
        Index: #i#<br>
      </cfoutput>
    
  
      <!--- /CFIF IsValid("integer", #i#) --->
    </cfif>

    </cfloop>

  
  <!--- /CFIF #action# is --->     
</cfif>
--->

<form>
    
<span>
  <p>       


<a href="add_virtual_recipients.cfm" class="btn btn-primary" role="button"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Create Recipient(s)</a>
&nbsp;&nbsp;

<button type="button" id="delete" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete</button>

</p>

<p>

</p>
</span>









<div class="alert alert-warning">
         
  <p><i class="icon fas fa-exclamation-triangle"></i>Virtual Recipients allow you to add a virtual email address that will deliver email to an internal or external recipient <strong>while bypassing ALL content checking.</strong></p>
  </div>


<cfquery name="getvirtual" datasource="hermes">
select * from virtual_recipients order by virtual_address asc
  </cfquery>
    
    <cfif #getvirtual.recordcount# GTE 1>

    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            <th>Edit</th>
            <th>Recipient</th>
            <th>Delivers To</th>
           
            
          

          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getvirtual">



        <td><input type="checkbox" name="id" value="#id#"></td>


          <td><a href="edit_virtual_recipient.cfm?id=#id#" class="btn btn-secondary" role="button"><i class="fas fa-edit"></i></a></td>
  
    

        
        <td>#virtual_address#</td>
         <td>#maps#</td>
  

      

          </tr>

        </cfoutput>

        </tbody>
        
       
        <tfoot>
          <tr>
            <th></th>
            <th>Edit</th>
              <th>Recipient</th>
            <th>Delivers To</th>
          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    <cfelseif #getvirtual.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No Virtual Recipients were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getvirtual.recordcount --->
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

  <!--- SCRIPT TO CHECK/UNCHECK ALL CHECKBOXES ON THE PAGE STARTS HERE --->
     <!--- THIS SCRIPT WILL NOT WORK IF PLACED IN THE <HEAD></HEAD> SECTION  --->
  <script>
    $('#selectAll').click(function() {
      if(this.checked) {
          $(':checkbox').each(function() {
              this.checked = true;                        
          });
      } else {
         $(':checkbox').each(function() {
              this.checked = false;                        
          });
      } 
    });
    </script>
  <!--- SCRIPT TO CHECK/UNCHECK ALL CHECKBOXES ON THE PAGE ENDS HERE --->

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