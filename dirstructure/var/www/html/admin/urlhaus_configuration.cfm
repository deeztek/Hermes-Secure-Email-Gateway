����   2 (proprietary/urlhaus_configuration_cfm$cf  lucee/runtime/PageImpl  ./compile/proprietary/urlhaus_configuration.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  o��ŷ getSourceLength      � getCompileTime  v�	�q getHash ()Ia�#� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this *Lproprietary/urlhaus_configuration_cfm$cf;
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Urlhaus Configuration</title>
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
 F,</head>
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
              <td height="131" width="988">
                 H<table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion32" style="background-image: url('./top_blue_3.png'); height: 131px;">
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
                    </td>
                  </tr>
                 J �</table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="679" width="988"> L@       keys $[Llucee/runtime/type/Collection$Key; P Q	  R !lucee/runtime/type/Collection$Key T *lucee/runtime/functions/decision/IsDefined V B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & X
 W Y 
 [ sessionScope $()Llucee/runtime/type/scope/Session; ] ^
 / _  lucee/runtime/type/scope/Session a get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; c d b e 	VIOLATION g lucee/runtime/op/Operator i compare '(Ljava/lang/Object;Ljava/lang/String;)I k l
 j m lucee/runtime/PageContextImpl o lucee.runtime.tag.Location q 
cflocation s use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; u v
 p w lucee/runtime/tag/Location y license_invalid.cfm { setUrl } 1
 z ~ setAddtoken (Z)V � �
 z � 
doStartTag � $
 z � doEndTag � $
 z � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 p � NEW �
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion30" style="background-image: url('./middle_988.png'); height: 679px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="976">
                        <tr valign="top" align="left">
                          <td width="8" height="13"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="454"></td>
                          <td width="1"></td>
                          <td width="4"></td>
                          <td width="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="2" width="506" id="Text291" class="TextObject">
                             ��<p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Urlhaus Feed Configuration</span></b></p>
                          </td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="8" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="4" width="961" id="Text454" class="TextObject">
                            <p><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">URLhaus is a project from abuse.ch with the goal of sharing malicious URLs that are being used for malware distribution <a href="https://urlhaus.abuse.ch/">https://urlhaus.abuse.ch/</a></span></p>
                            <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">It&#8217;s recommended that you enable Urlhaus feed in order to improve malware detection. Additionally, enable and disable Urlhaus databases below as needed. The databased marked as LOW False Positive Risk are the safest ones to enable.&nbsp;  ��</span></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="8" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="2" valign="middle" width="959"><hr id="HRRule1" width="959" size="1"></td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="8" height="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="283"></td>
                          <td colspan="4" width="964"> � m � &lucee/runtime/config/NullSupportHelper � NULL � '
 � � -lucee/runtime/interpreter/VariableInterpreter � getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; � �
 � � 0 � %lucee/runtime/exp/ExpressionException � java/lang/StringBuilder � The required parameter [ �  1
 � � append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; � �
 � � ] was not provided. � -(Ljava/lang/String;)Ljava/lang/StringBuilder; � �
 � � toString ()Ljava/lang/String; � �
 � �
 � � any ��       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 p �  
 � step � 

 � action �   �  

 � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � lucee/runtime/tag/Query � getunapplied � setName � 1
 � � A e setDatasource (Ljava/lang/Object;)V � �
 � �
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � =
select applied from malware_databases where applied = '2'
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � �
 � � 	outputEnd � 
 / � getCollection d A #lucee/runtime/util/VariableUtilImpl recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;
 (Ljava/lang/Object;D)I k

 j _M ;	 9 #lucee/commons/color/ConstantsDouble _9 Ljava/lang/Double;	@       _action ;	 9 True (ZLjava/lang/String;)I k
 j 	formScope !()Llucee/runtime/type/scope/Form; !
 /" _ACTION$ ;	 9% lucee/runtime/type/scope/Form'( e 


* 
geturlhaus, B
select name, enabled from malware_feeds where name = 'urlhaus'
. 



0 urlhaus2 I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; c4
 /5 Save Settings7 


<!--
9 

ACTION: ; lucee/runtime/op/Caster= &(Ljava/lang/Object;)Ljava/lang/String; �?
>@ <br>
B  lucee/runtime/type/util/ListUtilD listToArrayRemoveEmpty /(Ljava/lang/String;C)Llucee/runtime/type/Array;FG
EH lucee/runtime/type/ArrayJ sizeL $KM thefieldO getVariableReference Y(Llucee/runtime/PageContext;Ljava/lang/String;)Llucee/runtime/type/ref/VariableReference;QR
 �S getE (I)Ljava/lang/Object;UVKW (lucee/runtime/type/ref/VariableReferenceY B
Z[ cbox] ct '(Ljava/lang/Object;Ljava/lang/Object;)Z_`
 ja 
CHECKBOX:c lucee/runtime/type/KeyImple init 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;gh
fi@        _m &lucee/runtime/functions/list/ListGetAto T(Llucee/runtime/PageContext;Ljava/lang/String;DLjava/lang/String;)Ljava/lang/String; &q
pr 	
TheID: t <br>

v 

-->

x updateurlhausz &
update malware_feeds set enabled = '| writePSQ~ �
 / ' where name = 'urlhaus'
� setdatabasesfalse� H
update malware_databases set active = 'false' where feed = 'urlhaus'
� 8

<!-- START ROUTINE TO ENABLE/DISABLE DATABASES -->
� updatedatabases� ;
update malware_databases set active = 'true' where id = '� ' and feed = 'urlhaus'
� g

<!-- STOP ROUTINE TO ENABLE/DISABLE DATABASES -->

<!-- START ROUTINE TO DELETE DATABASES -->

� 
cboxdelete� 	getdbname� /
select db from malware_databases where id = '� [/]� %lucee/runtime/functions/string/REFind� S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object; &�
�� /� #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� /var/lib/clamav/� java/lang/String� concat &(Ljava/lang/String;)Ljava/lang/String;��
�� 'lucee/runtime/functions/file/FileExists� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &�
�� lucee.runtime.tag.FileTag� cffile� lucee/runtime/tag/FileTag� hasBody� �
�� delete� 	setAction� 1
�� setFile� 1
��
� �
� � ,
delete from malware_databases where id = '� lucee.runtime.tag.Execute� 	cfexecute� lucee/runtime/tag/Execute� /etc/init.d/clamav-daemon�
� � force-reload� setArguments� �
��@n       
setTimeout (D)V��
�� 	/dev/null� setOutputfile� 1
��
� �
� �
� � 5



<!-- STOP ROUTINE TO DELETE DATABASES -->

� update_feeds_databases.cfm� 	doInclude (Ljava/lang/String;Z)V��
 /� 


<!-- /CFIF action-->
��

<table border="0" cellspacing="0" cellpadding="0" width="635" id="LayoutRegion11" style="background-image: url('file:///C:/Users/dino.edwards/Dropbox/graphics/hermes/background_635_middle.png'); height: 330px;" </readonly>

                            <table border="0" cellspacing="0" cellpadding="0" width="964" id="LayoutRegion11" style="height: 283px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion11FORM" action="" method="post">
                                    <input type="hidden" name="action" value="Save Settings">
                                    <table border="0" cellspacing="0" cellpadding="0" width="964">
                                      <tr valign="top" align="left">
                                        <td width="964" id="Text185" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;">� 1�h
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Secure Portal Address cannot be blank</span></i></b></p>
� 2�y
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PDF Reply Sender E-mail must be a valid e-mail address</span></i></b></p>
� 3�l
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the PDF Reply Sender E-mail must not be blank</span></i></b></p>
� 4�}
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;the Encryption by e-mail subject keyword field cannot be blank</span></i></b></p>
� 5��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must be a valid e-mail address</span></i></b></p>
 6s
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;The Postmaster E-mail Address must must not be blank</span></i></b></p>
 7�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Settings Applied. If any databases were added or deleted the changes will not take effect until the next scheduled database update. Database updates times vary. </span></i></b></p>
	 8�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;An error occured while setting up user.conf file. Please contact support for assistance</span></i></b></p>
 9�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon1" title="warning_icon1">&nbsp;There are unapplied changes in the Malware Databases. Please click on the Apply Settings button on the bottom of this page.</span></i></b></p>
J

&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="3"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="964"><form name="edit" action="encryption_settings.cfm" method="post">
                                          <table id="Table70" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 41px;">
                                            <tr style="height: 14px;">
                                              <td width="960" id="Cell469">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Urlhaus FeedC</span></b></p>
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
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                 z<td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"> yes h
<input type="radio" checked="checked" name="urlhaus" value="yes" style="height: 13px; width: 13px;">
 no V
<input type="radio" name="urlhaus" value="yes" style="height: 13px; width: 13px;">
S






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
                                                              ! �<tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"># U
<input type="radio" name="urlhaus" value="no" style="height: 13px; width: 13px;">
% g
<input type="radio" checked="checked" name="urlhaus" value="no" style="height: 13px; width: 13px;">
'0






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell473">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            )!</tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1032">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"></span>&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1031">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                          

</form></td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="964">
                                      +<tr valign="top" align="left">
                                        <td width="2" height="3"></td>
                                        <td width="504"></td>
                                        <td width="455"></td>
                                        <td width="3"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="2" width="506" id="Text482" class="TextObject">
                                          <p style="margin-bottom: 0px;"><b><span style="font-size: 12px; color: rgb(0,51,153);">Urlhaus Databases</span></b></p>
                                        </td>
                                        <td colspan="2"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="4" height="2"></td>
                                      </tr>
                                      -<tr valign="top" align="left">
                                        <td height="30" colspan="4" valign="middle" width="964"><hr id="HRRule32" width="964" size="1"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="4" height="3"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td></td>
                                        <td colspan="2" width="959" id="Text522" class="TextObject">
                                          <p style="text-align: center; margin-bottom: 0px;"><form name="adddatabase" action="add_signature_database.cfm" method="post">
 <input type="hidden" name="feed" value="urlhaus"> 


  <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        /<table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Add Sanesecurity Database" style="height: 24px; width: 357px;">


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

&nbsp;</p>
                                        </td>
                                        <td></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="4" height="4"></td>
                                      1�</tr>
                                      <tr valign="top" align="left">
                                        <td height="30" colspan="4" valign="middle" width="964"><hr id="HRRule31" width="964" size="1"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="4" height="8"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="4" width="964" id="Text521" class="TextObject">
                                          <p style="margin-bottom: 0px;">3 getfp5 N
select distinct(fp) as thefp from malware_databases where feed = 'urlhaus'
7 checkdatabases9 :
select * from malware_databases where feed = 'urlhaus'
; �
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; color: rgb(255,0,0);  font-size: 12px;">No Databases found...</span></i></b></p>

=<

<table id="Table71" border="0" cellspacing="4" cellpadding="0" width="100%" style="height: 17px;" class="bottomBorder">
  <tr style="height: 14px;">
    
<td width="112" style="background-color: rgb(241,236,236);" id="Cell402">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Enabled</span></b></p>
    </td>

    <td width="48" style="background-color: rgb(241,236,236);" id="Cell764">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Database Name</span></b></p>
    </td>
    <td width="109" style="background-color: rgb(241,236,236);" id="Cell416">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Description</span></b></p>
    </td>
    
    <td width="193" style="background-color: rgb(241,236,236);" id="Cell403">
      ?�<p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">False Positive Risk</span></b></p>
    </td>

<td width="193" style="background-color: rgb(241,236,236);" id="Cell403">
      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Delete (Check to Delete)</span></b></p>
    </td>



  </tr>

A getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;CD
 /E getIdG $
 /H lucee/runtime/type/QueryJ getCurrentrow (I)ILMKN getRecordcountP $KQ !lucee/runtime/util/NumberIteratorS load '(II)Llucee/runtime/util/NumberIterator;UV
TW addQuery (Llucee/runtime/type/Query;)VYZ A[ isValid (I)Z]^
T_ currenta $
Tb go (II)ZdeKf getdatabasesh C
select * from malware_databases where feed = 'urlhaus' and fp = 'j ' order by db asc
l "
  <tr style="height: 19px;">

n truep :

<td align="center">
<input type="checkbox" name="cboxr _IDt ;	 9u " value="cbox_w B" checked="checked" style="height: 13px; width: 13px;">
</td>

y false{ 0" style="height: 13px; width: 13px;">
</td>

} �


    <td id="Cell406">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);"> �</span></p>
    </td>

    <td id="Cell407">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">� </span></p>
    </td>
   
� low� �
<td id="Cell408" style="background-color: rgb(0,255,0);">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(0,0,0);">LOW</span></p>
    </td>

� medium� �
<td id="Cell408" style="background-color: rgb(255,255,0);">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(0,0,0);">MEDIUM</span></p>
    </td>

� high� �
<td id="Cell408" style="background-color: rgb(255,0,0);">
      <p style="text-align: center; margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(0,0,0);">HIGH</span></p>
    </td>

� @

<td align="center">
<input type="checkbox" name="cboxdelete� " value="cboxdelete_� ?" style="height: 13px; width: 13px;">
</td>
    

  </tr>
� removeQuery�  A� release &(Llucee/runtime/util/NumberIterator;)V��
T� 
</table>
�&nbsp;</p>
                                        </td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="4" height="8"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td colspan="4" width="964" id="Text385" class="TextObject">
                                          <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please Wait...';this.form.submit();" value="Apply Settings" style="height: 24px; width: 200px;">
&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </form>
                                </td>
                              </tr>
                            </table>
                          �O</td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="8" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="7" valign="middle" width="968"><hr id="HRRule30" width="968" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="8" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="42" colspan="5" width="969">

                            <table border="0" cellspacing="0" cellpadding="0" width="969" id="LayoutRegion18" style="height: 42px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    �2<tr valign="top" align="left">
                                      <td width="969">
                                        <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 28px;">
                                          <tr style="height: 28px;">
                                            <td width="969" id="Cell1025">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="302" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="text-align: center; margin-bottom: 0px;"><form name="antivirussignfeeds" action="antivirus_signature_feeds.cfm" method="post">
  


  �<table id="Table90" border="0" cellspacing="0" cellpadding="0" width="635" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;">
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Antivirus Signature Feeds" style="height: 24px; width: 357px;">


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

&nbsp;</p>
                                                        </td>
                                                      �#</tr>
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
                            </table>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
                
            
</readonly>

            
            </td>
            </tr>
            <tr valign="top" align="left">
              <td height="49" width="988">
                ��<table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion24" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="981">
                        <tr valign="top" align="left">
                          <td width="981" height="12"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;">� $lucee/runtime/functions/dateTime/Now� =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &�
�� yyyy� 4lucee/runtime/functions/displayFormatting/DateFormat� S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &�
�� 
getversion� D
SELECT value from system_settings where parameter = 'version_no'
� getbuild� B
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
 � license� intern�h
f� LICENSE� GETUNAPPLIED� 
GETURLHAUS� ENABLED� URLHAUS� 
FIELDNAMES� THEFIELD� THEID� THEDELETEID� THEDB� 	GETDBNAME� DB� THEDB2� CHECKDATABASES� THEFP ACTIVE DESCRIPTION FP THEYEAR	 EDITION 
GETVERSION GETBUILD subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             P Q             *     *� 
*� *� � *�ص�*+�߱                 �                � �                 �                 �                  !�      # $         %�      & '   "l  �  J+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+ N*� S2� U� Z� �+\� 3+� `*� S2� f h� n� � � U+\� 3+� prt� x� zM,|� ,� �,� �W,� �� � ��� N+� p,� �-�+� p,� �+\� 3� ~+� `*� S2� f �� n� � � ^+\� 3+� prt� x� z:|� � �� �W� �� � ��� :+� p� ��+� p� �+\� 3� +\� 3� +�� 3+�� 3+�� 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� ��� ��� �� �� ��:6+� p�� � �� �+ʶ 3+�+� �� �:	6
+� �	� 0�Y:� !� �Y� �Y�� �̶ ��� �� �� ��:	6
+� p��	 � �
� �+ζ 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� �ж ��� �� �� ��:6+� p�� � �� �+Զ 3+� �+� p��� x� �:߶ �+� 7� =� � � �� �6� N+� �+� 3� ����� $:� �� :� +� �W� ��� +� �W� �� �� � ��� :+� p� ��+� p� �� :+� �+� +ζ 3++� 7*� S2� �	�� � � "+\� 3+� 7��� E W+\� 3� +ζ 3+�� U� Z�� � � Q+\� 3+�#�&�) Ҹ n� � � ++\� 3+� 7�&+�#�&�) � E W+\� 3� � ++� 3+� �+� p��� x� �:-� �+� 7� =� � � �� �6� O+� �+/� 3� ���� $:� �� :� +� �W� ��� +� �W� �� �� � ��� :+� p� ��+� p� �� :+� �+� +1� 3+3+� �� �:6+� �� H++� 7*� S2� *� S2�6Y:� "� �Y� �Y�� �3� ��� �� �� ��:6+� p�3 � �� �+ʶ 3+*� S2� U� Z�� � � 3+\� 3+� 7*� S2+�#*� S2�) � E W+\� 3� ++� 3+� 7�&� � 8� n� � �	�+:� 3+� �+<� 3++�#�&�) �A� 3+C� 3� :+� �+� +\� 3+�#*� S2�) �A,�I:�N 6 +P�T:!6#� �!+#�X �\W+\� 3+� 7*� S2� � ^�b� �+\� 3+� �+d� 3++� 7*� S2� � �A� 3+C� 3+� 7*� S	2++�#+� 7*� S2� � �A�j�) �Akn�s� E W+u� 3++� 7*� S	2� � �A� 3+w� 3� :$+� $�+� +\� 3� +\� 3�## ��+y� 3+� �+� p��� x� �:%%{� �%+� 7� =� � � �%� �6&&� m+%&� �+}� 3++� 7*� S2� � �A��+�� 3%� ���է $:'%'� �� :(&� +� �W%� �(�&� +� �W%� �%� �� � ��� :)+� p%� �)�+� p%� �� :*+� *�+� ++� 3+� �+� p��� x� �:++�� �++� 7� =� � � �+� �6,,� O++,� �+�� 3+� ���� $:-+-� �� :.,� +� �W+� �.�,� +� �W+� �+� �� � ��� :/+� p+� �/�+� p+� �� :0+� 0�+� +�� 3+�#*� S2�) �A,�I:11�N 62+P�T:365��3+15�X �\W+\� 3+� 7*� S2� � ^�b�R+\� 3+� �+\� 3+� 7*� S	2++�#+� 7*� S2� � �A�j�) �Akn�s� E W+ζ 3+� �+� p��� x� �:66�� �6+� 7� =� � � �6� �677� m+67� �+�� 3++� 7*� S	2� � �A��+�� 36� ���է $:868� �� :97� +� �W6� �9�7� +� �W6� �6� �� � ��� ::+� p6� �:�+� p6� �� :;+� ;�+� +ζ 3� :<+� <�+� +\� 3� +\� 3�552��u+�� 3+�#*� S2�) �A,�I:==�N 6>+P�T:?6A��?+=A�X �\W+\� 3+� 7*� S2� � ��b��+\� 3+� �+\� 3+� 7*� S
2++�#+� 7*� S2� � �A�j�) �Akn�s� E W+ζ 3+� �+� p��� x� �:BB�� �B+� 7� =� � � �B� �6CC� m+BC� �+�� 3++� 7*� S
2� � �A��+�� 3B� ���է $:DBD� �� :EC� +� �WB� �E�C� +� �WB� �B� �� � ��� :F+� pB� �F�+� pB� �� :G+� G�+� +ζ 3+� 7*� S2++� 7*� S2� *� S2�6� E W+ζ 3+�+� 7*� S2� � �A���� � � D+ζ 3+� 7*� S2+++� 7*� S2� � �Ak��s��� E W+ζ 3� 0+ζ 3+� 7*� S2+� 7*� S2� � � E W+ζ 3+ζ 3+�+� 7*� S2� � �A����� +ζ 3+� p��� x��:HH��H���H�+� 7*� S2� � �A����H��WH��� � ��� :I+� pH� �I�+� pH� �+\� 3� +ζ 3+� �+� p��� x� �:JJ�� �J+� 7� =� � � �J� �6KK� m+JK� �+ƶ 3++� 7*� S
2� � �A��+�� 3J� ���է $:LJL� �� :MK� +� �WJ� �M�K� +� �WJ� �J� �� � ��� :N+� pJ� �N�+� pJ� �� :O+� O�+� +ζ 3� :P+� P�+� +\� 3� +\� 3�AA>�� +ζ 3+� p��� x��:QQζ�QѶ�Qն�Qܶ�Q��6RR� 8+QR� �+\� 3Q������ :SR� +� �WS�R� +� �WQ��� � ��� :T+� pQ� �T�+� pQ� �+� 3+���+� 3� +� 3+� 7�� � � n� � � -+\� 3+� �+� 3� :U+� U�+� +\� 3� +ζ 3+� 7�� � �� n� � � -+\� 3+� �+�� 3� :V+� V�+� +\� 3� +ζ 3+� 7�� � �� n� � � -+\� 3+� �+�� 3� :W+� W�+� +\� 3� +ζ 3+� 7�� � �� n� � � -+\� 3+� �+�� 3� :X+� X�+� +\� 3� +ζ 3+� 7�� �  � n� � � -+\� 3+� �+� 3� :Y+� Y�+� +\� 3� ++� 3+� 7�� � � n� � � -+\� 3+� �+� 3� :Z+� Z�+� +\� 3� +ζ 3+� 7�� � � n� � � -+\� 3+� �+
� 3� :[+� [�+� +\� 3� +ζ 3+� 7�� � � n� � � -+\� 3+� �+� 3� :\+� \�+� +\� 3� +ζ 3+� 7�� � � n� � � -+\� 3+� �+� 3� :]+� ]�+� +\� 3� +� 3+� 3+� 3+� 7*� S2� � � n� � � -+\� 3+� �+� 3� :^+� ^�+� +\� 3� O+� 7*� S2� � � n� � � -+\� 3+� �+ � 3� :_+� _�+� +\� 3� +"� 3+$� 3+� 7*� S2� � � n� � � -+\� 3+� �+&� 3� :`+� `�+� +\� 3� O+� 7*� S2� � � n� � � -+\� 3+� �+(� 3� :a+� a�+� +\� 3� +*� 3+,� 3+.� 3+0� 3+2� 3+4� 3+� �+� p��� x� �:bb6� �b+� 7� =� � � �b� �6cc� O+bc� �+8� 3b� ���� $:dbd� �� :ec� +� �Wb� �e�c� +� �Wb� �b� �� � ��� :f+� pb� �f�+� pb� �� :g+� g�+� +ζ 3+� �+� p��� x� �:hh:� �h+� 7� =� � � �h� �6ii� O+hi� �+<� 3h� ���� $:jhj� �� :ki� +� �Wh� �k�i� +� �Wh� �h� �� � ��� :l+� ph� �l�+� ph� �� :m+� m�+� +1� 3++� 7*� S2� �	�� � � +>� 3��++� 7*� S2� �	�� � �a+@� 3+B� 3+6�F:o+�I6pop�O 6qo�R � � �6rro�R �X:n+� 7o�\ rd6unu`�`��on�cp�g � � � ��n�c6u+ζ 3+� �+� p��� x� �:vvi� �v+� 7� =� � � �v� �6ww� m+vw� �+k� 3++� 7*� S2� � �A��+m� 3v� ���է $:xvx� �� :yw� +� �Wv� �y�w� +� �Wv� �v� �� � ��� :z+� pv� �z�+� pv� �� :{+� {�+� +ζ 3+� �+i�F:}+�I6~}~�O 6}�R � � �\6��}�R �X:|+� 7}�\ �d6�|�`�`��}|�c~�g � � � ��|�c6�+o� 3+� 7*� S2� � q� n� � � A+s� 3++� 7�v� � �A� 3+x� 3++� 7�v� � �A� 3+z� 3� c+� 7*� S2� � |� n� � � A+s� 3++� 7�v� � �A� 3+x� 3++� 7�v� � �A� 3+~� 3� +�� 3++� 7*� S2� � �A� 3+�� 3++� 7*� S2� � �A� 3+�� 3+� 7*� S2� � �� n� � � +�� 3� [+� 7*� S2� � �� n� � � +�� 3� /+� 7*� S2� � �� n� � � +�� 3� +�� 3++� 7�v� � �A� 3+�� 3++� 7�v� � �A� 3+�� 3��� ":�}~�g W+� 7�� |����}~�g W+� 7�� |��� :�+� ��+� +\� 3��H� ":�oqp�g W+� 7�� n����oqp�g W+� 7�� n��+�� 3� +�� 3+�� 3+�� 3+�� 3+�� 3+�� 3+� 7*� S2++������ E W+\� 3+� �+� p��� x� �:���� ��+� 7� =� � � ��� �6��� O+��� �+�� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� p�� ���+� p�� �� :�+� ��+� +\� 3+� �+� p��� x� �:���� ��+� 7� =� � � ��� �6��� O+��� �+�� 3�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � ��� :�+� p�� ���+� p�� �� :�+� ��+� +\� 3+� �+�� 3++� `*� S2� f �A� 3+ö 3+++� 7*� S2� �ƶ6�A� 3+ȶ 3+++� 7*� S2� �ƶ6�A� 3+ʶ 3++� 7*� S2� � �A� 3+̶ 3� :�+� ��+� +ζ 3� J | � �   �  ��� )���  �

  x$$  6FI )6RU  ��  ���  ���  Y��  S�� )S��  %��  ��  7GJ )7SV  	��  ���  	�	�	� )	�	�	�  	�
