����   2( remount_archive_share_cfm$cf  lucee/runtime/PageImpl   /admin/remount_archive_share.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength      3o getCompileTime  n�Ы getHash ()I�@� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Lremount_archive_share_cfm$cf;<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
   --> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 �<html>
<head>
<title>Remount Archive Share</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
 4 us &()Llucee/runtime/type/scope/Undefined; 6 7
 / 8 $lucee/runtime/type/util/KeyConstants : _DATASOURCE #Llucee/runtime/type/Collection$Key; < =	 ; > hermes @ "lucee/runtime/type/scope/Undefined B set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; D E C Fg

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
                      <p style="margin-bottom: 0px;"><img id="Picture1" height="28" width="635" src="./background_635_trop.png" vspace="0" hspace="0" align="left" border="0" alt="background_635_trop" title="background_635_trop"> H-</p>
                    </td>
                  </tr>
                  <tr style="height: 172px;">
                    <td id="Cell9">
                      <table width="635" border="0" cellspacing="0" cellpadding="0" align="left">
                        <tr>
                          <td> J action L &lucee/runtime/config/NullSupportHelper N NULL P '
 O Q -lucee/runtime/interpreter/VariableInterpreter S getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; U V
 T W   Y %lucee/runtime/exp/ExpressionException [ java/lang/StringBuilder ] The required parameter [ _  1
 ^ a append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; c d
 ^ e ] was not provided. g -(Ljava/lang/String;)Ljava/lang/StringBuilder; c i
 ^ j toString ()Ljava/lang/String; l m
 ^ n
 \ a lucee/runtime/PageContextImpl q any s�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V w x
 r y  
 {@       _action  =	 ; � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � 
 � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � =	 ; � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � 

 � C � remount � keys $[Llucee/runtime/type/Collection$Key; � �	  � $lucee/runtime/functions/dateTime/Now � =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; & �
 � � 
yyyy-mm-dd � 4lucee/runtime/functions/displayFormatting/DateFormat � S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; & �
 � � HH:mm:ss � 4lucee/runtime/functions/displayFormatting/TimeFormat �
 � � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 r � lucee/runtime/tag/Query � getjobdetails � setName � 1
 � � setDatasource (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � &
select * from archive_jobs limit 1
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 r � 	outputEnd � 
 / � customtrans � getrandom_results � 	setResult � 1
 � � Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
 inserttrans stResult &
insert into salt
(salt)
values
(' getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;	

 / getId $
 / lucee/runtime/type/Query getCurrentrow (I)I getRecordcount $ !lucee/runtime/util/NumberIterator load '(II)Llucee/runtime/util/NumberIterator;
 addQuery (Llucee/runtime/type/Query;)V  C! isValid (I)Z#$
% current' $
( go (II)Z*+, lucee/runtime/op/Caster. &(Ljava/lang/Object;)Ljava/lang/String; l0
/1 #lucee/runtime/functions/string/Trim3 A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &5
46 writePSQ8 �
 /9 removeQuery;  C< release &(Llucee/runtime/util/NumberIterator;)V>?
@ ')
B gettransD 2
select salt as customtrans2 from salt where id='F getCollectionH � CI I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �K
 /L '
N deletetransP 
delete from salt where id='R lucee.runtime.tag.FileTagT cffileV lucee/runtime/tag/FileTagX hasBody (Z)VZ[
Y\ read^ 	setAction` 1
Ya */opt/hermes/scripts/mount_share_archive.shc setFilee 1
Yf validateshareh setVariablej 1
Yk
Y �
Y � 0 $/opt/hermes/tmp/mount_share_archive_p java/lang/Stringr concat &(Ljava/lang/String;)Ljava/lang/String;tu
sv 
THE-SERVERx ALLz (lucee/runtime/functions/string/REReplace| w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &~
} 	setOutput� �
Y� 	 
    
� 	THE-SHARE�  

� 
_DIRECTORY� =	 ;� THE-DIRECTORY� 
 
� SAMBAVER� 
THE-DOMAIN� THE-USERNAME� THE-PASSWORD�  
    


� lucee.runtime.tag.Execute� 	cfexecute� lucee/runtime/tag/Execute� 
/bin/chmod�
� � '+x /opt/hermes/tmp/mount_share_archive_� setArguments� �
��@N       
setTimeout (D)V��
��
� �
� �
� �@n       	/dev/null� setOutputfile� 1
�� -inputformat none� 


� delete�  /mnt/hermesemail_archive/testsmb� 'lucee/runtime/functions/file/FileExists� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &�
�� lucee.runtime.tag.Location� 
cflocation� lucee/runtime/tag/Location� email_archive.cfm?m3=1� setUrl� 1
�� setAddtoken�[
��
� �
� � email_archive.cfm?m3=2� cancel� email_archive.cfm�


                            <table border="0" cellspacing="0" cellpadding="0" width="635" id="LayoutRegion4" style="background-image: url('./background_635_middle.png'); height: 172px;">
                              <tr align="left" valign="top">
                                <td>
                                  <table border="0" cellspacing="0" cellpadding="0" width="628">
                                    <tr valign="top" align="left">
                                      <td width="14"></td>
                                      <td width="614" id="Text272" class="TextObject">
                                        <p style="text-align: center; margin-bottom: 0px;"><b>Are you sure you want to remount the Archive Job Share?</b></p>
                                      </td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td colspan="2" height="2"></td>
                                    �</tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      <td width="614" id="Text462" class="TextObject">
                                        <p style="text-align: center; margin-bottom: 0px;"><b><span style="color: rgb(255,0,0);">If you click YES, the the system will attempt to remount the Archive Job share.</span></b></p>
                                      </td>
                                    </tr>
                                  </table>
                                  <table border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top" align="left">
                                      <td width="12" height="27"></td>
                                      <td></td>
                                    </tr>
                                    <tr valign="top" align="left">
                                      <td></td>
                                      �<td width="615">
                                        <table id="Table128" border="0" cellspacing="0" cellpadding="0" width="615" style="height: 10px;">
                                          <tr style="height: 24px;">
                                            <td width="615" id="Cell769">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td align="center">
                                                    <table id="Table129" border="0" cellspacing="0" cellpadding="0" width="419" style="height: 24px;">
                                                      <tr style="height: 24px;">
                                                        <td width="218" id="Cell770">
                                                          <form name="Cell770FORM" action="" method="post">
                                                            �9<input type="hidden" name="action" value="remount">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                              <tr>
                                                                <td align="center"><input type="submit" id="FormsButton11" name="FormsButton11" value="YES" style="height: 24px; width: 49px;"></td>
                                                              </tr>
                                                            </table>
                                                          </form>
                                                        </td>
                                                        <td width="200" id="Cell771">
                                                          <form name="Cell771FORM" action="" method="post">
                                                            <input type="hidden" name="action" value="cancel">
                                                            �<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                        ��</table>
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
 ����� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � DATENOW� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� TIMENOW RANDOM STRESULT GENERATED_KEY CUSTOMTRANS3	 GETTRANS CUSTOMTRANS2 VALIDATESHARE GETJOBDETAILS SERVER SHARE 
SMBVERSION DOMAIN USERNAME PASSWORD TESTFILE subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   !"       #   *     *� 
*� *� � *���*+���        #         �        #        � �        #         �        #         �         #         !�      # $ #        %�      & ' #  �  _  O+-� 3+5� 3+� 9� ?A� G W+I� 3+K� 3+M+� R� XM>+� R,� .ZY:� !� \Y� ^Y`� bM� fh� k� o� p�M>+� rtM, u u� z+|� 3+ }� �� �� ��� �� � � Q+�� 3+� �� �� � Z� �� � � ++�� 3+� 9� �+� �� �� � � G W+�� 3� � +�� 3+� 9� �� � �� �� � ��+�� 3+� 9*� �2++� ��� �� G W+�� 3+� 9*� �2++� ��� �� G W+�� 3+� �+� r��� �� �:˶ �+� 9� ?� � � �� �6� N+� �+۶ 3� ����� $:� � :� +� �W� ��� +� �W� �� �� � � :	+� r� �	�+� r� �� :
+� �
�+� �+�� 3+� �+� r��� �� �:�� �+� 9� ?� � � ��� � �6� O+� �+� 3� ���� $:� � :� +� �W� ��� +� �W� �� �� � � :+� r� ��+� r� �� :+� ��+� �+�� 3+� �+� r��� �� �:� �+� 9� ?� � � �� � �6�@+� �+� 3+� �+��:+�6� 6� � � � �6� �:+� 9�" d6`�&� C�)�- � � � � '�)6+++� 9*� �2� � �2�7�:���� ":�- W+� 9�= �A��- W+� 9�= �A� :+� ��+� �+C� 3� ���� $:� � :� +� �W� ��� +� �W� �� �� � � :+� r� ��+� r� �� : +� � �+� �+�� 3+� �+� r��� �� �:!!E� �!+� 9� ?� � � �!� �6""� v+!"� �+G� 3+++� 9*� �2�J *� �2�M�2�:+O� 3!� ���̧ $:#!#� � :$"� +� �W!� �$�"� +� �W!� �!� �� � � :%+� r!� �%�+� r!� �� :&+� �&�+� �+�� 3+� 9*� �2++� 9*� �2�J *� �2�M� G W+�� 3+� �+� r��� �� �:''Q� �'+� 9� ?� � � �'� �6((� v+'(� �+S� 3+++� 9*� �2�J *� �2�M�2�:+O� 3'� ���̧ $:)')� � :*(� +� �W'� �*�(� +� �W'� �'� �� � � :++� r'� �+�+� r'� �� :,+� �,�+� �+�� 3+� rUW� ��Y:--�]-_�b-d�g-i�l-�mW-�n� � � :.+� r-� �.�+� r-� �+�� 3+� rUW� ��Y://�]/o�b/q+� 9*� �2� � �2�w�g/++� 9*� �2� � �2y++� 9*� �	2�J *� �
2�M�2{����/�mW/�n� � � :0+� r/� �0�+� r/� �+�� 3+� rUW� ��Y:11�]1_�b1q+� 9*� �2� � �2�w�g1i�l1�mW1�n� � � :2+� r1� �2�+� r1� �+�� 3+� rUW� ��Y:33�]3o�b3q+� 9*� �2� � �2�w�g3++� 9*� �2� � �2�++� 9*� �	2�J *� �2�M�2{����3�mW3�n� � � :4+� r3� �4�+� r3� �+�� 3++� 9*� �	2�J ���MZ� �� � �+�� 3+� rUW� ��Y:55�]5_�b5q+� 9*� �2� � �2�w�g5i�l5�mW5�n� � � :6+� r5� �6�+� r5� �+�� 3+� rUW� ��Y:77�]7o�b7q+� 9*� �2� � �2�w�g7++� 9*� �2� � �2�Z{����7�mW7�n� � � :8+� r7� �8�+� r7� �+�� 3�]++� 9*� �	2�J ���MZ� �� � �5+�� 3+� rUW� ��Y:99�]9_�b9q+� 9*� �2� � �2�w�g9i�l9�mW9�n� � � ::+� r9� �:�+� r9� �+�� 3+� rUW� ��Y:;;�];o�b;q+� 9*� �2� � �2�w�g;++� 9*� �2� � �2�++� 9*� �	2�J ���M�2{����;�mW;�n� � � :<+� r;� �<�+� r;� �+�� 3� +�� 3+� rUW� ��Y:==�]=_�b=q+� 9*� �2� � �2�w�g=i�l=�mW=�n� � � :>+� r=� �>�+� r=� �+�� 3+� rUW� ��Y:??�]?o�b?q+� 9*� �2� � �2�w�g?++� 9*� �2� � �2�++� 9*� �	2�J *� �2�M�2{����?�mW?�n� � � :@+� r?� �@�+� r?� �+�� 3+� rUW� ��Y:AA�]A_�bAq+� 9*� �2� � �2�w�gAi�lA�mWA�n� � � :B+� rA� �B�+� rA� �+�� 3+� rUW� ��Y:CC�]Co�bCq+� 9*� �2� � �2�w�gC++� 9*� �2� � �2�++� 9*� �	2�J *� �2�M�2{����C�mWC�n� � � :D+� rC� �D�+� rC� �+�� 3+� rUW� ��Y:EE�]E_�bEq+� 9*� �2� � �2�w�gEi�lE�mWE�n� � � :F+� rE� �F�+� rE� �+�� 3+� rUW� ��Y:GG�]Go�bGq+� 9*� �2� � �2�w�gG++� 9*� �2� � �2�++� 9*� �	2�J *� �2�M�2{����G�mWG�n� � � :H+� rG� �H�+� rG� �+�� 3+� rUW� ��Y:II�]I_�bIq+� 9*� �2� � �2�w�gIi�lI�mWI�n� � � :J+� rI� �J�+� rI� �+�� 3+� rUW� ��Y:KK�]Ko�bKq+� 9*� �2� � �2�w�gK++� 9*� �2� � �2�++� 9*� �	2�J *� �2�M�2{����K�mWK�n� � � :L+� rK� �L�+� rK� �+�� 3+� r��� ���:MM���M�+� 9*� �2� � �2�w��M���M��6NN� 8+MN� �+�� 3M������ :ON� +� �WO�N� +� �WM��� � � :P+� rM� �P�+� rM� �+�� 3+� r��� ���:QQq+� 9*� �2� � �2�w��Q���Q���Q���Q��6RR� 8+QR� �+�� 3Q������ :SR� +� �WS�R� +� �WQ��� � � :T+� rQ� �T�+� rQ� �+�� 3+� rUW� ��Y:UU�]U��bUq+� 9*� �2� � �2�w�gU�mWU�n� � � :V+� rU� �V�+� rU� �+�� 3+� 9*� �2�� G W+�� 3++� 9*� �2� � �ř �+�� 3+� rUW� ��Y:WW�]W��bW+� 9*� �2� � �2�gW�mWW�n� � � :X+� rW� �X�+� rW� �+�� 3+� r��� ���:YYͶ�Y��Y��WY��� � � :Z+� rY� �Z�+� rY� �+�� 3� �++� 9*� �2� � �ř � � a+�� 3+� r��� ���:[[׶�[��[��W[��� � � :\+� r[� �\�+� r[� �+�� 3� +�� 3� +� 9� �� � ٸ �� � � a+�� 3+� r��� ���:]]۶�]��]��W]��� � � :^+� r]� �^�+� r]� �+�� 3� +ݶ 3+߶ 3+� 3+� 3+� 3+� 3� /��� )���  l��  [  csv )c�  /��  ��  ���  ;  014 )0=@  �vv  ���  �  )�),  �bb  �||  := )FI  �  ���  ���  $��  �!!  Q��  	2	|	|  	�

  
t
�
�  
�ll  ���   ��  �  M��   JJ  z��  -ww  �))  ���  Z��  Tff  
��  �  n��  �  Y~~  �   $         * +  %  � n        	      ' 7  8 � 9 � : � ; � = >4 ?T A� C Eg G� I4 M% N� P� Q R� T� V W. X� Z \4 ]Q ^� \� ^� `; ba c~ d� b� d� f	 h	� j	� k	� l
) j
) l
- n
^ p
� r
� s t� r� t� v� x
 z0 {M |� z� |� ~7 �] �z �� �� �� �d �� �� � � � �� �� �� �@ �@ �D �d �� �� �� �) �1 �9 �W �� �� �� � � �  �: �X �� � �C �� �� �� � �' �1 �5 �8 �< �? �C �&     ) �� #        �    &     ) �� #         �    &     ) �� #        �    &    �    #   �     �*� �Y�� SY� SY� SY� SY� SY
� SY� SY� SY� SY	� SY
� SY� SY� SY� SY� SY� SY � S� ��     '    