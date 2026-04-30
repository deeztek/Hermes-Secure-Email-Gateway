<!---
SETUP DEVICES — TOKEN INVALID PAGE (#224 Phase 2c)

Rendered when get_mobileconfig.cfm rejects a token for any reason
(not found, expired, already used, wrong user). The reasons are
deliberately not differentiated in the UI — same generic page so
information about valid token lifetimes / ownership doesn't leak
to someone holding a copy of the URL.
--->

<cfheader statuscode="404">

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Setup link no longer valid</title>
  <cfinclude template="./html_head.cfm" />
</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">
  <cfinclude template="./top_navbar.cfm" />
  <cfinclude template="./main_sidebar.cfm" />

  <main class="app-main">
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0">Setup link no longer valid</h1>
          </div>
        </div>
      </div>
    </div>

    <div class="app-content">
      <div class="container-fluid">

<div class="row">
  <div class="col-md-8 col-lg-6">
    <div class="card">
      <div class="card-body">
        <div class="alert alert-warning mb-3">
          <h5 class="mb-2"><i class="icon fas fa-exclamation-triangle"></i> This setup link is no longer valid</h5>
          <p class="mb-0">Profile setup links work only once and expire after 30 minutes. This one has either already been used, expired, or doesn't belong to your account.</p>
        </div>

        <p class="mb-3">No problem &mdash; just generate a new one. Each profile takes only a few seconds to create.</p>

        <a href="setup_devices.cfm?device=apple" class="btn btn-primary">
          <i class="fas fa-redo me-1"></i> Generate a new setup profile
        </a>
        <a href="setup_devices.cfm" class="btn btn-link">Pick a different device</a>
      </div>
    </div>
  </div>
</div>

      </div>
    </div>
  </main>

  <cfinclude template="./main_footer.cfm" />
</div>
</body>
</html>
