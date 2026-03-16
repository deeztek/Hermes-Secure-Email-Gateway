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
  <title>Hermes SEG | Message Rules</title>

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
            <h1 class="m-0">Message Rules</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Message Rules</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m_rules")>
  <cfif session.m_rules is not ""><cfset m = session.m_rules></cfif>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(form, "action")>
  <cfif form.action is not ""><cfset action = form.action></cfif>
</cfif>

<!--- GET DATA --->
<cfinclude template="./inc/get_message_rules.cfm">

<!--- ===================== --->
<!--- ACTION: ADD RULE --->
<!--- ===================== --->
<cfif action is "add_rule">
  <cfset step = 0>

  <cfparam name="form.rule_name" default="">
  <cfparam name="form.rule_type" default="body">
  <cfparam name="form.rule_desc" default="">
  <cfparam name="form.header" default="">
  <cfparam name="form.regex" default="">
  <cfparam name="form.score" default="">

  <cfset rule_name = trim(form.rule_name)>
  <cfset rule_type = trim(form.rule_type)>
  <cfset rule_desc = trim(form.rule_desc)>
  <cfset header = trim(form.header)>
  <cfset regex = trim(form.regex)>
  <cfset score = trim(form.score)>

  <!--- Validate rule_name --->
  <cfif rule_name is "">
    <cfset session.m_rules = 10>
    <cflocation url="view_message_rules.cfm" addtoken="no">
  </cfif>
  <cfif REFind("[^_a-zA-Z0-9-]", rule_name) GT 0>
    <cfset session.m_rules = 11>
    <cflocation url="view_message_rules.cfm" addtoken="no">
  </cfif>

  <!--- Check for duplicate rule name --->
  <cfquery name="checkDupRule" datasource="hermes">
    SELECT COUNT(*) as cnt FROM message_rules
    WHERE rule_name = <cfqueryparam value="#rule_name#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkDupRule.cnt GT 0>
    <cfset session.m_rules = 12>
    <cflocation url="view_message_rules.cfm" addtoken="no">
  </cfif>

  <!--- Validate header field for header rule type --->
  <cfif rule_type is "header">
    <cfif header is "">
      <cfset session.m_rules = 13>
      <cflocation url="view_message_rules.cfm" addtoken="no">
    </cfif>
    <cfif REFind("[^_a-zA-Z0-9-]", header) GT 0>
      <cfset session.m_rules = 14>
      <cflocation url="view_message_rules.cfm" addtoken="no">
    </cfif>
  <cfelse>
    <cfset header = "">
  </cfif>

  <!--- Validate regex --->
  <cfif regex is "">
    <cfset session.m_rules = 15>
    <cflocation url="view_message_rules.cfm" addtoken="no">
  </cfif>

  <!--- Validate score --->
  <cfif score is "">
    <cfset session.m_rules = 16>
    <cflocation url="view_message_rules.cfm" addtoken="no">
  </cfif>
  <cfif NOT IsNumeric(score)>
    <cfset session.m_rules = 17>
    <cflocation url="view_message_rules.cfm" addtoken="no">
  </cfif>

  <!--- Validate rule_type is in allowed list --->
  <cfif NOT ListFindNoCase("header,body,rawbody,full,uri", rule_type)>
    <cfset session.m_rules = 18>
    <cflocation url="view_message_rules.cfm" addtoken="no">
  </cfif>

  <!--- Insert the rule --->
  <cfquery datasource="hermes">
    INSERT INTO message_rules (rule_name, rule_type, rule_desc, header, regex, score, applied)
    VALUES (
      <cfqueryparam value="#rule_name#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#rule_type#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#rule_desc#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#header#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#regex#" cfsqltype="cf_sql_varchar">,
      <cfqueryparam value="#score#" cfsqltype="cf_sql_varchar">,
      '2'
    )
  </cfquery>

  <cfset session.m_rules = 1>
  <cflocation url="view_message_rules.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: DELETE RULE --->
<!--- ===================== --->
<cfif action is "delete_rule">
  <cfif StructKeyExists(form, "delete_id") AND IsNumeric(form.delete_id)>
    <cfquery datasource="hermes">
      DELETE FROM message_rules
      WHERE id = <cfqueryparam value="#form.delete_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <!--- Mark remaining rules as needing apply --->
    <cfquery datasource="hermes">
      UPDATE message_rules SET applied = '2' WHERE applied = '1'
    </cfquery>
    <cfset session.m_rules = 2>
  </cfif>
  <cflocation url="view_message_rules.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: BULK DELETE --->
