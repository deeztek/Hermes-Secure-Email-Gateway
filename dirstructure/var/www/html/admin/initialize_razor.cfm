����   23 initialize_razor_cfm$cf  lucee/runtime/PageImpl  /admin/initialize_razor.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength      J getCompileTime  n��4 getHash ()I�e� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Linitialize_razor_cfm$cf;

    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Initialize Razor</title>
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
              <td height="429" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion32" style="background-image: url('./middle_988.png'); height: 429px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="521">
                              <tr valign="top" align="left">
                                <td width="15" height="11"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                 P<td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Initialize Vipul&#8217;s Razor</span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="449">
                              <tr valign="top" align="left">
                                <td width="424" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/initialize-vipul-s-razor/')"> R�<img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="15" height="2"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="164"></td>
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
 � � A � 	initrazor � getCatch #()Llucee/runtime/exp/PageException; � �
 / � 

 � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 | � lucee/runtime/tag/Query � customtrans � setName � 1
 � � setDatasource (Ljava/lang/Object;)V � �
 � � getrandom_results � 	setResult � 1
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 | � 	outputEnd � 
 / � inserttrans � stResult  &
insert into salt
(salt)
values
(' getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;
 / getId $
 /	 lucee/runtime/type/Query getCurrentrow (I)I getRecordcount $ !lucee/runtime/util/NumberIterator load '(II)Llucee/runtime/util/NumberIterator;
 addQuery (Llucee/runtime/type/Query;)V A isValid (I)Z
  current" $
# go (II)Z%&' keys $[Llucee/runtime/type/Collection$Key;)*	 + lucee/runtime/op/Caster- &(Ljava/lang/Object;)Ljava/lang/String; v/
.0 #lucee/runtime/functions/string/Trim2 A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &4
35 writePSQ7 �
 /8 removeQuery:  A; release &(Llucee/runtime/util/NumberIterator;)V=>
? ')
A gettransC 2
select salt as customtrans2 from salt where id='E getCollectionG � AH I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �J
 /K '
M lucee.runtime.tag.ExecuteO 	cfexecuteQ lucee/runtime/tag/ExecuteS '/opt/hermes/scripts/initialize_razor.shU
T �@n       
setTimeout (D)VZ[
T\ -inputformat none^ setArguments` �
Ta /opt/hermes/tmp/razorresults_c java/lang/Stringe concat &(Ljava/lang/String;)Ljava/lang/String;gh
fi setOutputfilek 1
Tl razorn setVariablep 1
Tq
T �
T �
T � isAbort (Ljava/lang/Throwable;)Zvw
 �x toPageException 8(Ljava/lang/Throwable;)Llucee/runtime/exp/PageException;z{
.| setCatch &(Llucee/runtime/exp/PageException;ZZ)V~
 /� lucee.runtime.tag.FileTag� cffile� lucee/runtime/tag/FileTag� hasBody (Z)V��
�� 0 	setAction� 1
�� setFile� 1
�� _CFCATCH� ;	 9� _DETAIL� ;	 9� 	setOutput� �
�� setAddnewline��
��
� �
� � $(Llucee/runtime/exp/PageException;)V~�
 /� read� razorlog�
�q delete� Register successful� ct '(Ljava/lang/Object;Ljava/lang/Object;)Z��
 �� _M� ;	 9� #lucee/commons/color/ConstantsDouble� _1 Ljava/lang/Double;��	�� Bootstrap discovery failed� _2��	�� 


�"

                            <table border="0" cellspacing="0" cellpadding="0" width="951" id="LayoutRegion15" style="height: 164px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" id="Text454" class="TextObject">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Vipul&#8217;s Razor requires that all spam reporters be registered so that their reputations can be computer over time and eventually participate in the revocation of spam. Clicking the button below will create a new Razor configuration and register your server using an automaticaly assigned username/password. Please be patient initialization can take up to 1 minute.</span></p>
                                      </td>
                                    �f</tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="41"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951">
                                        <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 22px;">
                                          <tr style="height: 22px;">
                                            <td width="951" id="Cell1017">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="184" border="0" cellspacing="0" cellpadding="0">
                                                      �<tr>
                                                        <td class="TextObject">
                                                          <p style="text-align: center; margin-bottom: 0px;"><form name="initrazor" action="" method="post">
<input type="hidden" name="action" value="initrazor">
<input type="submit" onclick="this.disabled=true;this.value='Initializing...';this.form.submit();" name="changepass" value="Initialize Razor" style="height: 24px; width: 205px;">
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
                                      �m</td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="14"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951" id="Text459" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;">� 1�h
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Vipul's Razor Initialized</span></i></b></p>
� 2��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;Vipul's Razor was not able to initialize correctly. Please ensure the system has connectivity to the Internet and try again</span></i></b></p>
�&nbsp;</p>
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
                        � �</tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;">� $lucee/runtime/functions/dateTime/Now� =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &�
�� yyyy� 4lucee/runtime/functions/displayFormatting/DateFormat� S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &�
�� 
getversion� D
SELECT value from system_settings where parameter = 'version_no'
� getbuild� B
SELECT value from system_settings where parameter = 'build_no'
� V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway � sessionScope $()Llucee/runtime/type/scope/Session;��
 /�  lucee/runtime/type/scope/Session�� � 	 Version:� _VALUE� ;	 9�  Build:� . Copyright 2011-� l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>�C
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
 ����� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException  lucee/runtime/type/UDFProperties udfs #[Llucee/runtime/type/UDFProperties;	
	  setPageSource 
  RANDOM lucee/runtime/type/KeyImpl intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;
 STRESULT GENERATED_KEY CUSTOMTRANS3 GETTRANS CUSTOMTRANS2  RAZORLOG" THEYEAR$ EDITION& 
GETVERSION( GETBUILD* subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile            )*   ,-       .   *     *� 
*� *� � *��*+��        .         �        .        � �        .         �        .         �         .         !�      # $ .        %�      & ' .  �  ]  �+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+S� 3+U� 3+W+� \� bM>+� \,� .dY:� !� fY� hYj� lW� pr� u� y� z�M>+� |~W,  � �+�� 3+�+� \� b:6+� \� 0�Y:� !� fY� hYj� l�� pr� u� y� z�:6+� |~�  � �+�� 3+ �� �� �� ��� �� � � Q+�� 3+� �� �� � �� �� � � ++�� 3+� 7� �+� �� �� � � E W+�� 3� � +�� 3+� 7� �� � �� �� � �
N+�� 3+� �:+�� 3+� �+� |��� �� �:		ʶ �	+� 7� =� � � �	Ӷ �	� �6

� N+	
� �+߶ 3	� ����� $:	� � :
� +� �W	� ��
� +� �W	� �	� �� � ��� :+� |	� ��+� |	� �� :+� ��+� �+�� 3+� �+� |��� �� �:�� �+� 7� =� � � �� �� �6�@+� �+� 3+� �+ʶ:+�
6� 6� � � � �6� �:+� 7� d6`�!� C�$�( � � � � '�$6+++� 7*�,2� � �1�6�9���� ":�( W+� 7�< �@��( W+� 7�< �@� :+� ��+� �+B� 3� ���� $:� � :� +� �W� ��� +� �W� �� �� � ��� :+� |� ��+� |� �� :+� ��+� �+�� 3+� �+� |��� �� �:D� �+� 7� =� � � �� �6  � v+ � �+F� 3+++� 7*�,2�I *�,2�L�1�9+N� 3� ���̧ $:!!� � :" � +� �W� �"� � +� �W� �� �� � ��� :#+� |� �#�+� |� �� :$+� �$�+� �+�� 3+� 7*�,2++� 7*�,2�I *�,2�L� E W+�� 3+� �+� |��� �� �:%%ʶ �%+� 7� =� � � �%Ӷ �%� �6&&� N+%&� �+߶ 3%� ����� $:'%'� � :(&� +� �W%� �(�&� +� �W%� �%� �� � ��� :)+� |%� �)�+� |%� �� :*+� �*�+� �+�� 3+� �+� |��� �� �:++�� �++� 7� =� � � �+� �+� �6,,�@++,� �+� 3+� �+ʶ:.+�
6/./� 60.� � � � �611.� �:-+� 7.� 1d64-4`�!� C.-�$/�( � � � � '-�$64+++� 7*�,2� � �1�6�9���� ":5.0/�( W+� 7�< -�@5�.0/�( W+� 7�< -�@� :6+� �6�+� �+B� 3+� ���� $:7+7� � :8,� +� �W+� �8�,� +� �W+� �+� �� � ��� :9+� |+� �9�+� |+� �� ::+� �:�+� �+�� 3+� �+� |��� �� �:;;D� �;+� 7� =� � � �;� �6<<� v+;<� �+F� 3+++� 7*�,2�I *�,2�L�1�9+N� 3;� ���̧ $:=;=� � :><� +� �W;� �>�<� +� �W;� �;� �� � ��� :?+� |;� �?�+� |;� �� :@+� �@�+� �+�� 3+� 7*�,2++� 7*�,2�I *�,2�L� E W+�� 3+� |PR� ��T:AAV�WAX�]A_�bAd+� 7*�,2� � �1�j�mAo�rA�s6BB� 8+AB� �+�� 3A�t���� :CB� +� �WC�B� +� �WA�u� � ��� :D+� |A� �D�+� |A� �+�� 3� �:EE�y� E�E�}:F+F��+�� 3+� |��� ���:GG��G���Gd+� 7*�,2� � �1�j��G++� 7���I ���L��G��G��WG��� � ��� :H+� |G� �H�+� |G� �+�� 3� :I+��I�+��+�� 3+� |��� ���:JJ��J���Jd+� 7*�,2� � �1�j��J���J��WJ��� � ��� :K+� |J� �K�+� |J� �+�� 3+� |��� ���:LL��L���Ld+� 7*�,2� � �1�j��L��WL��� � ��� :M+� |L� �M�+� |L� �+�� 3+� 7*�,2� � ���� "+�� 3+� 7����� E W+�� 3� ;+� 7*�,2� � ���� "+�� 3+� 7����� E W+�� 3� +�� 3� +¶ 3+Ķ 3+ƶ 3+ȶ 3+� 7��� � ʸ �� � � -+�� 3+� �+̶ 3� :N+� �N�+� �+�� 3� +�� 3+� 7��� � θ �� � � -+�� 3+� �+ж 3� :O+� �O�+� �+�� 3� +Ҷ 3+Զ 3+� 7*�,2++��۸� E W+�� 3+� �+� |��� �� �:PP� �P+� 7� =� � � �P� �6QQ� O+PQ� �+� 3P� ���� $:RPR� � :SQ� +� �WP� �S�Q� +� �WP� �P� �� � ��� :T+� |P� �T�+� |P� �� :U+� �U�+� �+�� 3+� �+� |��� �� �:VV� �V+� 7� =� � � �V� �6WW� O+VW� �+� 3V� ���� $:XVX� � :YW� +� �WV� �Y�W� +� �WV� �V� �� � ��� :Z+� |V� �Z�+� |V� �� :[+� �[�+� �+�� 3+� �+� 3++��*�,2�� �1� 3+� 3+++� 7*�,	2�I ���L�1� 3+�� 3+++� 7*�,
2�I ���L�1� 3+�� 3++� 7*�,2� � �1� 3+�� 3� :\+� �\�+� �+�� 3� .��� )�
  �@@  �ZZ  __  ���  ��� )���  ���  q  m�� )m��  ?��  .  ��� )���  Z��  I��  �  d==  YZ] )Yfi  $��  ��  FI )RU  ���  ���  	L	^	^  �	�	�  �	�	� )	�
?
?  �
\
_  
�
�
�  EE   **  nxx   )   �VV  �pp  ��� )���  �  �55  L��   /         * +  0  : N           @  A ! k $ � - � 0 � 9 � < � ? � E � � � � �# �F �e �q �� �� �� �j �� �� �' �q �� � �B �� � ]N�:	��				1	O	�	�
Y
p
s
�_~����!�#�:�;�ST$U7V:WCYgZr[�\�]�w�xz�{�}E~P��1     ) �  .        �    1     )  .         �    1     )  .        �    1        .   ~     r*� �Y�SY�SY�SY�SY�SY!�SY#�SY%�SY'�SY	)�SY
+�S�,�     2    