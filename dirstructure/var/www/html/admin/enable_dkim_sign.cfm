����   2 #proprietary/enable_dkim_sign_cfm$cf  lucee/runtime/PageImpl  )/compile/proprietary/enable_dkim_sign.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�
  getSourceLength      {2 getCompileTime  p��^ getHash ()I#*� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this %Lproprietary/enable_dkim_sign_cfm$cf;
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Enable DKIM Sign</title>
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
              <td height="438" width="988"> L@       keys $[Llucee/runtime/type/Collection$Key; P Q	  R !lucee/runtime/type/Collection$Key T *lucee/runtime/functions/decision/IsDefined V B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & X
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
 p � NEW �


                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 438px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="966">
                        <tr valign="top" align="left">
                          <td width="10" height="13"></td>
                          <td width="506"></td>
                          <td width="447"></td>
                          <td width="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="506" id="Text373" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Enable DKIM Sign</span></b></p>
                          </td>
                          <td colspan="2"></td>
                         �:</tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="165"></td>
                          <td colspan="2" width="953"> � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � lucee/runtime/op/Caster � toStruct /(Ljava/lang/Object;)Llucee/runtime/type/Struct; � �
 � � _domain � ;	 9 � .lucee/runtime/functions/struct/StructKeyExists � \(Llucee/runtime/PageContext;Llucee/runtime/type/Struct;Llucee/runtime/type/Collection$Key;)Z & �
 � � 	error.cfm � lucee/runtime/type/scope/Form � � e   � 

 � m1 � &lucee/runtime/config/NullSupportHelper � NULL � '
 � � -lucee/runtime/interpreter/VariableInterpreter � getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; � �
 � � 0 � %lucee/runtime/exp/ExpressionException � java/lang/StringBuilder � The required parameter [ �  1
 � � append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; � �
 � � ] was not provided. � -(Ljava/lang/String;)Ljava/lang/StringBuilder; � �
 � � toString ()Ljava/lang/String; � �
 � �
 � � any ��       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 p � domain �@       True � (ZLjava/lang/String;)I k �
 j � theID � _ID � ;	 9 � _id � ;	 9 � dkimkey � 1024 � action �  
 � _action � ;	 9 � _ACTION � ;	 9 � A e generate 


 outputStart 
 / lucee.runtime.tag.Query	 cfquery lucee/runtime/tag/Query customtrans setName 1
 setDatasource (Ljava/lang/Object;)V
 getrandom_results 	setResult 1

 � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V
 /  Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
" doAfterBody$ $
% doCatch (Ljava/lang/Throwable;)V'(
) popBody ()Ljavax/servlet/jsp/JspWriter;+,
 /- 	doFinally/ 
0
 � 	outputEnd3 
 /4 inserttrans6 stResult8 &
insert into salt
(salt)
values
(': getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;<=
 /> getId@ $
 /A lucee/runtime/type/QueryC getCurrentrow (I)IEFDG getRecordcountI $DJ !lucee/runtime/util/NumberIteratorL load '(II)Llucee/runtime/util/NumberIterator;NO
MP addQuery (Llucee/runtime/type/Query;)VRS AT isValid (I)ZVW
MX currentZ $
M[ go (II)Z]^D_ &(Ljava/lang/Object;)Ljava/lang/String; �a
 �b #lucee/runtime/functions/string/Trimd A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &f
eg writePSQi
 /j removeQueryl  Am release &(Llucee/runtime/util/NumberIterator;)Vop
Mq ')
s gettransu 2
select salt as customtrans2 from salt where id='w getCollectiony d Az I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; c|
 /} '
 deletetrans� 
delete from salt where id='� lucee.runtime.tag.FileTag� cffile� lucee/runtime/tag/FileTag� hasBody� �
�� read� 	setAction� 1
�� $/opt/hermes/scripts/generate_dkim.sh� setFile� 1
�� temp� setVariable� 1
��
� �
� � 0 /opt/hermes/scripts/� java/lang/String� concat &(Ljava/lang/String;)Ljava/lang/String;��
�� _generate_dkim.sh� THE-KEY� ALL� (lucee/runtime/functions/string/REReplace� w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &�
�� 	setOutput�
�� setAddnewline� �
�� 
THE-DOMAIN� 
    


� lucee.runtime.tag.Execute� 	cfexecute� lucee/runtime/tag/Execute� 
/bin/chmod�
� +x /opt/hermes/scripts/� setArguments�
��@N       
setTimeout (D)V��
��
� �
�%
� �@n       	/dev/null� setOutputfile� 1
�� -inputformat none� delete� 4
    




<!-- CHECK PRIVATE FILE EXISTS -->
� /opt/hermes/dkim/keys/� .dkim.private� 'lucee/runtime/functions/file/FileExists� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &�
�� )

<!-- CHECK PRIVATE FILE EXISTS --> 
� 	.dkim.txt� 
insertdkim� �
insert into dkim_sign (dkim_sign.domain, dkim_sign.applied, dkim_sign.public, dkim_sign.private, dkim_sign.enabled, dkim_sign.generated) values ('� 	', '1', '� .dkim.txt', '� .dkim.private', '1', '1')
� 2

<!-- GET KEYTABLE ENTRIES FROM DATABASE --> 
� getkeys� )
select domain, private from dkim_sign
� �

