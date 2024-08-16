����   2  \__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_internal_recipients_json_cfm$cf  lucee/runtime/PageImpl  N../../publish/hermes-seg-18.04/proprietary/2/view_internal_recipients_json.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  |�B�� getSourceLength      | getCompileTime  �\��� getHash ()I�2� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this ^L__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_internal_recipients_json_cfm$cf; �<!DOCTYPE html>

  
 
<html lang="en">


 
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Internal Recipients</title>

   , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 ./inc/html_head.cfm 4 	doInclude (Ljava/lang/String;Z)V 6 7
 / 8R






<script>
$(document).ready(function() {
    $('#sortTable').DataTable( {
      'processing': true,
      "ajax": {
    "url": "./inc/get_int_recipients.cfm",
    "dataSrc": "DATA"
  },

      dom: 'Blfrtip',
        buttons: [
            'copy', 'csv', 'excel', 'pdf', 'print'
        ],
        lengthMenu: [
      [ 25, 50, 100, -1 ],
      [ '25 rows', '50 rows', '100 rows', 'Show all' ]

    ],
      'columnDefs': [

        {  targets: 0,
         render: function (data, type, row, meta) {
            return '<input type="checkbox" name="id" value=' + data + '>';
         }
         },
        {  targets: 1,
         render: function (data, type, row, meta) {
            return '<a href="view_recipient_certificates.cfm?type=1&id=' + data + '" class="btn btn-secondary" role="button"><i class="fas fa-user-shield"></i></a>';
         }
         },

         {  targets: 2,
         render: function (data, type, row, meta) {
            return '<a href="view_recipient_keyrings.cfm?type=1&id=' + data + '" class="btn btn-secondary" role="button"> :E<i class="fas fa-user-lock"></i></a>';
         }
         },

   
      ],
      'select': {
         'style': 'multi'
      },
        "order": [[ 3, "asc" ]]
    });



  });
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
  
  </script>

<script>

  $(document).ready(function() {
    $("#edit").click(function() {
      var editrecipient = [];
      $.each($("input[name='id']:checked"), function() {
        editrecipient.push($(this).val());
      });
      $('#edit_modal').modal('show').on('shown.bs.modal', function() {
      $("#editid").html('<input type="hidden" name="recipient_id" value=' + editrecipient + '>');
      });
    });
  });
  
   < d</script>


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
  
  
   � 

  
     � step � action �@       $lucee/runtime/type/util/KeyConstants � _action #Llucee/runtime/type/Collection$Key; � �	 � � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � (ZLjava/lang/String;)I � �
 � � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _ACTION � �	 � � lucee/runtime/type/scope/Form � � � *  
    
  

  
        
  
         � � � 3 � �
          <div class="alert alert-success alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-check"></i> Success!</h4>
             �  Recipient(s) edited successfully � *<br>
        
          </div>
         � 
        
  
         � 2 � !Recipient(s) deleted successfully � 

         � 1 � �

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
             � MYou must first select recipient(s) before clicking the Edit or Delete buttons � &
          </div>
        
         � 

 � �

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
     � DYou must first select recipient(s) before clicking the Delete button � 
  </div>

 �-
      
        
        
        

        
  
 

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
        <button type="button" class="btn btn-primary" data-dismiss="modal">No ��</button>
      </div>
    </div>
  </div>
  </div>
  
    


  
 

  <div class="modal fade" id="edit_modal" tabindex="-1" role="dialog" aria-labelledby="editRecipientModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-warning">
          
            <h4 class="modal-title">Edit Recipient(s) </h4>
        </div>
          
        <div class="modal-body">

          

          <form name="edit_recipients" method="post" action="">
    
            <input type="hidden" name="action" value="editrecipient">
            <div id="editid"></div>
         
               

                lucee.runtime.tag.Query cfquery OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:292 use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag;	

 x lucee/runtime/tag/Query hasBody (Z)V
 getdefaultpolicy setName 1
 hermes setDatasource (Ljava/lang/Object;)V
 
