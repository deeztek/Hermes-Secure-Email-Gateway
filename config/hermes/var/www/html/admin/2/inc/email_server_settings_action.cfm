
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

EMAIL SERVER SETTINGS ACTION HANDLER
Saves Nextcloud webmail settings (via occ commands), Dovecot mail server
settings (to parameters2 module='dovecot'), and the TLS certificate
(to parameters2 module='certificates'). After saving, regenerates
dovecot.conf from template and reloads Dovecot.
--->

<cfparam name="form.nc_auto_redirect" default="false">
<cfparam name="form.dovecot_cert_id" default="">
<cfparam name="form.ssl_profile" default="intermediate">
<cfparam name="form.ssl_min_protocol" default="TLSv1.2">
<cfparam name="form.ssl_cipher_list" default="">

<!--- Translate TLS profile presets into actual values.
     Disabled fields aren't submitted by the browser, so the cfparam
     defaults above would be used. Override with the correct values
     based on the selected profile. --->
<cfswitch expression="#form.ssl_profile#">
    <cfcase value="modern">
        <cfset form.ssl_min_protocol = "TLSv1.3">
        <cfset form.ssl_cipher_list = "">
    </cfcase>
    <cfcase value="intermediate">
        <cfset form.ssl_min_protocol = "TLSv1.2">
        <cfset form.ssl_cipher_list = "ECDHE+AESGCM:ECDHE+CHACHA20:DHE+AESGCM:DHE+CHACHA20:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4">
    </cfcase>
    <cfcase value="legacy">
        <cfset form.ssl_min_protocol = "TLSv1.2">
        <cfset form.ssl_cipher_list = "ALL:!DH:!kRSA:!SRP:!kDHd:!DSS:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH">
    </cfcase>
    <!--- custom: use form values as submitted --->
</cfswitch>
<cfparam name="form.mail_compression" default="yes">
<cfparam name="form.compression_algorithm" default="lz4">
<cfparam name="form.compression_level" default="3">
<cfparam name="form.mail_encryption" default="no">
<cfparam name="form.encryption_curve" default="prime256v1">
<cfparam name="form.protocol_imap" default="yes">
<cfparam name="form.protocol_pop3" default="yes">
<cfparam name="form.quota_warning_critical" default="99">
<cfparam name="form.quota_warning_high" default="95">
<cfparam name="form.quota_warning_medium" default="80">
<cfparam name="form.quota_trash_percentage" default="110">
<cfparam name="form.connection_client_limit" default="1000">
<cfparam name="form.connection_max_userip" default="20">
<cfparam name="form.logging_debug" default="no">

<cfset saveError = false>
<cfset saveErrors = ArrayNew(1)>

<!--- ================================================================== --->
<!--- NEXTCLOUD OIDC AUTO-REDIRECT                                        --->
<!--- ================================================================== --->
<cfset ncAutoRedirectVal = (form.nc_auto_redirect EQ "true") ? "true" : "false">

<cftry>
    <!--- Persist to parameters2 --->
    <cfquery name="checkParam3" datasource="hermes">
        SELECT parameter FROM parameters2
        WHERE module = 'nextcloud' AND parameter = 'oidc.auto_redirect'
    </cfquery>
    <cfif checkParam3.recordcount GTE 1>
        <cfquery datasource="hermes">
            UPDATE parameters2 SET value2 = <cfqueryparam value="#ncAutoRedirectVal#" cfsqltype="cf_sql_varchar">
            WHERE module = 'nextcloud' AND parameter = 'oidc.auto_redirect'
        </cfquery>
    <cfelse>
        <cfquery datasource="hermes">
            INSERT INTO parameters2 (module, parameter, value2, applied)
            VALUES ('nextcloud', 'oidc.auto_redirect',
                    <cfqueryparam value="#ncAutoRedirectVal#" cfsqltype="cf_sql_varchar">, '2')
        </cfquery>
    </cfif>

    <!--- Apply via occ: allow_multiple_user_backends=0 means auto-redirect,
         =1 means show login form with SSO button. Admin bypass: ?direct=1 --->
    <cfset occBackendVal = (ncAutoRedirectVal EQ "true") ? "0" : "1">
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ config:app:set --type=string --value=#occBackendVal# user_oidc allow_multiple_user_backends"
        variable="occAutoRedirectResult"
        errorVariable="occAutoRedirectError"
        timeout="30" />

<cfcatch type="any">
    <cfset saveError = true>
    <cfset ArrayAppend(saveErrors, "Nextcloud Auto-Redirect: " & cfcatch.message)>
</cfcatch>
</cftry>

<!--- ================================================================== --->
<!--- NEXTCLOUD HIDE LOGIN FORM                                            --->
<!--- ================================================================== --->
<cfparam name="form.nc_hide_login_form" default="false">
<cfset ncHideLoginFormVal = (form.nc_hide_login_form EQ "true") ? "true" : "false">

