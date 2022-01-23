<!---
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
    --->
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Create Recipient2</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<cfset datasource="hermes">

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
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder_1.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="492" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 492px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="964">
                        <tr valign="top" align="left">
                          <td width="15" height="18"></td>
                          <td width="506"></td>
                          <td width="443"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="506" id="Text369" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Configure External Recipient PDF Encryption</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="357"></td>
                          <td colspan="2" width="949"><cfif NOT IsDefined('session.ext_recipient')>
<cflocation url="create_recipient.cfm">
<cfelseif IsDefined('session.ext_recipient')>
<cfif #session.ext_recipient# is "">
<cflocation url="create_recipient.cfm">
</cfif>
</cfif>

<cfparam name = "m" default = "0">
<cfparam name = "step" default = "0">

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
</cfif></cfif>

<CFPARAM NAME="filter" DEFAULT="">
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>
 

<cfparam name = "action" default = ""> 
<cfif IsDefined("form.action") is "True">
<cfif form.action is not "">
<cfset action = form.action>
</cfif></cfif>

<cfparam name = "show_pdf_password_length" default = "20"> 
<cfif IsDefined("form.pdf_password_length") is "True">
<cfif form.pdf_password_length is not "">
<cfset show_pdf_password_length = form.pdf_password_length>
</cfif> 
</cfif>

<cfparam name = "show_pdf_mode" default = "random"> 
<cfif IsDefined("form.pdf_mode") is "True">
<cfif form.pdf_mode is not "">
<cfset show_pdf_mode = form.pdf_mode>
</cfif> 
</cfif>

<cfparam name = "show_pdf_password" default = ""> 
<cfif IsDefined("form.pdf_password") is "True">
<cfif form.pdf_password is not "">
<cfset show_pdf_password = form.pdf_password>
</cfif> 
</cfif>

<cfparam name = "show_pdf_password2" default = ""> 
<cfif IsDefined("form.pdf_password2") is "True">
<cfif form.pdf_password2 is not "">
<cfset show_pdf_password2 = form.pdf_password2>
</cfif> 
</cfif>

<cfparam name = "show_pdf_password_age" default = "60"> 
<cfif IsDefined("form.pdf_password_age") is "True">
<cfif form.pdf_password_age is not "">
<cfset show_pdf_password_age = form.pdf_password_age>
</cfif> 
</cfif>



<cfif #action# is "edit">


<cfif #show_pdf_mode# is "static">
<cfset step=2>
<cfelseif #show_pdf_mode# is "random">
<cfset step=7>
<cfelseif #show_pdf_mode# is "backtosender">
<cfset step=6>
</cfif>

<cfif step is "2" and #show_pdf_mode# is "static">
<cfif #show_pdf_password# is "">
<cfset step=0>
<cfset m=1>
<cfelseif #show_pdf_password# is not "">
<cfif NOT (len(show_pdf_password) GTE 8)>
<cfset step=0>
<cfset m=2>
<cfelse>
<cfset step=3>
</cfif>
</cfif>
</cfif>

<cfif step is "3" and #show_pdf_mode# is "static">
<cfif REFind("[a-z]",show_pdf_password) gte 1 and REFind("[A-Z]",show_pdf_password) gte 1 and REFind("[0-9]",show_pdf_password) gte 1 and
 REFind("[?!$@*()%^]",show_pdf_password) gte 1>
<cfset step=4> 
<cfelse>
<cfset step=0>
<cfset m=2>
</cfif>
</cfif>

<cfif step is "4" and #show_pdf_password2# is "">
<cfset step=0>
<cfset m=7>
<cfelseif step is "4" and #show_pdf_password2# is not "">
<cfset step=5>
</cfif>

