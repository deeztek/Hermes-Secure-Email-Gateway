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
<title>Search Progress</title>
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
        <td><style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted
 black;padding:5px; }
</style>

          <table border="0" cellspacing="0" cellpadding="0" width="988">
            <tr valign="top" align="left">
              <td height="10"></td>
              <td width="5"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="131" colspan="2" width="988">
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
              <td height="361" width="983"><cfquery name="getsearches" datasource="#datasource#">
select * from searches order by started desc
</cfquery>


<cfparam name = "m1" default = ""> 
<cfif IsDefined("url.m1") is "True">
<cfif url.m1 is not "">
<cfset m1 = url.m1>
</cfif></cfif> 

<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfparam name = "StartRow" default = "1"> 
<cfif IsDefined("url.StartRow") is "True">
<cfif url.StartRow is not "">
<cfset StartRow = url.StartRow>
</cfif></cfif>

<cfparam name = "DisplayRows" default = "20"> 
<cfif IsDefined("url.DisplayRows") is "True">
<cfif url.DisplayRows is not "">
<cfset DisplayRows = url.DisplayRows>
</cfif></cfif>

<CFSET ToRow = StartRow + (DisplayRows - 1)>
<CFSET Next = StartRow + DisplayRows>
<CFSET Previous = StartRow - DisplayRows>



<cfif #action# is "view">
<cfset session.searchtype2="advanced">
<cfset session.searchfor="#form.searchfor#">
<cfset session.customtrans="#form.customtrans#">
<cfset session.totalevents="#form.totalevents#">

<cflocation url="loading4.cfm?action=search&DisplayRows=25">
</cfif>

<cfif #action# is "cancel">

<cftry>
<cfexecute name = "/opt/hermes/scripts/cancel_search.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

<cfcatch type="any">
</cfcatch>
</cftry>

<!---
<cfschedule
action = "delete"
task = "search_#form.customtrans#">
--->

<cfset testfile="/opt/hermes/tmp/#form.customtrans#_grepmail.sh">

<cfif fileExists(testfile)>
<cffile 
action = "delete"
file = "#testfile#">
</cfif>

<cfset testfile="/opt/hermes/tmp/#form.customtrans#_results.txt">

<cfif fileExists(testfile)>
<cffile 
action = "delete"
file = "#testfile#">
</cfif>


<cfquery name="getversion" datasource="#datasource#">
select value from system_settings where parameter = 'version_no'
</cfquery>



<cffile
    action = "delete"
    file = "/var/www/html/schedule/#form.customtrans#_search_task.cfm">
    

    
<cfquery name="cancel" datasource="#datasource#">
update searches set status = 'cancelled' where customtrans = '#form.customtrans#'
</cfquery>

<cfquery name="delete" datasource="#datasource#">
delete from body_temp where customtrans = '#form.customtrans#'
</cfquery>


<cflocation url="search_progress.cfm?m1=1" addtoken="no">
</cfif>

<cfif #action# is "delete">

<cfquery name="delete" datasource="#datasource#">
delete from searches where customtrans = '#form.customtrans#'
</cfquery>

<cfquery name="delete" datasource="#datasource#">
delete from body_temp where customtrans = '#form.customtrans#'
</cfquery>

<cflocation url="search_progress.cfm?m1=2" addtoken="no">
</cfif>
                <table border="0" cellspacing="0" cellpadding="0" width="983" id="LayoutRegion4" style="background-image: url('./middle_988.png'); height: 361px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="8" height="11"></td>
                          <td width="1"></td>
                          <td width="403"></td>
                          <td width="560"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="2" width="404" id="Text291" class="TextObject"><cfoutput>
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Body/Headers Search History</span></b></p>
                            </cfoutput></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="2" width="963" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Current and previous Body/Headers search history is shown below. If any of the previous searches show a status of <b>Complete</b> and there is a<b> View</b> button in the results column, you can click that button to view the results. If any of the previous searches show a status of <b>Complete</b> but there is no View button, it means that the search did not yield any results. If any of the previous searches is still pending, and you wish to cancel it, click on the Cancel button. It is recommended to delete any completed or canceled searches that are no longer needed from time to time in order to conserve system resources.</span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="9" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="964">
                            <table id="Table147" border="0" cellspacing="0" cellpadding="0" width="965" style="height: 17px;">
                              <tr style="height: 17px;">
                                <td width="459" id="Cell869">
                                  <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                    <tr>
                                      <td class="TextObject">
                                        <p style="margin-bottom: 0px;"><CFOUTPUT>
<CFIF Previous GTE 1>
<A HREF="search_progess.cfm?StartRow=#Previous#&DisplayRows=#DisplayRows#&action=#action###delete"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous #DisplayRows# Records</SPAN></b></P>
</A>
<CFELSE>
 
