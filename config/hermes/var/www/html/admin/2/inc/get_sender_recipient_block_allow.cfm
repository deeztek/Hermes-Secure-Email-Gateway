<!---
Hermes Secure Email Gateway - Sender/Recipient Block/Allow Data Include
Queries wblist joined with mailaddr and recipients for all active entries
(both admin-managed and user-trained entries).
--->

<cfquery name="get_active_all" datasource="hermes">
  SELECT w.rid, w.sid, w.wb,
         m.email AS sender,
         r.recipient AS receiver
  FROM wblist w
  JOIN mailaddr m ON m.id = w.sid
  JOIN recipients r ON r.id = w.rid
  ORDER BY m.email ASC
</cfquery>
