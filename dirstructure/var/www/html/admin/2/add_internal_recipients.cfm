����   2� V__138/__138/publish/hermes_seg_18_041454/proprietary/_2/add_internal_recipients_cfm$cf  lucee/runtime/PageImpl  H../../publish/hermes-seg-18.04/proprietary/2/add_internal_recipients.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ���h getSourceLength      U getCompileTime  �\��� getHash ()I�W call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this XL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/add_internal_recipients_cfm$cf; �<!DOCTYPE html>

  
<html lang="en">


 
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Add Internal Recipient(s)</title>
  
   , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 ./inc/html_head.cfm 4 	doInclude (Ljava/lang/String;Z)V 6 7
 / 8!

   <!-- Preloader -->
   <div class="preloader flex-column justify-content-center align-items-center">
    <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
    </div>



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
 / E d
            <h1 class="m-0">Add Internal Recipient(s)
            </h1>
            
           G 	outputEnd I 
 / JC
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Add Internal Recipient(s)</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">


<!-- CFML CODE STARTS HERE -->

 L step N &lucee/runtime/config/NullSupportHelper P NULL R '
 Q S -lucee/runtime/interpreter/VariableInterpreter U getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; W X
 V Y 0 [ %lucee/runtime/exp/ExpressionException ] java/lang/StringBuilder _ The required parameter [ a  1
 ` c append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; e f
 ` g ] was not provided. i -(Ljava/lang/String;)Ljava/lang/StringBuilder; e k
 ` l toString ()Ljava/lang/String; n o
 ` p
 ^ c lucee/runtime/PageContextImpl s any u�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V y z
 t {  
 } errormessage  
 � emptyrecipients � 
emptyemail � invalidemail � invalidemailrecipient �   � alreadyexists � alreadyexistsrecipient � invaliddomain � invaliddomainrecipient � success � successrecipient � djigzonotadded � djigzonotaddedrecipient � 



 � m4 �@       keys $[Llucee/runtime/type/Collection$Key; � �	  � !lucee/runtime/type/Collection$Key � *lucee/runtime/functions/decision/IsDefined � B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z & �
 � � True � lucee/runtime/op/Operator � compare (ZLjava/lang/String;)I � �
 � � urlScope  ()Llucee/runtime/type/scope/URL; � �
 / � lucee/runtime/type/scope/URL � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � � '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � us &()Llucee/runtime/type/scope/Undefined; � �
 / � "lucee/runtime/type/scope/Undefined � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � �   

 � action � lucee/runtime/op/Caster � toStruct /(Ljava/lang/Object;)Llucee/runtime/type/Struct; � �
 � � $lucee/runtime/type/util/KeyConstants � _action #Llucee/runtime/type/Collection$Key; � �	 � � .lucee/runtime/functions/struct/StructKeyExists � \(Llucee/runtime/PageContext;Llucee/runtime/type/Struct;Llucee/runtime/type/Collection$Key;)Z & �
 � � _ACTION � �	 � �  

 � show_recipient � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � lucee/runtime/type/scope/Form � � � &(Ljava/lang/Object;)Ljava/lang/String; n �
 � � $lucee/runtime/functions/string/LCase � A(Llucee/runtime/PageContext;Ljava/lang/String;)Ljava/lang/String; & �
 � � 





 � show_policy � 

 � lucee.runtime.tag.Query � cfquery  IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:128 use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag;
 t lucee/runtime/tag/Query hasBody (Z)V

	 checkpolicy setName 1
	 hermes setDatasource (Ljava/lang/Object;)V
	 
doStartTag $
	 initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V
 / #
select id from policy where id =   lucee.runtime.tag.QueryParam" cfqueryparam$ IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:129& lucee/runtime/tag/QueryParam( setValue*
)+ CF_SQL_INTEGER- setCfsqltype/ 1
)0
) doEndTag3 $
)4 lucee/runtime/exp/Abort6 newInstance (I)Llucee/runtime/exp/Abort;89
7: reuse !(Ljavax/servlet/jsp/tagext/Tag;)V<=
 t> doAfterBody@ $
	A doCatch (Ljava/lang/Throwable;)VCD
	E popBody ()Ljavax/servlet/jsp/JspWriter;GH
 /I 	doFinallyK 
	L
	4 getCollectionO � �P #lucee/runtime/util/VariableUtilImplR recordcount A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object;TU
