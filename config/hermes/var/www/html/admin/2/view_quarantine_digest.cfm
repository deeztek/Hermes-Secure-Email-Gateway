<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.
--->

<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Quarantine Digest</title>
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
            <h1 class="m-0">Content Checks - Quarantine Digest</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Content Checks</li>
              <li class="breadcrumb-item active">Quarantine Digest</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="digestFlash" default="0">
<cfif StructKeyExists(session, "quarantineDigestFlash") AND session.quarantineDigestFlash NEQ "">
  <cfset digestFlash = session.quarantineDigestFlash>
</cfif>

<cfif NOT StructKeyExists(session, "quarantineDigestCsrf") OR session.quarantineDigestCsrf EQ "">
  <cfset session.quarantineDigestCsrf = hash(createUUID() & now())>
</cfif>

<cfif StructKeyExists(form, "action") AND form.action EQ "save_digest_settings">
    <cfif NOT StructKeyExists(form, "csrf_token") OR form.csrf_token NEQ session.quarantineDigestCsrf>
        <cfset m = "Quarantine Digest: invalid CSRF token">
        <cfinclude template="./inc/error.cfm">
        <cfabort>
    </cfif>
    <cfparam name="form.digest_enabled" default="0">
    <cfparam name="form.digest_frequency" default="daily">
    <cfparam name="form.digest_template" default="modern">
    <cfparam name="form.digest_subject" default="[Hermes SEG] Quarantine Digest">
    <cfparam name="form.digest_intro" default="Review quarantined messages below.">
    <cfparam name="form.disable_individual" default="1">

    <cfif NOT ListFindNoCase("0,1", form.digest_enabled)>
        <cfset form.digest_enabled = "0">
    </cfif>
    <cfif NOT ListFindNoCase("daily,weekly,monthly", form.digest_frequency)>
        <cfset form.digest_frequency = "daily">
    </cfif>
    <cfset digestOfeliaSchedule = "0 0 19 * * *">
    <cfif form.digest_frequency EQ "weekly">
        <cfset digestOfeliaSchedule = "0 0 19 * * FRI">
    <cfelseif form.digest_frequency EQ "monthly">
        <cfset digestOfeliaSchedule = "0 0 19 28-31 * *">
    </cfif>
    <cfif NOT ListFindNoCase("modern,classic,compact", form.digest_template)>
        <cfset form.digest_template = "modern">
    </cfif>
    <cfif NOT ListFindNoCase("0,1", form.disable_individual)>
        <cfset form.disable_individual = "1">
    </cfif>

    <cfset digestSubject = Left(Trim(form.digest_subject), 255)>
    <cfset digestIntro = Left(Trim(form.digest_intro), 255)>
    <cfif digestSubject EQ "">
        <cfset digestSubject = "[Hermes SEG] Quarantine Digest">
    </cfif>
    <cfif digestIntro EQ "">
        <cfset digestIntro = "Review quarantined messages below. Secure links let recipients view, release, or block senders without signing in.">
    </cfif>

    <cfscript>
    settingDefaults = [
        {parameter="enabled", value2="0"},
        {parameter="frequency", value2="daily"},
        {parameter="template", value2="modern"},
        {parameter="subject", value2="[Hermes SEG] Quarantine Digest"},
        {parameter="intro", value2="Review quarantined messages below. Secure links let recipients view, release, or block senders without signing in."},
        {parameter="disable_individual", value2="1"},
        {parameter="last_run", value2=""}
    ];
    for (var defaultRow in settingDefaults) {
        queryExecute(
            "INSERT INTO parameters2 (parameter, value2, module, active, applied) " &
            "SELECT :parameter, :value2, 'quarantine_digest', 1, 1 " &
            "WHERE NOT EXISTS (SELECT 1 FROM (SELECT * FROM parameters2) p WHERE p.parameter = :parameter AND p.module = 'quarantine_digest')",
            {
                parameter: {value: defaultRow.parameter, cfsqltype: "cf_sql_varchar"},
                value2: {value: defaultRow.value2, cfsqltype: "cf_sql_varchar", null: (defaultRow.value2 EQ "")}
            },
            {datasource: "hermes"}
        );
    }
    </cfscript>

    <cfquery datasource="hermes">
        UPDATE parameters2 SET value2 = <cfqueryparam value="#form.digest_enabled#" cfsqltype="cf_sql_varchar">, applied = 2
        WHERE module = 'quarantine_digest' AND parameter = 'enabled'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE parameters2 SET value2 = <cfqueryparam value="#form.digest_frequency#" cfsqltype="cf_sql_varchar">, applied = 2
        WHERE module = 'quarantine_digest' AND parameter = 'frequency'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE parameters2 SET value2 = <cfqueryparam value="#form.digest_template#" cfsqltype="cf_sql_varchar">, applied = 2
        WHERE module = 'quarantine_digest' AND parameter = 'template'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE parameters2 SET value2 = <cfqueryparam value="#digestSubject#" cfsqltype="cf_sql_varchar">, applied = 2
        WHERE module = 'quarantine_digest' AND parameter = 'subject'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE parameters2 SET value2 = <cfqueryparam value="#digestIntro#" cfsqltype="cf_sql_varchar">, applied = 2
        WHERE module = 'quarantine_digest' AND parameter = 'intro'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE parameters2 SET value2 = <cfqueryparam value="#form.disable_individual#" cfsqltype="cf_sql_varchar">, applied = 2
        WHERE module = 'quarantine_digest' AND parameter = 'disable_individual'
    </cfquery>
    <cfquery datasource="hermes">
        UPDATE ofelia_jobs
        SET schedule = <cfqueryparam value="#digestOfeliaSchedule#" cfsqltype="cf_sql_varchar">
        WHERE job_name = '[job-exec "hermes-quarantine-digest"]'
    </cfquery>
    <cfsilent>
        <cfinclude template="./inc/ofelia_generate_config.cfm">
    </cfsilent>

    <cfset session.quarantineDigestCsrf = hash(createUUID() & now())>
    <cfset session.quarantineDigestFlash = 1>
    <cflocation url="view_quarantine_digest.cfm" addtoken="no">
    <cfabort>
