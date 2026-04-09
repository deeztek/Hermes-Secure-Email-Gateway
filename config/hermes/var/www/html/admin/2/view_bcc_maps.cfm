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
  <title>Hermes SEG | BCC Maps</title>
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
            <h1 class="m-0">BCC Maps</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Content Checks</li>
              <li class="breadcrumb-item active">BCC Maps</li>
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
<cfif action is "add_bcc">
  <cfinclude template="./inc/add_bcc_map_action.cfm">
<cfelseif action is "edit_bcc">
  <cfinclude template="./inc/edit_bcc_map_action.cfm">
<cfelseif action is "delete_bcc">
  <cfinclude template="./inc/delete_bcc_map_action.cfm">
</cfif>

<!--- SUCCESS / ERROR MESSAGES --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    BCC map entry created successfully.
  </div>
<cfelseif m EQ 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    BCC map entry updated successfully.
  </div>
<cfelseif m EQ 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    BCC map entry deleted successfully.
  </div>
<cfelseif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Address cannot be blank.
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid address format. Use a valid email address or @domain pattern.
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    BCC To address cannot be blank.
  </div>
<cfelseif m EQ 13>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    BCC To must be a valid email address.
  </div>
<cfelseif m EQ 14>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    A BCC map entry with this address and type already exists.
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
    BCC map entry not found.
  </div>
</cfif>

<!--- HELP CALLOUT --->
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About BCC Maps</h5>
  <p class="mb-1">BCC maps create <strong>silent copies</strong> of email messages. The original delivery is unaffected and neither the sender nor recipient is aware of the copy.</p>
  <ul class="mb-1">
    <li><strong>Sender BCC</strong> &mdash; copies every email <strong>sent by</strong> the specified address (outbound monitoring)</li>
    <li><strong>Recipient BCC</strong> &mdash; copies every email <strong>received by</strong> the specified address (inbound monitoring)</li>
    <li>Supports full email addresses (<code>user@domain.com</code>) or domain-wide patterns (<code>@domain.com</code>)</li>
  </ul>
  <p class="mb-0"><small><i class="fas fa-exclamation-triangle text-warning me-1"></i><strong>SPF Warning:</strong> When the BCC target is on an external server, SPF checks may fail because the original sender's domain does not authorize your server. For reliable delivery, use a <strong>local mailbox</strong> as the BCC target or ensure the receiving server trusts your IP.</small></p>
</div>

<!--- GET ALL BCC MAPS --->
<cfquery name="getBccMaps" datasource="hermes">
    SELECT id, address, bcc_to, bcc_type, enabled, description, created_at
    FROM bcc_maps
    ORDER BY bcc_type ASC, address ASC
</cfquery>

<!--- ADD BUTTON --->
<div class="mb-3">
  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBccModal"><i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Add BCC Map</button>
</div>

<!--- BCC MAPS DATATABLE --->
<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-copy me-2"></i>BCC Maps (<cfoutput>#getBccMaps.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <table id="bccMapsTable" class="table table-bordered table-striped" style="width:100%">
      <thead>
        <tr>
          <th>Actions</th>
          <th>Address</th>
          <th>Type</th>
          <th>BCC To</th>
          <th>Status</th>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getBccMaps">
        <tr>
          <td>
            <div class="d-flex gap-1 flex-nowrap">
              <button type="button" class="btn btn-sm btn-primary" title="Edit"
                      onclick="loadEditBccModal(#id#)">
                <i class="fas fa-edit"></i>
              </button>
              <button type="button" class="btn btn-sm btn-danger" title="Delete"
                      onclick="confirmDeleteBcc(#id#, '#JSStringFormat(address)#', '#JSStringFormat(bcc_type)#')">
                <i class="fas fa-trash"></i>
              </button>
            </div>
          </td>
          <td>#HTMLEditFormat(address)#</td>
          <td>
            <cfif bcc_type EQ "sender">
              <span class="badge bg-primary">Sender</span>
            <cfelse>
              <span class="badge bg-info">Recipient</span>
            </cfif>
          </td>
          <td>#HTMLEditFormat(bcc_to)#</td>
          <td>
            <cfif enabled EQ 1>
              <span class="badge bg-success">Enabled</span>
            <cfelse>
              <span class="badge bg-secondary">Disabled</span>
            </cfif>
          </td>
          <td><cfif Len(description)>#HTMLEditFormat(description)#<cfelse><span class="text-muted">&mdash;</span></cfif></td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>

