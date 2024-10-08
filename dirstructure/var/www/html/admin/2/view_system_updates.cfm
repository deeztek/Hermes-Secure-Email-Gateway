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


    
<div class="alert alert-warning" role="alert">
  System Update is done in the CLI. More information can be found on our <a href="#" onClick="window.open('https://docs.deeztek.com/books/hermes-seg-administrator-guide/page/system-update', '_blank')"><b>System Update</b></a> documentation.

  
</div>

    

    
    
   
    
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

<!--- EDIT INSTALL UPDATE MODAL SCRIPT STARTS HERE  --->
<script>
  $('#installupdate_modal').on('show.bs.modal', function(e) {
var file = $(e.relatedTarget).data('file');
$(e.currentTarget).find('input[name="InstallFile"]').val(file);

var build = $(e.relatedTarget).data('build');
$(e.currentTarget).find('input[name="build"]').val(build);

var build = $(e.relatedTarget).data('build');
$(e.currentTarget).find('input[name="BuildNo"]').val(build);

var released = $(e.relatedTarget).data('released');
$(e.currentTarget).find('input[name="released"]').val(released);


  });


    </script>

<!--- EDIT INSTALL UPDATE MODAL SCRIPT ENDS HERE  --->


<!--- EDIT INSTALL UPDATE MODAL MYSQL SCRIPT STARTS HERE  --->
<script>
  $('#installupdate_modal_mysql').on('show.bs.modal', function(e) {
var file = $(e.relatedTarget).data('file');
$(e.currentTarget).find('input[name="file"]').val(file);

var build = $(e.relatedTarget).data('build');
$(e.currentTarget).find('input[name="build"]').val(build);

var released = $(e.relatedTarget).data('released');
$(e.currentTarget).find('input[name="released"]').val(released);


  });


    </script>

<!--- EDIT INSTALL UPDATE MODAL MYSQL SCRIPT ENDS HERE  --->


</html>