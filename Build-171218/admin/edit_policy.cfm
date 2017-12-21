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
<title>Edit Policy</title>
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
              <td height="1013" width="988"><cfparam name = "m" default = "0"> 
<cfparam name = "step" default = "0">

<cfparam name = "action" default = "view"> 
<cfif IsDefined("form.action") is "True">
<cfset show_action = form.action>
</cfif>

<cfif #action# is "view">
<cfif IsDefined("URL.ID")>
<cfquery name="getpolicysettings" datasource="#datasource#">
select * from policy where id='#url.id#'
</cfquery>
<cfif #getpolicysettings.recordcount# LT 1>
<cflocation url="error.cfm">
</cfif>
<cfelseif NOT IsDefined("URL.ID")>
<cflocation url="error.cfm">
</cfif>
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 1013px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="12" height="21"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="448"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="2" width="506" id="Text291" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Edit SVF Policy</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="6"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="863"></td>
                          <td colspan="3" width="954"><cfif #action# is "view">
<cfparam name = "show_policy_name" default = "#getpolicysettings.policy_name#"> 
<cfelseif #action# is "edit">
<cfif IsDefined("form.policy_name") is "True">
<cfset show_policy_name = form.policy_name>
</cfif>
</cfif>

<cfif #action# is "view">
<cfparam name = "show_virus_lover" default = "#getpolicysettings.virus_lover#">
<cfelseif #action# is "edit"> 
<cfif IsDefined("form.virus_lover") is "True">
<cfset show_virus_lover = form.virus_lover>
</cfif> 
</cfif>

<cfif #action# is "view">
<cfparam name = "show_spam_lover" default = "#getpolicysettings.spam_lover#">
<cfelseif #action# is "edit">
<cfif IsDefined("form.spam_lover") is "True">
<cfset show_spam_lover = form.spam_lover>
</cfif>
</cfif>

<cfif #action# is "view">
<cfparam name = "show_banned_files_lover" default = "#getpolicysettings.banned_files_lover#">
<cfelseif #action# is "edit">
<cfif IsDefined("form.banned_files_lover") is "True">
<cfset show_banned_files_lover = form.banned_files_lover>
</cfif>
</cfif> 

<cfif #action# is "view">
<cfparam name = "show_bad_header_lover" default = "#getpolicysettings.bad_header_lover#">
<cfelseif #action# is "edit"> 
<cfif IsDefined("form.bad_header_lover") is "True">
<cfset show_bad_header_lover = form.bad_header_lover>
</cfif>
</cfif>

<cfif #action# is "view">
<cfparam name = "show_bypass_virus_checks" default = "#getpolicysettings.bypass_virus_checks#">
<cfelseif #action# is "edit">
<cfif IsDefined("form.bypass_virus_checks") is "True">
<cfset show_bypass_virus_checks = form.bypass_virus_checks>
</cfif>
</cfif>
 

<cfif #action# is "view">
<cfparam name = "show_bypass_spam_checks" default = "#getpolicysettings.bypass_spam_checks#">
<cfelseif #action# is "edit">
<cfif IsDefined("form.bypass_spam_checks") is "True">
<cfset show_bypass_spam_checks = form.bypass_spam_checks>
</cfif>
</cfif> 
 
<cfif #action# is "view">
<cfparam name = "show_bypass_banned_checks" default = "#getpolicysettings.bypass_banned_checks#">
<cfelseif #action# is "edit"> 
<cfif IsDefined("form.bypass_banned_checks") is "True">
<cfset show_bypass_banned_checks = form.bypass_banned_checks>
</cfif>
</cfif>


<cfif #action# is "view">
<cfparam name = "show_bypass_header_checks" default = "#getpolicysettings.bypass_header_checks#">
<cfelseif #action# is "edit"> 
<cfif IsDefined("form.bypass_header_checks") is "True">
<cfset show_bypass_header_checks = form.bypass_header_checks>
</cfif>
</cfif>
 
<cfif #action# is "view">
<cfparam name = "show_spam_tag_level" default = "#getpolicysettings.spam_tag_level#">
<cfelseif #action# is "edit">
<cfif IsDefined("form.spam_tag_level") is "True">
<cfset show_spam_tag_level = form.spam_tag_level>
</cfif>
</cfif>

<cfif #action# is "view">
<cfparam name = "show_spam_tag2_level" default = "#getpolicysettings.spam_tag2_level#">
<cfelseif #action# is "edit">
<cfif IsDefined("form.spam_tag2_level") is "True">
<cfset show_spam_tag2_level = form.spam_tag2_level>
</cfif>
</cfif>

