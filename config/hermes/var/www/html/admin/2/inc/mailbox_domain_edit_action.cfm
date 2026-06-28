<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

Mailbox Domain Edit Action Handler (Email Server > Domains).

Domain name is immutable after creation. Editable fields live on the
`domains` table (mailbox metadata) and `mailbox_domains` table (cert
binding).

If cert binding changes, mailbox_sans is re-synced so subdomain rows
point at the new certificate (and ip/dns get reset to trigger
re-validation).
--->

<cfset isPro = isDefined("session.edition") AND session.edition EQ "Pro">

<cfif NOT StructKeyExists(form, "domain_id") OR NOT IsNumeric(form.domain_id)>
  <cfset session.m = 20>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>

<cfquery name="getCurrent" datasource="hermes">
  SELECT d.id, d.domain, md.mailbox_certificate
  FROM domains d
  LEFT JOIN mailbox_domains md ON md.domain = d.domain
  WHERE d.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.domain_id#">
  AND d.type = 'mailbox'
</cfquery>
<cfif getCurrent.recordcount EQ 0>
  <cfset session.m = 20>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>

<!--- Validate cert mode --->
<cfparam name="form.cert_mode" default="existing">
<cfif NOT ListFindNoCase("auto,existing", form.cert_mode)>
  <cfset session.m = 20>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>

<cfparam name="form.cert_id" default="">

<!--- Resolve certificate id --->
<cfif form.cert_mode IS "auto">
  <!--- If an Acme cert keyed to this domain already exists, keep it. Else
       create a new placeholder Acme cert. --->
  <cfquery name="getExistingCertType" datasource="hermes">
    SELECT id, type, domain_name FROM system_certificates
    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getCurrent.mailbox_certificate#">
  </cfquery>
  <cfif getExistingCertType.recordcount EQ 1
        AND getExistingCertType.type IS "Acme"
        AND getExistingCertType.domain_name IS getCurrent.domain>
    <cfset certId = getExistingCertType.id>
  <cfelse>
    <cfquery name="insertAcmeCert" datasource="hermes" result="certResult">
      INSERT INTO system_certificates
        (type, domain_name, file_name, friendly_name, acme_hash, san)
      VALUES (
        'Acme',
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCurrent.domain#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCurrent.domain#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCurrent.domain#">,
        '',
        '1'
      )
    </cfquery>
    <cfset certId = certResult.GENERATED_KEY>
  </cfif>
