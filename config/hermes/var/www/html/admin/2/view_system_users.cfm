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
  <title>Hermes SEG | System Users</title>
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
            <h1 class="m-0">System Users</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">System Users</li>
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
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION ROUTING --->
<cfif action is not "">
  <cfinclude template="./inc/system_user_actions.cfm">
</cfif>

<!--- Load system users --->
<cfquery name="getsystemusers" datasource="hermes">
  SELECT id, username, email, first_name, last_name, access_control, system, applied, auth_type, remoteauth_domain
  FROM system_users
</cfquery>

<!--- Check RemoteAuth availability (Pro edition) --->
<cfset remoteauthAvailable = false>
<cfset remoteauthDomains = []>
<cfif isDefined("session.edition") AND session.edition EQ "Pro">
  <cfquery name="getRemoteauthStatus" datasource="hermes">
    SELECT setting_value FROM remoteauth_settings WHERE setting_name = 'enabled'
  </cfquery>
  <cfquery name="getRemoteauthDomains" datasource="hermes">
    SELECT domain_name, server_address FROM remoteauth_mappings WHERE enabled = 1 ORDER BY domain_name
  </cfquery>
  <cfif getRemoteauthStatus.recordcount GT 0 AND getRemoteauthStatus.setting_value EQ "1" AND getRemoteauthDomains.recordcount GT 0>
    <cfset remoteauthAvailable = true>
    <cfloop query="getRemoteauthDomains">
      <cfset arrayAppend(remoteauthDomains, {domain: getRemoteauthDomains.domain_name, server: getRemoteauthDomains.server_address})>
    </cfloop>
  </cfif>
</cfif>

<cfset session.m = "">

<!--- ALERTS (data-driven) --->
<cfset alerts = {
  "1":  {type:"success", msg:"System User was deleted successfully"},
  "2":  {type:"danger",  msg:"The Username field cannot be blank"},
  "21": {type:"danger",  msg:"You have entered an invalid Username. Usernames can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_), dashes (-), periods (.) and at signs (@)"},
  "3":  {type:"danger",  msg:"The E-mail Address field is not a valid e-mail address"},
  "4":  {type:"danger",  msg:"The E-mail Address field cannot be blank"},
  "5":  {type:"danger",  msg:"You have entered an invalid First Name. First Names can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)"},
  "6":  {type:"danger",  msg:"The First Name field cannot be blank"},
  "8":  {type:"danger",  msg:"You have entered an invalid Last Name. Last Names can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)"},
  "9":  {type:"danger",  msg:"The Last Name field cannot be blank"},
  "10": {type:"danger",  msg:"The Password field cannot be blank"},
  "11": {type:"danger",  msg:"The Password must be between 8 and 64 characters long"},
  "12": {type:"danger",  msg:"No password has been set for this user. You must set the <strong>Set User Password</strong> field to YES in order to continue"},
  "13": {type:"danger",  msg:"The Username you are attempting to use already exists. Usernames must be unique across all authentication types (Local and Remote). If adding a Remote Auth user whose username conflicts with an existing user, use a unique variant such as <strong>username@domain</strong> or <strong>username.domain</strong>"},
  "14": {type:"success", msg:"System User was saved successfully"},
  "15": {type:"success", msg:"System User 2FA devices were deleted successfully"},
  "16": {type:"warning", msg:"This user has not yet been synchronized to LDAP. To complete the synchronization, you must set <strong>Set User Password</strong> to YES and enter a new password. The user's existing password cannot be migrated to LDAP."},
  "17": {type:"danger",  msg:"You must select a RemoteAuth Domain when Authentication Type is set to Remote"},
  "18": {type:"success", msg:"Remote Auth System User was saved successfully"},
  "20": {type:"success", msg:"System User was created successfully"},
  "99": {type:"danger",  msg:"The Password you are attempting to use has previously appeared in a data breach. Please use another password. Password was checked by <a href='https://haveibeenpwned.com/Passwords' target='_blank'>haveibeenpwned.com</a>"},
  "100":{type:"danger",  msg:"There was a problem accessing haveibeenpwned.com to check your password against previous data breaches. Either ensure Hermes SEG has outbound Internet access over 443 to <a href='https://api.pwnedpasswords.com'>https://api.pwnedpasswords.com</a> OR set the <strong>Check Password Against haveibeenpwned.com</strong> field to NO"},
  "30": {type:"success", msg:"User session(s) invalidated. The user will need to log in again on their next request."},
  "31": {type:"success", msg:"All user sessions have been flushed. Every user will need to log in again."}
}>