<cfif #action# is "view">
<cfparam name = "show_spam_kill_level" default = "#getpolicysettings.spam_kill_level#">
<cfelseif #action# is "edit">
<cfif IsDefined("form.spam_kill_level") is "True">
<cfset show_spam_kill_level = form.spam_kill_level>
</cfif>
</cfif>


<cfif #action# is "view">
<cfparam name = "notify_banned" default = "#getpolicysettings.warnbannedrecip#">
<cfelseif #action# is "edit">
<cfif IsDefined("form.notify_banned") is "True">
<cfset notify_banned = form.notify_banned>
</cfif>
</cfif>

<cfif #action# is "view">
<cfparam name = "notify_virus" default = "#getpolicysettings.warnvirusrecip#">
<cfelseif #action# is "edit">
<cfif IsDefined("form.notify_virus") is "True">
<cfset notify_virus = form.notify_virus>
</cfif>
</cfif>

<cfif #action# is "view">
<cfparam name = "notify_header" default = "#getpolicysettings.warnbadhrecip#">
<cfelseif #action# is "edit">
<cfif IsDefined("form.notify_header") is "True">
<cfset notify_header = form.notify_header>
</cfif>
</cfif>

<cfif #action# is "view">
<cfparam name = "show_banned_rulenames" default = "#getpolicysettings.banned_rulenames#">
<cfelseif #action# is "edit">
<cfif IsDefined("form.banned_rulenames") is "True">
<cfset show_banned_rulenames = form.banned_rulenames>
</cfif>
</cfif>

<cfif #action# is "edit">

<cfif #form.policy_name# is "">
<cfset step=0>
<cfset m=1>
<cfelseif #form.policy_name# is not "">
<cfset step=1>
</cfif>

<cfoutput>Policy name: #form.policy_name#</cfoutput>

<cfif step is "1">
<cfif REFind("[^_a-zA-Z0-9-@. ]",form.policy_name) gt 0>
<cfset step=0>
<cfset m=2>
<cfelse>
<cfset step=2>
</cfif>
</cfif>

<cfif step is "2">
<cfquery name="checkexists" datasource="#datasource#">
select policy_name from policy where policy_name = '#form.policy_name#' and id <> '#url.id#'
</cfquery>
<cfif #checkexists.recordcount# GTE 1>
<cfset step=0>
<cfset m=3>
<cfelseif #checkexists.recordcount# LT 1>
<cfset step=3>
</cfif>
</cfif>


<cfif step is "3">
<cfif #form.spam_tag2_level# is "">
<cfset step=0>
<cfset m=5>
<cfelseif #form.spam_tag2_level# is not "">
<cfset step=4>
</cfif>
</cfif>

<cfif step is "4">
<cfif IsValid("float", form.spam_tag2_level)>
<cfset step=5>
<cfelseif NOT IsValid("float", form.spam_tag2_level)>
<cfset step=0>
<cfset m=8>
</cfif>
</cfif>

<cfif step is "5">
<cfif #form.spam_tag2_level# GT 999>
<cfset step=0>
<cfset m=7>
<cfelseif #form.spam_tag2_level# LT -999>
<cfset step=0>
<cfset m=6>
<cfelse>
<cfset step=6>
</cfif>
</cfif>



<cfif step is "6">
<cfif #form.spam_kill_level# is "">
<cfset step=0>
<cfset m=9>
<cfelseif #form.spam_kill_level# is not "">
<cfset step=7>
</cfif>
</cfif>

<cfif step is "7">
<cfif IsValid("float", form.spam_kill_level)>
<cfset step=8>
<cfelseif NOT IsValid("float", form.spam_kill_level)>
<cfset step=0>
<cfset m=12>
</cfif>
</cfif>

<cfif step is "8">
<cfif #form.spam_kill_level# GT 999>
<cfset step=0>
<cfset m=11>
<cfelseif #form.spam_kill_level# LT -999>
<cfset step=0>
<cfset m=10>
<cfelse>
<cfset step=9>
</cfif>
</cfif>

<cfif step is "9">
<cfif #form.banned_rulenames# is "">
<cfset step=0>
<cfset m=13>
<cfelseif #form.banned_rulenames# is not "">
<cfset step=10>
</cfif>
</cfif>

<cfif step is "10">

