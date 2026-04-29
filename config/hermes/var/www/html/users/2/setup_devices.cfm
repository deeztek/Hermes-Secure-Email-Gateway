<!DOCTYPE html>

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
SET UP YOUR DEVICES (#224 Phase 2)

End-user wizard for getting mail clients (IMAP/SMTP) and DAV clients
(CalDAV/CardDAV) configured on phones, tablets, and desktops. Two-stage
flow:

  1. Pick a device + client family
  2. Get device-specific instructions (and, for Apple, a signed
     .mobileconfig that auto-configures all four protocols)

Per-device branches live in inc/setup_<device>_<client>.cfm fragments.
Action handlers in inc/setup_<device>_<client>_action.cfm. New device
support = drop in two new files; this dispatcher remains stable.

ALL paths in the wizard mint a fresh app password (one credential, four
protocols per #197 Phase 1b). Re-running the wizard for the same device
creates a new row in app_passwords; the user revokes the old one from
view_app_passwords.cfm. Per-device-per-row is the model — re-use of
existing rows is intentionally not offered.
--->

<cfparam name="url.device" default="">
<cfparam name="form.action" default="">

<!--- Action dispatch: form POSTs land here first. Handlers may serve
     binary content + cfabort, or set session.m and redirect back. --->
<cfif form.action EQ "generate_apple_profile">
    <cfinclude template="./inc/setup_apple_action.cfm">
</cfif>

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Set Up Your Devices</title>
  <cfinclude template="./inc/html_head.cfm" />
</head>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Set Up Your Devices</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <cfif url.device EQ "">
                <li class="breadcrumb-item active">Set Up Your Devices</li>
              <cfelse>
                <li class="breadcrumb-item"><a href="setup_devices.cfm">Set Up Your Devices</a></li>
                <li class="breadcrumb-item active"><cfoutput>#HTMLEditFormat(url.device)#</cfoutput></li>
              </cfif>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<cfif NOT session.theGroups CONTAINS "mailboxes">
  <div class="alert alert-warning">
    <h4><i class="icon fas fa-exclamation-triangle"></i> Not Available</h4>
    <p class="mb-0">Device setup is only available for mailbox users.</p>
  </div>
<cfelse>

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m") AND session.m IS NOT "">
  <cfset m = session.m>
  <cfset session.m = "">
</cfif>

<!--- Status alerts (errors flow back through session.m from action handlers) --->
<cfif m EQ 60>
  <cfoutput>
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      <h4><i class="icon fa fa-ban"></i> Setup failed</h4>
      <p class="mb-0">#HTMLEditFormat(StructKeyExists(session, "setupDevicesError") ? session.setupDevicesError : "An unknown error occurred. Try again or open an existing app password from My App Passwords.")#</p>
    </div>
  </cfoutput>
  <cfset session.setupDevicesError = "">
</cfif>

<!--- ===== STAGE A: device picker ===== --->
<cfif url.device EQ "">

<div class="row mb-3">
  <div class="col-12">
    <div class="alert alert-info mb-0">
      <h5 class="mb-2"><i class="icon fas fa-info-circle"></i> About this wizard</h5>
      <p class="mb-2">Pick the device or app you're setting up. The wizard will give you everything you need &mdash; a setup file for Apple devices, or step-by-step instructions with copy buttons for everything else.</p>
      <p class="mb-0"><small>Each device gets its own app password. Already have one set up and want to revoke it? <a href="view_app_passwords.cfm">My App Passwords</a>.</small></p>
    </div>
  </div>
</div>

<div class="row">

  <!-- Apple: iPhone / iPad / macOS -->
  <div class="col-md-4 col-sm-6 mb-3">
    <a href="setup_devices.cfm?device=apple" class="text-decoration-none">
      <div class="card h-100">
        <div class="card-body text-center">
          <i class="fab fa-apple fa-3x mb-3 text-body"></i>
          <h5 class="card-title">iPhone, iPad, or macOS</h5>
          <p class="card-text text-muted mb-0">Apple Mail, Calendar, and Contacts &mdash; all in one downloadable profile.</p>
        </div>
      </div>
    </a>
  </div>

  <!-- Android: DAVx5 + email client -->
  <div class="col-md-4 col-sm-6 mb-3">
    <a href="setup_devices.cfm?device=android-davx5" class="text-decoration-none">
      <div class="card h-100">
        <div class="card-body text-center">
          <i class="fab fa-android fa-3x mb-3 text-body"></i>
          <h5 class="card-title">Android (DAVx5 + email)</h5>
          <p class="card-text text-muted mb-0">Step-by-step setup for DAVx5 (Calendar/Contacts) and an Android email app.</p>
        </div>
      </div>
    </a>
  </div>

  <!-- Thunderbird (desktop) -->
  <div class="col-md-4 col-sm-6 mb-3">
    <a href="setup_devices.cfm?device=thunderbird" class="text-decoration-none">
      <div class="card h-100">
        <div class="card-body text-center">
          <i class="fas fa-envelope fa-3x mb-3 text-body"></i>
          <h5 class="card-title">Thunderbird (Windows/Mac/Linux)</h5>
          <p class="card-text text-muted mb-0">Auto-discovery handles email, calendar, and contacts in one go.</p>
        </div>
      </div>
    </a>
  </div>

  <!-- Outlook -->
  <div class="col-md-4 col-sm-6 mb-3">
    <a href="setup_devices.cfm?device=outlook" class="text-decoration-none">
      <div class="card h-100">
        <div class="card-body text-center">
          <i class="fas fa-envelope-open-text fa-3x mb-3 text-body"></i>
          <h5 class="card-title">Microsoft Outlook (Windows)</h5>
          <p class="card-text text-muted mb-0">Outlook autodiscover + CalDAV Synchronizer for calendar &amp; contacts.</p>
        </div>
      </div>
    </a>
  </div>

  <!-- Linux desktop -->
  <div class="col-md-4 col-sm-6 mb-3">
    <a href="setup_devices.cfm?device=linux" class="text-decoration-none">
      <div class="card h-100">
        <div class="card-body text-center">
          <i class="fab fa-linux fa-3x mb-3 text-body"></i>
          <h5 class="card-title">Linux desktop</h5>
          <p class="card-text text-muted mb-0">Evolution, KMail, or any other client &mdash; manual settings reference.</p>
        </div>
      </div>
    </a>
  </div>

  <!-- Other / web only -->
  <div class="col-md-4 col-sm-6 mb-3">
    <a href="setup_devices.cfm?device=webonly" class="text-decoration-none">
      <div class="card h-100">
        <div class="card-body text-center">
          <i class="fas fa-globe fa-3x mb-3 text-body"></i>
          <h5 class="card-title">Web only</h5>
          <p class="card-text text-muted mb-0">Skip client setup &mdash; use webmail at <code>/nc</code>.</p>
        </div>
      </div>
    </a>
  </div>

</div>

<!--- ===== STAGE B: device-specific page ===== --->
<cfelse>

<cfswitch expression="#url.device#">
    <cfcase value="apple">
        <cfinclude template="./inc/setup_apple_mobileconfig.cfm">
    </cfcase>
    <cfcase value="android-davx5">
        <cfinclude template="./inc/setup_android_davx5.cfm">
    </cfcase>
    <cfcase value="thunderbird">
        <cfinclude template="./inc/setup_thunderbird.cfm">
    </cfcase>
    <cfcase value="outlook">
        <cfinclude template="./inc/setup_outlook.cfm">
    </cfcase>
    <cfcase value="linux">
        <cfinclude template="./inc/setup_linux.cfm">
    </cfcase>
    <cfcase value="webonly">
        <cfinclude template="./inc/setup_webonly.cfm">
    </cfcase>
    <cfdefaultcase>
        <div class="alert alert-warning">
            <h5><i class="icon fas fa-exclamation-triangle"></i> Unknown device</h5>
            <p class="mb-0"><a href="setup_devices.cfm">Back to device picker</a></p>
        </div>
    </cfdefaultcase>
</cfswitch>

</cfif>

</cfif>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />
</div>
</body>
</html>
