<cfparam name = "m2" default = "0">
<cfparam name = "step" default = "0">
<cfparam name = "error" default = "0">
<cfparam name = "success" default = "0">

<cfparam name = "m1" default = "0"> 
<cfif IsDefined("url.m1") is "True">
<cfif url.m1 is not "">
<cfset m1 = url.m1>
</cfif></cfif> 

<cfparam name = "domain_entry" default = ""> 
<cfif IsDefined("form.relay_domain") is "True">
<cfif form.relay_domain is not "">
<cfset domain_entry = form.relay_domain>
</cfif></cfif> 

<cfparam name = "show_type" default = "ip"> 
<cfif IsDefined("url.type") is "True">
<cfif url.type is not "">
<cfset show_type = url.type>
</cfif></cfif> 

<cfparam name = "octet1" default = ""> 
<cfif IsDefined("form.octet1") is "True">
<cfif form.octet1 is not "">
<cfset octet1 = form.octet1>
</cfif></cfif> 

<cfparam name = "octet2" default = ""> 
<cfif IsDefined("form.octet2") is "True">
<cfif form.octet2 is not "">
<cfset octet2 = form.octet2>
</cfif></cfif> 

<cfparam name = "octet3" default = ""> 
<cfif IsDefined("form.octet3") is "True">
<cfif form.octet3 is not "">
<cfset octet3 = form.octet3>
</cfif></cfif> 

<cfparam name = "octet4" default = ""> 
<cfif IsDefined("form.octet4") is "True">
<cfif form.octet4 is not "">
<cfset octet4 = form.octet4>
</cfif></cfif> 

<cfparam name = "domain" default = ""> 
<cfif IsDefined("form.domain") is "True">
<cfif form.domain is not "">
<cfset domain = form.domain>
</cfif></cfif> 

<cfparam name = "host_name" default = ""> 
<cfif IsDefined("form.host_name") is "True">
<cfif form.host_name is not "">
<cfset host_name = form.host_name>
</cfif></cfif> 

<cfparam name = "host_domain" default = ""> 
<cfif IsDefined("form.host_domain") is "True">
<cfif form.host_domain is not "">
<cfset host_domain = form.host_domain>
</cfif></cfif>


<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfif #action# is "canceladd">
<cfquery name="canceldelete" datasource="#datasource#">
delete from domains_temp where action='insert' and applied='2'
</cfquery>
<cfset step=0>
<cfset m2=12>
<cfelseif #action# is "canceldelete">
<cfquery name="canceldelete" datasource="#datasource#">
delete from domains_temp where action='delete' and applied='2'
</cfquery>
<cfset step=0>
<cfset m1=5>
</cfif>


<script>

/*
Auto tabbing script- By JavaScriptKit.com
http://www.javascriptkit.com
This credit MUST stay intact for use
*/

function autotab(original,destination){
if (original.getAttribute&&original.value.length==original.getAttribute("maxlength"))
destination.focus()
}

</script>
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
<title>Relay Domains</title>
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
              <td height="519" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion29" style="background-image: url('./middle_988.png'); height: 519px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="651">
                              <tr valign="top" align="left">
                                <td width="18" height="11"></td>
                                <td width="404"></td>
                                <td width="102"></td>
                                <td width="102"></td>
                                <td width="25"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="404" id="Text291" class="TextObject"><cfoutput>
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Relay Domains</span></b></p>
                                  </cfoutput></td>
                                <td colspan="3"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="5" height="3"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="2" width="506" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Domains &amp; Destinations</span></b></p>
                                </td>
                                <td colspan="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="5" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="4" width="633" id="Text273" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(128,128,128);">Relay Domain Destination Type</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="5" height="4"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="38"></td>
                                <td colspan="3" width="608">
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="487">
                                        <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                          <tr style="height: 19px;">
                                            <form name="LayoutRegion8FORM" action="relay_domains_new.cfm?type=ip" method="post">
                                            <td width="58" id="Cell524">
                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<cfoutput>
<input type="radio" name="type" value="ip" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="ip" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                            </form>
                                            <td width="429" id="Cell525">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">IP Address Destination</span></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 19px;">
                                            <form name="LayoutRegion8FORM" action="relay_domains_new.cfm?type=host" method="post">
                                            <td id="Cell526">
                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="margin-bottom: 0px;"><cfif #show_type# is "host">
