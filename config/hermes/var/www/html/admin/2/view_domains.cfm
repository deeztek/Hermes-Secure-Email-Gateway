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
  <title>Hermes SEG | Email Relay - Domains</title>
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
            <h1 class="m-0">Email Relay - Domains</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Domains</li>
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

<!--- ACTION HANDLERS --->
<cfif action is "add_domain">
  <cfinclude template="./inc/domain_add_action.cfm">
<cfelseif action is "edit_domain">
  <cfinclude template="./inc/domain_edit_action.cfm">
<cfelseif action is "delete_domain">
  <cfinclude template="./inc/domain_delete_action.cfm">
</cfif>

<!--- Get all domains with transport details --->
<cfquery name="getdomains" datasource="hermes">
  SELECT d.id, d.domain, d.transport_id, d.senders_id, d.recipients_id,
    t.destination, t.port, t.mx, t.method, t.authentication,
    r.status AS recipient_status,
    CASE WHEN tp.id IS NOT NULL THEN 'YES' ELSE 'NO' END AS tls_enforced,
    COALESCE(dks.dkim_active, 0) AS dkim_active,
    COALESCE(dks.dkim_total, 0) AS dkim_total
  FROM domains d
  LEFT JOIN transport t ON t.id = d.transport_id
  LEFT JOIN recipients r ON r.id = d.recipients_id
  LEFT JOIN tls_policies tp ON tp.domain = d.domain
  LEFT JOIN (
    SELECT domain,
           SUM(CASE WHEN enabled = '1' THEN 1 ELSE 0 END) AS dkim_active,
           COUNT(*) AS dkim_total
    FROM dkim_sign
    GROUP BY domain
  ) dks ON dks.domain = d.domain
  WHERE (d.type IS NULL OR d.type = '' OR d.type = 'relay')
  ORDER BY d.domain ASC
</cfquery>

<cfset session.m = "">

<!--- ALERTS --->
<cfif m is "1">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Unable to delete domain with existing Relay Recipients. Please delete the Relay Recipients first.
  </div>
</cfif>
<cfif m is "2">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Unable to delete domain with existing Virtual Recipients. Please delete the Virtual Recipients first.
  </div>
</cfif>
<cfif m is "3">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Unable to delete domain with existing System Postmaster E-mail address. Please change the Postmaster address first.
  </div>
</cfif>
<cfif m is "4">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Unable to delete domain with existing DKIM Key(s). Please delete the DKIM Key(s) first.
  </div>
</cfif>
<cfif m is "7">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Domain deleted successfully.
  </div>
</cfif>
<cfif m is "8">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Domain added successfully.
  </div>
</cfif>
<cfif m is "9">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Domain saved successfully. Postfix reloaded.
  </div>
</cfif>
<cfif m is "10">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Domain Name field cannot be empty.
  </div>
</cfif>
<cfif m is "11">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Domain Name is not a valid domain.
  </div>
</cfif>
<cfif m is "12">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Domain Name already exists.
  </div>
</cfif>
<cfif m is "13">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Destination Address field cannot be empty.
  </div>
</cfif>
<cfif m is "14">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Destination Port must be a valid number.
  </div>
</cfif>
<cfif m is "15">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Cannot enable Destination Authentication when Relay Host is enabled.
  </div>
</cfif>
<cfif m is "16">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Destination Username cannot be empty when authentication is enabled.
  </div>
</cfif>
<cfif m is "17">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Destination Password cannot be empty when authentication is enabled.
  </div>
</cfif>
<cfif m is "20">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Missing required form fields.
  </div>
</cfif>

