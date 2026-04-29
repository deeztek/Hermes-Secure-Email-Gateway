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
        <!--- Established Hermes download pattern (claude_conversation.md
             3/25/2025 entry): form targets a hidden iframe so the
             current page never navigates, plus class="no-preloader"
             so the global Hermes spinner doesn't fire on submit. The
             iframe receives the binary; the browser intercepts it as
             a download per the Content-Disposition: attachment header.
             Same pattern PGP / S/MIME / CSR downloads use. --->
        <form method="post" action="setup_devices.cfm?device=apple" target="downloadFrame" class="no-preloader">
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
      <ol class="mb-0">
        <li>Open the downloaded <code>.mobileconfig</code> file on your iPhone, iPad, or Mac (email it to yourself, AirDrop it, or download it directly on the device).</li>
        <li><strong>iPhone / iPad:</strong> Settings &rarr; General &rarr; VPN &amp; Device Management &rarr; tap the profile &rarr; Install.</li>
        <li><strong>macOS:</strong> System Settings &rarr; Privacy &amp; Security &rarr; Profiles &rarr; double-click the profile &rarr; Install.</li>
        <li>If iOS prompts for a password during install, paste it from the profile note (or simply tap Skip — iOS will pull it from the profile automatically in many cases).</li>
      </ol>
    </div>
  </div>
</div>

<!--- Hidden iframe target for the Generate Profile form. Form's
     target="downloadFrame" routes the response here so the parent
     page never navigates; browser intercepts the Content-Disposition:
     attachment as a download. Established Hermes download pattern. --->
<iframe name="downloadFrame" style="display:none;"></iframe>
</cfoutput>