<cfoutput>
<input type="radio" name="type" value="host" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelse>
<cfoutput>
<input type="radio" name="type" value="host" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>


&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                            </form>
                                            <td id="Cell527">
                                              <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Host Name Destination</span></p>
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
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="319">
                              <tr valign="top" align="left">
                                <td width="294" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/gateway/relay-domains/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="19" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="950"><hr id="HRRule16" width="950" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="963">
                        <tr valign="top" align="left">
                          <td width="17" height="3"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="332"></td>
                          <td width="172"></td>
                          <td width="104"></td>
                          <td width="12"></td>
                          <td width="1"></td>
                          <td width="323"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td width="332" id="Text369" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(128,128,128);">Relay Domain with IP Address Destination</span></b></p>
                          </td>
                          <td colspan="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="43"></td>
                          <td colspan="5" width="621"><cfif #show_type# is "ip">
<cfif #action# is "add">

<cfif #domain# is not "">
<cfset step=1>
<cfelseif #domain# is "">
<cfset step=0>
<cfset m2=1>
</cfif>

<cfif step is "1">
<cfset temp_email="bob@#domain#">
<cfif IsValid("email", temp_email)>
<cfset step=2>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m2=2>
</cfif>
</cfif>


<cfif step is "2">
<cfif #octet1# is not "">
<cfset octet_first = 1>
<cfset octet_last = 219>
<cfif #octet1# GTE #octet_first# AND #octet1# LTE #octet_last#>
<cfset step=3>
<cfelse>
<cfset step=0>
<cfset m2=3>
</cfif>
<cfelseif #octet1# is "">
<cfset step=0>
<cfset m2=5>
</cfif>
</cfif>

<cfif step is "3">

<cfif #octet2# is not "">
<cfset octet2_first = 0>
<cfset octet2_last = 254>
<cfif #octet2# GTE #octet2_first# AND #octet2# LTE #octet2_last#>
<cfset step=4>
<cfelse>
<cfset step=0>
<cfset m2=3>
</cfif>
<cfelseif #octet2# is "">
<cfset step=0>
<cfset m2=5>
</cfif>
</cfif>

<cfif step is "4">

<cfif #octet3# is not "">
<cfset octet3_first = 0>
<cfset octet3_last = 254>
<cfif #octet3# GTE #octet3_first# AND #octet3# LTE #octet3_last#>
<cfset step=5>
<cfelse>
<cfset step=0>
<cfset m2=3>
</cfif>
<cfelseif #octet3# is "">
<cfset step=0>
<cfset m2=5>
</cfif>
</cfif>

<cfif step is "5">

<cfif #octet4# is not "">
<cfset octet4_first = 0>
<cfset octet4_last = 254>
<cfif #octet4# GTE #octet4_first# AND #octet4# LTE #octet4_last#>
<cfset step=6>
<cfelse>
<cfset step=0>
<cfset m2=3>
</cfif>
<cfelseif #octet4# is "">
<cfset step=0>
<cfset m2=5>
</cfif>
</cfif>

<cfif step is "6">
<cfif #octet1# is "0">
<cfset step=0>
<cfset m2=3>
<cfelseif #octet1# is "127">
<cfset step=0>
<cfset m2=3>
<cfelseif #octet1# is "169" and #octet2# is "254">
<cfset step=0>
<cfset m2=3>
<cfelseif #octet1# is "192" and #octet2# is "0" and #octet3# is "2">
<cfset step=0>
<cfset m2=3>
<cfelseif #octet4# is "0">
<cfset step=0>
<cfset m2=3>
<cfelse>
<cfset step=7>
</cfif>
</cfif>



<cfif step is "7">
<cfset theAddress="#numberFormat(octet1,0)#.#numberFormat(octet2,0)#.#numberFormat(octet3,0)#.#numberFormat(octet4,0)#">

<cfquery name="checkexists" datasource="#datasource#">
select * from domains where domain='#domain#'
</cfquery>



<cfif #checkexists.recordcount# LT 1>


<!-- START -->

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


<cfquery name="add" datasource="#datasource#" result="transResult">
insert into transport
(domain,
transport,
destination,
method) 
values 
('#domain#', 
'smtp:[#theAddress#]',
'#theAddress#',
'smtp')
</cfquery>