<!-- ADD DOMAIN CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add Domain</h3>
  </div>
  <div class="card-body">

    <!-- ADD DOMAIN FORM -->
    <form method="post" autocomplete="off" class="mb-4" id="addDomainForm">
      <input type="hidden" name="action" value="add_domain">
      <div class="row">
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Domain Name</strong></label>
            <input type="text" class="form-control" name="domain_name" placeholder="example.com" maxlength="255" required>
          </div>
        </div>
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Delivery Method</strong></label>
            <select class="form-select" name="delivery_method" id="add_delivery_method">
              <option value="smtp" selected>SMTP (Recommended)</option>
              <option value="discard">NONE (Discard All E-mail Silently)</option>
            </select>
          </div>
        </div>
        <div class="col-md-4">
          <div class="mb-3" id="add_recipient_delivery_group">
            <label class="form-label"><strong>Recipient Delivery</strong></label>
            <select class="form-select" name="recipient_delivery">
              <option value="OK" selected>ANY</option>
              <option value="">SPECIFIED</option>
            </select>
          </div>
        </div>
      </div>
      <div class="row" id="add_destination_group">
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Destination Address</strong></label>
            <input type="text" class="form-control" name="destination_address" placeholder="smtp.example.com">
          </div>
        </div>
        <div class="col-md-2">
          <div class="mb-3">
            <label class="form-label"><strong>Port</strong></label>
            <input type="text" class="form-control" name="destination_port" placeholder="25" value="25">
          </div>
        </div>
        <div class="col-md-2">
          <div class="mb-3" id="add_mx_group">
            <label class="form-label"><strong>MX Lookup</strong></label>
            <select class="form-select" name="destination_mx">
              <option value="NO" selected>NO</option>
              <option value="YES">YES</option>
            </select>
          </div>
        </div>
        <div class="col-md-2">
          <div class="mb-3">
            <label class="form-label"><strong>Auth</strong></label>
            <select class="form-select" name="destination_authentication" id="add_destination_auth">
              <option value="NO" selected>NO</option>
              <option value="YES">YES</option>
            </select>
          </div>
        </div>
      </div>
      <div class="row" id="add_auth_fields" style="display:none;">
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Destination Username</strong></label>
            <input type="text" class="form-control" name="destination_username" placeholder="username">
          </div>
        </div>
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Destination Password</strong></label>
            <div class="input-group">
              <input type="password" class="form-control" name="destination_password" id="add_password" placeholder="password">
              <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('add_password', this);">
                <i class="fas fa-eye-slash"></i>
              </button>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="mb-3">
            <div class="form-check form-switch mt-4">
              <input class="form-check-input" type="checkbox" name="enforce_tls" id="add_enforce_tls" value="1" checked>
              <label class="form-check-label" for="add_enforce_tls"><strong>Enforce TLS</strong></label>
            </div>
            <small class="text-muted">Automatically adds domain to <a href="view_smtp_tls_settings.cfm">SMTP TLS Settings &gt; TLS Policy Domains</a></small>
          </div>
        </div>
      </div>
      <button type="submit" class="btn btn-primary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
        <i class="fas fa-plus"></i> Add Domain
      </button>
    </form>

  </div>
</div>