<cfquery name="update" datasource="#datasource#">
update policy set
policy_name='#form.policy_name#', 
virus_lover='#form.virus_lover#', 
spam_lover='#form.spam_lover#',
banned_files_lover='#form.banned_files_lover#',
bad_header_lover='#form.bad_header_lover#',
bypass_virus_checks='#form.bypass_virus_checks#',
bypass_spam_checks='#form.bypass_spam_checks#',
bypass_banned_checks='#form.bypass_banned_checks#',
bypass_header_checks='#form.bypass_header_checks#',
spam_tag2_level='#form.spam_tag2_level#',
spam_kill_level='#form.spam_kill_level#',
banned_rulenames = '#form.banned_rulenames#',
warnbannedrecip = '#form.notify_banned#',
warnvirusrecip = '#form.notify_virus#',
warnbadhrecip = '#form.notify_header#'
where id='#url.id#'
</cfquery>

<cfquery name="update2" datasource="#datasource#">
update spam_policies set
policy_name='#form.policy_name#'
where policy_id='#url.id#'
</cfquery>

<cfset step=0>
<cfset m=14>


</cfif>


</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion11" style="height: 863px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="<cfoutput>edit_policy.cfm?id=#url.id#</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="954">
                                          <table id="Table70" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 817px;">
                                            <tr style="height: 14px;">
                                              <td width="950" id="Cell405">
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
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Accept Bad Headers?</span></b></span></p>
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
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Bypass Virus Checks? <span style="font-weight: normal;">(If set to Yes, the Accept Viruses setting above will not be effective)</span></span></b></p>
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
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Bypass Spam Checks? <span style="font-weight: normal;">(If set to Yes, the Accept Spam setting above will not be effective)</span></span></b></p>
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
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Bypass Banned Files Checks? <span style="font-weight: normal;">(If set to Yes, the Accept Banned Files setting above will not be effective)</span></span></b></p>
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
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Bypass Bad Header Checks? <span style="font-weight: normal;">(If set to Yes, the Accept Bad Headers setting above will not be effective)</span></span></b></p>
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
                                              <td id="Cell1024">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Notify Recipient of Banned File Quarantine<span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(51,51,51);">? </span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell1025">
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
                                              <td id="Cell1030">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Notify Recipient of Virus Quarantine<span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(51,51,51);">?</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell1031">
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
                                              <td id="Cell1037">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Notify Recipient of Bad Header Quarantine<span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(51,51,51);">?</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell1038">
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
                                              <td id="Cell1021">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">File Rule</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1022">
                                                <table width="555" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfquery name="getfilerules" datasource="#datasource#">
select distinct(rule_name) from file_rule_components where rule_name <> '#show_banned_rulenames#'
</cfquery>

<select name="banned_rulenames" style="height: 24px;">
<cfoutput>
<option value="#show_banned_rulenames#" selected="selected">#show_banned_rulenames#</option>
</cfoutput>
<cfoutput query="getfilerules">
<option value="#rule_name#">#rule_name#</option>
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="954">
                                      <tr valign="top" align="left">
                                        <td width="954" height="6"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="954" id="Text296" class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Policy Name cannot be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Policy Name contains invalid characters. Allowed characters are letters, numbers spaces, dashes and underscores</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Policy Name already exists. Please enter a new Policy Name</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Send Quarantined Spam Messages to field must be a vaid e-mail address</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Score Required for E-mail  to be tagged as Spam field cannot be  blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Score Required for E-mail  to be tagged as Spam field cannot be  less than -999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Score Required for E-mail  to be tagged as Spam field cannot be  more than 999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Score Required for E-mail  to be tagged as Spam field must be a valid number</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Score Required before e-mail is Quarantined field must not be blank</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Score Required before e-mail is Quarantined field must not be less than -999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Score Required before e-mail is Quarantined field cannot be greater than 999</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Score Required before e-mail is Quarantined field must be a valid number</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m# is "13">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;You must select a File Rule before continuing</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m# is "14">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Policy Updated. If you are finished making changes, click the button below to return to Spam/Virus/File Policies</span></i></b></p>
</cfoutput>
</cfif>


&nbsp;</p>
                                        </td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td height="6"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="954" id="Text293" class="TextObject">
                                          <p style="text-align: center; margin-bottom: 0px;"><table id="Table75" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 22px;">
  <tr style="height: 24px;">
   <td width="700" id="Cell435">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
     <tr>
      <td align="center"><input type="submit" id="FormsButton1" name="FormsButton1" value="Save Changes" style="height: 24px; width: 120px;" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();"></input></td>
     </tr>
    </table>
   </td>
  </tr>
 </table>&nbsp;</p>
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
                          <td colspan="5" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="4" valign="middle" width="955"><hr id="HRRule28" width="955" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="46"></td>
                          <td colspan="2" width="953">

                            <table border="0" cellspacing="0" cellpadding="0" width="953" id="LayoutRegion18" style="height: 46px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="953">
                                        <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 28px;">
                                          <tr style="height: 28px;">
                                            <td width="953" id="Cell1023">
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
                          <td></td>
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