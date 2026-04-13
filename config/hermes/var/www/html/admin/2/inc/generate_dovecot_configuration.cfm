
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

GENERATE DOVECOT CONFIGURATION
Reads the dovecot.conf template from /opt/hermes/templates/dovecot.conf,
replaces all hermes_* placeholders with values from parameters2
(module='dovecot') and the certificate from parameters2
(module='certificates', parameter='mail.certificate'), writes to a temp
file, moves to /etc/dovecot/dovecot.conf, and reloads Dovecot.

Called from: email_server_settings_action.cfm (after saving form values)
--->

<!--- GENERATE CUSTOMTRANS --->
<cfinclude template="generate_customtrans.cfm">

<!--- LOAD ALL DOVECOT SETTINGS FROM parameters2 --->
<cfquery name="getDovecotSettings" datasource="hermes">
    SELECT parameter, value2 FROM parameters2
    WHERE module = 'dovecot' AND active = '1'
</cfquery>

<!--- Build a struct for easy lookup --->
<cfset dov = StructNew()>
<cfloop query="getDovecotSettings">
    <cfset dov[getDovecotSettings.parameter] = getDovecotSettings.value2>
</cfloop>

<!--- Defaults for any missing settings (safety net for fresh installs) --->
<cfparam name="dov['mail.compression']" default="yes">
<cfparam name="dov['mail.compression_algorithm']" default="lz4">
<cfparam name="dov['mail.compression_level']" default="3">
<cfparam name="dov['mail.encryption']" default="no">
<cfparam name="dov['mail.encryption_curve']" default="prime256v1">
<cfparam name="dov['protocol.imap']" default="yes">
<cfparam name="dov['protocol.pop3']" default="yes">
<cfparam name="dov['ssl.min_protocol']" default="TLSv1.2">
<cfparam name="dov['ssl.cipher_list']" default="ALL:!DH:!kRSA:!SRP:!kDHd:!DSS:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH">
<cfparam name="dov['quota.warning_critical']" default="99">
<cfparam name="dov['quota.warning_high']" default="95">
<cfparam name="dov['quota.warning_medium']" default="80">
<cfparam name="dov['quota.trash_percentage']" default="110">
<cfparam name="dov['connection.client_limit']" default="1000">
<cfparam name="dov['connection.max_userip']" default="20">
<cfparam name="dov['logging.debug']" default="no">

<!--- BUILD PROTOCOLS LINE --->
<!--- Submission, sieve, lmtp are always on (required for mail delivery, filtering, vacation) --->
<cfset protocolList = "">
<cfif dov['protocol.imap'] EQ "yes">
    <cfset protocolList = ListAppend(protocolList, "imap", " ")>
</cfif>
<cfif dov['protocol.pop3'] EQ "yes">
    <cfset protocolList = ListAppend(protocolList, "pop3", " ")>
</cfif>
<cfset protocolList = ListAppend(protocolList, "submission sieve lmtp", " ")>

<!--- BUILD COMPRESSION LEVEL LINE --->
<!--- LZ4 has no configurable level; zstd and zlib do --->
<cfset compressLevelLine = "">
<cfif dov['mail.compression'] EQ "yes" AND dov['mail.compression_algorithm'] NEQ "lz4">
    <cfset compressLevelLine = "mail_compress_write_level = " & dov['mail.compression_level']>
</cfif>

<!--- BUILD DEBUG LOG LINE --->
<cfset logDebugLine = "">
<cfif dov['logging.debug'] EQ "yes">
    <cfset logDebugLine = "log_debug = category=mail or category=auth">
<cfelse>
    <cfset logDebugLine = "# log_debug disabled">
</cfif>

<!--- RESOLVE TLS CERTIFICATE PATHS --->
<!--- Look up the certificate ID from the certificates module --->
<cfquery name="getCertParam" datasource="hermes">
    SELECT value2 FROM parameters2
    WHERE module = 'certificates' AND parameter = 'mail.certificate'
