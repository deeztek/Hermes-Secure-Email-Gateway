<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula>.
--->

<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH")#">
<cfset theDate=#DateFormat(DateAdd('d', -1, datenow),'yyyy-mm-dd')#>
<cfset datenow2=#DateFormat(datenow,"mm/dd/yyyy")#>

<cfset frequency=#url.frequency#>

<!--- GENERATE REPORT FOR USERS WHO HAVE CHOSEN TO RECEIVE REPORT REGARDLESS STARTS HERE--->

<cfquery name="getrecipientsall" datasource="hermes">
SELECT users.email as rcptemail, user_settings.id as customid, user_settings.report_enabled, user_settings.report_frequency from user_settings LEFT JOIN users ON users.email = user_settings.email where user_settings.report_enabled = 'ALL' and user_settings.report_frequency = '#frequency#' and users.email is not NULL
</cfquery>

<cfloop query="getrecipientsall">
<cfoutput>
<cfquery name="getrid" datasource="hermes">
select id as rcptid from maddr where email='#rcptemail#'
</cfquery>
#rcptemail#<br>

<cfquery name="getquarantineall" datasource="hermes">
SELECT msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds from msgrcpt LEFT JOIN msgs ON msgs.mail_id = msgrcpt.mail_id where (msgrcpt.ds like binary 'B' or msgrcpt.ds like binary 'D') and msgrcpt.rid='#getrid.rcptid#' and msgs.time_iso between '#datenow# 00:00:00' and '#datenow# 23:59:59' group by msgrcpt.mail_id order by msgs.time_iso desc
</cfquery>

<cfquery name="getpostmaster" datasource="hermes">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfmail from="#getpostmaster.value#" to="#TRIM(rcptemail)#" subject="[#rcptemail#] Hermes Secure Email Gateway Scheduled Quarantine Report" type="HTML" server="localhost" port="10026">
    <HTML>
       <head><title>Hermes Secure Email Gateway Scheduled Quarantine Report</title>

       </head>
       <body>
           <!--- Style Tag in the Body, not Head, for Email --->

<style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; }
</style>


<table id="Table2" border="0" cellspacing="6" cellpadding="2" width="100%" style="height: 50px;">
  <tr style="height: 75px;">
    <td width="750" id="Cell9" style="background-color: rgb(45,103,228);">
      <p style="margin-bottom: 0px;"><img id="Picture1" height="75" width="750" src="cid:hermeslogo" vspace="0" hspace="0" align="top" border="0" alt="hermes_secure_mail_gateway" title="Hermes Secure Email Gateway"></p>
    </td>
  </tr>
  <tr style="height: 96px;">
    <td id="Cell10">


      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12pt;"><b>Scheduled Quarantine Report for #rcptemail# for period #datenow2#</b><br><br> The listing below shows <b>#getquarantineall.recordcount# messages</b> that the system has quarantined. <br><br>

If there are no messages listed, then the system did not quarantine any messages for the period listed above.<br><br>

If you wish to view a message, click on the View Msg button.<br><br>

If you wish to release a message to your mailbox, click the the Release Msg button. <br><br>

Additionally, click the links below to access the different sections of the User Console:

<cfquery name="getportal" datasource="hermes">
select value2 from parameters2 where parameter='console.host' and module='console'
</cfquery>

<ul>

<li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=3">Report Settings</a> - Clicking this link will direct you to the Report Settings where you can adjust the settings for this report.</li>
<li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=2">History and Archive</a> - Clicking this link will direct you to the Message History where you can search, view/download and release email messages to your mailbox.</li>
<li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=4">Sender Filters</a> - Clicking this link will direct you to the Sender Filters where you can create block/allow filters for outside email addresses.</li>
<li><a href="https://docs.deeztek.com/books/hermes-seg-user-guide/page/accessing-the-user-self-service-portal">Online Help</a> - Clicking this link will direct you to the Hermes SEG Online Help where you can read detailed instructions on how to use each part of the User Console</li>
</ul>
</span></p>


<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12pt;">
<b>Please note the system periodically purges oldest messages in order to conserve system resources</b></span></p>

    </td>
  </tr>
</table>


<hr id="HRRule7" width="100%" size="1">

