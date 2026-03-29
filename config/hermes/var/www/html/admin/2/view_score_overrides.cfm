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
  <title>Hermes SEG | SpamAssassin Score Overrides</title>
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
            <h1 class="m-0">SpamAssassin Score Overrides</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Score Overrides</li>
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

<cfset session.m = "">

<!--- ALERTS --->
<cfset alerts = {
  "1":  {type:"success", msg:"Score override added successfully"},
  "2":  {type:"danger",  msg:"The Test Name field cannot be blank"},
  "3":  {type:"danger",  msg:"The Test Name already exists"},
  "4":  {type:"danger",  msg:"The Score must be between -999 and 999"},
  "5":  {type:"danger",  msg:"The Score field cannot be blank"},
  "6":  {type:"danger",  msg:"The Score must be a valid number"},
  "7":  {type:"success", msg:"Score override edited successfully. SpamAssassin configuration regenerated."},
  "8":  {type:"success", msg:"Score override(s) deleted successfully. SpamAssassin configuration regenerated."},
  "10": {type:"danger",  msg:"You must select at least one entry before clicking Delete"},
  "11": {type:"danger",  msg:"An error occurred while applying settings"}
}>

<cfif structKeyExists(alerts, toString(m))>
  <cfset a = alerts[toString(m)]>
  <cfoutput>
  <div class="alert alert-#a.type# alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <cfif a.type is "success"><h4><i class="icon fa fa-check"></i> Success</h4>
    <cfelse><h4><i class="icon fa fa-ban"></i> Error</h4></cfif>
    #a.msg#
  </div>
  </cfoutput>
</cfif>

<!--- ACTION ROUTING --->
<cfif action is "add">

  <!--- Validate test name --->
  <cfif NOT StructKeyExists(form, "parameter") OR trim(form.parameter) is "">
    <cfset session.m = 2>
    <cflocation url="view_score_overrides.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicates --->
  <cfquery name="checkDup" datasource="hermes">
    SELECT id FROM spam_settings
    WHERE parameter = <cfqueryparam value="#trim(form.parameter)#" cfsqltype="cf_sql_varchar">
      AND spamfilter = '1'
  </cfquery>
  <cfif checkDup.recordcount GTE 1>
    <cfset session.m = 3>
    <cflocation url="view_score_overrides.cfm" addtoken="no">
  </cfif>

  <!--- Validate score --->
  <cfif NOT StructKeyExists(form, "value") OR trim(form.value) is "">
    <cfset session.m = 5>
    <cflocation url="view_score_overrides.cfm" addtoken="no">
  </cfif>
  <cfif NOT IsNumeric(form.value)>
    <cfset session.m = 6>
    <cflocation url="view_score_overrides.cfm" addtoken="no">
  </cfif>
  <cfif Val(form.value) LT -999 OR Val(form.value) GT 999>
    <cfset session.m = 4>
    <cflocation url="view_score_overrides.cfm" addtoken="no">
  </cfif>

  <!--- Insert --->
  <cfquery datasource="hermes">
    INSERT INTO spam_settings (parameter, value, description, spamfilter, active, applied)
    VALUES (
      <cfqueryparam value="#trim(form.parameter)#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#trim(form.value)#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#trim(StructKeyExists(form,'description') ? form.description : '')#" cfsqltype="cf_sql_varchar">,
      '1', '1', '1'
    )
  </cfquery>

  <!--- Apply immediately --->
  <cftry>
    <cfinclude template="./inc/update_spamassassin_config_files.cfm">
    <cfinclude template="./inc/update_amavis_config_files.cfm">
    <cfinclude template="./inc/restart_amavis.cfm">
    <cfinclude template="./inc/restart_spamassassin.cfm">
    <cfset session.m = 1>
  <cfcatch type="any">
    <cfset session.m = 11>
  </cfcatch>
  </cftry>
  <cflocation url="view_score_overrides.cfm" addtoken="no">

<cfelseif action is "edit">

  <cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)>
    <!--- Validate score --->
    <cfif NOT StructKeyExists(form, "edit_value") OR trim(form.edit_value) is "">
      <cfset session.m = 5>
      <cflocation url="view_score_overrides.cfm" addtoken="no">
    </cfif>
    <cfif NOT IsNumeric(form.edit_value)>
      <cfset session.m = 6>
      <cflocation url="view_score_overrides.cfm" addtoken="no">
    </cfif>
    <cfif Val(form.edit_value) LT -999 OR Val(form.edit_value) GT 999>
      <cfset session.m = 4>
      <cflocation url="view_score_overrides.cfm" addtoken="no">
    </cfif>

    <cfquery datasource="hermes">
      UPDATE spam_settings
      SET value = <cfqueryparam value="#trim(form.edit_value)#" cfsqltype="cf_sql_varchar">,
          description = <cfqueryparam value="#trim(StructKeyExists(form,'edit_description') ? form.edit_description : '')#" cfsqltype="cf_sql_varchar">,
          applied = '1'
      WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
        AND spamfilter = '1'
    </cfquery>

    <!--- Apply immediately --->
    <cftry>
      <cfinclude template="./inc/update_spamassassin_config_files.cfm">
      <cfinclude template="./inc/update_amavis_config_files.cfm">
      <cfinclude template="./inc/restart_amavis.cfm">
      <cfinclude template="./inc/restart_spamassassin.cfm">
      <cfset session.m = 7>
    <cfcatch type="any">
      <cfset session.m = 11>
    </cfcatch>
    </cftry>
  </cfif>
  <cflocation url="view_score_overrides.cfm" addtoken="no">

