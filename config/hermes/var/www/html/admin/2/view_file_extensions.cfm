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
  <title>Hermes SEG | File Extensions</title>

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
            <h1 class="m-0">File Extensions</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">File Extensions</li>
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

<!--- Regex: extension must start with dot, only alphanumeric/dash/period/underscore --->
<cfset ext_pattern = "^[.][a-zA-Z0-9\-\.\_]+$">

<!--- GET DATA --->
<cfinclude template="./inc/get_file_extensions.cfm">

<!--- ===================== --->
<!--- ACTION: ADD ENTRIES  --->
<!--- ===================== --->
<cfif action is "add_entries">
  <cfset entries_added = 0>
  <cfset entries_skipped = 0>
  <cfset entry_errors = "">

  <cfif NOT StructKeyExists(form, "entries") OR trim(form.entries) is "">
    <cfset session.m = 30>
    <cflocation url="view_file_extensions.cfm" addtoken="no">
  </cfif>

  <cfparam name="form.ext_type" default="EXT">
  <cfif form.ext_type is not "EXT" AND form.ext_type is not "EXT-HIGH">
    <cfset form.ext_type = "EXT">
  </cfif>

  <cfparam name="form.casesense" default="no">

  <cfset entryText = Replace(form.entries, Chr(13) & Chr(10), Chr(10), "ALL")>
  <cfset entryText = Replace(entryText, Chr(13), Chr(10), "ALL")>
  <cfset lines = ListToArray(entryText, Chr(10))>

  <cfloop array="#lines#" index="line">
    <cfset line = trim(line)>
    <cfif line is ""><cfcontinue></cfif>

    <!--- Parse: .ext description --->
    <cfset firstSpace = Find(" ", line)>
    <cfif firstSpace GT 0>
      <cfset entryExt = trim(Left(line, firstSpace - 1))>
      <cfset entryDesc = trim(Mid(line, firstSpace + 1, Len(line)))>
    <cfelse>
      <cfset entryExt = line>
      <cfset entryDesc = "">
    </cfif>

    <!--- Validate extension starts with dot --->
    <cfif Left(entryExt, 1) is not ".">
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Must start with dot: " & encodeForHTML(entryExt) & "<br>">
      <cfcontinue>
    </cfif>

    <!--- Validate extension characters --->
    <cfif NOT REFind(ext_pattern, entryExt)>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Invalid characters: " & encodeForHTML(entryExt) & "<br>">
      <cfcontinue>
    </cfif>

    <!--- Validate description not empty --->
    <cfif entryDesc is "">
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Description required: " & encodeForHTML(entryExt) & "<br>">
      <cfcontinue>
    </cfif>

    <!--- Auto-prefix description with extension --->
    <cfset entryDesc = "(" & entryExt & ") " & entryDesc>

    <!--- Strip leading dot for storage --->
    <cfset theExtension = Replace(entryExt, ".", "", "ALL")>

    <!--- Check for duplicates --->
    <cfquery name="checkDup" datasource="hermes">
      SELECT COUNT(*) as cnt FROM files
      WHERE file = <cfqueryparam value="#theExtension#" cfsqltype="cf_sql_varchar">
        AND type IN (<cfqueryparam value="EXT,EXT-HIGH" cfsqltype="cf_sql_varchar" list="true">)
    </cfquery>
    <cfif checkDup.cnt GT 0>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Duplicate: " & encodeForHTML(entryExt) & "<br>">
      <cfcontinue>
    </cfif>

    <!--- Generate allow/deny content from templates --->
    <cfif form.casesense is "yes">
      <cffile action="read" file="/opt/hermes/scripts/file_allow_sense" variable="fileallow">
      <cffile action="read" file="/opt/hermes/scripts/file_deny_sense" variable="filedeny">
    <cfelse>
      <cffile action="read" file="/opt/hermes/scripts/file_allow_insense" variable="fileallow">
      <cffile action="read" file="/opt/hermes/scripts/file_deny_insense" variable="filedeny">
    </cfif>

    <cfset fileallow = REReplace(fileallow, "THE-EXTENSION", theExtension, "ALL")>
    <cfset filedeny = REReplace(filedeny, "THE-EXTENSION", theExtension, "ALL")>

    <!--- Insert --->
    <cfquery datasource="hermes">
      INSERT INTO files (file, description, type, system, allow, ban)
      VALUES (
        <cfqueryparam value="#theExtension#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#entryDesc#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#form.ext_type#" cfsqltype="cf_sql_varchar">,
        'NO',
        <cfqueryparam value="#fileallow#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#filedeny#" cfsqltype="cf_sql_varchar">
      )
    </cfquery>
    <cfset entries_added = entries_added + 1>
  </cfloop>

  <!--- If any extensions were added, update amavis config and reload --->
  <cfif entries_added GT 0>
    <cftry>
      <cfinclude template="./inc/update_amavis_config_files.cfm">
      <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
        timeout="30" />
    <cfcatch type="any">
      <!--- Log but don't block - extensions were added --->
    </cfcatch>
    </cftry>
  </cfif>

  <cfset session.entries_added = entries_added>
  <cfset session.entries_skipped = entries_skipped>
  <cfset session.entry_errors = entry_errors>
  <cfset session.m = 1>
  <cflocation url="view_file_extensions.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: DELETE       --->
