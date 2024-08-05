
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
    <a href="preloader_index.cfm" class="brand-link">
      <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="brand-image " style="opacity: .8">
    
      <span class="brand-text ">Admin Console</span>
    
    </a>

    <!-- Sidebar -->
    <div class="sidebar">
      <!-- Sidebar user panel (optional) -->
      <div class="user-panel mt-3 pb-3 mb-3 d-flex">
        <div class="image">
          <cfoutput>
          <a href="edit_system_user.cfm?id=#session.userid#"><img src="/dist/img/generic-user-160-160.png" class="img-circle elevation-2" alt="User Image" title="My Profile" \></a>
        </cfoutput>
        </div>
        <div class="info">

          <cfoutput>
          <a href="edit_system_user.cfm?id=#session.userid#" title="My Profile" class="d-block">#session.first_name# #session.last_name#</a>
        </cfoutput>
        </div>
    
      </div>
     

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

                 <!--- SYSTEM STARTS HERE --->
              
          <li class="nav-item">
            <a href="##" class="nav-link">
              <i class="nav-icon fas fa-wrench"></i>
              <p>
                <strong>System</strong>
               
                <i class="fas fa-angle-right right"></i>
      
              </p>
            </a>

            <ul class="nav nav-treeview">

              <li class="nav-item">
                <a href="view_ad_connection.cfm" class="nav-link">
                  <i class="fab fa-microsoft nav-icon"></i>
                  <p>AD Integration</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="view_authentication_settings.cfm" class="nav-link">
                  <i class="fas fa-unlock-alt nav-icon"></i>
                  <p>Admin Authentication</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="view_console_firewall.cfm" class="nav-link">
                  <i class="fas fa-fire nav-icon"></i>
                  <p>Admin Console Firewall</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="view_network_settings.cfm" class="nav-link">
                  <i class="fas fa-network-wired nav-icon"></i>
                  <p>Network Settings</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="view_console_settings.cfm" class="nav-link">
                  <i class="fab fa-expeditedssl nav-icon"></i>
                  <p>Console Settings</p>
                </a>
              </li>



              <li class="nav-item">
                <a href="preloader_view_mail_queue.cfm" class="nav-link">
                  <i class="fas fa-inbox nav-icon"></i>
                  <p>Mail Queue</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="preloader_view_system_logs.cfm" class="nav-link">
                  <i class="fas fa-inbox nav-icon"></i>
                  <p>System Logs</p>
                </a>
              </li>

              
              <li class="nav-item">
                <a href="view_system_certificates.cfm" class="nav-link">
                  <i class="fas fa-certificate nav-icon"></i>
                  <p>System Certificates</p>
                </a>
              </li>

              
                            
              <li class="nav-item">
                <a href="view_system_settings.cfm" class="nav-link">
                  <i class="fas fa-cogs nav-icon"></i>
                  <p>System Settings</small></p>
                </a>
              </li>

              <li class="nav-item">
                <a href="preloader_index.cfm" class="nav-link">
                  <i class="fas fa-info nav-icon"></i>
                  <p>System Status</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="view_system_updates.cfm" class="nav-link">
                  <i class="fas fa-code nav-icon"></i>
                  <p>System Update</p>
                </a>
              </li>
           
              <li class="nav-item">
                <a href="view_system_users.cfm" class="nav-link">
                  <i class="fas fa-users nav-icon"></i>
                  <p>System Users</p>
                </a>
              </li>

        


              <li class="nav-item">
                <a href="/admin/email_archive.cfm" class="nav-link">
                  <i class="fas fa-file-archive nav-icon"></i>
                  <p>Email Archive</p>
                </a>
              </li>

    

              <li class="nav-item">
                <a href="/admin/system_restart.cfm" class="nav-link">
                  <i class="fas fa-power-off nav-icon"></i>
                  <p>Reboot and Shutdown</p>
                </a>
              </li>
            </ul>
          </li>

              <!--- SYSTEM ENDS HERE --->

          <!--- GATEWAY STARTS HERE --->

          <li class="nav-item">
            <a href="##" class="nav-link">
              <i class="nav-icon fas fa-torii-gate"></i>
              <p>
                <strong>Gateway</strong>
               
                <i class="fas fa-angle-right right"></i>
   
              </p>
            </a>

            <ul class="nav nav-treeview">
       

              <li class="nav-item">
                <a href="view_smtp_tls_settings.cfm" class="nav-link">
                  <i class="fab fa-expeditedssl nav-icon"></i>
                  <p>SMTP TLS Settings</p>
                </a>
              </li>

              <li class="nav-item">
                <a href="/admin/relay_host.cfm" class="nav-link">
                  <i class="fab fa-microsoft nav-icon"></i>
                  <p>Relay Host</p>
                </a>
              </li>
              <li class="nav-item">
                <a href="view_domains.cfm" class="nav-link">
                  <i class="fas fa-cogs nav-icon"></i>
                  <p>Domains</small></p>
                </a>
              </li>
              <li class="nav-item">
                <a href="/admin/select.cfm" class="nav-link">
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
                <a href="view_virtual_recipients.cfm" class="nav-link">
                  <i class="fas fa-key nav-icon"></i>
                  <p>Virtual Recipients</p>
                </a>
              </li>



              
            </ul>
          </li>

          <!--- GATEWAY ENDS HERE --->

                     <!--- CONTENT CHECKS STARTS HERE --->

                     <li class="nav-item">
                      <a href="##" class="nav-link">
                        <i class="nav-icon fas fa-check-square"></i>
                        <p>
                         <strong>Content Checks</strong>
                         
                          <i class="fas fa-angle-right right"></i>
             
                        </p>
                      </a>

                      <ul class="nav nav-treeview">
                        <li class="nav-item">
                          <a href="/admin/perimeter_configuration.cfm" class="nav-link">
                            <i class="far fa-square nav-icon"></i>
                            <p>Perimeter Checks</p>
                          </a>
                        </li>
                        <li class="nav-item">
                          <a href="/admin/rbl.cfm" class="nav-link">
                            <i class="fas fa-ban nav-icon"></i>
                            <p>RBL Configuration</p>
                          </a>
                        </li>
                        <li class="nav-item">
                          <a href="/admin/rbl_override.cfm" class="nav-link">
                            <i class="fas fa-network-wired nav-icon"></i>
                            <p>Network Block/Allow</p>
                          </a>
                        </li>
                        <li class="nav-item">
                          <a href="/admin/sender_bypass.cfm" class="nav-link">
                            <i class="fab fa-connectdevelop nav-icon"></i>
                            <p>Sender to Recipient Block/Allow</p>
                          </a>
                        </li>
                        <li class="nav-item">
                          <a href="/admin/global_sender_bypass.cfm" class="nav-link">
                            <i class="fas fa-globe nav-icon"></i>
                            <p>Global Sender Block/Allow</small></p>
                          </a>
                        </li>
                        <li class="nav-item">
                          <a href="view_spf_settings.cfm" class="nav-link">
                            <i class="fas fa-crop-alt nav-icon"></i>
                            <p>SPF Settings</p>
                          </a>
                        </li>
              


                        <li class="nav-item">
                          <a href="view_dkim_settings.cfm" class="nav-link">
                            <i class="fas fa-key nav-icon"></i>
                            <p>DKIM Settings</p>
                          </a>
                        </li>
                        

       

                        <li class="nav-item">
                          <a href="view_dmarc_settings.cfm" class="nav-link">
                            <i class="fas fa-adjust nav-icon"></i>
                            <p>DMARC Settings</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/antivirus_settings.cfm" class="nav-link">
                            <i class="fas fa-virus nav-icon"></i>
                            <p>Antivirus Settings</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/antivirus_signature_feeds.cfm" class="nav-link">
                            <i class="fas fa-virus nav-icon"></i>
                            <p>Antivirus Signature Feeds</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/antivirus_signature_bypass.cfm" class="nav-link">
                            <i class="fas fa-virus nav-icon"></i>
                            <p>Antivirus Signature Bypass</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/spam_settings.cfm" class="nav-link">
                            <i class="fas fa-shield-virus nav-icon"></i>
                            <p>Antispam Settings</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/spam_filter_tests.cfm" class="nav-link">
                            <i class="fas fa-shield-virus nav-icon"></i>
                            <p>Antispam Filter Tests</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/initialize_pyzor.cfm" class="nav-link">
                            <i class="fas fa-play-circle nav-icon"></i>
                            <p>Initialize Pyzor</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/initialize_razor.cfm" class="nav-link">
                            <i class="fas fa-play-circle nav-icon"></i>
                            <p>Intialize Razor</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/clear_bayes.cfm" class="nav-link">
                            <i class="fas fa-database nav-icon"></i>
                            <p>Clear Bayes Database</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/file_extensions.cfm" class="nav-link">
                            <i class="far fa-file nav-icon"></i>
                            <p>File Extensions</p>
                          </a>
                        </li>
      
                        <li class="nav-item">
                          <a href="/admin/file_expressions.cfm" class="nav-link">
                            <i class="far fa-file nav-icon"></i>
                            <p>File Expressions</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/file_rules.cfm" class="nav-link">
                            <i class="far fa-file nav-icon"></i>
                            <p>File Rules</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/message_rules.cfm" class="nav-link">
                            <i class="fas fa-envelope-open-text nav-icon"></i>
                            <p>Message Rules</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="/admin/spam_policies.cfm" class="nav-link">
                            <i class="fas fa-object-group nav-icon"></i>
                            <p>SVF Policies</p>
                          </a>
                        </li>

                        <li class="nav-item">
                          <a href="preloader_view_message_history.cfm" class="nav-link">
                            <i class="fas fa-history nav-icon"></i>
                            <p>Message History</p>
                          </a>
                        </li>
                        
        </ul>
      </li>
      <!--- CONTENT CHECKS ENDS HERE --->

                <!--- ENCRYPTION STARTS HERE --->

                <li class="nav-item">
                  <a href="##" class="nav-link">
                    <i class="nav-icon fas fa-torii-gate"></i>
                    <p>
                      <strong>Encryption</strong>
                     
                      <i class="fas fa-angle-right right"></i>
         
                    </p>
                  </a>
      
                  <ul class="nav nav-treeview">
             
      
                    <li class="nav-item">
                      <a href="/admin/ca_settings.cfm" class="nav-link">
                        <i class="fab fa-expeditedssl nav-icon"></i>
                        <p>Internal CA</p>
                      </a>
                    </li>
      
                    <li class="nav-item">
                      <a href="/admin/key_servers.cfm" class="nav-link">
                        <i class="fab fa-microsoft nav-icon"></i>
                        <p>PGP Key Servers</p>
                      </a>
                    </li>
                    <li class="nav-item">
                      <a href="/admin/encryption_settings.cfm" class="nav-link">
                        <i class="fas fa-cogs nav-icon"></i>
                        <p>Encryption Settings</small></p>
                      </a>
                    </li>
                    <li class="nav-item">
                      <a href="/admin/external_encryption_users.cfm" class="nav-link">
                        <i class="fas fa-info nav-icon"></i>
                        <p>Ext Rec Encryption</p>
                      </a>
                    </li>
                   
      
      
      
                    
                  </ul>
                </li>
      
                <!--- GATEWAY ENDS HERE --->

    

           <!--- LOGOUT STARTS HERE --->
      <li class="nav-item">
        <a href="/admin/logout.cfm" class="nav-link">
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