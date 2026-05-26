<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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

<!--- Read ARC global settings from system_settings. Schema rows created in
      updates/v260119/sql/schema_updates.sql (#229). --->

<cfquery name="get_arc_signing_enabled" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'arc_signing_enabled'
</cfquery>

<cfquery name="get_arc_authserv_id" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'arc_authserv_id'
</cfquery>

<cfquery name="get_arc_mode" datasource="hermes">
    SELECT value FROM system_settings WHERE parameter = 'arc_mode'
</cfquery>

<!--- Fall back to the Postfix myhostname value if authserv_id is empty.
     The hostname lives in the `parameters` table, not system_settings:
       parent_name='myhostname' + child=1 + module='postfix' + conf_file='main.cf'
     ...with the actual hostname value stored in the `parameter` column
     (the `parameter` column does double duty -- it's the directive *name*
     when child=2 and the directive's *value* when child=1). See
     inc/save_server_identity.cfm for the writer side of this pattern. --->
<cfquery name="get_host_name" datasource="hermes">
    SELECT parameter AS value
    FROM parameters
    WHERE parent_name = 'myhostname'
      AND child = '1'
      AND module = 'postfix'
      AND conf_file = 'main.cf'
</cfquery>

<cfparam name="arc_signing_enabled" default="#get_arc_signing_enabled.value#">
<cfif IsDefined("form.arc_signing_enabled") AND form.arc_signing_enabled IS NOT "">
    <cfset arc_signing_enabled = form.arc_signing_enabled>
</cfif>

<cfparam name="arc_authserv_id" default="#get_arc_authserv_id.value#">
<cfif IsDefined("form.arc_authserv_id") AND form.arc_authserv_id IS NOT "">
    <cfset arc_authserv_id = form.arc_authserv_id>
</cfif>
<!--- Empty AuthservID falls back to host_name. --->
<cfif arc_authserv_id IS "">
    <cfset arc_authserv_id_effective = get_host_name.value>
<cfelse>
    <cfset arc_authserv_id_effective = arc_authserv_id>
</cfif>

<cfparam name="arc_mode" default="#get_arc_mode.value#">
<cfif IsDefined("form.arc_mode") AND form.arc_mode IS NOT "">
    <cfset arc_mode = form.arc_mode>
</cfif>
