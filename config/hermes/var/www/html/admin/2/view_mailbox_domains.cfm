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
  <title>Hermes SEG | Email Server - Domains</title>
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
            <h1 class="m-0">Email Server - Domains</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Email Server</li>
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
<cfif action is "add_mailbox_domain">
  <cfinclude template="./inc/mailbox_domain_add_action.cfm">
<cfelseif action is "edit_mailbox_domain">
  <cfinclude template="./inc/mailbox_domain_edit_action.cfm">
<cfelseif action is "delete_mailbox_domain">
  <cfinclude template="./inc/mailbox_domain_delete_action.cfm">
</cfif>

<!--- Edition check --->
<cfset isPro = isDefined("session.edition") AND session.edition EQ "Pro">

<!--- Get all mailbox-hosting domains joined with cert binding + DKIM status --->
<cfquery name="getmailboxdomains" datasource="hermes">
  SELECT d.id AS domain_id, d.domain,
         d.default_quota_mb, d.catchall_mailbox,
         d.nextcloud_enabled, d.nextcloud_group,
         md.mailbox_certificate,
         sc.friendly_name AS cert_friendly_name,
         sc.type AS cert_type,
         sc.file_name AS cert_file_name,
         COALESCE(dks.dkim_active, 0) AS dkim_active,
         COALESCE(dks.dkim_total, 0) AS dkim_total
  FROM domains d
  LEFT JOIN mailbox_domains md ON md.domain = d.domain
  LEFT JOIN system_certificates sc ON sc.id = md.mailbox_certificate
  LEFT JOIN (
    SELECT domain,
           SUM(CASE WHEN enabled = '1' THEN 1 ELSE 0 END) AS dkim_active,
           COUNT(*) AS dkim_total
    FROM dkim_sign
    GROUP BY domain
  ) dks ON dks.domain = d.domain
  WHERE d.type = 'mailbox'
  ORDER BY d.domain ASC
</cfquery>

<!--- Get all certificates usable for mailbox SAN binding --->
<cfquery name="getCerts" datasource="hermes">
  SELECT id, friendly_name, domain_name, type, file_name
  FROM system_certificates
  WHERE san = '1'
  ORDER BY friendly_name ASC
</cfquery>

<cfset session.m = "">

<!--- ALERTS --->
<cfif m is "1">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Mailbox domain added successfully. Certificate validation will run on the next scheduled cycle (every 30 minutes).
  </div>
</cfif>
<cfif m is "2">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Mailbox domain updated successfully.
  </div>
</cfif>
<cfif m is "3">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Mailbox domain deleted successfully.
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
    This domain already exists (as a relay or mailbox domain). Delete the existing entry first.
  </div>
</cfif>
<cfif m is "13">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Please select a valid SAN certificate.
  </div>
