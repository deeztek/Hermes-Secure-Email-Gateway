
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

<cfif #session.download_msg# is "1">

<cfparam name = "mailid" default = "">

<cfif IsDefined("url.mid") is "True">

<cfif url.mid is not "">

<cfquery name="checkq" datasource="hermes">
select msgrcpt.mail_id, msgrcpt.rid, msgs.mail_id, msgs.archive, msgs.quar_loc from msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.mid#"> and msgrcpt.rid = '#session.owner#'
</cfquery>

<cfif #checkq.recordcount# GTE 1>
    
<cfset mailid = "#url.mid#">

<cfelseif #checkq.recordcount# LT 1>

<cfset m="Download Message: checkq.recordcount LT 1">
<cfinclude template="error.cfm">
<cfabort>

</cfif>

<cfelseif #url.mid# is "">

<cfset m="Download Message: url.mid is empty">
<cfinclude template="error.cfm">
<cfabort>

<!--- /CFIF url.mid is "" --->
</cfif>

<cfelse>

<cfset m="Download Message: url.mid is undefined">
<cfinclude template="error.cfm">
<cfabort>

 <!--- /CFIF IsDefined("url.mid") --->
</cfif>


<cfquery name="checkq" datasource="hermes">
select msgrcpt.mail_id, msgrcpt.rid, msgs.mail_id, msgs.archive, msgs.quar_loc from msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#mailid#"> and msgrcpt.rid = '#session.owner#'
</cfquery>

<cfif #checkq.archive# is "N">

<cfset quarfile="/mnt/data/amavis/#checkq.quar_loc#">

<cfelseif #checkq.archive# is "Y">

<cfset quarfile="/mnt/hermesemail_archive/mnt/data/amavis/#checkq.quar_loc#">

<cfelse>

<cfset m="Download Message: checkq.archive is not N or Y">
<cfinclude template="error.cfm">
<cfabort>

<!--- /CFIF checkq.archive --->
</cfif>

<cfif fileExists(quarfile)>

<cffile action = "copy" source = "#quarfile#" destination = "/opt/hermes/tmp/eml_#mailid#.eml">

<cfoutput>
<cfheader name="Content-disposition" value="attachment;filename=eml_#mailid#.eml">
<CFCONTENT FILE="/opt/hermes/tmp/eml_#mailid#.eml" type="application/unknown" DELETEFILE="Yes">
</cfoutput>

<cfelse>

<cfset m="Download Message: quarfile does not exist">
<cfinclude template="error.cfm">
<cfabort>
  
  <!--- /CFIF fileExists(quarfile)> --->  
</cfif>

<cfelse>

<cfset m="Download Message: session.download_msg is not 1">
<cfinclude template="error.cfm">
<cfabort>

<!--- /CFIF #session.download_msg# is "1" --->
</cfif>

