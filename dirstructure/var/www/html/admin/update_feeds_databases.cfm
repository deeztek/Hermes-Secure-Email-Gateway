����   2I R__138/__138/publish/hermes_seg_18_041454/proprietary/update_feeds_databases_cfm$cf  lucee/runtime/PageImpl  E../../publish/hermes-seg-18.04/proprietary/update_feeds_databases.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  �͐�� getSourceLength      O getCompileTime  �@,�[ getHash ()I�#�' call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this TL__138/__138/publish/hermes_seg_18_041454/proprietary/update_feeds_databases_cfm$cf;@       keys $[Llucee/runtime/type/Collection$Key; . /	  0 !lucee/runtime/type/Collection$Key 2 *lucee/runtime/functions/decision/IsDefined 4 B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & 6
 5 7 
 9 lucee/runtime/PageContext ; write (Ljava/lang/String;)V = >
 < ? sessionScope $()Llucee/runtime/type/scope/Session; A B
 < C  lucee/runtime/type/scope/Session E get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; G H F I 	VIOLATION K lucee/runtime/op/Operator M compare '(Ljava/lang/Object;Ljava/lang/String;)I O P
 N Q lucee/runtime/PageContextImpl S lucee.runtime.tag.Location U 
cflocation W DC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:3 Y use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; [ \
 T ] lucee/runtime/tag/Location _ license_invalid.cfm a setUrl c >
 ` d setAddtoken (Z)V f g
 ` h 
doStartTag j $
 ` k doEndTag m $
 ` n lucee/runtime/exp/Abort p newInstance (I)Llucee/runtime/exp/Abort; r s
 q t reuse !(Ljavax/servlet/jsp/tagext/Tag;)V v w
 T x NEW z DC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:5 |h
<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Update Feeds Databases</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
 ~ us &()Llucee/runtime/type/scope/Undefined; � �
 < � $lucee/runtime/type/util/KeyConstants � _DATASOURCE #Llucee/runtime/type/Collection$Key; � �	 � � hermes � "lucee/runtime/type/scope/Undefined � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � �f

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="867">
    <tr valign="top" align="left">
      <td width="47" height="57"></td>
      <td width="820"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="820" id="Text378" class="TextObject">
        <p style="margin-bottom: 0px;">
 � outputStart � 
 < � lucee.runtime.tag.Query � cfquery � EC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:40 � lucee/runtime/tag/Query � hasBody � g
 � � customtrans � setName � >
 � � � I setDatasource (Ljava/lang/Object;)V � �
 � � getrandom_results � 	setResult � >
 � �
 � k initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 < � Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 < � 	doFinally � 
 � �
 � n 	outputEnd � 
 < � 

 � EC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:44 � inserttrans � stResult � &
insert into salt
(salt)
values
(' � getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query; � �
 < � getId � $
 < � lucee/runtime/type/Query � getCurrentrow (I)I � � � � getRecordcount � $ � � !lucee/runtime/util/NumberIterator � load '(II)Llucee/runtime/util/NumberIterator; � �
 � � addQuery (Llucee/runtime/type/Query;)V � � � � isValid (I)Z � �
 � � current � $
 � � go (II)Z � � � � lucee/runtime/op/Caster � toString &(Ljava/lang/Object;)Ljava/lang/String; � �
 � � #lucee/runtime/functions/string/Trim � A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &
  writePSQ �
 < removeQuery  � release &(Llucee/runtime/util/NumberIterator;)V

 � ')
 EC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:51 gettrans 2
select salt as customtrans2 from salt where id=' getCollection H � I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; G
 < '
 EC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:57 deletetrans  
delete from salt where id='" 



$ EC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:63& sanesecurityconf( M
select enabled, update_int from malware_feeds where name = 'sanesecurity'
* lucee.runtime.tag.FileTag, cffile. EC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:670 lucee/runtime/tag/FileTag2
3 � read5 	setAction7 >
38  /opt/hermes/conf_files/user.conf: setFile< >
3= temp? setVariableA >
3B
3 k
3 n yesF EC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:71H = /opt/hermes/tmp/K java/lang/StringM concat &(Ljava/lang/String;)Ljava/lang/String;OP
NQ 
_user.confS SANESECURITY-ENABLEDU ALLW (lucee/runtime/functions/string/REReplaceY w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &[
Z\ 	setOutput^ �
3_ setAddnewlinea g
3b nod EC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:77f 


h EC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:85j sanesecuritydbsl b
select db, active, feed from malware_databases where feed = 'sanesecurity' and active = 'true'
n EC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:89p _sanesecuritydbsr  t 
    
v EC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:96x appendz@$       "lucee/runtime/functions/string/Chr~ 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &�
�     

� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:102� sanesecuritydbsfile� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:104� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:106� SANESECURITY-DBS� 'lucee/runtime/functions/file/FileExists� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &�
�� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:112� delete� 






� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:122� securiteinfoconf� e
select enabled, update_int, code, securite_premium from malware_feeds where name = 'securiteinfo'
� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:126� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:130� $SECURITEINFO-AUTHORIZATION-SIGNATURE� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:134� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:136� SECURITEINFO-UPDATE� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:140� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:142� SECURITEINFO-ENABLED� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:148� 


    
� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:153� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:155� 
    
    
� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:160� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:162� 
    


� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:172� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:174� SECURITE-PREMIUM� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:180� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:182� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:192� securiteinfodbs� b
select db, active, feed from malware_databases where feed = 'securiteinfo' and active = 'true'
� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:196� _securiteinfodbs� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:203� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:209� securiteinfodbsfile� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:211� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:213� SECURERITEINFO-DBS� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:218� 
    






� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:230� malwarepatrolconf� w
select enabled, update_int, code, product, list, malwarepatrol_free from malware_feeds where name = 'malwarepatrol'
� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:234� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:238� MALWAREPATROL-RECEIPT-CODE� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:242� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:244� MALWAREPATROL-PRODUCT-CODE� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:249� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:251� MALWAREPATROL-LIST� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:255� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:257  MALWAREPATROL-FREE FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:261 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:263 MALWAREPATROL-UPDATE FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:267
 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:269 MALWAREPATROL-ENABLED FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:275 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:279 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:281 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:285 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:287 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:292 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:294 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:298 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:300  FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:304" FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:306$ 





& FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:317( linuxmalwaredetectconf* S
select enabled, update_int from malware_feeds where name = 'linuxmalwaredetect'
, FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:321. FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:3250 LINUXMALWAREDETECT-UPDATE2 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:3294 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:3316 LINUXMALWAREDETECT-ENABLED8 FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:337: FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:342< FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:344> FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:352@ linuxmalwaredetectdbsB h
select db, active, feed from malware_databases where feed = 'linuxmalwaredetect' and active = 'true'
D FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:356F _linuxmalwaredetectdbsH FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:363J FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:369L linuxmalwaredetectdbsfileN FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:371P FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:373R LINUXMALWAREDETECT-DBST FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:379V 
    







X FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:392Z yararulesconf\ J
select enabled, update_int from malware_feeds where name = 'yararules'
^ FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:396` FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:400b YARARULES-UPDATEd FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:404f FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:406h YARARULES-ENABLEDj FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:412l FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:417n FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:419p FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:427r yararulesdbst _
select db, active, feed from malware_databases where feed = 'yararules' and active = 'true'
v FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:431x _yararulesdbsz FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:438| FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:444~ yararulesdbsfile� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:446� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:448� YARARULES-DBS� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:454�    
    





� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:465� urlhausconf� H
select enabled, update_int from malware_feeds where name = 'urlhaus'
� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:469� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:473� URLHAUS-UPDATE� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:477� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:479� URLHAUS-ENABLED� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:485� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:489� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:491� 
    
    

� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:500� 
urlhausdbs� ]
select db, active, feed from malware_databases where feed = 'urlhaus' and active = 'true'
� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:504� _urlhausdbs� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:511� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:517� urlhausdbsfile� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:519� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:521� URLHAUS-DBS� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:527�    
    




� lucee.runtime.tag.Execute� 	cfexecute� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:539� lucee/runtime/tag/Execute� /bin/cp�
� � M/etc/clamav-unofficial-sigs/user.conf /etc/clamav-unofficial-sigs/user.HERMES� setArguments� �
��@N       
setTimeout (D)V��
��
� k
� �
� n FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:544� 0_user.conf /etc/clamav-unofficial-sigs/user.conf� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:549� FC:\publish\hermes-seg-18.04\proprietary\update_feeds_databases.cfm:553� updatedatabases� .
update malware_databases set applied = '1'
� _M� �	 �� #lucee/commons/color/ConstantsDouble� _7 Ljava/lang/Double;��	�� _8��	�� M&nbsp;</p>
      </td>
    </tr>
  </table>
  

</body>
</html>
 ����� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource 
  license lucee/runtime/type/KeyImpl intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;	

 LICENSE RANDOM STRESULT GENERATED_KEY CUSTOMTRANS3 GETTRANS CUSTOMTRANS2 SANESECURITYCONF ENABLED TEMP DB  SANESECURITYDBSFILE" SECURITEINFOCONF$ CODE& 
UPDATE_INT( SECURITE_PREMIUM* SECURITEINFODBSFILE, MALWAREPATROLCONF. PRODUCT0 LIST2 MALWAREPATROL_FREE4 LINUXMALWAREDETECTCONF6 LINUXMALWAREDETECTDBSFILE8 YARARULESCONF: YARARULESDBSFILE< URLHAUSCONF> URLHAUSDBSFILE@ subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             . /   BC       D   *     *� 
*� *� � *��� *+��        D         �        D        � �        D         �        D         �         D         !�      # $ D        %�      & ' D  a� d  U7+ ,*� 12� 3� 8�+:� @+� D*� 12� J L� R� � � W+:� @+� TVXZ� ^� `M,b� e,� i,� lW,� o� � u�� N+� T,� y-�+� T,� y+:� @� �+� D*� 12� J {� R� � � `+:� @+� TVX}� ^� `:b� e� i� lW� o� � u�� :+� T� y�+� T� y+:� @� +:� @� +� @+� �� ��� � W+�� @+� �+� T���� ^� �:� ��� �+� �� �� � � ��� �� �6� N+� �+�� @� ����� $:� �� :	� +� �W� �	�� +� �W� �� �� � u�� :
+� T� y
�+� T� y� :+� ��+� �+˶ @+� �+� T��Ͷ ^� �:� �϶ �+� �� �� � � �Ѷ �� �6�?+� �+Ӷ @+� �+�� �:+� �6� � 6� � � � � �6� � � �:+� �� � d6`� � C� �� � � � � � '� �6+++� �*� 12� � � ������� ":� � W+� ��	 ��� � W+� ��	 �� :+� ��+� �+� @� ���� $:� �� :� +� �W� ��� +� �W� �� �� � u�� :+� T� y�+� T� y� :+� ��+� �+˶ @+� �+� T��� ^� �:� �� �+� �� �� � � �� �6� v+� �+� @+++� �*� 12� *� 12�� ��+� @� ���̧ $:� �� :� +� �W� ��� +� �W� �� �� � u�� : +� T� y �+� T� y� :!+� �!�+� �+˶ @+� �*� 12++� �*� 12� *� 12�� � W+˶ @+� �+� T��� ^� �:""� �"!� �"+� �� �� � � �"� �6##� v+"#� �+#� @+++� �*� 12� *� 12�� ��+� @"� ���̧ $:$"$� �� :%#� +� �W"� �%�#� +� �W"� �"� �� � u�� :&+� T"� y&�+� T"� y� :'+� �'�+� �+%� @+� �+� T��'� ^� �:((� �()� �(+� �� �� � � �(� �6))� O+()� �++� @(� ���� $:*(*� �� :+)� +� �W(� �+�)� +� �W(� �(� �� � u�� :,+� T(� y,�+� T(� y� :-+� �-�+� �+˶ @+� T-/1� ^�3:..�4.6�9.;�>.@�C.�DW.�E� � u�� :/+� T.� y/�+� T.� y+˶ @++� �*� 12� *� 1	2�G� R� � � �+˶ @+� T-/I� ^�3:00�40J�90L+� �*� 12� � � ��RT�R�>0++� �*� 1
2� � � �VGX�]�`0�c0�DW0�E� � u�� :1+� T0� y1�+� T0� y+˶ @� �++� �*� 12� *� 1	2�e� R� � � �+˶ @+� T-/g� ^�3:22�42J�92L+� �*� 12� � � ��RT�R�>2++� �*� 1
2� � � �VeX�]�`2�c2�DW2�E� � u�� :3+� T2� y3�+� T2� y+i� @� +i� @+� �+� T��k� ^� �:44� �4m� �4+� �� �� � � �4� �655� O+45� �+o� @4� ���� $:646� �� :75� +� �W4� �7�5� +� �W4� �4� �� � u�� :8+� T4� y8�+� T4� y� :9+� �9�+� �+˶ @+� T-/q� ^�3:::�4:J�9:L+� �*� 12� � � ��Rs�R�>:u�`:�c:�DW:�E� � u�� :;+� T:� y;�+� T:� y+w� @+� �+m� �:=+� �6>=>� � 6?=� � � � �<6@@=� � � �:<+� �=� � @d6C<C`� � �=<� �>� � � � � � �<� �6C+˶ @+� T-/y� ^�3:DD�4D{�9DL+� �*� 12� � � ��Rs�R�>D+� �*� 12� � � �+|���R�`D�cD�DWD�E� � u�� :E+� TD� yE�+� TD� y+:� @��(� ":F=?>� � W+� ��	 <�F�=?>� � W+� ��	 <�� :G+� �G�+� �+�� @+� T-/�� ^�3:HH�4H6�9HL+� �*� 12� � � ��Rs�R�>H��CH�DWH�E� � u�� :I+� TH� yI�+� TH� y+˶ @+� T-/�� ^�3:JJ�4J6�9JL+� �*� 12� � � ��RT�R�>J@�CJ�DWJ�E� � u�� :K+� TJ� yK�+� TJ� y+˶ @+� T-/�� ^�3:LL�4LJ�9LL+� �*� 12� � � ��RT�R�>L++� �*� 1
2� � � ��+� �*� 12� � � �X�]�`L�cL�DWL�E� � u�� :M+� TL� yM�+� TL� y+i� @+L+� �*� 12� � � ��Rs�R��� �+:� @+� T-/�� ^�3:NN�4N��9NL+� �*� 12� � � ��Rs�R�>N�DWN�E� � u�� :O+� TN� yO�+� TN� y+:� @� +�� @+� �+� T���� ^� �:PP� �P�� �P+� �� �� � � �P� �6QQ� O+PQ� �+�� @P� ���� $:RPR� �� :SQ� +� �WP� �S�Q� +� �WP� �P� �� � u�� :T+� TP� yT�+� TP� y� :U+� �U�+� �+˶ @+� T-/�� ^�3:VV�4V6�9VL+� �*� 12� � � ��RT�R�>V@�CV�DWV�E� � u�� :W+� TV� yW�+� TV� y+˶ @++� �*� 12� *� 1	2�G� R� � �:+˶ @+� T-/�� ^�3:XX�4XJ�9XL+� �*� 12� � � ��RT�R�>X++� �*� 1
2� � � ��++� �*� 12� *� 12�� �X�]�`X�cX�DWX�E� � u�� :Y+� TX� yY�+� TX� y+˶ @+� T-/�� ^�3:ZZ�4Z6�9ZL+� �*� 12� � � ��RT�R�>Z@�CZ�DWZ�E� � u�� :[+� TZ� y[�+� TZ� y+˶ @+� T-/�� ^�3:\\�4\J�9\L+� �*� 12� � � ��RT�R�>\++� �*� 1
2� � � ��++� �*� 12� *� 12�� �X�]�`\�c\�DW\�E� � u�� :]+� T\� y]�+� T\� y+˶ @+� T-/�� ^�3:^^�4^6�9^L+� �*� 12� � � ��RT�R�>^@�C^�DW^�E� � u�� :_+� T^� y_�+� T^� y+˶ @+� T-/�� ^�3:``�4`J�9`L+� �*� 12� � � ��RT�R�>`++� �*� 1
2� � � ��GX�]�``�c`�DW`�E� � u�� :a+� T`� ya�+� T`� y+˶ @�j++� �*� 12� *� 1	2�e� R� � �=+˶ @+� T-/�� ^�3:bb�4bJ�9bL+� �*� 12� � � ��RT�R�>b++� �*� 1
2� � � ��++� �*� 12� *� 12�� �X�]�`b�cb�DWb�E� � u�� :c+� Tb� yc�+� Tb� y+�� @+� T-/�� ^�3:dd�4d6�9dL+� �*� 12� � � ��RT�R�>d@�Cd�DWd�E� � u�� :e+� Td� ye�+� Td� y+˶ @+� T-/�� ^�3:ff�4fJ�9fL+� �*� 12� � � ��RT�R�>f++� �*� 1
2� � � ��++� �*� 12� *� 12�� �X�]�`f�cf�DWf�E� � u�� :g+� Tf� yg�+� Tf� y+�� @+� T-/�� ^�3:hh�4h6�9hL+� �*� 12� � � ��RT�R�>h@�Ch�DWh�E� � u�� :i+� Th� yi�+� Th� y+˶ @+� T-/�� ^�3:jj�4jJ�9jL+� �*� 12� � � ��RT�R�>j++� �*� 1
2� � � ��eX�]�`j�cj�DWj�E� � u�� :k+� Tj� yk�+� Tj� y+�� @� +˶ @++� �*� 12� *� 12�G� R� � �5+˶ @+� T-/ö ^�3:ll�4l6�9lL+� �*� 12� � � ��RT�R�>l@�Cl�DWl�E� � u�� :m+� Tl� ym�+� Tl� y+˶ @+� T-/Ŷ ^�3:nn�4nJ�9nL+� �*� 12� � � ��RT�R�>n++� �*� 1
2� � � ��GX�]�`n�cn�DWn�E� � u�� :o+� Tn� yo�+� Tn� y+˶ @�c++� �*� 12� *� 12�e� R� � �6+˶ @+� T-/ɶ ^�3:pp�4p6�9pL+� �*� 12� � � ��RT�R�>p@�Cp�DWp�E� � u�� :q+� Tp� yq�+� Tp� y+˶ @+� T-/˶ ^�3:rr�4rJ�9rL+� �*� 12� � � ��RT�R�>r++� �*� 1
2� � � ��eX�]�`r�cr�DWr�E� � u�� :s+� Tr� ys�+� Tr� y+%� @� +%� @+� �+� T��Ͷ ^� �:tt� �t϶ �t+� �� �� � � �t� �6uu� O+tu� �+Ѷ @t� ���� $:vtv� �� :wu� +� �Wt� �w�u� +� �Wt� �t� �� � u�� :x+� Tt� yx�+� Tt� y� :y+� �y�+� �+˶ @+� T-/Ӷ ^�3:zz�4zJ�9zL+� �*� 12� � � ��RնR�>zu�`z�cz�DWz�E� � u�� :{+� Tz� y{�+� Tz� y+w� @+� �+϶ �:}+� �6~}~� � 6}� � � � �<6��}� � � �:|+� �}� � �d6�|�`� � �}|� �~� � � � � � �|� �6�+˶ @+� T-/׶ ^�3:���4�{�9�L+� �*� 12� � � ��RնR�>�+� �*� 12� � � �+|���R�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+:� @��(� ":�}~� � W+� ��	 |���}~� � W+� ��	 |�� :�+� ���+� �+�� @+� T-/ٶ ^�3:���4�6�9�L+� �*� 12� � � ��RնR�>�۶C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/ݶ ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/߶ ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � ��+� �*� 12� � � �X�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+L+� �*� 12� � � ��RնR��� �+:� @+� T-/� ^�3:���4���9�L+� �*� 12� � � ��RնR�>��DW��E� � u�� :�+� T�� y��+� T�� y+w� @� +� @+� �+� T��� ^� �:��� ��� ��+� �� �� � � ��� �6��� O+��� �+� @�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � u�� :�+� T�� y��+� T�� y� :�+� ���+� �+˶ @+� T-/�� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @++� �*� 12� *� 1	2�G� R� � �+˶ @+� T-/� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � ��++� �*� 12� *� 12�� �X�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/�� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � ��++� �*� 12� *� 12�� �X�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+i� @+� T-/�� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/�� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � ��++� �*� 12� *� 12�� �X�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/�� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �++� �*� 12� *� 12�� �X�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �	++� �*� 12� *� 12�� �X�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �GX�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @��++� �*� 12� *� 1	2�e� R� � ��+˶ @+� T-/� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � ��uX�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � ��uX�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � ��++� �*� 12� *� 12�� �X�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+i� @+� T-/� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �++� �*� 12� *� 12�� �X�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/!� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �	++� �*� 12� *� 12�� �X�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/#� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/%� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �eX�]�`��c¶DW¶E� � u�� :�+� T¶ yÿ+� T¶ y+i� @� +'� @+� �+� T��)� ^� �:��� ��+� ��+� �� �� � � �Ķ �6��� O+�Ŷ �+-� @Ķ ���� $:��ƶ �� :��� +� �WĶ �ǿ�� +� �WĶ �Ķ �� � u�� :�+� TĶ yȿ+� TĶ y� :�+� �ɿ+� �+˶ @+� T-//� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�CʶDWʶE� � u�� :�+� Tʶ y˿+� Tʶ y+˶ @++� �*� 12� *� 1	2�G� R� � ��+˶ @+� T-/1� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �3++� �*� 12� *� 12�� �X�]�`��c̶DW̶E� � u�� :�+� T̶ yͿ+� T̶ y+˶ @+� T-/5� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�CζDWζE� � u�� :�+� Tζ yϿ+� Tζ y+˶ @+� T-/7� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �9GX�]�`��cжDWжE� � u�� :�+� Tж yѿ+� Tж y+˶ @�%++� �*� 12� *� 1	2�e� R� � ��+˶ @+� T-/;� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �3++� �*� 12� *� 12�� �X�]�`��cҶDWҶE� � u�� :�+� TҶ yӿ+� TҶ y+�� @+� T-/=� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�CԶDWԶE� � u�� :�+� TԶ yտ+� TԶ y+˶ @+� T-/?� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �9eX�]�`��cֶDWֶE� � u�� :�+� Tֶ y׿+� Tֶ y+i� @� +i� @+� �+� T��A� ^� �:��� ��C� ��+� �� �� � � �ض �6��� O+�ٶ �+E� @ض ���� $:��ڶ �� :��� +� �Wض �ۿ�� +� �Wض �ض �� � u�� :�+� Tض yܿ+� Tض y� :�+� �ݿ+� �+˶ @+� T-/G� ^�3:���4�J�9�L+� �*� 12� � � ��RI�R�>�u�`��c޶DW޶E� � u�� :�+� T޶ y߿+� T޶ y+w� @+� �+C� �:�+� �6��� � 6�� � � � �<6��� � � �:�+� �� � �d6���`� � ��� �� � � � � � �� �6�+˶ @+� T-/K� ^�3:���4�{�9�L+� �*� 12� � � ��RI�R�>�+� �*� 12� � � �+|���R�`��c�DW�E� � u�� :�+� T� y�+� T� y+:� @��(� ":���� � W+� ��	 ����� � W+� ��	 �� :�+� ��+� �+�� @+� T-/M� ^�3:���4�6�9�L+� �*� 12� � � ��RI�R�>�O�C�DW�E� � u�� :�+� T� y��+� T� y+˶ @+� T-/Q� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C�DW�E� � u�� :�+� T� y�+� T� y+˶ @+� T-/S� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �U+� �*� 12� � � �X�]�`��c�DW�E� � u�� :�+� T� y�+� T� y+˶ @+L+� �*� 12� � � ��RI�R��� �+˶ @+� T-/W� ^�3:���4���9�L+� �*� 12� � � ��RI�R�>�DW�E� � u�� :�+� T� y�+� T� y+˶ @� +Y� @+� �+� T��[� ^� �:��� ��]� ��+� �� �� � � ��� �6��� O+��� �+_� @�� ���� $:���� �� :��� +� �W�� ����� +� �W�� ��� �� � u�� :�+� T�� y��+� T�� y� :�+� ���+� �+˶ @+� T-/a� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @++� �*� 12� *� 1	2�G� R� � �+˶ @+� T-/c� ^�3:���4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �e++� �*� 12� *� 12�� �X�]�`��c��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/g� ^�3:���4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� :�+� T�� y��+� T�� y+˶ @+� T-/i� ^�3�: � �4� J�9� L+� �*� 12� � � ��RT�R�>� ++� �*� 1
2� � � �kGX�]�`� �c� �DW� �E� � u�� �:+� T� � y��+� T� � y+˶ @�k++� �*� 12� *� 1	2�e� R� � �>+˶ @+� T-/m� ^�3�:��4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �e++� �*� 12� *� 12�� �X�]�`��c��DW��E� � u�� �:+� T�� y��+� T�� y+�� @+� T-/o� ^�3�:��4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� �:+� T�� y��+� T�� y+˶ @+� T-/q� ^�3�:��4�J�9�L+� �*� 12� � � ��RT�R�>�++� �*� 1
2� � � �keX�]�`��c��DW��E� � u�� �:+� T�� y��+� T�� y+i� @� +i� @+� �+� T��s� ^� ��:�� ��u� ��+� �� �� � � ��� ��6	�	� g+��	� �+w� @�� ���� 2�:
��
� ��  �:�	� +� �W�� ����	� +� �W�� ��� �� � u�� �:+� T�� y��+� T�� y� �:+� ���+� �+˶ @+� T-/y� ^�3�:��4�J�9�L+� �*� 12� � � ��R{�R�>�u�`��c��DW��E� � u�� �:+� T�� y��+� T�� y+w� @+� �+u� ��:+� ��6��� � �6�� � � � ���6��� � � ��:+� ��� � �d�6��`� � ���� ��� � � � � � ��� ��6+˶ @+� T-/}� ^�3�:��4�{�9�L+� �*� 12� � � ��R{�R�>�+� �*� 12� � � �+|���R�`��c��DW��E� � u�� �:+� T�� y��+� T�� y+:� @��� .�:���� � W+� ��	 �������� � W+� ��	 ��� �:+� ���+� �+�� @+� T-/� ^�3�:��4�6�9�L+� �*� 12� � � ��R{�R�>���C��DW��E� � u�� �:+� T�� y��+� T�� y+˶ @+� T-/�� ^�3�:��4�6�9�L+� �*� 12� � � ��RT�R�>�@�C��DW��E� � u�� �:+� T�� y��+� T�� y+˶ @+� T-/�� ^�3�: � �4� J�9� L+� �*� 12� � � ��RT�R�>� ++� �*� 1
2� � � ��+� �*� 12� � � �X�]�`� �c� �DW� �E� � u�� �:!+� T� � y�!�+� T� � y+˶ @+L+� �*� 12� � � ��R{�R��� �+˶ @+� T-/�� ^�3�:"�"�4�"��9�"L+� �*� 12� � � ��R{�R�>�"�DW�"�E� � u�� �:#+� T�"� y�#�+� T�"� y+w� @� +�� @+� �+� T���� ^� ��:$�$� ��$�� ��$+� �� �� � � ��$� ��6%�%� g+�$�%� �+�� @�$� ���� 2�:&�$�&� ��  �:'�%� +� �W�$� ��'��%� +� �W�$� ��$� �� � u�� �:(+� T�$� y�(�+� T�$� y� �:)+� ��)�+� �+˶ @+� T-/�� ^�3�:*�*�4�*6�9�*L+� �*� 12� � � ��RT�R�>�*@�C�*�DW�*�E� � u�� �:++� T�*� y�+�+� T�*� y+˶ @++� �*� 12� *� 1	2�G� R� � �<+˶ @+� T-/�� ^�3�:,�,�4�,J�9�,L+� �*� 12� � � ��RT�R�>�,++� �*� 1
2� � � ��++� �*� 12� *� 12�� �X�]�`�,�c�,�DW�,�E� � u�� �:-+� T�,� y�-�+� T�,� y+˶ @+� T-/�� ^�3�:.�.�4�.6�9�.L+� �*� 12� � � ��RT�R�>�.@�C�.�DW�.�E� � u�� �:/+� T�.� y�/�+� T�.� y+˶ @+� T-/�� ^�3�:0�0�4�0J�9�0L+� �*� 12� � � ��RT�R�>�0++� �*� 1
2� � � ��GX�]�`�0�c�0�DW�0�E� � u�� �:1+� T�0� y�1�+� T�0� y+˶ @�j++� �*� 12� *� 1	2�e� R� � �=+˶ @+� T-/�� ^�3�:2�2�4�2J�9�2L+� �*� 12� � � ��RT�R�>�2++� �*� 1
2� � � ��++� �*� 12� *� 12�� �X�]�`�2�c�2�DW�2�E� � u�� �:3+� T�2� y�3�+� T�2� y+˶ @+� T-/�� ^�3�:4�4�4�46�9�4L+� �*� 12� � � ��RT�R�>�4@�C�4�DW�4�E� � u�� �:5+� T�4� y�5�+� T�4� y+˶ @+� T-/�� ^�3�:6�6�4�6J�9�6L+� �*� 12� � � ��RT�R�>�6++� �*� 1
2� � � ��eX�]�`�6�c�6�DW�6�E� � u�� �:7+� T�6� y�7�+� T�6� y+�� @� +i� @+� �+� T���� ^� ��:8�8� ��8�� ��8+� �� �� � � ��8� ��69�9� g+�8�9� �+�� @�8� ���� 2�::�8�:� ��  �:;�9� +� �W�8� ��;��9� +� �W�8� ��8� �� � u�� �:<+� T�8� y�<�+� T�8� y� �:=+� ��=�+� �+˶ @+� T-/�� ^�3�:>�>�4�>J�9�>L+� �*� 12� � � ��R��R�>�>u�`�>�c�>�DW�>�E� � u�� �:?+� T�>� y�?�+� T�>� y+w� @+� �+�� ��:A+� ��6B�A�B� � �6C�A� � � � ���6D�D�A� � � ��:@+� ��A� � �Dd�6G�@�G`� � ��A�@� ��B� � � � � � ��@� ��6G+˶ @+� T-/�� ^�3�:H�H�4�H{�9�HL+� �*� 12� � � ��R��R�>�H+� �*� 12� � � �+|���R�`�H�c�H�DW�H�E� � u�� �:I+� T�H� y�I�+� T�H� y+:� @��� .�:J�A�C�B� � W+� ��	 �@��J��A�C�B� � W+� ��	 �@�� �:K+� ��K�+� �+�� @+� T-/�� ^�3�:L�L�4�L6�9�LL+� �*� 12� � � ��R��R�>�L��C�L�DW�L�E� � u�� �:M+� T�L� y�M�+� T�L� y+˶ @+� T-/�� ^�3�:N�N�4�N6�9�NL+� �*� 12� � � ��RT�R�>�N@�C�N�DW�N�E� � u�� �:O+� T�N� y�O�+� T�N� y+˶ @+� T-/�� ^�3�:P�P�4�PJ�9�PL+� �*� 12� � � ��RT�R�>�P++� �*� 1
2� � � ��+� �*� 12� � � �X�]�`�P�c�P�DW�P�E� � u�� �:Q+� T�P� y�Q�+� T�P� y+˶ @+L+� �*� 12� � � ��R��R��� �+˶ @+� T-/�� ^�3�:R�R�4�R��9�RL+� �*� 12� � � ��R��R�>�R�DW�R�E� � u�� �:S+� T�R� y�S�+� T�R� y+w� @� +�� @+L+� �*� 12� � � ��RT�R���W+˶ @+� T��Ŷ ^���:T�Tɶ��T̶��Tж��T���6U�U� F+�T�U� �+:� @�T����� �:V�U� +� �W�V��U� +� �W�T��� � u�� �:W+� T�T� y�W�+� T�T� y+˶ @+� T��ڶ ^���:X�Xɶ��XL+� �*� 12� � � ��RܶR���Xж��X���6Y�Y� F+�X�Y� �+:� @�X����� �:Z�Y� +� �W�Z��Y� +� �W�X��� � u�� �:[+� T�X� y�[�+� T�X� y+˶ @+� T-/޶ ^�3�:\�\�4�\��9�\L+� �*� 12� � � ��RT�R�>�\�DW�\�E� � u�� �:]+� T�\� y�]�+� T�\� y+˶ @+� �+� T��� ^� ��:^�^� ��^� ��^+� �� �� � � ��^� ��6_�_� g+�^�_� �+� @�^� ���� 2�:`�^�`� ��  �:a�_� +� �W�^� ��a��_� +� �W�^� ��^� �� � u�� �:b+� T�^� y�b�+� T�^� y� �:c+� ��c�+� �+i� @+� ����� � W+˶ @�  +˶ @+� ���� � W+i� @+� @� � Q q q   � � �  �� )��  E��  2��  ���  [44  QQT )Q]`  ��  ��  FI )RU  ���  ���  5lo )5x{  ��  ���  +;> )+GJ  ���  ���  ���  ^��  :��  	!	1	4 )	!	=	@  �	v	v  �	�	�  	�

  
�;;  
�^^  
1��  �  G��  �MM  ���  gwz )g��  3��  ��  �OO  �CC  v��  ���  �

  =��  ��  �++  ^��   pp  �  ���  	||  �55  h��  O_b )Okn  ��  ��  �==  �ii  ���  _��  �BB  u��  �{{  �!!  ��� )���  a��  M  -}}  � q q   � � �  !'!�!�  !�"9"9  "l"�"�  #-#}#}  #�$>$>  $q$�$�  $�%�%�  %�&&  &8&�&�  ''�'�  '�(