<!-- DOMAINS LIST CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-globe"></i> Domains</h3>
  </div>
  <div class="card-body">

    <!-- DOMAINS TABLE -->
    <table id="domainsTable" class="table table-bordered table-hover table-striped" style="width:100%">
      <thead>
        <tr>
          <th>Domain</th>
          <th>Delivery</th>
          <th>Destination</th>
          <th>Port</th>
          <th>MX</th>
          <th>Recipients</th>
          <th>Auth</th>
          <th>DKIM</th>
          <th>TLS</th>
          <th style="width: 15%">Actions</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getdomains">
          <tr>
            <td>#encodeForHTML(domain)#</td>
            <td>
              <cfif method is "discard">
                <span class="badge bg-warning">Discard</span>
              <cfelse>
                <span class="badge bg-success">SMTP</span>
              </cfif>
            </td>
            <td><cfif method is "discard">-<cfelse>#encodeForHTML(destination)#</cfif></td>
            <td><cfif method is "discard">-<cfelse>#encodeForHTML(port)#</cfif></td>
            <td><cfif method is "discard">-<cfelse>#encodeForHTML(mx)#</cfif></td>
            <td>
              <cfif recipient_status is "OK">
                <span class="badge bg-info">Any</span>
              <cfelse>
                <span class="badge bg-secondary">Specified</span>
              </cfif>
            </td>
            <td>
              <cfif authentication is "YES">
                <span class="badge bg-warning">YES</span>
              <cfelse>
                <span class="badge bg-secondary">NO</span>
              </cfif>
            </td>
            <td>
              <cfif dkim_active GT 0>
                <span class="badge bg-success">Active</span>
              <cfelseif dkim_total GT 0>
                <span class="badge bg-warning">Disabled</span>
              <cfelse>
                <span class="badge bg-secondary">None</span>
              </cfif>
            </td>
            <td>
              <cfif tls_enforced is "YES">
                <span class="badge bg-success">YES</span>
              <cfelse>
                <span class="badge bg-secondary">NO</span>
              </cfif>
            </td>
            <td>
              <button type="button" class="btn btn-sm btn-primary" title="Edit"
                onclick="openEditModal(#id#);">
                <i class="fas fa-edit"></i>
              </button>
              <a href="edit_domain_dkim.cfm?id=#id#" class="btn btn-sm btn-secondary" title="DKIM Keys">
                <i class="fas fa-lock"></i>
              </a>
              <button type="button" class="btn btn-sm btn-danger" title="Delete"
                onclick="openDeleteModal(#id#, '#encodeForJavaScript(domain)#');">
                <i class="fas fa-trash-alt"></i>
              </button>
            </td>
          </tr>
        </cfoutput>
      </tbody>
    </table>

  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<!-- EDIT DOMAIN MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" autocomplete="off" id="editDomainForm">
        <input type="hidden" name="action" value="edit_domain">
        <input type="hidden" name="domain_id" id="edit_domain_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Domain</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div id="editLoading" class="text-center py-4">
            <i class="fas fa-spinner fa-spin fa-2x"></i>
            <p class="mt-2">Loading domain settings...</p>
          </div>
          <div id="editFields" style="display:none;">
            <div class="row">
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label"><strong>Domain Name</strong></label>
                  <input type="text" class="form-control" id="edit_domain_name" maxlength="255" readonly disabled>
                </div>
                <div class="mb-3">
                  <label class="form-label"><strong>Delivery Method</strong></label>
                  <select class="form-select" name="delivery_method" id="edit_delivery_method">
                    <option value="smtp">SMTP (Recommended)</option>
                    <option value="discard">NONE (Discard All E-mail Silently)</option>
                  </select>
                </div>
                <div class="mb-3" id="edit_recipient_delivery_group">
                  <label class="form-label"><strong>Recipient Delivery</strong></label>
                  <select class="form-select" name="recipient_delivery" id="edit_recipient_delivery">
                    <option value="OK">ANY</option>
                    <option value="">SPECIFIED</option>
                  </select>
                </div>
              </div>
              <div class="col-md-6" id="edit_destination_group">
                <div class="mb-3">
                  <label class="form-label"><strong>Destination Address</strong></label>
                  <input type="text" class="form-control" name="destination_address" id="edit_destination_address" placeholder="FQDN or IP Address">
                </div>
                <div class="mb-3">
                  <label class="form-label"><strong>Destination Port</strong></label>
                  <input type="text" class="form-control" name="destination_port" id="edit_destination_port" placeholder="25">
                </div>
                <div class="mb-3" id="edit_mx_group">
                  <label class="form-label"><strong>Use MX Lookup</strong></label>
                  <select class="form-select" name="destination_mx" id="edit_destination_mx">
                    <option value="NO">NO</option>
                    <option value="YES">YES</option>
                  </select>
                </div>
              </div>
            </div>
            <div class="row" id="edit_auth_section">
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label"><strong>Destination Requires Authentication</strong></label>
                  <select class="form-select" name="destination_authentication" id="edit_destination_auth">
                    <option value="NO">NO</option>
                    <option value="YES">YES</option>
                  </select>
                </div>
              </div>
            </div>
            <div class="row" id="edit_auth_fields" style="display:none;">
              <div class="col-md-4">
                <div class="mb-3">
                  <label class="form-label"><strong>Username</strong></label>
                  <input type="text" class="form-control" name="destination_username" id="edit_destination_username">
                </div>
              </div>
              <div class="col-md-4">
                <div class="mb-3">
                  <label class="form-label"><strong>Password</strong></label>
                  <div class="input-group">
                    <input type="password" class="form-control" name="destination_password" id="edit_destination_password" placeholder="Leave blank to keep current">
                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('edit_destination_password', this);">
                      <i class="fas fa-eye-slash"></i>
                    </button>
                  </div>
                  <small class="text-muted" id="edit_password_hint"></small>
                </div>
              </div>
              <div class="col-md-4">
                <div class="mb-3">
                  <div class="form-check form-switch mt-4">
                    <input class="form-check-input" type="checkbox" name="enforce_tls" id="edit_enforce_tls" value="1">
                    <label class="form-check-label" for="edit_enforce_tls"><strong>Enforce TLS</strong></label>
                  </div>
                  <small class="text-muted">Automatically adds domain to <a href="view_smtp_tls_settings.cfm">SMTP TLS Settings &gt; TLS Policy Domains</a></small>
                </div>
              </div>
            </div>
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
      <form method="post">
        <input type="hidden" name="action" value="delete_domain">
        <input type="hidden" name="domain_id" id="delete_domain_id" value="">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title">Delete Domain</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to delete <strong id="delete_domain_name"></strong>? This action is irreversible!</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          <button type="submit" class="btn btn-danger">Yes, Delete</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
