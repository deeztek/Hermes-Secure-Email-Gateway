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
  <title>Hermes SEG | System Users</title>

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


<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW STARTS HERE --->  
<style>
  .alert a {
    color: #fff;
    text-decoration: none;
}
</style>
<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW ENDS HERE --->  

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
            <h1 class="m-0">System Users</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">System Users</li>
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

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>System User was deleted successfully</cfoutput> 
      
  </div>
  
  <cfset session.m = 0>
  
  </cfif>


       <!--- ERROR MESSAGES END HERE --->



    
<span>
  <p>       


<a href="./inc/create_new.cfm?type=systemuser" class="btn btn-primary" role="button"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Create System User</a>

<!---
<button type="button" id="delete" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete</button>
--->
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


<cfquery name="getsystemusers" datasource="hermes">
  select id, username, email, first_name, last_name, access_control, system, applied from system_users
  
  </cfquery>
    
    <cfif #getsystemusers.recordcount# GTE 1>


                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>

            <!---
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            --->    
        
            <th>Edit</th>
            <th>Username</th>
            <th>E-Mail</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Access Control</th>
            <th>Built-In</th>
            <th>Active</th>
            
            
          

          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getsystemusers">


<!---
        <td><input type="checkbox" name="id" value="#id#"></td>
--->
        <td><a href="edit_system_user.cfm?id=#id#" class="btn btn-secondary" role="button"><i class="fas fa-edit"></i></a></td>

        <td>#username#</td>
         <td>#email#</td>
            <td>#first_name#</td>
            <td>#last_name#</td>

            <cfif #access_control# is "one_factor">
              <td>ONE FACTOR</td>
            <cfelse>

  <td>TWO FACTOR</td>
            </cfif>

            <cfif #system# is "1">
            <td>YES</td>
            <cfelse>
            <td>NO</td>
            </cfif>

            <cfif #applied# is "1">
              <td>YES</td>
              <cfelse>
              <td>NO</td>
              </cfif>
       
     

      

          </tr>

        </cfoutput>

        </tbody>
        
       
        <tfoot>
          <tr>
          
            <!---
            <th></th>
            --->
            <th>Edit</th>
            <th>Username</th>
            <th>E-Mail</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Access Control</th>
            <th>Built-In</th>
            <th>Active</th>
            
            
          </tr>
        </tfoot>
      

      </table>

    
    
 
    
    <cfelseif #getsystemusers.recordcount# LT 1>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No System Users were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getrecipients.recordcount --->
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