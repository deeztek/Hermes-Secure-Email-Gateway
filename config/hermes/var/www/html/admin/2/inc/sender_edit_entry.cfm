<!---
Hermes Secure Email Gateway - Sender/Recipient Block/Allow Edit Entry Action Handler
Deletes the existing wblist row using a JOIN on the original sender and recipient email
addresses (not integer IDs), then inserts the updated entry.
Expects: form.edit_recipient (readonly), form.edit_original_sender (hidden, original value),
         form.edit_sender (new value), form.edit_type (BLOCK/ALLOW)
--->

<cfif StructKeyExists(form, "edit_recipient")     AND form.edit_recipient is not ""
  AND StructKeyExists(form, "edit_original_sender") AND form.edit_original_sender is not ""
  AND StructKeyExists(form, "edit_sender")          AND form.edit_sender is not ""
  AND StructKeyExists(form, "edit_type")>

  <cfset editSender         = trim(form.edit_sender)>
  <cfset editOriginalSender = trim(form.edit_original_sender)>
  <cfset editRecipient      = trim(form.edit_recipient)>
  <cfset editType           = trim(form.edit_type)>

  <!--- Validate type --->
  <cfif editType is not "BLOCK" AND editType is not "ALLOW">
    <cfset session.m = 32>
    <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
  </cfif>

  <!--- Format new sender for storage (plain domain gets @ prefix) --->
  <cfif Find("@", editSender) GT 0>
    <cfset editSenderStored = editSender>
  <cfelse>
    <cfset editSenderStored = "@" & editSender>
  </cfif>

  <!--- Format original sender the same way so the JOIN lookup is correct --->
  <cfif Find("@", editOriginalSender) GT 0>
    <cfset editOriginalSenderStored = editOriginalSender>
  <cfelse>
    <cfset editOriginalSenderStored = "@" & editOriginalSender>
  </cfif>

  <!--- Resolve or create mailaddr entry for new sender --->
  <cfquery name="checkNewSender" datasource="hermes">
    SELECT id FROM mailaddr
    WHERE email = <cfqueryparam value="#editSenderStored#" cfsqltype="cf_sql_varchar">
  </cfquery>
  <cfif checkNewSender.recordCount LT 1>
    <cfquery name="insertNewSender" datasource="hermes" result="stNewSender">
      INSERT INTO mailaddr (email)
      VALUES (<cfqueryparam value="#editSenderStored#" cfsqltype="cf_sql_varchar">)
    </cfquery>
    <cfset newSid = stNewSender.GENERATED_KEY>
  <cfelse>
    <cfset newSid = checkNewSender.id>
  </cfif>

  <cfset editWbCode = (editType is "ALLOW") ? "W" : "B">

  <!--- DELETE the existing wblist row using a JOIN on the email strings.
       This does not rely on any integer ID from the form. --->
  <cfquery datasource="hermes">
    DELETE w FROM wblist w
    JOIN recipients r ON r.id = w.rid
    JOIN mailaddr   m ON m.id = w.sid
    WHERE r.recipient = <cfqueryparam value="#editRecipient#"           cfsqltype="cf_sql_varchar">
      AND m.email     = <cfqueryparam value="#editOriginalSenderStored#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <!--- Also remove any pre-existing mapping to the new sender for this recipient
       to prevent a duplicate if the new sender email already had a rule. --->
  <cfquery datasource="hermes">
    DELETE w FROM wblist w
    JOIN recipients r ON r.id = w.rid
    WHERE r.recipient = <cfqueryparam value="#editRecipient#" cfsqltype="cf_sql_varchar">
      AND w.sid       = <cfqueryparam value="#newSid#"        cfsqltype="cf_sql_integer">
  </cfquery>

  <!--- Look up the recipient's rid for the INSERT --->
  <cfquery name="getRecipient" datasource="hermes">
    SELECT id FROM recipients
    WHERE recipient = <cfqueryparam value="#editRecipient#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfif getRecipient.recordCount LT 1>
    <cfset session.m = 34>
    <cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
  </cfif>

  <cfquery datasource="hermes">
    INSERT INTO wblist (rid, sid, wb)
    VALUES (
      <cfqueryparam value="#getRecipient.id#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#newSid#"          cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#editWbCode#"      cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <!--- Clean up orphaned mailaddr entries after the edit --->
  <cfquery datasource="hermes">
    DELETE FROM mailaddr WHERE id NOT IN (SELECT DISTINCT sid FROM wblist)
  </cfquery>

  <cfset session.m = 5>
</cfif>
<cflocation url="view_sender_recipient_block_allow.cfm" addtoken="no">