<cftry>
    <cfquery name="checkHideForm" datasource="hermes">
        SELECT parameter FROM parameters2
        WHERE module = 'nextcloud' AND parameter = 'hide.login.form'
    </cfquery>
    <cfif checkHideForm.recordcount GTE 1>
        <cfquery datasource="hermes">
            UPDATE parameters2 SET value2 = <cfqueryparam value="#ncHideLoginFormVal#" cfsqltype="cf_sql_varchar">
            WHERE module = 'nextcloud' AND parameter = 'hide.login.form'
        </cfquery>
    <cfelse>
        <cfquery datasource="hermes">
            INSERT INTO parameters2 (module, parameter, value2, applied)
            VALUES ('nextcloud', 'hide.login.form',
                    <cfqueryparam value="#ncHideLoginFormVal#" cfsqltype="cf_sql_varchar">, '2')
        </cfquery>
    </cfif>

    <!--- Regenerate NC config.php to apply the setting --->
    <cfinclude template="generate_nextcloud_configuration.cfm">

<cfcatch type="any">
    <cfset saveError = true>
    <cfset ArrayAppend(saveErrors, "Nextcloud Hide Login Form: " & cfcatch.message)>
</cfcatch>
</cftry>

<!--- ================================================================== --->
<!--- DOVECOT TLS CERTIFICATE (parameters2 module='certificates')         --->
<!--- ================================================================== --->
<cfif trim(form.dovecot_cert_id) NEQ "" AND IsNumeric(form.dovecot_cert_id)>
    <cftry>
        <cfquery name="verifyCert" datasource="hermes">
            SELECT id, friendly_name FROM system_certificates
            WHERE id = <cfqueryparam value="#form.dovecot_cert_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif verifyCert.recordcount GTE 1>
            <cfquery name="checkCertParam" datasource="hermes">
                SELECT parameter FROM parameters2
                WHERE module = 'certificates' AND parameter = 'mail.certificate'
            </cfquery>
            <cfif checkCertParam.recordcount GTE 1>
                <cfquery datasource="hermes">
                    UPDATE parameters2 SET value2 = <cfqueryparam value="#form.dovecot_cert_id#" cfsqltype="cf_sql_varchar">
                    WHERE module = 'certificates' AND parameter = 'mail.certificate'
                </cfquery>
            <cfelse>
                <cfquery datasource="hermes">
                    INSERT INTO parameters2 (module, parameter, value2, applied)
                    VALUES ('certificates', 'mail.certificate',
                            <cfqueryparam value="#form.dovecot_cert_id#" cfsqltype="cf_sql_varchar">, '2')
                </cfquery>
            </cfif>
        </cfif>
    <cfcatch type="any">
        <cfset saveError = true>
        <cfset ArrayAppend(saveErrors, "Dovecot TLS Certificate: " & cfcatch.message)>
    </cfcatch>
    </cftry>
</cfif>