</cfif>
<cfif m is "14">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Auto-managed (Let's Encrypt) certificates require Pro Edition.
  </div>
</cfif>
<cfif m is "15">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Default Mailbox Quota must be a positive number (MB).
  </div>
</cfif>
<cfif m is "20">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Missing required form fields.
  </div>
</cfif>

<!--- Orphan certificate notice after deletion --->
<cfif StructKeyExists(session, "orphan_cert_id") AND IsNumeric(session.orphan_cert_id)>
<cfoutput>
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5 class="alert-heading"><i class="fas fa-info-circle"></i> Orphaned Certificate</h5>
  <p class="mb-1">
    Certificate <strong>#encodeForHTML(session.orphan_cert_name)#</strong>
    (#encodeForHTML(session.orphan_cert_type)#) is no longer bound to any mailbox domain.
  </p>
  <p class="mb-0 small">
    You may delete it via <a href="view_system_certificates.cfm">System Certificates</a>.
    <cfif session.orphan_cert_type IS "Acme">
    <strong>Note:</strong> Let's Encrypt limits <em>duplicate</em> certificates to 5 per week.
    If you may need this exact SAN set again soon, keep the cert.
    </cfif>
  </p>
</div>
</cfoutput>
<cfset session.orphan_cert_id = "">
<cfset session.orphan_cert_name = "">
<cfset session.orphan_cert_type = "">
</cfif>

<!--- Pro upsell tip for Community edition --->
<cfif NOT isPro>
<div class="alert alert-warning alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5 class="alert-heading"><i class="fas fa-star"></i> Pro Tip</h5>
  <p class="mb-0">
    Upgrade to <strong>Pro Edition</strong> to automatically manage Let's Encrypt SAN certificates for
    your mailbox domains &mdash; zero-touch validation, issuance, and renewal.
    <a href="https://www.deeztek.com/hermes-secure-email-gateway/" target="_blank">Learn More &rarr;</a>
  </p>
</div>
</cfif>

<!-- ADD MAILBOX DOMAIN CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add Mailbox Domain</h3>
  </div>
  <div class="card-body">

    <p class="text-muted">
      Mailbox domains host local Dovecot mailboxes. Mail for these domains is delivered via
      <code>lmtp:[hermes_dovecot]:24</code> after content scanning. Each domain requires a SAN
      certificate covering the system SAN prefixes (<code>autodiscover.</code>,
      <code>autoconfig.</code>) plus any additional prefixes you've added to
      <code>additional_sans</code> for client auto-configuration.
    </p>

    <!-- ADD MAILBOX DOMAIN FORM -->
    <form method="post" autocomplete="off" class="mb-4" id="addMailboxDomainForm">
      <input type="hidden" name="action" value="add_mailbox_domain">

      <div class="row">
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Domain Name</strong></label>
            <input type="text" class="form-control" name="domain_name" placeholder="example.com" maxlength="255" required>
          </div>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Default Quota (GB)</strong></label>
            <input type="number" class="form-control" name="default_quota_gb" value="5" min="0.5" max="1024" step="0.5" required>
          </div>
        </div>
        <div class="col-md-5">
          <div class="mb-3">
            <label class="form-label"><strong>Catch-All Mailbox</strong></label>
            <input type="text" class="form-control" name="catchall_mailbox" placeholder="postmaster@example.com (optional)">
          </div>
        </div>
      </div>

      <!-- SAN CERTIFICATE SELECTION -->
      <label class="form-label"><strong>SAN Certificate</strong></label>

      <div class="card mb-2 <cfif NOT isPro>border-warning<cfelse>border-success</cfif>">
        <div class="card-body py-2">
          <div class="form-check">
            <input class="form-check-input" type="radio" name="cert_mode" value="auto"
                   id="add_cert_mode_auto"
                   <cfif NOT isPro>disabled</cfif>
                   <cfif isPro>checked</cfif>>
            <label class="form-check-label w-100" for="add_cert_mode_auto">
              <strong>Auto-managed (Let's Encrypt)</strong>
              <cfif NOT isPro>
                <span class="badge bg-warning text-dark ms-2"><i class="fas fa-lock"></i> PRO</span>
              <cfelse>
                <span class="badge bg-success ms-2">PRO</span>
              </cfif>
            </label>
            <p class="text-muted small mb-0 mt-1 ms-4">
              System creates SANs, validates IP+DNS, requests cert, and auto-renews &mdash; zero maintenance.
            </p>
            <cfif NOT isPro>
            <div class="alert alert-warning mt-2 mb-0 py-2 small ms-4">
              <i class="fas fa-star text-warning"></i>
              <strong>Upgrade to Pro Edition</strong> to unlock automatic certificate management.
              <a href="https://www.deeztek.com/hermes-secure-email-gateway/" target="_blank">Learn More &rarr;</a>
            </div>
            </cfif>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <div class="card-body py-2">
          <div class="form-check">
            <input class="form-check-input" type="radio" name="cert_mode" value="existing"
                   id="add_cert_mode_existing"
                   <cfif NOT isPro>checked</cfif>>
            <label class="form-check-label w-100" for="add_cert_mode_existing">
              <strong>Use existing certificate</strong>
            </label>
            <div class="ms-4 mt-2">
              <select class="form-select" name="cert_id" id="add_cert_id">
                <option value="">-- Select certificate --</option>
                <cfoutput query="getCerts">
                <option value="#id#">#encodeForHTMLAttribute(friendly_name)# (#type#<cfif Len(domain_name)> - #encodeForHTMLAttribute(domain_name)#</cfif>)</option>
                </cfoutput>
              </select>
              <small class="text-muted">
                Only SAN-enabled certificates are shown. For imported certs, verify it includes
                <code>autodiscover.</code> and <code>autoconfig.</code> subdomains (plus any
                custom SAN prefixes configured in your system).
              </small>
            </div>
          </div>
        </div>
      </div>

      <div class="row align-items-center">
        <div class="col-md-6">
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" name="nextcloud_enabled" id="add_nextcloud_enabled" value="1">
            <label class="form-check-label" for="add_nextcloud_enabled">
              <strong>Enable Nextcloud webmail for this domain</strong>
            </label>
          </div>
        </div>
        <div class="col-md-6 text-md-end">
          <button type="submit" class="btn btn-primary">
            <i class="fas fa-plus"></i> Add Domain
          </button>
        </div>
      </div>
    </form>

  </div>
</div>

<!-- MAILBOX DOMAINS LIST CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-inbox"></i> Mailbox Domains</h3>
  </div>
  <div class="card-body">

    <!-- DOMAINS TABLE -->
    <table id="mailboxDomainsTable" class="table table-striped table-bordered" style="width:100%">
      <thead>
        <tr>
          <th>Domain</th>
          <th>Certificate</th>
          <th>Default Quota</th>
          <th>Catch-All</th>
          <th>Nextcloud</th>
          <th>DKIM</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getmailboxdomains">
          <tr>
            <td><strong>#encodeForHTML(domain)#</strong></td>
            <td>
              <cfif Len(cert_friendly_name)>
                #encodeForHTML(cert_friendly_name)#
                <cfif cert_type IS "Acme">
                  <span class="badge bg-info ms-1">Auto (LE)</span>
                <cfelse>
                  <span class="badge bg-secondary ms-1">Imported</span>
                </cfif>
              <cfelse>
                <span class="badge bg-danger">Missing</span>
              </cfif>
            </td>
            <td><cfset quotaGb = default_quota_mb / 1024><cfif quotaGb EQ Int(quotaGb)>#Int(quotaGb)#<cfelse>#NumberFormat(quotaGb, "0.0")#</cfif> GB</td>
            <td>
              <cfif Len(catchall_mailbox)>
                #encodeForHTML(catchall_mailbox)#
              <cfelse>
                <span class="text-muted">&mdash;</span>
              </cfif>
            </td>
            <td>
              <cfif nextcloud_enabled is 1>
                <span class="badge bg-success">Enabled</span>
              <cfelse>
                <span class="badge bg-secondary">Disabled</span>
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
              <button type="button" class="btn btn-sm btn-primary" title="Edit"
                onclick="openEditModal(#domain_id#);">
                <i class="fas fa-edit"></i>
              </button>
              <a href="edit_domain_dkim.cfm?id=#domain_id#" class="btn btn-sm btn-secondary" title="DKIM Keys">
                <i class="fas fa-lock"></i>
              </a>
              <button type="button" class="btn btn-sm btn-danger" title="Delete"
                onclick="openDeleteModal(#domain_id#, '#encodeForJavaScript(domain)#');">
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

<!-- EDIT MAILBOX DOMAIN MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" autocomplete="off" id="editMailboxDomainForm">
        <input type="hidden" name="action" value="edit_mailbox_domain">
        <input type="hidden" name="domain_id" id="edit_domain_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Mailbox Domain</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div id="editLoading" class="text-center py-4">
            <i class="fas fa-spinner fa-spin fa-2x"></i>
            <p class="mt-2">Loading domain settings...</p>
          </div>
          <div id="editFields" style="display:none;">

            <div class="mb-3">
              <label class="form-label"><strong>Domain Name</strong></label>
              <input type="text" class="form-control" id="edit_domain_name" readonly disabled>
              <small class="text-muted">Domain name cannot be changed after creation.</small>
            </div>

            <label class="form-label"><strong>SAN Certificate</strong></label>
            <div class="card mb-2 <cfif NOT isPro>border-warning<cfelse>border-success</cfif>">
              <div class="card-body py-2">
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="cert_mode" value="auto"
                         id="edit_cert_mode_auto"
                         <cfif NOT isPro>disabled</cfif>>
                  <label class="form-check-label w-100" for="edit_cert_mode_auto">
                    <strong>Auto-managed (Let's Encrypt)</strong>
                    <cfif NOT isPro>
                      <span class="badge bg-warning text-dark ms-2"><i class="fas fa-lock"></i> PRO</span>
                    <cfelse>
                      <span class="badge bg-success ms-2">PRO</span>
                    </cfif>
                  </label>
                </div>
              </div>
            </div>

            <div class="card mb-3">
              <div class="card-body py-2">
                <div class="form-check">
                  <input class="form-check-input" type="radio" name="cert_mode" value="existing"
                         id="edit_cert_mode_existing">
                  <label class="form-check-label w-100" for="edit_cert_mode_existing">
                    <strong>Use existing certificate</strong>
                  </label>
                  <div class="ms-4 mt-2">
                    <select class="form-select" name="cert_id" id="edit_cert_id">
                      <option value="">-- Select certificate --</option>
                      <cfoutput query="getCerts">
                      <option value="#id#">#encodeForHTMLAttribute(friendly_name)# (#type#<cfif Len(domain_name)> - #encodeForHTMLAttribute(domain_name)#</cfif>)</option>
                      </cfoutput>
                    </select>
                  </div>
                </div>
              </div>
            </div>

            <hr>

            <div class="row">
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label"><strong>Default Mailbox Quota (GB)</strong></label>
                  <input type="number" class="form-control" name="default_quota_gb" id="edit_default_quota_gb" min="0.5" max="1024" step="0.5" required>
                </div>
              </div>
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label"><strong>Catch-All Mailbox</strong></label>
                  <input type="text" class="form-control" name="catchall_mailbox" id="edit_catchall_mailbox" placeholder="postmaster@example.com">
                </div>
              </div>
            </div>

            <div class="form-check form-switch mb-2">
              <input class="form-check-input" type="checkbox" name="nextcloud_enabled" id="edit_nextcloud_enabled" value="1">
              <label class="form-check-label" for="edit_nextcloud_enabled">
                <strong>Enable Nextcloud webmail for this domain</strong>
              </label>
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
        <input type="hidden" name="action" value="delete_mailbox_domain">
        <input type="hidden" name="domain_id" id="delete_domain_id" value="">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title">Delete Mailbox Domain</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to delete <strong id="delete_domain_name"></strong>?</p>
          <p>This will remove:</p>
          <ul>
            <li>The domain's Postfix transport, sender, and recipient rules</li>
            <li>All SAN subdomains (<code>mail.</code>, <code>autodiscover.</code>, <code>autoconfig.</code>, <code>imap.</code>, <code>pop.</code>, <code>smtp.</code>)</li>
            <li>The mailbox domain record</li>
          </ul>
          <div class="alert alert-warning py-2 mb-2">
            <i class="fas fa-exclamation-triangle"></i>
            <strong>Mailbox data on disk is NOT deleted.</strong> Remove mailbox directories manually if needed.
          </div>
          <div class="alert alert-info py-2 mb-0 small">
            <i class="fas fa-info-circle"></i>
            If the bound certificate has no other domains, you will be prompted to delete it as well.
            Note: Let's Encrypt limits duplicate certificates to 5 per week &mdash; avoid deleting and
            re-requesting the same cert repeatedly.
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
$(document).ready(function() {
  $('#mailboxDomainsTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[0, 'asc']],
    columnDefs: [
      { orderable: false, targets: [6] },
      { searchable: false, targets: [6] }
    ]
  });

  // Add form: cert mode toggle enables/disables cert select
  $('input[name="cert_mode"]').on('change', function() {
    var modalContext = $(this).closest('.modal').attr('id');
    var prefix = (modalContext === 'addModal') ? 'add_' : 'edit_';
    if ($(this).val() === 'existing') {
      $('#' + prefix + 'cert_id').prop('disabled', false);
    } else {
      $('#' + prefix + 'cert_id').prop('disabled', true).val('');
    }
  });
});

function openEditModal(mailboxDomainId) {
  document.getElementById('edit_domain_id').value = mailboxDomainId;
  document.getElementById('editLoading').style.display = '';
  document.getElementById('editFields').style.display = 'none';

  var modal = new bootstrap.Modal(document.getElementById('editModal'));
  modal.show();

  $.ajax({
    url: './inc/get_mailbox_domain_json.cfm',
    type: 'POST',
    data: { id: mailboxDomainId },
    dataType: 'json',
    success: function(data) {
      if (data.error) {
        alert('Error: ' + data.error);
        return;
      }
      document.getElementById('edit_domain_name').value = data.domain;
      document.getElementById('edit_default_quota_gb').value = (data.default_quota_mb / 1024).toFixed(2).replace(/\.?0+$/, '');
      document.getElementById('edit_catchall_mailbox').value = data.catchall_mailbox || '';
      document.getElementById('edit_nextcloud_enabled').checked = (data.nextcloud_enabled == 1);

      // Determine cert mode
      if (data.cert_type === 'Acme') {
        document.getElementById('edit_cert_mode_auto').checked = true;
        document.getElementById('edit_cert_id').value = '';
        document.getElementById('edit_cert_id').disabled = true;
      } else {
        document.getElementById('edit_cert_mode_existing').checked = true;
        document.getElementById('edit_cert_id').value = data.cert_id || '';
        document.getElementById('edit_cert_id').disabled = false;
      }

      document.getElementById('editLoading').style.display = 'none';
      document.getElementById('editFields').style.display = '';
    },
    error: function(xhr, status, error) {
      document.getElementById('editLoading').innerHTML =
        '<div class="alert alert-danger">Failed to load domain: ' + error + '</div>';
    }
  });
}

function openDeleteModal(mailboxDomainId, domainName) {
  document.getElementById('delete_domain_id').value = mailboxDomainId;
  document.getElementById('delete_domain_name').textContent = domainName;
  var modal = new bootstrap.Modal(document.getElementById('deleteModal'));
  modal.show();
}
</script>

</body>
</html>
