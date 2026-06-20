<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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

<!--- Security check --->
<cfset allowCADownload = false>
<cfset securityConfPath = "/opt/hermes/config/security.conf">
<cfif fileExists(securityConfPath)>
  <cftry>
    <cffile action="read" file="#securityConfPath#" variable="securityConf">
    <cfif REFindNoCase("ALLOW_CA_DOWNLOAD\s*=\s*yes", securityConf)>
      <cfset allowCADownload = true>
    </cfif>
    <cfcatch></cfcatch>
  </cftry>
</cfif>

<cfif NOT allowCADownload>
  <cfset session.m_ca = 45>
  <cflocation url="view_internal_ca.cfm" addtoken="no">
</cfif>

<!--- Validate parameters --->
<cfif NOT IsDefined("url.id") OR NOT IsNumeric(url.id)>
  <cfset session.m_ca = 46>
  <cflocation url="view_internal_ca.cfm" addtoken="no">
</cfif>
<cfif NOT IsDefined("url.type") OR NOT ListFindNoCase("cert,key", url.type)>
  <cfset session.m_ca = 46>
  <cflocation url="view_internal_ca.cfm" addtoken="no">
</cfif>

<!--- Get CA details --->
<cfquery name="getCA" datasource="hermes">
  SELECT * FROM ca_settings WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getCA.recordcount LT 1>
  <cfset session.m_ca = 46>
  <cflocation url="view_internal_ca.cfm" addtoken="no">
</cfif>

<cfset caDir = "/opt/hermes/CA/#getCA.ca_directory#/root_ca">

<cfif url.type is "cert">
  <cfset filePath = "#caDir#/certs/cacert.pem">
  <cfset fileName = "#getCA.ca_directory#_cacert.pem">
<cfelseif url.type is "key">
  <cfset filePath = "#caDir#/private/cakey.pem">
  <cfset fileName = "#getCA.ca_directory#_cakey.pem">
</cfif>

<cfif NOT fileExists(filePath)>
  <cfset session.m_ca = 47>
  <cflocation url="view_internal_ca.cfm" addtoken="no">
</cfif>

<!--- Serve the file --->
<cffile action="copy" source="#filePath#" destination="/opt/hermes/tmp/#fileName#">
<cfheader name="Content-Disposition" value="attachment;filename=#fileName#">
<cfcontent file="/opt/hermes/tmp/#fileName#" type="application/x-pem-file" deletefile="Yes">
