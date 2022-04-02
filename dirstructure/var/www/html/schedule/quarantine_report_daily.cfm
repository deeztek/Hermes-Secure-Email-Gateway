<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula>.
--->


<cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH")#">
<cfset theDate=#DateFormat(DateAdd('d', -1, datenow),'yyyy-mm-dd')#>
<cfset datenow2=#DateFormat(theDate,"mm/dd/yyyy")#>

<!--- GENERATE REPORT FOR USERS WHO HAVE CHOSEN TO RECEIVE REPORT REGARDLESS STARTS HERE--->

<cfquery name="getrecipientsall" datasource="hermes">
SELECT users.email as rcptemail, user_settings.id as customid, user_settings.report_enabled, user_settings.report_frequency, user_settings.email from user_settings LEFT JOIN users ON users.email = user_settings.email where user_settings.report_enabled = 'ALL' and user_settings.report_frequency = '24' and users.email is not NULL
</cfquery>

<cfloop query="getrecipientsall">
<cfoutput>
<cfquery name="getrid" datasource="hermes">
select id as rcptid from maddr where email='#rcptemail#'
</cfquery>
#rcptemail#<br>

<cfquery name="getquarantineall" datasource="hermes">
SELECT msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds from msgrcpt LEFT JOIN msgs ON msgs.mail_id = msgrcpt.mail_id where (msgrcpt.ds like binary 'B' or msgrcpt.ds like binary 'D') and msgrcpt.rid='#getrid.rcptid#' and msgs.time_iso between '#theDate# 00:00:00' and '#theDate# 23:59:59' group by msgrcpt.mail_id order by msgs.time_iso desc
</cfquery>


<cfquery name="getpostmaster" datasource="hermes">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfmail from="#getpostmaster.value#" to="#TRIM(rcptemail)#" subject="[#rcptemail#] Hermes SEG Daily Quarantine Report" type="HTML" server="localhost" port="10026">
    <HTML>
       <head><title>Hermes SEG Daily Quarantine Report</title>

       </head>
       <body>
           <!--- Style Tag in the Body, not Head, for Email --->

<style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; }
</style>


<table id="Table2" border="0" cellspacing="6" cellpadding="2" width="100%" style="height: 50px;">
  <tr style="height: 75px;">
    <td style="background-color: rgb(255,255,255);">
      <p style="text-align: center; margin-bottom: 0px;"><img id="Picture1" src="cid:hermeslogo" vspace="0" hspace="0" align="top" border="0" alt="hermes_secure_mail_gateway" title="Hermes Secure Email Gateway"></p>
    </td>
  </tr>

  <hr></hr>

  <tr style="height: 96px;">
    <td>
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12pt;"><b>Daily Quarantine Report for #rcptemail# for period #datenow2#</b><br><br> The listing below shows <b>#getquarantineall.recordcount# messages</b> that the system has quarantined. <br><br>

If there are no messages listed, then the system did not quarantine any messages for the period listed above.</p>

<hr></hr>

<p style="text-align: left; margin-bottom: 0px;">
If you wish to view a message, click on the <b>View Msg</b> button.<br><br>

If you wish to release a message to your mailbox, click the the <b>Release Msg</b> button. <br><br>

Additionally, click the links below to access the different sections of the User Console:

<cfquery name="getportal" datasource="hermes">
select value2 from parameters2 where parameter='console.host' and module='console'
</cfquery>

<ul>

<li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=3">Report Settings</a> - Clicking this link will direct you to the Report Settings where you can adjust the settings for this report.</li>
<li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=2">Message History</a> - Clicking this link will direct you to Message History where you can search, view/download and release email messages to your mailbox.</li>
<li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=4">Sender Filters</a> - Clicking this link will direct you to the Sender Filters where you can create block/allow filters for outside email addresses.</li>
<li><a href="https://docs.deeztek.com/books/hermes-seg-user-guide/page/accessing-the-user-self-service-portal">Online Help</a> - Clicking this link will direct you to the Hermes SEG Online Help where you can read detailed instructions on how to use each part of the User Console</li>
</ul>
</p>



    </td>
  </tr>
</table>


<hr>


<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">
    <td align="center">
    <b>Date/Time</b>
    </td>
   
   <td align="center">
    <b>From</b>
    </td>

   <td align="center">
    <b>Subject</b>
    </td>

   <td align="center">
    <b>Type</b>
    </td>

   <td align="center">
  <b>Spam Score</b>
    </td>

   <td align="center">
  <b>View Msg</b>
    </td>

  <td align="center">
  <b>Release Msg</b>
    </td>
    

  

    
  </tr>
<cfoutput query="getquarantineall">

<cfset date = #DateFormat(time_iso, "mm/dd/yyyy")#>
<cfset time = #TimeFormat(time_iso, "HH:mm:ss")#>
  <tr style="height: 28px;">
    <td  align="center">
<div style="word-wrap: break-word;">
  #date# #time#
</div>
    </td>
    

<cfquery name="getfromaddr" datasource="hermes">
SELECT email as fromAddress FROM maddr where id='#sid#'
</cfquery>

    <td align="center">
<div style="word-wrap: break-word;">
  #getfromaddr.fromAddress#
</div>
    </td>

    <td align="center">
<div style="word-wrap: break-word;">
  #subject#
</div>
    </td>

<cfquery name="gettype" datasource="hermes">
select content_type, description from msg_content_type where content_type like binary '#content#'
</cfquery>


    <td align="center">
<div style="word-wrap: break-word;">
#gettype.description#
</div>
    </td>

    <td align="center">
<div style="word-wrap: break-word;">
#Numberformat (spam_level, '____.__')#
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

