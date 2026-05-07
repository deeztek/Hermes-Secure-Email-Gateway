<!---
SETUP DEVICES — APPLE BRANCH UI FRAGMENT (#224 Phase 2)

Renders the Apple device setup form: label input, display-name input,
"Generate Setup Profile" button. Form POSTs back to setup_devices.cfm
with action=generate_apple_profile, which is dispatched to
inc/setup_apple_action.cfm at the top of the page.

This fragment intentionally has NO logic beyond rendering — all the
work happens in the action handler.
--->

<cfoutput>
<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fab fa-apple"></i> Set up iPhone, iPad, or macOS</h3>
      </div>
      <div class="card-body">
        <p>This will give you a downloadable Apple <code>.mobileconfig</code> profile that configures <strong>Mail, Calendar, and Contacts</strong> in one go on the device. It uses a fresh app password created just for this device, so revoking it later cuts off only this device.</p>

        <ul class="mb-3">
          <li><strong>What gets set up:</strong> Mail (IMAP + SMTP), Calendar (CalDAV), Contacts (CardDAV)</li>
          <li><strong>What you'll need to do on the device:</strong> open the downloaded file, follow the iOS/macOS install prompts. iOS may ask for the app password during install &mdash; the profile contains it pre-filled, so you may not need to type anything.</li>
          <li><strong>If you set up the same device twice:</strong> iOS treats it as an update of the previous profile rather than a duplicate. The old app password row stays in <a href="view_app_passwords.cfm">My App Passwords</a> until you manually revoke it.</li>
        </ul>
      </div>
      <div class="card-footer">
        <!--- Form posts to the action handler which now redirects to a
             result page (Phase 2c — was a binary download in Phase 2a).
             That means we want a normal form submit / page navigation,
             NOT the hidden-iframe download pattern. The global preloader
             firing during the redirect is fine — profile generation +
             signing can take a few seconds, and the spinner gives the
             user feedback that something is happening. --->
        <form method="post" action="setup_devices.cfm?device=apple">
          <input type="hidden" name="action" value="generate_apple_profile">

          <div class="row">
            <div class="col-md-6 mb-3">
              <label class="form-label"><strong>Device label</strong> <span class="text-danger">*</span></label>
              <input type="text" class="form-control" name="label" value="iPhone" maxlength="100" required autocomplete="off">
              <small class="text-muted">A name you'll recognize for this device (e.g., "iPhone", "Sarah's iPad", "Work MacBook"). Shows up in <a href="view_app_passwords.cfm">My App Passwords</a> so you can revoke it later by name.</small>
            </div>
            <div class="col-md-6 mb-3">
              <label class="form-label"><strong>Display name</strong> <small class="text-muted">(optional)</small></label>
              <input type="text" class="form-control" name="display_name" value="" maxlength="100" autocomplete="off">
              <small class="text-muted">How the account appears inside Mail/Calendar/Contacts on the device. Defaults to your email address if left blank.</small>
            </div>
          </div>

          <button type="submit" class="btn btn-primary"><i class="fas fa-download"></i> Generate Setup Profile</button>
          <a href="setup_devices.cfm" class="btn btn-link">Cancel</a>
        </form>
      </div>
    </div>
  </div>
</div>

<div class="row">
  <div class="col-12">
    <div class="alert alert-info mb-0">
      <h6 class="mb-2"><i class="icon fas fa-info-circle"></i> Installing the profile</h6>
      <p class="mb-2">After clicking <strong>Generate Setup Profile</strong> you'll see two ways to get the file onto your Apple device. Pick whichever fits where you are:</p>
      <ul class="mb-2">
        <li><strong>Scan the QR code</strong> with the camera on the iPhone, iPad, or Mac you want to set up &mdash; quickest if the wizard is open on a different machine. The device fetches the profile directly over your network.</li>
        <li><strong>Download on this device</strong> &mdash; click the download button to save the <code>.mobileconfig</code> locally; if you ran the wizard from a desktop and need it on a phone instead, AirDrop or email the saved file across.</li>
      </ul>
      <p class="mb-1"><strong>Then on the device:</strong></p>
      <ol class="mb-0">
        <li><strong>iPhone / iPad:</strong> Settings &rarr; General &rarr; VPN &amp; Device Management &rarr; tap the profile &rarr; Install.</li>
        <li><strong>macOS:</strong> System Settings &rarr; Privacy &amp; Security &rarr; Profiles &rarr; double-click the profile &rarr; Install.</li>
        <li>If iOS prompts for a password during install, paste it from the profile note (or simply tap Skip &mdash; iOS will pull it from the profile automatically in many cases).</li>
      </ol>
    </div>
  </div>
</div>

</cfoutput>
