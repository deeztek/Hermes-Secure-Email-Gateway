
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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

<!--- Get relay host parent parameter (includes enabled status) --->
<cfquery name="get_relayhost_parent" datasource="hermes">
SELECT id, enabled FROM parameters WHERE parameter='relayhost' AND child = '2'
</cfquery>

<!--- Get relay host child parameter (contains hostname and port) --->
<cfquery name="get_relayhost" datasource="hermes">
SELECT name, parameter FROM parameters WHERE parent='#get_relayhost_parent.id#' AND child = '1'
</cfquery>

<!--- Determine if relay host is enabled (check parent enabled status) --->
<cfif get_relayhost_parent.enabled is "1" AND get_relayhost.parameter is not "">
    <cfset relayhost_enabled = 1>
<cfelse>
    <cfset relayhost_enabled = 0>
</cfif>

<!--- Get relay host hostname --->
<cfset relayhost_hostname = get_relayhost.name>

<!--- Get relay host port (extract from parameter like [hostname]:port) --->
<cfif get_relayhost.name is not "" AND get_relayhost.parameter is not "">
    <cfset relayhost_port = trim(ListGetAt(get_relayhost.parameter, 2, ":"))>
<cfelse>
    <cfset relayhost_port = 25>
</cfif>

<!--- Get smtp_sasl_auth_enable parent parameter (includes enabled status) --->
<cfquery name="get_smtp_sasl_auth_enable" datasource="hermes">
SELECT id, enabled FROM parameters WHERE parameter='smtp_sasl_auth_enable' AND child = '2'
</cfquery>

<!--- Get smtp_sasl_auth_enable value --->
<cfquery name="get_smtp_sasl_auth_enable_parameter" datasource="hermes">
SELECT parameter FROM parameters WHERE parent='#get_smtp_sasl_auth_enable.id#' AND child = '1'
</cfquery>

<!--- Determine if authentication is required (check parent enabled AND value is yes) --->
<cfif get_smtp_sasl_auth_enable.enabled is "1" AND get_smtp_sasl_auth_enable_parameter.parameter is "yes">
    <cfset relayhost_authenticate = 1>
<cfelse>
    <cfset relayhost_authenticate = 0>
</cfif>

<!--- Get relay host username and password --->
<cfquery name="get_relayhost_username_password" datasource="hermes">
SELECT name FROM parameters WHERE parameter='smtp_sasl_password_maps' AND child = '2'
</cfquery>

<cfif get_relayhost_username_password.name is not "">
    <cfset relayhost_username = listGetAt(get_relayhost_username_password.name, 1, ":")>
    <cfset relayhost_password = listGetAt(get_relayhost_username_password.name, 2, ":")>
<cfelse>
    <cfset relayhost_username = "">
    <cfset relayhost_password = "">
</cfif>

<!--- Get smtp_tls_security_level for outbound relay TLS --->
<cfquery name="get_smtp_tls_security_level" datasource="hermes">
SELECT id, enabled FROM parameters WHERE parameter='smtp_tls_security_level' AND child = '2'
</cfquery>

<!--- Get the TLS level value --->
<cfif get_smtp_tls_security_level.recordcount GT 0>
    <cfquery name="get_smtp_tls_security_level_value" datasource="hermes">
    SELECT parameter FROM parameters WHERE parent_name='smtp_tls_security_level' AND child = '1'
    </cfquery>

    <cfif get_smtp_tls_security_level.enabled is "1" AND get_smtp_tls_security_level_value.recordcount GT 0>
        <cfset relayhost_tls_mode = get_smtp_tls_security_level_value.parameter>
    <cfelse>
        <cfset relayhost_tls_mode = "">
    </cfif>
<cfelse>
    <!--- Parameter doesn't exist yet, default to empty (disabled) --->
    <cfset relayhost_tls_mode = "">
</cfif>
