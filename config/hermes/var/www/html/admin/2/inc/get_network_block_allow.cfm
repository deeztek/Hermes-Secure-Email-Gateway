<!---
Hermes Secure Email Gateway - Network Block/Allow Data Include
Queries the postscreen_access table for active IP/network overrides.
--->

<cfquery name="get_active_all" datasource="hermes">
  SELECT id, sender, action, note
  FROM postscreen_access
  WHERE applied = '1' AND action2 = 'NONE'
  ORDER BY sender ASC
</cfquery>
