<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

AJAX endpoint: returns a single mailbox-hosting domain (domains row with
type='mailbox') joined to its cert binding (mailbox_domains) as JSON.
Used by view_mailbox_domains.cfm edit modal.
--->
<cfcontent type="application/json" reset="yes">
<cfsetting enablecfoutputonly="yes">

<cfparam name="form.id" default="0">

<cfif NOT IsNumeric(form.id) OR form.id LTE 0>
  <cfoutput>{"error":"Invalid id"}</cfoutput>
  <cfabort>
</cfif>

<cfquery name="getdomain" datasource="hermes">
  SELECT d.id, d.domain,
         d.default_quota_mb, d.catchall_mailbox,
         d.nextcloud_enabled, d.nextcloud_group,
         d.enforce_mfa,
         md.mailbox_certificate,
         sc.type AS cert_type,
         sc.friendly_name AS cert_friendly_name
  FROM domains d
  LEFT JOIN mailbox_domains md ON md.domain = d.domain
  LEFT JOIN system_certificates sc ON sc.id = md.mailbox_certificate
  WHERE d.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id#">
  AND d.type = 'mailbox'
</cfquery>

<cfif getdomain.recordcount EQ 0>
  <cfoutput>{"error":"Mailbox domain not found"}</cfoutput>
  <cfabort>
</cfif>

<cfset resp = {
  "id"                  = getdomain.id,
  "domain"              = getdomain.domain,
  "cert_id"             = getdomain.mailbox_certificate,
  "cert_type"           = getdomain.cert_type,
  "cert_friendly_name"  = getdomain.cert_friendly_name,
  "default_quota_mb"    = getdomain.default_quota_mb,
  "catchall_mailbox"    = getdomain.catchall_mailbox,
  "nextcloud_enabled"   = getdomain.nextcloud_enabled,
  "nextcloud_group"     = getdomain.nextcloud_group,
  "enforce_mfa"         = getdomain.enforce_mfa
}>

<cfoutput>#SerializeJSON(resp)#</cfoutput>