<!--- ===================== --->
<cfif action is "bulk_delete">
  <cfif StructKeyExists(form, "selected_ids") AND form.selected_ids is not "">
    <cfloop list="#form.selected_ids#" index="delId">
      <cfif IsNumeric(delId)>
        <cfquery datasource="hermes">
          DELETE FROM message_rules
          WHERE id = <cfqueryparam value="#delId#" cfsqltype="cf_sql_integer">
        </cfquery>
      </cfif>
    </cfloop>
    <!--- Mark remaining rules as needing apply --->
    <cfquery datasource="hermes">
      UPDATE message_rules SET applied = '2' WHERE applied = '1'
    </cfquery>
    <cfset session.m_rules = 2>
  </cfif>
  <cflocation url="view_message_rules.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: EDIT RULE --->
<!--- ===================== --->
<cfif action is "edit_rule">
  <cfif StructKeyExists(form, "edit_id") AND IsNumeric(form.edit_id)>
    <cfset edit_rule_type = trim(form.edit_rule_type)>
    <cfset edit_header = trim(form.edit_header)>
    <cfset edit_regex = trim(form.edit_regex)>
    <cfset edit_score = trim(form.edit_score)>
    <cfset edit_rule_desc = trim(form.edit_rule_desc)>

    <!--- Validate header for header type --->
    <cfif edit_rule_type is "header">
      <cfif edit_header is "">
        <cfset session.m_rules = 13>
        <cflocation url="view_message_rules.cfm" addtoken="no">
      </cfif>
      <cfif REFind("[^_a-zA-Z0-9-]", edit_header) GT 0>
        <cfset session.m_rules = 14>
        <cflocation url="view_message_rules.cfm" addtoken="no">
      </cfif>
    <cfelse>
      <cfset edit_header = "">
    </cfif>

    <!--- Validate regex --->
    <cfif edit_regex is "">
      <cfset session.m_rules = 15>
      <cflocation url="view_message_rules.cfm" addtoken="no">
    </cfif>

    <!--- Validate score --->
    <cfif edit_score is "" OR NOT IsNumeric(edit_score)>
      <cfset session.m_rules = 17>
      <cflocation url="view_message_rules.cfm" addtoken="no">
    </cfif>

    <!--- Validate rule_type --->
    <cfif NOT ListFindNoCase("header,body,rawbody,full,uri", edit_rule_type)>
      <cfset session.m_rules = 18>
      <cflocation url="view_message_rules.cfm" addtoken="no">
    </cfif>

    <cfquery datasource="hermes">
      UPDATE message_rules
      SET rule_type = <cfqueryparam value="#edit_rule_type#" cfsqltype="cf_sql_varchar">,
          rule_desc = <cfqueryparam value="#edit_rule_desc#" cfsqltype="cf_sql_varchar">,
          header = <cfqueryparam value="#edit_header#" cfsqltype="cf_sql_varchar">,
          regex = <cfqueryparam value="#edit_regex#" cfsqltype="cf_sql_varchar">,
          score = <cfqueryparam value="#edit_score#" cfsqltype="cf_sql_varchar">,
          applied = '2'
      WHERE id = <cfqueryparam value="#form.edit_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfset session.m_rules = 3>
  </cfif>
  <cflocation url="view_message_rules.cfm" addtoken="no">
</cfif>

<!--- ===================== --->
<!--- ACTION: APPLY --->
<!--- ===================== --->
<cfif action is "apply">
  <cftry>
    <cfinclude template="./inc/update_spamassassin_config_files.cfm">
    <cfinclude template="./inc/restart_spamassassin.cfm">

    <!--- Mark all rules as applied --->
    <cfquery datasource="hermes">
      UPDATE message_rules SET applied = '1' WHERE applied = '2'
    </cfquery>

    <cfset session.m_rules = 4>
    <cfcatch type="any">
      <cfset session.m_rules = 5>
    </cfcatch>
  </cftry>
  <cflocation url="view_message_rules.cfm" addtoken="no">
</cfif>

<!--- Refresh data after actions --->
<cfinclude template="./inc/get_message_rules.cfm">
<cfset session.m_rules = "">

<!--- ===================== --->
<!--- ALERTS --->
<!--- ===================== --->
<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Rule Added</h4>
    <p>Rule has been added. Click <strong>Apply Settings</strong> to activate.</p>
  </div>
