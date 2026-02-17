
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

<!--- Get mynetworks parent parameter ID --->
<cfquery name="get_mynetworks_parent" datasource="hermes">
SELECT id FROM parameters WHERE parameter='mynetworks' AND child = '2'
</cfquery>

<cfset mynetworks_parent_id = get_mynetworks_parent.id>

<!--- Get active relay networks (applied=1, excludes system defaults) --->
<cfquery name="get_active_networks" datasource="hermes">
SELECT id, parameter, note, network_entry
FROM parameters
WHERE parent='#mynetworks_parent_id#'
AND child = '1'
AND enabled='1'
AND applied='1'
AND parameter <> '127.0.0.1'
AND parameter <> '172.16.32.0/24'
ORDER BY order1 ASC
</cfquery>

<!--- Get networks pending addition (action=insert, applied=2) --->
<cfquery name="get_pending_adds" datasource="hermes">
SELECT id, parameter, note, network_entry
FROM parameters
WHERE parent='#mynetworks_parent_id#'
AND child = '1'
AND action='insert'
AND applied='2'
ORDER BY parameter ASC
</cfquery>

<!--- Get networks pending deletion (action=delete, applied=2) --->
<cfquery name="get_pending_deletes" datasource="hermes">
SELECT id, parameter, note, network_entry
FROM parameters
WHERE parent='#mynetworks_parent_id#'
AND child = '1'
AND action='delete'
AND applied='2'
ORDER BY parameter ASC
</cfquery>

<!--- Check if there are pending changes that need to be applied --->
<cfquery name="get_pending_changes" datasource="hermes">
SELECT COUNT(*) as cnt
FROM parameters
WHERE parent='#mynetworks_parent_id#'
AND applied='2'
</cfquery>

<cfset has_pending_changes = get_pending_changes.cnt GT 0>

<!--- Get subnet list for dropdown --->
<cfquery name="get_subnets" datasource="hermes">
SELECT mask, value3 FROM subnet ORDER BY value2 ASC
</cfquery>
