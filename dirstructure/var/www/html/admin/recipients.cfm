<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
 
 --->
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Internal Recipients</title>
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
<body style="background-color: rgb(192,192,192); background-attachment: scroll; margin: 0px;" class="nof-centerBody">
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
              <td width="1" height="10"></td>
              <td></td>
            </tr>
            <tr valign="top" align="left">
              <td height="131" colspan="2" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion32" style="background-image: url('./top_blue_3.png'); height: 131px;">
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
              <td height="782"></td>
              <td width="987">
                <table border="0" cellspacing="0" cellpadding="0" width="987" id="LayoutRegion16" style="background-image: url('./middle_988.png'); height: 782px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="969">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="517">
                              <tr valign="top" align="left">
                                <td width="10" height="13"></td>
                                <td width="1"></td>
                                <td width="505"></td>
                                <td width="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="2" width="506" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Internal Recipients</span></b></p>
                                </td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="4" height="5"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2"></td>
                                <td colspan="2" width="506" id="Text482" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Internal Recipients</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="452">
                              <tr valign="top" align="left">
                                <td width="427" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/gateway/internal-recipients/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="971">
                        <tr valign="top" align="left">
                          <td width="10" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="368"></td>
                          <td width="961"><cfparam name = "m1" default = "0">
<cfparam name = "m2" default = "0">
<cfparam name = "m3" default = "0">
<cfparam name = "m4" default = "0">
<cfparam name = "step" default = "0"> 
<cfparam name = "error" default = "0">
<cfparam name = "success" default = "0">
<cfparam name = "usercount" default = "0">
<cfparam name = "rcptcount" default = "0">

<cfparam name = "m4" default = ""> 
<cfif IsDefined("url.m4") is "True">
<cfif url.m4 is not "">
<cfset m4 = url.m4>
</cfif></cfif>  

<cfparam name = "action" default = ""> 
<cfif IsDefined("url.action") is "True">
<cfif url.action is not "">
<cfset action = url.action>
</cfif></cfif> 

<cfparam name = "show_type" default = "manual"> 
<cfif IsDefined("url.type") is "True">
<cfif url.type is not "">
<cfset show_type = url.type>
</cfif></cfif>



<cfparam name = "show_connection" default = ""> 
<cfif IsDefined("form.adconnection") is "True">
<cfif form.adconnection is not "">
<cfset show_connection = form.adconnection>
</cfif></cfif>

<cfparam name = "show_recipient" default = ""> 
<cfif IsDefined("form.recipient") is "True">
<cfif form.recipient is not "">
<cfset show_recipient = #LCase(FORM.recipient)#>
</cfif></cfif>

<cfif #action# is "add">
<cfif #show_type# is "ad">
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

<cfquery name="getad_connection" datasource="#datasource#">
select * from ad_integration where id='#show_connection#'
</cfquery>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="theKey">

