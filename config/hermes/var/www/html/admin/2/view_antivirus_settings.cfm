<!DOCTYPE html>

 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->


<html lang="en">


  <head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Antivirus Settings</title>

  <cfinclude template="./inc/html_head.cfm" />
<!--- Sort Table Script Default Sort by Column 4 Desc --->


<!--- Sort Table Script  --->
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
  
  </script>


  

<!--- STYLE FOR EYE-SLASH STARTS HERE --->    
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
<!--- STYLE FOR EYE-SLASH ENDS HERE --->  

<!--- TEXT AREA STYLE ---> 
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

<!--- BACK TO TOP BUTTON STYLE ---> 
<style>
#btn-back-to-top {
  position: fixed;
  bottom: 20px;
  right: 20px;
  display: none;
}
</style>

</head>



<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">



  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <!-- Content Wrapper. Contains page content -->
  <main class="app-main">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <cfoutput>
            <h1 class="m-0">Antivirus Settings</h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
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


  <cfparam name = "m" default = "0">
  <cfif StructKeyExists(session, "m")>
  <cfif session.m is not "">
  <cfset m = session.m>

  <!--- ENABLE FOR DEBUG BELOW --->

  <!---
  <cfoutput>M: #session.m#</cfoutput>
  --->

  <!--- /CFIF for session.m is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.m --->
  </cfif>

  <!---
  <cfoutput>session M: #m#</cfoutput>
  --->


  <cfquery name="getavwhitelist" datasource="hermes">
    select id, parameter, module from parameters2 where module = 'clamav-bypass'
    </cfquery>

  <cfparam name = "errormessage" default = "0">
  <cfif StructKeyExists(session, "errormessage")>
    <cfif session.errormessage is not "">
    <cfset errormessage = session.errormessage>

<!--- ENABLE FOR DEBUG BELOW --->

  <!---
  <cfoutput>M: #session.errormessage#</cfoutput>
  --->

    <!--- /CFIF for session.errormessage is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.errormessage --->
  </cfif>


<cfparam name = "invalid" default = "0">

<cfif StructKeyExists(session, "invalid")>
  <cfif session.invalid is not "">
  <cfset invalid = session.invalid>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.invalid#</cfoutput>
--->


    <!--- /CFIF for session.invalid is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.invalid --->
  </cfif>


<cfparam name = "invalid_entry" default = "">

<cfif StructKeyExists(session, "invalid_entry")>
  <cfif session.invalid_entry is not "">
  <cfset invalid_entry = session.invalid_entry>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.invalid_entry#</cfoutput>
--->

    <!--- /CFIF for session.invalid_entry is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.invalid_entry --->
  </cfif>



<cfparam name = "exists" default = "0">

<cfif StructKeyExists(session, "exists")>
  <cfif session.exists is not "">
  <cfset exists = session.exists>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.exists#</cfoutput>
--->


    <!--- /CFIF for session.exists is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.exists --->
  </cfif>


<cfparam name = "exists_entry" default = "">

<cfif StructKeyExists(session, "exists_entry")>
  <cfif session.exists_entry is not "">
  <cfset exists_entry = session.exists_entry>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.exists#</cfoutput>
--->

    <!--- /CFIF for session.exists_entry is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.exists_entry --->
  </cfif>

<cfparam name = "success" default = "0">

<cfif StructKeyExists(session, "success")>
  <cfif session.success is not "">
  <cfset success = session.success>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.success#</cfoutput>
--->


    <!--- /CFIF for session.success is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.success --->
  </cfif>

<cfparam name = "success_entry" default = "">

<cfif StructKeyExists(session, "success_entry")>
  <cfif session.success_entry is not "">
  <cfset success_entry = session.success_entry>

<!--- ENABLE FOR DEBUG BELOW --->

