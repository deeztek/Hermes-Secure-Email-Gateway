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
<title>View Policy</title>
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
              <td height="955" width="988"><cfif IsDefined("URL.ID")>
<cfquery name="getpolicysettings" datasource="#datasource#">
select * from policy where id='#url.id#'
</cfquery>
<cfif #getpolicysettings.recordcount# LT 1>
<cflocation url="error.cfm">
</cfif>
<cfelseif NOT IsDefined("URL.ID")>
<cflocation url="error.cfm">
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 955px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="963">
                        <tr valign="top" align="left">
                          <td width="10" height="21"></td>
                          <td width="5"></td>
                          <td width="506"></td>
                          <td width="441"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text291" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">View SVF Policy</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="817"></td>
                          <td colspan="3" width="948"><cfparam name = "m" default = ""> 
<cfif IsDefined("url.m") is "True">
<cfif url.m is not "">
<cfset m = url.m>
</cfif></cfif> 

<cfparam name = "show_policy_name" default = "#getpolicysettings.policy_name#"> 
<cfif IsDefined("form.policy_name") is "True">
<cfif form.policy_name is not "">
<cfset show_policy_name = form.policy_name>
</cfif></cfif> 

<cfparam name = "show_virus_lover" default = "#getpolicysettings.virus_lover#"> 
<cfif IsDefined("form.virus_lover") is "True">
<cfif form.virus_lover is not "">
<cfset show_virus_lover = form.virus_lover>
</cfif></cfif> 

<cfparam name = "show_spam_lover" default = "#getpolicysettings.spam_lover#">
<cfif IsDefined("form.spam_lover") is "True">
<cfif form.spam_lover is not "">
<cfset show_spam_lover = form.spam_lover>
</cfif></cfif> 

<cfparam name = "show_banned_files_lover" default = "#getpolicysettings.banned_files_lover#">
<cfif IsDefined("form.banned_files_lover") is "True">
<cfif form.banned_files_lover is not "">
<cfset show_banned_files_loverr = form.banned_files_lover>
</cfif></cfif> 

<cfparam name = "show_bad_header_lover" default = "#getpolicysettings.bad_header_lover#"> 
<cfif IsDefined("form.bad_header_lover") is "True">
<cfif form.bad_header_lover is not "">
<cfset show_bad_header_lover = form.bad_header_lover>
</cfif></cfif> 

<cfparam name = "show_bypass_virus_checks" default = "#getpolicysettings.bypass_virus_checks#">
<cfif IsDefined("form.bypass_virus_checks") is "True">
<cfif form.bypass_virus_checks is not "">
<cfset show_bypass_virus_checks = form.bypass_virus_checks>
</cfif></cfif> 

<cfparam name = "show_bypass_spam_checks" default = "#getpolicysettings.bypass_spam_checks#">
<cfif IsDefined("form.bypass_spam_checks") is "True">
<cfif form.bypass_spam_checks is not "">
<cfset show_bypass_spam_checks = form.bypass_spam_checks>
</cfif></cfif> 
 
<cfparam name = "show_bypass_banned_checks" default = "#getpolicysettings.bypass_banned_checks#"> 
<cfif IsDefined("form.bypass_banned_checks") is "True">
<cfif form.bypass_banned_checks is not "">
<cfset show_bypass_banned_checks = form.bypass_banned_checks>
</cfif></cfif> 

<cfparam name = "show_bypass_header_checks" default = "#getpolicysettings.bypass_header_checks#"> 
<cfif IsDefined("form.bypass_header_checks") is "True">
<cfif form.bypass_header_checks is not "">
<cfset show_bypass_header_checks = form.bypass_header_checks>
</cfif></cfif> 
 

<cfparam name = "notify_banned" default = "#getpolicysettings.warnbannedrecip#">
<cfif IsDefined("form.notify_banned") is "True">
<cfif form.notify_banned is not "">
<cfset notify_banned = form.notify_banned>
</cfif>
</cfif>


