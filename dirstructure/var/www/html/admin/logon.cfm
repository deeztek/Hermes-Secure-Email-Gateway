����   2� proprietary/logon_cfm$cf  lucee/runtime/PageImpl  /compile/proprietary/logon.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�
 � getSourceLength      I� getCompileTime  v�ԫ� getHash ()I@O� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Lproprietary/logon_cfm$cf; 

 , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 us &()Llucee/runtime/type/scope/Undefined; 4 5
 / 6 $lucee/runtime/type/util/KeyConstants 8 _DATASOURCE #Llucee/runtime/type/Collection$Key; : ;	 9 < hermes > "lucee/runtime/type/scope/Undefined @ set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; B C A D
<!--
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2017. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see <http://www.deeztek.com/products-and-services/hermes-secure-email-gateway/hermes-secure-email-gateway-pro-end-user-license-agreement/>.
-->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Logon</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">


<script type="text/javascript" src="./validation.js">
</script>
<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
 F<link rel="stylesheet" type="text/css" href="./site.css">
</head>
<body style="background-color: rgb(192,192,192); background-image: none; margin: 0px;" class="nof-centerBody">
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="988">
            <tr valign="top" align="left">
              <td height="53"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="97" width="988"><img id="Picture46" height="97" width="988" src="./top_blue_logon1.png" border="0" alt="top_blue_logon1" title="top_blue_logon1"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="262" width="988"> H action J &lucee/runtime/config/NullSupportHelper L NULL N '
 M O -lucee/runtime/interpreter/VariableInterpreter Q getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; S T
 R U   W %lucee/runtime/exp/ExpressionException Y java/lang/StringBuilder [ The required parameter [ ]  1
 \ _ append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; a b
 \ c ] was not provided. e -(Ljava/lang/String;)Ljava/lang/StringBuilder; a g
 \ h toString ()Ljava/lang/String; j k
 \ l
 Z _ lucee/runtime/PageContextImpl o any q�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V u v
 p w  
 y@       _action } ;	 9 ~ !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � 
 � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � ;	 9 � lucee/runtime/type/scope/Form � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � reason �@       keys $[Llucee/runtime/type/Collection$Key; � �	  � sessionScope $()Llucee/runtime/type/scope/Session; � �
 / �  lucee/runtime/type/scope/Session � � �  

 � 
logoncount � 1 � A � login �@$       (Ljava/lang/Object;D)I � �
 � � VYou have exceeded the maximum number of logons. Please wait 1 hour before trying again � � D lucee.runtime.tag.Location � 
cflocation � use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; � �
 p � lucee/runtime/tag/Location � 	logon.cfm � setUrl � 1
 � � setAddtoken (Z)V � �
 � � 
doStartTag � $
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 p � outputStart � 
 / � lucee.runtime.tag.Query � cfquery � lucee/runtime/tag/Query � checkrestore � setName � 1
 � � setDatasource (Ljava/lang/Object;)V � �
 � �
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � :
select status from restore_jobs where status='running'
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V 
 � popBody ()Ljavax/servlet/jsp/JspWriter;
 / 	doFinally 
 �	
 � � 	outputEnd 
 / getCollection � A #lucee/runtime/util/VariableUtilImpl recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;
 mSystem Restore is in Progress. You will not be be able to log into the system until the process has completed java/lang/Boolean FALSE Ljava/lang/Boolean;	 step  0" 	checkuser$ C
	SELECT username, password
	FROM system_users
	WHERE username='& lucee/runtime/op/Caster( &(Ljava/lang/Object;)Ljava/lang/String; j*
)+ writePSQ- �
 /. '
0 9

<!-- is the username present in the database? -->

2 #lucee/commons/color/ConstantsDouble4 _1 Ljava/lang/Double;67	58 plusRef 8(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Double;:;
 �< XThe username/password combination you typed is invalid. Please try again. Logon attempt > java/lang/String@ concat &(Ljava/lang/String;)Ljava/lang/String;BC
