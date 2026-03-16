
<!---
Hermes Secure Email Gateway - Clear Bayes Database Action Handler
Clears the SpamAssassin Bayes learned spam/ham database.
--->

<cftry>
  <cfexecute name="/usr/local/bin/docker"
      arguments="exec hermes_mail_filter /usr/bin/sa-learn --clear"
      timeout="60" variable="bayesResult" errorVariable="bayesError" />

  <cfset session.m = 5>
  <cfset session.cmdOutput = bayesResult>

  <cfcatch type="any">
    <cfset session.m = 6>
    <cfset session.cmdOutput = cfcatch.message>
  </cfcatch>
</cftry>
<cflocation url="view_antispam_maintenance.cfm" addtoken="no">
