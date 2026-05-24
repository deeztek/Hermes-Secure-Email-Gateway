<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

Resolve the active console certificate's on-disk paths so callers don't
have to repeat the parameters2 + system_certificates JOIN + path-pattern
logic. Hermes supports two cert sources (Imported third-party, ACME
auto-renewed via Let's Encrypt) plus an Ubuntu snakeoil fallback, each
with different filename conventions.

This helper writes the resolved paths to caller-visible variables (CFML
includes don't have proper return values). All paths are fully qualified
so callers can pass them straight to openssl/nginx/etc.

Outputs (caller reads these after cfinclude):

  hermesCertType       - "Imported" | "Acme" | "Snakeoil"
  hermesCertIsSnakeoil - true if no real cert is configured (no signing
                         possible because snakeoil isn't publicly trusted)

  hermesCertNginxPath  - cert path to feed nginx ssl_certificate
                         (bundle for Imported, fullchain for Acme).
  hermesCertKeyPath    - private key path (nginx ssl_certificate_key,
                         openssl -inkey).

  hermesCertSignerPath - LEAF certificate only (no chain). openssl cms
                         -sign wants signer separate from -certfile.
  hermesCertChainPath  - intermediates only (no leaf). openssl cms
                         -sign -certfile.

For Snakeoil, the *Path values are still set to the snakeoil cert/key
paths so callers that don't care about signing (e.g. nginx) can use
them; signing callers should branch on hermesCertIsSnakeoil and skip
signing entirely (snakeoil isn't publicly trusted, signing with it
just produces a profile that's worse than unsigned).
--->

<cfquery name="_certIdLookup" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'console' AND parameter = 'console.certificate'
</cfquery>

<!--- Defaults point at the system-flagged cert's files (#251 + #252).
     The system cert (Docker bootstrap with file_name='bootstrap',
     legacy snakeoil with file_name='ssl-cert-snakeoil') is always
     installed -- its files exist on disk for the life of the install.
     Path pattern matches the Imported branch below so callers get the
     same shape (.bundle.pem for nginx, .key for the key) regardless
     of which install variant they're on. The old Ubuntu
     /etc/ssl/certs/ssl-cert-snakeoil.pem hardcode was leftover from
     pre-#179 and crashed nginx with BIO_new_file in our minimal
     container that doesn't have the ssl-cert package. --->
<cfinclude template="get_system_cert_ids.cfm">
<cfset hermesCertType = "Snakeoil">
<cfset hermesCertIsSnakeoil = true>
<cfset hermesCertNginxPath = "/opt/hermes/ssl/bootstrap_hermes.bundle.pem">
<cfset hermesCertKeyPath = "/opt/hermes/ssl/bootstrap_hermes.key">
<cfset hermesCertSignerPath = "">
<cfset hermesCertChainPath = "">

<cfif systemCertIds NEQ "">
    <cfquery name="_systemCertRow" datasource="hermes">
        SELECT file_name FROM system_certificates
        WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListFirst(systemCertIds)#">
    </cfquery>
    <cfif _systemCertRow.recordcount EQ 1 AND Len(_systemCertRow.file_name) GT 0>
        <cfif _systemCertRow.file_name EQ "ssl-cert-snakeoil">
            <!--- Legacy non-Docker installs: Ubuntu ssl-cert package paths.
                 The cert files live under /etc/ssl/, not /opt/hermes/ssl/. --->
            <cfset hermesCertNginxPath = "/etc/ssl/certs/ssl-cert-snakeoil.pem">
            <cfset hermesCertKeyPath = "/etc/ssl/private/ssl-cert-snakeoil.key">
        <cfelse>
            <!--- Docker bootstrap (file_name='bootstrap') or any future
                 install-generated cert: standard Hermes /opt/hermes/ssl/
                 path pattern, same as the Imported branch below. --->
            <cfset hermesCertNginxPath = "/opt/hermes/ssl/" & _systemCertRow.file_name & "_hermes.bundle.pem">
            <cfset hermesCertKeyPath = "/opt/hermes/ssl/" & _systemCertRow.file_name & "_hermes.key">
        </cfif>
    </cfif>
</cfif>

<!--- Drop the legacy `value2 NEQ "1"` guard (#251). It assumed id=1 was
     a sentinel for "no cert configured", but post-#179 id=1 is a real
     row -- the bootstrap System Bootstrap Certificate. Letting id=1
     through the lookup resolves to file_name='bootstrap' which builds
     the correct Imported paths below. --->
<cfif _certIdLookup.recordcount EQ 1
      AND Len(Trim(_certIdLookup.value2)) GT 0
      AND IsNumeric(_certIdLookup.value2)>

    <cfquery name="_certRow" datasource="hermes">
        SELECT id, type, file_name FROM system_certificates
        WHERE id = <cfqueryparam value="#_certIdLookup.value2#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif _certRow.recordcount EQ 1>
        <cfif _certRow.type EQ "Imported">
            <cfif _certRow.file_name EQ "ssl-cert-snakeoil">
                <!--- Legacy non-Docker install bound to the Ubuntu
                     ssl-cert package snakeoil. Cert files live under
                     /etc/ssl/, not /opt/hermes/ssl/. Still flag as
                     Snakeoil so signing callers skip. --->
                <cfset hermesCertType = "Snakeoil">
                <cfset hermesCertIsSnakeoil = true>
                <cfset hermesCertNginxPath = "/etc/ssl/certs/ssl-cert-snakeoil.pem">
                <cfset hermesCertKeyPath = "/etc/ssl/private/ssl-cert-snakeoil.key">
                <cfset hermesCertSignerPath = "">
                <cfset hermesCertChainPath = "">
            <cfelse>
                <cfset hermesCertType = "Imported">
                <cfset hermesCertIsSnakeoil = false>
                <cfset hermesCertNginxPath = "/opt/hermes/ssl/" & _certRow.file_name & "_hermes.bundle.pem">
                <cfset hermesCertKeyPath = "/opt/hermes/ssl/" & _certRow.file_name & "_hermes.key">
                <cfset hermesCertSignerPath = "/opt/hermes/ssl/" & _certRow.file_name & "_hermes.pem">
                <cfset hermesCertChainPath = "/opt/hermes/ssl/" & _certRow.file_name & "_hermes.chain.pem">
            </cfif>
        <cfelseif _certRow.type EQ "Acme">
            <cfset hermesCertType = "Acme">
            <cfset hermesCertIsSnakeoil = false>
            <cfset hermesCertNginxPath = "/etc/letsencrypt/live/" & _certRow.file_name & "/fullchain.pem">
            <cfset hermesCertKeyPath = "/etc/letsencrypt/live/" & _certRow.file_name & "/privkey.pem">
            <cfset hermesCertSignerPath = "/etc/letsencrypt/live/" & _certRow.file_name & "/cert.pem">
            <cfset hermesCertChainPath = "/etc/letsencrypt/live/" & _certRow.file_name & "/chain.pem">
        </cfif>
    </cfif>
</cfif>
