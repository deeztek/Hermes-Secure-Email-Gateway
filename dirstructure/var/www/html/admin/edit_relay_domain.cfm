����   2� edit_relay_domain_cfm$cf  lucee/runtime/PageImpl  /admin/edit_relay_domain.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  n�  getSourceLength      �� getCompileTime  n��� getHash ()I��6 call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Ledit_relay_domain_cfm$cf; action , &lucee/runtime/config/NullSupportHelper . NULL 0 '
 / 1 -lucee/runtime/interpreter/VariableInterpreter 3 getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; 5 6
 4 7   9 %lucee/runtime/exp/ExpressionException ; java/lang/StringBuilder = The required parameter [ ? (Ljava/lang/String;)V  A
 > B append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; D E
 > F ] was not provided. H -(Ljava/lang/String;)Ljava/lang/StringBuilder; D J
 > K toString ()Ljava/lang/String; M N
 > O
 < B lucee/runtime/PageContextImpl R any T�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V X Y
 S Z  
 \ lucee/runtime/PageContext ^ write ` A
 _ a@       $lucee/runtime/type/util/KeyConstants e _action #Llucee/runtime/type/Collection$Key; g h	 f i !lucee/runtime/type/Collection$Key k *lucee/runtime/functions/decision/IsDefined m B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & o
 n p True r lucee/runtime/op/Operator t compare (ZLjava/lang/String;)I v w
 u x 
 z urlScope  ()Llucee/runtime/type/scope/URL; | }
 _ ~ _ACTION � h	 f � lucee/runtime/type/scope/URL � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � '(Ljava/lang/Object;Ljava/lang/String;)I v �
 u � us &()Llucee/runtime/type/scope/Undefined; � �
 _ � "lucee/runtime/type/scope/Undefined � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � �  


 � keys $[Llucee/runtime/type/Collection$Key; � �	  � [^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ � 

 � m1 � 0 � m2 � step � error � success � domain �@       _domain � h	 f � 	formScope !()Llucee/runtime/type/scope/Form; � �
 _ � lucee/runtime/type/scope/Form � � �  

 � id � _id � h	 f � _ID � h	 f � 	show_type � ip � _type � h	 f � _TYPE � h	 f � 	mx_lookup � � � host � .
<!-- /CFIF IsDefined("form.mx_lookup") -->
 � 
<!-- /CFIF show_type -->
 � 
ip_address � port � 25 � _port � h	 f � 	host_name � host_domain �9
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
<title>Edit Relay Domain</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="Generator" content="NetObjects (http://netobjects.com)">
 � _DATASOURCE � h	 f � hermes �

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
 �</head>
<body style="background-color: rgb(192,192,192); background-repeat: repeat; background-attachment: scroll; margin: 0px;" class="nof-centerBody">
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
               � <td height="131" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion34" style="background-image: url('./top_blue_3.png'); height: 131px;">
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
                     �</td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="506" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion30" style="background-image: url('./middle_988.png'); height: 506px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="16" height="16"></td>
                          <td width="1"></td>
                          <td width="1"></td>
                          <td width="330"></td>
                          <td width="2"></td>
                          <td width="174"></td>
                          <td width="100"></td>
                          <td width="188"></td>
                          <td width="125"></td>
                           �v<td width="30"></td>
                          <td width="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td colspan="3" width="506" id="Text351" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 16px; color: rgb(0,51,153);">Edit Existing Relay Domain Mapping</span></b></p>
                          </td>
                          <td colspan="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="11" height="5"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2"></td>
                          <td colspan="6" width="795" id="Text273" class="TextObject">
                            <p style="margin-bottom: 0px;"><span style="font-size: 12px; color: rgb(128,128,128);">Select the type of Destination you are adding and then fill out the corresponding information in the fields below. � </span></p>
                          </td>
                          <td colspan="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="11" height="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td height="38"></td>
                          <td colspan="6" width="608">
                            <table border="0" cellspacing="0" cellpadding="0">
                              <tr valign="top" align="left">
                                <td width="487">
                                  <table id="Table92" border="0" cellspacing="0" cellpadding="0" width="487" style="height: 34px;">
                                    <tr style="height: 19px;">
                                      <form name="LayoutRegion8FORM" action="edit_relay_domain.cfm?type=ip" method="post">
                                      <td width="58" id="Cell524">
                                         �<table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                          <tr>
                                            <td class="TextObject">
                                              <p style="margin-bottom: 0px;"> � outputStart � 
 _ � ,
<input type="hidden" name="domain" value=" � lucee/runtime/op/Caster � &(Ljava/lang/Object;)Ljava/lang/String; M 
 � *">
<input type="hidden" name="id" value=" �">
<input type="radio" name="type" value="ip" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
 	outputEnd 
 _ t">
<input type="radio" name="type" value="ip" style="height: 19px; width: 19px;" onclick="this.form.submit();" />

@


&nbsp;</p>
                                            </td>
                                          </tr>
                                        </table>
                                        &nbsp;</td>
                                      </form>
                                      <td width="429" id="Cell525">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px;">IP Address Destination</span></p>
                                      </td>
                                    </tr>
                                    <tr style="height: 19px;">
                                      <form name="LayoutRegion8FORM" action="edit_relay_domain.cfm?type=host" method="post">
                                      <td id="Cell526">
                                        <table width="42" border="0" cellspacing="0" cellpadding="0" align="left">
                                          <tr>
                                            <td class="TextObject">
                                               <p style="margin-bottom: 0px;"> �">
<input type="radio" name="type" value="host" checked="checked" style="height: 19px; width: 19px;" onclick="this.form.submit();" />
 v">
<input type="radio" name="type" value="host" style="height: 19px; width: 19px;" onclick="this.form.submit();" />



&nbsp;</p>
                                            </td>
                                          </tr>
                                        </table>
                                        &nbsp;</td>
                                      </form>
                                      <td id="Cell527">
                                        <p style="margin-bottom: 0px;"><span style="font-size: 12px;">Host Name Destination</span></p>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                          <td colspan="4"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="11" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3" height="30"></td>
                          <td colspan="8" valign="middle" width="951"><hr id="HRRule17" width="951" size="1"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="11" height="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="3"></td>
                          <td colspan="2" width="332" id="Text369" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">IP Address Destination</span></b></p>
                          </td>
                          <td colspan="6"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="11" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="2" height="43"> =</td>
                          <td colspan="7" width="920"> add 


 %lucee/runtime/functions/string/REFind S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object; & 
! (Ljava/lang/Object;D)I v#
 u$ #lucee/commons/color/ConstantsDouble& _1 Ljava/lang/Double;()	'* _0,)	'- _3/)	'0 _52)	'3 15 float7 (lucee/runtime/functions/decision/IsValid9 B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &;
:< _2>)	'? _13A)	'B -
<!-- /CFIF for IsValid("float", port) -->
D _14F)	'G )

<!-- /CFIF for #port# is not "" -->
I 

<!-- /CFIF for step 1 -->
K 



M 2O 


<!-- START -->

Q lucee.runtime.tag.QueryS cfqueryU use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag;WX
 SY lucee/runtime/tag/Query[ customtrans] setName_ A
\` setDatasource (Ljava/lang/Object;)Vbc
\d getrandom_resultsf 	setResulth A
\i 
doStartTagk $
\l initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)Vno
 _p Q
select random_letter as random from captcha_list_all2 order by RAND() limit 8
r doAfterBodyt $
\u doCatch (Ljava/lang/Throwable;)Vwx
\y popBody ()Ljavax/servlet/jsp/JspWriter;{|
 _} 	doFinally 
\� doEndTag� $
\� lucee/runtime/exp/Abort� newInstance (I)Llucee/runtime/exp/Abort;��
�� reuse !(Ljavax/servlet/jsp/tagext/Tag;)V��
 S� inserttrans� stResult� &
insert into salt
(salt)
values
('� getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;��
 _� getId� $
 _� lucee/runtime/type/Query� getCurrentrow (I)I���� getRecordcount� $�� !lucee/runtime/util/NumberIterator� load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� �� isValid (I)Z��
�� current� $
�� go (II)Z���� #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� writePSQ�c
 _� removeQuery�  �� release &(Llucee/runtime/util/NumberIterator;)V��
�� ')
� gettrans� 2
select salt as customtrans2 from salt where id='� getCollection� � �� I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; ��
 _� '
� deletetrans� 
delete from salt where id='� 
getotherid� X
select domain, transport_id, senders_id, recipients_id, domain from domains where id='� edit� *
update transport set transport = 'smtp:[� ]:� ', destination = '� ', port = '� ', mx = 'NO' where id = '� 
getdomains� 
select * from domains
� java/lang/String� concat &(Ljava/lang/String;)Ljava/lang/String;��
��@*       "lucee/runtime/functions/string/Chr� 0(Llucee/runtime/PageContext;D)Ljava/lang/String; &�
��@$       lucee.runtime.tag.FileTag� cffile  lucee/runtime/tag/FileTag hasBody (Z)V
 ` 	setAction	 A

 /etc/postfix/relay_domains setFile A
 	setOutputc
 setAddnewline

