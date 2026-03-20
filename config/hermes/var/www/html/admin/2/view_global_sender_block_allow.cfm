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
  <title>Hermes SEG | Global Sender Rules</title>

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
            <h1 class="m-0">Global Sender Rules</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Global Sender Rules</li>
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

<!--- GET DATA --->
<cfinclude template="./inc/get_global_sender_block_allow.cfm">

<!--- ACTION HANDLERS --->
<cfif action is "add_entries">
  <cfinclude template="./inc/global_sender_add_entries.cfm">
<cfelseif action is "delete" OR action is "bulk_delete">
  <cfinclude template="./inc/global_sender_delete_entry.cfm">
<cfelseif action is "edit_entry">
  <cfinclude template="./inc/global_sender_edit_entry.cfm">
</cfif>

<!--- Refresh data after actions --->
<cfinclude template="./inc/get_global_sender_block_allow.cfm">
<cfset session.m = "">

<!--- ALERTS --->
<cfif m is 1>
  <cfif StructKeyExists(session, "entries_added") AND session.entries_added GT 0>
    <div class="alert alert-success alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fa fa-check"></i> Success</h4>
      <cfoutput>The following #session.entries_added# entries were added successfully:</cfoutput><br>
      <cfoutput>#session.success_list#</cfoutput>
      <p class="mb-0 mt-2">Settings applied. Postfix reloaded and Amavis restarted.</p>
    </div>
  </cfif>
  <cfif StructKeyExists(session, "invalid_list") AND session.invalid_list is not "">
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fa fa-ban"></i> Invalid Entries</h4>
      The following entries had invalid email address(es) or domain(s):<br>
      <cfoutput>#session.invalid_list#</cfoutput>
    </div>
  </cfif>
  <cfif StructKeyExists(session, "duplicate_list") AND session.duplicate_list is not "">
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fa fa-ban"></i> Duplicate Entries</h4>
      The following entries already exist:<br>
      <cfoutput>#session.duplicate_list#</cfoutput>
    </div>
  </cfif>
  <cfset session.entries_added = "">
  <cfset session.entries_skipped = "">
  <cfset session.success_list = "">
  <cfset session.invalid_list = "">
  <cfset session.duplicate_list = "">
</cfif>
<cfif m is 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entry Deleted</h4>
    <p>Settings applied. Postfix reloaded and Amavis restarted.</p>
  </div>
</cfif>
<cfif m is 4>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Apply Failed</h4>
    <p>An error occurred while applying settings. Check container logs for details.</p>
  </div>
</cfif>
<cfif m is 5>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entry Updated</h4>
    <p>Settings applied. Postfix reloaded and Amavis restarted.</p>
  </div>
</cfif>
<cfif m is 30>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Please enter at least one email address or domain.</p>
  </div>
</cfif>

<!--- WARNING CALLOUT --->
<div class="callout callout-warning mb-4">
  <h5><i class="fas fa-exclamation-triangle"></i> Use Extreme Caution</h5>
  <p class="mb-1">
    Any <strong>Allow</strong> entries will bypass <strong>ALL</strong> filter checks including Spam, Virus, and Banned File checks
    for <strong>ALL</strong> recipients in your system. Do not use if at all possible. A Global Sender Rules entry takes
    precedence over any Sender/Recipient Rules entries.
  </p>
  <p class="mb-0">
    <code>@example.com</code> &mdash; matches all senders from <code>example.com</code> only (exact domain).<br>
    <code>.example.com</code> &mdash; matches <code>example.com</code> <strong>and all subdomains</strong>
    (<code>sub.example.com</code>, <code>mail.sub.example.com</code>, etc.).<br>
    <code>user@example.com</code> &mdash; matches a single sender address.
  </p>
</div>

<!-- ADD ENTRIES CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add Sender Entries</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off" id="addForm">
      <input type="hidden" name="action" value="add_entries">
      <div class="row">
        <div class="col-md-6">
          <label for="entries" class="form-label"><strong>Email Addresses and/or Domains</strong></label>
          <textarea class="form-control" id="entries" name="entries" rows="5"
            placeholder="user@example.com
