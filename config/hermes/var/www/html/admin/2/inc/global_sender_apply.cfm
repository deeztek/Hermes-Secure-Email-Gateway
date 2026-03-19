<!---
Hermes Secure Email Gateway - Global Sender Block/Allow Apply Settings Handler
Commits all pending changes: deletes staged-for-deletion entries, marks the rest as applied,
then writes Postfix amavis_senderbypass and Amavis white.lst/black.lst config files and reloads services.
--->

<!--- Commit pending deletions --->
<cfquery datasource="hermes">
  DELETE FROM amavis_sender_bypass WHERE action = 'delete' AND applied = '2'
</cfquery>

<!--- Mark all remaining staged entries as applied --->
<cfquery datasource="hermes">
  UPDATE amavis_sender_bypass SET action = 'NONE', applied = '1' WHERE applied = '2'
</cfquery>

<cftry>
  <!--- Get all allow entries --->
  <cfquery name="getAllow" datasource="hermes">
    SELECT sender, transport FROM amavis_sender_bypass
    WHERE type = 'allow' AND applied = '1' AND action = 'NONE'
    ORDER BY sender ASC
  </cfquery>

  <!--- Get all block entries --->
  <cfquery name="getBlock" datasource="hermes">
    SELECT sender FROM amavis_sender_bypass
    WHERE type = 'block' AND applied = '1' AND action = 'NONE'
    ORDER BY sender ASC
  </cfquery>

  <!--- Build Postfix amavis_senderbypass content (allow entries with transport) --->
  <cfset FileDataAllowPostfix = "">
  <cfloop query="getAllow">
    <cfset FileDataAllowPostfix = FileDataAllowPostfix & getAllow.sender & Chr(32) & getAllow.transport & Chr(13) & Chr(10)>
  </cfloop>

  <!--- Write amavis_senderbypass file for Postfix --->
  <cffile action="write" file="/etc/postfix/amavis_senderbypass" output="#FileDataAllowPostfix#" addnewline="no">

  <!--- Build Amavis whitelist --->
  <cfset FileDataAllowAmavis = "">
  <cfloop query="getAllow">
    <cfset FileDataAllowAmavis = FileDataAllowAmavis & getAllow.sender & Chr(10)>
  </cfloop>

  <!--- Write white.lst for Amavis --->
  <cffile action="write" file="/etc/amavis/white.lst" output="#FileDataAllowAmavis##Chr(10)#" addnewline="no">

  <!--- Build Amavis blacklist --->
  <cfset FileDataBlockAmavis = "">
  <cfloop query="getBlock">
    <cfset FileDataBlockAmavis = FileDataBlockAmavis & getBlock.sender & Chr(10)>
  </cfloop>

  <!--- Write black.lst for Amavis --->
  <cffile action="write" file="/etc/amavis/black.lst" output="#FileDataBlockAmavis##Chr(10)#" addnewline="no">

  <!--- Postmap the amavis_senderbypass file via Docker exec --->
  <cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_postfix_dkim /usr/sbin/postmap /etc/postfix/amavis_senderbypass"
    timeout="60" />

  <!--- Set ownership for Postfix --->
  <cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_postfix_dkim chown root:root /etc/postfix/amavis_senderbypass"
    timeout="60" />
  <cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_postfix_dkim chown root:root /etc/postfix/amavis_senderbypass.db"
    timeout="60" />

  <!--- Reload Postfix via Docker --->
  <cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_postfix_dkim /usr/sbin/postfix reload"
    timeout="60" />

  <!--- Reload Amavis via Docker --->
  <cfexecute name="/usr/local/bin/docker"
    arguments="exec hermes_mail_filter /etc/init.d/amavis force-reload"
    timeout="60" />

  <cfset session.m = 3>
  <cfcatch type="any">
    <cfset session.m = 4>
  </cfcatch>
</cftry>
<cflocation url="view_global_sender_block_allow.cfm" addtoken="no">
