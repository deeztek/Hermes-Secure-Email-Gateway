<!DOCTYPE html>

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

<html lang="en">



<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG Admin | View Message</title>

<cfinclude template="./inc/html_head.cfm" />


  <!-- Preloader -->
  <div class="preloader flex-column justify-content-center align-items-center">
    <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
    </div>

<!--- TEXT AREA STYLE ---> 
<style>
textarea{
    border:1px solid #999999;
    width:100%;
    margin:5px 0;
    padding:3px;
}
.textareacontainer{
    padding-right: 8px; /* 1 + 3 + 3 + 1 */
}
  </style>

</head>



<cfparam name = "startdate" default = ""> 
<cfif IsDefined("url.startdate") is "True">
<cfif url.startdate is not "">
<cfif isValid("date", #url.startdate#)> 
<cfset startdate = url.startdate>
<cfelseif NOT isValid("date", #url.startdate#)>

<cfset m="View Message: url.startdate is invalid">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF NOT isValid("date", #url.startdate#) --->
 </cfif>

 <cfelseif url.startdate is "">

 <cfset m="View Message: url.startdate is empty">
 <cfinclude template="./inc/error.cfm">
 <cfabort>

<!--- /CFIF url.startdate is "" --->
</cfif>

<cfelse>

<cfset m="View Message: url.startdate is undefined">
<cfinclude template="./inc/error.cfm">
<cfabort>

 <!--- /CFIF IsDefined("url.startdate") --->
</cfif>

<cfparam name = "enddate" default = ""> 
<cfif IsDefined("url.enddate") is "True">
<cfif url.enddate is not "">
<cfif isValid("date", #url.enddate#)> 
<cfset enddate = url.enddate>
<cfelseif NOT isValid("date", #url.enddate#)>

<cfset m="View Message: url.enddate is invalid">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF NOT isValid("date", #url.enddate#) --->
 </cfif>

<cfelseif url.enddate is "">

  <cfset m="View Message: url.enddate is empty">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF url.enddate is "" --->
</cfif>

<cfelse>

<cfset m="View Message: url.enddate is undefined">
<cfinclude template="./inc/error.cfm">
<cfabort>

 <!--- /CFIF IsDefined("url.enddate") --->
</cfif>

<cfparam name = "limit" default = "">

<cfif IsDefined("url.limit") is "True">

<cfif url.limit is not "">

<cfif #url.limit# is "1000" OR #url.limit# is "1500" OR #url.limit# is "2500" OR #url.limit# is "5000" OR #url.limit# is "10000" OR #url.limit# is "15000"> 

<cfset limit = url.limit>

<cfelse>

<cfset m="View Message: url.limit is not 1000, 1500, 2500, 5000, 10000 or 15000">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF #url.limit# is "1000" OR #url.limit# is "1500" OR #url.limit# is "2500" OR #url.limit# is "5000" OR #url.limit# is "10000" OR #url.limit# is "15000" --->
 </cfif>

<cfelseif #url.limit# is "">

<cfset m="View Message: url.limit is empty">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF url.limit is "" --->
</cfif>

<cfelse>

<cfset m="View Message: url.limit is undefined">
<cfinclude template="./inc/error.cfm">
<cfabort>

 <!--- /CFIF IsDefined("url.limit") --->
</cfif>

<cfparam name = "mailid" default = "">

<cfif IsDefined("url.mid") is "True">

<cfif url.mid is not "">

<cfquery name="checkq" datasource="hermes">
select msgrcpt.mail_id, msgrcpt.rid, msgs.mail_id, msgs.archive, msgs.quar_loc from msgs INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id where msgs.mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.mid#"> and msgrcpt.rid = '#session.owner#'
</cfquery>

<cfif #checkq.recordcount# GTE 1>
    
<cfset mailid = "#url.mid#">

<cfelseif #checkq.recordcount# LT 1>

<cfset m="View Message: checkq.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

</cfif>

<cfelseif #url.mid# is "">

<cfset m="View Message: url.mid is empty">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF url.mid is "" --->
</cfif>

<cfelse>

<cfset m="View Message: url.mid is undefined">
<cfinclude template="./inc/error.cfm">
<cfabort>

 <!--- /CFIF IsDefined("url.mid") --->
</cfif>


<cfif #checkq.archive# is "N">

<cfset quarfile="/mnt/data/amavis/#checkq.quar_loc#">


<cfelseif #checkq.archive# is "Y">

<!---
<cfquery name="getarchive" datasource="hermes">
select * from archive_jobs limit 1
</cfquery>
--->

<cfset quarfile="/mnt/hermesemail_archive/mnt/data/amavis/#checkq.quar_loc#">

<cfelse>

  <cfset m="View Message: checkq.archive is not Y or N">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF checkq.archive --->
</cfif>

<cfif fileExists(quarfile)>

<cfquery name="getmsgother" datasource="hermes">
SELECT * FROM msgs where mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#mailid#">
</cfquery>

<cfset popAccount = createObject("component", "pop").init()>

<cfset message = popAccount.loadFromFile("#quarfile#")>

<!---<cfset email = CreateObject('component', 'emailParse').init('#FileData#') /> --->

<cfset date=#DateFormat(getmsgother.time_iso,"yyyy-mm-dd")#>
<cfset time="#TimeFormat(getmsgother.time_iso, "hh:mm:ss tt")#">

<!---
<cfset bodyNOHTML = REReplace("#message.HTMLBODY#","(<a.*?>)(.*?)(</a>)","\2","ALL")>
--->

<cfset htmlbody = "#message.htmlbody#">
<cfset textbody = "#message.textbody#">

<cfset from2 = "#message.FROMEMAILADDRESS#">
<cfset to2 = "#message.TOEMAILADDRESS#">


<cfquery name="getsid" datasource="hermes">
select sid from msgs where mail_id = '#mailid#'
</cfquery>

<cfquery name="getfromaddr" datasource="hermes">
SELECT email as fromAddress FROM maddr where id='#getsid.sid#'
</cfquery>

<cfquery name="gettoaddr" datasource="hermes">
SELECT msgrcpt.rid,maddr.email as toAddress FROM msgrcpt INNER JOIN maddr ON msgrcpt.rid = maddr.id where mail_id like binary <cfqueryparam cfsqltype="cf_sql_varchar" value="#mailid#">
</cfquery>

<cfset from = "#getfromaddr.fromAddress#">
<cfset to = "#gettoaddr.toAddress#">

<cfset subject = "#message.subject#">
<cfset header = "#message.header#">
<cfset cc = "#message.CCEMAILADDRESS#">

<cfelse>

  
  <cfset m="View Message: quarfile does not exist">
  <cfinclude template="./inc/error.cfm">
  <cfabort>

<!--- /CFIF fileExists(quarfile)> --->  
</cfif>



<body>
  <div class="container-fluid">

<div class="card card-primary card-outline">


    <div class="mailbox-controls with-border text-left">
      <div class="btn-group">
        <!---
        <button type="button" class="btn btn-default btn-sm" data-container="body" title="Delete">
          <i class="far fa-trash-alt"></i>
        </button>
      --->

      <cfoutput>
      <a href="preloader_view_message_history.cfm?startdate=#startdate#&enddate=#enddate#&limit=#limit#" title="Back to Message History" class="btn btn-secondary btn-lg" role="button"><i class="fas fa-reply"></i></a>
    </cfoutput>

    &nbsp;&nbsp;

    <cfif #session.download_msg# is "1">

    <cfoutput>
      <a href="./inc/download_message.cfm?mid=#URLEncodedFormat(Trim(mailid))#" title="Download Message" class="btn btn-secondary btn-lg" role="button"><i class="fas fa-download"></i></a>
    </cfoutput>

    &nbsp;&nbsp;

    <!--- /CFIF #session.download_msg# is "1" --->

    </cfif>

    <button class="btn btn-secondary btn-lg" title="Print Message" onclick="printPage()"><i class="fas fa-print"></i></button>

        <!---
        <button type="button" class="btn btn-default btn-sm" data-container="body" title="Forward">
          <i class="fas fa-share"></i>
        </button>

             <button type="button" class="btn btn-default btn-sm" title="Print">
        <i class="fas fa-print"></i>
      </button>

      --->
      </div>
      <!-- /.btn-group -->
 
    </div>
    <!-- /.mailbox-controls -->

    <div class="card-header">

    <h2 class="card-title">View Message</h2>

          <!---
    <div class="card-tools">
      <cfoutput>
      <a href="view_messages.cfm?startdate=#url.startdate#&enddate=#url.enddate#&limit=#url.limit#" class="btn btn-tool" title="Previous"><i class="fas fa-chevron-left"></i></a>
    </cfoutput>

      <a href="#" class="btn btn-tool" title="Next"><i class="fas fa-chevron-right"></i></a>
          </div>
  --->

  </div>
  <!-- /.card-header -->
  <div class="card-body p-0">
    <div class="mailbox-read-info">
      <cfoutput>
      <h5>#subject# <span class="mailbox-read-time float-right">#date# #time#</span></h5>
    </div>
    <div class="mailbox-read-info">
      <h6><strong>From:</strong> #from#</h6>
      <h6><strong>Return-Path:</strong> #from2#</h6>
        <h6><strong>To:</strong> #to#</h6>
        <h6><strong>X-Envelope-To:</strong> #to2#</h6>
        <h6><strong>CC:</strong> #cc#</h6>
      </cfoutput>
    </div>
 
    <!-- /.mailbox-read-info -->
   

<div class="mailbox-read-message">
<cfif #htmlbody# is "">

<div class="textareacontainer">
<textarea wrap="physical" rows="25">
<cfoutput>#textbody#</cfoutput>
</textarea>
</div>

<!---
        <cfoutput>
          #textbody#
        </cfoutput>
      --->

      <cfelse>
      </cfif>
      <cfoutput>
      <p>#htmlbody#</p>
    </cfoutput>

      
    </div>
    <!-- /.mailbox-read-message -->

<div class="mailbox-read-info">

<h5>Headers</h5>
</div>

<div class="textareacontainer">
<textarea wrap="physical" rows="25">
<cfoutput>#header#</cfoutput>
</textarea>
</div>

  </div>
  <!-- /.card-body -->

</wrapper>

</body>

<!--- SCRIPT TO PRINT PAGE --->
<script>
function printPage() {
  window.print();
}
</script>

</html>