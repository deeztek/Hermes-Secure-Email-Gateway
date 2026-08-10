
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
       keeps -create idempotent, since it fails when a config already exists.

       chown to amavis is REQUIRED and not optional. docker exec runs as root,
       so razor-admin creates the identity and the server discovery files
       root-owned, while SpamAssassin runs as amavis inside amavis. Razor does
       not merely read that directory: it refreshes servers.*.lst and the
       per-server .conf files at runtime, so amavis needs write access. Without
       this, -home=/etc/razor only moves the failure from "looking in the wrong
       place" to "looking in the right place and unable to use it", and
       registration still reports success while Razor returns nothing.

       /root/.razor is removed because every install that ran the pre-fix
       handler has a stale identity there, already registered with Cloudmark.
       Leaving it means two identities exist and the next person diagnosing
       this cannot tell which one SpamAssassin is meant to use. --->
  <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_mail_filter /bin/bash -c 'rm -rf /root/.razor && rm -f /etc/razor/identity* /etc/razor/razor-agent.conf && razor-admin -home=/etc/razor -create && razor-admin -home=/etc/razor -register && chown -R amavis:amavis /etc/razor'"
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