<!-- LOOP THROUGH KEYTABLE ENTRIES FROM DATABASE AND CREATE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMKEYTABLE FILE --> 
� "/opt/hermes/templates/DkimKeyTable  /opt/hermes/tmp/ _DkimKeyTable 
    
 � 	_KeyTable	 B

<!-- DELETE /opt/hermes/tmp/#customtrans3#_DkimKeyTable --> 
 �

<!-- CREATE SCRIPT TO MOVE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMKEYTABLE FILE  AND REPLACE /OPT/HERMES/DKIM/KEYTABLE --> 
 _mv_keytable.sh B/bin/cp /opt/hermes/dkim/KeyTable /opt/hermes/dkim/KeyTable.HERMES@$       "lucee/runtime/functions/string/Chr 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &
 /bin/mv /opt/hermes/tmp/ #_KeyTable /opt/hermes/dkim/KeyTable +x /opt/hermes/tmp/ �

<!-- DELETE SCRIPT TO MOVE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMKEYTABLE FILE  AND REPLACE /OPT/HERMES/DKIM/KEYTABLE --> 
  e
    
    
<!-- CREATE SCRIPT TO CHANGE OWNER OF /OPT/HERMES/DKIM/KEYS TO OPENDKIM:OPENDKIM --> 
" _change_keys_owner.sh$ 6/bin/chown -R opendkim:opendkim /opt/hermes/dkim/keys/& e