</cfif>

<cfquery name="getDigestSettings" datasource="hermes">
    SELECT parameter, value2
    FROM parameters2
    WHERE module = 'quarantine_digest'
</cfquery>

<cfquery name="getDigestJob" datasource="hermes">
    SELECT schedule, active, command
    FROM ofelia_jobs
    WHERE job_name = '[job-exec "hermes-quarantine-digest"]'
</cfquery>

<cfset digestSettings = StructNew()>
<cfloop query="getDigestSettings">
    <cfset digestSettings[parameter] = value2>
</cfloop>

<cfset digestEnabled = StructKeyExists(digestSettings, 'enabled') ? digestSettings['enabled'] : '0'>
<cfset digestFrequency = StructKeyExists(digestSettings, 'frequency') ? digestSettings['frequency'] : 'daily'>
<cfset digestTemplate = StructKeyExists(digestSettings, 'template') ? digestSettings['template'] : 'modern'>
<cfset digestSubject = StructKeyExists(digestSettings, 'subject') ? digestSettings['subject'] : '[Hermes SEG] Quarantine Digest'>
<cfset digestIntro = StructKeyExists(digestSettings, 'intro') ? digestSettings['intro'] : ''>
<cfset disableIndividual = StructKeyExists(digestSettings, 'disable_individual') ? digestSettings['disable_individual'] : '1'>
<cfset digestLastRun = StructKeyExists(digestSettings, 'last_run') ? digestSettings['last_run'] : ''>

<cfif digestFlash EQ "1">
<div class="alert alert-success alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-check"></i> Success</h5>
  Quarantine digest settings were saved successfully.
</div>
<cfset session.quarantineDigestFlash = "">
</cfif>

<div class="alert alert-info">
  <h5><i class="icon fas fa-info-circle"></i> About Quarantine Digest</h5>
  <p class="mb-2">This central notifier sends one digest email per recipient on the selected schedule instead of sending one message per quarantine event. Each digest email includes secure <strong>View</strong>, <strong>Release</strong>, and <strong>Block Sender</strong> links that work without requiring portal login.</p>
  <p class="mb-0"><strong>Scheduler endpoint:</strong> <code>http://localhost:8888/schedule/digestQuarantine.cfm?force</code> runs the digest immediately, emits verbose output, and ignores the normal time check.</p>
</div>

