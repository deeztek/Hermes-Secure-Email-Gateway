����   2 antivirus_settings_cfm$cf  lucee/runtime/PageImpl  /admin/antivirus_settings.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength     �N getCompileTime  n�ѯ getHash ()I��� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Lantivirus_settings_cfm$cf;
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Antivirus Settings</title>
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
              <td height="1232" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion1" style="background-image: url('./middle_988.png'); height: 1232px;">
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
                                 P<td width="506" id="Text291" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Antivirus Settings</span></b></p>
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
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/antivirus-settings/')"> R�<img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
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
                          <td height="967"></td>
                          <td width="959"> T m V &lucee/runtime/config/NullSupportHelper X NULL Z '
 Y [ -lucee/runtime/interpreter/VariableInterpreter ] getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; _ `
 ^ a 0 c %lucee/runtime/exp/ExpressionException e java/lang/StringBuilder g The required parameter [ i  1
 h k append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; m n
 h o ] was not provided. q -(Ljava/lang/String;)Ljava/lang/StringBuilder; m s
 h t toString ()Ljava/lang/String; v w
 h x
 f k lucee/runtime/PageContextImpl { any }�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 | �  
 � m2 � step � 

 � action � view �@       _action � ;	 9 � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � 
 � keys $[Llucee/runtime/type/Collection$Key; � �	  � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � ;	 9 � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 | � lucee/runtime/tag/Query � getScanMail � setName � 1
 � � A � setDatasource (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � m
select parameter, value2 from parameters2 where parameter='ScanMail' and active = '1' and module='clamav'
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 | � 	outputEnd � 
 / � getScanArchive � p
select parameter, value2 from parameters2 where parameter='ScanArchive' and active = '1' and module='clamav'
 � 


 � getArchiveBlockEncrypted � z
select parameter, value2 from parameters2 where parameter='ArchiveBlockEncrypted' and active = '1' and module='clamav'
 � 	getScanPE  k
select parameter, value2 from parameters2 where parameter='ScanPE' and active = '1' and module='clamav'
 getScanOLE2 m
select parameter, value2 from parameters2 where parameter='ScanOLE2' and active = '1' and module='clamav'
 getOLE2BlockMacros t
select parameter, value2 from parameters2 where parameter='OLE2BlockMacros' and active = '1' and module='clamav'

 
getScanPDF l
select parameter, value2 from parameters2 where parameter='ScanPDF' and active = '1' and module='clamav'
 getScanHTML m
select parameter, value2 from parameters2 where parameter='ScanHTML' and active = '1' and module='clamav'
 getAlgorithmicDetection y
select parameter, value2 from parameters2 where parameter='AlgorithmicDetection' and active = '1' and module='clamav'
 
getScanELF l
select parameter, value2 from parameters2 where parameter='ScanELF' and active = '1' and module='clamav'
 getPhishingSignatures w
select parameter, value2 from parameters2 where parameter='PhishingSignatures' and active = '1' and module='clamav'
 getPhishingScanURLs  u
select parameter, value2 from parameters2 where parameter='PhishingScanURLs' and active = '1' and module='clamav'
" !getPhishingAlwaysBlockSSLMismatch$ �
select parameter, value2 from parameters2 where parameter='PhishingAlwaysBlockSSLMismatch' and active = '1' and module='clamav'
& getPhishingAlwaysBlockCloak( }
select parameter, value2 from parameters2 where parameter='PhishingAlwaysBlockCloak' and active = '1' and module='clamav'
* getDetectPUA, n
select parameter, value2 from parameters2 where parameter='DetectPUA' and active = '1' and module='clamav'
. getHeuristicScanPrecedence0 |
select parameter, value2 from parameters2 where parameter='HeuristicScanPrecedence' and active = '1' and module='clamav'
2 ScanMail4 getCollection6 � A7 I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �9
 /: ScanArchive< ArchiveBlockEncrypted> ScanPE@ ScanOLE2B OLE2BlockMacrosD ScanPDFF 



H ScanHTMLJ AlgorithmicDetectionL ScanELFN PhishingSignaturesP PhishingScanURLsR PhishingAlwaysBlockSSLMismatchT PhishingAlwaysBlockCloakV 	DetectPUAX HeuristicScanPrecedenceZ edit\ '(Ljava/lang/Object;Ljava/lang/String;)I �^
 �_ updateScanMaila !
update parameters2 set value2='c lucee/runtime/op/Castere &(Ljava/lang/Object;)Ljava/lang/String; vg
fh writePSQj �
 /k ?', applied='2' where parameter='ScanMail' and module='clamav'
m updateScanArchiveo B', applied='2' where parameter='ScanArchive' and module='clamav'
q updateArchiveBlockEncrypteds L', applied='2' where parameter='ArchiveBlockEncrypted' and module='clamav'
u updateScanPEw =', applied='2' where parameter='ScanPE' and module='clamav'
y updateScanOLE2{ ?', applied='2' where parameter='ScanOLE2' and module='clamav'
} updateOLE2BlockMacros F', applied='2' where parameter='OLE2BlockMacros' and module='clamav'
� updateScanPDF� >', applied='2' where parameter='ScanPDF' and module='clamav'
� updateScanHTML� ?', applied='2' where parameter='ScanHTML' and module='clamav'
� updateAlgorithmicDetection� K', applied='2' where parameter='AlgorithmicDetection' and module='clamav'
� updateScanELF� >', applied='2' where parameter='ScanELF' and module='clamav'
� updatePhishingSignatures� I', applied='2' where parameter='PhishingSignatures' and module='clamav'
� updatePhishingScanURLs� G', applied='2' where parameter='PhishingScanURLs' and module='clamav'
� $updatePhishingAlwaysBlockSSLMismatch� U', applied='2' where parameter='PhishingAlwaysBlockSSLMismatch' and module='clamav'
� updatePhishingAlwaysBlockCloak� O', applied='2' where parameter='PhishingAlwaysBlockCloak' and module='clamav'
� updateDetectPUA� @', applied='2' where parameter='DetectPUA' and module='clamav'
� updateHeuristicScanPrecedence� N', applied='2' where parameter='HeuristicScanPrecedence' and module='clamav'
� _M� ;	 9� #lucee/commons/color/ConstantsDouble� _27 Ljava/lang/Double;��	��D
                            <table border="0" cellspacing="0" cellpadding="0" width="959" id="LayoutRegion11" style="height: 967px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="antivirus_settings.cfm" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="19"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="959">
                                          <table id="Table160" border="0" cellspacing="0" cellpadding="0" width="959" style="height: 640px;">
                                            <tr style="height: 14px;">
                                              �6<td width="959" id="Cell889">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan Email Files <span style="font-weight: normal;">(</span><span style="color: rgb(255,0,0);">WARNING:</span> <span style="font-weight: normal;">Setting to Disabled will effectively disable the antivirus engine)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 38px;">
                                              <td id="Cell890">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      ��<td>
                                                        <table id="Table180" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1120">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">� true� k
<input type="radio" name="ScanMail" value="true" checked="checked" style="height: 19px; width: 19px;"/>
� Y
<input type="radio" name="ScanMail" value="true" style="height: 19px; width: 19px;"/>
�P


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
                                                                � �<tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">� false� l
<input type="radio" name="ScanMail" value="false" checked="checked" style="height: 19px; width: 19px;"/>
� Z
<input type="radio" name="ScanMail" value="false" style="height: 19px; width: 19px;"/>
� 

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
                                              �~</tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1091">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan Archives <span style="font-weight: normal;">(Enable scanning of archive files such as ZIP, RAR etc)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1092">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table181" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          �<tr style="height: 19px;">
                                                            <td width="58" id="Cell1124">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">� n
<input type="radio" name="ScanArchive" value="true" checked="checked" style="height: 19px; width: 19px;"/>
� \
<input type="radio" name="ScanArchive" value="true" style="height: 19px; width: 19px;"/>
�P


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
                                                                � o
<input type="radio" name="ScanArchive" value="false" checked="checked" style="height: 19px; width: 19px;"/>
� ]
<input type="radio" name="ScanArchive" value="false" style="height: 19px; width: 19px;"/>
�/

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
                                              �E<tr style="height: 14px;">
                                                <td id="Cell1143">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Mark Encrypted Archives as Viruses <span style="font-weight: normal;">(Encrypted Zip, Encrypted RAR)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1144">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table182" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          �<tr style="height: 19px;">
                                                            <td width="58" id="Cell1128">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">� x
<input type="radio" name="ArchiveBlockEncrypted" value="true" checked="checked" style="height: 19px; width: 19px;"/>
� f
<input type="radio" name="ArchiveBlockEncrypted" value="true" style="height: 19px; width: 19px;"/>
�

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1129">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1130">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                � y
<input type="radio" name="ArchiveBlockEncrypted" value="false" checked="checked" style="height: 19px; width: 19px;"/>
� g
<input type="radio" name="ArchiveBlockEncrypted" value="false" style="height: 19px; width: 19px;"/>
�0


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1131">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              �</tr>
                                              <tr style="height: 28px;">
                                                <td id="Cell1105">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan Portable Executables. <span style="font-weight: normal;">(This allows AV engine to perform a deeper analysis of executable files. This option is also required for decompression of popular executable packers such as UPX)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1099">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      ��<td>
                                                        <table id="Table183" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1145">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">� i
<input type="radio" name="ScanPE" value="true" checked="checked" style="height: 19px; width: 19px;"/>
� W
<input type="radio" name="ScanPE" value="true" style="height: 19px; width: 19px;"/>
�N

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1146">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1147">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                � j
<input type="radio" name="ScanPE" value="false" checked="checked" style="height: 19px; width: 19px;"/>
� X
<input type="radio" name="ScanPE" value="false" style="height: 19px; width: 19px;"/>
�1


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1148">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              �<tr style="height: 14px;">
                                                <td id="Cell1100">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Scan OLE2 files <span style="font-weight: normal;">(Microsoft Office Documents, MSI files)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1109">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table170" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          �<tr style="height: 19px;">
                                                            <td width="58" id="Cell1060">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">� k
<input type="radio" name="ScanOLE2" value="true" checked="checked" style="height: 19px; width: 19px;"/>
  Y
<input type="radio" name="ScanOLE2" value="true" style="height: 19px; width: 19px;"/>
P


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1061">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1062">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                 l
<input type="radio" name="ScanOLE2" value="false" checked="checked" style="height: 19px; width: 19px;"/>
 Z
<input type="radio" name="ScanOLE2" value="false" style="height: 19px; width: 19px;"/>
1


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1063">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              
r<tr style="height: 28px;">
                                                <td id="Cell1110">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Block OLE2 Macros <span style="font-weight: normal;">(</span><span style="color: rgb(255,0,0);">WARNING:</span><span style="font-weight: normal;"> This will bypass ALL AV signatures and block ALL OLE2 files with VBA Macros in them whether malicious or not. In effect, it will treat any macros as a virus. This setting has no effect if </span>Enable Scanning of OLE2 files<span style="font-weight: normal;"> is set to Disabled)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1111">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table174" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            <td width="58" id="Cell1078">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"> r
<input type="radio" name="OLE2BlockMacros" value="true" checked="checked" style="height: 19px; width: 19px;"/>
 `
