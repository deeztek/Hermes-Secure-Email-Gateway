
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

<!--- AJAX endpoint for system resources - returns JSON --->
<cfcontent type="application/json">
<cfheader name="Cache-Control" value="no-cache, no-store, must-revalidate">

<cftry>

<!--- Initialize response structure --->
<cfset response = {
    "success": true,
    "cpu": 0,
    "cpuColor": "20c997",
    "mem": 0,
    "memColor": "20c997",
    "rootUsage": 0,
    "rootUsageColor": "20c997",
    "dataUsage": 0,
    "dataUsageColor": "20c997",
    "archiveUsage": 0,
    "archiveUsageColor": "20c997",
    "vmailUsage": 0,
    "vmailUsageColor": "20c997",
    "nextcloudUsage": 0,
    "nextcloudUsageColor": "20c997"
}>

<!--- GET CPU USAGE --->
<cftry>
    <cfexecute name="/opt/hermes/scripts/getcpu.sh" variable="cpuResult" timeout="15" />
    <cfset cpu = reReplace(cpuResult, "%", "", "all")>
    <cfset cpu = trim(cpu)>
    <cfif isNumeric(cpu)>
        <cfset response.cpu = int(cpu)>
    </cfif>
    <cfcatch type="any">
        <cfset response.cpu = 0>
    </cfcatch>
</cftry>

<!--- Set CPU color based on value --->
<cfif response.cpu GTE 0 AND response.cpu LTE 19>
    <cfset response.cpuColor = "20c997">
<cfelseif response.cpu GTE 20 AND response.cpu LTE 49>
    <cfset response.cpuColor = "ffc107">
<cfelseif response.cpu GTE 50 AND response.cpu LTE 79>
    <cfset response.cpuColor = "fd7e14">
<cfelseif response.cpu GTE 80 AND response.cpu LTE 100>
    <cfset response.cpuColor = "e74c3c">
<cfelse>
    <cfset response.cpuColor = "e74c3c">
</cfif>

<!--- GET MEMORY USAGE --->
<cftry>
    <cfexecute name="/opt/hermes/scripts/getmem.sh" variable="memResult" timeout="10" />
    <cfset mem = trim(memResult)>
    <cfif isNumeric(mem)>
        <cfset response.mem = numberFormat(mem, "____._")>
    </cfif>
    <cfcatch type="any">
        <cfset response.mem = 0>
    </cfcatch>
</cftry>

<!--- Set memory color based on value --->
<cfif response.mem GTE 0 AND response.mem LTE 59>
    <cfset response.memColor = "20c997">
<cfelseif response.mem GTE 60 AND response.mem LTE 79>
    <cfset response.memColor = "ffc107">
<cfelseif response.mem GTE 80 AND response.mem LTE 89>
    <cfset response.memColor = "fd7e14">
<cfelseif response.mem GTE 90 AND response.mem LTE 100>
    <cfset response.memColor = "e74c3c">
<cfelse>
    <cfset response.memColor = "e74c3c">
</cfif>

<!--- GET ROOT FILESYSTEM USAGE --->
<cftry>
    <cfexecute name="/opt/hermes/scripts/disk_space_usage_root.sh" variable="rootResult" timeout="10" />
    <cfset rootUsage = reReplace(rootResult, "Use%", "", "all")>
    <cfset rootUsage = reReplace(rootUsage, "%", "", "all")>
    <cfset rootUsage = trim(rootUsage)>
    <cfif isNumeric(rootUsage)>
        <cfset response.rootUsage = int(rootUsage)>
    </cfif>
    <cfcatch type="any">
        <cfset response.rootUsage = 0>
    </cfcatch>
</cftry>

<!--- Set root filesystem color based on value --->
<cfif response.rootUsage GTE 0 AND response.rootUsage LTE 59>
    <cfset response.rootUsageColor = "20c997">
<cfelseif response.rootUsage GTE 60 AND response.rootUsage LTE 79>
    <cfset response.rootUsageColor = "ffc107">
<cfelseif response.rootUsage GTE 80 AND response.rootUsage LTE 89>
    <cfset response.rootUsageColor = "fd7e14">
<cfelseif response.rootUsage GTE 90 AND response.rootUsage LTE 100>
    <cfset response.rootUsageColor = "e74c3c">
<cfelse>
    <cfset response.rootUsageColor = "e74c3c">
</cfif>

<!--- GET DATA FILESYSTEM USAGE --->
<cftry>
    <cfexecute name="/opt/hermes/scripts/disk_space_usage_data.sh" variable="dataResult" timeout="10" />
    <cfset dataUsage = reReplace(dataResult, "Use%", "", "all")>
    <cfset dataUsage = reReplace(dataUsage, "%", "", "all")>
    <cfset dataUsage = trim(dataUsage)>
    <cfif isNumeric(dataUsage)>
        <cfset response.dataUsage = int(dataUsage)>
    </cfif>
    <cfcatch type="any">
        <cfset response.dataUsage = 0>
    </cfcatch>
</cftry>

<!--- Set data filesystem color based on value --->
<cfif response.dataUsage GTE 0 AND response.dataUsage LTE 59>
    <cfset response.dataUsageColor = "20c997">
<cfelseif response.dataUsage GTE 60 AND response.dataUsage LTE 79>
    <cfset response.dataUsageColor = "ffc107">
