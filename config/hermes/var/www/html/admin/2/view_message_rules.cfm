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

  <!--- Preserve form values for validation errors --->
  <cfset session.form_rule_name = rule_name>
  <cfset session.form_rule_type = rule_type>
  <cfset session.form_rule_desc = rule_desc>
  <cfset session.form_header = header>
  <cfset session.form_regex = regex>
  <cfset session.form_score = score>

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

  <!--- For header rules, prepend "~ " to regex for SpamAssassin =~ operator format --->
  <cfif rule_type is "header" AND Left(trim(regex), 2) is not "~ ">
    <cfset regex = "~ " & regex>
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

  <!--- Apply immediately --->
  <cfinclude template="./inc/apply_message_rules.cfm">
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

    <!--- Apply immediately --->
    <cfinclude template="./inc/apply_message_rules.cfm">
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

    <!--- Apply immediately --->
    <cfinclude template="./inc/apply_message_rules.cfm">
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

    <!--- For header rules, prepend "~ " to regex for SpamAssassin =~ operator format --->
    <cfif edit_rule_type is "header" AND Left(trim(edit_regex), 2) is not "~ ">
      <cfset edit_regex = "~ " & edit_regex>
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

    <!--- Apply immediately --->
    <cfinclude template="./inc/apply_message_rules.cfm">
    <cfset session.m_rules = 3>
  </cfif>
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
    <p>Rule added, SpamAssassin configuration validated and reloaded.</p>
  </div>
</cfif>
<cfif m is 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Rule Deleted</h4>
    <p>Rule deleted, SpamAssassin configuration validated and reloaded.</p>
  </div>
</cfif>
<cfif m is 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Rule Updated</h4>
    <p>Rule updated, SpamAssassin configuration validated and reloaded.</p>
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

<div class="callout callout-info mb-4">
  <h5><i class="fas fa-info-circle"></i> Page Guide</h5>
  <p class="mb-1">Message rules are custom SpamAssassin rules that add or subtract from a message's spam score based on regex pattern matches. Each rule targets a specific part of the message and assigns a score when the pattern matches.</p>
  <p class="mb-1">Rules with <strong>positive scores</strong> increase the spam score (making the message more likely to be quarantined), while <strong>negative scores</strong> decrease it (useful for whitelisting). A score of <strong>0</strong> disables the rule without removing it. Changes are applied immediately and validated with <code>spamassassin --lint</code>. If validation fails, the previous configuration is automatically restored.</p>
  <p class="mb-1"><strong>Rule Types:</strong>
    <code>header</code> -- match a specific header (requires Header field, use <code>ALL</code> for any header) |
    <code>body</code> -- match decoded plain text body |
    <code>rawbody</code> -- match raw/HTML body |
    <code>full</code> -- match entire raw message (resource-intensive) |
    <code>uri</code> -- match URIs found in the message.
  </p>
  <p class="mb-0"><strong>Regex Syntax:</strong>
    <code>/keyword/i</code> case-insensitive match |
    <code>/\bword\b/</code> whole word only |
    <code>/word1|word2/i</code> match any of several words |
    <code>/[A-Z]{20,}/</code> 20+ consecutive uppercase letters |
    <code>/https?:\/\/.*\.ru\//</code> URLs with .ru domain
  </p>
</div>

