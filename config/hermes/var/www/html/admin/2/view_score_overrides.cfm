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
  "11": {type:"danger",  msg:"An error occurred while applying settings"},
  "12": {type:"danger",  msg:"This rule is system-managed and cannot be edited or deleted (defines a Hermes architectural decision)"},
  "13": {type:"danger",  msg:"Score overrides for DKIM_*, ADSP, and SPF_* rules have no effect because the underlying SpamAssassin plugins are disabled in Hermes. See the warning callout for details and the authoritative verifier for each protocol."}
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

  <!--- Block adds for rules belonging to plugins we've disabled (#234).
        Lookup is case-insensitive so admins can't sidestep with mixed case. --->
  <cfset _paramUpper = UCase(trim(form.parameter))>
  <cfif Left(_paramUpper, 5) IS "DKIM_"
     OR FindNoCase("ADSP", _paramUpper) GT 0
     OR Left(_paramUpper, 4) IS "SPF_">
    <cfset session.m = 13>
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
    <!--- Block edits to system-managed rules (forged POST defense; UI hides the edit button) --->
    <cfquery name="checkSysManagedEdit" datasource="hermes">
      SELECT system_managed FROM spam_settings
      WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
        AND spamfilter = '1'
    </cfquery>
    <cfif checkSysManagedEdit.recordcount EQ 1 AND checkSysManagedEdit.system_managed EQ 1>
      <cfset session.m = 12>
      <cflocation url="view_score_overrides.cfm" addtoken="no">
    </cfif>

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
        AND system_managed = 0
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
      <!--- AND system_managed = 0 silently skips any forged POST targeting a system-managed row.
            UI hides the checkbox for system-managed rows so legitimate users never hit this path. --->
      <cfquery datasource="hermes">
        DELETE FROM spam_settings
        WHERE id = <cfqueryparam value="#i#" cfsqltype="cf_sql_integer">
          AND spamfilter = '1'
          AND system_managed = 0
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
  SELECT id, parameter, value, description, applied, system_managed
  FROM spam_settings
  WHERE spamfilter = '1' AND active = '1'
  ORDER BY system_managed DESC, parameter ASC
</cfquery>


<!-- HELP CARD (COLLAPSIBLE) -->
<div class="card card-outline card-secondary mb-4">
  <div class="card-header">
    <h3 class="card-title">
      <button type="button" class="btn btn-sm btn-outline-secondary me-2" id="toggleScoringHelper" title="Expand">
        <i class="fas fa-chevron-down"></i>
      </button>
      <i class="fas fa-question-circle"></i> How SpamAssassin Scoring Works
    </h3>
  </div>
  <div class="collapse" id="scoringHelper">
    <div class="card-body">
      <p>SpamAssassin evaluates each incoming email against hundreds of built-in test rules. Each rule that matches adds its score to the message's total spam score. When the total score exceeds the spam threshold (configured in Antispam Settings), the message is flagged or quarantined as spam.</p>

      <p><strong>Score overrides</strong> let you change the default score of any built-in SpamAssassin rule without modifying SpamAssassin's core files. Your overrides are written to <code>local.cf</code> and take precedence over the defaults.</p>

      <h5 class="border-bottom pb-2 mb-2 mt-3">How scores work</h5>
      <ul class="mb-3">
        <li><strong>Positive score</strong> (e.g., <code>3.5</code>) - Adds to the spam score. Higher values make the rule more aggressive at flagging spam.</li>
        <li><strong>Score of 0</strong> - Effectively disables the rule. The rule still runs but contributes nothing to the spam score.</li>
        <li><strong>Negative score</strong> (e.g., <code>-2.0</code>) - Subtracts from the spam score. Acts as a whitelist/bonus, making it harder for the message to be flagged as spam.</li>
      </ul>

      <h5 class="border-bottom pb-2 mb-2 mt-3">Common use cases</h5>
      <ul class="mb-3">
        <li><strong>Reduce false positives</strong> - Lower the score of a rule that incorrectly flags legitimate mail (e.g., <code>HTML_MESSAGE 0</code> to stop penalizing HTML-only emails)</li>
        <li><strong>Increase detection</strong> - Raise the score of a rule to catch more spam (e.g., <code>BAYES_99 5.0</code> to heavily penalize messages the Bayesian filter is 99% sure are spam)</li>
        <li><strong>Disable a rule entirely</strong> - Set any rule's score to <code>0</code></li>
      </ul>

      <h5 class="border-bottom pb-2 mb-2 mt-3">Examples</h5>
      <table class="table table-sm table-bordered mb-3" style="max-width:700px;">
        <thead><tr><th>Test Name</th><th>Score</th><th>Effect</th></tr></thead>
        <tbody>
          <tr><td><code>BAYES_99</code></td><td><code>5.0</code></td><td>Increase weight when Bayes filter is 99% sure message is spam</td></tr>
          <tr><td><code>BAYES_50</code></td><td><code>1.0</code></td><td>Reduce default weight when Bayes filter is only 50% confident</td></tr>
          <tr><td><code>FREEMAIL_FROM</code></td><td><code>1.0</code></td><td>Penalize mail from public free-email providers (Gmail, Yahoo, etc.)</td></tr>
          <tr><td><code>HTML_MESSAGE</code></td><td><code>0</code></td><td>Disable the HTML_MESSAGE rule (score of 0 = rule has no effect)</td></tr>
        </tbody>
      </table>

      <p class="mb-0"><small class="text-muted"><strong>Finding rule names:</strong> Check the <code>X-Spam-Status</code> header of any email to see which SpamAssassin rules matched and their scores. Rule names are uppercase with underscores (e.g., <code>BAYES_99</code>, <code>HTML_MESSAGE</code>).</small></p>
    </div>
  </div>
