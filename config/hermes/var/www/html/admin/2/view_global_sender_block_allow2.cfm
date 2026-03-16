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
  <title>Hermes SEG | Global Sender Block/Allow</title>

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
            <h1 class="m-0">Global Sender Block/Allow</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Global Sender Block/Allow</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
  <cfif session.m is not ""><cfset m = session.m></cfif>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(url, "action")>
  <cfif url.action is not ""><cfset action = url.action></cfif>
</cfif>
<cfif StructKeyExists(form, "action")>
  <cfif form.action is not ""><cfset action = form.action></cfif>
</cfif>

<!--- GET DATA --->
<cfinclude template="./inc/get_global_sender_block_allow.cfm">

<!--- ===================== --->
<!--- ACTION: ADD ENTRIES --->
<!--- ===================== --->
<cfif action is "add_entries">
  <cfset entries_added = 0>
  <cfset entries_skipped = 0>
  <cfset entry_errors = "">

  <cfif NOT StructKeyExists(form, "entries") OR trim(form.entries) is "">
    <cfset session.m = 30>
    <cflocation url="view_global_sender_block_allow2.cfm" addtoken="no">
  </cfif>

  <cfset entryType = "block">
  <cfif StructKeyExists(form, "entry_type") AND form.entry_type is "allow">
    <cfset entryType = "allow">
  </cfif>

  <cfset entryText = Replace(form.entries, Chr(13) & Chr(10), Chr(10), "ALL")>
  <cfset entryText = Replace(entryText, Chr(13), Chr(10), "ALL")>
  <cfset lines = ListToArray(entryText, Chr(10))>

  <cfloop array="#lines#" index="line">
    <cfset line = trim(line)>
    <cfif line is ""><cfcontinue></cfif>

    <!--- Validate: must be a valid email address, domain, or .domain (leading dot for root-domain match) --->
    <cfset isEmail = REFind("[@]", line) GT 0>
    <cfset isDotDomain = Left(line, 1) is ".">

    <cfif isEmail>
      <cfif NOT IsValid("email", line)>
        <cfset entries_skipped = entries_skipped + 1>
        <cfset entry_errors = entry_errors & "Invalid email: " & encodeForHTML(line) & "<br>">
        <cfcontinue>
      </cfif>
    <cfelseif isDotDomain>
      <!--- Leading-dot domain validation: .domain.tld matches domain and all subdomains --->
      <cfset testDomain = Mid(line, 2, Len(line))>
      <cfif NOT IsValid("email", "test@" & testDomain)>
        <cfset entries_skipped = entries_skipped + 1>
        <cfset entry_errors = entry_errors & "Invalid domain: " & encodeForHTML(line) & "<br>">
        <cfcontinue>
      </cfif>
    <cfelse>
      <!--- Plain domain validation --->
      <cfif NOT IsValid("email", "test@" & line)>
        <cfset entries_skipped = entries_skipped + 1>
        <cfset entry_errors = entry_errors & "Invalid domain: " & encodeForHTML(line) & "<br>">
        <cfcontinue>
      </cfif>
    </cfif>

    <!--- Check for duplicates --->
    <cfquery name="checkDup" datasource="hermes">
      SELECT COUNT(*) as cnt FROM amavis_sender_bypass
      WHERE sender = <cfqueryparam value="#line#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkDup.cnt GT 0>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Duplicate: " & encodeForHTML(line) & "<br>">
      <cfcontinue>
    </cfif>

    <cfquery datasource="hermes">
      INSERT INTO amavis_sender_bypass (sender, transport, action, type, applied)
      VALUES (
        <cfqueryparam value="#line#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="FILTER amavis:[127.0.0.1]:10030" cfsqltype="cf_sql_varchar">,
        'add',
        <cfqueryparam value="#entryType#" cfsqltype="cf_sql_varchar">,
        '2'
      )
    </cfquery>
    <cfset entries_added = entries_added + 1>
  </cfloop>

  <cfset session.entries_added = entries_added>
  <cfset session.entries_skipped = entries_skipped>
  <cfset session.entry_errors = entry_errors>
  <cfset session.m = 1>
  <cflocation url="view_global_sender_block_allow2.cfm" addtoken="no">
</cfif>

