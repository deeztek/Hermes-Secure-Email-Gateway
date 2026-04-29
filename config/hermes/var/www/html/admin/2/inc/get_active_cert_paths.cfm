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

<cfset hermesCertType = "Snakeoil">
<cfset hermesCertIsSnakeoil = true>
<cfset hermesCertNginxPath = "/etc/ssl/certs/ssl-cert-snakeoil.pem">
<cfset hermesCertKeyPath = "/etc/ssl/private/ssl-cert-snakeoil.key">
<cfset hermesCertSignerPath = "">
<cfset hermesCertChainPath = "">

<cfif _certIdLookup.recordcount EQ 1
      AND Len(Trim(_certIdLookup.value2)) GT 0
      AND IsNumeric(_certIdLookup.value2)
      AND _certIdLookup.value2 NEQ "1">

    <cfquery name="_certRow" datasource="hermes">
        SELECT id, type, file_name FROM system_certificates
        WHERE id = <cfqueryparam value="#_certIdLookup.value2#" cfsqltype="cf_sql_integer">
    </cfquery>

    <cfif _certRow.recordcount EQ 1>
        <cfif _certRow.type EQ "Imported">
            <cfset hermesCertType = "Imported">
            <cfset hermesCertIsSnakeoil = false>
            <cfset hermesCertNginxPath = "/opt/hermes/ssl/" & _certRow.file_name & "_hermes.bundle.pem">
            <cfset hermesCertKeyPath = "/opt/hermes/ssl/" & _certRow.file_name & "_hermes.key">
            <cfset hermesCertSignerPath = "/opt/hermes/ssl/" & _certRow.file_name & "_hermes.pem">
            <cfset hermesCertChainPath = "/opt/hermes/ssl/" & _certRow.file_name & "_hermes.chain.pem">
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