AD  of 10F I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �H
 /I@>       #lucee/runtime/functions/string/LeftM B(Llucee/runtime/PageContext;Ljava/lang/String;D)Ljava/lang/String; &O
NP@��      	hashCountT getVariableReference Y(Llucee/runtime/PageContext;Ljava/lang/String;)Llucee/runtime/type/ref/VariableReference;VW
 RX (lucee/runtime/type/ref/VariableReferenceZ (D)V B\
[] SHA-512_ UTF-8a #lucee/runtime/functions/string/Hashc e(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &e
df 


h &lucee/runtime/functions/string/Comparej B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)D &l
km toRef (D)Ljava/lang/Double;op
)q -1s TRUEu	v lucee.runtime.tag.Executex 	cfexecutez lucee/runtime/tag/Execute| /opt/hermes/scripts/dmidecode~
} � setArguments� �
}�@N       
setTimeout�\
}�
} �
} �
} � lucee.runtime.tag.FileTag� cffile� lucee/runtime/tag/FileTag� hasBody� �
�� read� 	setAction� 1
�� /usr/share/UUID� setFile� 1
�� temp1� setVariable� 1
��
� �
� � "lucee/runtime/functions/string/Chr� 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &�
�� ALL� (lucee/runtime/functions/string/REReplace� w(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String; &�
��@*       UUID:� 0 #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� 	setOutput� �
�� setAddnewline� �
�� /usr/share/UUID2� 'lucee/runtime/functions/file/FileExists� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &�
�� uuid� uuid2� /usr/share/lt� lt� $lucee/runtime/functions/dateTime/Now� =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &�
�� 
yyyy-mm-dd� 4lucee/runtime/functions/displayFormatting/DateFormat� S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &�
�� HH:mm:ss� 4lucee/runtime/functions/displayFormatting/TimeFormat�
�� &/usr/share/djigzo/ADDITIONAL-NOTES.TXT� date� d�  � getTimeZone ()Ljava/util/TimeZone;��
 /� toDate H(Ljava/lang/String;Ljava/util/TimeZone;)Llucee/runtime/type/dt/DateTime;��
)� H(Ljava/lang/Object;Ljava/util/TimeZone;)Llucee/runtime/type/dt/DateTime;��
)� )lucee/runtime/functions/dateTime/DateDiff� p(Llucee/runtime/PageContext;Ljava/lang/String;Llucee/runtime/type/dt/DateTime;Llucee/runtime/type/dt/DateTime;)D &�
�� 	getserial� I
select parameter, value from system_settings where parameter='serial'
� /usr/share/UUID3� _VALUE  ;	 9 delete NEW 	Community 	index.cfm	 VALID Pro 2 	VIOLATION #

<!-- /CFIF FOR LOGONCOUNT -->
 

