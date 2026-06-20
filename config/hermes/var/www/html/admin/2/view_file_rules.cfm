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
  <title>Hermes SEG | File Rules</title>

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
            <h1 class="m-0">File Rules</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item">Content Checks</li>
              <li class="breadcrumb-item active">File Rules</li>
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
<cfif StructKeyExists(form, "action")>
  <cfif form.action is not ""><cfset action = form.action></cfif>
</cfif>

<!--- GET DATA --->
<cfinclude template="./inc/get_file_rules.cfm">

<!--- ===================== --->
<!--- ACTION: ADD RULE --->
<!--- ===================== --->
<cfif action is "add_rule">
  <!--- Validate rule name --->
  <cfif NOT StructKeyExists(form, "rule_name") OR trim(form.rule_name) is "">
    <cfset session.m = 20>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <cfset theRuleName = trim(form.rule_name)>

  <!--- Rule name must only contain letters, numbers, dashes, underscores --->
  <cfif REFind("[^_a-zA-Z0-9-]", theRuleName) GT 0>
    <cfset session.m = 21>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicate rule name --->
  <cfquery name="checkDupRule" datasource="hermes">
    SELECT COUNT(*) as cnt FROM file_rule_components
    WHERE rule_name = <cfqueryparam value="#theRuleName#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkDupRule.cnt GT 0>
    <cfset session.m = 22>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Must have at least one file type selected --->
  <cfif NOT StructKeyExists(form, "file_ids") OR form.file_ids is "">
    <cfset session.m = 23>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Get next rule_id --->
  <cfquery name="getMaxRuleId" datasource="hermes">
    SELECT COALESCE(MAX(rule_id), 0) as maxid FROM file_rule_components
  </cfquery>
  <cfset nextRuleId = getMaxRuleId.maxid + 1>

  <!--- Determine rule type (ban/allow) --->
  <cfset ruleType = "ban">
  <cfif StructKeyExists(form, "rule_type") AND form.rule_type is "allow">
    <cfset ruleType = "allow">
  </cfif>

  <!--- Insert each selected file type as a component --->
  <cfset priority = 0>
  <cfloop list="#form.file_ids#" index="fileId">
    <cfif IsNumeric(fileId)>
      <cfset priority = priority + 1>
      <cfquery name="getFileDesc" datasource="hermes">
        SELECT description FROM files
        WHERE id = <cfqueryparam value="#fileId#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfif getFileDesc.recordCount GT 0>
        <cfquery datasource="hermes">
          INSERT INTO file_rule_components (file_id, rule_id, rule_name, description, type, priority, system)
          VALUES (
            <cfqueryparam value="#fileId#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#nextRuleId#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#theRuleName#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#getFileDesc.description#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#ruleType#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#priority#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="2" cfsqltype="cf_sql_integer">
          )
        </cfquery>
      </cfif>
    </cfif>
  </cfloop>

  <!--- Regenerate amavis config and reload --->
  <cftry>
    <cfinclude template="./inc/update_amavis_config_files.cfm">
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
      timeout="60" />
    <cfset session.m = 1>
    <cfcatch type="any">
      <cfset session.m = 10>
    </cfcatch>
  </cftry>
  <cflocation url="view_file_rules.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: EDIT RULE --->
