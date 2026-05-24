<!---
Hermes Secure Email Gateway - System Certificate ID Resolver

Returns a comma-separated list of system_certificates row IDs that are
"system-managed" -- install-generated certs that can be used as a
placeholder when binding a mailbox domain before a real SAN cert has
been imported. See #248 (bootstrap-as-placeholder) and #252 (system
column).

Outputs (caller reads after cfinclude):

  systemCertIds   - comma-separated list of IDs (e.g. "1" or "1,7")
                    or "" if none found

## Defensive resolution

The new `system` column added in #252 may or may not exist yet
depending on whether the schema migration has been applied. To avoid
making CFML order-of-operations dependent on the migration, this
helper:

  1. Checks information_schema.COLUMNS for the `system` column
  2. If the column exists: SELECT id WHERE system = 1
  3. If the column doesn't exist: SELECT id WHERE type='Imported' AND
     file_name IN ('bootstrap', 'ssl-cert-snakeoil')

Both paths return the same row(s) on both Docker installs (file_name
'bootstrap' from install_hermes_docker.sh:register_bootstrap_cert_in_db)
and legacy DEV (file_name 'ssl-cert-snakeoil' from the ssl-cert
package). The type='Imported' filter prevents matching a non-Imported
row that happens to share the file_name.

Callers use:
   <cfif systemCertIds NEQ "">
       WHERE id IN (<cfqueryparam list="yes" value="#systemCertIds#">)
   </cfif>
or:
   WHERE san='1' OR id IN (...)
--->

<cfquery name="_checkSystemCol" datasource="hermes">
    SELECT COUNT(*) AS hasCol FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'system_certificates'
      AND COLUMN_NAME = 'system'
</cfquery>

<cfif _checkSystemCol.hasCol GT 0>
    <cfquery name="_systemCerts" datasource="hermes">
        SELECT id FROM system_certificates WHERE system = 1
    </cfquery>
<cfelse>
    <cfquery name="_systemCerts" datasource="hermes">
        SELECT id FROM system_certificates
        WHERE type = 'Imported'
          AND file_name IN ('bootstrap', 'ssl-cert-snakeoil')
    </cfquery>
</cfif>

<cfset systemCertIds = ValueList(_systemCerts.id)>
