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
<title>User Main</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
<script type="text/javascript" src="js/tinymce/tinymce.min.js"></script>
<script>
tinymce.init({selector:'textarea',
readonly: true,
  toolbar: false,
  menubar: false,
  statusbar: false
});
</script>

<script language="JavaScript">
<!--

// function to load the calendar window.
function ShowCalendar(FormName, FieldName) {
  window.open("calendar.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=500,height=300");
}

//-->
</script>

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
var popupWidth = 800;
var popupHeight = 600;
var popupTop = 300;
var popupLeft = 300;
var isFullScreen = false;
var isAutoCenter = true;
var popupTarget = "popupwin_27b5";
var popupParams = "toolbar=0, scrollbars=1, menubar=0, status=0, resizable=1";

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
<body style="background-color: rgb(192,192,192); background-image: none; background-attachment: scroll; margin: 0px;" class="nof-centerBody">
<!-- DO NOT MOVE! The following AllWebMenus linking code section must always be placed right AFTER the BODY tag-->
<!-- ******** BEGIN ALLWEBMENUS CODE FOR hermes_seg_menu_users ******** -->
<script type='text/javascript'>var MenuLinkedBy='AllWebMenus [2]',awmMenuName='hermes_seg_menu_users',awmBN='FUS';awmAltUrl='';</script><script charset='UTF-8' src='./hermes_seg_menu_users.js' language='JavaScript1.2' type='text/javascript'></script><script type='text/javascript'>awmBuildMenu();</script>
<!-- ******** END ALLWEBMENUS CODE FOR hermes_seg_menu_users ******** -->
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="988">
            <tr valign="top" align="left">
              <td height="10"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="130" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion33" style="background-image: url('./top_blue_3.png'); height: 130px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="887">
                        <tr valign="top" align="left">
                          <td width="132" height="101"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="19"></td>
                          <td width="755"><!--<img id="AllWebMenusComponent1" height="19" width="755" src="./Fusion_placeholder.gif" border="0"> AllWebMenusTag='hermes_seg_menu_users.js' AWMJSPATH='./hermes_seg_menu_users.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu_users'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="311" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion7" style="background-image: url('./middle_988.png'); height: 311px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="967">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="893">
                              <tr valign="top" align="left">
                                <td width="11" height="14"></td>
                                <td width="882"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="882" id="Text291" class="TextObject"><cfoutput>
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Mail Statistics for #session.email#</span></b></p>
                                  </cfoutput></td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="74">
                              <tr valign="top" align="left">
                                <td width="49" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-user-guide/mail-statistics/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="12" height="30"></td>
                          <td valign="middle" width="956"><hr id="HRRule10" width="956" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="12" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="955">
                            <table id="Table3" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 172px;">
                              <tr style="height: 155px;">
                                <td width="955" id="Cell12">
                                  <table width="954" border="0" cellspacing="0" cellpadding="0" align="left">
                                    <tr>
                                      <td><cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH")#">


<cfquery name="getearliest" datasource="#datasource#">
SELECT min(time_iso) as earliest FROM msgs
</cfquery>

<cfif #getearliest.earliest# is "">
<cfset earliest="#datenow# #timenow#">
<cfelse>
<cfset earliest="#getearliest.earliest#">
</cfif>

<cfset maxdays = DateDiff("d", "#datenow#", "#earliest#")>

<cfparam name = "theInterval" default = "-1"> 
<cfif IsDefined("form.interval") is "True">
<cfset theInterval = form.interval>
</cfif>

<cfparam name = "show_type" default = "block"> 
<cfif IsDefined("form.type") is "True">
<cfif form.type is not "">
<cfset show_type = form.type>
</cfif></cfif> 





                                        <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion5" style="height: 155px;">
                                          <tr align="left" valign="top">
                                            <td>
                                              <table border="0" cellspacing="0" cellpadding="0" width="954">
                                                <tr valign="top" align="left">
                                                  <td colspan="2" width="612" id="Text459" class="TextObject">
                                                    <p style="margin-bottom: 0px;"><cfif #theInterval# is "-30">
<cfset theDays = #maxdays# * -1>
<form name="Table165FORM" action="" method="post">
<table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 26px;">
      <td width="165" id="Cell1017">
        <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Statistics for the past</span></p>
      </td>
      <td width="94" id="Cell1018">
        <p style="margin-bottom: 0px;">
          <select id="FormsComboBox1" name="interval" style="height: 24px;">
<cfoutput><option value="#maxdays#">#theDays# Days</option></cfoutput>

            <option value="-30" selected="selected">30 Days</option>
            <option value="-15">15 Days</option>
            <option value="-7">7 Days</option>
            <option value="-1">1 Day</option>
          </select>
        </p>
      </td>
      <td width="325" id="Cell1019">
        <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" id="FormsButton1" name="FormsButton1" value="Go" style="height: 24px; width: 175px;"></p>
      </td>
    </tr>
  </table>
  </form>

