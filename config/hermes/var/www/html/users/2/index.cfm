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
  <title>Hermes SEG | Welcome</title>

  <cfinclude template="./inc/html_head.cfm" />
 

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
            <h1 class="m-0">Welcome #session.theName#!</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Home</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

        <!--- QUICK LINKS CARD --->
        <div class="card card-outline card-primary mb-4">
            <div class="card-header">
                <h3 class="card-title"><i class="fas fa-th-large me-2"></i>Quick Links</h3>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4 col-sm-6 mb-3">
                        <a href="view_sender_filters.cfm" class="btn btn-outline-primary btn-block w-100">
                            <i class="fas fa-filter me-2"></i>Sender Filters
                        </a>
                    </div>
                    <div class="col-md-4 col-sm-6 mb-3">
                        <a href="report_settings.cfm" class="btn btn-outline-primary btn-block w-100">
                            <i class="fas fa-bell me-2"></i>Notification Settings
                        </a>
                    </div>
                    <div class="col-md-4 col-sm-6 mb-3">
                        <a href="user_settings.cfm" class="btn btn-outline-primary btn-block w-100">
                            <i class="fas fa-cog me-2"></i>Account Settings
                        </a>
                    </div>
                    <div class="col-md-4 col-sm-6 mb-3">
                        <a href="view_message_history.cfm" class="btn btn-outline-primary btn-block w-100">
                            <i class="fas fa-history me-2"></i>Message History
                        </a>
                    </div>
                </div>
            </div>
        </div>

      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</body>


</html>
