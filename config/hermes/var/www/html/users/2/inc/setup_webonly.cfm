<!---
SETUP DEVICES — WEB ONLY (#224 Phase 2)

For users who don't want to set up any clients — just use the webmail
interface. No app password needed; web logins use their main login
password (LDAP / AD/LDAP via OIDC SSO).
--->

<cfoutput>
<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fas fa-globe"></i> Web only</h3>
      </div>
      <div class="card-body">
        <p>If you don't need email/calendar/contacts on a phone or desktop client, skip the setup entirely &mdash; just bookmark the webmail and you're done.</p>

        <h5>Webmail</h5>
        <p><a href="/nc" target="_blank" rel="noopener" class="btn btn-primary"><i class="fas fa-envelope-open"></i> Open Webmail</a></p>
        <p>Sign in with your normal login password. The Mail, Calendar, and Contacts apps are all in the top bar of the webmail interface.</p>

        <p class="mb-0"><small>Want to add a client later? Come back to <a href="setup_devices.cfm">Set Up Your Devices</a> any time.</small></p>
      </div>
    </div>
  </div>
</div>
</cfoutput>
