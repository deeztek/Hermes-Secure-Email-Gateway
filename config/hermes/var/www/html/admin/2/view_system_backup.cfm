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
    
    

<!--- ===========================================================================
     CLI-ONLY by design. Backup/restore is a long-running, infrequent,
     SSH-native operation. Wrapping it in a web UI buys nothing (web UI
     adds brittleness: page-reload kills progress, websocket timeouts,
     race conditions) and costs significant dev time on something
     sysadmins are already doing from a shell.

     This page is a pointer to the CLI, not a launcher. It exists so
     the sidebar entry isn't a dead link and so an admin who clicks
     "Backup/Restore" sees the canonical commands + a link to the full
     docs. No discovery list, no buttons, no actions -- the admin who
     ran the backup already knows where it landed (the CLI prints the
     path on success).
=========================================================================== --->

<div class="alert alert-info" role="alert">
  <h5 class="alert-heading"><i class="fas fa-terminal"></i> Backup &amp; Restore is CLI-only</h5>
  <p class="mb-0">Run backups and restores by SSH'ing into the Docker host and invoking the scripts below. This page is informational &mdash; there is no launch button by design. See the <a href="#" onClick="window.open('https://docs.deeztek.com/books/administrator-guide/page/backuprestore', '_blank'); return false;"><b>full Backup &amp; Restore documentation</b></a> for scope tradeoffs, the disaster-recovery flow, hypervisor-snapshot alternatives, and what NOT to do.</p>
</div>

<div class="card mb-3">
  <div class="card-header"><strong>Backup &mdash; hot mode by default, zero application downtime</strong></div>
  <div class="card-body">
    <p>Uses application-native hot-backup primitives: <code>mariadb-dump --single-transaction</code> for the six databases, <code>slapcat</code> for OpenLDAP, and live tar of mail tiers (Dovecot maildir/sdbox and Amavis quarantine use atomic-rename writes, so live tar is safe). For Nextcloud, the script briefly toggles <code>occ maintenance:mode --on</code> to pause NC user writes during the file tar (mail flow unaffected).</p>
    <p>The <code>-B</code> flag chooses what to back up:</p>
    <ul class="mb-3">
      <li><code>system</code> &mdash; Config + Data + 6 DB dumps + LDAP slapcat. Small + fast. Nightly default.</li>
      <li><code>archive</code> &mdash; Archive tier only (Amavis quarantine).</li>
      <li><code>vmail</code> &mdash; Vmail tier only (Dovecot mailboxes).</li>
      <li><code>nextcloud</code> &mdash; Nextcloud tier only (NC files).</li>
      <li><code>all</code> &mdash; Everything.</li>
    </ul>
    <pre class="bg-body-secondary p-3 mb-2"><code>sudo /opt/hermes-seg-docker-gl/scripts/system_backup.sh -P /mnt/backups -B system --yes
sudo /opt/hermes-seg-docker-gl/scripts/system_backup.sh -P /mnt/backups -B vmail
sudo /opt/hermes-seg-docker-gl/scripts/system_backup.sh -P /mnt/backups -B all  --yes</code></pre>
    <p class="mb-0 text-muted small">Add <code>--cold</code> for legal-hold / forensic snapshots that need absolute byte-level consistency at the cost of full-stack downtime. Add <code>--dry-run</code> to preview without changing anything. Run <code>system_backup.sh --help</code> for the full flag list.</p>
  </div>
</div>

<div class="card mb-3">
  <div class="card-header"><strong>Restore &mdash; replaces only the scopes present in the backup</strong></div>
  <div class="card-body">
    <p>Verifies the manifest + per-archive SHA256 BEFORE any destructive action, refuses on storage-topology mismatch unless <code>FORCE_REMAP=1</code> is set, stops the stack for the duration of the restore (always; even hot-mode backups restore cold), restores DBs via socket-auth <code>mariadb</code>, restores OpenLDAP via <code>slapadd</code>, rsyncs each in-scope tier from staging to its mount path with <code>--delete</code>, and restarts the stack. Reads the scope from the backup's manifest: restoring a <code>vmail</code> backup only touches <code>/mnt/vmail</code>; restoring an <code>archive</code> backup only touches <code>/mnt/archive</code>; etc.</p>
    <pre class="bg-body-secondary p-3 mb-2"><code>sudo /opt/hermes-seg-docker-gl/scripts/system_restore.sh -F /mnt/backups/hermes-backup-system-vYYMMDD-YYYYMMDDTHHMMSSZ.tar</code></pre>
    <p class="mb-0 text-muted small">If restoring onto a host with a different storage topology (different DATA_MOUNT etc.), prefix with <code>FORCE_REMAP=1</code>. Run <code>system_restore.sh --help</code> for full usage.</p>
  </div>
</div>

<div class="alert alert-warning" role="alert">
  <h6 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Do NOT use the legacy bare-metal CLI scripts</h6>
  <p class="mb-0">The pre-Docker <code>config/hermes/opt/hermes/scripts/system_backup.sh</code> and <code>system_restore.sh</code> scripts must NOT be run on a Docker host. The legacy restore extracts the backup tarball relative to the host filesystem root and will overwrite system directories &mdash; safe on the bare-metal install it was written for, destructive on Docker. Use only the Docker-aware scripts under <code>scripts/</code> as shown above.</p>
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