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
<title>Reset Portal Password</title>
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
              <td height="422" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 422px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="11" height="23"></td>
                          <td width="2"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="449"></td>
                          <td width="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="2" width="506" id="Text291" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Reset External Recipient Portal Password</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="234"></td>
                          <td colspan="4" width="957"><cfparam name = "m" default = "0">

<CFPARAM NAME="theID" DEFAULT="">
<cfif IsDefined("url.id") is "True">
<cfif url.id is not "">
<cfset theID = url.id>
</cfif>
<cfelseif NOT IsDefined("url.id")>
<cflocation url="error.cfm" addToken = "no">
</cfif>

<CFPARAM NAME="StartRow" DEFAULT="1">
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<CFPARAM NAME="DisplayRows" DEFAULT="10">
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>

<CFPARAM NAME="show" DEFAULT="">
<cfif IsDefined("url.show") is "True">
<cfif url.show is not "">
<cfset show = url.show>
</cfif>
<cfelseif NOT IsDefined("url.show")>
<cflocation url="error.cfm" addToken = "no">
</cfif>

<CFPARAM NAME="filter" DEFAULT="">
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfquery name="getrecipientdetails" datasource="#datasource#">
select * from external_recipients where id='#theID#' 
</cfquery>

<cfif #getrecipientdetails.recordcount# GTE 1>

<cfif #getrecipientdetails.pdf# is not "1">
<cflocation url="error.cfm" addToken = "no">
<cfelseif #getrecipientdetails.pdf# is "1">
<cfif #getrecipientdetails.pdf_mode# is not "random">
<cflocation url="error.cfm" addToken = "no">
</cfif>
</cfif>

<cfelseif #getrecipientdetails.recordcount# LT 1>
<cflocation url="error.cfm" addToken = "no">

<!-- /CFIF FOR GETRECIPIENTDETAILS.RECORDCOUNT -->
</cfif>

<cfparam name = "step" default = "0"> 

<cfparam name = "action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfparam name = "show_password1" default = ""> 
<cfif IsDefined("form.password1") is "True">
<cfif form.password1 is not "">
<cfset show_password1 = form.password1>
</cfif></cfif> 

<cfparam name = "show_password2" default = ""> 
<cfif IsDefined("form.password2") is "True">
<cfif form.password2 is not "">
<cfset show_password2 = form.password2>
</cfif></cfif> 

<cfif #action# is "edit">

<cfif #show_password1# is "">
<cfset step=0>
<cfset m=2>
<cfelseif #show_password1# is not "">
<cfif NOT ( len(show_password1) GTE 8)>
<cfset step=0>
<cfset m=3>
<cfelse>
<cfif REFind("[a-z]",show_password1) gte 1 and REFind("[A-Z]",show_password1) gte 1 and REFind("[0-9]",show_password1) gte 1 and
 REFind("[?!$@*()%^]",show_password1) gte 1>
<cfset step=1>
<cfelse>
<cfset step=0>
<cfset m=8>
</cfif>
</cfif>
</cfif>

<cfif step is "1" and #show_password2# is "">
<cfset step=0>
<cfset m=4>
<cfelseif step is "1" and #show_password2# is not "">
<cfset step=2>
</cfif>



