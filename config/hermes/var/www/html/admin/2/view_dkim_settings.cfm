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
  <title>Hermes SEG | DKIM Settings</title>
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
            <h1 class="m-0">DKIM Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">DKIM Settings</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- Load current settings --->
<cfinclude template="./inc/get_dkim_settings.cfm">

<!--- ACTION HANDLERS --->
<cfif action is "save_settings">
  <cfinclude template="./inc/dkim_save_settings.cfm">
<cfelseif action is "add_entry">
  <cfinclude template="./inc/dkim_add_entry_action.cfm">
<cfelseif action is "delete_entry">
  <cfinclude template="./inc/dkim_delete_entry_action.cfm">
<cfelseif action is "edit_entry">
  <cfinclude template="./inc/dkim_edit_entry_action.cfm">
</cfif>

<!--- Re-load settings after actions --->
<cfinclude template="./inc/get_dkim_settings.cfm">

<!--- Get all entries --->
<cfquery name="getdkimbypass" datasource="hermes">
  SELECT id, entry, note FROM dkim_bypass ORDER BY entry ASC
</cfquery>

<cfquery name="getdkimtrusted" datasource="hermes">
  SELECT id, host, note FROM dkim_trusted_hosts ORDER BY host ASC
</cfquery>

<!--- Session alert variables --->
<cfparam name="session.success" default="0">
<cfparam name="session.success_entry" default="">
<cfparam name="session.invalid" default="0">
<cfparam name="session.invalid_entry" default="">
<cfparam name="session.exists" default="0">
<cfparam name="session.exists_entry" default="">

<cfset _success = session.success>
<cfset _success_entry = session.success_entry>
<cfset _invalid = session.invalid>
<cfset _invalid_entry = session.invalid_entry>
<cfset _exists = session.exists>
<cfset _exists_entry = session.exists_entry>

<cfset session.m = "">
<cfset session.success = 0>
<cfset session.success_entry = "">
<cfset session.invalid = 0>
<cfset session.invalid_entry = "">
<cfset session.exists = 0>
<cfset session.exists_entry = "">

<!--- ALERTS --->
<cfif m is "9">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    DKIM settings saved successfully. Postfix reloaded.
  </div>
</cfif>
<cfif m is "11">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    You must select entries before clicking the Delete button.
  </div>
</cfif>
<cfif m is "12">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Entries deleted successfully.
  </div>
</cfif>
<cfif m is "13">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Domain/Host field cannot be empty.
  </div>
</cfif>
<cfif m is "14">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The entry you are attempting to save already exists.
  </div>
</cfif>
<cfif m is "15">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Entry edited successfully.
  </div>
</cfif>
<cfif m is "16">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Domain/Host field cannot be empty.
  </div>
</cfif>
<cfif m is "17">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The entry is not a valid IP address, network, or domain.
  </div>
</cfif>
<cfif m is "20">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Missing required form fields.
  </div>
</cfif>

<!--- Add result alerts --->
<cfif _success GTE 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    <cfoutput>The following #_success# entries were added successfully:</cfoutput><br>
    <cfoutput>#_success_entry#</cfoutput>
  </div>
</cfif>
<cfif _invalid is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Entries</h4>
    <cfoutput>The following #_invalid# entries were invalid:</cfoutput><br>
    <cfoutput>#_invalid_entry#</cfoutput>
  </div>
</cfif>
<cfif _exists is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Duplicate Entries</h4>
    <cfoutput>The following #_exists# entries already exist:</cfoutput><br>
    <cfoutput>#_exists_entry#</cfoutput>
  </div>
</cfif>

