����   2� [__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/antivirus_add_whitelists_cfm$cf  lucee/runtime/PageImpl  M../../publish/hermes-seg-18.04/proprietary/2/inc/antivirus_add_whitelists.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ���� getSourceLength      � getCompileTime  �@,�� getHash ()I�5A call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this ]L__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/antivirus_add_whitelists_cfm$cf; 	
 


 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 errormessage 4 &lucee/runtime/config/NullSupportHelper 6 NULL 8 '
 7 9 -lucee/runtime/interpreter/VariableInterpreter ; getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; = >
 < ? 0 A %lucee/runtime/exp/ExpressionException C java/lang/StringBuilder E The required parameter [ G  1
 F I append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; K L
 F M ] was not provided. O -(Ljava/lang/String;)Ljava/lang/StringBuilder; K Q
 F R toString ()Ljava/lang/String; T U
 F V
 D I lucee/runtime/PageContextImpl Y any [�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V _ `
 Z a 
 c sessionScope $()Llucee/runtime/type/scope/Session; e f
 / g lucee/runtime/op/Caster i toStruct /(Ljava/lang/Object;)Llucee/runtime/type/Struct; k l
 j m keys $[Llucee/runtime/type/Collection$Key; o p	  q !lucee/runtime/type/Collection$Key s .lucee/runtime/functions/struct/StructKeyExists u \(Llucee/runtime/PageContext;Llucee/runtime/type/Struct;Llucee/runtime/type/Collection$Key;)Z & w
 v x 
   z  lucee/runtime/type/scope/Session | get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; ~  } �   � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � us &()Llucee/runtime/type/scope/Undefined; � �
 / � "lucee/runtime/type/scope/Undefined � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � � 





  
 � 


 � step � session.invalid � session.invalid_entry � session.exists � session.exists_entry � session.success � session.success_entry � 


  
   � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � lucee/runtime/type/scope/Form � � � &(Ljava/lang/Object;)Ljava/lang/String; T �
 j �@$       "lucee/runtime/functions/string/Chr � 0(Llucee/runtime/PageContext;D)Ljava/lang/String; & �
 � �  lucee/runtime/type/util/ListUtil � listToArrayRemoveEmpty @(Ljava/lang/String;Ljava/lang/String;)Llucee/runtime/type/Array; � �
 � � lucee/runtime/type/Array � size � $ � � w � getVariableReference Y(Llucee/runtime/PageContext;Ljava/lang/String;)Llucee/runtime/type/ref/VariableReference; � �
 < � getE (I)Ljava/lang/Object; � � � � (lucee/runtime/type/ref/VariableReference � A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object; � �
 � � 

    
     � outputStart � 
 / � 
     � $lucee/runtime/type/util/KeyConstants � _W #Llucee/runtime/type/Collection$Key; � �	 � � � � #lucee/runtime/functions/string/Trim � A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; & �
 � � 	outputEnd � 
 / � 
    
    
   � 

    
   � 

    � #lucee/commons/color/ConstantsDouble � _1 Ljava/lang/Double; � �	 � � 1 � 
      � lucee.runtime.tag.Query � cfquery � MC:\publish\hermes-seg-18.04\proprietary\2\inc\antivirus_add_whitelists.cfm:60 � use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; � 
 Z lucee/runtime/tag/Query hasBody (Z)V
 
checkentry	 setName 1
 hermes setDatasource (Ljava/lang/Object;)V
 
doStartTag $
 initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V
 / D
     select parameter, module from parameters2 where parameter = ' writePSQ
 / %' and module = 'clamav-bypass'
       doAfterBody" $
# doCatch (Ljava/lang/Throwable;)V%&
' popBody ()Ljavax/servlet/jsp/JspWriter;)*
 /+ 	doFinally- 
. doEndTag0 $
1 lucee/runtime/exp/Abort3 newInstance (I)Llucee/runtime/exp/Abort;56
47 reuse !(Ljavax/servlet/jsp/tagext/Tag;)V9:
 Z; 	

     = getCollection?  �@ #lucee/runtime/util/VariableUtilImplB recordcountD �
CE (Ljava/lang/Object;D)I �G
 �H 



J MC:\publish\hermes-seg-18.04\proprietary\2\inc\antivirus_add_whitelists.cfm:70L insertN K
insert into parameters2
(parameter, module, active, applied)
values
('P ', 'clamav-bypass', '1', '1')
R 

T plusRef 8(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Double;VW
 �X } �  [ java/lang/String] concat &(Ljava/lang/String;)Ljava/lang/String;_`
^a <br>c 
         
   
   e _0g �	 �h _3j �	 �k 	
   

m 




      
    o 
    
    
    q 
 s udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException{  lucee/runtime/type/UDFProperties} udfs #[Llucee/runtime/type/UDFProperties;�	 � setPageSource� 
 � lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� ERRORMESSAGE� 	WHITELIST� STEP� 
CHECKENTRY� SUCCESS� SUCCESS_ENTRY� EXISTS� EXISTS_ENTRY� INVALID� INVALID_ENTRY� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             o p   ��       �   *     *� 
*� *� � *�~��*+���        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  
h  .  �+-� 3+5+� :� @M>+� :,� .BY:� !� DY� FYH� J5� NP� S� W� X�M>+� Z\5, ] ]� b+d� 3++� h� n*� r2� t� y� `+{� 3+� h*� r2� � �� �� � � 1+{� 3+� �*� r2+� h*� r2� � � � W+�� 3� +�� 3� +�� 3+�+� :� @:6+� :� 0BY:� !� DY� FYH� J�� NP� S� W� X�:6+� Z\� ] ]� b+d� 3+�+� :� @:6	+� :� 0BY:
� !� DY� FYH� J�� NP� S� W� X�
:6	+� Z\� ] ]	� b+d� 3+�+� :� @:6+� :� 0�Y:� !� DY� FYH� J�� NP� S� W� X�:6+� Z\� ] ]� b+d� 3+�+� :� @:6+� :� 0BY:� !� DY� FYH� J�� NP� S� W� X�:6+� Z\� ] ]� b+d� 3+�+� :� @:6+� :� 0�Y:� !� DY� FYH� J�� NP� S� W� X�:6+� Z\� ] ]� b+d� 3+�+� :� @:6+� :� 0BY:� !� DY� FYH� J�� NP� S� W� X�:6+� Z\� ] ]� b+d� 3+�+� :� @:6+� :� 0�Y:� !� DY� FYH� J�� NP� S� W� X�:6+� Z\� ] ]� b+�� 3+� �*� r2� � � �+ �� �� �:� � 6+Ÿ �:6�'+� � � �W+Զ 3+� �+ٶ 3+� �*� r2++� �� ߹ � � �� � � W+ٶ 3� :+� ��+� �+� 3+� �*� r2� � �� �� � � +� 3��+� �*� r2� � �� �� � �u+� 3+� �*� r2� �� � W+�� 3+� �*� r2� � �� �� � �,+Զ 3+� �+�� 3+� �+� Z�����:  � 
� � �6!!� l+ !�+� 3++� �*� r2� � � ��+!� 3 �$��֧ $:" "�(� :#!� +�,W �/#�!� +�,W �/ �2� �8�� :$+� Z �<$�+� Z �<� :%+� �%�+� �+�� 3� :&+� �&�+� �+>� 3++� �*� r2�A �F�I� � ��+K� 3+� �+d� 3+� �+� Z��M��:''�'O�'�'�6((� l+'(�+Q� 3++� �*� r2� � � ��+S� 3'�$��֧ $:)')�(� :*(� +�,W'�/*�(� +�,W'�/'�2� �8�� :++� Z'�<+�+� Z'�<� :,+� �,�+� �+d� 3� :-+� �-�+� �+U� 3+� h*� r2+� h*� r2� � � ��Y�Z W+d� 3+� h*� r2+� h*� r2� � � �\�b+� �*� r2� � � ��bd�b�Z W+f� 3�s++� �*� r2�A �F�I� � � �+>� 3+� �*� r2�i� � W+�� 3+� h*� r2�l�Z W+�� 3+� h*� r2+� h*� r2� � � ��Y�Z W+�� 3+� h*� r2+� h*� r2� � � �\�b+� �*� r2� � � ��bd�b�Z W+n� 3� �+U� 3+� h*� r2�l�Z W+d� 3+� h*� r	2+� h*� r	2� � � ��Y�Z W+d� 3+� h*� r
2+� h*� r
2� � � �\�b+� �*� r2� � � ��bd�b�Z W+�� 3+K� 3� +p� 3� +r� 3����+t� 3� �

  �$' )�03  �ii  ���  ���  $QT )$]`  ���  ���  ���   �         * +  �   � >        ^  {  �  �  �  �  �  � :  � !� "` #� $$ %� (� )� +� ,� - . 0 1@ 3i 5� 8� :� ;� <� = >� ?� A� D� E� F( JE K� L� N ON R{ T� U� V� W& Z0 \I ]v ^� `� a� d� e� j� k� m� )� n� o�     ) uv �        �    �     ) wx �         �    �     ) yz �        �    �    |    �   }     q*� tY5��SY���SY���SY���SY���SY���SY���SY���SY���SY	���SY
���S� r�     �    