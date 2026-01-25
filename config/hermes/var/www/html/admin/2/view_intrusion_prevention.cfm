<!DOCTYPE html>

  <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hermes SEG | Intrusion Prevention</title>

<cfinclude template="./inc/html_head.cfm" />

<!--- DataTable Script --->
<script>
$(document).ready(function() {
    $('#bannedTable').DataTable({
        dom: 'Blfrtip',
        buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
        stateSave: true,
        lengthMenu: [
            [25, 50, 100, -1],
            ['25 rows', '50 rows', '100 rows', 'Show all']
        ],
        "order": [[4, "desc"]]
    });

    $('#whitelistTable').DataTable({
        dom: 'Blfrtip',
        buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
        stateSave: true,
        lengthMenu: [
            [25, 50, 100, -1],
            ['25 rows', '50 rows', '100 rows', 'Show all']
        ],
        "order": [[1, "asc"]]
    });

    // Select all checkboxes for banned IPs
    $('#selectAllBanned').click(function() {
        $('.banned-checkbox').prop('checked', this.checked);
    });

    // Select all checkboxes for whitelist
    $('#selectAllWhitelist').click(function() {
        $('.whitelist-checkbox').prop('checked', this.checked);
    });

    // Unban button handler
    $("#unbanBtn").click(function() {
        var unbanIps = [];
        $.each($("input[name='banned_ip']:checked"), function() {
            unbanIps.push($(this).val());
        });
        if(unbanIps.length > 0) {
            $('#unbanIps').val(unbanIps.join(','));
            $('#unban_modal').modal('show');
        } else {
            alert('Please select at least one IP address to unban.');
        }
    });

    // Delete whitelist button handler
    $("#deleteWhitelistBtn").click(function() {
        var deleteIds = [];
        $.each($("input[name='whitelist_id']:checked"), function() {
            deleteIds.push($(this).val());
        });
        if(deleteIds.length > 0) {
            $('#deleteWhitelistIds').val(deleteIds.join(','));
            $('#delete_whitelist_modal').modal('show');
        } else {
            alert('Please select at least one IP/CIDR to delete.');
        }
    });
});
</script>

<style>
.alert a {
    color: #fff;
    text-decoration: none;
}
#btn-back-to-top {
    position: fixed;
    bottom: 20px;
    right: 20px;
    display: none;
}
.settings-label {
    font-weight: 600;
    color: #495057;
}
.settings-value {
    color: #212529;
}
.badge-pending {
    background-color: #ffc107;
    color: #212529;
}
.badge-synced {
    background-color: #28a745;
    color: #fff;
}
.stat-card {
    text-align: center;
    padding: 15px;
}
.stat-card .stat-value {
    font-size: 2rem;
    font-weight: bold;
}
.stat-card .stat-label {
    font-size: 0.9rem;
    color: #6c757d;
}
</style>

</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

<cfinclude template="./inc/top_navbar.cfm" />
<cfinclude template="./inc/main_sidebar.cfm" />

<!-- Content Wrapper. Contains page content -->
<main class="app-main">
<!-- Content Header (Page header) -->
<div class="content-header">
    <div class="container-fluid">
        <div class="row mb-2">
            <div class="col-sm-6">
                <h1 class="m-0">Intrusion Prevention</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="#">Home</a></li>
                    <li class="breadcrumb-item"><a href="#">System</a></li>
                    <li class="breadcrumb-item active">Intrusion Prevention</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<!-- Main content -->
<div class="content">
<div class="container-fluid">

<!--- LICENSE CHECK --->
<cfinclude template="./inc/lc2.cfm" />

<!--- PRO EDITION CHECK --->
<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <div class="alert alert-danger" style="display: inline-block; text-align: center;">
        <i class="fa fa-exclamation-triangle fa-5x"></i>
        <p>Intrusion Prevention is only available with a valid Hermes SEG Pro License. Please contact sales@deeztek.com to obtain a valid Hermes SEG Pro License.</p>
    </div>
    <cfinclude template="./inc/main_footer.cfm" />
    </div>
    </main>
    </div>
    </body>
    </html>
    <cfabort>
</cfif>

<!-- Back to top button -->
<button type="button" class="btn btn-danger btn-floating btn-lg" id="btn-back-to-top">
    <i class="fas fa-arrow-up"></i>
</button>

<!--- Generate container IPs file for fail2ban API notify script --->
<!--- This file is read by hermes-api-notify.sh which can't use Docker DNS in host network mode --->
<cfinclude template="./inc/generate_container_ips.cfm">

<!--- Initialize variables --->
<cfparam name="m" default="0">
<cfparam name="action" default="">

<cfif StructKeyExists(session, "m")>
    <cfif session.m NEQ "">
        <cfset m = session.m>
    </cfif>
</cfif>

<cfif IsDefined("form.action")>
    <cfif form.action NEQ "">
        <cfset action = form.action>
    </cfif>
</cfif>

<!--- HANDLE FORM ACTIONS --->

