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
  <title>Hermes SEG | SPF Settings</title>
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
            <h1 class="m-0">SPF Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">SPF Settings</li>
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
<cfinclude template="./inc/get_spf_settings.cfm">

<!--- ACTION HANDLERS --->
<cfif action is "save_settings">
  <cfinclude template="./inc/spf_save_settings.cfm">
<cfelseif action is "add_whitelist">
  <cfinclude template="./inc/spf_add_whitelist.cfm">
<cfelseif action is "delete_whitelist">
  <cfinclude template="./inc/spf_delete_whitelist.cfm">
<cfelseif action is "edit_whitelist">
  <cfinclude template="./inc/spf_edit_whitelist.cfm">
</cfif>

<!--- Re-load settings after actions --->
<cfinclude template="./inc/get_spf_settings.cfm">

<!--- Get whitelist entries --->
<cfquery name="getspfbypass" datasource="hermes">
  SELECT id, entry_note, entry_type, entry FROM spf_bypass ORDER BY entry ASC
</cfquery>

<!--- Session alert variables for add whitelist --->
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
    SPF settings saved successfully. Postfix reloaded.
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
    Entries deleted successfully. Postfix reloaded.
  </div>
</cfif>
<cfif m is "13">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Entry field cannot be empty.
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
    Entry edited successfully. Postfix reloaded.
  </div>
</cfif>
<cfif m is "16">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Entry field cannot be empty.
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

<!--- Add whitelist result alerts --->
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

