����   2� T__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_console_settings_cfm$cf  lucee/runtime/PageImpl  F../../publish/hermes-seg-18.04/proprietary/2/view_console_settings.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ��:@  getSourceLength      j� getCompileTime  �\��� getHash ()I�%a� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this VL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_console_settings_cfm$cf; �<!DOCTYPE html>

  

 
<html lang="en">


<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Console Settings</title>

   , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 ./inc/html_head.cfm 4 	doInclude (Ljava/lang/String;Z)V 6 7
 / 8

   <!-- Preloader -->
   <div class="preloader flex-column justify-content-center align-items-center">
    <img src="/dist/img/hermes_preloader.gif" alt="Loading" >
    </div>

    
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
 / E M
            <h1 class="m-0">Console Settings</h1>
            
           G 	outputEnd I 
 / J%
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Console Settings</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">


     



 L step N &lucee/runtime/config/NullSupportHelper P NULL R '
 Q S -lucee/runtime/interpreter/VariableInterpreter U getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; W X
 V Y 0 [ %lucee/runtime/exp/ExpressionException ] java/lang/StringBuilder _ The required parameter [ a  1
 ` c append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; e f
 ` g ] was not provided. i -(Ljava/lang/String;)Ljava/lang/StringBuilder; e k
 ` l toString ()Ljava/lang/String; n o
 ` p
 ^ c lucee/runtime/PageContextImpl s any u�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V y z
 t {  

 } m  
 � sessionScope $()Llucee/runtime/type/scope/Session; � �
 / � lucee/runtime/op/Caster � toStruct /(Ljava/lang/Object;)Llucee/runtime/type/Struct; � �
 � � $lucee/runtime/type/util/KeyConstants � _m #Llucee/runtime/type/Collection$Key; � �	 � � !lucee/runtime/type/Collection$Key � .lucee/runtime/functions/struct/StructKeyExists � \(Llucee/runtime/PageContext;Llucee/runtime/type/Struct;Llucee/runtime/type/Collection$Key;)Z & �
 � � 


  

 � _M � �	 � �  lucee/runtime/type/scope/Session � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � �   � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � us &()Llucee/runtime/type/scope/Undefined; � �
 / � "lucee/runtime/type/scope/Undefined � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � � 





 � 


 � action �  
 � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _action � �	 � � _ACTION � �	 � � lucee/runtime/type/scope/Form � � �   






 � ./inc/get_console_settings.cfm � 

 � consoleMode � keys $[Llucee/runtime/type/Collection$Key; � �	  � getCollection � � � � I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � �
 / � consoleHost � consoleCertificate � dhparam � hsts � sslstapling � sslstaplingverify � lucee.runtime.tag.Query � cfquery � GC:\publish\hermes-seg-18.04\proprietary\2\view_console_settings.cfm:176 � use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; � �
 t � lucee/runtime/tag/Query � hasBody (Z)V � �
 � � getcertdetails � setName � 1
 � � hermes � setDatasource (Ljava/lang/Object;)V
 � 
doStartTag $
 � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V	
 /
 _
select id, subject, issuer, serial, type, friendly_name from system_certificates where id = ' � � &(Ljava/lang/Object;)Ljava/lang/String; n
 � writePSQ
 / '
 doAfterBody $
 � doCatch (Ljava/lang/Throwable;)V
 � popBody ()Ljavax/servlet/jsp/JspWriter;
 /  	doFinally" 
 �# doEndTag% $
 �& lucee/runtime/exp/Abort( newInstance (I)Llucee/runtime/exp/Abort;*+
), reuse !(Ljavax/servlet/jsp/tagext/Tag;)V./
 t0 





2 edit4 



6 ./inc/edit_console_settings.cfm8 )./inc/generate_authelia_configuration.cfm: "./inc/edit_ciphermail_settings.cfm< ./inc/modify_hosts.cfm> #lucee/commons/color/ConstantsDouble@ _27 Ljava/lang/Double;BC	AD � � 


  
  G lucee.runtime.tag.LocationI 
cflocationK GC:\publish\hermes-seg-18.04\proprietary\2\view_console_settings.cfm:206M lucee/runtime/tag/LocationO "/admin/2/view_console_settings.cfmQ java/lang/StringS concat &(Ljava/lang/String;)Ljava/lang/String;UV
TW setUrlY 1
PZ setAddtoken\ �
P]
P
P& 
  
 


