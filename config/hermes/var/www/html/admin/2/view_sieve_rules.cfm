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
  <title>Hermes SEG | Email Server - Mailbox Rules</title>
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
            <h1 class="m-0">Email Server - Mailbox Rules</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Email Server</li>
              <li class="breadcrumb-item active">Mailbox Rules</li>
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

<cfif action EQ "add_rule" OR action EQ "edit_rule" OR action EQ "delete_rule" OR action EQ "toggle_rule" OR action EQ "reorder_rule">
  <cfinclude template="./inc/sieve_rule_actions.cfm">
</cfif>

<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Rule created and sieve script regenerated.
  </div>
<cfelseif m EQ 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Rule updated and sieve script regenerated.
  </div>
<cfelseif m EQ 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Rule deleted and sieve script regenerated.
  </div>
<cfelseif m EQ 4>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Rule toggled and sieve script regenerated.
  </div>
<cfelseif m EQ 5>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Rule order updated.
  </div>
<cfelseif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Rule name cannot be blank.
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    At least one condition is required.
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    At least one action is required.
  </div>
<cfelseif m EQ 13>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Size value must be a positive integer optionally followed by K, M, or G (e.g. <code>10M</code>).
  </div>
<cfelseif m EQ 14>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Redirect action requires a valid email address.
  </div>
<cfelseif m EQ 15>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    The selected action requires a value (e.g. folder name for "File to folder", rejection message for "Reject with message").
  </div>
<cfelseif m EQ 16>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Condition value (max 500 chars) or action value (max 255 chars) is too long.
  </div>
<cfelseif m EQ 17>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    "All Messages" cannot be combined with other conditions. Use it on its own.
  </div>
<cfelseif m EQ 22>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    System rules cannot be deleted.
  </div>
<cfelseif m EQ 30>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Saved, but compilation failed</h4>
    <p class="mb-1">Your rule was saved to the database, but the generated sieve script failed to compile. The previous compiled script is still active until this is fixed.</p>
    <cfif StructKeyExists(session, "compile_error")>
      <pre class="mb-0" style="white-space:pre-wrap;font-size:0.85em;"><cfoutput>#HTMLEditFormat(session.compile_error)#</cfoutput></pre>
      <cfset session.compile_error = "">
    </cfif>
  </div>
</cfif>

<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About Global Mailbox Rules</h5>
  <p class="mb-1">Global mailbox rules run <strong>before</strong> any user's personal rules on every incoming message delivered to a mailbox. They are mandatory and cannot be overridden by users.</p>
  <p class="mb-1"><small>System rules (marked with <span class="badge bg-primary">System</span>) cannot be deleted but can be enabled or disabled. Rules can have multiple conditions (AND/OR) and multiple actions. Rules are processed in order from top to bottom.</small></p>
  <p class="mb-0"><small><strong>Note about Bcc:</strong> The <code>Bcc</code> header is stripped by the MTA before delivery in most cases (that is the entire purpose of Bcc), so a condition matching the <code>Bcc</code> field will rarely fire on incoming mail. It is included for completeness but should not be relied on.</small></p>
</div>

<cfquery name="getRules" datasource="hermes">
    SELECT id, rule_name, rule_order, enabled, is_system, match_type
    FROM sieve_rules
    WHERE scope = 'global'
    ORDER BY rule_order ASC
</cfquery>

<cfquery name="getAllConds" datasource="hermes">
    SELECT c.rule_id, c.condition_field, c.condition_type, c.condition_value
    FROM sieve_rule_conditions c
    INNER JOIN sieve_rules r ON r.id = c.rule_id
    WHERE r.scope = 'global'
    ORDER BY c.rule_id, c.condition_order, c.id
</cfquery>

<cfquery name="getAllActs" datasource="hermes">
    SELECT a.rule_id, a.action_type, a.action_value
    FROM sieve_rule_actions a
    INNER JOIN sieve_rules r ON r.id = a.rule_id
    WHERE r.scope = 'global'
    ORDER BY a.rule_id, a.action_order, a.id
</cfquery>

<div class="mb-3">
  <button type="button" class="btn btn-primary" onclick="openAddModal()"><i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Add Rule</button>
</div>

