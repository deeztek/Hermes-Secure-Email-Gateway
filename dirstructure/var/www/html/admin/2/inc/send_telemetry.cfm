����   2j Q__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/send_telemetry_cfm$cf  lucee/runtime/PageImpl  C../../publish/hermes-seg-18.04/proprietary/2/inc/send_telemetry.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ��HT� getSourceLength      #� getCompileTime  �@,�� getHash ()I�v� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this SL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/inc/send_telemetry_cfm$cf;   




 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 outputStart 4 
 / 5 lucee/runtime/PageContextImpl 7 lucee.runtime.tag.Query 9 cfquery ; CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:14 = use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; ? @
 8 A lucee/runtime/tag/Query C hasBody (Z)V E F
 D G checktelemetry I setName K 1
 D L hermes N setDatasource (Ljava/lang/Object;)V P Q
 D R 
doStartTag T $
 D U initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V W X
 / Y K
    select value from system_settings where parameter = 'telemetry'
     [ doAfterBody ] $
 D ^ doCatch (Ljava/lang/Throwable;)V ` a
 D b popBody ()Ljavax/servlet/jsp/JspWriter; d e
 / f 	doFinally h 
 D i doEndTag k $
 D l lucee/runtime/exp/Abort n newInstance (I)Llucee/runtime/exp/Abort; p q
 o r reuse !(Ljavax/servlet/jsp/tagext/Tag;)V t u
 8 v 	outputEnd x 
 / y 
    
    
     { us &()Llucee/runtime/type/scope/Undefined; } ~
 /  keys $[Llucee/runtime/type/Collection$Key; � �	  � "lucee/runtime/type/scope/Undefined � getCollection 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � $lucee/runtime/type/util/KeyConstants � _VALUE #Llucee/runtime/type/Collection$Key; � �	 � � get I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � �
 / � 1 � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � 
    


 � dmi_decode.cfm � 	doInclude (Ljava/lang/String;Z)V � �
 / � 



 � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:27 � getrecipients � V
    select count(recipient) as recipients from recipients where domain is NULL
     � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:32 � getdomainsspecified � �
      
        select count(recipient) as domainsspecified from recipients where domain = '1' and status = '' or status is null
       � 
    
     � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:37 � getdomainsany � l
        select count(recipient) as domainsany from recipients where domain = '1' and status = "OK"
       � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:41 � 
getvirtual � a
    select count(virtual_address) as virtual from virtual_recipients where system = '2'
       � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:45 � 
getversion � T
        SELECT value FROM system_settings where parameter = 'version_no'
         � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:49 � getbuild � R
        SELECT value FROM system_settings where parameter = 'build_no'
         � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:53 � gettimezone � R
        SELECT value FROM system_settings where parameter = 'timezone'
         � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:57 � 	getserial � P
        SELECT value FROM system_settings where parameter = 'serial'
         � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:61 � getconsolecertificate � Z
        SELECT value2 FROM parameters2 where parameter = 'console.certificate'
         � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:65 � getsmtpcertificate � W
        SELECT value2 FROM parameters2 where parameter = 'smtp.certificate'
         � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:69 � getcleanmessagecount � ^
    select count(mail_id) as cleanmessages from msgs where content like binary 'C'
         � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:73 � getspammessagecount � t
    select count(mail_id) as spammessages from msgs where content like binary 'S' or content like binary 'Y'
     � CC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:77 � getvirusmessagecount � Z
    select count(mail_id) as virusmessages from msgs where content like binary 'V'
     �     



 �   � 
     � #lucee/commons/color/ConstantsDouble � _0 Ljava/lang/Double; � 	 � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � 
  
	 

 


 	Community Pro Build-In Other 

            
      
     generate_customtrans.cfm (
            
            
    
     lucee.runtime.tag.FileTag cffile DC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:150! lucee/runtime/tag/FileTag#
$ G 0 	setAction' 1
$( /opt/hermes/tmp/* � � �, lucee/runtime/op/Caster. toString &(Ljava/lang/Object;)Ljava/lang/String;01
/2 java/lang/String4 concat &(Ljava/lang/String;)Ljava/lang/String;67
58 _telemetryfile: setFile< 1
$=@P       "lucee/runtime/functions/string/ChrA 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &C
BD 	setOutputF Q
$G setAddnewlineI F
$J
$ U
$ l 
      
    
      N getCatch #()Llucee/runtime/exp/PageException;PQ
 /R  
    
      T lucee.runtime.tag.ExecuteV 	cfexecuteX DC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:157Z lucee/runtime/tag/Execute\ /usr/bin/openssl^
] L Mrsautl -encrypt -inkey /opt/hermes/ssl/public.pem -pubin -in /opt/hermes/tmp/a $_telemetryfile -out /opt/hermes/tmp/c _telemetryfile.ssle setArgumentsg Q
]h@N       
setTimeout (D)Vlm
]n
] U 

        q
] ^
] l 
        
        
        u isAbort (Ljava/lang/Throwable;)Zwx
 oy toPageException 8(Ljava/lang/Throwable;)Llucee/runtime/exp/PageException;{|
/} setCatch &(Llucee/runtime/exp/PageException;ZZ)V�
 /� 
     
            � _M� �	 �� </inc/check_system_update.cfm: Error running /usr/bin/openssl� 
            � 	error.cfm� lucee.runtime.tag.Abort� cfabort� DC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:166� lucee/runtime/tag/Abort�
� U
� l 
    
    
        � $(Llucee/runtime/exp/PageException;)V�
 /� 
    
    
    
    � lucee.runtime.tag.Http� cfhttp� DC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:178� lucee/runtime/tag/Http�
� G Post� 	setMethod� 1
�� )https://updates.deeztek.com/telemetry.cfm� setUrl� 1
�� 60�l Q
��
� U 
          
      � lucee.runtime.tag.HttpParam� cfhttpparam� DC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:180� lucee/runtime/tag/HttpParam� File� setType� 1
��
� L
�=
� U
� l 
              
      � DC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:184� 	Formfield� setValue� Q
�� customtrans�
� ^
� l .
      
      
        
        
        � 
    
    
    
        � G
    
    
    
          
          
         
    
          � 200� 
    
          
           � 
          � 'lucee/runtime/functions/file/FileExists� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &�
�� 
          
          � DC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:223� delete� $
          
          
          � DC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:232� 
    
     
         � 
    
     
     � 
     � 
     
     � DC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:244� ;
     
     <!-- /CFIF fileExists(updatefile)> -->
     � 
     
     
     � DC:\publish\hermes-seg-18.04\proprietary\2\inc\send_telemetry.cfm:253  ?
     
     <!-- /CFIF fileExists(updatefile_ssl)> -->
      2
      
    
    
    
          
           *
    
          
    
    
    
     udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException  lucee/runtime/type/UDFProperties udfs #[Llucee/runtime/type/UDFProperties;	  setPageSource 
  !lucee/runtime/type/Collection$Key CHECKTELEMETRY lucee/runtime/type/KeyImpl intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key; 
! GETRECIPIENTS# 
RECIPIENTS% GETDOMAINSSPECIFIED' DOMAINSSPECIFIED) GETDOMAINSANY+ 
DOMAINSANY- 
GETVIRTUAL/ VIRTUAL1 	GETSERIAL3 EDITION5 GETCONSOLECERTIFICATE7 VALUE29 CONSOLECERTIFICATE; GETSMTPCERTIFICATE= SMTPCERTIFICATE? GETCLEANMESSAGECOUNTA CLEANMESSAGESC GETSPAMMESSAGECOUNTE SPAMMESSAGESG GETVIRUSMESSAGECOUNTI VIRUSMESSAGESK CUSTOMTRANS3M THEUUIDO 
GETVERSIONQ GETBUILDS GETTIMEZONEU CFHTTPW STATUS_CODEY TELEMETRYFILE[ TELEMETRYFILE_SSL] 
UPDATEFILE_ UPDATEFILE_SSLa subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   cd       e   *     *� 
*� *� � *��*+��        e         �        e        � �        e         �        e         �         e         !�      # $ e        %�      & ' e  >  v  �+-� 3+� 6+� 8:<>� B� DM,� H,J� M,O� S,� V>� F+,� Z+\� 3,� _���� !:,� c� :� +� gW,� j�� +� gW,� j,� m� � s�� :+� 8,� w�+� 8,� w� :+� z�+� z+|� 3++� �*� �2� � � �� ��� �� � ��+�� 3+�� �+�� 3+� 6+� 8:<�� B� D:� H�� MO� S� V6		� N+	� Z+�� 3� _���� $:

� c� :	� +� gW� j�	� +� gW� j� m� � s�� :+� 8� w�+� 8� w� :+� z�+� z+|� 3+� 6+� 8:<�� B� D:� H�� MO� S� V6� N+� Z+�� 3� _���� $:� c� :� +� gW� j�� +� gW� j� m� � s�� :+� 8� w�+� 8� w� :+� z�+� z+�� 3+� 6+� 8:<�� B� D:� H�� MO� S� V6� N+� Z+�� 3� _���� $:� c� :� +� gW� j�� +� gW� j� m� � s�� :+� 8� w�+� 8� w� :+� z�+� z+�� 3+� 6+� 8:<�� B� D:� H�� MO� S� V6� N+� Z+�� 3� _���� $:� c� :� +� gW� j�� +� gW� j� m� � s�� :+� 8� w�+� 8� w� :+� z�+� z+�� 3+� 6+� 8:<¶ B� D:  � H Ķ M O� S � V6!!� N+ !� Z+ƶ 3 � _���� $:" "� c� :#!� +� gW � j#�!� +� gW � j � m� � s�� :$+� 8 � w$�+� 8 � w� :%+� z%�+� z+�� 3+� 6+� 8:<ȶ B� D:&&� H&ʶ M&O� S&� V6''� N+&'� Z+̶ 3&� _���� $:(&(� c� :)'� +� gW&� j)�'� +� gW&� j&� m� � s�� :*+� 8&� w*�+� 8&� w� :++� z+�+� z+�� 3+� 6+� 8:<ζ B� D:,,� H,ж M,O� S,� V6--� N+,-� Z+Ҷ 3,� _���� $:.,.� c� :/-� +� gW,� j/�-� +� gW,� j,� m� � s�� :0+� 8,� w0�+� 8,� w� :1+� z1�+� z+�� 3+� 6+� 8:<Զ B� D:22� H2ֶ M2O� S2� V633� N+23� Z+ض 32� _���� $:424� c� :53� +� gW2� j5�3� +� gW2� j2� m� � s�� :6+� 82� w6�+� 82� w� :7+� z7�+� z+�� 3+� 6+� 8:<ڶ B� D:88� H8ܶ M8O� S8� V699� N+89� Z+޶ 38� _���� $::8:� c� :;9� +� gW8� j;�9� +� gW8� j8� m� � s�� :<+� 88� w<�+� 88� w� :=+� z=�+� z+�� 3+� 6+� 8:<� B� D:>>� H>� M>O� S>� V6??� N+>?� Z+� 3>� _���� $:@>@� c� :A?� +� gW>� jA�?� +� gW>� j>� m� � s�� :B+� 8>� wB�+� 8>� w� :C+� zC�+� z+�� 3+� 6+� 8:<� B� D:DD� HD� MDO� SD� V6EE� N+DE� Z+� 3D� _���� $:FDF� c� :GE� +� gWD� jG�E� +� gWD� jD� m� � s�� :H+� 8D� wH�+� 8D� w� :I+� zI�+� z+�� 3+� 6+� 8:<� B� D:JJ� HJ� MJO� SJ� V6KK� N+JK� Z+� 3J� _���� $:LJL� c� :MK� +� gWJ� jM�K� +� gWJ� jJ� m� � s�� :N+� 8J� wN�+� 8J� w� :O+� zO�+� z+�� 3+� 6+� 8:<� B� D:PP� HP�� MPO� SP� V6QQ� N+PQ� Z+�� 3P� _���� $:RPR� c� :SQ� +� gWP� jS�Q� +� gWP� jP� m� � s�� :T+� 8P� wT�+� 8P� w� :U+� zU�+� z+�� 3++� �*� �2� � *� �2� ��� �� � � &+�� 3+� �*� �2�� W+� 3� 9+�� 3+� �*� �2++� �*� �2� � *� �2� �� W+
� 3+� 3++� �*� �2� � *� �2� ��� �� � � &+�� 3+� �*� �2�� W+� 3� 9+�� 3+� �*� �2++� �*� �2� � *� �2� �� W+
� 3+� 3++� �*� �2� � *� �2� ��� �� � � '+�� 3+� �*� �2�� W+� 3� ;+�� 3+� �*� �2++� �*� �2� � *� �2� �� W+
� 3+� 3++� �*� �2� � *� �2� ��� �� � � '+�� 3+� �*� �2�� W+� 3� <+�� 3+� �*� �2++� �*� �2� � *� �2� �� W+
� 3+� 3++� �*� �	2� � � �� ��� �� � � '+�� 3+� �*� �
2� W+� 3� $+�� 3+� �*� �
2� W+
� 3+� 3++� �*� �2� � *� �2� ��� �� � � '+�� 3+� �*� �2� W+� 3� $+�� 3+� �*� �2� W+
� 3+� 3++� �*� �2� � *� �2� ��� �� � � '+�� 3+� �*� �2� W+� 3� $+�� 3+� �*� �2� W+
� 3+� 3++� �*� �2� � *� �2� ��� �� � � '+�� 3+� �*� �2�� W+� 3� <+�� 3+� �*� �2++� �*� �2� � *� �2� �� W+
� 3+� 3++� �*� �2� � *� �2� ��� �� � � '+�� 3+� �*� �2�� W+� 3� <+�� 3+� �*� �2++� �*� �2� � *� �2� �� W+
� 3+� 3++� �*� �2� � *� �2� ��� �� � � '+�� 3+� �*� �2�� W+� 3� <+�� 3+� �*� �2++� �*� �2� � *� �2� �� W+
� 3+� 3+� �+� 3+� 8 "� B�$:VV�%V&�)V++� �*� �2�- �3�9;�9�>V+� �*� �2�- �3+?�E�9+� �*� �2�- �3�9+?�E�9+� �*� �2�- �3�9+?�E�9+� �*� �2�- �3�9+?�E�9+� �*� �2�- �3�9+?�E�9++� �*� �2� � � �� ��3�9+?�E�9++� �*� �2� � � �� ��3�9+?�E�9++� �*� �2� � � �� ��3�9+?�E�9+� �*� �
2�- �3�9+?�E�9+� �*� �2�- �3�9+?�E�9+� �*� �2�- �3�9+?�E�9+� �*� �2�- �3�9+?�E�9+� �*� �2�- �3�9+?�E�9+� �*� �2�- �3�9�HV�KV�LWV�M� � s�� :W+� 8V� wW�+� 8V� w+O� 3+�S:X+U� 3+� 8WY[� B�]:YY_�`Yb+� �*� �2�- �3�9d�9+� �*� �2�- �3�9f�9�iYj�oY�p6ZZ� 9+YZ� Z+r� 3Y�s��� :[Z� +� gW[�Z� +� gWY�t� � s�� :\+� 8Y� w\�+� 8Y� w+v� 3� �:]]�z� ]�]�~:^+^��+�� 3+� ����� W+�� 3+�� �+�� 3+� 8���� B��:__��W_��� � s�� :`+� 8_� w`�+� 8_� w+�� 3� :a+X��a�+X��+�� 3+�S:b+�� 3+� 8���� B��:cc��c���c���c���c��6dd�>+cd� Z+�� 3+� 8���� B��:ee¶�e+� �*� �2�- �3f�9��e++� �*� �2�- �3�9f�9��e��We��� � s�� :f+� 8e� wf�+� 8e� w+˶ 3+� 8��Ͷ B��:gg϶�g+� �*� �2�- ��gԶ�g��Wg��� � s�� :h+� 8g� wh�+� 8g� w+˶ 3c����� :id� +� gWi�d� +� gWc��� � s�� :j+� 8c� wj�+� 8c� w+ض 3� 4:kk�z� k�k�~:l+l��+ڶ 3� :m+b��m�+b��+ܶ 3++� �*� �2� � *� �2� �޸ �� � ��+� 3+� �*� �2++� �*� �2�- �3�9;�9� W+� 3++� �*� �2�- �� ~+� 3+� 8 � B�$:nn�%n��)n+� �*� �2�- �3�>n�LWn�M� � s�� :o+� 8n� wo�+� 8n� w+� 3� +� 3+� �*� �2++� �*� �2�- �3�9f�9� W+� 3++� �*� �2�- �� ~+� 3+� 8 � B�$:pp�%p��)p+� �*� �2�- �3�>p�LWp�M� � s�� :q+� 8p� wq�+� 8p� w+� 3� +� 3��+�� 3+� �*� �2++� �*� �2�- �3�9;�9� W+�� 3++� �*� �2�- �� ~+�� 3+� 8 �� B�$:rr�%r��)r+� �*� �2�- �3�>r�LWr�M� � s�� :s+� 8r� ws�+� 8r� w+�� 3� +�� 3+� �*� � 2++� �*� �2�- �3�9f�9� W+�� 3++� �*� � 2�- �� ~+�� 3+� 8 � B�$:tt�%t��)t+� �*� � 2�- �3�>t�LWt�M� � s�� :u+� 8t� wu�+� 8t� w+� 3� +� 3+� 3� +� 3� H = K N ) = V Y    � �   
 � �  />A )/JM  ��   ���  �� )�  �DD  �^^  ��� )���  �  u  r�� )r��  I��  6��  3BE )3NQ  
