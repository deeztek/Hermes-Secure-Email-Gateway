����   2� V__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/generate_tls_policy_cfm$cf  lucee/runtime/PageImpl  H../../publish/hermes-seg-18.04/proprietary/2/inc/generate_tls_policy.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  }��
� getSourceLength      # getCompileTime  �@,�� getHash ()I�)�[ call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this XL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/generate_tls_policy_cfm$cf; 	
 

   , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 outputStart 4 
 / 5 lucee/runtime/PageContextImpl 7 lucee.runtime.tag.Query 9 cfquery ; HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:12 = use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; ? @
 8 A lucee/runtime/tag/Query C hasBody (Z)V E F
 D G customtrans I setName K 1
 D L hermes N setDatasource (Ljava/lang/Object;)V P Q
 D R getrandom_results T 	setResult V 1
 D W 
doStartTag Y $
 D Z initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V \ ]
 / ^ Y
    select random_letter as random from captcha_list_all2 order by RAND() limit 8
     ` doAfterBody b $
 D c doCatch (Ljava/lang/Throwable;)V e f
 D g popBody ()Ljavax/servlet/jsp/JspWriter; i j
 / k 	doFinally m 
 D n doEndTag p $
 D q lucee/runtime/exp/Abort s newInstance (I)Llucee/runtime/exp/Abort; u v
 t w reuse !(Ljavax/servlet/jsp/tagext/Tag;)V y z
 8 { 	outputEnd } 
 / ~ 
    
     � HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:16 � inserttrans � stResult � 6
    insert into salt
    (salt)
    values
    (' � getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query; � �
 / � getId � $
 / � lucee/runtime/type/Query � getCurrentrow (I)I � � � � getRecordcount � $ � � !lucee/runtime/util/NumberIterator � load '(II)Llucee/runtime/util/NumberIterator; � �
 � � us &()Llucee/runtime/type/scope/Undefined; � �
 / � "lucee/runtime/type/scope/Undefined � addQuery (Llucee/runtime/type/Query;)V � � � � isValid (I)Z � �
 � � current � $
 � � go (II)Z � � � � keys $[Llucee/runtime/type/Collection$Key; � �	  � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � lucee/runtime/op/Caster � toString &(Ljava/lang/Object;)Ljava/lang/String; � �
 � � #lucee/runtime/functions/string/Trim � A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; & �
 � � writePSQ � Q
 / � removeQuery �  � � release &(Llucee/runtime/util/NumberIterator;)V � �
 � � ')
     � HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:23 � gettrans � 6
    select salt as customtrans2 from salt where id=' � getCollection � � � � I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � �
 / � '
     � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � � HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:29 � deletetrans � !
    delete from salt where id=' � 
    

     � HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:34 � policies � $lucee/runtime/type/util/KeyConstants � _DATASOURCE #Llucee/runtime/type/Collection$Key; � �	 � � _
      SELECT domain, method from tls_policies where applied = '1' order by domain asc
       � 
      
      
       � #lucee/runtime/util/VariableUtilImpl � recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object; � �
 �  lucee/runtime/op/Operator compare (Ljava/lang/Object;D)I
 
       lucee.runtime.tag.FileTag
 cffile HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:40 lucee/runtime/tag/FileTag
 G 0 	setAction 1
 /opt/hermes/tmp/ java/lang/String concat &(Ljava/lang/String;)Ljava/lang/String;
 _tls_policy setFile! 1
"  $ 	setOutput& Q
' setAddnewline) F
*
 Z
 q 
      
      . HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:470 append2  4 _METHOD6 �	 �7 HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:569 E/bin/cp /etc/postfix/tls_policy /etc/postfix/tls_policy.HERMES.BACKUP;@$       "lucee/runtime/functions/string/Chr? 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &A
@B /bin/mv /opt/hermes/tmp/D #_tls_policy /etc/postfix/tls_policyF )/usr/sbin/postmap /etc/postfix/tls_policyH HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:65J 	_apply.shL 



      N getCatch #()Llucee/runtime/exp/PageException;PQ
 /R 
  
        T lucee.runtime.tag.ExecuteV 	cfexecuteX HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:73Z lucee/runtime/tag/Execute\ 
/bin/chmod^
] L +x /opt/hermes/tmp/a setArgumentsc Q
]d@N       
setTimeout (D)Vhi
]j
] Z
] c
] q 2
                    
            
            o isAbort (Ljava/lang/Throwable;)Zqr
 ts toPageException 8(Ljava/lang/Throwable;)Llucee/runtime/exp/PageException;uv
 �w setCatch &(Llucee/runtime/exp/PageException;ZZ)Vyz
 /{  
                
            } _M �	 �� SGenerate TLS Policy: There was an error making /opt/hermes/tmp/_apply.sh executable� 
            � 	error.cfm� 	doInclude (Ljava/lang/String;Z)V��
 /� lucee.runtime.tag.Abort� cfabort� HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:82� lucee/runtime/tag/Abort�
� Z
� q #   
                
            � $(Llucee/runtime/exp/PageException;)Vy�
 /� 
        
      

� 
  
  � HC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:91� 	/dev/null� setOutputfile� 1
]� -inputformat none�@^       
  �  
              
      
      � 
          
      � IC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:101�    
          
      � 
    


� 'lucee/runtime/functions/file/FileExists� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &�
�� IC:\publish\hermes-seg-18.04\proprietary\2\inc\generate_tls_policy.cfm:110� delete�     
  
  � 
     
    
 
  � udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � !lucee/runtime/type/Collection$Key� RANDOM� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� STRESULT� GENERATED_KEY� CUSTOMTRANS3� GETTRANS� CUSTOMTRANS2� POLICIES� DOMAIN� COMMAND� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *�̵�*+�ӱ        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  �  R  �+-� 3+� 6+� 8:<>� B� DM,� H,J� M,O� S,U� X,� [>� F+,� _+a� 3,� d���� !:,� h� :� +� lW,� o�� +� lW,� o,� r� � x�� :+� 8,� |�+� 8,� |� :+� �+� +�� 3+� 6+� 8:<�� B� D:� H�� MO� S�� X� [6		�>+	� _+�� 3+� 6+J� �:+� �6� � 6� � � � � �6� � � �:
+� �� � d6
`� �� C
� �� � � � � � '
� �6+++� �*� �2� � � ¸ Ƕ ʧ��� ":� � W+� �� � 
� ��� � W+� �� � 
� ѧ :+� �+� +Ӷ 3� d��� $:� h� :	� +� lW� o�	� +� lW� o� r� � x�� :+� 8� |�+� 8� |� :+� �+� +�� 3+� 6+� 8:<ն B� D:� H׶ MO� S� [6� t+� _+ٶ 3+++� �*� �2� � *� �2� ߸ ¶ �+� 3� d��Χ $:� h� :� +� lW� o�� +� lW� o� r� � x�� :+� 8� |�+� 8� |� :+� �+� +�� 3+� �*� �2++� �*� �2� � *� �2� ߹ � W+�� 3+� 6+� 8:<� B� D:� H� MO� S� [6� t+� _+� 3+++� �*� �2� � *� �2� ߸ ¶ �+� 3� d��Χ $:  � h� :!� +� lW� o!�� +� lW� o� r� � x�� :"+� 8� |"�+� 8� |� :#+� #�+� +�� 3+� 6+� 8:<� B� D:$$� H$� M$+� �� �� � � S$� [6%%� N+$%� _+�� 3$� d���� $:&$&� h� :'%� +� lW$� o'�%� +� lW$� o$� r� � x�� :(+� 8$� |(�+� 8$� |� :)+� )�+� +�� 3++� �*� �2� � ��� � �5+	� 3+� 8� B�:**�*�*+� �*� �2� � � ¶ ��#*%�(*�+*�,W*�-� � x�� :++� 8*� |+�+� 8*� |+	� 3+� �:-+� �6.-.� � 6/-� � � � �n600-� � � �:,+� �-� � 0d63,3`� ��-,� �.� � � � � � �,� �63+/� 3+� 6+	� 3+� 81� B�:44�43�4+� �*� �2� � � ¶ ��#4+� �*� �2� � � �5�+� ��8� � � ¶�(4�+4�,W4�-� � x�� :5+� 84� |5�+� 84� |+	� 3� :6+� 6�+� +/� 3���� ":7-/.� � W+� �� � ,� �7�-/.� � W+� �� � ,� �+/� 3� �++� �*� �2� � ��� � � �+	� 3+� 8:� B�:88�8�8+� �*� �2� � � ¶ ��#8%�(8�+8�,W8�-� � x�� :9+� 88� |9�+� 88� |+	� 3� +�� 3+� �*� �2<+=�C�E�+� �*� �2� � � ¶G�+=�C�I�� � W+/� 3+� 8K� B�:::�:�:+� �*� �2� � � ¶M��#:+� �*� �2� � �(:�+:�,W:�-� � x�� :;+� 8:� |;�+� 8:� |+O� 3+�S:<+U� 3+� 8WY[� B�]:==_�`=b+� �*� �2� � � ¶M��e=f�k=�l6>>� 9+=>� _+	� 3=�m��� :?>� +� lW?�>� +� lW=�n� � x�� :@+� 8=� |@�+� 8=� |+p� 3� �:AA�t� A�A�x:B+B�|+~� 3+� ����� � W+�� 3+���+�� 3+� 8���� B��:CC��WC��� � x�� :D+� 8C� |D�+� 8C� |+�� 3� :E+<��E�+<��+�� 3+�S:F+�� 3+� 8WY�� B�]:GG+� �*� �2� � � ¶M��`G���G��eG��kG�l6HH� 9+GH� _+�� 3G�m��� :IH� +� lWI�H� +� lWG�n� � x�� :J+� 8G� |J�+� 8G� |+�� 3� �:KK�t� K�K�x:L+L�|+�� 3+� ����� � W+	� 3+���+	� 3+� 8���� B��:MM��WM��� � x�� :N+� 8M� |N�+� 8M� |+�� 3� :O+F��O�+F��+�� 3++� �*� �2� � � ¶M���� �+�� 3+� 8�� B�:PP�P��P+� �*� �2� � � ¶M��#P�,WP�-� � x�� :Q+� 8P� |Q�+� 8P� |+�� 3� +¶ 3� ' C Q T ) C \ _    � �   
 � �  Z��  ��   )   �FF   �``  ��� )���  �--  wGG  �� )�
  �CC  �]]  ��� )���  �  t((  |��  �  x44  >NN  �((  �		  	�	�	�  	_	�	�  	B

 )
f
}
}  	B
�
�  )<<  
�hh  
��� )���  
�   z��   �         * +  �  F Q        F  �  � p � � W � � � m "� $8 'c (� )� *� +� (� +� ,q .| /� 0� 1� 2* /* 2. 3E 5� 7� 8� 9 : ;? 8? ;C <L ?� A� B� C	5 A	5 C	9 F	< G	F I	i J	� K	� L
 N
' P
> Q
M R
� T
� U
� X
� Y
� [
� \ ] ^- _� a� c� d� e g1 h5 k8 la n� o� p� n� p� r� v�     ) �� �        �    �     ) �� �         �    �     ) �� �        �    �    �    �   j     ^*	��Y׸�SY߸�SY��SY��SY��SY��SY��SY��SY���S� ��     �    