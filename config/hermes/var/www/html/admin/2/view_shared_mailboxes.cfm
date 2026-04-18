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
  <title>Hermes SEG | Email Server - Shared Mailboxes</title>
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
            <h1 class="m-0">Email Server - Shared Mailboxes</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Email Server</li>
              <li class="breadcrumb-item active">Shared Mailboxes</li>
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
  <cfset session.m = "">
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION HANDLERS --->
<cfif action is "add_shared_mailbox">
  <cfinclude template="./inc/shared_mailbox_actions.cfm">
<cfelseif action is "delete_shared_mailbox">
  <cfinclude template="./inc/shared_mailbox_actions.cfm">
<cfelseif action is "add_permission">
  <cfinclude template="./inc/shared_mailbox_actions.cfm">
<cfelseif action is "remove_permission">
  <cfinclude template="./inc/shared_mailbox_actions.cfm">
</cfif>

<!--- SUCCESS / ERROR MESSAGES --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Shared mailbox created successfully.
  </div>
<cfelseif m EQ 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Shared mailbox deleted successfully.
  </div>
<cfelseif m EQ 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Permission added successfully.
  </div>
<cfelseif m EQ 4>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Permission removed successfully.
  </div>
<cfelseif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Address prefix cannot be blank.
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid address format. Use only lowercase letters, numbers, dots, hyphens, and underscores.
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid or missing mailbox domain.
  </div>
<cfelseif m EQ 13>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    This address already exists as a mailbox, alias, or virtual recipient.
  </div>
<cfelseif m EQ 14>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Quota must be a positive number.
  </div>
<cfelseif m EQ 15>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Display name cannot be blank.
  </div>
<cfelseif m EQ 20>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Missing required form fields.
  </div>
<cfelseif m EQ 21>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Shared mailbox not found.
  </div>
<cfelseif m EQ 22>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid user mailbox selected.
  </div>
<cfelseif m EQ 23>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    This user already has permissions on this shared mailbox.
  </div>
<cfelseif m EQ 24>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Permission record not found.
  </div>
<cfelseif m EQ 25>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    At least one permission must be selected.
  </div>
<cfelseif m EQ 30>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    An unexpected error occurred. Check the system log for details.
  </div>
</cfif>

<!--- HELP CALLOUT --->
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About Shared Mailboxes</h5>
  <p class="mb-1">Shared mailboxes are email addresses that multiple users can access, such as <code>info@</code>, <code>support@</code>, or <code>sales@</code>. They exist on <strong>mailbox domains</strong> and do not have their own login credentials.</p>
  <ul class="mb-1">
    <li><strong>Permissions</strong> &mdash; control what each member can do: read, write, delete, insert, or administer the shared mailbox.</li>
    <li><strong>Send-As</strong> &mdash; when enabled, allows a member to send email from the shared mailbox address.</li>
    <li><strong>Auto-Subscribe</strong> &mdash; shared mailboxes appear automatically in each member's IMAP folder list.</li>
  </ul>
  <p class="mb-0"><small>Shared mailboxes cannot log in directly. Access is managed through permissions granted to individual user mailboxes.</small></p>
</div>

<!--- GET ALL SHARED MAILBOXES --->
<cfquery name="getSharedMailboxes" datasource="hermes">
    SELECT sm.id, sm.mailbox_id, sm.address, sm.display_name, sm.domain_id, sm.auto_subscribe,
           d.domain,
           m.quota, m.active,
           (SELECT COUNT(*) FROM shared_mailbox_permissions smp WHERE smp.shared_mailbox_id = sm.id) AS member_count
    FROM shared_mailboxes sm
    INNER JOIN domains d ON d.id = sm.domain_id AND d.type = 'mailbox'
    INNER JOIN mailboxes m ON m.id = sm.mailbox_id
    ORDER BY sm.address ASC
</cfquery>

<!--- GET MAILBOX DOMAINS FOR ADD FORM --->
<cfquery name="getMailboxDomains" datasource="hermes">
    SELECT id, domain FROM domains
    WHERE type = 'mailbox'
    ORDER BY domain ASC