<cfparam name = "notify_virus" default = "#getpolicysettings.warnvirusrecip#">
<cfif IsDefined("form.notify_virus") is "True">
<cfif form.notify_virus is not "">
<cfset notify_virus = form.notify_virus>
</cfif>
</cfif>


<cfparam name = "notify_header" default = "#getpolicysettings.warnbadhrecip#">
<cfif IsDefined("form.notify_header") is "True">
<cfif form.notify_header is not "">
<cfset notify_header = form.notify_header>
</cfif>
</cfif>

<cfparam name = "show_spam_tag_level" default = "#getpolicysettings.spam_tag_level#">
<cfif IsDefined("form.spam_tag_level") is "True">
<cfif form.spam_tag_level is not "">
<cfset show_spam_tag_level = form.spam_tag_level>
</cfif></cfif>

<cfparam name = "show_spam_tag2_level" default = "#getpolicysettings.spam_tag2_level#">
<cfif IsDefined("form.spam_tag2_level") is "True">
<cfif form.spam_tag2_level is not "">
<cfset show_spam_tag2_level = form.spam_tag2_level>
</cfif></cfif>


<cfparam name = "show_spam_kill_level" default = "#getpolicysettings.spam_kill_level#">
<cfif IsDefined("form.spam_kill_level") is "True">
<cfif form.spam_kill_level is not "">
<cfset show_spam_kill_level = form.spam_kill_level>
</cfif></cfif>

<cfparam name = "show_banned_rulenames" default = "#getpolicysettings.banned_rulenames#">
<cfif IsDefined("form.banned_rulenames") is "True">
<cfif form.banned_rulenames is not "">
<cfset show_banned_rulenames = form.banned_rulenames>
</cfif></cfif>


                            <table border="0" cellspacing="0" cellpadding="0" width="948" id="LayoutRegion11" style="height: 817px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="948">
                                          <table id="Table70" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 751px;">
                                            <tr style="height: 14px;">
                                              <td width="944" id="Cell405">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Policy Name</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell404">
                                                <table width="256" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td><cfoutput><input type="text" id="FormsEditField21" name="policy_name" size="32" maxlength="32" style="width: 252px; white-space: pre;" value="#show_policy_name#"></cfoutput></td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell341">
                                                <p style="margin-bottom: 0px;"><b><span style="color: rgb(51,51,51);"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Accept Viruses?</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell386">
                                                <table width="608" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table87" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="54" id="Cell500">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_virus_lover# is "Y">
<cfoutput>
<input type="radio" checked="checked" name="virus_lover" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_virus_lover# is not "Y">
<cfoutput>
<input type="radio" name="virus_lover" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="554" id="Cell501">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell502">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_virus_lover# is "N">
<cfoutput>
<input type="radio" checked="checked" name="virus_lover" value="N" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_virus_lover# is not "N">
<cfoutput>
<input type="radio" name="virus_lover" value="N" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell503">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No <span style="color: rgb(255,0,0);">(Default)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell398">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Accept Spam?</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell400">
                                                <table width="608" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table88" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="54" id="Cell504">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_spam_lover# is "Y">
<cfoutput>
<input type="radio" checked="checked" name="spam_lover" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_spam_lover# is not "Y">
<cfoutput>
<input type="radio" name="spam_lover" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="554" id="Cell505">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell506">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_spam_lover# is "N">
<cfoutput>
<input type="radio" checked="checked" name="spam_lover" value="N" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_spam_lover# is not "N">
<cfoutput>
<input type="radio" name="spam_lover" value="N" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell507">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No <span style="color: rgb(255,0,0);">(Default)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell406">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Accept Banned Files?</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell409">
                                                <table width="608" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table89" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="54" id="Cell508">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_banned_files_lover# is "Y">