</cfquery>

<cfset sslCertPath = "">
<cfset sslKeyPath = "">

<cfif getCertParam.recordcount GTE 1 AND getCertParam.value2 NEQ "">
    <!--- Look up the certificate's friendly_name to build the Let's Encrypt path --->
    <cfquery name="getCertDomain" datasource="hermes">
        SELECT friendly_name FROM system_certificates
        WHERE id = <cfqueryparam value="#getCertParam.value2#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getCertDomain.recordcount GTE 1>
        <cfset sslCertPath = "/etc/letsencrypt/live/" & getCertDomain.friendly_name & "/fullchain.pem">
        <cfset sslKeyPath = "/etc/letsencrypt/live/" & getCertDomain.friendly_name & "/privkey.pem">
    </cfif>
</cfif>

<!--- If no cert is configured yet, extract the current paths from the live config
     so we don't break an existing setup when other settings are changed --->
<cfif sslCertPath EQ "">
    <cftry>
        <cffile action="read" file="/etc/dovecot/dovecot.conf" variable="currentConf" charset="utf-8">
        <cfset certMatch = REFind("ssl_server\s*\{[^}]*?cert_file\s*=\s*([^\n]+)", currentConf, 1, true)>
        <cfif certMatch.pos[1] GT 0 AND ArrayLen(certMatch.pos) GTE 2>
            <cfset sslCertPath = trim(Mid(currentConf, certMatch.pos[2], certMatch.len[2]))>
        </cfif>
        <cfset keyMatch = REFind("ssl_server\s*\{[^}]*?key_file\s*=\s*([^\n]+)", currentConf, 1, true)>
        <cfif keyMatch.pos[1] GT 0 AND ArrayLen(keyMatch.pos) GTE 2>
            <cfset sslKeyPath = trim(Mid(currentConf, keyMatch.pos[2], keyMatch.len[2]))>
        </cfif>
    <cfcatch type="any">
        <!--- Absolute fallback — should never reach here --->
    </cfcatch>
    </cftry>
</cfif>

<!--- Final fallback if still empty (brand new install, no cert at all) --->
<cfif sslCertPath EQ "">
    <cfset sslCertPath = "/etc/letsencrypt/live/localhost/fullchain.pem">
    <cfset sslKeyPath = "/etc/letsencrypt/live/localhost/privkey.pem">
</cfif>

<!--- READ DATABASE CREDENTIALS from mounted creds files --->
<!--- These files are mounted into the commandbox container from the Docker host
     at /opt/hermes/creds/. The install script generates them with random passwords.
     This keeps credentials out of the template file and version control. --->
<cfset dbUsername = "hermes">
<cfset dbPassword = "">
<cftry>
    <cffile action="read" file="/opt/hermes/creds/hermes_username" variable="dbUsername" charset="utf-8">
    <cfset dbUsername = trim(dbUsername)>
<cfcatch type="any">
    <!--- Fall back to default if creds file not found --->
</cfcatch>
</cftry>
<cftry>
    <cffile action="read" file="/opt/hermes/creds/hermes_password" variable="dbPassword" charset="utf-8">
    <cfset dbPassword = trim(dbPassword)>
<cfcatch type="any">
    <cfset m="generate_dovecot_configuration.cfm: Cannot read database password from /opt/hermes/creds/hermes_password">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>
</cftry>

<!--- LDAP settings — container hostname and base DN are fixed per deployment.
     The LDAP URI uses the Docker service name (hermes_ldap) which resolves
     via Docker DNS. The base DN matches the OpenLDAP container's configured
     domain (dc=hermes,dc=local). --->
<cfset ldapUri = "ldap://hermes_ldap:389">
<cfset ldapBase = "ou=users,dc=hermes,dc=local">

