
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
    WHERE module = 'dovecot'
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
    <cfset logDebugLine = "">
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
    <cfif getCertParam.value2 EQ "1">
        <!--- Built-in self-signed (snakeoil) certificate — ID 1 is always the
             system default. Same paths as generate_nginx_configuration.cfm. --->
        <cfset sslCertPath = "/etc/ssl/certs/ssl-cert-snakeoil.pem">
        <cfset sslKeyPath = "/etc/ssl/private/ssl-cert-snakeoil.key">
    <cfelse>
        <!--- Look up the certificate type and file_name to build the correct path.
             Path patterns match generate_nginx_configuration.cfm:
               Acme:     /etc/letsencrypt/live/<file_name>/fullchain.pem + privkey.pem
               Imported: /opt/hermes/ssl/<file_name>_hermes.pem + _hermes.key --->
        <cfquery name="getCertInfo" datasource="hermes">
            SELECT type, file_name FROM system_certificates
            WHERE id = <cfqueryparam value="#getCertParam.value2#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif getCertInfo.recordcount GTE 1>
            <cfif getCertInfo.type EQ "Acme">
                <cfset sslCertPath = "/etc/letsencrypt/live/" & getCertInfo.file_name & "/fullchain.pem">
                <cfset sslKeyPath = "/etc/letsencrypt/live/" & getCertInfo.file_name & "/privkey.pem">
            <cfelseif getCertInfo.type EQ "Imported">
                <cfset sslCertPath = "/opt/hermes/ssl/" & getCertInfo.file_name & "_hermes.pem">
                <cfset sslKeyPath = "/opt/hermes/ssl/" & getCertInfo.file_name & "_hermes.key">
            </cfif>
        </cfif>
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

<!--- Encryption: mail_crypt plugin is always loaded (needed to read existing
     encrypted mail). The admin toggle controls crypt_write_algorithm:
     enabled = encrypt new mail, disabled = don't encrypt new mail. --->
<cfset cryptWriteLine = "">
<cfif dov['mail.encryption'] EQ "yes">
    <cfset cryptWriteLine = "crypt_write_algorithm = aes-256-gcm-sha256">
<cfelse>
    <cfset cryptWriteLine = "crypt_write_algorithm =">
</cfif>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_crypt_write_algorithm_line", cryptWriteLine, "ALL")>

<!--- crypt_global_public_key_file directive: only emit when a real key
     is present. The host path is an empty placeholder on fresh installs
     (install_hermes_docker.sh touches the file so docker compose doesn't
     auto-create a directory at the bind-mount source). Dovecot would
     fatal-error on an empty key, so check for the PEM BEGIN marker.
     Keys are generated by inc/generate_mail_crypt_keys.cfm when admin
     enables mail encryption. --->
<cfset cryptPubKeyLine = "">
<cfif FileExists("/opt/hermes/keys/ecpubkey.pem")>
    <cfset keyContent = FileRead("/opt/hermes/keys/ecpubkey.pem")>
    <cfif Find("-----BEGIN", keyContent) GT 0>
        <cfset cryptPubKeyLine = "crypt_global_public_key_file = /keys/ecpubkey.pem">
    </cfif>
</cfif>
<cfset dovecotConf = REReplace(dovecotConf, "hermes_crypt_pubkey_line", cryptPubKeyLine, "ALL")>
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

