<!--- Early intercept: AJAX JSON requests must return before any HTML output --->
<cfparam name="action" default="">
<cfif StructKeyExists(url, "action")>
  <cfif url.action is not ""><cfset action = url.action></cfif>
</cfif>
<cfif action is "test_entry">
  <cfinclude template="./inc/get_rbl_configuration.cfm">
  <cfinclude template="./inc/rbl_test_entry.cfm">
</cfif>

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
  <!--- inc/rbl_apply_settings.cfm has existed since this page was written but
       nothing ever invoked it, so the only way to push a database change into
       main.cf was to edit an entry and save it without changing anything. That
       also meant the upgrade notes documented an Apply button that did not
       exist. Wired up here (#293). --->
  <cfinclude template="./inc/rbl_apply_settings.cfm">
</cfif>

<!--- Clear session message --->
<cfset session.m = "">

<!--- ALERT MESSAGES --->
<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entry Added</h4>
    <p>RBL entry has been added and Postfix configuration applied successfully.</p>
  </div>
</cfif>
<cfif m is 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entry Deleted</h4>
    <p>RBL entry has been deleted and Postfix configuration applied successfully.</p>
  </div>
</cfif>
<cfif m is 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Configuration Applied</h4>
    <p>Pending changes were committed and the Postfix configuration was regenerated and reloaded.</p>
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
    <p>RBL entry has been updated and Postfix configuration applied successfully.</p>
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
      <p class="mb-1"><strong>Weight:</strong> Controls how much each list contributes to the overall DNSBL score. The combined score is compared against the DNSBL Threshold configured in Perimeter Checks.</p>
      <p class="mb-0"><strong>Return Code Filtering:</strong> Postfix supports filtering by DNS return code using <code>hostname=127.x.x.x</code> syntax (e.g., <code>bl.mailspike.net=127.0.0.[10;11;12]</code>). This restricts matches to specific return codes published by the list.</p>
    </div>
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="add_entry">
      <div class="row">
        <div class="col-md-4">
          <label for="rbl_host" class="form-label"><strong>RBL Hostname</strong></label>
          <input type="text" class="form-control" id="rbl_host" name="rbl_host" placeholder="zen.spamhaus.org or bl.mailspike.net=127.0.0.[10;11;12]" required>
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
    <div class="callout callout-warning mb-3">
      <h5><i class="fas fa-exclamation-triangle"></i> Warning on RBL Tests</h5>
      <p class="mb-1">The <i class="fas fa-vial"></i> test performs a two-point DNS probe against each RBL zone using the same DNS resolver and source IP as Postfix. It queries <code>2.0.0.127.<em>zone</em></code>, which should be listed, and <code>1.0.0.127.<em>zone</em></code>, which must never be listed.</p>
      <p class="mb-1"><span class="badge bg-success">Green</span> means the zone returned real reputation data. <span class="badge bg-warning text-dark">Yellow</span> means the zone exists but no data reached us: either the list publishes no test entry, or its answers are being blocked or stripped somewhere between here and the list. <span class="badge bg-danger">Red</span> means the query was refused, the zone answers every query (wildcard), or the zone is dead. Hover any badge for the detail.</p>
      <p class="mb-1">Yellow is not a pass. A list that returns nothing contributes nothing, so its weight silently drops out of the DNSBL score. Many providers also refuse queries from public or shared resolvers, which shows as red with a <code>127.255.255.254</code> code; recursive mode under System &gt; DNS Resolver avoids that.</p>
      <p class="mb-1">A dead or misconfigured <strong>Block List</strong> that returns wildcard matches will add to the DNSBL score for every connecting IP, potentially blocking all legitimate inbound mail.</p>
      <p class="mb-0">A dead or misconfigured <strong>Allow List (DNSWL)</strong> that returns wildcard matches will subtract from the DNSBL score for every connecting IP, potentially allowing spam through that would otherwise be blocked.</p>
    </div>
    <!--- Standalone form, deliberately a SIBLING of bulkDeleteForm rather than
         nested inside it: the DataTable below is already wrapped in that form,
         and nesting forms around a DataTable silently strips fields. The Apply
         button lives in the toolbar and submits this one via JS. --->
    <form id="applyForm" method="post" style="display:none">
      <input type="hidden" name="action" value="apply">
    </form>

    <form id="bulkDeleteForm" method="post">
      <input type="hidden" name="action" value="bulk_delete">
      <input type="hidden" name="selected_ids" id="selectedIds" value="">

      <div class="mb-2 d-flex gap-2 align-items-center flex-wrap">
        <button type="button" class="btn btn-sm btn-danger" id="bulkDeleteBtn" disabled
          onclick="submitBulkDelete();">
          <i class="fas fa-trash"></i> Delete Selected
        </button>
        <button type="button" class="btn btn-sm btn-primary" onclick="submitApply();">
          <i class="fas fa-sync"></i> Apply
        </button>
        <button type="button" class="btn btn-sm btn-info" onclick="testAll();">
          <i class="fas fa-vial"></i> Test All
        </button>
        <span class="ms-2 text-muted small">
          <i class="fas fa-vial"></i> Test results:
          <span class="badge bg-success ms-1"><i class="fas fa-check-circle"></i> Data OK</span> list returned reputation data &nbsp;
          <span class="badge bg-warning text-dark ms-1"><i class="fas fa-exclamation-triangle"></i> No Data</span> zone exists, nothing returned &nbsp;
          <span class="badge bg-danger ms-1"><i class="fas fa-times-circle"></i> Error</span> refused, wildcard, or dead
        </span>
      </div>

      <table id="rblTable" class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th style="width: 35%">Hostname</th>
            <th style="width: 10%">Type</th>
            <th style="width: 10%">Weight</th>
            <th style="width: 20%">Status</th>
            <th style="width: 20%">Actions</th>
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
              <td><span id="status-#id#" class="badge bg-secondary">Not Tested</span></td>
              <td>
                <button type="button" class="btn btn-sm btn-info test-btn" onclick="testEntry('#id#');" title="Test DNS">
                  <i class="fas fa-vial"></i>
                </button>
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
            <label class="form-label"><strong>List Type</strong></label>
            <div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="edit_type" id="edit_type_block" value="block" checked onchange="updateEditWeightHelp()">
                <label class="form-check-label" for="edit_type_block">Block List</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="edit_type" id="edit_type_allow" value="allow" onchange="updateEditWeightHelp()">
                <label class="form-check-label" for="edit_type_allow">Allow List (DNSWL)</label>
              </div>
            </div>
          </div>
          <div class="mb-3">
            <label for="edit_host" class="form-label"><strong>RBL Hostname</strong></label>
            <input type="text" class="form-control" id="edit_host" name="edit_host" required>
          </div>
          <div class="mb-3">
            <label for="edit_weight" class="form-label"><strong>Weight</strong></label>
            <input type="number" class="form-control" id="edit_weight" name="edit_weight" min="1" step="1" required>
            <small class="text-muted" id="editWeightHelp">Points added to the DNSBL score per match</small>
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
      { orderable: false, targets: [0, 4, 5] },
      { searchable: false, targets: [0, 4, 5] }
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

function updateEditWeightHelp() {
  var isAllow = document.getElementById('edit_type_allow').checked;
  document.getElementById('editWeightHelp').textContent = isAllow
    ? 'Points subtracted from the DNSBL score per match'
    : 'Points added to the DNSBL score per match';
}

function openEditModal(id, host, weight) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_host').value = host;
  var w = parseInt(weight, 10);
  document.getElementById('edit_weight').value = Math.abs(w);
  if (w < 0) {
    document.getElementById('edit_type_allow').checked = true;
  } else {
    document.getElementById('edit_type_block').checked = true;
  }
  updateEditWeightHelp();
  var modal = new bootstrap.Modal(document.getElementById('editModal'));
  modal.show();
}

