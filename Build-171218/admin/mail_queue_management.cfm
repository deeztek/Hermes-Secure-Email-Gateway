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
<title>Mail Queue Management</title>
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
<script type="text/javascript">
<!--
var hwndPopup_27b5;
function openpopup_27b5(url){
var popupWidth = 900;
var popupHeight = 780;
var popupTop = 300;
var popupLeft = 300;
var isFullScreen = false;
var isAutoCenter = false;
var popupTarget = "popupwin_27b5";
var popupParams = "toolbar=0, scrollbars=1, menubar=0, status=0, resizable=0";

if (isFullScreen) {
	popupParams += ", fullscreen=1";
} else if (isAutoCenter) {
	popupTop	= parseInt((window.screen.height - popupHeight)/2);
	popupLeft	= parseInt((window.screen.width - popupWidth)/2);
}

var ua = window.navigator.userAgent;
var isMac = (ua.indexOf("Mac") > -1);

//IE 5.1 PR on OSX 10.0.x does not support relative URLs in pop-ups the way they're handled below w/ document.writeln
if (isMac && url.indexOf("http") != 0) {
  url = location.href.substring(0,location.href.lastIndexOf('\/')) + "/" + url;
}

var isOpera = (ua.indexOf("Opera") > -1);
var operaVersion;
if (isOpera) {
	var i = ua.indexOf("Opera");
	operaVersion = parseFloat(ua.substring(i + 6, ua.indexOf(" ", i + 8)));
	if (operaVersion > 7.00) {
		var isAccessible = false;
		eval("try { isAccessible = ( (hwndPopup_27b5 != null) && !hwndPopup_27b5.closed ); } catch(exc) { } ");
		if (!isAccessible) {
			hwndPopup_27b5 = null;
		}
	}
}
if ( (hwndPopup_27b5 == null) || hwndPopup_27b5.closed ) {
	
	if (isOpera && (operaVersion < 7)) {
		if (url.indexOf("http") != 0) {
			hwndPopup_27b5 = window.open(url,popupTarget,popupParams + ((!isFullScreen) ? ", width=" + popupWidth +", height=" + popupHeight : ""));
			if (!isFullScreen) {
				hwndPopup_27b5.moveTo(popupLeft, popupTop);
			}
			hwndPopup_27b5.focus();
			return;
		}
	}
	if (!(window.navigator.appName == "Netscape" && !document.getElementById)) {
		//not ns4
		popupParams += ", width=" + popupWidth +", height=" + popupHeight + ", left=" + popupLeft + ", top=" + popupTop;
	} else {
		popupParams += ", left=" + popupLeft + ", top=" + popupTop;
	}
	//alert(popupParams);
	hwndPopup_27b5 = window.open("",popupTarget,popupParams);
	if (!isFullScreen) {
		hwndPopup_27b5.resizeTo(popupWidth, popupHeight);
		hwndPopup_27b5.moveTo(popupLeft, popupTop);
	}
	hwndPopup_27b5.focus();
	with (hwndPopup_27b5.document) {
		open();
    		write("<ht"+"ml><he"+"ad><\/he"+"ad><bo"+"dy onLoad=\"window.location.href='" + url + "'\"><\/bo"+"dy><\/ht"+"ml>");
		close();
	}
} else {
	if (isOpera && (operaVersion > 7.00)) {
		eval("try { hwndPopup_27b5.focus();	hwndPopup_27b5.location.href = url; } catch(exc) { hwndPopup_27b5 = window.open(\""+ url +"\",\"" + popupTarget +"\",\""+ popupParams + ", width=" + popupWidth +", height=" + popupHeight +"\"); } ");
	} else {
		hwndPopup_27b5.focus();
		hwndPopup_27b5.location.href = url;
	}
}

}

-->
</script>
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
              <td height="874" width="988"><cfquery name="get_bounce_queue_lifetime" datasource="#datasource#">
select id from parameters where parameter='bounce_queue_lifetime' and child = '2'
</cfquery>

<cfquery name="get_bounce_queue_lifetime_children" datasource="#datasource#">
select * from parameters where parent='#get_bounce_queue_lifetime.id#' and child = '1' order by order1 asc
</cfquery>

<cfquery name="get_maximal_queue_lifetime" datasource="#datasource#">
select id from parameters where parameter='maximal_queue_lifetime' and child = '2'
</cfquery>

<cfquery name="get_maximal_queue_lifetime_children" datasource="#datasource#">
select * from parameters where parent='#get_maximal_queue_lifetime.id#' and child = '1' order by order1 asc
</cfquery>

