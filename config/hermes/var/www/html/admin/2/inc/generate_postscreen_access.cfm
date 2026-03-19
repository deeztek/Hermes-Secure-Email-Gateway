<!---
Hermes Secure Email Gateway - Generate postscreen_access.cidr
Writes all active postscreen_access entries to /etc/postfix/postscreen_access.cidr
and reloads Postfix so the new CIDR table takes effect immediately.
--->

<cfquery name="getAllPostscreenAccess" datasource="hermes">
  SELECT sender, action
  FROM postscreen_access
  WHERE applied = '1' AND action2 = 'NONE'
  ORDER BY sender ASC
</cfquery>

<cfset fileData = "">
<cfloop query="getAllPostscreenAccess">
  <cfset fileData = fileData & getAllPostscreenAccess.sender & Chr(9) & getAllPostscreenAccess.action & Chr(10)>
</cfloop>

<cffile action="write"
  file="/etc/postfix/postscreen_access.cidr"
  output="#fileData#"
  addnewline="no">

<!--- Reload Postfix to pick up the updated CIDR table --->
<cfexecute name="/usr/local/bin/docker"
  arguments="exec hermes_postfix_dkim /usr/sbin/postfix reload"
  timeout="30" />
