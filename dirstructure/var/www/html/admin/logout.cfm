����   21 B__138/__138/publish/hermes_seg_18_041454/proprietary/logout_cfm$cf  lucee/runtime/PageImpl  5../../publish/hermes-seg-18.04/proprietary/logout.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  }
�� getSourceLength        getCompileTime  �\��� getHash ()IIr� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this DL__138/__138/publish/hermes_seg_18_041454/proprietary/logout_cfm$cf; lucee/runtime/PageContextImpl , lucee.runtime.tag.Header . cfheader 0 4C:\publish\hermes-seg-18.04\proprietary\logout.cfm:1 2 use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; 4 5
 - 6 lucee/runtime/tag/Header 8 Expires : setName (Ljava/lang/String;)V < =
 9 > Mon, 06 Jan 1990 00:00:01 GMT @ setValue B =
 9 C 
doStartTag E $
 9 F doEndTag H $
 9 I lucee/runtime/exp/Abort K newInstance (I)Llucee/runtime/exp/Abort; M N
 L O reuse !(Ljavax/servlet/jsp/tagext/Tag;)V Q R
 - S  
 U lucee/runtime/PageContext W write Y =
 X Z 4C:\publish\hermes-seg-18.04\proprietary\logout.cfm:2 \ Pragma ^ no-cache ` 4C:\publish\hermes-seg-18.04\proprietary\logout.cfm:3 b cache-control d � 
<!-- meta anti cache--> 
<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT"> 
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<!-- Kills the login session Variable --> 
 f sessionScope $()Llucee/runtime/type/scope/Session; h i
 X j keys $[Llucee/runtime/type/Collection$Key; l m	  n java/lang/Boolean p FALSE Ljava/lang/Boolean; r s	 q t  lucee/runtime/type/scope/Session v set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; x y w z 1 
<!-- Kills the license session Variable --> 
 |   ~ 1 
<!-- Kills the edition session Variable --> 
 � 	 



 � outputStart � 
 X � lucee.runtime.tag.Query � cfquery � 5C:\publish\hermes-seg-18.04\proprietary\logout.cfm:17 � lucee/runtime/tag/Query � hasBody (Z)V � �
 � � getconsolemode �
 � > hermes � setDatasource (Ljava/lang/Object;)V � �
 � �
 � F initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 X � L
select parameter, value2 from parameters2 where parameter='console.mode'
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 X � 	doFinally � 
 � �
 � I 	outputEnd � 
 X � 
    
 � us &()Llucee/runtime/type/scope/Undefined; � �
 X � "lucee/runtime/type/scope/Undefined � getCollection 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � get I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � �
 X � ip � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � 

 � 
 � lucee.runtime.tag.Location � 
cflocation � 5C:\publish\hermes-seg-18.04\proprietary\logout.cfm:24 � lucee/runtime/tag/Location � /logout?rd=https:// � cgiScope  ()Llucee/runtime/type/scope/CGI; � �
 X � lucee/runtime/type/scope/CGI � � � � � lucee/runtime/op/Caster � toString &(Ljava/lang/Object;)Ljava/lang/String; � �
 � � java/lang/String � concat &(Ljava/lang/String;)Ljava/lang/String; � �
 � � /admin/ � setUrl � =
 � � setAddtoken � �
 � �
 � F
 � I 


 � 5C:\publish\hermes-seg-18.04\proprietary\logout.cfm:30 � getconsolehost � L
select parameter, value2 from parameters2 where parameter='console.host'
 � 5C:\publish\hermes-seg-18.04\proprietary\logout.cfm:35 udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException	  lucee/runtime/type/UDFProperties udfs #[Llucee/runtime/type/UDFProperties;	  setPageSource 
  !lucee/runtime/type/Collection$Key LOGGEDIN lucee/runtime/type/KeyImpl intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;
 LICENSE EDITION  GETCONSOLEMODE" VALUE2$ 
LOCAL_ADDR& GETCONSOLEHOST( subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             l m   *+       ,   *     *� 
*� *� � *��*+��        ,         �        ,        � �        ,         �        ,         �         ,         !�      # $ ,        %�      & ' ,  1    ++� -/13� 7� 9M,;� ?,A� D,� GW,� J� � P�� N+� -,� T-�+� -,� T+V� [+� -/1]� 7� 9:_� ?a� D� GW� J� � P�� :+� -� T�+� -� T+V� [+� -/1c� 7� 9:e� ?a� D� GW� J� � P�� :+� -� T�+� -� T+g� [+� k*� o2� u� { W+}� [+� k*� o2� { W+�� [+� k*� o2� { W+�� [+� �+� -���� 7� �:� ��� ��� �� �6		� N+	� �+�� [� ����� $:

� �� :	� +� �W� ��	� +� �W� �� �� � P�� :+� -� T�+� -� T� :+� ��+� �+�� [++� �*� o2� � *� o2� �Ƹ �� � � �+ζ [+� �+ж [+� -��ֶ 7� �:�+� �*� o2� � � � �� � �� �� �W� �� � P�� :+� -� T�+� -� T+ж [� :+� ��+� �+ζ [�e+�� [+� �+� -���� 7� �:� ��� ��� �� �6� O+� �+ � [� ���� $:� �� :� +� �W� ��� +� �W� �� �� � P�� :+� -� T�+� -� T� :+� ��+� �+ζ [+� �+ж [+� -��� 7� �:�++� �*� o2� � *� o2� ĸ � �� � �� �� �W� �� � P�� :+� -� T�+� -� T+ж [� :+� ��+� �+�� [+ж [�   3 3   _ � �   � � �  �� )��  V��  C��  M��  4��   )#&  �\\  �vv  ���  �   -         * +  .   j     I  �  �  � 	 
 $ ' < ? � � - 7 � � � �   � "� #
 $  &# '& (/     )  ,        �    /     )  ,         �    /     )  ,        �    /    
    ,   V     J*�Y�SY�SY!�SY#�SY%�SY'�SY)�S� o�     0    