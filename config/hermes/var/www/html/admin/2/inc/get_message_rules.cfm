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

<!--- All message rules --->
<cfquery name="get_message_rules" datasource="hermes">
  SELECT id, rule_name, rule_type, rule_desc, header, regex, score, applied
  FROM message_rules
  ORDER BY rule_name ASC
</cfquery>

<!--- Pending changes (applied = 2) --->
<cfquery name="get_pending_rules" datasource="hermes">
  SELECT id, rule_name, rule_type, rule_desc, header, regex, score, applied
  FROM message_rules
  WHERE applied = <cfqueryparam value="2" cfsqltype="cf_sql_varchar">
  ORDER BY rule_name ASC
</cfquery>

<!--- Check for any pending changes --->
<cfset has_pending_rule_changes = get_pending_rules.recordCount GT 0>
