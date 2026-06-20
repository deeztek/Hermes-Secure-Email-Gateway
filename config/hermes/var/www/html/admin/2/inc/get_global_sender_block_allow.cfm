<!---
Hermes Secure Email Gateway - Global Sender Rules Data Include
Queries the amavis_sender_bypass table for sender-level whitelist/blacklist entries.
--->

<!--- All active entries --->
<cfquery name="get_active_all" datasource="hermes">
  SELECT id, sender, type
  FROM amavis_sender_bypass
  WHERE applied = '1' AND action = 'NONE'
  ORDER BY sender ASC
</cfquery>
