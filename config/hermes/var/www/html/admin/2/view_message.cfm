<!DOCTYPE html>

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

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG Admin | View Message</title>

  <cfinclude template="./inc/html_head.cfm" />
  <style>
    textarea { border: 1px solid ##999999; width: 100%; margin: 5px 0; padding: 3px; }
    .textareacontainer { padding-right: 8px; }
    .msg-body-sandbox { border: 1px solid ##dee2e6; padding: 15px; background: ##fff; min-height: 200px; max-height: 600px; overflow: auto; }
  </style>
</head>

<!--- ===================== --->
<!--- PARAMETER VALIDATION --->
<!--- ===================== --->

<cfparam name="startdate" default="">
<cfif IsDefined("url.startdate") is "True">
  <cfif url.startdate is not "">
    <cfif isValid("date", url.startdate)>
      <cfset startdate = url.startdate>
    <cfelse>
      <cfset m="View Message: url.startdate is invalid">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
    </cfif>
  <cfelse>
    <cfset m="View Message: url.startdate is empty">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  </cfif>
<cfelse>
  <cfset m="View Message: url.startdate is undefined">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfparam name="enddate" default="">
<cfif IsDefined("url.enddate") is "True">
  <cfif url.enddate is not "">
    <cfif isValid("date", url.enddate)>
      <cfset enddate = url.enddate>
    <cfelse>
      <cfset m="View Message: url.enddate is invalid">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
    </cfif>
  <cfelse>
    <cfset m="View Message: url.enddate is empty">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  </cfif>
<cfelse>
  <cfset m="View Message: url.enddate is undefined">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfparam name="limit" default="">
<cfif IsDefined("url.limit") is "True">
  <cfif url.limit is not "">
    <cfif url.limit is "1000" OR url.limit is "1500" OR url.limit is "2500" OR url.limit is "5000" OR url.limit is "10000" OR url.limit is "15000">
      <cfset limit = url.limit>
    <cfelse>
      <cfset m="View Message: url.limit is not 1000, 1500, 2500, 5000, 10000 or 15000">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
    </cfif>
  <cfelse>
    <cfset m="View Message: url.limit is empty">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  </cfif>
<cfelse>
  <cfset m="View Message: url.limit is undefined">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfparam name="mailid" default="">
<cfif IsDefined("url.mid") is "True">
  <cfif url.mid is not "">
    <cfquery name="checkq" datasource="hermes">
      SELECT archive, quar_loc FROM msgs WHERE mail_id LIKE BINARY <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.mid#">
    </cfquery>
    <cfif checkq.recordcount GTE 1>
      <cfset mailid = url.mid>
    <cfelse>
      <cfset m="View Message: checkq.recordcount LT 1">
      <cfinclude template="./inc/error.cfm">
      <cfabort>
    </cfif>
  <cfelse>
    <cfset m="View Message: url.mid is empty">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
  </cfif>
<cfelse>
  <cfset m="View Message: url.mid is undefined">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<!--- ===================== --->
<!--- SECURITY SETTINGS    --->
<!--- ===================== --->

<cfset allowMessageContent = false>
<cfset allowAttachmentDownload = false>
<cfset securityConfPath = "/opt/hermes/config/security.conf">
<cfif fileExists(securityConfPath)>
  <cftry>
    <cffile action="read" file="#securityConfPath#" variable="securityConf">
    <cfif REFindNoCase("ALLOW_MESSAGE_CONTENT\s*=\s*yes", securityConf)>
      <cfset allowMessageContent = true>
    </cfif>
    <cfif REFindNoCase("ALLOW_ATTACHMENT_DOWNLOAD\s*=\s*yes", securityConf)>
      <cfset allowAttachmentDownload = true>
    </cfif>
    <cfcatch></cfcatch>
  </cftry>
</cfif>

<!--- ===================== --->
<!--- LOAD MESSAGE DATA    --->
<!--- ===================== --->

<cfif checkq.archive is "N">
  <cfset quarfile = "/mnt/data/amavis/#checkq.quar_loc#">
<cfelseif checkq.archive is "Y">
  <cfset quarfile = "/mnt/hermesemail_archive/mnt/data/amavis/#checkq.quar_loc#">
<cfelse>
  <cfset m="View Message: checkq.archive is not Y or N">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<cfif NOT fileExists(quarfile)>
  <cfset m="View Message: quarfile does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>
</cfif>

<!--- Get message metadata from database --->
<cfquery name="getmsgother" datasource="hermes">
  SELECT *, sid FROM msgs WHERE mail_id LIKE BINARY <cfqueryparam cfsqltype="cf_sql_varchar" value="#mailid#">
</cfquery>

<cfset msgDate = DateFormat(getmsgother.time_iso, "yyyy-mm-dd")>
<cfset msgTime = TimeFormat(getmsgother.time_iso, "hh:mm:ss tt")>

<cfquery name="getfromaddr" datasource="hermes">
  SELECT email AS fromAddress FROM maddr WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getmsgother.sid#">
</cfquery>

<cfquery name="gettoaddr" datasource="hermes">
  SELECT msgrcpt.rid, maddr.email AS toAddress FROM msgrcpt
  INNER JOIN maddr ON msgrcpt.rid = maddr.id
  WHERE mail_id LIKE BINARY <cfqueryparam cfsqltype="cf_sql_varchar" value="#mailid#">
</cfquery>

<cfset from = getfromaddr.fromAddress>
<cfset to = gettoaddr.toAddress>

<!--- Initialize message fields --->
<cfset htmlbody = "">
<cfset textbody = "">
<cfset from2 = "">
<cfset to2 = "">
<cfset cc = "">
<cfset subject = getmsgother.subject>
<cfset header = "">

<cfif allowMessageContent>
  <!--- Full EML parse needed for body content --->
  <cfset popAccount = createObject("component", "pop").init()>
  <cfset message = popAccount.loadFromFile("#quarfile#")>
  <cfset htmlbody = message.htmlbody>
  <cfset textbody = message.textbody>
  <cfset from2 = message.FROMEMAILADDRESS>
  <cfset to2 = message.TOEMAILADDRESS>
  <cfset subject = message.subject>
  <cfset header = message.header>
  <cfset cc = message.CCEMAILADDRESS>
<cfelse>
  <!--- Fast path: read only raw headers from file using buffered reader (stops at first blank line) --->
  <cftry>
    <cfset headerBuilder = createObject("java", "java.lang.StringBuilder").init()>
    <cfset fis = createObject("java", "java.io.FileInputStream").init(quarfile)>
    <cfset isr = createObject("java", "java.io.InputStreamReader").init(fis, "UTF-8")>
    <cfset br = createObject("java", "java.io.BufferedReader").init(isr)>
    <cfloop condition="true">
      <cfset line = br.readLine()>
      <cfif isNull(line) OR trim(line) EQ ""><cfbreak></cfif>
      <cfset headerBuilder.append(line).append(chr(10))>
    </cfloop>
    <cfset br.close()>
    <cfset header = headerBuilder.toString()>
    <!--- Extract Return-Path, To, CC from raw headers --->
    <cfset headerLines = header>
    <cfset rpMatch = REFindNoCase("Return-Path:\s*<?([^>\r\n]+)>?", headerLines, 1, true)>
    <cfif rpMatch.pos[1] GT 0>
      <cfset from2 = Mid(headerLines, rpMatch.pos[2], rpMatch.len[2])>
    </cfif>
    <cfset ccMatch = REFindNoCase("(?:^|\n)Cc:\s*([^\r\n]+)", headerLines, 1, true)>
    <cfif ccMatch.pos[1] GT 0>
      <cfset cc = Mid(headerLines, ccMatch.pos[2], ccMatch.len[2])>
    </cfif>
    <cfcatch>
      <cfset header = "Unable to read message headers">
    </cfcatch>
  </cftry>
</cfif>

<!--- ===================== --->
<!--- EXTRACT ATTACHMENTS  --->
<!--- ===================== --->

<!--- Only parse MIME structure for attachments when at least one feature needs it --->
<cfset attachmentList = ArrayNew(1)>
<cfif allowMessageContent OR allowAttachmentDownload>
  <cftry>
    <cffile action="readBinary" file="#quarfile#" variable="emlBytes">
    <cfset jProps = createObject("java", "java.util.Properties").init()>
    <cfset jSession = createObject("java", "javax.mail.Session").getDefaultInstance(jProps)>
    <cfset bais = createObject("java", "java.io.ByteArrayInputStream").init(emlBytes)>
    <cfset mimeMsg = createObject("java", "javax.mail.internet.MimeMessage").init(jSession, bais)>
    <cfset bais.close()>

    <!--- Recursive walk of MIME parts to find attachments --->
    <cfset partStack = ArrayNew(1)>
    <cfset ArrayAppend(partStack, { part = mimeMsg, index = "0" })>

    <cfloop condition="ArrayLen(partStack) GT 0">
      <cfset current = partStack[1]>
      <cfset ArrayDeleteAt(partStack, 1)>
      <cfset cType = current.part.getContentType()>

      <cfif FindNoCase("multipart/", cType)>
        <cftry>
          <cfset mp = current.part.getContent()>
          <cfloop from="0" to="#mp.getCount() - 1#" index="pi">
            <cfset ArrayAppend(partStack, { part = mp.getBodyPart(JavaCast("int", pi)), index = current.index & "." & pi })>
          </cfloop>
          <cfcatch></cfcatch>
        </cftry>
      <cfelse>
        <cfset fn = current.part.getFileName()>
        <cfif isDefined("fn") AND NOT isNull(fn) AND fn NEQ "">
          <cfset attInfo = StructNew()>
          <cfset attInfo.filename = fn>
          <cfset attInfo.contentType = ListFirst(cType, ";")>
          <cfset attInfo.size = current.part.getSize()>
          <cfset attInfo.partIndex = current.index>
          <cfset ArrayAppend(attachmentList, attInfo)>
        </cfif>
      </cfif>
    </cfloop>
    <cfcatch>
      <!--- Silently fail - attachments won't be listed --->
    </cfcatch>
  </cftry>
</cfif>

<!--- ===================== --->
<!--- PAGE OUTPUT          --->
<!--- ===================== --->

<body>
<!-- Preloader -->
<div class="preloader">
  <img src="/dist/img/hermes_preloader.gif" alt="Loading">
</div>

<div class="container-fluid">

  <div class="card card-primary card-outline">

    <!--- TOOLBAR --->
    <div class="card-header">
      <h3 class="card-title"><i class="fas fa-envelope-open-text"></i> View Message</h3>
    </div>

    <div class="card-body p-3">

      <!--- Action Buttons --->
      <div class="mb-3">
        <cfoutput>
        <a href="view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" title="Back to Message History" class="btn btn-secondary">
          <i class="fas fa-reply"></i> Back
        </a>
        <a href="./inc/download_message.cfm?mid=#URLEncodedFormat(Trim(mailid))#" title="Download Message as EML" class="btn btn-secondary">
          <i class="fas fa-download"></i> Download EML
        </a>
        </cfoutput>
        <button class="btn btn-secondary" title="Print Message" onclick="printPage();">
          <i class="fas fa-print"></i> Print
        </button>
      </div>

      <!--- Message Header Info --->
      <div class="card mb-3">
        <div class="card-body">
          <cfoutput>
          <h5 class="mb-3">#encodeForHTML(subject)# <span class="text-muted float-end small">#msgDate# #msgTime#</span></h5>
          <div class="row">
            <div class="col-md-6">
              <p class="mb-1"><strong>From:</strong> #encodeForHTML(from)#</p>
              <p class="mb-1"><strong>Return-Path:</strong> #encodeForHTML(from2)#</p>
            </div>
            <div class="col-md-6">
              <p class="mb-1"><strong>To:</strong> #encodeForHTML(to)#</p>
              <p class="mb-1"><strong>X-Envelope-To:</strong> #encodeForHTML(to2)#</p>
              <cfif cc is not ""><p class="mb-1"><strong>CC:</strong> #encodeForHTML(cc)#</p></cfif>
            </div>
          </div>
          </cfoutput>
        </div>
      </div>

      <!--- Security Warning --->
      <cfif allowMessageContent OR allowAttachmentDownload>
        <div class="alert alert-warning alert-dismissible mb-3">
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          <h6 class="alert-heading"><i class="fas fa-exclamation-triangle me-1"></i> Security Warning</h6>
          <p class="mb-0">This message may contain malicious content. Clicking links in the message body, opening attachments, or downloading files can infect your computer with malware. Exercise caution and only interact with content from trusted senders.</p>
        </div>
      </cfif>

      <!--- Attachments Section --->
      <cfif ArrayLen(attachmentList) GT 0>
        <div class="card mb-3">
          <div class="card-header">
            <h5 class="card-title mb-0"><i class="fas fa-paperclip"></i> Attachments (<cfoutput>#ArrayLen(attachmentList)#</cfoutput>)</h5>
          </div>
          <div class="card-body p-0">
            <ul class="list-group list-group-flush">
              <cfloop from="1" to="#ArrayLen(attachmentList)#" index="ai">
                <cfoutput>
                <li class="list-group-item d-flex justify-content-between align-items-center">
                  <span>
                    <i class="fas fa-file me-1"></i>
                    #encodeForHTML(attachmentList[ai].filename)#
                    <small class="text-muted ms-1">
                      (#encodeForHTML(attachmentList[ai].contentType)#<cfif attachmentList[ai].size GT 0>, #NumberFormat(attachmentList[ai].size / 1024, "0.0")# KB</cfif>)
                    </small>
                  </span>
                  <cfif allowAttachmentDownload>
                    <a href="./inc/download_attachment.cfm?mid=#URLEncodedFormat(Trim(mailid))#&part=#URLEncodedFormat(attachmentList[ai].partIndex)#&fn=#URLEncodedFormat(attachmentList[ai].filename)#"
                       class="btn btn-sm btn-primary" title="Download #encodeForHTMLAttribute(attachmentList[ai].filename)#">
                      <i class="fas fa-download"></i>
                    </a>
                  <cfelse>
                    <span class="badge bg-secondary" title="ALLOW_ATTACHMENT_DOWNLOAD is disabled in security.conf">
                      <i class="fas fa-lock"></i> Download Disabled
                    </span>
                  </cfif>
                </li>
                </cfoutput>
              </cfloop>
            </ul>
          </div>
        </div>
      </cfif>

      <!--- Message Body --->
      <div class="card mb-3">
        <div class="card-header">
          <h5 class="card-title mb-0"><i class="fas fa-envelope"></i> Message Body</h5>
        </div>
        <div class="card-body">
          <cfif allowMessageContent>
            <cfif htmlbody is "">
              <div class="textareacontainer">
                <textarea wrap="physical" rows="25" readonly><cfoutput>#textbody#</cfoutput></textarea>
              </div>
            <cfelse>
              <div class="msg-body-sandbox">
                <cfoutput>#htmlbody#</cfoutput>
              </div>
            </cfif>
          <cfelse>
            <div class="alert alert-info mb-0">
              <i class="fas fa-lock me-1"></i> Message body content is hidden. To enable, set <code>ALLOW_MESSAGE_CONTENT=yes</code> in <code>/opt/hermes/config/security.conf</code>.
            </div>
          </cfif>
        </div>
      </div>

      <!--- Headers --->
      <div class="card mb-3">
        <div class="card-header">
          <h5 class="card-title mb-0"><i class="fas fa-code"></i> Headers</h5>
        </div>
        <div class="card-body">
          <div class="textareacontainer">
            <textarea wrap="physical" rows="25" readonly><cfoutput>#header#</cfoutput></textarea>
          </div>
        </div>
      </div>

    </div>
    <!-- /.card-body -->
  </div>
  <!-- /.card -->

</div>
<!-- /.container-fluid -->

</body>

<script>
function printPage() {
  window.print();
}
</script>

</html>
