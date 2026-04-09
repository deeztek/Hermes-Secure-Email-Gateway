
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
          <a href="view_sieve_rules.cfm" class="nav-link">
            <i class="nav-icon fas fa-filter"></i>
            <p><strong>Mail Filters</strong></p>
          </a>
        </li>
        <li class="nav-item">
          <a href="/nc/" class="nav-link">
            <i class="nav-icon fas fa-inbox"></i>
            <p><strong>Login to Webmail</strong></p>
          </a>
        </li>
        </cfif>

      </ul>
    </nav>
    <!-- /.sidebar-menu -->
  </div>
  <!--end::Sidebar Wrapper-->
</aside>
<!--end::Sidebar-->
</cfoutput>