<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-filter me-2"></i>Global Mailbox Rules (<cfoutput>#getRules.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <table id="sieveRulesTable" class="table table-bordered table-striped" style="width:100%">
      <thead>
        <tr>
          <th>Order</th>
          <th>Actions</th>
          <th>Rule Name</th>
          <th>Match</th>
          <th>Conditions</th>
          <th>Actions</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getRules">
        <tr>
          <td>#rule_order#</td>
          <td>
            <div class="d-flex gap-1 flex-nowrap align-items-center">
              <button type="button" class="btn btn-sm btn-outline-secondary" title="Move Up" onclick="reorderRule(#id#, 'up')">
                <i class="fas fa-arrow-up"></i>
              </button>
              <button type="button" class="btn btn-sm btn-outline-secondary" title="Move Down" onclick="reorderRule(#id#, 'down')">
                <i class="fas fa-arrow-down"></i>
              </button>
              <button type="button" class="btn btn-sm <cfif enabled EQ 1>btn-success<cfelse>btn-secondary</cfif>" title="<cfif enabled EQ 1>Disable<cfelse>Enable</cfif>" onclick="toggleRule(#id#)">
                <i class="fas <cfif enabled EQ 1>fa-toggle-on<cfelse>fa-toggle-off</cfif>"></i>
              </button>
              <cfif is_system NEQ 1>
                <button type="button" class="btn btn-sm btn-primary" title="Edit" onclick="loadEditRuleModal(#id#)">
                  <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-sm btn-danger" title="Delete" onclick="confirmDeleteRule(#id#, '#JSStringFormat(rule_name)#')">
                  <i class="fas fa-trash"></i>
                </button>
              <cfelse>
                <span class="badge bg-primary">System</span>
              </cfif>
            </div>
          </td>
          <td>#HTMLEditFormat(rule_name)#</td>
          <td>
            <cfif match_type EQ "any">
              <span class="badge bg-warning text-dark">ANY (OR)</span>
            <cfelse>
              <span class="badge bg-info">ALL (AND)</span>
            </cfif>
          </td>
          <td>
            <code>
            <cfset condCount = 0>
            <cfloop query="getAllConds">
              <cfif getAllConds.rule_id EQ id>
                <cfif condCount GT 0><br></cfif>
                <cfif getAllConds.condition_field EQ "header">
                  Header #HTMLEditFormat(ListFirst(getAllConds.condition_value, ":"))#
                <cfelseif getAllConds.condition_field EQ "subject">Subject
                <cfelseif getAllConds.condition_field EQ "from">From
                <cfelseif getAllConds.condition_field EQ "to">To
                <cfelseif getAllConds.condition_field EQ "cc">Cc
                <cfelseif getAllConds.condition_field EQ "bcc">Bcc
                <cfelseif getAllConds.condition_field EQ "size">Size
                <cfelseif getAllConds.condition_field EQ "all">All messages
                </cfif>
                <cfif getAllConds.condition_field EQ "size">
                  <cfif getAllConds.condition_type EQ "over">over<cfelse>under</cfif> #HTMLEditFormat(getAllConds.condition_value)#
                <cfelseif getAllConds.condition_field NEQ "all">
                  <cfif getAllConds.condition_type EQ "is">is exactly
                  <cfelseif getAllConds.condition_type EQ "contains">contains
                  <cfelseif getAllConds.condition_type EQ "matches">matches
                  <cfelseif getAllConds.condition_type EQ "not_contains">does not contain
                  </cfif>
                  <cfif getAllConds.condition_field EQ "header">
                    "#HTMLEditFormat(trim(ListRest(getAllConds.condition_value, ':')))#"
                  <cfelse>
                    "#HTMLEditFormat(getAllConds.condition_value)#"
                  </cfif>
                </cfif>
                <cfset condCount++>
              </cfif>
            </cfloop>
            </code>
          </td>
          <td>
            <cfset actCount = 0>
            <cfloop query="getAllActs">
              <cfif getAllActs.rule_id EQ id>
                <cfif actCount GT 0><br></cfif>
                <cfif getAllActs.action_type EQ "fileinto">
                  <span class="badge bg-info">File to</span> #HTMLEditFormat(getAllActs.action_value)#
                <cfelseif getAllActs.action_type EQ "discard">
                  <span class="badge bg-dark">Discard</span>
                <cfelseif getAllActs.action_type EQ "keep">
                  <span class="badge bg-success">Keep</span>
                <cfelseif getAllActs.action_type EQ "redirect">
                  <span class="badge bg-warning text-dark">Redirect to</span> #HTMLEditFormat(getAllActs.action_value)#
                <cfelseif getAllActs.action_type EQ "flag_seen">
                  <span class="badge bg-secondary">Mark read</span>
                <cfelseif getAllActs.action_type EQ "reject">
                  <span class="badge bg-danger">Reject</span> #HTMLEditFormat(getAllActs.action_value)#
                </cfif>
                <cfset actCount++>
              </cfif>
            </cfloop>
          </td>
          <td>
            <cfif enabled EQ 1>
              <span class="badge bg-success">Enabled</span>
            <cfelse>
              <span class="badge bg-secondary">Disabled</span>
            </cfif>
          </td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>

<!--- ============================================================
     RULE MODAL (used for both add and edit)
     ============================================================ --->
<div class="modal fade" id="ruleModal" tabindex="-1">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <form method="post" action="view_sieve_rules.cfm" id="ruleForm">
        <input type="hidden" name="action" id="ruleFormAction" value="add_rule">
        <input type="hidden" name="rule_id" id="ruleFormRuleId" value="">
        <input type="hidden" name="cond_count" id="condCount" value="0">
        <input type="hidden" name="act_count" id="actCount" value="0">
        <div class="modal-header">
          <h5 class="modal-title" id="ruleModalTitle"><i class="fas fa-plus me-2"></i>Add Mailbox Rule</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <div class="form-group mb-3">
            <label><strong>Rule Name</strong></label>
            <input type="text" class="form-control" name="rule_name" id="ruleName" maxlength="255" placeholder="e.g., Move newsletters to folder" required>
          </div>

          <div class="form-group mb-3">
            <label><strong>Match Type</strong></label>
            <select class="form-control" name="match_type" id="matchType" style="max-width:300px;">
              <option value="all">Match ALL conditions (AND)</option>
              <option value="any">Match ANY condition (OR)</option>
            </select>
            <small class="text-muted">Determines whether all conditions must match or just any one.</small>
          </div>

          <div class="card mb-3">
            <div class="card-header d-flex justify-content-between align-items-center">
              <strong>IF (Conditions)</strong>
              <button type="button" class="btn btn-sm btn-outline-primary" onclick="addConditionRow()"><i class="fas fa-plus"></i> Add Condition</button>
            </div>
            <div class="card-body" id="conditionsContainer">
              <!-- Condition rows injected here -->
            </div>
          </div>

          <div class="card mb-3">
            <div class="card-header d-flex justify-content-between align-items-center">
              <strong>THEN (Actions)</strong>
              <button type="button" class="btn btn-sm btn-outline-primary" onclick="addActionRow()"><i class="fas fa-plus"></i> Add Action</button>
            </div>
            <div class="card-body" id="actionsContainer">
              <!-- Action rows injected here -->
            </div>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Save Rule</button>
        </div>
      </form>
    </div>
  </div>
</div>

<form id="toggleRuleForm" method="post" action="view_sieve_rules.cfm" style="display:none;">
  <input type="hidden" name="action" value="toggle_rule">
  <input type="hidden" name="toggle_rule_id" id="toggleRuleId">
</form>
<form id="reorderRuleForm" method="post" action="view_sieve_rules.cfm" style="display:none;">
  <input type="hidden" name="action" value="reorder_rule">
  <input type="hidden" name="reorder_rule_id" id="reorderRuleId">
  <input type="hidden" name="reorder_direction" id="reorderDirection">
</form>

<div class="modal fade" id="deleteRuleModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_sieve_rules.cfm">
        <input type="hidden" name="action" value="delete_rule">
        <input type="hidden" name="delete_rule_id" id="deleteRuleId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-trash me-2 text-danger"></i>Delete Mailbox Rule</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to delete the rule <strong id="deleteRuleName"></strong>?</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete Rule</button>
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
  var condIdx = 0;
  var actIdx = 0;

  $(document).ready(function() {
    $('#sieveRulesTable').DataTable({
      "order": [[0, "asc"]],
      "paging": false,
      "searching": false,
      "info": false,
      "columnDefs": [{ "orderable": false, "targets": [1, 4, 5] }]
    });

    // Confirm before submitting destructive rule combinations
    $('#ruleForm').on('submit', function(e) {
      var hasAll = false;
      var hasDiscard = false;
      var hasReject = false;
      $('.condition-row').each(function() {
        var idx = $(this).data('idx');
        if ($(this).find('[name="cond_field_' + idx + '"]').val() === 'all') hasAll = true;
      });
      $('.action-row').each(function() {
        var idx = $(this).data('idx');
        var v = $(this).find('[name="act_type_' + idx + '"]').val();
        if (v === 'discard') hasDiscard = true;
        if (v === 'reject') hasReject = true;
      });
      var needConfirm = null;
      if (hasAll && hasDiscard) {
        needConfirm = 'WARNING: This rule will SILENTLY DELETE every incoming message that reaches a mailbox. This is irreversible. Are you absolutely sure?';
      } else if (hasAll && hasReject) {
        needConfirm = 'WARNING: This rule will REJECT every incoming message and bounce it back to the sender. Are you absolutely sure?';
      }
      if (needConfirm && !confirm(needConfirm)) {
        e.preventDefault();
        e.stopImmediatePropagation();
        // The global form-submit hook in html_head.cfm has already shown
        // the preloader - hide it since we're cancelling the submit.
        var preloader = document.querySelector('.preloader');
        if (preloader) {
          preloader.style.display = 'none';
          preloader.style.opacity = '0';
        }
        return false;
      }
    });
  });

  // Build a condition row HTML block
  function conditionRowHtml(idx, cond) {
    cond = cond || { field: 'subject', type: 'contains', value: '' };
    var html = '<div class="row align-items-end mb-2 condition-row" data-idx="' + idx + '">';
    html += '<div class="col-md-3"><label class="form-label small mb-1">Field</label>';
    html += '<select class="form-control form-control-sm" name="cond_field_' + idx + '" onchange="updateCondRowUI(' + idx + ')">';
    html += '<option value="subject">Subject</option>';
    html += '<option value="from">From</option>';
    html += '<option value="to">To</option>';
    html += '<option value="cc">Cc</option>';
    html += '<option value="bcc">Bcc</option>';
    html += '<option value="header">Custom Header</option>';
    html += '<option value="size">Size</option>';
    html += '<option value="all">All Messages</option>';
    html += '</select></div>';
    html += '<div class="col-md-3"><label class="form-label small mb-1">Match</label>';
    html += '<select class="form-control form-control-sm" name="cond_type_' + idx + '">';
    html += '<option value="contains">Contains</option>';
    html += '<option value="is">Equals (case-insensitive)</option>';
    html += '<option value="matches">Matches pattern</option>';
    html += '<option value="not_contains">Does not contain</option>';
    html += '</select></div>';
    html += '<div class="col-md-5"><label class="form-label small mb-1">Value</label>';
    html += '<input type="text" class="form-control form-control-sm" name="cond_value_' + idx + '" maxlength="500" placeholder="e.g., newsletter">';
    html += '</div>';
    html += '<div class="col-md-1 text-end">';
    html += '<button type="button" class="btn btn-sm btn-outline-danger" title="Remove" onclick="removeConditionRow(' + idx + ')"><i class="fas fa-times"></i></button>';
    html += '</div>';
    html += '</div>';
    return $(html).each(function() {
      $(this).find('[name="cond_field_' + idx + '"]').val(cond.field);
      $(this).find('[name="cond_type_' + idx + '"]').val(cond.type);
      $(this).find('[name="cond_value_' + idx + '"]').val(cond.value);
    });
  }

  function actionRowHtml(idx, act) {
    act = act || { type: 'fileinto', value: '' };
    var html = '<div class="row align-items-end mb-2 action-row" data-idx="' + idx + '">';
    html += '<div class="col-md-4"><label class="form-label small mb-1">Action</label>';
    html += '<select class="form-control form-control-sm" name="act_type_' + idx + '" onchange="updateActRowUI(' + idx + ')">';
    html += '<option value="fileinto">File to folder</option>';
    html += '<option value="discard">Discard (delete silently)</option>';
    html += '<option value="redirect">Redirect to address</option>';
    html += '<option value="keep">Keep (deliver normally)</option>';
    html += '<option value="flag_seen">Mark as read</option>';
    html += '<option value="reject">Reject with message</option>';
    html += '</select></div>';
    html += '<div class="col-md-7"><label class="form-label small mb-1 act-value-label">Folder name</label>';
    html += '<input type="text" class="form-control form-control-sm act-value-input" name="act_value_' + idx + '" maxlength="255" placeholder="e.g., Newsletters">';
    html += '<small class="form-text text-muted act-value-hint"></small>';
    html += '<div class="alert alert-warning small mt-2 mb-0 act-redirect-warning" style="display:none;">';
    html += '<i class="fas fa-shield-alt me-2"></i><strong>Forwarder-trust warning (#229):</strong> ';
    html += 'redirecting to an <strong>external address</strong> breaks all three sender-auth signals at the receiver:';
    html += '<ul class="mb-1 mt-1 ps-3">';
    html += '<li><strong>SPF fails</strong> &mdash; the receiver sees Hermes\'s IP, not an IP authorized by the original sender\'s SPF record (this break happens on any forward, regardless of body modification).</li>';
    html += '<li><strong>DKIM fails</strong> &mdash; if banner / disclaimer / encryption modified the body, the original sender\'s DKIM-Signature body hash no longer matches.</li>';
    html += '<li><strong>ARC chain fails</strong> &mdash; if the inbound message had an upstream ARC seal, the same body modification invalidates it; Hermes\'s own seal honestly records <code>cv=fail</code>.</li>';
    html += '</ul>';
    html += 'With all three broken, the receiver applies the original sender\'s DMARC policy (quarantine / reject for strict domains). ';
    html += 'Internal redirects (to mailboxes Hermes hosts) are not affected. ';
    html += 'For external destinations, ensure the receiver is configured to trust this gateway as a forwarder.';
    html += '</div>';
    html += '</div>';
    html += '<div class="col-md-1 text-end">';
    html += '<button type="button" class="btn btn-sm btn-outline-danger" title="Remove" onclick="removeActionRow(' + idx + ')"><i class="fas fa-times"></i></button>';
    html += '</div>';
    html += '</div>';
    return $(html).each(function() {
      $(this).find('[name="act_type_' + idx + '"]').val(act.type);
      $(this).find('[name="act_value_' + idx + '"]').val(act.value || '');
    });
  }

  function addConditionRow(cond) {
    var $row = conditionRowHtml(condIdx, cond);
    $('#conditionsContainer').append($row);
    var idx = condIdx;
    condIdx++;
    $('#condCount').val(condIdx);
    updateCondRowUI(idx);
  }

  function removeConditionRow(idx) {
    $('.condition-row[data-idx="' + idx + '"]').remove();
  }

  function addActionRow(act) {
    var $row = actionRowHtml(actIdx, act);
    $('#actionsContainer').append($row);
    var idx = actIdx;
    actIdx++;
    $('#actCount').val(actIdx);
    updateActRowUI(idx);
  }

  function removeActionRow(idx) {
    $('.action-row[data-idx="' + idx + '"]').remove();
  }

  function updateCondRowUI(idx) {
    var $row = $('.condition-row[data-idx="' + idx + '"]');
    var field = $row.find('[name="cond_field_' + idx + '"]').val();
    var $type = $row.find('[name="cond_type_' + idx + '"]');
    var $value = $row.find('[name="cond_value_' + idx + '"]');
    if (field === 'all') {
      $type.prop('disabled', true).hide();
      $value.prop('disabled', true).hide();
    } else if (field === 'size') {
      $type.prop('disabled', false).show().html('<option value="over">Is over</option><option value="under">Is under</option>');
      $value.prop('disabled', false).show().attr('placeholder', 'e.g., 10M');
    } else if (field === 'header') {
      $type.prop('disabled', false).show().html('<option value="contains">Contains</option><option value="is">Is exactly</option><option value="matches">Matches pattern</option><option value="not_contains">Does not contain</option>');
      $value.prop('disabled', false).show().attr('placeholder', 'Header-Name: value');
    } else {
      $type.prop('disabled', false).show().html('<option value="contains">Contains</option><option value="is">Is exactly</option><option value="matches">Matches pattern</option><option value="not_contains">Does not contain</option>');
      $value.prop('disabled', false).show().attr('placeholder', 'e.g., newsletter');
    }
  }

  function updateActRowUI(idx) {
    var $row = $('.action-row[data-idx="' + idx + '"]');
    var type = $row.find('[name="act_type_' + idx + '"]').val();
    var $label = $row.find('.act-value-label');
    var $input = $row.find('.act-value-input');
    var $hint = $row.find('.act-value-hint');
    var $redirectWarning = $row.find('.act-redirect-warning');
    $redirectWarning.hide();
    if (type === 'fileinto') {
      $label.text('Folder name');
      $input.show().prop('disabled', false).attr('placeholder', 'e.g., Newsletters');
      $hint.text('Use "/" for nested folders (e.g. "Work/Projects").');
    } else if (type === 'redirect') {
      $label.text('Email address');
      $input.show().prop('disabled', false).attr('placeholder', 'e.g., user@domain.com');
      $hint.text('Forwarding may cause loops or trigger spam scoring on the destination server.');
      $redirectWarning.show();
    } else if (type === 'reject') {
      $label.text('Rejection message');
      $input.show().prop('disabled', false).attr('placeholder', 'e.g., Mailbox does not accept mail');
      $hint.text('Generates a bounce back to the sender, which can leak that the address exists. Use sparingly.');
    } else {
      $label.text('');
      $input.hide().prop('disabled', true).val('');
      $hint.text('');
    }
  }

  function resetModal() {
    $('#conditionsContainer').empty();
    $('#actionsContainer').empty();
    condIdx = 0; actIdx = 0;
    $('#condCount').val(0); $('#actCount').val(0);
    $('#ruleName').val('');
    $('#matchType').val('all');
    $('#ruleFormRuleId').val('');
  }

  function openAddModal() {
    resetModal();
    $('#ruleFormAction').val('add_rule');
    $('#ruleModalTitle').html('<i class="fas fa-plus me-2"></i>Add Mailbox Rule');
    addConditionRow();
    addActionRow();
    new bootstrap.Modal(document.getElementById('ruleModal')).show();
  }

  function loadEditRuleModal(ruleId) {
    $.post('./inc/get_sieve_rule_json.cfm', { id: ruleId }, function(data) {
      try {
        var r = (typeof data === 'string') ? JSON.parse(data) : data;
        if (r.error) { alert('Error: ' + r.error); return; }
        resetModal();
        $('#ruleFormAction').val('edit_rule');
        $('#ruleFormRuleId').val(r.id);
        $('#ruleName').val(r.rule_name);
        $('#matchType').val(r.match_type || 'all');
        $('#ruleModalTitle').html('<i class="fas fa-edit me-2"></i>Edit Mailbox Rule');
        if (r.conditions && r.conditions.length) {
          r.conditions.forEach(function(c) { addConditionRow(c); });
        } else {
          addConditionRow();
        }
        if (r.actions && r.actions.length) {
          r.actions.forEach(function(a) { addActionRow(a); });
        } else {
          addActionRow();
        }
        new bootstrap.Modal(document.getElementById('ruleModal')).show();
      } catch(e) { alert('Error loading rule data.'); }
    }, 'json');
  }

  function confirmDeleteRule(ruleId, ruleName) {
    $('#deleteRuleId').val(ruleId);
    $('#deleteRuleName').text(ruleName);
    new bootstrap.Modal(document.getElementById('deleteRuleModal')).show();
  }

  function toggleRule(ruleId) {
    $('#toggleRuleId').val(ruleId);
    document.getElementById('toggleRuleForm').submit();
  }

  function reorderRule(ruleId, direction) {
    $('#reorderRuleId').val(ruleId);
    $('#reorderDirection').val(direction);
    document.getElementById('reorderRuleForm').submit();
  }
</script>

</html>
