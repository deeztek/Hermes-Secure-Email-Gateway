����   2� R__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_system_updates_cfm$cf  lucee/runtime/PageImpl  D../../publish/hermes-seg-18.04/proprietary/2/view_system_updates.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  �ط�� getSourceLength      U� getCompileTime  �\��� getHash ()I��� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this TL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/view_system_updates_cfm$cf; �<!DOCTYPE html>


 

<html lang="en">


<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | System Updates</title>

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
 / E *
<h1 class="m-0">System Updates</h1>

     G 	outputEnd I 
 / J�

    </div><!-- /.col -->
    <div class="col-sm-6">
<ol class="breadcrumb float-sm-right">
  <li class="breadcrumb-item"><a href="#">Home</a></li>
  <li class="breadcrumb-item active">System Updates</li>
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
 / � "lucee/runtime/type/scope/Undefined � set I(Llucee/runtime/type/Collection$Key;Ljava/lang/Object;)Ljava/lang/Object; � � � � 

  
   � 


 



 � step � 
    
 � action �  
 � 	formScope !()Llucee/runtime/type/scope/Form; � �
 / � _action � �	 � � 
 � _ACTION � �	 � � lucee/runtime/type/scope/Form � � � 


 � 
  


  
   � session.dev_release � 2 �  

   � keys $[Llucee/runtime/type/Collection$Key; � �	  � � � 
  

 � theFile �  

 � _file � �	 � � 

   � _FILE � �	 � � 
     � 
    
  
   � 
  
  
 � 



  
 
  


 � lucee.runtime.tag.Query � cfquery � EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:224 � use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; � �
 x � lucee/runtime/tag/Query � hasBody (Z)V � 
 � 
getupdates setName 1
 � hermes setDatasource (Ljava/lang/Object;)V

 � 
doStartTag $
 � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V
 / e
select build, status, date_installed, install_order from system_updates order by install_order desc
 doAfterBody $
 � doCatch (Ljava/lang/Throwable;)V
 � popBody ()Ljavax/servlet/jsp/JspWriter;
 /  	doFinally" 
 �# doEndTag% $
 �& lucee/runtime/exp/Abort( newInstance (I)Llucee/runtime/exp/Abort;*+
), reuse !(Ljavax/servlet/jsp/tagext/Tag;)V./
 x0 

2 urlScope  ()Llucee/runtime/type/scope/URL;45
 /6 lucee/runtime/type/scope/URL89 � ./inc/check_system_update.cfm;







<div class="card col-sm-8">


<form name="SetDev" method="post">



  <div class="col-sm-6">

 

   <div class="form-group">
            <label><strong>Check for DEV Releases</strong></label>
            <div class="alert alert-warning">
         
              <p><i class="icon fas fa-exclamation-triangle"></i>Do Not install DEV Releases Unless Guided by Support</p>
              </div>
              
            <select class="form-control" name="dev_release" style="width: 100%;" id="dev_release">

              = �
               
                <option value="2" selected>NO</option>
                <option value="1">YES</option>

              ? 1A w

                <option value="1" selected>YES</option>
                <option value="2">NO</option>

              C 

                E #lucee/commons/color/ConstantsDoubleG _0 Ljava/lang/Double;IJ	HK 
                M 1System Updates: session.dev_release is not 1 or 2O ./inc/error.cfmQ lucee.runtime.tag.AbortS cfabortU EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:275W lucee/runtime/tag/AbortY
Z
Z& 

              
              ]r
             
                </select>   
              
              </div>
    </div>
  
  
  <div class="col-sm-4">
  
  <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">
  </div>
    
  </form>
  <br>

      
</div>





<div class="modal fade" id="installupdate_modal" tabindex="-1" role="dialog" aria-labelledby="InstallUpdateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  
    <h4 class="modal-title">Install Update </h4>
</div>
  