<!--- ACTION: DELETE --->
<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <cfquery datasource="hermes">
      UPDATE amavis_sender_bypass SET action = 'delete', applied = '2'
      WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.m = 2>
  </cfif>
  <cflocation url="view_global_sender_block_allow2.cfm" addtoken="no">
</cfif>

<!--- ACTION: BULK DELETE --->
<cfif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <cfquery datasource="hermes">
          UPDATE amavis_sender_bypass SET action = 'delete', applied = '2'
          WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
      </cfif>
    </cfloop>
    <cfset session.m = 2>
  </cfif>
  <cflocation url="view_global_sender_block_allow2.cfm" addtoken="no">
</cfif>

<!--- ACTION: EDIT --->
<cfif action is "edit_entry">
  <cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)>
    <cfquery datasource="hermes">
      UPDATE amavis_sender_bypass
      SET sender = <cfqueryparam value="#trim(form.edit_sender)#" cfsqltype="cf_sql_varchar">,
          type = <cfqueryparam value="#form.edit_type#" cfsqltype="cf_sql_varchar">,
          action = 'add', applied = '2'
      WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.m = 5>
  </cfif>
  <cflocation url="view_global_sender_block_allow2.cfm" addtoken="no">
</cfif>

<!--- ACTION: CANCEL ADD --->
<cfif action is "cancel_add">
  <cfquery datasource="hermes">
    DELETE FROM amavis_sender_bypass WHERE action = 'add' AND applied = '2'
  </cfquery>
  <cfset session.m = 6>
  <cflocation url="view_global_sender_block_allow2.cfm" addtoken="no">
</cfif>

<!--- ACTION: CANCEL DELETE --->
<cfif action is "cancel_delete">
  <cfquery datasource="hermes">
    UPDATE amavis_sender_bypass SET action = 'NONE', applied = '1'
    WHERE action = 'delete' AND applied = '2'
  </cfquery>
  <cfset session.m = 7>
  <cflocation url="view_global_sender_block_allow2.cfm" addtoken="no">
</cfif>

<!--- ACTION: APPLY --->
<cfif action is "apply">
  <!--- Delete entries marked for deletion --->
  <cfquery datasource="hermes">
    DELETE FROM amavis_sender_bypass WHERE action = 'delete' AND applied = '2'
  </cfquery>

  <!--- Mark all remaining as applied --->
  <cfquery datasource="hermes">
    UPDATE amavis_sender_bypass SET action = 'NONE', applied = '1' WHERE applied = '2'
  </cfquery>

  <cftry>
    <!--- Get all allow entries for config files --->
    <cfquery name="getAllow" datasource="hermes">
      SELECT sender, transport FROM amavis_sender_bypass
      WHERE type = 'allow' AND applied = '1' AND action = 'NONE'
      ORDER BY sender ASC
    </cfquery>

    <!--- Get all block entries for config files --->
    <cfquery name="getBlock" datasource="hermes">
      SELECT sender FROM amavis_sender_bypass
      WHERE type = 'block' AND applied = '1' AND action = 'NONE'
      ORDER BY sender ASC
    </cfquery>

    <!--- Build Postfix amavis_senderbypass content (allow entries with transport) --->
    <cfset FileDataAllowPostfix = "">
    <cfloop query="getAllow">
      <cfset FileDataAllowPostfix = FileDataAllowPostfix & getAllow.sender & Chr(32) & getAllow.transport & Chr(13) & Chr(10)>
    </cfloop>

    <!--- Write amavis_senderbypass file for Postfix --->
    <cffile action="write" file="/etc/postfix/amavis_senderbypass" output="#FileDataAllowPostfix#" addnewline="no">

    <!--- Build Amavis whitelist (allow entries) --->
    <cfset FileDataAllowAmavis = "">
    <cfloop query="getAllow">
      <cfset FileDataAllowAmavis = FileDataAllowAmavis & getAllow.sender & Chr(10)>
    </cfloop>

    <!--- Write white.lst for Amavis --->
    <cffile action="write" file="/etc/amavis/white.lst" output="#FileDataAllowAmavis##Chr(10)#" addnewline="no">

    <!--- Build Amavis blacklist (block entries) --->
    <cfset FileDataBlockAmavis = "">
    <cfloop query="getBlock">
      <cfset FileDataBlockAmavis = FileDataBlockAmavis & getBlock.sender & Chr(10)>
    </cfloop>

    <!--- Write black.lst for Amavis --->
    <cffile action="write" file="/etc/amavis/black.lst" output="#FileDataBlockAmavis##Chr(10)#" addnewline="no">

    <!--- Postmap the amavis_senderbypass file via Docker exec --->
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_postfix_dkim /usr/sbin/postmap /etc/postfix/amavis_senderbypass"
      timeout="60" />

    <!--- Set ownership for Postfix --->
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_postfix_dkim chown root:root /etc/postfix/amavis_senderbypass"
      timeout="60" />
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_postfix_dkim chown root:root /etc/postfix/amavis_senderbypass.db"
      timeout="60" />

    <!--- Reload Postfix via Docker --->
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_postfix_dkim /usr/sbin/postfix reload"
      timeout="60" />

    <!--- Reload Amavis via Docker --->
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
      timeout="60" />

    <cfset session.m = 3>
    <cfcatch type="any">
      <cfset session.m = 4>
    </cfcatch>
  </cftry>
  <cflocation url="view_global_sender_block_allow2.cfm" addtoken="no">
