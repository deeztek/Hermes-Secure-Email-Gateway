����   2 � ___138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/get_antivirus_signature_feed_cfm$cf  lucee/runtime/PageImpl  Q../../publish/hermes-seg-18.04/proprietary/2/inc/get_antivirus_signature_feed.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ��$�� getSourceLength      D getCompileTime  �\��G getHash ()I2�� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this aL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/get_antivirus_signature_feed_cfm$cf; 
 

 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 outputStart 4 
 / 5 lucee/runtime/PageContextImpl 7 lucee.runtime.tag.Query 9 cfquery ; QC:\publish\hermes-seg-18.04\proprietary\2\inc\get_antivirus_signature_feed.cfm:12 = use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; ? @
 8 A lucee/runtime/tag/Query C hasBody (Z)V E F
 D G getantivirusfeed I setName K 1
 D L hermes N setDatasource (Ljava/lang/Object;)V P Q
 D R 
doStartTag T $
 D U initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V W X
 / Y B
select name, enabled, update_int from malware_feeds where id = ' [ us &()Llucee/runtime/type/scope/Undefined; ] ^
 / _ keys $[Llucee/runtime/type/Collection$Key; a b	  c "lucee/runtime/type/scope/Undefined e get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; g h f i lucee/runtime/op/Caster k toString &(Ljava/lang/Object;)Ljava/lang/String; m n
 l o writePSQ q Q
 / r '
 t doAfterBody v $
 D w doCatch (Ljava/lang/Throwable;)V y z
 D { popBody ()Ljavax/servlet/jsp/JspWriter; } ~
 /  	doFinally � 
 D � doEndTag � $
 D � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 8 � 	outputEnd � 
 / � 

 � QC:\publish\hermes-seg-18.04\proprietary\2\inc\get_antivirus_signature_feed.cfm:16 � getantivirusfeedurl � H
  select name, value, feed, type from malware_databases where feed = ' � ' and type = 'feedurl'
   � QC:\publish\hermes-seg-18.04\proprietary\2\inc\get_antivirus_signature_feed.cfm:20 � getantivirusfeedvariables � N
select name, value, active, feed, type from malware_databases where feed = ' � -' and active = 'true' and type = 'variable'
 � QC:\publish\hermes-seg-18.04\proprietary\2\inc\get_antivirus_signature_feed.cfm:24 � getantivirusfeeddatabases � Y
select name, filename, value, active, feed, type  from malware_databases where feed = ' � -' and active = 'true' and type = 'database'
 � 

  


 � udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException �  lucee/runtime/type/UDFProperties � udfs #[Llucee/runtime/type/UDFProperties; � �	  � setPageSource � 
  � !lucee/runtime/type/Collection$Key � THEID � lucee/runtime/type/KeyImpl � intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key; � �
 � � subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             a b    � �        �   *     *� 
*� *� � *� �� �*+� ��         �         �         �        � �         �         �         �         �          �         !�      # $  �        %�      & '  �  L    j+-� 3+� 6+� 8:<>� B� DM,� H,J� M,O� S,� V>� b+,� Z+\� 3++� `*� d2� j � p� s+u� 3,� x��٧ !:,� |� :� +� �W,� ��� +� �W,� �,� �� � ��� :+� 8,� ��+� 8,� �� :+� ��+� �+�� 3+� 6+� 8:<�� B� D:� H�� MO� S� V6		� j+	� Z+�� 3++� `*� d2� j � p� s+�� 3� x��ا $:

� |� :	� +� �W� ��	� +� �W� �� �� � ��� :+� 8� ��+� 8� �� :+� ��+� �+�� 3+� 6+� 8:<�� B� D:� H�� MO� S� V6� j+� Z+�� 3++� `*� d2� j � p� s+�� 3� x��ا $:� |� :� +� �W� ��� +� �W� �� �� � ��� :+� 8� ��+� 8� �� :+� ��+� �+�� 3+� 6+� 8:<�� B� D:� H�� MO� S� V6� j+� Z+�� 3++� `*� d2� j � p� s+�� 3� x��ا $:� |� :� +� �W� ��� +� �W� �� �� � ��� :+� 8� ��+� 8� �� :+� ��+� �+�� 3�  = g j ) = r u    � �   
 � �  <? )HK   ���   ���  � )�%(  �^^  �xx  ��� )�  �;;  �UU    �         * +   �   >         @  \  �  0 � �  � � � e  �     )  � �  �        �     �     )  � �  �         �     �     )  � �  �        �     �     �     �        *� �Yĸ �S� d�      �    