
 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->

  <cfinclude template="generate_customtrans.cfm">


    <cfquery name="policies" datasource="#datasource#">
      SELECT domain, method from tls_policies where applied = '1' order by domain asc
      </cfquery>

      <!--- Per-recipient backend overrides (#157).

           smtp_tls_policy_maps is keyed by NEXTHOP, not by recipient, so a
           recipient override contributes a policy for the host it points at.
           Two recipients sharing a backend therefore share one entry.

           When they disagree, the strictest wins. A duplicate key in the map
           would otherwise be resolved by postmap taking whichever line came
           first, which is arbitrary. Honouring the stronger of two explicit
           choices is at least defensible, and downgrading one silently is not.

           Ranked none < may < encrypt, collapsed back to the name after the
           MAX so the file holds a real policy keyword. --->
      <cfquery name="recipientBackends" datasource="#datasource#">
        SELECT nexthop,
               CASE MAX(tls_rank) WHEN 3 THEN 'encrypt' WHEN 2 THEN 'may' ELSE 'none' END AS method
          FROM (
            SELECT CONCAT('[', backend_server, ']:', COALESCE(backend_port, 25)) AS nexthop,
                   CASE backend_tls WHEN 'encrypt' THEN 3 WHEN 'may' THEN 2 ELSE 1 END AS tls_rank
              FROM recipients
             WHERE backend_server IS NOT NULL AND backend_server <> ''
               AND backend_tls    IS NOT NULL AND backend_tls    <> ''
          ) AS overrides
         GROUP BY nexthop
         ORDER BY nexthop ASC
      </cfquery>

      <!--- Start empty and append from both sources. This used to write the
           file in one branch and create it empty in the other, which left no
           room for a second contributor. --->
      <cffile action = "write"
          file = "/opt/hermes/tmp/#customtrans3#_tls_policy"
          output = ""
          addNewLine = "no">

      <cfloop query="policies">
      <cfoutput>
      <cffile action = "append"
          file = "/opt/hermes/tmp/#customtrans3#_tls_policy"
          output = "#policies.domain# #policies.method#"
          addNewLine = "yes">
      </cfoutput>
      </cfloop>

      <cfloop query="recipientBackends">
      <cfoutput>
      <cffile action = "append"
          file = "/opt/hermes/tmp/#customtrans3#_tls_policy"
          output = "#recipientBackends.nexthop# #recipientBackends.method#"
          addNewLine = "yes">
      </cfoutput>
      </cfloop>
      
      
      <cfset command="/bin/cp /etc/postfix/tls_policy /etc/postfix/tls_policy.HERMES.BACKUP#chr(10)#/bin/mv /opt/hermes/tmp/#customtrans3#_tls_policy /etc/postfix/tls_policy#chr(10)#/usr/local/bin/docker exec hermes_postfix_dkim /usr/sbin/postmap /etc/postfix/tls_policy">
      
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
<cfexecute name="/opt/hermes/tmp/#customtrans3#_apply.sh"
  arguments="-inputformat none"
  timeout="120"
  variable="applyOutput"
  errorVariable="applyError" />
    

<!--- delete /opt/hermes/tmp/#customtrans3#_apply.sh file --->
<cfif FileExists("/opt/hermes/tmp/#customtrans3#_apply.sh")>
  
  <cffile
  action = "delete"
  file = "/opt/hermes/tmp/#customtrans3#_apply.sh">    
  
  </cfif>
     
    
 
  