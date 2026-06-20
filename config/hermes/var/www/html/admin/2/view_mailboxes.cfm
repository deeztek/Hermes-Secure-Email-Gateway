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
  <title>Hermes SEG | Email Server - Mailboxes</title>
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
            <h1 class="m-0">Email Server - Mailboxes</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Email Server</li>
              <li class="breadcrumb-item active">Mailboxes</li>
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
<cfif action is "edit_mailbox">
  <cfinclude template="./inc/edit_mailbox_action.cfm">
<cfelseif action is "edit_mailbox_encryption">
  <cfinclude template="./inc/edit_mailbox_encryption_action.cfm">
<cfelseif action is "edit_mailbox_access_control">
  <cfinclude template="./inc/edit_mailbox_access_control_action.cfm">
<cfelseif action is "delete_mailbox">
  <cfinclude template="./inc/delete_mailbox_action.cfm">
<cfelseif action is "rotate_nc_password">
  <cfinclude template="./inc/rotate_nc_password_action.cfm">
<cfelseif action is "resend_mobile_setup">
  <cfinclude template="./inc/admin_resend_mobile_setup_action.cfm">
</cfif>

<!--- Edition check --->
<cfset isPro = isDefined("session.edition") AND session.edition EQ "Pro">

<!--- SUCCESS / ERROR MESSAGES --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Mailbox created successfully.
    <cfif StructKeyExists(session, "smimeQueued") AND session.smimeQueued GT 0>
      <br><cfoutput>#session.smimeQueued#</cfoutput> S/MIME certificate(s) queued for background generation.
      <cfset session.smimeQueued = "">
    </cfif>
    <cfif StructKeyExists(session, "pgpQueued") AND session.pgpQueued GT 0>
      <br><cfoutput>#session.pgpQueued#</cfoutput> PGP keyring(s) queued for background generation.
      <cfset session.pgpQueued = "">
    </cfif>
  </div>
<cfelseif m EQ 2>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Mailbox updated successfully.
    <cfif StructKeyExists(session, "passwordChanged") AND session.passwordChanged>
      Password has been changed.
      <cfset session.passwordChanged = "">
    </cfif>
  </div>
<cfelseif m EQ 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Mailbox deleted successfully.
  </div>
<cfelseif m EQ 4>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    Encryption settings updated successfully.
    <cfif StructKeyExists(session, "smimeQueued") AND session.smimeQueued GT 0>
      <br><cfoutput>#session.smimeQueued#</cfoutput> S/MIME certificate(s) queued for background generation.
      <cfset session.smimeQueued = "">
    </cfif>
    <cfif StructKeyExists(session, "pgpQueued") AND session.pgpQueued GT 0>
      <br><cfoutput>#session.pgpQueued#</cfoutput> PGP keyring(s) queued for background generation.
      <cfset session.pgpQueued = "">
    </cfif>
  </div>
<cfelseif m EQ 5>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    2FA devices reset. The user will be prompted to re-register on their next sign-in.
  </div>
<cfelseif m EQ 15>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Quota must be a positive number.
  </div>
<cfelseif m EQ 20>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Missing required form fields.
  </div>
<cfelseif m EQ 21>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Mailbox not found.
  </div>
<cfelseif m EQ 22>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Password must be at least 12 characters.
  </div>
<cfelseif m EQ 51>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Password Required</h4>
    A password must be set when enabling Nextcloud webmail for an existing user. The password is needed to create the user's email profile in the Nextcloud Mail app. Please edit the mailbox again with both Nextcloud enabled and a new password.
  </div>
<cfelseif m EQ 99>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Compromised Password</h4>
    This password has been found in a data breach and cannot be used. Please choose a different password.
  </div>
<cfelseif m EQ 50>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid mailbox id for NC password rotation.
  </div>
<cfelseif m EQ 51>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Mailbox not found for NC password rotation.
  </div>
<cfelseif m EQ 52>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-exclamation-triangle"></i> Not Applicable</h4>
    This mailbox does not have Nextcloud enabled, so there is no NC internal password to rotate.
  </div>
<cfelseif m EQ 53>
  <cfset rotatedNcUser = StructKeyExists(session, "rotateNcUser") ? session.rotateNcUser : "">
  <cfset session.rotateNcUser = "">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> NC Internal Password Rotated</h4>
    <p class="mb-0">NC internal password rotated for <strong><cfoutput>#HTMLEditFormat(rotatedNcUser)#</cfoutput></strong>. The new value is random, never displayed, and never used by anything user-facing &mdash; this is purely defense-in-depth.</p>
  </div>
<cfelseif m EQ 54>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Rotation Failed</h4>
    <p class="mb-0">Could not rotate the NC internal password. <cfif StructKeyExists(session, "rotateNcError")><cfoutput>Details: #HTMLEditFormat(session.rotateNcError)#</cfoutput><cfset session.rotateNcError = ""></cfif></p>
  </div>
<cfelseif m EQ 100>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fas fa-exclamation-triangle"></i> Password Check Unavailable</h4>
    Unable to verify password against breach database. Please try again later.
  </div>
<cfelseif m EQ 80>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Setup profile sent</h4>
    <p class="mb-0">A mobile setup profile email was sent to <strong><cfoutput>#HTMLEditFormat(StructKeyExists(session, "adminResendTarget") ? session.adminResendTarget : "")#</cfoutput></strong>. The link expires in 30 minutes and works only once.</p>
    <cfset session.adminResendTarget = "">
  </div>
<cfelseif m EQ 81>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Mailbox not found</h4>
    Could not send mobile setup profile &mdash; the selected mailbox could not be found or is not an active user mailbox.
  </div>
<cfelseif m EQ 82>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Setup profile generation failed</h4>
    <p class="mb-0"><cfif StructKeyExists(session, "adminResendError")><cfoutput>#HTMLEditFormat(session.adminResendError)#</cfoutput><cfset session.adminResendError = ""><cfelse>An unknown error occurred while generating the setup profile.</cfif></p>
  </div>