<input type="radio" name="OLE2BlockMacros" value="true" style="height: 19px; width: 19px;"/>



&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1079">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1080">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                 s
<input type="radio" name="OLE2BlockMacros" value="false" checked="checked" style="height: 19px; width: 19px;"/>
 a
<input type="radio" name="OLE2BlockMacros" value="false" style="height: 19px; width: 19px;"/>
0


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1081">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              E</tr>
                                              <tr style="height: 14px;">
                                                <td id="Cell1180">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Scan PDF files</span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1181">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table188" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            �<td width="58" id="Cell1175">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;"> j
<input type="radio" name="ScanPDF" value="true" checked="checked" style="height: 19px; width: 19px;"/>
  X
<input type="radio" name="ScanPDF" value="true" style="height: 19px; width: 19px;"/>
"P


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1176">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1177">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                $ k
<input type="radio" name="ScanPDF" value="false" checked="checked" style="height: 19px; width: 19px;"/>
& Y
<input type="radio" name="ScanPDF" value="false" style="height: 19px; width: 19px;"/>
(1


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1178">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              *I<tr style="height: 14px;">
                                                <td id="Cell891">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan and normalize HTML </span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell1047">
                                                  <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table175" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                          <tr style="height: 19px;">
                                                            ,�<td width="58" id="Cell1082">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">. k
<input type="radio" name="ScanHTML" value="true" checked="checked" style="height: 19px; width: 19px;"/>
0 Y
<input type="radio" name="ScanHTML" value="true" style="height: 19px; width: 19px;"/>
2P


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="429" id="Cell1083">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 19px;">
                                                            <td id="Cell1084">
                                                              <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                4 l
<input type="radio" name="ScanHTML" value="false" checked="checked" style="height: 19px; width: 19px;"/>
6 Z
<input type="radio" name="ScanHTML" value="false" style="height: 19px; width: 19px;"/>
81


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1085">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              :9<tr style="height: 14px;">
                                                <td id="Cell1046">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Algorithmic Detection <span style="font-weight: normal;">(Useful in detecting complex malware, exploits in graphic files and others)</span></span></b></p>
                                                </td>
                                              </tr>
                                              <tr style="height: 38px;">
                                                <td id="Cell892">
                                                  <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                    <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                      <tr>
                                                        <�<td>
                                                          <table id="Table176" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                            <tr style="height: 19px;">
                                                              <td width="58" id="Cell1086">
                                                                <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                  <tr>
                                                                    <td class="TextObject">
                                                                      <p style="margin-bottom: 0px;">> w
<input type="radio" name="AlgorithmicDetection" value="true" checked="checked" style="height: 19px; width: 19px;"/>
@ e
<input type="radio" name="AlgorithmicDetection" value="true" style="height: 19px; width: 19px;"/>
Bh


&nbsp;</p>
                                                                    </td>
                                                                  </tr>
                                                                </table>
                                                                &nbsp;</td>
                                                              <td width="429" id="Cell1087">
                                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                              </td>
                                                            </tr>
                                                            <tr style="height: 19px;">
                                                              <td id="Cell1088">
                                                                <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                  D �<tr>
                                                                    <td class="TextObject">
                                                                      <p style="margin-bottom: 0px;">F x
<input type="radio" name="AlgorithmicDetection" value="false" checked="checked" style="height: 19px; width: 19px;"/>
H f
<input type="radio" name="AlgorithmicDetection" value="false" style="height: 19px; width: 19px;"/>
J


&nbsp;</p>
                                                                    </td>
                                                                  </tr>
                                                                </table>
                                                                &nbsp;</td>
                                                              <td id="Cell1089">
                                                                <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                              </td>
                                                            </tr>
                                                          </table>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                    </b></td>
                                                L&</tr>
                                                <tr style="height: 14px;">
                                                  <td id="Cell911">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan Executable and Linking Format Files (ELF)</span></b></p>
                                                  </td>
                                                </tr>
                                                <tr style="height: 38px;">
                                                  <td id="Cell912">
                                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"></span>
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          N�<td>
                                                            <table id="Table178" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1112">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">P j
<input type="radio" name="ScanELF" value="true" checked="checked" style="height: 19px; width: 19px;"/>
R X
<input type="radio" name="ScanELF" value="true" style="height: 19px; width: 19px;"/>
T�


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
                                                                    V �<tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">X k
<input type="radio" name="ScanELF" value="false" checked="checked" style="height: 19px; width: 19px;"/>
Z Y
<input type="radio" name="ScanELF" value="false" style="height: 19px; width: 19px;"/>
\


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
                                                      </b>^</td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1014">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Signature Based Detection of Phishing Attempts</span></b></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1058">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            `�<table id="Table179" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1116">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">b u
<input type="radio" name="PhishingSignatures" value="true" checked="checked" style="height: 19px; width: 19px;"/>
d c
<input type="radio" name="PhishingSignatures" value="true" style="height: 19px; width: 19px;"/>
f�


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
                                                                    h v
<input type="radio" name="PhishingSignatures" value="false" checked="checked" style="height: 19px; width: 19px;"/>
j d
<input type="radio" name="PhishingSignatures" value="false" style="height: 19px; width: 19px;"/>
l4


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
                                                  ne</tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1059">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Scan Email URLs for Phishing Attempts </span></b></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1072">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table177" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              p<tr style="height: 19px;">
                                                                <td width="58" id="Cell1093">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">r s
<input type="radio" name="PhishingScanURLs" value="true" checked="checked" style="height: 19px; width: 19px;"/>
t a
<input type="radio" name="PhishingScanURLs" value="true" style="height: 19px; width: 19px;"/>
v�


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1094">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1095">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    x t
<input type="radio" name="PhishingScanURLs" value="false" checked="checked" style="height: 19px; width: 19px;"/>
z b
<input type="radio" name="PhishingScanURLs" value="false" style="height: 19px; width: 19px;"/>
|4


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1096">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  ~</tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1073">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Block SSL Mismatches in Email URLs </b>(<b><span style="color: rgb(255,0,0);">Warning:</span></b> This can lead to false positives)</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1149">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            ��<table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1151">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� �
<input type="radio" name="PhishingAlwaysBlockSSLMismatch" value="true" checked="checked" style="height: 19px; width: 19px;"/>
� o
<input type="radio" name="PhishingAlwaysBlockSSLMismatch" value="true" style="height: 19px; width: 19px;"/>
�M


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1152">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled </span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1153">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    � �
<input type="radio" name="PhishingAlwaysBlockSSLMismatch" value="false" checked="checked" style="height: 19px; width: 19px;"/>
� p
<input type="radio" name="PhishingAlwaysBlockSSLMismatch" value="false" style="height: 19px; width: 19px;"/>
�/


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1154">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    �</td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1150">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Block Cloaked Email URLs </b>(<b><span style="color: rgb(255,0,0);">Warning:</span></b> This can lead to false positives)</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1155">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          ��<td>
                                                            <table id="Table185" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1156">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� {
<input type="radio" name="PhishingAlwaysBlockCloak" value="true" checked="checked" style="height: 19px; width: 19px;"/>
� i
<input type="radio" name="PhishingAlwaysBlockCloak" value="true" style="height: 19px; width: 19px;"/>
�L


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1157">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1158">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    � |
<input type="radio" name="PhishingAlwaysBlockCloak" value="false" checked="checked" style="height: 19px; width: 19px;"/>
� j
<input type="radio" name="PhishingAlwaysBlockCloak" value="false" style="height: 19px; width: 19px;"/>
�/


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1159">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    ��</td>
                                                  </tr>
                                                  <tr style="height: 14px;">
                                                    <td id="Cell1161">
                                                      <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Detect Possibly Unwanted Applications</span></b></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 38px;">
                                                    <td id="Cell1162">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table186" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              �<tr style="height: 19px;">
                                                                <td width="58" id="Cell1163">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        <p style="margin-bottom: 0px;">� l
<input type="radio" name="DetectPUA" value="true" checked="checked" style="height: 19px; width: 19px;"/>
� Z
<input type="radio" name="DetectPUA" value="true" style="height: 19px; width: 19px;"/>
�L


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1164">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1165">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    � m
<input type="radio" name="DetectPUA" value="false" checked="checked" style="height: 19px; width: 19px;"/>
� [
<input type="radio" name="DetectPUA" value="false" style="height: 19px; width: 19px;"/>
�/


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1166">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    �</td>
                                                  </tr>
                                                  <tr style="height: 42px;">
                                                    <td id="Cell1168">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b>Heuristic Scan Precedence </b>(When enabled, if a heuristic malware match, the scanning will stop immediately thus saving CPU. When disabled, heuristic matches will be reported at the end of the scan. For example, if disabled and an archive contains both a heuristically detected malware and a signature based malware, the signature based malware will be reported. If signature based malware is found, the scan stops immediately regardless of whether this option is enabled or not)</span></p>
                                                    </td>
                                                  </tr>
                                                  �><tr style="height: 38px;">
                                                    <td id="Cell1167">
                                                      <table width="487" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td>
                                                            <table id="Table187" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                              <tr style="height: 19px;">
                                                                <td width="58" id="Cell1169">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    <tr>
                                                                      <td class="TextObject">
                                                                        � <p style="margin-bottom: 0px;">� z
<input type="radio" name="HeuristicScanPrecedence" value="true" checked="checked" style="height: 19px; width: 19px;"/>
� h
<input type="radio" name="HeuristicScanPrecedence" value="true" style="height: 19px; width: 19px;"/>
�L


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td width="429" id="Cell1170">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Enabled</span></b></p>
                                                                </td>
                                                              </tr>
                                                              <tr style="height: 19px;">
                                                                <td id="Cell1171">
                                                                  <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                    � {
<input type="radio" name="HeuristicScanPrecedence" value="false" checked="checked" style="height: 19px; width: 19px;"/>
� i
<input type="radio" name="HeuristicScanPrecedence" value="false" style="height: 19px; width: 19px;"/>
�/


&nbsp;</p>
                                                                      </td>
                                                                    </tr>
                                                                  </table>
                                                                  &nbsp;</td>
                                                                <td id="Cell1172">
                                                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Disabled <span style="font-weight: normal;">(Default)</span></span></b></p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    �E</td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1179">
                                                      <p style="margin-bottom: 0px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 17px;">
                                                    <td id="Cell1015">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                �(<td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Saving, please wait...';this.form.submit();" name="FormsButton1" value="Save Settings" style="height: 24px; width: 142px;">
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
                                          �R</table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="959">
                                            <tr valign="top" align="left">
                                              <td width="959" height="9"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="959" id="Text495" class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;">
� 1�d
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the User Portal Address cannot be empty</span></i></b></p>
� 2�u
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Spam Message Modified Subject String cannot be empty</span></i></b></p>
� 3�{
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto SPAM Score String cannot be empty</span></i></b></p>
� 4��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto SPAM Score String must be greater than -999</span></i></b></p>
� 5�|
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto SPAM Score String must be less 999</span></i></b></p>
� 6�~
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto SPAM Score String must be an integer</span></i></b></p>
� 7�y
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto NON-SPAM String cannot be empty</span></i></b></p>
� 8��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto NON-SPAM String must be greater than -999</span></i></b></p>
� 9�z
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto NON-SPAM String must be less 999</span></i></b></p>
� 10�|
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Bayes Spam Database Auto NON-SPAM String must be an integer</span></i></b></p>
� 11�~
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 0-1% Probability String cannot be empty</span></i></b></p>
� 12��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 0-1% Probability String must be greater than -999</span></i></b></p>
� 13�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 0-1% Probability String must be less 999</span></i></b></p>
� 14��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 0-1% Probability String must be an integer</span></i></b></p>
� 15 }
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 80% Probability String cannot be empty</span></i></b></p>
 16�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 80% Probability String must be greater than -999</span></i></b></p>
 17~
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 80% Probability String must be less 999</span></i></b></p>

 18�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 80% Probability String must be an integer</span></i></b></p>
 19}
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 95% Probability String cannot be empty</span></i></b></p>
 20�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 95% Probability String must be greater than -999</span></i></b></p>
 21~
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 95% Probability String must be less 999</span></i></b></p>
 22�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 95% Probability String must be an integer</span></i></b></p>
 23 }
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 99% Probability String cannot be empty</span></i></b></p>
" 24$�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 99% Probability String must be greater than -999</span></i></b></p>
& 25(~
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 99% Probability String must be less 999</span></i></b></p>
* 26,�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the pam Score Assigned at 99% Probability String must be an integer</span></i></b></p>
. 270�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Settings Saved!! You MUST click the Apply Settings button in order for your changes to take effect</span></i></b></p>
2&nbsp;</p>
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
                                <td width="9" height="3"></td>
                                <td></td>
                                <td width="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="30"></td>
                                <td colspan="2" valign="middle" width="957"><hr id="HRRule5" width="957" size="1">4v</td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="3" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="46"></td>
                                <td width="955">6 show_action28  :  

< apply> _16@�	�A customtransC getrandom_resultsE 	setResultG 1
 �H Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
J inserttransL stResultN &
insert into salt
(salt)
values
('P getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;RS
 /T getIdV $
 /W lucee/runtime/type/QueryY getCurrentrow (I)I[\Z] getRecordcount_ $Z` !lucee/runtime/util/NumberIteratorb load '(II)Llucee/runtime/util/NumberIterator;de
cf addQuery (Llucee/runtime/type/Query;)Vhi Aj isValid (I)Zlm
cn currentp $
cq go (II)ZstZu #lucee/runtime/functions/string/Trimw A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &y
xz removeQuery|  A} release &(Llucee/runtime/util/NumberIterator;)V�
c� ')
� gettrans� 2
select salt as customtrans2 from salt where id='� '
� deletetrans� 
delete from salt where id='� lucee.runtime.tag.FileTag� cffile� lucee/runtime/tag/FileTag� hasBody (Z)V��
�� read� 	setAction� 1
�� (/opt/hermes/conf_files/clamd.conf.HERMES� setFile� 1
�� clam� setVariable� 1
��
� �
� � 0 /opt/hermes/tmp/� java/lang/String� concat &(Ljava/lang/String;)Ljava/lang/String;��
�� _clamd.conf.HERMES� 	Scan-Mail� 	ScanMail � ALL� (lucee/runtime/functions/string/REReplace� w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &�
�� 	setOutput� �
�� Scan-Archive� ScanArchive � Archive-BlockEncrypted� ArchiveBlockEncrypted � Scan-PE� ScanPE � 	Scan-OLE2� 	ScanOLE2 � 
    
� OLE2-BlockMacros� OLE2BlockMacros � Scan-PDF� ScanPDF � 	Scan-HTML� 	ScanHTML � Algorithmic-Detection� AlgorithmicDetection � Scan-ELF� ScanELF � Phishing-Signatures� PhishingSignatures � Phishing-ScanURLs� PhishingScanURLs � Phishing-AlwaysBlockSSLMismatch� PhishingAlwaysBlockSSLMismatch � 
 
 
� Phishing-AlwaysBlockCloak� PhishingAlwaysBlockCloak � 
Detect-PUA� 
DetectPUA � HeuristicScan-Precedence� HeuristicScanPrecedence  	_apply.sh C/bin/cp /etc/clamav/clamd.conf /etc/clamav/clamd.conf.HERMES.BACKUP@$       "lucee/runtime/functions/string/Chr	 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &

 setAddnewline�
� APPEND /bin/mv /opt/hermes/tmp/ )_clamd.conf.HERMES /etc/clamav/clamd.conf (/usr/bin/dos2unix /etc/clamav/clamd.conf !/etc/init.d/clamav-daemon restart /etc/init.d/amavis restart /etc/init.d/postfix restart lucee.runtime.tag.Execute 	cfexecute! lucee/runtime/tag/Execute# 
/bin/chmod%
$ � +x /opt/hermes/tmp/( setArguments* �
$+@N       
setTimeout (D)V/0
$1
$ �
$ �
$ � 	/dev/null6 setOutputfile8 1
$9 -inputformat none;@n       delete?  

    
A updateparamsC P
update parameters2 set applied='1' where applied = '2' and module = 'clamav'
E 	 
    
GK


                                  <table border="0" cellspacing="0" cellpadding="0" width="955" id="LayoutRegion13" style="height: 46px;">
                                    <tr align="left" valign="top">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="955">
                                              <form name="apply_settings" action="antivirus_settings.cfm#apply" method="post">
                                                <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="955" id="Cell753">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        I�<tr>
                                                          <td align="center">
                                                            <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;">K 
getappliedM E
select * from parameters2 where module = 'clamav' and applied='2'
O #lucee/runtime/util/VariableUtilImplQ recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;ST
RU (Ljava/lang/Object;D)I �W
 �X �
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
Z
<input type="hidden" name="action2" value="apply">
<input type="submit" onclick="this.disabled=true;this.value='Applying settings, please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" disabled="disabled" style="height: 24px; width: 142px;">
\&nbsp;</p>
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
                                            <td width="955" height="5">^?</td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td width="955" id="Text351" class="TextObject">
                                              <p style="text-align: left; margin-bottom: 0px;">`_
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes Applied.</span></i></b></p>
b@



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
                              dm<tr valign="top" align="left">
                                <td width="981" height="12"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td width="981" id="Text496" class="TextObject">
                                  <p style="text-align: center; margin-bottom: 0px;">f $lucee/runtime/functions/dateTime/Nowh =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &j
ik yyyym 4lucee/runtime/functions/displayFormatting/DateFormato S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &q
pr 
getversiont D
SELECT value from system_settings where parameter = 'version_no'
v getbuildx B
SELECT value from system_settings where parameter = 'build_no'
z V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway | sessionScope $()Llucee/runtime/type/scope/Session;~
 /�  lucee/runtime/type/scope/Session�� � 	 Version:� _VALUE� ;	 9�  Build:� . Copyright 2011-� l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>��
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
�� GETSCANMAIL� VALUE2� SCANMAIL� GETSCANARCHIVE� SCANARCHIVE� GETARCHIVEBLOCKENCRYPTED� ARCHIVEBLOCKENCRYPTED� 	GETSCANPE� SCANPE� GETSCANOLE2� SCANOLE2� GETOLE2BLOCKMACROS� OLE2BLOCKMACROS� 
GETSCANPDF� SCANPDF� GETSCANHTML� SCANHTML� GETALGORITHMICDETECTION� ALGORITHMICDETECTION� 
GETSCANELF� SCANELF� GETPHISHINGSIGNATURES� PHISHINGSIGNATURES� GETPHISHINGSCANURLS� PHISHINGSCANURLS� !GETPHISHINGALWAYSBLOCKSSLMISMATCH� PHISHINGALWAYSBLOCKSSLMISMATCH� GETPHISHINGALWAYSBLOCKCLOAK� PHISHINGALWAYSBLOCKCLOAK� GETDETECTPUA� 	DETECTPUA� GETHEURISTICSCANPRECEDENCE� HEURISTICSCANPRECEDENCE� action2� ACTION2� SHOW_ACTION2� M2� RANDOM� STRESULT� GENERATED_KEY� CUSTOMTRANS3� GETTRANS� CUSTOMTRANS2� CLAM 
GETAPPLIED THEYEAR EDITION 
GETVERSION	 GETBUILD subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �             *     *� 
*� *� � *����*+���                 �                � �                 �                 �                  !�      # $         %�      & '   �0 J  �~+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+S� 3+U� 3+W+� \� bM>+� \,� .dY:� !� fY� hYj� lW� pr� u� y� z�M>+� |~W,  � �+�� 3+�+� \� b:6+� \� 0dY:� !� fY� hYj� l�� pr� u� y� z�:6+� |~�  � �+�� 3+�+� \� b:6	+� \� 0dY:
� !� fY� hYj� l�� pr� u� y� z�
:6	+� |~�  	� �+�� 3+�+� \� b:6+� \� 0�Y:� !� fY� hYj� l�� pr� u� y� z�:6+� |~�  � �+�� 3+ �� �� �� ��� �� � � .+�� 3+� 7*� �2+� �� �� � � E W+�� 3� +�� 3+� �+� |��� �� �:ƶ �+� 7� =� � � �� �6� N+� �+׶ 3� ����� $:� ާ :� +� �W� ��� +� �W� �� �� �  :+� |� ��+� |� � :+� ��+� �+�� 3+� �+� |��� �� �:�� �+� 7� =� � � �� �6� N+� �+�� 3� ����� $:� ާ :� +� �W� ��� +� �W� �� �� �  :+� |� ��+� |� � :+� ��+� �+�� 3+� �+� |��� �� �:�� �+� 7� =� � � �� �6� N+� �+�� 3� ����� $:� ާ :� +� �W� ��� +� �W� �� �� �  :+� |� ��+� |� � :+� ��+� �+�� 3+� �+� |��� �� �:  � � +� 7� =� � � � � �6!!� O+ !� �+� 3 � ���� $:" "� ާ :#!� +� �W � �#�!� +� �W � � � �� �  :$+� | � �$�+� | � � :%+� �%�+� �+�� 3+� �+� |��� �� �:&&� �&+� 7� =� � � �&� �6''� O+&'� �+� 3&� ���� $:(&(� ާ :)'� +� �W&� �)�'� +� �W&� �&� �� �  :*+� |&� �*�+� |&� � :++� �+�+� �+�� 3+� �+� |��� �� �:,,	� �,+� 7� =� � � �,� �6--� O+,-� �+� 3,� ���� $:.,.� ާ :/-� +� �W,� �/�-� +� �W,� �,� �� �  :0+� |,� �0�+� |,� � :1+� �1�+� �+�� 3+� �+� |��� �� �:22� �2+� 7� =� � � �2� �633� O+23� �+� 32� ���� $:424� ާ :53� +� �W2� �5�3� +� �W2� �2� �� �  :6+� |2� �6�+� |2� � :7+� �7�+� �+�� 3+� �+� |��� �� �:88� �8+� 7� =� � � �8� �699� O+89� �+� 38� ���� $::8:� ާ :;9� +� �W8� �;�9� +� �W8� �8� �� �  :<+� |8� �<�+� |8� � :=+� �=�+� �+�� 3+� �+� |��� �� �:>>� �>+� 7� =� � � �>� �6??� O+>?� �+� 3>� ���� $:@>@� ާ :A?� +� �W>� �A�?� +� �W>� �>� �� �  :B+� |>� �B�+� |>� � :C+� �C�+� �+�� 3+� �+� |��� �� �:DD� �D+� 7� =� � � �D� �6EE� O+DE� �+� 3D� ���� $:FDF� ާ :GE� +� �WD� �G�E� +� �WD� �D� �� �  :H+� |D� �H�+� |D� � :I+� �I�+� �+�� 3+� �+� |��� �� �:JJ� �J+� 7� =� � � �J� �6KK� O+JK� �+� 3J� ���� $:LJL� ާ :MK� +� �WJ� �M�K� +� �WJ� �J� �� �  :N+� |J� �N�+� |J� � :O+� �O�+� �+�� 3+� �+� |��� �� �:PP!� �P+� 7� =� � � �P� �6QQ� O+PQ� �+#� 3P� ���� $:RPR� ާ :SQ� +� �WP� �S�Q� +� �WP� �P� �� �  :T+� |P� �T�+� |P� � :U+� �U�+� �+�� 3+� �+� |��� �� �:VV%� �V+� 7� =� � � �V� �6WW� O+VW� �+'� 3V� ���� $:XVX� ާ :YW� +� �WV� �Y�W� +� �WV� �V� �� �  :Z+� |V� �Z�+� |V� � :[+� �[�+� �+�� 3+� �+� |��� �� �:\\)� �\+� 7� =� � � �\� �6]]� O+\]� �++� 3\� ���� $:^\^� ާ :_]� +� �W\� �_�]� +� �W\� �\� �� �  :`+� |\� �`�+� |\� � :a+� �a�+� �+�� 3+� �+� |��� �� �:bb-� �b+� 7� =� � � �b� �6cc� O+bc� �+/� 3b� ���� $:dbd� ާ :ec� +� �Wb� �e�c� +� �Wb� �b� �� �  :f+� |b� �f�+� |b� � :g+� �g�+� �+�� 3+� �+� |��� �� �:hh1� �h+� 7� =� � � �h� �6ii� O+hi� �+3� 3h� ���� $:jhj� ާ :ki� +� �Wh� �k�i� +� �Wh� �h� �� �  :l+� |h� �l�+� |h� � :m+� �m�+� �+�� 3+5+� \� b:n6o+� \n� H++� 7*� �2�8 *� �2�;Y:p� "� fY� hYj� l5� pr� u� y� z�p:n6o+� |~5n  o� �+�� 3+ �*� �2� �� ��� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3+=+� \� b:q6r+� \q� H++� 7*� �2�8 *� �2�;Y:s� "� fY� hYj� l=� pr� u� y� z�s:q6r+� |~=q  r� �+�� 3+ �*� �2� �� ��� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3+?+� \� b:t6u+� \t� I++� 7*� �2�8 *� �2�;Y:v� "� fY� hYj� l?� pr� u� y� z�v:t6u+� |~?t  u� �+�� 3+ �*� �	2� �� ��� �� � � 3+�� 3+� 7*� �
2+� �*� �
2� � � E W+�� 3� +�� 3+A+� \� b:w6x+� \w� I++� 7*� �2�8 *� �2�;Y:y� "� fY� hYj� lA� pr� u� y� z�y:w6x+� |~Aw  x� �+�� 3+ �*� �2� �� ��� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3+C+� \� b:z6{+� \z� I++� 7*� �2�8 *� �2�;Y:|� "� fY� hYj� lC� pr� u� y� z�|:z6{+� |~Cz  {� �+�� 3+ �*� �2� �� ��� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3+E+� \� b:}6~+� \}� I++� 7*� �2�8 *� �2�;Y:� "� fY� hYj� lE� pr� u� y� z�:}6~+� |~E}  ~� �+�� 3+ �*� �2� �� ��� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3+G+� \� b:�6�+� \�� I++� 7*� �2�8 *� �2�;Y:�� "� fY� hYj� lG� pr� u� y� z��:�6�+� |~G�  �� �+�� 3+ �*� �2� �� ��� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +I� 3+K+� \� b:�6�+� \�� I++� 7*� �2�8 *� �2�;Y:�� "� fY� hYj� lK� pr� u� y� z��:�6�+� |~K�  �� �+�� 3+ �*� �2� �� ��� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3+M+� \� b:�6�+� \�� I++� 7*� �2�8 *� �2�;Y:�� "� fY� hYj� lM� pr� u� y� z��:�6�+� |~M�  �� �+�� 3+ �*� �2� �� ��� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3+O+� \� b:�6�+� \�� I++� 7*� �2�8 *� �2�;Y:�� "� fY� hYj� lO� pr� u� y� z��:�6�+� |~O�  �� �+�� 3+ �*� �2� �� ��� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3+Q+� \� b:�6�+� \�� I++� 7*� � 2�8 *� �2�;Y:�� "� fY� hYj� lQ� pr� u� y� z��:�6�+� |~Q�  �� �+�� 3+ �*� �!2� �� ��� �� � � 3+�� 3+� 7*� �"2+� �*� �"2� � � E W+�� 3� +�� 3+S+� \� b:�6�+� \�� I++� 7*� �#2�8 *� �2�;Y:�� "� fY� hYj� lS� pr� u� y� z��:�6�+� |~S�  �� �+�� 3+ �*� �$2� �� ��� �� � � 3+�� 3+� 7*� �%2+� �*� �%2� � � E W+�� 3� +�� 3+U+� \� b:�6�+� \�� I++� 7*� �&2�8 *� �2�;Y:�� "� fY� hYj� lU� pr� u� y� z��:�6�+� |~U�  �� �+�� 3+ �*� �'2� �� ��� �� � � 3+�� 3+� 7*� �(2+� �*� �(2� � � E W+�� 3� +�� 3+W+� \� b:�6�+� \�� I++� 7*� �)2�8 *� �2�;Y:�� "� fY� hYj� lW� pr� u� y� z��:�6�+� |~W�  �� �+�� 3+ �*� �*2� �� ��� �� � � 3+�� 3+� 7*� �+2+� �*� �+2� � � E W+�� 3� +�� 3+Y+� \� b:�6�+� \�� I++� 7*� �,2�8 *� �2�;Y:�� "� fY� hYj� lY� pr� u� y� z��:�6�+� |~Y�  �� �+�� 3+ �*� �-2� �� ��� �� � � 3+�� 3+� 7*� �.2+� �*� �.2� � � E W+�� 3� +�� 3+[+� \� b:�6�+� \�� I++� 7*� �/2�8 *� �2�;Y:�� "� fY� hYj� l[� pr� u� y� z��:�6�+� |~[�  �� �+�� 3+ �*� �02� �� ��� �� � � 3+�� 3+� 7*� �12+� �*� �12� � � E W+�� 3� +I� 3+� 7� �� � ]�`� � �Q+�� 3+� �+� |��� �� �:��b� ��+� 7� =� � � ��� �6��� l+��� �+d� 3++� 7*� �2� � �i�l+n� 3�� ���֧ $:���� ާ :��� +� �W�� ����� +� �W�� ��� �� �  :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� �+� |��� �� �:��p� ��+� 7� =� � � ��� �6��� m+��� �+d� 3++� 7*� �2� � �i�l+r� 3�� ���է $:���� ާ :��� +� �W�� ����� +� �W�� ��� �� �  :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� �+� |��� �� �:��t� ��+� 7� =� � � ��� �6��� m+��� �+d� 3++� 7*� �
2� � �i�l+v� 3�� ���է $:���� ާ :��� +� �W�� ����� +� �W�� ��� �� �  :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� �+� |��� �� �:��x� ��+� 7� =� � � ��� �6��� m+��� �+d� 3++� 7*� �2� � �i�l+z� 3�� ���է $:���� ާ :��� +� �W�� ����� +� �W�� ��� �� �  :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� �+� |��� �� �:��|� ��+� 7� =� � � ��� �6��� m+��� �+d� 3++� 7*� �2� � �i�l+~� 3�� ���է $:���� ާ :��� +� �W�� ����� +� �W�� ��� �� �  :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � ��� �6��� m+��� �+d� 3++� 7*� �2� � �i�l+�� 3�� ���է $:���� ާ :��� +� �W�� ����� +� �W�� ��� �� �  :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � �¶ �6��� m+�ö �+d� 3++� 7*� �2� � �i�l+�� 3¶ ���է $:��Ķ ާ :��� +� �W¶ �ſ�� +� �W¶ �¶ �� �  :�+� |¶ �ƿ+� |¶ � :�+� �ǿ+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � �ȶ �6��� m+�ɶ �+d� 3++� 7*� �2� � �i�l+�� 3ȶ ���է $:��ʶ ާ :��� +� �Wȶ �˿�� +� �Wȶ �ȶ �� �  :�+� |ȶ �̿+� |ȶ � :�+� �Ϳ+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � �ζ �6��� m+�϶ �+d� 3++� 7*� �2� � �i�l+�� 3ζ ���է $:��ж ާ :��� +� �Wζ �ѿ�� +� �Wζ �ζ �� �  :�+� |ζ �ҿ+� |ζ � :�+� �ӿ+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � �Զ �6��� m+�ն �+d� 3++� 7*� �2� � �i�l+�� 3Զ ���է $:��ֶ ާ :��� +� �WԶ �׿�� +� �WԶ �Զ �� �  :�+� |Զ �ؿ+� |Զ � :�+� �ٿ+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � �ڶ �6��� m+�۶ �+d� 3++� 7*� �"2� � �i�l+�� 3ڶ ���է $:��ܶ ާ :��� +� �Wڶ �ݿ�� +� �Wڶ �ڶ �� �  :�+� |ڶ �޿+� |ڶ � :�+� �߿+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � �� �6��� m+�� �+d� 3++� 7*� �%2� � �i�l+�� 3� ���է $:��� ާ :��� +� �W� ���� +� �W� �� �� �  :�+� |� ��+� |� � :�+� ��+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � �� �6��� m+�� �+d� 3++� 7*� �(2� � �i�l+�� 3� ���է $:��� ާ :��� +� �W� ���� +� �W� �� �� �  :�+� |� ��+� |� � :�+� ��+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � �� �6��� m+��� �+d� 3++� 7*� �+2� � �i�l+�� 3� ���է $:��� ާ :��� +� �W� ���� +� �W� �� �� �  :�+� |� ��+� |� � :�+� ��+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � �� �6��� m+�� �+d� 3++� 7*� �.2� � �i�l+�� 3� ���է $:���� ާ :��� +� �W� ����� +� �W� �� �� �  :�+� |� ���+� |� � :�+� ���+� �+�� 3+� �+� |��� �� �:���� ��+� 7� =� � � ��� �6��� m+��� �+d� 3++� 7*� �12� � �i�l+�� 3�� ���է $:���� ާ :��� +� �W�� ����� +� �W�� ��� �� �  :�+� |�� ���+� |�� � :�+� ���+� �+�� 3+� 7����� E W+�� 3� +�� 3+�� 3+�� 3+� 7*� �2� � ��`� � � -+�� 3+� �+�� 3� :�+� ���+� �+�� 3� N+� 7*� �2� � ��`� � � -+�� 3+� �+�� 3� :�+� ���+� �+�� 3� +�� 3+ö 3+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+Ƕ 3� �: +� �� �+� �+�� 3� R+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+ɶ 3� �:+� ���+� �+�� 3� +˶ 3+Ͷ 3+϶ 3+� 7*� �2� � ��`� � � 1+�� 3+� �+Ѷ 3� �:+� ���+� �+�� 3� S+� 7*� �2� � ��`� � � 1+�� 3+� �+Ӷ 3� �:+� ���+� �+�� 3� +ն 3+ö 3+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+׶ 3� �:+� ���+� �+�� 3� S+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+ٶ 3� �:+� ���+� �+�� 3� +۶ 3+ݶ 3+߶ 3+� 7*� �
2� � ��`� � � 1+�� 3+� �+� 3� �:+� ���+� �+�� 3� S+� 7*� �
2� � ��`� � � 1+�� 3+� �+� 3� �:+� ���+� �+�� 3� +� 3+ö 3+� 7*� �
2� � Ÿ`� � � 1+�� 3+� �+� 3� �:+� ���+� �+�� 3� S+� 7*� �
2� � Ÿ`� � � 1+�� 3+� �+� 3� �:	+� ��	�+� �+�� 3� +� 3+�� 3+� 3+� 7*� �2� � ��`� � � 1+�� 3+� �+� 3� �:
+� ��
�+� �+�� 3� S+� 7*� �2� � ��`� � � 1+�� 3+� �+� 3� �:+� ���+� �+�� 3� +�� 3+ö 3+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+�� 3� �:+� ���+� �+�� 3� S+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+�� 3� �:+� ���+� �+�� 3� +�� 3+�� 3+�� 3+� 7*� �2� � ��`� � � 1+�� 3+� �+� 3� �:+� ���+� �+�� 3� S+� 7*� �2� � ��`� � � 1+�� 3+� �+� 3� �:+� ���+� �+�� 3� +� 3+ö 3+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+� 3� �:+� ���+� �+�� 3� S+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+	� 3� �:+� ���+� �+�� 3� +� 3+� 3+� 3+� 7*� �2� � ��`� � � 1+�� 3+� �+� 3� �:+� ���+� �+�� 3� S+� 7*� �2� � ��`� � � 1+�� 3+� �+� 3� �:+� ���+� �+�� 3� +� 3+ö 3+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+� 3� �:+� ���+� �+�� 3� S+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+� 3� �:+� ���+� �+�� 3� +� 3+� 3+� 3+� 7*� �2� � ��`� � � 1+�� 3+� �+!� 3� �:+� ���+� �+�� 3� S+� 7*� �2� � ��`� � � 1+�� 3+� �+#� 3� �:+� ���+� �+�� 3� +%� 3+ö 3+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+'� 3� �:+� ���+� �+�� 3� S+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+)� 3� �:+� ���+� �+�� 3� ++� 3+-� 3+/� 3+� 7*� �2� � ��`� � � 1+�� 3+� �+1� 3� �:+� ���+� �+�� 3� S+� 7*� �2� � ��`� � � 1+�� 3+� �+3� 3� �:+� ���+� �+�� 3� +5� 3+ö 3+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+7� 3� �:+� ���+� �+�� 3� S+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+9� 3� �:+� ���+� �+�� 3� +;� 3+=� 3+?� 3+� 7*� �2� � ��`� � � 1+�� 3+� �+A� 3� �:+� ���+� �+�� 3� S+� 7*� �2� � ��`� � � 1+�� 3+� �+C� 3� �:+� ���+� �+�� 3� +E� 3+G� 3+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+I� 3� �: +� �� �+� �+�� 3� S+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+K� 3� �:!+� ��!�+� �+�� 3� +M� 3+O� 3+Q� 3+� 7*� �2� � ��`� � � 1+�� 3+� �+S� 3� �:"+� ��"�+� �+�� 3� S+� 7*� �2� � ��`� � � 1+�� 3+� �+U� 3� �:#+� ��#�+� �+�� 3� +W� 3+Y� 3+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+[� 3� �:$+� ��$�+� �+�� 3� S+� 7*� �2� � Ÿ`� � � 1+�� 3+� �+]� 3� �:%+� ��%�+� �+�� 3� +_� 3+a� 3+c� 3+� 7*� �"2� � ��`� � � 1+�� 3+� �+e� 3� �:&+� ��&�+� �+�� 3� S+� 7*� �"2� � ��`� � � 1+�� 3+� �+g� 3� �:'+� ��'�+� �+�� 3� +i� 3+Y� 3+� 7*� �"2� � Ÿ`� � � 1+�� 3+� �+k� 3� �:(+� ��(�+� �+�� 3� S+� 7*� �"2� � Ÿ`� � � 1+�� 3+� �+m� 3� �:)+� ��)�+� �+�� 3� +o� 3+q� 3+s� 3+� 7*� �%2� � ��`� � � 1+�� 3+� �+u� 3� �:*+� ��*�+� �+�� 3� S+� 7*� �%2� � ��`� � � 1+�� 3+� �+w� 3� �:++� ��+�+� �+�� 3� +y� 3+Y� 3+� 7*� �%2� � Ÿ`� � � 1+�� 3+� �+{� 3� �:,+� ��,�+� �+�� 3� S+� 7*� �%2� � Ÿ`� � � 1+�� 3+� �+}� 3� �:-+� ��-�+� �+�� 3� +� 3+�� 3+�� 3+� 7*� �(2� � ��`� � � 1+�� 3+� �+�� 3� �:.+� ��.�+� �+�� 3� S+� 7*� �(2� � ��`� � � 1+�� 3+� �+�� 3� �:/+� ��/�+� �+�� 3� +�� 3+Y� 3+� 7*� �(2� � Ÿ`� � � 1+�� 3+� �+�� 3� �:0+� ��0�+� �+�� 3� S+� 7*� �(2� � Ÿ`� � � 1+�� 3+� �+�� 3� �:1+� ��1�+� �+�� 3� +�� 3+�� 3+�� 3+� 7*� �+2� � ��`� � � 1+�� 3+� �+�� 3� �:2+� ��2�+� �+�� 3� S+� 7*� �+2� � ��`� � � 1+�� 3+� �+�� 3� �:3+� ��3�+� �+�� 3� +�� 3+Y� 3+� 7*� �+2� � Ÿ`� � � 1+�� 3+� �+�� 3� �:4+� ��4�+� �+�� 3� S+� 7*� �+2� � Ÿ`� � � 1+�� 3+� �+�� 3� �:5+� ��5�+� �+�� 3� +�� 3+�� 3+�� 3+� 7*� �.2� � ��`� � � 1+�� 3+� �+�� 3� �:6+� ��6�+� �+�� 3� S+� 7*� �.2� � ��`� � � 1+�� 3+� �+�� 3� �:7+� ��7�+� �+�� 3� +�� 3+Y� 3+� 7*� �.2� � Ÿ`� � � 1+�� 3+� �+�� 3� �:8+� ��8�+� �+�� 3� S+� 7*� �.2� � Ÿ`� � � 1+�� 3+� �+�� 3� �:9+� ��9�+� �+�� 3� +�� 3+�� 3+�� 3+�� 3+� 7*� �12� � ��`� � � 1+�� 3+� �+�� 3� �::+� ��:�+� �+�� 3� S+� 7*� �12� � ��`� � � 1+�� 3+� �+�� 3� �:;+� ��;�+� �+�� 3� +�� 3+Y� 3+� 7*� �12� � Ÿ`� � � 1+�� 3+� �+�� 3� �:<+� ��<�+� �+�� 3� S+� 7*� �12� � Ÿ`� � � 1+�� 3+� �+�� 3� �:=+� ��=�+� �+�� 3� +�� 3+ö 3+Ŷ 3+Ƕ 3+� 7��� � ɸ`� � � 1+�� 3+� �+˶ 3� �:>+� ��>�+� �+�� 3� +�� 3+� 7��� � ͸`� � � 1+�� 3+� �+϶ 3� �:?+� ��?�+� �+�� 3� +�� 3+� 7��� � Ѹ`� � � 1+�� 3+� �+Ӷ 3� �:@+� ��@�+� �+�� 3� +�� 3+� 7��� � ո`� � � 1+�� 3+� �+׶ 3� �:A+� ��A�+� �+�� 3� +�� 3+� 7��� � ٸ`� � � 1+�� 3+� �+۶ 3� �:B+� ��B�+� �+�� 3� +�� 3+� 7��� � ݸ`� � � 1+�� 3+� �+߶ 3� �:C+� ��C�+� �+�� 3� +�� 3+� 7��� � �`� � � 1+�� 3+� �+� 3� �:D+� ��D�+� �+�� 3� +�� 3+� 7��� � �`� � � 1+�� 3+� �+� 3� �:E+� ��E�+� �+�� 3� +�� 3+� 7��� � �`� � � 1+�� 3+� �+� 3� �:F+� ��F�+� �+�� 3� +�� 3+� 7��� � ��`� � � 1+�� 3+� �+� 3� �:G+� ��G�+� �+�� 3� +�� 3+� 7��� � �`� � � 1+�� 3+� �+� 3� �:H+� ��H�+� �+�� 3� +�� 3+� 7��� � ��`� � � 1+�� 3+� �+�� 3� �:I+� ��I�+� �+�� 3� +�� 3+� 7��� � ��`� � � 1+�� 3+� �+�� 3� �:J+� ��J�+� �+�� 3� +�� 3+� 7��� � ��`� � � 1+�� 3+� �+�� 3� �:K+� ��K�+� �+�� 3� +�� 3+� 7��� � �`� � � 1+�� 3+� �+� 3� �:L+� ��L�+� �+�� 3� +�� 3+� 7��� � �`� � � 1+�� 3+� �+� 3� �:M+� ��M�+� �+�� 3� +�� 3+� 7��� � 	�`� � � 1+�� 3+� �+� 3� �:N+� ��N�+� �+�� 3� +�� 3+� 7��� � �`� � � 1+�� 3+� �+� 3� �:O+� ��O�+� �+�� 3� +�� 3+� 7��� � �`� � � 1+�� 3+� �+� 3� �:P+� ��P�+� �+�� 3� +�� 3+� 7��� � �`� � � 1+�� 3+� �+� 3� �:Q+� ��Q�+� �+�� 3� +�� 3+� 7��� � �`� � � 1+�� 3+� �+� 3� �:R+� ��R�+� �+�� 3� +�� 3+� 7��� � �`� � � 1+�� 3+� �+� 3� �:S+� ��S�+� �+�� 3� +�� 3+� 7��� � !�`� � � 1+�� 3+� �+#� 3� �:T+� ��T�+� �+�� 3� +�� 3+� 7��� � %�`� � � 1+�� 3+� �+'� 3� �:U+� ��U�+� �+�� 3� +�� 3+� 7��� � )�`� � � 1+�� 3+� �++� 3� �:V+� ��V�+� �+�� 3� +�� 3+� 7��� � -�`� � � 1+�� 3+� �+/� 3� �:W+� ��W�+� �+�� 3� +I� 3+� 7��� � 1�`� � � 1+�� 3+� �+3� 3� �:X+� ��X�+� �+�� 3� +5� 3+7� 3+9+� \� b�:Y�6Z+� \�Y� 9�Y�:[� "� fY� hYj� l9� pr� u� y� z��[�:Y�6Z+� |~9�Y  �Z� �+�� 3+ �*� �22� �� ��� �� � � ^+�� 3+� �*� �32� � ;�`� � � 3+�� 3+� 7*� �42+� �*� �32� � � E W+�� 3� � +=� 3+� 7*� �42� � ?�`� � �1�+�� 3+� 7*� �52�B� E W+�� 3+� �+� |��� �� ��:\�\ƶ ��\+� 7� =� � � ��\� ��6]�]� f+�\�]� �+׶ 3�\� ���� 2�:^�\�^� ާ  �:_�]� +� �W�\� ��_��]� +� �W�\� ��\� �� �  �:`+� |�\� ��`�+� |�\� � �:a+� ��a�+� �+�� 3+� �+� |��� �� ��:b�b�� ��b+� 7� =� � � ��b� ��6c�c� f+�b�c� �+�� 3�b� ���� 2�:d�b�d� ާ  �:e�c� +� �W�b� ��e��c� +� �W�b� ��b� �� �  �:f+� |�b� ��f�+� |�b� � �:g+� ��g�+� �+�� 3+� �+� |��� �� ��:h�h�� ��h+� 7� =� � � ��h� ��6i�i� f+�h�i� �+�� 3�h� ���� 2�:j�h�j� ާ  �:k�i� +� �W�h� ��k��i� +� �W�h� ��h� �� �  �:l+� |�h� ��l�+� |�h� � �:m+� ��m�+� �+�� 3+� �+� |��� �� ��:n�n� ��n+� 7� =� � � ��n� ��6o�o� g+�n�o� �+� 3�n� ���� 2�:p�n�p� ާ  �:q�o� +� �W�n� ��q��o� +� �W�n� ��n� �� �  �:r+� |�n� ��r�+� |�n� � �:s+� ��s�+� �+�� 3+� �+� |��� �� ��:t�t� ��t+� 7� =� � � ��t� ��6u�u� g+�t�u� �+� 3�t� ���� 2�:v�t�v� ާ  �:w�u� +� �W�t� ��w��u� +� �W�t� ��t� �� �  �:x+� |�t� ��x�+� |�t� � �:y+� ��y�+� �+�� 3+� �+� |��� �� ��:z�z	� ��z+� 7� =� � � ��z� ��6{�{� g+�z�{� �+� 3�z� ���� 2�:|�z�|� ާ  �:}�{� +� �W�z� ��}��{� +� �W�z� ��z� �� �  �:~+� |�z� ��~�+� |�z� � �:+� ���+� �+�� 3+� �+� |��� �� ��:���� ���+� 7� =� � � ���� ��6���� g+����� �+� 3��� ���� 2�:������ ާ  �:���� +� �W��� ������� +� �W��� ���� �� �  �:�+� |��� ����+� |��� � �:�+� ����+� �+�� 3+� �+� |��� �� ��:���� ���+� 7� =� � � ���� ��6���� g+����� �+� 3��� ���� 2�:������ ާ  �:���� +� �W��� ������� +� �W��� ���� �� �  �:�+� |��� ����+� |��� � �:�+� ����+� �+�� 3+� �+� |��� �� ��:���� ���+� 7� =� � � ���� ��6���� g+����� �+� 3��� ���� 2�:������ ާ  �:���� +� �W��� ������� +� �W��� ���� �� �  �:�+� |��� ����+� |��� � �:�+� ����+� �+�� 3+� �+� |��� �� ��:���� ���+� 7� =� � � ���� ��6���� g+����� �+� 3��� ���� 2�:������ ާ  �:���� +� �W��� ������� +� �W��� ���� �� �  �:�+� |��� ����+� |��� � �:�+� ����+� �+�� 3+� �+� |��� �� ��:���� ���+� 7� =� � � ���� ��6���� g+����� �+� 3��� ���� 2�:������ ާ  �:���� +� �W��� ������� +� �W��� ���� �� �  �:�+� |��� ����+� |��� � �:�+� ����+� �+�� 3+� �+� |��� �� ��:���!� ���+� 7� =� � � ���� ��6���� g+����� �+#� 3��� ���� 2�:������ ާ  �:���� +� �W��� ������� +� �W��� ���� �� �  �:�+� |��� ����+� |��� � �:�+� ����+� �+�� 3+� �+� |��� �� ��:���%� ���+� 7� =� � � ���� ��6���� g+����� �+'� 3��� ���� 2�:������ ާ  �:���� +� �W��� ������� +� �W��� ���� �� �  �:�+� |��� ����+� |��� � �:�+� ����+� �+�� 3+� �+� |��� �� ��:���)� ���+� 7� =� � � ���� ��6���� g+����� �++� 3��� ���� 2�:������ ާ  �:���� +� �W��� ������� +� �W��� ���� �� �  �:�+� |��� ����+� |��� � �:�+� ����+� �+�� 3+� �+� |��� �� ��:���-� ���+� 7� =� � � ���� ��6���� g+����� �+/� 3��� ���� 2�:������ ާ  �:���� +� �W��� ������� +� �W��� ���� �� �  �:�+� |��� ����+� |��� � �:�+� ����+� �+�� 3+� �+� |��� �� ��:���1� ���+� 7� =� � � ���� ��6���� g+����� �+3� 3��� ���� 2�:������ ާ  �:���� +� �W��� ������� +� �W��� ���� �� �  �:�+� |��� ����+� |��� � �:�+� ����+� �+I� 3+� �+� |��� �� ��:���D� ���+� 7� =� � � ���F�I��� ��6���� g+����� �+K� 3��� ���� 2�:������ ާ  �:���� +� �W��� ������� +� �W��� ���� �� �  �:�+� |��� ����+� |��� � �:�+� ����+� �+�� 3+� �+� |��� �� ��:���M� ���+� 7� =� � � ���O�I�¶ ��6�����+���ö �+Q� 3+� �+D�U�:�+�X�6����ƹ^ �6��Źa � � � ��6����Źa �g�:�+� 7�Źk ��d�6�����`�o� N���Ķr�ƹv � � � � ,�Ķr�6�+++� 7*� �62� � �i�{�l���� .�:������ƹv W+� 7�~ �ĸ��̿�����ƹv W+� 7�~ �ĸ�� �:�+� ��Ϳ+� �+�� 3�¶ ����� 2�:����ζ ާ  �:���� +� �W�¶ ��Ͽ��� +� �W�¶ ��¶ �� �  �:�+� |�¶ ��п+� |�¶ � �:�+� ��ѿ+� �+�� 3+� �+� |��� �� ��:����� ���+� 7� =� � � ��Ҷ ��6���� �+���Ӷ �+�� 3+++� 7*� �72�8 *� �82�;�i�l+�� 3�Ҷ ���ȧ 2�:����Զ ާ  �:���� +� �W�Ҷ ��տ��� +� �W�Ҷ ��Ҷ �� �  �:�+� |�Ҷ ��ֿ+� |�Ҷ � �:�+� ��׿+� �+�� 3+� 7*� �92++� 7*� �:2�8 *� �;2�;� E W+�� 3+� �+� |��� �� ��:����� ���+� 7� =� � � ��ض ��6���� �+���ٶ �+�� 3+++� 7*� �72�8 *� �82�;�i�l+�� 3�ض ���ȧ 2�:����ڶ ާ  �:���� +� �W�ض ��ۿ��� +� �W�ض ��ض �� �  �:�+� |�ض ��ܿ+� |�ض � �:�+� ��ݿ+� �+�� 3+� |��� ����:���������������������޶�W�޶�� �  �:�+� |�޶ ��߿+� |�޶ �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������++� 7*� �<2� � �i��++� 7*� �2�8 *� �2�;�i����������W���� �  �:�+� |�� ���+� |�� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������������W���� �  �:�+� |�� ���+� |�� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������++� 7*� �<2� � �i��++� 7*� �2�8 *� �2�;�i����������W���� �  �:�+� |�� ���+� |�� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������������W���� �  �:�+� |�� ���+� |�� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������++� 7*� �<2� � �i��++� 7*� �2�8 *� �2�;�i����������W���� �  �:�+� |�� ���+� |�� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������������W���� �  �:�+� |�� ���+� |�� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������++� 7*� �<2� � �i��++� 7*� �2�8 *� �2�;�i����������W���� �  �:�+� |�� ����+� |�� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������������W���� �  �:�+� |�� ���+� |�� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������++� 7*� �<2� � �i��++� 7*� �2�8 *� �2�;�i����������W���� �  �:�+� |�� ���+� |�� �+Զ 3+� |��� ����:�������������+� 7*� �92� � �i���������������W���� �  �:�+� |�� ���+� |�� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������++� 7*� �<2� � �i��++� 7*� �2�8 *� �2�;�i�����������W����� �  �:�+� |��� ����+� |��� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i����������������W����� �  �:�+� |��� ����+� |��� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������++� 7*� �<2� � �i��++� 7*� �2�8 *� �2�;�i�����������W����� �  �:�+� |��� ����+� |��� �+Զ 3+� |��� ����:�������������+� 7*� �92� � �i����������������W����� �  �:�+� |��� ����+� |��� �+�� 3+� |��� ����:�������������+� 7*� �92� � �i���������++� 7*� �<2� � �i��++� 7*� �2�8 *� �2�;�i�����������W����� �  �:�+� |��� ����+� |��� �+Զ 3+� |��� ����:�������������+� 7*� �92� � �i����������������W����� �  �:�+� |��� ����+� |��� �+�� 3+� |��� ����: � ��� ���� �+� 7*� �92� � �i�������� ++� 7*� �<2� � �i��++� 7*� �2�8 *� �2�;�i�������� ��W� ��� �  �:+� |� � ���+� |� � �+Զ 3+� |��� ����:���������+� 7*� �92� � �i��������������W���� �  �:+� |�� ���+� |�� �+�� 3+� |��� ����:���������+� 7*� �92� � �i��������++� 7*� �<2� � �i��++� 7*� �2�8 *� �2�;�i����������W���� �  �:+� |�� ���+� |�� �+�� 3+� |��� ����:���������+� 7*� �92� � �i��������������W���� �  �:+� |�� ���+� |�� �+�� 3+� |��� ����:���������+� 7*� �92� � �i��������++� 7*� �<2� � �i��++� 7*� � 2�8 *� �2�;�i����������W���� �  �:	+� |�� ��	�+� |�� �+�� 3+� |��� ����:
�
���
����
�+� 7*� �92� � �i��������
����
��W�
��� �  �:+� |�
� ���+� |�
� �+�� 3+� |��� ����:���������+� 7*� �92� � �i��������++� 7*� �<2� � �i��++� 7*� �#2�8 *� �2�;�i����������W���� �  �:+� |�� ���+� |�� �+Զ 3+� |��� ����:���������+� 7*� �92� � �i��������������W���� �  �:+� |�� ���+� |�� �+�� 3+� |��� ����:���������+� 7*� �92� � �i��������++� 7*� �<2� � �i��++� 7*� �&2�8 *� �2�;�i����������W���� �  �:+� |�� ���+� |�� �+�� 3+� |��� ����:���������+� 7*� �92� � �i��������������W���� �  �:+� |�� ���+� |�� �+�� 3+� |��� ����:���������+� 7*� �92� � �i��������++� 7*� �<2� � �i��++� 7*� �)2�8 *� �2�;�i����������W���� �  �:+� |�� ���+� |�� �+Զ 3+� |��� ����:���������+� 7*� �92� � �i��������������W���� �  �:+� |�� ���+� |�� �+�� 3+� |��� ����:���������+� 7*� �92� � �i��������++� 7*� �<2� � �i��++� 7*� �,2�8 *� �2�;�i����������W���� �  �:+� |�� ���+� |�� �+Զ 3+� |��� ����:���������+� 7*� �92� � �i��������������W���� �  �:+� |�� ���+� |�� �+�� 3+� |��� ����:���������+� 7*� �92� � �i��������++� 7*� �<2� � �i ++� 7*� �/2�8 *� �2�;�i����������W���� �  �:+� |�� ���+� |�� �+�� 3+� |��� ����:���������+� 7*� �92� � �i�������+����������W���� �  �:+� |�� ���+� |�� �+�� 3+� |��� ����: � ��� ��� �+� 7*� �92� � �i������� +� 7*� �92� � �i����+������ �� ��W� ��� �  �:!+� |� � ��!�+� |� � �+�� 3+� |��� ����:"�"���"����"�+� 7*� �92� � �i�������"+������"��"��W�"��� �  �:#+� |�"� ��#�+� |�"� �+�� 3+� |��� ����:$�$���$���$�+� 7*� �92� � �i�������$+�����+��������$��$��W�$��� �  �:%+� |�$� ��%�+� |�$� �+�� 3+� | "� ��$�:&�&&�'�&)+� 7*� �92� � �i�����,�&-�2�&�3�6'�'� F+�&�'� �+�� 3�&�4��� �:(�'� +� �W�(��'� +� �W�&�5� �  �:)+� |�&� ��)�+� |�&� �+�� 3+� | "� ��$�:*�*�+� 7*� �92� � �i�����'�*7�:�*<�,�*=�2�*�3�6+�+� F+�*�+� �+�� 3�*�4��� �:,�+� +� �W�,��+� +� �W�*�5� �  �:-+� |�*� ��-�+� |�*� �+�� 3+� |��� ����:.�.���.@���.�+� 7*� �92� � �i�������.��W�.��� �  �:/+� |�.� ��/�+� |�.� �+B� 3+� �+� |��� �� ��:0�0D� ��0+� 7� =� � � ��0� ��61�1� g+�0�1� �+F� 3�0� ���� 2�:2�0�2� ާ  �:3�1� +� �W�0� ��3��1� +� �W�0� ��0� �� �  �:4+� |�0� ��4�+� |�0� � �:5+� ��5�+� �+H� 3� +J� 3+L� 3+� �+� |��� �� ��:6�6N� ��6+� 7� =� � � ��6� ��67�7� g+�6�7� �+P� 3�6� ���� 2�:8�6�8� ާ  �:9�7� +� �W�6� ��9��7� +� �W�6� ��6� �� �  �::+� |�6� ��:�+� |�6� � �:;+� ��;�+� �+�� 3++� 7*� �=2�8 �V�Y� � � +[� 3� 
+]� 3+_� 3+a� 3+� 7*� �52� � �`� � � 1+�� 3+� �+c� 3� �:<+� ��<�+� �+�� 3� +e� 3+g� 3+� 7*� �>2++�ln�s� E W+�� 3+� �+� |��� �� ��:=�=u� ��=+� 7� =� � � ��=� ��6>�>� g+�=�>� �+w� 3�=� ���� 2�:?�=�?� ާ  �:@�>� +� �W�=� ��@��>� +� �W�=� ��=� �� �  �:A+� |�=� ��A�+� |�=� � �:B+� ��B�+� �+�� 3+� �+� |��� �� ��:C�Cy� ��C+� 7� =� � � ��C� ��6D�D� g+�C�D� �+{� 3�C� ���� 2�:E�C�E� ާ  �:F�D� +� �W�C� ��F��D� +� �W�C� ��C� �� �  �:G+� |�C� ��G�+� |�C� � �:H+� ��H�+� �+�� 3+� �+}� 3++��*� �?2�� �i� 3+�� 3+++� 7*� �@2�8 ���;�i� 3+�� 3+++� 7*� �A2�8 ���;�i� 3+�� 3++� 7*� �>2� � �i� 3+�� 3� �:I+� ��I�+� �+�� 3�hWfi )Wru  *��  ��  ), )58  �nn  ���  ��� )���  �11  �KK  ��� )���  s��  b  fvy )f��  8��  '��  +;> )+GJ  ���  ���  �  )�  �EE  �__  ��� )���  �

  v$$  z�� )z��  L��  ;��  	?	O	R )	?	[	^  		�	�  	 	�	�  


 )

 
#  	�
Y
Y  	�
s
s  
�
�
� )
�
�
�  
�  
�88  ��� )���  `��  O��  Scf )Sor  %��  ��  (+ )47  �mm  ���  ��� )���  �22  �LL  @C )LO  ���  ���  �#& )�/2  �hh  ���  �	 )�  �KK  �ee  ��� )���  �..  |HH  ��� )���  p    _ + +   � � � ) � � �   S � �   B!!  !d!�!� )!d!�!�  !6!�!�  !%!�!�  "G"u"x )"G"�"�  ""�"�  ""�"�  #*#X#[ )#*#d#g  "�#�#�  "�#�#�  $$;$> )$$G$J  #�$�$�  #�$�$�  $�%%! )$�%*%-  $�%c%c  $�%}%}  %�&& )%�&&  %�&F&F  %�&`&`  &�&�&� )&�&�&�  &�')')  &w'C'C  '�'�'� )'�'�'�  'k((  'Z(&(&  (|(�(� )(|(�(�  (N(�(�  (=)	)	  )_)�)� ))_)�)�  )1)�)�  ) )�)�  *X*b*b  *�*�*�  *�++  +K+U+U  +�+�+�  , ,
,
  ,^,h,h  ,�,�,�  ---  -c-m-m  -�-�-�  ...  .v.�.�  .�.�.�  /$/./.  /t/~/~  /�/�/�  0)0303  0�0�0�  0�0�0�  1<1F1F  1�1�1�  1�1�1�  2:2D2D  2�2�2�  2�2�2�  3M3W3W  3�3�3�  444  4R4\4\  4�4�4�  5 5
