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

<!--- GET ARCHIVE TIER (Amavis quarantine) USAGE -- #260 --->


<cftry>

  <cfexecute name="/opt/hermes/scripts/disk_space_usage_archive.sh"
  variable="archiveusage"
  timeout="10" />


          <cfcatch type="any">

          <cfset m="/inc/get_system_archive_filesystem_usage: There was an error executing /opt/hermes/scripts/disk_space_usage_archive.sh">
          <cfinclude template="error.cfm">
          <cfabort>

          </cfcatch>
          </cftry>


<cfset archiveusage = reReplace( archiveusage, "Use%", "", "all" )>
<cfset archiveusage = reReplace( archiveusage, "%", "", "all" )>
<cfset archiveusage = reReplace( archiveusage, "[\r\n]\s*([\r\n]|\Z)", "#chr(13)##chr(10)#", "all" )>
<cfset archiveusage=#TRIM(archiveusage)#>


<cfif #archiveusage# GTE "0" and #archiveusage# LTE "59">

  <cfset archiveusagecolor = "20c997">

  <cfelseif #archiveusage# GTE "60" and #archiveusage# LTE "79">

  <cfset archiveusagecolor = "ffc107">

  <cfelseif #archiveusage# GTE "80" and #archiveusage# LTE "89">

  <cfset archiveusagecolor = "fd7e14">

  <cfelseif #archiveusage# GTE "90" and #archiveusage# LTE "100">

  <cfset archiveusagecolor = "e74c3c">

  <cfelse>

  <cfset archiveusagecolor = "e74c3c">

  <!--- /CFIF #archiveusage# is --->
  </cfif>
