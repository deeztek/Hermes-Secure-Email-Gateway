<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

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
    -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Add Internal User Encryption</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<script language="JavaScript">
<!--

// function to load the calendar window.
function ShowCalendar(FormName, FieldName) {
  window.open("calendar.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=500,height=300");
}

//-->
</script>

<script type="text/javascript" language="javascript">// <![CDATA[
function checkAll(formname, checktoggle)
{
  var checkboxes = new Array();
  checkboxes = document[formname].getElementsByTagName('input');
 
  for (var i=0; i<checkboxes.length; i++)  {
    if (checkboxes[i].type == 'checkbox')   {
      checkboxes[i].checked = checktoggle;
    }
  }
}
// ]]></script>


<style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; }
</style>



<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(192,192,192); background-repeat: repeat; background-attachment: scroll; margin: 0px;" class="nof-centerBody">
<!-- DO NOT MOVE! The following AllWebMenus linking code section must always be placed right AFTER the BODY tag-->
<!-- ******** BEGIN ALLWEBMENUS CODE FOR hermes_seg_menu2 ******** -->
<script type='text/javascript'>var MenuLinkedBy='AllWebMenus [2]',awmMenuName='hermes_seg_menu2',awmBN='FUS';awmAltUrl='';</script><script charset='UTF-8' src='./hermes_seg_menu2.js' language='JavaScript1.2' type='text/javascript'></script><script type='text/javascript'>awmBuildMenu();</script>
<!-- ******** END ALLWEBMENUS CODE FOR hermes_seg_menu2 ******** -->
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="988">
            <tr valign="top" align="left">
              <td height="10"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="131" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion34" style="background-image: url('./top_blue_3.png'); height: 131px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="709">
                        <tr valign="top" align="left">
                          <td width="45" height="92"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="13"></td>
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="525" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 525px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="10" height="13"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="450"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="2" width="506" id="Text373" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Edit Internal Recipient Encryption</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="337"></td>
                          <td colspan="4" width="957"><cfparam name = "m" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "m3" default = "0">
<cfparam name = "step" default = "0">
<cfparam name="url.id" type="numeric" default=0>

<CFPARAM NAME="StartRow" DEFAULT="">
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<CFPARAM NAME="DisplayRows" DEFAULT="">
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>

<CFPARAM NAME="show" DEFAULT="">
<cfif IsDefined("url.show") is "True">
<cfif url.show is not "">
<cfset show = url.show>
</cfif></cfif>

<CFPARAM NAME="filter" DEFAULT="">
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfquery name="getrecipientdetails" datasource="#datasource#">
select * from recipients where 
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>
 
<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfparam name = "show_smime_certificate_name" default = "#getrecipientdetails.smime_certificate_name#"> 

<cfparam name = "show_pdf_enabled" default = "#getrecipientdetails.pdf_enabled#"> 
<cfif IsDefined("form.pdf_enabled") is "True">
<cfif form.pdf_enabled is not "">
<cfset show_pdf_enabled = form.pdf_enabled>
</cfif></cfif>

<cfparam name = "show_smime_enabled" default = "#getrecipientdetails.smime_enabled#"> 
<cfif IsDefined("form.smime_enabled") is "True">
<cfif form.smime_enabled is not "">
<cfset show_smime_enabled = form.smime_enabled>
</cfif></cfif> 

<cfparam name = "show_pgp_enabled" default = "#getrecipientdetails.pgp_enabled#"> 
<cfif IsDefined("form.pgp_enabled") is "True">
<cfif form.pgp_enabled is not "">
<cfset show_pgp_enabled = form.pgp_enabled>
</cfif></cfif> 



<cfparam name = "show_sign" default = "#getrecipientdetails.digital_sign#"> 
<cfif IsDefined("form.sign") is "True">
<cfif form.sign is not "">
<cfset show_sign = form.sign>
</cfif></cfif>



<cfif #action# is "edit">
<cfset rcpt_name = rereplace(getrecipientdetails.recipient, "[^A-Za-z0-9]+", "", "all")>

<cfquery name="customtrans" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 8
</cfquery>

