
<!---
Hermes Secure Email Gateway - Initialize Pyzor Action Handler
Pings Pyzor servers to verify connectivity and service configuration.
--->

<cftry>
  <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_mail_filter /usr/bin/pyzor ping"
      timeout="30" variable="pyzorResult" errorVariable="pyzorError" />

  <cfif FindNoCase("200", pyzorResult)>
    <cfset session.m = 1>
    <cfset session.cmdOutput = pyzorResult>
  <cfelse>
    <cfset session.m = 2>
    <cfset session.cmdOutput = pyzorResult & " " & pyzorError>
  </cfif>

  <cfcatch type="any">
    <cfset session.m = 2>
    <cfset session.cmdOutput = cfcatch.message>
  </cfcatch>
</cftry>
<cflocation url="view_antispam_maintenance.cfm" addtoken="no">
