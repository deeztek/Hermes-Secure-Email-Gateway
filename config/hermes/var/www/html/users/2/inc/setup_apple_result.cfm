<!---
SETUP DEVICES — APPLE RESULT PAGE (#224 Phase 2c)

Rendered after setup_apple_action.cfm has minted an app password,
generated+signed the .mobileconfig, stored the bytes in
mobile_setup_tokens with a fresh 64-char hex token, and redirected
here with ?token=<t>.

Two install paths shown side-by-side, both pointed at the same
single-use token URL:

  1. QR — for installing on a different device. Phone scans, hits
     get_mobileconfig.cfm via Authelia auth, gets the file.
  2. "Download on this device" button — for installing on the
     desktop the wizard was run from.

Single-use means the user picks one or the other. We make that
explicit in the UI so they don't burn the token on a download and
then wonder why the QR scan errors.

QR is rendered client-side via qrcode-generator (Kazuhiko Arase, MIT,
~17KB) loaded from jsdelivr — same CDN that already serves jQuery,
Bootstrap, and Tom Select on this portal. SVG output, scaled
responsively, no canvas / image export step.
--->

<cfparam name="url.token" default="">

<cfset _resToken = Trim(url.token)>

<!--- Same format gate as get_mobileconfig.cfm — fail closed on
     anything that's not 64-char lowercase hex. --->
<cfif Len(_resToken) NEQ 64 OR REFind("^[a-f0-9]{64}$", _resToken) EQ 0>
    <cfset _resInvalid = true>
<cfelse>
    <cfquery name="_resTok" datasource="hermes">
        SELECT user_email, expires_at, used_at
        FROM mobile_setup_tokens
        WHERE token = <cfqueryparam value="#_resToken#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif _resTok.recordcount NEQ 1
       OR _resTok.user_email NEQ session.email
       OR IsDate(_resTok.used_at)
       OR DateCompare(Now(), _resTok.expires_at) GT 0>
        <cfset _resInvalid = true>
    <cfelse>
        <cfset _resInvalid = false>
    </cfif>
</cfif>

<cfif _resInvalid>
    <cfoutput>
    <div class="row mb-3">
      <div class="col-12">
        <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
        <div class="card">
          <div class="card-body">
            <div class="alert alert-warning mb-3">
              <h5 class="mb-1"><i class="icon fas fa-exclamation-triangle"></i> This setup link is no longer valid</h5>
              <p class="mb-0">Profile setup links work only once and expire after 30 minutes. Generate a new one to continue.</p>
            </div>
            <a href="setup_devices.cfm?device=apple" class="btn btn-primary"><i class="fas fa-redo me-1"></i> Generate a new setup profile</a>
          </div>
        </div>
      </div>
    </div>
    </cfoutput>
    <cfexit>
</cfif>

<!--- Build the canonical download URL. Use parameters2.console.host
     so the QR works even if the user accessed the portal on an
     alternate hostname. The phone needs DNS+TLS that resolves to
     the canonical name. --->
<cfquery name="_resHost" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'console' AND parameter = 'console.host'
</cfquery>
<cfset _resMailHost = (_resHost.recordcount GTE 1 AND Trim(_resHost.value2) NEQ "") ? Trim(_resHost.value2) : cgi.http_host>
<cfset _resDownloadUrl = "https://#_resMailHost#/users/2/get_mobileconfig.cfm?token=#_resToken#">

<!--- Compute minutes remaining for the "expires in X minutes" hint. --->
<cfset _resMinutesLeft = Max(1, Int(DateDiff("n", Now(), _resTok.expires_at)))>

<cfoutput>
<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fab fa-apple"></i> Setup profile is ready</h3>
      </div>
      <div class="card-body">
        <p class="mb-3">Your <code>.mobileconfig</code> profile has been generated and is waiting for you.</p>

        <div class="alert alert-warning border-warning border-2 mb-4">
          <h5 class="mb-1"><i class="icon fas fa-exclamation-triangle"></i> Pick ONE install path below</h5>
          <p class="mb-0">The link below installs <strong>only once</strong>. Use either the QR code (for installing on a different device) <strong>OR</strong> the Download button (for this device) &mdash; not both. If you need to install on more than one device, generate a fresh profile for each.</p>
        </div>

        <div class="row g-3">
          <!-- Path A: QR for another device -->
          <div class="col-md-6">
            <div class="card h-100 border-primary">
              <div class="card-body text-center">
                <h5 class="card-title"><i class="fas fa-mobile-alt me-1"></i> Scan with your phone or iPad</h5>
                <p class="text-muted small mb-3">If you ran this wizard on a desktop, scan the QR with the device you want to install on.</p>
                <div id="hermesQr" style="display: inline-block; padding: 12px; background: ##fff; border: 1px solid ##dee2e6; border-radius: 6px;"></div>
                <p class="text-muted small mt-3 mb-0">After scanning you'll be asked to sign in (same email and password as this portal). Once signed in, the profile downloads automatically and iOS/macOS will prompt you to install it.</p>
              </div>
            </div>
          </div>

          <!-- Path B: download here -->
          <div class="col-md-6">
            <div class="card h-100">
              <div class="card-body text-center">
                <h5 class="card-title"><i class="fas fa-download me-1"></i> Install on this device</h5>
                <p class="text-muted small mb-3">If you're already on the iPhone, iPad, or Mac you want to install on, just download the profile directly.</p>
                <a href="#_resDownloadUrl#" class="btn btn-primary"><i class="fas fa-download me-1"></i> Download profile</a>
                <p class="text-muted small mt-3 mb-0">After download, iOS asks you to install via Settings. macOS asks via System Settings &rarr; Profiles.</p>
              </div>
            </div>
          </div>
        </div>

        <div class="alert alert-info mt-4 mb-0">
          <h6 class="mb-1"><i class="icon fas fa-clock"></i> Expires in #_resMinutesLeft# minute<cfif _resMinutesLeft NEQ 1>s</cfif></h6>
          <p class="mb-0">If you accidentally use the link on the wrong device, miss the install prompt, or close the page, just <a href="setup_devices.cfm?device=apple" class="alert-link">generate a new profile</a>.</p>
        </div>
      </div>
    </div>
  </div>
</div>

<!--- qrcode-generator (Kazuhiko Arase, MIT). Tiny, single-file, SVG
     output. Pinned version on jsdelivr — same CDN already used for
     jQuery / Bootstrap / Tom Select / etc. on this portal. --->
<script src="https://cdn.jsdelivr.net/npm/qrcode-generator@1.4.4/qrcode.min.js"></script>
<script>
  (function() {
    var url = "#JSStringFormat(_resDownloadUrl)#";
    // Type 0 = auto-fit version. Error correction 'M' = medium (15%);
    // 'L' would be ~7%. M gives good resilience for camera scans.
    var qr = qrcode(0, 'M');
    qr.addData(url);
    qr.make();
    // Module size 6 -> ~250px QR for typical token URLs. SVG so
    // it scales cleanly if the user zooms.
    document.getElementById('hermesQr').innerHTML = qr.createSvgTag({ cellSize: 6, margin: 2 });
  })();
</script>
</cfoutput>