<cfelseif #theInterval# is "-15">
<cfset theDays = #maxdays# * -1>
<form name="Table165FORM" action="" method="post">
<table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 26px;">
      <td width="165" id="Cell1017">
        <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Statistics for the past</span></p>
      </td>
      <td width="94" id="Cell1018">
        <p style="margin-bottom: 0px;">
          <select id="FormsComboBox1" name="interval" style="height: 24px;">
<cfoutput><option value="#maxdays#">#theDays# Days</option></cfoutput>

            <option value="-30">30 Days</option>
            <option value="-15" selected="selected">15 Days</option>
            <option value="-7">7 Days</option>
            <option value="-1">1 Day</option>
          </select>
        </p>
      </td>
      <td width="325" id="Cell1019">
        <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" id="FormsButton1" name="FormsButton1" value="Go" style="height: 24px; width: 175px;"></p>
      </td>
    </tr>
  </table>
  </form>

<cfelseif #theInterval# is "-7">
<cfset theDays = #maxdays# * -1>
<form name="Table165FORM" action="" method="post">
<table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 26px;">
      <td width="165" id="Cell1017">
        <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Statistics for the past</span></p>
      </td>
      <td width="94" id="Cell1018">
        <p style="margin-bottom: 0px;">
          <select id="FormsComboBox1" name="interval" style="height: 24px;">
<cfoutput><option value="#maxdays#">#theDays# Days</option></cfoutput>

            <option value="-30">30 Days</option>
            <option value="-15">15 Days</option>
            <option value="-7" selected="selected">7 Days</option>
            <option value="-1">1 Day</option>
          </select>
        </p>
      </td>
      <td width="325" id="Cell1019">
        <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" id="FormsButton1" name="FormsButton1" value="Go" style="height: 24px; width: 175px;"></p>
      </td>
    </tr>
  </table>
  </form>



<cfelseif #theInterval# is "-1">
<cfset theDays = #maxdays# * -1>
<form name="Table165FORM" action="" method="post">
<table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 26px;">
      <td width="165" id="Cell1017">
        <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Statistics for the past</span></p>
      </td>
      <td width="94" id="Cell1018">
        <p style="margin-bottom: 0px;">
          <select id="FormsComboBox1" name="interval" style="height: 24px;">
            <cfoutput><option value="#maxdays#">#theDays# Days</option></cfoutput>
             <option value="-30">30 Days</option>
            <option value="-15">15 Days</option>
            <option value="-7">7 Days</option>
            <option value="-1" selected="selected">1 Day</option>
          </select>
        </p>
      </td>
      <td width="325" id="Cell1019">
        <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" id="FormsButton1" name="FormsButton1" value="Go" style="height: 24px; width: 175px;"></p>
      </td>
    </tr>
  </table>
  </form>

<cfelse>
<cfset theDays = #maxdays# * -1>
<form name="Table165FORM" action="" method="post">

<table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 26px;">
      <td width="165" id="Cell1017">
        <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Show Statistics for the past</span></p>
      </td>
      <td width="94" id="Cell1018">
        <p style="margin-bottom: 0px;">
          <select id="FormsComboBox1" name="interval" style="height: 24px;">
<cfoutput><option value="#maxdays#" selected="selected">#theDays# Days</option></cfoutput>
            <option value="-30">30 Days</option>
            <option value="-15">15 Days</option>
            <option value="-7">7 Days</option>
<option value="-1">1 Day</option>
            
          </select>
        </p>
      </td>
      <td width="325" id="Cell1019">
        <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" id="FormsButton1" name="FormsButton1" value="Go" style="height: 24px; width: 175px;"></p>
      </td>
    </tr>
  </table>
  </form>


</cfif>&nbsp;</p>
                                                  </td>
                                                  <td colspan="3"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td width="551" height="2"></td>
                                                  <td width="61"></td>
                                                  <td width="1"></td>
                                                  <td width="3"></td>
                                                  <td width="338"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td height="30" colspan="5" valign="middle" width="954"><hr id="HRRule1" width="954" size="1"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td colspan="5" height="2"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td colspan="3" width="613" id="Text455" class="TextObject"><cfset datenow=#DateFormat(Now(),"yyyy-mm-dd")#>
<cfset timenow="#TimeFormat(now(), "HH")#">
<cfset theDate=#DateFormat(DateAdd('d', #theInterval#, datenow),'yyyy-mm-dd')#>
<cfset datenow2=#DateFormat(theDate,"mm/dd/yyyy")#>

