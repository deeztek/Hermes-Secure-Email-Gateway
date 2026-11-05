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
  <title>Hermes SEG | Hash Blocklist</title>
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
            <h1 class="m-0">Hash Blocklist</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Content Checks</li>
              <li class="breadcrumb-item active">Hash Blocklist</li>
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
<cfif action is "add_hash">
  <cfinclude template="./inc/add_attachment_hash_action.cfm">
<cfelseif action is "delete_hash">
  <cfinclude template="./inc/delete_attachment_hash_action.cfm">
</cfif>

<!--- SUCCESS / ERROR MESSAGES --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Hash added. ClamAV has been told to reload its signatures.
  </div>
<cfelseif m EQ 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Hash removed. ClamAV has been told to reload its signatures.
  </div>
<cfelseif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    A SHA-256 hash is exactly 64 hexadecimal characters.
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    File size must be a whole number of bytes, or left blank.
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    That hash is already on the blocklist.
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
    Hash not found.
  </div>
<cfelseif m EQ 30>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The change was saved, but the signature file could not be updated, so ClamAV is still using the previous list. Check the hermes log for details.
  </div>
</cfif>

<!--- HELP CALLOUT --->
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About the Hash Blocklist</h5>
  <p class="mb-1">ClamAV treats any attachment with a listed SHA-256 hash as a virus, including files inside archives it can open. The message then follows the <strong>Virus Messages</strong> setting under <a href="view_antispam_maintenance.cfm">Antispam Settings</a>.</p>
  <p class="mb-0">A hash matches one exact file, so a changed copy is not blocked. Enter the file size if you know it: lookups are faster than with a blank size.</p>
</div>

<!--- GET ALL HASHES --->
<cfquery name="getHashes" datasource="hermes">
    SELECT id, sha256, file_size, description, source, created_at
    FROM attachment_hash_blocklist
    ORDER BY created_at DESC, id DESC
</cfquery>

<!--- ADD BUTTON --->
<div class="mb-3">
  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addHashModal"><i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Add Hash</button>
</div>

<!--- HASHES DATATABLE --->
<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-fingerprint me-2"></i>Blocked Hashes (<cfoutput>#getHashes.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <table id="hashTable" class="table table-bordered table-striped" style="width:100%">
      <thead>
        <tr>
          <th>Actions</th>
          <th>SHA-256</th>
          <th>Size (bytes)</th>
          <th>Description</th>
          <th>Source</th>
          <th>Signature Name</th>
          <th>Added</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getHashes">
        <tr>
          <td>
            <button type="button" class="btn btn-sm btn-danger" title="Remove"
                    onclick="confirmDeleteHash(#id#, '#JSStringFormat(sha256)#')">
              <i class="fas fa-trash"></i>
            </button>
          </td>
          <td><code>#HTMLEditFormat(sha256)#</code></td>
          <td><cfif Len(file_size)>#file_size#<cfelse><span class="text-muted">Any</span></cfif></td>
          <td>#HTMLEditFormat(description)#</td>
          <td><span class="badge bg-secondary">#HTMLEditFormat(source)#</span></td>
          <td><code>Hermes.Blocklist.#id#.UNOFFICIAL</code></td>
          <td>#DateFormat(created_at, "yyyy-mm-dd")# #TimeFormat(created_at, "HH:mm")#</td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>

<!--- ================================================================
     ADD HASH MODAL
     ================================================================ --->
<div class="modal fade" id="addHashModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_attachment_hash_blocklist.cfm">
        <input type="hidden" name="action" value="add_hash">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add Hash</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <div class="form-group mb-3">
            <label><strong>SHA-256</strong></label>
            <input type="text" class="form-control" name="sha256" maxlength="64" pattern="[A-Fa-f0-9]{64}" title="64 hexadecimal characters" required>
          </div>

          <div class="form-group mb-3">
            <label><strong>File Size (bytes)</strong></label>
            <input type="number" class="form-control" name="file_size" min="1" step="1">
            <small class="text-muted">Optional. Leave blank to match any size.</small>
          </div>

          <div class="form-group mb-3">
            <label><strong>Description</strong></label>
            <input type="text" class="form-control" name="description" maxlength="255" placeholder="Optional description">
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Add Hash</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ================================================================
     DELETE CONFIRMATION MODAL
     ================================================================ --->
<div class="modal fade" id="deleteHashModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_attachment_hash_blocklist.cfm">
        <input type="hidden" name="action" value="delete_hash">
        <input type="hidden" name="delete_hash_id" id="deleteHashId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-trash me-2 text-danger"></i>Remove Hash</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Remove this hash from the blocklist?</p>
          <p><code id="deleteHashValue" style="word-break:break-all;"></code></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Remove</button>
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
    $('#hashTable').DataTable({
      "order": [[6, "desc"]],
      "pageLength": 25,
      "stateSave": true,
      "columnDefs": [
        { "orderable": false, "targets": [0] }
      ]
    });
  });

  function confirmDeleteHash(hashId, hashValue) {
    $('#deleteHashId').val(hashId);
    $('#deleteHashValue').text(hashValue);
    new bootstrap.Modal(document.getElementById('deleteHashModal')).show();
  }
</script>

</html>