<!--- ================================================================== --->
<!--- MAIL ENCRYPTION KEY GENERATION (if enabling and keys don't exist)   --->
<!--- ================================================================== --->
<cfif form.mail_encryption EQ "yes">
    <!--- Generate keys if missing or empty (0 bytes = failed previous attempt) --->
    <cfset needKeys = NOT FileExists("/opt/hermes/keys/ecprivkey.pem")
                   OR NOT FileExists("/opt/hermes/keys/ecpubkey.pem")
                   OR (FileExists("/opt/hermes/keys/ecprivkey.pem") AND FileInfo("/opt/hermes/keys/ecprivkey.pem").size EQ 0)
                   OR (FileExists("/opt/hermes/keys/ecpubkey.pem") AND FileInfo("/opt/hermes/keys/ecpubkey.pem").size EQ 0)>
    <cfif needKeys>
        <cftry>
            <cfset keyCurve = form.encryption_curve>
            <cfinclude template="generate_mail_crypt_keys.cfm">
            <cfif keyGenResult EQ "error">
                <cfset saveError = true>
                <cfset ArrayAppend(saveErrors, "Encryption Key Generation: " & keyGenError)>
            </cfif>
        <cfcatch type="any">
            <cfset saveError = true>
            <cfset ArrayAppend(saveErrors, "Encryption Key Generation: " & cfcatch.message)>
        </cfcatch>
        </cftry>
    </cfif>
</cfif>

<!--- ================================================================== --->
<!--- DOVECOT SETTINGS (parameters2 module='dovecot')                     --->
<!--- ================================================================== --->
<!--- Validate and sanitize inputs before saving --->

<!--- Whitelist-validate select fields --->
<cfset validAlgorithms = "lz4,zstd,zlib">
<cfset validCurves = "prime256v1,secp384r1,secp521r1">
<cfset validTlsVersions = "TLSv1.2,TLSv1.3">

<cfif NOT ListFindNoCase(validAlgorithms, form.compression_algorithm)>
    <cfset form.compression_algorithm = "lz4">
</cfif>
<cfif NOT ListFindNoCase(validCurves, form.encryption_curve)>
    <cfset form.encryption_curve = "prime256v1">
</cfif>
<cfif NOT ListFindNoCase(validTlsVersions, form.ssl_min_protocol)>
    <cfset form.ssl_min_protocol = "TLSv1.2">
</cfif>

<!--- Clamp numeric values --->
<cfset form.compression_level = max(1, min(22, val(form.compression_level)))>
<cfset form.quota_warning_critical = max(1, min(100, val(form.quota_warning_critical)))>
<cfset form.quota_warning_high = max(1, min(100, val(form.quota_warning_high)))>
<cfset form.quota_warning_medium = max(1, min(100, val(form.quota_warning_medium)))>
<cfset form.quota_trash_percentage = max(100, min(200, val(form.quota_trash_percentage)))>
<cfset form.connection_client_limit = max(100, min(10000, val(form.connection_client_limit)))>
<cfset form.connection_max_userip = max(1, min(1000, val(form.connection_max_userip)))>

<!--- Enforce zlib max level of 9 --->
<cfif form.compression_algorithm EQ "zlib" AND form.compression_level GT 9>
    <cfset form.compression_level = 6>
</cfif>

<!--- Boolean fields --->
<cfset form.mail_compression = (form.mail_compression EQ "yes") ? "yes" : "no">
<cfset form.mail_encryption = (form.mail_encryption EQ "yes") ? "yes" : "no">
<cfset form.protocol_imap = (form.protocol_imap EQ "yes") ? "yes" : "no">
<cfset form.protocol_pop3 = (form.protocol_pop3 EQ "yes") ? "yes" : "no">
<cfset form.logging_debug = (form.logging_debug EQ "yes") ? "yes" : "no">

<!--- Build a struct of parameter name -> value for batch upsert --->
<cfset dovSettings = StructNew()>
<cfset dovSettings['mail.compression'] = form.mail_compression>
<cfset dovSettings['mail.compression_algorithm'] = form.compression_algorithm>
<cfset dovSettings['mail.compression_level'] = form.compression_level>
<cfset dovSettings['mail.encryption'] = form.mail_encryption>
<cfset dovSettings['mail.encryption_curve'] = form.encryption_curve>
<cfset dovSettings['protocol.imap'] = form.protocol_imap>
<cfset dovSettings['protocol.pop3'] = form.protocol_pop3>
<cfset dovSettings['ssl.min_protocol'] = form.ssl_min_protocol>
<cfset dovSettings['ssl.cipher_list'] = trim(form.ssl_cipher_list)>
<cfset dovSettings['quota.warning_critical'] = form.quota_warning_critical>
<cfset dovSettings['quota.warning_high'] = form.quota_warning_high>
<cfset dovSettings['quota.warning_medium'] = form.quota_warning_medium>
<cfset dovSettings['quota.trash_percentage'] = form.quota_trash_percentage>
<cfset dovSettings['connection.client_limit'] = form.connection_client_limit>
<cfset dovSettings['connection.max_userip'] = form.connection_max_userip>
<cfset dovSettings['logging.debug'] = form.logging_debug>

<!--- Upsert each dovecot setting --->
<cftry>
    <cfloop collection="#dovSettings#" item="paramName">
        <cfquery name="checkDovParam" datasource="hermes">
            SELECT parameter FROM parameters2
            WHERE module = 'dovecot' AND parameter = <cfqueryparam value="#paramName#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif checkDovParam.recordcount GTE 1>
            <cfquery datasource="hermes">
                UPDATE parameters2
                SET value2 = <cfqueryparam value="#dovSettings[paramName]#" cfsqltype="cf_sql_varchar">
                WHERE module = 'dovecot' AND parameter = <cfqueryparam value="#paramName#" cfsqltype="cf_sql_varchar">
            </cfquery>
        <cfelse>
            <cfquery datasource="hermes">
                INSERT INTO parameters2 (module, parameter, value2, applied)
                VALUES ('dovecot',
                        <cfqueryparam value="#paramName#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#dovSettings[paramName]#" cfsqltype="cf_sql_varchar">,
                        '2')
            </cfquery>
        </cfif>
    </cfloop>
<cfcatch type="any">
    <cfset saveError = true>
    <cfset ArrayAppend(saveErrors, "Dovecot Settings DB: " & cfcatch.message)>
</cfcatch>
</cftry>

<!--- ================================================================== --->
<!--- REGENERATE DOVECOT CONFIGURATION FROM TEMPLATE                      --->
<!--- ================================================================== --->
<cfif NOT saveError>
    <cftry>
        <cfinclude template="generate_dovecot_configuration.cfm">
    <cfcatch type="any">
        <cfset saveError = true>
        <cfset ArrayAppend(saveErrors, "Dovecot Config Regeneration: " & cfcatch.message)>
    </cfcatch>
    </cftry>
</cfif>

<!--- RESULT --->
<cfif saveError>
    <cfset session.m = 10>
    <cfset session.saveErrors = saveErrors>
<cfelse>
    <cfset session.m = 1>
</cfif>
<cflocation url="view_email_server_settings.cfm" addtoken="no">
