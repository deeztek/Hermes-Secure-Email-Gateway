<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

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


<cfquery name="getemail" datasource="#datasource#">

select msgrcpt.mail_id, msgrcpt.rid, msgs.mail_id as mail_id, msgs.archive, msgs.secret_id as secret_id from msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.mid#">  and msgrcpt.rid = '#session.owner#'

</cfquery>


<cfif #getemail.recordcount# GTE 1>

<cfinclude template="./inc/messages_release_message.cfm" />

<cfoutput>
  <cflocation url="preloader_view_message_history.cfm" addtoken="no">
  </cfoutput>

<cfelse>

  <cfset m="Release Message: getemail.recordcount LT 1">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF getmsgs.recordcount --->
</cfif>