<!--- ===================== --->
<!--- REGEX HELPER --->
<!--- ===================== --->
<div class="card card-outline card-secondary mb-4">
  <div class="card-header">
    <h3 class="card-title">
      <button type="button" class="btn btn-sm btn-outline-secondary me-2" id="toggleRegexHelper" title="Expand">
        <i class="fas fa-chevron-down"></i>
      </button>
      <i class="fas fa-question-circle"></i> SpamAssassin Regex Helper
    </h3>
  </div>
  <div class="collapse" id="regexHelper">
    <div class="card-body">

      <!-- SECTION 1: Rule Builder -->
      <h5 class="border-bottom pb-2 mb-3"><i class="fas fa-magic me-1"></i> Build a Rule (No Regex Knowledge Required)</h5>
      <p class="text-muted mb-2">Select what to match, enter your text, and click <strong>Build</strong> to generate the SpamAssassin regex pattern. Then click <strong>Use</strong> to copy it to the Add form below.</p>
      <div class="row">
        <div class="col-md-10 mb-3">
          <div class="row mb-2">
            <div class="col-md-3">
              <select class="form-select form-select-sm" id="builderTarget">
                <option value="body">Match in body</option>
                <option value="header">Match in header</option>
                <option value="rawbody">Match in raw/HTML body</option>
                <option value="uri">Match in URIs</option>
              </select>
            </div>
            <div class="col-md-3" id="builderHeaderCol" style="display:none;">
              <input type="text" class="form-control form-control-sm" id="builderHeader" list="builderHeaderList" placeholder="e.g. Subject">
              <datalist id="builderHeaderList">
                <option value="Subject">
                <option value="From">
                <option value="To">
                <option value="Cc">
                <option value="Reply-To">
                <option value="Return-Path">
                <option value="Received">
                <option value="Content-Type">
                <option value="Content-Disposition">
                <option value="MIME-Version">
                <option value="Message-ID">
                <option value="X-Mailer">
                <option value="X-Originating-IP">
                <option value="X-Spam-Status">
                <option value="X-Priority">
                <option value="List-Unsubscribe">
                <option value="ALL">
              </datalist>
              <small class="text-muted">Select from the list or type any header name</small>
            </div>
            <div class="col-md-3">
              <select class="form-select form-select-sm" id="builderMode">
                <option value="contains">Contains</option>
                <option value="exact">Exact match</option>
                <option value="startswith">Starts with</option>
                <option value="endswith">Ends with</option>
                <option value="anyof">Any of (comma-separated)</option>
              </select>
            </div>
            <div class="col-md-3">
              <select class="form-select form-select-sm" id="builderCase">
                <option value="i">Case-insensitive</option>
                <option value="">Case-sensitive</option>
              </select>
            </div>
          </div>
          <div class="input-group mb-2">
            <input type="text" class="form-control" id="builderValue" placeholder="Enter text to match (e.g. lottery winner, click here)">
            <button type="button" class="btn btn-primary" onclick="buildSaPattern();">
              <i class="fas fa-cog"></i> Build
            </button>
          </div>
          <div class="input-group">
            <span class="input-group-text">Generated Pattern</span>
            <input type="text" class="form-control" id="builtSaPattern" readonly>
            <button type="button" class="btn btn-success" onclick="useBuiltSaPattern();" title="Copy to Add form">
              <i class="fas fa-arrow-down"></i> Use
            </button>
          </div>
          <div id="buildSaExplanation" class="mt-1" style="display:none;"></div>
        </div>
      </div>

      <hr>

      <!-- SECTION 2: Quick Select Common Patterns -->
      <h5 class="border-bottom pb-2 mb-3"><i class="fas fa-list me-1"></i> Quick Select Common Patterns</h5>
      <p class="text-muted mb-2">Select a pre-built rule pattern and it will be copied directly to the Add form below.</p>
      <div class="row">
        <div class="col-md-8 mb-3">
          <div class="input-group">
            <select class="form-select" id="commonSaPatterns">
              <option value="">-- Select a pattern --</option>
              <optgroup label="Header Rules">
                <option value="header|Subject|/lottery winner/i|5">Subject contains "lottery winner" (score 5)</option>
                <option value="header|Subject|/urgent action required/i|4">Subject contains "urgent action required" (score 4)</option>
                <option value="header|Subject|/\bfree\b.*\b(money|gift|offer)\b/i|3">Subject contains "free money/gift/offer" (score 3)</option>
                <option value="header|From|/noreply@.*\.xyz$/i|4">From address on .xyz domain (score 4)</option>
              </optgroup>
              <optgroup label="Body Rules">
                <option value="body||/click here to (verify|confirm|update)/i|4">Body: "click here to verify/confirm/update" (score 4)</option>
                <option value="body||/cryptocurrency.*invest/i|5">Body: cryptocurrency investment (score 5)</option>
                <option value="body||/act now.*limited time/i|3">Body: "act now...limited time" (score 3)</option>
              </optgroup>
              <optgroup label="URI Rules">
                <option value="uri||/\.xyz\/[a-z0-9]{8,}/i|4">URI: suspicious .xyz path (score 4)</option>
                <option value="uri||/bit\.ly|tinyurl\.com|t\.co/i|2">URI: URL shortener (score 2)</option>
              </optgroup>
              <optgroup label="Raw Body Rules">
                <option value="rawbody||/display\s*:\s*none/i|3">HTML: hidden text (display:none) (score 3)</option>
                <option value="rawbody||/font-size\s*:\s*0/i|3">HTML: zero-size font (score 3)</option>
              </optgroup>
            </select>
            <button type="button" class="btn btn-success" onclick="applyCommonSaPattern();">
              <i class="fas fa-arrow-down"></i> Use
            </button>
          </div>
        </div>
      </div>

      <hr>

      <!-- SECTION 3: Test a Pattern -->
      <h5 class="border-bottom pb-2 mb-3"><i class="fas fa-flask me-1"></i> Test a Pattern</h5>
      <p class="text-muted mb-2">Verify your pattern works by testing it against sample text.</p>
      <div class="row">
        <div class="col-md-10 mb-3">
          <div class="input-group">
            <span class="input-group-text">Pattern</span>
            <input type="text" class="form-control" id="testPattern" placeholder="/your-regex-here/i">
            <span class="input-group-text">Test String</span>
            <input type="text" class="form-control" id="testString" placeholder="Text to test against">
            <button type="button" class="btn btn-outline-success" onclick="testRegex();">
              <i class="fas fa-flask"></i> Test
            </button>
          </div>
          <div id="testResult" class="mt-2"></div>
        </div>
      </div>
    </div>
  </div>
