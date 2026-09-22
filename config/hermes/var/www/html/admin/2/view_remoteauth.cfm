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

<!--- Pro Edition License Check --->
<cfinclude template="./inc/license_check.cfm" />

<!--- PRO EDITION CHECK --->
<cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
    <cfset proFeatureName = "LDAP RemoteAuth Configuration">
    <cfinclude template="./inc/license_pro_required.cfm">
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

            <!--- Upload BEFORE removing the current bundle. The old order
                 deleted first, so a rejected upload (wrong type, bad file)
                 left no bundle at all. With an LDAPS mapping on tls_reqcert
                 demand that breaks authentication as the result of a failed
                 attempt to ADD a certificate, which is the worst possible
                 moment to lose trust. --->
            <cfset caCertTarget = "global_remoteauth_ca.pem">

            <cffile action="upload"
                fileField="ca_cert_file"
                destination="#certsDir#"
                nameConflict="makeunique"
                accept="application/x-x509-ca-cert,application/pkix-cert,application/x-pem-file,text/plain,.pem,.crt,.cer">

            <cfset caCertUploaded = cffile.serverFile>

            <!--- Only now is the previous bundle expendable. --->
            <cfif caCertUploaded NEQ caCertTarget>
                <cfif fileExists("#certsDir#/#caCertTarget#")>
                    <cffile action="delete" file="#certsDir#/#caCertTarget#">
                </cfif>
                <cffile action="rename"
                    source="#certsDir#/#caCertUploaded#"
                    destination="#certsDir#/#caCertTarget#">
            </cfif>

            <cfset caCertFilename = caCertTarget>
        </cfif>

        <!--- Client certificate and key (#335). Mutual TLS: Google Secure LDAP
             will not accept a connection without one. Same ordering rule as
             the CA bundle above -- upload first, replace only on success --
             and the same reason: losing a working certificate as the result
             of a failed attempt to replace it is the worst outcome.

             The pair is all-or-nothing. A certificate without its key cannot
             be used, and emitting half of it produces an overlay slapd
             rejects, so removing either removes both. --->
        <cfquery name="getCurrentClient" datasource="hermes">
            SELECT setting_name, setting_value FROM remoteauth_settings
             WHERE setting_name IN ('client_cert_file', 'client_key_file')
        </cfquery>
        <cfset clientCertFilename = "">
        <cfset clientKeyFilename  = "">
        <cfloop query="getCurrentClient">
            <cfif getCurrentClient.setting_name IS "client_cert_file"><cfset clientCertFilename = getCurrentClient.setting_value></cfif>
            <cfif getCurrentClient.setting_name IS "client_key_file"><cfset clientKeyFilename  = getCurrentClient.setting_value></cfif>
        </cfloop>

        <cfif structKeyExists(form, "remove_client_cert") AND form.remove_client_cert EQ "1">
            <cfloop list="#clientCertFilename#,#clientKeyFilename#" index="oneOld">
                <cfif Len(Trim(oneOld)) AND fileExists("#certsDir#/#Trim(oneOld)#")>
                    <cffile action="delete" file="#certsDir#/#Trim(oneOld)#">
                </cfif>
            </cfloop>
            <cfset clientCertFilename = "">
            <cfset clientKeyFilename  = "">
        </cfif>

        <cfif structKeyExists(form, "client_cert_file") AND len(form.client_cert_file)
          AND structKeyExists(form, "client_key_file")  AND len(form.client_key_file)>

            <cfif NOT directoryExists(certsDir)>
                <cfdirectory action="create" directory="#certsDir#" mode="755">
            </cfif>

            <cfset clientCertTarget = "global_remoteauth_client.pem">
            <cfset clientKeyTarget  = "global_remoteauth_client.key">

            <cffile action="upload" fileField="client_cert_file" destination="#certsDir#"
                nameConflict="makeunique"
                accept="application/x-x509-ca-cert,application/pkix-cert,application/x-pem-file,text/plain,.pem,.crt,.cer">
            <cfset clientCertUploaded = cffile.serverFile>

            <cffile action="upload" fileField="client_key_file" destination="#certsDir#"
                nameConflict="makeunique"
                accept="application/x-pem-file,application/pkcs8,text/plain,.pem,.key">
            <cfset clientKeyUploaded = cffile.serverFile>

            <cfif clientCertUploaded NEQ clientCertTarget>
                <cfif fileExists("#certsDir#/#clientCertTarget#")><cffile action="delete" file="#certsDir#/#clientCertTarget#"></cfif>
                <cffile action="rename" source="#certsDir#/#clientCertUploaded#" destination="#certsDir#/#clientCertTarget#">
            </cfif>
            <cfif clientKeyUploaded NEQ clientKeyTarget>
                <cfif fileExists("#certsDir#/#clientKeyTarget#")><cffile action="delete" file="#certsDir#/#clientKeyTarget#"></cfif>
                <cffile action="rename" source="#certsDir#/#clientKeyUploaded#" destination="#certsDir#/#clientKeyTarget#">
            </cfif>

            <!--- slapd reads this as root, but the key should not be readable
                 to anything else that gains a foothold in either container. --->
            <cffile action="write" file="/opt/hermes/tmp/remoteauth_keyperm.sh" mode="700"
                output="##!/bin/bash#Chr(10)#chmod 600 '#certsDir#/#clientKeyTarget#'#Chr(10)#" addNewLine="no">
            <cftry>
                <cfexecute name="/bin/bash" arguments="/opt/hermes/tmp/remoteauth_keyperm.sh" timeout="15" variable="kpOut" errorVariable="kpErr"></cfexecute>
                <cfcatch></cfcatch>
            </cftry>
            <cftry><cffile action="delete" file="/opt/hermes/tmp/remoteauth_keyperm.sh"><cfcatch></cfcatch></cftry>

            <cfset clientCertFilename = clientCertTarget>
            <cfset clientKeyFilename  = clientKeyTarget>
        </cfif>

        <cfquery datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = <cfqueryparam value="#clientCertFilename#" cfsqltype="cf_sql_varchar">
             WHERE setting_name = 'client_cert_file'
        </cfquery>
        <cfquery datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = <cfqueryparam value="#clientKeyFilename#" cfsqltype="cf_sql_varchar">
             WHERE setting_name = 'client_key_file'
        </cfquery>

        <!--- Update TLS settings in database --->
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
    <!--- STARTTLS cannot run on a connection that is already TLS. With the
         STARTTLS control removed from this page, refusing here would be a dead
         end: there would be no way to satisfy the requirement. So it resolves
         itself and says what it did. The seed default is already "no", so this
         fires only on an install that set it years ago. --->
    <cfif val(form.use_ldaps) EQ 1>
        <cfquery name="starttlsOn" datasource="hermes">
            SELECT setting_value FROM remoteauth_settings WHERE setting_name = 'tls_starttls'
        </cfquery>
        <cfif starttlsOn.recordcount GTE 1 AND starttlsOn.setting_value EQ "yes">
            <cfquery datasource="hermes">
                UPDATE remoteauth_settings SET setting_value = 'no' WHERE setting_name = 'tls_starttls'
            </cfquery>
            <cfset session.raNotice = "STARTTLS was turned off because this mapping uses LDAPS, which is already encrypted and cannot be upgraded again. Any plain mapping that was being upgraded is now unencrypted. Test those mappings, or move them to LDAPS as well.">
        </cfif>
    </cfif>

    <cftry>
        <!--- TLS settings are now global, not per-mapping --->
        <cfquery name="insertMapping" datasource="hermes">
            INSERT INTO remoteauth_mappings (domain_name, server_address, server_port, use_ldaps, remote_dn_pattern, description, enabled, ldap_synced)
            VALUES (
                <cfqueryparam value="#trim(form.domain_name)#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#trim(form.server_address)#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#val(form.server_port)#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#(val(form.use_ldaps) EQ 1 ? 1 : 0)#" cfsqltype="cf_sql_integer">,
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
            SELECT id, domain_name FROM remoteauth_mappings
            WHERE id IN (<cfqueryparam value="#idList#" cfsqltype="cf_sql_integer" list="yes">)
        </cfquery>

        <!--- Build list of domains to check --->
        <cfset domainList = valueList(getMappingDomains.domain_name)>

        <!--- Check if any system users are assigned to these mappings --->
        <cfquery name="checkUsersAssigned" datasource="hermes">
            SELECT remoteauth_domain, COUNT(*) AS user_count FROM system_users
            WHERE auth_type = 'remote'
            AND remoteauth_domain IN (<cfqueryparam value="#domainList#" cfsqltype="cf_sql_varchar" list="yes">)
            GROUP BY remoteauth_domain
        </cfquery>

        <!--- Check if any recipients are assigned to these mappings --->
        <cfquery name="checkRecipientsAssigned" datasource="hermes">
            SELECT remoteauth_domain, COUNT(*) AS user_count FROM recipients
            WHERE auth_type = 'remote'
            AND remoteauth_domain IN (<cfqueryparam value="#domainList#" cfsqltype="cf_sql_varchar" list="yes">)
            GROUP BY remoteauth_domain
        </cfquery>

        <!--- Combine blocked domains from both system users and recipients --->
        <cfset blockedDomains = "">
        <cfif checkUsersAssigned.recordcount GT 0>
            <cfset blockedDomains = valueList(checkUsersAssigned.remoteauth_domain)>
        </cfif>
        <cfif checkRecipientsAssigned.recordcount GT 0>
            <cfloop query="checkRecipientsAssigned">
                <cfif NOT listFindNoCase(blockedDomains, checkRecipientsAssigned.remoteauth_domain)>
                    <cfset blockedDomains = listAppend(blockedDomains, checkRecipientsAssigned.remoteauth_domain)>
                </cfif>
            </cfloop>
        </cfif>

        <cfif len(blockedDomains)>
            <!--- Some mappings have users/recipients assigned - cannot delete those --->
            <cfset session.m = "ra_delete_blocked">
            <cfset session.blockedDomains = blockedDomains>
            <cflocation url="view_remoteauth.cfm" addtoken="no">
        </cfif>

        <!--- Safe to delete - no users assigned --->
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
<cffunction name="raShq" access="private" returntype="string" output="false">
    <cfargument name="v" type="string" required="true">
    <cfreturn Replace(arguments.v, "'", "'\''", "all")>
</cffunction>

<cffunction name="raTestExplain" access="private" returntype="string" output="false">
    <cfargument name="raw"    type="string" required="true">
    <cfargument name="server" type="string" required="true">
    <cfargument name="port"   type="string" required="true">
    <cfargument name="scheme" type="string" required="true">
    <cfargument name="hasCa"   type="boolean" required="false" default="true">
    <cfset var txt  = Trim(arguments.raw)>
    <cfset var hint = "">
    <cfif FindNoCase("Invalid credentials", txt) GT 0 OR FindNoCase("data 52e", txt) GT 0>
        <cfset hint = "The directory accepted the connection but rejected the password for that user. The Bind DN shown below is the account it tried; if that DN looks wrong, the mapping's DN pattern is what to fix.">
    <cfelseif FindNoCase("Can't contact LDAP server", txt) GT 0>
        <!--- OpenLDAP reports a failed TLS handshake as the same -1 "can't
             contact" as a dead port, so this message is ambiguous on LDAPS.
             Lead with the certificate when verification is on and there is no
             CA bundle to verify against, because that is by far the more
             likely cause and the other reading sends an administrator to
             check a firewall that is fine. --->
        <cfif arguments.scheme IS "ldaps" AND NOT arguments.hasCa>
            <cfset hint = "Most likely the server certificate could not be verified: no CA bundle is uploaded, and an LDAPS mapping always verifies. OpenLDAP reports a rejected certificate with the same message as an unreachable server, so this may instead mean nothing is listening on " & arguments.server & ":" & arguments.port & ".">
        <cfelseif arguments.scheme IS "ldaps">
            <cfset hint = "Either " & arguments.server & ":" & arguments.port & " is unreachable, or the server certificate was rejected -- OpenLDAP reports both the same way. Check that the CA bundle covers this server and that the address matches the certificate's hostname rather than being an IP.">
        <cfelse>
            <cfset hint = "Could not reach " & arguments.server & " on port " & arguments.port & ". Check the address, the port, and that the directory is listening on it.">
        </cfif>
    <cfelseif FindNoCase("No such object", txt) GT 0 OR FindNoCase("data 525", txt) GT 0>
        <cfset hint = "The directory has no account at that DN. The mapping's DN pattern does not match how users are named there.">
    <cfelseif FindNoCase("TLS", txt) GT 0 OR FindNoCase("certificate", txt) GT 0>
        <cfset hint = "The server certificate was rejected. Upload a CA bundle that covers it, and make sure the address above matches the certificate's hostname rather than being an IP.">
    </cfif>
    <cfreturn Len(hint) ? hint & " (" & txt & ")" : txt>
</cffunction>

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
        WHERE setting_name IN ('tls_starttls', 'tls_reqcert', 'ca_cert_file', 'client_cert_file', 'client_key_file')
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

    <!--- Build the LDAP URL. LDAPS only (#335): the overlay is pinned to
         the mapping's own transport, so a probe on the wrong scheme would pass
         on a directory that production cannot reach. --->
    <cfparam name="form.test_use_ldaps" default="0">
    <cfset testScheme = (val(form.test_use_ldaps) EQ 1) ? "ldaps" : "ldap">
    <cfset ldapUrl = testScheme & "://" & form.test_server & ":" & form.test_port>

    <!--- ldapsearch reads its TLS settings from the client config, not from
         olcRemoteAuthTLS, so the overlay's posture is passed explicitly.
         Without this the probe would silently verify nothing. --->
    <!--- Mirrors what the sync derives: choosing LDAPS is choosing verification,
         so the probe must verify too. A probe that is laxer than production
         passes on a directory production will refuse. --->
    <cfset testReqcert = (testScheme IS "ldaps")
                       ? "demand"
                       : (structKeyExists(globalTLS, "tls_reqcert") ? globalTLS.tls_reqcert : "never")>
    <cfset testEnv = " -e LDAPTLS_REQCERT='#raShq(testReqcert)#'">
    <!--- The DERIVED bundle, matching what the overlay verifies against. The
         uploaded file alone is missing the public roots, so a probe using it
         would reject a directory production accepts. --->
    <cfif structKeyExists(globalTLS, "ca_cert_file") AND len(globalTLS.ca_cert_file)>
        <cfset testEnv = testEnv & " -e LDAPTLS_CACERT='/opt/hermes/certs/remoteauth/remoteauth_ca_effective.pem'">
    </cfif>

    <!--- The client certificate reached the overlay and enumeration but never
         this probe, so a directory requiring mutual TLS dropped the handshake
         here while working in production. OpenLDAP reports that as "can't
         contact", which reads as an unreachable server and sends an
         administrator to check a firewall that is fine. --->
    <cfif structKeyExists(globalTLS, "client_cert_file") AND len(globalTLS.client_cert_file)
      AND structKeyExists(globalTLS, "client_key_file")  AND len(globalTLS.client_key_file)>
        <cfset testEnv = testEnv & " -e LDAPTLS_CERT='/opt/hermes/certs/remoteauth/#raShq(globalTLS.client_cert_file)#'">
        <cfset testEnv = testEnv & " -e LDAPTLS_KEY='/opt/hermes/certs/remoteauth/#raShq(globalTLS.client_key_file)#'">
    </cfif>

    <!--- Password goes to a file read with -y, never into the command. It used
         to be an argument, visible in the host process list, and moving the
         command into a script would have put it on disk in the script itself.
         Every other value is single-quoted and escaped: a DN can legitimately
         contain an apostrophe, and these are all operator input. --->
    <cfset tcPw = "/opt/hermes/tmp/" & LCase(Left(Replace(CreateUUID(), "-", "", "all"), 10)) & "_ra_test.pw">
    <cffile action="write" file="#tcPw#" output="#form.test_password#" charset="utf-8" mode="600" addNewLine="no">
    <!--- A root DSE read, not ldapwhoami. Whoami is an EXTENDED OPERATION and
         Google Secure LDAP does not implement it, so a perfectly good bind
         came back as "Protocol error (2)" from the whoami step and the probe
         reported failure for every correctly configured Google mapping.

         A base-scope read of the root DSE is supported everywhere and tests
         the same thing: ldapsearch exits before searching if the bind is
         refused, so a returned entry proves the credentials were accepted. --->
    <cfset ldapCommand = "exec#testEnv# hermes_ldap ldapsearch -LLL -o ldif-wrap=no -x -H '#raShq(ldapUrl)#' -D '#raShq(testDn)#' -y '#tcPw#' -b '' -s base '(objectClass=*)' 1.1">
    <cfif testScheme IS "ldap" AND structKeyExists(globalTLS, "tls_starttls") AND globalTLS.tls_starttls EQ "yes">
        <cfset ldapCommand = ldapCommand & " -ZZ">
    </cfif>

    <!--- Run it through a temp script that redirects both streams to files
         and always exits 0.

         cfexecute throws when the command exits non-zero, and ldapsearch does
         exactly that on a rejected bind. Worse, it does not reliably populate
         errorVariable on that path, so the catch had nothing to report and
         showed Lucee's "Error invoking external process" instead of the LDAP
         reason. Capturing the streams in the shell sidesteps both: the exit
         code is neutralised and the text is on disk either way.

         Same approach directory_sync.cfm uses, for the same reason. --->
    <cfset tcId   = LCase(Left(Replace(CreateUUID(), "-", "", "all"), 10))>
    <cfset tcSh   = "/opt/hermes/tmp/#tcId#_ra_test.sh">
    <cfset tcOut  = "/opt/hermes/tmp/#tcId#_ra_test.out">
    <cfset tcErr  = "/opt/hermes/tmp/#tcId#_ra_test.err">
    <cfset testResult = "">
    <cfset testError  = "">

    <cftry>
        <cfsavecontent variable="tcBody"><cfoutput>##!/bin/bash
/usr/local/bin/docker #ldapCommand# > '#tcOut#' 2> '#tcErr#'
exit 0
</cfoutput></cfsavecontent>
        <cffile action="write" file="#tcSh#" output="#tcBody#" charset="utf-8" mode="700" addNewLine="no">
        <cfexecute name="/bin/bash" arguments="#tcSh#" timeout="45" variable="tcShOut" errorVariable="tcShErr"></cfexecute>

        <cfif FileExists(tcOut)><cffile action="read" file="#tcOut#" variable="testResult" charset="utf-8"></cfif>
        <cfif FileExists(tcErr)><cffile action="read" file="#tcErr#" variable="testError"  charset="utf-8"></cfif>

        <cfcatch type="any">
            <cfset testError = Len(Trim(testError)) ? testError : cfcatch.message>
        </cfcatch>
    </cftry>

    <cfloop list="#tcSh#,#tcOut#,#tcErr#,#tcPw#" index="tcJunk">
        <cftry><cfif FileExists(tcJunk)><cffile action="delete" file="#tcJunk#"></cfif><cfcatch></cfcatch></cftry>
    </cfloop>

    <cfset session.testDomain = form.test_domain>
    <cfset session.testDn     = testDn>

    <!--- The bind was accepted if the search ran at all: ldapsearch exits
         before searching when a bind is refused, so any returned entry proves
         the credentials were good. Checking for an error in stderr as well,
         because a server can answer with a referral and no entry.

         An empty stderr was once treated as success here, which reported a
         healthy directory whenever the command produced no output at all. A
         probe that passes when nothing happened is worse than no probe. --->
    <cfif FindNoCase("dn:", testResult) GT 0
       OR (Len(Trim(testResult)) AND FindNoCase("ldap_", testError) LTE 0)>
        <cfset session.m = "ra_test_success">
        <cfset session.testResult = testResult>
    <cfelse>
        <cfset session.m = "ra_test_fail">
        <cfset session.testError = raTestExplain(testError, form.test_server, form.test_port, testScheme,
                    (structKeyExists(globalTLS, "ca_cert_file") AND Len(Trim(globalTLS.ca_cert_file))))>
    </cfif>

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
        <cfoutput>The following domain mapping(s) cannot be deleted because they have users or recipients assigned: <strong>#session.blockedDomains#</strong></cfoutput><br>
        <small>You must reassign or delete these users/recipients before deleting the mapping(s).</small>
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

<cfparam name="session.raNotice" default="">
<cfif Len(session.raNotice)>
    <cfoutput>
    <div class="alert alert-warning alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-triangle-exclamation"></i> Heads up</h4>
        #EncodeForHTML(session.raNotice)#
    </div>
    </cfoutput>
    <cfset session.raNotice = "">
</cfif>

<cfif m EQ "ra_error">
    <cfparam name="session.raError" default="">
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-ban"></i> Error!</h4>
        <cfif Len(session.raError)>
            <cfoutput>#EncodeForHTML(session.raError)#</cfoutput>
        <cfelse>
            An error occurred. Please try again.
        </cfif>
    </div>
    <cfset session.raError = "">
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
    SELECT id, domain_name, server_address, server_port, use_ldaps, remote_dn_pattern, retry_count, description, enabled, ldap_synced
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
    olcRemoteAuthMapping: example ldap://dc01.example.com:389
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
        <div class="callout callout-info mb-3">
            <p class="mb-1"><strong>Recipients always sign in with their e-mail address.</strong></p>
            <p class="mb-0"><small>Their username in your directory can be anything &mdash; <code>jsmith</code>, <code>John Smith</code>, an employee number &mdash; and Hermes never asks for it.
            The e-mail address is the Hermes username; the DN pattern below is only how Hermes locates that person in your directory in order to hand the password check over to it.
            (System users are the exception: their username is whatever an administrator sets, and is unrelated to this page.)</small></p>
        </div>
        <p><strong>Remote DN Pattern:</strong> This must match how users are named in your directory. Common patterns:</p>
        <ul>
            <li><code>cn={firstname} {lastname},ou=Users,dc=example,dc=com</code> - If directory uses display name as CN (e.g., "John Smith")</li>
            <li><code>cn={username},ou=Users,dc=example,dc=com</code> - If directory uses username as CN (e.g., "jsmith")</li>
            <li><code>uid={username},ou=People,dc=example,dc=com</code> - Common for OpenLDAP/FreeIPA</li>
        </ul>
        <p class="text-muted mb-0"><small><i class="fas fa-info-circle"></i> Check your directory user properties to determine which pattern applies. The DN must exactly match your directory naming convention.</small></p>
    </div>
</div>

<!-- DNS Resolution Prerequisite Card -->
<div class="card mb-4">
    <div class="card-header bg-warning text-dark">
        <h3 class="card-title"><i class="fas fa-exclamation-triangle"></i> Prerequisite: DNS Resolution for Internal AD/LDAP Hostnames</h3>
    </div>
    <div class="card-body">
        <p>If your AD/LDAP server hostname is resolvable only <strong>inside your internal network</strong> (e.g., <code>homedc01.corp.example.com</code>, <code>dc01.internal</code>, or anything on a split-horizon/private DNS zone), Hermes will not be able to reach it out of the box. The <code>hermes_ldap</code> container resolves hostnames through Hermes&rsquo;s internal Unbound DNS resolver, which by default queries public recursive DNS &mdash; it will not know about your internal-only names and RemoteAuth bind operations will fail with <code>remoteauth_bind operations error</code>.</p>
        <p><strong>Fix before creating a mapping:</strong></p>
        <ol class="mb-3">
            <li>Go to <a href="view_dns_resolver.cfm">System &rarr; DNS Resolver</a>.</li>
            <li>Add a <strong>DNS Local Record</strong> pointing your AD/LDAP server&rsquo;s FQDN to its actual IP address (e.g., <code>homedc01.corp.example.com</code> &rarr; <code>10.0.0.12</code>).</li>
            <li>Save and let Unbound reload.</li>
        </ol>
        <p class="mb-2"><strong>Verify from inside the LDAP container:</strong></p>
<pre class="bg-light p-2 mb-3 small"><code>docker exec hermes_ldap getent hosts &lt;ad-hostname&gt;</code></pre>
        <p class="mb-0"><small class="text-muted"><i class="fas fa-info-circle"></i> Publicly-resolvable hostnames (e.g., if your AD lives at a hostname with a real A record in public DNS) don&rsquo;t need a Local Record &mdash; skip this step. Test with the command above; if it returns an IP, you&rsquo;re already good.</small></p>
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
            <i class="fas fa-info-circle"></i> <strong>Transport is chosen per mapping, and there are two states:</strong>
<ul class="mb-1 mt-1">
  <li><strong>Plain LDAP</strong> &mdash; not encrypted. The user's password crosses the network in the clear.</li>
  <li><strong>LDAPS</strong> &mdash; encrypted, and the directory's certificate is verified against the CA bundle below. The address you enter must match the certificate's hostname.</li>
</ul>
There is no separate verification setting: choosing LDAPS is choosing verification. The CA bundle and retry count below are shared by <strong>every</strong> mapping, because the overlay is a singleton.
            <p class="mt-2 mb-0"><strong>Connecting to multiple LDAP servers with different CA certificates?</strong> Create a CA bundle by concatenating all CA certificates into a single PEM file:</p>
            <pre class="bg-dark text-light p-2 mt-2 mb-0" style="font-size: 0.85em;">cat server1-ca.pem server2-ca.pem server3-ca.pem > ca-bundle.pem</pre>
            <small class="text-muted d-block mt-1">Then upload the ca-bundle.pem file below. OpenLDAP will use all certificates in the bundle to validate any server.</small>
        </div>
        <form name="UpdateTLSSettings" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update_tls_settings">
            <div class="row">
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
                        <small class="text-muted">
                          <strong>Only needed for a directory with a private certificate authority</strong>
                          &mdash; an internal AD, typically. Public roots are always trusted, so a
                          directory with a commercial or cloud certificate needs nothing here.
                          <br>
                          Upload the certificate of the authority that <strong>issued</strong> the directory's
                          certificate, not the directory's own, unless that certificate is self-signed.
                          Must be <strong>Base-64 encoded X.509</strong> (PEM, begins <code>-----BEGIN CERTIFICATE-----</code>).
                          DER will be rejected at connection time rather than on upload.
                          <br>
                          <strong>Active Directory:</strong> on the CA server run
                          <code>certutil -ca.cert ca.cer</code>, or export from
                          <em>Certificates (Local Computer) &rarr; Trusted Root Certification Authorities</em>
                          choosing <em>Base-64 encoded X.509 (.CER)</em>.
                          Several internal authorities go in one file, concatenated. You never need to add a
                          public root: Hermes combines whatever you upload with the system trust store.
                        </small>
                        <small class="text-muted">Upload CA certificate or bundle (.pem, .crt, .cer). For multiple servers, concatenate CA certs into one file.</small>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="mb-3">
                        <label class="form-label d-block"><strong>Client Certificate</strong></label>
                        <cfif structKeyExists(settings, "client_cert_file") AND len(settings.client_cert_file)>
                            <div class="mb-2">
                                <span class="badge bg-success"><i class="fas fa-id-badge"></i> Installed</span>
                                <div class="form-check mt-1">
                                    <input class="form-check-input" type="checkbox" name="remove_client_cert" id="remove_client_cert" value="1">
                                    <label class="form-check-label text-danger" for="remove_client_cert">Remove certificate and key</label>
                                </div>
                            </div>
                        </cfif>
                        <label class="form-label d-block mb-1 mt-1"><small class="text-muted">Certificate (<code>.pem</code>, <code>.crt</code>, <code>.cer</code>)</small></label>
                        <input type="file" name="client_cert_file" class="form-control mb-2" accept=".pem,.crt,.cer">
                        <label class="form-label d-block mb-1"><small class="text-muted">Private key (<code>.pem</code>, <code>.key</code>)</small></label>
                        <input type="file" name="client_key_file" class="form-control" accept=".pem,.key">
                        <small class="text-muted">Only needed where the directory demands mutual TLS, such as Google Secure LDAP. Upload both together; one without the other cannot be used.</small>
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
                        <th>Transport</th>
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
                            <td><button type="button" class="btn btn-info btn-sm test-btn" data-bs-toggle="modal" data-bs-target="##test_modal" data-domain="#domain_name#" data-server="#server_address#" data-port="#server_port#" data-dnpattern="#htmlEditFormat(remote_dn_pattern)#" data-useldaps="#val(use_ldaps)#"><i class="fas fa-vial"></i></button></td>
                            <td>#domain_name#</td>
                            <td>#server_address#</td>
                            <td>#server_port#</td>
                            <td><cfif val(use_ldaps) EQ 1><span class="badge bg-success">LDAPS</span><cfelse><span class="badge bg-secondary">Plain</span></cfif></td>
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
                        <th>Transport</th>
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
                        <input type="text" name="domain_name" class="form-control" required placeholder="e.g., example">
                        <small class="text-muted">The domain identifier for this mapping (unique identifier)</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Server Address <span class="text-danger">*</span></label>
                        <input type="text" name="server_address" class="form-control" required placeholder="e.g., dc01.example.com">
                        <small class="text-muted">Hostname or IP address of the remote LDAP server</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Transport</label>
                        <select name="use_ldaps" id="add_use_ldaps" class="form-select" onchange="hermesSyncLdapPort(this, 'add_server_port')">
                            <option value="0" selected>Plain LDAP</option>
                            <option value="1">LDAPS</option>
                        </select>
                        <small class="text-muted">LDAPS is required for Google Secure LDAP. Mappings may differ: each one gets its own URI, so an existing plain connection is unaffected by adding an LDAPS one.</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Server Port</label>
                        <input type="number" name="server_port" id="add_server_port" class="form-control" value="389" min="1" max="65535">
                        <small class="text-muted">LDAP port (389 for standard, 636 for LDAPS)</small>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Remote DN Pattern <span class="text-danger">*</span></label>
                        <input type="text" name="remote_dn_pattern" class="form-control" required placeholder="e.g., cn={firstname} {lastname},ou=Users,dc=example,dc=com">
                        <small class="text-muted"><strong>This is not the sign-in username.</strong> Recipients always sign in as their e-mail address; this is only how Hermes finds them in your directory.<br>
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
                        <small><i class="fas fa-info-circle"></i> <strong>Transport is per mapping.</strong> Choosing LDAPS also turns on certificate verification for it, so the directory must present a certificate that validates and whose hostname matches the address above. The CA bundle and retry count are shared by every mapping and live in the "Global TLS Settings" card.</small>
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
                    <input type="hidden" name="test_use_ldaps" id="test_use_ldaps" value="0">
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
                    </div>
                    <div class="mb-3">
                        <label class="form-label">E-mail address</label>
                        <input type="email" name="test_email" id="test_email" class="form-control" placeholder="e.g., jsmith@example.com">
                        <small class="text-muted">Only needed when the DN pattern uses <code>{email}</code>, as Google Secure LDAP does. Left blank, that placeholder cannot be substituted and the bind is attempted against a DN containing it literally.</small>
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

document.addEventListener('DOMContentLoaded', function() {
    // Test modal - populate fields when test button is clicked
    const testModal = document.getElementById('test_modal');
    if (testModal) {
        testModal.addEventListener('show.bs.modal', function(event) {
            const button = event.relatedTarget;
            const domain = button.getAttribute('data-domain');
            const server = button.getAttribute('data-server');
            const port = button.getAttribute('data-port');
            const dnpattern = button.getAttribute('data-dnpattern');
            const useLdaps = button.getAttribute('data-useldaps') || '0';

            // Set hidden fields
            document.getElementById('test_domain').value = domain;
            document.getElementById('test_server').value = server;
            document.getElementById('test_port').value = port;
            document.getElementById('test_dnpattern').value = dnpattern;
            document.getElementById('test_use_ldaps').value = useLdaps;

            // Set display fields
            document.getElementById('test_domain_display').textContent = domain;
            document.getElementById('test_server_display').textContent =
                (useLdaps === '1' ? 'ldaps://' : 'ldap://') + server + ':' + port;

            // Clear previous inputs and results
            document.getElementById('test_username').value = '';
            var tEmail = document.getElementById('test_email');
            if (tEmail) { tEmail.value = ''; }
            document.getElementById('test_firstname').value = '';
            document.getElementById('test_lastname').value = '';
            document.getElementById('test_password').value = '';
            document.getElementById('test_result').style.display = 'none';
            document.getElementById('test_result').innerHTML = '';
        });
    }
});
</script>

<script>
// Transport and port are separate fields, so the dropdown must not claim a
// port. It moves the port to the conventional default as a convenience, but
// only when the field still holds the other convention's default: a directory
// deliberately on 6636 is not clobbered by toggling transport.
function hermesSyncLdapPort(sel, portId) {
    var port = document.getElementById(portId);
    if (!port) { return; }
    var v = (port.value || '').trim();
    var wantsLdaps = (sel.value === '1' || sel.value === 'ldaps');
    if (wantsLdaps  && (v === '' || v === '389')) { port.value = '636'; }
    if (!wantsLdaps && (v === '' || v === '636')) { port.value = '389'; }
}
</script>

</body>
</html>