<cfset decryptedUsername=decrypt(getad_connection.username, #theKey#, "AES", "Base64")>
<cfset decryptedPassword=decrypt(getad_connection.password, #theKey#, "AES", "Base64")>

<cftry>
<cfldap action="query"
name="adresult"
attributes = "mail"
START="#getad_connection.fqdn_domain#"
filter="(&(objectClass=#getad_connection.objectclass#)(mail=*))"
server="#getad_connection.dc_name#"
port="389"
username="#getad_connection.netbios_domain#\#decryptedUsername#"
password="#decryptedPassword#">

<cfcatch type="any">

<cfif #cfcatch.type# contains "javax.naming.AuthenticationException">
<cfset step=0>
<cfset m2=7>
<cfelseif #cfcatch.type# contains "javax.naming.CommunicationException">
<cfset step=0>
<cfset m2=8>
<cfelseif #cfcatch.type# contains "javax.naming.InvalidNameException">
<cfset step=0>
<cfset m2=9>
<cfelseif #cfcatch.type# contains "javax.naming.NamingException">
<cfset step=0>
<cfset m2=9> 	
<cfelse>
<cfset step=0>
<cfset m2=11>
</cfif>

</cfcatch>

<cfif #adresult.recordcount# LT 1>
<cfset step=0>
<cfset m2=10>
<cfelseif #adresult.recordcount# GTE 1>
<cfset step=1>
</cfif>

</cftry>

<cfif #step# is "1">

<cfset FileData = "">
<cfloop query="adresult">
<cfset FileData = FileData & mail & #chr(10)#>
</cfloop>

<cffile action = "write" file = "/opt/hermes/tmp/#customtrans3#_temp" output = "#FileData#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_temp" variable="variables.myFile">

<!---
<cffile
    action = "delete"
    file = "/opt/hermes/tmp/#customtrans3#_temp">
    --->

<cfloop index="curLine" list="#variables.myFile#" delimiters="#chr(10)#">
<cfset success=#success#+1>
<cfset domainpart = #trim(ListGetAt(curline, 2, "@"))#>
<cfquery name="checkdomain" datasource="#datasource#">
select domain from domains where domain='#domainpart#'
</cfquery>

<cfif #checkdomain.recordcount# GTE 1>
<cfquery name="checkentry" datasource="#datasource#">
select recipient from recipients where recipient='#curline#'
</cfquery>

<cfif #checkentry.recordcount# LT 1>
<cfquery name="getlicensedusers" datasource="#datasource#">
select parameter, value from system_settings where parameter='users'
</cfquery>

<cfif #getlicensedusers.value# GTE 1>
<cfset usercount=#getlicensedusers.value#>
<cfelseif #getlicensedusers.value# LT 1>
<cfset usercount=0>
</cfif>

<cfquery name="countrecipients" datasource="#datasource#">
select count(recipient) as rcptcount from recipients where domain is NULL
</cfquery>

<cfif #countrecipients.rcptcount# GTE 1>
<cfset rcptcount1=#countrecipients.rcptcount#>
<cfelseif #countrecipients.rcptcount# LT 1>
<cfset rcptcount1=0>
</cfif>

<cfquery name="counttemprecipients" datasource="#datasource#">
select count(recipient) as temp_rcptcount from recipients_temp where action='insert' and applied='2'
</cfquery>

<cfif #counttemprecipients.temp_rcptcount# GTE 1>
<cfset rcptcount2=#counttemprecipients.temp_rcptcount#>
<cfelseif #counttemprecipients.temp_rcptcount# LT 1>
<cfset rcptcount2=0>
</cfif>

<cfset rcptcount=#rcptcount1# + #rcptcount2#>

<cfif #usercount# GTE #rcptcount#>
<cfquery name="checktemp" datasource="#datasource#">
select recipient from recipients_temp where recipient='#curline#'
</cfquery>

<cfif #checktemp.recordcount# LT 1>
<cfquery name="insert" datasource="#datasource#">
insert into recipients_temp
(policy_id, recipient, status, applied, action)
values 
('7', '#LCase(curLine)#', 'OK', '2', 'insert')
</cfquery>
</cfif>

<cfelseif #usercount# LT #rcptcount#>
<cfset error=#error#+1>
</cfif>

</cfif>

<cfelseif #checkdomain.recordcount# LT 1>
<cfset error=#error#+1>
</cfif>
</cfloop>
<cfset step=0>
<cfset m2=3>

</cfif>


<cfelseif #show_type# is "manual">

<cfif #show_recipient# is not "">
<cfif IsValid("email", show_recipient)>
<cfset domainpart = #trim(ListGetAt(show_recipient, 2, "@"))#>
<cfquery name="checkdomain" datasource="#datasource#">
select domain from domains where domain='#domainpart#'
</cfquery>
<cfif #checkdomain.recordcount# GTE 1>
<cfset step=1>
<cfelseif #checkdomain.recordcount# LT 1>
<cfset step=0>
<cfset m2=5>
</cfif>
<cfelseif not IsValid("email", show_recipient)>
<cfset step=0>
<cfset m2=2>
</cfif>

<cfelseif #show_recipient# is "">
<cfset step=0>
<cfset m2=4>
</cfif>



<cfif #step# is "1">
<cfquery name="checkrecipient" datasource="#datasource#">
select recipient from recipients where recipient='#show_recipient#'
</cfquery>


<cfif #checkrecipient.recordcount# LT 1>
<cfquery name="getlicensedusers" datasource="#datasource#">
select parameter, value from system_settings where parameter='users'
</cfquery>

<cfif #getlicensedusers.value# GTE 1>
<cfset usercount=#getlicensedusers.value#>
<cfelseif #getlicensedusers.value# LT 1>
<cfset usercount=0>
</cfif>

<cfquery name="countrecipients" datasource="#datasource#">
select count(recipient) as rcptcount from recipients where domain is NULL
</cfquery>

<cfif #countrecipients.rcptcount# GTE 1>
<cfset rcptcount1=#countrecipients.rcptcount#>
<cfelseif #countrecipients.rcptcount# LT 1>
<cfset rcptcount1=0>
</cfif>

<cfquery name="counttemprecipients" datasource="#datasource#">
select count(recipient) as temp_rcptcount from recipients_temp where action='insert' and applied='2'
</cfquery>

<cfif #counttemprecipients.temp_rcptcount# GTE 1>
<cfset rcptcount2=#counttemprecipients.temp_rcptcount#>
<cfelseif #counttemprecipients.temp_rcptcount# LT 1>
<cfset rcptcount2=0>
</cfif>

<cfset rcptcount=#rcptcount1# + #rcptcount2#>

<cfif #usercount# GTE #rcptcount#>
<cfquery name="checktemp" datasource="#datasource#">
select recipient from recipients_temp where recipient='#show_recipient#'
</cfquery>

<cfif #checktemp.recordcount# LT 1>

<cfquery name="insert" datasource="#datasource#">
insert into recipients_temp
(policy_id, recipient, status, applied, action)
values 
('7', '#show_recipient#', 'OK', '2', 'insert')
</cfquery>
<cfset m2=6>
</cfif>

<cfelseif #usercount# LT #rcptcount#>
<cfset step=0>
<cfset m2=13>
</cfif>
<cfelseif #checkrecipient.recordcount# GTE 1>
<cfset m2=1>
</cfif>
</cfif>

</cfif>
<cfelseif #action# is "canceladd">
<cfquery name="canceldelete" datasource="#datasource#">
delete from recipients_temp where action='insert' and applied='2'
</cfquery>
<cfset step=0>
<cfset m2=12>
</cfif>
                            <table border="0" cellspacing="0" cellpadding="0" width="961" id="LayoutRegion5" style="height: 368px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="961">
                                    <tr valign="top" align="left">
                                      <td width="961" id="Text333" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">Select whether to import Internal Recipients from Active Directory or manually add. Import from Active Directory is only enabled if there are existing Active Directory connections. Connections can be added in the <a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;" href="ad_integration.cfm">Active Directory Connections</a> section.</span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="617">
                                    <tr valign="top" align="left">
                                      <td width="290" height="8"></td>
                                      <td width="318"></td>
                                      <td width="9"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="38" colspan="2" width="608">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="487">
                                              <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                <tr style="height: 19px;">
                                                  <form action="recipients.cfm?type=manual" method="post">
                                                  <td width="58" id="Cell524">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfif #show_type# is "manual">
<cfoutput>
<input type="radio" name="type" value="manual" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelseif #show_type# is not "manual">
<cfoutput>
<input type="radio" name="type" value="manual" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>

&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td width="429" id="Cell525">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Manually Add</span></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form action="recipients.cfm?type=ad" method="post">
                                                  <td id="Cell526">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;"><cfquery name="getadconnections" datasource="#datasource#">
select * from ad_integration order by entry_name asc
</cfquery>
<cfif #getadconnections.recordcount# GTE 1>
<cfif #show_type# is "ad">
<cfoutput>
<input type="radio" name="type" value="ad" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
<cfelseif #show_type# is not "ad">
<cfoutput>
<input type="radio" name="type" value="ad" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
</cfoutput>
</cfif>
<cfelseif #getadconnections.recordcount# LT 1>
<cfoutput>
<input type="radio" name="type" value="ad" disabled="disabled" style="height: 19px; width: 19px;"/>
</cfoutput>
</cfif>


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell527">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Import from Active Directory</span></p>
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
                                      <td colspan="3" height="14"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text369" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Manually Add Internal Recipient</span></b></p>
                                      </td>
                                      <td colspan="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="3" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="50" colspan="3" width="617">
                                        <form name="addbutton" action="<cfoutput>recipients.cfm?action=add&type=#show_type#</cfoutput>" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="609">
                                                <table id="Table124" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 21px;">
                                                  <tr style="height: 17px;">
                                                    <td width="256" id="Cell730">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Internal Recipient E-mail Address</span></p>
                                                    </td>
                                                    <td width="353" id="Cell732">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 23px;">
                                                    <td id="Cell733">
                                                      <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td><input type="text" id="FormsEditField40" name="recipient" size="30" maxlength="255" style="width: 236px; white-space: pre;"></td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell735">
                                                      <table width="72" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "manual">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 60px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
<cfelseif #show_type# is not "manual">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Add" style="height: 24px; width: 60px;" disabled="disabled">
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
                                        </form>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="3" height="13"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text370" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Import Internal Recipients from Active Directory</span></b></p>
                                      </td>
                                      <td colspan="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="3" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="50" colspan="3" width="617">
                                        <form name="addbutton" action="<cfoutput>recipients.cfm?action=add&type=#show_type#</cfoutput>" method="post">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="609">
                                                <table id="Table123" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 21px;">
                                                  <tr style="height: 17px;">
                                                    <td width="194" id="Cell715">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Import from Active Directory Connection</span></p>
                                                    </td>
                                                    <td width="415" id="Cell713">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 23px;">
                                                    <td id="Cell710">
                                                      <table width="164" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ad">
<cfif #getadconnections.recordcount# GTE 1>
<select name="adconnection" style="height: 24px;">
<cfoutput query="getadconnections">
<option value="#id#">#entry_name#</option>
</cfoutput>
</select>
<cfelseif #getadconnections.recordcount# LT 1>
<select name="adconnection" style="height: 24px;" disabled="disabled">
<cfoutput query="getadconnections">
<option value="#id#">#entry_name#</option>
</cfoutput>
</select>
</cfif>
<cfelseif #show_type# is not "ad">
<select name="adconnection" style="height: 24px;" disabled="disabled">
<option value=""></option>
</cfif>&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                    <td id="Cell712">
                                                      <table width="72" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><cfif #show_type# is "ad">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Import" style="height: 24px; width: 60px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
<cfelseif #show_type# is not "ad">
<input type="submit" id="FormsButton6" name="FormsButton6" value="Import" style="height: 24px; width: 60px;" disabled="disabled">
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
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="961">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="961"><hr id="HRRule1" width="961" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="609">
                                    <tr valign="top" align="left">
                                      <td width="290" height="13"></td>
                                      <td width="319"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text375" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Internal Recipients to be added</span></b></p>
                                      </td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" colspan="2" width="609" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfquery name="get_recipients2" datasource="#datasource#">
select id, recipient from recipients_temp where action='insert' and applied='2' order by recipient asc
</cfquery>
<cfif #get_recipients2.recordcount# GTE 1>
<select name="recipients2" style="height: 88px;" size="60" disabled="disabled">
<cfoutput query="get_recipients2">
<option value="#id#">#recipient# ---> TO BE ADDED</option>
</cfoutput>
</select>
<cfelse>
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No recipients found to be added..</span></p>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="961">
                                        <form name="Table127FORM" action="recipients.cfm?action=canceladd" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="961" id="Cell738">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfif #get_recipients2.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_recipients2.recordcount# LT 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" disabled="disabled">
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
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="961">
                                    <tr valign="top" align="left">
                                      <td width="961" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="961" id="Text277" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m2# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The recipient you are attempting to add already exists</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the recipient you are attempting to add is not valid</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Recipients downloaded from Active Directory and marked for import. Click the Apply Settings button to import the recipients into the system</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The recipient cannot be empty</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Adding an e-mail address for a domain that the system does not relay is not allowed. Please check the domain of the e-mail address and try again or add the domain in the Relay Domains & Destinations</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Recipient ready to be added. Please click the Apply Settings to add the recipient to the system and apply your changes</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m2# is "7">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Domain Username and/or Password. Plese try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "8">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Domain Controller cannot be reached. Please check the IP/Host Name and ensure it's reachable via port 389</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "9">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Domain Distinguished Name Root you entered is invalid. Please check your entry and try again</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m2# is "10">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Unable to retrieve any SMTP addresses from Active Directory. Please check that you have entered the correct Domain Distinguished Name Root and try again</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "11">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;An undefined error has occured. Please contact support</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "12">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All add requests have been cancelled</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m2# is "13">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have exceeded the licensed numbers of recipients. You may not add more recipients until you purchase more recipient licenses.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m4# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have exceeded the licensed numbers of recipients. You may not add more recipients until you purchase more recipient licenses.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #error# GT 0>
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Some errors occured while downloading SMTP Addresses from Active Directory. #error# out of #success# SMTP addresses did not get downloaded succesfully. This is usually caused by SMTP addresses with domains that the system does not relay or you have exceeded the amount of licensed recipients.</span></i></b></p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="9" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="963"><hr id="HRRule2" width="963" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="9" height="2"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="453"></td>
                          <td width="1"></td>
                          <td width="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="70"></td>
                          <td colspan="5" width="963"><cfparam name = "filter" default = ""> 
<cfif IsDefined("url.filter") is "True">
<cfif url.filter is not "">
<cfset filter = url.filter>
</cfif></cfif>

<cfif #filter# is "">
<cfquery name="getintrecipients" datasource="#datasource#">
select * from recipients where domain is NULL order by recipient asc
</cfquery>
<cfelseif #filter# is not "">
<cfif REFind("[^_a-zA-Z0-9-.@]",filter) gt 0>
<cflocation url="error.cfm">
<cfelse>
<cfquery name="checkkeywords" datasource="#datasource#">
SELECT * FROM keywords where keyword IN ('#filter#') and banned='1'
</cfquery>
</cfif>
<cfif #checkkeywords.recordcount# LT 1>
<cfquery name="getintrecipients" datasource="#datasource#">
select * from recipients where domain is NULL and recipient like '%#filter#%' order by recipient asc
</cfquery>
<cfelseif #checkkeywords.recordcount# GTE 1>
<cflocation url="error.cfm">
</cfif>
</cfif>



                            <table border="0" cellspacing="0" cellpadding="0" width="963" id="LayoutRegion21" style="height: 70px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table cellpadding="0" cellspacing="0" border="0" width="624">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="8" height="8"></td>
                                            <td></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td></td>
                                            <td width="430">
                                              <form name="Table144FORM" action="recipients_filter.cfm#delete" method="post">
                                                <input type="hidden" name="setfilter" value="1">
                                                <table id="Table144" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 25px;">
                                                  <tr style="height: 25px;">
                                                    <td width="56" id="Cell864">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Filter By</span></p>
                                                    </td>
                                                    <td width="258" id="Cell865">
                                                      <p style="margin-bottom: 0px;"><cfoutput><input type="text" id="FormsEditField41" name="filter" size="29" maxlength="29" style="width: 228px; white-space: pre;" value="#filter#"></cfoutput></p>
                                                    </td>
                                                    <td width="116" id="Cell866">
                                                      <table width="110" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Set Filter" style="height: 24px; width: 87px;">&nbsp;</p>
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
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="8" height="8"></td>
                                            <td></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td></td>
                                            <td width="178">
                                              <form name="Table145FORM" action="recipients_filter.cfm#delete" method="post">
                                                <input type="hidden" name="clearfilter" value="1">
                                                <table id="Table145" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="178" id="Cell868">
                                                      <table width="153" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Clear Filter" style="height: 24px; width: 105px;">&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="617">
                                    <tr valign="top" align="left">
                                      <td width="7" height="7"></td>
                                      <td width="610"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="610" id="Text381" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m4# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field cannot be blank</span></i></b></p>
</cfoutput>
</cfif>


<cfif #m4# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field must only contain letters, numbers, underscores, dashes, @ symbols and periods</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m4# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field contains banned keywords. Keywords such as Select, Update, Delete etc. are not allowed</span></i></b></p>
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
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text410" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Existing Internal Recipients</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="105"></td>
                          <td colspan="3" width="960"><CFPARAM NAME="StartRow" DEFAULT="1">
<CFSET DisplayRows = 10>
<CFSET ToRow = StartRow + (DisplayRows - 1)>
<CFIF ToRow GT getintrecipients.RecordCount>
<CFSET ToRow = getintrecipients.RecordCount>
</CFIF>

<CFSET Next = StartRow + DisplayRows>
<CFSET Previous = StartRow - DisplayRows>


<cfparam name = "recipients_entry" default = ""> 
<cfif IsDefined("form.id") is "True">
<cfif form.id is not "">
<cfset recipients_entry = form.id>
</cfif></cfif> 


<cfif #action# is "delete">
<cfif #recipients_entry# is not "">
<cfset step=1>
<cfelseif #recipients_entry# is "">
<cfset step=0>
<cfset m1=1>
</cfif>

<cfif #step# is "1">

<cfquery name="getrecipient" datasource="#datasource#">
select * from recipients where id='#recipients_entry#'
</cfquery>

<cfquery name="checkrecipient" datasource="#datasource#">
select recipient from recipients_temp where recipient='#getrecipient.recipient#'
</cfquery>

<cfif #checkrecipient.recordcount# LT 1>
<cfquery name="getcount" datasource="#datasource#">
select count(id) as count from recipients_temp where action='delete'
</cfquery>
<cfif #getcount.count# GTE 10>
<cfset step=0>
<cfset m1=6>

<cfelseif #getcount.count# LT 10>

<cfquery name="inserttemp" datasource="#datasource#">
insert into recipients_temp
(recipient, applied, action, delete_id)
values
('#getrecipient.recipient#', '2', 'delete', '#recipients_entry#')
</cfquery>

<cfset step=0>
<cfset m1=2>

<cfquery name="checkcerts" datasource="#datasource#">
select * from recipient_certificates where user_id='#recipients_entry#'
</cfquery>

<cfquery name="checkkeys" datasource="#datasource#">
select * from recipient_keystores where user_id='#recipients_entry#'
</cfquery>

<cfif #checkcerts.recordcount# GTE 1>
<cfset m3=5>
</cfif>

<cfif #checkkeys.recordcount# GTE 1>
<cfset m4=5>
</cfif>


</cfif>



<cfelseif #checkrecipient.recordcount# GTE 1>
<cfset step=0>
<cfset m1=3>

</cfif>
</cfif>


<cfelseif #action# is "canceldelete">
<cfquery name="canceldelete" datasource="#datasource#">
delete from recipients_temp where action='delete' and applied='2'
</cfquery>
<cfset step=0>
<cfset m1=4>
</cfif>

                            <table border="0" cellspacing="0" cellpadding="0" width="960" id="LayoutRegion4" style="height: 105px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="959">
                                        <table id="Table147" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="456" id="Cell869">
                                              <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="margin-bottom: 0px;"><CFOUTPUT>
<CFIF Previous GTE 1>
<A HREF="recipients.cfm?StartRow=#Previous#&DisplayRows=#DisplayRows#&filter=#filter###delete"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous #DisplayRows# Recipients</SPAN></b></P>
</A>
<CFELSE>
 
</CFIF>
</cfoutput>&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                            <td width="9" id="Cell870">
                                              <p style="margin-bottom: 0px;">&nbsp;</p>
                                            </td>
                                            <td width="494" id="Cell871">
                                              <table width="234" border="0" cellspacing="0" cellpadding="0" align="right">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="text-align: right; margin-bottom: 0px;"><cfoutput>
<CFIF Next LTE getintrecipients.RecordCount>
<A HREF="recipients.cfm?StartRow=#Next#&DisplayRows=#DisplayRows#&filter=#filter###delete"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next<CFIF (getintrecipients.RecordCount - Next) LT DisplayRows>
      #Evaluate((getintrecipients.RecordCount - Next)+1)#
    <CFELSE>
      #DisplayRows#
    </CFIF>Recipients&nbsp; &gt;&gt;</SPAN></b></P></A>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="960">
                                    <tr valign="top" align="left">
                                      <td width="960" height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="960" id="Text378" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #getintrecipients.recordcount# GTE 1>
<cfoutput>
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying #StartRow# through #toRow# out of #getintrecipients.recordcount# total internal recipients. Internal recipients shown in bold red are marked for deletion.</span></p>
</cfoutput>
<cfelse>
</cfif>&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="960">
                                    <tr valign="top" align="left">
                                      <td width="960" height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="960" id="Text407" class="TextObject">
                                        <p style="text-align: center; margin-bottom: 0px;"><cfif #getintrecipients.recordcount# LT 1>
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No Internal Recipients were found with the filter criteria you specified or you do not have any internal recipients added to the system...</span></i></b></p>

<cfelseif #getintrecipients.recordcount# GTE 1>
<table id="Table131" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;">
  <tr style="height: 14px;">
    <td width="391" style="background-color: rgb(241,236,236);" id="Cell792">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Recipient</span></b></p>
    </td>
<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Recipient Settings</span></b></p>
    </td>

<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Report Settings</span></b></p>
    </td>


    <td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Delete</span></b></p>
    </td>
  </tr>

<cfoutput query="getintrecipients" STARTROW="#StartRow#" MAXROWS="#DisplayRows#">
<cfquery name="checkdeletion" datasource="#datasource#">
select recipient from recipients_temp where recipient='#recipient#' and action='delete' and applied='2'
</cfquery>
  <tr style="height: 19px;">
    <td id="Cell798">
      
        
<cfif #checkdeletion.recordcount# GTE 1>
        <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><b>#recipient#</span></p></b>
<cfelseif #checkdeletion.recordcount# LT 1>
        <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">#recipient#</span></p>
</cfif>
      
    </td>



<td id="Cell802">
      <form name="editreport" action="recipient_settings.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter###delete" method="post">
<input type="hidden" name="recipient" value="#recipient#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
<cfif #checkdeletion.recordcount# GTE 1>

            <td align="center"><input type="image" disabled="disabled" name="FormsButton1" src="configure_icon_off.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
<cfelseif #checkdeletion.recordcount# LT 1>
<td align="center"><input type="image" name="FormsButton1" src="configure_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
</cfif>

          </tr>
        </table>
      </form>
    </td>



<td id="Cell802">
      <form name="editreport" action="recipient_reports.cfm?StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter###delete" method="post">
<input type="hidden" name="recipient" value="#recipient#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
<cfif #checkdeletion.recordcount# GTE 1>

            <td align="center"><input type="image" disabled="disabled" name="FormsButton1" src="configure_icon_off.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
<cfelseif #checkdeletion.recordcount# LT 1>
<td align="center"><input type="image" name="FormsButton1" src="configure_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
</cfif>

          </tr>
        </table>
      </form>
    </td>

    <td id="Cell802">
      <form name="Cell802FORM" action="recipients.cfm?action=delete&StartRow=#StartRow#&DisplayRows=#DisplayRows#&filter=#filter###delete" method="post">
<input type="hidden" name="id" value="#id#">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
<cfif #checkdeletion.recordcount# GTE 1>

            <td align="center"><input type="image" disabled="disabled" name="FormsButton1" src="delete_icon_off.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
<cfelseif #checkdeletion.recordcount# LT 1>
<td align="center"><input type="image" name="FormsButton1" src="delete_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
</cfif>

          </tr>
        </table>
      </form>
    </td>
  </tr>
</cfoutput>
</table>
</cfif>
    &nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="960">
                                        <form name="Table127FORM" action="<cfoutput>recipients.cfm?action=canceldelete&filter=#filter###delete</cfoutput>" method="post">
                                          <table id="Table127" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="960" id="Cell737">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfquery name="get_recipients3" datasource="#datasource#">
select id, recipient from recipients_temp where action='delete' and applied='2' order by recipient asc
</cfquery>
<cfif #get_recipients3.recordcount# GTE 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
<cfelseif #get_recipients3.recordcount# LT 1>
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" disabled="disabled">
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
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="960">
                                    <tr valign="top" align="left">
                                      <td width="960" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="960" id="Text276" class="TextObject">
                                        <p style="margin-bottom: 0px;"><cfif #m1# is "1">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You must select an entry before clicking the Delete button</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "2">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Recipient marked for deletion. Please click the Apply Settings button below to apply your changes</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "3">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The recipient you selected is already marked for deletion</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "4">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All delete requests have been cancelled</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m1# is "6">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;No more than 10 internal recipients can be marked for deletion at any given time. Please click the Apply Settings button below for the changes to take effect and then mark additional internal recipients for deletion </span></i></b></p>
</cfoutput>
</cfif>

<cfif #m3# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The recipient you selected has S/MIME certificate(s) assigned. Deleting the recipient will also delete all certificates assigned to that recipient. This can have adverse effects on encrypted e-mail communication between the recipient and any external recipients</span></i></b></p>
</cfoutput>
</cfif>

<cfif #m4# is "5">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The recipient you selected has PGP keystore(s) assigned. Deleting the recipient will also delete all keystores assigned to that recipient. This can have adverse effects on encrypted e-mail communication between the recipient and any external recipients</span></i></b></p>
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
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="4" valign="middle" width="961"><hr id="HRRule3" width="961" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="63"></td>
                          <td colspan="2" width="959"><cfif #action# is "apply">

<!-- CREATE CUSTOMTRANS STARTS HERE -->
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

<!-- CREATE CUSTOMTRANS ENDS HERE -->

<!-- GET ALL RECIPIENTS TO BE ADDED -->
<cfquery name="gettempinsert" datasource="#datasource#">
select * from recipients_temp where applied='2' and action='insert'
</cfquery>

<!-- GET ALL RECIPIENTS TO BE DELETED -->
<cfquery name="gettempdelete" datasource="#datasource#">
select * from recipients_temp where applied='2' and action='delete'
</cfquery>

<cfloop query="gettempinsert">

<cfquery name="checkentry" datasource="#datasource#">
select recipient from recipients where recipient='#recipient#'
</cfquery>

<cfif #checkentry.recordcount# LT 1>

<cfquery name="getdefaultpolicy" datasource="#datasource#">
select policy_id, default_policy from spam_policies where default_policy='1'
</cfquery>

<cfif #getdefaultpolicy.recordcount# GTE 1>

<cfquery name="insertnew" datasource="#datasource#">
insert into recipients
(policy_id, recipient, status, configured, pdf_enabled, smime_enabled, pgp_enabled, smime_mode, digital_sign, validity, encryption, algorithm)
values
('#getdefaultpolicy.policy_id#', '#recipient#', 'OK', '2', '2', '2', '2', '1', '2', '1825', '4096', 'sha512')
</cfquery>

<cfelse>

<cfquery name="insertnew" datasource="#datasource#">
insert into recipients
(policy_id, recipient, status, configured, pdf_enabled, smime_enabled, pgp_enabled, smime_mode, digital_sign, validity, encryption,
 algorithm)
values
('7', '#recipient#', 'OK', '2', '2', '2', '2', '1', '2', '1825', '4096', 'sha512')
</cfquery>

<!-- /CFIF getdefaultpolicy.recordcount -->
</cfif>

<!-- CREATE UNIQUE ID FOR EACH RECIPIENT STARTS HERE -->
<cfquery name="userrandom" datasource="#datasource#" result="getrandom_results">
select random_letter as random from captcha_list_all2 order by RAND() limit 24
</cfquery>

<cfquery name="inserttrans" datasource="#datasource#" result="stResult">
insert into salt
(salt)
values
('<cfoutput query="userrandom">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="gettrans" datasource="#datasource#">
select salt as userrandom2 from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<cfset userrandom3=#gettrans.userrandom2#>

<cfquery name="deletetrans" datasource="#datasource#">
delete from salt where id='#stResult.GENERATED_KEY#'
</cfquery>

<!-- CREATE UNIQUE ID FOR EACH RECIPIENT ENDS HERE -->

<cfquery name="insertreport" datasource="#datasource#">
insert into user_settings
(id, email, report_enabled, report_frequency, password_set, train_bayes, download_msg)
values
('#userrandom3#', '#recipient#', 'ALL', '24', '0', '0', '0')
</cfquery>

<cfquery name="deletetemp" datasource="#datasource#">
delete from recipients_temp where recipient='#recipient#'
</cfquery>

<cfelse>
<cfquery name="deletetemp" datasource="#datasource#">
delete from recipients_temp where recipient='#recipient#'
</cfquery>

<!-- /CFIF FOR checkentry.recordcount -->
</cfif>

<!-- /CFLOOP FOR gettempinsert -->
</cfloop>

<cfloop query="gettempdelete">

<!-- DELETE RECIPIENT FROM DJIGZO STARTS HERE -->
<cffile action="read" file="/opt/hermes/scripts/delete_intrecipient.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/scripts/#customtrans3#_delete_intrecipient.sh"
    output = "#REReplace("#temp#","THE-RECIPIENT","#recipient#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/scripts/#customtrans3#_delete_intrecipient.sh" variable="temp">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/scripts/#customtrans3#_delete_intrecipient.sh"
timeout = "60">
</cfexecute>

<cfexecute name = "/opt/hermes/scripts/#customtrans3#_delete_intrecipient.sh"
timeout = "240"
outputfile ="/dev/null"
arguments="-inputformat none">
</cfexecute>

<cffile
    action = "delete"
    file = "/opt/hermes/scripts/#customtrans3#_delete_intrecipient.sh">

<!-- DELETE RECIPIENT FROM DJIGZO ENDS HERE -->

<!-- DELETE CERTIFICATES AND KEYSTORES FROM DJIGZO STARTS HERE -->

<cfquery name="getcertid" datasource="djigzo">
select cm_certificates_id, cm_email from cm_certificates_email where cm_email='#recipient#'
</cfquery>

<cfif #getcertid.recordcount# GTE 1>
<cfloop query="getcertid">
<cfoutput>
<cfquery name="getthumbprint" datasource="djigzo">
select cm_id, cm_thumbprint, cm_key_alias from cm_certificates where cm_id='#cm_certificates_id#'
</cfquery>
<cfquery name="delete1" datasource="djigzo">
delete from cm_certificates_email where cm_certificates_id='#cm_certificates_id#'
</cfquery>
<cfquery name="delete2" datasource="djigzo">
delete from cm_certificates where cm_id='#cm_certificates_id#'
</cfquery>

<cfquery name="getctl" datasource="djigzo">
select * from cm_ctl where cm_thumbprint='#getthumbprint.cm_thumbprint#'
</cfquery>

<cfif #getctl.recordcount# GTE 1>
<cfquery name="delete4" datasource="djigzo">
delete from cm_ctl_cm_name_values where cm_ctl='#getctl.cm_id#'
</cfquery>

<cfquery name="delete3" datasource="djigzo">
delete from cm_ctl where cm_thumbprint='#getthumbprint.cm_thumbprint#'
</cfquery>

<!-- /CFIF for getctl.recordcount -->
</cfif>

<cfquery name="getkeystore" datasource="djigzo">
select * from cm_keystore where cm_alias='#getthumbprint.cm_key_alias#'
</cfquery>

<cfif #getkeystore.recordcount# GTE 1>
<cfquery name="delete5" datasource="djigzo">
delete from cm_keystore where cm_alias='#getthumbprint.cm_key_alias#'
</cfquery>

<!-- /CFIF for getkeystore.recordcount -->
</cfif>

</cfoutput>

<!-- /CFLOOP for getcertid -->
</cfloop>

<!-- /CFIF for getcertid.recordcount -->
</cfif>

<!-- DELETE CERTIFICATES AND KEYSTORES FROM DJIGZO ENDS HERE -->

<!-- DELETE FROM RECIPIENTS, MAILADDR AND WBLIST STARTS HERE -->
<cfquery name="delete" datasource="#datasource#">
delete from recipients where id='#delete_id#'
</cfquery>

<cfquery name="deletetemp" datasource="#datasource#">
delete from recipients_temp where recipient='#recipient#'
</cfquery>

<cfquery name="deletewblist" datasource="#datasource#">
delete from wblist where rid='#delete_id#'
</cfquery>

<cfquery name="mailaddr_temp" datasource="#datasource#">
delete from mailaddr_temp where recipient_id='#delete_id#'
</cfquery>

<cfquery name="deletereport" datasource="#datasource#">
delete from user_settings where email='#recipient#'
</cfquery>

<cfquery name="getmailaddrid" datasource="#datasource#">
select id, email from mailaddr where email='#recipient#'
</cfquery>

<cfif #getmailaddrid.recordcount# GTE 1>
<cfquery name="deletemailaddr" datasource="#datasource#">
delete from wblist where sid='#getmailaddrid.id#'
</cfquery>

<!-- /CFIF for getmailaddrid.recordcount -->
</cfif>

<!-- DELETE FROM RECIPIENTS, MAILADDR AND WBLIST ENDS HERE -->

<!-- DELETE FROM HERMES CERTITIFCATE STORE STARTS HERE -->

<cfquery name="selectcerts" datasource="#datasource#">
select * from recipient_certificates where user_id='#delete_id#'
</cfquery>

<cfif #selectcerts.recordcount# GTE 1>

<cfloop query="selectcerts">
<cfif #external_ca# is not "1">
<cfoutput>
<cfquery name="getca" datasource="#datasource#">
select ca_directory from ca_settings where id='#ca_id#'
</cfquery>


<cfset smime_certificate_name2="/opt/hermes/CA/#getca.ca_directory#/root_ca/newcerts/#smime_certificate_name#">
<cfif fileExists(smime_certificate_name2)> 
<cffile 
action = "delete"
file = "#smime_certificate_name2#">
</cfif>

<cfset smime_certificate_request2="/opt/hermes/CA/#getca.ca_directory#/root_ca/requests/#smime_certificate_request#">  
<cfif fileExists(smime_certificate_request2)>    
<cffile
    action = "delete"
    file = "#smime_certificate_request2#">
</cfif>
    
<cfset smime_certificate_key2="/opt/hermes/CA/#getca.ca_directory#/root_ca/private/#smime_certificate_key#">   
<cfif fileExists(smime_certificate_key2)>  
<cffile
    action = "delete"
    file = "#smime_certificate_key2#">
</cfif>
    
<cfset pfx_certificate_name2="/opt/hermes/CA/#getca.ca_directory#/root_ca/PFX/#pfx_certificate_name#">    
<cfif fileExists(pfx_certificate_name2)>     
<cffile
    action = "delete"
    file = "#pfx_certificate_name2#">
</cfif>  
</cfoutput>

<cfelseif #external_ca# is "1">
<cfset pfx_certificate_name2="/opt/hermes/HermesExternalCACerts/#pfx_certificate_name#">    
<cfif fileExists(pfx_certificate_name2)>     
<cffile
    action = "delete"
    file = "#pfx_certificate_name2#">
</cfif> 

<!-- /CFIF for external_ca -->
</cfif>


<!-- /CFLOOP FOR SELECTCERTS -->
</cfloop>  

<!-- /CFIF for selectcerts.recordcount -->
</cfif> 

<!-- DELETE FROM HERMES CERTITIFCATE STORE ENDS HERE -->  

    
<!-- DELETE PGP KEYSTORES STARTS HERE -->

<cfquery name="getkeys" datasource="#datasource#">
select * from recipient_keystores where user_id='#delete_id#' and master='1'
</cfquery>


<cfif #getkeys.recordcount# GTE 1>

<cfloop query="getkeys">

<cfquery name="getchildren" datasource="#datasource#">
select id, pgp_fingerprint,  pgp_fingerprint_sha256, djigzo_keystore_id from recipient_keystores where parent  = '#id#'
</cfquery>

<cfif #getchildren.recordcount# GTE 1>
<cfloop query="getchildren">
<cfoutput>
<cfquery name="getpgpcmid" datasource="djigzo">
select cm_id from cm_pgp_trust_list where cm_fingerprint = '#pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletepgpnamevalues" datasource="djigzo">
delete from cm_pgp_trust_list_cm_name_values where cm_pgp_trust_list = '#getpgpcmid.cm_id#'
</cfquery>

<cfquery name="deletetrustlist" datasource="djigzo">
delete from cm_pgp_trust_list where cm_fingerprint = '#pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletekeystore" datasource="djigzo">
delete from cm_keystore where cm_alias = 'PGP:#pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletecmkeyringuserid" datasource="djigzo">
delete from cm_keyring_userid where cm_keyring_id = '#djigzo_keystore_id#'
</cfquery>


<cfquery name="deletecmkeyringemail" datasource="djigzo">
delete from cm_keyring_email where cm_keyring_id = '#djigzo_keystore_id#'
</cfquery>

<cfquery name="deletecmkeyring" datasource="djigzo">
delete from cm_keyring where cm_id = '#djigzo_keystore_id#'
</cfquery>

<cfquery name="deleterecipientkeystore" datasource="#datasource#">
delete from recipient_keystores where pgp_fingerprint_sha256 = '#pgp_fingerprint_sha256#'
</cfquery>

<!-- /CFOUTPUT for getchildren -->
</cfoutput>
<!-- /CFLOOP for getchildren -->
</cfloop>
<!-- /CFIF for getchildren.recordcount -->
</cfif>


<cfoutput>
<cfquery name="getpgpcmid" datasource="djigzo">
select cm_id from cm_pgp_trust_list where cm_fingerprint = '#pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletepgpnamevalues" datasource="djigzo">
delete from cm_pgp_trust_list_cm_name_values where cm_pgp_trust_list = '#getpgpcmid.cm_id#'
</cfquery>

<cfquery name="deletetrustlist" datasource="djigzo">
delete from cm_pgp_trust_list where cm_fingerprint = '#pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletekeystore" datasource="djigzo">
delete from cm_keystore where cm_alias = 'PGP:#pgp_fingerprint_sha256#'
</cfquery>

<cfquery name="deletecmkeyringuserid" datasource="djigzo">
delete from cm_keyring_userid where cm_keyring_id = '#djigzo_keystore_id#'
</cfquery>


<cfquery name="deletecmkeyringemail" datasource="djigzo">
delete from cm_keyring_email where cm_keyring_id = '#djigzo_keystore_id#'
</cfquery>

<cfquery name="deletecmkeyring" datasource="djigzo">
delete from cm_keyring where cm_id = '#djigzo_keystore_id#'
</cfquery>

<cfquery name="deleterecipientkeystore" datasource="#datasource#">
delete from recipient_keystores where pgp_fingerprint_sha256 = '#pgp_fingerprint_sha256#'
</cfquery>

<!-- /CFOUTPUT for getkeys -->
</cfoutput>


<!-- DELETE PGP KEYSTORES ENDS HERE -->

<!-- DELETE FROM GNUPG STARTS HERE -->

<cffile action="read" file="/opt/hermes/scripts/delete_gpg_master_key.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh"
    output = "#REReplace("#temp#","THE_KEY","#pgp_fingerprint#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh"
timeout = "60">
</cfexecute>


<cfexecute name = "/opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh"
timeout = "240"
variable="thekeyemail2"
arguments="-inputformat none">
</cfexecute>

<!-- delete /opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_delete_gpg_master_key.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<!-- DELETE FROM GNUPG ENDS HERE -->

<!-- /CFLOOP for getkeys -->
</cfloop>

<!-- /CFIF for getkeys.recordcount -->
</cfif>


<cfquery name="deletecerts" datasource="#datasource#">
delete from recipient_certificates where user_id='#delete_id#'
</cfquery>


<!-- /CFLOOP FOR gettempdelete -->
</cfloop>

<cfset m2=16>

<!-- STOP POSTFIX AND AMAVIS STARTS HERE -->

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

<!-- STOP POSTFIX AND AMAVIS ENDS HERE -->

<!-- DROP USERS TABLE AND RE-CREATE IT USING THE RECIPIENTS TABLE STARTS HERE -->

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

<!-- DROP USERS TABLE AND RE-CREATE IT USING THE RECIPIENTS TABLE ENDS HERE -->

<!-- START POSTFIX AND AMAVIS STARTS HERE -->

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

<!-- START POSTFIX AND AMAVIS ENDS HERE -->

<cfoutput>
<cflocation url="recipients.cfm?action=applied&filter=#filter#&StartRow=1&DisplayRows=#DisplayRows###apply" addToken = "no">
</cfoutput>

</cfif>




                            <table border="0" cellspacing="0" cellpadding="0" width="959" id="LayoutRegion17" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="959">
                                        <form name="apply_settings" action="recipients.cfm?action=apply" method="post">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="959" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><cfquery name="getapplied" datasource="#datasource#">
select * from recipients_temp where applied='2'
</cfquery>
<cfif #getapplied.recordcount# GTE 1>
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
<cfelse>
<input type="submit" onclick="this.disabled=true;this.value='Applying settings, please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" disabled="disabled" style="height: 24px; width: 142px;">
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
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="959">
                                    <tr valign="top" align="left">
                                      <td width="959" height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="959" id="Text330" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;"><cfif #m2# is "16">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
</cfoutput>
</cfif>

<cfif #action# is "applied">
<cfoutput>
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
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
                          <td colspan="2"></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="49" colspan="2" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion24" style="background-image: url('./bottom_988.png'); height: 49px;">
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
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway #session.edition# Version:#getversion.value# Build:#getbuild.value#. Copyright 2011-#theYear#, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span></cfoutput>&nbsp;</p>
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