<cfelseif m EQ 83>
  <div class="alert alert-warning alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fas fa-exclamation-triangle"></i> Setup profile staged but email failed</h4>
    <p class="mb-0">The setup profile was generated successfully but the notification email could not be sent. <cfif StructKeyExists(session, "adminResendError")><cfoutput>Details: #HTMLEditFormat(session.adminResendError)#</cfoutput><cfset session.adminResendError = ""></cfif></p>
  </div>
</cfif>

<!--- QUERY ALL MAILBOXES --->
<!--- #226 Phase 2B: per-domain dept name list, used by the Edit
     Mailbox modal's department datalist (typeahead). Sets
     variables.deptOptionsByDomain + deptOptionsByDomainJson. --->
<cfinclude template="./inc/get_dept_options.cfm" />

<cfquery name="getMailboxes" datasource="hermes">
    SELECT m.id, m.username, m.name, m.quota, m.active, m.created, m.modified, m.domain_id,
           m.nextcloud_enabled AS mb_nextcloud,
           d.domain, d.default_quota_mb,
           r.id AS recipient_id, r.id AS theID, r.id AS theOtherID,
           r.policy_id, r.auth_type, r.remoteauth_domain, r.enforce_mfa,
           IF(r.pdf_enabled = 1, 'YES', 'NO') AS pdf_enabled,
           IF(r.smime_enabled = '1', 'YES', 'NO') AS smime_enabled,
           IF(r.pgp_enabled = 1, 'YES', 'NO') AS pgp_enabled,
           IF(r.digital_sign = '1', 'YES', 'NO') AS digital_sign,
           sp.policy_name,
           IF(us.report_enabled = 'NO', 'NO', 'YES') AS report_enabled,
           IF(us.train_bayes = 1, 'YES', 'NO') AS train_bayes,
           IF(us.download_msg = 1, 'YES', 'NO') AS download_msg,
           COALESCE(us.ldap_username, '') AS ldap_username,
           IF(rc.user_id IS NULL, 'NO', 'YES') AS cert,
           IF(rk.user_id IS NULL, 'NO', 'YES') AS keystore
    FROM mailboxes m
    INNER JOIN domains d ON m.domain_id = d.id AND d.type = 'mailbox'
    LEFT JOIN recipients r ON r.recipient = m.username
    LEFT JOIN spam_policies sp ON sp.policy_id = r.policy_id
    LEFT JOIN user_settings us ON us.email = m.username
    LEFT JOIN recipient_certificates rc ON r.id = rc.user_id
    LEFT JOIN recipient_keystores rk ON r.id = rk.user_id
    WHERE m.mailbox_type = 'user'
    GROUP BY m.id
    ORDER BY m.username ASC
</cfquery>

<!--- QUERY LDAP FOR TWO_FACTOR GROUP MEMBERS (single query for all users) --->
<cfset twoFactorMembers = "">
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b 'cn=two_factor,ou=groups,dc=hermes,dc=local' -LLL member"
        variable="twoFactorMembers"
        errorVariable="ldapError"
        timeout="30">
    </cfexecute>
<cfcatch type="any">
    <cfset twoFactorMembers = "">
</cfcatch>
</cftry>

<!--- GET ALL POLICIES FOR EDIT MODAL --->
<cfquery name="getAllPolicies" datasource="hermes">
    SELECT policy_id, policy_name, default_policy FROM spam_policies
    WHERE custom = '1' OR default_policy = '1'
    ORDER BY default_policy DESC, policy_name ASC
</cfquery>

<!--- CHECK FOR PENDING CERT JOBS --->
<cfquery name="getPendingJobs" datasource="hermes">
    SELECT recipient_email, job_type, status FROM cert_generation_queue
    WHERE status IN ('pending', 'processing')
</cfquery>
<cfset pendingJobMap = {}>
<cfloop query="getPendingJobs">
    <cfif NOT StructKeyExists(pendingJobMap, getPendingJobs.recipient_email)>
        <cfset pendingJobMap[getPendingJobs.recipient_email] = []>
    </cfif>
    <cfset ArrayAppend(pendingJobMap[getPendingJobs.recipient_email], getPendingJobs.job_type & ":" & getPendingJobs.status)>
</cfloop>

<!--- CHECK 2FA GROUP MEMBERSHIP VIA LDAP QUERY ON USER_SETTINGS --->
<!--- We check if the user's ldap_username is in the two_factor group by querying
     the LDAP group membership. For performance, we batch this in a single query
     against the user_settings table and check LDAP group membership. --->

<!--- GET MAILBOX DOMAINS FOR FILTER --->
<cfquery name="getFilterDomains" datasource="hermes">
    SELECT DISTINCT d.domain FROM domains d
    INNER JOIN mailboxes m ON m.domain_id = d.id
    WHERE d.type = 'mailbox'
    ORDER BY d.domain ASC
</cfquery>

<!--- ADD MAILBOX BUTTON + DOMAIN FILTER --->
<div class="d-flex justify-content-between align-items-center mb-3">
  <a href="add_mailbox.cfm" class="btn btn-primary"><i class="fa fa-plus fa-lg"></i>&nbsp;&nbsp;Add Mailbox</a>
  <cfif getFilterDomains.recordcount GTE 1>
  <div class="d-flex align-items-center gap-2">
    <label class="mb-0"><strong>Filter by Domain:</strong></label>
    <select class="form-control form-control-sm" id="domainFilter" style="width:auto;">
      <option value="">All Domains</option>
      <cfoutput query="getFilterDomains">
        <option value="#HTMLEditFormat(domain)#">#HTMLEditFormat(domain)#</option>
      </cfoutput>
    </select>
  </div>
  </cfif>
</div>

