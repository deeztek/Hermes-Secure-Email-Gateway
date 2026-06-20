
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

<!--- Check if mailbox sharing is enabled (for Shared Folders link visibility) --->
<cfquery name="getSidebarSharingEnabled" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'dovecot' AND parameter = 'sharing.enabled'
</cfquery>
<cfset sidebarSharingEnabled = (getSidebarSharingEnabled.recordcount GTE 1 AND getSidebarSharingEnabled.value2 EQ "yes")>

<!--- #226: Personal Signature link visibility. Gated on the user's
     domain.allow_user_signatures flag - if the admin disabled
     user-managed signatures for this domain, the link is hidden and
     view_signature.cfm renders a locked-out screen on direct hit. --->
<cfquery name="getSidebarSignaturesEnabled" datasource="hermes">
    SELECT d.allow_user_signatures
    FROM mailboxes m
    INNER JOIN domains d ON m.domain_id = d.id
    WHERE m.username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfset sidebarSignaturesEnabled = (getSidebarSignaturesEnabled.recordcount GTE 1 AND Val(getSidebarSignaturesEnabled.allow_user_signatures) EQ 1)>

<cfoutput>
<!--begin::Sidebar-->
<aside class="app-sidebar bg-body-secondary shadow" data-bs-theme="dark">
  <!--begin::Sidebar Brand-->
  <div class="sidebar-brand">
    <a href="index.cfm" class="brand-link">
      <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="brand-image opacity-75 shadow">
      <span class="brand-text fw-light">User Console</span>
    </a>
  </div>
  <!--end::Sidebar Brand-->

  <!--begin::Sidebar Wrapper-->
  <div class="sidebar-wrapper">
    <!-- Sidebar Menu -->
    <nav class="mt-2">
      <ul class="nav sidebar-menu flex-column" data-lte-toggle="treeview" role="menu" data-accordion="false">

        <li class="nav-item">
          <a href="report_settings.cfm" class="nav-link">
            <i class="nav-icon fas fa-bell"></i>
            <p><strong>Notification Settings</strong></p>
          </a>
        </li>

        <li class="nav-item">
          <a href="view_sender_filters.cfm" class="nav-link">
            <i class="nav-icon fas fa-filter"></i>
            <p><strong>Sender Filters</strong></p>
          </a>
        </li>

        <li class="nav-item">
          <a href="user_settings.cfm" class="nav-link">
            <i class="nav-icon fas fa-cog"></i>
            <p><strong>Account Settings</strong></p>
          </a>
        </li>

        <li class="nav-item">
          <a href="view_message_history.cfm" class="nav-link">
            <i class="nav-icon fas fa-history"></i>
            <p><strong>Message History</strong></p>
          </a>
        </li>

        <cfif #session.theGroups# contains "mailboxes">
        <li class="nav-item">
          <a href="view_app_passwords.cfm" class="nav-link">
            <i class="nav-icon fas fa-key"></i>
            <p><strong>My App Passwords</strong></p>
          </a>
        </li>
        <li class="nav-item">
          <a href="setup_devices.cfm" class="nav-link">
            <i class="nav-icon fas fa-mobile-alt"></i>
            <p><strong>Set Up Your Devices</strong></p>
          </a>
        </li>
        <li class="nav-item">
          <a href="view_sieve_rules.cfm" class="nav-link">
            <i class="nav-icon fas fa-filter"></i>
            <p><strong>Mail Filters</strong></p>
          </a>
        </li>
        <li class="nav-item">
          <a href="view_vacation.cfm" class="nav-link">
            <i class="nav-icon fas fa-paper-plane"></i>
            <p><strong>Vacation Auto-Reply</strong></p>
          </a>
        </li>
        <cfif sidebarSignaturesEnabled>
        <li class="nav-item">
          <a href="view_signature.cfm" class="nav-link">
            <i class="nav-icon fas fa-signature"></i>
            <p><strong>Personal Signature</strong></p>
          </a>
        </li>
        </cfif>
        <cfif sidebarSharingEnabled>
        <li class="nav-item">
          <a href="view_shared_folders.cfm" class="nav-link">
            <i class="nav-icon fas fa-share-alt"></i>
            <p><strong>Shared Folders</strong></p>
          </a>
        </li>
        </cfif>
        <cfif #session.theGroups# contains "nextcloud">
        <li class="nav-item">
          <a href="/users/2/preload_nc_login.cfm" class="nav-link" title="Mail, Calendar, Contacts, Files">
            <i class="nav-icon fas fa-inbox"></i>
            <p><strong>Webmail &amp; Apps</strong></p>
          </a>
        </li>
        </cfif>
        </cfif>

      </ul>
    </nav>
    <!-- /.sidebar-menu -->
  </div>
  <!--end::Sidebar Wrapper-->
</aside>
<!--end::Sidebar-->
</cfoutput>
