����   2� M__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/setsession_cfm$cf  lucee/runtime/PageImpl  ?../../publish/hermes-seg-18.04/proprietary/2/inc/setsession.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ��cu� getSourceLength       getCompileTime  �\��b getHash ()I�k7� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this OL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/setsession_cfm$cf;   
  
 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 lucee/runtime/PageContextImpl 4 lucee.runtime.tag.Execute 6 	cfexecute 8 ?C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:11 : use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; < =
 5 > lucee/runtime/tag/Execute @ /opt/hermes/scripts/dmidecode B setName D 1
 A E   G setArguments (Ljava/lang/Object;)V I J
 A K@N       
setTimeout (D)V O P
 A Q 
doStartTag S $
 A T initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V V W
 / X 
 Z doAfterBody \ $
 A ] popBody ()Ljavax/servlet/jsp/JspWriter; _ `
 / a doEndTag c $
 A d lucee/runtime/exp/Abort f newInstance (I)Llucee/runtime/exp/Abort; h i
 g j reuse !(Ljavax/servlet/jsp/tagext/Tag;)V l m
 5 n 

 p lucee.runtime.tag.FileTag r cffile t ?C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:16 v lucee/runtime/tag/FileTag x hasBody (Z)V z {
 y | read ~ 	setAction � 1
 y � /usr/share/UUID � setFile � 1
 y � temp1 � setVariable � 1
 y �
 y T
 y d us &()Llucee/runtime/type/scope/Undefined; � �
 / � keys $[Llucee/runtime/type/Collection$Key; � �	  � "lucee/runtime/type/scope/Undefined � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � lucee/runtime/op/Caster � toString &(Ljava/lang/Object;)Ljava/lang/String; � �
 � �@$       "lucee/runtime/functions/string/Chr � 0(Llucee/runtime/PageContext;D)Ljava/lang/String; & �
 � � ALL � (lucee/runtime/functions/string/REReplace � w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; & �
 � � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � �@*       UUID: � ?C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:24 � 0 #lucee/runtime/functions/string/Trim � A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; & �
 � � 	setOutput � J
 y � setAddnewline � {
 y � /usr/share/UUID2 � 'lucee/runtime/functions/file/FileExists � 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z & �
 � �  

 � ?C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:32 � uuid � ?C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:33 � uuid2 � &lucee/runtime/functions/string/Compare � B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)D & �
 � � toRef (D)Ljava/lang/Double; � �
 � � 0 � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � ?C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:38 � /usr/share/lt � lt � 1 � $lucee/runtime/functions/dateTime/Now � =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; & �
 � � 
yyyy-mm-dd � 4lucee/runtime/functions/displayFormatting/DateFormat � S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; & �
 � � HH:mm:ss � 4lucee/runtime/functions/displayFormatting/TimeFormat �
  � ?C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:46 &/usr/share/djigzo/ADDITIONAL-NOTES.TXT date d  
 java/lang/String concat &(Ljava/lang/String;)Ljava/lang/String;
 getTimeZone ()Ljava/util/TimeZone;
 / toDate H(Ljava/lang/String;Ljava/util/TimeZone;)Llucee/runtime/type/dt/DateTime;
 � H(Ljava/lang/Object;Ljava/util/TimeZone;)Llucee/runtime/type/dt/DateTime;
 � )lucee/runtime/functions/dateTime/DateDiff p(Llucee/runtime/PageContext;Ljava/lang/String;Llucee/runtime/type/dt/DateTime;Llucee/runtime/type/dt/DateTime;)D &
  (Ljava/lang/Object;D)I �"
 �# outputStart% 
 /& lucee.runtime.tag.Query( cfquery* ?C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:51, lucee/runtime/tag/Query.
/ | 	getserial1
/ E hermes4 setDatasource6 J
/7
/ T I
select parameter, value from system_settings where parameter='serial'
:
/ ] doCatch (Ljava/lang/Throwable;)V=>
/? 	doFinallyA 
/B
/ d 	outputEndE 
 /F ?C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:55H /usr/share/UUID3J getCollectionL � �M $lucee/runtime/type/util/KeyConstantsO _VALUE #Llucee/runtime/type/Collection$Key;QR	PS I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �U
 /V ?C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:59X deleteZ sessionScope $()Llucee/runtime/type/scope/Session;\]
 /^ N/A`  lucee/runtime/type/scope/Sessionbc � 	Communitye VALIDg Proi 
