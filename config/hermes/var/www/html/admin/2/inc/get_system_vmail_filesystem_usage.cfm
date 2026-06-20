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

<!--- GET VMAIL FILESYSTEM USAGE --->

<cftry>

  <cfexecute name="/opt/hermes/scripts/disk_space_usage_vmail.sh"
  variable="vmailusage"
  timeout="10" />


          <cfcatch type="any">

          <cfset m="/inc/get_system_vmail_filesystem_usage: There was an error executing /opt/hermes/scripts/disk_space_usage_vmail.sh">
          <cfinclude template="error.cfm">
          <cfabort>

          </cfcatch>
          </cftry>


<cfset vmailusage = reReplace( vmailusage, "Use%", "", "all" )>
<cfset vmailusage = reReplace( vmailusage, "%", "", "all" )>
<cfset vmailusage = reReplace( vmailusage, "[\r\n]\s*([\r\n]|\Z)", "#chr(13)##chr(10)#", "all" )>
<cfset vmailusage=#TRIM(vmailusage)#>


<cfif #vmailusage# GTE "0" and #vmailusage# LTE "59">

  <cfset vmailusagecolor = "20c997">

  <cfelseif #vmailusage# GTE "60" and #vmailusage# LTE "79">

  <cfset vmailusagecolor = "ffc107">

  <cfelseif #vmailusage# GTE "80" and #vmailusage# LTE "89">

  <cfset vmailusagecolor = "fd7e14">

  <cfelseif #vmailusage# GTE "90" and #vmailusage# LTE "100">

  <cfset vmailusagecolor = "e74c3c">

  <cfelse>

  <cfset vmailusagecolor = "e74c3c">

  <!--- /CFIF #vmailusage# is --->
  </cfif>
