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

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | SMTP TLS Settings</title>
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
            <h1 class="m-0">SMTP TLS Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">SMTP TLS Settings</li>
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
<cfinclude template="./inc/get_smtp_tls_settings.cfm">
<cfinclude template="./inc/get_smtp_tls_policies.cfm">

<cfset tls_mode = smtpd_tls_security_level.parameter>
<cfset smtpCertificate = smtpd_tls_certificate.value2>

<!--- ACTION HANDLERS --->
<cfif action is "save_settings">
  <cfinclude template="./inc/smtp_tls_save_settings.cfm">
<cfelseif action is "add_domain">
  <cfinclude template="./inc/smtp_tls_add_domain.cfm">
<cfelseif action is "edit_domain">
  <cfinclude template="./inc/smtp_tls_edit_domain.cfm">
<cfelseif action is "delete_domain">
  <cfinclude template="./inc/smtp_tls_delete_domain.cfm">
</cfif>

<!--- Re-load after actions --->
<cfinclude template="./inc/get_smtp_tls_settings.cfm">
<cfinclude template="./inc/get_smtp_tls_policies.cfm">

<cfset tls_mode = smtpd_tls_security_level.parameter>
<cfset smtpCertificate = smtpd_tls_certificate.value2>

<cfset session.m = "">

<!--- ALERTS --->
<cfif m is "1">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The SMTP TLS Certificate cannot be blank when TLS Mode is set to Opportunistic or Mandatory.
  </div>
</cfif>
<cfif m is "2">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The SMTP TLS Certificate you entered is not valid.
  </div>
</cfif>
<cfif m is "63">
  <cfset badCertFile = StructKeyExists(session, "smtpTlsBadCertFile") ? session.smtpTlsBadCertFile : "">
  <cfset session.smtpTlsBadCertFile = "">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Certificate files are missing</h4>
    <p>Nothing was saved and the previous certificate is still in use.</p>
    <cfif Len(Trim(badCertFile))>
      <p class="mb-1">Postfix would have been pointed at a file that does not exist:</p>
      <p class="mb-2"><code><cfoutput>#encodeForHTML(badCertFile)#</cfoutput></code></p>
    </cfif>
    <p class="mb-0"><small>A certificate can appear in this list before it has actually been
    issued, and its record survives if its files are later removed. Postfix has no fallback for
    the SMTP TLS certificate, so binding one that is not on disk would stop mail being accepted
    over TLS. Check the certificate has completed issuing under
    <a href="view_system_certificates.cfm">System Certificates</a>, then try again.</small></p>
  </div>
</cfif>
<cfif m is "3">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    You cannot select the system-self-signed Certificate for SMTP TLS.
  </div>
</cfif>
<cfif m is "4">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The domain entered is not valid.
  </div>
</cfif>
<cfif m is "5">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The domain you are attempting to add already exists.
  </div>
</cfif>
<cfif m is "6">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The domain you are attempting to edit already exists.
  </div>
</cfif>
<cfif m is "20">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Missing required form fields.
  </div>
</cfif>
<cfif m is "34">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Domain deleted successfully. Postfix reloaded.
  </div>
</cfif>
<cfif m is "35">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    SMTP TLS settings saved successfully. Postfix reloaded.
  </div>
</cfif>
<cfif m is "36">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    SMTP TLS disabled successfully. Postfix reloaded.
  </div>
</cfif>
<cfif m is "37">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Domain added successfully. Postfix reloaded.
  </div>
</cfif>
<cfif m is "38">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    SMTP TLS settings applied successfully. Postfix reloaded.
  </div>
</cfif>
<cfif m is "39">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Domain edited successfully. Postfix reloaded.
  </div>
</cfif>

