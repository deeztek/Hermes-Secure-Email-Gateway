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
  <title>Hermes SEG | PGP Keyrings</title>
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
            <h1 class="m-0">PGP Keyrings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><a href="view_ext_rec_encryption.cfm">Ext Rec Encryption</a></li>
              <li class="breadcrumb-item active">PGP Keyrings</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<!--- Validate email parameter --->
<cfif NOT IsDefined("url.email") OR url.email is "">
  <cfset m="View PGP Keyrings: email parameter missing">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfparam name="url.show" default="manual">
<cfparam name="action" default="">
<cfparam name="m" default="0">

<cfif StructKeyExists(session, "m_pgpk") AND session.m_pgpk is not "">
  <cfset m = session.m_pgpk>
  <cfset session.m_pgpk = "">
</cfif>

<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- Get recipient details --->
<cfquery name="getrecipient" datasource="hermes">
  SELECT id, email FROM external_recipients WHERE email = <cfqueryparam value="#url.email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif getrecipient.recordcount LT 1>
  <cfset m="View PGP Keyrings: recipient not found">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfset recipientId = getrecipient.id>
<cfset recipientEmail = getrecipient.email>

<!--- ACTION: DELETE KEYRING --->
<cfif action is "delete_key">
  <cfif StructKeyExists(form, "key_id") AND IsNumeric(form.key_id)>
    <cfquery name="getkeys" datasource="hermes">
      SELECT * FROM recipient_keystores WHERE id = <cfqueryparam value="#form.key_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getkeys.recordcount GTE 1>
      <cftry>
        <cfinclude template="./inc/delete_pgp_keyring.cfm">
        <cfset session.m_pgpk = 3>
        <cfcatch type="any">
          <cfset session.m_pgpk = 10>
        </cfcatch>
      </cftry>
    </cfif>
  </cfif>
  <cflocation url="view_ext_pgp_keyrings.cfm?email=#URLEncodedFormat(recipientEmail)#&show=#url.show#" addtoken="no">
</cfif>

<!--- ACTION: DOWNLOAD PUBLIC KEY --->
<cfif action is "download_public">
  <cfif StructKeyExists(form, "key_id") AND IsNumeric(form.key_id)>
    <cfquery name="getkeys" datasource="hermes">
      SELECT * FROM recipient_keystores WHERE id = <cfqueryparam value="#form.key_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getkeys.recordcount GTE 1>
      <cfinclude template="./inc/download_public_keyring.cfm">
    </cfif>
  </cfif>
</cfif>

<!--- ACTION: DOWNLOAD PRIVATE KEY --->
<cfif action is "download_private">
  <cfif StructKeyExists(form, "key_id") AND IsNumeric(form.key_id)>
    <cfquery name="getkeys" datasource="hermes">
      SELECT * FROM recipient_keystores WHERE id = <cfqueryparam value="#form.key_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getkeys.recordcount GTE 1>
      <cfinclude template="./inc/download_private_keyring.cfm">
    </cfif>
  </cfif>
</cfif>

<!--- ACTION: PUBLISH KEY --->
<cfif action is "publish_key">
  <cfif StructKeyExists(form, "key_id") AND IsNumeric(form.key_id) AND StructKeyExists(form, "keyserver_id") AND IsNumeric(form.keyserver_id)>
    <cfquery name="getkeydetails" datasource="hermes">
      SELECT * FROM recipient_keystores WHERE id = <cfqueryparam value="#form.key_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfquery name="getkeyservername" datasource="hermes">
      SELECT keyserver FROM pgp_keyservers WHERE id = <cfqueryparam value="#form.keyserver_id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getkeydetails.recordcount GTE 1 AND getkeyservername.recordcount GTE 1>
      <cftry>
        <cfinclude template="./inc/publish_pgp_keyring.cfm">
        <cfset session.m_pgpk = 7>
        <cfcatch type="any">
          <cfset session.m_pgpk = 11>
        </cfcatch>
      </cftry>
    </cfif>
  </cfif>
  <cflocation url="view_ext_pgp_keyrings.cfm?email=#URLEncodedFormat(recipientEmail)#&show=#url.show#" addtoken="no">
</cfif>

<!--- Get keyrings (master keys only) --->
<cfquery name="getkeyrings" datasource="hermes">
  SELECT * FROM recipient_keystores
  WHERE user_id = <cfqueryparam value="#recipientId#" cfsqltype="cf_sql_integer">
    AND master = '1'
</cfquery>

<!--- Get available keyservers for publish modal --->
<cfquery name="getAllKeyservers" datasource="hermes">
  SELECT id, keyserver FROM pgp_keyservers ORDER BY keyserver ASC
</cfquery>

<!--- ALERTS --->
<cfif m is 3>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>PGP keyring deleted.</p></div>
</cfif>
<cfif m is 5>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>PGP keyring created successfully.</p></div>
</cfif>
<cfif m is 6>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>PGP key imported successfully.</p></div>
</cfif>
<cfif m is 7>
  <div class="alert alert-success alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4><p>PGP key published to key server.</p></div>
</cfif>
<cfif m is 11>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to publish PGP key. The key server may have rejected the request.</p></div>
</cfif>
<cfif m is 10>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to delete PGP keyring.</p></div>
</cfif>

