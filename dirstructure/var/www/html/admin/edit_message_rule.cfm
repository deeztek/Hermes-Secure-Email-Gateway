����   2� M__138/__138/publish/hermes_seg_18_041454/proprietary/edit_message_rule_cfm$cf  lucee/runtime/PageImpl  @../../publish/hermes-seg-18.04/proprietary/edit_message_rule.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  �ͩi� getSourceLength      �� getCompileTime  �@,�# getHash ()I�Eο call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this OL__138/__138/publish/hermes_seg_18_041454/proprietary/edit_message_rule_cfm$cf;
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Edit Message Rule</title>
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
              <td height="634" width="988"> L m1 N &lucee/runtime/config/NullSupportHelper P NULL R '
 Q S -lucee/runtime/interpreter/VariableInterpreter U getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; W X
 V Y 0 [ %lucee/runtime/exp/ExpressionException ] java/lang/StringBuilder _ The required parameter [ a  1
 ` c append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; e f
 ` g ] was not provided. i -(Ljava/lang/String;)Ljava/lang/StringBuilder; e k
 ` l toString ()Ljava/lang/String; n o
 ` p
 ^ c lucee/runtime/PageContextImpl s any u�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V y z
 t { 
 } m2  step � 

 � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � lucee/runtime/op/Caster � toStruct /(Ljava/lang/Object;)Llucee/runtime/type/Struct; � �
 � � _id � ;	 9 � !lucee/runtime/type/Collection$Key � .lucee/runtime/functions/struct/StructKeyExists � \(Llucee/runtime/PageContext;Llucee/runtime/type/Struct;Llucee/runtime/type/Collection$Key;)Z & �
 � � lucee.runtime.tag.Location � 
cflocation � @C:\publish\hermes-seg-18.04\proprietary\edit_message_rule.cfm:94 � use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; � �
 t � lucee/runtime/tag/Location � 	error.cfm � setUrl � 1
 � � setAddtoken (Z)V � �
 � � 
