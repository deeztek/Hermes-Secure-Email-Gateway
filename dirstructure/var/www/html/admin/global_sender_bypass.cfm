����   2 global_sender_bypass_cfm$cf  lucee/runtime/PageImpl  /admin/global_sender_bypass.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength     ' getCompileTime  n��5 getHash ()I��� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Lglobal_sender_bypass_cfm$cf;
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Global Sender Block/Allow List</title>
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
 J)</script>
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
              <td height="920" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion27" style="background-image: url('./middle_988.png'); height: 920px;">
                  <tr align="left" valign="top">
                    <td>
                      <table cellpadding="0" cellspacing="0" border="0" width="970">
                        <tr valign="top" align="left">
                          <td>
                            <table border="0" cellspacing="0" cellpadding="0" width="520">
                              <tr valign="top" align="left">
                                <td width="14" height="15"></td>
                                <td width="506"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                 P<td width="506" id="Text485" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Global Sender Block/Allow List</span></b></p>
                                </td>
                              </tr>
                              <tr valign="top" align="left">
                                <td colspan="2" height="2"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td></td>
                                <td width="506" id="Text486" class="TextObject">
                                  <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Add Global Sender Block/Allow Entry </span></b></p>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td>
                             R<table border="0" cellspacing="0" cellpadding="0" width="450">
                              <tr valign="top" align="left">
                                <td width="425" height="6"></td>
                                <td></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td height="25"></td>
                                <td width="25"><a target="_self" href="javascript:openpopup_27b5('https://www.deeztek.com/documentation/hermes-seg-documentation/hermes-seg-administrator-guide/content-checks/global-sender-block-allow-list/')"><img id="Picture2" height="25" width="25" src="./help.png" border="0" alt="Online Help" title="Online Help"></a></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                         T3<tr valign="top" align="left">
                          <td width="13" height="5"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="365"></td>
                          <td width="954"> V m1 X &lucee/runtime/config/NullSupportHelper Z NULL \ '
 [ ] -lucee/runtime/interpreter/VariableInterpreter _ getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; a b
 ` c 0 e %lucee/runtime/exp/ExpressionException g java/lang/StringBuilder i The required parameter [ k  1
 j m append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; o p
 j q ] was not provided. s -(Ljava/lang/String;)Ljava/lang/StringBuilder; o u
 j v toString ()Ljava/lang/String; x y
 j z
 h m lucee/runtime/PageContextImpl } any �       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 ~ � 
 � m2 � m3 � m4 � step �  

 � action �   �  
 �@       _action � ;	 9 � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � ;	 9 � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � 	show_type � block � _type � ;	 9 � _TYPE � ;	 9 � keys $[Llucee/runtime/type/Collection$Key; � �	  � 
sendertype � sender � A � 	canceladd � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 ~ � lucee/runtime/tag/Query � setName � 1
 � � setDatasource (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � J
delete from amavis_sender_bypass where action='add' and applied='2'   
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � � doEndTag � $
 � � lucee/runtime/exp/Abort  newInstance (I)Llucee/runtime/exp/Abort;
 reuse !(Ljavax/servlet/jsp/tagext/Tag;)V
 ~ 	outputEnd
 
 / lucee.runtime.tag.Location 
cflocation lucee/runtime/tag/Location global_sender_bypass.cfm?m2=7 setUrl 1
 setAddtoken (Z)V

 �
 � 

 canceldelete  f
update amavis_sender_bypass set action='NONE', applied='1' where action='delete' and applied='2'  
" $global_sender_bypass.cfm?m1=5#delete$�




                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion5" style="height: 365px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td height="225" width="954">& add( [@]* lucee/runtime/op/Caster, &(Ljava/lang/Object;)Ljava/lang/String; x.
-/ %lucee/runtime/functions/string/REFind1 S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object; &3
24 (Ljava/lang/Object;D)I �6
 �7 #lucee/commons/color/ConstantsDouble9 _2 Ljava/lang/Double;;<	:= email? domainA _0C<	:D _1F<	:G 





I 2K #lucee/runtime/functions/string/LeftM B(Llucee/runtime/PageContext;Ljava/lang/String;D)Ljava/lang/String; &O
NP #lucee/runtime/functions/string/TrimR A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &T
SU .W '(Ljava/lang/String;Ljava/lang/String;)I �Y
 �Z (lucee/runtime/functions/decision/IsValid\ B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &^
]_ _3a<	:b 1

<!-- /CFIF IsValid("email", temp_email) -->
d bob@f java/lang/Stringh concat &(Ljava/lang/String;)Ljava/lang/String;jk
il 

<!-- /CFIF sendertype -->
n ,

<!-- /CFIF #trim(left(sender, 1))# -->
p  

<!-- /CFIF step is "2" -->
r 3t checkexistsv 8
SELECT sender from amavis_sender_bypass where sender='x writePSQz �
 /{ '
} getCollection � A� #lucee/runtime/util/VariableUtilImpl� recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;��
�� insertsender� stSender� 	setResult� 1
 �� Z
insert into amavis_sender_bypass
(sender, transport, action, type, applied)
values
('� .', 'FILTER amavis:[127.0.0.1]:10030', 'add', '� 	', '2')
� .

<!-- /CFIF #checkexists.recordcount# -->
�  

<!-- /CFIF step is "3" -->
� $

<!-- /CFIF action is "add" -->
��










                                        <form name="block" action="global_sender_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="add">
                                          <table border="0" cellspacing="0" cellpadding="0" width="954">
                                            <tr valign="top" align="left">
                                              <td width="954" id="Text424" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"><b><span style="color: rgb(255,0,0);">Warning:</span></b> <b>Use extreme caution when adding any Global Sender Allow entries. Any Allow Action entries will bypass ALL filter checks to include any Spam, Virus and Banned File checks to ALL the recipients in your system!! Do not use if at all possible. Additionally, a Global Sender Block/Allow entry will take precedence over any Sender to Recipient Block/Allow entries. This is the proverbial using a sledgehammer to kill a fly approach. Please consider alternative methods of bypassing senders. �a</b> <b>Please note that you CANNOT add &#8220;.&#8221; in front of the domain name to encompass all subdomains. You must enter each domain and any of its subdomain separately.</b></span></p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0" width="472">
                                            <tr valign="top" align="left">
                                              <td height="28"></td>
                                              <td width="32"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td colspan="2" width="472" id="Text497" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enter Email Address or Domain below�</span></p>
                                              </td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td colspan="2" height="2"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td height="22" width="440"><input type="text" id="FormsEditField39" name="sender" size="55" maxlength="255" style="width: 436px; white-space: pre;"></td>
                                              <td></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td colspan="2" height="8"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              �-<td colspan="2" width="472" id="Text432" class="TextObject">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Select Action to take below</span></p>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              <td height="2"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="487">
                                                <table id="Table154" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 34px;">
                                                  ��<tr style="height: 19px;">
                                                    <td width="58" id="Cell936">
                                                      <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;">� h
<input type="radio" name="type" value="block" checked="checked" style="height: 19px; width: 19px;"/>
� V
<input type="radio" name="type" value="block" style="height: 19px; width: 19px;"/>
�M


&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      &nbsp;</td>
                                                    <td width="429" id="Cell937">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Block Action</span></p>
                                                    </td>
                                                  </tr>
                                                  <tr style="height: 19px;">
                                                    <td id="Cell938">
                                                      <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            � <p style="margin-bottom: 0px;">� allow� g
<input type="radio" name="type" value="allow" checked="checked" style="height: 19px; width: 19px;">
� U
<input type="radio" name="type" value="allow" style="height: 19px; width: 19px;">
�


&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                      &nbsp;</td>
                                                    <td id="Cell939">
                                                      <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Allow Action</span></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                          <table border="0" cellspacing="0" cellpadding="0">
                                            <tr valign="top" align="left">
                                              �<td height="6"></td>
                                            </tr>
                                            <tr valign="top" align="left">
                                              <td width="954">
                                                <table id="Table152" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  <tr style="height: 24px;">
                                                    <td width="954" id="Cell934">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                �!<td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;"><input type="submit" id="FormsButton5" name="FormsButton5" value="Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">

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
                                          �#</table>
                                        </form>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="30" valign="middle" width="954"><hr id="HRRule1" width="954" size="1"></td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="290">
                                    <tr valign="top" align="left">
                                      <td width="290" height="3"></td>
                                    </tr>
                                    ��<tr valign="top" align="left">
                                      <td width="290" id="Text375" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Global Sender Block/Allow Entries&nbsp; to be added</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td width="954" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="954" id="Text374" class="TextObject">
                                        <p style="margin-bottom: 0px;">� get_add_senders� ]
select * from amavis_sender_bypass where action='add' and applied='2' order by sender asc
� S
<select name="parameters2" style="height: 88px;" size="60" disabled="disabled">
� getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;��
 /� getId� $
 /� lucee/runtime/type/Query� getCurrentrow (I)I���� getRecordcount� $�� !lucee/runtime/util/NumberIterator� load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� A� isValid (I)Z��
�� current� $
�� go (II)Z���� 
<option value="� _ID� ;	 9� ">�  --> �  --> TO BE ADDED</option>
� removeQuery�  A� release &(Llucee/runtime/util/NumberIterator;)V��
�� 
</select>
� �
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No Block/Allow Sender(s) found to be added..</span></p>
�6&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954">
                                        <form name="Table127FORM" action="global_sender_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="canceladd">
                                          <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="954" id="Cell738">
                                                �$<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;">  �
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
 �
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Add" style="height: 24px; width: 136px;" disabled="disabled">
&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td width="954" height="5"></td>
                                    </tr>
                                     �<tr valign="top" align="left">
                                      <td width="954" id="Text277" class="TextObject">
                                        <p style="margin-bottom: 0px;"> 1
u
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Sender Domain or Email Address field cannot be blank</span></i></b></p>
�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Sender Domain or Email Address field must be a valid e-mail address or a valid domain. Ensure you don't enter a "." in front of a domain when adding a domain</span></i></b></p>
�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Global Sender you are attempting to add already exists or is already set to be added</span></i></b></p>
 4�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Entry ready to be added. Please click the Apply Settings to apply your changes</span></i></b></p>
 


 7r
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All add requests have been cancelled</span></i></b></p>



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
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="12" height="1"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="443"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="2"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="6" valign="middle" width="953"><hr id="HRRule10" width="953" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="46"></td>
                          <td colspan="7" width="954"> StartRow @       urlScope  ()Llucee/runtime/type/scope/URL;$%
 /& lucee/runtime/type/scope/URL() � DisplayRows+ 20- minusRef 8(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Double;/0
 �1 plusRef30
 �4 filter6 _FILTER8 ;	 99 getmailaddrtemp; L
select * from amavis_sender_bypass where applied='1' order by sender asc
= [^_a-zA-Z0-9-.@]? 	error.cfmA checkkeywordsC ,
SELECT * FROM keywords where keyword IN ('E ') and banned='1'
G I
select * from amavis_sender_bypass where applied='1' and sender like '%I %' order by sender asc
KR



                            <table border="0" cellspacing="0" cellpadding="0" width="954" id="LayoutRegion21" style="height: 46px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table cellpadding="0" cellspacing="0" border="0" width="623">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="430">
                                              <form name="Table144FORM" action="global_sender_bypass_filter.cfm" method="post">
                                                <input type="hidden" name="setfilter" value="1">
                                                <table id="Table144" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 25px;">
                                                  M<tr style="height: 25px;">
                                                    <td width="56" id="Cell864">
                                                      <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Filter By</span></p>
                                                    </td>
                                                    <td width="258" id="Cell865">
                                                      <p style="margin-bottom: 0px;">O <input type="text" id="FormsEditField41" name="filter" size="29" maxlength="29" style="width: 228px; white-space: pre;" value="Q1</p>
                                                    </td>
                                                    <td width="116" id="Cell866">
                                                      <table width="110" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Set Filter" style="height: 24px; width: 87px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                S</table>
                                              </form>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0">
                                          <tr valign="top" align="left">
                                            <td width="15"></td>
                                            <td width="178">
                                              <form name="Table145FORM" action="global_sender_bypass_filter.cfm" method="post">
                                                <input type="hidden" name="clearfilter" value="1">
                                                <table id="Table145" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                                  U<tr style="height: 24px;">
                                                    <td width="178" id="Cell868">
                                                      <table width="153" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Clear Filter" style="height: 24px; width: 105px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                WW</table>
                                              </form>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="954">
                                    <tr valign="top" align="left">
                                      <td width="954" height="4"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="954" id="Text381" class="TextObject">
                                        <p style="margin-bottom: 0px;">Y]
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field cannot be blank</span></i></b></p>
[�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field must only contain letters, numbers, underscores, dashes, @ symbols and periods</span></i></b></p>
]�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The filter field contains banned keywords. Keywords such as Select, Update, Delete etc. are not allowed</span></i></b></p>
_





&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="6" valign="middle" width="952"><hr id="HRRule12" width="952" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          a�<td colspan="2" width="506" id="Text488" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Delete Global Sender Block/Allow Entry</span></b></p>
                          </td>
                          <td colspan="6"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="188"></td>
                          <td colspan="5" width="951">c sender_bypasse  


g deletei _fieldnamesk ;	 9l  lucee/runtime/type/util/ListUtiln listToArrayRemoveEmpty /(Ljava/lang/String;C)Llucee/runtime/type/Array;pq
or lucee/runtime/type/Arrayt sizev $uw thefieldy getVariableReference Y(Llucee/runtime/PageContext;Ljava/lang/String;)Llucee/runtime/type/ref/VariableReference;{|
 `} getE (I)Ljava/lang/Object;�u� (lucee/runtime/type/ref/VariableReference� B�
�� cbox� ct '(Ljava/lang/Object;Ljava/lang/Object;)Z��
 �� java/lang/Object� 2lucee/runtime/functions/dynamicEvaluation/Evaluate� B(Llucee/runtime/PageContext;[Ljava/lang/Object;)Ljava/lang/Object; &�
�� I
update amavis_sender_bypass set applied='2', action='delete' where id='� 'global_sender_bypass.cfm?m1=2&StartRow=� &DisplayRows=� &filter=� #delete� 
 � 'global_sender_bypass.cfm?m1=1&StartRow=�

                            <table border="0" cellspacing="0" cellpadding="0" width="951" id="LayoutRegion4" style="height: 188px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="950">
                                        <table id="Table147" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          <tr style="height: 17px;">
                                            <td width="452" id="Cell869">
                                              <table width="215" border="0" cellspacing="0" cellpadding="0" align="left">
                                                <tr>
                                                  <td class="TextObject">
                                                    � -
<A HREF="global_sender_bypass.cfm?StartRow=� &action=� u#delete"><P STYLE="margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>&lt;&lt; Previous �  Records</SPAN></b></P>
</A>
� 
 
�r&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                            <td width="9" id="Cell870">
                                              <p style="margin-bottom: 0px;">&nbsp;</p>
                                            </td>
                                            <td width="489" id="Cell871">
                                              <table width="234" border="0" cellspacing="0" cellpadding="0" align="right">
                                                <tr>
                                                  <td class="TextObject">
                                                    <p style="text-align: right; margin-bottom: 0px;">� '(Ljava/lang/Object;Ljava/lang/Object;)I ��
 �� z#delete"><P STYLE="text-align: right; margin-bottom: 0px;"><SPAN STYLE="font-size: 12px; color: rgb(128,128,128);"><b>Next� toDoubleValue (Ljava/lang/Double;)D��
-� (DLjava/lang/Object;)I ��
 �� 
      � 
    � +Records&nbsp; &gt;&gt;</SPAN></b></P></A>
� 
  
��&nbsp;</p>
                                                  </td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="5"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951" id="Text378" class="TextObject">
                                        <p style="margin-bottom: 0px;">� �
<p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Displaying � 	 through �  out of �  total records.</span></p>
�W&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table cellpadding="0" cellspacing="0" border="0" width="192">
                                    <tr valign="top" align="left">
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="89">
                                          <tr valign="top" align="left">
                                            <td width="89" height="3"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td height="17" width="89" id="Text458" class="TextObject">
                                              <p style="margin-bottom: 0px;"><b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('delete', true);" href="javascript:void();">��<span style="font-size: 10px;">Select All</span></a></b><span style="font-size: 10px;"></span>&nbsp;</p>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td>
                                        <table border="0" cellspacing="0" cellpadding="0" width="103">
                                          <tr valign="top" align="left">
                                            <td width="14" height="3"></td>
                                            <td width="89"></td>
                                          </tr>
                                          <tr valign="top" align="left">
                                            <td></td>
                                            <td width="89" id="Text462" class="TextObject">
                                              <p style="margin-bottom: 0px;"><b><a style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 10px; color: rgb(51,51,51); text-decoration: none ;" onclick="javascript:checkAll('delete', false);" href="javascript:void();">�`<span style="font-size: 10px;">None</span></a></b>&nbsp;</p>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" width="951" id="Text266" class="TextObject">
                                        <p style="margin-bottom: 0px;">� 
<form name="delete" action="� 0global_sender_bypass.cfm?action=delete&StartRow=�)" method="post">

<table style="table-layout: fixed; width: 100%" class="bottomBorder">
  <tr style="height: 28px;">
<td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Select</span></b></p>
    </td>

    <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Sender</span></b></p>
    </td>
   
  <td>
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-size: 12px;">Type</span></b></p>
    </td>
   
  
    
  </tr>


� (Ljava/lang/Object;)D��
-� lucee/runtime/util/NumberRange� range (II)I��
�� loadMax ((III)Llucee/runtime/util/NumberIterator;��
�� /


  <tr style="height: 28px;">


     
� ?
     
<td align="center">
<input type="checkbox" name="cbox� 	" value="� 0" style="height: 13px; width: 13px;">
</td>

� 8
<td align="center">
<input type="checkbox" name="cbox� B" style="height: 13px; width: 13px;" disabled="disabled">
</td>
� �



    <td id="Cell1056">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">� � </span></p>
</div>
    </td>
    


    <td id="Cell1060">
<div style="word-wrap: break-word;">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-size: 12px;">� ,</span></p>
</div>
    </td>

    


�w
        </tr>
      </table>

<br><br>
<table id="Table155" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
  <tr style="height: 24px;">
    <td width="951" id="Cell940">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center">
            <table width="160" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="TextObject">
                  <p style="text-align: center; margin-bottom: 0px;">
<input type="submit" id="FormsButton5" name="FormsButton5" value="Delete" style="height: 24px; width: 69px;"
 onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
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

� �
<p style=""text-align: center; margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);">No existing Global Sender Block/Allow entries found...</span></i></b></p>
�$&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="290" height="4"></td>
                                      <td width="660"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="290" id="Text416" class="TextObject">
                                        <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Global Sender Block/Allow Entries&nbsp; to be deleted</span></b></p>
                                      </td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      �H<td colspan="2" height="2"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td height="24" colspan="2" width="950" id="Text417" class="TextObject">
                                        <p style="margin-bottom: 0px;">� get_parameters3 `
select * from amavis_sender_bypass where action='delete' and applied='2' order by sender asc
 S
<select name="parameters3" style="height: 88px;" size="60" disabled="disabled">
  --> TO BE DELETED</option>
 �
<p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">No Global Sender Block/Allow entries found ..</span></p>
	d&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="3"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="951">
                                        <form name="Table127FORM" action="global_sender_bypass.cfm?action=canceldelete#delete#" method="post">
                                          <table id="Table151" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="951" id="Cell875">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  �<tr>
                                                    <td align="center">
                                                      <table width="136" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"> �
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" onclick="this.disabled=true;this.value='Wait...';this.form.submit();">
 �
<input type="submit" id="FormsButton5" name="FormsButton5" value="Cancel All Delete" style="height: 24px; width: 136px;" disabled="disabled">
&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="951">
                                    <tr valign="top" align="left">
                                      <td width="951" height="4"></td>
                                    </tr>
                                     �<tr valign="top" align="left">
                                      <td width="951" id="Text276" class="TextObject">
                                        <p style="margin-bottom: 0px;">w
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;you must select an entry before clicking the Delete button</span></i></b></p>
�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Block/Allow List ready to be deleted. Please click the Apply Settings to apply your changes</span></i></b></p>
 5u
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All delete requests have been cancelled</span></i></b></p>

&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="3" valign="middle" width="949"><hr id="HRRule13" width="949" size="1"></td>
                          <td colspan="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="9" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                           M<td height="63"></td>
                          <td colspan="4" width="950">! apply# %

<!-- RESET ALL APPLIED TO 2 -->
% resetall' /
update amavis_sender_bypass set applied='2'
) %

<!-- GET ALL DELETE ACTIONS -->
+ 	getdelete- J
delete from amavis_sender_bypass where action='delete' and applied='2'
/ (

<!-- GET ALL ADD ALLOW ACTIONS -->
1 getaddallow3 Z
select * from amavis_sender_bypass where action='add' and type='allow' and applied='2'
5 (

<!-- GET ALL ADD BLOCK ACTIONS -->
7 getaddblock9 Z
select * from amavis_sender_bypass where action='add' and type='block' and applied='2'
; =

<!-- GENERATE UNIQUE TRANSACTION NUMBER STARTS HERE -->
= customtrans? getrandom_resultsA Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
C inserttransE stResultG &
insert into salt
(salt)
values
('I ')
K gettransM 2
select salt as customtrans2 from salt where id='O I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �Q
 /R deletetransT 
delete from salt where id='V �

<!-- GENERATE UNIQUE TRANSACTION NUMBER ENDS HERE -->

<!-- CREATE FILEDATAALLOWPOSTFIX VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
X@@       "lucee/runtime/functions/string/Chr\ 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &^
]_@*      @$       `

<!-- WRITE AMAVIS_SENDERBYPASS FILE WITH FILEDATAALLOWPOSTFIX VARIABLE CREATED EARLIER -->
e lucee.runtime.tag.FileTagg cffilei lucee/runtime/tag/FileTagk hasBodym
ln 0 	setActionq 1
lr  /etc/postfix/amavis_senderbypasst setFilev 1
lw 	setOutputy �
lz setAddnewline|
l}
l �
l � `

<!-- CREATE FILEDATAALLOWAMAVIS VARIABLE AND INSERT ADD ALLOW ENTRIES TO THAT VARIABLE -->
� U

<!-- WRITE WHITE.LST FILE WITH FILEDATAALLOWAMAVIS VARIABLE CREATED EARLIER -->
� /etc/amavis/white.lst� `

<!-- CREATE FILEDATABLOCKAMAVIS VARIABLE AND INSERT ADD BLOCK ENTRIES TO THAT VARIABLE -->
� U

<!-- WRITE BLACK.LST FILE WITH FILEDATABLOCKAMAVIS VARIABLE CREATED EARLIER -->
� /etc/amavis/black.lst� W

<!-- CREATE POSTMAP SCRIPT TO POSTMAP THE AMAVIS_SENDERBYPASS FILE IN POSTFIX -->
� /opt/hermes/tmp/� _postmap.sh� 2/usr/sbin/postmap /etc/postfix/amavis_senderbypass� -

<!-- MAKE POSTMAP SCRIPT EXECUTABLE -->
� lucee.runtime.tag.Execute� 	cfexecute� lucee/runtime/tag/Execute� 
/bin/chmod�
� � +x /opt/hermes/tmp/� setArguments� �
��@N       
setTimeout (D)V��
��
� �
� �
� � %

<!-- EXECUTE POSTMAP SCRIPT -->
�@n       	/dev/null� setOutputfile� 1
�� -inputformat none� $

<!-- DELETE POSTMAP SCRIPT -->
� 

<!-- RESTART POSTFIX -->
� /bin/systemctl� restart postfix� 

<!-- RESTART AMAVIS -->
� restart amavis� %

<!-- RESET ALL APPLIED TO 1 -->
� setapply� R
update amavis_sender_bypass set applied='1' where action='add' and applied='2'
� 

<!-- SET SUCCESS -->
� #global_sender_bypass.cfm?m3=7#apply�F



                            <table border="0" cellspacing="0" cellpadding="0" width="950" id="LayoutRegion17" style="height: 63px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="6"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="950">
                                        <form name="apply_settings" action="global_sender_bypass.cfm" method="post">
                                          <input type="hidden" name="action" value="apply">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              ��<td width="950" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;">� 
getapplied� 8
select * from amavis_sender_bypass where applied='2'
� �
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" style="height: 24px; width: 142px;">
� �
<input type="submit" onclick="this.disabled=true;this.value='Applying settings, please wait...';this.form.submit();" name="FormsButton1" value="Apply Settings" disabled="disabled" style="height: 24px; width: 142px;">
�&nbsp;</p>
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
                                  <table border="0" cellspacing="0" cellpadding="0" width="950">
                                    <tr valign="top" align="left">
                                      <td width="950" height="2"></td>
                                    </tr>
                                    � �<tr valign="top" align="left">
                                      <td width="950" id="Text330" class="TextObject">
                                        <p style="text-align: left; margin-bottom: 0px;">�]
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! Changes Applied</span></i></b></p>
�





