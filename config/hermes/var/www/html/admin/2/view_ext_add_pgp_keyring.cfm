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
  <title>Hermes SEG | Add PGP Keyring</title>
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
            <h1 class="m-0">Add PGP Keyring</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item"><a href="view_ext_rec_encryption.cfm">Ext Rec Encryption</a></li>
              <li class="breadcrumb-item active">Add PGP Keyring</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<!--- Validate parameters --->
<cfif NOT IsDefined("url.email") OR url.email is "">
  <cfset m="Add PGP Keyring: email parameter missing">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfparam name="url.show" default="manual">
<cfparam name="action" default="">
<cfparam name="m" default="0">

<cfif StructKeyExists(session, "m_addpgp") AND session.m_addpgp is not "">
  <cfset m = session.m_addpgp>
  <cfset session.m_addpgp = "">
</cfif>

<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- Get recipient --->
<cfquery name="getrecipient" datasource="hermes">
  SELECT id, email FROM external_recipients WHERE email = <cfqueryparam value="#url.email#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfif getrecipient.recordcount LT 1>
  <cfset m="Add PGP Keyring: recipient not found">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<!--- Set up variables needed by includes --->
<cfset type = 2>
<cfset url.type = "2">
<cfset url.id = getrecipient.id>

<!--- Simulate getrecipientdetails for the include --->
<cfquery name="getrecipientdetails" datasource="hermes">
  SELECT id, email AS recipient FROM external_recipients WHERE id = <cfqueryparam value="#getrecipient.id#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- ACTION: CREATE KEYRING --->
<cfif action is "create_keyring">
  <cfparam name="form.realname" default="">
  <cfparam name="form.encryption" default="4096">
  <cfparam name="form.password1" default="">
  <cfparam name="form.password2" default="">

  <!--- Validate --->
  <cfif trim(form.realname) is "">
    <cfset session.m_addpgp = 1>
    <cflocation url="view_ext_add_pgp_keyring.cfm?email=#URLEncodedFormat(url.email)#&show=#url.show#" addtoken="no">
  </cfif>
  <cfif REFind("[^a-zA-Z0-9 .]", form.realname) GT 0>
    <cfset session.m_addpgp = 2>
    <cflocation url="view_ext_add_pgp_keyring.cfm?email=#URLEncodedFormat(url.email)#&show=#url.show#" addtoken="no">
  </cfif>
  <cfif Len(form.password1) LT 10>
    <cfset session.m_addpgp = 3>
    <cflocation url="view_ext_add_pgp_keyring.cfm?email=#URLEncodedFormat(url.email)#&show=#url.show#" addtoken="no">
  </cfif>
  <cfif form.password1 NEQ form.password2>
    <cfset session.m_addpgp = 4>
    <cflocation url="view_ext_add_pgp_keyring.cfm?email=#URLEncodedFormat(url.email)#&show=#url.show#" addtoken="no">
  </cfif>

  <cfset password1 = form.password1>

  <cftry>
    <cfinclude template="./inc/create_keyring.cfm">
    <cfset session.m_pgpk = 5>
    <cflocation url="view_ext_pgp_keyrings.cfm?email=#URLEncodedFormat(url.email)#&show=#url.show#" addtoken="no">
    <cfcatch type="any">
      <cfset session.m_addpgp = 5>
      <cflocation url="view_ext_add_pgp_keyring.cfm?email=#URLEncodedFormat(url.email)#&show=#url.show#" addtoken="no">
    </cfcatch>
  </cftry>
</cfif>

<!--- ACTION: IMPORT KEY --->
<cfif action is "import_key">
  <cfparam name="form.keytype" default="">

  <cfif form.keytype is "" OR NOT ListFindNoCase("public,private", form.keytype)>
    <cfset session.m_addpgp = 6>
    <cflocation url="view_ext_add_pgp_keyring.cfm?email=#URLEncodedFormat(url.email)#&show=#url.show#" addtoken="no">
  </cfif>
  <cfif NOT StructKeyExists(form, "thekeyfile") OR form.thekeyfile is "">
    <cfset session.m_addpgp = 7>
    <cflocation url="view_ext_add_pgp_keyring.cfm?email=#URLEncodedFormat(url.email)#&show=#url.show#" addtoken="no">
  </cfif>

  <cfinclude template="./inc/generate_customtrans.cfm">

  <!--- Upload key file --->
  <cftry>
    <cffile action="upload" filefield="thekeyfile" destination="/opt/hermes/tmp/" nameconflict="overwrite">
    <cfset theKeyringName = "/opt/hermes/tmp/#cffile.serverFile#">

    <cfinclude template="./inc/import_keyring.cfm">
    <cfset session.m_pgpk = 6>
    <cflocation url="view_ext_pgp_keyrings.cfm?email=#URLEncodedFormat(url.email)#&show=#url.show#" addtoken="no">
    <cfcatch type="any">
      <cfset session.m_addpgp = 8>
      <cflocation url="view_ext_add_pgp_keyring.cfm?email=#URLEncodedFormat(url.email)#&show=#url.show#" addtoken="no">
    </cfcatch>
  </cftry>
