����   2O V__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_antivirus_settings_cfm$cf  lucee/runtime/PageImpl  H../../publish/hermes-seg-18.04/proprietary/2/view_antivirus_settings.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ��t� getSourceLength      �� getCompileTime  �@,�� getHash ()I�W�� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this XL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_antivirus_settings_cfm$cf; �<!DOCTYPE html>

 


<html lang="en">


  <head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Antivirus Settings</title>

   , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 ./inc/html_head.cfm 4 	doInclude (Ljava/lang/String;Z)V 6 7
 / 8?

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
      
          "order": [[ 1, "asc" ]]
      } );
  } );
    </script>

    

<script>

  $(document).ready(function() {
    $("#deletewhitelists").click(function() {
      var deletewhitelists = [];
      $.each($("input[name='id']:checked"), function() {
        deletewhitelists.push($(this).val());
      });
      $('#delete_modal').modal('show').on('shown.bs.modal', function() {
      $("#deleteid").html('<input type="hidden" name="delete_id" value=' + deletewhitelists + '>');
      });
    });
  });
  
   :F</script>


  

    
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
#btn-back-to-top {
  position: fixed;
  bottom: 20px;
  right: 20px;
  display: none;
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
 / G O
            <h1 class="m-0">Antivirus Settings</h1>
            
           I 	outputEnd K 
 / L�
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Antivirus Settings</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

<!-- Back to top button -->
<button
        type="button"
        class="btn btn-danger btn-floating btn-lg"
        id="btn-back-to-top"
        >
  <i class="fas fa-arrow-up"></i>
