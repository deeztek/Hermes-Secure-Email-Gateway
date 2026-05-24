<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | System Certificates</title>
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
            <h1 class="m-0">System Certificates</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">System Certificates</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfparam name="m" default="">
<cfparam name="alerttype" default="">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m") AND session.m is not "">
  <cfset m = session.m>
</cfif>
<cfif StructKeyExists(session, "alerttype") AND session.alerttype is not "">
  <cfset alerttype = session.alerttype>
</cfif>
<cfif StructKeyExists(form, "action") AND form.action is not "">
  <cfset action = form.action>
</cfif>

<!--- ACTION HANDLER --->
<cfif action is not "">
  <cfinclude template="./inc/cert_action.cfm">
</cfif>

<!--- Load certificates --->
<cfquery name="getsystemcertificates" datasource="hermes">
  SELECT id, type, friendly_name, domain_name, file_name FROM system_certificates
</cfquery>

<!--- Get assignment lookups (batch instead of N+1) --->
<cfquery name="getWebCert" datasource="hermes">
  SELECT value2 FROM parameters2 WHERE parameter = 'console.certificate' AND module = 'console'
</cfquery>
<cfquery name="getSmtpCert" datasource="hermes">
  SELECT value2 FROM parameters2 WHERE parameter = 'smtp.certificate' AND module = 'certificates'
</cfquery>
<cfquery name="getMailCert" datasource="hermes">
  SELECT value2 FROM parameters2 WHERE parameter = 'mail.certificate' AND module = 'certificates'
</cfquery>
<cfquery name="getMailboxCerts" datasource="hermes">
  SELECT DISTINCT mailbox_certificate FROM mailbox_domains WHERE mailbox_certificate IS NOT NULL
</cfquery>
<cfset mailboxCertList = ValueList(getMailboxCerts.mailbox_certificate)>
<cfquery name="getAllMailboxSans" datasource="hermes">
  SELECT certificate, subdomain, ip, ip_result_msg, ip_result_datetime, dns, dns_result_msg, dns_result_datetime
  FROM mailbox_sans
  ORDER BY subdomain ASC
</cfquery>

