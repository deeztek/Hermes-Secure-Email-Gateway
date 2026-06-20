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
  <title>Hermes SEG | Antivirus Settings</title>
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
            <h1 class="m-0">Antivirus Settings</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Antivirus Settings</li>
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

<cfinclude template="./inc/get_antivirus_settings.cfm" />

<!--- Get AV whitelist entries --->
<cfquery name="getavwhitelist" datasource="hermes">
  SELECT id, parameter, module FROM parameters2 WHERE module = 'clamav-bypass'
</cfquery>

<!--- Session variables for whitelist add results --->
<cfparam name="session.success" default="0">
<cfparam name="session.success_entry" default="">
<cfparam name="session.invalid" default="0">
<cfparam name="session.invalid_entry" default="">
<cfparam name="session.exists" default="0">
<cfparam name="session.exists_entry" default="">

<cfset _success = session.success>
<cfset _success_entry = session.success_entry>
<cfset _invalid = session.invalid>
<cfset _invalid_entry = session.invalid_entry>
<cfset _exists = session.exists>
<cfset _exists_entry = session.exists_entry>

<cfset session.m = "">
<cfset session.success = 0>
<cfset session.success_entry = "">
<cfset session.invalid = 0>
<cfset session.invalid_entry = "">
<cfset session.exists = 0>
<cfset session.exists_entry = "">

<!--- ALERTS (data-driven) --->
<cfset alerts = {
  "9":  {type:"success", msg:"Antivirus Settings were saved successfully"},
  "11": {type:"danger",  msg:"You must first select entries before clicking the Delete button"},
  "12": {type:"success", msg:"Entries deleted successfully"},
  "13": {type:"danger",  msg:"The Entry field cannot be blank"}
}>

<cfif structKeyExists(alerts, toString(m))>
  <cfset a = alerts[toString(m)]>
  <cfoutput>
  <div class="alert alert-#a.type# alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <cfif a.type is "success"><h4><i class="icon fa fa-check"></i> Success</h4>
    <cfelse><h4><i class="icon fa fa-ban"></i> Error</h4></cfif>
    #a.msg#
  </div>
  </cfoutput>
</cfif>

<!--- Whitelist add result alerts --->
<cfif _success GTE 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    <cfoutput>The following #_success# entries were added successfully:</cfoutput><br>
    <cfoutput>#_success_entry#</cfoutput>
  </div>
</cfif>
<cfif _invalid is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Invalid Entries</h4>
    <cfoutput>The following #_invalid# entries were invalid:</cfoutput><br>
    <cfoutput>#_invalid_entry#</cfoutput>
  </div>
</cfif>
<cfif _exists is not "0">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Duplicate Entries</h4>
    <cfoutput>The following #_exists# entries already exist:</cfoutput><br>
    <cfoutput>#_exists_entry#</cfoutput>
  </div>
</cfif>

<!--- ACTION ROUTING --->
<cfif action is "AV Settings">

  <!--- Define required boolean fields --->
  <cfset avFields = "ScanMail,ScanArchive,ArchiveBlockEncrypted,ScanPE,ScanOLE2,OLE2BlockMacros,ScanPDF,ScanHTML,AlgorithmicDetection,ScanELF,PhishingSignatures,PhishingScanURLs,PhishingAlwaysBlockSSLMismatch,PhishingAlwaysBlockCloak,DetectPUA,HeuristicScanPrecedence">

  <!--- Validate all fields exist and are true/false --->
  <cfloop list="#avFields#" index="f">
    <cfif NOT StructKeyExists(form, f)>
      <cfset m = "Antivirus Settings: form.#f# does not exist">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
    </cfif>
    <cfif NOT ListFindNoCase("true,false", form[f])>
      <cfset m = "Antivirus Settings: form.#f# is not true or false">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
    </cfif>
  </cfloop>

  <!--- Set variables from form for the set_settings include --->
  <cfloop list="#avFields#" index="f">
    <cfset "#f#" = form[f]>
  </cfloop>

  <cfinclude template="./inc/antivirus_set_settings.cfm">
  <cfinclude template="./inc/generate_antivirus_configuration.cfm">

  <cfset session.m = 9>
  <cflocation url="view_antivirus_settings.cfm" addtoken="no">

<cfelseif action is "Delete Entry">

  <cfif NOT StructKeyExists(form, "delete_id") OR trim(form.delete_id) is "">
    <cfset session.m = 11>
    <cflocation url="view_antivirus_settings.cfm" addtoken="no">
  </cfif>

  <cfloop index="i" list="#form.delete_id#" delimiters=",">
    <cfif IsValid("integer", i)>
      <cfquery name="getentry" datasource="hermes">
        SELECT id FROM parameters2 WHERE id = <cfqueryparam value="#i#" cfsqltype="cf_sql_integer">
      </cfquery>
      <cfif getentry.recordcount GTE 1>
        <cfset delete_id = i>
        <cfinclude template="./inc/antivirus_delete_entry.cfm">
      </cfif>
    </cfif>
  </cfloop>

  <cfset session.m = 12>
  <cfinclude template="./inc/generate_antivirus_configuration.cfm">
  <cflocation url="view_antivirus_settings.cfm" addtoken="no">