$(document).ready(function() {
  $('#domainsTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[0, 'asc']],
    columnDefs: [
      { orderable: false, targets: [9] },
      { searchable: false, targets: [9] }
    ]
  });

  // Add form: delivery method toggle
  $('#add_delivery_method').on('change', function() {
    if ($(this).val() === 'discard') {
      $('#add_destination_group, #add_recipient_delivery_group, #add_auth_fields').hide();
    } else {
      $('#add_destination_group, #add_recipient_delivery_group').show();
    }
  });

  // Add form: auth toggle
  $('#add_destination_auth').on('change', function() {
    if ($(this).val() === 'YES') {
      $('#add_auth_fields').show();
      $('#add_mx_group').hide();
    } else {
      $('#add_auth_fields').hide();
      $('#add_mx_group').show();
    }
  });

  // Edit modal: delivery method toggle
  $('#edit_delivery_method').on('change', function() {
    if ($(this).val() === 'discard') {
      $('#edit_destination_group, #edit_recipient_delivery_group, #edit_auth_section, #edit_mx_group').hide();
    } else {
      $('#edit_destination_group, #edit_recipient_delivery_group, #edit_auth_section, #edit_mx_group').show();
    }
  });

  // Edit modal: auth toggle
  $('#edit_destination_auth').on('change', function() {
    if ($(this).val() === 'YES') {
      $('#edit_auth_fields').show();
      $('#edit_mx_group').hide();
    } else {
      $('#edit_auth_fields').hide();
      $('#edit_mx_group').show();
    }
  });
});

function openEditModal(domainId) {
  document.getElementById('edit_domain_id').value = domainId;
  document.getElementById('editLoading').style.display = '';
  document.getElementById('editFields').style.display = 'none';

  var modal = new bootstrap.Modal(document.getElementById('editModal'));
  modal.show();

  // Fetch domain data via AJAX
  $.ajax({
    url: './inc/get_domain_json.cfm',
    type: 'POST',
    data: { id: domainId },
    dataType: 'json',
    success: function(data) {
      if (data.error) {
        alert('Error: ' + data.error);
        return;
      }
      document.getElementById('edit_domain_name').value = data.domain;
      document.getElementById('edit_delivery_method').value = data.method;
      document.getElementById('edit_recipient_delivery').value = data.recipient_status;
      document.getElementById('edit_destination_address').value = data.destination;
      document.getElementById('edit_destination_port').value = data.port;
      document.getElementById('edit_destination_mx').value = data.mx;
      document.getElementById('edit_destination_auth').value = data.authentication;
      document.getElementById('edit_destination_username').value = data.username || '';
      document.getElementById('edit_destination_password').value = '';

      // Show masked password hint
      if (data.has_password && data.masked_password) {
        document.getElementById('edit_password_hint').textContent = 'Current: ' + data.masked_password;
      } else {
        document.getElementById('edit_password_hint').textContent = '';
      }

      // TLS toggle
      document.getElementById('edit_enforce_tls').checked = data.tls_enforced;

      // Toggle visibility
      if (data.method === 'discard') {
        $('#edit_destination_group, #edit_recipient_delivery_group, #edit_auth_section, #edit_mx_group, #edit_auth_fields').hide();
      } else {
        $('#edit_destination_group, #edit_recipient_delivery_group, #edit_auth_section, #edit_mx_group').show();
        if (data.authentication === 'YES') {
          $('#edit_auth_fields').show();
          $('#edit_mx_group').hide();
        } else {
          $('#edit_auth_fields').hide();
        }
      }

      document.getElementById('editLoading').style.display = 'none';
      document.getElementById('editFields').style.display = '';
    },
    error: function(xhr, status, error) {
      document.getElementById('editLoading').innerHTML = '<div class="alert alert-danger">Failed to load domain: ' + error + '<br>' + xhr.responseText.substring(0, 500) + '</div>';
    }
  });
}

function togglePassword(inputId, btn) {
  var input = document.getElementById(inputId);
  var icon = btn.querySelector('i');
  if (input.type === 'password') {
    input.type = 'text';
    icon.classList.remove('fa-eye-slash');
    icon.classList.add('fa-eye');
  } else {
    input.type = 'password';
    icon.classList.remove('fa-eye');
    icon.classList.add('fa-eye-slash');
  }
}

function openDeleteModal(domainId, domainName) {
  document.getElementById('delete_domain_id').value = domainId;
  document.getElementById('delete_domain_name').textContent = domainName;
  new bootstrap.Modal(document.getElementById('deleteModal')).show();
}
</script>

</body>
</html>