<!-- /CFIF FOR ACTION -->
	



                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion3" style="background-image: url('./middle_988.png'); height: 262px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="968">
                        <tr valign="top" align="left">
                          <td width="14" height="227"></td>
                          <td width="954">
                            <table border="0" cellspacing="0" cellpadding="0">
                              <tr valign="top" align="left">
                                <td height="26"></td>
                              </tr>
                              <tr valign="top" align="left">
                                <td width="954">
                                  <script type="text/javascript">
                                  <!--
                                  function __fv1_logon(form) {
                                   var args = {
                                  "username":[["NOF_isRequired", [''], "A username is required", "", ""], ["NOF_isLengthInRange", ['1', '30'], "The username must be a min of 1 character and a maximum of 30 characters", "", ""]],
                                  "password":[["NOF_isRequired", [''], "A password is required", "", ""], ["NOF_isLengthInRange", ['8', '30'], "The password must be a minimum of 8 characters and a maximum of 30 characters", "", ""]]
                                   };
                                   return NOF_validateForm(form, args, true, null,'Please correct the following errors:');
                                  }
                                  //-->
                                  *</script>
                                  <form name="logon" action="" method="post" onSubmit="return __fv1_logon(this)">
                                    <input type="hidden" name="action" value="login">
                                    <table id="Table3" border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 144px;">
                                      <tr style="height: 18px;">
                                        <td width="954" id="Cell10">
                                          <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px;">Administration Console</span></b></p>
                                        </td>
                                      </tr>
                                      <tr style="height: 18px;">
                                        <td id="Cell11">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            ;<tr>
                                              <td align="center">
                                                <table width="198" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Username</span></b></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                      <tr style="height: 28px;">
                                        1<td id="Cell12">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center"><input type="text" id="FormsEditField1" name="username" size="25" maxlength="30" style="width: 196px; white-space: pre;"></td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                      <tr style="height: 18px;">
                                        <td id="Cell13">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">
                                                <table width="198" border="0" cellspacing="0" cellpadding="0">
                                                  -<tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: center; margin-bottom: 0px;"><b><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(128,128,128);">Password</span></b></p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                      <tr style="height: 28px;">
                                        <td id="Cell14">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              *<td align="center"><input type="password" id="FormsEditField2" name="password" size="25" maxlength="30" style="width: 196px; white-space: pre;" style="white-space:pre"></td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                      <tr style="height: 31px;">
                                        <td id="Cell15">
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td align="center">
                                                <table width="142" border="0" cellspacing="0" cellpadding="0">
                                                  <tr>
                                                    <td class="TextObject">
                                                      <p style="text-align: left; margin-bottom: 0px;">!<input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Logon" style="height: 24px; width: 142px;">&nbsp;</p>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </form>
                                </td>
                              </tr>
                            </table>
                            <table border="0" cellspacing="0" cellpadding="0" width="954">
                              <tr valign="top" align="left">
                                <td width="954" height="4"></td>
                              # �</tr>
                              <tr valign="top" align="left">
                                <td width="954" id="Text11" class="TextObject">
                                  <p style="text-align: center; margin-bottom: 0px;">% �

<P STYLE="text-align: center;"><SPAN STYLE="font-size: x-small; color: rgb(255,0,0); FACE="Arial,Helvetica,Geneva,Sans-serif,sans-serif">' </P>

)'&nbsp;</p>
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
            <tr valign="top" align="left">
              <td height="49" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion24" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="981">
                        <tr valign="top" align="left">
                          <td width="981" height="12"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            + 3<p style="text-align: center; margin-bottom: 0px;">- yyyy/ 
getversion1 D
SELECT value from system_settings where parameter = 'version_no'
3 getbuild5 B
SELECT value from system_settings where parameter = 'build_no'
7 ^
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway Version:9  Build:; . Copyright 2011-= l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>?_
&nbsp;</p>
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
    </table>
  </div>
</body>
</html>
 ����A udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageExceptionI  lucee/runtime/type/UDFPropertiesK udfs #[Llucee/runtime/type/UDFProperties;MN	 O setPageSourceQ 
 R lucee/runtime/type/KeyImplT intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;VW