</div>

<!--- ===================== --->
<!--- ADD RULE CARD --->
<!--- ===================== --->
<!--- Restore form values after validation error --->
<cfset fv_rule_name = "">
<cfset fv_rule_type = "body">
<cfset fv_rule_desc = "">
<cfset fv_header = "">
<cfset fv_regex = "">
<cfset fv_score = "">
<cfif StructKeyExists(session, "form_rule_name")>
  <cfset fv_rule_name = session.form_rule_name>
  <cfset fv_rule_type = session.form_rule_type>
  <cfset fv_rule_desc = session.form_rule_desc>
  <cfset fv_header = session.form_header>
  <cfset fv_regex = session.form_regex>
  <cfset fv_score = session.form_score>
  <cfset StructDelete(session, "form_rule_name")>
  <cfset StructDelete(session, "form_rule_type")>
  <cfset StructDelete(session, "form_rule_desc")>
  <cfset StructDelete(session, "form_header")>
  <cfset StructDelete(session, "form_regex")>
  <cfset StructDelete(session, "form_score")>
</cfif>

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
          <cfoutput>
          <input type="text" class="form-control" id="rule_name" name="rule_name" maxlength="255"
            placeholder="MY_CUSTOM_RULE" value="#encodeForHTMLAttribute(fv_rule_name)#" required>
          <small class="text-muted">Letters, numbers, dashes and underscores only. No spaces.</small>
        </div>
        <div class="col-md-4 mb-3">
          <label for="rule_type" class="form-label"><strong>Rule Type</strong></label>
          <select class="form-select" id="rule_type" name="rule_type" onchange="toggleHeaderField();">
            <option value="body"<cfif fv_rule_type is "body"> selected</cfif>>Body - Search message body</option>
            <option value="header"<cfif fv_rule_type is "header"> selected</cfif>>Header - Search message headers</option>
            <option value="rawbody"<cfif fv_rule_type is "rawbody"> selected</cfif>>Rawbody - Search raw/HTML body</option>
            <option value="full"<cfif fv_rule_type is "full"> selected</cfif>>Full - Search entire message</option>
            <option value="uri"<cfif fv_rule_type is "uri"> selected</cfif>>URI - Search URIs in message</option>
          </select>
        </div>
        <div class="col-md-4 mb-3">
          <label for="header" class="form-label"><strong>Header</strong></label>
          <input type="text" class="form-control" id="header" name="header" list="headerList" maxlength="255"
            placeholder="e.g. Subject" value="#encodeForHTMLAttribute(fv_header)#"<cfif fv_rule_type is not "header"> disabled</cfif>>
          <datalist id="headerList">
            <option value="Subject">
            <option value="From">
            <option value="To">
            <option value="Cc">
            <option value="Reply-To">
            <option value="Return-Path">
            <option value="Received">
            <option value="Content-Type">
            <option value="Content-Disposition">
            <option value="MIME-Version">
            <option value="Message-ID">
            <option value="X-Mailer">
            <option value="X-Originating-IP">
            <option value="X-Spam-Status">
            <option value="X-Priority">
            <option value="List-Unsubscribe">
            <option value="ALL">
          </datalist>
          <small class="text-muted">Select from the list or type any header name</small>
        </div>
      </div>
      <div class="row">
        <div class="col-md-6 mb-3">
          <label for="regex" class="form-label"><strong>Regex Pattern</strong></label>
          <input type="text" class="form-control" id="regex" name="regex" maxlength="255"
            placeholder="/pattern/i" value="#encodeForHTMLAttribute(fv_regex)#" required>
          <small class="text-muted">SpamAssassin regex pattern (e.g., <code>/keyword/i</code>)</small>
        </div>
        <div class="col-md-2 mb-3">
          <label for="score" class="form-label"><strong>Score</strong></label>
          <input type="number" class="form-control" id="score" name="score" step="0.01" min="-999" max="999"
            placeholder="5" value="#encodeForHTMLAttribute(fv_score)#" required>
          <small class="text-muted">Positive = more spammy, negative = whitelist</small>
        </div>
        <div class="col-md-4 mb-3">
          <label for="rule_desc" class="form-label"><strong>Description</strong> <span class="text-muted">(optional)</span></label>
          <input type="text" class="form-control" id="rule_desc" name="rule_desc" maxlength="255"
            placeholder="Blocks messages containing..." value="#encodeForHTMLAttribute(fv_rule_desc)#">
          </cfoutput>
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
            <tr>
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
              <td><code><cfif rule_type is "header" AND Left(trim(regex), 2) is "~ ">#encodeForHTML(Mid(trim(regex), 3, Len(trim(regex))))#<cfelse>#encodeForHTML(regex)#</cfif></code></td>
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
              <input type="text" class="form-control" id="edit_header" name="edit_header" list="editHeaderList" maxlength="255" placeholder="e.g. Subject">
              <datalist id="editHeaderList">
                <option value="Subject">
                <option value="From">
                <option value="To">
                <option value="Cc">
                <option value="Reply-To">
                <option value="Return-Path">
                <option value="Received">
                <option value="Content-Type">
                <option value="Content-Disposition">
                <option value="MIME-Version">
                <option value="Message-ID">
                <option value="X-Mailer">
                <option value="X-Originating-IP">
                <option value="X-Spam-Status">
                <option value="X-Priority">
                <option value="List-Unsubscribe">
                <option value="ALL">
              </datalist>
              <small class="text-muted">Select from the list or type any header name</small>
            </div>
          </div>
          <div class="mb-3">
            <label for="edit_regex" class="form-label"><strong>Regex Pattern</strong></label>
            <input type="text" class="form-control" id="edit_regex" name="edit_regex" maxlength="255" required>
          </div>
          <div class="row">
            <div class="col-md-4 mb-3">
              <label for="edit_score" class="form-label"><strong>Score</strong></label>
              <input type="number" class="form-control" id="edit_score" name="edit_score" step="0.01" min="-999" max="999" required>
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
  // Regex Helper toggle (chevron down/up)
  $('#toggleRegexHelper').on('click', function() {
    $('#regexHelper').collapse('toggle');
  });
  $('#regexHelper').on('shown.bs.collapse', function() {
    $('#toggleRegexHelper').find('i').removeClass('fa-chevron-down').addClass('fa-chevron-up');
    $('#toggleRegexHelper').attr('title', 'Collapse');
  });
  $('#regexHelper').on('hidden.bs.collapse', function() {
    $('#toggleRegexHelper').find('i').removeClass('fa-chevron-up').addClass('fa-chevron-down');
    $('#toggleRegexHelper').attr('title', 'Expand');
  });

  // Show/hide header select in builder when target is 'header'
  $('#builderTarget').on('change', function() {
    if (this.value === 'header') {
      $('#builderHeaderCol').show();
    } else {
      $('#builderHeaderCol').hide();
    }
  });

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

