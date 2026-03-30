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
  <title>Hermes SEG | External Recipient Encryption</title>
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
            <h1 class="m-0">External Recipient Encryption</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Ext Rec Encryption</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="show" default="manual">

<cfif StructKeyExists(session, "m_extenc") AND session.m_extenc is not "">
  <cfset m = session.m_extenc>
  <cfset session.m_extenc = "">
</cfif>
<cfif StructKeyExists(url, "show") AND url.show is not "">
  <cfset show = url.show>
</cfif>
<cfif StructKeyExists(url, "action") AND url.action is not "">
  <cfset urlAction = url.action>
<cfelse>
  <cfset urlAction = "">
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION: DELETE RECIPIENT --->
<cfif action is "delete_recipient">
  <cfif StructKeyExists(form, "delete_email") AND form.delete_email is not "">
    <cfset delete_email = trim(form.delete_email)>
    <cftry>
      <cfinclude template="./inc/delete_ext_recipient.cfm">
      <cfset session.m_extenc = 3>
      <cfcatch type="any">
        <cfset session.m_extenc = 20>
      </cfcatch>
    </cftry>
  </cfif>
  <cflocation url="view_ext_rec_encryption.cfm?show=#show#" addtoken="no">
</cfif>

<!--- Load recipients based on view type --->
<cfif show is "manual">
  <cfquery name="getextrecipients" datasource="djigzo">
    SELECT * FROM cm_users WHERE cm_locality = 'manual' ORDER BY cm_email ASC
  </cfquery>
<cfelse>
  <cfquery name="getextrecipients" datasource="djigzo">
    SELECT * FROM cm_users WHERE cm_locality IS NULL ORDER BY cm_email ASC
  </cfquery>
</cfif>

<!--- ALERTS --->
<cfif urlAction is "add">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient encryption options set.</p></div>
</cfif>
<cfif urlAction is "edit">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient encryption options updated.</p></div>
</cfif>
<cfif urlAction is "deletedcertificate">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient S/MIME certificate deleted.</p></div>
</cfif>
<cfif urlAction is "addedcertificate">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient S/MIME certificate created.</p></div>
</cfif>
<cfif urlAction is "sentcertificate">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient S/MIME certificate sent.</p></div>
</cfif>
<cfif urlAction is "portalpassword">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient portal password reset.</p></div>
</cfif>
<cfif urlAction is "pdfpassword">
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient PDF password reset.</p></div>
</cfif>
<cfif m is 3>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>External recipient deleted.</p>
    <p class="text-warning"><i class="fas fa-exclamation-triangle"></i> If you had a Sender Checks Bypass mapping for this recipient, you must re-create it under the Sender Checks Bypass section.</p></div>
</cfif>

<cfif m is 20>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to delete external recipient.</p></div>
</cfif>

<!--- PAGE GUIDE --->
<div class="callout callout-info mb-4">
  <h5><i class="fas fa-info-circle"></i> Page Guide</h5>
  <p class="mb-1">Manage encryption settings for external recipients. <strong>Manual</strong> recipients are explicitly created by administrators, while <strong>Auto</strong> recipients are automatically discovered by Ciphermail during email processing.</p>
  <p class="mb-0">Each recipient can be configured with S/MIME certificates, PGP keyrings, PDF encryption passwords, and portal access credentials. Use the <strong>Configure</strong> button to set encryption options for each recipient.</p>
</div>

