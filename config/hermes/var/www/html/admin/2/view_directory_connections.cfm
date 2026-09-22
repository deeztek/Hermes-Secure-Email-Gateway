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

<!--- Directory Connections (#332). Enumerate relay recipients from AD/LDAP. --->

<cfinclude template="./inc/directory_connection_actions.cfm" />
<cfinclude template="./inc/html_head.cfm" />

<script>
$(document).ready(function() {
    var addAuth = document.getElementById('add_auth_type');
    if (addAuth) { dcAuthChanged(addAuth, 'add_mapping_id'); }
    var addProv = document.getElementById('add_provider');
    if (addProv) { dcProviderChanged(addProv, 'add_'); }

    $('#dcTable').DataTable({
        dom: 'Blfrtip',
        buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
        stateSave: true,
        lengthMenu: [[25, 50, 100, -1], [25, 50, 100, "All"]],
        order: [[0, 'asc']]
    });
});

// Transport and port are separate fields, so the dropdown must not claim a
// port. It does move the port to the conventional default as a convenience,
// but only when the field still holds the other convention's default: a
// directory deliberately on 6636 is not clobbered by toggling transport.
function hermesSyncLdapPort(sel, portId) {
    var port = document.getElementById(portId);
    if (!port) { return; }
    var v = (port.value || '').trim();
    var wantsLdaps = (sel.value === 'ldaps' || sel.value === '1');
    if (wantsLdaps  && (v === '' || v === '389')) { port.value = '636'; }
    if (!wantsLdaps && (v === '' || v === '636')) { port.value = '389'; }
}

function dcFillEdit(el) {
    var d = el.dataset;
    document.getElementById('edit_connection_id').value   = d.id;
    document.getElementById('edit_entry_name').value       = d.name;
    document.getElementById('edit_mapping_id').value       = d.mappingid;
    document.getElementById('edit_server_address').value   = d.server;
    document.getElementById('edit_server_port').value      = d.port;
    document.getElementById('edit_base_dn').value          = d.basedn;
    document.getElementById('edit_bind_dn').value          = d.binddn;
    document.getElementById('edit_object_class').value     = d.objectclass;
    document.getElementById('edit_mail_attribute').value   = d.mailattr;
    document.getElementById('edit_extra_filter').value     = d.extrafilter;
    document.getElementById('edit_bind_password').value    = '';
    document.getElementById('edit_tls_mode').value         = d.tls;
    document.getElementById('edit_provider').value         = d.provider;
    document.getElementById('edit_google_subject').value   = d.gsubject || '';
    var saWrap = document.getElementById('edit_has_sa_wrap');
    if (saWrap) { saWrap.hidden = (d.hassa !== '1'); }
    dcProviderChanged(document.getElementById('edit_provider'), 'edit_');
    document.getElementById('edit_auth_type').value        = d.authtype;
    document.getElementById('edit_policy_id').value        = d.policyid;
    document.getElementById('edit_report_enabled').value   = d.report;
    document.getElementById('edit_download_msg').value     = d.download;
    document.getElementById('edit_train_bayes').value      = d.bayes;
    document.getElementById('edit_enforce_mfa').value      = d.mfa;
    document.getElementById('edit_send_welcome').value     = d.welcome;
    document.getElementById('edit_auto_apply').value       = d.autoapply;
    dcAuthChanged(document.getElementById('edit_auth_type'), 'edit_mapping_id');

    // The remove option only means something when a pair is installed.
    var rmWrap = document.getElementById('edit_remove_cert_wrap');
    var rmBox  = document.getElementById('edit_remove_client_cert');
    if (rmWrap) { rmWrap.hidden = (d.hascert !== '1'); }
    var caWrap = document.getElementById('edit_remove_ca_wrap');
    var caBox  = document.getElementById('edit_remove_ca_cert');
    if (caWrap) { caWrap.hidden = (d.hasca !== '1'); }
    if (caBox)  { caBox.checked = false; }
    if (rmBox)  { rmBox.checked = false; }
}

// The mapping only means anything for Remote auth, so it is hidden rather than
// disabled for Local: it is irrelevant there, not unavailable. Hiding also
// clears it, so a stale selection cannot be saved against a Local connection.
function dcAuthChanged(sel, mapSelectId) {
    var map   = document.getElementById(mapSelectId);
    var group = document.getElementById(mapSelectId + '_group');
    if (!map || !group) { return; }
    var remote = (sel.value === 'remote');
    group.hidden  = !remote;
    map.required  = remote;
    if (!remote) { map.value = '0'; }
}

// Google reads over REST and has none of the LDAP connection fields. Hiding
// them by the input's own name rather than tagging every row keeps the markup
// from sprouting classes that only JavaScript reads.
function dcProviderChanged(sel, prefix) {
    var isGoogle = (sel.value === 'google');
    var scope = sel.closest('.modal-body') || document;
    var ldapOnly = ['server_address','server_port','tls_mode','base_dn','bind_dn',
                    'bind_password','object_class','mail_attribute','extra_filter',
                    'ca_cert_file','client_cert_file','client_key_file'];
    ldapOnly.forEach(function (n) {
        var el = scope.querySelector('[name="' + n + '"]');
        if (!el) { return; }
        var box = el.closest('.row') || el.closest('.mb-3');
        if (box) { box.hidden = isGoogle; }

        // A hidden field that is still required blocks submit, and the browser
        // cannot focus it to say why, so the button appears to do nothing.
        // Remembering the original lets LDAP get its validation back.
        if (isGoogle) {
            if (el.required) { el.dataset.wasRequired = '1'; }
            el.required = false;
        } else if (el.dataset.wasRequired === '1') {
            el.required = true;
        }
    });

    // Blocks whose input sits deeper than the box that should disappear, so
    // closest() finds an inner row and leaves the label and help behind.
    scope.querySelectorAll('.dcLdapOnly').forEach(function (b) { b.hidden = isGoogle; });

    var g = document.getElementById(prefix + 'google_wrap');
    if (g) { g.hidden = !isGoogle; }
}

function dcAction(name, id, flag) {
    document.getElementById('dcActionName').value = name;
    document.getElementById('dcActionId').value   = id;
    document.getElementById('dcActionFlag').value = (typeof flag === 'undefined') ? '' : flag;
    document.getElementById('dcActionForm').submit();
}

function dcFillDelete(el) {
    var d = el.dataset;
    document.getElementById('delete_connection_id').value = d.id;
    document.getElementById('delete_name_display').textContent = d.name;
}
</script>

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
                <h1 class="m-0">Recipient Auto-Provisioning</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
                    <li class="breadcrumb-item">Recipients</li>
                    <li class="breadcrumb-item active">Auto-Provisioning</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<div class="content">
<div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
    <cfif session.m NEQ "">
        <cfset m = session.m>
        <cfset session.m = "">
    </cfif>
</cfif>
<cfparam name="session.dcError" default="">

<cfif m EQ "dc_add">
  <div class="alert alert-success alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <i class="fas fa-check"></i>&nbsp;Directory added.</div>
</cfif>
<cfif m EQ "dc_edit">
  <div class="alert alert-success alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <i class="fas fa-check"></i>&nbsp;Directory updated.</div>
</cfif>
<cfif m EQ "dc_delete">
  <div class="alert alert-success alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <i class="fas fa-check"></i>&nbsp;Directory deleted. Recipients it created were left in place.</div>
</cfif>
<cfif m EQ "dc_enabled">
  <div class="alert alert-success alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <i class="fas fa-check"></i>&nbsp;Directory enabled.</div>
</cfif>
<cfif m EQ "dc_disabled">
  <div class="alert alert-warning alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <i class="fas fa-pause"></i>&nbsp;Directory disabled. It will be skipped by the scheduled run.</div>
</cfif>
<cfif m EQ "dc_synced">
  <div class="alert alert-info alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <i class="fas fa-sync"></i>&nbsp;Sync finished. Check the result below, then open Review to apply what it found.</div>
</cfif>
<cfif m EQ "dc_error">
  <cfoutput>
  <div class="alert alert-danger alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <i class="fas fa-ban"></i>&nbsp;#EncodeForHTML(session.dcError)#</div>
  </cfoutput>
  <cfset session.dcError = "">
</cfif>

<cfquery name="getConnections" datasource="hermes">
  SELECT c.*, m.domain_name AS mapping_domain,
         (SELECT COUNT(*) FROM directory_import_staging s
           WHERE s.connection_id = c.id AND s.status = 'pending' AND s.action = 'insert') AS pending_new,
         (SELECT COUNT(*) FROM directory_import_staging s
           WHERE s.connection_id = c.id AND s.status = 'pending' AND s.action = 'vanished') AS pending_gone
    FROM directory_connections c
    LEFT JOIN remoteauth_mappings m ON m.id = c.remoteauth_mapping_id
   ORDER BY c.entry_name
</cfquery>

<cfquery name="getMappings" datasource="hermes">
  SELECT id, domain_name, server_address, server_port FROM remoteauth_mappings
   WHERE enabled = 1 ORDER BY domain_name
</cfquery>

<!--- RemoteAuth is a Pro feature (view_remoteauth.cfm gates on it), so a
     Community install has no mappings and must not be offered Remote. --->
<cfset dcProEdition = (isDefined("session.edition") AND session.edition EQ "Pro")>

<cfquery name="getPolicies" datasource="hermes">
  SELECT policy_id, policy_name, default_policy FROM spam_policies ORDER BY policy_name
</cfquery>

<div class="card card-secondary card-outline mb-4">
  <div class="card-header"><h3 class="card-title"><i class="fas fa-address-book"></i>&nbsp;How this works</h3></div>
  <div class="card-body">
    <p class="mb-2">A connection reads a directory on a schedule and <strong>stages</strong> the addresses it finds for review. Nothing is created until you apply it, and nothing is ever deleted automatically.</p>
    <p class="mb-2 text-muted"><small>Enumeration does not affect mail flow. A relay domain set to <strong>ANY</strong> already accepts mail for every address in the domain. Recipients exist so that per-recipient features work: encryption, the <strong>/users</strong> portal, and block or allow lists.</small></p>
    <p class="mb-0"><small><strong>Transport has two states.</strong>
    <strong>Plain LDAP</strong> is not encrypted, so the bind password crosses the network in the clear on every run, and unlike a login that is a standing credential.
    <strong>LDAPS</strong> is encrypted and verifies the directory's certificate against the CA bundle on the RemoteAuth page. There is no separate verification setting.</small></p>
  </div>
</div>

<div class="card card-primary card-outline">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-server"></i>&nbsp;Directories</h3>
    <div class="card-tools">
      <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addModal">
        <i class="fas fa-plus"></i>&nbsp;Add Directory
      </button>
    </div>
  </div>
  <div class="card-body table-responsive">
  <table id="dcTable" class="table table-bordered table-striped table-hover">
    <thead>
      <tr>
        <th>Name</th><th>Directory</th><th>Status</th>
        <th>Last Run</th><th>Pending</th><th>Actions</th>
      </tr>
    </thead>
    <tbody>
    <cfoutput query="getConnections">
      <tr>
        <td>#EncodeForHTML(getConnections.entry_name)#</td>
        <td>
          <cfif getConnections.provider IS "google">
            <span class="badge bg-danger"><i class="fab fa-google"></i>&nbsp;Workspace</span>
            <small class="text-muted ms-1">#EncodeForHTML(getConnections.google_subject)#</small>
          <cfelseif Len(getConnections.mapping_domain)>
            <span class="badge bg-info">RemoteAuth: #EncodeForHTML(getConnections.mapping_domain)#</span>
          <cfelse>
            #EncodeForHTML(getConnections.server_address)#:#getConnections.server_port#
          </cfif>
          <!--- Transport badges describe an LDAP connection. Admin SDK talks
                HTTPS REST, and tls_mode simply carries its column default
                there, so showing LDAPS would state something untrue. --->
          <cfif getConnections.provider IS NOT "google">
            <cfif getConnections.tls_mode IS "ldaps"><span class="badge bg-success">LDAPS</span></cfif>
            <cfif Len(Trim(getConnections.client_cert_file))><span class="badge bg-info" title="Client certificate installed"><i class="fas fa-id-badge"></i></span></cfif>
          </cfif>
        </td>
        <td>
          <cfif getConnections.enabled EQ 1>
            <span class="badge bg-success">Enabled</span>
          <cfelse>
            <span class="badge bg-secondary">Disabled</span>
          </cfif>
          <br>
          <cfif val(getConnections.auto_apply) EQ 1>
            <span class="badge bg-primary">Auto-provision</span>
          <cfelse>
            <span class="badge bg-light text-dark">Review first</span>
          </cfif>
          <br>
          <small class="text-muted">
            Auth: <cfif getConnections.auth_type IS "remote">Remote<cfelse>Local</cfif><cfif val(getConnections.send_welcome) EQ 0>, no welcome e-mail</cfif>
          </small>
        </td>
        <td>
          <cfif Len(getConnections.last_run_status)>
            <cfif getConnections.last_run_status IS "ok">
              <span class="badge bg-success">OK</span>
            <cfelse>
              <span class="badge bg-danger">Failed</span>
            </cfif>
            <br><small class="text-muted">#DateFormat(getConnections.last_run_at, "yyyy-mm-dd")# #TimeFormat(getConnections.last_run_at, "HH:mm")#</small>
            <br><small>#EncodeForHTML(Left(getConnections.last_run_message, 160))#</small>
          <cfelse>
            <span class="text-muted">Never run</span>
          </cfif>
        </td>
        <td>
          <cfif getConnections.pending_new GT 0>
            <span class="badge bg-primary">#getConnections.pending_new# new</span>
          </cfif>
          <cfif getConnections.pending_gone GT 0>
            <span class="badge bg-warning text-dark">#getConnections.pending_gone# gone</span>
          </cfif>
          <cfif getConnections.pending_new EQ 0 AND getConnections.pending_gone EQ 0>
            <span class="text-muted">--</span>
          </cfif>
        </td>
        <!--- No <form> in the cell. A form-wrapped button never lines up with a
              bare one, and a form inside a DataTable row is the thing that
              silently eats fields on submit. Every button here is a plain
              button driving the single hidden form below the table, which is
              the pattern view_rbl_configuration.cfm uses. --->
        <td>
        <div class="d-flex gap-1 align-items-center">
          <a href="view_directory_import.cfm?connection_id=#getConnections.id#" class="btn btn-sm btn-info" title="Review staged results">
            <i class="fas fa-list-check"></i>
          </a>
          <button type="button" class="btn btn-sm btn-secondary" title="Sync now"
                  onclick="dcAction('sync_now', '#getConnections.id#');"><i class="fas fa-sync"></i></button>
          <button type="button" class="btn btn-sm btn-warning" title="Edit"
                  data-bs-toggle="modal" data-bs-target="##editModal" onclick="dcFillEdit(this)"
                  data-id="#getConnections.id#"
                  data-name="#EncodeForHTMLAttribute(getConnections.entry_name)#"
                  data-mappingid="#val(getConnections.remoteauth_mapping_id)#"
                  data-server="#EncodeForHTMLAttribute(getConnections.server_address)#"
                  data-port="#getConnections.server_port#"
                  data-basedn="#EncodeForHTMLAttribute(getConnections.base_dn)#"
                  data-binddn="#EncodeForHTMLAttribute(getConnections.bind_dn)#"
                  data-objectclass="#EncodeForHTMLAttribute(getConnections.object_class)#"
                  data-mailattr="#EncodeForHTMLAttribute(getConnections.mail_attribute)#"
                  data-extrafilter="#EncodeForHTMLAttribute(getConnections.extra_filter)#"
                  data-tls="#EncodeForHTMLAttribute(getConnections.tls_mode)#"
                  data-provider="#EncodeForHTMLAttribute(getConnections.provider)#"
                  data-authtype="#EncodeForHTMLAttribute(getConnections.auth_type)#"
                  data-policyid="#val(getConnections.policy_id)#"
                  data-report="#EncodeForHTMLAttribute(getConnections.report_enabled)#"
                  data-download="#val(getConnections.download_msg)#"
                  data-bayes="#val(getConnections.train_bayes)#"
                  data-mfa="#val(getConnections.enforce_mfa)#"
                  data-welcome="#val(getConnections.send_welcome)#"
                  data-autoapply="#val(getConnections.auto_apply)#"
                  data-hascert="#(Len(Trim(getConnections.client_cert_file)) AND Len(Trim(getConnections.client_key_file)) ? 1 : 0)#"
                  data-hasca="#(Len(Trim(getConnections.ca_cert_file)) ? 1 : 0)#"
                  data-gsubject="#EncodeForHTMLAttribute(getConnections.google_subject)#"
                  data-hassa="#(Len(Trim(getConnections.google_sa_json)) ? 1 : 0)#">
            <i class="fas fa-edit"></i>
          </button>
          <button type="button" class="btn btn-sm btn-secondary" title="Enable or disable"
                  onclick="dcAction('toggle', '#getConnections.id#', '#(getConnections.enabled EQ 1 ? 0 : 1)#');">
            <i class="fas fa-power-off"></i>
          </button>
          <button type="button" class="btn btn-sm btn-danger" title="Delete"
                  data-bs-toggle="modal" data-bs-target="##deleteModal" onclick="dcFillDelete(this)"
                  data-id="#getConnections.id#"
                  data-name="#EncodeForHTMLAttribute(getConnections.entry_name)#">
            <i class="fas fa-trash"></i>
          </button>
        </div>
        </td>
      </tr>
    </cfoutput>
    </tbody>
  </table>
  </div>
</div>

<!--- One form for every row action. Lives outside the table so DataTables
     paging never detaches it from a row. --->
<form method="post" action="" id="dcActionForm">
  <input type="hidden" name="action"        id="dcActionName"  value="">
  <input type="hidden" name="connection_id" id="dcActionId"    value="">
  <input type="hidden" name="enabled"       id="dcActionFlag"  value="">
</form>

<!--- ============================ ADD MODAL ============================ --->
<div class="modal fade" id="addModal" tabindex="-1">
 <div class="modal-dialog modal-lg">
  <div class="modal-content">
   <form method="post" action="" enctype="multipart/form-data">
   <input type="hidden" name="action" value="add">
   <div class="modal-header"><h5 class="modal-title">Add Directory</h5>
     <button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
   <div class="modal-body">
     <cfoutput>
     <div class="row">
       <div class="col-md-12 mb-3">
         <label class="form-label"><strong>Name</strong></label>
         <input type="text" class="form-control" name="entry_name" maxlength="255" required>
         <small class="text-muted">A label for this connection.</small>

         <label class="form-label mt-2"><strong>Directory Type</strong></label>
         <select class="form-select" name="provider" id="add_provider" onchange="dcProviderChanged(this, 'add_')">
           <option value="ldap">LDAP / Active Directory</option>
           <option value="google">Google Workspace (Admin SDK)</option>
           <option value="graph" disabled>Microsoft 365 (Graph connector not built)</option>
         </select>
         <small class="text-muted">Where the user list is read from. How recipients authenticate is set separately below.<br>
         <strong>Google Workspace</strong> uses the Admin SDK and works on every tier. Secure LDAP is for <em>authentication</em> and is configured on the RemoteAuth page, not here.</small>
       </div>
     </div>
     <div class="row dcGoogleOnly" id="add_google_wrap" hidden>
       <div class="col-md-6 mb-3">
         <label class="form-label"><strong>Service Account Key</strong></label>
         <input type="file" class="form-control" name="google_sa_json" accept=".json,application/json">
         <small class="text-muted">The JSON key file downloaded when you created the service account. Stored encrypted.</small>
       </div>
       <div class="col-md-6 mb-3">
         <label class="form-label"><strong>Impersonate Administrator</strong></label>
         <input type="email" class="form-control" name="google_subject" id="add_google_subject" placeholder="admin@yourdomain.com" maxlength="255">
         <small class="text-muted">A super administrator in that Workspace. Domain-wide delegation lets the service account act as this person; the Directory API will not answer without one.</small>
       </div>
       <div class="col-md-12 mb-3">
         <div class="callout callout-info mb-0">
           <p class="mb-1"><strong>Before this works, authorise the service account in Google.</strong></p>
           <p class="mb-0"><small>Google Admin console &rarr; Security &rarr; Access and data control &rarr; API controls &rarr; Domain-wide delegation. Add the service account's <strong>client ID</strong> with the scope
           <code>https://www.googleapis.com/auth/admin.directory.user.readonly</code>.
           Your organisation may require a second super administrator to approve it.</small></p>
         </div>
       </div>
     </div>
     <div class="row dcLdapOnly" id="add_ldap_wrap">
       <div class="col-md-6 mb-3">
         <label class="form-label"><strong>Server Address</strong></label>
         <input type="text" class="form-control" name="server_address" maxlength="255" placeholder="dc01.example.local">
       </div>
       <div class="col-md-3 mb-3">
         <label class="form-label"><strong>Transport</strong></label>
         <select class="form-select" name="tls_mode" onchange="hermesSyncLdapPort(this, 'add_server_port')">
           <option value="ldaps" selected>LDAPS</option>
           <option value="none">Plain LDAP</option>
         </select>
         <small class="text-muted">LDAPS encrypts and verifies the certificate. Plain sends the bind password in the clear on every run.</small>
       </div>
       <div class="col-md-3 mb-3">
         <label class="form-label"><strong>Port</strong></label>
         <input type="number" class="form-control" name="server_port" id="add_server_port" value="636" min="1" max="65535">
       </div>
     </div>
     <div class="mb-3">
       <label class="form-label"><strong>Base DN</strong></label>
       <input type="text" class="form-control" name="base_dn" maxlength="500" placeholder="OU=Users,DC=example,DC=local" required>
       <small class="text-muted">Scope the search to an OU where you can. Active Directory returns at most 1000 entries in one search.</small>
     </div>
     <div class="row">
       <div class="col-md-6 mb-3">
         <label class="form-label"><strong>Bind DN</strong></label>
         <input type="text" class="form-control" name="bind_dn" maxlength="500" placeholder="CN=hermes-reader,OU=Service,DC=example,DC=local">
       </div>
       <div class="col-md-6 mb-3">
         <label class="form-label"><strong>Bind Password</strong></label>
         <input type="password" class="form-control" name="bind_password" autocomplete="new-password">
         <small class="text-muted">Stored encrypted. A read-only account is enough.</small>
       </div>
     </div>
     <div class="row">
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Object Class</strong></label>
         <input type="text" class="form-control" name="object_class" value="user" maxlength="64">
         <small class="text-muted">AD: <code>user</code>. OpenLDAP: <code>inetOrgPerson</code>.</small>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Mail Attribute</strong></label>
         <input type="text" class="form-control" name="mail_attribute" value="mail" maxlength="64">
         <small class="text-muted"><code>proxyAddresses</code> also works and picks up aliases.</small>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Extra Filter</strong></label>
         <input type="text" class="form-control" name="extra_filter" maxlength="500" placeholder="(!(userAccountControl:1.2.840.113556.1.4.803:=2))">
         <small class="text-muted">Optional, appended inside the AND.</small>
       </div>
     </div>

     <div class="row">
       <div class="col-md-12 mb-3">
         <label class="form-label"><strong>CA Bundle</strong> <span class="text-muted">(LDAPS only)</span></label>
         <input type="file" class="form-control" name="ca_cert_file" accept=".pem,.crt,.cer">
         <small class="text-muted">Only needed for a directory with a <strong>private</strong> certificate authority, such as an internal AD. Public roots are always trusted, so nothing is needed here for a cloud or commercially signed directory. Upload the certificate of the authority that <strong>issued</strong> it, not the directory's own, in <strong>Base-64 encoded X.509</strong>. For Active Directory, <code>certutil -ca.cert ca.cer</code> on the CA server. Separate from the RemoteAuth bundle.</small>
       </div>
     </div>
     <div class="row">
       <div class="col-md-12 mb-3 dcLdapOnly">
         <label class="form-label"><strong>Client Certificate</strong> <span class="text-muted">(optional)</span></label>
         <div class="row g-2">
           <div class="col-md-6">
             <label class="form-label d-block mb-1"><small class="text-muted">Certificate (<code>.pem</code>, <code>.crt</code>, <code>.cer</code>)</small></label>
             <input type="file" class="form-control" name="client_cert_file" accept=".pem,.crt,.cer">
           </div>
           <div class="col-md-6">
             <label class="form-label d-block mb-1"><small class="text-muted">Private key (<code>.pem</code>, <code>.key</code>)</small></label>
             <input type="file" class="form-control" name="client_key_file" accept=".pem,.key">
           </div>
         </div>
         <small class="text-muted">Certificate then private key, uploaded together. Only needed where the directory itself requires mutual TLS, which is unusual. <strong>For Google Workspace, use the Google Workspace (Admin SDK) directory type instead</strong> &mdash; it works on every tier and needs no certificate. Separate from the RemoteAuth certificate, so enumerating one directory and authenticating against another stays independent.</small>
       </div>
     </div>
     <hr>
     <h6 class="text-muted text-uppercase"><strong>Provisioning Defaults</strong></h6>
     <p class="text-muted"><small>Applied to every recipient this connection creates. Encryption is deliberately not here: turn S/MIME or PGP on afterwards from Relay Recipients using Bulk Edit.</small></p>

     <div class="row">
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Authentication</strong></label>
         <select class="form-select" name="auth_type" id="add_auth_type" onchange="dcAuthChanged(this, 'add_mapping_id')">
           <option value="local">Local (Hermes password, user resets it)</option>
           <cfif dcProEdition>
             <option value="remote">Remote (their organisation credentials)</option>
           <cfelse>
             <!--- Rendered but disabled on Community. A directory saved under Pro
                  keeps auth_type 'remote', and without an option to match it the
                  select shows blank and a save would silently convert it to
                  Local. Disabled keeps the real state visible and unselectable. --->
             <option value="remote" disabled>Remote &mdash; requires Pro</option>
           </cfif>
         </select>
       </div>
       <div class="col-md-4 mb-3" id="add_mapping_id_group">
         <label class="form-label"><strong>Authenticate Recipients Against</strong></label>
         <select class="form-select" name="remoteauth_mapping_id" id="add_mapping_id">
           <option value="0">None</option>
           <cfloop query="getMappings">
             <option value="#getMappings.id#">#EncodeForHTML(getMappings.domain_name)#</option>
           </cfloop>
         </select>
         <small class="text-muted">Where recipients sign in, which is not necessarily where the list is read from. They sign in as their <strong>e-mail address</strong> regardless of their username in that directory.</small>
         <cfif NOT dcProEdition><div class="text-muted"><small>Remote authentication requires Pro.</small></div></cfif>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>SVF Policy</strong></label>
         <select class="form-select" name="policy_id" id="add_policy_id">
           <option value="0">Use system default</option>
           <cfloop query="getPolicies">
             <option value="#getPolicies.policy_id#">#EncodeForHTML(getPolicies.policy_name)#<cfif getPolicies.default_policy IS "1"> (default)</cfif></option>
           </cfloop>
         </select>
       </div>
     </div>

     <div class="row">
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Quarantine Notifications</strong></label>
         <select class="form-select" name="report_enabled" id="add_report_enabled">
           <option value="YES">Enabled</option>
           <option value="NO">Disabled</option>
         </select>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Download Messages From Portal</strong></label>
         <select class="form-select" name="download_msg" id="add_download_msg">
           <option value="0">Disable</option>
           <option value="1">Enable</option>
         </select>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Train Bayes From Portal</strong></label>
         <select class="form-select" name="train_bayes" id="add_train_bayes">
           <option value="0">Disable</option>
           <option value="1">Enable</option>
         </select>
       </div>
     </div>

     <div class="row">
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Require 2FA</strong></label>
         <select class="form-select" name="enforce_mfa" id="add_enforce_mfa">
           <option value="0">Disable</option>
           <option value="1">Enable</option>
         </select>
         <small class="text-muted">The user enrols it themselves in Account Settings. Until they do, quarantine notification settings, sender filters and message history are withheld; the dashboard and releasing messages keep working.</small>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Send Welcome E-mail</strong></label>
         <select class="form-select" name="send_welcome" id="add_send_welcome">
           <option value="1">Yes</option>
           <option value="0">No</option>
         </select>
         <small class="text-muted">Turn off for a first bulk import of people who already have mail flowing.</small>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Provisioning Mode</strong></label>
         <select class="form-select" name="auto_apply" id="add_auto_apply">
           <option value="0">Stage for review</option>
           <option value="1">Create automatically</option>
         </select>
         <small class="text-muted">Automatic creates up to 25 per run. Recipients missing from the directory are always reported, never removed.</small>
       </div>
     </div>
     </cfoutput>
   </div>
   <div class="modal-footer">
     <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
     <button type="submit" class="btn btn-primary">Add Directory</button>
   </div>
   </form>
  </div>
 </div>
</div>

<!--- ============================ EDIT MODAL ============================ --->
<div class="modal fade" id="editModal" tabindex="-1">
 <div class="modal-dialog modal-lg">
  <div class="modal-content">
   <form method="post" action="" enctype="multipart/form-data">
   <input type="hidden" name="action" value="edit">
   <input type="hidden" name="connection_id" id="edit_connection_id">
   <div class="modal-header"><h5 class="modal-title">Edit Directory</h5>
     <button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
   <div class="modal-body">
     <cfoutput>
     <div class="row">
       <div class="col-md-12 mb-3">
         <label class="form-label"><strong>Name</strong></label>
         <input type="text" class="form-control" name="entry_name" id="edit_entry_name" maxlength="255" required>

         <label class="form-label mt-2"><strong>Directory Type</strong></label>
         <select class="form-select" name="provider" id="edit_provider" onchange="dcProviderChanged(this, 'edit_')">
           <option value="ldap">LDAP / Active Directory</option>
           <option value="google">Google Workspace (Admin SDK)</option>
           <option value="graph" disabled>Microsoft 365 (Graph connector not built)</option>
         </select>
         <small class="text-muted">Where the user list is read from. How recipients authenticate is set separately below.<br>
         <strong>Google Workspace</strong> uses the Admin SDK and works on every tier. Secure LDAP is for <em>authentication</em> and is configured on the RemoteAuth page, not here.</small>
       </div>
     </div>
     <div class="row dcGoogleOnly" id="edit_google_wrap" hidden>
       <div class="col-md-6 mb-3">
         <label class="form-label"><strong>Service Account Key</strong></label>
         <div class="form-check mb-1" id="edit_has_sa_wrap" hidden>
           <span class="badge bg-success"><i class="fas fa-key"></i> Installed</span>
           <small class="text-muted ms-1">Upload a new file only to replace it.</small>
         </div>
         <input type="file" class="form-control" name="google_sa_json" accept=".json,application/json">
         <small class="text-muted">The JSON key file downloaded when you created the service account. Stored encrypted.</small>
       </div>
       <div class="col-md-6 mb-3">
         <label class="form-label"><strong>Impersonate Administrator</strong></label>
         <input type="email" class="form-control" name="google_subject" id="edit_google_subject" placeholder="admin@yourdomain.com" maxlength="255">
         <small class="text-muted">A super administrator in that Workspace. Domain-wide delegation lets the service account act as this person; the Directory API will not answer without one.</small>
       </div>
       <div class="col-md-12 mb-3">
         <div class="callout callout-info mb-0">
           <p class="mb-1"><strong>Before this works, authorise the service account in Google.</strong></p>
           <p class="mb-0"><small>Google Admin console &rarr; Security &rarr; Access and data control &rarr; API controls &rarr; Domain-wide delegation. Add the service account's <strong>client ID</strong> with the scope
           <code>https://www.googleapis.com/auth/admin.directory.user.readonly</code>.
           Your organisation may require a second super administrator to approve it.</small></p>
         </div>
       </div>
     </div>
     <div class="row dcLdapOnly" id="edit_ldap_wrap">
       <div class="col-md-6 mb-3">
         <label class="form-label"><strong>Server Address</strong></label>
         <input type="text" class="form-control" name="server_address" id="edit_server_address" maxlength="255">
       </div>
       <div class="col-md-3 mb-3">
         <label class="form-label"><strong>Transport</strong></label>
         <select class="form-select" name="tls_mode" id="edit_tls_mode" onchange="hermesSyncLdapPort(this, 'edit_server_port')">
           <option value="ldaps">LDAPS</option>
           <option value="none">Plain LDAP</option>
         </select>
       </div>
       <div class="col-md-3 mb-3">
         <label class="form-label"><strong>Port</strong></label>
         <input type="number" class="form-control" name="server_port" id="edit_server_port" min="1" max="65535">
       </div>
     </div>
     <div class="mb-3">
       <label class="form-label"><strong>Base DN</strong></label>
       <input type="text" class="form-control" name="base_dn" id="edit_base_dn" maxlength="500" required>
     </div>
     <div class="row">
       <div class="col-md-6 mb-3">
         <label class="form-label"><strong>Bind DN</strong></label>
         <input type="text" class="form-control" name="bind_dn" id="edit_bind_dn" maxlength="500">
       </div>
       <div class="col-md-6 mb-3">
         <label class="form-label"><strong>Bind Password</strong></label>
         <input type="password" class="form-control" name="bind_password" id="edit_bind_password" autocomplete="new-password">
         <small class="text-muted">Leave blank to keep the stored password.</small>
       </div>
     </div>
     <div class="row">
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Object Class</strong></label>
         <input type="text" class="form-control" name="object_class" id="edit_object_class" maxlength="64">
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Mail Attribute</strong></label>
         <input type="text" class="form-control" name="mail_attribute" id="edit_mail_attribute" maxlength="64">
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Extra Filter</strong></label>
         <input type="text" class="form-control" name="extra_filter" id="edit_extra_filter" maxlength="500">
       </div>
     </div>

     <div class="row">
       <div class="col-md-12 mb-3">
         <label class="form-label"><strong>CA Bundle</strong> <span class="text-muted">(LDAPS only)</span></label>
         <div class="form-check mb-1" id="edit_remove_ca_wrap" hidden>
           <input class="form-check-input" type="checkbox" name="remove_ca_cert" id="edit_remove_ca_cert" value="1">
           <label class="form-check-label text-danger" for="edit_remove_ca_cert">Remove the installed CA bundle</label>
         </div>
         <input type="file" class="form-control" name="ca_cert_file" accept=".pem,.crt,.cer">
         <small class="text-muted">Only needed for a private certificate authority. Public roots are always trusted. Export the <strong>issuing</strong> authority, Base-64 encoded X.509. Separate from the RemoteAuth bundle.</small>
       </div>
     </div>
     <div class="row">
       <div class="col-md-12 mb-3 dcLdapOnly">
         <label class="form-label"><strong>Client Certificate</strong> <span class="text-muted">(optional)</span></label>
         <div class="form-check mb-1" id="edit_remove_cert_wrap" hidden>
           <input class="form-check-input" type="checkbox" name="remove_client_cert" id="edit_remove_client_cert" value="1">
           <label class="form-check-label text-danger" for="edit_remove_client_cert">Remove the installed certificate and key</label>
         </div>
         <div class="row g-2">
           <div class="col-md-6">
             <label class="form-label d-block mb-1"><small class="text-muted">Certificate (<code>.pem</code>, <code>.crt</code>, <code>.cer</code>)</small></label>
             <input type="file" class="form-control" name="client_cert_file" accept=".pem,.crt,.cer">
           </div>
           <div class="col-md-6">
             <label class="form-label d-block mb-1"><small class="text-muted">Private key (<code>.pem</code>, <code>.key</code>)</small></label>
             <input type="file" class="form-control" name="client_key_file" accept=".pem,.key">
           </div>
         </div>
         <small class="text-muted">Certificate then private key, uploaded together. Only needed where the directory itself requires mutual TLS, which is unusual. <strong>For Google Workspace, use the Google Workspace (Admin SDK) directory type instead</strong> &mdash; it works on every tier and needs no certificate. Separate from the RemoteAuth certificate, so enumerating one directory and authenticating against another stays independent.</small>
       </div>
     </div>
     <hr>
     <h6 class="text-muted text-uppercase"><strong>Provisioning Defaults</strong></h6>
     <p class="text-muted"><small>Applied to every recipient this connection creates. Encryption is deliberately not here: turn S/MIME or PGP on afterwards from Relay Recipients using Bulk Edit.</small></p>

     <div class="row">
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Authentication</strong></label>
         <select class="form-select" name="auth_type" id="edit_auth_type" onchange="dcAuthChanged(this, 'edit_mapping_id')">
           <option value="local">Local (Hermes password, user resets it)</option>
           <cfif dcProEdition>
             <option value="remote">Remote (their organisation credentials)</option>
           <cfelse>
             <!--- Rendered but disabled on Community. A directory saved under Pro
                  keeps auth_type 'remote', and without an option to match it the
                  select shows blank and a save would silently convert it to
                  Local. Disabled keeps the real state visible and unselectable. --->
             <option value="remote" disabled>Remote &mdash; requires Pro</option>
           </cfif>
         </select>
       </div>
       <div class="col-md-4 mb-3" id="edit_mapping_id_group">
         <label class="form-label"><strong>Authenticate Recipients Against</strong></label>
         <select class="form-select" name="remoteauth_mapping_id" id="edit_mapping_id">
           <option value="0">None</option>
           <cfloop query="getMappings">
             <option value="#getMappings.id#">#EncodeForHTML(getMappings.domain_name)#</option>
           </cfloop>
         </select>
         <small class="text-muted">Where recipients sign in, which is not necessarily where the list is read from. They sign in as their <strong>e-mail address</strong> regardless of their username in that directory.</small>
         <cfif NOT dcProEdition><div class="text-muted"><small>Remote authentication requires Pro.</small></div></cfif>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>SVF Policy</strong></label>
         <select class="form-select" name="policy_id" id="edit_policy_id">
           <option value="0">Use system default</option>
           <cfloop query="getPolicies">
             <option value="#getPolicies.policy_id#">#EncodeForHTML(getPolicies.policy_name)#<cfif getPolicies.default_policy IS "1"> (default)</cfif></option>
           </cfloop>
         </select>
       </div>
     </div>

     <div class="row">
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Quarantine Notifications</strong></label>
         <select class="form-select" name="report_enabled" id="edit_report_enabled">
           <option value="YES">Enabled</option>
           <option value="NO">Disabled</option>
         </select>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Download Messages From Portal</strong></label>
         <select class="form-select" name="download_msg" id="edit_download_msg">
           <option value="0">Disable</option>
           <option value="1">Enable</option>
         </select>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Train Bayes From Portal</strong></label>
         <select class="form-select" name="train_bayes" id="edit_train_bayes">
           <option value="0">Disable</option>
           <option value="1">Enable</option>
         </select>
       </div>
     </div>

     <div class="row">
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Require 2FA</strong></label>
         <select class="form-select" name="enforce_mfa" id="edit_enforce_mfa">
           <option value="0">Disable</option>
           <option value="1">Enable</option>
         </select>
         <small class="text-muted">The user enrols it themselves in Account Settings. Until they do, quarantine notification settings, sender filters and message history are withheld; the dashboard and releasing messages keep working.</small>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Send Welcome E-mail</strong></label>
         <select class="form-select" name="send_welcome" id="edit_send_welcome">
           <option value="1">Yes</option>
           <option value="0">No</option>
         </select>
         <small class="text-muted">Turn off for a first bulk import of people who already have mail flowing.</small>
       </div>
       <div class="col-md-4 mb-3">
         <label class="form-label"><strong>Provisioning Mode</strong></label>
         <select class="form-select" name="auto_apply" id="edit_auto_apply">
           <option value="0">Stage for review</option>
           <option value="1">Create automatically</option>
         </select>
         <small class="text-muted">Automatic creates up to 25 per run. Recipients missing from the directory are always reported, never removed.</small>
       </div>
     </div>
     </cfoutput>
   </div>
   <div class="modal-footer">
     <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
     <button type="submit" class="btn btn-warning">Save Changes</button>
   </div>
   </form>
  </div>
 </div>
</div>

<!--- ============================ DELETE MODAL ============================ --->
<div class="modal fade" id="deleteModal" tabindex="-1">
 <div class="modal-dialog">
  <div class="modal-content">
   <form method="post" action="" enctype="multipart/form-data">
   <input type="hidden" name="action" value="delete">
   <input type="hidden" name="connection_id" id="delete_connection_id">
   <div class="modal-header bg-danger"><h5 class="modal-title">Delete Directory</h5>
     <button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
   <div class="modal-body">
     <p>Delete <strong id="delete_name_display"></strong> and its staged results?</p>
     <p class="mb-0 text-muted"><small>Recipients this connection already created are <strong>not</strong> removed. They are live users with portal access and encryption settings, and stay exactly as they are.</small></p>
   </div>
   <div class="modal-footer">
     <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
     <button type="submit" class="btn btn-danger">Delete</button>
   </div>
   </form>
  </div>
 </div>
</div>

</div>
</div>
</main>

<cfinclude template="./inc/main_footer.cfm" />

</body>
</html>