<!--- ===================== --->
<cfif action is "edit_rule">
  <cfif NOT StructKeyExists(form, "edit_rule_id") OR NOT IsNumeric(form.edit_rule_id)>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Check that this is a custom rule (system=2), not a system rule --->
  <cfquery name="checkEditSystem" datasource="hermes">
    SELECT DISTINCT system FROM file_rule_components
    WHERE rule_id = <cfqueryparam value="#form.edit_rule_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif checkEditSystem.recordCount GT 0 AND checkEditSystem.system is "1">
    <cfset session.m = 24>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Validate rule name --->
  <cfif NOT StructKeyExists(form, "edit_rule_name") OR trim(form.edit_rule_name) is "">
    <cfset session.m = 20>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <cfset theRuleName = trim(form.edit_rule_name)>

  <cfif REFind("[^_a-zA-Z0-9-]", theRuleName) GT 0>
    <cfset session.m = 21>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicate rule name (excluding current rule) --->
  <cfquery name="checkDupEditRule" datasource="hermes">
    SELECT COUNT(*) as cnt FROM file_rule_components
    WHERE rule_name = <cfqueryparam value="#theRuleName#" cfsqltype="cf_sql_varchar">
    AND rule_id <> <cfqueryparam value="#form.edit_rule_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif checkDupEditRule.cnt GT 0>
    <cfset session.m = 22>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Must have at least one file type selected --->
  <cfif NOT StructKeyExists(form, "edit_file_ids") OR form.edit_file_ids is "">
    <cfset session.m = 23>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Determine rule type --->
  <cfset ruleType = "ban">
  <cfif StructKeyExists(form, "edit_rule_type") AND form.edit_rule_type is "allow">
    <cfset ruleType = "allow">
  </cfif>

  <!--- Update policy table if rule name changed --->
  <cfquery name="getOldRuleName" datasource="hermes">
    SELECT DISTINCT rule_name FROM file_rule_components
    WHERE rule_id = <cfqueryparam value="#form.edit_rule_id#" cfsqltype="cf_sql_integer">
    LIMIT 1
  </cfquery>
  <cfif getOldRuleName.recordCount GT 0 AND getOldRuleName.rule_name is not theRuleName>
    <cfquery datasource="hermes">
      UPDATE policy SET banned_rulenames = <cfqueryparam value="#theRuleName#" cfsqltype="cf_sql_varchar">
      WHERE banned_rulenames = <cfqueryparam value="#getOldRuleName.rule_name#" cfsqltype="cf_sql_varchar">
    </cfquery>
  </cfif>

  <!--- Delete existing components for this rule --->
  <cfquery datasource="hermes">
    DELETE FROM file_rule_components
    WHERE rule_id = <cfqueryparam value="#form.edit_rule_id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Re-insert components --->
  <cfset priority = 0>
  <cfloop list="#form.edit_file_ids#" index="fileId">
    <cfif IsNumeric(fileId)>
      <cfset priority = priority + 1>
      <cfquery name="getFileDescEdit" datasource="hermes">
        SELECT description FROM files
        WHERE id = <cfqueryparam value="#fileId#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfif getFileDescEdit.recordCount GT 0>
        <cfquery datasource="hermes">
          INSERT INTO file_rule_components (file_id, rule_id, rule_name, description, type, priority, system)
          VALUES (
            <cfqueryparam value="#fileId#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#form.edit_rule_id#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#theRuleName#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#getFileDescEdit.description#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#ruleType#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#priority#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="2" cfsqltype="cf_sql_integer">
          )
        </cfquery>
      </cfif>
    </cfif>
  </cfloop>

  <!--- Regenerate amavis config and reload --->
  <cftry>
    <cfinclude template="./inc/update_amavis_config_files.cfm">
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
      timeout="60" />
    <cfset session.m = 2>
    <cfcatch type="any">
      <cfset session.m = 10>
    </cfcatch>
  </cftry>
  <cflocation url="view_file_rules.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: DELETE RULE --->
