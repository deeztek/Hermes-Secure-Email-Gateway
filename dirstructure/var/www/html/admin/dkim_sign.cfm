����   2� E__138/__138/publish/hermes_seg_18_041454/proprietary/dkim_sign_cfm$cf  lucee/runtime/PageImpl  8../../publish/hermes-seg-18.04/proprietary/dkim_sign.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ��� getSourceLength      *y getCompileTime  �\��� getHash ()I�8 call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this GL__138/__138/publish/hermes_seg_18_041454/proprietary/dkim_sign_cfm$cf; m2 , &lucee/runtime/config/NullSupportHelper . NULL 0 '
 / 1 -lucee/runtime/interpreter/VariableInterpreter 3 getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; 5 6
 4 7 0 9 %lucee/runtime/exp/ExpressionException ; java/lang/StringBuilder = The required parameter [ ? (Ljava/lang/String;)V  A
 > B append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; D E
 > F ] was not provided. H -(Ljava/lang/String;)Ljava/lang/StringBuilder; D J
 > K toString ()Ljava/lang/String; M N
 > O
 < B lucee/runtime/PageContextImpl R any T�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V X Y
 S Z 
 \ lucee/runtime/PageContext ^ write ` A
 _ a step c error e success g 

 i m1 k  
 m@       keys $[Llucee/runtime/type/Collection$Key; q r	  s !lucee/runtime/type/Collection$Key u *lucee/runtime/functions/decision/IsDefined w B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & y
 x z True | lucee/runtime/op/Operator ~ compare (ZLjava/lang/String;)I � �
  � urlScope  ()Llucee/runtime/type/scope/URL; � �
 _ � lucee/runtime/type/scope/URL � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � �   � '(Ljava/lang/Object;Ljava/lang/String;)I � �
  � us &()Llucee/runtime/type/scope/Undefined; � �
 _ � "lucee/runtime/type/scope/Undefined � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � �  

 � domain_entry �@       	formScope !()Llucee/runtime/type/scope/Form; � �
 _ � lucee/runtime/type/scope/Form � � � 	show_type � ip � $lucee/runtime/type/util/KeyConstants � _type #Llucee/runtime/type/Collection$Key; � �	 � � _TYPE � �	 � � octet1 � octet2 � octet3 � octet4 � domain � _domain � �	 � � 	host_name � host_domain � 


 � action � _action � �	 � � _ACTION � �	 � � � � 	canceladd � outputStart � 
 _ � lucee.runtime.tag.Query � cfquery � 8C:\publish\hermes-seg-18.04\proprietary\dkim_sign.cfm:74 � use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; � �
 S � lucee/runtime/tag/Query � hasBody (Z)V � �
 � � canceldelete � setName � A
 � � _DATASOURCE � �	 � � setDatasource (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 _ � B
delete from domains_temp where action='insert' and applied='2'
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V 
 � popBody ()Ljavax/servlet/jsp/JspWriter;
 _ 	doFinally 
 �	 doEndTag $
 � lucee/runtime/exp/Abort newInstance (I)Llucee/runtime/exp/Abort;
 reuse !(Ljavax/servlet/jsp/tagext/Tag;)V
 S 	outputEnd 
 _ #lucee/commons/color/ConstantsDouble _0 Ljava/lang/Double;	 _12!	" 8C:\publish\hermes-seg-18.04\proprietary\dkim_sign.cfm:80$ B
delete from domains_temp where action='delete' and applied='2'
& _5(	)0


<script>

/*
Auto tabbing script- By JavaScriptKit.com
http://www.javascriptkit.com
This credit MUST stay intact for use
*/

function autotab(original,destination){
if (original.getAttribute&&original.value.length==original.getAttribute("maxlength"))
destination.focus()
}

</script>

 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>DKIM Sign</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
+ hermes-

<script language="JavaScript">
<!--

// function to load the calendar window.
function ShowCalendar(FormName, FieldName) {
  window.open("calendar.cfm?FormName=" + FormName + "&FieldName=" + FieldName, "CalendarWindow", "width=500,height=300");
}

//-->
</script>

<script type="text/javascript" language="javascript">// <![CDATA[
function checkAll(formname, checktoggle)
{
  var checkboxes = new Array();
  checkboxes = document[formname].getElementsByTagName('input');
 
  for (var i=0; i<checkboxes.length; i++)  {
    if (checkboxes[i].type == 'checkbox')   {
      checkboxes[i].checked = checktoggle;
    }
  }
}
// ]]></script>


<style type="text/css">
table.bottomBorder { border-collapse:collapse; }
table.bottomBorder td, table.bottomBorder th { border-bottom:1px dotted black;padding:5px; }
</style>

<link rel="stylesheet" type="text/css" href="./fusion.css">
<link rel="stylesheet" type="text/css" href="./style.css">
<link rel="stylesheet" type="text/css" href="./site.css">
/,</head>
<body style="background-color: rgb(192,192,192); background-attachment: scroll; margin: 0px;" class="nof-centerBody">
<!-- DO NOT MOVE! The following AllWebMenus linking code section must always be placed right AFTER the BODY tag-->
<!-- ******** BEGIN ALLWEBMENUS CODE FOR hermes_seg_menu2 ******** -->
<script type='text/javascript'>var MenuLinkedBy='AllWebMenus [2]',awmMenuName='hermes_seg_menu2',awmBN='FUS';awmAltUrl='';</script><script charset='UTF-8' src='./hermes_seg_menu2.js' language='JavaScript1.2' type='text/javascript'></script><script type='text/javascript'>awmBuildMenu();</script>
<!-- ******** END ALLWEBMENUS CODE FOR hermes_seg_menu2 ******** -->
  <div align="center">
    <table border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="988">
            <tr valign="top" align="left">
              <td height="10"></td>
            </tr>
            <tr valign="top" align="left">
              <td height="131" width="988">
                1<table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion32" style="background-image: url('./top_blue_3.png'); height: 131px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="709">
                        <tr valign="top" align="left">
                          <td width="45" height="92"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="13"></td>
                          <td width="664"><!--<img id="AllWebMenusComponent1" height="13" width="664" src="./Fusion_placeholder_1.gif" border="0"> AllWebMenusTag='hermes_seg_menu2.js' AWMJSPATH='./hermes_seg_menu2.js' AWMIMGPATH=''--> <span id='awmAnchor-hermes_seg_menu2'>&nbsp;</span></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                3 �</table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="519" width="988">5@       sessionScope $()Llucee/runtime/type/scope/Session;9:
 _;  lucee/runtime/type/scope/Session=> � 	VIOLATION@ lucee.runtime.tag.LocationB 
cflocationD 9C:\publish\hermes-seg-18.04\proprietary\dkim_sign.cfm:192F lucee/runtime/tag/LocationH license_invalid.cfmJ setUrlL A
IM setAddtokenO �
IP
I �
I NEWT 9C:\publish\hermes-seg-18.04\proprietary\dkim_sign.cfm:194V mX _mZ �	 �[ _M] �	 �^#

                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion29" style="background-image: url('./middle_988.png'); height: 519px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="981">
                        <tr valign="top" align="left">
                          <td width="17" height="11"></td>
                          <td width="1"></td>
                          <td width="404"></td>
                          <td width="559"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td width="404" id="Text291" class="TextObject">` �
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">DKIM Sign</span></b></p>
                            b</td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="4" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="3" width="964" id="Text498" class="TextObject" style="background-color: rgb(102,153,51); border: 1px solid rgb(255,0,0);">
                            <p style="margin-bottom: 0px;"><b><span style="color: rgb(255,255,255);">This page has been upgraded to our new 2.0 interface. Please click <a href="/admin/2/view_domains.cfm">here</a> to use the new version</span></b></p>
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
                d�<table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion24" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="981">
                        <tr valign="top" align="left">
                          <td width="981" height="12"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;">f $lucee/runtime/functions/dateTime/Nowh =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &j
