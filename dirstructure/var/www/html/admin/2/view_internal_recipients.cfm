����   2I .proprietary/_2/view_internal_recipients_cfm$cf  lucee/runtime/PageImpl  3/compile/proprietary/2/view_internal_recipients.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  |�U�� getSourceLength      �Q getCompileTime  }�� getHash ()I�h�i call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this 0Lproprietary/_2/view_internal_recipients_cfm$cf; �<!DOCTYPE html>




<html lang="en">


  <head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Internal Recipients</title>

   , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 ./inc/html_head.cfm 4 	doInclude (Ljava/lang/String;Z)V 6 7
 / 8�







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
  
  </script>



<script>

  $(document).ready(function() {
    $("#editoptions").click(function() {
      var editrecipient = [];
      $.each($("input[name='id']:checked"), function() {
        editrecipient.push($(this).val());
      });
      $('#editoptions_modal').modal('show').on('shown.bs.modal', function() {
      $("#editoptionsid").html(' :M<input type="hidden" name="recipient_id" value=' + editrecipient + '>');
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

</style>
  

</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">



   < ./inc/top_navbar.cfm > 
   @ ./inc/main_sidebar.cfm B

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
             D outputStart F 
 / G P
            <h1 class="m-0">Internal Recipients</h1>
            
           I 	outputEnd K 
 / L)
            
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

    
    
     N errormessage P &lucee/runtime/config/NullSupportHelper R NULL T '
 S U -lucee/runtime/interpreter/VariableInterpreter W getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; Y Z
 X [ 0 ] %lucee/runtime/exp/ExpressionException _ java/lang/StringBuilder a The required parameter [ c  1
 b e append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; g h
 b i ] was not provided. k -(Ljava/lang/String;)Ljava/lang/StringBuilder; g m
 b n toString ()Ljava/lang/String; p q
 b r
 ` e lucee/runtime/PageContextImpl u any w�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V { |
 v } 
    
      m2 �  
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

           � #lucee/commons/color/ConstantsDouble � _0 Ljava/lang/Double; � �	 � � � � 

         
        
  
         2 !Recipient(s) deleted successfully .<br>
        
          </div>

          	 1 �

          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-ban"></i> Oops!</h4>
             MYou must first select recipient(s) before clicking the Edit or Delete buttons  
          </div>

           
        
         

 �

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
     DYou must first select recipient(s) before clicking the Delete button 
  </div>

-
      
        
        
        

        
  
 

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
        <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
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
      <option value="1">Enable</option>
      
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
        !I</div>
      
        
    
    
            
    
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
    #�<div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header alert-primary">
          
            <h4 class="modal-title">Edit Recipient Options </h4>
        </div>
          
        <div class="modal-body">

          

          <form name="edit_options" method="post" action="">
    
            <input type="hidden" name="action" value="editoptions">
            <div id="editoptionsid"></div>
         
               

               % lucee.runtime.tag.Query' cfquery) use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag;+,
 v- lucee/runtime/tag/Query/ getdefaultpolicy1 setName3 1
04 hermes6 setDatasource (Ljava/lang/Object;)V89
0: 
doStartTag< $
0= initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V?@
 /A ~
                select policy_id, policy_name, default_policy from spam_policies where default_policy ='1'
                C doAfterBodyE $
0F doCatch (Ljava/lang/Throwable;)VHI
0J popBody ()Ljavax/servlet/jsp/JspWriter;LM
 /N 	doFinallyP 
0Q doEndTagS $
0T lucee/runtime/exp/AbortV newInstance (I)Llucee/runtime/exp/Abort;XY
WZ reuse !(Ljavax/servlet/jsp/tagext/Tag;)V\]
 v^ 
    
              ` getuserpoliciesb �
                select policy_id, policy_name, custom, system from spam_policies where custom='1' and system<>'1' and policy_id<>'d getCollectionf � �g I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �i
 /j &(Ljava/lang/Object;)Ljava/lang/String; pl
 �m writePSQo9
 /p ,' order by policy_name asc
                r #lucee/runtime/util/VariableUtilImplt recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;vw
ux (Ljava/lang/Object;D)I �z
 �{A
    
    
    
                <div class="form-group">
                    <label><strong>SVF Policy to Assign</strong></label>
                    <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                            style="width: 100%;">
                      } <option value=" " selected="selected">� 	</option>� A
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
    
      <label><strong>Download Messages from User Portal</strong>��</label>
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
cflocation� lucee/runtime/tag/Location� view_internal_recipients.cfm� setUrl� 1
�� setAddtoken (Z)V��
��
�=
�T "
      
          

          � 

            � *
              
          

          � 
      

� ,�  lucee/runtime/type/util/ListUtil� listToArrayRemoveEmpty @(Ljava/lang/String;Ljava/lang/String;)Llucee/runtime/type/Array;��
�� lucee/runtime/type/Array� size� $�� i� getVariableReference Y(Llucee/runtime/PageContext;Ljava/lang/String;)Llucee/runtime/type/ref/VariableReference;��
 X� getE (I)Ljava/lang/Object;���� (lucee/runtime/type/ref/VariableReference� �w
�  


       integer _I �	 � (lucee/runtime/functions/decision/IsValid	 B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &

 getrecipient :
        select id, recipient from recipients where id =  lucee.runtime.tag.QueryParam cfqueryparam lucee/runtime/tag/QueryParam setValue9
 CF_SQL_INTEGER setCfsqltype 1

=
T 

        " 
          $ _ID& �	 �' $./inc/delete_internal_recipients.cfm) 

          
            + 
            - <br>
          / "
        

          
        1 
      
          
        3 
      
        
        5 
  
        7 _29 �	 �: 


  < 	
 


> 



@ 


B editoptionsD 

  
  
  F 

  
    H 4Edit Internal Recipients: form.policy does not existJ ./inc/error.cfmL lucee.runtime.tag.AbortN cfabortP lucee/runtime/tag/AbortR
S=
ST 
  
  V checkpolicyX '
    select id from policy where id = Z 6Edit Internal Recipients: checkpolicy.recordcount LT 1\ 5Edit Internal Recipients: form.reports does not exist^ YES` NOb ALLd =Edit Internal Recipients: form.reports is not YEs, NO, or ALLf 7Edit Internal Recipients: form.frequency does not existh =Edit Internal Recipients: form.frequency is not valid Integerj 9Edit Internal Recipients: form.train_bayes does not existl 8Edit Internal Recipients: form.train_bayes is not 0 or 1n :Edit Internal Recipients: form.download_msg does not existp 9Edit Internal Recipients: form.download_msg is not 0 or 1r 
  
  
  
    t 
  
  
      v 
  
      x 
          
  
  z       
  
  
  
  | 6
    select id, recipient from recipients where id = ~ 
      � "./inc/edit_internal_recipients.cfm� 
  
      
        � <br>
      � 
    
  
      
    � 
  
      
    � 
  
    
    � _3� �	 �� 
  
  
  
  � editencryption� 9Edit Internal Recipients: form.pdf_enabled does not exist� 8Edit Internal Recipients: form.pdf_enabled is not 1 or 2� ;Edit Internal Recipients: form.smime_enabled does not exist� :Edit Internal Recipients: form.smime_enabled is not 1 or 2� 2Edit Internal Recipients: form.sign does not exist� 1Edit Internal Recipients: form.sign is not 1 or 2� 9Edit Internal Recipients: form.pgp_enabled does not exist� 8Edit Internal Recipients: form.pgp_enabled is not 1 or 2� 

    � 



    � 
        

�       



� 4
  select id, recipient from recipients where id = � )./inc/edit_internal_recipients_djigzo.cfm� 

    
      � 
<br>
    � 
  

    
  � 
    
           
    �� 
    

  
  

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




� getrecipients�G
  select recipients.id, recipients.id as theID, recipients.id as theOtherID, recipients.recipient, policy.policy_name, user_settings.report_enabled as report_enabled, user_settings.report_frequency as report_frequency, if(user_settings.train_bayes = 1, 'YES', 'NO') as train_bayes, if(user_settings.download_msg = 1, 'YES', 'NO') as download_msg, if(recipients.pdf_enabled = 1, 'YES', 'NO') as pdf_enabled, if(recipients.smime_enabled = '1', 'YES', 'NO') as smime_enabled, if(recipients.pgp_enabled = 1, 'YES', 'NO') as pgp_enabled, if(recipients.digital_sign = '1', 'YES', 'NO') as digital_sign, if(recipient_certificates.user_id is NULL, 'NO', 'YES') as cert, if(recipient_keystores.user_id is NULL, 'NO', 'YES') as keystore
  from recipients LEFT JOIN policy ON recipients.policy_id = policy.id LEFT JOIN recipient_certificates ON recipients.id = recipient_certificates.user_id  LEFT JOIN recipient_keystores ON recipients.id = recipient_keystores.user_id  LEFT JOIN user_settings ON recipients.recipient = user_settings.email where recipients.domain is NULL group by recipients.id
  
  �&

    
                
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

        

� <



        <td><input type="checkbox" name="id" value="� H"></td>
        <td><a href="view_recipient_certificates.cfm?type=1&id=� �" class="btn btn-secondary" role="button"><i class="fas fa-user-shield"></i></a></td>
        <td><a href="view_recipient_keyrings.cfm?type=1&id=� a" class="btn btn-secondary" role="button"><i class="fas fa-user-lock"></i></a></td>
        <td>� </td>
         <td>� </td>
            <td>� .</td>

      

          </tr>

        ��

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
    
 
    
    � �
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        � *No Internal Recipients were found</strong>� "
      </div>
    
      
    ��
    
    

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


� ./inc/main_footer.cfm��

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
  

</html>� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� M2� ERRORMESSAGE� GETDEFAULTPOLICY� 	POLICY_ID� GETUSERPOLICIES� POLICY_NAME� recipient_id  RECIPIENT_ID GETRECIPIENT 	RECIPIENT 	DELETE_ID policy
 POLICY CHECKPOLICY reports REPORTS 	frequency 	FREQUENCY train_bayes TRAIN_BAYES download_msg DOWNLOAD_MSG EDIT_ID  pdf_enabled" PDF_ENABLED$ smime_enabled& SMIME_ENABLED( sign* SIGN, pgp_enabled. PGP_ENABLED0 GETRECIPIENTS2 THEID4 
THEOTHERID6 REPORT_ENABLED8 REPORT_FREQUENCY: DIGITAL_SIGN< CERT> KEYSTORE@ subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   BC       D   *     *� 
*� *� � *���*+���        D         �        D        � �        D         �        D         �         D         !�      # $ D        %�      & ' D  2l  �  *2+-� 3+5� 9+;� 3+=� 3+?� 9+A� 3+C� 9+E� 3+� H+J� 3� 
M+� M,�+� M+O� 3+Q+� V� \N6+� V-� /^Y:� !� `Y� bYd� fQ� jl� o� s� t�N6+� vxQ- y y� ~+�� 3+�+� V� \:6+� V� 0^Y:� !� `Y� bYd� f�� jl� o� s� t�:6+� vx� y y� ~+�� 3++� �� �*� �2� �� �� `+�� 3+� �*� �2� � �� �� � � 1+�� 3+� �*� �2+� �*� �2� � � � W+�� 3� +�� 3� +�� 3+�+� V� \:	6
+� V	� 0^Y:� !� `Y� bYd� f�� jl� o� s� t�:	6
+� vx�	 y y
� ~+A� 3++� �� �� �� �� �� W+A� 3+� �� ȹ � �� �� � � ++A� 3+� �� �+� �� ȹ � � � W+Ͷ 3� +϶ 3� +Ѷ 3+�+� V� \:6+� V� 0^Y:� !� `Y� bYd� fӶ jl� o� s� t�:6+� vx� y y� ~+�� 3+�+� V� \:6+� V� 0�Y:� !� `Y� bYd� fն jl� o� s� t�:6+� vx� y y� ~+�� 3+ ֲ �� �� �� �� � � Q+�� 3+� � � � �� �� � � ++�� 3+� �� �+� � � � � � W+�� 3� � +� 3+� �� ȹ � � �� � � C+�� 3+� H+�� 3� :+� M�+� M+�� 3+� �� Ȳ ��  W+� 3� +� 3+� �� ȹ � � �� � � E+�� 3+� H+� 3� :+� M�+� M+
� 3+� �� Ȳ ��  W+� 3� +� 3+� �� ȹ � � �� � � F+� 3+� H+� 3� :+� M�+� M+� 3+� �� Ȳ ��  W+� 3� +� 3+� �*� �2� � � �� � � /+� 3+� H+� 3� :+� M�+� M+� 3� +� 3+ � 3+"� 3+$� 3+&� 3+� H+� v(*�.�0:2�57�;�>6� O+�B+D� 3�G��� $:�K� :� +�OW�R�� +�OW�R�U� �[�� :+� v�_�+� v�_� :+� M�+� M+a� 3+� H+� v(*�.�0:c�57�;�>6� v+�B+e� 3+++� �*� �2�h *� �2�k�n�q+s� 3�G��̧ $:�K� :� +�OW�R�� +�OW�R�U� �[�� : +� v�_ �+� v�_� :!+� M!�+� M+�� 3+� H+�� 3++� �*� �2�h �y�|� � � ~+~� 3+� H+�� 3+++� �*� �2�h *� �2�k�n� 3+�� 3+++� �*� �2�h *� �2�k�n� 3+�� 3� :"+� M"�+� M+�� 3��++� �*� �2�h �y�|� � ��+�� 3+� H+�� 3+++� �*� �2�h *� �2�k�n� 3+�� 3+++� �*� �2�h *� �2�k�n� 3+�� 3� :#+� M#�+� M+�� 3+� H+c��:%+��6&%&�� 6'%�� � � � �6((%�� ��:$+� �%�� (d6+$+`��� k%$��&�� � � � � O$��6++�� 3++� �*� �2� � �n� 3+�� 3++� �*� �2� � �n� 3+�� 3���� ":,%'&�� W+� ��� $��,�%'&�� W+� ��� $��� :-+� M-�+� M+�� 3� +�� 3� :.+� M.�+� M+¶ 3+Ķ 3+ƶ 3+� �� � � ȸ �� � ��+� 3++� � �*� �2� �� �� � � z+ʶ 3+� �� Ȳ͹  W+� 3+� v���.��://ն�/��/��W/��� �[�� :0+� v/�_0�+� v/�_+� 3��++� � �*� �2� �� ���+ʶ 3+� �*� �2� � �� �� � � z+� 3+� �� Ȳ͹  W+ʶ 3+� v���.��:11ն�1��1��W1��� �[�� :2+� v1�_2�+� v1�_+� 3�+� �*� �2� � �� �� � ��+� 3+� �*� �2� � �n��:33�� 64+���:567�F5+37�� �W+� 3++� ��� � ��+� 3+� H+� v(*�.�0:88�587�;8�>699� �+89�B+� 3+� v�.�:::+� ��� � �:�:� W:�!� �[�� :;+� v:�_;�+� v:�_+#� 38�G���� $:<8<�K� :=9� +�OW8�R=�9� +�OW8�R8�U� �[�� :>+� v8�_>�+� v8�_� :?+� M?�+� M+� 3++� �*� �	2�h �y�|� � � �+%� 3+� �*� �
2++� �*� �	2�h *� �
2�k� � W+%� 3+� �*� �2++� �*� �	2�h �(�k� � W+ʶ 3+*� 9+,� 3+� H+.� 3++� ��� � �n� 3+0� 3� :@+� M@�+� M+2� 3� +4� 3� +6� 3�774���+8� 3+� �� Ȳ;�  W+=� 3+� v���.��:AAն�A��A��WA��� �[�� :B+� vA�_B�+� vA�_+?� 3� +A� 3� +C� 3�6+� �� � � E� �� � �K+G� 3++� � �*� �2� �� �� � � y+I� 3+� �� �K� � W+�� 3+M� 9+�� 3+� vOQ�.�S:CC�TWC�U� �[�� :D+� vC�_D�+� vC�_+W� 3��++� � �*� �2� �� ���+W� 3+� H+� v(*�.�0:EEY�5E7�;E�>6FF� �+EF�B+[� 3+� v�.�:GG+� �*� �2� � �G�G� WG�!� �[�� :H+� vG�_H�+� vG�_+A� 3E�G���� $:IEI�K� :JF� +�OWE�RJ�F� +�OWE�RE�U� �[�� :K+� vE�_K�+� vE�_� :L+� ML�+� M+W� 3++� �*� �2�h �y�|� � � x+I� 3+� �� �]� � W+�� 3+M� 9+�� 3+� vOQ�.�S:MM�TWM�U� �[�� :N+� vM�_N�+� vM�_+�� 3� +�� 3� +�� 3++� � �*� �2� �� �� � � y+I� 3+� �� �_� � W+�� 3+M� 9+�� 3+� vOQ�.�S:OO�TWO�U� �[�� :P+� vO�_P�+� vO�_+W� 3�++� � �*� �2� �� ��+W� 3+� �*� �2� � a� �� � � )+� �*� �2� � c� �� � � � � )+� �*� �2� � e� �� � � � � +W� 3� u+I� 3+� �� �g� � W+�� 3+M� 9+�� 3+� vOQ�.�S:QQ�TWQ�U� �[�� :R+� vQ�_R�+� vQ�_+�� 3+�� 3� +�� 3++� � �*� �2� �� �� � � y+I� 3+� �� �i� � W+�� 3+M� 9+�� 3+� vOQ�.�S:SS�TWS�U� �[�� :T+� vS�_T�+� vS�_+W� 3� �++� � �*� �2� �� �� �+I� 3++� �*� �2� � �� � � x+I� 3+� �� �k� � W+�� 3+M� 9+�� 3+� vOQ�.�S:UU�TWU�U� �[�� :V+� vU�_V�+� vU�_+�� 3� +�� 3� +�� 3++� � �*� �2� �� �� � � y+I� 3+� �� �m� � W+�� 3+M� 9+�� 3+� vOQ�.�S:WW�TWW�U� �[�� :X+� vW�_X�+� vW�_+W� 3� �++� � �*� �2� �� �� �+W� 3+� �*� �2� � ^� �� � � )+� �*� �2� � � �� � � � � +W� 3� t+�� 3+� �� �o� � W+�� 3+M� 9+�� 3+� vOQ�.�S:YY�TWY�U� �[�� :Z+� vY�_Z�+� vY�_+�� 3+�� 3� +�� 3++� � �*� �2� �� �� � � y+I� 3+� �� �q� � W+�� 3+M� 9+�� 3+� vOQ�.�S:[[�TW[�U� �[�� :\+� v[�_\�+� v[�_+W� 3� �++� � �*� �2� �� �� �+W� 3+� �*� �2� � ^� �� � � )+� �*� �2� � � �� � � � � +W� 3� t+�� 3+� �� �s� � W+�� 3+M� 9+�� 3+� vOQ�.�S:]]�TW]�U� �[�� :^+� v]�_^�+� v]�_+�� 3+�� 3� +u� 3++� � �*� �2� �� �� � � z+� 3+� �� Ȳ͹  W+I� 3+� v���.��:__ն�_��_��W_��� �[�� :`+� v_�_`�+� v_�_+w� 3��++� � �*� �2� �� ���+y� 3+� �*� �2� � �� �� � � z+� 3+� �� Ȳ͹  W+y� 3+� v���.��:aaն�a��a��Wa��� �[�� :b+� va�_b�+� va�_+{� 3�<+� �*� �2� � �� �� � �+}� 3+� �*� �2� � �n��:cc�� 6d+���:e6g�Ee+cg�� �W+W� 3++� ��� � ��+I� 3+� H+� v(*�.�0:hh�5h7�;h�>6ii� �+hi�B+� 3+� v�.�:jj+� ��� � �j�j� Wj�!� �[�� :k+� vj�_k�+� vj�_+�� 3h�G���� $:lhl�K� :mi� +�OWh�Rm�i� +�OWh�Rh�U� �[�� :n+� vh�_n�+� vh�_� :o+� Mo�+� M+I� 3++� �*� �	2�h �y�|� � � �+�� 3+� �*� �
2++� �*� �	2�h *� �
2�k� � W+�� 3+� �*� �2++� �*� �	2�h �(�k� � W+y� 3+�� 9+�� 3+� H+#� 3++� ��� � �n� 3+�� 3� :p+� Mp�+� M+�� 3� +�� 3� +�� 3�ggd���+I� 3+� �� Ȳ��  W+�� 3+� H+A� 3+� v���.��:qqն�q��q��Wq��� �[�� :r+� vq�_r�+� vq�_+A� 3� :s+� Ms�+� M+�� 3� +�� 3� +C� 3�
�+� �� � � �� �� � �
�+A� 3++� � �*� �2� �� �� � � x+�� 3+� �� ��� � W+A� 3+M� 9+A� 3+� vOQ�.�S:tt�TWt�U� �[�� :u+� vt�_u�+� vt�_+� 3� �++� � �*� �2� �� �� �+� 3+� �*� �2� � � �� � � )+� �*� �2� � � �� � � � � +�� 3� u+A� 3+� �� ��� � W+A� 3+M� 9+A� 3+� vOQ�.�S:vv�TWv�U� �[�� :w+� vv�_w�+� vv�_+C� 3+C� 3� +C� 3++� � �*� �2� �� �� � � x+�� 3+� �� ��� � W+A� 3+M� 9+A� 3+� vOQ�.�S:xx�TWx�U� �[�� :y+� vx�_y�+� vx�_+� 3� �++� � �*� �2� �� �� �+� 3+� �*� �2� � � �� � � )+� �*� �2� � � �� � � � � +� 3� u+�� 3+� �� ��� � W+A� 3+M� 9+A� 3+� vOQ�.�S:zz�TWz�U� �[�� :{+� vz�_{�+� vz�_+C� 3+C� 3� +C� 3++� � �*� �2� �� �� � � x+�� 3+� �� ��� � W+A� 3+M� 9+A� 3+� vOQ�.�S:||�TW|�U� �[�� :}+� v|�_}�+� v|�_+� 3� �++� � �*� �2� �� �� �+� 3+� �*� �2� � � �� � � )+� �*� �2� � � �� � � � � +� 3� u+A� 3+� �� ��� � W+A� 3+M� 9+A� 3+� vOQ�.�S:~~�TW~�U� �[�� :+� v~�_�+� v~�_+C� 3+C� 3� +C� 3++� � �*� �2� �� �� � � x+�� 3+� �� ��� � W+A� 3+M� 9+A� 3+� vOQ�.�S:���TW��U� �[�� :�+� v��_��+� v��_+� 3� �++� � �*� �2� �� �� �+� 3+� �*� �2� � � �� � � )+� �*� �2� � � �� � � � � +� 3� u+A� 3+� �� ��� � W+A� 3+M� 9+A� 3+� vOQ�.�S:���TW��U� �[�� :�+� v��_��+� v��_+C� 3+C� 3� +=� 3++� � �*� �2� �� �� � � y+�� 3+� �� Ȳ͹  W+�� 3+� v���.��:��ն�������W���� �[�� :�+� v��_��+� v��_+�� 3��++� � �*� �2� �� ���+�� 3+� �*� �2� � �� �� � � z+� 3+� �� Ȳ͹  W+�� 3+� v���.��:��ն�������W���� �[�� :�+� v��_��+� v��_+�� 3�+� �*� �2� � �� �� � ��+�� 3+� �*� �2� � �n��:���� 6�+���:�6��?�+���� �W+� 3++� ��� � ��	+�� 3+� H+� v(*�.�0:���5�7�;��>6��� �+���B+�� 3+� v�.�:��+� ��� � ����� W��!� �[�� :�+� v��_��+� v��_+A� 3��G���� $:����K� :��� +�OW��R���� +�OW��R��U� �[�� :�+� v��_��+� v��_� :�+� M��+� M+�� 3++� �*� �	2�h �y�|� � � �+�� 3+� �*� �
2++� �*� �	2�h *� �
2�k� � W+�� 3+� �*� �2++� �*� �	2�h �(�k� � W+�� 3+�� 9+�� 3+� H+�� 3++� ��� � �n� 3+�� 3� :�+� M��+� M+�� 3� +�� 3� +϶ 3�������+�� 3+� �� Ȳ��  W+� 3+� v���.��:��ն�������W���� �[�� :�+� v��_��+� v��_+A� 3� +A� 3� +�� 3� +�� 3+� H+� v(*�.�0:����5�7�;��>6��� O+���B+�� 3��G��� $:����K� :��� +�OW��R���� +�OW��R��U� �[�� :�+� v��_��+� v��_� :�+� M��+� M+�� 3++� �*� � 2�h �y�|� � ��+�� 3+� H+���:�+��6����� 6���� � � �X6����� ��:�+� ���� �d6���`����������� � � � �����6�+¶ 3++� ��(� � �n� 3+Ķ 3++� �*� �!2� � �n� 3+ƶ 3++� �*� �"2� � �n� 3+ȶ 3++� �*� �
2� � �n� 3+ʶ 3++� �*� �2� � �n� 3+̶ 3++� �*� �#2� � �n� 3+̶ 3++� �*� �$2� � �n� 3+̶ 3++� �*� �2� � �n� 3+̶ 3++� �*� �2� � �n� 3+̶ 3++� �*� �2� � �n� 3+̶ 3++� �*� �2� � �n� 3+̶ 3++� �*� �2� � �n� 3+̶ 3++� �*� �%2� � �n� 3+̶ 3++� �*� �&2� � �n� 3+̶ 3++� �*� �'2� � �n� 3+ζ 3��� ":������ W+� ��� ���������� W+� ��� ���� :�+� M��+� M+ж 3� S++� �*� � 2�h �y�|� � � /+Ҷ 3+� H+Զ 3� :�+� M��+� M+ֶ 3� +ض 3+�� 9+ܶ 3� L 7 @ @  ���  ''  ���  ���  p�� )p��  K��  8��  /fi )/ru  
��  ���  ii  �  n��  	!	!  �	B	B  	�	�	�  
�
�
�  ���  � )�"  }XX  jrr  &JJ  ���  ���  7kk  �� )��  ���  ���  f}}  
!!  66  ���  w��  22    ���  ���  #HH  ���  55  �[^ )�gj  ���  ���  n��  �##  �CC  �  ���  {��  e||    � 	 	   � � �  !!�!�  "":":  "�"�"�  #�$&$&  #�$L$O )#�$X$[  #�$�$�  #�$�$�  %\%�%�  %�&&  &}&�&� )&}&�&�  &X&�&�  &E&�&�  '})w)w  '.)�)�  )�**   E         * +  F  �m           _  d  � # � 0 � 3 � : � K � N � Q � � � �+ �Q �v �| � �� �� �� � �' �F �L �O �U �X �[ �� � �@ �c �� �� �� �� �� �� �� �� �� � � �8 �; �O �Y �~ �� �����	�H-�1�4�t���3�Z�����	��z������������	2�	8�	<�	O�	S�	d-	�/	�1	�3
5
 :
<<
d>
{@
�B
�G
�IFKcM�NO�Q�R�SUX*YDZ[]a^e`kaoduI|d�f�i�l�m�p�qt)v,xPzf{t|�~��!����,�B�P�������������������<�^�������	�P�S�V�\�_�b����������=�S�a������������������M�o���������5�8�;�A�D�G�k���������K�T�j�x����������������c��������E�H�� ��O��)X
gr������������=S!Y"]%c&g)�+�-�/�0�1!3C5�7�8�9�:
<=?@BCAEWFeG�I�K"M+OAPOQ�S�T�V�W�Y�Z�\�]�^:`\b�d�e�f�g $i 'j +l 1m 5o 8p [r qs t �v �x!<z!E{![|!i}!�!��!��!��!��!��!��!��"U�"w�"��"��#�#7�#:�#��#��#��$@�$��$��%�%F�%U�%`�%z�%��%��%��%��%��%��%��%��%��& �&&�&*�&0�&4�&:�&>�&A&�"&�$''('*D'�H'�I'�J(	K('L(EM(cN(�O(�P(�Q(�R(�S)T)5U)SV)t\)�^)�|)�~)��*�*�*�*!�*-�G     ) �� D        �    G     ) �� D         �    G     ) �� D        �    G    �    D  �    �*(� �Y���SY���SY���SY���SY���SY���SY���SY��SY��SY	��SY
��SY	��SY��SY��SY��SY��SY��SY��SY��SY��SY��SY��SY��SY!��SY#��SY%��SY'��SY)��SY+��SY-��SY/��SY1��SY 3��SY!5��SY"7��SY#9��SY$;��SY%=��SY&?��SY'A��S� ��     H    