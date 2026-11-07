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

<!---
  Mail Import (#356). Pulls mail from another IMAP server into a Hermes mailbox.
  This page only records jobs. schedule/mail_import.cfm starts them.
--->

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Mail Import</title>
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
            <h1 class="m-0">Mail Import</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Email Server</li>
              <li class="breadcrumb-item active">Mail Import</li>
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
<cfif ListFind("add_import,edit_import,run_import,stop_import,delete_import", action)>
  <cfinclude template="./inc/mail_import_actions.cfm">
</cfif>

<!--- SUCCESS / ERROR MESSAGES --->
<cfset miMessages = {
  "1"  = "Import added. It starts within a minute.",
  "2"  = "Import queued. It starts within a minute.",
  "3"  = "Import stopped and the source password deleted. Mail already copied is kept.",
  "4"  = "Import removed. Mail already copied is kept.",
  "5"  = "Import saved. It starts within a minute."
}>
<cfset miErrors = {
  "10" = "Check the source host, port and encryption.",
  "11" = "Enter the source username and password.",
  "12" = "Check the import options. The timeout must be at least 30 seconds, the sync interval at least 15 minutes, and the Folder Prefix can only contain letters, numbers, dots, dashes, underscores and slashes.",
  "13" = "The target must be an active user mailbox.",
  "14" = "That mailbox already has an open import. Stop or delete it first.",
  "20" = "Missing required form fields.",
  "21" = "Import not found.",
  "22" = "That import cannot be run. Finished and stopped imports no longer hold the source password, so use Edit to enter it again.",
  "23" = "Stop the import before deleting it.",
  "24" = "Stop the import before editing it."
}>
<cfif StructKeyExists(miMessages, m)>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>#miMessages[m]#</cfoutput>
  </div>
<cfelseif StructKeyExists(miErrors, m)>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <cfoutput>#miErrors[m]#</cfoutput>
  </div>
</cfif>

<!--- HELP CALLOUT --->
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About Mail Import</h5>
  <p class="mb-1">Copies mail from another IMAP server into a Hermes mailbox. The source is only read, and mail already in the Hermes mailbox is kept. Repeat runs copy only what is new.</p>
  <p class="mb-0">The source password is stored encrypted and deleted when the import finishes or is stopped. Check that the mailbox quota can hold the source account before you start.</p>
</div>

<!-- Troubleshooting Commands (collapsible, same pattern as Intrusion Prevention) -->
<div class="card card-outline card-secondary mb-4">
    <div class="card-header">
        <h3 class="card-title">
            <button type="button" class="btn btn-sm btn-outline-secondary me-2" id="toggleMiTroubleshoot" title="Expand">
                <i class="fas fa-chevron-down"></i>
            </button>
            <i class="fas fa-terminal"></i> Troubleshooting Commands
        </h3>
    </div>
    <div class="collapse" id="miTroubleshoot">
        <div class="card-body">
        <p class="mb-2">Run these commands on the Docker host. Replace <code>user@domain.tld</code> with the Hermes mailbox and <code>imap.domain.tld</code> with the source server.</p>
        <div class="table-responsive">
            <table class="table table-sm table-bordered mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width: 40%;">Command</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>docker top hermes_dovecot | grep -E 'hermes_mail_import|mail_import_run'</code></td>
                        <td>Show import processes. A running import has a <code>mail_import_run.sh work</code> line and a <code>doveadm</code> line. Nothing printed means no import is running</td>
                    </tr>
                    <tr>
                        <td><code>docker exec hermes_dovecot sh -c 'cat /logs/mail_import/*.progress'</code></td>
                        <td>Show the message counts of a running import, refreshed every minute</td>
                    </tr>
                    <tr>
                        <td><code>docker exec hermes_dovecot sh -c 'tail -n 50 /logs/mail_import/*.log'</code></td>
                        <td>Show doveadm output of a running import. The file is removed once the result is recorded under <strong>Recent Runs</strong></td>
                    </tr>
                    <tr>
                        <td><code>docker exec hermes_dovecot doveadm mailbox status -u user@domain.tld messages '*'</code></td>
                        <td>Show the message count of each folder in the Hermes mailbox</td>
                    </tr>
                    <tr>
                        <td><code>docker exec hermes_dovecot doveadm quota get -u user@domain.tld</code></td>
                        <td>Show quota usage and limit of the Hermes mailbox, in KB</td>
                    </tr>
                    <tr>
                        <td><code>docker exec hermes_dovecot timeout 5 bash -c '&lt;/dev/tcp/imap.domain.tld/993' &amp;&amp; echo open</code></td>
                        <td>Check that Hermes can reach the source server. Use <code>143</code> for STARTTLS or no encryption</td>
                    </tr>
                    <tr>
                        <td><code>docker logs hermes_ofelia --tail 100 | grep mail-import</code></td>
                        <td>Check that the scheduler runs <code>hermes-mail-import</code> every minute</td>
                    </tr>
                    <tr>
                        <td><code>docker exec hermes_commandbox curl --silent http://localhost:8888/schedule/mail_import.cfm</code></td>
                        <td>Run the scheduler once now, without waiting for the next minute</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <p class="text-muted mt-2 mb-0"><small><i class="fas fa-info-circle"></i> <strong>Note:</strong> The error of a failed run is shown under <strong>Recent Runs</strong> and in the failure e-mail sent to the administrator.</small></p>
        </div>
    </div>
</div>

<cfquery name="getJobs" datasource="hermes">
  SELECT j.id, j.mailbox_id, j.source_host, j.source_port, j.source_ssl, j.verify_cert, j.source_username,
         j.exclude_folders, j.folder_prefix, j.imapc_features, j.since_days, j.max_message_mb, j.io_timeout,
         j.mode, j.interval_minutes, j.status, j.next_run_at, j.last_error, m.username,
         IF(j.source_password IS NULL, 0, 1) AS has_password,
         (SELECT MAX(r.ended_at) FROM mail_import_runs r WHERE r.job_id = j.id) AS last_run,
         (SELECT r.token FROM mail_import_runs r WHERE r.job_id = j.id AND r.ended_at IS NULL ORDER BY r.id DESC LIMIT 1) AS run_token
  FROM mail_import_jobs j
  LEFT JOIN mailboxes m ON m.id = j.mailbox_id
  ORDER BY j.created_at DESC, j.id DESC
</cfquery>

<cfquery name="getRuns" datasource="hermes">
  SELECT r.id, r.started_at, r.ended_at, r.exit_code, r.messages_before, r.messages_after, r.error_text,
         j.source_host, m.username
  FROM mail_import_runs r
  INNER JOIN mail_import_jobs j ON j.id = r.job_id
  LEFT JOIN mailboxes m ON m.id = j.mailbox_id
  ORDER BY r.id DESC
  LIMIT 50
</cfquery>

<cfquery name="getMailboxes" datasource="hermes">
  SELECT id, username FROM mailboxes
  WHERE active = 1 AND mailbox_type = 'user'
  ORDER BY username
</cfquery>

<!--- Progress of a running import, from the file the runner refreshes every
     minute. "Copied" is the growth of the target mailbox. The source total is
     only for scale: mail already in the mailbox is not copied again, so the
     two numbers need not meet. --->
<cffunction name="miProgressText" returntype="string" output="false">
  <cfargument name="token" type="string" required="true">
  <cfset var path = "/servicelogs/dovecot/mail_import/" & arguments.token & ".progress">
  <cfset var raw = "">
  <cfset var line = "">
  <cfset var values = {"before" = "", "now" = "", "source" = ""}>
  <cfset var text = "">
  <cfif NOT REFind("^[a-z0-9]{32}$", arguments.token) OR NOT FileExists(path)>
    <cfreturn "Reading the source account. This can take a few minutes on a large account.">
  </cfif>
  <cftry>
    <cffile action="read" file="#path#" variable="raw" charset="utf-8">
    <cfcatch><cfreturn ""></cfcatch>
  </cftry>
  <cfloop list="#raw#" delimiters="#Chr(10)#" index="line">
    <cfif ListLen(line, "=") EQ 2 AND StructKeyExists(values, ListFirst(line, "="))>
      <cfset values[ListFirst(line, "=")] = ListLast(line, "=")>
    </cfif>
  </cfloop>
  <cfif IsNumeric(values.before) AND IsNumeric(values.now)>
    <cfset text = NumberFormat(Max(0, values.now - values.before), ",") & " messages copied so far.">
  </cfif>
  <cfif IsNumeric(values.source)>
    <cfset text = ListAppend(text, "The source account holds about " & NumberFormat(values.source, ",") & " messages.", " ")>
  </cfif>
  <cfreturn text>
</cffunction>

<cfset miBadges = {queued = "bg-info", running = "bg-primary", finished = "bg-success", failed = "bg-danger", stopped = "bg-secondary"}>

<!--- ADD BUTTON --->
<div class="mb-3">
  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addImportModal" onclick="resetImportForm()"><i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Add Import</button>
</div>

<!--- JOBS --->
<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-file-import me-2"></i>Imports (<cfoutput>#getJobs.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <table id="importTable" class="table table-bordered table-striped" style="width:100%">
      <thead>
        <tr>
          <th>Actions</th>
          <th>Mailbox</th>
          <th>Source</th>
          <th>Mode</th>
          <th>Status</th>
          <th>Last Run</th>
          <th>Next Run</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getJobs">
        <tr>
          <td>
            <div class="dropdown">
              <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">Actions</button>
              <ul class="dropdown-menu">
                <cfif ListFind("queued,failed", status) AND has_password EQ 1>
                  <li><a class="dropdown-item" href="##" onclick="importAction('run_import', #id#); return false;"><i class="fas fa-play me-2"></i>Run Now</a></li>
                </cfif>
                <cfif status NEQ "running">
                  <li><a class="dropdown-item" href="##" onclick="editImport(this); return false;"
                      data-id="#id#"
                      data-mailbox="#mailbox_id#"
                      data-host="#EncodeForHTMLAttribute(source_host)#"
                      data-port="#source_port#"
                      data-ssl="#EncodeForHTMLAttribute(source_ssl)#"
                      data-verify="#Val(verify_cert)#"
                      data-user="#EncodeForHTMLAttribute(source_username)#"
                      data-has-password="#has_password#"
                      data-mode="#EncodeForHTMLAttribute(mode)#"
                      data-interval="#interval_minutes#"
                      data-excludes="#EncodeForHTMLAttribute(exclude_folders)#"
                      data-since="#since_days#"
                      data-max-mb="#max_message_mb#"
                      data-timeout="#io_timeout#"
                      data-prefix="#EncodeForHTMLAttribute(folder_prefix)#"
                      data-features="#EncodeForHTMLAttribute(imapc_features)#"><i class="fas fa-edit me-2"></i>Edit</a></li>
                </cfif>
                <cfif ListFind("queued,running,failed", status)>
                  <li><a class="dropdown-item" href="##" onclick="confirmImportAction('stop_import', #id#, '#JSStringFormat(username)#'); return false;"><i class="fas fa-stop me-2"></i>Stop</a></li>
                </cfif>
                <cfif status NEQ "running">
                  <li><a class="dropdown-item text-danger" href="##" onclick="confirmImportAction('delete_import', #id#, '#JSStringFormat(username)#'); return false;"><i class="fas fa-trash me-2"></i>Delete</a></li>
                </cfif>
              </ul>
            </div>
          </td>
          <td>#HTMLEditFormat(username)#</td>
          <td>#HTMLEditFormat(source_username)#<br><small class="text-muted">#HTMLEditFormat(source_host)#:#source_port#</small></td>
          <td><cfif mode EQ "repeat">Every #interval_minutes# minutes<cfelse>Once</cfif></td>
          <td>
            <span class="badge #StructKeyExists(miBadges, status) ? miBadges[status] : 'bg-secondary'#">#HTMLEditFormat(status)#</span>
            <cfif status EQ "running"><br><small class="text-muted">#HTMLEditFormat(miProgressText(run_token))#</small></cfif>
            <cfif Len(last_error)><br><small class="text-danger">#HTMLEditFormat(last_error)#</small></cfif>
          </td>
          <td><cfif Len(last_run)>#DateFormat(last_run, "yyyy-mm-dd")# #TimeFormat(last_run, "HH:mm")#</cfif></td>
          <td><cfif Len(next_run_at)>#DateFormat(next_run_at, "yyyy-mm-dd")# #TimeFormat(next_run_at, "HH:mm")#</cfif></td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>

<!--- RUN HISTORY --->
<div class="card mt-3">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-history me-2"></i>Recent Runs</h3>
  </div>
  <div class="card-body">
    <table id="runTable" class="table table-bordered table-striped" style="width:100%">
      <thead>
        <tr>
          <th>Started</th>
          <th>Ended</th>
          <th>Mailbox</th>
          <th>Source</th>
          <th>Messages Copied</th>
          <th>Result</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getRuns">
        <tr>
          <td>#DateFormat(started_at, "yyyy-mm-dd")# #TimeFormat(started_at, "HH:mm:ss")#</td>
          <td><cfif Len(ended_at)>#DateFormat(ended_at, "yyyy-mm-dd")# #TimeFormat(ended_at, "HH:mm:ss")#</cfif></td>
          <td>#HTMLEditFormat(username)#</td>
          <td>#HTMLEditFormat(source_host)#</td>
          <td><cfif IsNumeric(messages_after) AND IsNumeric(messages_before)>#messages_after - messages_before#</cfif></td>
          <td>
            <cfif NOT Len(ended_at)>
              <span class="badge bg-primary">running</span>
            <cfelseif Len(error_text)>
              <small class="text-danger">#HTMLEditFormat(error_text)#</small>
            <cfelse>
              <span class="badge bg-success">ok</span>
            </cfif>
          </td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>

<!--- Row actions post this form, so no table cell holds a form. --->
<form method="post" action="view_mail_import.cfm" id="importActionForm">
  <input type="hidden" name="action" id="importActionName">
  <input type="hidden" name="job_id" id="importActionJob">
</form>

<!--- ================================================================
     ADD IMPORT MODAL
     ================================================================ --->
<div class="modal fade" id="addImportModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" action="view_mail_import.cfm" autocomplete="off" id="importForm">
        <input type="hidden" name="action" id="importFormAction" value="add_import">
        <input type="hidden" name="job_id" id="importFormJob" value="">
        <div class="modal-header">
          <h5 class="modal-title" id="importModalTitle">Add Import</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <div class="form-group mb-3">
            <label><strong>Hermes Mailbox</strong></label>
            <select class="form-select" name="mailbox_id" id="importMailbox" required>
              <option value="">Select a mailbox</option>
              <cfoutput query="getMailboxes"><option value="#id#">#HTMLEditFormat(username)#</option></cfoutput>
            </select>
          </div>

          <div class="row">
            <div class="col-md-6 form-group mb-3">
              <label><strong>Source Host</strong></label>
              <input type="text" class="form-control" name="source_host" maxlength="255" pattern="[A-Za-z0-9._\-]+" placeholder="imap.domain.tld" required>
            </div>
            <div class="col-md-3 form-group mb-3">
              <label><strong>Encryption</strong></label>
              <select class="form-select" name="source_ssl" id="sourceSsl">
                <option value="imaps" selected>SSL/TLS</option>
                <option value="starttls">STARTTLS</option>
                <option value="no">None</option>
              </select>
            </div>
            <div class="col-md-3 form-group mb-3">
              <label><strong>Port</strong></label>
              <input type="number" class="form-control" name="source_port" id="sourcePort" min="1" max="65535" value="993" required>
            </div>
          </div>

          <div class="alert alert-warning d-none" id="noEncryptionWarning">
            <strong>Important:</strong> With no encryption, the password and all mail cross the network in clear text.
          </div>

          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" name="verify_cert" id="verifyCert" value="1" checked>
            <label class="form-check-label" for="verifyCert">Verify the server certificate</label>
          </div>

          <div class="row">
            <div class="col-md-6 form-group mb-3">
              <label><strong>Source Username</strong></label>
              <input type="text" class="form-control" name="source_username" maxlength="255" autocomplete="off" required>
            </div>
            <div class="col-md-6 form-group mb-3">
              <label><strong>Source Password</strong></label>
              <input type="password" class="form-control" name="source_password" id="importPassword" autocomplete="new-password" required>
              <small class="text-muted d-block d-none" id="importPasswordHint"></small>
              <small class="text-muted">Gmail and similar providers need an app password.</small>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6 form-group mb-3">
              <label><strong>Mode</strong></label>
              <select class="form-select" name="mode" id="importMode">
                <option value="once" selected>Once</option>
                <option value="repeat">Keep syncing until stopped</option>
              </select>
            </div>
            <div class="col-md-6 form-group mb-3 d-none" id="intervalGroup">
              <label><strong>Sync Interval (minutes)</strong></label>
              <input type="number" class="form-control" name="interval_minutes" min="15" max="99999" value="60">
            </div>
          </div>

          <div class="form-group mb-3">
            <label><strong>Exclude Folders</strong></label>
            <textarea class="form-control" name="exclude_folders" rows="3">[Gmail]/All Mail
[Gmail]/Important
[Gmail]/Starred</textarea>
            <small class="text-muted">One per line. The Gmail folders are excluded by default because they hold copies of mail in other folders.</small>
          </div>

          <p class="mb-2"><a data-bs-toggle="collapse" href="#importAdvanced" role="button"><i class="fas fa-sliders-h me-1"></i>Advanced Options</a></p>
          <div class="collapse" id="importAdvanced">

            <div class="row">
              <div class="col-md-4 form-group mb-3">
                <label><strong>Skip Mail Older Than (days)</strong></label>
                <input type="number" class="form-control" name="since_days" min="0" max="36500" value="0">
                <small class="text-muted">0 copies everything.</small>
              </div>
              <div class="col-md-4 form-group mb-3">
                <label><strong>Skip Mail Larger Than (MB)</strong></label>
                <input type="number" class="form-control" name="max_message_mb" min="0" max="999999" value="0">
                <small class="text-muted">0 copies everything.</small>
              </div>
              <div class="col-md-4 form-group mb-3">
                <label><strong>Timeout (seconds)</strong></label>
                <input type="number" class="form-control" name="io_timeout" min="30" max="99999" value="600">
              </div>
            </div>

            <div class="form-group mb-3">
              <label><strong>Folder Prefix</strong></label>
              <input type="text" class="form-control" name="folder_prefix" maxlength="100" pattern="[A-Za-z0-9._/\-]*" placeholder="INBOX.">
              <small class="text-muted">Only if the source server keeps all folders under a prefix.</small>
            </div>

            <label><strong>Compatibility Switches</strong></label>
            <small class="text-muted d-block mb-2">Leave these off unless an import fails against a specific server.</small>
            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="imapc_features" id="featExamine" value="no-examine">
              <label class="form-check-label" for="featExamine">Use SELECT instead of EXAMINE (Courier)</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="imapc_features" id="featQresync" value="no-qresync">
              <label class="form-check-label" for="featQresync">Disable QRESYNC (Zimbra)</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="imapc_features" id="featZimbra" value="zimbra-workarounds">
              <label class="form-check-label" for="featZimbra">Zimbra message fetch workaround</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="checkbox" name="imapc_features" id="featModseq" value="no-modseq">
              <label class="form-check-label" for="featModseq">Disable MODSEQ</label>
            </div>
            <div class="form-check mb-3">
              <input class="form-check-input" type="checkbox" name="imapc_features" id="featMsn" value="fetch-msn-workarounds">
              <label class="form-check-label" for="featMsn">Ignore wrong message sequence numbers</label>
            </div>

          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary" id="importSubmit">Add Import</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ================================================================
     CONFIRMATION MODAL
     ================================================================ --->
<div class="modal fade" id="confirmImportModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="confirmImportTitle"></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p id="confirmImportText"></p>
        <p class="mb-0">Mail already copied into <strong id="confirmImportMailbox"></strong> is kept.</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-danger" id="confirmImportButton"></button>
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

<script>
  var pendingImportAction = null;

  // Fetch the page in the background and swap in the rows of both tables, so
  // nothing flashes and the page stays where it is. Never over an open form or
  // menu. DOMParser is used because it does not run the fetched page's scripts.
  // Polls for as long as the page is open: a repeat job sits at "queued"
  // between runs and finishes in seconds, so there is no safe point to stop.
  setInterval(function() {
    if ($('.modal.show, .dropdown-menu.show').length > 0) {
      return;
    }
    $.ajax({ url: 'view_mail_import.cfm', cache: false }).done(function(html) {
      var fresh = new DOMParser().parseFromString(html, 'text/html');
      if (!fresh.getElementById('importTable')) {
        window.location.href = 'view_mail_import.cfm';
        return;
      }
      if ($('.modal.show, .dropdown-menu.show').length > 0) {
        return;
      }
      ['importTable', 'runTable'].forEach(function(id) {
        var table = $('#' + id).DataTable();
        table.clear();
        table.rows.add($(fresh).find('#' + id + ' tbody tr'));
        table.draw(false);
      });
    });
  }, 30000);

  $(document).ready(function() {
    // Troubleshooting Commands collapsible (chevron down/up)
    $('#toggleMiTroubleshoot').on('click', function() { $('#miTroubleshoot').collapse('toggle'); });
    $('#miTroubleshoot').on('shown.bs.collapse', function() {
      $('#toggleMiTroubleshoot').find('i').removeClass('fa-chevron-down').addClass('fa-chevron-up');
      $('#toggleMiTroubleshoot').attr('title', 'Collapse');
    });
    $('#miTroubleshoot').on('hidden.bs.collapse', function() {
      $('#toggleMiTroubleshoot').find('i').removeClass('fa-chevron-up').addClass('fa-chevron-down');
      $('#toggleMiTroubleshoot').attr('title', 'Expand');
    });
    $('#importTable').DataTable({
      "order": [],
      "pageLength": 25,
      "stateSave": true,
      "columnDefs": [ { "orderable": false, "targets": [0] } ]
    });
    $('#runTable').DataTable({
      "order": [[0, "desc"]],
      "pageLength": 10
    });

    // Follow the encryption choice, unless the admin typed their own port.
    $('#sourceSsl').on('change', function() {
      var port = $('#sourcePort');
      if (port.val() === '993' || port.val() === '143') {
        port.val($(this).val() === 'imaps' ? '993' : '143');
      }
      $('#noEncryptionWarning').toggleClass('d-none', $(this).val() !== 'no');
    });

    $('#importMode').on('change', function() {
      $('#intervalGroup').toggleClass('d-none', $(this).val() !== 'repeat');
    });

    $('#confirmImportButton').on('click', function() {
      importAction(pendingImportAction.name, pendingImportAction.id);
    });
  });

  function resetImportForm() {
    $('#importForm')[0].reset();
    $('#importFormAction').val('add_import');
    $('#importFormJob').val('');
    $('#importModalTitle').text('Add Import');
    $('#importSubmit').text('Add Import');
    $('#importMailbox').prop('disabled', false);
    $('#importPassword').prop('required', true);
    $('#importPasswordHint').addClass('d-none').text('');
    $('#intervalGroup').addClass('d-none');
    $('#noEncryptionWarning').addClass('d-none');
  }

  // The mailbox is shown but not sent: an edit keeps it. The password field
  // stays empty, because the stored password is never sent to the page.
  function editImport(link) {
    var job = $(link);
    var form = $('#importForm');
    var features = (job.attr('data-features') || '').split(' ');
    var hasPassword = job.attr('data-has-password') === '1';

    resetImportForm();
    $('#importFormAction').val('edit_import');
    $('#importFormJob').val(job.attr('data-id'));
    $('#importModalTitle').text('Edit Import');
    $('#importSubmit').text('Save and Run');
    $('#importMailbox').val(job.attr('data-mailbox')).prop('disabled', true);

    form.find('[name=source_host]').val(job.attr('data-host'));
    form.find('[name=source_port]').val(job.attr('data-port'));
    $('#sourceSsl').val(job.attr('data-ssl'));
    $('#noEncryptionWarning').toggleClass('d-none', job.attr('data-ssl') !== 'no');
    $('#verifyCert').prop('checked', job.attr('data-verify') === '1');
    form.find('[name=source_username]').val(job.attr('data-user'));
    $('#importMode').val(job.attr('data-mode')).trigger('change');
    form.find('[name=interval_minutes]').val(job.attr('data-interval'));
    form.find('[name=exclude_folders]').val(job.attr('data-excludes'));
    form.find('[name=since_days]').val(job.attr('data-since'));
    form.find('[name=max_message_mb]').val(job.attr('data-max-mb'));
    form.find('[name=io_timeout]').val(job.attr('data-timeout'));
    form.find('[name=folder_prefix]').val(job.attr('data-prefix'));
    form.find('[name=imapc_features]').each(function() {
      this.checked = features.indexOf(this.value) !== -1;
    });

    $('#importPassword').prop('required', !hasPassword);
    $('#importPasswordHint').removeClass('d-none').text(hasPassword
      ? 'Leave blank to keep the stored password.'
      : 'The stored password was deleted when this import ended. Enter it again.');

    bootstrap.Modal.getOrCreateInstance(document.getElementById('addImportModal')).show();
  }

  function importAction(name, id) {
    $('#importActionName').val(name);
    $('#importActionJob').val(id);
    $('#importActionForm').submit();
  }

  function confirmImportAction(name, id, mailbox) {
    var stopping = (name === 'stop_import');
    pendingImportAction = { name: name, id: id };
    $('#confirmImportTitle').text(stopping ? 'Stop Import' : 'Delete Import');
    $('#confirmImportText').text(stopping
      ? 'Stop this import and delete its source password?'
      : 'Delete this import and its run history?');
    $('#confirmImportMailbox').text(mailbox);
    $('#confirmImportButton').text(stopping ? 'Stop' : 'Delete');
    new bootstrap.Modal(document.getElementById('confirmImportModal')).show();
  }
</script>

</html>
