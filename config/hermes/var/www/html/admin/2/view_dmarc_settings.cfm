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
  <title>Hermes SEG | DMARC Settings</title>
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
            <h1 class="m-0">DMARC Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">DMARC Settings</li>
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
<cfinclude template="./inc/get_dmarc_settings.cfm">

<!--- ACTION HANDLERS --->
<cfif action is "save_settings">
  <cfinclude template="./inc/dmarc_save_settings.cfm">
<cfelseif action is "add_domain">
  <cfinclude template="./inc/dmarc_add_domain_action.cfm">
<cfelseif action is "delete_domain">
  <cfinclude template="./inc/dmarc_delete_domain_action.cfm">
<cfelseif action is "edit_domain">
  <cfinclude template="./inc/dmarc_edit_domain_action.cfm">
</cfif>

<!--- Re-load settings after actions --->
<cfinclude template="./inc/get_dmarc_settings.cfm">

<!--- Get whitelisted domains --->
<cfquery name="getdmarcdomains" datasource="hermes">
  SELECT id, domain, note FROM dmarc_domains ORDER BY domain ASC
</cfquery>

<!--- Session alert variables --->
<cfparam name="session.success" default="0">
<cfparam name="session.success_domain" default="">
<cfparam name="session.invalid" default="0">
<cfparam name="session.invalid_domain" default="">
<cfparam name="session.exists" default="0">
<cfparam name="session.exists_domain" default="">

<cfset _success = session.success>
<cfset _success_domain = session.success_domain>
<cfset _invalid = session.invalid>
<cfset _invalid_domain = session.invalid_domain>
<cfset _exists = session.exists>
<cfset _exists_domain = session.exists_domain>

<cfset session.m = "">
<cfset session.success = 0>
<cfset session.success_domain = "">
<cfset session.invalid = 0>
<cfset session.invalid_domain = "">
<cfset session.exists = 0>
<cfset session.exists_domain = "">

<!--- ALERTS --->
<cfif m is "1">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    You must first enable both SPF and DKIM before you can enable DMARC.
  </div>
</cfif>
<cfif m is "2">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Failure Reports From E-mail Address cannot be blank.
  </div>
</cfif>
<cfif m is "3">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Failure Reports From E-mail Address must be a valid e-mail address.
  </div>
</cfif>
<cfif m is "4">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Failure Reports Reporting Organization cannot be blank.
  </div>
</cfif>
<cfif m is "5">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Failure Reports Reporting Organization can only contain letters A-Z and numbers 0-9.
  </div>
</cfif>
<cfif m is "9">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    DMARC settings saved successfully. Postfix reloaded.
  </div>
</cfif>
<cfif m is "11">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    You must select domains before clicking the Delete button.
  </div>
</cfif>
<cfif m is "12">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Domains deleted successfully.
  </div>
</cfif>
<cfif m is "13">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Domain field cannot be empty.
  </div>
</cfif>
<cfif m is "14">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The domain you are attempting to save already exists.
  </div>
</cfif>
<cfif m is "15">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Domain edited successfully.
  </div>
</cfif>
<cfif m is "16">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Domain field cannot be empty.
  </div>
</cfif>
<cfif m is "17">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The entry is not a valid domain.
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
    <cfoutput>The following #_success# domains were added successfully:</cfoutput><br>
    <cfoutput>#_success_domain#</cfoutput>
  </div>
</cfif>
<cfif _invalid is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Entries</h4>
    <cfoutput>The following #_invalid# entries were invalid domains:</cfoutput><br>
    <cfoutput>#_invalid_domain#</cfoutput>
  </div>
</cfif>
<cfif _exists is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Duplicate Entries</h4>
    <cfoutput>The following #_exists# domains already exist:</cfoutput><br>
    <cfoutput>#_exists_domain#</cfoutput>
  </div>
</cfif>

