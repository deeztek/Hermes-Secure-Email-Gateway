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
  <title>Hermes SEG | ARC Settings</title>
  <cfinclude template="./inc/html_head.cfm" />

  <!--- DataTable init for the ARC keys table -- mirrors the pattern in
       edit_domain_dkim.cfm so the keys area looks/behaves identically:
       Copy/CSV/Excel/PDF/Print export buttons, row-count selector, search,
       state saving. --->
  <script>
    $(document).ready(function() {
      $('#arcKeysTable').DataTable({
        dom: 'Blfrtip',
        buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
        stateSave: true,
        lengthMenu: [
          [25, 50, 100, -1],
          ['25 rows', '50 rows', '100 rows', 'Show all']
        ],
        "order": [[3, "asc"]]
      });
    });
  </script>

  <!--- Style for break-all on table cells (matches edit_domain_dkim.cfm). --->
  <style>
    td { word-break: break-all; }
    textarea {
      border: 1px solid #999999;
      width: 100%;
      margin: 5px 0;
      padding: 3px;
    }
    .textareacontainer { padding-right: 8px; }
  </style>
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
            <h1 class="m-0">ARC Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item active">ARC Settings</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m") AND session.m IS NOT "">
  <cfset m = session.m>
</cfif>
<cfif StructKeyExists(form, "action") AND form.action IS NOT "">
  <cfset action = form.action>
</cfif>

<!--- ACTION HANDLERS ---------------------------------------------------- --->
<!--- Every branch ends with cflocation back to view_arc_settings.cfm so the
     alert pattern works correctly. Reason: the `m` variable at the top of
     this file is set from session.m BEFORE these action handlers run.
     Setting session.m here only surfaces in the NEXT request -- the
     cflocation forces a fresh GET that reads session.m into m, renders
     the alert, and then wipes session.m. Mirrors the dkim_*_action.cfm
     pattern. --->
<cfif action IS "save_settings">
  <cfinclude template="./inc/arc_save_settings.cfm">
  <cflocation url="view_arc_settings.cfm" addtoken="no">

<cfelseif action IS "create_key">
  <!--- Single-identity model: only ONE active key at a time. Generating
       a new key replaces any existing one. We delete existing rows + key
       files first so the admin doesn't accumulate orphaned keypairs.

       Validation gates (server-side, in addition to HTML `required`):
         - signing_domain: bob@<domain> + IsValid("email", ...) pattern
           used elsewhere in Hermes (e.g. domain_add_action.cfm).
         - selector: must match DKIM selector syntax (RFC 6376 §3.6.1):
           start with alphanumeric, then alphanumeric / underscore /
           hyphen, max 63 chars (DNS label limit).
         - arckey: must be 1024 or 2048 (only sizes the dropdown offers).

       The signing-domain check validates DNS NAME SYNTAX only -- it does
       NOT verify the admin controls DNS for the entered domain. Real
       ownership enforcement happens at DNS publication time: if the
       admin doesn't own the domain, the <selector>._domainkey.<domain>
       TXT record cannot be published, and downstream verifiers reject
       the ARC seal as cv=fail. --->
  <cfset signing_domain = LCase(trim(form.signing_domain ?: ""))>
  <cfset selector       = trim(form.selector ?: "")>
  <cfset arckey_size    = trim(form.arckey ?: "")>

  <cfif signing_domain IS "" OR NOT IsValid("email", "bob@" & signing_domain)>
    <cfset session.m = 36>
    <cflocation url="view_arc_settings.cfm" addtoken="no">
  </cfif>
  <cfif selector IS "" OR NOT REFind("^[A-Za-z0-9][A-Za-z0-9_\-]{0,62}$", selector)>
    <cfset session.m = 37>
    <cflocation url="view_arc_settings.cfm" addtoken="no">
  </cfif>
  <cfif NOT ListFind("1024,2048", arckey_size)>
    <cfset session.m = 38>
    <cflocation url="view_arc_settings.cfm" addtoken="no">
  </cfif>

  <cfquery name="existing_keys" datasource="hermes">
    SELECT id, public, private FROM arc_sign
  </cfquery>
  <cfloop query="existing_keys">
    <cfset PubF = "/opt/hermes/arc/keys/#existing_keys.public#">
    <cfset PrvF = "/opt/hermes/arc/keys/#existing_keys.private#">
    <cfif fileExists(PubF)><cffile action="delete" file="#PubF#"></cfif>
    <cfif fileExists(PrvF)><cffile action="delete" file="#PrvF#"></cfif>
  </cfloop>
  <cfquery name="wipe_old_keys" datasource="hermes">
    DELETE FROM arc_sign
  </cfquery>

  <!--- arc_create_key.cfm references getdomain.domain - mock it.
       It also reads form.selector and form.arckey -- both already
       validated above, so they pass through unmodified. --->
  <cfset getdomain = {domain = signing_domain}>
  <cfinclude template="./inc/arc_create_key.cfm">
  <cfset session.m = 30>
  <cflocation url="view_arc_settings.cfm" addtoken="no">

