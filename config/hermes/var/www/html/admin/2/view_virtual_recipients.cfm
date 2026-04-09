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
  <title>Hermes SEG | Virtual Recipients</title>
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
            <h1 class="m-0">Virtual Recipients</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Virtual Recipients</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">
<cfparam name="errormessage" default="0">
<cfparam name="invalidemail" default="0">
<cfparam name="invalidemailrecipient" default="">
<cfparam name="invaliddomain" default="0">
<cfparam name="invaliddomainrecipient" default="">
<cfparam name="alreadyexists" default="0">
<cfparam name="alreadyexistsrecipient" default="">
<cfparam name="success" default="0">
<cfparam name="successrecipient" default="">

<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION HANDLERS --->
<cfif action is "add">
  <cfif NOT StructKeyExists(form, "addresses") OR trim(form.addresses) is "">
    <cfset errormessage = 1>
  <cfelseif NOT StructKeyExists(form, "forwards_1") OR trim(form.forwards_1) is "">
    <cfset errormessage = 2>
  <cfelseif NOT IsValid("email", trim(form.forwards_1))>
    <cfset errormessage = 3>
  <cfelse>
    <cfinclude template="./inc/addvirtualrecipients.cfm">
  </cfif>
<cfelseif action is "edit_entry">
  <cfinclude template="./inc/editvirtualrecipient.cfm">
<cfelseif action is "deleterecipient">
  <cfif NOT StructKeyExists(form, "recipient_id") OR form.recipient_id is "">
    <cfset session.m = 1>
    <cflocation url="view_virtual_recipients.cfm" addtoken="no">
  </cfif>
  <cfloop index="i" list="#form.recipient_id#" delimiters=",">
    <cfif IsValid("integer", i)>
      <cfset delete_id = i>
      <cfinclude template="./inc/delete_virtual_recipients.cfm">
    </cfif>
  </cfloop>
  <cfset session.m = 2>
  <cflocation url="view_virtual_recipients.cfm" addtoken="no">
</cfif>

<!--- Get data --->
<cfquery name="getvirtual" datasource="hermes">
  SELECT id, virtual_address, maps FROM virtual_recipients ORDER BY virtual_address ASC
</cfquery>

<cfset session.m = "">

<!--- HELP CALLOUT --->
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About Virtual Recipients</h5>
  <p class="mb-1">Virtual recipients forward email addresses on your <strong>relay domains</strong> to any email address, internal or external.</p>
  <ul class="mb-1">
    <li>Forward a specific address: <code>info@domain.com</code> &rarr; <code>bob@gmail.com</code></li>
    <li>Catch-all for a domain: <code>@domain.com</code> &rarr; <code>admin@domain.com</code></li>
  </ul>
  <p class="mb-0"><small>For mailbox domains (Email Server), use <a href="view_mailbox_aliases.cfm">Email Server &gt; Aliases</a> instead. Virtual recipients cannot be created for mailbox domains.</small></p>
</div>

<!--- ALERTS --->
<cfif m is "1">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    You must first select recipient(s) before clicking the Delete button.
  </div>
</cfif>
<cfif m is "2">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Recipient(s) deleted successfully.
  </div>
</cfif>
<cfif m is "3">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    Recipient edited successfully.
  </div>
</cfif>
<cfif m is "10">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Virtual Address must be a valid email address or catch-all pattern (e.g., <code>@example.com</code>).
  </div>
</cfif>
<cfif m is "11">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Delivers To field cannot be empty.
  </div>
</cfif>
<cfif m is "12">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Delivers To field must be a valid email address.
  </div>
</cfif>
<cfif m is "13">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The domain is not configured in the system.
  </div>
</cfif>
<cfif m is "14">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The recipient you are attempting to save already exists.
  </div>
</cfif>

<!--- ADD FORM ALERTS --->
<cfif success GTE 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    <cfoutput>The following #success# virtual recipients were added successfully:</cfoutput><br>
    <cfoutput>#successrecipient#</cfoutput>
  </div>
</cfif>
<cfif errormessage is "1">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Please enter at least one email address or catch-all pattern.
  </div>
</cfif>
<cfif errormessage is "2">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Delivers To field cannot be empty.
  </div>
</cfif>
<cfif errormessage is "3">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The Delivers To field must be a valid email address.
  </div>
</cfif>
<cfif invalidemail is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Entries</h4>
    <cfoutput>The following #invalidemail# entries had invalid email address(es):</cfoutput><br>
    <cfoutput>#invalidemailrecipient#</cfoutput>
  </div>