<!---
<cfoutput>M: #session.success_entry#</cfoutput>
--->


    <!--- /CFIF for session.success_entry is not "" --->
  </cfif>

  <!--- /CFIF for StructKeyExists session.success_entry --->
  </cfif>
  
    <cfparam name = "step" default = "0">
    
    <cfparam name = "action" default = ""> 
    <cfif IsDefined("form.action") is "True">
    <cfif form.action is not "">
    <cfset action = form.action>
    </cfif></cfif>  


    <cfinclude template="./inc/get_antivirus_settings.cfm" />  
   

      <cfif #m# is "9">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>Antivirus Settings were saved successfully </cfoutput><br> 
        </div>

              
        <cfset session.m = 0>
      
      </cfif>

      
      <cfif #m# is "11">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>You must select entries before clicking the <strong>Delete</strong> button</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "12">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>Entries were deleted successfully </cfoutput><br> 
        </div>

              
        <cfset session.m = 0>
      
      </cfif>


      <cfif #m# is "13">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Whitelist Entry field cannot be empty</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>

      <cfif #m# is "14">

        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-ban"></i> Oops!</h4>
          <cfoutput>The Entry field in the entry you are attempting to edit already exists</cfoutput>
        </div>
      
        <cfset session.m = 0>
      
      </cfif>


      <cfif #success# GTE "1">
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
          <h4><i class="icon fa fa-check"></i> Success!</h4>
          <cfoutput>The following #success# entries were added successfully:</cfoutput><br>
          <cfoutput>#success_entry#</cfoutput>
        </div>

        <cfset session.success = 0>
        <cfset session.success_entry = "">

      </cfif>
       
      
     
      
      
      
      
      <cfif #invalid# is not "0">
      
          <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
            <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
            <cfoutput>The following #invalid# entries were invalid:</cfoutput><br>
            <cfoutput>#invalid_entry#</cfoutput>
          </div>

          <cfset session.invalid = 0>
          <cfset session.invalid_entry = "">
      
      </cfif>
      
      <cfif #exists# is not "0">
      
        <div class="alert alert-danger alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
          <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
          <cfoutput>The following #exists# entries already exist:</cfoutput><br>
          <cfoutput>#exists_entry#</cfoutput>
        </div>

        <cfset session.exists = 0>
        <cfset session.exists_entry = "">
      
      </cfif>


      



<!--- ERROR MESSAGES END HERE --->

<cfif #session.license# is "VALID">   
  <span>
    <p>  


 

<!--- ADD AV WHITELIST BUTTON STARTS HERE --->
<cfoutput>
  <a href="##addwhitelist_modal"  class="btn btn-primary" role="button" data-bs-toggle="modal" ><i class="fa fa-plus-square fa-lg"></i>&nbsp;&nbsp;Add AV Signature Whitelist Entries</a>
  </cfoutput>
<!--- ADD AV WHITELIST BUTTON STARTS HERE --->
&nbsp;&nbsp;

<!--- DELETE AV WHITELIST BUTTON STARTS HERE --->

<button type="button" id="deletewhitelists" class="btn btn-danger"><i class="fas fa-trash-alt"></i>&nbsp;&nbsp;Delete AV Signature Whitelist Entries</button>
<!--- DELETE ADD AV WHITELIST BUTTON STARTS HERE --->

<!--- /CFIF #session.license# is "VALID" --->


</p>
</span>

</cfif>

<div class="card col-sm-8">
          
  <div class="form-group" id="avsettings">

    <div class="col-sm-8">


      <form name="avsettings" method="post">

        <input type="hidden" name="action" value="AV Settings">

      <label><strong>Scan E-mail Attachments</strong></label>
        
      <select class="form-control" name="ScanMail" style="width: 100%;" id="ScanMail">

