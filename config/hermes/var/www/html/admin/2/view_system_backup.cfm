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
  <title>Hermes SEG | Backup/Restore</title>

  <cfinclude template="./inc/html_head.cfm" />
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
            <h1 class="m-0">Backup/Restore</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Backup/Restore</li>
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
    
    

<div class="alert alert-warning" role="alert">
  <h5 class="alert-heading"><i class="fas fa-tools"></i> Backup &amp; Restore &mdash; Coming Soon</h5>
  <p>First-class Docker-aware backup/restore tooling is in development. It is <strong>not yet shipped</strong> in this release. Progress is tracked at
    <a href="#" onClick="window.open('https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/219', '_blank'); return false;"><b>#219 (system_backup.sh)</b></a>
    and
    <a href="#" onClick="window.open('https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues/220', '_blank'); return false;"><b>#220 (system_restore.sh)</b></a>.
  </p>
  <hr>
  <p class="mb-2"><strong>Recommended interim strategy &mdash; hypervisor / VM snapshots.</strong> Take a snapshot of the entire Hermes host VM (Proxmox, VMware, KVM, AWS EBS, Azure Disk, etc.) with the VM either powered off or quiesced through your hypervisor's guest-tools integration. This is the only backup method we currently recommend for Docker installs &mdash; it captures every storage tier, the databases, and container state in a single consistent point-in-time image.</p>
  <p class="mb-0"><strong>Do NOT use the legacy <code>/opt/hermes/scripts/system_backup.sh</code> and <code>system_restore.sh</code> scripts</strong> referenced in older bare-metal documentation. The restore script extracts the backup tarball relative to the host filesystem root and will overwrite host directories &mdash; safe on a legacy bare-metal install where the backup originated from that same layout, dangerous on a Docker host where it does not. Do not tar a running <code>/mnt/data</code>, <code>/mnt/vmail</code>, <code>/mnt/files</code>, or <code>/mnt/archive</code> while containers are writing to them.</p>
</div>
    








    
    
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
</main><!-- replaced content-wrapper -->


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