��  ���  � )�  �HH  �bb  ��� )���  �		  y##  v�� )v��  M��  :��  7FI )7RU  ��  ���  �
 )�  �LL  �ff  ��� )���  �		  }	'	'  	z	�	� )	z	�	�  	Q	�	�  	>	�	�  
;
J
M )
;
V
Y  

�
�  	�
�
�  'AA  ���  �&&  eDG )���  e��  i��  �::  Ldd  ��  ��� )���  ���  ^��  8uu  EE   f         * +  g  Z �      @  �  �  �  �  �  � 2 �  � #n %� '/ )u +� -6 /� 1� 3r 5� 73 9y ;� =: ?� A� Cv E� G	7 I	} K	� M
> O
� Q
� S
� T U V< WC Ys Z� [� \� ]� _� ` a" bT c[ e� f� g� h� i� l m4 n= oX p_ r� s� t� u� v� x	 y$ z- {H |O ~� � �� �� �� � �, �5 �h �o �� �� �� �� �� � � � �7 �[ �X �X �\ �i �� �� �� �A �g �~ �� �� �� �� �� �  � �P �s �� �� � � �U �� �� �� �� �� �  �# �W �u �� �� �� �� �' �E �� �� �� �� �� � � �� �� �� �� �� �� �` �f jmqw{h     ) 	 e        �    h     ) 
 e         �    h     )  e        �    h        e  Z    N*!�Y�"SY$�"SY&�"SY(�"SY*�"SY,�"SY.�"SY0�"SY2�"SY	4�"SY
6�"SY8�"SY:�"SY<�"SY>�"SY@�"SYB�"SYD�"SYF�"SYH�"SYJ�"SYL�"SYN�"SYP�"SYR�"SYT�"SYV�"SYX�"SYZ�"SY\�"SY^�"SY`�"SY b�"S� ��     i    