<div class="row">
  <div class="col-lg-8">
    <div class="card card-primary card-outline">
      <div class="card-header">
        <h3 class="card-title"><i class="fas fa-envelope-open-text me-2"></i>Digest Settings</h3>
      </div>
      <div class="card-body">
        <form method="post" action="view_quarantine_digest.cfm">
          <input type="hidden" name="action" value="save_digest_settings">
          <cfoutput><input type="hidden" name="csrf_token" value="#encodeForHTMLAttribute(session.quarantineDigestCsrf)#"></cfoutput>

          <div class="mb-3">
            <label class="form-label"><strong>Enable Quarantine Digest</strong></label>
            <select class="form-control" name="digest_enabled">
              <option value="1" <cfif digestEnabled EQ "1">selected</cfif>>Enabled</option>
              <option value="0" <cfif digestEnabled NEQ "1">selected</cfif>>Disabled</option>
            </select>
            <small class="text-muted">Hermes schedules this job for 7:00 PM based on the selected digest frequency.</small>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Digest Schedule</strong></label>
            <select class="form-control" name="digest_frequency">
              <option value="daily" <cfif digestFrequency EQ "daily">selected</cfif>>Daily</option>
              <option value="weekly" <cfif digestFrequency EQ "weekly">selected</cfif>>Weekly</option>
              <option value="monthly" <cfif digestFrequency EQ "monthly">selected</cfif>>Monthly</option>
            </select>
            <small class="text-muted">Daily runs at 7:00 PM, Weekly runs Friday at 7:00 PM, and Monthly runs at 7:00 PM during month-end dates (28-31, with month-end send gating).</small>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Email Template</strong></label>
            <select class="form-control" name="digest_template">
              <option value="modern" <cfif digestTemplate EQ "modern">selected</cfif>>Modern orange</option>
              <option value="classic" <cfif digestTemplate EQ "classic">selected</cfif>>Classic blue</option>
              <option value="compact" <cfif digestTemplate EQ "compact">selected</cfif>>Compact neutral</option>
            </select>
            <small class="text-muted">Templates keep the Hermes theme while changing the header and table styling.</small>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Email Subject</strong></label>
            <input type="text" class="form-control" name="digest_subject" maxlength="255" value="<cfoutput>#encodeForHTMLAttribute(digestSubject)#</cfoutput>">
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Short Email Intro Text</strong></label>
            <textarea class="form-control" name="digest_intro" rows="3" maxlength="255"><cfoutput>#encodeForHTML(digestIntro)#</cfoutput></textarea>
            <small class="text-muted">Short message shown above the quarantined-message table in the digest email. Stored in the compact parameters2 settings store, so it is limited to 255 characters.</small>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Individual Quarantine Notifications</strong></label>
            <select class="form-control" name="disable_individual">
              <option value="1" <cfif disableIndividual EQ "1">selected</cfif>>Disable individual notifications</option>
              <option value="0" <cfif disableIndividual EQ "0">selected</cfif>>Keep individual notifications enabled</option>
            </select>
          </div>

          <button type="submit" class="btn btn-primary">
            <i class="fas fa-save me-1"></i> Save Settings
          </button>
        </form>
      </div>
    </div>
  </div>

  <div class="col-lg-4">
    <div class="card card-outline card-secondary">
      <div class="card-header">
        <h3 class="card-title"><i class="fas fa-clock me-2"></i>Scheduler Status</h3>
      </div>
      <div class="card-body">
        <cfif getDigestJob.recordcount GTE 1>
          <p class="mb-2"><strong>Job schedule:</strong> <code><cfoutput>#encodeForHTML(getDigestJob.schedule)#</cfoutput></code></p>
          <p class="mb-2"><strong>Job status:</strong>
            <cfif Trim(getDigestJob.active) EQ "1">
              <span class="badge bg-success">Enabled</span>
            <cfelse>
              <span class="badge bg-secondary">Disabled</span>
            </cfif>
          </p>
          <p class="mb-2"><strong>Command:</strong><br><small><code><cfoutput>#encodeForHTML(getDigestJob.command)#</cfoutput></code></small></p>
        <cfelse>
          <div class="alert alert-warning mb-2">The Ofelia digest job is not seeded in this database yet.</div>
        </cfif>
        <p class="mb-0"><strong>Last digest run:</strong><br>
          <cfif digestLastRun NEQ "">
            <cfoutput>#encodeForHTML(digestLastRun)#</cfoutput>
          <cfelse>
            <span class="text-muted">Never</span>
          </cfif>
        </p>
      </div>
    </div>

    <div class="card card-outline card-info">
      <div class="card-header">
        <h3 class="card-title"><i class="fas fa-paint-brush me-2"></i>Template Notes</h3>
      </div>
      <div class="card-body">
        <ul class="mb-0">
          <li><strong>Modern:</strong> Hermes orange header with prominent action buttons.</li>
          <li><strong>Classic:</strong> Blue admin-style header with lighter tables.</li>
          <li><strong>Compact:</strong> Neutral styling for dense monthly digests.</li>
        </ul>
      </div>
    </div>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />
</div>
</body>
</html>
