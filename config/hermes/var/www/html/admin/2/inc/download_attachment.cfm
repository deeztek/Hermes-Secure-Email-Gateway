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

<!--- Security check: ALLOW_ATTACHMENT_DOWNLOAD must be enabled --->
<cfset allowAttachmentDownload = false>
<cfset securityConfPath = "/opt/hermes/config/security.conf">
<cfif fileExists(securityConfPath)>
  <cftry>
    <cffile action="read" file="#securityConfPath#" variable="securityConf">
    <cfif REFindNoCase("ALLOW_ATTACHMENT_DOWNLOAD\s*=\s*yes", securityConf)>
      <cfset allowAttachmentDownload = true>
    </cfif>
    <cfcatch></cfcatch>
  </cftry>
</cfif>

<cfif NOT allowAttachmentDownload>
  <cfset m="Download Attachment: ALLOW_ATTACHMENT_DOWNLOAD is not enabled in security.conf">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<!--- Validate parameters --->
<cfif NOT IsDefined("url.mid") OR url.mid is "">
  <cfset m="Download Attachment: url.mid is missing or empty">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<cfif NOT IsDefined("url.part") OR url.part is "">
  <cfset m="Download Attachment: url.part is missing or empty">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<cfif NOT IsDefined("url.fn") OR url.fn is "">
  <cfset m="Download Attachment: url.fn is missing or empty">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<!--- Validate part index format (only digits and dots) --->
<cfif REFind("[^\d.]", url.part) GT 0>
  <cfset m="Download Attachment: url.part contains invalid characters">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<!--- Sanitize filename (remove path separators) --->
<cfset safeFilename = ReReplace(url.fn, "[/\\:*?""<>|]", "_", "ALL")>

<!--- Look up quarantine file --->
<cfquery name="checkq" datasource="hermes">
  SELECT archive, quar_loc FROM msgs WHERE mail_id LIKE BINARY <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.mid#">
</cfquery>

<cfif checkq.recordcount LT 1>
  <cfset m="Download Attachment: message not found">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<cfif checkq.archive is "N">
  <cfset quarfile = "/mnt/data/amavis/#checkq.quar_loc#">
<cfelseif checkq.archive is "Y">
  <cfset quarfile = "/mnt/hermesemail_archive/mnt/data/amavis/#checkq.quar_loc#">
<cfelse>
  <cfset m="Download Attachment: invalid archive flag">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<cfif NOT fileExists(quarfile)>
  <cfset m="Download Attachment: quarantine file does not exist">
  <cfinclude template="error.cfm">
  <cfabort>
</cfif>

<!--- Parse EML and extract the specific MIME part --->
<cftry>
  <cffile action="readBinary" file="#quarfile#" variable="emlBytes">
  <cfset jProps = createObject("java", "java.util.Properties").init()>
  <cfset jSession = createObject("java", "javax.mail.Session").getDefaultInstance(jProps)>
  <cfset bais = createObject("java", "java.io.ByteArrayInputStream").init(emlBytes)>
  <cfset mimeMsg = createObject("java", "javax.mail.internet.MimeMessage").init(jSession, bais)>
  <cfset bais.close()>

  <!--- Walk MIME tree by part index (e.g., "0.1.0") --->
  <cfset indices = ListToArray(url.part, ".")>
  <cfset currentPart = mimeMsg>

  <!--- Skip first index (always 0 for the root message) --->
  <cfloop from="2" to="#ArrayLen(indices)#" index="idx">
    <cfset mp = currentPart.getContent()>
    <cfset currentPart = mp.getBodyPart(JavaCast("int", indices[idx]))>
  </cfloop>

  <!--- Write attachment to temp file --->
  <cfset tmpFile = "/opt/hermes/tmp/att_#CreateUUID()#_#safeFilename#">
  <cfset fos = createObject("java", "java.io.FileOutputStream").init(tmpFile)>
  <cfset bos = createObject("java", "java.io.BufferedOutputStream").init(fos)>
  <cfset is = currentPart.getInputStream()>
  <cfset buf = createObject("java", "java.lang.reflect.Array").newInstance(createObject("java", "java.lang.Byte").TYPE, JavaCast("int", 8192))>
  <cfloop condition="true">
    <cfset bytesRead = is.read(buf)>
    <cfif bytesRead EQ -1><cfbreak></cfif>
    <cfset bos.write(buf, JavaCast("int", 0), bytesRead)>
  </cfloop>
  <cfset bos.close()>
  <cfset fos.close()>
  <cfset is.close()>

  <!--- Serve the file --->
  <cfheader name="Content-Disposition" value="attachment;filename=#safeFilename#">
  <cfcontent file="#tmpFile#" type="application/octet-stream" deletefile="Yes">

  <cfcatch type="any">
    <cfset m="Download Attachment: " & cfcatch.message>
    <cfinclude template="error.cfm">
    <cfabort>
  </cfcatch>
</cftry>