<!--- Set Intrusion Prevention Status via dropdown --->
<cfif action EQ "set_ip_status">
    <cfif NOT StructKeyExists(form, "ip_status")>
        <cfset session.m = "ip_error">
        <cflocation url="view_intrusion_prevention.cfm" addtoken="no">
    </cfif>

    <cfif form.ip_status EQ "enabled">
        <cfset newValue = "1">
    <cfelseif form.ip_status EQ "disabled">
        <cfset newValue = "0">
    <cfelse>
        <cfset session.m = "ip_error">
        <cflocation url="view_intrusion_prevention.cfm" addtoken="no">
    </cfif>

    <!--- Check if status actually changed --->
    <cfquery name="getCurrentEnabled" datasource="hermes">
        SELECT setting_value FROM intrusion_prevention_settings WHERE setting_name = 'enabled'
    </cfquery>

    <cfif getCurrentEnabled.setting_value NEQ newValue>
        <cfquery name="updateEnabled" datasource="hermes">
            UPDATE intrusion_prevention_settings SET setting_value = <cfqueryparam value="#newValue#" cfsqltype="cf_sql_varchar">
            WHERE setting_name = 'enabled'
        </cfquery>

        <!--- If disabling, unban all IPs and clear database --->
        <cfif newValue EQ "0">
            <cftry>
                <!--- Get all enabled jails from database --->
                <cfquery name="getEnabledJails" datasource="hermes">
                    SELECT jail_name FROM intrusion_prevention_jails WHERE enabled = 1
                </cfquery>

                <!--- For each jail, get banned IPs directly from fail2ban and unban them --->
                <cfloop query="getEnabledJails">
                    <cftry>
                        <!--- Get list of banned IPs for this jail from fail2ban --->
                        <cfexecute name="/usr/local/bin/docker"
                            arguments="exec hermes_fail2ban fail2ban-client status #getEnabledJails.jail_name#"
                            variable="jailStatus"
                            errorVariable="jailStatusError"
                            timeout="30">
                        </cfexecute>

                        <!--- Parse banned IP list from output --->
                        <!--- Format: "   Banned IP list:	1.2.3.4 5.6.7.8" --->
                        <cfset bannedIPLine = "">
                        <cfloop list="#jailStatus#" delimiters="#chr(10)#" index="line">
                            <cfif FindNoCase("Banned IP list:", line)>
                                <cfset bannedIPLine = trim(listLast(line, ":"))>
                            </cfif>
                        </cfloop>

                        <!--- Unban each IP found --->
                        <cfif len(bannedIPLine)>
                            <cfloop list="#bannedIPLine#" delimiters=" " index="bannedIP">
                                <cfset bannedIP = trim(bannedIP)>
                                <cfif len(bannedIP)>
                                    <cftry>
                                        <cfexecute name="/usr/local/bin/docker"
                                            arguments="exec hermes_fail2ban fail2ban-client set #getEnabledJails.jail_name# unbanip #bannedIP#"
                                            variable="unbanResult"
                                            errorVariable="unbanError"
                                            timeout="30">
                                        </cfexecute>
                                    <cfcatch type="any">
                                        <!--- Continue even if individual unban fails --->
                                    </cfcatch>
                                    </cftry>
                                </cfif>
                            </cfloop>
                        </cfif>

                    <cfcatch type="any">
                        <!--- Continue to next jail even if this one fails --->
                    </cfcatch>
                    </cftry>
                </cfloop>

                <!--- Clear all entries from fail2ban_ips table --->
                <cfquery name="clearBannedIPs" datasource="hermes">
                    DELETE FROM fail2ban_ips
                </cfquery>

            <cfcatch type="any">
                <!--- Log error but continue with disable --->
            </cfcatch>
            </cftry>
        </cfif>

        <!--- Mark config as unsynced so Apply Settings appears --->
        <cfquery name="markUnsynced" datasource="hermes">
            UPDATE intrusion_prevention_settings SET setting_value = '0' WHERE setting_name = 'config_synced'
        </cfquery>
        <cfif newValue EQ "1">
            <cfset session.m = "ip_enabled">
        <cfelse>
            <cfset session.m = "ip_disabled">
        </cfif>
    </cfif>
    <cflocation url="view_intrusion_prevention.cfm" addtoken="no">
</cfif>

<!--- Update Jail Settings --->
<cfif action EQ "update_jail">
    <cfif StructKeyExists(form, "jail_id") AND StructKeyExists(form, "jail_enabled") AND StructKeyExists(form, "maxretry") AND StructKeyExists(form, "findtime") AND StructKeyExists(form, "bantime")>
        <cftry>
            <cfquery name="updateJail" datasource="hermes">
                UPDATE intrusion_prevention_jails SET
                    enabled = <cfqueryparam value="#val(form.jail_enabled)#" cfsqltype="cf_sql_integer">,
                    maxretry = <cfqueryparam value="#val(form.maxretry)#" cfsqltype="cf_sql_integer">,
                    findtime = <cfqueryparam value="#val(form.findtime)#" cfsqltype="cf_sql_integer">,
                    bantime = <cfqueryparam value="#val(form.bantime)#" cfsqltype="cf_sql_integer">,
                    config_synced = 0
                WHERE id = <cfqueryparam value="#val(form.jail_id)#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfquery name="markUnsynced" datasource="hermes">
                UPDATE intrusion_prevention_settings SET setting_value = '0' WHERE setting_name = 'config_synced'
            </cfquery>
            <cfset session.m = "ip_jail_updated">
        <cfcatch type="any">
            <cfset session.m = "ip_error">
        </cfcatch>
        </cftry>
    <cfelse>
        <cfset session.m = "ip_error">
    </cfif>
    <cflocation url="view_intrusion_prevention.cfm" addtoken="no">
</cfif>

<!--- Apply Changes (Sync to fail2ban) --->
<cfif action EQ "apply_changes">
    <cfinclude template="./inc/intrusion_prevention_generate_config.cfm">
    <cfif ipSyncSuccess>
        <cfset session.m = "ip_sync">
    <cfelse>
        <cfset session.m = "ip_sync_error">
        <cfset session.syncError = ipSyncError>
    </cfif>
    <cflocation url="view_intrusion_prevention.cfm" addtoken="no">