$
$  	r
>
>  	%
T
T  x�� )x��  J��  9  !dd  ��� )�
  �@@  �ZZ  
�pp  ���  �""  ���  ���  ''  kuu  ���    V``  ���  ���  S]]  ���  �  EOO  ��� )���  �''  �AA  ��� )���  i��  X  Aor )A{~  ��  ��  422  �nn  ���  Yil )Yux  +��  ��  .1 ):=  �ss  ���  �44            * +    � �   
       ! F $ G - Y C Z i [ � \ � ]- ^6 _? `B qN �� � �q �� �4 �] �s �| �� �� �� �� �: �� �2 �Z �� �� �� �� �� �� �� �3 �R �] �{ �� �� �� �� � �	 � �W �u �� �; �� �� �� �	 �	( �	k �	� �	� �
N �
d �
m �
s �
z �
~ �
� �
� �
� �
� �2 �| �� � �G �w �� �� �� �� � �) �1 �{ �{ �~ �� �� �� �j �� �� �� �� �� �� �� ��=@LRVYz������ �!�"�$%!&4'7(@*d+o,�-�.�0�1�2�3�4�789:";+=O>Z?m@pAyC�D�E�F�G�I�J�K	LMO i$jLkWljmmn�o�p�q�r�y������������>�I�\�_�i�s�w�z�~���������Q�BH
psz&�(E)c*�,g-j/�1�2�3�5�7�8$9*;.>1?OCmF�G�K�L�P�Q�U�W�X)Y/]~^�_�`���������������]���"�����     ) ��         �         ) ��          �         ) ��         �        �            �*� UY��SY��SY��SY��SY��SY3��SY��SY��SY��SY	���SY
���SY���SY���SY���SY���SY ��SY��SY��SY��SY��SY
��SY��SY��SY��S� S�         