<cfif #ScanMail# is "true">
  
          <option value="true" selected>Enabled (Recommended)</option>
          <option value="false">Disabled</option>
   

      <cfelseif #ScanMail# is "false">

        <option value="false" selected>Disabled</option>
        <option value="true">Enabled (Recommended)</option>

     

        <!--- /CFIF cfif #ScanMail# is --->
      </cfif>
     
          </select>   

          <label><strong>Scan Archives</strong></label>
        
          <select class="form-control" name="ScanArchive" style="width: 100%;" id="ScanArchive">
    
    <cfif #ScanArchive# is "true">
      
              <option value="true" selected>Enabled (Recommended)</option>
              <option value="false">Disabled</option>
       
    
          <cfelseif #ScanArchive# is "false">
    
            <option value="false" selected>Disabled</option>
            <option value="true">Enabled (Recommended)</option>
    
         
    
            <!--- /CFIF cfif #ScanArchive# is --->
          </cfif>
         
              </select>   

              <label><strong>Mark Encrypted Archives as Viruses</strong></label>
        
              <select class="form-control" name="ArchiveBlockEncrypted" style="width: 100%;" id="ArchiveBlockEncrypted">
        
        <cfif #ArchiveBlockEncrypted# is "true">
          
                  <option value="true" selected>Enabled</option>
                  <option value="false">Disabled (Recommended)</option>
           
        
              <cfelseif #ArchiveBlockEncrypted# is "false">
        
                <option value="false" selected>Disabled (Recommended)</option>
                <option value="true">Enabled</option>
        
             
        
                <!--- /CFIF cfif #ArchiveBlockEncrypted# is --->
              </cfif>
             
                  </select>   

                  <label><strong>Scan Portable Executables Files</strong> (Windows Executable File Format)</label>
        
                  <select class="form-control" name="ScanPE" style="width: 100%;" id="ScanPE">
            
            <cfif #ScanPE# is "true">
              
                      <option value="true" selected>Enabled (Recommended)</option>
                      <option value="false">Disabled</option>
               
            
                  <cfelseif #ScanPE# is "false">
            
                    <option value="false" selected>Disabled</option>
                    <option value="true">Enabled (Recommended)</option>
            
                 
            
                    <!--- /CFIF cfif #ScanPE# is --->
                  </cfif>
                 
                      </select>   
  
                      <label><strong>Scan OLE2 Files</strong> (MS Office and Windows .msi Files)</label>
        
                      <select class="form-control" name="ScanOLE2" style="width: 100%;" id="ScanOLE2">
                
                <cfif #ScanOLE2# is "true">
                  
                          <option value="true" selected>Enabled (Recommended)</option>
                          <option value="false">Disabled</option>
                   
                
                      <cfelseif #ScanOLE2# is "false">
                
                        <option value="false" selected>Disabled</option>
                        <option value="true">Enabled (Recommended)</option>
                
                     
                
                        <!--- /CFIF cfif #ScanOLE2# is --->
                      </cfif>
                     
                          </select>   

  
                          <label><strong>Block OLE2 Macros</strong> (MS Office Files with VBA Macros)</label>

                          <div class="alert alert-warning">
             
                            <p><i class="icon fas fa-exclamation-triangle"></i>This setting will bypass scanning and simply block all OLE2 files with VBA Macros in them whether malicious or not. In effect, it will treat any VBA macros as a virus. This setting has no effect if <strong>Scan OLE2 Macros</strong> is <strong>Disabled.</strong> It's recommended that you set this setting to <strong>Disabled.</strong></p>
                            </div>
                          
        
                          <select class="form-control" name="OLE2BlockMacros" style="width: 100%;" id="OLE2BlockMacros">
                    
                    <cfif #OLE2BlockMacros# is "true">
                      
                              <option value="true" selected>Enabled</option>
                              <option value="false">Disabled (Recommended)</option>
                       
                    
                          <cfelseif #OLE2BlockMacros# is "false">
                    
                            <option value="false" selected>Disabled (Recommended)</option>
                            <option value="true">Enabled</option>
                    
                         
                    
                            <!--- /CFIF cfif #OLE2BlockMacros# is --->
                          </cfif>
                         
                              </select>   

                              <label><strong>Scan PDF Files</strong></label>
        
                              <select class="form-control" name="ScanPDF" style="width: 100%;" id="ScanPDF">
                        
                        <cfif #ScanPDF# is "true">
                          
                                  <option value="true" selected>Enabled (Recommended)</option>
                                  <option value="false">Disabled</option>
                           
                        
                              <cfelseif #ScanPDF# is "false">
                        
                                <option value="false" selected>Disabled</option>
                                <option value="true">Enabled (Recommended)</option>
                        
                             
                        
                                <!--- /CFIF cfif #ScanPDF# is --->
                              </cfif>
                             
                                  </select>  
                                  

                                  <label><strong>Perform HTML/Javascript/ScriptEncoder Normalization and Decryption</strong></label>
        
                                  <select class="form-control" name="ScanHTML" style="width: 100%;" id="ScanHTML">
                            
                            <cfif #ScanHTML# is "true">
                              
                                      <option value="true" selected>Enabled (Recommended)</option>
                                      <option value="false">Disabled</option>
                               
                            
                                  <cfelseif #ScanHTML# is "false">
                            
                                    <option value="false" selected>Disabled</option>
                                    <option value="true">Enabled (Recommended)</option>
                            
                                 
                            
                                    <!--- /CFIF cfif #ScanHTML# is --->
                                  </cfif>
                                 
                                      </select>  

                                  <label><strong>Algorithmic Detection</strong> (Detects complex malware, graphic files exploits and others)</label>
        
                                  <select class="form-control" name="AlgorithmicDetection" style="width: 100%;" id="AlgorithmicDetection">
                            
                            <cfif #AlgorithmicDetection# is "true">
                              
                                      <option value="true" selected>Enabled (Recommended)</option>
                                      <option value="false">Disabled</option>
                               
                            
                                  <cfelseif #AlgorithmicDetection# is "false">
                            
                                    <option value="false" selected>Disabled</option>
                                    <option value="true">Enabled (Recommended)</option>
                            
                                 
                            
                                    <!--- /CFIF cfif #AlgorithmicDetection# is --->
                                  </cfif>
                                 
                                      </select>   


                                      <label><strong>Scan ELF Files</strong> (UN*X Executables)</label>
        
                                      <select class="form-control" name="ScanELF" style="width: 100%;" id="ScanELF">
                                
                                <cfif #ScanELF# is "true">
                                  
                                          <option value="true" selected>Enabled (Recommended)</option>
                                          <option value="false">Disabled</option>
                                   
                                
                                      <cfelseif #ScanELF# is "false">
                                
                                        <option value="false" selected>Disabled</option>
                                        <option value="true">Enabled (Recommended)</option>
                                
                                     
                                
                                        <!--- /CFIF cfif #ScanELF# is --->
                                      </cfif>
                                     
                                          </select>   

                                          <label><strong>Signature Based Detection of Phishing</strong> </label>
        
                                          <select class="form-control" name="PhishingSignatures" style="width: 100%;" id="PhishingSignatures">
                                    
                                    <cfif #PhishingSignatures# is "true">
                                      
                                              <option value="true" selected>Enabled (Recommended)</option>
                                              <option value="false">Disabled</option>
                                       
                                    
                                          <cfelseif #PhishingScanURLs# is "false">
                                    
                                            <option value="false" selected>Disabled</option>
                                            <option value="true">Enabled (Recommended)</option>
                                    
                                         
                                    
                                            <!--- /CFIF cfif #PhishingScanURLs# is --->
                                          </cfif>
                                         
                                              </select>   


                                              <label><strong>Scan E-mail URLs for Phishing</strong> </label>
        
                                              <select class="form-control" name="PhishingScanURLs" style="width: 100%;" id="PhishingScanURLs">
                                        
                                        <cfif #PhishingScanURLs# is "true">
                                          
                                                  <option value="true" selected>Enabled (Recommended)</option>
                                                  <option value="false">Disabled</option>
                                           
                                        
                                              <cfelseif #PhishingScanURLs# is "false">
                                        
                                                <option value="false" selected>Disabled</option>
                                                <option value="true">Enabled (Recommended)</option>
                                        
                                             
                                        
                                                <!--- /CFIF cfif #PhishingScanURLs# is --->
                                              </cfif>
                                             
                                                  </select>   

                                                  <label><strong>Block SSL Mismatches in E-mail URLs</strong> </label>

                                                  <div class="alert alert-warning">
             
                                                    <p><i class="icon fas fa-exclamation-triangle"></i> Enabling can lead to false positivies.</p>
                                                    </div>
        
                                                  <select class="form-control" name="PhishingAlwaysBlockSSLMismatch" style="width: 100%;" id="PhishingAlwaysBlockSSLMismatch">
                                            
                                            <cfif #PhishingAlwaysBlockSSLMismatch# is "true">
                                              
                                                      <option value="true" selected>Enabled</option>
                                                      <option value="false">Disabled (Recommended)</option>
                                               
                                            
                                                  <cfelseif #PhishingAlwaysBlockSSLMismatch# is "false">
                                            
                                                    <option value="false" selected>Disabled (Recommended)</option>
                                                    <option value="true">Enabled</option>
                                            
                                                 
                                            
                                                    <!--- /CFIF cfif #PhishingAlwaysBlockSSLMismatch# is --->
                                                  </cfif>
                                                 
                                                      </select>  

                                                      <label><strong>Block Cloaked E-mail URLs</strong> </label>

                                                      <div class="alert alert-warning">
                 
                                                        <p><i class="icon fas fa-exclamation-triangle"></i> Enabling can lead to false positivies.</p>
                                                        </div>
            
                                                      <select class="form-control" name="PhishingAlwaysBlockCloak" style="width: 100%;" id="PhishingAlwaysBlockCloak">
                                                
                                                <cfif #PhishingAlwaysBlockCloak# is "true">
                                                  
                                                          <option value="true" selected>Enabled</option>
                                                          <option value="false">Disabled (Recommended)</option>
                                                   
                                                
                                                      <cfelseif #PhishingAlwaysBlockCloak# is "false">
                                                
                                                        <option value="false" selected>Disabled (Recommended)</option>
                                                        <option value="true">Enabled</option>
                                                
                                                     
                                                
                                                        <!--- /CFIF cfif #PhishingAlwaysBlockCloak# is --->
                                                      </cfif>
                                                     
                                                          </select> 


                                                          <label><strong>Detect Possibly Unwanted Applications (PUA)</strong> </label>

                                    
                
                                                          <select class="form-control" name="DetectPUA" style="width: 100%;" id="DetectPUA">
                                                    
                                                    <cfif #DetectPUA# is "true">
                                                      
                                                              <option value="true" selected>Enabled (Recommended)</option>
                                                              <option value="false">Disabled</option>
                                                       
                                                    
                                                          <cfelseif #DetectPUA# is "false">
                                                    
                                                            <option value="false" selected>Disabled</option>
                                                            <option value="true">Enabled (Recommended)</option>
                                                    
                                                         
                                                    
                                                            <!--- /CFIF cfif #DetectPUA# is --->
                                                          </cfif>
                                                         
                                                              </select> 
    


                                                              <label><strong>Heuristic Scan Precedence</strong> </label>

                                                              <div class="alert alert-warning">
                 
                                                                <p><i class="icon fas fa-exclamation-triangle"></i> Allow heuristic match to take precedence. When enabled, if a heuristic scan (such as phishingScan) detects a possible virus/phishing it will  stop  scanning  immediately.
                                                                  Recommended to be Enabled because it saves  CPU  scan-time.  When  disabled, virus/phishing detected by heuristic scans will be reported only at the end of a scan. If an archive contains both a
                                                                  heuristically detected virus/phishing, and a real malware, the real malware will be reported. Keep this disabled if you intend to handle "*.Heuristics.*" viruses  differ‐
                                                                  ently from "real" malware. If a non-heuristically-detected virus (signature-based) is found first, the scan is interrupted immediately, regardless of this config option.</p>
                                                                </div>
                
                                                              <select class="form-control" name="HeuristicScanPrecedence" style="width: 100%;" id="HeuristicScanPrecedence">
                                                        
                                                        <cfif #HeuristicScanPrecedence# is "true">
                                                          
                                                                  <option value="true" selected>Enabled (Recommended)</option>
                                                                  <option value="false">Disabled</option>
                                                           
                                                        
                                                              <cfelseif #HeuristicScanPrecedence# is "false">
                                                        
                                                                <option value="false" selected>Disabled</option>
                                                                <option value="true">Enabled (Recommended)</option>
                                                        
                                                             
                                                        
                                                                <!--- /CFIF cfif #HeuristicScanPrecedence# is --->
                                                              </cfif>
                                                             
                                                                  </select> 
