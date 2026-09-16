<!---
Hermes Secure Email Gateway - Generate postscreen_access.cidr
Writes all active postscreen_access entries to /etc/postfix/postscreen_access.cidr
and reloads Postfix so the new CIDR table takes effect immediately.
--->

<!---
  Network alias expansion (#324).

  A row with entry_type = 'alias' holds an alias NAME in `sender` rather than a
  literal address, and renders as whatever ranges that alias currently supplies.
  v_alias_ranges decides which those are. Postfix never
  sees an alias: the indirection is resolved here, so the .cidr file contains the
  same literal networks it always did.

  This is the consumer that justifies the feature. This file ships with 129
  hand-pasted Microsoft ranges that nothing keeps current.

  IPv6 is excluded because the mail containers disable it. An alias that is
  disabled or has not resolved contributes NOTHING rather than an empty line,
  which a cidr table would reject.
--->
<cfquery name="getAllPostscreenAccess" datasource="hermes">
  SELECT rendered AS sender, act AS action FROM (
    SELECT CASE WHEN p.entry_type = 'alias'
                THEN (SELECT GROUP_CONCAT(v.cidr ORDER BY v.cidr SEPARATOR ',')
                        FROM v_alias_ranges v
                       WHERE v.alias_name = p.sender)
                ELSE p.sender END AS rendered,
           p.action AS act,
           p.sender AS sort_key
      FROM postscreen_access p
     WHERE p.applied = '1' AND p.action2 = 'NONE'
  ) x
  WHERE rendered IS NOT NULL AND rendered <> ''
  ORDER BY sort_key ASC
</cfquery>

<!--- One network per line: a cidr table cannot take a comma list, so an expanded
     alias is split and each range carries the row's action. --->
<cfset fileData = "">
<cfloop query="getAllPostscreenAccess">
  <cfloop list="#getAllPostscreenAccess.sender#" index="oneNet" delimiters=",">
    <cfset fileData = fileData & Trim(oneNet) & Chr(9) & getAllPostscreenAccess.action & Chr(10)>
  </cfloop>
</cfloop>

<cffile action="write"
  file="/etc/postfix/postscreen_access.cidr"
  output="#fileData#"
  addnewline="no">

<!--- Reload Postfix to pick up the updated CIDR table --->
<cfexecute name="/usr/local/bin/docker"
  arguments="exec hermes_postfix_dkim /usr/sbin/postfix reload"
  timeout="30" />

<!--- The .cidr now reflects whatever the aliases currently mean, so this page is
     caught up. See inc/alias_stamp_applied.cfm. --->
<cfset aliasStampConsumer = "Network Block-Allow">
<cfinclude template="alias_stamp_applied.cfm">
