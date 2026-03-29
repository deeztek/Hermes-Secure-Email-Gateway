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
  <title>Hermes SEG | File Expressions</title>

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
            <h1 class="m-0">File Expressions</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">File Expressions</li>
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
<cfinclude template="./inc/get_file_expressions.cfm">

<!--- ===================== --->
<!--- ACTION: ADD ENTRIES --->
<!--- ===================== --->
<cfif action is "add_entries">
  <cfset entries_added = 0>
  <cfset entries_skipped = 0>
  <cfset entry_errors = "">

  <cfif NOT StructKeyExists(form, "entries") OR trim(form.entries) is "">
    <cfset session.m = 30>
    <cflocation url="view_file_expressions.cfm" addtoken="no">
  </cfif>

  <cfset entryText = Replace(form.entries, Chr(13) & Chr(10), Chr(10), "ALL")>
  <cfset entryText = Replace(entryText, Chr(13), Chr(10), "ALL")>
  <cfset lines = ListToArray(entryText, Chr(10))>

  <cfloop array="#lines#" index="line">
    <cfset line = trim(line)>
    <cfif line is ""><cfcontinue></cfif>

    <cfset firstSpace = Find(" ", line)>
    <cfif firstSpace GT 0>
      <cfset entryPattern = trim(Left(line, firstSpace - 1))>
      <cfset entryDescription = trim(Mid(line, firstSpace + 1, Len(line)))>
    <cfelse>
      <cfset entryPattern = line>
      <cfset entryDescription = line>
    </cfif>

    <!--- Check for duplicates --->
    <cfquery name="checkDup" datasource="hermes">
      SELECT COUNT(*) as cnt FROM files
      WHERE file = <cfqueryparam value="#entryPattern#" cfsqltype="cf_sql_varchar">
        AND type = <cfqueryparam value="CUSTOM-EXPRESSION" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkDup.cnt GT 0>
      <cfset entries_skipped = entries_skipped + 1>
      <cfset entry_errors = entry_errors & "Duplicate: " & encodeForHTML(entryPattern) & "<br>">
      <cfcontinue>
    </cfif>

    <!--- Generate Amavis qr'' ban and allow patterns from the regex --->
    <cfset amavisBan = "[qr'#entryPattern#'i => 1]">
    <cfset amavisAllow = "[qr'#entryPattern#'i => 0]">

    <cfquery datasource="hermes">
      INSERT INTO files (file, description, type, system, allow, ban)
      VALUES (
        <cfqueryparam value="#entryPattern#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#entryDescription#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="CUSTOM-EXPRESSION" cfsqltype="cf_sql_varchar">,
        'NO',
        <cfqueryparam value="#amavisAllow#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#amavisBan#" cfsqltype="cf_sql_varchar">
      )
    </cfquery>
    <cfset entries_added = entries_added + 1>
  </cfloop>

  <!--- Apply amavis config and reload --->
  <cfif entries_added GT 0>
    <cftry>
      <cfinclude template="./inc/update_amavis_config_files.cfm">
      <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
        timeout="30" />
      <cfcatch type="any">
        <!--- Log error but continue --->
      </cfcatch>
    </cftry>
  </cfif>

  <cfset session.entries_added = entries_added>
  <cfset session.entries_skipped = entries_skipped>
  <cfset session.entry_errors = entry_errors>
  <cfset session.m = 1>
  <cflocation url="view_file_expressions.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: DELETE --->
<!--- ===================== --->
<cfif action is "delete">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <!--- Check for FK references in file_rule_components --->
    <cfquery name="checkFK" datasource="hermes">
      SELECT COUNT(*) as cnt FROM file_rule_components
      WHERE file_id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif checkFK.cnt GT 0>
      <cfquery name="getRuleNames" datasource="hermes">
        SELECT DISTINCT rule_name FROM file_rule_components
        WHERE file_id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfset ruleList = "">
      <cfloop query="getRuleNames">
        <cfset ruleList = ListAppend(ruleList, rule_name)>
      </cfloop>
      <cfset session.deleteRuleNames = ruleList>
      <cfset session.m = 40>
      <cflocation url="view_file_expressions.cfm" addtoken="no">
    </cfif>

    <cfquery datasource="hermes">
      DELETE FROM files
      WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
        AND type = <cfqueryparam value="CUSTOM-EXPRESSION" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cftry>
      <cfinclude template="./inc/update_amavis_config_files.cfm">
      <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
        timeout="30" />
      <cfcatch type="any">
      </cfcatch>
    </cftry>

    <cfset session.m = 2>
  </cfif>
  <cflocation url="view_file_expressions.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: BULK DELETE --->
