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
  <title>Hermes SEG | Add Internal Recipient(s)</title>
  
  <cfinclude template="./inc/html_head.cfm" />

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
            <h1 class="m-0">Add Internal Recipient(s)
            </h1>
            <!---
            <h2 class="m-0">Group Member: #session.thegroups#</h2>
            --->
          </cfoutput>
            
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
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

<cfparam name = "step" default = "0"> 
<cfparam name = "errormessage" default = "0">
<cfparam name = "emptyrecipients" default = "0">
<cfparam name = "emptyemail" default = "0">
<cfparam name = "invalidemail" default = "0">
<cfparam name = "invalidemailrecipient" default = "">
<cfparam name = "alreadyexists" default = "0">
<cfparam name = "alreadyexistsrecipient" default = "">
<cfparam name = "invaliddomain" default = "0">
<cfparam name = "invaliddomainrecipient" default = "">
<cfparam name = "success" default = "0">
<cfparam name = "successrecipient" default = "">
<cfparam name = "djigzonotadded" default = "0">
<cfparam name = "djigzonotaddedrecipient" default = "">



<cfparam name = "m4" default = ""> 
<cfif IsDefined("url.m4") is "True">
<cfif url.m4 is not "">
<cfset m4 = url.m4>
</cfif>
</cfif>  

<cfparam name = "action" default = ""> 
<cfif StructKeyExists(url, "action")>
<cfif url.action is not "">
<cfset action = url.action>
</cfif>
</cfif> 

<cfparam name = "show_recipient" default = ""> 
<cfif StructKeyExists(form, "recipient")>
<cfif form.recipient is not "">
<cfset show_recipient = #LCase(FORM.recipient)#>
</cfif>
</cfif>

<!--- VALIDATE PARAMETERS BELOW --->

<!--- SHOW_POLICY --->
<cfparam name = "show_policy" default = ""> 

<cfif StructKeyExists(form, "policy")>

<cfif form.policy is not "">

<cfquery name="checkpolicy" datasource="hermes">
select id from policy where id = <cfqueryparam value = #form.policy# CFSQLType = "CF_SQL_INTEGER">
</cfquery>

<cfif #checkpolicy.recordcount# LT 1>

<cfset m="Add Internal Recipients: checkpolicy.recordcount LT 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelse>

<cfset show_policy = #form.policy#>

<!--- /CFIF #checkpolicy.recordcount# --->
</cfif>

<!--- /CFIF form.policy is not "" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "policy")--->
</cfif>

<!--- SHOW_REPORTS --->
<cfparam name = "show_reports" default = ""> 

<cfif StructKeyExists(form, "reports")>


<cfif #form.reports# is "YES" OR #form.reports# is "NO" OR #form.reports# is "ALL">

<cfset show_reports = #form.reports#>

<cfelse>

<cfset m="Add Internal Recipients: form.reports is not YES, NO or ALL">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- /CFIF #form.reports# is not "YES" OR #form.reports# is not "NO" OR #form.reports# is not "ALL" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "policy")--->
</cfif>

<!--- SHOW_FREQUENCY --->
<cfparam name = "show_frequency" default = ""> 
  
<cfif StructKeyExists(form, "frequency")>
  
