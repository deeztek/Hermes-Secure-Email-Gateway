<!---
SETUP DEVICES — WEB ONLY (#224 Phase 2b)

For users who don't want to set up any mail clients — they just use
the webmail interface at /nc. No app password needed; web logins use
their main login password (LDAP for local-auth users; the upstream
IdP for remote-auth users via OIDC SSO).

The /users portal sidebar already exposes a "Webmail & Apps" link via
preload_nc_login.cfm, but new users tend to find this wizard first —
so it's worth listing the option here explicitly with a quick tour
of what's actually inside the webmail.
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
        <p>If you don't need email/calendar/contacts on a phone or desktop client, skip the setup entirely &mdash; just bookmark the webmail and you're done. <strong>No app password needed</strong>; webmail uses your normal login.</p>

        <h5>Open Webmail</h5>
        <p><a href="/users/2/preload_nc_login.cfm" class="btn btn-primary"><i class="fas fa-envelope-open me-1"></i> Open Webmail &amp; Apps</a></p>

        <h5>What's inside</h5>
        <ul class="mb-3">
          <li><strong><i class="fas fa-envelope me-1"></i> Mail</strong> &mdash; full IMAP webmail, search, attachments, drafts. Same inbox you'd see in any IMAP client.</li>
          <li><strong><i class="fas fa-calendar-alt me-1"></i> Calendar</strong> &mdash; create / share / subscribe to calendars; invitations and free-busy lookups work end-to-end.</li>
          <li><strong><i class="fas fa-address-book me-1"></i> Contacts</strong> &mdash; address books with shared / personal scopes. Same store DAVx5, Apple Contacts, etc. would sync against.</li>
          <li><strong><i class="fas fa-folder-open me-1"></i> Files</strong> &mdash; personal file storage with sharing, public links, and version history.</li>
        </ul>

        <div class="alert alert-info mb-0">
          <h6 class="mb-1"><i class="icon fas fa-info-circle"></i> Works on any device with a browser</h6>
          <p class="mb-0">The webmail interface is fully responsive &mdash; it works on phones and tablets too. If you only ever check mail occasionally on the go, the web is often enough. Want to add a native client later? Come back to <a href="setup_devices.cfm">Set Up Your Devices</a> any time.</p>
        </div>
      </div>
    </div>
  </div>
</div>
</cfoutput>