</cfif>

<!--- Add Whitelist Entry --->
<cfif action EQ "add_whitelist">
    <cfif StructKeyExists(form, "whitelist_ip") AND len(trim(form.whitelist_ip))>
        <cfset ipInput = trim(form.whitelist_ip)>
        <cfset isValidIP = false>

        <!--- Check if input contains CIDR notation --->
        <cfif Find("/", ipInput)>
            <!--- Split IP and CIDR prefix --->
            <cfset ipPart = listFirst(ipInput, "/")>
            <cfset cidrPart = listLast(ipInput, "/")>

            <!--- Validate CIDR prefix is numeric --->
            <cfif isNumeric(cidrPart)>
                <cfset cidrNum = val(cidrPart)>

                <!--- Check for IPv4 CIDR (0-32) --->
                <cfinclude template="./inc/validate_ip_address.cfm">
                <cfif REFind(pattern, ipPart) GT 0 AND cidrNum GTE 0 AND cidrNum LTE 32>
                    <cfset isValidIP = true>
                <cfelse>
                    <!--- Check for IPv6 CIDR (0-128) --->
                    <cfinclude template="./inc/validate_ip_address_ipv6.cfm">
                    <cfif REFind(pattern, ipPart) GT 0 AND cidrNum GTE 0 AND cidrNum LTE 128>
                        <cfset isValidIP = true>
                    </cfif>
                </cfif>
            </cfif>
        <cfelse>
            <!--- Plain IP address (no CIDR) --->
            <!--- Check IPv4 --->
            <cfinclude template="./inc/validate_ip_address.cfm">
            <cfif REFind(pattern, ipInput) GT 0>
                <cfset isValidIP = true>
            <cfelse>
                <!--- Check IPv6 --->
                <cfinclude template="./inc/validate_ip_address_ipv6.cfm">
                <cfif REFind(pattern, ipInput) GT 0>
                    <cfset isValidIP = true>
                </cfif>
            </cfif>
        </cfif>

        <cfif isValidIP>
            <cftry>
                <cfquery name="insertWhitelist" datasource="hermes">
                    INSERT INTO intrusion_prevention_whitelist (ip_cidr, description)
                    VALUES (
                        <cfqueryparam value="#ipInput#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#trim(form.whitelist_description)#" cfsqltype="cf_sql_varchar">
                    )
                </cfquery>
                <cfquery name="markUnsynced" datasource="hermes">
                    UPDATE intrusion_prevention_settings SET setting_value = '0' WHERE setting_name = 'config_synced'
                </cfquery>
                <cfset session.m = "ip_whitelist_add">
            <cfcatch type="database">
                <cfif cfcatch.message CONTAINS "Duplicate">
                    <cfset session.m = "ip_whitelist_duplicate">
                <cfelse>
                    <cfset session.m = "ip_error">
                </cfif>
            </cfcatch>
            </cftry>
        <cfelse>
            <cfset session.m = "ip_whitelist_invalid">
        </cfif>
    <cfelse>
        <cfset session.m = "ip_error">
    </cfif>
    <cflocation url="view_intrusion_prevention.cfm" addtoken="no">
</cfif>

<!--- Delete Whitelist Entries --->
<cfif action EQ "delete_whitelist">
    <cfif IsDefined("form.delete_whitelist_ids") AND form.delete_whitelist_ids NEQ "">
        <!--- Check if any protected IPs are in the selection BEFORE deleting (case-insensitive) --->
        <cfquery name="checkProtected" datasource="hermes">
            SELECT COUNT(*) as protectedCount FROM intrusion_prevention_whitelist
            WHERE id IN (<cfqueryparam value="#form.delete_whitelist_ids#" cfsqltype="cf_sql_integer" list="yes">)
            AND (LOWER(ip_cidr) = '127.0.0.1/8' OR LOWER(ip_cidr) = '::1' OR LOWER(ip_cidr) = '172.16.0.0/12')
        </cfquery>

        <cfif checkProtected.protectedCount GT 0>
            <!--- Attempted to delete protected IPs - show warning, don't delete anything --->
            <cfset session.m = "ip_whitelist_protected">
        <cfelse>
            <!--- Safe to delete - no protected IPs in selection --->
            <cfquery name="deleteWhitelist" datasource="hermes">
                DELETE FROM intrusion_prevention_whitelist
                WHERE id IN (<cfqueryparam value="#form.delete_whitelist_ids#" cfsqltype="cf_sql_integer" list="yes">)
                AND LOWER(ip_cidr) NOT IN ('127.0.0.1/8', '::1', '172.16.0.0/12')
            </cfquery>

            <cfquery name="markUnsynced" datasource="hermes">
                UPDATE intrusion_prevention_settings SET setting_value = '0' WHERE setting_name = 'config_synced'
            </cfquery>
            <cfset session.m = "ip_whitelist_delete">
        </cfif>
    </cfif>
    <cflocation url="view_intrusion_prevention.cfm" addtoken="no">
</cfif>

<!--- Manual Ban --->
<cfif action EQ "manual_ban">
    <cfinclude template="./inc/intrusion_prevention_manual_ban.cfm">
    <cfif manualBanSuccess>
        <cfset session.m = "ip_ban_success">
    <cfelse>
        <cfset session.m = "ip_ban_error">
        <cfset session.banError = manualBanError>
    </cfif>
    <cflocation url="view_intrusion_prevention.cfm" addtoken="no">