<!--- ===================== --->
<cfif action is "delete_rule">
  <cfif NOT StructKeyExists(form, "delete_rule_id") OR NOT IsNumeric(form.delete_rule_id)>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Cannot delete system rules --->
  <cfquery name="checkDelSystem" datasource="hermes">
    SELECT DISTINCT system FROM file_rule_components
    WHERE rule_id = <cfqueryparam value="#form.delete_rule_id#" cfsqltype="cf_sql_integer">
  </cfquery>
  <cfif checkDelSystem.recordCount GT 0 AND checkDelSystem.system is "1">
    <cfset session.m = 24>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Cannot delete a rule that is assigned to a policy --->
  <cfquery name="getDelRuleName" datasource="hermes">
    SELECT DISTINCT rule_name FROM file_rule_components
    WHERE rule_id = <cfqueryparam value="#form.delete_rule_id#" cfsqltype="cf_sql_integer">
    LIMIT 1
  </cfquery>
  <cfif getDelRuleName.recordCount GT 0>
    <cfquery name="checkAssigned" datasource="hermes">
      SELECT policy_name FROM policy
      WHERE banned_rulenames = <cfqueryparam value="#getDelRuleName.rule_name#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif checkAssigned.recordCount GT 0>
      <cfset session.m = 25>
      <cfset session.deleteAssignedPolicies = ValueList(checkAssigned.policy_name, ", ")>
      <cflocation url="view_file_rules.cfm" addtoken="no">
    </cfif>
  </cfif>

  <!--- Delete from file_rules table --->
  <cfquery datasource="hermes">
    DELETE FROM file_rules
    WHERE rule_id = <cfqueryparam value="#form.delete_rule_id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Delete from file_rule_components --->
  <cfquery datasource="hermes">
    DELETE FROM file_rule_components
    WHERE rule_id = <cfqueryparam value="#form.delete_rule_id#" cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Regenerate amavis config and reload --->
  <cftry>
    <cfinclude template="./inc/update_amavis_config_files.cfm">
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
      timeout="60" />
    <cfset session.m = 3>
    <cfcatch type="any">
      <cfset session.m = 10>
    </cfcatch>
  </cftry>
  <cflocation url="view_file_rules.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: COPY RULE --->
<!--- ===================== --->
<cfif action is "copy_rule">
  <cfif NOT StructKeyExists(form, "copy_rule_id") OR NOT IsNumeric(form.copy_rule_id)>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <cfif NOT StructKeyExists(form, "copy_rule_name") OR trim(form.copy_rule_name) is "">
    <cfset session.m = 20>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <cfset theCopyName = trim(form.copy_rule_name)>

  <cfif REFind("[^_a-zA-Z0-9-]", theCopyName) GT 0>
    <cfset session.m = 21>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicate --->
  <cfquery name="checkCopyDup" datasource="hermes">
    SELECT COUNT(*) as cnt FROM file_rule_components
    WHERE rule_name = <cfqueryparam value="#theCopyName#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkCopyDup.cnt GT 0>
    <cfset session.m = 22>
    <cflocation url="view_file_rules.cfm" addtoken="no">
  </cfif>

  <!--- Get next rule_id --->
  <cfquery name="getMaxCopyId" datasource="hermes">
    SELECT COALESCE(MAX(rule_id), 0) as maxid FROM file_rule_components
  </cfquery>
  <cfset nextCopyId = getMaxCopyId.maxid + 1>

  <!--- Copy components from source rule --->
  <cfquery name="getSourceComponents" datasource="hermes">
    SELECT file_id, description, type, priority
    FROM file_rule_components
    WHERE rule_id = <cfqueryparam value="#form.copy_rule_id#" cfsqltype="cf_sql_integer">
    ORDER BY priority ASC
  </cfquery>

  <cfloop query="getSourceComponents">
    <cfquery datasource="hermes">
      INSERT INTO file_rule_components (file_id, rule_id, rule_name, description, type, priority, system)
      VALUES (
        <cfqueryparam value="#file_id#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#nextCopyId#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#theCopyName#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#description#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#type#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#priority#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="2" cfsqltype="cf_sql_integer">
      )
    </cfquery>
  </cfloop>

  <!--- Regenerate amavis config and reload --->
  <cftry>
    <cfinclude template="./inc/update_amavis_config_files.cfm">
    <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
      timeout="60" />
    <cfset session.m = 4>
    <cfcatch type="any">
      <cfset session.m = 10>
    </cfcatch>
  </cftry>
  <cflocation url="view_file_rules.cfm" addtoken="no">
</cfif>

<!--- Refresh data after actions --->
<cfinclude template="./inc/get_file_rules.cfm">
<cfset session.m = "">

<!--- ALERTS --->
<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Rule Added</h4>
    <p>File rule created successfully. Please assign the rule to a policy under Content Checks &gt; SVF Policies.</p>
  </div>