5
  5e5o5o  5�5�5�  666  6c6m6m  6�6�6�  77"7"  7v7�7�  7�7�7�  8+8585  8{8�8�  8�8�8�  9)9393  9�9�9�  9�9�9�  :<:F:F  :�:�:�  :�:�:�  ;A;K;K  ;�;�;�  ;�;�;�  <T<^<^  <�<�<�  ===  =R=\=\  =�=�=�  >>>  >e>o>o  >�>�>�  ?!?+?+  ?q?{?{  ?�?�?�  @@)@)  @�@�@�  @�@�@�  A+A5A5  A}A�A�  A�A�A�  B!B+B+  BsB}B}  B�B�B�  CC!C!  CiCsCs  C�C�C�  DDD  D_DiDi  D�D�D�  EEE  EUE_E_  E�E�E�  E�FF  FKFUFU  F�F�F�  F�F�F�  GAGKGK  G�G�G�  G�G�G�  H7HAHA  H�H�H�  H�H�H�  J�J�J� )J�J�J�  JbKK  JOK)K)  K�K�K� )K�K�K�  KWK�K�  KDLL  L�L�L� )L�L�L�  LLL�L�  L9MM  M}M�M� )M}M�M�  MAM�M�  M.N
N
  NtN�N� )NtN�N�  N8N�N�  N%OO  OkO}O� )OkO�O�  O/O�O�  OO�O�  PbPtPw )PbP�P�  P&P�P�  PP�P�  QYQkQn )QYQ}Q�  QQ�Q�  Q
