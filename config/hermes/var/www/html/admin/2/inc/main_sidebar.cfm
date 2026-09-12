
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
<!--begin::Sidebar-->
<aside class="app-sidebar bg-body-secondary shadow" data-bs-theme="dark">
  <!--begin::Sidebar Brand-->
  <div class="sidebar-brand">
    <a href="index.cfm" class="brand-link">
      <img src="/dist/img/hermes_logo_new_orange2.png" alt="Hermes SEG" class="brand-image opacity-75 shadow">
      <span class="brand-text fw-light">Admin Console</span>
    </a>
  </div>
  <!--end::Sidebar Brand-->

  <!--begin::Sidebar Wrapper-->
  <div class="sidebar-wrapper">
    <!-- Sidebar user panel -->
    <div class="user-panel mt-3 pb-3 mb-3 d-flex align-items-center">
      <div class="image">
        <cfoutput>
        <a href="edit_system_user.cfm?id=#session.userid#">
          <img src="/dist/img/generic-user-160-160.png" class="img-circle elevation-2" alt="User Image" title="My Profile">
        </a>
        </cfoutput>
      </div>
      <div class="info">
        <cfoutput>
        <a href="edit_system_user.cfm?id=#session.userid#" title="My Profile" class="d-block text-decoration-none">#session.first_name# #session.last_name#</a>
        </cfoutput>
      </div>
    </div>

    <!-- Sidebar Menu -->
    <nav class="mt-2">
      <ul class="nav sidebar-menu flex-column" data-lte-toggle="treeview" role="menu" data-accordion="false">

        <!--- SYSTEM STARTS HERE --->
        <li class="nav-item">
          <a href="##" class="nav-link">
            <i class="nav-icon fas fa-wrench"></i>
            <p>
              <strong>System</strong>
              <i class="nav-arrow bi bi-chevron-right"></i>
            </p>
          </a>
          <ul class="nav nav-treeview">
            <li class="nav-item">
              <a href="view_remoteauth.cfm" class="nav-link">
                <i class="nav-icon fas fa-server"></i>
                <p>
                  LDAP RemoteAuth
                  <cfif NOT (isDefined("session.edition") AND session.edition EQ "Pro")>
                  <span class="badge bg-warning text-dark ms-1" style="font-size:9px;">PRO</span>
                  </cfif>
                </p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_intrusion_prevention.cfm" class="nav-link">
                <i class="nav-icon fas fa-shield-alt"></i>
                <p>
                  IPS
                  <cfif NOT (isDefined("session.edition") AND session.edition EQ "Pro")>
                  <span class="badge bg-warning text-dark ms-1" style="font-size:9px;">PRO</span>
                  </cfif>
                </p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_authentication_settings.cfm" class="nav-link">
                <i class="nav-icon fas fa-unlock-alt"></i>
                <p>Authentication Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_console_firewall.cfm" class="nav-link">
                <i class="nav-icon fas fa-fire"></i>
                <p>
                  Console Firewall
                  <cfif NOT (isDefined("session.edition") AND session.edition EQ "Pro")>
                  <span class="badge bg-warning text-dark ms-1" style="font-size:9px;">PRO</span>
                  </cfif>
                </p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_console_settings.cfm" class="nav-link">
                <i class="nav-icon fab fa-expeditedssl"></i>
                <p>Console Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_mail_queue.cfm" class="nav-link">
                <i class="nav-icon fas fa-inbox"></i>
                <p>Mail Queue</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_system_logs.cfm" class="nav-link">
                <i class="nav-icon fas fa-inbox"></i>
                <p>System Logs</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_system_certificates.cfm" class="nav-link">
                <i class="nav-icon fas fa-certificate"></i>
                <p>System Certificates</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_smtp_tls_settings.cfm" class="nav-link">
                <i class="nav-icon fab fa-expeditedssl"></i>
                <p>SMTP TLS Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_system_settings.cfm" class="nav-link">
                <i class="nav-icon fas fa-cogs"></i>
                <p>System Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_server_setup.cfm" class="nav-link">
                <i class="nav-icon fas fa-cogs"></i>
                <p>Server Setup</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_system_notifications.cfm" class="nav-link">
                <i class="nav-icon fas fa-bell"></i>
                <p>System Notifications</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="index.cfm" class="nav-link">
                <i class="nav-icon fas fa-info"></i>
                <p>System Status</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_system_updates.cfm" class="nav-link">
                <i class="nav-icon fas fa-code"></i>
                <p>System Update</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_dns_resolver.cfm" class="nav-link">
                <i class="nav-icon fas fa-globe"></i>
                <p>DNS Resolver</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_network_aliases.cfm" class="nav-link">
                <i class="nav-icon fas fa-network-wired"></i>
                <p>Network Aliases</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_scheduled_tasks.cfm" class="nav-link">
                <i class="nav-icon fas fa-clock"></i>
                <p>Scheduled Tasks</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_system_backup.cfm" class="nav-link">
                <i class="nav-icon fas fa-archive"></i>
                <p>Backup/Restore</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_system_users.cfm" class="nav-link">
                <i class="nav-icon fas fa-users"></i>
                <p>System Users</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_password_reset_requests.cfm" class="nav-link">
                <i class="nav-icon fas fa-key"></i>
                <p>Password Resets</p>
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
              <strong>Email Relay</strong>
              <i class="nav-arrow bi bi-chevron-right"></i>
            </p>
          </a>
          <ul class="nav nav-treeview">
            <li class="nav-item">
              <a href="view_relay_host.cfm" class="nav-link">
                <i class="nav-icon fas fa-server"></i>
                <p>Relay Host</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_domains.cfm" class="nav-link">
                <i class="nav-icon fas fa-cogs"></i>
                <p>Domains</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_relay_networks.cfm" class="nav-link">
                <i class="nav-icon fas fa-network-wired"></i>
                <p>Relay Networks</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_internal_recipients.cfm" class="nav-link">
                <i class="nav-icon fas fa-envelope"></i>
                <p>Relay Recipients</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_virtual_recipients.cfm" class="nav-link">
                <i class="nav-icon fas fa-key"></i>
                <p>Virtual Recipients</p>
              </a>
            </li>
          </ul>
        </li>
        <!--- GATEWAY ENDS HERE --->

        <!--- EMAIL SERVER STARTS HERE --->
        <li class="nav-item">
          <a href="##" class="nav-link">
            <i class="nav-icon fas fa-inbox"></i>
            <p>
              <strong>Email Server</strong>
              <i class="nav-arrow bi bi-chevron-right"></i>
            </p>
          </a>
          <ul class="nav nav-treeview">
            <li class="nav-item">
              <a href="view_email_server_settings.cfm" class="nav-link">
                <i class="nav-icon fas fa-sliders-h"></i>
                <p>Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_mailbox_domains.cfm" class="nav-link">
                <i class="nav-icon fas fa-cogs"></i>
                <p>Domains</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_mailboxes.cfm" class="nav-link">
                <i class="nav-icon fas fa-envelope"></i>
                <p>Mailboxes</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_mailbox_aliases.cfm" class="nav-link">
                <i class="nav-icon fas fa-share"></i>
                <p>Aliases</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_shared_mailboxes.cfm" class="nav-link">
                <i class="nav-icon fas fa-users"></i>
                <p>Shared Mailboxes</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_sieve_rules.cfm" class="nav-link">
                <i class="nav-icon fas fa-filter"></i>
                <p>Mailbox Rules</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_mailbox_sans.cfm" class="nav-link">
                <i class="nav-icon fas fa-network-wired"></i>
                <p>SAN Management</p>
              </a>
            </li>
          </ul>
        </li>
        <!--- EMAIL SERVER ENDS HERE --->

        <!--- CONTENT CHECKS STARTS HERE --->
        <li class="nav-item">
          <a href="##" class="nav-link">
            <i class="nav-icon fas fa-check-square"></i>
            <p>
              <strong>Content Checks</strong>
              <i class="nav-arrow bi bi-chevron-right"></i>
            </p>
          </a>
          <ul class="nav nav-treeview">
            <li class="nav-item">
              <a href="view_perimeter_checks.cfm" class="nav-link">
                <i class="nav-icon far fa-square"></i>
                <p>Perimeter Checks</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_rbl_configuration.cfm" class="nav-link">
                <i class="nav-icon fas fa-ban"></i>
                <p>RBL Configuration</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_network_block_allow.cfm" class="nav-link">
                <i class="nav-icon fas fa-network-wired"></i>
                <p>Network Block/Allow</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_sender_recipient_block_allow.cfm" class="nav-link">
                <i class="nav-icon fab fa-connectdevelop"></i>
                <p>Sender/Recipient Rules</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_global_sender_block_allow.cfm" class="nav-link">
                <i class="nav-icon fas fa-globe"></i>
                <p>Global Sender Rules</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_bcc_maps.cfm" class="nav-link">
                <i class="nav-icon fas fa-copy"></i>
                <p>BCC Maps</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_spf_settings.cfm" class="nav-link">
                <i class="nav-icon fas fa-crop-alt"></i>
                <p>SPF Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_dkim_settings.cfm" class="nav-link">
                <i class="nav-icon fas fa-key"></i>
                <p>DKIM Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_dmarc_settings.cfm" class="nav-link">
                <i class="nav-icon fas fa-adjust"></i>
                <p>DMARC Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_arc_settings.cfm" class="nav-link">
                <i class="nav-icon fas fa-link"></i>
                <p>ARC Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_antivirus_settings.cfm" class="nav-link">
                <i class="nav-icon fas fa-virus"></i>
                <p>Antivirus Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_malware_feeds.cfm" class="nav-link">
                <i class="nav-icon fas fa-biohazard"></i>
                <p>Malware Feeds</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_antispam_maintenance.cfm" class="nav-link">
                <i class="nav-icon fas fa-shield-virus"></i>
                <p>Antispam Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_score_overrides.cfm" class="nav-link">
                <i class="nav-icon fas fa-sliders-h"></i>
                <p>Score Overrides</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_file_extensions.cfm" class="nav-link">
                <i class="nav-icon far fa-file"></i>
                <p>File Extensions</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_file_expressions.cfm" class="nav-link">
                <i class="nav-icon far fa-file"></i>
                <p>File Expressions</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_file_rules.cfm" class="nav-link">
                <i class="nav-icon far fa-file"></i>
                <p>File Rules</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_message_rules.cfm" class="nav-link">
                <i class="nav-icon fas fa-envelope-open-text"></i>
                <p>Message Rules</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_svf_policies.cfm" class="nav-link">
                <i class="nav-icon fas fa-object-group"></i>
                <p>SVF Policies</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_message_history.cfm" class="nav-link">
                <i class="nav-icon fas fa-history"></i>
                <p>Message History</p>
              </a>
            </li>
          </ul>
        </li>
        <!--- CONTENT CHECKS ENDS HERE --->

        <!--- EMAIL POLICIES STARTS HERE (##214). Pro-edition feature; the
             sidebar entry renders for all editions but the pages enforce
             a license check. Future home for outbound DLP, attachment
             rules, and an eventual migration target for parts of Content
             Checks. --->
        <li class="nav-item">
          <a href="##" class="nav-link">
            <i class="nav-icon fas fa-clipboard-list"></i>
            <p>
              <strong>Email Policies</strong>
              <i class="nav-arrow bi bi-chevron-right"></i>
            </p>
          </a>
          <ul class="nav nav-treeview">
            <li class="nav-item">
              <a href="view_disclaimers.cfm" class="nav-link">
                <i class="nav-icon fas fa-file-signature"></i>
                <p>
                  Disclaimers
                  <cfif NOT (isDefined("session.edition") AND session.edition EQ "Pro")>
                  <span class="badge bg-warning text-dark ms-1" style="font-size:9px;">PRO</span>
                  </cfif>
                </p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_org_signatures.cfm" class="nav-link">
                <i class="nav-icon fas fa-id-card"></i>
                <p>
                  Org Signatures
                  <cfif NOT (isDefined("session.edition") AND session.edition EQ "Pro")>
                  <span class="badge bg-warning text-dark ms-1" style="font-size:9px;">PRO</span>
                  </cfif>
                </p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_external_banners.cfm" class="nav-link">
                <i class="nav-icon fas fa-shield-alt"></i>
                <p>External Banner</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="view_linkguard.cfm" class="nav-link">
                <i class="nav-icon fas fa-link"></i>
                <p>
                  Link Guard
                  <cfif NOT (isDefined("session.edition") AND session.edition EQ "Pro")>
                  <span class="badge bg-warning text-dark ms-1" style="font-size:9px;">PRO</span>
                  </cfif>
                </p>
              </a>
            </li>
          </ul>
        </li>
        <!--- EMAIL POLICIES ENDS HERE --->

        <!--- ENCRYPTION STARTS HERE --->
        <li class="nav-item">
          <a href="##" class="nav-link">
            <i class="nav-icon fas fa-lock"></i>
            <p>
              <strong>Encryption</strong>
              <i class="nav-arrow bi bi-chevron-right"></i>
            </p>
          </a>
          <ul class="nav nav-treeview">
            <li class="nav-item">
              <a href="/admin/2/view_internal_ca.cfm" class="nav-link">
                <i class="nav-icon fab fa-expeditedssl"></i>
                <p>Internal CA</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="/admin/2/view_pgp_key_servers.cfm" class="nav-link">
                <i class="nav-icon fas fa-key"></i>
                <p>PGP Key Servers</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="/admin/2/view_encryption_settings.cfm" class="nav-link">
                <i class="nav-icon fas fa-cogs"></i>
                <p>Encryption Settings</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="/admin/2/view_ext_rec_encryption.cfm" class="nav-link">
                <i class="nav-icon fas fa-user-lock"></i>
                <p>External Recipients</p>
              </a>
            </li>
            <li class="nav-item">
              <a href="/ciphermail/" class="nav-link" target="_blank">
                <i class="nav-icon fas fa-shield-alt"></i>
                <p>Advanced Settings <i class="fas fa-external-link-alt fa-xs"></i></p>
              </a>
            </li>
          </ul>
        </li>
        <!--- ENCRYPTION ENDS HERE --->

      </ul>
    </nav>
    <!-- /.sidebar-menu -->
  </div>
  <!--end::Sidebar Wrapper-->
</aside>
<!--end::Sidebar-->

<!---
  Issue 309 -- keep the section containing the current page expanded, and mark
  the page itself active.

  The tree is static markup with no awareness of the requested template, so
  every navigation collapsed it and the operator had to re-open the section
  they were working in. Worst in Content Checks and System, which have the
  longest child lists. Reported by a user via discussion 307.

  Done in JS rather than CFML on purpose. There are 66 nav-links across 6
  treeview sections; a <cfif> on each would be 66 edits now and another one
  every time the menu grows. This stays correct on its own.

  Runs INLINE at parse time, not on DOMContentLoaded. adminlte.min.js is loaded
  by html_head.cfm, which is included before this file, so its script tag is
  parsed before the sidebar markup exists and it can only initialise on
  DOMContentLoaded. Setting the classes here means they are already present when
  it does, which is the same state a static AdminLTE template ships with.

  Note for anyone extending this: the whole file is inside a cfoutput block,
  where a
  literal hash is an expression delimiter and has to be doubled. There is no
  precedent in this codebase for one appearing inside a CFML comment, so this
  block avoids them entirely rather than relying on the parser stripping
  comments first. The parent-toggle test below keys off '.cfm' for the same
  reason, instead of testing whether the href is a bare hash.
--->
<script>
(function () {
  var links = document.querySelectorAll('.app-sidebar a.nav-link[href]');
  if (!links.length) { return; }

  // Requested template name, lowercased, query string discarded.
  var here = (window.location.pathname.split('/').pop() || 'index.cfm').toLowerCase();

  var match = null;
  for (var i = 0; i < links.length; i++) {
    var href = links[i].getAttribute('href') || '';
    // Parent toggles have no .cfm target; only real pages can match.
    if (href.toLowerCase().indexOf('.cfm') === -1) { continue; }
    if (href.split('?')[0].split('/').pop().toLowerCase() === here) {
      match = links[i];
      break;
    }
  }

  // No match is normal: the dashboard is reached from the brand link, and some
  // pages are not in the menu at all. Leave the sidebar as AdminLTE renders it.
  if (!match) { return; }

  match.classList.add('active');

  // Open every ancestor section. A loop rather than one step, so a future
  // nested submenu opens all the way down without this needing to change.
  var node = match.closest('li.nav-item');
  while (node && node.parentElement) {
    var ancestor = node.parentElement.closest('li.nav-item');
    if (!ancestor) { break; }
    ancestor.classList.add('menu-open');
    node = ancestor;
  }
})();
</script>
</cfoutput>