<cfoutput>
<cfquery name="getmsgtypes" datasource="#datasource#">
SELECT count(*) as msgcount, msgs.sid, msgs.spam_level, msgs.mail_id,  msgs.secret_id, msgs.time_iso, msgs.subject, msgs.from_addr, msgs.content, msgrcpt.mail_id, msgrcpt.rid, msgrcpt.ds,  msg_content_type.content_type, msg_content_type.description FROM msg_content_type LEFT JOIN msgs ON msgs.content = binary(msg_content_type.content_type) LEFT JOIN msgrcpt
ON msgrcpt.mail_id = msgs.mail_id where msgrcpt.rid='#session.owner#' and msgs.time_iso between '#theDate# 00:00:00' and '#datenow# 23:59:59' group by msg_content_type.description
</cfquery>
</cfoutput>

<cfoutput>
<cfquery name="gettotalmsgs" datasource="#datasource#">
SELECT count(*) as totalmsgs, msgs.mail_id,  msgs.time_iso, msgrcpt.rid, msgrcpt.mail_id FROM msgrcpt LEFT JOIN msgs
ON msgs.mail_id = msgrcpt.mail_id where msgrcpt.rid='#session.owner#' and msgs.time_iso between '#theDate# 00:00:00' and '#datenow# 23:59:59'
</cfquery>
                                                    <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><b>Message Statistics for past #Abs(theInterval)# Day(s) </b>(#gettotalmsgs.totalmsgs# total msgs)</span></p>
                                                    </cfoutput></td>
                                                  <td colspan="2"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td colspan="5" height="1"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td colspan="2" width="612" id="Text454" class="TextObject">
                                                    <p style="margin-bottom: 0px;"><cfoutput>
<cfchart   
    format="png"  
    chartWidth="500" 
    chartHeight="300"
    xaxistitle="Message Type"  
    yaxistitle="Total Messages" 
    showlegend="yes" 
    show3d="no"  
    showxgridlines="yes"  
    fontsize="12"  
    sortxaxis="yes"  
    showygridlines="yes"  
    gridlines="5"  
    showborder="no" 
    seriesPlacement = "stacked" 
    >  

<cfchartseries
query="getmsgtypes"   
type="pie"
itemColumn="description"
valuecolumn="msgcount">
</cfchartseries>  
</cfchart>  

</cfoutput>

&nbsp;</p>
                                                  </td>
                                                  <td colspan="3"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td colspan="5" height="22"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td width="551" id="Text456" class="TextObject"><cfoutput>
<cfquery name="getspamavg" datasource="#datasource#">
SELECT avg(msgs.spam_level) as spamavg, msgs.spam_level, msgs.mail_id,  msgs.time_iso, msgs.content, msgrcpt.mail_id, msgrcpt.rid, msg_content_type.content_type, msg_content_type.description FROM msg_content_type LEFT JOIN msgs ON msgs.content = binary(msg_content_type.content_type) LEFT JOIN msgrcpt
ON msgrcpt.mail_id = msgs.mail_id where msgrcpt.rid='#session.owner#' and msgs.time_iso between '#theDate# 00:00:00' and '#datenow# 23:59:59' and msg_content_type.user_stats = '1' group by msg_content_type.description
</cfquery>
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Message Statistics for the past #Abs(theInterval)# Day(s)</span></b></p>
                                                    </cfoutput></td>
                                                  <td colspan="4"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td colspan="5" height="3"></td>
                                                </tr>
                                                <tr valign="top" align="left">
                                                  <td colspan="4" width="616" id="Text458" class="TextObject">
                                                    <p style="margin-bottom: 0px;"><table id="Table165" border="1" cellspacing="4" cellpadding="2" width="100%" style="height: 119px;">
  <tr style="height: 18px;">
    <td width="294" style="background-color: rgb(241,236,236);">
      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Message Type</span></b></p>
    </td>
    <td width="294" style="background-color: rgb(241,236,236);">
      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Total Messages</span></b></p>
    </td>

    
  </tr>
<cfoutput query="getmsgtypes">
  <tr style="height: 18px;">

    <td>
      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#description#</span></p>
    </td>
<td>
      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">#msgcount#</span></p>
    </td>

    
  </tr>
</cfoutput>
  
</table>&nbsp;</p>
                                                  </td>
                                                  <td></td>
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
                                <td id="Cell15">
                                  <p style="margin-bottom: 0px;">&nbsp;</p>
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
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion34" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="979">
                        <tr valign="top" align="left">
                          <td width="979" height="13"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="979" id="Text464" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,255,255);"><cfset theYear=#DateFormat(Now(),"yyyy")#>
<cfquery name="getversion" datasource="#datasource#">
SELECT value from system_settings where parameter = 'version_no'
</cfquery>
<cfoutput>
<span style="font-size: 12px; color: rgb(255,255,255);">Hermes Secure Email Gateway #getversion.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved.</span></cfoutput></span>&nbsp;</p>
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