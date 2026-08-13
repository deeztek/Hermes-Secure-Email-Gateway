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

<!--- GET NEXTCLOUD FILESYSTEM USAGE --->

<!--- Default first. cfexecute only creates `variable` when the command
     produces output, so an empty result leaves it undefined and the
     dashboard dies with "variable [NEXTCLOUDUSAGE] doesn't exist" rather than
     showing a zero ring. Every tier probe shares this shape. --->
<cfset nextcloudusage = "0">

<cftry>

  <cfexecute name="/opt/hermes/scripts/disk_space_usage_nextcloud.sh"
  variable="nextcloudusage"
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


<cfset nextcloudusage = reReplace( nextcloudusage, "Use%", "", "all" )>
<cfset nextcloudusage = reReplace( nextcloudusage, "%", "", "all" )>
<cfset nextcloudusage = reReplace( nextcloudusage, "[\r\n]\s*([\r\n]|\Z)", "#chr(13)##chr(10)#", "all" )>
<cfset nextcloudusage=#TRIM(nextcloudusage)#>


<cfif #nextcloudusage# GTE "0" and #nextcloudusage# LTE "59">

  <cfset nextcloudusagecolor = "20c997">

  <cfelseif #nextcloudusage# GTE "60" and #nextcloudusage# LTE "79">

  <cfset nextcloudusagecolor = "ffc107">

  <cfelseif #nextcloudusage# GTE "80" and #nextcloudusage# LTE "89">

  <cfset nextcloudusagecolor = "fd7e14">

  <cfelseif #nextcloudusage# GTE "90" and #nextcloudusage# LTE "100">

  <cfset nextcloudusagecolor = "e74c3c">

  <cfelse>

  <cfset nextcloudusagecolor = "e74c3c">

  <!--- /CFIF #nextcloudusage# is --->
  </cfif>