l
� gettransports 
select * from transport
@"       /etc/postfix/transport /opt/hermes/tmp/! _postmap.sh# (/usr/sbin/postmap /etc/postfix/transport% lucee.runtime.tag.Execute' 	cfexecute) lucee/runtime/tag/Execute+ 
/bin/chmod-
,` +x /opt/hermes/tmp/0 setArguments2c
,3@N       
setTimeout (D)V78
,9
,l
,u
,�@n       	/dev/null@ setOutputfileB A
,C -inputformat noneE deleteG /etc/init.d/postfixI stopK /etc/init.d/amavisM 	dropusersO 
drop table users
Q createusersS &
CREATE TABLE users LIKE recipients
U 	copyusersW .
INSERT INTO users SELECT * FROM recipients
Y 
alterusers[ ;
alter table users change recipient email VARBINARY(255)
] start_ 

<!-- END -->


a lucee.runtime.tag.Locationc 
cflocatione lucee/runtime/tag/Locationg relay_domains_new.cfm?m1=8i setUrlk A
hl
hl
h� 





p �




                            <form name="ipaddress" action="edit_relay_domain.cfm?action=add&type=ip" method="post">
                              <input type="hidden" name="id" value="r ,"><input type="hidden" name="domain" value="t �">
                              <table border="0" cellspacing="0" cellpadding="0">
                                <tr valign="top" align="left">
                                  <td width="888">v

                                    <table id="Table101" border="0" cellspacing="0" cellpadding="0" width="890" style="height: 41px;">
                                      <tr style="height: 17px;">
                                        <td width="208" id="Cell1041">
                                          <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Relay Domain</span></p>
                                        </td>
                                        <td width="209" id="Cell1042">
                                          <p style="text-align: left; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">IP</span></p>
                                        </td>
                                        <td width="190" id="Cell1049">
                                          <p style="text-align: left; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Port</span></p>
                                        x�</td>
                                        <td width="281" id="Cell1035">
                                          <p style="text-align: center; margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                      </tr>
                                      <tr style="height: 24px;">
                                        <td id="Cell1050">
                                          <table width="200" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;">z *
<input type="text" name="domain" value="| 2" size="30" maxlength="75"  disabled="disabled">
~ 1" size="30" maxlength="75" disabled="disabled">
�R&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell1051">
                                          <table width="201" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;">� G
<input type="text" name="ip_address" size="30" maxlength="45" value="� ">
� " disabled="disabled">
�T
&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell1058">
                                          <table width="181" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;">� @
<input type="text" name="port" size="30" maxlength="7" value="�U

&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell1036">
                                          <table width="46" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;">� &
<input type="submit" value="Edit">
�X
&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                    �</td>
                                </tr>
                              </table>
                            </form>
                          </td>
                          <td colspan="2"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="11" height="13"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td colspan="3" width="332" id="Text377" class="TextObject">
                            <p style="margin-bottom: 0px;"><b><span style="font-size: 12px;">Host Name Destination</span></b></p>
                          </td>
                          <td colspan="7"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td colspan="11" height="3"></td>
                        </tr>
                        <tr valign="top" align="left">
                          � M<td height="43"></td>
                          <td colspan="9" width="951">� _7�)	'� [^_a-zA-Z0-9-]� _8�)	'� _9�)	'� bob@� email� _10�)	'� 3� _4�)	'� '
<!-- /CFIF for #port# is not "" -->
� 
<!-- /CFIF for step 3 -->
� 4� 



<!-- START -->

� .� )
update transport set transport = 'smtp:� :� ', mx = 'YES'
 where id = '� $

<!-- /CFIF mx_lookup is "" -->
� 


<!-- END -->


� �




                            <form name="host" action="edit_relay_domain.cfm?action=add&type=host" method="post">
                              <input type="hidden" name="id" value="� �">
                              <table border="0" cellspacing="0" cellpadding="0">
                                <tr valign="top" align="left">
                                  <td width="939">�4
                                    <table id="Table102" border="0" cellspacing="0" cellpadding="0" width="940" style="height: 41px;">
                                      <tr style="height: 17px;">
                                        <td width="182" id="Cell1059">
                                          <p style="margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Relay Domain</span></p>
                                        </td>
                                        <td width="182" id="Cell1060">
                                          <p style="text-align: left; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Host</span></p>
                                        </td>
                                        <td width="6" id="Cell1061">
                                          <p style="margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                        <td width="182" id="Cell1062">
                                          �<p style="text-align: left; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Domain</span></p>
                                        </td>
                                        <td width="182" id="Cell1037">
                                          <p style="text-align: left; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">Port</span></p>
                                        </td>
                                        <td width="107" id="Cell1039">
                                          <p style="text-align: left; margin-bottom: 0px;"><span style="font-size: 10px; color: rgb(128,128,128);">MX Lookup</span></p>
                                        </td>
                                        <td width="98" id="Cell1063">
                                          <p style="margin-bottom: 0px;">&nbsp;</p>
                                        </td>
                                      </tr>
                                      ��<tr style="height: 24px;">
                                        <td id="Cell1064">
                                          <table width="170" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;">� 2" size="20" maxlength="75"  disabled="disabled">
� 1" size="20" maxlength="75" disabled="disabled">
�R&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell1065">
                                          <table width="170" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;">� -
<input type="text" name="host_name" value="� " size="20" maxlength="50">
� 1" size="20" maxlength="50" disabled="disabled">
�L&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell1066">
                                          <p style="text-align: left; margin-bottom: 0px;"><b><span style="font-size: 20px;">.</span></b></p>
                                        </td>
                                        <td id="Cell1067">
                                          <table width="170" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;">� /
<input type="text" name="host_domain" value="�R&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell1038">
                                          <table width="170" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;">� @
<input type="text" name="port" size="20" maxlength="7" value="�U

&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell1040">
                                          <table width="90" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;">� 8
<input type="checkbox" name="mx_lookup" value="yes">
� J
<input type="checkbox" name="mx_lookup" value="yes" checked="checked">
� L
<input type="checkbox" name="mx_lookup" value="yes" disabled="disabled">
�S
&nbsp;</p>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                        <td id="Cell1068">
                                          <table width="71" border="0" cellspacing="0" cellpadding="0" align="left">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="margin-bottom: 0px;">� m
<input type="submit" value="Edit" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
� �
<input type="submit" value="Edit" disabled="disabled" onclick="this.disabled=true;this.value='Wait...';this.form.submit();" >
��</td>
                                </tr>
                              </table>
                            </form>
                          </td>
                          <td></td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0" width="969">
                        <tr valign="top" align="left">
                          <td width="17" height="4"></td>
                          <td width="952"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="952" id="Text277" class="TextObject">
                            <p style="margin-bottom: 0px;">�c
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Relay Domain field cannot be empty</span></i></b></p>
�r
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Relay Domain you are attempting to add is invalid</span></i></b></p>
�z
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination IP address you attempting to add is not valid</span></i></b></p>
�v
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Relay Domain you are attempting to add already exists</span></i></b></p>
� 5�g
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination IP address cannot be empty</span></i></b></p>
� 6��
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Relay Domain & Destination ready to be added. Please click the Apply Settings to add the Relay Domain & Destination to the system and apply your changes</span></i></b></p>
� 7l
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination Host Name field cannot be empty</span></i></b></p>
 8{
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination Host Name you are attempting to add is invalid</span></i></b></p>
 9	n
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination Host Domain field cannot be empty</span></i></b></p>
 10}
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;the Destination Host Domain you are attempting to add is invalid</span></i></b></p>
 11�
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(255,0,0);"><img id="Picture37" height="14" width="15" src="warning_icon.png" vspace="0" hspace="0" align="top" border="0" alt="warning_icon" title="warning_icon">&nbsp;The Relay Domain & Destination you are attempting to add is already marked for addition</span></i></b></p>
 12r
<p style="margin-bottom: 0px;"><b><i><span style="font-family: Arial,Helvetica,Geneva,Sans-serif; font-size: 12px; color: rgb(16,174,75);"><img id="Picture37" height="14" width="15" src="checkmark_icon.png" vspace="0" hspace="0" align="top" border="0" alt="checkmark_icon" title="checkmark_icon">&nbsp;Success! All add requests have been cancelled</span></i></b></p>
9

&nbsp;</p>
                          </td>
                        </tr>
                      </table>
                      <table border="0" cellspacing="0" cellpadding="0">
                        <tr valign="top" align="left">
                          <td width="17" height="5"></td>
                          <td></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td></td>
                          <td width="951">
                            <form name="relay_domains" action=" relay_domains_new.cfm" method="post">
                              <table id="Table90" border="0" cellspacing="0" cellpadding="0" width="951" style="height: 24px;">
                                <tr style="height: 24px;">
                                  <td width="951" id="Cell518">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr>
                                        <td align="center">
                                          <table width="360" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td class="TextObject">
                                                <p style="text-align: center; margin-bottom: 0px;"><input type="submit" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();" name="FormsButton1" value="Back to Relay Domains" style="height: 24px; width: 357px;">
&nbsp;</p>
                                              "</td>
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
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr valign="top" align="left">
              <td height="49" width="988">
                <table border="0" cellspacing="0" cellpadding="0" width="988" id="LayoutRegion33" style="background-image: url('./bottom_988.png'); height: 49px;">
                  <tr align="left" valign="top">
                    <td>
                      <table border="0" cellspacing="0" cellpadding="0" width="981">
                        O<tr valign="top" align="left">
                          <td width="981" height="12"></td>
                        </tr>
                        <tr valign="top" align="left">
                          <td width="981" id="Text496" class="TextObject">
                            <p style="text-align: center; margin-bottom: 0px;">! $lucee/runtime/functions/dateTime/Now# =(Llucee/runtime/PageContext;)Llucee/runtime/type/dt/DateTime; &%
$& yyyy( 4lucee/runtime/functions/displayFormatting/DateFormat* S(Llucee/runtime/PageContext;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/String; &,
+- 
getversion/ D
SELECT value from system_settings where parameter = 'version_no'
1 getbuild3 B
SELECT value from system_settings where parameter = 'build_no'
5 V
<span style="font-size: 10px; color: rgb(255,255,255);">Hermes Secure Email Gateway 7 sessionScope $()Llucee/runtime/type/scope/Session;9:
 _;  lucee/runtime/type/scope/Session=> � 	 Version:@ _VALUEB h	 fC  Build:E . Copyright 2011-G l, Dionyssios Edwards. All Rights Reserved. Portions of this program are covered under AGPLv3 License </span>IC
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
 ����K udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageExceptionS  lucee/runtime/type/UDFPropertiesU udfs #[Llucee/runtime/type/UDFProperties;WX	 Y setPageSource[ 
 \ PATTERN^ lucee/runtime/type/KeyImpl` intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;bc