<!-- DKIM SETTINGS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-shield-alt"></i> DKIM Settings</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="save_settings">

      <div class="callout callout-warning mb-3">
        <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i> Disabling <strong>DKIM</strong> will also disable <strong>DMARC</strong>.</p>
      </div>

      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>DKIM Enabled</strong></label>
            <select class="form-select" name="dkimenabled" id="dkimenabled">
              <option value="1" <cfif dkimenabled is "1">selected</cfif>>YES</option>
              <option value="2" <cfif dkimenabled is "2">selected</cfif>>NO</option>
            </select>
          </div>
        </div>
      </div>

      <div id="dkimPolicySettings" <cfif dkimenabled is "2">style="display:none;"</cfif>>
        <div class="row">
          <div class="col-md-6">
            <div class="mb-3">
              <label class="form-label"><strong>Body Canonicalization</strong></label>
              <select class="form-select" name="body_canonicalization">
                <option value="relaxed" <cfif body_canonicalization is "relaxed">selected</cfif>>Relaxed (Recommended)</option>
                <option value="simple" <cfif body_canonicalization is "simple">selected</cfif>>Simple</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>Headers Canonicalization</strong></label>
              <select class="form-select" name="headers_canonicalization">
                <option value="relaxed" <cfif headers_canonicalization is "relaxed">selected</cfif>>Relaxed (Recommended)</option>
                <option value="simple" <cfif headers_canonicalization is "simple">selected</cfif>>Simple</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>Default Message Action</strong></label>
              <select class="form-select" name="default_action">
                <option value="accept" <cfif default_action is "accept">selected</cfif>>Accept (Recommended)</option>
                <option value="discard" <cfif default_action is "discard">selected</cfif>>Discard</option>
                <option value="reject" <cfif default_action is "reject">selected</cfif>>Reject</option>
                <option value="tempfail" <cfif default_action is "tempfail">selected</cfif>>Temp Fail</option>
                <option value="quarantine" <cfif default_action is "quarantine">selected</cfif>>Quarantine</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>Bad Signature Action</strong></label>
              <select class="form-select" name="badsignature_action">
                <option value="accept" <cfif badsignature_action is "accept">selected</cfif>>Accept (Recommended)</option>
                <option value="discard" <cfif badsignature_action is "discard">selected</cfif>>Discard</option>
                <option value="reject" <cfif badsignature_action is "reject">selected</cfif>>Reject</option>
                <option value="tempfail" <cfif badsignature_action is "tempfail">selected</cfif>>Temp Fail</option>
                <option value="quarantine" <cfif badsignature_action is "quarantine">selected</cfif>>Quarantine</option>
              </select>
            </div>
          </div>

          <div class="col-md-6">
            <div class="mb-3">
              <label class="form-label"><strong>DNS Error Action</strong></label>
              <select class="form-select" name="dnserror_action">
                <option value="accept" <cfif dnserror_action is "accept">selected</cfif>>Accept (Recommended)</option>
                <option value="discard" <cfif dnserror_action is "discard">selected</cfif>>Discard</option>
                <option value="reject" <cfif dnserror_action is "reject">selected</cfif>>Reject</option>
                <option value="tempfail" <cfif dnserror_action is "tempfail">selected</cfif>>Temp Fail</option>
                <option value="quarantine" <cfif dnserror_action is "quarantine">selected</cfif>>Quarantine</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>Internal Error Action</strong></label>
              <select class="form-select" name="internalerror_action">
                <option value="accept" <cfif internalerror_action is "accept">selected</cfif>>Accept (Recommended)</option>
                <option value="discard" <cfif internalerror_action is "discard">selected</cfif>>Discard</option>
                <option value="reject" <cfif internalerror_action is "reject">selected</cfif>>Reject</option>
                <option value="tempfail" <cfif internalerror_action is "tempfail">selected</cfif>>Temp Fail</option>
                <option value="quarantine" <cfif internalerror_action is "quarantine">selected</cfif>>Quarantine</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>No Signature Action</strong></label>
              <select class="form-select" name="nosignature_action">
                <option value="accept" <cfif nosignature_action is "accept">selected</cfif>>Accept (Recommended)</option>
                <option value="discard" <cfif nosignature_action is "discard">selected</cfif>>Discard</option>
                <option value="reject" <cfif nosignature_action is "reject">selected</cfif>>Reject</option>
                <option value="tempfail" <cfif nosignature_action is "tempfail">selected</cfif>>Temp Fail</option>
                <option value="quarantine" <cfif nosignature_action is "quarantine">selected</cfif>>Quarantine</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>Security Concern Action</strong></label>
              <select class="form-select" name="security_action">
                <option value="accept" <cfif security_action is "accept">selected</cfif>>Accept (Recommended)</option>
                <option value="discard" <cfif security_action is "discard">selected</cfif>>Discard</option>
                <option value="reject" <cfif security_action is "reject">selected</cfif>>Reject</option>
                <option value="tempfail" <cfif security_action is "tempfail">selected</cfif>>Temp Fail</option>
                <option value="quarantine" <cfif security_action is "quarantine">selected</cfif>>Quarantine</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>Signature Algorithm</strong></label>
              <select class="form-select" name="signature_algorithm">
                <option value="rsa-sha256" <cfif signature_algorithm is "rsa-sha256">selected</cfif>>RSA-SHA256 (Recommended)</option>
                <option value="rsa-sha1" <cfif signature_algorithm is "rsa-sha1">selected</cfif>>RSA-SHA1</option>
              </select>
            </div>
          </div>
        </div>
      </div>

      <button type="submit" class="btn btn-primary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
        <i class="fas fa-save"></i> Save &amp; Apply Settings
      </button>
    </form>
  </div>
</div>