<!---  class="col-sm-6" --->
</div>

    <!--- class="form-group" class="form-group" id="avsettings"  --->  
      </div>
       

  
          

  
  
  <div class="col-sm-6">
  
  <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  <!--- div class="col-sm-6" --->
  </div>
    
  </form>  
  
<br>

  <!--- div class="card"  --->  
</div>


<cfif #session.license# is "VALID">   

<!--- DELETE ENTRY MODAL HTML STARTS HERE --->
   
<div class="modal fade" id="delete_modal" tabindex="-1" role="dialog" aria-labelledby="deleteCertificateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-danger">
  <!---
  <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
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
  <button type="button" class="btn btn-primary" data-bs-dismiss="modal">No</button>
</div>
    </div>
  </div>
</div>
<!--- DELETE ENTRY MODAL HTML ENDS HERE --->

<!--- /CFIF #session.license# is "VALID" --->
</cfif>


<cfif #session.license# is "VALID">   
<!--- ADD AV SIGNATURE WHITELIST MODAL HTML STARTS HERE --->

<div class="modal fade" id="addwhitelist_modal" tabindex="-1" role="dialog" aria-labelledby="AddWhitelistModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
<div class="modal-header alert-primary">
  <!---
  <button type="button" class="btn-close" data-bs-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
  --->
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

            
<!---
            <cfoutput>
              <div class="form-group">
                <label><strong>Note</strong></label>
                <input type="text" class="form-control" name="note" value="" id="note" placeholder="Enter Note" maxLength="255">
              </div>
              </cfoutput>
            --->

    <div>&nbsp;</div>

    <input type="submit" value="Submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  </form>

