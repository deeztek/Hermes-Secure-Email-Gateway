����   2 L__138/__138/publish/hermes_seg_18_041454/proprietary/file_expressions_cfm$cf  lucee/runtime/PageImpl  ?../../publish/hermes-seg-18.04/proprietary/file_expressions.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  �ͩq getSourceLength      � getCompileTime  �@,�) getHash ()IU4� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this NL__138/__138/publish/hermes_seg_18_041454/proprietary/file_expressions_cfm$cf;
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>File Expressions</title>
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
              <td height="500" width="988"> P@       keys $[Llucee/runtime/type/Collection$Key; T U	  V !lucee/runtime/type/Collection$Key X *lucee/runtime/functions/decision/IsDefined Z B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & \
 [ ] 
 _ sessionScope $()Llucee/runtime/type/scope/Session; a b
 / c  lucee/runtime/type/scope/Session e get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; g h f i 	VIOLATION k lucee/runtime/op/Operator m compare '(Ljava/lang/Object;Ljava/lang/String;)I o p
 n q lucee/runtime/PageContextImpl s lucee.runtime.tag.Location u 
cflocation w @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:175 y use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; { |
 t } lucee/runtime/tag/Location  license_invalid.cfm � setUrl � 1
 � � setAddtoken (Z)V � �
 � � 
doStartTag � $
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 t � NEW � @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:177 �,
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion30" style="background-image: url('./middle_988.png'); height: 500px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="517">
                              <tr valign="top" align="left">
                                <td width="10" height="8"></td>
                                <td width="1"></td>
                                <td width="505"></td>
                                <td width="1"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td colspan="2" width="506" id="Text497" class="TextObject">
                                   �?<p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Custom File Expressions</span></b></p>
                                </td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="4" height="5"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2"></td>
                                <td colspan="2" width="506" id="Text351" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Custom File Expression</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="453">
                               �<tr valign="top" align="left">
                                <td width="428" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/custom-file-expressions/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="974">
                        <tr valign="top" align="left">
                          <td width="11" height="4"></td>
                           � �<td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="260"></td>
                          <td width="963"> � m � &lucee/runtime/config/NullSupportHelper � NULL � '
 � � -lucee/runtime/interpreter/VariableInterpreter � getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; � �
 � � 0 � %lucee/runtime/exp/ExpressionException � java/lang/StringBuilder � The required parameter [ �  1
 � � append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; � �
 � � ] was not provided. � -(Ljava/lang/String;)Ljava/lang/StringBuilder; � �
 � � toString ()Ljava/lang/String; � �
 � �
 � � any ��       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 t � m2 � 

 � step �  


 � action �   �  
 �@       _action � ;	 9 � True � (ZLjava/lang/String;)I o �
 n � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � ;	 9 � lucee/runtime/type/scope/Form � � i 	extension �  

 � description � _description � ;	 9 � customextension � 	casesense  no� 

                            <table border="0" cellspacing="0" cellpadding="0" width="963" id="LayoutRegion5" style="height: 260px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="963">
                                    <tr valign="top" align="left">
                                      <td height="232" width="963"> A i add #lucee/commons/color/ConstantsDouble	 _1 Ljava/lang/Double;	
 _0	
 _M ;	 9 _2	
 



 1 [^a-zA-Z0-9\-\.\_\,\(\) ] lucee/runtime/op/Caster &(Ljava/lang/Object;)Ljava/lang/String; � 
! %lucee/runtime/functions/string/REFind# S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object; &%
$& (Ljava/lang/Object;D)I o(
 n) _4+	
, _5.	
/ 21 


3 outputStart5 
 /6 lucee.runtime.tag.Query8 cfquery: @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:303< lucee/runtime/tag/Query> hasBody@ �
?A customtransC setNameE 1
?F setDatasource (Ljava/lang/Object;)VHI
?J getrandom_resultsL 	setResultN 1
?O
? � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)VRS
 /T Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
