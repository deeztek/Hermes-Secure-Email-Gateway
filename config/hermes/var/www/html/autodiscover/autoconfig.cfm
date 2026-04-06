<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

Mozilla autoconfig endpoint for Thunderbird / K-9 Mail / other clients.

Clients GET with ?emailaddress=joe@example.com to this endpoint (proxied
by nginx from https://autoconfig.<domain>/mail/config-v1.1.xml).
We respond with IMAP + SMTP server settings for the mailbox domain.

Returns 404 if the domain is not configured as a mailbox domain.
--->
<cfsetting enablecfoutputonly="yes" showdebugoutput="no">

<cfparam name="url.emailaddress" default="">
<cfset emailAddress = Trim(url.emailaddress)>

<!--- Fallback: some clients send the query using different keys --->
<cfif Len(emailAddress) EQ 0>
  <cfif StructKeyExists(url, "EMAILADDRESS")>
    <cfset emailAddress = Trim(url.EMAILADDRESS)>
  </cfif>
</cfif>

<!--- If no email, use Host header domain (autoconfig.<domain> → <domain>) --->
<cfset emailDomain = "">
<cfif Len(emailAddress) GT 0 AND IsValid("email", emailAddress)>
  <cfset emailDomain = LCase(ListLast(emailAddress, "@"))>
<cfelse>
  <cfset hostHeader = cgi.http_host>
  <cfif Len(hostHeader) GT 0>
    <cfset hostHeader = LCase(ListFirst(hostHeader, ":"))>
    <cfif Left(hostHeader, 11) IS "autoconfig.">
      <cfset emailDomain = Mid(hostHeader, 12, Len(hostHeader) - 11)>
    </cfif>
  </cfif>
</cfif>

<cfif Len(emailDomain) EQ 0>
  <cfheader statuscode="400" statustext="Bad Request">
  <cfcontent type="text/plain" reset="yes">
  <cfoutput>Missing emailaddress parameter</cfoutput>
  <cfabort>
</cfif>

<!--- Verify this domain is a configured mailbox domain --->
<cfquery name="checkDomain" datasource="hermes">
  SELECT id FROM domains
  WHERE domain = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emailDomain#">
  AND type = 'mailbox'
</cfquery>
<cfif checkDomain.recordcount EQ 0>
  <cfheader statuscode="404" statustext="Not Found">
  <cfcontent type="text/plain" reset="yes">
  <cfoutput>Domain not configured</cfoutput>
  <cfabort>
</cfif>

<!--- Mail server hostname: read console_host from parameters2.
     TEMPORARY: returning console_host for IMAP/POP/SMTP server until
     the additional_sans.service column + admin UI ships (v1.1). --->
<cfquery name="getConsoleHost" datasource="hermes">
  SELECT value2 FROM parameters2
  WHERE parameter = 'console.host' AND module = 'console'
</cfquery>
<cfset mailHost = getConsoleHost.value2>
<cfif Len(mailHost) EQ 0>
  <cfset mailHost = cgi.http_host>
</cfif>

<!--- Mozilla Thunderbird autoconfig XML format --->
<cfset responseXml = '<?xml version="1.0" encoding="UTF-8"?>' & Chr(10) &
  '<clientConfig version="1.1">' & Chr(10) &
  '  <emailProvider id="' & encodeForXML(emailDomain) & '">' & Chr(10) &
  '    <domain>' & encodeForXML(emailDomain) & '</domain>' & Chr(10) &
  '    <displayName>' & encodeForXML(emailDomain) & ' Mail</displayName>' & Chr(10) &
  '    <displayShortName>' & encodeForXML(emailDomain) & '</displayShortName>' & Chr(10) &
  '    <incomingServer type="imap">' & Chr(10) &
  '      <hostname>' & encodeForXML(mailHost) & '</hostname>' & Chr(10) &
  '      <port>993</port>' & Chr(10) &
  '      <socketType>SSL</socketType>' & Chr(10) &
  '      <authentication>password-cleartext</authentication>' & Chr(10) &
  '      <username>%EMAILADDRESS%</username>' & Chr(10) &
  '    </incomingServer>' & Chr(10) &
  '    <incomingServer type="pop3">' & Chr(10) &
  '      <hostname>' & encodeForXML(mailHost) & '</hostname>' & Chr(10) &
  '      <port>995</port>' & Chr(10) &
  '      <socketType>SSL</socketType>' & Chr(10) &
  '      <authentication>password-cleartext</authentication>' & Chr(10) &
  '      <username>%EMAILADDRESS%</username>' & Chr(10) &
  '      <pop3>' & Chr(10) &
  '        <leaveMessagesOnServer>true</leaveMessagesOnServer>' & Chr(10) &
  '        <downloadOnBiff>true</downloadOnBiff>' & Chr(10) &
  '      </pop3>' & Chr(10) &
  '    </incomingServer>' & Chr(10) &
  '    <outgoingServer type="smtp">' & Chr(10) &
  '      <hostname>' & encodeForXML(mailHost) & '</hostname>' & Chr(10) &
  '      <port>587</port>' & Chr(10) &
  '      <socketType>STARTTLS</socketType>' & Chr(10) &
  '      <authentication>password-cleartext</authentication>' & Chr(10) &
  '      <username>%EMAILADDRESS%</username>' & Chr(10) &
  '    </outgoingServer>' & Chr(10) &
  '  </emailProvider>' & Chr(10) &
  '</clientConfig>'>

<cfcontent type="application/xml; charset=utf-8" reset="yes">
<cfoutput>#responseXml#</cfoutput>