mm/dd/yyyyk 



m 2o ?C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:88q EXPIREDs 

    u 
    w 
    
    
    
    y 


{ @C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:120} @C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:124 	VIOLATION� -1� @C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:137� @C:\publish\hermes-seg-18.04\proprietary\2\inc\setsession.cfm:142� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � !lucee/runtime/type/Collection$Key� TEMP2� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� TEMP1� TEMP3� TEMP4� TEMP5� 
UUID2_FILE� COMPARE_UUID� UUID� UUID2� LT2� LT� DATENOW� TIMENOW� 
DIFFERENCE� DATE� 	GETSERIAL� LICENSE� EDITION� REASON� LICENSEVALIDDAYS� LICENSEEXPIRES� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *����*+���        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  '  5  +-� 3+� 579;� ?� AM,C� F,H� L, M� R,� U>� 3+,� Y+[� 3,� ^���� :� +� bW�� +� bW,� e� � k�� :+� 5,� o�+� 5,� o+q� 3+� 5suw� ?� y:� }� ��� ��� �� �W� �� � k�� :+� 5� o�+� 5� o+q� 3+� �*� �2++� �*� �2� � � �+ �� �H�� �� � W+q� 3+� �*� �2++� �*� �2� � � �+ �� �H�� �� � W+[� 3+� �*� �2++� �*� �2� � � �HH�� �� � W+[� 3+� �*� �2++� �*� �2� � � ��H�� �� � W+q� 3+� 5su�� ?� y:� }�� ��� �++� �*� �2� � � �� �� �� �� �W� �� � k�� :	+� 5� o	�+� 5� o+q� 3+� �*� �2ȹ � W+q� 3++� �*� �2� � � ͙�+϶ 3+� 5suѶ ?� y:

