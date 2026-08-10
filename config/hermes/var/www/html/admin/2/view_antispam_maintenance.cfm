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
  <title>Hermes SEG | Antispam Settings</title>
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
            <h1 class="m-0">Antispam Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Antispam Settings</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m") AND session.m NEQ "">
  <cfset m = session.m>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(form, "action") AND form.action NEQ "">
  <cfset action = form.action>
</cfif>

<!--- Load current settings --->
<cfinclude template="./inc/get_spam_settings.cfm">

<!--- Action routing --->
<cfif action EQ "save_settings">
  <cfinclude template="./inc/spam_settings_save.cfm">
<cfelseif action EQ "initpyzor">
  <cfinclude template="./inc/antispam_init_pyzor.cfm">
<cfelseif action EQ "initrazor">
  <cfinclude template="./inc/antispam_init_razor.cfm">
<cfelseif action EQ "clearbayes">
  <cfinclude template="./inc/antispam_clear_bayes.cfm">
</cfif>

<cfset session.m = "">

<!--- ===================== --->
<!--- ALERT MESSAGES --->
<!--- ===================== --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Settings Saved</h4>
    <p class="mb-0">Anti-spam settings have been saved and applied successfully.</p>
  </div>
<cfelseif m EQ 2>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Spam Subject Tag</h4>
    <p class="mb-0">Spam subject tag cannot be empty.</p>
  </div>
<cfelseif m EQ 3>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Bayes Spam Threshold</h4>
    <p class="mb-0">Bayes auto-learn spam threshold cannot be empty.</p>
  </div>
<cfelseif m EQ 4>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Bayes Spam Threshold</h4>
    <p class="mb-0">Bayes spam threshold must be greater than 0 and no more than 999.</p>
  </div>
<cfelseif m EQ 5>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Bayes Spam Threshold</h4>
    <p class="mb-0">Bayes spam threshold must be a valid number.</p>
  </div>
<cfelseif m EQ 7>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Bayes Non-Spam Threshold</h4>
    <p class="mb-0">Bayes auto-learn non-spam threshold cannot be empty.</p>
  </div>
<cfelseif m EQ 8>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Bayes Non-Spam Threshold</h4>
    <p class="mb-0">Bayes non-spam threshold must be less than 0 and no less than -999.</p>
  </div>
<cfelseif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Bayes Non-Spam Threshold</h4>
    <p class="mb-0">Bayes non-spam threshold must be a valid number.</p>
  </div>
<cfelseif m EQ 9>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Save Error</h4>
    <p class="mb-0">An error occurred while saving settings.
      <cfif StructKeyExists(session, "saveError") AND session.saveError NEQ "">
        <cfoutput><small><strong>Detail:</strong> #encodeForHTML(session.saveError)#</small></cfoutput>
        <cfset session.saveError = "">
      </cfif>
    </p>
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Pyzor Initialized</h4>
    <p class="mb-0">Pyzor initialized successfully.</p>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput NEQ "">
      <pre class="mt-2 mb-0 bg-light p-2 rounded"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Pyzor Initialization Failed</h4>
    <p class="mb-0">Pyzor was not able to initialize. Please ensure the system has connectivity to the Internet and try again.</p>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput NEQ "">
      <pre class="mt-2 mb-0 bg-light p-2 rounded"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
<cfelseif m EQ 13>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Razor Initialized</h4>
    <p class="mb-0">Vipul's Razor initialized and registered successfully.</p>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput NEQ "">
      <pre class="mt-2 mb-0 bg-light p-2 rounded"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
<cfelseif m EQ 14>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Razor Initialization Failed</h4>
    <p class="mb-0">Vipul's Razor was not able to initialize. Please ensure the system has connectivity to the Internet and try again.</p>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput NEQ "">
      <pre class="mt-2 mb-0 bg-light p-2 rounded"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
<cfelseif m EQ 15>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Bayes Database Cleared</h4>
    <p class="mb-0">Bayes database cleared successfully. SpamAssassin will need to re-learn from scratch.</p>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput NEQ "">
      <pre class="mt-2 mb-0 bg-light p-2 rounded"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
<cfelseif m EQ 16>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Bayes Clear Failed</h4>
    <p class="mb-0">An error occurred while clearing the Bayes database.</p>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput NEQ "">
      <pre class="mt-2 mb-0 bg-light p-2 rounded"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
</cfif>

