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

<!--- Write SpamAssassin config from database --->
<cfinclude template="update_spamassassin_config_files.cfm">

<!--- Validate SpamAssassin config --->
<!--- Redirect stderr to stdout to prevent Lucee from throwing on stderr warnings --->
<cfinclude template="generate_customtrans.cfm">
<cfset lintScript = "/opt/hermes/tmp/#customtrans3#_sa_lint.sh">
<cfset lintContent = "docker exec hermes_mail_filter /usr/bin/spamassassin --lint 2>/dev/null" & chr(10) & "exit 0">
<cffile action="write" file="#lintScript#" output="#lintContent#">
<cfexecute name="/bin/bash" arguments="#lintScript#" variable="lintOutput" timeout="240" />
<cfif fileExists(lintScript)>
  <cffile action="delete" file="#lintScript#">
</cfif>

<!--- Restart Mail Filter --->
<cfinclude template="restart_mail_filter.cfm">

<!--- Mark all rules as applied --->
<cfquery datasource="hermes">
  UPDATE message_rules SET applied = '1'
</cfquery>
