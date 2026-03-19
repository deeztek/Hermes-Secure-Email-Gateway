<!DOCTYPE html>

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

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Relay Host</title>

  <cfinclude template="./inc/html_head.cfm" />

<!--- STYLE TO REMOVE UNDERLINE FROM BUTTON IN ALERT WINDOW --->
<style>
  .alert a {
    color: #fff;
    text-decoration: none;
}
</style>

</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper. Contains page content -->
  <main class="app-main">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <cfoutput>
            <h1 class="m-0">Relay Host Configuration</h1>
            </cfoutput>
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Relay Host</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
  <cfif session.m is not "">
    <cfset m = session.m>
  </cfif>
</cfif>

<cfparam name="step" default="0">

<cfparam name="action" default="">
<cfif StructKeyExists(form, "action")>
  <cfif form.action is not "">
    <cfset action = form.action>
  </cfif>
</cfif>

<!--- GET RELAY HOST SETTINGS --->
<cfinclude template="./inc/get_relay_host_settings.cfm">

<!--- SET FORM DEFAULTS FROM DATABASE VALUES --->
<cfparam name="show_relay_enabled" default="#relayhost_enabled#">
<cfif action is "save">
  <cfset show_relay_enabled = StructKeyExists(form, "relay_enabled") ? "1" : "0">
</cfif>

<cfparam name="show_relay_authenticate" default="#relayhost_authenticate#">
<cfif action is "save">
  <cfset show_relay_authenticate = StructKeyExists(form, "relay_authenticate") ? "1" : "0">
</cfif>

<cfparam name="show_relayhost" default="#relayhost_hostname#">
<cfif StructKeyExists(form, "relayhost")>
  <cfset show_relayhost = form.relayhost>
</cfif>

<cfparam name="show_relayhost_port" default="#relayhost_port#">
<cfif StructKeyExists(form, "relayhost_port")>
  <cfset show_relayhost_port = form.relayhost_port>
</cfif>

<cfparam name="show_relayhost_username" default="#relayhost_username#">
<cfif StructKeyExists(form, "relayhost_username")>
  <cfset show_relayhost_username = form.relayhost_username>
</cfif>

<cfparam name="show_relayhost_password" default="#relayhost_password#">
<cfif StructKeyExists(form, "relayhost_password")>
  <cfset show_relayhost_password = form.relayhost_password>
</cfif>

<cfparam name="show_relayhost_tls_mode" default="#relayhost_tls_mode#">
<cfif StructKeyExists(form, "relayhost_tls_mode")>
  <cfset show_relayhost_tls_mode = form.relayhost_tls_mode>
</cfif>


<!--- ACTIONS START HERE --->

<cfif action is "save">

  <!--- VALIDATION --->
  <cfif show_relay_enabled is "1">
    <!--- Relay enabled - validate required fields --->

    <!--- Validate relay host FQDN --->
    <cfif trim(form.relayhost) is "">
      <cfset session.m = 1>
      <cflocation url="view_relay_host.cfm" addtoken="no">
    </cfif>

    <!--- Validate FQDN or IP address format --->
    <cfset isValidHost = false>
    <!--- Check if it's a valid IPv4 address --->
    <cfif REFind("^([0-9]{1,3}\.){3}[0-9]{1,3}$", trim(form.relayhost))>
      <!--- Basic IPv4 format, now validate octets are 0-255 --->
      <cfset octets = ListToArray(trim(form.relayhost), ".")>
      <cfset isValidHost = true>
      <cfloop array="#octets#" index="octet">
        <cfif octet LT 0 OR octet GT 255>
          <cfset isValidHost = false>
          <cfbreak>
        </cfif>
      </cfloop>
    <!--- Check if it's a valid IPv6 address (simplified check) --->
    <cfelseif REFind("^[0-9a-fA-F:]+$", trim(form.relayhost)) AND Find(":", trim(form.relayhost))>
      <cfset isValidHost = true>
    <!--- Check if it's a valid FQDN using email trick --->
    <cfelse>
      <cfset temp_email = "bob@#trim(form.relayhost)#">
      <cfif IsValid("email", temp_email)>
        <cfset isValidHost = true>
      </cfif>
    </cfif>

    <cfif NOT isValidHost>
      <cfset session.m = 2>
      <cflocation url="view_relay_host.cfm" addtoken="no">
    </cfif>

    <!--- Validate port number --->
    <cfif trim(form.relayhost_port) is "">
      <cfset session.m = 3>
      <cflocation url="view_relay_host.cfm" addtoken="no">
    </cfif>

    <cfif NOT IsValid("integer", form.relayhost_port)>
      <cfset session.m = 4>
      <cflocation url="view_relay_host.cfm" addtoken="no">
    </cfif>

    <cfif form.relayhost_port LT 1 OR form.relayhost_port GT 65535>
      <cfset session.m = 4>
      <cflocation url="view_relay_host.cfm" addtoken="no">
    </cfif>

    <!--- If authentication required, validate username and password --->
    <cfif StructKeyExists(form, "relay_authenticate") AND form.relay_authenticate is "1">
      <cfif trim(form.relayhost_username) is "">
        <cfset session.m = 5>
        <cflocation url="view_relay_host.cfm" addtoken="no">
      </cfif>

      <cfif trim(form.relayhost_password) is "">
        <cfset session.m = 6>
        <cflocation url="view_relay_host.cfm" addtoken="no">
      </cfif>
    </cfif>

  <!--- /CFIF relay enabled --->
  </cfif>

  <!--- SAVE SETTINGS --->
  <cfinclude template="./inc/edit_relay_host_settings.cfm">

  <!--- GENERATE POSTFIX CONFIGURATION --->
  <cfinclude template="./inc/generate_postfix_configuration.cfm">

  <cfset session.m = 10>
  <cflocation url="view_relay_host.cfm" addtoken="no">

