����   2� spam_settings_cfm$cf  lucee/runtime/PageImpl  /admin/spam_settings.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength     �� getCompileTime  n��! getHash ()I��M call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Lspam_settings_cfm$cf;
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Spam Settings</title>
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
              <td height="843" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 843px;">
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
                                 P<td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Antispam Settings</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/antispam-settings/')"> R�<img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="10" height="6"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="680"></td>
                          <td width="959"> T m V &lucee/runtime/config/NullSupportHelper X NULL Z '
 Y [ -lucee/runtime/interpreter/VariableInterpreter ] getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; _ `
 ^ a 0 c %lucee/runtime/exp/ExpressionException e java/lang/StringBuilder g The required parameter [ i  1
 h k append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; m n
 h o ] was not provided. q -(Ljava/lang/String;)Ljava/lang/StringBuilder; m s
 h t toString ()Ljava/lang/String; v w
 h x
 f k lucee/runtime/PageContextImpl { any }�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 | �  
 � m2 � step � 


 � lucee.runtime.tag.FileTag � cffile � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 | � lucee/runtime/tag/FileTag � hasBody (Z)V � �
 � � read � 	setAction � 1
 � � /opt/hermes/keys/hermes.key � setFile � 1
 � � authkey � setVariable � 1
 � � 
doStartTag � $
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 | � 
 � algo � AES � encoding � Base64 � 

 � action � view �@       _action � ;	 9 � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � keys $[Llucee/runtime/type/Collection$Key; � �	  � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � ;	 9 � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � lucee/runtime/tag/Query � get_use_bayes � setName � 1
 � � A � setDatasource (Ljava/lang/Object;)V � �
 � 
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V
 / [
select parameter, value from spam_settings where parameter='use_bayes' and active = '1'
 doAfterBody	 $
 �
 doCatch (Ljava/lang/Throwable;)V
 � popBody ()Ljavax/servlet/jsp/JspWriter;
 / 	doFinally 
 �
 � � 	outputEnd 
 / get_bayes_auto_learn b
select parameter, value from spam_settings where parameter='bayes_auto_learn' and active = '1'
 &get_bayes_auto_learn_threshold_nonspam t
select parameter, value from spam_settings where parameter='bayes_auto_learn_threshold_nonspam' and active = '1'
! #get_bayes_auto_learn_threshold_spam# q
select parameter, value from spam_settings where parameter='bayes_auto_learn_threshold_spam' and active = '1'
% get_use_dcc' Y
select parameter, value from spam_settings where parameter='use_dcc' and active = '1'
) get_use_razor2+ \
select parameter, value from spam_settings where parameter='use_razor2' and active = '1'
- get_use_pyzor/ [
select parameter, value from spam_settings where parameter='use_pyzor' and active = '1'
1 get_user_portal3 ]
select parameter, value from spam_settings where parameter='user_portal' and active = '1'
5 get_sa_spam_subject_tag7 e
select parameter, value from spam_settings where parameter='sa_spam_subject_tag' and active = '1'
9 get_final_virus_destiny; e
select parameter, value from spam_settings where parameter='final_virus_destiny' and active = '1'
= get_final_banned_destiny? f
select parameter, value from spam_settings where parameter='final_banned_destiny' and active = '1'
A get_final_spam_destinyC d
select parameter, value from spam_settings where parameter='final_spam_destiny' and active = '1'
E get_final_bad_header_destinyG j
select parameter, value from spam_settings where parameter='final_bad_header_destiny' and active = '1'
I 	use_bayesK getCollectionM � AN _VALUEP ;	 9Q I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �S
 /T bayes_auto_learnV "bayes_auto_learn_threshold_nonspamX bayes_auto_learn_threshold_spamZ use_dcc\ 
use_razor2^ 	use_pyzor` show_user_portalb show_sa_spam_subject_tagd show_final_virus_destinyf show_final_banned_destinyh show_final_spam_destinyj show_final_bad_header_destinyl editn '(Ljava/lang/Object;Ljava/lang/String;)I �p
 �q get_mysql_username_hermess X
