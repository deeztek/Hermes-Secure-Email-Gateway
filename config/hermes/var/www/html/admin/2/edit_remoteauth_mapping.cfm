<!DOCTYPE html>

<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<html lang="en">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hermes SEG | Edit Domain Mapping</title>

<cfinclude template="./inc/html_head.cfm" />

<style>
.alert a {
    color: #fff;
    text-decoration: none;
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
                <h1 class="m-0">Edit Domain Mapping</h1>
            </div>
            <div class="col-sm-6">
                <ol class="breadcrumb float-sm-end">
                    <li class="breadcrumb-item"><a href="#">Home</a></li>
                    <li class="breadcrumb-item"><a href="view_remoteauth.cfm">RemoteAuth</a></li>
                    <li class="breadcrumb-item active">Edit Mapping</li>
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

<!--- Initialize variables --->
<cfparam name="action" default="">
<cfparam name="url.id" default="0">

<cfif IsDefined("form.action")>
    <cfif form.action NEQ "">
        <cfset action = form.action>
    </cfif>
</cfif>

<!--- HANDLE UPDATE ACTION --->
<cfif action EQ "update_mapping">
    <cftry>
        <!--- TLS settings are now global, not per-mapping --->
        <cfquery name="updateMapping" datasource="hermes">
            UPDATE remoteauth_mappings SET
                domain_name = <cfqueryparam value="#trim(form.domain_name)#" cfsqltype="cf_sql_varchar">,
                server_address = <cfqueryparam value="#trim(form.server_address)#" cfsqltype="cf_sql_varchar">,
                server_port = <cfqueryparam value="#val(form.server_port)#" cfsqltype="cf_sql_integer">,
                remote_dn_pattern = <cfqueryparam value="#trim(form.remote_dn_pattern)#" cfsqltype="cf_sql_varchar">,
                description = <cfqueryparam value="#trim(form.description)#" cfsqltype="cf_sql_varchar">,
                enabled = <cfqueryparam value="#val(form.enabled)#" cfsqltype="cf_sql_integer">,
                ldap_synced = 0
            WHERE id = <cfqueryparam value="#val(form.mapping_id)#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfquery name="markUnsyncedSettings" datasource="hermes">
            UPDATE remoteauth_settings SET setting_value = '0' WHERE setting_name = 'ldap_synced'
        </cfquery>
        <cfset session.m = "ra_mapping_updated">
        <cflocation url="view_remoteauth.cfm" addtoken="no">
        <cfcatch type="database">
            <cfif cfcatch.message CONTAINS "Duplicate">
                <cfset errorMessage = "A domain mapping with that name already exists.">
            <cfelse>
                <cfset errorMessage = "Database error: #cfcatch.message#">
            </cfif>
        </cfcatch>
    </cftry>
</cfif>

<!--- HANDLE DELETE ACTION --->
<cfif action EQ "delete_mapping">
    <!--- Get the mapping domain name for user check --->
    <cfquery name="getMappingDomain" datasource="hermes">
        SELECT domain_name, ca_cert_file FROM remoteauth_mappings
        WHERE id = <cfqueryparam value="#val(form.mapping_id)#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!--- Check if any users are assigned to this mapping --->
    <cfif getMappingDomain.recordcount GT 0>
        <cfquery name="checkUsersAssigned" datasource="hermes">
            SELECT COUNT(*) AS user_count FROM system_users
            WHERE auth_type = 'remote'
            AND remoteauth_domain = <cfqueryparam value="#getMappingDomain.domain_name#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif checkUsersAssigned.user_count GT 0>
            <!--- Cannot delete - users are assigned --->
            <cfset errorMessage = "Cannot delete this mapping. #checkUsersAssigned.user_count# user(s) are configured to use this domain for remote authentication. Please reassign or delete these users first.">
        <cfelse>
            <!--- Safe to delete --->
            <!--- Delete certificate file if exists --->
            <cfif len(getMappingDomain.ca_cert_file)>
                <cfset certPath = "/opt/hermes/certs/remoteauth/#getMappingDomain.ca_cert_file#">
                <cfif fileExists(certPath)>
                    <cffile action="delete" file="#certPath#">
                </cfif>
            </cfif>

            <cfquery name="deleteMapping" datasource="hermes">
                DELETE FROM remoteauth_mappings WHERE id = <cfqueryparam value="#val(form.mapping_id)#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfquery name="markUnsyncedSettings" datasource="hermes">
                UPDATE remoteauth_settings SET setting_value = '0' WHERE setting_name = 'ldap_synced'
            </cfquery>
            <cfset session.m = "ra_delete">
            <cflocation url="view_remoteauth.cfm" addtoken="no">
        </cfif>
    </cfif>
</cfif>

<!--- FETCH MAPPING DATA --->
<cfquery name="getMapping" datasource="hermes">
    SELECT id, domain_name, server_address, server_port, remote_dn_pattern, tls_starttls, tls_reqcert, ca_cert_file, retry_count, description, enabled, ldap_synced
    FROM remoteauth_mappings
    WHERE id = <cfqueryparam value="#val(url.id)#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- Get count of users assigned to this mapping --->
<cfset assignedUserCount = 0>
<cfif getMapping.recordcount GT 0>
    <cfquery name="getAssignedUsers" datasource="hermes">
        SELECT COUNT(*) AS user_count FROM system_users
        WHERE auth_type = 'remote'
        AND remoteauth_domain = <cfqueryparam value="#getMapping.domain_name#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfset assignedUserCount = getAssignedUsers.user_count>
</cfif>

<cfif getMapping.recordcount EQ 0>
    <div class="alert alert-danger">
        <h4><i class="icon fa fa-ban"></i> Error!</h4>
        Domain mapping not found. <a href="view_remoteauth.cfm">Return to RemoteAuth</a>
    </div>
<cfelse>

<!--- Show error message if exists --->
<cfif IsDefined("errorMessage")>
    <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        <h4><i class="icon fa fa-ban"></i> Error!</h4>
        <cfoutput>#errorMessage#</cfoutput>
    </div>
</cfif>

<!-- Action Buttons -->
<p>
    <a href="view_remoteauth.cfm" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to RemoteAuth</a>
    <cfif assignedUserCount GT 0>
        <button type="button" class="btn btn-danger float-end" disabled title="Cannot delete - #assignedUserCount# user(s) assigned"><i class="fas fa-trash-alt"></i> Delete Mapping</button>
    <cfelse>
        <a href="##delete_modal" class="btn btn-danger float-end" data-bs-toggle="modal"><i class="fas fa-trash-alt"></i> Delete Mapping</a>
    </cfif>
</p>

<cfif assignedUserCount GT 0>
<div class="alert alert-warning">
    <i class="fas fa-exclamation-triangle"></i> <strong>Cannot Delete:</strong> This domain mapping has <cfoutput><strong>#assignedUserCount#</strong></cfoutput> user(s) configured to use it for remote authentication.
    You must reassign or delete these users before deleting this mapping.
</div>
</cfif>

<!-- Edit Form Card -->
<div class="card">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-edit"></i> Edit Domain Mapping</h3>
    </div>
    <form method="post" action="" enctype="multipart/form-data">
        <div class="card-body">
            <input type="hidden" name="action" value="update_mapping">
            <input type="hidden" name="mapping_id" value="<cfoutput>#getMapping.id#</cfoutput>">

            <div class="mb-3">
                <label class="form-label">Domain Name <span class="text-danger">*</span></label>
                <input type="text" name="domain_name" class="form-control" value="<cfoutput>#getMapping.domain_name#</cfoutput>" required>
                <small class="text-muted">The domain identifier for this mapping (e.g., deeztek)</small>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="form-label">Server Address <span class="text-danger">*</span></label>
                        <input type="text" name="server_address" class="form-control" value="<cfoutput>#getMapping.server_address#</cfoutput>" required>
                        <small class="text-muted">Hostname or IP address of the remote LDAP server</small>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="form-label">Server Port</label>
                        <input type="number" name="server_port" class="form-control" value="<cfoutput>#getMapping.server_port#</cfoutput>" min="1" max="65535">
                        <small class="text-muted">LDAP port (389 for standard, 636 for LDAPS)</small>
                    </div>
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label">Remote DN Pattern <span class="text-danger">*</span></label>
                <input type="text" name="remote_dn_pattern" class="form-control" value="<cfoutput>#getMapping.remote_dn_pattern#</cfoutput>" required>
                <small class="text-muted">
                    The DN pattern must match your directory user naming convention. Placeholders: <code>{username}</code>, <code>{firstname}</code>, <code>{lastname}</code>, <code>{email}</code><br>
                    <strong>AD (display name as CN):</strong> <code>cn={firstname} {lastname},ou=Users,dc=example,dc=com</code><br>
                    <strong>AD (username as CN):</strong> <code>cn={username},ou=Users,dc=example,dc=com</code><br>
                    <strong>OpenLDAP/FreeIPA:</strong> <code>uid={username},ou=People,dc=example,dc=com</code>
                </small>
            </div>
            <div class="mb-3">
                <label class="form-label">Description</label>
                <input type="text" name="description" class="form-control" value="<cfoutput>#getMapping.description#</cfoutput>">
                <small class="text-muted">Optional description for this mapping</small>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="form-label">Enabled</label>
                        <select name="enabled" class="form-select">
                            <option value="1" <cfif getMapping.enabled EQ 1>selected</cfif>>Yes</option>
                            <option value="0" <cfif getMapping.enabled EQ 0>selected</cfif>>No</option>
                        </select>
                        <small class="text-muted">Enable or disable this domain mapping</small>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="form-label">Sync Status</label>
                        <p class="form-control-plaintext">
                            <cfif getMapping.ldap_synced EQ 1>
                                <span class="badge bg-success"><i class="fas fa-check-circle"></i> Synced to LDAP</span>
                            <cfelse>
                                <span class="badge bg-warning text-dark"><i class="fas fa-exclamation-circle"></i> Pending - Apply changes required</span>
                            </cfif>
                        </p>
                    </div>
                </div>
            </div>
            <div class="alert alert-info mb-0">
                <small><i class="fas fa-info-circle"></i> TLS settings (STARTTLS, certificate verification, CA certificate, retry count) are configured globally on the main RemoteAuth page.</small>
            </div>
        </div>
        <div class="card-footer">
            <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save Changes</button>
            <a href="view_remoteauth.cfm" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h4 class="modal-title"><i class="fas fa-exclamation-triangle"></i> Delete Mapping</h4>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete the domain mapping "<cfoutput><strong>#getMapping.domain_name#</strong></cfoutput>"?</p>
                <p>This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <form method="post" action="">
                    <input type="hidden" name="action" value="delete_mapping">
                    <input type="hidden" name="mapping_id" value="<cfoutput>#getMapping.id#</cfoutput>">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>

</cfif>

</div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</main>

<cfinclude template="./inc/main_footer.cfm" />

</div><!-- ./app-wrapper -->


</body>
</html>