</cfif>
<cfif m is 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Rule Updated</h4>
    <p>File rule updated and Amavis configuration reloaded.</p>
  </div>
</cfif>
<cfif m is 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Rule Deleted</h4>
    <p>File rule deleted and Amavis configuration reloaded.</p>
  </div>
</cfif>
<cfif m is 4>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Rule Copied</h4>
    <p>File rule copied successfully. Please assign the rule to a policy under Content Checks &gt; SVF Policies.</p>
  </div>
</cfif>
<cfif m is 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Configuration Error</h4>
    <p>An error occurred while updating the Amavis configuration.</p>
  </div>
</cfif>
<cfif m is 20>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4>
    <p>The rule name field cannot be empty.</p>
  </div>
</cfif>
<cfif m is 21>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4>
    <p>The rule name must only contain letters, numbers, dashes, and underscores. No other characters or spaces are allowed.</p>
  </div>
</cfif>
<cfif m is 22>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Duplicate Rule Name</h4>
    <p>A file rule with that name already exists. Please choose a different name.</p>
  </div>
</cfif>
<cfif m is 23>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> No File Types Selected</h4>
    <p>You must select at least one file type for the rule.</p>
  </div>
</cfif>
<cfif m is 24>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> System Rule</h4>
    <p>You cannot modify or delete a system file rule. Copy it to create an editable version.</p>
  </div>
</cfif>
<cfif m is 25>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Rule In Use</h4>
    <p>You cannot delete a file rule that is assigned to SVF Policy: <strong><cfif StructKeyExists(session, "deleteAssignedPolicies") AND session.deleteAssignedPolicies is not ""><cfoutput>#encodeForHTML(session.deleteAssignedPolicies)#</cfoutput><cfset session.deleteAssignedPolicies = ""><cfelse>Unknown</cfif></strong>. Remove the assignment first under Content Checks &gt; SVF Policies.</p>
  </div>
</cfif>

<!--- INFO CALLOUT --->
<div class="callout callout-info mb-4">
  <h5>About File Rules</h5>
  <p class="mb-0">
    File rules define which file types are banned or allowed in email attachments. Rules are processed top-down;
    once a match is found, the assigned action is taken. System rules cannot be modified or deleted, but you can
    copy them and customize the copy. After creating a rule, assign it to a policy under
    <strong>Content Checks &gt; SVF Policies</strong>.
  </p>
</div>

<!-- FILE RULES TABLE -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-file-shield"></i> File Rules</h3>
    <div class="card-tools">
      <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#addRuleModal">
        <i class="fas fa-plus"></i> Create Custom File Rule
      </button>
    </div>
  </div>
  <div class="card-body">
    <table id="fileRulesTable" class="table table-bordered table-hover table-striped">
      <thead>
        <tr>
          <th style="width: 25%">Rule Name</th>
          <th style="width: 10%">Type</th>
          <th style="width: 40%">File Types</th>
          <th style="width: 10%">System Rule</th>
          <th style="width: 15%">Actions</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="get_file_rules">
          <!--- Get components for this rule --->
          <cfquery name="getRuleComponents" datasource="hermes" dbtype="query">
            SELECT file_id, description, type, priority, file_category
            FROM get_all_rule_components
            WHERE rule_id = #rule_id#
            ORDER BY priority ASC
          </cfquery>
          <tr>
            <td>#encodeForHTML(rule_name)#</td>
            <td>
              <cfif getRuleComponents.recordCount GT 0>
                <cfset firstType = getRuleComponents.type[1]>
                <cfif firstType is "ban">
                  <span class="badge bg-danger">Ban</span>
                <cfelse>
                  <span class="badge bg-success">Allow</span>
                </cfif>
              </cfif>
            </td>
            <td>
              <cfset componentList = "">
              <cfloop query="getRuleComponents">
                <cfset componentList = ListAppend(componentList, encodeForHTML(description) & " (" & type & ")", "|")>
              </cfloop>
              <cfloop list="#componentList#" index="comp" delimiters="|">
                <span class="badge bg-secondary me-1 mb-1">#comp#</span>
              </cfloop>
            </td>
            <td class="text-center">
              <cfif system is "1">
                <span class="badge bg-info">Yes</span>
              <cfelse>
                <span class="badge bg-warning">No</span>
              </cfif>
            </td>
            <td>
              <!--- Copy button (always available) --->
              <button type="button" class="btn btn-sm btn-secondary" title="Copy Rule"
                onclick="openCopyModal('#rule_id#', '#encodeForJavaScript(rule_name)#');">
                <i class="fas fa-copy"></i>
              </button>
              <!--- View/Edit button --->
              <cfif system is "2">
                <button type="button" class="btn btn-sm btn-primary" title="Edit Rule"
                  onclick="openEditModal(#rule_id#);">
                  <i class="fas fa-edit"></i>
                </button>
                <!--- Delete button --->
                <button type="button" class="btn btn-sm btn-danger" title="Delete Rule"
                  onclick="confirmDelete('#rule_id#', '#encodeForJavaScript(rule_name)#');">
                  <i class="fas fa-trash"></i>
                </button>
              </cfif>
            </td>
          </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>

