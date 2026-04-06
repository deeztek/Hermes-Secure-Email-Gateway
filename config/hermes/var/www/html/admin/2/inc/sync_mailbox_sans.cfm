<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

Syncs the mailbox_sans table so it contains exactly one row per
(additional_sans.san + mailbox-hosting domain) combination.

The source of truth for mailbox-hosting domains is:
  domains WHERE type='mailbox' AND active=1
joined to mailbox_domains (for the cert binding).

  - Adds rows for any missing FQDNs with ip='NO', dns='NO'.
  - Removes mailbox_sans rows whose FQDN no longer corresponds to a valid
    (prefix, domain) combination.
  - Only operates on rows where mailbox_domain='1'.

Re-entrant / idempotent. Safe to call after every add/edit/delete on
mailbox domains or additional_sans.
--->

<!--- Build the set of valid FQDNs from additional_sans x mailbox-hosting domains --->
<cfquery name="syncDomains" datasource="hermes">
    SELECT d.id, d.domain, md.mailbox_certificate
    FROM domains d
    INNER JOIN mailbox_domains md ON md.domain = d.domain
    WHERE d.type = 'mailbox'
</cfquery>

<cfquery name="syncPrefixes" datasource="hermes">
    SELECT san FROM additional_sans
</cfquery>

<cfset validFqdns = StructNew()>
<cfloop query="syncDomains">
    <cfloop query="syncPrefixes">
        <cfset fqdn = LCase(Trim(syncPrefixes.san) & "." & Trim(syncDomains.domain))>
        <cfset validFqdns[fqdn] = {
            "cert_id" = syncDomains.mailbox_certificate,
            "domain"  = syncDomains.domain
        }>
    </cfloop>
</cfloop>

<!--- Get all existing mailbox_sans rows for mailbox_domain='1' --->
<cfquery name="syncExisting" datasource="hermes">
    SELECT id, subdomain, certificate
    FROM mailbox_sans
    WHERE mailbox_domain = '1'
</cfquery>

<cfset existingFqdns = StructNew()>
<cfloop query="syncExisting">
    <cfset existingFqdns[LCase(Trim(syncExisting.subdomain))] = syncExisting.id>
</cfloop>

<!--- Insert any missing FQDNs --->
<cfloop collection="#validFqdns#" item="syncFqdn">
    <cfif NOT StructKeyExists(existingFqdns, syncFqdn)>
        <!--- Determine acme flag: 1 if cert is Acme, 2 if Imported --->
        <cfquery name="syncCertType" datasource="hermes">
            SELECT type FROM system_certificates
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#validFqdns[syncFqdn].cert_id#">
        </cfquery>
        <cfset syncAcme = 2>
        <cfif syncCertType.recordcount EQ 1 AND syncCertType.type IS "Acme">
            <cfset syncAcme = 1>
        </cfif>

        <cfquery datasource="hermes">
            INSERT INTO mailbox_sans (certificate, mailbox_domain, subdomain, ip, dns, acme)
            VALUES (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#validFqdns[syncFqdn].cert_id#">,
                '1',
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#syncFqdn#">,
                'NO',
                'NO',
                <cfqueryparam cfsqltype="cf_sql_integer" value="#syncAcme#">
            )
        </cfquery>
    <cfelse>
        <!--- FQDN exists — update cert binding if changed but PRESERVE ip/dns
             validation state. Resetting ip/dns would destroy validated SANs and
             prevent nginx vhost generation until acme_validate_ip re-runs. --->
        <cfquery name="syncCurrentCert" datasource="hermes">
            SELECT certificate FROM mailbox_sans
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#existingFqdns[syncFqdn]#">
        </cfquery>
        <cfif syncCurrentCert.certificate NEQ validFqdns[syncFqdn].cert_id>
            <cfquery name="syncCertTypeForUpdate" datasource="hermes">
                SELECT type FROM system_certificates
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#validFqdns[syncFqdn].cert_id#">
            </cfquery>
            <cfset syncAcme = 2>
            <cfif syncCertTypeForUpdate.recordcount EQ 1 AND syncCertTypeForUpdate.type IS "Acme">
                <cfset syncAcme = 1>
            </cfif>
            <cfquery datasource="hermes">
                UPDATE mailbox_sans
                SET certificate = <cfqueryparam cfsqltype="cf_sql_integer" value="#validFqdns[syncFqdn].cert_id#">,
                    acme = <cfqueryparam cfsqltype="cf_sql_integer" value="#syncAcme#">
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#existingFqdns[syncFqdn]#">
            </cfquery>
        </cfif>
    </cfif>
</cfloop>

<!--- Delete mailbox_sans rows whose FQDN is no longer valid --->
<cfloop query="syncExisting">
    <cfset syncKey = LCase(Trim(syncExisting.subdomain))>
    <cfif NOT StructKeyExists(validFqdns, syncKey)>
        <cfquery datasource="hermes">
            DELETE FROM mailbox_sans
            WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#syncExisting.id#">
            AND mailbox_domain = '1'
        </cfquery>
    </cfif>
</cfloop>
