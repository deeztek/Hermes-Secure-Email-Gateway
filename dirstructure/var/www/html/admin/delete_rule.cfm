����   2 delete_rule_cfm$cf  lucee/runtime/PageImpl  /admin/delete_rule.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength      =� getCompileTime  n��p getHash ()I��J� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Ldelete_rule_cfm$cf;

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Delete Rule</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 us &()Llucee/runtime/type/scope/Undefined; 4 5
 / 6 $lucee/runtime/type/util/KeyConstants 8 _DATASOURCE #Llucee/runtime/type/Collection$Key; : ;	 9 < hermes > "lucee/runtime/type/scope/Undefined @ set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; B C A Db

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(255,255,255); background-image: none; margin: 0px;">
  <table border="0" cellspacing="0" cellpadding="0" width="803">
    <tr valign="top" align="left">
      <td width="21" height="37"></td>
      <td width="782"></td>
    </tr>
    <tr valign="top" align="left">
      <td></td>
      <td width="782" id="Text1" class="TextObject">
        <p style="margin-bottom: 0px;"> F lucee/runtime/PageContextImpl H lucee.runtime.tag.FileTag J cffile L use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; N O
 I P lucee/runtime/tag/FileTag R hasBody (Z)V T U
 S V read X 	setAction Z 1
 S [ /opt/hermes/keys/hermes.key ] setFile _ 1
 S ` authkey b setVariable d 1
 S e 
doStartTag g $
 S h doEndTag j $
 S k lucee/runtime/exp/Abort m newInstance (I)Llucee/runtime/exp/Abort; o p
 n q reuse !(Ljavax/servlet/jsp/tagext/Tag;)V s t
 I u 

 w algo y &lucee/runtime/config/NullSupportHelper { NULL } '
 | ~ -lucee/runtime/interpreter/VariableInterpreter � getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; � �
 � � AES � %lucee/runtime/exp/ExpressionException � java/lang/StringBuilder � The required parameter [ �  1
 � � append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; � �
 � � ] was not provided. � -(Ljava/lang/String;)Ljava/lang/StringBuilder; � �
 � � toString ()Ljava/lang/String; � �
 � �
 � � any ��       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 I � 
 � encoding � Base64 � 


 � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � lucee/runtime/tag/Query � get_mysql_username_hermes � setName � 1
 � � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � A � setDatasource (Ljava/lang/Object;)V � �
 � �
 � h initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � X
select parameter, value from system_settings where parameter='mysql_username_hermes'
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � �
 � k 	outputEnd � 
 / � keys $[Llucee/runtime/type/Collection$Key; � �	  � getCollection � � A � _VALUE � ;	 9 � I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � �
 / �   � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � lucee.runtime.tag.Location � 
cflocation � lucee/runtime/tag/Location � 	error.cfm � setUrl � 1
 � � setAddtoken � U
 � �
 � h
 � k get_mysql_password_hermes X
select parameter, value from system_settings where parameter='mysql_password_hermes'
 



 lucee/runtime/op/Caster &(Ljava/lang/Object;)Ljava/lang/String; �

	 %lucee/runtime/functions/other/Decrypt w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &
 customtrans getrandom_results 	setResult 1
 � Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
 inserttrans stResult &
insert into salt
(salt)
values
(' getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;!"
 /# getId% $
 /& lucee/runtime/type/Query( getCurrentrow (I)I*+), getRecordcount. $)/ !lucee/runtime/util/NumberIterator1 load '(II)Llucee/runtime/util/NumberIterator;34
25 addQuery (Llucee/runtime/type/Query;)V78 A9 isValid (I)Z;<
2= current? $
2@ go (II)ZBC)D #lucee/runtime/functions/string/TrimF A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &H
GI writePSQK �
 /L removeQueryN  AO release &(Llucee/runtime/util/NumberIterator;)VQR
2S ')
U gettransW 2
select salt as customtrans2 from salt where id='Y '
[ deletetrans] 
delete from salt where id='_ %/opt/hermes/scripts/validate_mysql.sha validatemysqlc 0 /opt/hermes/tmp/validate_mysql_f java/lang/Stringh concat &(Ljava/lang/String;)Ljava/lang/String;jk
il 	MYSQLUSERn ALLp (lucee/runtime/functions/string/REReplacer
s 	setOutputu �
 Sv 	 
    
x 	MYSQLPASSz  


| lucee.runtime.tag.Execute~ 	cfexecute� lucee/runtime/tag/Execute� 
/bin/chmod�
� � "+x /opt/hermes/tmp/validate_mysql_� setArguments� �
��@N       
setTimeout (D)V��
��
� h
� �
� k getCatch #()Llucee/runtime/exp/PageException;��
 /�@n       mysqlvalidate�
� e 





� isAbort (Ljava/lang/Throwable;)Z��
 n� toPageException 8(Ljava/lang/Throwable;)Llucee/runtime/exp/PageException;��
	� setCatch &(Llucee/runtime/exp/PageException;ZZ)V��
 /� _CFCATCH� ;	 9� _DETAIL� ;	 9� !ERROR 1045 (28000): Access denied� ct '(Ljava/lang/Object;Ljava/lang/Object;)Z��
 �� 'lucee/runtime/functions/file/FileExists� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &�
�� delete� #

<!-- /CFIF cfcatch.detail -->
� $(Llucee/runtime/exp/PageException;)V��
 /�@       _ID� ;	 9� !lucee/runtime/type/Collection$Key� *lucee/runtime/functions/decision/IsDefined� B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z &�
�� urlScope  ()Llucee/runtime/type/scope/URL;��
 /� lucee/runtime/type/scope/URL�� � checksystem� F
select distinct(rule_name) from file_rule_components where rule_id='� ' and system = '1'
� #lucee/runtime/util/VariableUtilImpl� recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;��
�� (Ljava/lang/Object;D)I ��
 �� file_rules.cfm?m=6� 
checkowner� R
select distinct(rule_name) as RuleName from file_rule_components where rule_id='� file_rules.cfm?m=9� checkassigned� /
select * from policy where banned_rulenames='� file_rules.cfm?m=11� (
delete from file_rules where rule_id='� delete2� 2
delete from file_rule_components where rule_id='� server_name� _
select * from parameters2 where parameter='server_name' and module='network' and active='1'
� server_domain� a
select * from parameters2 where parameter='server_domain' and module='network' and active='1'
  server_subnet a
select * from parameters2 where parameter='server_subnet' and module='network' and active='1'
 get_sa_spam_subject_tag e
select parameter, value from spam_settings where parameter='sa_spam_subject_tag' and active = '1'
 get_final_virus_destiny
 e
select parameter, value from spam_settings where parameter='final_virus_destiny' and active = '1'
 get_final_banned_destiny f
select parameter, value from spam_settings where parameter='final_banned_destiny' and active = '1'
 get_final_spam_destiny d
select parameter, value from spam_settings where parameter='final_spam_destiny' and active = '1'
 get_final_bad_header_destiny j
select parameter, value from spam_settings where parameter='final_bad_header_destiny' and active = '1'
 %/opt/hermes/conf_files/50-user.HERMES user /opt/hermes/tmp/ 50-user  _USER" ;	 9# SERVER-NAME% SERVER-DOMAIN' sa-spam-subject-tag) 
    
+ final-virus-destiny- final-banned-destiny/ final-spam-destiny1 final-bad-header-destiny3 

    
    
5 HERMES-USERNAME7 HERMES-PASSWORD9 

   
    



; getrules= K
SELECT distinct(rule_id) as RuleID, rule_name FROM file_rule_components
? getrulecomponentsA @
select file_id, type from file_rule_components where rule_id='C ' order by priority asc
E _amavis_rule_G 'I ' => new_RE( RULES ),K setAddnewlineM U
 SN _LASTP ;	 9Q _CURRENTROWS ;	 9T '(Ljava/lang/Object;Ljava/lang/Object;)I �V
 �W _TYPEY ;	 9Z ban\ getfile^ -
select ban as theType from files where id='` � _amavis_rule_components_c allowe /
select allow as theType from files where id='g ,i theComponentsk theRulem RULESo@$       "lucee/runtime/functions/string/Chrs 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &u
tv _amavis_rulex theRulesz FILE-RULES-GO-HERE| 