<!-- ADD RULE MODAL -->
<div class="modal fade" id="addRuleModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <form method="post" id="addRuleForm">
        <input type="hidden" name="action" value="add_rule">
        <input type="hidden" name="file_ids" id="add_file_ids" value="">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-plus-circle"></i> Create Custom File Rule</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="row mb-3">
            <div class="col-md-6">
              <label for="rule_name" class="form-label"><strong>Rule Name</strong></label>
              <input type="text" class="form-control" id="rule_name" name="rule_name" maxlength="50"
                placeholder="e.g. My_Custom_Rule" required
                pattern="[a-zA-Z0-9_-]+" title="Letters, numbers, dashes, and underscores only">
              <small class="text-muted">Letters, numbers, dashes, and underscores only. No spaces.</small>
            </div>
            <div class="col-md-6">
              <label class="form-label"><strong>Default Action</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="rule_type" id="type_ban" value="ban" checked>
                  <label class="form-check-label" for="type_ban"><i class="fas fa-ban text-danger"></i> Ban</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="rule_type" id="type_allow" value="allow">
                  <label class="form-check-label" for="type_allow"><i class="fas fa-check text-success"></i> Allow</label>
                </div>
              </div>
            </div>
          </div>

          <hr>
          <h6><strong>Select File Types</strong></h6>
          <p class="text-muted small">Select one or more file types to include in this rule. Use the category headers to select/deselect all in a group.</p>

          <div class="row">
            <!--- HIGH RISK FILE EXTENSIONS --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-danger h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input category-check" type="checkbox" id="cat_ext_high" data-category="ext_high">
                    <label class="form-check-label fw-bold text-danger" for="cat_ext_high">High Risk Extensions</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_ext_high">
                    <div class="form-check">
                      <input class="form-check-input file-check add-file-check ext_high" type="checkbox" value="#id#" id="add_f_#id#">
                      <label class="form-check-label small" for="add_f_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- HIGH RISK FILE TYPES --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-danger h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input category-check" type="checkbox" id="cat_file_high" data-category="file_high">
                    <label class="form-check-label fw-bold text-danger" for="cat_file_high">High Risk File Types</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_file_high">
                    <div class="form-check">
                      <input class="form-check-input file-check add-file-check file_high" type="checkbox" value="#id#" id="add_ff_#id#">
                      <label class="form-check-label small" for="add_ff_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- HIGH RISK MIME TYPES --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-danger h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input category-check" type="checkbox" id="cat_mime_high" data-category="mime_high">
                    <label class="form-check-label fw-bold text-danger" for="cat_mime_high">High Risk MIME Types</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_mime_high">
                    <div class="form-check">
                      <input class="form-check-input file-check add-file-check mime_high" type="checkbox" value="#id#" id="add_fm_#id#">
                      <label class="form-check-label small" for="add_fm_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- FILE EXTENSIONS --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-primary h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input category-check" type="checkbox" id="cat_ext" data-category="ext">
                    <label class="form-check-label fw-bold" for="cat_ext">File Extensions</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_ext">
                    <div class="form-check">
                      <input class="form-check-input file-check add-file-check ext" type="checkbox" value="#id#" id="add_fe_#id#">
                      <label class="form-check-label small" for="add_fe_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- FILE TYPES --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-primary h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input category-check" type="checkbox" id="cat_file" data-category="file">
                    <label class="form-check-label fw-bold" for="cat_file">File Types</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_file">
                    <div class="form-check">
                      <input class="form-check-input file-check add-file-check file" type="checkbox" value="#id#" id="add_ft_#id#">
                      <label class="form-check-label small" for="add_ft_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- MIME TYPES --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-primary h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input category-check" type="checkbox" id="cat_mime" data-category="mime">
                    <label class="form-check-label fw-bold" for="cat_mime">MIME Types</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_mime">
                    <div class="form-check">
                      <input class="form-check-input file-check add-file-check mime" type="checkbox" value="#id#" id="add_mi_#id#">
                      <label class="form-check-label small" for="add_mi_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- OTHER TYPES --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-secondary h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input category-check" type="checkbox" id="cat_other" data-category="other">
                    <label class="form-check-label fw-bold" for="cat_other">Other Types</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_other">
                    <div class="form-check">
                      <input class="form-check-input file-check add-file-check other" type="checkbox" value="#id#" id="add_fo_#id#">
                      <label class="form-check-label small" for="add_fo_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- CUSTOM EXPRESSIONS --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-warning h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input category-check" type="checkbox" id="cat_custom" data-category="custom">
                    <label class="form-check-label fw-bold" for="cat_custom">Custom Expressions</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_custom_expr">
                    <div class="form-check">
                      <input class="form-check-input file-check add-file-check custom" type="checkbox" value="#id#" id="add_fc_#id#">
                      <label class="form-check-label small" for="add_fc_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="collectAddFileIds();this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Creating...';this.form.submit();">
            <i class="fas fa-plus"></i> Create Rule
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- EDIT RULE MODAL -->
<div class="modal fade" id="editRuleModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <form method="post" id="editRuleForm">
        <input type="hidden" name="action" value="edit_rule">
        <input type="hidden" name="edit_rule_id" id="edit_rule_id" value="">
        <input type="hidden" name="edit_file_ids" id="edit_file_ids" value="">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit"></i> Edit File Rule</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="row mb-3">
            <div class="col-md-6">
              <label for="edit_rule_name" class="form-label"><strong>Rule Name</strong></label>
              <input type="text" class="form-control" id="edit_rule_name" name="edit_rule_name" maxlength="50"
                required pattern="[a-zA-Z0-9_-]+" title="Letters, numbers, dashes, and underscores only">
            </div>
            <div class="col-md-6">
              <label class="form-label"><strong>Default Action</strong></label>
              <div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_rule_type" id="edit_type_ban" value="ban" checked>
                  <label class="form-check-label" for="edit_type_ban"><i class="fas fa-ban text-danger"></i> Ban</label>
                </div>
                <div class="form-check form-check-inline">
                  <input class="form-check-input" type="radio" name="edit_rule_type" id="edit_type_allow" value="allow">
                  <label class="form-check-label" for="edit_type_allow"><i class="fas fa-check text-success"></i> Allow</label>
                </div>
              </div>
            </div>
          </div>

          <hr>
          <h6><strong>Select File Types</strong></h6>

          <div class="row">
            <!--- HIGH RISK FILE EXTENSIONS --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-danger h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input edit-category-check" type="checkbox" id="edit_cat_ext_high" data-category="edit_ext_high">
                    <label class="form-check-label fw-bold text-danger" for="edit_cat_ext_high">High Risk Extensions</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_ext_high">
                    <div class="form-check">
                      <input class="form-check-input file-check edit-file-check edit_ext_high" type="checkbox" value="#id#" id="edit_f_#id#">
                      <label class="form-check-label small" for="edit_f_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- HIGH RISK FILE TYPES --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-danger h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input edit-category-check" type="checkbox" id="edit_cat_file_high" data-category="edit_file_high">
                    <label class="form-check-label fw-bold text-danger" for="edit_cat_file_high">High Risk File Types</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_file_high">
                    <div class="form-check">
                      <input class="form-check-input file-check edit-file-check edit_file_high" type="checkbox" value="#id#" id="edit_ff_#id#">
                      <label class="form-check-label small" for="edit_ff_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- HIGH RISK MIME TYPES --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-danger h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input edit-category-check" type="checkbox" id="edit_cat_mime_high" data-category="edit_mime_high">
                    <label class="form-check-label fw-bold text-danger" for="edit_cat_mime_high">High Risk MIME Types</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_mime_high">
                    <div class="form-check">
                      <input class="form-check-input file-check edit-file-check edit_mime_high" type="checkbox" value="#id#" id="edit_fm_#id#">
                      <label class="form-check-label small" for="edit_fm_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- FILE EXTENSIONS --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-primary h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input edit-category-check" type="checkbox" id="edit_cat_ext" data-category="edit_ext">
                    <label class="form-check-label fw-bold" for="edit_cat_ext">File Extensions</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_ext">
                    <div class="form-check">
                      <input class="form-check-input file-check edit-file-check edit_ext" type="checkbox" value="#id#" id="edit_fe_#id#">
                      <label class="form-check-label small" for="edit_fe_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- FILE TYPES --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-primary h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input edit-category-check" type="checkbox" id="edit_cat_file" data-category="edit_file">
                    <label class="form-check-label fw-bold" for="edit_cat_file">File Types</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_file">
                    <div class="form-check">
                      <input class="form-check-input file-check edit-file-check edit_file" type="checkbox" value="#id#" id="edit_ft_#id#">
                      <label class="form-check-label small" for="edit_ft_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- MIME TYPES --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-primary h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input edit-category-check" type="checkbox" id="edit_cat_mime" data-category="edit_mime">
                    <label class="form-check-label fw-bold" for="edit_cat_mime">MIME Types</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_mime">
                    <div class="form-check">
                      <input class="form-check-input file-check edit-file-check edit_mime" type="checkbox" value="#id#" id="edit_mi_#id#">
                      <label class="form-check-label small" for="edit_mi_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- OTHER TYPES --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-secondary h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input edit-category-check" type="checkbox" id="edit_cat_other" data-category="edit_other">
                    <label class="form-check-label fw-bold" for="edit_cat_other">Other Types</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_other">
                    <div class="form-check">
                      <input class="form-check-input file-check edit-file-check edit_other" type="checkbox" value="#id#" id="edit_fo_#id#">
                      <label class="form-check-label small" for="edit_fo_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>

            <!--- CUSTOM EXPRESSIONS --->
            <div class="col-md-6 col-lg-4 mb-3">
              <div class="card card-outline card-warning h-100">
                <div class="card-header py-2">
                  <div class="form-check">
                    <input class="form-check-input edit-category-check" type="checkbox" id="edit_cat_custom" data-category="edit_custom">
                    <label class="form-check-label fw-bold" for="edit_cat_custom">Custom Expressions</label>
                  </div>
                </div>
                <div class="card-body py-2" style="max-height: 200px; overflow-y: auto;">
                  <cfoutput query="get_files_custom_expr">
                    <div class="form-check">
                      <input class="form-check-input file-check edit-file-check edit_custom" type="checkbox" value="#id#" id="edit_fc_#id#">
                      <label class="form-check-label small" for="edit_fc_#id#">#encodeForHTML(description)#</label>
                    </div>
                  </cfoutput>
                </div>
              </div>
            </div>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="collectEditFileIds();this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
            <i class="fas fa-save"></i> Save Changes
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- COPY RULE MODAL -->
<div class="modal fade" id="copyRuleModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="copy_rule">
        <input type="hidden" name="copy_rule_id" id="copy_rule_id" value="">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-copy"></i> Copy File Rule</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Copying rule: <strong id="copy_source_name"></strong></p>
          <div class="mb-3">
            <label for="copy_rule_name" class="form-label"><strong>New Rule Name</strong></label>
            <input type="text" class="form-control" id="copy_rule_name" name="copy_rule_name" maxlength="50"
              required pattern="[a-zA-Z0-9_-]+" title="Letters, numbers, dashes, and underscores only">
            <small class="text-muted">Letters, numbers, dashes, and underscores only.</small>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Copying...';this.form.submit();">
            <i class="fas fa-copy"></i> Copy Rule
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- DELETE FORM -->
<form id="deleteForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="delete_rule">
  <input type="hidden" name="delete_rule_id" id="delete_rule_id" value="">
