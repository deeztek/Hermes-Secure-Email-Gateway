����   2� W__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_internal_recipients_cfm$cf  lucee/runtime/PageImpl  I../../publish/hermes-seg-18.04/proprietary/2/view_internal_recipients.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ���f` getSourceLength      � getCompileTime  �\��� getHash ()I%�36 call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this YL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_internal_recipients_cfm$cf; �<!DOCTYPE html>




<html lang="en">


  <head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Internal Recipients</title>

   , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 ./inc/html_head.cfm 4 	doInclude (Ljava/lang/String;Z)V 6 7
 / 8;

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
          stateSave: true,
          lengthMenu: [
            [ 25, 50, 100, -1 ],
      [ '25 rows', '50 rows', '100 rows', 'Show all' ]
  
      ],
      
          "order": [[ 3, "asc" ]]
      } );
  } );
    </script>

  

<script>

  $(document).ready(function() {
    $("#delete").click(function() {
      var deleterecipient = [];
      $.each($("input[name='id']:checked"), function() {
        deleterecipient.push($(this).val());
      });
      $('#delete_modal').modal('show').on('shown.bs.modal', function() {
      $("#deleteid").html('<input type="hidden" name="recipient_id" value=' + deleterecipient + '>');
      });
    });
  });
  
   :P</script>



<script>

  $(document).ready(function() {
    $("#editoptions").click(function() {
      var editrecipient = [];
      $.each($("input[name='id']:checked"), function() {
        editrecipient.push($(this).val());
      });
      $('#editoptions_modal').modal('show').on('shown.bs.modal', function() {
      $("#editoptionsid").html('<input type="hidden" name="recipient_id" value=' + editrecipient + '>');
      });
    });
  });
  
  </script>

<script>

  $(document).ready(function() {
    $("#editencryption").click(function() {
      var editrecipient = [];
      $.each($("input[name='id']:checked"), function() {
        editrecipient.push($(this).val());
      });
      $('#editencryption_modal').modal('show').on('shown.bs.modal', function() {
      $("#editencryptionid").html('<input type="hidden" name="recipient_id" value=' + editrecipient + '>');
      });
    });
  });
  
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

 < e</style>
  

</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">



   > ./inc/top_navbar.cfm @ 
   B ./inc/main_sidebar.cfm D

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
             F outputStart H 
 / I P
            <h1 class="m-0">Internal Recipients</h1>
            
           K 	outputEnd M 
 / N)
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Internal Recipients</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

    
    
     P errormessage R &lucee/runtime/config/NullSupportHelper T NULL V '
 U W -lucee/runtime/interpreter/VariableInterpreter Y getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; [ \
 Z ] 0 _ %lucee/runtime/exp/ExpressionException a java/lang/StringBuilder c The required parameter [ e  1
 d g append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; i j
 d k ] was not provided. m -(Ljava/lang/String;)Ljava/lang/StringBuilder; i o
 d p toString ()Ljava/lang/String; r s
 d t
 b g lucee/runtime/PageContextImpl w any y�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V } ~
 x  
    
     � m2 �  
     � urlScope  ()Llucee/runtime/type/scope/URL; � �
 / � lucee/runtime/op/Caster � toStruct /(Ljava/lang/Object;)Llucee/runtime/type/Struct; � �
 � � keys $[Llucee/runtime/type/Collection$Key; � �	  � !lucee/runtime/type/Collection$Key � .lucee/runtime/functions/struct/StructKeyExists � \(Llucee/runtime/PageContext;Llucee/runtime/type/Struct;Llucee/runtime/type/Collection$Key;)Z & �
 � � 
     � lucee/runtime/type/scope/URL � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � �   � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � us &()Llucee/runtime/type/scope/Undefined; � �
 / � "lucee/runtime/type/scope/Undefined � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � � 

    
   � 
  
  
   � 

   � m � sessionScope $()Llucee/runtime/type/scope/Session; � �
 / � $lucee/runtime/type/util/KeyConstants � _m #Llucee/runtime/type/Collection$Key; � �	 � � _M � �	 � �  lucee/runtime/type/scope/Session � � � 

  
  

  
   � 


  
   � 

  

  
     � step � action �@       _action � �	 � � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � (ZLjava/lang/String;)I � �
 � � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � �	 � � lucee/runtime/type/scope/Form � � � *  
    
  

  
        
  
         � � � 3 � �
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
             �  Recipient(s) edited successfully � 9<br>

       
        
          </div>

           � #lucee/commons/color/ConstantsDouble � _0 Ljava/lang/Double; � �	 �  � � 

         
        
  
         2 !Recipient(s) deleted successfully	 .<br>
        
          </div>

           1 �

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
             MYou must first select recipient(s) before clicking the Edit or Delete buttons  
          </div>

           
        
         

 �

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
     DYou must first select recipient(s) before clicking the Delete button 
  </div>

-
      
        
        
        

        
  
 

<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteRecipientModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header alert-danger">
        
          <h4 class="modal-title">Delete Recipient(s) </h4>
      </div>
        
      <div class="modal-body">
        <p>Are you sure you to delete the recipient(s) you have selected? This action is irreversible!</p>
  
      </div>
      <div class="modal-footer">
        <form name="delete_recipients" method="post" action="">
  
          <input type="hidden" name="action" value="deleterecipient">
          <div id="deleteid"></div>
       
  


          <input type="submit" class="btn btn-danger" name="" value="Yes" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

            </form>
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
      </div>
    </div>
  </div>
  </div>
  
    




  
 

  <div class="modal fade" id="editencryption_modal" tabindex="-1" role="dialog" aria-labelledby="editEncryptionModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-primary">
          
            <h4 class="modal-title">Edit Recipient(s) Encryption </h4>
        </div>
          
        <div class="modal-body">

          

          <form name="edit_recipients" method="post" action="">
    
            <input type="hidden" name="action" value="editencryption">
            <div id="editencryptionid"></div>
         
                 
      
    
      <div class="form-group">
        <label><strong>PDF Encryption</strong></label>
      
      <select class="form-control" name="pdf_enabled" data-placeholder="pdf_enabled" style="width: 100%">                  
      <option value="2" selected="selected">Disable</option>
      !<option value="1">Enable</option>
      
      </select> 
      </div>
    
      
    
        
    
        <div class="form-group">
          <label><strong>S/MIME Encryption</strong></label>
        
        <select class="form-control" name="smime_enabled" data-placeholder="smime_enabled" style="width: 100%">                  
        <option value="2" selected="selected">Disable</option>
        <option value="1">Enable</option>
        
        </select> 
        </div>
      
        
    
        
        
    
        <div class="form-group">
          <label><strong>S/MIME SIGNATURE</strong></label>
        
          <p class="help-block">Effective only when S/MIME Certificate present</p>
        
        <select class="form-control" name="sign" data-placeholder="sign" style="width: 100%">                  
        <option value="2" selected="selected">Sign Encrypted Messages Only</option>
        <option value="1">Sign all messages</option>
        
        </select> 
        #I</div>
      
        
    
    
            
    
            <div class="form-group">
              <label><strong>PGP Encryption</strong></label>
            
            <select class="form-control" name="pgp_enabled" data-placeholder="pgp_enabled" style="width: 100%">                  
            <option value="2" selected="selected">Disable</option>
            <option value="1">Enable</option>
            
            </select> 
            </div>
          
            
    

  
            <input type="submit" class="btn btn-danger" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  
              </form>
        </div>
        <div class="modal-footer">
      
          <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
    </div>
    

    
 

  <div class="modal fade" id="editoptions_modal" tabindex="-1" role="dialog" aria-labelledby="editOptionsModalLabel" aria-hidden="true">
    %�<div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-primary">
          
            <h4 class="modal-title">Edit Recipient Options </h4>
        </div>
          
        <div class="modal-body">

          

          <form name="edit_options" method="post" action="">
    
            <input type="hidden" name="action" value="editoptions">
            <div id="editoptionsid"></div>
         
               

               ' lucee.runtime.tag.Query) cfquery+ JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:686- use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag;/0
 x1 lucee/runtime/tag/Query3 hasBody (Z)V56
47 getdefaultpolicy9 setName; 1
4< hermes> setDatasource (Ljava/lang/Object;)V@A
4B 
doStartTagD $
4E initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)VGH
 /I ~
                select policy_id, policy_name, default_policy from spam_policies where default_policy ='1'
                K doAfterBodyM $
4N doCatch (Ljava/lang/Throwable;)VPQ
4R popBody ()Ljavax/servlet/jsp/JspWriter;TU
 /V 	doFinallyX 
4Y doEndTag[ $
4\ lucee/runtime/exp/Abort^ newInstance (I)Llucee/runtime/exp/Abort;`a
_b reuse !(Ljavax/servlet/jsp/tagext/Tag;)Vde
 xf 
    
              h JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:690j getuserpoliciesl �
                select policy_id, policy_name, custom, system from spam_policies where custom='1' and system<>'1' and policy_id<>'n getCollectionp � �q I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �s
 /t &(Ljava/lang/Object;)Ljava/lang/String; rv
 �w writePSQyA
 /z ,' order by policy_name asc
                | #lucee/runtime/util/VariableUtilImpl~ recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;��
� (Ljava/lang/Object;D)I ��
 ��A
    
    
    
                <div class="form-group">
                    <label><strong>SVF Policy to Assign</strong></label>
                    <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                            style="width: 100%;">
                      � <option value="� " selected="selected">� 	</option>� A
                        </select>
    
                      �O
                        <div class="form-group">
                          <label><strong>SVF Policy to Assign</strong></label>
                          <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                                  style="width: 100%;">
                            � 
                            � getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;��
 /� getId� $
 /� lucee/runtime/type/Query� getCurrentrow (I)I���� getRecordcount� $�� !lucee/runtime/util/NumberIterator� load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� �� isValid (I)Z��
�� current� $
�� go (II)Z���� /
                              <option value="� ">� )</option>
                              � removeQuery�  �� release &(Llucee/runtime/util/NumberIterator;)V��
�� S
                              </select>
          
                            � 4
    
              
          </div>
          �
    
           
    
    
    
     
    
     
     <div class="form-group">
      <label><strong>Quarantine Reports</strong></label>
    
    <select class="form-control" name="reports" data-placeholder="reports" id="reports" style="width: 100%">                  
    <option value="YES" selected="selected">Enable Report Only if Quarantined Messages Exist</option>
    <option value="ALL">Enable Report Regardless if Quarantined Messages Exist</option>
    <option value="NO">Disable Quarantine Reports</option>
    
    </select> 
    </div>
    
         
              <div class="form-group" id="reportsfrequency">
                <label><strong>Quarantine Report Frequency</strong></label>
    
    
      <select class="form-control select2" name="frequency" data-placeholder="frequency" style="width: 100%">                  
      <option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
      <option value="2">Every 2 Hours (Previous 2 Hours Quarantine Report)�</option>
      <option value="4">Every 4 Hours (Previous 4 Hours Quarantine Report)</option>
      <option value="8">Every 8 Hours (Previous 8 Hours Quarantine Report)</option>
       </select> 
      </div>
    
      
    
    
    
    <div class="form-group">
      <label><strong>Train Bayes Filter from User Portal</strong></label>
    
      <div class="alert alert-danger">
        <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
        <p>Ensure you do <strong>NOT</strong> enable for inexperienced recipients. Improperly training Bayes Filter will affect ALL recipients</p>
        </div>
    
    <select class="form-control" name="train_bayes" data-placeholder="train_bayes" style="width: 100%">                  
    <option value="0" selected="selected">Disable</option>
    <option value="1">Enable</option>
    
    </select> 
    </div>
    
    
    
    
    
    
    <div class="form-group">
    
      <label><strong>Download Messages from User Portal��</strong></label>
      <div class="alert alert-danger">
      <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
      <p>Enabling can expose recipients to malware</p>
      </div>
    <select class="form-control" name="download_msg" data-placeholder="download_msg" style="width: 100%">                  
    <option value="0" selected="selected">Disable</option>
    <option value="1">Enable</option>
    
    </select> 
    </div>
    
    
    
    
       
         

  
            <input type="submit" class="btn btn-danger" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  
              </form>
        </div>
        <div class="modal-footer">
      
          <button type="button" class="btn btn-primary" data-dismiss="modal">Cancel</button>
        </div>
      </div>
    </div>
    </div>
    
      
  
      � deleterecipient� 

          � _1� �	 �� lucee.runtime.tag.Location� 