Q�Q�  RPRbRe )RPRtRw  RR�R�  RR�R�  SGSYS\ )SGSkSn  SS�S�  R�S�S�  T>TPTS )T>TbTe  TT�T�  S�T�T�  U5UGUJ )U5UYU\  T�U�U�  T�U�U�  V,V>VA )V,VPVS  U�V�V�  U�V�V�  W#W5W8 )W#WGWJ  V�W�W�  V�W�W�  XX,X/ )XX>XA  W�X�X�  W�X�X�  YY#Y& )YY5Y8  X�Y|Y|  X�Y�Y�  ZZ%Z( )ZZ7Z:  Y�Z~Z~  Y�Z�Z�  [�[�[�  [\6\6  [\Y\\ )[\k\n  Z�\�\�  Z�\�\�  ]>]y]| )]>]�]�  ]]�]�  \�]�]�  ^�^�^� )^�^�^�  ^T_$_$  ^A_F_F  _r_�_�  _�`�`�  `�aa  aWa�a�  b*b�b�  b�c[c[  c�c�c�  d,d�d�  e e]e]  e�f1f1  flf�f�  gg�g�  g�h4h4  hnii  iCi�i�  i�jtjt  j�kk  kFk�k�  llxlx  l�mLmL  m�m�m�  nn�n�  n�oNoN  o�p"p"  p]p�p�  p�q�q�  q�r&r&  r`r�r�  s5s�s�  s�tftf  t�t�t�  u8u�u�  vv{v{  v�w@w@  wzw�w�  x#x�x�  y;yOyO  x�y�y�  z"z6z6  y�zlzl  z�z�z�  {r{�{� ){r{�{�  {6{�{�  {#{�{�  |{|�|� )|{|�|�  |?|�|�  |,}}  }�}�}�  ~5~G~J )~5~Y~\  }�~�~�  }�~�~�  ,>A ),PS  ~���  ~���  Ԁd�d            * +    N�           @  A ! k $ � - � 0 � 9 � < � ? � E � � � � �a �� �� �	 � �Z �� � �� �� �[ �� �  �j �� �/ ��o�4
~�	C	�

