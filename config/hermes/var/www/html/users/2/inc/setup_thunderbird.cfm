<!---
SETUP DEVICES — THUNDERBIRD DESKTOP (#224 Phase 2b)

Thunderbird auto-discovers all four protocols (IMAP, SMTP, CalDAV,
CardDAV) when the user adds a mail account. The Hermes autoconfig
endpoint at /autodiscover/autoconfig.cfm advertises both the mail
servers (Mozilla autoconfig XML) and the Nextcloud DAV base URL, so
Thunderbird's "Connect your linked services" step on first login
finds Calendar and Address Books without any manual URL entry.

Same canonical mailHost lookup as the other manual fragments — pulled
from parameters2.console.host so an alternate-hostname portal access
still shows the right server.
--->

<cfquery name="getTbMailHost" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'console' AND parameter = 'console.host'
</cfquery>
<cfset mailHost = (getTbMailHost.recordcount GTE 1 AND Trim(getTbMailHost.value2) NEQ "") ? Trim(getTbMailHost.value2) : cgi.http_host>

<cfoutput>
<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fas fa-envelope"></i> Thunderbird &mdash; Windows / Mac / Linux</h3>
      </div>
      <div class="card-body">
        <p>Thunderbird is the cleanest desktop path: it auto-discovers <strong>all four protocols</strong> (IMAP, SMTP, CalDAV, CardDAV) when you add a mail account. You won't type a single server name &mdash; just your email address and an app password.</p>

        <ul class="mb-3">
          <li><strong>Mail (IMAP + SMTP):</strong> Mozilla autoconfig (built in)</li>
          <li><strong>Calendar + Contacts (CalDAV + CardDAV):</strong> "Connect your linked services" prompt after mail setup</li>
          <li><strong>One credential:</strong> the same app password works for all four protocols</li>
        </ul>

        <h5>Step 1 &mdash; Mint an app password for this computer</h5>
        <ol>
          <li>Open <a href="view_app_passwords.cfm">My App Passwords</a> and create one labeled for this computer (e.g. <em>Work laptop</em>).</li>
          <li><strong>Copy the plaintext shown once</strong> &mdash; you'll paste it into Thunderbird below.</li>
        </ol>

        <h5>Step 2 &mdash; Add your account to Thunderbird</h5>
        <ol>
          <li>Open Thunderbird and choose <em>File &rarr; New &rarr; Existing Mail Account</em> (or use the first-run setup if this is a fresh install).</li>
          <li>Fill in:
            <ul>
              <li><strong>Your name:</strong> however you want messages to be signed</li>
              <li><strong>Email address:</strong> your full email address</li>
              <li><strong>Password:</strong> the app password from Step 1</li>
            </ul>
          </li>
          <li>Click <em>Continue</em>. Thunderbird will discover IMAP and SMTP automatically and pre-fill the rest.</li>
          <li>Click <em>Done</em>. Mail is set up.</li>
        </ol>

        <h5>Step 3 &mdash; Connect Calendar and Contacts</h5>
        <ol>
          <li>After Thunderbird finishes mail setup, a <strong>"Connect your linked services"</strong> page appears.</li>
          <li>You'll see a list of available services &mdash; <em>Calendar</em>, <em>Address Book</em>. Click <em>Connect</em> on each.</li>
          <li>If prompted for a password again, paste the <strong>same</strong> app password from Step 1.</li>
        </ol>

        <div class="alert alert-info mb-3">
          <h6 class="mb-1"><i class="icon fas fa-info-circle"></i> If "Connect your linked services" doesn't appear</h6>
          <p class="mb-0">Some Thunderbird versions skip this page when adding a second account on a profile that already has one. You can always add Calendar / Address Books manually:
          </p>
          <ul class="mb-0 mt-2">
            <li><strong>Calendar:</strong> Calendar tab &rarr; <em>New Calendar &rarr; On the Network</em> &rarr; pick <em>CalDAV</em> &rarr; Location: <code>https://#mailHost#/nc/remote.php/dav/</code> &rarr; Username: your full email address &rarr; password: app password.</li>
            <li><strong>Address Book:</strong> Address Book tab &rarr; <em>New Address Book &rarr; CardDAV Address Book</em> &rarr; same URL, same credentials.</li>
          </ul>
        </div>

        <p class="mb-0"><small>One revoke from <a href="view_app_passwords.cfm">My App Passwords</a> cuts mail, calendar, and contacts simultaneously on this computer.</small></p>
      </div>
    </div>
  </div>
</div>
</cfoutput>
