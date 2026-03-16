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
  <title>Hermes SEG | RBL Configuration</title>

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
            <h1 class="m-0">RBL Configuration</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">RBL Configuration</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
  <cfif session.m is not "">
    <cfset m = session.m>
  </cfif>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(url, "action")>
  <cfif url.action is not ""><cfset action = url.action></cfif>
</cfif>
<cfif StructKeyExists(form, "action")>
  <cfif form.action is not ""><cfset action = form.action></cfif>
</cfif>

<!--- GET RBL DATA --->
<cfinclude template="./inc/get_rbl_configuration.cfm">

<!--- ===================== --->
<!--- ACTION HANDLERS --->
<!--- ===================== --->
<cfif action is "add_entry">
  <cfinclude template="./inc/rbl_add_entry.cfm">
<cfelseif action is "delete" OR action is "bulk_delete">
  <cfinclude template="./inc/rbl_delete_entry.cfm">
<cfelseif action is "edit_entry">
  <cfinclude template="./inc/rbl_edit_entry.cfm">
<cfelseif action is "apply">
  <cfinclude template="./inc/rbl_apply_settings.cfm">
<cfelseif action is "cancel_add" OR action is "cancel_delete">
  <cfinclude template="./inc/rbl_cancel_changes.cfm">
</cfif>

<!--- Refresh data after actions --->
<cfinclude template="./inc/get_rbl_configuration.cfm">

<!--- Clear session message --->
<cfset session.m = "">

<!--- ALERT MESSAGES --->
<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entry Added</h4>
    <p>RBL entry has been staged. Click <strong>Apply Settings</strong> to activate.</p>
  </div>
</cfif>
<cfif m is 2>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Entry Marked for Deletion</h4>
    <p>Entry marked for deletion. Click <strong>Apply Settings</strong> to confirm.</p>
  </div>
</cfif>
<cfif m is 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Settings Applied</h4>
    <p>RBL configuration has been applied and Postfix reloaded successfully.</p>
  </div>
</cfif>
<cfif m is 4>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Apply Failed</h4>
    <p>An error occurred while applying the configuration.</p>
  </div>
</cfif>
<cfif m is 5>
  <div class="alert alert-info alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-edit"></i> Entry Updated</h4>
    <p>Entry has been updated. Click <strong>Apply Settings</strong> to activate changes.</p>
  </div>
</cfif>
<cfif m is 6>
  <div class="alert alert-info alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-undo"></i> Pending Additions Cancelled</h4>
  </div>
</cfif>
<cfif m is 7>
  <div class="alert alert-info alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-undo"></i> Pending Deletions Cancelled</h4>
  </div>
</cfif>
<cfif m is 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Please enter an RBL hostname.</p>
  </div>
</cfif>
<cfif m is 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Hostname</h4>
    <p>The RBL hostname entered is not valid.</p>
  </div>
</cfif>
<cfif m is 12>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Duplicate Entry</h4>
    <p>This RBL entry already exists.</p>
  </div>
</cfif>