<!--- /CFIF action --->
</cfif>

<!--- ACTIONS END HERE --->


<!--- ERROR MESSAGES START HERE --->

<cfif m is "1">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Relay Host FQDN cannot be empty (Error Code: #m#)</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "2">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Relay Host must be a valid hostname (FQDN) or IP address (Error Code: #m#)</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "3">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Relay Host Port Number cannot be empty (Error Code: #m#)</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "4">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Relay Host Port Number must be a valid number between 1 and 65535 (Error Code: #m#)</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "5">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>When Relay Host Authentication is required, you must specify a Username (Error Code: #m#)</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "6">
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>When Relay Host Authentication is required, you must specify a Password (Error Code: #m#)</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<cfif m is "10">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>Relay Host settings saved and applied successfully.</cfoutput>
  </div>
  <cfset session.m = 0>
</cfif>

<!--- ERROR MESSAGES END HERE --->


<!--- INFORMATION CARD --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-info-circle"></i> Information</h3>
  </div>
  <div class="card-body">
    <p>By default, the system tries to deliver mail directly to the Internet. Depending on your configuration this may not be possible. For example, your system may be behind a firewall, or it may be connected via an ISP who does not allow outbound mail to the Internet. In those cases you need to configure the system to deliver mail via a Relay Host.</p>
  </div>
</div>


<!--- RELAY HOST CONFIGURATION FORM --->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-server"></i> Relay Host Settings</h3>
  </div>
  <div class="card-body">

    <form name="RelayHostForm" method="post" autocomplete="off">
      <input type="hidden" name="action" value="save">

      <!--- RELAY HOST ENABLED/DISABLED --->
      <div class="row mb-3">
        <div class="col-md-6">
          <div class="form-check form-switch">
            <cfoutput>
            <input class="form-check-input" type="checkbox" name="relay_enabled" id="relay_enabled" value="1"
              <cfif show_relay_enabled is "1">checked</cfif> onchange="toggleRelayFields()">
            <label class="form-check-label" for="relay_enabled"><strong>Enable Relay Host</strong></label>
            </cfoutput>
          </div>
          <small class="text-muted ms-4">Route outbound mail through a relay host instead of delivering directly to the Internet</small>
        </div>
      </div>

      <hr>

      <!--- RELAY HOST AUTHENTICATION --->
      <div id="authSection" class="row mb-3" <cfif show_relay_enabled is "0">style="display:none;"</cfif>>
        <div class="col-md-6">
          <div class="form-check form-switch">
            <cfoutput>
            <input class="form-check-input" type="checkbox" name="relay_authenticate" id="relay_authenticate" value="1"
              <cfif show_relay_authenticate is "1">checked</cfif> <cfif show_relay_enabled is "0">disabled</cfif> onchange="toggleAuthFields()">
            <label class="form-check-label" for="relay_authenticate"><strong>Relay Host Requires Authentication</strong></label>
            </cfoutput>
          </div>
          <small class="text-muted ms-4">Enable if the relay host requires a username and password</small>
        </div>
      </div>

      <hr id="authHr" <cfif show_relay_enabled is "0">style="display:none;"</cfif>>

      <!--- RELAY HOST DETAILS --->
      <div id="relayFields" <cfif show_relay_enabled is "0">style="display:none;"</cfif>>

        <!--- RELAY HOST ADDRESS --->
        <div class="row mb-3">
          <div class="col-md-6">
            <label for="relayhost" class="form-label"><strong>Relay Host Address</strong></label>
            <cfoutput>
            <input type="text" class="form-control" id="relayhost" name="relayhost" value="#show_relayhost#" maxlength="255" placeholder="e.g., smtp.example.com or 192.168.1.100" <cfif show_relay_enabled is "0">disabled</cfif>>
            </cfoutput>
            <small class="text-muted">Enter the hostname (FQDN) or IP address of your relay host</small>
          </div>
        </div>

        <!--- RELAY HOST PORT --->
        <div class="row mb-3">
          <div class="col-md-3">
            <label for="relayhost_port" class="form-label"><strong>Relay Host Port</strong></label>
            <cfoutput>
            <input type="number" class="form-control" id="relayhost_port" name="relayhost_port" value="#show_relayhost_port#" min="1" max="65535" <cfif show_relay_enabled is "0">disabled</cfif>>
            </cfoutput>
            <small class="text-muted">Default is 25. Common ports: 25, 465, 587</small>
          </div>
        </div>

        <!--- RELAY HOST TLS MODE --->
        <div class="row mb-3">
          <div class="col-md-4">
            <label for="relayhost_tls_mode" class="form-label"><strong>Outbound TLS Mode</strong></label>
            <cfoutput>
            <select class="form-select" id="relayhost_tls_mode" name="relayhost_tls_mode" <cfif show_relay_enabled is "0">disabled</cfif>>
              <option value="" <cfif show_relayhost_tls_mode is "">selected</cfif>>Disabled - No TLS</option>
              <option value="may" <cfif show_relayhost_tls_mode is "may">selected</cfif>>Opportunistic TLS (Recommended)</option>
              <option value="encrypt" <cfif show_relayhost_tls_mode is "encrypt">selected</cfif>>Mandatory TLS</option>
            </select>
            </cfoutput>
            <small class="text-muted">TLS encryption when connecting to relay host. Use Opportunistic for port 587 with STARTTLS.</small>
          </div>
        </div>

        <!--- AUTHENTICATION FIELDS --->
        <div id="authFields" <cfif show_relay_authenticate is "0">style="display:none;"</cfif>>

          <!--- USERNAME --->
          <div class="row mb-3">
            <div class="col-md-6">
              <label for="relayhost_username" class="form-label"><strong>Relay Host Username</strong></label>
              <cfoutput>
              <input type="text" class="form-control" id="relayhost_username" name="relayhost_username" value="#show_relayhost_username#" maxlength="255" placeholder="Enter username" <cfif show_relay_enabled is "0" OR show_relay_authenticate is "0">disabled</cfif>>
              </cfoutput>
            </div>
          </div>

          <!--- PASSWORD --->
          <div class="row mb-3">
            <div class="col-md-6">
              <label for="relayhost_password" class="form-label"><strong>Relay Host Password</strong></label>
              <div class="input-group">
                <cfoutput>
                <input type="password" class="form-control" id="relayhost_password" name="relayhost_password" value="#show_relayhost_password#" maxlength="255" placeholder="Enter password" <cfif show_relay_enabled is "0" OR show_relay_authenticate is "0">disabled</cfif>>
                </cfoutput>
                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword()">
                  <i class="fas fa-eye" id="toggleIcon"></i>
                </button>
              </div>
            </div>
          </div>

        </div>
        <!--- /authFields --->

      </div>
      <!--- /relayFields --->

      <hr>

      <!--- SUBMIT BUTTON --->
      <div class="row">
        <div class="col-md-12">
          <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Saving...';this.form.submit();">
            <i class="fas fa-save"></i> Save Settings
          </button>
        </div>
      </div>

    </form>

  </div>
  <!--- /card-body --->
</div>
<!--- /card --->


      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->

</div>
</body>

<!--- JAVASCRIPT FOR FORM TOGGLE --->
<script>
function toggleRelayFields() {
  var relayEnabled = document.getElementById('relay_enabled').checked;
  var relayFields = document.getElementById('relayFields');
  var authSection = document.getElementById('authSection');
  var authHr = document.getElementById('authHr');
  var authToggle = document.getElementById('relay_authenticate');

  if (relayEnabled) {
    relayFields.style.display = 'block';
    authSection.style.display = 'block';
    authHr.style.display = 'block';
    document.getElementById('relayhost').disabled = false;
    document.getElementById('relayhost_port').disabled = false;
    document.getElementById('relayhost_tls_mode').disabled = false;
    authToggle.disabled = false;
    toggleAuthFields();
  } else {
    relayFields.style.display = 'none';
    authSection.style.display = 'none';
    authHr.style.display = 'none';
    document.getElementById('relayhost').disabled = true;
    document.getElementById('relayhost_port').disabled = true;
    document.getElementById('relayhost_tls_mode').disabled = true;
    authToggle.disabled = true;
    document.getElementById('relayhost_username').disabled = true;
    document.getElementById('relayhost_password').disabled = true;
  }
}

function toggleAuthFields() {
  var authRequired = document.getElementById('relay_authenticate').checked;
  var authFields = document.getElementById('authFields');

  if (authRequired) {
    authFields.style.display = 'block';
    document.getElementById('relayhost_username').disabled = false;
    document.getElementById('relayhost_password').disabled = false;
  } else {
    authFields.style.display = 'none';
    document.getElementById('relayhost_username').disabled = true;
    document.getElementById('relayhost_password').disabled = true;
  }
}

function togglePassword() {
  var passwordField = document.getElementById('relayhost_password');
  var toggleIcon = document.getElementById('toggleIcon');

  if (passwordField.type === 'password') {
    passwordField.type = 'text';
    toggleIcon.classList.remove('fa-eye');
    toggleIcon.classList.add('fa-eye-slash');
  } else {
    passwordField.type = 'password';
    toggleIcon.classList.remove('fa-eye-slash');
    toggleIcon.classList.add('fa-eye');
  }
}
</script>

</html>