var _savedEditHeader = '';
function toggleEditHeaderField() {
  var ruleType = document.getElementById('edit_rule_type').value;
  var headerField = document.getElementById('edit_header');
  if (ruleType === 'header') {
    headerField.disabled = false;
    headerField.required = true;
    if (!headerField.value && _savedEditHeader) {
      headerField.value = _savedEditHeader;
    }
  } else {
    if (headerField.value) {
      _savedEditHeader = headerField.value;
    }
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
  // Strip leading "~ " from header rule regex for display
  if (ruleType === 'header' && regex.substring(0, 2) === '~ ') {
    regex = regex.substring(2);
  }
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

function escapeRegex(str) {
  return str.replace(/[.*+?^${}()|[\]\\\/]/g, '\\$&');
}

function buildSaPattern() {
  var value = document.getElementById('builderValue').value.trim();
  var mode = document.getElementById('builderMode').value;
  var caseflag = document.getElementById('builderCase').value;
  var target = document.getElementById('builderTarget').value;
  var resultEl = document.getElementById('builtSaPattern');
  var explainEl = document.getElementById('buildSaExplanation');

  if (!value) {
    resultEl.value = '';
    explainEl.style.display = 'none';
    return;
  }

  var pattern = '';
  var explanation = '';

  if (mode === 'anyof') {
    var parts = value.split(',').map(function(s) { return escapeRegex(s.trim()); }).filter(function(s) { return s; });
    pattern = '/' + parts.join('|') + '/' + caseflag;
    explanation = 'Matches any of: ' + parts.join(', ');
  } else if (mode === 'contains') {
    pattern = '/' + escapeRegex(value) + '/' + caseflag;
    explanation = 'Matches text containing "' + value + '"';
  } else if (mode === 'exact') {
    pattern = '/^' + escapeRegex(value) + '$/' + caseflag;
    explanation = 'Matches exactly "' + value + '"';
  } else if (mode === 'startswith') {
    pattern = '/^' + escapeRegex(value) + '/' + caseflag;
    explanation = 'Matches text starting with "' + value + '"';
  } else if (mode === 'endswith') {
    pattern = '/' + escapeRegex(value) + '$/' + caseflag;
    explanation = 'Matches text ending with "' + value + '"';
  }

  resultEl.value = pattern;
  if (explanation) {
    explainEl.innerHTML = '<small class="text-muted">' + explanation + '</small>';
    explainEl.style.display = 'block';
  }
}

function useBuiltSaPattern() {
  var pattern = document.getElementById('builtSaPattern').value;
  if (!pattern) return;
  var target = document.getElementById('builderTarget').value;

  document.getElementById('regex').value = pattern;
  document.getElementById('rule_type').value = target;
  toggleHeaderField();

  if (target === 'header') {
    var header = document.getElementById('builderHeader').value;
    document.getElementById('header').value = header;
  }

  document.getElementById('regex').scrollIntoView({ behavior: 'smooth', block: 'center' });
}

function applyCommonSaPattern() {
  var sel = document.getElementById('commonSaPatterns');
  if (!sel.value) return;

  var parts = sel.value.split('|');
  var ruleType = parts[0];
  var header = parts[1];
  var pattern = parts[2];
  var score = parts[3];

  document.getElementById('rule_type').value = ruleType;
  toggleHeaderField();

  if (ruleType === 'header' && header) {
    document.getElementById('header').value = header;
  }
  document.getElementById('regex').value = pattern;
  document.getElementById('score').value = score;

  sel.selectedIndex = 0;
  document.getElementById('regex').scrollIntoView({ behavior: 'smooth', block: 'center' });
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