� }
� �
�� �
Ӷ �
� �W
� �� � k�� :+� 5
� o�+� 5
� o+[� 3+� 5suն ?� y:� }� �ȶ �׶ �� �W� �� � k�� :+� 5� o�+� 5� o+[� 3+� �*� �2++� �*� �2� � � �+� �*� �2� � � �� ܸ � � W+q� 3+� �*� �2� � � �� � �j+q� 3+� 5su� ?� y:� }� �� �� �� �W� �� � k�� :+� 5� o�+� 5� o+q� 3+� �*� �	2++� �*� �
2� � � �� �� � W+q� 3+� �*� �	2� � � �� � ��+q� 3+� �*� �2++� ��� �� � W+[� 3+� �*� �2++� ���� � W+[� 3+� 5su� ?� y:� }� �� �� �� �W� �� � k�� :+� 5� o�+� 5� o+[� 3+� �*� �2+	+� �*� �2� � � ��+� �*� �2� � � ��+��+� �*� �2� � +���!� � � W+q� 3+� �*� �2� � �$� � �U+q� 3+�'+� 5)+-� ?�/:�02�35�8�96� O+� Y+;� 3�<��� $:�@� :� +� bW�C�� +� bW�C�D� � k�� :+� 5� o�+� 5� o� :+�G�+�G+q� 3+� 5suI� ?� y:� }�� �K� �+++� �*� �2�N �T�W� �� �� �� �� �W� �� � k�� :+� 5� o�+� 5� o+q� 3+� 5suY� ?� y:� }[� �ȶ �� �W� �� � k�� :+� 5� o�+� 5� o+q� 3+�'+[� 3+�_*� �2a�d W+[� 3+�_*� �2f�d W+[� 3+�_*� �2H�d W+[� 3+�_*� �2H�d W+[� 3+�_*� �2H�d W+[� 3� :+�G�+�G+q� 3� �+� �*� �2� � �$� � � �+q� 3+�'+[� 3+�_*� �2h�d W+[� 3+�_*� �2j�d W+[� 3+�_*� �2H�d W+[� 3+�_*� �2+� �*� �2� � �d W+[� 3+�_*� �2++� �*� �2� � l� ��d W+[� 3� :+�G�+�G+n� 3� +q� 3�(+� �*� �	2� � p� �� � �+q� 3+� �*� �2++� ��� �� � W+[� 3+� �*� �2++� ���� � W+[� 3+� 5sur� ?� y:� }� �� �� �� �W� �� � k�� :+� 5� o�+� 5� o+[� 3+� �*� �2+	+� �*� �2� � � ��+� �*� �2� � � ��+��+� �*� �2� � +���!� � � W+q� 3+� �*� �2� � �$� � � �+q� 3+�'+[� 3+�_*� �2t�d W+[� 3+�_*� �2j�d W+[� 3+�_*� �2H�d W+[� 3+�_*� �2+� �*� �2� � �d W+[� 3+�_*� �2++� �*� �2� � l� ��d W+[� 3� : +�G �+�G+q� 3� �+� �*� �2� � �$� � � �+v� 3+�'+x� 3+�_*� �2h�d W+x� 3+�_*� �2j�d W+x� 3+�_*� �2H�d W+x� 3+�_*� �2+� �*� �2� � �d W+x� 3+�_*� �2++� �*� �2� � l� ��d W+x� 3� :!+�G!�+�G+z� 3� +|� 3� +q� 3�3+� �*� �2� � � �� � ��+q� 3+�'+� 5)+~� ?�/:""�0"2�3"5�8"�96##� O+"#� Y+;� 3"�<��� $:$"$�@� :%#� +� bW"�C%�#� +� bW"�C"�D� � k�� :&+� 5"� o&�+� 5"� o� :'+�G'�+�G+q� 3+� 5su�� ?� y:((� }(�� �(K� �(+++� �*� �2�N �T�W� �� �� �(� �(� �W(� �� � k�� :)+� 5(� o)�+� 5(� o+q� 3+�'+[� 3+�_*� �2��d W+[� 3+�_*� �2j�d W+[� 3+�_*� �2H�d W+[� 3+�_*� �2H�d W+[� 3+�_*� �2H�d W+[� 3� :*+�G*�+�G+q� 3�+� �*� �2� � �� �� � ��+[� 3+�'+� 5)+�� ?�/:++�0+2�3+5�8+�96,,� O++,� Y+;� 3+�<��� $:-+-�@� :.,� +� bW+�C.�,� +� bW+�C+�D� � k�� :/+� 5+� o/�+� 5+� o� :0+�G0�+�G+|� 3+� 5su�� ?� y:11� }1�� �1K� �1+++� �*� �2�N �T�W� �� �� �1� �1� �W1� �� � k�� :2+� 51� o2�+� 51� o+v� 3+�'+[� 3+�_*� �2��d W+[� 3+�_*� �2j�d W+[� 3+�_*� �2H�d W+[� 3+�_*� �2H�d W+[� 3+�_*� �2H�d W+[� 3� :3+�G3�+�G+|� 3� +q� 3� �++� �*� �2� � � ͙ � � �+϶ 3+�'+[� 3+�_*� �2a�d W+[� 3+�_*� �2f�d W+[� 3+�_*� �2H�d W+[� 3+�_*� �2H�d W+[� 3+�_*� �2H�d W+[� 3� :4+�G4�+�G+|� 3� +|� 3�   ; L L    u u   � � �  �##  ���  �  ���  ���  ��� )���  �//  �II  p��  �""  C��  ��  	T	�	�  
=
�
�  )��  p�� )p��  E��  /��  [[  |  ��� )���  \��  F��  ss  �  e��   �         * +  �  � }        %  >  �  � & ] � � � � : : = U q  � !5 "y $� & (0 *W ,x -� .� /l 1� 3� 5Y 7 8� 9� 7� 9� ; <9 ;9 << >F ?` @z A� B� C� D� F H I( JB K[ L� M� N� Q� R� T� V	 W	= X	� Y
 [
6 ]
@ ^
Z _
t `
� a
� b
� c
� e" g- hH ic j} k� l� m� p� q� s� t� v( xt z� | } ~r |r ~u � �� �� �� �� �� � �? �� � �- �5 �� �� �� �� �� �� �� �� � �. �4 �7 �^ �h �� �� �� �� �� �� � � ��     ) �� �        �    �     ) �� �         �    �     ) �� �        �    �    �    �   �     �*��Y���SY���SY���SY���SY���SY���SY���SY���SY���SY	���SY
���SY���SY���SY���SY���SY���SYø�SYŸ�SYǸ�SYɸ�SY˸�S� ��     �    