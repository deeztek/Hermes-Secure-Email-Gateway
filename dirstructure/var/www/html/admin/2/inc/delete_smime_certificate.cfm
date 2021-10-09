<!-- DELETE CERTIFICATE AND KEYSTORE FROM DJIGZO STARTS HERE -->


<cfquery name="getthumbprint" datasource="djigzo">
    select cm_id, cm_thumbprint, cm_key_alias from cm_certificates where cm_id='#getcerts.djigzo_certificate_id#'
    </cfquery>
    
    <cfquery name="delete1" datasource="djigzo">
    delete from cm_certificates_email where cm_certificates_id='#getcerts.djigzo_certificate_id#'
    </cfquery>
    
    <cfquery name="delete2" datasource="djigzo">
    delete from cm_certificates where cm_id='#getcerts.djigzo_certificate_id#'
    </cfquery>
    
    <cfquery name="getctl" datasource="djigzo">
    select * from cm_ctl where cm_thumbprint='#getthumbprint.cm_thumbprint#'
    </cfquery>
    
    <cfif #getctl.recordcount# GTE 1>
  
    <cfquery name="delete4" datasource="djigzo">
    delete from cm_ctl_cm_name_values where cm_ctl='#getctl.cm_id#'
    </cfquery>
    
    <cfquery name="delete3" datasource="djigzo">
    delete from cm_ctl where cm_thumbprint='#getthumbprint.cm_thumbprint#'
    </cfquery>
    
    <!-- /CFIF for getctl.recordcount -->
    </cfif>
    
    <cfquery name="getkeystore" datasource="djigzo">
    select * from cm_keystore where cm_alias='#getthumbprint.cm_key_alias#'
    </cfquery>
    
    <cfif #getkeystore.recordcount# GTE 1>
  
    <cfquery name="delete5" datasource="djigzo">
    delete from cm_keystore where cm_alias='#getthumbprint.cm_key_alias#'
    </cfquery>
    
    <!-- /CFIF for getkeystore.recordcount -->
    </cfif>
    
    
    <!-- DELETE CERTIFICATE AND KEYSTORE FROM DJIGZO ENDS HERE -->
    
    <!-- DELETE FROM HERMES CERTITIFCATE STORE STARTS HERE -->
    
    <cfif #getcerts.external_ca# is not "1">
  
    <cfoutput>
    <cfquery name="getca" datasource="hermes">
    select ca_directory from ca_settings where id='#getcerts.ca_id#'
    </cfquery>
    
    <cfset smime_certificate_name2="/opt/hermes/CA/#getca.ca_directory#/root_ca/newcerts/#getcerts.smime_certificate_name#">
  
    <cfif fileExists(smime_certificate_name2)> 
  
    <cffile 
    action = "delete"
    file = "#smime_certificate_name2#">
  
     <!--- /CFIF fileExists() --->
    </cfif>
    
    <cfset smime_certificate_request2="/opt/hermes/CA/#getca.ca_directory#/root_ca/requests/#getcerts.smime_certificate_request#">  
  
    <cfif fileExists(smime_certificate_request2)>    
    <cffile
        action = "delete"
        file = "#smime_certificate_request2#">
  
    <!--- /CFIF fileExists() --->
    </cfif>
        
    <cfset smime_certificate_key2="/opt/hermes/CA/#getca.ca_directory#/root_ca/private/#getcerts.smime_certificate_key#"> 
  
    <cfif fileExists(smime_certificate_key2)>  
    <cffile
        action = "delete"
        file = "#smime_certificate_key2#">
  
    <!--- /CFIF fileExists() --->
    </cfif>
        
    <cfset pfx_certificate_name2="/opt/hermes/CA/#getca.ca_directory#/root_ca/PFX/#getcerts.pfx_certificate_name#">    
  
    <cfif fileExists(pfx_certificate_name2)>     
    <cffile
        action = "delete"
        file = "#pfx_certificate_name2#">
  
    <!--- /CFIF fileExists() --->
    </cfif>  
  
    </cfoutput>
    
    <cfelseif #getcerts.external_ca# is "1">
  
    <cfoutput>
  
    <cfset pfx_certificate_name2="/opt/hermes/HermesExternalCACerts/#getcerts.pfx_certificate_name#"> 
  
    <cfif fileExists(pfx_certificate_name2)>     
    <cffile
        action = "delete"
        file = "#pfx_certificate_name2#">
  
    <!--- /CFIF fileExists() --->
    </cfif> 
    
    </cfoutput>
    
    <!-- /CFIF for getcerts.external_ca -->
    </cfif>
    
    <cfquery name="deletecert" datasource="hermes">
    delete from recipient_certificates where id='#form.certificate_id#'
    </cfquery>
    
    <!-- DELETE FROM HERMES CERTITIFCATE STORE ENDS HERE --> 