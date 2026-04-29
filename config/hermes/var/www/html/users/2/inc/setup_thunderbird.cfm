<!---
SETUP DEVICES — THUNDERBIRD DESKTOP (#224 Phase 2b — placeholder)
--->

<cfoutput>
<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fas fa-envelope"></i> Thunderbird &mdash; Windows / Mac / Linux</h3>
      </div>
      <div class="card-body">
        <div class="alert alert-warning mb-3">
          <h6 class="mb-1"><i class="icon fas fa-tools"></i> Full walkthrough coming soon</h6>
          <p class="mb-0">Thunderbird auto-discovers all four protocols (IMAP, SMTP, CalDAV, CardDAV) when you add a mail account. Quick steps below until the polished walkthrough ships.</p>
        </div>

        <h5>Quick setup</h5>
        <ol class="mb-0">
          <li>Open <a href="view_app_passwords.cfm">My App Passwords</a> and create one labeled for the computer (e.g. "Work laptop"). Copy the plaintext shown once.</li>
          <li>In Thunderbird: <em>File &rarr; New &rarr; Existing Mail Account</em>.</li>
          <li>Enter your name, email address, and the app password from step 1.</li>
          <li>Thunderbird auto-discovers the rest. After mail finishes setting up, the "Connect your linked services" page offers Calendar and Address Books &mdash; click Connect on each. Use the <strong>same app password</strong> when prompted.</li>
        </ol>
      </div>
    </div>
  </div>
</div>
</cfoutput>