</cfquery>

<!--- GET MAILBOX DOMAINS FOR FILTER --->
<cfquery name="getFilterDomains" datasource="hermes">
    SELECT DISTINCT d.domain FROM domains d
    INNER JOIN shared_mailboxes sm ON d.id = sm.domain_id
    WHERE d.type = 'mailbox'
    ORDER BY d.domain ASC
</cfquery>

<!--- GET USER MAILBOXES FOR PERMISSION DROPDOWN --->
<cfquery name="getUserMailboxes" datasource="hermes">
    SELECT m.id, m.username, m.name, d.domain
    FROM mailboxes m
    INNER JOIN domains d ON m.domain_id = d.id AND d.type = 'mailbox'
    WHERE m.mailbox_type = 'user'
    AND m.active = 1
    ORDER BY m.username ASC
</cfquery>

<!--- ADD SHARED MAILBOX BUTTON + DOMAIN FILTER --->
<div class="d-flex justify-content-between align-items-center mb-3">
  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSharedMailboxModal"><i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Add Shared Mailbox</button>
  <cfif getFilterDomains.recordcount GTE 1>
  <div class="d-flex align-items-center gap-2">
    <label class="mb-0"><strong>Filter by Domain:</strong></label>
    <select class="form-control form-control-sm" id="domainFilter" style="width:auto;">
      <option value="">All Domains</option>
      <cfoutput query="getFilterDomains">
        <option value="#HTMLEditFormat(domain)#">#HTMLEditFormat(domain)#</option>
      </cfoutput>
    </select>
  </div>
  </cfif>
</div>

<!--- SHARED MAILBOXES DATATABLE --->
<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-inbox me-2"></i>Shared Mailboxes (<cfoutput>#getSharedMailboxes.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <div class="table-responsive">
    <table id="sharedMailboxesTable" class="table table-bordered table-striped" style="width:100%">
      <thead>
        <tr>
          <th>Actions</th>
          <th>Address</th>
          <th>Display Name</th>
          <th>Domain</th>
          <th>Members</th>
          <th>Quota</th>
          <th>Auto-Subscribe</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getSharedMailboxes">
        <cfset quotaGb = quota / 1024 / 1024 / 1024>
        <tr>
          <td>
            <div class="d-flex gap-1 flex-nowrap">
              <button type="button" class="btn btn-sm btn-primary" title="Manage Permissions"
                      onclick="openPermissionsModal(#id#, '#JSStringFormat(address)#', '#JSStringFormat(display_name)#')">
                <i class="fas fa-users-cog"></i>
              </button>
              <button type="button" class="btn btn-sm btn-danger" title="Delete"
                      onclick="confirmDeleteSharedMailbox(#id#, '#JSStringFormat(address)#')">
                <i class="fas fa-trash"></i>
              </button>
            </div>
          </td>
          <td>#HTMLEditFormat(address)#</td>
          <td>#HTMLEditFormat(display_name)#</td>
          <td>#HTMLEditFormat(domain)#</td>
          <td>
            <cfif member_count GT 0>
              <span class="badge bg-primary">#member_count# member<cfif member_count NEQ 1>s</cfif></span>
            <cfelse>
              <span class="badge bg-secondary">No members</span>
            </cfif>
          </td>
          <td>
            <cfif quotaGb GTE 1>
              <cfif quotaGb EQ Int(quotaGb)>#Int(quotaGb)#<cfelse>#NumberFormat(quotaGb, "0.0")#</cfif> GB
            <cfelse>
              #NumberFormat(quotaGb, "0.00")# GB
            </cfif>
          </td>
          <td>
            <cfif auto_subscribe EQ 1>
              <span class="badge bg-success">YES</span>
            <cfelse>
              <span class="badge bg-secondary">NO</span>
            </cfif>
          </td>
          <td>
            <cfif active EQ 1>
              <span class="badge bg-success">Active</span>
            <cfelse>
              <span class="badge bg-danger">Inactive</span>
            </cfif>
          </td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
    </div>
  </div>
</div>

