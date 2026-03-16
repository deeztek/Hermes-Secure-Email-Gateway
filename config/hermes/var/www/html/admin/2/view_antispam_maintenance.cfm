<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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
  <title>Hermes SEG | Anti-Spam Maintenance</title>

  <cfinclude template="./inc/html_head.cfm" />

</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper -->
  <main class="app-main">
    <!-- Content Header -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Anti-Spam Maintenance</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Anti-Spam Maintenance</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

<cfparam name="m" default="0">
<cfif StructKeyExists(session, "m")>
  <cfif session.m is not "">
    <cfset m = session.m>
  </cfif>
</cfif>

<cfparam name="action" default="">
<cfif StructKeyExists(form, "action")>
  <cfif form.action is not "">
    <cfset action = form.action>
  </cfif>
</cfif>

<!--- ===================== --->
<!--- ACTION HANDLERS --->
<!--- ===================== --->
<cfif action is "init_pyzor">
  <cfinclude template="./inc/antispam_init_pyzor.cfm">
<cfelseif action is "init_razor">
  <cfinclude template="./inc/antispam_init_razor.cfm">
<cfelseif action is "clear_bayes">
  <cfinclude template="./inc/antispam_clear_bayes.cfm">
</cfif>

<!--- Clear session message after reading --->
<cfset session.m = "">

<!--- ===================== --->
<!--- DISPLAY ALERT MESSAGES --->
<!--- ===================== --->

<cfif m is 1>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Pyzor Initialized Successfully</h4>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput is not "">
      <pre class="mt-2 mb-0"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
</cfif>

<cfif m is 2>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Pyzor Initialization Failed</h4>
    <p>An error occurred while initializing Pyzor.</p>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput is not "">
      <pre class="mt-2 mb-0"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
</cfif>

<cfif m is 3>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Razor Initialized Successfully</h4>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput is not "">
      <pre class="mt-2 mb-0"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
</cfif>

<cfif m is 4>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Razor Initialization Failed</h4>
    <p>An error occurred while initializing Razor.</p>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput is not "">
      <pre class="mt-2 mb-0"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
</cfif>

<cfif m is 5>
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-check"></i> Bayes Database Cleared Successfully</h4>
    <p>SpamAssassin Bayes database has been cleared. The system will need to relearn spam and ham patterns.</p>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput is not "">
      <pre class="mt-2 mb-0"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
</cfif>

<cfif m is 6>
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true"></button>
    <h4><i class="icon fa fa-ban"></i> Failed to Clear Bayes Database</h4>
    <cfif StructKeyExists(session, "cmdOutput") AND session.cmdOutput is not "">
      <pre class="mt-2 mb-0"><code><cfoutput>#encodeForHTML(session.cmdOutput)#</cfoutput></code></pre>
      <cfset session.cmdOutput = "">
    </cfif>
  </div>
</cfif>


<!-- ===================== -->
<!-- CARD 1: PYZOR -->
<!-- ===================== -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-network-wired"></i> Initialize Pyzor</h3>
  </div>
  <div class="card-body">
    <p>Pyzor is a collaborative spam detection network. It uses digest-based message identification
       to detect spam by checking message fingerprints against a distributed database of known spam messages.</p>
    <p>Initializing Pyzor will ping the Pyzor servers to verify connectivity and ensure the service
       is properly configured.</p>
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="init_pyzor">
      <button type="submit" class="btn btn-primary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Initializing...';this.form.submit();">
        <i class="fas fa-play-circle"></i> Initialize Pyzor
      </button>
    </form>
  </div>
</div>

<!-- ===================== -->
<!-- CARD 2: RAZOR -->
<!-- ===================== -->
<div class="card card-primary card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-cut"></i> Initialize Razor</h3>
  </div>
  <div class="card-body">
    <p>Vipul's Razor is a distributed, collaborative spam detection and filtering network.
       It uses statistical and randomized signatures to identify spam content.</p>
    <p>Initializing Razor will delete the existing identity, create a new configuration,
       and register with the Razor network servers.</p>
    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="init_razor">
      <button type="submit" class="btn btn-primary"
        onclick="this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Initializing...';this.form.submit();">
        <i class="fas fa-play-circle"></i> Initialize Razor
      </button>
    </form>
  </div>
</div>

<!-- ===================== -->
<!-- CARD 3: CLEAR BAYES -->
<!-- ===================== -->
<div class="card card-warning card-outline mb-4">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-database"></i> Clear Bayes Database</h3>
  </div>
  <div class="card-body">
    <p>The Bayes database stores learned spam and ham (non-spam) patterns used by SpamAssassin
       to classify messages. Over time, this database may become corrupted or contain outdated
       patterns that reduce accuracy.</p>

    <div class="alert alert-warning mb-3">
      <i class="fas fa-exclamation-triangle"></i>
      <strong>Warning:</strong> This will delete ALL learned spam and ham data.
      SpamAssassin will need to relearn patterns from scratch, which may temporarily
      reduce spam detection accuracy.
    </div>

    <form method="post" autocomplete="off">
      <input type="hidden" name="action" value="clear_bayes">
      <button type="submit" class="btn btn-danger"
        onclick="if(!confirm('Are you sure you want to clear the Bayes database? This action cannot be undone.')){return false;}this.disabled=true;this.innerHTML='<i class=\'fas fa-spinner fa-spin\'></i> Clearing...';this.form.submit();">
        <i class="fas fa-trash"></i> Clear Bayes Database
      </button>
    </form>
  </div>
</div>


      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </main>
  <!-- /.content-wrapper -->

  <cfinclude template="./inc/main_footer.cfm" />

</div>
<!-- ./wrapper -->

</body>
</html>
