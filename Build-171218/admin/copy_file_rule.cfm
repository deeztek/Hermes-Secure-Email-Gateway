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
<title>Copy File Rule</title>
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
              <td height="552" width="988"><cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">

<cfparam name = "step" default = "0"> 

<cfparam name = "m3" default = "0"> 
<cfif IsDefined("url.m3") is "True">
<cfif url.m3 is not "">
<cfset m3 = url.m3>
</cfif></cfif>

<cfparam name = "template" default = "copy"> 

<cfparam name = "type" default = "ban"> 
<cfif IsDefined("form.type") is "True">
<cfif form.type is not "">
<cfset show_type = form.type>
</cfif></cfif> 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion26" style="background-image: url('./middle_988.png'); height: 552px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="13" height="14"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="446"></td>
                          <td width="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text351" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Copy File Rule</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="338"></td>
                          <td colspan="3" width="953">





                            <table border="0" cellspacing="0" cellpadding="0" width="953" id="LayoutRegion5" style="height: 338px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="953">
                                    <tr valign="top" align="left">
                                      <td height="215" width="953">
                                        <form name="LayoutRegion10FORM" action="edit_rule.cfm" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0" width="953">
                                            <tr valign="top" align="left">
                                              <td width="953" id="Text456" class="TextObject">
                                                <p style="text-align: justify; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><span style="font-size: 12px;">Select File Type from the drop-down list below, select the Action to take and then click the ADD button. Add as many File Types as you need along with their associated actions. Once finished adding the File Types, enter a name for the rule you are creating on the bottom of the page and click ADD RULE button. If you make a mistake, click on the CANCEL ALL button below. File rules are processed from the top down fashion and once a match is found for a particular file type the assigned action is taken and processing of the rule stops. So the order the File Types and assigned Actions appear in a rule is important. For instance, if you wish to ban (.exe) Executable file types but you want to allow them within a (.zip) Zip Archive, you would add file type (.zip) Zip Archive first with an Allow action and then add&nbsp; (.exe) Executable file types with a Ban action. </span></span></p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="472">
                                            <tr valign="top" align="left">
                                              <td width="472" height="9"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="472" id="Text423" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">File Type</span></p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="953">
                                            <tr valign="top" align="left">
                                              <td width="953" height="2"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td height="21" width="953" id="Text403" class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfquery name="getexthigh" datasource="#datasource#">
select * from files where type = 'EXT-HIGH' order by description ASC
</cfquery>

<cfquery name="getext" datasource="#datasource#">
select * from files where type = 'EXT' order by description ASC
</cfquery>

<cfquery name="getfilehigh" datasource="#datasource#">
select * from files where type = 'FILE-HIGH' order by description ASC
</cfquery>

<cfquery name="getfile" datasource="#datasource#">
select * from files where type = 'FILE' order by description ASC
</cfquery>

<cfquery name="getmimehigh" datasource="#datasource#">
select * from files where type = 'MIME-HIGH' order by description ASC
</cfquery>

<cfquery name="getmime" datasource="#datasource#">
select * from files where type = 'MIME' order by description ASC
</cfquery>

<cfquery name="getother" datasource="#datasource#">
select * from files where type = 'OTHER' order by description ASC
</cfquery>

<cfquery name="getexp" datasource="#datasource#">
select * from files where type = 'CUSTOM-EXPRESSION' order by description ASC
</cfquery>


