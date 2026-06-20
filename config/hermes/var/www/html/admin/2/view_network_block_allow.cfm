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
  <title>Hermes SEG | Network Block/Allow</title>

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
            <h1 class="m-0">Network Block/Allow</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Network Block/Allow</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
  <cfif session.m is not ""><cfset m = session.m></cfif>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(url, "action")>
  <cfif url.action is not ""><cfset action = url.action></cfif>
</cfif>
<cfif StructKeyExists(form, "action")>
  <cfif form.action is not ""><cfset action = form.action></cfif>
</cfif>

<cfset ipv4_pattern = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$">

<cffunction name="normalizeIP" returntype="string" output="false">
  <cfargument name="ip" type="string" required="true">
  <cfset var octets = ListToArray(arguments.ip, ".")>
  <cfset var normalized = "">
  <cfloop array="#octets#" index="octet">
    <cfset normalized = ListAppend(normalized, Int(octet), ".")>
  </cfloop>
  <cfreturn normalized>
</cffunction>

<!--- GET DATA --->
<cfinclude template="./inc/get_network_block_allow.cfm">

<!--- ===================== --->
<!--- ACTION HANDLERS --->
<!--- ===================== --->
<cfif action is "add_entries">
  <cfinclude template="./inc/network_add_entries.cfm">
<cfelseif action is "delete" OR action is "bulk_delete">
  <cfinclude template="./inc/network_delete_entry.cfm">
<cfelseif action is "edit_entry">
  <cfinclude template="./inc/network_edit_entry.cfm">
</cfif>

<!--- Refresh data --->
<cfinclude template="./inc/get_network_block_allow.cfm">
<cfset session.m = "">

<!--- ALERTS --->
<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entries Added</h4>
    <cfif StructKeyExists(session, "entries_added")>
      <p><cfoutput>#session.entries_added#</cfoutput> entries added and Postfix configuration applied.</p>
      <cfset session.entries_added = "">
    </cfif>
    <cfif StructKeyExists(session, "entries_skipped") AND session.entries_skipped GT 0>
      <p><cfoutput>#session.entries_skipped#</cfoutput> entries skipped.</p>
      <cfset session.entries_skipped = "">
    </cfif>
    <cfif StructKeyExists(session, "entry_errors") AND session.entry_errors is not "">
      <p><cfoutput>#session.entry_errors#</cfoutput></p>
      <cfset session.entry_errors = "">
    </cfif>
  </div>
</cfif>
<cfif m is 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entry Deleted</h4>
    <p>Entry deleted and Postfix configuration applied successfully.</p>
  </div>
</cfif>
<cfif m is 4>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Configuration Error</h4>
    <p>An error occurred while applying the Postfix configuration.</p>
  </div>
</cfif>
<cfif m is 5>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entry Updated</h4>
    <p>Entry updated and Postfix configuration applied successfully.</p>
  </div>
</cfif>
<cfif m is 30>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Please enter at least one IP address or network.</p>
  </div>
</cfif>

<!-- ADD ENTRIES CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add IP/Network</h3>
  </div>
  <div class="card-body">
    <div class="callout callout-info mb-4">
      <h5><i class="fas fa-info-circle"></i> About Network Block/Allow</h5>
      <p class="mb-1">Entries here are evaluated by Postfix <strong>before</strong> any RBL/DNSBL checks run. This makes them useful as an <strong>RBL override</strong> — adding a trusted IP or network with <strong>Allow</strong> causes Postfix to skip all spam and DNSBL scoring for that sender entirely.</p>
      <p class="mb-2"><strong>When to add an Allow entry:</strong></p>
      <ul class="mb-2">
        <li>A trusted mail server or partner whose IP appears on RBL lists (e.g. a shared hosting provider)</li>
        <li>Your own internal mail servers or relay hosts that send through this gateway</li>
        <li>A known-good sender being incorrectly blocked due to RBL false positives</li>
      </ul>
      <p class="mb-2"><strong>When to add a Block entry:</strong></p>
      <ul class="mb-0">
        <li>A known-bad IP or network that you want rejected outright before any other checks</li>
        <li>A persistent spam source not covered by your current RBL lists</li>
      </ul>
    </div>
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="add_entries">
      <div class="row">
        <div class="col-md-6">
          <label for="entries" class="form-label"><strong>IP Addresses and/or Networks</strong></label>
          <textarea class="form-control" id="entries" name="entries" rows="5"
            placeholder="192.168.1.100 Office Server
