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

<!--- ACTION HANDLERS --->
<cfif action EQ "add_rule" OR action EQ "edit_rule" OR action EQ "delete_rule" OR action EQ "toggle_rule" OR action EQ "reorder_rule">
  <cfinclude template="./inc/sieve_rule_actions.cfm">
</cfif>

<!--- SUCCESS / ERROR MESSAGES --->
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
    Condition value cannot be blank.
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Action value is required (e.g., folder name for File to Folder).
  </div>
<cfelseif m EQ 22>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    System rules cannot be deleted.
  </div>
</cfif>

<!--- HELP CALLOUT --->
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About Global Mailbox Rules</h5>
  <p class="mb-1">Global mailbox rules run <strong>before</strong> any user's personal rules on every incoming message delivered to a mailbox. They are mandatory and cannot be overridden by users.</p>
  <p class="mb-0"><small>System rules (marked with <span class="badge bg-primary">System</span>) cannot be deleted but can be enabled or disabled. Rules are processed in order from top to bottom.</small></p>
</div>

<!--- GET GLOBAL RULES --->
<cfquery name="getRules" datasource="hermes">
    SELECT id, rule_name, rule_order, enabled, is_system,
           condition_field, condition_type, condition_value,
           action_type, action_value
    FROM sieve_rules
    WHERE scope = 'global'
    ORDER BY rule_order ASC
</cfquery>

<!--- ADD RULE BUTTON --->
<div class="mb-3">
  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addRuleModal"><i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Add Rule</button>
</div>

<!--- RULES TABLE --->
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
          <th>Condition</th>
          <th>Action</th>
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
            <code>
            <cfif condition_field EQ "header">
              Header #HTMLEditFormat(condition_value)#
              <cfif condition_type EQ "is"> is exactly
              <cfelseif condition_type EQ "contains"> contains
              <cfelseif condition_type EQ "matches"> matches
              <cfelseif condition_type EQ "not_contains"> does not contain
              </cfif>
            <cfelseif condition_field EQ "subject">
              Subject
              <cfif condition_type EQ "is"> is exactly
              <cfelseif condition_type EQ "contains"> contains
              <cfelseif condition_type EQ "matches"> matches
              <cfelseif condition_type EQ "not_contains"> does not contain
              </cfif>
              "#HTMLEditFormat(condition_value)#"
            <cfelseif condition_field EQ "from">
              From
              <cfif condition_type EQ "is"> is exactly
              <cfelseif condition_type EQ "contains"> contains
              <cfelseif condition_type EQ "matches"> matches
              <cfelseif condition_type EQ "not_contains"> does not contain
              </cfif>
              "#HTMLEditFormat(condition_value)#"
            <cfelseif condition_field EQ "to">
              To
              <cfif condition_type EQ "is"> is exactly
              <cfelseif condition_type EQ "contains"> contains
              <cfelseif condition_type EQ "matches"> matches
              <cfelseif condition_type EQ "not_contains"> does not contain
              </cfif>
              "#HTMLEditFormat(condition_value)#"
            <cfelseif condition_field EQ "cc">
              Cc
              <cfif condition_type EQ "is"> is exactly
              <cfelseif condition_type EQ "contains"> contains
              <cfelseif condition_type EQ "matches"> matches
              <cfelseif condition_type EQ "not_contains"> does not contain
              </cfif>
              "#HTMLEditFormat(condition_value)#"
            <cfelseif condition_field EQ "size">
              Size is <cfif condition_type EQ "over">over<cfelse>under</cfif> #HTMLEditFormat(condition_value)#
            <cfelseif condition_field EQ "all">
              All messages
            </cfif>
            </code>
          </td>
          <td>
            <cfif action_type EQ "fileinto">
              <span class="badge bg-info">File to</span> #HTMLEditFormat(action_value)#
            <cfelseif action_type EQ "discard">
              <span class="badge bg-dark">Discard</span>
            <cfelseif action_type EQ "keep">
              <span class="badge bg-success">Keep (deliver)</span>
            <cfelseif action_type EQ "redirect">
              <span class="badge bg-warning text-dark">Redirect to</span> #HTMLEditFormat(action_value)#
            <cfelseif action_type EQ "flag_seen">
              <span class="badge bg-secondary">Mark as read</span>
            <cfelseif action_type EQ "reject">
              <span class="badge bg-danger">Reject</span> #HTMLEditFormat(action_value)#
            </cfif>
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

<!--- ================================================================
     ADD RULE MODAL
     ================================================================ --->