<!--- READ TEMPLATE --->
<cffile action="read" file="/opt/hermes/templates/dovecot.conf" variable="dovecotConf" charset="utf-8">

<!--- REPLACE ALL PLACEHOLDERS --->

<!--- Database credentials --->
<cfset dovecotConf = REReplace(dovecotConf, "hermes_db_username", dbUsername, "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_db_password", dbPassword, "ALL")>

<!--- LDAP --->
<cfset dovecotConf = REReplace(dovecotConf, "hermes_ldap_uri", ldapUri, "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_ldap_base", ldapBase, "ALL")>

<!--- Protocols --->
<cfset dovecotConf = REReplace(dovecotConf, "hermes_protocols", protocolList, "ALL")>

<!--- Logging --->
<cfset dovecotConf = REReplace(dovecotConf, "hermes_log_debug_line", logDebugLine, "ALL")>

<!--- Compression --->
<cfset dovecotConf = REReplace(dovecotConf, "hermes_mail_compress", dov['mail.compression'], "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_compress_method", dov['mail.compression_algorithm'], "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_compress_level_line", compressLevelLine, "ALL")>

<!--- Encryption --->
<cfset dovecotConf = REReplace(dovecotConf, "hermes_mail_crypt", dov['mail.encryption'], "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_crypt_curve", dov['mail.encryption_curve'], "ALL")>

<!--- Quota warnings --->
<cfset dovecotConf = REReplace(dovecotConf, "hermes_quota_warn_critical", dov['quota.warning_critical'], "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_quota_warn_high", dov['quota.warning_high'], "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_quota_warn_medium", dov['quota.warning_medium'], "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_trash_quota_pct", dov['quota.trash_percentage'], "ALL")>

<!--- Connection limits --->
<cfset dovecotConf = REReplace(dovecotConf, "hermes_login_client_limit", dov['connection.client_limit'], "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_max_userip", dov['connection.max_userip'], "ALL")>

<!--- SSL/TLS --->
<cfset dovecotConf = REReplace(dovecotConf, "hermes_ssl_cipher_list", dov['ssl.cipher_list'], "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_ssl_min_protocol", dov['ssl.min_protocol'], "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_ssl_cert_path", sslCertPath, "ALL")>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_ssl_key_path", sslKeyPath, "ALL")>

<!--- WRITE TO TEMP FILE --->
<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_dovecot.conf"
    output="#dovecotConf#"
    charset="utf-8"
    addNewLine="no">

<!--- Run dos2unix to ensure clean line endings --->
<cftry>
    <cfexecute name="/usr/bin/dos2unix"
        arguments="/opt/hermes/tmp/#customtrans3#_dovecot.conf"
        timeout="60" />
<cfcatch type="any">
    <cfset m="generate_dovecot_configuration.cfm: Error running dos2unix on temp file">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>
</cftry>

<!--- MOVE TEMP FILE TO PRODUCTION --->
<!--- /etc/dovecot/ is volume-mounted from host config/dovecot-2.4/conf/ so
     changes persist across container recreations --->
<cftry>
    <cffile action="copy"
        source="/opt/hermes/tmp/#customtrans3#_dovecot.conf"
        destination="/etc/dovecot/dovecot.conf">
<cfcatch type="any">
    <cfset m="generate_dovecot_configuration.cfm: Error copying config to /etc/dovecot/dovecot.conf">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>
</cftry>

<!--- CLEAN UP TEMP FILE --->
<cftry>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_dovecot.conf">
<cfcatch type="any">
    <!--- Non-fatal — temp file will be cleaned up eventually --->
</cfcatch>
</cftry>

<!--- RELOAD DOVECOT to pick up new config --->
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_dovecot doveadm reload"
        variable="reloadResult"
        errorVariable="reloadError"
        timeout="30" />
<cfcatch type="any">
    <cfset m="generate_dovecot_configuration.cfm: Error reloading Dovecot - #cfcatch.message#">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>
</cftry>