<cfelseif action IS "import_key">
  <!--- Same single-identity wipe-and-replace as create_key.
       Validation: signing_domain + import_selector + import_private_key
       (must be a non-empty PEM-shaped blob; openssl parses inside the
       container so deep cryptographic validation happens there). --->
  <cfset signing_domain     = LCase(trim(form.signing_domain ?: ""))>
  <cfset import_selector    = trim(form.import_selector ?: "")>
  <cfset import_private_key = trim(form.import_private_key ?: "")>

  <cfif signing_domain IS "" OR NOT IsValid("email", "bob@" & signing_domain)>
    <cfset session.m = 36>
    <cflocation url="view_arc_settings.cfm" addtoken="no">
  </cfif>
  <cfif import_selector IS "" OR NOT REFind("^[A-Za-z0-9][A-Za-z0-9_\-]{0,62}$", import_selector)>
    <cfset session.m = 37>
    <cflocation url="view_arc_settings.cfm" addtoken="no">
  </cfif>
  <cfif import_private_key IS "" OR NOT FindNoCase("-----BEGIN", import_private_key)>
    <cfset session.m = 39>
    <cflocation url="view_arc_settings.cfm" addtoken="no">
  </cfif>

  <cfquery name="existing_keys" datasource="hermes">
    SELECT id, public, private FROM arc_sign
  </cfquery>
  <cfloop query="existing_keys">
    <cfset PubF = "/opt/hermes/arc/keys/#existing_keys.public#">
    <cfset PrvF = "/opt/hermes/arc/keys/#existing_keys.private#">
    <cfif fileExists(PubF)><cffile action="delete" file="#PubF#"></cfif>
    <cfif fileExists(PrvF)><cffile action="delete" file="#PrvF#"></cfif>
  </cfloop>
  <cfquery name="wipe_old_keys" datasource="hermes">
    DELETE FROM arc_sign
  </cfquery>

  <cfset getdomain = {domain = signing_domain}>
  <cfinclude template="./inc/arc_import_key.cfm">
  <cfset session.m = 32>
  <cflocation url="view_arc_settings.cfm" addtoken="no">

<cfelseif action IS "delete_key">
  <cfinclude template="./inc/arc_delete_key.cfm">
  <cfinclude template="./inc/arc_generate_config_file.cfm">
  <cfinclude template="./inc/restart_openarc.cfm">
  <cfset session.m = 33>
  <cflocation url="view_arc_settings.cfm" addtoken="no">

