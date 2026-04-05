<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

Mailbox Domain Add Action Handler (Email Server > Domains).

Flow:
  1. Validate domain name + cert mode
  2. Check domain does not already exist in domains table
  3. cert_mode='auto' (Pro only):
       - Insert placeholder Acme cert into system_certificates
       - Use that cert id for the mailbox_domain
     cert_mode='existing':
       - Use the selected cert id
  4. Insert transport row (lmtp:[hermes_dovecot]:24)
  5. Insert senders row
  6. Insert recipients row
  7. Insert domains row with type='mailbox'
  8. Insert mailbox_domains row with extended metadata
  9. Sync mailbox_sans (adds mail./autodiscover./autoconfig. SANs)
 10. Regenerate Postfix + Nginx configs
 11. Redirect with success message

Expects:
  form.domain_name, form.cert_mode ('auto'|'existing'), form.cert_id,
  form.default_quota_mb, form.catchall_mailbox, form.nextcloud_enabled
--->

<cfset isPro = isDefined("session.edition") AND session.edition EQ "Pro">

<!--- Validate domain name --->
<cfif NOT StructKeyExists(form, "domain_name") OR trim(form.domain_name) is "">
  <cfset session.m = 10>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>

<cfset domain_name = LCase(trim(form.domain_name))>

<cfset tempemail = "bob@#domain_name#">
<cfif NOT IsValid("email", tempemail)>
  <cfset session.m = 11>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>

<!--- Check domain doesn't already exist in domains (relay OR mailbox).
     mailbox_domains is allowed to have a pre-existing row (cert SAN
     binding from prior ACME work) — we'll UPSERT that row. --->
<cfquery name="checkexists" datasource="hermes">
  SELECT id FROM domains WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">
</cfquery>
<cfif checkexists.recordcount GTE 1>
  <cfset session.m = 12>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>
<cfquery name="checkmbxexists" datasource="hermes">
  SELECT id FROM mailbox_domains WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">
</cfquery>

<!--- Validate cert mode --->
<cfparam name="form.cert_mode" default="existing">
<cfif NOT ListFindNoCase("auto,existing", form.cert_mode)>
  <cfset session.m = 20>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>

<!--- Enforce Pro edition for Auto mode --->
<cfif form.cert_mode IS "auto" AND NOT isPro>
  <cfset session.m = 14>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>

<!--- Validate cert_id for existing mode --->
<cfparam name="form.cert_id" default="">
<cfif form.cert_mode IS "existing">
  <cfif NOT IsNumeric(form.cert_id) OR form.cert_id LTE 0>
    <cfset session.m = 13>
    <cflocation url="view_mailbox_domains.cfm" addtoken="no">
  </cfif>
  <cfquery name="validateCert" datasource="hermes">
    SELECT id FROM system_certificates
    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cert_id#">
    AND san = '1'
  </cfquery>
  <cfif validateCert.recordcount EQ 0>
    <cfset session.m = 13>
    <cflocation url="view_mailbox_domains.cfm" addtoken="no">
  </cfif>
</cfif>

<!--- Validate quota (input is GB, stored in DB as MB) --->
<cfparam name="form.default_quota_gb" default="5">
<cfif NOT IsNumeric(form.default_quota_gb) OR form.default_quota_gb LTE 0>
  <cfset session.m = 15>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>
<cfset quotaMb = Round(form.default_quota_gb * 1024)>

<cfparam name="form.catchall_mailbox" default="">
<cfparam name="form.nextcloud_enabled" default="0">

<!--- Resolve certificate id --->
<cfif form.cert_mode IS "auto">
  <!--- Reuse an existing Acme cert keyed to this domain, if one exists
       (common when the domain was previously set up via mailbox_domains
       for cert SAN work). Otherwise create a new placeholder. --->
  <cfquery name="findExistingAcme" datasource="hermes">
    SELECT id FROM system_certificates
    WHERE type = 'Acme'
    AND domain_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">
    AND san = '1'
    LIMIT 1
  </cfquery>
  <cfif findExistingAcme.recordcount EQ 1>
    <cfset certId = findExistingAcme.id>
  <cfelse>
    <cfquery name="insertAcmeCert" datasource="hermes" result="certResult">
      INSERT INTO system_certificates
        (type, domain_name, file_name, friendly_name, acme_hash, san)
      VALUES (
        'Acme',
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
        '',
        '1'
      )
    </cfquery>
    <cfset certId = certResult.GENERATED_KEY>
  </cfif>
