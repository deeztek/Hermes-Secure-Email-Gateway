����   2� clear_bayes_cfm$cf  lucee/runtime/PageImpl  /admin/clear_bayes.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength      @� getCompileTime  n��K getHash ()I��y call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Lclear_bayes_cfm$cf;
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Clear Bayes</title>
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
              <td height="418" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion30" style="background-image: url('./middle_988.png'); height: 418px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="523">
                              <tr valign="top" align="left">
                                <td width="17" height="15"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                 P<td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Clear Bayes Database</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="447">
                              <tr valign="top" align="left">
                                <td width="422" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/clear-bayes-database/')"> R�<img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="16" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="137"></td>
                          <td width="951"> T m V &lucee/runtime/config/NullSupportHelper X NULL Z '
 Y [ -lucee/runtime/interpreter/VariableInterpreter ] getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; _ `
 ^ a 0 c %lucee/runtime/exp/ExpressionException e java/lang/StringBuilder g The required parameter [ i  1
 h k append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; m n
 h o ] was not provided. q -(Ljava/lang/String;)Ljava/lang/StringBuilder; m s
 h t toString ()Ljava/lang/String; v w
 h x
 f k lucee/runtime/PageContextImpl { any }�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 | �  

 � action �   �  
 �@       _action � ;	 9 � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � 
 � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � ;	 9 � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � A � 
clearbayes � 

 � lucee.runtime.tag.Execute � 	cfexecute � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 | � lucee/runtime/tag/Execute � /usr/bin/sa-learn � setName � 1
 � �@n       
setTimeout (D)V � �
 � � 	/dev/null � setOutputfile � 1
 � � --clear � setArguments (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � doAfterBody � $
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 | � _M � ;	 9 � #lucee/commons/color/ConstantsDouble � _1 Ljava/lang/Double; � �	 � �
                            <table border="0" cellspacing="0" cellpadding="0" width="951" id="LayoutRegion15" style="height: 137px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" id="Text454" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Occasionally, the Bayes Database can become corrupted or poisoned due to bad database training or other factors. Please press the <b>Clear Database</b> button below to clear your database.</span></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                     �I<tr valign="top" align="left">
                                      <td height="32"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951">
                                        <table id="Table148" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="951" id="Cell872">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="242" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td class="TextObject">
                                                           �	<p style="text-align: center; margin-bottom: 0px;"><form name="clearbayes" action="" method="post">
<input type="hidden" name="action" value="clearbayes">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="changepass" value="Clear Database" style="height: 24px; width: 205px;">
</form>
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
                                   �<table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="12"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951" id="Text459" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;"> 1 outputStart 
 /j
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Bayes SPAM Database Cleared</span></i></b></p>
	 	outputEnd 
 /&nbsp;</p>
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
                         �</tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;"> keys $[Llucee/runtime/type/Collection$Key;	  $lucee/runtime/functions/dateTime/Now =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &
 yyyy 4lucee/runtime/functions/displayFormatting/DateFormat S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &
  lucee.runtime.tag.Query" cfquery$ lucee/runtime/tag/Query& 
getversion(
' � setDatasource+ �
',
' � D
SELECT value from system_settings where parameter = 'version_no'
/
' � doCatch (Ljava/lang/Throwable;)V23
'4 	doFinally6 
'7
' � getbuild: B
SELECT value from system_settings where parameter = 'build_no'
< V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway > sessionScope $()Llucee/runtime/type/scope/Session;@A
 /B  lucee/runtime/type/scope/SessionDE � lucee/runtime/op/CasterG &(Ljava/lang/Object;)Ljava/lang/String; vI
HJ 	 Version:L getCollectionN � AO _VALUEQ ;	 9R I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �T
 /U  Build:W . Copyright 2011-Y l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>[C
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
 ����] udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageExceptione  lucee/runtime/type/UDFPropertiesg udfs #[Llucee/runtime/type/UDFProperties;ij	 k setPageSourcem 
 n THEYEARp lucee/runtime/type/KeyImplr intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;tu
sv EDITIONx 
GETVERSIONz GETBUILD| subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile               ~       �   *     *� 
*� *� � *�h�l*+�o�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  Q    +-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+S� 3+U� 3+W+� \� bM>+� \,� .dY:� !� fY� hYj� lW� pr� u� y� z�M>+� |~W,  � �+�� 3+�+� \� b:6+� \� 0�Y:� !� fY� hYj� l�� pr� u� y� z�:6+� |~�  � �+�� 3+ �� �� �� ��� �� � � Q+�� 3+� �� �� � �� �� � � ++�� 3+� 7� �+� �� �� � � E W+�� 3� � +�� 3+� 7� �� � �� �� � � �+�� 3+� |��� �� �:ö � Ƕ �ζ �Ӷ �� �6		� 8+	� �+�� 3� ����� :
	� +� �W
�	� +� �W� �� �  :+� |� ��+� |� �+�� 3+� 7� �� �� E W+�� 3� +�� 3+�� 3+� 3+� 3+� 7� �� � � �� � � -+�� 3+�+
� 3� :+��+�+�� 3� +� 3+� 3+� 7*�2++��!� E W+�� 3+�+� |#%� ��':)�*+� 7� =� � �-�.6� O+� �+0� 3�1��� $:�5� :� +� �W�8�� +� �W�8�9� �  :+� |� ��+� |� � :+��+�+�� 3+�+� |#%� ��':;�*+� 7� =� � �-�.6� O+� �+=� 3�1��� $:�5� :� +� �W�8�� +� �W�8�9� �  :+� |� ��+� |� � :+��+�+�� 3+�+?� 3++�C*�2�F �K� 3+M� 3+++� 7*�2�P �S�V�K� 3+X� 3+++� 7*�2�P �S�V�K� 3+Z� 3++� 7*�2� � �K� 3+\� 3� :+��+�+^� 3� ���  �  ���  $47 )$@C  �yy  ���  ��� )�
  �@@  �ZZ  q��   �         * +  �   � .           @  A ! k $ � - � 0 � 9 � < � ? � E � � � � �# �F �e �q �� �� �� �� �� �2 �H �Q �T �W �Z
aeh!�"�#�$�%�?�@(B�C�EjFuGH�     ) _` �        �    �     ) ab �         �    �     ) cd �        �    �    f    �   9     -*� �Yq�wSYy�wSY{�wSY}�wS��     �    