<cfparam name = "bouncequeue" default = "#get_bounce_queue_lifetime_children.parameter#"> 
<cfif IsDefined("form.bouncequeue") is "True">
<cfif form.bouncequeue is not "">
<cfset bouncequeue = form.bouncequeue>
</cfif></cfif> 

<cfparam name = "maxqueue" default = "#get_maximal_queue_lifetime_children.parameter#"> 
<cfif IsDefined("form.maxqueue") is "True">
<cfif form.maxqueue is not "">
<cfset maxqueue = form.maxqueue>
</cfif></cfif> 

<cfset stime = 0> 
<cfset etime = 90>

<cfparam name = "m1" default = ""> 
<cfif IsDefined("url.m1") is "True">
<cfif url.m1 is not "">
<cfset m1 = url.m1>
</cfif></cfif> 

<cfexecute name = "/usr/bin/mailq"
timeout = "240"
variable="mailQueueStatus">
</cfexecute>

<cfif #mailQueueStatus# contains "Mail queue is empty">
<cfset theQueue = 0>
<cfelse>

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


<cffile action="read" file="/opt/hermes/scripts/list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-TRANSACTION","#customtrans3#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "240"
variable="thekeyid2"
arguments="-inputformat none">
</cfexecute>


<!-- delete /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mailqueue_list" variable="temp">

<cfloop index="curLine" list="#temp#" delimiters="#chr(10)#">

<!-- CHECK IF MESSAGE IS ON HOLD BY SEEING IF THERE IS ! (EXCLAMATION) IN MESSAGE ID -->
<cfif #trim(curLine)# contains "!">

<!-- REMOVE ! (EXCLAMATION) FROM MESSAGE ID -->
<cfset msgId = reReplace("#trim(curLine)#", "[!]", "", "ALL")>

<!-- INSERT INTO DATABASE AS ON-HOLD MESSAGE -->
<cfquery name="insert" datasource="#datasource#">
insert into postfix_queue
(trans_id, msg_id, on_hold)
values 
('#customtrans3#', '#msgId#', 'YES')
</cfquery>

<cfelse>

<cfquery name="insert" datasource="#datasource#">
insert into postfix_queue
(trans_id, msg_id, on_hold)
values 
('#customtrans3#', '#trim(curLine)#', 'NO')
</cfquery>

<!-- /CFIF CHECK IF MESSAGE IS ON HOLD BY SEEING IF THERE IS ! (EXCLAMATION) IN MESSAGE ID -->
</cfif>
</cfloop>

<!-- GET POSTFIX QUEUE FROM DATABASE -->
<cfquery name="getqueue" datasource="#datasource#">
select msg_id, on_hold from postfix_queue where trans_id = '#customtrans3#'
</cfquery>

<cfset theQueue = #getqueue.recordcount#>

<!-- DELETE POSTFIX QUEUE FROM DATABASE -->
<cfquery name="deletequeue" datasource="#datasource#">
delete from postfix_queue where trans_id = '#customtrans3#'
</cfquery>

<!-- delete /opt/hermes/tmp/#customtrans3#_mailqueue_list -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_mailqueue_list">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<!-- /CFIF  mailQueueStatus contains "Mail queue is empty" -->
</cfif>

                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 874px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="517">
                              <tr valign="top" align="left">
                                <td width="11" height="13"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Mail Queue Management</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="453">
                              <tr valign="top" align="left">
                                <td width="428" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/system/mail-queue-management/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="971">
                        <tr valign="top" align="left">
                          <td width="12" height="3"></td>
                          <td width="959"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="959" id="Text277" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Message(s) Requeued</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Message(s) are On Hold</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select 1 or more message(s)</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Message(s) Deleted from Queue</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Queue Settings were applied</span></i></b></p>
</cfoutput>
</cfif>



&nbsp;</p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="977">
                        <tr valign="top" align="left">
                          <td width="12" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="965"><hr id="HRRule1" width="965" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="10" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="614">
                            <form name="Table127FORM" action="mail_queue_management_edit.cfm" method="post">
                              <input type="hidden" name="action" value="Set Queue">
                              <table id="Table127" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 41px;">
                                <tr style="height: 28px;">
                                  <td width="101" id="Cell1023">
                                    <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Bounce Queue Lifetime</span></b></p>
                                  </td>
                                  <td width="105" id="Cell1022">
                                    <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Max Queue Lifetime</span></b></p>
                                  </td>
                                  <td width="18" id="Cell1021">
                                    <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;"></span></b>&nbsp;</p>
                                  </td>
                                  <td width="390" id="Cell1033">
                                    <p style="margin-bottom: 0px;">&nbsp;</p>
                                  </td>
                                </tr>
                                <tr style="height: 24px;">
                                  <td id="Cell768">
                                    <table width="92" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #bouncequeue# is "">