<!--- ===================== --->
<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>

    <!--- Check file_rule_components FK constraint --->
    <cfquery name="checkFK" datasource="hermes">
      SELECT COUNT(*) as cnt FROM file_rule_components
      WHERE file_id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif checkFK.cnt GT 0>
      <!--- Get the rule names that use this extension --->
      <cfquery name="getRuleNames" datasource="hermes">
        SELECT DISTINCT frc.rule_name FROM file_rule_components frc
        WHERE frc.file_id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfset ruleList = "">
      <cfloop query="getRuleNames">
        <cfset ruleList = ruleList & "<strong>" & encodeForHTML(rule_name) & "</strong>, ">
      </cfloop>
      <cfif Len(ruleList) GT 2>
        <cfset ruleList = Left(ruleList, Len(ruleList) - 2)>
      </cfif>
      <cfset session.deleteRuleNames = ruleList>
      <cfset session.m = 10>
    <cfelse>
      <!--- Verify it is a custom extension (system='NO') --->
      <cfquery name="checkSystem" datasource="hermes">
        SELECT system FROM files
        WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfif checkSystem.recordCount GT 0 AND checkSystem.system is "NO">
        <cfquery datasource="hermes">
          DELETE FROM files
          WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
            AND system = <cfqueryparam value="NO" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cftry>
          <cfinclude template="./inc/update_amavis_config_files.cfm">
          <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
            timeout="30" />
        <cfcatch type="any"></cfcatch>
        </cftry>
        <cfset session.m = 2>
      <cfelse>
        <cfset session.m = 11>
      </cfif>
    </cfif>
  </cfif>
  <cflocation url="view_file_extensions.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: BULK DELETE  --->
<!--- ===================== --->
<cfif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfset bulk_deleted = 0>
    <cfset bulk_skipped = 0>
    <cfset bulk_errors = "">

    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <!--- Check FK constraint --->
        <cfquery name="checkFK" datasource="hermes">
          SELECT COUNT(*) as cnt FROM file_rule_components
          WHERE file_id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif checkFK.cnt GT 0>
          <!--- Get the extension name and rule names for error message --->
          <cfquery name="getExtName" datasource="hermes">
            SELECT file FROM files WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
          </cfquery>
          <cfquery name="getBulkRuleNames" datasource="hermes">
            SELECT DISTINCT rule_name FROM file_rule_components
            WHERE file_id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
          </cfquery>
          <cfset bulk_skipped = bulk_skipped + 1>
          <cfif getExtName.recordCount GT 0>
            <cfset ruleNames = "">
            <cfloop query="getBulkRuleNames">
              <cfset ruleNames = ruleNames & encodeForHTML(rule_name) & ", ">
            </cfloop>
            <cfif Len(ruleNames) GT 2><cfset ruleNames = Left(ruleNames, Len(ruleNames) - 2)></cfif>
            <cfset bulk_errors = bulk_errors & "." & encodeForHTML(getExtName.file) & " (used in rule: " & ruleNames & ")<br>">
          </cfif>
        <cfelse>
          <cfquery datasource="hermes">
            DELETE FROM files
            WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
              AND system = <cfqueryparam value="NO" cfsqltype="cf_sql_varchar">
          </cfquery>
          <cfset bulk_deleted = bulk_deleted + 1>
        </cfif>
      </cfif>
    </cfloop>

    <cfif bulk_deleted GT 0>
      <cftry>
        <cfinclude template="./inc/update_amavis_config_files.cfm">
        <cfexecute name="/usr/local/bin/docker"
          arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
          timeout="30" />
      <cfcatch type="any"></cfcatch>
      </cftry>
    </cfif>

    <cfset session.bulk_deleted = bulk_deleted>
    <cfset session.bulk_skipped = bulk_skipped>
    <cfset session.bulk_errors = bulk_errors>
    <cfset session.m = 12>
  </cfif>
  <cflocation url="view_file_extensions.cfm" addtoken="no">
