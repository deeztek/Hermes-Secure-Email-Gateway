����   2� e__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/generate_antivirus_signatures_feed_cfm$cf  lucee/runtime/PageImpl  W../../publish/hermes-seg-18.04/proprietary/2/inc/generate_antivirus_signatures_feed.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ��-�� getSourceLength      � getCompileTime  �@,�� getHash ()IP1�f call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this gL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/generate_antivirus_signatures_feed_cfm$cf; 
 



 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 generate_customtrans.cfm 4 	doInclude (Ljava/lang/String;Z)V 6 7
 / 8 


 :  get_antivirus_signature_feed.cfm < 



 > lucee/runtime/PageContextImpl @ lucee.runtime.tag.FileTag B cffile D WC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:21 F use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; H I
 A J lucee/runtime/tag/FileTag L hasBody (Z)V N O
 M P read R 	setAction T 1
 M U ./opt/hermes/templates/antivirus_signature_feed W setFile Y 1
 M Z feed \ setVariable ^ 1
 M _ 
doStartTag a $
 M b doEndTag d $
 M e lucee/runtime/exp/Abort g newInstance (I)Llucee/runtime/exp/Abort; i j
 h k reuse !(Ljavax/servlet/jsp/tagext/Tag;)V m n
 A o 
 

 q WC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:24 s 0 /opt/hermes/tmp/ v us &()Llucee/runtime/type/scope/Undefined; x y
 / z keys $[Llucee/runtime/type/Collection$Key; | }	  ~ "lucee/runtime/type/scope/Undefined � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � lucee/runtime/op/Caster � toString &(Ljava/lang/Object;)Ljava/lang/String; � �
 � � java/lang/String � concat &(Ljava/lang/String;)Ljava/lang/String; � �
 � � _antivirus_signature_feed � 	feed_name � getCollection � � � � $lucee/runtime/type/util/KeyConstants � _NAME #Llucee/runtime/type/Collection$Key; � �	 � � I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � �
 / � ALL � (lucee/runtime/functions/string/REReplace � w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; & �
 � � 	setOutput (Ljava/lang/Object;)V � �
 M � setAddnewline � O
 M � 





 � #lucee/runtime/util/VariableUtilImpl � recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object; � �
 � � lucee/runtime/op/Operator � compare (Ljava/lang/Object;D)I � �
 � � 

    
   � WC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:34 � _feedvariables �   � 
  
   � getantivirusfeedvariables � getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query; � �
 / � getId � $
 / � lucee/runtime/type/Query � getCurrentrow (I)I � � � � getRecordcount � $ � � !lucee/runtime/util/NumberIterator � load '(II)Llucee/runtime/util/NumberIterator; � �
 � � addQuery (Llucee/runtime/type/Query;)V � � � � isValid (I)Z � �
 � � current � $
 � � go (II)Z � � � � WC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:41 � append � = � _VALUE � �	 � � removeQuery �  � � release &(Llucee/runtime/util/NumberIterator;)V � �
 � � 
  
  
  
   � getCatch #()Llucee/runtime/exp/PageException;
 / 
   lucee.runtime.tag.Execute 	cfexecute	 WC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:51 lucee/runtime/tag/Execute /usr/bin/dos2unix setName 1
 setArguments �
@$       
setTimeout (D)V

 b initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V
 /  doAfterBody" $
# popBody ()Ljavax/servlet/jsp/JspWriter;%&
 /'
 e 
          
  
  * isAbort (Ljava/lang/Throwable;)Z,-
 h. toPageException 8(Ljava/lang/Throwable;)Llucee/runtime/exp/PageException;01
 �2 setCatch &(Llucee/runtime/exp/PageException;ZZ)V45
 /6 
      
  8 _M: �	 �; [Generate Antivirus Signature Feed Variables: There was an error executing /usr/bin/dos2unix= set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object;?@ �A 	error.cfmC lucee.runtime.tag.AbortE cfabortG WC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:59I lucee/runtime/tag/AbortK
L b
L e    
      
  O $(Llucee/runtime/exp/PageException;)V4Q
 /R 

  



T WC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:68V feedvariablesX WC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:71Z WC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:74\ #feed_variables^ 





` WC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:91b _feeddatabasesd getantivirusfeeddatabasesf 

  h 	_FILENAMEj �	 �k '(Ljava/lang/Object;Ljava/lang/String;)I �m
 �n XC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:100p wget r # -O /var/lib/fangfrisch/signatures/t 

    v XC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:107x 

  
z XC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:120| [Generate Antivirus Signature Feed Databases: There was an error executing /usr/bin/dos2unix~ XC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:128� XC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:137� feeddatabases� XC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:140� XC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_antivirus_signatures_feed.cfm:143� feed_databases� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � !lucee/runtime/type/Collection$Key� CUSTOMTRANS3� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� FEED� GETANTIVIRUSFEED� GETVIRUSFEEDVARIABLES� FEEDVARIABLES� GETANTIVIRUSFEEDDATABASES� GETANTIVIRUSFEEDURL� FEEDDATABASES� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             | }   ��       �   *     *� 
*� *� � *����*+���        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  ]  B  �+-� 3+5� 9+;� 3+=� 9+?� 3+� ACEG� K� MM,� Q,S� V,X� [,]� `,� cW,� f� � l�� N+� A,� p-�+� A,� p+r� 3+� ACEt� K� M:� Qu� Vw+� {*� 2� � � �� ��� �� [++� {*� 2� � � ��++� {*� 2� � � �� �� ��� �� �� �� cW� f� � l�� :+� A� p�+� A� p+�� 3++� {*� 2� � � �� �� � �+�� 3+� ACE�� K� M:� Qu� Vw+� {*� 2� � � �� �ö �� [Ŷ �� �� cW� f� � l�� :+� A� p�+� A� p+Ƕ 3+ɶ �:	+� �6
	
� � 6	� � � � �?6	� � � �:+� {	� � d6`� � �	� �
� � � � � � �� �6+Ƕ 3+� ACE� K� M:� Q� Vw+� {*� 2� � � �� �ö �� [+� {� �� � � ��� �+� {� �� � � �� �� �� �� cW� f� � l�� :+� A� p�+� A� p+Ƕ 3��%� ":	
� � W+� {� � � ��	
� � W+� {� � � �+ � 3+�:+� 3+� A
� K�:�w+� {*� 2� � � �� �ö ����6� 2+�!�$���� :� +�(W�� +�(W�)� � l�� :+� A� p�+� A� p++� 3� �:�/� ��3:+�7+9� 3+� {�<>�B W+� 3+D� 9+� 3+� AFHJ� K�L:�MW�N� � l�� :+� A� p�+� A� p+P� 3� :+�S�+�S+U� 3+� ACEW� K� M:� QS� Vw+� {*� 2� � � �� �ö �� [Y� `� cW� f� � l�� :+� A� p�+� A� p+;� 3+� ACE[� K� M:� QS� Vw+� {*� 2� � � �� ��� �� []� `� cW� f� � l�� : +� A� p �+� A� p+;� 3+� ACE]� K� M:!!� Q!u� V!w+� {*� 2� � � �� ��� �� [!++� {*� 2� � � �_+� {*� 2� � � ��� �� �!� �!� cW!� f� � l�� :"+� A!� p"�+� A!� p+a� 3� +?� 3++� {*� 2� � � �� �� � �F+�� 3+� ACEc� K� M:##� Q#u� V#w+� {*� 2� � � �� �e� �� [#Ŷ �#� �#� cW#� f� � l�� :$+� A#� p$�+� A#� p+Ƕ 3+g� �:&+� �6'&'� � 6(&� � � � �g6))&� � � �:%+� {&� � )d6,%,`� ��&%� �'� � � � � ��%� �6,+i� 3+� {�l� � Ÿo� � � �+Ƕ 3+� ACEq� K� M:--� Q-� V-w+� {*� 2� � � �� �e� �� [-s++� {*� 2� � � �� �� �� �+� {� �� � � �� �u� �+� {� �� � � �� �� �-� �-� cW-� f� � l�� :.+� A-� p.�+� A-� p+i� 3� �+w� 3+� ACEy� K� M://� Q/� V/w+� {*� 2� � � �� �e� �� [/s++� {*� 2� � � �� �� �� �+� {� �� � � �� �u� �+� {�l� � � �� �� �/� �/� cW/� f� � l�� :0+� A/� p0�+� A/� p+{� 3+Ƕ 3���� ":1&('� � W+� {� � %� �1�&('� � W+� {� � %� �+ � 3+�:2+� 3+� A
}� K�:33�3w+� {*� 2� � � �� �e� ��3�3�644� 2+34�!3�$���� :54� +�(W5�4� +�(W3�)� � l�� :6+� A3� p6�+� A3� p++� 3� �:77�/� 7�7�3:8+8�7+9� 3+� {�<�B W+� 3+D� 9+� 3+� AFH�� K�L:99�MW9�N� � l�� ::+� A9� p:�+� A9� p+P� 3� :;+2�S;�+2�S+U� 3+� ACE�� K� M:<<� Q<S� V<w+� {*� 2� � � �� �e� �� [<�� `<� cW<� f� � l�� :=+� A<� p=�+� A<� p+;� 3+� ACE�� K� M:>>� Q>S� V>w+� {*� 2� � � �� ��� �� [>]� `>� cW>� f� � l�� :?+� A>� p?�+� A>� p+;� 3+� ACE�� K� M:@@� Q@u� V@w+� {*� 2� � � �� ��� �� [@++� {*� 2� � � ��+� {*� 2� � � ��� �� �@� �@� cW@� f� � l�� :A+� A@� pA�+� A@� p+a� 3� +a� 3�  2 ^ ^   �  f��  k��  #  ���  g��  J )e||  J��  �  G��  �AA  ���  �ll  �	C	C  d	m	m  

#
#  	�
O
O  	�
m
p )
�
�
�  	�  3��  ���  /��   �         * +  �  � f                 t  w  �  � $ $ ' *  P "u #� $� %� "� %� 'U )z *� +� ,� )� ,� .A 1D 2N 3q 4� 5  7& 9= :L ;� =� >� @� D0 F3 G� I� J� K� LX JX L\ Nb Ue Wh Y� [� \� ]� ^ [ ^ `� b� d� e fQ g� d� g� i� k� l� m	( n	Z k	Z n	^ p	a q	d s	� v	� w	� x	� y	� z
j |
� ~
� 
� � � � � �� �� � � �> �_ �� �� �� �� �� ��     ) �� �        �    �     ) �� �         �    �     ) �� �        �    �    �    �   `     T*��Y���SY���SY���SY���SY���SY���SY���SY���S� �     �    