<cfif structKeyExists(alerts, toString(m))>
  <cfset a = alerts[toString(m)]>
  <cfoutput>
  <div class="alert alert-#a.type# alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <cfif a.type is "success"><h4><i class="icon fa fa-check"></i> Success</h4>
    <cfelseif a.type is "warning"><h4><i class="icon fas fa-exclamation-triangle"></i> Warning</h4>
    <cfelse><h4><i class="icon fa fa-ban"></i> Error</h4></cfif>
    #a.msg#
  </div>
  </cfoutput>
</cfif>

<!-- SYSTEM USERS CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-users"></i> System Users</h3>
  </div>
  <div class="card-body">

    <div class="mb-3">
      <cfoutput>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##createModal">
        <i class="fa fa-plus-square fa-lg"></i> Create System User
      </button>
      <button type="button" class="btn btn-outline-danger ms-2" data-bs-toggle="modal" data-bs-target="##forceLogoutAllModal">
        <i class="fas fa-sign-out-alt"></i> Force Logout All Users
      </button>
      </cfoutput>
    </div>

    <cfif getsystemusers.recordcount GTE 1>
      <div class="table-responsive">
      <table id="sortTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th style="width: 120px">Actions</th>
            <th>Username</th>
            <th>E-Mail</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Access Control</th>
            <th>Auth Type</th>
            <th>Built-In</th>
            <th>Active</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getsystemusers">
          <tr>
            <td>
              <button type="button" class="btn btn-sm btn-primary" title="Edit"
                onclick="openEditModal(#id#, '#encodeForJavaScript(username)#', '#encodeForJavaScript(email)#', '#encodeForJavaScript(first_name)#', '#encodeForJavaScript(last_name)#', '#access_control#', '#auth_type#', '#encodeForJavaScript(remoteauth_domain)#', '#system#');">
                <i class="fas fa-edit"></i>
              </button>
              <button type="button" class="btn btn-sm btn-warning" title="Delete 2FA Devices"
                data-bs-toggle="modal" data-bs-target="##deleteDevicesModal" data-user="#encodeForHTMLAttribute(username)#">
                <i class="fas fa-key"></i>
              </button>
              <cfif id NEQ session.userid>
              <button type="button" class="btn btn-sm btn-outline-danger" title="Force Logout"
                onclick="confirmForceLogout('#encodeForJavaScript(username)#')">
                <i class="fas fa-sign-out-alt"></i>
              </button>
              </cfif>
              <cfif system NEQ "1" AND id NEQ session.userid>
              <button type="button" class="btn btn-sm btn-danger" title="Delete User"
                data-bs-toggle="modal" data-bs-target="##deleteModal" data-user="#id#" data-username="#encodeForHTMLAttribute(username)#">
                <i class="fa fa-trash"></i>
              </button>
              </cfif>
            </td>
            <td>#encodeForHTML(username)#</td>
            <td>#encodeForHTML(email)#</td>
            <td>#encodeForHTML(first_name)#</td>
            <td>#encodeForHTML(last_name)#</td>
            <td><cfif access_control is "one_factor">ONE FACTOR<cfelse>TWO FACTOR</cfif></td>
            <td><cfif auth_type EQ "remote"><span class="badge bg-info">REMOTE<cfif remoteauth_domain NEQ ""> (#encodeForHTML(remoteauth_domain)#)</cfif></span><cfelse><span class="badge bg-secondary">LOCAL</span></cfif></td>
            <td><cfif system is "1">YES<cfelse>NO</cfif></td>
            <td><cfif applied is "1">YES<cfelse>NO</cfif></td>
          </tr>
          </cfoutput>
        </tbody>
      </table>
      </div>
    <cfelse>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No System Users were found.
      </div>
    </cfif>

  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<!-- CREATE MODAL -->
<div class="modal fade" id="createModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="createuser">
        <div class="modal-header">
          <h5 class="modal-title">Create System User</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <cfif remoteauthAvailable>
          <div class="mb-3">
            <label class="form-label"><strong>Authentication Type</strong></label>
            <select class="form-select" name="auth_type" id="createAuthType">
              <option value="local" selected>Local</option>
              <option value="remote">Remote</option>
            </select>
          </div>
          <div class="mb-3" id="createRemoteauthGroup" style="display:none;">
            <label class="form-label"><strong>RemoteAuth Domain</strong></label>
            <select class="form-select" name="remoteauth_domain" id="createRemoteauthDomain">
              <option value="">-- Select Domain --</option>
              <cfloop array="#remoteauthDomains#" index="domainItem">
                <cfoutput><option value="#domainItem.domain#">#domainItem.domain# (#domainItem.server#)</option></cfoutput>
              </cfloop>
            </select>
            <small class="text-muted">Select the domain this user will authenticate against</small>
          </div>
          <cfelse>
          <input type="hidden" name="auth_type" value="local">
          </cfif>

          <div class="mb-3">
            <label class="form-label"><strong>Username</strong></label>
            <input type="text" class="form-control" name="username" placeholder="Username">
            <small class="form-text text-muted">Only letters, numbers, underscores, dashes, periods, and @ signs.</small>
          </div>
          <div class="alert alert-warning" id="createRemoteWarning" style="display:none;">
            <i class="icon fas fa-exclamation-triangle"></i> The <strong>Username</strong> must match the user's existing account name on the remote AD/LDAP server.
          </div>
          <div class="row">
            <div class="col-md-6">
              <div class="mb-3">
                <label class="form-label"><strong>E-Mail Address</strong></label>
                <input type="text" class="form-control" name="email" placeholder="user@domain.tld">
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-6">
              <div class="mb-3">
                <label class="form-label"><strong>First Name</strong></label>
                <input type="text" class="form-control" name="first_name" placeholder="First Name">
              </div>
            </div>
            <div class="col-md-6">
              <div class="mb-3">
                <label class="form-label"><strong>Last Name</strong></label>
                <input type="text" class="form-control" name="last_name" placeholder="Last Name">
              </div>
            </div>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Access Control Policy</strong></label>
            <select class="form-select" name="access_control">
              <option value="one_factor" selected>One Factor</option>
              <option value="two_factor">Two Factor</option>
            </select>
          </div>
          <div id="createPasswordGroup">
            <div class="mb-3">
              <label class="form-label"><strong>Check Password Against haveibeenpwned.com</strong></label>
              <select class="form-select" name="hibp">
                <option value="YES" selected>YES</option>
                <option value="NO">NO</option>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label"><strong>Password</strong></label>
              <div class="input-group">
                <input type="password" class="form-control" name="password" placeholder="8-64 characters" maxlength="64" id="createPassword">
                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('createPassword', this)">
                  <i class="fa fa-eye-slash"></i>
                </button>
              </div>
            </div>
          </div>
          <input type="hidden" name="setpassword" value="YES">

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Creating...';this.form.submit();">
            Create
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- EDIT MODAL -->
<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="edituser">
        <input type="hidden" name="id" id="edit_id" value="">
        <div class="modal-header">
          <h5 class="modal-title">Edit System User</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <div class="mb-3">
            <label class="form-label"><strong>Authentication Type</strong></label>
            <input type="text" class="form-control bg-light" id="editAuthTypeDisplay" readonly>
            <input type="hidden" name="auth_type" id="editAuthType" value="">
            <input type="hidden" name="remoteauth_domain" id="editRemoteauthDomain" value="">
            <small class="form-text text-muted" id="editRemoteauthDomainDisplay" style="display:none;"></small>
            <small class="form-text text-muted">Authentication type cannot be changed. To change, delete this user and create a new one.</small>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Username</strong></label>
            <input type="text" class="form-control bg-light" name="username" id="edit_username" readonly>
            <small class="form-text text-muted">Username cannot be changed. To change the username, delete this user and create a new one.</small>
          </div>
          <div class="row">
            <div class="col-md-6">
              <div class="mb-3">
                <label class="form-label"><strong>E-Mail Address</strong></label>
                <input type="text" class="form-control" name="email" id="edit_email" placeholder="user@domain.tld">
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-6">
              <div class="mb-3">
                <label class="form-label"><strong>First Name</strong></label>
                <input type="text" class="form-control" name="first_name" id="edit_first_name" placeholder="First Name">
              </div>
            </div>
            <div class="col-md-6">
              <div class="mb-3">
                <label class="form-label"><strong>Last Name</strong></label>
                <input type="text" class="form-control" name="last_name" id="edit_last_name" placeholder="Last Name">
              </div>
            </div>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Access Control Policy</strong></label>
            <div class="alert alert-warning">
              <i class="icon fas fa-exclamation-triangle"></i> Before setting to <strong>Two Factor</strong>, ensure e-mail delivery works and the user's e-mail address is correct. See the <a href="#" onclick="window.open('https://docs.deeztek.com/books/hermes-seg-administrator-guide-v2/page/system-users#bkmrk-access-control-polic', '_blank'); return false;">Access Control Policy Documentation</a>.
            </div>
            <select class="form-select" name="access_control" id="edit_access_control">
              <option value="one_factor">One Factor</option>
              <option value="two_factor">Two Factor</option>
            </select>
          </div>
          <div id="editPasswordGroup">
            <div class="mb-3">
              <label class="form-label"><strong>Set User Password</strong></label>
              <select class="form-select" name="setpassword" id="editSetPassword">
                <option value="NO" selected>NO</option>
                <option value="YES">YES</option>
              </select>
            </div>
            <div id="editPasswordFields" style="display:none;">
              <div class="mb-3">
                <label class="form-label"><strong>Check Password Against haveibeenpwned.com</strong></label>
                <select class="form-select" name="hibp">
                  <option value="YES" selected>YES</option>
                  <option value="NO">NO</option>
                </select>
              </div>
              <div class="mb-3">
                <label class="form-label"><strong>Password</strong></label>
                <div class="input-group">
                  <input type="password" class="form-control" name="password" placeholder="8-64 characters" maxlength="64" id="editPassword">
                  <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('editPassword', this)">
                    <i class="fa fa-eye-slash"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
            Save Changes
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- DELETE USER MODAL -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="deleteuser">
        <input type="hidden" name="user" id="delete_user_id" value="">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title">Delete System User</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to delete <strong id="delete_username"></strong>? This action is irreversible!</p>
          <p>The user and any Two Factor TOTP and Security Keys will be deleted. If the user has any Duo Devices, they must be manually deleted from the Duo Control Panel.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          <button type="submit" class="btn btn-danger"
            onclick="this.disabled=true;this.innerHTML='Deleting...';this.form.submit();">Yes, Delete</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- DELETE 2FA DEVICES MODAL -->
<div class="modal fade" id="deleteDevicesModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="deleteuserdevices">
        <input type="hidden" name="user" id="delete_devices_user" value="">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title">Delete 2FA Devices</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to delete all 2FA devices for <strong id="delete_devices_username"></strong>?</p>
          <p>This action is irreversible! All TOTP and Security Keys will be deleted. Duo devices must be manually deleted from the Duo Control Panel.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          <button type="submit" class="btn btn-danger"
            onclick="this.disabled=true;this.innerHTML='Deleting...';this.form.submit();">Yes, Delete</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- FORCE LOGOUT MODAL --->
<div class="modal fade" id="forceLogoutModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_system_users.cfm">
        <input type="hidden" name="action" value="forcelogout">
        <input type="hidden" name="logout_username" id="forceLogoutUsername" value="">
        <div class="modal-header bg-warning">
          <h5 class="modal-title"><i class="fas fa-sign-out-alt me-2"></i>Force Logout</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>This will immediately invalidate all active sessions for <strong id="forceLogoutDisplayName"></strong>.</p>
          <p>The user will be redirected to the login page on their next request. Any unsaved work will be lost.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-warning">Force Logout</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- FORCE LOGOUT ALL MODAL --->
<div class="modal fade" id="forceLogoutAllModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_system_users.cfm">
        <input type="hidden" name="action" value="forcelogoutall">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title"><i class="fas fa-sign-out-alt me-2"></i>Force Logout All Users</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="alert alert-danger">
            <h5><i class="icon fas fa-exclamation-triangle"></i> Warning</h5>
            <p>This will immediately invalidate <strong>ALL</strong> active sessions for <strong>every user</strong>, including your own.</p>
            <p class="mb-0">All users (admins, mailbox users, relay users) will be redirected to the login page on their next request. You will also be logged out.</p>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Force Logout All Users</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
function confirmForceLogout(username) {
  $('#forceLogoutUsername').val(username);
  $('#forceLogoutDisplayName').text(username);
  new bootstrap.Modal(document.getElementById('forceLogoutModal')).show();
}

$(document).ready(function() {
  $('#sortTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
    order: [[1, 'asc']],
    columnDefs: [
      { orderable: false, targets: [0] },
      { searchable: false, targets: [0] }
    ]
  });
});