</cfif>


<!--- Refresh data after actions --->
<cfinclude template="./inc/get_file_extensions.cfm">
<cfset session.m = "">

<!--- ===================== --->
<!--- ALERTS               --->
<!--- ===================== --->
<cfif m is 1>
  <cfset _addAdded = StructKeyExists(session, "entries_added") ? session.entries_added : 0>
  <cfset _addSkipped = StructKeyExists(session, "entries_skipped") ? session.entries_skipped : 0>
  <cfset _addErrors = StructKeyExists(session, "entry_errors") ? session.entry_errors : "">

  <cfif _addAdded GT 0 AND _addSkipped EQ 0>
    <div class="alert alert-success alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fa fa-check"></i> Extensions Added</h4>
      <p><cfoutput>#_addAdded#</cfoutput> extension(s) added successfully. Amavis configuration updated and reloaded.</p>
    </div>
  <cfelseif _addAdded GT 0 AND _addSkipped GT 0>
    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fas fa-exclamation-triangle"></i> Partial Add</h4>
      <p><cfoutput>#_addAdded#</cfoutput> extension(s) added. <cfoutput>#_addSkipped#</cfoutput> extension(s) skipped:</p>
      <cfif _addErrors is not ""><p><cfoutput>#_addErrors#</cfoutput></p></cfif>
    </div>
  <cfelse>
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fa fa-ban"></i> Add Failed</h4>
      <p>No extensions were added. <cfoutput>#_addSkipped#</cfoutput> extension(s) skipped:</p>
      <cfif _addErrors is not ""><p><cfoutput>#_addErrors#</cfoutput></p></cfif>
    </div>
  </cfif>

  <cfset session.entries_added = "">
  <cfset session.entries_skipped = "">
  <cfset session.entry_errors = "">
</cfif>
<cfif m is 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Extension Deleted</h4>
    <p>File extension deleted. Amavis configuration updated and reloaded.</p>
  </div>
</cfif>
<cfif m is 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Cannot Delete</h4>
    <p>This file extension is used in the following File Rule(s): <cfif StructKeyExists(session, "deleteRuleNames") AND session.deleteRuleNames is not ""><cfoutput>#session.deleteRuleNames#</cfoutput><cfset session.deleteRuleNames = ""><cfelse>Unknown</cfif>. Remove it from the rule(s) first, then try again.</p>
  </div>
</cfif>
<cfif m is 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Cannot Modify</h4>
    <p>System extensions cannot be modified or deleted.</p>
  </div>
</cfif>
<cfif m is 12>
  <cfset _bulkDeleted = StructKeyExists(session, "bulk_deleted") ? session.bulk_deleted : 0>
  <cfset _bulkSkipped = StructKeyExists(session, "bulk_skipped") ? session.bulk_skipped : 0>
  <cfset _bulkErrors = StructKeyExists(session, "bulk_errors") ? session.bulk_errors : "">

  <cfif _bulkDeleted GT 0 AND _bulkSkipped EQ 0>
    <!--- All succeeded --->
    <div class="alert alert-success alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fa fa-check"></i> Bulk Delete Complete</h4>
      <p><cfoutput>#_bulkDeleted#</cfoutput> extension(s) deleted. Amavis configuration updated and reloaded.</p>
    </div>
  <cfelseif _bulkDeleted GT 0 AND _bulkSkipped GT 0>
    <!--- Partial success --->
    <div class="alert alert-warning alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fas fa-exclamation-triangle"></i> Partial Delete</h4>
      <p><cfoutput>#_bulkDeleted#</cfoutput> extension(s) deleted. <cfoutput>#_bulkSkipped#</cfoutput> extension(s) could not be deleted:</p>
      <cfif _bulkErrors is not ""><p><cfoutput>#_bulkErrors#</cfoutput></p></cfif>
    </div>
  <cfelse>
    <!--- All failed --->
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fa fa-ban"></i> Cannot Delete</h4>
      <p>None of the selected extensions could be deleted:</p>
      <cfif _bulkErrors is not ""><p><cfoutput>#_bulkErrors#</cfoutput></p></cfif>
    </div>
  </cfif>

  <cfset session.bulk_deleted = "">
  <cfset session.bulk_skipped = "">
  <cfset session.bulk_errors = "">
