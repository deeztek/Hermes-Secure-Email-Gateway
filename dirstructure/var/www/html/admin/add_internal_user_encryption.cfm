����   2y #add_internal_user_encryption_cfm$cf  lucee/runtime/PageImpl  '/admin/add_internal_user_encryption.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength      �j getCompileTime  n��Y getHash ()I��a� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this %Ladd_internal_user_encryption_cfm$cf;
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Add Internal User Encryption</title>
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
                     J'</td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="525" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 525px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="967">
                        <tr valign="top" align="left">
                          <td width="10" height="13"></td>
                          <td width="1"></td>
                          <td width="505"></td>
                          <td width="450"></td>
                          <td width="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="2" width="506" id="Text373" class="TextObject">
                             L.<p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Edit Internal Recipient Encryption</span></b></p>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="337"></td>
                          <td colspan="4" width="957"> N m P &lucee/runtime/config/NullSupportHelper R NULL T '
 S U -lucee/runtime/interpreter/VariableInterpreter W getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; Y Z
 X [ 0 ] %lucee/runtime/exp/ExpressionException _ java/lang/StringBuilder a The required parameter [ c  1
 b e append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; g h
 b i ] was not provided. k -(Ljava/lang/String;)Ljava/lang/StringBuilder; g m
 b n toString ()Ljava/lang/String; p q
 b r
 ` e lucee/runtime/PageContextImpl u any w�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V { |
 v } 
  m2 � m3 � step � url.id � #lucee/commons/color/ConstantsDouble � _0 Ljava/lang/Double; � �	 � � numeric � 

 � StartRow �   �@       keys $[Llucee/runtime/type/Collection$Key; � �	  � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � urlScope  ()Llucee/runtime/type/scope/URL; � �
 / � lucee/runtime/type/scope/URL � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � DisplayRows � show � _show � ;	 9 � filter � _FILTER � ;	 9 � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 v � lucee/runtime/tag/Query � getrecipientdetails � setName � 1
 � � A � setDatasource (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � (
select * from recipients where 
id =  � lucee.runtime.tag.QueryParam � cfqueryparam � lucee/runtime/tag/QueryParam � _ID � ;	 9 � setValue � �
 � � CF_SQL_INTEGER � setCfsqltype � 1
 � �
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V 
 v doAfterBody $
 � doCatch (Ljava/lang/Throwable;)V
 �	 popBody ()Ljavax/servlet/jsp/JspWriter;
 / 	doFinally 
 �
 � � 	outputEnd 
 / 
 
 action  
@       _action ;	 9 	formScope !()Llucee/runtime/type/scope/Form;!"
 /# _ACTION% ;	 9& lucee/runtime/type/scope/Form() � show_smime_certificate_name+ getCollection- � A. I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �0
 /1  

3 show_pdf_enabled5 show_smime_enabled7 show_pgp_enabled9 	 



; 	show_sign= 



? editA lucee/runtime/op/CasterC &(Ljava/lang/Object;)Ljava/lang/String; pE
DF [^A-Za-z0-9]+H allJ (lucee/runtime/functions/string/REReplaceL w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &N
MO customtransQ getrandom_resultsS 	setResultU 1
 �V Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
X inserttransZ stResult\ &
insert into salt
(salt)
values
('^ getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;`a
 /b getIdd $
 /e lucee/runtime/type/Queryg getCurrentrow (I)Iijhk getRecordcountm $hn !lucee/runtime/util/NumberIteratorp load '(II)Llucee/runtime/util/NumberIterator;rs
qt addQuery (Llucee/runtime/type/Query;)Vvw Ax isValid (I)Zz{
q| current~ $
q go (II)Z��h� #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� writePSQ� �
 /� removeQuery�  A� release &(Llucee/runtime/util/NumberIterator;)V��
q� ')
� gettrans� 2
select salt as customtrans2 from salt where id='� '
� deletetrans� 
delete from salt where id='� 2� update� :
update recipients
set 
configured='1',
digital_sign='� ',
smime_enabled='� ',
pdf_enabled='� ',
pgp_enabled='� '
where
id = � 






� lucee.runtime.tag.FileTag� cffile� lucee/runtime/tag/FileTag� hasBody (Z)V��
�� read� 	setAction� 1
�� */opt/hermes/scripts/create_intrecipient.sh� setFile� 1
�� temp� setVariable� 1
��
� �
� � 0 /opt/hermes/scripts/� java/lang/String� concat &(Ljava/lang/String;)Ljava/lang/String;��
�� _create_intrecipient.sh� THE-RECIPIENT� ALL� 	setOutput� �
�� setAddnewline��
�� lucee.runtime.tag.Execute� 	cfexecute� lucee/runtime/tag/Execute� 
/bin/chmod�
� � +x /opt/hermes/scripts/� setArguments� �
��@N       
setTimeout (D)V��
��
� �
�
� �@n       	/dev/null� setOutputfile� 1
�� -inputformat none� 


  delete updatedjigzo djigzo D
update cm_users
set 
cm_locality='internal'
where
cm_email = ' 1
 )
update recipients
set 
digital_sign=' 
    
    
 2/opt/hermes/scripts/configure_intrecipient_sign.sh _configure_intrecipient_sign.sh THE-SIGN false 
    
 
  
 true 
    

 



 ./opt/hermes/scripts/enable_intrecipient_pdf.sh  _enable_intrecipient_pdf.sh" //opt/hermes/scripts/disable_intrecipient_pdf.sh$ _disable_intrecipient_pdf.sh&     

    