SV (Ljava/lang/Object;D)I �X
 �Y _M[ �	 �\ 5Add Internal Recipients: checkpolicy.recordcount LT 1^ ./inc/error.cfm` lucee.runtime.tag.Abortb cfabortd IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:136f lucee/runtime/tag/Aborth
i
i4 


l show_reportsn YESp NOr ALLt ;Add Internal Recipients: form.reports is not YES, NO or ALLv IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:165x show_frequencyz  
  
| 
  
~ integer� (lucee/runtime/functions/decision/IsValid� B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &�
�� 6Add Internal Recipients: form.frequency is not integer� IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:182� 
  
  

� 
  

� show_train_bayes� 1� 7Add Internal Recipients: form.train_bayes is not 0 or 1� IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:208� show_download_msg� 8Add Internal Recipients: form.download_msg is not 0 or 1� IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:229� show_pdf_enabled� 2� 

  � 7Add Internal Recipients: form.pdf_enabled is not 1 or 2� IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:250� show_smime_enabled� 9Add Internal Recipients: form.smime_enabled is not 1 or 2� IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:271�   


� 	show_sign� 0Add Internal Recipients: form.sign is not 1 or 2� IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:292� show_pgp_enabled� 7Add Internal Recipients: form.pgp_enabled is not 1 or 2� IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:313� � � add� #lucee/commons/color/ConstantsDouble� _1 Ljava/lang/Double;��	�� (./inc/add_internal_recipients_manual.cfm�  




  
� +

<!-- ERROR MESSAGES STARTS HERE -->

� �

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    � &The Recipient(s) field cannot be blank� 
  </div>

� �
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    � The following � $ Recipients were added successfully:� 
<br>
    � 
  </div>
� 
 

� �

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      � AErrors were encountered while adding recipients. Please see below� 
    </div>

� �

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      
      � There were �  blank recipient(s)� ( entries had invalid e-mail address(es):� <br>
      � �

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    
    �  recipient(s) already existed:� < recipient(s) entries had domains the system does not relay:� 6 recipient(s) entries had problems setting encryption:��


<!-- ERROR MESSAGES ENDS HERE -->

<span>
  <p>       


<a href="view_internal_recipients.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Internal Recipients</a>







</p>


</span>


<!-- ADD RECIPIENT FORM STARTS HERE -->


<!-- form start -->

  <form name="add_internal_recipients.cfm" method="post" action="">
  <input type="hidden" name="action" value="add">
    <div class="box-body">
       
      ��
        <div class="form-horizontal">
          <label for="recipients"><strong>Recipient(s)</strong></label>
          <div class="form-group">
              
                
                  <textarea class="form-control" name="recipient" rows="10" placeholder="Enter recipient e-mail address(es) each in its own line" required></textarea>            
          </div>

           

          � IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:471� getdefaultpolicy� v
            select policy_id, policy_name, default_policy from spam_policies where default_policy ='1'
            � 

          � IC:\publish\hermes-seg-18.04\proprietary\2\add_internal_recipients.cfm:475  getuserpolicies �
            select policy_id, policy_name, custom, system from spam_policies where custom='1' and system<>'1' and policy_id<>' I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �
 / writePSQ	
 /
 (' order by policy_name asc
            !



            <div class="form-group">
                <label><strong>SVF Policy to Assign</strong></label>
                <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                        style="width: 100%;">
                   <option value=" " selected="selected"> 	</option> 5
                    </select>

                  ;
                    <div class="form-group">
                      <label><strong>SVF Policy to Assign</strong></label>
                      <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                              style="width: 100%;">
                         
                         getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;
 / getId  $
 /! lucee/runtime/type/Query# getCurrentrow (I)I%&$' getRecordcount) $$* !lucee/runtime/util/NumberIterator, load '(II)Llucee/runtime/util/NumberIterator;./
-0 addQuery (Llucee/runtime/type/Query;)V23 �4 isValid (I)Z67
-8 current: $
-; go (II)Z=>$? +
                          <option value="A ">C ?</option>
                        
                          E removeQueryG  �H release &(Llucee/runtime/util/NumberIterator;)VJK
-L G
                          </select>
      
                        N 1

                       
      </div>
      P:

       



 

 
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
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)R</option>
 
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

  <label><strong>Download Messages from User Portal</strong></label>
  <div class="alert alert-danger">
  <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
  <p>Enabling can expose recipients to malware</p>
  </div>
<select class="form-control" name="download_msg" data-placeholder="download_msg" style="width: 100%">                  
T �<option value="0" selected="selected">Disable</option>
<option value="1">Enable</option>


</select> 
</div>






  <div class="alert alert-warning">
    
    <h5><i class="icon fas fa-exclamation-circle"></i> Please Note!</h5>
    V �Setting PDF, S/MIME or PGP Encryption below to <strong>Enable</strong> will significantly increase the amount of time it takes to add new recipient(s) X
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
    <option value="2" selected="selected">Disable</option>
    <option value="1">Enable</option>
  
    
    </select> 
    </div>
  
    

    
    

    <div class="form-group">
      <label><strong>S/MIME SIGNATURE</strong></label>
    
      <p class="help-block">Effective only when S/MIME Certificate present</p>
    
    <select class="form-control" name="sign" data-placeholder="sign" style="width: 100%">                  
    Z <option value="2" selected="selected">Sign Encrypted Messages Only</option>
    <option value="1">Sign all messages</option>
   
    
    </select> 
    </div>
  
    


        

        <div class="form-group">
          <label><strong>PGP Encryption</strong></label>
        
        <select class="form-control" name="pgp_enabled" data-placeholder="pgp_enabled" style="width: 100%">                  
        <option value="2" selected="selected">Disable</option>
        <option value="1">Enable</option>
   
        
        </select> 
        </div>
      
        

      <div class="box-footer">
        
       
        
        
              <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  

            </div>      

  

    
  </form>

  <div>&nbsp;</div>


<!-- ADD RECIPIENT FORM ENDS HERE -->

</div>
</div>

<div id="loader"></\Ydiv>

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


^ ./inc/main_footer.cfm`



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



</html>b udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageExceptionj  lucee/runtime/type/UDFPropertiesl udfs #[Llucee/runtime/type/UDFProperties;no	 p setPageSourcer 
 s lucee/runtime/type/KeyImplu intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;wx
vy M4{ 	recipient} 	RECIPIENT SHOW_RECIPIENT� policy� POLICY� CHECKPOLICY� SHOW_POLICY� reports� REPORTS� SHOW_REPORTS� 	frequency� 	FREQUENCY� SHOW_FREQUENCY� train_bayes� TRAIN_BAYES� SHOW_TRAIN_BAYES� download_msg� DOWNLOAD_MSG� SHOW_DOWNLOAD_MSG� pdf_enabled� PDF_ENABLED� SHOW_PDF_ENABLED� smime_enabled� SMIME_ENABLED� SHOW_SMIME_ENABLED� sign� SIGN� 	SHOW_SIGN� pgp_enabled� PGP_ENABLED� SHOW_PGP_ENABLED� EMPTYRECIPIENTS� SUCCESS� SUCCESSRECIPIENT� ERRORMESSAGE� 
EMPTYEMAIL� INVALIDEMAIL� INVALIDEMAILRECIPIENT� ALREADYEXISTS� ALREADYEXISTSRECIPIENT� INVALIDDOMAIN� INVALIDDOMAINRECIPIENT� DJIGZONOTADDED� DJIGZONOTADDEDRECIPIENT� GETDEFAULTPOLICY� 	POLICY_ID� GETUSERPOLICIES� POLICY_NAME� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *�m�q*+�t�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  %�  �   �+-� 3+5� 9+;� 3+=� 9+?� 3+A� 9+C� 3+� F+H� 3� 
M+� K,�+� K+M� 3+O+� T� ZN6+� T-� /\Y:� !� ^Y� `Yb� dO� hj� m� q� r�N6+� tvO- w w� |+~� 3+�+� T� Z:6+� T� 0\Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+�� 3+�+� T� Z:	6
+� T	� 0\Y:� !� ^Y� `Yb� d�� hj� m� q� r�:	6
+� tv�	 w w
� |+�� 3+�+� T� Z:6+� T� 0\Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+�� 3+�+� T� Z:6+� T� 0\Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+�� 3+�+� T� Z:6+� T� 0�Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+�� 3+�+� T� Z:6+� T� 0\Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+�� 3+�+� T� Z:6+� T� 0�Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+�� 3+�+� T� Z:6+� T� 0\Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+�� 3+�+� T� Z:6+� T� 0�Y: � !� ^Y� `Yb� d�� hj� m� q� r� :6+� tv� w w� |+�� 3+�+� T� Z:!6"+� T!� 0\Y:#� !� ^Y� `Yb� d�� hj� m� q� r�#:!6"+� tv�! w w"� |+�� 3+�+� T� Z:$6%+� T$� 0�Y:&� !� ^Y� `Yb� d�� hj� m� q� r�&:$6%+� tv�$ w w%� |+�� 3+�+� T� Z:'6(+� T'� 0\Y:)� !� ^Y� `Yb� d�� hj� m� q� r�):'6(+� tv�' w w(� |+�� 3+�+� T� Z:*6++� T*� 0�Y:,� !� ^Y� `Yb� d�� hj� m� q� r�,:*6++� tv�* w w+� |+�� 3+�+� T� Z:-6.+� T-� 0�Y:/� !� ^Y� `Yb� d�� hj� m� q� r�/:-6.+� tv�- w w.� |+~� 3+ �*� �2� �� ��� �� � � `+�� 3+� �*� �2� � �� �� � � 1+�� 3+� �*� �2+� �*� �2� � � � W+�� 3� +�� 3� +ζ 3+�+� T� Z:061+� T0� 0�Y:2� !� ^Y� `Yb� dж hj� m� q� r�2:061+� tv�0 w w1� |+~� 3++� �� ֲ �� �� � W+�� 3+� �� � � �� �� � � ++�� 3+� Ʋ �+� �� � � � � W+�� 3� +�� 3� +� 3+�+� T� Z:364+� T3� 0�Y:5� !� ^Y� `Yb� d� hj� m� q� r�5:364+� tv�3 w w4� |+~� 3++� � �*� �2� �� � g+�� 3+� �*� �2� � �� �� � � 8+�� 3+� �*� �2++� �*� �2� � � � �� � W+�� 3� +�� 3� +�� 3+�+� T� Z:667+� T6� 0�Y:8� !� ^Y� `Yb� d�� hj� m� q� r�8:667+� tv�6 w w7� |+� 3++� � �*� �2� �� �:+�� 3+� �*� �2� � �� �� � �	+�� 3+� F+� t���	:99�9�9�9�6::� �+9:�+!� 3+� t#%'��):;;+� �*� �2� � �,;.�1;�2W;�5� �;�� :<+� t;�?<�+� t;�?+�� 39�B���� $:=9=�F� :>:� +�JW9�M>�:� +�JW9�M9�N� �;�� :?+� t9�??�+� t9�?� :@+� K@�+� K+�� 3++� �*� �2�Q �W�Z� � � z+�� 3+� Ʋ]_� � W+�� 3+a� 9+�� 3+� tceg��i:AA�jWA�k� �;�� :B+� tA�?B�+� tA�?+�� 3� 1+�� 3+� �*� �2+� �*� �2� � � � W+m� 3+m� 3� +m� 3� +m� 3+o+� T� Z:C6D+� TC� 1�Y:E� "� ^Y� `Yb� do� hj� m� q� r�E:C6D+� tvoC w wD� |+� 3++� � �*� �	2� �� �/+m� 3+� �*� �
2� � q� �� � � )+� �*� �
2� � s� �� � � � � )+� �*� �
2� � u� �� � � � � 3+�� 3+� �*� �2+� �*� �
2� � � � W+�� 3� x+�� 3+� Ʋ]w� � W+�� 3+a� 9+�� 3+� tcey��i:FF�jWF�k� �;�� :G+� tF�?G�+� tF�?+m� 3+m� 3� +m� 3+{+� T� Z:H6I+� TH� 1�Y:J� "� ^Y� `Yb� d{� hj� m� q� r�J:H6I+� tv{H w wI� |+}� 3++� � �*� �2� �� � �+� 3+�+� �*� �2� � ��� � � z+�� 3+� Ʋ]�� � W+�� 3+a� 9+�� 3+� tce���i:KK�jWK�k� �;�� :L+� tK�?L�+� tK�?+�� 3� 1+�� 3+� �*� �2+� �*� �2� � � � W+�� 3+�� 3� +�� 3+�+� T� Z:M6N+� TM� 1�Y:O� "� ^Y� `Yb� d�� hj� m� q� r�O:M6N+� tv�M w wN� |+� 3++� � �*� �2� �� �+�� 3+� �*� �2� � \� �� � � )+� �*� �2� � �� �� � � � � 3+�� 3+� �*� �2+� �*� �2� � � � W+�� 3� x+�� 3+� Ʋ]�� � W+�� 3+a� 9+�� 3+� tce���i:PP�jWP�k� �;�� :Q+� tP�?Q�+� tP�?+m� 3+m� 3� +m� 3+�+� T� Z:R6S+� TR� 1�Y:T� "� ^Y� `Yb� d�� hj� m� q� r�T:R6S+� tv�R w wS� |+� 3++� � �*� �2� �� �+�� 3+� �*� �2� � \� �� � � )+� �*� �2� � �� �� � � � � 3+�� 3+� �*� �2+� �*� �2� � � � W+�� 3� x+�� 3+� Ʋ]�� � W+�� 3+a� 9+�� 3+� tce���i:UU�jWU�k� �;�� :V+� tU�?V�+� tU�?+m� 3+m� 3� +m� 3+�+� T� Z:W6X+� TW� 1�Y:Y� "� ^Y� `Yb� d�� hj� m� q� r�Y:W6X+� tv�W w wX� |+� 3++� � �*� �2� �� �+�� 3+� �*� �2� � �� �� � � )+� �*� �2� � �� �� � � � � 4+�� 3+� �*� �2+� �*� �2� � � � W+�� 3� x+�� 3+� Ʋ]�� � W+�� 3+a� 9+�� 3+� tce���i:ZZ�jWZ�k� �;�� :[+� tZ�?[�+� tZ�?+m� 3+m� 3� +m� 3+�+� T� Z:\6]+� T\� 1�Y:^� "� ^Y� `Yb� d�� hj� m� q� r�^:\6]+� tv�\ w w]� |+� 3++� � �*� �2� �� �+�� 3+� �*� �2� � �� �� � � )+� �*� �2� � �� �� � � � � 4+�� 3+� �*� �2+� �*� �2� � � � W+�� 3� x+�� 3+� Ʋ]�� � W+�� 3+a� 9+�� 3+� tce���i:__�jW_�k� �;�� :`+� t_�?`�+� t_�?+�� 3+m� 3� +m� 3+�+� T� Z:a6b+� Ta� 1�Y:c� "� ^Y� `Yb� d�� hj� m� q� r�c:a6b+� tv�a w wb� |+� 3++� � �*� �2� �� �+�� 3+� �*� �2� � �� �� � � )+� �*� �2� � �� �� � � � � 4+�� 3+� �*� �2+� �*� �2� � � � W+�� 3� x+�� 3+� Ʋ]�� � W+�� 3+a� 9+�� 3+� tce���i:dd�jWd�k� �;�� :e+� td�?e�+� td�?+m� 3+m� 3� +m� 3+�+� T� Z:f6g+� Tf� 1�Y:h� "� ^Y� `Yb� d�� hj� m� q� r�h:f6g+� tv�f w wg� |+� 3++� � �*� �2� �� �+�� 3+� �*� �2� � �� �� � � )+� �*� �2� � �� �� � � � � 3+�� 3+� �*� � 2+� �*� �2� � � � W+�� 3� x+�� 3+� Ʋ]�� � W+�� 3+a� 9+�� 3+� tce���i:ii�jWi�k� �;�� :j+� ti�?j�+� ti�?+m� 3+m� 3� +�� 3+� Ʋ �� �� �� � � j+�� 3+� �*� �2�� �� �� � � &+�� 3+� �*� �!2�ù � W+�� 3� +�� 3+�� 9+�� 3+Ƕ 3� +ɶ 3+� �*� �!2�� �� �� � � /+˶ 3+� F+Ͷ 3� :k+� Kk�+� K+϶ 3� +m� 3+� �*� �"2�� �� �� � � +Ѷ 3+� F+Ӷ 3++� �*� �"2�� � � 3+ն 3� :l+� Kl�+� K+׶ 3+� F++� �*� �#2�� � � 3� :m+� Km�+� K+ٶ 3� +۶ 3+� �*� �$2�� �� �� � � /+ݶ 3+� F+߶ 3� :n+� Kn�+� K+� 3� +�� 3+� �*� �%2�� \� �� � � M+� 3+� F+� 3++� �*� �%2�� � � 3+� 3� :o+� Ko�+� K+� 3� +�� 3+� �*� �&2�� \� �� � � +� 3+� F+Ӷ 3++� �*� �&2�� � � 3+� 3� :p+� Kp�+� K+� 3+� F++� �*� �'2�� � � 3� :q+� Kq�+� K+� 3� +�� 3+� �*� �(2�� \� �� � � +�� 3+� F+Ӷ 3++� �*� �(2�� � � 3+� 3� :r+� Kr�+� K+׶ 3+� F++� �*� �)2�� � � 3� :s+� Ks�+� K+϶ 3� +�� 3+� �*� �*2�� \� �� � � +�� 3+� F+Ӷ 3++� �*� �*2�� � � 3+� 3� :t+� Kt�+� K+׶ 3+� F++� �*� �+2�� � � 3� :u+� Ku�+� K+϶ 3� +�� 3+� �*� �,2�� \� �� � � +�� 3+� F+Ӷ 3++� �*� �,2�� � � 3+� 3� :v+� Kv�+� K+׶ 3+� F++� �*� �-2�� � � 3� :w+� Kw�+� K+϶ 3� +�� 3+� F+�� 3+� F+� t����	:xx�x��x�x�6yy� O+xy�+�� 3x�B��� $:zxz�F� :{y� +�JWx�M{�y� +�JWx�Mx�N� �;�� :|+� tx�?|�+� tx�?� :}+� K}�+� K+�� 3+� F+� t���	:~~�~�~�~�6� x+~�+� 3+++� �*� �.2�Q *� �/2�� �+� 3~�B��ʧ $:�~��F� :�� +�JW~�M��� +�JW~�M~�N� �;�� :�+� t~�?��+� t~�?� :�+� K��+� K+�� 3++� �*� �02�Q �W�Z� � � �+� 3+� F+� 3+++� �*� �.2�Q *� �/2�� � 3+� 3+++� �*� �.2�Q *� �12�� � 3+� 3� :�+� K��+� K+� 3��++� �*� �02�Q �W�Z� � ��+� 3+� F+� 3+++� �*� �.2�Q *� �/2�� � 3+� 3+++� �*� �.2�Q *� �12�� � 3+� 3� :�+� K��+� K+� 3+� F+�:�+�"6����( 6���+ � � � �6����+ �1:�+� ���5 �d6���`�9� l���<��@ � � � � P��<6�+B� 3++� �*� �/2�� � � 3+D� 3++� �*� �12�� � � 3+F� 3���� ":�����@ W+� ƹI ��M������@ W+� ƹI ��M� :�+� K��+� K+O� 3� +Q� 3� :�+� K��+� K+S� 3+U� 3+W� 3+� F+Y� 3� :�+� K��+� K+[� 3+]� 3+_� 3+a� 9+c� 3� * 1 : :  	C	w	w  	&	�	� )	&	�	�  �	�	�  �	�	�  
s
�
�  ]tt  ���  =TT  ���  G^^  ���  Sjj  ���  ���  +SS  k��  ���  #KK  ���  ���  7__  w��  �  44  }��  ���  DTW )D`c  ��  ��  DG )PS  ���  ���  �AA  ���  J��  ���  �     E O O   �         * +  �  � �           ,  - * / - 6 4 7 E < H > K Q � R Sj T� U. V� W� XT Y� Z [z \� ]> ^� b c) dO et f} g� i� j k% lD mM nV p� q� r� s' t0 u9 w< z� |� ~� �	* �	� �
 �
