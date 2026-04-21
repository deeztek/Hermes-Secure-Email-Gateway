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

<!--- ACCESS CHECK: Only mailbox users can access this page --->
<cfif NOT session.theGroups CONTAINS "mailboxes">
    <cflocation url="index.cfm" addtoken="no">
</cfif>

<!--- FEATURE CHECK: Mailbox sharing must be enabled by an administrator --->
<cfquery name="getSharingEnabled" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'dovecot' AND parameter = 'sharing.enabled'
</cfquery>
<cfset sharingEnabled = (getSharingEnabled.recordcount GTE 1 AND getSharingEnabled.value2 EQ "yes")>

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Shared Folders</title>

  <cfinclude template="./inc/html_head.cfm" />

</head>

<!--- INITIALIZE MESSAGE VARIABLES --->
<cfparam name="session.sfMessage" default="">
<cfparam name="session.sfMessageType" default="">

<!--- PROCESS FORM SUBMISSION (only if sharing is enabled) --->
<cfif sharingEnabled AND StructKeyExists(form, "action")>
    <cfif form.action EQ "share_folder" OR form.action EQ "unshare_folder">
        <cfinclude template="./inc/shared_folder_actions.cfm">
    </cfif>
</cfif>

<!--- GET OWNER'S DOMAIN ID --->
<cfquery name="getOwnerMailbox" datasource="hermes">
    SELECT id, domain_id FROM mailboxes
    WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
    AND mailbox_type = 'user' AND active = 1
</cfquery>

<!--- GET OTHER MAILBOX USERS IN THE SAME DOMAIN (for share dropdown) --->
<cfif getOwnerMailbox.recordcount GTE 1>
    <cfquery name="getDomainUsers" datasource="hermes">
        SELECT username, name FROM mailboxes
        WHERE domain_id = <cfqueryparam value="#getOwnerMailbox.domain_id#" cfsqltype="cf_sql_integer">
        AND username != <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
        AND mailbox_type = 'user'
        AND active = 1
        ORDER BY username ASC
    </cfquery>
<cfelse>
    <cfset getDomainUsers = QueryNew("username,name")>
</cfif>

<!--- GET FOLDERS THE LOGGED-IN USER HAS SHARED WITH OTHERS --->
<cfquery name="getMyShares" datasource="hermes">
    SELECT id, shared_with_username, folder_path, can_read, can_write, can_delete, can_insert, created_at
    FROM user_folder_shares
    WHERE owner_username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
    ORDER BY folder_path ASC, shared_with_username ASC
</cfquery>

<!--- GET FOLDERS OTHERS HAVE SHARED WITH THE LOGGED-IN USER --->
<cfquery name="getSharedWithMe" datasource="hermes">
    SELECT id, owner_username, folder_path, can_read, can_write, can_delete, can_insert, created_at
    FROM user_folder_shares
    WHERE shared_with_username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
    ORDER BY owner_username ASC, folder_path ASC
