����   2� \__138/__138/publish/hermes_seg_18_041454/proprietary/_2/edit_antivirus_signature_feed_cfm$cf  lucee/runtime/PageImpl  N../../publish/hermes-seg-18.04/proprietary/2/edit_antivirus_signature_feed.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ���4 getSourceLength      �� getCompileTime  �@,�� getHash ()I�iV� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this ^L__138/__138/publish/hermes_seg_18_041454/proprietary/_2/edit_antivirus_signature_feed_cfm$cf; �<!DOCTYPE html>

  
 
 
<html lang="en">


<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Edit Antivirus Signature Feed</title>

   , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 ./inc/html_head.cfm 4 	doInclude (Ljava/lang/String;Z)V 6 7
 / 8�

     <!-- Preloader -->
     <div class="preloader flex-column justify-content-center align-items-center">
      <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
      </div>

      
<script>
  $(document).ready(function() {
      $('#sortTable').DataTable( {
  dom: 'Blfrtip',
    buttons: [
  'copy', 'csv', 'excel', 'pdf', 'print'
    ],
    lengthMenu: [
  [ 10, 25, 50, -1 ],
  [ '10 rows', '25 rows', '50 rows', 'Show all' ]
  
      ],
    "order": [[ 2, "asc" ]]
      } );
  } );
    </script>




 
<style>
  textarea{
border:1px solid #999999;
width:100%;
margin:5px 0;
padding:3px;
  }
  .textareacontainer{
padding-right: 8px; /* 1 + 3 + 3 + 1 */
  }
    </style>



  
<style>
  .alert a {
    color: #fff;
    text-decoration: none;
}
</style>
  

