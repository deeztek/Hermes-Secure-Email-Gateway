<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

Microsoft Autodiscover endpoint for Outlook / iOS Mail / Exchange clients.

Clients POST an XML request with <EMailAddress> to this endpoint (proxied
by nginx from https://autodiscover.<domain>/autodiscover/autodiscover.xml).
We respond with IMAP + SMTP server settings for the mailbox domain.

Returns 404 if the email's domain is not configured as a mailbox domain.
--->
<cfsetting enablecfoutputonly="yes" showdebugoutput="no">

<!--- Parse the incoming POST body --->
<cfset emailAddress = "">
<cftry>
  <cfset postBody = GetHttpRequestData().content>
  <cfif IsBinary(postBody)>
    <cfset postBody = CharsetEncode(postBody, "utf-8")>
  </cfif>
  <cfif Len(Trim(postBody)) GT 0>
    <cfset xmlDoc = XmlParse(postBody)>
    <cfset emailNodes = XmlSearch(xmlDoc, "//*[local-name()='EMailAddress']")>
    <cfif ArrayLen(emailNodes) GTE 1>
      <cfset emailAddress = Trim(emailNodes[1].XmlText)>
    </cfif>
  </cfif>
  <cfcatch type="any">
    <cfset emailAddress = "">
  </cfcatch>
</cftry>

<!--- Fallback: try form/url scope if the XML parse failed --->
<cfif Len(emailAddress) EQ 0>
  <cfif StructKeyExists(form, "EMailAddress")>
    <cfset emailAddress = Trim(form.EMailAddress)>
  <cfelseif StructKeyExists(url, "emailaddress")>
    <cfset emailAddress = Trim(url.emailaddress)>
  </cfif>
</cfif>

<cfif Len(emailAddress) EQ 0 OR NOT IsValid("email", emailAddress)>
  <cfheader statuscode="400" statustext="Bad Request">
  <cfcontent type="text/plain" reset="yes">
  <cfoutput>Invalid or missing EMailAddress</cfoutput>
  <cfabort>
</cfif>

<!--- Extract domain from email --->
<cfset emailDomain = LCase(ListLast(emailAddress, "@"))>

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
     the additional_sans.service column + admin UI ships (v1.1).
     Admin will then configure which SAN prefix serves which protocol
     (imap/pop/smtp/all) and this XML will return the branded hostname
     like mail.<domain> or imap.<domain>. --->
<cfquery name="getConsoleHost" datasource="hermes">
  SELECT value2 FROM parameters2
  WHERE parameter = 'console.host' AND module = 'console'
</cfquery>
<cfset mailHost = getConsoleHost.value2>
<cfif Len(mailHost) EQ 0>
  <cfset mailHost = cgi.http_host>
</cfif>

<!--- Build autodiscover response XML --->
<cfset responseXml = '<?xml version="1.0" encoding="utf-8"?>' & Chr(10) &
  '<Autodiscover xmlns="http://schemas.microsoft.com/exchange/autodiscover/responseschema/2006">' & Chr(10) &
  '  <Response xmlns="http://schemas.microsoft.com/exchange/autodiscover/outlook/responseschema/2006a">' & Chr(10) &
  '    <User>' & Chr(10) &
  '      <DisplayName>' & encodeForXML(emailAddress) & '</DisplayName>' & Chr(10) &
  '    </User>' & Chr(10) &
  '    <Account>' & Chr(10) &
  '      <AccountType>email</AccountType>' & Chr(10) &
  '      <Action>settings</Action>' & Chr(10) &
  '      <Protocol>' & Chr(10) &
  '        <Type>IMAP</Type>' & Chr(10) &
  '        <Server>' & encodeForXML(mailHost) & '</Server>' & Chr(10) &
  '        <Port>993</Port>' & Chr(10) &
  '        <DomainRequired>off</DomainRequired>' & Chr(10) &
  '        <LoginName>' & encodeForXML(emailAddress) & '</LoginName>' & Chr(10) &
  '        <SPA>off</SPA>' & Chr(10) &
  '        <SSL>on</SSL>' & Chr(10) &
  '        <AuthRequired>on</AuthRequired>' & Chr(10) &
  '      </Protocol>' & Chr(10) &
  '      <Protocol>' & Chr(10) &
  '        <Type>POP3</Type>' & Chr(10) &
  '        <Server>' & encodeForXML(mailHost) & '</Server>' & Chr(10) &
  '        <Port>995</Port>' & Chr(10) &
  '        <DomainRequired>off</DomainRequired>' & Chr(10) &
  '        <LoginName>' & encodeForXML(emailAddress) & '</LoginName>' & Chr(10) &
  '        <SPA>off</SPA>' & Chr(10) &
  '        <SSL>on</SSL>' & Chr(10) &
  '        <AuthRequired>on</AuthRequired>' & Chr(10) &
  '      </Protocol>' & Chr(10) &
  '      <Protocol>' & Chr(10) &
  '        <Type>SMTP</Type>' & Chr(10) &
  '        <Server>' & encodeForXML(mailHost) & '</Server>' & Chr(10) &
  '        <Port>587</Port>' & Chr(10) &
  '        <DomainRequired>off</DomainRequired>' & Chr(10) &
  '        <LoginName>' & encodeForXML(emailAddress) & '</LoginName>' & Chr(10) &
  '        <SPA>off</SPA>' & Chr(10) &
  '        <Encryption>TLS</Encryption>' & Chr(10) &
  '        <AuthRequired>on</AuthRequired>' & Chr(10) &
  '        <UsePOPAuth>off</UsePOPAuth>' & Chr(10) &
  '        <SMTPLast>off</SMTPLast>' & Chr(10) &
  '      </Protocol>' & Chr(10) &
  '    </Account>' & Chr(10) &
  '  </Response>' & Chr(10) &
  '</Autodiscover>'>

<cfcontent type="text/xml; charset=utf-8" reset="yes">
<cfoutput>#responseXml#</cfoutput>