<cfelseif action is "Add AV Whitelist">

  <cfif NOT StructKeyExists(form, "whitelist") OR trim(form.whitelist) is "">
    <cfset session.m = 13>
    <cflocation url="view_antivirus_settings.cfm" addtoken="no">
  </cfif>

  <cfinclude template="./inc/antivirus_add_whitelists.cfm">
  <cfinclude template="./inc/generate_antivirus_configuration.cfm">
  <cflocation url="view_antivirus_settings.cfm" addtoken="no">

</cfif>

<!--- ================================================================ --->
<!--- ANTIVIRUS SETTINGS CARD                                          --->
<!--- ================================================================ --->

<cfset avSettings = [
  {name:"ScanMail", label:"Scan Email Attachments", rec:"true",
   hint:"Enables scanning of email attachments for viruses and malware. This is the primary scanning function for inbound mail."},
  {name:"ScanArchive", label:"Scan Archives", rec:"true",
   hint:"Enables scanning inside compressed archives (ZIP, RAR, 7z, etc.). Without this, only the archive file itself is scanned, not its contents."},
  {name:"ArchiveBlockEncrypted", label:"Mark Encrypted Archives as Viruses", rec:"false",
   hint:"When enabled, encrypted archives that cannot be scanned are treated as viruses and blocked. This is aggressive and may cause false positives with legitimate password-protected files."},
  {name:"ScanPE", label:"Scan Portable Executables (Windows EXE)", rec:"true",
   hint:"Enables deep analysis of Windows executable files (PE format). Required for decompression of executable packers such as UPX, FSG, and Petite."},
  {name:"ScanOLE2", label:"Scan OLE2 Files (MS Office, .msi)", rec:"true",
   hint:"Enables scanning of OLE2 files such as Microsoft Office documents (.doc, .xls, .ppt) and Windows Installer (.msi) files."},
  {name:"OLE2BlockMacros", label:"Block OLE2 VBA Macros", rec:"false",
   hint:"When enabled, ALL OLE2 files containing VBA macros are blocked regardless of whether the macros are malicious. Detected as 'Heuristics.OLE2.ContainsMacros'. Has no effect if Scan OLE2 is disabled. Use with caution as it blocks legitimate macro-enabled documents."},
  {name:"ScanPDF", label:"Scan PDF Files", rec:"true",
   hint:"Enables scanning within PDF files for embedded malware, JavaScript exploits, and malicious content."},
  {name:"ScanHTML", label:"Scan HTML/JavaScript Content", rec:"true",
   hint:"Enables HTML detection, normalization, and decryption of JavaScript/ScriptEncoder content in email messages. Helps detect HTML-based phishing and script exploits."},
  {name:"AlgorithmicDetection", label:"Algorithmic Detection", rec:"true",
   hint:"Enables special detection algorithms for complex malware, exploits in graphic files, and other threats that cannot be detected by signatures alone."},
  {name:"ScanELF", label:"Scan ELF Files (Linux Executables)", rec:"true",
   hint:"Enables scanning of ELF (Executable and Linking Format) files, the standard executable format for Linux/Unix systems."},
  {name:"PhishingSignatures", label:"Phishing Signature Detection", rec:"true",
   hint:"Enables signature-based detection of phishing attempts in email messages using ClamAV's phishing signature database."},
  {name:"PhishingScanURLs", label:"Scan Email URLs for Phishing", rec:"true",
   hint:"Enables scanning of URLs within email messages to detect phishing attempts by checking against known phishing URL databases."},
  {name:"PhishingAlwaysBlockSSLMismatch", label:"Block SSL Mismatches in URLs", rec:"false",
   hint:"When enabled, blocks emails containing URLs where the displayed URL hostname does not match the actual SSL certificate. Can lead to false positives with legitimate CDN or redirect URLs."},
  {name:"PhishingAlwaysBlockCloak", label:"Block Cloaked URLs", rec:"false",
   hint:"When enabled, blocks emails containing cloaked URLs (where the visible link text differs from the actual URL destination). Can lead to false positives with URL shorteners and marketing links."},
  {name:"DetectPUA", label:"Detect Potentially Unwanted Applications", rec:"true",
   hint:"Enables detection of Potentially Unwanted Applications (PUA) such as adware, spyware, dialers, and other non-malicious but unwanted software."},
  {name:"HeuristicScanPrecedence", label:"Heuristic Scan Precedence", rec:"true",
   hint:"When enabled, heuristic scan results (phishing, macro detection) take priority and stop scanning immediately when detected. Saves CPU time. When disabled, heuristic detections are reported only after the full scan completes, allowing signature-based detections to take precedence."}
]>

