<!---
SETUP DEVICES — MICROSOFT OUTLOOK (MAC) (#224 Phase 2b)

Outlook for Mac is split out from Outlook for Windows because:
  1. Outlook for Mac has NO native CalDAV / CardDAV support
     (Microsoft never implemented those protocols in the Mac client)
  2. CalDAV Synchronizer is Windows-only (a COM add-in; Mac is a
     different add-in architecture and there is no Mac build)
  3. Outlook for Mac autodiscover handles IMAP / SMTP cleanly enough
     that it's worth a card, but Calendar / Contacts have to live
     in macOS Calendar.app / Contacts.app pointed at Nextcloud DAV.

Note for the trailing-dot SMTP cosmetic on macOS Outlook autodiscover:
that is a known macOS Outlook quirk reading the MX record verbatim.
The connection still works. The real failure mode admins should
suspect FIRST on macOS connection problems is TLS 1.3 negotiation
against Dovecot — flip the Dovecot TLS preset to "Intermediate
(TLS 1.2+)" if Outlook for Mac fails to connect.
--->

<cfquery name="getOutlookMacMailHost" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'console' AND parameter = 'console.host'
</cfquery>
<cfset mailHost = (getOutlookMacMailHost.recordcount GTE 1 AND Trim(getOutlookMacMailHost.value2) NEQ "") ? Trim(getOutlookMacMailHost.value2) : cgi.http_host>

<cfoutput>
<cfset davBaseUrl = "https://#mailHost#/nc/remote.php/dav/">

<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fab fa-apple"></i> Microsoft Outlook (Mac)</h3>
      </div>
      <div class="card-body">
        <div class="alert alert-info mb-3">
          <h6 class="mb-1"><i class="icon fas fa-info-circle"></i> Outlook for Mac supports email only</h6>
          <p class="mb-0">Microsoft has never implemented CalDAV/CardDAV in Outlook for Mac, and the Windows-only CalDAV Synchronizer add-in does not run on macOS. This page covers email via Outlook for Mac plus calendar and contacts via the built-in macOS apps. If you only use Apple's mail/calendar/contacts apps, the <a href="setup_devices.cfm?device=apple">iPhone, iPad, or Mac (Apple apps)</a> path is faster &mdash; one downloadable profile sets up all three.</p>
        </div>

        <h5>Step 1 &mdash; Mint an app password for this Mac</h5>
        <ol>
          <li>Open <a href="view_app_passwords.cfm">My App Passwords</a> and create one labeled for this computer (e.g. <em>MacBook</em>).</li>
          <li><strong>Copy the plaintext shown once</strong> &mdash; you'll use it three times below (Outlook, Calendar, Contacts).</li>
        </ol>

        <h5>Step 2 &mdash; Email in Outlook for Mac</h5>
        <ol>
          <li>In Outlook: <em>Outlook &rarr; Settings &rarr; Accounts &rarr; +</em> &rarr; <em>Add Account</em>.</li>
          <li>Enter your full email address. Outlook will discover the IMAP and SMTP servers automatically.</li>
          <li>When prompted for a password, paste the app password from Step 1.</li>
        </ol>

        <div class="alert alert-warning mb-3">
          <h6 class="mb-1"><i class="icon fas fa-exclamation-triangle"></i> Cosmetic: trailing dot in SMTP server name</h6>
          <p class="mb-0">Outlook for Mac may show the SMTP server name with a trailing dot (e.g. <code>mail.example.com.</code>). This is Outlook for Mac reading the DNS MX record verbatim &mdash; it's cosmetic; the connection still works.</p>
        </div>

        <div class="alert alert-warning mb-3">
          <h6 class="mb-1"><i class="icon fas fa-exclamation-triangle"></i> If Outlook for Mac can't connect at all (TLS)</h6>
          <p class="mb-0">macOS clients are known to have TLS 1.3 negotiation issues with some Dovecot configurations. If Outlook for Mac fails to connect even with the right credentials, ask your admin to set Dovecot's TLS profile to <strong>Intermediate (TLS 1.2+)</strong>.</p>
        </div>

        <h5>Step 3 &mdash; Calendar in macOS Calendar.app</h5>
        <ol>
          <li>Open <em>Calendar &rarr; Settings &rarr; Accounts &rarr; +</em>.</li>
          <li>Choose <strong>Other CalDAV Account</strong>.</li>
          <li>Account Type: <strong>Manual</strong>. Fill in:
            <ul>
              <li><strong>User Name:</strong> your full email address</li>
              <li><strong>Password:</strong> the app password from Step 1</li>
              <li><strong>Server Address:</strong> <code>#davBaseUrl#</code></li>
            </ul>
          </li>
          <li>Click <em>Sign In</em>. Calendar.app will discover your calendars.</li>
        </ol>

        <h5>Step 4 &mdash; Contacts in macOS Contacts.app</h5>
        <ol>
          <li>Open <em>Contacts &rarr; Settings &rarr; Accounts &rarr; +</em>.</li>
          <li>Choose <strong>Other Contacts Account</strong>.</li>
          <li>Account Type: <strong>CardDAV</strong>. Fill in:
            <ul>
              <li><strong>User Name:</strong> your full email address</li>
              <li><strong>Password:</strong> the app password from Step 1</li>
              <li><strong>Server Address:</strong> <code>#davBaseUrl#</code></li>
            </ul>
          </li>
          <li>Click <em>Sign In</em>. Contacts.app will discover your address books.</li>
        </ol>

        <div class="alert alert-info mb-0">
          <h6 class="mb-1"><i class="icon fas fa-info-circle"></i> Same app password, three apps</h6>
          <p class="mb-0">All three macOS apps use the same app password from Step 1. Revoking it from <a href="view_app_passwords.cfm">My App Passwords</a> cuts mail, calendar, and contacts simultaneously on this Mac.</p>
        </div>
      </div>
    </div>
  </div>
</div>
</cfoutput>