a 
generatedhc /opt/hermes/tmp/dhparam.peme 'lucee/runtime/functions/file/FileExistsg 0(Llucee/runtime/PageContext;Ljava/lang/Object;)Z &i
hj yGenerate DH Parameters File: There was an attempt to generate DH Parameters file while /opt/hermes/tmp/dhparam.pem existsl ./inc/error.cfmn lucee.runtime.tag.Abortp cfabortr GC:\publish\hermes-seg-18.04\proprietary\2\view_console_settings.cfm:218t lucee/runtime/tag/Abortv
w
w&    

z /opt/hermes/ssl/dhparam.pem| lucee.runtime.tag.FileTag~ cffile� GC:\publish\hermes-seg-18.04\proprietary\2\view_console_settings.cfm:224� lucee/runtime/tag/FileTag�
� � delete� 	setAction� 1
�� setFile� 1
��
�
�& GC:\publish\hermes-seg-18.04\proprietary\2\view_console_settings.cfm:228� disablehparam� s
update parameters2 set value2='disable', active='1', applied='2' where parameter='dhparam' and module='console'
� getCatch #()Llucee/runtime/exp/PageException;��
 /� lucee.runtime.tag.Execute� 	cfexecute� GC:\publish\hermes-seg-18.04\proprietary\2\view_console_settings.cfm:234� lucee/runtime/tag/Execute� '/opt/hermes/scripts/generate_dhparam.sh�
� � 
setTimeout (D)V��
��
�
�
�& 

    

� isAbort (Ljava/lang/Throwable;)Z��
)� toPageException 8(Ljava/lang/Throwable;)Llucee/runtime/exp/PageException;��
 �� setCatch &(Llucee/runtime/exp/PageException;ZZ)V��
 /� aGenerate DH Parameters File: There was an error executing /opt/hermes/scripts/generate_dhparam.sh� GC:\publish\hermes-seg-18.04\proprietary\2\view_console_settings.cfm:241� $(Llucee/runtime/exp/PageException;)V��
 /� _28�C	A� 




  � GC:\publish\hermes-seg-18.04\proprietary\2\view_console_settings.cfm:252� 






