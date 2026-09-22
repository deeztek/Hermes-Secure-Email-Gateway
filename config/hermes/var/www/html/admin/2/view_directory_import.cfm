<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

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

<!---
  Review staged directory results (#332).

  Apply runs INLINE on this page rather than behind a redirect, because it is
  slow and the admin needs to watch it. The cheap actions (skip, resync) do
  redirect, in the usual session.m + cflocation shape.
--->

<cfparam name="url.connection_id" default="0">
<cfparam name="form.action"       default="">

<!--- Cheap actions redirect. Apply does not: it is handled after the page
      shell is open, further down. --->
<cfif form.action IS "skip">
  <cfparam name="form.ids" default="">
  <cfif Len(Trim(form.ids))>
    <cfquery datasource="hermes">
      UPDATE directory_import_staging
         SET status = 'skipped'
       WHERE status = 'pending'
         AND id IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#form.ids#">)
    </cfquery>
  </cfif>
  <cfset session.m = "di_skipped">
  <cflocation url="view_directory_import.cfm?connection_id=#val(url.connection_id)#" addtoken="no">
</cfif>

<cfif form.action IS "resync">
  <cftry>
    <cfhttp method="get"
            url="http://localhost:8888/schedule/directory_sync.cfm?connection_id=#val(url.connection_id)#"
            timeout="600" result="syncCall">
    <cfset session.m = "di_synced">
    <cfcatch>
      <cfset session.m = "di_sync_error">
    </cfcatch>
  </cftry>
  <cflocation url="view_directory_import.cfm?connection_id=#val(url.connection_id)#" addtoken="no">
</cfif>

<cfinclude template="./inc/html_head.cfm" />

<script>
$(document).ready(function() {
    $('#newTable').DataTable({
        dom: 'Blfrtip',
        buttons: ['copy', 'csv', 'excel', 'print'],
        lengthMenu: [[25, 50, 100, -1], [25, 50, 100, "All"]],
        order: [[1, 'asc']]
    });
    $('#otherTable').DataTable({
        dom: 'Blfrtip',
        buttons: ['copy', 'csv', 'excel', 'print'],
        lengthMenu: [[25, 50, 100, -1], [25, 50, 100, "All"]]
    });

    $('#checkAllNew').on('click', function() {
        $('.rowcheck').prop('checked', this.checked);
    });

    $('#importForm').on('submit', function() {
        if ($('.rowcheck:checked').length === 0) {
            alert('Select at least one address to import.');
            $('.preloader').hide();
            return false;
        }
        return true;
    });
});
</script>

</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

<cfinclude template="./inc/top_navbar.cfm" />
<cfinclude template="./inc/main_sidebar.cfm" />

<main class="app-main">
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6"><h1 class="m-0">Review Provisioning Results</h1></div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
                    <li class="breadcrumb-item"><a href="view_directory_connections.cfm">Auto-Provisioning</a></li>
                    <li class="breadcrumb-item active">Review</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<div class="content">
<div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
    <cfif session.m NEQ "">
        <cfset m = session.m>
        <cfset session.m = "">
    </cfif>
</cfif>

<cfif m EQ "di_skipped">
  <div class="alert alert-success alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <i class="fas fa-check"></i>&nbsp;Selected entries were skipped. The next sync will not offer them again unless they change.</div>
</cfif>
<cfif m EQ "di_synced">
  <div class="alert alert-info alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <i class="fas fa-sync"></i>&nbsp;Sync finished.</div>
</cfif>
<cfif m EQ "di_sync_error">
  <div class="alert alert-danger alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <i class="fas fa-ban"></i>&nbsp;The sync could not be started.</div>
</cfif>

<a href="view_directory_connections.cfm" class="btn btn-secondary mb-3" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Auto-Provisioning</a>

<cfquery name="getConn" datasource="hermes">
  SELECT c.*, m.domain_name AS mapping_domain
    FROM directory_connections c
    LEFT JOIN remoteauth_mappings m ON m.id = c.remoteauth_mapping_id
   WHERE c.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.connection_id)#">
