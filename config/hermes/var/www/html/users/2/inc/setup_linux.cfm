<!---
SETUP DEVICES — LINUX DESKTOP (#224 Phase 2b — placeholder)
--->

<cfoutput>
<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fab fa-linux"></i> Linux desktop</h3>
      </div>
      <div class="card-body">
        <div class="alert alert-warning mb-3">
          <h6 class="mb-1"><i class="icon fas fa-tools"></i> Per-client walkthroughs coming soon</h6>
          <p class="mb-0">Server settings reference below works for any client (Evolution, KMail, Geary, etc.).</p>
        </div>

        <h5>Server settings reference</h5>
        <p>Create an app password at <a href="view_app_passwords.cfm">My App Passwords</a> first. Use it as the password for all four services.</p>

        <table class="table table-bordered table-sm">
          <thead><tr><th>Service</th><th>Server</th><th>Port</th><th>Encryption</th></tr></thead>
          <tbody>
            <tr><td>IMAP</td><td><code>###cgi.http_host###</code></td><td>993</td><td>SSL/TLS</td></tr>
            <tr><td>SMTP submission</td><td><code>###cgi.http_host###</code></td><td>465</td><td>SSL/TLS</td></tr>
            <tr><td>CalDAV</td><td><code>https://###cgi.http_host###/nc/remote.php/dav/</code></td><td>443</td><td>HTTPS</td></tr>
            <tr><td>CardDAV</td><td><code>https://###cgi.http_host###/nc/remote.php/dav/</code></td><td>443</td><td>HTTPS</td></tr>
          </tbody>
        </table>

        <p class="mb-0"><small>For Thunderbird on Linux, <a href="setup_devices.cfm?device=thunderbird">use the Thunderbird walkthrough</a> instead &mdash; it auto-discovers everything.</small></p>
      </div>
    </div>
  </div>
</div>
</cfoutput>