UX REASONZ 
LOGONCOUNT\ CHECKRESTORE^ LOGGEDIN` USERNAMEb 	CHECKUSERd THESALTf PASSWORDh PASSWORDHASH512j THEPASSWORDl COMPARE_PASSWORDn TEMP2p TEMP1r TEMP3t TEMP4v TEMP5x 
UUID2_FILEz COMPARE_UUID| UUID~ UUID2� LT2� LT� DATENOW� TIMENOW� 
DIFFERENCE� DATE� 	GETSERIAL� LICENSE� EDITION� THEYEAR� 
GETVERSION� GETBUILD� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *�L�P*+�S�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �   �  t  3+-� 3+� 7� =?� E W+G� 3+I� 3+K+� P� VM>+� P,� .XY:� !� ZY� \Y^� `K� df� i� m� n�M>+� prK, s s� x+z� 3+ {� � �� ��� �� � � Q+�� 3+� �� �� � X� �� � � ++�� 3+� 7� �+� �� �� � � E W+�� 3� � +-� 3+�+� P� V:6+� P� 0XY:� !� ZY� \Y^� `�� df� i� m� n�:6+� pr� s s� x+�� 3+ �*� �2� �� ��� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +�� 3+�+� P� V:6	+� P� 0�Y:
� !� ZY� \Y^� `�� df� i� m� n�
:6	+� pr� s s	� x+z� 3+ �*� �2� �� ��� �� � � 1+�� 3+� 7*� �2+� �*� �2� � � E W+�� 3� +-� 3+� 7� �� � �� �� � �+-� 3+� 7*� �2� �  �� �� � � v+�� 3+� �*� �2�� � W+�� 3+� p��� �� �:̶ �� �� �W� �� � ߿� :+� p� ��+� p� �+-� 3�c+� 7*� �2� �  �� �� � �B+-� 3+� �+� p��� �� �:� �+� 7� =� � � �� �6� N+� �+�� 3� ����� $:�� :� +�W�
�� +�W�
�� � ߿� :+� p� ��+� p� � :+��+�+-� 3++� 7*� �2� �� �� � � w+�� 3+� �*� �2� � W+�� 3+� p��� �� �:̶ �� �� �W� �� � ߿� :+� p� ��+� p� �+�� 3� +-� 3+� �*� �2�� � W+�� 3+!+� P� V:6+� P� 2#Y:� "� ZY� \Y^� `!� df� i� m� n�:6+� pr! s s� x+�� 3+� �+� p��� �� �:%� �+� 7� =� � � �� �6� m+� �+'� 3++� �*� �2� � �,�/+1� 3� ���է $:�� :� +�W�
�� +�W�
�� � ߿� :+� p� ��+� p� � :+��+�+3� 3++� 7*� �2� �� �� � � �+-� 3+� �*� �2+� 7*� �2� � �9�=� � W+�� 3+� �*� �2?+� 7*� �2� � �,�EG�E� � W+�� 3+� p��� �� �:̶ �� �� �W� �� � ߿� :+� p� ��+� p� �+-� 3��++� 7*� �2� �� �� � �m+-� 3+� 7*� �2+++� 7*� �2� *� �	2�J�,K�Q� E W+-� 39 R9"9$$�� � 6&$�� � � �+U�Y:'' �^ 9*� '*$c\9*�^&� *"�� � � *"�� � � V+�� 3+� 7*� �
2++� �*� �	2� � �,+� 7*� �2� � �,�E`b�g� E W+�� 3��~+i� 3+� 7*� �2+� 7*� �2� � �,+� 7*� �
2� � �,�E� E W+-� 3+� 7*� �2++� 7*� �2� � �,++� 7*� �2� *� �	2�J�,�n�r� E W+-� 3+� 7*� �2� � �� �� � � �+-� 3+� �*� �2+� 7*� �2� � �9�=� � W+�� 3+� �*� �2?+� 7*� �2� � �,�EG�E� � W+�� 3+� p��� �� �:,,̶ �,� �,� �W,� �� � ߿� :-+� p,� �-�+� p,� �+i� 3��+� 7*� �2� � t� �� � � �+�� 3+� �*� �2+� 7*� �2� � �9�=� � W+�� 3+� �*� �2?+� 7*� �2� � �,�EG�E� � W+�� 3+� p��� �� �:..̶ �.� �.� �W.� �� � ߿� :/+� p.� �/�+� p.� �+-� 3�+� 7*� �2� � #� �� � ��+�� 3+� �*� �2�w� � W+�� 3+� �*� �2�9� � W+-� 3+� py{� ��}:00��0X��0���0��611� 8+01� �+�� 30������ :21� +�W2�1� +�W0��� � ߿� :3+� p0� �3�+� p0� �+-� 3+� p��� ���:44��4���4���4���4��W4��� � ߿� :5+� p4� �5�+� p4� �+-� 3+� 7*� �2++� 7*� �2� � �,+ ���X���� E W+-� 3+� 7*� �2++� 7*� �2� � �,+���X���� E W+�� 3+� 7*� �2++� 7*� �2� � �,XX���� E W+�� 3+� 7*� �2++� 7*� �2� � �,�X���� E W+-� 3+� p��� ���:66��6���6���6++� 7*� �2� � �,����6��6��W6��� � ߿� :7+� p6� �7�+� p6� �+-� 3+� 7*� �2ù E W+�� 3++� 7*� �2� � �șW+�� 3+� p��� ���:88��8���8���8ʶ�8��W8��� � ߿� :9+� p8� �9�+� p8� �+�� 3+� p��� ���:::��:���:ö�:̶�:��W:��� � ߿� :;+� p:� �;�+� p:� �+�� 3+� 7*� �2++� 7*� �2� � �,+� 7*� �2� � �,�n�r� E W+-� 3+� 7*� �2� � #� �� � ��+-� 3+� p��� ���:<<��<���<ζ�<ж�<��W<��� � ߿� :=+� p<� �=�+� p<� �+-� 3+� 7*� �2++� 7*� �2� � �,��� E W+-� 3+� 7*� �2� � �� �� � �a+�� 3+� 7*� �2++��׸ܹ E W+�� 3+� 7*� �2++��޸� E W+�� 3+� p��� ���:>>��>���>��>��>��W>��� � ߿� :?+� p>� �?�+� p>� �+�� 3+� 7*� �2+�+� 7*� �2� � �,�E+� 7*� �2� � �,�E+����+� 7*� �2� � +�������r� E W+-� 3+� 7*� �2� � � �� � �S+-� 3+� �+� p��� �� �:@@�� �@+� 7� =� � � �@� �6AA� O+@A� �+�� 3@� ���� $:B@B�� :CA� +�W@�
C�A� +�W@�
@�� � ߿� :D+� p@� �D�+� p@� � :E+�E�+�+-� 3+� p��� ���:FF��F���F���F+++� 7*� �2� ��J�,����F��F��WF��� � ߿� :G+� pF� �G�+� pF� �+-� 3+� p��� ���:HH��H��Hö�H��WH��� � ߿� :I+� pH� �I�+� pH� �+-� 3+� �*� �2� � W+�� 3+� �*� �2� � W+�� 3+� �*� �2X� � W+�� 3+� p��� �� �:JJ
� �J� �J� �WJ� �� � ߿� :K+� pJ� �K�+� pJ� �+-� 3� �+� 7*� �2� � � �� � � �+�� 3+� �*� �2� � W+�� 3+� �*� �2� � W+�� 3+� �*� �2X� � W+�� 3+� p��� �� �:LL
� �L� �L� �WL� �� � ߿� :M+� pL� �M�+� pL� �+�� 3� +-� 3� �+� 7*� �2� � � �� � � �+�� 3+� �*� �2� � W+�� 3+� �*� �2� � W+�� 3+� �*� �2X� � W+�� 3+� p��� �� �:NN
� �N� �N� �WN� �� � ߿� :O+� pN� �O�+� pN� �+�� 3� +-� 3�-+� 7*� �2� � �� �� � ��+�� 3+� �+� p��� �� �:PP�� �P+� 7� =� � � �P� �6QQ� O+PQ� �+�� 3P� ���� $:RPR�� :SQ� +�WP�
S�Q� +�WP�
P�� � ߿� :T+� pP� �T�+� pP� � :U+�U�+�+-� 3+� p��� ���:VV��V���V���V+++� 7*� �2� ��J�,����V��V��WV��� � ߿� :W+� pV� �W�+� pV� �+-� 3+� �*� �2� � W+�� 3+� �*� �2� � W+�� 3+� �*� �2X� � W+�� 3+� p��� �� �:XX
� �X� �X� �WX� �� � ߿� :Y+� pX� �Y�+� pX� �+-� 3�+� 7*� �2� � t� �� � ��+�� 3+� �+� p��� �� �:ZZ�� �Z+� 7� =� � � �Z� �6[[� O+Z[� �+�� 3Z� ���� $:\Z\�� :][� +�WZ�
]�[� +�WZ�
Z�� � ߿� :^+� pZ� �^�+� pZ� � :_+�_�+�+i� 3+� p��� ���:``��`���`���`+++� 7*� �2� ��J�,����`��`��W`��� � ߿� :a+� p`� �a�+� p`� �+-� 3+� �*� �2� � W+�� 3+� �*� �2� � W+�� 3+� �*� �2X� � W+�� 3+� p��� �� �:bb
� �b� �b� �Wb� �� � ߿� :c+� pb� �c�+� pb� �+-� 3� +-� 3� �++� 7*� �2� � �ș � � �+z� 3+� �*� �2� � W+�� 3+� �*� �2� � W+�� 3+� �*� �2X� � W+�� 3+� p��� �� �:dd
� �d� �d� �Wd� �� � ߿� :e+� pd� �e�+� pd� �+-� 3� +i� 3� +�� 3� +� 3� +� 3� +� 3+� 3+� 3+� 3+ � 3+"� 3+$� 3+&� 3+� �+(� 3++� 7*� �2� � �,� 3+*� 3� :f+�f�+�+,� 3+.� 3+� 7*� �2++��0�ܹ E W+�� 3+� �+� p��� �� �:gg2� �g+� 7� =� � � �g� �6hh� O+gh� �+4� 3g� ���� $:igi�� :jh� +�Wg�
j�h� +�Wg�
g�� � ߿� :k+� pg� �k�+� pg� � :l+�l�+�+�� 3+� �+� p��� �� �:mm6� �m+� 7� =� � � �m� �6nn� O+mn� �+8� 3m� ���� $:omo�� :pn� +�Wm�
p�n� +�Wm�
m�� � ߿� :q+� pm� �q�+� pm� � :r+�r�+�+�� 3+� �+:� 3+++� 7*� � 2� ��J�,� 3+<� 3+++� 7*� �!2� ��J�,� 3+>� 3++� 7*� �2� � �,� 3+@� 3� :s+�s�+�+B� 3� 5���  |�� )|��  O��  >��  Ptt  \�� )\��  .��  ��  ���  	2	V	V  

3
3  
�
�
�  
�**  Z��  ���  T��  ���  ���  ���  ��� )���  �  r    F��  ���  s��  ;``  33  ��� )���  �  �55  [��  +PP  ��� )���  �00  �JJ  q��  Aff  66  ���  `ps )`|  2��  !��  %58 )%AD  �zz  ���  �   �         * +  �  � �         $  % ! 3 y 4 � 5 � 6 � 7 � 9M :t ;� <� > ?+ @P AY C| E� F� G I7 K M� O# P< Q� R� T� U W` Z~ [� ]� _$ aO b� c� e g> i� j� k	 nI p� r� t� u	 v	q y	� z	� {	� |
M ~
x 
� �
� �
� �
� �
� �D �� �� � �R �� �� �� � � � �! �> �� � �L �t �� � �. �P �r �� �E �k �� �0 �V �^ �� �� �� �� � � � �- �G �_ �� �� �� � �' �z �� �� �� �� �� �M �V �� �� �E �k �s �� �� �� �� �� � �j �� �� �[ �� �� �� �� �� �� � �- �� �� �� �� �� �� �P �Z �c �m �s �w �} �� ����+�,�9�:�H�U�i�k�m���d���)�����.��     ) CD �        �    �     ) EF �         �    �     ) GH �        �    �    J    �  b    V*"� �Y��YSY[�YSY��YSY]�YSY_�YSYa�YSYc�YSYe�YSYg�YSY	i�YSY
k�YSYm�YSYo�YSYq�YSYs�YSYu�YSYw�YSYy�YSY{�YSY}�YSY�YSY��YSY��YSY��YSY��YSY��YSY��YSY��YSY��YSY��YSY��YSY��YSY ��YSY!��YS� ��     �    