doStartTag $
 initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V!"
 /# ~
                select policy_id, policy_name, default_policy from spam_policies where default_policy ='1'
                % doAfterBody' $
( doCatch (Ljava/lang/Throwable;)V*+
, popBody ()Ljavax/servlet/jsp/JspWriter;./
 /0 	doFinally2 
3 doEndTag5 $
6 lucee/runtime/exp/Abort8 newInstance (I)Llucee/runtime/exp/Abort;:;
9< reuse !(Ljavax/servlet/jsp/tagext/Tag;)V>?
 x@ 
    
              B OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:296D getuserpoliciesF �
                select policy_id, policy_name, custom, system from spam_policies where custom='1' and system<>'1' and policy_id<>'H getCollectionJ � �K I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �M
 /N &(Ljava/lang/Object;)Ljava/lang/String; rP
 �Q writePSQS
 /T ,' order by policy_name asc
                V #lucee/runtime/util/VariableUtilImplX recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;Z[
Y\ (Ljava/lang/Object;D)I �^
 �_A
    
    
    
                <div class="form-group">
                    <label><strong>SVF Policy to Assign</strong></label>
                    <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                            style="width: 100%;">
                      a <option value="c " selected="selected">e 	</option>g A
                        </select>
    
                      iO
                        <div class="form-group">
                          <label><strong>SVF Policy to Assign</strong></label>
                          <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                                  style="width: 100%;">
                            k 
                            m getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;op
 /q getIds $
 /t lucee/runtime/type/Queryv getCurrentrow (I)Ixywz getRecordcount| $w} !lucee/runtime/util/NumberIterator load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� �� isValid (I)Z��
�� current� $
�� go (II)Z��w� /
                              <option value="� ">� )</option>
                              � removeQuery�  �� release &(Llucee/runtime/util/NumberIterator;)V��
