<!---
SETUP DEVICES — ANDROID DAVx5 BRANCH (#224 Phase 2b — placeholder)

Manual-instructions template for Android using DAVx5 (CalDAV/CardDAV)
plus an email app of choice. Full content lands in Phase 2b once the
manual-instructions UI pattern is fleshed out from the Apple branch.

For now: point the user at My App Passwords and the credential-model
basics so they can set up Android manually with the right values.
--->

<cfoutput>
<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fab fa-android"></i> Android &mdash; DAVx5 + email app</h3>
      </div>
      <div class="card-body">
        <div class="alert alert-warning mb-3">
          <h6 class="mb-1"><i class="icon fas fa-tools"></i> Step-by-step instructions coming soon</h6>
          <p class="mb-0">The full DAVx5 / Android email walkthrough is being polished. In the meantime, the manual setup below will get you running.</p>
        </div>

        <h5>Manual setup &mdash; one app password covers everything</h5>
        <ol class="mb-3">
          <li>Open <a href="view_app_passwords.cfm">My App Passwords</a> and create one. Label it for the device (e.g. "Android" or "Pixel 8"). <strong>Copy the plaintext shown once</strong> &mdash; you'll need it below.</li>
          <li>Install <a href="https://www.davx5.com/" target="_blank" rel="noopener">DAVx5</a> from F-Droid or Google Play.</li>
          <li>In DAVx5, add a new account &rarr; <em>Login with URL and username</em>. Enter:
            <ul>
              <li><strong>Base URL:</strong> <code>https://###cgi.http_host###/nc/remote.php/dav/</code></li>
              <li><strong>Username:</strong> your full email address</li>
              <li><strong>Password:</strong> the app password you just created</li>
            </ul>
          </li>
          <li>For email, install an Android email app (K-9 Mail, FairEmail, or Thunderbird for Android). Configure with the server settings from the autoconfig endpoint at <code>https://autoconfig.&lt;your-domain&gt;/mail/config-v1.1.xml?emailaddress=YOU@DOMAIN</code> (most apps will auto-discover when you enter your email).</li>
          <li>For email password: use the <strong>same app password</strong> from step 1. One credential, all four protocols.</li>
        </ol>

        <p class="mb-0"><small><strong>Note on Nextcloud SSO:</strong> If your phone also has the Nextcloud Files app installed, DAVx5 has a "Login from Nextcloud Files app" option. That will work, but it creates a separate DAV-only credential outside My App Passwords. The manual setup above keeps everything visible in one place.</small></p>
      </div>
    </div>
  </div>
</div>
</cfoutput>