<select name="bouncequeue" style="height: 22px;">
<cfloop from="#stime#" to="#etime#" index="i" step="1"> 
<cfoutput>
<option value="#i#d">#i# Days</option>
</cfoutput>
</cfloop>
</select>

<cfelseif #bouncequeue# is not "">
<select name="bouncequeue" style="height: 22px;">
<cfoutput>
<!-- Check if there is a d in bouncequeue variable -->
<cfif #trim(bouncequeue)# contains "d">

<!-- Remove d from bouncequeue variable -->
<cfset thebouncequeue = reReplace("#trim(bouncequeue)#", "[d]", "", "ALL")>
<!-- /CFIF #trim(bouncequeue)# contains "d" -->
</cfif>
<option value="#bouncequeue#" SELECTED>#thebouncequeue# Days</option>
</cfoutput>
<cfloop from="#stime#" to="#etime#" index="i" step="1"> 
<cfoutput>
<option value="#i#d">#i# Days</option>
</cfoutput>
</cfloop>
</select>
<!-- /CFIF for #bouncequeue# is "" -->
</cfif>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1019">
                                    <table width="104" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="margin-bottom: 0px;"><cfif #maxqueue# is "">
<select name="maxqueue" style="height: 22px;">
<cfloop from="#stime#" to="#etime#" index="i" step="1"> 
<cfoutput>
<option value="#i#d">#i# Days</option>
</cfoutput>
</cfloop>
</select>

<cfelseif #maxqueue# is not "">
<select name="maxqueue" style="height: 22px;">
<cfoutput>
<!-- Check if there is a d in maxqueue variable -->
<cfif #trim(maxqueue)# contains "d">

<!-- Remove d from maxqueue variable -->
<cfset themaxqueue = reReplace("#trim(maxqueue)#", "[d]", "", "ALL")>
<!-- /CFIF #trim(maxqueue)# contains "d" -->
</cfif>
<option value="#maxqueue#" SELECTED>#themaxqueue# Days</option>
</cfoutput>
<cfloop from="#stime#" to="#etime#" index="i" step="1"> 
<cfoutput>
<option value="#i#d">#i# Days</option>
</cfoutput>
</cfloop>
</select>
<!-- /CFIF for #maxqueue# is "" -->
</cfif>&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td id="Cell1020">
                                    <p style="margin-bottom: 0px;">&nbsp;</p>
                                  </td>
                                  <td id="Cell1034">
                                    <table width="293" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Set" style="height: 22px; width: 175px;">&nbsp;</p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="974">
                        <tr valign="top" align="left">
                          <td width="9" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="965"><hr id="HRRule3" width="965" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="10" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="579">
                            <form name="Table144FORM" action="<cfoutput>loading_queue.cfm</cfoutput>" method="post">
                              <input type="hidden" name="setfilter" value="1">
                              <table id="Table144" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 25px;">
                                <tr style="height: 25px;">
                                  <td width="579" id="Cell866">
                                    <table width="276" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Reload Mail Queue" style="height: 24px; width: 175px;">&nbsp;</p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="976">
                        <tr valign="top" align="left">
                          <td width="11" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="965"><hr id="HRRule2" width="965" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="11" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="952">
                            <table id="Table147" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                              <tr style="height: 17px;">
                                <td width="272" id="Cell869">
                                  <p style="margin-bottom: 0px;">&nbsp;</p>
                                </td>
                                <td width="391" id="Cell870">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td align="center">
                                        <table width="242" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                            <td class="TextObject">
                                              <p style="margin-bottom: 0px;"><cfif #theQueue# GTE 1>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">There are #theQueue# Messages in the Queue.</span></p>
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
                                <td width="289" id="Cell871">
                                  <p style="margin-bottom: 0px;">&nbsp;</p>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table cellpadding="0" cellspacing="0" border="0" width="197">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="100">
                              <tr valign="top" align="left">
                                <td width="11" height="1"></td>
                                <td width="89"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="17"></td>
                                <td width="89" id="Text497" class="TextObject">
                                  <p style="margin-bottom: 0px;"><cfif #theQueue# GTE 1>
<b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('edit', true);" href="javascript:void();"><span style="font-size: 10px;">Select All</span></a></b>
</cfif><span style="font-size: 10px;"></span>&nbsp;</p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="97">
                              <tr valign="top" align="left">
                                <td width="8" height="1"></td>
                                <td width="89"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="89" id="Text498" class="TextObject">
                                  <p style="margin-bottom: 0px;"><cfif #theQueue# GTE 1>
