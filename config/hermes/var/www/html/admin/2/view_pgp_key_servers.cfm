<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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
  <title>Hermes SEG | PGP Key Servers</title>
  <cfinclude template="./inc/html_head.cfm" />
</head>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">PGP Key Servers</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">PGP Key Servers</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m_pgp") AND session.m_pgp is not "">
  <cfset m = session.m_pgp>
  <cfset session.m_pgp = "">
</cfif>

<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ===================== --->
<!--- ACTION: ADD SERVER   --->
<!--- ===================== --->
<cfif action is "add">
  <cfparam name="form.keyserver" default="">
  <cfparam name="form.note" default="">

  <cfset ks = trim(form.keyserver)>
  <cfset ks_note = trim(form.note)>

  <cfif ks is "">
    <cfset session.m_pgp = 1>
    <cflocation url="view_pgp_key_servers.cfm" addtoken="no">
  </cfif>

  <!--- Validate hostname format --->
  <cfset tempEmail = "bob@" & ks>
  <cfif NOT IsValid("email", tempEmail)>
    <cfset session.m_pgp = 2>
    <cflocation url="view_pgp_key_servers.cfm" addtoken="no">
  </cfif>

  <!--- Check duplicate --->
  <cfquery name="checkexists" datasource="hermes">
    SELECT COUNT(*) as cnt FROM pgp_keyservers WHERE keyserver = <cfqueryparam value="#ks#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkexists.cnt GT 0>
    <cfset session.m_pgp = 3>
    <cflocation url="view_pgp_key_servers.cfm" addtoken="no">
  </cfif>

  <cfquery datasource="hermes">
    INSERT INTO pgp_keyservers (keyserver, note)
    VALUES (
      <cfqueryparam value="#ks#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#ks_note#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <cfset session.m_pgp = 4>
  <cflocation url="view_pgp_key_servers.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: DELETE       --->
<!--- ===================== --->
<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <cfquery datasource="hermes">
      DELETE FROM pgp_keyservers WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.m_pgp = 5>
  </cfif>
  <cflocation url="view_pgp_key_servers.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: BULK DELETE  --->
<!--- ===================== --->
<cfif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <cfquery datasource="hermes">
          DELETE FROM pgp_keyservers WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
      </cfif>
    </cfloop>
    <cfset session.m_pgp = 5>
  </cfif>
  <cflocation url="view_pgp_key_servers.cfm" addtoken="no">
</cfif>

<!--- Load data --->
<cfquery name="get_keyservers" datasource="hermes">
  SELECT * FROM pgp_keyservers ORDER BY keyserver ASC
</cfquery>

<!--- ALERTS --->
<cfif m is 1>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The Key Server field cannot be empty.</p></div>
</cfif>
<cfif m is 2>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>The Key Server address is invalid. Enter a hostname only (e.g. keys.openpgp.org). Do not include http:// or port numbers.</p></div>
</cfif>
<cfif m is 3>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Duplicate</h4><p>That Key Server already exists.</p></div>
</cfif>
<cfif m is 4>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>PGP Key Server added.</p></div>
</cfif>
<cfif m is 5>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>PGP Key Server(s) deleted.</p></div>
</cfif>

<!--- PAGE GUIDE --->
<div class="callout callout-info mb-4">
  <h5><i class="fas fa-info-circle"></i> Page Guide</h5>
  <p class="mb-0">PGP Key Servers are used by Ciphermail to look up public PGP keys for recipients when sending PGP-encrypted email. Enter the hostname only (e.g. <code>keys.openpgp.org</code>) -- do not include <code>http://</code>, <code>https://</code>, or port numbers.</p>
</div>

<!--- ADD KEY SERVER --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title">
      <button type="button" class="btn btn-sm btn-outline-secondary me-2" id="toggleAddServer" title="Expand">
        <i class="fas fa-chevron-down"></i>
      </button>
      <i class="fas fa-plus-circle"></i> Add PGP Key Server
    </h3>
  </div>
  <div class="collapse" id="addServerCollapse">
    <div class="card-body">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="add">
        <div class="row mb-3">
          <div class="col-md-5">
            <label for="keyserver" class="form-label">Key Server</label>
            <input type="text" class="form-control" id="keyserver" name="keyserver" maxlength="255" required
              placeholder="e.g. keys.openpgp.org">
            <small class="text-muted">Hostname only, no http:// or port numbers</small>
          </div>
          <div class="col-md-5">
            <label for="note" class="form-label">Note <span class="text-muted">(optional)</span></label>
            <input type="text" class="form-control" id="note" name="note" maxlength="255"
              placeholder="e.g. Primary key server">
          </div>
          <div class="col-md-2 d-flex align-items-end">
            <button type="submit" class="btn btn-primary w-100"
              onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
              <i class="fas fa-plus"></i> Add
            </button>
          </div>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- EXISTING KEY SERVERS --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list"></i> Existing PGP Key Servers</h3>
  </div>
  <div class="card-body">
    <cfif get_keyservers.recordcount LT 1>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No PGP Key Servers configured.
      </div>
    <cfelse>
      <form id="bulkDeleteForm" method="post">
        <input type="hidden" name="action" value="bulk_delete">
        <input type="hidden" name="selected_ids" id="selectedIds" value="">

        <div class="mb-2">
          <button type="button" class="btn btn-sm btn-danger" id="bulkDeleteBtn" disabled
            onclick="submitBulkDelete();">
            <i class="fas fa-trash"></i> Delete Selected
          </button>
        </div>

        <div class="table-responsive">
        <table id="keyserverTable" class="table table-bordered table-hover table-striped" style="width:100%">
          <thead>
            <tr>
              <th style="width: 3%"><input type="checkbox" id="selectAll"></th>
              <th style="width: 50px"></th>
              <th>Key Server</th>
              <th>Note</th>
            </tr>
          </thead>
          <tbody>
            <cfoutput query="get_keyservers">
              <tr>
                <td><input type="checkbox" class="row-checkbox" value="#id#"></td>
                <td>
                  <button type="button" class="btn btn-sm btn-danger" title="Delete"
                    onclick="confirmDelete('#id#', '#encodeForJavaScript(keyserver)#');">
                    <i class="fas fa-trash-alt"></i>
                  </button>
                </td>
                <td>#encodeForHTML(keyserver)#</td>
                <td>#encodeForHTML(note)#</td>
              </tr>
            </cfoutput>
          </tbody>
        </table>
        </div>
      </form>
    </cfif>
  </div>
</div>

<!--- DELETE FORM --->
<form id="deleteForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="delete">
  <input type="hidden" name="delete_id" id="delete_id" value="">
</form>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>


<script>
$(document).ready(function() {
  // Toggle
  $('#toggleAddServer').on('click', function() { $('#addServerCollapse').collapse('toggle'); });
  $('#addServerCollapse').on('shown.bs.collapse', function() {
    $('#toggleAddServer').find('i').removeClass('fa-chevron-down').addClass('fa-chevron-up');
    $('#toggleAddServer').attr('title', 'Collapse');
  });
  $('#addServerCollapse').on('hidden.bs.collapse', function() {
    $('#toggleAddServer').find('i').removeClass('fa-chevron-up').addClass('fa-chevron-down');
    $('#toggleAddServer').attr('title', 'Expand');
  });

  // DataTable
  if ($('#keyserverTable').length) {
    $('#keyserverTable').DataTable({
      dom: 'Blfrtip',
      buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
      stateSave: true,
      lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
      order: [[2, 'asc']],
      columnDefs: [
        { orderable: false, targets: [0, 1] },
        { searchable: false, targets: [0, 1] }
      ]
    });
  }

  // Bulk select
  var selectedIds = new Set();
  $('#selectAll').on('change', function() {
    var checked = this.checked;
    $('.row-checkbox:visible').each(function() {
      this.checked = checked;
      if (checked) selectedIds.add(this.value); else selectedIds.delete(this.value);
    });
    $('#bulkDeleteBtn').prop('disabled', selectedIds.size === 0);
  });
  $(document).on('change', '.row-checkbox', function() {
    if (this.checked) selectedIds.add(this.value); else selectedIds.delete(this.value);
    $('#bulkDeleteBtn').prop('disabled', selectedIds.size === 0);
  });
  window.submitBulkDelete = function() {
    if (selectedIds.size === 0) return;
    if (!confirm('Delete ' + selectedIds.size + ' selected key server(s)?')) return;
    $('#selectedIds').val(Array.from(selectedIds).join(','));
    $('#bulkDeleteForm').submit();
  };
});

function confirmDelete(id, name) {
  if (!confirm('Delete key server "' + name + '"?')) return;
  document.getElementById('delete_id').value = id;
  document.getElementById('deleteForm').submit();
}
</script>

</body>
</html>