<cfelseif action is "delete">

  <cfif NOT StructKeyExists(form, "delete_id") OR trim(form.delete_id) is "">
    <cfset session.m = 10>
    <cflocation url="view_score_overrides.cfm" addtoken="no">
  </cfif>

  <cfloop index="i" list="#form.delete_id#" delimiters=",">
    <cfif IsValid("integer", i)>
      <cfquery datasource="hermes">
        DELETE FROM spam_settings
        WHERE id = <cfqueryparam value="#i#" cfsqltype="cf_sql_integer">
          AND spamfilter = '1'
      </cfquery>
    </cfif>
  </cfloop>

  <!--- Apply immediately --->
  <cftry>
    <cfinclude template="./inc/update_spamassassin_config_files.cfm">
    <cfinclude template="./inc/update_amavis_config_files.cfm">
    <cfinclude template="./inc/restart_amavis.cfm">
    <cfinclude template="./inc/restart_spamassassin.cfm">
    <cfset session.m = 8>
  <cfcatch type="any">
    <cfset session.m = 11>
  </cfcatch>
  </cftry>
  <cflocation url="view_score_overrides.cfm" addtoken="no">

  <cftry>
    <cfinclude template="./inc/update_spamassassin_config_files.cfm">
    <cfinclude template="./inc/update_amavis_config_files.cfm">
    <cfinclude template="./inc/restart_amavis.cfm">
    <cfinclude template="./inc/restart_spamassassin.cfm">
    <cfset session.m = 9>
  <cfcatch type="any">
    <cfset session.m = 11>
  </cfcatch>
  </cftry>
  <cflocation url="view_score_overrides.cfm" addtoken="no">

</cfif>

<!--- Load current overrides --->
<cfquery name="getOverrides" datasource="hermes">
  SELECT id, parameter, value, description, applied
  FROM spam_settings
  WHERE spamfilter = '1' AND active = '1'
  ORDER BY parameter ASC
</cfquery>


<!-- SCORE OVERRIDES CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-sliders-h"></i> SpamAssassin Score Overrides</h3>
  </div>
  <div class="card-body">

    <div class="alert alert-info mb-3">
      <i class="fas fa-info-circle me-1"></i> <strong>How SpamAssassin Scoring Works</strong>
      <p class="mt-2 mb-2">SpamAssassin evaluates each incoming email against hundreds of built-in test rules. Each rule that matches adds its score to the message's total spam score. When the total score exceeds the spam threshold (configured in Antispam Settings), the message is flagged or quarantined as spam.</p>

      <p class="mb-2"><strong>Score overrides</strong> let you change the default score of any built-in SpamAssassin rule without modifying SpamAssassin's core files. Your overrides are written to <code>local.cf</code> and take precedence over the defaults.</p>

      <hr>
      <strong>How scores work:</strong>
      <ul class="mb-2 mt-1">
        <li><strong>Positive score</strong> (e.g., <code>3.5</code>) - Adds to the spam score. Higher values make the rule more aggressive at flagging spam.</li>
        <li><strong>Score of 0</strong> - Effectively disables the rule. The rule still runs but contributes nothing to the spam score.</li>
        <li><strong>Negative score</strong> (e.g., <code>-2.0</code>) - Subtracts from the spam score. Acts as a whitelist/bonus, making it harder for the message to be flagged as spam.</li>
      </ul>

      <strong>Common use cases:</strong>
      <ul class="mb-2 mt-1">
        <li><strong>Reduce false positives</strong> - Lower the score of a rule that incorrectly flags legitimate mail (e.g., <code>HTML_MESSAGE 0</code> to stop penalizing HTML-only emails)</li>
        <li><strong>Increase detection</strong> - Raise the score of a rule to catch more spam (e.g., <code>BAYES_99 5.0</code> to heavily penalize messages the Bayesian filter is 99% sure are spam)</li>
        <li><strong>Disable a rule entirely</strong> - Set any rule's score to <code>0</code></li>
      </ul>

      <strong>Examples:</strong>
      <table class="table table-sm table-bordered mt-1 mb-1" style="max-width:600px;">
        <thead><tr><th>Test Name</th><th>Score</th><th>Effect</th></tr></thead>
        <tbody>
          <tr><td><code>BAYES_99</code></td><td><code>5.0</code></td><td>Increase weight when Bayes filter is 99% sure message is spam</td></tr>
          <tr><td><code>BAYES_50</code></td><td><code>1.0</code></td><td>Reduce default weight when Bayes filter is only 50% confident</td></tr>
          <tr><td><code>DKIM_ADSP_ALL</code></td><td><code>3.0</code></td><td>Penalize unsigned mail from domains that declare all mail is signed</td></tr>
          <tr><td><code>SPF_FAIL</code></td><td><code>0</code></td><td>Disable the SPF_FAIL rule (score of 0 = rule has no effect)</td></tr>
          <tr><td><code>HTML_MESSAGE</code></td><td><code>0</code></td><td>Disable the HTML_MESSAGE rule (score of 0 = rule has no effect)</td></tr>
        </tbody>
      </table>

      <small class="text-muted"><strong>Finding rule names:</strong> Check the <code>X-Spam-Status</code> header of any email to see which SpamAssassin rules matched and their scores. Rule names are uppercase with underscores (e.g., <code>BAYES_99</code>, <code>SPF_FAIL</code>, <code>HTML_MESSAGE</code>).</small>
    </div>

    <!-- BUTTONS -->
    <div class="mb-3">
      <cfoutput>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##addModal">
        <i class="fa fa-plus-square"></i> Add Override
      </button>
      </cfoutput>
      <button type="button" id="deleteSelected" class="btn btn-danger">
        <i class="fas fa-trash-alt"></i> Delete Selected
      </button>
    </div>

    <!-- OVERRIDES TABLE -->
    <cfif getOverrides.recordcount GTE 1>
      <form id="overridesForm">
      <div class="table-responsive">
        <table id="sortTable" class="table table-bordered table-hover table-striped" style="width:100%">
          <thead>
            <tr>
              <th style="width:40px"><input type="checkbox" id="selectAll"></th>
              <th>Test Name</th>
              <th style="width:100px">Score</th>
              <th>Description</th>
              <th style="width:60px">Edit</th>
            </tr>
          </thead>
          <tbody>
            <cfoutput query="getOverrides">
            <tr>
              <td><input type="checkbox" name="id" value="#id#"></td>
              <td>#encodeForHTML(parameter)#</td>
              <td>#encodeForHTML(value)#</td>
              <td>#encodeForHTML(description)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-primary" title="Edit"
                  onclick="openEditModal(#id#, '#encodeForJavaScript(parameter)#', '#encodeForJavaScript(value)#', '#encodeForJavaScript(description)#')">
                  <i class="fas fa-edit"></i>
                </button>
              </td>
            </tr>
            </cfoutput>
          </tbody>
        </table>
      </div>
      </form>
    <cfelse>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No score overrides have been added. SpamAssassin is using default scores for all rules.
      </div>
    </cfif>

  </div>
