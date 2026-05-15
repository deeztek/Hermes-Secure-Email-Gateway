<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.
This file is part of Hermes Secure Email Gateway Community Edition. [AGPLv3]
--->

<!--- AJAX endpoint for the per-row ARC Enable/Disable form-switch slider in
     view_arc_settings.cfm. Mirrors the toggle_ofelia_job_action.cfm pattern
     used by view_scheduled_tasks.cfm.

     Expects POST:
       key_id     -- arc_sign.id
       new_state  -- '1' (enable) or '0' (disable)

     Returns JSON:
       {"success": true}
       {"success": false, "error": "..."}

     Side effects on success: updates arc_sign.enabled, regenerates
     /etc/openarc/openarc.conf via arc_generate_config_file.cfm, restarts
     hermes_openarc, then marks arc_sign.applied=1 if enabling. --->

<cfheader name="Content-Type" value="application/json">

<cfparam name="form.key_id"    default="">
<cfparam name="form.new_state" default="">

<cfif form.key_id IS "" OR NOT IsNumeric(form.key_id)>
    <cfoutput>{"success": false, "error": "missing or invalid key_id"}</cfoutput>
    <cfabort>
</cfif>

<cfif NOT ListFind("0,1", form.new_state)>
    <cfoutput>{"success": false, "error": "new_state must be 0 or 1"}</cfoutput>
    <cfabort>
</cfif>

<cftry>
    <cfquery datasource="hermes">
        UPDATE arc_sign
           SET enabled = <cfqueryparam value="#form.new_state#" CFSQLType="CF_SQL_VARCHAR">,
               applied = '0'
         WHERE id = <cfqueryparam value="#form.key_id#" CFSQLType="CF_SQL_INTEGER">
    </cfquery>

    <!--- Auto-sync global ARC settings to match the slider state. Without
         this, the admin would have to manually align ARC Enabled + Mode
         in the Global Settings card after every slider toggle.

         Slider ON:
           - arc_signing_enabled -> '1'  (master kill-switch on)
           - arc_mode            -> 'sv' (sign+verify). If admin explicitly
                                   chose 's' (sign only), preserve it.
                                   If already 'sv', no change.

         Slider OFF:
           - arc_mode            -> 'v'  (no key to sign with -> verify only)
           - arc_signing_enabled : untouched (admin may still want
                                   verification running; the master kill-
                                   switch in the Global Settings card is
                                   their lever to fully disable ARC).
    --->
    <cfif form.new_state IS "1">
        <cfquery datasource="hermes">
            UPDATE system_settings SET value = '1'
             WHERE parameter = 'arc_signing_enabled'
        </cfquery>
        <cfquery datasource="hermes">
            UPDATE system_settings SET value = 'sv'
             WHERE parameter = 'arc_mode' AND value = 'v'
        </cfquery>
    <cfelse>
        <cfquery datasource="hermes">
            UPDATE system_settings SET value = 'v'
             WHERE parameter = 'arc_mode'
        </cfquery>
    </cfif>

    <cfinclude template="arc_generate_config_file.cfm">
    <cfinclude template="restart_openarc.cfm">

    <cfif form.new_state IS "1">
        <cfquery datasource="hermes">
            UPDATE arc_sign SET applied = '1' WHERE enabled = '1'
        </cfquery>
    </cfif>

    <!--- Always reload so both Mode and ARC Enabled dropdowns visually
         reflect the synced state regardless of toggle direction. --->
    <cfoutput>{"success": true, "reload": true}</cfoutput>

    <cfcatch type="any">
        <cfset errMsg = cfcatch.message>
        <cfset errMsg = Replace(errMsg, '"', '\"', 'ALL')>
        <cfset errMsg = Replace(errMsg, Chr(10), ' ', 'ALL')>
        <cfset errMsg = Replace(errMsg, Chr(13), ' ', 'ALL')>
        <cfoutput>{"success": false, "error": "#errMsg#"}</cfoutput>
    </cfcatch>
</cftry>
