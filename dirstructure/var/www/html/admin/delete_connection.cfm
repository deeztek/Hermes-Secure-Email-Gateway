����   2� M__138/__138/publish/hermes_seg_18_041454/proprietary/delete_connection_cfm$cf  lucee/runtime/PageImpl  */compile/proprietary/delete_connection.cfm imports *[Llucee/runtime/component/ImportDefintion; keys $[Llucee/runtime/type/Collection$Key; subs [Llucee/runtime/CIPage; <init> (Llucee/runtime/PageSource;)V ()V  
   initKeys  
   'lucee/runtime/component/ImportDefintion   	    lucee/runtime/type/UDFProperties  udfs #[Llucee/runtime/type/UDFProperties;  	   setPageSource  
   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  z�+�  p ��k getSourceLength      %� getCompileTime  zپ] getHash ()I*z|� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable 7

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Delete Connection</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
 9 lucee/runtime/PageContext ; write (Ljava/lang/String;)V = >
 < ? us &()Llucee/runtime/type/scope/Undefined; A B
 < C $lucee/runtime/type/util/KeyConstants E _DATASOURCE #Llucee/runtime/type/Collection$Key; G H	 F I hermes K "lucee/runtime/type/scope/Undefined M set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; O P N Qg

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-image: url('./top_blue.png'); margin: 0px;" class="nof-centerBody">
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0">
            <tr valign="top" align="left">
              <td width="9" height="53"></td>
              <td></td>
            </tr>
            <tr valign="top" align="left">
              <td></td>
              <td width="644">
                <table id="Table2" border="0" cellspacing="0" cellpadding="0" width="644" style="height: 56px;">
                  <tr style="height: 28px;">
                    <td width="644" id="Cell8">
                      <p style="margin-bottom: 0px;"><img id="Picture1" height="28" width="635" src="./background_635_trop.png" vspace="0" hspace="0" align="left" border="0" alt="background_635_trop" title="background_635_trop"> S-</p>
                    </td>
                  </tr>
                  <tr style="height: 132px;">
                    <td id="Cell9">
                      <table width="635" border="0" cellspacing="0" cellpadding="0" align="left">
                        <tr>
                          <td> U@        		  Y !lucee/runtime/type/Collection$Key [ *lucee/runtime/functions/decision/IsDefined ] B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z 5 _
 ^ ` 
 b sessionScope $()Llucee/runtime/type/scope/Session; d e
 < f  lucee/runtime/type/scope/Session h get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; j k i l 	VIOLATION n lucee/runtime/op/Operator p compare '(Ljava/lang/Object;Ljava/lang/String;)I r s
 q t lucee/runtime/PageContextImpl v lucee.runtime.tag.Location x 
cflocation z use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; | }
 w ~ lucee/runtime/tag/Location � license_invalid.cfm � setUrl � >
 � � setAddtoken (Z)V � �
 � � 
doStartTag � 3
 � � doEndTag � 3
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 w � NEW � 

 � action � &lucee/runtime/config/NullSupportHelper � NULL � 6
 � � -lucee/runtime/interpreter/VariableInterpreter � getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; � �
 � �   � %lucee/runtime/exp/ExpressionException � java/lang/StringBuilder � The required parameter [ �  >
 � � append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; � �
 � � ] was not provided. � -(Ljava/lang/String;)Ljava/lang/StringBuilder; � �
 � � toString ()Ljava/lang/String; � �
 � �
 � � any ��       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V � �
 w �  
 �@       _action � H	 F � True � (ZLjava/lang/String;)I r �
 q � 	formScope !()Llucee/runtime/type/scope/Form; � �
 < � _ACTION � H	 F � lucee/runtime/type/scope/Form � � l  

 � N l delete � outputStart � 
 < � lucee.runtime.tag.Query � cfquery � lucee/runtime/tag/Query � getscheduled � setName � >
 � � setDatasource (Ljava/lang/Object;)V � �
 � �
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 < � =
select entry_name, scheduled from ad_integration where id=' � _ID  H	 F lucee/runtime/op/Caster &(Ljava/lang/Object;)Ljava/lang/String; �
 writePSQ �
 <	 '
 doAfterBody 3
 � doCatch (Ljava/lang/Throwable;)V
 � popBody ()Ljavax/servlet/jsp/JspWriter;
 < 	doFinally 
 �
 � � 	outputEnd 
 < getCollection k N  I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; j"
 <# 1% 





' /var/www/html/schedule/) java/lang/String+ concat &(Ljava/lang/String;)Ljava/lang/String;-.
,/ _ad_tasks.cfm1 'lucee/runtime/functions/file/FileExists3 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z 55
46 lucee.runtime.tag.FileTag8 cffile: lucee/runtime/tag/FileTag< hasBody> �
=? 	setActionA >
=B setFileD >
=E
= �
= � 


I /etc/cron.d/hermes_adjob_K '
delete from ad_integration where id='M set_crontab.cfmO 	doInclude (Ljava/lang/String;Z)VQR
 <S 
getversionU D
select value from system_settings where parameter = 'version_no'
W 

  
Y 
    
[ ad_integration.cfm] cancel_=

                            <table border="0" cellspacing="0" cellpadding="0" width="635" id="LayoutRegion4" style="background-image: url('./background_635_middle.png'); height: 132px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="628">
                                    <tr valign="top" align="left">
                                      <td width="14"></td>
                                      <td width="614" id="Text272" class="TextObject">
                                        <p style="text-align: center; margin-bottom: 0px;"><b>Are you sure you want to delete this AD Connection?</b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      a<td width="14" height="11"></td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="615">
                                        <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="615" style="height: 10px;">
                                          <tr style="height: 24px;">
                                            <td width="615" id="Cell769">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table id="Table129" border="0" cellspacing="0" cellpadding="0" width="178" style="height: 24px;">
                                                      cs<tr style="height: 24px;">
                                                        <td width="93" id="Cell770">
                                                          <form name="Cell770FORM" action="" method="post">
                                                            <input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="e">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="center"><input type="submit" id="FormsButton11" name="FormsButton11" value="YES" style="height: 24px; width: 49px;"></td>
                                                              </tr>
                                                            </table>
                                                          </form>
                                                        </td>
                                                        <td width="85" id="Cell771">
                                                          <form name="Cell771FORM" action="" method="post">
                                                            <input type="hidden" name="action" value="cancel">
                                                            g<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="center"><input type="submit" id="FormsButton12" name="FormsButton12" value="NO" style="height: 24px; width: 39px;"></td>
                                                              </tr>
                                                            </table>
                                                          </form>
                                                        </td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                        i�</table>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr style="height: 32px;">
                    <td id="Cell10">
                      <p style="margin-bottom: 0px;"><img id="Picture2" height="32" width="635" src="./background_635_bottom.png" vspace="0" hspace="0" align="left" border="0" alt="background_635_bottom" title="background_635_bottom"></p>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
          

        </td>
      </tr>
    </table>
  </div>
</body>
</html>
 ����k this &Lproprietary/delete_connection_cfm$cf; udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageExceptionu licensew lucee/runtime/type/KeyImply intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;{|
z} LICENSE GETSCHEDULED� 	SCHEDULED� TESTFILE� 
ENTRY_NAME� Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile              	    
        �   *     *� *� *� � *� � *+�  �      ! " �         #�      % & �        � �      ' " �         (� *�      , " �         -�      / " �         0�      2 3 �        4�      5 6 �  
�  *  �+:� @+� D� JL� R W+T� @+V� @+ W*� Z2� \� a� �+c� @+� g*� Z2� m o� u� � � U+c� @+� wy{� � �M,�� �,� �,� �W,� �� � ��� N+� w,� �-�+� w,� �+c� @� ~+� g*� Z2� m �� u� � � ^+c� @+� wy{� � �:�� �� �� �W� �� � ��� :+� w� ��+� w� �+c� @� +c� @� +�� @+�+� �� �:6+� �� 0�Y:� !� �Y� �Y�� ��� ��� �� · ÿ:6+� w�� � �� �+Ͷ @+ β �� \� aԸ �� � � Q+c� @+� ۲ ޹ � �� u� � � ++c� @+� D� �+� ۲ ޹ � � R W+c� @� � +� @+� D� ޹ � � u� � ��+c� @+� �+� w��� � �:		� �	+� D� J� � � �	� �6

� h+	
� �+�� @++� ۲� � ��
+� @	���ڧ $:	�� :
� +�W	��
� +�W	�	�� � ��� :+� w	� ��+� w	� �� :+��+�+c� @++� D*� Z2�! *� Z2�$&� u� � �V+(� @+� D*� Z2*++� D*� Z2�! *� Z2�$��02�0� R W+c� @++� D*� Z2� � �7� w+c� @+� w9;� �=:�@�C+� D*� Z2� � ��F�GW�H� � ��� :+� w� ��+� w� �+c� @� +J� @+� D*� Z2L++� D*� Z2�! *� Z2�$��0� R W+c� @++� D*� Z2� � �7� w+c� @+� w9;� �=:�@�C+� D*� Z2� � ��F�GW�H� � ��� :+� w� ��+� w� �+c� @� +�� @+� �+� w��� � �:� �+� D� J� � � �� �6� i+� �+N� @++� ۲� � ��
+� @���٧ $:�� :� +�W��� +�W��� � ��� :+� w� ��+� w� �� :+��+�+�� @+P�T+�� @+� �+� w��� � �:V� �+� D� J� � � �� �6� O+� �+X� @���� $:�� :� +�W��� +�W��� � ��� :+� w� ��+� w� �� :+��+�+Z� @�++� D*� Z2�! *� Z2�$&� u� � � �+c� @+� �+� w��� � �:� �+� D� J� � � �� �6  � i+ � �+N� @++� ۲� � ��
+� @���٧ $:!!�� :" � +�W�"� � +�W��� � ��� :#+� w� �#�+� w� �� :$+�$�+�+�� @� +\� @+� wy{� � �:%%^� �%� �%� �W%� �� � ��� :&+� w%� �&�+� w%� �+c� @� }+� D� ޹ � `� u� � � _+c� @+� wy{� � �:''^� �'� �'� �W'� �� � ��� :(+� w'� �(�+� w'� �+c� @� +b� @+d� @+f� @+� �++� ۲� � �� @� :)+�)�+�+h� @+j� @+l� @�  p � �   �  o�� 8o��  B��  1��  ���  r��  ?B 8KN  ���  ���   8!  �WW  �qq  �%( 8�14  �jj  ���  ���  ,QQ  ���   �        mn  �   � <   
       ! / 7 0 ] 1 � 2 � 3! 4* 53 7� 8� 9� :� ; =* >r ?� @ A9 C< Jw K� L� M� N� N� O Q R@ S\ Tz U� V� V� W� Y Z3 [� ]� _ a� d� e� f g� i� k� l mk nu px } �� �� �� �� �� ��     8 op �        �    �     8 qr �         �    �     8 st �        �    �    v    �   L     @*� \Yx�~SY��~SY��~SY��~SY��~SY��~S� Z�     �    