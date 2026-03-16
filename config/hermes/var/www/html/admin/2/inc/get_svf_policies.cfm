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

<!--- SVF Policies Data Include
     Queries the spam_policies and policy tables for SVF policy data.
--->

<!--- All policies with settings joined --->
<cfquery name="get_all_policies" datasource="hermes">
  SELECT sp.policy_id, sp.policy_name, sp.system, sp.custom, sp.default_policy,
         p.virus_lover, p.spam_lover, p.banned_files_lover, p.bad_header_lover,
         p.bypass_virus_checks, p.bypass_spam_checks, p.bypass_banned_checks, p.bypass_header_checks,
         p.spam_tag_level, p.spam_tag2_level, p.spam_kill_level,
         p.banned_rulenames,
         p.warnbannedrecip, p.warnvirusrecip, p.warnbadhrecip
  FROM spam_policies sp
  INNER JOIN policy p ON sp.policy_id = p.id
  ORDER BY sp.system DESC, sp.policy_name ASC
</cfquery>

<!--- System policies only --->
<cfquery name="get_system_policies" datasource="hermes">
  SELECT sp.policy_id, sp.policy_name, sp.system, sp.custom, sp.default_policy,
         p.virus_lover, p.spam_lover, p.banned_files_lover, p.bad_header_lover,
         p.bypass_virus_checks, p.bypass_spam_checks, p.bypass_banned_checks, p.bypass_header_checks,
         p.spam_tag_level, p.spam_tag2_level, p.spam_kill_level,
         p.banned_rulenames,
         p.warnbannedrecip, p.warnvirusrecip, p.warnbadhrecip
  FROM spam_policies sp
  INNER JOIN policy p ON sp.policy_id = p.id
  WHERE sp.system = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
  ORDER BY sp.policy_name ASC
</cfquery>

<!--- Custom policies only --->
<cfquery name="get_custom_policies" datasource="hermes">
  SELECT sp.policy_id, sp.policy_name, sp.system, sp.custom, sp.default_policy,
         p.virus_lover, p.spam_lover, p.banned_files_lover, p.bad_header_lover,
         p.bypass_virus_checks, p.bypass_spam_checks, p.bypass_banned_checks, p.bypass_header_checks,
         p.spam_tag_level, p.spam_tag2_level, p.spam_kill_level,
         p.banned_rulenames,
         p.warnbannedrecip, p.warnvirusrecip, p.warnbadhrecip
  FROM spam_policies sp
  INNER JOIN policy p ON sp.policy_id = p.id
  WHERE sp.custom = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
    AND sp.system <> <cfqueryparam value="1" cfsqltype="cf_sql_varchar">
  ORDER BY sp.policy_name ASC
</cfquery>

<!--- Available file rules for dropdown --->
<cfquery name="get_file_rules" datasource="hermes">
  SELECT DISTINCT rule_name
  FROM file_rule_components
  ORDER BY rule_name ASC
</cfquery>