<!--- ================================================================
     ADD SHARED MAILBOX MODAL
     ================================================================ --->
<div class="modal fade" id="addSharedMailboxModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" action="view_shared_mailboxes.cfm">
        <input type="hidden" name="action" value="add_shared_mailbox">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add Shared Mailbox</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <!--- Domain --->
          <div class="form-group mb-3">
            <label><strong>Domain</strong></label>
            <select class="form-control" name="domain_id" id="addDomainId" required>
              <cfif getMailboxDomains.recordcount EQ 0>
                <option value="">-- No mailbox domains configured --</option>
              <cfelse>
                <cfoutput query="getMailboxDomains">
                  <option value="#id#">#HTMLEditFormat(domain)#</option>
                </cfoutput>
              </cfif>
            </select>
          </div>

          <!--- Address Prefix --->
          <div class="form-group mb-3">
            <label><strong>Address Prefix</strong></label>
            <div class="input-group">
              <input type="text" class="form-control" name="address_prefix" id="addAddressPrefix" placeholder="e.g. info, support, sales" required>
              <span class="input-group-text" id="addAddressSuffix">@</span>
            </div>
            <small class="text-muted">The local part of the email address. Only lowercase letters, numbers, dots, hyphens, and underscores allowed.</small>
          </div>

          <!--- Display Name --->
          <div class="form-group mb-3">
            <label><strong>Display Name</strong></label>
            <input type="text" class="form-control" name="display_name" placeholder="e.g. Info, Support Team" required>
          </div>

          <!--- Quota --->
          <div class="form-group mb-3">
            <label><strong>Quota (GB)</strong></label>
            <input type="number" class="form-control" name="quota_gb" value="5" step="0.01" min="0.01" required>
          </div>

          <!--- Auto Subscribe --->
          <div class="form-group mb-3">
            <label><strong>Auto-Subscribe</strong></label>
            <select class="form-control" name="auto_subscribe">
              <option value="1">Yes (recommended)</option>
              <option value="0">No</option>
            </select>
            <small class="text-muted">When enabled, the shared mailbox folder automatically appears in each member's IMAP client.</small>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Create Shared Mailbox</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ================================================================
     MANAGE PERMISSIONS MODAL
     ================================================================ --->
<div class="modal fade" id="permissionsModal" tabindex="-1">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fas fa-users-cog me-2"></i>Manage Permissions - <span id="permModalAddress"></span></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">

        <!--- CURRENT MEMBERS TABLE --->
        <h6 class="mb-3"><i class="fas fa-users me-1"></i> Current Members</h6>
        <div class="table-responsive mb-4">
          <table class="table table-bordered table-sm" id="permissionsTable">
            <thead>
              <tr>
                <th>User</th>
                <th>Read</th>
                <th>Write</th>
                <th>Delete</th>
                <th>Insert</th>
                <th>Post</th>
                <th>Admin</th>
                <th>Send-As</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody id="permissionsBody">
              <tr><td colspan="9" class="text-center text-muted">Loading...</td></tr>
            </tbody>
          </table>
        </div>

        <hr>

        <!--- ADD MEMBER FORM --->
        <h6 class="mb-3"><i class="fas fa-user-plus me-1"></i> Add Member</h6>
        <form method="post" action="view_shared_mailboxes.cfm" id="addPermissionForm">
          <input type="hidden" name="action" value="add_permission">
          <input type="hidden" name="shared_mailbox_id" id="addPermSharedId">
          <div class="row">
            <div class="col-md-4 mb-3">
              <label><strong>User Mailbox</strong></label>
              <select class="form-control" name="user_mailbox_id" id="addPermUserSelect" required>
                <option value=""></option>
                <cfoutput query="getUserMailboxes">
                  <option value="#id#" data-domain="#HTMLEditFormat(domain)#">#HTMLEditFormat(username)# (#HTMLEditFormat(name)#)</option>
                </cfoutput>
              </select>
            </div>
            <div class="col-md-8 mb-3">
              <label><strong>Permissions</strong></label>
              <div class="d-flex flex-wrap gap-3 mt-1">
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" name="perm_read" id="permRead" value="1" checked>
                  <label class="form-check-label" for="permRead">Read</label>
                </div>
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" name="perm_write" id="permWrite" value="1" checked>
                  <label class="form-check-label" for="permWrite">Write</label>
                </div>
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" name="perm_delete" id="permDelete" value="1">
                  <label class="form-check-label" for="permDelete">Delete</label>
                </div>
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" name="perm_insert" id="permInsert" value="1" checked>
                  <label class="form-check-label" for="permInsert">Insert</label>
                </div>
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" name="perm_post" id="permPost" value="1">
                  <label class="form-check-label" for="permPost">Post</label>
                </div>
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" name="perm_admin" id="permAdmin" value="1">
                  <label class="form-check-label" for="permAdmin">Admin</label>
                </div>
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" name="perm_send_as" id="permSendAs" value="1">
                  <label class="form-check-label" for="permSendAs">Send-As</label>
                </div>
              </div>
              <small class="text-muted d-block mt-1">
                <strong>Read</strong> = view messages |
                <strong>Write</strong> = flag/mark messages |
                <strong>Delete</strong> = expunge messages |
                <strong>Insert</strong> = append/copy messages |
                <strong>Post</strong> = submit messages |
                <strong>Admin</strong> = manage ACLs |
                <strong>Send-As</strong> = send from shared address
              </small>
            </div>
          </div>
          <button type="submit" class="btn btn-primary"><i class="fas fa-plus me-1"></i> Add Member</button>
        </form>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!--- ================================================================
     DELETE SHARED MAILBOX CONFIRMATION MODAL
     ================================================================ --->
