����   2Z perimeter_configuration_cfm$cf  lucee/runtime/PageImpl  "/admin/perimeter_configuration.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength     Q% getCompileTime  n��� getHash ()IQU� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this  Lperimeter_configuration_cfm$cf;
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Perimeter Configuration</title>
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
                     N</td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="1744" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 1744px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="519">
                              <tr valign="top" align="left">
                                <td width="13" height="12"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                 P<td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Perimeter Checks</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="451">
                              <tr valign="top" align="left">
                                <td width="426" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/perimeter-checks/')"> R�<img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="980">
                        <tr valign="top" align="left">
                          <td width="15" height="10"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="1481"></td>
                          <td width="965"> T m V &lucee/runtime/config/NullSupportHelper X NULL Z '
 Y [ -lucee/runtime/interpreter/VariableInterpreter ] getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; _ `
 ^ a 0 c %lucee/runtime/exp/ExpressionException e java/lang/StringBuilder g The required parameter [ i  1
 h k append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; m n
 h o ] was not provided. q -(Ljava/lang/String;)Ljava/lang/StringBuilder; m s
 h t toString ()Ljava/lang/String; v w
 h x
 f k lucee/runtime/PageContextImpl { any }�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 | � 
 � m2 � step �  

 � show_action � view �  
 �@       _action � ;	 9 � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � ;	 9 � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � �   � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � keys $[Llucee/runtime/type/Collection$Key; � �	  � 

 � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 | � lucee/runtime/tag/Query � #get_postscreen_pipelining_enable_id � setName � 1
 � � A � setDatasource (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � \
select id from parameters where parameter='postscreen_pipelining_enable' and child = '2'
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 | � 	outputEnd � 
 / � )get_postscreen_pipelining_enable_children � )
select * from parameters where parent=' � getCollection � A _ID ;	 9 I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �
 / lucee/runtime/op/Caster
 &(Ljava/lang/Object;)Ljava/lang/String; v
 writePSQ �
 / '' and child = '1' order by order1 asc
 )get_postscreen_non_smtp_command_enable_id b
select id from parameters where parameter='postscreen_non_smtp_command_enable' and child = '2'
 /get_postscreen_non_smtp_command_enable_children %get_postscreen_bare_newline_enable_id ^
select id from parameters where parameter='postscreen_bare_newline_enable' and child = '2'
 +get_postscreen_bare_newline_enable_children !get_postscreen_dnsbl_threshold_id  Z
select id from parameters where parameter='postscreen_dnsbl_threshold' and child = '2'
" 'get_postscreen_dnsbl_threshold_children$ get_message_size_limit_id& f
select id from parameters where parameter='message_size_limit' and child = '2' order by order1 asc
( get_message_size_limit_children* 7' and child = '1' and enabled='1' order by order1 asc
, get_smtpd_helo_required_id. S
select id from parameters where parameter='smtpd_helo_required' and child = '2'
0  get_smtpd_helo_required_children2 #get_smtpd_recipient_restrictions_id4 \
select id from parameters where parameter='smtpd_recipient_restrictions' and child = '2'
6 get_smtpd_milters_id8 M
select id from parameters where parameter='smtpd_milters' and child = '2'
: get_non_smtpd_milters_id< Q
select id from parameters where parameter='non_smtpd_milters' and child = '2'
> get_reject_unauth_destination@ c
select * from parameters where parameter='reject_unauth_destination' and child = '1' and parent='B '
D get_reject_unauth_pipeliningF c
select * from parameters where parameter='reject_unauth_pipelining' and child = '1'  and parent='H get_reject_invalid_hostnameJ a
select * from parameters where parameter='reject_invalid_hostname' and child = '1' and parent='L get_reject_non_fqdn_senderN `
select * from parameters where parameter='reject_non_fqdn_sender' and child = '1' and parent='P  get_reject_unknown_sender_domainR f
select * from parameters where parameter='reject_unknown_sender_domain' and child = '1' and parent='T get_reject_non_fqdn_recipientV c
select * from parameters where parameter='reject_non_fqdn_recipient' and child = '1' and parent='X #get_reject_unknown_recipient_domainZ i
select * from parameters where parameter='reject_unknown_recipient_domain' and child = '1' and parent='\ get_spf^ v
select * from parameters where parameter='check_policy_service unix:private/policy-spf' and child = '1' and parent='` get_dkimb ]
select * from parameters where parameter='inet:127.0.0.1:8891' and child = '1' and parent='d 	get_dmarcf ^
select * from parameters where parameter='inet:127.0.0.1:54321' and child = '1' and parent='h 


j !show_postscreen_pipelining_enablel 'show_postscreen_non_smtp_command_enablen  


