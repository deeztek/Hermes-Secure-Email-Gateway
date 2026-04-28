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
MY APP PASSWORDS (#197 Phase 1)
End-user portal page for managing per-device app passwords used by mail
clients (IMAP/SMTP) and DAV clients to authenticate without exposing the
user's main login password.

See docs/admin/authentication/01-credential-model.md for the architectural
context, and docs/users/app-passwords/01-what-are-they.md for the user-
facing explanation that this UI corresponds to.
--->

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | My App Passwords</title>
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
            <h1 class="m-0">My App Passwords</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item active">My App Passwords</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfif NOT session.theGroups CONTAINS "mailboxes">
  <div class="alert alert-warning">
    <h4><i class="icon fas fa-exclamation-triangle"></i> Not Available</h4>
    <p class="mb-0">App passwords are only available for mailbox users.</p>
  </div>
<cfelse>

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m") AND session.m IS NOT "">
  <cfset m = session.m>
  <cfset session.m = "">
</cfif>
<cfif StructKeyExists(form, "action") AND form.action IS NOT "">
  <cfset action = form.action>
</cfif>

<cfif action EQ "create" OR action EQ "revoke">
  <cfinclude template="./inc/app_password_actions.cfm">
</cfif>

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
    Could not generate the app password hash. Please try again or contact your administrator.
  </div>
<cfelseif m EQ 31>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Could not save the app password. Please try again or contact your administrator.
  </div>
<cfelseif m EQ 32>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Could not register the app password with Nextcloud (calendar / contacts integration). Please try again or contact your administrator.<cfif StructKeyExists(session, "newAppPasswordError") AND session.newAppPasswordError NEQ ""> <small>(<cfoutput>#HTMLEditFormat(session.newAppPasswordError)#</cfoutput>)</small><cfset session.newAppPasswordError = ""></cfif>
  </div>
</cfif>

<!--- One-shot plaintext display. We render the plaintext from session
     exactly once and clear it immediately, so a refresh / back-button
     hit never re-shows it. --->
<cfif StructKeyExists(session, "newAppPasswordPlain") AND session.newAppPasswordPlain IS NOT "">
  <cfset oneShotPlain = session.newAppPasswordPlain>
  <cfset oneShotLabel = session.newAppPasswordLabel>
  <cfset session.newAppPasswordPlain = "">
  <cfset session.newAppPasswordLabel = "">

  <div class="callout callout-warning">
    <h4><i class="fa fa-key"></i>&nbsp;&nbsp;Your new app password</h4>
    <p>Below is the password for <strong><cfoutput>#HTMLEditFormat(oneShotLabel)#</cfoutput></strong>.
       <strong>Copy it now</strong> &mdash; once you leave this page or refresh,
       it cannot be retrieved. Even an administrator cannot recover it.</p>
    <div class="input-group" style="max-width: 600px;">
      <input type="text" id="newAppPasswordField" readonly
             class="form-control font-monospace"
             value="<cfoutput>#oneShotPlain#</cfoutput>">
      <button type="button" class="btn btn-primary" onclick="copyAppPassword()">
        <i class="fa fa-copy"></i>&nbsp;&nbsp;Copy
      </button>
    </div>
    <p class="mt-2 mb-0"><small>If you lose this password, just revoke this row and create a new one.</small></p>
  </div>
</cfif>

<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About App Passwords</h5>
  <p class="mb-1">It's recommended that each app password be device-specific &mdash; create a
     separate one for each phone, tablet, or computer that needs to access your mail,
     calendar, or contacts. That way if you lose a device you can revoke just its app
     password and your other devices and main login are not affected.</p>
  <p class="mb-0"><small>Each password is 30 characters and shown only at creation. You will
     not need to type it manually after setup &mdash; your device stores it.</small></p>
</div>

<!--- is_system = 1 rows are admin-managed plumbing (e.g. "Hermes System"
     used internally by NC Mail). Hidden from the user portal so users
     can't accidentally revoke them and break webmail. --->
<cfquery name="getActive" datasource="hermes">
    SELECT id, label, created_at, last_used_at
    FROM app_passwords
    WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
      AND revoked_at IS NULL
      AND is_system = 0
    ORDER BY created_at DESC
</cfquery>

<cfquery name="getRevoked" datasource="hermes">
    SELECT id, label, created_at, last_used_at, revoked_at
    FROM app_passwords
    WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
      AND revoked_at IS NOT NULL
      AND is_system = 0
    ORDER BY revoked_at DESC
    LIMIT 50
</cfquery>

<div class="mb-3">
  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createModal">
    <i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Create App Password
  </button>
</div>

<div class="card">
  <div class="card-header">
    <h3 class="card-title">Active App Passwords</h3>
  </div>
  <div class="card-body p-0">
    <cfif getActive.recordCount EQ 0>
      <div class="p-3 text-muted">
        You have no active app passwords. Click <strong>Create App Password</strong> above to add one.
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
            <td>#HTMLEditFormat(label)#</td>
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
                onclick="confirmRevoke(#id#, '#JSStringFormat(label)#')">
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
        data-bs-target="#revokedBody" aria-expanded="false">
        <i class="fas fa-plus"></i>
      </button>
    </div>
  </div>
  <div id="revokedBody" class="collapse">
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
            <td>#HTMLEditFormat(label)#</td>
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
<div class="modal fade" id="createModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_app_passwords.cfm">
        <input type="hidden" name="action" value="create">
        <div class="modal-header">
          <h5 class="modal-title">Create App Password</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="labelInput" class="form-label">Label</label>
            <input type="text" class="form-control" id="labelInput" name="label"
              maxlength="100" required
              placeholder="e.g. iPhone, Thunderbird, Laptop">
            <small class="text-muted">Use a name that helps you identify the device or app
              later if you need to revoke it.</small>
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

<!--- Revoke confirmation modal (filled in by JS) --->
<div class="modal fade" id="revokeModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_app_passwords.cfm">
        <input type="hidden" name="action" value="revoke">
        <input type="hidden" name="id" id="revokeId" value="">
        <div class="modal-header">
          <h5 class="modal-title">Revoke App Password</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Revoke <strong id="revokeLabel"></strong>?</p>
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
function copyAppPassword() {
  var fld = document.getElementById('newAppPasswordField');
  fld.select();
  fld.setSelectionRange(0, 99999);
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(fld.value);
  } else {
    document.execCommand('copy');
  }
}

function confirmRevoke(id, label) {
  document.getElementById('revokeId').value = id;
  document.getElementById('revokeLabel').textContent = label;
  var modal = new bootstrap.Modal(document.getElementById('revokeModal'));
  modal.show();
}
</script>

</cfif><!--- end mailboxes group check --->

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />
</div>
</body>
</html>