<select name="file" style="height: 24px;">
<option value="EXT-HIGH">=== HIGH RISK FILE EXTENSIONS ===</option>
<cfoutput query="getexthigh">
<cfquery name="checkfileexists" datasource="#datasource#">
select file_id, sessionno from file_rule_components_temp where file_id = '#id#' and sessionno = '#session.cfid#' and action = 'add'
</cfquery>
<cfif #checkfileexists.recordcount# LT 1>
<option value="#id#">#description#</option>
</cfif>
</cfoutput>
<option value="FIlE-HIGH">=== HIGH RISK FILE TYPES ===</option>
<cfoutput query="getfilehigh">
<cfquery name="checkfileexists" datasource="#datasource#">
select file_id, sessionno from file_rule_components_temp where file_id = '#id#' and sessionno = '#session.cfid#' and action = 'add'
</cfquery>
<cfif #checkfileexists.recordcount# LT 1>
<option value="#id#">#description#</option>
</cfif>
</cfoutput>
<option value="MIME-HIGH">=== HIGH RISK MIME TYPES ===</option>
<cfoutput query="getmimehigh">
<cfquery name="checkfileexists" datasource="#datasource#">
select file_id, sessionno from file_rule_components_temp where file_id = '#id#' and sessionno = '#session.cfid#' and action = 'add'
</cfquery>
<cfif #checkfileexists.recordcount# LT 1>
<option value="#id#">#description#</option>
</cfif>
</cfoutput>
<option value="EXT">=== FILE EXTENSIONS ===</option>
<cfoutput query="getext">
<cfquery name="checkfileexists" datasource="#datasource#">
select file_id, sessionno from file_rule_components_temp where file_id = '#id#' and sessionno = '#session.cfid#' and action = 'add'
</cfquery>
<cfif #checkfileexists.recordcount# LT 1>
<option value="#id#">#description#</option>
</cfif>
</cfoutput>
<option value="FIlE">=== FILE TYPES ===</option>
<cfoutput query="getfile">
<cfquery name="checkfileexists" datasource="#datasource#">
select file_id, sessionno from file_rule_components_temp where file_id = '#id#' and sessionno = '#session.cfid#' and action = 'add'
</cfquery>
<cfif #checkfileexists.recordcount# LT 1>
<option value="#id#">#description#</option>
</cfif>
</cfoutput>
<option value="MIME">=== MIME TYPES ===</option>
<cfoutput query="getmime">
<cfquery name="checkfileexists" datasource="#datasource#">
select file_id, sessionno from file_rule_components_temp where file_id = '#id#' and sessionno = '#session.cfid#' and action = 'add'
</cfquery>
<cfif #checkfileexists.recordcount# LT 1>
<option value="#id#">#description#</option>
</cfif>
</cfoutput>
<option value="OTHER">=== OTHER TYPES ===</option>
<cfoutput query="getother">
<cfquery name="checkfileexists" datasource="#datasource#">
select file_id, sessionno from file_rule_components_temp where file_id = '#id#' and sessionno = '#session.cfid#' and action = 'add'
</cfquery>
<cfif #checkfileexists.recordcount# LT 1>
<option value="#id#">#description#</option>
</cfif>
</cfoutput>
<option value="CUSTOM-EXPRESSIONS">=== CUSTOM-EXPRESSIONS ===</option>
<cfoutput query="getexp">
<cfquery name="checkfileexists" datasource="#datasource#">
select file_id, sessionno from file_rule_components_temp where file_id = '#id#' and sessionno = '#session.cfid#' and action = 'add'
</cfquery>
<cfif #checkfileexists.recordcount# LT 1>
<option value="#id#">#description#</option>
</cfif>
</cfoutput>



</select>
&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="472">
                                            <tr valign="top" align="left">
                                              <td width="472" height="16"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="472" id="Text432" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Action</span></p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td height="3"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="149">
                                                <table id="Table154" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 38px;">
                                                  <tr style="height: 19px;">
                                                    <td width="58" id="Cell936">
                                                      <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #type# is "ban">
<cfoutput>
<input type="radio" name="type" value="ban" checked="checked" style="height: 19px; width: 19px;"/>
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="ban" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      &nbsp;</td>
                                                    <td width="91" id="Cell937">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Ban</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 19px;">
                                                    <td id="Cell938">
                                                      <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #type# is "allow">
<cfoutput>
<input type="radio" name="type" value="allow" checked="checked" style="height: 19px; width: 19px;">
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="allow" style="height: 19px; width: 19px;">
</cfoutput>
</cfif>


&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      &nbsp;</td>
                                                    <td id="Cell939">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Allow</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td height="4"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="953">
                                                <table id="Table152" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="953" id="Cell934">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;"><cfoutput><input type="hidden" name="template" value="#template#"></cfoutput>
