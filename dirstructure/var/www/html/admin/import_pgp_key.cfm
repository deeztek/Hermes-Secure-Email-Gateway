����   2� import_pgp_key_cfm$cf  lucee/runtime/PageImpl  /admin/import_pgp_key.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength      � getCompileTime  n��� getHash ()Ip6
< call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Limport_pgp_key_cfm$cf;
    
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Import PGP Key</title>
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
                     J �</td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="493" width="988"> L m N &lucee/runtime/config/NullSupportHelper P NULL R '
 Q S -lucee/runtime/interpreter/VariableInterpreter U getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; W X
 V Y 0 [ %lucee/runtime/exp/ExpressionException ] java/lang/StringBuilder _ The required parameter [ a  1
 ` c append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; e f
 ` g ] was not provided. i -(Ljava/lang/String;)Ljava/lang/StringBuilder; e k
 ` l toString ()Ljava/lang/String; n o
 ` p
 ^ c lucee/runtime/PageContextImpl s any u�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V y z
 t { 
 } m2  step �  
 � action � 

 � keytype � public �@       keys $[Llucee/runtime/type/Collection$Key; � �	  � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � �   � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � 
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion14" style="background-image: url('./middle_988.png'); height: 493px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="521">
                        <tr valign="top" align="left">
                          <td width="15" height="18"></td>
                          <td width="506"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="506" id="Text369" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Import Recipient PGP Key</span></b></p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                         �(<tr valign="top" align="left">
                          <td width="17" height="20"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="957">
                            <form name="Table190FORM" action="" method="post">
                              <table id="Table190" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 18px;">
                                <tr style="height: 14px;">
                                  <td width="957" id="Cell1167">
                                    <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">PGP Key Type</span></b></p>
                                  </td>
                                </tr>
                                <tr style="height: 34px;">
                                  <td id="Cell1168">
                                     � <table width="531" border="0" cellspacing="0" cellpadding="0" align="left">
                                      <tr>
                                        <td>
                                          <table id="Table184" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 7px;">
                                            <tr style="height: 17px;">
                                              <td width="51" id="Cell1161">
                                                <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"> � A � outputStart � 
 / � �
<input type="radio" checked="checked" name="keytype" value="public" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
 � 	outputEnd � 
 / � w
<input type="radio" name="keytype" value="public" style="height: 13px; width: 13px;" onclick="this.form.submit();">
 �A
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                              <td width="480" id="Cell1162">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Public</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1163">
                                                <table width="34" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                       � <p style="margin-bottom: 0px;"> � private � �
<input type="radio" checked="checked" name="keytype" value="private" style="height: 13px; width: 13px;" onclick="this.form.submit();" >
 � x
<input type="radio" name="keytype" value="private" style="height: 13px; width: 13px;" onclick="this.form.submit();">
 �	
&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                              <td id="Cell1164">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Private</span></b></p>
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
                         �</tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="974">
                        <tr valign="top" align="left">
                          <td width="16" height="218"></td>
                          <td width="958"> � url.id � #lucee/commons/color/ConstantsDouble � _0 Ljava/lang/Double; � �	 � � numeric � File.ServerFile � cffile.serverFileExt � 



 � StartRow � 1 �@       urlScope  ()Llucee/runtime/type/scope/URL; � �
 / � lucee/runtime/type/scope/URL � � � DisplayRows � 10 � show � _show � ;	 9 � filter � _FILTER � ;	 9 � 


 � _action � ;	 9 � _ACTION  ;	 9 ctl expired 2 	localfile	 _type ;	 9 lucee.runtime.tag.Query cfquery use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag;
 t lucee/runtime/tag/Query getrecipientdetails setName 1
 setDatasource (Ljava/lang/Object;)V
 
doStartTag! $
" initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V$%
 /& 4
select id, recipient from recipients where 
id = ( lucee.runtime.tag.QueryParam* cfqueryparam, lucee/runtime/tag/QueryParam. _ID0 ;	 91 setValue3
/4 CF_SQL_INTEGER6 setCfsqltype8 1
/9
/" doEndTag< $
/= lucee/runtime/exp/Abort? newInstance (I)Llucee/runtime/exp/Abort;AB
@C reuse !(Ljavax/servlet/jsp/tagext/Tag;)VEF
 tG doAfterBodyI $
J doCatch (Ljava/lang/Throwable;)VLM
N popBody ()Ljavax/servlet/jsp/JspWriter;PQ
 /R 	doFinallyT 
U
= _TYPEX ;	 9Y _1[ �	 �\ F
select id, email as recipient from external_recipients where 
id = ^ _2` �	 �a getCollectionc � Ad #lucee/runtime/util/VariableUtilImplf recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;hi
gj (Ljava/lang/Object;D)I �l
 �m lucee.runtime.tag.Locationo 
cflocationq lucee/runtime/tag/Locations 	error.cfmu setUrlw 1
tx
t"
t= I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �|
 /} 
 
 show_pgp_password� 	_password� ;	 9�  

� import� lucee/runtime/op/Caster� &(Ljava/lang/Object;)Ljava/lang/String; n�
�� [^A-Za-z0-9]+� all� (lucee/runtime/functions/string/REReplace� w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &�
�� customtrans� getrandom_results� 	setResult� 1
� Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
� inserttrans� stResult� &
insert into salt
(salt)
values
('� getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;��
 /� getId� $
 /� lucee/runtime/type/Query� getCurrentrow (I)I���� getRecordcount� $�� !lucee/runtime/util/NumberIterator� load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� A� isValid (I)Z��
�� current� $
�� go (II)Z���� #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� writePSQ�
 /� removeQuery�  A� release &(Llucee/runtime/util/NumberIterator;)V��
�� ')
� gettrans� 2
select salt as customtrans2 from salt where id='� '
� deletetrans� 
delete from salt where id='� _M� ;	 9� _7� �	 �� getCatch #()Llucee/runtime/exp/PageException;��
 /� 
  � lucee.runtime.tag.FileTag� cffile� lucee/runtime/tag/FileTag� hasBody (Z)V��
�� upload� 	setAction� 1
�  
thekeyfile setFilefield 1
� /opt/hermes/tmp setDestination	 1
�
 
makeunique setNameconflict 1
�
�"
�= 	
     
 [^A-Za-z0-9._]+ rename /opt/hermes/tmp/ java/lang/String concat &(Ljava/lang/String;)Ljava/lang/String;
 	setSource! 1
�" 
   



$ isAbort (Ljava/lang/Throwable;)Z&'
@( toPageException 8(Ljava/lang/Throwable;)Llucee/runtime/exp/PageException;*+
�, setCatch &(Llucee/runtime/exp/PageException;ZZ)V./
 /0 not accepted2 _CFCATCH4 ;	 95 _MESSAGE7 ;	 98 )lucee/runtime/functions/string/FindNoCase: B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)D &<
;= toBooleanValue (D)Z?@
�A 'lucee/runtime/functions/file/FileExistsC 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &E
DF deleteH setFileJ 1
�K _6M �	 �N doesn't existP 





R $(Llucee/runtime/exp/PageException;)V.T
 /U ascW pgpY gpg[ _3] �	 �^ 3` 	


 
b readd %/opt/hermes/scripts/get_pgp_key_id.shf temph setVariablej 1
�k 0 _get_pgp_key_id.shn THE-FILEp ALLr 	setOutputt
�u setAddnewlinew�
�x lucee.runtime.tag.Executez 	cfexecute| lucee/runtime/tag/Execute~ 
/bin/chmod�
 +x /opt/hermes/tmp/� setArguments�
�@N       
setTimeout (D)V��
�
"
J
=@n       	thekeyid2�
k -inputformat none� getsha256fingerprint� djigzo� A
select cm_sha256fingerprint from cm_keyring where cm_keyidhex='� checkkeyidexists� E
select cm_fingerprint from cm_pgp_trust_list where cm_fingerprint='� _4� �	 �� (/opt/hermes/scripts/get_pgp_subkey_id.sh� _get_pgp_subkey_id.sh� 





� 4� (/opt/hermes/scripts/get_pgp_key_email.sh� _get_pgp_key_email.sh� thekeyemail2� 8lucee/runtime/functions/displayFormatting/HTMLEditFormat�
�� 






� nct '(Ljava/lang/Object;Ljava/lang/Object;)Z��
 �� _10� �	 �� ct��
 �� _5� �	 �� +/opt/hermes/scripts/get_pgp_subkey_email.sh� _get_pgp_subkey_email.sh� 5� ,/opt/hermes/scripts/import_pgp_public_key.sh� _import_pgp_public_key.sh� commandoutput� -key ring file does not exist or is not a file� _9� �	 �� -/opt/hermes/scripts/import_pgp_private_key.sh� _import_pgp_private_key.sh� 
    
� THE-PASSWORD� checksum mismatch� _DETAIL� ;	 9� _11� �	 �� 6� checkexistsdjigzo� 2
select cm_id from cm_keyring where cm_keyidhex='� A
select cm_private_key_alias from cm_keyring where cm_keyidhex='� 7� +/opt/hermes/scripts/import_pgp_key_gnupg.sh� _import_pgp_key_gnupg.sh�     



� _8� �	 �� 8� getkeyprint� .
select * from cm_keyring where cm_keyidhex='� getkeyuserid� ?
select cm_userid from cm_keyring_userid where cm_keyring_id=' 	ctlexists 	insertctl I
insert into cm_pgp_trust_list (cm_name, cm_fingerprint) values ('pgp',' getctl	 <
select cm_id from cm_pgp_trust_list where cm_fingerprint=' insertctlnamevalues _
insert into cm_pgp_trust_list_cm_name_values (cm_pgp_trust_list, cm_value, cm_name) values (' ', 'trusted','status')
 9 '/opt/hermes/scripts/get_pgp_key_size.sh _get_pgp_key_size.sh THE_KEY 
thekeysize Total number processed: 0 key not found     
    


! getparentdjigzokeyring# (
select * from cm_keyring where cm_id='% ' and cm_master='1'
' getchilddjigzokeyring) .
select * from cm_keyring where cm_parentid='+ ' and cm_master='0'
- keystoreexists/ 6
select * from recipient_keystores where pgp_key_id='1 
yyyy-mm-dd3 4lucee/runtime/functions/displayFormatting/DateFormat5 S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &7
68 HH:mm:ss: 4lucee/runtime/functions/displayFormatting/TimeFormat<
=8  ? 9999-01-01 12:00:00A insertC �
insert into recipient_keystores
(user_id, user_name, encryption, pgp_keystore_expiration, pgp_keystore_creation, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, external)
values
('E ', 'G 	', '1', 'I gethermesparentK V
select id, pgp_fingerprint, pgp_key_id from recipient_keystores where pgp_key_id = 'M �
insert into recipient_keystores
(user_id, user_name, pgp_keystore_expiration, pgp_keystore_creation, encryption, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, parent, external)
values
('O ',
 'Q /opt/hermes/keys/hermes.keyS theKeyU AESW Base64Y %lucee/runtime/functions/other/Encrypt[
\� �
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, encryption, pgp_keystore_expiration, pgp_keystore_creation, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, external)
values
('^ �
insert into recipient_keystores
(user_id, user_name, pgp_keystore_password, pgp_keystore_expiration, pgp_keystore_creation, encryption, pgp_fingerprint_sha256, pgp_fingerprint, pgp_key_id,
 djigzo_keystore_id, master, parent, external)
values
('` updatepasswordparentb 8
update recipient_keystores set pgp_keystore_password='d ' where pgp_key_id='f updatepasswordchildhU
                            <table border="0" cellspacing="0" cellpadding="0" width="958" id="LayoutRegion17" style="height: 218px;">
                              <tr align="left" valign="top">
                                <td>
                                  <form name="LayoutRegion17FORM" enctype="multipart/form-data" action="j import_pgp_key.cfm?id=l &type=n 
&StartRow=p &DisplayRows=r &filter=t �" method="post">
                                    <input type="hidden" name="action" value="import"><input type="hidden" name="keytype" value="v">
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td width="605">
                                          <table id="Table143" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 39px;">
                                            <tr style="height: 14px;">
                                              <td width="605" id="Cell932">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Recipient</span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 25px;">
                                              <td id="Cell933">
                                                <p style="margin-bottom: 0px;">x �<input type="text" id="FormsEditField30" name="recipient" size="45" maxlength="255" disabled="disabled" style="width: 356px; white-space: pre;" value="z ">|</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0">
                                      <tr valign="top" align="left">
                                        <td height="1"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="958">
                                          <table id="Table186" border="0" cellspacing="2" cellpadding="0" width="100%" style="height: 106px;">
                                            <tr style="height: 14px;">
                                              <td width="954" id="Cell1165">
                                                ~L<p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Private PGP Key Password <span style="font-weight: normal;">(Required if Private is selected above )</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 22px;">
                                              <td id="Cell1166">
                                                <table width="240" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;">� �
<input type="password" id="FormsEditField5" name="password" size="30" maxlength="30" style="width: 236px; white-space: pre;" style="white-space:pre" value="� " disabled="disabled">
� ">
�r&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr style="height: 14px;">
                                              <td id="Cell1021">
                                                <p style="margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(51,51,51);">Select PGP Key file <span style="font-weight: normal;">(.asc, .pgp or .gpg files only)</span></span></b></p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1022">
                                                <table width="567" border="0" cellspacing="0" cellpadding="0" align="left">
                                                  �A<tr>
                                                    <td class="TextObject">
                                                      <p style="margin-bottom: 0px;"><input type="file" name="thekeyfile">
<input type="hidden" name="fileupload">












&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                                &nbsp;</td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1026">
                                                <p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1031">
                                                �<p style="margin-bottom: 0px;">&nbsp;</p>
                                              </td>
                                            </tr>
                                            <tr style="height: 17px;">
                                              <td id="Cell1032">
                                                <table id="Table188" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                                  <tr style="height: 17px;">
                                                    <td width="954" id="Cell1033">
                                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr>
                                                          <td align="center">
                                                            <table width="133" border="0" cellspacing="0" cellpadding="0">
                                                              �<tr>
                                                                <td class="TextObject">
                                                                  <p style="text-align: center; margin-bottom: 0px;"><input type="submit" name="savechanges" onclick="this.disabled=true;this.value='Importing, please wait...';this.form.submit();" value="Import Key" style="height: 24px; width: 160px;">
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
                                              �</td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    <table border="0" cellspacing="0" cellpadding="0" width="955">
                                      <tr valign="top" align="left">
                                        <td width="955" height="6"></td>
                                      </tr>
                                      <tr valign="top" align="left">
                                        <td width="955" id="Text567" class="TextObject">
                                          <p style="text-align: left; margin-bottom: 0px;">�|
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;You must enter a password in the Private PGP Key Password field</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;There was an error importing the PGP key you specified. This usually occurs because of any of the following reasons:<br>
You are attempting to import an invalid file<br> 
You are attempting to import a Private key when you have Public selected in the PGP Key Type field<br>
You are attempting to import a Public Key when you have Private selected in the PGP Key Type field.</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key you are attempting to import already exists in the system. </span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key File was not successfully imported. You have entered an incorrect password</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key File was not successfully imported. The system accepts only files with .asc, .pgp and .gpg extensions</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key File was not successfully imported. You must select a valid GPG Key file by browsing to the location of the file.</span></i></b></p>
�z
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success!! The PGP Key File was successfully imported.</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key File was not successfully imported. A system error has occured. No valid file was found for import into Djigzo.</span></i></b></p>
��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key File you are attempting to import is not for this recipient</span></i></b></p>
� 11��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the PGP Key File was not successfully imported. PGPException: checksum mismatch at 0 of 20</span></i></b></p>
�#


&nbsp;</p>
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
                      <table border="0" cellspacing="0" cellpadding="0" width="976">
                        <tr valign="top" align="left">
                          <td width="16" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="30"></td>
                          <td valign="middle" width="960"><hr id="HRRule4" width="960" size="1"></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="973">
                        �U<tr valign="top" align="left">
                          <td width="16" height="1"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="45"></td>
                          <td width="957">

                            <table border="0" cellspacing="0" cellpadding="0" width="957" id="LayoutRegion18" style="height: 45px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td height="17"></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td width="957">
                                        <table id="Table189" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 17px;">
                                          ��<tr style="height: 17px;">
                                            <td width="957" id="Cell1034">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table width="635" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td class="TextObject">
                                                          <p style="text-align: center; margin-bottom: 0px;">� &
<form name="apply_settings" action="� !internal_encryption_users.cfm?id=� &show=�" method="post">
  


  <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="635" style="height: 24px;">
    <tr style="height: 24px;">
      <td width="635" id="Cell518">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="center">
              <table width="360" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="TextObject">
                    <p style="text-align: left; margin-bottom: 0px;">� �
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Internal Recipients Encryption" style="height: 24px; width: 357px;">
� �
<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to External Recipients Encryption" style="height: 24px; width: 357px;">
� �
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

� (

<form name="apply_settings" action="� !external_encryption_users.cfm?id=� �
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
�
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
              ��<td height="49" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion33" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="981">
                        <tr valign="top" align="left">
                          <td width="981" height="12"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;">� $lucee/runtime/functions/dateTime/Now� =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &�
�� yyyy� 
getversion� D
SELECT value from system_settings where parameter = 'version_no'
� getbuild� B
SELECT value from system_settings where parameter = 'build_no'
� V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway � sessionScope $()Llucee/runtime/type/scope/Session;��
 /�  lucee/runtime/type/scope/Session�� � 	 Version:� _VALUE� ;	 9�  Build:� . Copyright 2011-� l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>�C
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
 ����� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�  KEYTYPE STARTROW DISPLAYROWS SHOW CTL
 EXPIRED 
THEKEYFILE 	LOCALFILE GETRECIPIENTDETAILS THERECIPIENT 	RECIPIENT PASSWORD SHOW_PGP_PASSWORD 	RCPT_NAME RANDOM STRESULT  GENERATED_KEY" CUSTOMTRANS3$ GETTRANS& CUSTOMTRANS2( STEP* ORIGINALFILENAME, CFFILE. 
SERVERFILE0 NEWFILENAME2 FILETODELETE4 SERVERFILEEXT6 TEMP8 	THEKEYID2: THEKEYID< GETSHA256FINGERPRINT> CM_SHA256FINGERPRINT@ CHECKKEYIDEXISTSB THEKEYEMAIL2D THEKEYEMAILF COMMANDOUTPUTH CHECKEXISTSDJIGZOJ CM_PRIVATE_KEY_ALIASL GETKEYPRINTN 	CM_MASTERP CM_IDR CM_PARENTIDT 	CTLEXISTSV GETCTLX CM_KEYIDHEXZ 
THEKEYSIZE\ KEYSTOREEXISTS^ CM_EXPIRATION_DATE` PGP_KEYSTORE_EXPIRATION_DATEb PGP_KEYSTORE_EXPIRATION_TIMEd PGP_KEYSTORE_EXPIRATIONf EXTERNALh PGP_KEYSTORE_CREATION_DATEj CM_CREATION_DATEl PGP_KEYSTORE_CREATION_TIMEn PGP_KEYSTORE_CREATIONp GETKEYUSERIDr 	CM_USERIDt GETPARENTDJIGZOKEYRINGv CM_FINGERPRINTx GETHERMESPARENTz ENCRYPTEDPASSWORD| THEKEY~ THEYEAR� EDITION� 
GETVERSION� GETBUILD� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *����*+���        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  �� �  �y+-� 3+� 7� =?� E W+G� 3+I� 3+K� 3+M� 3+O+� T� ZM>+� T,� .\Y:� !� ^Y� `Yb� dO� hj� m� q� r�M>+� tvO, w w� |+~� 3+�+� T� Z:6+� T� 0\Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+~� 3+�+� T� Z:6	+� T� 0\Y:
� !� ^Y� `Yb� d�� hj� m� q� r�
:6	+� tv� w w	� |+�� 3+�+� T� Z:6+� T� 0\Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+�� 3+�+� T� Z:6+� T� 0�Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+�� 3+ �*� �2� �� ��� �� � � Z+~� 3+� �*� �2� � �� �� � � 1+~� 3+� 7*� �2+� �*� �2� � � E W+~� 3� � +�� 3+�� 3+�� 3+� 7*� �2� � �� �� � � ,+~� 3+� �+�� 3� :+� ��+� �+~� 3� L+� 7*� �2� � �� �� � � ,+~� 3+� �+�� 3� :+� ��+� �+~� 3� +ö 3+Ŷ 3+� 7*� �2� � Ǹ �� � � ,+~� 3+� �+ɶ 3� :+� ��+� �+~� 3� L+� 7*� �2� � Ǹ �� � � ,+~� 3+� �+˶ 3� :+� ��+� �+~� 3� +Ͷ 3+϶ 3+�+� T� Z:6+� T� 1� �Y:� !� ^Y� `Yb� dѶ hj� m� q� r�:6+� t�� w w� |+~� 3+�+� T� Z:6+� T� 0�Y:� !� ^Y� `Yb� d۶ hj� m� q� r�:6+� tv� w w� |+~� 3+�+� T� Z:6+� T� 0�Y:� !� ^Y� `Yb� dݶ hj� m� q� r�:6+� tv� w w� |+߶ 3+�+� T� Z:6+� T� 0�Y: � !� ^Y� `Yb� d� hj� m� q� r� :6+� tv� w w� |+~� 3+ �*� �2� �� ��� �� � � Z+~� 3+� �*� �2� � �� �� � � 1+~� 3+� 7*� �2+� �*� �2� � � E W+~� 3� � +�� 3+�+� T� Z:!6"+� T!� 0�Y:#� !� ^Y� `Yb� d� hj� m� q� r�#:!6"+� tv�! w w"� |+~� 3+ �*� �2� �� ��� �� � � Z+~� 3+� �*� �2� � �� �� � � 1+~� 3+� 7*� �2+� �*� �2� � � E W+~� 3� � +�� 3+�+� T� Z:$6%+� T$� 0�Y:&� !� ^Y� `Yb� d� hj� m� q� r�&:$6%+� tv�$ w w%� |+~� 3+ � �� �� ��� �� � � ]+~� 3+� �*� �2� � �� �� � � 3+~� 3+� 7*� �2+� �*� �2� � � E W+~� 3� � +�� 3+�+� T� Z:'6(+� T'� 0�Y:)� !� ^Y� `Yb� d�� hj� m� q� r�):'6(+� tv�' w w(� |+~� 3+ �*� �2� �� ��� �� � � Q+~� 3+� � �� � �� �� � � ++~� 3+� 7� �+� � �� � � E W+~� 3� � +�� 3+�+� T� Z:*6++� T*� 0�Y:,� !� ^Y� `Yb� d�� hj� m� q� r�,:*6++� tv�* w w+� |+�� 3+ �� �� �� ��� �� � � Q+~� 3+� ��� � �� �� � � ++~� 3+� 7�+� ��� � � E W+~� 3� � +�� 3++� T� Z:-6.+� T-� 1�Y:/� "� ^Y� `Yb� d� hj� m� q� r�/:-6.+� tv- w w.� |+�� 3+ �*� �2� �� ��� �� � � ]+~� 3+� �*� �	2� � �� �� � � 3+~� 3+� 7*� �	2+� �*� �	2� � � E W+~� 3� � +�� 3++� T� Z:061+� T0� 2Y:2� "� ^Y� `Yb� d� hj� m� q� r�2:061+� tv0 w w1� |+�� 3+ �*� �
2� �� ��� �� � � ]+~� 3+� �*� �2� � �� �� � � 3+~� 3+� 7*� �2+� �*� �2� � � E W+~� 3� � +�� 3+
+� T� Z:364+� T3� 1�Y:5� "� ^Y� `Yb� d
� hj� m� q� r�5:364+� tv
3 w w4� |+�� 3+ �*� �2� �� ��� �� � � ]+~� 3+� �*� �2� � �� �� � � 3+~� 3+� 7*� �2+� �*� �2� � � E W+~� 3� � +�� 3+ �� �� �� � �I+~� 3+� �+� t��:66�6+� 7� =� � � 6�#677� �+67�'+)� 3+� t+-��/:88+� �2� � �587�:8�;W8�>� �D�� :9+� t8�H9�+� t8�H+~� 36�K���� $::6:�O� :;7� +�SW6�V;�7� +�SW6�V6�W� �D�� :<+� t6�H<�+� t6�H� :=+� �=�+� �+~� 3+� 7�Z�]� E W+~� 3��+ �� �� ���+~� 3+� �Z� � � �� � �I+~� 3+� �+� t��:>>�>+� 7� =� � � >�#6??� �+>?�'+)� 3+� t+-��/:@@+� �2� � �5@7�:@�;W@�>� �D�� :A+� t@�HA�+� t@�H+~� 3>�K���� $:B>B�O� :C?� +�SW>�VC�?� +�SW>�V>�W� �D�� :D+� t>�HD�+� t>�H� :E+� �E�+� �+~� 3+� 7�Z�]� E W+~� 3�g+� �Z� � � �� � �I+~� 3+� �+� t��:FF�F+� 7� =� � � F�#6GG� �+FG�'+_� 3+� t+-��/:HH+� �2� � �5H7�:H�;WH�>� �D�� :I+� tH�HI�+� tH�H+~� 3F�K���� $:JFJ�O� :KG� +�SWF�VK�G� +�SWF�VF�W� �D�� :L+� tF�HL�+� tF�H� :M+� �M�+� �+~� 3+� 7�Z�b� E W+�� 3� +~� 3� +�� 3++� 7*� �2�e �k�n� � � [+~� 3+� tpr��t:NNv�yN�zWN�{� �D�� :O+� tN�HO�+� tN�H+~� 3� b++� 7*� �2�e �k�n� � � >+~� 3+� 7*� �2++� 7*� �2�e *� �2�~� E W+~� 3� +�� 3+�+� T� Z:P6Q+� TP� 1�Y:R� "� ^Y� `Yb� d�� hj� m� q� r�R:P6Q+� tv�P w wQ� |+�� 3+ ���� �� ��� �� � � ]+~� 3+� �*� �2� � �� �� � � 3+~� 3+� 7*� �2+� �*� �2� � � E W+~� 3� � +�� 3+� 7�� � �� �� � �q�+�� 3+� 7*� �2+++� 7*� �2�e *� �2�~�������� E W+�� 3+� �+� t��:SS��S+� 7� =� � � S���S�#6TT� O+ST�'+�� 3S�K��� $:USU�O� :VT� +�SWS�VV�T� +�SWS�VS�W� �D�� :W+� tS�HW�+� tS�H� :X+� �X�+� �+�� 3+� �+� t��:YY��Y+� 7� =� � � Y���Y�#6ZZ�B+YZ�'+�� 3+� �+���:\+��6]\]�� 6^\�� � � � �6__\�� ��:[+� 7\�� _d6b[b`�ę D\[��]�� � � � � ([��6b+++� 7*� �2� � ���жӧ��� ":c\^]�� W+� 7�� [��c�\^]�� W+� 7�� [�ڧ :d+� �d�+� �+ܶ 3Y�K�� � $:eYe�O� :fZ� +�SWY�Vf�Z� +�SWY�VY�W� �D�� :g+� tY�Hg�+� tY�H� :h+� �h�+� �+�� 3+� �+� t��:ii޶i+� 7� =� � � i�#6jj� x+ij�'+� 3+++� 7*� �2�e *� �2�~����+� 3i�K��ʧ $:kik�O� :lj� +�SWi�Vl�j� +�SWi�Vi�W� �D�� :m+� ti�Hm�+� ti�H� :n+� �n�+� �+�� 3+� 7*� �2++� 7*� �2�e *� �2�~� E W+�� 3+� �+� t��:oo�o+� 7� =� � � o�#6pp� x+op�'+� 3+++� 7*� �2�e *� �2�~����+� 3o�K��ʧ $:qoq�O� :rp� +�SWo�Vr�p� +�SWo�Vo�W� �D�� :s+� to�Hs�+� to�H� :t+� �t�+� �+�� 3+� 7*� �2� � Ǹ �� � �:+~� 3+� 7*� �2� � �� �� � � <+~� 3+� 7*� �2� ׹ E W+~� 3+� 7��� E W+~� 3� �+� 7*� �2� � �� �� � � �+~� 3+� 7*� �2� � �� �� � � <+~� 3+� 7*� �2� ׹ E W+~� 3+� 7��]� E W+~� 3� G+� 7*� �2� � �� �� � � &+~� 3+� 7*� �2�b� E W+~� 3� +~� 3� +�� 3� �+� 7*� �2� � �� �� � � �+~� 3+� 7*� �2� � �� �� � � <+~� 3+� 7*� �2� ׹ E W+~� 3+� 7��� E W+~� 3� G+� 7*� �2� � �� �� � � &+~� 3+� 7*� �2�b� E W+~� 3� +�� 3� +�� 3+� 7*� �2� � � �� � ��+~� 3+��:u+� 3+� t�����:vv��v��v�v�v�v�Wv�� �D�� :w+� tv�Hw�+� tv�H+� 3+� 7*� �2++� 7*� �2�e *� �2�~� E W+~� 3+� 7*� �2++� 7*� �2� � ������� E W+~� 3+� t�����:xx��x�x+� 7*� �2� � ��� �#x+� 7*� �2� � ��� �x�Wx�� �D�� :y+� tx�Hy�+� tx�H+%� 3�x:zz�)� z�z�-:{+{�1+�� 3+3++� 7�6�e �9�~���>�B� �+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:||��|I�|+� 7*� � 2� � ���L|�W|�� �D�� :}+� t|�H}�+� t|�H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7��O� E W+߶ 3�#+Q++� 7�6�e �9�~���>�B� +�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:~~��~I�~+� 7*� � 2� � ���L~�W~�� �D�� :+� t~�H�+� t~�H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7��� E W+S� 3� +�� 3� :�+u�V��+u�V+�� 3++� 7*� �2�e *� �!2�~X� �� � � 4++� 7*� �2�e *� �!2�~Z� �� � � � � 4++� 7*� �2�e *� �!2�~\� �� � � � � &+~� 3+� 7*� �2�_� E W+~� 3� �+~� 3+� 7��O� E W+~� 3+� 7*� �2� ׹ E W+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L��W��� �D�� :�+� t��H��+� t��H+~� 3� +�� 3+߶ 3� +�� 3+� 7*� �2� � a� �� � �l+c� 3+� 7*� �2� � �� �� � �+߶ 3+� t�����:�����e��g�L�i�l��W��� �D�� :�+� t��H��+� t��H+�� 3+� t�����:�����m��+� 7*� �2� � ��� o� �L�++� 7*� �"2� � ��q+� 7*� �2� � ��s���v��y��W��� �D�� :�+� t��H��+� t��H+�� 3+� t{}��:�������+� 7*� �2� � ��� o� ���������6��� 8+���'+~� 3������� :��� +�SW���� +�SW���� �D�� :�+� t��H��+� t��H+�� 3+� t{}��:��+� 7*� �2� � ��� o� �����������������6��� 8+���'+~� 3������� :��� +�SW���� +�SW���� �D�� :�+� t��H��+� t��H+߶ 3+� 7*� � 2+� 7*� �2� � ��� o� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L��W��� �D�� :�+� t��H��+� t��H+~� 3� +�� 3+� 7*� �#2� � �� �� � � �+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L��W��� �D�� :�+� t��H��+� t��H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7��b� E W+~� 3��+� 7*� �#2� � �� �� � �j+~� 3+� 7*� �$2++� 7*� �#2� � ���й E W+߶ 3+� �+� t��:������� ��#6��� m+���'+�� 3++� 7*� �$2� � ����+� 3��K��է $:����O� :��� +�SW��V���� +�SW��V��W� �D�� :�+� t��H��+� t��H� :�+� ���+� �+�� 3+� �+� t��:������� ��#6��� x+���'+�� 3+++� 7*� �%2�e *� �&2�~����+� 3��K��ʧ $:����O� :��� +�SW��V���� +�SW��V��W� �D�� :�+� t��H��+� t��H� :�+� ���+� �+�� 3++� 7*� �'2�e �k�n� � � &+~� 3+� 7*� �2��� E W+~� 3�#++� 7*� �'2�e �k�n� � � �+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L��W��� �D�� :�+� t��H��+� t��H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7��_� E W+~� 3� +�� 3� +�� 3�0+� 7*� �2� � Ǹ �� � �+߶ 3+� t�����:�����e����L�i�l��W��� �D�� :�+� t��H��+� t��H+�� 3+� t�����:�����m��+� 7*� �2� � ��� �� �L�++� 7*� �"2� � ��q+� 7*� �2� � ��s���v��y��W��� �D�� :�+� t��H��+� t��H+�� 3+� t{}��:�������+� 7*� �2� � ��� �� ���������6��� 8+���'+~� 3������� :��� +�SW���� +�SW���� �D�� :�+� t��H��+� t��H+�� 3+� t{}��:��+� 7*� �2� � ��� �� �����������������6��� 8+���'+~� 3������� :��� +�SW���� +�SW���� �D�� :�+� t��H��+� t��H+�� 3+� 7*� � 2+� 7*� �2� � ��� �� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L��W��� �D�� :�+� t��H��+� t��H+~� 3� +�� 3+� 7*� �#2� � �� �� � � �+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L��W��� �D�� :�+� t��H��+� t��H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7��b� E W+~� 3��+� 7*� �#2� � �� �� � �j+~� 3+� 7*� �$2++� 7*� �#2� � ���й E W+߶ 3+� �+� t��:������� ��#6��� m+���'+�� 3++� 7*� �$2� � ����+� 3��K��է $:����O� :��� +�SW��V���� +�SW��V��W� �D�� :�+� t��H��+� t��H� :�+� ���+� �+�� 3+� �+� t��:������� ��#6��� x+���'+�� 3+++� 7*� �%2�e *� �&2�~����+� 3��K��ʧ $:����O� :��� +�SW��V���� +�SW��V��W� �D�� :�+� t��H��+� t��H� :�+� ���+� �+�� 3++� 7*� �'2�e �k�n� � � &+~� 3+� 7*� �2��� E W+~� 3�#++� 7*� �'2�e �k�n� � � �+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L��W��� �D�� :�+� t��H��+� t��H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7��_� E W+�� 3� +�� 3� +S� 3� +�� 3� +�� 3+� 7*� �2� � �� �� � �#+c� 3+� 7*� �2� � �� �� � �k+߶ 3+� t�����:�����e����L�i�l��W��� �D�� :�+� t��H��+� t��H+�� 3+� t�����:�����m��+� 7*� �2� � ��� �� �L�++� 7*� �"2� � ��q+� 7*� �2� � ��s���v��y��W��� �D�� :�+� t��H¿+� t��H+�� 3+� t{}��:�������+� 7*� �2� � ��� �� ������ö�6��� 8+�Ķ'+~� 3ö����� :��� +�SWſ�� +�SWö�� �D�� :�+� töHƿ+� töH+�� 3+� t{}��:��+� 7*� �2� � ��� �� ��������������Ƕ�6��� 8+�ȶ'+~� 3Ƕ����� :��� +�SWɿ�� +�SWǶ�� �D�� :�+� tǶHʿ+� tǶH+߶ 3+� 7*� � 2+� 7*� �2� � ��� �� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L˶W˶� �D�� :�+� t˶H̿+� t˶H+~� 3� +�� 3+� 7*� �(2� � �� �� � � �+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���LͶWͶ� �D�� :�+� tͶHο+� tͶH+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7��b� E W+~� 3��+� 7*� �(2� � �� �� � ��+~� 3+� 7*� �)2+++� 7*� �(2� � �����й E W+�� 3+� 7*� �)2� � ++� 7*� �2�e *� �2�~��� �+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L϶W϶� �D�� :�+� t϶Hп+� t϶H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7���� E W+~� 3� W+� 7*� �)2� � ++� 7*� �2�e *� �2�~��� &+~� 3+� 7*� �2�Ĺ E W+~� 3� +�� 3� +�� 3��+� 7*� �2� � Ǹ �� � �k+߶ 3+� t�����:�����e��ƶL�i�lѶWѶ� �D�� :�+� tѶHҿ+� tѶH+�� 3+� t�����:�����m��+� 7*� �2� � ��� ȶ �L�++� 7*� �"2� � ��q+� 7*� �2� � ��s���v��yӶWӶ� �D�� :�+� tӶHԿ+� tӶH+�� 3+� t{}��:�������+� 7*� �2� � ��� ȶ ������ն�6��� 8+�ֶ'+~� 3ն����� :��� +�SW׿�� +�SWն�� �D�� :�+� tնHؿ+� tնH+�� 3+� t{}��:��+� 7*� �2� � ��� ȶ ��������������ٶ�6��� 8+�ڶ'+~� 3ٶ����� :��� +�SWۿ�� +�SWٶ�� �D�� :�+� tٶHܿ+� tٶH+�� 3+� 7*� � 2+� 7*� �2� � ��� ȶ � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���LݶWݶ� �D�� :�+� tݶH޿+� tݶH+~� 3� +�� 3+� 7*� �(2� � �� �� � � �+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L߶W߶� �D�� :�+� t߶H�+� t߶H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7��b� E W+~� 3��+� 7*� �(2� � �� �� � ��+~� 3+� 7*� �)2+++� 7*� �(2� � �����й E W+�� 3+� 7*� �)2� � ++� 7*� �2�e *� �2�~��� �+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L�W�� �D�� :�+� t�H�+� t�H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7���� E W+~� 3� W+� 7*� �)2� � ++� 7*� �2�e *� �2�~��� &+~� 3+� 7*� �2�Ĺ E W+~� 3� +�� 3� +߶ 3� +�� 3� +S� 3+� 7*� �2� � ʸ �� � ��+�� 3+� 7*� �2� � �� �� � ��+߶ 3+� t�����:�����e��̶L�i�l�W�� �D�� :�+� t�H�+� t�H+�� 3+� t�����:�����m��+� 7*� �2� � ��� ζ �L�++� 7*� �"2� � ��q+� 7*� �2� � ��s���v��y�W�� �D�� :�+� t�H�+� t�H+�� 3+� t{}��:�������+� 7*� �2� � ��� ζ ��������6��� 8+��'+~� 3������ :��� +�SW��� +�SW��� �D�� :�+� t�H�+� t�H+�� 3+� t{}��:��+� 7*� �2� � ��� ζ �������ж�������6��� 8+��'+~� 3������ :��� +�SW���� +�SW��� �D�� :�+� t�H�+� t�H+�� 3+� 7*� � 2+� 7*� �2� � ��� ζ � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L�W�� �D�� :�+� t�H�+� t�H+~� 3� +�� 3+�+� 7*� �*2� � ���>�B� �+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� y+�� 3+� t�����:�����I��+� 7*� � 2� � ���L�W�� �D�� :�+� t�H�+� t�H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7��չ E W+�� 3� #+~� 3+� 7*� �2�O� E W+߶ 3+�� 3��+� 7*� �2� � Ǹ �� � ��+߶ 3+� t�����:�����e��׶L�i�l�W�� �D�� :�+� t�H��+� t�H+�� 3+� t�����:�����m��+� 7*� �2� � ��� ٶ �L�++� 7*� �"2� � ��q+� 7*� �2� � ��s���v��y��W��� �D�� :�+� t��H��+� t��H+۶ 3+� t�����:�����e��+� 7*� �2� � ��� ٶ �L�i�l��W��� �D�� :�+� t��H��+� t��H+�� 3+� t�����:�����m��+� 7*� �2� � ��� ٶ �L�++� 7*� �"2� � ���+� 7*� �2� � ��s���v��y��W��� �D�� :�+� t��H��+� t��H+�� 3+� t{}��:�������+� 7*� �2� � ��� ٶ ���������6��� 8+���'+~� 3������� :��� +�SW���� +�SW���� �D�� :�+� t��H��+� t��H+�� 3+��:�+�� 3+� t{}���: � +� 7*� �2� � ��� ٶ ��� ���� ж�� ���� ���6�� F+� ��'+~� 3� ����� �:�� +�SW���� +�SW� ��� �D�� �:+� t� �H��+� t� �H+S� 3���:��)� ����-�:+��1+�� 3+�++� 7�6�e ��~���>�B�+�� 3+� 7*� � 2+� 7*� �2� � ��� ٶ � E W+~� 3++� 7*� � 2� � �G� �+�� 3+� t������:����I��+� 7*� � 2� � ���L��W��� �D�� �:+� t��H��+� t��H+�� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7��� E W+S� 3� +�� 3� �:+��V��+��V+�� 3+� 7*� � 2+� 7*� �2� � ��� ٶ � E W+~� 3++� 7*� � 2� � �G� �+�� 3+� t������:	�	���	I��	+� 7*� � 2� � ���L�	�W�	�� �D�� �:
+� t�	�H�
�+� t�	�H+�� 3� +�� 3+�+� 7*� �*2� � ���>�B�+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� �+�� 3+� t������:����I��+� 7*� � 2� � ���L��W��� �D�� �:+� t��H��+� t��H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7��չ E W+�� 3� #+~� 3+� 7*� �2�O� E W+�� 3+S� 3� +�� 3� +�� 3+� 7*� �2� � � �� � ��+�� 3+� 7*� �2� � �� �� � ��+~� 3+� �+� t���:����� ��#�6�� �+���'+� 3++� 7*� �$2� � ����+� 3��K��ӧ 2�:���O�  �:�� +�SW��V���� +�SW��V��W� �D�� �:+� t��H��+� t��H� �:+� ���+� �+�� 3++� 7*� �+2�e �k�n� � � &+~� 3+� 7*� �2�� E W+~� 3� `++� 7*� �+2�e �k�n� � � <+~� 3+� 7*� �2� ׹ E W+~� 3+� 7��_� E W+�� 3� +�� 3��+� 7*� �2� � Ǹ �� � ��+~� 3+� �+� t���:����� ��#�6�� �+���'+�� 3++� 7*� �$2� � ����+� 3��K��ӧ 2�:���O�  �:�� +�SW��V���� +�SW��V��W� �D�� �:+� t��H��+� t��H� �:+� ���+� �+�� 3++� 7*� �+2�e *� �,2�~�� �� � � &+~� 3+� 7*� �2�� E W+~� 3� h++� 7*� �+2�e *� �,2�~�� �� � � <+~� 3+� 7*� �2� ׹ E W+~� 3+� 7���� E W+�� 3� +�� 3� +�� 3� +�� 3+� 7*� �2� � � �� � �+S� 3+� t������:����e���L�i�l��W��� �D�� �:+� t��H��+� t��H+�� 3+� t������:����m��+� 7*� �2� � ��� � �L�++� 7*� �"2� � ��q+� 7*� �2� � ��s���v��y��W��� �D�� �:+� t��H��+� t��H+�� 3+� t{}���:������+� 7*� �2� � ��� � ����������6�� F+���'+~� 3������ �:�� +�SW���� +�SW���� �D�� �: +� t��H� �+� t��H+�� 3+� t{}���:!�!+� 7*� �2� � ��� � ���!����!ж��!����!���6"�"� F+�!�"�'+~� 3�!����� �:#�"� +�SW�#��"� +�SW�!��� �D�� �:$+� t�!�H�$�+� t�!�H+�� 3+� 7*� � 2+� 7*� �2� � ��� � � E W+~� 3++� 7*� � 2� � �G� �+�� 3+� t������:%�%���%I��%+� 7*� � 2� � ���L�%�W�%�� �D�� �:&+� t�%�H�&�+� t�%�H+~� 3� +�� 3+� 7*� �2��� E W+�� 3� +�� 3+� 7*� �2� � �� �� � ��+߶ 3+� �+� t���:'�'���'�� �'�#�6(�(� �+�'�(�'+�� 3++� 7*� �$2� � ����+� 3�'�K��ӧ 2�:)�'�)�O�  �:*�(� +�SW�'�V�*��(� +�SW�'�V�'�W� �D�� �:++� t�'�H�+�+� t�'�H� �:,+� ��,�+� �+�� 3++� 7*� �-2�e *� �.2�~� �� � �%+~� 3+� �+� t���:-�- ��-�� �-�#�6.�.� �+�-�.�'+� 3+++� 7*� �-2�e *� �/2�~����+� 3�-�K��ȧ 2�:/�-�/�O�  �:0�.� +�SW�-�V�0��.� +�SW�-�V�-�W� �D�� �:1+� t�-�H�1�+� t�-�H� �:2+� ��2�+� �+~� 3�Q++� 7*� �-2�e *� �.2�~\� �� � �%+~� 3+� �+� t���:3�3 ��3�� �3�#�64�4� �+�3�4�'+� 3+++� 7*� �-2�e *� �02�~����+� 3�3�K��ȧ 2�:5�3�5�O�  �:6�4� +�SW�3�V�6��4� +�SW�3�V�3�W� �D�� �:7+� t�3�H�7�+� t�3�H� �:8+� ��8�+� �+�� 3� +�� 3+� �+� t���:9�9��9�� �9�#�6:�:� �+�9�:�'+�� 3+++� 7*� �-2�e *� �&2�~����+� 3�9�K��ȧ 2�:;�9�;�O�  �:<�:� +�SW�9�V�<��:� +�SW�9�V�9�W� �D�� �:=+� t�9�H�=�+� t�9�H� �:>+� ��>�+� �+�� 3++� 7*� �12�e �k�n� � �{+�� 3+� �+~� 3+� �+� t���:?�?��?�� �?�#�6@�@� �+�?�@�'+� 3+++� 7*� �-2�e *� �&2�~����+ܶ 3�?�K��ȧ 2�:A�?�A�O�  �:B�@� +�SW�?�V�B��@� +�SW�?�V�?�W� �D�� �:C+� t�?�H�C�+� t�?�H� �:D+� ��D�+� �+�� 3+� �+� t���:E�E
��E�� �E�#�6F�F� �+�E�F�'+� 3+++� 7*� �-2�e *� �&2�~����+� 3�E�K��ȧ 2�:G�E�G�O�  �:H�F� +�SW�E�V�H��F� +�SW�E�V�E�W� �D�� �:I+� t�E�H�I�+� t�E�H� �:J+� ��J�+� �+�� 3+� �+� t���:K�K��K�� �K�#�6L�L� �+�K�L�'+� 3+++� 7*� �22�e *� �/2�~����+� 3�K�K��ȧ 2�:M�K�M�O�  �:N�L� +�SW�K�V�N��L� +�SW�K�V�K�W� �D�� �:O+� t�K�H�O�+� t�K�H� �:P+� ��P�+� �+�� 3� �:Q+� ��Q�+� �+�� 3� +S� 3+� 7*� �2�չ E W+�� 3� +�� 3+� 7*� �2� � � �� � ��+߶ 3+� t������:R�R���Re��R�L�Ri�l�R�W�R�� �D�� �:S+� t�R�H�S�+� t�R�H+�� 3+� t������:T�T���Tm��T+� 7*� �2� � ��� � �L�T++� 7*� �"2� � ��++� 7*� �-2�e *� �32�~��s���v�T�y�T�W�T�� �D�� �:U+� t�T�H�U�+� t�T�H+�� 3+� t{}���:V�V����V�+� 7*� �2� � ��� � ���V����V���6W�W� F+�V�W�'+~� 3�V����� �:X�W� +�SW�X��W� +�SW�V��� �D�� �:Y+� t�V�H�Y�+� t�V�H+�� 3+� t{}���:Z�Z+� 7*� �2� � ��� � ���Z����Z���Z����Z���6[�[� F+�Z�[�'+~� 3�Z����� �:\�[� +�SW�\��[� +�SW�Z��� �D�� �:]+� t�Z�H�]�+� t�Z�H+�� 3++� 7*� �42� � ���>�B�+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� �+�� 3+� t������:^�^���^I��^+� 7*� � 2� � ���L�^�W�^�� �D�� �:_+� t�^�H�_�+� t�^�H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7���� E W+~� 3�3+ +� 7*� �42� � ���>�B�+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� �+�� 3+� t������:`�`���`I��`+� 7*� � 2� � ���L�`�W�`�� �D�� �:a+� t�`�H�a�+� t�`�H+~� 3� +�� 3+� 7*� �2� ׹ E W+~� 3+� 7���� E W+�� 3� +߶ 3+� 7*� � 2+� 7*� �2� � ��� � � E W+~� 3++� 7*� � 2� � �G� �+�� 3+� t������:b�b���bI��b+� 7*� � 2� � ���L�b�W�b�� �D�� �:c+� t�b�H�c�+� t�b�H+~� 3� +"� 3+� 7*� �2��� E W+�� 3� +�� 3+� 7*� �2� � � �� � �"L+�� 3++� 7*� �-2�e *� �.2�~� �� � �>+�� 3+� �+� t���:d�d$��d�� �d�#�6e�e� �+�d�e�'+&� 3+++� 7*� �-2�e *� �/2�~����+(� 3�d�K��ȧ 2�:f�d�f�O�  �:g�e� +�SW�d�V�g��e� +�SW�d�V�d�W� �D�� �:h+� t�d�H�h�+� t�d�H� �:i+� ��i�+� �+�� 3+� �+� t���:j�j*��j�� �j�#�6k�k� �+�j�k�'+,� 3+++� 7*� �-2�e *� �/2�~����+.� 3�j�K��ȧ 2�:l�j�l�O�  �:m�k� +�SW�j�V�m��k� +�SW�j�V�j�W� �D�� �:n+� t�j�H�n�+� t�j�H� �:o+� ��o�+� �+�� 3�j++� 7*� �-2�e *� �.2�~\� �� � �>+�� 3+� �+� t���:p�p$��p�� �p�#�6q�q� �+�p�q�'+&� 3+++� 7*� �-2�e *� �02�~����+(� 3�p�K��ȧ 2�:r�p�r�O�  �:s�q� +�SW�p�V�s��q� +�SW�p�V�p�W� �D�� �:t+� t�p�H�t�+� t�p�H� �:u+� ��u�+� �+�� 3+� �+� t���:v�v*��v�� �v�#�6w�w� �+�v�w�'+,� 3+++� 7*� �-2�e *� �02�~����+.� 3�v�K��ȧ 2�:x�v�x�O�  �:y�w� +�SW�v�V�y��w� +�SW�v�V�v�W� �D�� �:z+� t�v�H�z�+� t�v�H� �:{+� ��{�+� �+�� 3� +�� 3+� 7*� �2� � �� �� � �+~� 3+� �+� t���:|�|0��|+� 7� =� � � �|�#�6}�}� �+�|�}�'+2� 3++� 7*� �$2� � ����+� 3�|�K��ӧ 2�:~�|�~�O�  �:�}� +�SW�|�V���}� +�SW�|�V�|�W� �D�� �:�+� t�|�H���+� t�|�H� �:�+� ����+� �+�� 3++� 7*� �52�e �k�n� � �	�+�� 3++� 7*� �-2�e *� �62�~�� �� � � �+~� 3+� 7*� �72+++� 7*� �-2�e *� �62�~4�9� E W+~� 3+� 7*� �82+++� 7*� �-2�e *� �62�~;�>� E W+~� 3+� 7*� �92+� 7*� �72� � ��@� +� 7*� �82� � ��� � E W+~� 3� R++� 7*� �-2�e *� �62�~�� �� � � &+~� 3+� 7*� �92B� E W+~� 3� +�� 3+� 7�Z� � � �� � � &+~� 3+� 7*� �:2�b� E W+~� 3� D+� 7�Z� � � �� � � &+~� 3+� 7*� �:2�]� E W+~� 3� +�� 3+� 7*� �;2+++� 7*� �-2�e *� �<2�~4�9� E W+~� 3+� 7*� �=2+++� 7*� �-2�e *� �<2�~;�>� E W+~� 3+� 7*� �>2+� 7*� �;2� � ��@� +� 7*� �=2� � ��� � E W+�� 3+� �+~� 3+� �+� t���:���D���+� 7� =� � � ���#�6�����+�����'+F� 3++� �2� � ����+H� 3+++� 7*� �?2�e *� �@2�~����+H� 3++� 7*� �42� � ����+H� 3++� 7*� �92� � ����+H� 3++� 7*� �>2� � ����+H� 3+++� 7*� �A2�e *� �&2�~����+H� 3+++� 7*� �A2�e *� �B2�~����+H� 3+++� 7*� �A2�e *� �32�~����+H� 3+++� 7*� �A2�e *� �/2�~����+J� 3++� 7*� �:2� � ����+ܶ 3���K���� 2�:������O�  �:���� +�SW���V������ +�SW���V���W� �D�� �:�+� t���H���+� t���H� �:�+� ����+� �+~� 3� �:�+� ����+� �+�� 3+*���:�+���6������� �6����� � � �~�6������� ���:�+� 7���� ��d�6�����`�ę����������� � � � �������6�+~� 3+� �+�� 3+� �+� t���:���L���+� 7� =� � � ���#�6���� �+�����'+N� 3+++� 7*� �A2�e *� �32�~����+� 3���K��ȧ 2�:������O�  �:���� +�SW���V������ +�SW���V���W� �D�� �:�+� t���H���+� t���H� �:�+� ����+� �+�� 3+� �+� t���:���D���+� 7� =� � � ���#�6�����+�����'+P� 3++� �2� � ����+H� 3+++� 7*� �?2�e *� �@2�~����+H� 3++� 7*� �92� � ����+H� 3++� 7*� �>2� � ����+R� 3++� 7*� �42� � ����+H� 3++� 7*� �&2� � ����+H� 3++� 7*� �B2� � ����+H� 3++� 7*� �32� � ����+H� 3++� 7*� �/2� � ����+H� 3++� 7*� �.2� � ����+H� 3+++� 7*� �C2�e �2�~����+H� 3++� 7*� �:2� � ����+ܶ 3���K��{� 2�:������O�  �:���� +�SW���V������ +�SW���V���W� �D�� �:�+� t���H���+� t���H� �:�+� ����+� �+~� 3� �:�+� ����+� �+~� 3��� .�:��������� W+� 7�� ��������������� W+� 7�� ����+�� 3� +�� 3�P+� 7*� �2� � Ǹ �� � �0+~� 3+� �+� t���:���0���+� 7� =� � � ���#�6���� �+�����'+2� 3++� 7*� �$2� � ����+� 3���K��ӧ 2�:������O�  �:���� +�SW���V������ +�SW���V���W� �D�� �:�+� t���H���+� t���H� �:�+� ����+� �+�� 3++� 7*� �52�e �k�n� � �
�+�� 3++� 7*� �-2�e *� �62�~�� �� � � �+~� 3+� 7*� �72+++� 7*� �-2�e *� �62�~4�9� E W+~� 3+� 7*� �82+++� 7*� �-2�e *� �62�~;�>� E W+~� 3+� 7*� �92+� 7*� �72� � ��@� +� 7*� �82� � ��� � E W+~� 3� R++� 7*� �-2�e *� �62�~�� �� � � &+~� 3+� 7*� �92B� E W+~� 3� +�� 3+� 7�Z� � � �� � � &+~� 3+� 7*� �:2�b� E W+~� 3� D+� 7�Z� � � �� � � &+~� 3+� 7*� �:2�]� E W+~� 3� +�� 3+� 7*� �;2+++� 7*� �-2�e *� �<2�~4�9� E W+~� 3+� 7*� �=2+++� 7*� �-2�e *� �<2�~;�>� E W+~� 3+� 7*� �>2+� 7*� �;2� � ��@� +� 7*� �=2� � ��� � E W+�� 3+� t������:�������e���T�L��V�l���W���� �D�� �:�+� t���H���+� t���H+�� 3+� 7*� �D2++� 7*� �2� � ��+� 7*� �E2� � ��XZ�]� E W+�� 3+� �+~� 3+� �+� t���:���D���+� 7� =� � � ���#�6�����+�����'+_� 3++� �2� � ����+H� 3+++� 7*� �?2�e *� �@2�~����+H� 3++� 7*� �D2� � ����+H� 3++� 7*� �42� � ����+H� 3++� 7*� �92� � ����+H� 3++� 7*� �>2� � ����+R� 3+++� 7*� �A2�e *� �&2�~����+H� 3+++� 7*� �A2�e *� �B2�~����+H� 3+++� 7*� �A2�e *� �32�~����+H� 3+++� 7*� �A2�e *� �/2�~����+J� 3++� 7*� �:2� � ����+ܶ 3���K��t� 2�:������O�  �:���� +�SW���V������ +�SW���V���W� �D�� �:�+� t���H���+� t���H� �:�+� ����+� �+~� 3� �:�+� ����+� �+�� 3+*���:�+���6������� �6����� � � ���6������� ���:�+� 7���� ��d�6�����`�ę���������� � � � �������6�+~� 3+� �+�� 3+� �+� t���:���L���+� 7� =� � � ���#�6���� �+�����'+N� 3+++� 7*� �A2�e *� �32�~����+� 3���K��ȧ 2�:������O�  �:���� +�SW���V������ +�SW���V���W� �D�� �:�+� t���H���+� t���H� �:�+� ����+� �+�� 3+� �+� t���:���D���+� 7� =� � � ���#�6�����+�����'+a� 3++� �2� � ����+H� 3+++� 7*� �?2�e *� �@2�~����+H� 3++� 7*� �D2� � ����+H� 3++� 7*� �92� � ����+H� 3++� 7*� �>2� � ����+R� 3++� 7*� �42� � ����+H� 3++� 7*� �&2� � ����+H� 3++� 7*� �B2� � ����+H� 3++� 7*� �32� � ����+H� 3++� 7*� �/2� � ����+H� 3++� 7*� �.2� � ����+H� 3+++� 7*� �C2�e �2�~����+H� 3++� 7*� �:2� � ����+ܶ 3���K��]� 2�:������O�  �:���� +�SW���V������ +�SW���V���W� �D�� �:�+� t���H���+� t���H� �:�+� ����+� �+~� 3� �:�+� ��¿+� �+~� 3��� .�:��������� W+� 7�� �����ÿ�������� W+� 7�� ����+�� 3+� 7*� �2�� E W+~� 3+� 7*� �D2�� E W+c� 3��++� 7*� �52�e �k�n� � ��+�� 3++� 7*� �'2�e �k�n� � ��+�� 3+� t������:�������e���T�L��V�l�ĶW�Ķ� �D�� �:�+� t�ĶH�ſ+� t�ĶH+�� 3+� 7*� �D2++� 7*� �2� � ��+� 7*� �E2� � ��XZ�]� E W+�� 3+� �+� t���:���c���+� 7� =� � � �ƶ#�6���� �+���Ƕ'+e� 3++� 7*� �D2� � ����+g� 3+++� 7*� �A2�e *� �32�~����+� 3�ƶK���� 2�:����ȶO�  �:���� +�SW�ƶV�ɿ��� +�SW�ƶV�ƶW� �D�� �:�+� t�ƶH�ʿ+� t�ƶH� �:�+� ��˿+� �+�� 3+*���:�+���6����ι� �6��͹� � � �"�6����͹� ���:�+� 7�͹� ��d�6�����`�ę����̶��ι� � � � �p�̶��6�+~� 3+� �+~� 3+� �+� t���:���i���+� 7� =� � � �Զ#�6���� �+���ն'+e� 3++� 7*� �D2� � ����+g� 3++� 7*� �32� � ����+� 3�ԶK���� 2�:����ֶO�  �:���� +�SW�ԶV�׿��� +�SW�ԶV�ԶW� �D�� �:�+� t�ԶH�ؿ+� t�ԶH� �:�+� ��ٿ+� �+~� 3� �:�+� ��ڿ+� �+~� 3��d� .�:������ι� W+� 7�� �̸��ۿ�����ι� W+� 7�� �̸�+�� 3+� 7*� �2�� E W+~� 3+� 7*� �D2�� E W+�� 3� +�� 3� +�� 3� +�� 3+� 7���� E W+�� 3+� 7*� � 2+� 7*� �2� � ��� � E W+~� 3++� 7*� � 2� � �G� �+�� 3+� t������:�������I���+� 7*� � 2� � ���L�ܶW�ܶ� �D�� �:�+� t�ܶH�ݿ+� t�ܶH+~� 3� +�� 3� +�� 3� +k� 3+� �+m� 3++� 7�2� � ��� 3+o� 3++� 7�Z� � ��� 3+q� 3++� 7*� �2� � ��� 3+s� 3++� 7*� �2� � ��� 3+u� 3++� 7� �� � ��� 3� �:�+� ��޿+� �+w� 3+� �++� 7*� �2� � ��� 3� �:�+� ��߿+� �+y� 3+� �+{� 3++� 7*� �2� � ��� 3+}� 3� �:�+� ���+� �+� 3+�� 3+� 7*� �2� � �� �� � � O+~� 3+� �+�� 3++� 7*� �2� � ��� 3+�� 3� �:�+� ���+� �+�� 3� o+� 7*� �2� � Ǹ �� � � O+~� 3+� �+�� 3++� 7*� �2� � ��� 3+�� 3� �:�+� ���+� �+~� 3� +�� 3+�� 3+�� 3+�� 3+�� 3+� 7�� � � �� � � 1+~� 3+� �+�� 3� �:�+� ���+� �+~� 3� +�� 3+� 7�� � � �� � � 1+~� 3+� �+�� 3� �:�+� ���+� �+~� 3� +�� 3+� 7�� � a� �� � � 1+~� 3+� �+�� 3� �:�+� ���+� �+~� 3� +�� 3+� 7�� � �� �� � � 1+~� 3+� �+�� 3� �:�+� ���+� �+~� 3� +�� 3+� 7�� � � �� � � 1+~� 3+� �+�� 3� �:�+� ���+� �+~� 3� +�� 3+� 7�� � � �� � � 1+~� 3+� �+�� 3� �:�+� ���+� �+~� 3� +�� 3+� 7�� � �� �� � � 1+~� 3+� �+�� 3� �:�+� ���+� �+~� 3� +�� 3+� 7�� � � �� � � 1+~� 3+� �+�� 3� �:�+� ���+� �+~� 3� +�� 3+� 7�� � � �� � � 1+~� 3+� �+�� 3� �:�+� ���+� �+~� 3� +�� 3+� 7�� � �� �� � � 1+~� 3+� �+�� 3� �:�+� ���+� �+~� 3� +�� 3+�� 3+�� 3+� 7�Z� � � �� � �+�� 3+� �+�� 3++� �2� � ��� 3+q� 3++� 7*� �2� � ��� 3+s� 3++� 7*� �2� � ��� 3+�� 3++� 7*� �2� � ��� 3+u� 3++� 7� �� � ��� 3� �:�+� ����+� �+�� 3+� 7�Z� � � �� � � +�� 3� ++� 7�Z� � � �� � � +�� 3� +�� 3�,+� 7�Z� � � �� � �+�� 3+� �+�� 3++� �2� � ��� 3+q� 3++� 7*� �2� � ��� 3+s� 3++� 7*� �2� � ��� 3+�� 3++� 7*� �2� � ��� 3+u� 3++� 7� �� � ��� 3� �:�+� ���+� �+�� 3+� 7�Z� � � �� � � +�� 3� ++� 7�Z� � � �� � � +�� 3� +�� 3� +ö 3+Ŷ 3+� 7*� �F2++��̸9� E W+~� 3+� �+� t���:���ζ��+� 7� =� � � ��#�6���� g+����'+ж 3��K��� 2�:�����O�  �:���� +�SW��V����� +�SW��V��W� �D�� �:�+� t��H��+� t��H� �:�+� ����+� �+~� 3+� �+� t���:���Ҷ��+� 7� =� � � ���#�6���� g+�����'+Զ 3���K��� 2�:������O�  �:���� +�SW���V������ +�SW���V���W� �D�� �:�+� t���H���+� t���H� �:�+� ����+� �+~� 3+� �+ֶ 3++��*� �G2�� ��� 3+߶ 3+++� 7*� �H2�e ��~��� 3+� 3+++� 7*� �I2�e ��~��� 3+� 3++� 7*� �F2� � ��� 3+� 3� �:�+� ����+� �+� 3����    bkk  ���  |��  b�� )b��  4  !11  �&&  �LO )�X[  ���  ���  Z��  @�� )@��  ��  �  ���  ��� )���  �  y11  �;;  �ww  ��� )���  [��  H��  K�� )K��  ��  
��  m�� )m��  ?��  ,  ���  `��  p�� )���  ���  pIL  ���  ���  � p p   � � �   �!'!'  !�!�!�  !W!�!�  "i"�"�  #S#�#�  $z$�$� )$z$�$�  $U$�$�  $B%%  %V%�%� )%V%�%�  %1%�%�  %%�%�  &�''  '�'�'�  ((�(�  ))')'  (�)S)S  )�)�)�  )�**  *�*�*�  ++�+�  ,�,�,� ),�,�,�  ,�--  ,n-3-3  -�-�-� )-�-�-�  -]. .   -J..  .�/;/;  00N0N  0~11  1{1�1�  121�1�  2:2L2L  1�2x2x  2�3838  3�4"4"  5l5�5�  6�6�6�  77�7�  888  7�8A8A  8�8�8�  8q9 9   9�9�9�  :m:�:�  ;�<1<1  =a=�=�  =�>J>J  >�>�>�  >z??  ?�?�?�  ?1?�?�  @C@�@�  A,AiAi  B%BZBZ  B�CC  C?C�C�  C�DDDD  D�D�D�  DtD�D�  E�E�E�  E9E�E�  EFF )F�GG  EG}G�  HHJHJ  I IGIG  J{J�J� )J{J�J�  JHKK  J3K&K&  L\L�L� )L\L�L�  L)L�L�  LMM  N(NiNi  N�O5O5  O�O�O�  OoPP  P�P�P�  PLP�P�  Q�Q�Q�  R�R�R� )R�R�R�  R`SS  RKS>S>  S�TT )S�T T#  S�TgTg  S�T�T�  U!U\U_ )U!UnUq  T�U�U�  T�U�U�  VCV~V� )VCV�V�  VV�V�  U�V�V�  W�W�W� )W�W�W�  W]X$X$  WHXFXF  X�X�X� )X�X�X�  XvY=Y=  XaY_Y_  Y�Y�Z  )Y�ZZ  Y�ZVZV  YzZxZx  W>Z�Z�  [[T[T  [�\+\+  \�\�\�  \e]]  ]�]�]�  ]B]�]�  ^�^�^�  _�``  `�a)a)  b!b\b_ )b!bnbq  a�b�b�  a�b�b�  c:cucx )c:c�c�  cc�c�  b�c�c�  d�d�d� )d�d�d�  dUee  d@e>e>  e�e�e� )e�e�e�  enf5f5  eYfWfW  f�g"g% )f�g4g7  f�g{g{  f�g�g�  j�l/l2 )j�lAlD  j�l�l�  jml�l�  jcl�l�  m�n!n$ )m�n3n6  m�nznz  m�n�n�  op�p� )op�p�  n�p�p�  n�qq  m�q%q%  mDqBqB  rrLrO )rr^ra  q�r�r�  q�r�r�  u�u�u�  v�x9x< )v�xKxN  vnx�x�  vYx�x�  vOx�x�  y�z+z. )y�z=z@  y�z�z�  y�z�z�  {|�|� ){|�|�  z�}}  z�}3}3  y�}M}M  yN}j}j  ~\~�~�  ^�� )^��  "��  �2�2  �T���� )�T����  �����  ���  ���7�7  ���T�T  �l����  ������  ������  �Մ���  �F�n�n  ���څ�  �>�H�H  ������  ����  �4�>�>  ������  �؇��  �*�4�4  �|����  �͈׈�  ��)�)  ����  ���8�8  �.�@�C )�.�R�U  �򌙌�  �݌���  �'�9�< )�'�K�N  �덒��  �֍���  �ώ_�_   �         * +  �  ��          ! O $ P - c � d � eI f� h i4 jZ k l� m� }� ~� �� �� �� �� �� �� � � �# �& �/ �2 �[ �e �x �{ �� �� �� �� �� �� �6 �� �� �\ �� �� �� �� �< �c �� �� �� � �@ �g �� �� �� �$ �G �f �r �� �� �	 �	: �	F �	� �	� �	� �
! �
- �
� �
� �
� �	 � �z ����f�	A
Wp��@���D�5>Gq�� )"�#�$�% &(1*r,�.A0�4�57O8x9�;%=q>�?A;BbC|D�E�F�G�HI=JWK`LiN�O�P�Q�RS-T6V<W?Zg[t\�]�^�_�\�_�abJcpd�e�c�e�gi*k-lZmwn�o�n�o�p�rsu#wIyLzy{�|�} | }~�&�=�C�F�]�`���� �6�P�S���������
����"�K�N�q�t�����  � �� �� �� �� �� ��!A�!}�!��!��!��" �"�"6�"S�"y�"��"��"��"��"��"��# �#=�#c�#��#��#��#��#��#��$�$;�$>�$~�$��%�%Z�%��%��&(�&B�&o�&r�&��&��&��'&�'&�')�'2�'L�'b�'k�'q�'t�'��'��(�((�(L�(��(��(��(��(��)�)m�)��)��)� )�*,*/*b**�*�*�*�*�
+++L+i+�+�+�+�+�+�,,9,g,j,�,�-C-�-� .*".T#.n$.�&.�'.�(.�)/*/R)/R*/U+/^-/x./�//�0/�1/�2/�6/�7/�9/�:/�@/�B/�D0F0H0hJ0�K0�L1J1L1N1<O1`P1~Q1�T2U2V2W2=X2�[2�\2�]2�^3_3O^3O_3R`3[b3�d3�e3�f3�g3�h49g49h4<i4Ek4_l4um4�n4�p4�u5	w5x59y5Vz5|{5�z5�{5�|5�~5�5��66�6P�6Y�6_�6b�6��6��6��7�7:�7��7��7��7��7��8�8[�8��8��8��8��9�9�9P�9m�9��9��9��9��9��:
�:�::�:W�:}�:��:��:��:��:��:��;'�;Z�;]�;��;��;��;��<�<H�<H�<K�<T�<n�<��<��<��<��<��<��<��<��<��<��=%�=K�=N�=��=��=��>a�>a�>d�>��>��>��?�?W�?_�?g�?��?��?��@�@-�@S�@��@��@��@��@��@��@��A�A<�A��A��A��A��A��A��A��A�A�A�A�	BBBtB�B�C%C%C)C�C�C�D[D[D^D~D�D�EE! Ec!Em"Ew#E�$F	&F:(Fc*Ff+F�,F�-F�.G4-G4.G70G=1G@3GZ4Gq6Gw9Gz;G�>G�@G�AG�BG�CHDHiCHiDHlFHrGHuIH�KH�LH�MH�NIOIfNIfOIiPIrRI�SI�UI�VI�XI�YI�[I�^I�`I�aI�cJeJ,fJgJ�hK:jKdkK~lK�mK�nK�oK�pK�rLsL`tL~uMwMMxMgyM�zM�{M�|M�}M�M��M��M��M��N�N�N��N��N��OT�OT�OW�O}�O��O��P4�Pv�P��P��P��Q�Q�QQ�Qn�Q��Q��Q��Q��Q��Q��R�R�R�RD�RG�R��R��SR�SU�S��S��T �T��T��U%�UN�U��U��U��VG�Vp�W�W7�WA�W��W��XZ�X��X��Ys�Y��Y��Z��Z��Z��Z��Z��Z��Z��Z��Z��Z��[v�[��[��\J�\J�\M�\s�\��\��]*�]l�]v�]��]��^�^7�^:�^g�^��^��_�_�_�_�_(�_>�_g_j_�_�_�`2`2`5`>`X	`n`w`z`�`�`�aHaHaKaUaXaoauaxa�!a�#a�%b%&bN'b�)c>*cg+d-d9/d�0d�1eR3e�4e�5fk7ft9f�:f�;g<g�>g�@hAhFBhCh�Dh�EiFiHi@IiZJi�Ki�Li�Ni�OjPj\RjfSj�Xl!Yl�Zl�\m�]m�_m�`nan�coho�ip�jqkq9lq�nq�oq�qq�rr sr>tr�vsxs7yspzs�{s�|t$}t>~tG�tj�t��t��t��t��u�u@�u��v�v�vH�vR�v��wi�x+�x��x��y��y��y��z�z��{�{��|��}G�}a�}��}��}��}��~�~D�~��~���b����F������XÁ�Ă1łKƂ�Ȃ�ɂ�˂�̂�΂�ς�т�҂�ԃփ
׃7؃Tك�ڃ�ك�ڃ�ۃ������������焙�������?�J�h������������#��$�@�	L�M�e�7f�Bg�Yh�\i�ek��l��m��q��r��t��u��v��w� x�	z�-{�8|�O}�R~�[�������������������������������#��.��E��H��Q��u�������������������������������#��:��=��G��J��N��QЉUщX؉yي$݊'�H�N�p�v�z늀�����M �P	�q
�w����������5��6��?��@�2B��C�+E��F��G�tH�     ) �� �        �    �     ) �� �         �    �     ) �� �        �    �    �    �  �    �*J� �Y��SY�SY�SY�SY�SY�SY	�SY��SY�SY	�SY
�SY�SY�SY�SY�SY�SY�SY�SY�SY�SY�SY�SY!�SY#�SY%�SY'�SY)�SY+�SY-�SY/�SY1�SY3�SY 5�SY!7�SY"9�SY#;�SY$=�SY%?�SY&A�SY'C�SY(E�SY)G�SY*I�SY+K�SY,M�SY-O�SY.Q�SY/S�SY0U�SY1W�SY2Y�SY3[�SY4]�SY5_�SY6a�SY7c�SY8e�SY9g�SY:i�SY;k�SY<m�SY=o�SY>q�SY?s�SY@u�SYAw�SYBy�SYC{�SYD}�SYE�SYF��SYG��SYH��SYI��S� ��     �    