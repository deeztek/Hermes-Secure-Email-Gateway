<!---
SETUP DEVICES — ANDROID (#224 Phase 2b)

Android path: DAVx5 for Calendar + Contacts (CalDAV/CardDAV), plus a
mail app for IMAP/SMTP. K-9 Mail and Thunderbird for Android are the
same client (Thunderbird for Android is K-9's official rebrand). Both
autodiscover IMAP/SMTP cleanly from the Hermes autoconfig endpoint —
verified working — so users only enter email + app password.

One app password covers all four protocols. Same plaintext goes into
the mail app and into DAVx5.
--->

<cfquery name="getAndroidMailHost" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'console' AND parameter = 'console.host'
</cfquery>
<cfset mailHost = (getAndroidMailHost.recordcount GTE 1 AND Trim(getAndroidMailHost.value2) NEQ "") ? Trim(getAndroidMailHost.value2) : cgi.http_host>

<cfoutput>
<cfset davBaseUrl = "https://#mailHost#/nc/remote.php/dav/">

<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fab fa-android"></i> Android &mdash; DAVx5 + email app</h3>
      </div>
      <div class="card-body">
        <p>On Android you'll use two apps: <strong>DAVx5</strong> for Calendar and Contacts, plus <strong>K-9 Mail</strong> (also published as <strong>Thunderbird for Android</strong> &mdash; same app, just rebranded) for email. The mail app autodiscovers all the server settings, so you only type your email address and app password.</p>

        <ul class="mb-3">
          <li><strong>Mail (IMAP + SMTP):</strong> K-9 Mail / Thunderbird for Android (autoconfig)</li>
          <li><strong>Calendar + Contacts (CalDAV + CardDAV):</strong> DAVx5</li>
          <li><strong>One credential:</strong> the same app password works for all four protocols</li>
        </ul>

        <h5>Step 1 &mdash; Mint an app password for this device</h5>
        <ol>
          <li>Open <a href="view_app_passwords.cfm">My App Passwords</a> and create one labeled for the phone or tablet (e.g. <em>Pixel 8</em>).</li>
          <li><strong>Copy the plaintext shown once</strong> &mdash; you'll paste it into both DAVx5 and the mail app below.</li>
        </ol>

        <h5>Step 2 &mdash; Install your apps</h5>
        <ol>
          <li>Install <a href="https://www.davx5.com/" target="_blank" rel="noopener">DAVx5</a> from F-Droid or Google Play.</li>
          <li>Install <a href="https://k9mail.app/" target="_blank" rel="noopener">K-9 Mail</a> <em>or</em> <a href="https://www.thunderbird.net/en-US/mobile/" target="_blank" rel="noopener">Thunderbird for Android</a> (same app, rebranded &mdash; pick whichever name you prefer).</li>
        </ol>

        <h5>Step 3 &mdash; Set up email (K-9 / Thunderbird for Android)</h5>
        <ol>
          <li>Open the mail app and choose <em>Add account</em> (or <em>New account</em>).</li>
          <li>Enter your full email address and the app password from Step 1.</li>
          <li>The app discovers IMAP and SMTP automatically. Tap <em>Done</em>.</li>
        </ol>

        <h5>Step 4 &mdash; Set up Calendar and Contacts (DAVx5)</h5>
        <ol>
          <li>Open DAVx5 and tap the <em>+</em> button &rarr; <strong>Login with URL and username</strong>.</li>
          <li>Fill in:
            <ul>
              <li><strong>Base URL:</strong> <code>#davBaseUrl#</code></li>
              <li><strong>Username:</strong> your full email address</li>
              <li><strong>Password:</strong> the same app password from Step 1</li>
            </ul>
          </li>
          <li>Tap <em>Login</em>. DAVx5 will discover your calendars and address books.</li>
          <li>On the next screen, enable Calendar and Contacts sync. Grant DAVx5 the system permissions when prompted &mdash; that's how the calendar and contacts you sync show up in Android's built-in Calendar and Contacts apps.</li>
        </ol>

        <div class="alert alert-info mb-0">
          <h6 class="mb-1"><i class="icon fas fa-info-circle"></i> Note on DAVx5 + Nextcloud Files app</h6>
          <p class="mb-0">If you also have the Nextcloud Files Android app installed, DAVx5 offers a <em>Login from Nextcloud Files app</em> shortcut. That works, but it creates a separate device-token credential outside <a href="view_app_passwords.cfm">My App Passwords</a>. The manual setup above keeps everything visible and revocable in one place.</p>
        </div>
      </div>
    </div>
  </div>
</div>
</cfoutput>