<!--- ================================================================
     ADD BCC MAP MODAL
     ================================================================ --->
<div class="modal fade" id="addBccModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_bcc_maps.cfm">
        <input type="hidden" name="action" value="add_bcc">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add BCC Map</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <div class="form-group mb-3">
            <label><strong>Address</strong></label>
            <input type="text" class="form-control" name="address" placeholder="user@domain.com or @domain.com" required>
            <small class="text-muted">Email address or @domain pattern to monitor.</small>
          </div>

          <div class="form-group mb-3">
            <label><strong>Type</strong></label>
            <select class="form-control" name="bcc_type">
              <option value="sender">Sender BCC (copies outbound mail FROM this address)</option>
              <option value="recipient">Recipient BCC (copies inbound mail TO this address)</option>
            </select>
          </div>

          <div class="form-group mb-3">
            <label><strong>BCC To</strong></label>
            <input type="email" class="form-control" name="bcc_to" placeholder="archive@domain.com" required>
            <small class="text-muted">Address that receives the silent copy. Local mailbox recommended for SPF compatibility.</small>
          </div>

          <div class="form-group mb-3">
            <label><strong>Description</strong></label>
            <input type="text" class="form-control" name="description" placeholder="Optional description (e.g., Legal compliance)">
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Create BCC Map</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ================================================================
     EDIT BCC MAP MODAL
     ================================================================ --->
<div class="modal fade" id="editBccModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_bcc_maps.cfm">
        <input type="hidden" name="action" value="edit_bcc">
        <input type="hidden" name="bcc_id" id="editBccId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit BCC Map</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <div class="form-group mb-3">
            <label><strong>Address</strong></label>
            <input type="text" class="form-control" id="editBccAddress" readonly disabled>
          </div>

          <div class="form-group mb-3">
            <label><strong>Type</strong></label>
            <input type="text" class="form-control" id="editBccType" readonly disabled>
          </div>

          <div class="form-group mb-3">
            <label><strong>BCC To</strong></label>
            <input type="email" class="form-control" name="edit_bcc_to" id="editBccTo" required>
          </div>

          <div class="form-group mb-3">
            <label><strong>Status</strong></label>
            <select class="form-control" name="edit_enabled" id="editBccEnabled">
              <option value="1">Enabled</option>
              <option value="0">Disabled</option>
            </select>
          </div>

          <div class="form-group mb-3">
            <label><strong>Description</strong></label>
            <input type="text" class="form-control" name="edit_description" id="editBccDescription">
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
<div class="modal fade" id="deleteBccModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_bcc_maps.cfm">
        <input type="hidden" name="action" value="delete_bcc">
        <input type="hidden" name="delete_bcc_id" id="deleteBccId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-trash me-2 text-danger"></i>Delete BCC Map</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to delete the <strong id="deleteBccType"></strong> BCC map for <strong id="deleteBccAddress"></strong>?</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete</button>
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
  $(document).ready(function() {
    $('#bccMapsTable').DataTable({
      "order": [[2, "asc"], [1, "asc"]],
      "pageLength": 25,
      "stateSave": true,
      "columnDefs": [
        { "orderable": false, "targets": [0] }
      ]
    });
  });

  function loadEditBccModal(bccId) {
    $.post('./inc/get_bcc_map_json.cfm', { id: bccId }, function(data) {
      try {
        var b = (typeof data === 'string') ? JSON.parse(data) : data;
        if (b.error) { alert('Error: ' + b.error); return; }
        $('#editBccId').val(b.id);
        $('#editBccAddress').val(b.address);
        $('#editBccType').val(b.bcc_type === 'sender' ? 'Sender BCC' : 'Recipient BCC');
        $('#editBccTo').val(b.bcc_to);
        $('#editBccEnabled').val(b.enabled);
        $('#editBccDescription').val(b.description);
        new bootstrap.Modal(document.getElementById('editBccModal')).show();
      } catch(e) { alert('Error loading BCC map data.'); }
    });
  }

  function confirmDeleteBcc(bccId, address, bccType) {
    $('#deleteBccId').val(bccId);
    $('#deleteBccAddress').text(address);
    $('#deleteBccType').text(bccType === 'sender' ? 'Sender' : 'Recipient');
    new bootstrap.Modal(document.getElementById('deleteBccModal')).show();
  }
</script>

</html>