10.0.0.0/24 Internal Network"></textarea>
          <small class="text-muted">
            One entry per line. Format: <code>IP_or_Network [Note]</code><br>
            Examples: <code>192.168.1.100 My Server</code> or <code>10.0.0.0/24 LAN</code>
          </small>
        </div>
        <div class="col-md-3">
          <label class="form-label"><strong>Action</strong></label>
          <div>
            <div class="form-check mb-2">
              <input class="form-check-input" type="radio" name="entry_action" id="action_permit" value="permit" checked>
              <label class="form-check-label" for="action_permit"><i class="fas fa-check text-success"></i> Allow (bypass RBL)</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="entry_action" id="action_reject" value="reject">
              <label class="form-check-label" for="action_reject"><i class="fas fa-ban text-danger"></i> Block</label>
            </div>
          </div>
        </div>
        <div class="col-md-3 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add Entries
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- ENTRIES TABLE -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-network-wired"></i> Network Entries</h3>
  </div>
  <div class="card-body">
    <form id="bulkDeleteForm" method="post">
      <input type="hidden" name="action" value="bulk_delete">
      <input type="hidden" name="selected_ids" id="selectedIds" value="">

      <div class="mb-2">
        <button type="button" class="btn btn-sm btn-danger" id="bulkDeleteBtn" disabled
          onclick="submitBulkDelete();">
          <i class="fas fa-trash"></i> Delete Selected
        </button>
      </div>

      <table id="networkTable" class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th style="width: 30%">IP/Network</th>
            <th style="width: 25%">Note</th>
            <th style="width: 15%">Action</th>
            <th style="width: 25%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_active_all">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#id#"></td>
              <td>#encodeForHTML(sender)#</td>
              <td>#encodeForHTML(note)#</td>
              <td>
                <cfif action is "permit">
                  <span class="badge bg-success">Allow</span>
                <cfelse>
                  <span class="badge bg-danger">Block</span>
                </cfif>
              </td>
              <td>
                <button type="button" class="btn btn-sm btn-primary" onclick="openEditModal('#id#', '#encodeForJavaScript(sender)#', '#encodeForJavaScript(action)#', '#encodeForJavaScript(note)#');" title="Edit">
                  <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-sm btn-danger" onclick="deleteSingle('#id#', '#encodeForJavaScript(sender)#');" title="Delete">
                  <i class="fas fa-trash"></i>
                </button>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
    </form>
  </div>
</div>

<!-- EDIT MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="edit_entry">
        <input type="hidden" name="edit_id" id="edit_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Network Entry</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_sender" class="form-label"><strong>IP/Network</strong></label>
            <input type="text" class="form-control" id="edit_sender" name="edit_sender" required>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Action</strong></label>
            <select class="form-select" name="edit_action" id="edit_action">
              <option value="permit">Allow</option>
              <option value="reject">Block</option>
            </select>
          </div>
          <div class="mb-3">
            <label for="edit_note" class="form-label"><strong>Note</strong></label>
            <input type="text" class="form-control" id="edit_note" name="edit_note">
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Save Changes</button>
        </div>
      </form>
    </div>
  </div>
</div>

<form id="deleteForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="delete">
  <input type="hidden" name="delete_id" id="delete_id" value="">
</form>

<script>
$(document).ready(function() {
  $('#networkTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[1, 'asc']],
    columnDefs: [
      { orderable: false, targets: [0, 4] },
      { searchable: false, targets: [0, 4] }
    ]
  });

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
    if (!confirm('Delete ' + selectedIds.size + ' selected entries?')) return;
    $('#selectedIds').val(Array.from(selectedIds).join(','));
    $('#bulkDeleteForm').submit();
  };
});

function openEditModal(id, sender, action, note) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_sender').value = sender;
  document.getElementById('edit_action').value = action;
  document.getElementById('edit_note').value = note;
  new bootstrap.Modal(document.getElementById('editModal')).show();
}

function deleteSingle(id, name) {
  if (!confirm('Delete "' + name + '"?')) return;
  document.getElementById('delete_id').value = id;
  document.getElementById('deleteForm').submit();
}
</script>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>
</html>