<!--- PENDING CHANGES CARDS --->
<cfif has_pending_changes>
  <cfif get_pending_adds.recordCount GT 0>
    <div class="card card-warning card-outline mb-4">
      <div class="card-header">
        <h3 class="card-title"><i class="fas fa-clock"></i> Pending Additions (<cfoutput>#get_pending_adds.recordCount#</cfoutput>)</h3>
      </div>
      <div class="card-body">
        <cfoutput query="get_pending_adds">
          <span class="badge bg-success me-1">+ #encodeForHTML(parameter)# (w:#weight#)</span>
        </cfoutput>
        <div class="mt-3">
          <form method="post" class="d-inline">
            <input type="hidden" name="action" value="cancel_add">
            <button type="submit" class="btn btn-sm btn-secondary"><i class="fas fa-undo"></i> Cancel Additions</button>
          </form>
        </div>
      </div>
    </div>
  </cfif>
  <cfif get_pending_deletes.recordCount GT 0>
    <div class="card card-danger card-outline mb-4">
      <div class="card-header">
        <h3 class="card-title"><i class="fas fa-clock"></i> Pending Deletions (<cfoutput>#get_pending_deletes.recordCount#</cfoutput>)</h3>
      </div>
      <div class="card-body">
        <cfoutput query="get_pending_deletes">
          <span class="badge bg-danger me-1">- #encodeForHTML(parameter)#</span>
        </cfoutput>
        <div class="mt-3">
          <form method="post" class="d-inline">
            <input type="hidden" name="action" value="cancel_delete">
            <button type="submit" class="btn btn-sm btn-secondary"><i class="fas fa-undo"></i> Cancel Deletions</button>
          </form>
        </div>
      </div>
    </div>
  </cfif>

  <div class="mb-4">
    <form method="post" class="d-inline">
      <input type="hidden" name="action" value="apply">
      <button type="submit" class="btn btn-danger btn-lg"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Applying...';this.form.submit();">
        <i class="fas fa-check-circle"></i> Apply Settings
      </button>
    </form>
  </div>
</cfif>

<!-- ADD ENTRY CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add RBL Entry</h3>
  </div>
  <div class="card-body">
    <div class="callout callout-info" style="margin-bottom: 2rem;">
      <h5><i class="fas fa-info-circle"></i> Block Lists vs Allow Lists</h5>
      <p class="mb-1"><strong>Block List (DNSBL):</strong> DNS-based blacklists that identify known spam sources (e.g., <code>zen.spamhaus.org</code>, <code>bl.spamcop.net</code>). Matches add to the spam score.</p>
      <p class="mb-1"><strong>Allow List (DNSWL):</strong> DNS-based whitelists that identify trusted senders (e.g., <code>list.dnswl.org</code>). Matches subtract from the spam score.</p>
      <p class="mb-0"><strong>Weight:</strong> Controls how much each list contributes to the overall DNSBL score. The combined score is compared against the DNSBL Threshold configured in Perimeter Checks.</p>
    </div>
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="add_entry">
      <div class="row">
        <div class="col-md-4">
          <label for="rbl_host" class="form-label"><strong>RBL Hostname</strong></label>
          <input type="text" class="form-control" id="rbl_host" name="rbl_host" placeholder="zen.spamhaus.org" required>
        </div>
        <div class="col-md-3">
          <label class="form-label"><strong>Type</strong></label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="rbl_type" id="type_block" value="block" checked>
              <label class="form-check-label" for="type_block">Block List</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="rbl_type" id="type_allow" value="allow">
              <label class="form-check-label" for="type_allow">Allow List</label>
            </div>
          </div>
        </div>
        <div class="col-md-2">
          <label for="rbl_weight" class="form-label"><strong>Weight</strong></label>
          <input type="number" class="form-control" id="rbl_weight" name="rbl_weight" value="1" min="1" step="1">
          <small class="text-muted" id="weightHelp">Points added to the DNSBL score per match</small>
        </div>
        <div class="col-md-3 d-flex align-items-end pb-1">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add Entry
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- RBL ENTRIES TABLE -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list"></i> RBL Entries</h3>
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

      <table id="rblTable" class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th style="width: 40%">Hostname</th>
            <th style="width: 15%">Type</th>
            <th style="width: 15%">Weight</th>
            <th style="width: 25%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_active_all">
            <!--- Strip trailing *weight from parameter to get display hostname --->
            <cfset lastStar = Find("*", Reverse(parameter))>
            <cfif lastStar GT 0>
              <cfset displayHost = Left(parameter, Len(parameter) - lastStar)>
            <cfelse>
              <cfset displayHost = parameter>
            </cfif>
            <cfset isBlock = (weight GT 0)>
            <tr>
              <td><input type="checkbox" class="entry-checkbox" value="#id#"></td>
              <td>#encodeForHTML(displayHost)#</td>
              <td>
                <cfif isBlock>
                  <span class="badge bg-danger">Block List</span>
                <cfelse>
                  <span class="badge bg-success">Allow List</span>
                </cfif>
              </td>
              <td>#Abs(weight)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-primary" onclick="openEditModal('#id#', '#encodeForJavaScript(displayHost)#', '#weight#');" title="Edit">
                  <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-sm btn-danger" onclick="deleteSingle('#id#', '#encodeForJavaScript(displayHost)#');" title="Delete">
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
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="editForm" method="post">
        <input type="hidden" name="action" value="edit_entry">
        <input type="hidden" name="edit_id" id="edit_id" value="">
        <div class="modal-header">
          <h5 class="modal-title" id="editModalLabel">Edit RBL Entry</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_host" class="form-label"><strong>RBL Hostname</strong></label>
            <input type="text" class="form-control" id="edit_host" name="edit_host" required>
          </div>
          <div class="mb-3">
            <label for="edit_weight" class="form-label"><strong>Weight</strong></label>
            <input type="number" class="form-control" id="edit_weight" name="edit_weight" required>
            <small class="text-muted">Positive = Block List, Negative = Allow List</small>
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

<!-- DELETE FORM (hidden) -->
<form id="deleteForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="delete">
  <input type="hidden" name="delete_id" id="delete_id" value="">
</form>

<script>
$(document).ready(function() {
  $('#rblTable').DataTable({
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

  // Checkbox handling
  var selected = new Set();

  $('#selectAll').on('change', function() {
    var checked = this.checked;
    $('.entry-checkbox:visible').each(function() {
      this.checked = checked;
      if (checked) selected.add(this.value); else selected.delete(this.value);
    });
    $('#bulkDeleteBtn').prop('disabled', selected.size === 0);
  });
  $(document).on('change', '.entry-checkbox', function() {
    if (this.checked) selected.add(this.value); else selected.delete(this.value);
    $('#bulkDeleteBtn').prop('disabled', selected.size === 0);
  });

  window.submitBulkDelete = function() {
    if (selected.size === 0) return;
    if (!confirm('Are you sure you want to delete ' + selected.size + ' selected entries?')) return;
    $('#selectedIds').val(Array.from(selected).join(','));
    $('#bulkDeleteForm').submit();
  };
});

function openEditModal(id, host, weight) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_host').value = host;
  document.getElementById('edit_weight').value = weight;
  var modal = new bootstrap.Modal(document.getElementById('editModal'));
  modal.show();
}

function deleteSingle(id, name) {
  if (!confirm('Are you sure you want to delete "' + name + '"?')) return;
  document.getElementById('delete_id').value = id;
  document.getElementById('deleteForm').submit();
}

$('input[name="rbl_type"]').on('change', function() {
  if ($(this).val() === 'allow') {
    $('#weightHelp').text('Points subtracted from the DNSBL score per match');
  } else {
    $('#weightHelp').text('Points added to the DNSBL score per match');
  }
});
</script>


      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>
</html>
