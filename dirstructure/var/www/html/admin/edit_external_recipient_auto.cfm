����   2 #edit_external_recipient_auto_cfm$cf  lucee/runtime/PageImpl  '/admin/edit_external_recipient_auto.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength      �S getCompileTime  n��[ getHash ()I��, call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this %Ledit_external_recipient_auto_cfm$cf;
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Edit External Recipient Auto</title>
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
 F</head>
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
               H <td height="131" width="988">
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
                     J</td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="406" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 406px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="970">
                        <tr valign="top" align="left">
                          <td width="14" height="18"></td>
                          <td width="1"></td>
                          <td width="506"></td>
                          <td width="445"></td>
                          <td width="1"></td>
                          <td width="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                           L�<td width="506" id="Text369" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Edit External Encrypted Recipient</span></b></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="6" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="208"></td>
                          <td colspan="3" width="952"> N StartRow P &lucee/runtime/config/NullSupportHelper R NULL T '
 S U -lucee/runtime/interpreter/VariableInterpreter W getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; Y Z
 X [ 1 ] %lucee/runtime/exp/ExpressionException _ java/lang/StringBuilder a The required parameter [ c  1
 b e append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; g h
 b i ] was not provided. k -(Ljava/lang/String;)Ljava/lang/StringBuilder; g m
 b n toString ()Ljava/lang/String; p q
 b r
 ` e lucee/runtime/PageContextImpl u any w�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V { |
 v } 
 @       keys $[Llucee/runtime/type/Collection$Key; � �	  � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � urlScope  ()Llucee/runtime/type/scope/URL; � �
 / � lucee/runtime/type/scope/URL � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � �   � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � 

 � DisplayRows � 10 � show � _show � ;	 9 � filter � _FILTER � ;	 9 � 


 � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 v � lucee/runtime/tag/Query � getencryption � setName � 1
 � � A � setDatasource (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � 3
select * from external_recipients where email = ' � lucee/runtime/op/Caster � &(Ljava/lang/Object;)Ljava/lang/String; p �
 � � writePSQ � �
 / � '
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 v � 	outputEnd � 
 / � getCollection � � A  #lucee/runtime/util/VariableUtilImpl recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;
 (Ljava/lang/Object;D)I �
 �	 lucee.runtime.tag.Location 
cflocation lucee/runtime/tag/Location 	error.cfm setUrl 1

 �
 � action  
@       _action ;	 9 	formScope !()Llucee/runtime/type/scope/Form;!"
 /# _ACTION% ;	 9& lucee/runtime/type/scope/Form() � 



+ 
show_email-  


/ show_encryption_mode1 pdf_mandatory3 edit5 sessionScope $()Llucee/runtime/type/scope/Session;78
 /9 insert;  lucee/runtime/type/scope/Session=> D create_recipient2.cfm?StartRow=@ java/lang/StringB concat &(Ljava/lang/String;)Ljava/lang/String;DE
CF &DisplayRows=H &filter=J &show=L pdf_by_subjectN smime_mandatoryP create_recipient3.cfm?StartRow=R smime_by_subjectT pgp_mandatoryV create_recipient5.cfm?StartRow=X pgp_by_subjectZ
                            <table border="0" cellspacing="0" cellpadding="0" width="952" id="LayoutRegion17" style="height: 208px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" enctype="multipart/form-data" action="" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="952">
                                          <table id="Table76" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 137px;">
                                            <tr style="height: 14px;">
                                              <td width="948" id="Cell466">
                                                <p style="margin-bottom: 0px;">\}<b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Specify E-Mail Address</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 26px;">
                                              <td id="Cell473">
                                                <table width="581" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table72" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 26px;">
                                                        <tr style="height: 26px;">
                                                          <td width="576" id="Cell390">
                                                            <table width="576" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              ^ J<tr>
                                                                <td>` �<input type="text" id="FormsEditField23" name="user" size="72" maxlength="72" disabled="disabled" style="width: 572px; white-space: pre;" value="b ">d </td>
                                                              </tr>
                                                            </table>
                                                          </td>
                                                          <td width="5" id="Cell391">
                                                            <p style="margin-bottom: 0px;">&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 19px;">
                                              <td id="Cell422">
                                                f=<p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);"></span>
                                                  <table width="584" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        <table id="Table83" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 19px;">
                                                          <tr style="height: 19px;">
                                                            <td width="416" id="Cell479">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Select Encryption Type</span></b></p>
                                                            </td>
                                                            h5<td width="168" id="Cell480">
                                                              <p style="margin-bottom: 0px;">&nbsp;</p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  </b>&nbsp;</td>
                                              </tr>
                                              <tr style="height: 102px;">
                                                <td id="Cell468">
                                                  <table width="580" border="0" cellspacing="0" cellpadding="0" align="left">
                                                    <tr>
                                                      <td>
                                                        j�<table id="Table82" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 68px;">
                                                          <tr style="height: 17px;">
                                                            <td width="47" id="Cell469">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                <tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">l z
