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