</cfif>
<cfif invaliddomain is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Domain</h4>
    <cfoutput>The following #invaliddomain# entries have domains the system does not relay:</cfoutput><br>
    <cfoutput>#invaliddomainrecipient#</cfoutput>
  </div>
</cfif>
<cfif alreadyexists is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Duplicate Entries</h4>
    <cfoutput>The following #alreadyexists# virtual recipients already exist:</cfoutput><br>
    <cfoutput>#alreadyexistsrecipient#</cfoutput>
  </div>
</cfif>

<!--- WARNING CALLOUT --->
<div class="callout callout-warning mb-4">
  <h5><i class="fas fa-exclamation-triangle"></i> Important</h5>
  <p class="mb-0">
    Virtual Recipients allow you to add a virtual email address that will deliver email to an internal or external
    recipient <strong>while bypassing ALL content checking</strong> (spam, virus, banned files).
  </p>
</div>

<!-- ADD RECIPIENTS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add Virtual Recipients</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="add">
      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label for="addresses" class="form-label"><strong>Virtual Address(es)</strong></label>
            <textarea class="form-control" id="addresses" name="addresses" rows="4"
              placeholder="user@example.com
info@example.com
@example.com"></textarea>
            <small class="text-muted">
              One entry per line. Enter a full email address (e.g., <code>user@example.com</code>)
              or a catch-all pattern (e.g., <code>@example.com</code>).
              The domain must exist in the system.
            </small>
          </div>
        </div>
        <div class="col-md-4">
          <div class="mb-3">
            <label for="forwards_1" class="form-label"><strong>Delivers To</strong></label>
            <input type="text" name="forwards_1" class="forwards form-control" id="forwards_1"
              placeholder="Start typing to search or enter address" value="" autocomplete="off">
            <small class="text-muted">
              All entries will be delivered to this address.
            </small>
          </div>
        </div>
        <div class="col-md-2 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- RECIPIENTS TABLE CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-envelope"></i> Virtual Recipients</h3>
  </div>
  <div class="card-body">
    <form id="deleteForm" method="post">
      <input type="hidden" name="action" value="deleterecipient">
      <input type="hidden" name="recipient_id" id="selectedIds" value="">

      <div class="mb-2">
        <button type="button" id="deleteBtn" class="btn btn-sm btn-danger" disabled>
          <i class="fas fa-trash-alt"></i> Delete Selected
        </button>
      </div>

      <table id="sortTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th>Recipient</th>
            <th>Delivers To</th>
            <th style="width: 10%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getvirtual">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#id#"></td>
              <td>#encodeForHTML(virtual_address)#</td>
              <td>#encodeForHTML(maps)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-primary"
                  onclick="openEditModal('#id#', '#encodeForJavaScript(virtual_address)#', '#encodeForJavaScript(maps)#');" title="Edit">
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

<!-- EDIT MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="edit_entry">
        <input type="hidden" name="edit_id" id="edit_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Virtual Recipient</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_address" class="form-label"><strong>Virtual Address</strong></label>
            <input type="text" class="form-control" id="edit_address" name="edit_address" required>
            <small class="text-muted">Full email address or catch-all pattern (e.g., <code>@example.com</code>).</small>
          </div>
          <div class="mb-3">
            <label for="edit_forwards" class="form-label"><strong>Delivers To</strong></label>
            <input type="text" class="form-control forwards" id="edit_forwards" name="edit_forwards" required>
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
        <h5 class="modal-title">Delete Recipient(s)</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to delete the selected recipient(s)? This action is irreversible!</p>
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
  $('#sortTable').DataTable({
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

  // Autocomplete for Delivers To fields
  $(document).on('keydown', '.forwards', function() {
    var id = this.id;
    $('#' + id).autocomplete({
      source: function(request, response) {
        $.ajax({
          url: "./inc/getintrecipients.cfm",
          type: 'post',
          dataType: "json",
          data: { search: request.term, request: 1 },
          success: function(data) { response(data); }
        });
      },
      select: function(event, ui) {
        $(this).val(ui.item.label);
        return false;
      }
    });
  });
});

function openEditModal(id, address, forwards) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_address').value = address;
  document.getElementById('edit_forwards').value = forwards;
  new bootstrap.Modal(document.getElementById('editModal')).show();
}
</script>

</body>
</html>