// Password visibility toggle
function togglePassword(inputId, btn) {
  var input = document.getElementById(inputId);
  var icon = btn.querySelector('i');
  if (input.type === 'password') {
    input.type = 'text';
    icon.classList.remove('fa-eye-slash');
    icon.classList.add('fa-eye');
  } else {
    input.type = 'password';
    icon.classList.add('fa-eye-slash');
    icon.classList.remove('fa-eye');
  }
}

// Create modal: auth type toggle
document.getElementById('createAuthType')?.addEventListener('change', function() {
  var isRemote = this.value === 'remote';
  var domainGroup = document.getElementById('createRemoteauthGroup');
  var passwordGroup = document.getElementById('createPasswordGroup');
  var remoteWarning = document.getElementById('createRemoteWarning');
  if (domainGroup) domainGroup.style.display = isRemote ? '' : 'none';
  if (passwordGroup) passwordGroup.style.display = isRemote ? 'none' : '';
  if (remoteWarning) remoteWarning.style.display = isRemote ? '' : 'none';
});

// Edit modal: set password toggle
document.getElementById('editSetPassword')?.addEventListener('change', function() {
  document.getElementById('editPasswordFields').style.display = this.value === 'YES' ? '' : 'none';
});

// Open Edit Modal
function openEditModal(id, username, email, firstName, lastName, accessControl, authType, remoteauthDomain, system) {
  document.getElementById('edit_id').value = id;
  document.getElementById('edit_username').value = username;
  document.getElementById('edit_email').value = email;
  document.getElementById('edit_first_name').value = firstName;
  document.getElementById('edit_last_name').value = lastName;
  document.getElementById('edit_access_control').value = accessControl;

  // Auth type (read-only display)
  var at = authType || 'local';
  document.getElementById('editAuthType').value = at;
  document.getElementById('editAuthTypeDisplay').value = at === 'remote' ? 'Remote' : 'Local';
  document.getElementById('editRemoteauthDomain').value = remoteauthDomain || '';

  // Show remoteauth domain info if remote
  var domainDisplay = document.getElementById('editRemoteauthDomainDisplay');
  if (at === 'remote' && remoteauthDomain) {
    domainDisplay.textContent = 'RemoteAuth Domain: ' + remoteauthDomain;
    domainDisplay.style.display = '';
  } else {
    domainDisplay.style.display = 'none';
  }

  // Hide password group for remote auth users
  var passwordGroup = document.getElementById('editPasswordGroup');
  passwordGroup.style.display = at === 'remote' ? 'none' : '';

  // Reset password fields
  document.getElementById('editSetPassword').value = 'NO';
  document.getElementById('editPasswordFields').style.display = 'none';
  document.getElementById('editPassword').value = '';

  new bootstrap.Modal(document.getElementById('editModal')).show();
}

// Delete User modal
document.getElementById('deleteModal')?.addEventListener('show.bs.modal', function(e) {
  document.getElementById('delete_user_id').value = e.relatedTarget.dataset.user;
  document.getElementById('delete_username').textContent = e.relatedTarget.dataset.username;
});

// Delete 2FA Devices modal
document.getElementById('deleteDevicesModal')?.addEventListener('show.bs.modal', function(e) {
  var username = e.relatedTarget.dataset.user;
  document.getElementById('delete_devices_user').value = username;
  document.getElementById('delete_devices_username').textContent = username;
});
</script>

</body>
</html>