<!--- ACL / Shared Mailboxes (Dovecot 2.4 upstream syntax)
     Authoritative reference:
       https://doc.dovecot.org/main/core/config/shared_mailboxes.html
       https://doc.dovecot.org/main/core/plugins/acl.html
       https://doc.dovecot.org/main/installation/upgrade/2.3-to-2.4.html

     Key 2.4 changes vs. 2.3 we had to account for:
       1. No `plugin {}` wrapper. `acl_driver` is top-level.
       2. `acl_shared_dict` setting is GONE. Replaced with a top-level
          `acl_sharing_map { dict mysql { ... } dict_map ... }` block.
          There is no backward-compat wrapper.
       3. Shared namespace `location = maildir:...:INDEX=...` one-liner
          is GONE. Replaced with `mail_driver`, `mail_path`, and
          `mail_index_private_path` per-namespace settings.
       4. In the `prefix` the templating context uses `$user` / `$username`
          / `$domain` (dollar-sign form). Everywhere else (`mail_path`,
          `mail_index_private_path`, etc.) use `%{owner_user}` /
          `%{owner_user | username}` / `%{owner_user | domain}` to refer
          to the share owner. `%{user}` always refers to the connected
          user — using it in a shared namespace's path silently points
          at the connected user's own Maildir.
       5. No shipped SQL driver for per-mailbox ACL rights in 2.4.
          Only `vfile` ships — reads per-mailbox `dovecot-acl` files
          inside each Maildir. Hermes writes these files when admin
          adds/removes permissions (see shared_mailbox_actions.cfm).
          The `dovecot_acl` SQL table is retained for Hermes admin UI
          display only; Dovecot itself reads the files. --->
<cfparam name="dov['sharing.enabled']" default="no">
<cfif dov['sharing.enabled'] EQ "yes">
    <cfset dovecotConf = REReplace(dovecotConf, "hermes_acl_enabled", "yes", "ALL")>

    <!--- The aclshared dict MUST live inside dict_server, not inline in
         acl_sharing_map. SQL drivers are only loaded in the dict process;
         the IMAP process references them via `dict proxy`. Defining the
         dict inline in acl_sharing_map works only for file-based dicts.
         Same pattern as quotadict (already in dict_server, referenced by
         quota_clone via `dict proxy { name = quotadict }`). --->
    <cfset aclDictBlock = "  dict aclshared {" & chr(10) &
        "    driver = sql" & chr(10) &
        "    sql_driver = mysql" & chr(10) & chr(10) &
        "    mysql aclshared {" & chr(10) &
        "      host = hermes_db_server" & chr(10) &
        "      user = " & dbUsername & chr(10) &
        "      password = " & dbPassword & chr(10) &
        "      dbname = hermes" & chr(10) &
        "    }" & chr(10) & chr(10) &
        "    dict_map shared/shared-boxes/user/$to/$from {" & chr(10) &
        "      sql_table = dovecot_acl_shared" & chr(10) &
        "      value_field dummy {" & chr(10) &
        "      }" & chr(10) &
        "      key_field from_user {" & chr(10) &
        "        value = $from" & chr(10) &
        "      }" & chr(10) &
        "      key_field to_user {" & chr(10) &
        "        value = $to" & chr(10) &
        "      }" & chr(10) &
        "    }" & chr(10) & chr(10) &
        "    dict_map shared/shared-boxes/anyone/$from {" & chr(10) &
        "      sql_table = dovecot_acl_shared_anyone" & chr(10) &
        "      value_field dummy {" & chr(10) &
        "      }" & chr(10) &
        "      key_field from_user {" & chr(10) &
        "        value = $from" & chr(10) &
        "      }" & chr(10) &
        "    }" & chr(10) &
        "  }">
    <cfset dovecotConf = REReplace(dovecotConf, "hermes_acl_dict_block", aclDictBlock, "ALL")>

    <!--- Top-level acl_driver = vfile + acl_sharing_map {} referencing
         the aclshared dict via proxy. The dict_map lives on the dict
         definition in dict_server — no need to repeat it here. --->
    <cfset aclConfigBlock = "acl_driver = vfile" & chr(10) & chr(10) &
        "acl_sharing_map {" & chr(10) &
        "  dict proxy {" & chr(10) &
        "    name = aclshared" & chr(10) &
        "  }" & chr(10) &
        "}">
    <cfset dovecotConf = REReplace(dovecotConf, "hermes_acl_config_block", aclConfigBlock, "ALL")>

    <!--- Shared namespace. See header comment for 2.4 variable rules.
         - prefix uses `$user` (template context)
         - mail_path uses `%{owner_user | ...}` (substitution context)
         - mail_index_private_path (NOT mail_index_path) for shared --->
    <cfset sharedNamespace = "namespace shared {" & chr(10) &
        "  type = shared" & chr(10) &
        "  separator = /" & chr(10) &
        "  prefix = Shared/$user/" & chr(10) &
        "  mail_driver = maildir" & chr(10) &
        "  mail_path = /srv/mail/%{owner_user | domain}/%{owner_user | username}" & chr(10) &
        "  mail_index_private_path = ~/shared-index/%{owner_user}" & chr(10) &
        "  subscriptions = no" & chr(10) &
        "  list = children" & chr(10) &
        "}">
    <cfset dovecotConf = REReplace(dovecotConf, "hermes_shared_namespace_block", sharedNamespace, "ALL")>