<!--- ===================== --->
<cfif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfset blocked_ids = "">
    <cfset deleted_count = 0>

    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <!--- Check for FK references --->
        <cfquery name="checkFK" datasource="hermes">
          SELECT COUNT(*) as cnt FROM file_rule_components
          WHERE file_id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif checkFK.cnt GT 0>
          <cfquery name="getBlockedFile" datasource="hermes">
            SELECT file FROM files WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
          </cfquery>
          <cfquery name="getBulkRuleNames" datasource="hermes">
            SELECT DISTINCT rule_name FROM file_rule_components
            WHERE file_id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
          </cfquery>
          <cfset ruleNames = "">
          <cfloop query="getBulkRuleNames">
            <cfset ruleNames = ListAppend(ruleNames, rule_name)>
          </cfloop>
          <cfset blocked_ids = ListAppend(blocked_ids, delId)>
          <cfif NOT StructKeyExists(session, "bulk_errors")><cfset session.bulk_errors = ""></cfif>
          <cfset session.bulk_errors = session.bulk_errors & encodeForHTML(getBlockedFile.file) & " (used in rule: <strong>" & encodeForHTML(ruleNames) & "</strong>)<br>">
          <cfcontinue>
        </cfif>

        <cfquery datasource="hermes">
          DELETE FROM files
          WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
            AND type = <cfqueryparam value="CUSTOM-EXPRESSION" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfset deleted_count = deleted_count + 1>
      </cfif>
    </cfloop>

    <cfif deleted_count GT 0>
      <cftry>
        <cfinclude template="./inc/update_amavis_config_files.cfm">
        <cfexecute name="/usr/local/bin/docker"
          arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
          timeout="30" />
        <cfcatch type="any">
        </cfcatch>
      </cftry>
    </cfif>

    <cfif blocked_ids is not "">
      <cfset session.blocked_count = ListLen(blocked_ids)>
      <cfset session.deleted_count = deleted_count>
      <cfset session.m = 41>
    <cfelse>
      <cfset session.m = 2>
    </cfif>
  </cfif>
  <cflocation url="view_file_expressions.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: EDIT --->
<!--- ===================== --->
<!--- Edit action removed - delete and re-add instead --->

<!--- Refresh data --->
<cfinclude template="./inc/get_file_expressions.cfm">
<cfset session.m = "">

<!--- ALERTS --->
<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Expressions Added</h4>
    <cfif StructKeyExists(session, "entries_added")>
      <p><cfoutput>#session.entries_added#</cfoutput> expression(s) added successfully.</p>
      <cfset session.entries_added = "">
    </cfif>
    <cfif StructKeyExists(session, "entries_skipped") AND session.entries_skipped GT 0>
      <p><cfoutput>#session.entries_skipped#</cfoutput> expression(s) skipped.</p>
      <cfset session.entries_skipped = "">
    </cfif>
    <cfif StructKeyExists(session, "entry_errors") AND session.entry_errors is not "">
      <p><cfoutput>#session.entry_errors#</cfoutput></p>
      <cfset session.entry_errors = "">
    </cfif>
    <p>Amavis configuration updated and reloaded.</p>
  </div>
</cfif>
<cfif m is 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Expression(s) Deleted</h4>
    <p>Amavis configuration updated and reloaded.</p>
  </div>
</cfif>
<cfif m is 5>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Expression Updated</h4>
    <p>Amavis configuration updated and reloaded.</p>
  </div>
</cfif>
<cfif m is 30>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Please enter at least one file expression.</p>
  </div>
</cfif>
<cfif m is 31>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>Regex pattern cannot be empty.</p>
  </div>
</cfif>
<cfif m is 32>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <p>A file expression with that pattern already exists.</p>
  </div>
</cfif>
<cfif m is 40>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Cannot Delete</h4>
    <p>This expression is referenced by the following File Rule(s): <cfif StructKeyExists(session, "deleteRuleNames") AND session.deleteRuleNames is not ""><strong><cfoutput>#encodeForHTML(session.deleteRuleNames)#</cfoutput></strong><cfset session.deleteRuleNames = ""><cfelse>Unknown</cfif>. Remove it from the rule(s) first, then try again.</p>
  </div>
