����   2� ca_settings_cfm$cf  lucee/runtime/PageImpl  /admin/ca_settings.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength     � getCompileTime  n�� getHash ()I��� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Lca_settings_cfm$cf;
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>CA Settings</title>
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
                     N</td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="705" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 705px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="518">
                              <tr valign="top" align="left">
                                <td width="12" height="11"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                 P<td width="506" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Internal Certificate Authority</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2" height="5"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text483" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="color: rgb(0,51,153);"><span style="font-size: 12px;">Add Internal Certificate Authority</span></span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                             R<table border="0" cellspacing="0" cellpadding="0" width="452">
                              <tr valign="top" align="left">
                                <td width="427" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/encryption/internal-certificate-authority/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                         T3<tr valign="top" align="left">
                          <td width="11" height="4"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="437"></td>
                          <td width="956"> V m X &lucee/runtime/config/NullSupportHelper Z NULL \ '
 [ ] -lucee/runtime/interpreter/VariableInterpreter _ getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; a b
 ` c 0 e %lucee/runtime/exp/ExpressionException g java/lang/StringBuilder i The required parameter [ k  1
 j m append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; o p
 j q ] was not provided. s -(Ljava/lang/String;)Ljava/lang/StringBuilder; o u
 j v toString ()Ljava/lang/String; x y
 j z
 h m lucee/runtime/PageContextImpl } any �       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 ~ � 

 � step �  
 � action � 	 



 � show_encryption � 4096 �@       keys $[Llucee/runtime/type/Collection$Key; � �	  � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � 
 � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � �   � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � show_validity � 1825 � show_algorithm � show_ca_commonname � show_ca_email � show_subca_commonname � show_subca_email � show_organizationname � show_unitname � show_stateprovincename � show_countryname � show_default � _default � ;	 9 � 



 � A � #lucee/commons/color/ConstantsDouble � _0 Ljava/lang/Double; � �	 � � _M � ;	 9 � _1 � �	 � � [^a-zA-Z0-9 ] � lucee/runtime/op/Caster � &(Ljava/lang/Object;)Ljava/lang/String; x �
 � � %lucee/runtime/functions/string/REFind � S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object; & �
 � � (Ljava/lang/Object;D)I � �
 � � _2 � �	 � � 


 � 1 � _9 � �	 � � [^a-zA-Z0-9, ] � _10  �	 � 2 _11 �	 � [^_a-zA-Z0-9 ] _12
 �	 � _3 �	 � 3 _13 �	 � 	[^a-zA-Z] _14 �	 � _4 �	 � 4 _15 �	 �  _16" �	 �# _5% �	 �& 5( outputStart* 
 /+ lucee.runtime.tag.Query- cfquery/ use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag;12
 ~3 lucee/runtime/tag/Query5 checkca7 setName9 1
6: setDatasource (Ljava/lang/Object;)V<=
6> 
doStartTag@ $
6A initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)VCD
 /E 1
select * from ca_settings where ca_commonname='G writePSQI=
 /J '
L doAfterBodyN $
6O doCatch (Ljava/lang/Throwable;)VQR
6S popBody ()Ljavax/servlet/jsp/JspWriter;UV
 /W 	doFinallyY 
6Z doEndTag\ $
6] lucee/runtime/exp/Abort_ newInstance (I)Llucee/runtime/exp/Abort;ab
`c reuse !(Ljavax/servlet/jsp/tagext/Tag;)Vef
 ~g 	outputEndi 
 /j getCollectionl � Am #lucee/runtime/util/VariableUtilImplo recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;qr