<cfif step is "2" and #show_password1# is not "" and #show_password2# is not "">
<cfset compare_password = Compare(#show_password1#, #show_password2#)>
<cfif #compare_password# is "1">
<cfset m=5>
<cfset step=0>
<cfelseif #compare_password# is "-1">
<cfset m=5>
<cfset step=0>
<cfelseif #compare_password# is "0">
<cfset step=3>
</cfif>
</cfif>

<cfif step is "3">

<cfquery name="userrandom" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 8
</cfquery>

<cfquery name="inserttrans" datasource="#datasource#" result="stResult">
insert into salt
(salt)
values
('<cfoutput query="userrandom">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="gettrans" datasource="#datasource#">
select salt as userrandom2 from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfset customtrans3=#gettrans.userrandom2#>

<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>



<cffile action="read" file="/opt/hermes/scripts/reset_portal_password1.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_reset_portal_password1.sh"
    output = "#REReplace("#temp#","THE-PASSWORD","#show_password1#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_reset_portal_password1.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_reset_portal_password1.sh"
    output = "#REReplace("#temp#","THE-CODE","#customtrans3#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_reset_portal_password1.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_reset_portal_password1.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_reset_portal_password1.sh">
 

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_password" variable="encodedpassword">


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_password">


<cffile action="read" file="/opt/hermes/scripts/reset_portal_password2.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_reset_portal_password2.sh"
    output = "#REReplace("#temp#","THE-EMAIL","#getrecipientdetails.email#","ALL")#" addnewline="no">
    
<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_reset_portal_password2.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_reset_portal_password2.sh"
    output = "#REReplace("#temp#","THE-ENCODED-PASSWORD","#encodedpassword#","ALL")#" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_reset_portal_password2.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_reset_portal_password2.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_reset_portal_password2.sh">

<cfoutput>
<cflocation url="external_encryption_users.cfm?action=portalpassword&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#" addToken = "no">
</cfoutput>
</cfif>

</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion11" style="height: 234px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="<cfoutput>reset_portal_password.cfm?id=#theID#&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0" width="957">
                                      <tr valign="top" align="left">
                                        <td width="957" id="Text374" class="TextObject">
                                          <p style="margin-bottom: 0px;"><span style="font-size: 12px; font-weight: normal;">If an external recipient has lost his/her password to access the Secure Email Portal, use the form below to reset it. Passwords must be at least 8 characters long, they must include both upper and lower case letter, numbers and special characters. The new password should be given to the recipient via secure means. <b><u>Unencrypted voice calls and texts are NOT considered secure.</u></b></span></p>
                                          <ol>
                                          </ol>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="4"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table9" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 128px;">
                                            <tr style="height: 14px;">
                                              <td width="957" id="Cell1032">
                                                <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Recipient</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <cfoutput>
                                              <td id="Cell60">
                                                <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 14px; color: rgb(51,51,51);"></span>
                                                  <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td><cfoutput><input type="text" id="FormsEditField4" name="recipient" size="30" maxlength="30" disabled="disabled" style="width: 236px; white-space: pre;" value="#getrecipientdetails.email#"></cfoutput></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                </cfoutput>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1034">
                                                  <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">New Password&nbsp; </span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                <cfoutput>
                                                <td id="Cell62">
                                                  <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 14px; color: rgb(51,51,51);"></span>
                                                    <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td><input type="password" id="FormsEditField5" name="password1" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre"></td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                  </cfoutput>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell1036">
                                                    <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Verify New Password&nbsp; </span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <cfoutput>
                                                  <td id="Cell64">
                                                    <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 14px; color: rgb(51,51,51);"></span>
                                                      <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td><input type="password" id="FormsEditField6" name="password2" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre"></td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    </cfoutput>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell84">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell90">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="205" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="changepass" value="Reset Password" style="height: 24px; width: 205px;">
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
                                              <td width="957" height="10"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="957" id="Text185" class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the existing password field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the new password field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the new password must be at least 8 characters</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must verify the new password</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the new passwords you entered do not match. please try again.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Portal Password Reset.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the old password you used is not correct. Please try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the password does not meet complexity requirements. Passwords must be at least 8 characters, they must contain both upper and lower case letters, numbers and any of the special characters ?!$@*()%^</span></i></b></p>
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
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="6" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="30"></td>
                                <td colspan="4" valign="middle" width="957"><hr id="HRRule11" width="957" size="1"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="6" height="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="3" height="40"></td>
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
                                              <form name="apply_settings" action="<cfoutput>external_encryption_users.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&show=#show#&filter=#filter#</cfoutput>" method="post">
                                                <table id="Table191" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="956" id="Cell1031">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="360" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to External Recipients Encryption" style="height: 24px; width: 357px;">
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