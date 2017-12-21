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
<title>Recipient Reports</title>
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
<body style="background-color: rgb(192,192,192); background-image: none; background-repeat: repeat; background-attachment: scroll; margin: 0px;" class="nof-centerBody">
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
              <td height="652" width="988"><cfif IsDefined("session.license")>
<cfif #session.license# is "VIOLATION">
<cflocation url="license_invalid.cfm">
<cfelseif #session.license# is "NEW">
<cflocation url="license_invalid.cfm">
</cfif>
</cfif>

<cfparam name = "recipient" default = "#form.recipient#"> 

<cfparam name = "StartRow" default = ""> 
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif> 

<cfparam name = "DisplayRows" default = ""> 
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>

<cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>


<cfquery name="recid" datasource="#datasource#">
select id from user_settings where email = '#recipient#'
</cfquery>

                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion12" style="background-image: url('./middle_988.png'); height: 652px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="13" height="16"></td>
                          <td width="2"></td>
                          <td width="1"></td>
                          <td width="952"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="4" width="955" id="Text291" class="TextObject"><cfoutput>
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Quarantine Report Settings for #recipient#</span></b></p>
                            </cfoutput></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="4" valign="middle" width="955"><hr id="HRRule7" width="955" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="3" width="955" id="Text440" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">You can adjust your report settings to be sent on a <b>Daily Basis</b>, every<b> 8 Hours</b>, every <b>4 Hours</b> or alternatively, you can completely disable the reports. The Daily Report will be sent once a day and it will include any quarantined messages from the previous day. The 8 Hour or the 4 Hour report will include any quarantined messages from the current day only. Please note, no matter which option you choose, reports will only be sent if there are quarantined messages available. If there are no quarantined messages available, the report will not be sent.</span></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="4" valign="middle" width="955"><hr id="HRRule8" width="955" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="195"></td>
                          <td colspan="4" width="955"><cfparam name = "m" default = ""> 
<cfif IsDefined("url.m") is "True">
<cfif url.m is not "">
<cfset m = url.m>
</cfif></cfif> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfquery name="getsettings" datasource="#datasource#">
select report_enabled, report_frequency from user_settings where id='#recid.id#'
</cfquery>

<cfparam name = "frequency" default = "#getsettings.report_frequency#"> 
<cfif IsDefined("form.frequency") is "True">
<cfif form.frequency is not "">
<cfset frequency = #form.frequency#>
</cfif></cfif>

<cfparam name = "enabled" default = "#getsettings.report_enabled#">
<cfif IsDefined("form.enabled") is "True">
<cfif form.enabled is not "">
<cfset enabled = "#form.enabled#">
</cfif> 
</cfif>

<cfif #action# is "update">
<cfquery name="updatesettings" datasource="#datasource#">
update user_settings set
report_enabled='#enabled#',
report_frequency='#frequency#'
where id = '#recid.id#'
</cfquery>
</cfif>



                            <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion11" style="height: 195px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="<cfoutput>recipient_reports.cfm?m=1&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter###delete</cfoutput>" method="post">
                                    <input type="hidden" name="action" value="update"><input type="hidden" name="recipient" value="<cfoutput>#recipient#</cfoutput>">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="955">
                                          <table id="Table160" border="0" cellspacing="4" cellpadding="0" width="955" style="height: 165px;">
                                            <tr style="height: 14px;">
                                              <td width="947" id="Cell889">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Enable Quarantine Reports</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 51px;">
                                              <td id="Cell890">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                  <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table71" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                          <tr style="height: 17px;">
                                                            <td width="51" id="Cell411">
                                                              <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #enabled# is "YES">
<cfoutput>
<input type="radio" checked="checked" name="enabled" value="YES" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #enabled# is not "YES">
<cfoutput>
<input type="radio" name="enabled" value="YES" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="480" id="Cell412">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">YES <span style="color: rgb(51,51,51); font-weight: normal;">(Only if quarantined messages exist)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell1017">
                                                              <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #enabled# is "ALL">
<cfoutput>
<input type="radio" checked="checked" name="enabled" value="ALL" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #enabled# is not "ALL">
<cfoutput>
<input type="radio" name="enabled" value="ALL" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1016">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">YES <span style="color: rgb(51,51,51); font-weight: normal;">(Regardless if quarantined messages exist)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell413">
                                                              <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"><cfif #enabled# is "NO">
<cfoutput>
<input type="radio" checked="checked" name="enabled" value="NO" style="height: 13px; width: 13px;">
</cfoutput>
<cfelseif #enabled# is not "NO">
<cfoutput>
<input type="radio" name="enabled" value="NO" style="height: 13px; width: 13px;">
</cfoutput>
</cfif>
&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell414">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  </b></td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell891">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Quarantine Report Frequency</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 24px;">
                                                <td id="Cell892">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                    <table width="209" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #enabled# is "YES">

<cfif #frequency# is "24">
<select name="frequency" style="height: 24px;">
  <option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
  
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>


<cfelseif #frequency# is "8">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8" selected="selected">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "4">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4" selected="selected">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "2">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2" selected="selected">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

</cfif>

<cfelseif #enabled# is "NO">
<cfif #frequency# is "24">
<select name="frequency" style="height: 24px;" disabled="disabled">
  <option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>


<cfelseif #frequency# is "8">
<select name="frequency" style="height: 24px;" disabled="disabled">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8" selected="selected">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "4">
<select name="frequency" style="height: 24px;" disabled="disabled">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4" selected="selected">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "2">
<select name="frequency" style="height: 24px;" disabled="disabled">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2" selected="selected">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

</cfif>


<cfelseif #enabled# is "ALL">
<cfif #frequency# is "24">
<select name="frequency" style="height: 24px;">
  <option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>


<cfelseif #frequency# is "8">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8" selected="selected">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "4">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
<option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4" selected="selected">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>

<cfelseif #frequency# is "2">
<select name="frequency" style="height: 24px;">
  <option value="24">Daily (Previous Day's Quarantine Report)</option>
<option value="2" selected="selected">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
</select>


</cfif>

</cfif>&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    </b></td>
                                                </tr>
                                                <tr style="height: 17px;">
                                                  <td id="Cell1014">
                                                    <p style="margin-bottom: 0px;">&nbsp;</p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 17px;">
                                                  <td id="Cell1015">
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td align="center">
                                                          <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td class="TextObject">
                                                                <p style="text-align: left; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="949">
                                          <tr valign="top" align="left">
                                            <td width="949" height="13"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="949" id="Text185" class="TextObject">
                                              <p style="text-align: left; margin-bottom: 0px;"><cfif #m# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Report Settings Updated</span></i></b></p>
</cfoutput>
</cfif>


&nbsp;</p>
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
                              <td colspan="6" height="2"></td>
                            </tr>
                            <tr valign="top" align="left">
                              <td colspan="3" height="30"></td>
                              <td colspan="2" valign="middle" width="953"><hr id="HRRule30" width="953" size="1"></td>
                              <td></td>
                            </tr>
                            <tr valign="top" align="left">
                              <td colspan="6" height="2"></td>
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
                                                <td width="953" id="Cell1025">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center">
                                                        <table width="302" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><form name="recipients" action="<cfoutput>recipients.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter###delete</cfoutput>" method="post">
  


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
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Recipients" style="height: 24px; width: 357px;">


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
                              <td colspan="2"></td>
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