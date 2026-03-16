
<!---
Hermes Secure Email Gateway - Initialize Razor Action Handler
Deletes existing identity, creates new config, and registers with Razor network.
--->

<cftry>
  <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_mail_filter /bin/bash -c 'rm -f /etc/razor/identity && razor-admin -create && razor-admin -register'"
      timeout="30" variable="razorResult" errorVariable="razorError" />

  <cfif FindNoCase("Register successful", razorResult) OR FindNoCase("created", razorResult)>
    <cfset session.m = 3>
    <cfset session.cmdOutput = razorResult>
  <cfelse>
    <cfset session.m = 4>
    <cfset session.cmdOutput = razorResult & " " & razorError>
  </cfif>

  <cfcatch type="any">
    <cfset session.m = 4>
    <cfset session.cmdOutput = cfcatch.message>
  </cfcatch>
</cftry>
<cflocation url="view_antispam_maintenance.cfm" addtoken="no">
