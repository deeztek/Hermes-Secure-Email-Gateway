
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

<cfoutput>
<!-- Main Sidebar Container -->
<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="index.cfm" class="brand-link">
      <img src="/dist/img/hermes_logo.png" alt="Hermes SEG" class="brand-image " style="opacity: .8">
    
      <span class="brand-text ">SEG User</span>
    
    </a>

    
    <!-- Sidebar -->
    <div class="sidebar">

      <!---
      <!-- Sidebar user panel (optional) -->
      <div class="user-panel mt-3 pb-3 mb-3 d-flex">
        
        <div class="image">
          <cfoutput>
          <a href="edit_system_user.cfm?id="><img src="/dist/img/generic-user-160-160.png" class="img-circle elevation-2" alt="User Image" title="My Profile" \></a>
        </cfoutput>
        </div>

        <div class="info">

          <cfoutput>
          <a href="edit_system_user.cfm?id=" title="My Profile" class="d-block">#session.email#</a>
        </cfoutput>
        </div>
        
    
      </div>
    --->

      <!-- SidebarSearch Form -->
      <!---
      <div class="form-inline">
        <div class="input-group" data-widget="sidebar-search">
          <input class="form-control form-control-sidebar" type="search" placeholder="Search" aria-label="Search">
          <div class="input-group-append">
            <button class="btn btn-sidebar">
              <i class="fas fa-search fa-fw"></i>
            </button>
          </div>
        </div>
      </div>
    --->

    

      <!-- Sidebar Menu -->
      <nav class="mt-2">
        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
          <!-- Add icons to the links using the .nav-icon class
               with font-awesome or any other icon font library -->

               <li class="nav-item">
                <a href="report_settings.cfm" class="nav-link">
                  <i class="fas fa-file-invoice nav-icon"></i>
                  <p>
                   <strong>Report Settings</strong>
                  </p>
                </a>
              </li>

              
              <li class="nav-item">
                <a href="view_sender_filters.cfm" class="nav-link">
                  <i class="fas fa-filter nav-icon"></i>
                  <p>
                   <strong>Sender Filters</strong>
                  </p>
                </a>
              </li>

              
              <li class="nav-item">
                <a href="user_password.cfm" class="nav-link">
                  <i class="fas fa-key nav-icon"></i>
                  <p>
                   <strong>Change Password</strong>
                  </p>
                </a>
              </li>

  
       <li class="nav-item">
        <a href="preloader_view_message_history.cfm" class="nav-link">
          <i class="fas fa-history nav-icon"></i>
          <p>
           <strong>Message History</strong>
          </p>
        </a>
      </li>

     
      <div>&nbsp;&nbsp;</div>
           <!--- LOGOUT STARTS HERE --->
      <li class="nav-item">
        <a href="logout.cfm" class="nav-link">
          <i class="fas fa-sign-out-alt nav-icon"></i>
          <p>
           <strong>Logout</strong>
          </p>
        </a>
      </li>

       <!--- LOGOUT ENDS HERE --->



      </nav>
      <!-- /.sidebar-menu -->
    </div>
  </aside>

</cfoutput>