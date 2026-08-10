
<!---
Hermes Secure Email Gateway - Clear Bayes Database Action Handler
Clears the SpamAssassin Bayes learned spam/ham database.
--->

<cftry>
  <!--- All sa-learn calls across the admin console, the user portal and
       post_upgrade.cfm run as amavis (#292). SpamAssassin reads and writes the
       Bayes database as amavis, so training as root produced root-owned files
       in a directory amavis has to write. That survived only because local.cf
       sets bayes_file_mode 0777, which is a load-bearing accident rather than a
       design.

       Before this, the admin train handlers passed `sa-learn -u amavis` while
       the user portal passed nothing, so the same action behaved differently
       depending on who performed it. Running the process as amavis makes the
       ownership deterministic and removes the need for the flag: sa-learn
       already uses the running user's context.

       Depends on the ownership pass in post_upgrade.cfm section 1, which is why
       that runs before any migration touches the corpus. --->
  <cfexecute name="/usr/local/bin/docker"
      arguments="exec -u amavis hermes_mail_filter /usr/bin/sa-learn --clear"
      timeout="60" variable="bayesResult" errorVariable="bayesError" />

  <cfset session.m = 15>
  <cfset session.cmdOutput = bayesResult>

  <cfcatch type="any">
    <cfset session.m = 16>
    <cfset session.cmdOutput = cfcatch.message>
  </cfcatch>
</cftry>
<cflocation url="view_antispam_maintenance.cfm" addtoken="no">