</div>

<!-- ADD MODAL -->
<div class="modal fade" id="addModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="add">
        <div class="modal-header">
          <h5 class="modal-title">Add Score Override</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label"><strong>Test Name</strong></label>
            <input type="text" class="form-control" name="parameter" placeholder="e.g. BAYES_99, SPF_FAIL, DKIM_ADSP_ALL" maxlength="255">
            <small class="form-text text-muted">The SpamAssassin rule name. Use uppercase with underscores.</small>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Score</strong></label>
            <input type="text" class="form-control" name="value" placeholder="e.g. 3.5, 0, -1.0" maxlength="10">
            <small class="form-text text-muted">Numeric value between -999 and 999. Set to 0 to disable the rule. Negative values reduce spam score.</small>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Description</strong></label>
            <input type="text" class="form-control" name="description" placeholder="Optional description" maxlength="255">
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            Add Override
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- EDIT MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="edit_id" id="edit_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Score Override</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label"><strong>Test Name</strong></label>
            <input type="text" class="form-control bg-light" id="edit_parameter" readonly>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Score</strong></label>
            <input type="text" class="form-control" name="edit_value" id="edit_value" maxlength="10">
            <small class="form-text text-muted">Numeric value between -999 and 999.</small>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Description</strong></label>
            <input type="text" class="form-control" name="edit_description" id="edit_description" maxlength="255">
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
            Save Changes
          </button>
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
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="delete_id" id="deleteIds" value="">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title">Delete Score Overrides</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to delete the selected score overrides? The SpamAssassin configuration will be regenerated automatically.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          <button type="submit" class="btn btn-danger"
            onclick="this.disabled=true;this.innerHTML='Deleting...';this.form.submit();">Yes, Delete</button>
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

<script>
$(document).ready(function() {
  $('#sortTable').DataTable({
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

  // Select All
  $('#selectAll').click(function() {
    $('input[name="id"]').prop('checked', this.checked);
  });

  // Delete button
  $('#deleteSelected').click(function() {
    var selected = [];
    $('input[name="id"]:checked').each(function() {
      selected.push($(this).val());
    });
    if (selected.length === 0) {
      alert('Please select at least one entry to delete.');
      return;
    }
    $('#deleteIds').val(selected.join(','));
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
  });
});

// Edit modal
function openEditModal(id, parameter, value, description) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_parameter').value = parameter;
  document.getElementById('edit_value').value = value;
  document.getElementById('edit_description').value = description;
  new bootstrap.Modal(document.getElementById('editModal')).show();
}
</script>

</body>
</html>
