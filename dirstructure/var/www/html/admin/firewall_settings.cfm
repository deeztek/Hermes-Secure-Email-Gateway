����   2p $proprietary/firewall_settings_cfm$cf  lucee/runtime/PageImpl  */compile/proprietary/firewall_settings.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�
  getSourceLength     � getCompileTime  v�	w getHash ()IwBk| call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this &Lproprietary/firewall_settings_cfm$cf;
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Firewall Settings</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 us &()Llucee/runtime/type/scope/Undefined; 4 5
 / 6 $lucee/runtime/type/util/KeyConstants 8 _DATASOURCE #Llucee/runtime/type/Collection$Key; : ;	 9 < hermes > "lucee/runtime/type/scope/Undefined @ set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; B C A D

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
 Fu<script type="text/javascript">
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
	
	if (isOpera && (operaVersion  H�< 7)) {
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
 J</script>
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
              <td height="10"></td>
            </tr>
            <tr valign="top" align="left">
               L <td height="131" width="988">
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
                     N �</td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="501" width="988"> P@       keys $[Llucee/runtime/type/Collection$Key; T U	  V !lucee/runtime/type/Collection$Key X *lucee/runtime/functions/decision/IsDefined Z B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & \
 [ ] 
 _ sessionScope $()Llucee/runtime/type/scope/Session; a b
 / c  lucee/runtime/type/scope/Session e get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; g h f i 	VIOLATION k lucee/runtime/op/Operator m compare '(Ljava/lang/Object;Ljava/lang/String;)I o p
 n q lucee/runtime/PageContextImpl s lucee.runtime.tag.Location u 
cflocation w use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; y z
 t { lucee/runtime/tag/Location } license_invalid.cfm  setUrl � 1
 ~ � setAddtoken (Z)V � �
 ~ � 
doStartTag � $
 ~ � doEndTag � $
 ~ � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 t � NEW �6
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 501px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="518">
                              <tr valign="top" align="left">
                                <td width="10" height="17"></td>
                                <td width="508"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="508" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Administration Console Firewall Settings ��</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="422">
                              <tr valign="top" align="left">
                                <td width="5" height="24"></td>
                                <td width="417"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="417" id="Text466" class="TextObject"> � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � lucee/runtime/tag/Query � 
getversion � setName � 1
 � � A i setDatasource (Ljava/lang/Object;)V � �
 � �
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � D
select value from system_settings where parameter = 'version_no'
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � �
 � � 	outputEnd � 
 / � 



 � �
<p style="text-align: right; margin-bottom: 0px;"><span style="font-family:
 Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Your IP Address is:
 <b> � 0lucee/runtime/functions/other/GetHTTPRequestData � 8(Llucee/runtime/PageContext;)Llucee/runtime/type/Struct; & �
 � � getCollection I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � �
 / � g �
 / � lucee/runtime/op/Caster � toString &(Ljava/lang/Object;)Ljava/lang/String; � �
 � � </b></span></p>
 �[


                                  <p style="text-align: right; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>&nbsp;</p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="30">
                              <tr valign="top" align="left">
                                <td width="5" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/system/admin-console-firewall/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"> �V</a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="9" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="110"></td>
                          <td width="961"> � m � &lucee/runtime/config/NullSupportHelper � NULL � '
 � � -lucee/runtime/interpreter/VariableInterpreter � getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; � �
 � � 0 � %lucee/runtime/exp/ExpressionException � java/lang/StringBuilder � The required parameter [ �  1
 � � append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; � �
 � � ] was not provided.  -(Ljava/lang/String;)Ljava/lang/StringBuilder; �
 � ()Ljava/lang/String; �
 �
 � � any	�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V
 t@       _m ;	 9 True (ZLjava/lang/String;)I o
 n urlScope  ()Llucee/runtime/type/scope/URL;
 / _M ;	 9  lucee/runtime/type/scope/URL"# i  % 

' m2) m3+ step-  

/ checkstatus1 i
select value2 from parameters2 where parameter='firewall_status' and module='firewall' and active='1'
3 firewall_status5 � h A7  
9@       	formScope !()Llucee/runtime/type/scope/Form;=>
 /? lucee/runtime/type/scope/FormAB i2


                            <table border="0" cellspacing="0" cellpadding="0" width="961" id="LayoutRegion12" style="height: 110px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion12FORM" action="edit_firewall.cfm" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0" width="510">
                                      <tr valign="top" align="left">
                                        <td width="9"></td>
                                        <td width="501" id="Text291" class="TextObject">
                                          <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Firewall Status</span></b></p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      D
<tr valign="top" align="left">
                                        <td height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="600">
                                          <table id="Table79" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                            <tr style="height: 17px;">
                                              <td width="45" id="Cell449">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="left">
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          F t<td class="TextObject">
                                                            <p style="margin-bottom: 0px;">H enabledJ t
<input type="radio" checked="checked" name="firewall_status" value="enabled" style="height: 13px; width: 13px;">
L b
<input type="radio" name="firewall_status" value="enabled" style="height: 13px; width: 13px;">
N,






&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                              <td width="555" id="Cell450">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Enabled<span style="font-weight: normal;"> (Only Specified IP Addresses Allowed. </span><span style="color: rgb(255,0,0);">DO NOT Enable unless your IP Address is allowed</span><span style="font-weight: normal;">)</span></span></b></p>
                                              </td>
                                            </tr>
                                            P�<tr style="height: 17px;">
                                              <td id="Cell451">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="left">
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;">R disabledT u
<input type="radio" checked="checked" name="firewall_status" value="disabled" style="height: 13px; width: 13px;">
V c
<input type="radio" name="firewall_status" value="disabled" style="height: 13px; width: 13px;">
X







&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                              <td id="Cell452">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled<span style="font-weight: normal;"> (All IP Addresses Allowed)</span></span></b></p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    ZX</table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="8"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="961">
                                          <table id="Table174" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="961" id="Cell1033">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        \<tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="hidden" name="action" value="edit">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">&nbsp;</p>
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
                                      ^@</tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="961">
                                      <tr valign="top" align="left">
                                        <td width="961" height="13"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="961" id="Text467" class="TextObject">
                                          <p style="margin-bottom: 0px;">` 1b
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Cannot enable firewall unless current IP is in the Allowed IP list</span></i></b></p>
d 2f`
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Firewall Enabled.</span></i></b></p>
h 3ja
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Firewall Disabled.</span></i></b></p>
l


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
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="9" height="4"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="960"><hr id="HRRule4" width="960" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="3">n �</td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="108"></td>
                          <td width="960">p show_actionr viewt _actionv ;	 9w _ACTIONy ;	 9z  


| [^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$~ firewall_ip� 


� add� %lucee/runtime/functions/string/REFind� S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object; &�
�� (Ljava/lang/Object;D)I o�
 n� #lucee/commons/color/ConstantsDouble� _1 Ljava/lang/Double;��	�� _0��	�� _2��	�� _3��	�� check� &
select ip from firewall where ip = '� writePSQ� �
 /� '
� #lucee/runtime/util/VariableUtilImpl� recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;��
�� (
insert into firewall
(ip)
values
('� ')
� _4��	��




                            <table border="0" cellspacing="0" cellpadding="0" width="960" id="LayoutRegion1" style="height: 108px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="ipaddressallowedform" action="firewall_settings.cfm" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="615">
                                          <table id="Table175" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 52px;">
                                            <tr style="height: 19px;">
                                              <td width="615" id="Cell1048">
                                                <p style="margin-bottom: 0px;">�r<b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">IP Address to be allowed</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 32px;">
                                              <td id="Cell1049">
                                                <table width="610" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
�@
                                                      <table id="Table176" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                        <tr style="height: 24px;">
                                                          <td width="330" id="Cell1050">
                                                            <table width="302" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><input type="text" name="firewall_ip" size="30" maxlength="45" style="width: 236px; white-space: pre;" value="��">
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="280" id="Cell1057">
                                                            <p style="margin-bottom: 0px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      �.</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="960">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              �.<td width="960" id="Cell722">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Add IP" style="height: 24px; width: 142px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    ��</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="960">
                                      <tr valign="top" align="left">
                                        <td width="960" height="16"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="960" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;">�c
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid IP Address</span></i></b></p>
�[
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The IP Address cannot be blank</span></i></b></p>
�`
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! IP Address Added.</span></i></b></p>
� 4�t
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The IP Address you are attempting to add already exists</span></i></b></p>
�

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
                          <td colspan="2" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="960"><hr id="HRRule5" width="960" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="9" height="5"></td>
                          <td></� �td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="108"></td>
                          <td width="963">� server_ip_octet1� d
select * from parameters2 where parameter='server_ip_octet1' and module='network' and active='1'
� show_server_ip_octet1� server_ip_octet2� d
select * from parameters2 where parameter='server_ip_octet2' and module='network' and active='1'
� show_server_ip_octet2� server_ip_octet3� d
select * from parameters2 where parameter='server_ip_octet3' and module='network' and active='1'
� show_server_ip_octet3� server_ip_octet4� d
select * from parameters2 where parameter='server_ip_octet4' and module='network' and active='1'
� show_server_ip_octet4� server_gateway_octet1� i
select * from parameters2 where parameter='server_gateway_octet1' and module='network' and active='1'
� show_server_gateway_octet1� server_gateway_octet2� i
select * from parameters2 where parameter='server_gateway_octet2' and module='network' and active='1'
� show_server_gateway_octet2� server_gateway_octet3� i
select * from parameters2 where parameter='server_gateway_octet3' and module='network' and active='1'
� show_server_gateway_octet3� server_gateway_octet4� i
select * from parameters2 where parameter='server_gateway_octet4' and module='network' and active='1'
� show_server_gateway_octet4� server_dns1_octet1� f
select * from parameters2 where parameter='server_dns1_octet1' and module='network' and active='1'
 show_server_dns1_octet1 server_dns1_octet2 f
select * from parameters2 where parameter='server_dns1_octet2' and module='network' and active='1'
 show_server_dns1_octet2	 server_dns1_octet3 f
select * from parameters2 where parameter='server_dns1_octet3' and module='network' and active='1'
 show_server_dns1_octet3 server_dns1_octet4 f
select * from parameters2 where parameter='server_dns1_octet4' and module='network' and active='1'
 show_server_dns1_octet4 server_dns2_octet1 f
select * from parameters2 where parameter='server_dns2_octet1' and module='network' and active='1'
 show_server_dns2_octet1 server_dns2_octet2 f
select * from parameters2 where parameter='server_dns2_octet2' and module='network' and active='1'
 show_server_dns2_octet2! server_dns2_octet3# f
select * from parameters2 where parameter='server_dns2_octet3' and module='network' and active='1'
% show_server_dns2_octet3' server_dns2_octet4) f
select * from parameters2 where parameter='server_dns2_octet4' and module='network' and active='1'
+ show_server_dns2_octet4- server_dns3_octet1/ f
select * from parameters2 where parameter='server_dns3_octet1' and module='network' and active='1'
1 show_server_dns3_octet13 server_dns3_octet25 f
select * from parameters2 where parameter='server_dns3_octet2' and module='network' and active='1'
7 show_server_dns3_octet29 server_dns3_octet3; f
select * from parameters2 where parameter='server_dns3_octet3' and module='network' and active='1'
= show_server_dns3_octet3? server_dns3_octet4A f
select * from parameters2 where parameter='server_dns3_octet4' and module='network' and active='1'
C show_server_dns3_octet4E server_nameG _
select * from parameters2 where parameter='server_name' and module='network' and active='1'
I show_server_nameK _server_nameM ;	 9N server_domainP a
select * from parameters2 where parameter='server_domain' and module='network' and active='1'
R show_server_domainT server_subnetV a
select * from parameters2 where parameter='server_subnet' and module='network' and active='1'
X show_server_subnetZ edit\ static^@k`      toDouble (D)Ljava/lang/Double;bc
 �d '(Ljava/lang/Object;Ljava/lang/Object;)I of
 ng@o�      127k 169m 254o 192q _5s�	�t 5v _6x�	�y 6{ _7}�	�~ 7� _8��	�� 8� _9��	�� 9� _10��	�� 10� _11��	�� 11� _12��	�� 12� _13��	�� 13� _14��	�� 14� _15��	�� 15� _16��	�� 16� _17��	�� 17� _18��	�� 18� _19��	�� 19� _20��	�� 20� _21��	�� 21� _22��	�� 22� _23��	�� 23� _24��	�� 24� _25��	�� 25� bob@� java/lang/String� concat &(Ljava/lang/String;)Ljava/lang/String;��
�� email� (lucee/runtime/functions/decision/IsValid� B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &�
�� _26��	�� 26� [^_a-zA-Z0-9-]� _27��	�� 27� lucee.runtime.tag.Transaction� cftransaction� lucee/runtime/tag/Transaction�
� � update� !
update parameters2 set value2='  6lucee/runtime/functions/displayFormatting/NumberFormat S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &
 3', applied='2' where parameter='server_ip_octet1'
 3', applied='2' where parameter='server_ip_octet2'
	 3', applied='2' where parameter='server_ip_octet3'
 3', applied='2' where parameter='server_ip_octet4'
 8', applied='2' where parameter='server_gateway_octet1'
 8', applied='2' where parameter='server_gateway_octet2'
 8', applied='2' where parameter='server_gateway_octet3'
 8', applied='2' where parameter='server_gateway_octet4'
 5', applied='2' where parameter='server_dns1_octet1'
 5', applied='2' where parameter='server_dns1_octet2'
 5', applied='2' where parameter='server_dns1_octet3'
 5', applied='2' where parameter='server_dns1_octet4'
 5', applied='2' where parameter='server_dns2_octet1'
 V
update parameters2 set value2='', applied='2' where parameter='server_dns2_octet1'
! 5', applied='2' where parameter='server_dns2_octet2'
# V
update parameters2 set value2='', applied='2' where parameter='server_dns2_octet2'
% 5', applied='2' where parameter='server_dns2_octet3'
' V
update parameters2 set value2='', applied='2' where parameter='server_dns2_octet3'
) 5', applied='2' where parameter='server_dns2_octet4'
+ V
update parameters2 set value2='', applied='2' where parameter='server_dns2_octet4'
- 5', applied='2' where parameter='server_dns3_octet1'
/ V
update parameters2 set value2='', applied='2' where parameter='server_dns3_octet1'
1 5', applied='2' where parameter='server_dns3_octet2'
3 V
update parameters2 set value2='', applied='2' where parameter='server_dns3_octet2'
5 5', applied='2' where parameter='server_dns3_octet3'
7 V
update parameters2 set value2='', applied='2' where parameter='server_dns3_octet3'
9 5', applied='2' where parameter='server_dns3_octet4'
; V
update parameters2 set value2='', applied='2' where parameter='server_dns3_octet4'
= .' , applied='2'where parameter='server_name'
? 0', applied='2' where parameter='server_domain'
A 0', applied='2' where parameter='server_subnet'
C
� �
� �
� �
� � dhcpI



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
                            <table border="0" cellspacing="0" cellpadding="0" width="963" id="LayoutRegion18" style="height: 108px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="963">
                                    <tr valign="top" align="left">
                                      <td width="501" id="Text464" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Allowed IP Addresses</span></b></p>
                                      </td>
                                      <td width="462">K�</td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" colspan="2" width="963" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;">M get_ipsO *
select * from firewall order by ip asc
Q m

<form action="edit_firewall.cfm" method="post">


<select name="ip" style="height: 88px;" size="60">
S getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;UV
 /W getIdY $
 /Z lucee/runtime/type/Query\ getCurrentrow (I)I^_]` getRecordcountb $]c !lucee/runtime/util/NumberIteratore load '(II)Llucee/runtime/util/NumberIterator;gh
fi addQuery (Llucee/runtime/type/Query;)Vkl Am isValid (I)Zop
fq currents $
ft go (II)Zvw]x 
<option value="z ">| </option>
~ removeQuery�  A� release &(Llucee/runtime/util/NumberIterator;)V��
f�q
</select>

<table id="Table170" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 28px;">
  <tr style="height: 28px;">
    <td>
<input type="hidden" name="action" value="delete">
      <p style="margin-bottom: 0px;"><input type="submit" value="Delete" style="height: 24px; width: 69px;"></p>
    </td>
    
  </tr>
</table>
</form>

� �
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No Allowed IP Addresses were found...</span></p>


�


    
&nbsp;</p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" width="963" id="Text463" class="TextObject">
                                        <p style="margin-bottom: 0px;">�d
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You must select an IP Address to delete</span></i></b></p>
�f
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You cannot delete your current IP Address</span></i></b></p>
� 





�b
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! IP Address Deleted.</span></i></b></p>
�





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
            <tr valign="top" align="left">
              <td height="49" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion24" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="981">
                        <tr valign="top" align="left">
                          <td width="981" height="12"></td>
                        � �</tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;">� $lucee/runtime/functions/dateTime/Now� =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &�
�� yyyy� 4lucee/runtime/functions/displayFormatting/DateFormat�
� D
SELECT value from system_settings where parameter = 'version_no'
� getbuild� B
SELECT value from system_settings where parameter = 'build_no'
� V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway � 	 Version:� _VALUE� ;	 9�  Build:� . Copyright 2011-� l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>�A&nbsp;</p>
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
 ����� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � license� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� LICENSE� HEADERS� X-Forwarded-For� M3� CHECKSTATUS� VALUE2� FIREWALL_STATUS� SHOW_ACTION� PATTERN� FIREWALL_IP� STEP� M2� IPADDR� CHECK� SERVER_IP_OCTET1� SHOW_SERVER_IP_OCTET1� SERVER_IP_OCTET2� SHOW_SERVER_IP_OCTET2� SERVER_IP_OCTET3� SHOW_SERVER_IP_OCTET3� SERVER_IP_OCTET4� SHOW_SERVER_IP_OCTET4� SERVER_GATEWAY_OCTET1� SHOW_SERVER_GATEWAY_OCTET1� SERVER_GATEWAY_OCTET2 SHOW_SERVER_GATEWAY_OCTET2 SERVER_GATEWAY_OCTET3 SHOW_SERVER_GATEWAY_OCTET3 SERVER_GATEWAY_OCTET4	 SHOW_SERVER_GATEWAY_OCTET4 SERVER_DNS1_OCTET1 SHOW_SERVER_DNS1_OCTET1 SERVER_DNS1_OCTET2 SHOW_SERVER_DNS1_OCTET2 SERVER_DNS1_OCTET3 SHOW_SERVER_DNS1_OCTET3 SERVER_DNS1_OCTET4 SHOW_SERVER_DNS1_OCTET4 SERVER_DNS2_OCTET1 SHOW_SERVER_DNS2_OCTET1 SERVER_DNS2_OCTET2! SHOW_SERVER_DNS2_OCTET2# SERVER_DNS2_OCTET3% SHOW_SERVER_DNS2_OCTET3' SERVER_DNS2_OCTET4) SHOW_SERVER_DNS2_OCTET4+ SERVER_DNS3_OCTET1- SHOW_SERVER_DNS3_OCTET1/ SERVER_DNS3_OCTET21 SHOW_SERVER_DNS3_OCTET23 SERVER_DNS3_OCTET35 SHOW_SERVER_DNS3_OCTET37 SERVER_DNS3_OCTET49 SHOW_SERVER_DNS3_OCTET4; SERVER_NAME= SHOW_SERVER_NAME? SERVER_DOMAINA SHOW_SERVER_DOMAINC SERVER_SUBNETE SHOW_SERVER_SUBNETG SHOW_NETWORK_MODEI OCTET_FIRSTK 
OCTET_LASTM OCTET2_FIRSTO OCTET2_LASTQ OCTET3_FIRSTS OCTET3_LASTU OCTET4_FIRSTW OCTET4_LASTY 
TEMP_EMAIL[ GET_IPS] IP_ THEYEARa EDITIONc 
GETVERSIONe GETBUILDg subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             T U   ij       k   *     *� 
*� *� � *����*+�ȱ        k         �        k        � �        k         �        k         �         k         !�      # $ k        %�      & ' k  ��   ��+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+ R*� W2� Y� ^� �+`� 3+� d*� W2� j l� r� � � U+`� 3+� tvx� |� ~M,�� �,� �,� �W,� �� � ��� N+� t,� �-�+� t,� �+`� 3� ~+� d*� W2� j �� r� � � ^+`� 3+� tvx� |� ~:�� �� �� �W� �� � ��� :+� t� ��+� t� �+`� 3� +`� 3� +�� 3+�� 3+� �+� t��� |� �:�� �+� 7� =� � � �� �6� N+� �+�� 3� ����� $:� �� :	� +� �W� �	�� +� �W� �� �� � ��� :
+� t� �
�+� t� �� :+� ��+� �+˶ 3+� �+Ͷ 3++++� �*� W2� �*� W2� ظ ޶ 3+� 3� :+� ��+� �+� 3+� 3+�+� � �:6+� �� 1�Y:� "� �Y� �Y�� �� �����:6+� t
��+`� 3+�� Y� ^�� � � X+`� 3+��!�$ &� r� � � ++`� 3+� 7�!+��!�$ � E W+`� 3� +`� 3� +(� 3+*+� � �:6+� �� 2�Y:� #� �Y� �Y�� �*� �����:6+� t
*�+(� 3+,+� � �:6+� �� 2�Y:� #� �Y� �Y�� �,� �����:6+� t
,�+`� 3+*� W2� Y� ^�� � � a+`� 3+�*� W2�$ &� r� � � 1+`� 3+� 7*� W2+�*� W2�$ � E W+`� 3� +`� 3� +(� 3+.+� � �:6+� �� 2�Y:� #� �Y� �Y�� �.� �����:6+� t
.�+0� 3+� �+� t��� |� �:2� �+� 7� =� � � �� �6� O+� �+4� 3� ���� $:� �� :� +� �W� ��� +� �W� �� �� � ��� :+� t� ��+� t� �� :+� ��+� �+(� 3+6+� � �:6 +� �� K++� 7*� W2�8 *� W2� �Y:!� #� �Y� �Y�� �6� �����!:6 +� t
6 �+:� 3+;*� W2� Y� ^�� � � d+`� 3+�@*� W	2�C &� r� � � 3+`� 3+� 7*� W	2+�@*� W	2�C � E W+`� 3� +`� 3� +E� 3+G� 3+I� 3+� 7*� W	2� � K� r� � � -+`� 3+� �+M� 3� :"+� �"�+� �+`� 3� O+� 7*� W	2� � K� r� � � -+`� 3+� �+O� 3� :#+� �#�+� �+`� 3� +Q� 3+S� 3+� 7*� W	2� � U� r� � � -+`� 3+� �+W� 3� :$+� �$�+� �+`� 3� O+� 7*� W	2� � U� r� � � -+`� 3+� �+Y� 3� :%+� �%�+� �+`� 3� +[� 3+]� 3+_� 3+a� 3+� 7�!� � c� r� � � -+`� 3+� �+e� 3� :&+� �&�+� �+`� 3� +(� 3+� 7�!� � g� r� � � -+`� 3+� �+i� 3� :'+� �'�+� �+`� 3� +(� 3+� 7�!� � k� r� � � -+`� 3+� �+m� 3� :(+� �(�+� �+`� 3� +o� 3+q� 3+s+� � �:)6*+� �)� 3uY:+� #� �Y� �Y�� �s� �����+:)6*+� t
s)*�+:� 3+;�x� Y� ^�� � � V+`� 3+�@�{�C &� r� � � /+`� 3+� 7*� W
2+�@�{�C � E W+`� 3� � +}� 3+� 7*� W2� E W+(� 3+�+� � �:,6-+� �,� 3&Y:.� #� �Y� �Y�� ��� �����.:,6-+� t
�,-�+:� 3+;*� W2� Y� ^�� � � 3+`� 3+� 7*� W2+�@*� W2�C � E W+`� 3� +�� 3+� 7*� W
2� � �� r� � ��+(� 3+� 7*� W2� � &� r� � � �+`� 3++� 7*� W2� � � �+� 7*� W2� � � ޸���� � � &+`� 3+� 7*� W2��� E W+`� 3� >+`� 3+� 7*� W2��� E W+`� 3+� 7*� W2��� E W+�� 3+(� 3� c+� 7*� W2� � &� r� � � A+`� 3+� 7*� W2��� E W+`� 3+� 7*� W2��� E W+�� 3� +�� 3+� 7*� W2� � c� r� � ��+`� 3+� 7*� W2��� E W+(� 3+� 7*� W2+� 7*� W2� � � E W+(� 3+� �+� t��� |� �://�� �/+� 7� =� � � �/� �600� m+/0� �+�� 3++� 7*� W2� � � ޶�+�� 3/� ���է $:1/1� �� :20� +� �W/� �2�0� +� �W/� �/� �� � ��� :3+� t/� �3�+� t/� �� :4+� �4�+� �+(� 3++� 7*� W2�8 ����� � � �+`� 3+� �+� t��� |� �:55�� �5+� 7� =� � � �5� �666� m+56� �+�� 3++� 7*� W2� � � ޶�+�� 35� ���է $:757� �� :86� +� �W5� �8�6� +� �W5� �5� �� � ��� :9+� t5� �9�+� t5� �� ::+� �:�+� �+(� 3� K++� 7*� W2�8 ����� � � '+`� 3+� 7*� W2��� E W+�� 3� +�� 3� +�� 3� +�� 3+�� 3+� �+�� 3++� 7*� W2� � � ޶ 3+�� 3� :;+� �;�+� �+�� 3+�� 3+�� 3+� 7*� W2� � c� r� � � -+`� 3+� �+¶ 3� :<+� �<�+� �+`� 3� +(� 3+� 7*� W2� � g� r� � � -+`� 3+� �+Ķ 3� :=+� �=�+� �+`� 3� +�� 3+� 7*� W2� � k� r� � � -+`� 3+� �+ƶ 3� :>+� �>�+� �+`� 3� +(� 3+� 7*� W2� � ȸ r� � � -+`� 3+� �+ʶ 3� :?+� �?�+� �+`� 3� +̶ 3+ζ 3+�+� � �:@6A+� �@� 1�Y:B� "� �Y� �Y�� �� �����B:@6A+� t
�@A�+`� 3+*+� � �:C6D+� �C� 2�Y:E� #� �Y� �Y�� �*� �����E:C6D+� t
*CD�+`� 3+.+� � �:F6G+� �F� 2�Y:H� #� �Y� �Y�� �.� �����H:F6G+� t
.FG�+0� 3+s+� � �:I6J+� �I� 3uY:K� #� �Y� �Y�� �s� �����K:I6J+� t
sIJ�+:� 3+;�x� Y� ^�� � � V+`� 3+�@�{�C &� r� � � /+`� 3+� 7*� W
2+�@�{�C � E W+`� 3� � +0� 3+� �+� t��� |� �:LLж �L+� 7� =� � � �L� �6MM� O+LM� �+Ҷ 3L� ���� $:NLN� �� :OM� +� �WL� �O�M� +� �WL� �L� �� � ��� :P+� tL� �P�+� tL� �� :Q+� �Q�+� �+�� 3+�+� � �:R6S+� �R� K++� 7*� W2�8 *� W2� �Y:T� #� �Y� �Y�� �Զ �����T:R6S+� t
�RS�+:� 3+;*� W2� Y� ^�� � � 3+`� 3+� 7*� W2+�@*� W2�C � E W+`� 3� +�� 3+� �+� t��� |� �:UUֶ �U+� 7� =� � � �U� �6VV� O+UV� �+ض 3U� ���� $:WUW� �� :XV� +� �WU� �X�V� +� �WU� �U� �� � ��� :Y+� tU� �Y�+� tU� �� :Z+� �Z�+� �+�� 3+�+� � �:[6\+� �[� K++� 7*� W2�8 *� W2� �Y:]� #� �Y� �Y�� �ڶ �����]:[6\+� t
�[\�+:� 3+;*� W2� Y� ^�� � � 3+`� 3+� 7*� W2+�@*� W2�C � E W+`� 3� +�� 3+� �+� t��� |� �:^^ܶ �^+� 7� =� � � �^� �6__� O+^_� �+޶ 3^� ���� $:`^`� �� :a_� +� �W^� �a�_� +� �W^� �^� �� � ��� :b+� t^� �b�+� t^� �� :c+� �c�+� �+�� 3+�+� � �:d6e+� �d� K++� 7*� W2�8 *� W2� �Y:f� #� �Y� �Y�� �� �����f:d6e+� t
�de�+:� 3+;*� W2� Y� ^�� � � 3+`� 3+� 7*� W2+�@*� W2�C � E W+`� 3� +(� 3+� �+� t��� |� �:gg� �g+� 7� =� � � �g� �6hh� O+gh� �+� 3g� ���� $:igi� �� :jh� +� �Wg� �j�h� +� �Wg� �g� �� � ��� :k+� tg� �k�+� tg� �� :l+� �l�+� �+�� 3+�+� � �:m6n+� �m� K++� 7*� W2�8 *� W2� �Y:o� #� �Y� �Y�� �� �����o:m6n+� t
�mn�+:� 3+;*� W2� Y� ^�� � � 3+`� 3+� 7*� W2+�@*� W2�C � E W+`� 3� +(� 3+� �+� t��� |� �:pp� �p+� 7� =� � � �p� �6qq� O+pq� �+� 3p� ���� $:rpr� �� :sq� +� �Wp� �s�q� +� �Wp� �p� �� � ��� :t+� tp� �t�+� tp� �� :u+� �u�+� �+�� 3+�+� � �:v6w+� �v� K++� 7*� W2�8 *� W2� �Y:x� #� �Y� �Y�� �� �����x:v6w+� t
�vw�+:� 3+;*� W2� Y� ^�� � � 3+`� 3+� 7*� W 2+�@*� W2�C � E W+`� 3� +(� 3+� �+� t��� |� �:yy� �y+� 7� =� � � �y� �6zz� O+yz� �+� 3y� ���� $:{y{� �� :|z� +� �Wy� �|�z� +� �Wy� �y� �� � ��� :}+� ty� �}�+� ty� �� :~+� �~�+� �+�� 3+�+� � �:6�+� �� K++� 7*� W!2�8 *� W2� �Y:�� #� �Y� �Y�� �� ������:6�+� t
���+:� 3+;*� W"2� Y� ^�� � � 3+`� 3+� 7*� W#2+�@*� W!2�C � E W+`� 3� +�� 3+� �+� t��� |� �:���� ��+� 7� =� � � ��� �6��� O+��� �+�� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� t�� ���+� t�� �� :�+� ���+� �+�� 3+�+� � �:�6�+� ��� K++� 7*� W$2�8 *� W2� �Y:�� #� �Y� �Y�� ��� ������:�6�+� t
����+:� 3+;*� W%2� Y� ^�� � � 3+`� 3+� 7*� W&2+�@*� W$2�C � E W+`� 3� +(� 3+� �+� t��� |� �:���� ��+� 7� =� � � ��� �6��� O+��� �+�� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� t�� ���+� t�� �� :�+� ���+� �+�� 3+�+� � �:�6�+� ��� K++� 7*� W'2�8 *� W2� �Y:�� #� �Y� �Y�� ��� ������:�6�+� t
����+:� 3+;*� W(2� Y� ^�� � � 3+`� 3+� 7*� W)2+�@*� W'2�C � E W+`� 3� +(� 3+� �+� t��� |� �:�� � ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� t�� ���+� t�� �� :�+� ���+� �+�� 3++� � �:�6�+� ��� K++� 7*� W*2�8 *� W2� �Y:�� #� �Y� �Y�� �� ������:�6�+� t
���+:� 3+;*� W+2� Y� ^�� � � 3+`� 3+� 7*� W,2+�@*� W*2�C � E W+`� 3� +(� 3+� �+� t��� |� �:��� ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� t�� ���+� t�� �� :�+� ���+� �+�� 3+
+� � �:�6�+� ��� K++� 7*� W-2�8 *� W2� �Y:�� #� �Y� �Y�� �
� ������:�6�+� t

���+:� 3+;*� W.2� Y� ^�� � � 3+`� 3+� 7*� W/2+�@*� W-2�C � E W+`� 3� +�� 3+� �+� t��� |� �:��� ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� t�� ���+� t�� �� :�+� ���+� �+�� 3++� � �:�6�+� ��� K++� 7*� W02�8 *� W2� �Y:�� #� �Y� �Y�� �� ������:�6�+� t
���+:� 3+;*� W12� Y� ^�� � � 3+`� 3+� 7*� W22+�@*� W02�C � E W+`� 3� +(� 3+� �+� t��� |� �:��� ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� t�� ���+� t�� �� :�+� ���+� �+�� 3++� � �:�6�+� ��� K++� 7*� W32�8 *� W2� �Y:�� #� �Y� �Y�� �� ������:�6�+� t
���+:� 3+;*� W42� Y� ^�� � � 3+`� 3+� 7*� W52+�@*� W32�C � E W+`� 3� +(� 3+� �+� t��� |� �:��� ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� t�� ���+� t�� �� :�+� ���+� �+�� 3++� � �:�6�+� ��� K++� 7*� W62�8 *� W2� �Y:�� #� �Y� �Y�� �� ������:�6�+� t
���+:� 3+;*� W72� Y� ^�� � � 3+`� 3+� 7*� W82+�@*� W62�C � E W+`� 3� +(� 3+� �+� t��� |� �:��� ��+� 7� =� � � ��� �6��� O+�¶ �+ � 3�� ���� $:��ö �� :��� +� �W�� �Ŀ�� +� �W�� ��� �� � ��� :�+� t�� �ſ+� t�� �� :�+� �ƿ+� �+�� 3+"+� � �:�6�+� �Ǧ K++� 7*� W92�8 *� W2� �Y:�� #� �Y� �Y�� �"� ������:�6�+� t
"�ȶ+:� 3+;*� W:2� Y� ^�� � � 3+`� 3+� 7*� W;2+�@*� W92�C � E W+`� 3� +�� 3+� �+� t��� |� �:��$� ��+� 7� =� � � �ʶ �6��� O+�˶ �+&� 3ʶ ���� $:��̶ �� :��� +� �Wʶ �Ϳ�� +� �Wʶ �ʶ �� � ��� :�+� tʶ �ο+� tʶ �� :�+� �Ͽ+� �+�� 3+(+� � �:�6�+� �Ц K++� 7*� W<2�8 *� W2� �Y:�� #� �Y� �Y�� �(� ������:�6�+� t
(�Ѷ+:� 3+;*� W=2� Y� ^�� � � 3+`� 3+� 7*� W>2+�@*� W<2�C � E W+`� 3� +(� 3+� �+� t��� |� �:��*� ��+� 7� =� � � �Ӷ �6��� O+�Զ �+,� 3Ӷ ���� $:��ն �� :��� +� �WӶ �ֿ�� +� �WӶ �Ӷ �� � ��� :�+� tӶ �׿+� tӶ �� :�+� �ؿ+� �+�� 3+.+� � �:�6�+� �٦ K++� 7*� W?2�8 *� W2� �Y:�� #� �Y� �Y�� �.� ������:�6�+� t
.�ڶ+:� 3+;*� W@2� Y� ^�� � � 3+`� 3+� 7*� WA2+�@*� W?2�C � E W+`� 3� +(� 3+� �+� t��� |� �:��0� ��+� 7� =� � � �ܶ �6��� O+�ݶ �+2� 3ܶ ���� $:��޶ �� :��� +� �Wܶ �߿�� +� �Wܶ �ܶ �� � ��� :�+� tܶ ��+� tܶ �� :�+� ��+� �+�� 3+4+� � �:�6�+� �� K++� 7*� WB2�8 *� W2� �Y:�� #� �Y� �Y�� �4� ������:�6�+� t
4��+:� 3+;*� WC2� Y� ^�� � � 3+`� 3+� 7*� WD2+�@*� WB2�C � E W+`� 3� +(� 3+� �+� t��� |� �:��6� ��+� 7� =� � � �� �6��� O+�� �+8� 3� ���� $:��� �� :��� +� �W� ���� +� �W� �� �� � ��� :�+� t� ��+� t� �� :�+� ��+� �+�� 3+:+� � �:�6�+� �� K++� 7*� WE2�8 *� W2� �Y:�� #� �Y� �Y�� �:� ������:�6�+� t
:��+:� 3+;*� WF2� Y� ^�� � � 3+`� 3+� 7*� WG2+�@*� WE2�C � E W+`� 3� +�� 3+� �+� t��� |� �:��<� ��+� 7� =� � � �� �6��� O+�� �+>� 3� ���� $:��� �� :��� +� �W� ���� +� �W� �� �� � ��� :�+� t� ��+� t� �� :�+� ��+� �+�� 3+@+� � �:�6�+� ��� K++� 7*� WH2�8 *� W2� �Y:�� #� �Y� �Y�� �@� ������:�6�+� t
@���+:� 3+;*� WI2� Y� ^�� � � 3+`� 3+� 7*� WJ2+�@*� WH2�C � E W+`� 3� +(� 3+� �+� t��� |� �:��B� ��+� 7� =� � � ��� �6��� O+��� �+D� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� t�� ���+� t�� �� :�+� ���+� �+�� 3+F+� � �:�6�+� ��� K++� 7*� WK2�8 *� W2� �Y:�� #� �Y� �Y�� �F� ������:�6�+� t
F���+:� 3+;*� WL2� Y� ^�� � � 3+`� 3+� 7*� WM2+�@*� WK2�C � E W+`� 3� +(� 3+� �+� t��� |� ��: � H� �� +� 7� =� � � �� � ��6�� g+� �� �+J� 3� � ���� 2�:� �� ��  �:�� +� �W� � ����� +� �W� � �� � �� � ��� �:+� t� � ���+� t� � �� �:+� ���+� �+(� 3+L+� � ��:�6+� ��� S++� 7*� WN2�8 *� W2� �Y�:� #� �Y� �Y�� �L� �������:�6+� t
L���+:� 3+;�O� Y� ^�� � � 3+`� 3+� 7*� WO2+�@*� WN2�C � E W+`� 3� +(� 3+� �+� t��� |� ��:	�	Q� ��	+� 7� =� � � ��	� ��6
�
� g+�	�
� �+S� 3�	� ���� 2�:�	�� ��  �:�
� +� �W�	� ����
� +� �W�	� ��	� �� � ��� �:+� t�	� ���+� t�	� �� �:+� ���+� �+(� 3+U+� � ��:�6+� ��� S++� 7*� WP2�8 *� W2� �Y�:� #� �Y� �Y�� �U� �������:�6+� t
U���+:� 3+;*� WQ2� Y� ^�� � � 3+`� 3+� 7*� WR2+�@*� WP2�C � E W+`� 3� +�� 3+� �+� t��� |� ��:�W� ��+� 7� =� � � ��� ��6�� g+��� �+Y� 3�� ���� 2�:��� ��  �:�� +� �W�� ����� +� �W�� ��� �� � ��� �:+� t�� ���+� t�� �� �:+� ���+� �+(� 3+[+� � ��:�6+� ��� S++� 7*� WS2�8 *� W2� �Y�:� #� �Y� �Y�� �[� �������:�6+� t
[���+:� 3+;*� WT2� Y� ^�� � � 3+`� 3+� 7*� WU2+�@*� WS2�C � E W+`� 3� +(� 3+� 7*� W
2� � ]� r� � � )+� 7*� WV2� � _� r� � � � ��+(� 3+� 7*� W2� � &� r� � �+`� 3+� 7*� WW2��� E W+`� 3+� 7*� WX2`�e� E W+`� 3+� 7*� W2� � +� 7*� WW2� � �h� � � 6+� 7*� W2� � +� 7*� WX2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3� ^+� 7*� W2� � &� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +`� 3� +(� 3+� 7*� W2� � c� r� � ��+(� 3+� 7*� W2� � &� r� � �+`� 3+� 7*� WY2��� E W+`� 3+� 7*� WZ2i�e� E W+`� 3+� 7*� W2� � +� 7*� WY2� � �h� � � 6+� 7*� W2� � +� 7*� WZ2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3� ^+� 7*� W2� � &� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +`� 3� +(� 3+� 7*� W2� � g� r� � ��+(� 3+� 7*� W2� � &� r� � �+`� 3+� 7*� W[2��� E W+`� 3+� 7*� W\2i�e� E W+`� 3+� 7*� W2� � +� 7*� W[2� � �h� � � 6+� 7*� W2� � +� 7*� W\2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3� ^+� 7*� W2� � &� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +`� 3� +(� 3+� 7*� W2� � k� r� � ��+(� 3+� 7*� W2� � &� r� � �+`� 3+� 7*� W]2��� E W+`� 3+� 7*� W^2i�e� E W+`� 3+� 7*� W2� � +� 7*� W]2� � �h� � � 6+� 7*� W2� � +� 7*� W^2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3� ^+� 7*� W2� � &� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +`� 3� +(� 3+� 7*� W2� � ȸ r� � �t+`� 3+� 7*� W2� � � r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�+� 7*� W2� � l� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3��+� 7*� W2� � n� r� � � )+� 7*� W2� � p� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�++� 7*� W2� � r� r� � � (+� 7*� W2� � � r� � � � � )+� 7*� W2� � g� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� }+� 7*� W2� � � r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2�u� E W+`� 3+`� 3� +�� 3+� 7*� W2� � w� r� � � )+� 7*� W 2� � &� r� � � � �+`� 3+� 7*� WW2��� E W+`� 3+� 7*� WX2`�e� E W+`� 3+� 7*� W 2� � +� 7*� WW2� � �h� � � 6+� 7*� W 2� � +� 7*� WX2� � �h� � � � � &+`� 3+� 7*� W2�z� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3� �+� 7*� W2� � w� r� � � )+� 7*� W 2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +�� 3+� 7*� W2� � |� r� � ��+(� 3+� 7*� W#2� � &� r� � �+`� 3+� 7*� WY2��� E W+`� 3+� 7*� WZ2i�e� E W+`� 3+� 7*� W#2� � +� 7*� WY2� � �h� � � 6+� 7*� W#2� � +� 7*� WZ2� � �h� � � � � &+`� 3+� 7*� W2�� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3� ^+� 7*� W#2� � &� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +`� 3� +(� 3+� 7*� W2� � �� r� � ��+(� 3+� 7*� W&2� � &� r� � �+`� 3+� 7*� W[2��� E W+`� 3+� 7*� W\2i�e� E W+`� 3+� 7*� W&2� � +� 7*� W[2� � �h� � � 6+� 7*� W&2� � +� 7*� W\2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3� ^+� 7*� W&2� � &� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +`� 3� +(� 3+� 7*� W2� � �� r� � ��+(� 3+� 7*� W)2� � &� r� � �+`� 3+� 7*� W]2��� E W+`� 3+� 7*� W^2i�e� E W+`� 3+� 7*� W)2� � +� 7*� W]2� � �h� � � 6+� 7*� W)2� � +� 7*� W^2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3� ^+� 7*� W)2� � &� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +`� 3� +(� 3+� 7*� W2� � �� r� � �t+`� 3+� 7*� W 2� � � r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�+� 7*� W 2� � l� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3��+� 7*� W 2� � n� r� � � )+� 7*� W#2� � p� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�++� 7*� W 2� � r� r� � � (+� 7*� W#2� � � r� � � � � )+� 7*� W&2� � g� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� }+� 7*� W2� � � r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2��� E W+`� 3+`� 3� +�� 3+� 7*� W2� � �� r� � � )+� 7*� W,2� � &� r� � � � �+`� 3+� 7*� WW2��� E W+`� 3+� 7*� WX2`�e� E W+`� 3+� 7*� W,2� � +� 7*� WW2� � �h� � � 6+� 7*� W,2� � +� 7*� WX2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!�u� E W+`� 3+`� 3� �+� 7*� W2� � �� r� � � )+� 7*� W,2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!�z� E W+`� 3� +�� 3+� 7*� W2� � �� r� � ��+(� 3+� 7*� W/2� � &� r� � �+`� 3+� 7*� WY2��� E W+`� 3+� 7*� WZ2i�e� E W+`� 3+� 7*� W/2� � +� 7*� WY2� � �h� � � 6+� 7*� W/2� � +� 7*� WZ2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!�u� E W+`� 3+`� 3� ^+� 7*� W/2� � &� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!�z� E W+`� 3� +`� 3� +(� 3+� 7*� W2� � �� r� � ��+(� 3+� 7*� W22� � &� r� � �+`� 3+� 7*� W[2��� E W+`� 3+� 7*� W\2i�e� E W+`� 3+� 7*� W22� � +� 7*� W[2� � �h� � � 6+� 7*� W22� � +� 7*� W\2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!�u� E W+`� 3+`� 3� ^+� 7*� W22� � &� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!�z� E W+`� 3� +`� 3� +(� 3+� 7*� W2� � �� r� � ��+(� 3+� 7*� W52� � &� r� � �+`� 3+� 7*� W]2��� E W+`� 3+� 7*� W^2i�e� E W+`� 3+� 7*� W52� � +� 7*� W]2� � �h� � � 6+� 7*� W52� � +� 7*� W^2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!�u� E W+`� 3+`� 3� ^+� 7*� W52� � &� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!�z� E W+`� 3� +`� 3� +(� 3+� 7*� W2� � �� r� � �t+`� 3+� 7*� W,2� � � r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!�u� E W+`� 3�+� 7*� W,2� � l� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!�u� E W+`� 3��+� 7*� W,2� � n� r� � � )+� 7*� W/2� � p� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!�u� E W+`� 3�++� 7*� W,2� � r� r� � � (+� 7*� W/2� � � r� � � � � )+� 7*� W22� � g� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!�u� E W+`� 3� }+� 7*� W2� � � r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!�u� E W+`� 3� #+`� 3+� 7*� W2��� E W+`� 3+`� 3� +�� 3+� 7*� W2� � �� r� � � )+� 7*� W82� � &� r� � � � �+`� 3+� 7*� WW2��� E W+`� 3+� 7*� WX2`�e� E W+`� 3+� 7*� W82� � +� 7*� WW2� � �h� � � 6+� 7*� W82� � +� 7*� WX2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!�� E W+`� 3+`� 3� s+� 7*� W2� � �� r� � � )+� 7*� W82� � &� r� � � � � '+`� 3+� 7*� W2��� E W+(� 3� +�� 3+� 7*� W2� � �� r� � ��+(� 3+� 7*� W;2� � &� r� � ��+`� 3+� 7*� W82� � &� r� � � )+� 7*� W>2� � &� r� � � � � )+� 7*� WA2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�+`� 3+� 7*� WY2��� E W+`� 3+� 7*� WZ2i�e� E W+`� 3+� 7*� W;2� � +� 7*� WY2� � �h� � � 6+� 7*� W;2� � +� 7*� WZ2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!�� E W+`� 3+`� 3+`� 3�+� 7*� W;2� � &� r� � � �+`� 3+� 7*� W82� � &� r� � � )+� 7*� W>2� � &� r� � � � � )+� 7*� WA2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2��� E W+`� 3+`� 3� +`� 3� +(� 3+� 7*� W2� � �� r� � ��+`� 3+� 7*� W>2� � &� r� � ��+`� 3+� 7*� WA2� � &� r� � � )+� 7*� W;2� � &� r� � � � � )+� 7*� W82� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�+`� 3+� 7*� W[2��� E W+`� 3+� 7*� W\2i�e� E W+`� 3+� 7*� W>2� � +� 7*� W[2� � �h� � � 6+� 7*� W>2� � +� 7*� W\2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!�� E W+`� 3+`� 3+`� 3�+� 7*� W>2� � &� r� � � �+`� 3+� 7*� W82� � &� r� � � )+� 7*� WA2� � &� r� � � � � )+� 7*� W;2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2��� E W+`� 3+`� 3� +`� 3� +(� 3+� 7*� W2� � �� r� � ��+`� 3+� 7*� WA2� � &� r� � ��+`� 3+� 7*� W>2� � &� r� � � )+� 7*� W;2� � &� r� � � � � )+� 7*� W82� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�+`� 3+� 7*� W]2��� E W+`� 3+� 7*� W^2i�e� E W+`� 3+� 7*� WA2� � +� 7*� W]2� � �h� � � 6+� 7*� WA2� � +� 7*� W^2� � �h� � � � � &+`� 3+� 7*� W2��� E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!�� E W+`� 3+`� 3+`� 3�+� 7*� WA2� � &� r� � � �+`� 3+� 7*� W82� � &� r� � � )+� 7*� W>2� � &� r� � � � � )+� 7*� W;2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2��� E W+`� 3+`� 3� +`� 3� +(� 3+� 7*� W2� � �� r� � �t+`� 3+� 7*� W82� � � r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�+� 7*� W82� � l� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3��+� 7*� W82� � n� r� � � )+� 7*� W;2� � p� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�++� 7*� W82� � r� r� � � (+� 7*� W;2� � � r� � � � � )+� 7*� W>2� � g� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� }+� 7*� W2� � � r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2��� E W+`� 3+`� 3� +(� 3+� 7*� W2� � ¸ r� � � )+� 7*� WD2� � &� r� � � � �+`� 3+� 7*� WW2��� E W+`� 3+� 7*� WX2`�e� E W+`� 3+� 7*� WD2� � +� 7*� WW2� � �h� � � 6+� 7*� WD2� � +� 7*� WX2� � �h� � � � � &+`� 3+� 7*� W2�Ź E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3� r+� 7*� W2� � ¸ r� � � )+� 7*� WD2� � &� r� � � � � &+`� 3+� 7*� W2�Ź E W+`� 3� +�� 3+� 7*� W2� � Ǹ r� � ��+`� 3+� 7*� WG2� � &� r� � ��+`� 3+� 7*� WD2� � &� r� � � )+� 7*� WJ2� � &� r� � � � � )+� 7*� WM2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�+`� 3+� 7*� WY2��� E W+`� 3+� 7*� WZ2i�e� E W+`� 3+� 7*� WG2� � +� 7*� WY2� � �h� � � 6+� 7*� WG2� � +� 7*� WZ2� � �h� � � � � &+`� 3+� 7*� W2�ʹ E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3+`� 3�+� 7*� WG2� � &� r� � � �+`� 3+� 7*� WD2� � &� r� � � )+� 7*� WJ2� � &� r� � � � � )+� 7*� WM2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2�ʹ E W+`� 3+`� 3� +`� 3� +(� 3+� 7*� W2� � ̸ r� � ��+`� 3+� 7*� WJ2� � &� r� � ��+`� 3+� 7*� WM2� � &� r� � � )+� 7*� WG2� � &� r� � � � � )+� 7*� WD2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�+`� 3+� 7*� W[2��� E W+`� 3+� 7*� W\2i�e� E W+`� 3+� 7*� WJ2� � +� 7*� W[2� � �h� � � 6+� 7*� WJ2� � +� 7*� W\2� � �h� � � � � &+`� 3+� 7*� W2�Ϲ E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3+`� 3�+� 7*� WJ2� � &� r� � � �+`� 3+� 7*� WD2� � &� r� � � )+� 7*� WM2� � &� r� � � � � )+� 7*� WG2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2�Ϲ E W+`� 3+`� 3� +`� 3� +(� 3+� 7*� W2� � Ѹ r� � �-s+(� 3+� 7*� WM2� � &� r� � ��+`� 3+� 7*� WJ2� � &� r� � � )+� 7*� WG2� � &� r� � � � � )+� 7*� WD2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�+`� 3+� 7*� W]2��� E W+`� 3+� 7*� W^2i�e� E W+`� 3+� 7*� WM2� � +� 7*� W]2� � �h� � � 6+� 7*� WM2� � +� 7*� W^2� � �h� � � � � &+`� 3+� 7*� W2�Թ E W+`� 3� 9+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3+`� 3+`� 3�+� 7*� WM2� � &� r� � � �+`� 3+� 7*� WD2� � &� r� � � )+� 7*� WJ2� � &� r� � � � � )+� 7*� WG2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2�Թ E W+`� 3+`� 3� +˶ 3+� 7*� W2� � ָ r� � �t+`� 3+� 7*� WD2� � � r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�+� 7*� WD2� � l� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3��+� 7*� WD2� � n� r� � � )+� 7*� WG2� � p� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3�++� 7*� WD2� � r� r� � � (+� 7*� WG2� � � r� � � � � )+� 7*� WJ2� � g� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� }+� 7*� W2� � � r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2�ٹ E W+`� 3+`� 3� +(� 3+� 7*� W2� � ۸ r� � � )+� 7*� WR2� � &� r� � � � � �+`� 3+� 7*� W_2�+� 7*� WR2� � � ޶� E W+`� 3+�+� 7*� W_2� � �� &+`� 3+� 7*� W2��� E W+`� 3� ^+�+� 7*� W_2� � �� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +`� 3� �+� 7*� W2� � ۸ r� � � )+� 7*� WR2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +(� 3+� 7*� W2� � � r� � � )+� 7*� WO2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� �+� 7*� W2� � � r� � � )+� 7*� WO2� � &� r� � � � � �+`� 3+�+� 7*� WO2� � � ޸���� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2��� E W+`� 3+`� 3� +(� 3+� 7*� W2� � �� r� � �$�+`� 3+� 7�!��� E W+�� 3+� t��� |���:����6��$%+��� �+`� 3+� �+� t��� |� ��:��� ��+� 7� =� � � ��� ��6�� �+��� �+� 3+++� 7*� W2� � ���+� 3�� ���Ч 2�:��� ��  �: �� +� �W�� �� ��� +� �W�� ��� �� � ��� �:!+� t�� ��!�+� t�� �� �:"+� ��"�+� �+`� 3+� �+� t��� |� ��:#�#�� ��#+� 7� =� � � ��#� ��6$�$� �+�#�$� �+� 3+++� 7*� W2� � ���+
� 3�#� ���Ч 2�:%�#�%� ��  �:&�$� +� �W�#� ��&��$� +� �W�#� ��#� �� � ��� �:'+� t�#� ��'�+� t�#� �� �:(+� ��(�+� �+`� 3+� �+� t��� |� ��:)�)�� ��)+� 7� =� � � ��)� ��6*�*� �+�)�*� �+� 3+++� 7*� W2� � ���+� 3�)� ���Ч 2�:+�)�+� ��  �:,�*� +� �W�)� ��,��*� +� �W�)� ��)� �� � ��� �:-+� t�)� ��-�+� t�)� �� �:.+� ��.�+� �+`� 3+� �+� t��� |� ��:/�/�� ��/+� 7� =� � � ��/� ��60�0� �+�/�0� �+� 3+++� 7*� W2� � ���+� 3�/� ���Ч 2�:1�/�1� ��  �:2�0� +� �W�/� ��2��0� +� �W�/� ��/� �� � ��� �:3+� t�/� ��3�+� t�/� �� �:4+� ��4�+� �+`� 3+� �+� t��� |� ��:5�5�� ��5+� 7� =� � � ��5� ��66�6� �+�5�6� �+� 3+++� 7*� W 2� � ���+� 3�5� ���Ч 2�:7�5�7� ��  �:8�6� +� �W�5� ��8��6� +� �W�5� ��5� �� � ��� �:9+� t�5� ��9�+� t�5� �� �::+� ��:�+� �+`� 3+� �+� t��� |� ��:;�;�� ��;+� 7� =� � � ��;� ��6<�<� �+�;�<� �+� 3+++� 7*� W#2� � ���+� 3�;� ���Ч 2�:=�;�=� ��  �:>�<� +� �W�;� ��>��<� +� �W�;� ��;� �� � ��� �:?+� t�;� ��?�+� t�;� �� �:@+� ��@�+� �+`� 3+� �+� t��� |� ��:A�A�� ��A+� 7� =� � � ��A� ��6B�B� �+�A�B� �+� 3+++� 7*� W&2� � ���+� 3�A� ���Ч 2�:C�A�C� ��  �:D�B� +� �W�A� ��D��B� +� �W�A� ��A� �� � ��� �:E+� t�A� ��E�+� t�A� �� �:F+� ��F�+� �+`� 3+� �+� t��� |� ��:G�G�� ��G+� 7� =� � � ��G� ��6H�H� �+�G�H� �+� 3+++� 7*� W)2� � ���+� 3�G� ���Ч 2�:I�G�I� ��  �:J�H� +� �W�G� ��J��H� +� �W�G� ��G� �� � ��� �:K+� t�G� ��K�+� t�G� �� �:L+� ��L�+� �+`� 3+� �+� t��� |� ��:M�M�� ��M+� 7� =� � � ��M� ��6N�N� �+�M�N� �+� 3+++� 7*� W,2� � ���+� 3�M� ���Ч 2�:O�M�O� ��  �:P�N� +� �W�M� ��P��N� +� �W�M� ��M� �� � ��� �:Q+� t�M� ��Q�+� t�M� �� �:R+� ��R�+� �+`� 3+� �+� t��� |� ��:S�S�� ��S+� 7� =� � � ��S� ��6T�T� �+�S�T� �+� 3+++� 7*� W/2� � ���+� 3�S� ���Ч 2�:U�S�U� ��  �:V�T� +� �W�S� ��V��T� +� �W�S� ��S� �� � ��� �:W+� t�S� ��W�+� t�S� �� �:X+� ��X�+� �+`� 3+� �+� t��� |� ��:Y�Y�� ��Y+� 7� =� � � ��Y� ��6Z�Z� �+�Y�Z� �+� 3+++� 7*� W22� � ���+� 3�Y� ���Ч 2�:[�Y�[� ��  �:\�Z� +� �W�Y� ��\��Z� +� �W�Y� ��Y� �� � ��� �:]+� t�Y� ��]�+� t�Y� �� �:^+� ��^�+� �+`� 3+� �+� t��� |� ��:_�_�� ��_+� 7� =� � � ��_� ��6`�`� �+�_�`� �+� 3+++� 7*� W52� � ���+� 3�_� ���Ч 2�:a�_�a� ��  �:b�`� +� �W�_� ��b��`� +� �W�_� ��_� �� � ��� �:c+� t�_� ��c�+� t�_� �� �:d+� ��d�+� �+(� 3+� 7*� W82� � &� r� � �$+`� 3+� �+� t��� |� ��:e�e�� ��e+� 7� =� � � ��e� ��6f�f� �+�e�f� �+� 3+++� 7*� W82� � ���+ � 3�e� ���Ч 2�:g�e�g� ��  �:h�f� +� �W�e� ��h��f� +� �W�e� ��e� �� � ��� �:i+� t�e� ��i�+� t�e� �� �:j+� ��j�+� �+`� 3�%+� 7*� W82� � &� r� � �+`� 3+� �+� t��� |� ��:k�k�� ��k+� 7� =� � � ��k� ��6l�l� g+�k�l� �+"� 3�k� ���� 2�:m�k�m� ��  �:n�l� +� �W�k� ��n��l� +� �W�k� ��k� �� � ��� �:o+� t�k� ��o�+� t�k� �� �:p+� ��p�+� �+`� 3� +(� 3+� 7*� W;2� � &� r� � �$+`� 3+� �+� t��� |� ��:q�q�� ��q+� 7� =� � � ��q� ��6r�r� �+�q�r� �+� 3+++� 7*� W;2� � ���+$� 3�q� ���Ч 2�:s�q�s� ��  �:t�r� +� �W�q� ��t��r� +� �W�q� ��q� �� � ��� �:u+� t�q� ��u�+� t�q� �� �:v+� ��v�+� �+`� 3�%+� 7*� W;2� � &� r� � �+`� 3+� �+� t��� |� ��:w�w�� ��w+� 7� =� � � ��w� ��6x�x� g+�w�x� �+&� 3�w� ���� 2�:y�w�y� ��  �:z�x� +� �W�w� ��z��x� +� �W�w� ��w� �� � ��� �:{+� t�w� ��{�+� t�w� �� �:|+� ��|�+� �+`� 3� +(� 3+� 7*� W>2� � &� r� � �$+`� 3+� �+� t��� |� ��:}�}�� ��}+� 7� =� � � ��}� ��6~�~� �+�}�~� �+� 3+++� 7*� W>2� � ���+(� 3�}� ���Ч 2�:�}�� ��  �:��~� +� �W�}� �����~� +� �W�}� ��}� �� � ��� �:�+� t�}� ����+� t�}� �� �:�+� ����+� �+`� 3�%+� 7*� W>2� � &� r� � �+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� g+����� �+*� 3��� ���� 2�:������ ��  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� t��� ����+� t��� �� �:�+� ����+� �+`� 3� +(� 3+� 7*� WA2� � &� r� � �$+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� �+����� �+� 3+++� 7*� WA2� � ���+,� 3��� ���Ч 2�:������ ��  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� t��� ����+� t��� �� �:�+� ����+� �+`� 3�%+� 7*� WA2� � &� r� � �+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� g+����� �+.� 3��� ���� 2�:������ ��  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� t��� ����+� t��� �� �:�+� ����+� �+`� 3� +˶ 3+� 7*� WD2� � &� r� � �$+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� �+����� �+� 3+++� 7*� WD2� � ���+0� 3��� ���Ч 2�:������ ��  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� t��� ����+� t��� �� �:�+� ����+� �+`� 3�%+� 7*� WD2� � &� r� � �+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� g+����� �+2� 3��� ���� 2�:������ ��  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� t��� ����+� t��� �� �:�+� ����+� �+`� 3� +(� 3+� 7*� WG2� � &� r� � �$+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� �+����� �+� 3+++� 7*� WG2� � ���+4� 3��� ���Ч 2�:������ ��  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� t��� ����+� t��� �� �:�+� ����+� �+`� 3�%+� 7*� WG2� � &� r� � �+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� g+����� �+6� 3��� ���� 2�:������ ��  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� t��� ����+� t��� �� �:�+� ����+� �+`� 3� +(� 3+� 7*� WJ2� � &� r� � �$+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� �+����� �+� 3+++� 7*� WJ2� � ���+8� 3��� ���Ч 2�:������ ��  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� t��� ����+� t��� �� �:�+� ����+� �+`� 3�%+� 7*� WJ2� � &� r� � �+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� g+����� �+:� 3��� ���� 2�:������ ��  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� t��� ����+� t��� �� �:�+� ����+� �+`� 3� +(� 3+� 7*� WM2� � &� r� � �$+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� �+����� �+� 3+++� 7*� WM2� � ���+<� 3��� ���Ч 2�:������ ��  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� t��� ����+� t��� �� �:�+� ����+� �+`� 3�%+� 7*� WM2� � &� r� � �+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� g+����� �+>� 3��� ���� 2�:������ ��  �:���� +� �W��� ��¿��� +� �W��� ���� �� � ��� �:�+� t��� ��ÿ+� t��� �� �:�+� ��Ŀ+� �+`� 3� +(� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ��Ŷ ��6���� �+���ƶ �+� 3++� 7*� WO2� � � ޶�+@� 3�Ŷ ���ӧ 2�:����Ƕ ��  �:���� +� �W�Ŷ ��ȿ��� +� �W�Ŷ ��Ŷ �� � ��� �:�+� t�Ŷ ��ɿ+� t�Ŷ �� �:�+� ��ʿ+� �+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ��˶ ��6���� �+���̶ �+� 3++� 7*� WR2� � � ޶�+B� 3�˶ ���ӧ 2�:����Ͷ ��  �:���� +� �W�˶ ��ο��� +� �W�˶ ��˶ �� � ��� �:�+� t�˶ ��Ͽ+� t�˶ �� �:�+� ��п+� �+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ��Ѷ ��6���� �+���Ҷ �+� 3++� 7*� WU2� � � ޶�+D� 3�Ѷ ���ӧ 2�:����Ӷ ��  �:���� +� �W�Ѷ ��Կ��� +� �W�Ѷ ��Ѷ �� � ��� �:�+� t�Ѷ ��տ+� t�Ѷ �� �:�+� ��ֿ+� �+`� 3��E��3� 2�:���׶F�  �:��� +� �W��G�ؿ�� +� �W��G��H� � ��� �:�+� t�� ��ٿ+� t�� �+˶ 3� +(� 3�U+� 7*� W
2� � ]� r� � � )+� 7*� WV2� � J� r� � � � �	+(� 3+� 7*� WR2� � &� r� � � �+`� 3+� 7*� W_2�+� 7*� WR2� � � ޶� E W+`� 3+�+� 7*� W_2� � �� &+`� 3+� 7*� W2��� E W+`� 3� ^+�+� 7*� W_2� � �� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +`� 3� ^+� 7*� WR2� � &� r� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� +(� 3+� 7*� W2� � c� r� � � )+� 7*� WO2� � &� r� � � � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� �+� 7*� W2� � c� r� � � )+� 7*� WO2� � &� r� � � � � �+`� 3+�+� 7*� WO2� � � ޸���� � � <+`� 3+� 7*� W2��� E W+`� 3+� 7�!��� E W+`� 3� #+`� 3+� 7*� W2��� E W+`� 3+`� 3� +(� 3+� 7*� W2� � g� r� � �+`� 3+� 7�!��� E W+(� 3+� t��� |���:��ڶ��6�����+���۶ �+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ��ܶ ��6���� �+���ݶ �+� 3++� 7*� WO2� � � ޶�+@� 3�ܶ ���ӧ 2�:����޶ ��  �:���� +� �W�ܶ ��߿��� +� �W�ܶ ��ܶ �� � ��� �:�+� t�ܶ ���+� t�ܶ �� �:�+� ���+� �+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ��� ��6���� �+���� �+� 3++� 7*� WR2� � � ޶�+B� 3�� ���ӧ 2�:����� ��  �:���� +� �W�� ������ +� �W�� ��� �� � ��� �:�+� t�� ���+� t�� �� �:�+� ���+� �+`� 3�ڶE��ȧ 2�:�����F�  �:���� +� �W�ڶG����� +� �W�ڶG�ڶH� � ��� �:�+� t�ڶ ���+� t�ڶ �+(� 3� +�� 3� +L� 3+N� 3+� �+� t��� |� ��:���P� ���+� 7� =� � � ��� ��6���� g+���� �+R� 3�� ���� 2�:������ ��  �:���� +� �W�� ������ +� �W�� ��� �� � ��� �:�+� t�� ���+� t�� �� �:�+� ���+� �+(� 3++� 7*� W`2�8 ����� � �h+T� 3+� �+P�X�:�+�[�6�����a �6���d � � ��6�����d �j�:�+� 7��n ��d�6�����`�r� v����u��y � � � � T��u�6�+{� 3++� 7*� Wa2� � � ޶ 3+}� 3++� 7*� Wa2� � � ޶ 3+� 3���� .�:�������y W+� 7�� ������������y W+� 7�� ���� �:�+� ����+� �+�� 3� 
+�� 3+�� 3+� 7*� W2� � c� r� � � 1+`� 3+� �+�� 3� �:�+� ����+� �+`� 3� +(� 3+� 7*� W2� � g� r� � � 1+`� 3+� �+�� 3� �:�+� ����+� �+`� 3� +�� 3+� 7*� W2� � k� r� � � 1+`� 3+� �+�� 3� �:�+� ����+� �+`� 3� +�� 3+�� 3+� 7*� Wb2++������ E W+`� 3+� �+� t��� |� ��:����� ���+� 7� =� � � ���� ��6���� g+����� �+�� 3��� ���� 2�: ��� � ��  �:��� +� �W��� ������ +� �W��� ���� �� � ��� �:+� t��� ���+� t��� �� �:+� ���+� �+`� 3+� �+� t��� |� ��:��� ��+� 7� =� � � ��� ��6�� g+��� �+�� 3�� ���� 2�:��� ��  �:�� +� �W�� ����� +� �W�� ��� �� � ��� �:+� t�� ���+� t�� �� �:	+� ��	�+� �+`� 3+� �+�� 3++� d*� Wc2� j � ޶ 3+�� 3+++� 7*� Wd2�8 ��� ظ ޶ 3+�� 3+++� 7*� We2�8 ��� ظ ޶ 3+�� 3++� 7*� Wb2� � � ޶ 3+�� 3� �:
+� ��
�+� �+�� 3� � � �   �  ��� )���  i��  X  II  BRU )B^a  ��  ��    Waa  ���  �  akk  ���  �				  �#& )�/2  �hh  ���  14 )=@  �vv  ���  ==  ���  ���  1;;  ���  
 )
&)  �__  �yy  ��� )���  }    l  L\_ )Lhk  ��  ��  ��  )�	  �BB  �\\  ��� )���  `��  O��  /?B )/KN  ��  ���  ��� )���  �%%  �??  q�� )q��  C��  2��    " % )  . 1  � g g  � � �  !�!�!� )!�!�!�  !�""  !t""""  #T#d#g )#T#p#s  #&#�#�  ##�#�  $�%% )$�%%  $�%J%J  $�%d%d  &�&�&� )&�&�&�  &h&�&�  &W''  (7(G(J )(7(S(V  (	(�(�  '�(�(�  )�)�)� ))�)�)�  )�*-*-  )�*G*G  +y+�+� )+y+�+�  +K+�+�  +:+�+�  --*-- )--6-9  ,�-o-o  ,�-�-�  .�.�.� ).�.�.�  .�//  .|/*/*  0\0l0o )0\0x0{  0.0�0�  00�0�  1�22 )1�22  1�2R2R  1�2l2l  3�3�3� )3�3�3�  3r44  3_4;4;  5�5�5� )5�5�5�  5S5�5�  5@66  7t7�7� )7t7�7�  787�7�  7%88  uBuuux )uBu�u�  uu�u�  t�u�u�  vZv�v� )vZv�v�  vv�v�  vww  wrw�w� )wrw�w�  w6w�w�  w#x x   x�x�x� )x�x�x�  xNyy  x;y8y8  y�y�y� )y�y�y�  yfz.z.  ySzPzP  z�z�z� )z�z�{  z~{F{F  zk{h{h  {�|| ){�||  {�|^|^  {�|�|�  |�}}  )|�}/}2  |�}v}v  |�}�}�  ~~5~8 )~~G~J  }�~�~�  }�~�~�  MP )_b  ~���  ~���  �2�e�h )�2�w�z  �����  ����  �J�}�� )�J����  ��ց�  ������  ������ )���Ђ�  �O��  �<�9�9  �΃��� )�΃��  ���9�9  ��[�[  ���*�- )���<�?  ������  ������  �:�L�O )�:�^�a  ������  ��ǆ�  �c���� )�c����  �'���  ���  ������ )���ʈ�  �j��  �W�3�3  �ϊ� )�ϊ�  ���[�[  ���}�}  ��$�' )��6�9  �֋}�}  �Ë���  �:�m�p )�:���  ���ƌ�  ����  �}���� )�}����  �A���  �.�
�
  ���َ� )�����  �j�2�2  �W�T�T  ����� )���  ���T�T  ���v�v  ��E�H )��W�Z  �֑���  �Ñ���  �U�g�j )�U�y�|  �����  ����  �~���� )�~�Ó�  �B�
�
  �/�,�,  ���Ӕ� )�����  ���,�,  �r�N�N  ��� )��  ���K�K  �s�m�m  �ח�
 )�ח�  ���`�`  ������  ��� )��.�1  ���u�u  ������  t阹�� )t�˘�  tʙ�  �(�X�[ )�(�j�m  �읱��  �ٝӝ�  �=�m�p )�=���  ��ƞ�  ����  �ϟ
� )�ϟ�  ���c�c  ���	� )����  ���b�b  ������  �4����  �ˢ
�
  �^�h�h  ������  �
��  ���£� )���ԣ�  �u��  �b�=�=  ������ )���ˤ�  �k��  �X�4�4  �O�ߥ�   l         * +  m  �   
        6  7 ! a $ z - � 0 � 9 � O � u � � � � �9 �B �K �T �� � � �! �V �Y �b �� �� � �+ �4 �> �� � 5\����F
�Cl�����!�"�.�/01"2%3P4[5n6q7{>~J�K�R�S�T�U�V�WXYZ!b+/�9�Z�e�x�{���������������	�	�	�	#�	-�	��	��	��	��
�
�
'�
��
��
��
���;�{���������������:�@�D�l�������������%����������������
7J)Q:U;_T�U�V�W�X�Z�[�\�]�^a*b5cHdKeUg}h�i�j�k�m�������z���K�p�����������4�[�e���+��������P���M�v�������m����>�H������������3���0�Y�������P�����!�+�u���r������� � ��!�!<�!c�!m�!��"3�"��"��#�#�#X�#��$U�$~�$� $�$�%u%�&	&F
&P&�''�'�'�'�(;(�)8)a)�)�!)�#*X&*�'+(+))+3++}-+�0,z1,�2,�3,�5-7-�:.;.D<.k=.u?.�A/;D/�E/�F0G0J0`L0�O1]P1�Q1�R1�T2V2}Y2�Z3'[3N\3X^3�`4Pb4�c5d5/e59g5�i61k6�l6�m7n7q7xs8u8�v8�w8�x9z9V|9~}9�~9�:!�:;�:D�:^�:t�:z�:��:��:��:��:��;�;9�;S�;p�;��;��;��<�</�<5�<`�<z�<��<��<��<��<��=�=+�=��=��=��=��=��=��>�>5�>K�>T�>^�>��>��>��>��?R�?l�?u�?��?��?��?��?��@�@�@�@A�@h�@��@��@��@��@��AH�Ab�Ax�A��B�B&�BP�Bj�B��B��B��B��B��C�C�C<�C��C��C��C��C��D�DV�Dp�D��D��D��D��D��E�E��E��E��E��E��E��F�F"�F8�FA�FK�Ft�F��F��F��G?�GY�Gb�G|�G��G��G� G�G�G�HH/HWHq	H�
H�III7IMISI~I�I�I�I�I�JJ*J@JkJ�J�J�K
K  K�!K�"K�#K�$L%L(&L1'LK(LQ)L[,L�-L�.L�/MP0Mj1Ms2M�3M�4M�5M�6N7N.8N8;Na=N�>N�?N�@O,AOFBOOCOiDOEO�FO�GO�HO�IO�JO�LPNPDOP^PP{QP�RQSQ
TQ$UQ:VQ@WQkXQ�YQ�ZQ�[Q�]Q�_Q�`RaR6bR�cR�dR�eR�fR�gR�hS&iS@jSVkS_lSinS�oS�pS�qS�rTsT-tTCuT�vT�wT�xUFyU`zUv{U�|U�}U�~U�U��U��V�VU�Vo�V��V��W�W�W5�WK�WQ�W��W��W��W��X�X��X��X��X��X��Y�Yt�Y��Y��Y��Y��Y��Y��Y��Zz�Z��Z��Z��Z��Z��Z��Z��[�[6�[��[��[��[��\�\"�\��\��\��\��\��\��\��]�]��]��]��]��]��]��]��^ �^(�^P�^��^��^��_�_�_<�_��_��_��_��_��`�`�`2�`��`��`��`��a�a�a�a�aB�ai�a��a��a��a��a��bI�bc�by�b��c�c'�cQ�ck�c��c��c��c��c��d�d �d=�d��d��d��d��d��e�eW�eq�e{e�e�fGfafwf�f�	f�
g#g=gFg`gvg|g�g�h)hChYhbh|h�h�h�h�h�iai{i� i�!i�"i�#j=$jW%j`&jz'j�(j�)j�*j�+kC,k]-ks.k|/k�0k�1k�2k�4k�6l 7l|8l�9l�:l�;l�<l�=mX>mr?m{@m�Am�Bm�Cm�Dm�En^FnxGn�Hn�In�Jn�Kn�On�PoQo)Ro?SojTo�Uo�Vo�Wp	XpYp�Zp�[p�\p�]q^q'_q0`qJaqPbqZdq�eq�fq�grhrAir[jrqkrzlr�mr�nr�os	qs[rsuss�ts�utvt*wt@xtIytczti{ts}t�~t��t��uF�ug�v�v^�v�w�wv�w��x4�x��x��yL�y��y��zd�z��z��{|�{��{��|��|��}�}��~�~'�~���?����6��W�����N��o����5��������M��x�����o��y����������������>����������g�����%��P���GÉQŉyƉ�ǉ�Ȋ�Ɋ�ʋ̋�͋�ы�Ҍ>ӌ_Ԍ�Ս'֍�؎َ(ێP܎�ݎ�ޏhߏ����␊㐔吼��7�����Y��� �(���@�k�����b��l��������������������� ����4�>��
������&�Q�k�������������A�[�q������&�/�I �O!�Y#��$��&��'�,(�J)��*�A+�_,��-��/��2��5��R��T��V��X��\�u]��^�_�"l�)m�,p�0t�3|�W}�b~�y�|������������������������%��(��2��<��[�����Q�����H��S�n     ) �� k        �    n     ) �� k         �    n     ) �� k        �    n    �    k       *f� YYʸ�SYҸ�SYԸ�SYָ�SY,��SYظ�SYڸ�SYܸ�SY6��SY	޸�SY
��SY��SY���SY��SY��SY��SY��SY��SY��SYи�SY��SY��SYָ�SY���SY���SYܸ�SY���SY���SY��SY���SY���SY��SY  ��SY!��SY"��SY#��SY$��SY%���SY&��SY'
��SY(���SY)��SY*��SY+ ��SY,��SY-��SY.��SY/��SY0��SY1��SY2��SY3��SY4��SY5��SY6��SY7��SY8 ��SY9"��SY:��SY;$��SY<&��SY=$��SY>(��SY?*��SY@*��SYA,��SYB.��SYC0��SYD0��SYE2��SYF6��SYG4��SYH6��SYI<��SYJ8��SYK:��SYLB��SYM<��SYN>��SYO@��SYPB��SYQQ��SYRD��SYSF��SYTW��SYUH��SYVJ��SYWL��SYXN��SYYP��SYZR��SY[T��SY\V��SY]X��SY^Z��SY_\��SY`^��SYa`��SYbb��SYcd��SYdf��SYeh��S� W�     o    