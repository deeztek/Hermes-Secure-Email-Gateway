����   2� proprietary/_2/index_cfm$cf  lucee/runtime/PageImpl   /compile/proprietary/2/index.cfm <init> (Llucee/runtime/PageSource;)V ()V  
  	 initKeys  
   imports *[Llucee/runtime/component/ImportDefintion; 'lucee/runtime/component/ImportDefintion   	   
getVersion ()JY��Q��a� getImportDefintions ,()[Llucee/runtime/component/ImportDefintion; getSourceLastModified  ��H�� getSourceLength      (� getCompileTime  ����� getHash ()IL3J� call /(Llucee/runtime/PageContext;)Ljava/lang/Object; java/lang/Throwable ( this Lproprietary/_2/index_cfm$cf; �<!DOCTYPE html>

 

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
      

 b lucee/runtime/PageContextImpl d lucee.runtime.tag.Query f cfquery h use E(Ljava/lang/String;Ljava/lang/String;I)Ljavax/servlet/jsp/tagext/Tag; j k
 e l lucee/runtime/tag/Query n checkwizard p setName r 1
 o s hermes u setDatasource (Ljava/lang/Object;)V w x
 o y 
doStartTag { $
 o | initBody &(Ljavax/servlet/jsp/tagext/BodyTag;I)V ~ 
 / � V
  select parameter, value from system_settings where parameter='wizard_settings'
   � doAfterBody � $
 o � doCatch (Ljava/lang/Throwable;)V � �
 o � popBody ()Ljavax/servlet/jsp/JspWriter; � �
 / � 	doFinally � 
 o � doEndTag � $
 o � lucee/runtime/exp/Abort � newInstance (I)Llucee/runtime/exp/Abort; � �
 � � reuse !(Ljavax/servlet/jsp/tagext/Tag;)V � �
 e � 
  
   � us &()Llucee/runtime/type/scope/Undefined; � �
 / � "lucee/runtime/type/scope/Undefined � getCollection � T � � $lucee/runtime/type/util/KeyConstants � _VALUE #Llucee/runtime/type/Collection$Key; � �	 � � I(Ljava/lang/Object;Llucee/runtime/type/Collection$Key;)Ljava/lang/Object; S �
 / � 2 � lucee/runtime/op/Operator � compare '(Ljava/lang/Object;Ljava/lang/String;)I � �
 � � 
  

     � %./inc/update_postfix_config_files.cfm � 
     � $./inc/update_djigzo_config_files.cfm � $./inc/update_syslog_config_files.cfm � $./inc/update_amavis_config_files.cfm � 


 � 	setwizard � L
update system_settings set value = '1' where parameter='wizard_settings'
 � 	

 
   � 



 � get_serverkeyword � Z
  select property, value from encryption_settings where property='user.serverSecret'
   � 

 �   � +./inc/generate_ciphermail_server_secret.cfm � 

  � get_clientkeyword � Z
  select property, value from encryption_settings where property='user.clientSecret'
   � +./inc/generate_ciphermail_client_secret.cfm � get_mailkeyword � Z
select property, value from encryption_settings where property='user.systemMailSecret'
 � 
  
 � 

  
 � )./inc/generate_ciphermail_mail_secret.cfm � 





 � ./inc/get_system_ip.cfm � 
 � ./inc/get_system_uptime.cfm � "./inc/get_system_version_build.cfm � $./inc/get_system_reboot_required.cfm � ./inc/check_system_update.cfm � (



<div id="systemresources">

   � ./inc/get_system_resources.cfm ��


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
             � 
            <td> � U </td>
            <td> </td>

             	Community T&nbsp;&nbsp;<a href='view_system_settings.cfm'>ENTER SERIAL</a></td>

            
 Pro 
              <td> </td>
             (
              <td>N/A</td>
           

            <td>  Days</td>
            <td> </td>


 VALID 


  <td> 	 EXPIRES  	</td>

  EXPIRED" 

<td>$  ON & 	VIOLATION( 

<td>VIOLATION</td> 

* N/A, 

  <td>N/A</td> 


. 

  <td>N/A</td> 

 
0          



          2 2
            <td>REBOOT REQUIRED</td>
          4 5
            <td>NO REBOOT REQUIRED</td>
          6 

          <td>8 </td>

          :�
         
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
       
                < 9
                <input type="text" class="knob" value="> 2" data-width="90" data-height="90" data-fgColor="#@ " readonly>
              B �

                <div class="knob-label">CPU Utilization %</div>
              </div>
              <!-- ./col -->

              <div class="col-6 col-md-3 text-center">
                D �

                <div class="knob-label">Memory Utilization %</div>
              </div>
              <!-- ./col -->

              <div class="col-6 col-md-3 text-center">
                F �

                <div class="knob-label">Root FileSystem Utilization %</div>
              </div>
              <!-- ./col -->


              <div class="col-6 col-md-3 text-center">
                Hh

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


  J ./inc/main_footer.cfmL <

<!-- ./wrapper -->


</body>







</html>
N udfCall H(Llucee/runtime/PageContext;Llucee/runtime/type/UDF;I)Ljava/lang/Object; 
threadCall (Llucee/runtime/PageContext;I)V udfDefaultValue C(Llucee/runtime/PageContext;IILjava/lang/Object;)Ljava/lang/Object; lucee/runtime/exp/PageExceptionV  lucee/runtime/type/UDFPropertiesX udfs #[Llucee/runtime/type/UDFProperties;Z[	 \ setPageSource^ 
 _ !lucee/runtime/type/Collection$Keya THEUSERc lucee/runtime/type/KeyImple intern 7(Ljava/lang/String;)Llucee/runtime/type/Collection$Key;gh
fi CHECKWIZARDk GET_SERVERKEYWORDm GET_CLIENTKEYWORDo GET_MAILKEYWORDq 
THEVERSIONs THEBUILDu EDITIONw UPTIMEy THEIPADDRESS{ LICENSE} LICENSEEXPIRES 
MUSTREBOOT� HERMESUPDATE� CPU� CPUCOLOR� MEM� MEMCOLOR� 	ROOTUSAGE� ROOTUSAGECOLOR� 	DATAUSAGE� DATAUSAGECOLOR� subs [Llucee/runtime/CIPage; Code LocalVariableTable LineNumberTable 
Exceptions 
SourceFile             M N   ��       �   *     *� 
*� *� � *�Y�]*+�`�        �         �        �        � �        �         �        �         �         �         !�      # $ �        %�      & ' �  �  &  
!+-� 3+5� 9+;� 3+=� 9+?� 3+A� 9+C� 3+� F+H� 3++� L*� P2� V � \� 3+^� 3� 
M+� a,�+� a+c� 3+� F+� egi� m� oN-q� t-v� z-� }6� I+-� �+�� 3-� ����� ":-� �� :� +� �W-� ��� +� �W-� �-� �� � ��� :+� e-� ��+� e-� �� :+� a�+� a+�� 3++� �*� P2� � � �� ��� �� � � �+�� 3+�� 9+�� 3+�� 9+�� 3+�� 9+�� 3+�� 9+ȶ 3+� F+� egi� m� o:		ʶ t	v� z	� }6

� N+	
� �+̶ 3	� ����� $:	� �� :
� +� �W	� ��
� +� �W	� �	� �� � ��� :+� e	� ��+� e	� �� :+� a�+� a+ζ 3� +ж 3+� F+� egi� m� o:Ҷ tv� z� }6� N+� �+Զ 3� ����� $:� �� :� +� �W� ��� +� �W� �� �� � ��� :+� e� ��+� e� �� :+� a�+� a+ֶ 3++� �*� P2� � � �� �ظ �� � � +ȶ 3+�� 9+ȶ 3� +ܶ 3+� F+� egi� m� o:޶ tv� z� }6� N+� �+� 3� ����� $:� �� :� +� �W� ��� +� �W� �� �� � ��� :+� e� ��+� e� �� :+� a�+� a+ֶ 3++� �*� P2� � � �� �ظ �� � � +ȶ 3+�� 9+ȶ 3� +ֶ 3+� F+� egi� m� o:� tv� z� }6� N+� �+� 3� ����� $:� �� :� +� �W� ��� +� �W� �� �� � ��� :+� e� ��+� e� �� : +� a �+� a+� 3++� �*� P2� � � �� �ظ �� � � +� 3+�� 9+ȶ 3� +� 3+�� 9+� 3+�� 9+� 3+�� 9+� 3+�� 9+� 3+�� 9+�� 3+�� 9+ � 3+� F+� 3++� �*� P2� � \� 3+� 3++� �*� P2� � \� 3+� 3+� L*� P2� V 	� �� � � ++� 3++� L*� P2� V � \� 3+� 3� T+� L*� P2� V � �� � � ++� 3++� L*� P2� V � \� 3+� 3� 
+� 3+� 3++� �*� P2� � \� 3+� 3++� �*� P	2� � \� 3+� 3+� L*� P2� V � �� � �:+ֶ 3+� L*� P
2� V � �� � � I+� 3++� L*� P
2� V � \� 3+� 3++� L*� P2� V � \� 3+!� 3� �+� L*� P
2� V #� �� � � I+%� 3++� L*� P
2� V � \� 3+'� 3++� L*� P2� V � \� 3+� 3� [+� L*� P
2� V )� �� � � ++� 3� /+� L*� P
2� V -� �� � � +/� 3� +ֶ 3� /+� L*� P2� V 	� �� � � +1� 3� +3� 3+� �*� P2� �� �� � � +5� 3� 
+7� 3+9� 3++� �*� P2� � \� 3+;� 3� :!+� a!�+� a+=� 3+� F+?� 3++� �*� P2� � \� 3+A� 3++� �*� P2� � \� 3+C� 3� :"+� a"�+� a+E� 3+� F+?� 3++� �*� P2� � \� 3+A� 3++� �*� P2� � \� 3+C� 3� :#+� a#�+� a+G� 3+� F+?� 3++� �*� P2� � \� 3+A� 3++� �*� P2� � \� 3+C� 3� :$+� a$�+� a+I� 3+� F+?� 3++� �*� P2� � \� 3+A� 3++� �*� P2� � \� 3+C� 3� :%+� a%�+� a+K� 3+M� 9+O� 3�  1 V V   � � � ) � � �   { � �   k  ��� )���  �  y  o~� )o��  L��  ;��  kz} )k��  H��  7��  gvy )g��  D��  3��  ~��  ���  �	@	@  	X	�	�  	�	�	�   �         * +  �  � j           9  : * < - C 4 D a H d J g c � e g> iA jK kX le mr ou p� r+ t1 u4 x7 yr {� }  �' �- �0 �n �� � � �# �) �, �j �� � � � �% �( �+ �5 �B �O �\ �i �l �w �z �� �� �� �� �
 �0 �Q �X �[ �_ �� �� �� �� �. �T �� �� �� �� �� �� � �# �'ORY\`	���6�7�8�:�?�@	:A	QC	TH	\I	�J	�L	�R	�S	�T
V
y
{�     ) PQ �        �    �     ) RS �         �    �     ) TU �        �    �    W    �   �     �*�bYd�jSYl�jSYn�jSYp�jSYr�jSYt�jSYv�jSYx�jSYz�jSY	|�jSY
~�jSY��jSY��jSY��jSY��jSY��jSY��jSY��jSY��jSY��jSY��jSY��jS� P�     �    