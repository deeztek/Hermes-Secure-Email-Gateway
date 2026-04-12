
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

EMAIL SERVER SETTINGS ACTION HANDLER
Saves Nextcloud webmail settings via occ commands and config.php
regeneration, and stores the values in parameters2 for UI state.
--->

<cfparam name="form.nc_files_app" default="yes">
<cfparam name="form.nc_password_form" default="no">

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

<!--- RESULT --->
<cfif saveError>
    <cfset session.m = 10>
<cfelse>
    <cfset session.m = 1>
</cfif>
<cflocation url="view_email_server_settings.cfm" addtoken="no">
