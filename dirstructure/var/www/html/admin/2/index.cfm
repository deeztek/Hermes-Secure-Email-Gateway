����   2� D__138/__138/publish/hermes_seg_18_041454/proprietary/_2/index_cfm$cf  lucee/runtime/PageImpl  6../../publish/hermes-seg-18.04/proprietary/2/index.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()J\��>���D getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ��<� getSourceLength      )� getCompileTime  �@,�� getHash ()I�R�[ call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this FL__138/__138/publish/hermes_seg_18_041454/proprietary/_2/index_cfm$cf; �<!DOCTYPE html>

 

<html lang="en">



<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Welcome</title>

   , lucee/runtime/PageContext . write (Ljava/lang/String;)V 0 1
 / 2 ./inc/html_head.cfm 4 	doInclude (Ljava/lang/String;Z)V 6 7
 / 8�

  <!--
  <script>
    $(document).ready(function()
    {
        function refresh()
        {
            var div = $('#systemresources'),
                divHtml = div.html();
    
            div.html(divHtml);
        }
    
        setInterval(function()
        {
            refresh()
        }, 10000); //300000 is 5minutes in ms
    })
  </script>
-->


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
 / E &
            <h1 class="m-0">Welcome  G sessionScope $()Llucee/runtime/type/scope/Session; I J
 / K keys $[Llucee/runtime/type/Collection$Key; M N	  O  lucee/runtime/type/scope/Session Q get 7(Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; S T R U lucee/runtime/op/Caster W toString &(Ljava/lang/Object;)Ljava/lang/String; Y Z
 X [  !</h1>
            
           ] 	outputEnd _ 
 / `�
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Home</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">

        <div class="alert alert-warning alert-dismissible">
          <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
             
          <p><i class="icon fas fa-exclamation-triangle"></i>Welcome to new Hermes SEG 2.0 Web GUI. The new Web GUI is still a work in progress. Some of the navigation links will take you to the old Web GUI. We appreciate your patience as we continue to improve Hermes SEG.</p>

          
          </div>
      

 b lucee/runtime/PageContextImpl d lucee.runtime.tag.Query f cfquery h 6C:\publish\hermes-seg-18.04\proprietary\2\index.cfm:99 j use W(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)Ljavax/servlet/jsp/tagext/Tag; l m
 e n lucee/runtime/tag/Query p hasBody (Z)V r s
 q t checkwizard v setName x 1
 q y hermes { setDatasource (Ljava/lang/Object;)V } ~
 q  
doStartTag � $
 q � initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V � �
 / � V
  select parameter, value from system_settings where parameter='wizard_settings'
   � doAfterBody � $
 q � doCatch (Ljava/lang/Throwable;)V � �
 q � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 q � doEndTag � $
 q � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 e � 
  
   � us &()Llucee/runtime/type/scope/Undefined; � �
 / � "lucee/runtime/type/scope/Undefined � getCollection � T � � $lucee/runtime/type/util/KeyConstants � _VALUE #Llucee/runtime/type/Collection$Key; � �	 � � I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; S �
 / � 2 � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � 
  

     � %./inc/update_postfix_config_files.cfm � 
     � $./inc/update_djigzo_config_files.cfm � $./inc/update_syslog_config_files.cfm � $./inc/update_amavis_config_files.cfm � 


 � 7C:\publish\hermes-seg-18.04\proprietary\2\index.cfm:112 � 	setwizard � L
update system_settings set value = '1' where parameter='wizard_settings'
 � 	

 
   � 



  
 � lucee.runtime.tag.FileTag � cffile � 7C:\publish\hermes-seg-18.04\proprietary\2\index.cfm:121 � lucee/runtime/tag/FileTag �
 � t read � 	setAction � 1
 � � /opt/hermes/keys/hermes.key � setFile � 1
 � � authkey � setVariable � 1
 � �
 � �
 � � 

 � � U   � ./inc/generate_hermes_key.cfm � 7C:\publish\hermes-seg-18.04\proprietary\2\index.cfm:132 � get_serverkeyword � Z
  select property, value from encryption_settings where property='user.serverSecret'
   � +./inc/generate_ciphermail_server_secret.cfm  

  7C:\publish\hermes-seg-18.04\proprietary\2\index.cfm:144 get_clientkeyword Z
  select property, value from encryption_settings where property='user.clientSecret'
   +./inc/generate_ciphermail_client_secret.cfm
 7C:\publish\hermes-seg-18.04\proprietary\2\index.cfm:156 get_mailkeyword Z
select property, value from encryption_settings where property='user.systemMailSecret'
 
  
 

  
 )./inc/generate_ciphermail_mail_secret.cfm 





 ./inc/get_system_ip.cfm 
 ./inc/get_system_uptime.cfm "./inc/get_system_version_build.cfm  $./inc/get_system_reboot_required.cfm" ./inc/check_system_update.cfm$ (



<div id="systemresources">

  & ./inc/get_system_resources.cfm(�


</div>

 <!-- System Info Card -->
 <div class="card">
  <div class="card-header">
    <h3 class="card-title">
      <i class="fas fa-info"></i>
     System Info
    </h3>


  <!-- /.card-header -->
</div>



  <div class="card-body table-responsive">

    <div class="row">

      <table class="table">
        <thead>
        <tr>
          <th>Version</th>
          <th>Build</th>
          <th>Edition</th>
          <th>Uptime</th>
          <th>System IP</th>
          <th>License Status</th>
          <th>OS Updates</th>
          <th>Hermes Update</th>
     
    
        </tr>
        </thead>
        <tbody>

          <tr>
            * 
            <td>, </td>
            <td>. </td>

            0 	Community2 T&nbsp;&nbsp;<a href='view_system_settings.cfm'>ENTER SERIAL</a></td>

            4 Pro6 
              <td>8 </td>
            : (
              <td>N/A</td>
          < 

            <td>>  Days</td>
            <td>@ </td>


B VALIDD 


  <td>F 	 EXPIRES H 	</td>

J EXPIREDL 

<td>N  ON P 	VIOLATIONR 

<td>VIOLATION</td> 

T N/AV 

  <td>N/A</td> 


X 

  <td>N/A</td> 

 
Z          



          \ 2
            <td>REBOOT REQUIRED</td>
          ^ 5
            <td>NO REBOOT REQUIRED</td>
          ` 

          <td>b </td>

          d�
         
      </tr>
            
                  
                  </tbody>
                </table>



</div>

      
    
    </div>

        
      </div>

 



        <!-- System Resources Card -->
        <div class="card">

          <div class="card-header">
            <h3 class="card-title">
              <i class="fas fa-chart-bar"></i>
             System Resources
            </h3>


       <!-- /.card-header -->
</div>



          <div class="card-body" id="systemresources">

            <div class="row">
              <div class="col-6 col-md-3 text-center">
       
                f 9
                <input type="text" class="knob" value="h 2" data-width="90" data-height="90" data-fgColor="#j " readonly>
              l �

                <div class="knob-label">CPU Utilization %</div>
              </div>
              <!-- ./col -->

              <div class="col-6 col-md-3 text-center">
                n �

                <div class="knob-label">Memory Utilization %</div>
              </div>
              <!-- ./col -->

              <div class="col-6 col-md-3 text-center">
                p �

                <div class="knob-label">Root FileSystem Utilization %</div>
              </div>
              <!-- ./col -->


              <div class="col-6 col-md-3 text-center">
                rh

                <div class="knob-label">Data FileSystem Utilization %</div>

  
</div>

      

</div>

    
  </div>
                      

</div><!-- /.col -->
</div><!-- /.row -->
           
           
      
      <!-- /.container-fluid -->
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


  t ./inc/main_footer.cfmv <

<!-- ./wrapper -->


</body>







</html>
x udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageException�  lucee/runtime/type/UDFProperties� udfs #[Llucee/runtime/type/UDFProperties;��	 � setPageSource� 
 � !lucee/runtime/type/Collection$Key� THEUSER� lucee/runtime/type/KeyImpl� intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;��
�� CHECKWIZARD� AUTHKEY� GET_SERVERKEYWORD� GET_CLIENTKEYWORD� GET_MAILKEYWORD� 
THEVERSION� THEBUILD� EDITION� UPTIME� THEIPADDRESS� LICENSE� LICENSEEXPIRES� 
MUSTREBOOT� HERMESUPDATE� CPU� CPUCOLOR� MEM� MEMCOLOR� 	ROOTUSAGE� ROOTUSAGECOLOR� 	DATAUSAGE� DATAUSAGECOLOR� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             M N   ��       �   *     *� 
*� *� � *����*+���        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  �  (  
�+-� 3+5� 9+;� 3+=� 9+?� 3+A� 9+C� 3+� F+H� 3++� L*� P2� V � \� 3+^� 3� 
M+� a,�+� a+c� 3+� F+� egik� o� qN-� u-w� z-|� �-� �6� I+-� �+�� 3-� ����� ":-� �� :� +� �W-� ��� +� �W-� �-� �� � ��� :+� e-� ��+� e-� �� :+� a�+� a+�� 3++� �*� P2� � � �� ��� �� � �+¶ 3+�� 9+ƶ 3+�� 9+ƶ 3+�� 9+ƶ 3+�� 9+ζ 3+� F+� egiж o� q:		� u	Ҷ z	|� �	� �6

� N+	
� �+Զ 3	� ����� $:	� �� :
� +� �W	� ��
� +� �W	� �	� �� � ��� :+� e	� ��+� e	� �� :+� a�+� a+ֶ 3� +ض 3+� e��޶ o� �:� �� �� ��� �� �W� �� � ��� :+� e� ��+� e� �+�� 3+� �*� P2� � �� �� � � +ζ 3+�� 9+ζ 3� +ζ 3+� F+� egi�� o� q:� u�� z|� �� �6� N+� �+�� 3� ����� $:� �� :� +� �W� ��� +� �W� �� �� � ��� :+� e� ��+� e� �� :+� a�+� a+�� 3++� �*� P2� � � �� ��� �� � � +ζ 3+� 9+ζ 3� +� 3+� F+� egi� o� q:� u� z|� �� �6� O+� �+	� 3� ���� $:� �� :� +� �W� ��� +� �W� �� �� � ��� :+� e� ��+� e� �� :+� a�+� a+�� 3++� �*� P2� � � �� ��� �� � � +ζ 3+� 9+ζ 3� +�� 3+� F+� egi� o� q:� u� z|� �� �6� O+� �+� 3� ���� $:� �� : � +� �W� � �� +� �W� �� �� � ��� :!+� e� �!�+� e� �� :"+� a"�+� a+� 3++� �*� P2� � � �� ��� �� � � +� 3+� 9+ζ 3� +� 3+� 9+� 3+� 9+� 3+!� 9+� 3+#� 9+� 3+%� 9+'� 3+)� 9++� 3+� F+-� 3++� �*� P2� � � \� 3+/� 3++� �*� P2� � � \� 3+1� 3+� L*� P2� V 3� �� � � ++-� 3++� L*� P2� V � \� 3+5� 3� T+� L*� P2� V 7� �� � � ++9� 3++� L*� P2� V � \� 3+;� 3� 
+=� 3+?� 3++� �*� P	2� � � \� 3+A� 3++� �*� P
2� � � \� 3+C� 3+� L*� P2� V 7� �� � �:+�� 3+� L*� P2� V E� �� � � I+G� 3++� L*� P2� V � \� 3+I� 3++� L*� P2� V � \� 3+K� 3� �+� L*� P2� V M� �� � � I+O� 3++� L*� P2� V � \� 3+Q� 3++� L*� P2� V � \� 3+C� 3� [+� L*� P2� V S� �� � � +U� 3� /+� L*� P2� V W� �� � � +Y� 3� +�� 3� /+� L*� P2� V 3� �� � � +[� 3� +]� 3+� �*� P2� � �� �� � � +_� 3� 
+a� 3+c� 3++� �*� P2� � � \� 3+e� 3� :#+� a#�+� a+g� 3+� F+i� 3++� �*� P2� � � \� 3+k� 3++� �*� P2� � � \� 3+m� 3� :$+� a$�+� a+o� 3+� F+i� 3++� �*� P2� � � \� 3+k� 3++� �*� P2� � � \� 3+m� 3� :%+� a%�+� a+q� 3+� F+i� 3++� �*� P2� � � \� 3+k� 3++� �*� P2� � � \� 3+m� 3� :&+� a&�+� a+s� 3+� F+i� 3++� �*� P2� � � \� 3+k� 3++� �*� P2� � � \� 3+m� 3� :'+� a'�+� a+u� 3+w� 9+y� 3�  1 V V   � � � ) � � �   } � �   k  ��� )���  �  �**  Y��  $36 )$?B  �xx  ���  ,<? ),HK  ��  ���  4DG )4PS  
��  ���  [	b	b  	z	�	�  	�

  
6
|
|  
�
�
�   �         * +  �  � q           9  : * < - C 4 D a H d J g c � e gE iH jR k_ ll my o| p� r: t@ uC xF y� {� }� ~� �� �� �� �' �� �� �� �� �� �� �0 �� �� �� �� �� �� �8 �� �� �� �� �� �� �� �	 � �' �6 �E �H �T �W �_ �� �� �� �� � �/ �6 �9 �= �^ �| �� �� � �2 �t �� �� �� ���	
		-	0	7	:	>	o	s	vA	~B	�C	�E	�J	�K
L
/N
2S
:T
vU
�W
�]
�^
�_
�a
��
���     ) z{ �        �    �     ) |} �         �    �     ) ~ �        �    �    �    �   �     �*��Y���SY���SY���SY���SY���SY���SY���SY���SY���SY	���SY
���SY���SY���SY���SY���SY���SY���SY���SY���SY���SY���SY���SY���S� P�     �    