<div class="modal fade" id="deleteSharedMailboxModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_shared_mailboxes.cfm">
        <input type="hidden" name="action" value="delete_shared_mailbox">
        <input type="hidden" name="shared_mailbox_id" id="deleteSharedId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-trash me-2 text-danger"></i>Delete Shared Mailbox</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="alert alert-danger">
            <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
            <p>This will permanently delete the shared mailbox and remove:</p>
            <ul>
              <li>All member permissions and ACL entries</li>
              <li>Sender login maps (send-as permissions)</li>
              <li>Dovecot shared folder subscriptions</li>
              <li>Amavis policy entry</li>
            </ul>
            <p class="mb-0"><strong>This action cannot be undone.</strong></p>
          </div>
          <p>Are you sure you want to delete <strong id="deleteSharedAddress"></strong>?</p>
          <div class="form-check mt-3">
            <input class="form-check-input" type="checkbox" name="delete_maildir" id="deleteSharedMaildir" value="1" checked>
            <label class="form-check-label" for="deleteSharedMaildir">
              Also delete all email messages from the server
            </label>
            <small class="form-text text-danger d-block"><i class="fas fa-exclamation-triangle me-1"></i>When checked, all messages in this shared mailbox will be permanently removed from the mail server. This cannot be undone.</small>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete Shared Mailbox</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ================================================================
     REMOVE PERMISSION CONFIRMATION MODAL
     ================================================================ --->
<div class="modal fade" id="removePermissionModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_shared_mailboxes.cfm">
        <input type="hidden" name="action" value="remove_permission">
        <input type="hidden" name="permission_id" id="removePermId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-user-minus me-2 text-danger"></i>Remove Member</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to remove <strong id="removePermUsername"></strong> from this shared mailbox?</p>
          <p class="text-muted">This will revoke all access permissions and send-as rights for this user on the shared mailbox.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Remove Member</button>
        </div>
      </form>
    </div>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>

