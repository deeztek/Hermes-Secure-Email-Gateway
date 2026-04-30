
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

<!-- Preloader -->
<div class="preloader">
  <img src="/dist/img/hermes_preloader.gif" alt="Loading">
</div>

<!--begin::Header-->
<nav class="app-header navbar navbar-expand bg-body">
  <!--begin::Container-->
  <div class="container-fluid">
    <!--begin::Start Navbar Links-->
    <ul class="navbar-nav">
      <li class="nav-item">
        <a class="nav-link" data-lte-toggle="sidebar" href="#" role="button">
          <i class="bi bi-list"></i>
        </a>
      </li>
    </ul>
    <!--end::Start Navbar Links-->

    <!--begin::End Navbar Links-->
    <ul class="navbar-nav ms-auto">

      <li class="nav-item">
        <a class="nav-link" onclick="window.open('https://docs.deeztek.com/books/hermes-seg-user-guide')" role="button" title="Help">
          <i class="fas fa-book fa-lg"></i>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link" href="/users/logout.cfm" role="button" title="Logout">
          <i class="fas fa-sign-out-alt fa-lg"></i>
        </a>
      </li>

    </ul>
    <!--end::End Navbar Links-->
  </div>
  <!--end::Container-->
</nav>
<!--end::Header-->

<!--- SECONDARY EMAIL NAGGING BANNER FOR LOCAL-AUTH MAILBOX USERS

    Skip the nag for remote-auth (SSO) users — their password lives in
    an external IdP, so a local recovery email here would not let them
    reset anything. session.auth_type is set in Application.cfc from the
    recipients table; "remote" = SSO, anything else = local. --->
<cfif session.theGroups CONTAINS "mailboxes" AND (NOT StructKeyExists(session, "auth_type") OR session.auth_type NEQ "remote")>
    <cfif NOT StructKeyExists(session, "secondary_email_verified") OR session.secondary_email_verified NEQ 1>
        <div class="alert alert-warning alert-dismissible d-flex align-items-center mb-0 rounded-0 border-start-0 border-end-0" role="alert">
            <div class="container-fluid d-flex justify-content-center align-items-center">
                <i class="fas fa-exclamation-triangle fa-lg me-3"></i>
                <div>
                    <cfif NOT StructKeyExists(session, "secondary_email") OR session.secondary_email EQ "">
                        <strong>Set Up Password Recovery:</strong>
                        <span class="ms-1">You have not set up a recovery email address. <a href="user_settings.cfm" class="alert-link">Click here to add one.</a></span>
                    <cfelse>
                        <strong>Verify Recovery Email:</strong>
                        <span class="ms-1">Your recovery email has not been verified. <a href="user_settings.cfm" class="alert-link">Click here to resend verification.</a></span>
                    </cfif>
                </div>
                <button type="button" class="btn-close ms-3" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
    </cfif>
</cfif>

<!--- 2FA NAGGING BANNER FOR MAILBOX USERS NOT YET IN cn=two_factor (#225)

    Visual pattern matches the secondary-email nag above. Condition is
    just session.theGroups membership — group plumbing is already in
    place from the user-side toggle in user_settings.cfm and the
    admin-side enforce_mfa flow in add/edit_mailbox_action.cfm.

    Banner self-resolves whether the user enabled it themselves OR an
    admin enforced it (both end states put them in cn=two_factor and
    Authelia's existing rules then walk them through device enrollment
    on next access — no separate enrollment URL needed). --->
<cfif session.theGroups CONTAINS "mailboxes" AND NOT (session.theGroups CONTAINS "two_factor")>
    <div class="alert alert-warning alert-dismissible d-flex align-items-center mb-0 rounded-0 border-start-0 border-end-0" role="alert">
        <div class="container-fluid d-flex justify-content-center align-items-center">
            <i class="fas fa-shield-alt fa-lg me-3"></i>
            <div>
                <strong>Protect your account with Two-Factor Authentication:</strong>
                <span class="ms-1">You haven't enabled 2FA yet. <a href="user_settings.cfm" class="alert-link">Click here to enable it</a> &mdash; you'll be guided through device setup the next time you sign in.</span>
            </div>
            <button type="button" class="btn-close ms-3" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
</cfif>