<cfelseif action IS "enable_key">
  <!--- Mark the row as the active (enabled=1, applied=0 until save).
       Since single-identity wiped older rows at create time, this is
       effectively a "this is the one" flag. --->
  <cfquery name="enablearcsign" datasource="hermes">
    UPDATE arc_sign SET enabled = '1', applied = '0'
    WHERE id = <cfqueryparam value="#form.key_id#" CFSQLType="CF_SQL_INTEGER">
  </cfquery>
  <cfinclude template="./inc/arc_generate_config_file.cfm">
  <cfinclude template="./inc/restart_openarc.cfm">
  <cfquery name="markapplied" datasource="hermes">
    UPDATE arc_sign SET applied = '1' WHERE enabled = '1'
  </cfquery>
  <cfset session.m = 34>
  <cflocation url="view_arc_settings.cfm" addtoken="no">

<cfelseif action IS "disable_key">
  <cfquery name="disablearcsign" datasource="hermes">
    UPDATE arc_sign SET enabled = '0', applied = '0'
    WHERE id = <cfqueryparam value="#form.key_id#" CFSQLType="CF_SQL_INTEGER">
  </cfquery>
  <cfinclude template="./inc/arc_generate_config_file.cfm">
  <cfinclude template="./inc/restart_openarc.cfm">
  <cfset session.m = 35>
  <cflocation url="view_arc_settings.cfm" addtoken="no">
</cfif>

<!--- LOAD STATE ---------------------------------------------------------- --->
<cfinclude template="./inc/get_arc_settings.cfm">