( 7/opt/hermes/scripts/enable_intrecipient_smime_nocert.sh* $_enable_intrecipient_smime_nocert.sh, 

 
. 
   
0 1/opt/hermes/scripts/disable_intrecipient_smime.sh2 _disable_intrecipient_smime.sh4 

   
  
6 


    
8 5/opt/hermes/scripts/enable_intrecipient_pgp_nocert.sh: "_enable_intrecipient_pgp_nocert.sh< //opt/hermes/scripts/disable_intrecipient_pgp.sh> _disable_intrecipient_pgp.sh@ getcertsB 7
select * from recipient_certificates where user_id = D #lucee/runtime/util/VariableUtilImplF recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;HI
GJ (Ljava/lang/Object;D)I �L
 �M _1O �	 �P getkeysR 4
select * from recipient_keystores where user_id = T _MV ;	 9W /etc/init.d/postfixY stop[ /etc/init.d/amavis] 	dropusers_ 
drop table users
a createusersc &
CREATE TABLE users LIKE recipients
e 	copyusersg .
INSERT INTO users SELECT * FROM recipients
i 
alterusersk ;
alter table users change recipient email VARBINARY(255)
m startoF





 

                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion17" style="height: 337px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" action="q $add_internal_user_encryption.cfm?id=s 
&StartRow=u &DisplayRows=w &show=y &filter={" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="595">
                                          <table id="Table138" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 137px;">
                                            <tr style="height: 14px;">
                                              <td width="595" id="Cell973">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Internal Recipient</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              }j<td id="Cell972">
                                                <table width="541" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"> �
<input type="text" id="FormsEditField30" name="recipient" size="45" maxlength="255" disabled="disabled" style="width: 356px;
 white-space: pre;" value="� ">
�>&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell901">
                                                <p style="margin-bottom: 0px;"><span style="color: rgb(51,51,51);"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">PDF Encryption</span></b></span></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell902">
                                                <table width="535" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  �<tr>
                                                    <td>
                                                      <table id="Table133" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 29px;">
                                                        <tr style="height: 17px;">
                                                          <td width="46" id="Cell797">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� j
<input type="radio" checked="checked" name="pdf_enabled" value="1" style="height: 13px; width: 13px;">
� X
<input type="radio" name="pdf_enabled" value="1" style="height: 13px; width: 13px;">
�U







&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="489" id="Cell798">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell799">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              � �<tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� j
<input type="radio" checked="checked" name="pdf_enabled" value="2" style="height: 13px; width: 13px;">
� X
<input type="radio" name="pdf_enabled" value="2" style="height: 13px; width: 13px;">
�.





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell800">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            �</tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell903">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">S/MIME Encryption</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell904">
                                                <table width="532" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table134" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 12px;">
                                                        ��<tr style="height: 17px;">
                                                          <td width="45" id="Cell803">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� l
<input type="radio" checked="checked" name="smime_enabled" value="1" style="height: 13px; width: 13px;">
� Z
<input type="radio" name="smime_enabled" value="1" style="height: 13px; width: 13px;">
�S






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="487" id="Cell804">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell934">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              � l
<input type="radio" checked="checked" name="smime_enabled" value="2" style="height: 13px; width: 13px;">
� Z
<input type="radio" name="smime_enabled" value="2" style="height: 13px; width: 13px;">
�0






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell935">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            �\</tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell905">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">S/MIME Encryption Mode <span style="font-weight: normal;">(Not implemented)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell906">
                                                <table width="532" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table137" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 5px;">
                                                        ��<tr style="height: 17px;">
                                                          <td width="45" id="Cell818">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� }
<input type="radio" checked="checked" name="smime_mode" value="2" style="height: 13px; width: 13px;" disabled="disabled">
�P





&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="487" id="Cell819">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Normal</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell820">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              �<tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;"><input type="radio" name="smime_mode" value="2" style="height: 13px; width: 13px;" disabled="disabled">






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell821">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Paranoid</span></b></p>
                                                          </td>
                                                        �:</tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell968">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Digital Signature <span style="font-weight: normal;">(Applies only if S/MIME Certificate is present)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell969">
                                                ��<table width="539" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table105" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 12px;">
                                                        <tr style="height: 17px;">
                                                          <td width="48" id="Cell634">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� c
<input type="radio" checked="checked" name="sign" value="1" style="height: 13px; width: 13px;">
� Q
<input type="radio" name="sign" value="1" style="height: 13px; width: 13px;">
�d
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="491" id="Cell635">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Digitally Sign ALL Outgoing Messages</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell636">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              � c
<input type="radio" checked="checked" name="sign" value="2" style="height: 13px; width: 13px;">
� Q
<input type="radio" name="sign" value="2" style="height: 13px; width: 13px;">
�
&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell637">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Digitally Sign ONLY Encrypted Outgoing Messages</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              �L</td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell970">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PGP Encryption</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                              <td id="Cell971">
                                                <table width="532" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td>
                                                      <table id="Table148" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 12px;">
                                                        ��<tr style="height: 17px;">
                                                          <td width="45" id="Cell1019">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              <tr>
                                                                <td class="TextObject">
                                                                  <p style="margin-bottom: 0px;">� j
<input type="radio" checked="checked" name="pgp_enabled" value="1" style="height: 13px; width: 13px;">
� X
<input type="radio" name="pgp_enabled" value="1" style="height: 13px; width: 13px;">
�U






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td width="487" id="Cell1020">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Enabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                        <tr style="height: 17px;">
                                                          <td id="Cell1021">
                                                            <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                              � j
<input type="radio" checked="checked" name="pgp_enabled" value="2" style="height: 13px; width: 13px;">
� X
<input type="radio" name="pgp_enabled" value="2" style="height: 13px; width: 13px;">
� 






&nbsp;</p>
                                                                </td>
                                                              </tr>
                                                            </table>
                                                            &nbsp;</td>
                                                          <td id="Cell1022">
                                                            <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Disabled</span></b></p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </�Gtd>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="16"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957">
                                          <table id="Table136" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                            <tr style="height: 17px;">
                                              <td width="957" id="Cell815">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  �0<tr>
                                                    <td align="center">
                                                      <table width="277" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Saving and Applying Changes, please wait...';this.form.submit();" name="savechanges" value="Save and Apply Changes" style="height: 24px; width: 275px;">