<!-- SMTP TLS SETTINGS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fab fa-expeditedssl"></i> SMTP TLS Settings</h3>
  </div>
  <div class="card-body">
    <form name="SetTlsMode" method="post" autocomplete="off">
      <input type="hidden" name="action" value="save_settings">
      <cfoutput>
      <input type="hidden" name="certificateno_1" id="certificateno_1" value="#smtpCertificate#">
      </cfoutput>

      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label"><strong>SMTP TLS Mode</strong></label>
            <select class="form-select" name="tlsmode" id="tlsmode">
              <option value="" <cfif tls_mode is "">selected</cfif>>Disabled</option>
              <option value="may" <cfif tls_mode is "may">selected</cfif>>Opportunistic TLS (Recommended)</option>
              <option value="encrypt" <cfif tls_mode is "encrypt">selected</cfif>>Mandatory TLS (NOT Recommended for Internet Facing Servers)</option>
            </select>
          </div>
        </div>
      </div>

      <div id="tlscertificate" <cfif tls_mode is "">style="display:none;"</cfif>>
        <div class="callout callout-warning mb-3">
          <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i> Do <strong>NOT</strong> select the <strong>system-self-signed</strong> Certificate.</p>
        </div>

        <div class="row">
          <div class="col-md-6">
            <div class="mb-3">
              <label class="form-label"><strong>SMTP TLS Certificate</strong></label>
              <cfoutput>
              <!--- No name attribute: the server reads the hidden
                   certificateno_1 id and ignores this field. --->
              <select class="certificate remote-picker form-control" id="certificate_1"
                      data-endpoint="./inc/getcertificates.cfm"
                      data-target-id="certificateno_1"
                      data-target-type="type_1"
                      data-target-subject="subject_1"
                      data-target-issuer="issuer_1"
                      data-target-serial="serial_1"
                      placeholder="Click to choose a certificate, or type to search...">
                <cfif Trim(smtpCertificate) is not "" AND Trim(getcertdetails.friendly_name) is not "">
                  <option value="#encodeForHTMLAttribute(smtpCertificate)#" selected>#encodeForHTML(getcertdetails.friendly_name)#</option>
                </cfif>
              </select>
              </cfoutput>
            </div>
            <div class="mb-3">
              <label class="form-label"><strong>Certificate Subject</strong></label>
              <cfoutput>
              <input type="text" name="subject_1" class="form-control" id="subject_1" value="#getcertdetails.subject#" readonly>
              </cfoutput>
            </div>
          </div>
          <div class="col-md-6">
            <div class="mb-3">
              <label class="form-label"><strong>Certificate Issuer</strong></label>
              <cfoutput>
              <input type="text" name="issuer_1" class="form-control" id="issuer_1" value="#getcertdetails.issuer#" readonly>
              </cfoutput>
            </div>
            <div class="mb-3">
              <label class="form-label"><strong>Certificate Serial</strong></label>
              <cfoutput>
              <input type="text" name="serial_1" class="form-control" id="serial_1" value="#getcertdetails.serial#" readonly>
              </cfoutput>
            </div>
            <div class="mb-3">
              <label class="form-label"><strong>Certificate Type</strong></label>
              <cfoutput>
              <input type="text" name="type_1" class="form-control" id="type_1" value="#getcertdetails.type#" readonly>
              </cfoutput>
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

<!-- TLS POLICY DOMAINS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list"></i> TLS Policy Domains</h3>
  </div>
  <div class="card-body">

    <div class="callout callout-warning mb-3">
      <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i> Encryption for the domains listed below will not be in effect unless the <strong>SMTP TLS Mode</strong> is set to <strong>Opportunistic TLS</strong> and you have selected a valid <strong>SMTP TLS Certificate</strong> above.</p>
    </div>

    <!-- ADD DOMAIN FORM -->
    <form method="post" autocomplete="off" class="mb-4">
      <input type="hidden" name="action" value="add_domain">
      <div class="row">
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Domain</strong></label>
            <input type="text" class="form-control" name="domain" placeholder="domain.tld or .domain.tld" maxlength="64">
            <div class="form-text">Adding a "." prefix will match the domain and all subdomains</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Note</strong></label>
            <input type="text" class="form-control" name="domain_note" placeholder="Optional note" maxlength="255">
          </div>
        </div>
        <div class="col-md-4 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add Domain
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

      <table id="policiesTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th>Domain</th>
            <th>Encryption Mode</th>
            <th>Note</th>
            <th style="width: 10%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getpolicies">
            <cfset isAutoAdded = (description EQ "Auto-added: domain requires authentication")>
            <tr>
              <td><cfif isAutoAdded>&nbsp;<cfelse><input type="checkbox" class="row-checkbox" value="#id#"></cfif></td>
              <td>#encodeForHTML(domain)#</td>
              <td><cfif method is "encrypt"><span class="badge bg-success">Mandatory</span><cfelse><span class="badge bg-secondary">N/A</span></cfif></td>
              <td>
                <cfif isAutoAdded>
                  <span class="badge bg-info">Managed by <a href="view_domains.cfm" class="text-white">Domains</a></span>
                <cfelse>
                  #encodeForHTML(description)#
                </cfif>
              </td>
              <td>
                <cfif isAutoAdded>
                  &nbsp;
                <cfelse>
                  <button type="button" class="btn btn-sm btn-primary"
                    onclick="openEditModal('#id#', '#encodeForJavaScript(domain)#', '#encodeForJavaScript(description)#');" title="Edit">
                    <i class="fas fa-edit"></i>
                  </button>
                </cfif>
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
        <input type="hidden" name="edit_id" id="edit_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit TLS Policy Domain</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="callout callout-warning mb-3">
            <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i> Adding a "." prefix will match the domain and all subdomains (e.g., .domain.tld)</p>
          </div>
          <div class="mb-3">
            <label for="edit_domain" class="form-label"><strong>Domain</strong></label>
            <input type="text" class="form-control" id="edit_domain" name="domain" maxlength="64" required>
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
  $('#policiesTable').DataTable({
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

  // TLS mode toggle
  $('#tlsmode').on('change', function() {
    if ($(this).val() === '') {
      $('#tlscertificate').slideUp();
    } else {
      $('#tlscertificate').slideDown();
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

  // The certificate picker's jQuery UI autocomplete lived here. It is now a
  // TomSelect driven by inc/remote_picker_js.cfm.
});

function openEditModal(id, domain, note) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_domain').value = domain;
  document.getElementById('edit_note').value = note;
  new bootstrap.Modal(document.getElementById('editModal')).show();
}
</script>

<cfinclude template="./inc/remote_picker_js.cfm">

</body>
</html>