cflocation� JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:823� lucee/runtime/tag/Location� view_internal_recipients.cfm� setUrl� 1
�� setAddtoken�6
��
�E
�\ "
      
          

          � 

            � JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:836� *
              
          

          � 
      

� ,�  lucee/runtime/type/util/ListUtil� listToArrayRemoveEmpty @(Ljava/lang/String;Ljava/lang/String;)Llucee/runtime/type/Array;��
�� lucee/runtime/type/Array� size� $�� i getVariableReference Y(Llucee/runtime/PageContext;Ljava/lang/String;)Llucee/runtime/type/ref/VariableReference;
 Z getE (I)Ljava/lang/Object;�	 (lucee/runtime/type/ref/VariableReference ��
 


       integer _I �	 � (lucee/runtime/functions/decision/IsValid B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &
 JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:849 getrecipient :
        select id, recipient from recipients where id =  lucee.runtime.tag.QueryParam! cfqueryparam# JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:850% lucee/runtime/tag/QueryParam' setValue)A
(* CF_SQL_INTEGER, setCfsqltype. 1
(/
(E
(\ 

        3 
          5 _ID7 �	 �8 $./inc/delete_internal_recipients.cfm: 

          
            < 
            > <br>
          @ "
        

          
        B 
      
          
        D 
      
        
        F 
  
        H _2J �	 �K 


  M JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:877O 	
 


Q 



S 


U editoptionsW 

  
  
  Y 

  
    [ 4Edit Internal Recipients: form.policy does not exist] ./inc/error.cfm_ lucee.runtime.tag.Aborta cfabortc JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:896e lucee/runtime/tag/Abortg
hE
h\ 
  
  k JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:900m checkpolicyo '
    select id from policy where id = q JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:901s 6Edit Internal Recipients: checkpolicy.recordcount LT 1u JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:908w 5Edit Internal Recipients: form.reports does not existy JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:921{ YES} NO ALL� =Edit Internal Recipients: form.reports is not YEs, NO, or ALL� JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:931� 7Edit Internal Recipients: form.frequency does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:944� =Edit Internal Recipients: form.frequency is not valid Integer� JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:952� 9Edit Internal Recipients: form.train_bayes does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:965� 8Edit Internal Recipients: form.train_bayes is not 0 or 1� JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:974� :Edit Internal Recipients: form.download_msg does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:987� 9Edit Internal Recipients: form.download_msg is not 0 or 1� JC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:996� 
  
  
  
    � KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1010� 
  
  
      � 
  
      � KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1019� 
          
  
  �       
  
  
  
  � KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1030� 6
    select id, recipient from recipients where id = � KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1031� 
      � "./inc/edit_internal_recipients.cfm� 
  
      
        � <br>
      � 
    
  
      
    � 
  
      
    � 
  
    
    � _3� �	 �� KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1058� 
  
  
  
  � editencryption� 9Edit Internal Recipients: form.pdf_enabled does not exist� KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1077� 8Edit Internal Recipients: form.pdf_enabled is not 1 or 2� KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1086� ;Edit Internal Recipients: form.smime_enabled does not exist� KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1099� :Edit Internal Recipients: form.smime_enabled is not 1 or 2� KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1109� 2Edit Internal Recipients: form.sign does not exist� KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1122� 1Edit Internal Recipients: form.sign is not 1 or 2� KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1131� 9Edit Internal Recipients: form.pgp_enabled does not exist� KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1144� 8Edit Internal Recipients: form.pgp_enabled is not 1 or 2� KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1153� 

    � KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1166� 



    � KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1175� 
        

�       



� KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1186� 4
  select id, recipient from recipients where id = � KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1187� )./inc/edit_internal_recipients_djigzo.cfm� 

    
      � 
<br>
      
  

    
   KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1213 
    
           
    � 
    

  
  

<form>
    
<span>
  <p>       


<a href="add_internal_recipients.cfm" class="btn btn-primary" role="button"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Create Recipient(s)</a>
&nbsp;&nbsp;
<button type="button" id="editoptions" class="btn btn-primary"><i class="fa fa-edit"></i>&nbsp;&nbsp;Edit Options</button>
&nbsp;&nbsp;
<button type="button" id="editencryption" class="btn btn-primary"><i class="fas fa-lock"></i>&nbsp;&nbsp;Edit Encryption</button>
&nbsp;&nbsp;
<button type="button" id="delete" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete</button>

</p>

<p>

</p>
</span>






<br>




 KC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients.cfm:1314
 getrecipientsG
  select recipients.id, recipients.id as theID, recipients.id as theOtherID, recipients.recipient, policy.policy_name, user_settings.report_enabled as report_enabled, user_settings.report_frequency as report_frequency, if(user_settings.train_bayes = 1, 'YES', 'NO') as train_bayes, if(user_settings.download_msg = 1, 'YES', 'NO') as download_msg, if(recipients.pdf_enabled = 1, 'YES', 'NO') as pdf_enabled, if(recipients.smime_enabled = '1', 'YES', 'NO') as smime_enabled, if(recipients.pgp_enabled = 1, 'YES', 'NO') as pgp_enabled, if(recipients.digital_sign = '1', 'YES', 'NO') as digital_sign, if(recipient_certificates.user_id is NULL, 'NO', 'YES') as cert, if(recipient_keystores.user_id is NULL, 'NO', 'YES') as keystore
  from recipients LEFT JOIN policy ON recipients.policy_id = policy.id LEFT JOIN recipient_certificates ON recipients.id = recipient_certificates.user_id  LEFT JOIN recipient_keystores ON recipients.id = recipient_keystores.user_id  LEFT JOIN user_settings ON recipients.recipient = user_settings.email where recipients.domain is NULL group by recipients.id
  
  &

    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            
            <th>SMIME Certificates</th>
            <th>PGP Keyrings</th>
            <th>Recipient</th>
            <th>Policy</th>
            <th>Reports</th>
            <th>Frequency</th>
            <th>Train Bayes</th>
            <th>Download Msgs</th>
            <th>PDF Encrypt</th>
            <th>SMIME Encrypt</th>
            <th>PGP Encrypt</th>
            <th>Sign All</th>
            <th>SMIME Certificates</th>
            <th>PGP Keyrings</th>
            
          

          </tr>
        </thead>
        <tbody>

        

 <



        <td><input type="checkbox" name="id" value=" H"></td>
        <td><a href="view_recipient_certificates.cfm?type=1&id= �" class="btn btn-secondary" role="button"><i class="fas fa-user-shield"></i></a></td>
        <td><a href="view_recipient_keyrings.cfm?type=1&id= a" class="btn btn-secondary" role="button"><i class="fas fa-user-lock"></i></a></td>
        <td> </td>
         <td> </td>
            <td> .</td>

      

          </tr>

        �

        </tbody>
        
       
        <tfoot>
          <tr>
            <th></th>
            <th>SMIME Certificates</th>
            <th>PGP Keyrings</th>
            <th>Recipient</th>
            <th>Policy</th>
            <th>Reports</th>
            <th>Frequency</th>
            <th>Train Bayes</th>
            <th>Download Msgs</th>
            <th>PDF Encrypt</th>
            <th>SMIME Encrypt</th>
            <th>PGP Encrypt</th>
            <th>Sign All</th>
            <th>SMIME Certificates</th>
            <th>PGP Keyrings</th>
          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
      �
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        " *No Internal Recipients were found</strong>$ "
      </div>
    
      
    &�
    
    

    <div>&nbsp;</div>

    
    
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


( ./inc/main_footer.cfm*�

<!-- ./wrapper -->



</body>

  
   

  <script>

    $('#reports').on('change',function(){
      if( $(this).val()==="NO" ){
      $("#reportsfrequency").hide()
      }
      else{
      $("#reportsfrequency").show()
      }
    });
    
    </script>
  
  

  
     
  <script>
    $('#selectAll').click(function() {
      if(this.checked) {
          $(':checkbox').each(function() {
              this.checked = true;                        
          });
      } else {
         $(':checkbox').each(function() {
              this.checked = false;                        
          });
      } 
    });
    </script>
  

</html>, udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException4  lucee/runtime/type/UDFProperties6 udfs #[Llucee/runtime/type/UDFProperties;89	 : setPageSource< 
 = lucee/runtime/type/KeyImpl? intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;AB
@C M2E ERRORMESSAGEG GETDEFAULTPOLICYI 	POLICY_IDK GETUSERPOLICIESM POLICY_NAMEO recipient_idQ RECIPIENT_IDS GETRECIPIENTU 	RECIPIENTW 	DELETE_IDY policy[ POLICY] CHECKPOLICY_ reportsa REPORTSc 	frequencye 	FREQUENCYg train_bayesi TRAIN_BAYESk download_msgm DOWNLOAD_MSGo EDIT_IDq pdf_enableds PDF_ENABLEDu smime_enabledw SMIME_ENABLEDy sign{ SIGN} pgp_enabled PGP_ENABLED� GETRECIPIENTS� THEID� 
THEOTHERID� REPORT_ENABLED� REPORT_FREQUENCY� DIGITAL_SIGN� CERT� KEYSTORE� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *�7�;*+�>�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  3  �  *�+-� 3+5� 9+;� 3+=� 3+?� 3+A� 9+C� 3+E� 9+G� 3+� J+L� 3� 
M+� O,�+� O+Q� 3+S+� X� ^N6+� X-� /`Y:� !� bY� dYf� hS� ln� q� u� v�N6+� xzS- { {� �+�� 3+�+� X� ^:6+� X� 0`Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3++� �� �*� �2� �� �� `+�� 3+� �*� �2� � �� �� � � 1+�� 3+� �*� �2+� �*� �2� � � � W+�� 3� +�� 3� +�� 3+�+� X� ^:	6
+� X	� 0`Y:� !� bY� dYf� h�� ln� q� u� v�:	6
+� xz�	 { {
� �+C� 3++� �� �� �� �� �� W+C� 3+� �� ʹ � �� �� � � ++C� 3+� �� �+� �� ʹ � � � W+϶ 3� +Ѷ 3� +Ӷ 3+�+� X� ^:6+� X� 0`Y:� !� bY� dYf� hն ln� q� u� v�:6+� xz� { {� �+�� 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� h׶ ln� q� u� v�:6+� xz� { {� �+�� 3+ ز �� �� �� �� � � Q+�� 3+� � �� � �� �� � � ++�� 3+� �� �+� � �� � � � W+�� 3� � +� 3+� �� ʹ � �� �� � � C+�� 3+� J+�� 3� :+� O�+� O+�� 3+� �� ʲ� W+� 3� +� 3+� �� ʹ � � �� � � E+�� 3+� J+
� 3� :+� O�+� O+� 3+� �� ʲ� W+� 3� +� 3+� �� ʹ � � �� � � F+� 3+� J+� 3� :+� O�+� O+� 3+� �� ʲ� W+� 3� +� 3+� �*� �2� � � �� � � /+� 3+� J+� 3� :+� O�+� O+� 3� + � 3+"� 3+$� 3+&� 3+(� 3+� J+� x*,.�2�4:�8:�=?�C�F6� O+�J+L� 3�O��� $:�S� :� +�WW�Z�� +�WW�Z�]� �c�� :+� x�g�+� x�g� :+� O�+� O+i� 3+� J+� x*,k�2�4:�8m�=?�C�F6� v+�J+o� 3+++� �*� �2�r *� �2�u�x�{+}� 3�O��̧ $:�S� :� +�WW�Z�� +�WW�Z�]� �c�� : +� x�g �+� x�g� :!+� O!�+� O+�� 3+� J+�� 3++� �*� �2�r ����� � � ~+�� 3+� J+�� 3+++� �*� �2�r *� �2�u�x� 3+�� 3+++� �*� �2�r *� �2�u�x� 3+�� 3� :"+� O"�+� O+�� 3��++� �*� �2�r ����� � ��+�� 3+� J+�� 3+++� �*� �2�r *� �2�u�x� 3+�� 3+++� �*� �2�r *� �2�u�x� 3+�� 3� :#+� O#�+� O+�� 3+� J+m��:%+��6&%&�� 6'%�� � � � �6((%�� ��:$+� �%�� (d6+$+`��� k%$��&�� � � � � O$��6++�� 3++� �*� �2� � �x� 3+�� 3++� �*� �2� � �x� 3+�� 3���� ":,%'&�� W+� ��� $��,�%'&�� W+� ��� $�Ƨ :-+� O-�+� O+ȶ 3� +ʶ 3� :.+� O.�+� O+̶ 3+ζ 3+ж 3+� �� �� � Ҹ �� � ��+� 3++� � �*� �2� �� �� � � }+Զ 3+� �� ʲ׹ W+� 3+� x��ݶ2��://��/��/��W/��� �c�� :0+� x/�g0�+� x/�g+� 3��++� � �*� �2� �� ���+Զ 3+� �*� �2� � �� �� � � }+�� 3+� �� ʲ׹ W+Զ 3+� x���2��:11��1��1��W1��� �c�� :2+� x1�g2�+� x1�g+� 3�.+� �*� �2� � �� �� � �+� 3+� �*� �2� � �x���:33�  64+�:567�R5+37�
 �W+� 3++� ��� � ��+� 3+� J+� x*,�2�4:88�88�=8?�C8�F699� �+89�J+ � 3+� x"$&�2�(:::+� ��� � �+:-�0:�1W:�2� �c�� :;+� x:�g;�+� x:�g+4� 38�O���� $:<8<�S� :=9� +�WW8�Z=�9� +�WW8�Z8�]� �c�� :>+� x8�g>�+� x8�g� :?+� O?�+� O+� 3++� �*� �	2�r ����� � � �+6� 3+� �*� �
2++� �*� �	2�r *� �
2�u� � W+6� 3+� �*� �2++� �*� �	2�r �9�u� � W+Զ 3+;� 9+=� 3+� J+?� 3++� ��� � �x� 3+A� 3� :@+� O@�+� O+C� 3� +E� 3� +G� 3�774���+I� 3+� �� ʲL� W+N� 3+� x��P�2��:AA��A��A��WA��� �c�� :B+� xA�gB�+� xA�g+R� 3� +T� 3� +V� 3��+� �� �� � X� �� � ��+Z� 3++� � �*� �2� �� �� � � |+\� 3+� �� �^� � W+�� 3+`� 9+�� 3+� xbdf�2�h:CC�iWC�j� �c�� :D+� xC�gD�+� xC�g+l� 3��++� � �*� �2� �� ���+l� 3+� J+� x*,n�2�4:EE�8Ep�=E?�CE�F6FF� �+EF�J+r� 3+� x"$t�2�(:GG+� �*� �2� � �+G-�0G�1WG�2� �c�� :H+� xG�gH�+� xG�g+C� 3E�O���� $:IEI�S� :JF� +�WWE�ZJ�F� +�WWE�ZE�]� �c�� :K+� xE�gK�+� xE�g� :L+� OL�+� O+l� 3++� �*� �2�r ����� � � {+\� 3+� �� �v� � W+�� 3+`� 9+�� 3+� xbdx�2�h:MM�iWM�j� �c�� :N+� xM�gN�+� xM�g+�� 3� +�� 3� +�� 3++� � �*� �2� �� �� � � |+\� 3+� �� �z� � W+�� 3+`� 9+�� 3+� xbd|�2�h:OO�iWO�j� �c�� :P+� xO�gP�+� xO�g+l� 3� ++� � �*� �2� �� ��+l� 3+� �*� �2� � ~� �� � � )+� �*� �2� � �� �� � � � � )+� �*� �2� � �� �� � � � � +l� 3� x+\� 3+� �� ��� � W+�� 3+`� 9+�� 3+� xbd��2�h:QQ�iWQ�j� �c�� :R+� xQ�gR�+� xQ�g+�� 3+�� 3� +�� 3++� � �*� �2� �� �� � � |+\� 3+� �� ��� � W+�� 3+`� 9+�� 3+� xbd��2�h:SS�iWS�j� �c�� :T+� xS�gT�+� xS�g+l� 3� �++� � �*� �2� �� �� �+\� 3++� �*� �2� � �� � � {+\� 3+� �� ��� � W+�� 3+`� 9+�� 3+� xbd��2�h:UU�iWU�j� �c�� :V+� xU�gV�+� xU�g+�� 3� +�� 3� +�� 3++� � �*� �2� �� �� � � |+\� 3+� �� ��� � W+�� 3+`� 9+�� 3+� xbd��2�h:WW�iWW�j� �c�� :X+� xW�gX�+� xW�g+l� 3� �++� � �*� �2� �� �� �+l� 3+� �*� �2� � `� �� � � )+� �*� �2� � � �� � � � � +l� 3� w+�� 3+� �� ��� � W+�� 3+`� 9+�� 3+� xbd��2�h:YY�iWY�j� �c�� :Z+� xY�gZ�+� xY�g+�� 3+�� 3� +�� 3++� � �*� �2� �� �� � � |+\� 3+� �� ��� � W+�� 3+`� 9+�� 3+� xbd��2�h:[[�iW[�j� �c�� :\+� x[�g\�+� x[�g+l� 3� �++� � �*� �2� �� �� �+l� 3+� �*� �2� � `� �� � � )+� �*� �2� � � �� � � � � +l� 3� w+�� 3+� �� ��� � W+�� 3+`� 9+�� 3+� xbd��2�h:]]�iW]�j� �c�� :^+� x]�g^�+� x]�g+�� 3+�� 3� +�� 3++� � �*� �2� �� �� � � }+� 3+� �� ʲ׹ W+\� 3+� x����2��:__��_��_��W_��� �c�� :`+� x_�g`�+� x_�g+�� 3�++� � �*� �2� �� ���+�� 3+� �*� �2� � �� �� � � }+� 3+� �� ʲ׹ W+�� 3+� x����2��:aa��a��a��Wa��� �c�� :b+� xa�gb�+� xa�g+�� 3�K+� �*� �2� � �� �� � �*+�� 3+� �*� �2� � �x���:cc�  6d+�:e6g�Qe+cg�
 �W+l� 3++� ��� � ��+\� 3+� J+� x*,��2�4:hh�8h�=h?�Ch�F6ii� �+hi�J+�� 3+� x"$��2�(:jj+� ��� � �+j-�0j�1Wj�2� �c�� :k+� xj�gk�+� xj�g+�� 3h�O���� $:lhl�S� :mi� +�WWh�Zm�i� +�WWh�Zh�]� �c�� :n+� xh�gn�+� xh�g� :o+� Oo�+� O+\� 3++� �*� �	2�r ����� � � �+�� 3+� �*� �
2++� �*� �	2�r *� �
2�u� � W+�� 3+� �*� �2++� �*� �	2�r �9�u� � W+�� 3+�� 9+�� 3+� J+4� 3++� ��� � �x� 3+�� 3� :p+� Op�+� O+�� 3� +�� 3� +�� 3�ggd���+\� 3+� �� ʲù W+�� 3+� J+C� 3+� x��Ŷ2��:qq��q��q��Wq��� �c�� :r+� xq�gr�+� xq�g+C� 3� :s+� Os�+� O+�� 3� +Ƕ 3� +V� 3�
�+� �� �� � ɸ �� � �
�+T� 3++� � �*� �2� �� �� � � {+�� 3+� �� �˹ � W+C� 3+`� 9+C� 3+� xbdͶ2�h:tt�iWt�j� �c�� :u+� xt�gu�+� xt�g+� 3� �++� � �*� �2� �� �� �+� 3+� �*� �2� � � �� � � )+� �*� �2� � � �� � � � � +�� 3� x+C� 3+� �� �Ϲ � W+C� 3+`� 9+C� 3+� xbdѶ2�h:vv�iWv�j� �c�� :w+� xv�gw�+� xv�g+V� 3+V� 3� +V� 3++� � �*� �2� �� �� � � {+�� 3+� �� �ӹ � W+C� 3+`� 9+C� 3+� xbdն2�h:xx�iWx�j� �c�� :y+� xx�gy�+� xx�g+� 3� �++� � �*� �2� �� �� �+� 3+� �*� �2� � � �� � � )+� �*� �2� � � �� � � � � +� 3� x+�� 3+� �� �׹ � W+C� 3+`� 9+C� 3+� xbdٶ2�h:zz�iWz�j� �c�� :{+� xz�g{�+� xz�g+V� 3+V� 3� +V� 3++� � �*� �2� �� �� � � {+�� 3+� �� �۹ � W+C� 3+`� 9+C� 3+� xbdݶ2�h:||�iW|�j� �c�� :}+� x|�g}�+� x|�g+� 3� �++� � �*� �2� �� �� �+� 3+� �*� �2� � � �� � � )+� �*� �2� � � �� � � � � +� 3� x+C� 3+� �� �߹ � W+C� 3+`� 9+C� 3+� xbd�2�h:~~�iW~�j� �c�� :+� x~�g�+� x~�g+V� 3+V� 3� +V� 3++� � �*� �2� �� �� � � {+�� 3+� �� �� � W+C� 3+`� 9+C� 3+� xbd�2�h:���iW��j� �c�� :�+� x��g��+� x��g+� 3� �++� � �*� �2� �� �� �+� 3+� �*� �2� � � �� � � )+� �*� �2� � � �� � � � � +� 3� x+C� 3+� �� �� � W+C� 3+`� 9+C� 3+� xbd�2�h:���iW��j� �c�� :�+� x��g��+� x��g+V� 3+V� 3� +N� 3++� � �*� �2� �� �� � � |+� 3+� �� ʲ׹ W+�� 3+� x����2��:����������W���� �c�� :�+� x��g��+� x��g+� 3��++� � �*� �2� �� ���+� 3+� �*� �2� � �� �� � � }+� 3+� �� ʲ׹ W+� 3+� x���2��:����������W���� �c�� :�+� x��g��+� x��g+� 3�&+� �*� �2� � �� �� � �+�� 3+� �*� �2� � �x���:���  6�+�:�6��K�+���
 �W+� 3++� ��� � ��+�� 3+� J+� x*,��2�4:���8��=�?�C��F6��� �+���J+�� 3+� x"$��2�(:��+� ��� � �+�-�0��1W��2� �c�� :�+� x��g��+� x��g+C� 3��O���� $:����S� :��� +�WW��Z���� +�WW��Z��]� �c�� :�+� x��g��+� x��g� :�+� O��+� O+�� 3++� �*� �	2�r ����� � � �+�� 3+� �*� �
2++� �*� �	2�r *� �
2�u� � W+�� 3+� �*� �2++� �*� �	2�r �9�u� � W+� 3+�� 9+�� 3+� J+�� 3++� ��� � �x� 3+� 3� :�+� O��+� O+� 3� +�� 3� +Ѷ 3�������+�� 3+� �� ʲù W+� 3+� x���2��:����������W���� �c�� :�+� x��g��+� x��g+T� 3� +T� 3� +� 3� +	� 3+� J+� x*,�2�4:���8��=�?�C��F6��� O+���J+� 3��O��� $:����S� :��� +�WW��Z���� +�WW��Z��]� �c�� :�+� x��g��+� x��g� :�+� O��+� O+�� 3++� �*� � 2�r ����� � ��+� 3+� J+��:�+��6����� 6���� � � �X6����� ��:�+� ���� �d6���`����������� � � � �����6�+� 3++� ��9� � �x� 3+� 3++� �*� �!2� � �x� 3+� 3++� �*� �"2� � �x� 3+� 3++� �*� �
2� � �x� 3+� 3++� �*� �2� � �x� 3+� 3++� �*� �#2� � �x� 3+� 3++� �*� �$2� � �x� 3+� 3++� �*� �2� � �x� 3+� 3++� �*� �2� � �x� 3+� 3++� �*� �2� � �x� 3+� 3++� �*� �2� � �x� 3+� 3++� �*� �2� � �x� 3+� 3++� �*� �%2� � �x� 3+� 3++� �*� �&2� � �x� 3+� 3++� �*� �'2� � �x� 3+� 3��� ":������ W+� ��� ���������� W+� ��� ��Ƨ :�+� O��+� O+!� 3� S++� �*� � 2�r ����� � � /+#� 3+� J+%� 3� :�+� O��+� O+'� 3� +)� 3++� 9+-� 3� L = F F  ���  #--  ���  �    �� )��  T��  >��  G~� )G��  ��  ��  (��  �  ���  7	9	9  �	Z	Z  	�

  
�
�
�  �  �=@ )�IL  ���  ���  Ptt  ���  ���  s��  V�� )V��  +  ,,  ���  Lcc  d{{    ���  i��  Ull  �  ���  }��  7\\  n��  Q�� )Q��  &		  ##  ���  j��  N��  ^uu  Jaa  �  ���  ���   p � �  !!-!-  """  "�"�"�  #V#{#{  $�$�$�  $o$�$� )$o$�$�  $D%'%'  $.%A%A  %�&&  &y&�&�  ''/'2 )'';'>  &�'t't  &�'�'�  (**  '�*U*U  *�*�*�   �         * +  �  �k           � ) � 6 � 9 � @ � Q � T � W � � � �1 �W �| �� �� �� �� �� �
 �- �L �R �U �[ �^ �a �� �" �F �i �� �� �� �� �� �� �� �� �� � � �> �A �U �_ ������	���%L3�7�:�����K�r�����!�$���������0�����	J�	P�	T�	g�	k�	|1	�3	�5	�7
59
;>
W@
B
�D
�F
�KMdO�Q�R1S�U�VW:YI\T]n^�a�b�d�e�h�M�h�j�mp q$t*u.xVzY|}~������Z���=�h�~����������������%�3�~����'�=�K�������������������:�\����������������,�B�P�������.�<�������������������+�M������������"�&�)�M�d�������w�� ��	U�4
_����� &-1G!Q"�#�%�&�)�*�-�/�1!374E5�7�9;<#=1>|@A�C�D�F�G�I�J�K"MDO�Q�S�T�UWXZ[ ]#^F`\ajb�d�f *h 3i Ij Wk �m �n �p �q �s �t �v �w �x!Hz!j|!�~!�!��!��"5�"8�"<�"B�"F�"I�"m�"��"��"��#&�#=�#��#��#��$�$'�$s�$��%Q�%{�%��%��%��%��&�&'�&-�&0�&6�&9�&?�&F�&I�&`�&��&��&��&��&��&��&��&�"'#&'�('�,'�H(RL(oM(�N(�O(�P(�Q)R)#S)AT)_U)}V)�W)�X)�Y)�Z*`*fb*l�*��*��*��*��*��*��*���     ) ./ �        �    �     ) 01 �         �    �     ) 23 �        �    �    5    �  �    �*(� �Y��DSYF�DSYH�DSYJ�DSYL�DSYN�DSYP�DSYR�DSYT�DSY	V�DSY
X�DSYZ�DSY\�DSY^�DSY`�DSYb�DSYd�DSYf�DSYh�DSYj�DSYl�DSYn�DSYp�DSYr�DSYt�DSYv�DSYx�DSYz�DSY|�DSY~�DSY��DSY��DSY ��DSY!��DSY"��DSY#��DSY$��DSY%��DSY&��DSY'��DS� ��     �    