doStartTag � $
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 t � _ID � ;	 9 � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � �   � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � @C:\publish\hermes-seg-18.04\proprietary\edit_message_rule.cfm:97 � integer � (lucee/runtime/functions/decision/IsValid � B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z & �
 � � AC:\publish\hermes-seg-18.04\proprietary\edit_message_rule.cfm:102 � "

<!-- /CFIF form.id is "" -->
 � 0

<!-- /CFIF isValid("integer", form.id) -->
 � 0

<!-- /CFIF structKeyExists(form, "id") -->
 � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � AC:\publish\hermes-seg-18.04\proprietary\edit_message_rule.cfm:113 � lucee/runtime/tag/Query � hasBody � �
 � � getrule � setName � 1
 � � A � setDatasource (Ljava/lang/Object;)V � �
 � �
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � (
select * from message_rules where id=  � lucee.runtime.tag.QueryParam � cfqueryparam AC:\publish\hermes-seg-18.04\proprietary\edit_message_rule.cfm:114 lucee/runtime/tag/QueryParam setValue �
 CF_SQL_INTEGER
 setCfsqltype 1

 �
 � doAfterBody $
 � doCatch (Ljava/lang/Throwable;)V
 � popBody ()Ljavax/servlet/jsp/JspWriter;
 / 	doFinally 
 �
 � � 	outputEnd  
 /! keys $[Llucee/runtime/type/Collection$Key;#$	 % getCollection' � A( #lucee/runtime/util/VariableUtilImpl* recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;,-
+. (Ljava/lang/Object;D)I �0
 �1 AC:\publish\hermes-seg-18.04\proprietary\edit_message_rule.cfm:1183 	rule_name5 I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �7
 /8@       *lucee/runtime/functions/decision/IsDefined< B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z &>
=? TrueA (ZLjava/lang/String;)I �C
 �D 	rule_descF 	rule_typeH headerJ _headerL ;	 9M regexO scoreQ _scoreS ;	 9T actionV  
X _actionZ ;	 9[ _ACTION] ;	 9^ (

<!-- /CFIF getrule.recordcount -->
` editb #lucee/commons/color/ConstantsDoubled _1 Ljava/lang/Double;fg	eh [^_a-zA-Z0-9-]j &(Ljava/lang/Object;)Ljava/lang/String; nl
 �m %lucee/runtime/functions/string/REFindo S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object; &q
pr _2tg	eu :

<!-- /CFIF REFind("[^_a-zA-Z0-9-]"rule_name gt 0 -->
w $

<!-- /CFIF rule_name is "" -->
y 1{ _4}g	e~ _5�g	e� ;


<!-- /CFIF REFind("[^_a-zA-Z0-9-]",header) gt 0 -->
� !

<!-- /CFIF header is "" -->
� (

<!-- /CFIF rule_type is header -->
� 

<!-- /CFIF FOR STEP 1 -->
� 


� 2� _6�g	e� _3�g	e�  

<!-- /CFIF regex is "" -->
� 

<!-- /CFIF FOR STEP 2 -->
� 3� _7�g	e� *lucee/runtime/functions/decision/IsNumeric� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &�
�� _8�g	e� %

<!-- /CFIF IsNumeric(score) -->
� 

<!-- /CFIF FOR STEP 3 -->
� 4� AC:\publish\hermes-seg-18.04\proprietary\edit_message_rule.cfm:250� update� )
update message_rules 
set
rule_name='� writePSQ� �
 /� ',
rule_type='� ',
rule_desc='� ',
header='� ', 
regex=� AC:\publish\hermes-seg-18.04\proprietary\edit_message_rule.cfm:257� cf_sql_varchar� , 
score='� ',
applied='2'
where id='� '
� AC:\publish\hermes-seg-18.04\proprietary\edit_message_rule.cfm:264� message_rules.cfm?m2=2� 

<!-- /CFIF FOR STEP 4 -->
� !


<!-- /CFIF FOR ACTION -->
�5
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 634px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="987">
                        <tr valign="top" align="left">
                          <td width="10" height="13"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="446"></td>
                          <td width="4"></td>
                          <td width="1"></td>
                          <td width="20"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="2" width="506" id="Text373" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Edit Message Rule�f</span></b></p>
                          </td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="106"></td>
                          <td colspan="3" width="952">
                            <form name="LayoutRegion33FORM" action="edit_message_rule.cfm" method="post">
                              <input type="hidden" name="id" value="��">
                              <table border="0" cellspacing="0" cellpadding="0">
                                <tr valign="top" align="left">
                                  <td height="7"></td>
                                </tr>
                                <tr valign="top" align="left">
                                  <td width="780">
                                    <table id="Table139" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 32px;">
                                      <tr style="height: 17px;">
                                        <td width="780" id="Cell1086">
                                          <table width="751" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: left; margin-bottom: 0px;">�h
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes saved and applied</span></i></b></p>
�`
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name field cannot be empty</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name field must only contain lettes, numbers, dashes and underscores</span></i></b></p>
�s
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Rule Name you are attempting to use already exists</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The header field cannot be empty if Rule Type of Header is selected</span></i></b></p>
� 5��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The header field must only contain lettes, numbers, dashes and underscores</span></i></b></p>
� 6�\
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Regex field cannot be empty</span></i></b></p>
� 7�\
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Score field cannot be empty</span></i></b></p>
� 8�a
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Score field must be numeric only</span></i></b></p>
�&nbsp;</p>
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
                                            <tr>
                                              ��<td>
                                                <table id="Table133" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 68px;">
                                                  <tr style="height: 17px;">
                                                    <td width="64" id="Cell797">
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;">� body� �
<input type="radio" checked="checked" name="rule_type" value=body" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
� x
<input type="radio" name="rule_type" value="body" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
�g







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
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        � �<tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;">� �
<input type="radio" checked="checked" name="rule_type" value="header" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
� z
<input type="radio" name="rule_type" value="header" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
�o





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
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                         uri �
<input type="radio" checked="checked" name="rule_type" value="uri" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
 w
<input type="radio" name="rule_type" value="uri" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
i





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
                                                      <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                        	 rawbody �
<input type="radio" checked="checked" name="rule_type" value="rawbody" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
 {
<input type="radio" name="rule_type" value="rawbody" style="height: 13px; width: 13px;" onclick="this.form.submit();" >






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
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                              </table>
                            </form>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="226"></td>
                          <td colspan="5" width="976">




 

                            <table border="0" cellspacing="0" cellpadding="0" width="976" id="LayoutRegion17" style="height: 226px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="edit_message_rule.cfm" method="post">
                                    <input type="hidden" name="action" value="edit"> -<input type="hidden" name="rule_type" value=" ("><input type="hidden" name="id" value=" /"><input type="hidden" name="rule_name" value="">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="803">
                                          <table id="Table138" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 153px;">
                                            <tr style="height: 14px;">
                                              <td width="803" id="Cell973">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Rule Name <span style="font-weight: normal;">(Cannot be changed)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell972">
                                                 <p style="margin-bottom: 0px;"> �<input type="text" id="FormsEditField39" name="rule_name" size="55" maxlength="255" disabled="disabled" style="width: 436px; white-space: pre;" value=" ">!</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell901">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Rule Description</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell902">
                                                <p style="margin-bottom: 0px;"># �<input type="text" id="FormsEditField61" name="rule_desc" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="%%</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1082">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b><span style="color: rgb(51,51,51);">Message Header </span></b><span style="font-weight: normal;">(Letters numbers and underlines only. No spaces are allowed)</span></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1083">
                                                <table width="441" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    ' n<td class="TextObject">
                                                      <p style="margin-bottom: 0px;">) �
<input type="text" name="header" size="55" maxlength="255" style="width: 436px; white-space: pre;" style="white-space:pre" value="" disabled="disabled">
+ �
<input type="text" name="header" size="55" maxlength="255" style="width: 436px; white-space: pre;" style="white-space:pre" value="- ">
/�&nbsp;</p>
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
                                                <p style="margin-bottom: 0px;">1 <input type="text" id="FormsEditField63" name="regex" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="3�</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell906">
                                                <p style="margin-bottom: 0px;"><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;"><b><span style="color: rgb(51,51,51);">Spam Score </span></b><span style="font-weight: normal;">(Numeric&nbsp; Value only)</span></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell968">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">5 <input type="text" id="FormsEditField62" name="score" size="55" maxlength="255" style="width: 436px; white-space: pre;" value="7</span></b></p>
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
                                                9<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="277" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Saving Changes, please wait...';this.form.submit();" name="savechanges" value="Save Changes" style="height: 24px; width: 275px;">
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  ;	</tr>
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
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="3" valign="middle" width="955"><hr id="HRRule15" width="955" size="1"></td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="7" height="1"></td>
                        =i</tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="40"></td>
                          <td colspan="4" width="956">

                            <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="956">
                                        <form name="apply_settings" action="? message_rules.cfmA[" method="post">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="956" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="360" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Message Rules" style="height: 24px; width: 357px;">
&nbsp;C </p>
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
                E8</table>
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
                            <p style="text-align: center; margin-bottom: 0px;">G $lucee/runtime/functions/dateTime/NowI =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &K
JL yyyyN 4lucee/runtime/functions/displayFormatting/DateFormatP S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &R
QS AC:\publish\hermes-seg-18.04\proprietary\edit_message_rule.cfm:701U 
getversionW D
SELECT value from system_settings where parameter = 'version_no'
Y AC:\publish\hermes-seg-18.04\proprietary\edit_message_rule.cfm:704[ getbuild] B
SELECT value from system_settings where parameter = 'build_no'
_ V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway a sessionScope $()Llucee/runtime/type/scope/Session;cd
 /e  lucee/runtime/type/scope/Sessiongh � 	 Version:j _VALUEl ;	 9m  Build:o . Copyright 2011-q l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>sA&nbsp;</p>
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
 ����u udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException}  lucee/runtime/type/UDFProperties udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � GETRULE� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� 	RULE_NAME� 	RULE_DESC� 	RULE_TYPE� HEADER� REGEX� SCORE� M1� STEP� M2� THEYEAR� EDITION� 
GETVERSION� GETBUILD� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile            #$   ��       �   *     *� 
*� *� � *����*+���        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  #�  c  �+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O+� T� ZM>+� T,� .\Y:� !� ^Y� `Yb� dO� hj� m� q� r�M>+� tvO, w w� |+~� 3+�+� T� Z:6+� T� 0\Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+~� 3+�+� T� Z:6	+� T� 0\Y:
� !� ^Y� `Yb� d�� hj� m� q� r�
:6	+� tv� w w	� |+�� 3++� �� �� �� �� �� � � `+~� 3+� t���� �� �:�� �� �� �W� �� � ��� :+� t� ��+� t� �+~� 3�c++� �� �� �� �� ��O+~� 3+� �� �� � ȸ �� � � `+~� 3+� t��ж �� �:�� �� �� �W� �� � ��� :+� t� ��+� t� �+~� 3� �+� �� �� � ȸ �� � � �+~� 3+�+� �� �� � � י ++~� 3+� 7� �+� �� �� � � E W+~� 3� ]+~� 3+� t��ٶ �� �:�� �� �� �W� �� � ��� :+� t� ��+� t� �+۶ 3+ݶ 3� +߶ 3� +�� 3+� �+� t��� �� �:� �� �+� 7� =� � � �� �6� �+� �+�� 3+� t � ��:+� 7� �� � �	��W�� � ��� :+� t� ��+� t� �+~� 3����� $:�� :� +�W��� +�W��� � ��� :+� t� ��+� t� �� :+�"�+�"+�� 3++� 7*�&2�) �/�2� � � a+~� 3+� t��4� �� �:�� �� �� �W� �� � ��� :+� t� ��+� t� �+�� 3��++� 7*�&2�) �/�2� � ��+�� 3+6+� T� Z:6+� T� H++� 7*�&2�) *�&2�9Y:� "� ^Y� `Yb� d6� hj� m� q� r�:6+� tv6 w w� |+~� 3+:*�&2� ��@B�E� � � Z+~� 3+� �*�&2� � ȸ �� � � 1+~� 3+� 7*�&2+� �*�&2� � � E W+~� 3� � +�� 3+G+� T� Z:6+� T� H++� 7*�&2�) *�&2�9Y: � "� ^Y� `Yb� dG� hj� m� q� r� :6+� tvG w w� |+~� 3+:*�&2� ��@B�E� � � Z+~� 3+� �*�&2� � ȸ �� � � 1+~� 3+� 7*�&2+� �*�&2� � � E W+~� 3� � +�� 3+I+� T� Z:!6"+� T!� H++� 7*�&2�) *�&2�9Y:#� "� ^Y� `Yb� dI� hj� m� q� r�#:!6"+� tvI! w w"� |+~� 3+:*�&2� ��@B�E� � � Z+~� 3+� �*�&2� � ȸ �� � � 1+~� 3+� 7*�&2+� �*�&2� � � E W+~� 3� � +�� 3+K+� T� Z:$6%+� T$� I++� 7*�&2�) *�&2�9Y:&� "� ^Y� `Yb� dK� hj� m� q� r�&:$6%+� tvK$ w w%� |+~� 3+:�N� ��@B�E� � � ]+~� 3+� �*�&2� � ȸ �� � � 3+~� 3+� 7*�&2+� �*�&2� � � E W+~� 3� � +�� 3+P+� T� Z:'6(+� T'� I++� 7*�&2�) *�&2�9Y:)� "� ^Y� `Yb� dP� hj� m� q� r�):'6(+� tvP' w w(� |+~� 3+:*�&	2� ��@B�E� � � ]+~� 3+� �*�&2� � ȸ �� � � 3+~� 3+� 7*�&2+� �*�&2� � � E W+~� 3� � +�� 3+R+� T� Z:*6++� T*� I++� 7*�&2�) *�&
2�9Y:,� "� ^Y� `Yb� dR� hj� m� q� r�,:*6++� tvR* w w+� |+~� 3+:�U� ��@B�E� � � ]+~� 3+� �*�&
2� � ȸ �� � � 3+~� 3+� 7*�&
2+� �*�&
2� � � E W+~� 3� � +�� 3+W+� T� Z:-6.+� T-� 1�Y:/� "� ^Y� `Yb� dW� hj� m� q� r�/:-6.+� tvW- w w.� |+Y� 3+:�\� ��@B�E� � � Q+~� 3+� ��_� � ȸ �� � � ++~� 3+� 7�_+� ��_� � � E W+~� 3� � +a� 3� +�� 3+� 7�_� � c� �� � �+�� 3+� 7*�&2� � ȸ �� � � &+~� 3+� 7*�&2�i� E W+~� 3� �+� 7*�&2� � ȸ �� � � �+~� 3+k+� 7*�&2� � �n�s�2� � � &+~� 3+� 7*�&2�v� E W+~� 3� $+~� 3+� 7*�&2�i� E W+x� 3+z� 3� +�� 3+� 7*�&2� � |� �� � �k+�� 3+� 7*�&2� � K� �� � � �+~� 3+� 7*�&2� � ȸ �� � � &+~� 3+� 7*�&2�� E W+~� 3� �+� 7*�&2� � ȸ �� � � �+~� 3+k+� 7*�&2� � �n�s�2� � � &+~� 3+� 7*�&2��� E W+~� 3� $+~� 3+� 7*�&2�v� E W+�� 3+�� 3� +�� 3� H+� 7*�&2� � K� �� � � '+~� 3+� 7*�&2�v� E W+�� 3� +�� 3� +�� 3+� 7*�&2� � �� �� � � �+�� 3+� 7*�&2� � ȸ �� � � &+~� 3+� 7*�&2��� E W+~� 3� H+� 7*�&2� � ȸ �� � � '+~� 3+� 7*�&2��� E W+�� 3� +�� 3� +�� 3+� 7*�&2� � �� �� � � �+�� 3+� 7*�&
2� � ȸ �� � � &+~� 3+� 7*�&2��� E W+~� 3� �+� 7*�&
2� � ȸ �� � � o+~� 3++� 7*�&
2� � ��� '+Y� 3+� 7*�&2�� E W+~� 3� $+~� 3+� 7*�&2��� E W+�� 3+�� 3� +�� 3� +�� 3+� 7*�&2� � �� �� � ��+�� 3+� 7*�&2� � K� �� � � %+~� 3+� 7*�&2ȹ E W+~� 3� +�� 3+� �+� t���� �� �:00� �0�� �0+� 7� =� � � �0� �611�d+01� �+�� 3++� 7*�&2� � �n��+�� 3++� 7*�&2� � �n��+�� 3++� 7*�&2� � �n��+�� 3++� 7*�&2� � �n��+�� 3+� t �� ��:22+� 7*�&2� � �	2��2�W2�� � ��� :3+� t2� �3�+� t2� �+¶ 3++� 7*�&
2� � �n��+Ķ 3++� 7� �� � �n��+ƶ 30���ާ $:404�� :51� +�W0�5�1� +�W0�0�� � ��� :6+� t0� �6�+� t0� �� :7+�"7�+�"+�� 3+� t��ȶ �� �:88ʶ �8� �8� �W8� �� � ��� :9+� t8� �9�+� t8� �+̶ 3� +ζ 3� +ж 3+Ҷ 3+� �++� 7� �� � �n� 3� ::+�":�+�"+Զ 3+� 7*�&2� � |� �� � � -+~� 3+� �+ֶ 3� :;+�";�+�"+~� 3� +�� 3+� 7*�&2� � |� �� � � -+~� 3+� �+ض 3� :<+�"<�+�"+~� 3� +�� 3+� 7*�&2� � �� �� � � -+~� 3+� �+ڶ 3� :=+�"=�+�"+~� 3� +�� 3+� 7*�&2� � �� �� � � -+~� 3+� �+ܶ 3� :>+�">�+�"+~� 3� +�� 3+� 7*�&2� � �� �� � � -+~� 3+� �+޶ 3� :?+�"?�+�"+~� 3� +�� 3+� 7*�&2� � � �� � � -+~� 3+� �+� 3� :@+�"@�+�"+~� 3� +�� 3+� 7*�&2� � � �� � � -+~� 3+� �+� 3� :A+�"A�+�"+~� 3� +�� 3+� 7*�&2� � � �� � � -+~� 3+� �+� 3� :B+�"B�+�"+~� 3� +�� 3+� 7*�&2� � � �� � � -+~� 3+� �+� 3� :C+�"C�+�"+~� 3� +� 3+� 3+� 7*�&2� � �� �� � � -+~� 3+� �+�� 3� :D+�"D�+�"+~� 3� N+� 7*�&2� � �� �� � � -+~� 3+� �+�� 3� :E+�"E�+�"+~� 3� +�� 3+�� 3+� 7*�&2� � K� �� � � -+~� 3+� �+�� 3� :F+�"F�+�"+~� 3� N+� 7*�&2� � K� �� � � -+~� 3+� �+ � 3� :G+�"G�+�"+~� 3� +� 3+�� 3+� 7*�&2� � � �� � � -+~� 3+� �+� 3� :H+�"H�+�"+~� 3� N+� 7*�&2� � � �� � � -+~� 3+� �+� 3� :I+�"I�+�"+~� 3� +
� 3+�� 3+� 7*�&2� � � �� � � -+~� 3+� �+� 3� :J+�"J�+�"+~� 3� N+� 7*�&2� � � �� � � -+~� 3+� �+� 3� :K+�"K�+�"+~� 3� +� 3+� 3+� 3+� �++� 7*�&2� � �n� 3� :L+�"L�+�"+� 3+� �++� 7� �� � �n� 3� :M+�"M�+�"+� 3+� �++� 7*�&2� � �n� 3� :N+�"N�+�"+� 3+� 3+� �+ � 3++� 7*�&2� � �n� 3+"� 3� :O+�"O�+�"+$� 3+� �+&� 3++� 7*�&2� � �n� 3+"� 3� :P+�"P�+�"+(� 3+*� 3+� 7*�&2� � K� �� � � -+~� 3+� �+,� 3� :Q+�"Q�+�"+�� 3� l+� 7*�&2� � K� �� � � K+~� 3+� �+.� 3++� 7*�&2� � �n� 3+0� 3� :R+�"R�+�"+~� 3� +2� 3+� �+4� 3++� 7*�&2� � �n� 3+"� 3� :S+�"S�+�"+6� 3+� �+8� 3++� 7*�&
2� � �n� 3+"� 3� :T+�"T�+�"+:� 3+<� 3+>� 3+@� 3+� �+B� 3� :U+�"U�+�"+D� 3+F� 3+H� 3+� 7*�&2++�MO�T� E W+~� 3+� �+� t��V� �� �:VV� �VX� �V+� 7� =� � � �V� �6WW� O+VW� �+Z� 3V���� $:XVX�� :YW� +�WV�Y�W� +�WV�V�� � ��� :Z+� tV� �Z�+� tV� �� :[+�"[�+�"+~� 3+� �+� t��\� �� �:\\� �\^� �\+� 7� =� � � �\� �6]]� O+\]� �+`� 3\���� $:^\^�� :_]� +�W\�_�]� +�W\�\�� � ��� :`+� t\� �`�+� t\� �� :a+�"a�+�"+~� 3+� �+b� 3++�f*�&2�i �n� 3+k� 3+++� 7*�&2�) �n�9�n� 3+p� 3+++� 7*�&2�) �n�9�n� 3+r� 3++� 7*�&2� � �n� 3+t� 3� :b+�"b�+�"+v� 3� 4���  99  ���  ���  u�� )u��  B,,  /FF  ���  ���  � )�$'  �]]  �ww  ���    Waa  ���  �  MWW  ���  ���  CMM  ���  ���  @JJ  ���  ���  /99  ���  ���  ,66  w��  ���  ���  ((  Gnn  ���  ���  >ff  ���  ���  &&  ��� )���  �  n%%  ��� )���  P��  <��  
��   �         * +  �     
       ! F $ G - Y � Z � [I ]k ^� _� `� aS by c� d� e� f h i k l n% o( qx r� sV u v� x  z| {� |� }� ~� �w �� �� �� �� �r �� �� �� �� �o �� �� �� �� �	k �	� �	� �	� �	� �
k �
� �
� �
� �
� �P �u �� �� �� �� �� �� � �1 �Z �� �� �� �� �� �� �� �� �� �& �M �g �� �� �� �� �� � � � � �9 �T �Z �^ �d �h �� �� �� �� � � �  �& �) �Q �x �� �� �� �� �� � � � �% �) �/ �3 �[ �� �� �� �� � �1 �N l����
�����+(,+8P9[:n;q<z>�?�@�A�B�D�E�FGHJFKQLdMgNpP�Q�R�S�T�V�W�XYZ\<]G^Z_]`fb�c�d�e�f�h�i�j�kl{|�9�D�W�Z�������������������������(�3�F�I�S�V�Z�]������������������������%�0�C�F�p�{��������
9<� �,�-�.�/
0273B4`5v6�C�M]^�7�H�g���5������     ) wx �        �    �     ) yz �         �    �     ) {| �        �    �    ~    �   �     �*� �Y���SY���SY6��SY���SYG��SY���SYI��SY���SY���SY	P��SY
���SY���SY���SY���SY���SY���SY���SY���S�&�     �    