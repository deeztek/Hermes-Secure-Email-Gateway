 <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->


<!--- SEND GET POSTMASTER, ADMIN AND CONSOLE HOST FOR CFMAIL IF NECESSARY --->

      <cfquery name="getpostmaster" datasource="hermes">
    select parameter, value from system_settings where parameter='postmaster'
    </cfquery>
      
      <cfquery name="getadmin" datasource="hermes">
        select parameter, value from system_settings where parameter='admin_email'
        </cfquery>

<cfquery name="getconsolehost" datasource="hermes">
  select parameter, value2 from parameters2 where parameter='console.host' and module='console'
  </cfquery>

  <cftry> 

  <cfexecute name = "/opt/hermes/schedule/health_check_mailqueue.sh"
    arguments="-inputformat none"
    variable="mailqueuecount"
    timeout = "60">
    </cfexecute>

    <cfoutput>The Mail Queue Count: #mailqueuecount#</cfoutput>
    
    <cfcatch type="any">
 


      <cfmail from="#getpostmaster.value#" to="#getadmin.value#" server="hermes_postfix_dkim" subject="[Hermes SEG] Error Notification: Mailqueue Check Error" port="10026" type="html">

        <div align="center">

    <b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>
        
       <h2>Hermes SEG Error Notification</h2>
       
       Hermes SEG encountered an error while attempting to check the mailqueue. The error reported is: #cfcatch.detail#<br><br>
       
       Please contact Hermes SEG Support.
        </div>
        
        
        </cfmail>

  <cfabort>

    </cfcatch>
    </cftry>


<cfif #mailqueuecount# GT 20>

<cfmail from="#getpostmaster.value#" to="#getadmin.value#" server="hermes_postfix_dkim" subject="[Hermes SEG] Warning Notification: Mail Queue Message Count" port="10026" type="html">

        <div align="center">

    <b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>
        
       <h2>Hermes SEG Warning Notification</h2>
       
       Hermes SEG has detected #mailqueuecount# messages in the Mail Queue. This could indicate a problem with e-mail delivery. Please navigate to System --> Mail Queue in the Admin Console to investigate.<br><br>
       
        </div>
        
        
        </cfmail>

<!--- /CFIF #mailqueuecount# GTE --->
</cfif>
    