&nbsp;</p>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </td>
                                                  </tr>
                                                </table>
                                              �</td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="957">
                                      <tr valign="top" align="left">
                                        <td width="957" height="7"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="957" id="Text386" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;">�h
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! Changes saved and applied</span></i></b></p>
�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;WARNING: The system has detected that you have enabled S/MIME encryption without a S/MIME certificate present for this recipient. S/MIME encryption will not work until a certificate is created or imported for this recipient</span></i></b></p>
�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;WARNING: The system has detected that you have enabled PGP encryption without a PGP Keystore present for this recipient. PGP encryption will not work until a PGP Keystore is created or imported for this recipient</span></i></b></p>
�&nbsp;</p>
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
                          <td colspan="5" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="30"></td>
                          <td colspan="2" valign="middle" width="955"><hr id="HRRule15" width="955" size="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="5" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          �<td colspan="2" height="40"></td>
                          <td colspan="3" width="956">

                            <table border="0" cellspacing="0" cellpadding="0" width="956" id="LayoutRegion18" style="height: 40px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="7"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="956">
                                        <form name="apply_settings" action="� !internal_encryption_users.cfm?id=�l" method="post">
                                          <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 24px;">
                                            <tr style="height: 24px;">
                                              <td width="956" id="Cell518">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td align="center">
                                                      <table width="360" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td class="TextObject">
                                                            <p style="text-align: left; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Internal Recipients Encryption" style="height: 24px; width: 357px;">
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
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion33" style="background-image: url('./bottom_988.png'); height: 49px;">
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
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway � sessionScope $()Llucee/runtime/type/scope/Session;� 
 /  lucee/runtime/type/scope/Session � 	 Version: _VALUE ;	 9	  Build: . Copyright 2011- l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>C
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
 ���� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException  lucee/runtime/type/UDFProperties udfs #[Llucee/runtime/type/UDFProperties;	  setPageSource! 
 " lucee/runtime/type/KeyImpl$ intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;&'