</cfif>

<!--- Manual Unban --->
<cfif action EQ "manual_unban">
    <cfif StructKeyExists(form, "unban_ips") AND len(trim(form.unban_ips))>
        <cfinclude template="./inc/intrusion_prevention_manual_unban.cfm">
        <cfif manualUnbanSuccess>
            <cfset session.m = "ip_unban_success">
            <cfset session.unbannedCount = unbannedCount>
        <cfelse>
            <cfset session.m = "ip_unban_error">
            <cfset session.unbanError = manualUnbanError>
        </cfif>
    </cfif>
    <cflocation url="view_intrusion_prevention.cfm" addtoken="no">
</cfif>

<!--- SUCCESS/ERROR MESSAGES --->

<cfif m EQ "ip_enabled">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>Intrusion Prevention was <strong>Enabled</strong> successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
        <form action="" method="post">
            <input type="hidden" name="action" value="apply_changes">
            <div class="text-center">
                <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
            </div>
        </form>
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ip_disabled">
    <div class="alert alert-warning alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-exclamation-triangle"></i> Warning!</h4>
        <cfoutput>Intrusion Prevention was <strong>Disabled</strong>. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
        <form action="" method="post">
            <input type="hidden" name="action" value="apply_changes">
            <div class="text-center">
                <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
            </div>
        </form>
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ip_jail_updated">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>Jail settings were updated successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
        <form action="" method="post">
            <input type="hidden" name="action" value="apply_changes">
            <div class="text-center">
                <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
            </div>
        </form>
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ip_sync">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        Configuration was applied to fail2ban successfully.
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ip_sync_error">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-ban"></i> Error!</h4>
        Failed to sync to fail2ban: <cfoutput>#session.syncError#</cfoutput>
    </div>
    <cfset session.m = 0>
    <cfset session.syncError = "">
</cfif>

<cfif m EQ "ip_whitelist_add">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>Whitelist entry was added successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
        <form action="" method="post">
            <input type="hidden" name="action" value="apply_changes">
            <div class="text-center">
                <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
            </div>
        </form>
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ip_whitelist_delete">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>Whitelist entry/entries were deleted successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
        <form action="" method="post">
            <input type="hidden" name="action" value="apply_changes">
            <div class="text-center">
                <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
            </div>
        </form>
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ip_whitelist_duplicate">
    <div class="alert alert-warning alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-exclamation-triangle"></i> Warning!</h4>
        This IP/CIDR is already in the whitelist.
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ip_whitelist_invalid">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-ban"></i> Invalid IP/CIDR!</h4>
        Please enter a valid IPv4 address (e.g., 192.168.1.100), IPv4 CIDR (e.g., 10.0.0.0/8), IPv6 address (e.g., ::1), or IPv6 CIDR (e.g., fe80::/10).
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ip_ban_success">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        IP address was banned successfully.
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ip_ban_error">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-ban"></i> Ban Error!</h4>
        <cfoutput>#htmlEditFormat(session.banError)#</cfoutput>
    </div>
    <cfset session.m = 0>
    <cfset session.banError = "">
</cfif>

<cfif m EQ "ip_unban_success">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>#session.unbannedCount# IP address(es) were unbanned successfully.</cfoutput>
    </div>
    <cfset session.m = 0>
    <cfset session.unbannedCount = 0>
</cfif>

<cfif m EQ "ip_unban_error">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-ban"></i> Unban Error!</h4>
        <cfoutput>#htmlEditFormat(session.unbanError)#</cfoutput>
    </div>
    <cfset session.m = 0>
    <cfset session.unbanError = "">
</cfif>

<cfif m EQ "ip_whitelist_protected">
    <div class="alert alert-warning alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-exclamation-triangle"></i> Protected Entry!</h4>
        The localhost (127.0.0.1/8, ::1) and Docker network (172.16.0.0/12) entries cannot be deleted as they are required for system operation.
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ip_error">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-ban"></i> Error!</h4>
        An error occurred. Please try again.
    </div>
    <cfset session.m = 0>
</cfif>

<!--- FETCH DATA --->
<cfquery name="getSettings" datasource="hermes">
    SELECT setting_name, setting_value FROM intrusion_prevention_settings
</cfquery>

<cfset settings = {}>
<cfloop query="getSettings">
    <cfset settings[getSettings.setting_name] = getSettings.setting_value>
</cfloop>

<!--- Set defaults if settings don't exist --->
<cfif NOT structKeyExists(settings, "enabled")>
    <cfset settings.enabled = "1">
</cfif>
<cfif NOT structKeyExists(settings, "config_synced")>
    <cfset settings.config_synced = "1">
</cfif>

<cfquery name="getJails" datasource="hermes">
    SELECT * FROM intrusion_prevention_jails ORDER BY jail_name
</cfquery>

<cfquery name="getWhitelist" datasource="hermes">
    SELECT * FROM intrusion_prevention_whitelist ORDER BY ip_cidr
</cfquery>

<cfquery name="getBannedIPs" datasource="hermes">
    SELECT f.*, j.bantime, j.display_name as jail_display_name
    FROM fail2ban_ips f
    LEFT JOIN intrusion_prevention_jails j ON f.jail = j.jail_name
    ORDER BY f.datetime DESC
</cfquery>

<!--- Get live fail2ban status --->
<cfinclude template="./inc/intrusion_prevention_get_status.cfm">

<!--- Check if there are pending changes --->
<cfset hasPendingChanges = (settings.config_synced EQ "0")>
<cfquery name="checkJailSync" datasource="hermes">
    SELECT COUNT(*) as unsyncedCount FROM intrusion_prevention_jails WHERE config_synced = 0
