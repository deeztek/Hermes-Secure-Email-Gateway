����   2* /proprietary/_2/inc/edit_console_settings_cfm$cf  lucee/runtime/PageImpl  4/compile/proprietary/2/inc/edit_console_settings.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  }Bƈ getSourceLength      !3 getCompileTime  }��� getHash ()I� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this 1Lproprietary/_2/inc/edit_console_settings_cfm$cf; 
 

 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 	formScope !()Llucee/runtime/type/scope/Form; 4 5
 / 6 lucee/runtime/op/Caster 8 toStruct /(Ljava/lang/Object;)Llucee/runtime/type/Struct; : ;
 9 < keys $[Llucee/runtime/type/Collection$Key; > ?	  @ !lucee/runtime/type/Collection$Key B .lucee/runtime/functions/struct/StructKeyExists D \(Llucee/runtime/PageContext;Llucee/runtime/type/Struct;Llucee/runtime/type/Collection$Key;)Z & F
 E G 

 I us &()Llucee/runtime/type/scope/Undefined; K L
 / M $lucee/runtime/type/util/KeyConstants O _M #Llucee/runtime/type/Collection$Key; Q R	 P S 7Edit Console Settings: form.console_mode does not exist U "lucee/runtime/type/scope/Undefined W set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; Y Z X [ 
 ] 	error.cfm _ 	doInclude (Ljava/lang/String;Z)V a b
 / c lucee/runtime/PageContextImpl e lucee.runtime.tag.Abort g cfabort i use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; k l
 f m lucee/runtime/tag/Abort o 
