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


<!--- Default first. cfexecute only creates `variable` when the command
     produces output, so an empty result leaves it undefined and the
     dashboard dies with "variable [ARCHIVEUSAGE] doesn't exist" rather than
     showing a zero ring. Every tier probe shares this shape. --->
<cfset archiveusage = "0">

<cftry>

  <cfexecute name="/opt/hermes/scripts/disk_space_usage_archive.sh"
  variable="archiveusage"
  timeout="10" />


          <cfcatch type="any">
          <!--- Do NOT abort. A disk usage probe is decorative: the script can
               be missing (an older install that predates this tier) or the
               path can be unmounted, and neither is a reason to take the whole
               admin dashboard down with an error page. The default set above
               stands, the ring renders at 0, and every other panel still
               loads. Aborting here is what turned a missing script into a
               dead console. --->
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