<div class="modal-body">


  <form name="InstallUpdate" autocomplete="off" method="post">

    <input type="hidden" name="action" value="installupdate">

   
      <p>Do you wish to install the following update?</p>

   

    _�
      <div class="form-group">
        <label for="build"><strong>Build No</strong></label>
        <input type="text" class="form-control" name="build" value="" id="build" placeholder="Build No" maxLength="20" readonly="yes">
        <label for="date"><strong>Release Date</strong></label>
        <input type="text" class="form-control" name="released" value="" id="released" placeholder="Release Date" maxLength="20" readonly="yes">
        
        <input type="hidden" class="form-control" name="InstallFile" value="" id="InstallFile">
        <input type="hidden" class="form-control" name="BuildNo" value="" id="BuildNo">
      </div>
      a 

      <div class="alert alert-warning">
    
        <p><i class="icon fas fa-exclamation-triangle"></i>Please select <strong>I Agree</strong> from the drop-down below to verify that you have a <strong>valid and recent System Backup</strong>, you have read the <strong>Release Note</strong> for this update and <strong>agree that this update is provided with absolutely no guarantees or warranties of any kind explicitly or implied</strong>. <strong>Furthermore, you agree that we are NOT liable for any damage that may occur to your system, service, cat, dog, car, house etc..</strong> Simply stated, <strong>you are installing this update at your own risk.</strong> This update may introduce breaking changes and additional steps may have to be performed manually after the update installs. Ensure you refer to the <strong>Release Note</strong> for details.</p>
        </div>

        <div class="form-group">
        
        <select class="form-control" name="update_tos" data-placeholder="update_tos" style="width: 100%">                  
        c<option value="disagree" selected="selected">I do NOT Agree</option>
        <option value="agree">I Agree</option>
        
        </select> 
        </div>

      
        
    <div>&nbsp;</div>

    <input type="submit" value="Install" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  </form>

</div>


<div class="modal-footer">
 
<button type="button" class="btn btn-danger" data-dismiss="modal">Cancel</button>

</div>
    </div>
  </div>
</div>







e � � downloadupdateh 

  
  

  j 
  
  l !Download Update: theFile is emptyn EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:383p  ./inc/download_system_update.cfmr &(Ljava/lang/Object;)Ljava/lang/String; rt
 �u .hashw java/lang/Stringy concat &(Ljava/lang/String;)Ljava/lang/String;{|
z} ./inc/verify_system_update.cfm 


  
� 

  

� lucee.runtime.tag.Location� 
cflocation� EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:417� lucee/runtime/tag/Location�  /admin/2/view_system_updates.cfm� setUrl� 1
�� setAddtoken� 
��
�
�& 



� installupdate� 


  � 

    � 

      � )Install Update: form.InstallFile is empty� 
      � EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:434� 
      
    
    � /Install Update: form.InstallFile does not exist� EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:443� 

  