</cfif>

<!--- Refresh data --->
<cfinclude template="./inc/get_global_sender_block_allow.cfm">
<cfset session.m = "">

<!--- ALERTS --->
<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Entries Added</h4>
    <cfif StructKeyExists(session, "entries_added")>
      <p><cfoutput>#session.entries_added#</cfoutput> entries staged for addition.</p>
      <cfset session.entries_added = "">
    </cfif>
    <cfif StructKeyExists(session, "entries_skipped") AND session.entries_skipped GT 0>
      <p><cfoutput>#session.entries_skipped#</cfoutput> entries skipped.</p>
      <cfset session.entries_skipped = "">
    </cfif>
    <cfif StructKeyExists(session, "entry_errors") AND session.entry_errors is not "">
      <p><cfoutput>#session.entry_errors#</cfoutput></p>
      <cfset session.entry_errors = "">
    </cfif>
    <p>Click <strong>Apply Settings</strong> to activate.</p>
  </div>
</cfif>
<cfif m is 2>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Marked for Deletion</h4>
    <p>Click <strong>Apply Settings</strong> to confirm.</p>
  </div>
</cfif>
<cfif m is 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Settings Applied</h4>
    <p>Global sender block/allow configuration applied. Postfix reloaded and Amavis restarted.</p>
  </div>
</cfif>
<cfif m is 4>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Apply Failed</h4>
    <p>An error occurred while applying settings. Check container logs for details.</p>
  </div>
</cfif>
<cfif m is 5>
  <div class="alert alert-info alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-edit"></i> Entry Updated</h4>
    <p>Click <strong>Apply Settings</strong> to activate.</p>
  </div>
</cfif>
<cfif m is 6>
  <div class="alert alert-info alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-undo"></i> Pending Additions Cancelled</h4>
  </div>
</cfif>
<cfif m is 7>
  <div class="alert alert-info alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-undo"></i> Pending Deletions Cancelled</h4>
  </div>
</cfif>
<cfif m is 30>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Please enter at least one email address or domain.</p>
  </div>
</cfif>

<!--- WARNING CALLOUT --->
<div class="callout callout-danger mb-4">
  <h5><i class="fas fa-exclamation-triangle"></i> Use Extreme Caution</h5>
  <p class="mb-1">
    Any <strong>Allow</strong> entries will bypass <strong>ALL</strong> filter checks including Spam, Virus, and Banned File checks
    for <strong>ALL</strong> recipients in your system. Do not use if at all possible. A Global Sender Block/Allow entry takes
    precedence over any Sender to Recipient Block/Allow entries.
  </p>
  <p class="mb-0">
    To match an entire domain <strong>and all of its subdomains</strong>, enter a leading dot (e.g., <code>.example.com</code>).
    This is a powerful rule &mdash; use it with extreme care, as it will affect <strong>every</strong> email from
    <code>example.com</code>, <code>sub.example.com</code>, etc. for all recipients.
    To match only a single domain (no subdomains), enter it without a leading dot (e.g., <code>example.com</code>).
  </p>