<!--- MAILBOXES DATATABLE --->
<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-envelope me-2"></i>Mailboxes (<cfoutput>#getMailboxes.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <div class="table-responsive">
    <table id="mailboxesTable" class="table table-bordered table-striped" style="width:100%">
      <thead>
        <tr>
          <th>Actions</th>
          <th>S/MIME</th>
          <th>PGP</th>
          <th>Email</th>
          <th>Display Name</th>
          <th>Domain</th>
          <th>Quota</th>
          <th>Auth</th>
          <th>2FA</th>
          <th>Policy</th>
          <th>Notifications</th>
          <th>Train Bayes</th>
          <th>Download Msgs</th>
          <th>PDF Encrypt</th>
          <th>S/MIME Encrypt</th>
          <th>PGP Encrypt</th>
          <th>Sign All</th>
          <th>S/MIME Cert</th>
          <th>PGP Keyring</th>
          <th>Nextcloud</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getMailboxes">
        <cfset quotaGb = quota / 1024 / 1024 / 1024>
        <cfset hasPendingJobs = StructKeyExists(pendingJobMap, username)>
        <cfset recipientLdapUser = ldap_username NEQ "" ? LCase(ldap_username) : LCase(username)>
        <cfset isTwoFactor = twoFactorMembers CONTAINS "cn=#recipientLdapUser#,ou=users,dc=hermes,dc=local">
        <tr>
          <td>
            <div class="dropdown">
              <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                Actions
              </button>
              <ul class="dropdown-menu">
                <li><a class="dropdown-item" href="##" onclick="loadEditModal(#id#); return false;"><i class="fas fa-edit me-2"></i>Edit Options</a></li>
                <li><a class="dropdown-item" href="##" onclick="loadEncryptionModal(#id#, '#JSStringFormat(username)#'); return false;"><i class="fas fa-lock me-2"></i>Edit Encryption</a></li>
                <li><a class="dropdown-item" href="##" onclick="loadAccessControlModal(#id#, '#JSStringFormat(username)#', '#JSStringFormat(ldap_username)#'); return false;"><i class="fas fa-mobile-alt me-2"></i>Reset 2FA Devices</a></li>
                <li><a class="dropdown-item" href="view_mailbox_app_passwords.cfm?mailbox_id=#id#"><i class="fas fa-key me-2"></i>Manage App Passwords</a></li>
                <li><a class="dropdown-item" href="##" onclick="confirmResendMobileSetup(#id#, '#JSStringFormat(username)#'); return false;"><i class="fas fa-mobile-alt me-2"></i>Send Mobile Setup Profile</a></li>
                <cfif Val(mb_nextcloud) EQ 1>
                  <li><a class="dropdown-item" href="##" onclick="confirmRotateNcPassword(#id#, '#JSStringFormat(username)#'); return false;"><i class="fas fa-sync-alt me-2"></i>Rotate NC Internal Password</a></li>
                </cfif>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="##" onclick="confirmDelete(#id#, '#JSStringFormat(username)#'); return false;"><i class="fas fa-trash me-2"></i>Delete</a></li>
              </ul>
            </div>
          </td>
          <td><a href="view_recipient_certificates.cfm?type=1&id=#theID#" class="btn btn-secondary btn-sm" role="button" title="Manage S/MIME Certificates"><i class="fas fa-user-shield"></i></a></td>
          <td><a href="view_recipient_keyrings.cfm?type=1&id=#theOtherID#" class="btn btn-secondary btn-sm" role="button" title="Manage PGP Keyrings"><i class="fas fa-user-lock"></i></a></td>
          <td>#HTMLEditFormat(username)#</td>
          <td>#HTMLEditFormat(name)#</td>
          <td>#HTMLEditFormat(domain)#</td>
          <td>
            <cfif quotaGb GTE 1>
              <cfif quotaGb EQ Int(quotaGb)>#Int(quotaGb)#<cfelse>#NumberFormat(quotaGb, "0.0")#</cfif> GB
            <cfelse>
              #NumberFormat(quotaGb, "0.00")# GB
            </cfif>
          </td>
          <td><cfif auth_type EQ "remote"><span class="badge bg-primary" title="#HTMLEditFormat(remoteauth_domain)#"><i class="fas fa-cloud me-1"></i>REMOTE</span><cfelse><span class="badge bg-secondary">LOCAL</span></cfif></td>
          <td><!--- 2FA column: two orthogonal states, two independent pills.
                "Enrolled" reads cn=two_factor LDAP membership (user has
                registered a 2FA device — Authelia challenges them at
                sign-in). "Required" reads recipients.enforce_mfa (admin
                policy — set via Edit Options). A user can be enrolled
                voluntarily without admin enforcement, and admin can
                enforce without the user yet being enrolled, so the two
                must be displayed independently. (#225 Phase 1.5 + Phase 2)
            --->
            <cfif isTwoFactor>
              <span class="badge bg-success me-1" title="User has registered a 2FA device (TOTP, security key, or Duo Push). Authelia challenges them at sign-in."><i class="fas fa-shield-alt me-1"></i>Enrolled</span>
            </cfif>
            <cfif Val(enforce_mfa) EQ 1>
              <span class="badge bg-warning text-dark" title="Admin requires 2FA &mdash; set via Edit Options. Independent of enrollment state."><i class="fas fa-exclamation-triangle me-1"></i>Required</span>
            </cfif>
            <cfif NOT isTwoFactor AND Val(enforce_mfa) NEQ 1>
              <span class="text-muted">&mdash;</span>
            </cfif>
          </td>
          <td>#HTMLEditFormat(policy_name)#</td>
          <td><cfif report_enabled NEQ "NO"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
          <td><cfif train_bayes EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
          <td><cfif download_msg EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
          <td><cfif pdf_enabled EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
          <td><cfif smime_enabled EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
          <td><cfif pgp_enabled EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
          <td><cfif digital_sign EQ "YES"><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
          <td><cfif cert EQ "YES"><span class="badge bg-success"><i class="fas fa-certificate me-1"></i>YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif><cfif hasPendingJobs AND smime_enabled EQ "YES"><br><span class="badge bg-warning text-dark"><i class="fas fa-spinner fa-spin"></i></span></cfif></td>
          <td><cfif keystore EQ "YES"><span class="badge bg-success"><i class="fas fa-key me-1"></i>YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif><cfif hasPendingJobs AND pgp_enabled EQ "YES"><br><span class="badge bg-warning text-dark"><i class="fas fa-spinner fa-spin"></i></span></cfif></td>
          <td><cfif mb_nextcloud EQ 1><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
          <td><cfif active EQ 1><span class="badge bg-success">Active</span><cfelse><span class="badge bg-danger">Inactive</span></cfif></td>
        </tr>
        </cfoutput>
      </tbody>
      <tfoot>
        <tr>
          <th>Actions</th>
          <th>S/MIME</th>
          <th>PGP</th>
          <th>Email</th>
          <th>Display Name</th>
          <th>Domain</th>
          <th>Quota</th>
          <th>Auth</th>
          <th>2FA</th>
          <th>Policy</th>
          <th>Notifications</th>
          <th>Train Bayes</th>
          <th>Download Msgs</th>
          <th>PDF Encrypt</th>
          <th>S/MIME Encrypt</th>
          <th>PGP Encrypt</th>
          <th>Sign All</th>
          <th>S/MIME Cert</th>
          <th>PGP Keyring</th>
          <th>Nextcloud</th>
          <th>Status</th>
        </tr>
      </tfoot>
    </table>
    </div><!--- /.table-responsive --->
  </div>
</div>

<!--- ================================================================
     EDIT OPTIONS MODAL
     ================================================================ --->
<div class="modal fade" id="editMailboxModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" action="view_mailboxes.cfm">
        <input type="hidden" name="action" value="edit_mailbox">
        <input type="hidden" name="mailbox_id" id="editMailboxId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit Mailbox Options</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <!--- Email (read-only) --->
          <div class="form-group mb-3">
            <label><strong>Email Address</strong></label>
            <input type="text" class="form-control" id="editEmail" readonly disabled>
          </div>

          <!--- Display Name --->
          <div class="form-group mb-3">
            <label><strong>Display Name</strong></label>
            <input type="text" class="form-control" name="edit_display_name" id="editDisplayName">
          </div>

          <!---
            Personal Information (#226). Pro-only fields used by signature
            placeholder substitution ({{user.first_name}}, {{user.title}},
            {{user.phone}}, etc.) and by department signature resolution.
            Visible but disabled in Community with an upsell badge; same
            pattern as the domain Organization Information card. Action
            handler skips the UPDATE on Community so existing values
            survive a Pro->Community downgrade.
          --->
          <div class="form-group mb-3">
            <a class="d-block text-decoration-none collapsed" data-bs-toggle="collapse"
               href="#editPersonalInfo" role="button" aria-expanded="false">
              <i class="fas fa-chevron-right me-1"></i>
              <strong>Personal Information</strong>
              <span class="text-muted small ms-1">(used in organizational signatures)</span>
              <cfif isPro>
                <span class="badge bg-success ms-2">PRO</span>
              <cfelse>
                <span class="badge bg-warning text-dark ms-2"><i class="fas fa-lock"></i> PRO</span>
              </cfif>
            </a>
            <div class="collapse mt-2 ps-3 border-start" id="editPersonalInfo">
              <cfif NOT isPro>
                <div class="alert alert-warning py-2 mb-3 small">
                  <i class="fas fa-star text-warning me-1"></i>
                  <strong>Available in Pro Edition.</strong>
                  Personal information is used for signature placeholder substitution
                  (<code>{{user.first_name}}</code>, <code>{{user.title}}</code>, etc.)
                  and department-based signature templates.
                  <a href="https://www.hermesseg.io" target="_blank">Learn More &rarr;</a>
                </div>
              </cfif>
              <div class="row">
                <div class="col-md-6 mb-2">
                  <label class="form-label small mb-1">First Name</label>
                  <input type="text" class="form-control" name="edit_first_name" id="editFirstName" maxlength="64" <cfif NOT isPro>disabled</cfif>>
                </div>
                <div class="col-md-6 mb-2">
                  <label class="form-label small mb-1">Last Name</label>
                  <input type="text" class="form-control" name="edit_last_name" id="editLastName" maxlength="64" <cfif NOT isPro>disabled</cfif>>
                </div>
              </div>
              <div class="mb-2">
                <label class="form-label small mb-1">Title</label>
                <input type="text" class="form-control" name="edit_title" id="editTitle" maxlength="128" placeholder="e.g. Senior Engineer" <cfif NOT isPro>disabled</cfif>>
              </div>
              <div class="row">
                <div class="col-md-6 mb-2">
                  <label class="form-label small mb-1">Phone</label>
                  <input type="text" class="form-control" name="edit_phone" id="editPhone" maxlength="64" placeholder="e.g. +1 555 555 0100" <cfif NOT isPro>disabled</cfif>>
                </div>
                <div class="col-md-6 mb-2">
                  <label class="form-label small mb-1">Mobile</label>
                  <input type="text" class="form-control" name="edit_mobile" id="editMobile" maxlength="64" <cfif NOT isPro>disabled</cfif>>
                </div>
              </div>
              <div class="mb-2">
                <label class="form-label small mb-1">Department</label>
                <input type="text" class="form-control" name="edit_department" id="editDepartment" maxlength="64" placeholder="e.g. Sales, Engineering" list="editDeptDataList" autocomplete="off" <cfif NOT isPro>disabled</cfif>>
                <datalist id="editDeptDataList"></datalist>
                <small class="form-text text-muted">Type a new department or pick an existing one for this domain.</small>
                <small class="text-muted">Determines which signature template applies. Leave blank to use the domain default.</small>
              </div>
            </div>
          </div>

          <!--- Quota --->
          <div class="form-group mb-3">
            <label><strong>Mailbox Quota (GB)</strong></label>
            <input type="number" class="form-control" name="edit_quota_gb" id="editQuotaGb" step="0.01" min="0.01" required>
          </div>

          <!--- Active --->
          <div class="form-group mb-3">
            <label><strong>Status</strong></label>
            <select class="form-control" name="edit_active" id="editActive">
              <option value="1">Active</option>
              <option value="0">Inactive</option>
            </select>
          </div>

          <!--- SVF Policy --->
          <div class="form-group mb-3">
            <label><strong>SVF Policy to Assign</strong></label>
            <select class="form-control" name="edit_policy" id="editPolicy">
              <cfoutput query="getAllPolicies">
                <option value="#policy_id#">#policy_name#<cfif default_policy EQ '1'> (Default)</cfif></option>
              </cfoutput>
            </select>
          </div>

          <!--- Quarantine Notifications --->
          <div class="form-group mb-3">
            <label><strong>Quarantine Notifications</strong></label>
            <p class="help-block">When enabled, users receive an email notification each time a message is quarantined, with a one-click release button.</p>
            <select class="form-control" name="edit_reports" id="editReports">
              <option value="YES">Enabled</option>
              <option value="NO">Disabled</option>
            </select>
          </div>

          <!--- Train Bayes --->
          <div class="form-group mb-3">
            <label><strong>Train Bayes Filter from User Portal</strong></label>
            <div class="alert alert-danger">
              <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
              <p>Ensure you do <strong>NOT</strong> enable for inexperienced recipients. Improperly training Bayes Filter will affect ALL recipients</p>
            </div>
            <select class="form-control" name="edit_train_bayes" id="editTrainBayes">
              <option value="0">Disable</option>
              <option value="1">Enable</option>
            </select>
          </div>

          <!--- Download Messages --->
          <div class="form-group mb-3">
            <label><strong>Download Messages from User Portal</strong></label>
            <div class="alert alert-danger">
              <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
              <p>Enabling can expose recipients to malware</p>
            </div>
            <select class="form-control" name="edit_download_msg" id="editDownloadMsg">
              <option value="0">Disable</option>
              <option value="1">Enable</option>
            </select>
          </div>

          <!--- Nextcloud --->
          <div class="form-group mb-3">
            <label><strong>Nextcloud Webmail</strong></label>
            <select class="form-control" name="edit_nextcloud_enabled" id="editNextcloud">
              <option value="0">Disable</option>
              <option value="1">Enable</option>
            </select>
            <small class="form-text text-warning" id="editNextcloudHint" style="display:none;"><i class="fas fa-exclamation-triangle me-1"></i>A new password is required when enabling Nextcloud for an existing user. Set the password below to create their email profile in the Mail app.</small>
            <div id="editNextcloudDeleteGroup" style="display:none;" class="mt-2">
              <div class="form-check">
                <input class="form-check-input" type="checkbox" name="nc_keep_account" id="ncKeepAccount" value="1" checked>
                <label class="form-check-label" for="ncKeepAccount">
                  Keep Nextcloud account data (calendar, contacts, files)
                </label>
              </div>
              <small class="form-text text-danger"><i class="fas fa-exclamation-triangle me-1"></i>When unchecked, the user's Nextcloud account and all associated data will be permanently deleted.</small>
            </div>
          </div>

          <!--- 2FA enforcement (#225) --->
          <div class="form-group mb-3">
            <label><strong>Two-Factor Authentication</strong></label>
            <select class="form-control" name="edit_enforce_mfa" id="editEnforceMfa">
              <option value="0">Disable</option>
              <option value="1">Enable</option>
            </select>
            <small class="form-text text-muted"><i class="fas fa-info-circle me-1"></i>When enabled, the user's web portal access becomes limited to <strong>Account Settings</strong>, <strong>My App Passwords</strong>, <strong>Set Up Your Devices</strong>, and <strong>Webmail &amp; Apps</strong> until they enable 2FA themselves. A banner directs them to Account Settings. After they click <em>Enable 2FA</em>, Authelia walks them through device registration (TOTP, security key, or Duo Push) on their next sign-in. Email, calendar, and contacts apps continue to work normally throughout &mdash; only the web portal is gated.</small>
          </div>

          <!--- Timezone --->
          <div class="form-group mb-3">
            <label><strong>Timezone</strong></label>
            <p class="help-block">Used for the user's vacation auto-reply schedule and dashboard timestamps. Defaults to system timezone; the user can change it in their Account Settings.</p>
            <select class="form-control" name="edit_timezone" id="editTimezone" style="width:100%;">
              <cfset zoneIdClass = createObject("java", "java.time.ZoneId")>
              <cfset availableZones = zoneIdClass.getAvailableZoneIds().toArray()>
              <cfset tzList = []>
              <cfloop array="#availableZones#" index="z">
                  <cfset ArrayAppend(tzList, z)>
              </cfloop>
              <cfset ArraySort(tzList, "textnocase")>
              <cfoutput>
              <cfloop array="#tzList#" index="z">
                <option value="#z#">#z#</option>
              </cfloop>
              </cfoutput>
            </select>
          </div>

          <!--- Auth Type (read-only) --->
          <div class="form-group mb-3">
            <label><strong>Authentication Type</strong></label>
            <input type="text" class="form-control" id="editAuthType" readonly disabled>
          </div>

          <!--- Change Password (local auth only) --->
          <div class="form-group mb-3" id="editPasswordGroup" style="display:none;">
            <label><strong>Change Password</strong></label>
            <div class="input-group">
              <input type="password" class="form-control" name="edit_password" id="editPasswordInput" minlength="12"
                     placeholder="Leave blank to keep current password">
              <button class="btn btn-outline-secondary" type="button" onclick="toggleEditPassword()" title="Show/Hide Password">
                <i class="fas fa-eye" id="editTogglePasswordIcon"></i>
              </button>
              <button class="btn btn-outline-primary" type="button" onclick="generateEditPassword()" title="Generate Password">
                <i class="fas fa-random"></i> Generate
              </button>
            </div>
            <small class="text-muted">Minimum 12 characters. No special characters. Leave blank to keep current password. Will be checked against known data breaches.</small>
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

<!--- ================================================================
     EDIT ENCRYPTION MODAL
     ================================================================ --->
<div class="modal fade" id="editEncryptionModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" action="view_mailboxes.cfm">
        <input type="hidden" name="action" value="edit_mailbox_encryption">
        <input type="hidden" name="mailbox_id" id="encMailboxId">
        <input type="hidden" name="recipient_email" id="encRecipientEmail">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-lock me-2"></i>Edit Encryption</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Editing encryption for: <strong id="encEmailDisplay"></strong></p>
          <cfinclude template="./inc/edit_encryption_form_fields.cfm">
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Save Encryption</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ================================================================
     ACCESS CONTROL MODAL
     ================================================================ --->
<!--- RESET 2FA DEVICES MODAL (#225 Phase 1.5).
     Was previously the "Recipient Access Control" modal with a radio
     for one_factor vs two_factor. That radio is now redundant — Edit
     Options' enforce_mfa checkbox is the canonical admin policy, and
     LDAP group membership is driven by the user's own toggle in
     user_settings.cfm.

     Two modes:
     - DEFAULT: clear TOTP + WebAuthn devices so the user re-registers
       on next sign-in. "User lost their phone" recovery path.
     - NUCLEAR (opt-in checkbox): also remove from cn=two_factor LDAP
       group. Forces the user back into the bootstrap flow regardless
       of whether they self-enrolled before — useful for "admin
       overrides the user's voluntary 2FA" cases or full account
       reset where re-enrollment must be re-consented to. --->
<div class="modal fade" id="accessControlModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_mailboxes.cfm">
        <input type="hidden" name="action" value="edit_mailbox_access_control">
        <input type="hidden" name="mailbox_id" id="acMailboxId">
        <input type="hidden" name="recipient_email" id="acRecipientEmail">
        <input type="hidden" name="ldap_username" id="acLdapUsername">
        <input type="hidden" name="delete_2fa_devices" value="1">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-mobile-alt me-2"></i>Reset 2FA Devices</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <p>Reset Two-Factor Authentication devices for <strong id="acRecipientLabel"></strong>?</p>

          <div class="alert alert-warning mb-3">
            <p class="mb-2"><i class="fas fa-exclamation-triangle me-1"></i> This deletes all <strong>TOTP and WebAuthn</strong> devices registered to this user in Authelia. They will be guided through device re-registration on their next sign-in.</p>
            <p class="mb-0"><i class="fas fa-info-circle me-1"></i> <strong>Does not affect Duo Push.</strong> Duo enrollments are managed through the <a href="https://admin.duosecurity.com" target="_blank" rel="noopener">Duo Admin Console</a>.</p>
          </div>

          <div class="border rounded p-3 bg-light">
            <div class="form-check mb-0">
              <input class="form-check-input" type="checkbox" name="also_remove_from_two_factor" id="acAlsoRemove2faGroup" value="1">
              <label class="form-check-label" for="acAlsoRemove2faGroup">
                <strong>Also remove user from the 2FA group <span class="badge bg-danger ms-1">Nuclear</span></strong>
              </label>
            </div>
            <p class="mb-0 mt-2 small text-muted">By default this modal only deletes registered devices &mdash; the user stays under 2FA enforcement and re-registers on next login. Check this option to <strong>also move the user out of <code>cn=two_factor</code> back to <code>cn=one_factor</code></strong>. Use this when the user must restart 2FA from scratch (e.g., admin override of a voluntary enrollment, or a full account reset). If the per-mailbox <em>Two-Factor Authentication</em> policy in Edit Options is still <em>Enable</em>, the user will be sent through the bootstrap flow on their next portal visit.</p>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-warning"><i class="fas fa-redo me-1"></i> Reset Devices</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ================================================================
     DELETE CONFIRMATION MODAL
     ================================================================ --->
<div class="modal fade" id="deleteMailboxModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_mailboxes.cfm">
        <input type="hidden" name="action" value="delete_mailbox">
        <input type="hidden" name="delete_mailbox_id" id="deleteMailboxId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-trash me-2 text-danger"></i>Delete Mailbox</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="alert alert-danger">
            <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
            <p>This will permanently delete the mailbox and remove the user from all systems:</p>
            <ul>
              <li>LDAP user account</li>
              <li>Encryption settings and certificates</li>
              <li>User portal settings</li>
              <li>Quarantine preferences</li>
              <li>Mailbox aliases pointing to this mailbox</li>
              <li>User mail filters (sieve rules)</li>
            </ul>
            <p class="mb-0"><strong>This action cannot be undone.</strong></p>
          </div>

          <!--- BCC map cascade warning - populated by AJAX on modal open --->
          <div id="deleteMailboxBccWarn" class="alert alert-warning" style="display:none;">
            <h5><i class="icon fas fa-exclamation-circle"></i> BCC map entries will also be deleted</h5>
            <p class="mb-0" id="deleteMailboxBccWarnText"></p>
          </div>

          <p>Are you sure you want to delete <strong id="deleteMailboxEmail"></strong>?</p>

          <div class="form-check mt-3">
            <input class="form-check-input" type="checkbox" name="delete_maildir" id="deleteMaildir" value="1" checked>
            <label class="form-check-label" for="deleteMaildir">
              Also delete all email messages from the server
            </label>
            <small class="form-text text-danger d-block"><i class="fas fa-exclamation-triangle me-1"></i>When checked, all messages in this mailbox will be permanently removed from the mail server. This cannot be undone.</small>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete Mailbox</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- ROTATE NC INTERNAL PASSWORD CONFIRMATION MODAL (#197 Phase 1) --->
<div class="modal fade" id="rotateNcPasswordModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_mailboxes.cfm">
        <input type="hidden" name="action" value="rotate_nc_password">
        <input type="hidden" name="rotate_mailbox_id" id="rotateNcMailboxId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-sync-alt me-2"></i>Rotate NC Internal Password</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>This regenerates the random local password stored in Nextcloud's <code>oc_users</code> table for <strong id="rotateNcMailboxEmail"></strong>.</p>
          <div class="alert alert-info mb-2">
            <p class="mb-1"><strong>What this affects:</strong></p>
            <ul class="mb-0">
              <li><strong>Nothing user-facing.</strong> NC Mail uses the &ldquo;Hermes System&rdquo; app password (Hermes <code>app_passwords</code>); CalDAV/CardDAV use user-generated app passwords. Neither depends on this credential.</li>
              <li>This is purely defense-in-depth &mdash; the rotation closes the back-channel risk where the user's login password could otherwise have been silently accepted by NC's DAV endpoint.</li>
            </ul>
          </div>
          <p class="mb-0"><small>The new value is random, never disclosed, and never displayed. There is nothing for the admin to copy or share.</small></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"><i class="fas fa-sync-alt me-1"></i> Rotate</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- SEND MOBILE SETUP PROFILE CONFIRMATION MODAL (#224 Phase 2c) --->
<div class="modal fade" id="resendMobileSetupModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_mailboxes.cfm">
        <input type="hidden" name="action" value="resend_mobile_setup">
        <input type="hidden" name="mailbox_id" id="resendMobileSetupMailboxId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-mobile-alt me-2"></i>Send Mobile Setup Profile</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>This will email a one-time setup link to <strong id="resendMobileSetupEmail"></strong> with a signed Apple <code>.mobileconfig</code> profile that configures Mail, Calendar, and Contacts.</p>
          <div class="alert alert-info mb-2">
            <p class="mb-1"><strong>What this does:</strong></p>
            <ul class="mb-0">
              <li>Creates a fresh app password (visible to the user in <em>My App Passwords</em> as &ldquo;Mobile setup &lt;today's date&gt;&rdquo;).</li>
              <li>Generates and signs an iOS/macOS configuration profile with that password embedded.</li>
              <li>Emails the user a link &mdash; clicking it opens a page where they can scan a QR with their phone <em>or</em> download to install on the current device.</li>
            </ul>
          </div>
          <p class="mb-0"><small>The link expires in 30 minutes and works only once. Useful for non-technical users or anyone who can't sign in to the user portal themselves.</small></p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane me-1"></i> Send</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!--- (Reset DAV Password modal removed in #197 Phase 1b — superseded
     by per-mailbox app password mgmt + automatic NC oc_authtoken
     mirroring. The "Manage App Passwords" row action handles all
     credential rotation now.) --->

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>

<script>
  // #226 Phase 2B: per-domain dept name lists from
  // SELECT DISTINCT mailboxes.department. Used by the Edit Mailbox
  // modal to populate the dept input's datalist (typeahead). Lucee
  // SerializeJSON uppercases struct keys but the keys are numeric
  // domain ids so no lower-casing needed; values preserve case.
  window.DEPT_OPTIONS_BY_DOMAIN = <cfoutput>#variables.deptOptionsByDomainJson#</cfoutput>;

  // Initialize DataTable
  $(document).ready(function() {
    var table = $('#mailboxesTable').DataTable({
      "order": [[3, "asc"]],
      "pageLength": 25,
      "stateSave": true,
      "columnDefs": [
        { "orderable": false, "targets": [0, 1, 2] }
      ]
    });

    // Domain filter dropdown (column 5 = Domain)
    $('#domainFilter').on('change', function() {
      var val = $(this).val();
      table.column(5).search(val ? '^' + $.fn.dataTable.util.escapeRegex(val) + '$' : '', true, false).draw();
    });

    // Initialize Tom Select for the edit-mailbox timezone dropdown
    if (typeof TomSelect !== 'undefined' && document.getElementById('editTimezone')) {
      window.editTimezoneTS = new TomSelect('#editTimezone', {
        create: false,
        sortField: { field: 'text', direction: 'asc' },
        maxOptions: 1000
      });
    }
  });

  var editTimezoneTS = null;

  // Load Edit Options modal via AJAX
  function loadEditModal(mailboxId) {
    $.post('./inc/get_mailbox_json.cfm', { id: mailboxId }, function(data) {
      try {
        var mb = (typeof data === 'string') ? JSON.parse(data) : data;
        if (mb.error) { alert('Error: ' + mb.error); return; }
        $('#editMailboxId').val(mb.id);
        $('#editEmail').val(mb.username);
        $('#editDisplayName').val(mb.name);
        $('#editFirstName').val(mb.first_name || '');
        $('#editLastName').val(mb.last_name || '');
        $('#editTitle').val(mb.title || '');
        $('#editPhone').val(mb.phone || '');
        $('#editMobile').val(mb.mobile || '');
        $('#editDepartment').val(mb.department || '');
        // #226 Phase 2B: populate the dept datalist with this
        // mailbox's domain depts. Free-text input still - admin can
        // type a new dept name or pick an existing one.
        (function () {
          var dl = document.getElementById('editDeptDataList');
          if (!dl) return;
          dl.innerHTML = '';
          var opts = (window.DEPT_OPTIONS_BY_DOMAIN || {})[String(mb.domain_id)] || [];
          opts.forEach(function (d) {
              var o = document.createElement('option');
              o.value = d;
              dl.appendChild(o);
          });
        })();
        $('#editQuotaGb').val(mb.quota_gb);
        $('#editActive').val(mb.active);
        $('#editPolicy').val(mb.policy_id);
        $('#editReports').val(mb.report_enabled);
        $('#editTrainBayes').val(mb.train_bayes);
        $('#editDownloadMsg').val(mb.download_msg);
        $('#editNextcloud').val(mb.nextcloud_enabled || '0');
        editNextcloudOriginal = String(mb.nextcloud_enabled || '0');
        $('#editNextcloudHint').hide();
        $('#editNextcloudDeleteGroup').hide();
        $('#editEnforceMfa').val(mb.enforce_mfa || '0');
        $('#ncKeepAccount').prop('checked', true);
        if (editTimezoneTS) {
          editTimezoneTS.setValue(mb.timezone || '');
        } else {
          $('#editTimezone').val(mb.timezone || '');
        }
        $('#editAuthType').val(mb.auth_type === 'remote' ? 'Remote' : 'Local');
        // Show password field only for local auth
        if (mb.auth_type === 'local') {
          $('#editPasswordGroup').show();
        } else {
          $('#editPasswordGroup').hide();
        }
        $('#editPasswordInput').val('');
        $('#editTogglePasswordIcon').removeClass('fa-eye-slash').addClass('fa-eye');
        $('#editPasswordInput').attr('type', 'password');
        new bootstrap.Modal(document.getElementById('editMailboxModal')).show();
      } catch(e) { alert('Error loading mailbox data.'); }
    });
  }

  // Generate random password (16 chars, alphanumeric only)
  function generatePassword(length) {
    var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    var password = '';
    var array = new Uint32Array(length);
    window.crypto.getRandomValues(array);
    for (var i = 0; i < length; i++) {
      password += chars[array[i] % chars.length];
    }
    return password;
  }

  // Edit modal: generate password
  function generateEditPassword() {
    var pwd = generatePassword(16);
    $('#editPasswordInput').val(pwd).attr('type', 'text');
    $('#editTogglePasswordIcon').removeClass('fa-eye').addClass('fa-eye-slash');
  }

  // Edit modal: toggle password visibility
  function toggleEditPassword() {
    var input = $('#editPasswordInput');
    var icon = $('#editTogglePasswordIcon');
    if (input.attr('type') === 'password') {
      input.attr('type', 'text');
      icon.removeClass('fa-eye').addClass('fa-eye-slash');
    } else {
      input.attr('type', 'password');
      icon.removeClass('fa-eye-slash').addClass('fa-eye');
    }
  }

  // Load Edit Encryption modal
  function loadEncryptionModal(mailboxId, email) {
    $('#encMailboxId').val(mailboxId);
    $('#encRecipientEmail').val(email);
    $('#encEmailDisplay').text(email);
    new bootstrap.Modal(document.getElementById('editEncryptionModal')).show();
  }

  // Load Reset 2FA Devices modal (#225 Phase 1.5)
  function loadAccessControlModal(mailboxId, email, ldapUsername) {
    $('#acMailboxId').val(mailboxId);
    $('#acRecipientEmail').val(email);
    $('#acLdapUsername').val(ldapUsername || email);
    $('#acRecipientLabel').text(email);
    new bootstrap.Modal(document.getElementById('accessControlModal')).show();
  }

  // Show hint when enabling Nextcloud on an existing mailbox
  var editNextcloudOriginal = '0';
  $('#editNextcloud').on('change', function() {
    if ($(this).val() === '1' && editNextcloudOriginal === '0') {
      $('#editNextcloudHint').show();
      $('#editNextcloudDeleteGroup').hide();
    } else if ($(this).val() === '0' && editNextcloudOriginal === '1') {
      $('#editNextcloudHint').hide();
      $('#editNextcloudDeleteGroup').show();
    } else {
      $('#editNextcloudHint').hide();
      $('#editNextcloudDeleteGroup').hide();
    }
  });

  // Confirm delete
  function confirmDelete(mailboxId, email) {
    $('#deleteMailboxId').val(mailboxId);
    $('#deleteMailboxEmail').text(email);
    // Hide/reset the BCC warning before fetching fresh count
    $('#deleteMailboxBccWarn').hide();
    $('#deleteMailboxBccWarnText').text('');
    $.post('./inc/get_mailbox_bcc_count.cfm', { mailbox_id: mailboxId }, function(data) {
      try {
        var r = (typeof data === 'string') ? JSON.parse(data) : data;
        if (r && r.count > 0) {
          var parts = [];
          if (r.as_address > 0) parts.push(r.as_address + ' rule(s) where this mailbox is the watched address');
          if (r.as_target > 0)  parts.push(r.as_target  + ' rule(s) where this mailbox is the BCC destination');
          var text = 'Deleting this mailbox will also remove ' + r.count + ' BCC map entr' + (r.count === 1 ? 'y' : 'ies') + ': ' + parts.join(', ') + '.';
          $('#deleteMailboxBccWarnText').text(text);
          $('#deleteMailboxBccWarn').show();
        }
      } catch(e) { /* silent - modal still works without warning */ }
    }, 'json');
    new bootstrap.Modal(document.getElementById('deleteMailboxModal')).show();
  }

  // Confirm rotate NC internal password (#197 Phase 1)
  function confirmRotateNcPassword(mailboxId, email) {
    $('#rotateNcMailboxId').val(mailboxId);
    $('#rotateNcMailboxEmail').text(email);
    new bootstrap.Modal(document.getElementById('rotateNcPasswordModal')).show();
  }

  // Confirm resend mobile setup profile (#224 Phase 2c)
  function confirmResendMobileSetup(mailboxId, email) {
    $('#resendMobileSetupMailboxId').val(mailboxId);
    $('#resendMobileSetupEmail').text(email);
    new bootstrap.Modal(document.getElementById('resendMobileSetupModal')).show();
  }
</script>

</html>
