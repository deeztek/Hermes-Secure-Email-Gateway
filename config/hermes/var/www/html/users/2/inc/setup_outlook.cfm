<!---
SETUP DEVICES — MICROSOFT OUTLOOK (WINDOWS) (#224 Phase 2b)

Outlook for Windows path: built-in autodiscover handles IMAP/SMTP, and
the third-party CalDAV Synchronizer add-in handles Calendar/Contacts
against Nextcloud's DAV endpoint. CalDAV Synchronizer ships with a
built-in Nextcloud profile preset that auto-discovers calendars and
address books — admin/user does not have to enter per-collection URLs.

Outlook for Mac is a separate card — it does not speak CalDAV/CardDAV
at all and CalDAV Synchronizer is Windows-only.
--->

<cfquery name="getOutlookMailHost" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'console' AND parameter = 'console.host'
</cfquery>
<cfset mailHost = (getOutlookMailHost.recordcount GTE 1 AND Trim(getOutlookMailHost.value2) NEQ "") ? Trim(getOutlookMailHost.value2) : cgi.http_host>

<cfoutput>
<cfset davBaseUrl = "https://#mailHost#/nc/remote.php/dav/">

<div class="row mb-3">
  <div class="col-12">
    <a href="setup_devices.cfm" class="btn btn-link p-0 mb-2"><i class="fas fa-arrow-left"></i> Pick a different device</a>
    <div class="card">
      <div class="card-header">
        <h3 class="card-title m-0"><i class="fab fa-windows"></i> Microsoft Outlook (Windows)</h3>
      </div>
      <div class="card-body">
        <p>Outlook for Windows handles email natively via autodiscover. For Calendar and Contacts you'll install the free <strong>CalDAV Synchronizer</strong> add-in, which has a built-in Nextcloud preset that auto-discovers your calendars and address books once you point it at the server.</p>

        <ul class="mb-3">
          <li><strong>Mail (IMAP + SMTP):</strong> Outlook autodiscover (built in)</li>
          <li><strong>Calendar + Contacts (CalDAV + CardDAV):</strong> CalDAV Synchronizer add-in (free, COM add-in for Outlook 2007&ndash;365 on Windows)</li>
          <li><strong>One credential:</strong> the same app password works for all four protocols</li>
        </ul>

        <h5>Step 1 &mdash; Mint an app password for this computer</h5>
        <ol>
          <li>Open <a href="view_app_passwords.cfm">My App Passwords</a> and create one labeled for this computer (e.g. <em>Work laptop</em>).</li>
          <li><strong>Copy the plaintext shown once</strong> &mdash; you'll paste it into Outlook and CalDAV Synchronizer below.</li>
        </ol>

        <h5>Step 2 &mdash; Add your account to Outlook (mail)</h5>
        <ol>
          <li>In Outlook: <em>File &rarr; Add Account</em> (or first-run setup).</li>
          <li>Enter your full email address. Outlook will discover the IMAP and SMTP servers automatically.</li>
          <li>When prompted for a password, paste the app password from Step 1.</li>
        </ol>

        <h5>Step 3 &mdash; Install CalDAV Synchronizer (calendar + contacts)</h5>
        <ol>
          <li>Close Outlook.</li>
          <li>Download CalDAV Synchronizer from <a href="https://caldavsynchronizer.org/" target="_blank" rel="noopener">caldavsynchronizer.org</a> and run the installer.</li>
          <li>Re-open Outlook. A new <strong>CalDav Synchronizer</strong> ribbon tab will appear.</li>
          <li>Click <em>Synchronization Profiles &rarr; Add new Profile</em>.</li>
          <li>In the profile-type list, pick <strong>Nextcloud</strong>. The DAV URL field will pre-fill with the autodiscovery endpoint.</li>
          <li>Fill in the rest:
            <ul>
              <li><strong>DAV URL:</strong> <code>#davBaseUrl#</code> <em>(if not already pre-filled by the Nextcloud preset)</em></li>
              <li><strong>Username:</strong> your full email address</li>
              <li><strong>Password:</strong> the same app password from Step 1</li>
            </ul>
          </li>
          <li>Click <em>Test or discover settings</em>. You should see a list of your calendars and address books.</li>
          <li>Pick one calendar (or address book) per profile, choose the matching Outlook folder, and save. Repeat <em>Add new Profile</em> for each calendar/address book you want to sync.</li>
        </ol>

        <div class="alert alert-info mb-0">
          <h6 class="mb-1"><i class="icon fas fa-info-circle"></i> Why one profile per collection?</h6>
          <p class="mb-0">CalDAV Synchronizer maps one remote calendar (or address book) to one local Outlook folder per profile. If you have a Personal calendar plus a shared team calendar, that's two profiles. The Nextcloud preset's auto-discovery means you don't have to look up URLs &mdash; just pick from the list it returns.</p>
        </div>
      </div>
    </div>
  </div>
</div>
</cfoutput>
