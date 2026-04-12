
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

EMAIL SERVER SETTINGS ACTION HANDLER
Saves Nextcloud webmail settings via occ commands and config.php
regeneration, and stores the values in parameters2 for UI state.
--->

<cfparam name="form.nc_files_app" default="yes">
<cfparam name="form.nc_password_form" default="no">
<cfparam name="form.dovecot_cert_id" default="">

<cfset saveError = false>

<!--- NEXTCLOUD FILES APP VISIBILITY --->
<cfset ncFilesAppVal = (form.nc_files_app EQ "yes") ? "yes" : "no">

<cftry>
    <!--- Enable or disable the files_sharing app in Nextcloud.
         When disabled, the Files app is still technically present (it's
         a core NC app and can't be fully removed) but sharing functionality
         is removed which effectively hides the Files icon from the nav
         for most use cases. --->
    <cfif ncFilesAppVal EQ "yes">
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ app:enable files_sharing"
            variable="occResult"
            errorVariable="occError"
            timeout="30" />
    <cfelse>
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ app:disable files_sharing"
            variable="occResult"
            errorVariable="occError"
            timeout="30" />
    </cfif>

    <!--- Persist to parameters2 for UI state --->
    <cfquery name="checkParam1" datasource="hermes">
        SELECT parameter FROM parameters2
        WHERE module = 'nextcloud' AND parameter = 'files_app_visible'
    </cfquery>
    <cfif checkParam1.recordcount GTE 1>
        <cfquery datasource="hermes">
            UPDATE parameters2 SET value2 = <cfqueryparam value="#ncFilesAppVal#" cfsqltype="cf_sql_varchar">
            WHERE module = 'nextcloud' AND parameter = 'files_app_visible'
        </cfquery>
    <cfelse>
        <cfquery datasource="hermes">
            INSERT INTO parameters2 (module, parameter, value2, applied)
            VALUES ('nextcloud', 'files_app_visible',
                    <cfqueryparam value="#ncFilesAppVal#" cfsqltype="cf_sql_varchar">, '2')
        </cfquery>
    </cfif>
<cfcatch type="any">
    <cfset saveError = true>
</cfcatch>
</cftry>

<!--- NEXTCLOUD PASSWORD FORM VISIBILITY --->
<cfset ncPasswordFormVal = (form.nc_password_form EQ "yes") ? "yes" : "no">

<!--- This controls oidc_login_hide_password_form in config.php.
     The value is inverted: "show password form = yes" means
     hide_password_form = false, and vice versa. --->
<cfset hidePasswordForm = (ncPasswordFormVal EQ "yes") ? "false" : "true">

<cftry>
    <!--- Update Nextcloud config.php via occ --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ config:system:set oidc_login_hide_password_form --value=#hidePasswordForm# --type=boolean"
        variable="occResult2"
        errorVariable="occError2"
        timeout="30" />

    <!--- Persist to parameters2 --->
    <cfquery name="checkParam2" datasource="hermes">
        SELECT parameter FROM parameters2
        WHERE module = 'nextcloud' AND parameter = 'show_password_form'
    </cfquery>
    <cfif checkParam2.recordcount GTE 1>
        <cfquery datasource="hermes">
            UPDATE parameters2 SET value2 = <cfqueryparam value="#ncPasswordFormVal#" cfsqltype="cf_sql_varchar">
            WHERE module = 'nextcloud' AND parameter = 'show_password_form'
        </cfquery>
    <cfelse>
        <cfquery datasource="hermes">
            INSERT INTO parameters2 (module, parameter, value2, applied)
            VALUES ('nextcloud', 'show_password_form',
                    <cfqueryparam value="#ncPasswordFormVal#" cfsqltype="cf_sql_varchar">, '2')
        </cfquery>
    </cfif>
<cfcatch type="any">
    <cfset saveError = true>
</cfcatch>
</cftry>

<!--- DOVECOT TLS CERTIFICATE --->
<cfif trim(form.dovecot_cert_id) NEQ "" AND IsNumeric(form.dovecot_cert_id)>
    <cftry>
        <!--- Verify the cert exists --->
        <cfquery name="verifyCert" datasource="hermes">
            SELECT id, friendly_name FROM system_certificates
            WHERE id = <cfqueryparam value="#form.dovecot_cert_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif verifyCert.recordcount GTE 1>
            <!--- Persist to parameters2 --->
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

            <!--- Get the cert's Let's Encrypt path or imported path to
                 update dovecot.conf's ssl_server block. The cert file
                 paths follow the Let's Encrypt convention:
                 /etc/letsencrypt/live/<domain>/fullchain.pem
                 /etc/letsencrypt/live/<domain>/privkey.pem
                 For imported certs, the path is stored differently.
                 We need to look up the cert's associated domain to
                 construct the path. --->
            <cfquery name="getCertDomain" datasource="hermes">
                SELECT friendly_name FROM system_certificates
                WHERE id = <cfqueryparam value="#form.dovecot_cert_id#" cfsqltype="cf_sql_integer">
            </cfquery>

            <cfset certDomain = getCertDomain.friendly_name>
            <cfset certPath = "/etc/letsencrypt/live/" & certDomain & "/fullchain.pem">
            <cfset keyPath = "/etc/letsencrypt/live/" & certDomain & "/privkey.pem">

            <!--- Update dovecot.conf ssl_server block using sed.
                 IMPORTANT: target only the ssl_server block's cert/key
                 lines, NOT the mail_crypt key lines. The ssl_server block
                 uses "cert_file" and the line below it uses "key_file".
                 The mail_crypt block uses "crypt_private_key_file" and
                 "crypt_global_public_key_file" so there's no collision
                 on "cert_file". However "key_file" appears in both
                 ssl_server and crypt blocks. Use sed with the ssl_server
                 block context to target only the SSL key_file.
                 Full dovecot.conf templating is planned for a future
                 release to avoid this fragile approach. --->
            <cftry>
                <!--- Also update the host-mounted config file so changes
                     survive container recreation --->
                <cffile action="read" file="/etc/dovecot/dovecot.conf" variable="dovecotConf" charset="utf-8">
                <cfset dovecotConf = REReplace(dovecotConf, "(ssl_server\s*\{[^}]*?)cert_file\s*=\s*[^\n]+", "\1cert_file = #certPath#", "ALL")>
                <cfset dovecotConf = REReplace(dovecotConf, "(ssl_server\s*\{[^}]*?)key_file\s*=\s*[^\n]+", "\1key_file = #keyPath#", "ALL")>
                <cffile action="write" file="/etc/dovecot/dovecot.conf" output="#dovecotConf#" charset="utf-8" addNewLine="no">

                <!--- Reload Dovecot to pick up the new certificate --->
                <cfexecute name="/usr/local/bin/docker"
                    arguments="exec hermes_dovecot doveadm reload"
                    variable="reloadResult"
                    errorVariable="reloadError"
                    timeout="30" />
            <cfcatch type="any">
                <cfset saveError = true>
            </cfcatch>
            </cftry>
        </cfif>
    <cfcatch type="any">
        <cfset saveError = true>
    </cfcatch>
    </cftry>
</cfif>

<!--- RESULT --->
<cfif saveError>
    <cfset session.m = 10>
<cfelse>
    <cfset session.m = 1>
</cfif>
<cflocation url="view_email_server_settings.cfm" addtoken="no">
