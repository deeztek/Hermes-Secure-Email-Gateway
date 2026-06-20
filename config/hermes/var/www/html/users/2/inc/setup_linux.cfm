<!---
SETUP DEVICES — LINUX DESKTOP (#224 Phase 2b)

Reference card showing the canonical IMAP/SMTP/CalDAV/CardDAV settings
for any Linux mail/PIM client (Evolution, KMail, Geary, Claws, etc.).

Mail server hostname is pulled from parameters2.console.host (same
source as autoconfig.cfm, autodiscover.cfm, and setup_apple_action.cfm)
so the displayed values stay correct even if the user accessed the
portal on an alternate hostname.
--->

<cfquery name="getLinuxMailHost" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'console' AND parameter = 'console.host'
</cfquery>
<cfset mailHost = (getLinuxMailHost.recordcount GTE 1 AND Trim(getLinuxMailHost.value2) NEQ "") ? Trim(getLinuxMailHost.value2) : cgi.http_host>

<cfoutput>
<cfset davBaseUrl = "https://#mailHost#/nc/remote.php/dav/">

<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fab fa-linux"></i> Linux desktop</h3>
      </div>
      <div class="card-body">
        <div class="alert alert-info mb-3">
          <h6 class="mb-1"><i class="icon fas fa-info-circle"></i> One reference, any client</h6>
          <p class="mb-0">Linux mail/PIM clients vary too much for a single walkthrough, so the reference below works for any of them &mdash; Evolution, KMail, Geary, Claws, etc. Username and password are the same across all four protocols. For Thunderbird on Linux, <a href="setup_devices.cfm?device=thunderbird">use the Thunderbird walkthrough</a> &mdash; it auto-discovers everything.</p>
        </div>

        <h5>Step 1 &mdash; Mint an app password for this computer</h5>
        <ol>
          <li>Open <a href="view_app_passwords.cfm">My App Passwords</a> and create one labeled for this computer (e.g. <em>Linux desktop</em>).</li>
          <li><strong>Copy the plaintext shown once</strong> &mdash; you'll use it for all four protocols below.</li>
        </ol>

        <h5>Step 2 &mdash; Server settings reference</h5>
        <p>Username for all four services is your full email address. Password is the same app password from Step 1.</p>

        <table class="table table-bordered table-sm">
          <thead><tr><th>Service</th><th>Server</th><th>Port</th><th>Encryption</th></tr></thead>
          <tbody>
            <tr><td>IMAP</td><td><code>#mailHost#</code></td><td>993</td><td>SSL/TLS (implicit)</td></tr>
            <tr><td>SMTP (SMTPS)</td><td><code>#mailHost#</code></td><td>465</td><td>SSL/TLS (implicit)</td></tr>
            <tr><td>SMTP (Submission)</td><td><code>#mailHost#</code></td><td>587</td><td>STARTTLS</td></tr>
            <tr><td>CalDAV</td><td><code>#davBaseUrl#</code></td><td>443</td><td>HTTPS</td></tr>
            <tr><td>CardDAV</td><td><code>#davBaseUrl#</code></td><td>443</td><td>HTTPS</td></tr>
          </tbody>
        </table>

        <p class="mb-1"><small><strong>Outgoing mail:</strong> use either port 465 (SMTPS, implicit TLS &mdash; modern preference per RFC 8314) or port 587 (Submission with STARTTLS). Both work; pick whichever your client offers most cleanly.</small></p>
        <p class="mb-0"><small><strong>Calendar &amp; Contacts:</strong> most Linux clients accept the DAV "discovery" URL above and will list your calendars and address books automatically. If a client asks for individual collection URLs, append <code>calendars/&lt;your-email&gt;/</code> or <code>addressbooks/users/&lt;your-email&gt;/</code> after the base.</small></p>
      </div>
    </div>
  </div>
</div>
</cfoutput>