<!-- DKIM ENTRIES CARD (Whitelisted Domains + Trusted Hosts) -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list"></i> Whitelisted Domains &amp; Trusted Hosts</h3>
  </div>
  <div class="card-body">

    <!-- ADD ENTRY FORM -->
    <form method="post" autocomplete="off" class="mb-4">
      <input type="hidden" name="action" value="add_entry">
      <div class="row">
        <div class="col-md-2">
          <div class="mb-3">
            <label class="form-label"><strong>Entry Type</strong></label>
            <select class="form-select" name="entry_type">
              <option value="domain" selected>Whitelisted Domain</option>
              <option value="host">Trusted Host</option>
            </select>
          </div>
        </div>
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Entries</strong></label>
            <textarea class="form-control" name="entries" rows="3" placeholder="One entry per line"></textarea>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Note</strong></label>
            <input type="text" class="form-control" name="note" placeholder="Optional note" maxlength="255">
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

    <!-- ENTRIES TABLE -->
    <form id="deleteForm" method="post">
      <input type="hidden" name="action" value="delete_entry">
      <input type="hidden" name="delete_id" id="selectedIds" value="">

      <div class="mb-2">
        <button type="button" id="deleteBtn" class="btn btn-sm btn-danger" disabled>
          <i class="fas fa-trash-alt"></i> Delete Selected
        </button>
      </div>

      <table id="entriesTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th>Entry</th>
            <th>Type</th>
            <th>Note</th>
            <th style="width: 10%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getdkimbypass">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#id#|domain"></td>
              <td>#encodeForHTML(entry)#</td>
              <td><span class="badge bg-secondary">Whitelisted Domain</span></td>
              <td>#encodeForHTML(note)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-primary"
                  onclick="openEditModal('#id#', '#encodeForJavaScript(entry)#', '#encodeForJavaScript(note)#', 'domain');" title="Edit">
                  <i class="fas fa-edit"></i>
                </button>
              </td>
            </tr>
          </cfoutput>
          <cfoutput query="getdkimtrusted">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#id#|host"></td>
              <td>#encodeForHTML(host)#</td>
              <td><span class="badge bg-info">Trusted Host</span></td>
              <td>#encodeForHTML(note)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-primary"
                  onclick="openEditModal('#id#', '#encodeForJavaScript(host)#', '#encodeForJavaScript(note)#', 'host');" title="Edit">
                  <i class="fas fa-edit"></i>
                </button>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
    </form>

  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<!-- EDIT ENTRY MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="edit_entry">
        <input type="hidden" name="id" id="edit_id" value="">
        <input type="hidden" name="entry_type" id="edit_entry_type" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Entry</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_entry" class="form-label"><strong>Entry</strong></label>
            <input type="text" class="form-control" id="edit_entry" name="entry" maxlength="255" required>
          </div>
          <div class="mb-3">
            <label for="edit_note" class="form-label"><strong>Note</strong></label>
            <input type="text" class="form-control" id="edit_note" name="note" maxlength="255">
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

<!-- DELETE CONFIRMATION MODAL -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title">Delete Entries</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to delete the selected entries? This action is irreversible!</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
        <button type="button" class="btn btn-danger" id="confirmDelete">Yes, Delete</button>
      </div>
    </div>
  </div>
</div>

<script>
$(document).ready(function() {
  // DataTable
  $('#entriesTable').DataTable({
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

  // DKIM enabled toggle
  $('#dkimenabled').on('change', function() {
    if ($(this).val() === '2') {
      $('#dkimPolicySettings').slideUp();
    } else {
      $('#dkimPolicySettings').slideDown();
    }
  });

  // Checkbox selection for delete
  var selectedIds = new Set();

  $('#selectAll').on('change', function() {
    var checked = this.checked;
    $('.row-checkbox:visible').each(function() {
      this.checked = checked;
      if (checked) selectedIds.add(this.value); else selectedIds.delete(this.value);
    });
    $('#deleteBtn').prop('disabled', selectedIds.size === 0);
  });

  $(document).on('change', '.row-checkbox', function() {
    if (this.checked) selectedIds.add(this.value); else selectedIds.delete(this.value);
    $('#deleteBtn').prop('disabled', selectedIds.size === 0);
  });

  $('#deleteBtn').on('click', function() {
    if (selectedIds.size === 0) return;
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
  });

  $('#confirmDelete').on('click', function() {
    $('#selectedIds').val(Array.from(selectedIds).join(','));
    $('#deleteForm').submit();
  });
});

function openEditModal(id, entry, note, entryType) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_entry').value = entry;
  document.getElementById('edit_note').value = note;
  document.getElementById('edit_entry_type').value = entryType;
  new bootstrap.Modal(document.getElementById('editModal')).show();
}
</script>

</body>
</html>