</cfquery>

<cfif getConn.recordcount LT 1>
  <div class="alert alert-danger"><i class="fas fa-ban"></i>&nbsp;No such directory.</div>
  <a href="view_directory_connections.cfm" class="btn btn-secondary"><i class="fas fa-undo"></i>&nbsp;Back</a>
  </div></div></main>
  <cfinclude template="./inc/main_footer.cfm" />
  </body></html>
  <cfabort>
</cfif>

<cfoutput>
<div class="card card-secondary card-outline mb-3">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-server"></i>&nbsp;#EncodeForHTML(getConn.entry_name)#</h3></div>
  <div class="card-body">
    <dl class="row mb-0">
      <dt class="col-sm-3">Authentication</dt>
      <dd class="col-sm-9">
        <!--- The missing-mapping warning only means anything for remote auth.
              Shown unconditionally it told a Local directory that nobody would
              be able to sign in, which is the opposite of true: local
              recipients get a Hermes password and the reset flow. --->
        <cfif getConn.auth_type IS "remote">
          <span class="badge bg-primary"><i class="fas fa-cloud me-1"></i>Remote</span>
          <cfif Len(Trim(getConn.mapping_domain))>
            <small class="text-muted ms-1">against #EncodeForHTML(Trim(getConn.mapping_domain))#</small>
          <cfelse>
            <span class="badge bg-warning text-dark ms-1">Not linked</span>
            <small class="text-muted ms-1">Remote authentication needs a RemoteAuth mapping. Import is refused until one is chosen, or the directory is switched to Local.</small>
          </cfif>
        <cfelse>
          <span class="badge bg-secondary">Local</span>
          <small class="text-muted ms-1">Recipients get a Hermes password and are sent a reset link. No RemoteAuth mapping is involved.</small>
        </cfif>
      </dd>
      <dt class="col-sm-3">Last run</dt>
      <dd class="col-sm-9">
        <cfif Len(getConn.last_run_status)>
          <cfif getConn.last_run_status IS "ok">
            <span class="badge bg-success">OK</span>
          <cfelse>
            <span class="badge bg-danger">Failed</span>
          </cfif>
          #DateFormat(getConn.last_run_at, "yyyy-mm-dd")# #TimeFormat(getConn.last_run_at, "HH:mm")#
          <br><small>#EncodeForHTML(getConn.last_run_message)#</small>
        <cfelse>
          <span class="text-muted">Never run</span>
        </cfif>
      </dd>
    </dl>
  </div>
  <div class="card-footer">
    <form method="post" action="view_directory_import.cfm?connection_id=#getConn.id#" style="display:inline">
      <input type="hidden" name="action" value="resync">
      <button type="submit" class="btn btn-secondary btn-sm"><i class="fas fa-sync"></i>&nbsp;Sync Now</button>
    </form>
  </div>
</div>
</cfoutput>

<!--- ================= APPLY RUNS HERE, INLINE ================= --->
<cfif form.action IS "apply">
  <cfparam name="form.ids" default="">
  <cfset applyConnId = val(url.connection_id)>
  <cfset applyIds    = form.ids>
  <cfinclude template="./inc/directory_import_apply.cfm">
</cfif>

<cfquery name="getNew" datasource="hermes">
  SELECT id, email, first_name, last_name, display_name, source_dn
    FROM directory_import_staging
   WHERE connection_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.connection_id)#">
     AND status = 'pending' AND action = 'insert'
   ORDER BY email
</cfquery>

<cfquery name="getOther" datasource="hermes">
  SELECT email, action, status, error_message, applied_at
    FROM directory_import_staging
   WHERE connection_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.connection_id)#">
     AND NOT (status = 'pending' AND action = 'insert')
   ORDER BY FIELD(action,'vanished','existing'), email
   LIMIT 2000