</div>


<div class="modal-footer">
 
<button type="button" class="btn btn-danger" data-bs-dismiss="modal">Cancel</button>

</div>
    </div>
  </div>
</div>
<!--- ADD AV WHITELIST MODAL HTML ENDS HERE --->

  <!--- /CFIF #session.license# is "VALID" --->
</cfif>

         

<cfif #action# is "AV Settings">

  <cfif NOT StructKeyExists(form, "ScanMail")>

    <cfset m="Antivirus Settings: form.ScanMail does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "ScanMail")>

      <cfif #form.ScanMail# is "true" OR #form.ScanMail# is "false">      

        <cfset step=1>
          
          <cfelse>
          
      
            <cfset m="Antivirus Settings: form.ScanMail is not true or false">
            <cfinclude template="./inc/error.cfm">
            <cfabort>

  <!--- /CFIF #form.ScanMail# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "ScanMail") --->
</cfif>



<cfif #step# is "1">

  <cfif NOT StructKeyExists(form, "ScanArchive")>

    <cfset m="Antivirus Settings: form.ScanArchive does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>



<cfelseif StructKeyExists(form, "ScanArchive")>
      

<cfif #form.ScanArchive# is "true" OR #form.ScanArchive# is "false">      

  <cfset step=2>
    
    <cfelse>
    

      <cfset m="Antivirus Settings: form.ScanArchive is not true or false">
      <cfinclude template="./inc/error.cfm">
      <cfabort>