<cfquery name="insert_senders_domain" datasource="#datasource#" result="sendersResult">
insert into senders
(sender, action) 
values 
('#domain#', 'OK')
</cfquery>

<cfquery name="insert_recipipients_domain" datasource="#datasource#" result="recResult">
insert into recipients
(recipient, domain) 
values 
('@#domain#', '1')
</cfquery>

<cfquery name="insert_hermes_domain" datasource="#datasource#">
insert into domains
(domain, transport_id, senders_id, recipients_id, action_taken) 
values 
('#domain#', '#transResult.GENERATED_KEY#', '#sendersResult.GENERATED_KEY#', '#recResult.GENERATED_KEY#', 'OK')
</cfquery>

<cffile action="read" file="/opt/hermes/scripts/add_domain_djigzo.sh" variable="adddomain">
   
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_add_domain_djigzo.sh"
    output = "#REReplace("#adddomain#","THE-DOMAIN","#domain#","ALL")#"> 

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_add_domain_djigzo.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_add_domain_djigzo.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_add_domain_djigzo.sh"> 

<cfquery name="getdomains" datasource="#datasource#">
select * from domains
</cfquery>

<cfset FileDomain = "">
<cfloop query="getdomains">
<cfset FileDomain = FileDomain & getdomains.domain & #Chr(13)#&#Chr(10)#>
</cfloop>

<cffile action = "write" file = "/etc/postfix/relay_domains" output = "#FileDomain#" addnewline="no">

<cfquery name="gettransports" datasource="#datasource#">
select * from transport
</cfquery>

<cfset FileData = "">
<cfloop query="gettransports">
<cfset FileData = FileData & gettransports.domain & #Chr(9)# & #Chr(9)# & gettransports.transport & #Chr(13)#&#Chr(10)#>
</cfloop>

<cffile action = "write" file = "/etc/postfix/transport" output = "#FileData#" addnewline="no">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_postmap.sh"
    output = "/usr/sbin/postmap /etc/postfix/transport" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_postmap.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_postmap.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_postmap.sh">

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>


<cfquery name="dropusers" datasource="#datasource#">
drop table users
</cfquery>

<cfquery name="createusers" datasource="#datasource#">
CREATE TABLE users LIKE recipients
</cfquery>

<cfquery name="copyusers" datasource="#datasource#">
INSERT INTO users SELECT * FROM recipients
</cfquery>

<cfquery name="alterusers" datasource="#datasource#">
alter table users change recipient email VARBINARY(255)
</cfquery>

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>

<!-- END -->




<cfset step=0>
<cfset m2=6>


<cfelseif #checkexists.recordcount# GTE 1>
<cfset m2=4>
</cfif>

</cfif>
</cfif>
</cfif>




                            <form name="ipaddress" action="relay_domains_new.cfm?action=add&type=ip" method="post">
                              <table border="0" cellspacing="0" cellpadding="0">
                                <tr valign="top" align="left">
                                  <td width="614"><cfoutput>
                                    <table id="Table93" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 41px;">
                                      <tr style="height: 17px;">
                                        <td width="211" id="Cell727">
                                          <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Relay Domain</span></p>
                                        </td>
                                        <td width="61" id="Cell715">
                                          <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Dest IP</span></p>
                                        </td>
                                        <td width="12" id="Cell714">
                                          <p style="margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                        <td width="61" id="Cell713">
                                          <p style="margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                        <td width="10" id="Cell712">
                                          <p style="margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                        <td width="62" id="Cell711">
                                          <p style="margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                        <td width="10" id="Cell710">
                                          <p style="margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                        <td width="62" id="Cell709">
                                          <p style="margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                        <td width="125" id="Cell707">
                                          <p style="margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                      </tr>
                                      <tr style="height: 24px;">
                                        <td id="Cell728">
                                          <table width="200" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="domain" value="#domain#" size="25" maxlength="75" style="width: 196px; white-space: pre;" onKeyup="autotab(this, document.ipaddress.octet1)">