<cfelse>
    <cfset dovecotConf = REReplace(dovecotConf, "hermes_acl_enabled", "no", "ALL")>
    <cfset dovecotConf = REReplace(dovecotConf, "hermes_acl_dict_block", "", "ALL")>
    <cfset dovecotConf = REReplace(dovecotConf, "hermes_acl_config_block", "", "ALL")>
    <cfset dovecotConf = REReplace(dovecotConf, "hermes_shared_namespace_block", "", "ALL")>
</cfif>

<!--- WRITE TO TEMP FILE --->
<!--- Use fileWrite() instead of cffile tag to avoid Lucee evaluating
     ## comment characters in the dovecot config as CFML expressions --->
<cfscript>
    fileWrite("/opt/hermes/tmp/" & customtrans3 & "_dovecot.conf", dovecotConf, "utf-8");
</cfscript>

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

<!--- COPY TEMP FILE TO PRODUCTION --->
<!--- /etc/dovecot/ is volume-mounted into commandbox from host
     config/dovecot-2.4/conf/ — shared with the hermes_dovecot container,
     so changes persist and are visible to both containers. --->
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
    <!--- Non-fatal --->
</cfcatch>
</cftry>

<!--- ===== LUA PASSDB SCRIPT (auth_app_passwords.lua, #197) ===========
     The Dovecot Lua passdb script needs the same DB credentials as
     dovecot.conf. Render its template the same way: substitute creds,
     write to temp, dos2unix, copy into /etc/dovecot/. See
     docs/admin/authentication/01-credential-model.md for design. --->

<cffile action="read" file="/opt/hermes/templates/auth_app_passwords.lua" variable="luaConf" charset="utf-8">

<cfset luaConf = REReplace(luaConf, "hermes_db_username", dbUsername, "ALL")>
<cfset luaConf = REReplace(luaConf, "hermes_db_password", dbPassword, "ALL")>

<cfscript>
    fileWrite("/opt/hermes/tmp/" & customtrans3 & "_auth_app_passwords.lua", luaConf, "utf-8");
</cfscript>

<cftry>
    <cfexecute name="/usr/bin/dos2unix"
        arguments="/opt/hermes/tmp/#customtrans3#_auth_app_passwords.lua"
        timeout="60" />
<cfcatch type="any">
    <cfset m="generate_dovecot_configuration.cfm: Error running dos2unix on Lua temp file">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>
</cftry>

<cftry>
    <cffile action="copy"
        source="/opt/hermes/tmp/#customtrans3#_auth_app_passwords.lua"
        destination="/etc/dovecot/auth_app_passwords.lua">
<cfcatch type="any">
    <cfset m="generate_dovecot_configuration.cfm: Error copying Lua script to /etc/dovecot/auth_app_passwords.lua">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>
</cftry>

<cftry>
    <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_auth_app_passwords.lua">
<cfcatch type="any">
    <!--- Non-fatal --->
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