<!-- DMARC SETTINGS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-shield-alt"></i> DMARC Settings</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="save_settings">

      <div class="callout callout-warning mb-3">
        <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i> You will not be allowed to enable <strong>DMARC</strong> unless both <strong>DKIM</strong> and <strong>SPF</strong> are enabled.</p>
      </div>

      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>DMARC Enabled</strong></label>
            <select class="form-select" name="dmarcenabled" id="dmarcenabled">
              <option value="1" <cfif dmarcenabled is "1">selected</cfif>>YES</option>
              <option value="2" <cfif dmarcenabled is "2">selected</cfif>>NO</option>
            </select>
          </div>
        </div>
      </div>

      <div id="dmarcPolicySettings" <cfif dmarcenabled is "2">style="display:none;"</cfif>>
        <div class="row">
          <div class="col-md-6">
            <div class="mb-3">
              <label class="form-label"><strong>Reject Failures</strong></label>
              <small class="form-text text-muted d-block mb-1">When enabled, messages that fail DMARC evaluation are rejected (or temp-failed if evaluation could not be completed). When disabled, messages are accepted regardless of DMARC result and only an Authentication-Results header is added.</small>
              <select class="form-select" name="rejectfailures">
                <option value="true" <cfif rejectfailures is "true">selected</cfif>>YES (Recommended)</option>
                <option value="false" <cfif rejectfailures is "false">selected</cfif>>NO</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>Hold Quarantine Policy Messages</strong></label>
              <small class="form-text text-muted d-block mb-1">When enabled, messages from domains with a DMARC <code>p=quarantine</code> policy that fail DMARC checks are held in the Postfix hold queue rather than being delivered. An admin must then manually release or delete held messages. When disabled, quarantine policy messages are delivered normally with an Authentication-Results header added.</small>
              <select class="form-select" name="holdquarantinedmessages">
                <option value="false" <cfif holdquarantinedmessages is "false">selected</cfif>>NO (Recommended)</option>
                <option value="true" <cfif holdquarantinedmessages is "true">selected</cfif>>YES</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label"><strong>Generate Daily Failure Reports</strong></label>
              <small class="form-text text-muted d-block mb-1">When enabled, DMARC failure reports (formatted per RFC 6591) are generated and sent to the addresses specified in the sending domain's DMARC record. Reports are only generated for domains advertising a <code>p=quarantine</code> or <code>p=reject</code> policy.</small>
              <select class="form-select" name="failurereports" id="failurereports">
                <option value="true" <cfif failurereports is "true">selected</cfif>>YES (Recommended)</option>
                <option value="false" <cfif failurereports is "false">selected</cfif>>NO</option>
              </select>
            </div>
          </div>

          <div class="col-md-6">
            <div id="failureReportFields" <cfif failurereports is "false">style="display:none;"</cfif>>
              <div class="mb-3">
                <label class="form-label"><strong>Failure Reports From E-mail Address</strong></label>
                <small class="form-text text-muted d-block mb-1">The email address used as the sender (From:) for outgoing DMARC failure reports.</small>
                <cfoutput>
                <input type="text" class="form-control" name="report_email" value="#encodeForHTMLAttribute(report_email)#" placeholder="e.g. dmarc@yourdomain.com" autocomplete="off">
                </cfoutput>
              </div>

              <div class="mb-3">
                <label class="form-label"><strong>Failure Reports Reporting Organization</strong></label>
                <small class="form-text text-muted d-block mb-1">The organization name included in outgoing DMARC failure reports to identify your mail system as the report source.</small>
                <cfoutput>
                <input type="text" class="form-control" name="report_org" value="#encodeForHTMLAttribute(report_org)#" placeholder="e.g. MyCompany" autocomplete="off">
                </cfoutput>
              </div>
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

<!-- WHITELISTED DOMAINS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list"></i> Whitelisted Domains</h3>
  </div>
  <div class="card-body">

    <div class="alert alert-info mb-3">
      <i class="fas fa-info-circle me-1"></i> <strong>Whitelisted Domains</strong> are exempt from DMARC evaluation by OpenDMARC. Mail from these domains will not be checked against the sender's DMARC policy. Use this for trusted domains that have known DMARC configuration issues or for domains where you want to bypass DMARC enforcement. Only domain names are accepted (not IP addresses).<br>
      <small class="text-muted">Examples: <code>example.com</code> <code>mailinglist.org</code> <code>legacy-partner.net</code></small>
    </div>

    <!-- ADD DOMAIN FORM -->
    <form method="post" autocomplete="off" class="mb-4">
      <input type="hidden" name="action" value="add_domain">
      <div class="row">
        <div class="col-md-5">
          <div class="mb-3">
            <label class="form-label"><strong>Domain(s)</strong></label>
            <textarea class="form-control" name="domain" rows="3" placeholder="One domain per line"></textarea>
          </div>
        </div>
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Note</strong></label>
            <input type="text" class="form-control" name="note" placeholder="Optional note" maxlength="255">
          </div>
        </div>
        <div class="col-md-3 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add Domains
          </button>
        </div>
      </div>
    </form>

    <!-- DOMAINS TABLE -->
    <form id="deleteForm" method="post">
      <input type="hidden" name="action" value="delete_domain">
      <input type="hidden" name="delete_id" id="selectedIds" value="">

      <div class="mb-2">
        <button type="button" id="deleteBtn" class="btn btn-sm btn-danger" disabled>
          <i class="fas fa-trash-alt"></i> Delete Selected
        </button>
      </div>

      <table id="domainsTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th>Domain</th>
            <th>Note</th>
            <th style="width: 10%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getdmarcdomains">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#id#"></td>
              <td>#encodeForHTML(domain)#</td>
              <td>#encodeForHTML(note)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-primary"
                  onclick="openEditModal('#id#', '#encodeForJavaScript(domain)#', '#encodeForJavaScript(note)#');" title="Edit">
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

<!-- EDIT DOMAIN MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="edit_domain">
        <input type="hidden" name="id" id="edit_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Domain</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_domain" class="form-label"><strong>Domain</strong></label>
            <input type="text" class="form-control" id="edit_domain" name="domain" maxlength="255" required>
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
        <h5 class="modal-title">Delete Domains</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to delete the selected domains? This action is irreversible!</p>
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
  $('#domainsTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[1, 'asc']],
    columnDefs: [
      { orderable: false, targets: [0, 3] },
      { searchable: false, targets: [0, 3] }
    ]
  });

  // DMARC enabled toggle
  $('#dmarcenabled').on('change', function() {
    if ($(this).val() === '2') {
      $('#dmarcPolicySettings').slideUp();
    } else {
      $('#dmarcPolicySettings').slideDown();
    }
  });

  // Failure reports toggle
  $('#failurereports').on('change', function() {
    if ($(this).val() === 'false') {
      $('#failureReportFields').slideUp();
    } else {
      $('#failureReportFields').slideDown();
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

function openEditModal(id, domain, note) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_domain').value = domain;
  document.getElementById('edit_note').value = note;
  new bootstrap.Modal(document.getElementById('editModal')).show();
}
</script>

</body>
</html>