</CFIF>
</cfoutput>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  &nbsp;</td>
                                <td width="8" id="Cell870">
                                  <p style="margin-bottom: 0px;">&nbsp;</p>
                                </td>
                                <td width="497" id="Cell871">
                                  <table width="234" border="0" cellspacing="0" cellpadding="0" align="right">
                                    <tr>
                                      <td class="TextObject">
                                        <p style="text-align: right; margin-bottom: 0px;"><cfoutput>
<CFIF Next LTE getsearches.RecordCount>
<A HREF="search_progress.cfm?StartRow=#Next#&DisplayRows=#DisplayRows#&action=#action#"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next<CFIF (getsearches.RecordCount - Next) LT DisplayRows>
      #Evaluate((getsearches.RecordCount - Next)+1)#
    <CFELSE>
      #DisplayRows#
    </CFIF>Records&nbsp; &gt;&gt;</SPAN></b></P></A>
<CFELSE>
  
</CFIF>
</CFOUTPUT>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  &nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="971">
                        <tr valign="top" align="left">
                          <td width="9" height="4"></td>
                          <td width="961"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="961" id="Text378" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #getsearches.RecordCount# GTE 1>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying #StartRow# through #toRow# out of #getsearches.RecordCount# total records.</span></p>
</cfoutput>
<cfelse>
</cfif>&nbsp;</p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="24"></td>
                          <td colspan="2" width="962" id="Text266" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #getsearches.recordcount# GTE 1>

<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">
<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Started</span></b></p>
    </td>

    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Ended</span></b></p>
    </td>

<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Keywords</span></b></p>
    </td>

   
   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Results</span></b></p>
    </td>

  <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Status</span></b></p>
    </td>

<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Cancel</span></b></p>
    </td>

<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Delete</span></b></p>
    </td>
   
  
    
  </tr>


<cfoutput query="getsearches" STARTROW="#StartRow#" MAXROWS="#DisplayRows#">



  <tr style="height: 28px;">

<cfset datestarted = #DateFormat(started, "mm/dd/yyyy")#>
<cfset timestarted = #TimeFormat(started, "HH:mm:ss")#>
     
    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#datestarted# #timestarted# </span></p>
</div>
    </td>

<cfif #ended# is not "">
<cfset dateended = #DateFormat(ended, "mm/dd/yyyy")#>
<cfset timeended = #TimeFormat(ended, "HH:mm:ss")#>

    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#dateended# #timeended# </span></p>
</div>
    </td>

<cfelseif #ended# is "">
    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">N/A </span></p>
</div>
    </td>
</cfif>
    


    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#searchfor#</span></p>
</div>
    </td>

<cfif #status# is "completed">
<cfquery name="getresults" datasource="#datasource#">
select count(customtrans) as theResults from body_temp where customtrans = '#customtrans#'
</cfquery>

<cfif #getresults.theResults# GTE 1>

<form name="viewresults" action="search_progress.cfm?action=view" method="post">
<input type="hidden" name="searchfor" value="bodyresults">
<input type="hidden" name="customtrans" value="#customtrans#">
<input type="hidden" name="totalevents" value="#getresults.theResults#">

<td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;"><input type="submit" name="FormsButton1" value="View"></span></p>
</div>
    </td>
</form>

<cfelseif #getresults.theResults# LT 1>
<td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">No Results</span></p>
</div>
    </td>

</cfif>

<cfelse>

<td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">N/A</span></p>
</div>
    </td>


</cfif>

    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#status#</span></p>
</div>
    </td>

<cfif #status# is "pending"> 
<form name="cancelsearch" action="search_progress.cfm?action=cancel" method="post">
<input type="hidden" name="customtrans" value="#customtrans#">
    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;"><input type="submit" name="FormsButton1" value="Cancel"></span></p>
</div>
    </td>
</form>
<cfelseif #status# is not "pending">
<td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">N/A</span></p>
</div>
    </td>
</cfif>

<cfif #status# is "pending"> 
    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">N/A</span></p>
</div>
    </td>

<cfelseif #status# is not "pending">
<form name="cancelsearch" action="search_progress.cfm?action=delete" method="post">
<input type="hidden" name="customtrans" value="#customtrans#">
    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;"><input type="submit" name="FormsButton1" value="Delete"></span></p>
</div>
    </td>
</form>
</cfif>
    


</cfoutput>
        </tr>
      </table>

<cfelse>
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No existing searches found...</span></i></b></p>
</cfif>&nbsp;</p>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="961" id="Text276" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #m1# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry before clicking the Delete button</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! Search has been cancelled</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! Search has been deleted</span></i></b></p>
</cfoutput>
</cfif>&nbsp;</p>
                          </td>
                          <td></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
              <td></td>
            </tr>
            <tr valign="top" align="left">
              <td height="49" colspan="2" width="988">
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