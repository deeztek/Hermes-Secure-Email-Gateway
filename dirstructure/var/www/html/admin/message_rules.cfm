����   2� I__138/__138/publish/hermes_seg_18_041454/proprietary/message_rules_cfm$cf  lucee/runtime/PageImpl  <../../publish/hermes-seg-18.04/proprietary/message_rules.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  �ͩW! getSourceLength      �� getCompileTime  �@,�@ getHash ()IK��j call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this KL__138/__138/publish/hermes_seg_18_041454/proprietary/message_rules_cfm$cf;
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Message Rules</title>
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
              <td height="634" width="988"> P m1 R &lucee/runtime/config/NullSupportHelper T NULL V '
 U W -lucee/runtime/interpreter/VariableInterpreter Y getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; [ \
 Z ] 0 _ %lucee/runtime/exp/ExpressionException a java/lang/StringBuilder c The required parameter [ e  1
 d g append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; i j
 d k ] was not provided. m -(Ljava/lang/String;)Ljava/lang/StringBuilder; i o
 d p toString ()Ljava/lang/String; r s
 d t
 b g lucee/runtime/PageContextImpl w any y�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V } ~
 x  
 � m2 � step � 

 � 	rule_name �   �@       keys $[Llucee/runtime/type/Collection$Key; � �	  � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � 	rule_desc � 	rule_type � body � header � _header � ;	 9 � regex � score � _score � ;	 9 � action �  
 � _action � ;	 9 � _ACTION � ;	 9 � 


 � A � edit � #lucee/commons/color/ConstantsDouble � _1 Ljava/lang/Double; � �	 � � [^_a-zA-Z0-9-] � lucee/runtime/op/Caster � &(Ljava/lang/Object;)Ljava/lang/String; r �
 � � %lucee/runtime/functions/string/REFind � S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object; & �
 � � (Ljava/lang/Object;D)I � �
 � � _2 � �	 � � :

<!-- /CFIF REFind("[^_a-zA-Z0-9-]"rule_name gt 0 -->
 � $

<!-- /CFIF rule_name is "" -->
 � 1 � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:238 � use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; � �
 x � lucee/runtime/tag/Query � hasBody (Z)V � �
 � � 	checkname setName 1
 � setDatasource (Ljava/lang/Object;)V
 � 
doStartTag
 $
 � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V
 / 7
select rule_name from message_rules where rule_name=' writePSQ
 / '
 doAfterBody $
 � doCatch (Ljava/lang/Throwable;)V
 � popBody ()Ljavax/servlet/jsp/JspWriter; 
 /! 	doFinally# 
 �$ doEndTag& $
 �' lucee/runtime/exp/Abort) newInstance (I)Llucee/runtime/exp/Abort;+,
*- reuse !(Ljavax/servlet/jsp/tagext/Tag;)V/0
 x1 	outputEnd3 
 /4 getCollection6 � A7 #lucee/runtime/util/VariableUtilImpl9 recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;;<
:= _3? �	 �@ -

<!-- /CFIF checkname.recordcount "" -->
B 

<!-- /CFIF FOR STEP 1 -->
D 2F _4H �	 �I _5K �	 �L ;


<!-- /CFIF REFind("[^_a-zA-Z0-9-]",header) gt 0 -->
N !

<!-- /CFIF header is "" -->
P (

<!-- /CFIF rule_type is header -->
R 

<!-- /CFIF FOR STEP 2 -->
T 3V _6X �	 �Y  

<!-- /CFIF regex is "" -->
[ 

<!-- /CFIF FOR STEP 3 -->
] 4_ _7a �	 �b *lucee/runtime/functions/decision/IsNumericd 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &f
eg _8i �	 �j %

<!-- /CFIF IsNumeric(score) -->
l 

<!-- /CFIF FOR STEP 4 -->
n 5p =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:316r insertt f
insert into message_rules (rule_name, rule_type, rule_desc, header, regex, score, applied) values ('v ', 'x ', z lucee.runtime.tag.QueryParam| cfqueryparam~ =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:317� lucee/runtime/tag/QueryParam� setValue�
�� cf_sql_varchar� setCfsqltype� 1
��
�
�' , '� 	', '2')
� lucee.runtime.tag.Location� 
cflocation� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:327� lucee/runtime/tag/Location� message_rules.cfm?m2=1� setUrl� 1
�� setAddtoken� �
��
�
�' 

<!-- /CFIF FOR STEP 5 -->
� !


<!-- /CFIF FOR ACTION -->
�
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 634px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="835">
                              <tr valign="top" align="left">
                                <td width="10" height="13"></td>
                                <td width="1"></td>
                                <td width="1"></td>
                                <td width="504"></td>
                                <td width="1"></td>
                                <td width="318"></td>
                              </tr>
                              <tr valign="top" align="left">
                                �<td></td>
                                <td colspan="3" width="506" id="Text373" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Message Rules</span></b></p>
                                </td>
                                <td colspan="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="6" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2"></td>
                                <td colspan="3" width="506" id="Text505" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Message Rule</span></b></p>
                                </td>
                                <td></td>
                              �s</tr>
                              <tr valign="top" align="left">
                                <td colspan="6" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="3" height="106"></td>
                                <td colspan="3" width="823">
                                  <form name="LayoutRegion33FORM" action="" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="780">
                                          <table id="Table139" border="0" cellspacing="0" cellpadding="0" width="780" style="height: 32px;">
                                            <tr style="height: 17px;">
                                              <td width="780" id="Cell1086">
                                                <table width="753" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  � �<tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;">��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Rule Added. If you are finished adding rules, click the Apply Settings button below to apply your changes.</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Rule Updated. Click the Apply Settings button below to apply your changes.</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Rule Deleted. Click the Apply Settings button below to apply your changes.</span></i></b></p>
� 16�_
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
�`
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name field cannot be empty</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name field must only contain lettes, numbers, dashes and underscores</span></i></b></p>
�s
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name you are attempting to use already exists</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The header field cannot be empty if Rule Type of Header is selected</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The header field must only contain lettes, numbers, dashes and underscores</span></i></b></p>
� 6�\
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Regex field cannot be empty</span></i></b></p>
� 7�\
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Score field cannot be empty</span></i></b></p>
� 8�a
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Score field must be numeric only</span></i></b></p>
�&&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1084">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Rule Type</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 68px;">
                                              <td id="Cell1085">
                                                <table width="749" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  �<tr>
                                                    <td>
                                                      <table id="Table133" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 68px;">
                                                        <tr style="height: 17px;">
                                                          <td width="64" id="Cell797">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� �
<input type="radio" checked="checked" name="rule_type" value=body" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
� x
<input type="radio" name="rule_type" value="body" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
�%







&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="685" id="Cell798">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Message Body Rule <span style="font-weight: normal;">(Search body of messages for matches)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell799">
                                                            �J<table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� �
<input type="radio" checked="checked" name="rule_type" value="header" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
� z
<input type="radio" name="rule_type" value="header" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
�-





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell800">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Message Header Rule <span style="font-weight: normal;">(Search message header for matches. Ex: Subject, To, From)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1077">
                                                            � uri� �
<input type="radio" checked="checked" name="rule_type" value="uri" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
� w
<input type="radio" name="rule_type" value="uri" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
�'





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1078">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">URI Rule <span style="font-weight: normal;">(Search for URI in the plain text or HTML section of messages)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1079">
                                                            � rawbody� �
<input type="radio" checked="checked" name="rule_type" value="rawbody" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
� {
<input type="radio" name="rule_type" value="rawbody" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
�





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1080">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Message Rawbody Rule <span style="font-weight: normal;">(Search body of messages for HTML tags or HTML comments or line-break patterns)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  �</tr>
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
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="135">
                              <tr valign="top" align="left">
                                <td width="110" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                �8<td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/message-rules/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="13" height="7"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="226"></td>
                          <td width="957">




 

                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion17" style="height: 226px;">
                              �4<tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="message_rules.cfm" method="post">
                                    <input type="hidden" name="action" value="edit"><input type="hidden" name="rule_type" value="�	">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="803">
                                          <table id="Table138" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 153px;">
                                            <tr style="height: 14px;">
                                              <td width="803" id="Cell973">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Rule Name <span style="font-weight: normal;">(Letters numbers, dashes and underlines only. No spaces are allowed)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              � b<td id="Cell972">
                                                <p style="margin-bottom: 0px;">� �<input type="text" id="FormsEditField39" name="rule_name" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="� ">�</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell901">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Rule Description</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell902">
                                                <p style="margin-bottom: 0px;">  �<input type="text" id="FormsEditField61" name="rule_desc" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1082">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b><span style="color: rgb(51,51,51);">Message Header </span></b><span style="font-weight: normal;">(Letters numbers, dashes and underlines only. No spaces are allowed. Use ALL to match any header)</span></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1083">
                                                <table width="440" border="0" cellspacing="0" cellpadding="0" align="left">
                                                   �<tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"> �
<input type="text" name="header" size="55" maxlength="255" style="width: 436px; white-space: pre;" style="white-space:pre" value="" disabled="disabled">
 �
<input type="text" name="header" size="55" maxlength="255" style="width: 436px; white-space: pre;" style="white-space:pre" value="
 ">
�&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell904">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Rule Regex<span style="font-weight: normal;"> </span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell905">
                                                <p style="margin-bottom: 0px;"> <input type="text" id="FormsEditField63" name="regex" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="�</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell906">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b><span style="color: rgb(51,51,51);">Spam Score </span></b><span style="font-weight: normal;">(Numeric value only. A score of 0 effectively disables rule)</span></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell968">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);"> <input type="text" id="FormsEditField62" name="score" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="</span></b></p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="11"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table136" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="957" id="Cell815">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="277" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Adding Rule, please wait...';this.form.submit();" name="savechanges" value="Add Rule" style="height: 24px; width: 275px;">
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  /</tr>
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
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="13" height="1"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="448"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="3" valign="middle" width="955"><hr id="HRRule15" width="955" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text410" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Existing Message Rules</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="972">
                        <tr valign="top" align="left">
                          <td width="12" height="1"></td>
                          <td width="960"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="960" id="Text407" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;"> =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:771  getmessagerules" 6
select * from message_rules order by rule_name asc
$ �
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No Existing Message Rules were found...</span></i></b></p>

&
<table id="Table131" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;">
  <tr style="height: 14px;">
    <td width="212" style="background-color: rgb(241,236,236);" id="Cell792">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Name</span></b></p>
    </td>
<td width="391" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Description</span></b></p>
    </td>

<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Type</span></b></p>
    </td>


    <td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: left; margin-bottom: 0px;">(N<b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Header</span></b></p>
    </td>




    <td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Regex</span></b></p>
    </td>




    <td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Score</span></b></p>
    </td>

<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Edit</span></b></p>
    </td>

<td width="212" style="background-color: rgb(241,236,236);" id="Cell796">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Delete* -</span></b></p>
    </td>



  </tr>

, getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;./
 /0 getId2 $
 /3 lucee/runtime/type/Query5 getCurrentrow (I)I7869 getRecordcount; $6< !lucee/runtime/util/NumberIterator> load '(II)Llucee/runtime/util/NumberIterator;@A
?B addQuery (Llucee/runtime/type/Query;)VDE AF isValid (I)ZHI
?J currentL $
?M go (II)ZOP6Q �

  <tr style="height: 19px;">

<td id="Cell798">
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">S �</span></p>
</td>

<td id="Cell798">
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">U </span></p>
</td>

W �

<td id="Cell798">
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Y �

<td id="Cell798">
<p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">N/A</span></p>
</td>

[ �</span></p>
</td>

<td id="Cell798">
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">] �</span></p>
</td>


<td id="Cell802">
      <form name="editreport" action="edit_message_rule.cfm" method="post">
<input type="hidden" name="id" value="_ _IDa ;	 9b">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>

<td align="center"><input type="image" name="FormsButton1" src="configure_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>


          </tr>
        </table>
      </form>
    </td>




    <td id="Cell802">
      <form name="Cell802FORM" action="delete_message_rule.cfm" method="post">
<input type="hidden" name="id" value="d�">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>


<td align="center"><input type="image" name="FormsButton1" src="delete_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>


          </tr>
        </table>
      </form>
    </td>
  </tr>
f removeQueryh  Ai release &(Llucee/runtime/util/NumberIterator;)Vkl
?m 
</table>
o=
    &nbsp;</p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="11" height="1"></td>
                          <td></td>
                          <td width="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="2" valign="middle" width="955"><hr id="HRRule31" width="955" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="48"></td>
                          <td width="952">q applys _16u �	 �v =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:916x get_use_bayesz [
select parameter, value from spam_settings where parameter='use_bayes' and active = '1'
| =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:921~ get_bayes_auto_learn� b
select parameter, value from spam_settings where parameter='bayes_auto_learn' and active = '1'
� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:925� #get_bayes_auto_learn_threshold_spam� q
select parameter, value from spam_settings where parameter='bayes_auto_learn_threshold_spam' and active = '1'
� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:929� &get_bayes_auto_learn_threshold_nonspam� t
select parameter, value from spam_settings where parameter='bayes_auto_learn_threshold_nonspam' and active = '1'
� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:933� get_use_dcc� Y
select parameter, value from spam_settings where parameter='use_dcc' and active = '1'
� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:937� get_use_razor2� \
select parameter, value from spam_settings where parameter='use_razor2' and active = '1'
� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:941� get_use_pyzor� [
select parameter, value from spam_settings where parameter='use_pyzor' and active = '1'
� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:945� customtrans� getrandom_results� 	setResult� 1
 �� Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:949� inserttrans� stResult� &
insert into salt
(salt)
values
('� #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� ')
� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:956� gettrans� 2
select salt as customtrans2 from salt where id='� I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; ��
 /� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:962� deletetrans� 
delete from salt where id='� 





� lucee.runtime.tag.FileTag� cffile� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:970� lucee/runtime/tag/FileTag�
� � read� 	setAction� 1
�� &/opt/hermes/conf_files/local.cf.HERMES� setFile� 1
�� safile� setVariable� 1
��
�
�' _VALUE� ;	 9� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:973� 0 /opt/hermes/tmp/� java/lang/String� concat &(Ljava/lang/String;)Ljava/lang/String;��
�� local.cf.HERMES� USE-DCC� 	use_dcc 1� ALL� (lucee/runtime/functions/string/REReplace� w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &�
�  	setOutput
� =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:978 	use_dcc 0 =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:983	 =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:986 	USE-PYZOR use_pyzor 1 =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:991 use_pyzor 0 =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:996 =C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:999 
USE-RAZOR2 use_razor2 1 >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1004 use_razor2 0 >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1009! >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1012# 	USE-BAYES% use_bayes 1' >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1017) use_bayes 0+ >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1022- >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1025/ BAYES-AUTO-LEARN1 bayes_auto_learn 13 >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:10305 bayes_auto_learn 07 >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:10359 >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1037; BAYESAUTOLEARN-SPAM=  bayes_auto_learn_threshold_spam ? >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1041A >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1043C BAYESAUTOLEARN-HAME #bayes_auto_learn_threshold_nonspam G 



I >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1049K gettestsM \
SELECT * FROM spam_settings where spamfilter='1' and active = '1' order by parameter asc
O >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1055Q 	_sa_testsS setAddnewlineU �
�V >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1062X i score [  ] >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1069_ theTestsa >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1071c >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1073e #CUSTOM-TESTSg 'lucee/runtime/functions/file/FileExistsi
jg >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1079l deleten >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1089p 6
SELECT * FROM message_rules order by rule_name asc
r >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1095t _message_rulesv >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1104x@$       "lucee/runtime/functions/string/Chr| 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &~
} 	describe � >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1109� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1116�  =� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1121� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1130� theRules� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1132� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1134� #CUSTOM-MESSAGE-RULES� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1140� 






� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1151� 	_apply.sh� K/bin/cp /etc/amavis/conf.d/50-user /etc/amavis/conf.d/50-user.HERMES.BACKUP� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1156� APPEND� K/bin/cp /etc/spamassassin/local.cf /etc/spamassassin/local.cf.HERMES.BACKUP� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1161� /bin/mv /opt/hermes/tmp/� *local.cf.HERMES /etc/spamassassin/local.cf� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1166� /etc/init.d/amavis restart� /etc/init.d/postfix restart� lucee.runtime.tag.Execute� 	cfexecute� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1172� lucee/runtime/tag/Execute� 
/bin/chmod�
� +x /opt/hermes/tmp/� setArguments�
��@N       
setTimeout (D)V��
��
�
�
�' >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1177� 	/dev/null� setOutputfile� 1
�� -inputformat none�@n       >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1184�  

    
� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1189� updateparams� Q
update spam_settings set applied='1' where applied = '2' and spamfilter = '1'
�  

� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1193� updaterules� <
update message_rules set applied='1' where applied = '2'
�  


� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1198� message_rules.cfm?m2=16� 
    
�1


                            <table border="0" cellspacing="0" cellpadding="0" width="952" id="LayoutRegion13" style="height: 48px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="10"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="952">
                                        <form name="apply_settings" action="message_rules.cfm" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="952" id="Cell753">
                                                �8<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;">� >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1222� 
getapplied� 7
select applied from message_rules where applied='2'
� �
<input type="hidden" name="action" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
�
<input type="hidden" name="action" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Applying settings, please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" disabled="disabled" style="height: 24px; width: 142px;">
�&nbsp;</p>
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
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                �8</table>
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
                        </tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;">� $lucee/runtime/functions/dateTime/Now =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &
 yyyy 4lucee/runtime/functions/displayFormatting/DateFormat S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &

	 >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1269 
getversion D
SELECT value from system_settings where parameter = 'version_no'
 >C:\publish\hermes-seg-18.04\proprietary\message_rules.cfm:1272 getbuild B
SELECT value from system_settings where parameter = 'build_no'
 V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway  sessionScope $()Llucee/runtime/type/scope/Session;
 /  lucee/runtime/type/scope/Session  � 	 Version:"  Build:$ . Copyright 2011-& l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>(A&nbsp;</p>
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
 ����* udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException2  lucee/runtime/type/UDFProperties4 udfs #[Llucee/runtime/type/UDFProperties;67	 8 setPageSource: 
 ; lucee/runtime/type/KeyImpl= intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;?@
>A 	RULE_NAMEC 	RULE_DESCE 	RULE_TYPEG HEADERI REGEXK SCOREM M1O STEPQ 	CHECKNAMES M2U GETMESSAGERULESW RANDOMY STRESULT[ GENERATED_KEY] CUSTOMTRANS3_ GETTRANSa CUSTOMTRANS2c GET_USE_DCCe SAFILEg GET_USE_PYZORi GET_USE_RAZOR2k GET_USE_BAYESm GET_BAYES_AUTO_LEARNo #GET_BAYES_AUTO_LEARN_THRESHOLD_SPAMq &GET_BAYES_AUTO_LEARN_THRESHOLD_NONSPAMs GETTESTSu 	PARAMETERw THETESTSy THERULES{ 
GETAPPLIED} THEYEAR EDITION� 
GETVERSION� GETBUILD� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *�5�9*+�<�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  ^� <  P�+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+S+� X� ^M>+� X,� .`Y:� !� bY� dYf� hS� ln� q� u� v�M>+� xzS, { {� �+�� 3+�+� X� ^:6+� X� 0`Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3+�+� X� ^:6	+� X� 0`Y:
� !� bY� dYf� h�� ln� q� u� v�
:6	+� xz� { {	� �+�� 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3+ �*� �2� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3+ �*� �2� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3+ �*� �2� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3+ �� �� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3+ �� �� �� ��� �� � � ]+�� 3+� �*� �	2� � �� �� � � 3+�� 3+� 7*� �	2+� �*� �	2� � � E W+�� 3� � +�� 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� h¶ ln� q� u� v�:6+� xz� { {� �+Ķ 3+ �� �� �� ��� �� � � Q+�� 3+� �� ʹ � �� �� � � ++�� 3+� 7� �+� �� ʹ � � E W+�� 3� � +̶ 3+� 7� ʹ � ϸ �� � ��+�� 3+� 7*� �2� � �� �� � � &+�� 3+� 7*� �
2� չ E W+�� 3� �+� 7*� �2� � �� �� � � }+�� 3+�+� 7*� �2� � � ܸ �� �� � � &+�� 3+� 7*� �
2� � E W+�� 3� #+�� 3+� 7*� �2� չ E W+� 3+� 3� +�� 3+� 7*� �2� � �� �� � ��+�� 3+� �+� x���� �� �:  �  � +� 7� =� � �	 �6!!� l+ !�+� 3++� 7*� �2� � � ܶ+� 3 ���֧ $:" "�� :#!� +�"W �%#�!� +�"W �% �(� �.�� :$+� x �2$�+� x �2� :%+�5%�+�5+�� 3++� 7*� �2�8 �>� �� � � &+�� 3+� 7*� �
2�A� E W+�� 3� K++� 7*� �2�8 �>� �� � � '+�� 3+� 7*� �2� � E W+C� 3� +E� 3� +�� 3+� 7*� �2� � G� �� � �h+�� 3+� 7*� �2� � �� �� � � �+�� 3+� 7*� �2� � �� �� � � &+�� 3+� 7*� �
2�J� E W+�� 3� �+� 7*� �2� � �� �� � � �+�� 3+�+� 7*� �2� � � ܸ �� �� � � &+�� 3+� 7*� �
2�M� E W+�� 3� $+�� 3+� 7*� �2�A� E W+O� 3+Q� 3� +�� 3� G+� 7*� �2� � �� �� � � '+�� 3+� 7*� �2�A� E W+S� 3� +U� 3� +̶ 3+� 7*� �2� � W� �� � � �+�� 3+� 7*� �2� � �� �� � � &+�� 3+� 7*� �
2�Z� E W+�� 3� H+� 7*� �2� � �� �� � � '+�� 3+� 7*� �2�J� E W+\� 3� +^� 3� +�� 3+� 7*� �2� � `� �� � � �+�� 3+� 7*� �	2� � �� �� � � &+�� 3+� 7*� �
2�c� E W+�� 3� �+� 7*� �	2� � �� �� � � n+�� 3++� 7*� �	2� � �h� &+Ķ 3+� 7*� �2�M� E W+�� 3� $+�� 3+� 7*� �
2�k� E W+m� 3+\� 3� +o� 3� +̶ 3+� 7*� �2� � q� �� � ��+�� 3+� �+� x��s� �� �:&&� &u�&+� 7� =� � �	&�6''�J+&'�+w� 3++� 7*� �2� � � ܶ+y� 3++� 7*� �2� � � ܶ+y� 3++� 7*� �2� � � ܶ+y� 3++� 7*� �2� � � ܶ+{� 3+� x}�� ���:((+� 7*� �2� � ��(���(��W(��� �.�� :)+� x(�2)�+� x(�2+�� 3++� 7*� �	2� � � ܶ+�� 3&����� $:*&*�� :+'� +�"W&�%+�'� +�"W&�%&�(� �.�� :,+� x&�2,�+� x&�2� :-+�5-�+�5+�� 3+� 7*� �2�� E W+�� 3+� 7*� �2�� E W+�� 3+� 7*� �2�� E W+�� 3+� 7*� �2�� E W+�� 3+� 7*� �2�� E W+�� 3+� 7*� �	2�� E W+�� 3+� x���� ���:..���.��.��W.��� �.�� :/+� x.�2/�+� x.�2+�� 3� +�� 3� +�� 3+�� 3+�� 3+�� 3+� 7*� �2� � �� �� � � -+�� 3+� �+�� 3� :0+�50�+�5+�� 3� +�� 3+� 7*� �2� � G� �� � � -+�� 3+� �+�� 3� :1+�51�+�5+�� 3� +�� 3+� 7*� �2� � W� �� � � -+�� 3+� �+�� 3� :2+�52�+�5+�� 3� +�� 3+� 7*� �2� � �� �� � � -+�� 3+� �+�� 3� :3+�53�+�5+�� 3� +�� 3+� 7*� �
2� � �� �� � � -+�� 3+� �+�� 3� :4+�54�+�5+�� 3� +�� 3+� 7*� �
2� � G� �� � � -+�� 3+� �+�� 3� :5+�55�+�5+�� 3� +�� 3+� 7*� �
2� � W� �� � � -+�� 3+� �+�� 3� :6+�56�+�5+�� 3� +�� 3+� 7*� �
2� � `� �� � � -+�� 3+� �+�� 3� :7+�57�+�5+�� 3� +�� 3+� 7*� �
2� � q� �� � � -+�� 3+� �+ö 3� :8+�58�+�5+�� 3� +�� 3+� 7*� �
2� � Ÿ �� � � -+�� 3+� �+Ƕ 3� :9+�59�+�5+�� 3� +�� 3+� 7*� �
2� � ɸ �� � � -+�� 3+� �+˶ 3� ::+�5:�+�5+�� 3� +�� 3+� 7*� �
2� � ͸ �� � � -+�� 3+� �+϶ 3� :;+�5;�+�5+�� 3� +Ѷ 3+Ӷ 3+� 7*� �2� � �� �� � � -+�� 3+� �+ն 3� :<+�5<�+�5+�� 3� M+� 7*� �2� � �� �� � � -+�� 3+� �+׶ 3� :=+�5=�+�5+�� 3� +ٶ 3+۶ 3+� 7*� �2� � �� �� � � -+�� 3+� �+ݶ 3� :>+�5>�+�5+�� 3� M+� 7*� �2� � �� �� � � -+�� 3+� �+߶ 3� :?+�5?�+�5+�� 3� +� 3+۶ 3+� 7*� �2� � � �� � � -+�� 3+� �+� 3� :@+�5@�+�5+�� 3� N+� 7*� �2� � � �� � � -+�� 3+� �+� 3� :A+�5A�+�5+�� 3� +� 3+۶ 3+� 7*� �2� � � �� � � -+�� 3+� �+�� 3� :B+�5B�+�5+�� 3� N+� 7*� �2� � � �� � � -+�� 3+� �+� 3� :C+�5C�+�5+�� 3� +� 3+� 3+�� 3+�� 3+� �++� 7*� �2� � � ܶ 3� :D+�5D�+�5+�� 3+�� 3+� �+�� 3++� 7*� �2� � � ܶ 3+�� 3� :E+�5E�+�5+� 3+� �+� 3++� 7*� �2� � � ܶ 3+�� 3� :F+�5F�+�5+� 3+� 3+� 7*� �2� � �� �� � � -+�� 3+� �+	� 3� :G+�5G�+�5+�� 3� k+� 7*� �2� � �� �� � � K+�� 3+� �+� 3++� 7*� �2� � � ܶ 3+� 3� :H+�5H�+�5+�� 3� +� 3+� �+� 3++� 7*� �2� � � ܶ 3+�� 3� :I+�5I�+�5+� 3+� �+� 3++� 7*� �	2� � � ܶ 3+�� 3� :J+�5J�+�5+� 3+� 3+� 3+� 3+� 3+� �+� x��!� �� �:KK� K#�K+� 7� =� � �	K�6LL� O+KL�+%� 3K���� $:MKM�� :NL� +�"WK�%N�L� +�"WK�%K�(� �.�� :O+� xK�2O�+� xK�2� :P+�5P�+�5+�� 3++� 7*� �2�8 �>� �� � � +'� 3�;++� 7*� �2�8 �>� �� � �+)� 3++� 3+-� 3+� �+#�1:R+�46SRS�: 6TR�= � � ��6UUR�= �C:Q+� 7R�G Ud6XQX`�K�MRQ�NS�R � � � �1Q�N6X+T� 3++� 7*� �2� � � ܶ 3+V� 3++� 7*� �2� � � ܶ 3+V� 3++� 7*� �2� � � ܶ 3+X� 3+� 7*� �2� � �� �� � � ++Z� 3++� 7*� �2� � � ܶ 3+X� 3� 
+\� 3+Z� 3++� 7*� �2� � � ܶ 3+^� 3++� 7*� �	2� � � ܶ 3+`� 3++� 7�c� � � ܶ 3+e� 3++� 7�c� � � ܶ 3+g� 3���� ":YRTS�R W+� 7�j Q�nY�RTS�R W+� 7�j Q�n� :Z+�5Z�+�5+p� 3� +r� 3+� 7� ʹ � t� �� � �0/+�� 3+� 7*� �2�w� E W+�� 3+� �+� x��y� �� �:[[� [{�[+� 7� =� � �	[�6\\� O+[\�+}� 3[���� $:][]�� :^\� +�"W[�%^�\� +�"W[�%[�(� �.�� :_+� x[�2_�+� x[�2� :`+�5`�+�5+̶ 3+� �+� x��� �� �:aa� a��a+� 7� =� � �	a�6bb� O+ab�+�� 3a���� $:cac�� :db� +�"Wa�%d�b� +�"Wa�%a�(� �.�� :e+� xa�2e�+� xa�2� :f+�5f�+�5+�� 3+� �+� x���� �� �:gg� g��g+� 7� =� � �	g�6hh� O+gh�+�� 3g���� $:igi�� :jh� +�"Wg�%j�h� +�"Wg�%g�(� �.�� :k+� xg�2k�+� xg�2� :l+�5l�+�5+�� 3+� �+� x���� �� �:mm� m��m+� 7� =� � �	m�6nn� O+mn�+�� 3m���� $:omo�� :pn� +�"Wm�%p�n� +�"Wm�%m�(� �.�� :q+� xm�2q�+� xm�2� :r+�5r�+�5+�� 3+� �+� x���� �� �:ss� s��s+� 7� =� � �	s�6tt� O+st�+�� 3s���� $:usu�� :vt� +�"Ws�%v�t� +�"Ws�%s�(� �.�� :w+� xs�2w�+� xs�2� :x+�5x�+�5+�� 3+� �+� x���� �� �:yy� y��y+� 7� =� � �	y�6zz� O+yz�+�� 3y���� $:{y{�� :|z� +�"Wy�%|�z� +�"Wy�%y�(� �.�� :}+� xy�2}�+� xy�2� :~+�5~�+�5+�� 3+� �+� x���� �� �:� ��+� 7� =� � �	�6��� O+��+�� 3���� $:���� :��� +�"W�%���� +�"W�%�(� �.�� :�+� x�2��+� x�2� :�+�5��+�5+�� 3+� �+� x���� �� �:��� ����+� 7� =� � �	������6��� O+���+�� 3����� $:����� :��� +�"W��%���� +�"W��%��(� �.�� :�+� x��2��+� x��2� :�+�5��+�5+�� 3+� �+� x���� �� �:��� ����+� 7� =� � �	������6���B+���+�� 3+� �+��1:�+�46����: 6���= � � � �6����= �C:�+� 7��G �d6���`�K� D���N��R � � � � (��N6�+++� 7*� �2� � � ܸ������ ":�����R W+� 7�j ��n������R W+� 7�j ��n� :�+�5��+�5+�� 3���� � $:����� :��� +�"W��%���� +�"W��%��(� �.�� :�+� x��2��+� x��2� :�+�5��+�5+�� 3+� �+� x���� �� �:��� ����+� 7� =� � �	��6��� x+���+�� 3+++� 7*� �2�8 *� �2�ĸ ܶ+� 3����ʧ $:����� :��� +�"W��%���� +�"W��%��(� �.�� :�+� x��2��+� x��2� :�+�5��+�5+�� 3+� 7*� �2++� 7*� �2�8 *� �2�Ĺ E W+�� 3+� �+� x��ƶ �� �:��� �ȶ�+� 7� =� � �	��6��� x+���+ʶ 3+++� 7*� �2�8 *� �2�ĸ ܶ+� 3����ʧ $:����� :��� +�"W��%���� +�"W��%��(� �.�� :�+� x��2��+� x��2� :�+�5��+�5+̶ 3+� x��Ҷ ���:�����׶��ܶ�������W���� �.�� :�+� x��2��+� x��2+�� 3++� 7*� �2�8 ����� �� � � �+�� 3+� x��� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � ���������W���� �.�� :�+� x��2��+� x��2+�� 3� �++� 7*� �2�8 ���`� �� � � �+�� 3+� x��� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � ��������W���� �.�� :�+� x��2��+� x��2+�� 3� +�� 3+� x��
� ���:�����׶���+� 7*� �2� � � ܶ������������W���� �.�� :�+� x��2��+� x��2+�� 3++� 7*� �2�8 ����� �� � � �+�� 3+� x��� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � �������W���� �.�� :�+� x��2��+� x��2+�� 3� �++� 7*� �2�8 ���`� �� � � �+�� 3+� x��� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � �������W���� �.�� :�+� x��2��+� x��2+�� 3� +�� 3+� x��� ���:�����׶���+� 7*� �2� � � ܶ������������W���� �.�� :�+� x��2��+� x��2+�� 3++� 7*� �2�8 ����� �� � � �+�� 3+� x��� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � �������W���� �.�� :�+� x��2��+� x��2+�� 3� �++� 7*� �2�8 ���`� �� � � �+�� 3+� x��� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � � ������W���� �.�� :�+� x��2��+� x��2+�� 3� +�� 3+� x��"� ���:�����׶���+� 7*� �2� � � ܶ������������W���� �.�� :�+� x��2��+� x��2+�� 3++� 7*� �2�8 ����� �� � � �+�� 3+� x��$� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � �&(������W���� �.�� :�+� x��2��+� x��2+�� 3� �++� 7*� �2�8 ���`� �� � � �+�� 3+� x��*� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � �&,������W���� �.�� :�+� x��2��+� x��2+�� 3� +�� 3+� x��.� ���:�����׶���+� 7*� �2� � � ܶ������������W���� �.�� :�+� x��2��+� x��2+�� 3++� 7*� �2�8 ����� �� � � �+�� 3+� x��0� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � �24������W���� �.�� :�+� x��2¿+� x��2+�� 3� �++� 7*� �2�8 ���`� �� � � �+�� 3+� x��6� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � �28���ö�Wö�� �.�� :�+� xö2Ŀ+� xö2+�� 3� +�� 3+� x��:� ���:�����׶���+� 7*� �2� � � ܶ���������Ŷ�WŶ�� �.�� :�+� xŶ2ƿ+� xŶ2+�� 3+� x��<� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � �>@++� 7*� �2�8 ��ĸ ܶ����Ƕ�WǶ�� �.�� :�+� xǶ2ȿ+� xǶ2+�� 3+� x��B� ���:�����׶���+� 7*� �2� � � ܶ���������ɶ�Wɶ�� �.�� :�+� xɶ2ʿ+� xɶ2+�� 3+� x��D� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � �FH++� 7*� �2�8 ��ĸ ܶ����˶�W˶�� �.�� :�+� x˶2̿+� x˶2+J� 3+� �+� x��L� �� �:��� �N��+� 7� =� � �	Ͷ6��� O+�ζ+P� 3Ͷ��� $:��϶� :��� +�"WͶ%п�� +�"WͶ%Ͷ(� �.�� :�+� xͶ2ѿ+� xͶ2� :�+�5ҿ+�5+�� 3++� 7*� �2�8 �>� �� � ��+�� 3+� x��R� ���:���������+� 7*� �2� � � ܶ�T���������WӶ�WӶ�� �.�� :�+� xӶ2Կ+� xӶ2+�� 3+N�1:�+�46��׹: 6�ֹ= � � �Q6��ֹ= �C:�+� 7ֹG �d6���`�K� ��նN׹R � � � � �նN6�+�� 3+� x��Y� ���:�����Z����+� 7*� �2� � � ܶ�T�����\+� 7*� �2� � � ܶ�^��+� 7�� � � ܶ����Wݶ�Wݶ�� �.�� :�+� xݶ2޿+� xݶ2+�� 3��� ":���׹R W+� 7�j ոn߿��׹R W+� 7�j ոn+̶ 3+� x��`� ���:�����׶���+� 7*� �2� � � ܶ�T�����b����W��� �.�� :�+� x�2�+� x�2+�� 3+� x��d� ���:�����׶���+� 7*� �2� � � ܶ�����������W��� �.�� :�+� x�2�+� x�2+�� 3+� x��f� ���:���������+� 7*� �2� � � ܶ�������++� 7*� �2� � � �h+� 7*� �2� � � ������W��� �.�� :�+� x�2�+� x�2+̶ 3+�+� 7*� �2� � � ܶ�T���k� �+�� 3+� x��m� ���:�����o����+� 7*� �2� � � ܶ�T������W��� �.�� :�+� x�2�+� x�2+�� 3� +̶ 3� +̶ 3+� �+� x��q� �� �:��� �#��+� 7� =� � �	�6��� O+��+s� 3���� $:���� :��� +�"W�%��� +�"W�%�(� �.�� :�+� x�2�+� x�2� :�+�5��+�5+�� 3++� 7*� �2�8 �>� �� � �
N+�� 3+� x��u� ���:���������+� 7*� �2� � � ܶ�w���������W��W��� �.�� :�+� x�2�+� x�2+�� 3+#�1:�+�46���: 6��= � � ��6���= �C:�+� 7�G �d6���`�K�[��N�R � � � �?�N6�+�� 3+� 7*� �2� � �� �� � ��+�� 3+� 7*� �2� � �� �� � �g+�� 3+� x��y� ���:�����Z����+� 7*� �2� � � ܶ�w�����+� 7*� �2� � � �^��+� 7*� �2� � � ܶ�^��+� 7*� �2� � � ܶ�+z����\��+� 7*� �2� � � ܶ�^��+� 7*� �	2� � � ܶ�+z�������+� 7*� �2� � � ܶ�^��+� 7*� �2� � � ܶ�+z�������W���W���� �.�� :�+� x��2��+� x��2+�� 3�G+� 7*� �2� � �� �� � �'+�� 3+� x���� ���:�����Z����+� 7*� �2� � � ܶ�w�����+� 7*� �2� � � �^��+� 7*� �2� � � ܶ�^��+� 7*� �2� � � ܶ�+z����\��+� 7*� �2� � � ܶ�^��+� 7*� �	2� � � ܶ�+z�������W���W���� �.�� :�+� x��2��+� x��2+�� 3� +�� 3�2+� 7*� �2� � �� �� � �+�� 3+� 7*� �2� � �� �� � ��+�� 3+� x���� ���:�����Z����+� 7*� �2� � � ܶ�w�����+� 7*� �2� � � �^��+� 7*� �2� � � ܶ�^��+� 7*� �2� � � ܶ����+� 7*� �2� � � ܶ�+z����\��+� 7*� �2� � � ܶ�^��+� 7*� �	2� � � ܶ�+z�������+� 7*� �2� � � ܶ�^��+� 7*� �2� � � ܶ�+z�������W���W���� �.�� :�+� x��2��+� x��2+�� 3�c+� 7*� �2� � �� �� � �C+�� 3+� x���� ���:�����Z����+� 7*� �2� � � ܶ�w�����+� 7*� �2� � � �^��+� 7*� �2� � � ܶ�^��+� 7*� �2� � � ܶ����+� 7*� �2� � � ܶ�+z����\��+� 7*� �2� � � ܶ�^��+� 7*� �	2� � � ܶ�+z�������W���W���� �.�� :�+� x��2��+� x��2+�� 3� +�� 3� +�� 3���� &�: ���R W+� 7�j �n� ����R W+� 7�j �n+̶ 3+� x���� ����:����׶���+� 7*� �2� � � ܶ�w�����������W���� �.�� �:+� x��2��+� x��2+�� 3+� x���� ����:����׶���+� 7*� �2� � � ܶ������������W���� �.�� �:+� x��2��+� x��2+�� 3+� x���� ����:��������+� 7*� �2� � � ܶ�������++� 7*� �2� � � ��+� 7*� � 2� � � �������W���� �.�� �:+� x��2��+� x��2+̶ 3+�+� 7*� �2� � � ܶ�w���k� �+�� 3+� x���� ����:����o����+� 7*� �2� � � ܶ�w�������W���� �.�� �:+� x��2��+� x��2+�� 3� +̶ 3� +�� 3+� x���� ����:	�	���	���	�+� 7*� �2� � � ܶ�������	�+z������	�W�	��W�	��� �.�� �:
+� x�	�2�
�+� x�	�2+�� 3+� x���� ����:���������+� 7*� �2� � � ܶ��������+z�������W���W���� �.�� �:+� x��2��+� x��2+�� 3+� x���� ����:���������+� 7*� �2� � � ܶ��������+� 7*� �2� � � ܶ����+z�������W���W���� �.�� �:+� x��2��+� x��2+�� 3+� x���� ����:���������+� 7*� �2� � � ܶ��������+z����������W���W���� �.�� �:+� x��2��+� x��2+̶ 3+� x���� ����:������+� 7*� �2� � � ܶ��������������6�� F+���+�� 3������ �:�� +�"W���� +�"W���� �.�� �:+� x��2��+� x��2+�� 3+� x��˶ ����:��+� 7*� �2� � � ܶ�������Ͷ��Ҷ��Ӷ�����6�� F+���+�� 3������ �:�� +�"W���� +�"W���� �.�� �:+� x��2��+� x��2+̶ 3+� x��ֶ ����:����o����+� 7*� �2� � � ܶ���������W���� �.�� �:+� x��2��+� x��2+ض 3+� �+� x��ڶ �� ��:�� �ܶ�+� 7� =� � �	���6�� g+���+޶ 3����� 2�:����  �:�� +�"W��%���� +�"W��%��(� �.�� �:+� x��2��+� x��2� �: +�5� �+�5+� 3+� �+� x��� �� ��:!�!� �!��!+� 7� =� � �	�!��6"�"� g+�!�"�+� 3�!���� 2�:#�!�#��  �:$�"� +�"W�!�%�$��"� +�"W�!�%�!�(� �.�� �:%+� x�!�2�%�+� x�!�2� �:&+�5�&�+�5+� 3+� x��� ����:'�'���'���'��W�'��� �.�� �:(+� x�'�2�(�+� x�'�2+� 3� +� 3+� 3+� �+� x���� �� ��:)�)� �)���)+� 7� =� � �	�)��6*�*� g+�)�*�+�� 3�)���� 2�:+�)�+��  �:,�*� +�"W�)�%�,��*� +�"W�)�%�)�(� �.�� �:-+� x�)�2�-�+� x�)�2� �:.+�5�.�+�5+�� 3++� 7*� �!2�8 �>� �� � � +�� 3� 
+�� 3+�� 3+ � 3+� 7*� �"2++��� E W+�� 3+� �+� x��� �� ��:/�/� �/��/+� 7� =� � �	�/��60�0� g+�/�0�+� 3�/���� 2�:1�/�1��  �:2�0� +�"W�/�%�2��0� +�"W�/�%�/�(� �.�� �:3+� x�/�2�3�+� x�/�2� �:4+�5�4�+�5+�� 3+� �+� x��� �� ��:5�5� �5��5+� 7� =� � �	�5��66�6� g+�5�6�+� 3�5���� 2�:7�5�7��  �:8�6� +�"W�5�%�8��6� +�"W�5�%�5�(� �.�� �:9+� x�5�2�9�+� x�5�2� �::+�5�:�+�5+�� 3+� �+� 3++�*� �#2�! � ܶ 3+#� 3+++� 7*� �$2�8 ��ĸ ܶ 3+%� 3+++� 7*� �%2�8 ��ĸ ܶ 3+'� 3++� 7*� �"2� � � ܶ 3+)� 3� �:;+�5�;�+�5++� 3� ��		 )�	!	$  �	Z	Z  �	t	t  ���  ��� )�
  �@@  �ZZ  ;;  ���  �		  Q[[  ���  ���  FPP  ���  ���  <FF  ���  ���  2<<  ���  ���  ,66  v��  ���  $$  s}}  ���  �  6]]  u��  ���  +SS  t��  ���  Xhk )Xtw  $��  ��  ���  E))  ��� )���  �&&  �@@  ��� )���  k��  W  m}� )m��  9��  %��  ;KN );WZ  ��  ���   	   ) 	 % (  � ^ ^  � x x   � � � ) � � �   �!,!,   �!F!F  !�!�!� )!�!�!�  !q!�!�  !]""  "{"�"� )"{"�"�  "?"�"�  "+"�"�  #�#�#�  #\$7$7  #Q$T$W )#Q$`$c  #$�$�  #$�$�  %%K%N )%%W%Z  $�%�%�  $�%�%�  &;&t&w )&;&�&�  &&�&�  %�&�&�  &�'2'2  '�((  (e(�(�  ))`)`  )�*/*/  *�++  +=+�+�  +�,],]  ,�-/-/  -k-�-�  ..�.�  .�/]/]  /�/�/�  0K0�0�  11�1�  1�22  2K2�2�  3	3Z3Z  3�44  4�4�4� )4�4�4�  4N4�4�  4:4�4�  5D5�5�  6Q6�6�  66�6�  7N7�7�  7�8#8#  8V8�8�  939|9|  9�:: )9�::  9�:M:M  9�:g:g  :�;;  <=;=;  =�>>  ?
@N@N  @�A�A�  ;|A�A�  B>B�B�  B�C5C5  CrC�C�  DeD�D�  EEwEw  E�F#F#  F`F�F�  G(G�G�  H3HGHG  G�H}H}  II1I1  H�IgIg  I�I�I�  J{J�J� )J{J�J�  J7J�J�  J!KK  K~K�K� )K~K�K�  K:K�K�  K$LL  L;LhLh  L�MM )L�M!M$  L�MhMh  L�M�M�  NdNvNy )NdN�N�  N N�N�  N
N�N�  OfOxO{ )OfO�O�  O"O�O�  OO�O�  PP�P�   �         * +  �  �(   
        6  7 ! a $ z - � 0 � 9 � � � � �U �� �� � �) �5 �� �� �� �	 � �w �� �� �� �� �W �{ �� �� �� �7 �_ �� �� �� � �? �f �� �� �� � �B �a �m �� �� �� �� �' �A �J �d �g �j �p �s �� �� �		 �	� �	� �	� �	� �
 �
 �
 �
  �
# �
K �
q 
�
�
�%.I	L
PVY��������C^ d!h#n$q&�(�)�*+!,;-D._0b1f3l4p6v7y:�<�=�>j@�A�B�C�D�E�GVI\J`MfNjOm_{}~����������������"�J�U�h�k�t������������������?�J�]�`�i������������������5�@�S�V�_��������������������+�6�I�L�Y�]�`������������������������%�0�C�F�o�z�� ���������14>#A.E/H1l2w3�4�5�6�7�8�9�?�_�t�u�w(x+�/�q���������������$�/�M�c�p���������\�
03A7�9�<�@D!GEIHJfMmOpStUwV�Z�`�a�q�r�~:@�D�G�h�����P����q���?��� � �� ��!V�!��"$�"�"��#U�$H�$��%�%?�%��%��&?�&h�&��&��'L�'z�'��'��(�(�(�(L�(u�(��(��(��(��(��)z�)��)��)��*F�*F�*I�*z�*��*��+�+�+�+$�+��+��+��,#�,t�,t�,w�,��,��,��-F�-F�-I�-R�-��.�.-�.Q�.��.��.��.��.��/#�/t�/t�/w�/��0 020[00�0�0�11-1Q1�1�1�	1�222[22�2�2�3t3�3�4/4/43464�55+5T 5x!5"5�5�"5�$68&6a'6�(6�)6�&6�)6�*75-7�/8=18f28�38�18�38�6979�89�;9�=9�A9�C:wE:�G:�H:�I:�J;'G;'J;*L;�N;�O;�P<#Q<GR= S=RP=RS=UT=~U=�V=�W>dX>�U>�X>�Y>�Z>�[>�\?]?>^@3_@e\@e_@h`@�a@�b@�cA�dA�aA�dA�eA�fA�gB#jB�lCWnC�oC�pDnDpDsDJtD�uD�xD�zD�E�ED�EX�E�E��E��E��E��F�FB�FB�FE�Fv�F��F��G
�G
�G�G>�Gd�G~�G��G��G��G��H�H6�H��H��H��H��I �I��I��I��J�J�J�J�K�K��L �L��L��L��L��L��M�M��M��M��M��M��M��N�Nh�O�Oj�P�P��     ) ,- �        �    �     ) ./ �         �    �     ) 01 �        �    �    3    �  �    |*&� �Y��BSYD�BSY��BSYF�BSY��BSYH�BSYJ�BSY��BSYL�BSY	N�BSY
P�BSYR�BSYT�BSYV�BSYX�BSYZ�BSY\�BSY^�BSY`�BSYb�BSYd�BSYf�BSYh�BSYj�BSYl�BSYn�BSYp�BSYr�BSYt�BSYv�BSYx�BSYz�BSY |�BSY!~�BSY"��BSY#��BSY$��BSY%��BS� ��     �    