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
<title>Hermes SEG | LDAP RemoteAuth Configuration</title>

<cfinclude template="./inc/html_head.cfm" />

<!--- DataTable Script --->
<script>
$(document).ready(function() {
    $('#mappingsTable').DataTable({
        dom: 'Blfrtip',
        buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
        stateSave: true,
        lengthMenu: [
            [25, 50, 100, -1],
            ['25 rows', '50 rows', '100 rows', 'Show all']
        ],
        "order": [[2, "asc"]]
    });

    // Select all checkboxes
    $('#selectAll').click(function() {
        if(this.checked) {
            $(':checkbox').each(function() {
                this.checked = true;
            });
        } else {
            $(':checkbox').each(function() {
                this.checked = false;
            });
        }
    });

    // Delete button handler
    $("#deleteBtn").click(function() {
        var deleteIds = [];
        $.each($("input[name='mapping_id']:checked"), function() {
            deleteIds.push($(this).val());
        });
        if(deleteIds.length > 0) {
            $('#deleteIds').val(deleteIds.join(','));
            $('#delete_modal').modal('show');
        } else {
            alert('Please select at least one mapping to delete.');
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
                <h1 class="m-0">LDAP RemoteAuth Configuration</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="#">Home</a></li>
                    <li class="breadcrumb-item"><a href="#">System</a></li>
                    <li class="breadcrumb-item active">RemoteAuth</li>
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
        <p>RemoteAuth Configuration is only available with a valid Hermes SEG Pro License. Please contact sales@deeztek.com to obtain a valid Hermes SEG Pro License.</p>
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

<!--- Update Global TLS Settings --->
<cfif action EQ "update_tls_settings">
    <cftry>
        <!--- Handle CA certificate upload if provided --->
        <cfset caCertFilename = "">
        <cfset certsDir = "/opt/hermes/certs/remoteauth">

        <!--- Get current CA cert filename --->
        <cfquery name="getCurrentCaCert" datasource="hermes">
            SELECT setting_value FROM remoteauth_settings WHERE setting_name = 'ca_cert_file'
        </cfquery>
        <cfif getCurrentCaCert.recordcount GT 0>
            <cfset caCertFilename = getCurrentCaCert.setting_value>
        </cfif>

        <!--- Handle certificate removal if requested --->
        <cfif structKeyExists(form, "remove_ca_cert") AND form.remove_ca_cert EQ "1">
            <cfif len(caCertFilename) AND fileExists("#certsDir#/#caCertFilename#")>
                <cffile action="delete" file="#certsDir#/#caCertFilename#">
            </cfif>
            <cfset caCertFilename = "">
        </cfif>

        <!--- Handle CA certificate upload if provided --->
        <cfif structKeyExists(form, "ca_cert_file") AND len(form.ca_cert_file)>
            <!--- Create certs directory if it doesn't exist --->
            <cfif NOT directoryExists(certsDir)>
                <cfdirectory action="create" directory="#certsDir#" mode="755">
            </cfif>

            <!--- Delete old certificate if exists --->
            <cfif len(caCertFilename) AND fileExists("#certsDir#/#caCertFilename#")>
                <cffile action="delete" file="#certsDir#/#caCertFilename#">
            </cfif>

            <!--- Generate unique filename --->
            <cfset caCertFilename = "global_remoteauth_ca.pem">

            <!--- Upload the certificate file --->
            <cffile action="upload"
                fileField="ca_cert_file"
                destination="#certsDir#"
                nameConflict="overwrite"
                accept="application/x-x509-ca-cert,application/pkix-cert,application/x-pem-file,text/plain,.pem,.crt,.cer">

            <!--- Rename to standardized filename --->
            <cfif cffile.serverFile NEQ caCertFilename>
                <cffile action="rename"
                    source="#certsDir#/#cffile.serverFile#"
                    destination="#certsDir#/#caCertFilename#">
            </cfif>
        </cfif>

        <!--- Update TLS settings in database --->
        <cfquery name="updateStarttls" datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = <cfqueryparam value="#form.tls_starttls#" cfsqltype="cf_sql_varchar">
            WHERE setting_name = 'tls_starttls'
        </cfquery>
        <cfquery name="updateReqcert" datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = <cfqueryparam value="#form.tls_reqcert#" cfsqltype="cf_sql_varchar">
            WHERE setting_name = 'tls_reqcert'
        </cfquery>
        <cfquery name="updateCaCert" datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = <cfqueryparam value="#caCertFilename#" cfsqltype="cf_sql_varchar">
            WHERE setting_name = 'ca_cert_file'
        </cfquery>
        <cfquery name="updateRetryCount" datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = <cfqueryparam value="#val(form.retry_count)#" cfsqltype="cf_sql_varchar">
            WHERE setting_name = 'retry_count'
        </cfquery>

        <!--- Mark as unsynced --->
        <cfquery name="markUnsyncedSettings" datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = '0' WHERE setting_name = 'ldap_synced'
        </cfquery>

        <cfset session.m = "ra_tls_updated">
        <cfcatch type="any">
            <cfset session.m = "ra_error">
        </cfcatch>
    </cftry>
    <cflocation url="view_remoteauth.cfm" addtoken="no">
</cfif>

<!--- Set RemoteAuth Status via dropdown --->
<cfif action EQ "set_remoteauth_status">
    <!--- Validate parameter --->
    <cfif NOT StructKeyExists(form, "remoteauth_status")>
        <cfset session.m = "ra_error">
        <cflocation url="view_remoteauth.cfm" addtoken="no">
    </cfif>

    <cfif form.remoteauth_status EQ "enabled">
        <cfset newValue = "1">
    <cfelseif form.remoteauth_status EQ "disabled">
        <cfset newValue = "0">
    <cfelse>
        <cfset session.m = "ra_error">
        <cflocation url="view_remoteauth.cfm" addtoken="no">
    </cfif>

    <!--- Check if status actually changed --->
    <cfquery name="getCurrentEnabled" datasource="hermes">
        SELECT setting_value FROM remoteauth_settings WHERE setting_name = 'enabled'
    </cfquery>

    <cfif getCurrentEnabled.setting_value NEQ newValue>
        <cfquery name="updateEnabled" datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = <cfqueryparam value="#newValue#" cfsqltype="cf_sql_varchar">
            WHERE setting_name = 'enabled'
        </cfquery>
        <cfquery name="markUnsyncedSettings" datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = '0' WHERE setting_name = 'ldap_synced'
        </cfquery>
        <cfif newValue EQ "1">
            <cfset session.m = "ra_enabled">
        <cfelse>
            <cfset session.m = "ra_disabled">
        </cfif>
    <cfelse>
        <!--- No change, just redirect --->
        <cflocation url="view_remoteauth.cfm" addtoken="no">
    </cfif>
    <cflocation url="view_remoteauth.cfm" addtoken="no">
</cfif>


<!--- Add Mapping --->
<cfif action EQ "add_mapping">
    <cftry>
        <!--- TLS settings are now global, not per-mapping --->
        <cfquery name="insertMapping" datasource="hermes">
            INSERT INTO remoteauth_mappings (domain_name, server_address, server_port, remote_dn_pattern, description, enabled, ldap_synced)
            VALUES (
                <cfqueryparam value="#trim(form.domain_name)#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#trim(form.server_address)#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#val(form.server_port)#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#trim(form.remote_dn_pattern)#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#trim(form.description)#" cfsqltype="cf_sql_varchar">,
                1,
                0
            )
        </cfquery>
        <cfquery name="markUnsyncedSettings" datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = '0' WHERE setting_name = 'ldap_synced'
        </cfquery>
        <cfset session.m = "ra_add">
        <cfcatch type="database">
            <cfif cfcatch.message CONTAINS "Duplicate">
                <cfset session.m = "ra_duplicate">
            <cfelse>
                <cfset session.m = "ra_error">
            </cfif>
        </cfcatch>
    </cftry>
    <cflocation url="view_remoteauth.cfm" addtoken="no">
</cfif>

<!--- Delete Mappings --->
<cfif action EQ "delete_mappings">
    <cfif IsDefined("form.delete_ids") AND form.delete_ids NEQ "">
        <cfset idList = form.delete_ids>

        <!--- Get domain names for the mappings to check for assigned users --->
        <cfquery name="getMappingDomains" datasource="hermes">
            SELECT id, domain_name, ca_cert_file FROM remoteauth_mappings
            WHERE id IN (<cfqueryparam value="#idList#" cfsqltype="cf_sql_integer" list="yes">)
        </cfquery>

        <!--- Build list of domains to check --->
        <cfset domainList = valueList(getMappingDomains.domain_name)>

        <!--- Check if any users are assigned to these mappings --->
        <cfquery name="checkUsersAssigned" datasource="hermes">
            SELECT remoteauth_domain, COUNT(*) AS user_count FROM system_users
            WHERE auth_type = 'remote'
            AND remoteauth_domain IN (<cfqueryparam value="#domainList#" cfsqltype="cf_sql_varchar" list="yes">)
            GROUP BY remoteauth_domain
        </cfquery>

        <cfif checkUsersAssigned.recordcount GT 0>
            <!--- Some mappings have users assigned - cannot delete those --->
            <cfset blockedDomains = valueList(checkUsersAssigned.remoteauth_domain)>
            <cfset session.m = "ra_delete_blocked">
            <cfset session.blockedDomains = blockedDomains>
            <cflocation url="view_remoteauth.cfm" addtoken="no">
        </cfif>

        <!--- Safe to delete - no users assigned --->
        <!--- Delete certificate files --->
        <cfloop query="getMappingDomains">
            <cfif len(getMappingDomains.ca_cert_file)>
                <cfset certPath = "/opt/hermes/certs/remoteauth/#getMappingDomains.ca_cert_file#">
                <cfif fileExists(certPath)>
                    <cffile action="delete" file="#certPath#">
                </cfif>
            </cfif>
        </cfloop>

        <cfquery name="deleteMappings" datasource="hermes">
            DELETE FROM remoteauth_mappings WHERE id IN (<cfqueryparam value="#idList#" cfsqltype="cf_sql_integer" list="yes">)
        </cfquery>
        <cfquery name="markUnsyncedSettings" datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = '0' WHERE setting_name = 'ldap_synced'
        </cfquery>
        <cfset session.m = "ra_delete">
    </cfif>
    <cflocation url="view_remoteauth.cfm" addtoken="no">
</cfif>

<!--- Apply Changes (Sync to LDAP) --->
<cfif action EQ "apply_changes">
    <cfinclude template="./inc/ldap_remoteauth_sync_all.cfm">
    <cfif remoteauthSyncSuccess>
        <cfset session.m = "ra_sync">
    <cfelse>
        <cfset session.m = "ra_sync_error">
        <cfset session.syncError = remoteauthSyncError>
    </cfif>
    <cflocation url="view_remoteauth.cfm" addtoken="no">
</cfif>

<!--- Test Connection --->
<cfif action EQ "test_connection">
    <!--- Validate required parameters --->
    <cfif NOT StructKeyExists(form, "test_server") OR form.test_server EQ "">
        <cfset session.m = "ra_test_error">
        <cfset session.testError = "Server address is required">
        <cflocation url="view_remoteauth.cfm" addtoken="no">
    </cfif>

    <cfif NOT StructKeyExists(form, "test_username") OR form.test_username EQ "">
        <cfset session.m = "ra_test_error">
        <cfset session.testError = "Username is required">
        <cflocation url="view_remoteauth.cfm" addtoken="no">
    </cfif>

    <cfif NOT StructKeyExists(form, "test_password") OR form.test_password EQ "">
        <cfset session.m = "ra_test_error">
        <cfset session.testError = "Password is required">
        <cflocation url="view_remoteauth.cfm" addtoken="no">
    </cfif>

    <!--- Get global TLS settings from database --->
    <cfquery name="getGlobalTLS" datasource="hermes">
        SELECT setting_name, setting_value FROM remoteauth_settings
        WHERE setting_name IN ('tls_starttls', 'tls_reqcert', 'ca_cert_file')
    </cfquery>
    <cfset globalTLS = {}>
    <cfloop query="getGlobalTLS">
        <cfset globalTLS[getGlobalTLS.setting_name] = getGlobalTLS.setting_value>
    </cfloop>

    <!--- Build the DN from the pattern --->
    <cfset testDnPattern = form.test_dnpattern>
    <cfset testDn = testDnPattern>
    <cfset testDn = Replace(testDn, "{username}", form.test_username, "ALL")>
    <cfif StructKeyExists(form, "test_firstname") AND form.test_firstname NEQ "">
        <cfset testDn = Replace(testDn, "{firstname}", form.test_firstname, "ALL")>
    </cfif>
    <cfif StructKeyExists(form, "test_lastname") AND form.test_lastname NEQ "">
        <cfset testDn = Replace(testDn, "{lastname}", form.test_lastname, "ALL")>
    </cfif>
    <cfif StructKeyExists(form, "test_email") AND form.test_email NEQ "">
        <cfset testDn = Replace(testDn, "{email}", form.test_email, "ALL")>
    </cfif>

    <!--- Build LDAP URL --->
    <cfset ldapUrl = "ldap://" & form.test_server & ":" & form.test_port>

    <!--- Build ldapwhoami command to test authentication --->
    <!--- Using ldapwhoami for a simple bind test --->
    <cfset ldapCommand = "exec hermes_ldap ldapwhoami -x -H ""#ldapUrl#"" -D ""#testDn#"" -w ""#form.test_password#""">

    <!--- Add STARTTLS if enabled in global settings --->
    <cfif structKeyExists(globalTLS, "tls_starttls") AND globalTLS.tls_starttls EQ "yes">
        <cfset ldapCommand = ldapCommand & " -ZZ">
    </cfif>

    <!--- Execute the test --->
    <cftry>
        <cfexecute name="/usr/local/bin/docker"
            arguments="#ldapCommand#"
            variable="testResult"
            errorVariable="testError"
            timeout="30">
        </cfexecute>

        <!--- Check if successful (ldapwhoami returns the bound DN on success) --->
        <cfif FindNoCase("dn:", testResult) GT 0 OR FindNoCase("u:", testResult) GT 0 OR testError EQ "">
            <cfset session.m = "ra_test_success">
            <cfset session.testDomain = form.test_domain>
            <cfset session.testDn = testDn>
            <cfset session.testResult = testResult>
        <cfelse>
            <cfset session.m = "ra_test_fail">
            <cfset session.testDomain = form.test_domain>
            <cfset session.testDn = testDn>
            <cfset session.testError = testError>
        </cfif>
    <cfcatch type="any">
        <cfset session.m = "ra_test_fail">
        <cfset session.testDomain = form.test_domain>
        <cfset session.testDn = testDn>
        <cfset session.testError = cfcatch.message>
    </cfcatch>
    </cftry>
    <cflocation url="view_remoteauth.cfm" addtoken="no">
</cfif>

<!--- SUCCESS/ERROR MESSAGES --->

<cfif m EQ "ra_tls_updated">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>Global TLS settings were updated successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
        <form action="" method="post">
            <input type="hidden" name="action" value="apply_changes">
            <div class="text-center">
                <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
            </div>
        </form>
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ra_enabled">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>LDAP RemoteAuth was <strong>Enabled</strong> successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
        <form action="" method="post">
            <input type="hidden" name="action" value="apply_changes">
            <div class="text-center">
                <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
            </div>
        </form>
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ra_disabled">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>LDAP RemoteAuth was <strong>Disabled</strong> successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
        <form action="" method="post">
            <input type="hidden" name="action" value="apply_changes">
            <div class="text-center">
                <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
            </div>
        </form>
    </div>
    <cfset session.m = 0>
</cfif>


<cfif m EQ "ra_add">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>Domain mapping was added successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
        <form action="" method="post">
            <input type="hidden" name="action" value="apply_changes">
            <div class="text-center">
                <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
            </div>
        </form>
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ra_delete">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>Domain mapping(s) were deleted successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
        <form action="" method="post">
            <input type="hidden" name="action" value="apply_changes">
            <div class="text-center">
                <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
            </div>
        </form>
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ra_delete_blocked">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Cannot Delete!</h4>
        <cfoutput>The following domain mapping(s) cannot be deleted because they have users assigned: <strong>#session.blockedDomains#</strong></cfoutput><br>
        <small>You must reassign or delete these users before deleting the mapping(s).</small>
    </div>
    <cfset session.m = 0>
    <cfset structDelete(session, "blockedDomains")>
</cfif>

<cfif m EQ "ra_sync">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        Configuration was applied to LDAP successfully.
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ra_sync_error">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-ban"></i> Error!</h4>
        Failed to sync to LDAP: <cfoutput>#session.syncError#</cfoutput>
    </div>
    <cfset session.m = 0>
    <cfset session.syncError = "">
</cfif>

<cfif m EQ "ra_duplicate">
    <div class="alert alert-warning alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-exclamation-triangle"></i> Warning!</h4>
        A domain mapping with that name already exists.
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ra_error">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-ban"></i> Error!</h4>
        An error occurred. Please try again.
    </div>
    <cfset session.m = 0>
</cfif>

<cfif m EQ "ra_test_success">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-check"></i> Connection Test Successful!</h4>
        <cfoutput>
        <p>Successfully authenticated to domain <strong>#session.testDomain#</strong></p>
        <p><strong>Bind DN:</strong> <code>#htmlEditFormat(session.testDn)#</code></p>
        <cfif isDefined("session.testResult") AND session.testResult NEQ "">
        <p><strong>Response:</strong> <code>#htmlEditFormat(session.testResult)#</code></p>
        </cfif>
        </cfoutput>
    </div>
    <cfset session.m = 0>
    <cfset session.testDomain = "">
    <cfset session.testDn = "">
    <cfset session.testResult = "">
</cfif>

<cfif m EQ "ra_test_fail">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-ban"></i> Connection Test Failed!</h4>
        <cfoutput>
        <p>Failed to authenticate to domain <strong>#session.testDomain#</strong></p>
        <p><strong>Attempted Bind DN:</strong> <code>#htmlEditFormat(session.testDn)#</code></p>
        <p><strong>Error:</strong> <code>#htmlEditFormat(session.testError)#</code></p>
        <p class="text-muted"><small>Common causes: incorrect DN pattern, wrong password, network/firewall issues, or TLS configuration problems.</small></p>
        </cfoutput>
    </div>
    <cfset session.m = 0>
    <cfset session.testDomain = "">
    <cfset session.testDn = "">
    <cfset session.testError = "">
</cfif>

<cfif m EQ "ra_test_error">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-ban"></i> Test Error!</h4>
        <cfoutput>#htmlEditFormat(session.testError)#</cfoutput>
    </div>
    <cfset session.m = 0>
    <cfset session.testError = "">
</cfif>

<cfif m EQ "ra_mapping_updated">
    <div class="alert alert-success alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-check"></i> Success!</h4>
        <cfoutput>Domain mapping was updated successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.</cfoutput><br><br>
        <form action="" method="post">
            <input type="hidden" name="action" value="apply_changes">
            <div class="text-center">
                <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
            </div>
        </form>
    </div>
    <cfset session.m = 0>
</cfif>

<!--- FETCH DATA --->
<cfquery name="getSettings" datasource="hermes">
    SELECT setting_name, setting_value FROM remoteauth_settings
</cfquery>

<cfset settings = {}>
<cfloop query="getSettings">
    <cfset settings[getSettings.setting_name] = getSettings.setting_value>
</cfloop>

<cfquery name="getMappings" datasource="hermes">
    SELECT id, domain_name, server_address, server_port, remote_dn_pattern, tls_starttls, tls_reqcert, retry_count, description, enabled, ldap_synced
    FROM remoteauth_mappings
    ORDER BY domain_name
</cfquery>

<!--- Check if there are pending changes --->
<cfset hasPendingChanges = (settings.ldap_synced EQ "0")>
<cfquery name="checkMappingSync" datasource="hermes">
    SELECT COUNT(*) as unsyncedCount FROM remoteauth_mappings WHERE ldap_synced = 0
</cfquery>
<cfif checkMappingSync.unsyncedCount GT 0>
    <cfset hasPendingChanges = true>
</cfif>

<!--- Query LDAP for current overlay information --->
<cfset overlayInfo = {}>
<cfset overlayCount = 0>
<cfset overlayDebug = "">
<cftry>
    <cfexecute name="/usr/local/bin/docker"
        arguments="exec hermes_ldap ldapsearch -Y EXTERNAL -H ldapi://%2Fvar%2Frun%2Fslapd%2Fldapi -b cn=config -LLL ""(objectClass=olcRemoteAuthCfg)"" dn olcRemoteAuthMapping"
        variable="overlaySearchResult"
        errorVariable="overlaySearchError"
        timeout="30">
    </cfexecute>

    <!--- Parse overlay information - each entry separated by blank lines --->
    <!--- Example output:
    dn: olcOverlay={0}remoteauth,olcDatabase={1}mdb,cn=config
    olcRemoteAuthMapping: deeztek ldap://homedc01.deeztek.com:389
    --->
    <cfset overlayDebug = overlaySearchResult>

    <!--- Line by line parsing --->
    <cfset lines = listToArray(Replace(overlaySearchResult, chr(13), "", "ALL"), chr(10))>
    <cfset currentIndex = "">
    <cfloop array="#lines#" index="line">
        <cfset line = trim(line)>
        <!--- Look for DN line with overlay index --->
        <cfif FindNoCase("dn:", line) EQ 1>
            <cfset indexMatch = REFind("olcOverlay=\{([0-9]+)\}remoteauth", line, 1, true)>
            <cfif arrayLen(indexMatch.pos) GTE 2 AND indexMatch.pos[2] GT 0>
                <cfset currentIndex = mid(line, indexMatch.pos[2], indexMatch.len[2])>
            </cfif>
        <!--- Look for mapping line with domain --->
        <cfelseif FindNoCase("olcRemoteAuthMapping:", line) EQ 1 AND currentIndex NEQ "">
            <!--- Extract value after the colon --->
            <cfset colonPos = Find(":", line)>
            <cfif colonPos GT 0>
                <cfset mappingValue = trim(mid(line, colonPos + 1, len(line)))>
                <!--- Domain is first word before space --->
                <cfset domainName = listFirst(mappingValue, " ")>
                <cfif len(domainName) GT 0>
                    <cfset overlayInfo[domainName] = currentIndex>
                    <cfset overlayCount = overlayCount + 1>
                </cfif>
            </cfif>
            <cfset currentIndex = "">
        </cfif>
    </cfloop>
<cfcatch type="any">
    <!--- Silently fail - overlays may not exist yet --->
    <cfset overlayDebug = "Error: " & cfcatch.message>
</cfcatch>
</cftry>

<!--- DEBUG: LDAP Query Results (uncomment for troubleshooting)
<div class="card mb-4 bg-dark text-white">
    <div class="card-header">DEBUG: LDAP Query Result</div>
    <div class="card-body">
        <pre><cfoutput>#htmlEditFormat(overlayDebug)#</cfoutput></pre>
        <p>Overlay Count: <cfoutput>#overlayCount#</cfoutput></p>
        <p>Overlay Info: <cfoutput>#serializeJSON(overlayInfo)#</cfoutput></p>
    </div>
</div>
--->

<!-- Info Card -->
<div class="card mb-4">
    <div class="card-header bg-info text-white">
        <h3 class="card-title"><i class="fas fa-info-circle"></i> About LDAP RemoteAuth (Pass-Through Authentication)</h3>
    </div>
    <div class="card-body">
        <p><strong>RemoteAuth</strong> enables pass-through authentication to external LDAP servers (including Active Directory, OpenLDAP, 389 Directory Server, FreeIPA, etc.).
        Users can authenticate using their existing directory credentials without storing passwords in Hermes.</p>
        <p><strong>Domain Mappings:</strong> Each mapping connects a domain identifier to a remote LDAP server and defines the DN pattern for user lookups.</p>
        <p><strong>Remote DN Pattern:</strong> This must match how users are named in your directory. Common patterns:</p>
        <ul>
            <li><code>cn={firstname} {lastname},ou=Users,dc=example,dc=com</code> - If directory uses display name as CN (e.g., "John Smith")</li>
            <li><code>cn={username},ou=Users,dc=example,dc=com</code> - If directory uses username as CN (e.g., "jsmith")</li>
            <li><code>uid={username},ou=People,dc=example,dc=com</code> - Common for OpenLDAP/FreeIPA</li>
        </ul>
        <p class="text-muted mb-0"><small><i class="fas fa-info-circle"></i> Check your directory user properties to determine which pattern applies. The DN must exactly match your directory naming convention.</small></p>
    </div>
</div>

<!-- Global Settings Card -->
<div class="card mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-cog"></i> RemoteAuth Status</h3>
        <div class="card-tools">
            <cfif hasPendingChanges>
                <span class="badge badge-pending"><i class="fas fa-exclamation-circle"></i> Pending Changes</span>
            <cfelse>
                <span class="badge badge-synced"><i class="fas fa-check-circle"></i> Synced</span>
            </cfif>
        </div>
    </div>
    <div class="card-body">
        <form name="SetRemoteAuth" method="post">
            <input type="hidden" name="action" value="set_remoteauth_status">
            <div class="col-sm-6">
                <div class="form-group">
                    <label><strong>RemoteAuth Status</strong></label>
                    <select class="form-control" name="remoteauth_status" id="remoteauth_status" style="width: 100%;">
                        <cfif settings.enabled EQ "1">
                            <option value="enabled" selected>Enabled (Pass-through Active)</option>
                            <option value="disabled">Disabled (Pass-through Inactive)</option>
                        <cfelse>
                            <option value="enabled">Enabled (Pass-through Active)</option>
                            <option value="disabled" selected>Disabled (Pass-through Inactive)</option>
                        </cfif>
                    </select>
                </div>
            </div>
            <div class="col-sm-4 mt-3">
                <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Submit</button>
            </div>
        </form>
        <cfoutput>
        <div class="mt-3">
            <span class="settings-label me-2">LDAP Overlay:</span>
            <cfif overlayCount GT 0>
                <span class="badge bg-success">Active</span>
            <cfelse>
                <span class="badge bg-secondary">Not configured</span>
            </cfif>
        </div>
        </cfoutput>
        <p class="text-muted mt-2 mb-0"><small><i class="fas fa-info-circle"></i> OpenLDAP RemoteAuth uses a single overlay with global TLS settings. All domain mappings share the same TLS configuration.</small></p>
    </div>
</div>

<!-- Global TLS Settings Card -->
<div class="card mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-shield-alt"></i> Global TLS Settings</h3>
    </div>
    <div class="card-body">
        <div class="alert alert-info mb-3">
            <i class="fas fa-info-circle"></i> <strong>Global TLS Settings:</strong> OpenLDAP remoteauth uses a singleton overlay. These TLS settings apply <strong>globally to ALL domain mappings</strong>.
            <p class="mt-2 mb-0"><strong>Connecting to multiple LDAP servers with different CA certificates?</strong> Create a CA bundle by concatenating all CA certificates into a single PEM file:</p>
            <pre class="bg-dark text-light p-2 mt-2 mb-0" style="font-size: 0.85em;">cat server1-ca.pem server2-ca.pem server3-ca.pem > ca-bundle.pem</pre>
            <small class="text-muted d-block mt-1">Then upload the ca-bundle.pem file below. OpenLDAP will use all certificates in the bundle to validate any server.</small>
        </div>
        <form name="UpdateTLSSettings" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update_tls_settings">
            <div class="row">
                <div class="col-md-3">
                    <div class="mb-3">
                        <label class="form-label"><strong>Use STARTTLS</strong></label>
                        <select name="tls_starttls" class="form-select">
                            <cfif structKeyExists(settings, "tls_starttls") AND settings.tls_starttls EQ "yes">
                                <option value="no">No</option>
                                <option value="yes" selected>Yes</option>
                            <cfelse>
                                <option value="no" selected>No</option>
                                <option value="yes">Yes</option>
                            </cfif>
                        </select>
                        <small class="text-muted">Enable STARTTLS for all remote LDAP connections</small>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="mb-3">
                        <label class="form-label"><strong>TLS Certificate Requirement</strong></label>
                        <select name="tls_reqcert" class="form-select" id="global_tls_reqcert">
                            <cfset currentReqcert = structKeyExists(settings, "tls_reqcert") ? settings.tls_reqcert : "never">
                            <option value="never" <cfif currentReqcert EQ "never">selected</cfif>>Never (no verification)</option>
                            <option value="allow" <cfif currentReqcert EQ "allow">selected</cfif>>Allow (verify if possible)</option>
                            <option value="try" <cfif currentReqcert EQ "try">selected</cfif>>Try (require valid cert if provided)</option>
                            <option value="demand" <cfif currentReqcert EQ "demand">selected</cfif>>Demand (require valid cert)</option>
                        </select>
                        <small class="text-muted">TLS certificate verification level</small>
                    </div>
                </div>
                <div class="col-md-3" id="global_cacert_group">
                    <div class="mb-3">
                        <label class="form-label"><strong>CA Certificate (or Bundle)</strong></label>
                        <cfif structKeyExists(settings, "ca_cert_file") AND len(settings.ca_cert_file)>
                            <div class="mb-2">
                                <span class="badge bg-success"><i class="fas fa-certificate"></i> <cfoutput>#settings.ca_cert_file#</cfoutput></span>
                                <div class="form-check mt-1">
                                    <input class="form-check-input" type="checkbox" name="remove_ca_cert" id="remove_global_ca_cert" value="1">
                                    <label class="form-check-label text-danger" for="remove_global_ca_cert">Remove certificate</label>
                                </div>
                            </div>
                        </cfif>
                        <input type="file" name="ca_cert_file" class="form-control" accept=".pem,.crt,.cer">
                        <small class="text-muted">Upload CA certificate or bundle (.pem, .crt, .cer). For multiple servers, concatenate CA certs into one file.</small>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="mb-3">
                        <label class="form-label"><strong>Retry Count</strong></label>
                        <input type="number" name="retry_count" class="form-control" value="<cfoutput>#structKeyExists(settings, "retry_count") ? settings.retry_count : 3#</cfoutput>" min="1" max="10">
                        <small class="text-muted">Authentication retry attempts (1-10)</small>
                    </div>
                </div>
            </div>
            <div class="mt-2">
                <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();"><i class="fas fa-save"></i> Save TLS Settings</button>
            </div>
        </form>
    </div>
</div>

<!-- Domain Mappings Card -->
<div class="card mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-server"></i> Domain Mappings</h3>
        <div class="card-tools">
            <a href="#add_mapping_modal" class="btn btn-sm btn-primary" data-bs-toggle="modal"><i class="fas fa-plus"></i> Add Mapping</a>
        </div>
    </div>
    <div class="card-body">
        <p>
            <button type="button" id="deleteBtn" class="btn btn-danger"><i class="fas fa-trash-alt"></i> Delete Selected</button>
        </p>

        <cfif getMappings.recordcount GTE 1>
            <table class="table table-striped" id="mappingsTable" style="width:100%">
                <thead>
                    <tr>
                        <th><input type="checkbox" id="selectAll"></th>
                        <th>Edit</th>
                        <th>Test</th>
                        <th>Domain</th>
                        <th>Server</th>
                        <th>Port</th>
                        <th>Remote DN Pattern</th>
                        <th>Description</th>
                        <th>Enabled</th>
                        <th>Synced</th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="getMappings">
                        <tr>
                            <td><input type="checkbox" name="mapping_id" value="#id#"></td>
                            <td><a href="edit_remoteauth_mapping.cfm?id=#id#" class="btn btn-secondary btn-sm"><i class="fas fa-edit"></i></a></td>
                            <td><button type="button" class="btn btn-info btn-sm test-btn" data-bs-toggle="modal" data-bs-target="##test_modal" data-domain="#domain_name#" data-server="#server_address#" data-port="#server_port#" data-dnpattern="#htmlEditFormat(remote_dn_pattern)#"><i class="fas fa-vial"></i></button></td>
                            <td>#domain_name#</td>
                            <td>#server_address#</td>
                            <td>#server_port#</td>
                            <td><cfif remote_dn_pattern NEQ ""><small>#remote_dn_pattern#</small><cfelse><span class="text-muted">Not set</span></cfif></td>
                            <td><cfif description NEQ "">#description#<cfelse><span class="text-muted">-</span></cfif></td>
                            <td><cfif settings.enabled EQ "1" AND enabled EQ 1><span class="badge bg-success">Yes</span><cfelse><span class="badge bg-secondary">No</span></cfif></td>
                            <td><cfif settings.enabled EQ "1" AND ldap_synced EQ 1><span class="badge bg-success">Yes</span><cfelse><span class="badge bg-warning text-dark">No</span></cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
                <tfoot>
                    <tr>
                        <th></th>
                        <th>Edit</th>
                        <th>Test</th>
                        <th>Domain</th>
                        <th>Server</th>
                        <th>Port</th>
                        <th>Remote DN Pattern</th>
                        <th>Description</th>
                        <th>Enabled</th>
                        <th>Synced</th>
                    </tr>
                </tfoot>
            </table>
        <cfelse>
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i> No domain mappings configured. Click "Add Mapping" to add one.
            </div>
        </cfif>
    </div>
</div>


<!-- Add Mapping Modal -->
<div class="modal fade" id="add_mapping_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h4 class="modal-title"><i class="fas fa-plus"></i> Add Domain Mapping</h4>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="">
                <div class="modal-body">
                    <input type="hidden" name="action" value="add_mapping">
                    <div class="mb-3">
                        <label class="form-label">Domain Name <span class="text-danger">*</span></label>
                        <input type="text" name="domain_name" class="form-control" required placeholder="e.g., deeztek">
                        <small class="text-muted">The domain identifier for this mapping (unique identifier)</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Server Address <span class="text-danger">*</span></label>
                        <input type="text" name="server_address" class="form-control" required placeholder="e.g., dc01.example.com">
                        <small class="text-muted">Hostname or IP address of the remote LDAP server</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Server Port</label>
                        <input type="number" name="server_port" class="form-control" value="389" min="1" max="65535">
                        <small class="text-muted">LDAP port (389 for standard, 636 for LDAPS)</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Remote DN Pattern <span class="text-danger">*</span></label>
                        <input type="text" name="remote_dn_pattern" class="form-control" required placeholder="e.g., cn={firstname} {lastname},ou=Users,dc=example,dc=com">
                        <small class="text-muted">
                            The DN pattern must match your directory user naming convention. Placeholders: <code>{username}</code>, <code>{firstname}</code>, <code>{lastname}</code>, <code>{email}</code><br>
                            <strong>AD (display name as CN):</strong> <code>cn={firstname} {lastname},ou=Users,dc=example,dc=com</code><br>
                            <strong>AD (username as CN):</strong> <code>cn={username},ou=Users,dc=example,dc=com</code><br>
                            <strong>OpenLDAP/FreeIPA:</strong> <code>uid={username},ou=People,dc=example,dc=com</code>
                        </small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <input type="text" name="description" class="form-control" placeholder="Optional description">
                    </div>
                    <div class="alert alert-info mb-0">
                        <small><i class="fas fa-info-circle"></i> TLS settings (STARTTLS, certificate verification, CA certificate, retry count) are configured globally in the "Global TLS Settings" card above.</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add Mapping</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h4 class="modal-title"><i class="fas fa-exclamation-triangle"></i> Delete Mapping(s)</h4>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete the selected domain mapping(s)? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <form method="post" action="">
                    <input type="hidden" name="action" value="delete_mappings">
                    <input type="hidden" name="delete_ids" id="deleteIds" value="">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Test Connection Modal -->
<div class="modal fade" id="test_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h4 class="modal-title"><i class="fas fa-vial"></i> Test LDAP Connection</h4>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="">
                <div class="modal-body">
                    <input type="hidden" name="action" value="test_connection">
                    <input type="hidden" name="test_domain" id="test_domain" value="">
                    <input type="hidden" name="test_server" id="test_server" value="">
                    <input type="hidden" name="test_port" id="test_port" value="">
                    <input type="hidden" name="test_dnpattern" id="test_dnpattern" value="">

                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> Enter credentials to test the LDAP connection to <strong id="test_domain_display"></strong>
                        <br><small>Uses global TLS settings configured above.</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><strong>Server:</strong></label>
                        <p id="test_server_display" class="form-control-plaintext"></p>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><strong>Username</strong> <span class="text-danger">*</span></label>
                        <input type="text" name="test_username" id="test_username" class="form-control" required placeholder="e.g., jsmith">
                        <small class="text-muted">Enter the directory username (uid or sAMAccountName)</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><strong>First Name</strong></label>
                        <input type="text" name="test_firstname" id="test_firstname" class="form-control" placeholder="e.g., John">
                        <small class="text-muted">Required if DN pattern uses {firstname}</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><strong>Last Name</strong></label>
                        <input type="text" name="test_lastname" id="test_lastname" class="form-control" placeholder="e.g., Smith">
                        <small class="text-muted">Required if DN pattern uses {lastname}</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><strong>Password</strong> <span class="text-danger">*</span></label>
                        <input type="password" name="test_password" id="test_password" class="form-control" required placeholder="Enter directory password">
                    </div>

                    <div id="test_result" class="mt-3" style="display:none;"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-info" id="test_submit_btn">
                        <i class="fas fa-vial"></i> Test Connection
                    </button>
                </div>
            </form>
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

// Show/hide CA certificate field based on global TLS reqcert selection
document.addEventListener('DOMContentLoaded', function() {
    const globalTlsReqcertSelect = document.getElementById('global_tls_reqcert');
    const globalCacertGroup = document.getElementById('global_cacert_group');

    function toggleGlobalCacertField() {
        if (globalTlsReqcertSelect && globalCacertGroup) {
            if (globalTlsReqcertSelect.value === 'never') {
                globalCacertGroup.style.display = 'none';
            } else {
                globalCacertGroup.style.display = 'block';
            }
        }
    }

    // Initial state
    toggleGlobalCacertField();

    // On change
    if (globalTlsReqcertSelect) {
        globalTlsReqcertSelect.addEventListener('change', toggleGlobalCacertField);
    }

    // Test modal - populate fields when test button is clicked
    const testModal = document.getElementById('test_modal');
    if (testModal) {
        testModal.addEventListener('show.bs.modal', function(event) {
            const button = event.relatedTarget;
            const domain = button.getAttribute('data-domain');
            const server = button.getAttribute('data-server');
            const port = button.getAttribute('data-port');
            const dnpattern = button.getAttribute('data-dnpattern');

            // Set hidden fields
            document.getElementById('test_domain').value = domain;
            document.getElementById('test_server').value = server;
            document.getElementById('test_port').value = port;
            document.getElementById('test_dnpattern').value = dnpattern;

            // Set display fields
            document.getElementById('test_domain_display').textContent = domain;
            document.getElementById('test_server_display').textContent = server + ':' + port;

            // Clear previous inputs and results
            document.getElementById('test_username').value = '';
            document.getElementById('test_firstname').value = '';
            document.getElementById('test_lastname').value = '';
            document.getElementById('test_password').value = '';
            document.getElementById('test_result').style.display = 'none';
            document.getElementById('test_result').innerHTML = '';
        });
    }
});
</script>

</body>
</html>