<!-- SPF SETTINGS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-shield-alt"></i> SPF Settings</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="save_settings">

      <div class="callout callout-warning mb-3">
        <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i> Disabling <strong>SPF</strong> will also disable <strong>DMARC</strong>.</p>
      </div>

      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>SPF Enabled</strong></label>
            <select class="form-select" name="spfenabled" id="spfenabled">
              <option value="1" <cfif spfenabled is "1">selected</cfif>>YES</option>
              <option value="2" <cfif spfenabled is "2">selected</cfif>>NO</option>
            </select>
          </div>
        </div>
      </div>

      <div id="spfPolicySettings" <cfif spfenabled is "2">style="display:none;"</cfif>>
        <div class="row">
          <div class="col-md-6">
            <div class="mb-3">
              <label class="form-label"><strong>Logging Level</strong></label>
              <small class="form-text text-muted d-block mb-1">Controls the verbosity of SPF policy daemon logging. Higher levels are useful for troubleshooting but generate more log entries.</small>
              <select class="form-select" name="debuglevel">
                <option value="1" <cfif debuglevel is "1">selected</cfif>>Level 1 (Default. Logs only basic policy results and errors.)</option>
                <option value="2" <cfif debuglevel is "2">selected</cfif>>Level 2 (Logs SPF results for each Mail From and HELO check)</option>
                <option value="3" <cfif debuglevel is "3">selected</cfif>>Level 3 (Logs SPF server start/stop and configuration)</option>
                <option value="4" <cfif debuglevel is "4">selected</cfif>>Level 4 (Logs the complete data set received by SMTP server)</option>
                <option value="0" <cfif debuglevel is "0">selected</cfif>>Level 0 (Logs only errors)</option>
                <option value="-1" <cfif debuglevel is "-1">selected</cfif>>Disabled (No logs generated. Not recommended)</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>Test Mode</strong></label>
              <small class="form-text text-muted d-block mb-1">When enabled, SPF checks run but no email is rejected. Useful for evaluating SPF impact before enforcing. Results are logged and added as headers only.</small>
              <select class="form-select" name="testonly">
                <option value="1" <cfif testonly is "1">selected</cfif>>Enabled (Run SPF in test mode, do NOT reject email)</option>
                <option value="2" <cfif testonly is "2">selected</cfif>>Disabled (Recommended. Normal operation)</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>HELO Check Rejection Policy</strong></label>
              <small class="form-text text-muted d-block mb-1">Controls how the system handles SPF results for the HELO/EHLO hostname check. The HELO identity is checked first in the SMTP dialogue before the Mail From check.</small>
              <select class="form-select" name="helo_reject">
                <option value="Fail" <cfif helo_reject is "Fail">selected</cfif>>Reject HELO Fail (Default. Reject only on HELO Fail)</option>
                <option value="SPF_Not_Pass" <cfif helo_reject is "SPF_Not_Pass">selected</cfif>>Reject All (Reject on Fail, Softfail, Neutral or PermError)</option>
                <option value="Softfail" <cfif helo_reject is "Softfail">selected</cfif>>Reject SoftFail (Reject on Softfail or Fail)</option>
                <option value="Null" <cfif helo_reject is "Null">selected</cfif>>Reject Null (Reject HELO for Null Sender. NOT Recommended)</option>
                <option value="False" <cfif helo_reject is "False">selected</cfif>>Append Only (Do NOT Reject, append SPF header only)</option>
                <option value="No_Check" <cfif helo_reject is "No_Check">selected</cfif>>Disable Check (Do NOT Check HELO)</option>
              </select>
            </div>
          </div>

          <div class="col-md-6">
            <div class="mb-3">
              <label class="form-label"><strong>Mail From Check Rejection Policy</strong></label>
              <small class="form-text text-muted d-block mb-1">Controls how the system handles SPF results for the envelope sender (MAIL FROM) check. If HELO rejection is already configured, messages failing HELO are rejected before reaching this check.</small>
              <select class="form-select" name="mail_from_reject">
                <option value="Fail" <cfif mail_from_reject is "Fail">selected</cfif>>Reject Mail From Fail (Default. Reject only on Mail From Fail)</option>
                <option value="SPF_Not_Pass" <cfif mail_from_reject is "SPF_Not_Pass">selected</cfif>>Reject All (NOT Recommended)</option>
                <option value="Softfail" <cfif mail_from_reject is "Softfail">selected</cfif>>Reject SoftFail (NOT Recommended)</option>
                <option value="False" <cfif mail_from_reject is "False">selected</cfif>>Append Only (Do NOT Reject, append SPF header only)</option>
                <option value="No_Check" <cfif mail_from_reject is "No_Check">selected</cfif>>Disable Check (Do NOT Check Mail From)</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>Permanent Error Policy</strong></label>
              <small class="form-text text-muted d-block mb-1">A PermError occurs when the sender's SPF record is malformed or contains syntax errors. Setting to False treats it as if no SPF record exists, which avoids rejecting mail due to the sender's DNS misconfiguration.</small>
              <select class="form-select" name="permerror_reject">
                <option value="False" <cfif permerror_reject is "False">selected</cfif>>False (Recommended. Treat PermError as no SPF record)</option>
                <option value="True" <cfif permerror_reject is "True">selected</cfif>>True (Reject on PermError)</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>Temporary Error Policy</strong></label>
              <small class="form-text text-muted d-block mb-1">A TempError occurs when the SPF DNS lookup times out or the DNS server is temporarily unavailable. Setting to True defers the message (4xx response) so the sender retries later, which can reduce unwanted mail but may delay legitimate messages.</small>
              <select class="form-select" name="temperror_defer">
                <option value="False" <cfif temperror_defer is "False">selected</cfif>>False (Recommended. Treat TempError as no SPF record)</option>
                <option value="True" <cfif temperror_defer is "True">selected</cfif>>True (Defer on TempError)</option>
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