<b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('edit', false);" href="javascript:void();"><span style="font-size: 10px;">None</span></a></b>
</cfif>&nbsp;</p>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="11" height="1"></td>
                          <td width="961"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="961" id="Text226" class="TextObject">
                            <p style="margin-bottom: 0px;">
<cfif #theQueue# GTE 1>



<form name="edit" action="<cfoutput>mail_queue_management_edit.cfm</cfoutput>" method="post">
<hr id="HRRule8" width="977" size="1">

<table id="Table166" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 28px;">
  <tr style="height: 30px;">
    <td width="138" id="Cell1046">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>

      
<td><input type="submit" name="action" value="Requeue Msg" style="height: 24px; width: 153px;"></td>
</form>

        </tr>
      </table>
    </td>

    <td width="138" id="Cell1047">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
     
<td><input type="submit" name="action" value="Hold Msg" style="height: 24px; width: 153px;"></td>

          
        </tr>
      </table>
    </td>
    <td width="138" id="Cell1048">
      <table width="120" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>

          <td><input type="submit" name="action" value="Delete Msg" style="height: 24px; width: 153px;"></td>

        </tr>
      </table>
    </td>
 





  </tr>
</table>
<hr id="HRRule8" width="977" size="1">

<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">
<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Select</span></b></p>
    </td>


<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Message ID</span></b></p>
    </td>


<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">On Hold</span></b></p>
    </td>

<td>

      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Date</span></b></p>
    </td>


    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">From</span></b></p>
    </td>
   
   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">To</span></b></p>
    </td>


   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Subject</span></b></p>
    </td>

<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Diagnostic Code</span></b></p>
    </td>

  



   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">View Message</span></b></p>
    </td>
   
  
    
  </tr>


<cfoutput query="getqueue">

  <tr style="height: 28px;">


     
<td align="center">
<input type="checkbox" name="cbox#msg_id#" value="cbox_#msg_id#" style="height: 13px; width: 13px;">
</td>

    <td>
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#msg_id# </span></p>
</div>
    </td>


    <td>
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#on_hold# </span></p>
</div>
    </td>

<cffile action="read" file="/opt/hermes/scripts/get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","MESSAGE-ID","#msg_id#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-FIELD","Date","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-OPTION","-qh","ALL")#" addnewline="no">



<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "240"
variable="theDate"
arguments="-inputformat none">
</cfexecute>


<!-- delete /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>


    <td>
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#htmlEditFormat(theDate)# </span></p>
</div>
    </td>

<cffile action="read" file="/opt/hermes/scripts/get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","MESSAGE-ID","#msg_id#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-FIELD","From","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-OPTION","-qh","ALL")#" addnewline="no">



<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "240"
variable="theFrom"
arguments="-inputformat none">
</cfexecute>


<!-- delete /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>





    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#htmlEditFormat(theFrom)# </span></p>
</div>
    </td>

<cffile action="read" file="/opt/hermes/scripts/get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","MESSAGE-ID","#msg_id#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-FIELD","To","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-OPTION","-qh","ALL")#" addnewline="no">



<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "240"
variable="theTo"
arguments="-inputformat none">
</cfexecute>


<!-- delete /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>


    


    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#htmlEditFormat(theTo)#</span></p>
</div>
    </td>

<cffile action="read" file="/opt/hermes/scripts/get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","MESSAGE-ID","#msg_id#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-FIELD","Subject","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-OPTION","-qh","ALL")#" addnewline="no">



<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "240"
variable="theSubject"
arguments="-inputformat none">
</cfexecute>


<!-- delete /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>




    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#theSubject#</span></p>
</div>
    </td>

<cffile action="read" file="/opt/hermes/scripts/get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","MESSAGE-ID","#msg_id#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-FIELD","Diagnostic-Code","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-OPTION","-q","ALL")#" addnewline="no">



<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "240"
variable="theCode"
arguments="-inputformat none">
</cfexecute>


<!-- delete /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>




    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#theCode#</span></p>
</div>
    </td>




<form name="viewqueuemsg" action="view_queue_message.cfm" method="post">
<input type="hidden" name="mid" value="#msg_id#">

<td>
<p style="text-align: center; margin-bottom: 0px;"><input type="image" name="FormsButton1" src="view_icon.png"></p>
</td>

</form>

</cfoutput>

        </tr>
      </table>
</form>

<cfelseif #theQueue# LT 1>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(255,0,0);">No Messages Found in the Mail Queue</span></p>
 
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