function deleteSingle(id, name) {
  if (!confirm('Are you sure you want to delete "' + name + '"?')) return;
  document.getElementById('delete_id').value = id;
  document.getElementById('deleteForm').submit();
}

function submitApply() {
  // Regenerates main.cf from the database and reloads Postfix, so it reverts any
  // postconf edits made by hand outside the admin console. Worth a confirmation.
  if (!confirm('Apply the current block list configuration?\n\nThis regenerates the Postfix configuration from the database and reloads Postfix.')) return;
  document.getElementById('applyForm').submit();
}

function testEntry(id) {
  var badge = document.getElementById('status-' + id);
  badge.className = 'badge bg-secondary';
  badge.title = '';
  badge.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Testing...';
  fetch('view_rbl_configuration.cfm?action=test_entry&id=' + id)
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.status === 'ok') {
        badge.className = 'badge bg-success';
        badge.innerHTML = '<i class="fas fa-check-circle"></i> Data OK';
        badge.title = data.message;
      } else if (data.status === 'warn') {
        badge.className = 'badge bg-warning text-dark';
        badge.innerHTML = '<i class="fas fa-exclamation-triangle"></i> No Data';
        badge.title = data.message;
      } else {
        badge.className = 'badge bg-danger';
        badge.innerHTML = '<i class="fas fa-times-circle"></i> ' + (data.status === 'timeout' ? 'Unreachable' : 'Error');
        badge.title = data.message;
      }
    })
    .catch(function() {
      badge.className = 'badge bg-danger';
      badge.innerHTML = '<i class="fas fa-times-circle"></i> Request failed';
    });
}

function testAll() {
  document.querySelectorAll('.test-btn').forEach(function(btn) {
    btn.click();
  });
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