<cfelseif #show_type# is "host">
<input type="text" name="domain" value="#domain#" size="25" maxlength="75" disabled="disabled" style="width: 196px; white-space: pre;" onKeyup="autotab(this, document.ipaddress.octet1)">
</cfif>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell530">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">
                                                <table width="48" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" id="FormsEditField45" name="octet1" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet1#" onKeyup="autotab(this, document.ipaddress.octet2)">
<cfelseif #show_type# is "host">
<input type="text" id="FormsEditField45" name="octet1" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet1#" disabled="disabled" onKeyup="autotab(this, document.ipaddress.octet2)">
</cfif>
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell545">
                                          <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                        </td>
                                        <td id="Cell531">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">
                                                <table width="48" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="octet2" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet2#" onKeyup="autotab(this, document.ipaddress.octet3)">
<cfelseif #show_type# is "host">
<input type="text" name="octet2" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet2#" disabled="disabled" onKeyup="autotab(this, document.ipaddress.octet3)">
</cfif>

&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell546">
                                          <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                        </td>
                                        <td id="Cell532">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">
                                                <table width="48" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="octet3" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet3#" onKeyup="autotab(this, document.ipaddress.octet4)">
<cfelseif #show_type# is "host">
<input type="text" name="octet3" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet3#" disabled="disabled" onKeyup="autotab(this, document.ipaddress.octet4)">
</cfif>

&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell547">
                                          <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                        </td>
                                        <td id="Cell533">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">
                                                <table width="48" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="text" name="octet4" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet4#">
<cfelseif #show_type# is "host">
<input type="text" name="octet4" size="6" maxlength="3" style="width: 44px; white-space: pre;" value="#octet4#" disabled="disabled">
</cfif>

&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell534">
                                          <table width="46" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfif #show_type# is "ip">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
<cfelseif #show_type# is "host">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
</cfif>
&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    </cfoutput></td>
                                </tr>
                              </table>
                            </form>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="10"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td width="332" id="Text377" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(128,128,128);">Releay Domain with Host Name Destination</span></b></p>
                          </td>
                          <td colspan="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="43"></td>
                          <td colspan="4" width="620"><cfif #show_type# is "host">
<cfif #action# is "add">

<cfif #domain# is not "">
<cfset step=1>
<cfelseif #domain# is "">
<cfset step=0>
<cfset m2=1>
</cfif>

<cfif step is "1">
<cfset temp_email="bob@#domain#">
<cfif IsValid("email", temp_email)>
<cfset step=2>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m2=2>
</cfif>
</cfif>

<cfif step is "2">
<cfif #host_name# is "">
<cfset step=0>
<cfset m2=7>
<cfelseif #host_name# is not "">
<cfif REFind("[^_a-zA-Z0-9-]",host_name) gt 0>
<cfset step=0>
<cfset m2=8>
<cfelse>
<cfset step=3>
</cfif>
</cfif>
</cfif>

<cfif step is "3">
<cfif #host_domain# is not "">
<cfset step=4>
<cfelseif #host_domain# is "">
<cfset step=0>
<cfset m2=9>
</cfif>
</cfif>

<cfif step is "4">
<cfset temp_email="bob@#host_domain#">
<cfif IsValid("email", temp_email)>
<cfset step=4>
<cfelseif not IsValid("email", temp_email)>
<cfset step=0>
<cfset m2=10>
</cfif>
</cfif>


<cfif step is "4">

<cfquery name="checkexists" datasource="#datasource#">
select * from domains where domain='#domain#'
</cfquery>



<cfif #checkexists.recordcount# LT 1>


<!-- START -->

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


<cfquery name="add" datasource="#datasource#" result="transResult">
insert into transport
(domain,
transport,
destination,
method) 
values 
('#domain#', 
'smtp:[#host_name#.#host_domain#]',
'#host_name#.#host_domain#',
'smtp')
</cfquery>

<cfquery name="insert_senders_domain" datasource="#datasource#" result="sendersResult">
insert into senders
(sender, action) 
values 
('#domain#', 'OK')
</cfquery>

<cfquery name="insert_recipipients_domain" datasource="#datasource#" result="recResult">
insert into recipients
(recipient, domain) 
values 
('@#domain#', '1')
</cfquery>

<cfquery name="insert_hermes_domain" datasource="#datasource#">
insert into domains
(domain, transport_id, senders_id, recipients_id, action_taken) 
values 
('#domain#', '#transResult.GENERATED_KEY#', '#sendersResult.GENERATED_KEY#', '#recResult.GENERATED_KEY#', 'OK')
</cfquery>

