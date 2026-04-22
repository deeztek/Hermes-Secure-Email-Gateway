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
  <title>Hermes SEG | Email Server - SAN Management</title>
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
            <h1 class="m-0">Email Server - SAN Management</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Email Server</li>
              <li class="breadcrumb-item active">SAN Management</li>
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
<cfif action EQ "add_san" OR action EQ "delete_san">
  <cfinclude template="./inc/san_actions.cfm">
</cfif>

<!--- SUCCESS / ERROR MESSAGES --->
<cfif m EQ 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    SAN prefix added and certificate SANs synchronized.
  </div>
<cfelseif m EQ 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    SAN prefix deleted and certificate SANs synchronized.
  </div>
<cfelseif m EQ 10>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Prefix cannot be blank.
  </div>
<cfelseif m EQ 11>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Invalid prefix. Only lowercase letters, numbers, and hyphens are allowed. Must start with a letter.
  </div>
<cfelseif m EQ 12>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    That prefix already exists.
  </div>
<cfelseif m EQ 13>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    System prefixes (<code>autoconfig</code>, <code>autodiscover</code>) cannot be deleted. They are required for email client auto-configuration.
  </div>
</cfif>

<!--- Query SAN prefixes early so the help callout can reference the count --->
<cfquery name="getSanPrefixes" datasource="hermes">
    SELECT id, san, system FROM additional_sans ORDER BY system ASC, san ASC
</cfquery>

<!--- HELP CALLOUT --->
<div class="alert alert-info alert-dismissible">
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
  <h5><i class="icon fas fa-info-circle"></i> About SAN Prefixes</h5>
  <p class="mb-1">SAN (Subject Alternative Name) prefixes are subdomain labels that get cross-joined with your mailbox-hosting domains to generate certificate SANs. For example, the prefix <code>mail</code> combined with the domain <code>example.com</code> produces the SAN <code>mail.example.com</code>.</p>
  <p class="mb-1">Adding or deleting a prefix here automatically syncs the SAN validation table. Certificate re-issuance is triggered automatically once DNS has been verified for the new SANs. DNS verification runs on a scheduled basis, so the updated certificate may not be issued immediately. Check the status of your certificates in <a href="view_system_certificates.cfm">System Certificates</a>.</p>
  <p class="mb-1"><small>System prefixes (<span class="badge bg-primary">System</span>) are required for email client auto-configuration (Autodiscover/Autoconfig) and cannot be removed.</small></p>
  <hr class="my-2">
  <p class="mb-0"><small><strong>Let's Encrypt SAN limit:</strong> Each domain certificate supports a maximum of <strong>100 SANs</strong>. With <strong><cfoutput>#getSanPrefixes.recordcount#</cfoutput></strong> prefixes configured, each domain's certificate uses <strong><cfoutput>#getSanPrefixes.recordcount + 1#</cfoutput> SANs</strong> (1 for the domain + <cfoutput>#getSanPrefixes.recordcount#</cfoutput> prefixes), leaving room for up to <strong><cfoutput>#99 - getSanPrefixes.recordcount#</cfoutput></strong> additional prefixes.</small></p>
</div>

<!--- ADD SAN PREFIX FORM --->
<div class="card col-sm-8 mb-3">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus me-2"></i>Add SAN Prefix</h3>
  </div>
  <div class="card-body">
    <form method="post" action="view_mailbox_sans.cfm" class="row g-3 align-items-end">
      <input type="hidden" name="action" value="add_san">
      <div class="col-md-6">
        <label class="form-label"><strong>Prefix</strong></label>
        <input type="text" class="form-control" name="san_prefix" placeholder="e.g., mail, imap, smtp, pop, webmail" maxlength="63" required pattern="[a-z][a-z0-9-]*">
        <small class="text-muted">Lowercase letters, numbers, and hyphens only. Must start with a letter.</small>
      </div>
      <div class="col-md-3">
        <button type="submit" class="btn btn-primary"><i class="fa fa-plus"></i>&nbsp;&nbsp;Add Prefix</button>
      </div>
    </form>
  </div>
</div>

<!--- CURRENT SAN PREFIXES --->
<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-network-wired me-2"></i>Configured SAN Prefixes (<cfoutput>#getSanPrefixes.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <table class="table table-bordered table-striped">
      <thead>
        <tr>
          <th>Prefix</th>
          <th>Type</th>
          <th>Example SAN</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getSanPrefixes">
        <tr>
          <td><code>#HTMLEditFormat(san)#</code></td>
          <td>
            <cfif system EQ 1>
              <span class="badge bg-primary">System (Required)</span>
            <cfelse>
              <span class="badge bg-secondary">Additional</span>
            </cfif>
          </td>
          <td><code>#HTMLEditFormat(san)#.example.com</code></td>
          <td>
            <cfif system NEQ 1>
              <button type="button" class="btn btn-sm btn-danger" onclick="confirmDeleteSan(#id#, '#JSStringFormat(san)#')">
                <i class="fas fa-trash"></i> Delete
              </button>
            <cfelse>
              <span class="text-muted">-</span>
            </cfif>
          </td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>

<!--- DELETE CONFIRMATION MODAL --->
<div class="modal fade" id="deleteSanModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="view_mailbox_sans.cfm">
        <input type="hidden" name="action" value="delete_san">
        <input type="hidden" name="delete_san_id" id="deleteSanId">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-trash me-2 text-danger"></i>Delete SAN Prefix</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="alert alert-warning">
            <h5><i class="icon fas fa-exclamation-triangle"></i> Warning</h5>
            <p>Deleting a SAN prefix will remove all matching SANs from the certificate validation table. Existing certificates that include these SANs will need to be re-issued without them.</p>
          </div>
          <p>Are you sure you want to delete the prefix <strong><code id="deleteSanName"></code></strong>?</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-danger">Delete Prefix</button>
        </div>
      </form>
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
  function confirmDeleteSan(sanId, sanName) {
    $('#deleteSanId').val(sanId);
    $('#deleteSanName').text(sanName);
    new bootstrap.Modal(document.getElementById('deleteSanModal')).show();
  }
</script>

</html>
