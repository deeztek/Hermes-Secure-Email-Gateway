����   2� relay_host_cfm$cf  lucee/runtime/PageImpl  /admin/relay_host.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength      �� getCompileTime  n�ۆ getHash ()I� � call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Lrelay_host_cfm$cf;
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Relay Host</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 us &()Llucee/runtime/type/scope/Undefined; 4 5
 / 6 $lucee/runtime/type/util/KeyConstants 8 _DATASOURCE #Llucee/runtime/type/Collection$Key; : ;	 9 < hermes > "lucee/runtime/type/scope/Undefined @ set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; B C A D

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
 J#</script>
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
               L <td height="131" width="988">
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
                     N</td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="763" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 763px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="517">
                              <tr valign="top" align="left">
                                <td width="11" height="21"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                 Pk<td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Relay Host Configuration</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/gateway/relay-host/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"> Ra</a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="971">
                        <tr valign="top" align="left">
                          <td width="10" height="3"></td>
                          <td width="961"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="961" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">By default, the system tries to deliver mail directly to the Internet. Depending on your configuration this may not be possible. For example, your system may be behind a firewall, or it may be connected via an ISP who does not allow outbound mail to the Internet. In those cases you need to configure the system to deliver mail&nbsp; via a Relay Host. T�</span></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="10" height="2"></td>
                          <td width="1"></td>
                          <td></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="108"></td>
                          <td colspan="5" width="959"> V m X &lucee/runtime/config/NullSupportHelper Z NULL \ '
 [ ] -lucee/runtime/interpreter/VariableInterpreter _ getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; a b
 ` c 0 e %lucee/runtime/exp/ExpressionException g java/lang/StringBuilder i The required parameter [ k  1
 j m append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; o p
 j q ] was not provided. s -(Ljava/lang/String;)Ljava/lang/StringBuilder; o u
 j v toString ()Ljava/lang/String; x y
 j z
 h m lucee/runtime/PageContextImpl } any �       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 ~ �  
 � m2 � step � 

 � action � view �@       _action � ;	 9 � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � 
 � keys $[Llucee/runtime/type/Collection$Key; � �	  � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � ;	 9 � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 ~ � lucee/runtime/tag/Query � get_relayhost_id � setName � 1
 � � A � setDatasource (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � I
select id from parameters where parameter='relayhost' and child = '2'
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 ~ � 	outputEnd � 
 / � get_relayhost � 7
select name, parameter from parameters where parent=' � getCollection � � A � _ID � ;	 9  I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �
 / lucee/runtime/op/Caster &(Ljava/lang/Object;)Ljava/lang/String; x
 writePSQ
 �
 / ' and child = '1'
   '(Ljava/lang/Object;Ljava/lang/String;)I �
 � #lucee/commons/color/ConstantsDouble _2 Ljava/lang/Double;	 _1	 show_relay_enabled show_relayhost _NAME! ;	 9" get_smtp_sasl_auth_enable$ U
select id from parameters where parameter='smtp_sasl_auth_enable' and child = '2'
& #get_smtp_sasl_auth_enable_parameter( 1
select parameter from parameters where parent='* no, yes. show_relay_authenticate0@        :4 &lucee/runtime/functions/list/ListGetAt6 T(Llucee/runtime/PageContext;Ljava/lang/String;DLjava/lang/String;)Ljava/lang/String; &8
79 #lucee/runtime/functions/string/Trim; A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &=
<> _25@	A show_relayhost_portC get_relayhost_username_passwordE Y
select name from parameters where parameter='smtp_sasl_password_maps' and child = '2'
G 


I show_relayhost_usernameK show_relayhost_passwordM editO 1Q _0S	T _MV ;	 9W bob@Y java/lang/String[ concat &(Ljava/lang/String;)Ljava/lang/String;]^
\_ emaila (lucee/runtime/functions/decision/IsValidc B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &e
df _3h	i integerk@���     (Ljava/lang/Object;D)I �o
 �p _4r	s _5u	v 2x _8z	{ 3} _6	� 4� updaterelayhost� (
update parameters 
set 
parameter='[� ]:� 
',
name='� ',
applied='2'
where parent='� ' 
and child='1' 
� 
enableauth� I
update parameters 
set 
parameter='yes',
applied='2'
where parent='� '
and child='1'
� get_smtp_sasl_password_maps� W
select id from parameters where parameter='smtp_sasl_password_maps' and child = '2'
� updateuserpass� "
update parameters 
set 
name='� ',
applied='2'
where id='� '
� _7�	� disableauth� H
update parameters 
set 
parameter='no',
applied='2'
where parent='� =
update parameters 
set 
name='',
applied='2'
where id='� P
update parameters 
set 
parameter='',
name='',
applied='2'
where parent='�

                            <table border="0" cellspacing="0" cellpadding="0" width="959" id="LayoutRegion19" style="height: 108px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="959">
                                    <tr valign="top" align="left">
                                      <td height="38" width="608">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="487">
                                              <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                <tr style="height: 19px;">
                                                  <form action="" method="post">
                                                  ��<td width="58" id="Cell524">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;">� �
<input type="radio" name="relay_enabled" value="1" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
� z
<input type="radio" name="relay_enabled" value="1" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
�:


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td width="429" id="Cell525">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Relay Host Enabled</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form action="" method="post">
                                                  <td id="Cell526">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      � �<tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;">� �
<input type="radio" name="relay_enabled" value="2" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
� z
<input type="radio" name="relay_enabled" value="2" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
�'


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell527">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><b>Relay Host Disabled</b> (Default)</span></p>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td width="351"></td>
                                    </tr>
                                    �
<tr valign="top" align="left">
                                      <td height="30" colspan="2" valign="middle" width="959"><hr id="HRRule1" width="959" size="1"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="38" width="608">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="487">
                                              <table id="Table168" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                <tr style="height: 19px;">
                                                  ��<form action="relay_host.cfm" method="post">
                                                  <td width="58" id="Cell1053">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;">� �
<input type="radio" name="relay_authenticate" value="1" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
<input type="hidden" name="relay_enabled" value="� "/>
� �
<input type="radio" name="relay_authenticate" value="1" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
<input type="hidden" name="relay_enabled" value="� �
<input type="radio" name="relay_authenticate" value="1" checked="checked" style="height: 19px; width: 19px;" disabled="disabled"/>
� t
<input type="radio" name="relay_authenticate" value="1" style="height: 19px; width: 19px;" disabled="disabled"/>
�Z


&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td width="429" id="Cell1054">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Relay Host Authentication Required</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 19px;">
                                                  <form action="relay_host.cfm" method="post">
                                                  <td id="Cell1055">
                                                    <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      � �
<input type="radio" name="relay_authenticate" value="2" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
<input type="hidden" name="relay_enabled" value="� �
<input type="radio" name="relay_authenticate" value="2" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
<input type="hidden" name="relay_enabled" value="� �
<input type="radio" name="relay_authenticate" value="2" checked="checked" style="height: 19px; width: 19px;" disabled="disabled"/>
� t
<input type="radio" name="relay_authenticate" value="2" style="height: 19px; width: 19px;" disabled="disabled"/>
�

&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    &nbsp;</td>
                                                  </form>
                                                  <td id="Cell1056">
                                                    <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><b>Relay Host Authentication NOT Required</b> (Default)</span></p>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td></td>
                                    �</tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="2" valign="middle" width="956"><hr id="HRRule3" width="956" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="204"></td>
                          <td colspan="3" width="957">

                            ��<table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion11" style="height: 204px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="relay_host.cfm" method="post">
                                    <input type="hidden" name="action" value="edit"><input type="hidden" name="relay_enabled" value="� 8"><input type="hidden" name="relay_authenticate" value="�">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table160" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 178px;">
                                            <tr style="height: 14px;">
                                              <td width="957" id="Cell889">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Relay Host Host FQDN</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell890">
                                                <p style="margin-bottom: 0px;">�a<b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                  <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td class="TextObject">� n
<input type="text" name="relayhost" size="50" maxlength="40" style="width: 396px; white-space: pre;" value="� " >
� " disabled="disabled">
�@
                                                        <p style="margin-bottom: 0px;">&nbsp;</p>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  </b></td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell891">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Relay Host Host Port Number <span style="font-weight: normal;">(Defaut is 25. Change only if Relay Host requires different port number)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                �r<td id="Cell1047">
                                                  <table width="80" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td class="TextObject">
                                                        <p style="margin-bottom: 0px;">� �
<input type="text" id="FormsEditField59" name="relayhost_port" size="10" maxlength="5" style="width: 76px; white-space: pre;" value="� ">
�&nbsp;</p>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1046">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Relay Host Username <span style="font-weight: normal;">(Required only if Relay Host Requires Authentication)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                <td id="Cell892">
                                                  ��<p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                    <table width="321" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="margin-bottom: 0px;">� �
<input type="text" id="FormsEditField42" name="relayhost_username" size="40" maxlength="75" style="width: 316px; white-space: pre;" value="�+&nbsp;</p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    </b></td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell911">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Relay Host Password <span style="font-weight: normal;">(Required only if Relay Host Requires Authentication)</span></span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 22px;">
                                                  <td id="Cell912">
                                                    ��<p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                      <table width="321" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;">� �
<input type="password" id="FormsEditField61" name="relayhost_password" size="40" maxlength="75" style="width: 316px; white-space: pre;" style="white-space:pre" value="�6&nbsp;</p>
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
                                                          �1<td align="center">
                                                            <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    �\</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="957">
                                            <tr valign="top" align="left">
                                              <td width="957" height="9"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="957" id="Text185" class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;">c
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Relay Host FQDN cannot be empty</span></i></b></p>
r
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Relay Host FQDN must be a valid FQDN host name</span></i></b></p>
j
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Relay Host Port Number cannot be empty</span></i></b></p>
�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Relay Host Port Number must be a valid number between 1 and 65535</span></i></b></p>
	 5 6�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;if the Relay Host Authentication Required is checked, you must also specifiy a Relay Host Password</span></i></b></p>
 7�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Settings Saved!! You MUST click the Apply Settings button in order for your changes to take effect</span></i></b></p>
 8�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon1.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;if the Relay Host Authentication Required is checked, you must also specifiy a Relay Host Username</span></i></b></p>
+




&nbsp;</p>
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
                                <td colspan="6" height="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2" height="30"></td>
                                <td valign="middle" width="955"><hr id="HRRule4" width="955" size="1"></td>
                                <td colspan="3"></td>
                              </tr>
                              <tr valign="top" align="left">
                                 �<td colspan="6" height="3"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="63"></td>
                                <td colspan="4" width="958"> show_action2  

 apply! _16#	$ customtrans& getrandom_results( 	setResult* 1
 �+ Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
- inserttrans/ stResult1 &
insert into salt
(salt)
values
('3 getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;56
 /7 getId9 $
 /: lucee/runtime/type/Query< getCurrentrow (I)I>?=@ getRecordcountB $=C !lucee/runtime/util/NumberIteratorE load '(II)Llucee/runtime/util/NumberIterator;GH
FI addQuery (Llucee/runtime/type/Query;)VKL AM isValid (I)ZOP
FQ currentS $
FT go (II)ZVW=X removeQueryZ  A[ release &(Llucee/runtime/util/NumberIterator;)V]^
F_ ')
a gettransc 2
select salt as customtrans2 from salt where id='e deletetransg 
delete from salt where id='i getmainparamsk �
select distinct(parameter), id, description, child, editable, enabled, conf_file from parameters where enabled='1' and child <> '1' and module='postfix'
m getchildreno 9
select * from parameters where child='1' and parent = 'q )' and enabled = '1' order by order1 asc
s insertu N
insert into command 
(command, trans_id)
values
('/usr/sbin/postconf -e "w  = y �
 /{ toQueryColumn O(Ljava/lang/Object;Llucee/runtime/PageContext;)Llucee/runtime/type/QueryColumn;}~
 , � 'lucee/runtime/functions/query/ValueList� a(Llucee/runtime/PageContext;Llucee/runtime/type/QueryColumn;Ljava/lang/String;)Ljava/lang/String; &�
�� "�@$       "lucee/runtime/functions/string/Chr� 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &�
�� ', '� 
getcommand� *
select * from command where trans_id = '� lucee.runtime.tag.FileTag� cffile� lucee/runtime/tag/FileTag� hasBody (Z)V��
�� 0 	setAction� 1
�� /opt/hermes/tmp/� 	_apply.sh� setFile� 1
�� ?/bin/cp /etc/postfix/main.cf /etc/postfix/main.cf.HERMES.BACKUP� 	setOutput� �
�� setAddnewline��
��
� �
� � APPEND� deletecommand� (
delete from command where trans_id = '� /usr/sbin/postfix reload� /etc/init.d/postfix restart� check_smtp_sasl_auth_enable� P
select id, parameter from parameters where parameter='smtp_sasl_auth_enable'
� check_smtp_sasl_auth_parameter� I
select name from parameters where parameter='smtp_sasl_password_maps'
� read� */opt/hermes/conf_files/relay_passwd.HERMES� 	relaypass� setVariable� 1
�� /opt/hermes/conf_files/� relay_passwd.HERMES� 	HOST-NAME� ALL� (lucee/runtime/functions/string/REReplace� w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &�
�� 





� 



� 	USER-NAME� /etc/postfix/relay_passwd� 	PASS-WORD� delete� 	 



� lucee.runtime.tag.Execute� 	cfexecute� lucee/runtime/tag/Execute� 
/bin/chmod�
� � +x /opt/hermes/tmp/� setArguments� �
��@N       
setTimeout (D)V��
��
� �
� �
� � 	/dev/null setOutputfile 1
� -inputformat none@n          
    

 updateparams 9
update parameters set applied='1' where applied = '2'
2


                                  <table border="0" cellspacing="0" cellpadding="0" width="958" id="LayoutRegion13" style="height: 63px;">
                                    <tr align="left" valign="top">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td height="9"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="958">
                                              <form name="apply_settings" action="relay_host.cfm#apply" method="post">
                                                <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    �<td width="958" id="Cell753">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;"> 
getapplied C
select * from parameters where module='postfix' and applied='2'
 #lucee/runtime/util/VariableUtilImpl recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;
 �
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
 
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Applying settings, please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" disabled="disabled" style="height: 24px; width: 142px;">
"&nbsp;</p>
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
                                        <table border="0" cellspacing="0" cellpadding="0" width="958">
                                          <tr valign="top" align="left">
                                            <td width="958" height="6">$?</td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="958" id="Text351" class="TextObject">
                                              <p style="text-align: left; margin-bottom: 0px;">& 16(_
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
*@



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
                              ,m<tr valign="top" align="left">
                                <td width="981" height="12"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td width="981" id="Text496" class="TextObject">
                                  <p style="text-align: center; margin-bottom: 0px;">. $lucee/runtime/functions/dateTime/Now0 =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &2
13 yyyy5 4lucee/runtime/functions/displayFormatting/DateFormat7 S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &9
8: 
getversion< D
SELECT value from system_settings where parameter = 'version_no'
> getbuild@ B
SELECT value from system_settings where parameter = 'build_no'
B V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway D sessionScope $()Llucee/runtime/type/scope/Session;FG
 /H  lucee/runtime/type/scope/SessionJK � 	 Version:M _VALUEO ;	 9P  Build:R . Copyright 2011-T l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>V�
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
       ����X udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException`  lucee/runtime/type/UDFPropertiesb udfs #[Llucee/runtime/type/UDFProperties;de	 f setPageSourceh 
 i SHOW_ACTIONk lucee/runtime/type/KeyImplm intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;op