(
  (=(�(�  (�)3)3  )f)�)�  *(*x*x  *�+9+9  +l+�+�  +�,},}  ,�- -   -3-�-�  ..*.- )..6.9  -�.o.o  -�.�.�  .�//  /h/�/�  0)0y0y  0�11  1�22  2J2�2�  2�3@3@  3�3�3� )3�3�3�  3�4	4	  3l4#4#  4L4�4�  5^5�5�  55�5�  4�6-6-  6W6�6�  6�7*7*  7]7�7�  8>8�8�  8�9	9 )8�99  8�9N9N  8�9h9h  9�9�9�  :G:�:�  ;;X;X  ;�<<  <�==  =[=�=�  =�>u>u  ??? )??'?*  >�?n?n  >�?�?�  ?�@#@#  AA�A�  @�A�A�  @MB
B
  B:B�B�  B�C/C/  ClC�C�  DeD�D�  EEEWEZ )EEEiEl  EE�E�  D�E�E�  FF]F]  F�GiGi  G�HH  H?H�H�  I3I�I�  JJhJh  J�K&K&  K�K�K� )K�K�K�  KpLL  KZLALA  LpL�L�  M�N@N@  MgNkNk  L�N�N�  N�OGOG  O�O�O�  PP�P�  QQhQh  RR,R,  Q�RbRb  R�SS  R�SASA  S~S�S�  TSTeTh )TSTwTz  TT�T�  S�T�T�   E         * +  F  ��      <  �  �     + . (� *� ,T 0E 1� 3 4: 5� 7� 99 :` ;� >� ?/ A� C EE Gn H� I� G� I� K! MJ Nm O� M� O� Q� R� T� U	% W	� Y	� Z	� [	� \
& Y
& \
* ^
� `
� a
� b  cR `R cU d� f. h� j� k� ld jd lh o� p� q� r p r s u zk |� ~i �� �� �� �Z �Z �] �� �	 �, �� �� �� �$ �M �p �� �� �� �  �) �L �� �� �� �E �n �� � � � �� �� �� �- �- �1 �7 �: �m �� � �< �� �� �� �� �O �x �� �� �� �� �� �  � �S �� �� � �" �T �T �X �� �	 �, �N �� �� �� �� �\ �� � �+ �� �� �� �� �� �� �8 �8 �< �F �I �� � �� �� �� �  � � � � � � �! �!7 �!Z �!� �!� �!� �"S �"| �"� �# �# �# �#�#�#�$U$U$X$�%%'	%�%�	%�&&H&k&�&�&�&�'$'G'�'�'�($(M(p(�(�(�)M)v )�!**!*$*�&*�'*�(+P&+P(+S*+�,+�-,".,�,,�.,�0-2-C3-f4-�2-�4-�6-�7-�9-�=.?.�A/C/OE/xF/�G0E0G0I0�K0�L0�M16K16M19O1oQ1�R1�S2-Q2-S21V2�X2�Y3 Z3WX3WZ3[\3a]3e_3h`3�b43d4\e4f4�g4�d4�g4�i5Ek5nl5�m5�n5�k5�n5�o6>q6�s7Du7mv7�w7�u7�w7�y8%{8F|8N}8�{8�}8�8��8��8��9x�9��:.�:W�:z�:��:��:��;r�;��;��<-�<-�<0�<f�<��<��=<�=<�=@�=��>
�>/�>��>��>��>��>��>��?�?��?��?��@�@B�@B�@F�@��A'�AL�Ap�A��A��A��B�B��CQ�C��C��D�D�D�DJ�Dq�D{�D��D��D��D��D��EI�E��F�F��F��G�G��G��G��H$�HU�Hz�H��H��H��I�II�In�I��I��I��J��J��J��KE�KE�KI�KO�KS�KV�K��LU�L��L��L��L��L��L��M��M� M�N!N_�N_NbN�OiP	P3
PXP�	P�P�P�Q"Q,Q�Q�Q�Q�Q�Q�Q�Q�RR� R�!R�"R�#Sc%S�&S�'S�%S�'S�)TW+T�.U0U2U+4U.5G     ) �� D        �    G     ) �� D         �    G     ) �� D        �    G    �    D  (    *� 3Y�SY�SY�SY�SY�SY�SY�SY�SY�SY	�SY
�SY!�SY#�SY%�SY'�SY)�SY+�SY-�SY/�SY1�SY3�SY5�SY7�SY9�SY;�SY=�SY?�SYA�S� 1�     H    