</form>

<!--- Build rule components data for JavaScript edit modal --->
<script>
var ruleComponents = {};
<cfoutput query="get_file_rules">
ruleComponents[#rule_id#] = {
  name: '#encodeForJavaScript(rule_name)#',
  fileIds: [<cfquery name="rcJS" datasource="hermes" dbtype="query">SELECT file_id, type FROM get_all_rule_components WHERE rule_id = #rule_id# ORDER BY priority ASC</cfquery><cfloop query="rcJS">#file_id#<cfif currentRow LT recordCount>,</cfif></cfloop>],
  type: '<cfquery name="rcType" datasource="hermes" dbtype="query">SELECT type FROM get_all_rule_components WHERE rule_id = #rule_id#</cfquery>#encodeForJavaScript(rcType.type)#'
};
</cfoutput>

$(document).ready(function() {
  $('#fileRulesTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[3, 'asc'], [0, 'asc']],
    columnDefs: [
      { orderable: false, targets: [4] },
      { searchable: false, targets: [4] }
    ]
  });

  // Category select-all for Add modal
  $('.category-check').on('change', function() {
    var cat = $(this).data('category');
    $('.add-file-check.' + cat).prop('checked', this.checked);
  });

  // Category select-all for Edit modal
  $('.edit-category-check').on('change', function() {
    var cat = $(this).data('category');
    $('.edit-file-check.' + cat).prop('checked', this.checked);
  });
});