<!--- Single-identity: pick the most recent row. If multiple exist
     (shouldn't, but defensive), pick the highest id. --->
<cfquery name="getarckey" datasource="hermes">
  SELECT id, domain, selector, public, private, enabled, generated, applied
  FROM arc_sign
  ORDER BY id DESC
</cfquery>

<!--- Sign/Verify mode options require a private key. Gate the dropdown:
     when no enabled arc_sign row exists, only "v" (verify only) is offered.
     Matches what arc_generate_config_file.cfm actually does at config-render
     time (force Mode=v if no active key) -- removes the silent-override
     confusion where an admin picks sv/s and doesn't realize it's ignored. --->
<cfset has_active_key = (getarckey.recordcount GTE 1 AND getarckey.enabled IS "1")>

<cfquery name="getdomains" datasource="hermes">
  SELECT id, domain FROM domains ORDER BY domain ASC
</cfquery>

<cfset session.m = "">

<!--- ALERTS ------------------------------------------------------------- --->
<cfif m IS "9">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    ARC settings saved. OpenARC reloaded.
  </div>
</cfif>
<cfif m IS "30">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    ARC key generated. Publish the DNS TXT record (shown below) before clicking <strong>Enable</strong>.
  </div>
</cfif>
<cfif m IS "31">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    Domain not found.
  </div>
</cfif>
<cfif m IS "32">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    ARC key imported.
  </div>
</cfif>
<cfif m IS "33">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    ARC key deleted.
  </div>
</cfif>
<cfif m IS "34">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    ARC key activated. OpenARC reloaded.
  </div>
</cfif>
<cfif m IS "35">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    ARC key disabled. OpenARC reloaded.
  </div>
</cfif>
<cfif m IS "36">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Signing Domain</h4>
    The signing domain you entered is not a valid DNS domain name. Enter a domain like <code>example.com</code> (lowercase, no <code>http://</code>, no spaces). The system did not generate a key.
  </div>
</cfif>
<cfif m IS "37">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Selector</h4>
    The selector cannot be empty and must consist of letters, numbers, hyphens, or underscores (starting with a letter or number), up to 63 characters. Examples: <code>arc1</code>, <code>mx2026</code>, <code>hermes-arc</code>. The system did not generate a key.
  </div>
</cfif>
<cfif m IS "38">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Key Size</h4>
    Key size must be 1024 or 2048. The system did not generate a key.
  </div>
</cfif>
<cfif m IS "39">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Private Key</h4>
    The imported private key is empty or does not look like a PEM-encoded RSA key (no <code>-----BEGIN</code> header found). Paste the full key block including the BEGIN/END lines.
  </div>
</cfif>

<!-- ARC SIGNING IDENTITY CARD (Step 1: generate key, publish DNS, enable) -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header d-flex justify-content-between align-items-center">
    <h3 class="card-title mb-0"><i class="fas fa-key"></i> Gateway ARC Signing Identity</h3>
    <div>
      <cfif getarckey.recordcount LT 1>
        <a href="##addarckey_modal" class="btn btn-primary" role="button" data-bs-toggle="modal">
          <i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add ARC Key
        </a>
        <a href="##importarckey_modal" class="btn btn-info" role="button" data-bs-toggle="modal">
          <i class="fa fa-upload fa-lg"></i>&nbsp;&nbsp;Import ARC Key
        </a>
      <cfelse>
        <a href="##addarckey_modal" class="btn btn-warning" role="button" data-bs-toggle="modal">
          <i class="fa fa-sync fa-lg"></i>&nbsp;&nbsp;Replace ARC Key
        </a>
      </cfif>
    </div>
  </div>
  <div class="card-body">
    <cfif getarckey.recordcount LT 1>
      <div class="callout callout-warning mb-0">
        <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i>
          No ARC signing key configured. Click <strong>Add ARC Key</strong>
          to generate one for this gateway. After generation you must publish
          the DNS TXT record (shown via <strong>View Public Key</strong>) and
          then click <strong>Enable</strong> to activate signing.
        </p>
      </div>
    <cfelse>
      <!--- No outer <form> wrapper: the table cells contain per-row Enable/
           Disable <form> submits, and HTML disallows nested forms. Browsers
           silently strip fields from inner forms when nested, which dropped
           the key_id input and caused "key [KEY_ID] doesn't exist". DKIM's
           equivalent page wraps its table in <form> only because all DKIM
           actions go through modals (with separate forms outside the table),
           so DKIM never hits the nesting collision. --->
        <table class="table table-striped" id="arcKeysTable" style="width:100%">
          <thead>
            <tr>
              <th>Delete</th>
              <th>View Public Key</th>
              <th>View Private Key</th>
              <th>ARC Selector</th>
              <th>DNS Record</th>
              <th>ARC Sign</th>
            </tr>
          </thead>
          <tbody>
            <cfoutput query="getarckey">

              <!--- Read the public-key BIND-zone file and extract just the
                   p= base64 portion for display, matching DKIM's pattern. --->
              <cfset PublicFiletoRead = "/opt/hermes/arc/keys/#public#">
              <cfif fileExists(PublicFiletoRead)>
                <cffile action="read" file="#PublicFiletoRead#" variable="arcpublicfile">
                <cfset rightPublic = "#trim(ListGetAt(arcpublicfile, 2, '('))#">
                <cfset publicKeyRaw = "#trim(ListGetAt(rightPublic, 1, ')'))#">
                <cfset publicKey = publicKeyRaw>
                <cfset publicKey = Replace(publicKey, '"', '', 'ALL')>
                <cfset publicKey = Replace(publicKey, Chr(10), '', 'ALL')>
                <cfset publicKey = Replace(publicKey, Chr(13), '', 'ALL')>
                <cfset publicKey = Replace(publicKey, Chr(9), '', 'ALL')>
                <cfset publicKey = REReplace(publicKey, '\s+', ' ', 'ALL')>
                <cfset publicKey = Trim(publicKey)>
              <cfelse>
                <cfset publicKey = "(public key file missing at " & PublicFiletoRead & ")">
              </cfif>

              <cfset PrivateFiletoRead = "/opt/hermes/arc/keys/#private#">
              <cfif fileExists(PrivateFiletoRead)>
                <cffile action="read" file="#PrivateFiletoRead#" variable="arcprivatefile">
              <cfelse>
                <cfset arcprivatefile = "(private key file missing at " & PrivateFiletoRead & ")">
              </cfif>

              <tr>
                <td>
                  <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="##deletearckey_modal" data-keyid="#id#"><i class="fa fa-trash"></i></button>
                </td>
                <td>
                  <button type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="##viewArcPublickey_modal" data-key='#publicKey#'><i class="fas fa-search"></i></button>
                </td>
                <td>
                  <button type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="##viewArcPrivatekey_modal" data-key='#HTMLEditFormat(arcprivatefile)#'><i class="fas fa-search"></i></button>
                </td>
                <td>#selector#</td>
                <td>#selector#._domainkey.#domain#</td>
                <td class="align-middle">
                  <div class="form-check form-switch d-inline-block">
                    <input class="form-check-input arc-toggle"
                           type="checkbox"
                           role="switch"
                           id="arctoggle-#id#"
                           data-key-id="#id#"
                           <cfif enabled IS "1">checked</cfif>>
                    <label class="form-check-label" for="arctoggle-#id#">
                      <span class="toggle-state-label">
                        <cfif enabled IS "1">
                          <span class="badge bg-success">Enabled</span>
                        <cfelse>
                          <span class="badge bg-secondary">Disabled</span>
                        </cfif>
                      </span>
                    </label>
                  </div>
                </td>
              </tr>
            </cfoutput>
          </tbody>
        </table>
    </cfif>
  </div>
</div>

<!-- ARC GLOBAL SETTINGS CARD (Step 2: enable ARC + pick signing Mode) -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-link"></i> ARC Global Settings</h3>
  </div>
  <div class="card-body">

    <div class="callout callout-info mb-3">
      <p class="mb-0">
        <i class="icon fas fa-info-circle"></i>
        <strong>ARC (Authenticated Received Chain, RFC 8617)</strong> seals
        authentication results at each gateway hop so downstream verifiers
        (Gmail, Microsoft 365, etc.) trust the chain even when body
        modification (disclaimers, banners, forwarding) invalidates the
        original DKIM signature. The seal is applied at the
        post-content-filter re-injection point (<code>:10026</code>), after
        OpenDKIM signs outbound mail and after body_milter has finished
        modifications.
      </p>
    </div>

    <div class="callout callout-warning mb-3">
      <p class="mb-0">
        <i class="icon fas fa-exclamation-triangle"></i>
        OpenARC uses a <strong>single signing identity per gateway</strong> &mdash;
        not per-sender-domain like DKIM. This matches industry practice
        (Gmail signs all ARC seals with <code>d=google.com</code>, M365 with
        <code>d=outlook.com</code>, etc.). Generate the key in the card
        above first; once it's enabled, the <strong>Sign &amp; Verify</strong>
        and <strong>Sign only</strong> modes become available below.
      </p>
    </div>

    <div class="callout callout-warning mb-3">
      <p class="mb-2">
        <i class="icon fas fa-exclamation-triangle"></i>
        <strong>Hermes is the authoritative auth boundary.</strong> When
        Hermes injects an External Sender Banner or a disclaimer into a
        message that already carries an upstream <code>ARC-Seal</code>
        header (M365, Workspace, Mimecast, Proofpoint, Exclaimer, etc.),
        the body change invalidates the upstream chain's body hash.
        Hermes's own seal at <code>i=2</code> remains mathematically valid
        (computed over the modified body) but honestly records
        <code>cv=fail</code> for the upstream chain it can no longer
        validate. The original sender's <code>DKIM-Signature</code> body
        hash is also invalidated by the body change.
      </p>
      <p class="mb-2">
        <strong>This is by design.</strong> Customer downstream mail
        servers must be configured to trust Hermes implicitly &mdash; allowlist
        Hermes by IP / hostname and accept forwarded mail without re-running
        DKIM / SPF / DMARC / ARC checks. This is the same deployment model
        used by Mimecast, Proofpoint, and Barracuda customers. If a
        downstream MX is doing redundant auth checks on Hermes-forwarded
        mail, that is a misconfiguration on the customer's end &mdash; the
        fix is to allowlist Hermes there, not to silence reporting here.
      </p>
      <p class="mb-0">
        For cross-org scenarios where downstream allowlisting is not an
        option (e.g. forwarding to an M365 tenant that requires strict
        auth even from trusted gateways), Hermes can be added to the
        receiving M365 tenant's <strong>Trusted ARC Sealers</strong> list
        as the receiver-side equivalent of an allowlist. See the
        <a href="../../docs/admin/04-content-checks/trusted-arc-sealers-m365.md"
           target="_blank">Trusted ARC Sealers &mdash; M365 guide</a>.
      </p>
    </div>

    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="save_settings">

      <div class="row">
        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>ARC Enabled</strong></label>
            <select class="form-select" name="arc_signing_enabled">
              <option value="1" <cfif arc_signing_enabled IS "1">selected</cfif>>YES</option>
              <option value="0" <cfif arc_signing_enabled IS "0">selected</cfif>>NO</option>
            </select>
            <small class="form-text text-muted">Master on/off. <strong>NO</strong> puts OpenARC into pass-through mode (no signing, no verifying, no headers added) by listing every peer in <code>/opt/hermes/arc/PeerList</code>. The milter stays wired in postfix but does nothing.</small>
          </div>
        </div>

        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>AuthservID</strong></label>
            <cfoutput>
              <input type="text" class="form-control" name="arc_authserv_id" value="#arc_authserv_id#" placeholder="Defaults to host name">
              <small class="form-text text-muted">Identifies this gateway in ARC-Authentication-Results headers. Leave blank to use <code>#get_host_name.value#</code>.</small>
            </cfoutput>
          </div>
        </div>

        <div class="col-md-4">
          <div class="mb-3">
            <label class="form-label"><strong>Mode</strong></label>
            <select class="form-select" name="arc_mode">
              <cfif has_active_key>
                <option value="sv" <cfif arc_mode IS "sv">selected</cfif>>Sign &amp; Verify (Recommended)</option>
                <option value="s"  <cfif arc_mode IS "s">selected</cfif>>Sign only</option>
              </cfif>
              <option value="v"  <cfif arc_mode IS "v" OR NOT has_active_key>selected</cfif>>Verify only</option>
            </select>
            <small class="form-text text-muted">
              OpenARC operating mode.
              <cfif has_active_key>
                <strong>sv</strong> verifies any inbound chain then extends it; correct default for a gateway.
              <cfelse>
                <strong>Sign &amp; Verify</strong> and <strong>Sign only</strong> require an enabled ARC signing key &mdash; generate one in the card above first. Until a key is enabled, only <strong>Verify only</strong> is available.
              </cfif>
            </small>
          </div>
        </div>
      </div>

      <button type="submit" class="btn btn-primary">
        <i class="fas fa-save"></i> Save Settings
      </button>
    </form>
  </div>
</div>

<!-- VIEW PUBLIC KEY MODAL -->
<div class="modal fade" id="viewArcPublickey_modal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <h4 class="modal-title">View ARC Public Key</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>Copy and paste the key below into your ARC DNS TXT record at <code>&lt;selector&gt;._domainkey.&lt;domain&gt;</code>.</p>
        <div class="form-group">
          <label>Public Key</label>
          <div class="textareacontainer">
            <div id="arcpublickeyarea"></div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- VIEW PRIVATE KEY MODAL -->
<div class="modal fade" id="viewArcPrivatekey_modal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <h4 class="modal-title">View ARC Private Key</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>The Private Key below is shown for reference. It should be kept in a safe place and not shared. <strong>Do NOT</strong> attempt to enter the key below into your ARC DNS Record.</p>
        <div class="form-group">
          <label>Private Key</label>
          <div class="textareacontainer">
            <div id="arcprivatekeyarea"></div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- DELETE KEY MODAL -->
<div class="modal fade" id="deletearckey_modal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        <h4 class="modal-title">Delete ARC Key</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to delete this ARC signing key? This action is irreversible! This removes the private/public key files from disk and disables ARC signing.</p>
      </div>
      <div class="modal-footer">
        <form method="post">
          <input type="hidden" name="action" value="delete_key">
          <input type="hidden" name="key_id" value="">
          <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
        </form>
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>

<!-- JS HANDLERS: populate modal textareas / form fields from data attributes,
     and drive the form-switch ARC Sign slider via AJAX
     (mirrors view_scheduled_tasks.cfm's .job-toggle pattern). -->
<script>
  $('#viewArcPublickey_modal').on('show.bs.modal', function(e) {
    var key = $(e.relatedTarget).data('key');
    $("#arcpublickeyarea").html('<textarea rows="10" id="arcpublickeyarea" name="arcpublickeyarea" readonly>' + key + '</textarea>');
  });

  $('#viewArcPrivatekey_modal').on('show.bs.modal', function(e) {
    var key = $(e.relatedTarget).data('key');
    $("#arcprivatekeyarea").html('<textarea rows="10" id="arcprivatekeyarea" name="arcprivatekeyarea" readonly>' + key + '</textarea>');
  });

  $('#deletearckey_modal').on('show.bs.modal', function(e) {
    var key_id = $(e.relatedTarget).data('keyid');
    $(e.currentTarget).find('input[name="key_id"]').val(key_id);
  });

  // ARC Sign slider: AJAX toggle that updates arc_sign.enabled, regenerates
  // openarc.conf, and restarts hermes_openarc on the back end. On failure
  // the toggle reverts to its prior position so the UI never drifts from
  // server state.
  $('#arcKeysTable').on('change', '.arc-toggle', function() {
    var $toggle = $(this);
    var keyId = $toggle.data('key-id');
    var newState = $toggle.is(':checked') ? '1' : '0';
    var labelSpan = $toggle.closest('.form-switch').find('.toggle-state-label');
    var originallyChecked = !$toggle.is(':checked');  // pre-change state

    $toggle.prop('disabled', true);
    labelSpan.html('<span class="badge bg-warning text-dark">Saving...</span>');

    $.post('./inc/toggle_arc_action.cfm', { key_id: keyId, new_state: newState })
      .done(function(data) {
        var r = (typeof data === 'string') ? JSON.parse(data) : data;
        if (r.success) {
          if (r.reload) {
            // Enabling the key auto-syncs the global ARC Enabled + Mode
            // settings (in toggle_arc_action.cfm). Reload so the Global
            // Settings card visibly reflects the new state.
            location.reload();
            return;
          }
          if (newState === '1') {
            labelSpan.html('<span class="badge bg-success">Enabled</span>');
          } else {
            labelSpan.html('<span class="badge bg-secondary">Disabled</span>');
          }
        } else {
          $toggle.prop('checked', originallyChecked);
          labelSpan.html(originallyChecked
            ? '<span class="badge bg-success">Enabled</span>'
            : '<span class="badge bg-secondary">Disabled</span>');
          alert('ARC toggle failed: ' + (r.error || 'unknown error'));
        }
      })
      .fail(function(xhr) {
        $toggle.prop('checked', originallyChecked);
        labelSpan.html(originallyChecked
          ? '<span class="badge bg-success">Enabled</span>'
          : '<span class="badge bg-secondary">Disabled</span>');
        alert('ARC toggle request failed: HTTP ' + xhr.status);
      })
      .always(function() {
        $toggle.prop('disabled', false);
      });
  });
</script>

<!-- GENERATE KEY MODAL -->
<div class="modal fade" id="addarckey_modal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <h4 class="modal-title">
          <cfif getarckey.recordcount LT 1>Generate ARC Key<cfelse>Replace ARC Key</cfif>
        </h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="create_key">
        <div class="modal-body">

          <cfif getarckey.recordcount GTE 1>
            <div class="alert alert-warning small">
              <strong>Replacing the existing key</strong> will delete the current key files from disk and create a new keypair. You must publish the new DNS record and re-enable.
            </div>
          </cfif>

          <div class="alert alert-warning small">
            <i class="fas fa-exclamation-triangle"></i>
            <strong>You must control DNS for the signing domain.</strong>
            After generation, you'll need to publish a TXT record at
            <code>&lt;selector&gt;._domainkey.&lt;domain&gt;</code>. If you don't control
            DNS for the domain you enter, your outbound ARC seals will fail
            verification at every downstream recipient. The seal can't impersonate
            the entered domain &mdash; verifiers reject it without the public key in DNS &mdash;
            but your own outbound trust chain is broken until you correct it.
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Gateway Signing Domain</strong></label>
            <input type="text" class="form-control" name="signing_domain" list="arc_signing_domains_datalist" placeholder="e.g. example.com" required autocapitalize="none" autocorrect="off" spellcheck="false">
            <datalist id="arc_signing_domains_datalist">
              <cfoutput query="getdomains">
                <option value="#domain#"></option>
              </cfoutput>
            </datalist>
            <small class="form-text text-muted">Start typing and your existing Hermes domains appear as suggestions &mdash; or enter any domain you control DNS for. Recommended: your primary mail domain (Gmail uses <code>d=google.com</code>, M365 uses <code>d=outlook.com</code>). This becomes the <code>d=</code> value in every ARC-Seal this gateway emits.</small>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Key Size</strong></label>
            <select class="form-select" name="arckey">
              <option value="2048" selected>2048-bit (Recommended)</option>
              <option value="1024">1024-bit</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Selector</strong></label>
            <input type="text" class="form-control" name="selector" placeholder="e.g. arc1" required autocapitalize="none" autocorrect="off" spellcheck="false">
            <small class="form-text text-muted">DNS label. Will publish at <code>&lt;selector&gt;._domainkey.&lt;domain&gt;</code>.</small>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Generate Key</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- IMPORT KEY MODAL -->
<div class="modal fade" id="importarckey_modal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header alert-primary">
        <h4 class="modal-title">Import ARC Key</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="import_key">
        <div class="modal-body">

          <div class="alert alert-warning small">
            <i class="fas fa-exclamation-triangle"></i>
            <strong>You must control DNS for the signing domain.</strong>
            The selector you enter here must already be (or will be) published at
            <code>&lt;selector&gt;._domainkey.&lt;domain&gt;</code> with the matching
            public key. Without that DNS record, downstream verifiers reject every
            ARC seal this gateway emits.
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Gateway Signing Domain</strong></label>
            <input type="text" class="form-control" name="signing_domain" list="arc_signing_domains_datalist_import" placeholder="e.g. example.com" required autocapitalize="none" autocorrect="off" spellcheck="false">
            <datalist id="arc_signing_domains_datalist_import">
              <cfoutput query="getdomains">
                <option value="#domain#"></option>
              </cfoutput>
            </datalist>
            <small class="form-text text-muted">Start typing and your existing Hermes domains appear as suggestions &mdash; or enter any domain you control DNS for.</small>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Selector</strong></label>
            <input type="text" class="form-control" name="import_selector" placeholder="e.g. arc1" required autocapitalize="none" autocorrect="off" spellcheck="false">
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Private Key (PEM)</strong></label>
            <textarea class="form-control" name="import_private_key" rows="12" placeholder="-----BEGIN RSA PRIVATE KEY-----&#10;...&#10;-----END RSA PRIVATE KEY-----" required></textarea>
            <small class="form-text text-muted">Paste the full PEM-encoded RSA private key. The public key + DNS TXT record will be derived automatically.</small>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Import Key</button>
        </div>
      </form>
    </div>
  </div>
</div>

      </div><!-- /.container-fluid -->
    </div><!-- /.app-content -->
  </main>

  <cfinclude template="./inc/main_footer.cfm" />
</div>
</body>
</html>