<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-shield-virus"></i> ClamAV Antivirus Settings</h3>
  </div>
  <div class="card-body">
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="AV Settings">

      <div class="row">
        <cfloop array="#avSettings#" index="s">
          <div class="col-md-6">
            <div class="mb-3">
              <cfoutput>
              <label class="form-label"><strong>#s.label#</strong></label>
              <small class="form-text text-muted d-block mb-1">#s.hint#</small>
              <cfset currentVal = evaluate(s.name)>
              <select class="form-select" name="#s.name#">
                <cfif s.rec EQ "true">
                  <option value="true" <cfif currentVal is "true">selected</cfif>>Enabled (Recommended)</option>
                  <option value="false" <cfif currentVal is "false">selected</cfif>>Disabled</option>
                <cfelse>
                  <option value="false" <cfif currentVal is "false">selected</cfif>>Disabled (Recommended)</option>
                  <option value="true" <cfif currentVal is "true">selected</cfif>>Enabled</option>
                </cfif>
              </select>
              </cfoutput>
            </div>
          </div>
        </cfloop>
      </div>

      <button type="submit" class="btn btn-primary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
        <i class="fas fa-save"></i> Save &amp; Apply Settings
      </button>
    </form>
  </div>
</div>

<!--- ================================================================ --->
<!--- AV SIGNATURE WHITELIST CARD (Pro Edition Only)                   --->
<!--- ================================================================ --->

<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-list"></i> AV Signature Whitelist</h3>
  </div>
  <div class="card-body">

    <div class="alert alert-info mb-3">
      <i class="fas fa-info-circle me-1"></i> <strong>AV Signature Whitelist</strong> allows you to exclude specific ClamAV signature names from detection. Use this when ClamAV produces false positives on known-safe files.
      <hr>
      <strong>How to find a ClamAV signature name:</strong>
      <ol class="mb-1 mt-1">
        <li>Go to <strong>Message History</strong> and find the blocked message (Type column will show <strong>Virus</strong> or <strong>Banned</strong>)</li>
        <li>Check the mail filter logs for the message ID:<br>
          <code>docker logs hermes_mail_filter 2>&amp;1 | grep "mail_id_here"</code></li>
        <li>The log entry will show the signature name, for example:<br>
          <code>Blocked INFECTED (Heuristics.OLE2.ContainsMacros)</code><br>
          The text in parentheses is the signature name to whitelist</li>
        <li>Alternatively, scan a file directly to see what ClamAV detects:<br>
          <code>docker exec hermes_mail_filter clamscan /path/to/file</code></li>
      </ol>
      <small class="text-muted">Enter the exact signature name as reported by ClamAV. Multiple entries can be added at once, one per line.</small>
    </div>

    <div class="mb-3">
      <cfoutput>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##addWhitelistModal">
        <i class="fa fa-plus-square fa-lg"></i> Add Entries
      </button>
      </cfoutput>
      <button type="button" id="deleteWhitelists" class="btn btn-danger">
        <i class="fas fa-trash-alt"></i> Delete Selected
      </button>
    </div>

    <cfif getavwhitelist.recordcount GTE 1>
      <form id="whitelistForm">
      <div class="table-responsive">
        <table id="sortTable" class="table table-bordered table-hover table-striped" style="width:100%">
          <thead>
            <tr>
              <th style="width:40px"><input type="checkbox" id="selectAll"></th>
              <th>AV Signature</th>
            </tr>
          </thead>
          <tbody>
            <cfoutput query="getavwhitelist">
            <tr>
              <td><input type="checkbox" name="id" value="#id#"></td>
              <td>#encodeForHTML(parameter)#</td>
            </tr>
            </cfoutput>
          </tbody>
        </table>
      </div>
      </form>
    <cfelse>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No AV Signature Whitelist entries found.
      </div>
    </cfif>

  </div>
</div>

<!-- ADD WHITELIST MODAL -->
<div class="modal fade" id="addWhitelistModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="Add AV Whitelist">
        <div class="modal-header">
          <h5 class="modal-title">Add AV Signature Whitelist Entries</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label"><strong>AV Signature(s)</strong></label>
            <textarea class="form-control" name="whitelist" rows="8" placeholder="Enter ClamAV signature names, one per line"></textarea>
            <small class="form-text text-muted">Example: <code>Heuristics.OLE2.ContainsMacros</code></small>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Adding...';this.form.submit();">
            Add Entries
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- DELETE CONFIRMATION MODAL -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="Delete Entry">
        <input type="hidden" name="delete_id" id="deleteIds" value="">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title">Delete Entries</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to delete the selected entries? This action is irreversible!</p>
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

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<script>
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

  // Select All checkbox
  $('#selectAll').click(function() {
    $('input[name="id"]').prop('checked', this.checked);
  });

  // Delete button - collect selected IDs and show modal
  $('#deleteWhitelists').click(function() {
    var selected = [];
    $('input[name="id"]:checked').each(function() {
      selected.push($(this).val());
    });
    if (selected.length === 0) {
      alert('Please select at least one entry to delete.');
      return;
    }
    $('#deleteIds').val(selected.join(','));
    new bootstrap.Modal(document.getElementById('deleteModal')).show();
  });
});
</script>

</body>
</html>