</cfif>
<cfif m is 41>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Partial Delete</h4>
    <cfif StructKeyExists(session, "deleted_count")>
      <p><cfoutput>#session.deleted_count#</cfoutput> expression(s) deleted.</p>
      <cfset session.deleted_count = "">
    </cfif>
    <cfif StructKeyExists(session, "blocked_count") AND session.blocked_count GT 0>
      <p><cfoutput>#session.blocked_count#</cfoutput> expression(s) could not be deleted:</p>
      <cfif StructKeyExists(session, "bulk_errors") AND session.bulk_errors is not "">
        <p><cfoutput>#session.bulk_errors#</cfoutput></p>
      </cfif>
      <cfset session.blocked_count = "">
      <cfset session.bulk_errors = "">
    </cfif>
  </div>
</cfif>

<!-- REGEX HELPER -->
<div class="card card-secondary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title" style="cursor:pointer;" data-bs-toggle="collapse" data-bs-target="#regexHelper" aria-expanded="false" aria-controls="regexHelper">
      <i class="fas fa-lightbulb me-1"></i> Expression Helper <i class="fas fa-chevron-down ms-2 small"></i>
    </h3>
  </div>
  <div class="collapse" id="regexHelper">
    <div class="card-body">

      <!-- SECTION 1: Simple Builder -->
      <h5 class="border-bottom pb-2 mb-3"><i class="fas fa-magic me-1"></i> Build an Expression (No Regex Knowledge Required)</h5>
      <p class="text-muted mb-2">Select a match type, enter your text, and click <strong>Build</strong> to generate the regex pattern automatically. Then click <strong>Use</strong> to copy it to the Add form below.</p>
      <div class="row">
        <div class="col-md-8 mb-3">
          <div class="input-group mb-2">
            <select class="form-select" id="builderMode" style="max-width: 180px;">
              <option value="endswith">Ends with</option>
              <option value="startswith">Starts with</option>
              <option value="contains">Contains</option>
              <option value="exact">Exact match</option>
            </select>
            <input type="text" class="form-control" id="builderValue" placeholder="Enter text (e.g. .exe or invoice)">
            <button type="button" class="btn btn-primary" onclick="buildPattern();">
              <i class="fas fa-cog"></i> Build
            </button>
          </div>
          <div class="input-group">
            <span class="input-group-text">Generated Pattern</span>
            <input type="text" class="form-control" id="builtPattern" readonly>
            <button type="button" class="btn btn-success" onclick="useBuiltPattern();" title="Copy to Add form">
              <i class="fas fa-arrow-down"></i> Use
            </button>
          </div>
          <div id="buildExplanation" class="mt-1" style="display:none;"></div>
        </div>
      </div>

      <hr>

      <!-- SECTION 2: Common Patterns -->
      <h5 class="border-bottom pb-2 mb-3"><i class="fas fa-list me-1"></i> Quick Select Common Patterns</h5>
      <p class="text-muted mb-2">Select a pre-built pattern and it will be copied directly to the Add form below.</p>
      <div class="row">
        <div class="col-md-8 mb-3">
          <div class="input-group">
            <select class="form-select" id="commonPatterns">
              <option value="">-- Select a pattern --</option>
              <optgroup label="File Extensions">
                <option value="\.exe$">Files ending with .exe</option>
                <option value="\.bat$">Files ending with .bat</option>
                <option value="\.scr$">Files ending with .scr</option>
                <option value="\.pif$">Files ending with .pif</option>
                <option value="\.cmd$">Files ending with .cmd</option>
                <option value="\.vbs$">Files ending with .vbs</option>
                <option value="\.js$">Files ending with .js</option>
                <option value="\.wsf$">Files ending with .wsf</option>
                <option value="\.msi$">Files ending with .msi</option>
                <option value="\.dll$">Files ending with .dll</option>
                <option value="\.(exe|bat|cmd|scr|pif)$">Multiple: .exe, .bat, .cmd, .scr, .pif</option>
              </optgroup>
              <optgroup label="Filename Patterns">
                <option value="^invoice">Filenames starting with "invoice"</option>
                <option value="^payment">Filenames starting with "payment"</option>
                <option value="macro">Filenames containing "macro"</option>
              </optgroup>
            </select>
            <button type="button" class="btn btn-success" onclick="applyCommonPattern(document.getElementById('commonPatterns').value);">
              <i class="fas fa-arrow-down"></i> Use
            </button>
          </div>
        </div>
      </div>

      <hr>

      <!-- SECTION 3: Test Pattern -->
      <h5 class="border-bottom pb-2 mb-3"><i class="fas fa-flask me-1"></i> Test a Pattern</h5>
      <p class="text-muted mb-2">Verify your pattern works by testing it against a sample filename before adding it.</p>
      <div class="row mb-3">
        <div class="col-md-10">
          <div class="input-group">
            <span class="input-group-text">Pattern</span>
            <input type="text" class="form-control" id="testPattern" placeholder="e.g. \.exe$">
            <span class="input-group-text">Filename</span>
            <input type="text" class="form-control" id="testFilename" placeholder="e.g. report.exe">
            <button type="button" class="btn btn-outline-success" onclick="testRegex();">
              <i class="fas fa-flask"></i> Test
            </button>
          </div>
          <div id="testResult" class="mt-2" style="display:none;"></div>
        </div>
      </div>

      <hr>

      <!-- SECTION 4: Reference -->
      <h5 class="border-bottom pb-2 mb-3"><i class="fas fa-book me-1"></i> Pattern Reference</h5>
      <div class="table-responsive">
        <table class="table table-sm table-bordered">
          <thead class="table-light">
            <tr>
              <th>Pattern</th>
              <th>Matches</th>
              <th>Example Files</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><code>\.exe$</code></td>
              <td>Files ending with .exe</td>
              <td>setup.exe, installer.exe</td>
            </tr>
            <tr>
              <td><code>\.(exe|bat|cmd)$</code></td>
              <td>Files ending with .exe, .bat, or .cmd</td>
              <td>run.exe, script.bat, deploy.cmd</td>
            </tr>
            <tr>
              <td><code>^invoice</code></td>
              <td>Files starting with "invoice"</td>
              <td>invoice_2026.pdf, invoice.docx</td>
            </tr>
            <tr>
              <td><code>macro</code></td>
              <td>Files containing "macro"</td>
              <td>macro_report.xlsm, file_with_macro.doc</td>
            </tr>
            <tr>
              <td><code>^.+\.docm$</code></td>
              <td>Any file ending with .docm (macro-enabled Word)</td>
              <td>report.docm, letter.docm</td>
            </tr>
            <tr>
              <td><code>\.(zip|rar|7z|tar|gz)$</code></td>
              <td>Archive files</td>
              <td>backup.zip, data.tar.gz</td>
            </tr>
            <tr>
              <td><code>^(?=.*\.pdf$)(?=.*invoice)</code></td>
              <td>PDF files with "invoice" in the name</td>
              <td>invoice_march.pdf</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<!-- ADD ENTRIES CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add File Expressions</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="add_entries">
      <div class="row">
        <div class="col-md-8">
          <label for="entries" class="form-label"><strong>File Expressions</strong></label>
          <textarea class="form-control" id="entries" name="entries" rows="5"
            placeholder="\.exe$ Executable files