<!--- GENERATE REPORT FOR USERS WHO HAVE CHOSEN TO RECEIVE REPORT IF QURANTINE EXIST STARTS HERE --->


<cfquery name="getrecipients" datasource="hermes">
SELECT users.email as rcptemail, user_settings.id as customid, user_settings.report_enabled, user_settings.report_frequency from user_settings LEFT JOIN users ON users.email = user_settings.email where user_settings.report_enabled = 'YES' and user_settings.report_frequency = '24' and users.email is not NULL
</cfquery>



<cfloop query="getrecipients">
<cfoutput>
<cfquery name="getrid" datasource="hermes">
select id as rcptid from maddr where email='#rcptemail#'
</cfquery>
#rcptemail#<br>

<cfquery name="getquarantine" datasource="hermes">
SELECT msgs.sid, msgs.spam_level, msgs.mail_id, msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds from msgrcpt LEFT JOIN msgs ON msgs.mail_id = msgrcpt.mail_id where (msgrcpt.ds like binary 'B' or msgrcpt.ds like binary 'D') and msgrcpt.rid='#getrid.rcptid#' and msgs.time_iso between '#theDate# 00:00:00' and '#theDate# 23:59:59' group by msgrcpt.mail_id order by msgs.time_iso desc
</cfquery>

<cfif #getquarantine.recordcount# GTE 1>
<cfquery name="getpostmaster" datasource="hermes">
select parameter, value from system_settings where parameter='postmaster'
</cfquery>

<cfmail from="#getpostmaster.value#" to="#TRIM(rcptemail)#" subject="[#rcptemail#] Hermes SEG Daily Quarantine Report" type="HTML" server="localhost" port="10026">
    <HTML>
       <head><title>Hermes Secure Mail Gateway Daily Quarantine Report</title>

       </head>
       <body>
           <!--- Style Tag in the Body, not Head, for Email --->

<style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; }
</style>


<table id="Table2" border="0" cellspacing="6" cellpadding="2" width="100%" style="height: 50px;">
  <tr style="height: 75px;">
    <td style="background-color: rgb(255,255,255);">
      <p style="text-align: center; margin-bottom: 0px;"><img id="Picture1" src="cid:hermeslogo" vspace="0" hspace="0" align="top" border="0" alt="hermes_secure_mail_gateway" title="Hermes Secure Mail Gateway"></p>
    </td>
  </tr>

  <hr></hr>

  <tr style="height: 96px;">
    <td id="Cell10">

      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12pt;"><b>Daily Quarantine Report for #rcptemail# for period #datenow2#</b><br><br> The listing below shows <b>#getquarantineall.recordcount# messages</b> that the system has quarantined. </p><br><br>


<hr></hr>

<p style="text-align: left; margin-bottom: 0px;">
If you wish to view a message, click on the <b>View Msg</b> button.<br><br>

If you wish to release a message to your mailbox, click the the <b>Release Msg</b> button. <br><br>

Additionally, click the links below to access the different sections of the User Console:

<cfquery name="getportal" datasource="hermes">
select value2 from parameters2 where parameter='console.host' and module='console'
</cfquery>

<ul>

  <li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=3">Report Settings</a> - Clicking this link will direct you to the Report Settings where you can adjust the settings for this report.</li>
  <li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=2">Message History</a> - Clicking this link will direct you to Message History where you can search, view/download and release email messages to your mailbox.</li>
  <li><a href="https://#getportal.value2#/user-auth/?uid=#customid#&dest=4">Sender Filters</a> - Clicking this link will direct you to the Sender Filters where you can create block/allow filters for outside email addresses.</li>
  <li><a href="https://docs.deeztek.com/books/hermes-seg-user-guide/page/accessing-the-user-self-service-portal">Online Help</a> - Clicking this link will direct you to the Hermes SEG Online Help where you can read detailed instructions on how to use each part of the User Console</li>
  </ul>
</ul>
</p>


    </td>
  </tr>
</table>


<hr>

<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">
    <td align="center">
    <b>Date/Time</b>
    </td>
   
   <td align="center">
    <b>From</b>
    </td>

   <td align="center">
    <b>Subject</b>
    </td>

   <td align="center">
  <b>Type</b>
    </td>

   <td align="center">
    <b>Spam Score</b>
    </td>

<td align="center">
    <b>View Msg</b>
    </td>

  <td align="center">
  <b>Release Msg</b>
    </td>
    

  

    
  </tr>
<cfoutput query="getquarantine">

<cfset date = #DateFormat(time_iso, "mm/dd/yyyy")#>
<cfset time = #TimeFormat(time_iso, "HH:mm:ss")#>
  <tr style="height: 28px;">
    <td align="center">
<div style="word-wrap: break-word;">
#date# #time# 
</div>
    </td>
    

<cfquery name="getfromaddr" datasource="hermes">
SELECT email as fromAddress FROM maddr where id='#sid#'
</cfquery>

    <td align="center">
<div style="word-wrap: break-word;">
  #getfromaddr.fromAddress#
</div>
    </td>

    <td align="center">
<div style="word-wrap: break-word;">
    #subject#
</div>
    </td>

<cfquery name="gettype" datasource="hermes">
select content_type, description from msg_content_type where content_type like binary '#content#'
</cfquery>


    <td align="center">
<div style="word-wrap: break-word;">
#gettype.description#
</div>
    </td>

    <td align="center">
<div style="word-wrap: break-word;">
#Numberformat (spam_level, '____.__')#
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

<!--- GENERATE REPORT FOR USERS WHO HAVE CHOSEN TO RECEIVE REPORT IF QURANTINE EXIST STARTS HERE --->