<script>
  var addPermUserTS;

  // Initialize DataTable and Tom Select
  $(document).ready(function() {
    var table = $('#sharedMailboxesTable').DataTable({
      "order": [[1, "asc"]],
      "pageLength": 25,
      "stateSave": true,
      "columnDefs": [
        { "orderable": false, "targets": [0] }
      ]
    });

    // Domain filter (column 3 = Domain)
    $('#domainFilter').on('change', function() {
      var val = $(this).val();
      table.column(3).search(val ? '^' + $.fn.dataTable.util.escapeRegex(val) + '$' : '', true, false).draw();
    });

    // Tom Select for user mailbox dropdown in permissions modal
    addPermUserTS = new TomSelect('#addPermUserSelect', {
      create: false,
      sortField: { field: 'text', direction: 'asc' },
      placeholder: 'Type to search mailboxes...'
    });
  });

  // Update the address suffix when domain changes
  $('#addDomainId').on('change', function() {
    var domainText = $(this).find('option:selected').text();
    $('#addAddressSuffix').text('@' + domainText);
  });
  // Trigger on load
  $(document).ready(function() {
    var domainText = $('#addDomainId').find('option:selected').text();
    if (domainText) {
      $('#addAddressSuffix').text('@' + domainText);
    }
  });

  // Open Permissions Modal and load current members via AJAX
  function openPermissionsModal(sharedId, address, displayName) {
    $('#permModalAddress').text(address + ' (' + displayName + ')');
    $('#addPermSharedId').val(sharedId);
    // Reset add permission form
    addPermUserTS.clear();
    $('#permRead').prop('checked', true);
    $('#permWrite').prop('checked', true);
    $('#permDelete').prop('checked', false);
    $('#permInsert').prop('checked', true);
    $('#permPost').prop('checked', false);
    $('#permAdmin').prop('checked', false);
    $('#permSendAs').prop('checked', false);

    // Load permissions via AJAX
    $('#permissionsBody').html('<tr><td colspan="9" class="text-center text-muted">Loading...</td></tr>');
    $.post('./inc/get_shared_mailbox_permissions_json.cfm', { shared_mailbox_id: sharedId }, function(data) {
      try {
        var perms = (typeof data === 'string') ? JSON.parse(data) : data;
        if (perms.length === 0) {
          $('#permissionsBody').html('<tr><td colspan="9" class="text-center text-muted">No members assigned yet.</td></tr>');
          return;
        }
        var html = '';
        for (var i = 0; i < perms.length; i++) {
          var p = perms[i];
          html += '<tr>';
          html += '<td>' + escapeHtml(p.username) + '</td>';
          html += '<td>' + badge(p.can_read) + '</td>';
          html += '<td>' + badge(p.can_write) + '</td>';
          html += '<td>' + badge(p.can_delete) + '</td>';
          html += '<td>' + badge(p.can_insert) + '</td>';
          html += '<td>' + badge(p.can_post) + '</td>';
          html += '<td>' + badge(p.can_admin) + '</td>';
          html += '<td>' + badge(p.send_as) + '</td>';
          html += '<td><button type="button" class="btn btn-sm btn-danger" title="Remove" onclick="confirmRemovePermission(' + p.id + ', \'' + escapeJsString(p.username) + '\')"><i class="fas fa-user-minus"></i></button></td>';
          html += '</tr>';
        }
        $('#permissionsBody').html(html);
      } catch(e) {
        $('#permissionsBody').html('<tr><td colspan="9" class="text-center text-danger">Error loading permissions.</td></tr>');
      }
    });

    new bootstrap.Modal(document.getElementById('permissionsModal')).show();
  }

  function badge(val) {
    return val == 1 ? '<span class="badge bg-success">YES</span>' : '<span class="badge bg-secondary">NO</span>';
  }

  function escapeHtml(text) {
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(text));
    return div.innerHTML;
  }

  function escapeJsString(s) {
    return String(s).replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/"/g, '\\"');
  }

  // Confirm delete shared mailbox
  function confirmDeleteSharedMailbox(sharedId, address) {
    $('#deleteSharedId').val(sharedId);
    $('#deleteSharedAddress').text(address);
    new bootstrap.Modal(document.getElementById('deleteSharedMailboxModal')).show();
  }

  // Confirm remove permission
  function confirmRemovePermission(permId, username) {
    $('#removePermId').val(permId);
    $('#removePermUsername').text(username);
    new bootstrap.Modal(document.getElementById('removePermissionModal')).show();
  }
</script>

</html>
