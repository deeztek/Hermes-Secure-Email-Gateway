����   2l $proprietary/spf_configuration_cfm$cf  lucee/runtime/PageImpl  */compile/proprietary/spf_configuration.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�
 3 getSourceLength     �� getCompileTime  v�Բ6 getHash ()If��H call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this &Lproprietary/spf_configuration_cfm$cf;
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>SPF Configuration</title>
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
              <td height="774" width="988"> P@       keys $[Llucee/runtime/type/Collection$Key; T U	  V !lucee/runtime/type/Collection$Key X *lucee/runtime/functions/decision/IsDefined Z B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & \
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
 t � NEW �
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 774px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="514">
                              <tr valign="top" align="left">
                                <td width="8" height="18"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">SPF Configuration �</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="456">
                              <tr valign="top" align="left">
                                <td width="431" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/spf-configuration/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                             � </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="960">
                        <tr valign="top" align="left">
                          <td width="9" height="6"></td>
                          <td width="951"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="951" id="Text454" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="color: rgb(255,0,0);">I<b>mportant:</b></span> The settings below will have no effect unless <b>SPF</b> (<b>Sender Policy Framework Checks)</b> is set to <b>enabled</b> under <b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Content Checks --&gt; Perimenter Checks</span></b></a></span></p>
                          </td>
                        </ ��tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="9" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="957"><hr id="HRRule4" width="957" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="8" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="556"></td>
                          <td width="961"> � m � &lucee/runtime/config/NullSupportHelper � NULL � '
 � � -lucee/runtime/interpreter/VariableInterpreter � getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; � �
 � � 0 � %lucee/runtime/exp/ExpressionException � java/lang/StringBuilder � The required parameter [ �  1
 � � append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; � �
 � � ] was not provided. � -(Ljava/lang/String;)Ljava/lang/StringBuilder; � �
 � � toString ()Ljava/lang/String; � �
 � �
 � � any ��       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 t � m2 � step �  

 � show_action � view �  
 �@       _action � ;	 9 � True � (ZLjava/lang/String;)I o �
 n � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � ;	 9 � lucee/runtime/type/scope/Form � � i   � 

 � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � lucee/runtime/tag/Query � get_debugLevel � setName � 1
 � � A i setDatasource (Ljava/lang/Object;)V
 �
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V
 /	 R
select value2 from parameters2 where parameter='debugLevel' and module = 'spf'
 doAfterBody $
 � doCatch (Ljava/lang/Throwable;)V
 � popBody ()Ljavax/servlet/jsp/JspWriter;
 / 	doFinally 
 �
 � � 	outputEnd 
 / get_TestOnly P
select value2 from parameters2 where parameter='TestOnly' and module = 'spf'
! 


# get_HELO_reject% S
select value2 from parameters2 where parameter='HELO_reject' and module = 'spf'
' get_Mail_From_reject) X
select value2 from parameters2 where parameter='Mail_From_reject' and module = 'spf'
+ get_PermError_reject- X
select value2 from parameters2 where parameter='PermError_reject' and module = 'spf'
/ get_TempError_Defer1 W
select value2 from parameters2 where parameter='TempError_Defer' and module = 'spf'
3 
debugLevel5 getCollection7 h A8 I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; g:
 /; TestOnly=  


? HELO_rejectA Mail_From_rejectC PermError_rejectE TempError_DeferG editI updatedebugLevelK #
update parameters2 set 
value2='M lucee/runtime/op/CasterO &(Ljava/lang/Object;)Ljava/lang/String; �Q
PR writePSQT
 /U C',
applied='2'
where
parameter='debugLevel' and module = 'spf'
W updateTestOnlyY A',
applied='2'
where
parameter='TestOnly' and module = 'spf'
[ updateHELO_reject] D',
applied='2'
where
parameter='HELO_reject' and module = 'spf'
_ updateMail_From_rejecta I',
applied='2'
where
parameter='Mail_From_reject' and module = 'spf'
c updatePermError_rejecte I',
applied='2'
where
parameter='PermError_reject' and module = 'spf'
g updateTempError_Deferi H',
applied='2'
where
parameter='TempError_Defer' and module = 'spf'
k 





m _Mo ;	 9p #lucee/commons/color/ConstantsDoubler _3 Ljava/lang/Double;tu	sv 

<!-- /CFIF FOR ACTION -->
x


                            <table border="0" cellspacing="0" cellpadding="0" width="961" id="LayoutRegion11" style="height: 556px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="3"></td>
                                        <td width="958">
                                          <table id="Table100" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 424px;">
                                            <tr style="height: 14px;">
                                              <td width="958" id="Cell1044">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">Logging Levelz=</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 114px;">
                                              <td id="Cell1042">
                                                <table width="923" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table163" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 119px;">
                                                        <tr style="height: 19px;">
                                                          <td width="57" id="Cell1021">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                |�<td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">~ 1� i
<input type="radio" checked="checked" name="debugLevel" value="1" style="height: 13px; width: 13px;">
� W
<input type="radio" name="debugLevel" value="1" style="height: 13px; width: 13px;">
�5





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="866" id="Cell1022">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Level 1</span> <span style="font-weight: normal;">( </span>Default<span style="font-weight: normal;">. Log only basic policy results and errors)</span></span></b></p>
                                                          ��</td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell1023">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� 2� i
<input type="radio" checked="checked" name="debugLevel" value="2" style="height: 13px; width: 13px;">
� W
<input type="radio" name="debugLevel" value="2" style="height: 13px; width: 13px;">
�&





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1024">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Level 2 </b><span style="color: rgb(128,128,128); font-weight: normal;">(Logs message if no client address, Mail From Address or HELO/EHLO is received and logs SPF results for each Mail From and HELO check)</span></span></p>
                                                          ��</td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell1104">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� 3� i
<input type="radio" checked="checked" name="debugLevel" value="3" style="height: 13px; width: 13px;">
� W
<input type="radio" name="debugLevel" value="3" style="height: 13px; width: 13px;">
�





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1105">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Level 3 </b><span style="color: rgb(128,128,128); font-weight: normal;">(Logs SPF server start/stop, exact copy of header returned to SMTP server and configuration used by SMTP server)</span></span></p>
                                                          ��</td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell1106">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� 4� i
<input type="radio" checked="checked" name="debugLevel" value="4" style="height: 13px; width: 13px;">
� W
<input type="radio" name="debugLevel" value="4" style="height: 13px; width: 13px;">
�





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1107">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Level 4 </b><span style="color: rgb(128,128,128); font-weight: normal;">(Logs the complete data set received by SMTP server)</span></span></p>
                                                          </td>
                                                        �N</tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell1110">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� i
<input type="radio" checked="checked" name="debugLevel" value="0" style="height: 13px; width: 13px;">
� W
<input type="radio" name="debugLevel" value="0" style="height: 13px; width: 13px;">
�0





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1111">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Level 0 </b><span style="color: rgb(128,128,128); font-weight: normal;">(Logs only errors)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        �<tr style="height: 19px;">
                                                          <td id="Cell1112">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� -1� j
<input type="radio" checked="checked" name="debugLevel" value="-1" style="height: 13px; width: 13px;">
� X
<input type="radio" name="debugLevel" value="-1" style="height: 13px; width: 13px;">
�





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1113">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>No Logging </b><span style="color: rgb(128,128,128); font-weight: normal;">(Disables logging. Do not use unless necessary)</span></span></p>
                                                          </td>
                                                        �&</tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1045">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">Test Mode</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell1041">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  �<tr>
                                                    <td>
                                                      <table id="Table164" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1027">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        � <p style="margin-bottom: 0px;">� g
<input type="radio" checked="checked" name="TestOnly" value="2" style="height: 13px; width: 13px;">
� U
<input type="radio" name="TestOnly" value="2" style="height: 13px; width: 13px;">
�"





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="541" id="Cell1028">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">No</span> <span style="font-weight: normal;">(</span>Default.<span style="font-weight: normal;"> SPF Server Normal Operation)</span></span></b></p>
                                                          ��</td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1029">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� g
<input type="radio" checked="checked" name="TestOnly" value="1" style="height: 13px; width: 13px;">
� U
<input type="radio" name="TestOnly" value="1" style="height: 13px; width: 13px;">
�





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1030">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Yes&nbsp; </b><span style="color: rgb(128,128,128); font-weight: normal;">(Run SPF Server in test mode to see potential impact of SPF checking without rejecting email)</span></span></p>
                                                          </�vtd>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1040">
                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,0,0);">HELO Check Rejection Policy</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 102px;">
                                              <td id="Cell1039">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  �<tr>
                                                    <td>
                                                      <table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1034">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        � Fail� m
