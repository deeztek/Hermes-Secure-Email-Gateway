<!---
SETUP DEVICES — OUTLOOK (#224 Phase 2b — placeholder)
--->

<cfoutput>
<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fas fa-envelope-open-text"></i> Microsoft Outlook (Windows)</h3>
      </div>
      <div class="card-body">
        <div class="alert alert-warning mb-3">
          <h6 class="mb-1"><i class="icon fas fa-tools"></i> Full walkthrough coming soon</h6>
          <p class="mb-0">Outlook supports IMAP/SMTP via autodiscover. Calendar and Contacts need the free <strong>CalDAV Synchronizer</strong> add-on.</p>
        </div>

        <h5>Quick setup</h5>
        <ol class="mb-0">
          <li>Create an app password at <a href="view_app_passwords.cfm">My App Passwords</a> labeled for the computer.</li>
          <li>In Outlook, add a new account using your email address. Outlook will auto-discover the IMAP and SMTP servers; enter the app password when prompted.</li>
          <li>Install <a href="https://caldavsynchronizer.org/" target="_blank" rel="noopener">CalDAV Synchronizer</a> for calendar and contacts. Configure the profile with:
            <ul>
              <li><strong>Server URL:</strong> <code>https://###cgi.http_host###/nc/remote.php/dav/</code></li>
              <li><strong>Username:</strong> your full email address</li>
              <li><strong>Password:</strong> the same app password from step 1</li>
            </ul>
            CalDAV Synchronizer will discover the calendars and address books from there.
          </li>
        </ol>
      </div>
    </div>
  </div>
</div>
</cfoutput>
