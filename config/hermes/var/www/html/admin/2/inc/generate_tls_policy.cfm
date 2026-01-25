
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

  <cfquery name="customtrans" datasource="hermes" result="getrandom_results">
    select random_letter as random from captcha_list_all2 order by RAND() limit 8
    </cfquery>
    
    <cfquery name="inserttrans" datasource="hermes" result="stResult">
    insert into salt
    (salt)
    values
    ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
    </cfquery>
    
    <cfquery name="gettrans" datasource="hermes">
    select salt as customtrans2 from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    <cfset customtrans3=#gettrans.customtrans2#>
    
    <cfquery name="deletetrans" datasource="hermes">
    delete from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    

    <cfquery name="policies" datasource="#datasource#">
      SELECT domain, method from tls_policies where applied = '1' order by domain asc
      </cfquery>
      
      
      <cfif #policies.recordcount# GTE 1>
      <cffile action = "write"
          file = "/opt/hermes/tmp/#customtrans3#_tls_policy"
          output = ""
          addNewLine = "no">
      <cfloop query="policies">
      
      <cfoutput>
      <cffile action = "append"
          file = "/opt/hermes/tmp/#customtrans3#_tls_policy"
          output = "#domain# #method#"
          addNewLine = "yes">
      </cfoutput>
      
      </cfloop>
      
      <cfelseif #policies.recordcount# LT 1>
      <cffile action = "write"
          file = "/opt/hermes/tmp/#customtrans3#_tls_policy"
          output = ""
          addNewLine = "no">
      </cfif>
      
      
      <cfset command="/bin/cp /etc/postfix/tls_policy /etc/postfix/tls_policy.HERMES.BACKUP#chr(10)#/bin/mv /opt/hermes/tmp/#customtrans3#_tls_policy /etc/postfix/tls_policy#chr(10)#/usr/sbin/postmap /etc/postfix/tls_policy">
      
      <cffile action = "write" 
      file = "/opt/hermes/tmp/#customtrans3#_apply.sh" 
      output = "#command#" addnewline="no">


<!--- MAKE #CUSTOMTRANS3#_APPLY.SH EXECUTABLE --->
      <cftry>
  
        <cfexecute name = "/bin/chmod"
        arguments="+x /opt/hermes/tmp/#customtrans3#_apply.sh"
        timeout = "60">
      </cfexecute>
                    
            <cfcatch type="any">
                
            <cfset m="Generate TLS Policy: There was an error making /opt/hermes/tmp/_apply.sh executable">
            <cfinclude template="error.cfm">
            <cfabort>   
                
            </cfcatch>
            </cftry>
        
      
<!--- EXECUTE #CUSTOMTRANS3#_APPLY.SH --->
<cftry>
  
  <cfexecute name = "/opt/hermes/tmp/#customtrans3#_apply.sh"
  outputfile ="/dev/null"
  arguments="-inputformat none"
  timeout = "120">
  </cfexecute>
              
      <cfcatch type="any">
          
      <cfset m="Generate TLS Policy: There was an error making /opt/hermes/tmp/_apply.sh executable">
      <cfinclude template="error.cfm">
      <cfabort>   
          
      </cfcatch>
      </cftry>
    

<!--- delete /opt/hermes/tmp/#customtrans3#_apply.sh file --->
<cfif FileExists("/opt/hermes/tmp/#customtrans3#_apply.sh")>
  
  <cffile
  action = "delete"
  file = "/opt/hermes/tmp/#customtrans3#_apply.sh">    
  
  </cfif>
     
    
 
  