example.com
.example.com"></textarea>
          <small class="text-muted">
            One entry per line. Enter an email address (e.g., <code>user@example.com</code>), a domain (e.g., <code>example.com</code>),
            or a leading-dot domain (e.g., <code>.example.com</code>) to match the domain and all its subdomains.
          </small>
          <div id="domainWarning" class="alert alert-warning mt-2 d-none">
            <i class="fas fa-exclamation-triangle"></i>
            <strong>Warning:</strong> You are adding one or more full domains. This will <span id="domainWarningAction">block</span>
            all email from the entire domain(s) for all recipients.
          </div>
        </div>
        <div class="col-md-3">
          <label class="form-label"><strong>Action</strong></label>
          <div>
            <div class="form-check mb-2">
              <input class="form-check-input" type="radio" name="entry_type" id="type_block" value="block" checked>
              <label class="form-check-label" for="type_block"><i class="fas fa-ban text-danger"></i> Block</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="entry_type" id="type_allow" value="allow">
              <label class="form-check-label" for="type_allow"><i class="fas fa-check text-success"></i> Allow (bypass ALL filters)</label>
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
    <h3 class="card-title"><i class="fas fa-envelope"></i> Global Sender Entries</h3>
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

      <table id="senderTable" class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th style="width: 40%">Sender</th>
            <th style="width: 15%">Format</th>
            <th style="width: 15%">Action</th>
            <th style="width: 25%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_active_all">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#id#"></td>
              <td>#encodeForHTML(sender)#</td>
              <td>
                <cfif Left(sender, 1) is "@">
                  <span class="badge bg-secondary">Domain</span>
                <cfelseif Left(sender, 1) is ".">
                  <span class="badge bg-warning">Domain + Subdomains</span>
                <cfelseif REFind("[@]", sender) GT 0>
                  <span class="badge bg-info">Email</span>
                <cfelse>
                  <span class="badge bg-secondary">Domain</span>
                </cfif>
              </td>
              <td>
                <cfif type is "allow">
                  <span class="badge bg-success">Allow</span>
                <cfelse>
                  <span class="badge bg-danger">Block</span>
                </cfif>
              </td>
              <td>
                <button type="button" class="btn btn-sm btn-primary" onclick="openEditModal('#id#', '#encodeForJavaScript(sender)#', '#encodeForJavaScript(type)#');" title="Edit">
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
          <h5 class="modal-title">Edit Sender Entry</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_sender" class="form-label"><strong>Sender (Email or Domain)</strong></label>
            <input type="text" class="form-control" id="edit_sender" name="edit_sender" required>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Action</strong></label>
            <select class="form-select" name="edit_type" id="edit_type">
              <option value="block">Block</option>
              <option value="allow">Allow</option>
            </select>
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
  $('#senderTable').DataTable({
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

  // Domain warning detection on textarea input
  $('#entries').on('input', function() {
    var text = $(this).val();
    var lines = text.split(/\r?\n/);
    var hasDomain = false;
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim();
      if (line !== '' && line.indexOf('@') === -1) {
        hasDomain = true;
        break;
      }
    }
    if (hasDomain) {
      var actionType = $('input[name="entry_type"]:checked').val();
      $('#domainWarningAction').text(actionType === 'allow' ? 'allow (bypass all filters for)' : 'block');
      $('#domainWarning').removeClass('d-none');
    } else {
      $('#domainWarning').addClass('d-none');
    }
  });

  // Update domain warning text when action radio changes
  $('input[name="entry_type"]').on('change', function() {
    if (!$('#domainWarning').hasClass('d-none')) {
      var actionType = $(this).val();
      $('#domainWarningAction').text(actionType === 'allow' ? 'allow (bypass all filters for)' : 'block');
    }
  });
});

function openEditModal(id, sender, type) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_sender').value = sender;
  document.getElementById('edit_type').value = type;
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