� agree� disagree� 8Install Update: form.update_tos is not agree or disagree� EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:457� .Install Update: form.update_tos does not exist� EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:466� integer� (lucee/runtime/functions/decision/IsValid� B(Llucee/runtime/PageContext;Ljava/lang/String;Ljava/lang/Object;)Z &�
�� 

  
      � 3Install Update: form.BuildNo is not a valid integer� EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:484� 
  
    � +Install Update: form.BuildNo does not exist� EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:493� 
  
    
  � 
  
  

� ./inc/install_system_update.cfm� EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:506� _8�J	H� EC:\publish\hermes-seg-18.04\proprietary\2\view_system_updates.cfm:512�u

  


  <div class="alert alert-warning">
    
    <p><i class="icon fas fa-exclamation-triangle"></i>Please note that system updates are NOT cumulative. The system will only show one update at a time to be installed. You must install each update in the order the system presents them until all updates have been installed and your system is up-to-date.</p>
    </div>



� �

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    � 3Update Server Reported NOTFOUND Error (Error Code: � )� 
  </div>

  � :Update Server Reported Invalid License Error (Error Code: � 3� �

  <div class="alert alert-success alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    � [Update downloaded successfully. Please click the Install button below to install the update� 4� 7There was an error downloading the update (Error Code: � 5� wUpdate has failed checksum verification. Update is corrupted. Please retry to download or contact support (Error Code: � 6� �Update has failed to install. Please click <strong>Download System Update Log</strong> button below and contact support (Error Code: � @

    <div>&nbsp;</div>

    <div class="text-center">
    
    � �
      <a href="/admin/2/inc/download_system_update_log.cfm" class="btn btn-secondary" role="button"><i class="fas fa-download fa-lg"></i>&nbsp;&nbsp;Download System Update Log</a>
      � 
    </div>

</div>

� 
  
� 7 �Update installed successfully. Please click <strong>Download System Update Log</strong> button below if you wish to view the update details. 
    </div>

  </div> 


 8 �You must select the <strong>I agree</strong> option in the <strong>Install Update</strong> window before you can install the update (Error Code: 	 





 _STATUS �	 � SUCCESS ct '(Ljava/lang/Object;Ljava/lang/Object;)Z
 � ./inc/updates_show_new.cfm 
    
    
 
Connection �
      
  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
     OThere was a problem attempting to reach the update server. Specific error was:  getCollection  � �! I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; �#
 /$ �<br>Hermes SEG must have access to the URL <strong>updates.deeztek.com</strong> over ports 80 and 443 <strong>without SSL interception</strong> in order to check for updates.</strong>& 
  </div>

  
    
  ( ./inc/updates_show_old.cfm* 
      
  
  , INVALID. �

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      0 :Unable to check updates. Your license is invalid.</strong>2 
    </div>
  
      
    4 
      

  6 NOUPDATE8 �


    <div class="alert alert-success alert-dismissible">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-check"></i> Success!</h4>
      : &Your system is on the latest version. < <br> 
    </div>

    > INVALIDREQUEST@ .There was a problem fetching updates.</strong>B 
  </div>

    
  D INVALID REQUESTF EXPIREDH ;Unable to check updates. Your license has expired.</strong>J 
  </div>

L N/AN =Unable to check updates. You must install a license.</strong>P 	VIOLATIONR JUnable to check updates. The system detected a license violation.</strong>T 
      



  Vb
    

    

    
    
   
    
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


X ./inc/main_footer.cfmZ�

<!-- ./wrapper -->



</body>


<script>
  $('#installupdate_modal').on('show.bs.modal', function(e) {
var file = $(e.relatedTarget).data('file');
$(e.currentTarget).find('input[name="InstallFile"]').val(file);

var build = $(e.relatedTarget).data('build');
$(e.currentTarget).find('input[name="build"]').val(build);

var build = $(e.relatedTarget).data('build');
$(e.currentTarget).find('input[name="BuildNo"]').val(build);

var released = $(e.relatedTarget).data('released');
$(e.currentTarget).find('input[name="released"]').val(released);


  });


    </script>





<script>
  $('#installupdate_modal_mysql').on('show.bs.modal', function(e) {
var file = $(e.relatedTarget).data('file');
$(e.currentTarget).find('input[name="file"]').val(file);

var build = $(e.relatedTarget).data('build');
$(e.currentTarget).find('input[name="build"]').val(build);

var released = $(e.relatedTarget).data('released');
$(e.currentTarget).find('input[name="released"]').val(released);


  });


    </script>




</html>\ udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageExceptiond  lucee/runtime/type/UDFPropertiesf udfs #[Llucee/runtime/type/UDFProperties;hi	 j setPageSourcel 
 m dev_releaseo lucee/runtime/type/KeyImplq intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;st
ru DEV_RELEASEw THEFILEy DEV{ STEP} THEFILENAME InstallFile� INSTALLFILE� 
update_tos� 
UPDATE_TOS� BuildNo� BUILDNO� CFHTTP� 
STATUSCODE� HERMESUPDATE� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             � �   ��       �   *     *� 
*� *� � *�g�k*+�n�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  7  E  �+-� 3+5� 9+;� 3+=� 9+?� 3+A� 9+C� 3+� F+H� 3� 
M+� K,�+� K+M� 3+O� 9+Q� 3+S+� X� ^N6+� X-� /`Y:� !� bY� dYf� hS� ln� q� u� v�N6+� xzS- { {� �+?� 3++� �� �� �� �� �� W+?� 3+� �� �� � �� �� � � ++?� 3+� �� �+� �� �� � � � W+�� 3� +�� 3� +�� 3+�+� X� ^:6+� X� 0`Y:� !� bY� dYf� h�� ln� q� u� v�:6+� xz� { {� �+�� 3+�+� X� ^:	6
+� X	� 0�Y:� !� bY� dYf� h�� ln� q� u� v�:	6
+� xz�	 { {
� �+�� 3++� ¸ �� �� �� �� W+Ƕ 3+� ² ʹ � �� �� � � ++Ƕ 3+� �� �+� ² ʹ � � � W+϶ 3� +϶ 3� +Ѷ 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� hӶ ln� q� u� v�:6+� xz� { {� �+׶ 3++� ¸ �*� �2� �� �� `+?� 3+� �*� �2� � �� �� � � 1+?� 3+� �*� �2+� �*� �2� � � � W+޶ 3� +϶ 3� +϶ 3+�+� X� ^:6+� X� 0�Y:� !� bY� dYf� h� ln� q� u� v�:6+� xz� { {� �+� 3++� ¸ �� �� �� �� Z+� 3+� ² � � �� �� � � .+� 3+� �*� �2+� ² � � � � W+� 3� +� 3� +� 3+� F+� x���� �� �:��	��6� O+�+� 3���� $:�� :� +�!W�$�� +�!W�$�'� �-�� :+� x�1�+� x�1� :+� K�+� K+3� 3+� F+Ƕ 3+�7*� �2+� �*� �2� � �: W+Ƕ 3� :+� K�+� K+3� 3+<� 9+>� 3+� �*� �2� � ո �� � � +@� 3� �+� �*� �2� � B� �� � � +D� 3� �+F� 3+� �*� �2�L� � W+N� 3+� �� �P� � W+N� 3+R� 9+N� 3+� xTVX� ��Z:�[W�\� �-�� :+� x�1�+� x�1+^� 3+`� 3+� F+b� 3� :+� K�+� K+d� 3+f� 3+� �� ʹg i� �� � �+k� 3+� �*� �2�g �� �� � � |+m� 3+� �� �o� � W+?� 3+R� 9+?� 3+� xTVq� ��Z:�[W�\� �-�� :+� x�1�+� x�1+3� 3�+϶ 3+� F+?� 3+� �*� �2+� �*� �2�g � � W+?� 3� :+� K�+� K+϶ 3+s� 9+϶ 3+� F+Ƕ 3+� �*� �2+� �*� �2�g �vx�~� � W+Ƕ 3� :+� K�+� K+϶ 3+s� 9+϶ 3+� F+Ƕ 3+� �*� �2+� �*� �2�g � � W+Ƕ 3� : +� K �+� K+϶ 3+�� 9+�� 3+�� 3+� x���� ���:!!���!��!��W!��� �-�� :"+� x!�1"�+� x!�1+�� 3��+� �� ʹg �� �� � ��+�� 3++� ¸ �*� �2� �� �� �+�� 3+� �*� �2� � �� �� � � 5+�� 3+� �*� �2+� �*� �2� � � � W+�� 3� {+�� 3+� �� ��� � W+�� 3+R� 9+�� 3+� xTV�� ��Z:##�[W#�\� �-�� :$+� x#�1$�+� x#�1+�� 3+� 3� y+�� 3+� �� ��� � W+� 3+R� 9+� 3+� xTV�� ��Z:%%�[W%�\� �-�� :&+� x%�1&�+� x%�1+�� 3+϶ 3++� ¸ �*� �2� �� �� �+3� 3+� �*� �	2� � �� �� � � )+� �*� �	2� � �� �� � � � � +� 3� x+�� 3+� �� ��� � W+� 3+R� 9+� 3+� xTV�� ��Z:''�[W'�\� �-�� :(+� x'�1(�+� x'�1+� 3+3� 3� x+� 3+� �� ��� � W+?� 3+R� 9+?� 3+� xTV�� ��Z:))�[W)�\� �-�� :*+� x)�1*�+� x)�1+�� 3+϶ 3++� ¸ �*� �
2� �� �� �+� 3+�+� �*� �2� � ��� U+3� 3+� F+Ƕ 3+� �*� �2+� �*� �2� � � � W+Ƕ 3� :++� K+�+� K+�� 3� {+ö 3+� �� �Ź � W+�� 3+R� 9+�� 3+� xTVǶ ��Z:,,�[W,�\� �-�� :-+� x,�1-�+� x,�1+�� 3+m� 3� y+ɶ 3+� �� �˹ � W+� 3+R� 9+� 3+� xTVͶ ��Z:..�[W.�\� �-�� :/+� x.�1/�+� x.�1+϶ 3+Ѷ 3+� �*� �	2� � �� �� � � s+϶ 3+�� 9+϶ 3+� x��ն ���:00���0��0��W0��� �-�� :1+� x0�11�+� x0�1+3� 3� y+3� 3+� �� ��ع � W+3� 3+� x��ڶ ���:22���2��2��W2��� �-�� :3+� x2�13�+� x2�1+϶ 3+�� 3� +ܶ 3+� �� ��g B� �� � � `+޶ 3+� F+� 3++� �� ��g �v� 3+� 3� :4+� K4�+� K+� 3+� �� ��L� � W+3� 3� +3� 3+� �� ��g ո �� � � `+޶ 3+� F+� 3++� �� ��g �v� 3+� 3� :5+� K5�+� K+� 3+� �� ��L� � W+3� 3� +3� 3+� �� ��g � �� � � F+� 3+� F+� 3� :6+� K6�+� K+� 3+� �� ��L� � W+3� 3� +3� 3+� �� ��g � �� � � `+޶ 3+� F+� 3++� �� ��g �v� 3+� 3� :7+� K7�+� K+� 3+� �� ��L� � W+3� 3� +3� 3+� �� ��g � �� � � `+޶ 3+� F+�� 3++� �� ��g �v� 3+� 3� :8+� K8�+� K+� 3+� �� ��L� � W+3� 3� +3� 3+� �� ��g �� �� � � �+޶ 3+� F+�� 3++� �� ��g �v� 3+� 3� :9+� K9�+� K+�� 3+� F+�� 3� ::+� K:�+� K+�� 3+� �� ��L� � W+ � 3� +3� 3+� �� ��g � �� � � h+� 3+� F+� 3� :;+� K;�+� K+�� 3+� F+�� 3� :<+� K<�+� K+� 3+� �� ��L� � W+3� 3� +϶ 3+� �� ��g � �� � � `+޶ 3+� F+
� 3++� �� ��g �v� 3+� 3� :=+� K=�+� K+� 3+� �� ��L� � W+3� 3� +� 3+� ���g �� +϶ 3+� 9+� 3�Y+� ���g �� g+� 3+� F+� 3+++� �*� �2�" *� �2�%�v� 3+'� 3� :>+� K>�+� K+)� 3++� 9+-� 3��+� ���g /�� >+1� 3+� F+3� 3� :?+� K?�+� K+5� 3++� 9+7� 3��+� ���g 9�� >+;� 3+� F+=� 3� :@+� K@�+� K+?� 3++� 9+3� 3�@+� ���g A�� Y+޶ 3+� F+C� 3� :A+� KA�+� K+E� 3++� 9+7� 3+� �*� �2G� � W+3� 3� �+� ���g I�� /+޶ 3+� F+K� 3� :B+� KB�+� K+M� 3� �+� ���g O�� /+޶ 3+� F+Q� 3� :C+� KC�+� K+M� 3� S+� ���g S�� >+޶ 3+� F+U� 3� :D+� KD�+� K+E� 3++� 9+W� 3� +Y� 3+[� 9+]� 3� ' 1 : :  GWZ )Gcf  ��  	��  ���  ���    ���  �,,  Q��  ���  ??  	:	Q	Q  	�	�	�  
�
�
�  '>>  ���  /FF  ���  7\\  ���  -QQ  ���  0::  ���  >>  ���  ���  @JJ  bll  ���  o��  ���  8BB  ���  ���  4>>  u   �         * +  �             g  h * j - q 4 r E v H x K � U � X � � � � � � � � � � �! �� �� �� �" �A �G �J �P �S �� �� �� � �# �& �, �/ �� �� �� �� �� �� �� � � �K �� �� �� � � �CI	nqx���
CD(M,O/W6wXy[{}�~��������&�<�?�J�M�T�������������������������Z�����������	�	!�	l�	o�	r�	|�	��	��	��	��	��
�
b�
l�
��
��
��
��
��
�� ��Y�\�_�}�������������a�d�h�r����������������w���� ����&)bey�� �#�$�&�(*),,/K0N2b4l6�8�;�<�>�@�BDGOHRJfLpN�P�S�U�Y�Z�[�\�`
bd9f<i[k^ofpyq}r�w�y�|�~�������"�:�=�I�O�h�k�����������������1�4�S�V�b���������������������-�0�O�U�n�q����������������     ) ^_ �        �    �     ) `a �         �    �     ) bc �        �    �    e    �   �     �*� �Yp�vSYx�vSYz�vSY|�vSY~�vSY��vSY��vSY��vSY��vSY	��vSY
��vSY��vSY��vSY��vSY��vS� ۱     �    