ik yyyym 4lucee/runtime/functions/displayFormatting/DateFormato S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &q
pr 9C:\publish\hermes-seg-18.04\proprietary\dkim_sign.cfm:248t 
getversionv D
SELECT value from system_settings where parameter = 'version_no'
x 9C:\publish\hermes-seg-18.04\proprietary\dkim_sign.cfm:251z getbuild| B
SELECT value from system_settings where parameter = 'build_no'
~ V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway � lucee/runtime/op/Caster� &(Ljava/lang/Object;)Ljava/lang/String; M�
�� 	 Version:� getCollection� � �� _VALUE� �	 �� I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; ��
 _�  Build:� . Copyright 2011-� l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>�A&nbsp;</p>
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
 ����� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� M1� relay_domain� RELAY_DOMAIN� DOMAIN_ENTRY� 	SHOW_TYPE� OCTET1� OCTET2� OCTET3� OCTET4� DOMAIN� 	HOST_NAME� HOST_DOMAIN� STEP� M2� license� LICENSE� THEYEAR� EDITION� 
GETVERSION� GETBUILD� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             q r   ��       �   *     *� 
*� *� � *����*+���        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  �  P  :+-+� 2� 8M>+� 2,� .:Y:� !� <Y� >Y@� C-� GI� L� P� Q�M>+� SU-, V V� [+]� b+d+� 2� 8:6+� 2� 0:Y:� !� <Y� >Y@� Cd� GI� L� P� Q�:6+� SUd V V� [+]� b+f+� 2� 8:6	+� 2� 0:Y:
� !� <Y� >Y@� Cf� GI� L� P� Q�
:6	+� SUf V V	� [+]� b+h+� 2� 8:6+� 2� 0:Y:� !� <Y� >Y@� Ch� GI� L� P� Q�:6+� SUh V V� [+j� b+l+� 2� 8:6+� 2� 0:Y:� !� <Y� >Y@� Cl� GI� L� P� Q�:6+� SUl V V� [+n� b+ o*� t2� v� {}� �� � � Z+]� b+� �*� t2� � �� �� � � 1+]� b+� �*� t2+� �*� t2� � � � W+]� b� � +�� b+�+� 2� 8:6+� 2� 0�Y:� !� <Y� >Y@� C�� GI� L� P� Q�:6+� SU� V V� [+n� b+ �*� t2� v� {}� �� � � Z+]� b+� �*� t2� � �� �� � � 1+]� b+� �*� t2+� �*� t2� � � � W+]� b� � +�� b+�+� 2� 8:6+� 2� 0�Y:� !� <Y� >Y@� C�� GI� L� P� Q�:6+� SU� V V� [+n� b+ o� �� v� {}� �� � � T+]� b+� �� �� � �� �� � � .+]� b+� �*� t2+� �� �� � � � W+]� b� � +�� b+�+� 2� 8:6+� 2� 0�Y:� !� <Y� >Y@� C�� GI� L� P� Q�:6+� SU� V V� [+n� b+ �*� t2� v� {}� �� � � ]+]� b+� �*� t2� � �� �� � � 3+]� b+� �*� t2+� �*� t2� � � � W+]� b� � +�� b+�+� 2� 8:6+� 2� 0�Y:� !� <Y� >Y@� C�� GI� L� P� Q�:6+� SU� V V� [+n� b+ �*� t2� v� {}� �� � � ]+]� b+� �*� t	2� � �� �� � � 3+]� b+� �*� t	2+� �*� t	2� � � � W+]� b� � +�� b+�+� 2� 8:6+� 2� 0�Y:� !� <Y� >Y@� C�� GI� L� P� Q�:6+� SU� V V� [+n� b+ �*� t
2� v� {}� �� � � ]+]� b+� �*� t2� � �� �� � � 3+]� b+� �*� t2+� �*� t2� � � � W+]� b� � +�� b+�+� 2� 8: 6!+� 2 � 0�Y:"� !� <Y� >Y@� C�� GI� L� P� Q�": 6!+� SU�  V V!� [+n� b+ �*� t2� v� {}� �� � � ]+]� b+� �*� t2� � �� �� � � 3+]� b+� �*� t2+� �*� t2� � � � W+]� b� � +�� b+�+� 2� 8:#6$+� 2#� 0�Y:%� !� <Y� >Y@� C�� GI� L� P� Q�%:#6$+� SU�# V V$� [+n� b+ �� �� v� {}� �� � � ]+]� b+� �*� t2� � �� �� � � 3+]� b+� �*� t2+� �*� t2� � � � W+]� b� � +�� b+�+� 2� 8:&6'+� 2&� 0�Y:(� !� <Y� >Y@� CŶ GI� L� P� Q�(:&6'+� SU�& V V'� [+n� b+ �*� t2� v� {}� �� � � ]+]� b+� �*� t2� � �� �� � � 3+]� b+� �*� t2+� �*� t2� � � � W+]� b� � +�� b+�+� 2� 8:)6*+� 2)� 0�Y:+� !� <Y� >Y@� CǶ GI� L� P� Q�+:)6*+� SU�) V V*� [+n� b+ �*� t2� v� {}� �� � � ]+]� b+� �*� t2� � �� �� � � 3+]� b+� �*� t2+� �*� t2� � � � W+]� b� � +ɶ b+�+� 2� 8:,6-+� 2,� 0�Y:.� !� <Y� >Y@� C˶ GI� L� P� Q�.:,6-+� SU�, V V-� [+n� b+ o� �� v� {}� �� � � Q+]� b+� �� ѹ � �� �� � � ++]� b+� �� �+� �� ѹ � � � W+]� b� � +�� b+� �� ѹ � Ը �� � �+]� b+� �+� S��ݶ �� �://� �/� �/+� �� � � � �/� �600� N+/0� �+�� b/� ����� $:1/1�� :20� +�W/�
2�0� +�W/�
/�� ��� :3+� S/�3�+� S/�� :4+�4�+�+]� b+� �*� t2� � � W+]� b+� �*� t2�#� � W+]� b�)+� �� ѹ � � �� � �+]� b+� �+� S��%� �� �:55� �5� �5+� �� � � � �5� �666� O+56� �+'� b5� ���� $:757�� :86� +�W5�
8�6� +�W5�
5�� ��� :9+� S5�9�+� S5�� ::+�:�+�+]� b+� �*� t2� � � W+]� b+� �*� t2�*� � W+]� b� +,� b+� �� �.� � W+0� b+2� b+4� b+6� b+7*� t2� v� {�+]� b+�<*� t2�? A� �� � � d+]� b+� SCEG� ��I:;;K�N;�Q;�RW;�S� ��� :<+� S;�<�+� S;�+]� b� �+�<*� t2�? U� �� � � d+]� b+� SCEW� ��I:==K�N=�Q=�RW=�S� ��� :>+� S=�>�+� S=�+]� b� +]� b� +j� b+Y+� 2� 8:?6@+� 2?� 1:Y:A� "� <Y� >Y@� CY� GI� L� P� Q�A:?6@+� SUY? V V@� [+]� b+ o�\� v� {}� �� � � Q+]� b+� ��_� � �� �� � � ++]� b+� ��_+� ��_� � � � W+]� b� � +a� b+� �+c� b� :B+�B�+�+e� b+g� b+� �*� t2++�ln�s� � W+]� b+� �+� S��u� �� �:CC� �Cw� �C+� �� � � � �C� �6DD� O+CD� �+y� bC� ���� $:ECE�� :FD� +�WC�
F�D� +�WC�
C�� ��� :G+� SC�G�+� SC�� :H+�H�+�+]� b+� �+� S��{� �� �:II� �I}� �I+� �� � � � �I� �6JJ� O+IJ� �+� bI� ���� $:KIK�� :LJ� +�WI�
L�J� +�WI�
I�� ��� :M+� SI�M�+� SI�� :N+�N�+�+]� b+� �+�� b++�<*� t2�? ��� b+�� b+++� �*� t2�� ������� b+�� b+++� �*� t2�� ������� b+�� b++� �*� t2� � ��� b+�� b� :O+�O�+�+�� b� ��� )���  ^��  K��  ��� )���  �  p&&  �  }��  ���  @PS )@\_  ��  ���  ! )*-  �cc  �}}  �$$   �         * +  �  � d    X  �  ~ �  - 	R 
^ � �  2 > � � � 	  w � � � � [ �  � !� "� $? %g &� '� (� *# +K ,r -� .� 0 1+ 2R 3y 4� 6� 7	 8	6 9	] :	i <	� =	� >
 ?
A @
M C
� D
� E
� F G! ID J� L M) NC Oi P� R6 SP Ti Us Xv w� y� �� �� �� �� �9 �d �� �� �� �3 �W �z �� �� �� �� �� �� �� �� �� �D �� � �� �� ��     ) �� �        �    �     ) �� �         �    �     ) �� �        �    �    �    �      *� vYl��SY���SY���SY���SY���SY���SY���SY���SY���SY	���SY
���SY���SY���SY¸�SYĸ�SYŸ�SYƸ�SYǸ�SYȸ�SYʸ�SY̸�SYθ�SYи�SYҸ�SYԸ�SYָ�SYظ�S� t�     �    