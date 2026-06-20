<!---
Hermes Secure Email Gateway - Get Domain JSON
Returns domain data as JSON for edit modal AJAX call.
Expects: form.id (domain ID)
--->
<cfsetting showdebugoutput="false">
<cfcontent type="application/json">

<cfif NOT StructKeyExists(form, "id") OR NOT isValid("integer", form.id)>
  <cfoutput>{"error":"Invalid domain ID"}</cfoutput>
  <cfabort>
</cfif>

<cfquery name="getDomain" datasource="hermes">
  SELECT d.id, d.domain, d.transport_id, d.senders_id, d.recipients_id,
    t.destination, t.port, t.mx, t.method, t.authentication,
    t.authentication_username, t.authentication_password,
    r.status AS recipient_status
  FROM domains d
  LEFT JOIN transport t ON t.id = d.transport_id
  LEFT JOIN recipients r ON r.id = d.recipients_id
  WHERE d.id = <cfqueryparam value="#form.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getDomain.recordcount LT 1>
  <cfoutput>{"error":"Domain not found"}</cfoutput>
  <cfabort>
</cfif>

<!--- Decrypt username if present --->
<cfset decryptedUsername = "">
<cfset maskedPassword = "">
<cfset hasPassword = false>
<cfif getDomain.authentication_username is not "">
  <cftry>
    <cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">
    <cfset decryptedUsername = decrypt(getDomain.authentication_username, hermeskey, "AES", "Base64")>
    <cfif getDomain.authentication_password is not "">
      <cfset decryptedPassword = decrypt(getDomain.authentication_password, hermeskey, "AES", "Base64")>
      <cfset hasPassword = true>
      <!--- Show first 4 chars, mask the rest --->
      <cfif Len(decryptedPassword) GT 4>
        <cfset maskedPassword = Left(decryptedPassword, 4) & RepeatString("*", Len(decryptedPassword) - 4)>
      <cfelse>
        <cfset maskedPassword = RepeatString("*", Len(decryptedPassword))>
      </cfif>
    </cfif>
    <cfcatch type="any">
      <cfset decryptedUsername = "">
      <cfset maskedPassword = "">
    </cfcatch>
  </cftry>
</cfif>

<!--- Check if domain has TLS policy --->
<cfquery name="checkTls" datasource="hermes">
  SELECT id FROM tls_policies WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getDomain.domain#">
</cfquery>

<cfset result = {
  "id": getDomain.id,
  "domain": getDomain.domain,
  "method": getDomain.method,
  "destination": getDomain.destination,
  "port": getDomain.port,
  "mx": getDomain.mx,
  "authentication": getDomain.authentication,
  "username": decryptedUsername,
  "masked_password": maskedPassword,
  "has_password": hasPassword,
  "recipient_status": getDomain.recipient_status,
  "tls_enforced": (checkTls.recordcount GT 0)
}>
<cfoutput>#serializeJSON(result)#</cfoutput>
