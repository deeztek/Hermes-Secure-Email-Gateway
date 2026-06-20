
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

<cfinclude template="generate_customtrans.cfm">
<cffile action="write"
    file="/opt/hermes/tmp/#customtrans3#_sa_learn_sync.sh"
    output="docker exec hermes_mail_filter /usr/bin/sa-learn --sync 2>&1">

<cftry>
    <cfexecute name="/bin/chmod" arguments="+x /opt/hermes/tmp/#customtrans3#_sa_learn_sync.sh" timeout="60"></cfexecute>
    <cfexecute name="/opt/hermes/tmp/#customtrans3#_sa_learn_sync.sh" timeout="240" variable="syncResult" arguments=""></cfexecute>
<cfcatch type="any">
    <cfset m="Messages SA Learn Sync: There was an error executing /usr/bin/sa-learn --sync">
    <cfinclude template="error.cfm">
    <cfabort>
</cfcatch>
</cftry>
<cfif fileExists("/opt/hermes/tmp/#customtrans3#_sa_learn_sync.sh")>
  <cffile action="delete" file="/opt/hermes/tmp/#customtrans3#_sa_learn_sync.sh">
</cfif>
