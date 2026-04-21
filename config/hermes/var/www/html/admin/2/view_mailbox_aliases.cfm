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
  <title>Hermes SEG | Email Server - Aliases</title>
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
            <h1 class="m-0">Email Server - Aliases</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Email Server</li>
              <li class="breadcrumb-item active">Aliases</li>
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
<cfif action is "add_alias">
  <cfinclude template="./inc/add_mailbox_alias_action.cfm">
<cfelseif action is "edit_alias">
  <cfinclude template="./inc/edit_mailbox_alias_action.cfm">
<cfelseif action is "delete_alias">
  <cfinclude template="./inc/delete_mailbox_alias_action.cfm">
</cfif>

<!--- SUCCESS / ERROR MESSAGES --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Alias created successfully.
  </div>
<cfelseif m EQ 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Alias updated successfully.
  </div>
<cfelseif m EQ 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Alias deleted successfully.
  </div>
<cfelseif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Alias address cannot be blank.
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid email address format.
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The domain is not a mailbox domain. Aliases can only be created for mailbox domains.
  </div>
<cfelseif m EQ 13>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    This address already exists as a mailbox. Use the Mailboxes page to manage it.
  </div>
<cfelseif m EQ 14>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    An alias with this address already exists.
  </div>
<cfelseif m EQ 15>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Delivers To address is required for forward aliases.
  </div>
<cfelseif m EQ 16>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The target mailbox does not exist. The alias must deliver to an existing mailbox.
  </div>
<cfelseif m EQ 17>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    This address already exists as a virtual recipient under Email Relay. Remove it there first.
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
    Alias not found.
  </div>
</cfif>

<!--- HELP CALLOUT --->
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About Aliases</h5>
  <p class="mb-1">Aliases are alternate email addresses on your <strong>mailbox domains</strong> that deliver to an existing local mailbox or silently discard mail.</p>
  <ul class="mb-1">
    <li><strong>Forward</strong> &mdash; delivers mail to a local mailbox (e.g., <code>sales@domain.com</code> &rarr; <code>tina@domain.com</code>). Optionally allows the mailbox user to send as the alias address.</li>
    <li><strong>Discard</strong> &mdash; silently drops all mail with no bounce (e.g., <code>noreply@domain.com</code>).</li>
  </ul>
  <p class="mb-0"><small>To forward to external email addresses or for relay domains, use <a href="view_virtual_recipients.cfm">Email Relay &gt; Virtual Recipients</a> instead.</small></p>
</div>

<!--- GET ALL MAILBOX ALIASES --->
<cfquery name="getAliases" datasource="hermes">
    SELECT ma.id, ma.alias_address, ma.delivers_to, ma.alias_type, ma.send_as,
           d.domain
    FROM mailbox_aliases ma
    INNER JOIN domains d ON d.id = ma.domain_id AND d.type = 'mailbox'
    ORDER BY ma.alias_address ASC
</cfquery>

<!--- GET MAILBOX DOMAINS FOR DOMAIN FILTER --->
<cfquery name="getFilterDomains" datasource="hermes">
    SELECT DISTINCT d.domain FROM domains d
    INNER JOIN mailbox_aliases ma ON d.id = ma.domain_id
    WHERE d.type = 'mailbox'
    ORDER BY d.domain ASC
</cfquery>

<!--- GET ALL MAILBOXES FOR DELIVERS-TO DROPDOWN --->
<cfquery name="getMailboxes" datasource="hermes">
    SELECT username FROM mailboxes
    WHERE mailbox_type = 'user'
    ORDER BY username ASC
</cfquery>

<!--- ADD ALIAS BUTTON + DOMAIN FILTER --->
<div class="d-flex justify-content-between align-items-center mb-3">
  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAliasModal"><i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Add Alias</button>
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