</cfquery>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Shared Folders</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item active">Shared Folders</li>
            </ol>
          </div>
        </div>
      </div>
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

        <cfif NOT sharingEnabled>
        <!--- FEATURE UNAVAILABLE --->
        <div class="card card-outline card-secondary">
            <div class="card-body text-center py-5">
                <i class="fas fa-share-alt fa-4x text-muted mb-3"></i>
                <h3 class="text-muted">Folder Sharing Unavailable</h3>
                <p class="text-muted mb-0">Folder sharing is currently disabled on this server.<br>Please contact your administrator if you need access to this feature.</p>
            </div>
        </div>
        <cfelse>

        <!--- DISPLAY MESSAGES --->
        <cfif session.sfMessage NEQ "">
            <div class="alert alert-<cfoutput>#session.sfMessageType#</cfoutput> alert-dismissible">
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
                <cfoutput>#session.sfMessage#</cfoutput>
            </div>
            <cfset session.sfMessage = "">
            <cfset session.sfMessageType = "">
        </cfif>

        <!--- SECTION 1: MY SHARED FOLDERS --->
        <div class="card card-outline card-primary mb-4">
            <div class="card-header">
                <h3 class="card-title"><i class="fas fa-share-alt me-2"></i>My Shared Folders</h3>
            </div>
            <div class="card-body">

                <div class="alert alert-warning">
                    <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i>Share your mailbox folders with other users in your domain. Shared folders will appear under the <strong>Shared/</strong> namespace in the recipient's email client. Common folder paths: <strong>INBOX</strong>, <strong>INBOX/Projects</strong>, <strong>Sent</strong>, <strong>Drafts</strong>.</p>
                </div>

                <div class="alert alert-info">
                    <p class="mb-1"><i class="icon fas fa-info-circle"></i> <strong>If your recipient uses Nextcloud Mail (webmail):</strong></p>
                    <p class="mb-0">NC Mail caches its folder list once when the account is first set up and won&rsquo;t automatically pick up folders that are shared later. If your recipient can&rsquo;t see a folder you&rsquo;ve shared with them, have them go to <strong>Webmail &rarr; Settings &rarr; Mail accounts</strong>, remove their account, and add it back &mdash; the fresh setup re-enumerates the full folder tree, including shared folders. <strong>Thunderbird and other IMAP clients</strong> don&rsquo;t have this limitation; they see shared folders as soon as they refresh their folder list (for Thunderbird: right-click the account &rarr; <em>Subscribe</em> &rarr; <em>Refresh</em>).</p>
                </div>

                <!--- SHARE A FOLDER FORM --->
                <cfif getDomainUsers.recordcount GTE 1>
                <div class="card card-outline card-secondary mb-3">
                    <div class="card-header">
                        <h3 class="card-title"><i class="fas fa-plus-circle me-2"></i>Share a Folder</h3>
                    </div>
                    <div class="card-body">
                        <form method="post" action="view_shared_folders.cfm">
                            <input type="hidden" name="action" value="share_folder">

                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="folder_path" class="form-label"><strong>Folder Path</strong></label>
                                    <select class="form-control" name="folder_path" id="folder_path" required>
                                        <option value=""></option>
                                    </select>
                                    <div class="form-text">Pick a folder from your mailbox, or type a custom path.</div>
                                </div>
                                <div class="col-md-4">
                                    <label for="shared_with_username" class="form-label"><strong>Share With</strong></label>
                                    <select class="form-control" name="shared_with_username" id="shared_with_username" required>
                                        <option value="">-- Select a User --</option>
                                        <cfoutput query="getDomainUsers">
                                            <option value="#encodeForHTML(username)#">#encodeForHTML(username)#<cfif name NEQ ""> (#encodeForHTML(name)#)</cfif></option>
                                        </cfoutput>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label"><strong>Permissions</strong></label>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="can_read" id="can_read" value="1" checked>
                                        <label class="form-check-label" for="can_read">Read</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="can_write" id="can_write" value="1">
                                        <label class="form-check-label" for="can_write">Write</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="can_delete" id="can_delete" value="1">
                                        <label class="form-check-label" for="can_delete">Delete</label>
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='Please wait...';this.form.submit();">
                                <i class="fas fa-share me-1"></i> Share Folder
                            </button>
                        </form>
                    </div>
                </div>
                <cfelse>
                    <div class="alert alert-info">
                        <i class="icon fas fa-info-circle"></i>
                        There are no other mailbox users in your domain to share folders with.
                    </div>
                </cfif>

                <!--- MY SHARES TABLE --->
                <cfif getMyShares.recordcount GTE 1>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Folder</th>
                                <th>Shared With</th>
                                <th>Permissions</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="getMyShares">
                                <tr>
                                    <td>#encodeForHTML(folder_path)#</td>
                                    <td>#encodeForHTML(shared_with_username)#</td>
                                    <td>
                                        <cfif can_read EQ 1><span class="badge bg-success me-1">Read</span></cfif>
                                        <cfif can_write EQ 1><span class="badge bg-warning me-1">Write</span></cfif>
                                        <cfif can_delete EQ 1><span class="badge bg-danger me-1">Delete</span></cfif>
                                    </td>
                                    <td>
                                        <form method="post" action="view_shared_folders.cfm" style="display:inline;" onsubmit="return confirm('Are you sure you want to revoke this folder share?');">
                                            <input type="hidden" name="action" value="unshare_folder">
                                            <input type="hidden" name="share_id" value="#id#">
                                            <button type="submit" class="btn btn-outline-danger btn-sm">
                                                <i class="fas fa-times me-1"></i> Revoke
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </table>
                <cfelse>
                    <div class="alert alert-info">
                        <i class="icon fas fa-info-circle"></i>
                        You have not shared any folders yet.
                    </div>
                </cfif>

            </div>
        </div>

        <!--- SECTION 2: SHARED WITH ME --->
        <div class="card card-outline card-primary mb-4">
            <div class="card-header">
                <h3 class="card-title"><i class="fas fa-inbox me-2"></i>Shared With Me</h3>
            </div>
            <div class="card-body">

                <div class="alert alert-info">
                    <p class="mb-0"><i class="icon fas fa-info-circle"></i>These folders appear under the <strong>Shared/</strong> namespace in your email client. You may need to subscribe to them in your email client's folder settings for them to appear.</p>
                </div>

                <cfif getSharedWithMe.recordcount GTE 1>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Owner</th>
                                <th>Folder</th>
                                <th>Permissions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="getSharedWithMe">
                                <tr>
                                    <td>#encodeForHTML(owner_username)#</td>
                                    <td>#encodeForHTML(folder_path)#</td>
                                    <td>
                                        <cfif can_read EQ 1><span class="badge bg-success me-1">Read</span></cfif>
                                        <cfif can_write EQ 1><span class="badge bg-warning me-1">Write</span></cfif>
                                        <cfif can_delete EQ 1><span class="badge bg-danger me-1">Delete</span></cfif>
                                    </td>
                                </tr>
                            </cfoutput>
                        </tbody>
                    </table>
                <cfelse>
                    <div class="alert alert-info">
                        <i class="icon fas fa-info-circle"></i>
                        No folders have been shared with you yet.
                    </div>
                </cfif>

            </div>
        </div>

        </cfif>

      </div>
    </div>
  </main>

<cfif sharingEnabled AND getDomainUsers.recordcount GTE 1>
<script>
  $(document).ready(function() {
    var sel = document.getElementById('folder_path');
    if (!sel) return;

    var ts = new TomSelect(sel, {
      create: function(input) { return { value: input, text: input }; },
      createOnBlur: true,
      persist: true,
      sortField: { field: 'text', direction: 'asc' },
      placeholder: 'Select or type folder name...',
      maxOptions: 500
    });

    $.getJSON('./inc/get_mailbox_folders.cfm', function(data) {
      if (data && data.folders && data.folders.length) {
        data.folders.forEach(function(f) { ts.addOption({ value: f, text: f }); });
        ts.refreshOptions(false);
      }
    });
  });
</script>
</cfif>

<cfinclude template="./inc/main_footer.cfm" />

</div>
<!-- ./wrapper -->

</body>
</html>