</div>

<!--- PENDING CHANGES --->
<cfif has_pending_changes>
  <cfif get_pending_adds.recordCount GT 0>
    <div class="card card-warning card-outline mb-4">
      <div class="card-header">
        <h3 class="card-title"><i class="fas fa-clock"></i> Pending Additions (<cfoutput>#get_pending_adds.recordCount#</cfoutput>)</h3>
      </div>
      <div class="card-body">
        <cfoutput query="get_pending_adds">
          <span class="badge <cfif type is 'allow'>bg-success<cfelse>bg-danger</cfif> me-1">+ #encodeForHTML(sender)# (#type#)</span>
        </cfoutput>
        <div class="mt-3">
          <form method="post" class="d-inline">
            <input type="hidden" name="action" value="cancel_add">
            <button type="submit" class="btn btn-sm btn-secondary"><i class="fas fa-undo"></i> Cancel Additions</button>
          </form>
        </div>
      </div>
    </div>
  </cfif>
  <cfif get_pending_deletes.recordCount GT 0>
    <div class="card card-danger card-outline mb-4">
      <div class="card-header">
        <h3 class="card-title"><i class="fas fa-clock"></i> Pending Deletions (<cfoutput>#get_pending_deletes.recordCount#</cfoutput>)</h3>
      </div>
      <div class="card-body">
        <cfoutput query="get_pending_deletes">
          <span class="badge bg-danger me-1">- #encodeForHTML(sender)#</span>
        </cfoutput>
        <div class="mt-3">
          <form method="post" class="d-inline">
            <input type="hidden" name="action" value="cancel_delete">
            <button type="submit" class="btn btn-sm btn-secondary"><i class="fas fa-undo"></i> Cancel Deletions</button>
          </form>
        </div>
      </div>
    </div>
  </cfif>
  <div class="mb-4">
    <form method="post" class="d-inline">
      <input type="hidden" name="action" value="apply">
      <button type="submit" class="btn btn-danger btn-lg"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Applying...';this.form.submit();">
        <i class="fas fa-check-circle"></i> Apply Settings
      </button>
    </form>
  </div>
</cfif>

<!-- ADD ENTRIES CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add Sender Entries</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off" id="addForm">
      <input type="hidden" name="action" value="add_entries">
      <div class="row">
        <div class="col-md-6">
          <label for="entries" class="form-label"><strong>Email Addresses and/or Domains</strong></label>
          <textarea class="form-control" id="entries" name="entries" rows="5"
            placeholder="user@example.com
example.com
.example.com"></textarea>
          <small class="text-muted">
            One entry per line. Enter an email address (e.g., <code>user@example.com</code>), a domain (e.g., <code>example.com</code>),
            or a leading-dot domain (e.g., <code>.example.com</code>) to match the domain and all its subdomains.
          </small>
          <div id="domainWarning" class="alert alert-warning mt-2 d-none">
            <i class="fas fa-exclamation-triangle"></i>
            <strong>Warning:</strong> You are adding one or more full domains. This will <span id="domainWarningAction">block</span>
            all email from the entire domain(s) for all recipients.
          </div>
        </div>
        <div class="col-md-3">
          <label class="form-label"><strong>Action</strong></label>
          <div>
            <div class="form-check mb-2">
              <input class="form-check-input" type="radio" name="entry_type" id="type_block" value="block" checked>
              <label class="form-check-label" for="type_block"><i class="fas fa-ban text-danger"></i> Block</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="entry_type" id="type_allow" value="allow">
              <label class="form-check-label" for="type_allow"><i class="fas fa-check text-success"></i> Allow (bypass ALL filters)</label>
            </div>
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
  </div>
</div>

<!-- ENTRIES TABLE -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-envelope"></i> Global Sender Entries</h3>
  </div>
  <div class="card-body">
    <form id="bulkDeleteForm" method="post">
      <input type="hidden" name="action" value="bulk_delete">
      <input type="hidden" name="selected_ids" id="selectedIds" value="">

      <div class="mb-2">
        <button type="button" class="btn btn-sm btn-danger" id="bulkDeleteBtn" disabled
          onclick="submitBulkDelete();">
          <i class="fas fa-trash"></i> Delete Selected
        </button>
      </div>

      <table id="senderTable" class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th style="width: 40%">Sender</th>
            <th style="width: 15%">Format</th>
            <th style="width: 15%">Action</th>
            <th style="width: 25%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_active_all">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#id#"></td>
              <td>#encodeForHTML(sender)#</td>
              <td>
                <cfif REFind("[@]", sender) GT 0>
                  <span class="badge bg-info">Email</span>
                <cfelseif Left(sender, 1) is ".">
                  <span class="badge bg-warning">Domain + Subdomains</span>
                <cfelse>
                  <span class="badge bg-secondary">Domain</span>
                </cfif>
              </td>
              <td>
                <cfif type is "allow">
                  <span class="badge bg-success">Allow</span>
                <cfelse>
                  <span class="badge bg-danger">Block</span>
                </cfif>
              </td>
              <td>
                <button type="button" class="btn btn-sm btn-primary" onclick="openEditModal('#id#', '#encodeForJavaScript(sender)#', '#encodeForJavaScript(type)#');" title="Edit">
                  <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-sm btn-danger" onclick="deleteSingle('#id#', '#encodeForJavaScript(sender)#');" title="Delete">
                  <i class="fas fa-trash"></i>
                </button>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
    </form>
  </div>
</div>

<!-- EDIT MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="edit_entry">
        <input type="hidden" name="edit_id" id="edit_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Sender Entry</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="edit_sender" class="form-label"><strong>Sender (Email or Domain)</strong></label>
            <input type="text" class="form-control" id="edit_sender" name="edit_sender" required>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Action</strong></label>
            <select class="form-select" name="edit_type" id="edit_type">
              <option value="block">Block</option>
              <option value="allow">Allow</option>
            </select>
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

<form id="deleteForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="delete">
  <input type="hidden" name="delete_id" id="delete_id" value="">
</form>

<script>
$(document).ready(function() {
  $('#senderTable').DataTable({
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

  var selectedIds = new Set();
  $('#selectAll').on('change', function() {
    var checked = this.checked;
    $('.row-checkbox:visible').each(function() {
      this.checked = checked;
      if (checked) selectedIds.add(this.value); else selectedIds.delete(this.value);
    });
    $('#bulkDeleteBtn').prop('disabled', selectedIds.size === 0);
  });
  $(document).on('change', '.row-checkbox', function() {
    if (this.checked) selectedIds.add(this.value); else selectedIds.delete(this.value);
    $('#bulkDeleteBtn').prop('disabled', selectedIds.size === 0);
  });
  window.submitBulkDelete = function() {
    if (selectedIds.size === 0) return;
    if (!confirm('Delete ' + selectedIds.size + ' selected entries?')) return;
    $('#selectedIds').val(Array.from(selectedIds).join(','));
    $('#bulkDeleteForm').submit();
  };

  // Domain warning detection on textarea input
  $('#entries').on('input', function() {
    var text = $(this).val();
    var lines = text.split(/\r?\n/);
    var hasDomain = false;
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim();
      if (line !== '' && line.indexOf('@') === -1) {
        hasDomain = true;
        break;
      }
    }
    if (hasDomain) {
      var actionType = $('input[name="entry_type"]:checked').val();
      $('#domainWarningAction').text(actionType === 'allow' ? 'allow (bypass all filters for)' : 'block');
      $('#domainWarning').removeClass('d-none');
    } else {
      $('#domainWarning').addClass('d-none');
    }
  });

  // Update domain warning text when action radio changes
  $('input[name="entry_type"]').on('change', function() {
    if (!$('#domainWarning').hasClass('d-none')) {
      var actionType = $(this).val();
      $('#domainWarningAction').text(actionType === 'allow' ? 'allow (bypass all filters for)' : 'block');
    }
  });
});

function openEditModal(id, sender, type) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_sender').value = sender;
  document.getElementById('edit_type').value = type;
  new bootstrap.Modal(document.getElementById('editModal')).show();
}

function deleteSingle(id, name) {
  if (!confirm('Delete "' + name + '"?')) return;
  document.getElementById('delete_id').value = id;
  document.getElementById('deleteForm').submit();
}
</script>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>
</html>