function collectAddFileIds() {
  var ids = [];
  $('.add-file-check:checked').each(function() { ids.push(this.value); });
  document.getElementById('add_file_ids').value = ids.join(',');
}

function collectEditFileIds() {
  var ids = [];
  $('.edit-file-check:checked').each(function() { ids.push(this.value); });
  document.getElementById('edit_file_ids').value = ids.join(',');
}

function openEditModal(ruleId) {
  var rule = ruleComponents[ruleId];
  if (!rule) return;

  document.getElementById('edit_rule_id').value = ruleId;
  document.getElementById('edit_rule_name').value = rule.name;

  // Set type radio
  if (rule.type === 'allow') {
    document.getElementById('edit_type_allow').checked = true;
  } else {
    document.getElementById('edit_type_ban').checked = true;
  }

  // Uncheck all edit checkboxes first
  $('.edit-file-check').prop('checked', false);
  $('.edit-category-check').prop('checked', false);

  // Check the file types that belong to this rule
  rule.fileIds.forEach(function(fid) {
    $('#edit_f_' + fid + ', #edit_ff_' + fid + ', #edit_fm_' + fid + ', #edit_fe_' + fid + ', #edit_ft_' + fid + ', #edit_mi_' + fid + ', #edit_fo_' + fid + ', #edit_fc_' + fid).prop('checked', true);
  });

  new bootstrap.Modal(document.getElementById('editRuleModal')).show();
}

function openCopyModal(ruleId, ruleName) {
  document.getElementById('copy_rule_id').value = ruleId;
  document.getElementById('copy_source_name').textContent = ruleName;
  document.getElementById('copy_rule_name').value = ruleName + '_copy';
  new bootstrap.Modal(document.getElementById('copyRuleModal')).show();
}

function confirmDelete(ruleId, ruleName) {
  if (!confirm('Delete file rule "' + ruleName + '"? This cannot be undone.')) return;
  document.getElementById('delete_rule_id').value = ruleId;
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