<cffile action="read" file="/opt/hermes/scripts/add_domain_djigzo.sh" variable="adddomain">
   
<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_add_domain_djigzo.sh"
    output = "#REReplace("#adddomain#","THE-DOMAIN","#domain#","ALL")#"> 

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_add_domain_djigzo.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_add_domain_djigzo.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_add_domain_djigzo.sh"> 


<cfquery name="getdomains" datasource="#datasource#">
select * from domains
</cfquery>

<cfset FileDomain = "">
<cfloop query="getdomains">
<cfset FileDomain = FileDomain & getdomains.domain & #Chr(13)#&#Chr(10)#>
</cfloop>

<cffile action = "write" file = "/etc/postfix/relay_domains" output = "#FileDomain#" addnewline="no">


<cfquery name="gettransports" datasource="#datasource#">
select * from transport
</cfquery>

<cfset FileData = "">
<cfloop query="gettransports">
<cfset FileData = FileData & gettransports.domain & #Chr(9)# & #Chr(9)# & gettransports.transport & #Chr(13)#&#Chr(10)#>
</cfloop>

<cffile action = "write" file = "/etc/postfix/transport" output = "#FileData#" addnewline="no">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_postmap.sh"
    output = "/usr/sbin/postmap /etc/postfix/transport" addnewline="no">


<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_postmap.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_postmap.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>


<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_postmap.sh">

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="stop">
</cfexecute>


<cfquery name="dropusers" datasource="#datasource#">
drop table users
</cfquery>

<cfquery name="createusers" datasource="#datasource#">
CREATE TABLE users LIKE recipients
</cfquery>

<cfquery name="copyusers" datasource="#datasource#">
INSERT INTO users SELECT * FROM recipients
</cfquery>

<cfquery name="alterusers" datasource="#datasource#">
alter table users change recipient email VARBINARY(255)
</cfquery>

<cfexecute name = "/etc/init.d/postfix"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>

<cfexecute name = "/etc/init.d/amavis"
timeout = "240"
outputfile ="/dev/null"
arguments="start">
</cfexecute>


<!-- END -->

<cfset step=0>
<cfset m2=6>



<cfelseif #checkexists.recordcount# GTE 1>
<cfset m2=4>
</cfif>

</cfif>
</cfif>
</cfif>




                            <form name="host" action="relay_domains_new.cfm?action=add&type=host" method="post">
                              <table border="0" cellspacing="0" cellpadding="0">
                                <tr valign="top" align="left">
                                  <td width="614"><cfoutput>
                                    <table id="Table100" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 41px;">
                                      <tr style="height: 17px;">
                                        <td width="207" id="Cell729">
                                          <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Relay Domain</span></p>
                                        </td>
                                        <td width="135" id="Cell730">
                                          <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Dest Host Name</span></p>
                                        </td>
                                        <td width="12" id="Cell747">
                                          <p style="margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                        <td width="173" id="Cell736">
                                          <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Dest Host Domain</span></p>
                                        </td>
                                        <td width="87" id="Cell737">
                                          <p style="margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                      </tr>
                                      <tr style="height: 24px;">
                                        <td id="Cell738">
                                          <table width="195" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfif #show_type# is "host">
<input type="text" name="domain" value="#domain#" size="25" maxlength="75" style="width: 196px; white-space: pre;" onKeyup="autotab(this, document.host.host)">
<cfelseif #show_type# is "ip">
<input type="text" name="domain" value="#domain#" size="25" maxlength="75" disabled="disabled" style="width: 196px; white-space: pre;" onKeyup="autotab(this, document.host.host)">
</cfif>&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell739">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">
                                                <table width="116" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_type# is "host">
<input type="text" name="host_name" value="#host_name#" size="15" maxlength="50" style="width: 116px; white-space: pre;" onKeyup="autotab(this, document.host.host_domain)">
<cfelseif #show_type# is "ip">
<input type="text" name="host_name" value="#host_name#" size="15" maxlength="50" style="width: 116px; white-space: pre;" onKeyup="autotab(this, document.host.host_domain)" disabled="disabled">
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell748">
                                          <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                        </td>
                                        <td id="Cell745">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">
                                                <table width="160" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><cfif #show_type# is "host">