</cfif>
<cfif m is 2>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-trash"></i> Rule Deleted</h4>
    <p>Click <strong>Apply Settings</strong> to activate the changes.</p>
  </div>
</cfif>
<cfif m is 3>
  <div class="alert alert-info alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-edit"></i> Rule Updated</h4>
    <p>Click <strong>Apply Settings</strong> to activate the changes.</p>
  </div>
</cfif>
<cfif m is 4>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Settings Applied</h4>
    <p>Message rules have been applied and SpamAssassin restarted.</p>
  </div>
</cfif>
<cfif m is 5>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Apply Failed</h4>
    <p>There was an error applying the SpamAssassin configuration. Please check the logs.</p>
  </div>
</cfif>
<cfif m is 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4>
    <p>The Rule Name field cannot be empty.</p>
  </div>
</cfif>
<cfif m is 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4>
    <p>The Rule Name field must only contain letters, numbers, dashes and underscores.</p>
  </div>
</cfif>
<cfif m is 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4>
    <p>A rule with that name already exists.</p>
  </div>
</cfif>
<cfif m is 13>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4>
    <p>The Header field cannot be empty when Rule Type is set to Header.</p>
  </div>
</cfif>
<cfif m is 14>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4>
    <p>The Header field must only contain letters, numbers, dashes and underscores.</p>
  </div>
</cfif>
<cfif m is 15>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4>
    <p>The Regex/Pattern field cannot be empty.</p>
  </div>
</cfif>
<cfif m is 16>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4>
    <p>The Score field cannot be empty.</p>
  </div>
</cfif>
<cfif m is 17>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4>
    <p>The Score field must be a numeric value.</p>
  </div>
</cfif>
<cfif m is 18>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4>
    <p>Invalid rule type selected.</p>
  </div>
</cfif>

