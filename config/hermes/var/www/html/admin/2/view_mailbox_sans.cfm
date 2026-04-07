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

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Email Server - SAN Management</title>
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
            <h1 class="m-0">Email Server - SAN Management</h1>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="index.cfm">Home</a></li>
              <li class="breadcrumb-item">Email Server</li>
              <li class="breadcrumb-item active">SAN Management</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<p>
  <a href="view_mailbox_domains.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Domains</a>
</p>

<div class="alert alert-info">
  <h5><i class="icon fas fa-info-circle"></i> Coming Soon</h5>
  <p class="mb-0">SAN prefix management will allow you to add, edit, and remove subdomain prefixes (e.g., <code>mail</code>, <code>imap</code>, <code>smtp</code>, <code>pop</code>, <code>webmail</code>) that are cross-joined with your mailbox domains to generate certificate SANs. The system prefixes <code>autoconfig</code> and <code>autodiscover</code> are required and cannot be removed.</p>
</div>

<!--- CURRENT SAN PREFIXES (read-only for now) --->
<cfquery name="getSanPrefixes" datasource="hermes">
    SELECT san FROM additional_sans ORDER BY san ASC
</cfquery>

<div class="card">
  <div class="card-header">
    <h3 class="card-title"><i class="fas fa-network-wired me-2"></i>Configured SAN Prefixes (<cfoutput>#getSanPrefixes.recordcount#</cfoutput>)</h3>
  </div>
  <div class="card-body">
    <table class="table table-bordered table-striped">
      <thead>
        <tr>
          <th>Prefix</th>
          <th>Type</th>
          <th>Example</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="getSanPrefixes">
        <tr>
          <td><code>#HTMLEditFormat(san)#</code></td>
          <td>
            <cfif san EQ "autoconfig" OR san EQ "autodiscover">
              <span class="badge bg-primary">System (Required)</span>
            <cfelse>
              <span class="badge bg-secondary">Additional</span>
            </cfif>
          </td>
          <td><code>#HTMLEditFormat(san)#.example.com</code></td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>
</html>