<div class="modal fade" id="addRuleModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" action="view_sieve_rules.cfm">
        <input type="hidden" name="action" value="add_rule">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Add Sieve Rule</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <div class="form-group mb-3">
            <label><strong>Rule Name</strong></label>
            <input type="text" class="form-control" name="rule_name" placeholder="e.g., Move newsletters to folder" required>
          </div>

          <div class="card mb-3">
            <div class="card-header"><strong>IF</strong> (Condition)</div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-3 mb-2">
                  <label>Field</label>
                  <select class="form-control" name="condition_field" id="addCondField">
                    <option value="subject">Subject</option>
                    <option value="from">From</option>
                    <option value="to">To</option>
                    <option value="cc">Cc</option>
                    <option value="header">Custom Header</option>
                    <option value="size">Size</option>
                    <option value="all">All Messages</option>
                  </select>
                </div>
                <div class="col-md-3 mb-2" id="addCondTypeGroup">
                  <label>Match</label>
                  <select class="form-control" name="condition_type" id="addCondType">
                    <option value="contains">Contains</option>
                    <option value="is">Is exactly</option>
                    <option value="matches">Matches pattern</option>
                    <option value="not_contains">Does not contain</option>
                  </select>
                </div>
                <div class="col-md-6 mb-2" id="addCondValueGroup">
                  <label>Value</label>
                  <input type="text" class="form-control" name="condition_value" id="addCondValue" placeholder="e.g., newsletter">
                  <small class="text-muted" id="addCondHint">Text to match in the subject</small>
                </div>
              </div>
            </div>
          </div>

          <div class="card mb-3">
            <div class="card-header"><strong>THEN</strong> (Action)</div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-4 mb-2">
                  <label>Action</label>
                  <select class="form-control" name="action_type" id="addActionType">
                    <option value="fileinto">File to folder</option>
                    <option value="discard">Discard (delete silently)</option>
                    <option value="redirect">Redirect to address</option>
                    <option value="keep">Keep (deliver normally)</option>
                    <option value="flag_seen">Mark as read</option>
                    <option value="reject">Reject with message</option>
                  </select>
                </div>
                <div class="col-md-8 mb-2" id="addActionValueGroup">
                  <label id="addActionValueLabel">Folder name</label>
                  <input type="text" class="form-control" name="action_value" id="addActionValue" placeholder="e.g., Newsletters">
                </div>
              </div>
            </div>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Create Rule</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ================================================================
     EDIT RULE MODAL
     ================================================================ --->
<div class="modal fade" id="editRuleModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" action="view_sieve_rules.cfm">
        <input type="hidden" name="action" value="edit_rule">
        <input type="hidden" name="rule_id" id="editRuleId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Sieve Rule</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <div class="form-group mb-3">
            <label><strong>Rule Name</strong></label>
            <input type="text" class="form-control" name="edit_rule_name" id="editRuleName" required>
          </div>

          <div class="card mb-3">
            <div class="card-header"><strong>IF</strong> (Condition)</div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-3 mb-2">
                  <label>Field</label>
                  <select class="form-control" name="edit_condition_field" id="editCondField">
                    <option value="subject">Subject</option>
                    <option value="from">From</option>
                    <option value="to">To</option>
                    <option value="cc">Cc</option>
                    <option value="header">Custom Header</option>
                    <option value="size">Size</option>
                    <option value="all">All Messages</option>
                  </select>
                </div>
                <div class="col-md-3 mb-2" id="editCondTypeGroup">
                  <label>Match</label>
                  <select class="form-control" name="edit_condition_type" id="editCondType">
                    <option value="contains">Contains</option>
                    <option value="is">Is exactly</option>
                    <option value="matches">Matches pattern</option>
                    <option value="not_contains">Does not contain</option>
                  </select>
                </div>
                <div class="col-md-6 mb-2" id="editCondValueGroup">
                  <label>Value</label>
                  <input type="text" class="form-control" name="edit_condition_value" id="editCondValue">
                </div>
              </div>
            </div>
          </div>

          <div class="card mb-3">
            <div class="card-header"><strong>THEN</strong> (Action)</div>
            <div class="card-body">
              <div class="row">
                <div class="col-md-4 mb-2">
                  <label>Action</label>
                  <select class="form-control" name="edit_action_type" id="editActionType">
                    <option value="fileinto">File to folder</option>
                    <option value="discard">Discard (delete silently)</option>
                    <option value="redirect">Redirect to address</option>
                    <option value="keep">Keep (deliver normally)</option>
                    <option value="flag_seen">Mark as read</option>
                    <option value="reject">Reject with message</option>
                  </select>
                </div>
                <div class="col-md-8 mb-2" id="editActionValueGroup">
                  <label id="editActionValueLabel">Folder name</label>
                  <input type="text" class="form-control" name="edit_action_value" id="editActionValue">
                </div>
              </div>
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

<!--- HIDDEN FORMS FOR TOGGLE AND REORDER ACTIONS --->
<form id="toggleRuleForm" method="post" action="view_sieve_rules.cfm" style="display:none;">
  <input type="hidden" name="action" value="toggle_rule">
  <input type="hidden" name="toggle_rule_id" id="toggleRuleId">
</form>
<form id="reorderRuleForm" method="post" action="view_sieve_rules.cfm" style="display:none;">
  <input type="hidden" name="action" value="reorder_rule">
  <input type="hidden" name="reorder_rule_id" id="reorderRuleId">
  <input type="hidden" name="reorder_direction" id="reorderDirection">
</form>

<!--- ================================================================
     DELETE CONFIRMATION MODAL
     ================================================================ --->
