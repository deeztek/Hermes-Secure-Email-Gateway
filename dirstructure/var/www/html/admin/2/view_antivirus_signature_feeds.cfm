����   2� ]__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_antivirus_signature_feeds_cfm$cf  lucee/runtime/PageImpl  O../../publish/hermes-seg-18.04/proprietary/2/view_antivirus_signature_feeds.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  �ؿp� getSourceLength      �b getCompileTime  �\��{ getHash ()Iආ� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this _L__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_antivirus_signature_feeds_cfm$cf; �<!DOCTYPE html>


 

<html lang="en">


<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Antivirus Signature Feeds</title>

   , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 ./inc/html_head.cfm 4 	doInclude (Ljava/lang/String;Z)V 6 7
 / 8

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
  td {
   word-break: break-all;
       },

body{
 padding:100px 0;
 background-color:#efefef
}

a, a:hover{
 color:#333
}

</style>
  


<style>
  th { font-size: 16px; }
td { font-size: 16px; }
</style>


 
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



   : ./inc/top_navbar.cfm < 
   > ./inc/main_sidebar.cfm @ �

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <div class="content-header">
<div class="container-fluid">
  <div class="row mb-2">
    <div class="col-sm-6">
 B outputStart D 
 / E 5
<h1 class="m-0">Antivirus Signature Feeds</h1>

     G 	outputEnd I 
 / J�

    </div><!-- /.col -->
    <div class="col-sm-6">
<ol class="breadcrumb float-sm-right">
  <li class="breadcrumb-item"><a href="#">Home</a></li>
  <li class="breadcrumb-item active">Antivirus Signature Feeds</li>
</ol>
    </div><!-- /.col -->
  </div><!-- /.row -->
</div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
<div class="container-fluid">

  

   L ./inc/lc1.cfm N 



    
 
    
   P m R &lucee/runtime/config/NullSupportHelper T NULL V '
 U W -lucee/runtime/interpreter/VariableInterpreter Y getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; [ \
 Z ] 0 _ %lucee/runtime/exp/ExpressionException a java/lang/StringBuilder c The required parameter [ e  1
 d g append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; i j
 d k ] was not provided. m -(Ljava/lang/String;)Ljava/lang/StringBuilder; i o
 d p toString ()Ljava/lang/String; r s
 d t
 b g lucee/runtime/PageContextImpl w any y�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V } ~
 x  sessionScope $()Llucee/runtime/type/scope/Session; � �
 / � lucee/runtime/op/Caster � toStruct /(Ljava/lang/Object;)Llucee/runtime/type/Struct; � �
 � � $lucee/runtime/type/util/KeyConstants � _m #Llucee/runtime/type/Collection$Key; � �	 � � !lucee/runtime/type/Collection$Key � .lucee/runtime/functions/struct/StructKeyExists � \(Llucee/runtime/PageContext;Llucee/runtime/type/Struct;Llucee/runtime/type/Collection$Key;)Z & �
 � � _M � �	 � �  lucee/runtime/type/scope/Session � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � �   � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � us &()Llucee/runtime/type/scope/Undefined; � �
 / � "lucee/runtime/type/scope/Undefined � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � � 

  
  

  
   � 

  
   � 

  



 � step � 
    
 � action �  
 � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _action � �	 � � 
 � _ACTION � �	 � � lucee/runtime/type/scope/Form � � � 


 �   

 � lucee.runtime.tag.Query � cfquery � PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:186 � use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; � �
 x � lucee/runtime/tag/Query � hasBody (Z)V � �
 � � checkstatus � setName � 1
 � � hermes � setDatasource (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � g
select value2 from parameters2 where parameter='firewall_status' and module='firewall' and active='1'
 � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � 
 / 	doFinally 
 � doEndTag $
 � lucee/runtime/exp/Abort	 newInstance (I)Llucee/runtime/exp/Abort;

 reuse !(Ljavax/servlet/jsp/tagext/Tag;)V
 x 
  
   firewall_status keys $[Llucee/runtime/type/Collection$Key;	  getCollection � � I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �
 /  
  ! 
  

# 


  % PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:202' getsignaturefeeds) F
select id, name, enabled, update_int, description from malware_feeds
+ 



- � � 10 �

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    2 3The IP Address you entered is invalid (Error Code: 4 &(Ljava/lang/Object;)Ljava/lang/String; r6
 �7 )9 
  </div>

  ; #lucee/commons/color/ConstantsDouble= _0 Ljava/lang/Double;?@	>A � � 

D 2F FThe IP Address you are attempting to edit already exists (Error Code: H 3J �You cannot delete the IP that you are accessing the system with while the Antivirus Signature Feeds is enabled. Please disable the firewall and try the operation again (Error Code: L 4N �You cannot edit the IP Address that you are accessing the system with while the Console Firewall is enabled. Please disable the firewall and try the operation again (Error Code: P 5R �You cannot enable the Antivirus Signature Feeds unless the IP you are accessing the system with is in the allowed IP address list below and <strong>Allow to Hermes Admin</strong> is set to <strong>YES</strong>  (Error Code: T 6V EThe IP Address you are attempting to add already exists (Error Code: X 7Z AThe IP Address you are attempting to add is invalid (Error Code: \ 33^ �
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    ` �IP Address Edited successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.ba<br><br>

    <form action="" method="post">
      <input type="hidden" name="action" value="apply">
                           
      <div class="text-center">
      <button type="submit" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Apply Settings</button>
      </div>
      </form>

  </div>

  d 
  
f 34h �IP Address Deleted successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect.j 35l �The Antivirus Signature Feeds was Enabled successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect. n 36p �The Antivirus Signature Feeds was Disabled successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect. r 37t �The IP Address was added successfully. You must click on the <strong>Apply Settings</strong> button below for the changes to take effect. v 38x 8Antivirus Signature Feeds Settings applied successfully.z 






<span>
  <p> 



| �
<a href="#addip_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="" data-recipientemail=""><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add IP Address</a>
~�


</p>


</span>







<div class="modal fade" id="addip_modal" tabindex="-1" role="dialog" aria-labelledby="AddIpModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  
    <h4 class="modal-title">Add IP Address </h4>
</div>
  
<div class="modal-body">
  

  <form name="AddIpAddress" autocomplete="off" method="post">

    <input type="hidden" name="action" value="addip">

    � �
      <div class="form-group">
        <label for="username"><strong>IP Address</strong></label>
        <input type="text" class="form-control" name="ip_address" value="" id="ip_address" placeholder="IP Address" maxLength="20">
      </div>
      ��

      
        <div class="form-group">
          <label><strong>Allow to Hermes Admin</strong></label>
            
          <select class="form-control" name="ip_hermesadmin" data-placeholder="hermesadmin" style="width: 100%;" id="hermesadmin">
             
              <option value="yes" selected>YES</option>
              <option value="no">NO</option>
           
              </select>   
            
            </div>

                  
        <div class="form-group">
          <label><strong>Allow to Ciphermail Admin</strong></label>
            
          <select class="form-control" name="ip_ciphermailadmin" data-placeholder="ciphermailadmin" style="width: 100%;"  id="ciphermailadmin">
             
              <option value="yes" selected>YES</option>
              <option value="no">NO</option>
           
              </select>   
            
            </div>
            

            �
              <div class="form-group">
                <label><strong>Note</strong></label>
                <input type="text" class="form-control" name="ip_note" value="" id="ip_note" placeholder="Enter Note" maxLength="255">
              </div>
              �j

    <div>&nbsp;</div>

    <input type="submit" value="Submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  </form>

</div>


<div class="modal-footer">
 
<button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>

</div>
    </div>
  </div>
</div>





   

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteCertificateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  
    <h4 class="modal-title">Delete IP Address </h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you send to delete this IP Address from the Antivirus Signature Feeds? This action is irreversible! </p>

</div>
<div class="modal-footer">
  <form name="DeleteIpAddress" method="post">

    <input type="hidden" name="action" value="deleteip">
    <input type="hidden" name="ip_id" value=""/>
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
�l</form>
  <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>





<div class="modal fade" id="editip_modal" tabindex="-1" role="dialog" aria-labelledby="editIpModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  
    <h4 class="modal-title">Edit IP Address </h4>
</div>
  
<div class="modal-body">
  

  <form name="EditIpAddress" autocomplete="off" method="post">

    <input type="hidden" name="action" value="editip">
    <input type="hidden" name="ip_id" value=""/>

    �R

    <div>&nbsp;</div>

    <input type="submit" value="Submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  </form>

</div>


<div class="modal-footer">
 
<button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>

</div>
    </div>
  </div>
</div>




� editip� [^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$� 

  

  
  � 

    � 
    � +Edit Firewall IP: form.ip_id does not exist� ./inc/error.cfm� lucee.runtime.tag.Abort� cfabort� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:644� lucee/runtime/tag/Abort�
� �
� 

      � 

        
    � %Edit Firewall IP: form.ip_id is blank� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:654� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:658� getipaddress� )
        select * from firewall where id=� lucee.runtime.tag.QueryParam� cfqueryparam� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:659� lucee/runtime/tag/QueryParam� setValue� �
�� CF_SQL_INTEGER� setCfsqltype� 1
��
� �
� 	
        � 
        

    � #lucee/runtime/util/VariableUtilImpl� recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;��
�� (Ljava/lang/Object;D)I ��
 �� /Edit Firewall IP: getipaddress.recordcount LT 1� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:668� 


    
    � 

    
    � 


  
  
  � 0Edit Firewall IP: form.ip_address does not exist� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:687� %lucee/runtime/functions/string/REFind� S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object; &�
�� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:694� checkipaddress� )
select id, ip from firewall where ip = '� writePSQ� �
 /� ' and id <> � PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:695� _2�@	>� lucee.runtime.tag.Location� 
cflocation� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:704� lucee/runtime/tag/Location� view_console_firewall.cfm� setUrl  1
� setAddtoken �
�
� �
� _1@	>	 PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:716 

  
 


  

 4Edit Firewall IP: form.ip_hermesadmin does not exist PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:732 yes no 

   3Edit Firewall IP: form.hermesadmin is not yes or no PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:742 8Edit Firewall IP: form.ip_ciphermailadmin does not exist PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:755! 7Edit Firewall IP: form.ciphermailadmin is not yes or no# PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:765% PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:777' getip) (
  select ip from firewall
  where id = + PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:779- &lucee/runtime/functions/string/Compare/ B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/String;)D &1
02 toRef (D)Ljava/lang/Double;45
 �6 -18 PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:788: updateipaddress< (
    update firewall
    set 
    ip = '> #lucee/runtime/functions/string/Trim@ A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; &B
AC ',
    hermesadmin = 'E ',
    ciphermailadmin = 'G ',
    note = 'I '
    where id = K PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:795M _33O@	>P PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:801R enabledT _4V@	>W PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:810Y PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:815[ .
      update firewall
      set 
      ip = '] ',
      hermesadmin = '_ ',
      ciphermailadmin = 'a ',
      note = 'c '
      where id = e PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:822g 
      i 
      
      k PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:827m 
      

  o addipq 

  


  
  s /Add Firewall IP: form.ip_address does not existu PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:853w PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:860y %
select ip from firewall where ip = '{ '
} _6@	>� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:870� _7�@	>� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:882� 3Add Firewall IP: form.ip_hermesadmin does not exist� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:898� 2Add Firewall IP: form.hermesadmin is not yes or no� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:908� 7Add Firewall IP: form.ip_ciphermailadmin does not exist� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:921� 6Add Firewall IP: form.ciphermailadmin is not yes or no� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:931� 

  


    � PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:942� insertipaddress� \
     insert into firewall
     (ip, hermesadmin, ciphermailadmin, note)
     values
     ('� ', '� 	')
      � _37�@	>� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:951� deleteip� 	

   
   � -Delete Firewall IP: form.ip_id does not exist� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:962� 'Delete Firewall IP: form.ip_id is blank� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:972� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:976� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:977� 1Delete Firewall IP: getipaddress.recordcount LT 1� PC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:986� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1000� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1002� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1011� )
    delete from firewall
    where id = � QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1013� 

    
    � _34�@	>� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1018� _3�@	>� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1027� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1032� -
      delete from firewall
      where id = � QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1034� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1039� 
   

  
  � setfirewall� 

  


� BSet Antivirus Signature Feeds: form.firewall_status does not exist� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1060� disabled� NSet Antivirus Signature Feeds: form.firewall_status is not enabled or disabled� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1070� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1083� checkcurrent� #
select ip from firewall where ip='� ' and hermesadmin = 'yes'
� _5�@	>� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1093� QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1098� updatestatus�  
update parameters2 set value2='� I' where parameter='firewall_status' and module='firewall' and active='1'
� _35@	> QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1106 QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1114 _36@	>	 QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1122 
 

 apply &./inc/generate_nginx_configuration.cfm _38@	> QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1138 



  
 


  






        
<table class="table table-striped"  id="sortTable" style="width:100%">
  <thead>
    <tr>
      <th>Edit</th>    
      <th>Delete</th>
      <th>Name</th>
      <th>Description</th>
      <th>Status</th>
      <th>Update Interval</th>

    </tr>
  </thead>
  <tbody>

   
 getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;
 /  getId" $
 /# lucee/runtime/type/Query% getCurrentrow (I)I'(&) getRecordcount+ $&, !lucee/runtime/util/NumberIterator. load '(II)Llucee/runtime/util/NumberIterator;01
/2 addQuery (Llucee/runtime/type/Query;)V45 �6 isValid (I)Z89
/: current< $
/= go (II)Z?@&A M
   
    
    <tr>


      <td><a href="edit_antivirus_signature_feed.cfm?id=C _IDE �	 �F �" class="btn btn-secondary" role="button"><i class="fas fa-edit"></i></a></td>

      <td>

        <button a href="#delete_modal"  type="button" id="delete" class="btn btn-danger" data-toggle="modal" data-ip="H B"><i class="fas fa-trash-alt"></i></button>

      </td>





<td>J _NAMEL �	 �M 
</td>
<td>O </td>
<td>
Q 	
ENABLED
S 

DISABLED
U 	

</td>

W QC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_signature_feeds.cfm:1201Y getcrontabentry[ ;
  select value, label from crontab_entries where value = '] '
  _ 
  <td>a _LABELc �	 �d 	</td> 
  f 
    <td>N/A</td> 

  
  h 






    j 



  </tr>


  l removeQueryn  �o release &(Llucee/runtime/util/NumberIterator;)Vqr
/s �
  </tbody>
  
  <tfoot>
    <tr>
    
      <th>Edit</th>    
      <th>Delete</th>
      <th>Name</th>
      <th>Description</th>
      <th>Status</th>
      <th>Update Interval</th>

    </tr>
  </tfoot>
 
</table>
    
    
    u �
    
<div class="alert alert-danger alert-dismissible">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-ban"></i> Oops!</h4>
  w 4No Antivirus Signature Feeds IPs were found</strong>y 
</div>
    

    {V
    
    
   
    
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


} ./inc/main_footer.cfm�

<!-- ./wrapper -->



</body>


<script>
  $('#editip_modal').on('show.bs.modal', function(e) {
var ip_id = $(e.relatedTarget).data('ip');
$(e.currentTarget).find('input[name="ip_id"]').val(ip_id);

var ip_address = $(e.relatedTarget).data('address');
$(e.currentTarget).find('input[name="ip_address"]').val(ip_address);

var ip_note = $(e.relatedTarget).data('note');
$(e.currentTarget).find('input[name="ip_note"]').val(ip_note);

var ip_hermesadmin = $(e.relatedTarget).data('hermesadmin');
$(e.currentTarget).find('input[name="ip_hermesadmin"]').val(ip_hermesadmin);

var ip_ciphermailadmin = $(e.relatedTarget).data('ciphermailadmin');
$(e.currentTarget).find('input[name="ip_ciphermailadmin"]').val(ip_ciphermailadmin);

  });


    </script>




<script>
  $('#delete_modal').on('show.bs.modal', function(e) {
var ip_id = $(e.relatedTarget).data('ip');
$(e.currentTarget).find('input[name="ip_id"]').val(ip_id);
  });
    </script>





</html>� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � CHECKSTATUS� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� VALUE2� FIREWALL_STATUS� PATTERN� ip_id� STEP� IP_ID� GETIPADDRESS� 
ip_address� 
IP_ADDRESS� CHECKIPADDRESS� ip_hermesadmin� IP_HERMESADMIN� ip_ciphermailadmin� IP_CIPHERMAILADMIN� GETIP� 
COMPARE_IP� IP� CLIENTIP� IP_NOTE� CHECKCURRENT� GETSIGNATUREFEEDS� DESCRIPTION� ENABLED� 
UPDATE_INT� GETCRONTABENTRY� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile               ��       �   *     *� 
*� *� � *����*+���        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  H�  �  <+-� 3+5� 9+;� 3+=� 9+?� 3+A� 9+C� 3+� F+H� 3� 
M+� K,�+� K+M� 3+O� 9+Q� 3+S+� X� ^N6+� X-� /`Y:� !� bY� dYf� hS� ln� q� u� v�N6+� xzS- { {� �+?� 3++� �� �� �� �� �� W+?� 3+� �� �� � �� �� � � ++?� 3+� �� �+� �� �� � � � W+�� 3� +�� 3� +�� 3+�+� X� ^:6+� X� 0`Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3+�+� X� ^:	6
+� X	� 0�Y:� !� bY� dYf� h�� ln� q� u� v�:	6
+� xz�	 { {
� �+�� 3++� ĸ �� �� �� �� W+ɶ 3+� Ĳ ̹ � �� �� � � ++ɶ 3+� �� �+� Ĳ ̹ � � � W+Ѷ 3� +Ѷ 3� +Ӷ 3+� F+� x��ٶ �� �:� �� �� �� �6� N+� �+�� 3� ����� $:� �� :� +�W��� +�W��� ��� :+� x��+� x�� :+� K�+� K+� 3++� X� ^:6+� X� H++� �*�2� *�2� Y:� "� bY� dYf� h� ln� q� u� v�:6+� xz { {� �+"� 3++� ĸ �*�2� �� �� b+?� 3+� �*�2� � �� �� � � 2+?� 3+� �*�2+� �*�2� � � � W+$� 3� +&� 3� +Ѷ 3+� F+� x��(� �� �:� �*� �� �� �6� O+� �+,� 3� ���� $:� �� :� +�W��� +�W��� ��� :+� x��+� x�� :+� K�+� K+.� 3+� �� ��/ 1� �� � � `+3� 3+� F+5� 3++� �� ��/ �8� 3+:� 3� :+� K�+� K+<� 3+� �� ��B�C W+E� 3� +E� 3+� �� ��/ G� �� � � `+3� 3+� F+I� 3++� �� ��/ �8� 3+:� 3� :+� K�+� K+<� 3+� �� ��B�C W+E� 3� +E� 3+� �� ��/ K� �� � � `+3� 3+� F+M� 3++� �� ��/ �8� 3+:� 3� :+� K�+� K+<� 3+� �� ��B�C W+E� 3� +E� 3+� �� ��/ O� �� � � `+3� 3+� F+Q� 3++� �� ��/ �8� 3+:� 3� :+� K�+� K+<� 3+� �� ��B�C W+E� 3� +Ѷ 3+� �� ��/ S� �� � � `+3� 3+� F+U� 3++� �� ��/ �8� 3+:� 3� :+� K�+� K+<� 3+� �� ��B�C W+E� 3� +E� 3+� �� ��/ W� �� � � `+3� 3+� F+Y� 3++� �� ��/ �8� 3+:� 3� : +� K �+� K+<� 3+� �� ��B�C W+E� 3� +E� 3+� �� ��/ [� �� � � `+3� 3+� F+]� 3++� �� ��/ �8� 3+:� 3� :!+� K!�+� K+<� 3+� �� ��B�C W+E� 3� +Ѷ 3+� �� ��/ _� �� � � F+a� 3+� F+c� 3� :"+� K"�+� K+e� 3+� �� ��B�C W+g� 3� +E� 3+� �� ��/ i� �� � � F+a� 3+� F+k� 3� :#+� K#�+� K+e� 3+� �� ��B�C W+g� 3� +E� 3+� �� ��/ m� �� � � F+a� 3+� F+o� 3� :$+� K$�+� K+e� 3+� �� ��B�C W+g� 3� +E� 3+� �� ��/ q� �� � � F+a� 3+� F+s� 3� :%+� K%�+� K+e� 3+� �� ��B�C W+g� 3� +E� 3+� �� ��/ u� �� � � F+a� 3+� F+w� 3� :&+� K&�+� K+e� 3+� �� ��B�C W+g� 3� +E� 3+� �� ��/ y� �� � � F+a� 3+� F+{� 3� :'+� K'�+� K+<� 3+� �� ��B�C W+g� 3� +}� 3+� F+� 3� :(+� K(�+� K+�� 3+� F+�� 3� :)+� K)�+� K+�� 3+� F+�� 3� :*+� K*�+� K+�� 3+�� 3+� F+�� 3� :++� K+�+� K+�� 3+� F+�� 3� :,+� K,�+� K+�� 3+� �� ̹/ �� �� � �9+Ѷ 3+� �*�2�� � W+�� 3++� ĸ �*�2� �� �� � � �+�� 3+� �*�2�B� � W+�� 3+� �� ��� � W+�� 3+�� 9+�� 3+� x���� ���:--��W-��� ��� :.+� x-�.�+� x-�+�� 3��++� ĸ �*�2� �� ���+�� 3+� �*�2� � �� �� � � �+�� 3+� �*�2�B� � W+�� 3+� �� ��� � W+�� 3+�� 9+�� 3+� x���� ���://��W/��� ��� :0+� x/�0�+� x/�+�� 3�+� �*�2� � �� �� � ��+�� 3+� F+� x���� �� �:11� �1�� �1� �1� �622� �+12� �+�� 3+� x���� ���:33+� �*�2� � ��3���3��W3��� ��� :4+� x3�4�+� x3�+Ƕ 31� ����� $:515� �� :62� +�W1�6�2� +�W1�1�� ��� :7+� x1�7�+� x1�� :8+� K8�+� K+ɶ 3++� �*�2� ����� � � �+�� 3+� �*�2�B� � W+�� 3+� �� �Թ � W+�� 3+�� 9+�� 3+� x��ֶ ���:99��W9��� ��� ::+� x9�:�+� x9�+�� 3� +ض 3� +ڶ 3� +ܶ 3++� ĸ �*�	2� �� �� � � |+� 3+� �� �޹ � W+?� 3+�� 9+?� 3+� x��� ���:;;��W;��� ��� :<+� x;�<�+� x;�+� 3�G++� ĸ �*�	2� �� ��/+Ѷ 3++� �*�2�/ �8+� �*�
2� � �8����� � �5+E� 3+� F+� x��� �� �:==� �=� �=� �=� �6>>� �+=>� �+� 3++� �*�
2� � �8��+� 3+� x��� ���:??+� �*�2� � ��?���?��W?��� ��� :@+� x?�@�+� x?�+ɶ 3=� ���n� $:A=A� �� :B>� +�W=�B�>� +�W=�=�� ��� :C+� x=�C�+� x=�� :D+� KD�+� K+E� 3++� �*�2� ����� � � �+E� 3+� �*�2�B� � W+ɶ 3+� �� ����C W+g� 3+� F+ɶ 3+� x���� ���:EE��E�E�WE�� ��� :F+� xE�F�+� xE�+ɶ 3� :G+� KG�+� K+Ѷ 3� +E� 3� �+E� 3+� �*�2�B� � W+ɶ 3+� �� ��
�C W+g� 3+� F+ɶ 3+� x��� ���:HH��H�H�WH�� ��� :I+� xH�I�+� xH�+ɶ 3� :J+� KJ�+� K+� 3+� 3� +� 3++� ĸ �*�2� �� �� � � |+� 3+� �� �� � W+?� 3+�� 9+?� 3+� x��� ���:KK��WK��� ��� :L+� xK�L�+� xK�+E� 3� �++� ĸ �*�2� �� �� �+E� 3+� �*�2� � � �� � � )+� �*�2� � � �� � � � � +E� 3� y+� 3+� �� �� � W+?� 3+�� 9+?� 3+� x��� ���:MM��WM��� ��� :N+� xM�N�+� xM�+� 3+� 3� +Ѷ 3++� ĸ �*�2� �� �� � � |+� 3+� �� � � � W+?� 3+�� 9+?� 3+� x��"� ���:OO��WO��� ��� :P+� xO�P�+� xO�+E� 3� �++� ĸ �*�2� �� �� �+E� 3+� �*�2� � � �� � � )+� �*�2� � � �� � � � � +E� 3� y+� 3+� �� �$� � W+?� 3+�� 9+?� 3+� x��&� ���:QQ��WQ��� ��� :R+� xQ�R�+� xQ�+� 3+� 3� +�� 3+� F+� x��(� �� �:SS� �S*� �S� �S� �6TT� �+ST� �+,� 3+� x��.� ���:UU+� �*�2� � ��U���U��WU��� ��� :V+� xU�V�+� xU�+?� 3S� ����� $:WSW� �� :XT� +�WS�X�T� +�WS�S�� ��� :Y+� xS�Y�+� xS�� :Z+� KZ�+� K+E� 3++� �*�2� ����� � �+E� 3+� �*�2+++� �*�2� *�2� �8+� �*�2�/ �8�3�7� � W+E� 3+� �*�2�/ 1� �� � � )+� �*�2�/ 9� �� � � � �H+� 3+� F+� x��;� �� �:[[� �[=� �[� �[� �6\\�3+[\� �+?� 3+++� �*�
2� � �8�D��+F� 3++� �*�2� � �8��+H� 3++� �*�2� � �8��+J� 3++� �*�2� � �8��+L� 3+� x��N� ���:]]+� �*�2� � ��]���]��W]��� ��� :^+� x]�^�+� x]�+�� 3[� ���� $:_[_� �� :`\� +�W[�`�\� +�W[�[�� ��� :a+� x[�a�+� x[�� :b+� Kb�+� K+ڶ 3+� �� ��Q�C W+�� 3+� F+�� 3+� x��S� ���:cc��c�c�Wc�� ��� :d+� xc�d�+� xc�+�� 3� :e+� Ke�+� K+� 3�+E� 3+� �*�2�/ U� �� � � �+�� 3+� �� ��X�C W+�� 3+� F+�� 3+� x��Z� ���:ff��f�f�Wf�� ��� :g+� xf�g�+� xf�+�� 3� :h+� Kh�+� K+� 3�E+�� 3+� F+� x��\� �� �:ii� �i=� �i� �i� �6jj�3+ij� �+^� 3+++� �*�
2� � �8�D��+`� 3++� �*�2� � �8��+b� 3++� �*�2� � �8��+d� 3++� �*�2� � �8��+f� 3+� x��h� ���:kk+� �*�2� � ��k���k��Wk��� ��� :l+� xk�l�+� xk�+j� 3i� ���� $:mim� �� :nj� +�Wi�n�j� +�Wi�i�� ��� :o+� xi�o�+� xi�� :p+� Kp�+� K+l� 3+� �� ��Q�C W+j� 3+� F+j� 3+� x��n� ���:qq��q�q�Wq�� ��� :r+� xq�r�+� xq�+j� 3� :s+� Ks�+� K+p� 3+&� 3+Ѷ 3� +Ѷ 3��+� �� ̹/ r� �� � ��+Ѷ 3+� �*�2�� � W+t� 3++� ĸ �*�	2� �� �� � � |+� 3+� �� �v� � W+?� 3+�� 9+?� 3+� x��x� ���:tt��Wt��� ��� :u+� xt�u�+� xt�+� 3��++� ĸ �*�	2� �� ���+Ѷ 3++� �*�2�/ �8+� �*�
2� � �8����� � ��+E� 3+� F+� x��z� �� �:vv� �v� �v� �v� �6ww� m+vw� �+|� 3++� �*�
2� � �8��+~� 3v� ���է $:xvx� �� :yw� +�Wv�y�w� +�Wv�v�� ��� :z+� xv�z�+� xv�� :{+� K{�+� K+E� 3++� �*�2� ����� � � �+E� 3+� �*�2�B� � W+ɶ 3+� �� ����C W+g� 3+� F+ɶ 3+� x���� ���:||��|�|�W|�� ��� :}+� x|�}�+� x|�+ɶ 3� :~+� K~�+� K+Ѷ 3� +E� 3� �+E� 3+� �*�2�B� � W+ɶ 3+� �� ����C W+g� 3+� F+ɶ 3+� x���� ���:����W�� ��� :�+� x���+� x�+ɶ 3� :�+� K��+� K+� 3+� 3� +� 3++� ĸ �*�2� �� �� � � |+� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� ���:����W���� ��� :�+� x����+� x��+E� 3� �++� ĸ �*�2� �� �� �+E� 3+� �*�2� � � �� � � )+� �*�2� � � �� � � � � +E� 3� y+� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� ���:����W���� ��� :�+� x����+� x��+� 3+� 3� +Ѷ 3++� ĸ �*�2� �� �� � � |+� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� ���:����W���� ��� :�+� x����+� x��+E� 3� �++� ĸ �*�2� �� �� �+E� 3+� �*�2� � � �� � � )+� �*�2� � � �� � � � � +E� 3� y+� 3+� �� ��� � W+?� 3+�� 9+?� 3+� x���� ���:����W���� ��� :�+� x����+� x��+� 3+� 3� +�� 3+� F+� x���� �� �:��� ���� ��� ��� �6��� �+��� �+�� 3++� �*�
2� � �8��+�� 3++� �*�2� � �8��+�� 3++� �*�2� � �8��+�� 3++� �*�2� � �8��+�� 3�� ���{� $:���� �� :��� +�W������ +�W����� ��� :�+� x����+� x��� :�+� K��+� K+l� 3+� �� ����C W+j� 3+� F+j� 3+� x���� ���:��������W��� ��� :�+� x����+� x��+j� 3� :�+� K��+� K+E� 3�+� �� ̹/ �� �� � �
+�� 3++� ĸ �*�2� �� �� � � �+�� 3+� �*�2�B� � W+�� 3+� �� ��� � W+�� 3+�� 9+�� 3+� x���� ���:����W���� ��� :�+� x����+� x��+�� 3��++� ĸ �*�2� �� ���+�� 3+� �*�2� � �� �� � � �+�� 3+� �*�2�B� � W+�� 3+� �� ��� � W+�� 3+�� 9+�� 3+� x���� ���:����W���� ��� :�+� x����+� x��+�� 3�+� �*�2� � �� �� � ��+�� 3+� F+� x���� �� �:��� ���� ��� ��� �6��� �+��� �+�� 3+� x���� ���:��+� �*�2� � ���������W���� ��� :�+� x����+� x��+Ƕ 3�� ����� $:���� �� :��� +�W������ +�W����� ��� :�+� x����+� x��� :�+� K��+� K+ɶ 3++� �*�2� ����� � � �+�� 3+� �*�2�B� � W+�� 3+� �� ��� � W+�� 3+�� 9+�� 3+� x���� ���:����W���� ��� :�+� x����+� x��+�� 3� +ض 3� +ڶ 3� +.� 3+� F+� x���� �� �:��� ��*� ��� ��� �6��� �+��� �+,� 3+� x���� ���:��+� �*�2� � ���������W���� ��� :�+� x����+� x��+?� 3�� ����� $:���� �� :��� +�W������ +�W����� ��� :�+� x����+� x��� :�+� K��+� K+E� 3++� �*�2� ����� � �	+E� 3+� �*�2+++� �*�2� *�2� �8+� �*�2�/ �8�3�7� � W+E� 3+� �*�2�/ 1� �� � � )+� �*�2�/ 9� �� � � � ��+�� 3+� F+� x��ö �� �:��� ���� ��� ��� �6��� �+��� �+Ŷ 3+� x��Ƕ ���:��+� �*�2� � ���������W���� ��� :�+� x����+� x��+�� 3�� ����� $:���� �� :��� +�W������ +�W����� ��� :�+� x����+� x��� :�+� K��+� K+ɶ 3+� �� ��̹C W+�� 3+� F+�� 3+� x��ζ ���:��������W��� ��� :�+� x����+� x��+�� 3� :�+� K��+� K+� 3��+� 3+� �*�2�/ U� �� � � �+�� 3+� �� ��ѹC W+�� 3+� F+�� 3+� x��Ӷ ���:��������W��� ��� :�+� x����+� x��+�� 3� :�+� K��+� K+� 3��+�� 3+� F+� x��ն �� �:��� ���� ��� ��� �6��� �+��� �+׶ 3+� x��ٶ ���:��+� �*�2� � ���������W���� ��� :�+� x����+� x��+j� 3�� ����� $:���� �� :��� +�W������ +�W����� ��� :�+� x����+� x��� :�+� K��+� K+l� 3+� �� ��̹C W+j� 3+� F+j� 3+� x��۶ ���:��������W��� ��� :�+� x����+� x��+j� 3� :�+� K��+� K+ݶ 3+&� 3+Ѷ 3� +E� 3��+� �� ̹/ ߸ �� � ��+� 3++� ĸ �*�2� �� �� � � |+� 3+� �� �� � W+?� 3+�� 9+?� 3+� x��� ���:�¶�W¶�� ��� :�+� x¶ÿ+� x¶+E� 3� �++� ĸ �*�2� �� �� �+E� 3+� �*�2� � U� �� � � (+� �*�2� � � �� � � � � +E� 3� y+� 3+� �� �� � W+?� 3+�� 9+?� 3+� x��� ���:�Ķ�WĶ�� ��� :�+� xĶſ+� xĶ+� 3+� 3� +� 3+� �*�2� � U� �� � �a+E� 3+� F+� x���� �� �:��� ��� ��� �ƶ �6��� m+�Ƕ �+� 3++� �*�2�/ �8��+� 3ƶ ���է $:��ȶ �� :��� +�Wƶɿ�� +�Wƶƶ� ��� :�+� xƶʿ+� xƶ� :�+� K˿+� K+E� 3++� �*�2� ����� � � �+E� 3+� �*�2�B� � W+ɶ 3+� �� ����C W+g� 3+� F+ɶ 3+� x���� ���:������̶W̶� ��� :�+� x̶Ϳ+� x̶+ɶ 3� :�+� Kο+� K+E� 3��+E� 3+� F+� x���� �� �:��� ���� ��� �϶ �6��� l+�ж �+�� 3++� �*�2� � �8��+ � 3϶ ���֧ $:��Ѷ �� :��� +�W϶ҿ�� +�W϶϶� ��� :�+� x϶ӿ+� x϶� :�+� KԿ+� K+E� 3+� �*�2�B� � W+ɶ 3+� �� ���C W+g� 3+� F+ɶ 3+� x��� ���:������նWն� ��� :�+� xնֿ+� xն+ɶ 3� :�+� K׿+� K+Ѷ 3+E� 3��+� �*�2� � � �� � ��+E� 3+� F+� x��� �� �:��� ���� ��� �ض �6��� l+�ٶ �+�� 3++� �*�2� � �8��+ � 3ض ���֧ $:��ڶ �� :��� +�Wضۿ�� +�Wضض� ��� :�+� xضܿ+� xض� :�+� Kݿ+� K+E� 3+� �*�2�B� � W+ɶ 3+� �� ��
�C W+g� 3+� F+ɶ 3+� x��� ���:������޶W޶� ��� :�+� x޶߿+� x޶+ɶ 3� :�+� K�+� K+Ѷ 3� +� 3� �+� �� ̹/ � �� � � �+Ѷ 3+� 9+E� 3+� �*�2�B� � W+ɶ 3+� �� ���C W+g� 3+� F+ɶ 3+� x��� ���:�������W�� ��� :�+� x��+� x�+ɶ 3� :�+� K�+� K+� 3� +� 3++� �*�2� ����� � ��+� 3+*�!:�+�$6���* 6��- � � ��6���- �3:�+� ��7 �d6���`�;�;��>�B � � � ��>6�+�� 3+� F+D� 3++� ��G�/ �8� 3+I� 3++� ��G�/ �8� 3+K� 3++� ��N�/ �8� 3+P� 3++� �*�2�/ �8� 3+R� 3+� �*�2�/ � �� � � +T� 3� 
+V� 3+X� 3+� F+� x��Z� �� �:��� ��\� ��� �� �6��� m+��� �+^� 3++� �*�2�/ �8��+`� 3� ���է $:��� �� :��� +�W���� +�W��� ��� :�+� x��+� x�� :�+� K�+� K+� 3++� �*�2� ����� � � 2+b� 3+++� �*�2� �e� �8� 3+g� 3� 
+i� 3+k� 3� :�+� K�+� K+m� 3���� ":����B W+� ��p �t����B W+� ��p �t+v� 3� S++� �*�2� ����� � � /+x� 3+� F+z� 3� :�+� K��+� K+|� 3� +~� 3+�� 9+�� 3� � 1 : :  ��� )���  m��  Z  Scf )Sor  )��  ��  �##  ���  ''  ���  **  ���  
..  ���  ���  	[	e	e  	�	�	�  
+
5
5  
�
�
�  
�
�
�  
�  $$  CMM  eoo  >UU  **  �  �-0 )�9<  �rr  w��  "99  ���  �  �BE )�NQ  ���  o��  1VV  vv  �  �33  ���  ���  Mdd  ;RR  �  �9< )�EH  �~~  ���  U��  ��� )���  ���  ~  [��  >��  DD  ee  ^��  ��� )���  ���  �  d��  G��  v��  N| )N��  $��  ��   k � �   O � �  !(!M!M  !!m!m  !�"
"
  "�"�"�  #�#�#�  $u$�$�  $�%�%� )$�%�%�  $�%�%�  $�%�%�  &0&U&U  &&v&v  '/'F'F  (((  (�(�(�  (�))! )(�)*)-  (|)c)c  (h)})}  *****  *�*�*�  *�++! )*�+*+-  *}+c+c  *i+}+}  ,�,�,�  ,�-- ),�-%-(  ,w-^-^  ,c-x-x  -�-�-�  -�.
.
  .�.�.�  .k.�.�  /K//  /./�/� )/./�/�  //�/�  .�00  0Q0v0v  040�0�  1J1a1a  252L2L  2�33 )2�33"  2�3X3X  2�3r3r  44'4'  3�4G4G  4�4�4� )4�4�4�  4}55  4i5353  5�5�5�  5|5�5�  6d6�6� )6d6�6�  6:6�6�  6&6�6�  7U7z7z  797�7�  8>8c8c  8"8�8�  :C:q:t ):C:}:�  ::�:�  ::�:�  9T;H;H  9;b;b  ;�;�;�   �         * +  �  ��           g  h * j - q 4 r E v H x K � U � X � � � � � � � � � � �! �$ �� �� �� �" �A �G �J �P �S �� � �� �� �� �� � � � � �W �� �� �� �� �4 �7 �K �U �z �} �� �� �� �� �� �� �8 �; �O �Y �~ �� �� �� �� ���;>	R\������?B!V#_&�'�*�6�8�:�;�>	J	%L	/N	TO	WR	y^	�`	�b	�c	�f	�r	�t	�v
$w
'z
I�
]�
g�
��
��
��
��
��
��
��
��
��
��
��
������1�5�?9G:Z>^Aa[i\|`�b�w�y�z�|������%�p�����������E�p���!���������	�S�Y�]�c�g�m�q�t��������(�+�h���6���������p���������������-�D�G�K�Q�U�X�|��������`�j����������������&�4���������"�m�p tz}�	�-��$w��� <� 7 B!�"�$�&�(�)*_+v-�/�0�2�3	4'5E6�7)9@:K;�<�>�?�A�B�D�E�H�J�KMQ9SOT]U�W�Y�Z	\N]p^�` b 1c He Rf �g �i �j �l �n �o!q!r!gs!~u!�v!�x!�y!�{!�~!��!��!��"%�"G�"��"��"��"��#�#�#�# �##�#J�#`�#n�#��#��$.�$8�$N�$\�$��$��$��$��$��$��$��%�%y�%��&�&�&p�&��&��&��&��&��'�'�'a�'��'��'��'��'��(6�(a�(��)�)��)��)��)��)��*D�*J�*N�*T�*X�*^�*b�*e�*��+�+��+��,	�,\�,��-�-��-��-��.�.�.%�.M.d.o.�.�.�/2
/�00-080�0�0�0�0�0�0�0�0�0� 1"1##11$1|&1�(1�*1�,2-2.2g02j12n32t42x72{92�;2�<3=3�?3�A3�B3�D3�E4AF4XH4bJ4�K4�L5DN5^O5uQ5R5�S5�U5�V5�X6Z6d[6�\7^7_72a7<b7�c7�e7�f7�i7�k7�l7�n8o8q8%r8}s8�w8�x8�z8��8��8��9M�9X�9[�9u�9��9��9��9��9��9��:�:C�:e�:��;�;4�;;�;>�;B�;Y�;_�;��;��;��;��;��;��;��;��<��     ) �� �        �    �     ) �� �         �    �     ) �� �        �    �    �    �      *� �Y���SY���SY��SY���SY���SY���SY���SY���SY���SY	���SY
���SY���SY���SY���SY���SY���SY���SY���SY���SY���SY���SYø�SYŸ�SYǸ�SYɸ�SY˸�SY͸�S��     �    