</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">

  
  


   : ./inc/top_navbar.cfm < 
   > ./inc/main_sidebar.cfm @

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
             B outputStart D 
 / E Z
            <h1 class="m-0">Edit Antivirus Signature Feed</h1>
            
           G 	outputEnd I 
 / J+
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Edit Antivirus Signature Feed</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

  

   L ./inc/lc1.cfm N 



     



 P step R &lucee/runtime/config/NullSupportHelper T NULL V '
 U W -lucee/runtime/interpreter/VariableInterpreter Y getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; [ \
 Z ] 0 _ %lucee/runtime/exp/ExpressionException a java/lang/StringBuilder c The required parameter [ e  1
 d g append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; i j
 d k ] was not provided. m -(Ljava/lang/String;)Ljava/lang/StringBuilder; i o
 d p toString ()Ljava/lang/String; r s
 d t
 b g lucee/runtime/PageContextImpl w any y�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V } ~
 x   

 � m � 
 � sessionScope $()Llucee/runtime/type/scope/Session; � �
 / � lucee/runtime/op/Caster � toStruct /(Ljava/lang/Object;)Llucee/runtime/type/Struct; � �
 � � $lucee/runtime/type/util/KeyConstants � _m #Llucee/runtime/type/Collection$Key; � �	 � � !lucee/runtime/type/Collection$Key � .lucee/runtime/functions/struct/StructKeyExists � \(Llucee/runtime/PageContext;Llucee/runtime/type/Struct;Llucee/runtime/type/Collection$Key;)Z & �
 � � _M � �	 � �  lucee/runtime/type/scope/Session � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � �   � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � us &()Llucee/runtime/type/scope/Undefined; � �
 / � "lucee/runtime/type/scope/Undefined � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � � 






 � 


 � 



 � action �  
 � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _action � �	 � � _ACTION � �	 � � lucee/runtime/type/scope/Form � � � 





 � theID � urlScope  ()Llucee/runtime/type/scope/URL; � �
 / � _id � �	 � � integer � _ID � �	 � � lucee/runtime/type/scope/URL � � � (lucee/runtime/functions/decision/IsValid � B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z & �
 � � keys $[Llucee/runtime/type/Collection$Key; � �	  � 8Edit Antivirus Signature Feed: url.id not valid interger � ./inc/error.cfm � lucee.runtime.tag.Abort � cfabort � OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:174 � use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; � �
 x � lucee/runtime/tag/Abort � 
doStartTag � $
 � � doEndTag � $
 �  lucee/runtime/exp/Abort newInstance (I)Llucee/runtime/exp/Abort;
 reuse !(Ljavax/servlet/jsp/tagext/Tag;)V	
 x
 4Edit Antivirus Signature Feed: url.id does not exist OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:183 lucee.runtime.tag.Query cfquery OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:188 lucee/runtime/tag/Query hasBody (Z)V
 getfeed setName 1
 hermes! setDatasource (Ljava/lang/Object;)V#$
%
 � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V()
 /* [
select id, name, enabled, update_int, description, applied from malware_feeds where id = , lucee.runtime.tag.QueryParam. cfqueryparam0 OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:1892 lucee/runtime/tag/QueryParam4 � � setValue7$
58 CF_SQL_INTEGER: setCfsqltype< 1
5=
5 �
5  doAfterBodyA $
B doCatch (Ljava/lang/Throwable;)VDE
F popBody ()Ljavax/servlet/jsp/JspWriter;HI
 /J 	doFinallyL 
M
  

P getCollectionR � �S #lucee/runtime/util/VariableUtilImplU recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;WX
VY (Ljava/lang/Object;D)I �[
 �\ 7Edit Antivirus Signature Feed: getfeed.recordcount LT 1^ OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:195` theNameb _NAMEd �	 �e I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �g
 /h 	theStatusj theUpdateIntl theDescriptionn OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:206p getfeeditemsr n
  select id, name, filename, value, description, active, feed, fp, type from malware_databases where feed = t OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:207v 





x editfeedz 


  

| 	_username~ �	 � 

  � ;Edit Antivirus Signature Feed: form.username does not exist� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:234� 
  
  
  � 	_password� �	 �� 
  
  � ;Edit Antivirus Signature Feed: form.password does not exist� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:244� _email� �	 �� 8Edit Antivirus Signature Feed: form.email does not exist� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:253� =Edit Antivirus Signature Feed: form.first_name does not exist� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:263� <Edit Antivirus Signature Feed: form.last_name does not exist� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:273� 

  
    � AEdit Antivirus Signature Feed: form.access_control does not exist� 
    � OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:282� 
one_factor� 
two_factor� REdit Antivirus Signature Feed: form.access_control is not one_factor or two_factor� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:292� 
    
  
  � >Edit Antivirus Signature Feed: form.setpassword does not exist� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:305� YES� NO� @Edit Antivirus Signature Feed: form.setpassword is not YES or NO� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:315� 


  
  � 7Edit Antivirus Signature Feed: form.hibp does not exist� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:328� 9Edit Antivirus Signature Feed: form.hibp is not YES or NO� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:338� 
  
  
  

� #lucee/commons/color/ConstantsDouble� _0 Ljava/lang/Double;��	�� _2��	�� � � lucee.runtime.tag.Location� 
cflocation� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:355� lucee/runtime/tag/Location� edit_system_user.cfm?id=� &(Ljava/lang/Object;)Ljava/lang/String; r�
 �� java/lang/String� concat &(Ljava/lang/String;)Ljava/lang/String;��
�� setUrl� 1
�� setAddtoken�
��
� �
�  _1��	�� 
  

� 1� [^A-Za-z0-9\_\.\-\@]� %lucee/runtime/functions/string/REFind� S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object; &�
�� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:373� 2  OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:390 checkusername 6
select username from system_users where username = ' writePSQ$
 /	 ' and id <>  OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:391 OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:397 
updateuser '
update system_users set
username = ' ',
applied='2'
where id =  OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:401 _3�	� _13�	� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:412 3! email# OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:430% OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:436' (
  update system_users set
  email = ')  ',
  applied='2'
  where id = + OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:440- _4/�	�0 OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:4542 44 _66�	�7 OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:4679 [^A-Za-z0-9\_\-]; _5=�	�> OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:478@ 

  
B OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:484D -
  update system_users set
  first_name = 'F OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:488H 5J _9L�	�M OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:505O 
  
Q _8S�	�T OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:515V OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:521X ,
  update system_users set
  last_name = 'Z OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:525\ 6^ OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:539` -
update system_users set
access_control = 'b OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:543d _7f�	�g 7i OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:557k checkpasswordexistsm 3
select id, password from system_users where id = o OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:558q _12s�	�t OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:566v 



  
x 8z _10|�	�} OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:595 "lucee/runtime/functions/string/Len� 0(Llucee/runtime/PageContext;Ljava/lang/Object;)D &�
��@        (DD)I ��
 �� _11��	�� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:606�@P       OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:615� 9� ./inc/check_hibp.cfm� 10� $./inc/generate_authelia_password.cfm� 11� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:659� '
update system_users set
password = '� #lucee/runtime/functions/string/Trim� A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &�
�� ',
applied='1'
where id = � OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:663� *./inc/generate_authelia_users_database.cfm� _14��	�� java� java.lang.Thread� *lucee/runtime/functions/other/CreateObject�
�� _sleep� �	 �� java/lang/Object�@��      toDouble (D)Ljava/lang/Double;��
 �� getFunction \(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;[Ljava/lang/Object;)Ljava/lang/Object;��
 /�  
  
� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:677� 12� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:685� 9
  update system_users set
  applied='1'
  where id = � OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:688� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:702� 
deleteitem� 

    � (Delete Feed Item: form.id does not exist� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:715� 
    
    � Delete Feed Item: form.id blank� OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:722� 

    
    � OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:733� getitem� B
SELECT  id, value, type, feed from malware_databases where id = � OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:734� _VALUE� �	 �� _TYPE� �	 �� (

<!-- DELETE ITEM FROM DATABASE -->
� #./inc/delete_feed_item_database.cfm� feedurl� 

<!-- DISABLE THE FEED -->
� ./inc/disable_malware_feed.cfm� database� 5

  <!-- DELETE DATABASE FILE FROM FILESYSTEM -->
� %./inc/delete_feed_item_filesystem.cfm  
          

 $./inc/delete_system_user_devices.cfm OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:773 view_system_users.cfm ,Delete System User: getfeed.recordcount LT 1
 OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:782 deleteuserdevices _user �	 � ,Delete System User: form.user does not exist OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:793 _USER �	 � #Delete System User: form.user blank OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:800 OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:811 getuser  B
SELECT  id, username, system from system_users where username = " OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:812$ cf_sql_varchar& _15(�	�) OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:831+ OC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:840- 
 
 


/ � 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    1 �You have entered an invalid Username. Usernames can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_), dashes (-), periods (.) and at signs (@)3 
  </div>

  5 �

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    7 "The Username field cannot be blank9 6The E-mail Address field is not a valid e-mail address; (The E-mail Address field cannot be blank= �You have entered an invalid First Name. First Names can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)? $The First Name field cannot be blankA �You have entered an invalid Last Name. Last Names can only contain upper/lower case letters (A-Z, a-z), numbers (0-9), underscores (_) and dashes (-)C #The Last Name field cannot be blankE The Password field cannot blankG 5The Password must be between 8 and 64 characters longI }No password has been set for this user. You must set the <strong>Set User Password</strong> field to YES in order to continueK 13M 5The Username you are attempting to use already existsO 14Q �

<div class="alert alert-success alert-dismissible">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-check"></i> Success!</h4>
  S "System User was saved successfullyU  
    
</div>

W 15Y �

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    [ 1System User 2FA devices were deleted successfully]  
      
  </div>
  
  _ 



  
a 99c

      <div class="alert alert-danger alert-dismissible">
                  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                  <h4><i class="icon fa fa-ban"></i> Oops!</h4>
                  e �The Password you are attempting to use has previously appeared in a data breach. Please use another password. Password was checked by <a href="https://haveibeenpwned.com/Passwords" target="_blank">haveibeenpwned.com</a>g ,
                </div>

                i 100k �

  <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      mGThere was a problem accessing haveibeenpwned.com to check your password against previous data breaches. Either ensure Hermes SEG has outbound Internet access over 443 to <a href="https://api.pwnedpasswords.com">https://api.pwnedpasswords.com</a> OR set the <strong>Check Password Against haveibeenpwned.com</strong> field to NOo 
    </div>

    q �






<span>
  <p>       


<a href="view_antivirus_signature_feeds.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Antivirus Signature Feeds</a>





s �
  <!-- Delete User devices Button-->
  <a href="#delete_devices_modal"  class="btn btn-danger" role="button" data-toggle="modal" data-user="u D"><i class="fa fa-mobile"></i>&nbsp;&nbsp;Delete 2FA Devices</a>
  wR






</p>


</span>



   

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteUserModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        
          <h4 class="modal-title">Delete Feed Item(s) </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you send to delete this item(s)? This action is irreversible! If you click <strong>Yes</strong>, the item(s). If among the item(s) you delete is the Feed URL, the Signature Feed will be disabled automatically.</p>

      </div>
      <div class="modal-footer">
        <form name="delete_item" method="post">

          <input type="hidden" name="action" value="deleteitem">
          <input type="hidden" name="id" value=""/>

          
          <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

          
          
            y-</form>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
</div>


<!-- EDIT SYSTEM USER FORM STARTS HERE -->


<div class="card col-sm-8">


  <!-- form start -->
    <form name="edit_antivirus_signare_feeds.cfm" method="post" action="">
  
    <input type="hidden" name="action" value="editfeed">
  
      <div class="box-body">
         
      
        <div class="form-group">
          <label for="feedname"><strong>Name</strong></label>
  
  
            { K
          <input type="text" class="form-control" name="feedname" value="} B" id="feedname" placeholder="Feed Name">
        </div>
        
  
        
        <div class="form-group">
          <label><strong>Status</strong></label>
  
  
      
          <select class="form-control" name="feedstatus" data-placeholder="feedstatus" style="width: 100%;"  id="access_control">
            � no� �                           
              <option value="no" selected>Disabled</option>
              <option value="yes">Enabled</option>
  
            � yes� �
              <option value="yes" selected>Enabled</option>
              <option value="no">Disabled</option>
           
            � f
              </select>   
        
            </div> 
  
            
   

                �/
                <div class="form-group" id="updateint">
                  <label><strong>Update Interval</strong></label>
               
                  <select class="form-control select2" name="updateint" data-placeholder="updateint" style="width: 100%;">
                  
                � 
                  � PC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:1185� getcrontabentry� P
                  select value, label from crontab_entries
                  � (
                  
                  � getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;��
 /� getId� $
 /� lucee/runtime/type/Query� getCurrentrow (I)I���� getRecordcount� $�� !lucee/runtime/util/NumberIterator� load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� �� isValid (I)Z��
�� current� $
�� go (II)Z���� %
                    <option value="� ">� _LABEL� �	 �� </option>
                  � removeQuery�  �� release &(Llucee/runtime/util/NumberIterator;)V��
�� <
                
                  

                  � Z
                  
                    
                      
                      � PC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:1199� Q
                      select value, label from crontab_entries where value != '� '
                      � 2
                        
                      � PC:\publish\hermes-seg-18.04\proprietary\2\edit_antivirus_signature_feed.cfm:1203� getdefaultcrontabentry� P
                      select value, label from crontab_entries where value = '� 
                      � '
                      <option value="� " selected="selected">� !</option>
                      � 

                      � Z

                                              
                  
                  � d


                      </select> 

              
        </div>





                � .       
  
                
               � �
                  <div class="form-group">
                    <label>Description</label>
                    <div class="textareacontainer">
                <textarea name="description" placeholder="Enter Feed Description" wrap="physical" rows="5">� 6</textarea>
                </div>   
              �� 
                  
                      </div> 
      </div>
    
    
    <div class="col-sm-4">
    
    <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
    </div>
      
    </form>
    <br>
  
        
  </div>
          




  <div>&nbsp;</div>

  ��
        
    <table class="table table-striped"  id="sortTable" style="width:100%">
      <thead>
        <tr>
          <th>Edit</th>    
          <th>Delete</th>
          <th>Name</th>
          <th>Save As</th>
          <th>Value</th>
          <th>Description</th>
          <th>Active</th>
          <th>FP Risk</th>
          <th>Type</th>
    
        </tr>
      </thead>
      <tbody>
    
       
    � 
    
      
      � �
       
        
        <tr>
    
    
          <td>
    
            <button a href="#edititem_modal"  type="button" id="delete" class="btn btn-secondary" data-toggle="modal" data-id="� " data-name="� " data-value="� " data-type="  " data-fp=" �"><i class="fas fa-edit"></i></button>
    
          </td>
    
          <td>
    
            <button a href="#delete_modal"  type="button" id="delete" class="btn btn-danger" data-toggle="modal" data-id=" j"><i class="fas fa-trash-alt"></i></button>
    
          </td>
    
    
    
    
    
    <td> </td>

    <td>
     	_FILENAME
 �	 � 
      	
        
   
         
   
          
          

         
          N/A
 
         

      </td>


    <td> </td>

    <td> !</td>
    
    <td>

  
     
       true! 
        YES
    # 
    NO

       
      % $
      N/A

 

        
      ' +



    
    </td>

    <td>

    ) 
    N/A

    + low- 
      LOW

    / medium1 
      MEDIUM

    3 high5 
      HIGH

      
    7 %

    </td>
    
    <td>

    9 
      DATABASE

    ; 
      FEED URL

    = variable? $
      VARIABLE


      
      A 4

    </td>
    
   
    
    
    
        C 3
    
    
    
      </tr>
    
    
      E�
      </tbody>
      
      <tfoot>
        <tr>
        
          <th>Edit</th>    
          <th>Delete</th>
          <th>Name</th>
          <th>Save As</th>
          <th>Value</th>
          
          <th>Description</th>
          <th>Active</th>
          <th>FP Risk</th>
          <th>Type</th>
    
        </tr>
      </tfoot>
     
    </table>
        
        
        G �
        
    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      I )No Malware Feed Items were found</strong>K  
    </div>
        
    
  Mi


</div>
</div>

</div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- Control Sidebar -->
<aside class="control-sidebar control-sidebar-dark">
<!-- Control sidebar content goes here -->
<div class="p-3">
  <h5>Title</h5>
  <p>Sidebar content</p>
</div>
</aside>
<!-- /.control-sidebar -->


O ./inc/main_footer.cfmQ

<!-- ./wrapper -->



</body>




     
<script>
  $('#delete_modal').on('show.bs.modal', function(e) {
      var id = $(e.relatedTarget).data('id');
      $(e.currentTarget).find('input[name="id"]').val(id);
  });
    </script>




 


</html>S udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException[  lucee/runtime/type/UDFProperties] udfs #[Llucee/runtime/type/UDFProperties;_`	 a setPageSourcec 
 d THEIDf lucee/runtime/type/KeyImplh intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;jk
il GETFEEDn ENABLEDp 
UPDATE_INTr DESCRIPTIONt 
first_namev 	last_namex access_controlz ACCESS_CONTROL| setpassword~ SETPASSWORD� hibp� HIBP� USERNAME� STEP� CHECKUSERNAME� EMAIL� 
FIRST_NAME� 	LAST_NAME� CHECKPASSWORDEXISTS� PASSWORD� NEXTSTEP� AUTHELIAPASS� THREAD� THEITEM� GETITEM� THEVALUE� THETYPE� THEFEED� FEED� THEUSER� THEUSERNAME� 	THEUSERID� THENAME� 	THESTATUS� THEUPDATEINT� GETDEFAULTCRONTABENTRY� THEDESCRIPTION� GETFEEDITEMS� FP� ACTIVE� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *�^�b*+�e�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  \: $  L�+-� 3+5� 9+;� 3+=� 9+?� 3+A� 9+C� 3+� F+H� 3� 
M+� K,�+� K+M� 3+O� 9+Q� 3+S+� X� ^N6+� X-� /`Y:� !� bY� dYf� hS� ln� q� u� v�N6+� xzS- { {� �+�� 3+�+� X� ^:6+� X� 0`Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3++� �� �� �� �� �� W+�� 3+� �� �� � �� �� � � ++�� 3+� �� �+� �� �� � � � W+�� 3� +�� 3� +�� 3+�+� X� ^:	6
+� X	� 0�Y:� !� bY� dYf� h�� ln� q� u� v�:	6
+� xz�	 { {
� �+¶ 3++� Ƹ �� �� �� �� ++�� 3+� �� �+� Ʋ ̹ � � � W+�� 3� +Ѷ 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� hӶ ln� q� u� v�:6+� xz� { {� �+¶ 3++� ׸ �� �� �� �� �+�� 3+�+� ײ ߹ � � � .+�� 3+� �*� �2+� ײ ߹ � � � W+�� 3� r+�� 3+� �� ��� � W+�� 3+�� 9+�� 3+� x���� �� �:� �W�� ��� :+� x��+� x�+�� 3+�� 3� �++� ׸ �� �� �� �� � � w+�� 3+� �� �� � W+�� 3+�� 9+�� 3+� x��� �� �:� �W�� ��� :+� x��+� x�+�� 3� +�� 3+� F+� x� ��:�� "�&�'6� �+�++-� 3+� x/13� ��5:+� �*� �2�6 �9;�>�?W�@� ��� :+� x��+� x�+�� 3�C���� $:�G� :� +�KW�N�� +�KW�N�O� ��� :+� x��+� x�� :+� K�+� K+Q� 3++� �*� �2�T �Z�]� � � w+�� 3+� �� �_� � W+�� 3+�� 9+�� 3+� x��a� �� �:� �W�� ��� :+� x��+� x�+�� 3� +Q� 3+c+� X� ^:6+� X� E++� �*� �2�T �f�iY:� "� bY� dYf� hc� ln� q� u� v�:6+� xzc { {� �+�� 3+k+� X� ^: 6!+� X � H++� �*� �2�T *� �2�iY:"� "� bY� dYf� hk� ln� q� u� v�": 6!+� xzk  { {!� �+�� 3+m+� X� ^:#6$+� X#� H++� �*� �2�T *� �2�iY:%� "� bY� dYf� hm� ln� q� u� v�%:#6$+� xzm# { {$� �+�� 3+o+� X� ^:&6'+� X&� H++� �*� �2�T *� �2�iY:(� "� bY� dYf� ho� ln� q� u� v�(:&6'+� xzo& { {'� �+�� 3+� F+� xq� ��:))�)s� )"�&)�'6**� �+)*�++u� 3+� x/1w� ��5:+++� �*� �2�6 �9+;�>+�?W+�@� ��� :,+� x+�,�+� x+�+?� 3)�C���� $:-)-�G� :.*� +�KW)�N.�*� +�KW)�N)�O� ��� :/+� x)�/�+� x)�� :0+� K0�+� K+y� 3+� �� ̹6 {� �� � �&|+}� 3++� Ƹ ���� �� �� � � y+�� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� �� �:11� �W1�� ��� :2+� x1�2�+� x1�+�� 3� +�� 3++� Ƹ ���� �� �� � � y+�� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� �� �:33� �W3�� ��� :4+� x3�4�+� x3�+�� 3� +�� 3++� Ƹ ���� �� �� � � y+�� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� �� �:55� �W5�� ��� :6+� x5�6�+� x5�+�� 3� +�� 3++� Ƹ �*� �2� �� �� � � y+�� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� �� �:77� �W7�� ��� :8+� x7�8�+� x7�+�� 3� +�� 3++� Ƹ �*� �2� �� �� � � y+�� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� �� �:99� �W9�� ��� ::+� x9�:�+� x9�+�� 3� +�� 3++� Ƹ �*� �2� �� �� � � {+�� 3+� �� ��� � W+�� 3+�� 9+�� 3+� x���� �� �:;;� �W;�� ��� :<+� x;�<�+� x;�+�� 3� �+�� 3+� �*� �2� � �� �� � � )+� �*� �2� � �� �� � � � � +�� 3� v+�� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� �� �:==� �W=�� ��� :>+� x=�>�+� x=�+�� 3+�� 3+�� 3++� Ƹ �*� �	2� �� �� � � y+�� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� �� �:??� �W?�� ��� :@+� x?�@�+� x?�+�� 3� �+�� 3+� �*� �
2� � �� �� � � )+� �*� �
2� � �� �� � � � � +�� 3� v+�� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� �� �:AA� �WA�� ��� :B+� xA�B�+� xA�+�� 3+�� 3+�� 3++� Ƹ �*� �2� �� �� � � y+�� 3+� �� �¹ � W+?� 3+�� 9+?� 3+� x��Ķ �� �:CC� �WC�� ��� :D+� xC�D�+� xC�+�� 3� �+�� 3+� �*� �2� � �� �� � � )+� �*� �2� � �� �� � � � � +�� 3� v+�� 3+� �� �ƹ � W+?� 3+�� 9+?� 3+� x��ȶ �� �:EE� �WE�� ��� :F+� xE�F�+� xE�+�� 3+�� 3+ʶ 3+� �*� �2� � �� �� � � �+Q� 3+� �*� �2�й � W+�� 3+� �� ��ӹ� W+Q� 3+� F+�� 3+� x��ڶ ���:GG�+� �*� �2�6 ����G��G��WG��� ��� :H+� xG�H�+� xG�+�� 3� :I+� KI�+� K+Q� 3� %+Q� 3+� �*� �2�� � W+�� 3+Q� 3+� �*� �2�6 �� �� � �'+Q� 3+�+� �*� �2� � ����]� � � �+Q� 3+� �*� �2�й � W+�� 3+� �� ���� W+Q� 3+� F+�� 3+� x���� ���:JJ�+� �*� �2�6 ����J��J��WJ��� ��� :K+� xJ�K�+� xJ�+�� 3� :L+� KL�+� K+�� 3� $+Q� 3+� �*� �2�ӹ � W+�� 3+�� 3� +�� 3+� �*� �2�6 � �� � ��+Q� 3+� F+� x� ��:MM�M� M"�&M�'6NN� �+MN�++� 3++� �*� �2� � ��
+� 3+� x/1� ��5:OO+� �*� �2�6 �9O;�>O�?WO�@� ��� :P+� xO�P�+� xO�+�� 3M�C��o� $:QMQ�G� :RN� +�KWM�NR�N� +�KWM�NM�O� ��� :S+� xM�S�+� xM�� :T+� KT�+� K+Q� 3++� �*� �2�T �Z�]� � �s+�� 3+� F+� x� ��:UU�U� U"�&U�'6VV� �+UV�++� 3++� �*� �2� � ��
+� 3+� x/1� ��5:WW+� �*� �2�6 �9W;�>W�?WW�@� ��� :X+� xW�X�+� xW�+�� 3U�C��o� $:YUY�G� :ZV� +�KWU�NZ�V� +�KWU�NU�O� ��� :[+� xU�[�+� xU�� :\+� K\�+� K+Q� 3+� �*� �2�� � W+Q� 3� �+Q� 3+� �*� �2�й � W+�� 3+� �� ���� W+Q� 3+� F+�� 3+� x�� � ���:]]�+� �*� �2�6 ����]��]��W]��� ��� :^+� x]�^�+� x]�+�� 3� :_+� K_�+� K+�� 3+�� 3� +�� 3+� �*� �2�6 "� �� � � (+� �*� �2� � �� �� � � � �k+Q� 3+$+� �*� �2� � � � � � �+Q� 3+� �*� �2�й � W+�� 3+� �� ���� W+Q� 3+� F+�� 3+� x��&� ���:``�+� �*� �2�6 ����`��`��W`��� ��� :a+� x`�a�+� x`�+�� 3� :b+� Kb�+� K+Q� 3�o+�� 3+� F+� x(� ��:cc�c� c"�&c�'6dd� �+cd�++*� 3++� �*� �2� � ��
+,� 3+� x/1.� ��5:ee+� �*� �2�6 �9e;�>e�?We�@� ��� :f+� xe�f�+� xe�+?� 3c�C��o� $:gcg�G� :hd� +�KWc�Nh�d� +�KWc�Nc�O� ��� :i+� xc�i�+� xc�� :j+� Kj�+� K+Q� 3+� �*� �2�1� � W+�� 3+Q� 3�+� �*� �2�6 "� �� � � (+� �*� �2� � �� �� � � � � �+Q� 3+� �*� �2�й � W+�� 3+� �� ��1�� W+Q� 3+� F+�� 3+� x��3� ���:kk�+� �*� �2�6 ����k��k��Wk��� ��� :l+� xk�l�+� xk�+�� 3� :m+� Km�+� K+�� 3� +�� 3+� �*� �2�6 5� �� � � (+� �*� �2� � �� �� � � � � �+Q� 3+� �*� �2�й � W+�� 3+� �� ��8�� W+Q� 3+� F+�� 3+� x��:� ���:nn�+� �*� �2�6 ����n��n��Wn��� ��� :o+� xn�o�+� xn�+�� 3� :p+� Kp�+� K+Q� 3�p+Q� 3+<+� �*� �2� � ����]� � � �+Q� 3+� �*� �2�й � W+�� 3+� �� ��?�� W+Q� 3+� F+�� 3+� x��A� ���:qq�+� �*� �2�6 ����q��q��Wq��� ��� :r+� xq�r�+� xq�+�� 3� :s+� Ks�+� K+Q� 3�p+C� 3+� F+� xE� ��:tt�t� t"�&t�'6uu� �+tu�++G� 3++� �*� �2� � ��
+,� 3+� x/1I� ��5:vv+� �*� �2�6 �9v;�>v�?Wv�@� ��� :w+� xv�w�+� xv�+?� 3t�C��o� $:xtx�G� :yu� +�KWt�Ny�u� +�KWt�Nt�O� ��� :z+� xt�z�+� xt�� :{+� K{�+� K+Q� 3+� �*� �2�?� � W+�� 3+�� 3+Q� 3+� �*� �2�6 K� �� � � (+� �*� �2� � �� �� � � � � �+Q� 3+� �*� �2�й � W+�� 3+� �� ��N�� W+Q� 3+� F+�� 3+� x��P� ���:||�+� �*� �2�6 ����|��|��W|��� ��� :}+� x|�}�+� x|�+�� 3� :~+� K~�+� K+R� 3�q+R� 3+<+� �*� �2� � ����]� � � �+�� 3+� �*� �2�й � W+�� 3+� �� ��U�� W+Q� 3+� F+�� 3+� x��W� ���:�+� �*� �2�6 ��������W��� ��� :�+� x���+� x�+�� 3� :�+� K��+� K+R� 3�q+C� 3+� F+� xY� ��:����� �"�&��'6��� �+���++[� 3++� �*� �2� � ��
+,� 3+� x/1]� ��5:��+� �*� �2�6 �9�;�>��?W��@� ��� :�+� x����+� x��+?� 3��C��o� $:����G� :��� +�KW��N���� +�KW��N��O� ��� :�+� x����+� x��� :�+� K��+� K+Q� 3+� �*� �2�8� � W+�� 3+�� 3+Q� 3+� �*� �2�6 _� �� � �r+�� 3+� F+� xa� ��:����� �"�&��'6��� �+���++c� 3++� �*� �2� � ��
+� 3+� x/1e� ��5:��+� �*� �2�6 �9�;�>��?W��@� ��� :�+� x����+� x��+�� 3��C��o� $:����G� :��� +�KW��N���� +�KW��N��O� ��� :�+� x����+� x��� :�+� K��+� K+Q� 3+� �*� �2�h� � W+�� 3� +�� 3+� �*� �2�6 j� �� � ��+Q� 3+� �*� �
2� � �� �� � �V+Q� 3+� F+� xl� ��:����n� �"�&��'6��� �+���++p� 3+� x/1r� ��5:��+� �*� �2�6 �9�;�>��?W��@� ��� :�+� x����+� x��+�� 3��C���� $:����G� :��� +�KW��N���� +�KW��N��O� ��� :�+� x����+� x��� :�+� K��+� K+Q� 3++� �*� �2�T *� �2�i�� �� � � �+�� 3+� �*� �2�й � W+�� 3+� �� ��u�� W+Q� 3+� F+�� 3+� x��w� ���:���+� �*� �2�6 ����������W���� ��� :�+� x����+� x��+�� 3� :�+� K��+� K+�� 3� $+Q� 3+� �*� �2�u� � W+�� 3+Q� 3� I+� �*� �
2� � �� �� � � '+Q� 3+� �*� �2�U� � W+�� 3� +y� 3� +�� 3+� �*� �2�6 {� �� � � (+� �*� �2� � �� �� � � � � �+Q� 3+� �*� �2�й � W+�� 3+� �� ��~�� W+Q� 3+� F+�� 3+� x���� ���:���+� �*� �2�6 ����������W���� ��� :�+� x����+� x��+�� 3� :�+� K��+� K+Q� 3�i+� �*� �2�6 {� �� � � (+� �*� �2� � �� �� � � � �+�� 3++� �*� �2� � ������ � � � � �+�� 3+� �*� �2�й � W+�� 3+� �� ����� W+Q� 3+� F+�� 3+� x���� ���:���+� �*� �2�6 ����������W���� ��� :�+� x����+� x��+�� 3� :�+� K��+� K+�� 3�++� �*� �2� � ������ � � � � �+�� 3+� �*� �2�й � W+�� 3+� �� ����� W+Q� 3+� F+�� 3+� x���� ���:���+� �*� �2�6 ����������W���� ��� :�+� x����+� x��+�� 3� :�+� K��+� K+R� 3� $+Q� 3+� �*� �2�N� � W+�� 3+�� 3� +Q� 3+� �*� �2�6 �� �� � � �+Q� 3+� �*� �2� � �� �� � � 5+�� 3+� �*� �2�~� � W+�� 3+�� 9+Q� 3� $+Q� 3+� �*� �2�~� � W+�� 3+�� 3� +Q� 3+� �*� �2�6 �� �� � � 6+Q� 3+�� 9+Q� 3+� �*� �2��� � W+�� 3� +Q� 3+� �*� �2�6 �� �� � �Z+Q� 3+� F+� x�� ��:����� �"�&��'6��� �+���++�� 3+++� �*� �2�6 ����
+�� 3+� x/1�� ��5:��+� �*� �2�6 �9�;�>��?W��@� ��� :�+� x����+� x��+�� 3��C��k� $:����G� :��� +�KW��N���� +�KW��N��O� ��� :�+� x����+� x��� :�+� K��+� K+Q� 3+�� 9+Q� 3+� �� ����� W+�� 3� C+� �*� �2+����� � W++� �*� �2�T ����Y���S��W+Ƕ 3+� F+�� 3+� x��ɶ ���:���+� �*� �2�6 ����������W���� ��� :�+� x����+� x��+�� 3� :�+� K��+� K+�� 3� +Q� 3+� �*� �2�6 ˸ �� � �8+�� 3+� F+� xͶ ��:����� �"�&��'6��� �+���++϶ 3+� x/1Ѷ ��5:��+� �*� �2�6 �9�;�>��?W��@� ��� :�+� x����+� x��+?� 3��C���� $:����G� :��� +�KW��N���� +�KW��N��O� ��� :�+� x����+� x��� :�+� K��+� K+R� 3+�� 9+Q� 3+� �� ����� W+�� 3� C+� �*� �2+����� � W++� �*� �2�T ����Y���S��W+�� 3+� F+�� 3+� x��Ӷ ���:���+� �*� �2�6 ����������W���� ��� :�+� x����+� x��+�� 3� :�+� K��+� K+�� 3� +�� 3�
�+� �� ̹6 ո �� � ��+�� 3++� Ƹ �� �� �� �� � � {+׶ 3+� �� �ٹ � W+�� 3+�� 9+�� 3+� x��۶ �� �:��� �W��� ��� :�+� x����+� x��+׶ 3�++� Ƹ �� �� �� �� �+ݶ 3+� Ʋ ߹ � �� �� � � {+�� 3+� �� �߹ � W+�� 3+�� 9+�� 3+� x��� �� �:��� �W��� ��� :�+� x����+� x��+ݶ 3� N+� Ʋ ߹ � �� �� � � 1+�� 3+� �*� �2+� Ʋ ߹ � � � W+� 3� +� 3� +Q� 3+� F+� x� ��:����� �"�&��'6��� �+���++� 3+� x/1� ��5:��+� �*� �2�6 �9�;�>¶?W¶@� ��� :�+� x¶ÿ+� x¶+�� 3��C���� $:��ĶG� :��� +�KW��Nſ�� +�KW��N��O� ��� :�+� x��ƿ+� x��� :�+� Kǿ+� K+Q� 3++� �*� �2�T �Z�]� � �+Q� 3+� �*� �2++� �*� �2�T ��i� � W+�� 3+� �*� �2++� �*� �2�T ��i� � W+�� 3+� �*� �2++� �*� �2�T *� �2�i� � W+� 3+�� 9+Q� 3+� �*� �2�6 �� �� � � +�� 3+�� 9+Q� 3� >+� �*� �2�6 �� �� � � +�� 3+� 9+� 3� +Q� 3+� 9+�� 3+�� 9+�� 3+� �� ���� W+}� 3� C+� �*� �2+����� � W++� �*� �2�T ����Y���S��W+�� 3+� F+�� 3+� x��� ���:��	�����ȶ�Wȶ�� ��� :�+� xȶɿ+� xȶ+�� 3� :�+� Kʿ+� K+�� 3� u+�� 3+� �� �� � W+?� 3+�� 9+?� 3+� x��� �� �:�˶ �W˶� ��� :�+� x˶̿+� x˶+�� 3+Q� 3��+� �� ̹6 � �� � ��+�� 3++� Ƹ ��� �� �� � � {+׶ 3+� �� �� � W+�� 3+�� 9+�� 3+� x��� �� �:�Ͷ �WͶ� ��� :�+� xͶο+� xͶ+׶ 3�++� Ƹ ��� �� �� �+ݶ 3+� Ʋ� � �� �� � � {+�� 3+� �� �� � W+�� 3+�� 9+�� 3+� x��� �� �:�϶ �W϶� ��� :�+� x϶п+� x϶+ݶ 3� N+� Ʋ� � �� �� � � 1+�� 3+� �*� �2+� Ʋ� � � � W+� 3� +� 3� +Q� 3+� F+� x� ��:����!� �"�&Ѷ'6��� �+�Ҷ++#� 3+� x/1%� ��5:��+� �*� �2�6 �9�'�>Ӷ?WӶ@� ��� :�+� xӶԿ+� xӶ+�� 3ѶC���� $:��նG� :��� +�KWѶNֿ�� +�KWѶNѶO� ��� :�+� xѶ׿+� xѶ� :�+� Kؿ+� K+Q� 3++� �*� �2�T �Z�]� � �d+Q� 3+� �*� �2++� �*� �2�T �f�i� � W+�� 3+� �*� � 2++� �*� �2�T � ߶i� � W+Q� 3+� 9+Q� 3+� �� ��*�� W+�� 3� C+� �*� �2+����� � W++� �*� �2�T ����Y���S��W+�� 3+� F+�� 3+� x��,� ���:���+� �*� �2�6 �������ٶ�Wٶ�� ��� :�+� xٶڿ+� xٶ+�� 3� :�+� Kۿ+� K+�� 3� u+�� 3+� �� �� � W+?� 3+�� 9+?� 3+� x��.� �� �:�ܶ �Wܶ� ��� :�+� xܶݿ+� xܶ+�� 3+0� 3� +�� 3+� �� ��6 �� �� � � F+2� 3+� F+4� 3� :�+� K޿+� K+6� 3+� �� ��й� W+Q� 3� +Q� 3+� �� ��6 � �� � � F+8� 3+� F+:� 3� :�+� K߿+� K+6� 3+� �� ��й� W+Q� 3� +Q� 3+� �� ��6 "� �� � � F+8� 3+� F+<� 3� :�+� K�+� K+6� 3+� �� ��й� W+Q� 3� +�� 3+� �� ��6 5� �� � � F+8� 3+� F+>� 3� :�+� K�+� K+6� 3+� �� ��й� W+Q� 3� +�� 3+� �� ��6 K� �� � � F+8� 3+� F+@� 3� :�+� K�+� K+6� 3+� �� ��й� W+Q� 3� +�� 3+� �� ��6 _� �� � � F+8� 3+� F+B� 3� :�+� K�+� K+6� 3+� �� ��й� W+Q� 3� +Q� 3+� �� ��6 {� �� � � F+8� 3+� F+D� 3� :�+� K�+� K+6� 3+� �� ��й� W+Q� 3� +Ѷ 3+� �� ��6 �� �� � � F+8� 3+� F+F� 3� :�+� K�+� K+6� 3+� �� ��й� W+Q� 3� +Q� 3+� �� ��6 �� �� � � F+8� 3+� F+H� 3� :�+� K�+� K+6� 3+� �� ��й� W+Q� 3� +Q� 3+� �� ��6 �� �� � � F+8� 3+� F+J� 3� :�+� K�+� K+6� 3+� �� ��й� W+Q� 3� +�� 3+� �� ��6 ˸ �� � � F+8� 3+� F+L� 3� :�+� K�+� K+6� 3+� �� ��й� W+Q� 3� +�� 3+� �� ��6 N� �� � � F+8� 3+� F+P� 3� :�+� K�+� K+6� 3+� �� ��й� W+Q� 3� +�� 3+� �� ��6 R� �� � � F+T� 3+� F+V� 3� :�+� K�+� K+X� 3+� �� ��й� W+Q� 3� +Q� 3+� �� ��6 Z� �� � � F+\� 3+� F+^� 3� :�+� K�+� K+`� 3+� �� ��й� W+�� 3� +b� 3+� �� ��6 d� �� � � E+f� 3+� F+h� 3� :�+� K�+� K+j� 3+� �� ��й� W+�� 3� +�� 3+� �� ��6 l� �� � � F+n� 3+� F+p� 3� :�+� K��+� K+r� 3+� �� ��й� W+Q� 3� +t� 3+� F+v� 3+++� �*� �2�T �f�i�� 3+x� 3� :�+� K�+� K+z� 3+|� 3+� F+~� 3++� �*� �!2�6 �� 3+�� 3� :�+� K�+� K+�� 3+� �*� �"2�6 �� �� � � +�� 3� /+� �*� �"2�6 �� �� � � +�� 3� +�� 3+� F+�� 3+� �*� �#2�6 �� �� � ��+�� 3+� F+� x�� ��:������ �"�&�'6��� O+��++�� 3�C��� $:���G� :��� +�KW�N��� +�KW�N�O� ��� :�+� x���+� x�� :�+� K��+� K+�� 3+� F+���:�+��6����� 6���� � � � �6����� ��:�+� ���� �d6���`��� d������� � � � � H���6�+�� 3++� ���6 �� 3+�� 3++� ��Ĺ6 �� 3+ƶ 3���� ":������ W+� ��� ���������� W+� ��� ��ͧ :�+� K��+� K+϶ 3�+Ѷ 3+� F+� xӶ ���: � �� �� � "�&� �'�6�� �+� ��++ն 3++� �*� �#2�6 ��
+׶ 3� �C��ӧ 2�:� ��G�  �:�� +�KW� �N���� +�KW� �N� �O� ��� �:+� x� ���+� x� �� �:+� K��+� K+ٶ 3+� F+� x۶ ���:���ݶ �"�&��'�6�� �+���++߶ 3++� �*� �#2�6 ��
+׶ 3��C��ӧ 2�:���G�  �:	�� +�KW��N�	��� +�KW��N��O� ��� �:
+� x���
�+� x��� �:+� K��+� K+� 3+� F+� 3+++� �*� �$2�T ��i�� 3+� 3+++� �*� �$2�T �Ķi�� 3+� 3� �:+� K��+� K+� 3+� F+����:+���6���� �6��� � � � ��6���� ���:+� ���� �d�6��`��� n������� � � � � L����6+� 3++� ���6 �� 3+�� 3++� ��Ĺ6 �� 3+� 3���� .�:����� W+� ��� ���������� W+� ��� ��ͧ �:+� K��+� K+� 3+�� 3� �:+� K��+� K+� 3+� F+� 3++� �*� �%2�6 �� 3+� 3� �:+� K��+� K+�� 3++� �*� �&2�T �Z�]� � �o+�� 3+s���:+���6���� �6��� � � �%�6���� ���:+� ���� �d�6 �� `����������� � � � �s����6 +�� 3+� F+�� 3++� �� ߹6 �� 3+�� 3++� ��f�6 �� 3+�� 3++� ���6 �� 3+� 3++� ���6 �� 3+� 3++� �*� �'2�6 �� 3+� 3++� �� ߹6 �� 3+� 3++� ��f�6 �� 3+	� 3+� ���6 �� �� � � v+�� 3+� ���6 �� �� � � '+� 3++� ��f�6 �� 3+� 3� $+� 3++� ���6 �� 3+� 3+� 3� 
+� 3+� 3++� ���6 �� 3+� 3++� �*� �2�6 �� 3+� 3+� ���6 �� �� � � G+ � 3+� �*� �(2�6 "� �� � � +$� 3� 
+&� 3+׶ 3� 
+(� 3+*� 3+� �*� �'2�6 �� �� � � +,� 3� �+� �*� �'2�6 .� �� � � +0� 3� [+� �*� �'2�6 2� �� � � +4� 3� /+� �*� �'2�6 6� �� � � +8� 3� +:� 3+� ���6 �� �� � � +<� 3� S+� ���6 �� �� � � +>� 3� ++� ���6 @� �� � � +B� 3� +D� 3� �:!+� K�!�+� K+F� 3��a� .�:"����� W+� ��� ����"������ W+� ��� ���+H� 3� W++� �*� �&2�T �Z�]� � � 3+J� 3+� F+L� 3� �:#+� K�#�+� K+N� 3� +P� 3+R� 9+T� 3� � 1 : :  !88  ���  V��  9�� )9��  ��  �  ���  BB  �hk )�tw  ���  ���  	Z	q	q  	�



  
�
�
�  (??  ���  d{{  7NN  ���  ���  Lcc  66  �  �55   ZZ  zz  j��  /�� )/��    �""  �  �9< )�EH  z~~  d��  "\\  ||  j��  N��  a��  &�� )&��  ���  �  �..  �NN  GG  �gg  AA  �aa  �22  �X[ )�dg  ���  ���  ���  y��  ���  r��   � � �   K � � ) K � �    !$!$   
!>!>  "#"V"V  !�"|" )!�"�"�  !�"�"�  !�"�"�  #�#�#�  #�$ $# )#�$,$/  #$e$e  #i$$  %%P%P  $�%p%p  &�&�&�  &�''  '�(+(+  '�(K(K  (�) )   (�)@)@  +?+r+r  + +�+� )+ +�+�  *�+�+�  *�+�+�  ,�,�,�  ,,�,�  -�-�-�  -�-�-� )-�..  -U.;.;  -?.U.U  .�/2/2  .�/R/R  /�0
0
  0�0�0�  1�1�1�  1|1�1� )1|1�2  1Q2828  1;2R2R  4K4p4p  4/4�4�  4�4�4�  5�5�5�  6S6j6j  7I7}7}  7,7�7� )7,7�7�  77�7�  6�88  9*9d9d  99�9�  9�9�9�  :E:O:O  :�:�:�  ;;;  ;|;�;�  ;�;�;�  <J<T<T  <�<�<�  ==#=#  =�=�=�  =�=�=�  >P>Z>Z  >�>�>�  ??(?(  ?�?�?�  ?�?�?�  @T@^@^  @�@�@�  @�AA  A�BB
 )A�BB  A�BLBL  A�BfBf  B�C=C=  B~CyCy  C�DD! )C�D0D3  C�DwDw  C�D�D�  EE8E; )EEJEM  D�E�E�  D�E�E�  E�F#F#  F�G&G&  F?GvGv  A�G�G�  G�G�G�  H�LL  H�L-L-  L�L�L�   �         * +  �  
&�           R  S * U - \ 4 ] E a H c K u U w X } �  �/ �R �q �w �z �� �� �� �� �� � �$ �' �* �� �� �� �� �� �� � �R �U �X �} �� �� �� �� �� �= �� � �H �^ �k �� �� �6 �� �. �� �� �\ �� �� �� �	  �	  �	6 �	C �	� �	� �	� �	� �	� �	� �
% �
+ �
/ �
R �
h �
u �
� �
� 
�
�Z	`
d�����(?M��� �"# $i&l'p)s*w-�/�0�1
35g7q9�:�;�=�>�@�A�DF(G5H~J�L�N�P�QRQTTUXW[X_Zb]�_�`�b�c/dFfPhkjnkrm�o�q�r�tutv�y�{�}�~��������3���3�]�`�����-�����������	�v��������������0�G�Q���������*�H���*�D�G�K���������H�^�d�g���������a�x�����������[�r�|������L�������������A�[�r�|��� �
�:�T ku��  	 O m �!O!j!m!q!t!x!�!�!�"
"p "�"#%#&#)#9+#b-#�.$/$�1$�2$�3$�5$�6%j7%�9%�:%�<%�>%�?%�A%�C%�E%�F%�I&J&M&VO&pP&�R&�S&�T'V'iX'lY'�Z'�['�]'�^(E_([a(ab(�c(�d(�f(�g):h)Qj)[l)un)xo){q)�r)�t)�v)�x)�y)�{)�|)�~*	�*#�*&�*)�*/�*3�*\�*k�*��*��*��*��+�+&�+��,�,�,-�,0�,4�,O�,t�,x�,��,��-�-�-�-8�-��-��.f�.u�.��.��.��.��.��.��.��/L�/c�/i�/l�/��/��/��/��0%�0C�0g�0~�0��0��0��1 �1&�1*�10�14�1��1��2c�2��2��2��3�3 �3,�3U�3X�3d�3��3��3��3��3��3��3��3��3��3� 4 4%4(424�4�
4�4�4�5555D5g5~5�5�5�66.6< 6�"6�#6�%6�&6�(6�)6�+70,7�-8/8=18j28�48�68�88�98�:8�;9<9>9?9~@9�D9�F9�G9�H:	J:K:O:P:R:W:>Y:A\:`]:c_:wa:�c:�e:�h:�i:�k:�m:�o;q;t;0u;3w;Gy;P|;u~;x�;��;��;��;��;��;��;��<�<�<�<C�<F�<e�<h�<|�<��<��<��<��<��<��<��=�=�=4�=7�=K�=U�=z�=}�=��=��=��=��=��=��>�>�>�>$�>I�>L�>k�>n�>��>��>��>��>��>��>��>��?�?�?9�?<�?P�?Z�??�?�?�?�
?�?�?�@	@@@(@M@P @o!@r#@�%@�)@�6@�7@�8@�9@�:@�|@�}A~AA�A �AF�AL�Ar�Ax�A|�A�A��A��A��A��Bw�C �C:�C��C��C��D�D��E�E*�E��E��F4�F8�F��G#�G��G��G��G��G��G��G��G��G��G��H�H H�H�H�I]IwI�I�I�I�I�!J#J$J&J&(J))J-+J0.JJ0Jg5J�6J�8J�;J�<J�>J�CJ�DJ�IJ�MJ�PK(SKTVK�YK�ZK�\K�`K�cK�fK�jLkL	mL sL$wL*zL~{L��L��L��L��L��L��L��L���     ) UV �        �    �     ) WX �         �    �     ) YZ �        �    �    \    �  �    �*)� �Yg�mSYo�mSYq�mSYs�mSYu�mSYw�mSYy�mSY{�mSY}�mSY	�mSY
��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY��mSY ��mSY!��mSY"��mSY#��mSY$��mSY%��mSY&��mSY'��mSY(��mS� �     �    