<!--- TOOLBAR --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-users"></i> External Recipients
      <cfoutput>
      <cfif show is "manual">
        <span class="badge bg-primary ms-2">Manual</span>
      <cfelse>
        <span class="badge bg-info ms-2">Auto</span>
      </cfif>
      </cfoutput>
    </h3>
  </div>
  <div class="card-body">

    <div class="mb-3">
      <a href="view_create_ext_recipient.cfm" class="btn btn-primary">
        <i class="fas fa-plus-circle"></i> Create External Recipient
      </a>
      <cfoutput>
      <a href="view_ext_rec_encryption.cfm?show=manual" class="btn <cfif show is 'manual'>btn-secondary<cfelse>btn-outline-secondary</cfif>">
        <i class="fas fa-user-edit"></i> Manual Recipients
      </a>
      <a href="view_ext_rec_encryption.cfm?show=auto" class="btn <cfif show is 'auto'>btn-secondary<cfelse>btn-outline-secondary</cfif>">
        <i class="fas fa-robot"></i> Auto Recipients
      </a>
      </cfoutput>
    </div>

    <cfif getextrecipients.recordcount LT 1>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No <cfoutput>#show#</cfoutput> external recipients found.
      </div>
    <cfelse>
      <div class="table-responsive">
      <table id="extRecTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th>Recipient</th>
            <th style="width: 120px">Encryption</th>
            <th style="width: 90px">S/MIME</th>
            <th style="width: 90px">PGP</th>
            <th style="width: 260px">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getextrecipients">
            <!--- Get S/MIME certificate count --->
            <cfquery name="getsmimecount" datasource="djigzo">
              SELECT COUNT(*) as cnt FROM cm_certificates WHERE cm_email = <cfqueryparam value="#cm_email#" cfsqltype="cf_sql_varchar">
            </cfquery>
            <!--- Get PGP keyring count --->
            <cfquery name="getpgpcount" datasource="djigzo">
              SELECT COUNT(*) as cnt FROM cm_pgp_certificates WHERE cm_email = <cfqueryparam value="#cm_email#" cfsqltype="cf_sql_varchar">
            </cfquery>
            <tr>
              <td>#encodeForHTML(cm_email)#</td>
              <td class="text-center">
                <cfif cm_country is "pdf"><span class="badge bg-warning text-dark">PDF</span>
                <cfelseif cm_country is "smime"><span class="badge bg-success">S/MIME</span>
                <cfelseif cm_country is "pgp"><span class="badge bg-info">PGP</span>
                <cfelseif cm_country is "none"><span class="badge bg-secondary">None</span>
                <cfelse><span class="badge bg-light text-dark">#encodeForHTML(cm_country)#</span>
                </cfif>
              </td>
              <td class="text-center">
                <cfif getsmimecount.cnt GT 0>
                  <a href="view_ext_smime_certificates.cfm?email=#URLEncodedFormat(cm_email)#&show=#show#" class="badge bg-success" title="View S/MIME Certificates">
                    #getsmimecount.cnt# cert(s)
                  </a>
                <cfelse>
                  <span class="badge bg-secondary">None</span>
                </cfif>
              </td>
              <td class="text-center">
                <cfif getpgpcount.cnt GT 0>
                  <a href="view_ext_pgp_keyrings.cfm?email=#URLEncodedFormat(cm_email)#&show=#show#" class="badge bg-success" title="View PGP Keyrings">
                    #getpgpcount.cnt# key(s)
                  </a>
                <cfelse>
                  <span class="badge bg-secondary">None</span>
                </cfif>
              </td>
              <td class="text-center">
                <a href="view_ext_smime_certificates.cfm?email=#URLEncodedFormat(cm_email)#&show=#show#" class="btn btn-sm btn-outline-success" title="S/MIME Certificates">
                  <i class="fas fa-certificate"></i>
                </a>
                <a href="view_ext_pgp_keyrings.cfm?email=#URLEncodedFormat(cm_email)#&show=#show#" class="btn btn-sm btn-outline-info" title="PGP Keyrings">
                  <i class="fas fa-key"></i>
                </a>
                <form method="post" class="d-inline">
                  <input type="hidden" name="delete_email" value="#cm_email#">
                  <button type="submit" name="action" value="delete_recipient" class="btn btn-sm btn-outline-danger" title="Delete Recipient"
                    onclick="return confirm('Delete external recipient #encodeForJavaScript(cm_email)#? This will remove all certificates and keyrings.');">
                    <i class="fas fa-trash-alt"></i>
                  </button>
                </form>
              </td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
      </div>
    </cfif>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>


<script>
$(document).ready(function() {
  if ($('#extRecTable').length) {
    $('#extRecTable').DataTable({
      dom: 'Blfrtip',
      buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
      stateSave: true,
      lengthMenu: [[25, 50, 100, -1], ['25 rows', '50 rows', '100 rows', 'Show all']],
      order: [[0, 'asc']],
      columnDefs: [
        { orderable: false, targets: [4] },
        { searchable: false, targets: [4] }
      ]
    });
  }
});
</script>

</body>
</html>
