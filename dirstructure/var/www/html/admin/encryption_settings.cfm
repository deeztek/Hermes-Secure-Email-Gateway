����   2� encryption_settings_cfm$cf  lucee/runtime/PageImpl  /admin/encryption_settings.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength      �m getCompileTime  n��R getHash ()I���e call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Lencryption_settings_cfm$cf;
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Encryption Settings</title>
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
              <td height="630" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion30" style="background-image: url('./middle_988.png'); height: 630px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="515">
                              <tr valign="top" align="left">
                                <td width="9" height="13"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                 P<td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Encryption Settings</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="455">
                              <tr valign="top" align="left">
                                <td width="430" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/encryption/encryption-settings/')"> R�<img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="8" height="3"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="576"></td>
                          <td width="964"> T m V &lucee/runtime/config/NullSupportHelper X NULL Z '
 Y [ -lucee/runtime/interpreter/VariableInterpreter ] getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; _ `
 ^ a 0 c %lucee/runtime/exp/ExpressionException e java/lang/StringBuilder g The required parameter [ i  1
 h k append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; m n
 h o ] was not provided. q -(Ljava/lang/String;)Ljava/lang/StringBuilder; m s
 h t toString ()Ljava/lang/String; v w
 h x
 f k lucee/runtime/PageContextImpl { any }�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 | �  
 � step � 

 � action �   �  

 �@       _action � ;	 9 � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � 
 � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � ;	 9 � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � 


 � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 | � lucee/runtime/tag/Query � get_subjectenable � setName � 1
 � � A � setDatasource (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � _
select property, value from encryption_settings where property='user.subjectTriggerEnabled'
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 | � 	outputEnd � 
 / � get_subject_trigger � X
select property, value from encryption_settings where property='user.subjectTrigger'
 � get_removesubjecttrigger � e
select property, value from encryption_settings where property='user.subjectTriggerRemovePattern'
 � get_portal_url � X
select property, value from encryption_settings where property='user.portal.baseURL'
 get_pdfreply_sender Y
select property, value from encryption_settings where property='user.pdf.replySender'
 



 get_serverkeyword	 V
select property, value from encryption_settings where property='user.serverSecret'
 keys $[Llucee/runtime/type/Collection$Key;	  getCollection � A _VALUE ;	 9 I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �
 / lucee.runtime.tag.FileTag cffile lucee/runtime/tag/FileTag hasBody (Z)V !
" read$ 	setAction& 1
' /opt/hermes/keys/hermes.key) setFile+ 1
, 	hermeskey. setVariable0 1
1
 �
 � 

<!-- DECRYPT KEYWORD -->
5 lucee/runtime/op/Caster7 &(Ljava/lang/Object;)Ljava/lang/String; v9
8: AES< Base64> %lucee/runtime/functions/other/Decrypt@ w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &B
AC 7


<!-- /CFIF #get_serverkeyword.value# is ""  -->
E get_clientkeywordG V
select property, value from encryption_settings where property='user.clientSecret'
I 7


<!-- /CFIF #get_clientkeyword.value# is ""  -->
K get_mailkeywordM Z
select property, value from encryption_settings where property='user.systemMailSecret'
O 5


<!-- /CFIF #get_mailkeyword.value# is ""  -->
Q show_subjectenableS show_subject_triggerU  


W show_removesubjecttriggerY show_portal_url[ show_pdfreply_sender] show_serverkeyword_ show_clientkeyworda show_mailkeywordc Generate Server Keyworde customtransg getrandom_resultsi 	setResultk 1
 �l S
select random_letter as random from captcha_list_all2 order by RAND() limit 103
n inserttransp stResultr &
insert into salt
(salt)
values
('t getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;vw
 /x getIdz $
 /{ lucee/runtime/type/Query} getCurrentrow (I)I�~� getRecordcount� $~� !lucee/runtime/util/NumberIterator� load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� A� isValid (I)Z��
�� current� $
�� go (II)Z��~� #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� writePSQ� �
 /� removeQuery�  A� release &(Llucee/runtime/util/NumberIterator;)V��
�� ')
� gettrans� 2
select salt as customtrans2 from salt where id='� '
� $lucee/runtime/functions/string/LCase�
�� deletetrans� 
delete from salt where id='� Generate Client Keyword� Generate Mail Keyword� Save Settings� #lucee/commons/color/ConstantsDouble� _1 Ljava/lang/Double;��	�� _0��	�� _M� ;	 9� _4��	�� 1� _2��	�� 2� email� (lucee/runtime/functions/decision/IsValid� B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &�
�� _3��	�� 3� "lucee/runtime/functions/string/Len� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)D &�
��@$       (DD)I ��
 �� _8��	�� [a-z]� %lucee/runtime/functions/string/REFind� S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object; &�
�� (Ljava/lang/Object;D)I ��
 �� [0-9]� 4� _5��	�� _9��	�  5 _6�	� _10�	� 6
 update (
update encryption_settings set value=' )' where property='user.pdf.replySender'
 (' where property='user.portal.baseURL'
 (' where property='user.subjectTrigger'
 /' where property='user.subjectTriggerEnabled'
 5' where property='user.subjectTriggerRemovePattern'
 %lucee/runtime/functions/other/Encrypt
C &' where property='user.serverSecret'
 &' where property='user.clientSecret'
 *' where property='user.systemMailSecret'
! Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
# //opt/hermes/scripts/edit_encryption_settings.sh% temp' 0 /opt/hermes/tmp/* java/lang/String, concat &(Ljava/lang/String;)Ljava/lang/String;./
-0 _edit_encryption_settings.sh2 PDFREPLY-SENDER4 ALL6 (lucee/runtime/functions/string/REReplace8
9C 	setOutput; �
< setAddnewline>!
? 
PORTAL-URLA SUBJECT-TRIGGERC SUBJECT-ENABLEE 
    
G TRIGGER-REMOVEI 
    
    
K SERVER-SECRETM CLIENT-SECRETO MAIL-SECRETQ lucee.runtime.tag.ExecuteS 	cfexecuteU lucee/runtime/tag/ExecuteW 
/bin/chmodY
X � +x /opt/hermes/tmp/\ setArguments^ �
X_@N       
setTimeout (D)Vcd
Xe
X �
X �
X �@n       	/dev/nulll setOutputfilen 1
Xo -inputformat noneq deletes _7u�	�v0

<table border="0" cellspacing="0" cellpadding="0" width="635" id="LayoutRegion11" style="background-image: url('file:///C:/Users/dino.edwards/Dropbox/graphics/hermes/background_635_middle.png'); height: 330px;" </readonly>

                            <table border="0" cellspacing="0" cellpadding="0" width="964" id="LayoutRegion11" style="height: 576px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="964"><form name="edit" action="encryption_settings.cfm" method="post">
                                        <table id="Table70" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 272px;">
                                          <tr style="height: 14px;">
                                            <td width="960" id="Cell469">
                                              x <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Trigger encryption by e-mail subject***</span></b></span></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 38px;">
                                            <td id="Cell468">
                                              <table width="483" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td>
                                                    <table id="Table80" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 38px;">
                                                      <tr style="height: 19px;">
                                                        <td width="45" id="Cell470">
                                                          zD<table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                            <tr>
                                                              <td class="TextObject">
                                                                <p style="margin-bottom: 0px;">| true~ o
<input type="radio" checked="checked" name="subjectenable" value="true" style="height: 13px; width: 13px;">
� false� ]
<input type="radio" name="subjectenable" value="true" style="height: 13px; width: 13px;">
�;






&nbsp;</p>
                                                              </td>
                                                            </tr>
                                                          </table>
                                                          &nbsp;</td>
                                                        <td width="438" id="Cell471">
                                                          <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enabled</span></b></p>
                                                        </td>
                                                      </tr>
                                                      <tr style="height: 19px;">
                                                        <td id="Cell472">
                                                          <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                            � �<tr>
                                                              <td class="TextObject">
                                                                <p style="margin-bottom: 0px;">� ^
<input type="radio" name="subjectenable" value="false" style="height: 13px; width: 13px;">
� p
<input type="radio" checked="checked" name="subjectenable" value="false" style="height: 13px; width: 13px;">
�0






&nbsp;</p>
                                                              </td>
                                                            </tr>
                                                          </table>
                                                          &nbsp;</td>
                                                        <td id="Cell473">
                                                          <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Disabled<span style="font-size: 10px; font-weight: normal;"> (Not recommended)</span></span></b></p>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                              </table>
                                            ��</td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell406">
                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Encryption by e-mail subject keyword****</span></b></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 22px;">
                                            <td id="Cell409">
                                              <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">� t
<input type="text" name="subject_trigger" size="30" maxlength="75" style="width: 396px; white-space: pre;" value="� " >
�

                                                    <p style="margin-bottom: 0px;">&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                          <tr style="height: 14px;">
                                            <td id="Cell410">
                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Remove e-mail subject keyword after encryption</span></b></p>
                                            </td>
                                          </tr>
                                          <tr style="height: 38px;">
                                            <td id="Cell408">
                                              <p style="margin-bottom: 0px;">�<span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                <table width="483" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table81" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 38px;">
                                                        <tr style="height: 19px;">
                                                          <td width="45" id="Cell474">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� v
<input type="radio" checked="checked" name="removesubjecttrigger" value="true" style="height: 13px; width: 13px;">
� d
<input type="radio" name="removesubjecttrigger" value="true" style="height: 13px; width: 13px;">
�






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="438" id="Cell475">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Yes <span style="font-size: 10px; font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell476">
                                                            �J<table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� w
<input type="radio" checked="checked" name="removesubjecttrigger" value="false" style="height: 13px; width: 13px;">
� e
<input type="radio" name="removesubjecttrigger" value="false" style="height: 13px; width: 13px;">
�3






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell477">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No<span style="font-size: 10px; font-weight: normal;"> </span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              ��</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1017">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Secure Portal Address<span style="font-weight: normal;"> (Default: https://hermes.domain.tld:9080/web/portal)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1018">
                                                <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">� p
<input type="text" name="portal_url" size="55" maxlength="255" style="width: 396px; white-space: pre;" value="�

                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1019">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PDF Reply Sender E-mail</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1020">
                                                � �<table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">� u
<input type="text" name="pdfreply_sender" size="30" maxlength="255" style="width: 396px; white-space: pre;" value="�

                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 21px;">
                                              <td id="Cell1033">
                                                <table width="483" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table82" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 21px;">
                                                        <tr style="height: 21px;">
                                                          �<td width="55" id="Cell1036">
                                                            <table width="31" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><button type="submit" name="action" value="Generate Server Keyword"><img src="generate_icon.png" alt="Generate Server Keyword"></button&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="428" id="Cell1037">
                                                            <p style="margin-bottom: 0px;">�R<span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128); font-weight: normal;">Click Button to Generate Server Secret Keyword</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1021">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Server Secret Keyword <span style="font-weight: normal;">(Minimum 10 characters, Upper/Lower Case Letters and numbers ONLY)�
</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1023">
                                                <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">� s
<input type="text" name="serverkeyword" size="55" maxlength="255" style="width: 396px; white-space: pre;" value="�

                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 21px;">
                                              <td id="Cell1042">
                                                <table width="483" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table83" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 21px;">
                                                        <tr style="height: 21px;">
                                                          �<td width="55" id="Cell1043">
                                                            <table width="31" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><button type="submit" name="action" value="Generate Client Keyword"><img src="generate_icon.png" alt="Generate Client Keyword"></button&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="428" id="Cell1044">
                                                            <p style="margin-bottom: 0px;">�R<span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128); font-weight: normal;">Click Button to Generate Client Secret Keyword</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1035">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Client Secret Keyword <span style="font-weight: normal;">(Minimum 10 characters, Upper/Lower Case Letters and numbers ONLY)�
</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1022">
                                                <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">� s
<input type="text" name="clientkeyword" size="55" maxlength="255" style="width: 396px; white-space: pre;" value="�

                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 21px;">
                                              <td id="Cell1045">
                                                <table width="483" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table84" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 21px;">
                                                        <tr style="height: 21px;">
                                                          �<td width="55" id="Cell1046">
                                                            <table width="31" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><button type="submit" name="action" value="Generate Mail Keyword"><img src="generate_icon.png" alt="Generate Mail Keyword"></button&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="428" id="Cell1047">
                                                            <p style="margin-bottom: 0px;">�N<span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128); font-weight: normal;">Click Button to Generate Mail Secret Keyword</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1039">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Mail Secret Keyword <span style="font-weight: normal;">(Minimum 10 characters, Upper/Lower Case Letters and numbers ONLY)�
</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1040">
                                                <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">� q
<input type="text" name="mailkeyword" size="55" maxlength="255" style="width: 396px; white-space: pre;" value="�/

                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1041">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1031">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    �<td align="center">
                                                      <table width="350" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><input type="submit" name="action" value="Save Settings" onclick="this.form.submit();"  style="height: 24px; width: 133px;">
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          ��</table>
                                          

</form></td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="964">
                                      <tr valign="top" align="left">
                                        <td width="964" height="11"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="964" id="Text185" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;">�h
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Secure Portal Address cannot be blank</span></i></b></p>
�y
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PDF Reply Sender E-mail must be a valid e-mail address</span></i></b></p>
�l
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PDF Reply Sender E-mail must not be blank</span></i></b></p>
�}
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Encryption by e-mail subject keyword field cannot be blank</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must be a valid e-mail address</span></i></b></p>
�s
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must not be blank</span></i></b></p>
� 7�_
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Settings updated</span></i></b></p>
� 8��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Server Secret Keyword must be at least 10 characters and it must contain ONLY letters and numbers</span></i></b></p>
� 9��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Client Secret Keyword must be at least 10 characters and it must contain ONLY letters and numbers</span></i></b></p>
� 10��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Mail Secret Keyword must be at least 10 characters and it must contain ONLY letters and numbers</span></i></b></p>
�


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
                  <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion33" style="background-image: url('./bottom_988.png'); height: 49px;">
                    <tr align="left" valign="top">
                      <td>
                        <table border="0" cellspacing="0" cellpadding="0" width="981">
                          <tr valign="top" align="left">
                            <td width="981" height="12">�</td>
                          </tr>
                          <tr valign="top" align="left">
                            <td width="981" id="Text496" class="TextObject">
                              <p style="text-align: center; margin-bottom: 0px;">� $lucee/runtime/functions/dateTime/Now� =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &�
�� yyyy� 4lucee/runtime/functions/displayFormatting/DateFormat� S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &�
�  
getversion D
SELECT value from system_settings where parameter = 'version_no'
 getbuild B
SELECT value from system_settings where parameter = 'build_no'
 V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway 
 sessionScope $()Llucee/runtime/type/scope/Session;
 /  lucee/runtime/type/scope/Session � 	 Version:  Build: . Copyright 2011- l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>c
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
   ���� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException#  lucee/runtime/type/UDFProperties% udfs #[Llucee/runtime/type/UDFProperties;'(	 ) setPageSource+ 
 , GET_SERVERKEYWORD. lucee/runtime/type/KeyImpl0 intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;23
14 THESERVERKEYWORD6 	HERMESKEY8 GET_CLIENTKEYWORD: THECLIENTKEYWORD< GET_MAILKEYWORD> THEMAILKEYWORD@ GET_SUBJECTENABLEB subjectenableD SHOW_SUBJECTENABLEF SUBJECTENABLEH GET_SUBJECT_TRIGGERJ subject_triggerL SHOW_SUBJECT_TRIGGERN SUBJECT_TRIGGERP GET_REMOVESUBJECTTRIGGERR removesubjecttriggerT SHOW_REMOVESUBJECTTRIGGERV REMOVESUBJECTTRIGGERX GET_PORTAL_URLZ 
portal_url\ SHOW_PORTAL_URL^ 
PORTAL_URL` GET_PDFREPLY_SENDERb pdfreply_senderd SHOW_PDFREPLY_SENDERf PDFREPLY_SENDERh serverkeywordj SHOW_SERVERKEYWORDl SERVERKEYWORDn clientkeywordp SHOW_CLIENTKEYWORDr CLIENTKEYWORDt mailkeywordv SHOW_MAILKEYWORDx MAILKEYWORDz RANDOM| STRESULT~ GENERATED_KEY� GETTRANS� CUSTOMTRANS2� STEP� ENCRYPTED_SERVERKEYWORD� ENCRYPTED_CLIENTKEYWORD� ENCRYPTED_MAILKEYWORD� CUSTOMTRANS3� TEMP� THEYEAR� EDITION� 
GETVERSION� GETBUILD� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile               ��       �   *     *� 
*� *� � *�&�**+�-�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  ZP b  M
+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+S� 3+U� 3+W+� \� bM>+� \,� .dY:� !� fY� hYj� lW� pr� u� y� z�M>+� |~W,  � �+�� 3+�+� \� b:6+� \� 0dY:� !� fY� hYj� l�� pr� u� y� z�:6+� |~�  � �+�� 3+�+� \� b:6	+� \� 0�Y:
� !� fY� hYj� l�� pr� u� y� z�
:6	+� |~�  	� �+�� 3+ �� �� �� ��� �� � � Q+�� 3+� �� �� � �� �� � � ++�� 3+� 7� �+� �� �� � � E W+�� 3� � +�� 3+� �+� |��� �� �:Ƕ �+� 7� =� � � �� �6� N+� �+ض 3� ����� $:� ߧ :� +� �W� ��� +� �W� �� �� � ￧ :+� |� ��+� |� � :+� ��+� �+�� 3+� �+� |��� �� �:�� �+� 7� =� � � �� �6� N+� �+�� 3� ����� $:� ߧ :� +� �W� ��� +� �W� �� �� � ￧ :+� |� ��+� |� � :+� ��+� �+�� 3+� �+� |��� �� �:�� �+� 7� =� � � �� �6� N+� �+�� 3� ����� $:� ߧ :� +� �W� ��� +� �W� �� �� � ￧ :+� |� ��+� |� � :+� ��+� �+�� 3+� �+� |��� �� �: � �+� 7� =� � � �� �6� O+� �+� 3� ���� $:� ߧ : � +� �W� � �� +� �W� �� �� � ￧ :!+� |� �!�+� |� � :"+� �"�+� �+�� 3+� �+� |��� �� �:##� �#+� 7� =� � � �#� �6$$� O+#$� �+� 3#� ���� $:%#%� ߧ :&$� +� �W#� �&�$� +� �W#� �#� �� � ￧ :'+� |#� �'�+� |#� � :(+� �(�+� �+� 3+� �+� |��� �� �:))
� �)+� 7� =� � � �)� �6**� O+)*� �+� 3)� ���� $:+)+� ߧ :,*� +� �W)� �,�*� +� �W)� �)� �� � ￧ :-+� |)� �-�+� |)� � :.+� �.�+� �+�� 3++� 7*�2� ���� �� � � 8+�� 3+� 7*�2++� 7*�2� ��� E W+�� 3� �+�� 3+� |� ��://�#/%�(/*�-//�2/�3W/�4� � ￧ :0+� |/� �0�+� |/� �+6� 3+� 7*�2+++� 7*�2� ���;+� 7*�2� � �;=?�D� E W+F� 3+�� 3+� �+� |��� �� �:11H� �1+� 7� =� � � �1� �622� O+12� �+J� 31� ���� $:313� ߧ :42� +� �W1� �4�2� +� �W1� �1� �� � ￧ :5+� |1� �5�+� |1� � :6+� �6�+� �+�� 3++� 7*�2� ���� �� � � 8+�� 3+� 7*�2++� 7*�2� ��� E W+�� 3� �+�� 3+� |� ��:77�#7%�(7*�-7/�27�3W7�4� � ￧ :8+� |7� �8�+� |7� �+6� 3+� 7*�2+++� 7*�2� ���;+� 7*�2� � �;=?�D� E W+L� 3+�� 3+� �+� |��� �� �:99N� �9+� 7� =� � � �9� �6::� O+9:� �+P� 39� ���� $:;9;� ߧ :<:� +� �W9� �<�:� +� �W9� �9� �� � ￧ :=+� |9� �=�+� |9� � :>+� �>�+� �+�� 3++� 7*�2� ���� �� � � 9+�� 3+� 7*�2++� 7*�2� ��� E W+�� 3� �+�� 3+� |� ��:??�#?%�(?*�-?/�2?�3W?�4� � ￧ :@+� |?� �@�+� |?� �+6� 3+� 7*�2+++� 7*�2� ���;+� 7*�2� � �;=?�D� E W+R� 3+�� 3+T+� \� b:A6B+� \A� F++� 7*�2� ��Y:C� "� fY� hYj� lT� pr� u� y� z�C:A6B+� |~TA  B� �+�� 3+ �*�2� �� ��� �� � � 3+�� 3+� 7*�	2+� �*�
2� � � E W+�� 3� +�� 3+V+� \� b:D6E+� \D� F++� 7*�2� ��Y:F� "� fY� hYj� lV� pr� u� y� z�F:D6E+� |~VD  E� �+�� 3+ �*�2� �� ��� �� � � 3+�� 3+� 7*�2+� �*�2� � � E W+�� 3� +X� 3+Z+� \� b:G6H+� \G� F++� 7*�2� ��Y:I� "� fY� hYj� lZ� pr� u� y� z�I:G6H+� |~ZG  H� �+�� 3+ �*�2� �� ��� �� � � 3+�� 3+� 7*�2+� �*�2� � � E W+�� 3� +�� 3+\+� \� b:J6K+� \J� F++� 7*�2� ��Y:L� "� fY� hYj� l\� pr� u� y� z�L:J6K+� |~\J  K� �+�� 3+ �*�2� �� ��� �� � � 3+�� 3+� 7*�2+� �*�2� � � E W+�� 3� +�� 3+^+� \� b:M6N+� \M� F++� 7*�2� ��Y:O� "� fY� hYj� l^� pr� u� y� z�O:M6N+� |~^M  N� �+�� 3+ �*�2� �� ��� �� � � 3+�� 3+� 7*�2+� �*�2� � � E W+�� 3� +�� 3+`+� \� b:P6Q+� \P� >+� 7*�2� � Y:R� "� fY� hYj� l`� pr� u� y� z�R:P6Q+� |~`P  Q� �+�� 3+ �*�2� �� ��� �� � � 3+�� 3+� 7*�2+� �*�2� � � E W+�� 3� +�� 3+b+� \� b:S6T+� \S� >+� 7*�2� � Y:U� "� fY� hYj� lb� pr� u� y� z�U:S6T+� |~bS  T� �+�� 3+ �*�2� �� ��� �� � � 3+�� 3+� 7*�2+� �*� 2� � � E W+�� 3� +�� 3+d+� \� b:V6W+� \V� ?+� 7*�2� � Y:X� "� fY� hYj� ld� pr� u� y� z�X:V6W+� |~dV  W� �+�� 3+ �*�!2� �� ��� �� � � 3+�� 3+� 7*�"2+� �*�#2� � � E W+�� 3� +� 3+� 7� �� � f� �� � ��+�� 3+� �+� |��� �� �:YYh� �Y+� 7� =� � � �Yj�mY� �6ZZ� O+YZ� �+o� 3Y� ���� $:[Y[� ߧ :\Z� +� �WY� �\�Z� +� �WY� �Y� �� � ￧ :]+� |Y� �]�+� |Y� � :^+� �^�+� �+�� 3+� �+� |��� �� �:__q� �_+� 7� =� � � �_s�m_� �6``�B+_`� �+u� 3+� �+h�y:b+�|6cbc�� 6db�� � � � �6eeb�� ��:a+� 7b�� ed6hah`��� Dba��c�� � � � � (a��6h+++� 7*�$2� � �;�������� ":ibdc�� W+� 7�� a��i�bdc�� W+� 7�� a��� :j+� �j�+� �+�� 3_� ��� � $:k_k� ߧ :l`� +� �W_� �l�`� +� �W_� �_� �� � ￧ :m+� |_� �m�+� |_� � :n+� �n�+� �+�� 3+� �+� |��� �� �:oo�� �o+� 7� =� � � �o� �6pp� x+op� �+�� 3+++� 7*�%2� *�&2��;��+�� 3o� ���ʧ $:qoq� ߧ :rp� +� �Wo� �r�p� +� �Wo� �o� �� � ￧ :s+� |o� �s�+� |o� � :t+� �t�+� �+�� 3+� 7*�2+++� 7*�'2� *�(2��;��� E W+� 3+� �+� |��� �� �:uu�� �u+� 7� =� � � �u� �6vv� x+uv� �+�� 3+++� 7*�%2� *�&2��;��+�� 3u� ���ʧ $:wuw� ߧ :xv� +� �Wu� �x�v� +� �Wu� �u� �� � ￧ :y+� |u� �y�+� |u� � :z+� �z�+� �+�� 3� +�� 3+� 7� �� � �� �� � ��+�� 3+� �+� |��� �� �:{{h� �{+� 7� =� � � �{j�m{� �6||� O+{|� �+o� 3{� ���� $:}{}� ߧ :~|� +� �W{� �~�|� +� �W{� �{� �� � ￧ :+� |{� ��+� |{� � :�+� ���+� �+�� 3+� �+� |��� �� �:��q� ��+� 7� =� � � ��s�m�� �6���B+��� �+u� 3+� �+h�y:�+�|6����� 6���� � � � �6����� ��:�+� 7��� �d6���`��� D������� � � � � (���6�+++� 7*�$2� � �;�������� ":������ W+� 7�� ���������� W+� 7�� ���� :�+� ���+� �+�� 3�� ��� � $:���� ߧ :��� +� �W�� ����� +� �W�� ��� �� � ￧ :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � ��� �6��� x+��� �+�� 3+++� 7*�%2� *�&2��;��+�� 3�� ���ʧ $:���� ߧ :��� +� �W�� ����� +� �W�� ��� �� � ￧ :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� 7*�2+++� 7*�'2� *�(2��;��� E W+� 3+� �+� |��� �� �:���� ��+� 7� =� � � ��� �6��� x+��� �+�� 3+++� 7*�%2� *�&2��;��+�� 3�� ���ʧ $:���� ߧ :��� +� �W�� ����� +� �W�� ��� �� � ￧ :�+� |�� ���+� |�� � :�+� ���+� �+�� 3� +�� 3+� 7� �� � �� �� � ��+�� 3+� �+� |��� �� �:��h� ��+� 7� =� � � ��j�m�� �6��� O+��� �+o� 3�� ���� $:���� ߧ :��� +� �W�� ����� +� �W�� ��� �� � ￧ :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� �+� |��� �� �:��q� ��+� 7� =� � � ��s�m�� �6���B+��� �+u� 3+� �+h�y:�+�|6����� 6���� � � � �6����� ��:�+� 7��� �d6���`��� D������� � � � � (���6�+++� 7*�$2� � �;�������� ":������ W+� 7�� ���������� W+� 7�� ���� :�+� ���+� �+�� 3�� ��� � $:���� ߧ :��� +� �W�� ����� +� �W�� ��� �� � ￧ :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � ��� �6��� x+��� �+�� 3+++� 7*�%2� *�&2��;��+�� 3�� ���ʧ $:���� ߧ :��� +� �W�� ����� +� �W�� ��� �� � ￧ :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� 7*�"2+++� 7*�'2� *�(2��;��� E W+� 3+� �+� |��� �� �:���� ��+� 7� =� � � ��� �6��� x+��� �+�� 3+++� 7*�%2� *�&2��;��+�� 3�� ���ʧ $:���� ߧ :��� +� �W�� ����� +� �W�� ��� �� � ￧ :�+� |�� ���+� |�� � :�+� ���+� �+�� 3� +�� 3+� 7� �� � �� �� � �"+�� 3+� 7*�2� � �� �� � � &+�� 3+� 7*�)2�Ĺ E W+�� 3� ]+� 7*�2� � �� �� � � <+�� 3+� 7*�)2�ǹ E W+�� 3+� 7�ʲ͹ E W+�� 3� +�� 3+� 7*�)2� � ϸ �� � � �+�� 3+� 7*�2� � �� �� � � &+�� 3+� 7*�)2�ҹ E W+�� 3� ]+� 7*�2� � �� �� � � <+�� 3+� 7*�)2�ǹ E W+�� 3+� 7�ʲĹ E W+�� 3� +�� 3� +�� 3+� 7*�)2� � Ը �� � �4+�� 3+� 7*�2� � �� �� � � �+�� 3+�+� 7*�2� � �ۙ &+�� 3+� 7*�)2�޹ E W+�� 3� ^+�+� 7*�2� � �ۙ � � <+�� 3+� 7*�)2�ǹ E W+�� 3+� 7�ʲҹ E W+�� 3� +�� 3� ]+� 7*�2� � �� �� � � <+�� 3+� 7*�)2�ǹ E W+�� 3+� 7�ʲ޹ E W+�� 3� +�� 3� +�� 3+� 7*�)2� � � �� � �:+�� 3++� 7*�2� � ����� � � � � <+�� 3+� 7*�)2�ǹ E W+�� 3+� 7�ʲ�� E W+�� 3� �+�� 3+�+� 7*�2� � �;����� � � 1+�+� 7*�2� � �;����� � � � � &+�� 3+� 7*�)2�͹ E W+�� 3� 9+�� 3+� 7*�)2�ǹ E W+�� 3+� 7�ʲ�� E W+�� 3+�� 3+�� 3� +�� 3+� 7*�)2� � �� �� � �:+�� 3++� 7*�2� � ����� � � � � <+�� 3+� 7*�)2�ǹ E W+�� 3+� 7�ʲ�� E W+�� 3� �+�� 3+�+� 7*�2� � �;����� � � 1+�+� 7*�2� � �;����� � � � � &+�� 3+� 7*�)2��� E W+�� 3� 9+�� 3+� 7*�)2�ǹ E W+�� 3+� 7�ʲ� E W+�� 3+�� 3+�� 3� +�� 3+� 7*�)2� � � �� � �:+�� 3++� 7*�"2� � ����� � � � � <+�� 3+� 7*�)2�ǹ E W+�� 3+� 7�ʲ�� E W+�� 3� �+�� 3+�+� 7*�"2� � �;����� � � 1+�+� 7*�"2� � �;����� � � � � &+�� 3+� 7*�)2�� E W+�� 3� 9+�� 3+� 7*�)2�ǹ E W+�� 3+� 7�ʲ	� E W+�� 3+�� 3+�� 3� +�� 3+� 7*�)2� � � �� � ��+�� 3+� �+� |��� �� �:��� ��+� 7� =� � � ��� �6��� m+��� �+� 3++� 7*�2� � �;��+� 3�� ���է $:���� ߧ :��� +� �W�� �¿�� +� �W�� ��� �� � ￧ :�+� |�� �ÿ+� |�� � :�+� �Ŀ+� �+�� 3+� �+� |��� �� �:��� ��+� 7� =� � � �Ŷ �6��� m+�ƶ �+� 3++� 7*�2� � �;��+� 3Ŷ ���է $:��Ƕ ߧ :��� +� �WŶ �ȿ�� +� �WŶ �Ŷ �� � ￧ :�+� |Ŷ �ɿ+� |Ŷ � :�+� �ʿ+� �+�� 3+� �+� |��� �� �:��� ��+� 7� =� � � �˶ �6��� m+�̶ �+� 3++� 7*�2� � �;��+� 3˶ ���է $:��Ͷ ߧ :��� +� �W˶ �ο�� +� �W˶ �˶ �� � ￧ :�+� |˶ �Ͽ+� |˶ � :�+� �п+� �+�� 3+� �+� |��� �� �:��� ��+� 7� =� � � �Ѷ �6��� m+�Ҷ �+� 3++� 7*�	2� � �;��+� 3Ѷ ���է $:��Ӷ ߧ :��� +� �WѶ �Կ�� +� �WѶ �Ѷ �� � ￧ :�+� |Ѷ �տ+� |Ѷ � :�+� �ֿ+� �+�� 3+� �+� |��� �� �:��� ��+� 7� =� � � �׶ �6��� m+�ض �+� 3++� 7*�2� � �;��+� 3׶ ���է $:��ٶ ߧ :��� +� �W׶ �ڿ�� +� �W׶ �׶ �� � ￧ :�+� |׶ �ۿ+� |׶ � :�+� �ܿ+� �+�� 3+� |� ��:���#�%�(�*�-�/�2ݶ3Wݶ4� � ￧ :�+� |ݶ �޿+� |ݶ �+�� 3+� 7*�*2++� 7*�2� � �;+� 7*�2� � �;=?�� E W+�� 3+� �+� |��� �� �:��� ��+� 7� =� � � �߶ �6��� m+�� �+� 3++� 7*�*2� � �;��+� 3߶ ���է $:��� ߧ :��� +� �W߶ ���� +� �W߶ �߶ �� � ￧ :�+� |߶ ��+� |߶ � :�+� ��+� �+�� 3+� 7*�+2++� 7*�2� � �;+� 7*�2� � �;=?�� E W+�� 3+� �+� |��� �� �:��� ��+� 7� =� � � �� �6��� m+�� �+� 3++� 7*�+2� � �;��+ � 3� ���է $:��� ߧ :��� +� �W� ���� +� �W� �� �� � ￧ :�+� |� ��+� |� � :�+� ��+� �+�� 3+� 7*�,2++� 7*�"2� � �;+� 7*�2� � �;=?�� E W+�� 3+� �+� |��� �� �:��� ��+� 7� =� � � �� �6��� m+�� �+� 3++� 7*�,2� � �;��+"� 3� ���է $:���� ߧ :��� +� �W� ���� +� �W� �� �� � ￧ :�+� |� ��+� |� � :�+� ��+� �+�� 3+� �+� |��� �� �:��h� ��+� 7� =� � � ��j�m� �6��� O+�� �+$� 3� ���� $:��� ߧ :��� +� �W� ����� +� �W� �� �� � ￧ :�+� |� ���+� |� � :�+� ���+� �+�� 3+� �+� |��� �� �:��q� ��+� 7� =� � � ��s�m�� �6���X+��� �+u� 3+� �+h�y:�+�|6����� 6���� � � � �6����� ��:�+� 7��� �d�6 �� `��� F������� � � � � *����6 +++� 7*�$2� � �;�������� &�:����� W+� 7�� ���������� W+� 7�� ���� �:+� ���+� �+�� 3�� ���� ,�:��� ߧ �:�� +� �W�� ����� +� �W�� ��� �� � ￧ �:+� |�� ���+� |�� � �:+� ���+� �+�� 3+� �+� |��� �� ��:��� ��+� 7� =� � � ��� ��6�� �+��� �+�� 3+++� 7*�%2� *�&2��;��+�� 3�� ���ȧ 2�:	��	� ߧ  �:
�� +� �W�� ��
��� +� �W�� ��� �� � ￧ �:+� |�� ���+� |�� � �:+� ���+� �+�� 3+� 7*�-2++� 7*�'2� *�(2�� E W+�� 3+� �+� |��� �� ��:��� ��+� 7� =� � � ��� ��6�� �+��� �+�� 3+++� 7*�%2� *�&2��;��+�� 3�� ���ȧ 2�:��� ߧ  �:�� +� �W�� ����� +� �W�� ��� �� � ￧ �:+� |�� ���+� |�� � �:+� ���+� �+�� 3+� |� ���:��#�%�(�&�-�(�2��3W��4� � ￧ �:+� |�� ���+� |�� �+�� 3+� |� ���:��#�)�(�++� 7*�-2� � �;�13�1�-�++� 7*�.2� � �;5+� 7*�2� � �;7�:�=��@��3W��4� � ￧ �:+� |�� ���+� |�� �+�� 3+� |� ���:��#�%�(�++� 7*�-2� � �;�13�1�-�(�2��3W��4� � ￧ �:+� |�� ���+� |�� �+�� 3+� |� ���:��#�)�(�++� 7*�-2� � �;�13�1�-�++� 7*�.2� � �;B+� 7*�2� � �;7�:�=��@��3W��4� � ￧ �:+� |�� ���+� |�� �+�� 3+� |� ���:��#�%�(�++� 7*�-2� � �;�13�1�-�(�2��3W��4� � ￧ �:+� |�� ���+� |�� �+�� 3+� |� ���:��#�)�(�++� 7*�-2� � �;�13�1�-�++� 7*�.2� � �;D+� 7*�2� � �;7�:�=��@��3W��4� � ￧ �:+� |�� ���+� |�� �+�� 3+� |� ���:��#�%�(�++� 7*�-2� � �;�13�1�-�(�2��3W��4� � ￧ �: +� |�� �� �+� |�� �+�� 3+� |� ���:!�!�#�!)�(�!++� 7*�-2� � �;�13�1�-�!++� 7*�.2� � �;F+� 7*�	2� � �;7�:�=�!�@�!�3W�!�4� � ￧ �:"+� |�!� ��"�+� |�!� �+H� 3+� |� ���:#�#�#�#%�(�#++� 7*�-2� � �;�13�1�-�#(�2�#�3W�#�4� � ￧ �:$+� |�#� ��$�+� |�#� �+�� 3+� |� ���:%�%�#�%)�(�%++� 7*�-2� � �;�13�1�-�%++� 7*�.2� � �;J+� 7*�2� � �;7�:�=�%�@�%�3W�%�4� � ￧ �:&+� |�%� ��&�+� |�%� �+L� 3+� |� ���:'�'�#�'%�(�'++� 7*�-2� � �;�13�1�-�'(�2�'�3W�'�4� � ￧ �:(+� |�'� ��(�+� |�'� �+�� 3+� |� ���:)�)�#�))�(�)++� 7*�-2� � �;�13�1�-�)++� 7*�.2� � �;N+� 7*�2� � �;7�:�=�)�@�)�3W�)�4� � ￧ �:*+� |�)� ��*�+� |�)� �+H� 3+� |� ���:+�+�#�+%�(�+++� 7*�-2� � �;�13�1�-�+(�2�+�3W�+�4� � ￧ �:,+� |�+� ��,�+� |�+� �+�� 3+� |� ���:-�-�#�-)�(�-++� 7*�-2� � �;�13�1�-�-++� 7*�.2� � �;P+� 7*�2� � �;7�:�=�-�@�-�3W�-�4� � ￧ �:.+� |�-� ��.�+� |�-� �+H� 3+� |� ���:/�/�#�/%�(�/++� 7*�-2� � �;�13�1�-�/(�2�/�3W�/�4� � ￧ �:0+� |�/� ��0�+� |�/� �+�� 3+� |� ���:1�1�#�1)�(�1++� 7*�-2� � �;�13�1�-�1++� 7*�.2� � �;R+� 7*�"2� � �;7�:�=�1�@�1�3W�1�4� � ￧ �:2+� |�1� ��2�+� |�1� �+� 3+� |TV� ��X�:3�3Z�[�3]+� 7*�-2� � �;�13�1�`�3a�f�3�g�64�4� F+�3�4� �+�� 3�3�h��� �:5�4� +� �W�5��4� +� �W�3�i� � ￧ �:6+� |�3� ��6�+� |�3� �+�� 3+� |TV� ��X�:7�7++� 7*�-2� � �;�13�1�[�7j�f�7m�p�7r�`�7�g�68�8� F+�7�8� �+�� 3�7�h��� �:9�8� +� �W�9��8� +� �W�7�i� � ￧ �::+� |�7� ��:�+� |�7� �+�� 3+� |� ���:;�;�#�;t�(�;++� 7*�-2� � �;�13�1�-�;�3W�;�4� � ￧ �:<+� |�;� ��<�+� |�;� �+�� 3+� 7�ʲw� E W+�� 3� +� 3� +y� 3+{� 3+}� 3+� 7*�	2� � � �� � � 1+�� 3+� �+�� 3� �:=+� ��=�+� �+�� 3� S+� 7*�	2� � �� �� � � 1+�� 3+� �+�� 3� �:>+� ��>�+� �+�� 3� +�� 3+�� 3+� 7*�	2� � � �� � � 1+�� 3+� �+�� 3� �:?+� ��?�+� �+�� 3� S+� 7*�	2� � �� �� � � 1+�� 3+� �+�� 3� �:@+� ��@�+� �+�� 3� +�� 3+�� 3+� �+�� 3++� 7*�2� � �;� 3+�� 3� �:A+� ��A�+� �+�� 3+�� 3+� 7*�2� � � �� � � 1+�� 3+� �+�� 3� �:B+� ��B�+� �+�� 3� S+� 7*�2� � �� �� � � 1+�� 3+� �+�� 3� �:C+� ��C�+� �+�� 3� +�� 3+�� 3+� 7*�2� � �� �� � � 1+�� 3+� �+�� 3� �:D+� ��D�+� �+�� 3� S+� 7*�2� � �� �� � � 1+�� 3+� �+�� 3� �:E+� ��E�+� �+�� 3� +�� 3+�� 3+� �+�� 3++� 7*�2� � �;� 3+�� 3� �:F+� ��F�+� �+�� 3+�� 3+� �+�� 3++� 7*�2� � �;� 3+�� 3� �:G+� ��G�+� �+�� 3+�� 3+�� 3+�� 3+� �+�� 3++� 7*�2� � �;� 3+�� 3� �:H+� ��H�+� �+�� 3+�� 3+�� 3+ö 3+� �+Ŷ 3++� 7*�2� � �;� 3+�� 3� �:I+� ��I�+� �+Ƕ 3+ɶ 3+˶ 3+Ͷ 3+� �+϶ 3++� 7*�"2� � �;� 3+�� 3� �:J+� ��J�+� �+Ѷ 3+Ӷ 3+ն 3+� 7�ʹ � ϸ �� � � 1+�� 3+� �+׶ 3� �:K+� ��K�+� �+�� 3� +�� 3+� 7�ʹ � Ը �� � � 1+�� 3+� �+ٶ 3� �:L+� ��L�+� �+�� 3� +�� 3+� 7�ʹ � � �� � � 1+�� 3+� �+۶ 3� �:M+� ��M�+� �+�� 3� +�� 3+� 7�ʹ � �� �� � � 1+�� 3+� �+ݶ 3� �:N+� ��N�+� �+�� 3� +�� 3+� 7�ʹ � � �� � � 1+�� 3+� �+߶ 3� �:O+� ��O�+� �+�� 3� +�� 3+� 7�ʹ � � �� � � 1+�� 3+� �+� 3� �:P+� ��P�+� �+�� 3� +�� 3+� 7�ʹ � � �� � � 1+�� 3+� �+� 3� �:Q+� ��Q�+� �+�� 3� +�� 3+� 7�ʹ � � �� � � 1+�� 3+� �+� 3� �:R+� ��R�+� �+�� 3� +�� 3+� 7�ʹ � � �� � � 1+�� 3+� �+�� 3� �:S+� ��S�+� �+�� 3� +�� 3+� 7�ʹ � � �� � � 1+�� 3+� �+� 3� �:T+� ��T�+� �+�� 3� +� 3+�� 3+� 7*�/2++����� E W+�� 3+� �+� |��� �� ��:U�U� ��U+� 7� =� � � ��U� ��6V�V� g+�U�V� �+� 3�U� ���� 2�:W�U�W� ߧ  �:X�V� +� �W�U� ��X��V� +� �W�U� ��U� �� � ￧ �:Y+� |�U� ��Y�+� |�U� � �:Z+� ��Z�+� �+�� 3+� �+� |��� �� ��:[�[� ��[+� 7� =� � � ��[� ��6\�\� g+�[�\� �+	� 3�[� ���� 2�:]�[�]� ߧ  �:^�\� +� �W�[� ��^��\� +� �W�[� ��[� �� � ￧ �:_+� |�[� ��_�+� |�[� � �:`+� ��`�+� �+�� 3+� �+� 3++�*�02� �;� 3+� 3+++� 7*�12� ���;� 3+� 3+++� 7*�22� ���;� 3+� 3++� 7*�/2� � �;� 3+� 3� �:a+� ��a�+� �+� 3� �'* )36  �ll  ���  ��� )���  �//  �II  ��� )���  q��  `  bru )b~�  4��  #��  '7: )'CF  �||  ���  ��  )�	  �BB  �\\  �  ��� )���  �!!  �;;  ���  	�	�	� )	�	�	�  	}
 
   	l

  
�
�
�  3CF )3OR  ���  ���  Z��  ��    )   �HH  �bb  ��� )��   �66  yPP  � )�%(  �^^  �xx   )"  �XX  �rr  *zz  ���  ��� )���  �  �22  ��� )���  Z  I    ��� )���  �..  qHH  ��� )���  �((  �BB  �JJ  ���  ��� )���  j��  Y  X�� )X��  *��  ��  ��� )���  R��  A    '�'�'� )'�'�'�  '�(%(%  's(?(?  (�(�(� )(�(�(�  (g))  (V)")"  )x)�)� ))x)�)�  )J)�)�  )9**  *[*�*� )*[*�*�  *-*�*�  **�*�  +>+l+o )+>+x+{  ++�+�  *�+�+�  +�,&,&  ,�,�,� ),�--	  ,�-?-?  ,�-Y-Y  -�.#.& )-�./.2  -�.h.h  -�.�.�  //L/O )//X/[  .�/�/�  .�/�/�  0	00 )0	0%0(  /�0^0^  /�0x0x  121�1�  0�1�1�  0�1�1� )0�1�1�  0�2424  0�2R2R  2�2�2� )2�3	3  2�3P3P  2m3r3r  44I4L )44[4^  3�4�4�  3�4�4�  4�5151  5k5�5�  676�6�  6�7`7`  7�7�7�  818�8�  8�9Z9Z  9�:&:&  :a:�:�  :�;�;�  ;�<"<"  <\<�<�  =)=�=�  =�>R>R  >�>�>�  ?$?�?�  @J@^@^  ?�@�@�  A1AEAE  @�A{A{  A�BB  B�B�B�  B�B�B�  C?CICI  C�C�C�  C�C�C�  D8DBDB  D�D�D�  D�D�D�  E6E@E@  ElE�E�  E�E�E�  FF8F8  FiF�F�  F�F�F�  G8GBGB  G�G�G�  G�G�G�  H.H8H8  H�H�H�  H�H�H�  I$I.I.  IvI�I�  I�I�I�  JJ$J$  J�J�J� )J�J�J�  J�K,K,  JrKNKN  K�K�K� )K�K�K�  K|L#L#  KiLELE  L`L�L�   �         * +  �  �           @  A ! k $ � - � 0 � 9 � < � ? � E � � � � �a �� �� �� �� � �� �� �Y �� � �f �� �+ ���l��	�47����Kx��	!	"	_%	b&	e(	�*
*,
W.
�0
�2
�4
�5@8C9F<�=�>?B�C�D�E�HeI�J�K�N7O_P�Q�T	U1VXWaY�Z�["\+^�_�`�a�dhe�f�g�k�l7n�pt�urw�x�y`{�����������������B�����0�j�����X�a�����R������\��� �:����� (� 1� U� |� �� �� �� �� ��!!�!H�!b�!��!��!��!��!��!��"�"=�"W�"��"��"��"��"��"��#�#�#'�#O�#��#��#��#��$�$8�$A�$[�$q�$w�$}�$��$��$��$��%�%�%}�%��%��%��%��%��%��%��&�&A�&[�&q�&z�&��&��&��'�'/�'5 ';'D'l'�'�(O(�	(�
)2)|)�**_*}*�+B+`+�,@,�,�,�-i -�"-�#.$.�&.�(/")/@*/�,0.0�00�41�52f72�82�93�;3�=4>4;?4�B5SE5�F5�G6E6G6I6�K6�L7
M7K7M7�O8Q8GR8mS8�Q8�S8�U9|W9�X9�Y:EW:EY:I[:�];^;4_;�];�_;�b<Dd<re<�f=d=f=h=�j=�k=�l>qj>ql>un?p?:q?`r?�p?�r?�v?�w@%x@My@�{@�|A}A~A4A��A��A��B'�B'�B*�B@�BJ�BT�BW�B^�Bb�Be�B��B��B��B��B��B��B��B��C	�C�C�C�C8�CC�CZ�C]�C��C��C��C��C��C��C��C��D�D�DD1D<DS	DV
D�D�D�D�D�D� D�!D�#D�$D�%E&E'E/(E:)EQ*ET+E^2EhJEpKE�LE�NE�[E�\E�]E�^E�_E�aE�nE�oE�xF�F�F2�FM�FP�FT�FW�Fe�Fm�F��F��F��F��F��F��F��F��F��G�G�GG1G<GSGVG_G�G�G�G�G�G�G�G� G�!H#H'$H2%HI&HL'HU)Hy*H�+H�,H�-H�0H�1H�2H�3H�4H�6I7I(8I?9IB:IK<Io=Iz>I�?I�@I�BI�CI�DI�EI�FI�HJIJJJ5KJ8LJBOJLiJkjJ�lKbmK�oLYpLdqMr�     )  �        �    �     )   �         �    �     ) !" �        �    �    $    �      *3� �Y/�5SY7�5SY9�5SY;�5SY=�5SY?�5SYA�5SYC�5SYE�5SY	G�5SY
I�5SYK�5SYM�5SYO�5SYQ�5SYS�5SYU�5SYW�5SYY�5SY[�5SY]�5SY_�5SYa�5SYc�5SYe�5SYg�5SYi�5SYk�5SYm�5SYo�5SYq�5SYs�5SY u�5SY!w�5SY"y�5SY#{�5SY$}�5SY%�5SY&��5SY'��5SY(��5SY)��5SY*��5SY+��5SY,��5SY-��5SY.��5SY/��5SY0��5SY1��5SY2��5S��     �    