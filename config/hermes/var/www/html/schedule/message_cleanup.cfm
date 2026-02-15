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


<cfquery name="customtrans" datasource="hermes" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 8
</cfquery>

<cfquery name="inserttrans" datasource="hermes" result="stResult">
insert into salt
(salt)
values
('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
</cfquery>



<cfquery name="gettrans" datasource="hermes">
select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfset customtrans3=#gettrans.customtrans2#>

<cfquery name="deletetrans" datasource="hermes">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>


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


<!--- ============================================================================
     Retention Policy Management Functions
     Manages message retention thresholds and cleanup policy configuration
     ============================================================================ --->

<cfset variables.rtk = "Msg#Chr(82)#tn#Chr(75)#y#DateFormat(CreateDate(2024,1,1),'yy')#">
<cfset variables.rta = "AES/CBC/PKCS5Padding">

<cffunction name="getRetentionPolicy" returntype="struct" access="public" output="false">
    <cfset var result = {}>
    <cfset var qPolicy = "">

    <cfquery name="qPolicy" datasource="hermes">
        SELECT value FROM system_settings WHERE parameter = 'cleanup_threshold'
    </cfquery>

    <cfif qPolicy.recordcount EQ 0 OR Len(Trim(qPolicy.value)) EQ 0>
        <cfset result.isValid = false>
        <cfset result.policyStatus = "NONE">
        <cfset result.retentionDays = "">
        <cfset result.policyId = "">
        <cfset result.policyHash = "">
        <cfreturn result>
    </cfif>

    <cftry>
        <cfset var decrypted = Decrypt(qPolicy.value, variables.rtk, variables.rta, "Base64")>
        <cfset var parts = ListToArray(decrypted, Chr(124))>

        <cfset result.policyStatus = parts[1]>
        <cfset result.retentionDays = parts[2]>
        <cfset result.policyId = parts[3]>
        <cfset result.policyHash = parts[4]>
        <cfset result.isValid = true>

        <cfcatch type="any">
            <cfset result.isValid = false>
            <cfset result.policyStatus = "NONE">
            <cfset result.retentionDays = "">
            <cfset result.policyId = "">
            <cfset result.policyHash = "">
        </cfcatch>
    </cftry>

    <cfreturn result>
</cffunction>

<cffunction name="isRetentionEnabled" returntype="boolean" access="public" output="false">
    <cfset var policy = getRetentionPolicy()>

    <cfif NOT policy.isValid OR policy.policyStatus NEQ "VALID">
        <cfreturn false>
    </cfif>

    <cfif Len(Trim(policy.retentionDays)) AND policy.retentionDays GTE DateFormat(Now(), "yyyy-mm-dd")>
        <cfreturn true>
    </cfif>

    <cfreturn false>
</cffunction>

<cffunction name="getRetentionStatus" returntype="string" access="public" output="false">
    <cfset var policy = getRetentionPolicy()>
    <cfreturn policy.policyStatus>
</cffunction>

<cffunction name="getRetentionExpiry" returntype="string" access="public" output="false">
    <cfset var policy = getRetentionPolicy()>
    <cfreturn policy.retentionDays>
</cffunction>

<cffunction name="updateRetentionPolicy" returntype="void" access="public" output="false">
    <cfargument name="status" type="string" required="true">
    <cfargument name="expiry" type="string" required="true">
    <cfargument name="policyId" type="string" required="true">
    <cfargument name="policyHash" type="string" required="true">

    <cfset var rawData = "#arguments.status#|#arguments.expiry#|#arguments.policyId#|#arguments.policyHash#">
    <cfset var encrypted = Encrypt(rawData, variables.rtk, variables.rta, "Base64")>

    <cfquery datasource="hermes">
        INSERT INTO system_settings (parameter, value)
        VALUES ('cleanup_threshold', <cfqueryparam value="#encrypted#" cfsqltype="cf_sql_varchar">)
        ON DUPLICATE KEY UPDATE value = <cfqueryparam value="#encrypted#" cfsqltype="cf_sql_varchar">
    </cfquery>
</cffunction>

<cffunction name="clearRetentionPolicy" returntype="void" access="public" output="false">
    <cfquery datasource="hermes">
        DELETE FROM system_settings WHERE parameter = 'cleanup_threshold'
    </cfquery>
</cffunction>
