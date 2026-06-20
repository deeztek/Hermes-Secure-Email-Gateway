
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

<cfinclude template="generate_customtrans.cfm">

<!--- EDIT RECIPIENTS STARTS HERE.
     enforce_mfa is the admin policy bit only — no LDAP cascade fires here.
     The user must click Enable in their Account Settings (user_settings.cfm)
     to actually move into cn=two_factor. Same pattern as the mailbox flow
     (Phase 1.5) so the two pages share one mental model. (#225 Phase 2) --->
<cfquery name="editrecipients" datasource="hermes">
    UPDATE recipients
    SET policy_id    = <cfqueryparam value="#form.policy#"      cfsqltype="cf_sql_integer">,
        enforce_mfa  = <cfqueryparam value="#form.enforce_mfa#" cfsqltype="cf_sql_tinyint">
    WHERE recipient  = <cfqueryparam value="#recipient#"        cfsqltype="cf_sql_varchar">
</cfquery>
<!--- EDIT RECIPIENT ENDS HERE --->

<!--- EDIT USER_SETTINGS STARTS HERE --->
<cfquery name="editusersettings" datasource="hermes">
    UPDATE user_settings
    SET report_enabled = <cfqueryparam value="#form.reports#"      cfsqltype="cf_sql_varchar">,
        train_bayes    = <cfqueryparam value="#form.train_bayes#"  cfsqltype="cf_sql_tinyint">,
        download_msg   = <cfqueryparam value="#form.download_msg#" cfsqltype="cf_sql_tinyint">
    WHERE email        = <cfqueryparam value="#recipient#"         cfsqltype="cf_sql_varchar">
</cfquery>
<!--- EDIT USER_SETTINGS ENDS HERE --->