<cfif NOT IsValid("integer", #form.frequency#)>

<cfset m="Add Internal Recipients: form.frequency is not integer">
<cfinclude template="./inc/error.cfm">
<cfabort>

<cfelse>

<cfset show_frequency = #form.frequency#>  
  
<!--- /CFIF NOT IsValid("integer", #form.frequency#) --->
</cfif>
  
<!--- /CFIF StructKeyExists(form, "frequency")--->
</cfif>


<!--- SHOW_TRAIN_BAYES --->
<cfparam name = "show_train_bayes" default = ""> 

<cfif StructKeyExists(form, "train_bayes")>

<cfif #form.train_bayes# is "0" OR #form.train_bayes# is "1">

<cfset show_train_bayes = #form.train_bayes#>

<cfelse>

<cfset m="Add Internal Recipients: form.train_bayes is not 0 or 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- #form.train_bayes# is not "0" OR #form.train_bayes# is not "1" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "train_bayes") --->
</cfif>

<!--- SHOW_DOWNLOAD_MSG --->
<cfparam name = "show_download_msg" default = ""> 

<cfif StructKeyExists(form, "download_msg")>

<cfif #form.download_msg# is "0" OR #form.download_msg# is "1">

<cfset show_download_msg = #form.download_msg#>

<cfelse>

<cfset m="Add Internal Recipients: form.download_msg is not 0 or 1">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- #form.download_msg# is not "0" OR #form.download_msg# is not "1" --->
</cfif>

<!--- /CFIF StructKeyExists(form, "download_msg") --->
</cfif>

<!--- SHOW_PDF_ENABLED --->
<cfparam name = "show_pdf_enabled" default = ""> 

<cfif StructKeyExists(form, "pdf_enabled")>

<cfif #form.pdf_enabled# is "1" OR #form.pdf_enabled# is "2">

  <cfset show_pdf_enabled = #form.pdf_enabled#>

<cfelse>

<cfset m="Add Internal Recipients: form.pdf_enabled is not 1 or 2">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- #form.pdf_enabled# is not "1" OR #form.pdf_enabled# is not "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "pdf_enabled") --->
</cfif>

<!--- SHOW_SMIME_ENABLED --->
<cfparam name = "show_smime_enabled" default = ""> 

<cfif StructKeyExists(form, "smime_enabled")>

<cfif #form.smime_enabled# is "1" OR #form.smime_enabled# is "2">

  <cfset show_smime_enabled = #form.smime_enabled#>

<cfelse>

<cfset m="Add Internal Recipients: form.smime_enabled is not 1 or 2">
<cfinclude template="./inc/error.cfm">
<cfabort>  

<!--- #form.smime_enabled# is not "1" OR #form.smime_enabled# is not "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "smime_enabled") --->
</cfif>

<!--- SHOW_SIGN --->
<cfparam name = "show_sign" default = ""> 

<cfif StructKeyExists(form, "sign")>

<cfif #form.sign# is "1" OR #form.sign# is "2">

  <cfset show_sign = #form.sign#>

<cfelse>

<cfset m="Add Internal Recipients: form.sign is not 1 or 2">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- #form.sign# is not "1" OR #form.sign# is not "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "sign") --->
</cfif>

<!--- SHOW_PGP_ENABLED --->
<cfparam name = "show_pgp_enabled" default = ""> 

<cfif StructKeyExists(form, "pgp_enabled")>

<cfif #form.pgp_enabled# is "1" OR #form.pgp_enabled# is "2">

<cfset show_pgp_enabled = #form.pgp_enabled#>

<cfelse>

<cfset m="Add Internal Recipients: form.pgp_enabled is not 1 or 2">
<cfinclude template="./inc/error.cfm">
<cfabort>

<!--- #form.pgp_enabled# is not "1" OR #form.pgp_enabled# is not "2"--->
</cfif>

<!--- /CFIF StructKeyExists(form, "pgp_enabled") --->
</cfif>

<!--- VALIDATE PARAMETERS ABOVE --->

<cfif #action# is "add">

<cfif #show_recipient# is "">
<cfset emptyrecipients=1>
<cfelse>
<cfinclude template="./inc/add_internal_recipients_manual.cfm">
</cfif> 


<!---
<cfinclude template="./inc/add_internal_recipients_djigzo.cfm">
--->

  <!--- /CFIF #action# --->
</cfif>

<!-- ERROR MESSAGES STARTS HERE -->

<cfif #emptyrecipients# is "1">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-ban"></i> Oops!</h4>
    <cfoutput>The Recipient(s) field cannot be blank</cfoutput>
  </div>

</cfif>


<cfif #success# GTE "1">
  <div class="alert alert-success alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <h4><i class="icon fa fa-check"></i> Success!</h4>
    <cfoutput>The following #success# Recipients were added successfully:</cfoutput><br>
    <cfoutput>#successrecipient#</cfoutput>
  </div>
</cfif>
 

<cfif #errormessage# is "2">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <h4><i class="icon fa fa-ban"></i> Oops!</h4>
      <cfoutput>Errors were encountered while adding recipients. Please see below</cfoutput>
    </div>

</cfif>



<cfif #emptyemail# is not "0">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
      <cfoutput>There were #emptyemail# blank recipient(s)</cfoutput>
    </div>

</cfif>

<cfif #invalidemail# is not "0">

    <div class="alert alert-danger alert-dismissible">
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
      <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
      <cfoutput>The following #invalidemail# entries had invalid e-mail address(es):</cfoutput><br>
      <cfoutput>#invalidemailrecipient#</cfoutput>
    </div>

</cfif>

<cfif #alreadyexists# is not "0">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
    <cfoutput>The following #alreadyexists# recipient(s) already existed:</cfoutput><br>
    <cfoutput>#alreadyexistsrecipient#</cfoutput>
  </div>

</cfif>

<cfif #invaliddomain# is not "0">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
    <cfoutput>The following #invaliddomain# recipient(s) entries had domains the system does not relay:</cfoutput><br>
    <cfoutput>#invaliddomainrecipient#</cfoutput>
  </div>

</cfif>



<cfif #djigzonotadded# is not "0">

  <div class="alert alert-danger alert-dismissible">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-hidden="true">&times;</button>
    <!--- <h4><i class="icon fa fa-ban"></i> Oops!</h4> --->
    <cfoutput>The following #djigzonotadded# recipient(s) entries had problems setting encryption:</cfoutput><br>
    <cfoutput>#djigzonotaddedrecipient#</cfoutput>
  </div>

</cfif>


<!-- ERROR MESSAGES ENDS HERE -->

<span>
  <p>       

<!--- BACK TO RECIPIENTS BUTTON STARTS HERE --->
<a href="view_internal_recipients.cfm" class="btn btn-secondary" role="button"><i class="fa fa-undo fa-lg"></i>&nbsp;&nbsp;Back to Internal Recipients</a>

<!--- BACK TO RECIPIENTS BUTTON ENDS HERE --->





</p>


</span>


<!-- ADD RECIPIENT FORM STARTS HERE -->


<!-- form start -->

  <form name="add_internal_recipients.cfm" method="post" action="">
  <input type="hidden" name="action" value="add">
    <div class="box-body">
       
      <cfoutput>
        <div class="form-horizontal">
          <label for="recipients"><strong>Recipient(s)</strong></label>
          <div class="form-group">
              
                
                  <textarea class="form-control" name="recipient" rows="10" placeholder="Enter recipient e-mail address(es) each in its own line" required></textarea>            
          </div>

           <!--- RECIPIENT POLICY STARTS HERE --->

          <cfquery name="getdefaultpolicy" datasource="hermes">
            select policy_id, policy_name, default_policy from spam_policies where default_policy ='1'
            </cfquery>

          <cfquery name="getuserpolicies" datasource="hermes">
            select policy_id, policy_name, custom, system from spam_policies where custom='1' and system<>'1' and policy_id<>'#getdefaultpolicy.policy_id#' order by policy_name asc
            </cfquery>

<cfif #getuserpolicies.recordcount# LT 1>



            <div class="form-group">
                <label><strong>SVF Policy to Assign</strong></label>
                <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                        style="width: 100%;">
                  <cfoutput><option value="#getdefaultpolicy.policy_id#" selected="selected">#getdefaultpolicy.policy_name#</option></cfoutput>
                    </select>

                  <cfelseif #getuserpolicies.recordcount# GTE 1>
                    <div class="form-group">
                      <label><strong>SVF Policy to Assign</strong></label>
                      <select class="form-control select2" name="policy" data-placeholder="SVF Policy to Assign"
                              style="width: 100%;">
                        <cfoutput><option value="#getdefaultpolicy.policy_id#" selected="selected">#getdefaultpolicy.policy_name#</option></cfoutput>
                        <cfoutput query="getuserpolicies">
                          <option value="#policy_id#">#policy_name#</option>
                        
                          </cfoutput>
                          </select>
      <!--- /CFIF #getuserpolicies.recordcount# --->
                        </cfif>

                       
      </div>
      </cfoutput>

       <!--- RECIPIENT POLICY ENDS HERE --->



 <!--- QUARANTINE REPORTS STARTS HERE --->

 
 <div class="form-group">
  <label><strong>Quarantine Reports</strong></label>
<!---
  <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
--->
<select class="form-control" name="reports" data-placeholder="reports" id="reports" style="width: 100%">                  
<option value="YES" selected="selected">Enable Report Only if Quarantined Messages Exist</option>
<option value="ALL">Enable Report Regardless if Quarantined Messages Exist</option>
<option value="NO">Disable Quarantine Reports</option>


</select> 
</div>

     
          <div class="form-group" id="reportsfrequency">
            <label><strong>Quarantine Report Frequency</strong></label>
<!---
            <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
--->

  <select class="form-control select2" name="frequency" data-placeholder="frequency" style="width: 100%">                  
  <option value="24" selected="selected">Daily (Previous Day's Quarantine Report)</option>
  <option value="2">Every 2 Hours (Current Day's Quarantine Report)</option>
  <option value="4">Every 4 Hours (Current Day's Quarantine Report)</option>
  <option value="8">Every 8 Hours (Current Day's Quarantine Report)</option>
 
   </select> 
  </div>

  <!--- QUARANTINE REPORTS ENDS HERE --->

<!--- TRAIN BAYES STARTS HERE --->

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


<!--- TRAIN BAYES AND DOWNLOAD MESSAGES  ENDS HERE --->

<!--- DOWNLOAD MESSAGES STARTS HERE --->

<div class="form-group">

  <label><strong>Download Messages from User Portal</strong></label>
  <div class="alert alert-danger">
  <h5><i class="icon fas fa-exclamation-triangle"></i> Warning!</h5>
  <p>Enabling can expose recipients to malware</p>
  </div>
<select class="form-control" name="download_msg" data-placeholder="download_msg" style="width: 100%">                  
<option value="0" selected="selected">Disable</option>
<option value="1">Enable</option>


</select> 
</div>


<!--- DOWNLOAD MESSAGES  ENDS HERE --->



  <div class="alert alert-warning">
    
    <h5><i class="icon fas fa-exclamation-circle"></i> Please Note!</h5>
    <cfoutput>Setting PDF, S/MIME or PGP Encryption below to <strong>Enable</strong> will significantly increase the amount of time it takes to add new recipient(s) </cfoutput>
  </div>

  <!--- PDF ENCRYPTION STARTS HERE --->

  <div class="form-group">
    <label><strong>PDF Encryption</strong></label>
  <!---
    <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
  --->
  <select class="form-control" name="pdf_enabled" data-placeholder="pdf_enabled" style="width: 100%">                  
  <option value="2" selected="selected">Disable</option>
  <option value="1">Enable</option>
 
  
  </select> 
  </div>

  <!--- PDF ENCRYPTION ENDS HERE --->

    <!--- SMIME ENCRYPTION STARTS HERE --->

    <div class="form-group">
      <label><strong>S/MIME Encryption</strong></label>
    <!---
      <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
    --->
    <select class="form-control" name="smime_enabled" data-placeholder="smime_enabled" style="width: 100%">                  
    <option value="2" selected="selected">Disable</option>
    <option value="1">Enable</option>
  
    
    </select> 
    </div>
  
    <!--- SMIME ENCRYPTION ENDS HERE --->

    
    <!--- SMIME SIGN STARTS HERE --->

    <div class="form-group">
      <label><strong>S/MIME SIGNATURE</strong></label>
    
      <p class="help-block">Effective only when S/MIME Certificate present</p>
    
    <select class="form-control" name="sign" data-placeholder="sign" style="width: 100%">                  
    <option value="2" selected="selected">Sign Encrypted Messages Only</option>
    <option value="1">Sign all messages</option>
   
    
    </select> 
    </div>
  
    <!--- SMIME SIGN ENDS HERE --->


        <!--- PGP ENCRYPTION STARTS HERE --->

        <div class="form-group">
          <label><strong>PGP Encryption</strong></label>
        <!---
          <p class="help-block">Effective only Quarantined Report is set to one of the <b>Enable Report</b> options above</p>
        --->
        <select class="form-control" name="pgp_enabled" data-placeholder="pgp_enabled" style="width: 100%">                  
        <option value="2" selected="selected">Disable</option>
        <option value="1">Enable</option>
   
        
        </select> 
        </div>
      
        <!--- PGP ENCRYPTION ENDS HERE --->

      <div class="box-footer">
        <!--- <p class="help-block">Help Block Text</p> --->
       
        <!---
              <button type="submit" class="btn btn-primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">Submit</button>
        --->
        
              <input type="submit" class="btn btn-primary" name="" value="Submit" class="form-control primary" onclick="this.disabled=true;this.value='Please wait...';this.form.submit();">

  

            </div>      

  

    
  </form>

  <div>&nbsp;</div>


<!-- ADD RECIPIENT FORM ENDS HERE -->

</div>
</div>

<div id="loader"></div>

</div><!-- /.container-fluid -->
</div>
<!-- /.content -->
</div>
</main><!-- replaced content-wrapper -->


<cfinclude template="./inc/main_footer.cfm" />



<!-- ./wrapper -->


  

</body>

<!--- SCRIPT TO SHOW/HIDE SCHEDULE IMPORT FREQUENCY SCRIPT STARTS HERE  --->

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

<!--- SCRIPT TO SHOW/HIDE SCHEDULE IMPORT FREQUENCY SCRIPT ENDS HERE  --->

</html>