�� S
                              </select>
          
                            � 4
    
              
          </div>
          �
    
           
    
    
    
     
    
     
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
      <option value="2">Every 2 Hours (Current Day's Quarantine Report)�</option>
      <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
      <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
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
    
      <label><strong>Download Messages from User Portal</strong>��</label>
      <div class="alert alert-danger">
      <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
      <p>Enabling can expose recipients to malware</p>
      </div>
    <select class="form-control" name="download_msg" data-placeholder="download_msg" style="width: 100%">                  
    <option value="0" selected="selected">Disable</option>
    <option value="1">Enable</option>
    
    </select> 
    </div>
    
    
    
    
    
    
    
      
    
      <div class="form-group">
        <label><strong>PDF Encryption</strong></label>
      
      <select class="form-control" name="pdf_enabled" data-placeholder="pdf_enabled" style="width: 100%">                  
      <option value="2" selected="selected">Disable</option>
      <option value="1">Enable</option>
      
      </select> 
      </div>
    
      
    
        
    
        <div class="form-group">
          <label><strong>S/MIME Encryption</strong></label>
        
        <select class="form-control" name="smime_enabled" data-placeholder="smime_enabled" style="width: 100%">                  
        �<option value="2" selected="selected">Disable</option>
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
        </div>
      
        
    
    
            
    
            <div class="form-group">
              <label><strong>PGP Encryption</strong></label>
            
            <select class="form-control" name="pgp_enabled" data-placeholder="pgp_enabled" style="width: 100%">                  
            <option value="2" selected="selected">Disable�X</option>
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
    
      
  
      � deleterecipient� lucee.runtime.tag.Location� 
cflocation� OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:500� lucee/runtime/tag/Location� !view_internal_recipients.cfm?m2=1� setUrl� 1
�� setAddtoken�
��
�
�6 "
      
          

          � 

          � OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:511� *
              
          

          � 
      

� ,�  lucee/runtime/type/util/ListUtil� listToArrayRemoveEmpty @(Ljava/lang/String;Ljava/lang/String;)Llucee/runtime/type/Array;��
�� lucee/runtime/type/Array� size� $�� i� getVariableReference Y(Llucee/runtime/PageContext;Ljava/lang/String;)Llucee/runtime/type/ref/VariableReference;��
 Z� getE (I)Ljava/lang/Object;���� (lucee/runtime/type/ref/VariableReference� �[
�� 


      � integer� _I� �	 �� (lucee/runtime/functions/decision/IsValid� B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &�
�� OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:524� getrecipient� :
        select id, recipient from recipients where id = � lucee.runtime.tag.QueryParam� cfqueryparam� OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:525� lucee/runtime/tag/QueryParam  setValue
 CF_SQL_INTEGER setCfsqltype 1


6 

         
           _ID �	 � $./inc/delete_internal_recipients.cfm 

          
             
             <br>
           "
        

          
         
      
          
         
      
        
         
  
      
! OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:551# !view_internal_recipients.cfm?m2=2% 


' 



) editrecipient+ 

  - _M/ �	 �0 4Edit Internal Recipients: form.policy does not exist2 ./inc/error.cfm4 lucee.runtime.tag.Abort6 cfabort8 OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:570: lucee/runtime/tag/Abort<
=
=6 OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:574@ checkpolicyB %
  select id from policy where id = D OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:575F 
H 6Edit Internal Recipients: checkpolicy.recordcount LT 1J OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:582L 5Edit Internal Recipients: form.reports does not existN OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:595P YESR NOT ALLV =Edit Internal Recipients: form.reports is not YEs, NO, or ALLX OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:605Z 7Edit Internal Recipients: form.frequency does not exist\ OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:618^ =Edit Internal Recipients: form.frequency is not valid Integer` OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:626b 9Edit Internal Recipients: form.train_bayes does not existd OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:639f 8Edit Internal Recipients: form.train_bayes is not 0 or 1h OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:648j :Edit Internal Recipients: form.download_msg does not existl OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:661n 9Edit Internal Recipients: form.download_msg is not 0 or 1p OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:670r 9Edit Internal Recipients: form.pdf_enabled does not existt OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:683v 8Edit Internal Recipients: form.pdf_enabled is not 1 or 2x OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:692z ;Edit Internal Recipients: form.smime_enabled does not exist| OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:705~ :Edit Internal Recipients: form.smime_enabled is not 1 or 2� OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:715� 2Edit Internal Recipients: form.sign does not exist� OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:728� 1Edit Internal Recipients: form.sign is not 1 or 2� OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:737� 9Edit Internal Recipients: form.pgp_enabled does not exist� OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:750� 8Edit Internal Recipients: form.pgp_enabled is not 1 or 2� OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:759� 


  � OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:770� 



    � 

    � OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:777� 
        

�       



� OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:788� 4
  select id, recipient from recipients where id = � OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:789� "./inc/edit_internal_recipients.cfm� 

    
      � 
      � 
<br>
    � 
  

    
  � 


  
  � OC:\publish\hermes-seg-18.04\proprietary\2\view_internal_recipients_json.cfm:815� !view_internal_recipients.cfm?m2=3� 

    
           
    � 
    

  
  

<form>
    
<span>
  <p>       


<a href="add_internal_recipients.cfm" class="btn btn-secondary" role="button"><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Create Recipient(s)</a>
&nbsp;&nbsp;
<button type="button" id="edit" class="btn btn-warning"><i class="fa fa-edit"></i>&nbsp;&nbsp;Bulk Edit</button>
&nbsp;&nbsp;
<button type="button" id="delete" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Bulk Delete</button>

</p>

<p>

</p>
</span>






<br>






   
  
   
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
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
            �<th>SMIME Encrypt</th>
            <th>PGP Encrypt</th>
            <th>Sign All</th>
            <th>SMIME Certificates</th>
            <th>PGP Keyrings</th>
            
          

          </tr>
        </thead>
        <tbody>


        <td></td>
        <td></td>
        <td></td>
        <td></td>
         <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
      

          </tr>

        </tbody>
        
       
        <tfoot>
          <tr>
              <th></th>
              <th>SMIME Certificates</th>
              <th>PGP Keyrings</th>
              <th>Recipient</th>
              <th>Policy</th>
              <th>Quarantine Reports</th>
              <th>Reports Frequency(Hours)</th>
              <th>Train Bayes</th>
              <th>Download Msg(s)</th>
              ��<th>PDF Encrypt</th>
              <th>S/MIME Encrypt</th>
              <th>PGP Encrypt</th>
              <th>Sign All</th>
              <th>S/MIME Cert(s)</th>
              <th>PGP Keyring(s)</th>
          </tr>
        </tfoot>
      

      </table>

    </form>
    
      
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


� ./inc/main_footer.cfm�.

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
  
  

</html>� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� M2� ERRORMESSAGE� GETDEFAULTPOLICY� 	POLICY_ID� GETUSERPOLICIES� POLICY_NAME� recipient_id� RECIPIENT_ID� GETRECIPIENT� 	RECIPIENT� 	DELETE_ID� policy� POLICY� CHECKPOLICY� reports� REPORTS� 	frequency� 	FREQUENCY� train_bayes� TRAIN_BAYES download_msg DOWNLOAD_MSG pdf_enabled PDF_ENABLED	 smime_enabled SMIME_ENABLED sign SIGN pgp_enabled PGP_ENABLED EDIT_ID subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �             *     *� 
*� *� � *�͵�*+�Ա                 �                � �                 �                 �                  !�      # $         %�      & '   ',  �   �+-� 3+5� 9+;� 3+=� 3+?� 3+A� 9+C� 3+E� 9+G� 3+� J+L� 3� 
M+� O,�+� O+Q� 3+S+� X� ^N6+� X-� /`Y:� !� bY� dYf� hS� ln� q� u� v�N6+� xzS- { {� �+�� 3+�+� X� ^:6+� X� 0`Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3++� �� �*� �2� �� �� `+�� 3+� �*� �2� � �� �� � � 1+�� 3+� �*� �2+� �*� �2� � � � W+�� 3� +�� 3� +�� 3+�+� X� ^:	6
+� X	� 0`Y:� !� bY� dYf� h�� ln� q� u� v�:	6
+� xz�	 { {
� �+�� 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3+ �� �� �� �θ �� � � Q+�� 3+� ղ ع � �� �� � � ++�� 3+� �� �+� ղ ع � � � W+�� 3� � +ݶ 3+� �*� �2� � � �� � � ,+� 3+� J+� 3� :+� O�+� O+� 3� +� 3+� �*� �2� � � �� � � ,+� 3+� J+� 3� :+� O�+� O+� 3� +� 3+� �*� �2� � � �� � � ,+� 3+� J+�� 3� :+� O�+� O+�� 3� +�� 3+� �*� �2� � � �� � � ,+�� 3+� J+�� 3� :+� O�+� O+�� 3� + � 3+� 3+� J+� x��:���� 6� O+�$+&� 3�)��� $:�-� :� +�1W�4�� +�1W�4�7� �=�� :+� x�A�+� x�A� :+� O�+� O+C� 3+� J+� xE��:�G��� 6� v+�$+I� 3+++� �*� �2�L *� �2�O�R�U+W� 3�)��̧ $:�-� :� +�1W�4�� +�1W�4�7� �=�� :+� x�A�+� x�A� :+� O�+� O+�� 3+� J+�� 3++� �*� �2�L �]�`� � � ~+b� 3+� J+d� 3+++� �*� �2�L *� �2�O�R� 3+f� 3+++� �*� �2�L *� �2�O�R� 3+h� 3� :+� O�+� O+j� 3��++� �*� �2�L �]�`� � ��+l� 3+� J+d� 3+++� �*� �2�L *� �2�O�R� 3+f� 3+++� �*� �2�L *� �2�O�R� 3+h� 3� : +� O �+� O+n� 3+� J+G�r:"+�u6#"#�{ 6$"�~ � � � �6%%"�~ ��:!+� �"�� %d6(!(`��� k"!��#�� � � � � O!��6(+�� 3++� �*� �2� � �R� 3+�� 3++� �*� �2� � �R� 3+�� 3���� ":)"$#�� W+� ��� !��)�"$#�� W+� ��� !��� :*+� O*�+� O+�� 3� +�� 3� :++� O+�+� O+�� 3+�� 3+�� 3+�� 3+�� 3+� �� ع � �� �� � �t+� 3++� ո �*� �2� �� �� � � e+� 3+� x������:,,���,��,��W,��� �=�� :-+� x,�A-�+� x,�A+Ķ 3��++� ո �*� �2� �� ���+ƶ 3+� �*� �2� � �� �� � � f+ƶ 3+� x��ȶ��:..���.��.��W.��� �=�� :/+� x.�A/�+� x.�A+ʶ 3�5+� �*� �2� � �� �� � �+̶ 3+� �*� �2� � �Rθ�:00�� 61+۸�:264�P2+04�� ��W+� 3+�+� ��� � ��+� 3+� J+� x���:55�5��5�5� 666� �+56�$+�� 3+� x�����:77+� ��� � �7�	7�
W7�� �=�� :8+� x7�A8�+� x7�A+� 35�)���� $:959�-� ::6� +�1W5�4:�6� +�1W5�45�7� �=�� :;+� x5�A;�+� x5�A� :<+� O<�+� O+� 3++� �*� �	2�L �]�`� � � �+� 3+� �*� �
2++� �*� �	2�L *� �
2�O� � W+� 3+� �*� �2++� �*� �	2�L ��O� � W+ƶ 3+� 9+� 3+� J+� 3++� ��� � �R� 3+� 3� :=+� O=�+� O+� 3� +� 3� + � 3�441���+"� 3+� J+C� 3+� x��$���:>>&��>��>��W>��� �=�� :?+� x>�A?�+� x>�A+C� 3� :@+� O@�+� O+(� 3� +*� 3� +(� 3��+� �� ع � ,� �� � ��+*� 3++� ո �*� �2� �� �� � � {+.� 3+� ��13� � W+C� 3+5� 9+C� 3+� x79;��=:AA�>WA�?� �=�� :B+� xA�AB�+� xA�A+�� 3��++� ո �*� �2� �� ���+�� 3+� J+� xA��:CC�CC�C�C� 6DD� �+CD�$+E� 3+� x��G��:EE+� �*� �2� � �E�	E�
WE�� �=�� :F+� xE�AF�+� xE�A+I� 3C�)���� $:GCG�-� :HD� +�1WC�4H�D� +�1WC�4C�7� �=�� :I+� xC�AI�+� xC�A� :J+� OJ�+� O+�� 3++� �*� �2�L �]�`� � � |+.� 3+� ��1K� � W+C� 3+5� 9+C� 3+� x79M��=:KK�>WK�?� �=�� :L+� xK�AL�+� xK�A+(� 3� +(� 3� +(� 3++� ո �*� �2� �� �� � � {+.� 3+� ��1O� � W+C� 3+5� 9+C� 3+� x79Q��=:MM�>WM�?� �=�� :N+� xM�AN�+� xM�A+�� 3� ++� ո �*� �2� �� ��+�� 3+� �*� �2� � S� �� � � )+� �*� �2� � U� �� � � � � )+� �*� �2� � W� �� � � � � +�� 3� y+.� 3+� ��1Y� � W+C� 3+5� 9+C� 3+� x79[��=:OO�>WO�?� �=�� :P+� xO�AP�+� xO�A+(� 3+(� 3� +(� 3++� ո �*� �2� �� �� � � {+.� 3+� ��1]� � W+C� 3+5� 9+C� 3+� x79_��=:QQ�>WQ�?� �=�� :R+� xQ�AR�+� xQ�A+�� 3� �++� ո �*� �2� �� �� �+.� 3+�+� �*� �2� � �� � � |+.� 3+� ��1a� � W+C� 3+5� 9+C� 3+� x79c��=:SS�>WS�?� �=�� :T+� xS�AT�+� xS�A+(� 3� +(� 3� +(� 3++� ո �*� �2� �� �� � � {+.� 3+� ��1e� � W+C� 3+5� 9+C� 3+� x79g��=:UU�>WU�?� �=�� :V+� xU�AV�+� xU�A+�� 3� �++� ո �*� �2� �� �� �+�� 3+� �*� �2� � `� �� � � (+� �*� �2� � � �� � � � � +�� 3� x+C� 3+� ��1i� � W+C� 3+5� 9+C� 3+� x79k��=:WW�>WW�?� �=�� :X+� xW�AX�+� xW�A+(� 3+(� 3� +(� 3++� ո �*� �2� �� �� � � {+.� 3+� ��1m� � W+C� 3+5� 9+C� 3+� x79o��=:YY�>WY�?� �=�� :Z+� xY�AZ�+� xY�A+�� 3� �++� ո �*� �2� �� �� �+�� 3+� �*� �2� � `� �� � � (+� �*� �2� � � �� � � � � +�� 3� x+C� 3+� ��1q� � W+C� 3+5� 9+C� 3+� x79s��=:[[�>W[�?� �=�� :\+� x[�A\�+� x[�A+(� 3+(� 3� +(� 3++� ո �*� �2� �� �� � � {+.� 3+� ��1u� � W+C� 3+5� 9+C� 3+� x79w��=:]]�>W]�?� �=�� :^+� x]�A^�+� x]�A+�� 3� �++� ո �*� �2� �� �� �+�� 3+� �*� �2� � � �� � � (+� �*� �2� � � �� � � � � +.� 3� x+C� 3+� ��1y� � W+C� 3+5� 9+C� 3+� x79{��=:__�>W_�?� �=�� :`+� x_�A`�+� x_�A+(� 3+(� 3� +(� 3++� ո �*� �2� �� �� � � {+.� 3+� ��1}� � W+C� 3+5� 9+C� 3+� x79��=:aa�>Wa�?� �=�� :b+� xa�Ab�+� xa�A+�� 3� �++� ո �*� �2� �� �� �+�� 3+� �*� �2� � � �� � � (+� �*� �2� � � �� � � � � +�� 3� y+.� 3+� ��1�� � W+C� 3+5� 9+C� 3+� x79���=:cc�>Wc�?� �=�� :d+� xc�Ad�+� xc�A+(� 3+(� 3� +(� 3++� ո �*� �2� �� �� � � {+.� 3+� ��1�� � W+C� 3+5� 9+C� 3+� x79���=:ee�>We�?� �=�� :f+� xe�Af�+� xe�A+�� 3� �++� ո �*� �2� �� �� �+�� 3+� �*� �2� � � �� � � (+� �*� �2� � � �� � � � � +�� 3� x+C� 3+� ��1�� � W+C� 3+5� 9+C� 3+� x79���=:gg�>Wg�?� �=�� :h+� xg�Ah�+� xg�A+(� 3+(� 3� +(� 3++� ո �*� �2� �� �� � � {+.� 3+� ��1�� � W+C� 3+5� 9+C� 3+� x79���=:ii�>Wi�?� �=�� :j+� xi�Aj�+� xi�A+�� 3� �++� ո �*� �2� �� �� �+�� 3+� �*� �2� � � �� � � (+� �*� �2� � � �� � � � � +�� 3� x+C� 3+� ��1�� � W+C� 3+5� 9+C� 3+� x79���=:kk�>Wk�?� �=�� :l+� xk�Al�+� xk�A+(� 3+(� 3� +�� 3++� ո �*� �2� �� �� � � f+.� 3+� x������:mm���m��m��Wm��� �=�� :n+� xm�An�+� xm�A+�� 3��++� ո �*� �2� �� ���+�� 3+� �*� �2� � �� �� � � f+�� 3+� x������:oo���o��o��Wo��� �=�� :p+� xo�Ap�+� xo�A+�� 3�4+� �*� �2� � �� �� � �+�� 3+� �*� �2� � �Rθ�:qq�� 6r+۸�:s6u�Ms+qu�� ��W+�� 3+�+� ��� � ��+.� 3+� J+� x���:vv�v��v�v� 6ww� �+vw�$+�� 3+� x�����:xx+� ��� � �x�	x�
Wx�� �=�� :y+� xx�Ay�+� xx�A+C� 3v�)���� $:zvz�-� :{w� +�1Wv�4{�w� +�1Wv�4v�7� �=�� :|+� xv�A|�+� xv�A� :}+� O}�+� O+.� 3++� �*� �	2�L �]�`� � � �+�� 3+� �*� �
2++� �*� �	2�L *� �
2�O� � W+�� 3+� �*� �2++� �*� �	2�L ��O� � W+�� 3+�� 9+�� 3+� J+�� 3++� ��� � �R� 3+�� 3� :~+� O~�+� O+�� 3� +�� 3� +�� 3�uur���+(� 3+� J+I� 3+� x������:�������W��� �=�� :�+� x�A��+� x�A+I� 3� :�+� O��+� O+(� 3� +*� 3� +�� 3� +�� 3+�� 3+�� 3+�� 9+ö 3� = = F F  ���  @II  ���  ���  P`c )Plo  %��  ��  OR )[^  ���  ���  �RR  ���  W��  

  �++  ���  	^	�	�  
�
�
�  
w
�
� )
w
�
�  
L00  
6JJ  �!!  z��  ^��  p��  '[[  
�� )
��  ���  ���  Ypp    //  ���  x��  "99  
!!  ���  ���  @WW  )@@  ���  ���  `ww  H__  �  ���  Z  �""  3cc  �� )��  ���  ���  ���    < <  � ] ]            * +    r           ?  x ) y 6 { 9 � @ � Q � T � W � � � �1 �W �| �� �� �� �� �� �R �v �� �� �� �� �� �� �
 � � �9 �< �Y �_ �b �� �� �� �� �� �� �� �� �� � �$T&�()C*�,�-�1�5c6i8�9�=>�?�@A!C%F8G<IM�[�|�����	�	�	E�	�	�	�


/
{
�Z����28<B F#LS#W&a'�(�*�+�.�/�24638I9W:�<�>?v@�BD2E@F�H�I�K�L�N�O�Q�R�S4UUW�Y�[�\�]J_M`QbWc[e^f�h�i�j�ln;pQq_r�t�u�w�x�z�{�}�~	S�t���������<�?�C�I�M�P�t��������S�\�r�����������������'�q���������[�^�b�h�l�o��������"�r�|�����������������#�9�G�������!�/�z�}��������������� �A���������	����� A���	=hk��}�#U��� �!�$�%�'�(�+��+�.�/ W0 n2 t3 x6 ~7 �: �; �> �� �� � �     ) ��         �         ) ��          �         ) ��         �        �      O    C* � �Y���SYܸ�SY޸�SY��SY��SY��SY��SY��SY��SY	��SY
��SY��SY��SY���SY���SY���SY���SY���SY���SY ��SY��SY��SY��SY��SY
��SY��SY��SY��SY��SY��SY��SY��S� ��         