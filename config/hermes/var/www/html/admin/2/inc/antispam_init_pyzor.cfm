
<!---
Hermes Secure Email Gateway - Initialize Pyzor Action Handler
Pings Pyzor servers to verify connectivity and service configuration.
--->

<cftry>
  <cfexecute name="/usr/local/bin/docker"
      <!--- Run as amavis, not root. SpamAssassin invokes pyzor as the amavis
           user, so that is the identity whose connectivity and home directory
           actually matter. Pinging as root tested a path nothing uses. Pyzor
           keeps no per-user state for this (it reaches public.pyzor.org from a
           built-in default), so unlike Razor there is nothing to relocate;
           this only makes the diagnostic honest. --->
      arguments="exec -u amavis hermes_mail_filter /usr/bin/pyzor ping"
      timeout="30" variable="pyzorResult" errorVariable="pyzorError" />

  <cfif FindNoCase("200", pyzorResult)>
    <cfset session.m = 11>
    <cfset session.cmdOutput = pyzorResult>
  <cfelse>
    <cfset session.m = 12>
    <cfset session.cmdOutput = pyzorResult & " " & pyzorError>
  </cfif>

  <cfcatch type="any">
    <cfset session.m = 12>
    <cfset session.cmdOutput = cfcatch.message>
  </cfcatch>
</cftry>
<cflocation url="view_antispam_maintenance.cfm" addtoken="no">