<cfoutput>
<input type="radio" checked="checked" name="banned_files_lover" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_banned_files_lover# is not "Y">
<cfoutput>
<input type="radio" name="banned_files_lover" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="554" id="Cell509">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell510">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_banned_files_lover# is "N">
<cfoutput>
<input type="radio" checked="checked" name="banned_files_lover" value="N" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_banned_files_lover# is not "N">
<cfoutput>
<input type="radio" name="banned_files_lover" value="N" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell511">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No <span style="color: rgb(255,0,0);">(Default)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell410">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Accept Bad E-mail Headers?</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell408">
                                                <table width="609" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="53" id="Cell512">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_bad_header_lover# is "Y">
<cfoutput>
<input type="radio" checked="checked" name="bad_header_lover" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_bad_header_lover# is not "Y">
<cfoutput>
<input type="radio" name="bad_header_lover" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="556" id="Cell513">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell514">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_bad_header_lover# is "N">
<cfoutput>
<input type="radio" checked="checked" name="bad_header_lover" value="N" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_bad_header_lover# is not "N">
<cfoutput>
<input type="radio" name="bad_header_lover" value="N" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell515">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No <span style="color: rgb(255,0,0);">(Default)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell478">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Bypass Virus Scanning?</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell480">
                                                <table width="610" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table82" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="53" id="Cell469">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_bypass_virus_checks# is "Y">
<cfoutput>
<input type="radio" checked="checked" name="bypass_virus_checks" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_bypass_virus_checks# is not "Y">
<cfoutput>
<input type="radio" name="bypass_virus_checks" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="557" id="Cell470">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell471">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_bypass_virus_checks# is "N">
<cfoutput>
<input type="radio" checked="checked" name="bypass_virus_checks" value="N" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_bypass_virus_checks# is not "N">
<cfoutput>
<input type="radio" name="bypass_virus_checks" value="N" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell472">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No <span style="color: rgb(255,0,0);">(Default)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell491">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Bypass Spam Checking?</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell492">
                                                <table width="608" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table83" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 21px;">
                                                          <td width="53" id="Cell473">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_bypass_spam_checks# is "Y">
<cfoutput>
<input type="radio" checked="checked" name="bypass_spam_checks" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_bypass_spam_checks# is not "Y">
<cfoutput>
<input type="radio" name="bypass_spam_checks" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="555" id="Cell474">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 21px;">
                                                          <td id="Cell475">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_bypass_spam_checks# is "N">
<cfoutput>
<input type="radio" checked="checked" name="bypass_spam_checks" value="N" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_bypass_spam_checks# is not "N">
<cfoutput>
<input type="radio" name="bypass_spam_checks" value="N" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell476">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No <span style="color: rgb(255,0,0);">(Default)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell637">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Bypass Banned Files Checking?</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell638">
                                                <table width="606" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table106" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="53" id="Cell643">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_bypass_banned_checks# is "Y">
<cfoutput>
<input type="radio" checked="checked" name="bypass_banned_checks" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_bypass_banned_checks# is not "Y">
<cfoutput>
<input type="radio" name="bypass_banned_checks" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="553" id="Cell644">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell645">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_bypass_banned_checks# is "N">
<cfoutput>
<input type="radio" checked="checked" name="bypass_banned_checks" value="N" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_bypass_banned_checks# is not "N">
<cfoutput>
<input type="radio" name="bypass_banned_checks" value="N" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell646">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No <span style="color: rgb(255,0,0);">(Default)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell517">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Bypass Bad E-mail Header Checking?</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell516">
                                                <table width="607" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table91" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="52" id="Cell523">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_bypass_header_checks# is "Y">