%( STARTROW* DISPLAYROWS, SHOW. GETRECIPIENTDETAILS0 SMIME_CERTIFICATE_NAME2 PDF_ENABLED4 pdf_enabled6 SHOW_PDF_ENABLED8 SMIME_ENABLED: smime_enabled< SHOW_SMIME_ENABLED> PGP_ENABLED@ pgp_enabledB SHOW_PGP_ENABLEDD DIGITAL_SIGNF signH SIGNJ 	SHOW_SIGNL 	RCPT_NAMEN 	RECIPIENTP RANDOMR STRESULTT GENERATED_KEYV CUSTOMTRANS3X GETTRANSZ CUSTOMTRANS2\ 
CONFIGURED^ TEMP` GETCERTSb M2d GETKEYSf M3h THEYEARj EDITIONl 
GETVERSIONn GETBUILDp subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   rs       t   *     *� 
*� *� � *�� *+�#�        t         �        t        � �        t         �        t         �         t         !�      # $ t        %�      & ' t  \k ^  N�+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O� 3+Q+� V� \M>+� V,� .^Y:� !� `Y� bYd� fQ� jl� o� s� t�M>+� vxQ, y y� ~+�� 3+�+� V� \:6+� V� 0^Y:� !� `Y� bYd� f�� jl� o� s� t�:6+� vx� y y� ~+�� 3+�+� V� \:6	+� V� 0^Y:
� !� `Y� bYd� f�� jl� o� s� t�
:6	+� vx� y y	� ~+�� 3+�+� V� \:6+� V� 0^Y:� !� `Y� bYd� f�� jl� o� s� t�:6+� vx� y y� ~+�� 3+�+� V� \:6+� V� 1� �Y:� !� `Y� bYd� f�� jl� o� s� t�:6+� v�� y y� ~+�� 3+�+� V� \:6+� V� 0�Y:� !� `Y� bYd� f�� jl� o� s� t�:6+� vx� y y� ~+�� 3+ �*� �2� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� V� \:6+� V� 0�Y:� !� `Y� bYd� f�� jl� o� s� t�:6+� vx� y y� ~+�� 3+ �*� �2� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� V� \:6+� V� 0�Y:� !� `Y� bYd� f�� jl� o� s� t�:6+� vx� y y� ~+�� 3+ �� �� �� ��� �� � � Z+�� 3+� �*� �2� � �� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� � +�� 3+�+� V� \:6+� V� 0�Y:� !� `Y� bYd� f�� jl� o� s� t�:6+� vx� y y� ~+�� 3+ �*� �2� �� ��� �� � � Q+�� 3+� �� Ĺ � �� �� � � ++�� 3+� 7� �+� �� Ĺ � � E W+�� 3� � +�� 3+� �+� v��� �� �:Ӷ �+� 7� =� � � �� �6� �+� �+� 3+� v��� �� �:+� �� �� � � �� �� �W� �� � ��� : +� v� �+� v�+�� 3����� $:!!�
� :"� +�W�"�� +�W��� � ��� :#+� v�#�+� v�� :$+�$�+�+� 3++� V� \:%6&+� V%� 1�Y:'� "� `Y� bYd� f� jl� o� s� t�':%6&+� vx% y y&� ~+� 3+� � �� ��� �� � � Q+�� 3+�$�'�* �� �� � � ++�� 3+� 7�'+�$�'�* � E W+�� 3� � +�� 3+,+� V� \:(6)+� V(� J++� 7*� �2�/ *� �2�2Y:*� "� `Y� bYd� f,� jl� o� s� t�*:(6)+� vx,( y y)� ~+4� 3+6+� V� \:+6,+� V+� J++� 7*� �2�/ *� �2�2Y:-� "� `Y� bYd� f6� jl� o� s� t�-:+6,+� vx6+ y y,� ~+� 3+*� �	2� �� ��� �� � � ]+�� 3+�$*� �2�* �� �� � � 3+�� 3+� 7*� �
2+�$*� �2�* � E W+�� 3� � +�� 3+8+� V� \:.6/+� V.� J++� 7*� �2�/ *� �2�2Y:0� "� `Y� bYd� f8� jl� o� s� t�0:.6/+� vx8. y y/� ~+� 3+*� �2� �� ��� �� � � ]+�� 3+�$*� �2�* �� �� � � 3+�� 3+� 7*� �2+�$*� �2�* � E W+�� 3� � +4� 3+:+� V� \:162+� V1� J++� 7*� �2�/ *� �2�2Y:3� "� `Y� bYd� f:� jl� o� s� t�3:162+� vx:1 y y2� ~+� 3+*� �2� �� ��� �� � � ]+�� 3+�$*� �2�* �� �� � � 3+�� 3+� 7*� �2+�$*� �2�* � E W+�� 3� � +<� 3+>+� V� \:465+� V4� J++� 7*� �2�/ *� �2�2Y:6� "� `Y� bYd� f>� jl� o� s� t�6:465+� vx>4 y y5� ~+� 3+*� �2� �� ��� �� � � ]+�� 3+�$*� �2�* �� �� � � 3+�� 3+� 7*� �2+�$*� �2�* � E W+�� 3� � +@� 3+� 7�'� � B� �� � �7+�� 3+� 7*� �2+++� 7*� �2�/ *� �2�2�GI�K�P� E W+�� 3+� �+� v��� �� �:77R� �7+� 7� =� � � �7T�W7� �688� O+78� �+Y� 37���� $:979�
� ::8� +�W7�:�8� +�W7�7�� � ��� :;+� v7�;�+� v7�� :<+�<�+�+�� 3+� �+� v��� �� �:==[� �=+� 7� =� � � �=]�W=� �6>>�B+=>� �+_� 3+� �+R�c:@+�f6A@A�l 6B@�o � � � �6CC@�o �u:?+� 7@�y Cd6F?F`�}� D@?��A�� � � � � (?��6F+++� 7*� �2� � �G�������� ":G@BA�� W+� 7�� ?��G�@BA�� W+� 7�� ?��� :H+�H�+�+�� 3=��� � $:I=I�
� :J>� +�W=�J�>� +�W=�=�� � ��� :K+� v=�K�+� v=�� :L+�L�+�+�� 3+� �+� v��� �� �:MM�� �M+� 7� =� � � �M� �6NN� x+MN� �+�� 3+++� 7*� �2�/ *� �2�2�G��+�� 3M���ʧ $:OMO�
� :PN� +�WM�P�N� +�WM�M�� � ��� :Q+� vM�Q�+� vM�� :R+�R�+�+�� 3+� 7*� �2++� 7*� �2�/ *� �2�2� E W+�� 3+� �+� v��� �� �:SS�� �S+� 7� =� � � �S� �6TT� x+ST� �+�� 3+++� 7*� �2�/ *� �2�2�G��+�� 3S���ʧ $:USU�
� :VT� +�WS�V�T� +�WS�S�� � ��� :W+� vS�W�+� vS�� :X+�X�+�+�� 3++� 7*� �2�/ *� �2�2�� �� � �"+�� 3+� �+� v��� �� �:YY�� �Y+� 7� =� � � �Y� �6ZZ�$+YZ� �+�� 3++� 7*� �2� � �G��+�� 3++� 7*� �2� � �G��+�� 3++� 7*� �
2� � �G��+�� 3++� 7*� �2� � �G��+�� 3+� v��� �� �:[[+� �� �� � � �[� �[� �W[� �� � ��� :\+� v[�\�+� v[�+�� 3Y���� $:]Y]�
� :^Z� +�WY�^�Z� +�WY�Y�� � ��� :_+� vY�_�+� vY�� :`+�`�+�+�� 3+� v��� ���:aa��a���a���aŶ�a��Wa��� � ��� :b+� va�b�+� va�+�� 3+� v��� ���:cc��c˶�c�+� 7*� �2� � �G��նӶ�c++� 7*� �2� � �G�++� 7*� �2�/ *� �2�2�GٸP��c��c��Wc��� � ��� :d+� vc�d�+� vc�+�� 3+� v��� ���:ee��e���e�+� 7*� �2� � �G��նӶ�eŶ�e��We��� � ��� :f+� ve�f�+� ve�+�� 3+� v��� ���:gg��g�+� 7*� �2� � �G��նӶ�g��g��6hh� 8+gh� �+�� 3g������ :ih� +�Wi�h� +�Wg��� � ��� :j+� vg�j�+� vg�+�� 3+� v��� ���:kk�+� 7*� �2� � �G��նӶ�k���k���k���k��6ll� 8+kl� �+�� 3k������ :ml� +�Wm�l� +�Wk��� � ��� :n+� vk�n�+� vk�+� 3+� v��� ���:oo��o��o�+� 7*� �2� � �G��նӶ�o��Wo��� � ��� :p+� vo�p�+� vo�+� 3+� �+� v��� �� �:qq� �q� �q� �6rr� x+qr� �+	� 3+++� 7*� �2�/ *� �2�2�G��+�� 3q���ʧ $:sqs�
� :tr� +�Wq�t�r� +�Wq�q�� � ��� :u+� vq�u�+� vq�� :v+�v�+�+�� 3��++� 7*� �2�/ *� �2�2� �� � ��+�� 3+� �+� v��� �� �:ww�� �w+� 7� =� � � �w� �6xx�$+wx� �+� 3++� 7*� �2� � �G��+�� 3++� 7*� �2� � �G��+�� 3++� 7*� �
2� � �G��+�� 3++� 7*� �2� � �G��+�� 3+� v��� �� �:yy+� �� �� � � �y� �y� �Wy� �� � ��� :z+� vy�z�+� vy�+�� 3w���� $:{w{�
� :|x� +�Ww�|�x� +�Ww�w�� � ��� :}+� vw�}�+� vw�� :~+�~�+�+�� 3+� �+� v��� �� �:� �� �� �6��� x+�� �+	� 3+++� 7*� �2�/ *� �2�2�G��+�� 3���ʧ $:���
� :��� +�W����� +�W��� � ��� :�+� v���+� v�� :�+���+�+�� 3� +� 3+� v��� ���:������������Ŷ����W���� � ��� :�+� v����+� v��+�� 3+� 7*� �2� � � �� � ��+�� 3+� v��� ���:�����˶���+� 7*� �2� � �G���Ӷ��++� 7*� �2� � �GٸP��������W���� � ��� :�+� v����+� v��+� 3+� v��� ���:����������+� 7*� �2� � �G���Ӷ��Ŷ����W���� � ��� :�+� v����+� v��+�� 3+� v��� ���:�����˶���+� 7*� �2� � �G���Ӷ��++� 7*� �2� � �G�++� 7*� �2�/ *� �2�2�GٸP��������W���� � ��� :�+� v����+� v��+� 3+� v��� ���:������+� 7*� �2� � �G���Ӷ�������6��� 8+��� �+�� 3������� :��� +�W���� +�W���� � ��� :�+� v����+� v��+� 3+� v��� ���:���+� 7*� �2� � �G���Ӷ����������������6��� 8+��� �+�� 3������� :��� +�W���� +�W���� � ��� :�+� v����+� v��+� 3+� v��� ���:���������+� 7*� �2� � �G���Ӷ����W���� � ��� :�+� v����+� v��+� 3� +�� 3+� 7*� �2� � �� �� � ��+�� 3+� v��� ���:�����˶���+� 7*� �2� � �G���Ӷ��++� 7*� �2� � �GٸP��������W���� � ��� :�+� v����+� v��+� 3+� v��� ���:����������+� 7*� �2� � �G���Ӷ��Ŷ����W���� � ��� :�+� v����+� v��+�� 3+� v��� ���:�����˶���+� 7*� �2� � �G���Ӷ��++� 7*� �2� � �G�++� 7*� �2�/ *� �2�2�GٸP��������W���� � ��� :�+� v����+� v��+� 3+� v��� ���:������+� 7*� �2� � �G���Ӷ�������6��� 8+��� �+�� 3������� :��� +�W���� +�W���� � ��� :�+� v����+� v��+� 3+� v��� ���:���+� 7*� �2� � �G���Ӷ����������������6��� 8+��� �+�� 3������� :��� +�W���� +�W���� � ��� :�+� v����+� v��+� 3+� v��� ���:���������+� 7*� �2� � �G���Ӷ����W���� � ��� :�+� v����+� v��+� 3� +� 3+� 7*� �
2� � � �� � ��+�� 3+� v��� ���:���������!���Ŷ����W���� � ��� :�+� v����+� v��+� 3+� v��� ���:�����˶���+� 7*� �2� � �G��#�Ӷ��++� 7*� �2� � �G�++� 7*� �2�/ *� �2�2�GٸP��������W���� � ��� :�+� v����+� v��+�� 3+� v��� ���:����������+� 7*� �2� � �G��#�Ӷ��Ŷ����W���� � ��� :�+� v����+� v��+�� 3+� v��� ���:������+� 7*� �2� � �G��#�Ӷ�������6��� 8+��� �+�� 3������� :��� +�W���� +�W���� � ��� :�+� v����+� v��+� 3+� v��� ���:���+� 7*� �2� � �G��#�Ӷ����������������6��� 8+��� �+�� 3������� :��� +�W���� +�W���� � ��� :�+� v����+� v��+� 3+� v��� ���:���������+� 7*� �2� � �G��#�Ӷ����W���� � ��� :�+� v����+� v��+�� 3� +� 3+� 7*� �
2� � �� �� � ��+�� 3+� v��� ���:���������%���Ŷ����W���� � ��� :�+� v����+� v��+� 3+� v��� ���:�����˶���+� 7*� �2� � �G��'�Ӷ��++� 7*� �2� � �G�++� 7*� �2�/ *� �2�2�GٸP��������W���� � ��� :�+� v����+� v��+�� 3+� v��� ���:����������+� 7*� �2� � �G��'�Ӷ��Ŷ����W���� � ��� :�+� v����+� v��+�� 3+� v��� ���:������+� 7*� �2� � �G��'�Ӷ�������6��� 8+��� �+�� 3������� :��� +�W���� +�W���� � ��� :�+� v����+� v��+� 3+� v��� ���:���+� 7*� �2� � �G��'�Ӷ����������������6��� 8+�¶ �+�� 3������� :��� +�Wÿ�� +�W���� � ��� :�+� v��Ŀ+� v��+� 3+� v��� ���:���������+� 7*� �2� � �G��'�Ӷ�Ŷ�WŶ�� � ��� :�+� vŶƿ+� vŶ+)� 3� +@� 3+� 7*� �2� � � �� � �#+�� 3+� v��� ���:���������+���Ŷ�Ƕ�WǶ�� � ��� :�+� vǶȿ+� vǶ+� 3+� v��� ���:�����˶���+� 7*� �2� � �G��-�Ӷ��++� 7*� �2� � �G�++� 7*� �2�/ *� �2�2�GٸP�����ɶ�Wɶ�� � ��� :�+� vɶʿ+� vɶ+�� 3+� v��� ���:������+� 7*� �2� � �G��-�Ӷ����˶�6��� 8+�̶ �+�� 3˶����� :��� +�WͿ�� +�W˶�� � ��� :�+� v˶ο+� v˶+� 3+� v��� ���:���+� 7*� �2� � �G��-�Ӷ�������������϶�6��� 8+�ж �+�� 3϶����� :��� +�Wѿ�� +�W϶�� � ��� :�+� v϶ҿ+� v϶+/� 3+� v��� ���:���������+� 7*� �2� � �G��-�Ӷ�Ӷ�WӶ�� � ��� :�+� vӶԿ+� vӶ+1� 3� +�� 3+� 7*� �2� � �� �� � ��+�� 3+� v��� ���:���������3���Ŷ�ն�Wն�� � ��� :�+� vնֿ+� vն+� 3+� v��� ���:�����˶���+� 7*� �2� � �G��5�Ӷ��++� 7*� �2� � �G�++� 7*� �2�/ *� �2�2�GٸP�����׶�W׶�� � ��� :�+� v׶ؿ+� v׶+�� 3+� v��� ���:����������+� 7*� �2� � �G��5�Ӷ��Ŷ�ٶ�Wٶ�� � ��� :�+� vٶڿ+� vٶ+7� 3+� v��� ���:������+� 7*� �2� � �G��5�Ӷ����۶�6��� 8+�ܶ �+�� 3۶����� :��� +�Wݿ�� +�W۶�� � ��� :�+� v۶޿+� v۶+� 3+� v��� ���:���+� 7*� �2� � �G��5�Ӷ�������������߶�6��� 8+�� �+�� 3߶����� :��� +�W��� +�W߶�� � ��� :�+� v߶�+� v߶+/� 3+� v��� ���:���������+� 7*� �2� � �G��5�Ӷ���W��� � ��� :�+� v��+� v�+9� 3� +� 3+� 7*� �2� � � �� � �#+�� 3+� v��� ���:���������;���Ŷ���W��� � ��� :�+� v��+� v�+� 3+� v��� ���:�����˶���+� 7*� �2� � �G��=�Ӷ��++� 7*� �2� � �G�++� 7*� �2�/ *� �2�2�GٸP�������W��� � ��� :�+� v��+� v�+�� 3+� v��� ���:������+� 7*� �2� � �G��=�Ӷ������6��� 8+�� �+�� 3������ :��� +�W��� +�W��� � ��� :�+� v��+� v�+� 3+� v��� ���:���+� 7*� �2� � �G��=�Ӷ����������������6��� 8+�� �+�� 3������� :��� +�W��� +�W���� � ��� :�+� v���+� v��+/� 3+� v��� ���:���������+� 7*� �2� � �G��=�Ӷ���W��� � ��� :�+� v��+� v�+1� 3� +�� 3+� 7*� �2� � �� �� � ��+�� 3+� v��� ���:���������?���Ŷ���W��� � ��� :�+� v���+� v�+� 3+� v��� ���:�����˶���+� 7*� �2� � �G��A�Ӷ��++� 7*� �2� � �G�++� 7*� �2�/ *� �2�2�GٸP��������W���� � ��� :�+� v����+� v��+�� 3+� v��� ���:����������+� 7*� �2� � �G��A�Ӷ��Ŷ����W���� � ��� :�+� v����+� v��+7� 3+� v��� ���:������+� 7*� �2� � �G��A�Ӷ�������6��� 8+��� �+�� 3������� :��� +�W���� +�W���� � ��� :�+� v����+� v��+� 3+� v��� ���:���+� 7*� �2� � �G��A�Ӷ����������������6��� 8+��� �+�� 3������� :��� +�W���� +�W���� � ��� �: +� v��� �+� v��+/� 3+� v��� ����:��������+� 7*� �2� � �G��A�Ӷ����W���� � ��� �:+� v����+� v��+9� 3� +�� 3+� 7*� �2� � � �� � ��+�� 3+� �+� v��� �� ��:�C� ��+� 7� =� � � ��� ��6�� �+��� �+E� 3+� v��� �� ��:�+� �� �� � � ��� ��� �W�� �� � ��� �:+� v����+� v��+�� 3������ 2�:���
�  �:�� +�W������ +�W����� � ��� �:	+� v���	�+� v��� �:
+��
�+�+�� 3++� 7*� �2�/ �K�N� � � &+�� 3+� 7*� � 2�Q� E W+�� 3� +�� 3� +�� 3+� 7*� �2� � � �� � ��+�� 3+� �+� v��� �� ��:�S� ��+� 7� =� � � ��� ��6�� �+��� �+U� 3+� v��� �� ��:�+� �� �� � � ��� ��� �W�� �� � ��� �:+� v����+� v��+�� 3������ 2�:���
�  �:�� +�W������ +�W����� � ��� �:+� v����+� v��� �:+���+�+�� 3++� 7*� �!2�/ �K�N� � � &+�� 3+� 7*� �"2�Q� E W+�� 3� +�� 3� +�� 3+� 7�X�Q� E W+�� 3+� v��� ����:�Z�����������\������6�� F+��� �+�� 3������ �:�� +�W���� +�W���� � ��� �:+� v����+� v��+�� 3+� v��� ����:�^�����������\������6�� F+��� �+�� 3������ �:�� +�W���� +�W���� � ��� �:+� v����+� v��+� 3+� �+� v��� �� ��:�`� ��+� 7� =� � � ��� ��6�� g+��� �+b� 3����� 2�:���
�  �:�� +�W������ +�W����� � ��� �:+� v����+� v��� �: +�� �+�+�� 3+� �+� v��� �� ��:!�!d� ��!+� 7� =� � � ��!� ��6"�"� g+�!�"� �+f� 3�!���� 2�:#�!�#�
�  �:$�"� +�W�!��$��"� +�W�!��!�� � ��� �:%+� v�!��%�+� v�!�� �:&+��&�+�+�� 3+� �+� v��� �� ��:'�'h� ��'+� 7� =� � � ��'� ��6(�(� g+�'�(� �+j� 3�'���� 2�:)�'�)�
�  �:*�(� +�W�'��*��(� +�W�'��'�� � ��� �:++� v�'��+�+� v�'�� �:,+��,�+�+�� 3+� �+� v��� �� ��:-�-l� ��-+� 7� =� � � ��-� ��6.�.� g+�-�.� �+n� 3�-���� 2�:/�-�/�
�  �:0�.� +�W�-��0��.� +�W�-��-�� � ��� �:1+� v�-��1�+� v�-�� �:2+��2�+�+�� 3+� v��� ����:3�3Z���3����3����3p���3���64�4� F+�3�4� �+�� 3�3����� �:5�4� +�W�5��4� +�W�3��� � ��� �:6+� v�3��6�+� v�3�+�� 3+� v��� ����:7�7^���7����7����7p���7���68�8� F+�7�8� �+�� 3�7����� �:9�8� +�W�9��8� +�W�7��� � ��� �::+� v�7��:�+� v�7�+�� 3� +r� 3+� �+t� 3++� �� �� � �G� 3+v� 3++� 7*� �2� � �G� 3+x� 3++� 7*� �2� � �G� 3+z� 3++� 7*� �2� � �G� 3+|� 3++� 7� Ĺ � �G� 3� �:;+��;�+�+~� 3+�� 3+� �+�� 3+++� 7*� �2�/ *� �2�2�G� 3+�� 3� �:<+��<�+�+�� 3+�� 3+� 7*� �
2� � � �� � � 1+�� 3+� �+�� 3� �:=+��=�+�+�� 3� S+� 7*� �
2� � � �� � � 1+�� 3+� �+�� 3� �:>+��>�+�+�� 3� +�� 3+�� 3+� 7*� �
2� � �� �� � � 1+�� 3+� �+�� 3� �:?+��?�+�+�� 3� S+� 7*� �
2� � �� �� � � 1+�� 3+� �+�� 3� �:@+��@�+�+�� 3� +�� 3+�� 3+�� 3+� 7*� �2� � � �� � � 1+�� 3+� �+�� 3� �:A+��A�+�+�� 3� S+� 7*� �2� � � �� � � 1+�� 3+� �+�� 3� �:B+��B�+�+�� 3� +�� 3+�� 3+� 7*� �2� � �� �� � � 1+�� 3+� �+�� 3� �:C+��C�+�+�� 3� S+� 7*� �2� � �� �� � � 1+�� 3+� �+�� 3� �:D+��D�+�+�� 3� +�� 3+�� 3+�� 3+� 7*� �2� � � �� � � +�� 3� /+� 7*� �2� � � �� � � +�� 3� +�� 3+�� 3+�� 3+�� 3+� 7*� �2� � � �� � � 1+�� 3+� �+�� 3� �:E+��E�+�+�� 3� S+� 7*� �2� � � �� � � 1+�� 3+� �+�� 3� �:F+��F�+�+�� 3� +�� 3+�� 3+� 7*� �2� � �� �� � � 1+�� 3+� �+�� 3� �:G+��G�+�+�� 3� S+� 7*� �2� � �� �� � � 1+�� 3+� �+�� 3� �:H+��H�+�+�� 3� +�� 3+¶ 3+Ķ 3+� 7*� �2� � � �� � � 1+�� 3+� �+ƶ 3� �:I+��I�+�+�� 3� S+� 7*� �2� � � �� � � 1+�� 3+� �+ȶ 3� �:J+��J�+�+�� 3� +ʶ 3+�� 3+� 7*� �2� � �� �� � � 1+�� 3+� �+̶ 3� �:K+��K�+�+�� 3� S+� 7*� �2� � �� �� � � 1+�� 3+� �+ζ 3� �:L+��L�+�+�� 3� +ж 3+Ҷ 3+Զ 3+ֶ 3+� 7�X� � � �� � � 1+�� 3+� �+ض 3� �:M+��M�+�+�� 3� +�� 3+� 7*� � 2� � � �� � � 1+�� 3+� �+ڶ 3� �:N+��N�+�+�� 3� +�� 3+� 7*� �"2� � � �� � � 1+�� 3+� �+ܶ 3� �:O+��O�+�+�� 3� +޶ 3+� 3+� �+� 3++� �� �� � �G� 3+v� 3++� 7*� �2� � �G� 3+x� 3++� 7*� �2� � �G� 3+z� 3++� 7*� �2� � �G� 3+|� 3++� 7� Ĺ � �G� 3� �:P+��P�+�+� 3+� 3+� 3+� 7*� �#2++����� E W+�� 3+� �+� v��� �� ��:Q�Q�� ��Q+� 7� =� � � ��Q� ��6R�R� g+�Q�R� �+�� 3�Q���� 2�:S�Q�S�
�  �:T�R� +�W�Q��T��R� +�W�Q��Q�� � ��� �:U+� v�Q��U�+� v�Q�� �:V+��V�+�+�� 3+� �+� v��� �� ��:W�W�� ��W+� 7� =� � � ��W� ��6X�X� g+�W�X� �+�� 3�W���� 2�:Y�W�Y�
�  �:Z�X� +�W�W��Z��X� +�W�W��W�� � ��� �:[+� v�W��[�+� v�W�� �:\+��\�+�+�� 3+� �+�� 3++�*� �$2� �G� 3+� 3+++� 7*� �%2�/ �
�2�G� 3+� 3+++� 7*� �&2�/ �
�2�G� 3+� 3++� 7*� �#2� � �G� 3+� 3� �:]+��]�+�+� 3� ��  �9< )�EH  �~~  ���  ��� )���  �  s))  �11  �mm  ��� )���  Q��  @��  ?x{ )?��  ��   ��  _�� )_��  1��   ��  ??  �eh )�qt  R��  A��  �    P��  ``  ���  �  ���  G��  PP  ��� )���  �&&  r@@  \��  ��� )���  ���  �  ]�� )]��  8��  '��  %ZZ  �&&  W��  �gg  ���  �  ���  P��  YY  �//  `��  � p p   � � �   �!(!(  !�!�!�  !Y!�!�  ""b"b  "�"�"�  #+#�#�  #�$;$;  $�$�$�  $k$�$�  %t%�%�  %#%�%�  %�&,&,  &�&�&�  &�'�'�  '�((  (}(�(�  (4(�(�  )=)O)O  (�){){  )�)�)�  *X*�*�  *�+M+M  +�+�+�  +},,  ,�,�,�  ,5,�,�  ,�->->  -�-�-�  ..�.�  .�//  /�/�/�  /G/�/�  0P0b0b  /�0�0�  0�11  1k1�1�  1�2`2`  2�2�2�  2�33  3�3�3�  3H3�3�  44Q4Q  4�4�4�  55�5�  5�6)6)  6�6�6�  6Z6�6�  7c7u7u  77�7�  7�8+8+  8�9&9&  8�9V9Y )8�9h9k  8�9�9�  8�9�9�  :�;
;
  :�;:;= ):�;L;O  :};�;�  :j;�;�  <�<�<�  <M<�<�  =_=s=s  ==�=�  >">4>7 )>">F>I  =�>�>�  =�>�>�  ??+?. )??=?@  >�?�?�  >�?�?�  @@"@% )@@4@7  ?�@{@{  ?�@�@�  AAA )AA+A.  @�ArAr  @�A�A�  BBB  A�BQBQ  B�B�B�  B�CC  COC�C�  D D3D3  D~D�D�  D�D�D�  E,E6E6  E|E�E�  E�E�E�  F1F;F;  F�F�F�  F�F�F�  G�G�G�  HHH  HfHpHp  H�H�H�  II%I%  IkIuIu  I�I�I�  JJ#J#  J�J�J�  J�J�J�  K-K7K7  KcK�K�  L�L�L� )L�L�L�  LPL�L�  L=MM  M�M�M� )M�M�M�  MGM�M�  M4NN  N+N�N�   u         * +  v  ��          ! O $ P - r 3 { � | � }O ~�  �v �� �� �� �� �V �} �� �� �� �6 �Z �� �� �� � �: �] �| �� �� �- �� � �3 �V �u �� �  � �� �� �� �	 �	� �	� �	� �	� �
 �
� �
� �
� �
� � �� �� �� �� � �+ �l �� �9 �� �~ �� �C �l �� � �c �� � �: �� �� �� �� �� �Y �� �� �: �` �� �� �� �� �z �� �� �� �1 �m �u �} �� �� g gk�
�P���*H� a�!#$t&�'�(�)='=)A,�.�/0~.~0�2�3�4�5:8v9~:�;�<�?@ Ap?pAtC}E�F�G�HFFFHJJ�L�M N �L �N �P �Q �R �S!CV!W!�X!�Y!�Z"]"!^")_"y]"y_"}a"�g"�h"�j#m#;n#_o#�m#�o#�q$Us$ut$�u$�v%y%Iz%Q{%Y|%w}%��%��%��&C�&C�&F�&P�&x�&��'�'(�'��'��'��(�(>�(b�(��(��)�)�)"�)@�)��)��)��*�*�*�*�*�*B�*��*��*��+d�+d�+g�+��+��+��,�,[�,c�,k�,��,��,��-�-U�-U�-Y�-b�-��-��.�.:�.��.��.��/1�/Q�/u�/��/��0%�0-�05�0S�0��0��0��1�1�1#�1-�10�1U�1��1��2�2w�2w�2z�2��2��2��32�3n�3v�3~�3��3��4�4�4h�4h�4l�4u4�55)5M5�5�5�
6D6d6�6�6�787@7H7f7�7�7�8J8J8N 8W"8#8�$9H%9�':(:)):2*:;,:c-:�.;,/;�1;�2<3<4<6<58<[9<e:<o;<�<= >=&?=0@=:A=bB=�E>&G>�I?K?�M@O@�QASA�UA�VA�WA�XB
YBs[B�\B�]B�^B�_C>aCHiCKlC�mC�xC�yC�|D}D~D-DK�DO�DR�Dw�D��D��D��D��D��D��D��D��D��D��E �E%�E0�EG�EJ�Eu�E��E��E��E��E��E��E��E��E��E��E��F*�F5�FL�FO�FY�F\�F`�Fc�F��F��F� F�F�F�F�F�GG&G'G+G>,GD-Gj.Gp/Gt5GwAG{BG�`G�aG�iG�jG�kG�lG�mHnHoH#pH&qH0rH3~H7H:�H_�Hj�H��H��H��H��H��H��H��H��H��H��I�I�I6�I9�Id�Io�I��I��I��I��I��I��I��I��I��I��J�J�J4�J7�JA�JD�JH�JK�JO�JY
JzJ�J�J�J�J�J�J�J�J�K&K1KHKKKX0K_<L=LkL6lL�nM-oM�qN$rN/sN�tw     )  t        �    w     )  t         �    w     )  t        �    w        t  �    �*'� �Y��)SY+�)SY��)SY-�)SY/�)SY��)SY1�)SY3�)SY5�)SY	7�)SY
9�)SY;�)SY=�)SY?�)SYA�)SYC�)SYE�)SYG�)SYI�)SYK�)SYM�)SYO�)SYQ�)SYS�)SYU�)SYW�)SYY�)SY[�)SY]�)SY_�)SYa�)SYc�)SY e�)SY!g�)SY"i�)SY#k�)SY$m�)SY%o�)SY&q�)S� ��     x    