<!--- ALIASES DATATABLE --->
<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-share me-2"></i>Aliases (<cfoutput>#getAliases.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <div class="table-responsive">
    <table id="aliasesTable" class="table table-bordered table-striped" style="width:100%">
      <thead>
        <tr>
          <th>Actions</th>
          <th>Alias</th>
          <th>Domain</th>
          <th>Type</th>
          <th>Delivers To</th>
          <th>Send-As</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getAliases">
        <tr>
          <td>
            <div class="d-flex gap-1 flex-nowrap">
              <button type="button" class="btn btn-sm btn-primary" title="Edit"
                      onclick="loadEditAliasModal(#id#)">
                <i class="fas fa-edit"></i>
              </button>
              <button type="button" class="btn btn-sm btn-danger" title="Delete"
                      onclick="confirmDeleteAlias(#id#, '#JSStringFormat(alias_address)#')">
                <i class="fas fa-trash"></i>
              </button>
            </div>
          </td>
          <td>#HTMLEditFormat(alias_address)#</td>
          <td>#HTMLEditFormat(domain)#</td>
          <td>
            <cfif alias_type EQ "discard">
              <span class="badge bg-dark">Discard</span>
            <cfelse>
              <span class="badge bg-primary">Forward</span>
            </cfif>
          </td>
          <td>
            <cfif alias_type EQ "discard">
              <span class="text-muted"><i class="fas fa-ban me-1"></i>Silently dropped</span>
            <cfelse>
              #HTMLEditFormat(delivers_to)#
            </cfif>
          </td>
          <td>
            <cfif alias_type EQ "forward" AND send_as EQ 1>
              <span class="badge bg-success">YES</span>
            <cfelseif alias_type EQ "forward">
              <span class="badge bg-secondary">NO</span>
            <cfelse>
              <span class="text-muted">&mdash;</span>
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
     ADD ALIAS MODAL
     ================================================================ --->
<div class="modal fade" id="addAliasModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" action="view_mailbox_aliases.cfm">
        <input type="hidden" name="action" value="add_alias">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add Alias</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <!--- Alias Address --->
          <div class="form-group mb-3">
            <label><strong>Alias Address</strong></label>
            <input type="email" class="form-control" name="alias_address" placeholder="noreply@domain.com" required>
            <small class="text-muted">Must be on a mailbox domain. Cannot be an existing mailbox address.</small>
          </div>

          <!--- Alias Type --->
          <div class="form-group mb-3">
            <label><strong>Type</strong></label>
            <select class="form-control" name="alias_type" id="addAliasType">
              <option value="forward">Forward (deliver to mailbox)</option>
              <option value="discard">Discard (silently drop all mail)</option>
            </select>
          </div>

          <!--- Delivers To (shown for forward only) --->
          <div class="form-group mb-3" id="addDeliversToGroup">
            <label><strong>Delivers To</strong></label>
            <select class="form-control" name="delivers_to" id="addDeliversTo" placeholder="Type to search mailboxes...">
              <option value=""></option>
              <cfoutput query="getMailboxes">
                <option value="#HTMLEditFormat(username)#">#HTMLEditFormat(username)#</option>
              </cfoutput>
            </select>
            <small class="text-muted">The mailbox that will receive mail sent to the alias address.</small>
          </div>

          <!--- Send-As (shown for forward only) --->
          <div class="form-group mb-3" id="addSendAsGroup">
            <label><strong>Allow Send-As</strong></label>
            <div class="alert alert-info">
              <i class="icon fas fa-info-circle"></i>
              When enabled, the target mailbox user can send email as the alias address. They can configure it as an additional identity in their email client.
            </div>
            <select class="form-control" name="send_as">
              <option value="0">No</option>
              <option value="1">Yes</option>
            </select>
          </div>

          <!--- Discard info (shown for discard only) --->
          <div class="form-group mb-3" id="addDiscardInfo" style="display:none;">
            <div class="alert alert-warning">
              <h5><i class="icon fas fa-exclamation-triangle"></i> Discard Mode</h5>
              <p class="mb-0">All mail sent to this address will be silently dropped. No bounce or error message will be sent to the sender. Use this for addresses like <code>noreply@</code> or <code>donotreply@</code>.</p>
            </div>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Create Alias</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ================================================================
     EDIT ALIAS MODAL
     ================================================================ --->
<div class="modal fade" id="editAliasModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" action="view_mailbox_aliases.cfm">
        <input type="hidden" name="action" value="edit_alias">
        <input type="hidden" name="alias_id" id="editAliasId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Alias</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <!--- Alias Address (read-only) --->
          <div class="form-group mb-3">
            <label><strong>Alias Address</strong></label>
            <input type="text" class="form-control" id="editAliasAddress" readonly disabled>
          </div>

          <!--- Alias Type --->
          <div class="form-group mb-3">
            <label><strong>Type</strong></label>
            <select class="form-control" name="edit_alias_type" id="editAliasType">
              <option value="forward">Forward (deliver to mailbox)</option>
              <option value="discard">Discard (silently drop all mail)</option>
            </select>
          </div>

          <!--- Delivers To --->
          <div class="form-group mb-3" id="editDeliversToGroup">
            <label><strong>Delivers To</strong></label>
            <select class="form-control" name="edit_delivers_to" id="editDeliversTo" placeholder="Type to search mailboxes...">
              <option value=""></option>
              <cfoutput query="getMailboxes">
                <option value="#HTMLEditFormat(username)#">#HTMLEditFormat(username)#</option>
              </cfoutput>
            </select>
          </div>

          <!--- Send-As --->
          <div class="form-group mb-3" id="editSendAsGroup">
            <label><strong>Allow Send-As</strong></label>
            <select class="form-control" name="edit_send_as" id="editSendAs">
              <option value="0">No</option>
              <option value="1">Yes</option>
            </select>
          </div>

          <!--- Discard info --->
          <div class="form-group mb-3" id="editDiscardInfo" style="display:none;">
            <div class="alert alert-warning">
              <h5><i class="icon fas fa-exclamation-triangle"></i> Discard Mode</h5>
              <p class="mb-0">All mail sent to this address will be silently dropped.</p>
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