<!--- /CFIF #form.ScanArchive# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "ScanArchive") --->
</cfif>


<!--- /CFIF #step# is "1" --->  
</cfif>



<cfif #step# is "2">

  <cfif NOT StructKeyExists(form, "ArchiveBlockEncrypted")>

    <cfset m="Antivirus Settings: form.ArchiveBlockEncrypted does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>



    <cfelseif StructKeyExists(form, "ArchiveBlockEncrypted")>


<cfif #form.ArchiveBlockEncrypted# is "true" OR #form.ArchiveBlockEncrypted# is "false">      

  <cfset step=3>
    
    <cfelse>
    

      <cfset m="Antivirus Settings: form.ArchiveBlockEncrypted is not true or false">
      <cfinclude template="./inc/error.cfm">
      <cfabort>

<!--- /CFIF #form.ArchiveBlockEncrypted# is "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "ArchiveBlockEncrypted") --->
</cfif>


<!--- /CFIF #step# is "2" --->  
</cfif>



<cfif #step# is "3">

  <cfif NOT StructKeyExists(form, "ScanPE")>

    <cfset m="Antivirus Settings: form.ScanPE does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "ScanPE")>


      <cfif #form.ScanPE# is "true" OR #form.ScanPE# is "false">       

  <cfset step=4>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.ScanPE is not true or false">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.ScanPE# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "ScanPE") --->
</cfif>

<!--- /CFIF #step# is "3" --->  
</cfif>


<cfif #step# is "4">

  <cfif NOT StructKeyExists(form, "ScanOLE2")>

    <cfset m="Antivirus Settings: form.ScanOLE2 does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "ScanOLE2")>


      <cfif #form.ScanOLE2# is "true" OR #form.ScanOLE2# is "false">        

  <cfset step=5>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.ScanOLE2 is not true or false">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.ScanOLE2# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "ScanOLE2") --->
</cfif>

<!--- /CFIF #step# is "4" --->  
</cfif>


<cfif #step# is "5">

  <cfif NOT StructKeyExists(form, "OLE2BlockMacros")>

    <cfset m="Antivirus Settings: form.OLE2BlockMacros does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "OLE2BlockMacros")>


<cfif #form.OLE2BlockMacros# is "False" OR #form.OLE2BlockMacros# is "True">      

  <cfset step=6>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.OLE2BlockMacros is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.OLE2BlockMacros# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "OLE2BlockMacros") --->
</cfif>

<!--- /CFIF #step# is "5" --->  
</cfif>


<cfif #step# is "6">

  <cfif NOT StructKeyExists(form, "ScanPDF")>

    <cfset m="Antivirus Settings: form.ScanPDF does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "ScanPDF")>


<cfif #form.ScanPDF# is "False" OR #form.ScanPDF# is "True">      

  <cfset step=7>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.ScanPDF is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.ScanPDF# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "ScanPDF") --->
</cfif>

<!--- /CFIF #step# is "6" --->  
</cfif>


<cfif #step# is "7">

  <cfif NOT StructKeyExists(form, "ScanHTML")>

    <cfset m="Antivirus Settings: form.ScanHTML does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "ScanHTML")>


<cfif #form.ScanHTML# is "False" OR #form.ScanHTML# is "True">      

  <cfset step=8>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.ScanHTML is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.ScanHTML# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "ScanHTML") --->
</cfif>

<!--- /CFIF #step# is "7" --->  
</cfif>



<cfif #step# is "8">

  <cfif NOT StructKeyExists(form, "AlgorithmicDetection")>

    <cfset m="Antivirus Settings: form.AlgorithmicDetection does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "AlgorithmicDetection")>


<cfif #form.AlgorithmicDetection# is "False" OR #form.AlgorithmicDetection# is "True">      

  <cfset step=9>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.AlgorithmicDetection is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.AlgorithmicDetection# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "AlgorithmicDetection") --->