<cfelse>
  <cfset certId = form.cert_id>
</cfif>

<!--- Clean up any orphan entries for this domain. Since the domains check
     above already blocks duplicates at the entity level, any existing rows
     in transport/senders/recipients for this domain are orphans from a
     prior incomplete add or manual setup. --->
<cfquery datasource="hermes">
  DELETE FROM transport WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">
</cfquery>
<cfquery datasource="hermes">
  DELETE FROM senders WHERE sender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">
</cfquery>
<cfquery datasource="hermes">
  DELETE FROM recipients WHERE recipient = <cfqueryparam cfsqltype="cf_sql_varchar" value="@#domain_name#">
</cfquery>

<!--- Insert transport: lmtp:[hermes_dovecot]:24 --->
<cfquery name="addTransport" datasource="hermes" result="transResult">
  INSERT INTO transport
    (domain, transport, destination, method, port, mx, authentication)
  VALUES (
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
    'lmtp:[hermes_dovecot]:24',
    'hermes_dovecot',
    'lmtp',
    '24',
    'NO',
    'NO'
  )
</cfquery>

<!--- Insert sender --->
<cfquery name="addSender" datasource="hermes" result="sendersResult">
  INSERT INTO senders (sender, action) VALUES (
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">, 'OK'
  )
</cfquery>

<!--- Insert recipient (any @domain accepted; individual mailbox filtering is enforced by Dovecot LMTP) --->
<cfquery name="addRecipient" datasource="hermes" result="recResult">
  INSERT INTO recipients (recipient, domain, status) VALUES (
    <cfqueryparam cfsqltype="cf_sql_varchar" value="@#domain_name#">, '1', 'OK'
  )
</cfquery>

<!--- Insert domains row with type='mailbox' + all mailbox metadata --->
<cfset ncEnabled = (form.nextcloud_enabled IS "1") ? 1 : 0>
<cfquery datasource="hermes">
  INSERT INTO domains
    (domain, transport_id, senders_id, recipients_id, action_taken, type,
     default_quota_mb, catchall_mailbox, nextcloud_enabled,
     created_at, updated_at)
  VALUES (
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#transResult.GENERATED_KEY#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#sendersResult.GENERATED_KEY#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#recResult.GENERATED_KEY#">,
    'OK',
    'mailbox',
    <cfqueryparam cfsqltype="cf_sql_integer" value="#quotaMb#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.catchall_mailbox)#" null="#(trim(form.catchall_mailbox) IS '')#">,
    <cfqueryparam cfsqltype="cf_sql_tinyint" value="#ncEnabled#">,
    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
  )
</cfquery>

<!--- Upsert mailbox_domains row (cert SAN binding). May already exist from
     legacy ACME work — update the cert in that case. --->
<cfif checkmbxexists.recordcount GTE 1>
  <cfquery datasource="hermes">
    UPDATE mailbox_domains
    SET mailbox_certificate = <cfqueryparam cfsqltype="cf_sql_integer" value="#certId#">
    WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">
  </cfquery>
<cfelse>
  <cfquery datasource="hermes">
    INSERT INTO mailbox_domains (domain, mailbox_certificate)
    VALUES (
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#domain_name#">,
      <cfqueryparam cfsqltype="cf_sql_integer" value="#certId#">
    )
  </cfquery>
</cfif>

<!--- Sync mailbox_sans (adds one row per additional_sans prefix × this domain) --->
<cfinclude template="./sync_mailbox_sans.cfm">

<!--- Regenerate Postfix configs (transport, relay domains, postfix config) --->
<cfset datasource = "hermes">
<cfinclude template="./generate_transports.cfm">
<cfinclude template="./generate_relay_domains.cfm">
<cfinclude template="./generate_postfix_configuration.cfm">

<!--- Regenerate Nginx config (restart happens via preload page) --->
<cfinclude template="./generate_nginx_configuration.cfm">

<!--- Add domain to Ciphermail (same as relay domains) --->
<cfset theNewDomain = domain_name>
<cfinclude template="./add_domain_djigzo.cfm">

<cfset session.m = 1>
<cflocation url="preload_restart_nginx.cfm?returnUrl=/admin/2/view_mailbox_domains.cfm" addtoken="no">