<cfelse>
  <cfif NOT IsNumeric(form.cert_id) OR form.cert_id LTE 0>
    <cfset session.m = 13>
    <cflocation url="view_mailbox_domains.cfm" addtoken="no">
  </cfif>
  <!--- Accept either a real SAN cert (san='1') OR any system-flagged
       cert as a placeholder (#248 + #252). Mirrors the add-action
       validation so admin can swap to/from the placeholder via edit. --->
  <cfinclude template="./get_system_cert_ids.cfm">
  <cfquery name="validateCert" datasource="hermes">
    SELECT id FROM system_certificates
    WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cert_id#">
    AND (
      san = '1'
      <cfif systemCertIds NEQ "">
        OR id IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#systemCertIds#">)
      </cfif>
    )
  </cfquery>
  <cfif validateCert.recordcount EQ 0>
    <cfset session.m = 13>
    <cflocation url="view_mailbox_domains.cfm" addtoken="no">
  </cfif>
  <cfset certId = form.cert_id>
</cfif>

<!--- Validate quota (input is GB, stored in DB as MB) --->
<cfparam name="form.default_quota_gb" default="5">
<cfif NOT IsNumeric(form.default_quota_gb) OR form.default_quota_gb LTE 0>
  <cfset session.m = 15>
  <cflocation url="view_mailbox_domains.cfm" addtoken="no">
</cfif>
<cfset quotaMb = Round(form.default_quota_gb * 1024)>

<cfparam name="form.catchall_mailbox"  default="">
<cfparam name="form.nextcloud_enabled" default="0">
<cfparam name="form.enforce_mfa"       default="0">
<cfset ncEnabled  = (form.nextcloud_enabled IS "1") ? 1 : 0>
<cfset enforceMfa = (form.enforce_mfa       IS "1") ? 1 : 0>

<!--- #226: per-domain user-portal signature toggle (both tiers) +
     org info (Pro-only). The toggle gates the user-portal editor in
     either tier; org placeholders ({{org.name}} etc.) only resolve in
     Pro. Org fields are skipped from the UPDATE on Community so a
     tampered form post can't write data, and existing values survive
     a Pro->Community downgrade. --->
<cfparam name="form.allow_user_signatures"  default="0">
<cfset allowUserSignaturesFlag = (Trim(form.allow_user_signatures) EQ "1") ? 1 : 0>

<cfif isPro>
  <cfparam name="form.org_name"     default="">
  <cfparam name="form.org_phone"    default="">
  <cfparam name="form.org_address"  default="">
  <cfparam name="form.org_website"  default="">
  <cfset orgName    = Left(Trim(form.org_name),     255)>
  <cfset orgPhone   = Left(Trim(form.org_phone),     64)>
  <cfset orgAddress = Trim(form.org_address)>
  <cfset orgWebsite = Left(Trim(form.org_website),  255)>
</cfif>

<!--- Update mailbox metadata on domains row.
     enforce_mfa here is the DOMAIN-level default for new mailboxes. It
     does NOT cascade to existing mailboxes — same convention as
     nextcloud_enabled. The disclaimer in the Edit Domain modal makes
     this explicit to admins. --->
<cfquery datasource="hermes">
  UPDATE domains
  SET default_quota_mb       = <cfqueryparam cfsqltype="cf_sql_integer"   value="#quotaMb#">,
      catchall_mailbox       = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#trim(form.catchall_mailbox)#" null="#(trim(form.catchall_mailbox) IS '')#">,
      nextcloud_enabled      = <cfqueryparam cfsqltype="cf_sql_tinyint"   value="#ncEnabled#">,
      enforce_mfa            = <cfqueryparam cfsqltype="cf_sql_tinyint"   value="#enforceMfa#">,
      <cfif isPro>
      org_name               = <cfqueryparam cfsqltype="cf_sql_varchar"     value="#orgName#"    null="#(orgName    EQ '')#">,
      org_phone              = <cfqueryparam cfsqltype="cf_sql_varchar"     value="#orgPhone#"   null="#(orgPhone   EQ '')#">,
      org_address            = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#orgAddress#" null="#(orgAddress EQ '')#">,
      org_website            = <cfqueryparam cfsqltype="cf_sql_varchar"     value="#orgWebsite#" null="#(orgWebsite EQ '')#">,
      </cfif>
      allow_user_signatures  = <cfqueryparam cfsqltype="cf_sql_tinyint"   value="#allowUserSignaturesFlag#">,
      updated_at             = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
  WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.domain_id#">
</cfquery>

<!--- Upsert cert binding on mailbox_domains --->
<cfquery name="checkMbx" datasource="hermes">
  SELECT id FROM mailbox_domains
  WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCurrent.domain#">
</cfquery>
<cfif checkMbx.recordcount GTE 1>
  <cfquery datasource="hermes">
    UPDATE mailbox_domains
    SET mailbox_certificate = <cfqueryparam cfsqltype="cf_sql_integer" value="#certId#">
    WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCurrent.domain#">
  </cfquery>
<cfelse>
  <cfquery datasource="hermes">
    INSERT INTO mailbox_domains (domain, mailbox_certificate)
    VALUES (
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#getCurrent.domain#">,
      <cfqueryparam cfsqltype="cf_sql_integer" value="#certId#">
    )
  </cfquery>
</cfif>

<!--- Re-sync mailbox_sans so cert bindings and subdomains match the edit --->
<cfinclude template="./sync_mailbox_sans.cfm">

<!--- #226 Phase 2B: any change to allow_user_signatures or the org_*
     columns shifts the resolver winner per mailbox and changes the
     {{org.*}} substitution data, so rebuild the body milter map and
     sender_data.json. Cheap (one query per table, no per-mailbox
     file writes unless an org sig wins). --->
<cfset signatureRegenSilent = true>
<cfinclude template="./signature_regen_map.cfm">

<!--- Regenerate Nginx config (restart happens via preload page) --->
<cfinclude template="./generate_nginx_configuration.cfm">

<cfset session.m = 2>
<cflocation url="preload_restart_nginx.cfm?returnUrl=/admin/2/view_mailbox_domains.cfm" addtoken="no">