</cfif>

<!--- /CFIF #step# is "8" --->  
</cfif>



<cfif #step# is "9">

  <cfif NOT StructKeyExists(form, "ScanELF")>

    <cfset m="Antivirus Settings: form.ScanELF does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "ScanELF")>


<cfif #form.ScanELF# is "False" OR #form.ScanELF# is "True">      

  <cfset step=10>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.ScanELF is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.ScanELF# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "ScanELF") --->
</cfif>

<!--- /CFIF #step# is "9" --->  
</cfif>


<cfif #step# is "10">

  <cfif NOT StructKeyExists(form, "PhishingSignatures")>

    <cfset m="Antivirus Settings: form.PhishingSignatures does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "PhishingSignatures")>


<cfif #form.PhishingSignatures# is "False" OR #form.PhishingSignatures# is "True">      

  <cfset step=11>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.PhishingSignatures is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.PhishingSignatures# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "PhishingSignatures") --->
</cfif>

<!--- /CFIF #step# is "10" --->  
</cfif>



<cfif #step# is "11">

  <cfif NOT StructKeyExists(form, "PhishingScanURLs")>

    <cfset m="Antivirus Settings: form.PhishingScanURLs does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "PhishingScanURLs")>


<cfif #form.PhishingScanURLs# is "False" OR #form.PhishingScanURLs# is "True">      

  <cfset step=12>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.PhishingScanURLs is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.PhishingScanURLs# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "PhishingScanURLs") --->
</cfif>

<!--- /CFIF #step# is "11" --->  
</cfif>


<cfif #step# is "12">

  <cfif NOT StructKeyExists(form, "PhishingAlwaysBlockSSLMismatch")>

    <cfset m="Antivirus Settings: form.PhishingAlwaysBlockSSLMismatch does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "PhishingAlwaysBlockSSLMismatch")>


<cfif #form.PhishingAlwaysBlockSSLMismatch# is "False" OR #form.PhishingAlwaysBlockSSLMismatch# is "True">      

  <cfset step=13>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.PhishingAlwaysBlockSSLMismatch is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.PhishingAlwaysBlockSSLMismatch# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "PhishingAlwaysBlockSSLMismatch") --->
</cfif>

<!--- /CFIF #step# is "12" --->  
</cfif>



<cfif #step# is "13">

  <cfif NOT StructKeyExists(form, "PhishingAlwaysBlockCloak")>

    <cfset m="Antivirus Settings: form.PhishingAlwaysBlockCloak does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "PhishingAlwaysBlockCloak")>


<cfif #form.PhishingAlwaysBlockCloak# is "False" OR #form.PhishingAlwaysBlockCloak# is "True">      

  <cfset step=14>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.PhishingAlwaysBlockCloak is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.PhishingAlwaysBlockCloak# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "PhishingAlwaysBlockCloak") --->
</cfif>

<!--- /CFIF #step# is "13" --->  
</cfif>


<cfif #step# is "14">

  <cfif NOT StructKeyExists(form, "DetectPUA")>

    <cfset m="Antivirus Settings: form.DetectPUA does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "DetectPUA")>


<cfif #form.DetectPUA# is "False" OR #form.DetectPUA# is "True">      

  <cfset step=15>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.DetectPUA is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.DetectPUA# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "DetectPUA") --->
</cfif>

<!--- /CFIF #step# is "14" --->  
</cfif>



<cfif #step# is "15">

  <cfif NOT StructKeyExists(form, "HeuristicScanPrecedence")>

    <cfset m="Antivirus Settings: form.HeuristicScanPrecedence does not exist">
    <cfinclude template="./inc/error.cfm">
    <cfabort>


    <cfelseif StructKeyExists(form, "HeuristicScanPrecedence")>


<cfif #form.HeuristicScanPrecedence# is "False" OR #form.HeuristicScanPrecedence# is "True">      

  <cfset step=16>

    
    <cfelse>  

      <cfset m="Antivirus Settings: form.HeuristicScanPrecedence is not True or False">
      <cfinclude template="./inc/error.cfm">
      <cfabort>



<!--- /CFIF #form.HeuristicScanPrecedence# is "" --->
</cfif>

<!--- /CFIF NOT/StructKeyExists(form, "HeuristicScanPrecedence") --->
</cfif>

<!--- /CFIF #step# is "15" --->  
</cfif>


<cfif #step# is "16">


<cfinclude template="./inc/antivirus_set_settings.cfm">

<cfinclude template="./inc/generate_antivirus_configuration.cfm">

<cfset session.m=9>

