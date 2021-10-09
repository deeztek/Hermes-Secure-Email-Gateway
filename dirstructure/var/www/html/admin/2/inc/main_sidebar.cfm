<cfoutput>
<!-- Main Sidebar Container -->
<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="index.cfm" class="brand-link">
      <img src="dist/img/hermes_logo.png" alt="Hermes SEG" class="brand-image " style="opacity: .8">
    
      <span class="brand-text ">SEG Admin</span>
    
    </a>

    <!-- Sidebar -->
    <div class="sidebar">
      <!-- Sidebar user panel (optional) 
      <div class="user-panel mt-3 pb-3 mb-3 d-flex">
        <div class="image">
          <img src="dist/img/generic-user-160-160.png" class="img-circle elevation-2" alt="User Image">
        </div>
        <div class="info">

          <a href="profile.cfm" class="d-block">Dino Edwards</a>
        </div>
      </div>
      -->

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
            <a href="##" class="nav-link">
              <i class="nav-icon fas fa-wrench"></i>
              <p>
                System
               
                <i class="fas fa-angle-right right"></i>
      
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-network-wired nav-icon"></i>
                  <p>Network Settings</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fab fa-expeditedssl nav-icon"></i>
                  <p>Console SSL Settings</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-fire nav-icon"></i>
                  <p>Admin Console Firewall</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="view_ad_connection.cfm" class="nav-link">
                  <i class="fab fa-microsoft nav-icon"></i>
                  <p>AD Integration</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-cogs nav-icon"></i>
                  <p>System Settings</small></p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-info nav-icon"></i>
                  <p>System Status</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-envelope nav-icon"></i>
                  <p>Mail Queue</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-key nav-icon"></i>
                  <p>Change Password</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-upload nav-icon"></i>
                  <p>System Backup</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-download nav-icon"></i>
                  <p>System Restore</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-file-archive nav-icon"></i>
                  <p>Email Archive</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-code nav-icon"></i>
                  <p>System Update</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-power-off nav-icon"></i>
                  <p>Reboot and Shutdown</p>
                </a>
              </li>
            </ul>
          </li>

          <li class="nav-item">
            <a href="##" class="nav-link">
              <i class="nav-icon fas fa-torii-gate"></i>
              <p>
                Gateway
               
                <i class="fas fa-angle-right right"></i>
   
              </p>
            </a>
            <ul class="nav nav-treeview">
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-signature nav-icon"></i>
                  <p>CSR Request</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fab fa-expeditedssl nav-icon"></i>
                  <p>SMTP TLS Settings</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-fire nav-icon"></i>
                  <p>SMTP TLS Policy</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fab fa-microsoft nav-icon"></i>
                  <p>Relay Host</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-cogs nav-icon"></i>
                  <p>Relay Domains</small></p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-info nav-icon"></i>
                  <p>Relay Networks</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="view_internal_recipients.cfm" class="nav-link">
                  <i class="fas fa-envelope nav-icon"></i>
                  <p>Internal Recipients</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="##" class="nav-link">
                  <i class="fas fa-key nav-icon"></i>
                  <p>Virtual Recipients</p>
                </a>
              </li>

              
            </ul>
          </li>

       
        </ul>
      </nav>
      <!-- /.sidebar-menu -->
    </div>
  </aside>

</cfoutput>