<!-- SPF WHITELIST CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list"></i> SPF Whitelist Entries</h3>
  </div>
  <div class="card-body">

    <div class="alert alert-info mb-3">
      <i class="fas fa-info-circle me-1"></i> <strong>SPF Whitelist</strong> bypasses SPF checks for trusted relays, forwarders, or hosts with buggy SPF records. Entries are written to the <code>policyd-spf.conf</code> Whitelist directives.
      <hr>
      <strong>Entry Types and Examples:</strong>
      <ul class="mb-0 mt-1">
        <li><strong>IP/Network Address</strong> - Whitelists by connecting IP. Use for trusted relays such as a secondary MX or known forwarders.<br>
          Examples: <code>192.168.1.100</code> <code>10.0.0.0/24</code></li>
        <li><strong>HELO/EHLO Host Name</strong> - Whitelists by the hostname announced during SMTP handshake. A DNS check verifies the connecting IP has an A/AAAA record matching the HELO domain to prevent forgery.<br>
          Examples: <code>mail.example.com</code> <code>relay.provider.net</code></li>
        <li><strong>Domain Name</strong> - Whitelists by the sender's envelope domain (MAIL FROM).<br>
          Examples: <code>example.com</code> <code>lists.company.com</code></li>
        <li><strong>PTR Domain</strong> - Whitelists by the reverse DNS (PTR) domain of the connecting IP address.<br>
          Examples: <code>outbound.mailprovider.com</code> <code>servers.example.net</code></li>
      </ul>
      <small class="text-muted">Multiple entries can be added at once, one per line. Use IP-based whitelisting when possible to avoid DNS lookup delays.</small>
    </div>

    <!-- ADD WHITELIST FORM -->
    <form method="post" autocomplete="off" class="mb-4">
      <input type="hidden" name="action" value="add_whitelist">
      <div class="row">
        <div class="col-md-2">
          <div class="mb-3">
            <label class="form-label"><strong>Entry Type</strong></label>
            <select class="form-select" name="entry_type">
              <option value="ip" selected>IP/Network Address</option>
              <option value="helo">HELO/EHLO Host Name</option>
              <option value="domain">Domain Name</option>
              <option value="ptr">PTR Domain</option>
            </select>
          </div>
        </div>
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Entries</strong></label>
            <textarea class="form-control" name="host" rows="3" placeholder="One entry per line"></textarea>
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

    <!-- WHITELIST TABLE -->
    <form id="deleteForm" method="post">
      <input type="hidden" name="action" value="delete_whitelist">
      <input type="hidden" name="delete_id" id="selectedIds" value="">

      <div class="mb-2">
        <button type="button" id="deleteBtn" class="btn btn-sm btn-danger" disabled>
          <i class="fas fa-trash-alt"></i> Delete Selected
        </button>
      </div>

      <table id="whitelistTable" class="table table-bordered table-hover table-striped" style="width:100%">
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
          <cfoutput query="getspfbypass">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#id#"></td>
              <td>#encodeForHTML(entry)#</td>
              <td>
                <cfif entry_type is "ip"><span class="badge bg-info">IP/Network</span>
                <cfelseif entry_type is "helo"><span class="badge bg-warning">HELO/EHLO</span>
                <cfelseif entry_type is "domain"><span class="badge bg-secondary">Domain</span>
                <cfelseif entry_type is "ptr"><span class="badge bg-dark">PTR</span>
                <cfelse><span class="badge bg-light text-dark">N/A</span>
                </cfif>
              </td>
              <td>#encodeForHTML(entry_note)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-primary"
                  onclick="openEditModal('#id#', '#encodeForJavaScript(entry)#', '#encodeForJavaScript(entry_note)#', '#encodeForJavaScript(entry_type)#');" title="Edit">
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

<!-- EDIT WHITELIST MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="edit_whitelist">
        <input type="hidden" name="edit_id" id="edit_id" value="">
        <input type="hidden" name="edit_type" id="edit_type" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Whitelist Entry</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_entry" class="form-label"><strong>Entry</strong></label>
            <input type="text" class="form-control" id="edit_entry" name="edit_entry" maxlength="255" required>
          </div>
          <div class="mb-3">
            <label for="edit_note" class="form-label"><strong>Note</strong></label>
            <input type="text" class="form-control" id="edit_note" name="edit_note" maxlength="255">
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
  $('#whitelistTable').DataTable({
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

  // SPF enabled toggle
  $('#spfenabled').on('change', function() {
    if ($(this).val() === '2') {
      $('#spfPolicySettings').slideUp();
    } else {
      $('#spfPolicySettings').slideDown();
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

function openEditModal(id, entry, note, type) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_entry').value = entry;
  document.getElementById('edit_note').value = note;
  document.getElementById('edit_type').value = type;
  new bootstrap.Modal(document.getElementById('editModal')).show();
}
</script>

</body>
</html>