~ K/bin/cp /etc/amavis/conf.d/50-user /etc/amavis/conf.d/50-user.HERMES.BACKUP� /bin/mv /opt/hermes/tmp/� "50-user /etc/amavis/conf.d/50-user� /etc/init.d/amavis restart� 	_apply.sh� +x /opt/hermes/tmp/� 	/dev/null� setOutputfile� 1
�� -inputformat none�@^       file_rules.cfm?m=12� file_rules.cfm?m=8� G&nbsp;</p>
      </td>
    </tr>
  </table>
</body>
</html>
 ����� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � GET_MYSQL_USERNAME_HERMES� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� MYSQLUSERNAMEHERMES� GET_MYSQL_PASSWORD_HERMES� MYSQLPASSWORDHERMES� AUTHKEY� ALGO� ENCODING� RANDOM� STRESULT� GENERATED_KEY� CUSTOMTRANS3� GETTRANS� CUSTOMTRANS2� VALIDATEMYSQL� VALIDATEFILE� CHECKSYSTEM� 
CHECKOWNER� RULENAME� CHECKASSIGNED� 
SERVERNAME� SERVER_NAME� VALUE2� SERVERDOMAIN� SERVER_DOMAIN� SERVERSUBNET� SERVER_SUBNET� GET_SA_SPAM_SUBJECT_TAG� GET_FINAL_VIRUS_DESTINY� GET_FINAL_BANNED_DESTINY� GET_FINAL_SPAM_DESTINY� GET_FINAL_BAD_HEADER_DESTINY� RULEID� 	RULE_NAME� GETRULECOMPONENTS� FILE_ID� GETFILE� THETYPE� THERULE� THECOMPONENTS� THERULES  COMMAND subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �             *     *� 
*� *� � *����*+���                 �                � �                 �                 �                  !�      # $         %�      & '   O� X  E+-� 3+� 7� =?� E W+G� 3+� IKM� Q� SM,� W,Y� \,^� a,c� f,� iW,� l� � r�� N+� I,� v-�+� I,� v+x� 3+z+� � �:6+� � 0�Y:� !� �Y� �Y�� �z� ��� �� �� ��:6+� I�z � �� �+�� 3+�+� � �:6+� � 0�Y:	� !� �Y� �Y�� ��� ��� �� �� ��	:6+� I�� � �� �+�� 3+� �+� I��� Q� �:

