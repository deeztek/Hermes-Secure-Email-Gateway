����   2� W__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/verify_system_update_cfm$cf  lucee/runtime/PageImpl  I../../publish/hermes-seg-18.04/proprietary/2/inc/verify_system_update.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ��d~� getSourceLength      � getCompileTime  �\��n getHash ()I[t� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this YL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/verify_system_update_cfm$cf;   


        
  
 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 generate_customtrans.cfm 4 	doInclude (Ljava/lang/String;Z)V 6 7
 / 8  


 : lucee/runtime/PageContextImpl < lucee.runtime.tag.FileTag > cffile @ IC:\publish\hermes-seg-18.04\proprietary\2\inc\verify_system_update.cfm:17 B use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; D E
 = F lucee/runtime/tag/FileTag H hasBody (Z)V J K
 I L read N 	setAction P 1
 I Q /opt/hermes/scripts/shasum.sh S setFile U 1
 I V shasum X setVariable Z 1
 I [ 
doStartTag ] $
 I ^ doEndTag ` $
 I a lucee/runtime/exp/Abort c newInstance (I)Llucee/runtime/exp/Abort; e f
 d g reuse !(Ljavax/servlet/jsp/tagext/Tag;)V i j
 = k 

 m IC:\publish\hermes-seg-18.04\proprietary\2\inc\verify_system_update.cfm:19 o 0 /opt/hermes/tmp/ r us &()Llucee/runtime/type/scope/Undefined; t u
 / v keys $[Llucee/runtime/type/Collection$Key; x y	  z "lucee/runtime/type/scope/Undefined | get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; ~  } � lucee/runtime/op/Caster � toString &(Ljava/lang/Object;)Ljava/lang/String; � �
 � � java/lang/String � concat &(Ljava/lang/String;)Ljava/lang/String; � �
 � � 
_shasum.sh � THE-FILE � ALL � (lucee/runtime/functions/string/REReplace � w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; & �
 � � 	setOutput (Ljava/lang/Object;)V � �
 I � setAddnewline � K
 I � 


 � getCatch #()Llucee/runtime/exp/PageException; � �
 / � 


   � lucee.runtime.tag.Execute � 	cfexecute � IC:\publish\hermes-seg-18.04\proprietary\2\inc\verify_system_update.cfm:27 � lucee/runtime/tag/Execute � 
/bin/chmod � setName � 1
 � � +x /opt/hermes/tmp/ � setArguments � �
 � �@N       
setTimeout (D)V � �
 � �
 � ^ initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � 
   � doAfterBody � $
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / �
 � a 

  
  
   � isAbort (Ljava/lang/Throwable;)Z � �
 d � toPageException 8(Ljava/lang/Throwable;)Llucee/runtime/exp/PageException; � �
 � � setCatch &(Llucee/runtime/exp/PageException;ZZ)V � �
 / � 

      
    

       � $lucee/runtime/type/util/KeyConstants � _M #Llucee/runtime/type/Collection$Key; � �	 � � </inc/verify_system_update.cfm: Error making /opt/hermes/tmp/ � _shasum.sh executable � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � } � 
       � 	error.cfm � lucee.runtime.tag.Abort � cfabort � IC:\publish\hermes-seg-18.04\proprietary\2\inc\verify_system_update.cfm:41 � lucee/runtime/tag/Abort �
 � ^
 � a 

  
     � $(Llucee/runtime/exp/PageException;)V � �
 / � 

 
    
   
     IC:\publish\hermes-seg-18.04\proprietary\2\inc\verify_system_update.cfm:50 /usr/bin/dos2unix /opt/hermes/updates/ .hash
 
     V/inc/verify_system_update.cfm: Error running /usr/bin/dos2unix on /opt/hermes/updates/ IC:\publish\hermes-seg-18.04\proprietary\2\inc\verify_system_update.cfm:64 





   


       IC:\publish\hermes-seg-18.04\proprietary\2\inc\verify_system_update.cfm:76@n       	/dev/null setOutputfile 1
 � -inputformat none shasumresult!
 � [ 
  
  

    
  $  & lucee/runtime/op/Operator( compare '(Ljava/lang/Object;Ljava/lang/String;)I*+
), 

  . sessionScope $()Llucee/runtime/type/scope/Session;01
 /2 #lucee/commons/color/ConstantsDouble4 _5 Ljava/lang/Double;67	58  lucee/runtime/type/scope/Session:; � _ACTION= �	 �> 


  
 
  @ 'lucee/runtime/functions/file/FileExistsB 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &D
CE  
  G JC:\publish\hermes-seg-18.04\proprietary\2\inc\verify_system_update.cfm:108I deleteK 
  
  
  M 


    
 

    O  
    Q JC:\publish\hermes-seg-18.04\proprietary\2\inc\verify_system_update.cfm:120S 
    
    
    U _3W7	5X 


  
  Z 

      
  \ 
  
      
  

  ^ =/inc/verify_system_update.cfm: Error running /opt/hermes/tmp/` IC:\publish\hermes-seg-18.04\proprietary\2\inc\verify_system_update.cfm:92b 


  
    
 

    d JC:\publish\hermes-seg-18.04\proprietary\2\inc\verify_system_update.cfm:143f "




    


      



h udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageExceptionp  lucee/runtime/type/UDFPropertiesr udfs #[Llucee/runtime/type/UDFProperties;tu	 v setPageSourcex 
 y !lucee/runtime/type/Collection$Key{ CUSTOMTRANS3} lucee/runtime/type/KeyImpl intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� SHASUM� THEFILE� SHASUMRESULT� FILETODELETE� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             x y   ��       �   *     *� 
*� *� � *�s�w*+�z�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  
�  *  �+-� 3+5� 9+;� 3+� =?AC� G� IM,� M,O� R,T� W,Y� \,� _W,� b� � h�� N+� =,� l-�+� =,� l+n� 3+� =?Ap� G� I:� Mq� Rs+� w*� {2� � � �� ��� �� W++� w*� {2� � � ��+� w*� {2� � � ��� �� �� �� _W� b� � h�� :+� =� l�+� =� l+�� 3+� �:+�� 3+� =���� G� �:�� ��+� w*� {2� � � �� ��� �� � �� �� �6� 8+� �+ƶ 3� ����� :	� +� �W	�� +� �W� �� � h�� :
+� =� l
�+� =� l+ж 3� �:� ԙ �� �:+� �+޶ 3+� w� ��+� w*� {2� � � �� �� �� � W+� 3+�� 9+� 3+� =���� G� �:� �W� �� � h�� :+� =� l�+� =� l+�� 3� :+� ��+� �+� 3+� �:+� 3+� =��� G� �:� �	+� w*� {2� � � �� �� �� � �� �� �6� 9+� �+� 3� ���� :� +� �W�� +� �W� �� � h�� :+� =� l�+� =� l+ж 3� �:� ԙ �� �:+� �+޶ 3+� w� �+� w*� {2� � � �� �� �� � W+� 3+�� 9+� 3+� =��� G� �:� �W� �� � h�� :+� =� l�+� =� l+�� 3� :+� ��+� �+� 3+� �:+� 3+� =��� G� �:s+� w*� {2� � � �� ��� �� �� �� � �"�#� �6� 8+� �+� 3� ����� :� +� �W�� +� �W� �� � h�� :+� =� l�+� =� l+%� 3+� w*� {2� � '�-� � ��+/� 3+�3� �9�< W+/� 3+� w�?'� � W+A� 3+� w*� {2	+� w*� {2� � � �� �� � W+ƶ 3++� w*� {2� � �F� {+H� 3+� =?AJ� G� I:� ML� R+� w*� {2� � � �� W� _W� b� � h�� : +� =� l �+� =� l+N� 3� +P� 3+� w*� {2	+� w*� {2� � � �� �� �� � W+� 3++� w*� {2� � �F� {+R� 3+� =?AT� G� I:!!� M!L� R!+� w*� {2� � � �� W!� _W!� b� � h�� :"+� =!� l"�+� =!� l+V� 3� +/� 3� !+� 3+�3� �Y�< W+[� 3+]� 3� �:##� ԙ #�#� �:$+$� �+_� 3+� w� �a+� w*� {2� � � �� ��� �� � W+ƶ 3+�� 9+ƶ 3+� =��c� G� �:%%� �W%� �� � h�� :&+� =%� l&�+� =%� l+�� 3� :'+� �'�+� �+e� 3+� w*� {2s+� w*� {2� � � �� ��� �� � W+� 3++� w*� {2� � �F� {+R� 3+� =?Ag� G� I:((� M(L� R(+� w*� {2� � � �� W(� _W(� b� � h�� :)+� =(� l)�+� =(� l+V� 3� +i� 3�  % Q Q   } � �  z��  5��  �� )I``  }�    �@@  �]` )���  �  ���  D��  ���  u��  ) )x��  )��  +gg   �         * +  �  ^ W          g  �  �      > _ } �  � "� '& (3 )z +� -� /� 0� 2� 3� 4 5Z 7 9� >� ?� @ B D  I# J- Lg Mo Nw O P� Q� S� a c2 eI hL jw k� l� m� l� m o p s vA w^ x� y� x� y� {� |� ~� �� �� �� �  S$ U' ZT [a \� ^� �� �� �� � �; �~ �~ �� �� �� ��     ) jk �        �    �     ) lm �         �    �     ) no �        �    �    q    �   B     6*�|Y~��SY���SY���SY���SY���S� {�     �    