&nbsp;</p>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td colspan="4"></td>
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
                          �<td width="981" height="12"></td>
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
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway � sessionScope $()Llucee/runtime/type/scope/Session;��
 /�  lucee/runtime/type/scope/Session�  � 	 Version: _VALUE ;	 9  Build: . Copyright 2011-	 l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>C
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
 ���� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException  lucee/runtime/type/UDFProperties udfs #[Llucee/runtime/type/UDFProperties;	  setPageSource 
  	SHOW_TYPE  lucee/runtime/type/KeyImpl" intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;$%
#& SENDER( STEP* 
SENDERTYPE, M2. 
TEMP_EMAIL0 CHECKEXISTS2 GET_ADD_SENDERS4 STARTROW6 DISPLAYROWS8 TOROW: NEXT< PREVIOUS> CHECKKEYWORDS@ M4B SENDER_BYPASSD 
FIELDNAMESF THEFIELDH THEIDJ M1L GETMAILADDRTEMPN APPLIEDP GET_PARAMETERS3R RANDOMT STRESULTV GENERATED_KEYX CUSTOMTRANS3Z GETTRANS\ CUSTOMTRANS2^ FILEDATAALLOWPOSTFIX` GETADDALLOWb 	TRANSPORTd FILEDATAALLOWAMAVISf FILEDATABLOCKAMAVISh GETADDBLOCKj 
GETAPPLIEDl M3n THEYEARp EDITIONr 
GETVERSIONt GETBUILDv subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   xy       z   *     *� 
*� *� � *��*+��        z         �        z        � �        z         �        z         �         z         !�      # $ z        %�      & ' z  N� 6  B�+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q� 3+S� 3+U� 3+W� 3+Y+� ^� dM>+� ^,� .fY:� !� hY� jYl� nY� rt� w� {� |�M>+� ~�Y, � �� �+�� 3+�+� ^� d:6+� ^� 0fY:� !� hY� jYl� n�� rt� w� {� |�:6+� ~�� � �� �+�� 3+�+� ^� d:6	+� ^� 0fY:
� !� hY� jYl� n�� rt� w� {� |�
:6	+� ~�� � �	� �+�� 3+�+� ^� d:6+� ^� 0fY:� !� hY� jYl� n�� rt� w� {� |�:6+� ~�� � �� �+�� 3+�+� ^� d:6+� ^� 0fY:� !� hY� jYl� n�� rt� w� {� |�:6+� ~�� � �� �+�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� n�� rt� w� {� |�:6+� ~�� � �� �+�� 3+ �� �� �� ��� �� � � Q+�� 3+� �� �� � �� �� � � ++�� 3+� 7� �+� �� �� � � E W+�� 3� � +�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� n�� rt� w� {� |�:6+� ~�� � �� �+�� 3+ �� �� �� ��� �� � � T+�� 3+� �� ƹ � �� �� � � .+�� 3+� 7*� �2+� �� ƹ � � E W+�� 3� � +�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� n̶ rt� w� {� |�:6+� ~�� � �� �+�� 3+�+� ^� d:6+� ^� 0�Y:� !� hY� jYl� nζ rt� w� {� |�:6+� ~�� � �� �+�� 3+ �*� �2� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+� 7� �� � Ѹ �� � �%+�� 3+� �+� ~��� �� �:Ѷ �+� 7� =� � � �� �6� N+� �+� 3� ����� $:� �� : � +� �W� � �� +� �W� �� �� ��� :!+� ~�	!�+� ~�	� :"+�"�+�+�� 3+� ~� ��:##�#�#�W#�� ��� :$+� ~#�	$�+� ~#�	+� 3�D+� 7� �� � !� �� � �&+�� 3+� �+� ~��� �� �:%%!� �%+� 7� =� � � �%� �6&&� O+%&� �+#� 3%� ���� $:'%'� �� :(&� +� �W%� �(�&� +� �W%� �%� �� ��� :)+� ~%�	)�+� ~%�	� :*+�*�+�+�� 3+� ~� ��:++%�+�+�W+�� ��� :,+� ~+�	,�+� ~+�	+�� 3� +'� 3+� 7� �� � )� �� � ��+� 3+� 7*� �2� � �� �� � � �+�� 3+++� 7*� �2� � �0�5�8� � � >+�� 3+� 7*� �2�>� E W+�� 3+� 7*� �2@� E W+�� 3� ;+�� 3+� 7*� �2�>� E W+�� 3+� 7*� �2B� E W+�� 3+�� 3� ^+� 7*� �2� � �� �� � � >+�� 3+� 7*� �2�E� E W+�� 3+� 7*� �2�H� E W+�� 3� +J� 3+� 7*� �2� � L� �� � ��+� 3+++� 7*� �2� � �0�Q�VX�[� � � ?+�� 3+� 7*� �2�E� E W+�� 3+� 7*� �2�>� E W+� 3�-+++� 7*� �2� � �0�Q�VX�[� � � +�� 3+� 7*� �2� � @� �� � � �+�� 3+� 7*� �2+� 7*� �2� � � E W+� 3+@+� 7*� �2� � �`� %+�� 3+� 7*� �2�c� E W+�� 3� a+@+� 7*� �2� � �`� � � ?+�� 3+� 7*� �2�E� E W+�� 3+� 7*� �2�>� E W+e� 3� +� 3� �+� 7*� �2� � B� �� � � �+�� 3+� 7*� �2g+� 7*� �2� � �0�m� E W+� 3+@+� 7*� �2� � �`� %+�� 3+� 7*� �2�c� E W+�� 3� a+@+� 7*� �2� � �`� � � ?+�� 3+� 7*� �2�E� E W+�� 3+� 7*� �2�>� E W+e� 3� +o� 3� +q� 3� +s� 3� +� 3+� 7*� �2� � u� �� � ��+� 3+� �+� ~��� �� �:--w� �-+� 7� =� � � �-� �6..� l+-.� �+y� 3++� 7*� �2� � �0�|+~� 3-� ���֧ $:/-/� �� :0.� +� �W-� �0�.� +� �W-� �-� �� ��� :1+� ~-�	1�+� ~-�	� :2+�2�+�+� 3++� 7*� �2�� ���8� � �+� 3+� �+� ~��� �� �:33�� �3+� 7� =� � � �3���3� �644� �+34� �+�� 3++� 7*� �2� � �0�|+�� 3++� 7*� �2� � �0�|+�� 33� ����� $:535� �� :64� +� �W3� �6�4� +� �W3� �3� �� ��� :7+� ~3�	7�+� ~3�	� :8+�8�+�+� 3� c++� 7*� �2�� ���8� � � ?+�� 3+� 7*� �2�E� E W+�� 3+� 7*� �2�c� E W+�� 3� +�� 3� +�� 3� +�� 3+�� 3+�� 3+�� 3+�� 3+� 7*� �2� � �� �� � � -+�� 3+� �+�� 3� :9+�9�+�+�� 3� *+�� 3+� �+�� 3� ::+�:�+�+�� 3+�� 3+�� 3+� 7*� �2� � �� �� � � -+�� 3+� �+�� 3� :;+�;�+�+�� 3� *+�� 3+� �+�� 3� :<+�<�+�+�� 3+�� 3+�� 3+�� 3+�� 3+�� 3+� �+� ~��� �� �:==�� �=+� 7� =� � � �=� �6>>� O+=>� �+�� 3=� ���� $:?=?� �� :@>� +� �W=� �@�>� +� �W=� �=� �� ��� :A+� ~=�	A�+� ~=�	� :B+�B�+�+�� 3++� 7*� �2�� ���8� � �=+¶ 3+� �+���:D+��6EDE�� 6FD�� � � � �6GGD�� ��:C+� 7D�� Gd6JCJ`��� �DC��E�� � � � � eC��6J+� 3++� 7�� � �0� 3+� 3++� 7*� �2� � �0� 3+� 3++� 7� ƹ � �0� 3+� 3��y� ":KDFE�� W+� 7�� C��K�DFE�� W+� 7�� C��� :L+�L�+�+�� 3� 
+�� 3+�� 3+� 3++� 7*� �2�� ���8� � � +� 3� 1++� 7*� �2�� ���8� � � +� 3� +� 3+	� 3+� 7*� �2� � � �� � � -+�� 3+� �+� 3� :M+�M�+�+�� 3� +� 3+� 7*� �2� � L� �� � � -+�� 3+� �+� 3� :N+�N�+�+�� 3� +� 3+� 7*� �2� � u� �� � � -+�� 3+� �+� 3� :O+�O�+�+�� 3� +� 3+� 7*� �2� � � �� � � -+�� 3+� �+� 3� :P+�P�+�+�� 3� +� 3+� 7*� �2� � � �� � � -+�� 3+� �+� 3� :Q+�Q�+�+�� 3� +� 3+� 3+!+� ^� d:R6S+� ^R� 2Y:T� "� hY� jYl� n!� rt� w� {� |�T:R6S+� ~�!R � �S� �+�� 3+"*� �	2� �� ��� �� � � ]+�� 3+�'*� �
2�* �� �� � � 3+�� 3+� 7*� �
2+�'*� �
2�* � E W+�� 3� � +� 3+,+� ^� d:U6V+� ^U� 2.Y:W� "� hY� jYl� n,� rt� w� {� |�W:U6V+� ~�,U � �V� �+�� 3+"*� �2� �� ��� �� � � ]+�� 3+�'*� �2�* �� �� � � 3+�� 3+� 7*� �2+�'*� �2�* � E W+�� 3� � +� 3+� 7*� �2+� 7*� �
2� � +� 7*� �2� � �H�2�5� E W+�� 3+� 7*� �2+� 7*� �
2� � +� 7*� �2� � �5� E W+�� 3+� 7*� �2+� 7*� �
2� � +� 7*� �2� � �2� E W+� 3+7+� ^� d:X6Y+� ^X� 1�Y:Z� "� hY� jYl� n7� rt� w� {� |�Z:X6Y+� ~�7X � �Y� �+�� 3+"*� �2� �� ��� �� � � Q+�� 3+�'�:�* �� �� � � ++�� 3+� 7�:+�'�:�* � E W+�� 3� � +� 3+� 7�:� � �� �� � � �+�� 3+� �+� ~��� �� �:[[<� �[+� 7� =� � � �[� �6\\� O+[\� �+>� 3[� ���� $:][]� �� :^\� +� �W[� �^�\� +� �W[� �[� �� ��� :_+� ~[�	_�+� ~[�	� :`+�`�+�+�� 3�!+� 7�:� � �� �� � �+�� 3+@+� 7�:� � �0�5�8� � � [+�� 3+� ~� ��:aaB�a�Wa�� ��� :b+� ~a�	b�+� ~a�	+�� 3� �+�� 3+� �+� ~��� �� �:ccD� �c+� 7� =� � � �c� �6dd� i+cd� �+F� 3++� 7�:� � �0�|+H� 3c� ���٧ $:ece� �� :fd� +� �Wc� �f�d� +� �Wc� �c� �� ��� :g+� ~c�	g�+� ~c�	� :h+�h�+�+�� 3+�� 3++� 7*� �2�� ���8� � � �+�� 3+� �+� ~��� �� �:ii<� �i+� 7� =� � � �i� �6jj� i+ij� �+J� 3++� 7�:� � �0�|+L� 3i� ���٧ $:kik� �� :lj� +� �Wi� �l�j� +� �Wi� �i� �� ��� :m+� ~i�	m�+� ~i�	� :n+�n�+�+� 3� ++� 7*� �2�� ���8� � � [+�� 3+� ~� ��:ooB�o�Wo�� ��� :p+� ~o�	p�+� ~o�	+�� 3� +�� 3� +N� 3+P� 3+� �+R� 3++� 7�:� � �0� 3+� 3� :q+�q�+�+T� 3+V� 3+X� 3+Z� 3+� 7*� �2� � � �� � � -+�� 3+� �+\� 3� :r+�r�+�+�� 3� +� 3+� 7*� �2� � L� �� � � -+�� 3+� �+^� 3� :s+�s�+�+�� 3� +� 3+� 7*� �2� � u� �� � � -+�� 3+� �+`� 3� :t+�t�+�+�� 3� +b� 3+d� 3+f+� ^� d:u6v+� ^u� 1�Y:w� "� hY� jYl� nf� rt� w� {� |�w:u6v+� ~�fu � �v� �+�� 3+ �*� �2� �� ��� �� � � ]+�� 3+� �*� �2� � �� �� � � 3+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +h� 3+� 7� �� � j� �� � ��+�� 3+ ��m� �� ���+�� 3+� �*� �2� � �0,�s:xx�x 6y+z�~:z6|�yz+x|�� ��W+�� 3+� 7*� �2� � ����A+�� 3+� �+�� 3+� 7*� �2+��Y+� 7*� �2� � S��� E W+�� 3+� �+� ~��� �� �:}}j� �}+� 7� =� � � �}� �6~~� m+}~� �+�� 3++� 7*� �2� � �0�|+~� 3}� ���է $:}� �� :�~� +� �W}� ���~� +� �W}� �}� �� ��� :�+� ~}�	��+� ~}�	� :�+���+�+�� 3� :�+���+�+�� 3� +�� 3�||y���+� 3+� 7*� �2�>� E W+�� 3+� �+�� 3+� ~� ��:���+� 7*� �
2� � �0�m��m+� 7*� �2� � �0�m��m+� 7�:� � �0�m��m�����W��� ��� :�+� ~��	��+� ~��	+�� 3� :�+���+�+�� 3� �+�� 3+� �+�� 3+� ~� ��:���+� 7*� �
2� � �0�m��m+� 7*� �2� � �0�m��m+� 7�:� � �0�m��m�����W��� ��� :�+� ~��	��+� ~��	+�� 3� :�+���+�+�� 3+�� 3� +�� 3+�� 3+� �+�� 3+� 7*� �2� � �8� � � �+�� 3++� 7*� �2� � �0� 3+�� 3++� 7*� �2� � �0� 3+�� 3++� 7�:� � �0� 3+�� 3++� 7� �� � �0� 3+�� 3++� 7*� �2� � �0� 3+�� 3� 
+�� 3+�� 3� :�+���+�+�� 3+� �+�� 3+� 7*� �2� � ++� 7*� �2�� ����� � �B+�� 3++� 7*� �2� � �0� 3+�� 3++� 7*� �2� � �0� 3+�� 3++� 7�:� � �0� 3+�� 3++� 7� �� � �0� 3+�� 3++� 7*� �2�� ��+� 7*� �2� � �2��+� 7*� �2� � ��� � � S+�� 3++��Y++� 7*� �2�� ��+� 7*� �2� � �2�H�5S���0� 3+�� 3� (+�� 3++� 7*� �2� � �0� 3+�� 3+�� 3� 
+ö 3+�� 3� :�+���+�+Ŷ 3++� 7*� �2�� ���8� � � �+�� 3+� �+Ƕ 3++� 7*� �
2� � �0� 3+ɶ 3++� 7*� �2� � �0� 3+˶ 3+++� 7*� �2�� ���0� 3+Ͷ 3� :�+���+�+�� 3� 	+�� 3+϶ 3+Ѷ 3+Ӷ 3++� 7*� �2�� ���8� � ��+ն 3+� �+׶ 3++� 7*� �
2� � �0� 3+�� 3++� 7*� �2� � �0� 3+�� 3++� 7�:� � �0� 3+�� 3� :�+���+�+ٶ 3+� �+<��:�+��6����� 6���� � � ��+� 7*� �
2� � �܎��6����� +� 7*� �2� � �܎��:�+� 7��� �d6���`���.������� � � � ����6�+� 3+� 7*� �2� � � �� � � A+� 3++� 7�� � �0� 3+� 3++� 7�� � �0� 3+� 3� c+� 7*� �2� � L� �� � � A+� 3++� 7�� � �0� 3+� 3++� 7�� � �0� 3+� 3� +�� 3++� 7*� �2� � �0� 3+�� 3++� 7� ƹ � �0� 3+�� 3��̧ ":������ W+� 7�� ���������� W+� 7�� ���� :�+���+�+�� 3� 
+�� 3+�� 3+ � 3+� �+� ~��� �� �:��� ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� ��� :�+� ~��	��+� ~��	� :�+���+�+�� 3++� 7*� �2�� ���8� � �=+� 3+� �+��:�+��6����� 6���� � � � �6����� ��:�+� 7��� �d6���`��� �������� � � � � e���6�+� 3++� 7�� � �0� 3+� 3++� 7*� �2� � �0� 3+� 3++� 7� ƹ � �0� 3+� 3��y� ":������ W+� 7�� ���������� W+� 7�� ���� :�+���+�+�� 3� 
+
� 3+� 3+� 3++� 7*� �2�� ���8� � � +� 3� 1++� 7*� �2�� ���8� � � +� 3� +� 3+� 3+� 7*� �2� � � �� � � -+�� 3+� �+� 3� :�+���+�+�� 3� +� 3+� 7*� �2� � L� �� � � -+�� 3+� �+� 3� :�+���+�+�� 3� +� 3+� 7*� �2� � � �� � � -+�� 3+� �+� 3� :�+���+�+�� 3� + � 3+"� 3+� 7� �� � $� �� � �1+&� 3+� �+� ~��� �� �:��(� ��+� 7� =� � � ��� �6��� O+��� �+*� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� ��� :�+� ~��	��+� ~��	� :�+���+�+,� 3+� �+� ~��� �� �:��.� ��+� 7� =� � � ��� �6��� O+��� �+0� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� ��� :�+� ~��	��+� ~��	� :�+���+�+2� 3+� �+� ~��� �� �:��4� ��+� 7� =� � � ��� �6��� O+��� �+6� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� ��� :�+� ~��	��+� ~��	� :�+���+�+8� 3+� �+� ~��� �� �:��:� ��+� 7� =� � � ��� �6��� O+��� �+<� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� ��� :�+� ~��	��+� ~��	� :�+�¿+�+>� 3+� �+� ~��� �� �:��@� ��+� 7� =� � � ��B��ö �6��� O+�Ķ �+D� 3ö ���� $:��Ŷ �� :��� +� �Wö �ƿ�� +� �Wö �ö �� ��� :�+� ~ö	ǿ+� ~ö	� :�+�ȿ+�+� 3+� �+� ~��� �� �:��F� ��+� 7� =� � � ��H��ɶ �6���B+�ʶ �+J� 3+� �+@��:�+��6��͹� 6�̹� � � � �6��̹� ��:�+� 7̹� �d6���`��� D�˶�͹� � � � � (˶�6�+++� 7*� �2� � �0�V�|���� ":���͹� W+� 7�� ˸�ӿ��͹� W+� 7�� ˸�� :�+�Կ+�+L� 3ɶ ��� � $:��ն �� :��� +� �Wɶ �ֿ�� +� �Wɶ �ɶ �� ��� :�+� ~ɶ	׿+� ~ɶ	� :�+�ؿ+�+� 3+� �+� ~��� �� �:��N� ��+� 7� =� � � �ٶ �6��� x+�ڶ �+P� 3+++� 7*� �2�� *� �2�S�0�|+~� 3ٶ ���ʧ $:��۶ �� :��� +� �Wٶ �ܿ�� +� �Wٶ �ٶ �� ��� :�+� ~ٶ	ݿ+� ~ٶ	� :�+�޿+�+� 3+� 7*� �2++� 7*� � 2�� *� �!2�S� E W+� 3+� �+� ~��� �� �:��U� ��+� 7� =� � � �߶ �6��� x+�� �+W� 3+++� 7*� �2�� *� �2�S�0�|+~� 3߶ ���ʧ $:��� �� :��� +� �W߶ ���� +� �W߶ �߶ �� ��� :�+� ~߶	�+� ~߶	� :�+��+�+Y� 3+� 7*� �"2�� E W+�� 3+4��:�+��6���� 6��� � � �"6���� ��:�+� 7�� �d6���`��� ������ � � � � ���6�+�� 3+� 7*� �"2+� 7*� �"2� � �0++� 7*� �#2�� *� �2�S�0�m+Z�`�m++� 7*� �#2�� *� �$2�S�0�m+a�`�m+c�`�m� E W+�� 3��B� ":����� W+� 7�� �������� W+� 7�� ��+f� 3+� ~hj� ��l:���o�p�s�u�x�+� 7*� �"2� � �{��~�W��� ��� :�+� ~�	�+� ~�	+�� 3+� 7*� �%2�� E W+�� 3+4��:�+��6���� 6��� � � � �6���� ��:�+� 7�� �d6���`��� ������ � � � � g��6�+�� 3+� 7*� �%2+� 7*� �%2� � �0++� 7*� �#2�� *� �2�S�0�m+c�`�m� E W+�� 3��w� ":����� W+� 7�� �������� W+� 7�� ��+�� 3+� ~hj� ��l:���o�p�s���x�+� 7*� �%2� � �0+c�`�m�{��~��W���� ��� :�+� ~��	��+� ~��	+�� 3+� 7*� �&2�� E W+�� 3+:��:�+��6����� 6���� � � � �6����� ��:�+� 7��� �d�6��`��� �������� � � � � i����6+�� 3+� 7*� �&2+� 7*� �&2� � �0++� 7*� �'2�� *� �2�S�0�m+c�`�m� E W+�� 3��s� &�:����� W+� 7�� ���������� W+� 7�� ���+�� 3+� ~hj� ��l�:��o�p�s���x�+� 7*� �&2� � �0+c�`�m�{��~��W���� ��� �:+� ~��	��+� ~��	+�� 3+� ~hj� ��l�:��o�p�s��+� 7*� �2� � �0�m��m�x���{��~��W���� ��� �:+� ~��	��+� ~��	+�� 3+� ~��� ����:������+� 7*� �2� � �0�m��m����������6	�	� F+��	� �+�� 3������ �:
�	� +� �W�
��	� +� �W���� ��� �:+� ~��	��+� ~��	+�� 3+� ~��� ����:��+� 7*� �2� � �0�m��m������������������6�� F+��� �+�� 3������ �:�� +� �W���� +� �W���� ��� �:+� ~��	��+� ~��	+�� 3+� ~hj� ��l�:��o�j�s��+� 7*� �2� � �0�m��m�x��W���� ��� �:+� ~��	��+� ~��	+�� 3+� ~��� ����:��������������������6�� F+��� �+�� 3������ �:�� +� �W���� +� �W���� ��� �:+� ~��	��+� ~��	+¶ 3+� ~��� ����:�������������Ķ�����6�� F+��� �+�� 3������ �:�� +� �W���� +� �W���� ��� �:+� ~��	��+� ~��	+ƶ 3+� �+� ~��� �� ��:�ȶ ��+� 7� =� � � ��� ��6�� g+��� �+ʶ 3�� ���� 2�:��� ��  �:�� +� �W�� ����� +� �W�� ��� �� ��� �:+� ~��	��+� ~��	� �:+���+�+̶ 3+� ~� ���: � ζ� �� �W� �� ��� �:!+� ~� �	�!�+� ~� �	+�� 3� +ж 3+Ҷ 3+� �+� ~��� �� ��:"�"Զ ��"+� 7� =� � � ��"� ��6#�#� g+�"�#� �+ֶ 3�"� ���� 2�:$�"�$� ��  �:%�#� +� �W�"� ��%��#� +� �W�"� ��"� �� ��� �:&+� ~�"�	�&�+� ~�"�	� �:'+��'�+�+�� 3++� 7*� �(2�� ���8� � � +ض 3� 
+ڶ 3+ܶ 3+޶ 3+� 7*� �)2� � � �� � � 1+�� 3+� �+� 3� �:(+��(�+�+�� 3� +� 3+� 3+� 7*� �*2++���� E W+�� 3+� �+� ~��� �� ��:)�)� ��)+� 7� =� � � ��)� ��6*�*� g+�)�*� �+�� 3�)� ���� 2�:+�)�+� ��  �:,�*� +� �W�)� ��,��*� +� �W�)� ��)� �� ��� �:-+� ~�)�	�-�+� ~�)�	� �:.+��.�+�+�� 3+� �+� ~��� �� ��:/�/�� ��/+� 7� =� � � ��/� ��60�0� g+�/�0� �+�� 3�/� ���� 2�:1�/�1� ��  �:2�0� +� �W�/� ��2��0� +� �W�/� ��/� �� ��� �:3+� ~�/�	�3�+� ~�/�	� �:4+��4�+�+�� 3+� �+�� 3++��*� �+2� �0� 3+� 3+++� 7*� �,2�� ��S�0� 3+� 3+++� 7*� �-2�� ��S�0� 3+
� 3++� 7*� �*2� � �0� 3+� 3� �:5+��5�+�+� 3� ���� )���  S��  B��  99  ��� )���  �  �00  V{{  +X[ )+dg  ���  ���  A�� )A��  ��  ���  ���  ���  BLL  lvv  �� )�  �DD  �^^  �||  ���  y��  ���  ''  oyy  ���  ��� )���  �  y''  ���  'QT )']`  ���  ���  6`c )6lo  ��  ���  22  m��  ���  9CC  ���  ��� )���  �55  �OO  Gee  � > >  � _ _   �!!   !.!.  !\"*"*  "B#�#�  $$t$t  $�%4%4  %�' '   %L'<'<  '�'�'� )'�'�'�  '}( (   'l((  (�)8)8  (\)t)t  *6*@*@  *�*�*�  *�*�*�  +r+�+� )+r+�+�  +D+�+�  +3+�+�  ,8,H,K ),8,T,W  ,
,�,�  +�,�,�  ,�-- ),�--  ,�-S-S  ,�-m-m  -�-�-� )-�-�-�  -�..  -�.3.3  .�.�.� ).�.�.�  .\.�.�  .K//  /�0
0
  /k0F0F  /`0c0f )/`0o0r  /*0�0�  /0�0�  11R1U )11^1a  0�1�1�  0�1�1�  2;2t2w )2;2�2�  22�2�  1�2�2�  3O44  4f4�4�  545�5�  66k6k  6�7�7�  7�8B8B  8}8�8�  9v9�9�  99�9�  :^:r:r  9�:�:�  :�;6;6  ;�;�;�  ;q<<  <�<�<�  <=<�<�  =G=Y=\ )=G=k=n  ==�=�  <�=�=�  >>.>.  >�>�>� )>�>�>�  >{?"?"  >h?D?D  ?�?�?�  @q@�@� )@q@�@�  @5@�@�  @"@�@�  AhAzA} )AhA�A�  A,A�A�  AA�A�  BB�B�   {         * +  |  f�           @  A ! k $ � - � 0 � 9 � < � ? � B � E � H � K � � � �g �� �+ �� �� �� �� �� �a �� �� �� �� �8 ���;�	�
T{�@�����2 K!T"m#�$�%�&�'�(�-	/	L0	e1	3	�5	�6
8
#9
<:
g;
�<
�>
�?
�A
�B
�DE7FbG{H�J�K�M�N�P�Q�S�T�V�X/YLZ�\�^Ebc�e(fAg[iajelkmooupy{��������������������������;�F�Y�\�e�p��������������	�
��n��"y���� �/�0�567:8@9GKKLNMrN}O�P�Q�S�T�U�V�W�YZ![4\7]A_h`sa�b�c�f�g�h�i�j�m����R�z�������;�c���������8�s��� �#�B�O�r���7�]�������+�E�������:�T�����L�U�_�b�f�i�������� �� 
2=P	S
]������,�-�67D8k9�:�=�>�?!@@AJB|C�D�E_FuG~H�?�H�J�K�L YM oN xO �P!(Q!>R!DS!NU!Qa!_b!�c"e"g"$h">t"Eu"v#?w#�x#�y#�z#�{#�}#�~#��$�$�$��$��$��$��$��$��$��%E�%H�%��%��&"�&%�&V�&\�&��&��&��&��&��&��&��&��'M�'P'W'Z'a''h+'�-(*.(U/(X0(�1)52)�3)�4)�5)�6)�E)�F)�J)�K)�L)�M)�N*`*a*
b*/c*:d*Me*Pf*Zh*�i*�j*�k*�l*�n*�o*�p*�q*�r+ s+�+
�+,�+/�+v�+��+��,<�,��,��-�-~�-��-��.D�.G�.��/�/d�0W�0��1�1F�1��1��2?�2h�2��2��2��3��4
�4P�4S�4��4��4��5f�5��6 �6�6��6��6��7)�7}�7��7��8e�8h�8��8��9�9�9�9�9+�9Q�9y�9��9��:%�:/�:9�:a�:��:��:��:��;U�;U�;Y�;\�;�;��;��;��<%�<(�<K�<U�<_�<��<��<��=K�=��=��>P�>Z>]>a>d>�?X?�?�?�?�?�0?�1?�2?�3?�4?�5?�6?�<?�S?�W@X@uZA[Al]B	^B_B�`}     )  z        �    }     )  z         �    }     )  z        �    }        z  �    �*.� �Y!�'SYθ'SY)�'SY+�'SY-�'SY/�'SY1�'SY3�'SY5�'SY	!�'SY
7�'SY,�'SY9�'SY;�'SY=�'SY?�'SY7�'SYA�'SYC�'SYf�'SYE�'SYG�'SYI�'SYK�'SYM�'SYO�'SYQ�'SYS�'SYU�'SYW�'SYY�'SY[�'SY ]�'SY!_�'SY"a�'SY#c�'SY$e�'SY%g�'SY&i�'SY'k�'SY(m�'SY)o�'SY*q�'SY+s�'SY,u�'SY-w�'S� ʱ     ~    