</cfquery>

<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-user-plus"></i>&nbsp;New Addresses</h3>
  </div>
  <div class="card-body">
  <cfif getNew.recordcount LT 1>
    <p class="mb-0 text-muted">Nothing pending. Either everything has been imported or skipped, or the last sync found no new addresses.</p>
  <cfelse>
    <p class="text-muted">
      These exist in the directory and have no recipient in Hermes yet.
      Importing creates them with <strong>encryption disabled</strong>; turn S/MIME or PGP on afterwards from Relay Recipients using Bulk Edit.
    </p>
    <cfoutput>
    <form method="post" action="view_directory_import.cfm?connection_id=#getConn.id#" id="importForm">
    <input type="hidden" name="action" value="apply">
    <table id="newTable" class="table table-bordered table-striped table-hover">
      <thead>
        <tr>
          <th><input type="checkbox" id="checkAllNew"></th>
          <th>E-mail</th><th>First</th><th>Last</th><th>Directory DN</th>
        </tr>
      </thead>
      <tbody>
      <cfloop query="getNew">
        <tr>
          <td><input type="checkbox" class="rowcheck" name="ids" value="#getNew.id#"></td>
          <td>#EncodeForHTML(getNew.email)#</td>
          <td>#EncodeForHTML(getNew.first_name)#</td>
          <td>#EncodeForHTML(getNew.last_name)#</td>
          <td><small class="text-muted">#EncodeForHTML(Left(getNew.source_dn, 90))#</small></td>
        </tr>
      </cfloop>
      </tbody>
    </table>
    <button type="submit" class="btn btn-primary">
      <i class="fas fa-user-plus"></i>&nbsp;Import Selected
    </button>
    <button type="submit" class="btn btn-outline-secondary"
            onclick="document.getElementById('importForm').elements['action'].value='skip'">
      <i class="fas fa-ban"></i>&nbsp;Skip Selected
    </button>
    </form>
    </cfoutput>
  </cfif>
  </div>
</div>

<div class="card card-secondary card-outline">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-clipboard-list"></i>&nbsp;Everything Else</h3></div>
  <div class="card-body">
    <p class="text-muted">
      <strong>No longer in directory</strong> is reported, never acted on. A recipient
      is not deleted because they stopped appearing upstream: a relay domain set to
      ANY still delivers their mail, and removing them would strip portal access and
      encryption from a live user. Remove them by hand from Relay Recipients if that
      is what you want.
    </p>
    <table id="otherTable" class="table table-bordered table-striped table-hover">
      <thead><tr><th>E-mail</th><th>Finding</th><th>State</th><th>Note</th></tr></thead>
      <tbody>
      <cfoutput query="getOther">
        <tr>
          <td>#EncodeForHTML(getOther.email)#</td>
          <td>
            <cfif getOther.action IS "vanished">
              <span class="badge bg-warning text-dark">No longer in directory</span>
            <cfelseif getOther.action IS "existing">
              <span class="badge bg-secondary">Already a recipient</span>
            <cfelse>
              <span class="badge bg-light text-dark">#EncodeForHTML(getOther.action)#</span>
            </cfif>
          </td>
          <td>
            <cfif getOther.status IS "applied">
              <span class="badge bg-success">Imported</span>
            <cfelseif getOther.status IS "skipped">
              <span class="badge bg-secondary">Skipped</span>
            <cfelseif getOther.status IS "failed">
              <span class="badge bg-danger">Failed</span>
            <cfelse>
              <span class="badge bg-info">Pending</span>
            </cfif>
          </td>
          <td><small class="text-muted">#EncodeForHTML(Left(getOther.error_message, 120))#</small></td>
        </tr>
      </cfoutput>
      </tbody>
    </table>
  </div>
</div>

</div>
</div>
</main>

<cfinclude template="./inc/main_footer.cfm" />

</body>
</html>
