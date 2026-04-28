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
ADMIN: PER-MAILBOX APP PASSWORDS (#197 Phase 1)
Lets the admin list/create/revoke app passwords on behalf of a single
mailbox. Reached from view_mailboxes.cfm row actions ("Manage App
Passwords"). Mirrors users/2/view_app_passwords.cfm but scoped to a
specific mailbox via ?mailbox_id=N.
--->

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Mailbox App Passwords</title>
  <cfinclude template="./inc/html_head.cfm" />
</head>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">

<cfparam name="url.mailbox_id" default="">
<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m") AND session.m IS NOT "">
  <cfset m = session.m>
  <cfset session.m = "">
</cfif>
<cfif StructKeyExists(form, "action") AND form.action IS NOT "">
  <cfset action = form.action>
</cfif>

<!--- Validate mailbox_id and resolve mailbox row.
     For action handler invocations, mailbox_id may also come via form. --->
<cfset _mailboxIdEffective = "">
<cfif IsNumeric(url.mailbox_id)>
    <cfset _mailboxIdEffective = url.mailbox_id>
<cfelseif StructKeyExists(form, "mailbox_id") AND IsNumeric(form.mailbox_id)>
    <cfset _mailboxIdEffective = form.mailbox_id>
</cfif>

<cfif _mailboxIdEffective EQ "">
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfquery name="theMailbox" datasource="hermes">
    SELECT id, username, name
    FROM mailboxes
    WHERE id = <cfqueryparam value="#_mailboxIdEffective#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif theMailbox.recordCount EQ 0>
    <cflocation url="view_mailboxes.cfm" addtoken="no">
</cfif>

<cfset _mbUsername = theMailbox.username>
<cfset _mbDisplayName = theMailbox.name>

<!--- ACTION HANDLER --->
<cfif action EQ "create" OR action EQ "revoke">
  <cfinclude template="./inc/admin_app_password_actions.cfm">
</cfif>

    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-8">
            <h1 class="m-0">App Passwords for <cfoutput>#HTMLEditFormat(_mbUsername)#</cfoutput></h1>
          </div>
          <div class="col-sm-4">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item"><a href="view_mailboxes.cfm">Mailboxes</a></li>
              <li class="breadcrumb-item active">App Passwords</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<!--- Status alerts --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    App password created. <strong>Copy it now</strong> &mdash; it will not be shown again.
  </div>
<cfelseif m EQ 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    App password revoked.
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Label is required and must be 100 characters or less.
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid app password id.
  </div>
<cfelseif m EQ 30>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Could not generate the app password hash. Please try again.
  </div>
<cfelseif m EQ 31>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Could not save the app password.
  </div>
<cfelseif m EQ 32>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Could not register the app password with Nextcloud (calendar / contacts integration).<cfif StructKeyExists(session, "adminNewAppPasswordError") AND session.adminNewAppPasswordError NEQ ""> <small>(<cfoutput>#HTMLEditFormat(session.adminNewAppPasswordError)#</cfoutput>)</small><cfset session.adminNewAppPasswordError = ""></cfif>
  </div>
</cfif>

<!--- One-shot plaintext display, scoped to this mailbox.
     If session has a stashed password but for a DIFFERENT user,
     don't show it here (defensive against navigation between mailbox
     pages). Clear immediately after rendering. --->
<cfif StructKeyExists(session, "adminNewAppPasswordPlain") AND session.adminNewAppPasswordPlain IS NOT ""
      AND StructKeyExists(session, "adminNewAppPasswordUser") AND session.adminNewAppPasswordUser EQ _mbUsername>

  <cfset oneShotPlain = session.adminNewAppPasswordPlain>
  <cfset oneShotLabel = session.adminNewAppPasswordLabel>
  <cfset session.adminNewAppPasswordPlain = "">
  <cfset session.adminNewAppPasswordLabel = "">
  <cfset session.adminNewAppPasswordUser  = "">

  <div class="callout callout-warning">
    <h4><i class="fa fa-key"></i>&nbsp;&nbsp;New app password created</h4>
    <p>Below is the password for <strong><cfoutput>#HTMLEditFormat(oneShotLabel)#</cfoutput></strong>
       (mailbox <code><cfoutput>#HTMLEditFormat(_mbUsername)#</cfoutput></code>).
       Copy it and pass it to the user through a secure channel.
       <strong>It cannot be retrieved later</strong> &mdash; not even from the database
       (only the bcrypt hash is stored).</p>
    <div class="input-group" style="max-width: 600px;">
      <input type="text" id="adminNewAppPasswordField" readonly
             class="form-control font-monospace"
             value="<cfoutput>#oneShotPlain#</cfoutput>">
      <button type="button" class="btn btn-primary" onclick="copyAdminAppPassword()">
        <i class="fa fa-copy"></i>&nbsp;&nbsp;Copy
      </button>
    </div>
  </div>
</cfif>

<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About App Passwords (Admin)</h5>
  <p class="mb-1">App passwords are device-specific credentials this user uses for IMAP/SMTP
     authentication (and, after #197 Phase 1b, for CalDAV/CardDAV). Each password is
     30 characters and stored as a bcrypt hash &mdash; admins cannot see the plaintext
     of an existing password, only mint a new one or revoke.</p>
  <p class="mb-0"><small>The user can self-manage these from the user portal at
     <code>/users/2/view_app_passwords.cfm</code>. Use this admin page when troubleshooting
     or when handing off an Initial Setup credential during onboarding.</small></p>
</div>

<!--- Admin sees ALL rows including is_system = 1 rows (the "Hermes System"
     plumbing). System rows render with a badge in the table. --->
<cfquery name="getActive" datasource="hermes">
    SELECT id, label, created_at, last_used_at, is_system
    FROM app_passwords
    WHERE username = <cfqueryparam value="#_mbUsername#" cfsqltype="cf_sql_varchar">
      AND revoked_at IS NULL
    ORDER BY is_system DESC, created_at DESC
</cfquery>

<cfquery name="getRevoked" datasource="hermes">
    SELECT id, label, created_at, last_used_at, revoked_at, is_system
    FROM app_passwords
    WHERE username = <cfqueryparam value="#_mbUsername#" cfsqltype="cf_sql_varchar">
      AND revoked_at IS NOT NULL
    ORDER BY revoked_at DESC
    LIMIT 50
</cfquery>

<div class="mb-3">
  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createAdminModal">
    <i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Create App Password
  </button>
  <a href="view_mailboxes.cfm" class="btn btn-secondary">
    <i class="fa fa-arrow-left"></i>&nbsp;&nbsp;Back to Mailboxes
  </a>
</div>

<div class="card">
  <div class="card-header">
    <h3 class="card-title">Active App Passwords</h3>
  </div>
  <div class="card-body p-0">
    <cfif getActive.recordCount EQ 0>
      <div class="p-3 text-muted">
        This mailbox has no active app passwords.
      </div>
    <cfelse>
      <table class="table table-hover mb-0">
        <thead>
          <tr>
            <th>Label</th>
            <th>Created</th>
            <th>Last Used</th>
            <th class="text-end">Action</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getActive">
          <tr>
            <td>
              #HTMLEditFormat(label)#
              <cfif Val(is_system) EQ 1>
                <span class="badge bg-secondary ms-1" title="System credential — used internally for NC Mail. Revoking will break webmail until regenerated.">System</span>
              </cfif>
            </td>
            <td>#DateFormat(created_at, "yyyy-mm-dd")# #TimeFormat(created_at, "HH:mm")#</td>
            <td>
              <cfif IsDate(last_used_at)>
                #DateFormat(last_used_at, "yyyy-mm-dd")# #TimeFormat(last_used_at, "HH:mm")#
              <cfelse>
                <span class="text-muted">never</span>
              </cfif>
            </td>
            <td class="text-end">
              <button type="button" class="btn btn-sm btn-danger"
                onclick="confirmAdminRevoke(#id#, '#JSStringFormat(label)#')">
                <i class="fa fa-ban"></i>&nbsp;Revoke
              </button>
            </td>
          </tr>
          </cfoutput>
        </tbody>
      </table>
    </cfif>
  </div>
</div>

<cfif getRevoked.recordCount GT 0>
<div class="card mt-3">
  <div class="card-header">
    <h3 class="card-title">Revoked (most recent 50)</h3>
    <div class="card-tools">
      <button type="button" class="btn btn-tool" data-bs-toggle="collapse"
        data-bs-target="#revokedAdminBody" aria-expanded="false">
        <i class="fas fa-plus"></i>
      </button>
    </div>
  </div>
  <div id="revokedAdminBody" class="collapse">
    <div class="card-body p-0">
      <table class="table table-sm mb-0">
        <thead>
          <tr>
            <th>Label</th>
            <th>Created</th>
            <th>Revoked</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getRevoked">
          <tr class="text-muted">
            <td>
              #HTMLEditFormat(label)#
              <cfif Val(is_system) EQ 1>
                <span class="badge bg-secondary ms-1">System</span>
              </cfif>
            </td>
            <td>#DateFormat(created_at, "yyyy-mm-dd")#</td>
            <td>#DateFormat(revoked_at, "yyyy-mm-dd")# #TimeFormat(revoked_at, "HH:mm")#</td>
          </tr>
          </cfoutput>
        </tbody>
      </table>
    </div>
  </div>
</div>
</cfif>

<!--- Create modal --->
<div class="modal fade" id="createAdminModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_mailbox_app_passwords.cfm">
        <input type="hidden" name="action" value="create">
        <input type="hidden" name="mailbox_id" value="<cfoutput>#_mailboxIdEffective#</cfoutput>">
        <div class="modal-header">
          <h5 class="modal-title">Create App Password for <cfoutput>#HTMLEditFormat(_mbUsername)#</cfoutput></h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="adminLabelInput" class="form-label">Label</label>
            <input type="text" class="form-control" id="adminLabelInput" name="label"
              maxlength="100" required
              placeholder="e.g. Hermes System, Replacement, Onboarding">
            <small class="text-muted">A name that helps identify this credential later.
              The plaintext password will be shown once on the next page &mdash; copy it
              before navigating away.</small>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Create</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- Revoke confirmation modal --->
<div class="modal fade" id="revokeAdminModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_mailbox_app_passwords.cfm">
        <input type="hidden" name="action" value="revoke">
        <input type="hidden" name="mailbox_id" value="<cfoutput>#_mailboxIdEffective#</cfoutput>">
        <input type="hidden" name="id" id="revokeAdminId" value="">
        <div class="modal-header">
          <h5 class="modal-title">Revoke App Password</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Revoke <strong id="revokeAdminLabel"></strong> for
             <code><cfoutput>#HTMLEditFormat(_mbUsername)#</cfoutput></code>?</p>
          <p class="text-danger mb-0">
            <i class="fa fa-exclamation-triangle"></i>
            The device using this password will be locked out immediately. This cannot be undone.
          </p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Revoke</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
function copyAdminAppPassword() {
  var fld = document.getElementById('adminNewAppPasswordField');
  fld.select();
  fld.setSelectionRange(0, 99999);
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(fld.value);
  } else {
    document.execCommand('copy');
  }
}

function confirmAdminRevoke(id, label) {
  document.getElementById('revokeAdminId').value = id;
  document.getElementById('revokeAdminLabel').textContent = label;
  var modal = new bootstrap.Modal(document.getElementById('revokeAdminModal'));
  modal.show();
}
</script>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />
</div>
</body>
</html>