<!--- TOOLBAR --->
<div class="mb-3">
  <cfoutput>
  <a href="view_ext_rec_encryption.cfm?show=#url.show#" class="btn btn-secondary">
    <i class="fas fa-arrow-left"></i> Back to Recipients
  </a>
  <a href="view_ext_add_pgp_keyring.cfm?email=#URLEncodedFormat(recipientEmail)#&show=#url.show#" class="btn btn-primary">
    <i class="fas fa-plus-circle"></i> Add PGP Keyring
  </a>
  </cfoutput>
</div>

<!--- KEYRINGS TABLE --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-key"></i> PGP Keyrings for <cfoutput>#encodeForHTML(recipientEmail)#</cfoutput></h3>
  </div>
  <div class="card-body">
    <cfif getkeyrings.recordcount LT 1>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No PGP keyrings found for this recipient.
      </div>
    <cfelse>
      <div class="table-responsive">
      <table class="table table-bordered table-hover table-striped">
        <thead>
          <tr>
            <th>Type</th>
            <th>Size</th>
            <th>User-ID</th>
            <th>Created</th>
            <th>Expires</th>
            <th>Private Key</th>
            <th>Key ID</th>
            <th style="width: 200px">Actions</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getkeyrings">
            <cfquery name="getkeyservers" datasource="hermes">
              SELECT COUNT(*) as cnt FROM pgp_keyservers
            </cfquery>
            <tr>
              <td><span class="badge bg-primary">Master</span></td>
              <td>#encodeForHTML(encryption)#</td>
              <td>#encodeForHTML(user_name)#</td>
              <td>#DateFormat(pgp_keystore_creation, "yyyy-mm-dd")#</td>
              <td><cfif pgp_keystore_expiration is not "">#DateFormat(pgp_keystore_expiration, "yyyy-mm-dd")#<cfelse><span class="text-muted">Never</span></cfif></td>
              <td class="text-center"><cfif private_key is "1"><span class="badge bg-success">Yes</span><cfelse><span class="badge bg-secondary">No</span></cfif></td>
              <td><code>#encodeForHTML(key_id)#</code></td>
              <td>
                <form method="post" class="d-inline">
                  <input type="hidden" name="key_id" value="#id#">
                  <button type="submit" name="action" value="download_public" class="btn btn-sm btn-outline-primary" title="Download Public Key">
                    <i class="fas fa-download"></i> Pub
                  </button>
                  <cfif private_key is "1">
                    <button type="submit" name="action" value="download_private" class="btn btn-sm btn-outline-warning" title="Download Private Key">
                      <i class="fas fa-download"></i> Priv
                    </button>
                  </cfif>
                  <cfif getAllKeyservers.recordcount GT 0>
                    <button type="button" class="btn btn-sm btn-outline-info" title="Publish to Key Server"
                      onclick="openPublishModal('#id#', '#encodeForJavaScript(key_id)#');">
                      <i class="fas fa-globe"></i>
                    </button>
                  </cfif>
                  <button type="submit" name="action" value="delete_key" class="btn btn-sm btn-outline-danger" title="Delete Keyring"
                    onclick="return confirm('Delete this PGP keyring? This cannot be undone.');">
                    <i class="fas fa-trash-alt"></i>
                  </button>
                </form>
              </td>
            </tr>
            <!--- Show child/sub keys --->
            <cfquery name="getchildkeys" datasource="hermes">
              SELECT * FROM recipient_keystores WHERE parent = <cfqueryparam value="#id#" cfsqltype="cf_sql_integer"> AND master = '0'
            </cfquery>
            <cfloop query="getchildkeys">
              <tr class="table-light">
                <td><span class="badge bg-secondary">Sub</span></td>
                <td>#encodeForHTML(getchildkeys.encryption)#</td>
                <td>#encodeForHTML(getchildkeys.user_name)#</td>
                <td>#DateFormat(getchildkeys.pgp_keystore_creation, "yyyy-mm-dd")#</td>
                <td><cfif getchildkeys.pgp_keystore_expiration is not "">#DateFormat(getchildkeys.pgp_keystore_expiration, "yyyy-mm-dd")#<cfelse><span class="text-muted">Never</span></cfif></td>
                <td class="text-center"><cfif getchildkeys.private_key is "1"><span class="badge bg-success">Yes</span><cfelse><span class="badge bg-secondary">No</span></cfif></td>
                <td><code>#encodeForHTML(getchildkeys.key_id)#</code></td>
                <td></td>
              </tr>
            </cfloop>
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

<!--- PUBLISH MODAL --->
<cfif getAllKeyservers.recordcount GT 0>
<div class="modal fade" id="publishModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="publish_key">
        <input type="hidden" name="key_id" id="publish_key_id" value="">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-globe"></i> Publish PGP Key</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Publish key <strong id="publish_key_display"></strong> to a PGP key server.</p>
          <div class="mb-3">
            <label class="form-label">Select Key Server</label>
            <select class="form-select" name="keyserver_id" required>
              <cfoutput query="getAllKeyservers">
                <option value="#id#">#encodeForHTML(keyserver)#</option>
              </cfoutput>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Publishing...';this.form.submit();">
            <i class="fas fa-globe"></i> Publish
          </button>
        </div>
      </form>
    </div>
  </div>
</div>
</cfif>


<script>
function openPublishModal(keyDbId, keyId) {
  document.getElementById('publish_key_id').value = keyDbId;
  document.getElementById('publish_key_display').textContent = keyId;
  new bootstrap.Modal(document.getElementById('publishModal')).show();
}
</script>

</body>
</html>
