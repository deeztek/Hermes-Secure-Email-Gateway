<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

ENSURE MAILBOX CERT BINDING (#371).

Gives every listed mailbox-hosting domain (type mailbox or hybrid) a
mailbox_domains row (its certificate binding), the same way
mailbox_domain_add_action.cfm does in its automatic certificate mode: reuse the
domain's existing ACME SAN certificate if there is one, otherwise create a
placeholder ACME certificate row for it.

Without that row sync_mailbox_sans.cfm skips the domain, so it never gets its
autoconfig./autodiscover. (and other mail) host names, and the scheduled SAN
validation never verifies, issues or serves them. Converting relay recipients
to mailboxes made domains hybrid without creating the row.

Input:  ensureBindingDomains  comma-separated domain names
Output: ensureBindingCreated  number of bindings created

Domains whose binding points at an existing certificate are left alone. A
binding row that points at a certificate which no longer exists (a leftover
from earlier certificate work) counts as missing and is re-pointed. The caller runs
sync_mailbox_sans.cfm afterwards when ensureBindingCreated > 0; the scheduled
SAN validation (schedule/acme_validate_ip.cfm) then verifies DNS, issues the
certificate and regenerates nginx, as for a newly added mailbox domain.
--->

<cfparam name="ensureBindingDomains" default="">
<cfset ensureBindingCreated = 0>

<cfloop list="#ensureBindingDomains#" index="ebDomain">
    <cfset ebDomain = LCase(Trim(ebDomain))>
    <cfif NOT Len(ebDomain)><cfcontinue></cfif>

    <cfquery name="ebDomainRow" datasource="hermes">
        SELECT d.id, md.id AS binding_id
        FROM domains d
        LEFT JOIN mailbox_domains md ON md.domain = d.domain
        LEFT JOIN system_certificates sc ON sc.id = md.mailbox_certificate
        WHERE d.domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ebDomain#">
          AND d.type IN ('mailbox', 'hybrid')
          AND (md.id IS NULL OR sc.id IS NULL)
    </cfquery>
    <cfif ebDomainRow.recordcount EQ 0><cfcontinue></cfif>

    <cfquery name="ebExistingAcme" datasource="hermes">
        SELECT id FROM system_certificates
        WHERE type = 'Acme'
          AND domain_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ebDomain#">
          AND san = '1'
        LIMIT 1
    </cfquery>
    <cfif ebExistingAcme.recordcount EQ 1>
        <cfset ebCertId = ebExistingAcme.id>
    <cfelse>
        <cfquery datasource="hermes" result="ebCertResult">
            INSERT INTO system_certificates
                (type, domain_name, file_name, friendly_name, acme_hash, san)
            VALUES (
                'Acme',
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ebDomain#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ebDomain#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ebDomain#">,
                '',
                '1'
            )
        </cfquery>
        <cfset ebCertId = ebCertResult.GENERATED_KEY>
    </cfif>

    <cfif Len(ebDomainRow.binding_id)>
        <cfquery datasource="hermes">
            UPDATE mailbox_domains
               SET mailbox_certificate = <cfqueryparam cfsqltype="cf_sql_integer" value="#ebCertId#">
             WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ebDomainRow.binding_id#">
        </cfquery>
    <cfelse>
        <cfquery datasource="hermes">
            INSERT INTO mailbox_domains (domain, mailbox_certificate)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ebDomain#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ebCertId#">
            )
        </cfquery>
    </cfif>
    <cfset ensureBindingCreated = ensureBindingCreated + 1>
</cfloop>
