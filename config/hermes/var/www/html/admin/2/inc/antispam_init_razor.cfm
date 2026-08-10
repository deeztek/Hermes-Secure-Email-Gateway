
<!---
Hermes Secure Email Gateway - Initialize Razor Action Handler
Deletes existing identity, creates new config, and registers with Razor network.
--->

<cftry>
  <!--- -home=/etc/razor is REQUIRED and was missing (#292). Without it
       razor-admin defaults to $HOME/.razor, so registration landed in
       /root/.razor while local.cf's `razor_config /etc/razor/razor-agent.conf`
       points SpamAssassin at /etc/razor. The button reported "Register
       successful" and Razor still returned nothing, on every install.

       The legacy installer and this repo's own scripts/initialize_razor.sh both
       pass -home; only this handler was written without it. Removing
       razor-agent.conf as well as identity* matches initialize_razor.sh and
       keeps -create idempotent, since it fails when a config already exists. --->
  <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_mail_filter /bin/bash -c 'rm -f /etc/razor/identity* /etc/razor/razor-agent.conf && razor-admin -home=/etc/razor -create && razor-admin -home=/etc/razor -register'"
      timeout="30" variable="razorResult" errorVariable="razorError" />

  <cfif FindNoCase("Register successful", razorResult) OR FindNoCase("created", razorResult)>
    <cfset session.m = 13>
    <cfset session.cmdOutput = razorResult>
  <cfelse>
    <cfset session.m = 14>
    <cfset session.cmdOutput = razorResult & " " & razorError>
  </cfif>

  <cfcatch type="any">
    <cfset session.m = 14>
    <cfset session.cmdOutput = cfcatch.message>
  </cfcatch>
</cftry>
<cflocation url="view_antispam_maintenance.cfm" addtoken="no">