<cfif step is "5" and #show_pdf_password# is not "" and #show_pdf_password2# is not "">
<cfset compare_password = Compare(#show_pdf_password#, #show_pdf_password2#)>
<cfif #compare_password# is "1">
<cfset m=8>
<cfset step=0>
<cfelseif #compare_password# is "-1">
<cfset m=8>
<cfset step=0>
<cfelseif #compare_password# is "0">
<cfset step=7>
</cfif>
</cfif>


<cfif step is "6" and #show_pdf_mode# is "backtosender">
<cfif #show_pdf_password_age# is not "">
<cfif isValid("integer", show_pdf_password_age)>
<cfif #show_pdf_password_age# LTE 240 AND #show_pdf_password_age# GTE 15>
<cfset step=7>
<cfelseif #show_pdf_password_age# GT 240>
<cfset step=0>
<cfset m=3>
<cfelseif #show_pdf_password_age# LT 15>
<cfset step=0>
<cfset m=3>
</cfif>
<cfelseif NOT isValid("integer", show_pdf_password_age)>
<cfset step=0>
<cfset m=4>
</cfif>
<cfelseif #show_pdf_password_age# is "">
<cfset step=0>
<cfset m=5>
</cfif>
</cfif>


<cfif step is "7">
<cfset session.pdf_mode=#show_pdf_mode#>
<cfif #show_pdf_mode# is "static">
<cfset session.pdf_password="#show_pdf_password#">
</cfif>
<cfif #show_pdf_mode# is "backtosender">
<cfset session.pdf_password_age="#show_pdf_password_age#">
<cfset session.pdf_password_length="#show_pdf_password_length#">
</cfif>
<cfoutput>
<cflocation url="create_recipient4.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter#&show=#show#">
</cfoutput>
</cfif>

</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="949" id="LayoutRegion17" style="height: 357px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="949">
                                        <form name="Table132FORM" action="" method="post">
                                          <table id="Table132" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 122px;">
                                            <tr style="height: 14px;">
                                              <td width="945" id="Cell795">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">E-Mail Address</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 26px;">
                                              <td id="Cell796">
                                                <table width="617" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table133" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 26px;">
                                                        <tr style="height: 26px;">
                                                          <td width="617" id="Cell797">
                                                            <table width="360" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td><cfoutput><input type="text" id="FormsEditField24" name="user" size="45" maxlength="45" disabled="disabled" style="width: 356px; white-space: pre;" value="#session.ext_recipient#"></cfoutput></td>
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
                                            <tr style="height: 17px;">
                                              <td id="Cell798">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);"></span>
                                                  <table width="616" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table134" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 13px;">
                                                          <tr style="height: 14px;">
                                                            <td width="616" id="Cell799">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Select PDF Encryption Type</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  </b>&nbsp;</td>
                                              </tr>
                                              <tr style="height: 55px;">
                                                <td id="Cell801">
                                                  <table width="923" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table135" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 55px;">
                                                          <tr style="height: 17px;">
                                                            <td width="76" id="Cell802">
                                                              <table width="50" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_pdf_mode# is "random">
<cfoutput>
<input type="radio" checked="checked" name="pdf_mode" value="random" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #show_pdf_mode# is not "random">
<cfoutput>
<input type="radio" name="pdf_mode" value="random" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
</cfif>
&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="847" id="Cell803">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Random Generated PDF Password through Secure E-mail Portal <span style="color: rgb(51,51,51);">(Recommended)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell804">
                                                              <table width="50" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_pdf_mode# is "backtosender">
<cfoutput>
<input type="radio" checked="checked" name="pdf_mode" value="backtosender" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
<cfelseif #show_pdf_mode# is not "backtosender">
<cfoutput>
<input type="radio" name="pdf_mode" value="backtosender" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell805">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Random Generated PDF Password Sent Back to Sender<span style="color: rgb(51,51,51);"> </span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell633">
                                                              <table width="50" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_pdf_mode# is "static">
<cfoutput>
<input type="radio" checked="checked" name="pdf_mode" value="static" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_pdf_mode# is not "static">
<cfoutput>
<input type="radio" name="pdf_mode" value="static" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell634">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Specified PDF Password</span></b></p>
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
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="3"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="949">
                                          <form name="Table136FORM" action="" method="post">
                                            <input type="hidden" name="action" value="edit"><input type="hidden" name="pdf_mode" value="<cfoutput>#show_pdf_mode#</cfoutput>">
                                            <table id="Table136" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 151px;">
                                              <tr style="height: 14px;">
                                                <td width="949" id="Cell808">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PDF Password Age in Minutes <span style="font-weight: normal;">(Ex: 60 = 1 Hour. Required when Back to Sender is selected. 15 Minutes Min)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                <td id="Cell809">
                                                  <table width="360" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td class="TextObject">
                                                        <p style="margin-bottom: 0px;"><cfif #show_pdf_mode# is "backtosender">