6 �
L �
Z �
� �
� �
� �
� �
� �
� �
� �
� �
� �
� �U �t �� � �  �6 �D �� �� �� �� �� �� � �% �M �c �q �� �� �� �� �� �� �� �� �a � �� �� �  � �$ �o �r �v �| �� �� �� � �T �{ �� �� �� �� �� �� �  � � �i �� �� � �
 �  �. �y �| �� �� ���`	�����u�� ",#:$�&�'�)�*�,�-�/1k3�5�7�8�9
;<>?AC>EdF~G�H�I�L�Q�S�U�W�Z�[�]�`$a'dde�f�g�j�l�o�p�r�vx{\|b~e�����������0�3�p������������E�K�N�v�y������������� �H����8�������R�X�������}��� � � � ,� 0� :B AQ `R c j� n� q� }��     ) de �        �    �     ) fg �         �    �     ) hi �        �    �    k    �      �*2� �Y��zSY|�zSY~�zSY��zSY��zSY��zSY��zSY��zSY��zSY	��zSY
��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY��zSY ��zSY!��zSY"��zSY#��zSY$¸zSY%ĸzSY&ƸzSY'ȸzSY(ʸzSY)̸zSY*θzSY+иzSY,ҸzSY-ԸzSY.ָzSY/ظzSY0ڸzSY1ܸzS� ��     �    