<!--- ======================== --->
<!--- DCC AVAILABILITY PROBE --->
<!--- ======================== --->
<!--- DCC is deliberately absent from the published mail_filter image: its
     licence is free only to organisations that do not sell filtering devices or
     services except to their own users, and it forbids redistributing binaries
     (#292). Operators who qualify rebuild with WITH_DCC=true.

     Probe rather than hardcode a warning, so it disappears for anyone who has
     rebuilt. `ls` is used instead of `which` or a `sh -c` test because cfexecute
     is unreliable with quoting, pipes and redirects; this passes no shell
     metacharacters at all. The probed path is the one local.cf's dcc_path
     points at, so it answers the question that actually matters.
     Any failure is treated as "not present", which is the safe default. --->
<cfset dccAvailable = false>
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_mail_filter ls /usr/local/bin/dccproc"
        variable="dccProbeOut"
        errorVariable="dccProbeErr"
        timeout="30" />
    <cfif FindNoCase("dccproc", dccProbeOut) GT 0>
        <cfset dccAvailable = true>
    </cfif>
<cfcatch type="any">
    <cfset dccAvailable = false>
</cfcatch>
</cftry>

<!--- ======================== --->
<!--- SETTINGS FORM --->
<!--- ======================== --->
<form method="post" autocomplete="off">
  <input type="hidden" name="action" value="save_settings">

  <cfoutput>

  <!-- ===================== -->
  <!-- CARD 1: SPAM DETECTION PLUGINS -->
  <!-- ===================== -->
  <div class="card card-primary card-outline mb-4">
    <div class="card-header">
      <h3 class="card-title"><i class="fas fa-puzzle-piece"></i> Spam Detection Plugins</h3>
    </div>
    <div class="card-body">
      <p class="text-muted mb-3">Enable or disable third-party spam detection plugins used by SpamAssassin.</p>
      <div class="row">
        <div class="col-md-4 mb-3">
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" name="use_dcc" id="use_dcc" value="1"
              <cfif get_use_dcc.value EQ "1">checked</cfif>>
            <label class="form-check-label" for="use_dcc"><strong>DCC</strong>: Distributed Checksum Clearinghouse</label>
          </div>
          <small class="text-muted ms-4">Detects bulk mail via distributed checksums</small>
          <cfif NOT dccAvailable>
            <div class="alert alert-warning py-2 px-3 mt-2 mb-0 small">
              <i class="fas fa-exclamation-triangle"></i>
              <strong>Not installed.</strong> Enabling this has no effect until the mail
              filter container is rebuilt with DCC included. DCC is not in the published
              image because its licence is free only to organisations that do not sell
              filtering devices or services except to their own users, and it does not
              permit redistributing binaries. Most self-hosted operators qualify, and
              <code>docker-compose.yml</code> carries a commented build block for exactly
              this. See the
              <a href="https://docs.deeztek.com/books/administrator-guide/page/antispam-settings" target="_blank" rel="noopener">Antispam Settings documentation</a>.
            </div>
          </cfif>
        </div>
        <div class="col-md-4 mb-3">
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" name="use_razor2" id="use_razor2" value="1"
              <cfif get_use_razor2.value EQ "1">checked</cfif>>
            <label class="form-check-label" for="use_razor2"><strong>Razor2</strong>: Vipul's Razor v2</label>
          </div>
          <small class="text-muted ms-4">Collaborative spam identification network</small>
        </div>
        <div class="col-md-4 mb-3">
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" name="use_pyzor" id="use_pyzor" value="1"
              <cfif get_use_pyzor.value EQ "1">checked</cfif>>
            <label class="form-check-label" for="use_pyzor"><strong>Pyzor</strong></label>
          </div>
          <small class="text-muted ms-4">Collaborative spam detection and reporting</small>
        </div>
      </div>
    </div>
  </div>

  <!-- ===================== -->
  <!-- CARD 2: SUBJECT TAGGING -->
  <!-- ===================== -->
  <div class="card card-primary card-outline mb-4">
    <div class="card-header">
      <h3 class="card-title"><i class="fas fa-tag"></i> Subject Tagging</h3>
    </div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-6">
          <label for="sa_spam_subject_tag" class="form-label"><strong>Spam Subject Tag</strong></label>
          <input type="text" class="form-control" id="sa_spam_subject_tag" name="sa_spam_subject_tag"
            value="#encodeForHTML(get_spam_subject_tag.value)#" maxlength="50" required>
          <small class="text-muted">Text prepended to the subject line of messages identified as spam (e.g. <code>***SPAM***</code>)</small>
        </div>
      </div>
    </div>
  </div>

  <!-- ===================== -->
  <!-- CARD 3: MESSAGE HANDLING POLICIES -->
  <!-- ===================== -->
  <div class="card card-primary card-outline mb-4">
    <div class="card-header">
      <h3 class="card-title"><i class="fas fa-inbox"></i> Message Handling Policies</h3>
    </div>
    <div class="card-body">
      <p class="text-muted mb-3">Choose what happens to messages that match each filter category.</p>
      <div class="row">
        <div class="col-md-6 mb-3">
          <label class="form-label"><strong>Virus Messages</strong></label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="final_virus_destiny" id="virus_discard" value="D_DISCARD"
                <cfif get_final_virus_destiny.value EQ "D_DISCARD">checked</cfif>>
              <label class="form-check-label" for="virus_discard">Quarantine Only</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="final_virus_destiny" id="virus_bounce" value="D_BOUNCE"
                <cfif get_final_virus_destiny.value EQ "D_BOUNCE">checked</cfif>>
              <label class="form-check-label" for="virus_bounce">Quarantine &amp; Send DSN</label>
            </div>
          </div>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label"><strong>Banned File Messages</strong></label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="final_banned_destiny" id="banned_discard" value="D_DISCARD"
                <cfif get_final_banned_destiny.value EQ "D_DISCARD">checked</cfif>>
              <label class="form-check-label" for="banned_discard">Quarantine Only</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="final_banned_destiny" id="banned_bounce" value="D_BOUNCE"
                <cfif get_final_banned_destiny.value EQ "D_BOUNCE">checked</cfif>>
              <label class="form-check-label" for="banned_bounce">Quarantine &amp; Send DSN</label>
            </div>
          </div>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label"><strong>Spam Messages</strong></label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="final_spam_destiny" id="spam_discard" value="D_DISCARD"
                <cfif get_final_spam_destiny.value EQ "D_DISCARD">checked</cfif>>
              <label class="form-check-label" for="spam_discard">Quarantine Only</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="final_spam_destiny" id="spam_bounce" value="D_BOUNCE"
                <cfif get_final_spam_destiny.value EQ "D_BOUNCE">checked</cfif>>
              <label class="form-check-label" for="spam_bounce">Quarantine &amp; Send DSN</label>
            </div>
          </div>
        </div>
        <div class="col-md-6 mb-3">
          <label class="form-label"><strong>Bad-Header Messages</strong></label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="final_bad_header_destiny" id="badheader_discard" value="D_DISCARD"
                <cfif get_final_bad_header_destiny.value EQ "D_DISCARD">checked</cfif>>
              <label class="form-check-label" for="badheader_discard">Quarantine Only</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="final_bad_header_destiny" id="badheader_bounce" value="D_BOUNCE"
                <cfif get_final_bad_header_destiny.value EQ "D_BOUNCE">checked</cfif>>
              <label class="form-check-label" for="badheader_bounce">Quarantine &amp; Send DSN</label>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- ===================== -->
  <!-- CARD 4: BAYES DATABASE -->
  <!-- ===================== -->
  <div class="card card-primary card-outline mb-4">
    <div class="card-header">
      <h3 class="card-title"><i class="fas fa-brain"></i> Bayes Database</h3>
    </div>
    <div class="card-body">
      <p class="text-muted mb-3">SpamAssassin's statistical learning engine. Trains on your mail to improve detection accuracy over time.</p>
      <div class="row mb-3">
        <div class="col-md-6">
          <div class="form-check form-switch mb-2">
            <input class="form-check-input" type="checkbox" name="use_bayes" id="use_bayes" value="1"
              <cfif get_use_bayes.value EQ "1">checked</cfif> onchange="toggleBayes(this.checked)">
            <label class="form-check-label" for="use_bayes"><strong>Enable Bayes Database</strong></label>
          </div>
        </div>
      </div>
      <div id="bayes_options" <cfif get_use_bayes.value NEQ "1">style="display:none;"</cfif>>
        <div class="row mb-3">
          <div class="col-md-6">
            <div class="form-check form-switch">
              <input class="form-check-input" type="checkbox" name="bayes_auto_learn" id="bayes_auto_learn" value="1"
                <cfif get_bayes_auto_learn.value EQ "1">checked</cfif> onchange="toggleAutoLearn(this.checked)">
              <label class="form-check-label" for="bayes_auto_learn"><strong>Enable Auto-Learning</strong></label>
            </div>
            <small class="text-muted">Automatically trains the Bayes database based on threshold scores</small>
          </div>
        </div>
        <div id="autolearn_thresholds" <cfif get_bayes_auto_learn.value NEQ "1">style="display:none;"</cfif>>
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="bayes_auto_learn_threshold_spam" class="form-label"><strong>Spam Threshold</strong></label>
              <input type="number" class="form-control" id="bayes_auto_learn_threshold_spam"
                name="bayes_auto_learn_threshold_spam" step="0.01" min="0.01" max="999"
                value="#encodeForHTML(get_bayes_spam_threshold.value)#">
              <small class="text-muted">Must be &gt; 0 (e.g. 6.31)</small>
            </div>
            <div class="col-md-3 mb-3">
              <label for="bayes_auto_learn_threshold_nonspam" class="form-label"><strong>Non-Spam Threshold</strong></label>
              <input type="number" class="form-control" id="bayes_auto_learn_threshold_nonspam"
                name="bayes_auto_learn_threshold_nonspam" step="0.01" min="-999" max="-0.01"
                value="#encodeForHTML(get_bayes_nonspam_threshold.value)#">
              <small class="text-muted">Must be &lt; 0 (e.g. -0.1)</small>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  </cfoutput>

  <!-- SAVE BUTTON -->
  <div class="mb-4">
    <button type="submit" class="btn btn-primary btn-lg"
      onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving &amp; Applying...';this.form.submit();">
      <i class="fas fa-save"></i> Save &amp; Apply Settings
    </button>
  </div>

</form>

<hr class="my-4">
<h4 class="mb-3"><i class="fas fa-tools"></i> Maintenance</h4>

<!-- ===================== -->
<!-- CARD 5: INITIALIZE PYZOR -->
<!-- ===================== -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plug"></i> Initialize Pyzor</h3>
  </div>
  <div class="card-body">
    <p>Pyzor is a collaborative spam detection system. It must be initialized before it can be used. Click the button below to discover and ping Pyzor servers.</p>
    <form method="post">
      <input type="hidden" name="action" value="initpyzor">
      <button type="submit" class="btn btn-secondary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Initializing...';this.form.submit();">
        <i class="fas fa-plug"></i> Initialize Pyzor
      </button>
    </form>
  </div>
</div>

<!-- ===================== -->
<!-- CARD 6: INITIALIZE RAZOR -->
<!-- ===================== -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plug"></i> Initialize Razor</h3>
  </div>
  <div class="card-body">
    <p>Vipul's Razor requires all spam reporters to be registered so their reputations can be computed. This will create a new Razor configuration and register your server with the Razor network.</p>
    <form method="post">
      <input type="hidden" name="action" value="initrazor">
      <button type="submit" class="btn btn-secondary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Initializing...';this.form.submit();">
        <i class="fas fa-plug"></i> Initialize Razor
      </button>
    </form>
  </div>
</div>

<!-- ===================== -->
<!-- CARD 7: CLEAR BAYES DATABASE -->
<!-- ===================== -->
<div class="card card-warning card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-exclamation-triangle"></i> Clear Bayes Database</h3>
  </div>
  <div class="card-body">
    <div class="alert alert-warning mb-3">
      <i class="fas fa-exclamation-triangle"></i> <strong>Warning:</strong> This action cannot be undone. All learned spam/ham data will be permanently lost and SpamAssassin will need to re-learn from scratch.
    </div>
    <p>Occasionally the Bayes database can become corrupted or poisoned due to bad training. Clearing it resets SpamAssassin's learned data.</p>
    <form method="post" id="clearBayesForm">
      <input type="hidden" name="action" value="clearbayes">
      <button type="button" class="btn btn-danger"
        onclick="if(confirm('Are you sure you want to clear the Bayes database? This cannot be undone.')){this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Clearing...';document.getElementById('clearBayesForm').submit();}">
        <i class="fas fa-trash"></i> Clear Bayes Database
      </button>
    </form>
  </div>
</div>

      </div><!-- /.container-fluid -->
    </div><!-- /.content -->
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<script>
function toggleBayes(enabled) {
  document.getElementById('bayes_options').style.display = enabled ? '' : 'none';
}
function toggleAutoLearn(enabled) {
  document.getElementById('autolearn_thresholds').style.display = enabled ? '' : 'none';
}
</script>

</body>
</html>