<cfoutput>
<input type="text" id="FormsEditField25" name="pdf_password_age" size="45" maxlength="45" style="width: 356px; white-space: pre;" value="#show_pdf_password_age#">
</cfoutput>
<cfelse>
<cfoutput>
<input type="text" id="FormsEditField25" name="pdf_password_age" size="45" maxlength="45" style="width: 356px; white-space: pre;" value="#show_pdf_password_age#" disabled="disabled">
</cfoutput>
</cfif>&nbsp;</p>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell810">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PDF Password Length <span style="font-weight: normal;">(Takes Effect Only when Back to Sender is selected)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 36px;">
                                                <td id="Cell811">
                                                  <table width="924" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table105" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 36px;">
                                                          <tr style="height: 17px;">
                                                            <td width="78" id="Cell644">
                                                              <table width="50" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_pdf_mode# is "backtosender">
<cfif #show_pdf_password_length# is "20">
<cfoutput>
<input type="radio" checked="checked" name="pdf_password_length" value="20" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_pdf_password_length# is not "20">
<cfoutput>
<input type="radio" name="pdf_password_length" value="20" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
<cfelse>
<cfif #show_pdf_password_length# is "20">
<cfoutput>
<input type="radio" checked="checked" name="pdf_password_length" value="20" style="height: 13px; width: 13px;" disabled="disabled">
</cfoutput>
<cfelseif #show_pdf_password_length# is not "20">
<cfoutput>
<input type="radio" name="pdf_password_length" value="20" style="height: 13px; width: 13px;" disabled="disabled">
</cfoutput>
</cfif>
</cfif>
&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="846" id="Cell645">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">160-Bits <span style="color: rgb(51,51,51);">(Recommended)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell646">
                                                              <table width="50" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #show_pdf_password_length# is "16">
<cfoutput>
<input type="radio" checked="checked" name="pdf_password_length" value="16" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_pdf_password_length# is not "16">
<cfoutput>
<input type="radio" name="pdf_password_length" value="16" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell647">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">128-bits<span style="color: rgb(51,51,51);"> </span></span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell812">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PDF Password <span style="font-weight: normal;">(Required if Specified PDF Password selected. 8 characters, letters, numbers &amp; special characters)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                <td id="Cell813">
                                                  <table width="360" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td class="TextObject">
                                                        <p style="margin-bottom: 0px;"><cfif #show_pdf_mode# is "static">
<cfoutput>
<input type="password" id="FormsEditField26" name="pdf_password" size="45" maxlength="45" style="width: 356px; white-space: pre;" value="#show_pdf_password#">
</cfoutput>
<cfelse>
<cfoutput>
<input type="password" id="FormsEditField26" name="pdf_password" size="45" maxlength="45" style="width: 356px; white-space: pre;" value="#show_pdf_password#" disabled="disabled">
</cfoutput>

</cfif>&nbsp;</p>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1018">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Verify PDF Password</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                <td id="Cell814">
                                                  <table width="360" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td class="TextObject">
                                                        <p style="margin-bottom: 0px;"><cfif #show_pdf_mode# is "static">
<cfoutput>
<input type="password" id="FormsEditField26" name="pdf_password2" size="45" maxlength="45" style="width: 356px; white-space: pre;" value="#show_pdf_password2#">
</cfoutput>
<cfelse>
<cfoutput>
<input type="password" id="FormsEditField26" name="pdf_password2" size="45" maxlength="45" style="width: 356px; white-space: pre;" value="#show_pdf_password2#" disabled="disabled">
</cfoutput>

</cfif>&nbsp;</p>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 17px;">
                                                <td id="Cell1017">
                                                  <p style="margin-bottom: 0px;">&nbsp;</p>
                                                </td>
                                              </tr>
                                              <tr style="height: 17px;">
                                                <td id="Cell815">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center">
                                                        <table width="360" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply" style="height: 24px; width: 357px;">
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="949">
                                      <tr valign="top" align="left">
                                        <td width="949" height="23"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="949" id="Text386" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must specify a PDF password</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PDF password must be 8 characters or more, must contain letters, numbers and special characters</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PDF password age must be between 15 and 240 minutes (4 Hours)</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PDF password age must be a numeric value between 15 and 240</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PDF password age must not be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select a PDF Encryption type</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the verify PDF Password field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PDF Passwords you entered do not match</span></i></b></p>
</cfoutput>
</cfif>

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
<cfquery name="getbuild" datasource="#datasource#">
SELECT value from system_settings where parameter = 'build_no'
</cfquery>
<cfoutput>
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway #session.edition# Version:#getversion.value# Build:#getbuild.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>
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
    </div>
  </body>
  </html>
     