p #show_postscreen_bare_newline_enabler show_smtpd_helo_requiredt show_reject_unauth_destinationv show_reject_unauth_pipeliningx show_reject_invalid_hostnamez show_reject_non_fqdn_sender| !show_reject_unknown_sender_domain~ show_reject_non_fqdn_recipient� $show_reject_unknown_recipient_domain� show_spf� 	show_dkim� 
show_dmarc� show_postscreen_dnsbl_threshold�@�       toDouble (D)Ljava/lang/Double;��
� divRef 8(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Double;��
 �� show_message_size_limit�   


� edit� integer� (lucee/runtime/functions/decision/IsValid� B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &�
�� show_postscreen_dnsbl� %
update parameters set 
parameter='� '
where
parent='� #' and child = '1' and enabled='1'
� #lucee/commons/color/ConstantsDouble� _2 Ljava/lang/Double;��	�� _0��	�� _M� ;	 9� >
� 2� float� (Ljava/lang/Object;D)I ��
 �� multiplyRef��
 �� message_size_limit� _3��	�� _4��	�� _1��	�� 






� 3� yes� postscreen_pipelining_enable� H
update parameters set 
parameter='yes',
applied='2'
where
parent='� ' and child = '1'
� no� G
update parameters set 
parameter='no',
applied='2'
where
parent='� "postscreen_non_smtp_command_enable� postscreen_bare_newline_enable� 1� smtpd_helo_required� D
update parameters set 
enabled='1',
applied='2'
where
parent='� D
update parameters set 
enabled='2',
applied='2'
where
parent='� reject_unauth_destination� ~
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_unauth_destination' and child = '1' and parent='� ~
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_unauth_destination' and child = '1' and parent='� reject_unauth_pipelining� }
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_unauth_pipelining' and child = '1' and parent='� }
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_unauth_pipelining' and child = '1' and parent='� reject_invalid_hostname� |
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_invalid_hostname' and child = '1' and parent='� |
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_invalid_hostname' and child = '1' and parent='� reject_non_fqdn_sender� {
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_non_fqdn_sender' and child = '1' and parent='� {
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_non_fqdn_sender' and child = '1' and parent='  reject_unknown_sender_domainr �
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_unknown_sender_domain' and child = '1' and parent=' reject_unknown_sender_domain �
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_unknown_sender_domain' and child = '1' and parent=' reject_non_fqdn_recipient
 ~
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_non_fqdn_recipient' and child = '1' and parent=' ~
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_non_fqdn_recipient' and child = '1' and parent=' reject_unknown_recipient_domain �
update parameters set 
enabled='1',
applied='2'
where
parameter='reject_unknown_recipient_domain' and child = '1' and parent=' �
update parameters set 
enabled='2',
applied='2'
where
parameter='reject_unknown_recipient_domain' and child = '1' and parent=' 



 spf �
update parameters set 
enabled='1',
applied='2'
where
parameter='check_policy_service unix:private/policy-spf' and child = '1' and parent=' �
update parameters set 
enabled='2',
applied='2'
where
parameter='check_policy_service unix:private/policy-spf' and child = '1' and parent=' 	dkimsmtpd x
update parameters set 
enabled='1',
applied='2'
where
parameter='inet:127.0.0.1:8891' and child = '1' and parent='  dkimnonsmtpd" x
update parameters set 
enabled='2',
applied='2'
where
parameter='inet:127.0.0.1:8891' and child = '1' and parent='$ 
dmarcsmtpd& y
update parameters set 
enabled='1',
applied='2'
where
parameter='inet:127.0.0.1:54321' and child = '1' and parent='( dmarcnonsmtpd* y
update parameters set 
enabled='2',
applied='2'
where
parameter='inet:127.0.0.1:54321' and child = '1' and parent=',)

                            <table border="0" cellspacing="0" cellpadding="0" width="965" id="LayoutRegion11" style="height: 1481px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="958">
                                          <table id="Table100" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 1227px;">
                                            <tr style="height: 14px;">
                                              <td width="958" id="Cell1043">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Initital Connection Deep Protocol Tests.@</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 56px;">
                                              <td id="Cell563">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">The following three settings comprise the Initital Connection Deep Protocl Tests. If they are all enabled they are very useful in refusing SMTP connections by zombie senders by performing a series of tests before the sender is allowed to talk to the SMTP service. However, this setting introduces a delay (graylisting) in e-mail delivery and certain legitimate but 0<b><u>incorrectly configured</u></b> e-mail servers do not try to reconnect to deliver their email.. If you have problems receiving emails from legitimate servers, disable <b>ALL three settings</b> below.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1047">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1044">
                                                <p style="margin-bottom: 0px;">2S<span style="color: rgb(0,0,0);"><b><span style="font-size: 12px;">Pipelining Detection</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell1042">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table163" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1021">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              4�<tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">6 }
<input type="radio" checked="checked" name="postscreen_pipelining_enable" value="yes" style="height: 13px; width: 13px;">
8 k
<input type="radio" name="postscreen_pipelining_enable" value="yes" style="height: 13px; width: 13px;">
:#





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="541" id="Cell1022">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        <N</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1023">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">> {
<input type="radio" checked="checked" name="postscreen_pipelining_enable" value="2" style="height: 13px; width: 13px;">
@ j
<input type="radio" name="postscreen_pipelining_enable" value="no" style="height: 13px; width: 13px;">
B






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1024">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    D</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1045">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(0,0,0);"><b><span style="font-size: 12px;">Non SMTP Commands Detection</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell1041">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    F�<td>
                                                      <table id="Table164" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1027">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">H �
<input type="radio" checked="checked" name="postscreen_non_smtp_command_enable" value="yes" style="height: 13px; width: 13px;">
J q
<input type="radio" name="postscreen_non_smtp_command_enable" value="yes" style="height: 13px; width: 13px;">
L#





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="541" id="Cell1028">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        NN</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1029">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">P �
<input type="radio" checked="checked" name="postscreen_non_smtp_command_enable" value="no" style="height: 13px; width: 13px;">
R p
<input type="radio" name="postscreen_non_smtp_command_enable" value="no" style="height: 13px; width: 13px;">
T






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1030">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    V</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1040">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(0,0,0);"><b><span style="font-size: 12px;">Bare New Line Detection</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell1039">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    X�<td>
                                                      <table id="Table165" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell1034">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">Z 
<input type="radio" checked="checked" name="postscreen_bare_newline_enable" value="yes" style="height: 13px; width: 13px;">
\ m
<input type="radio" name="postscreen_bare_newline_enable" value="yes" style="height: 13px; width: 13px;">
^#





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="541" id="Cell1035">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        `N</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1036">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">b ~
<input type="radio" checked="checked" name="postscreen_bare_newline_enable" value="no" style="height: 13px; width: 13px;">
d l
<input type="radio" name="postscreen_bare_newline_enable" value="no" style="height: 13px; width: 13px;">
f






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1037">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    h!</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1046">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1038">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Require HELO</span></b></p>
                                              </td>
                                            </tr>
                                            j�<tr style="height: 28px;">
                                              <td id="Cell564">
                                                <table width="958" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting requires for the incoming email system to start the SMTP session by first sending the HELO or EHLO command before sending the MAIL FROM or ETRN command. Set this setting to Disabled if it starts creating problems with certain homegrown email systems. Otherwise, it is recommended to be set to Enabled.l.</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell565">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table106" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        n<tr style="height: 17px;">
                                                          <td width="55" id="Cell604">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">p r
<input type="radio" checked="checked" name="smtpd_helo_required" value="1" style="height: 13px; width: 13px;">
r `
<input type="radio" name="smtpd_helo_required" value="1" style="height: 13px; width: 13px;">
t9






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="541" id="Cell605">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51); font-weight: normal;">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        vM</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell606">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">x r
<input type="radio" checked="checked" name="smtpd_helo_required" value="2" style="height: 13px; width: 13px;">
z `
<input type="radio" name="smtpd_helo_required" value="2" style="height: 13px; width: 13px;">
|







&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell607">
                                                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    ~-</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell566">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell609">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Unauthorized Domain</span></b></p>
                                              </td>
                                            </tr>
                                            �<tr style="height: 28px;">
                                              <td id="Cell610">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email that is destined for a recipient domain or subdomain thereof&nbsp; that the system does not handle i.e. any domain that is not listed in the Relay Domains (See General Options Above). It is recommended that this settings is set to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                �2</table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell611">
                                                <table width="597" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table107" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell612">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                ��<td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� x
<input type="radio" checked="checked" name="reject_unauth_destination" value="1" style="height: 13px; width: 13px;">
� f
<input type="radio" name="reject_unauth_destination" value="1" style="height: 13px; width: 13px;">
�&







&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="542" id="Cell613">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        �M</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell614">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� x
<input type="radio" checked="checked" name="reject_unauth_destination" value="2" style="height: 13px; width: 13px;">
� f
<input type="radio" name="reject_unauth_destination" value="2" style="height: 13px; width: 13px;">
�






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell615">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    �!</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell608">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell749">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">SPF (Sender Policy Framework Checks)</span></b></p>
                                              </td>
                                            </tr>
                                            �<tr style="height: 28px;">
                                              <td id="Cell752">
                                                <table width="951" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enable/Disable SPF checks on the system. When enabled the system will attempt to identify email spam by detecting whether or not the email is spoofed by verifying that the sender IP address is authorized to send email on behalf of the senders domain.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </�Mtd>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell751">
                                                <table width="595" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table103" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="49" id="Cell579">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  �O<table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� b
<input type="radio" checked="checked" name="spf" value="1" style="height: 13px; width: 13px;">
� P
<input type="radio" name="spf" value="1" style="height: 13px; width: 13px;">
�$






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="546" id="Cell580">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        �M</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell581">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� b
<input type="radio" checked="checked" name="spf" value="2" style="height: 13px; width: 13px;">
� P
<input type="radio" name="spf" value="2" style="height: 13px; width: 13px;">
�






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell582">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    �'</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1108">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1110">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">DKIM (DomainKeys Identified Mail Checks)</span></b></p>
                                              </td>
                                            </tr>
                                            �<tr style="height: 28px;">
                                              <td id="Cell1109">
                                                <table width="951" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enable/Disable DKIM checks on the system. When enabled the system will attempt to verify a domain name identity associated with a message through cryptographic authentication.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            �m<tr style="height: 34px;">
                                              <td id="Cell750">
                                                <table width="595" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table171" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="49" id="Cell1111">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    � �<tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� c
<input type="radio" checked="checked" name="dkim" value="1" style="height: 13px; width: 13px;">
� Q
<input type="radio" name="dkim" value="1" style="height: 13px; width: 13px;">
�%






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="546" id="Cell1112">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        �N</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1113">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� c
<input type="radio" checked="checked" name="dkim" value="2" style="height: 13px; width: 13px;">
� Q
<input type="radio" name="dkim" value="2" style="height: 13px; width: 13px;">
�






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1114">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    �</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1115">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1120">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">DMARC (Domain-based Message Authentication, Reporting and Conformance Checks) <span style="color: rgb(255,0,0);">(Ensure you enable BOTH SPF and DKIM before enabling DMARC)�</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell1121">
                                                <table width="951" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enable/Disable DMARC checks on the system. When enabled the system will leverage SPF and DKIM checks to determine if a message is fraudulent. For this reason, BOTH SPF and DKIM MUST be enabled in order for DMARC to work.</span></p>
                                                    </td>
                                                  �%</tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell1123">
                                                <table width="595" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table172" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="49" id="Cell1124">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              � d
<input type="radio" checked="checked" name="dmarc" value="1" style="height: 13px; width: 13px;">
� R
<input type="radio" name="dmarc" value="1" style="height: 13px; width: 13px;">
�%






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="546" id="Cell1125">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        �N</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1126">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� d
<input type="radio" checked="checked" name="dmarc" value="2" style="height: 13px; width: 13px;">
� R
<input type="radio" name="dmarc" value="2" style="height: 13px; width: 13px;">
�






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell1127">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    �0</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1122">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell617">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Invalid HELO Hostname</span></b></p>
                                              </td>
                                            </tr>
                                            �<tr style="height: 28px;">
                                              <td id="Cell618">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email from a mail server that sends the HELO or EHLO command along with a malformed hostname. It is recommended that this settings is set to Enabled. For best effect of this setting, ensure the Required HELO setting above is also set to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                �2</table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell616">
                                                <table width="595" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table108" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell619">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                � v
<input type="radio" checked="checked" name="reject_invalid_hostname" value="1" style="height: 13px; width: 13px;">
� d
<input type="radio" name="reject_invalid_hostname" value="1" style="height: 13px; width: 13px;">
�&







&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="540" id="Cell620">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        �M</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell621">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� v
<input type="radio" checked="checked" name="reject_invalid_hostname" value="2" style="height: 13px; width: 13px;">
� d
<input type="radio" name="reject_invalid_hostname" value="2" style="height: 13px; width: 13px;">
�






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell622">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    �$</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell623">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell625">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Pipelining</span></b></p>
                                              </td>
                                            </tr>
                                            �,<tr style="height: 28px;">
                                              <td id="Cell626">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email from a mail server that sends SMTP commands where it is not allowed or without waiting for confirmation that the system supports ESMTP commands. This is used by spammers in order to try to speed up delivery of spam email. It is recommended that you set this setting to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                �2</table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell624">
                                                <table width="597" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table109" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell627">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                � w
<input type="radio" checked="checked" name="reject_unauth_pipelining" value="1" style="height: 13px; width: 13px;">
� e
<input type="radio" name="reject_unauth_pipelining" value="1" style="height: 13px; width: 13px;">
�"





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="542" id="Cell628">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        �M</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell629">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� w
<input type="radio" checked="checked" name="reject_unauth_pipelining" value="2" style="height: 13px; width: 13px;">
� e
<input type="radio" name="reject_unauth_pipelining" value="2" style="height: 13px; width: 13px;">
�






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell630">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    �0</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell631">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell633">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Non-FQDN Sender Domain</span></b></p>
                                              </td>
                                            </tr>
                                            �/<tr style="height: 28px;">
                                              <td id="Cell634">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email from a mail server without a FQDN (Fully Qualified Domain Name). Example of a Non-FQDN domain would be: domain.local. It is recommended that you set this setting to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                             </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell632">
                                                <table width="597" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table110" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell635">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                   u
<input type="radio" checked="checked" name="reject_non_fqdn_sender" value="1" style="height: 13px; width: 13px;">
 c
<input type="radio" name="reject_non_fqdn_sender" value="1" style="height: 13px; width: 13px;">
"





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="542" id="Cell636">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        M</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell637">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">
 u
<input type="radio" checked="checked" name="reject_non_fqdn_sender" value="2" style="height: 13px; width: 13px;">
 c
<input type="radio" name="reject_non_fqdn_sender" value="2" style="height: 13px; width: 13px;">







&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell638">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    /</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell639">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell641">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Invalid Sender Domain</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell642">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email from a mail server whose domain as sent in the MAIL FROM command during the SMTP session does not have a DNS A or MX record or has an invalid MX record. It is recommended that you set this setting to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              O</td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell640">
                                                <table width="598" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table112" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell647">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                   {
<input type="radio" checked="checked" name="reject_unknown_sender_domain" value="1" style="height: 13px; width: 13px;">
 i
<input type="radio" name="reject_unknown_sender_domain" value="1" style="height: 13px; width: 13px;">
"





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="543" id="Cell648">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        M</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell649">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;"> {
<input type="radio" checked="checked" name="reject_unknown_sender_domain" value="2" style="height: 13px; width: 13px;">
  i
<input type="radio" name="reject_unknown_sender_domain" value="2" style="height: 13px; width: 13px;">
"






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell650">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    $,</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell651">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell653">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Non-FQDN Recipient</span></b></p>
                                              </td>
                                            </tr>
                                            & <tr style="height: 28px;">
                                              <td id="Cell654">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email destined for a recipient without a FQDN (Fully Qualified Domain Name) as sent in the RCPT TO command of the SMTP session. It is recommended that you set this setting to Enabled.</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              (O</td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell655">
                                                <table width="598" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table113" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell656">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  * x
<input type="radio" checked="checked" name="reject_non_fqdn_recipient" value="1" style="height: 13px; width: 13px;">
, f
<input type="radio" name="reject_non_fqdn_recipient" value="1" style="height: 13px; width: 13px;">
."





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="543" id="Cell657">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        0M</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell658">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">2 x
<input type="radio" checked="checked" name="reject_non_fqdn_recipient" value="2" style="height: 13px; width: 13px;">
4 f
<input type="radio" name="reject_non_fqdn_recipient" value="2" style="height: 13px; width: 13px;">
6






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell659">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    8</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell652">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell661">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Reject Invalid Recipient Domain</span></b></p>
                                              </td>
                                            </:!tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell662">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">If enabled, this setting will reject any incoming email where this system is not the final destination and the email is destined for a recipient domain as specified in the RCPT TO command of the SMTP session that does not have a DNS A or MX Record or an invalid MX record. It is recommended that you set this setting to Enabled.</span></p>
                                                    </td>
                                                  <#</tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell660">
                                                <table width="596" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table114" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                        <tr style="height: 17px;">
                                                          <td width="55" id="Cell663">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              > ~
<input type="radio" checked="checked" name="reject_unknown_recipient_domain" value="1" style="height: 13px; width: 13px;">
@ l
<input type="radio" name="reject_unknown_recipient_domain" value="1" style="height: 13px; width: 13px;">
B"





&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="541" id="Cell664">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><span style="color: rgb(51,51,51);">Enabled</span> <span style="font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        DM</tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell665">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="left">
                                                                  <table width="34" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">F ~
<input type="radio" checked="checked" name="reject_unknown_recipient_domain" value="2" style="height: 13px; width: 13px;">
H l
<input type="radio" name="reject_unknown_recipient_domain" value="2" style="height: 13px; width: 13px;">
J






&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td id="Cell666">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    L</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1032">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell756">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Realtime Block/Allow Lists Threshold Score</span></b></p>
                                              </td>
                                            N</tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell757">
                                                <table width="953" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">This is the score required for&nbsp; the system to block an incoming mail server&#8217;s IP address that has been listed on Real Time Block/Allow List(s). The final outcome of combining the weights of the Real Time Block/Allow Lists must be <b>less</b> than the number specified below in order for the incoming mail server to be allowed to deliver mail to this system. </span></p>
                                                    PX</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell876">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>R �<input type="text" id="FormsEditField39" name="postscreen_dnsbl_threshold" size="30" maxlength="3" style="width: 236px; white-space: pre;" value="T ">V</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell877">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell878">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Message Size Limit</span></b></span></p>
                                              </td>
                                            X</tr>
                                            <tr style="height: 28px;">
                                              <td id="Cell879">
                                                <table width="952" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enter the maximum message size in MB (Megabytes)&nbsp; to be processed by the system. Please note, the larger the limit the more memory required by the system to process the e-mail. Extremely large message sizes can crash the system. Recommended size is 20 MB or lower.</span></p>
                                                    </td>
                                                  </tr>
                                                Z�</table>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell880">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>\ �<input type="text" id="FormsEditField38" name="message_size_limit" size="30" maxlength="3" style="width: 236px; white-space: pre;" value="^/</td>
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
                                        <td height="12"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="953">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              `1<td width="953" id="Cell722">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="hidden" name="action" value="edit">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      b�</table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="965">
                                      <tr valign="top" align="left">
                                        <td width="965" height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="965" id="Text277" class="TextObject">
                                          <p style="margin-bottom: 0px;">dd
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Please enter a valid Message Size Limit</span></i></b></p>
fa
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Please enter a valid RBL Block Score</span></i></b></p>
h�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Saved. Please click on the Apply Settings to apply your changes</span></i></b></p>
j 4lj
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Message Size Limit must be greater than 0</span></i></b></p>
n

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
                      <table border="0" cellspacing="0" cellpadding="0" width="971">
                        <tr valign="top" align="left">
                          <td width="13" height="1"></td>
                          <td width="1"></td>
                          <td width="954"></td>
                          <td width="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="2" valign="middle" width="957"><hr id="HRRule3" width="957" size="1"></td>
                        p9</tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="63"></td>
                          <td colspan="2" width="955">r show_action2t applyv _16x�	�y customtrans{ getrandom_results} 	setResult 1
 �� Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
� inserttrans� stResult� &
insert into salt
(salt)
values
('� getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;��
 /� getId� $
 /� lucee/runtime/type/Query� getCurrentrow (I)I���� getRecordcount� $�� !lucee/runtime/util/NumberIterator� load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� A� isValid (I)Z��
�� current� $
�� go (II)Z���� #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� removeQuery�  A� release &(Llucee/runtime/util/NumberIterator;)V��
�� ')
� gettrans� 2
select salt as customtrans2 from salt where id='� deletetrans� 
delete from salt where id='� getmainparams� �
select distinct(parameter), id, description, child, editable, enabled, conf_file from parameters where enabled='1' and child <> '1' and module='postfix'
� getchildren� 9
select * from parameters where child='1' and parent = '� )' and enabled = '1' order by order1 asc
� insert� N
insert into command 
(command, trans_id)
values
('/usr/sbin/postconf -e "�  = �
 /� toQueryColumn O(Ljava/lang/Object;Llucee/runtime/PageContext;)Llucee/runtime/type/QueryColumn;��
� , � 'lucee/runtime/functions/query/ValueList� a(Llucee/runtime/PageContext;Llucee/runtime/type/QueryColumn;Ljava/lang/String;)Ljava/lang/String; &�
�� "�@$       "lucee/runtime/functions/string/Chr� 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &�
�� ', '� 
getcommand� *
select * from command where trans_id = '� lucee.runtime.tag.FileTag� cffile� lucee/runtime/tag/FileTag� hasBody (Z)V��
�� 0 	setAction� 1
�� /opt/hermes/tmp/� java/lang/String concat &(Ljava/lang/String;)Ljava/lang/String;
 	_apply.sh setFile	 1
�
 ?/bin/cp /etc/postfix/main.cf /etc/postfix/main.cf.HERMES.BACKUP 	setOutput �
� setAddnewline�
�
� �
� � APPEND deletecommand (
delete from command where trans_id = ' /usr/sbin/postfix reload /etc/init.d/postfix restart lucee.runtime.tag.Execute  	cfexecute" lucee/runtime/tag/Execute$ 
/bin/chmod&
% � +x /opt/hermes/tmp/) setArguments+ �
%,@N       
setTimeout (D)V01
%2
% �
% �
% � 	/dev/null7 setOutputfile9 1
%: -inputformat none<@n       delete@     

B updateparamsD 9
update parameters set applied='1' where applied = '2'
F@


                            <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion13" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="9"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="955">
                                        <form name="apply_settings" action="perimeter_configuration.cfm#apply" method="post">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="955" id="Cell753">
                                                H6<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;">J 
getappliedL C
select * from parameters where module='postfix' and applied='2'
N #lucee/runtime/util/VariableUtilImplP recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;RS
QT �
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
V
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Applying settings, please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" disabled="disabled" style="height: 24px; width: 142px;">
X&nbsp;</p>
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
                                    Z-</tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="947" id="Text351" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;">\ 16^_
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
`



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
                        <tr valign="top" align="left">
                          <td width="981" height="12">b �</td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;">d $lucee/runtime/functions/dateTime/Nowf =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &h
gi yyyyk 4lucee/runtime/functions/displayFormatting/DateFormatm S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &o
np 
getversionr D
SELECT value from system_settings where parameter = 'version_no'
t getbuildv B
SELECT value from system_settings where parameter = 'build_no'
x V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway z sessionScope $()Llucee/runtime/type/scope/Session;|}
 /~  lucee/runtime/type/scope/Session�� � 	 Version:� _VALUE� ;	 9�  Build:� . Copyright 2011-� l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>�C
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
 ����� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � SHOW_ACTION� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� #GET_POSTSCREEN_PIPELINING_ENABLE_ID� )GET_POSTSCREEN_NON_SMTP_COMMAND_ENABLE_ID� %GET_POSTSCREEN_BARE_NEWLINE_ENABLE_ID� !GET_POSTSCREEN_DNSBL_THRESHOLD_ID� GET_MESSAGE_SIZE_LIMIT_ID� GET_SMTPD_HELO_REQUIRED_ID� #GET_SMTPD_RECIPIENT_RESTRICTIONS_ID� GET_SMTPD_MILTERS_ID� )GET_POSTSCREEN_PIPELINING_ENABLE_CHILDREN� 	PARAMETER� POSTSCREEN_PIPELINING_ENABLE� !SHOW_POSTSCREEN_PIPELINING_ENABLE� /GET_POSTSCREEN_NON_SMTP_COMMAND_ENABLE_CHILDREN� "POSTSCREEN_NON_SMTP_COMMAND_ENABLE� 'SHOW_POSTSCREEN_NON_SMTP_COMMAND_ENABLE� +GET_POSTSCREEN_BARE_NEWLINE_ENABLE_CHILDREN� POSTSCREEN_BARE_NEWLINE_ENABLE� #SHOW_POSTSCREEN_BARE_NEWLINE_ENABLE�  GET_SMTPD_HELO_REQUIRED_CHILDREN� ENABLED� SMTPD_HELO_REQUIRED� SHOW_SMTPD_HELO_REQUIRED� GET_REJECT_UNAUTH_DESTINATION� REJECT_UNAUTH_DESTINATION� SHOW_REJECT_UNAUTH_DESTINATION� GET_REJECT_UNAUTH_PIPELINING� REJECT_UNAUTH_PIPELINING� SHOW_REJECT_UNAUTH_PIPELINING� GET_REJECT_INVALID_HOSTNAME� REJECT_INVALID_HOSTNAME� SHOW_REJECT_INVALID_HOSTNAME� GET_REJECT_NON_FQDN_SENDER� REJECT_NON_FQDN_SENDER� SHOW_REJECT_NON_FQDN_SENDER�  GET_REJECT_UNKNOWN_SENDER_DOMAIN� REJECT_UNKNOWN_SENDER_DOMAIN� !SHOW_REJECT_UNKNOWN_SENDER_DOMAIN� GET_REJECT_NON_FQDN_RECIPIENT� REJECT_NON_FQDN_RECIPIENT� SHOW_REJECT_NON_FQDN_RECIPIENT� #GET_REJECT_UNKNOWN_RECIPIENT_DOMAIN� REJECT_UNKNOWN_RECIPIENT_DOMAIN� $SHOW_REJECT_UNKNOWN_RECIPIENT_DOMAIN� GET_SPF� SPF SHOW_SPF GET_DKIM dkim DKIM	 	SHOW_DKIM 	GET_DMARC dmarc DMARC 
SHOW_DMARC 'GET_POSTSCREEN_DNSBL_THRESHOLD_CHILDREN postscreen_dnsbl_threshold POSTSCREEN_DNSBL_THRESHOLD SHOW_POSTSCREEN_DNSBL_THRESHOLD MESSAGE_SIZE1 GET_MESSAGE_SIZE_LIMIT_CHILDREN MESSAGE_SIZE2! MESSAGE_SIZE_LIMIT# SHOW_MESSAGE_SIZE_LIMIT% STEP' MESSAGE_SIZE_LIMIT1) MESSAGE_SIZE_LIMIT2+ GET_NON_SMTPD_MILTERS_ID- action2/ ACTION21 SHOW_ACTION23 M25 RANDOM7 STRESULT9 GENERATED_KEY; CUSTOMTRANS3= GETTRANS? CUSTOMTRANS2A GETMAINPARAMSC GETCHILDRENE COMMANDG 
GETAPPLIEDI THEYEARK EDITIONM 
GETVERSIONO GETBUILDQ subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ST       U   *     *� 
*� *� � *����*+���        U         �        U        � �        U         �        U         �         U         !�      # $ U        %�      & ' U  �� _  ��+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+S� 3+U� 3+W+� \� bM>+� \,� .dY:� !� fY� hYj� lW� pr� u� y� z�M>+� |~W,  � �+�� 3+�+� \� b:6+� \� 0dY:� !� fY� hYj� l�� pr� u� y� z�:6+� |~�  � �+�� 3+�+� \� b:6	+� \� 0dY:
� !� fY� hYj� l�� pr� u� y� z�
:6	+� |~�  	� �+�� 3+�+� \� b:6+� \� 0�Y:� !� fY� hYj� l�� pr� u� y� z�:6+� |~�  � �+�� 3+ �� �� �� ��� �� � � T+�� 3+� �� �� � �� �� � � .+�� 3+� 7*� �2+� �� �� � � E W+�� 3� � +�� 3+� �+� |��� �� �:Ͷ �+� 7� =� � � �� �6� N+� �+޶ 3� ����� $:� � :� +� �W� ��� +� �W� �� �� � ��� :+� |� ��+� |� �� :+� ��+� �+�� 3+� �+� |��� �� �:�� �+� 7� =� � � �� �6� s+� �+ � 3+++� 7*� �2� ��	��+� 3� ���ϧ $:� � :� +� �W� ��� +� �W� �� �� � ��� :+� |� ��+� |� �� :+� ��+� �+�� 3+� �+� |��� �� �:� �+� 7� =� � � �� �6� O+� �+� 3� ���� $:� � :� +� �W� ��� +� �W� �� �� � ��� :+� |� ��+� |� �� :+� ��+� �+�� 3+� �+� |��� �� �:  � � +� 7� =� � � � � �6!!� s+ !� �+ � 3+++� 7*� �2� ��	��+� 3 � ���ϧ $:" "� � :#!� +� �W � �#�!� +� �W � � � �� � ��� :$+� | � �$�+� | � �� :%+� �%�+� �+�� 3+� �+� |��� �� �:&&� �&+� 7� =� � � �&� �6''� O+&'� �+� 3&� ���� $:(&(� � :)'� +� �W&� �)�'� +� �W&� �&� �� � ��� :*+� |&� �*�+� |&� �� :++� �+�+� �+�� 3+� �+� |��� �� �:,,� �,+� 7� =� � � �,� �6--� s+,-� �+ � 3+++� 7*� �2� ��	��+� 3,� ���ϧ $:.,.� � :/-� +� �W,� �/�-� +� �W,� �,� �� � ��� :0+� |,� �0�+� |,� �� :1+� �1�+� �+�� 3+� �+� |��� �� �:22!� �2+� 7� =� � � �2� �633� O+23� �+#� 32� ���� $:424� � :53� +� �W2� �5�3� +� �W2� �2� �� � ��� :6+� |2� �6�+� |2� �� :7+� �7�+� �+�� 3+� �+� |��� �� �:88%� �8+� 7� =� � � �8� �699� s+89� �+ � 3+++� 7*� �2� ��	��+� 38� ���ϧ $::8:� � :;9� +� �W8� �;�9� +� �W8� �8� �� � ��� :<+� |8� �<�+� |8� �� :=+� �=�+� �+�� 3+� �+� |��� �� �:>>'� �>+� 7� =� � � �>� �6??� O+>?� �+)� 3>� ���� $:@>@� � :A?� +� �W>� �A�?� +� �W>� �>� �� � ��� :B+� |>� �B�+� |>� �� :C+� �C�+� �+�� 3+� �+� |��� �� �:DD+� �D+� 7� =� � � �D� �6EE� s+DE� �+ � 3+++� 7*� �2� ��	��+-� 3D� ���ϧ $:FDF� � :GE� +� �WD� �G�E� +� �WD� �D� �� � ��� :H+� |D� �H�+� |D� �� :I+� �I�+� �+�� 3+� �+� |��� �� �:JJ/� �J+� 7� =� � � �J� �6KK� O+JK� �+1� 3J� ���� $:LJL� � :MK� +� �WJ� �M�K� +� �WJ� �J� �� � ��� :N+� |J� �N�+� |J� �� :O+� �O�+� �+�� 3+� �+� |��� �� �:PP3� �P+� 7� =� � � �P� �6QQ� t+PQ� �+ � 3+++� 7*� �2� ��	��+� 3P� ���Χ $:RPR� � :SQ� +� �WP� �S�Q� +� �WP� �P� �� � ��� :T+� |P� �T�+� |P� �� :U+� �U�+� �+�� 3+� �+� |��� �� �:VV5� �V+� 7� =� � � �V� �6WW� O+VW� �+7� 3V� ���� $:XVX� � :YW� +� �WV� �Y�W� +� �WV� �V� �� � ��� :Z+� |V� �Z�+� |V� �� :[+� �[�+� �+�� 3+� �+� |��� �� �:\\9� �\+� 7� =� � � �\� �6]]� O+\]� �+;� 3\� ���� $:^\^� � :_]� +� �W\� �_�]� +� �W\� �\� �� � ��� :`+� |\� �`�+� |\� �� :a+� �a�+� �+�� 3+� �+� |��� �� �:bb=� �b+� 7� =� � � �b� �6cc� O+bc� �+?� 3b� ���� $:dbd� � :ec� +� �Wb� �e�c� +� �Wb� �b� �� � ��� :f+� |b� �f�+� |b� �� :g+� �g�+� �+�� 3+� �+� |��� �� �:hhA� �h+� 7� =� � � �h� �6ii� t+hi� �+C� 3+++� 7*� �2� ��	��+E� 3h� ���Χ $:jhj� � :ki� +� �Wh� �k�i� +� �Wh� �h� �� � ��� :l+� |h� �l�+� |h� �� :m+� �m�+� �+�� 3+� �+� |��� �� �:nnG� �n+� 7� =� � � �n� �6oo� t+no� �+I� 3+++� 7*� �2� ��	��+E� 3n� ���Χ $:pnp� � :qo� +� �Wn� �q�o� +� �Wn� �n� �� � ��� :r+� |n� �r�+� |n� �� :s+� �s�+� �+�� 3+� �+� |��� �� �:ttK� �t+� 7� =� � � �t� �6uu� t+tu� �+M� 3+++� 7*� �2� ��	��+E� 3t� ���Χ $:vtv� � :wu� +� �Wt� �w�u� +� �Wt� �t� �� � ��� :x+� |t� �x�+� |t� �� :y+� �y�+� �+�� 3+� �+� |��� �� �:zzO� �z+� 7� =� � � �z� �6{{� t+z{� �+Q� 3+++� 7*� �2� ��	��+E� 3z� ���Χ $:|z|� � :}{� +� �Wz� �}�{� +� �Wz� �z� �� � ��� :~+� |z� �~�+� |z� �� :+� ��+� �+�� 3+� �+� |��� �� �:��S� ��+� 7� =� � � ��� �6��� t+��� �+U� 3+++� 7*� �2� ��	��+E� 3�� ���Χ $:���� � :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� |�� ���+� |�� �� :�+� ���+� �+�� 3+� �+� |��� �� �:��W� ��+� 7� =� � � ��� �6��� t+��� �+Y� 3+++� 7*� �2� ��	��+E� 3�� ���Χ $:���� � :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� |�� ���+� |�� �� :�+� ���+� �+�� 3+� �+� |��� �� �:��[� ��+� 7� =� � � ��� �6��� t+��� �+]� 3+++� 7*� �2� ��	��+E� 3�� ���Χ $:���� � :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� |�� ���+� |�� �� :�+� ���+� �+�� 3+� �+� |��� �� �:��_� ��+� 7� =� � � ��� �6��� t+��� �+a� 3+++� 7*� �2� ��	��+E� 3�� ���Χ $:���� � :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� |�� ���+� |�� �� :�+� ���+� �+�� 3+� �+� |��� �� �:��c� ��+� 7� =� � � ��� �6��� t+��� �+e� 3+++� 7*� �2� ��	��+E� 3�� ���Χ $:���� � :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� |�� ���+� |�� �� :�+� ���+� �+�� 3+� �+� |��� �� �:��g� ��+� 7� =� � � ��� �6��� t+��� �+i� 3+++� 7*� �2� ��	��+E� 3�� ���Χ $:���� � :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� |�� ���+� |�� �� :�+� ���+� �+k� 3+m+� \� b:�6�+� \�� J++� 7*� �	2� *� �
2�	Y:�� "� fY� hYj� lm� pr� u� y� z��:�6�+� |~m�  �� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+o+� \� b:�6�+� \�� J++� 7*� �2� *� �
2�	Y:�� "� fY� hYj� lo� pr� u� y� z��:�6�+� |~o�  �� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +q� 3+s+� \� b:�6�+� \�� J++� 7*� �2� *� �
2�	Y:�� "� fY� hYj� ls� pr� u� y� z��:�6�+� |~s�  �� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+u+� \� b:�6�+� \�� J++� 7*� �2� *� �2�	Y:�� "� fY� hYj� lu� pr� u� y� z��:�6�+� |~u�  �� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+w+� \� b:�6�+� \�� J++� 7*� �2� *� �2�	Y:�� "� fY� hYj� lw� pr� u� y� z��:�6�+� |~w�  �� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+y+� \� b:�6�+� \�� J++� 7*� �2� *� �2�	Y:�� "� fY� hYj� ly� pr� u� y� z��:�6�+� |~y�  �� �+�� 3+ �*� � 2� �� ��� �� � � ]+�� 3+� �*� �!2� � �� �� � � 3+�� 3+� 7*� �"2+� �*� �!2� � � E W+�� 3� � +�� 3+{+� \� b:�6�+� \�� J++� 7*� �#2� *� �2�	Y:�� "� fY� hYj� l{� pr� u� y� z��:�6�+� |~{�  �� �+�� 3+ �*� �$2� �� ��� �� � � ]+�� 3+� �*� �%2� � �� �� � � 3+�� 3+� 7*� �&2+� �*� �%2� � � E W+�� 3� � +�� 3+}+� \� b:�6�+� \�� J++� 7*� �'2� *� �2�	Y:�� "� fY� hYj� l}� pr� u� y� z��:�6�+� |~}�  �� �+�� 3+ �*� �(2� �� ��� �� � � ]+�� 3+� �*� �)2� � �� �� � � 3+�� 3+� 7*� �*2+� �*� �)2� � � E W+�� 3� � +�� 3++� \� b:�6�+� \�� J++� 7*� �+2� *� �2�	Y:�� "� fY� hYj� l� pr� u� y� z��:�6�+� |~�  �� �+�� 3+ �*� �,2� �� ��� �� � � ]+�� 3+� �*� �-2� � �� �� � � 3+�� 3+� 7*� �.2+� �*� �-2� � � E W+�� 3� � +�� 3+�+� \� b:�6�+� \�� J++� 7*� �/2� *� �2�	Y:�� "� fY� hYj� l�� pr� u� y� z��:�6�+� |~��  �� �+�� 3+ �*� �02� �� ��� �� � � ]+�� 3+� �*� �12� � �� �� � � 3+�� 3+� 7*� �22+� �*� �12� � � E W+�� 3� � +q� 3+�+� \� b:�6�+� \¦ J++� 7*� �32� *� �2�	Y:�� "� fY� hYj� l�� pr� u� y� z��:�6�+� |~��  ö �+�� 3+ �*� �42� �� ��� �� � � ]+�� 3+� �*� �52� � �� �� � � 3+�� 3+� 7*� �62+� �*� �52� � � E W+�� 3� � +�� 3+�+� \� b:�6�+� \Ŧ J++� 7*� �72� *� �2�	Y:�� "� fY� hYj� l�� pr� u� y� z��:�6�+� |~��  ƶ �+�� 3+ �*� �82� �� ��� �� � � ]+�� 3+� �*� �92� � �� �� � � 3+�� 3+� 7*� �:2+� �*� �92� � � E W+�� 3� � +�� 3+�+� \� b:�6�+� \Ȧ J++� 7*� �;2� *� �2�	Y:�� "� fY� hYj� l�� pr� u� y� z��:�6�+� |~��  ɶ �+�� 3+ �*� �<2� �� ��� �� � � ]+�� 3+� �*� �=2� � �� �� � � 3+�� 3+� 7*� �>2+� �*� �=2� � � E W+�� 3� � +�� 3+�+� \� b:�6�+� \˦ J++� 7*� �?2� *� �2�	Y:�� "� fY� hYj� l�� pr� u� y� z��:�6�+� |~��  ̶ �+�� 3+ �*� �@2� �� ��� �� � � ]+�� 3+� �*� �A2� � �� �� � � 3+�� 3+� 7*� �B2+� �*� �A2� � � E W+�� 3� � +�� 3+�+� \� b:�6�+� \Φ J++� 7*� �C2� *� �
2�	Y:�� "� fY� hYj� l�� pr� u� y� z��:�6�+� |~��  ϶ �+�� 3+ �*� �D2� �� ��� �� � � ]+�� 3+� �*� �E2� � �� �� � � 3+�� 3+� 7*� �F2+� �*� �E2� � � E W+�� 3� � +�� 3+� 7*� �G2++� 7*� �H2� *� �
2�	������ E W+�� 3+� 7*� �I2+� 7*� �G2� � ������ E W+�� 3+�+� \� b:�6�+� \Ѧ ?+� 7*� �I2� � Y:�� "� fY� hYj� l�� pr� u� y� z��:�6�+� |~��  Ҷ �+�� 3+ �*� �J2� �� ��� �� � � ]+�� 3+� �*� �K2� � �� �� � � 3+�� 3+� 7*� �L2+� �*� �K2� � � E W+�� 3� � +�� 3+� 7*� �2� � �� �� � �,�+�� 3+� 7*� �F2� � �� �� � ��+�� 3+�+� 7*� �F2� � ���-+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � �Զ �6��� �+�ն �+�� 3++� 7*� �F2� � ��+�� 3+++� 7*� �2� ��	��+�� 3Զ ����� $:��ֶ � :��� +� �WԶ �׿�� +� �WԶ �Զ �� � ��� :�+� |Զ �ؿ+� |Զ �� :�+� �ٿ+� �+�� 3+� 7*� �M2��� E W+�� 3� 9+�� 3+� 7*� �M2��� E W+�� 3+� 7����� E W+�� 3+�� 3� ^+� 7*� �F2� � �� �� � � =+�� 3+� 7*� �M2��� E W+�� 3+� 7����� E W+�� 3� +�� 3+� 7*� �M2� � �� �� � ��+�� 3+�+� 7*� �L2� � ���+�� 3+� 7*� �L2� � ��� � ��+�� 3+� 7*� �N2+� 7*� �L2� � ����¹ E W+�� 3+� 7*� �O2+� 7*� �N2� � ����¹ E W+�� 3+� �+� |��� �� �:��Ķ ��+� 7� =� � � �ڶ �6��� �+�۶ �+�� 3++� 7*� �O2� � ��+�� 3+++� 7*� �2� ��	��+�� 3ڶ ����� $:��ܶ � :��� +� �Wڶ �ݿ�� +� �Wڶ �ڶ �� � ��� :�+� |ڶ �޿+� |ڶ �� :�+� �߿+� �+�� 3+� 7*� �M2�ǹ E W+�� 3� \+� 7*� �L2� � ��� � � <+�� 3+� 7*� �M2��� E W+�� 3+� 7���ʹ E W+�� 3� +�� 3� ^+�+� 7*� �L2� � ��� � � <+�� 3+� 7*� �M2��� E W+�� 3+� 7���͹ E W+�� 3� +�� 3� +϶ 3+� 7*� �M2� � Ѹ �� � �'�+�� 3+� 7*� �2� � Ӹ �� � � �+�� 3+� �+� |��� �� �:��ն ��+� 7� =� � � �� �6��� s+�� �+׶ 3+++� 7*� �2� ��	��+ٶ 3� ���ϧ $:��� � :��� +� �W� ���� +� �W� �� �� � ��� :�+� |� ��+� |� �� :�+� ��+� �+�� 3�+� 7*� �2� � ۸ �� � � �+�� 3+� �+� |��� �� �:��ն ��+� 7� =� � � �� �6��� s+�� �+ݶ 3+++� 7*� �2� ��	��+ٶ 3� ���ϧ $:��� � :��� +� �W� ���� +� �W� �� �� � ��� :�+� |� ��+� |� �� :�+� ��+� �+�� 3� +�� 3+� 7*� �2� � Ӹ �� � � �+�� 3+� �+� |��� �� �:��߶ ��+� 7� =� � � �� �6��� s+��� �+׶ 3+++� 7*� �2� ��	��+ٶ 3� ���ϧ $:��� � :��� +� �W� ���� +� �W� �� �� � ��� :�+� |� ��+� |� �� :�+� ��+� �+�� 3�+� 7*� �2� � ۸ �� � � �+�� 3+� �+� |��� �� �:��߶ ��+� 7� =� � � �� �6��� s+�� �+ݶ 3+++� 7*� �2� ��	��+ٶ 3� ���ϧ $:���� � :��� +� �W� ����� +� �W� �� �� � ��� :�+� |� ���+� |� �� :�+� ���+� �+�� 3� +�� 3+� 7*� �2� � Ӹ �� � � �+�� 3+� �+� |��� �� �:��� ��+� 7� =� � � ��� �6��� s+��� �+׶ 3+++� 7*� �2� ��	��+ٶ 3�� ���ϧ $:���� � :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� |�� ���+� |�� �� :�+� ���+� �+�� 3�'+� 7*� �2� � ۸ �� � �+�� 3+� �+� |��� �� �:��� ��+� 7� =� � � ��� �6��� {+��� �+ݶ 3+++� 7*� �2� ��	��+ٶ 3�� ���ϧ ,�: �� � � �:�� +� �W�� ����� +� �W�� ��� �� � ��� �:+� |�� ���+� |�� �� �:+� ���+� �+�� 3� +k� 3+� 7*� �2� � � �� � �(+�� 3+� �+� |��� �� ��:�� ��+� 7� =� � � ��� ��6�� �+��� �+� 3+++� 7*� �2� ��	��+ٶ 3�� ���̧ 2�:��� �  �:�� +� �W�� ����� +� �W�� ��� �� � ��� �:+� |�� ���+� |�� �� �:	+� ��	�+� �+�� 3�J+� 7*� �2� � � �� � �(+�� 3+� �+� |��� �� ��:
�
� ��
+� 7� =� � � ��
� ��6�� �+�
�� �+� 3+++� 7*� �2� ��	��+ٶ 3�
� ���̧ 2�:�
�� �  �:�� +� �W�
� ����� +� �W�
� ��
� �� � ��� �:+� |�
� ���+� |�
� �� �:+� ���+� �+�� 3� +k� 3+� 7*� �2� � � �� � �(+�� 3+� �+� |��� �� ��:�� ��+� 7� =� � � ��� ��6�� �+��� �+�� 3+++� 7*� �2� ��	��+E� 3�� ���̧ 2�:��� �  �:�� +� �W�� ����� +� �W�� ��� �� � ��� �:+� |�� ���+� |�� �� �:+� ���+� �+�� 3�J+� 7*� �2� � � �� � �(+�� 3+� �+� |��� �� ��:�� ��+� 7� =� � � ��� ��6�� �+��� �+� 3+++� 7*� �2� ��	��+E� 3�� ���̧ 2�:��� �  �:�� +� �W�� ����� +� �W�� ��� �� � ��� �:+� |�� ���+� |�� �� �:+� ���+� �+�� 3� +�� 3+� 7*� �"2� � � �� � �(+�� 3+� �+� |��� �� ��:�� ��+� 7� =� � � ��� ��6�� �+��� �+� 3+++� 7*� �2� ��	��+E� 3�� ���̧ 2�:��� �  �:�� +� �W�� ����� +� �W�� ��� �� � ��� �: +� |�� �� �+� |�� �� �:!+� ��!�+� �+�� 3�J+� 7*� �"2� � � �� � �(+�� 3+� �+� |��� �� ��:"�"� ��"+� 7� =� � � ��"� ��6#�#� �+�"�#� �+�� 3+++� 7*� �2� ��	��+E� 3�"� ���̧ 2�:$�"�$� �  �:%�#� +� �W�"� ��%��#� +� �W�"� ��"� �� � ��� �:&+� |�"� ��&�+� |�"� �� �:'+� ��'�+� �+�� 3� +�� 3+� 7*� �&2� � � �� � �(+�� 3+� �+� |��� �� ��:(�(�� ��(+� 7� =� � � ��(� ��6)�)� �+�(�)� �+�� 3+++� 7*� �2� ��	��+E� 3�(� ���̧ 2�:*�(�*� �  �:+�)� +� �W�(� ��+��)� +� �W�(� ��(� �� � ��� �:,+� |�(� ��,�+� |�(� �� �:-+� ��-�+� �+�� 3�J+� 7*� �&2� � � �� � �(+�� 3+� �+� |��� �� ��:.�.�� ��.+� 7� =� � � ��.� ��6/�/� �+�.�/� �+�� 3+++� 7*� �2� ��	��+E� 3�.� ���̧ 2�:0�.�0� �  �:1�/� +� �W�.� ��1��/� +� �W�.� ��.� �� � ��� �:2+� |�.� ��2�+� |�.� �� �:3+� ��3�+� �+�� 3� +�� 3+� 7*� �*2� � � �� � �(+�� 3+� �+� |��� �� ��:4�4�� ��4+� 7� =� � � ��4� ��65�5� �+�4�5� �+�� 3+++� 7*� �2� ��	��+E� 3�4� ���̧ 2�:6�4�6� �  �:7�5� +� �W�4� ��7��5� +� �W�4� ��4� �� � ��� �:8+� |�4� ��8�+� |�4� �� �:9+� ��9�+� �+�� 3�J+� 7*� �*2� � � �� � �(+�� 3+� �+� |��� �� ��::�:�� ��:+� 7� =� � � ��:� ��6;�;� �+�:�;� �+� 3+++� 7*� �2� ��	��+E� 3�:� ���̧ 2�:<�:�<� �  �:=�;� +� �W�:� ��=��;� +� �W�:� ��:� �� � ��� �:>+� |�:� ��>�+� |�:� �� �:?+� ��?�+� �+�� 3� +�� 3+� 7*� �.2� � � �� � �(+�� 3+� �+� |��� �� ��:@�@� ��@+� 7� =� � � ��@� ��6A�A� �+�@�A� �+� 3+++� 7*� �2� ��	��+E� 3�@� ���̧ 2�:B�@�B� �  �:C�A� +� �W�@� ��C��A� +� �W�@� ��@� �� � ��� �:D+� |�@� ��D�+� |�@� �� �:E+� ��E�+� �+�� 3�J+� 7*� �.2� � � �� � �(+�� 3+� �+� |��� �� ��:F�F� ��F+� 7� =� � � ��F� ��6G�G� �+�F�G� �+	� 3+++� 7*� �2� ��	��+E� 3�F� ���̧ 2�:H�F�H� �  �:I�G� +� �W�F� ��I��G� +� �W�F� ��F� �� � ��� �:J+� |�F� ��J�+� |�F� �� �:K+� ��K�+� �+�� 3� +�� 3+� 7*� �22� � � �� � �(+�� 3+� �+� |��� �� ��:L�L� ��L+� 7� =� � � ��L� ��6M�M� �+�L�M� �+� 3+++� 7*� �2� ��	��+E� 3�L� ���̧ 2�:N�L�N� �  �:O�M� +� �W�L� ��O��M� +� �W�L� ��L� �� � ��� �:P+� |�L� ��P�+� |�L� �� �:Q+� ��Q�+� �+�� 3�J+� 7*� �22� � � �� � �(+�� 3+� �+� |��� �� ��:R�R� ��R+� 7� =� � � ��R� ��6S�S� �+�R�S� �+� 3+++� 7*� �2� ��	��+E� 3�R� ���̧ 2�:T�R�T� �  �:U�S� +� �W�R� ��U��S� +� �W�R� ��R� �� � ��� �:V+� |�R� ��V�+� |�R� �� �:W+� ��W�+� �+�� 3� +�� 3+� 7*� �62� � � �� � �(+�� 3+� �+� |��� �� ��:X�X� ��X+� 7� =� � � ��X� ��6Y�Y� �+�X�Y� �+� 3+++� 7*� �2� ��	��+E� 3�X� ���̧ 2�:Z�X�Z� �  �:[�Y� +� �W�X� ��[��Y� +� �W�X� ��X� �� � ��� �:\+� |�X� ��\�+� |�X� �� �:]+� ��]�+� �+�� 3�J+� 7*� �62� � � �� � �(+�� 3+� �+� |��� �� ��:^�^� ��^+� 7� =� � � ��^� ��6_�_� �+�^�_� �+� 3+++� 7*� �2� ��	��+E� 3�^� ���̧ 2�:`�^�`� �  �:a�_� +� �W�^� ��a��_� +� �W�^� ��^� �� � ��� �:b+� |�^� ��b�+� |�^� �� �:c+� ��c�+� �+�� 3� +� 3+� 7*� �:2� � � �� � �(+�� 3+� �+� |��� �� ��:d�d� ��d+� 7� =� � � ��d� ��6e�e� �+�d�e� �+� 3+++� 7*� �2� ��	��+E� 3�d� ���̧ 2�:f�d�f� �  �:g�e� +� �W�d� ��g��e� +� �W�d� ��d� �� � ��� �:h+� |�d� ��h�+� |�d� �� �:i+� ��i�+� �+�� 3�K+� 7*� �:2� � � �� � �)+�� 3+� �+� |��� �� ��:j�j� ��j+� 7� =� � � ��j� ��6k�k� �+�j�k� �+� 3+++� 7*� �2� ��	��+E� 3�j� ���̧ 2�:l�j�l� �  �:m�k� +� �W�j� ��m��k� +� �W�j� ��j� �� � ��� �:n+� |�j� ��n�+� |�j� �� �:o+� ��o�+� �+k� 3� +� 3+� 7*� �>2� � � �� � �D+�� 3+� �+� |��� �� ��:p�p� ��p+� 7� =� � � ��p� ��6q�q� �+�p�q� �+!� 3+++� 7*� �2� ��	��+E� 3�p� ���̧ 2�:r�p�r� �  �:s�q� +� �W�p� ��s��q� +� �W�p� ��p� �� � ��� �:t+� |�p� ��t�+� |�p� �� �:u+� ��u�+� �+�� 3+� �+� |��� �� ��:v�v#� ��v+� 7� =� � � ��v� ��6w�w� �+�v�w� �+!� 3+++� 7*� �P2� ��	��+E� 3�v� ���̧ 2�:x�v�x� �  �:y�w� +� �W�v� ��y��w� +� �W�v� ��v� �� � ��� �:z+� |�v� ��z�+� |�v� �� �:{+� ��{�+� �+�� 3�g+� 7*� �>2� � � �� � �E+�� 3+� �+� |��� �� ��:|�|� ��|+� 7� =� � � ��|� ��6}�}� �+�|�}� �+%� 3+++� 7*� �2� ��	��+E� 3�|� ���̧ 2�:~�|�~� �  �:�}� +� �W�|� ����}� +� �W�|� ��|� �� � ��� �:�+� |�|� ����+� |�|� �� �:�+� ����+� �+�� 3+� �+� |��� �� ��:���#� ���+� 7� =� � � ���� ��6���� �+����� �+%� 3+++� 7*� �P2� ��	��+E� 3��� ���̧ 2�:������ �  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� |��� ����+� |��� �� �:�+� ����+� �+k� 3� +� 3+� 7*� �B2� � � �� � �D+�� 3+� �+� |��� �� ��:���'� ���+� 7� =� � � ���� ��6���� �+����� �+)� 3+++� 7*� �2� ��	��+E� 3��� ���̧ 2�:������ �  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� |��� ����+� |��� �� �:�+� ����+� �+�� 3+� �+� |��� �� ��:���+� ���+� 7� =� � � ���� ��6���� �+����� �+)� 3+++� 7*� �P2� ��	��+E� 3��� ���̧ 2�:������ �  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� |��� ����+� |��� �� �:�+� ����+� �+�� 3�g+� 7*� �B2� � � �� � �E+�� 3+� �+� |��� �� ��:���'� ���+� 7� =� � � ���� ��6���� �+����� �+-� 3+++� 7*� �2� ��	��+E� 3��� ���̧ 2�:������ �  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� |��� ����+� |��� �� �:�+� ����+� �+�� 3+� �+� |��� �� ��:���+� ���+� 7� =� � � ���� ��6���� �+����� �+-� 3+++� 7*� �P2� ��	��+E� 3��� ���̧ 2�:������ �  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� |��� ����+� |��� �� �:�+� ����+� �+k� 3� +k� 3+� 7���ǹ E W+k� 3� +k� 3� +/� 3+1� 3+3� 3+5� 3+7� 3+� 7*� �2� � Ӹ �� � � 1+�� 3+� �+9� 3� �:�+� ����+� �+�� 3� S+� 7*� �2� � Ӹ �� � � 1+�� 3+� �+;� 3� �:�+� ����+� �+�� 3� +=� 3+?� 3+� 7*� �2� � ۸ �� � � 1+�� 3+� �+A� 3� �:�+� ����+� �+�� 3� S+� 7*� �2� � ۸ �� � � 1+�� 3+� �+C� 3� �:�+� ����+� �+�� 3� +E� 3+G� 3+I� 3+� 7*� �2� � Ӹ �� � � 1+�� 3+� �+K� 3� �:�+� ����+� �+�� 3� S+� 7*� �2� � Ӹ �� � � 1+�� 3+� �+M� 3� �:�+� ����+� �+�� 3� +O� 3+Q� 3+� 7*� �2� � ۸ �� � � 1+�� 3+� �+S� 3� �:�+� ����+� �+�� 3� S+� 7*� �2� � ۸ �� � � 1+�� 3+� �+U� 3� �:�+� ����+� �+�� 3� +W� 3+Y� 3+[� 3+� 7*� �2� � Ӹ �� � � 1+�� 3+� �+]� 3� �:�+� ����+� �+�� 3� S+� 7*� �2� � Ӹ �� � � 1+�� 3+� �+_� 3� �:�+� ����+� �+�� 3� +a� 3+c� 3+� 7*� �2� � ۸ �� � � 1+�� 3+� �+e� 3� �:�+� ����+� �+�� 3� S+� 7*� �2� � ۸ �� � � 1+�� 3+� �+g� 3� �:�+� ����+� �+�� 3� +i� 3+k� 3+m� 3+o� 3+q� 3+� 7*� �2� � � �� � � 1+�� 3+� �+s� 3� �:�+� ����+� �+�� 3� S+� 7*� �2� � � �� � � 1+�� 3+� �+u� 3� �:�+� ����+� �+�� 3� +w� 3+y� 3+� 7*� �2� � �� �� � � 1+�� 3+� �+{� 3� �:�+� ����+� �+�� 3� S+� 7*� �2� � �� �� � � 1+�� 3+� �+}� 3� �:�+� ����+� �+�� 3� +� 3+�� 3+�� 3+�� 3+�� 3+� 7*� �2� � � �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� S+� 7*� �2� � � �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� +�� 3+�� 3+� 7*� �2� � �� �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� S+� 7*� �2� � �� �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� +�� 3+�� 3+�� 3+�� 3+�� 3+� 7*� �:2� � � �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� S+� 7*� �:2� � � �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� +�� 3+�� 3+� 7*� �:2� � �� �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� S+� 7*� �:2� � �� �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� +�� 3+�� 3+�� 3+�� 3+�� 3+� 7*� �>2� � � �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� S+� 7*� �>2� � � �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� +�� 3+�� 3+� 7*� �>2� � �� �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� S+� 7*� �>2� � �� �� � � 1+�� 3+� �+�� 3� �:�+� ����+� �+�� 3� +�� 3+ö 3+Ŷ 3+Ƕ 3+7� 3+� 7*� �B2� � � �� � � 1+�� 3+� �+ɶ 3� �:�+� ����+� �+�� 3� S+� 7*� �B2� � � �� � � 1+�� 3+� �+˶ 3� �:�+� ����+� �+�� 3� +Ͷ 3+϶ 3+� 7*� �B2� � �� �� � � 1+�� 3+� �+Ѷ 3� �:�+� ����+� �+�� 3� S+� 7*� �B2� � �� �� � � 1+�� 3+� �+Ӷ 3� �:�+� ����+� �+�� 3� +ն 3+׶ 3+ٶ 3+۶ 3+�� 3+� 7*� �&2� � � �� � � 1+�� 3+� �+ݶ 3� �:�+� ����+� �+�� 3� S+� 7*� �&2� � � �� � � 1+�� 3+� �+߶ 3� �:�+� ����+� �+�� 3� +� 3+� 3+� 7*� �&2� � �� �� � � 1+�� 3+� �+� 3� �:�+� ��¿+� �+�� 3� S+� 7*� �&2� � �� �� � � 1+�� 3+� �+� 3� �:�+� ��ÿ+� �+�� 3� +� 3+� 3+�� 3+� 3+�� 3+� 7*� �"2� � � �� � � 1+�� 3+� �+� 3� �:�+� ��Ŀ+� �+�� 3� S+� 7*� �"2� � � �� � � 1+�� 3+� �+� 3� �:�+� ��ſ+� �+�� 3� +�� 3+�� 3+� 7*� �"2� � �� �� � � 1+�� 3+� �+�� 3� �:�+� ��ƿ+� �+�� 3� S+� 7*� �"2� � �� �� � � 1+�� 3+� �+�� 3� �:�+� ��ǿ+� �+�� 3� +�� 3+�� 3+� 3+� 3+�� 3+� 7*� �*2� � � �� � � 1+�� 3+� �+� 3� �:�+� ��ȿ+� �+�� 3� S+� 7*� �*2� � � �� � � 1+�� 3+� �+� 3� �:�+� ��ɿ+� �+�� 3� +	� 3+� 3+� 7*� �*2� � �� �� � � 1+�� 3+� �+� 3� �:�+� ��ʿ+� �+�� 3� S+� 7*� �*2� � �� �� � � 1+�� 3+� �+� 3� �:�+� ��˿+� �+�� 3� +� 3+� 3+� 3+� 3+�� 3+� 7*� �.2� � � �� � � 1+�� 3+� �+� 3� �:�+� ��̿+� �+�� 3� S+� 7*� �.2� � � �� � � 1+�� 3+� �+� 3� �:�+� ��Ϳ+� �+�� 3� +� 3+� 3+� 7*� �.2� � �� �� � � 1+�� 3+� �+!� 3� �:�+� ��ο+� �+�� 3� S+� 7*� �.2� � �� �� � � 1+�� 3+� �+#� 3� �:�+� ��Ͽ+� �+�� 3� +%� 3+'� 3+)� 3++� 3+�� 3+� 7*� �22� � � �� � � 1+�� 3+� �+-� 3� �:�+� ��п+� �+�� 3� S+� 7*� �22� � � �� � � 1+�� 3+� �+/� 3� �:�+� ��ѿ+� �+�� 3� +1� 3+3� 3+� 7*� �22� � �� �� � � 1+�� 3+� �+5� 3� �:�+� ��ҿ+� �+�� 3� S+� 7*� �22� � �� �� � � 1+�� 3+� �+7� 3� �:�+� ��ӿ+� �+�� 3� +9� 3+;� 3+=� 3+?� 3+7� 3+� 7*� �62� � � �� � � 1+�� 3+� �+A� 3� �:�+� ��Կ+� �+�� 3� S+� 7*� �62� � � �� � � 1+�� 3+� �+C� 3� �:�+� ��տ+� �+�� 3� +E� 3+G� 3+� 7*� �62� � �� �� � � 1+�� 3+� �+I� 3� �:�+� ��ֿ+� �+�� 3� S+� 7*� �62� � �� �� � � 1+�� 3+� �+K� 3� �:�+� ��׿+� �+�� 3� +M� 3+O� 3+Q� 3+S� 3+� �+U� 3++� 7*� �F2� � �� 3+W� 3� �:�+� ��ؿ+� �+Y� 3+[� 3+]� 3+� �+_� 3++� 7*� �L2� � �� 3+W� 3� �:�+� ��ٿ+� �+a� 3+c� 3+e� 3+� 7��� � � �� � � 1+�� 3+� �+g� 3� �:�+� ��ڿ+� �+�� 3� +�� 3+� 7��� � �� �� � � 1+�� 3+� �+i� 3� �:�+� ��ۿ+� �+�� 3� +�� 3+� 7��� � Ѹ �� � � 1+�� 3+� �+k� 3� �:�+� ��ܿ+� �+�� 3� +k� 3+� 7��� � m� �� � � 1+�� 3+� �+o� 3� �:�+� ��ݿ+� �+�� 3� +q� 3+s� 3+u+� \� b�:��6�+� \�ަ 9�Y�:�� "� fY� hYj� lu� pr� u� y� z����:��6�+� |~u��  �߶ �+�� 3+ �*� �Q2� �� ��� �� � � ]+�� 3+� �*� �R2� � �� �� � � 3+�� 3+� 7*� �S2+� �*� �R2� � � E W+�� 3� � +�� 3+� 7*� �S2� � w� �� � �!+�� 3+� 7*� �T2�z� E W+�� 3+� �+� |��� �� ��:���|� ���+� 7� =� � � ���~���� ��6���� g+���� �+�� 3�� ���� 2�:����� �  �:���� +� �W�� ������ +� �W�� ��� �� � ��� �:�+� |�� ���+� |�� �� �:�+� ���+� �+�� 3+� �+� |��� �� ��:����� ���+� 7� =� � � �������� ��6�����+���� �+�� 3+� �+|���:�+���6������ �6���� � � � ��6������ ���:�+� 7��� ��d�6�����`��� N�������� � � � � ,����6�+++� 7*� �U2� � �������� .�:�������� W+� 7�� ������������ W+� 7�� ���� �:�+� ���+� �+�� 3�� ����� 2�:����� �  �:���� +� �W�� ������� +� �W�� ��� �� � ��� �:�+� |�� ����+� |�� �� �:�+� ����+� �+�� 3+� �+� |��� �� ��:����� ���+� 7� =� � � ���� ��6���� �+����� �+�� 3+++� 7*� �V2� *� �W2�	��+E� 3��� ���ȧ 2�:������ �  �:���� +� �W��� ������� +� �W��� ���� �� � ��� �:�+� |��� ����+� |��� �� �:�+� ����+� �+�� 3+� 7*� �X2++� 7*� �Y2� *� �Z2�	� E W+�� 3+� �+� |��� �� ��:���¶ ���+� 7� =� � � ���� ��6���� �+����� �+Ķ 3+++� 7*� �V2� *� �W2�	��+E� 3��� ���ȧ 2�:������ �  �: ��� +� �W��� �� ���� +� �W��� ���� �� � ��� �:+� |��� ���+� |��� �� �:+� ���+� �+k� 3+� �+� |��� �� ��:�ƶ ��+� 7� =� � � ��� ��6�� g+��� �+ȶ 3�� ���� 2�:��� �  �:�� +� �W�� ����� +� �W�� ��� �� � ��� �:+� |�� ���+� |�� �� �:+� ���+� �+�� 3+ƶ��:
+���6�
��� �6�
�� � � ���6��
�� ���:	+� 7�
�� �d�6�	�`�����
�	����� � � � ���	���6+�� 3+� �+�� 3+� �+� |��� �� ��:�ʶ ��+� 7� =� � � ��� ��6�� �+��� �+̶ 3+++� 7*� �[2� ��	��+ζ 3�� ���̧ 2�:��� �  �:�� +� �W�� ����� +� �W�� ��� �� � ��� �:+� |�� ���+� |�� �� �:+� ���+� �+�� 3+� �+� |��� �� ��:�ж ��+� 7� =� � � ��� ��6�� �+��� �+Ҷ 3+++� 7*� �[2� *� �
2�	��+Զ 3++++� 7*� �\2� *� �
2��+��ܸ� 3+� 3++��+� 3++� 7*� �X2� � ��+�� 3�� ���g� 2�:��� �  �:�� +� �W�� ����� +� �W�� ��� �� � ��� �:+� |�� ���+� |�� �� �:+� ���+� �+�� 3� �:+� ���+� �+�� 3���� .�:�
���� W+� 7�� �	�����
���� W+� 7�� �	��+�� 3+� �+� |��� �� ��:�� ��+� 7� =� � � ��� ��6 � � �+�� � �+� 3++� 7*� �X2� � ��+E� 3�� ���ӧ 2�:!��!� �  �:"� � +� �W�� ��"�� � +� �W�� ��� �� � ��� �:#+� |�� ��#�+� |�� �� �:$+� ��$�+� �+�� 3+� |��� ����:%�%���%����% +� 7*� �X2� � �����%+����%��%�W�%�� � ��� �:&+� |�%� ��&�+� |�%� �+�� 3+� �+���:(+���6)�(�)�� �6*�(�� � � �u�6+�+�(�� ���:'+� 7�(�� �+d�6.�'�.`��� ��(�'���)�� � � � � ��'���6.+�� 3+� |��� ����:/�/���/���/ +� 7*� �X2� � �����/+� 7*� �]2� � ��/��/�W�/�� � ��� �:0+� |�/� ��0�+� |�/� �+�� 3��� .�:1�(�*�)�� W+� 7�� �'���1��(�*�)�� W+� 7�� �'��� �:2+� ��2�+� �+�� 3+� �+� |��� �� ��:3�3� ��3+� 7� =� � � ��3� ��64�4� �+�3�4� �+� 3++� 7*� �X2� � ��+E� 3�3� ���ӧ 2�:5�3�5� �  �:6�4� +� �W�3� ��6��4� +� �W�3� ��3� �� � ��� �:7+� |�3� ��7�+� |�3� �� �:8+� ��8�+� �+�� 3+� |��� ����:9�9���9���9 +� 7*� �X2� � �����9+�����9��9�W�9�� � ��� �::+� |�9� ��:�+� |�9� �+k� 3+� |!#� ��%�:;�;'�(�;*+� 7*� �X2� � ����-�;.�3�;�4�6<�<� F+�;�<� �+�� 3�;�5��� �:=�<� +� �W�=��<� +� �W�;�6� � ��� �:>+� |�;� ��>�+� |�;� �+�� 3+� |!#� ��%�:?�? +� 7*� �X2� � ����(�?8�;�?=�-�?>�3�?�4�6@�@� F+�?�@� �+�� 3�?�5��� �:A�@� +� �W�A��@� +� �W�?�6� � ��� �:B+� |�?� ��B�+� |�?� �+k� 3+� |��� ����:C�C���CA���C +� 7*� �X2� � �����C�W�C�� � ��� �:D+� |�C� ��D�+� |�C� �+C� 3+� �+� |��� �� ��:E�EE� ��E+� 7� =� � � ��E� ��6F�F� g+�E�F� �+G� 3�E� ���� 2�:G�E�G� �  �:H�F� +� �W�E� ��H��F� +� �W�E� ��E� �� � ��� �:I+� |�E� ��I�+� |�E� �� �:J+� ��J�+� �+�� 3� +I� 3+K� 3+� �+� |��� �� ��:K�KM� ��K+� 7� =� � � ��K� ��6L�L� g+�K�L� �+O� 3�K� ���� 2�:M�K�M� �  �:N�L� +� �W�K� ��N��L� +� �W�K� ��K� �� � ��� �:O+� |�K� ��O�+� |�K� �� �:P+� ��P�+� �+�� 3++� 7*� �^2� �U��� � � +W� 3� 
+Y� 3+[� 3+]� 3+� 7*� �T2� � _� �� � � 1+�� 3+� �+a� 3� �:Q+� ��Q�+� �+�� 3� +c� 3+e� 3+� 7*� �_2++�jl�q� E W+�� 3+� �+� |��� �� ��:R�Rs� ��R+� 7� =� � � ��R� ��6S�S� g+�R�S� �+u� 3�R� ���� 2�:T�R�T� �  �:U�S� +� �W�R� ��U��S� +� �W�R� ��R� �� � ��� �:V+� |�R� ��V�+� |�R� �� �:W+� ��W�+� �+�� 3+� �+� |��� �� ��:X�Xw� ��X+� 7� =� � � ��X� ��6Y�Y� g+�X�Y� �+y� 3�X� ���� 2�:Z�X�Z� �  �:[�Y� +� �W�X� ��[��Y� +� �W�X� ��X� �� � ��� �:\+� |�X� ��\�+� |�X� �� �:]+� ��]�+� �+�� 3+� �+{� 3++�*� �`2�� �� 3+�� 3+++� 7*� �a2� ���	�� 3+�� 3+++� 7*� �b2� ���	�� 3+�� 3++� 7*� �_2� � �� 3+�� 3� �:^+� ��^�+� �+�� 3�n}�� )}��  P��  ?��  @tw )@��  ��  ��  )9< ))EH  �~~  ���  �"% )�.1  �gg  ���  ��� )���  �,,  �FF  ��� )���  n  ]//  ��� )���  W��  F��  J~� )J��  ��  ��  	3	C	F )	3	O	R  		�	�  �	�	�  	�
,
/ )	�
8
;  	�
q
q  	�
�
�  
�
�
� )
�
�   
�66  
�PP  ��� )���  x    g::  ��� )���  b��  Q��  Ueh )Uqt  '��  ��  *- )69  �oo  ���  � )� #  �YY  �ss  �� )�
  �CC  �]]  ��� )���  �--  tGG  ��� )���  o  ^11  ��� )���  Y  H  q�� )q��  C��  2  [�� )[��  -��  ��  Ez} )E��  ��  ��  /dg )/ps  ��  ���  NQ )Z]  ���  ���  (�)')* )(�)3)6  (�)l)l  (�)�)�  +g+�+� )+g+�+�  +9+�+�  +(,,  -�-�-� )-�-�-�  -z.!.!  -i.;.;  .�.�.� ).�.�.�  .�/5/5  .}/O/O  /�0
0 )/�00  /�0O0O  /�0i0i  0�11! )0�1*1-  0�1c1c  0�1}1}  2282; )22D2G  1�2}2}  1�2�2�  33L3O )33\3_  2�3�3�  2�3�3�  4S4�4� )4S4�4�  44�4�  455  5�5�5� )5�5�5�  5^6*6*  5K6L6L  6�77" )6�7174  6�7x7x  6�7�7�  8/8f8i )8/8x8{  7�8�8�  7�8�8�  9|9�9� )9|9�9�  9@::  9-:.:.  :�:�:� ):�;;  :�;S;S  :t;u;u  <<G<J )<<Y<\  ;�<�<�  ;�<�<�  =W=�=� )=W=�=�  ==�=�  =>	>	  >�>�>� )>�>�>�  >h?4?4  >U?V?V  ?�@"@% )?�@4@7  ?�@{@{  ?�@�@�  A8AoAr )A8A�A�  @�A�A�  @�A�A�  BB�B� )BB�B�  BCCC  B0C1C1  C�DD )C�DD  C�D\D\  C}D~D~  EEJEM )EE\E_  D�E�E�  D�E�E�  F`F�F� )F`F�F�  F$F�F�  FGG  G�G�G� )G�G�G�  GkH7H7  GXHYHY  H�I,I/ )H�I>IA  H�I�I�  H�I�I�  J<JsJv )J<J�J�  J J�J�  I�J�J�  K�K�K� )K�K�K�  KOLL  K<L=L=  L�L�L� )L�L�L�  LkM7M7  LXMYMY  M�N%N( )M�N7N:  M�N~N~  M�N�N�  O
OAOD )O
OSOV  N�O�O�  N�O�O�  PYP�P� )PYP�P�  PP�P�  P
QQ  QuQ�Q� )QuQ�Q�  Q9RR  Q&R'R'  R�R�R� )R�SS  R�SLSL  RmSnSn  S�TT )S�T!T$  S�ThTh  S�T�T�  UU)U)  UoUyUy  U�U�U�  VV'V'  V�V�V�  V�V�V�  W0W:W:  W�W�W�  W�W�W�  X5X?X?  X�X�X�  X�X�X�  YVY`Y`  Y�Y�Y�  ZZZ  ZTZ^Z^  Z�Z�Z�  [[![!  [u[[  [�[�[�  \8\B\B  \�\�\�  \�\�\�  ]6]@]@  ]�]�]�  ]�^^  ^W^a^a  ^�^�^�  __$_$  _j_t_t  _�_�_�  ``"`"  `�`�`�  `�`�`�  a9aCaC  a�a�a�  a�bb  bLbVbV  b�b�b�  b�cc  cmcwcw  c�c�c�  dd%d%  dkdudu  d�d�d�  e.e8e8  e�e�e�  e�e�e�  fOfYfY  f�f�f�  f�gg  gMgWgW  g�g�g�  hhh  hnhxhx  h�h�h�  ii*i*  iTi|i|  i�i�i�  jj&j&  jnjxjx  j�j�j�  l�l�l� )l�l�l�  lEl�l�  l2mm  n n^n^  m�n�n�  m�n�n� )m�n�n�  mFo*o*  m3oLoL  o�o�o� )o�pp  ozpJpJ  ogplpl  qqCqF )qqUqX  p�q�q�  p�q�q�  r)r;r> )r)rMrP  q�r�r�  q�r�r�  s�tt )s�tt"  s�tftf  s�t�t�  t�u�u� )t�u�u�  t�u�u�  t�v	v	  s}v#v#  s6v@v@  v�ww )v�w(w+  v�wowo  v�w�w�  w�x,x,  yy�y�  x�y�y�  xUzz  zmz�z� )zmz�z�  z1z�z�  z{{  {D{�{�  |M|a|a  {�|�|�  }4}H}H  |�}~}~  }�~~  ~�~�~� )~�~�~�  ~I~�~�  ~6  ��� )���  Q��  >��  ������  �G�Y�\ )�G�k�n  �����  ���ԁ�  �>�P�S )�>�b�e  �����  ��˂�  ��v�v   V         * +  W  �-           @  A ! k $ � - � 0 � 9 � < � ? � E � � � � �a �� �� �
 �, �8 �� �� �D �h �� �- �� �� � �� �� �V �� �� ?�Nr�
	7	�	�
 
�
�`��J�Y �"$�&�'(�*�+�,m.�/�0W2�3�4A6�7�8+:u;�<>_?�@�BICnD�F3GXH�JKBL�O<PdQ�R�S�U<VdW�X�Y�\=]e^�_�`�b=ced�e�f�h=iej�k�l�n=oep�q�r�t=uev�w�x�z={e|�}�~�� =� e� �� �� ��!=�!e�!��!��!��">�"f�"��"��"��#>�#f�#��#��#��$>�$f�$��$��$��%>�%f�%��%��%��&>�&f�&��&��&��&��'+�'��'��'��(�(!�(H�(o�(��(��(��)�)��)��)��)��)��)��*�*4�*J�*S�*{�*��*��*��+!�+k�+��+��,(�,B�,k�,��,��,��,��,��,��-�-�-:�-b�-��-��.K�.v�.��.��/_�/h�/��/��/��0y0�0�11�	1�1�22,2�2�33@3�3�3� 4W%4|&5'5D(5�-5�.6`/6j26�36�8797�:7�;83@8XA8�B8�D9&E9�J9�K:BL:mM:�R:�S;�T;�V;�W<\<9]<�^=_=[d=�e>f>&h>Ni>�n>�o?jp?�q?�v@w@�x@�z@�{A<�Aa�A��B)�B��B��CE�CN�Cv�C��C��D��D��E�E<�E��E��F
�Fd�F��G&�GQ�G��G��Hm�Hw�Hz�H��H��I�I��I��J@�Je�K�K	�K�K�K5�K��K��LQ�L��L��Mm�M��M��N�N��O�O3�O��O��O��O��P�P]�P��Q�Qy�Q� R;RfR�	R�
S�S�TT�T�T�T�T�T�T�T� T�2T�?T�KT�LT�PUQU#RU:SU=TUhUUsVU�WU�XU�^U�rU�sU�tU�uU�vVwV!xV8yV;zVE�VO�VS�VV�V{�V��V��V��V��V��V��V��V��W�W)�W4�WK�WN�Wy�W��W��W��W��W��W��W��W��W��X �X X.X9XPXSX]
XgX�X� X�!X�"X�#X�$X�%Y&Y-YIYJY#`Y'aY*hYOiYZjYqkYtlY�mY�nY�oY�pY�wY��Y��Z�Z�Z"�ZM�ZX�Zo�Zr�Z|�Z��Z��Z��Z��Z��Z��Z��Z��Z��[�[�[2�[5�[?�[I�[n�[y�[��[��[��[��[��[��[�[�[� [�(\)\5\	6\8\19\<:\S;\V<\�=\�>\�?\�@\�G\�[\�\\�]]^]_]/`]:a]Qb]Tc]^j]h�]l�]o�]s�]v�]z�]}�]��]��]��]��]��]��^�^�^!�^+�^P�^[�^r�^u�^��^��^��^��^��^�^�^�___5	_8
_c_n_�_�_�_�)_�*_�+_�,_�-`.`/`30`61`@8`JT`NU`Xi`\j`_m`�n`�o`�p`�q`�r`�s`�t`�ua}a�a2�a=�aT�aW�a��a��a��a��a��a��a��a��a��a��a��b �b�b�bE�bP�bg�bj�bt�b~�b��b��b��b��b��b��c�c�c"c,"c0#c:8c>9cA;cf<cq=c�>c�?c�@c�Ac�Bc�Cc�Ic�]d^d_d6`d9addbdocd�dd�ed�ld��d��d��d��d��d��d��d��d��e'�e2�eI�eL�eV�e`�e��e��e��e��e��e��e��e��f�f�f�ff f#fHfS	fj
fmf�f�f�f�f�f�)f�*g+g,g-gF.gQ/gh0gk1gu8gSg�Tg�hg�ig�mg�ng�og�pg�qh	rhsh+th.uh8{hB�hg�hr�h��h��h��h��h��h��h��h��iP�i��i��i�	i�	i�	i�	i�	i�	j	j 	j7	j:	jC	jg	 jr	!j�	"j�	#j�	&j�	'j�	(j�	)j�	*j�	,j�	Gkg	Hk�	Ik�	Jk�	Kk�	Ml	Nl+	Pl�	Rm,	Tm�	Xn�	Yo`	[o�	\o�	]p�	_p�	aq	bq5	cq�	fr-	gr�	hr�	jsv	ks�	ls�	ms�	nt�	pt�	tu�	uv	wv7	xv�	zv�	{w	|w�	~w�	w�	�x	�xK	~xK	�xN	�x�	�y,	�yR	�yi	�y�	�y�	�y�	�z	�zq	�z�	�{,	�{Z	�{�	�{�	�{�	�{�	�{�	�|	�|(	�|P	�|�	�|�	�}	�}	�}7	�}�	�}�	�}�	�~+	�~+	�~/	�~�	�&	�0	�3	�7	�:	��	��.	Y	À\	ŀc	ƀf	Ȁt	ހ�	߀�	���	ှ	��	��
��
�K
��
�B
��
��
	��

X     ) �� U        �    X     ) �� U         �    X     ) �� U        �    X    �    U  �    �*c� �Y���SY���SY���SY���SY���SY���SY���SY���SY���SY	���SY
���SYո�SY���SY���SY¸�SY߸�SYĸ�SYƸ�SYȸ�SY��SYʸ�SY̸�SYθ�SYи�SY��SYҸ�SYԸ�SYָ�SY��SYظ�SYڸ�SYܸ�SY ��SY!޸�SY"��SY#��SY$���SY%��SY&��SY'��SY(���SY)��SY*��SY+��SY,��SY-��SY.��SY/���SY0��SY1���SY2���SY3���SY4��SY5���SY6���SY7 ��SY8��SY9��SY:��SY;��SY<��SY=
��SY>��SY?��SY@��SYA��SYB��SYC��SYD��SYE��SYF��SYG��SYH ��SYI"��SYJĸ�SYK$��SYL&��SYM(��SYN*��SYO,��SYP.��SYQ0��SYR2��SYS4��SYT6��SYU8��SYV:��SYW<��SYX>��SYY@��SYZB��SY[D��SY\F��SY]H��SY^J��SY_L��SY`N��SYaP��SYbR��S� ��     Y    