<cflocation url="view_antivirus_settings.cfm" addtoken="no">


<!--- /CFIF #step# is "16" --->
</cfif>


<cfelseif #action# is "Delete Entry">


  <cfif NOT StructKeyExists(form, "delete_id")>

    <cfset session.m = 11>

  <cflocation url="view_antivirus_settings.cfm" addtoken="no">


    <cfelseif StructKeyExists(form, "delete_id")>

    <cfif #form.delete_id# is "">

      <cfset session.m = 11>

    <cflocation url="view_antivirus_settings.cfm" addtoken="no">
        

    <cfelseif #form.delete_id# is not "">      

<cfloop index="i" list="#form.delete_id#" delimiters=",">

  <cfoutput>#i#<br></cfoutput>

  <cfquery name="getentry" datasource="hermes">
  select id from parameters2 where id = <cfqueryparam value = #i# CFSQLType = "CF_SQL_INTEGER">
  </cfquery>


  <cfif #getentry.recordcount# GTE 1>

    <cfset delete_id = #i#>

    <cfinclude template="./inc/antivirus_delete_entry.cfm">
  

    <!--- /CFIF #getentry.recordcount# --->
  </cfif>

  
  </cfloop>


  <cfset session.m = 12>

  <cfinclude template="./inc/generate_antivirus_configuration.cfm">
  
  <cflocation url="view_antivirus_settings.cfm" addtoken="no">  


<!--- /CFIF #form.delete_id# is/is not "" --->
</cfif>


<!--- /CFIF NOT/StructKeyExists(form, "delete_id") --->
</cfif>


<cfelseif #action# is "Add AV Whitelist">



      <cfif NOT StructKeyExists(form, "whitelist")>
      
      
        <cfset m="Antivirus Settings Add Whitelist Entries: form.whitelist does not exist">
        <cfinclude template="./inc/error.cfm">
        <cfabort>
         
      
      <cfelseif StructKeyExists(form, "whitelist")>

        <cfif #form.whitelist# is not "">
      
      <cfinclude template="./inc/antivirus_add_whitelists.cfm">

        <cfelseif #form.whitelist# is "">

          
    <cfset session.m = 13>

    <cflocation url="view_antivirus_settings.cfm" addtoken="no">
      
    <!--- #form.whitelist# is not "" --->
    </cfif>
      
      <!--- /CFIF StructKeyExists(form, "whitelist") --->
      </cfif>
  
 
<cfinclude template="./inc/generate_antivirus_configuration.cfm">

<cflocation url="view_antivirus_settings.cfm" addtoken="no">

    
<!--- /CFIF #action# is --->     
</cfif> 


<cfif #session.license# is "VALID">   

<form>

    <cfif #getavwhitelist.recordcount# GTE 1>

    
                
      <table class="table table-striped"  id="sortTable" style="width:100%">
        <thead>
          <tr>
            <th><input type="checkbox" id="selectAll" value="selectAll"></th>
            <th>AV Signature Whitelist</th> 
          

          </tr>
        </thead>
        <tbody>

        

<cfoutput query="getavwhitelist">


  <td><input type="checkbox" name="id" value="#id#"></td>


<td>#parameter#</td>  

</tr>

</cfoutput>




    

        </tbody>
        
       
        <tfoot>
          <tr>
      
            <th></th>
            <th>AV Signature Whitelist</th>  
              


           
          </tr>
        </tfoot>
      

      </table>

    </form>
    
 
    
    <cfelse>
    
      <div class="alert alert-danger alert-dismissible">
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
        <h4><i class="icon fa fa-ban"></i> Oops!</h4>
        <cfoutput>No AV Signature Whitelist entries were found</strong></cfoutput>
      </div>
    
      <!--- /CFIF FOR getavwhitelist.recordcount --->
    </cfif>

  <!--- /CFIF FOR #session.license# is "VALID" --->
  </cfif>

    <div>&nbsp;</div>

    
    
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
</main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />

<!-- ./wrapper -->



</body>



  <!--- SCRIPT TO CHECK/UNCHECK ALL CHECKBOXES ON THE PAGE STARTS HERE --->
     <!--- THIS SCRIPT WILL NOT WORK IF PLACED IN THE <HEAD></HEAD> SECTION  --->
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
    <!--- SCRIPT TO CHECK/UNCHECK ALL CHECKBOXES ON THE PAGE ENDS HERE --->


<!--- BACK TO TOP BUTTON SCRIPT STARTS HERE  --->

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

</script>

<!--- BACK TO TOP BUTTON SCRIPT ENDS HERE  --->

</html>