ad DOMAINf 	SHOW_TYPEh 	MX_LOOKUPj 
IP_ADDRESSl PORTn 	HOST_NAMEp HOST_DOMAINr STEPt M2v 
THEADDRESSx RANDOMz STRESULT| GENERATED_KEY~ CUSTOMTRANS3� GETTRANS� CUSTOMTRANS2� 
GETOTHERID� TRANSPORT_ID� 
FILEDOMAIN� 
GETDOMAINS� FILEDATA� GETTRANSPORTS� 	TRANSPORT� 
TEMP_EMAIL� THEYEAR� EDITION� 
GETVERSION� GETBUILD� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *�V�Z*+�]�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  ]c b  O�+-+� 2� 8M>+� 2,� .:Y:� !� <Y� >Y@� C-� GI� L� P� Q�M>+� SU-, V V� [+]� b+ c� j� l� qs� y� � � Q+{� b+� � �� � :� �� � � ++{� b+� �� �+� � �� � � � W+{� b� � +�� b+� �*� �2�� � W+�� b+�+� 2� 8:6+� 2� 0�Y:� !� <Y� >Y@� C�� GI� L� P� Q�:6+� SU� V V� [+{� b+�+� 2� 8:6	+� 2� 0�Y:
� !� <Y� >Y@� C�� GI� L� P� Q�
:6	+� SU� V V	� [+{� b+�+� 2� 8:6+� 2� 0�Y:� !� <Y� >Y@� C�� GI� L� P� Q�:6+� SU� V V� [+{� b+�+� 2� 8:6+� 2� 0�Y:� !� <Y� >Y@� C�� GI� L� P� Q�:6+� SU� V V� [+{� b+�+� 2� 8:6+� 2� 0�Y:� !� <Y� >Y@� C�� GI� L� P� Q�:6+� SU� V V� [+�� b+�+� 2� 8:6+� 2� 0:Y:� !� <Y� >Y@� C�� GI� L� P� Q�:6+� SU� V V� [+]� b+ �� �� l� qs� y� � � Z+{� b+� �*� �2� � :� �� � � 1+{� b+� �*� �2+� �*� �2� � � � W+{� b� � +�� b+�+� 2� 8:6+� 2� 0:Y:� !� <Y� >Y@� C�� GI� L� P� Q�:6+� SU� V V� [+]� b+ �� �� l� qs� y� � � Q+{� b+� �� ù � :� �� � � ++{� b+� �� �+� �� ù � � � W+{� b� � +�� b+�+� 2� 8:6+� 2� 0�Y:� !� <Y� >Y@� CŶ GI� L� P� Q�:6+� SU� V V� [+]� b+ c� �� l� qs� y� � � T+{� b+� � ͹ � :� �� � � .+{� b+� �*� �2+� � ͹ � � � W+{� b� � +�� b+�+� 2� 8:6+� 2� 0:Y:� !� <Y� >Y@� C϶ GI� L� P� Q�:6+� SU� V V� [+]� b+� �*� �2� � Ǹ �� � � $+{� b+� �*� �2:� � W+{� b� �+� �*� �2� � Ҹ �� � � �+{� b+ �*� �2� l� qs� y� � � `+{� b+� �*� �2� � :� �� � � 1+{� b+� �*� �2+� �*� �2� � � � W+{� b� +{� b� 	+Զ b+ֶ b� +�� b+�+� 2� 8: 6!+� 2 � 0:Y:"� !� <Y� >Y@� Cض GI� L� P� Q�": 6!+� SU�  V V!� [+]� b+ �*� �2� l� qs� y� � � ]+{� b+� �*� �2� � :� �� � � 3+{� b+� �*� �2+� �*� �2� � � � W+{� b� � +�� b+�+� 2� 8:#6$+� 2#� 0�Y:%� !� <Y� >Y@� Cڶ GI� L� P� Q�%:#6$+� SU�# V V$� [+]� b+ �� �� l� qs� y� � � ]+{� b+� �*� �2� � :� �� � � 3+{� b+� �*� �2+� �*� �2� � � � W+{� b� � +�� b+�+� 2� 8:&6'+� 2&� 0:Y:(� !� <Y� >Y@� C� GI� L� P� Q�(:&6'+� SU�& V V'� [+]� b+ �*� �2� l� qs� y� � � ]+{� b+� �*� �	2� � :� �� � � 3+{� b+� �*� �	2+� �*� �	2� � � � W+{� b� � +�� b+�+� 2� 8:)6*+� 2)� 0:Y:+� !� <Y� >Y@� C� GI� L� P� Q�+:)6*+� SU�) V V*� [+]� b+ �*� �
2� l� qs� y� � � ]+{� b+� �*� �2� � :� �� � � 3+{� b+� �*� �2+� �*� �2� � � � W+{� b� � +� b+� �� �� � W+� b+� b+� b+� b+�� b+�� b+�� b+� �*� �2� � Ǹ �� � � c+{� b+� �+�� b++� �*� �2� � �� b+� b++� �� ù � �� b+� b� :,+�	,�+�	+{� b� `+{� b+� �+�� b++� �*� �2� � �� b+� b++� �� ù � �� b+� b� :-+�	-�+�	+{� b+� b+� b+� �*� �2� � Ҹ �� � � c+{� b+� �+�� b++� �*� �2� � �� b+� b++� �� ù � �� b+� b� :.+�	.�+�	+{� b� `+{� b+� �+�� b++� �*� �2� � �� b+� b++� �� ù � �� b+� b� :/+�	/�+�	+{� b+� b+� b+� b+� �*� �2� � Ǹ �� � ��+{� b+� �� �� � � �� � ��+� b+� �*� �2� � :� �� � � �+{� b++� �*� �2� � �+� �*� �2� � ��"�%� � � &+{� b+� �*� �2�+� � W+{� b� >+{� b+� �*� �2�.� � W+{� b+� �*� �2�1� � W+� b+�� b� b+� �*� �2� � :� �� � � A+{� b+� �*� �2�.� � W+{� b+� �*� �2�4� � W+� b� +� b+� �*� �2� � 6� �� � �?+{� b+� �*� �2� � :� �� � � �+{� b+8+� �*� �2� � �=� &+{� b+� �*� �2�@� � W+{� b� c+8+� �*� �2� � �=� � � A+{� b+� �*� �2�.� � W+{� b+� �*� �2�C� � W+E� b� +{� b� b+� �*� �2� � :� �� � � A+{� b+� �*� �2�.� � W+{� b+� �*� �2�H� � W+J� b� +L� b� +N� b+� �*� �2� � P� �� � ��+{� b+� �*� �2+� �*� �2� � � � W+R� b+� �+� STV�Z�\:00^�a0+� �� � � �e0g�j0�m611� O+01�q+s� b0�v��� $:202�z� :31� +�~W0��3�1� +�~W0��0��� ���� :4+� S0��4�+� S0��� :5+�	5�+�	+�� b+� �+� STV�Z�\:66��a6+� �� � � �e6��j6�m677�B+67�q+�� b+� �+^��:9+��6:9:�� 6;9�� � � � �6<<9�� ��:8+� �9�� <d6?8?`��� D98��:�� � � � � (8��6?+++� �*� �2� � ��������� ":@9;:�� W+� ��� 8��@�9;:�� W+� ��� 8�ȧ :A+�	A�+�	+ʶ b6�v�� � $:B6B�z� :C7� +�~W6��C�7� +�~W6��6��� ���� :D+� S6��D�+� S6��� :E+�	E�+�	+�� b+� �+� STV�Z�\:FF̶aF+� �� � � �eF�m6GG� x+FG�q+ζ b+++� �*� �2�� *� �2�Ը��+ֶ bF�v��ʧ $:HFH�z� :IG� +�~WF��I�G� +�~WF��F��� ���� :J+� SF��J�+� SF��� :K+�	K�+�	+�� b+� �*� �2++� �*� �2�� *� �2�Թ � W+�� b+� �+� STV�Z�\:LLضaL+� �� � � �eL�m6MM� x+LM�q+ڶ b+++� �*� �2�� *� �2�Ը��+ֶ bL�v��ʧ $:NLN�z� :OM� +�~WL��O�M� +�~WL��L��� ���� :P+� SL��P�+� SL��� :Q+�	Q�+�	+�� b+� �+� STV�Z�\:RRܶaR+� �� � � �eR�m6SS� i+RS�q+޶ b++� �� ù � ���+ֶ bR�v��٧ $:TRT�z� :US� +�~WR��U�S� +�~WR��R��� ���� :V+� SR��V�+� SR��� :W+�	W�+�	+�� b+� �+� STV�Z�\:XX�aX+� �� � � �eX�m6YY� �+XY�q+� b++� �*� �2� � ���+� b++� �*� �2� � ���+� b++� �*� �2� � ���+� b++� �*� �2� � ���+� b+++� �*� �2�� *� �2�Ը��+ֶ bX�v��R� $:ZXZ�z� :[Y� +�~WX��[�Y� +�~WX��X��� ���� :\+� SX��\�+� SX��� :]+�	]�+�	+�� b+� �+� STV�Z�\:^^�a^+� �� � � �e^�m6__� O+^_�q+� b^�v��� $:`^`�z� :a_� +�~W^��a�_� +�~W^��^��� ���� :b+� S^��b�+� S^��� :c+�	c�+�	+�� b+� �*� �2:� � W+{� b+��:e+��6fef�� 6ge�� � � � �6hhe�� ��:d+� �e�� hd6kdk`��� �ed��f�� � � � � qd��6k+{� b+� �*� �2+� �*� �2� � �++� �*� �2�� *� �2�Ը��+�����+������ � W+{� b��m� ":legf�� W+� ��� d��l�egf�� W+� ��� d��+�� b+� S��Z�:mm�m�m�m+� �*� �2� � �m�m�Wm�� ���� :n+� Sm��n�+� Sm��+�� b+� �+� STV�Z�\:oo�ao+� �� � � �eo�m6pp� O+op�q+� bo�v��� $:qoq�z� :rp� +�~Wo��r�p� +�~Wo��o��� ���� :s+� So��s�+� So��� :t+�	t�+�	+�� b+� �*� �2:� � W+{� b+��:v+��6wvw�� 6xv�� � � �,6yyv�� ��:u+� �v�� yd6|u|`��� �vu��w�� � � � � �u��6|+{� b+� �*� �2+� �*� �2� � �++� �*� �2�� *� �2�Ը��+����+����++� �*� �2�� *� �2�Ը��+�����+������ � W+{� b��8� ":}vxw�� W+� ��� u��}�vxw�� W+� ��� u��+�� b+� S��Z�:~~�~�~ �~+� �*� �2� � �~�~�W~�� ���� :+� S~���+� S~��+�� b+� S��Z�:������"+� �*� �2� � ���$����&�����W��� ���� :�+� S�����+� S���+� b+� S(*�Z�,:��.�/�1+� �*� �2� � ���$���4�5�:��;6��� 8+���q+{� b��<���� :��� +�~W���� +�~W��=� ���� :�+� S�����+� S���+� b+� S(*�Z�,:��"+� �*� �2� � ���$���/�>�:�A�D�F�4��;6��� 8+���q+{� b��<���� :��� +�~W���� +�~W��=� ���� :�+� S�����+� S���+� b+� S��Z�:����H��"+� �*� �2� � ���$�����W��� ���� :�+� S�����+� S���+�� b+� S(*�Z�,:��J�/�>�:�A�D�L�4��;6��� 8+���q+{� b��<���� :��� +�~W���� +�~W��=� ���� :�+� S�����+� S���+�� b+� S(*�Z�,:��N�/�>�:�A�D�L�4��;6��� 8+���q+{� b��<���� :��� +�~W���� +�~W��=� ���� :�+� S�����+� S���+� b+� �+� STV�Z�\:��P�a�+� �� � � �e��m6��� O+���q+R� b��v��� $:����z� :��� +�~W������� +�~W������� ���� :�+� S�����+� S���� :�+�	��+�	+�� b+� �+� STV�Z�\:��T�a�+� �� � � �e��m6��� O+���q+V� b��v��� $:����z� :��� +�~W������� +�~W������� ���� :�+� S�����+� S���� :�+�	��+�	+�� b+� �+� STV�Z�\:��X�a�+� �� � � �e��m6��� O+���q+Z� b��v��� $:����z� :��� +�~W������� +�~W������� ���� :�+� S�����+� S���� :�+�	��+�	+�� b+� �+� STV�Z�\:��\�a�+� �� � � �e��m6��� O+���q+^� b��v��� $:����z� :��� +�~W������� +�~W������� ���� :�+� S�����+� S���� :�+�	��+�	+�� b+� S(*�Z�,:��J�/�>�:�A�D�`�4��;6��� 8+���q+{� b��<���� :��� +�~W���� +�~W��=� ���� :�+� S�����+� S���+�� b+� S(*�Z�,:��N�/�>�:�A�D�`�4��;6��� 8+���q+{� b��<���� :��� +�~W���� +�~W��=� ���� :�+� S�����+� S���+b� b+� Sdf�Z�h:��j�m��nW��o� ���� :�+� S�����+� S���+q� b� +{� b� +{� b� +s� b+� �++� �� ù � �� b� :�+�	��+�	+u� b+� �++� �*� �2� � �� b� :�+�	��+�	+w� b+� �+y� b+{� b+� �*� �2� � Ǹ �� � � *+}� b++� �*� �2� � �� b+� b� J+� �*� �2� � Ҹ �� � � *+}� b++� �*� �2� � �� b+�� b� +�� b+� �*� �2� � Ǹ �� � � ++�� b++� �*� �2� � �� b+�� b� K+� �*� �2� � Ҹ �� � � ++�� b++� �*� �2� � �� b+�� b� +�� b+� �*� �2� � Ǹ �� � � ++�� b++� �*� �2� � �� b+�� b� K+� �*� �2� � Ҹ �� � � ++�� b++� �*� �2� � �� b+�� b� +�� b+� �*� �2� � Ǹ �� � � +�� b� -+� �*� �2� � Ҹ �� � � +�� b� +�� b� :�+�	��+�	+�� b+�� b+� �*� �2� � Ҹ �� � ��+{� b+� �� �� � � �� � ��+� b+� �*� �	2� � :� �� � � @+{� b+� �*� �2�.� � W+{� b+� �*� �2��� � W+{� b� �+� �*� �	2� � :� �� � � �+{� b+�+� �*� �	2� � ��"�%� � � @+{� b+� �*� �2�.� � W+{� b+� �*� �2��� � W+{� b� #+{� b+� �*� �2�+� � W+{� b+{� b� +�� b+� �*� �2� � 6� �� � � �+{� b+� �*� �2� � :� �� � � &+{� b+� �*� �2�@� � W+{� b� a+� �*� �2� � :� �� � � @+{� b+� �*� �2�.� � W+{� b+� �*� �2��� � W+{� b� +{� b� +�� b+� �*� �2� � P� �� � � �+{� b+� �*� �2�+� �*� �2� � ���� � W+{� b+�+� �*� �2� � �=� &+{� b+� �*� �2�1� � W+{� b� b+�+� �*� �2� � �=� � � @+{� b+� �*� �2�.� � W+{� b+� �*� �2��� � W+{� b� +{� b� +�� b+� �*� �2� � �� �� � �?+{� b+� �*� �2� � :� �� � � �+{� b+8+� �*� �2� � �=� &+{� b+� �*� �2��� � W+{� b� c+8+� �*� �2� � �=� � � A+{� b+� �*� �2�.� � W+{� b+� �*� �2�C� � W+E� b� +{� b� b+� �*� �2� � :� �� � � A+{� b+� �*� �2�.� � W+{� b+� �*� �2�H� � W+�� b� +�� b� +� b+� �*� �2� � �� �� � �/+�� b+� �+� STV�Z�\:��^�a�+� �� � � �e�g�j��m6��� O+���q+s� b��v��� $:����z� :��� +�~W������� +�~W������� ���� :�+� S�����+� S���� :�+�	��+�	+�� b+� �+� STV�Z�\:����a�+� �� � � �e���j��m6���B+���q+�� b+� �+^��:�+��6��ù� 6�¹� � � � �6��¹� ��:�+� �¹� �d6���`��� D����ù� � � � � (���6�+++� �*� �2� � ��������� ":���ù� W+� ��� ���ɿ��ù� W+� ��� ��ȧ :�+�	ʿ+�	+ʶ b��v�� � $:��˶z� :��� +�~W���̿�� +�~W������� ���� :�+� S���Ϳ+� S���� :�+�	ο+�	+�� b+� �+� STV�Z�\:��̶a�+� �� � � �e϶m6��� x+�жq+ζ b+++� �*� �2�� *� �2�Ը��+ֶ b϶v��ʧ $:��Ѷz� :��� +�~W϶�ҿ�� +�~W϶�϶�� ���� :�+� S϶�ӿ+� S϶�� :�+�	Կ+�	+�� b+� �*� �2++� �*� �2�� *� �2�Թ � W+�� b+� �+� STV�Z�\:��ضa�+� �� � � �eնm6��� x+�ֶq+ڶ b+++� �*� �2�� *� �2�Ը��+ֶ bնv��ʧ $:��׶z� :��� +�~Wն�ؿ�� +�~Wն�ն�� ���� :�+� Sն�ٿ+� Sն�� :�+�	ڿ+�	+� b+� �+� STV�Z�\:��ܶa�+� �� � � �e۶m6��� i+�ܶq+޶ b++� �� ù � ���+ֶ b۶v��٧ $:��ݶz� :��� +�~W۶�޿�� +�~W۶�۶�� ���� :�+� S۶�߿+� S۶�� :�+�	�+�	+�� b+� �*� �2� � :� �� � ��+{� b+� �+� STV�Z�\:���a�+� �� � � �e�m6���,+��q+� b++� �*� �	2� � ���+�� b++� �*� �2� � ���+� b++� �*� �2� � ���+� b++� �*� �	2� � ���+�� b++� �*� �2� � ���+� b++� �*� �2� � ���+� b+++� �*� �2�� *� �2�Ը��+ֶ b�v��� $:���z� :��� +�~W����� +�~W����� ���� :�+� S���+� S��� :�+�	�+�	+�� b��+� �*� �2� � :� �� � ��+{� b+� �+� STV�Z�\:���a�+� �� � � �e�m6���,+��q+�� b++� �*� �	2� � ���+�� b++� �*� �2� � ���+�� b++� �*� �2� � ���+� b++� �*� �	2� � ���+�� b++� �*� �2� � ���+� b++� �*� �2� � ���+�� b+++� �*� �2�� *� �2�Ը��+ֶ b�v��� $:���z� :��� +�~W����� +�~W����� ���� :�+� S���+� S��� :�+�	�+�	+�� b� +�� b+� �+� STV�Z�\:���a�+� �� � � �e��m6��� O+��q+� b��v��� $:���z� :��� +�~W������ +�~W������� ���� :�+� S����+� S���� :�+�	�+�	+�� b+� �*� �2:� � W+{� b+��:�+��6����� 6���� � � � �6����� ��:�+� ���� �d6���`��� ������� � � � � q��6�+{� b+� �*� �2+� �*� �2� � �++� �*� �2�� *� �2�Ը��+�����+������ � W+{� b��m� ":������ W+� ��� ��������� W+� ��� ��+�� b+� S��Z�:��������+� �*� �2� � �����W��� ���� :�+� S�����+� S���+�� b+� �+� STV�Z�\:���a�+� �� � � �e��m6��� W+���q+� b��v��� ,�: �� �z� �:�� +�~W������� +�~W������� ���� �:+� S�����+� S���� �:+�	��+�	+�� b+� �*� �2:� � W+{� b+���:+���6���� �6��� � � �\�6���� ���:+� ���� �d�6��`��� �������� � � � � �����6+{� b+� �*� �2+� �*� �2� � �++� �*� �2�� *� �2�Ը��+����+����++� �*� �2�� *� �2�Ը��+�����+������ � W+{� b��*� .�:����� W+� ��� ���������� W+� ��� ���+�� b+� S��Z��:����� ��+� �*� �2� � �����W��� ���� �:+� S�����+� S���+�� b+� S��Z��:�����"+� �*� �2� � ���$����&�����W��� ���� �:+� S�����+� S���+� b+� S(*�Z�,�:�.�/�1+� �*� �2� � ���$���4�5�:��;�6�� F+���q+{� b��<��� �:�� +�~W���� +�~W��=� ���� �:+� S�����+� S���+� b+� S(*�Z�,�:�"+� �*� �2� � ���$���/�>�:�A�D�F�4��;�6�� F+���q+{� b��<��� �:�� +�~W���� +�~W��=� ���� �:+� S�����+� S���+� b+� S��Z��:���H��"+� �*� �2� � ���$�����W��� ���� �:+� S�����+� S���+�� b+� S(*�Z�,�:�J�/�>�:�A�D�L�4��;�6�� F+���q+{� b��<��� �:�� +�~W���� +�~W��=� ���� �:+� S�����+� S���+�� b+� S(*�Z�,�:�N�/�>�:�A�D�L�4��;�6 � � F+�� �q+{� b��<��� �:!� � +�~W�!�� � +�~W��=� ���� �:"+� S����"�+� S���+� b+� �+� STV�Z�\�:#�#P�a�#+� �� � � �e�#�m�6$�$� g+�#�$�q+R� b�#�v��� 2�:%�#�%�z�  �:&�$� +�~W�#���&��$� +�~W�#���#��� ���� �:'+� S�#���'�+� S�#��� �:(+�	�(�+�	+�� b+� �+� STV�Z�\�:)�)T�a�)+� �� � � �e�)�m�6*�*� g+�)�*�q+V� b�)�v��� 2�:+�)�+�z�  �:,�*� +�~W�)���,��*� +�~W�)���)��� ���� �:-+� S�)���-�+� S�)��� �:.+�	�.�+�	+�� b+� �+� STV�Z�\�:/�/X�a�/+� �� � � �e�/�m�60�0� g+�/�0�q+Z� b�/�v��� 2�:1�/�1�z�  �:2�0� +�~W�/���2��0� +�~W�/���/��� ���� �:3+� S�/���3�+� S�/��� �:4+�	�4�+�	+�� b+� �+� STV�Z�\�:5�5\�a�5+� �� � � �e�5�m�66�6� g+�5�6�q+^� b�5�v��� 2�:7�5�7�z�  �:8�6� +�~W�5���8��6� +�~W�5���5��� ���� �:9+� S�5���9�+� S�5��� �::+�	�:�+�	+�� b+� S(*�Z�,�:;�;J�/�;>�:�;A�D�;`�4�;�;�6<�<� F+�;�<�q+{� b�;�<��� �:=�<� +�~W�=��<� +�~W�;�=� ���� �:>+� S�;���>�+� S�;��+�� b+� S(*�Z�,�:?�?N�/�?>�:�?A�D�?`�4�?�;�6@�@� F+�?�@�q+{� b�?�<��� �:A�@� +�~W�A��@� +�~W�?�=� ���� �:B+� S�?���B�+� S�?��+¶ b+� Sdf�Z�h�:C�Cj�m�C�nW�C�o� ���� �:D+� S�C���D�+� S�C��+N� b� +{� b� +{� b� +Ķ b+� �++� �� ù � �� b� �:E+�	�E�+�	+u� b+� �++� �*� �2� � �� b� �:F+�	�F�+�	+ƶ b+� �+ȶ b+ʶ b+̶ b+� �*� �2� � Ҹ �� � � *+}� b++� �*� �2� � �� b+ζ b� J+� �*� �2� � Ǹ �� � � *+}� b++� �*� �2� � �� b+ж b� +Ҷ b+� �*� �2� � Ҹ �� � � ++Զ b++� �*� �	2� � �� b+ֶ b� K+� �*� �2� � Ǹ �� � � ++Զ b++� �*� �	2� � �� b+ض b� +ڶ b+� �*� �2� � Ҹ �� � � ++ܶ b++� �*� �2� � �� b+ֶ b� K+� �*� �2� � Ǹ �� � � ++ܶ b++� �*� �2� � �� b+ض b� +޶ b+� �*� �2� � Ҹ �� � � ++� b++� �*� �2� � �� b+�� b� K+� �*� �2� � Ǹ �� � � ++� b++� �*� �2� � �� b+�� b� +� b+� �*� �2� � Ҹ �� � � f+{� b+� �*� �2� � :� �� � � +� b� -+� �*� �2� � :� �� � � +� b� +{� b� -+� �*� �2� � Ǹ �� � � +� b� +� b+� �*� �2� � Ҹ �� � � +� b� -+� �*� �2� � Ǹ �� � � +� b� +�� b� �:G+�	�G�+�	+� b+� �*� �2� � 6� �� � � 1+{� b+� �+� b� �:H+�	�H�+�	+{� b� +�� b+� �*� �2� � P� �� � � 1+{� b+� �+�� b� �:I+�	�I�+�	+{� b� +�� b+� �*� �2� � �� �� � � 1+{� b+� �+�� b� �:J+�	�J�+�	+{� b� +�� b+� �*� �2� � �� �� � � 1+{� b+� �+�� b� �:K+�	�K�+�	+{� b� +�� b+� �*� �2� � �� �� � � 1+{� b+� �+�� b� �:L+�	�L�+�	+{� b� +�� b+� �*� �2� � �� �� � � 1+{� b+� �+ � b� �:M+�	�M�+�	+{� b� +�� b+� �*� �2� � � �� � � 1+{� b+� �+� b� �:N+�	�N�+�	+{� b� +�� b+� �*� �2� � � �� � � 1+{� b+� �+� b� �:O+�	�O�+�	+{� b� +�� b+� �*� �2� � 
� �� � � 1+{� b+� �+� b� �:P+�	�P�+�	+{� b� +�� b+� �*� �2� � � �� � � 1+{� b+� �+� b� �:Q+�	�Q�+�	+{� b� +�� b+� �*� �2� � � �� � � 1+{� b+� �+� b� �:R+�	�R�+�	+{� b� +�� b+� �*� �2� � � �� � � 1+{� b+� �+� b� �:S+�	�S�+�	+{� b� +� b+� �+� b� �:T+�	�T�+�	+� b+ � b+"� b+� �*� �2++�')�.� � W+{� b+� �+� STV�Z�\�:U�U0�a�U+� �� � � �e�U�m�6V�V� g+�U�V�q+2� b�U�v��� 2�:W�U�W�z�  �:X�V� +�~W�U���X��V� +�~W�U���U��� ���� �:Y+� S�U���Y�+� S�U��� �:Z+�	�Z�+�	+{� b+� �+� STV�Z�\�:[�[4�a�[+� �� � � �e�[�m�6\�\� g+�[�\�q+6� b�[�v��� 2�:]�[�]�z�  �:^�\� +�~W�[���^��\� +�~W�[���[��� ���� �:_+� S�[���_�+� S�[��� �:`+�	�`�+�	+{� b+� �+8� b++�<*� �2�? �� b+A� b+++� �*� �2�� �D�Ը� b+F� b+++� �*� � 2�� �D�Ը� b+H� b++� �*� �2� � �� b+J� b� �:a+�	�a�+�	+L� b� �
�
�
�  AA  ���  �,,  ��� )���  �##  �==  �GG  ���  ��� )���  g��  T��  W�� )W��  )��  ��  y�� )y��  K��  8  i�� )i��  ;��  (��  J�� )J
  @@  	ZZ  ��� )���  �  q!!  �55  ���  1AD )1MP  ��  ���  ��  ;��  �

  ���  ;��  DVV  ���  ���  ass  ,��    �BB  ��� )���  w��  d     l |  ) l � �   > � �   + � �  !3!C!F )!3!O!R  !!�!�   �!�!�  !�"
" )!�""  !�"O"O  !�"i"i  "�"�"�  "�##  #g#y#y  #2#�#�  #�#�#�  $3$I$I  $a$z$z  $�&�&�  +�,	, )+�,,  +�,N,N  +�,h,h  -"-r-r  ,�-�-�  ,�-�-� ),�-�-�  ,�..  ,.*.*  .�.�.� ).�.�.�  .T/ /   .A//  /�/�/� )/�/�/�  /v0"0"  /c0<0<  0�0�0� )0�0�0�  0g11  0T11  1�2�2� )1�2�2�  1n2�2�  1[2�2�  3i4V4Y )3i4b4e  3;4�4�  3(4�4�  55'5* )55356  4�5l5l  4�5�5�  66�6�  6�7474  7�7�7� )7�7�7�  7h7�7�  7U88  8�9�9�  9�:D:D  :~:�:�  ;w;�;�  ;;�;�  <_<s<s  ;�<�<�  <�=7=7  =�=�=�  =q>>  >�>�>�  ><>�>�  ?H?Z?] )?H?l?o  ??�?�  >�?�?�  @A@S@V )@A@e@h  @@�@�  ?�@�@�  A:ALAO )A:A^Aa  @�A�A�  @�A�A�  B3BEBH )B3BWBZ  A�B�B�  A�B�B�  C3CGCG  B�C}C}  C�DD  C�DHDH  D�D�D�  D�EE  E E9E9  EUH�H�  II$I$  IpIzIz  I�I�I�  JJ&J&  JrJ|J|  J�J�J�  KK(K(  KtK~K~  K�K�K�  L L*L*  LvL�L�  L�L�L�  L�MM  M�M�M� )M�M�M�  MfNN  MQN/N/  N�N�N� )N�N�N�  N_OO  NJO(O(  OCO�O�   �         * +  �  ��    X  |  �  �  �  �  � 
D �  j � . R x � �  / R q } �  & H  T "� #� $� % &D 'j (� )� *� +� ,� -� .� 0 19 2` 3� 4� 6� 7 8@ 9g :s <� =� >	$ ?	K @	W B	� C	� D
 E
/ F
; G
> o
P q
Y �
\ �
e �
q �
t �
w �
� �
� �
� �
� �
� �
� �
� � �! �; �N �Q �X �[
��������&9<CF.T@wA�D�EFG%H?IZK]L`N�O�P�R�S�V�WX8YRZ}[�\�]�^�_�`�ac d$f*g.kVl~o�q�sMu�y�z|[}�~��1�}���!�m����N���j���1�J���,�q���5�����M���%�������!�!�%�E�i������!�)�G����������6�>�F�d����������]��� $� p� ��!7�!��!��"y�"��"��"��"��#�#<�#D�#L�#j�#��#��$�$�$"�$,�$/�$��$��$��$�$�$�%%(%5%Y%w%�%�%�%�&%�'&(&8)&V*&`,&c5&�6&�7&�8&�9&�:&�A&�V&�W&�X'$['K\'e]'^'�_'�`'�a(b(c(0d(6e(?g(gh(�i(�j(�k(�l)m)n)p)@q)pr)�s)�t)�u)�v*	w*x*z*C{*j|*�}*�~*�*��+�+
�+�+7�+Q�+l�+r�+v�+|�+��+��+��+��,x�,��-��.:�.��.��/*�/\�/��/��0M�0��0��1.�1T�1��2}�2��3!�3m�4!�4J�4��4��4��5�5��5��63�6��6��7N�7��8%�8>�8��9}�9��:f�:��:��;�;�;�;,�;R�;z�;��<&�<0�<:�<b�<��<��<��=V�=V�=Y�=�=��=��=��>$�>J�>T�>^�>��>��?L�?��@E�@��A>�A��B7B�B�CCC6C�	C�
C�C�DDkDnD�D�D�D�D�EN EQ"EY#E\/Ec;Eg<Ej@E�AE�BE�CE�DE�MF#NFAOFkPF�QF�]F�^F�_G`G aG-jGQkGolG�mG�nG�pG�yG�zH{H|H8}H>~HAHk�Hq�Hu�Hx�H��H��H��H��H��H��H��I�I�I5�I8�IA�Ii�It�I��I��I��I��I��I��I��I��J�J �J7�J:�JC�Jk�Jv�J��J��J��J��J��J��J��J��K�K"�K9�K<�KE�Km�Kx�K��K��K��K��K��K��K��K��L�L$�L;�L>�LG�Lo�Lz�L��L��L��L��L��L��L��L��L��M�M$M( M+$MJ%M�'NC(N�*O<+OG,O�-�     ) MN �        �    �     ) OP �         �    �     ) QR �        �    �    T    �  V    J*!� lY_�eSYg�eSYi�eSYk�eSYϸeSYظeSYm�eSYo�eSY�eSY	q�eSY
�eSYs�eSYu�eSYw�eSYy�eSY{�eSY}�eSY�eSY��eSY��eSY��eSY��eSY��eSY��eSY��eSY��eSY��eSY��eSY��eSY��eSY��eSY��eSY ��eS� ��     �    