<!--- ================================================================
     DELETE CONFIRMATION MODAL
     ================================================================ --->
<div class="modal fade" id="deleteAliasModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_mailbox_aliases.cfm">
        <input type="hidden" name="action" value="delete_alias">
        <input type="hidden" name="delete_alias_id" id="deleteAliasId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-trash me-2 text-danger"></i>Delete Alias</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to delete the alias <strong id="deleteAliasAddress"></strong>?</p>
          <p class="text-muted">This will also remove any send-as permissions and Amavis policy entries for this alias.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete Alias</button>
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
  // Tom Select instances (need references to set values programmatically)
  var addDeliversToTS, editDeliversToTS;

  // Initialize DataTable and Tom Select
  $(document).ready(function() {
    var table = $('#aliasesTable').DataTable({
      "order": [[1, "asc"]],
      "pageLength": 25,
      "stateSave": true,
      "columnDefs": [
        { "orderable": false, "targets": [0] }
      ]
    });

    // Domain filter (column 2 = Domain)
    $('#domainFilter').on('change', function() {
      var val = $(this).val();
      table.column(2).search(val ? '^' + $.fn.dataTable.util.escapeRegex(val) + '$' : '', true, false).draw();
    });

    // Initialize Tom Select on Delivers To dropdowns (type-to-search, no custom entries)
    addDeliversToTS = new TomSelect('#addDeliversTo', {
      create: false,
      sortField: { field: 'text', direction: 'asc' },
      placeholder: 'Type to search mailboxes...'
    });

    editDeliversToTS = new TomSelect('#editDeliversTo', {
      create: false,
      sortField: { field: 'text', direction: 'asc' },
      placeholder: 'Type to search mailboxes...'
    });
  });

  // Add modal: toggle forward/discard fields
  $('#addAliasType').on('change', function() {
    if ($(this).val() === 'discard') {
      $('#addDeliversToGroup').hide();
      $('#addSendAsGroup').hide();
      $('#addDiscardInfo').show();
      $('#addDeliversTo').prop('required', false);
    } else {
      $('#addDeliversToGroup').show();
      $('#addSendAsGroup').show();
      $('#addDiscardInfo').hide();
    }
  });

  // Edit modal: toggle forward/discard fields
  $('#editAliasType').on('change', function() {
    if ($(this).val() === 'discard') {
      $('#editDeliversToGroup').hide();
      $('#editSendAsGroup').hide();
      $('#editDiscardInfo').show();
    } else {
      $('#editDeliversToGroup').show();
      $('#editSendAsGroup').show();
      $('#editDiscardInfo').hide();
    }
  });

  // Load edit modal via AJAX
  function loadEditAliasModal(aliasId) {
    $.post('./inc/get_mailbox_alias_json.cfm', { id: aliasId }, function(data) {
      try {
        var a = (typeof data === 'string') ? JSON.parse(data) : data;
        if (a.error) { alert('Error: ' + a.error); return; }
        $('#editAliasId').val(a.id);
        $('#editAliasAddress').val(a.alias_address);
        $('#editAliasType').val(a.alias_type).trigger('change');
        if (a.alias_type === 'forward') {
          editDeliversToTS.setValue(a.delivers_to);
        } else {
          editDeliversToTS.clear();
        }
        $('#editSendAs').val(a.send_as);
        new bootstrap.Modal(document.getElementById('editAliasModal')).show();
      } catch(e) { alert('Error loading alias data.'); }
    });
  }

  // Confirm delete
  function confirmDeleteAlias(aliasId, address) {
    $('#deleteAliasId').val(aliasId);
    $('#deleteAliasAddress').text(address);
    new bootstrap.Modal(document.getElementById('deleteAliasModal')).show();
  }
</script>

</html>
