
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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
        <cfoutput>
        <a class="nav-link" role="button" title="My IP Address: #ClientIP#">
          <i class="fas fa-network-wired fa-lg"></i>
        </a>
        </cfoutput>
      </li>

      <li class="nav-item">
        <a class="nav-link" onclick="window.open('https://docs.deeztek.com/books/hermes-seg-administrator-guide')" role="button" title="Documentation">
          <i class="fas fa-book fa-lg"></i>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link" onclick="window.open('https://github.com/deeztek/Hermes-Secure-Email-Gateway/discussions/categories/support')" role="button" title="Support Forums">
          <i class="fas fa-users fa-lg"></i>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link" onclick="window.open('https://t.me/HermesSEG')" role="button" title="Telegram Channel">
          <i class="fab fa-telegram fa-lg"></i>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link" onclick="window.open('https://matrix.to/#/#hermesseg:matrix.org')" role="button" title="Matrix Channel">
          <i class="fas fa-comments fa-lg"></i>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link" onclick="window.open('https://github.com/deeztek/Hermes-Secure-Email-Gateway')" role="button" title="GitHub">
          <i class="fab fa-github fa-lg"></i>
        </a>
      </li>

      <li class="nav-item">
        <a class="nav-link" href="/admin/logout.cfm" role="button" title="Logout">
          <i class="fa fa-sign-out-alt fa-lg"></i>
        </a>
      </li>

    </ul>
    <!--end::End Navbar Links-->
  </div>
  <!--end::Container-->
</nav>
<!--end::Header-->