</cfquery>
<cfif checkJailSync.unsyncedCount GT 0>
    <cfset hasPendingChanges = true>
</cfif>

<!-- Info Card -->
<div class="card mb-4">
    <div class="card-header bg-info text-white">
        <h3 class="card-title"><i class="fas fa-info-circle"></i> About Intrusion Prevention</h3>
    </div>
    <div class="card-body">
        <p><strong>Intrusion Prevention</strong> protects your mail server and SSO portal against brute force attacks by automatically blocking IP addresses that repeatedly fail authentication.</p>
        <p><strong>How it works:</strong> Fail2ban monitors authentication logs and bans IPs that exceed the configured failure threshold within the specified time window. Bans expire automatically after the ban time.</p>
        <p class="text-muted mb-0"><small><i class="fas fa-info-circle"></i> When disabled, no new IP addresses will be banned. Existing bans remain in place until they expire.</small></p>

        <hr>
        <p><strong><i class="fas fa-terminal"></i> Troubleshooting Commands</strong></p>
        <p class="mb-2">Run these commands on the Docker host to check fail2ban and firewall status:</p>
        <div class="table-responsive">
            <table class="table table-sm table-bordered mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width: 40%;">Command</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>docker exec hermes_fail2ban fail2ban-client status</code></td>
                        <td>Show overall fail2ban status and list of active jails</td>
                    </tr>
                    <tr>
                        <td><code>docker exec hermes_fail2ban fail2ban-client status dovecot</code></td>
                        <td>Show dovecot jail status including currently banned IPs</td>
                    </tr>
                    <tr>
                        <td><code>docker exec hermes_fail2ban fail2ban-client status authelia</code></td>
                        <td>Show authelia jail status including currently banned IPs</td>
                    </tr>
                    <tr>
                        <td><code>docker logs hermes_fail2ban --tail 50</code></td>
                        <td>View recent fail2ban container logs</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <p class="mt-3 mb-2"><strong>iptables Commands</strong> <small class="text-muted">(use the command that matches your system's iptables backend)</small></p>
        <div class="table-responsive">
            <table class="table table-sm table-bordered mb-0">
                <thead class="table-light">
                    <tr>
                        <th style="width: 40%;">iptables-legacy (older systems)</th>
                        <th style="width: 40%;">iptables-nft (newer systems)</th>
                        <th>Description</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><code>docker exec hermes_fail2ban iptables-legacy -L f2b-dovecot -n</code></td>
                        <td><code>docker exec hermes_fail2ban iptables-nft -L f2b-dovecot -n</code></td>
                        <td>Show firewall rules for dovecot jail</td>
                    </tr>
                    <tr>
                        <td><code>docker exec hermes_fail2ban iptables-legacy -L f2b-authelia -n</code></td>
                        <td><code>docker exec hermes_fail2ban iptables-nft -L f2b-authelia -n</code></td>
                        <td>Show firewall rules for authelia jail</td>
                    </tr>
                    <tr>
                        <td><code>docker exec hermes_fail2ban iptables-legacy -L DOCKER-USER -n</code></td>
                        <td><code>docker exec hermes_fail2ban iptables-nft -L DOCKER-USER -n</code></td>
                        <td>Show DOCKER-USER chain (entry point for container traffic filtering)</td>
                    </tr>
                    <tr>
                        <td><code>docker exec hermes_fail2ban iptables-legacy -L -n</code></td>
                        <td><code>docker exec hermes_fail2ban iptables-nft -L -n</code></td>
                        <td>Show all iptables rules</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <p class="text-muted mt-2 mb-0"><small><i class="fas fa-info-circle"></i> <strong>Tip:</strong> To check which backend your system uses, run: <code>docker exec hermes_fail2ban update-alternatives --display iptables</code></small></p>
        <p class="text-muted mt-1 mb-0"><small><i class="fas fa-info-circle"></i> <strong>Note:</strong> Fail2ban uses the DOCKER-USER chain to filter traffic to Docker containers. The f2b-dovecot and f2b-authelia chains contain the actual banned IPs.</small></p>
    </div>
</div>

<!-- Status Card -->
<div class="card mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-shield-alt"></i> Intrusion Prevention Status</h3>
        <div class="card-tools">
            <cfif hasPendingChanges>
                <span class="badge badge-pending"><i class="fas fa-exclamation-circle"></i> Pending Changes</span>
            <cfelse>
                <span class="badge badge-synced"><i class="fas fa-check-circle"></i> Synced</span>
            </cfif>
        </div>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-6">
                <form name="SetIPStatus" method="post">
                    <input type="hidden" name="action" value="set_ip_status">
                    <div class="form-group">
                        <label><strong>Protection Status</strong></label>
                        <select class="form-control" name="ip_status" id="ip_status" style="width: 100%;">
                            <cfif settings.enabled EQ "1">
                                <option value="enabled" selected>Enabled (Protection Active)</option>
                                <option value="disabled">Disabled (Protection Inactive)</option>
                            <cfelse>
                                <option value="enabled">Enabled (Protection Active)</option>
                                <option value="disabled" selected>Disabled (Protection Inactive)</option>
                            </cfif>
                        </select>
                    </div>
                    <div class="mt-3">
                        <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Submit</button>
                    </div>
                </form>
            </div>
            <div class="col-md-6">
                <div class="row">
                    <div class="col-6">
                        <div class="stat-card bg-light rounded">
                            <div class="stat-value text-primary"><cfoutput>#activeJailCount#</cfoutput></div>
                            <div class="stat-label">Active Jails</div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="stat-card bg-light rounded">
                            <div class="stat-value text-danger"><cfoutput>#totalBannedIPs#</cfoutput></div>
                            <div class="stat-label">Currently Banned IPs</div>
                        </div>
                    </div>
                </div>
                <cfif NOT f2bRunning>
                    <div class="alert alert-warning mt-3 mb-0">
                        <i class="fas fa-exclamation-triangle"></i> Fail2ban service is not responding
                        <cfif len(f2bError)><br><small><cfoutput>#htmlEditFormat(f2bError)#</cfoutput></small></cfif>
                    </div>
                </cfif>
            </div>
        </div>
    </div>
</div>

<!-- Jails Configuration Card -->
<div class="card mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-lock"></i> Jails Configuration</h3>
    </div>
    <div class="card-body">
        <cfif getJails.recordcount GTE 1>
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Jail</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Max Retry</th>
                            <th>Find Time</th>
                            <th>Ban Time</th>
                            <th>Currently Banned</th>
                            <th>Banned (All Time)</th>
                            <th>Synced</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="getJails">
                            <cfset jailLiveStatus = structKeyExists(jailStatuses, jail_name) ? jailStatuses[jail_name] : {bannedCount: 0, totalBanned: 0}>
                            <tr>
                                <td><strong>#display_name#</strong><br><small class="text-muted">#jail_name#</small></td>
                                <td><small>#description#</small></td>
                                <td>
                                    <cfif settings.enabled EQ "1" AND enabled EQ 1>
                                        <span class="badge bg-success">Enabled</span>
                                    <cfelse>
                                        <span class="badge bg-secondary">Disabled</span>
                                    </cfif>
                                </td>
                                <td>#maxretry#</td>
                                <td>#NumberFormat(findtime / 3600, "0.0")# hrs</td>
                                <td>#NumberFormat(bantime / 60, "0")# min</td>
                                <td><span class="badge bg-danger">#jailLiveStatus.bannedCount#</span></td>
                                <td>#jailLiveStatus.totalBanned#</td>
                                <td>
                                    <cfif settings.config_synced EQ "1" AND config_synced EQ 1>
                                        <span class="badge bg-success">Yes</span>
                                    <cfelse>
                                        <span class="badge bg-warning text-dark">No</span>
                                    </cfif>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-secondary btn-sm edit-jail-btn"
                                        data-bs-toggle="modal" data-bs-target="##edit_jail_modal"
                                        data-id="#id#"
                                        data-name="#display_name#"
                                        data-enabled="#enabled#"
                                        data-maxretry="#maxretry#"
                                        data-findtime="#findtime#"
                                        data-bantime="#bantime#">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        <cfelse>
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i> No jails configured.
            </div>
        </cfif>
    </div>
</div>

<!-- IP Whitelist Card -->
<div class="card mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-list-alt"></i> IP Whitelist (Never Ban)</h3>
        <div class="card-tools">
            <a href="#add_whitelist_modal" class="btn btn-sm btn-primary" data-bs-toggle="modal"><i class="fas fa-plus"></i> Add IP/CIDR</a>
        </div>
    </div>
    <div class="card-body">
        <p>
            <button type="button" id="deleteWhitelistBtn" class="btn btn-danger"><i class="fas fa-trash-alt"></i> Delete Selected</button>
        </p>

        <cfif getWhitelist.recordcount GTE 1>
            <table class="table table-striped" id="whitelistTable" style="width:100%">
                <thead>
                    <tr>
                        <th><input type="checkbox" id="selectAllWhitelist"></th>
                        <th>IP/CIDR</th>
                        <th>Description</th>
                        <th>Added</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="getWhitelist">
                        <cfset isProtected = (CompareNoCase(ip_cidr, "127.0.0.1/8") EQ 0 OR CompareNoCase(ip_cidr, "::1") EQ 0 OR CompareNoCase(ip_cidr, "172.16.0.0/12") EQ 0)>
                        <tr>
                            <td>
                                <cfif isProtected>
                                    <i class="fas fa-lock text-muted" title="Protected - cannot be deleted"></i>
                                <cfelse>
                                    <input type="checkbox" class="whitelist-checkbox" name="whitelist_id" value="#id#">
                                </cfif>
                            </td>
                            <td><code>#ip_cidr#</code><cfif isProtected> <span class="badge bg-secondary">Protected</span></cfif></td>
                            <td>#description#</td>
                            <td><cfif isProtected><span class="text-muted">N/A</span><cfelse>#DateFormat(created_at, "mm/dd/yyyy")# #TimeFormat(created_at, "HH:mm")#</cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
        <cfelse>
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i> No whitelist entries configured. Click "Add IP/CIDR" to add trusted IP addresses or ranges.
            </div>
        </cfif>
    </div>
</div>

<!-- Banned IPs Card -->
<div class="card mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-ban"></i> Banned IP Addresses</h3>
        <div class="card-tools">
            <a href="#ban_modal" class="btn btn-sm btn-warning" data-bs-toggle="modal"><i class="fas fa-plus"></i> Manual Ban</a>
        </div>
    </div>
    <div class="card-body">
        <p>
            <button type="button" id="unbanBtn" class="btn btn-success"><i class="fas fa-unlock"></i> Unban Selected</button>
        </p>

        <cfif getBannedIPs.recordcount GTE 1>
            <table class="table table-striped" id="bannedTable" style="width:100%">
                <thead>
                    <tr>
                        <th><input type="checkbox" id="selectAllBanned"></th>
                        <th>IP Address</th>
                        <th>Jail(s)</th>
                        <th>Source</th>
                        <th>Type</th>
                        <th>Banned At</th>
                        <th>Time Remaining</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="getBannedIPs">
                        <tr>
                            <td><input type="checkbox" class="banned-checkbox" name="banned_ip" value="#ip#|#jail#"></td>
                            <td><code>#ip#</code></td>
                            <td>
                                <!--- Display jail from joined table or derive from source --->
                                <cfif structKeyExists(getBannedIPs, "jail_display_name") AND len(trim(jail_display_name))>
                                    <span class="badge bg-secondary">#jail_display_name#</span>
                                <cfelseif structKeyExists(getBannedIPs, "jail") AND len(trim(jail))>
                                    <span class="badge bg-secondary">#jail#</span>
                                <cfelseif ban_source EQ "MAILSERVER">
                                    <span class="badge bg-primary">Mail Server (Dovecot)</span>
                                <cfelseif ban_source EQ "SSO">
                                    <span class="badge bg-info">SSO Portal (Authelia)</span>
                                <cfelse>
                                    <span class="badge bg-secondary">Unknown</span>
                                </cfif>
                            </td>
                            <td>
                                <cfif ban_source EQ "MAILSERVER">
                                    <span class="badge bg-primary">Mail Server</span>
                                <cfelseif ban_source EQ "SSO">
                                    <span class="badge bg-info">SSO Portal</span>
                                <cfelseif ban_source EQ "ADMIN">
                                    <span class="badge bg-dark">Administrator</span>
                                <cfelse>
                                    <span class="badge bg-secondary">#ban_source#</span>
                                </cfif>
                            </td>
                            <td>
                                <cfif ban_type EQ "AUTOMATIC">
                                    <span class="badge bg-warning text-dark">Auto</span>
                                <cfelseif ban_type EQ "MANUAL">
                                    <span class="badge bg-danger">Manual</span>
                                <cfelse>
                                    <span class="badge bg-secondary">#ban_type#</span>
                                </cfif>
                            </td>
                            <td>#DateFormat(datetime, "mm/dd/yyyy")# #TimeFormat(datetime, "HH:mm")#</td>
                            <td>
                                <!--- Calculate time remaining until unban --->
                                <cfif structKeyExists(getBannedIPs, "bantime") AND isNumeric(bantime) AND bantime GT 0>
                                    <cfset banDateTime = ParseDateTime(datetime)>
                                    <cfset unbanDateTime = DateAdd("s", bantime, banDateTime)>
                                    <cfset secondsRemaining = DateDiff("s", Now(), unbanDateTime)>
                                    <cfset unbanTimestamp = DateDiff("s", CreateDateTime(1970,1,1,0,0,0), DateConvert("local2utc", unbanDateTime))>
                                    <cfif secondsRemaining GT 0>
                                        <span class="countdown-timer badge bg-warning text-dark" data-unban-timestamp="#unbanTimestamp#">
                                            <cfif secondsRemaining GTE 3600>
                                                <cfset hoursRemaining = Int(secondsRemaining / 3600)>
                                                <cfset minsRemaining = Int((secondsRemaining MOD 3600) / 60)>
                                                #hoursRemaining#h #minsRemaining#m
                                            <cfelseif secondsRemaining GTE 60>
                                                <cfset minsRemaining = Int(secondsRemaining / 60)>
                                                #minsRemaining# min
                                            <cfelse>
                                                &lt; 1 min
                                            </cfif>
                                        </span>
                                    <cfelse>
                                        <span class="badge bg-secondary">Expired</span>
                                    </cfif>
                                <cfelseif ban_type EQ "MANUAL">
                                    <span class="badge bg-dark">Permanent</span>
                                <cfelse>
                                    <span class="badge bg-secondary">Unknown</span>
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
            </table>
        <cfelse>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> No IP addresses are currently banned.
            </div>
        </cfif>
    </div>
</div>

<!-- Edit Jail Modal -->
<div class="modal fade" id="edit_jail_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h4 class="modal-title"><i class="fas fa-edit"></i> Edit Jail: <span id="edit_jail_name_display"></span></h4>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update_jail">
                    <input type="hidden" name="jail_id" id="edit_jail_id">
                    <div class="mb-3">
                        <label class="form-label">Enabled</label>
                        <select name="jail_enabled" id="edit_jail_enabled" class="form-select">
                            <option value="1">Enabled</option>
                            <option value="0">Disabled</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Max Retry</label>
                        <input type="number" name="maxretry" id="edit_maxretry" class="form-control" min="1" max="100">
                        <small class="text-muted">Failed attempts before ban (1-100)</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Find Time (seconds)</label>
                        <input type="number" name="findtime" id="edit_findtime" class="form-control" min="60" max="604800">
                        <small class="text-muted">Window for counting failures (e.g., 86400 = 1 day)</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Ban Time (seconds)</label>
                        <input type="number" name="bantime" id="edit_bantime" class="form-control" min="60" max="604800">
                        <small class="text-muted">Duration of ban (e.g., 1800 = 30 minutes, 3600 = 1 hour)</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Add Whitelist Modal -->
<div class="modal fade" id="add_whitelist_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h4 class="modal-title"><i class="fas fa-plus"></i> Add Whitelist Entry</h4>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="">
                <div class="modal-body">
                    <input type="hidden" name="action" value="add_whitelist">
                    <div class="mb-3">
                        <label class="form-label">IP Address or CIDR Range <span class="text-danger">*</span></label>
                        <input type="text" name="whitelist_ip" class="form-control" required placeholder="e.g., 192.168.1.100 or 10.0.0.0/8">
                        <small class="text-muted">Enter a single IP address or CIDR notation for a range</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <input type="text" name="whitelist_description" class="form-control" placeholder="e.g., Office network">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add to Whitelist</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Whitelist Confirmation Modal -->
<div class="modal fade" id="delete_whitelist_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h4 class="modal-title"><i class="fas fa-exclamation-triangle"></i> Delete Whitelist Entry</h4>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete the selected whitelist entry/entries? These IP addresses will no longer be protected from banning.</p>
            </div>
            <div class="modal-footer">
                <form method="post" action="">
                    <input type="hidden" name="action" value="delete_whitelist">
                    <input type="hidden" name="delete_whitelist_ids" id="deleteWhitelistIds" value="">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Manual Ban Modal -->
<div class="modal fade" id="ban_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h4 class="modal-title"><i class="fas fa-ban"></i> Manual Ban IP Address</h4>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="">
                <div class="modal-body">
                    <input type="hidden" name="action" value="manual_ban">
                    <div class="mb-3">
                        <label class="form-label">IP Address <span class="text-danger">*</span></label>
                        <input type="text" name="ban_ip" class="form-control" required placeholder="e.g., 192.168.1.100">
                        <small class="text-muted">Enter the IP address to ban</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Jail <span class="text-danger">*</span></label>
                        <select name="ban_jail" class="form-select" required>
                            <option value="ALL">All Jails</option>
                            <cfoutput query="getJails">
                                <cfif enabled EQ 1>
                                    <option value="#jail_name#">#display_name#</option>
                                </cfif>
                            </cfoutput>
                        </select>
                        <small class="text-muted">Select a specific jail or "All Jails" to ban across all enabled jails</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Source</label>
                        <input type="hidden" name="ban_source" value="ADMIN">
                        <input type="text" class="form-control" value="Administrator" disabled>
                        <small class="text-muted">Manual bans are recorded as administrator actions</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-warning">Ban IP</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Unban Confirmation Modal -->
<div class="modal fade" id="unban_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h4 class="modal-title"><i class="fas fa-unlock"></i> Unban IP Addresses</h4>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to unban the selected IP address(es)? They will be able to access your services again.</p>
            </div>
            <div class="modal-footer">
                <form method="post" action="">
                    <input type="hidden" name="action" value="manual_unban">
                    <input type="hidden" name="unban_ips" id="unbanIps" value="">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success">Unban</button>
                </form>
            </div>
        </div>
    </div>
</div>

</div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</main>

<cfinclude template="./inc/main_footer.cfm" />

</div><!-- ./app-wrapper -->

<!-- Back to top button script -->
<script>
let mybutton = document.getElementById("btn-back-to-top");
window.onscroll = function() {
    if (document.body.scrollTop > 200 || document.documentElement.scrollTop > 200) {
        mybutton.style.display = "block";
    } else {
        mybutton.style.display = "none";
    }
};
mybutton.addEventListener("click", function() {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
});

// Edit jail modal - populate fields when edit button is clicked
document.addEventListener('DOMContentLoaded', function() {
    const editJailModal = document.getElementById('edit_jail_modal');
    if (editJailModal) {
        editJailModal.addEventListener('show.bs.modal', function(event) {
            const button = event.relatedTarget;
            const id = button.getAttribute('data-id');
            const name = button.getAttribute('data-name');
            const enabled = button.getAttribute('data-enabled');
            const maxretry = button.getAttribute('data-maxretry');
            const findtime = button.getAttribute('data-findtime');
            const bantime = button.getAttribute('data-bantime');

            document.getElementById('edit_jail_id').value = id;
            document.getElementById('edit_jail_name_display').textContent = name;
            document.getElementById('edit_jail_enabled').value = enabled;
            document.getElementById('edit_maxretry').value = maxretry;
            document.getElementById('edit_findtime').value = findtime;
            document.getElementById('edit_bantime').value = bantime;
        });
    }
});

// Countdown timer for banned IPs
function updateCountdowns() {
    const timers = document.querySelectorAll('.countdown-timer');
    const now = Math.floor(Date.now() / 1000);

    timers.forEach(function(timer) {
        const unbanTimestamp = parseInt(timer.getAttribute('data-unban-timestamp'));
        const secondsRemaining = unbanTimestamp - now;

        if (secondsRemaining <= 0) {
            timer.textContent = 'Expired';
            timer.classList.remove('bg-warning', 'bg-danger', 'text-dark');
            timer.classList.add('bg-secondary');
        } else if (secondsRemaining < 60) {
            timer.textContent = '< 1 min';
            timer.classList.remove('bg-warning', 'text-dark');
            timer.classList.add('bg-danger');
        } else if (secondsRemaining < 3600) {
            const mins = Math.floor(secondsRemaining / 60);
            timer.textContent = mins + ' min';
            timer.classList.remove('bg-danger');
            timer.classList.add('bg-warning', 'text-dark');
        } else {
            const hours = Math.floor(secondsRemaining / 3600);
            const mins = Math.floor((secondsRemaining % 3600) / 60);
            timer.textContent = hours + 'h ' + mins + 'm';
            timer.classList.remove('bg-danger');
            timer.classList.add('bg-warning', 'text-dark');
        }
    });
}

// Update countdowns every second
setInterval(updateCountdowns, 1000);

// Initial update
updateCountdowns();
</script>

</body>
</html>
