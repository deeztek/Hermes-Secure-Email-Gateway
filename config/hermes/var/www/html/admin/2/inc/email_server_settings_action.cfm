
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

EMAIL SERVER SETTINGS ACTION HANDLER
Saves Nextcloud files/sharing settings via occ commands and stores
the values in parameters2 for UI state persistence.
--->

<cfparam name="form.nc_files_sharing" default="no">
<cfparam name="form.nc_public_links" default="no">

<cfset saveError = false>

<!--- NEXTCLOUD FILE SHARING --->
<cfset ncFileSharingVal = (form.nc_files_sharing EQ "yes") ? "yes" : "no">

<cftry>
    <!--- Update Nextcloud via occ --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ config:app:set files_sharing enabled --value=#ncFileSharingVal#"
        variable="occResult"
        errorVariable="occError"
        timeout="30" />

    <!--- Persist to parameters2 for UI state --->
    <cfquery name="checkParam" datasource="hermes">
        SELECT parameter FROM parameters2
        WHERE module = 'nextcloud' AND parameter = 'files_sharing_enabled'
    </cfquery>
    <cfif checkParam.recordcount GTE 1>
        <cfquery datasource="hermes">
            UPDATE parameters2 SET value2 = <cfqueryparam value="#ncFileSharingVal#" cfsqltype="cf_sql_varchar">
            WHERE module = 'nextcloud' AND parameter = 'files_sharing_enabled'
        </cfquery>
    <cfelse>
        <cfquery datasource="hermes">
            INSERT INTO parameters2 (module, parameter, value2, applied)
            VALUES ('nextcloud', 'files_sharing_enabled',
                    <cfqueryparam value="#ncFileSharingVal#" cfsqltype="cf_sql_varchar">, '2')
        </cfquery>
    </cfif>
<cfcatch type="any">
    <cfset saveError = true>
</cfcatch>
</cftry>

<!--- NEXTCLOUD PUBLIC LINKS --->
<cfset ncPublicLinksVal = (form.nc_public_links EQ "yes") ? "yes" : "no">

<cftry>
    <!--- Update Nextcloud via occ --->
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec -u www-data hermes_nextcloud php /var/www/html/occ config:app:set core shareapi_allow_links --value=#ncPublicLinksVal#"
        variable="occResult2"
        errorVariable="occError2"
        timeout="30" />

    <!--- Persist to parameters2 --->
    <cfquery name="checkParam2" datasource="hermes">
        SELECT parameter FROM parameters2
        WHERE module = 'nextcloud' AND parameter = 'public_links_enabled'
    </cfquery>
    <cfif checkParam2.recordcount GTE 1>
        <cfquery datasource="hermes">
            UPDATE parameters2 SET value2 = <cfqueryparam value="#ncPublicLinksVal#" cfsqltype="cf_sql_varchar">
            WHERE module = 'nextcloud' AND parameter = 'public_links_enabled'
        </cfquery>
    <cfelse>
        <cfquery datasource="hermes">
            INSERT INTO parameters2 (module, parameter, value2, applied)
            VALUES ('nextcloud', 'public_links_enabled',
                    <cfqueryparam value="#ncPublicLinksVal#" cfsqltype="cf_sql_varchar">, '2')
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