\.(bat|cmd)$ Batch and command files
^invoice.*\.pdf$ Invoice PDF files"></textarea>
          <small class="text-muted">
            One entry per line. Format: <code>regex_pattern description</code><br>
            The regex pattern is separated from the description by the first space.<br>
            Examples: <code>\.exe$ Executable files</code> or <code>^invoice Invoice attachments</code>
          </small>
        </div>
        <div class="col-md-4 d-flex align-items-end pb-4">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add Expressions
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- EXPRESSIONS TABLE -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-file-code"></i> File Expressions</h3>
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

      <table id="expressionsTable" class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th style="width: 5%"><input type="checkbox" id="selectAll"></th>
            <th style="width: 35%">Regex Pattern</th>
            <th style="width: 40%">Description</th>
            <th style="width: 20%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_file_expressions">
            <tr>
              <td><input type="checkbox" class="row-checkbox" value="#id#"></td>
              <td><code>#encodeForHTML(file)#</code></td>
              <td>#encodeForHTML(description)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-danger" onclick="deleteSingle('#id#', '#encodeForJavaScript(file)#');" title="Delete">
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
<form id="deleteForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="delete">
  <input type="hidden" name="delete_id" id="delete_id" value="">
</form>

<script>
$(document).ready(function() {
  $('#expressionsTable').DataTable({
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
    $('#bulkDeleteBtn').prop('disabled', selectedIds.size === 0);
  });
  $(document).on('change', '.row-checkbox', function() {
    if (this.checked) selectedIds.add(this.value); else selectedIds.delete(this.value);
    $('#bulkDeleteBtn').prop('disabled', selectedIds.size === 0);
  });
  window.submitBulkDelete = function() {
    if (selectedIds.size === 0) return;
    if (!confirm('Delete ' + selectedIds.size + ' selected expression(s)?')) return;
    $('#selectedIds').val(Array.from(selectedIds).join(','));
    $('#bulkDeleteForm').submit();
  };
});