� 1� � 

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    � cThe Host Name field must be a valid FQDN domain when Console Mode is set to Host Name (Error Code: � )� 
  </div>

  � _0�C	A� 2� �

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    � :You must select a valid Console Certificate  (Error Code: � 27� �

<div class="alert alert-success alert-dismissible">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  <h4><i class="icon fa fa-check"></i> Success!</h4>
  � (Console Settings were saved successfully�  
    
</div>

� 28� �

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    � �Generate DH Parameters File was started. This is going to take a long time to complete. Check back on this page for the Diffie-Hellman (DH) key-exchange drop-down option to appear. <strong>Do NOT</strong> start another Generate DH Parameters File process�  
      
  </div>
  
  � 
  
  �  
  




<span>
<p> 


� �



  <div class="alert alert-warning">
    <p>The system in in progress of generating a Diffie-Hellman (DH) Parameters file. The Generate DH Parameters File button will re-appear once the process is finished.</p>
    </div>


� �
  <a href="#generate_modal"  class="btn btn-primary" role="button" data-toggle="modal" data-recipient="" data-recipientemail=""><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Generate DH Parameters File</a>
  ��

</p>
</span>


   
<div class="modal fade" id="generate_modal" tabindex="-1" role="dialog" aria-labelledby="generateDHParameterModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  
    <h4 class="modal-title">Generate Diffie-Hellman (DH) Parameters File</h4>
</div>
  
<div class="modal-body">
  <p>This process will take very long time to complete (~40 minutes on 1 CPU systems).</p>
  
  <p><strong>If this the first time you are generating a Diffie-Hellman (DH) file</strong>, when the process is complete there will be a new <strong>Diffie-Hellman (DH) key-exchange</strong> drop-down option on the Console Settings page. <strong>The option will only appear when the process is complete.</strong></p>
    
  <p><strong>If this is not the first time you are generating a Diffie-Hellman (DH) file</strong>, generating a new file will automatically <strong>Disable the Diffie-Hellman key-exchange for your system</strong>, replace the existing Diffie-Hellman (DH) file and remove the Diffie-Hellman (DH) key-exchange drop-down option from the Console Settings page.��<strong> You must manually re-enable the Diffie-Hellman (DH) key-exchange option when the process is complete.</strong></p>

  <p>Are you sure you want to Generate a Diffie-Hellman (DH) Parameters File?</p>

</div>
<div class="modal-footer">
  <form name="GenerateDH" method="post">

    <input type="hidden" name="action" value="generatedh">
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>






<form name="EditConsoleSettings" method="post">

<input type="hidden" name="action" value="edit">

� m
<input type="hidden" name="certificateno_1" class="certificateno form-control" id="certificateno_1" value="� ">
��

    <div class="box-body">

      <div class="form-group">
        <label><strong>Console Mode</strong></label>

        <div class="alert alert-warning">
         
          <p><i class="icon fas fa-exclamation-triangle"></i>If you change the Console Mode to <strong>IP Address</strong> or <strong>Host Name</strong> ensure you change your browser's address to reflect the new system IP Address or the Host Name you set. This setting also sets the Ciphermail Portal and the User Console addresses.</p>
          </div>
    
        <select class="form-control" name="console_mode" data-placeholder="console_mode" style="width: 100%;"  id="console_mode">
          � ip  �                           
            <option value="ip" selected>IP Address</option></option>
            <option value="fqdn">Host Name</option>
           fqdn ~
            <option value="fqdn" selected>Host Name</option>
            <option value="ip">IP Address</option>
           6
            </select>   
    
          </div>

 �


                          <div class="form-group" id="console_host" style="display:none;">
             

                              
                              
P
                                <div class="form-group" id="console_host">
                                  <label for="console_host"><strong>Host Name</strong></label>
                                  <div class="input-group">
                                  <input type="text" class="form-control" name="console_host" value=" �" id="console_host" placeholder="Enter a FQDN Host Name" maxLength="255">
                                 
                                </div>
                                </div>
                                 K 

                              </div>


                             @
                            

                               Q 

                              </div>

                  
                 �


                <div class="form-group">
                  <label>Console Certificate</label>
                  <div class="input-group">
                   �
                  <input type="text" name="certificate_1" class="certificate form-control" id="certificate_1" placeholder="Start typing to search..." value=" )" autocomplete="off">
                  /
                  
                  
                  </div>
                  
                  
                  </div>

                  <div class="form-group">
                    <label>Certificate Subject</label>
                    <div class="input-group">
                     m
                    <input type="text" name="subject_1" class="subject form-control" id="subject_1" value=" !" readonly>
                     d
                    
                    
                    </div>
                    
                    
                    </div>
                  

                    
                  <div class="form-group">
                    <label>Certificate Issuer</label>
                    <div class="input-group">
                    " j
                    <input type="text" name="issuer_1" class="issuer form-control" id="issuer_1" value="$�
                    
                    
                    </div>
                    
                    
                    </div>

                    
                    

                        <div class="form-group">
                          <label>Certificate Serial</label>
                          <div class="input-group">
                          & p
                          <input type="text" name="serial_1" class="serial form-control" id="serial_1" value="( '" readonly>
                          *^
                          
                          
                          </div>
                          
                          
                          </div>


                  <div class="form-group">
                    <label>Certificate Type</label>
                    <div class="input-group">
                    , d
                    <input type="text" name="type_1" class="type form-control" id="type_1" value=". _TYPE0 �	 �1 �
                    
                    
                    </div>
                    
                    
                    </div>


                    3W
                  
                      <div class="form-group">
                        <label><strong>Diffie-Hellman (DH) key-exchange</strong></label>
                    
                        <select class="form-control" name="dh_param" data-placeholder="dh_param" style="width: 100%;"  id="dh_param">
                          5 enable7 �                           
                            <option value="enable" selected>Enable (Recommended)</option></option>
                            <option value="disable">Disable</option>
                          9 disable; �
                            <option value="disable" selected>Disable</option></option>
                            <option value="enable">Enable (Recommended)</option>
                          = �
                            </select>   
                    
                          </div>          
                      
                    ?4

                    <div class="form-group">
                      <label><strong>HTTP Strict Transport Security (HSTS)</strong></label>
                  
                      <select class="form-control" name="hsts" data-placeholder="hsts" style="width: 100%;"  id="hsts">
                        A �                           
                          <option value="enable" selected>Enable (Recommended)</option></option>
                          <option value="disable">Disable</option>
                        C �
                          <option value="disable" selected>Disable</option></option>
                          <option value="enable">Enable (Recommended)</option>
                        E�
                          </select>   
                  
                        </div>       
                        

                        <div class="form-group">
                          <label><strong>Online Certificate Status Protocol (OCSP) Stapling</strong></label>
                      
                          <select class="form-control" name="ocsp" data-placeholder="ocsp" style="width: 100%;"  id="ocsp">
                            G �                           
                              <option value="enable" selected>Enable (Recommended)</option></option>
                              <option value="disable">Disable</option>
                            I �
                              <option value="disable" selected>Disable</option></option>
                              <option value="enable">Enable (Recommended)</option>
                            K�
                              </select>   
                      
                            </div>     

                            <div class="form-group">
                              <label><strong>Online Certificate Status Protocol (OCSP) Stapling Verify</strong></label>
                          
                              <select class="form-control" name="ocspverify" data-placeholder="ocspverify" style="width: 100%;"  id="ocspverify">
                                M �                           
                                  <option value="enable" selected>Enable (Recommended)</option></option>
                                  <option value="disable">Disable</option>
                                O �
                                  <option value="disable" selected>Disable</option></option>
                                  <option value="enable">Enable (Recommended)</option>
                                Q�
                                  </select>   
                          
                                </div>  





<input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">


  </form>

  <div>&nbsp;</div>


<!-- CONSOLE SETTINGS FORM ENDS HERE -->

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


S ./inc/main_footer.cfmU[

<!-- ./wrapper -->



</body>



<script>

  $('#console_mode').on('change',function(){
    if( $(this).val()==="fqdn"){
    $("#console_host").show()
    }
    else{
    $("#console_host").hide()
    }
  });
  
  </script>
   

 

<script type="text/javascript">
  $(document).ready(function(){

      $(document).on('keydown', '.certificate', function() {
          
          var id = this.id;
          var splitid = id.split('_');
          var index = splitid[1];

          $( '#'+id ).autocomplete({
              source: function( request, response ) {
                  $.ajax({
                      url: "./inc/getcertificates.cfm",
                      type: 'post',
                      dataType: "json",
                      data: {
                          search: request.term,request:1
                      },
                      success: function( data ) {
                          response( data );
                      }
                  });
              },
              select: function (event, ui) {
                  $(this).val(ui.item.label); // display the selected text
                  var id = ui.item.value; // selected id to input

                  // AJAX
                  $.ajax({
                      url: './inc/getcertificates.cfm',
                      type: 'post',
                      data: {id:id,request:2},
                      dataType: 'json',
                      success:function(response){
                          
                          var len = response.length;

                          if(len > 0){
                              var certificate_no = response[0]['id'];
                              var type = response[0]['type'];
                              var subject = response[0]['subject'];
                              var issuer = response[0]['issuer'];
                              var serial = response[0]['serial'];
                              var fingerprint = response[0]['fingerprint'];
                              var certstart = response[0]['certstart'];
                              var certend = response[0]['certend'];
                              var friendlyname = response[0]['friendly_name'];
                  
                              document.getElementById('certificateno_'+index).value = certificate_no;
                              document.getElementById('type_'+index).value = type;
                              document.getElementById('subject_'+index).value = subject;
                              document.getElementById('issuer_'+index).value = issuer;
                              document.getElementById('serial_'+index).value = serial;
                              document.getElementById('fingerprint_'+index).value = fingerprint;
                              document.getElementById('certstart_'+index).value = certstart;
                              document.getElementById('certend_'+index).value = certend;
                              document.getElementById('friendlyname_'+index).value = friendlyname;
             
                        
                              
                          }
                          
                      }
                  });

                  return false;
              }
          });
      });
      
      

  });

W </script>


</html>Y udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageExceptiona  lucee/runtime/type/UDFPropertiesc udfs #[Llucee/runtime/type/UDFProperties;ef	 g setPageSourcei 
 j CONSOLE_MODEl lucee/runtime/type/KeyImpln intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;pq
or VALUE2t CONSOLE_HOSTv CONSOLE_CERTIFICATEx CONSOLE_DHPARAMz CONSOLE_HSTS| CONSOLE_SSL_STAPLING~ CONSOLE_SSL_STAPLING_VERIFY� CONSOLECERTIFICATE� THEURL� CONSOLEMODE� CONSOLEHOST� GETCERTDETAILS� FRIENDLY_NAME� SUBJECT� ISSUER� SERIAL� DHPARAM� HSTS� SSLSTAPLING� SSLSTAPLINGVERIFY� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *�d�h*+�k�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  X  N  
+-� 3+5� 9+;� 3+=� 9+?� 3+A� 9+C� 3+� F+H� 3� 
M+� K,�+� K+M� 3+O+� T� ZN6+� T-� /\Y:� !� ^Y� `Yb� dO� hj� m� q� r�N6+� tvO- w w� |+~� 3+�+� T� Z:6+� T� 0\Y:� !� ^Y� `Yb� d�� hj� m� q� r�:6+� tv� w w� |+�� 3++� �� �� �� �� �� W+�� 3+� �� �� � �� �� � � ++�� 3+� �� �+� �� �� � � � W+�� 3� +�� 3� +�� 3+�+� T� Z:	6
+� T	� 0�Y:� !� ^Y� `Yb� d�� hj� m� q� r�:	6
+� tv�	 w w
� |+�� 3++� ¸ �� �� �� �� W+�� 3+� ² ȹ � �� �� � � ++�� 3+� �� �+� ² ȹ � � � W+�� 3� +�� 3� +Ͷ 3+�� 9+Ѷ 3+�+� T� Z:6+� T� G++� �*� �2� � *� �2� �Y:� !� ^Y� `Yb� dӶ hj� m� q� r�:6+� tv� w w� |+~� 3+�+� T� Z:6+� T� G++� �*� �2� � *� �2� �Y:� !� ^Y� `Yb� d߶ hj� m� q� r�:6+� tv� w w� |+~� 3+�+� T� Z:6+� T� G++� �*� �2� � *� �2� �Y:� !� ^Y� `Yb� d� hj� m� q� r�:6+� tv� w w� |+~� 3+�+� T� Z:6+� T� G++� �*� �2� � *� �2� �Y:� !� ^Y� `Yb� d� hj� m� q� r�:6+� tv� w w� |+~� 3+�+� T� Z:6+� T� G++� �*� �2� � *� �2� �Y:� !� ^Y� `Yb� d� hj� m� q� r�:6+� tv� w w� |+~� 3+�+� T� Z:6+� T� H++� �*� �2� � *� �2� �Y:� !� ^Y� `Yb� d� hj� m� q� r�:6+� tv� w w� |+~� 3+�+� T� Z:6+� T� H++� �*� �2� � *� �2� �Y: � !� ^Y� `Yb� d� hj� m� q� r� :6+� tv� w w� |+~� 3+� F+� t��� �� �:!!� �!�� �! �!�6""� m+!"�+� 3++� �*� �2� ��+� 3!���է $:#!#�� :$"� +�!W!�$$�"� +�!W!�$!�'� �-�� :%+� t!�1%�+� t!�1� :&+� K&�+� K+3� 3+� �� ȹ 5� �� � � �+7� 3+9� 9+�� 3+;� 9+�� 3+=� 9+�� 3+?� 9+Ѷ 3+� �� ��E�F W+H� 3+� F+?� 3+� tJLN� ��P:''+� �*� �	2� �R�X�['�^'�_W'�`� �-�� :(+� t'�1(�+� t'�1+?� 3� :)+� K)�+� K+b� 3��+� �� ȹ d� �� � ��+Ѷ 3+f�k� {+Ѷ 3+� �� �m� � W+�� 3+o� 9+�� 3+� tqsu� ��w:**�xW*�y� �-�� :++� t*�1+�+� t*�1+{� 3�6+�� 3+}�k� l+�� 3+� t��� ���:,,��,���,}��,��W,��� �-�� :-+� t,�1-�+� t,�1+�� 3� +�� 3+� F+� t���� �� �:..� �.�� �. �.�6//� O+./�+�� 3.���� $:0.0�� :1/� +�!W.�$1�/� +�!W.�$.�'� �-�� :2+� t.�12�+� t.�1� :3+� K3�+� K+�� 3+��:4+�� 3+� t���� ���:55���5��5��666� 2+56�5������ :76� +�!W7�6� +�!W5��� �-�� :8+� t5�18�+� t5�1+�� 3� �:99��� 9�9��::+:��+Ѷ 3+� �� ��� � W+�� 3+o� 9+�� 3+� tqs�� ��w:;;�xW;�y� �-�� :<+� t;�1<�+� t;�1+{� 3� :=+4��=�+4��+�� 3+� �� ��ĹF W+ƶ 3+� F+?� 3+� tJLȶ ��P:>>+� �*� �	2� �R�X�[>�^>�_W>�`� �-�� :?+� t>�1?�+� t>�1+?� 3� :@+� K@�+� K+7� 3+�� 3� +ʶ 3+� �� �� ̸ �� � � _+ζ 3+� F+ж 3++� �� �� � �� 3+Ҷ 3� :A+� KA�+� K+Զ 3+� �� ��׹F W+Ѷ 3� +Ѷ 3+� �� �� ٸ �� � � _+۶ 3+� F+ݶ 3++� �� �� � �� 3+Ҷ 3� :B+� KB�+� K+Զ 3+� �� ��׹F W+Ѷ 3� +�� 3+� �� �� ߸ �� � � E+� 3+� F+� 3� :C+� KC�+� K+� 3+� �� ��׹F W+Ѷ 3� +�� 3+� �� �� � �� � � F+� 3+� F+� 3� :D+� KD�+� K+�� 3+� �� ��׹F W+� 3� +� 3+f�k� +� 3� *+�� 3+� F+�� 3� :E+� KE�+� K+�� 3+�� 3+�� 3+� F+�� 3++� �*� �2� �� 3+�� 3� :F+� KF�+� K+�� 3+� �*� �
2� � �� � � +� 3� /+� �*� �
2� � �� � � +� 3� +	� 3+� �*� �
2� � �� � � M+� 3+� F+� 3++� �*� �2� �� 3+� 3� :G+� KG�+� K+� 3� J+� 3+� F+� 3++� �*� �2� �� 3+� 3� :H+� KH�+� K+� 3+� 3+� F+� 3+++� �*� �2� � *� �2� ݸ� 3+� 3� :I+� KI�+� K+� 3+� F+� 3+++� �*� �2� � *� �2� ݸ� 3+!� 3� :J+� KJ�+� K+#� 3+� F+%� 3+++� �*� �2� � *� �2� ݸ� 3+!� 3� :K+� KK�+� K+'� 3+� F+)� 3+++� �*� �2� � *� �2� ݸ� 3++� 3� :L+� KL�+� K+-� 3+� F+/� 3+++� �*� �2� � �2� ݸ� 3+!� 3� :M+� KM�+� K+4� 3+}�k� l+6� 3+� �*� �2� 8� �� � � +:� 3� /+� �*� �2� <� �� � � +>� 3� +@� 3� +B� 3+� �*� �2� 8� �� � � +D� 3� /+� �*� �2� <� �� � � +F� 3� +H� 3+� �*� �2� 8� �� � � +J� 3� /+� �*� �2� <� �� � � +L� 3� +N� 3+� �*� �2� 8� �� � � +P� 3� /+� �*� �2� <� �� � � +R� 3� +T� 3+V� 9+X� 3+Z� 3� ! 1 : :  � )�"%  �[[  �uu  XX  xx  �  a��  �		
 )�		  �	L	L  �	f	f  	�	�	�  	�	�	�  	

 )
s
�
�  	
�
�  
�44  
�TT  ���  !EE  ���    dnn  ���  [��  ���  �  7jj  ���  �    GG   �         * +  �  " �         !  J  K * M - T 4 U E Y H [ K p � r s" u% yE zd |j m �s �v �� �� � �4 �: �= �C �F �I �S �� �E �� �7 �� �* �� �� �
 �� �� �� �� �� �� �� �� �� �� �� �� � �r �� �� �� �� �� �/ �8 �; �H �� �� �� �� �	v �	y �	� �	� �
 �
6 �
L �
Z �
� �
� �
� �
� �
� �N �e hkqux������VYl!u$�&�)�+�-�/�2 47"9%;9=CAFGTKWP]R`ShT{U~V�Z�\�p��������������!�'�+�.�T�W�_�b�}����������������������������0�3�;�d�{�~����������()A*X,[3i5l9�:�<�=�?�@�D�F�J�KM'N-P1Q4ZZ[`]�^�`�a�i�j�l�m�o�p�����     ) [\ �        �    �     ) ]^ �         �    �     ) _` �        �    �    b    �   �     �*� �Ym�sSYu�sSYw�sSYy�sSY{�sSY}�sSY�sSY��sSY��sSY	��sSY
��sSY��sSY��sSY��sSY��sSY��sSY��sSY��sSY��sSY��sSY��sS� ױ     �    