�
�H�W �"$�&�(\+�,�-$.-0�1�2�35~6�7�8�:S;{<�=�?(@PAwB�D�E%FLGUI�J�K!L+P�Q�R�S V}W�X�Y�[R\z]�^�`'aObvce�f$gKhTj�k�l m)o�p�q�r�t{u�v�w�yPzx{�|�����4������������u�����X����� ;� �� ��!�!h�!��"�"K�"i�"��#.�#L�#��$�$/�$��$��%�%��%��%��&p�&��&��'S�'��'��(6�(��(��)�)c�)��)��*�*�*�*#�*&�**�*-�*Q�*\�*o�*r�*��*��*��*��*��*��*��*��*��+ �+ ++D+O+f+i+s+}!+�"+�&+�'+�(+�)+�*+�+,,,-,.,(1,+=,/>,2?,W@,bA,yB,|C,�D,�E,�F,�G,�I,�X,�Y,�c,�d,�h-i-j-.k-1l-\m-gn-~o-�p-�r-�~-�-��-��-��-��-��.
�.�.,�./�.9�.C�.G�.J�.o�.z�.��.��.��.��.��.��.��.��.��.��/�/(�/?�/B�/m�/x�/��/��/��/��/��/��/��/��/��/��/��/��0"�0-�0D�0G�0Q�0T0X0[0�0�0�0�	0�
0�0�0�0�11 1	'1(1/1501@11W21Z31�41�51�61�71�:1�F1�G1�H1�I1�J2K2L23M2>N2UO2XP2bS2ln2po2sr2�s2�t2�u2�v2�w2�x3
y3z3}3�3�3!�3F�3Q�3h�3k�3��3��3��3��3��3��3��3��3��3��3��4�4�4 �4K�4V�4m�4p�4z�4}�4��4��4��4��4��4��4��5�5�5�5(�5+�5/�52�56�59�5^�5i�5��5��5��5��5� 5�5�5�5�5�666.616\6g6~6�6�6�66�76�=6�>6�?6�@6�A7B7C73D76E7@H7CT7GU7JV7oW7zX7�Y7�Z7�[7�\7�]7�^7�a7�z7�{7��8$�8/�8F�8I�8t�8�8��8��8��8��8��8��8��8��8��8��9"�9-�9D�9G�9Q�9[�9_�9b�9��9��9��9��9��9��9��9��:�:	�:�:�:5�:@�:W�:Z�:��:��:��:��:��:� :�:�:�:�;	;
;:;E;\;_;i;l;p;s;� ;�!;�";�#;�$;�%<
&<'<*<!B<%C<(I<MJ<XK<oL<rM<�N<�O<�P<�Q<�T<�`<�a<�b<�c=d=e= f=Kg=Vh=mi=pj=zm=��=��=��=��=��=��=��> �>�>"�>%�>/�>2�>6�>9�>^�>i�>��>��>��>��>��>��>��>��>��>��?�?%�?<�??�?j�?u�?��?��?��?��?��?��?��?��?��?��@�@#�@:�@=�@G�@Q@U@_%@�&@�'@�(@�)@�+@�,@�-@�.@�/A 1A$2A/3AF4AI5AR7Av8A�9A�:A�;A�=A�>A�?A�@A�AA�CBDB%EB<FB?GBHJBlKBwLB�MB�NB�PB�QB�RB�SB�TB�VCWCXC2YC5ZC>\Cb]Cm^C�_C�`C�bC�cC�dC�eC�fC�hDiDjD(kD+lD4nDXoDcpDzqD}rD�tD�uD�vD�wD�xD�{D�|E}E~E!E*�EN�EY�Ep�Es�E|�E��E��E��E��E��E��E��F�F�F �FD�FO�Ff�Fi�Fr�F��F��F��F��F��F��F��G
�G�G�G:�GE�G\�G_�Gh�G��G��G��G��G��G��G��H �H�H�H0�H;�HR�HU�H^�H��H��H��H��H��H��H��H��H��I�I��I��I��I��J�J.�JH�J��K=�K��L2�L��M'�M��N�Nx OOoPPfQ
Q]Q�RTR�SKS�TBT�U9U�V0 V�"W'$W�&X(X�*Y,Y�0Z2Z�4[8\K9\�;]B<]k=^?^:A^�B^�C_ZE_�H`I`)J`�H`�J`�La?OamPa�QbObQbSb�Ub�Vb�WczUczWc}Yd[dB\dh]d�[d�]d�_eae�be�cfPafPcfTef�gghg?ig�gg�ig�khVmh�nh�oi'mi'oi+qi�si�tjuj�sj�uj�wk.yk\zk�{k�yk�{l}l�l��l��mkmk�mn�n�n3�nY�n��n��n��op�o��o��pA�pA�pE�p��q
�q0�q��q��q��rH�rv�r��s�s�s�s��s��t�t��t��t��u �uN�ut�u��u��u��v"�vH�v\�v��v��v��v��v��w!�w_�w_�wb�w��w��w��x�x�x�x9�x_�x��x��x��x��x��y�y>�y��y��y��y��z%�z��z��z��{�{�{�{v�|�|�|!�|%�|(�|�}�}G�}J�}Q�}T�}b}�}�}�}�}�
}� }�!}�%}�&~9(~�)0+�,�-�y.     ) ��         �         ) ��          �         ) ��         �        �      �    �*B� �Y���SY���SY���SY5��SY���SY���SY=��SY���SY���SY	?��SY
���SY���SYA��SY���SY���SYC��SY���SY¸�SYE��SYĸ�SYƸ�SYG��SYȸ�SYʸ�SYK��SY̸�SYθ�SYM��SYи�SYҸ�SYO��SYԸ�SY ָ�SY!Q��SY"ظ�SY#ڸ�SY$S��SY%ܸ�SY&޸�SY'U��SY(��SY)��SY*W��SY+��SY,��SY-Y��SY.��SY/��SY0[��SY1��SY2��SY3��SY4��SY5���SY6���SY7���SY8���SY9���SY:���SY; ��SY<��SY=��SY>��SY?��SY@
��SYA��S� ��         