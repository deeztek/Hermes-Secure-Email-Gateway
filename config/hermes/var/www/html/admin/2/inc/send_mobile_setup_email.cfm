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
SEND MOBILE SETUP EMAIL (#224 Phase 2c)

Sent by admin_resend_mobile_setup_action.cfm after the shared helper
has staged a mobile_setup_tokens row with a 30-min single-use token.
Body links to /users/2/setup_devices.cfm?device=apple-result&token=<t>
which renders the QR + download UI behind Authelia auth.

Required inputs:
  - _arsmTargetEmail : recipient email (mailbox owner)
  - _arsmTargetName  : display name for the greeting
  - _arsmResultUrl   : full URL to the result page including ?token=
--->

<cfquery name="_smseGetPostmaster" datasource="hermes">
    SELECT parameter, value FROM system_settings WHERE parameter='postmaster'
</cfquery>

<cfmail from="#_smseGetPostmaster.value#"
        to="#_arsmTargetEmail#"
        server="hermes_postfix_dkim"
        port="10026"
        subject="[Hermes SEG] Set up your mobile device"
        type="html">
<div align="center" style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
<b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>

<img src="cid:hermeslogo" alt="Hermes SEG" style="max-height: 80px; margin-bottom: 10px;"><br>
<h2 style="color: ##333;">Set up your mobile device</h2>

<p style="text-align: left;">Hello <strong>#_arsmTargetName#</strong>,</p>

<p style="text-align: left;">Your administrator has prepared a setup profile for your iPhone, iPad, or Mac. The profile configures Mail, Calendar, and Contacts in one step.</p>

<div style="background-color: ##fff8e6; border: 1px solid ##ffe09a; padding: 20px; margin: 20px 0; border-radius: 5px; text-align: left;">
    <h3 style="margin-top: 0; color: ##805500;">Click here to install</h3>
    <p style="margin: 0 0 12px 0;">Open this link on the device you want to set up &mdash; iPhone, iPad, or Mac:</p>
    <p style="margin: 0 0 12px 0; text-align: center;">
        <a href="#_arsmResultUrl#" style="display: inline-block; background-color: ##0d6efd; color: ##fff; padding: 10px 20px; border-radius: 4px; text-decoration: none; font-weight: bold;">Open setup page</a>
    </p>
    <p style="margin: 0; font-size: 13px; color: ##555;">If the button does not work, copy and paste this URL into your browser:<br>
    <code style="font-size: 12px; word-break: break-all;">#_arsmResultUrl#</code></p>
</div>

<div style="background-color: ##f0f7ff; border: 1px solid ##b8daff; padding: 15px; margin: 20px 0; border-radius: 5px; text-align: left;">
    <p style="margin: 0 0 8px 0;"><strong>Sign in once.</strong> When you open the link you'll be asked to sign in with your normal email login. After signing in, the setup page shows a QR code (for installing on a different device) and a Download button (for installing on the device you're reading this on).</p>
    <p style="margin: 0;"><strong>Pick one path.</strong> The link installs <strong>only once</strong> and expires after 30 minutes. If it expires before you get to it, just ask your administrator to send a new one.</p>
</div>

<p style="text-align: left; font-size: 13px; color: ##555;">If you have any questions, contact your administrator.</p>

<hr style="border: 0; border-top: 1px solid ##ccc; margin: 20px 0;">
<p style="font-size: 12px; color: ##888;">This message was sent automatically by Hermes Secure Email Gateway.</p>
</div>
<cfmailparam file="/var/www/html/dist/img/hermes_logo_new_orange2.png" contentid="hermeslogo" disposition="inline" />
</cfmail>
