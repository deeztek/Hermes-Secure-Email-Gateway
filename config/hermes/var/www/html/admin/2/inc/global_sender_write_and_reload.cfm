<!---
Hermes Secure Email Gateway - Global Sender Write Config and Reload Services
Writes Postfix amavis_senderbypass, Amavis white.lst/black.lst from active entries,
then runs postmap, reloads Postfix, and force-reloads Amavis.
Sets session.applySuccess = true/false.
--->

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

  <cfset session.applySuccess = true>
  <cfcatch type="any">
    <cfset session.applySuccess = false>
  </cfcatch>
</cftry>
