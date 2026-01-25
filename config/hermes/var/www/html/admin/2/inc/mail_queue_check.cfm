
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

        

         
  

            <cftry>
  

                <cfexecute name = "/usr/local/bin/docker"
                arguments="exec hermes_postfix_dkim /usr/bin/mailq"
                timeout = "240"
                variable="mailQueueStatus">
                </cfexecute>
                
                                    
                    <cfcatch type="any">
                                
                    <cfset m="/inc/mail_queue_check.cfm: There was an error checking mail queue">
                    <cfinclude template="error.cfm">
                    <cfabort>   
                                
                    </cfcatch>
                    </cftry>
                
  

    
                
                    <cfif #mailQueueStatus# contains "Mail queue is empty">

                    <cfset getqueue.recordcount=0>
                        
                    <cfelse>   
                            
<cfinclude template="generate_customtrans.cfm">

<cffile action="read" file="/opt/hermes/scripts/list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-TRANSACTION","#customtrans3#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "60">
</cfexecute>


<!--- Gemerate /opt/hermes/tmp/#customtrans3#__list CSV File --->
<cftry>
  
    <cfexecute name = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    timeout = "240"
    arguments="-inputformat none">
    </cfexecute>
    
                        
        <cfcatch type="any">
                    
        <cfset m="/inc/mail_queue_check.cfm: There was an error running /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh">
        <cfinclude template="error.cfm">
        <cfabort>   
                    
        </cfcatch>
        </cftry>

<!--- Clear all records from postfix_queue table --->
<cfquery name="clearpostfixqueue" datasource="hermes">
delete from postfix_queue
</cfquery>

<!--- Dump genearated /opt/hermes/tmp/#customtrans3#-mailqueue_list CSV file into postfix_queue table --->

<cffile action="read" file="/opt/hermes/scripts/import_mailqueue_db.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_import_mailqueue_db.sh"
    output = "#REReplace("#temp#","THE-TRANSACTION","#customtrans3#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_import_mailqueue_db.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_import_mailqueue_db.sh"
    output = "#REReplace("#temp#","THE-USERNAME","#HERMES_DATASOURCE_USERNAME#","ALL")#" addnewline="no">

    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_import_mailqueue_db.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_import_mailqueue_db.sh"
    output = "#REReplace("#temp#","THE-PASSWORD","#HERMES_DATASOURCE_PASSWORD#","ALL")#" addnewline="no">


<cftry>
  
<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_import_mailqueue_db.sh"
timeout = "60">
</cfexecute>
    
                        
        <cfcatch type="any">
                    
        <cfset m="/inc/mail_queue_check.cfm: There was an error running chmod +x /opt/hermes/tmp/#customtrans3#_import_mailqueue_db.sh">
        <cfinclude template="error.cfm">
        <cfabort>   
                    
        </cfcatch>
        </cftry>

<cftry>
  
<cfexecute name = "/opt/hermes/tmp/#customtrans3#_import_mailqueue_db.sh"
timeout = "60"
arguments="-inputformat none">
</cfexecute>
    
                        
        <cfcatch type="any">
                    
        <cfset m="/inc/mail_queue_check.cfm: There was an error running /opt/hermes/tmp/#customtrans3#_import_mailqueue_db.sh">
        <cfinclude template="error.cfm">
        <cfabort>   
                    
        </cfcatch>
        </cftry>



<!-- delete /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>

<!--- delete /opt/hermes/tmp/#customtrans3#_list --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#-mailqueue_list">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>

<!--- delete /opt/hermes/tmp/#customtrans3#_import_mailqueue_db.sh --->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_import_mailqueue_db.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF fileExists(FiletoDelete) --->
</cfif>

<!--- GET POSTFIX QUEUE COUNT FROM DATABASE --->
<cfquery name="getqueuecount" datasource="hermes">
select count(QueueID) as count from postfix_queue
</cfquery>

<cfif #getqueuecount.count# GT 100>
<cfset mailqueuelimit = 1> 

<!--- GET POSTFIX QUEUE FROM DATABASE --->
<cfquery name="getqueue" datasource="hermes">
select QueueID, Sender, Recipient, ConnectionStatus, MsgStatus from postfix_queue limit 100
</cfquery>

<cfelse>

<!--- GET POSTFIX QUEUE FROM DATABASE --->
<cfquery name="getqueue" datasource="hermes">
select QueueID, Sender, Recipient, ConnectionStatus, MsgStatus from postfix_queue
</cfquery>

<!--- /CFIF #getqueuecount.count# GT --->
</cfif>

<!--- DELETE POSTFIX QUEUE FROM DATABASE --->
<cfquery name="deletequeue" datasource="hermes">
delete from postfix_queue
</cfquery>


<!--- /CFIF #mailQueueStatus# contains --->
</cfif>