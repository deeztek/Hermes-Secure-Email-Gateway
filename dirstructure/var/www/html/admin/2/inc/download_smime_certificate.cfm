
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

<cfif #getcerts.external_ca# is "1">

<cfset pfxfile="/opt/hermes/HermesExternalCACerts/#getcerts.pfx_certificate_name#">

<cfelse>

<cfquery name="getca" datasource="#datasource#">
select * from ca_settings where id='#getcerts.ca_id#'
</cfquery>

<cfset pfxfile="/opt/hermes/CA/#getca.ca_directory#/root_ca/PFX/#getcerts.pfx_certificate_name#">

<!--- #getcerts.external_ca# --->
</cfif>

<cfif NOT fileExists(pfxfile)> 

<cfset session.m = 17>
<cfoutput>
<cflocation url="#cgi.http_referer#" addtoken="no">
</cfoutput>
<cfabort>

<cfelseif fileExists(pfxfile)>

<cffile action = "copy" source = "#pfxfile#" destination = "/opt/hermes/tmp/#getcerts.pfx_certificate_name#">

<cfoutput>
<cfheader name="Content-disposition" value="attachment;filename=#getcerts.pfx_certificate_name#">
<CFCONTENT FILE="/opt/hermes/tmp/#getcerts.pfx_certificate_name#" type="application/unknown" DELETEFILE="Yes">
</cfoutput>

<!--- /CFIF fileExists(pfxfile) --->
</cfif>
