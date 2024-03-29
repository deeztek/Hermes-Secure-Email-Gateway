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
<title>Copy Rule</title>
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
<body style="background-color: rgb(255,255,255); background-image: none; background-repeat: repeat; background-attachment: scroll; margin: 0px;">
<!-- DO NOT MOVE! The following AllWebMenus linking code section must always be placed right AFTER the BODY tag-->
<!-- ******** BEGIN ALLWEBMENUS CODE FOR hermes_seg_menu2 ******** -->
<script type='text/javascript'>var MenuLinkedBy='AllWebMenus [2]',awmMenuName='hermes_seg_menu2',awmBN='FUS';awmAltUrl='';</script><script charset='UTF-8' src='./hermes_seg_menu2.js' language='JavaScript1.2' type='text/javascript'></script><script type='text/javascript'>awmBuildMenu();</script>
<!-- ******** END ALLWEBMENUS CODE FOR hermes_seg_menu2 ******** -->
  <table border="0" cellspacing="0" cellpadding="0" width="988">
    <tr valign="top" align="left">
      <td width="21" height="10"></td>
      <td width="782"></td>
      <td width="185"></td>
    </tr>
    <tr valign="top" align="left">
      <td height="131" colspan="3" width="988">
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
      <td colspan="3" height="37"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="782" id="Text1" class="TextObject">
        <p style="margin-bottom: 0px;"><cfif IsDefined("URL.ID")>
<cfquery name="getfilerule" datasource="#datasource#">
select * from file_rule_components where rule_id='#url.id#' order by priority asc
</cfquery>

<cfquery name="clear" datasource="#datasource#">
delete from file_rule_components_temp where action='copy'
</cfquery>

<cfloop query="getfilerule">
<cfquery name="insertrule" datasource="#datasource#">
insert into file_rule_components_temp
(file_id, description, type, priority, action, applied)
values
('#file_id#', '#description#', '#type#', '#priority#', 'copy', '2')
</cfquery>
</cfloop>
<cflocation url="copy_file_rule.cfm" addtoken="no">

<cfif #getfilerule.recordcount# LT 1>
<cflocation url="error.cfm" addtoken="no">
</cfif>
<cfelseif NOT IsDefined("URL.ID")>
<cflocation url="error.cfm" addtoken="no">
</cfif>&nbsp;</p>
      </td>
      <td></td>
    </tr>
    <tr valign="top" align="left">
      <td colspan="3" height="293"></td>
    </tr>
    <tr valign="top" align="left">
      <td height="49" colspan="3" width="988">
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
</body>
</html>
   