<cfquery name="inserttrans" datasource="#datasource#" result="stResult">
insert into salt
(salt)
values
('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="gettrans" datasource="#datasource#">
select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfset customtrans3=#gettrans.customtrans2#>

<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfif #getrecipientdetails.configured# is "2">
<cfquery name="update" datasource="#datasource#">
update recipients
set 
configured='1',
digital_sign='#show_sign#',
smime_enabled='#show_smime_enabled#',
pdf_enabled='#show_pdf_enabled#',
pgp_enabled='#show_pgp_enabled#'
where
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>





<!--- CREATE RECIPIENT IN DJIGZO --->
<cffile action="read" file="/opt/hermes/scripts/create_intrecipient.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_create_intrecipient.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#getrecipientdetails.recipient#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_create_intrecipient.sh" variable="temp">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_create_intrecipient.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_create_intrecipient.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_create_intrecipient.sh">


<cfquery name="updatedjigzo" datasource="djigzo">
update cm_users
set 
cm_locality='internal'
where
cm_email = '#getrecipientdetails.recipient#'
</cfquery>

<cfelseif #getrecipientdetails.configured# is "1">
<cfquery name="update" datasource="#datasource#">
update recipients
set 
digital_sign='#show_sign#',
smime_enabled='#show_smime_enabled#',
pdf_enabled='#show_pdf_enabled#',
pgp_enabled='#show_pgp_enabled#'
where
id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfquery name="updatedjigzo" datasource="djigzo">
update cm_users
set 
cm_locality='internal'
where
cm_email = '#getrecipientdetails.recipient#'
</cfquery>

</cfif>
    
<!--- CONFIGURE SIGN WHEN ENCRYPT IN DJIGZO --->    
<cffile action="read" file="/opt/hermes/scripts/configure_intrecipient_sign.sh" variable="temp">

<cfif #show_sign# is "1">
<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh"
    output = "#REReplace("#temp#","THE-SIGN","false","ALL")#" addnewline="no">
    
    
<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#getrecipientdetails.recipient#","ALL")#" addnewline="no">
    
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh">
  
</cfif>

<cfif #show_sign# is "2">
<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh"
    output = "#REReplace("#temp#","THE-SIGN","true","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#getrecipientdetails.recipient#","ALL")#" addnewline="no">
    
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_configure_intrecipient_sign.sh">
 
</cfif>
    

 


<!--- CONFIGURE PDF ENCRYPTION IN DJIGZO --->
<cfif #show_pdf_enabled# is "1">

<cffile action="read" file="/opt/hermes/scripts/enable_intrecipient_pdf.sh" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_intrecipient_pdf.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#getrecipientdetails.recipient#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_enable_intrecipient_pdf.sh" variable="temp">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_enable_intrecipient_pdf.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/scripts/#customtrans3#_enable_intrecipient_pdf.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_enable_intrecipient_pdf.sh">

</cfif>
    
<cfif #show_pdf_enabled# is "2">

<cffile action="read" file="/opt/hermes/scripts/disable_intrecipient_pdf.sh" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_disable_intrecipient_pdf.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#getrecipientdetails.recipient#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_disable_intrecipient_pdf.sh" variable="temp">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_disable_intrecipient_pdf.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/scripts/#customtrans3#_disable_intrecipient_pdf.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_disable_intrecipient_pdf.sh">    

    
</cfif>


<!--- CONFIGURE SMIME_ENCRYPTION IN DJIGZO --->
<cfif #show_smime_enabled# is "1">

<cffile action="read" file="/opt/hermes/scripts/enable_intrecipient_smime_nocert.sh" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_intrecipient_smime_nocert.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#getrecipientdetails.recipient#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_enable_intrecipient_smime_nocert.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/scripts/#customtrans3#_enable_intrecipient_smime_nocert.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

 
<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_enable_intrecipient_smime_nocert.sh">
   
</cfif>

<cfif #show_smime_enabled# is "2">

<cffile action="read" file="/opt/hermes/scripts/disable_intrecipient_smime.sh" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_disable_intrecipient_smime.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#getrecipientdetails.recipient#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_disable_intrecipient_smime.sh" variable="temp">

   
  
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_disable_intrecipient_smime.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/scripts/#customtrans3#_disable_intrecipient_smime.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

 
<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_disable_intrecipient_smime.sh">

    
</cfif>

<!--- CONFIGURE PGP_ENCRYPTION IN DJIGZO --->
<cfif #show_pgp_enabled# is "1">

<cffile action="read" file="/opt/hermes/scripts/enable_intrecipient_pgp_nocert.sh" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_enable_intrecipient_pgp_nocert.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#getrecipientdetails.recipient#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_enable_intrecipient_pgp_nocert.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/scripts/#customtrans3#_enable_intrecipient_pgp_nocert.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

 
<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_enable_intrecipient_pgp_nocert.sh">
   
</cfif>

<cfif #show_pgp_enabled# is "2">

<cffile action="read" file="/opt/hermes/scripts/disable_intrecipient_pgp.sh" variable="temp">


<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_disable_intrecipient_pgp.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#getrecipientdetails.recipient#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_disable_intrecipient_pgp.sh" variable="temp">

   
  
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_disable_intrecipient_pgp.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/scripts/#customtrans3#_disable_intrecipient_pgp.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

 
<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_disable_intrecipient_pgp.sh">

    
</cfif>

<cfif #show_smime_enabled# is "1">
<cfquery name="getcerts" datasource="#datasource#">
select * from recipient_certificates where user_id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getcerts.recordcount# LT 1>
<cfset m2=1>
</cfif>
</cfif>

<cfif #show_pgp_enabled# is "1">
<cfquery name="getkeys" datasource="#datasource#">
select * from recipient_keystores where user_id = <cfqueryparam value = #url.id# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #getkeys.recordcount# LT 1>
<cfset m3=1>
</cfif>
</cfif>

<cfset m=1>

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>


<cfquery name="dropusers" datasource="#datasource#">
drop table users
</cfquery>

<cfquery name="createusers" datasource="#datasource#">
CREATE TABLE users LIKE recipients
</cfquery>

<cfquery name="copyusers" datasource="#datasource#">
INSERT INTO users SELECT * FROM recipients
</cfquery>

<cfquery name="alterusers" datasource="#datasource#">
alter table users change recipient email VARBINARY(255)
</cfquery>

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>

</cfif>





 

                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion17" style="height: 337px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="<cfoutput>add_internal_user_encryption.cfm?id=#url.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="595">
                                          <table id="Table138" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 137px;">
                                            <tr style="height: 14px;">
                                              <td width="595" id="Cell973">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Internal Recipient</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell972">
                                                <table width="541" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfoutput>
<input type="text" id="FormsEditField30" name="recipient" size="45" maxlength="255" disabled="disabled" style="width: 356px;
 white-space: pre;" value="#getrecipientdetails.recipient#">
</cfoutput>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell901">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">PDF Encryption</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell902">
                                                <table width="535" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table133" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 29px;">
                                                        <tr style="height: 17px;">
                                                          <td width="46" id="Cell797">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_pdf_enabled# is "1">
<cfoutput>
<input type="radio" checked="checked" name="pdf_enabled" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_pdf_enabled# is not "1">
<cfoutput>
<input type="radio" name="pdf_enabled" value="1" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>







&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="489" id="Cell798">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell799">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_pdf_enabled# is "2">
<cfoutput>
<input type="radio" checked="checked" name="pdf_enabled" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_pdf_enabled# is not "2">
<cfoutput>
<input type="radio" name="pdf_enabled" value="2" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell800">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell903">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">S/MIME Encryption</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell904">
                                                <table width="532" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table134" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 12px;">
                                                        <tr style="height: 17px;">
                                                          <td width="45" id="Cell803">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_smime_enabled# is "1">
<cfoutput>
<input type="radio" checked="checked" name="smime_enabled" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_smime_enabled# is not "1">
<cfoutput>
<input type="radio" name="smime_enabled" value="1" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="487" id="Cell804">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell934">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_smime_enabled# is "2">
<cfoutput>
<input type="radio" checked="checked" name="smime_enabled" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_smime_enabled# is not "2">
<cfoutput>
<input type="radio" name="smime_enabled" value="2" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell935">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell905">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">S/MIME Encryption Mode <span style="font-weight: normal;">(Not implemented)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell906">
                                                <table width="532" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table137" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 5px;">
                                                        <tr style="height: 17px;">
                                                          <td width="45" id="Cell818">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_smime_enabled# is "1">
<input type="radio" checked="checked" name="smime_mode" value="2" style="height: 13px; width: 13px;" disabled="disabled">
<cfelseif #show_smime_enabled# is not "1">
<input type="radio" checked="checked" name="smime_mode" value="2" style="height: 13px; width: 13px;" disabled="disabled">
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="487" id="Cell819">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Normal</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell820">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><input type="radio" name="smime_mode" value="2" style="height: 13px; width: 13px;" disabled="disabled">






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell821">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Paranoid</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell968">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Digital Signature <span style="font-weight: normal;">(Applies only if S/MIME Certificate is present)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell969">
                                                <table width="539" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table105" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 12px;">
                                                        <tr style="height: 17px;">
                                                          <td width="48" id="Cell634">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_sign# is "1">
<cfoutput>
<input type="radio" checked="checked" name="sign" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_sign# is not "1">
<cfoutput>
<input type="radio" name="sign" value="1" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="491" id="Cell635">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Digitally Sign ALL Outgoing Messages</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell636">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_sign# is "2">
<cfoutput>
<input type="radio" checked="checked" name="sign" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_sign# is not "2">
<cfoutput>
<input type="radio" name="sign" value="2" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell637">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Digitally Sign ONLY Encrypted Outgoing Messages</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell970">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PGP Encryption</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell971">
                                                <table width="532" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table148" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 12px;">
                                                        <tr style="height: 17px;">
                                                          <td width="45" id="Cell1019">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_pgp_enabled# is "1">
<cfoutput>
<input type="radio" checked="checked" name="pgp_enabled" value="1" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_pgp_enabled# is not "1">
<cfoutput>
<input type="radio" name="pgp_enabled" value="1" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="487" id="Cell1020">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1021">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_pgp_enabled# is "2">
<cfoutput>
<input type="radio" checked="checked" name="pgp_enabled" value="2" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_pgp_enabled# is not "2">
<cfoutput>
<input type="radio" name="pgp_enabled" value="2" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1022">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="16"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table136" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="957" id="Cell815">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="277" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Saving and Applying Changes, please wait...';this.form.submit();" name="savechanges" value="Save and Apply Changes" style="height: 24px; width: 275px;">
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="957">
                                      <tr valign="top" align="left">
                                        <td width="957" height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957" id="Text386" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes saved and applied</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;WARNING: The system has detected that you have enabled S/MIME encryption without a S/MIME certificate present for this recipient. S/MIME encryption will not work until a certificate is created or imported for this recipient</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;WARNING: The system has detected that you have enabled PGP encryption without a PGP Keystore present for this recipient. PGP encryption will not work until a PGP Keystore is created or imported for this recipient</span></i></b></p>
</cfoutput>
</cfif>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </form>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="2" valign="middle" width="955"><hr id="HRRule15" width="955" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="40"></td>
                          <td colspan="3" width="956">

                            <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="956">
                                        <form name="apply_settings" action="<cfoutput>internal_encryption_users.cfm?id=#url.id#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#</cfoutput>" method="post">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="956" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="360" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Internal Recipients Encryption" style="height: 24px; width: 357px;">
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="49" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion33" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="981">
                        <tr valign="top" align="left">
                          <td width="981" height="12"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;"><cfset theYear=#DateFormat(Now(),"yyyy")#>
<cfquery name="getversion" datasource="#datasource#">
SELECT value from system_settings where parameter = 'version_no'
</cfquery>
<cfoutput>
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway #session.edition# #getversion.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>&nbsp;</p>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </div>
</body>
</html>
   