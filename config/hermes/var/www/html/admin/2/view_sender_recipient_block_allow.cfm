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
  <title>Hermes SEG | Sender/Recipient Rules</title>

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
            <h1 class="m-0">Sender/Recipient Rules</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Sender/Recipient Rules</li>
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
<cfinclude template="./inc/get_sender_recipient_block_allow.cfm">

<!--- ACTION HANDLERS --->
<cfif action is "add_entry">
  <cfinclude template="./inc/sender_add_entry.cfm">
<cfelseif action is "delete" OR action is "bulk_delete">
  <cfinclude template="./inc/sender_delete_entry.cfm">
<cfelseif action is "edit_entry">
  <cfinclude template="./inc/sender_edit_entry.cfm">
</cfif>

<!--- Refresh data after actions --->
<cfinclude template="./inc/get_sender_recipient_block_allow.cfm">
<cfset session.m = "">

<!--- ===================== --->
<!--- ALERTS --->
<!--- ===================== --->
<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entry Added</h4>
    <p>Sender/recipient entry added and Amavis configuration applied successfully.</p>
  </div>
</cfif>
<cfif m is 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entry Deleted</h4>
    <p>Sender/recipient entry deleted and Amavis configuration applied successfully.</p>
  </div>
</cfif>
<cfif m is 5>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entry Updated</h4>
    <p>Sender/recipient entry updated and Amavis configuration applied successfully.</p>
  </div>
</cfif>
<cfif m is 30>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>The Sender Domain or Email Address field cannot be blank.</p>
  </div>
</cfif>
<cfif m is 31>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>The Recipient field cannot be blank.</p>
  </div>
</cfif>
<cfif m is 32>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Invalid block/allow type specified.</p>
  </div>
</cfif>
<cfif m is 33>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>The Sender field must be a valid email address or a valid domain.</p>
  </div>
</cfif>
<cfif m is 34>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>The specified recipient was not found in the system.</p>
  </div>
</cfif>
<cfif m is 35>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>The sender and recipient domains cannot be the same.</p>
  </div>
</cfif>
<cfif m is 36>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>This sender to recipient mapping already exists or is already staged for addition.</p>
  </div>
</cfif>

<!--- ===================== --->
<!--- ADD ENTRY CARD --->
<!--- ===================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add Sender/Recipient Entry</h3>
  </div>
  <div class="card-body">
    <div class="callout callout-info mb-3">
      <p class="mb-0"><strong>Note:</strong> Allow entries only bypass Spam checks. Emails with Viruses, Banned Files, and Bad Headers will still be blocked. To block/allow an entire domain and all its sub-domains, enter <code>.domain.tld</code> (note the leading dot).</p>
    </div>
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="add_entry">
      <div class="row">
        <div class="col-md-4">
          <label for="sender" class="form-label"><strong>Sender Email or Domain</strong></label>
          <input type="text" class="form-control" id="sender" name="sender" maxlength="255"
            placeholder="user@example.com or .example.com">
          <small class="text-muted">Email address or domain (prefix with . for subdomains)</small>
        </div>
        <div class="col-md-4">
          <label for="recipient" class="form-label"><strong>Recipient</strong></label>
          <input type="text" class="form-control" id="recipient" name="recipient" maxlength="255" list="recipientList"
            placeholder="user@example.com or @example.com">
          <small class="text-muted">Type to search recipients</small>
          <!--- Populate datalist with recipients from the database --->
          <cfquery name="getAllRecipients" datasource="hermes">
            SELECT id, recipient, domain FROM recipients ORDER BY recipient ASC
          </cfquery>
          <datalist id="recipientList">
            <cfoutput query="getAllRecipients">
              <option value="#encodeForHTMLAttribute(recipient)#">
            </cfoutput>
          </datalist>
        </div>
        <div class="col-md-2">
          <label class="form-label"><strong>Action</strong></label>
          <div>
            <div class="form-check mb-2">
              <input class="form-check-input" type="radio" name="entry_type" id="type_block" value="BLOCK" checked>
              <label class="form-check-label" for="type_block"><i class="fas fa-ban text-danger"></i> Block</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="entry_type" id="type_allow" value="ALLOW">
              <label class="form-check-label" for="type_allow"><i class="fas fa-check text-success"></i> Allow</label>
            </div>
          </div>
        </div>
        <div class="col-md-2 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add Entry
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!--- ===================== --->
<!--- ENTRIES TABLE --->
<!--- ===================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-exchange-alt"></i> Sender/Recipient Entries</h3>
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

      <table id="senderRecipientTable" class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th style="width: 30%">Sender</th>
            <th style="width: 30%">Recipient</th>
            <th style="width: 10%">Type</th>
            <th style="width: 25%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_active_all">
            <cfset rowKey = "#rid#:#sid#">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#rowKey#"></td>
              <td>#encodeForHTML(sender)#</td>
              <td>#encodeForHTML(receiver)#</td>
              <td>
                <cfif wb is "W">
                  <span class="badge bg-success">Allow</span>
                <cfelse>
                  <span class="badge bg-danger">Block</span>
                </cfif>
              </td>
              <td>
                <button type="button" class="btn btn-sm btn-primary" onclick="openEditModal('#rid#', '#sid#', '#encodeForJavaScript(sender)#', '#encodeForJavaScript(receiver)#', '#wb#');" title="Edit">
                  <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-sm btn-danger" onclick="deleteSingle('#rid#', '#sid#', '#encodeForJavaScript(sender)#', '#encodeForJavaScript(receiver)#');" title="Delete">
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

<!--- ===================== --->
<!--- EDIT MODAL --->
<!--- ===================== --->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="edit_entry">
        <input type="hidden" name="edit_rid" id="edit_rid" value="">
        <input type="hidden" name="edit_sid" id="edit_sid" value="">
        <input type="hidden" name="edit_original_sender" id="edit_original_sender" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Sender/Recipient Entry</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_sender" class="form-label"><strong>Sender Email or Domain</strong></label>
            <input type="text" class="form-control" id="edit_sender" name="edit_sender" required>
          </div>
          <div class="mb-3">
            <label for="edit_recipient" class="form-label"><strong>Recipient</strong></label>
            <input type="text" class="form-control" id="edit_recipient" name="edit_recipient" required readonly>
            <small class="text-muted">Recipient cannot be changed. Delete and re-add if needed.</small>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Type</strong></label>
            <select class="form-select" name="edit_type" id="edit_type">
              <option value="BLOCK">Block</option>
              <option value="ALLOW">Allow</option>
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
  <input type="hidden" name="delete_rid" id="delete_rid" value="">
  <input type="hidden" name="delete_sid" id="delete_sid" value="">
</form>

<script>
$(document).ready(function() {
  $('#senderRecipientTable').DataTable({
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

function openEditModal(rid, sid, sender, recipient, wb) {
  document.getElementById('edit_rid').value = rid;
  document.getElementById('edit_sid').value = sid;
  document.getElementById('edit_sender').value = sender;
  document.getElementById('edit_original_sender').value = sender;
  document.getElementById('edit_recipient').value = recipient;
  document.getElementById('edit_type').value = (wb === 'W') ? 'ALLOW' : 'BLOCK';
  new bootstrap.Modal(document.getElementById('editModal')).show();
}

function deleteSingle(rid, sid, sender, recipient) {
  if (!confirm('Delete mapping "' + sender + ' \u2192 ' + recipient + '"?')) return;
  document.getElementById('delete_rid').value = rid;
  document.getElementById('delete_sid').value = sid;
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