V doAfterBodyX $
?Y doCatch (Ljava/lang/Throwable;)V[\
?] popBody ()Ljavax/servlet/jsp/JspWriter;_`
 /a 	doFinallyc 
?d
? � 	outputEndg 
 /h @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:307j inserttransl stResultn &
insert into salt
(salt)
values
('p getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;rs
 /t getIdv $
 /w lucee/runtime/type/Queryy getCurrentrow (I)I{|z} getRecordcount $z� !lucee/runtime/util/NumberIterator� load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� A� isValid (I)Z��
�� current� $
�� go (II)Z��z� #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� writePSQ�I
 /� removeQuery�  A� release &(Llucee/runtime/util/NumberIterator;)V��
�� ')
� @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:314� gettrans� 2
select salt as customtrans2 from salt where id='� getCollection� h A� I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; g�
 /� '
� @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:320� deletetrans� 
delete from salt where id='� yes� lucee.runtime.tag.FileTag� cffile� @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:325� lucee/runtime/tag/FileTag�
�A read� 	setAction� 1
�� #/opt/hermes/scripts/exp_allow_sense� setFile� 1
�� 	fileallow� setVariable� 1
��
� �
� � @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:326� "/opt/hermes/scripts/exp_deny_sense� filedeny� @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:328� %/opt/hermes/scripts/exp_allow_insense� @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:329� $/opt/hermes/scripts/exp_deny_insense� @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:332� 0 /opt/hermes/tmp/� java/lang/String� concat &(Ljava/lang/String;)Ljava/lang/String;��
�� 
file_allow� THE-EXPRESSION� ALL� (lucee/runtime/functions/string/REReplace� w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &�
�� 	setOutput�I
�� 
    
� @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:336 	file_deny @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:340 @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:341 
    


	 @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:344 insertextension stSender N
insert into files
(file, description, type, system, allow, ban)
values
(' ', ' ', 'CUSTOM-EXPRESSION', 'NO', ' 'lucee/runtime/functions/file/FileExists 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &
 @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:352 delete @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:356  _6"	
#�










                                        <form name="block" action="file_expressions.cfm" method="post">
                                          <input type="hidden" name="action" value="add">
                                          <table border="0" cellspacing="0" cellpadding="0" width="963">
                                            <tr valign="top" align="left">
                                              <td width="963" id="Text424" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enter a File Expression in the box below. File expressions follow the Regular Expression format (regexp). Your regexp should be tested before entering it. A good place to test your regexp is <a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);" href="https://regex101.com">https://regex101.com</a>. Example: Suppose you want to identify all Microsoft Office Word and Excel with the file name that has the word &#8220;invoice&#8221; in it, then the regexp would look like this: %<b>(invoice){1,}.*(doc|xls|docx|xlsx){1,} </b></span></p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="800">
                                            <tr valign="top" align="left">
                                              <td height="1"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td height="22" width="800"><input type="text" id="FormsEditField39" name="extension" size="100" maxlength="255" style="width: 796px; white-space: pre;"></td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="963">
                                            '#<tr valign="top" align="left">
                                              <td width="963" height="15"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="963" id="Text498" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif;"><span style="font-size: 12px; color: rgb(128,128,128);">Select below whether you want the file expression to be case sensitive or case insensitive. In most cases you should leave the default setting of case insensitive selected</span><span style="font-style: normal;"></span></span></p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            )�<tr valign="top" align="left">
                                              <td height="2"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="531">
                                                <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="531" style="height: 12px;">
                                                  <tr style="height: 17px;">
                                                    <td width="51" id="Cell1023">
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;">+ i
<input type="radio" checked="checked" name="casesense" value="no" style="height: 13px; width: 13px;">
- W
<input type="radio" name="casesense" value="no" style="height: 13px; width: 13px;">
/X
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      &nbsp;</td>
                                                    <td width="480" id="Cell1024">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Case Insensitive <span style="color: rgb(51,51,51); font-weight: normal;">(Recommended)</span></span></b></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1025">
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        1 �<tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;">3 j
<input type="radio" checked="checked" name="casesense" value="yes" style="height: 13px; width: 13px;">
5 X
<input type="radio" name="casesense" value="yes" style="height: 13px; width: 13px;">
7
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      &nbsp;</td>
                                                    <td id="Cell1026">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Case Sensitive</span></b></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="963">
                                            9<tr valign="top" align="left">
                                              <td width="963" height="15"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="963" id="Text432" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enter a description for your new File Expression. Example: Block all Invoice&nbsp; Microsoft Office Word and Excel Files</span></p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="440">
                                            <tr valign="top" align="left">
                                              ;><td height="3"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td height="22" width="440"><input type="text" id="FormsEditField43" name="description" size="55" maxlength="75" style="width: 436px; white-space: pre;"></td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td height="24"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="963">
                                                <table id="Table152" border="0" cellspacing="0" cellpadding="0" width="963" style="height: 24px;">
                                                  =1<tr style="height: 24px;">
                                                    <td width="963" id="Cell934">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><input type="submit" id="FormsButton5" name="FormsButton5" value="Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
&nbsp;</p>
                                                                </td>
                                                              ?P</tr>
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
                                        </form>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="11"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="963" id="Text459" class="TextObject">
                                        A <p style="margin-bottom: 0px;">Cr
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must enter a period (.) before the file extension</span></i></b></p>
Ee
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the file extension field cannot be blank</span></i></b></p>
G 3I�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the file extension field must only include dashes, periods or underscores</span></i></b></p>
K 4M�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the description field must only include dashes, periods, underscores, commas, brackets and spaces</span></i></b></p>
O 5Qb
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the description field cannot be blank</span></i></b></p>
S 6Ub
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! File Extension added</span></i></b></p>
W 7Ys
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the extension you are attempting to add already exists</span></i></b></p>
[
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
                      <table border="0" cellspacing="0" cellpadding="0" width="973">
                        <tr valign="top" align="left">
                          <td width="10" height="1"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="453"></td>
                          <td width="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="3" valign="middle" width="960"><hr id="HRRule21" width="960" size="1"></td>
                          ]�<td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="506" id="Text415" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Delete Custom File Expression</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="75"></td>
                          <td colspan="3" width="962">_ @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:602a checkexistsc <
SELECT file_id from file_rule_components where file_id = 'e #lucee/runtime/util/VariableUtilImplg recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;ij
hk @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:607m  
delete from files where id = 'o _3q	
rM

                            <table border="0" cellspacing="0" cellpadding="0" width="962" id="LayoutRegion4" style="height: 75px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="962">
                                    <tr valign="top" align="left">
                                      <td height="50" width="962">
                                        <form name="delete" action="file_expressions.cfm" method="post">
                                          <input type="hidden" name="action" value="delete">
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td width="962">
                                                <table id="Table1" border="0" cellspacing="0" cellpadding="0" width="962" style="height: 50px;">
                                                  t�<tr style="height: 24px;">
                                                    <td width="962" id="Cell7">
                                                      <table width="608" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;">v @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:637x getextensionsz n
select id, file, description from files where system = 'NO' and type='CUSTOM-EXPRESSION' order by file asc
| D
<select name="customextension" style="height: 88px;" size="300">
~ 
<option value="� _ID� ;	 9� ">� _FILE� ;	 9�  ---> � </option>
� 
</select>
� �
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No Custom File Expressions found...</span></i></b></p>
�C
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 26px;">
                                                    <td id="Cell1">
                                                      <table width="68" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;">� �
<input type="submit" id="FormsButton5" name="FormsButton5" value="Delete" style="height: 24px; width: 69px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
�
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
                                        </form>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="8"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="962" id="Text276" class="TextObject">
                                        �w
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry before clicking the Delete button</span></i></b></p>
�d
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! File Extension deleted</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the File Extension you are attempting to remove is part of a File Rule. Please remove the extension from the File Rule and then try to delete again</span></i></b></p>
�
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
                        � �</tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;">� $lucee/runtime/functions/dateTime/Now� =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &�
�� yyyy� 4lucee/runtime/functions/displayFormatting/DateFormat� S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &�
�� @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:726� 
getversion� D
SELECT value from system_settings where parameter = 'version_no'
� @C:\publish\hermes-seg-18.04\proprietary\file_expressions.cfm:729� getbuild� B
SELECT value from system_settings where parameter = 'build_no'
� V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway � 	 Version:� _VALUE� ;	 9�  Build:� . Copyright 2011-� l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>�A&nbsp;</p>
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
 ����� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � license� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� LICENSE� 	EXTENSION� DESCRIPTION� CUSTOMEXTENSION� 	CASESENSE� STEP� RANDOM� STRESULT� GENERATED_KEY� CUSTOMTRANS3� GETTRANS� CUSTOMTRANS2� 	FILEALLOW� FILEDENY� M2� CHECKEXISTS  GETEXTENSIONS THEYEAR EDITION 
GETVERSION GETBUILD
 subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             T U             *     *� 
*� *� � *�ҵ�*+�ٱ                 �                � �                 �                 �                  !�      # $         %�      & '   '�  �  !�+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+ R*� W2� Y� ^�+`� 3+� d*� W2� j l� r� � � W+`� 3+� tvxz� ~� �M,�� �,� �,� �W,� �� � ��� N+� t,� �-�+� t,� �+`� 3� �+� d*� W2� j �� r� � � `+`� 3+� tvx�� ~� �:�� �� �� �W� �� � ��� :+� t� ��+� t� �+`� 3� +`� 3� +�� 3+�� 3+�� 3+�� 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� ��� �¶ Ŷ ɷ ʿ:6+� t�� � �� �+`� 3+�+� �� �:	6
+� �	� 0�Y:� !� �Y� �Y�� �Զ �¶ Ŷ ɷ ʿ:	6
+� t��	 � �
� �+ֶ 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� �ض �¶ Ŷ ɷ ʿ:6+� t�� � �� �+ڶ 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� �ܶ �¶ Ŷ ɷ ʿ:6+� t�� � �� �+� 3+ � �� Y� ^� �� � � Q+`� 3+� � � � ޸ r� � � ++`� 3+� 7� �+� � � � � E W+`� 3� � +ֶ 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� ��� �¶ Ŷ ɷ ʿ:6+� t�� � �� �+� 3+ �*� W2� Y� ^� �� � � Z+`� 3+� �*� W2� � ޸ r� � � 1+`� 3+� 7*� W2+� �*� W2� � � E W+`� 3� � +�� 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� ��� �¶ Ŷ ɷ ʿ:6+� t�� � �� �+� 3+ � �� Y� ^� �� � � Z+`� 3+� �*� W2� � ޸ r� � � 1+`� 3+� 7*� W2+� �*� W2� � � E W+`� 3� � +�� 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� ��� �¶ Ŷ ɷ ʿ:6+� t�� � �� �+� 3+ �*� W2� Y� ^� �� � � ]+`� 3+� �*� W2� � ޸ r� � � 3+`� 3+� 7*� W2+� �*� W2� � � E W+`� 3� � +�� 3++� �� �:6+� �� 2Y:� "� �Y� �Y�� �� �¶ Ŷ ɷ ʿ:6+� t� � �� �+� 3+ �*� W2� Y� ^� �� � � ]+`� 3+� �*� W2� � ޸ r� � � 3+`� 3+� 7*� W2+� �*� W2� � � E W+`� 3� � +� 3+� 7� � � r� � �0+`� 3+� 7*� W2� ޸ r� � � &+`� 3+� 7*� W	2�� E W+`� 3� \+� 7*� W2� ޸ r� � � <+`� 3+� 7*� W	2�� E W+`� 3+� 7��� E W+`� 3� +� 3+� 7*� W	2� � r� � �+`� 3+� 7*� W2� ޸ r� � � �+ֶ 3++� 7*� W2� �"�'�*� � � <+`� 3+� 7*� W	2�� E W+`� 3+� 7��-� E W+ֶ 3� #+`� 3+� 7*� W	2�� E W+`� 3+`� 3� \+� 7*� W2� ޸ r� � � <+`� 3+� 7*� W	2�� E W+`� 3+� 7��0� E W+`� 3� +ֶ 3� +ֶ 3+� 7*� W	2� 2� r� � �+4� 3+�7+� t9;=� ~�?:�BD�G+� 7� =� �KM�P�Q6� O+�U+W� 3�Z��� $:  �^� :!� +�bW�e!�� +�bW�e�f� � ��� :"+� t� �"�+� t� �� :#+�i#�+�i+ֶ 3+�7+� t9;k� ~�?:$$�B$m�G$+� 7� =� �K$o�P$�Q6%%�B+$%�U+q� 3+�7+D�u:'+�x6('(�~ 6)'�� � � � �6**'�� ��:&+� 7'�� *d6-&-`��� D'&��(�� � � � � (&��6-+++� 7*� W
2� �"�������� ":.')(�� W+� 7�� &��.�')(�� W+� 7�� &��� :/+�i/�+�i+�� 3$�Z�� � $:0$0�^� :1%� +�bW$�e1�%� +�bW$�e$�f� � ��� :2+� t$� �2�+� t$� �� :3+�i3�+�i+ֶ 3+�7+� t9;�� ~�?:44�B4��G4+� 7� =� �K4�Q655� x+45�U+�� 3+++� 7*� W2�� *� W2���"��+�� 34�Z��ʧ $:646�^� :75� +�bW4�e7�5� +�bW4�e4�f� � ��� :8+� t4� �8�+� t4� �� :9+�i9�+�i+ֶ 3+� 7*� W2++� 7*� W2�� *� W2��� E W+ֶ 3+�7+� t9;�� ~�?:::�B:��G:+� 7� =� �K:�Q6;;� x+:;�U+�� 3+++� 7*� W2�� *� W2���"��+�� 3:�Z��ʧ $:<:<�^� :=;� +�bW:�e=�;� +�bW:�e:�f� � ��� :>+� t:� �>�+� t:� �� :?+�i?�+�i+ֶ 3+� 7*� W2� �� r� � � �+`� 3+� t��ö ~��:@@��@ȶ�@Ͷ�@Ҷ�@��W@��� � ��� :A+� t@� �A�+� t@� �+`� 3+� t��ٶ ~��:BB��Bȶ�B۶�Bݶ�B��WB��� � ��� :C+� tB� �C�+� tB� �+`� 3� �+� 7*� W2� � r� � � �+`� 3+� t��߶ ~��:DD��Dȶ�D��DҶ�D��WD��� � ��� :E+� tD� �E�+� tD� �+`� 3+� t��� ~��:FF��Fȶ�F��Fݶ�F��WF��� � ��� :G+� tF� �G�+� tF� �+`� 3� +ֶ 3+� t��� ~��:HH��H��H�+� 7*� W2� �"�����H++� 7*� W2� �"�+� 7*� W2� �"�����H��WH��� � ��� :I+� tH� �I�+� tH� �+ � 3+� t��� ~��:JJ��J��J�+� 7*� W2� �"�����J++� 7*� W2� �"�+� 7*� W2� �"�����J��WJ��� � ��� :K+� tJ� �K�+� tJ� �+ֶ 3+� t��� ~��:LL��Lȶ�L�+� 7*� W2� �"�����LҶ�L��WL��� � ��� :M+� tL� �M�+� tL� �+`� 3+� t��� ~��:NN��Nȶ�N�+� 7*� W2� �"�����Nݶ�N��WN��� � ��� :O+� tN� �O�+� tN� �+
� 3+�7+� t9;� ~�?:PP�BP�GP+� 7� =� �KP�PP�Q6QQ� �+PQ�U+� 3++� 7*� W2� �"��+� 3++� 7*� W2� �"��+� 3++� 7*� W2� �"��+� 3++� 7*� W2� �"��+�� 3P�Z��}� $:RPR�^� :SQ� +�bWP�eS�Q� +�bWP�eP�f� � ��� :T+� tP� �T�+� tP� �� :U+�iU�+�i+ֶ 3+�+� 7*� W2� �"����� �+`� 3+� t��� ~��:VV��V��V�+� 7*� W2� �"�����V��WV��� � ��� :W+� tV� �W�+� tV� �+`� 3� +ֶ 3+�+� 7*� W2� �"����� �+`� 3+� t��!� ~��:XX��X��X�+� 7*� W2� �"�����X��WX��� � ��� :Y+� tX� �Y�+� tX� �+`� 3� +ֶ 3+� 7*� W	2�� E W+`� 3+� 7��$� E W+� 3� +ֶ 3� +&� 3+(� 3+*� 3+,� 3+� 7*� W2� � r� � � -+`� 3+�7+.� 3� :Z+�iZ�+�i+`� 3� O+� 7*� W2� � r� � � -+`� 3+�7+0� 3� :[+�i[�+�i+`� 3� +2� 3+4� 3+� 7*� W2� �� r� � � -+`� 3+�7+6� 3� :\+�i\�+�i+`� 3� O+� 7*� W2� �� r� � � -+`� 3+�7+8� 3� :]+�i]�+�i+`� 3� +:� 3+<� 3+>� 3+@� 3+B� 3+D� 3+� 7�� � r� � � -+`� 3+�7+F� 3� :^+�i^�+�i+`� 3� +ֶ 3+� 7�� 2� r� � � -+`� 3+�7+H� 3� :_+�i_�+�i+`� 3� +ֶ 3+� 7�� J� r� � � -+`� 3+�7+L� 3� :`+�i`�+�i+`� 3� +ֶ 3+� 7�� N� r� � � -+`� 3+�7+P� 3� :a+�ia�+�i+`� 3� +ֶ 3+� 7�� R� r� � � -+`� 3+�7+T� 3� :b+�ib�+�i+`� 3� +4� 3+� 7�� V� r� � � -+`� 3+�7+X� 3� :c+�ic�+�i+`� 3� +ֶ 3+� 7�� Z� r� � � -+`� 3+�7+\� 3� :d+�id�+�i+`� 3� +^� 3+`� 3+� 7� � � r� � ��+ֶ 3+� 7*� W2� ޸ r� � � &+`� 3+� 7*� W2�� E W+ֶ 3�y+`� 3+�7+� t9;b� ~�?:ee�Bed�Ge+� 7� =� �Ke�Q6ff� m+ef�U+f� 3++� 7*� W2� �"��+�� 3e�Z��է $:geg�^� :hf� +�bWe�eh�f� +�bWe�ee�f� � ��� :i+� te� �i�+� te� �� :j+�ij�+�i+ֶ 3++� 7*� W2�� �l�*� � �+`� 3+�7+� t9;n� ~�?:kk�Bkd�Gk+� 7� =� �Kk�Q6ll� m+kl�U+p� 3++� 7*� W2� �"��+�� 3k�Z��է $:mkm�^� :nl� +�bWk�en�l� +�bWk�ek�f� � ��� :o+� tk� �o�+� tk� �� :p+�ip�+�i+ֶ 3+� 7*� W2�� E W+ֶ 3� J++� 7*� W2�� �l�*� � � &+`� 3+� 7*� W2�s� E W+`� 3� +ֶ 3+`� 3� +u� 3+w� 3+�7+� t9;y� ~�?:qq�Bq{�Gq+� 7� =� �Kq�Q6rr� O+qr�U+}� 3q�Z��� $:sqs�^� :tr� +�bWq�et�r� +�bWq�eq�f� � ��� :u+� tq� �u�+� tq� �� :v+�iv�+�i+ֶ 3++� 7*� W2�� �l�*� � �=+� 3+�7+{�u:x+�x6yxy�~ 6zx�� � � � �6{{x�� ��:w+� 7x�� {d6~w~`��� �xw��y�� � � � � ew��6~+�� 3++� 7��� �"� 3+�� 3++� 7��� �"� 3+�� 3++� 7*� W2� �"� 3+�� 3��y� ":xzy�� W+� 7�� w���xzy�� W+� 7�� w��� :�+�i��+�i+�� 3� 
+�� 3+�� 3++� 7*� W2�� �l�*� � � +�� 3� +�� 3+D� 3+� 7*� W2� � r� � � -+`� 3+�7+�� 3� :�+�i��+�i+`� 3� +ֶ 3+� 7*� W2� 2� r� � � -+`� 3+�7+�� 3� :�+�i��+�i+`� 3� +ֶ 3+� 7*� W2� J� r� � � -+`� 3+�7+�� 3� :�+�i��+�i+`� 3� +�� 3+�� 3+� 7*� W2++������ E W+`� 3+�7+� t9;�� ~�?:���B���G�+� 7� =� �K��Q6��� O+���U+�� 3��Z��� $:����^� :��� +�bW��e���� +�bW��e��f� � ��� :�+� t�� ���+� t�� �� :�+�i��+�i+`� 3+�7+� t9;�� ~�?:���B���G�+� 7� =� �K��Q6��� O+���U+�� 3��Z��� $:����^� :��� +�bW��e���� +�bW��e��f� � ��� :�+� t�� ���+� t�� �� :�+�i��+�i+`� 3+�7+�� 3++� d*� W2� j �"� 3+�� 3+++� 7*� W2�� �����"� 3+¶ 3+++� 7*� W2�� �����"� 3+Ķ 3++� 7*� W2� �"� 3+ƶ 3� :�+�i��+�i+ȶ 3� G � � �   �##  	n	~	� )	n	�	�  	2	�	�  		�	�  
�
�
�  
Q,,  
FIL )
FUX  

��  	���  	BE )	NQ  ���  ���  4mp )4y|   ��  ���  RR  ���  MM  ���  �nn  �  R��  �''  �!$ )�-0  _ff  I��  �  ���  z��  ���   **  lvv  ���  ,66  z��  ���      eoo  ���  ��� )���  i  S**  ��� )���  �((  kBB  $47 )$@C  �yy  ���  $��  ���  z��  ���  ((  ��� )���  �    r + +   � � � ) � � �   X � �   B � �  !!�!�            * +    � �   
        6  7 ! a $ z - � 0 � 9 � O � u � � � � �= �F �O �R �X �[ �^ �d �� �% �� �� � �0 �O �[ �� �� �
 �/ �; �� �� �� � � z����a��	�
��.Hq�����(B X"a#{$�%�&�'�(�*�,	/	r1	�3
J7=8�:;6<�>�@8AaB�DElF�G�HgI�J�LM%N�L�N�P�Q�R6P6R9T�UBX�\]�_�`8aAcmd�e�gh#l,n6y9~@�D�G�K�N�s�~����������������������$�7�:�e�p����������������������
%0CFOs~��������-0 :#^$i%|&'�)�*�+�,�-�.�C�TV)WCYLZ�[�\:^d_�`�aRcle�f�g�i�j�l�x�y�}(������W����������:�@�D�G�s�~������������������"�5�8�B�L�k��� ;� ��!�!�     ) ��         �         ) ��          �         ) ��         �        �           �*� YY۸�SY��SY���SY��SY��SY���SY��SY��SY��SY	���SY
��SY��SY��SY���SY���SY���SY���SY���SY���SY��SY��SY��SY��SY	��SY��S� W�         