<!--- SAN prefix list for the Generate CSR mailbox-cert path (#246).
     Hermes' canonical model is one mailbox cert = one mailbox domain
     (matching the Pro ACME path in inc/mailbox_domain_add_action.cfm).
     Per-domain mandatory SANs are autoconfig + autodiscover (seeded
     system=1) plus any custom prefixes the admin has added in SAN
     Management. JS uses this list to render the live mandatory-SAN
     preview as admin types a mailbox domain in the modal; backend
     cert_action.cfm uses the same source to auto-inject the SANs at
     submission. --->
<cfquery name="getCsrSanPrefixes" datasource="hermes">
  SELECT san FROM additional_sans ORDER BY san
</cfquery>
<cfset csrSanPrefixesList = ValueList(getCsrSanPrefixes.san)>

<!--- Used only for the radio-toggle smart default in the CSR modal.
     If any mailbox-hosting domains exist, default to "Mailbox"; else
     default to "Server". --->
<cfquery name="getMailboxDomainCount" datasource="hermes">
  SELECT COUNT(*) AS c FROM mailbox_domains
</cfquery>

<!--- Read security settings --->
<cfset allowCertDownload = false>
<cfset securityConfPath = "/opt/hermes/config/security.conf">
<cfif fileExists(securityConfPath)>
  <cftry>
    <cffile action="read" file="#securityConfPath#" variable="securityConf">
    <cfif REFindNoCase("ALLOW_CERT_DOWNLOAD\s*=\s*yes", securityConf)>
      <cfset allowCertDownload = true>
    </cfif>
    <cfcatch></cfcatch>
  </cftry>
</cfif>

<!--- ALERTS --->
<cfif alerttype is "error" AND m is not "">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-ban"></i> Error</h4>
    <cfoutput>#m#</cfoutput>
  </div>
<cfelseif alerttype is "success" AND m contains "CSR completed successfully">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    <cfoutput>#m#</cfoutput><br><br>
    <cfoutput>
    <iframe id="csrDownloadFrame" style="display:none;"></iframe>
    <button type="button" class="btn btn-secondary" onclick="downloadCsr('#encodeForJavaScript(session.customtrans)#');">
      <i class="fas fa-download"></i> Download CSR
    </button>
    <script>
    function downloadCsr(ct) {
      document.getElementById('csrDownloadFrame').src = '/admin/2/inc/download_csr.cfm?customtrans=' + ct;
      setTimeout(function() { window.location.href = 'view_system_certificates.cfm'; }, 2000);
    }
    </script>
    </cfoutput>
  </div>
<cfelseif alerttype is "success" AND m is not "">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    <h4><i class="icon fa fa-check"></i> Success</h4>
    <cfoutput>#m#</cfoutput>
  </div>
</cfif>

<cfset session.alerttype = "">
<cfset session.m = "">

<!-- CHOOSING THE RIGHT CERTIFICATE TYPE (#244) -->
<div class="card card-info card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-info-circle"></i> Choosing the Right Certificate Type</h3>
  </div>
  <div class="card-body">
    <p class="mb-3 text-muted">
      Hermes can use two distinct kinds of TLS certificate depending on what
      this gateway is doing. <strong>Pick the right one before ordering or
      generating a CSR &mdash; the cheap kind will not work if you're hosting
      mailboxes.</strong>
    </p>
    <div class="row">

      <div class="col-md-6">
        <div class="card border-primary h-100">
          <div class="card-header bg-primary bg-opacity-10">
            <h5 class="card-title mb-0">
              <i class="fas fa-server text-primary"></i> Server Certificate
              <span class="badge bg-primary ms-1" style="font-size:10px;">Single-name DV</span>
            </h5>
          </div>
          <div class="card-body">
            <p class="text-muted small mb-2"><strong>Cost:</strong> ~$10/year from any CA</p>
            <p class="mb-2"><strong>Use when this Hermes is for:</strong></p>
            <ul class="mb-2">
              <li>Admin console access only</li>
              <li>SMTP host / mail transport only</li>
              <li>Relay-only setups (no mailbox users hosted locally)</li>
            </ul>
            <p class="mb-0">
              Any standard Domain Validation (DV) cert from any CA works.
              Covers the Common Name only. Pick this in the Generate CSR
              dialog if it matches your use case.
            </p>
          </div>
        </div>
      </div>

      <div class="col-md-6">
        <div class="card border-warning h-100">
          <div class="card-header bg-warning bg-opacity-10">
            <h5 class="card-title mb-0">
              <i class="fas fa-inbox text-warning"></i> Mailbox Certificate
              <span class="badge bg-warning text-dark ms-1" style="font-size:10px;">SAN / UCC</span>
            </h5>
          </div>
          <div class="card-body">
            <p class="text-muted small mb-2"><strong>Cost:</strong> typically $50&ndash;$200/year</p>
            <p class="mb-2">
              <strong>One cert per mailbox domain.</strong> If you host mailboxes
              for multiple email domains, generate a separate cert for each.
              Each cert covers:
            </p>
            <ul class="mb-2">
              <li><code>autoconfig.&lt;domain&gt;</code> &mdash; <em>mandatory</em>; this is the cert's <strong>Common Name</strong></li>
              <li><code>autodiscover.&lt;domain&gt;</code> &mdash; <em>mandatory</em></li>
              <li>Any custom subdomain prefixes from <a href="view_mailbox_sans.cfm">SAN Management</a> &mdash; auto-included</li>
            </ul>
            <p class="mb-2 small text-muted">
              No separate Common Name field is needed when generating a mailbox CSR &mdash; the
              first SAN alphabetically (<code>autoconfig.&lt;domain&gt;</code> by default) also serves as the CN.
              This produces a cert byte-for-byte identical to what Pro Edition's Auto mode would issue.
            </p>
            <p class="mb-2">
              When ordering, ask your CA for a <strong>UCC certificate</strong>,
              <strong>multi-domain certificate</strong>, or <strong>SAN
              certificate</strong>. A basic DV cert will <strong>not work</strong>
              &mdash; mail clients will fail TLS during autoconfig.
            </p>

            <!--- Community-edition workflow callout (#245). Pro skips
                 this because Auto mode generates per-domain ACME certs
                 on the fly when adding the mailbox domain. --->
            <div class="alert alert-info small mb-0 mt-3">
              <strong>Community Edition workflow</strong> (Pro automates this):
              <ol class="mb-0 mt-1 ps-3">
                <li>Open <strong>Generate CSR</strong>, pick <em>Mailbox</em>,
                    list your planned mailbox domains</li>
                <li>Submit the CSR to your CA, receive the cert + chain</li>
                <li><strong>Import Certificate</strong> &mdash; upload the cert</li>
                <li><strong>Email Server &rsaquo; Domains &rsaquo; Add</strong>
                    &mdash; select the imported cert</li>
              </ol>
            </div>

          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<!-- CERTIFICATES CARD -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-certificate"></i> System Certificates</h3>
  </div>
  <div class="card-body">

    <div class="mb-3">
      <cfoutput>
      <cfif isDefined("session.license") AND session.license is "VALID">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##requestModal">
          <i class="fas fa-plus-square"></i> Request ACME Certificate
        </button>
      <cfelse>
        <span title="Pro Edition license required" data-bs-toggle="tooltip">
        <button type="button" class="btn btn-primary" disabled>
          <i class="fas fa-plus-square"></i> Request ACME Certificate
        </button>
        </span>
      </cfif>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##importModal">
        <i class="fas fa-upload"></i> Import Certificate
      </button>
      <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="##csrModal">
        <i class="fas fa-sync"></i> Generate CSR
      </button>
      </cfoutput>
    </div>

    <div class="callout callout-info mb-3">
      <h5><i class="fas fa-info-circle"></i> Page Guide</h5>
      <p class="mb-1">This page manages SSL/TLS certificates used by the system. Certificates can be assigned to <strong>Console</strong> (admin, user portal, Ciphermail), <strong>SMTP</strong> (mail transport), <strong>Webmail</strong> (Nextcloud webmail access), and <strong>Mailbox SAN</strong> (mailbox domain SAN certificates for autodiscover, autoconfig, etc.) services.</p>
      <p class="mb-1">Click the <i class="fas fa-chevron-down"></i> arrow on each row to expand certificate details including Subject, Issuer, Serial, Fingerprint, and SAN entries. The expanded view also provides buttons to download the <strong>Certificate</strong>, <strong>Private Key</strong>, and <strong>CA Chain</strong> files. Certificate downloads must be enabled via <code>ALLOW_CERT_DOWNLOAD=yes</code> in <code>/opt/hermes/config/security.conf</code>. Certificates with Mailbox SANs will also display IP and DNS validation status for each subdomain.</p>
      <p class="mb-0">Use the buttons above to <strong>Request</strong> an ACME (Let's Encrypt) certificate, <strong>Import</strong> an existing certificate, or <strong>Generate</strong> a Certificate Signing Request (CSR).</p>
    </div>

    <cfif getsystemcertificates.recordcount GTE 1>
      <div class="table-responsive">
      <table id="certsTable" class="table table-bordered table-hover table-striped" style="width:100%">
        <thead>
          <tr>
            <th style="width: 30px"></th>
            <th style="width: 50px"></th>
            <th>Name</th>
            <th>Type</th>
            <th>Domain</th>
            <th>Console</th>
            <th>SMTP</th>
            <th>Webmail</th>
            <th>Mailbox SAN</th>
            <th>Not Before</th>
            <th>Not After</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="getsystemcertificates">
            <!--- Determine certificate path --->
            <cfif type is "Imported">
              <cfset path = "/opt/hermes/ssl/#file_name#_hermes.pem">
            <cfelseif type is "Acme">
              <cfset path = "/etc/letsencrypt/live/#file_name#/fullchain.pem">
            <cfelse>
              <cfset path = "">
            </cfif>

            <!--- Parse certificate details --->
            <cfif path is not "" AND fileExists(path)>
              <cftry>
                <cfinclude template="./inc/parse_certificate_details.cfm">
                <cfcatch type="any">
                  <cfset subject = "Error">
                  <cfset issuer = "Error">
                  <cfset thestartdate = "Error">
                  <cfset theenddate = "Error">
                  <cfset serial = "Error">
                  <cfset fingerprint = "Error">
                  <cfset san = "Error">
                </cfcatch>
              </cftry>
            <cfelseif path is not "" AND NOT fileExists(path)>
              <!--- Certificate file not yet created (e.g. Acme pending validation) --->
              <cfset subject = "Pending">
              <cfset issuer = "Pending">
              <cfset thestartdate = "Pending">
              <cfset theenddate = "Pending">
              <cfset serial = "Pending">
              <cfset fingerprint = "Pending">
              <cfset san = "Pending">
            <cfelse>
              <cfset subject = "N/A">
              <cfset issuer = "N/A">
              <cfset thestartdate = "N/A">
              <cfset theenddate = "N/A">
              <cfset serial = "N/A">
              <cfset fingerprint = "N/A">
              <cfset san = "N/A">
            </cfif>

            <!--- Build SAN validation sub-table for this certificate --->
            <cfset sanDetailsHtml = "">
            <cfif getAllMailboxSans.recordcount GT 0>
            <cfquery name="certSans" dbtype="query">
              SELECT subdomain, ip, ip_result_msg, ip_result_datetime, dns, dns_result_msg, dns_result_datetime
              FROM getAllMailboxSans
              WHERE certificate = <cfqueryparam value="#getsystemcertificates.id#" cfsqltype="cf_sql_integer">
            </cfquery>
            </cfif>
            <cfif getAllMailboxSans.recordcount GT 0 AND certSans.recordcount GT 0>
              <cfset sanDetailsHtml = "<br><br><strong>Mailbox SAN Validation:</strong><table class='table table-sm table-bordered mt-2 mb-0'><thead><tr><th>Subdomain</th><th>IP</th><th>IP Result</th><th>IP Date</th><th>DNS</th><th>DNS Result</th><th>DNS Date</th></tr></thead><tbody>">
              <cfloop query="certSans">
                <cfset ipBadge = iif(certSans.ip is 'YES', de('bg-success'), de('bg-secondary'))>
                <cfset dnsBadge = iif(certSans.dns is 'YES', de('bg-success'), de('bg-secondary'))>
                <cfset ipDateFormatted = "">
                <cfif certSans.ip_result_datetime is not "">
                  <cftry>
                    <cfset ipDateFormatted = DateTimeFormat(certSans.ip_result_datetime, "mm/dd/yyyy HH:nn:ss")>
                    <cfcatch><cfset ipDateFormatted = certSans.ip_result_datetime></cfcatch>
                  </cftry>
                </cfif>
                <cfset dnsDateFormatted = "">
                <cfif certSans.dns_result_datetime is not "">
                  <cftry>
                    <cfset dnsDateFormatted = DateTimeFormat(certSans.dns_result_datetime, "mm/dd/yyyy HH:nn:ss")>
                    <cfcatch><cfset dnsDateFormatted = certSans.dns_result_datetime></cfcatch>
                  </cftry>
                </cfif>
                <cfset sanDetailsHtml = sanDetailsHtml & "<tr><td>#encodeForHTMLAttribute(certSans.subdomain)#</td><td><span class='badge #ipBadge#'>#encodeForHTMLAttribute(certSans.ip)#</span></td><td>#encodeForHTMLAttribute(certSans.ip_result_msg)#</td><td>#encodeForHTMLAttribute(ipDateFormatted)#</td><td><span class='badge #dnsBadge#'>#encodeForHTMLAttribute(certSans.dns)#</span></td><td>#encodeForHTMLAttribute(certSans.dns_result_msg)#</td><td>#encodeForHTMLAttribute(dnsDateFormatted)#</td></tr>">
              </cfloop>
              <cfset sanDetailsHtml = sanDetailsHtml & "</tbody></table>">
            </cfif>

            <!--- Build download buttons (use iframe to avoid page navigation/spinner) --->
            <cfif allowCertDownload>
              <cfset downloadHtml = "<br><br><strong>Downloads:</strong><br><button type='button' class='btn btn-sm btn-outline-primary me-1 mt-1' onclick=""downloadCert(#id#,'cert')""><i class='fas fa-download'></i> Certificate</button><button type='button' class='btn btn-sm btn-outline-warning me-1 mt-1' onclick=""downloadCert(#id#,'key')""><i class='fas fa-key'></i> Private Key</button><button type='button' class='btn btn-sm btn-outline-secondary mt-1' onclick=""downloadCert(#id#,'chain')""><i class='fas fa-link'></i> CA Chain</button>">
            <cfelse>
              <cfset downloadHtml = "<br><br><strong>Downloads:</strong><br><span title='Enable ALLOW_CERT_DOWNLOAD in /opt/hermes/config/security.conf'><button type='button' class='btn btn-sm btn-outline-primary me-1 mt-1' disabled><i class='fas fa-download'></i> Certificate</button></span><span title='Enable ALLOW_CERT_DOWNLOAD in /opt/hermes/config/security.conf'><button type='button' class='btn btn-sm btn-outline-warning me-1 mt-1' disabled><i class='fas fa-key'></i> Private Key</button></span><span title='Enable ALLOW_CERT_DOWNLOAD in /opt/hermes/config/security.conf'><button type='button' class='btn btn-sm btn-outline-secondary mt-1' disabled><i class='fas fa-link'></i> CA Chain</button></span>">
            </cfif>

            <tr class="cert-row" data-details="<strong>Subject:</strong> #encodeForHTMLAttribute(subject)#<br><strong>Issuer:</strong> #encodeForHTMLAttribute(issuer)#<br><strong>Serial:</strong> #encodeForHTMLAttribute(serial)#<br><strong>Fingerprint:</strong> #encodeForHTMLAttribute(fingerprint)#<br><strong>SAN(s):</strong> #encodeForHTMLAttribute(san)##encodeForHTMLAttribute(downloadHtml)##encodeForHTMLAttribute(sanDetailsHtml)#">
              <td>
                <button type="button" class="btn btn-sm btn-outline-secondary toggle-details" title="Expand">
                  <i class="fas fa-chevron-down"></i>
                </button>
              </td>
              <td>
                <cfif id is not "1">
                  <button type="button" class="btn btn-sm btn-danger" title="Delete"
                    onclick="openDeleteModal('#id#', '#encodeForJavaScript(friendly_name)#');">
                    <i class="fas fa-trash-alt"></i>
                  </button>
                </cfif>
              </td>
              <td>#encodeForHTML(friendly_name)#</td>
              <td><span class="badge <cfif type is 'Acme'>bg-success<cfelse>bg-info</cfif>">#encodeForHTML(type)#</span></td>
              <td>#encodeForHTML(domain_name)#</td>
              <td><cfif getWebCert.value2 is id><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
              <td><cfif getSmtpCert.value2 is id><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
              <td><cfif getMailCert.value2 is id><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
              <td><cfif ListFind(mailboxCertList, id)><span class="badge bg-success">YES</span><cfelse><span class="badge bg-secondary">NO</span></cfif></td>
              <td>#encodeForHTML(thestartdate)#</td>
              <td>#encodeForHTML(theenddate)#</td>
            </tr>
          </cfoutput>
        </tbody>
      </table>
      </div>
    <cfelse>
      <div class="alert alert-info">
        <i class="icon fa fa-info-circle"></i> No system certificates found.
      </div>
    </cfif>

  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

<!-- DELETE CERTIFICATE MODAL -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post">
        <input type="hidden" name="action" value="deletecertificate">
        <input type="hidden" name="certificate_id" id="delete_cert_id" value="">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title">Delete Certificate</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <p>Are you sure you want to delete <strong id="delete_cert_name"></strong>? This action is irreversible!</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          <button type="submit" class="btn btn-danger">Yes, Delete</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- REQUEST ACME CERTIFICATE MODAL -->
<div class="modal fade" id="requestModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="requestacme">
        <div class="modal-header">
          <h5 class="modal-title">Request ACME Certificate</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="callout callout-danger mb-3">
            <p class="mb-0"><i class="icon fas fa-exclamation-triangle"></i> Ensure <strong>TCP 80 and 443</strong> are open from the Internet and the domain points to this server's IP. Test with <strong>Staging</strong> first before using Production.</p>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Certificate Name</strong></label>
            <input type="text" class="form-control" name="certificate_name" placeholder="Friendly name for this certificate">
            <small class="form-text text-muted">Only letters, numbers, dashes, underscores, and periods are allowed.</small>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Domain Name</strong></label>
            <input type="text" class="form-control" name="domainname" placeholder="domain.tld (no www)">
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Notification Email</strong></label>
            <input type="text" class="form-control" name="email" placeholder="admin@domain.tld">
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>ACME Server</strong></label>
            <select class="form-select" name="acmeserver">
              <option value="staging" selected>Staging (Testing)</option>
              <option value="production">Production</option>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='Requesting...';this.form.submit();">Request</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- IMPORT CERTIFICATE MODAL -->
<div class="modal fade" id="importModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="importcertificate">
        <div class="modal-header">
          <h5 class="modal-title">Import Certificate</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label"><strong>Certificate Name</strong></label>
            <input type="text" class="form-control" name="certificate_name" placeholder="Friendly name for this certificate">
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Certificate (PEM)</strong></label>
            <textarea class="form-control" name="certificate" rows="6" placeholder="Paste certificate including -----BEGIN CERTIFICATE----- and -----END CERTIFICATE----- lines"></textarea>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Unencrypted Key (PEM)</strong></label>
            <textarea class="form-control" name="key" rows="6" placeholder="Paste private key including -----BEGIN PRIVATE KEY----- and -----END PRIVATE KEY----- lines"></textarea>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Root &amp; Intermediate CA Certificates (PEM)</strong></label>
            <textarea class="form-control" name="chain" rows="6" placeholder="Paste CA chain including -----BEGIN CERTIFICATE----- and -----END CERTIFICATE----- lines"></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='Importing...';this.form.submit();">Import</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- GENERATE CSR MODAL -->
<div class="modal fade" id="csrModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="generatecsr">
        <input type="hidden" name="algorithm" value="sha512">
        <div class="modal-header">
          <h5 class="modal-title">Generate CSR</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">

          <!--- Cert-purpose radio toggle (#244). Smart default: Mailbox if
               mailbox_domains has rows, Server otherwise. The radio is
               informational + drives the show/hide for the cost warning,
               mailbox-domain input, and mandatory-SAN preview. Sanitization
               in cert_action.cfm enforces autoconfig/autodiscover + custom
               prefixes for mailbox certs regardless. --->
          <cfoutput>
          <div class="mb-3 p-3 border rounded bg-body-secondary">
            <label class="form-label mb-2"><strong>Certificate purpose</strong> &mdash; pick the use case for this cert</label>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="cert_purpose" id="purposeServer" value="server" <cfif getMailboxDomainCount.c EQ 0>checked</cfif>>
              <label class="form-check-label" for="purposeServer">
                <strong>Server certificate</strong> &mdash; admin console / SMTP / relay-only
                <span class="text-muted">(single-name DV, ~$10/yr)</span>
              </label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="cert_purpose" id="purposeMailbox" value="mailbox" <cfif getMailboxDomainCount.c GT 0>checked</cfif>>
              <label class="form-check-label" for="purposeMailbox">
                <strong>Mailbox certificate</strong> &mdash; covers mailbox autoconfig / autodiscover
                <span class="text-muted">(SAN / UCC, $50&ndash;$200/yr)</span>
              </label>
            </div>
          </div>
          </cfoutput>

          <!--- Cost warning shown only when purpose=mailbox. JS toggles
               visibility based on the radio above. --->
          <div id="csrMailboxWarning" class="alert alert-warning mb-3" role="alert">
            <h5 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> Buy a multi-name (SAN / UCC) certificate</h5>
            <p class="mb-2">
              For mailbox use, Hermes requires a certificate that covers <strong>multiple
              hostnames</strong>: <code>autoconfig.&lt;domain&gt;</code> and
              <code>autodiscover.&lt;domain&gt;</code> at minimum (mailbox clients ping these
              during account setup), plus any custom prefixes you've added in SAN Management.
              A single-name (DV) cert will <strong>not</strong> work &mdash; mail clients will
              fail TLS during autoconfig.
            </p>
            <p class="mb-0">
              When ordering from your CA, look for <strong>"UCC certificate"</strong>,
              <strong>"multi-domain"</strong>, or <strong>"SAN certificate"</strong>.
              These typically cost more than a basic DV cert ($50&ndash;$200/yr vs ~$10/yr),
              but a basic DV cert is not an option for mailbox users.
            </p>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Country Code</strong> (2 letters, e.g. US)</label>
            <input type="text" class="form-control" name="country" placeholder="US" maxlength="2">
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>State/Province</strong></label>
            <input type="text" class="form-control" name="state" placeholder="Texas">
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Locality</strong></label>
            <input type="text" class="form-control" name="locality" placeholder="Houston">
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Organization</strong></label>
            <input type="text" class="form-control" name="organization" placeholder="Widgets, Inc">
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Department</strong></label>
            <input type="text" class="form-control" name="department" placeholder="IT Department">
          </div>
          <!--- Common Name input (#247). Shown only for server certs.
               For mailbox certs, the CN is auto-derived server-side as
               the first alphabetical SAN (matching Pro ACME's
               first-`-d`-flag behavior in inc/acme_request_san_certificate.cfm)
               so the resulting cert is byte-for-byte identical to what
               Pro Auto mode would produce. --->
          <div id="csrCommonNameBlock" class="mb-3">
            <label class="form-label"><strong>Common Name</strong> (hostname this cert identifies, e.g. <code>mail.widgets.tld</code>)</label>
            <input type="text" class="form-control" name="commonname" placeholder="mail.widgets.tld">
          </div>

          <!--- Singular mailbox-domain input (#246). Shown only when
               cert_purpose=mailbox. Hermes-canonical model is one cert
               per mailbox domain (matches Pro ACME pattern in
               inc/mailbox_domain_add_action.cfm). JS updates the
               mandatory-SAN preview below as admin types. --->
          <div id="csrMailboxDomainBlock" class="mb-3">
            <label class="form-label" for="mailboxDomainInput">
              <strong>Mailbox domain</strong>
              <span class="text-muted small">(the email domain you're hosting mailboxes for)</span>
            </label>
            <input type="text" class="form-control font-monospace"
                   id="mailboxDomainInput" name="mailbox_domain"
                   placeholder="widgets.tld">
            <div class="form-text">
              One mailbox cert covers one mailbox domain. If you host mailboxes
              for multiple email domains, generate a separate cert for each.
              (Pro Edition's Auto mode handles this automatically when you add
              a domain in <a href="view_mailbox_domains.cfm">Email Server &rsaquo; Domains</a>.)
            </div>
          </div>

          <!--- Read-only mandatory-SAN preview (#246). JS rebuilds this
               list whenever the mailbox-domain input changes. The SANs
               here are non-negotiable for mailbox certs and are injected
               by cert_action.cfm regardless of what the admin types in
               the Additional SANs textarea below. --->
          <div id="csrMandatorySansBlock" class="mb-3">
            <label class="form-label"><strong>SANs that will be included</strong> <span class="text-muted small">(read-only)</span></label>
            <div id="csrMandatorySansPreview" class="border rounded p-2 bg-body-tertiary font-monospace small" style="min-height:5rem;">
              <span class="text-muted">Type a mailbox domain above to see the SANs that will be on the cert.</span>
            </div>
            <div class="form-text">
              <code>autoconfig.&lt;domain&gt;</code> and <code>autodiscover.&lt;domain&gt;</code>
              are <strong>mandatory</strong> for any mailbox cert and are always included
              &mdash; you don't need to (and can't) opt out. Any custom prefixes you've
              added in <a href="view_mailbox_sans.cfm">SAN Management</a> are also expanded
              automatically against the mailbox domain.
              <br><br>
              The <strong>first SAN alphabetically</strong> also serves as the certificate's
              <strong>Common Name</strong> (no separate CN field is required) &mdash; this
              produces a cert that's byte-for-byte identical to what Pro Edition's Auto
              mode would issue for the same domain.
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label"><strong>Additional SANs</strong> <span class="text-muted small">(optional, one entry per line)</span></label>
            <textarea class="form-control font-monospace" name="sans" rows="4" placeholder="imap&#10;smtp&#10;vanity.othercompany.com"></textarea>

            <!--- Help text variants. JS toggles which one is visible
                 based on the cert_purpose radio. --->
            <div id="csrSanHelpMailbox" class="form-text">
              Two kinds of entry are accepted, mixed freely:
              <ul class="mb-1 ps-3">
                <li><strong>Bare prefix</strong> (e.g. <code>imap</code>, <code>smtp</code>,
                    <code>pop</code>) &mdash; automatically expanded against the mailbox
                    domain above (becomes <code>imap.&lt;mailbox-domain&gt;</code>, etc.)</li>
                <li><strong>Full DNS name</strong> (e.g. <code>vanity.othercompany.com</code>)
                    &mdash; used as-is, for cross-domain vanity hostnames</li>
              </ul>
              The preview above updates live so you can see exactly what will end up on
              the cert. Leave blank in most cases &mdash; the mandatory SANs already cover
              what mailbox clients need.
              <br>
              To add a prefix that applies to <strong>every</strong> mailbox domain
              (not just this one), add it to <a href="view_mailbox_sans.cfm">SAN Management</a>
              instead &mdash; it'll be auto-included in every mailbox CSR going forward.
              Duplicates of the mandatory SANs are dropped silently.
            </div>

            <div id="csrSanHelpServer" class="form-text" style="display:none;">
              Enter <strong>full DNS names</strong> (e.g. <code>admin.widgets.tld</code>),
              not bare prefixes. Optional &mdash; a standard single-name DV cert is
              sufficient for server-only use. Only add SANs here if you need the cert to
              cover additional subdomains (e.g. a separate hostname for the admin console).
              The Common Name is added automatically.
            </div>
          </div>
          <div class="mb-3">
            <label class="form-label"><strong>Encryption Length</strong></label>
            <select class="form-select" name="encryption">
              <option value="2048">2048 Bit (Medium)</option>
              <option value="4096" selected>4096 Bit (High)</option>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary"
            onclick="this.disabled=true;this.innerHTML='Generating...';this.form.submit();">Generate</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
$(document).ready(function() {
  var table = $('#certsTable').DataTable({
    dom: 'Blfrtip',
    buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
    stateSave: true,
    lengthMenu: [[10, 25, 50, -1], ['10 rows', '25 rows', '50 rows', 'Show all']],
    order: [[2, 'asc']],
    columnDefs: [
      { orderable: false, targets: [0, 1] },
      { searchable: false, targets: [0, 1] }
    ]
  });

  // Expandable row details
  $('#certsTable tbody').on('click', '.toggle-details', function() {
    var tr = $(this).closest('tr');
    var row = table.row(tr);
    var icon = $(this).find('i');

    if (row.child.isShown()) {
      row.child.hide();
      tr.removeClass('shown');
      icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
    } else {
      var details = tr.data('details');
      row.child('<div class="p-3 bg-light">' + details + '</div>').show();
      tr.addClass('shown');
      icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
    }
  });

  // CSR modal (#244 + #246) -- cert purpose radio toggle + mandatory-SAN
  // preview for mailbox certs.
  //
  // Server: hide cost warning + mailbox-domain input + mandatory-SAN preview
  //         + mailbox help. Show server help. Additional-SANs textarea stays
  //         visible for optional custom SANs.
  // Mailbox: show cost warning + mailbox-domain input + mandatory-SAN preview
  //          + mailbox help. Hide server help. As admin types the mailbox
  //          domain, the preview updates live from the system SAN prefixes
  //          (autoconfig, autodiscover, plus custom from additional_sans).
  //          The same expansion is enforced server-side by cert_action.cfm.
  <cfoutput>
  var csrSanPrefixes = "#csrSanPrefixesList#".split(',').filter(function(p) { return p.length > 0; });
  </cfoutput>

  function applyCsrPurpose() {
    var purpose = $('#csrModal input[name="cert_purpose"]:checked').val();
    if (purpose === 'mailbox') {
      $('#csrMailboxWarning').show();
      $('#csrCommonNameBlock').hide();
      $('#csrMailboxDomainBlock').show();
      $('#csrMandatorySansBlock').show();
      $('#csrSanHelpMailbox').show();
      $('#csrSanHelpServer').hide();
      updateMandatorySansPreview();
    } else {
      $('#csrMailboxWarning').hide();
      $('#csrCommonNameBlock').show();
      $('#csrMailboxDomainBlock').hide();
      $('#csrMandatorySansBlock').hide();
      $('#csrSanHelpMailbox').hide();
      $('#csrSanHelpServer').show();
    }
  }

  function updateMandatorySansPreview() {
    var domain = ($('#mailboxDomainInput').val() || '').trim().toLowerCase();
    var $preview = $('#csrMandatorySansPreview');
    if (domain.length === 0) {
      $preview.html('<span class="text-muted">Type a mailbox domain above to see the SANs that will be on the cert.</span>');
      return;
    }
    if (!/^[a-z0-9.\-]+$/.test(domain)) {
      $preview.html('<span class="text-danger">Invalid domain &mdash; only letters, numbers, dots, and hyphens are allowed.</span>');
      return;
    }
    if (csrSanPrefixes.length === 0) {
      $preview.html('<span class="text-warning">No SAN prefixes configured in SAN Management.</span>');
      return;
    }

    // Mandatory entries first. csrSanPrefixes is ORDER BY san from the
    // DB query, so index 0 is the alphabetically first prefix -- that
    // row also serves as the certificate's Common Name (matches Pro
    // ACME's first-`-d`-flag behavior).
    var entries = csrSanPrefixes.map(function(p) {
      return { fqdn: p + '.' + domain, kind: 'mandatory', source: null };
    });

    // Additional entries from the textarea, with smart expansion:
    // - bare prefix (no dot) -> append .<mailbox-domain>
    // - full FQDN (has dot)  -> used as-is
    // Skip empties, invalid chars, and dedupe against existing entries.
    var rawAdd = $('#csrModal textarea[name="sans"]').val() || '';
    rawAdd.split('\n').forEach(function(line) {
      var clean = line.replace(/\r/g, '').trim().toLowerCase();
      if (clean.length === 0) return;
      if (!/^[a-z0-9.\-\*]+$/.test(clean)) return;
      var fqdn = (clean.indexOf('.') === -1) ? clean + '.' + domain : clean;
      // dedupe (case-insensitive)
      var dup = entries.some(function(e) { return e.fqdn === fqdn; });
      if (dup) return;
      entries.push({
        fqdn: fqdn,
        kind: 'additional',
        source: (clean !== fqdn) ? clean : null
      });
    });

    var html = '';
    entries.forEach(function(e, idx) {
      var chips = '';
      if (idx === 0) {
        chips += ' <span class="badge bg-secondary ms-2" style="font-size:9px;">CN</span>';
      }
      if (e.kind === 'additional') {
        chips += ' <span class="badge bg-info text-dark ms-1" style="font-size:9px;">added</span>';
        if (e.source) {
          chips += ' <span class="text-muted small">(from &ldquo;' + e.source + '&rdquo;)</span>';
        }
      }
      html += '<div>' + e.fqdn + chips + '</div>';
    });
    $preview.html(html);
  }

  $('#csrModal input[name="cert_purpose"]').on('change', applyCsrPurpose);
  $('#mailboxDomainInput').on('input', updateMandatorySansPreview);
  $('#csrModal textarea[name="sans"]').on('input', updateMandatorySansPreview);
  applyCsrPurpose();
});

function openDeleteModal(id, name) {
  document.getElementById('delete_cert_id').value = id;
  document.getElementById('delete_cert_name').textContent = name;
  new bootstrap.Modal(document.getElementById('deleteModal')).show();
}

function downloadCert(id, filetype) {
  document.getElementById('certDownloadFrame').src = 'inc/download_certificate.cfm?id=' + id + '&filetype=' + filetype;
}
</script>
<iframe id="certDownloadFrame" style="display:none;"></iframe>

</body>
</html>