</cfif>
<cfif m is 30>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Please enter at least one file extension.</p>
  </div>
</cfif>

<div class="callout callout-info mb-4">
  <h5><i class="fas fa-info-circle"></i> Page Guide</h5>
  <p class="mb-1">File extensions define attachment types that Amavis checks during mail filtering. Each extension entry specifies a file type (e.g. <code>.exe</code>, <code>.bat</code>) and whether it should be <strong>banned</strong> or <strong>allowed</strong> when matched.</p>
  <p class="mb-0">Extensions are assigned to <strong>File Rules</strong> under Content Checks &gt; File Rules, which are then assigned to <strong>SVF Policies</strong> to control attachment filtering per recipient.</p>
</div>

<!-- ADD EXTENSIONS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add File Extensions</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="add_entries">
      <div class="row">
        <div class="col-md-6">
          <label for="entries" class="form-label"><strong>File Extensions</strong></label>
          <textarea class="form-control" id="entries" name="entries" rows="5"
            placeholder=".docm Microsoft Word Macro-Enabled Document
.xlsm Microsoft Excel Macro-Enabled Spreadsheet"></textarea>
          <small class="text-muted">
            One entry per line. Format: <code>.extension description</code> (description is <strong>required</strong>)<br>
            Example: <code>.docm Microsoft Word Macro-Enabled Document</code><br>
            Extension must start with a dot. Only alphanumeric, dashes, periods, and underscores allowed.
            The extension will be automatically prefixed to the description (e.g., "(.docm) Microsoft Word Macro-Enabled Document").
          </small>
        </div>
        <div class="col-md-3">
          <div class="mb-3">
            <label class="form-label"><strong>Extension Type</strong></label>
            <select class="form-select" name="ext_type">
              <option value="EXT">File Extension</option>
              <option value="EXT-HIGH">High Risk File Extension</option>
            </select>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Case Sensitivity</strong></label>
            <div>
              <div class="form-check mb-1">
                <input class="form-check-input" type="radio" name="casesense" id="case_insensitive" value="no" checked>
                <label class="form-check-label" for="case_insensitive">Case Insensitive <small class="text-muted">(Recommended)</small></label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="casesense" id="case_sensitive" value="yes">
                <label class="form-check-label" for="case_sensitive">Case Sensitive</label>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-3 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add Extensions
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- CUSTOM EXTENSIONS TABLE -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-puzzle-piece"></i> Custom File Extensions</h3>
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

      <table id="customExtTable" class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th style="width: 25%">Extension</th>
            <th style="width: 50%">Description</th>
            <th style="width: 20%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_custom_extensions">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#id#"></td>
              <td>.#encodeForHTML(file)#</td>
              <td>#encodeForHTML(description)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-danger" onclick="deleteSingle('#id#', '.#encodeForJavaScript(file)#');" title="Delete">
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

<!-- SYSTEM EXTENSIONS TABLE (Read-Only) -->
<div class="card card-secondary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-lock"></i> System File Extensions <small class="text-muted">(Read-Only)</small></h3>
  </div>
  <div class="card-body">
    <table id="systemExtTable" class="table table-bordered table-hover table-striped">
      <thead>
        <tr>
          <th style="width: 25%">Extension</th>
          <th style="width: 50%">Description</th>
          <th style="width: 25%">Type</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="get_all_extensions">
          <cfif system is "YES">
            <tr>
              <td>.#encodeForHTML(file)#</td>
              <td>#encodeForHTML(description)#</td>
              <td>
                <cfif type is "EXT-HIGH">
                  <span class="badge bg-danger">High Risk</span>
                <cfelse>
                  <span class="badge bg-info">Standard</span>
                </cfif>
              </td>
            </tr>
          </cfif>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>

<!-- EDIT MODAL -->
<form id="deleteForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="delete">
  <input type="hidden" name="delete_id" id="delete_id" value="">
</form>

<script>
$(document).ready(function() {
  $('#customExtTable').DataTable({
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

  $('#systemExtTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[0, 'asc']]
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
    if (!confirm('Delete ' + selectedIds.size + ' selected extension(s)?')) return;
    $('#selectedIds').val(Array.from(selectedIds).join(','));
    $('#bulkDeleteForm').submit();
  };
});


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