<!--- ===================== --->
<!--- PENDING CHANGES --->
<!--- ===================== --->
<cfif has_pending_rule_changes>
  <div class="card card-warning card-outline mb-4">
    <div class="card-header">
      <h3 class="card-title"><i class="fas fa-clock"></i> Pending Changes (<cfoutput>#get_pending_rules.recordCount#</cfoutput>)</h3>
    </div>
    <div class="card-body">
      <cfoutput query="get_pending_rules">
        <span class="badge bg-warning text-dark me-1">#encodeForHTML(rule_name)# (#encodeForHTML(rule_type)#)</span>
      </cfoutput>
    </div>
  </div>
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

<!--- ===================== --->
<!--- REGEX HELPER --->
<!--- ===================== --->
<div class="card card-outline card-secondary mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-question-circle"></i> SpamAssassin Regex Helper</h3>
    <div class="card-tools">
      <button type="button" class="btn btn-tool" data-bs-toggle="collapse" data-bs-target="#regexHelper">
        <i class="fas fa-plus"></i>
      </button>
    </div>
  </div>
  <div class="collapse" id="regexHelper">
    <div class="card-body">
      <div class="row">
        <div class="col-md-6">
          <h5>Rule Types</h5>
          <table class="table table-sm table-bordered">
            <thead><tr><th>Type</th><th>Description</th></tr></thead>
            <tbody>
              <tr><td><code>header</code></td><td>Match against a specific message header (Subject, From, To, X-Mailer, etc.). Requires the <strong>Header</strong> field. Use <code>ALL</code> to match any header.</td></tr>
              <tr><td><code>body</code></td><td>Match against the decoded (plain text) body of the message.</td></tr>
              <tr><td><code>rawbody</code></td><td>Match against the raw (undecoded) body. Useful for matching HTML tags, comments, or encoding patterns.</td></tr>
              <tr><td><code>full</code></td><td>Match against the entire raw message including headers and body. Use with caution as this is the most resource-intensive type.</td></tr>
              <tr><td><code>uri</code></td><td>Match against URIs (URLs) found in the message body, both plain text and HTML.</td></tr>
            </tbody>
          </table>

          <h5 class="mt-3">Common Regex Patterns</h5>
          <table class="table table-sm table-bordered">
            <thead><tr><th>Pattern</th><th>Matches</th></tr></thead>
            <tbody>
              <tr><td><code>/keyword/i</code></td><td>Case-insensitive match for "keyword"</td></tr>
              <tr><td><code>/\bword\b/</code></td><td>Whole word match only</td></tr>
              <tr><td><code>/word1|word2|word3/i</code></td><td>Match any of several words</td></tr>
              <tr><td><code>/^Subject:.*free money/i</code></td><td>Subject line containing "free money"</td></tr>
              <tr><td><code>/https?:\/\/.*\.ru\//</code></td><td>URLs with .ru domain</td></tr>
              <tr><td><code>/[A-Z]{20,}/</code></td><td>20+ consecutive uppercase letters</td></tr>
            </tbody>
          </table>
        </div>
        <div class="col-md-6">
          <h5>Example SpamAssassin Rules</h5>
          <div class="mb-3">
            <strong>Block subject containing "lottery winner":</strong>
            <pre class="bg-light p-2 rounded">Rule Type: header
Header: Subject
Pattern: /lottery winner/i
Score: 5</pre>
            <small class="text-muted">Generates: <code>header RULE_NAME Subject =/lottery winner/i</code></small>
          </div>
          <div class="mb-3">
            <strong>Block body text with "click here to unsubscribe":</strong>
            <pre class="bg-light p-2 rounded">Rule Type: body
Pattern: /click here to unsubscribe/i
Score: 3</pre>
            <small class="text-muted">Generates: <code>body RULE_NAME /click here to unsubscribe/i</code></small>
          </div>
          <div class="mb-3">
            <strong>Block suspicious URIs:</strong>
            <pre class="bg-light p-2 rounded">Rule Type: uri
Pattern: /\.xyz\/[a-z0-9]{8,}/i
Score: 4</pre>
            <small class="text-muted">Generates: <code>uri RULE_NAME /\.xyz\/[a-z0-9]{8,}/i</code></small>
          </div>
          <div class="mb-3">
            <strong>Flag HTML with hidden text:</strong>
            <pre class="bg-light p-2 rounded">Rule Type: rawbody
Pattern: /display\s*:\s*none/i
Score: 2</pre>
            <small class="text-muted">Generates: <code>rawbody RULE_NAME /display\s*:\s*none/i</code></small>
          </div>

          <h5 class="mt-3">Test Your Regex</h5>
          <div class="mb-2">
            <label for="testPattern" class="form-label"><strong>Pattern</strong></label>
            <input type="text" class="form-control form-control-sm" id="testPattern" placeholder="/your-regex-here/i">
          </div>
          <div class="mb-2">
            <label for="testString" class="form-label"><strong>Test String</strong></label>
            <input type="text" class="form-control form-control-sm" id="testString" placeholder="Text to test against">
          </div>
          <button type="button" class="btn btn-sm btn-secondary" onclick="testRegex();">
            <i class="fas fa-play"></i> Test
          </button>
          <span id="testResult" class="ms-2"></span>
        </div>
      </div>

      <div class="row mt-3">
        <div class="col-12">
          <div class="callout callout-info">
            <h5>Scoring Guide</h5>
            <ul class="mb-0">
              <li><strong>Positive scores</strong> increase the spam score (higher = more likely spam). Typical range: 1-10.</li>
              <li><strong>A score of 0</strong> effectively disables the rule (still evaluated but does not affect the final spam score).</li>
              <li><strong>Negative scores</strong> decrease the spam score (can whitelist patterns).</li>
              <li>The default SpamAssassin spam threshold is typically <strong>6.31</strong>. Messages scoring at or above this are treated as spam.</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!--- ===================== --->
<!--- ADD RULE CARD --->
<!--- ===================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Add Message Rule</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="add_rule">
      <div class="row">
        <div class="col-md-4 mb-3">
          <label for="rule_name" class="form-label"><strong>Rule Name</strong></label>
          <input type="text" class="form-control" id="rule_name" name="rule_name" maxlength="255"
            placeholder="MY_CUSTOM_RULE" required>
          <small class="text-muted">Letters, numbers, dashes and underscores only. No spaces.</small>
        </div>
        <div class="col-md-4 mb-3">
          <label for="rule_type" class="form-label"><strong>Rule Type</strong></label>
          <select class="form-select" id="rule_type" name="rule_type" onchange="toggleHeaderField();">
            <option value="body">Body - Search message body</option>
            <option value="header">Header - Search message headers</option>
            <option value="rawbody">Rawbody - Search raw/HTML body</option>
            <option value="full">Full - Search entire message</option>
            <option value="uri">URI - Search URIs in message</option>
          </select>
        </div>
        <div class="col-md-4 mb-3">
          <label for="header" class="form-label"><strong>Header</strong></label>
          <input type="text" class="form-control" id="header" name="header" maxlength="255"
            placeholder="Subject" disabled>
          <small class="text-muted">Required for Header type. Use ALL to match any header.</small>
        </div>
      </div>
      <div class="row">
        <div class="col-md-6 mb-3">
          <label for="regex" class="form-label"><strong>Regex Pattern</strong></label>
          <input type="text" class="form-control" id="regex" name="regex" maxlength="255"
            placeholder="/pattern/i" required>
          <small class="text-muted">SpamAssassin regex pattern (e.g., <code>/keyword/i</code>)</small>
        </div>
        <div class="col-md-2 mb-3">
          <label for="score" class="form-label"><strong>Score</strong></label>
          <input type="text" class="form-control" id="score" name="score" maxlength="10"
            placeholder="5" required>
          <small class="text-muted">Numeric value</small>
        </div>
        <div class="col-md-4 mb-3">
          <label for="rule_desc" class="form-label"><strong>Description</strong> <span class="text-muted">(optional)</span></label>
          <input type="text" class="form-control" id="rule_desc" name="rule_desc" maxlength="255"
            placeholder="Blocks messages containing...">
        </div>
      </div>
      <div class="row">
        <div class="col-12">
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            <i class="fas fa-plus"></i> Add Rule
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!--- ===================== --->
<!--- RULES TABLE --->
<!--- ===================== --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list-alt"></i> Existing Message Rules</h3>
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

      <table id="rulesTable" class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th style="width: 3%"><input type="checkbox" id="selectAll"></th>
            <th style="width: 15%">Rule Name</th>
            <th style="width: 10%">Type</th>
            <th style="width: 10%">Header</th>
            <th style="width: 25%">Regex</th>
            <th style="width: 7%">Score</th>
            <th style="width: 18%">Description</th>
            <th style="width: 12%">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="get_message_rules">
            <tr<cfif applied is "2"> class="table-warning"</cfif>>
              <td><input type="checkbox" class="row-checkbox" value="#id#"></td>
              <td>#encodeForHTML(rule_name)#</td>
              <td>
                <cfswitch expression="#rule_type#">
                  <cfcase value="header"><span class="badge bg-info">header</span></cfcase>
                  <cfcase value="body"><span class="badge bg-primary">body</span></cfcase>
                  <cfcase value="rawbody"><span class="badge bg-secondary">rawbody</span></cfcase>
                  <cfcase value="full"><span class="badge bg-dark">full</span></cfcase>
                  <cfcase value="uri"><span class="badge bg-success">uri</span></cfcase>
                  <cfdefaultcase><span class="badge bg-light text-dark">#encodeForHTML(rule_type)#</span></cfdefaultcase>
                </cfswitch>
              </td>
              <td><cfif rule_type is "header">#encodeForHTML(header)#<cfelse><span class="text-muted">N/A</span></cfif></td>
              <td><code>#encodeForHTML(regex)#</code></td>
              <td class="text-center">#encodeForHTML(score)#</td>
              <td>#encodeForHTML(rule_desc)#</td>
              <td>
                <button type="button" class="btn btn-sm btn-primary" title="Edit"
                  onclick="openEditModal('#id#', '#encodeForJavaScript(rule_name)#', '#encodeForJavaScript(rule_type)#', '#encodeForJavaScript(header)#', '#encodeForJavaScript(regex)#', '#encodeForJavaScript(score)#', '#encodeForJavaScript(rule_desc)#');">
                  <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-sm btn-danger" title="Delete"
                  onclick="deleteSingle('#id#', '#encodeForJavaScript(rule_name)#');">
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

<!--- ===================== --->
<!--- EDIT MODAL --->
<!--- ===================== --->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="edit_rule">
        <input type="hidden" name="edit_id" id="edit_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit Message Rule</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label"><strong>Rule Name</strong></label>
            <input type="text" class="form-control" id="edit_rule_name" disabled>
            <small class="text-muted">Rule name cannot be changed.</small>
          </div>
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="edit_rule_type" class="form-label"><strong>Rule Type</strong></label>
              <select class="form-select" name="edit_rule_type" id="edit_rule_type" onchange="toggleEditHeaderField();">
                <option value="body">Body - Search message body</option>
                <option value="header">Header - Search message headers</option>
                <option value="rawbody">Rawbody - Search raw/HTML body</option>
                <option value="full">Full - Search entire message</option>
                <option value="uri">URI - Search URIs in message</option>
              </select>
            </div>
            <div class="col-md-6 mb-3">
              <label for="edit_header" class="form-label"><strong>Header</strong></label>
              <input type="text" class="form-control" id="edit_header" name="edit_header" maxlength="255">
              <small class="text-muted">Required for Header type. Use ALL to match any header.</small>
            </div>
          </div>
          <div class="mb-3">
            <label for="edit_regex" class="form-label"><strong>Regex Pattern</strong></label>
            <input type="text" class="form-control" id="edit_regex" name="edit_regex" maxlength="255" required>
          </div>
          <div class="row">
            <div class="col-md-4 mb-3">
              <label for="edit_score" class="form-label"><strong>Score</strong></label>
              <input type="text" class="form-control" id="edit_score" name="edit_score" maxlength="10" required>
            </div>
            <div class="col-md-8 mb-3">
              <label for="edit_rule_desc" class="form-label"><strong>Description</strong></label>
              <input type="text" class="form-control" id="edit_rule_desc" name="edit_rule_desc" maxlength="255">
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

<!--- Hidden delete form --->
<form id="deleteForm" method="post" style="display:none;">
  <input type="hidden" name="action" value="delete_rule">
  <input type="hidden" name="delete_id" id="delete_id" value="">
</form>

<script>
$(document).ready(function() {
  $('#rulesTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[1, 'asc']],
    columnDefs: [
      { orderable: false, targets: [0, 7] },
      { searchable: false, targets: [0, 7] }
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
    if (!confirm('Delete ' + selectedIds.size + ' selected rule(s)?')) return;
    $('#selectedIds').val(Array.from(selectedIds).join(','));
    $('#bulkDeleteForm').submit();
  };
});

function toggleHeaderField() {
  var ruleType = document.getElementById('rule_type').value;
  var headerField = document.getElementById('header');
  if (ruleType === 'header') {
    headerField.disabled = false;
    headerField.required = true;
  } else {
    headerField.disabled = true;
    headerField.required = false;
    headerField.value = '';
  }
}

function toggleEditHeaderField() {
  var ruleType = document.getElementById('edit_rule_type').value;
  var headerField = document.getElementById('edit_header');
  if (ruleType === 'header') {
    headerField.disabled = false;
    headerField.required = true;
  } else {
    headerField.disabled = true;
    headerField.required = false;
    headerField.value = '';
  }
}

function openEditModal(id, ruleName, ruleType, header, regex, score, ruleDesc) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_rule_name').value = ruleName;
  document.getElementById('edit_rule_type').value = ruleType;
  document.getElementById('edit_header').value = header;
  document.getElementById('edit_regex').value = regex;
  document.getElementById('edit_score').value = score;
  document.getElementById('edit_rule_desc').value = ruleDesc;
  toggleEditHeaderField();
  new bootstrap.Modal(document.getElementById('editModal')).show();
}

function deleteSingle(id, name) {
  if (!confirm('Delete rule "' + name + '"?')) return;
  document.getElementById('delete_id').value = id;
  document.getElementById('deleteForm').submit();
}

function testRegex() {
  var pattern = document.getElementById('testPattern').value;
  var testStr = document.getElementById('testString').value;
  var resultEl = document.getElementById('testResult');

  if (!pattern || !testStr) {
    resultEl.innerHTML = '<span class="badge bg-secondary">Enter both pattern and test string</span>';
    return;
  }

  try {
    // Strip SpamAssassin-style delimiters if present
    var regexParts = pattern.match(/^\/(.+)\/([gimsuy]*)$/);
    var re;
    if (regexParts) {
      re = new RegExp(regexParts[1], regexParts[2]);
    } else {
      re = new RegExp(pattern);
    }

    if (re.test(testStr)) {
      resultEl.innerHTML = '<span class="badge bg-success"><i class="fas fa-check"></i> Match found</span>';
    } else {
      resultEl.innerHTML = '<span class="badge bg-danger"><i class="fas fa-times"></i> No match</span>';
    }
  } catch(e) {
    resultEl.innerHTML = '<span class="badge bg-warning text-dark"><i class="fas fa-exclamation-triangle"></i> Invalid regex: ' + e.message + '</span>';
  }
}
</script>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>
</html>