<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">
    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Date/Time</span></b></p>
    </td>
   
   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">From</span></b></p>
    </td>

   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Subject</span></b></p>
    </td>

   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Type</span></b></p>
    </td>

   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Score</span></b></p>
    </td>

   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">View Msg</span></b></p>
    </td>

  <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Release Msg</span></b></p>
    </td>
    

  

    
  </tr>
<cfoutput query="getquarantineall">

<cfset date = #DateFormat(time_iso, "mm/dd/yyyy")#>
<cfset time = #TimeFormat(time_iso, "HH:mm:ss")#>
  <tr style="height: 28px;">
    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#date# #time# </span></p>
</div>
    </td>
    

<cfquery name="getfromaddr" datasource="hermes">
SELECT email as fromAddress FROM maddr where id='#sid#'
</cfquery>

    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#getfromaddr.fromAddress#</span></p>
</div>
    </td>

    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#subject#</span></p>
</div>
    </td>

<cfquery name="gettype" datasource="hermes">
select content_type, description from msg_content_type where content_type like binary '#content#'
</cfquery>


    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#gettype.description#</span></p>
</div>
    </td>

    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#Numberformat (spam_level, '____.__')#</span></p>
</div>
    </td>

<td align="center">
<a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=7&mid=#URLEncodedFormat(Trim(mail_id))#"><img id="Picture52" height="19" width="17" src="cid:hermesview" border="0" alt="View Message" title="View Message"></a>
    </td>

<td align="center">
<a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=8&mid=#URLEncodedFormat(Trim(mail_id))#"><img id="Picture52" height="19" width="17" src="cid:hermesrelease" border="0" alt="Release Message" title="Release Message"></a>
    </td>

 

</cfoutput>
        </tr>
      </table>
       </body>
    </HTML>

<cfmailparam
file="/opt/hermes/email/hermes_top_banner_email.png"
contentid="hermeslogo"
disposition="inline"
/>

<cfmailparam
file="/opt/hermes/email/view_icon.png"
contentid="hermesview"
disposition="inline"
/>

<cfmailparam
file="/opt/hermes/email/assign_icon.png"
contentid="hermesrelease"
disposition="inline"
/>

</cfmail>


</cfoutput>
</cfloop>

<!--- GENERATE REPORT FOR USERS WHO HAVE CHOSEN TO RECEIVE REPORT REGARDLESS ENDS HERE--->


<cfquery name="getrecipients" datasource="hermes">
SELECT users.email as rcptemail, user_settings.id as customid, user_settings.report_enabled, user_settings.report_frequency from user_settings LEFT JOIN users ON users.email = user_settings.email where user_settings.report_enabled = 'YES' and user_settings.report_frequency = '#frequency#' and users.email is not NULL
</cfquery>



<cfloop query="getrecipients">
<cfoutput>
<cfquery name="getrid" datasource="hermes">
select id as rcptid from maddr where email='#rcptemail#'
</cfquery>
#rcptemail#<br>

<cfquery name="getquarantine" datasource="hermes">
SELECT msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds from msgrcpt LEFT JOIN msgs ON msgs.mail_id = msgrcpt.mail_id where (msgrcpt.ds like binary 'B' or msgrcpt.ds like binary 'D') and msgrcpt.rid='#getrid.rcptid#' and msgs.time_iso between '#datenow# 00:00:00' and '#datenow# 23:59:59' group by msgrcpt.mail_id order by msgs.time_iso desc
</cfquery>

<cfif #getquarantine.recordcount# GTE 1>
<cfquery name="getpostmaster" datasource="hermes">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfmail from="#getpostmaster.value#" to="#TRIM(rcptemail)#" subject="[#rcptemail#] Hermes Secure Email Gateway Scheduled Quarantine Report" type="HTML" server="localhost" port="10026">
    <HTML>
       <head><title>Hermes Secure Mail Gateway Scheduled Quarantine Report</title>

       </head>
       <body>
           <!--- Style Tag in the Body, not Head, for Email --->

<style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; }
</style>


