<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

Mailbox Domain Delete Action Handler (Email Server > Domains).

Deletes the mailbox-hosting domain entity (domains row with type='mailbox')
and its Postfix linkage + cert SAN binding + mailbox_sans rows. Mailbox
data on disk is NOT touched.

If the bound certificate has no other mailbox domains after deletion,
sets a flash message pointing the admin to System Certificates (we do NOT
auto-delete the cert to avoid Let's Encrypt duplicate-cert throttling on
re-request).
--->

<cfif NOT StructKeyExists(form, "domain_id") OR NOT IsNumeric(form.domain_id)>
  <cfset session.m = 20>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>

<cfset datasource = "hermes">

<!--- Get the mailbox-hosting domain row --->
<cfquery name="getDomainRow" datasource="hermes">
  SELECT id, domain, transport_id, senders_id, recipients_id
  FROM domains
  WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.domain_id#">
  AND type = 'mailbox'
</cfquery>
<cfif getDomainRow.recordcount EQ 0>
  <cfset session.m = 20>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>

<cfset theDomain = getDomainRow.domain>

<!--- Block deletion if mailboxes exist under this domain --->
<cfquery name="checkMailboxes" datasource="hermes">
  SELECT COUNT(*) AS cnt FROM mailboxes
  WHERE domain_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDomainRow.id#">
</cfquery>
<cfif checkMailboxes.cnt GT 0>
  <cfset session.m = 16>
  <cfset session.m_detail = checkMailboxes.cnt>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>

<!--- Block deletion if recipients (non-domain entries) exist for this domain --->
<cfquery name="checkRecipients" datasource="hermes">
  SELECT COUNT(*) AS cnt FROM recipients
  WHERE recipient LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%@#theDomain#">
  AND recipient NOT LIKE '@%'
</cfquery>
<cfif checkRecipients.cnt GT 0>
  <cfset session.m = 17>
  <cfset session.m_detail = checkRecipients.cnt>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>

<!--- Capture the cert id before deleting mailbox_domains row --->
<cfquery name="getMbxCert" datasource="hermes">
  SELECT mailbox_certificate
  FROM mailbox_domains
  WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#theDomain#">
</cfquery>
<cfset theCertId = (getMbxCert.recordcount EQ 1) ? getMbxCert.mailbox_certificate : 0>

<!--- Delete the cert SAN binding so sync_mailbox_sans.cfm drops its SANs --->
<cfquery datasource="hermes">
  DELETE FROM mailbox_domains
  WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#theDomain#">
</cfquery>

<!--- Delete the domains row + Postfix linkage (transport/senders/recipients) --->
<cfquery datasource="hermes">
  DELETE FROM domains WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDomainRow.id#">
</cfquery>
<cfquery datasource="hermes">
  DELETE FROM transport WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDomainRow.transport_id#">
</cfquery>
<cfquery datasource="hermes">
  DELETE FROM senders WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDomainRow.senders_id#">
</cfquery>
<cfquery datasource="hermes">
  DELETE FROM recipients WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getDomainRow.recipients_id#">
</cfquery>

<!--- Delete this domain's mailbox_sans rows directly (don't use
     sync_mailbox_sans which would nuke validated ip/dns state on
     other domains if run during a delete→re-add cycle) --->
<cfquery datasource="hermes">
  DELETE FROM mailbox_sans
  WHERE mailbox_domain = '1'
  AND subdomain LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#theDomain#">
</cfquery>

<!--- Regenerate Postfix configs --->
<cfinclude template="./generate_transports.cfm">
<cfinclude template="./generate_relay_domains.cfm">
<cfinclude template="./generate_postfix_configuration.cfm">

<!--- Regenerate Nginx config (restart happens via preload page) --->
<cfinclude template="./generate_nginx_configuration.cfm">

<!--- Remove from Ciphermail --->
<cfset theOriginalDomain = theDomain>
<cfinclude template="./delete_domain_djigzo.cfm">

<!--- Check if the bound cert is now orphaned (no other mailbox_domains use it) --->
<cfif IsNumeric(theCertId) AND theCertId GT 0>
  <cfquery name="checkOrphan" datasource="hermes">
    SELECT COUNT(*) AS n FROM mailbox_domains
    WHERE mailbox_certificate = <cfqueryparam cfsqltype="cf_sql_integer" value="#theCertId#">
  </cfquery>
  <cfif checkOrphan.n EQ 0>
    <cfquery name="getOrphanCert" datasource="hermes">
      SELECT friendly_name, type FROM system_certificates
      WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#theCertId#">
    </cfquery>
    <cfif getOrphanCert.recordcount EQ 1>
      <cfset session.orphan_cert_id = theCertId>
      <cfset session.orphan_cert_name = getOrphanCert.friendly_name>
      <cfset session.orphan_cert_type = getOrphanCert.type>
    </cfif>
  </cfif>
</cfif>

<cfset session.m = 3>
<cflocation url="preload_restart_nginx.cfm?returnUrl=/admin/2/view_mailbox_domains.cfm" addtoken="no">
