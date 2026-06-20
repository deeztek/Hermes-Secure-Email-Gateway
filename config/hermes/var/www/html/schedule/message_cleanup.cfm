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

<!--- #276 no-login Pro lapse enforcement. message_cleanup runs @daily on EVERY
     edition and its core job (disk-full protection) makes it a task an operator
     cannot safely disable. The mis-keyed inline copies of the retention/license
     functions that used to live at the bottom of this file were DEAD code (a
     stale fork of schedule/retention_policy_functions.cfm, never called by the
     body) and were removed in this change. We now include the CANONICAL
     functions and, when the cached license is not valid, tear down the
     body-milter Pro features (disclaimers, org sigs, Link Guard) so an
     unattended box stops running them with no console traffic. Idempotent; this
     file is fingerprinted (pro_templates.json) so removing the hook trips tamper
     detection. Login-time counterpart is in setsession.cfm. --->
<cfinclude template="retention_policy_functions.cfm">
<cfif NOT isRetentionEnabled()>
    <cfinclude template="/admin/2/inc/pro_milter_enforce.cfm">
</cfif>

<cfexecute name="/opt/hermes/scripts/disk_space_alert.sh"
variable="diskspace"
timeout="10" />

<cfset diskspace2=TRIM(#REReplace("#diskspace#","%","","ALL")#)>

<cfif #diskspace2# GTE 90>

<cfquery name="getoldest" datasource="hermes">
SELECT min(time_iso) as oldest FROM msgs
</cfquery>

<cfset oldest=#DateFormat(getoldest.oldest, "yyyy-mm-dd")#>

<cfset future=#DateFormat(DateAdd('d', 30, oldest),'yyyy-mm-dd')#>

<cfoutput>Oldest: #oldest# - 30 Days Future: #future#<br></cfoutput>

<cfquery name="getmsgs" datasource="hermes">
select mail_id, quar_loc from msgs where time_iso < '#future#'
</cfquery>

<cfoutput query="getmsgs">
Mail id: #mail_id# --- #quar_loc#<br>
</cfoutput>


<cfloop query="getmsgs">
<cfoutput>
<cfquery name="clearmsgrcpt" datasource="hermes">
delete from msgrcpt where mail_id = '#mail_id#'
</cfquery>
</cfoutput>
</cfloop>

<cfquery name="deletemsgs" datasource="hermes">
delete from msgs where time_iso < '#future#'
</cfquery>


<cfinclude template="../admin/2/inc/generate_customtrans.cfm">


<cffile action="read" file="/opt/hermes/scripts/amavis_delete_files.sh" variable="amavis">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#amavis_delete_files.sh"
    output = "#REReplace("#amavis#","THE-DATE","#future#","ALL")#">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#amavis_delete_files.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#amavis_delete_files.sh"
outputfile ="/dev/null"
timeout = "300">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#amavis_delete_files.sh">


</cfif>

<cfquery name="getlogretention" datasource="hermes">
select parameter, value2, module from parameters2 where parameter = 'system_log_retention' limit 1
</cfquery>

<cfset TheLogRetention=#getlogretention.value2#>

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset datepast=#DateFormat(DateAdd('d', -#TheLogRetention#, datenow),'yyyy-mm-dd')#>
<cfoutput>Date Now: #datenow#</cfoutput><br>

<!---
<cfquery name="syslog" datasource="syslog">
select min(ReceivedAt) as SysOldest from SystemEvents
</cfquery>


<cfif #syslog.SysOldest# is "">
<cfset sysoldest="#datenow#">
<cfelse>
<cfset sysoldest=#DateFormat(syslog.SysOldest, "yyyy-mm-dd")#>
</cfif>

<cfoutput>Syslog Oldest: #sysoldest#</cfoutput><br>
--->


<cfoutput>Syslog #TheLogRetention#: #datepast#</cfoutput><br>
<cfif #datepast# is not "">
<cfquery name="deleteoldlogs" datasource="syslog">
delete from SystemEvents where ReceivedAt < '#datepast#'
</cfquery>
</cfif>

<!--- Send Telemetry If Enabled --->
<cfinclude template="/admin/2/inc/send_telemetry.cfm">