<table id="Table2" border="0" cellspacing="6" cellpadding="2" width="100%" style="height: 50px;">
  <tr style="height: 75px;">
    <td width="750" id="Cell9" style="background-color: rgb(45,103,228);">
      <p style="margin-bottom: 0px;"><img id="Picture1" height="75" width="750" src="cid:hermeslogo" vspace="0" hspace="0" align="top" border="0" alt="hermes_secure_mail_gateway" title="Hermes Secure Mail Gateway"></p>
    </td>
  </tr>
  <tr style="height: 96px;">
    <td id="Cell10">
      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12pt;"><b>Scheduled Quarantine Report for #rcptemail# for period #datenow2#</b><br><br> The listing below shows <b>#getquarantine.recordcount# messages</b> that the system has quarantined.<br><br>

If there are no messages listed, then the system did not quarantine any messages for the period listed above.<br><br>

If you wish to view a message, click on the View Msg button.<br><br>

If you wish to release a message to your mailbox, click the the Release Msg button. <br><br>

Additionally, click the links below to access the different sections of the User Console:

<cfquery name="getportal" datasource="hermes">
select value2 from parameters2 where parameter='console.host' and module='console'
</cfquery>

<ul>

<li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=3">Report Settings</a> - Clicking this link will direct you to the Report Settings where you can adjust the settings for this report.</li>
<li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=2">History and Archive</a> - Clicking this link will direct you to the Message History where you can search, view/download and release email messages to your mailbox.</li>
<li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=4">Sender Filters</a> - Clicking this link will direct you to the Sender Filters where you can create block/allow filters for outside email addresses.</li>
<li><a href="https://docs.deeztek.com/books/hermes-seg-user-guide/page/accessing-the-user-self-service-portal">Online Help</a> - Clicking this link will direct you to the Hermes SEG Online Help where you can read detailed instructions on how to use each part of the User Console</li>
</ul>
</span></p>


<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12pt;">
<b>Please note the system periodically purges oldest messages in order to conserve system resources</b></span></p>

    </td>
  </tr>
</table>


<hr id="HRRule7" width="100%" size="1">


<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">
    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Date/Time</span></b></p>
    </td>
   
   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">From</span></b></p>
    </td>

   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Subject</span></b></p>
    </td>

   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Type</span></b></p>
    </td>

   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Score</span></b></p>
    </td>

<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">View Msg</span></b></p>
    </td>

  <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Release Msg</span></b></p>
    </td>
    

  

    
  </tr>
<cfoutput query="getquarantine">

<cfset date = #DateFormat(time_iso, "mm/dd/yyyy")#>
<cfset time = #TimeFormat(time_iso, "HH:mm:ss")#>
  <tr style="height: 28px;">
    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#date# #time# </span></p>
</div>
    </td>
    

<cfquery name="getfromaddr" datasource="hermes">
SELECT email as fromAddress FROM maddr where id='#sid#'
</cfquery>

    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#getfromaddr.fromAddress#</span></p>
</div>
    </td>

    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#subject#</span></p>
</div>
    </td>

<cfquery name="gettype" datasource="hermes">
select content_type, description from msg_content_type where content_type like binary '#content#'
</cfquery>


    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#gettype.description#</span></p>
</div>
    </td>

    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#Numberformat (spam_level, '____.__')#</span></p>
</div>
    </td>

<td id="Cell1060">
<a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=7&mid=#URLEncodedFormat(Trim(mail_id))#"><img id="Picture52" height="19" width="17" src="cid:hermesview" border="0" alt="View Message" title="View Message"></a>
    </td>

<td id="Cell1060">
<a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=8&mid=#URLEncodedFormat(Trim(mail_id))#"><img id="Picture52" height="19" width="17" src="cid:hermesrelease" border="0" alt="Release Message" title="Release Message"></a>
    </td>


 

</cfoutput>
        </tr>
      </table>
       </body>
    </HTML>

<cfmailparam
file="/opt/hermes/email/hermes_top_banner_email.png"
contentid="hermeslogo"
disposition="inline"
/>

<cfmailparam
file="/opt/hermes/email/view_icon.png"
contentid="hermesview"
disposition="inline"
/>

<cfmailparam
file="/opt/hermes/email/assign_icon.png"
contentid="hermesrelease"
disposition="inline"
/>

</cfmail>

</cfif>
</cfoutput>
</cfloop>