<input type="radio" checked="checked" name="HELO_reject" value="Fail" style="height: 13px; width: 13px;">
� [
<input type="radio" name="HELO_reject" value="Fail" style="height: 13px; width: 13px;">
�!





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="541" id="Cell1035">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Fail</span> <span style="font-weight: normal;">(</span>Default.<span style="font-weight: normal;"> Reject only on HELO Fail)</span></span></b></p>
                                                          ��</td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1036">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� SPF_Not_Pass� u
<input type="radio" checked="checked" name="HELO_reject" value="SPF_Not_Pass" style="height: 13px; width: 13px;">
� c
<input type="radio" name="HELO_reject" value="SPF_Not_Pass" style="height: 13px; width: 13px;">
� 






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1037">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>SPF Not Pass </b><span style="color: rgb(128,128,128); font-weight: normal;">(Reject if result is Fail, Softfail, Neutral or PermError)</span></span></p>
                                                          </td>
                                                        �N</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1114">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� Softfail� q
<input type="radio" checked="checked" name="HELO_reject" value="Softfail" style="height: 13px; width: 13px;">
� _
<input type="radio" name="HELO_reject" value="Softfail" style="height: 13px; width: 13px;">
�






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1115">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>SoftFail </b><span style="color: rgb(128,128,128); font-weight: normal;">(Reject if result is Softfail or Fail)</span></span></p>
                                                          </td>
                                                        �N</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1116">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� Null� m
<input type="radio" checked="checked" name="HELO_reject" value="Null" style="height: 13px; width: 13px;">
� [
<input type="radio" name="HELO_reject" value="Null" style="height: 13px; width: 13px;">
�






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1117">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Null </b><span style="color: rgb(128,128,128); font-weight: normal;">(Reject only HELO for Null Sender. Do not use unless necessary)</span></span></p>
                                                          </td>
                                                        �N</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1118">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� False� n
<input type="radio" checked="checked" name="HELO_reject" value="False" style="height: 13px; width: 13px;">
� \
<input type="radio" name="HELO_reject" value="False" style="height: 13px; width: 13px;">
�	






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1119">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>False </b><span style="color: rgb(128,128,128); font-weight: normal;">(Never reject on HELO, append header only)</span></span></p>
                                                          </td>
                                                        �N</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1120">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">  No_Check q
<input type="radio" checked="checked" name="HELO_reject" value="No_Check" style="height: 13px; width: 13px;">
 _
<input type="radio" name="HELO_reject" value="No_Check" style="height: 13px; width: 13px;">
1






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1121">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>No Check </b><span style="color: rgb(128,128,128); font-weight: normal;">(Never check HELO)</span></span></p>
                                                          </td>
                                                        </tr>
                                                      2</table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1038">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Mail From Check Rejection Policy</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 85px;">
                                              <td id="Cell565">
                                                <table width="597" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  
<tr>
                                                    <td>
                                                      <table id="Table106" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell604">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                         r
<input type="radio" checked="checked" name="Mail_From_reject" value="Fail" style="height: 13px; width: 13px;">
 `
<input type="radio" name="Mail_From_reject" value="Fail" style="height: 13px; width: 13px;">







&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="542" id="Cell605">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Fail</b><b><span style="color: rgb(128,128,128);"> <span style="font-weight: normal;">(</span>Default.<span style="font-weight: normal;"> Reject on Mail From Fail)</span></span></b></span></p>
                                                          �</td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell606">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"> z
<input type="radio" checked="checked" name="Mail_From_reject" value="SPF_Not_Pass" style="height: 13px; width: 13px;">
 h
<input type="radio" name="Mail_From_reject" value="SPF_Not_Pass" style="height: 13px; width: 13px;">
3




&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell607">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>SPF Not Pass </b><span style="color: rgb(128,128,128); font-weight: normal;">(Reject if result not Pass/None/Tempfail. Do not use this option unless necessary)</span></span></p>
                                                          </td>
                                                        N</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1048">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"> v
<input type="radio" checked="checked" name="Mail_From_reject" value="Softfail" style="height: 13px; width: 13px;">
 d
<input type="radio" name="Mail_From_reject" value="Softfail" style="height: 13px; width: 13px;">
 


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1049">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><b>SoftFail </b><span style="color: rgb(128,128,128); font-weight: normal;">(Reject on Mail From Softfail or Fail. Do not use this option unless necessary)</span></span></span></p>
                                                          </"�td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1050">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">$ s
<input type="radio" checked="checked" name="Mail_From_reject" value="False" style="height: 13px; width: 13px;">
& a
<input type="radio" name="Mail_From_reject" value="False" style="height: 13px; width: 13px;">
(



&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1051">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><b>False </b><span style="color: rgb(128,128,128); font-weight: normal;">(Never reject Mail From, append headers only)</span></span></span></p>
                                                          </td>
                                                        *N</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1052">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">, v
<input type="radio" checked="checked" name="Mail_From_reject" value="No_Check" style="height: 13px; width: 13px;">
. d
<input type="radio" name="Mail_From_reject" value="No_Check" style="height: 13px; width: 13px;">
0






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1053">
                                                            <p style="margin-bottom: 0px;"><span style="font-size: 12px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><b>No Check </b><span style="color: rgb(128,128,128); font-weight: normal;">(Never check Mail From)</span></span></span></p>
                                                          </td>
                                                        2h</tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell609">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Permanent Error Processing</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell611">
                                                <table width="659" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  4<tr>
                                                    <td>
                                                      <table id="Table166" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1054">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">6 s
<input type="radio" checked="checked" name="PermError_reject" value="False" style="height: 13px; width: 13px;">
8 a
<input type="radio" name="PermError_reject" value="False" style="height: 13px; width: 13px;">
:4





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="604" id="Cell1055">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>False </b><span style="color: rgb(128,128,128); font-weight: normal;">(<b>Default.</b> Treat PermError the same as no SPF record at all)</span></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1056">
                                                            <i<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">> r
<input type="radio" checked="checked" name="PermError_reject" value="True" style="height: 13px; width: 13px;">
@ `
<input type="radio" name="PermError_reject" value="True" style="height: 13px; width: 13px;">
B




&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1057">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>True</b><b><span style="color: rgb(128,128,128);"> <span style="font-weight: normal;">(Reject mail if the SPF result (HELO Check or Mail From Check) is PermError)</span></span></b></span></p>
                                                          D</td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell749">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Temporary Error Processing</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell751">
                                                F�<table width="661" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table167" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="56" id="Cell1064">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">H r
<input type="radio" checked="checked" name="TempError_Defer" value="False" style="height: 13px; width: 13px;">
J `
<input type="radio" name="TempError_Defer" value="False" style="height: 13px; width: 13px;">
LN



&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="605" id="Cell1065">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b><span style="color: rgb(128,128,128);"></span>False </b><b><span style="color: rgb(128,128,128);"><span style="font-weight: normal;">(</span>Default.<span style="font-weight: normal;"> Treat TempError the same as no SPF record at all. </span></span></b></span></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          N�<td id="Cell1066">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">P q
<input type="radio" checked="checked" name="TempError_Defer" value="True" style="height: 13px; width: 13px;">
R _
<input type="radio" name="TempError_Defer" value="True" style="height: 13px; width: 13px;">
T2







&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1067">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>True </b><span style="color: rgb(128,128,128); font-weight: normal;">(Defer the message of the SPF result (HELO check or Mail From Check) is TempError)</span></span></p>
                                                          </td>
                                                        V9</tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell651">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="956">
                                      <tr valign="top" align="left">
                                        X8<td width="956" height="3"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="956" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;">Zd
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Please enter a valid Message Size Limit</span></i></b></p>
\a
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Please enter a valid RBL Block Score</span></i></b></p>
^�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Saved. Please click on the Apply Settings to apply your changes</span></i></b></p>
`j
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Message Size Limit must be greater than 0</span></i></b></p>
b$

&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="953">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="953" id="Cell722">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    d<td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="hidden" name="action" value="edit">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              f</td>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="965">
                        <tr valign="top" align="left">
                          <td width="8" height="2"></td>
                          <td width="1"></td>
                          <td></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="3" valign="middle" width="957">h~<hr id="HRRule3" width="957" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="63"></td>
                          <td width="955">j show_action2l applyn _16pu	sq 8

<!-- GENERATE CUSTOM TRANSACTION STARTS HERE -->

s customtransu getrandom_resultsw 	setResulty 1
 �z Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
| inserttrans~ stResult� &
insert into salt
(salt)
values
('� getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;��
 /� getId� $
 /� lucee/runtime/type/Query� getCurrentrow (I)I���� getRecordcount� $�� !lucee/runtime/util/NumberIterator� load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� A� isValid (I)Z��
�� current� $
�� go (II)Z���� #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� removeQuery�  A� release &(Llucee/runtime/util/NumberIterator;)V��
�� ')
� gettrans� 2
select salt as customtrans2 from salt where id='� '
� deletetrans� 
delete from salt where id='� {

<!-- GENERATE CUSTOM TRANSACTION ENDS HERE -->

<!-- GET SPF CONFIGURATION PARAMETERS FROM DATABASE STARTS HERE -->
� �

<!-- GET SPF CONFIGURATION PARAMETERS FROM DATABASE ENDS HERE -->

<!-- UPDATE SPF CONFIGURATION PARAMETERS IN policyd-spf.conf FILE STARTS HERE -->

<!-- READ /OPT/HERMES/TEMPLATES/POLICYD-SPF.CONF.HERMES TEMPLATE FILE -->

� lucee.runtime.tag.FileTag� cffile� lucee/runtime/tag/FileTag� hasBody� �
�� read� 	setAction� 1
�� -/opt/hermes/templates/policyd-spf.conf.HERMES� setFile� 1
�� policydfile� setVariable� 1
��
� �
� � 0 /opt/hermes/tmp/� java/lang/String� concat &(Ljava/lang/String;)Ljava/lang/String;��
�� _policyd-spf.conf� DEBUG-LEVEL� ALL� (lucee/runtime/functions/string/REReplace� w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &�
�� 	setOutput�
�� 
    
� 	TEST-ONLY� HELO-REJECT� MAIL-FROM-REJECT� PERMERROR-REJECT� TEMPERROR-REJECT  �

<!-- UPDATE SPF CONFIGURATION PARAMETERS ENDS HERE -->

<!-- ADD SPF BYPASS PARAMETERS HERE -->

<!-- RESET ALL APPLIED TO 2 -->
 resetall %
update spf_bypass set applied='2'
 %

<!-- GET ALL ADD IP ACTIONS -->
 getaddip
 C
select * from spf_bypass where action='add' and entry_type='ip'
 *

<!-- GET ALL ADD NETWORK ACTIONS -->
 getaddnetwork H
select * from spf_bypass where action='add' and entry_type='network'
 '

<!-- GET ALL ADD HELO ACTIONS -->
 
getaddhelo E
select * from spf_bypass where action='add' and entry_type='helo'
 )

<!-- GET ALL ADD DOMAIN ACTIONS -->
 getadddomain G
select * from spf_bypass where action='add' and entry_type='domain'
 &

<!-- GET ALL ADD PTR ACTIONS -->
  	getaddptr" D
select * from spf_bypass where action='add' and entry_type='ptr'
$ Y


<!-- CREATE FILEDATAADDIP VARIABLE AND INSERT ADD IP ENTRIES TO THAT VARIABLE -->
& M

<!-- IF CURRENT OUTPUT ROW IS NOT THE LAST ROW IN QUERY ADD A COMMA -->
( #lucee/runtime/util/VariableUtilImpl* 
currentrow A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;,-
+. recordcount0-
+1 '(Ljava/lang/Object;Ljava/lang/Object;)I o3
 n4@F       "lucee/runtime/functions/string/Chr8 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &:
9; �

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA NORMALLY, BUT SINCE THE IP AND NETWORK GO ON THE SAME LINE, WE ADD A COMMA HERE BECAUSE NETWORK
 ADDRESSES WILL FOLLOW -->
= ,

<!-- /CFIF FOR GETADDIP.CURRENTROW -->
? a


<!-- CREATE FILEDATAADDNETWORK VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
A P

<!-- IF CURRENT OUTPUT ROW IS THE LAST ROW IN QUERY DO NOT ADD A COMMA -->
C 1

<!-- /CFIF FOR GETADDNETWORK.CURRENTROW -->
E \

<!-- CREATE FILEDATAADDHELO VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
G .

<!-- /CFIF FOR GETADDHELO.CURRENTROW -->
I ^

<!-- CREATE FILEDATAADDDOMAIN VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
K 0

<!-- /CFIF FOR GETADDDOMAIN.CURRENTROW -->
M [

<!-- CREATE FILEDATAADDPTR VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
O -

<!-- /CFIF FOR GETADDPTR.CURRENTROW -->
Q U

<!-- READ /OPT/HERMES/TMP/#CUSTOMTRANS3_POLICYD-SPF.CONF FILE CREATED ABOVE -->
S theSPFU l
  
<!-- CREATE TEMP FILE AND REPLACE IP-NETWORK-WHITELIST PLACEHOLDER WITH IPS AND NETWORK ENTRIES --> 
W IP-NETWORK-WHITELISTY S 
    
<!-- READ CREATED TEMP /OPT/HERMES/TMP/CUSTOMTRANS3_POLICYD-SPF.CONF -->
[ F
  
<!-- REPLACE HELO-WHITELIST PLACEHOLDER WITH HELO ENTRIES --> 
] HELO-WHITELIST_ R
    
<!-- READ CREATED TEMP /OPT/HERMES/TMP/CUSTOMTRANS3_POLICYD-SPF.CONF -->
a J
  
<!-- REPLACE DOMAIN-WHITELIST PLACEHOLDER WITH DOMAIN ENTRIES --> 
c DOMAIN-WHITELISTe E
  
<!-- REPLACE PTR-WHITELIST PLACEHOLDER WITH PTR ENTRIES -->  
g PTR-WHITELISTi 


<!-- ADD SPF BYPASS ENDS HERE -->



<!-- MAKE A BACKUP OF EXISTING /ETC/POSTFIX/POLICYD-SPF-PYTHON.CONF FILE -->

k 	_apply.shm w/bin/cp /etc/postfix-policyd-spf-python/policyd-spf.conf /etc/postfix-policyd-spf-python/policyd-spf.conf.HERMES.BACKUPo@$       setAddnewlines �
�t �


<!-- CREATE /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT AND INSERT MAKE A BACKUP OF EXISTING /ETC/POSTFIX/POLICYD-SPF-PYTHON.CONF FILE COMMAND -->

v �

<!--  APPEND MOVE AND REPLACE EXISTING /ETC/POSTFIX/POLICYD-SPF-PYTHON.CONF FILE COMMAND WITH ONE WE CREATED ABOVE COMMAND IN /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH
 SCRIPT CREATED ABOVE -->
x APPENDz /bin/mv /opt/hermes/tmp/| B_policyd-spf.conf /etc/postfix-policyd-spf-python/policyd-spf.conf~ �

<!-- APPEND CREATE POSTFIX RESTART COMMAND TO APPLY CHANGES IN /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT SCRIPT CREATED ABOVE -->

� /bin/systemctl restart postfix � P


<!-- MAKE /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT EXECUTABLE -->

� lucee.runtime.tag.Execute� 	cfexecute� lucee/runtime/tag/Execute� 
/bin/chmod�
� � +x /opt/hermes/tmp/� setArguments�
��@N       
setTimeout (D)V��
��
� �
�
� � H


<!-- EXECUTE /OPT/HERMES/TMP/#CUSTOMTRANS3_APPLY.SH SCRIPT -->

� 	/dev/null� setOutputfile� 1
�� -inputformat none�@n       A


<!-- DELETE POSTFIX RESTART SCRIPT TO APPLY CHANGES -->

� delete� ;
    
 


<!-- SET ALL SPF PARAMETERS TO APPLIED -->
� completespf� ;
update parameters2 set applied='1' where module = 'spf'
� ,

<!-- SET ALL SPF BYPASS TO APPLIED -->
� 
spfapplied� %
update spf_bypass set applied='1'
�8

                            <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion13" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="9"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="955">
                                        <form name="apply_settings" action="spf_configuration.cfm#apply" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="955" id="Cell753">
                                                �6<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;">� 
getapplied� @
select * from parameters2 where module='spf' and applied='2'
� (Ljava/lang/Object;D)I o�
 n� �
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
�
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Applying settings, please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" disabled="disabled" style="height: 24px; width: 142px;">
�&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="955">
                                    <tr valign="top" align="left">
                                      <td width="8" height="4"></td>
                                      <td width="947"></td>
                                    �-</tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="947" id="Text351" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;">� 16�_
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
�



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
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion24" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="981">
                        <tr valign="top" align="left">
                          <td width="981" height="12">� �</td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;">� $lucee/runtime/functions/dateTime/Now� =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &�
�� yyyy� 4lucee/runtime/functions/displayFormatting/DateFormat� S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &�
�� 
getversion� D
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
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties; 	  setPageSource 
  license lucee/runtime/type/KeyImpl	 intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;

 LICENSE SHOW_ACTION GET_DEBUGLEVEL VALUE2 
DEBUGLEVEL GET_TESTONLY TESTONLY GET_HELO_REJECT HELO_REJECT GET_MAIL_FROM_REJECT! MAIL_FROM_REJECT# GET_PERMERROR_REJECT% PERMERROR_REJECT' GET_TEMPERROR_DEFER) TEMPERROR_DEFER+ action2- ACTION2/ SHOW_ACTION21 M23 RANDOM5 STRESULT7 GENERATED_KEY9 CUSTOMTRANS3; GETTRANS= CUSTOMTRANS2? POLICYDFILEA FILEDATAADDIPC GETADDIPE ENTRYG FILEDATAADDNETWORKI GETADDNETWORKK FILEDATAADDHELOM 
GETADDHELOO FILEDATAADDDOMAINQ GETADDDOMAINS FILEDATAADDPTRU 	GETADDPTRW THESPFY 
GETAPPLIED[ THEYEAR] EDITION_ 
GETVERSIONa GETBUILDc subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             T U   ef       g   *     *� 
*� *� � *���*+��        g         �        g        � �        g         �        g         �         g         !�      # $ g        %�      & ' g  h� �  W�+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+ R*� W2� Y� ^� �+`� 3+� d*� W2� j l� r� � � U+`� 3+� tvx� |� ~M,�� �,� �,� �W,� �� � ��� N+� t,� �-�+� t,� �+`� 3� ~+� d*� W2� j �� r� � � ^+`� 3+� tvx� |� ~:�� �� �� �W� �� � ��� :+� t� ��+� t� �+`� 3� +`� 3� +�� 3+�� 3+�� 3+�� 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� ��� ��� �� ŷ ƿ:6+� t�� � �� �+`� 3+�+� �� �:	6
+� �	� 0�Y:� !� �Y� �Y�� �ж ��� �� ŷ ƿ:	6
+� t��	 � �
� �+`� 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� �Ҷ ��� �� ŷ ƿ:6+� t�� � �� �+Զ 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� �ֶ ��� �� ŷ ƿ:6+� t�� � �� �+ڶ 3+ ۲ �� Y� ^� �� � � T+`� 3+� � � � � r� � � .+`� 3+� 7*� W2+� � � � � E W+`� 3� � +� 3+� �+� t��� |� �:�� +� 7� =� ��6� O+�
+� 3���� $:�� :� +�W��� +�W��� � ��� :+� t� ��+� t� �� :+��+�+� 3+� �+� t��� |� �: � +� 7� =� ��6� O+�
+"� 3���� $:�� :� +�W��� +�W��� � ��� :+� t� ��+� t� �� :+��+�+$� 3+� �+� t��� |� �:&� +� 7� =� ��6� O+�
+(� 3���� $:  �� :!� +�W�!�� +�W��� � ��� :"+� t� �"�+� t� �� :#+�#�+�+� 3+� �+� t��� |� �:$$*� $+� 7� =� �$�6%%� O+$%�
+,� 3$���� $:&$&�� :'%� +�W$�'�%� +�W$�$�� � ��� :(+� t$� �(�+� t$� �� :)+�)�+�+� 3+� �+� t��� |� �:**.� *+� 7� =� �*�6++� O+*+�
+0� 3*���� $:,*,�� :-+� +�W*�-�+� +�W*�*�� � ��� :.+� t*� �.�+� t*� �� :/+�/�+�+� 3+� �+� t��� |� �:002� 0+� 7� =� �0�611� O+01�
+4� 30���� $:202�� :31� +�W0�3�1� +�W0�0�� � ��� :4+� t0� �4�+� t0� �� :5+�5�+�+� 3+6+� �� �:667+� �6� H++� 7*� W2�9 *� W2�<Y:8� "� �Y� �Y�� �6� ��� �� ŷ ƿ8:667+� t�66 � �7� �+ڶ 3+ �*� W2� Y� ^� �� � � ]+`� 3+� �*� W2� � � r� � � 3+`� 3+� 7*� W2+� �*� W2� � � E W+`� 3� � +Զ 3+>+� �� �:96:+� �9� I++� 7*� W2�9 *� W2�<Y:;� "� �Y� �Y�� �>� ��� �� ŷ ƿ;:96:+� t�>9 � �:� �+ڶ 3+ �*� W2� Y� ^� �� � � ]+`� 3+� �*� W	2� � � r� � � 3+`� 3+� 7*� W	2+� �*� W	2� � � E W+`� 3� � +@� 3+B+� �� �:<6=+� �<� I++� 7*� W
2�9 *� W2�<Y:>� "� �Y� �Y�� �B� ��� �� ŷ ƿ>:<6=+� t�B< � �=� �+ڶ 3+ �*� W2� Y� ^� �� � � ]+`� 3+� �*� W2� � � r� � � 3+`� 3+� 7*� W2+� �*� W2� � � E W+`� 3� � +Զ 3+D+� �� �:?6@+� �?� I++� 7*� W2�9 *� W2�<Y:A� "� �Y� �Y�� �D� ��� �� ŷ ƿA:?6@+� t�D? � �@� �+ڶ 3+ �*� W2� Y� ^� �� � � ]+`� 3+� �*� W2� � � r� � � 3+`� 3+� 7*� W2+� �*� W2� � � E W+`� 3� � +Զ 3+F+� �� �:B6C+� �B� I++� 7*� W2�9 *� W2�<Y:D� "� �Y� �Y�� �F� ��� �� ŷ ƿD:B6C+� t�FB � �C� �+ڶ 3+ �*� W2� Y� ^� �� � � ]+`� 3+� �*� W2� � � r� � � 3+`� 3+� 7*� W2+� �*� W2� � � E W+`� 3� � +Զ 3+H+� �� �:E6F+� �E� I++� 7*� W2�9 *� W2�<Y:G� "� �Y� �Y�� �H� ��� �� ŷ ƿG:E6F+� t�HE � �F� �+ڶ 3+ �*� W2� Y� ^� �� � � ]+`� 3+� �*� W2� � � r� � � 3+`� 3+� 7*� W2+� �*� W2� � � E W+`� 3� � +Զ 3+� 7*� W2� J� r� � �z+$� 3+� �+� t��� |� �:HHL� H+� 7� =� �H�6II� m+HI�
+N� 3++� 7*� W2� �S�V+X� 3H���է $:JHJ�� :KI� +�WH�K�I� +�WH�H�� � ��� :L+� tH� �L�+� tH� �� :M+�M�+�+$� 3+� �+� t��� |� �:NNZ� N+� 7� =� �N�6OO� m+NO�
+N� 3++� 7*� W	2� �S�V+\� 3N���է $:PNP�� :QO� +�WN�Q�O� +�WN�N�� � ��� :R+� tN� �R�+� tN� �� :S+�S�+�+$� 3+� �+� t��� |� �:TT^� T+� 7� =� �T�6UU� m+TU�
+N� 3++� 7*� W2� �S�V+`� 3T���է $:VTV�� :WU� +�WT�W�U� +�WT�T�� � ��� :X+� tT� �X�+� tT� �� :Y+�Y�+�+� 3+� �+� t��� |� �:ZZb� Z+� 7� =� �Z�6[[� m+Z[�
+N� 3++� 7*� W2� �S�V+d� 3Z���է $:\Z\�� :][� +�WZ�]�[� +�WZ�Z�� � ��� :^+� tZ� �^�+� tZ� �� :_+�_�+�+� 3+� �+� t��� |� �:``f� `+� 7� =� �`�6aa� m+`a�
+N� 3++� 7*� W2� �S�V+h� 3`���է $:b`b�� :ca� +�W`�c�a� +�W`�`�� � ��� :d+� t`� �d�+� t`� �� :e+�e�+�+$� 3+� �+� t��� |� �:ffj� f+� 7� =� �f�6gg� m+fg�
+N� 3++� 7*� W2� �S�V+l� 3f���է $:hfh�� :ig� +�Wf�i�g� +�Wf�f�� � ��� :j+� tf� �j�+� tf� �� :k+�k�+�+n� 3+� 7�q�w� E W+y� 3� +{� 3+}� 3+� 3+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :l+�l�+�+`� 3� O+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :m+�m�+�+`� 3� +�� 3+�� 3+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :n+�n�+�+`� 3� O+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :o+�o�+�+`� 3� +�� 3+�� 3+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :p+�p�+�+`� 3� O+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :q+�q�+�+`� 3� +�� 3+�� 3+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :r+�r�+�+`� 3� O+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :s+�s�+�+`� 3� +�� 3+�� 3+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :t+�t�+�+`� 3� N+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :u+�u�+�+`� 3� +�� 3+�� 3+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :v+�v�+�+`� 3� O+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :w+�w�+�+`� 3� +�� 3+�� 3+�� 3+�� 3+� 7*� W	2� �� r� � � -+`� 3+� �+�� 3� :x+�x�+�+`� 3� O+� 7*� W	2� �� r� � � -+`� 3+� �+�� 3� :y+�y�+�+`� 3� +ö 3+Ŷ 3+� 7*� W	2� �� r� � � -+`� 3+� �+Ƕ 3� :z+�z�+�+`� 3� O+� 7*� W	2� �� r� � � -+`� 3+� �+ɶ 3� :{+�{�+�+`� 3� +˶ 3+Ͷ 3+϶ 3+�� 3+� 7*� W2� Ѹ r� � � -+`� 3+� �+Ӷ 3� :|+�|�+�+`� 3� O+� 7*� W2� Ѹ r� � � -+`� 3+� �+ն 3� :}+�}�+�+`� 3� +׶ 3+ٶ 3+� 7*� W2� ۸ r� � � -+`� 3+� �+ݶ 3� :~+�~�+�+`� 3� O+� 7*� W2� ۸ r� � � -+`� 3+� �+߶ 3� :+��+�+`� 3� +� 3+� 3+� 7*� W2� � r� � � -+`� 3+� �+� 3� :�+���+�+`� 3� O+� 7*� W2� � r� � � -+`� 3+� �+� 3� :�+���+�+`� 3� +� 3+�� 3+� 7*� W2� � r� � � -+`� 3+� �+� 3� :�+���+�+`� 3� O+� 7*� W2� � r� � � -+`� 3+� �+� 3� :�+���+�+`� 3� +�� 3+�� 3+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :�+���+�+`� 3� O+� 7*� W2� �� r� � � -+`� 3+� �+�� 3� :�+���+�+`� 3� +�� 3+� 3+� 7*� W2� � r� � � -+`� 3+� �+� 3� :�+���+�+`� 3� O+� 7*� W2� � r� � � -+`� 3+� �+� 3� :�+���+�+`� 3� +	� 3+� 3+� 3+�� 3+� 7*� W2� Ѹ r� � � -+`� 3+� �+� 3� :�+���+�+`� 3� O+� 7*� W2� Ѹ r� � � -+`� 3+� �+� 3� :�+���+�+`� 3� +� 3+� 3+� 7*� W2� ۸ r� � � -+`� 3+� �+� 3� :�+���+�+`� 3� O+� 7*� W2� ۸ r� � � -+`� 3+� �+� 3� :�+���+�+`� 3� +� 3+� 3+� 7*� W2� � r� � � -+`� 3+� �+� 3� :�+���+�+`� 3� O+� 7*� W2� � r� � � -+`� 3+� �+!� 3� :�+���+�+`� 3� +#� 3+%� 3+� 7*� W2� �� r� � � -+`� 3+� �+'� 3� :�+���+�+`� 3� O+� 7*� W2� �� r� � � -+`� 3+� �+)� 3� :�+���+�+`� 3� ++� 3+-� 3+� 7*� W2� � r� � � -+`� 3+� �+/� 3� :�+���+�+`� 3� O+� 7*� W2� � r� � � -+`� 3+� �+1� 3� :�+���+�+`� 3� +3� 3+5� 3+7� 3+� 7*� W2� �� r� � � -+`� 3+� �+9� 3� :�+���+�+`� 3� O+� 7*� W2� �� r� � � -+`� 3+� �+;� 3� :�+���+�+`� 3� +=� 3+?� 3+� 7*� W2� � r� � � -+`� 3+� �+A� 3� :�+���+�+`� 3� N+� 7*� W2� � r� � � -+`� 3+� �+C� 3� :�+���+�+`� 3� +E� 3+G� 3+I� 3+� 7*� W2� �� r� � � -+`� 3+� �+K� 3� :�+���+�+`� 3� O+� 7*� W2� �� r� � � -+`� 3+� �+M� 3� :�+���+�+`� 3� +O� 3+Q� 3+� 7*� W2� � r� � � -+`� 3+� �+S� 3� :�+���+�+`� 3� N+� 7*� W2� � r� � � -+`� 3+� �+U� 3� :�+���+�+`� 3� +W� 3+Y� 3+[� 3+� 7�q� �� r� � � -+`� 3+� �+]� 3� :�+���+�+`� 3� +� 3+� 7�q� �� r� � � -+`� 3+� �+_� 3� :�+���+�+`� 3� +� 3+� 7�q� �� r� � � -+`� 3+� �+a� 3� :�+���+�+`� 3� +$� 3+� 7�q� �� r� � � -+`� 3+� �+c� 3� :�+���+�+`� 3� +e� 3+g� 3+i� 3+k� 3+m+� �� �:�6�+� ��� 1�Y:�� "� �Y� �Y�� �m� ��� �� ŷ ƿ�:�6�+� t�m� � ��� �+ڶ 3+ �*� W2� Y� ^� �� � � ]+`� 3+� �*� W2� � � r� � � 3+`� 3+� 7*� W2+� �*� W2� � � E W+`� 3� � +Զ 3+� 7*� W2� o� r� � �.]+`� 3+� 7*� W2�r� E W+t� 3+� �+� t��� |� �:��v� �+� 7� =� ��x�{��6��� O+���
+}� 3����� $:����� :��� +�W������ +�W����� � ��� :�+� t�� ���+� t�� �� :�+���+�+� 3+� �+� t��� |� �:��� �+� 7� =� ����{��6���B+���
+�� 3+� �+v��:�+��6����� 6���� � � � �6����� ��:�+� 7��� �d6���`��� D������� � � � � (���6�+++� 7*� W2� �S���V���� ":������ W+� 7�� ���������� W+� 7�� ���� :�+���+�+�� 3���� � $:����� :��� +�W������ +�W����� � ��� :�+� t�� ���+� t�� �� :�+���+�+� 3+� �+� t��� |� �:���� �+� 7� =� ���6��� x+���
+�� 3+++� 7*� W2�9 *� W2�<�S�V+�� 3����ʧ $:����� :��� +�W������ +�W����� � ��� :�+� t�� ���+� t�� �� :�+���+�+� 3+� 7*� W2++� 7*� W2�9 *� W2�<� E W+� 3+� �+� t��� |� �:���� �+� 7� =� ���6��� x+���
+�� 3+++� 7*� W2�9 *� W2�<�S�V+�� 3����ʧ $:����� :��� +�W������ +�W����� � ��� :�+� t�� ���+� t�� �� :�+�¿+�+¶ 3+� �+� t��� |� �:���� �+� 7� =� �ö6��� O+�Ķ
+� 3ö��� $:��Ŷ� :��� +�Wöƿ�� +�Wöö� � ��� :�+� tö �ǿ+� tö �� :�+�ȿ+�+� 3+� �+� t��� |� �:�� � �+� 7� =� �ɶ6��� O+�ʶ
+"� 3ɶ��� $:��˶� :��� +�Wɶ̿�� +�Wɶɶ� � ��� :�+� tɶ �Ϳ+� tɶ �� :�+�ο+�+$� 3+� �+� t��� |� �:��&� �+� 7� =� �϶6��� O+�ж
+(� 3϶��� $:��Ѷ� :��� +�W϶ҿ�� +�W϶϶� � ��� :�+� t϶ �ӿ+� t϶ �� :�+�Կ+�+� 3+� �+� t��� |� �:��*� �+� 7� =� �ն6��� O+�ֶ
+,� 3ն��� $:��׶� :��� +�Wնؿ�� +�Wնն� � ��� :�+� tն �ٿ+� tն �� :�+�ڿ+�+� 3+� �+� t��� |� �:��.� �+� 7� =� �۶6��� O+�ܶ
+0� 3۶��� $:��ݶ� :��� +�W۶޿�� +�W۶۶� � ��� :�+� t۶ �߿+� t۶ �� :�+��+�+� 3+� �+� t��� |� �:��2� �+� 7� =� ��6��� O+��
+4� 3���� $:���� :��� +�W���� +�W��� � ��� :�+� t� ��+� t� �� :�+��+�+Ķ 3+� t��� |��:�����϶��Զ��ٶ���W��� � ��� :�+� t� ��+� t� �+� 3+� t��� |��:�����߶���+� 7*� W2� �S������++� 7*� W 2� �S�++� 7*� W2�9 *� W2�<�S������W��� � ��� :�+� t� ��+� t� �+�� 3+� t��� |��:�����϶���+� 7*� W2� �S������ٶ���W��� � ��� :�+� t� ��+� t� �+� 3+� t��� |��:�����߶���+� 7*� W2� �S������++� 7*� W 2� �S�++� 7*� W2�9 *� W2�<�S�������W���� � ��� :�+� t�� ��+� t�� �+�� 3+� t��� |��:�����϶���+� 7*� W2� �S������ٶ���W��� � ��� :�+� t� ��+� t� �+� 3+� t��� |��:�����߶���+� 7*� W2� �S������++� 7*� W 2� �S�++� 7*� W
2�9 *� W2�<�S������W��� � ��� :�+� t� ��+� t� �+�� 3+� t��� |��:�����϶���+� 7*� W2� �S������ٶ���W��� � ��� :�+� t� ���+� t� �+� 3+� t��� |��:�����߶���+� 7*� W2� �S������++� 7*� W 2� �S�++� 7*� W2�9 *� W2�<�S�������W���� � ��� :�+� t�� ���+� t�� �+�� 3+� t��� |��:�����϶���+� 7*� W2� �S������ٶ����W���� � ��� :�+� t�� ���+� t�� �+� 3+� t��� |��:�����߶���+� 7*� W2� �S������++� 7*� W 2� �S�++� 7*� W2�9 *� W2�<�S�������W���� � ��� :�+� t�� ���+� t�� �+�� 3+� t��� |��:�����϶���+� 7*� W2� �S������ٶ����W���� � ��� :�+� t�� ���+� t�� �+� 3+� t��� |��:�����߶���+� 7*� W2� �S������++� 7*� W 2� �S++� 7*� W2�9 *� W2�<�S�������W���� � ��� :�+� t�� ���+� t�� �+� 3+� �+� t��� |� �:��� �+� 7� =� ����6 � � ]+�� �
+� 3����� .�:���� �:� � +�W����� � +�W����� � ��� �:+� t�� ���+� t�� �� �:+���+�+	� 3+� �+� t��� |� ��:�� �+� 7� =� ����6�� g+���
+� 3����� 2�:����  �:�� +�W������ +�W����� � ��� �:	+� t�� ��	�+� t�� �� �:
+��
�+�+� 3+� �+� t��� |� ��:�� �+� 7� =� ����6�� g+���
+� 3����� 2�:����  �:�� +�W������ +�W����� � ��� �:+� t�� ���+� t�� �� �:+���+�+� 3+� �+� t��� |� ��:�� �+� 7� =� ����6�� g+���
+� 3����� 2�:����  �:�� +�W������ +�W����� � ��� �:+� t�� ���+� t�� �� �:+���+�+� 3+� �+� t��� |� ��:�� �+� 7� =� ����6�� g+���
+� 3����� 2�:����  �:�� +�W������ +�W����� � ��� �:+� t�� ���+� t�� �� �:+���+�+!� 3+� �+� t��� |� ��:�#� �+� 7� =� ����6�� g+���
+%� 3����� 2�:����  �: �� +�W��� ��� +�W����� � ��� �:!+� t�� ��!�+� t�� �� �:"+��"�+�+'� 3+� 7*� W!2� E W+`� 3+���:$+���6%�$�%�� �6&�$�� � � ���6'�'�$�� ���:#+� 7�$�� �'d�6*�#�*`���l�$�#���%�� � � � �J�#���6*+)� 3++� 7*� W"2�9 �/++� 7*� W"2�9 �2�5� � � b+ڶ 3+� 7*� W!2+� 7*� W!2� �S++� 7*� W"2�9 *� W#2�<�S��+6�<�� E W+>� 3� �++� 7*� W"2�9 �/++� 7*� W"2�9 �2�5� � � b+`� 3+� 7*� W!2+� 7*� W!2� �S++� 7*� W"2�9 *� W#2�<�S��+6�<�� E W+@� 3� +� 3���� .�:+�$�&�%�� W+� 7�� �#���+��$�&�%�� W+� 7�� �#��+B� 3+� 7*� W$2� E W+`� 3+���:-+���6.�-�.�� �6/�-�� � � ���60�0�-�� ���:,+� 7�-�� �0d�63�,�3`���b�-�,���.�� � � � �@�,���63+)� 3++� 7*� W%2�9 �/++� 7*� W%2�9 �2�5� � � b+ڶ 3+� 7*� W$2+� 7*� W$2� �S++� 7*� W%2�9 *� W#2�<�S��+6�<�� E W+D� 3� �++� 7*� W%2�9 �/++� 7*� W%2�9 �2�5� � � X+`� 3+� 7*� W$2+� 7*� W$2� �S++� 7*� W%2�9 *� W#2�<�S�� E W+F� 3� +� 3���� .�:4�-�/�.�� W+� 7�� �,���4��-�/�.�� W+� 7�� �,��+H� 3+� 7*� W&2� E W+`� 3+���:6+���67�6�7�� �68�6�� � � ���69�9�6�� ���:5+� 7�6�� �9d�6<�5�<`���b�6�5���7�� � � � �@�5���6<+)� 3++� 7*� W'2�9 �/++� 7*� W'2�9 �2�5� � � b+ڶ 3+� 7*� W&2+� 7*� W&2� �S++� 7*� W'2�9 *� W#2�<�S��+6�<�� E W+D� 3� �++� 7*� W'2�9 �/++� 7*� W'2�9 �2�5� � � X+`� 3+� 7*� W&2+� 7*� W&2� �S++� 7*� W'2�9 *� W#2�<�S�� E W+J� 3� +� 3���� .�:=�6�8�7�� W+� 7�� �5���=��6�8�7�� W+� 7�� �5��+L� 3+� 7*� W(2� E W+`� 3+���:?+���6@�?�@�� �6A�?�� � � ���6B�B�?�� ���:>+� 7�?�� �Bd�6E�>�E`���b�?�>���@�� � � � �@�>���6E+)� 3++� 7*� W)2�9 �/++� 7*� W)2�9 �2�5� � � b+ڶ 3+� 7*� W(2+� 7*� W(2� �S++� 7*� W)2�9 *� W#2�<�S��+6�<�� E W+D� 3� �++� 7*� W)2�9 �/++� 7*� W)2�9 �2�5� � � X+`� 3+� 7*� W(2+� 7*� W(2� �S++� 7*� W)2�9 *� W#2�<�S�� E W+N� 3� +`� 3���� .�:F�?�A�@�� W+� 7�� �>���F��?�A�@�� W+� 7�� �>��+P� 3+� 7*� W*2� E W+`� 3+#���:H+���6I�H�I�� �6J�H�� � � ���6K�K�H�� ���:G+� 7�H�� �Kd�6N�G�N`���b�H�G���I�� � � � �@�G���6N+)� 3++� 7*� W+2�9 �/++� 7*� W+2�9 �2�5� � � b+ڶ 3+� 7*� W*2+� 7*� W*2� �S++� 7*� W+2�9 *� W#2�<�S��+6�<�� E W+D� 3� �++� 7*� W+2�9 �/++� 7*� W+2�9 �2�5� � � X+`� 3+� 7*� W*2+� 7*� W*2� �S++� 7*� W+2�9 *� W#2�<�S�� E W+R� 3� +� 3���� .�:O�H�J�I�� W+� 7�� �G���O��H�J�I�� W+� 7�� �G��+T� 3+� t��� |���:P�P���P϶��P�+� 7*� W2� �S������PV���P��W�P��� � ��� �:Q+� t�P� ��Q�+� t�P� �+X� 3+� t��� |���:R�R���R߶��R�+� 7*� W2� �S������R++� 7*� W,2� �SZ+� 7*� W!2� �S+� 7*� W$2� �S�������R��W�R��� � ��� �:S+� t�R� ��S�+� t�R� �+\� 3+� t��� |���:T�T���T϶��T�+� 7*� W2� �S������TV���T��W�T��� � ��� �:U+� t�T� ��U�+� t�T� �+^� 3+� t��� |���:V�V���V߶��V�+� 7*� W2� �S������V++� 7*� W,2� �S`+� 7*� W&2� �S�����V��W�V��� � ��� �:W+� t�V� ��W�+� t�V� �+b� 3+� t��� |���:X�X���X϶��X�+� 7*� W2� �S������XV���X��W�X��� � ��� �:Y+� t�X� ��Y�+� t�X� �+d� 3+� t��� |���:Z�Z���Z߶��Z�+� 7*� W2� �S������Z++� 7*� W,2� �Sf+� 7*� W(2� �S�����Z��W�Z��� � ��� �:[+� t�Z� ��[�+� t�Z� �+b� 3+� t��� |���:\�\���\϶��\�+� 7*� W2� �S������\V���\��W�\��� � ��� �:]+� t�\� ��]�+� t�\� �+h� 3+� t��� |���:^�^���^߶��^�+� 7*� W2� �S������^++� 7*� W,2� �Sj+� 7*� W*2� �S�����^��W�^��� � ��� �:_+� t�^� ��_�+� t�^� �+l� 3+� t��� |���:`�`���`߶��`�+� 7*� W2� �S��n����`p+q�<����`�u�`��W�`��� � ��� �:a+� t�`� ��a�+� t�`� �+w� 3+� t��� |���:b�b���b߶��b�+� 7*� W2� �S��n����bp+q�<����b�u�b��W�b��� � ��� �:c+� t�b� ��c�+� t�b� �+y� 3+� t��� |���:d�d���d{���d�+� 7*� W2� �S��n����d}+� 7*� W2� �S����+q�<����d�u�d��W�d��� � ��� �:e+� t�d� ��e�+� t�d� �+�� 3+� t��� |���:f�f���f{���f�+� 7*� W2� �S��n����f�+q�<����f�u�f��W�f��� � ��� �:g+� t�f� ��g�+� t�f� �+�� 3+� t��� |���:h�h����h�+� 7*� W2� �S��n����h����h���6i�i� F+�h�i�
+`� 3�h����� �:j�i� +�W�j��i� +�W�h��� � ��� �:k+� t�h� ��k�+� t�h� �+�� 3+� t��� |���:l�l�+� 7*� W2� �S��n����l����l����l����l���6m�m� F+�l�m�
+`� 3�l����� �:n�m� +�W�n��m� +�W�l��� � ��� �:o+� t�l� ��o�+� t�l� �+�� 3+� t��� |���:p�p���p����p�+� 7*� W2� �S��n����p��W�p��� � ��� �:q+� t�p� ��q�+� t�p� �+�� 3+� �+� t��� |� ��:r�r�� �r+� 7� =� ��r��6s�s� g+�r�s�
+�� 3�r���� 2�:t�r�t��  �:u�s� +�W�r��u��s� +�W�r��r�� � ��� �:v+� t�r� ��v�+� t�r� �� �:w+��w�+�+�� 3+� �+� t��� |� ��:x�x�� �x+� 7� =� ��x��6y�y� g+�x�y�
+�� 3�x���� 2�:z�x�z��  �:{�y� +�W�x��{��y� +�W�x��x�� � ��� �:|+� t�x� ��|�+� t�x� �� �:}+��}�+�+y� 3� +�� 3+�� 3+� �+� t��� |� ��:~�~�� �~+� 7� =� ��~��6�� g+�~��
+�� 3�~���� 2�:��~����  �:��� +�W�~������ +�W�~��~�� � ��� �:�+� t�~� ����+� t�~� �� �:�+����+�+`� 3++� 7*� W-2�9 �2��� � � +Ķ 3� 
+ƶ 3+ȶ 3+ʶ 3+� 7*� W2� ̸ r� � � 1+`� 3+� �+ζ 3� �:�+����+�+`� 3� +ж 3+Ҷ 3+� 7*� W.2++��ٸ޹ E W+`� 3+� �+� t��� |� ��:���� ��+� 7� =� �����6���� g+�����
+� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� t��� ����+� t��� �� �:�+����+�+`� 3+� �+� t��� |� ��:���� ��+� 7� =� �����6���� g+�����
+� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� t��� ����+� t��� �� �:�+����+�+`� 3+� �+� 3++� d*� W/2� j �S� 3+� 3+++� 7*� W02�9 ���<�S� 3+� 3+++� 7*� W12�9 ���<�S� 3+� 3++� 7*� W.2� �S� 3+� 3� �:�+����+�+�� 3� � � � �   �  ��� )���  r��  a  dtw )d��  6��  %��  *:= )*FI  �  ���  �� )�  �DD  �^^  ��� )���  �		  u##  y�� )y��  K��  :��  _�� )_��  1��   ��  Cqt )C}�  ��  ��  'UX )'ad  ���  ���  
8; )
DG  �}}  ���  � )�'*  �``  �zz  �� )�  �DD  �^^  ���  ##  s}}  ���  ##  eoo  ���    dnn  ���  	  U__  ���  	  cmm  ���  !!  cmm  ���  	  cmm  ���  	  U__  ���  �  U__  ���  	  U__  ���  �  U__  ���  �  GQQ  ���  ���   N X X   � � �   � � �  !>!H!H  !�!�!�  !�!�!�  "D"N"N  "�"�"�  "�"�"�  #:#D#D  #�#�#�  #�#�#�  %�%�%� )%�%�%�  %R%�%�  %A%�%�  &�&�&�  &`';';  &U'X'[ )&U'd'g  &'�'�  &'�'�  ((F(I )((R(U  '�(�(�  '�(�(�  )-)f)i ))-)r)u  (�)�)�  (�)�)�  **+*. )**7*:  )�*p*p  )�*�*�  *�*�*� )*�*�*�  *�+5+5  *�+O+O  +�+�+� )+�+�+�  +x+�+�  +g,,  ,k,{,~ ),k,�,�  ,=,�,�  ,,,�,�  -0-@-C )-0-L-O  --�-�  ,�-�-�  -�.. )-�..  -�.J.J  -�.d.d  .�.�.�  .�/w/w  /�/�/�  0)0�0�  0�1313  1c1�1�  22m2m  2�3%3%  3V3�3�  3�4_4_  4�4�4�  55�5�  6 66 )6 6 6#  5�6a6a  5�66  6�6�6� )6�77  6�7U7U  6�7w7w  7�7�7� )7�88	  7�8M8M  7�8o8o  8�8�8� )8�8�9  8�9E9E  8�9g9g  9�9�9� )9�9�9�  9�:=:=  9�:_:_  :�:�:� ):�:�:�  :�;5;5  :{;W;W  ;�=m=m  >C?�?�  @�A�A�  B�DEDE  EF�F�  F�GSGS  G�H.H.  HiH�H�  II�I�  I�J#J#  J^J�J�  K#K�K�  K�LELE  L�L�L�  M*M�M�  M�N_N_  N�O	O	  O�O�O�  ODO�O�  P�P�P�  P"P�P�  Q
Q]Q]  Q�Q�Q� )Q�Q�Q�  Q�RARA  Q�RcRc  R�R�R� )R�R�R�  R�S9S9  RS[S[  S�S�S� )S�S�S�  S�TBTB  S�TdTd  T�T�T�  U�U�U� )U�U�U�  UUU�U�  UBVV  V�V�V� )V�V�V�  VLV�V�  V9WW  W0W�W�   h         * +  i  	�r   
        6  7 ! a $ z - � 0 � 9 � O � u � � � � �9 �B �K �Z �] �` �� �! �� �� �	 �, �N �Z �� � h�.�	�n�3}�t����	r	�	�	�	�"
r#
�$
�%
�&
�(q)�*�+�,�.p/�0�1�2�4o5�6�7�8�:=c?�C�FGHeL�O+QIU�WY,]�_�ae�h�j�nos�u�v�y����������������0�3�=�G�l�w�������������������0�3�^�i�|�������������� "%/	9]h{ ~!�"�#�$�%�+�7�8�?@A B#CNDYElFoGyM�g�h�r�s�t�u�vwx y#z-�7�\�g�z�}�����������������������.�1�\�g�z�}��������������� �#�-�7\gz}������/01 2#3N4Y5l6o7y>�R�S�T�U�V�W�XYZa)uNvYwlxoy�z�{�|�}���������� �#�N�Y�l�o�y������������������)�N�Y�l�o����������������@K^aku,�-�.�/�0�1�2 3 4 ; U V "] G^ R_ e` ha �b �c �d �e �k �v �w �| �} �~!
!�!7�!B�!U�!X�!b�!l�!p�!s�!��!��!��!��!��!��"�"�"�"�"�"�"=�"H�"[�"^�"��"��"��"��"��"��"��"��"��#�#�#�#3 #>#Q#T#]#�#�#�#�	#�#�#�#�#�#�#�!$"$C$J$uK$�L$�M$�N$�P%Q%:S%=U%�W&Y&Y]'L^'�`(a(:b(�d(�f)1g)Zh)�j)�m*o*�q*�s+`v+�x,%z,o|,�~-4�-��-��.u�.x�.��/ �/$�/��/��/��0�09�0]�0��0��0��1M�1s�1��2�2�2�2��2��2��3<�3<�3@�3��3��4�4v�4v�4z�4��5!�5E�5��5��5��5��6�6��6��6��7��7��7��8��8��8��9|�9�9��:t�:w�:��;l�;o�;��<2�<5�<o�<��<��=�=[�=a�=d�=��=��=��>��>��>��?�?�?W�?��?��?��@�@	�@�@��@��A	�A_�Ae A�A�A�A�BNBQ	Bg
CCCQC�C�C�D3D9D<D�D�D�E\E_E�E� E�!F/"F{$F�%F�'F�)F�*Gv,Gy-G�.G�/HM-HM/HQ1HT2H�4H�5I6I=7I�5I�7I�9I�:JF<JI=Jt>J�?K=K?KAKBK�DK�EK�FK�GLdELdGLhJLkPL�QL�RL�SMPMSMVMXM@YMfZMz[M�XM�[M�]M�_M�`NaN@bN~_N~bN�dN�fN�gN�hN�iO(fO(iO,lO/nORoOxpO�qP
tPvPLwPVxP`yP�zP�}P�Q�Q �Q|Q|�Q��Q��Q��Rx�R{�R��Sp�Sv�Sz�S}�S��S��S��Tx�T��T��T��T��T��T��T��U�U�U�U�U;�U��V2�V��W)�W4�j     ) �� g        �    j     ) �� g         �    j     ) �� g        �    j    �    g      �*2� YY�SY�SY�SY�SY�SY6�SY�SY�SY>�SY	�SY
�SYB�SY �SY"�SYD�SY$�SY&�SYF�SY(�SY*�SYH�SY,�SY.�SY0�SY2�SY4�SY6�SY8�SY:�SY<�SY>�SY@�SY B�SY!D�SY"F�SY#H�SY$J�SY%L�SY&N�SY'P�SY(R�SY)T�SY*V�SY+X�SY,Z�SY-\�SY.^�SY/`�SY0b�SY1d�S� W�     k    