select parameter, value from system_settings where parameter='mysql_username_hermes'
u  w #lucee/commons/color/ConstantsDoubley _0 Ljava/lang/Double;{|	z} _M ;	 9� _11�|	z� _1�|	z� 1� get_mysql_password_hermes� X
select parameter, value from system_settings where parameter='mysql_password_hermes'
� _12�|	z� _2�|	z� 2� _3�|	z� 3� _4�|	z� 4� float� (lucee/runtime/functions/decision/IsValid� B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &�
�� (Ljava/lang/Object;D)I ��
 ��@�8      _5�|	z� K

<!-- /CFIF for #bayes_auto_learn_threshold_spam# GT 0 and LTE 999 -->
� I

<!-- /CFIF for IsValid("float", bayes_auto_learn_threshold_spam)-->
� D

<!-- /CFIF for #bayes_auto_learn_threshold_spam# is not "" -->
� 

<!-- /CFIF for step 4 -->
� 5���8      _6�|	z� _8�|	z� H

<!-- /CFIF for auto_learn_threshold_nonspam# LT 0 and GTE -999 -->
� _10�|	z� L

<!-- /CFIF for IsValid("float", bayes_auto_learn_threshold_nonspam)-->
� _7�|	z� G

<!-- /CFIF for #bayes_auto_learn_threshold_nonspam# is not "" -->
� 

<!-- /CFIF for step 5 -->
� 6� update_user_portal� "
update spam_settings set value='� lucee/runtime/op/Caster� &(Ljava/lang/Object;)Ljava/lang/String; v�
�� writePSQ� �
 /� .', applied='2' where parameter='user_portal'
� update_sa_spam_subject_tag� 6', applied='2' where parameter='sa_spam_subject_tag'
� update_final_virus_destiny� 6', applied='2' where parameter='final_virus_destiny'
� update_final_banned_destiny� 7', applied='2' where parameter='final_banned_destiny'
� update_final_spam_destiny� 5', applied='2' where parameter='final_spam_destiny'
� update_final_bad_header_destiny� ;', applied='2' where parameter='final_bad_header_destiny'
� update_use_bayes� ,', applied='2' where parameter='use_bayes'
� update_bayes_auto_learn� 3', applied='2' where parameter='bayes_auto_learn'
� update_use_dcc� *', applied='2' where parameter='use_dcc'
� update_use_razor2� -', applied='2' where parameter='use_razor2'
 update_use_pyzor ,', applied='2' where parameter='use_pyzor'
 _27|	z 

<!-- /cfif for step 6 -->

 

<!-- /cfif for action -->


                            <table border="0" cellspacing="0" cellpadding="0" width="959" id="LayoutRegion11" style="height: 680px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="spam_settings.cfm" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0" width="959">
                                      <tr valign="top" align="left">
                                        <td width="959" id="Text185" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;">
d
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the User Portal Address cannot be empty</span></i></b></p>
u
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Spam Message Modified Subject String cannot be empty</span></i></b></p>
�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Spam Threshold Score String cannot be empty</span></i></b></p>
�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Spam Threshold Score String must be greater than 0 and less than or equal to 999</span></i></b></p>
�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Spam Threshold Score String must be a valid integer</span></i></b></p>
 7�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Non-Spam Threshold Score String cannot be empty</span></i></b></p>
 8�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Non-Spam Threshold Score String must be less than 0 and greater than or equal ot -999</span></i></b></p>
  10"�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Database Auto Learn Non-Spam Threshold Score String must be an integer</span></i></b></p>
$ 11&
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The system is not able to save your settings because the Hermes MySQL Database Username is not defined. Please navigate to <b>System --> System Settings</b> and specify a username for the Hermes MySQL Database </span></i></b></p>
( 12*
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The system is not able to save your settings because the Hermes MySQL Database Password is not defined. Please navigate to <b>System --> System Settings</b> and specify a password for the Hermes MySQL Database </span></i></b></p>
, 13.2
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The system is not able to apply your settings because the Hermes MySQL Database credentials are not defined or are incorrect. Please navigate to <b>System --> System Settings</b> and specify the correct credentials for the Hermes MySQL Database </span></i></b></p>
0 



2 274�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Settings Saved!! You MUST click the Apply Settings button in order for your changes to take effect</span></i></b></p>
6f&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="2"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="959">
                                          <table id="Table160" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 640px;">
                                            <tr style="height: 14px;">
                                              <td width="959" id="Cell1142">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>User Portal Address </b><span style="color: rgb(51,51,51); font-weight: normal;">(Default: https://hermes.domain.tld:9080/users)8</span></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1141">
                                                <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">: q
<input type="text" name="user_portal" size="50" maxlength="255" style="width: 396px; white-space: pre;" value="< " >
>

                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell889">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Filter Uses Distributed Checksum Clearninghouse (DCC)</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 38px;">
                                              <td id="Cell890">
                                                @,<p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table180" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1120">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    B <p style="margin-bottom: 0px;">D g
<input type="radio" name="use_dcc" value="1" checked="checked" style="height: 19px; width: 19px;"/>
F U
<input type="radio" name="use_dcc" value="1" style="height: 19px; width: 19px;"/>
HP


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1121">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1122">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                J �<tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">L g
<input type="radio" name="use_dcc" value="0" checked="checked" style="height: 19px; width: 19px;"/>
N U
<input type="radio" name="use_dcc" value="0" style="height: 19px; width: 19px;"/>
P 

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1123">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  </b></td>
                                              R6</tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1091">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Filter Uses Vipul&#8217;s Razor v2</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1092">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table181" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          T<tr style="height: 19px;">
                                                            <td width="58" id="Cell1124">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">V j
<input type="radio" name="use_razor2" value="1" checked="checked" style="height: 19px; width: 19px;"/>
X X
<input type="radio" name="use_razor2" value="1" style="height: 19px; width: 19px;"/>
ZP


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1125">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1126">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                \ j
<input type="radio" name="use_razor2" value="0" checked="checked" style="height: 19px; width: 19px;"/>
^ X
<input type="radio" name="use_razor2" value="0" style="height: 19px; width: 19px;"/>
`/

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1127">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              bH<tr style="height: 14px;">
                                                <td id="Cell1143">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Filter Uses Pyzor</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1144">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table182" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            d�<td width="58" id="Cell1128">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">f i
<input type="radio" name="use_pyzor" value="1" checked="checked" style="height: 19px; width: 19px;"/>
h W
<input type="radio" name="use_pyzor" value="1" style="height: 19px; width: 19px;"/>
jN

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1129">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1130">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                l i
<input type="radio" name="use_pyzor" value="0" checked="checked" style="height: 19px; width: 19px;"/>
n W
<input type="radio" name="use_pyzor" value="0" style="height: 19px; width: 19px;"/>
p1


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1131">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              r8<tr style="height: 14px;">
                                                <td id="Cell1105">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Message Modified Subject String</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 22px;">
                                                <td id="Cell1099">
                                                  <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td class="TextObject">t x
<input type="text" name="sa_spam_subject_tag" size="50" maxlength="50" style="width: 396px; white-space: pre;" value="vc

                                                        <p style="margin-bottom: 0px;">&nbsp;</p>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1100">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Virus Messages Action to take</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1109">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    x<tr>
                                                      <td>
                                                        <table id="Table170" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1060">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">z 	D_DISCARD| {
<input type="radio" name="final_virus_destiny" value="D_DISCARD" checked="checked" style="height: 19px; width: 19px;"/>
~ i
<input type="radio" name="final_virus_destiny" value="D_DISCARD" style="height: 19px; width: 19px;"/>
�X


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1061">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine Only <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1062">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                � D_BOUNCE� z
<input type="radio" name="final_virus_destiny" value="D_BOUNCE" checked="checked" style="height: 19px; width: 19px;"/>
� h
<input type="radio" name="final_virus_destiny" value="D_BOUNCE" style="height: 19px; width: 19px;"/>
�


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1063">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine &amp; Send DSN to Sender</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              �2</tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1110">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Banned File Messages Action to take</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1111">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table174" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          �<tr style="height: 19px;">
                                                            <td width="58" id="Cell1078">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">� |
<input type="radio" name="final_banned_destiny" value="D_DISCARD" checked="checked" style="height: 19px; width: 19px;"/>
� j
<input type="radio" name="final_banned_destiny" value="D_DISCARD" style="height: 19px; width: 19px;"/>
�X


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1079">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine Only <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1080">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                � {
<input type="radio" name="final_banned_destiny" value="D_BOUNCE" checked="checked" style="height: 19px; width: 19px;"/>
� i
<input type="radio" name="final_banned_destiny" value="D_BOUNCE" style="height: 19px; width: 19px;"/>
�


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1081">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine &amp; Send DSN to Sender</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              �*</tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell891">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Spam Messages Action to take</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1047">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table175" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          �<tr style="height: 19px;">
                                                            <td width="58" id="Cell1082">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">� z
<input type="radio" name="final_spam_destiny" value="D_DISCARD" checked="checked" style="height: 19px; width: 19px;"/>
� h
<input type="radio" name="final_spam_destiny" value="D_DISCARD" style="height: 19px; width: 19px;"/>
�X


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1083">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine Only <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1084">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                � y
<input type="radio" name="final_spam_destiny" value="D_BOUNCE" checked="checked" style="height: 19px; width: 19px;"/>
� g
<input type="radio" name="final_spam_destiny" value="D_BOUNCE" style="height: 19px; width: 19px;"/>
�


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1085">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine &amp; Send DSN to Sender</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              �</tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1046">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;">Bad-Header Messages Action to take</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell892">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                    <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        ��<td>
                                                          <table id="Table176" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                            <tr style="height: 19px;">
                                                              <td width="58" id="Cell1086">
                                                                <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                  <tr>
                                                                    <td class="TextObject">
                                                                      <p style="margin-bottom: 0px;">� �
<input type="radio" name="final_bad_header_destiny" value="D_DISCARD" checked="checked" style="height: 19px; width: 19px;"/>
� n
<input type="radio" name="final_bad_header_destiny" value="D_DISCARD" style="height: 19px; width: 19px;"/>
�p


&nbsp;</p>
                                                                    </td>
                                                                  </tr>
                                                                </table>
                                                                &nbsp;</td>
                                                              <td width="429" id="Cell1087">
                                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine Only <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                              </td>
                                                            </tr>
                                                            <tr style="height: 19px;">
                                                              <td id="Cell1088">
                                                                <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                  � �<tr>
                                                                    <td class="TextObject">
                                                                      <p style="margin-bottom: 0px;">� 
<input type="radio" name="final_bad_header_destiny" value="D_BOUNCE" checked="checked" style="height: 19px; width: 19px;"/>
� m
<input type="radio" name="final_bad_header_destiny" value="D_BOUNCE" style="height: 19px; width: 19px;"/>
� 


&nbsp;</p>
                                                                    </td>
                                                                  </tr>
                                                                </table>
                                                                &nbsp;</td>
                                                              <td id="Cell1089">
                                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Quarantine &amp; Send DSN to Sender</span></b></p>
                                                              </td>
                                                            </tr>
                                                          </table>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    </�/b></td>
                                                </tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell911">
                                                    <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><span style="font-size: 12px;"></span><b><span style="font-size: 12px;">Bayes Database <span style="font-size: 10px; font-weight: normal;">(<b><span style="font-size: 12px; color: rgb(255,0,0);">NOTE:</span></b> <span style="font-size: 12px;">Modifying will reset ALL Spam Filter Tests to their DEFAULT values thus erasing any custom values you may have previously set )</span></span></span></b></span></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 38px;">
                                                  <td id="Cell912">
                                                    �T<p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table178" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1112">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        � i
<input type="radio" name="use_bayes" value="1" checked="checked" style="height: 19px; width: 19px;"/>
� W
<input type="radio" name="use_bayes" value="1" style="height: 19px; width: 19px;"/>
��


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1113">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1114">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    � �<tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� i
<input type="radio" name="use_bayes" value="0" checked="checked" style="height: 19px; width: 19px;"/>
� W
<input type="radio" name="use_bayes" value="0" style="height: 19px; width: 19px;"/>
�


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1115">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      </b>�@</td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1014">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Bayes Database Auto Learn </b>(Bayes Database must be Enabled, otherwise the setting below will have no effect)</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1058">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            ��<table id="Table179" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1116">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� p
<input type="radio" name="bayes_auto_learn" value="1" checked="checked" style="height: 19px; width: 19px;"/>
� ^
<input type="radio" name="bayes_auto_learn" value="1" style="height: 19px; width: 19px;"/>
��


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1117">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1118">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    � p
<input type="radio" name="bayes_auto_learn" value="0" checked="checked" style="height: 19px; width: 19px;"/>
� ^
<input type="radio" name="bayes_auto_learn" value="0" style="height: 19px; width: 19px;"/>
�4


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1119">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  ��</tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1146">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Bayes Database Auto Learn Spam Threshold Score </b>(Bayes Database Auto Learn must be Enabled, otherwise the setting below will have no effect)</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 22px;">
                                                    <td id="Cell1147">
                                                      <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">� �
<input type="text" name="bayes_auto_learn_threshold_spam" size="50" maxlength="50" style="width: 396px; white-space: pre;" value="�"

                                                            <p style="margin-bottom: 0px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1148">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Bayes Database Auto Learn Non-Spam Threshold Score </b>(Bayes Database Auto Learn must be Enabled, otherwise the setting below will have no effect)</span></p>
                                                    </td>
                                                  </tr>
                                                  �v<tr style="height: 22px;">
                                                    <td id="Cell1149">
                                                      <table width="404" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">� �
<input type="text" name="bayes_auto_learn_threshold_nonspam" size="50" maxlength="50" style="width: 396px; white-space: pre;" value="�O

                                                            <p style="margin-bottom: 0px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1150">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1015">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        �3<tr>
                                                          <td align="center">
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
                                                      �9</table>
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
                            <table border="0" cellspacing="0" cellpadding="0" width="967">
                              <tr valign="top" align="left">
                                <td width="10" height="1"></td>
                                <td></td>
                                <td width="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                ��<td height="30"></td>
                                <td colspan="2" valign="middle" width="957"><hr id="HRRule5" width="957" size="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="3" height="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="46"></td>
                                <td width="955">� show_action2�  

� apply� lucee.runtime.tag.Location� 
cflocation� lucee/runtime/tag/Location� 	error.cfm� setUrl  1
� setAddtoken �
�
� �
� � %lucee/runtime/functions/other/Decrypt w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &

	 customtrans getrandom_results 	setResult 1
 � Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
 inserttrans stResult &
insert into salt
(salt)
values
(' getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;
 / getId  $
 /! lucee/runtime/type/Query# getCurrentrow (I)I%&$' getRecordcount) $$* !lucee/runtime/util/NumberIterator, load '(II)Llucee/runtime/util/NumberIterator;./
-0 addQuery (Llucee/runtime/type/Query;)V23 A4 isValid (I)Z67
-8 current: $
-; go (II)Z=>$? #lucee/runtime/functions/string/TrimA A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &C
BD removeQueryF  AG release &(Llucee/runtime/util/NumberIterator;)VIJ
-K ')
M gettransO 2
select salt as customtrans2 from salt where id='Q '
S deletetransU 
delete from salt where id='W %/opt/hermes/scripts/validate_mysql.shY validatemysql[ 0 /opt/hermes/tmp/validate_mysql_^ java/lang/String` concat &(Ljava/lang/String;)Ljava/lang/String;bc
ad 	MYSQLUSERf ALLh (lucee/runtime/functions/string/REReplacej
k 	setOutputm �
 �n 	 
    
p 	MYSQLPASSr  


t lucee.runtime.tag.Executev 	cfexecutex lucee/runtime/tag/Executez 
/bin/chmod|
{ � "+x /opt/hermes/tmp/validate_mysql_ setArguments� �
{�@N       
setTimeout (D)V��
{�
{ �
{

{ � getCatch #()Llucee/runtime/exp/PageException;��
 /�@n       mysqlvalidate�
{ � 





� isAbort (Ljava/lang/Throwable;)Z��
 �� toPageException 8(Ljava/lang/Throwable;)Llucee/runtime/exp/PageException;��
�� setCatch &(Llucee/runtime/exp/PageException;ZZ)V��
 /� _CFCATCH� ;	 9� _DETAIL� ;	 9� !ERROR 1045 (28000): Access denied� ct '(Ljava/lang/Object;Ljava/lang/Object;)Z��
 �� delete� #

<!-- /CFIF cfcatch.detail -->
� $(Llucee/runtime/exp/PageException;)V��
 /� 'lucee/runtime/functions/file/FileExists� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &�
�� _16�|	z� get_previous_use_bayes� S
select parameter, value from spam_settings where parameter='previous_use_bayes'
� get_user_portal_spam_training� k
select parameter, value from spam_settings where parameter='user_portal_spam_training' and active = '1'
� server_name� _
select * from parameters2 where parameter='server_name' and module='network' and active='1'
� server_domain� a
select * from parameters2 where parameter='server_domain' and module='network' and active='1'
� &lucee/runtime/functions/string/Compare� B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)D &�
�� toRef (D)Ljava/lang/Double;��
�� -1� getspamtests� D
select * from spam_settings where spamfilter='1' order by id asc
� default� J
select default_bayes_network as theDefault from spam_settings where id='� _ID� ;	 9� B ', active = '2' where id='� D
select default_network as theDefault from spam_settings where id='� update_previous_bayes� *' where parameter = 'previous_use_bayes'
� %/opt/hermes/conf_files/50-user.HERMES� user� /opt/hermes/tmp/� 50-user� _USER� ;	 9� SERVER-NAME� SERVER-DOMAIN� 
    
� sa-spam-subject-tag� final-virus-destiny final-banned-destiny final-spam-destiny final-bad-header-destiny 


    
    
	 HERMES-USERNAME HERMES-PASSWORD 

    




 getrules K
SELECT distinct(rule_id) as RuleID, rule_name FROM file_rule_components
 getrulecomponents @
select file_id, type from file_rule_components where rule_id=' ' order by priority asc
 _amavis_rule_ ' ' => new_RE( RULES ), setAddnewline! �
 �" _LAST$ ;	 9% #lucee/runtime/util/VariableUtilImpl' recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;)*
(+ _CURRENTROW- ;	 9. '(Ljava/lang/Object;Ljava/lang/Object;)I �0
 �1 _TYPE3 ;	 94 ban6 getfile8 -
select ban as theType from files where id=': m _amavis_rule_components_= allow? /
select allow as theType from files where id='A ,C theComponentsE theRuleG RULESI@$       "lucee/runtime/functions/string/ChrM 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &O
NP _amavis_ruleR theRulesT FILE-RULES-GO-HEREV 






X &/opt/hermes/conf_files/local.cf.HERMESZ local\ local.cf.HERMES^ localGet (Z)Ljava/lang/Object;`a
 /b USE-DCCd 	use_dcc 1f 	use_dcc 0h 	USE-PYZORj use_pyzor 1l use_pyzor 0n 
USE-RAZOR2p use_razor2 1r use_razor2 0t 	USE-BAYESv use_bayes 1x use_bayes 0z BAYES-AUTO-LEARN| bayes_auto_learn 1~ bayes_auto_learn 0� BAYESAUTOLEARN-SPAM�  bayes_auto_learn_threshold_spam � BAYESAUTOLEARN-HAM� #bayes_auto_learn_threshold_nonspam � gettests� \
SELECT * FROM spam_settings where spamfilter='1' and active = '1' order by parameter asc
� 	_sa_tests� score �  � theTests� #CUSTOM-TESTS� 





� getmessagerules� 6
SELECT * FROM message_rules order by rule_name asc
� _message_rules� header� 	describe �  =� #CUSTOM-MESSAGE-RULES� 







� 	_apply.sh� K/bin/cp /etc/amavis/conf.d/50-user /etc/amavis/conf.d/50-user.HERMES.BACKUP� APPEND� K/bin/cp /etc/spamassassin/local.cf /etc/spamassassin/local.cf.HERMES.BACKUP� /bin/mv /opt/hermes/tmp/� "50-user /etc/amavis/conf.d/50-user� *local.cf.HERMES /etc/spamassassin/local.cf� /etc/init.d/amavis restart� /etc/init.d/postfix restart� +x /opt/hermes/tmp/� 	/dev/null� setOutputfile� 1
{� -inputformat none�  

    
� updateparams� <
update spam_settings set applied='1' where applied = '2'
�F


                                  <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion13" style="height: 46px;">
                                    <tr align="left" valign="top">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="955">
                                              <form name="apply_settings" action="spam_settings.cfm#apply" method="post">
                                                <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="955" id="Cell753">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        ��<tr>
                                                          <td align="center">
                                                            <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;">� 
getapplied� 1
select * from spam_settings where applied='2'
� �
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
�
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Applying settings, please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" disabled="disabled" style="height: 24px; width: 142px;">
�&nbsp;</p>
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
                                            <td width="955" height="5">�?</td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="955" id="Text351" class="TextObject">
                                              <p style="text-align: left; margin-bottom: 0px;">� 16�_
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
�@



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
                              �m<tr valign="top" align="left">
                                <td width="981" height="12"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td width="981" id="Text496" class="TextObject">
                                  <p style="text-align: center; margin-bottom: 0px;">� $lucee/runtime/functions/dateTime/Now� =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &�
�� yyyy� 4lucee/runtime/functions/displayFormatting/DateFormat� S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &�
�� 
getversion� D
SELECT value from system_settings where parameter = 'version_no'
� getbuild� B
SELECT value from system_settings where parameter = 'build_no'
� V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway � sessionScope $()Llucee/runtime/type/scope/Session;��
 /�  lucee/runtime/type/scope/Session�� � 	 Version:   Build: . Copyright 2011- l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>�
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
       ���� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException  lucee/runtime/type/UDFProperties udfs #[Llucee/runtime/type/UDFProperties;	  setPageSource 
  SHOW_ACTION lucee/runtime/type/KeyImpl intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key; 
! GET_USE_BAYES# 	USE_BAYES% GET_BAYES_AUTO_LEARN' BAYES_AUTO_LEARN) &GET_BAYES_AUTO_LEARN_THRESHOLD_NONSPAM+ "BAYES_AUTO_LEARN_THRESHOLD_NONSPAM- #GET_BAYES_AUTO_LEARN_THRESHOLD_SPAM/ BAYES_AUTO_LEARN_THRESHOLD_SPAM1 GET_USE_DCC3 USE_DCC5 GET_USE_RAZOR27 
USE_RAZOR29 GET_USE_PYZOR; 	USE_PYZOR= GET_USER_PORTAL? user_portalA SHOW_USER_PORTALC USER_PORTALE GET_SA_SPAM_SUBJECT_TAGG sa_spam_subject_tagI SHOW_SA_SPAM_SUBJECT_TAGK SA_SPAM_SUBJECT_TAGM GET_FINAL_VIRUS_DESTINYO final_virus_destinyQ SHOW_FINAL_VIRUS_DESTINYS FINAL_VIRUS_DESTINYU GET_FINAL_BANNED_DESTINYW final_banned_destinyY SHOW_FINAL_BANNED_DESTINY[ FINAL_BANNED_DESTINY] GET_FINAL_SPAM_DESTINY_ final_spam_destinya SHOW_FINAL_SPAM_DESTINYc FINAL_SPAM_DESTINYe GET_FINAL_BAD_HEADER_DESTINYg final_bad_header_destinyi SHOW_FINAL_BAD_HEADER_DESTINYk FINAL_BAD_HEADER_DESTINYm GET_MYSQL_USERNAME_HERMESo STEPq GET_MYSQL_PASSWORD_HERMESs action2u ACTION2w SHOW_ACTION2y MYSQLUSERNAMEHERMES{ MYSQLPASSWORDHERMES} AUTHKEY ALGO� ENCODING� RANDOM� STRESULT� GENERATED_KEY� CUSTOMTRANS3� GETTRANS� CUSTOMTRANS2� VALIDATEMYSQL� VALIDATEFILE� M2� COMPARE_BAYES� GET_PREVIOUS_USE_BAYES� DEFAULT� 
THEDEFAULT� SERVER_NAME� VALUE2� SERVER_DOMAIN� RULEID� 	RULE_NAME� GETRULECOMPONENTS� FILE_ID� GETFILE� THETYPE� THERULE� THECOMPONENTS� THERULES� GETTESTS� 	PARAMETER� THETESTS� GETMESSAGERULES� 	RULE_TYPE� 	RULE_DESC� REGEX� SCORE� HEADER� 
GETAPPLIED� THEYEAR� EDITION� 
GETVERSION� GETBUILD� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *��*+��        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  � !  �A+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+S� 3+U� 3+W+� \� bM>+� \,� .dY:� !� fY� hYj� lW� pr� u� y� z�M>+� |~W,  � �+�� 3+�+� \� b:6+� \� 0dY:� !� fY� hYj� l�� pr� u� y� z�:6+� |~�  � �+�� 3+�+� \� b:6	+� \� 0dY:
� !� fY� hYj� l�� pr� u� y� z�
:6	+� |~�  	� �+�� 3+� |��� �� �:� ��� ��� ��� �� �W� �� � ��� :+� |� ��+� |� �+�� 3+�+� \� b:6+� \� 0�Y:� !� fY� hYj� l�� pr� u� y� z�:6+� |~�  � �+�� 3+�+� \� b:6+� \� 0�Y:� !� fY� hYj� l�� pr� u� y� z�:6+� |~�  � �+Ŷ 3+�+� \� b:6+� \� 0�Y:� !� fY� hYj� lǶ pr� u� y� z�:6+� |~�  � �+�� 3+ ʲ �� и �׸ �� � � .+�� 3+� 7*� �2+� � � � � E W+�� 3� +Ŷ 3+� �+� |��� �� �:�� �+� 7� =� � ��6� O+�+� 3���� $:�� :� +�W��� +�W��� � ��� :+� |� ��+� |� �� :+��+�+Ŷ 3+� �+� |��� �� �:� �+� 7� =� � ��6� O+�+� 3���� $:�� :� +�W��� +�W��� � ��� : +� |� � �+� |� �� :!+�!�+�+Ŷ 3+� �+� |��� �� �:"" � �"+� 7� =� � �"�6##� O+"#�+"� 3"���� $:$"$�� :%#� +�W"�%�#� +�W"�"�� � ��� :&+� |"� �&�+� |"� �� :'+�'�+�+Ŷ 3+� �+� |��� �� �:(($� �(+� 7� =� � �(�6))� O+()�+&� 3(���� $:*(*�� :+)� +�W(�+�)� +�W(�(�� � ��� :,+� |(� �,�+� |(� �� :-+�-�+�+Ŷ 3+� �+� |��� �� �:..(� �.+� 7� =� � �.�6//� O+./�+*� 3.���� $:0.0�� :1/� +�W.�1�/� +�W.�.�� � ��� :2+� |.� �2�+� |.� �� :3+�3�+�+Ŷ 3+� �+� |��� �� �:44,� �4+� 7� =� � �4�655� O+45�+.� 34���� $:646�� :75� +�W4�7�5� +�W4�4�� � ��� :8+� |4� �8�+� |4� �� :9+�9�+�+Ŷ 3+� �+� |��� �� �:::0� �:+� 7� =� � �:�6;;� O+:;�+2� 3:���� $:<:<�� :=;� +�W:�=�;� +�W:�:�� � ��� :>+� |:� �>�+� |:� �� :?+�?�+�+Ŷ 3+� �+� |��� �� �:@@4� �@+� 7� =� � �@�6AA� O+@A�+6� 3@���� $:B@B�� :CA� +�W@�C�A� +�W@�@�� � ��� :D+� |@� �D�+� |@� �� :E+�E�+�+Ŷ 3+� �+� |��� �� �:FF8� �F+� 7� =� � �F�6GG� O+FG�+:� 3F���� $:HFH�� :IG� +�WF�I�G� +�WF�F�� � ��� :J+� |F� �J�+� |F� �� :K+�K�+�+Ŷ 3+� �+� |��� �� �:LL<� �L+� 7� =� � �L�6MM� O+LM�+>� 3L���� $:NLN�� :OM� +�WL�O�M� +�WL�L�� � ��� :P+� |L� �P�+� |L� �� :Q+�Q�+�+Ŷ 3+� �+� |��� �� �:RR@� �R+� 7� =� � �R�6SS� O+RS�+B� 3R���� $:TRT�� :US� +�WR�U�S� +�WR�R�� � ��� :V+� |R� �V�+� |R� �� :W+�W�+�+Ŷ 3+� �+� |��� �� �:XXD� �X+� 7� =� � �X�6YY� O+XY�+F� 3X���� $:ZXZ�� :[Y� +�WX�[�Y� +�WX�X�� � ��� :\+� |X� �\�+� |X� �� :]+�]�+�+Ŷ 3+� �+� |��� �� �:^^H� �^+� 7� =� � �^�6__� O+^_�+J� 3^���� $:`^`�� :a_� +�W^�a�_� +�W^�^�� � ��� :b+� |^� �b�+� |^� �� :c+�c�+�+Ŷ 3+L+� \� b:d6e+� \d� E++� 7*� �2�O �R�UY:f� "� fY� hYj� lL� pr� u� y� z�f:d6e+� |~Ld  e� �+�� 3+ �*� �2� и �׸ �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +Ŷ 3+W+� \� b:g6h+� \g� E++� 7*� �2�O �R�UY:i� "� fY� hYj� lW� pr� u� y� z�i:g6h+� |~Wg  h� �+�� 3+ �*� �2� и �׸ �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +Ŷ 3+Y+� \� b:j6k+� \j� F++� 7*� �2�O �R�UY:l� "� fY� hYj� lY� pr� u� y� z�l:j6k+� |~Yj  k� �+�� 3+ �*� �2� и �׸ �� � � 3+�� 3+� 7*� �	2+� �*� �	2� � � E W+�� 3� +Ŷ 3+[+� \� b:m6n+� \m� F++� 7*� �
2�O �R�UY:o� "� fY� hYj� l[� pr� u� y� z�o:m6n+� |~[m  n� �+�� 3+ �*� �2� и �׸ �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +Ŷ 3+]+� \� b:p6q+� \p� F++� 7*� �2�O �R�UY:r� "� fY� hYj� l]� pr� u� y� z�r:p6q+� |~]p  q� �+�� 3+ �*� �2� и �׸ �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +Ŷ 3+_+� \� b:s6t+� \s� F++� 7*� �2�O �R�UY:u� "� fY� hYj� l_� pr� u� y� z�u:s6t+� |~_s  t� �+�� 3+ �*� �2� и �׸ �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +Ŷ 3+a+� \� b:v6w+� \v� F++� 7*� �2�O �R�UY:x� "� fY� hYj� la� pr� u� y� z�x:v6w+� |~av  w� �+�� 3+ �*� �2� и �׸ �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +Ŷ 3+c+� \� b:y6z+� \y� F++� 7*� �2�O �R�UY:{� "� fY� hYj� lc� pr� u� y� z�{:y6z+� |~cy  z� �+�� 3+ �*� �2� и �׸ �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +Ŷ 3+e+� \� b:|6}+� \|� F++� 7*� �2�O �R�UY:~� "� fY� hYj� le� pr� u� y� z�~:|6}+� |~e|  }� �+�� 3+ �*� �2� и �׸ �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3+g+� \� b:6�+� \� F++� 7*� �2�O �R�UY:�� "� fY� hYj� lg� pr� u� y� z��:6�+� |~g  �� �+�� 3+ �*� �2� и �׸ �� � � 3+�� 3+� 7*� � 2+� �*� �!2� � � E W+�� 3� +Ŷ 3+i+� \� b:�6�+� \�� F++� 7*� �"2�O �R�UY:�� "� fY� hYj� li� pr� u� y� z��:�6�+� |~i�  �� �+�� 3+ �*� �#2� и �׸ �� � � 3+�� 3+� 7*� �$2+� �*� �%2� � � E W+�� 3� +Ŷ 3+k+� \� b:�6�+� \�� F++� 7*� �&2�O �R�UY:�� "� fY� hYj� lk� pr� u� y� z��:�6�+� |~k�  �� �+�� 3+ �*� �'2� и �׸ �� � � 3+�� 3+� 7*� �(2+� �*� �)2� � � E W+�� 3� +Ŷ 3+m+� \� b:�6�+� \�� F++� 7*� �*2�O �R�UY:�� "� fY� hYj� lm� pr� u� y� z��:�6�+� |~m�  �� �+�� 3+ �*� �+2� и �׸ �� � � 3+�� 3+� 7*� �,2+� �*� �-2� � � E W+�� 3� +Ŷ 3+� 7� � � o�r� � ��+�� 3+� �+� |��� �� �:��t� ��+� 7� =� � ���6��� O+���+v� 3����� $:����� :��� +�W������ +�W����� � ��� :�+� |�� ���+� |�� �� :�+���+�+Ŷ 3++� 7*� �.2�O �R�Ux�r� � � <+�� 3+� 7*� �/2�~� E W+�� 3+� 7����� E W+�� 3� O++� 7*� �.2�O �R�Ux�r� � � &+�� 3+� 7*� �/2��� E W+�� 3� +Ŷ 3+� 7*� �/2� � ��r� � ��+�� 3+� �+� |��� �� �:���� ��+� 7� =� � ���6��� O+���+�� 3����� $:����� :��� +�W������ +�W����� � ��� :�+� |�� ���+� |�� �� :�+���+�+Ŷ 3++� 7*� �02�O �R�Ux�r� � � <+�� 3+� 7*� �/2�~� E W+�� 3+� 7����� E W+Ŷ 3� O++� 7*� �02�O �R�Ux�r� � � &+Ŷ 3+� 7*� �/2��� E W+�� 3� +�� 3� +Ŷ 3+� 7*� �/2� � ��r� � � �+Ŷ 3+� 7*� �2� � x�r� � � &+�� 3+� 7*� �/2��� E W+�� 3� ^+� 7*� �2� � x�r� � � <+�� 3+� 7*� �/2�~� E W+�� 3+� 7����� E W+�� 3� +�� 3� +Ŷ 3+� 7*� �/2� � ��r� � � �+Ŷ 3+� 7*� �2� � x�r� � � &+�� 3+� 7*� �/2��� E W+�� 3� ^+� 7*� �2� � x�r� � � <+�� 3+� 7*� �/2�~� E W+�� 3+� 7����� E W+�� 3� +�� 3� +Ŷ 3+� 7*� �/2� � ��r� � ��+Ŷ 3+� 7*� �2� � x�r� � �;+�� 3+�+� 7*� �2� � ��� �+�� 3+� 7*� �2� � ��� � � )+� 7*� �2� � ���� � � � � &+�� 3+� 7*� �/2��� E W+�� 3� :+�� 3+� 7*� �/2�~� E W+�� 3+� 7����� E W+�� 3+Ŷ 3� _+�+� 7*� �2� � ��� � � =+�� 3+� 7*� �/2�~� E W+�� 3+� 7����� E W+�� 3� +Ŷ 3� _+� 7*� �2� � x�r� � � =+�� 3+� 7*� �/2�~� E W+�� 3+� 7����� E W+�� 3� +�� 3� +Ŷ 3+� 7*� �/2� � ��r� � ��+Ŷ 3+� 7*� �	2� � x�r� � �;+�� 3+�+� 7*� �	2� � ��� �+�� 3+� 7*� �	2� � ��� � � )+� 7*� �	2� � ���� � � � � &+�� 3+� 7*� �/2��� E W+�� 3� :+�� 3+� 7*� �/2�~� E W+�� 3+� 7����� E W+¶ 3+Ŷ 3� _+�+� 7*� �	2� � ��� � � =+�� 3+� 7*� �/2�~� E W+�� 3+� 7���Ź E W+Ƕ 3� +Ŷ 3� _+� 7*� �	2� � x�r� � � =+�� 3+� 7*� �/2�~� E W+�� 3+� 7���ʹ E W+̶ 3� +ζ 3� +Ŷ 3+� 7*� �/2� � иr� � �	�+�� 3+� �+� |��� �� �:��Ҷ ��+� 7� =� � ���6��� m+���+Զ 3++� 7*� �2� � �ٶ�+޶ 3����է $:����� :��� +�W������ +�W����� � ��� :�+� |�� ���+� |�� �� :�+���+�+Ŷ 3+� �+� |��� �� �:��� ��+� 7� =� � ���6��� m+���+Զ 3++� 7*� �2� � �ٶ�+� 3����է $:����� :��� +�W������ +�W����� � ��� :�+� |�� ���+� |�� �� :�+���+�+Ŷ 3+� �+� |��� �� �:��� ��+� 7� =� � ���6��� m+���+Զ 3++� 7*� � 2� � �ٶ�+� 3����է $:����� :��� +�W������ +�W����� � ��� :�+� |�� ���+� |�� �� :�+���+�+Ŷ 3+� �+� |��� �� �:��� ��+� 7� =� � ���6��� m+���+Զ 3++� 7*� �$2� � �ٶ�+� 3����է $:����� :��� +�W������ +�W����� � ��� :�+� |�� ���+� |�� �� :�+���+�+Ŷ 3+� �+� |��� �� �:��� ��+� 7� =� � ���6��� m+���+Զ 3++� 7*� �(2� � �ٶ�+� 3����է $:����� :��� +�W������ +�W����� � ��� :�+� |�� ���+� |�� �� :�+���+�+Ŷ 3+� �+� |��� �� �:��� ��+� 7� =� � ���6��� m+���+Զ 3++� 7*� �,2� � �ٶ�+� 3����է $:����� :��� +�W������ +�W����� � ��� :�+� |�� ���+� |�� �� :�+���+�+Ŷ 3+� �+� |��� �� �:���� ��+� 7� =� � ���6��� l+���+Զ 3++� 7*� �2� � �ٶ�+�� 3����֧ $:����� :��� +�W������ +�W����� � ��� :�+� |�� ���+� |�� �� :�+���+�+Ŷ 3+� �+� |��� �� �:���� ��+� 7� =� � ���6��� m+�¶+Զ 3++� 7*� �2� � �ٶ�+�� 3����է $:��ö� :��� +�W��Ŀ�� +�W����� � ��� :�+� |�� �ſ+� |�� �� :�+�ƿ+�+Ŷ 3+� �+� |��� �� �:���� ��+� 7� =� � �Ƕ6��� m+�ȶ+Զ 3++� 7*� �2� � �ٶ�+�� 3Ƕ��է $:��ɶ� :��� +�WǶʿ�� +�WǶǶ� � ��� :�+� |Ƕ �˿+� |Ƕ �� :�+�̿+�+Ŷ 3+� �+� |��� �� �:�� � ��+� 7� =� � �Ͷ6��� m+�ζ+Զ 3++� 7*� �2� � �ٶ�+� 3Ͷ��է $:��϶� :��� +�WͶп�� +�WͶͶ� � ��� :�+� |Ͷ �ѿ+� |Ͷ �� :�+�ҿ+�+Ŷ 3+� �+� |��� �� �:��� ��+� 7� =� � �Ӷ6��� m+�Զ+Զ 3++� 7*� �2� � �ٶ�+� 3Ӷ��է $:��ն� :��� +�WӶֿ�� +�WӶӶ� � ��� :�+� |Ӷ �׿+� |Ӷ �� :�+�ؿ+�+Ŷ 3+� 7���	� E W+� 3� +� 3� +� 3+� 7��� � ��r� � � -+�� 3+� �+� 3� :�+�ٿ+�+�� 3� +Ŷ 3+� 7��� � ��r� � � -+�� 3+� �+� 3� :�+�ڿ+�+�� 3� +Ŷ 3+� 7��� � ��r� � � -+�� 3+� �+� 3� :�+�ۿ+�+�� 3� +Ŷ 3+� 7��� � ��r� � � -+�� 3+� �+� 3� :�+�ܿ+�+�� 3� +Ŷ 3+� 7��� � ��r� � � -+�� 3+� �+� 3� :�+�ݿ+�+�� 3� +�� 3+� 7��� � �r� � � -+�� 3+� �+� 3� :�+�޿+�+�� 3� +Ŷ 3+� 7��� � �r� � � -+�� 3+� �+!� 3� :�+�߿+�+�� 3� +�� 3+� 7��� � #�r� � � -+�� 3+� �+%� 3� :�+��+�+�� 3� +�� 3+� 7��� � '�r� � � -+�� 3+� �+)� 3� :�+��+�+�� 3� +Ŷ 3+� 7��� � +�r� � � -+�� 3+� �+-� 3� :�+��+�+�� 3� +Ŷ 3+� 7��� � /�r� � � -+�� 3+� �+1� 3� :�+��+�+�� 3� +3� 3+� 7��� � 5�r� � � -+�� 3+� �+7� 3� :�+��+�+�� 3� +9� 3+;� 3+� �+=� 3++� 7*� �2� � �ٶ 3+?� 3� :�+��+�+A� 3+C� 3+E� 3+� 7*� �2� � ��r� � � -+�� 3+� �+G� 3� :�+��+�+�� 3� O+� 7*� �2� � ��r� � � -+�� 3+� �+I� 3� :�+��+�+�� 3� +K� 3+M� 3+� 7*� �2� � d�r� � � -+�� 3+� �+O� 3� :�+��+�+�� 3� N+� 7*� �2� � d�r� � � -+�� 3+� �+Q� 3� :�+��+�+�� 3� +S� 3+U� 3+W� 3+� 7*� �2� � ��r� � � -+�� 3+� �+Y� 3� :�+��+�+�� 3� O+� 7*� �2� � ��r� � � -+�� 3+� �+[� 3� :�+��+�+�� 3� +]� 3+M� 3+� 7*� �2� � d�r� � � -+�� 3+� �+_� 3� :�+��+�+�� 3� N+� 7*� �2� � d�r� � � -+�� 3+� �+a� 3� :�+���+�+�� 3� +c� 3+e� 3+g� 3+� 7*� �2� � ��r� � � -+�� 3+� �+i� 3� :�+��+�+�� 3� O+� 7*� �2� � ��r� � � -+�� 3+� �+k� 3� :�+��+�+�� 3� +m� 3+M� 3+� 7*� �2� � d�r� � � -+�� 3+� �+o� 3� :�+��+�+�� 3� N+� 7*� �2� � d�r� � � -+�� 3+� �+q� 3� :�+��+�+�� 3� +s� 3+u� 3+� �+w� 3++� 7*� �2� � �ٶ 3+?� 3� :�+��+�+y� 3+{� 3+� 7*� � 2� � }�r� � � -+�� 3+� �+� 3� :�+��+�+�� 3� O+� 7*� � 2� � }�r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� +�� 3+M� 3+� 7*� � 2� � ��r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� O+� 7*� � 2� � ��r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� +�� 3+�� 3+�� 3+� 7*� �$2� � }�r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� O+� 7*� �$2� � }�r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� +�� 3+M� 3+� 7*� �$2� � ��r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� O+� 7*� �$2� � ��r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� +�� 3+�� 3+�� 3+� 7*� �(2� � }�r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� O+� 7*� �(2� � }�r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� +�� 3+M� 3+� 7*� �(2� � ��r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� O+� 7*� �(2� � ��r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� +�� 3+�� 3+�� 3+� 7*� �,2� � }�r� � � -+�� 3+� �+�� 3� :�+���+�+�� 3� S+� 7*� �,2� � }�r� � � 1+�� 3+� �+�� 3� �: +�� �+�+�� 3� +�� 3+�� 3+� 7*� �,2� � ��r� � � 1+�� 3+� �+�� 3� �:+���+�+�� 3� S+� 7*� �,2� � ��r� � � 1+�� 3+� �+�� 3� �:+���+�+�� 3� +�� 3+�� 3+�� 3+E� 3+� 7*� �2� � ��r� � � 1+�� 3+� �+ö 3� �:+���+�+�� 3� R+� 7*� �2� � ��r� � � 1+�� 3+� �+Ŷ 3� �:+���+�+�� 3� +Ƕ 3+ɶ 3+� 7*� �2� � d�r� � � 1+�� 3+� �+˶ 3� �:+���+�+�� 3� Q+� 7*� �2� � d�r� � � 1+�� 3+� �+Ͷ 3� �:+���+�+�� 3� +϶ 3+Ѷ 3+Ӷ 3+� 7*� �2� � ��r� � � 1+�� 3+� �+ն 3� �:+���+�+�� 3� S+� 7*� �2� � ��r� � � 1+�� 3+� �+׶ 3� �:+���+�+�� 3� +ٶ 3+ɶ 3+� 7*� �2� � d�r� � � 1+�� 3+� �+۶ 3� �:	+��	�+�+�� 3� R+� 7*� �2� � d�r� � � 1+�� 3+� �+ݶ 3� �:
+��
�+�+�� 3� +߶ 3+� 3+� �+� 3++� 7*� �2� � �ٶ 3+?� 3� �:+���+�+� 3+� 3+� �+� 3++� 7*� �	2� � �ٶ 3+?� 3� �:+���+�+� 3+�� 3+� 3+� 3+�+� \� b�:�6+� \�� 9�Y�:� "� fY� hYj� l� pr� u� y� z���:�6+� |~��  �� �+�� 3+ �*� �12� и �׸ �� � � ^+�� 3+� �*� �22� � x�r� � � 3+�� 3+� 7*� �32+� �*� �22� � � E W+�� 3� � +�� 3+� 7*� �32� � ��r� � �y+�� 3+� �+� |��� �� ��:�t� ��+� 7� =� � ����6�� g+���+v� 3����� 2�:����  �:�� +�W������ +�W����� � ��� �:+� |�� ���+� |�� �� �:+���+�+Ŷ 3++� 7*� �.2�O �R�Ux�r� � � s+Ŷ 3+� |��� ����:�������W��� � ��� �:+� |�� ���+� |�� �+Ŷ 3� c++� 7*� �.2�O �R�Ux�r� � � :+Ŷ 3+� 7*� �42++� 7*� �.2�O �R�U� E W+Ŷ 3� +�� 3+� �+� |��� �� ��:��� ��+� 7� =� � ����6�� g+���+�� 3����� 2�:����  �:�� +�W������ +�W����� � ��� �:+� |�� ���+� |�� �� �:+���+�+Ŷ 3++� 7*� �02�O �R�Ux�r� � � s+Ŷ 3+� |��� ����:�������W��� � ��� �:+� |�� ���+� |�� �+Ŷ 3��++� 7*� �02�O �R�Ux�r� � ��+3� 3+� 7*� �52+++� 7*� �02�O �R�U��+� 7*� �62� � ��+� 7*� �72� � ��+� 7*� �82� � �ٸ� E W+3� 3+� �+� |��� �� ��: � � �� +� 7� =� � �� �� ��6!�!� g+� �!�+� 3� ���� 2�:"� �"��  �:#�!� +�W� ��#��!� +�W� �� �� � ��� �:$+� |� � ��$�+� |� � �� �:%+��%�+�+Ŷ 3+� �+� |��� �� ��:&�&� ��&+� 7� =� � ��&��&��6'�'��+�&�'�+� 3+� �+��:)+�"�6*�)�*�( �6+�)�+ � � � ��6,�,�)�+ �1�:(+� 7�)�5 �,d�6/�(�/`�9� N�)�(�<�*�@ � � � � ,�(�<�6/+++� 7*� �92� � �ٸE�ܧ��� .�:0�)�+�*�@ W+� 7�H �(�L�0��)�+�*�@ W+� 7�H �(�L� �:1+��1�+�+N� 3�&����� 2�:2�&�2��  �:3�'� +�W�&��3��'� +�W�&��&�� � ��� �:4+� |�&� ��4�+� |�&� �� �:5+��5�+�+Ŷ 3+� �+� |��� �� ��:6�6P� ��6+� 7� =� � ��6��67�7� �+�6�7�+R� 3+++� 7*� �:2�O *� �;2�U�ٶ�+T� 3�6���ȧ 2�:8�6�8��  �:9�7� +�W�6��9��7� +�W�6��6�� � ��� �::+� |�6� ��:�+� |�6� �� �:;+��;�+�+Ŷ 3+� 7*� �<2++� 7*� �=2�O *� �>2�U� E W+Ŷ 3+� �+� |��� �� ��:<�<V� ��<+� 7� =� � ��<��6=�=� �+�<�=�+X� 3+++� 7*� �:2�O *� �;2�U�ٶ�+T� 3�<���ȧ 2�:>�<�>��  �:?�=� +�W�<��?��=� +�W�<��<�� � ��� �:@+� |�<� ��@�+� |�<� �� �:A+��A�+�+Ŷ 3+� |��� �� ��:B�B� ��B�� ��BZ� ��B\� ��B� �W�B� �� � ��� �:C+� |�B� ��C�+� |�B� �+Ŷ 3+� |��� �� ��:D�D� ��D]� ��D_+� 7*� �<2� � �ٶe� ��D++� 7*� �?2� � ��g+� 7*� �42� � ��i�l�o�D� �W�D� �� � ��� �:E+� |�D� ��E�+� |�D� �+q� 3+� |��� �� ��:F�F� ��F�� ��F_+� 7*� �<2� � �ٶe� ��F\� ��F� �W�F� �� � ��� �:G+� |�F� ��G�+� |�F� �+Ŷ 3+� |��� �� ��:H�H� ��H]� ��H_+� 7*� �<2� � �ٶe� ��H++� 7*� �?2� � ��s+� 7*� �52� � ��i�l�o�H� �W�H� �� � ��� �:I+� |�H� ��I�+� |�H� �+u� 3+� |wy� ��{�:J�J}�~�J�+� 7*� �<2� � �ٶe���J����J���6K�K� F+�J�K�+�� 3�J����� �:L�K� +�W�L��K� +�W�J��� � ��� �:M+� |�J� ��M�+� |�J� �+Ŷ 3+���:N+Ŷ 3+� |wy� ��{�:O�O_+� 7*� �<2� � �ٶe�~�O����O����Ox���O���6P�P� F+�O�P�+�� 3�O����� �:Q�P� +�W�Q��P� +�W�O��� � ��� �:R+� |�O� ��R�+� |�O� �+�� 3�]�:S�S��� �S��S���:T+�T��+Ŷ 3++� 7���O ���U���� �+Ŷ 3+� |��� �� ��:U�U� ��U�� ��U_+� 7*� �<2� � �ٶe� ��U� �W�U� �� � ��� �:V+� |�U� ��V�+� |�U� �+Ŷ 3+� |��� ����:W�W���W��W�W�W�� � ��� �:X+� |�W� ��X�+� |�W� �+�� 3� +�� 3� �:Y+�N���Y�+�N��+Ŷ 3+� 7*� �@2_+� 7*� �<2� � �ٶe� E W+Ŷ 3++� 7*� �@2� � ��� �+�� 3+� |��� �� ��:Z�Z� ��Z�� ��Z+� 7*� �@2� � �ٶ ��Z� �W�Z� �� � ��� �:[+� |�Z� ��[�+� |�Z� �+�� 3� +�� 3� +3� 3+� 7*� �A2��� E W+Ŷ 3+� �+� |��� �� ��:\�\�� ��\+� 7� =� � ��\��6]�]� g+�\�]�+¶ 3�\���� 2�:^�\�^��  �:_�]� +�W�\��_��]� +�W�\��\�� � ��� �:`+� |�\� ��`�+� |�\� �� �:a+��a�+�+Ŷ 3+� �+� |��� �� ��:b�b�� ��b+� 7� =� � ��b��6c�c� g+�b�c�+� 3�b���� 2�:d�b�d��  �:e�c� +�W�b��e��c� +�W�b��b�� � ��� �:f+� |�b� ��f�+� |�b� �� �:g+��g�+�+Ŷ 3+� �+� |��� �� ��:h�h�� ��h+� 7� =� � ��h��6i�i� g+�h�i�+¶ 3�h���� 2�:j�h�j��  �:k�i� +�W�h��k��i� +�W�h��h�� � ��� �:l+� |�h� ��l�+� |�h� �� �:m+��m�+�+Ŷ 3+� �+� |��� �� ��:n�n� ��n+� 7� =� � ��n��6o�o� g+�n�o�+� 3�n���� 2�:p�n�p��  �:q�o� +�W�n��q��o� +�W�n��n�� � ��� �:r+� |�n� ��r�+� |�n� �� �:s+��s�+�+Ŷ 3+� �+� |��� �� ��:t�t$� ��t+� 7� =� � ��t��6u�u� g+�t�u�+&� 3�t���� 2�:v�t�v��  �:w�u� +�W�t��w��u� +�W�t��t�� � ��� �:x+� |�t� ��x�+� |�t� �� �:y+��y�+�+Ŷ 3+� �+� |��� �� ��:z�z � ��z+� 7� =� � ��z��6{�{� g+�z�{�+"� 3�z���� 2�:|�z�|��  �:}�{� +�W�z��}��{� +�W�z��z�� � ��� �:~+� |�z� ��~�+� |�z� �� �:+���+�+�� 3+� �+� |��� �� ��:���(� ���+� 7� =� � �����6���� g+�����+*� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���,� ���+� 7� =� � �����6���� g+�����+.� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���0� ���+� 7� =� � �����6���� g+�����+2� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���4� ���+� 7� =� � �����6���� g+�����+6� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���Ķ ���+� 7� =� � �����6���� g+�����+ƶ 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���8� ���+� 7� =� � �����6���� g+�����+:� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���<� ���+� 7� =� � �����6���� g+�����+>� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���@� ���+� 7� =� � �����6���� g+�����+B� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���D� ���+� 7� =� � �����6���� g+�����+F� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���H� ���+� 7� =� � �����6���� g+�����+J� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���ȶ ���+� 7� =� � �����6���� g+�����+ʶ 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���̶ ���+� 7� =� � ��¶�6���� g+���ö+ζ 3�¶��� 2�:����Ķ�  �:���� +�W�¶�ſ��� +�W�¶�¶� � ��� �:�+� |�¶ ��ƿ+� |�¶ �� �:�+��ǿ+�+3� 3+� 7*� �B2+++� 7*� �C2�O �R�U��++� 7*� �2�O �R�U�ٸӸ׹ E W+Ŷ 3+� 7*� �B2� � ��r� � � )+� 7*� �B2� � ٸr� � � � �+�� 3+� �+� |��� �� ��:���۶ ���+� 7� =� � ��ȶ�6���� g+���ɶ+ݶ 3�ȶ��� 2�:����ʶ�  �:���� +�W�ȶ�˿��� +�W�ȶ�ȶ� � ��� �:�+� |�ȶ ��̿+� |�ȶ �� �:�+��Ϳ+�+Ŷ 3+۶�:�+�"�6����й( �6��Ϲ+ � � ���6����Ϲ+ �1�:�+� 7�Ϲ5 ��d�6�����`�9�6���ζ<�й@ � � � ��ζ<�6�+Ŷ 3++� 7*� �2�O �R�U��r� � �W+Ŷ 3+� �+� |��� �� ��:���߶ ���+� 7� =� � ��ֶ�6���� �+���׶+� 3++� 7�� � �ٶ�+T� 3�ֶ��ק 2�:����ض�  �:���� +�W�ֶ�ٿ��� +�W�ֶ�ֶ� � ��� �:�+� |�ֶ ��ڿ+� |�ֶ �� �:�+��ۿ+�+Ŷ 3+� �+� |��� �� ��:���� ���+� 7� =� � ��ܶ�6���� �+���ݶ+Զ 3+++� 7*� �D2�O *� �E2�U�ٶ�+� 3++� 7�� � �ٶ�+T� 3�ܶ���� 2�:����޶�  �:���� +�W�ܶ�߿��� +�W�ܶ�ܶ� � ��� �:�+� |�ܶ ���+� |�ܶ �� �:�+���+�+Ŷ 3�~++� 7*� �2�O �R�Ud�r� � �W+Ŷ 3+� �+� |��� �� ��:���߶ ���+� 7� =� � ����6���� �+����+� 3++� 7�� � �ٶ�+T� 3����ק 2�:������  �:���� +�W������� +�W����� � ��� �:�+� |�� ���+� |�� �� �:�+���+�+Ŷ 3+� �+� |��� �� ��:���� ���+� 7� =� � ����6���� �+����+Զ 3+++� 7*� �D2�O *� �E2�U�ٶ�+� 3++� 7�� � �ٶ�+T� 3������ 2�:������  �:���� +�W������� +�W����� � ��� �:�+� |�� ���+� |�� �� �:�+����+�+Ŷ 3� +Ŷ 3���� .�:������й@ W+� 7�H �θL�������й@ W+� 7�H �θL+Ŷ 3� +Ŷ 3+� �+� |��� �� ��:���� ���+� 7� =� � ����6���� �+����+Զ 3+++� 7*� �2�O �R�U�ٶ�+�� 3����ͧ 2�:������  �:���� +�W������� +�W����� � ��� �:�+� |�� ���+� |�� �� �:�+����+�+3� 3+� �+� |��� �� ��:���� ���+� 7� =� � ��������6���� g+�����+� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3+� �+� |��� �� ��:���� ���+� 7� =� � ��������6�����+�����+� 3+� �+��:�+�"�6������( �6 ���+ � � � ��6����+ �1�:�+� 7���5 �d�6���`�9� N�����<���@ � � � � ,���<�6+++� 7*� �92� � �ٸE�ܧ��� .�:��� ���@ W+� 7�H ���L����� ���@ W+� 7�H ���L� �:+���+�+N� 3������� 2�:�����  �:��� +�W�������� +�W������� � ��� �:	+� |��� ��	�+� |��� �� �:
+��
�+�+Ŷ 3+� �+� |��� �� ��:�P� ��+� 7� =� � ����6�� �+���+R� 3+++� 7*� �:2�O *� �;2�U�ٶ�+T� 3����ȧ 2�:����  �:�� +�W������ +�W����� � ��� �:+� |�� ���+� |�� �� �:+���+�+Ŷ 3+� 7*� �<2++� 7*� �=2�O *� �>2�U� E W+Ŷ 3+� �+� |��� �� ��:�V� ��+� 7� =� � ����6�� �+���+X� 3+++� 7*� �:2�O *� �;2�U�ٶ�+T� 3����ȧ 2�:����  �:�� +�W������ +�W����� � ��� �:+� |�� ���+� |�� �� �:+���+�+3� 3+� |��� �� ��:�� ���� ��� ��� ��� �W�� �� � ��� �:+� |�� ���+� |�� �+�� 3+� |��� �� ��:�� ��]� ���+� 7*� �<2� � �ٶe��e� ��++� 7��� � ���++� 7*� �F2�O *� �G2�U��i�l�o�� �W�� �� � ��� �:+� |�� ���+� |�� �+Ŷ 3+� |��� �� ��:�� ���� ���+� 7*� �<2� � �ٶe��e� ��� ��� �W�� �� � ��� �:+� |�� ���+� |�� �+�� 3+� |��� �� ��:�� ��]� ���+� 7*� �<2� � �ٶe��e� ��++� 7��� � ���++� 7*� �H2�O *� �G2�U��i�l�o�� �W�� �� � ��� �:+� |�� ���+� |�� �+�� 3+� |��� �� ��:�� ���� ���+� 7*� �<2� � �ٶe��e� ��� ��� �W�� �� � ��� �: +� |�� �� �+� |�� �+�� 3+� |��� �� ��:!�!� ��!]� ��!�+� 7*� �<2� � �ٶe��e� ��!++� 7��� � �� ++� 7*� �2�O �R�U��i�l�o�!� �W�!� �� � ��� �:"+� |�!� ��"�+� |�!� �+�� 3+� |��� �� ��:#�#� ��#�� ��#�+� 7*� �<2� � �ٶe��e� ��#� ��#� �W�#� �� � ��� �:$+� |�#� ��$�+� |�#� �+�� 3+� |��� �� ��:%�%� ��%]� ��%�+� 7*� �<2� � �ٶe��e� ��%++� 7��� � ��++� 7*� �2�O �R�U��i�l�o�%� �W�%� �� � ��� �:&+� |�%� ��&�+� |�%� �+�� 3+� |��� �� ��:'�'� ��'�� ��'�+� 7*� �<2� � �ٶe��e� ��'� ��'� �W�'� �� � ��� �:(+� |�'� ��(�+� |�'� �+�� 3+� |��� �� ��:)�)� ��)]� ��)�+� 7*� �<2� � �ٶe��e� ��)++� 7��� � ��++� 7*� �"2�O �R�U��i�l�o�)� �W�)� �� � ��� �:*+� |�)� ��*�+� |�)� �+Ŷ 3+� |��� �� ��:+�+� ��+�� ��+�+� 7*� �<2� � �ٶe��e� ��+� ��+� �W�+� �� � ��� �:,+� |�+� ��,�+� |�+� �+�� 3+� |��� �� ��:-�-� ��-]� ��-�+� 7*� �<2� � �ٶe��e� ��-++� 7��� � ��++� 7*� �&2�O �R�U��i�l�o�-� �W�-� �� � ��� �:.+� |�-� ��.�+� |�-� �+�� 3+� |��� �� ��:/�/� ��/�� ��/�+� 7*� �<2� � �ٶe��e� ��/� ��/� �W�/� �� � ��� �:0+� |�/� ��0�+� |�/� �+�� 3+� |��� �� ��:1�1� ��1]� ��1�+� 7*� �<2� � �ٶe��e� ��1++� 7��� � ��++� 7*� �*2�O �R�U��i�l�o�1� �W�1� �� � ��� �:2+� |�1� ��2�+� |�1� �+
� 3+� |��� �� ��:3�3� ��3�� ��3�+� 7*� �<2� � �ٶe��e� ��3� ��3� �W�3� �� � ��� �:4+� |�3� ��4�+� |�3� �+Ŷ 3+� |��� �� ��:5�5� ��5]� ��5�+� 7*� �<2� � �ٶe��e� ��5++� 7��� � ��+� 7*� �42� � ��i�l�o�5� �W�5� �� � ��� �:6+� |�5� ��6�+� |�5� �+Ŷ 3+� |��� �� ��:7�7� ��7�� ��7�+� 7*� �<2� � �ٶe��e� ��7� ��7� �W�7� �� � ��� �:8+� |�7� ��8�+� |�7� �+Ŷ 3+� |��� �� ��:9�9� ��9]� ��9�+� 7*� �<2� � �ٶe��e� ��9++� 7��� � ��+� 7*� �52� � ��i�l�o�9� �W�9� �� � ��� �::+� |�9� ��:�+� |�9� �+� 3+� �+� |��� �� ��:;�;� ��;+� 7� =� � ��;��6<�<� g+�;�<�+� 3�;���� 2�:=�;�=��  �:>�<� +�W�;��>��<� +�W�;��;�� � ��� �:?+� |�;� ��?�+� |�;� �� �:@+��@�+�+3� 3+��:B+�"�6C�B�C�( �6D�B�+ � � ���6E�E�B�+ �1�:A+� 7�B�5 �Ed�6H�A�H`�9�T�B�A�<�C�@ � � � �2�A�<�6H+Ŷ 3+� �+� |��� �� ��:I�I� ��I+� 7� =� � ��I��6J�J� �+�I�J�+� 3++� 7*� �I2� � �ٶ�+� 3�I���ӧ 2�:K�I�K��  �:L�J� +�W�I��L��J� +�W�I��I�� � ��� �:M+� |�I� ��M�+� |�I� �� �:N+��N�+�+Ŷ 3+� |��� �� ��:O�O� ��O]� ��O�+� 7*� �<2� � �ٶe�e+� 7*� �J2� � �ٶe� ��O+� 7*� �J2� � �ٶe �e�o�O�#�O� �W�O� �� � ��� �:P+� |�O� ��P�+� |�O� �+3� 3+� 7�&++� 7*� �K2�O �,� E W+Ŷ 3+��:R+�"�6S�R�S�( �6T�R�+ � � �
�6U�U�R�+ �1�:Q+� 7�R�5 �Ud�6X�Q�X`�9�	��R�Q�<�S�@ � � � �	a�Q�<�6X+Ŷ 3+� 7�/� � +� 7�&� � �2� � � +Ŷ 3+� 7�5� � 7�r� � ��+Ŷ 3+� �+� |��� �� ��:Y�Y9� ��Y+� 7� =� � ��Y��6Z�Z� �+�Y�Z�+;� 3++� 7*� �L2� � �ٶ�+T� 3�Y���ӧ 2�:[�Y�[��  �:\�Z� +�W�Y��\��Z� +�W�Y��Y�� � ��� �:]+� |�Y� ��]�+� |�Y� �� �:^+��^�+�+Ŷ 3+� |��� �� ��:_�_� ��_<� ��_�+� 7*� �<2� � �ٶe>�e+� 7*� �J2� � �ٶe� ��_++� 7*� �M2�O *� �N2�U�o�_�#�_� �W�_� �� � ��� �:`+� |�_� ��`�+� |�_� �+Ŷ 3�
+� 7�5� � @�r� � ��+�� 3+� �+� |��� �� ��:a�a9� ��a+� 7� =� � ��a��6b�b� �+�a�b�+B� 3++� 7*� �L2� � �ٶ�+T� 3�a���ӧ 2�:c�a�c��  �:d�b� +�W�a��d��b� +�W�a��a�� � ��� �:e+� |�a� ��e�+� |�a� �� �:f+��f�+�+Ŷ 3+� |��� �� ��:g�g� ��g<� ��g�+� 7*� �<2� � �ٶe>�e+� 7*� �J2� � �ٶe� ��g++� 7*� �M2�O *� �N2�U�o�g�#�g� �W�g� �� � ��� �:h+� |�g� ��h�+� |�g� �+�� 3� +Ŷ 3�Y+� 7�/� � +� 7�&� � �2� � �2+�� 3+� 7�5� � 7�r� � ��+Ŷ 3+� �+� |��� �� ��:i�i9� ��i+� 7� =� � ��i��6j�j� �+�i�j�+;� 3++� 7*� �L2� � �ٶ�+T� 3�i���ӧ 2�:k�i�k��  �:l�j� +�W�i��l��j� +�W�i��i�� � ��� �:m+� |�i� ��m�+� |�i� �� �:n+��n�+�+Ŷ 3+� |��� �� ��:o�o� ��o<� ��o�+� 7*� �<2� � �ٶe>�e+� 7*� �J2� � �ٶe� ��o++� 7*� �M2�O *� �N2�U��D�e�o�o�#�o� �W�o� �� � ��� �:p+� |�o� ��p�+� |�o� �+Ŷ 3�+� 7�5� � @�r� � ��+�� 3+� �+� |��� �� ��:q�q9� ��q+� 7� =� � ��q��6r�r� �+�q�r�+B� 3++� 7*� �L2� � �ٶ�+T� 3�q���ӧ 2�:s�q�s��  �:t�r� +�W�q��t��r� +�W�q��q�� � ��� �:u+� |�q� ��u�+� |�q� �� �:v+��v�+�+Ŷ 3+� |��� �� ��:w�w� ��w<� ��w�+� 7*� �<2� � �ٶe>�e+� 7*� �J2� � �ٶe� ��w++� 7*� �M2�O *� �N2�U��D�e�o�w�#�w� �W�w� �� � ��� �:x+� |�w� ��x�+� |�w� �+�� 3� +Ŷ 3� +Ŷ 3+� |��� �� ��:y�y� ��y�� ��y�+� 7*� �<2� � �ٶe>�e+� 7*� �J2� � �ٶe� ��yF� ��y� �W�y� �� � ��� �:z+� |�y� ��z�+� |�y� �+�� 3��s� .�:{�R�T�S�@ W+� 7�H �Q�L�{��R�T�S�@ W+� 7�H �Q�L+Ŷ 3+� |��� �� ��:|�|� ��|�� ��|�+� 7*� �<2� � �ٶe�e+� 7*� �J2� � �ٶe� ��|H� ��|� �W�|� �� � ��� �:}+� |�|� ��}�+� |�|� �+Ŷ 3+� |��� �� ��:~�~� ��~]� ��~�+� 7*� �<2� � �ٶe�e+� 7*� �J2� � �ٶe� ��~++� 7*� �O2� � ��J+K�Q+� 7*� �P2� � �ٶei�l�o�~�#�~� �W�~� �� � ��� �:+� |�~� ���+� |�~� �+Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe�e+� 7*� �J2� � �ٶe� ���H� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3+� |��� �� ��:���� ���<� ����+� 7*� �<2� � �ٶeS�e� ���+� 7*� �O2� � �o���#��� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3+�+� 7*� �<2� � �ٶe�e+� 7*� �J2� � �ٶe��� �+�� 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe�e+� 7*� �J2� � �ٶe� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3� +Ŷ 3+�+� 7*� �<2� � �ٶe>�e+� 7*� �J2� � �ٶe��� �+�� 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe>�e+� 7*� �J2� � �ٶe� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3� +�� 3� .�:��B�D�C�@ W+� 7�H �A�L����B�D�C�@ W+� 7�H �A�L+Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶeS�e� ���U� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe��e� ���� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe��e� ���++� 7��� � ��W+� 7*� �Q2� � ��i�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3+�+� 7*� �<2� � �ٶeS�e��� �+�� 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶeS�e� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3� +Y� 3+� |��� �� ��:���� ����� ���[� ���]� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3++� 7*� �2�O �R�U��r� � � �+�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c��egi�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3� �++� 7*� �2�O �R�Ud�r� � � �+�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c��eii�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3� +Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe_�e� ���]� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3++� 7*� �2�O �R�U��r� � � �+�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c��kmi�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3� �++� 7*� �2�O �R�Ud�r� � � �+�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c��koi�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3� +Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe_�e� ���]� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3++� 7*� �2�O �R�U��r� � � �+�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c��qsi�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3� �++� 7*� �2�O �R�Ud�r� � � �+�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c��qui�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3� +Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe_�e� ���]� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3++� 7*� �2�O �R�U��r� � � �+�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c��wyi�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3� �++� 7*� �2�O �R�Ud�r� � � �+�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c��w{i�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3� +Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe_�e� ���]� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3++� 7*� �2�O �R�U��r� � � �+�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c��}i�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3� �++� 7*� �2�O �R�Ud�r� � � �+�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c��}�i�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3� +Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe_�e� ���]� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c����++� 7*� �
2�O �R�U�ٶei�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe_�e� ���]� ���� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c����++� 7*� �2�O �R�U�ٶei�l�o��� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3+� �+� |��� �� ��:����� ���+� 7� =� � �����6���� g+�����+�� 3������ 2�:�������  �:���� +�W��������� +�W������� � ��� �:�+� |��� ����+� |��� �� �:�+����+�+Ŷ 3++� 7*� �R2�O �,��� � �+Ŷ 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe��e� ���x�o���#��� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3+���:�+�"�6������( �6����+ � � ���6������+ �1�:�+� 7���5 ��d�6�����`�9������<���@ � � � � ����<�6�+Ŷ 3+� |��� �� ��:���� ���<� ����+� 7*� �<2� � �ٶe��e� ����+� 7*� �S2� � �ٶe��e+� 7�R� � �ٶe�o���#�Ƕ �W�Ƕ �� � ��� �:�+� |�Ƕ ��ȿ+� |�Ƕ �+�� 3��� .�:��������@ W+� 7�H ���L�ɿ�������@ W+� 7�H ���L+�� 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe��e� ����� ��ʶ �W�ʶ �� � ��� �:�+� |�ʶ ��˿+� |�ʶ �+Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe_�e� ���]� ��̶ �W�̶ �� � ��� �:�+� |�̶ ��Ϳ+� |�̶ �+Ŷ 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c���+� 7*� �T2� � ��i�l�o�ζ �W�ζ �� � ��� �:�+� |�ζ ��Ͽ+� |�ζ �+�� 3+�+� 7*� �<2� � �ٶe��e��� �+�� 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe��e� ��ж �W�ж �� � ��� �:�+� |�ж ��ѿ+� |�ж �+�� 3� +�� 3� +�� 3+� �+� |��� �� ��:����� ���+� 7� =� � ��Ҷ�6���� g+���Ӷ+�� 3�Ҷ��� 2�:����Զ�  �:���� +�W�Ҷ�տ��� +�W�Ҷ�Ҷ� � ��� �:�+� |�Ҷ ��ֿ+� |�Ҷ �� �:�+��׿+�+Ŷ 3++� 7*� �U2�O �,��� � �
�+Ŷ 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe��e� ���x�o���#�ض �W�ض �� � ��� �:�+� |�ض ��ٿ+� |�ض �+Ŷ 3+���:�+�"�6����ܹ( �6��۹+ � � �]�6����۹+ �1�:�+� 7�۹5 ��d�6�����`�9�����ڶ<�ܹ@ � � � ���ڶ<�6�+Ŷ 3+� 7*� �V2� � ��r� � �+�� 3+� 7*� �W2� � x�r� � �+�� 3+� |��� �� ��:���� ���<� ����+� 7*� �<2� � �ٶe��e� ���+� 7*� �V2� � ����e+� 7*� �J2� � �ٶe��e+� 7*� �X2� � �ٶe+K�Q�e��e+� 7*� �J2� � �ٶe��e+� 7*� �Y2� � �ٶe+K�Q�e��e+� 7*� �J2� � �ٶe��e+� 7*� �W2� � �ٶe+K�Q�e�o���#�� �W�� �� � ��� �:�+� |�� ���+� |�� �+�� 3�_+� 7*� �W2� � x�r� � �=+�� 3+� |��� �� ��:���� ���<� ����+� 7*� �<2� � �ٶe��e� ���+� 7*� �V2� � ����e+� 7*� �J2� � �ٶe��e+� 7*� �X2� � �ٶe+K�Q�e��e+� 7*� �J2� � �ٶe��e+� 7*� �Y2� � �ٶe+K�Q�e�o���#�� �W�� �� � ��� �:�+� |�� ���+� |�� �+�� 3� +�� 3�f+� 7*� �V2� � ��r� � �D+�� 3+� 7*� �W2� � x�r� � ��+�� 3+� |��� �� ��:���� ���<� ����+� 7*� �<2� � �ٶe��e� ���+� 7*� �V2� � ����e+� 7*� �J2� � �ٶe��e+� 7*� �Z2� � �ٶe��e+� 7*� �X2� � �ٶe+K�Q�e��e+� 7*� �J2� � �ٶe��e+� 7*� �Y2� � �ٶe+K�Q�e��e+� 7*� �J2� � �ٶe��e+� 7*� �W2� � �ٶe+K�Q�e�o���#�� �W�� �� � ��� �:�+� |�� ���+� |�� �+�� 3�{+� 7*� �W2� � x�r� � �Y+�� 3+� |��� �� ��:���� ���<� ����+� 7*� �<2� � �ٶe��e� ���+� 7*� �V2� � ����e+� 7*� �J2� � �ٶe��e+� 7*� �Z2� � �ٶe��e+� 7*� �X2� � �ٶe+K�Q�e��e+� 7*� �J2� � �ٶe��e+� 7*� �Y2� � �ٶe+K�Q�e�o���#�� �W�� �� � ��� �:�+� |�� ���+� |�� �+�� 3� +�� 3� +�� 3��)� .�:������ܹ@ W+� 7�H �ڸL�������ܹ@ W+� 7�H �ڸL+�� 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe��e� ���U� ��� �W�� �� � ��� �:�+� |�� ���+� |�� �+Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe_�e� ���]� ���� �W��� �� � ��� �:�+� |��� ���+� |��� �+Ŷ 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe_�e� ���++�c���+� 7*� �Q2� � ��i�l�o�� �W�� �� � ��� �:�+� |�� ���+� |�� �+�� 3+�+� 7*� �<2� � �ٶe��e��� �+�� 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe��e� ��� �W�� �� � ��� �:�+� |�� ���+� |�� �+�� 3� +�� 3� +�� 3+� |��� �� ��:���� ���]� ����+� 7*� �<2� � �ٶe��e� ����+K�Q�e�o���#�� �W�� �� � ��� �:�+� |�� ����+� |�� �+Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe��e� ����+K�Q�e�o���#��� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe��e� ����+� 7*� �<2� � �ٶe��e+K�Q�e�o���#��� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe��e� ����+� 7*� �<2� � �ٶe��e+K�Q�e�o���#��� �W��� �� � ��� �:�+� |��� ����+� |��� �+Ŷ 3+� |��� �� ��:���� ����� ����+� 7*� �<2� � �ٶe��e� ����+K�Q�e��e�o���#��� �W��� �� � ��� �:�+� |��� ����+� |��� �+�� 3+� |wy� ��{�:���}�~���+� 7*� �<2� � �ٶe��e������������6���� F+�����+�� 3������� �:���� +�W������ +�W����� � ��� �: +� |��� �� �+� |��� �+Ŷ 3+� |wy� ��{�:��+� 7*� �<2� � �ٶe��e�~�����Ķ���������6�� F+���+�� 3������ �:�� +�W���� +�W���� � ��� �:+� |�� ���+� |�� �+�� 3+� |��� �� ��:�� ���� ���+� 7*� �<2� � �ٶe��e� ��� �W�� �� � ��� �:+� |�� ���+� |�� �+ƶ 3+� �+� |��� �� ��:�ȶ ��+� 7� =� � ����6�� g+���+ʶ 3����� 2�:	��	��  �:
�� +�W���
��� +�W����� � ��� �:+� |�� ���+� |�� �� �:+���+�+q� 3� +̶ 3+ζ 3+� �+� |��� �� ��:�ж ��+� 7� =� � ����6�� g+���+Ҷ 3����� 2�:����  �:�� +�W������ +�W����� � ��� �:+� |�� ���+� |�� �� �:+���+�+�� 3++� 7*� �[2�O �,��� � � +Զ 3� 
+ֶ 3+ض 3+ڶ 3+� 7*� �A2� � ܸr� � � 1+�� 3+� �+޶ 3� �:+���+�+�� 3� +� 3+� 3+� 7*� �\2++���� E W+�� 3+� �+� |��� �� ��:�� ��+� 7� =� � ����6�� g+���+� 3����� 2�:����  �:�� +�W������ +�W����� � ��� �:+� |�� ���+� |�� �� �:+���+�+�� 3+� �+� |��� �� ��:��� ��+� 7� =� � ����6�� g+���+�� 3����� 2�:����  �:�� +�W������ +�W����� � ��� �:+� |�� ���+� |�� �� �:+���+�+�� 3+� �+�� 3++��*� �]2�� �ٶ 3+� 3+++� 7*� �^2�O �R�U�ٶ 3+� 3+++� 7*� �_2�O �R�U�ٶ 3+� 3++� 7*� �\2� � �ٶ 3+� 3� �: +�� �+�+	� 3��u��  {�� ){��  N��  =��  @PS )@\_  ��  ��   )!$  �ZZ  �tt  ��� )���  �  �99  ��� )���  a��  P��  Tdg )Tps  &��  ��  ), )58  �nn  ���  ��� )���  �	3	3  �	M	M  	�	�	� )	�	�	�  	u	�	�  	d

  
h
x
{ )
h
�
�  
:
�
�  
)
�
�  -=@ )-IL  
���  
���  � )�  �GG  �aa  ��� )���  �  x&&  DTW )D`c  ��  ��  ��� )�  �::  �TT  !!G!J )!!S!V   �!�!�   �!�!�  !�"*"- )!�"6"9  !�"o"o  !�"�"�  "�## )"�##  "�#R#R  "�#l#l  #�#�#� )#�#�#�  #�$5$5  #�$O$O  $�$�$� )$�$�$�  $w%%  $f%2%2  %�%�%� )%�%�%�  %Z%�%�  %I&&  &k&�&� )&k&�&�  &=&�&�  &,&�&�  'M'{'~ )'M'�'�  ''�'�  ''�'�  (0(^(a )(0(j(m  ((�(�  '�(�(�  ))A)D )))M)P  (�)�)�  (�)�)�  )�*$*' ))�*0*3  )�*i*i  )�*�*�  *�*�*�  +7+A+A  +�+�+�  +�+�+�  ,!,+,+  ,o,y,y  ,�,�,�  ---  -Y-c-c  -�-�-�  -�-�-�  .D.N.N  .v.�.�  .�.�.�  /8/B/B  /�/�/�  /�/�/�  0=0G0G  0�0�0�  0�0�0�  1-1717  1�1�1�  1�1�1�  232=2=  2~2�2�  2�2�2�  33)3)  3k3u3u  3�3�3�  444  4r4|4|  4�4�4�  55"5"  5d5n5n  5�5�5�  666  6k6u6u  6�6�6�  77"7"  7d7n7n  7�7�7�  888  8}8�8�  8�8�8�  9(9292  9v9�9�  9�9�9�  :+:5:5  :�:�:�  :�:�:�  ;;5;5  ;X;�;�  =#=5=8 )=#=G=J  <�=�=�  <�=�=�  >>8>8  ??+?. )??=?@  >�?�?�  >�?�?�  @@.@.  ARAdAg )ARAvAy  AA�A�  @�A�A�  B�C%C%  B^CuCu  BSC�C� )BSC�C�  BC�C�  A�DD  D}D�D� )D}D�D�  DAEE  D.E3E3  E�F
F )E�FF  E�FcFc  E�F�F�  F�F�F�  G'G�G�  G�H:H:  HrH�H�  I�I�I�  I1I�I�  JsJ�J�  JJ�J�  I�J�J� )KIK�K�  K�K�K�  I�L,L/  L�L�L�  M�M�M� )M�M�M�  M^NN  MKN'N'  N�N�N� )N�N�N�  NUN�N�  NBOO  O�O�O� )O�O�O�  OKO�O�  O8PP  P~P�P� )P~P�P�  PBP�P�  P/QQ  QuQ�Q� )QuQ�Q�  Q9Q�Q�  Q&RR  RlR~R� )RlR�R�  R0R�R�  RR�R�  ScSuSx )ScS�S�  S'S�S�  SS�S�  TZTlTo )TZT~T�  TT�T�  TT�T�  UQUcUf )UQUuUx  UU�U�  UU�U�  VHVZV] )VHVlVo  VV�V�  U�V�V�  W?WQWT )W?WcWf  WW�W�  V�W�W�  X6XHXK )X6XZX]  W�X�X�  W�X�X�  Y-Y?YB )Y-YQYT  X�Y�Y�  X�Y�Y�  Z$Z6Z9 )Z$ZHZK  Y�Z�Z�  Y�Z�Z�  [[-[0 )[[?[B  Z�[�[�  Z�[�[�  \\$\' )\\6\9  [�\}\}  [�\�\�  ]	]] )]	]-]0  \�]t]t  \�]�]�  ^ ^^ )^ ^$^'  ]�^k^k  ]�^�^�  _�_�_� )_�_�_�  __``  _L`(`(  ala�a� )ala�a�  a0a�a�  abb  b}b�b� )b}b�b�  bAc+c+  b.cMcM  c�dd )c�d%d(  c�dldl  c�d�d�  d�eMeP )d�e_eb  d�e�e�  d�e�e�  `�e�e�  f�f�f� )f�f�f�  fag,g,  fNgNgN  g�g�g� )g�g�g�  g}h.h.  gjhPhP  i8i�i�  h�i�i�  h�j	j )h�jj  h~jbjb  hkj�j�  j�k)k, )j�k;k>  j�k�k�  j�k�k�  l@l{l~ )l@l�l�  ll�l�  k�l�l�  m!mama  m�n*n*  nbn�n�  n�o�o�  o�pp  pTp�p�  qqvqv  q�r;r;  rtr�r�  ss�s�  s�t)t)  tat�t�  u'u�u�  u�vHvH  v�v�v�  ww�w�  w�x/x/  xgx�x�  yfyxy{ )yfy�y�  y*y�y�  yy�y�  {
{:{= ){
{L{O  z�{�{�  z�{�{�  {�|v|v  ~~C~F )~~U~X  }�~�~�  }�~�~�  ~�{{  ��J�M )��\�_  ހ���  ˀŀ�  ���  �W���� )�W����  �����  ���  �,�ȃ�  �g���� )�g����  �+����  ���  �<�؅�  �"����  },����  �%����  �ψ���  ���+�+  �c�Չ�  �O����  �;����  zt�؋�  �>����  �ҍ.�.  �f���  �P����  ��%�%  ������  �d�Ӑ�  ��p�p  �גF�F  ����  �_����  �"����  ���i�i  ����  �l�ۖ�  �C����  ��O�O  ���$�$  ������  �<����  �Л\�\  �����  �(����  �-�?�B )�-�Q�T  �񝘝�  �ޝ���  ��s�s  �W���  ���  �{�נ�  ��k�k  ���"�"  ���٢�  �d�v�y )�d����  �(�ϣ�  ����  �E����  �ާ�  �|�u�u  �	�`�`  �ëث�  �8��  �{�׬�  ��k�k  ���"�"  ���ٮ�  �$����  �˰:�:  �r����  �5����  ���m�m  � ��  ���J�J  �����  ���1�1  �i����  �5�G�J )�5�Y�\  ������  ��µ�  �>�P�S )�>�b�e  �����  ��˶�  �Q�[�[  ���
� )����  ���c�c  ������  ��� )���  ���Z�Z  ���|�|  ���'�'   �         * +  �  �.           @  A ! k $ � - � 0 � 9 � < � ? � E � � � � �a �� �# �� �� � �- �6 � �� �D �� �	 �� �� �I �� X��
�	]	�
"
l
�1��q� 6"�#�$�%'}(�)�*�,N-v.�/�1 2H3o4x6�78A9J;�<�=>@�A�B�C�EhF�G�H�J:KbL�M�PQ4R[SdU�VW-X6Z�[�\�]_�`�a�b�d�fgHi�k�lm"nTonqtrwt�v�w�yd{�|�}�������!�I�q��������������� �H�b����������������?����������������.�E�K�N�y����������������-�}������������� � � 3� 9� <� g� �� �� �� �� �� �� ��!�!;�!��" �"�"��"��#�#|�#��#��$_�$��$��%B�%��%��&%�&o�&��'�'Q�'o�'��(4�(R (�))5)�)�**�
*�*�*�*�*�*�*�*�+ ++!+0"+;#+N$+Q%+Z'+~(+�)+�*+�++�-+�.+�/+�0+�1+�3,4,%5,86,;7,D:,h;,s<,�=,�>,�@,�A,�B,�C,�D,�G-H-I-"J-%K-.N-RO-]P-pQ-sR-|T-�U-�V-�W-�X-�Z-�[-�\.].^.b.=c.Hd.[e.^f.rz.z{.�|.�~.��.��.��.��/�/�/1�/<�/O�/R�/\�/_�/c�/f�/��/��/��/��/��/��/��/��0 �0
�0�0�06�0A�0T�0W�0��0��0��0��0��0��0��0��0��0��0��0��1&�11�1D�1G�1Q�1T	1X
1[1_1b1�1�1�1�1�1�1� 1�!1�#2/20212,22732J42M52w62�72�82�92�<2�K2�L2�T2�U2�V2�X2�f2�g2�n3o3#p36q39r3ds3ot3�u3�v3�y3��3��3��3��3��3��3��4
�4�4(�4+�45�4?�4C�4F�4k�4v�4��4��4��4��4��4��4��4��4��4��5�5�5/�52�5]�5h�5{�5~�5��5��5��5��5��5��5��5��6
�6�6(�6+�65�686<6?6d6o6�6�6�6�6�6�6�6�16�26�8797:7/;72<7]=7h>7?7�@7�C7�O7�P7�Q7�R7�S7�T7�U8V8W8-X80Y8:\8=i8Dr8K|8v}8�~8�8��8��8��8��8��8��8��8��8��9!�9,�9C�9F�9o�9z�9��9��9��9��9��9��9��9��9��9��:$�:/�:F�:I�:S�:V�:Z�:]�:��:��:��:��:��:��:��:��:��;	�;�;/�;J�;M
;Q;T;\;z;�;� ;�!;�B;�J<!K<IL<qM<�N<�P<�R<�S='U=�W=�Y>Z[>�]>�_>�a>�b?d?�f?�h@Pj@�m@�n@�p@�rAVtA�vBWzC�{D'}D�~D�EG�Ey�E��E��F��G�G=�G]�G��G��G��H\�H��H��I�I�I�I?�I_�I��I��I��J:�JD�JN�Jv�J��K�K3�KU�K_�K��K��K��L �L&�L)�LH�LK�L{�L��M�M �M&�M*�M-�MD�M��N;�N��O1�O��P(�P��Q�Qy�R�Rp�S�Sg�T�T^�T��UU�U��VL�V��WC�W��X:�X��Y1�Y��Z(�Z��[�[��\�\� ]]�^^�^�
^�_E_�`<`�aapa�b'b�b�cac�!c�"d#d�%d�&e?'e�)e�+f>-fG/f�0f�1gc3gf5g�7hd9h�=i�>j�@j�AkBk�Dk�FlDGlmHmJmLm�Om�Pm�QnIOnIQnLSn�VoWo2Xo�Vo�Xo�Zp>]pj^p�_q ]q _qaq�dq�eq�frZdrZfr^hr�kslsDms�ks�ms�otKrtwst�turutuvu�yu�zu�{vgyvg{vk~vn�v��w+�wQ�w��w��w��xQ�x}�x��y�y�y�y�yj�z�z��{�{,�{��{��|1�|W�|��|��|��|��}l�}��}��~�~5�~��~��:�\������������<�������A��c�������������łǂ[ȂyɃ˃B̃~̓�΃�˃�΃�Єфk҄�Ӆ&ՅRօ�ׅ�؅�Յ�؅�ۆ݆߆��䇹���!�b鈠戠鈣�M�y���������9������%��������(�����P�|������:��	�����G�v��������N�z�������������� ��!�"�e �e"�h$��%��&��'�=%�='�@(�I*��,�-�8.�^/��-��/��1��2�3�64��2��4��5��7�(9�V:��;��<��:��<��>�-?�Y@�A��?��A��B��D�qF��G��H��I�CG�CI�FK�vL��M��N�L�N�O�&Q��S��T�U�{S�{U�~W�Y�>Z�d[��Y��[��^��`�1b��d��f�$g�Jh�Ti��f��i��k�Am�mn��o��p�	m�	p�q�et��v��x��y��z�Ax�Az�D}�p~���������h����/��[�����������������x����������������8��8��;��f��������V����������������������E��A����������������������������������e��������������A��A��D��p���������ǯ:ȯ`ɯtʯ�ǯ�ʯ�̯�ͰΰϰY̰Yϰ\Ѱ�Ұ�Ӱ�ԱѱԱֱKױqر�ٱ�ֱ�ٱ�۲ܲ4ݲN޲�۲�޲�Ჵ����l泮糸�����S��u���������9�������������	�B���
����%&�J'�U(�l)�o*�y.�|D��E��I��J��L��M��O��P��Q�<R�     ) 
 �        �    �     )  �         �    �     )  �        �    �        �  �    �*`� �Y�"SY$�"SYL�"SY&�"SY(�"SYW�"SY*�"SY,�"SYY�"SY	.�"SY
0�"SY[�"SY2�"SY4�"SY]�"SY6�"SY8�"SY_�"SY:�"SY<�"SYa�"SY>�"SY@�"SYB�"SYD�"SYF�"SYH�"SYJ�"SYL�"SYN�"SYP�"SYR�"SY T�"SY!V�"SY"X�"SY#Z�"SY$\�"SY%^�"SY&`�"SY'b�"SY(d�"SY)f�"SY*h�"SY+j�"SY,l�"SY-n�"SY.p�"SY/r�"SY0t�"SY1v�"SY2x�"SY3z�"SY4|�"SY5~�"SY6��"SY7��"SY8��"SY9��"SY:��"SY;��"SY<��"SY=��"SY>��"SY?��"SY@��"SYA��"SYB��"SYC��"SYD��"SYE��"SYF��"SYG��"SYH��"SYI��"SYJ��"SYK��"SYL��"SYM��"SYN��"SYO��"SYP��"SYQ��"SYR��"SYS��"SYT��"SYU��"SYV��"SYW¸"SYXĸ"SYYƸ"SYZȸ"SY[ʸ"SY\̸"SY]θ"SY^и"SY_Ҹ"S� �     �    