<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!---
RESTRICTED-ACCESS PANEL (#225 Phase 1.5)

Rendered in place of a restricted page's main content when
check_enforce_mfa_restriction.cfm sets enforceMfaRestricted = true.
The user clicked a sidebar link they're not allowed into yet because
the admin requires 2FA and the user hasn't enabled it yet. Walks them
through the bootstrap.

Caller is responsible for the surrounding page chrome (DOCTYPE, head,
sidebars, footer). This fragment renders only the panel that fills
the main content area.
--->

<cfoutput>
<div class="row">
  <div class="col-12 col-lg-9 col-xl-7">

    <div class="card card-warning card-outline">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fas fa-shield-alt me-2"></i>Two-Factor Authentication required</h3>
      </div>
      <div class="card-body">
        <div class="alert alert-warning mb-3">
          <p class="mb-2"><strong>Your administrator requires Two-Factor Authentication (2FA) on your account.</strong></p>
          <p class="mb-0">Until you enable 2FA, your portal access is limited to <strong>Account Settings</strong>, <strong>My App Passwords</strong>, <strong>Set Up Your Devices</strong>, and <strong>Webmail &amp; Apps</strong>. Other sections (Notification Settings, Sender Filters, Message History, Mail Filters, Vacation Auto-Reply, Shared Folders) unlock automatically once you're enrolled.</p>
        </div>

        <h5 class="mb-2">How to enable 2FA &mdash; follow these steps in order</h5>
        <ol class="mb-3">
          <li class="mb-2"><strong>Open Webmail in a new browser tab</strong> &mdash; <a href="/users/2/preload_nc_login.cfm" target="_blank" rel="noopener">click here to open it now</a>. <strong>Keep that tab open</strong>; you'll use it to read the verification email during enrollment.</li>
          <li class="mb-2">Go to <a href="user_settings.cfm">Account Settings</a> and click <strong>Enable 2FA now</strong>.</li>
          <li class="mb-2">Sign out of this portal, then sign back in. (Your Webmail tab will stay logged in.)</li>
          <li class="mb-2">Sign-in will route through 2FA enrollment. A verification email arrives in your Webmail tab &mdash; switch to that tab, open the email, and click the link.</li>
          <li class="mb-0">Register a 2FA device (authenticator app, security key, or Duo Push). The portal unlocks automatically once enrolled.</li>
        </ol>

        <p class="text-muted mb-3"><small><i class="fas fa-info-circle me-1"></i> Make sure Webmail is open in another tab <em>before</em> clicking Enable in step 2.</small></p>

        <a href="user_settings.cfm" class="btn btn-warning"><i class="fas fa-shield-alt me-1"></i> Go to Account Settings to enable 2FA</a>
      </div>
    </div>

  </div>
</div>
</cfoutput>