function deleteSingle(id, name) {
  if (!confirm('Delete expression "' + name + '"?')) return;
  document.getElementById('delete_id').value = id;
  document.getElementById('deleteForm').submit();
}

/* Regex Helper Functions */
function applyCommonPattern(pattern) {
  if (!pattern) { alert('Select a pattern first.'); return; }
  var textarea = document.getElementById('entries');
  var current = textarea.value;
  if (current && !current.endsWith('\n')) current += '\n';
  textarea.value = current + pattern;
  textarea.focus();
}

function buildPattern() {
  var mode = document.getElementById('builderMode').value;
  var value = document.getElementById('builderValue').value;
  if (!value) { alert('Enter a value to build a pattern.'); return; }
  // Escape special regex characters in the user input
  var escaped = value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  var pattern = '';
  switch (mode) {
    case 'startswith': pattern = '^' + escaped; break;
    case 'endswith':   pattern = escaped + '$'; break;
    case 'contains':   pattern = escaped; break;
    case 'exact':      pattern = '^' + escaped + '$'; break;
  }
  document.getElementById('builtPattern').value = pattern;
  document.getElementById('testPattern').value = pattern;
  // Show explanation
  var explain = '';
  switch (mode) {
    case 'startswith': explain = 'Matches filenames starting with "' + value + '"'; break;
    case 'endswith':   explain = 'Matches filenames ending with "' + value + '"'; break;
    case 'contains':   explain = 'Matches filenames containing "' + value + '"'; break;
    case 'exact':      explain = 'Matches filenames exactly equal to "' + value + '"'; break;
  }
  document.getElementById('buildExplanation').innerHTML = '<small class="text-success"><i class="fas fa-check-circle me-1"></i>' + explain + '</small>';
  document.getElementById('buildExplanation').style.display = 'block';
}

function useBuiltPattern() {
  var pattern = document.getElementById('builtPattern').value;
  if (!pattern) { alert('Build or select a pattern first.'); return; }
  var textarea = document.getElementById('entries');
  var current = textarea.value;
  if (current && !current.endsWith('\n')) current += '\n';
  textarea.value = current + pattern + ' ';
  textarea.focus();
  // Place cursor at end so user can type description
  textarea.setSelectionRange(textarea.value.length, textarea.value.length);
}

function testRegex() {
  var pattern = document.getElementById('testPattern').value;
  var filename = document.getElementById('testFilename').value;
  var resultDiv = document.getElementById('testResult');
  resultDiv.style.display = 'block';

  if (!pattern) {
    resultDiv.innerHTML = '<span class="text-danger"><i class="fas fa-exclamation-circle"></i> Enter a regex pattern.</span>';
    return;
  }
  if (!filename) {
    resultDiv.innerHTML = '<span class="text-danger"><i class="fas fa-exclamation-circle"></i> Enter a filename to test against.</span>';
    return;
  }

  try {
    var regex = new RegExp(pattern, 'i');
    if (regex.test(filename)) {
      resultDiv.innerHTML = '<span class="text-success"><i class="fas fa-check-circle"></i> <strong>Match!</strong> The pattern <code>' +
        escapeHtml(pattern) + '</code> matches <code>' + escapeHtml(filename) + '</code></span>';
    } else {
      resultDiv.innerHTML = '<span class="text-danger"><i class="fas fa-times-circle"></i> <strong>No match.</strong> The pattern <code>' +
        escapeHtml(pattern) + '</code> does not match <code>' + escapeHtml(filename) + '</code></span>';
    }
  } catch (e) {
    resultDiv.innerHTML = '<span class="text-danger"><i class="fas fa-exclamation-triangle"></i> <strong>Invalid regex:</strong> ' + escapeHtml(e.message) + '</span>';
  }
}

function escapeHtml(text) {
  var div = document.createElement('div');
  div.appendChild(document.createTextNode(text));
  return div.innerHTML;
}
</script>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>
</html>
