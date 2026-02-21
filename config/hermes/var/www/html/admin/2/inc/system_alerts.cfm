<!---
Hermes Secure Email Gateway - System Alerts Component
Displays system-wide alerts in the top navbar for various conditions:
- License status (expired, revoked, tampered, offline mode, expiring soon)
- System updates available
- Reboot required
- Other system alerts

Usage: <cfinclude template="system_alerts.cfm">
--->

<!--- Initialize alerts array --->
<cfset systemAlerts = []>

<!--- ============================================================================
     LICENSE ALERTS
     ============================================================================ --->
<cfif StructKeyExists(session, "license")>

    <!--- Template tampering (highest priority) --->
    <cfif session.license EQ "TAMPERED">
        <cfset ArrayAppend(systemAlerts, {
            type: "danger",
            icon: "fas fa-exclamation-triangle",
            label: "Templates Modified",
            title: "Template files have been modified. Pro features disabled.",
            priority: 1
        })>
    </cfif>

    <!--- License revoked --->
    <cfif session.license EQ "REVOKED">
        <cfset ArrayAppend(systemAlerts, {
            type: "danger",
            icon: "fas fa-ban",
            label: "License Revoked",
            title: "License has been revoked. Contact support.",
            priority: 2
        })>
    </cfif>

    <!--- License invalid --->
    <cfif session.license EQ "INVALID">
        <cfset ArrayAppend(systemAlerts, {
            type: "danger",
            icon: "fas fa-times-circle",
            label: "Invalid License",
            title: "License is invalid.",
            priority: 3
        })>
    </cfif>

    <!--- Pending validation (server unreachable, no baseline fingerprint) --->
    <cfif session.license EQ "PENDING_VALIDATION">
        <cfset ArrayAppend(systemAlerts, {
            type: "warning",
            icon: "fas fa-cloud-upload-alt",
            label: "Validation Required",
            title: "License server unreachable. Connect to internet and log in again to validate Pro license.",
            priority: 3
        })>
    </cfif>

    <!--- License expired --->
    <cfif session.license EQ "EXPIRED">
        <cfset ArrayAppend(systemAlerts, {
            type: "warning",
            icon: "fas fa-clock",
            label: "License Expired",
            title: "License has expired. Pro features disabled.",
            priority: 4
        })>
    </cfif>

    <!--- Grace period expired --->
    <cfif session.license EQ "GRACE_PERIOD_EXPIRED">
        <cfset ArrayAppend(systemAlerts, {
            type: "danger",
            icon: "fas fa-wifi",
            iconStyle: "opacity:0.5",
            label: "Grace Period Expired",
            title: "Offline grace period expired. Connect to internet and log in again to revalidate.",
            priority: 3
        })>
    </cfif>

    <!--- Offline/cached validation mode (grace period) --->
    <cfif session.license EQ "VALID" AND StructKeyExists(session, "validationMode") AND session.validationMode EQ "cached">
        <cfset offlineTitle = "Validation server unreachable. Using cached license data.">
        <cfif StructKeyExists(session, "gracePeriodRemaining") AND IsNumeric(session.gracePeriodRemaining)>
            <cfset offlineTitle = offlineTitle & " Pro features disabled in " & session.gracePeriodRemaining & " day">
            <cfif session.gracePeriodRemaining NEQ 1>
                <cfset offlineTitle = offlineTitle & "s">
            </cfif>
            <cfset offlineTitle = offlineTitle & ".">
        </cfif>
        <cfset ArrayAppend(systemAlerts, {
            type: "warning",
            icon: "fas fa-wifi",
            iconStyle: "opacity:0.5",
            label: "Offline Mode",
            title: offlineTitle,
            priority: 5
        })>
    </cfif>

    <!--- License expiring soon (30 days or less) --->
    <cfif session.license EQ "VALID"
          AND StructKeyExists(session, "licensevaliddays")
          AND IsNumeric(session.licensevaliddays)
          AND session.licensevaliddays LTE 30
          AND session.licensevaliddays GT 0>
        <cfset ArrayAppend(systemAlerts, {
            type: "info",
            icon: "fas fa-info-circle",
            label: "Expires in " & session.licensevaliddays & " days",
            title: "License expires " & session.licenseexpires,
            priority: 10
        })>
    </cfif>

</cfif>

<!--- ============================================================================
     SYSTEM UPDATE ALERTS
     Check for pending updates (future expansion)
     ============================================================================ --->
<cfif StructKeyExists(session, "updateAvailable") AND session.updateAvailable EQ true>
    <cfset ArrayAppend(systemAlerts, {
        type: "info",
        icon: "fas fa-download",
        label: "Update Available",
        title: "A system update is available. Version: " & session.updateVersion,
        priority: 6
    })>
</cfif>

<!--- ============================================================================
     REBOOT REQUIRED ALERT
     Check if system reboot is needed (future expansion)
     ============================================================================ --->
<cfif StructKeyExists(session, "rebootRequired") AND session.rebootRequired EQ true>
    <cfset ArrayAppend(systemAlerts, {
        type: "warning",
        icon: "fas fa-sync-alt",
        label: "Reboot Required",
        title: "System configuration changes require a reboot to take effect.",
        priority: 7
    })>
</cfif>

<!--- ============================================================================
     CERTIFICATE EXPIRATION ALERTS
     Check for expiring SSL certificates (future expansion)
     ============================================================================ --->
<cfif StructKeyExists(session, "certExpiringSoon") AND session.certExpiringSoon EQ true>
    <cfset ArrayAppend(systemAlerts, {
        type: "warning",
        icon: "fas fa-certificate",
        label: "Cert Expiring",
        title: "SSL certificate expires " & session.certExpirationDate,
        priority: 8
    })>
</cfif>

<!--- ============================================================================
     RENDER ALERTS
     Display all alerts sorted by priority (lower = higher priority)
     ============================================================================ --->
<cfif ArrayLen(systemAlerts) GT 0>
    <!--- Sort by priority (ArraySort modifies in-place, returns boolean) --->
    <cfset ArraySort(systemAlerts, function(a, b) {
        return a.priority - b.priority;
    })>

    <!--- Store in request scope for callout rendering --->
    <cfset request.systemAlerts = systemAlerts>

    <!--- Only show navbar badges for low-priority alerts (priority > 5) --->
    <!--- High-priority alerts are shown as callout banners in top_navbar.cfm --->
    <cfoutput>
    <cfloop array="#systemAlerts#" index="alert">
        <cfif alert.priority GT 5>
        <span class="badge text-bg-#alert.type# ms-2" title="#alert.title#">
            <i class="#alert.icon# me-1"<cfif StructKeyExists(alert, "iconStyle")> style="#alert.iconStyle#"</cfif>></i> #alert.label#
        </span>
        </cfif>
    </cfloop>
    </cfoutput>
</cfif>