<input type="radio" checked="checked" name="encryption_mode" value="pdf_mandatory" style="height: 13px; width: 13px;">
n h
<input type="radio" name="encryption_mode" value="pdf_mandatory" style="height: 13px; width: 13px;">
ps

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td width="533" id="Cell470">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Mandatory PDF Encryption </span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell636">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                r �<tr>
                                                                  <td class="TextObject">
                                                                    <p style="margin-bottom: 0px;">t {
<input type="radio" checked="checked" name="encryption_mode" value="pdf_by_subject" style="height: 13px; width: 13px;">
v i
<input type="radio" name="encryption_mode" value="pdf_by_subject" style="height: 13px; width: 13px;">
x�

&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell635">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">PDF Encryption Triggered by E-mail Subject Keyword</span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell471">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                z �

<input type="radio" checked="checked" name="encryption_mode" value="smime_mandatory" style="height: 13px; width: 13px;">

| n

<input type="radio" name="encryption_mode" value="smime_mandatory" style="height: 13px; width: 13px;">

~l


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell472">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Mandatory S/MIME Encryption </span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell477">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                � �

<input type="radio" checked="checked" name="encryption_mode" value="smime_by_subject" style="height: 13px; width: 13px;">

� o

<input type="radio" name="encryption_mode" value="smime_by_subject" style="height: 13px; width: 13px;">

��
&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell478">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">S/MIME Encryption Triggered by E-mail Subject Keyword </span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell1070">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                � ~

<input type="radio" checked="checked" name="encryption_mode" value="pgp_mandatory" style="height: 13px; width: 13px;">

� l

<input type="radio" name="encryption_mode" value="pgp_mandatory" style="height: 13px; width: 13px;">

�k


&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1071">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Mandatory PGP Encryption </span></b></p>
                                                            </td>
                                                          </tr>
                                                          <tr style="height: 17px;">
                                                            <td id="Cell1072">
                                                              <table width="30" border="0" cellspacing="0" cellpadding="0" align="left">
                                                                � 

<input type="radio" checked="checked" name="encryption_mode" value="pgp_by_subject" style="height: 13px; width: 13px;">

� m

<input type="radio" name="encryption_mode" value="pgp_by_subject" style="height: 13px; width: 13px;">

�7
&nbsp;</p>
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              &nbsp;</td>
                                                            <td id="Cell1073">
                                                              <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">PGP Encryption Triggered by E-mail Subject Keyword </span></b></p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                �g</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                      <table border="0" cellspacing="0" cellpadding="0">
                                        <tr valign="top" align="left">
                                          <td height="6"></td>
                                        </tr>
                                        <tr valign="top" align="left">
                                          <td width="952">
                                            <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                              <tr style="height: 24px;">
                                                <td width="952" id="Cell518">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    �2<tr>
                                                      <td align="center">
                                                        <table width="360" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Continue" style="height: 24px; width: 357px;">
&nbsp;</p>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                �</td>
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
                            <td></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="6" height="2"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td colspan="2" height="30"></td>
                            <td colspan="2" valign="middle" width="951"><hr id="HRRule7" width="951" size="1"></td>
                            <td colspan="2"></td>
                          </tr>
                          ��<tr valign="top" align="left">
                            <td colspan="6" height="3"></td>
                          </tr>
                          <tr valign="top" align="left">
                            <td height="40"></td>
                            <td colspan="5" width="956">

                              <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                                <tr align="left" valign="top">
                                  <td>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="956">
                                          <form name="apply_settings" action="� 'external_encryption_users.cfm?StartRow=��" method="post">
                                            <table id="Table191" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                              <tr style="height: 24px;">
                                                <td width="956" id="Cell1031">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr>
                                                      <td align="center">
                                                        <table width="360" border="0" cellspacing="0" cellpadding="0">
                                                          <tr>
                                                            <td class="TextObject">
                                                              <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to External Recipients Encryption" style="height: 24px; width: 357px;">
&nbsp;�</p>
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
                  �T</table>
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
                          </tr>
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
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway �> � 	 Version:� _VALUE� ;	 9� I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; ��
 /�  Build:� . Copyright 2011-� l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>�c
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
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� STARTROW� DISPLAYROWS� SHOW� EMAIL� GETENCRYPTION� encryption_mode� ENCRYPTION_MODE� SHOW_ENCRYPTION_MODE� MODE� 
SHOW_EMAIL� THEYEAR� EDITION� 
GETVERSION� GETBUILD� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��           *     *� 
*� *� � *�Ե�*+�۱                  �                 � �                  �                  �                   !�      # $          %�      & '    �  D  +-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q+� V� \M>+� V,� .^Y:� !� `Y� bYd� fQ� jl� o� s� t�M>+� vxQ, y y� ~+�� 3+ �*� �2� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� V� \:6+� V� 0�Y:� !� `Y� bYd� f�� jl� o� s� t�:6+� vx� y y� ~+�� 3+ �*� �2� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� V� \:6	+� V� 0�Y:
� !� `Y� bYd� f�� jl� o� s� t�
:6	+� vx� y y	� ~+�� 3+ �� �� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� V� \:6+� V� 0�Y:� !� `Y� bYd� f�� jl� o� s� t�:6+� vx� y y� ~+�� 3+ �*� �2� �� ��� �� � � Q+�� 3+� �� �� � �� �� � � ++�� 3+� 7� �+� �� �� � � E W+�� 3� � +�� 3+� �+� v��� �� �:Ŷ �+� 7� =� � � �� �6� k+� �+ֶ 3++� �*� �2� � � ۶ �+� 3� ���ק $:� � :� +� �W� ��� +� �W� �� �� � ��� :+� v� ��+� v� �� :+� ��+� �+�� 3++� 7*� �2� ��
� � � [+�� 3+� v� ��:��W�� � ��� :+� v� ��+� v� �+�� 3� +�� 3++� V� \:6+� V� 1�Y:� "� `Y� bYd� f� jl� o� s� t�:6+� vx y y� ~+� 3+� � �� ��� �� � � Q+�� 3+�$�'�* �� �� � � ++�� 3+� 7�'+�$�'�* � E W+�� 3� � +,� 3+.+� V� \:6+� V� ?+� �*� �2� � Y:� "� `Y� bYd� f.� jl� o� s� t�:6+� vx. y y� ~+0� 3+2+� V� \:6+� V� 24Y:� "� `Y� bYd� f2� jl� o� s� t�:6+� vx2 y y� ~+� 3+*� �2� �� ��� �� � � d+�� 3+�$*� �	2�* �� �� � � 3+�� 3+� 7*� �
2+�$*� �	2�* � E W+�� 3� +� 3� +�� 3+� 7�'� � 6� �� � �h+�� 3+�:*� �2<�? W+�� 3+�:*� �2+� 7*� �2� � �? W+�� 3+�:*� �	2+� 7*� �
2� � �? W+�� 3+� 7*� �
2� � 4� �� � � �+�� 3+� �+�� 3+� v� ��:A+� 7*� �2� � � ۶GI�G+� 7*� �2� � � ۶GK�G+� 7� �� � � ۶GM�G+� 7*� �2� � � ۶G��W�� � ��� : +� v� � �+� v� �+�� 3� :!+� �!�+� �+�� 3��+� 7*� �
2� � O� �� � � �+�� 3+� �+�� 3+� v� ��:""A+� 7*� �2� � � ۶GI�G+� 7*� �2� � � ۶GK�G+� 7� �� � � ۶GM�G+� 7*� �2� � � ۶G�"�W"�� � ��� :#+� v"� �#�+� v"� �+�� 3� :$+� �$�+� �+�� 3��+� 7*� �
2� � Q� �� � � �+�� 3+� �+�� 3+� v� ��:%%S+� 7*� �2� � � ۶GI�G+� 7*� �2� � � ۶GK�G+� 7� �� � � ۶GM�G+� 7*� �2� � � ۶G�%�W%�� � ��� :&+� v%� �&�+� v%� �+�� 3� :'+� �'�+� �+�� 3��+� 7*� �
2� � U� �� � � �+�� 3+� �+�� 3+� v� ��:((S+� 7*� �2� � � ۶GI�G+� 7*� �2� � � ۶GK�G+� 7� �� � � ۶GM�G+� 7*� �2� � � ۶G�(�W(�� � ��� :)+� v(� �)�+� v(� �+�� 3� :*+� �*�+� �+�� 3��+� 7*� �
2� � W� �� � � �+�� 3+� �+�� 3+� v� ��:++Y+� 7*� �2� � � ۶GI�G+� 7*� �2� � � ۶GK�G+� 7� �� � � ۶GM�G+� 7*� �2� � � ۶G�+�W+�� � ��� :,+� v+� �,�+� v+� �+�� 3� :-+� �-�+� �+�� 3� +� 7*� �
2� � [� �� � � �+�� 3+� �+�� 3+� v� ��:..Y+� 7*� �2� � � ۶GI�G+� 7*� �2� � � ۶GK�G+� 7� �� � � ۶GM�G+� 7*� �2� � � ۶G�.�W.�� � ��� :/+� v.� �/�+� v.� �+�� 3� :0+� �0�+� �+�� 3� +�� 3� +]� 3+_� 3+a� 3+� �+c� 3++� 7*� �2� � � ۶ 3+e� 3� :1+� �1�+� �+g� 3+i� 3+k� 3+m� 3+� 7*� �
2� � 4� �� � � -+�� 3+� �+o� 3� :2+� �2�+� �+�� 3� O+� 7*� �
2� � 4� �� � � -+�� 3+� �+q� 3� :3+� �3�+� �+�� 3� +s� 3+u� 3+� 7*� �
2� � O� �� � � -+�� 3+� �+w� 3� :4+� �4�+� �+�� 3� O+� 7*� �
2� � O� �� � � -+�� 3+� �+y� 3� :5+� �5�+� �+�� 3� +{� 3+u� 3+� 7*� �
2� � Q� �� � � +}� 3� /+� 7*� �
2� � Q� �� � � +� 3� +�� 3+u� 3+� 7*� �
2� � U� �� � � +�� 3� /+� 7*� �
2� � U� �� � � +�� 3� +�� 3+u� 3+� 7*� �
2� � W� �� � � +�� 3� /+� 7*� �
2� � W� �� � � +�� 3� +�� 3+u� 3+� 7*� �
2� � [� �� � � +�� 3� /+� 7*� �
2� � [� �� � � +�� 3� +�� 3+�� 3+�� 3+�� 3+�� 3+� �+�� 3++� 7*� �2� � � ۶ 3+I� 3++� 7*� �2� � � ۶ 3+M� 3++� 7*� �2� � � ۶ 3+K� 3++� 7� �� � � ۶ 3� :6+� �6�+� �+�� 3+�� 3+�� 3+� 7*� �2++������ E W+�� 3+� �+� v��� �� �:77�� �7+� 7� =� � � �7� �688� O+78� �+�� 37� ���� $:979� � ::8� +� �W7� �:�8� +� �W7� �7� �� � ��� :;+� v7� �;�+� v7� �� :<+� �<�+� �+�� 3+� �+� v��� �� �:==�� �=+� 7� =� � � �=� �6>>� O+=>� �+�� 3=� ���� $:?=?� � :@>� +� �W=� �@�>� +� �W=� �=� �� � ��� :A+� v=� �A�+� v=� �� :B+� �B�+� �+�� 3+� �+�� 3++�:*� �2�� � ۶ 3+�� 3+++� 7*� �2� ���¸ ۶ 3+Ķ 3+++� 7*� �2� ���¸ ۶ 3+ƶ 3++� 7*� �2� � � ۶ 3+ȶ 3� :C+� �C�+� �+ʶ 3�  � )�  �SS  �mm  ���  ��  ���  		�	�  �	�	�  


�
�  	�
�
�  ��  
���  ��  ���  ��  ���  �  Xbb  ���  �  JTT  )��  $47 )$@C  �yy  ���  ��� )�  �>>  �XX  o��            * +    f �          ! O $ P - r 0 s 3 | � } � ~ �  � �	 �k �� �� �� �� �K �o �� �� �� �( �O �r �� �� �� � �} �� �� �� �e �� �� �� �� �L �� �� � �) �3 �< �` �z �� �� �� �� �� �� �� �� �	� �	� �	� �	� �
� �
� �
� �
� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� � � �" %),Q\or������*�+�,�-./0C1N2a3d4n6qBuCxD�F�H�J�L�O�[�\�]_
a0c6e:f=rAsDtjvpx�z�|������������������"�%�����(��hs     ) ��          �         ) ��           �         ) ��          �        �        �     �*� �YQ��SY��SY���SY��SY��SY���SY��SY��SY���SY	��SY
��SY��SY���SY���SY���SY���SY���S� ��         