<cfelseif response.dataUsage GTE 80 AND response.dataUsage LTE 89>
    <cfset response.dataUsageColor = "fd7e14">
<cfelseif response.dataUsage GTE 90 AND response.dataUsage LTE 100>
    <cfset response.dataUsageColor = "e74c3c">
<cfelse>
    <cfset response.dataUsageColor = "e74c3c">
</cfif>

<!--- GET ARCHIVE FILESYSTEM USAGE -- #260 (Amavis quarantine tier) --->
<cftry>
    <cfexecute name="/opt/hermes/scripts/disk_space_usage_archive.sh" variable="archiveResult" timeout="10" />
    <cfset archiveUsage = reReplace(archiveResult, "Use%", "", "all")>
    <cfset archiveUsage = reReplace(archiveUsage, "%", "", "all")>
    <cfset archiveUsage = trim(archiveUsage)>
    <cfif isNumeric(archiveUsage)>
        <cfset response.archiveUsage = int(archiveUsage)>
    </cfif>
    <cfcatch type="any">
        <cfset response.archiveUsage = 0>
    </cfcatch>
</cftry>

<!--- Set archive filesystem color based on value --->
<cfif response.archiveUsage GTE 0 AND response.archiveUsage LTE 59>
    <cfset response.archiveUsageColor = "20c997">
<cfelseif response.archiveUsage GTE 60 AND response.archiveUsage LTE 79>
    <cfset response.archiveUsageColor = "ffc107">
<cfelseif response.archiveUsage GTE 80 AND response.archiveUsage LTE 89>
    <cfset response.archiveUsageColor = "fd7e14">
<cfelseif response.archiveUsage GTE 90 AND response.archiveUsage LTE 100>
    <cfset response.archiveUsageColor = "e74c3c">
<cfelse>
    <cfset response.archiveUsageColor = "e74c3c">
</cfif>

<!--- GET VMAIL FILESYSTEM USAGE --->
<cftry>
    <cfexecute name="/opt/hermes/scripts/disk_space_usage_vmail.sh" variable="vmailResult" timeout="10" />
    <cfset vmailUsage = reReplace(vmailResult, "Use%", "", "all")>
    <cfset vmailUsage = reReplace(vmailUsage, "%", "", "all")>
    <cfset vmailUsage = reReplace(vmailUsage, "[\r\n]", "", "all")>
    <cfset vmailUsage = trim(vmailUsage)>
    <cfif isNumeric(vmailUsage)>
        <cfset response.vmailUsage = int(vmailUsage)>
    <cfelse>
        <cfset response.vmailUsage = 0>
    </cfif>
    <cfcatch type="any">
        <cfset response.vmailUsage = 0>
    </cfcatch>
</cftry>

<!--- Set vmail filesystem color based on value --->
<cfif response.vmailUsage GTE 0 AND response.vmailUsage LTE 59>
    <cfset response.vmailUsageColor = "20c997">
<cfelseif response.vmailUsage GTE 60 AND response.vmailUsage LTE 79>
    <cfset response.vmailUsageColor = "ffc107">
<cfelseif response.vmailUsage GTE 80 AND response.vmailUsage LTE 89>
    <cfset response.vmailUsageColor = "fd7e14">
<cfelseif response.vmailUsage GTE 90 AND response.vmailUsage LTE 100>
    <cfset response.vmailUsageColor = "e74c3c">
<cfelse>
    <cfset response.vmailUsageColor = "e74c3c">
</cfif>

<!--- GET NEXTCLOUD FILESYSTEM USAGE --->
<cftry>
    <cfexecute name="/opt/hermes/scripts/disk_space_usage_nextcloud.sh" variable="nextcloudResult" timeout="10" />
    <cfset nextcloudUsage = reReplace(nextcloudResult, "Use%", "", "all")>
    <cfset nextcloudUsage = reReplace(nextcloudUsage, "%", "", "all")>
    <cfset nextcloudUsage = reReplace(nextcloudUsage, "[\r\n]", "", "all")>
    <cfset nextcloudUsage = trim(nextcloudUsage)>
    <cfif isNumeric(nextcloudUsage)>
        <cfset response.nextcloudUsage = int(nextcloudUsage)>
    <cfelse>
        <cfset response.nextcloudUsage = 0>
    </cfif>
    <cfcatch type="any">
        <cfset response.nextcloudUsage = 0>
    </cfcatch>
</cftry>

<!--- Set nextcloud filesystem color based on value --->
<cfif response.nextcloudUsage GTE 0 AND response.nextcloudUsage LTE 59>
    <cfset response.nextcloudUsageColor = "20c997">
<cfelseif response.nextcloudUsage GTE 60 AND response.nextcloudUsage LTE 79>
    <cfset response.nextcloudUsageColor = "ffc107">
<cfelseif response.nextcloudUsage GTE 80 AND response.nextcloudUsage LTE 89>
    <cfset response.nextcloudUsageColor = "fd7e14">
<cfelseif response.nextcloudUsage GTE 90 AND response.nextcloudUsage LTE 100>
    <cfset response.nextcloudUsageColor = "e74c3c">
<cfelse>
    <cfset response.nextcloudUsageColor = "e74c3c">
</cfif>

<cfcatch type="any">
    <cfset response = {
        "success": false,
        "error": cfcatch.message
    }>
</cfcatch>
</cftry>

<cfoutput>#serializeJSON(response)#</cfoutput>