�� �
+� 7� =� � � �
� �6� N+
� �+ʶ 3
� ����� $:
� ѧ :� +� �W
� ��� +� �W
� �
� �� � r�� :+� I
� v�+� I
� v� :+� ��+� �+x� 3++� 7*� �2� � � � �� �� � � ^+x� 3+� I��� Q� �:�� �� �� W�� � r�� :+� I� v�+� I� v+x� 3� _++� 7*� �2� � � � �� �� � � 8+x� 3+� 7*� �2++� 7*� �2� � � � � E W+x� 3� +�� 3+� �+� I��� Q� �:� �+� 7� =� � � �� �6� O+� �+� 3� ���� $:� ѧ :� +� �W� ��� +� �W� �� �� � r�� :+� I� v�+� I� v� :+� ��+� �+x� 3++� 7*� �2� � � � �� �� � � ^+x� 3+� I��� Q� �:�� �� �� W�� � r�� :+� I� v�+� I� v+x� 3�++� 7*� �2� � � � �� �� � �
�+� 3+� 7*� �2+++� 7*� �2� � � � �+� 7*� �2� � �+� 7*� �2� � �+� 7*� �2� � ��� E W+� 3+� �+� I��� Q� �:� �+� 7� =� � � ��� �6� O+� �+� 3� ���� $:� ѧ :� +� �W� ��� +� �W� �� �� � r�� :+� I� v�+� I� v� :+� ��+� �+x� 3+� �+� I��� Q� �:  � � +� 7� =� � � � � � �6!!�B+ !� �+ � 3+� �+�$:#+�'6$#$�- 6%#�0 � � � �6&&#�0 �6:"+� 7#�: &d6)")`�>� D#"�A$�E � � � � ("�A6)+++� 7*� �2� � ��J�M���� ":*#%$�E W+� 7�P "�T*�#%$�E W+� 7�P "�T� :++� �+�+� �+V� 3 � ��� � $:, ,� ѧ :-!� +� �W � �-�!� +� �W � � � �� � r�� :.+� I � v.�+� I � v� :/+� �/�+� �+x� 3+� �+� I��� Q� �:00X� �0+� 7� =� � � �0� �611� x+01� �+Z� 3+++� 7*� �2� � *� �	2� ��M+\� 30� ���ʧ $:202� ѧ :31� +� �W0� �3�1� +� �W0� �0� �� � r�� :4+� I0� v4�+� I0� v� :5+� �5�+� �+x� 3+� 7*� �
2++� 7*� �2� � *� �2� � E W+x� 3+� �+� I��� Q� �:66^� �6+� 7� =� � � �6� �677� x+67� �+`� 3+++� 7*� �2� � *� �	2� ��M+\� 36� ���ʧ $:868� ѧ :97� +� �W6� �9�7� +� �W6� �6� �� � r�� ::+� I6� v:�+� I6� v� :;+� �;�+� �+x� 3+� IKM� Q� S:<<� W<Y� \<b� a<d� f<� iW<� l� � r�� :=+� I<� v=�+� I<� v+x� 3+� IKM� Q� S:>>� W>e� \>g+� 7*� �
2� � ��m� a>++� 7*� �2� � �o+� 7*� �2� � �q�t�w>� iW>� l� � r�� :?+� I>� v?�+� I>� v+y� 3+� IKM� Q� S:@@� W@Y� \@g+� 7*� �
2� � ��m� a@d� f@� iW@� l� � r�� :A+� I@� vA�+� I@� v+x� 3+� IKM� Q� S:BB� WBe� \Bg+� 7*� �
2� � ��m� aB++� 7*� �2� � �{+� 7*� �2� � �q�t�wB� iWB� l� � r�� :C+� IB� vC�+� IB� v+}� 3+� I�� Q��:DD���D�+� 7*� �
2� � ��m��D���D��6EE� 8+DE� �+�� 3D������ :FE� +� �WF�E� +� �WD��� � r�� :G+� ID� vG�+� ID� v+x� 3+��:H+x� 3+� I�� Q��:IIg+� 7*� �
2� � ��m��I���I���I��I��6JJ� 8+IJ� �+�� 3I������ :KJ� +� �WK�J� +� �WI��� � r�� :L+� II� vL�+� II� v+�� 3�r:MM��� M�M��:N+N��+x� 3++� 7��� � ��� ����� +x� 3+� 7*� �2g+� 7*� �
2� � ��m� E W+x� 3++� 7*� �2� � ��� w+�� 3+� IKM� Q� S:OO� WO�� \O+� 7*� �2� � �� aO� iWO� l� � r�� :P+� IO� vP�+� IO� v+�� 3� +x� 3+� I��� Q� �:QQ�� �Q� �Q� WQ�� � r�� :R+� IQ� vR�+� IQ� v+�� 3� +�� 3� :S+H��S�+H��+x� 3+� 7*� �2g+� 7*� �
2� � ��m� E W+x� 3++� 7*� �2� � ��� w+�� 3+� IKM� Q� S:TT� WT�� \T+� 7*� �2� � �� aT� iWT� l� � r�� :U+� IT� vU�+� IT� v+�� 3� +�� 3� +� 3+Ĳ��ʸϙ5B+�� 3+�Ӳȹ� � �� � �4�+�� 3+� �+� I��� Q� �:VVض �V+� 7� =� � � �V� �6WW� i+VW� �+ڶ 3++�Ӳȹ� ��M+ܶ 3V� ���٧ $:XVX� ѧ :YW� +� �WV� �Y�W� +� �WV� �V� �� � r�� :Z+� IV� vZ�+� IV� v� :[+� �[�+� �+x� 3++� 7*� �2� � ����� � � _+�� 3+� I��� Q� �:\\� �\� �\� W\�� � r�� :]+� I\� v]�+� I\� v+�� 3� +x� 3+� �+� I��� Q� �:^^� �^+� 7� =� � � �^� �6__� i+^_� �+� 3++�Ӳȹ� ��M+\� 3^� ���٧ $:`^`� ѧ :a_� +� �W^� �a�_� +� �W^� �^� �� � r�� :b+� I^� vb�+� I^� v� :c+� �c�+� �+x� 3++� 7*� �2� � ����� � � _+�� 3+� I��� Q� �:dd�� �d� �d� Wd�� � r�� :e+� Id� ve�+� Id� v+�� 3� +x� 3+� �+� I��� Q� �:ff� �f+� 7� =� � � �f� �6gg� x+fg� �+� 3+++� 7*� �2� � *� �2� ��M+\� 3f� ���ʧ $:hfh� ѧ :ig� +� �Wf� �i�g� +� �Wf� �f� �� � r�� :j+� If� vj�+� If� v� :k+� �k�+� �+x� 3++� 7*� �2� � ����� � � _+�� 3+� I��� Q� �:ll� �l� �l� Wl�� � r�� :m+� Il� vm�+� Il� v+�� 3� +x� 3+� �+� I��� Q� �:nn�� �n+� 7� =� � � �n� �6oo� i+no� �+�� 3++�Ӳȹ� ��M+\� 3n� ���٧ $:pnp� ѧ :qo� +� �Wn� �q�o� +� �Wn� �n� �� � r�� :r+� In� vr�+� In� v� :s+� �s�+� �+x� 3+� �+� I��� Q� �:tt�� �t+� 7� =� � � �t� �6uu� i+tu� �+�� 3++�Ӳȹ� ��M+\� 3t� ���٧ $:vtv� ѧ :wu� +� �Wt� �w�u� +� �Wt� �t� �� � r�� :x+� It� vx�+� It� v� :y+� �y�+� �+� 3+� �+� I��� Q� �:zz�� �z+� 7� =� � � �z� �6{{� O+z{� �+�� 3z� ���� $:|z|� ѧ :}{� +� �Wz� �}�{� +� �Wz� �z� �� � r�� :~+� Iz� v~�+� Iz� v� :+� ��+� �+x� 3+� �+� I��� Q� �:���� ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� ѧ :��� +� �W�� ����� +� �W�� ��� �� � r�� :�+� I�� v��+� I�� v� :�+� ���+� �+x� 3+� �+� I��� Q� �:��� ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� ѧ :��� +� �W�� ����� +� �W�� ��� �� � r�� :�+� I�� v��+� I�� v� :�+� ���+� �+x� 3+� �+� I��� Q� �:��� ��+� 7� =� � � ��� �6��� O+��� �+	� 3�� ���� $:���� ѧ :��� +� �W�� ����� +� �W�� ��� �� � r�� :�+� I�� v��+� I�� v� :�+� ���+� �+x� 3+� �+� I��� Q� �:��� ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� ѧ :��� +� �W�� ����� +� �W�� ��� �� � r�� :�+� I�� v��+� I�� v� :�+� ���+� �+x� 3+� �+� I��� Q� �:��� ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� ѧ :��� +� �W�� ����� +� �W�� ��� �� � r�� :�+� I�� v��+� I�� v� :�+� ���+� �+x� 3+� �+� I��� Q� �:��� ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� ѧ :��� +� �W�� ����� +� �W�� ��� �� � r�� :�+� I�� v��+� I�� v� :�+� ���+� �+x� 3+� �+� I��� Q� �:��� ��+� 7� =� � � ��� �6��� O+��� �+� 3�� ���� $:���� ѧ :��� +� �W�� ����� +� �W�� ��� �� � r�� :�+� I�� v��+� I�� v� :�+� ���+� �+x� 3+� 7*� �2++� 7*� �2� � *� �2� � E W+�� 3+� 7*� �2++� 7*� �2� � *� �2� � E W+�� 3+� 7*� �2++� 7*� �2� � *� �2� � E W+x� 3+� �+� I��� Q� �:��� ��+� 7� =� � � ����� �6��� O+��� �+� 3�� ���� $:���� ѧ :��� +� �W�� ����� +� �W�� ��� �� � r�� :�+� I�� v��+� I�� v� :�+� ���+� �+x� 3+� �+� I��� Q� �:��� ��+� 7� =� � � ����� �6���B+��� �+ � 3+� �+�$:�+�'6����- 6���0 � � � �6����0 �6:�+� 7��: �d6���`�>� D���A��E � � � � (��A6�+++� 7*� �2� � ��J�M���� ":�����E W+� 7�P ��T������E W+� 7�P ��T� :�+� ���+� �+V� 3�� ��� � $:���� ѧ :��� +� �W�� ����� +� �W�� ��� �� � r�� :�+� I�� v��+� I�� v� :�+� ���+� �+x� 3+� �+� I��� Q� �:��X� ��+� 7� =� � � ��� �6��� x+��� �+Z� 3+++� 7*� �2� � *� �	2� ��M+\� 3�� ���ʧ $:��¶ ѧ :��� +� �W�� �ÿ�� +� �W�� ��� �� � r�� :�+� I�� vĿ+� I�� v� :�+� �ſ+� �+x� 3+� 7*� �
2++� 7*� �2� � *� �2� � E W+x� 3+� �+� I��� Q� �:��^� ��+� 7� =� � � �ƶ �6��� x+�Ƕ �+`� 3+++� 7*� �2� � *� �	2� ��M+\� 3ƶ ���ʧ $:��ȶ ѧ :��� +� �Wƶ �ɿ�� +� �Wƶ �ƶ �� � r�� :�+� Iƶ vʿ+� Iƶ v� :�+� �˿+� �+� 3+� IKM� Q� S:��� W�Y� \�� a�� f̶ iW̶ l� � r�� :�+� I̶ vͿ+� I̶ v+�� 3+� IKM� Q� S:��� W�e� \�+� 7*� �
2� � ��m!�m� a�++� 7�$� � �&+� 7*� �2� � �q�t�wζ iWζ l� � r�� :�+� Iζ vϿ+� Iζ v+x� 3+� IKM� Q� S:��� W�Y� \�+� 7*� �
2� � ��m!�m� a�� fж iWж l� � r�� :�+� Iж vѿ+� Iж v+x� 3+� IKM� Q� S:��� W�e� \�+� 7*� �
2� � ��m!�m� a�++� 7�$� � �(+� 7*� �2� � �q�t�wҶ iWҶ l� � r�� :�+� IҶ vӿ+� IҶ v+x� 3+� IKM� Q� S:��� W�Y� \�+� 7*� �
2� � ��m!�m� a�� fԶ iWԶ l� � r�� :�+� IԶ vտ+� IԶ v+�� 3+� IKM� Q� S:��� W�e� \�+� 7*� �
2� � ��m!�m� a�++� 7�$� � �*++� 7*� �2� � � � �q�t�wֶ iWֶ l� � r�� :�+� Iֶ v׿+� Iֶ v+,� 3+� IKM� Q� S:��� W�Y� \�+� 7*� �
2� � ��m!�m� a�� fض iWض l� � r�� :�+� Iض vٿ+� Iض v+�� 3+� IKM� Q� S:��� W�e� \�+� 7*� �
2� � ��m!�m� a�++� 7�$� � �.++� 7*� �2� � � � �q�t�wڶ iWڶ l� � r�� :�+� Iڶ vۿ+� Iڶ v+,� 3+� IKM� Q� S:��� W�Y� \�+� 7*� �
2� � ��m!�m� a�� fܶ iWܶ l� � r�� :�+� Iܶ vݿ+� Iܶ v+�� 3+� IKM� Q� S:��� W�e� \�+� 7*� �
2� � ��m!�m� a�++� 7�$� � �0++� 7*� �2� � � � �q�t�w޶ iW޶ l� � r�� :�+� I޶ v߿+� I޶ v+x� 3+� IKM� Q� S:��� W�Y� \�+� 7*� �
2� � ��m!�m� a�� f� iW� l� � r�� :�+� I� v�+� I� v+�� 3+� IKM� Q� S:��� W�e� \�+� 7*� �
2� � ��m!�m� a�++� 7�$� � �2++� 7*� �2� � � � �q�t�w� iW� l� � r�� :�+� I� v�+� I� v+,� 3+� IKM� Q� S:��� W�Y� \�+� 7*� �
2� � ��m!�m� a�� f� iW� l� � r�� :�+� I� v�+� I� v+�� 3+� IKM� Q� S:��� W�e� \�+� 7*� �
2� � ��m!�m� a�++� 7�$� � �4++� 7*� �2� � � � �q�t�w� iW� l� � r�� :�+� I� v�+� I� v+6� 3+� IKM� Q� S:��� W�Y� \�+� 7*� �
2� � ��m!�m� a�� f� iW� l� � r�� :�+� I� v�+� I� v+x� 3+� IKM� Q� S:��� W�e� \�+� 7*� �
2� � ��m!�m� a�++� 7�$� � �8+� 7*� �2� � �q�t�w� iW� l� � r�� :�+� I� v�+� I� v+x� 3+� IKM� Q� S:��� W�Y� \�+� 7*� �
2� � ��m!�m� a�� f� iW� l� � r�� :�+� I� v��+� I� v+x� 3+� IKM� Q� S:��� W�e� \�+� 7*� �
2� � ��m!�m� a�++� 7�$� � �:+� 7*� �2� � �q�t�w� iW� l� � r�� :�+� I� v�+� I� v+<� 3+� �+� I��� Q� �:��>� ��+� 7� =� � � �� �6��� O+�� �+@� 3� ���� $:��� ѧ :��� +� �W� ���� +� �W� �� �� � r�� :�+� I� v��+� I� v� :�+� ���+� �+� 3+>�$:�+�'6����- 6���0 � � ��6����0 �6:�+� 7��: �d6���`�>�(���A��E � � � ���A6�+x� 3+� �+� I��� Q� �:��B� ��+� 7� =� � � ��� �6��� u+��� �+D� 3++� 7*� �2� � ��M+F� 3�� ���է ,�: �� � ѧ �:�� +� �W�� ����� +� �W�� ��� �� � r�� �:+� I�� v��+� I�� v� �:+� ���+� �+x� 3+� IKM� Q� S�:�� W�e� \�+� 7*� �
2� � ��mH�m+� 7*� � 2� � ��m� a�J+� 7*� � 2� � ��mL�m�w��O�� iW�� l� � r�� �:+� I�� v��+� I�� v+� 3+� 7�R++� 7*� �!2� � �� E W+x� 3+B�$�:+�'�6���- �6	��0 � � �
�6
�
��0 �6�:+� 7��: �
d�6��`�>�	����A��E � � � �	a��A�6+x� 3+� 7�U� � +� 7�R� � �X� � � +x� 3+� 7�[� � ]� �� � ��+x� 3+� �+� I��� Q� ��:�_� ��+� 7� =� � � ��� ��6�� �+��� �+a� 3++� 7*� �"2� � ��M+\� 3�� ���ӧ 2�:��� ѧ  �:�� +� �W�� ����� +� �W�� ��� �� � r�� �:+� I�� v��+� I�� v� �:+� ���+� �+x� 3+� IKM� Q� S�:�� W�b� \�+� 7*� �
2� � ��md�m+� 7*� � 2� � ��m� a�++� 7*� �#2� � *� �$2� �w��O�� iW�� l� � r�� �:+� I�� v��+� I�� v+x� 3�
+� 7�[� � f� �� � ��+�� 3+� �+� I��� Q� ��:�_� ��+� 7� =� � � ��� ��6�� �+��� �+h� 3++� 7*� �"2� � ��M+\� 3�� ���ӧ 2�:��� ѧ  �:�� +� �W�� ����� +� �W�� ��� �� � r�� �:+� I�� v��+� I�� v� �:+� ���+� �+x� 3+� IKM� Q� S�:�� W�b� \�+� 7*� �
2� � ��md�m+� 7*� � 2� � ��m� a�++� 7*� �#2� � *� �$2� �w��O�� iW�� l� � r�� �:+� I�� v��+� I�� v+�� 3� +x� 3�Y+� 7�U� � +� 7�R� � �X� � �2+�� 3+� 7�[� � ]� �� � ��+x� 3+� �+� I��� Q� ��:�_� ��+� 7� =� � � ��� ��6�� �+��� �+a� 3++� 7*� �"2� � ��M+\� 3�� ���ӧ 2�: �� � ѧ  �:!�� +� �W�� ��!��� +� �W�� ��� �� � r�� �:"+� I�� v�"�+� I�� v� �:#+� ��#�+� �+x� 3+� IKM� Q� S�:$�$� W�$b� \�$+� 7*� �
2� � ��md�m+� 7*� � 2� � ��m� a�$++� 7*� �#2� � *� �$2� �j�m�w�$�O�$� iW�$� l� � r�� �:%+� I�$� v�%�+� I�$� v+x� 3�+� 7�[� � f� �� � ��+�� 3+� �+� I��� Q� ��:&�&_� ��&+� 7� =� � � ��&� ��6'�'� �+�&�'� �+h� 3++� 7*� �"2� � ��M+\� 3�&� ���ӧ 2�:(�&�(� ѧ  �:)�'� +� �W�&� ��)��'� +� �W�&� ��&� �� � r�� �:*+� I�&� v�*�+� I�&� v� �:++� ��+�+� �+x� 3+� IKM� Q� S�:,�,� W�,b� \�,+� 7*� �
2� � ��md�m+� 7*� � 2� � ��m� a�,++� 7*� �#2� � *� �$2� �j�m�w�,�O�,� iW�,� l� � r�� �:-+� I�,� v�-�+� I�,� v+�� 3� +x� 3� +x� 3+� IKM� Q� S�:.�.� W�.Y� \�.+� 7*� �
2� � ��md�m+� 7*� � 2� � ��m� a�.l� f�.� iW�.� l� � r�� �:/+� I�.� v�/�+� I�.� v+�� 3��s� .�:0��	��E W+� 7�P ��T�0���	��E W+� 7�P ��T+x� 3+� IKM� Q� S�:1�1� W�1Y� \�1+� 7*� �
2� � ��mH�m+� 7*� � 2� � ��m� a�1n� f�1� iW�1� l� � r�� �:2+� I�1� v�2�+� I�1� v+x� 3+� IKM� Q� S�:3�3� W�3e� \�3+� 7*� �
2� � ��mH�m+� 7*� � 2� � ��m� a�3++� 7*� �%2� � �p+q�w+� 7*� �&2� � ��mq�t�w�3�O�3� iW�3� l� � r�� �:4+� I�3� v�4�+� I�3� v+x� 3+� IKM� Q� S�:5�5� W�5Y� \�5+� 7*� �
2� � ��mH�m+� 7*� � 2� � ��m� a�5n� f�5� iW�5� l� � r�� �:6+� I�5� v�6�+� I�5� v+x� 3+� IKM� Q� S�:7�7� W�7b� \�7+� 7*� �
2� � ��my�m� a�7+� 7*� �%2� � �w�7�O�7� iW�7� l� � r�� �:8+� I�7� v�8�+� I�7� v+x� 3++� 7*� �
2� � ��mH�m+� 7*� � 2� � ��m��� �+�� 3+� IKM� Q� S�:9�9� W�9�� \�9+� 7*� �
2� � ��mH�m+� 7*� � 2� � ��m� a�9� iW�9� l� � r�� �::+� I�9� v�:�+� I�9� v+�� 3� +x� 3++� 7*� �
2� � ��md�m+� 7*� � 2� � ��m��� �+�� 3+� IKM� Q� S�:;�;� W�;�� \�;+� 7*� �
2� � ��md�m+� 7*� � 2� � ��m� a�;� iW�;� l� � r�� �:<+� I�;� v�<�+� I�;� v+�� 3� +�� 3��ҧ &�:=����E W+� 7�P ��T�=�����E W+� 7�P ��T+x� 3+� IKM� Q� S�:>�>� W�>Y� \�>+� 7*� �
2� � ��my�m� a�>{� f�>� iW�>� l� � r�� �:?+� I�>� v�?�+� I�>� v+x� 3+� IKM� Q� S�:@�@� W�@Y� \�@+� 7*� �
2� � ��m!�m� a�@� f�@� iW�@� l� � r�� �:A+� I�@� v�A�+� I�@� v+�� 3+� IKM� Q� S�:B�B� W�Be� \�B+� 7*� �
2� � ��m!�m� a�B++� 7�$� � �}+� 7*� �'2� � �q�t�w�B� iW�B� l� � r�� �:C+� I�B� v�C�+� I�B� v+�� 3++� 7*� �
2� � ��my�m��� �+�� 3+� IKM� Q� S�:D�D� W�D�� \�D+� 7*� �
2� � ��my�m� a�D� iW�D� l� � r�� �:E+� I�D� v�E�+� I�D� v+�� 3� +� 3+� 7*� �(2�+q�w�m��m+� 7*� �
2� � ��m��m+q�w�m��m� E W+x� 3+� IKM� Q� S�:F�F� W�Fe� \�F+� 7*� �
2� � ��m��m� a�F+� 7*� �(2� � �w�F�O�F� iW�F� l� � r�� �:G+� I�F� v�G�+� I�F� v+x� 3+� I�� Q���:H�H����H�+� 7*� �
2� � ��m��m���H����H���6I�I� F+�H�I� �+�� 3�H����� �:J�I� +� �W�J��I� +� �W�H��� � r�� �:K+� I�H� v�K�+� I�H� v+x� 3+� I�� Q���:L�L+� 7*� �
2� � ��m��m���L����L����L����L���6M�M� F+�L�M� �+�� 3�L����� �:N�M� +� �W�N��M� +� �W�L��� � r�� �:O+� I�L� v�O�+� I�L� v+x� 3+� IKM� Q� S�:P�P� W�P�� \�P+� 7*� �
2� � ��m��m� a�P� iW�P� l� � r�� �:Q+� I�P� v�Q�+� I�P� v+� 3+� I��� Q� ��:R�R�� ��R� ��R� W�R�� � r�� �:S+� I�R� v�S�+� I�R� v+x� 3� n+�� 3+� I��� Q� ��:T�T�� ��T� ��T� W�T�� � r�� �:U+� I�T� v�U�+� I�T� v+�� 3+x� 3� �+Ĳ��ʸϙ � � p+�� 3+� I��� Q� ��:V�V�� ��V� ��V� W�V�� � r�� �:W+� I�V� v�W�+� I�V� v+�� 3� +�� 3� � + W W  v�� )v��  I��  8��  5YY  .1 ):=  �ss  ���  �   )"%  �[[  �uu  -}}  ���  ��� )���  �  �55  ��� )���  ]		  L##  ��� )���  }	)	)  l	C	C  	g	�	�  	�
@
@  
o
�
�  
�^^  ���  �  ���  L��  3�� )���  //  3VY  �  ��� )���  �&&  x@@  ���  FI )RU  ���  ���  �  ��� )���  S��  B  g��  �" )�+.  �dd  �~~  �� )�
  �CC  �]]  ��� )���  �		  u##  y�� )y��  K��  :��  >NQ )>Z]  ��  ���   )"  �XX  �rr  ��� )���  �  �77  ��� )���  _��  N��  Rbe )Rnq  $��  ��  '* )36  �ll  ���  z�� )z��  D��  3��  ���  R--  GJM )GVY  ��   ��  �8; )�DG  �}}  ���    X [ )  d g  � � �  � � �   �!!  !>!�!�  !�"6"6  "d"�"�  ##\#\  #�$$  $:$�$�  $�%9%9  %h%�%�  %�&g&g  &�&�&�  ''�'�  '�((  (A(�(�  (�)A)A  )o)�)�  **f*f  *�++  +n+~+� )+n+�+�  +@+�+�  +/+�+�  ,�,�,� ),�,�,�  ,�-3-3  ,y-Q-Q  -{..  /�/�/� )/�/�/�  /s0808  /`0Z0Z  0�11  1�1�1� )1�1�1�  1z2?2?  1g2a2a  2�33  3�4#4& )3�4548  3�4|4|  3�4�4�  4�5d5d  66366 )66E6H  5�6�6�  5�6�6�  6�7t7t  7�8080  .�8[8[  8�9393  9k::  :U:�:�  :�;q;q  ;�<T<T  <�=@=@  ,@=t=t  =�>&>&  >^>�>�  >�?x?x  ?�@/@/  @�A9A9  A�A�A�  AsBB  B�B�B�  BPB�B�  C5C�C�  C�C�C�  D/D\D\  D�D�D�            * +    �7           ) m + � ,1 .4 /y 1� 3! 5s 7� 9� ;� =� >" @� B� D FM IP J� L� N
 P� R� V� WE Y� Z� [3 ]e _� `� a	S c	� e	� f	� g
W e
W g
[ i
� k
� l mu ku my p� q� r� s* u6 wl xt y| z� {� ~ �6 �f �� �� �� �J �P �S �j �m �� �� �% �. �4 �8 �; �N �q �� �� �P �z �� �� �  �: �� �� �2 �; �� �� �) �S �� �� �� � �� �� �� �n �q �� �3 �} �� �B �� � �� �� �G �� � �V �� � �� �� �� �, �~ �� �K �> �� � �, �� �� � # � L � � �!* �!N �!r �!� �!� �!�"P"t"�"�"�"�#v
#�#�$"
$"$&$�$�$�%P%P%T%�%�&&~&~&�&�'# 'G!'�'�!'�#(-&(Q'(u((�&(�((�*(�,)[.)/)�0)�.)�0*2*�4*�5*�6+$4+$6+(8++=+r?+�C,rE,�F,�G-eI-�J-�K-�L.1I.1L.5P.\R/T/5V/YX/�Y/�Z0n\0�]0�^0�_16\16_19a1`b1�c1�d2uf2�g2�h2�i3=f3=i3@l3In3yq3�s3�t4u4�w4�x5y5Ez5�w5�z5�|5�}6~6%6��6��7*�7U�7��7��7��7��7��8R�8��9U�9��9��9��:<�:<�:?�:��;�;;�;R�;��;��;��;��<v�<�<��=b�=k�=��>H�>��?�?.�?��?��?��?��@Q�@[�@^�@��@��A�AX�AX�A[�A��A��A��B8�Bz�B��B��B��C�CA�CK�C��C��C��C��D�D�D~�D��D��E	�	     ) ��         �    	     ) ��          �    	     ) ��         �    	    �      �    �*)��Y���SY���SY���SY���SY���SY���SY���SY���SYø�SY	Ÿ�SY
Ǹ�SYɸ�SY˸�SY͸�SYϸ�SYѸ�SYӸ�SYո�SY׸�SYٸ�SY۸�SYݸ�SY߸�SY��SY��SY��SY��SY��SY��SY���SY��SY��SY ��SY!���SY"���SY#���SY$���SY%���SY&���SY'��SY(��S� �     
    