ps $lucee/runtime/functions/dateTime/Nowu =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &w
vx 
yyyy-mm-ddz 4lucee/runtime/functions/displayFormatting/DateFormat| S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &~
} d� toDoubleValue (Ljava/lang/Object;)D��
 �� getTimeZone ()Ljava/util/TimeZone;��
 /� toDate H(Ljava/lang/Object;Ljava/util/TimeZone;)Llucee/runtime/type/dt/DateTime;��
 �� (lucee/runtime/functions/dateTime/DateAdd� p(Llucee/runtime/PageContext;Ljava/lang/String;DLlucee/runtime/type/dt/DateTime;)Llucee/runtime/type/dt/DateTime; &�
�� reset� '
update ca_settings set default2='2'
� [^A-Za-z0-9]+� all� (lucee/runtime/functions/string/REReplace� w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &�
�� insertca� caResult� 	setResult� 1
6� �
insert into ca_settings 
(
validity, 
encryption, 
ca_commonname, 
organizationname, 
unitname, 
stateprovincename, 
countryname,
applied,
expires,
default2,
ca_directory)
values
(
'� ', 
'� ',
'2',
'� ',
'� ')
� customtrans� getrandom_results� Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
� inserttrans� stResult� &
insert into salt
(salt)
values
('� getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;��
 /� getId� $
 /� lucee/runtime/type/Query� getCurrentrow (I)I���� getRecordcount� $�� !lucee/runtime/util/NumberIterator� load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� A� isValid (I)Z��
�� current� $
�� go (II)Z���� #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� removeQuery�  A� release &(Llucee/runtime/util/NumberIterator;)V��
�� gettrans� 2
select salt as customtrans2 from salt where id='� I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; ��
 /� deletetrans� 
delete from salt where id='� clearcerttmp� djigzo� #
delete from cm_certificates_tmp
� 	copycerts  A
INSERT INTO cm_certificates_tmp SELECT * FROM cm_certificates
 lucee.runtime.tag.FileTag cffile lucee/runtime/tag/FileTag hasBody (Z)V

	 read 	setAction 1
	  /opt/hermes/scripts/create_ca.sh setFile 1
	 temp setVariable 1
	
	A
	] 0 /opt/hermes/scripts/  java/lang/String" concat &(Ljava/lang/String;)Ljava/lang/String;$%
#& _create_ca.sh( SHOW-ENCRYPTION* ALL, 	setOutput.=
	/ setAddnewline1
	2 SHOW-VALIDITY4 SHOW-COUNTRYNAME6 SHOW-STATEPROVINCENAME8 SHOW-ORGANIZATIONNAME: SHOW-UNITNAME< SHOW-CA-COMMONNAME> CUSTOM-TRANS@ 
    
B CA-DIRECTORYD (/opt/hermes/templates/rootca_openssl.cnfF opensslH /opt/hermes/templates/J _rootca_openssl.cnfL 
    
  
N lucee.runtime.tag.ExecuteP 	cfexecuteR lucee/runtime/tag/ExecuteT 
/bin/chmodV
U: +x /opt/hermes/scripts/Y setArguments[=
U\@N       
setTimeout (D)V`a
Ub
UA
UO
U]@n       	/dev/nulli setOutputfilek 1
Ul -inputformat nonen 





p deleter 


    
t 
getnewcertv l
SELECT * FROM cm_certificates WHERE cm_thumbprint NOT IN (SELECT cm_thumbprint FROM cm_certificates_tmp)
x _19z �	 �{ setroot} @
update cm_certificates set cm_store_name='roots' where cm_id=' 
checkthumb� :
select cm_thumbprint from cm_ctl where cm_thumbprint = '� getmax� *
SELECT max(cm_id) as maxid FROM cm_ctl
� plusRef 8(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Double;��
 �� 	insertctl� >
insert into cm_ctl (cm_id, cm_name, cm_thumbprint) values ('� ', 'global', '� insertctlnamewhitelisted� I
insert into cm_ctl_cm_name_values (cm_ctl, cm_value, cm_name) values ('� ', 'whitelisted', 'status')
� insertctlnameexpired� ', 'false', 'allowExpired')
� updatedjigzoproperties� '
update ca_settings set ca_djigzo_id='� ', ca_djigzo_subject='CN=� , OU=� , O=� , ST=� , C=� ' where id='� _17� �	 �� _20� �	 �� _18� �	 ��:
                            <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion1" style="height: 437px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="system_configuration_form" action="ca_settings.cfm?action=" method="post">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="578">
                                          <table id="Table76" border="0" cellspacing="0" cellpadding="0" width="578" style="height: 365px;">
                                            <tr style="height: 14px;">
                                              <td width="578" id="Cell735">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Certificate Authority Common Name ��</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell734">
                                                <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>� �<input type="text" id="FormsEditField1" name="ca_commonname" size="40" maxlength="50" style="width: 316px; white-space: pre;" value="� ">�</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell442">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Certficate Authority Certificate Validity in Years</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 95px;">
                                              <td id="Cell460">
                                                <table width="563" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  �<tr>
                                                    <td>
                                                      <table id="Table73" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 95px;">
                                                        <tr style="height: 19px;">
                                                          <td width="46" id="Cell423">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� j
<input type="radio" checked="checked" name="validity" value="1825" style="height: 13px; width: 13px;">
� X
<input type="radio" name="validity" value="1825" style="height: 13px; width: 13px;">
�






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="517" id="Cell424">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">5 Years <span style="color: rgb(51,51,51); font-weight: normal;">(Recommended)</span></span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell425">
                                                            �J<table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� 1460� j
<input type="radio" checked="checked" name="validity" value="1460" style="height: 13px; width: 13px;">
� X
<input type="radio" name="validity" value="1460" style="height: 13px; width: 13px;">
�G






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell426">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">4 Years</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell427">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              � �<tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� 1095� j
<input type="radio" checked="checked" name="validity" value="1095" style="height: 13px; width: 13px;">
� X
<input type="radio" name="validity" value="1095" style="height: 13px; width: 13px;">
�G






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell428">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">3 Years</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell429">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              � 730� W
<input type="radio" name="validity" value="730" style="height: 13px; width: 13px;">
�G






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell430">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">2 Years</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 19px;">
                                                          <td id="Cell431">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              � 365� W
<input type="radio" name="validity" value="365" style="height: 13px; width: 13px;">
�.






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell432">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">1 Year</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            �6</tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell433">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Certificate Authority Certificate Key Length</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell445">
                                                <table width="564" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table71" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        ��<tr style="height: 19px;">
                                                          <td width="45" id="Cell411">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� 2048� l
<input type="radio" checked="checked" name="encryption" value="2048" style="height: 13px; width: 13px;">
� Z
<input type="radio" name="encryption" value="2048" style="height: 13px; width: 13px;">
�V






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="519" id="Cell412">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">2048-bits </span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 23px;">
                                                          <td id="Cell413">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              � l
<input type="radio" checked="checked" name="encryption" value="4096" style="height: 13px; width: 13px;">
� Z
<input type="radio" name="encryption" value="4096" style="height: 13px; width: 13px;">
� 






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell414">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">4096-bits</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </�jtd>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell453">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Organization/Company Name</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell473">
                                                <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>� �<input type="text" id="FormsEditField5" name="organizationname" size="40" maxlength="50" style="width: 316px; white-space: pre;" value="�</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell474">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Organization Unit</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell772">
                                                <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    � <td>  �<input type="text" id="FormsEditField6" name="unitname" size="40" maxlength="50" style="width: 316px; white-space: pre;" value="</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell773">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Organization State/Province</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell774">
                                                <table width="320" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                     �<input type="text" id="FormsEditField7" name="stateprovincename" size="40" maxlength="50" style="width: 316px; white-space: pre;" value="v</td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell775">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Organization Country Code</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell776">
                                                <p style="margin-bottom: 0px;"> �<input type="text" id="FormsEditField8" name="countryname" size="40" maxlength="2" style="width: 316px; white-space: pre;" value="
�</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell790">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Make Default</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell791">
                                                <table width="44" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"> checkdefault 7
select default2 from ca_settings where default2='1'
 W
<input type="checkbox" name="default" value="1" style="height: 13px; width: 13px;">
 �
<input type="hidden" name="default" value="1">
<input type="checkbox" name="default" value="1" style="height: 13px; width: 13px;" checked="checked" disabled="disabled">
-&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
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
                                        <td width="956">
                                          <table id="Table125" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            6<tr style="height: 17px;">
                                              <td width="956" id="Cell722">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="hidden" name="action" value="edit">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
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
                                    <table border="0" cellspacing="0" cellpadding="0" width="956">
                                      <tr valign="top" align="left">
                                        <td width="956" height="13"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="956" id="Text277" class="TextObject">
                                           <p style="margin-bottom: 0px;">d
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Root CA Common Name cannot be empty</span></i></b></p>
x
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Root CA Common Name must not contain special characters</span></i></b></p>
 o
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Root CA E-mail Address</span></i></b></p>
"g
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Root CA E-mail address cannot be empty</span></i></b></p>
$�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Intermediate CA Common Name must not contain special characters</span></i></b></p>
& 6(q
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Server Intermedia CA Common Name cannot be empty</span></i></b></p>
* 7,v
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You have entered an invalid Intermedite CA E-mail Address</span></i></b></p>
. 80m
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Intermedia CA E-mail Address cannot be empty</span></i></b></p>
2 94j
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization/Company Name cannot be empty</span></i></b></p>
6 108�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization/Company Name cannot contain any special characters</span></i></b></p>
: 11<b
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization Unit cannot be empty</span></i></b></p>
> 12@x
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization Unit cannot contain any special characters</span></i></b></p>
B 13Dl
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization State/Province cannot be empty</span></i></b></p>
F 14H�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization State/Province cannot contain any special characters</span></i></b></p>
J 15Lj
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization Country Code cannot be empty</span></i></b></p>
N 16P�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Organization Country Code cannot contain any special characters</span></i></b></p>
R 17TZ
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! CA Created.</span></i></b></p>
V 18X�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Certification Authority you are attempting to add already exists. Please change the Certification Authority Common Name</span></i></b></p>
Z 19\�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;System error has occured. Please contact support with the following error: Error occured while inserting CA. Temp Email not found</span></i></b></p>
^ 20`�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;System error has occured. Please contact support with the following error: Error occured while inserting CA. Multiple Temp Email found</span></i></b></p>
b 101d_
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
f







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
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="10" height="2"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="449"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="2" valign="middle" width="954">h�<hr id="HRRule13" width="954" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="11"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="2" width="506" id="Text369" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Edit/Delete Existing Internal Certificate Authorities</span></b></p>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="126"></td>
                          <td colspan="4" width="956">j m2l@       urlScope  ()Llucee/runtime/type/scope/URL;pq
 /r lucee/runtime/type/scope/URLtu � _ACTIONw ;	 9x 	mkdefaultz B 0
update ca_settings set default2='1' where id='} _ID ;	 9� lucee.runtime.tag.Location� 
cflocation� lucee/runtime/tag/Location� !ca_settings.cfm?action=setdefault� setUrl� 1
��
�A
�]2
                            <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion15" style="height: 126px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="956">
                                    <tr valign="top" align="left">
                                      <td width="956" id="Text367" class="TextObject">
                                        <p style="margin-bottom: 0px;">� getca� 8
select * from ca_settings order by ca_commonname asc
� �
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(255,0,0);">No Existing Certificate Authrorities were found...</span></i></b></p>

�#

<table id="Table129" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;">
  <tr style="height: 14px;">
    <td width="51" style="background-color: rgb(241,236,236);" id="Cell779">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Delete</span></b></p>
    </td>
    <td width="150" style="background-color: rgb(241,236,236);" id="Cell780">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">CA Common Name</span></b></p>
    </td>
    
    <td width="87" style="background-color: rgb(241,236,236);" id="Cell782">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Cert Expires</span></b></p>
    </td>
    <td width="83" style="background-color: rgb(241,236,236);" id="Cell783">
      ��<p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Key Length</span></b></p>
    </td>
    <td width="60" style="background-color: rgb(241,236,236);" id="Cell790">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Default</span></b></p>
    </td>
  </tr>
� getcarecepients� 4
select * from recipient_certificates where ca_id='� �
  <tr style="height: 19px;">
    <td id="Cell784">
      <form name="Cell765FORM" action="delete_ca.cfm" method="post">
        <input type="hidden" name="id" value="� ]">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
�g
            <td align="center"><input type="image" id="FormsButton2" name="FormsButton1" src="delete_icon.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
�s
<td align="center"><input type="image" id="FormsButton2" name="FormsButton1" disabled="disabled" src="delete_icon_off.png" style="height: 19px; border-left-width: 0px; border-left-style: solid; border-top-width: 0px; border-top-style: solid; border-right-width: 0px; border-right-style: solid; border-bottom-width: 0px; border-bottom-style: solid; width: 19px;"></td>
� �
          </tr>
        </table>
      </form>
    </td>
    <td id="Cell785">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">� �</span></p>
    </td>
    
    <td id="Cell787">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">� 
mm/dd/yyyy� �</span></p>
    </td>
    <td id="Cell788">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">� </span></p>
    </td>
� �
    <td width="60" id="Cell791">
  <form name="Cell791FORM" action="ca_settings.cfm?action=mkdefault" method="post">
    <input type="hidden" name="id" value="� �">
    <p style="text-align: center; margin-bottom: 0px;"><input type="checkbox" name="mkdefault" value="1" style="height: 13px; width: 13px;" checked="checked" disabled="disabled">&nbsp;</p>
  </form>
</td>
� �">
    <p style="text-align: center; margin-bottom: 0px;"><input type="checkbox" name="mkdefault" value="1" style="height: 13px; width: 13px;" onclick="this.form.submit();">&nbsp;</p>
  </form>
</td>
� 

  </tr>
� 
</table>
��
&nbsp;</p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="956" id="Text366" class="TextObject">
                                        <p style="margin-bottom: 0px;">� 
setdefault�w
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! New default Certification Authority set.</span></i></b></p>
�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Certificate Authority you are attempting to delete has issued certificates. You must first delete the users and corresponding certificates that are issued before you can delete the Certificate Authority</span></i></b></p>
�l
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Certificate Authority Deleted</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;Unable to retrieve any SMTP addresses from Active Directory. Please check that you have entered the correct Domain Distinguished Name Root and try again</span></i></b></p>
�



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
                          <td width="981" height="12"></td>
                        � �</tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;">� yyyy� 
getversion� D
SELECT value from system_settings where parameter = 'version_no'
� getbuild� B
SELECT value from system_settings where parameter = 'build_no'
� V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway � sessionScope $()Llucee/runtime/type/scope/Session;��
 /�  lucee/runtime/type/scope/Session�� � 	 Version:� _VALUE� ;	 9�  Build:� . Copyright 2011-� l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>�C
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
 ����� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � 
encryption� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key; 
� 
ENCRYPTION SHOW_ENCRYPTION validity VALIDITY
 SHOW_VALIDITY 	algorithm 	ALGORITHM SHOW_ALGORITHM ca_commonname CA_COMMONNAME SHOW_CA_COMMONNAME ca_email CA_EMAIL SHOW_CA_EMAIL subca_commonname  SUBCA_COMMONNAME" SHOW_SUBCA_COMMONNAME$ subca_email& SUBCA_EMAIL( SHOW_SUBCA_EMAIL* organizationname, ORGANIZATIONNAME. SHOW_ORGANIZATIONNAME0 unitname2 UNITNAME4 SHOW_UNITNAME6 stateprovincename8 STATEPROVINCENAME: SHOW_STATEPROVINCENAME< countryname> COUNTRYNAME@ SHOW_COUNTRYNAMEB DEFAULTD SHOW_DEFAULTF STEPH CHECKCAJ DATENOWL CERTEXPIRESN CA_DIRECTORYP RANDOMR STRESULTT GENERATED_KEYV CUSTOMTRANS3X GETTRANSZ CUSTOMTRANS2\ TEMP^ OPENSSL` 
GETNEWCERTb CM_IDd CM_THUMBPRINTf 
CHECKTHUMBh GETMAXj MAXIDl MAXID2n NEXTIDp CARESULTr CHECKDEFAULTt M2v GETCAx GETCARECEPIENTSz EXPIRES| DEFAULT2~ THEYEAR� EDITION� 
GETVERSION� GETBUILD� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *����*+���        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  `� =  Q�+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+S� 3+U� 3+W� 3+Y+� ^� dM>+� ^,� .fY:� !� hY� jYl� nY� rt� w� {� |�M>+� ~�Y, � �� �+�� 3+�+� ^� d:6+� ^� 0fY:� !� hY� jYl� n�� rt� w� {� |�:6+� ~�� � �� �+�� 3+�+� ^� d:6	+� ^� 0fY:
� !� hY� jYl� n�� rt� w� {� |�
:6	+� ~�� � �	� �+�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� n�� rt� w� {� |�:6+� ~�� � �� �+�� 3+ �*� �2� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� n�� rt� w� {� |�:6+� ~�� � �� �+�� 3+ �*� �2� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� n�� rt� w� {� |�:6+� ~�� � �� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� n¶ rt� w� {� |�:6+� ~�� � �� �+�� 3+ �*� �	2� �� ��� �� � � ]+�� 3+� �*� �
2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �
2� � � E W+�� 3� � +�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� nĶ rt� w� {� |�:6+� ~�� � �� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� nƶ rt� w� {� |�:6+� ~�� � �� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� nȶ rt� w� {� |�:6+� ~�� � �� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� ^� d: 6!+� ^ � 0�Y:"� !� hY� jYl� nʶ rt� w� {� |�": 6!+� ~��  � �!� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� ^� d:#6$+� ^#� 0�Y:%� !� hY� jYl� n̶ rt� w� {� |�%:#6$+� ~��# � �$� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� ^� d:&6'+� ^&� 0�Y:(� !� hY� jYl� nζ rt� w� {� |�(:&6'+� ~��& � �'� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� ^� d:)6*+� ^)� 0�Y:+� !� hY� jYl� nж rt� w� {� |�+:)6*+� ~��) � �*� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� � 2+� �*� �2� � � E W+�� 3� � +�� 3+�+� ^� d:,6-+� ^,� 0�Y:.� !� hY� jYl� nҶ rt� w� {� |�.:,6-+� ~��, � �-� �+�� 3+ �� �� �� ��� �� � � ]+�� 3+� �*� �!2� � �� �� � � 3+�� 3+� 7*� �"2+� �*� �!2� � � E W+�� 3� � +׶ 3+� 7*� �2� � �� �� � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� � � E W+�� 3� �+� 7*� �2� � �� �� � � �+�� 3+�+� 7*� �2� � � � �� �� � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� � �� E W+�� 3� #+�� 3+� 7*� �#2� � E W+�� 3+�� 3� +�� 3+� 7*� �#2� � �� �� � � (+� 7*� �2� � �� �� � � � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� � �� E W+�� 3� �+� 7*� �#2� � �� �� � � (+� 7*� �2� � �� �� � � � � �+�� 3+�+� 7*� �2� � � � �� �� � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� �� E W+�� 3� #+�� 3+� 7*� �#2� �� E W+�� 3+�� 3� +�� 3+� 7*� �#2� � � �� � � (+� 7*� �2� � �� �� � � � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� �� E W+�� 3� �+� 7*� �#2� � � �� � � (+� 7*� �2� � �� �� � � � � �+�� 3+	+� 7*� �2� � � � �� �� � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� �� E W+�� 3� #+�� 3+� 7*� �#2�� E W+�� 3+�� 3� +�� 3+� 7*� �#2� � � �� � � (+� 7*� �2� � �� �� � � � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� �� E W+�� 3� �+� 7*� �#2� � � �� � � (+� 7*� �2� � �� �� � � � � �+�� 3++� 7*� �2� � � � �� �� � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� �� E W+�� 3� #+�� 3+� 7*� �#2�� E W+�� 3+�� 3� +�� 3+� 7*� �#2� � � �� � � (+� 7*� � 2� � �� �� � � � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� �!� E W+�� 3� �+� 7*� �#2� � � �� � � (+� 7*� � 2� � �� �� � � � � �+�� 3++� 7*� � 2� � � � �� �� � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� �$� E W+�� 3� #+�� 3+� 7*� �#2�'� E W+�� 3+�� 3� +�� 3+� 7*� �#2� � )� �� � �$�+�� 3+�,+� ~.0�4�6://8�;/+� 7� =� � �?/�B600� m+/0�F+H� 3++� 7*� �2� � � �K+M� 3/�P��է $:1/1�T� :20� +�XW/�[2�0� +�XW/�[/�^� �d�� :3+� ~/�h3�+� ~/�h� :4+�k4�+�k+�� 3++� 7*� �$2�n �t� �� � �#K+�� 3+� 7*� �%2++�y{��� E W+�� 3+� 7*� �&2+�+� 7*� �2� � ��+� 7*� �%2� � +������� E W+�� 3+� 7*� �&2++� 7*� �&2� � {��� E W+�� 3+� 7*� �"2� � �� �� � � �+�� 3+� 7*� �!2� � E W+�� 3+�,+� ~.0�4�6:55��;5+� 7� =� � �?5�B666� O+56�F+�� 35�P��� $:757�T� :86� +�XW5�[8�6� +�XW5�[5�^� �d�� :9+� ~5�h9�+� ~5�h� ::+�k:�+�k+�� 3� G+� 7*� �"2� � �� �� � � &+�� 3+� 7*� �!2� �� E W+�� 3� +�� 3+� 7*� �'2++� 7*� �2� � � ������� E W+�� 3+�,+� ~.0�4�6:;;��;;+� 7� =� � �?;���;�B6<<�y+;<�F+�� 3++� 7*� �2� � � �K+�� 3++� 7*� �2� � � �K+�� 3++� 7*� �2� � � �K+�� 3++� 7*� �2� � � �K+�� 3++� 7*� �2� � � �K+�� 3++� 7*� �2� � � �K+�� 3++� 7*� � 2� � � �K+�� 3++� 7*� �&2� � � �K+�� 3++� 7*� �!2� � � �K+�� 3++� 7*� �'2� � � �K+�� 3;�P��ɧ $:=;=�T� :><� +�XW;�[>�<� +�XW;�[;�^� �d�� :?+� ~;�h?�+� ~;�h� :@+�k@�+�k+�� 3+�,+� ~.0�4�6:AA��;A+� 7� =� � �?A���A�B6BB� O+AB�F+�� 3A�P��� $:CAC�T� :DB� +�XWA�[D�B� +�XWA�[A�^� �d�� :E+� ~A�hE�+� ~A�h� :F+�kF�+�k+�� 3+�,+� ~.0�4�6:GG��;G+� 7� =� � �?G���G�B6HH�B+GH�F+�� 3+�,+���:J+��6KJK�� 6LJ�� � � � �6MMJ�� ��:I+� 7J�� Md6PIP`�ۙ DJI��K�� � � � � (I��6P+++� 7*� �(2� � � ��K���� ":QJLK�� W+� 7�� I��Q�JLK�� W+� 7�� I�� :R+�kR�+�k+�� 3G�P�� � $:SGS�T� :TH� +�XWG�[T�H� +�XWG�[G�^� �d�� :U+� ~G�hU�+� ~G�h� :V+�kV�+�k+�� 3+�,+� ~.0�4�6:WW�;W+� 7� =� � �?W�B6XX� x+WX�F+� 3+++� 7*� �)2�n *� �*2��� �K+M� 3W�P��ʧ $:YWY�T� :ZX� +�XWW�[Z�X� +�XWW�[W�^� �d�� :[+� ~W�h[�+� ~W�h� :\+�k\�+�k+�� 3+� 7*� �+2++� 7*� �,2�n *� �-2��� E W+�� 3+�,+� ~.0�4�6:]]��;]+� 7� =� � �?]�B6^^� x+]^�F+�� 3+++� 7*� �)2�n *� �*2��� �K+M� 3]�P��ʧ $:_]_�T� :`^� +�XW]�[`�^� +�XW]�[]�^� �d�� :a+� ~]�ha�+� ~]�h� :b+�kb�+�k+�� 3+�,+� ~.0�4�6:cc��;c��?c�B6dd� O+cd�F+�� 3c�P��� $:ece�T� :fd� +�XWc�[f�d� +�XWc�[c�^� �d�� :g+� ~c�hg�+� ~c�h� :h+�kh�+�k+�� 3+�,+� ~.0�4�6:ii�;i��?i�B6jj� O+ij�F+� 3i�P��� $:kik�T� :lj� +�XWi�[l�j� +�XWi�[i�^� �d�� :m+� ~i�hm�+� ~i�h� :n+�kn�+�k+�� 3+� ~�4�	:oo�o�o�o�o�Wo�� �d�� :p+� ~o�hp�+� ~o�h+�� 3+� ~�4�	:qq�q�q!+� 7*� �+2� � � �')�'�q++� 7*� �.2� � � �++� 7*� �2� � � �-���0q�3q�Wq�� �d�� :r+� ~q�hr�+� ~q�h+�� 3+� ~�4�	:ss�s�s!+� 7*� �+2� � � �')�'�s�s�Ws�� �d�� :t+� ~s�ht�+� ~s�h+�� 3+� ~�4�	:uu�u�u!+� 7*� �+2� � � �')�'�u++� 7*� �.2� � � �5+� 7*� �2� � � �-���0u�3u�Wu�� �d�� :v+� ~u�hv�+� ~u�h+�� 3+� ~�4�	:ww�w�w!+� 7*� �+2� � � �')�'�w�w�Ww�� �d�� :x+� ~w�hx�+� ~w�h+�� 3+� ~�4�	:yy�y�y!+� 7*� �+2� � � �')�'�y++� 7*� �.2� � � �7+� 7*� � 2� � � �-���0y�3y�Wy�� �d�� :z+� ~y�hz�+� ~y�h+�� 3+� ~�4�	:{{�{�{!+� 7*� �+2� � � �')�'�{�{�W{�� �d�� :|+� ~{�h|�+� ~{�h+�� 3+� ~�4�	:}}�}�}!+� 7*� �+2� � � �')�'�}++� 7*� �.2� � � �9+� 7*� �2� � � �-���0}�3}�W}�� �d�� :~+� ~}�h~�+� ~}�h+�� 3+� ~�4�	:��!+� 7*� �+2� � � �')�'���W�� �d�� :�+� ~�h��+� ~�h+�� 3+� ~�4�	:������!+� 7*� �+2� � � �')�'��++� 7*� �.2� � � �;+� 7*� �2� � � �-���0��3��W��� �d�� :�+� ~��h��+� ~��h+�� 3+� ~�4�	:������!+� 7*� �+2� � � �')�'�����W��� �d�� :�+� ~��h��+� ~��h+�� 3+� ~�4�	:������!+� 7*� �+2� � � �')�'��++� 7*� �.2� � � �=+� 7*� �2� � � �-���0��3��W��� �d�� :�+� ~��h��+� ~��h+�� 3+� ~�4�	:������!+� 7*� �+2� � � �')�'�����W��� �d�� :�+� ~��h��+� ~��h+�� 3+� ~�4�	:������!+� 7*� �+2� � � �')�'��++� 7*� �.2� � � �?+� 7*� �2� � � �-���0��3��W��� �d�� :�+� ~��h��+� ~��h+�� 3+� ~�4�	:������!+� 7*� �+2� � � �')�'�����W��� �d�� :�+� ~��h��+� ~��h+�� 3+� ~�4�	:������!+� 7*� �+2� � � �')�'��++� 7*� �.2� � � �A+� 7*� �+2� � � �-���0��3��W��� �d�� :�+� ~��h��+� ~��h+C� 3+� ~�4�	:������!+� 7*� �+2� � � �')�'�����W��� �d�� :�+� ~��h��+� ~��h+�� 3+� ~�4�	:������!+� 7*� �+2� � � �')�'��++� 7*� �.2� � � �E+� 7*� �'2� � � �-���0��3��W��� �d�� :�+� ~��h��+� ~��h+�� 3+� ~�4�	:������G��I���W��� �d�� :�+� ~��h��+� ~��h+�� 3+� ~�4�	:������K+� 7*� �+2� � � �'M�'��++� 7*� �/2� � � �E+� 7*� �'2� � � �-���0��3��W��� �d�� :�+� ~��h��+� ~��h+O� 3+� ~QS�4�U:��W�X�Z+� 7*� �+2� � � �')�'�]�^�c��d6��� 8+���F+�� 3��e���� :��� +�XW���� +�XW��f� �d�� :�+� ~��h��+� ~��h+�� 3+� ~QS�4�U:��!+� 7*� �+2� � � �')�'�X�g�c�j�m�o�]��d6��� 8+���F+�� 3��e���� :��� +�XW���� +�XW��f� �d�� :�+� ~��h��+� ~��h+q� 3+� ~�4�	:����s��!+� 7*� �+2� � � �')�'���W��� �d�� :�+� ~��h��+� ~��h+u� 3+�,+� ~.0�4�6:��w�;���?��B6��� O+���F+y� 3��P��� $:����T� :��� +�XW��[���� +�XW��[��^� �d�� :�+� ~��h��+� ~��h� :�+�k��+�k+�� 3++� 7*� �02�n �t� �� � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� �|� E W+�� 3�
++� 7*� �02�n �t� �� � �	�+�� 3+�,+� ~.0�4�6:��~�;���?��B6��� x+���F+�� 3+++� 7*� �02�n *� �12��� �K+M� 3��P��ʧ $:����T� :��� +�XW��[���� +�XW��[��^� �d�� :�+� ~��h��+� ~��h� :�+�k��+�k+�� 3+�,+� ~.0�4�6:����;���?��B6��� x+���F+�� 3+++� 7*� �02�n *� �22��� �K+M� 3��P��ʧ $:����T� :��� +�XW��[���� +�XW��[��^� �d�� :�+� ~��h��+� ~��h� :�+�k��+�k+�� 3++� 7*� �32�n �t� �� � �%+�� 3+�,+� ~.0�4�6:����;���?��B6��� O+���F+�� 3��P��� $:����T� :��� +�XW��[���� +�XW��[��^� �d�� :�+� ~��h��+� ~��h� :�+�k��+�k+�� 3++� 7*� �42�n *� �52���� �� � � S+�� 3+� 7*� �62� ޹ E W+�� 3+� 7*� �72+� 7*� �62� � � ��� E W+�� 3� p++� 7*� �42�n *� �52���� �� � � D+�� 3+� 7*� �72++� 7*� �42�n *� �52��� ��� E W+�� 3� +�� 3+�,+� ~.0�4�6:����;���?��B6��� �+���F+�� 3++� 7*� �72� � � �K+�� 3+++� 7*� �02�n *� �22��� �K+�� 3��P���� $:����T� :��� +�XW��[���� +�XW��[��^� �d�� :�+� ~��h��+� ~��h� :�+�k��+�k+�� 3+�,+� ~.0�4�6:����;���?��B6��� m+���F+�� 3++� 7*� �72� � � �K+�� 3��P��է $:����T� :��� +�XW��[¿�� +�XW��[��^� �d�� :�+� ~��hÿ+� ~��h� :�+�kĿ+�k+�� 3+�,+� ~.0�4�6:����;���?ŶB6��� m+�ƶF+�� 3++� 7*� �72� � � �K+�� 3ŶP��է $:��ǶT� :��� +�XWŶ[ȿ�� +�XWŶ[Ŷ^� �d�� :�+� ~Ŷhɿ+� ~Ŷh� :�+�kʿ+�k+�� 3+�,+� ~.0�4�6:����;�+� 7� =� � �?˶B6���7+�̶F+�� 3+++� 7*� �02�n *� �12��� �K+�� 3++� 7*� �2� � � �K+�� 3++� 7*� �2� � � �K+�� 3++� 7*� �2� � � �K+�� 3++� 7*� �2� � � �K+�� 3++� 7*� � 2� � � �K+�� 3+++� 7*� �82�n *� �*2��� �K+M� 3˶P��� $:��ͶT� :��� +�XW˶[ο�� +�XW˶[˶^� �d�� :�+� ~˶hϿ+� ~˶h� :�+�kп+�k+�� 3� +�� 3+�,+� ~.0�4�6:����;���?ѶB6��� O+�ҶF+�� 3ѶP��� $:��ӶT� :��� +�XWѶ[Կ�� +�XWѶ[Ѷ^� �d�� :�+� ~Ѷhտ+� ~Ѷh� :�+�kֿ+�k+�� 3+� 7� ��� E W+�� 3+� 7*� �2�� E W+�� 3+� 7*� �2�� E W+�� 3+� 7*� �2�� E W+�� 3+� 7*� �2�� E W+�� 3+� 7*� � 2�� E W+�� 3+� 7*� �&2�� E W+�� 3+� 7*� �!2�� E W+�� 3+� 7*� �'2�� E W+�� 3� 9+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� ��� E W+�� 3+׶ 3� `++� 7*� �$2�n �t� �� � � <+�� 3+� 7*� �#2� ޹ E W+�� 3+� 7� ��� E W+�� 3� +�� 3� +�� 3+�� 3+�,+�� 3++� 7*� �2� � � � 3+�� 3� :�+�k׿+�k+�� 3+�� 3+� 7*� �2� � �� �� � � -+�� 3+�,+ö 3� :�+�kؿ+�k+�� 3� M+� 7*� �2� � �� �� � � -+�� 3+�,+Ŷ 3� :�+�kٿ+�k+�� 3� +Ƕ 3+ɶ 3+� 7*� �2� � ˸ �� � � -+�� 3+�,+Ͷ 3� :�+�kڿ+�k+�� 3� N+� 7*� �2� � ˸ �� � � -+�� 3+�,+϶ 3� :�+�kۿ+�k+�� 3� +Ѷ 3+Ӷ 3+� 7*� �2� � ո �� � � -+�� 3+�,+׶ 3� :�+�kܿ+�k+�� 3� N+� 7*� �2� � ո �� � � -+�� 3+�,+ٶ 3� :�+�kݿ+�k+�� 3� +۶ 3+Ӷ 3+� 7*� �2� � ݸ �� � � -+�� 3+�,+ö 3� :�+�k޿+�k+�� 3� N+� 7*� �2� � ݸ �� � � -+�� 3+�,+߶ 3� :�+�k߿+�k+�� 3� +� 3+Ӷ 3+� 7*� �2� � � �� � � -+�� 3+�,+ö 3� :�+�k�+�k+�� 3� N+� 7*� �2� � � �� � � -+�� 3+�,+� 3� :�+�k�+�k+�� 3� +� 3+� 3+� 3+� 7*� �2� � �� �� � � -+�� 3+�,+� 3� :�+�k�+�k+�� 3� N+� 7*� �2� � �� �� � � -+�� 3+�,+� 3� :�+�k�+�k+�� 3� +� 3+Ӷ 3+� 7*� �2� � �� �� � � -+�� 3+�,+�� 3� :�+�k�+�k+�� 3� M+� 7*� �2� � �� �� � � -+�� 3+�,+�� 3� :�+�k�+�k+�� 3� +�� 3+�� 3+�,+�� 3++� 7*� �2� � � � 3+�� 3� :�+�k�+�k+�� 3+� 3+�,+� 3++� 7*� �2� � � � 3+�� 3� :�+�k�+�k+� 3+� 3+�,+� 3++� 7*� �2� � � � 3+�� 3� :�+�k�+�k+	� 3+�,+� 3++� 7*� � 2� � � � 3+�� 3� :�+�k�+�k+� 3+�,+� ~.0�4�6:���;�+� 7� =� � �?�B6��� O+��F+� 3�P��� $:���T� :��� +�XW�[���� +�XW�[�^� �d�� :�+� ~�h�+� ~�h� :�+�k�+�k+�� 3++� 7*� �92�n �t� �� � � +� 3� 1++� 7*� �92�n �t� �� � � +� 3� +� 3+� 3+� 3+� 3+� 7� � � �� �� � � -+�� 3+�,+� 3� :�+�k�+�k+�� 3� +�� 3+� 7� � � � �� � � -+�� 3+�,+!� 3� :�+�k�+�k+�� 3� +�� 3+� 7� � � � �� � � -+�� 3+�,+#� 3� :�+�k�+�k+�� 3� +�� 3+� 7� � � � �� � � -+�� 3+�,+%� 3� :�+�k�+�k+�� 3� +�� 3+� 7� � � )� �� � � -+�� 3+�,+'� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � )� �� � � -+�� 3+�,++� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � -� �� � � -+�� 3+�,+/� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � 1� �� � � -+�� 3+�,+3� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � 5� �� � � -+�� 3+�,+7� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � 9� �� � � -+�� 3+�,+;� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � =� �� � � -+�� 3+�,+?� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � A� �� � � -+�� 3+�,+C� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � E� �� � � -+�� 3+�,+G� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � I� �� � � -+�� 3+�,+K� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � M� �� � � -+�� 3+�,+O� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � Q� �� � � -+�� 3+�,+S� 3� :�+�k��+�k+�� 3� +�� 3+� 7� � � U� �� � � 1+�� 3+�,+W� 3� �: +�k� �+�k+�� 3� +�� 3+� 7� � � Y� �� � � 1+�� 3+�,+[� 3� �:+�k��+�k+�� 3� +�� 3+� 7� � � ]� �� � � 1+�� 3+�,+_� 3� �:+�k��+�k+�� 3� +�� 3+� 7� � � a� �� � � 1+�� 3+�,+c� 3� �:+�k��+�k+�� 3� +�� 3+� 7� � � e� �� � � 1+�� 3+�,+g� 3� �:+�k��+�k+�� 3� +i� 3+k� 3+m+� ^� d�:�6+� ^�� 9fY�:� "� hY� jYl� nm� rt� w� {� |���:�6+� ~�m� � ��� �+�� 3+n*� �:2� �� ��� �� � � ]+�� 3+�s*� �;2�v �� �� � � 3+�� 3+� 7*� �;2+�s*� �;2�v � E W+�� 3� � +�� 3+� 7�y� � {� �� � �w+�� 3+�,+� ~.0�4�6�:���;�+� 7� =� � �?��B�6	�	� g+��	�F+�� 3��P��� 2�:
��
�T�  �:�	� +�XW��[���	� +�XW��[��^� �d�� �:+� ~��h��+� ~��h� �:+�k��+�k+�� 3+�,+� ~.0�4�6�:�|�;�+� 7� =� � �?��B�6�� �+���F+~� 3++� ���� � � �K+M� 3��P��ק 2�:���T�  �:�� +�XW��[���� +�XW��[��^� �d�� �:+� ~��h��+� ~��h� �:+�k��+�k+�� 3+� ~���4���:�������W���� �d�� �:+� ~��h��+� ~��h+�� 3� +�� 3+�,+� ~.0�4�6�:���;�+� 7� =� � �?��B�6�� g+���F+�� 3��P��� 2�:���T�  �:�� +�XW��[���� +�XW��[��^� �d�� �:+� ~��h��+� ~��h� �:+�k��+�k+�� 3++� 7*� �<2�n �t� �� � � +�� 3��++� 7*� �<2�n �t� �� � ��+�� 3+�� 3+�,+����:+���6���� �6��� � � �I�6 � ��� ���:+� 7��� � d�6#��#`�ۙ�������� � � � ������6#+�� 3+�,+� ~.0�4�6�:$�$��;�$+� 7� =� � �?�$�B�6%�%� �+�$�%�F+�� 3++� 7��� � � �K+M� 3�$�P��ק 2�:&�$�&�T�  �:'�%� +�XW�$�[�'��%� +�XW�$�[�$�^� �d�� �:(+� ~�$�h�(�+� ~�$�h� �:)+�k�)�+�k+�� 3++� 7��� � � � 3+�� 3++� 7*� �=2�n �t� �� � � +�� 3� 1++� 7*� �=2�n �t� �� � � +�� 3� +�� 3++� 7*� �
2� � � � 3+�� 3+++� 7*� �>2� � ���� 3+�� 3++� 7*� �2� � � � 3+�� 3+� 7*� �?2� � �� �� � � '+�� 3++� 7��� � � � 3+�� 3� I+� 7*� �?2� � � �� � � '+�� 3++� 7��� � � � 3+�� 3� +�� 3��=� .�:*����� W+� 7�� ����*������ W+� 7�� ��� �:++�k�+�+�k+�� 3� +�� 3+� 7�y� � �� �� � � 1+�� 3+�,+�� 3� �:,+�k�,�+�k+�� 3� +�� 3+� 7*� �;2� � �� �� � � 1+�� 3+�,+¶ 3� �:-+�k�-�+�k+�� 3� +�� 3+� 7*� �;2� � � �� � � 1+�� 3+�,+Ķ 3� �:.+�k�.�+�k+�� 3� +�� 3+� 7*� �;2� � � �� � � 1+�� 3+�,+ƶ 3� �:/+�k�/�+�k+�� 3� +ȶ 3+ʶ 3+� 7*� �@2++�y̸�� E W+�� 3+�,+� ~.0�4�6�:0�0ζ;�0+� 7� =� � �?�0�B�61�1� g+�0�1�F+ж 3�0�P��� 2�:2�0�2�T�  �:3�1� +�XW�0�[�3��1� +�XW�0�[�0�^� �d�� �:4+� ~�0�h�4�+� ~�0�h� �:5+�k�5�+�k+�� 3+�,+� ~.0�4�6�:6�6Ҷ;�6+� 7� =� � �?�6�B�67�7� g+�6�7�F+Զ 3�6�P��� 2�:8�6�8�T�  �:9�7� +�XW�6�[�9��7� +�XW�6�[�6�^� �d�� �::+� ~�6�h�:�+� ~�6�h� �:;+�k�;�+�k+�� 3+�,+ֶ 3++��*� �A2�� � � 3+߶ 3+++� 7*� �B2�n ���� � 3+� 3+++� 7*� �C2�n ���� � 3+� 3++� 7*� �@2� � � � 3+� 3� �:<+�k�<�+�k+� 3� �&TW )&`c  ���  ���    )),  �bb  �||  _�� )_��  )��  ��  Xhk )Xtw  "��  ��  ���  2  '*- )'69  �oo  ���  � )�&)  �__  �yy  <? )HK  ���  ���  ��� )�	  �??  �YY  ��� )���  ���  p  =rr  �%%  U��  � Y Y   � � �  !
!�!�  !�""  "?"�"�  "�#D#D  #t#�#�  $($y$y  $�%-%-  %]%�%�  %�&b&b  &�&�&�  ''�'�  '�((  (I(�(�  (�)2)2  )b)�)�  *`*r*r  **�*�  ++1+1  *�+]+]  +�+�+�  ,1,A,D ),1,M,P  ,,�,�  +�,�,�  -v-�-� )-v-�-�  -Q-�-�  ->..  .].�.� ).].�.�  .8.�.�  .%.�.�  /n/~/� )/n/�/�  /I/�/�  /6/�/�  11r1u )11~1�  0�1�1�  0�1�1�  2 2N2Q )2 2Z2]  1�2�2�  1�2�2�  2�3*3- )2�3639  2�3o3o  2�3�3�  3�4�4� )3�4�4�  3�55  3�5858  5�5�5� )5�5�5�  5k5�5�  5X5�5�  7�7�7�  88!8!  8a8k8k  8�8�8�  999  9^9h9h  9�9�9�  :::  :M:W:W  :�:�:�  :�:�:�  ;Q;[;[  ;�;�;�  ;�;�;�  <><H<H  <p<�<�  <�<�<�  <�=&=&  =>=f=f  =�=�=� )=�=�=�  =�>>  =~>.>.  >�>�>�  ?.?8?8  ?|?�?�  ?�?�?�  @@"@"  @f@p@p  @�@�@�  AAA  APAZAZ  A�A�A�  A�A�A�  B:BDBD  B�B�B�  B�B�B�  C$C.C.  CrC|C|  C�C�C�  DDD  DdDnDn  D�D�D�  EEE  F�F�F� )F�F�F�  FpGG  F[G9G9  G�G�G� )G�G�G�  GiH*H*  GTHLHL  HxH�H�  I!I3I6 )I!IEIH  H�I�I�  H�I�I�  K*KVKY )K*KhKk  J�K�K�  J�K�K�  J�M[M[  J)M�M�  M�M�M�  NJNTNT  N�N�N�  N�O O   O�O�O� )O�O�O�  OcP
P
  ONP,P,  P�P�P� )P�P�P�  P\QQ  PGQ%Q%  Q@Q�Q�   �         * +  �  	JR           @  A ! k $ � - � 0 � 9 � < � ? � B � E � H � K � � � �g �� �� � �; �G �� �� �� � �' �� �� �� �� m����Q	y
���5]���Ah���%Ls �!		"	0#	W$	c&	�'	�(
)
;*
G,
�-
�.
�/0+2�3�4�5�6:2;L<b=�>�?�@�A�BCDGmH�I�J�KL9MONXOrPxQ�T�U�VWVX�Y�Z�[�\�]�^�a9bScid�e�fgh&i@jFkOm�n�o�p$qTrns�t�u�v�w�y�z*{H|�~��V�����������������c������������3�Q�o����\���+������������0�����i���'�������<�<�?����� 
� p� p� s� ��!�!>�!��!��!��")�"O�"s�"��"��"��#^�#��#��$�$�$�$��$��$��%D�%D�%G�%��%��&�&y�&y�&|�&��'#�'G�'��'��'��(3�(Y�(}�(��(��(�)L)r)�)�)�*	*!
*E*c*�*�*�++"+x+�+�+�+�+�,5,�!,�",�#-
%-7'-z(-�).+.a,.�-////1/r3/�5060970f80�90�:0�<1=1f>1�@2$A2BB2�D3 E3F3�H3�I4�J5HK5QM5�O6Q6%S6>T6WU6pV6�W6�X6�Y6�Z6�]6�^7_7&`7,d7Ye7sf7�g7�j7�k7�|7��7��7��8�8�8.�81�8Z�8e�8x�8{�8��8��8��8��8��8��8��8��8��9	�9�9�9)�9,�90�93�9W�9b�9u�9x�9��9��9��9��9��9��9��9��9��:�:�:�:F�:Q�:d�:g�:q�:t:x:{:�:�:�:�	:�
:�;;;;.;#/;&3;J4;U5;h6;k7;�8;�9;�:;�;;�B;�N;�O;�P;�Q;�R<S<T<7U<BV<UW<XX<b_<el<im<lw<��<��=:�=z�=��>>�>i�>o�>��>��>��>��>��>��>��>��>��?�?'�?2�?E�?H�?Q�?u�?��?��?��?��?��?��?��?��?��@�@�@/�@2�@; @_@j@}@�@�@�@�	@�
@�@�@�AAAA%AIATAgAjAsA�A�A�A�A�!A�"A�#B$B%B'B3(B>)BQ*BT+B].B�/B�0B�1B�2B�4B�5B�6B�7B�8B�:C;C(<C;=C>>CG@CkACvBC�CC�DC�GC�HC�IC�JC�KC�MDNDOD-PD0QD9SD]TDhUDVD�WD�YD�ZD�[D�\D�]D�_E`EaE#bE&cE0kE3�E:�E��E��E��F$�F0�FT�F��GM�G��G��H`�H��H��H��I%�I��I��I��J�J�J%�J��K.�KH�K��K��L �L�L+�L1�LY�L_�Lc�Lf�L��L��L��L��L��M�M�M.�M1�MH�MN�MR�MX�M��M��M��M��M��M��N�N NNCNNNeNhNqN�	N�
N�N�N�N�N�OOOO(0OG1O�3P@4P�6Q97QD8Q�9�     ) �� �        �    �     ) �� �         �    �     ) �� �        �    �    �    �  �    �*D� �Y��SY�SY�SY	�SY�SY�SY�SY�SY�SY	�SY
�SY�SY�SY�SY�SY!�SY#�SY%�SY'�SY)�SY+�SY-�SY/�SY1�SY3�SY5�SY7�SY9�SY;�SY=�SY?�SYA�SY C�SY!E�SY"G�SY#I�SY$K�SY%M�SY&O�SY'Q�SY(S�SY)U�SY*W�SY+Y�SY,[�SY-]�SY._�SY/a�SY0c�SY1e�SY2g�SY3i�SY4k�SY5m�SY6o�SY7q�SY8s�SY9u�SY:m�SY;w�SY<y�SY={�SY>}�SY?�SY@��SYA��SYB��SYC��S� ��     �    