<input type="submit" name="action" value="Add" style="height: 24px; width: 136px;">&nbsp;</p>
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
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="953">
                                    <tr valign="top" align="left">
                                      <td height="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="953"><hr id="HRRule1" width="953" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="476">
                                    <tr valign="top" align="left">
                                      <td width="290" height="1"></td>
                                      <td width="186"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text375" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">File Types and Actions&nbsp; to be added</span></b></p>
                                      </td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" colspan="2" width="476" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_components2" datasource="#datasource#">
select * from file_rule_components_temp where action='copy' and applied='2' order by priority asc
</cfquery>

<cfif #get_components2.recordcount# GTE 1>
<form name="LayoutRegion10FORM" action="edit_rule.cfm" method="post">
<select name="file" style="height: 88px;" size="60">
<cfoutput query="get_components2">
<option value="#file_id#">#description# --> #type#</option>
</cfoutput>
</select>
<cfoutput><input type="hidden" name="template" value="#template#"></cfoutput>
<table id="Table170" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 28px;">
  <tr style="height: 28px;">
    <td>
      <p style="margin-bottom: 0px;"><input type="submit" name="action" value="Delete" style="height: 24px; width: 69px;"></p>
    </td>
    <td>
      <p style="margin-bottom: 0px;"><input type="submit" name="action" value="Move Up" style="height: 24px; width: 91px;"></p>
    </td>
    <td>
      <p style="margin-bottom: 0px;"><input type="submit" name="action" value="Move Down" style="height: 24px; width: 115px;"></p>
    </td>
  </tr>
</table>
</form>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No file type(s) found to be added..</span></p>
</cfif>


    
&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="953">
                                        <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                          <tr style="height: 24px;">
                                            <td width="953" id="Cell738">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="text-align: center; margin-bottom: 0px;"><cfif #get_components2.recordcount# GTE 1>
<form name="LayoutRegion10FORM" action="edit_rule.cfm" method="post">
<cfoutput><input type="hidden" name="template" value="#template#"></cfoutput>
<input type="submit" name="action" value="Cancel All" style="height: 24px; width: 136px;">
</form>
<cfelseif #get_components2.recordcount# LT 1>
<input type="submit" name="action" value="Cancel All" style="height: 24px; width: 136px;" disabled="disabled">
</cfif>&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="953">
                                    <tr valign="top" align="left">
                                      <td width="953" height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="953" id="Text277" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You must select a file type to delete</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Rule Name field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the File Type you are attempting is already set to be added</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;File Type Added Successfully</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you cannot insert a rule with no file types defined</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All add requests have been cancelled</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Rule Name you are attempting to use already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! File Type Deleted</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! File Type Moved Up</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! File Type Moved Down</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The File Type you are attempting to move up is the top most entry</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "13">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The File Type you are attempting to move down is the bottom most entry</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Rule Name must only contain letters, numbers, dashes and underscores. No other characters or spaces are allowed</span></i></b></p>
</cfoutput>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="74"></td>
                          <td colspan="4" width="957">

                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion17" style="height: 74px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="edit_rule.cfm" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0" width="635">
                                      <tr valign="top" align="left">
                                        <td width="635" id="Text455" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(0,0,0);"><span style="font-size: 12px;">Enter a name for this File Rule</span></span></b></p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="4"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 39px;">
                                            <tr style="height: 22px;">
                                              <td width="957" id="Cell1017">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="left"><input type="text" id="FormsEditField42" name="rule_name" size="50" maxlength="50" style="width: 396px; white-space: pre;"></td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1018">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfoutput><input type="hidden" name="template" value="#template#"></cfoutput>
<cfquery name="getapplied" datasource="#datasource#">
select * from file_rule_components_temp where applied='2'
</cfquery>
<cfif #getapplied.recordcount# GTE 1>
<input type="submit" name="action" value="Add Rule" style="height: 24px; width: 142px;">
<cfelse>
<input type="submit" name="action" value="Add Rule" disabled="disabled" style="height: 24px; width: 142px;">
</cfif>&nbsp;</p>
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