doStartTag q $
 p r doEndTag t $
 p u lucee/runtime/exp/Abort w newInstance (I)Llucee/runtime/exp/Abort; y z
 x { reuse !(Ljavax/servlet/jsp/tagext/Tag;)V } ~
 f  

   � 
  
   � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � ip � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � fqdn � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � lucee/runtime/tag/Query � update � setName � 1
 � � hermes � setDatasource (Ljava/lang/Object;)V � �
 � �
 � r initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � #
  update parameters2 set value2=' � toString &(Ljava/lang/Object;)Ljava/lang/String; � �
 9 � writePSQ � �
 / � 1', applied='2' where parameter='console.mode'
   � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � �
 � u 	outputEnd � 
 / �   

   � #lucee/commons/color/ConstantsDouble � _1 Ljava/lang/Double; � �	 � � 
      
   � :Edit Console Settings: form.console_mode is not ip or fqdn � 
   � 
  
    
     � 
    
    
     � X � 1 � 

     � 
    
     � VEdit Console Settings: form.console_host does not exist when form.console_mode is fqdn � 
     � 
      
     � bob@ � java/lang/String � concat &(Ljava/lang/String;)Ljava/lang/String; � �
 � � 
            
     � email � (lucee/runtime/functions/decision/IsValid � B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z & �
 � � _0 � �	 � � sessionScope $()Llucee/runtime/type/scope/Session; � �
 /   lucee/runtime/type/scope/Session [ lucee.runtime.tag.Location 
cflocation lucee/runtime/tag/Location	 cgiScope  ()Llucee/runtime/type/scope/CGI;
 / lucee/runtime/type/scope/CGI � setUrl 1

 setAddtoken (Z)V



 r

 u 1', applied='2' where parameter='console.host'
     
            
   _2 �	 �  

    
  " 
            
    
  $ 

   
  & 


( 
  
* 2, 
    
. 5Edit Console Settings: certificateno_1 does not exist0  2 _34 �	 �5 

      
7 checkcertificate9 .
select id from system_certificates where id=; lucee.runtime.tag.QueryParam= cfqueryparam? lucee/runtime/tag/QueryParamA setValueC �
BD CF_SQL_INTEGERF setCfsqltypeH 1
BI
B r
B u getCollectionM � XN #lucee/runtime/util/VariableUtilImplP recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;RS
QT (Ljava/lang/Object;D)I �V
 �W 
          
Y !
update parameters2 set value2='[ 6', applied='2' where parameter='console.certificate'
]   

_ 
  

a 

    

c 3e /opt/hermes/ssl/dhparam.pemg 'lucee/runtime/functions/file/FileExistsi 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &k
jl enablen updatedhparamp z
update parameters2 set value2='enable', active='1', applied='2' where parameter='console.dhparam' and module='console'
r _4t �	 �u disablew {
update parameters2 set value2='disable', active='1', applied='2' where parameter='console.dhparam' and module='console'
y =Edit Console Settings: form.dh_param is not enable or disable{ @Edit Console Settings: form.dh_param passed without dhparam file} 
      

 



� 4� /Edit Console Settings: form.hsts does not exist� 
        
  � 
updatehsts� {
  update parameters2 set value2='enable', active='1', applied='2' where parameter='console.hsts' and module='console'
  � _5� �	 �� |
  update parameters2 set value2='disable', active='1', applied='2' where parameter='console.hsts' and module='console'
  � 9Edit Console Settings: form.hsts is not enable or disable� 
  
  
  � 
        
  
  � 
    
  
  � 
    

  � 5� /Edit Console Settings: form.ocsp does not exist� 
    
      � 
            
      � 
updateocsp� �
      update parameters2 set value2='enable', active='1', applied='2' where parameter='console.ssl_stapling' and module='console'
      � 
      
      � _6� �	 �� �
      update parameters2 set value2='disable', active='1', applied='2' where parameter='console.ssl_stapling' and module='console'
      � 9Edit Console Settings: form.ocsp is not enable or disable� 
      � 
      
      
      � 
            
      
      � 
        
      
      � 



      � 6� 
    
        � 
        
        � 5Edit Console Settings: form.ocspverify does not exist� 

        � 
          
        � 
        
          � 
                
          � updateocspverify� �
          update parameters2 set value2='enable', active='1', applied='2' where parameter='console.ssl_stapling_verify' and module='console'
          � 
          
          � _7� �	 �� �
          update parameters2 set value2='disable', active='1', applied='2' where parameter='console.ssl_stapling_verify' and module='console'
          � ?Edit Console Settings: form.ocspverify is not enable or disable� 
          � $
          
          
          � *
                
          
          � &
            
          
          � 
 
� 7� %generate_auth_nginx_configuration.cfm�  generate_nginx_configuration.cfm� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � console_mode� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� CONSOLE_MODE STEP console_host 
TESTDOMAIN CONSOLE_HOST	 HTTP_REFERER certificateno_1 CERTIFICATENO_1 CHECKCERTIFICATE dh_param DH_PARAM hsts HSTS ocsp OCSP 
ocspverify 
OCSPVERIFY! subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             > ?   #$       %   *     *� 
*� *� � *���*+���        %         �        %        � �        %         �        %         �         %         !�      # $ %        %�      & ' %  �  k  `+-� 3++� 7� =*� A2� C� H� � � l+J� 3+� N� TV� \ W+^� 3+`� d+^� 3+� fhj� n� pM,� sW,� v� � |�� N+� f,� �-�+� f,� �+�� 3��+�� 3+� 7*� A2� � �� �� � � '+� 7*� A2� � �� �� � � � � �+�� 3+� �+� f��� n� �:�� ��� �� �6� j+� �+�� 3++� 7*� A2� � � �� �+�� 3� ���ا $:� �� :� +� �W� ��� +� �W� �� �� � |�� :+� f� ��+� f� �� :	+� �	�+� �+̶ 3+� N*� A2� ҹ \ W+�� 3� p+Զ 3+� N� Tֹ \ W+ض 3+`� d+ض 3+� fhj� n� p:

� sW
� v� � |�� :+� f
� ��+� f
� �+ڶ 3+ܶ 3+J� 3+� N*� A2� � ߸ �� � �+� 3+� 7*� A2� � �� �� � ��+� 3++� 7� =*� A2� C� H� � � s+� 3+� N� T� \ W+� 3+`� d+� 3+� fhj� n� p:� sW� v� � |�� :+� f� ��+� f� �+� 3�1+� 3+� �+� 3+� N*� A2�+� 7*� A2� � � �� � \ W+� 3� :+� ��+� �+� 3+�+� N*� A2� � � �� � � �+� 3+� N*� A2� �� \ W+� 3+�� T� ҹ W+� 3+� �+� 3+� f� n�
:+�*� A2� � ����W�� � |�� :+� f� ��+� f� �+� 3� :+� ��+� �+�� 3� �+�� 3+� �+� f��� n� �:�� ��� �� �6� k+� �+�� 3++� 7*� A2� � � �� �+� 3� ���ק $:� �� :� +� �W� ��� +� �W� �� �� � |�� :+� f� ��+� f� �� :+� ��+� �+� 3+� N*� A2�!� \ W+#� 3+%� 3+J� 3� #+J� 3+� N*� A2�!� \ W+'� 3+)� 3� ++� 3+� N*� A2� � -� �� � �+/� 3++� 7� =*� A2� C� H� � � v+/� 3+� N� T1� \ W+^� 3+`� d+^� 3+� fhj� n� p:� sW� v� � |�� :+� f� ��+� f� �++� 3�^++� 3+� 7*� A2� � 3� �� � � &+J� 3+� N*� A2�6� \ W++� 3�+8� 3+� �+� f��� n� �::� ��� �� �6� �+� �+<� 3+� f>@� n�B:+� 7*� A2� � �EG�J�KW�L� � |�� :+� f� ��+� f� �+^� 3� ����� $:� �� :� +� �W� ��� +� �W� �� �� � |�� : +� f� � �+� f� �� :!+� �!�+� �+J� 3++� N*� A	2�O �U�X� � � �+J� 3+� N*� A2� �� \ W+^� 3+�� T�!� W+Z� 3+� �+^� 3+� f� n�
:""+�*� A2� � ��"�"�W"�� � |�� :#+� f"� �#�+� f"� �+^� 3� :$+� �$�+� �+J� 3� �+J� 3+� �+� f��� n� �:%%�� �%�� �%� �6&&� m+%&� �+\� 3++� 7*� A2� � � �� �+^� 3%� ���է $:'%'� �� :(&� +� �W%� �(�&� +� �W%� �%� �� � |�� :)+� f%� �)�+� f%� �� :*+� �*�+� �+`� 3+� N*� A2�6� \ W+)� 3+b� 3+d� 3+)� 3� +)� 3+� N*� A2� � f� �� � �Q+/� 3++� 7� =*� A
2� C� H�+J� 3+h�m��+J� 3+� 7*� A2� � o� �� � � �+8� 3+� �+� f��� n� �:++q� �+�� �+� �6,,� O++,� �+s� 3+� ���� $:-+-� �� :.,� +� �W+� �.�,� +� �W+� �+� �� � |�� :/+� f+� �/�+� f+� �� :0+� �0�+� �+J� 3+� N*� A2�v� \ W+J� 3�q+� 7*� A2� � x� �� � � �+J� 3+� �+� f��� n� �:11q� �1�� �1� �622� O+12� �+z� 31� ���� $:313� �� :42� +� �W1� �4�2� +� �W1� �1� �� � |�� :5+� f1� �5�+� f1� �� :6+� �6�+� �+J� 3+� N*� A2�v� \ W+J� 3� r+J� 3+� N� T|� \ W+^� 3+`� d+^� 3+� fhj� n� p:77� sW7� v� � |�� :8+� f7� �8�+� f7� �+)� 3+J� 3� r+J� 3+� N� T~� \ W+^� 3+`� d+^� 3+� fhj� n� p:99� sW9� v� � |�� ::+� f9� �:�+� f9� �+)� 3+J� 3� #+J� 3+� N*� A2�v� \ W+�� 3+b� 3� +�� 3+� N*� A2� � �� �� � �!+/� 3++� 7� =*� A2� C� H� � � u+J� 3+� N� T�� \ W+^� 3+`� d+^� 3+� fhj� n� p:;;� sW;� v� � |�� :<+� f;� �<�+� f;� �++� 3�~+�� 3+� 7*� A2� � o� �� � � �+�� 3+� �+� f��� n� �:==�� �=�� �=� �6>>� O+=>� �+�� 3=� ���� $:?=?� �� :@>� +� �W=� �@�>� +� �W=� �=� �� � |�� :A+� f=� �A�+� f=� �� :B+� �B�+� �+�� 3+� N*� A2��� \ W+�� 3�q+� 7*� A2� � x� �� � � �+�� 3+� �+� f��� n� �:CC�� �C�� �C� �6DD� O+CD� �+�� 3C� ���� $:ECE� �� :FD� +� �WC� �F�D� +� �WC� �C� �� � |�� :G+� fC� �G�+� fC� �� :H+� �H�+� �+�� 3+� N*� A2��� \ W+�� 3� r+�� 3+� N� T�� \ W+ض 3+`� d+ض 3+� fhj� n� p:II� sWI� v� � |�� :J+� fI� �J�+� fI� �+�� 3+�� 3+�� 3� +�� 3+� N*� A2� � �� �� � �(+� 3++� 7� =*� A2� C� H� � � t+� 3+� N� T�� \ W+� 3+`� d+� 3+� fhj� n� p:KK� sWK� v� � |�� :L+� fK� �L�+� fK� �+� 3��+�� 3+� 7*� A2� � o� �� � � �+�� 3+� �+� f��� n� �:MM�� �M�� �M� �6NN� O+MN� �+�� 3M� ���� $:OMO� �� :PN� +� �WM� �P�N� +� �WM� �M� �� � |�� :Q+� fM� �Q�+� fM� �� :R+� �R�+� �+�� 3+� N*� A2��� \ W+�� 3�w+� 7*� A2� � x� �� � � �+�� 3+� �+� f��� n� �:SS�� �S�� �S� �6TT� O+ST� �+�� 3S� ���� $:USU� �� :VT� +� �WS� �V�T� +� �WS� �S� �� � |�� :W+� fS� �W�+� fS� �� :X+� �X�+� �+�� 3+� N*� A2��� \ W+�� 3� u+�� 3+� N� T�� \ W+�� 3+`� d+�� 3+� fhj� n� p:YY� sWY� v� � |�� :Z+� fY� �Z�+� fY� �+�� 3+�� 3+�� 3� +�� 3+� N*� A2� � �� �� � �-+�� 3++� 7� =*� A2� C� H� � � x+�� 3+� N� T¹ \ W+Ķ 3+`� d+Ķ 3+� fhj� n� p:[[� sW[� v� � |�� :\+� f[� �\�+� f[� �+ƶ 3��+ȶ 3+� 7*� A2� � o� �� � � �+ʶ 3+� �+� f��� n� �:]]̶ �]�� �]� �6^^� O+]^� �+ζ 3]� ���� $:_]_� �� :`^� +� �W]� �`�^� +� �W]� �]� �� � |�� :a+� f]� �a�+� f]� �� :b+� �b�+� �+ж 3+� N*� A2�ӹ \ W+ж 3�w+� 7*� A2� � x� �� � � �+ж 3+� �+� f��� n� �:cc̶ �c�� �c� �6dd� O+cd� �+ն 3c� ���� $:ece� �� :fd� +� �Wc� �f�d� +� �Wc� �c� �� � |�� :g+� fc� �g�+� fc� �� :h+� �h�+� �+ж 3+� N*� A2�ӹ \ W+ж 3� u+ж 3+� N� T׹ \ W+ٶ 3+`� d+ٶ 3+� fhj� n� p:ii� sWi� v� � |�� :j+� fi� �j�+� fi� �+۶ 3+ݶ 3+߶ 3� +� 3+� N*� A2� � � �� � � )+J� 3+�� d+J� 3+�� d+)� 3� +^� 3� B ] r r  EH )QT   ���   ���  ##  �  1gg  �!!  �AA  ��� )���  r  a    ))  �$$  �JM )�VY  ���  ���  3hh  ��  �	
	 )�		  �	O	O  �	i	i  
n
~
� )
n
�
�  
J
�
�  
9
�
�  m}� )m��  I��  8��  E\\  ���  ���  N^a )Njm  *��  ��  M]` )Mil  )��  ��  %<<  �

  ��� )���  o��  ^  ��� )���  q��  `  r��  D[[  ��� )�  �::  �TT  ��� )�  �<<  �VV  ���   &         * +  '  � �        (  =  J  �  �  �  9 � � � � �  = "@ #C %F &I (o *� ,� .� /� 0! 2* 44 5a 6w 8� :� ;� =� >; ?Q AZ C� D� E1 GK IN JR LU MX Oa Q{ S~ T� V� W� Y� [� ]� ^� _D aN cv e� g� i� j> k� m� o� p r s� t� v� x� y� z	z |	� ~	� 	� �	� �	� �	� �	� �	� �	� �	� �	� �
	 �
2 �
r �
� � �1 �q �� � � �$ �1 �w �z �} �� �� �� �� �� �� �� � � � �% �) �Q �w �� �� �� �� � �R �� �� � �Q �� �� �� � � �W �Z �^ �a �e �k �o �� �� �� �� �$ �. �W �� � �- �Y �� �/9P^�	�
������"0v�� �"e$&�(�*g,�.�0�1�2�4�5�7 8:
;=5?CARCXD[E(     ) �� %        �    (     ) �� %         �    (     ) �� %        �    (    �    %   �     �*� CY�� SY� SY� SY� SY� SY
� SY� SY� SY� SY	� SY
� SY� SY� SY� SY� SY� SY � SY"� S� A�     )    