nq GET_RELAYHOST_IDs GET_RELAYHOSTu 	PARAMETERw RELAYHOST_ENABLEDy relay_enabled{ SHOW_RELAY_ENABLED} RELAY_ENABLED 	relayhost� SHOW_RELAYHOST� 	RELAYHOST� GET_SMTP_SASL_AUTH_ENABLE� #GET_SMTP_SASL_AUTH_ENABLE_PARAMETER� RELAYHOST_AUTHENTICATE� relay_authenticate� RELAY_AUTHENTICATE� SHOW_RELAY_AUTHENTICATE� THEPORT� relayhost_port� RELAYHOST_PORT� SHOW_RELAYHOST_PORT� GET_RELAYHOST_USERNAME_PASSWORD� RELAY_PASSWORD� RELAY_USERNAME� relayhost_username� RELAYHOST_USERNAME� SHOW_RELAYHOST_USERNAME� relayhost_password� RELAYHOST_PASSWORD� SHOW_RELAYHOST_PASSWORD� STEP� 
TEMP_EMAIL� GET_SMTP_SASL_PASSWORD_MAPS� action2� ACTION2� SHOW_ACTION2� M2� RANDOM� STRESULT� GENERATED_KEY� CUSTOMTRANS3� GETTRANS� CUSTOMTRANS2� GETMAINPARAMS� GETCHILDREN� COMMAND� CHECK_SMTP_SASL_AUTH_ENABLE� CHECK_SMTP_SASL_AUTH_PARAMETER� 	RELAYPASS� 
GETAPPLIED� THEYEAR� EDITION� 
GETVERSION� GETBUILD� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *�c�g*+�j�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  a� [  R�+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+S� 3+U� 3+W� 3+Y+� ^� dM>+� ^,� .fY:� !� hY� jYl� nY� rt� w� {� |�M>+� ~�Y, � �� �+�� 3+�+� ^� d:6+� ^� 0fY:� !� hY� jYl� n�� rt� w� {� |�:6+� ~�� � �� �+�� 3+�+� ^� d:6	+� ^� 0fY:
� !� hY� jYl� n�� rt� w� {� |�
:6	+� ~�� � �	� �+�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� n�� rt� w� {� |�:6+� ~�� � �� �+�� 3+ �� �� �� ��� �� � � .+�� 3+� 7*� �2+� �� �� � � E W+�� 3� +�� 3+� �+� ~��� �� �:ȶ �+� 7� =� � � �� �6� N+� �+ٶ 3� ����� $:� � :� +� �W� ��� +� �W� �� �� � � :+� ~� ��+� ~� �� :+� ��+� �+�� 3+� �+� ~��� �� �:�� �+� 7� =� � � �� �6� r+� �+�� 3+++� 7*� �2� � ���	�+� 3� ���Ч $:� � :� +� �W� ��� +� �W� �� �� � � :+� ~� ��+� ~� �� :+� ��+� �+�� 3++� 7*� �2� � *� �2��� � � %+�� 3+� 7*� �2�� E W+�� 3� P++� 7*� �2� � *� �2��� � � %+�� 3+� 7*� �2�� E W+�� 3� +�� 3++� ^� d:6+� ^� >+� 7*� �2� � Y:� "� hY� jYl� n� rt� w� {� |�:6+� ~� � �� �+�� 3+ �*� �2� �� ��� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3+ +� ^� d:6+� ^� E++� 7*� �2� � �#�Y:� "� hY� jYl� n � rt� w� {� |�:6+� ~�  � �� �+�� 3+ �*� �2� �� ��� �� � � 3+�� 3+� 7*� �	2+� �*� �
2� � � E W+�� 3� +�� 3+� �+� ~��� �� �:  %� � +� 7� =� � � � � �6!!� O+ !� �+'� 3 � ���� $:" "� � :#!� +� �W � �#�!� +� �W � � � �� � � :$+� ~ � �$�+� ~ � �� :%+� �%�+� �+�� 3+� �+� ~��� �� �:&&)� �&+� 7� =� � � �&� �6''� t+&'� �++� 3+++� 7*� �2� � ���	�+� 3&� ���Χ $:(&(� � :)'� +� �W&� �)�'� +� �W&� �&� �� � � :*+� ~&� �*�+� ~&� �� :++� �+�+� �+�� 3++� 7*� �2� � *� �2�-�� � � &+�� 3+� 7*� �2�� E W+�� 3� R++� 7*� �2� � *� �2�/�� � � &+�� 3+� 7*� �2�� E W+�� 3� +�� 3+1+� ^� d:,6-+� ^,� ?+� 7*� �2� � Y:.� "� hY� jYl� n1� rt� w� {� |�.:,6-+� ~�1, � �-� �+�� 3+ �*� �2� �� ��� �� � � d+�� 3+� �*� �2� � �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3� +�� 3++� 7*� �2� � �#��� � � M+�� 3+� 7*� �2++++� 7*� �2� � *� �2��	25�:�?� E W+�� 3� N++� 7*� �2� � �#��� � � &+�� 3+� 7*� �2�B� E W+�� 3� +�� 3+D+� ^� d:/60+� ^/� ?+� 7*� �2� � Y:1� "� hY� jYl� nD� rt� w� {� |�1:/60+� ~�D/ � �0� �+�� 3+ �*� �2� �� ��� �� � � d+�� 3+� �*� �2� � �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3� +�� 3+� �+� ~��� �� �:22F� �2+� 7� =� � � �2� �633� O+23� �+H� 32� ���� $:424� � :53� +� �W2� �5�3� +� �W2� �2� �� � � :6+� ~2� �6�+� ~2� �� :7+� �7�+� �+�� 3++� 7*� �2� � �#��� � � �+�� 3+� 7*� �2+++� 7*� �2� � �#��	25�:� E W+�� 3+� 7*� �2+++� 7*� �2� � �#��	5�:� E W+�� 3� i++� 7*� �2� � �#��� � � @+�� 3+� 7*� �2� E W+�� 3+� 7*� �2� E W+�� 3� +J� 3+L+� ^� d:869+� ^8� ?+� 7*� �2� � Y::� "� hY� jYl� nL� rt� w� {� |�::869+� ~�L8 � �9� �+�� 3+ �*� �2� �� ��� �� � � d+�� 3+� �*� �2� � �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3� +�� 3+N+� ^� d:;6<+� ^;� ?+� 7*� �2� � Y:=� "� hY� jYl� nN� rt� w� {� |�=:;6<+� ~�N; � �<� �+�� 3+ �*� �2� �� ��� �� � � d+�� 3+� �*� �2� � �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3� +�� 3+� 7� �� � P�� � �d+�� 3+� 7*� �2� � R�� � ��+�� 3+� 7*� �2� � R�� � �
#+�� 3+� 7*� �	2� � �� � � <+�� 3+� 7*� �2�U� E W+�� 3+� 7�X�� E W+�� 3� �+� 7*� �	2� � �� � � �+�� 3+� 7*� �2Z+� 7*� �	2� � �	�`� E W+�� 3+b+� 7*� �2� � �g� &+�� 3+� 7*� �2�� E W+�� 3� ^+b+� 7*� �2� � �g� � � <+�� 3+� 7*� �2�U� E W+�� 3+� 7�X�� E W+�� 3� +�� 3� +�� 3+� 7*� �2� � R�� � ��+�� 3+� 7*� �2� � �� � � <+�� 3+� 7*� �2�U� E W+�� 3+� 7�X�j� E W+�� 3�[+� 7*� �2� � �� � �9+�� 3+l+� 7*� �2� � �g� �+�� 3+� 7*� �2� � m�q� � � '+� 7*� �2� � �q� � � � � &+�� 3+� 7*� �2�� E W+�� 3� 9+�� 3+� 7*� �2�U� E W+�� 3+� 7�X�t� E W+�� 3+�� 3� ^+l+� 7*� �2� � �g� � � <+�� 3+� 7*� �2�U� E W+�� 3+� 7�X�w� E W+�� 3� +�� 3� +�� 3� +�� 3+� 7*� �2� � y�� � � �+�� 3+� 7*� �2� � �� � � <+�� 3+� 7*� �2�U� E W+�� 3+� 7�X�|� E W+�� 3� H+� 7*� �2� � �� � � &+�� 3+� 7*� �2�j� E W+�� 3� +�� 3� +�� 3+� 7*� �2� � ~�� � � �+�� 3+� 7*� �2� � �� � � <+�� 3+� 7*� �2�U� E W+�� 3+� 7�X��� E W+�� 3� H+� 7*� �2� � �� � � &+�� 3+� 7*� �2�t� E W+�� 3� +�� 3� +�� 3+� 7*� �2� � ��� � ��+�� 3+� �+� ~��� �� �:>>�� �>+� 7� =� � � �>� �6??� �+>?� �+�� 3++� 7*� �	2� � �	�+�� 3++� 7*� �2� � �	�+�� 3++� 7*� �	2� � �	�+�� 3+++� 7*� �2� � ���	�+�� 3>� ���u� $:@>@� � :A?� +� �W>� �A�?� +� �W>� �>� �� � � :B+� ~>� �B�+� ~>� �� :C+� �C�+� �+�� 3+� �+� ~��� �� �:DD%� �D+� 7� =� � � �D� �6EE� O+DE� �+'� 3D� ���� $:FDF� � :GE� +� �WD� �G�E� +� �WD� �D� �� � � :H+� ~D� �H�+� ~D� �� :I+� �I�+� �+�� 3+� �+� ~��� �� �:JJ�� �J+� 7� =� � � �J� �6KK� t+JK� �+�� 3+++� 7*� �2� � ���	�+�� 3J� ���Χ $:LJL� � :MK� +� �WJ� �M�K� +� �WJ� �J� �� � � :N+� ~J� �N�+� ~J� �� :O+� �O�+� �+�� 3+� �+� ~��� �� �:PP�� �P+� 7� =� � � �P� �6QQ� O+PQ� �+�� 3P� ���� $:RPR� � :SQ� +� �WP� �S�Q� +� �WP� �P� �� � � :T+� ~P� �T�+� ~P� �� :U+� �U�+� �+�� 3+� �+� ~��� �� �:VV�� �V+� 7� =� � � �V� �6WW� �+VW� �+�� 3++� 7*� �2� � �	�+5� 3++� 7*� �2� � �	�+�� 3+++� 7*� � 2� � ���	�+�� 3V� ����� $:XVX� � :YW� +� �WV� �Y�W� +� �WV� �V� �� � � :Z+� ~V� �Z�+� ~V� �� :[+� �[�+� �+�� 3+� 7�X��� E W+�� 3� +J� 3�Z+� 7*� �2� � y�� � �8+�� 3+� 7*� �	2� � �� � � <+�� 3+� 7*� �2�U� E W+�� 3+� 7�X�� E W+�� 3� �+� 7*� �	2� � �� � � �+�� 3+� 7*� �2Z+� 7*� �	2� � �	�`� E W+�� 3+b+� 7*� �2� � �g� &+�� 3+� 7*� �2�� E W+�� 3� ^+b+� 7*� �2� � �g� � � <+�� 3+� 7*� �2�U� E W+�� 3+� 7�X�� E W+�� 3� +�� 3� +�� 3+� 7*� �2� � R�� � ��+�� 3+� 7*� �2� � �� � � <+�� 3+� 7*� �2�U� E W+�� 3+� 7�X�j� E W+�� 3�[+� 7*� �2� � �� � �9+�� 3+l+� 7*� �2� � �g� �+�� 3+� 7*� �2� � m�q� � � '+� 7*� �2� � �q� � � � � &+�� 3+� 7*� �2�� E W+�� 3� 9+�� 3+� 7*� �2�U� E W+�� 3+� 7�X�t� E W+�� 3+�� 3� ^+l+� 7*� �2� � �g� � � <+�� 3+� 7*� �2�U� E W+�� 3+� 7�X�w� E W+�� 3� +�� 3� +�� 3� +�� 3+� 7*� �2� � y�� � ��+�� 3+� �+� ~��� �� �:\\�� �\+� 7� =� � � �\� �6]]� �+\]� �+�� 3++� 7*� �	2� � �	�+�� 3++� 7*� �2� � �	�+�� 3++� 7*� �	2� � �	�+�� 3+++� 7*� �2� � ���	�+�� 3\� ���u� $:^\^� � :_]� +� �W\� �_�]� +� �W\� �\� �� � � :`+� ~\� �`�+� ~\� �� :a+� �a�+� �+�� 3+� �+� ~��� �� �:bb%� �b+� 7� =� � � �b� �6cc� O+bc� �+'� 3b� ���� $:dbd� � :ec� +� �Wb� �e�c� +� �Wb� �b� �� � � :f+� ~b� �f�+� ~b� �� :g+� �g�+� �+�� 3+� �+� ~��� �� �:hh�� �h+� 7� =� � � �h� �6ii� t+hi� �+�� 3+++� 7*� �2� � ���	�+�� 3h� ���Χ $:jhj� � :ki� +� �Wh� �k�i� +� �Wh� �h� �� � � :l+� ~h� �l�+� ~h� �� :m+� �m�+� �+�� 3+� �+� ~��� �� �:nn�� �n+� 7� =� � � �n� �6oo� O+no� �+�� 3n� ���� $:pnp� � :qo� +� �Wn� �q�o� +� �Wn� �n� �� � � :r+� ~n� �r�+� ~n� �� :s+� �s�+� �+�� 3+� �+� ~��� �� �:tt�� �t+� 7� =� � � �t� �6uu� t+tu� �+�� 3+++� 7*� � 2� � ���	�+�� 3t� ���Χ $:vtv� � :wu� +� �Wt� �w�u� +� �Wt� �t� �� � � :x+� ~t� �x�+� ~t� �� :y+� �y�+� �+�� 3+� 7�X��� E W+�� 3� +�� 3� +�� 3��+� 7*� �2� � y�� � �i+�� 3+� �+� ~��� �� �:zz�� �z+� 7� =� � � �z� �6{{� s+z{� �+�� 3+++� 7*� �2� � ���	�+�� 3z� ���ϧ $:|z|� � :}{� +� �Wz� �}�{� +� �Wz� �z� �� � � :~+� ~z� �~�+� ~z� �� :+� ��+� �+�� 3+� �+� ~��� �� �:��%� ��+� 7� =� � � ��� �6��� O+��� �+'� 3�� ���� $:���� � :��� +� �W�� ����� +� �W�� ��� �� � � :�+� ~�� ���+� ~�� �� :�+� ���+� �+�� 3+� �+� ~��� �� �:���� ��+� 7� =� � � ��� �6��� t+��� �+�� 3+++� 7*� �2� � ���	�+�� 3�� ���Χ $:���� � :��� +� �W�� ����� +� �W�� ��� �� � � :�+� ~�� ���+� ~�� �� :�+� ���+� �+�� 3+� �+� ~��� �� �:���� ��+� 7� =� � � ��� �6��� O+��� �+�� 3�� ���� $:���� � :��� +� �W�� ����� +� �W�� ��� �� � � :�+� ~�� ���+� ~�� �� :�+� ���+� �+�� 3+� �+� ~��� �� �:���� ��+� 7� =� � � ��� �6��� t+��� �+�� 3+++� 7*� � 2� � ���	�+�� 3�� ���Χ $:���� � :��� +� �W�� ����� +� �W�� ��� �� � � :�+� ~�� ���+� ~�� �� :�+� ���+� �+�� 3+� 7�X��� E W+�� 3� +�� 3� +�� 3+�� 3+� 7*� �2� � R�� � � -+�� 3+� �+�� 3� :�+� ���+� �+�� 3� O+� 7*� �2� � R�� � � -+�� 3+� �+�� 3� :�+� ���+� �+�� 3� +�� 3+�� 3+� 7*� �2� � y�� � � -+�� 3+� �+�� 3� :�+� ���+� �+�� 3� O+� 7*� �2� � y�� � � -+�� 3+� �+�� 3� :�+� ���+� �+�� 3� +�� 3+�� 3+¶ 3+� 7*� �2� � R�� � � �+�� 3+� 7*� �2� � R�� � � K+�� 3+� �+Ķ 3++� 7*� �2� � �	� 3+ƶ 3� :�+� ���+� �+�� 3� m+� 7*� �2� � R�� � � K+�� 3+� �+ȶ 3++� 7*� �2� � �	� 3+ƶ 3� :�+� ���+� �+�� 3� +�� 3� �+� 7*� �2� � y�� � � �+�� 3+� 7*� �2� � R�� � � -+�� 3+� �+ʶ 3� :�+� ���+� �+�� 3� O+� 7*� �2� � R�� � � -+�� 3+� �+̶ 3� :�+� ���+� �+�� 3� +�� 3� +ζ 3+�� 3+� 7*� �2� � R�� � � �+�� 3+� 7*� �2� � y�� � � K+�� 3+� �+ж 3++� 7*� �2� � �	� 3+ƶ 3� :�+� ���+� �+�� 3� m+� 7*� �2� � y�� � � K+�� 3+� �+Ҷ 3++� 7*� �2� � �	� 3+ƶ 3� :�+� ���+� �+�� 3� +�� 3� �+� 7*� �2� � y�� � � �+�� 3+� 7*� �2� � y�� � � -+�� 3+� �+Զ 3� :�+� ���+� �+�� 3� O+� 7*� �2� � y�� � � -+�� 3+� �+ֶ 3� :�+� ���+� �+�� 3� +�� 3� +ض 3+ڶ 3+ܶ 3+� �++� 7*� �2� � �	� 3� :�+� ���+� �+޶ 3+� �++� 7*� �2� � �	� 3� :�+� ���+� �+� 3+� 3+� 7*� �2� � R�� � � K+�� 3+� �+� 3++� 7*� �	2� � �	� 3+� 3� :�+� ���+� �+�� 3� m+� 7*� �2� � y�� � � K+�� 3+� �+� 3++� 7*� �	2� � �	� 3+� 3� :�+� ���+� �+�� 3� +� 3+� 3+� 7*� �2� � R�� � � K+�� 3+� �+� 3++� 7*� �2� � �	� 3+� 3� :�+� ���+� �+�� 3� m+� 7*� �2� � y�� � � K+�� 3+� �+� 3++� 7*� �2� � �	� 3+� 3� :�+� ���+� �+�� 3� +� 3+�� 3+� 7*� �2� � R�� � � �+�� 3+� 7*� �2� � R�� � � K+�� 3+� �+�� 3++� 7*� �2� � �	� 3+� 3� :�+� ���+� �+�� 3� m+� 7*� �2� � y�� � � K+�� 3+� �+�� 3++� 7*� �2� � �	� 3+� 3� :�+� ���+� �+�� 3� +�� 3�+� 7*� �2� � y�� � � �+�� 3+� 7*� �2� � R�� � � K+�� 3+� �+�� 3++� 7*� �2� � �	� 3+� 3� :�+� ���+� �+�� 3� m+� 7*� �2� � y�� � � K+�� 3+� �+�� 3++� 7*� �2� � �	� 3+� 3� :�+� ���+� �+�� 3� +�� 3� +�� 3+�� 3+� 7*� �2� � R�� � � �+�� 3+� 7*� �2� � R�� � � K+�� 3+� �+�� 3++� 7*� �2� � �	� 3+� 3� :�+� ���+� �+�� 3� m+� 7*� �2� � y�� � � K+�� 3+� �+�� 3++� 7*� �2� � �	� 3+� 3� :�+� ���+� �+�� 3� +�� 3�+� 7*� �2� � y�� � � �+�� 3+� 7*� �2� � R�� � � K+�� 3+� �+�� 3++� 7*� �2� � �	� 3+� 3� :�+� ���+� �+�� 3� m+� 7*� �2� � y�� � � K+�� 3+� �+�� 3++� 7*� �2� � �	� 3+� 3� :�+� ���+� �+�� 3� +�� 3� +�� 3+ � 3+� 3+� 7�X� � R�� � � -+�� 3+� �+� 3� :�+� ���+� �+�� 3� +�� 3+� 7�X� � y�� � � -+�� 3+� �+� 3� :�+� ���+� �+�� 3� +�� 3+� 7�X� � ~�� � � -+�� 3+� �+� 3� :�+� ���+� �+�� 3� +�� 3+� 7�X� � ��� � � -+�� 3+� �+
� 3� :�+� ���+� �+�� 3� +�� 3+� 7�X� � �� � � -+�� 3+� �+
� 3� :�+� ���+� �+�� 3� +J� 3+� 7�X� � �� � � -+�� 3+� �+� 3� :�+� ���+� �+�� 3� +�� 3+� 7�X� � �� � � -+�� 3+� �+� 3� :�+� ���+� �+�� 3� +�� 3+� 7�X� � �� � � -+�� 3+� �+� 3� :�+� ���+� �+�� 3� +� 3+� 3++� ^� d:�6�+� ^�� 1�Y:�� "� hY� jYl� n� rt� w� {� |��:�6�+� ~�� � ��� �+�� 3+ �*� �!2� �� ��� �� � � ^+�� 3+� �*� �"2� � �� � � 3+�� 3+� 7*� �#2+� �*� �"2� � � E W+�� 3� � + � 3+� 7*� �#2� � "�� � �5+�� 3+� 7*� �$2�%� E W+�� 3+� �+� ~��� �� �:��'� ��+� 7� =� � � ��)�,�� �6��� O+��� �+.� 3�� ���� $:���� � :��� +� �W�� ����� +� �W�� ��� �� � � :�+� ~�� ���+� ~�� �� :�+� �¿+� �+�� 3+� �+� ~��� �� �:��0� ��+� 7� =� � � ��2�,ö �6���B+�Ķ �+4� 3+� �+'�8:�+�;6��ǹA 6�ƹD � � � �6��ƹD �J:�+� 7ƹN �d6���`�R� D�ŶUǹY � � � � (ŶU6�+++� 7*� �%2� � �	�?����� ":���ǹY W+� 7�\ Ÿ`Ϳ��ǹY W+� 7�\ Ÿ`� :�+� �ο+� �+b� 3ö ��� � $:��϶ � :��� +� �Wö �п�� +� �Wö �ö �� � � :�+� ~ö �ѿ+� ~ö �� :�+� �ҿ+� �+�� 3+� �+� ~��� �� �:��d� ��+� 7� =� � � �Ӷ �6��� x+�Զ �+f� 3+++� 7*� �&2� � *� �'2��	�+�� 3Ӷ ���ʧ $:��ն � :��� +� �WӶ �ֿ�� +� �WӶ �Ӷ �� � � :�+� ~Ӷ �׿+� ~Ӷ �� :�+� �ؿ+� �+�� 3+� 7*� �(2++� 7*� �)2� � *� �*2�� E W+�� 3+� �+� ~��� �� �:��h� ��+� 7� =� � � �ٶ �6��� x+�ڶ �+j� 3+++� 7*� �&2� � *� �'2��	�+�� 3ٶ ���ʧ $:��۶ � :��� +� �Wٶ �ܿ�� +� �Wٶ �ٶ �� � � :�+� ~ٶ �ݿ+� ~ٶ �� :�+� �޿+� �+J� 3+� �+� ~��� �� �:��l� ��+� 7� =� � � �߶ �6��� O+�� �+n� 3߶ ���� $:��� � :��� +� �W߶ ���� +� �W߶ �߶ �� � � :�+� ~߶ ��+� ~߶ �� :�+� ��+� �+�� 3+l�8:�+�;6���A 6��D � � ��6���D �J:�+� 7�N �d6���`�R����U�Y � � � �j�U6�+�� 3+� �+�� 3+� �+� ~��� �� �:��p� ��+� 7� =� � � ��� �6��� t+�� �+r� 3+++� 7*� �+2� � ���	�+t� 3�� ���Χ $:��� � :��� +� �W�� ���� +� �W�� ��� �� � � :�+� ~�� ��+� ~�� �� :�+� ��+� �+�� 3+� �+� ~��� �� �:��v� ��+� 7� =� � � �� �6��� �+��� �+x� 3+++� 7*� �+2� � *� �2��	�+z� 3++++� 7*� �,2� � *� �2�|+������ 3+�� 3++����+�� 3++� 7*� �(2� � �	�+b� 3� ���k� $:���� � :��� +� �W� ����� +� �W� �� �� � � :�+� ~� ���+� ~� �� :�+� ���+� �+�� 3� :�+� ���+� �+�� 3��t� ":����Y W+� 7�\ �`�����Y W+� 7�\ �`+ � 3+� �+� ~��� �� �:���� ��+� 7� =� � � ��� �6��� m+��� �+�� 3++� 7*� �(2� � �	�+�� 3�� ���է $:���� � :��� +� �W�� ����� +� �W�� ��� �� � � :�+� ~�� ���+� ~�� �� �: +� �� �+� �+�� 3+� ~��� ����:���������+� 7*� �(2� � �	�`��`����+����`��������W���� � � �:+� ~�� ���+� ~�� �+�� 3+� �+��8�:+�;�6���A �6��D � � �u�6���D �J�:+� 7��N �d�6
��
`�R� ����U��Y � � � � ���U�6
+�� 3+� ~��� ����:���������+� 7*� �(2� � �	�`��`���+� 7*� �-2� � ��������W���� � � �:+� ~�� ���+� ~�� �+�� 3��� .�:����Y W+� 7�\ ��`������Y W+� 7�\ ��`� �:+� ���+� �+�� 3+� �+� ~��� �� ��:��� ��+� 7� =� � � ��� ��6�� �+��� �+�� 3++� 7*� �(2� � �	�+�� 3�� ���ӧ 2�:��� �  �:�� +� �W�� ����� +� �W�� ��� �� � � �:+� ~�� ���+� ~�� �� �:+� ���+� �+�� 3+� ~��� ����:���������+� 7*� �(2� � �	�`��`����+����`��`��������W���� � � �:+� ~�� ���+� ~�� �+�� 3+� �+� ~��� �� ��:��� ��+� 7� =� � � ��� ��6�� g+��� �+ö 3�� ���� 2�:��� �  �:�� +� �W�� ����� +� �W�� ��� �� � � �:+� ~�� ���+� ~�� �� �:+� ���+� �+�� 3+� �+� ~��� �� ��:�Ŷ ��+� 7� =� � � ��� ��6�� �+��� �++� 3+++� 7*� �.2� � ���	�+�� 3�� ���̧ 2�:��� �  �: �� +� �W�� �� ��� +� �W�� ��� �� � � �:!+� ~�� ��!�+� ~�� �� �:"+� ��"�+� �+�� 3++� 7*� �/2� � *� �2�/�� � ��+�� 3+� �+� ~��� �� ��:#�#�� ��#+� 7� =� � � ��#� ��6$�$� g+�#�$� �+Ƕ 3�#� ���� 2�:%�#�%� �  �:&�$� +� �W�#� ��&��$� +� �W�#� ��#� �� � � �:'+� ~�#� ��'�+� ~�#� �� �:(+� ��(�+� �+�� 3+� 7*� �2+++� 7*� � 2� � �#��	25�:� E W+�� 3+� 7*� �2+++� 7*� � 2� � �#��	5�:� E W+�� 3+� ~��� ����:)�)���)ɶ��)˶��)Ͷ��)��W�)��� � � �:*+� ~�)� ��*�+� ~�)� �+J� 3+� ~��� ����:+�+���+����+�+� 7*� �(2� � �	�`Զ`���+++� 7*� �02� � �	�+� 7*� �	2� � �	ظݶ��+��W�+��� � � �:,+� ~�+� ��,�+� ~�+� �+߶ 3+� ~��� ����:-�-���-ɶ��-�+� 7*� �(2� � �	�`Զ`���-Ͷ��-��W�-��� � � �:.+� ~�-� ��.�+� ~�-� �+� 3+� ~��� ����:/�/���/����/�+� 7*� �(2� � �	�`Զ`���/++� 7*� �02� � �	�+� 7*� �2� � �	ظݶ��/��W�/��� � � �:0+� ~�/� ��0�+� ~�/� �+J� 3+� ~��� ����:1�1���1ɶ��1�+� 7*� �(2� � �	�`Զ`���1Ͷ��1��W�1��� � � �:2+� ~�1� ��2�+� ~�1� �+� 3+� ~��� ����:3�3���3����3���3++� 7*� �02� � �	�+� 7*� �2� � �	ظݶ��3��W�3��� � � �:4+� ~�3� ��4�+� ~�3� �+�� 3+� ~��� ����:5�5���5���5�+� 7*� �(2� � �	�`Զ`���5��W�5��� � � �:6+� ~�5� ��6�+� ~�5� �+J� 3� +� 3+� ~��� ����:7�7���7�+� 7*� �(2� � �	�`��`���7����7� �68�8� F+�7�8� �+�� 3�7���� �:9�8� +� �W�9��8� +� �W�7�� � � �::+� ~�7� ��:�+� ~�7� �+�� 3+� ~��� ����:;�;�+� 7*� �(2� � �	�`��`���;��;	���;
���;� �6<�<� F+�;�<� �+�� 3�;���� �:=�<� +� �W�=��<� +� �W�;�� � � �:>+� ~�;� ��>�+� ~�;� �+J� 3+� ~��� ����:?�?���?���?�+� 7*� �(2� � �	�`��`���?��W�?��� � � �:@+� ~�?� ��@�+� ~�?� �+� 3+� �+� ~��� �� ��:A�A� ��A+� 7� =� � � ��A� ��6B�B� g+�A�B� �+� 3�A� ���� 2�:C�A�C� �  �:D�B� +� �W�A� ��D��B� +� �W�A� ��A� �� � � �:E+� ~�A� ��E�+� ~�A� �� �:F+� ��F�+� �+�� 3� +� 3+� 3+� �+� ~��� �� ��:G�G� ��G+� 7� =� � � ��G� ��6H�H� g+�G�H� �+� 3�G� ���� 2�:I�G�I� �  �:J�H� +� �W�G� ��J��H� +� �W�G� ��G� �� � � �:K+� ~�G� ��K�+� ~�G� �� �:L+� ��L�+� �+�� 3++� 7*� �12� � ��q� � � +!� 3� 
+#� 3+%� 3+'� 3+� 7*� �$2� � )�� � � 1+�� 3+� �++� 3� �:M+� ��M�+� �+�� 3� +-� 3+/� 3+� 7*� �22++�46�;� E W+�� 3+� �+� ~��� �� ��:N�N=� ��N+� 7� =� � � ��N� ��6O�O� g+�N�O� �+?� 3�N� ���� 2�:P�N�P� �  �:Q�O� +� �W�N� ��Q��O� +� �W�N� ��N� �� � � �:R+� ~�N� ��R�+� ~�N� �� �:S+� ��S�+� �+�� 3+� �+� ~��� �� ��:T�TA� ��T+� 7� =� � � ��T� ��6U�U� g+�T�U� �+C� 3�T� ���� 2�:V�T�V� �  �:W�U� +� �W�T� ��W��U� +� �W�T� ��T� �� � � �:X+� ~�T� ��X�+� ~�T� �� �:Y+� ��Y�+� �+�� 3+� �+E� 3++�I*� �32�L �	� 3+N� 3+++� 7*� �42� � �Q��	� 3+S� 3+++� 7*� �52� � �Q��	� 3+U� 3++� 7*� �22� � �	� 3+W� 3� �:Z+� ��Z�+� �+Y� 3� �]lo )]x{  0��  ��   SV ) _b  ���  ���  BRU )B^a  ��  ��  <? )HK  ���  ���  P`c )Plo  "��  ��  �<? )�HK  ���  o��  � )�  �FF  �``  ��� )���  �00  wJJ  ��� )���  r��  a  e�� )e��  7  &55  B�� )B��    //  ��� )���  W��  F��  J� )J��  ��  ��   4 D G ) 4 P S    � �  � � �   �!.!1 ) �!:!=   �!s!s   �!�!�  "6"j"m )"6"v"y  ""�"�  !�"�"�  ##/#2 )##;#>  "�#t#t  "�#�#�  #�$$ )#�$%$(  #�$^$^  #�$x$x  $�$�$� )$�$�$�  $�%#%#  $�%=%=  %�%�%� )%�%�%�  %e&&  %T&'&'  &�&�&�  &�&�&�  '<'F'F  '�'�'�  ((9(9  ({(�(�  )) )   )b)l)l  )�**  *W**  *�*�*�  +>+H+H  +�+�+�  +�+�+�  ,,;,;  ,},�,�  ,�--  -_-�-�  -�.'.'  .i.�.�  //,/,  /n/�/�  00?0?  0�0�0�  11D1D  1�1�1�  2
22  2X2b2b  2�2�2�  2�2�2�  3B3L3L  3�3�3�  3�3�3�  4-4747  5�5�5� )5�5�5�  5�6&6&  5�6@6@  6�7H7H  6�7�7�  6�7�7� )6�7�7�  6h7�7�  6W8 8   8V8�8� )8V8�8�  8(8�8�  88�8�  9v9�9� )9v9�9�  9H9�9�  97::  :e:u:x ):e:�:�  :7:�:�  :&:�:�  ;�;�;� );�;�;�  ;�<2<2  ;y<L<L  <�=:== )<�=F=I  <t==  <c=�=�  ;o=�=�  ;6=�=�  >K>y>| )>K>�>�  >>�>�  >>�>�  ??s?s  @]@�@�  @@�@�  ?�AJAJ  A�A�A� )A�A�A�  AxB=B=  AeB_B_  B�C C   CxC�C� )CxC�C�  C<C�C�  C)DD  DoD�D� )DoD�D�  D3D�D�  D E!E!  E�E�E� )E�E�E�  E�F(F(  EnFJFJ  F�G+G+  GfG�G�  H+H�H�  H�IMIM  I�I�I�  J J�J�  J�KK  K�K�K�  K`LL  L�L�L�  L=L�L�  M%MxMx  M�NN )M�NN  M�N\N\  M�N~N~  N�OO )N�OO   N�OdOd  N�O�O�  PPP  P�P�P� )P�P�P�  PwQQ  PdQ@Q@  Q�Q�Q� )Q�Q�Q�  QnRR  Q[R7R7  RRR�R�   �         * +  �  �$           @  A ! k $ � - � 0 � 9 � < � K � � � �g �� �� � � �` �� �# �G ���@Yb��	"
+����F�0���,FO� �!	"	9#	B$	K&	y'	�(	�)
*
,
�-
�.
�/
�01
3T5�7�899r:�;�<�=�@UA}B�C�D�E�GQHyI�J�K�L�N�O&PNRvS�T�U�VW!X;YfZ�[�\�]�_�`�ab(cSdse�f�g�h ijkGlamwn�o�p�r�s�t�uv=wWx`yi{�|�}�~��.�7�@�h������0�����p�����Z����i�����E�[�e����������C�c�}������������:�T�j�������(�B�X�^���������������F�������?����N�s��� 8� �� ��!"�!��!��!��!��!��":"^"�###�	#�$$�$�%M%�%�&7&M&V!&`#&c/&g0&j3&�4&�5&�6&�7&�8&�9&�:&�;'>'	L'M'N'5O'@P'SQ'VR'�S'�T'�U'�V'�Y'�j'�k'�w'�x'�|'�}(
~((�(3�(I�(t�(�(��(��(��(��(��)�)�)-�)0�)[�)f�)y�)|�)��)��)��)��)��)��)��)��)��*�*%�*P�*[�*^�*y�*��*��*��*��*��+	�+�+7�+B�+U�+X�+a�+k�+u�+y�+|�+��+��+��,�,�,5�,K�,v�,��,��,� ,�,�,�,�,�,�----X-c-�-�-�&-�*-�,-�-...!/.70.b1.m2.�3.�4.�5.�6.�7/8/&9/<:/g;/r</�=/�>/�?/�L/�P/�Q0R0S09T0OU0zV0�W0�X0�Y0�[0�\1]1 ^1>_1T`1a1�b1�c1�d1�e1�t1�u1��2�2�2!�2$�2-�2Q�2\�2o�2r�2{�2��2��2��2��2��2��2��3�3�3�3;�3F�3Y�3\�3f�3��3��3��3��3��3��3��3��3��4�4&�41�4D�4G�4Q�4T�4[�4��4��5�54�5A�5i�5��5��6P�6��7��8�8Z�8��8��90�9z�9��:�:i�:��:��;h�;r�;��;� <\<�=.=�	=�
>>O>m>�??@?T?�?�?�@E@s@�@�@�@�@�A^A�A� Bs"B�#B�$B�%C"C%C"'C|)D+Ds,D�-E5/Eg1E�3F^5F�6F�8GN;G|<G�=H;H=HBH�FH�GH�HIlFIlHIpKJOJ6PJ@QJ�OJ�QJ�SJ�TJ�UK:SK:UK>XKH\Kn]K�^K�_L%aLgbLqcL{dL�eMhM1iM;jM�hM�jM�mM�oN�pN�sN�N��N��N��O��O��O��O��O��O��P�P�P'�P*�P4�P7�P;�P>�P]�P��QT�Q��RK�RV�R���     ) Z[ �        �    �     ) \] �         �    �     ) ^_ �        �    �    a    �  ,     *6� �Yl�rSYt�rSYv�rSYx�rSYz�rSY|�rSY~�rSY��rSY��rSY	��rSY
��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY��rSY ��rSY!��rSY"��rSY#��rSY$��rSY%��rSY&��rSY'��rSY(¸rSY)ĸrSY*ƸrSY+ȸrSY,ʸrSY-̸rSY.θrSY/иrSY0ҸrSY1ԸrSY2ָrSY3ظrSY4ڸrSY5ܸrS� ��     �    