<input type="text" name="host_domain" value="#host_domain#" size="20" maxlength="50" style="width: 160px; white-space: pre;">
<cfelseif #show_type# is "ip">
<input type="text" name="host_domain" value="#host_domain#" size="20" maxlength="50" style="width: 160px; white-space: pre;" disabled="disabled">
</cfif>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell746">
                                          <table width="46" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;"><cfif #show_type# is "host">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
<cfelseif #show_type# is "ip">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 46px;" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
</cfif>
&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    </cfoutput></td>
                                </tr>
                              </table>
                            </form>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="4" width="609" id="Text277" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Relay Domain field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Relay Domain you are attempting to add is invalid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination IP address you attempting to add is not valid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Relay Domain you are attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination IP address fields cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Relay Domain & Destination has been added. </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination Host Name field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination Host Name you are attempting to add is invalid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination Host Domain field cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination Host Domain you are attempting to add is invalid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Relay Domain & Destination you are attempting to add is already marked for addition</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All add requests have been cancelled</span></i></b></p>
</cfoutput>
</cfif>

&nbsp;</p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="7" valign="middle" width="945"><hr id="HRRule17" width="945" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="4" width="506" id="Text419" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Edit/Delete Domains &amp; Destinations</span></b></p>
                          </td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="8" width="946" id="Text464" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfquery name="get_domains" datasource="#datasource#">
select * from domains order by domain asc
</cfquery>

<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">

    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Domain</span></b></p>
    </td>
   
   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Destination</span></b></p>
    </td>


   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Edit</span></b></p>
    </td>

   <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Delete</span></b></p>
    </td>
   
  
    
  </tr>


<cfoutput query="get_domains">

  <tr style="height: 28px;">


     




    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#domain# </span></p>
</div>
    </td>
    

<cfquery name="gettransports" datasource="#datasource#">
select domain, destination from transport where domain='#domain#'
</cfquery>

    <td id="Cell1059">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">#gettransports.destination#</span></p>
</div>
    </td>


<form name="editdomain" action="edit_relay_domain.cfm" method="post">
<input type="hidden" name="id" value="#id#"><input type="hidden" name="domain" value="#domain#">
<td align="center"><input type="image" id="FormsButton13" name="configure" src="configure_icon.png"></td>
</form>

<cfquery name="checkrecipients" datasource="#datasource#">
select * from recipients where recipient like '%#domain#%' and domain is NULL
</cfquery>

<cfquery name="checkvirtual" datasource="#datasource#">
select * from virtual where virtual like '%#domain#%'
</cfquery>

<cfquery name="checkpostmaster" datasource="#datasource#">
select parameter, value from system_settings where parameter = 'postmaster' and value like '%#domain#%'
</cfquery>

<cfif #checkrecipients.recordcount# GTE 1>

<td>
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Cannot delete. Must remove existing internal recipients assigned to domain </span></p>
</div>
</td>

<cfelseif #checkvirtual.recordcount# GTE 1>
<td>
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Cannot delete. Must remove existing virtual recipients assigned to domain </span></p>
</div>
</td>

<cfelseif #checkpostmaster.recordcount# GTE 1>
<td>
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">Cannot delete. Must change postmaster address to another domain </span></p>
</div>
</td>




<cfelse>
<form name="deletedomain" action="delete_domain.cfm" method="post">
<input type="hidden" name="id" value="#id#"><input type="hidden" name="domain" value="#domain#">
<td align="center"><input type="image" id="FormsButton13" name="delete" src="delete_icon.png"></td>
</form>
</cfif>





</cfoutput>
        </tr>
      </table>&nbsp;</p>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="8" width="946" id="Text276" class="TextObject">
                            <p style="margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry to delete before clicking the Delete button</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The domain you selected is already marked for deletion</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Domain marked for deletion. Please click the Apply Settings button below to apply your changes</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m1# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You cannot delete a domain that has recipients and/or virtual users. Please delete the recipients and/or virtual users first</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You cannot delete a domain that is associated with the postmaster account under system settings. Change the postmaster account to a different domain and try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All delete requests have been cancelled</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! Relay  domain deleted</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! Relay  domain edited</span></i></b></p>
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