<cfoutput>
<input type="radio" checked="checked" name="bypass_header_checks" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_bypass_header_checks# is not "Y">
<cfoutput>
<input type="radio" name="bypass_header_checks" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="555" id="Cell524">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell525">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #show_bypass_header_checks# is "N">
<cfoutput>
<input type="radio" checked="checked" name="bypass_header_checks" value="N" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #show_bypass_header_checks# is not "N">
<cfoutput>
<input type="radio" name="bypass_header_checks" value="N" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell526">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No <span style="color: rgb(255,0,0);">(Default)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1043">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Notify Recipient of Banned File Quarantine<span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(51,51,51);">? </span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell1047">
                                                <table width="607" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table185" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="52" id="Cell1026">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #notify_banned# is "Y">
<cfoutput>
<input type="radio" checked="checked" name="notify_banned" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #notify_banned# is not "Y">
<cfoutput>
<input type="radio" name="notify_banned" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="555" id="Cell1027">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell1028">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #notify_banned# is "N">
<cfoutput>
<input type="radio" checked="checked" name="notify_banned" value="N" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #notify_banned# is not "N">
<cfoutput>
<input type="radio" name="notify_banned" value="N" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1029">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No <span style="color: rgb(255,0,0);">(Default)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1048">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Notify Recipient of Virus Quarantine<span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(51,51,51);">?</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell1046">
                                                <table width="607" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table186" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="52" id="Cell1032">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #notify_virus# is "Y">
<cfoutput>
<input type="radio" checked="checked" name="notify_virus" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #notify_virus# is not "Y">
<cfoutput>
<input type="radio" name="notify_virus" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="555" id="Cell1033">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell1034">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #notify_virus# is "N">
<cfoutput>
<input type="radio" checked="checked" name="notify_virus" value="N" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #notify_virus# is not "N">
<cfoutput>
<input type="radio" name="notify_virus" value="N" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1035">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No <span style="color: rgb(255,0,0);">(Default)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1045">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Notify Recipient of Bad Header Quarantine<span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(51,51,51);">?</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell1044">
                                                <table width="607" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table187" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 19px;">
                                                          <td width="52" id="Cell1039">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #notify_header# is "Y">
<cfoutput>
<input type="radio" checked="checked" name="notify_header" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #notify_header# is not "Y">
<cfoutput>
<input type="radio" name="notify_header" value="Y" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="555" id="Cell1040">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell1041">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><cfif #notify_header# is "N">
<cfoutput>
<input type="radio" checked="checked" name="notify_header" value="N" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #notify_header# is not "N">
<cfoutput>
<input type="radio" name="notify_header" value="N" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1042">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No <span style="color: rgb(255,0,0);">(Default)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell550">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Score Required for E-mail&nbsp; to be tagged as Spam&nbsp; <span style="font-weight: normal;">(Default 5 - Range is -999 to 999)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell549">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td><cfoutput><input type="text" id="FormsEditField22" name="spam_tag2_level" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_spam_tag2_level#"></cfoutput></td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell555">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Score Required before e-mail is Quarantined<span style="font-weight: normal;"> (Default 12 - Range is -999 to 999)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell548">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td><cfoutput><input type="text" id="FormsEditField23" name="spam_kill_level" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="#show_spam_kill_level#"></cfoutput></td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1023">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">File Rule</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1024">
                                                <table width="555" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><select name="banned_rulenames" style="height: 24px;">
<cfoutput>
<option value="#show_banned_rulenames#" selected="selected">#show_banned_rulenames#</option>
</cfoutput>
</select>





&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
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
                        <tr valign="top" align="left">
                          <td colspan="5" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="2" valign="middle" width="947"><hr id="HRRule29" width="947" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="46"></td>
                          <td colspan="4" width="953">

                            <table border="0" cellspacing="0" cellpadding="0" width="953" id="LayoutRegion18" style="height: 46px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="953">
                                        <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 28px;">
                                          <tr style="height: 28px;">
                                            <td width="953" id="Cell1025">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="302" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="text-align: center; margin-bottom: 0px;"><form name="apply_settings" action="spam_policies.cfm" method="post">
  


  <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="635" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Spam/Virus/File Policies" style="height: 24px; width: 357px;">


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