</button>


   N m P &lucee/runtime/config/NullSupportHelper R NULL T '
 S U -lucee/runtime/interpreter/VariableInterpreter W getVariableEL S(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Ljava/lang/Object; Y Z
 X [ 0 ] %lucee/runtime/exp/ExpressionException _ java/lang/StringBuilder a The required parameter [ c  1
 b e append -(Ljava/lang/Object;)Ljava/lang/StringBuilder; g h
 b i ] was not provided. k -(Ljava/lang/String;)Ljava/lang/StringBuilder; g m
 b n toString ()Ljava/lang/String; p q
 b r
 ` e lucee/runtime/PageContextImpl u any w�       subparam O(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;DDLjava/lang/String;IZ)V { |
 v } sessionScope $()Llucee/runtime/type/scope/Session;  �
 / � lucee/runtime/op/Caster � toStruct /(Ljava/lang/Object;)Llucee/runtime/type/Struct; � �
 � � $lucee/runtime/type/util/KeyConstants � _m #Llucee/runtime/type/Collection$Key; � �	 � � !lucee/runtime/type/Collection$Key � .lucee/runtime/functions/struct/StructKeyExists � \(Llucee/runtime/PageContext;Llucee/runtime/type/Struct;Llucee/runtime/type/Collection$Key;)Z & �
 � � _M � �	 � �  lucee/runtime/type/scope/Session � get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; � � � �   � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � us &()Llucee/runtime/type/scope/Undefined; � �
 / � "lucee/runtime/type/scope/Undefined � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � � 

  

  

  
   � 


  
   � 

  


   � lucee.runtime.tag.Query � cfquery � IC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:189 � use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; � �
 v � lucee/runtime/tag/Query � hasBody (Z)V � �
 � � getavwhitelist � setName � 1
 � � hermes � setDatasource (Ljava/lang/Object;)V � �
 � � 
doStartTag � $
 � � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � X
    select id, parameter, module from parameters2 where module = 'clamav-bypass'
     � doAfterBody � $
 � � doCatch (Ljava/lang/Throwable;)V � �
 � � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 � � doEndTag � $
 � � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 v � 

   � errormessage � keys $[Llucee/runtime/type/Collection$Key; � �	  � 
     � 



  

    
    


 invalid 

 






    
   invalid_entry
 





    
   



 exists exists_entry success success_entry 

  
     step 
    
     action  
     @       _action$ �	 �% *lucee/runtime/functions/decision/IsDefined' B(Llucee/runtime/PageContext;DLlucee/runtime/type/Collection$Key;)Z &)
(* True, (ZLjava/lang/String;)I �.
 �/ 	formScope !()Llucee/runtime/type/scope/Form;12
 /3 _ACTION5 �	 �6 lucee/runtime/type/scope/Form89 �   


    ;  ./inc/get_antivirus_settings.cfm=   
   

      ? � � 9B �
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          D +Antivirus Settings were saved successfully F 1<br> 
        </div>

              
        H #lucee/commons/color/ConstantsDoubleJ _0 Ljava/lang/Double;LM	KN � � 
      
      Q 

      
      S 11U �

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          W JYou must select entries before clicking the <strong>Delete</strong> buttonY "
        </div>
      
        [ 


      ] 12_ "Entries were deleted successfully a 


      c 13e )The Whitelist Entry field cannot be emptyg 14i FThe Entry field in the entry you are attempting to edit already existsk 1m The following o &(Ljava/lang/Object;)Ljava/lang/String; pq
 �r ! entries were added successfully:t <br>
          v 
        </div>

        x 

        z @
       
      
     
      
      
      
      
      | �
      
          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            
            ~  entries were invalid:� <br>
            �  
          </div>

          � 
          � �
      
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
          
          �  entries already exist:� 


      





� VALID� %   
  <span>
    <p>  


 


� �
  <a href="#addwhitelist_modal"  class="btn btn-primary" role="button" data-toggle="modal" ><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add AV Signature Whitelist Entries</a>
  � �

&nbsp;&nbsp;



<button type="button" id="deletewhitelists" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete AV Signature Whitelist Entries</button>





</p>
</span>

��

<div class="card col-sm-8">
          
  <div class="form-group" id="avsettings">

    <div class="col-sm-8">


      <form name="avsettings" method="post">

        <input type="hidden" name="action" value="AV Settings">

      <label><strong>Scan E-mail Attachments</strong></label>
        
      <select class="form-control" name="ScanMail" style="width: 100%;" id="ScanMail">

� true� �
  
          <option value="true" selected>Enabled (Recommended)</option>
          <option value="false">Disabled</option>
   

      � false� �

        <option value="false" selected>Disabled</option>
        <option value="true">Enabled (Recommended)</option>

     

        
      � �
     
          </select>   

          <label><strong>Scan Archives</strong></label>
        
          <select class="form-control" name="ScanArchive" style="width: 100%;" id="ScanArchive">
    
    � �
      
              <option value="true" selected>Enabled (Recommended)</option>
              <option value="false">Disabled</option>
       
    
          � �
    
            <option value="false" selected>Disabled</option>
            <option value="true">Enabled (Recommended)</option>
    
         
    
            
          �
         
              </select>   

              <label><strong>Mark Encrypted Archives as Viruses</strong></label>
        
              <select class="form-control" name="ArchiveBlockEncrypted" style="width: 100%;" id="ArchiveBlockEncrypted">
        
        � �
          
                  <option value="true" selected>Enabled</option>
                  <option value="false">Disabled (Recommended)</option>
           
        
              � �
        
                <option value="false" selected>Disabled (Recommended)</option>
                <option value="true">Enabled</option>
        
             
        
                
              �+
             
                  </select>   

                  <label><strong>Scan Portable Executables Files</strong> (Windows Executable File Format)</label>
        
                  <select class="form-control" name="ScanPE" style="width: 100%;" id="ScanPE">
            
            � �
              
                      <option value="true" selected>Enabled (Recommended)</option>
                      <option value="false">Disabled</option>
               
            
                  � �
            
                    <option value="false" selected>Disabled</option>
                    <option value="true">Enabled (Recommended)</option>
            
                 
            
                    
                  �;
                 
                      </select>   
  
                      <label><strong>Scan OLE2 Files</strong> (MS Office and Windows .msi Files)</label>
        
                      <select class="form-control" name="ScanOLE2" style="width: 100%;" id="ScanOLE2">
                
                � �
                  
                          <option value="true" selected>Enabled (Recommended)</option>
                          <option value="false">Disabled</option>
                   
                
                      �
                
                        <option value="false" selected>Disabled</option>
                        <option value="true">Enabled (Recommended)</option>
                
                     
                
                        
                      ��
                     
                          </select>   

  
                          <label><strong>Block OLE2 Macros</strong> (MS Office Files with VBA Macros)</label>

                          <div class="alert alert-warning">
             
                            <p><i class="icon fas fa-exclamation-triangle"></i>This setting will bypass scanning and simply block all OLE2 files with VBA Macros in them whether malicious or not. In effect, it will treat any VBA macros as a virus. This setting has no effect if <strong>Scan OLE2 Macros</strong> is <strong>Disabled.</strong> It's recommended that you set this setting to <strong>Disabled.</strong></p>
                            </div>
                          
        
                          <select class="form-control" name="OLE2BlockMacros" style="width: 100%;" id="OLE2BlockMacros">
                    
                    �
                      
                              <option value="true" selected>Enabled</option>
                              <option value="false">Disabled (Recommended)</option>
                       
                    
                          �6
                    
                            <option value="false" selected>Disabled (Recommended)</option>
                            <option value="true">Enabled</option>
                    
                         
                    
                            
                          �C
                         
                              </select>   

                              <label><strong>Scan PDF Files</strong></label>
        
                              <select class="form-control" name="ScanPDF" style="width: 100%;" id="ScanPDF">
                        
                        �
                          
                                  <option value="true" selected>Enabled (Recommended)</option>
                                  <option value="false">Disabled</option>
                           
                        
                              �V
                        
                                <option value="false" selected>Disabled</option>
                                <option value="true">Enabled (Recommended)</option>
                        
                             
                        
                                
                              ��
                             
                                  </select>  
                                  

                                  <label><strong>Perform HTML/Javascript/ScriptEncoder Normalization and Decryption</strong></label>
        
                                  <select class="form-control" name="ScanHTML" style="width: 100%;" id="ScanHTML">
                            
                            �6
                              
                                      <option value="true" selected>Enabled (Recommended)</option>
                                      <option value="false">Disabled</option>
                               
                            
                                  �v
                            
                                    <option value="false" selected>Disabled</option>
                                    <option value="true">Enabled (Recommended)</option>
                            
                                 
                            
                                    
                                  ��
                                 
                                      </select>  

                                  <label><strong>Algorithmic Detection</strong> (Detects complex malware, graphic files exploits and others)</label>
        
                                  <select class="form-control" name="AlgorithmicDetection" style="width: 100%;" id="AlgorithmicDetection">
                            
                            ��
                                 
                                      </select>   


                                      <label><strong>Scan ELF Files</strong> (UN*X Executables)</label>
        
                                      <select class="form-control" name="ScanELF" style="width: 100%;" id="ScanELF">
                                
                                �N
                                  
                                          <option value="true" selected>Enabled (Recommended)</option>
                                          <option value="false">Disabled</option>
                                   
                                
                                      ��
                                
                                        <option value="false" selected>Disabled</option>
                                        <option value="true">Enabled (Recommended)</option>
                                
                                     
                                
                                        
                                      ��
                                     
                                          </select>   

                                          <label><strong>Signature Based Detection of Phishing</strong> </label>
        
                                          <select class="form-control" name="PhishingSignatures" style="width: 100%;" id="PhishingSignatures">
                                    
                                    �f
                                      
                                              <option value="true" selected>Enabled (Recommended)</option>
                                              <option value="false">Disabled</option>
                                       
                                    
                                          ��
                                    
                                            <option value="false" selected>Disabled</option>
                                            <option value="true">Enabled (Recommended)</option>
                                    
                                         
                                    
                                            
                                          ��
                                         
                                              </select>   


                                              <label><strong>Scan E-mail URLs for Phishing</strong> </label>
        
                                              <select class="form-control" name="PhishingScanURLs" style="width: 100%;" id="PhishingScanURLs">
                                        
                                        �~
                                          
                                                  <option value="true" selected>Enabled (Recommended)</option>
                                                  <option value="false">Disabled</option>
                                           
                                        
                                              ��
                                        
                                                <option value="false" selected>Disabled</option>
                                                <option value="true">Enabled (Recommended)</option>
                                        
                                             
                                        
                                                
                                              �5
                                             
                                                  </select>   

                                                  <label><strong>Block SSL Mismatches in E-mail URLs</strong> </label>

                                                  <div class="alert alert-warning">
             
                                                    <p><i class="icon fas fa-exclamation-triangle"></i> Enabling can lead to false positivies.</p>
                                                    </div>
        
                                                  <select class="form-control" name="PhishingAlwaysBlockSSLMismatch" style="width: 100%;" id="PhishingAlwaysBlockSSLMismatch">
                                            
                                            ��
                                              
                                                      <option value="true" selected>Enabled</option>
                                                      <option value="false">Disabled (Recommended)</option>
                                               
                                            
                                                  ��
                                            
                                                    <option value="false" selected>Disabled (Recommended)</option>
                                                    <option value="true">Enabled</option>
                                            
                                                 
                                            
                                                    
                                                  �J
                                                 
                                                      </select>  

                                                      <label><strong>Block Cloaked E-mail URLs</strong> </label>

                                                      <div class="alert alert-warning">
                 
                                                        <p><i class="icon fas fa-exclamation-triangle"></i> Enabling can lead to false positivies.</p>
                                                        </div>
            
                                                      <select class="form-control" name="PhishingAlwaysBlockCloak" style="width: 100%;" id="PhishingAlwaysBlockCloak">
                                                
                                                ��
                                                  
                                                          <option value="true" selected>Enabled</option>
                                                          <option value="false">Disabled (Recommended)</option>
                                                   
                                                
                                                      �
                                                
                                                        <option value="false" selected>Disabled (Recommended)</option>
                                                        <option value="true">Enabled</option>
                                                
                                                     
                                                
                                                        
                                                      �=
                                                     
                                                          </select> 


                                                          <label><strong>Detect Possibly Unwanted Applications (PUA)</strong> </label>

                                    
                
                                                          <select class="form-control" name="DetectPUA" style="width: 100%;" id="DetectPUA">
                                                    
                                                    ��
                                                      
                                                              <option value="true" selected>Enabled (Recommended)</option>
                                                              <option value="false">Disabled</option>
                                                       
                                                    
                                                          �6
                                                    
                                                            <option value="false" selected>Disabled</option>
                                                            <option value="true">Enabled (Recommended)</option>
                                                    
                                                         
                                                    
                                                            
                                                          ��
                                                         
                                                              </select> 
    


                                                              <label><strong>Heuristic Scan Precedence</strong> </label>

                                                              <div class="alert alert-warning">
                 
                                                                <p><i class="icon fas fa-exclamation-triangle"></i> Allow heuristic match to take precedence. When enabled, if a heuristic scan (such as phishingScan) detects a possible virus/phishing it will  stop  scanning  immediately.
                                                                  Recommended to be Enabled because it saves  CPU  scan-time.  When  disabled, virus/phishing detected by heuristic scans will be reported only at the end of a scan. If an archive contains both a
                                                                  heuristically detected virus/phishing, and a real malware, the real malware will be reported. Keep this disabled if you intend to handle "*.Heuristics.*" viruses  differâ€�
                                                                  ently from "real" malware. If a non-heuristically-detected virus (signature-based) is found first, the scan is interrupted immediately, regardless of this config option.��</p>
                                                                </div>
                
                                                              <select class="form-control" name="HeuristicScanPrecedence" style="width: 100%;" id="HeuristicScanPrecedence">
                                                        
                                                        ��
                                                          
                                                                  <option value="true" selected>Enabled (Recommended)</option>
                                                                  <option value="false">Disabled</option>
                                                           
                                                        
                                                              �V
                                                        
                                                                <option value="false" selected>Disabled</option>
                                                                <option value="true">Enabled (Recommended)</option>
                                                        
                                                             
                                                        
                                                                
                                                              ��
                                                             
                                                                  </select> 

</div>

      
      </div>
       

  
          

  
  
  <div class="col-sm-6">
  
  <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  
  </div>
    
  </form>  
  
<br>

    
</div>


��   


   
<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteCertificateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  
    <h4 class="modal-title">Delete Entries </h4>
</div>
  
<div class="modal-body">
  <p>Are you sure you send to delete the Entries you have selected? This action is irreversible! </p>

</div>
<div class="modal-footer">
  <form name="DeleteEntry" method="post">

    <input type="hidden" name="action" value="Delete Entry">
    <div id="deleteid"></div>
    <input type="submit" value="Yes" class="btn btn-danger" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

   
    
</form>
  <button type="button" class="btn btn-primary" data-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>



�   


<div class="modal fade" id="addwhitelist_modal" tabindex="-1" role="dialog" aria-labelledby="AddWhitelistModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  
    <h4 class="modal-title">Add AV Signature Whitelist Entries </h4>
</div>
  
<div class="modal-body">

  <form name="AddWhitelist" autocomplete="off" method="post">

    <input type="hidden" name="action" value="Add AV Whitelist">

    

      <div class="form-group">
        <label>AV Signature(s)</label>
        <div class="textareacontainer">
    <textarea name="whitelist" placeholder="Enter AV Signature Whitelist Entries each in its own line" wrap="physical" rows="10"></textarea>
    </div>
    
      </div>

            


    <div>&nbsp;</div>

    <input type="submit" value="Submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  </form>

</div>


<div class="modal-footer">
 
� �<button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>

</div>
    </div>
  </div>
</div>


  
� 

         

  AV Settings 

     0Antivirus Settings: form.ScanMail does not exist ./inc/error.cfm lucee.runtime.tag.Abort
 cfabort JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1013 lucee/runtime/tag/Abort
 �
 � 



           

         _1M	K 
          
           "
          
      
             6Antivirus Settings: form.ScanMail is not true or false 
            ! JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1027# 

  
% 3Antivirus Settings: form.ScanArchive does not exist' JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1044) 
      

+       

  - _2/M	K0 
    

      2 9Antivirus Settings: form.ScanArchive is not true or false4 
      6 JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:10608 



  
: 2< =Antivirus Settings: form.ArchiveBlockEncrypted does not exist> JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1082@ 



    B _3DM	KE CAntivirus Settings: form.ArchiveBlockEncrypted is not true or falseG JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1098I 3K .Antivirus Settings: form.ScanPE does not existM JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1119O        

  Q _4SM	KT 

    
    V   

      X 4Antivirus Settings: form.ScanPE is not true or falseZ JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1134\ 





^ 4` 0Antivirus Settings: form.ScanOLE2 does not existb JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1154d         

  f _5hM	Ki 6Antivirus Settings: form.ScanOLE2 is not true or falsek JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1169m 5o 7Antivirus Settings: form.OLE2BlockMacros does not existq JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1189s Falseu _6wM	Kx =Antivirus Settings: form.OLE2BlockMacros is not True or Falsez JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1204| 6~ /Antivirus Settings: form.ScanPDF does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1224� _7�M	K� 5Antivirus Settings: form.ScanPDF is not True or False� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1239� 7� 0Antivirus Settings: form.ScanHTML does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1259� _8�M	K� 6Antivirus Settings: form.ScanHTML is not True or False� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1274� 8� <Antivirus Settings: form.AlgorithmicDetection does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1295� _9�M	K� BAntivirus Settings: form.AlgorithmicDetection is not True or False� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1310� /Antivirus Settings: form.ScanELF does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1331� _10�M	K� 5Antivirus Settings: form.ScanELF is not True or False� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1346� 10� :Antivirus Settings: form.PhishingSignatures does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1366� _11�M	K� @Antivirus Settings: form.PhishingSignatures is not True or False� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1381� 8Antivirus Settings: form.PhishingScanURLs does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1402� _12�M	K� >Antivirus Settings: form.PhishingScanURLs is not True or False� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1417� FAntivirus Settings: form.PhishingAlwaysBlockSSLMismatch does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1437� _13�M	K� LAntivirus Settings: form.PhishingAlwaysBlockSSLMismatch is not True or False� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1452� @Antivirus Settings: form.PhishingAlwaysBlockCloak does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1473� _14�M	K� FAntivirus Settings: form.PhishingAlwaysBlockCloak is not True or False� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1488� 1Antivirus Settings: form.DetectPUA does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1508� _15�M	K� 7Antivirus Settings: form.DetectPUA is not True or False� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1523� 15� ?Antivirus Settings: form.HeuristicScanPrecedence does not exist� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1544� _16�M	K� EAntivirus Settings: form.HeuristicScanPrecedence is not True or False� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1559� 16�  ./inc/antivirus_set_settings.cfm� *./inc/generate_antivirus_configuration.cfm� lucee.runtime.tag.Location� 
cflocation� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1582  lucee/runtime/tag/Location view_antivirus_settings.cfm setUrl 1
 setAddtoken	 �


 �
 � Delete Entry 


   JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1596 JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1605 
        

     
      

 ,  lucee/runtime/type/util/ListUtil listToArrayRemoveEmpty @(Ljava/lang/String;Ljava/lang/String;)Llucee/runtime/type/Array;
  lucee/runtime/type/Array" size$ $#% i' getVariableReference Y(Llucee/runtime/PageContext;Ljava/lang/String;)Llucee/runtime/type/ref/VariableReference;)*
 X+ getE (I)Ljava/lang/Object;-.#/ (lucee/runtime/type/ref/VariableReference1 A(Llucee/runtime/PageContext;Ljava/lang/Object;)Ljava/lang/Object; �3
24 _I6 �	 �7 <br>9 JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1614; getentry= *
  select id from parameters2 where id = ? lucee.runtime.tag.QueryParamA cfqueryparamC JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1615E lucee/runtime/tag/QueryParamG setValueI �
HJ CF_SQL_INTEGERL setCfsqltypeN 1
HO
H �
H � getCollectionS � �T #lucee/runtime/util/VariableUtilImplV recordcountX3
WY (Ljava/lang/Object;D)I �[
 �\  ./inc/antivirus_delete_entry.cfm^ 
  

    
  ` 
  
  b JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1637d 
  



f Add AV Whitelisth 



      j 
      
      
        l GAntivirus Settings Add Whitelist Entries: form.whitelist does not existn JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1657p 
         
      
      r 

        t "./inc/antivirus_add_whitelists.cfmv 

          
    x JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1671z 
      
    
    | 
      
      
      ~ 	
  
 
� JC:\publish\hermes-seg-18.04\proprietary\2\view_antivirus_settings.cfm:1682� 

    
     
�  


�    

<form>

    �X

    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            <th>AV Signature Whitelist</th> 
          

          </tr>
        </thead>
        <tbody>

        

� getQuery .(Ljava/lang/String;)Llucee/runtime/type/Query;��
 /� getId� $
 /� lucee/runtime/type/Query� getCurrentrow (I)I���� getRecordcount� $�� !lucee/runtime/util/NumberIterator� load '(II)Llucee/runtime/util/NumberIterator;��
�� addQuery (Llucee/runtime/type/Query;)V�� �� isValid (I)Z��
�� current� $
�� go (II)Z���� 4


  <td><input type="checkbox" name="id" value="� _ID� �	 �� "></td>


<td>� </td>  

</tr>

� removeQuery�  �� release &(Llucee/runtime/util/NumberIterator;)V��
��&




    

        </tbody>
        
       
        <tfoot>
          <tr>
      
            <th></th>
            <th>AV Signature Whitelist</th>  
              


           
          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    � �
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        � 5No AV Signature Whitelist entries were found</strong>� "
      </div>
    
      
    �|

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


� ./inc/main_footer.cfm�~

<!-- ./wrapper -->



</body>



  
     
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
    




<script>

//Get the button
let mybutton = document.getElementById("btn-back-to-top");

// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function () {
  scrollFunction();
};

function scrollFunction() {
  if (
    document.body.scrollTop > 200 ||
    document.documentElement.scrollTop > 200
  ) {
    mybutton.style.display = "block";
  } else {
    mybutton.style.display = "none";
  }
}
// When the user clicks on the button, scroll to the top of the document
mybutton.addEventListener("click", backToTop);

function backToTop() {
  document.body.scrollTop = 0;
  document.documentElement.scrollTop = 0;
}

� </script>



</html>� udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� ERRORMESSAGE� INVALID� INVALID_ENTRY� EXISTS� EXISTS_ENTRY� SUCCESS� SUCCESS_ENTRY� LICENSE� SCANMAIL� SCANARCHIVE� ARCHIVEBLOCKENCRYPTED� SCANPE� SCANOLE2  OLE2BLOCKMACROS SCANPDF SCANHTML ALGORITHMICDETECTION SCANELF
 PHISHINGSIGNATURES PHISHINGSCANURLS PHISHINGALWAYSBLOCKSSLMISMATCH PHISHINGALWAYSBLOCKCLOAK 	DETECTPUA HEURISTICSCANPRECEDENCE ScanMail STEP ScanArchive ArchiveBlockEncrypted ScanPE  ScanOLE2" OLE2BlockMacros$ ScanPDF& ScanHTML( AlgorithmicDetection* ScanELF, PhishingSignatures. PhishingScanURLs0 PhishingAlwaysBlockSSLMismatch2 PhishingAlwaysBlockCloak4 	DetectPUA6 HeuristicScanPrecedence8 	delete_id: 	DELETE_ID< GETENTRY> 	whitelist@ 	WHITELISTB GETAVWHITELISTD 	PARAMETERF subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   HI       J   *     *� 
*� *� � *�ڵ�*+��        J         �        J        � �        J         �        J         �         J         !�      # $ J        %�      & ' J  G�  �  ;�+-� 3+5� 9+;� 3+=� 3+?� 9+A� 3+C� 9+E� 3+� H+J� 3� 
M+� M,�+� M+O� 3+Q+� V� \N6+� V-� /^Y:� !� `Y� bYd� fQ� jl� o� s� t�N6+� vxQ- y y� ~+A� 3++� �� �� �� �� �� W+A� 3+� �� �� � �� �� � � ++A� 3+� �� �+� �� �� � � � W+�� 3� +�� 3� +�� 3+� H+� v���� �� �:� �ȶ �Ͷ �� �6� N+� �+ڶ 3� ����� $:� � :	� +� �W� �	�� +� �W� �� �� � � :
+� v� �
�+� v� �� :+� M�+� M+�� 3+�+� V� \:6+� V� 0^Y:� !� `Y� bYd� f�� jl� o� s� t�:6+� vx� y y� ~+A� 3++� �� �*� �2� �� �� a+�� 3+� �*� �2� � �� �� � � 2+�� 3+� �*� �2+� �*� �2� � � � W+� 3� +�� 3� +� 3++� V� \:6+� V� 1^Y:� "� `Y� bYd� f� jl� o� s� t�:6+� vx y y� ~+� 3++� �� �*� �2� �� �� a+A� 3+� �*� �2� � �� �� � � 2+A� 3+� �*� �2+� �*� �2� � � � W+	� 3� +�� 3� +� 3++� V� \:6+� V� 1�Y:� "� `Y� bYd� f� jl� o� s� t�:6+� vx y y� ~+� 3++� �� �*� �2� �� �� a+A� 3+� �*� �2� � �� �� � � 2+A� 3+� �*� �2+� �*� �2� � � � W+� 3� +�� 3� +� 3++� V� \:6+� V� 1^Y:� "� `Y� bYd� f� jl� o� s� t�:6+� vx y y� ~+� 3++� �� �*� �2� �� �� d+A� 3+� �*� �2� � �� �� � � 4+A� 3+� �*� �2+� �*� �2� � � � W+	� 3� +�� 3� +� 3++� V� \:6+� V� 1�Y:� "� `Y� bYd� f� jl� o� s� t�:6+� vx y y� ~+� 3++� �� �*� �2� �� �� d+A� 3+� �*� �	2� � �� �� � � 4+A� 3+� �*� �	2+� �*� �	2� � � � W+� 3� +�� 3� +� 3++� V� \:6+� V� 1^Y:� "� `Y� bYd� f� jl� o� s� t�:6+� vx y y� ~+� 3++� �� �*� �
2� �� �� d+A� 3+� �*� �2� � �� �� � � 4+A� 3+� �*� �2+� �*� �2� � � � W+	� 3� +�� 3� +� 3++� V� \:6+� V� 1�Y: � "� `Y� bYd� f� jl� o� s� t� :6+� vx y y� ~+� 3++� �� �*� �2� �� �� d+A� 3+� �*� �2� � �� �� � � 4+A� 3+� �*� �2+� �*� �2� � � � W+	� 3� +�� 3� +� 3++� V� \:!6"+� V!� 1^Y:#� "� `Y� bYd� f� jl� o� s� t�#:!6"+� vx! y y"� ~+� 3++� V� \:$6%+� V$� 1�Y:&� "� `Y� bYd� f� jl� o� s� t�&:$6%+� vx$ y y%� ~+!� 3+"�&� ��+-�0� � � Q+�� 3+�4�7�: �� �� � � ++�� 3+� ��7+�4�7�: � � W+�� 3� � +<� 3+>� 9+@� 3+� �� ��A C� �� � � F+E� 3+� H+G� 3� :'+� M'�+� M+I� 3+� �� ��O�P W+R� 3� +T� 3+� �� ��A V� �� � � F+X� 3+� H+Z� 3� :(+� M(�+� M+\� 3+� �� ��O�P W+R� 3� +^� 3+� �� ��A `� �� � � F+E� 3+� H+b� 3� :)+� M)�+� M+I� 3+� �� ��O�P W+R� 3� +d� 3+� �� ��A f� �� � � F+X� 3+� H+h� 3� :*+� M*�+� M+\� 3+� �� ��O�P W+R� 3� +^� 3+� �� ��A j� �� � � F+X� 3+� H+l� 3� :++� M+�+� M+\� 3+� �� ��O�P W+R� 3� +d� 3+� �*� �2�A n� �� � � �+E� 3+� H+p� 3++� �*� �2�A �s� 3+u� 3� :,+� M,�+� M+w� 3+� H++� �*� �2�A �s� 3� :-+� M-�+� M+y� 3+� �*� �2�O�P W+{� 3+� �*� �2��P W+^� 3� +}� 3+� �*� �2�A ^� �� � � �+� 3+� H+p� 3++� �*� �2�A �s� 3+�� 3� :.+� M.�+� M+�� 3+� H++� �*� �2�A �s� 3� :/+� M/�+� M+�� 3+� �*� �2�O�P W+�� 3+� �*� �2��P W+R� 3� +R� 3+� �*� �2�A ^� �� � � �+�� 3+� H+p� 3++� �*� �2�A �s� 3+�� 3� :0+� M0�+� M+w� 3+� H++� �*� �	2�A �s� 3� :1+� M1�+� M+y� 3+� �*� �2�O�P W+{� 3+� �*� �	2��P W+R� 3� +�� 3+� �*� �2� � �� �� � � /+�� 3+� H+�� 3� :2+� M2�+� M+�� 3� +�� 3+� �*� �2�A �� �� � � +�� 3� /+� �*� �2�A �� �� � � +�� 3� +�� 3+� �*� �2�A �� �� � � +�� 3� /+� �*� �2�A �� �� � � +�� 3� +�� 3+� �*� �2�A �� �� � � +�� 3� /+� �*� �2�A �� �� � � +�� 3� +�� 3+� �*� �2�A �� �� � � +�� 3� /+� �*� �2�A �� �� � � +�� 3� +�� 3+� �*� �2�A �� �� � � +�� 3� /+� �*� �2�A �� �� � � +�� 3� +�� 3+� �*� �2�A �� �� � � +�� 3� /+� �*� �2�A �� �� � � +�� 3� +�� 3+� �*� �2�A �� �� � � +�� 3� /+� �*� �2�A �� �� � � +ö 3� +Ŷ 3+� �*� �2�A �� �� � � +Ƕ 3� /+� �*� �2�A �� �� � � +ɶ 3� +˶ 3+� �*� �2�A �� �� � � +Ƕ 3� /+� �*� �2�A �� �� � � +ɶ 3� +Ͷ 3+� �*� �2�A �� �� � � +϶ 3� /+� �*� �2�A �� �� � � +Ѷ 3� +Ӷ 3+� �*� �2�A �� �� � � +ն 3� /+� �*� �2�A �� �� � � +׶ 3� +ٶ 3+� �*� �2�A �� �� � � +۶ 3� /+� �*� �2�A �� �� � � +ݶ 3� +߶ 3+� �*� �2�A �� �� � � +� 3� /+� �*� �2�A �� �� � � +� 3� +� 3+� �*� �2�A �� �� � � +� 3� /+� �*� �2�A �� �� � � +� 3� +� 3+� �*� �2�A �� �� � � +�� 3� /+� �*� �2�A �� �� � � +� 3� +� 3+� 3+� �*� �2�A �� �� � � +�� 3� /+� �*� �2�A �� �� � � +�� 3� +�� 3+� �*� �2� � �� �� � � +�� 3� +� 3+� �*� �2� � �� �� � � +�� 3+�� 3� +� 3+� ��7�A � �� � ��+�� 3++�4� �*� �2� �� �� � � |+� 3+� �� �� � W+�� 3+	� 9+�� 3+� v� ��:33�W3�� � � :4+� v3� �4�+� v3� �+� 3�++�4� �*� �2� �� �� �+^� 3+�4*� �2�: �� �� � � )+�4*� �2�: �� �� � � � � (+� 3+� �*� � 2�� � W+� 3� {+� 3+� �� � � � W+"� 3+	� 9+"� 3+� v$� ��:55�W5�� � � :6+� v5� �6�+� v5� �+&� 3+� 3� +� 3+� �*� � 2�A n� �� � ��+�� 3++�4� �*� �!2� �� �� � � |+� 3+� �� �(� � W+�� 3+	� 9+�� 3+� v*� ��:77�W7�� � � :8+� v7� �8�+� v7� �+� 3�++�4� �*� �!2� �� �� �+,� 3+�4*� �2�: �� �� � � )+�4*� �2�: �� �� � � � � (+.� 3+� �*� � 2�1� � W+� 3� {+3� 3+� �� �5� � W+7� 3+	� 9+7� 3+� v9� ��:99�W9�� � � ::+� v9� �:�+� v9� �+� 3+� 3� +;� 3� +� 3+� �*� � 2�A =� �� � ��+�� 3++�4� �*� �"2� �� �� � � |+� 3+� �� �?� � W+�� 3+	� 9+�� 3+� vA� ��:;;�W;�� � � :<+� v;� �<�+� v;� �+C� 3�++�4� �*� �"2� �� �� �+� 3+�4*� �2�: �� �� � � )+�4*� �2�: �� �� � � � � (+.� 3+� �*� � 2�F� � W+� 3� {+3� 3+� �� �H� � W+7� 3+	� 9+7� 3+� vJ� ��:==�W=�� � � :>+� v=� �>�+� v=� �+� 3+� 3� +;� 3� +� 3+� �*� � 2�A L� �� � ��+�� 3++�4� �*� �#2� �� �� � � |+� 3+� �� �N� � W+�� 3+	� 9+�� 3+� vP� ��:??�W?�� � � :@+� v?� �@�+� v?� �+� 3�++�4� �*� �#2� �� �� �+d� 3+�4*� �2�: �� �� � � )+�4*� �2�: �� �� � � � � (+R� 3+� �*� � 2�U� � W+W� 3� {+Y� 3+� �� �[� � W+7� 3+	� 9+7� 3+� v]� ��:AA�WA�� � � :B+� vA� �B�+� vA� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A a� �� � ��+�� 3++�4� �*� �$2� �� �� � � |+� 3+� �� �c� � W+�� 3+	� 9+�� 3+� ve� ��:CC�WC�� � � :D+� vC� �D�+� vC� �+� 3�++�4� �*� �$2� �� �� �+d� 3+�4*� �2�: �� �� � � )+�4*� �2�: �� �� � � � � (+g� 3+� �*� � 2�j� � W+W� 3� {+Y� 3+� �� �l� � W+7� 3+	� 9+7� 3+� vn� ��:EE�WE�� � � :F+� vE� �F�+� vE� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A p� �� � ��+�� 3++�4� �*� �%2� �� �� � � |+� 3+� �� �r� � W+�� 3+	� 9+�� 3+� vt� ��:GG�WG�� � � :H+� vG� �H�+� vG� �+� 3�++�4� �*� �%2� �� �� �+� 3+�4*� �2�: v� �� � � )+�4*� �2�: -� �� � � � � (+.� 3+� �*� � 2�y� � W+W� 3� {+Y� 3+� �� �{� � W+7� 3+	� 9+7� 3+� v}� ��:II�WI�� � � :J+� vI� �J�+� vI� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A � �� � ��+�� 3++�4� �*� �&2� �� �� � � |+� 3+� �� ��� � W+�� 3+	� 9+�� 3+� v�� ��:KK�WK�� � � :L+� vK� �L�+� vK� �+� 3�++�4� �*� �&2� �� �� �+� 3+�4*� �2�: v� �� � � )+�4*� �2�: -� �� � � � � (+.� 3+� �*� � 2��� � W+W� 3� {+Y� 3+� �� ��� � W+7� 3+	� 9+7� 3+� v�� ��:MM�WM�� � � :N+� vM� �N�+� vM� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A �� �� � ��+�� 3++�4� �*� �'2� �� �� � � |+� 3+� �� ��� � W+�� 3+	� 9+�� 3+� v�� ��:OO�WO�� � � :P+� vO� �P�+� vO� �+� 3�++�4� �*� �'2� �� �� �+� 3+�4*� �2�: v� �� � � )+�4*� �2�: -� �� � � � � (+.� 3+� �*� � 2��� � W+W� 3� {+Y� 3+� �� ��� � W+7� 3+	� 9+7� 3+� v�� ��:QQ�WQ�� � � :R+� vQ� �R�+� vQ� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A �� �� � ��+�� 3++�4� �*� �(2� �� �� � � |+� 3+� �� ��� � W+�� 3+	� 9+�� 3+� v�� ��:SS�WS�� � � :T+� vS� �T�+� vS� �+� 3�++�4� �*� �(2� �� �� �+� 3+�4*� �2�: v� �� � � )+�4*� �2�: -� �� � � � � (+.� 3+� �*� � 2��� � W+W� 3� {+Y� 3+� �� ��� � W+7� 3+	� 9+7� 3+� v�� ��:UU�WU�� � � :V+� vU� �V�+� vU� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A C� �� � ��+�� 3++�4� �*� �)2� �� �� � � |+� 3+� �� ��� � W+�� 3+	� 9+�� 3+� v�� ��:WW�WW�� � � :X+� vW� �X�+� vW� �+� 3�++�4� �*� �)2� �� �� �+� 3+�4*� �2�: v� �� � � )+�4*� �2�: -� �� � � � � (+.� 3+� �*� � 2��� � W+W� 3� {+Y� 3+� �� ��� � W+7� 3+	� 9+7� 3+� v�� ��:YY�WY�� � � :Z+� vY� �Z�+� vY� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A �� �� � ��+�� 3++�4� �*� �*2� �� �� � � |+� 3+� �� ��� � W+�� 3+	� 9+�� 3+� v�� ��:[[�W[�� � � :\+� v[� �\�+� v[� �+� 3�++�4� �*� �*2� �� �� �+� 3+�4*� �2�: v� �� � � )+�4*� �2�: -� �� � � � � (+.� 3+� �*� � 2��� � W+W� 3� {+Y� 3+� �� ��� � W+7� 3+	� 9+7� 3+� v�� ��:]]�W]�� � � :^+� v]� �^�+� v]� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A V� �� � ��+�� 3++�4� �*� �+2� �� �� � � |+� 3+� �� ��� � W+�� 3+	� 9+�� 3+� v�� ��:__�W_�� � � :`+� v_� �`�+� v_� �+� 3�++�4� �*� �+2� �� �� �+� 3+�4*� �2�: v� �� � � )+�4*� �2�: -� �� � � � � (+.� 3+� �*� � 2�ù � W+W� 3� {+Y� 3+� �� �Ź � W+7� 3+	� 9+7� 3+� vǶ ��:aa�Wa�� � � :b+� va� �b�+� va� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A `� �� � ��+�� 3++�4� �*� �,2� �� �� � � |+� 3+� �� �ɹ � W+�� 3+	� 9+�� 3+� v˶ ��:cc�Wc�� � � :d+� vc� �d�+� vc� �+� 3�++�4� �*� �,2� �� �� �+� 3+�4*� �2�: v� �� � � )+�4*� �2�: -� �� � � � � (+.� 3+� �*� � 2�ι � W+W� 3� {+Y� 3+� �� �й � W+7� 3+	� 9+7� 3+� vҶ ��:ee�We�� � � :f+� ve� �f�+� ve� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A f� �� � ��+�� 3++�4� �*� �-2� �� �� � � |+� 3+� �� �Թ � W+�� 3+	� 9+�� 3+� vֶ ��:gg�Wg�� � � :h+� vg� �h�+� vg� �+� 3�++�4� �*� �-2� �� �� �+� 3+�4*� �2�: v� �� � � )+�4*� �2�: -� �� � � � � (+.� 3+� �*� � 2�ٹ � W+W� 3� {+Y� 3+� �� �۹ � W+7� 3+	� 9+7� 3+� vݶ ��:ii�Wi�� � � :j+� vi� �j�+� vi� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A j� �� � ��+�� 3++�4� �*� �.2� �� �� � � |+� 3+� �� �߹ � W+�� 3+	� 9+�� 3+� v� ��:kk�Wk�� � � :l+� vk� �l�+� vk� �+� 3�++�4� �*� �.2� �� �� �+� 3+�4*� �2�: v� �� � � )+�4*� �2�: -� �� � � � � (+.� 3+� �*� � 2�� � W+W� 3� {+Y� 3+� �� �� � W+7� 3+	� 9+7� 3+� v� ��:mm�Wm�� � � :n+� vm� �n�+� vm� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A � �� � ��+�� 3++�4� �*� �/2� �� �� � � |+� 3+� �� �� � W+�� 3+	� 9+�� 3+� v� ��:oo�Wo�� � � :p+� vo� �p�+� vo� �+� 3�++�4� �*� �/2� �� �� �+� 3+�4*� �2�: v� �� � � )+�4*� �2�: -� �� � � � � (+.� 3+� �*� � 2�� � W+W� 3� {+Y� 3+� �� �� � W+7� 3+	� 9+7� 3+� v�� ��:qq�Wq�� � � :r+� vq� �r�+� vq� �+_� 3+� 3� +&� 3� +� 3+� �*� � 2�A �� �� � � �+� 3+�� 9+� 3+�� 9+� 3+� �� ����P W+� 3+� v��� ��:ss�s�s�Ws�� � � :t+� vs� �t�+� vs� �+� 3� +� 3��+� ��7�A � �� � �7+� 3++�4� �*� �02� �� �� � � |+� 3+� �� ����P W+�� 3+� v��� ��:uu�u�u�Wu�� � � :v+� vu� �v�+� vu� �+� 3��++�4� �*� �02� �� ��u+� 3+�4*� �12�: �� �� � � }+^� 3+� �� ����P W+� 3+� v��� ��:ww�w�w�Ww�� � � :x+� vw� �x�+� vw� �+� 3��+�4*� �12�: �� �� � ��+� 3+�4*� �12�: �s�!:yy�& 6z+(�,:{6}��{+y}�0 �5W+�� 3+� H++� ��8�A �s� 3+:� 3� :~+� M~�+� M+�� 3+� H+� v��<� �� �:� �>� �Ͷ �� �6��� �+�� �+@� 3+� vBDF� ��H:��+� ��8�A �K�M�P��QW��R� � � :�+� v�� ���+� v�� �+A� 3� ����� $:��� � :��� +� �W� ����� +� �W� �� �� � � :�+� v� ���+� v� �� :�+� M��+� M+� 3++� �*� �22�U �Z�]� � � @+� 3+� �*� �12+� ��8�A � � W+� 3+_� 9+a� 3� +�� 3�}}z�� +� 3+� �� ��ùP W+�� 3+�� 9+c� 3+� v��e� ��:�������W��� � � :�+� v�� ���+� v�� �+g� 3� +� 3� +� 3�3+� ��7�A i� �� � �+k� 3++�4� �*� �32� �� �� � � ~+m� 3+� �� �o� � W+{� 3+	� 9+{� 3+� vq� ��:���W��� � � :�+� v�� ���+� v�� �+s� 3�++�4� �*� �32� �� �� �+u� 3+�4*� �42�: �� �� � � +R� 3+w� 9+u� 3� �+�4*� �42�: �� �� � � }+y� 3+� �� ��ιP W+� 3+� v��{� ��:�������W��� � � :�+� v�� ���+� v�� �+}� 3� +� 3� +�� 3+�� 9+� 3+� v���� ��:�������W��� � � :�+� v�� ���+� v�� �+�� 3� +�� 3+� �*� �2� � �� �� � ��+�� 3++� �*� �52�U �Z�]� � �#+�� 3+� H+ȶ�:�+��6����� 6���� � � � �6����� ��:�+� ���� �d6���`��� h������� � � � � L���6�+�� 3++� ����A �s� 3+�� 3++� �*� �62�A �s� 3+�� 3���� ":������ W+� ��� ���������� W+� ��� ���� :�+� M��+� M+¶ 3� ,+Ķ 3+� H+ƶ 3� :�+� M��+� M+ȶ 3+�� 3� +ʶ 3+�� 9+ζ 3+ж 3� A 7 @ @  ]lo )]x{  4��  !��  	�	�	�  	�

  
`
j
j  
�
�
�  0::  ���  ���  t��  ���  Iqq  ���  #--  4KK  ?VV  %%  00  �		  �  ���  ���  ���  ���  ���  ���   � � �  !�!�!�  "f"}"}  #q#�#�  $J$a$a  %U%l%l  &.&E&E  '9'P'P  (()()  ))4)4  )�**  +++  +�+�+�  ,�,�,�  -�-�-�  .�.�.�  /�/�/�  0�0�0�  1�1�1�  2�2�2�  3U3z3z  44B4B  4�4�4�  5�5�5�  6!6Q6Q  66w6z )66�6�  5�6�6�  5�6�6�  7�7�7�  88�8�  9e9�9�  9�::  :�;H;H  :�;�;�  ;�;�;�   K         * +  L  	�c           | # } 0  3 � : � K � N � Q � � � � � � � � � � � � �` �� �= �Z �� �� �� �� �� �� � �< �b �� �� �� �� �� � � �D �j �p �s �y �} �� � �( �PV	Y_c��6<?EI!�#�$�%'"/%1+2/4�6�7�8:BDEG{I�J	K	)L	HM	UP	dS	�T	�W	�X	�[	�]	�`	�b	�e
f
h
*j
4l
Ym
\p
{q
~t
�v
�y
�{
�~
�
��
���)�,�K�N�b�l��������
�"�<�F�m�p�����������B�E�����������������'�:�>�D�H�K�q�w���� ���
��	/ 5$[&a,e.h4�6�:�<�B�D�J�L�PRX#Z&gLiRmxo~u�w�}�����������
��6�<�@�C�i�o��������������������'�-�S�Y�]�`������������	��$D&J*p,v2z4}=�?�C�E�K�M�]	_c5e;k?mB�h�n�r���������������f������� &qtx	~
�����@b���"�# $K'N(R+X,\/b0f4�6�8�9�:$>FA�C�E�H�I�J/L2M6P<Q@TFUJYr[�]�^�_b*e}g�j�l�m�nrsu v$x*y.|V~}��������a�|�����������������:�a�w�������E�`�j������������������� � E� [� i� �� ��!)�!D�!N�!e�!t�!��!��!��!��!��!��!��"�")�"?�"M�"��"��#�#(�#2�#I�#X�#��#��#�#�#�#�#�	#�$$#$1$|$�$�%%%-%<%�"%�#%�%%�&%�(%�)%�-%�/%�1&2&3&`6&�9&�;&�>&�@'A' B'kF'nG'rI'xJ'|L'�M'�P'�R'�T'�U'�V(DY(f\(�^(�a(�c(�d)e)Oi)Rj)Vl)\m)`o)fp)jt)�v)�x)�y)�z*(}*J�*��*��*��*��*��+3�+6�+:�+@�+D�+J�+N�+v�+��+��+��,�,.�,��,��,��,��,��-�-�-�-$�-(�-.�-2�-Z�-��-��-��-��.�.e�.��.��.��.��.��.��/�/�/�/�/�/>�/e�/{�/��/��/��0I�0d�0n�0��0��0��0��0��0��0��0��0�1"1I1_1m1�1�2-2H2R2i2x2�2�2�2�2�!2�"2�%3(3*3%,3<.3�13�23�53�83�:4<4]?4A4�C4�E5H5BJ5�L5�N6O6kP6�S7U76W7EZ7K[7N^7TJ7[^7_a7uc7�e7�h7�i7�l7�m7�p8t8@w8Wx8fy8�|8�~8��9
�95�9L�9��9��9��9��9��9��:!�:'�:+�:T�:W�:�:��;�;$�;E�;��;��;��;��;��;��;��;��;��;��;��M     ) �� J        �    M     ) �� J         �    M     ) �� J        �    M    �    J  5    )*7� �Y���SY��SY��SY��SY��SY���SY��SY��SY��SY	��SY
��SY��SY��SY���SY���SY���SY���SY���SY���SY��SY��SY��SY��SY	��SY��SY��SY��SY��SY��SY��SY��SY��SY ��SY!��SY"��SY#!��SY$#��SY%%��SY&'��SY')��SY(+��SY)-��SY*/��SY+1��SY,3��SY-5��SY.7��SY/9��SY0;��SY1=��SY2?��SY3A��SY4C��SY5E��SY6G��S� ��     N    