</div>

<!-- SCORE OVERRIDES CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-sliders-h"></i> SpamAssassin Score Overrides</h3>
  </div>
  <div class="card-body">

    <div class="alert alert-warning mb-3">
      <i class="fas fa-exclamation-triangle me-1"></i> <strong>DKIM and SPF rules are not evaluated by SpamAssassin</strong>
      <p class="mt-2 mb-2">Both the SpamAssassin <strong>DKIM</strong> and <strong>SPF</strong> plugins are intentionally disabled in Hermes SEG. Adding score overrides for any of the following rule families will have <strong>no effect</strong> — the rules will be parsed but cannot fire because the underlying plugin functions are not loaded:</p>
      <ul class="mb-2">
        <li><strong>DKIM rules</strong>: <code>DKIM_INVALID</code>, <code>DKIM_VALID</code>, <code>DKIM_ADSP_ALL</code>, <code>DKIM_ADSP_DISCARD</code>, <code>DKIM_ADSP_NXDOMAIN</code>, <code>DKIM_ADSP_CUSTOM_*</code>, <code>NML_ADSP_CUSTOM_*</code></li>
        <li><strong>SPF rules</strong>: <code>SPF_PASS</code>, <code>SPF_FAIL</code>, <code>SPF_SOFTFAIL</code>, <code>SPF_NEUTRAL</code>, <code>SPF_HELO_FAIL</code>, <code>SPF_HELO_SOFTFAIL</code>, <code>SPF_HELO_PASS</code></li>
      </ul>
      <p class="mb-2"><strong>Why DKIM is disabled:</strong> DKIM verification is performed once at the gateway perimeter by OpenDKIM (the authoritative source). Hermes modifies inbound message bodies (External Sender Banner, Disclaimers, Signatures), which would cause SpamAssassin's redundant DKIM re-verification to produce false-positive <code>dkim=fail</code> verdicts on every legitimate message. The <code>Authentication-Results:</code> header written by OpenDKIM at <code>:25</code> is the authoritative DKIM verdict.</p>
      <p class="mb-0"><strong>Why SPF is disabled:</strong> SPF verification is performed at SMTP envelope time by <code>postfix-policyd-spf-python</code> on hard fail AND soft fail. SpamAssassin's redundant SPF re-check could pick up the wrong intermediate hop's IP from the Received chain in multi-relay scenarios (federal mail, M365 GOV cloud, Proofpoint Government, etc.) and produce false-positive fail/softfail verdicts. The <code>Received-SPF:</code> header written by <code>postfix-policyd-spf-python</code> is the authoritative SPF verdict.</p>
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
            <tr<cfif system_managed eq 1> class="table-light"</cfif>>
              <td>
                <cfif system_managed eq 1>
                  <span class="text-muted" title="System-managed - cannot be edited or deleted"><i class="fas fa-lock"></i></span>
                <cfelse>
                  <input type="checkbox" name="id" value="#id#">
                </cfif>
              </td>
              <td>
                #encodeForHTML(parameter)#
                <cfif system_managed eq 1>
                  <span class="badge bg-secondary ms-2" title="Managed by Hermes architecture (GitHub ##234)">System-managed</span>
                </cfif>
              </td>
              <td>#encodeForHTML(value)#</td>
              <td>#encodeForHTML(description)#</td>
              <td>
                <cfif system_managed eq 1>
                  <button type="button" class="btn btn-sm btn-secondary" disabled title="System-managed - cannot be edited">
                    <i class="fas fa-lock"></i>
                  </button>
                <cfelse>
                  <button type="button" class="btn btn-sm btn-primary" title="Edit"
                    onclick="openEditModal(#id#, '#encodeForJavaScript(parameter)#', '#encodeForJavaScript(value)#', '#encodeForJavaScript(description)#')">
                    <i class="fas fa-edit"></i>
                  </button>
                </cfif>
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

// Scoring Helper toggle (chevron down/up) - mirrors view_message_rules.cfm pattern
$('#toggleScoringHelper').on('click', function() {
  $('#scoringHelper').collapse('toggle');
});
$('#scoringHelper').on('shown.bs.collapse', function() {
  $('#toggleScoringHelper').find('i').removeClass('fa-chevron-down').addClass('fa-chevron-up');
  $('#toggleScoringHelper').attr('title', 'Collapse');
});
$('#scoringHelper').on('hidden.bs.collapse', function() {
  $('#toggleScoringHelper').find('i').removeClass('fa-chevron-up').addClass('fa-chevron-down');
  $('#toggleScoringHelper').attr('title', 'Expand');
});
</script>

</body>
</html>