<div class="modal fade" id="deleteRuleModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_sieve_rules.cfm">
        <input type="hidden" name="action" value="delete_rule">
        <input type="hidden" name="delete_rule_id" id="deleteRuleId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-trash me-2 text-danger"></i>Delete Sieve Rule</h5>
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
  $(document).ready(function() {
    $('#sieveRulesTable').DataTable({
      "order": [[0, "asc"]],
      "pageLength": 25,
      "paging": false,
      "searching": false,
      "info": false,
      "columnDefs": [
        { "orderable": false, "targets": [1] }
      ]
    });
  });

  // Helper: update condition UI based on field selection
  function updateConditionUI(prefix) {
    var field = $('#' + prefix + 'CondField').val();
    if (field === 'all') {
      $('#' + prefix + 'CondTypeGroup').hide();
      $('#' + prefix + 'CondValueGroup').hide();
    } else if (field === 'size') {
      $('#' + prefix + 'CondTypeGroup').show().find('select').html(
        '<option value="over">Is over</option><option value="under">Is under</option>'
      );
      $('#' + prefix + 'CondValueGroup').show();
      $('#' + prefix + 'CondValue').attr('placeholder', 'e.g., 10M');
      if (prefix === 'add') $('#addCondHint').text('Size with unit: K, M, G');
    } else if (field === 'header') {
      $('#' + prefix + 'CondTypeGroup').show().find('select').html(
        '<option value="is">Is exactly</option><option value="contains">Contains</option><option value="matches">Matches pattern</option><option value="not_contains">Does not contain</option>'
      );
      $('#' + prefix + 'CondValueGroup').show();
      $('#' + prefix + 'CondValue').attr('placeholder', 'e.g., X-Spam-Flag: YES');
      if (prefix === 'add') $('#addCondHint').text('Format: Header-Name: value');
    } else {
      $('#' + prefix + 'CondTypeGroup').show().find('select').html(
        '<option value="contains">Contains</option><option value="is">Is exactly</option><option value="matches">Matches pattern</option><option value="not_contains">Does not contain</option>'
      );
      $('#' + prefix + 'CondValueGroup').show();
      $('#' + prefix + 'CondValue').attr('placeholder', 'e.g., newsletter');
      if (prefix === 'add') $('#addCondHint').text('Text to match in the ' + field);
    }
  }

  // Helper: update action UI based on action selection
  function updateActionUI(prefix) {
    var action = $('#' + prefix + 'ActionType').val();
    if (action === 'fileinto') {
      $('#' + prefix + 'ActionValueGroup').show();
      $('#' + prefix + 'ActionValueLabel').text('Folder name');
      $('#' + prefix + 'ActionValue').attr('placeholder', 'e.g., Newsletters');
    } else if (action === 'redirect') {
      $('#' + prefix + 'ActionValueGroup').show();
      $('#' + prefix + 'ActionValueLabel').text('Email address');
      $('#' + prefix + 'ActionValue').attr('placeholder', 'e.g., user@domain.com');
    } else if (action === 'reject') {
      $('#' + prefix + 'ActionValueGroup').show();
      $('#' + prefix + 'ActionValueLabel').text('Rejection message');
      $('#' + prefix + 'ActionValue').attr('placeholder', 'e.g., This mailbox does not accept mail');
    } else {
      $('#' + prefix + 'ActionValueGroup').hide();
    }
  }

  // Wire up add modal field changes
  $('#addCondField').on('change', function() { updateConditionUI('add'); });
  $('#addActionType').on('change', function() { updateActionUI('add'); });

  // Wire up edit modal field changes
  $('#editCondField').on('change', function() { updateConditionUI('edit'); });
  $('#editActionType').on('change', function() { updateActionUI('edit'); });

  // Load edit modal
  function loadEditRuleModal(ruleId) {
    $.post('./inc/get_sieve_rule_json.cfm', { id: ruleId }, function(data) {
      try {
        var r = (typeof data === 'string') ? JSON.parse(data) : data;
        if (r.error) { alert('Error: ' + r.error); return; }
        $('#editRuleId').val(r.id);
        $('#editRuleName').val(r.rule_name);
        $('#editCondField').val(r.condition_field);
        updateConditionUI('edit');
        $('#editCondType').val(r.condition_type);
        $('#editCondValue').val(r.condition_value);
        $('#editActionType').val(r.action_type);
        updateActionUI('edit');
        $('#editActionValue').val(r.action_value);
        new bootstrap.Modal(document.getElementById('editRuleModal')).show();
      } catch(e) { alert('Error loading rule data.'); }
    });
  }

  // Confirm delete
  function confirmDeleteRule(ruleId, ruleName) {
    $('#deleteRuleId').val(ruleId);
    $('#deleteRuleName').text(ruleName);
    new bootstrap.Modal(document.getElementById('deleteRuleModal')).show();
  }

  // Toggle rule via hidden form
  function toggleRule(ruleId) {
    $('#toggleRuleId').val(ruleId);
    document.getElementById('toggleRuleForm').submit();
  }

  // Reorder rule (up/down)
  function reorderRule(ruleId, direction) {
    $('#reorderRuleId').val(ruleId);
    $('#reorderDirection').val(direction);
    document.getElementById('reorderRuleForm').submit();
  }
</script>

</html>
