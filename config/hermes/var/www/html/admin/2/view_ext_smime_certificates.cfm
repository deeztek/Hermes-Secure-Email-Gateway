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
  <title>Hermes SEG | S/MIME Certificates</title>
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
            <h1 class="m-0">S/MIME Certificates</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><a href="view_ext_rec_encryption.cfm">Ext Rec Encryption</a></li>
              <li class="breadcrumb-item active">S/MIME Certificates</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfset datasource = "hermes">

<!--- Validate email parameter --->
<cfif NOT IsDefined("url.email") OR url.email is "">
  <cfset m="View S/MIME Certificates: email parameter missing">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfparam name="url.show" default="manual">
<cfparam name="action" default="">
<cfparam name="m" default="0">

<cfif StructKeyExists(session, "m_smime") AND session.m_smime is not "">
  <cfset m = session.m_smime>
  <cfset session.m_smime = "">
</cfif>

<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- Get recipient details from external_recipients --->
<cfquery name="getrecipient" datasource="hermes">
  SELECT id, email FROM external_recipients WHERE email = <cfqueryparam value="#url.email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getrecipient.recordcount LT 1>
  <cfset m="View S/MIME Certificates: recipient not found">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfset recipientId = getrecipient.id>
<cfset recipientEmail = getrecipient.email>

<!--- ACTION: DELETE CERTIFICATE --->
<cfif action is "delete_cert">
  <cfif StructKeyExists(form, "certificate_id") AND IsNumeric(form.certificate_id)>
    <cfquery name="getcerts" datasource="hermes">
      SELECT * FROM recipient_certificates WHERE id = <cfqueryparam value="#form.certificate_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getcerts.recordcount GTE 1>
      <cftry>
        <cfinclude template="./inc/delete_smime_certificate.cfm">
        <cfset session.m_smime = 3>
        <cfcatch type="any">
          <cfset session.m_smime = 10>
        </cfcatch>
      </cftry>
    </cfif>
  </cfif>
  <cflocation url="view_ext_smime_certificates.cfm?email=#URLEncodedFormat(recipientEmail)#&show=#url.show#" addtoken="no">
</cfif>

<!--- ACTION: DOWNLOAD CERTIFICATE --->
<cfif action is "download_cert">
  <cfif StructKeyExists(form, "certificate_id") AND IsNumeric(form.certificate_id)>
    <cfquery name="getcerts" datasource="hermes">
      SELECT * FROM recipient_certificates WHERE id = <cfqueryparam value="#form.certificate_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getcerts.recordcount GTE 1>
      <cfinclude template="./inc/download_smime_certificate.cfm">
    </cfif>
  </cfif>
</cfif>

<!--- ACTION: SEND CERTIFICATE --->
<cfif action is "send_cert">
  <cfif StructKeyExists(form, "certificate_id") AND IsNumeric(form.certificate_id)>
    <cfquery name="getcerts" datasource="hermes">
      SELECT * FROM recipient_certificates WHERE id = <cfqueryparam value="#form.certificate_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getcerts.recordcount GTE 1>
      <cftry>
        <cfinclude template="./inc/send_smime_certificate.cfm">
        <cfset session.m_smime = 4>
        <cfcatch type="any">
          <cfset session.m_smime = 11>
        </cfcatch>
      </cftry>
    </cfif>
  </cfif>
  <cflocation url="view_ext_smime_certificates.cfm?email=#URLEncodedFormat(recipientEmail)#&show=#url.show#" addtoken="no">
</cfif>

<!--- Get certificates for this recipient --->
<cfquery name="getcertificates" datasource="hermes">
  SELECT * FROM recipient_certificates WHERE user_id = <cfqueryparam value="#recipientId#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- ALERTS --->
<cfif m is 3>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>S/MIME certificate deleted.</p></div>
</cfif>
<cfif m is 4>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>S/MIME certificate sent to recipient.</p></div>
</cfif>
<cfif m is 5>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>S/MIME certificate created successfully.</p></div>
</cfif>
<cfif m is 6>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>S/MIME certificate imported successfully.</p></div>
</cfif>
<cfif m is 10>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to delete S/MIME certificate.</p></div>
</cfif>
<cfif m is 11>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to send S/MIME certificate.</p></div>
</cfif>

<!--- TOOLBAR --->
<div class="mb-3">
  <cfoutput>
  <a href="view_ext_rec_encryption.cfm?show=#url.show#" class="btn btn-secondary">
    <i class="fas fa-arrow-left"></i> Back to Recipients
  </a>
  <a href="view_ext_add_smime_cert.cfm?email=#URLEncodedFormat(recipientEmail)#&show=#url.show#" class="btn btn-primary">
    <i class="fas fa-plus-circle"></i> Add S/MIME Certificate
  </a>
  </cfoutput>
</div>

<!--- CERTIFICATES TABLE --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-certificate"></i> S/MIME Certificates for <cfoutput>#encodeForHTML(recipientEmail)#</cfoutput></h3>
  </div>
  <div class="card-body">
    <cfif getcertificates.recordcount LT 1>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No S/MIME certificates found for this recipient.
      </div>
    <cfelse>
      <div class="table-responsive">
      <table class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th>CA</th>
            <th>Expires</th>
            <th>Key Length</th>
            <th>Algorithm</th>
            <th>Type</th>
            <th style="width: 200px">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getcertificates">
            <tr>
              <td>
                <cfif external_ca is "1">
                  #encodeForHTML(external_ca_name)#
                <cfelse>
                  <cfquery name="getca" datasource="hermes">
                    SELECT ca_commonname FROM ca_settings WHERE id = <cfqueryparam value="#ca_id#" cfsqltype="cf_sql_integer">
                  </cfquery>
                  <cfif getca.recordcount GTE 1>#encodeForHTML(getca.ca_commonname)#<cfelse>Unknown</cfif>
                </cfif>
              </td>
              <td>#DateFormat(smime_certificate_expiration, "yyyy-mm-dd")#</td>
              <td><cfif external_ca is "1">N/A<cfelse>#encodeForHTML(encryption)# bits</cfif></td>
              <td><cfif external_ca is "1">N/A<cfelse>#encodeForHTML(algorithm)#</cfif></td>
              <td><cfif external_ca is "1"><span class="badge bg-info">Imported</span><cfelse><span class="badge bg-primary">Internal</span></cfif></td>
              <td>
                <form method="post" class="d-inline">
                  <input type="hidden" name="certificate_id" value="#id#">
                  <button type="submit" name="action" value="download_cert" class="btn btn-sm btn-outline-primary" title="Download PFX">
                    <i class="fas fa-download"></i>
                  </button>
                  <button type="submit" name="action" value="send_cert" class="btn btn-sm btn-outline-success" title="Send to Recipient"
                    onclick="return confirm('Send certificate to #encodeForJavaScript(recipientEmail)#?');">
                    <i class="fas fa-envelope"></i>
                  </button>
                  <button type="submit" name="action" value="delete_cert" class="btn btn-sm btn-outline-danger" title="Delete Certificate"
                    onclick="return confirm('Delete this S/MIME certificate? This cannot be undone.');">
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


</body>
</html>