</cfif>

<!--- ALERTS --->
<cfif m is 1>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Real Name cannot be empty.</p></div>
</cfif>
<cfif m is 2>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Real Name must contain only letters, numbers, spaces, and periods.</p></div>
</cfif>
<cfif m is 3>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Passphrase must be at least 10 characters.</p></div>
</cfif>
<cfif m is 4>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Passphrases do not match.</p></div>
</cfif>
<cfif m is 5>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to create PGP keyring. Please check the logs.</p></div>
</cfif>
<cfif m is 6>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Please select a key type (public or private).</p></div>
</cfif>
<cfif m is 7>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Validation Error</h4><p>Please select a PGP key file to upload.</p></div>
</cfif>
<cfif m is 8>
  <div class="alert alert-danger alert-dismissible"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4><p>Failed to import PGP key. Please check the logs.</p></div>
</cfif>

<!--- TOOLBAR --->
<div class="mb-3">
  <cfoutput>
  <a href="view_ext_pgp_keyrings.cfm?email=#URLEncodedFormat(url.email)#&show=#url.show#" class="btn btn-secondary">
    <i class="fas fa-arrow-left"></i> Back to Keyrings
  </a>
  </cfoutput>
</div>

<cfoutput>
<p class="text-muted mb-3">Recipient: <strong>#encodeForHTML(getrecipient.email)#</strong></p>
</cfoutput>

<!--- CREATE PGP KEYRING --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-plus-circle"></i> Create PGP Keyring</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="create_keyring">
      <cfoutput><input type="hidden" name="recipient_id" value="#getrecipient.id#"></cfoutput>
      <div class="row mb-3">
        <div class="col-md-4">
          <label for="realname" class="form-label">Real Name</label>
          <input type="text" class="form-control" id="realname" name="realname" maxlength="255" required
            placeholder="e.g. John Smith">
          <small class="text-muted">Letters, numbers, spaces, and periods only</small>
        </div>
        <div class="col-md-2">
          <label class="form-label">Key Size</label>
          <select class="form-select" name="encryption">
            <option value="4096" selected>4096-bit</option>
            <option value="2048">2048-bit</option>
          </select>
        </div>
      </div>
      <div class="row mb-3">
        <div class="col-md-3">
          <label class="form-label">Passphrase</label>
          <input type="password" class="form-control" name="password1" maxlength="255" required placeholder="Minimum 10 characters">
          <small class="text-muted">Min 10 chars with letters and numbers</small>
        </div>
        <div class="col-md-3">
          <label class="form-label">Confirm Passphrase</label>
          <input type="password" class="form-control" name="password2" maxlength="255" required>
        </div>
      </div>
      <button type="submit" class="btn btn-primary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Creating...';this.form.submit();">
        <i class="fas fa-plus"></i> Create Keyring
      </button>
    </form>
  </div>
</div>

<!--- IMPORT PGP KEY --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-upload"></i> Import PGP Key</h3>
  </div>
  <div class="card-body">
    <form method="post" enctype="multipart/form-data" autocomplete="off">
      <input type="hidden" name="action" value="import_key">
      <cfoutput><input type="hidden" name="recipient_id" value="#getrecipient.id#"></cfoutput>
      <div class="row mb-3">
        <div class="col-md-3">
          <label class="form-label">Key Type</label>
          <div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="keytype" value="public" id="keytype_pub" checked>
              <label class="form-check-label" for="keytype_pub">Public Key</label>
            </div>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="radio" name="keytype" value="private" id="keytype_priv">
              <label class="form-check-label" for="keytype_priv">Private Key</label>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <label class="form-label">PGP Key File</label>
          <input type="file" class="form-control" name="thekeyfile" accept=".asc,.gpg,.key,.pgp" required>
          <small class="text-muted">ASCII-armored or binary PGP key file</small>
        </div>
      </div>
      <button type="submit" class="btn btn-primary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Importing...';this.form.submit();">
        <i class="fas fa-upload"></i> Import Key
      </button>
    </form>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>


</body>
</html>