<!-- DELETE SCRIPT TO SCRIPT TO CHANGE OWNER OF /OPT/HERMES/DKIM/KEYS TO OPENDKIM:OPENDKIM --> 
( �
    

<!-- LOOP THROUGH KEYTABLE ENTRIES FROM DATABASE AND CREATE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMSIGNTABLE FILE --> 
* #/opt/hermes/templates/DkimSignTable, _DkimSignTable. 
_SignTable0 C

<!-- DELETE /opt/hermes/tmp/#customtrans3#_DkimSignTable --> 
2 �

<!-- CREATE SCRIPT TO MOVE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMSIGNTABLE FILE  AND REPLACE /OPT/HERMES/DKIM/SIGNINGTABLE --> 
4 _mv_signtable.sh6 J/bin/cp /opt/hermes/dkim/SigningTable /opt/hermes/dkim/SigningTable.HERMES8 (_SignTable /opt/hermes/dkim/SigningTable: �

<!-- DELETE SCRIPT TO MOVE TEMPORARY /OPT/HERMES/TMP/#CUSTOMTRANS3#_DKIMSIGNTABLE FILE  AND REPLACE /OPT/HERMES/DKIM/SIGNINGTABLE --> 
< -
  
<!-- RELOAD & RESTART OPENDKIM -->   
> _restart_opendkim.sh@ !/usr/sbin/service opendkim reloadB "/usr/sbin/service opendkim restartD (

<!-- RELOAD & RESTART POSTFIX --> 
F _restart_postfix.shH  /usr/sbin/service postfix reloadJ !/usr/sbin/service postfix restartL dkim_sign.cfm?m=1N _MP ;	 9Q #lucee/commons/color/ConstantsDoubleS _1 Ljava/lang/Double;UV	TW 
<!-- PrivateFile Exists -->
Y 
<!-- PublicFile Exists -->
[ !



<!-- /CFIF  action  -->
] &

<!-- /CFIF form.domain is "" -->
_ 4

<!-- /CFIF structKeyExists(form, "domain") -->
a7
                            <table border="0" cellspacing="0" cellpadding="0" width="953" id="LayoutRegion17" style="height: 165px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="c enable_dkim_sign.cfme �" method="post">
                                    <input type="hidden" name="action" value="generate"><input type="hidden" name="domain" value="g ("><input type="hidden" name="id" value="ip">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="595">
                                          <table id="Table185" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 39px;">
                                            <tr style="height: 17px;">
                                              <td width="595" id="Cell1029">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Domain</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1030">
                                                <table width="360" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  k �<tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;">m �
<input type="text" id="FormsEditField30" name="recipient" size="45" maxlength="255" disabled="disabled" style="width: 356px; white-space: pre;" value="o ">
q(

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
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="2"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="590">
                                          <table id="Table132" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 45px;">
                                            sH<tr style="height: 14px;">
                                              <td width="586" id="Cell886">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">DKIM Key Length</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 42px;">
                                              <td id="Cell887">
                                                <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table71" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 42px;">
                                                        <tr style="height: 21px;">
                                                          u�<td width="51" id="Cell1032">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">w i
<input type="radio" checked="checked" name="dkimkey" value="1024" style="height: 13px; width: 13px;">
y W
<input type="radio" name="dkimkey" value="1024" style="height: 13px; width: 13px;">
{J
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="480" id="Cell1031">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">1024-bits</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 21px;">
                                                          <td id="Cell411">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              } �<tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"> 2048� i
<input type="radio" checked="checked" name="dkimkey" value="2048" style="height: 13px; width: 13px;">
� W
<input type="radio" name="dkimkey" value="2048" style="height: 13px; width: 13px;">
�%
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell412">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">2048-bits</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            �</tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="15"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="953">
                                          <table id="Table136" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="953" id="Cell815">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  �<tr>
                                                    <td align="center">
                                                      <table width="194" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Generate DKIM Keys" style="height: 24px; width: 357px;">
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              �</td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="953">
                                      <tr valign="top" align="left">
                                        <td width="953" height="5"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="953" id="Text276" class="TextObject">
                                          <p style="margin-bottom: 0px;">� 1��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;there was an error generating DKIM keys. Please try again or contact support</span></i></b></p>
� 8�b
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! Relay  domain edited</span></i></b></p>
�


&nbsp;</p>
                                        </td>
                                      </tr>
                                    </table>
                                  </form>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td colspan="2" valign="middle" width="953"><hr id="HRRule2" width="953" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="40"></td>
                          <td colspan="3" width="956">

                            ��<table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="956">
                                        <form name="apply_settings" action="� dkim_sign.cfm�Y" method="post">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="956" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="591" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to DKIM Sign" style="height: 24px; width: 357px;">
&nbsp;�</p>
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
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            �</tr>
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
 � license� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� LICENSE� DOMAIN� THEID� DKIMKEY� RANDOM� STRESULT� GENERATED_KEY� CUSTOMTRANS3� GETTRANS� CUSTOMTRANS2� TEMP� PRIVATEFILE� 
PUBLICFILE� GETKEYS� M1� THEYEAR� EDITION� 
GETVERSION GETBUILD subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             P Q             *     *� 
*� *� � *�ϵ�*+�ֱ                 �                � �                 �                 �                  !�      # $         %�      & '   3l  �  +�+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+ N*� S2� U� Z� �+\� 3+� `*� S2� f h� n� � � U+\� 3+� prt� x� zM,|� ,� �,� �W,� �� � ��� N+� p,� �-�+� p,� �+\� 3� ~+� `*� S2� f �� n� � � ^+\� 3+� prt� x� z:|� � �� �W� �� � ��� :+� p� ��+� p� �+\� 3� +\� 3� +�� 3+�� 3++� �� �� �� U� �� � � ^+\� 3+� prt� x� z:�� � �� �W� �� � ��� :+� p� ��+� p� �+\� 3�$h++� �� �� �� U� ��$T+\� 3+� �*� S2� � �� n� � � ^+\� 3+� prt� x� z:�� � �� �W� �� � ��� :	+� p� �	�+� p� �+\� 3�#�+� �*� S2� � �� n� � �#�+�� 3+�+� �� �:
6+� �
� 0�Y:� !� �Y� �Yɷ ��� �Ѷ Զ ط ٿ:
6+� p��
 � �� �+�� 3+�+� �� �:6+� �� =+� �*� S2� � Y:� !� �Y� �Yɷ �� �Ѷ Զ ط ٿ:6+� p�� � �� �+\� 3+ � �� U� Z� �� � � Z+\� 3+� �*� S2� � �� n� � � 1+\� 3+� 7*� S2+� �*� S2� � � E W+\� 3� � +�� 3+�+� �� �:6+� �� :+� �� � � Y:� !� �Y� �Yɷ �� �Ѷ Զ ط ٿ:6+� p�� � �� �+\� 3+ � �� U� Z� �� � � T+\� 3+� �� � � �� n� � � .+\� 3+� 7*� S2+� �� � � � E W+\� 3� � +�� 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Yɷ ��� �Ѷ Զ ط ٿ:6+� p�� � �� �+\� 3+ �*� S2� U� Z� �� � � Z+\� 3+� �*� S2� � �� n� � � 1+\� 3+� 7*� S2+� �*� S2� � � E W+\� 3� � +�� 3+�+� �� �:6+� �� 0�Y:� !� �Y� �Yɷ ��� �Ѷ Զ ط ٿ:6+� p�� � �� �+�� 3+ � �� U� Z� �� � � Q+\� 3+� �� � � �� n� � � ++\� 3+� 7� +� �� � � � E W+\� 3� � +�� 3+� 7� � � n� � ��+� 3+�+� p
� x�:�+� 7� =� ���6� O+�!+#� 3�&��� $:�*� :� +�.W�1�� +�.W�1�2� � ��� :+� p� ��+� p� �� :+�5�+�5+�� 3+�+� p
� x�:7�+� 7� =� �9��6  �B+ �!+;� 3+�+�?:"+�B6#"#�H 6$"�K � � � �6%%"�K �Q:!+� 7"�U %d6(!(`�Y� D"!�\#�` � � � � (!�\6(+++� 7*� S2� �c�h�k���� ":)"$#�` W+� 7�n !�r)�"$#�` W+� 7�n !�r� :*+�5*�+�5+t� 3�&�� � $:++�*� :, � +�.W�1,� � +�.W�1�2� � ��� :-+� p� �-�+� p� �� :.+�5.�+�5+�� 3+�+� p
� x�://v�/+� 7� =� �/�600� x+/0�!+x� 3+++� 7*� S2�{ *� S2�~�c�k+�� 3/�&��ʧ $:1/1�*� :20� +�.W/�12�0� +�.W/�1/�2� � ��� :3+� p/� �3�+� p/� �� :4+�54�+�5+�� 3+� 7*� S	2++� 7*� S
2�{ *� S2�~� E W+�� 3+�+� p
� x�:55��5+� 7� =� �5�666� x+56�!+�� 3+++� 7*� S2�{ *� S2�~�c�k+�� 35�&��ʧ $:757�*� :86� +�.W5�18�6� +�.W5�15�2� � ��� :9+� p5� �9�+� p5� �� ::+�5:�+�5+� 3+� p��� x��:;;��;���;���;���;��W;��� � ��� :<+� p;� �<�+� p;� �+� 3+� p��� x��:==��=���=�+� 7*� S	2� �c�������=++� 7*� S2� �c�+� 7*� S2� �c�����=��=��W=��� � ��� :>+� p=� �>�+� p=� �+�� 3+� p��� x��:??��?���?�+� 7*� S	2� �c�������?���?��W?��� � ��� :@+� p?� �@�+� p?� �+�� 3+� p��� x��:AA��A���A�+� 7*� S	2� �c�������A++� 7*� S2� �c�+� 7*� S2� �c�����A��A��WA��� � ��� :B+� pA� �B�+� pA� �+�� 3+� p��� x��:CCĶ�C�+� 7*� S	2� �c�������C˶�C��6DD� 8+CD�!+\� 3C������ :ED� +�.WE�D� +�.WC��� � ��� :F+� pC� �F�+� pC� �+�� 3+� p��� x��:GG�+� 7*� S	2� �c�������GԶ�G׶�Gܶ�G��6HH� 8+GH�!+\� 3G������ :IH� +�.WI�H� +�.WG��� � ��� :J+� pG� �J�+� pG� �+�� 3+� p��� x��:KK��K޶�K�+� 7*� S	2� �c�������K��WK��� � ��� :L+� pK� �L�+� pK� �+� 3+� 7*� S2�+� 7*� S2� �c����� E W+\� 3++� 7*� S2� ��>+� 3+� 7*� S2�+� 7*� S2� �c������ E W+\� 3++� 7*� S2� ���+�� 3+�+� p
� x�:MM�M+� 7� =� �M�6NN� �+MN�!+� 3++� 7*� S2� �c�k+� 3++� 7*� S2� �c�k+�� 3++� 7*� S2� �c�k+�� 3M�&���� $:OMO�*� :PN� +�.WM�1P�N� +�.WM�1M�2� � ��� :Q+� pM� �Q�+� pM� �� :R+�5R�+�5+�� 3+�+� p
� x�:SS��S+� 7� =� �S�6TT� O+ST�!+�� 3S�&��� $:USU�*� :VT� +�.WS�1V�T� +�.WS�1S�2� � ��� :W+� pS� �W�+� pS� �� :X+�5X�+�5+�� 3+��?:Z+�B6[Z[�H 6\Z�K � � ��6]]Z�K �Q:Y+� 7Z�U ]d6`Y``�Y�hZY�\[�` � � � �LY�\6`+�� 3+� p��� x��:aa��a���a��a���a��Wa��� � ��� :b+� pa� �b�+� pa� �+�� 3+� p��� x��:cc��c���c+� 7*� S	2� �c������c++� 7*� S2� �c�++� 7*� S2�{ *� S2�~�c�����c��c��Wc��� � ��� :d+� pc� �d�+� pc� �+� 3+� p��� x��:ee��e���e+� 7*� S	2� �c������e���e��We��� � ��� :f+� pe� �f�+� pe� �+�� 3+� p��� x��:gg��g��g+� 7*� S	2� �c��
����g+� 7*� S2� ��g��g��Wg��� � ��� :h+� pg� �h�+� pg� �+�� 3���� ":iZ\[�` W+� 7�n Y�ri�Z\[�` W+� 7�n Y�r+� 3+� p��� x��:jj��j޶�j+� 7*� S	2� �c������j��Wj��� � ��� :k+� pj� �k�+� pj� �+� 3+� p��� x��:ll��l���l+� 7*� S	2� �c������l+�����+� 7*� S	2� �c������l��l��Wl��� � ��� :m+� pl� �m�+� pl� �+� 3+� p��� x��:nnĶ�n+� 7*� S	2� �c������n˶�n��6oo� 8+no�!+\� 3n������ :po� +�.Wp�o� +�.Wn��� � ��� :q+� pn� �q�+� pn� �+�� 3+� p��� x��:rr+� 7*� S	2� �c������rԶ�r��6ss� 8+rs�!+\� 3r������ :ts� +�.Wt�s� +�.Wr��� � ��� :u+� pr� �u�+� pr� �+!� 3+� p��� x��:vv��v޶�v+� 7*� S	2� �c������v��Wv��� � ��� :w+� pv� �w�+� pv� �+#� 3+� p��� x��:xx��x���x+� 7*� S	2� �c��%����x'��x��x��Wx��� � ��� :y+� px� �y�+� px� �+� 3+� p��� x��:zzĶ�z+� 7*� S	2� �c��%����z˶�z��6{{� 8+z{�!+\� 3z������ :|{� +�.W|�{� +�.Wz��� � ��� :}+� pz� �}�+� pz� �+�� 3+� p��� x��:~~+� 7*� S	2� �c��%����~Զ�~��6� 8+~�!+\� 3~������ :�� +�.W��� +�.W~��� � ��� :�+� p~� ���+� p~� �+)� 3+� p��� x��:�����޶��+� 7*� S	2� �c��%�������W���� � ��� :�+� p�� ���+� p�� �++� 3+��?:�+�B6����H 6���K � � ��6����K �Q:�+� 7��U �d6���`�Y�h���\��` � � � �L��\6�+�� 3+� p��� x��:���������-���������W���� � ��� :�+� p�� ���+� p�� �+�� 3+� p��� x��:���������+� 7*� S	2� �c��/�����++� 7*� S2� �c�++� 7*� S2�{ *� S2�~�c�����������W���� � ��� :�+� p�� ���+� p�� �+� 3+� p��� x��:���������+� 7*� S	2� �c��/�����������W���� � ��� :�+� p�� ���+� p�� �+�� 3+� p��� x��:��������+� 7*� S	2� �c��1�����+� 7*� S2� ��������W���� � ��� :�+� p�� ���+� p�� �+�� 3���� ":�����` W+� 7�n ��r������` W+� 7�n ��r+3� 3+� p��� x��:�����޶��+� 7*� S	2� �c��/�������W���� � ��� :�+� p�� ���+� p�� �+5� 3+� p��� x��:���������+� 7*� S	2� �c��7�����9+�����+� 7*� S	2� �c��;����������W���� � ��� :�+� p�� ���+� p�� �+� 3+� p��� x��:��Ķ��+� 7*� S	2� �c��7�����˶����6��� 8+���!+\� 3������� :��� +�.W���� +�.W���� � ��� :�+� p�� ���+� p�� �+�� 3+� p��� x��:��+� 7*� S	2� �c��7�����Զ����6��� 8+���!+\� 3������� :��� +�.W���� +�.W���� � ��� :�+� p�� ���+� p�� �+=� 3+� p��� x��:�����޶��+� 7*� S	2� �c��7�������W���� � ��� :�+� p�� ���+� p�� �+?� 3+� p��� x��:���������+� 7*� S	2� �c��A�����C+���E����������W���� � ��� :�+� p�� ���+� p�� �+� 3+� p��� x��:��Ķ��+� 7*� S	2� �c��A�����˶����6��� 8+���!+\� 3������� :��� +�.W���� +�.W���� � ��� :�+� p�� ���+� p�� �+�� 3+� p��� x��:��+� 7*� S	2� �c��A�����Զ����6��� 8+���!+\� 3������� :��� +�.W���� +�.W���� � ��� :�+� p�� ���+� p�� �+� 3+� p��� x��:�����޶��+� 7*� S	2� �c��A�������W���� � ��� :�+� p�� ���+� p�� �+G� 3+� p��� x��:���������+� 7*� S	2� �c��I�����K+���M����������W���� � ��� :�+� p�� ���+� p�� �+� 3+� p��� x��:��Ķ��+� 7*� S	2� �c��I�����˶����6��� 8+���!+\� 3������� :��� +�.W���� +�.W���� � ��� :�+� p�� ���+� p�� �+�� 3+� p��� x��:��+� 7*� S	2� �c��I�����Զ����6��� 8+���!+\� 3������� :��� +�.W���� +�.W���� � ��� :�+� p�� ���+� p�� �+� 3+� p��� x��:�����޶��+� 7*� S	2� �c��I�������W���� � ��� :�+� p�� ���+� p�� �+� 3+� prt� x� z:��O� �� ��� �W�� �� � ��� :�+� p�� ���+� p�� �+�� 3�  +\� 3+� 7�R�X� E W+Z� 3+�� 3�  +\� 3+� 7�R�X� E W+\� 3+^� 3� +`� 3� +b� 3� +d� 3+�+f� 3� :�+�5��+�5+h� 3+�++� 7*� S2� �c� 3� :�+�5��+�5+j� 3+�++� 7*� S2� �c� 3� :�+�5��+�5+l� 3+n� 3+�+p� 3++� 7*� S2� �c� 3+r� 3� :�+�5��+�5+t� 3+v� 3+x� 3+� 7*� S2� �� n� � � -+\� 3+�+z� 3� :�+�5��+�5+\� 3� M+� 7*� S2� �� n� � � -+\� 3+�+|� 3� :�+�5¿+�5+\� 3� +~� 3+�� 3+� 7*� S2� �� n� � � -+\� 3+�+�� 3� :�+�5ÿ+�5+\� 3� N+� 7*� S2� �� n� � � -+\� 3+�+�� 3� :�+�5Ŀ+�5+\� 3� +�� 3+�� 3+�� 3+�� 3+� 7*� S2� �� n� � � -+\� 3+�+�� 3� :�+�5ſ+�5+\� 3� +� 3+� 7*� S2� �� n� � � -+\� 3+�+�� 3� :�+�5ƿ+�5+\� 3� +�� 3+�� 3+�+�� 3� :�+�5ǿ+�5+�� 3+�� 3+�� 3+� 7*� S2++������ E W+\� 3+�+� p
� x�:�����+� 7� =� �ȶ6��� O+�ɶ!+�� 3ȶ&��� $:��ʶ*� :��� +�.Wȶ1˿�� +�.Wȶ1ȶ2� � ��� :�+� pȶ �̿+� pȶ �� :�+�5Ϳ+�5+\� 3+�+� p
� x�:�����+� 7� =� �ζ6��� O+�϶!+�� 3ζ&��� $:��ж*� :��� +�.Wζ1ѿ�� +�.Wζ1ζ2� � ��� :�+� pζ �ҿ+� pζ �� :�+�5ӿ+�5+\� 3+�+�� 3++� `*� S2� f �c� 3+�� 3+++� 7*� S2�{ ���~�c� 3+�� 3+++� 7*� S2�{ ���~�c� 3+�� 3++� 7*� S2� �c� 3+ö 3� :�+�5Կ+�5+Ŷ 3� f | � �   �  {��  44  ��� )���  �""  �<<  �FF  ���  ��� )���  f��  S��  	V	�	� )	V	�	�  	(	�	�  		�	�  
x
�
� )
x
�
�  
J
�
�  
7  7ll  �    P��  �TT  ���  �  ���  <��  �DD  L�� )L��  ��    k{~ )k��  =��  *��  ���  �xx  ���  *��  =��  MM  ~  {��  2��  *<<  �hh  ���  jj  ���  �""  ���  R��  KK   55  e��  $uu  �		  �,,  ��  �||  �  �44  ���  d��    ] ]   � � �  !o!�!�  !&!�!�  ""0"0  !�"\"\  "�"�"�  ##n#n  #�#�#�  #�$&$&  $�$�$�  $V$�$�  %%O%O  %~%�%�  &/&9&9  &Q&j&j  &�&�&�  &�&�&�  '-'7'7  'w'�'�  '�'�'�  ((%(%  (�(�(�  (�(�(�  )))  )�)�)� ))�)�)�  )m)�)�  )Z*
*
  *b*r*u )*b*~*�  *4*�*�  *!*�*�  *�+x+x            * +  	  �"   
       ! F $ G - Y C Z i [ � \ � ]- ^6 _? bH xg y� z� {� |N }w � �H �l �� �� �� �/ �S �v �� �� � �- �S �x �� �� �
 �- �L �X �} �� �L �� �� �	 �	Z �	� �	� �
0 �
| �
� �! �� �� �� �7 �7 �: �� �� � �k �k �o �� �� �� �& �b �j �r �� �� � � �[ �[ �_ �b �� �� �� �� � �P �� �# �& �o �� �� �o �� �� � �� �� �� � �� �� �� � � �d �d �h �k �� �� � � � �< `~�-��	�
��	�� #G������<x���
 bb f#i$�&O(u)�*
(
*,�.#0i2l3�4�5�3�5�7�8�;�<�=�>N@�A�B�D E F $G tE tG xI {J �K �L!J!L!O!0P!TQ!rR!�T"U"!V"wY"�Z"�["�Y"�["�]"�^#_#;`#�^#�`#�c#�d#�e#�f$@h$|i$�j$�m%n%o%fm%fo%jq%�s%�t%�u%�v%�x%�y&z&{&
&�&�&�&�&$�&(�&+�&J�&��&��&��&��&��&��&��&��&��&��' �'�'&�'1�'D�'G�'p�'{�'��'��'��'��'��'��'��'��'��'��(�(�(2�(5�(?�(I�(M�(W(|(�(�(�(�(�(�(�(� (�#(�:);)C)#D)4r)Ss)�u*v*fx*�y*�z
     ) ��         �    
     ) ��          �    
     ) ��         �    
    �       �     �*� UYظ�SY��SY��SY��SY���SY��SY��SY��SY��SY	��SY
��SY��SY���SY���SY���SY���SY���SY���SY ��SY��SY��S� S�         