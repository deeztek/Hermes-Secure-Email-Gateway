
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
  

                <cfexecute name = "/usr/bin/mailq"
                timeout = "240"
                variable="mailQueueStatus">
                </cfexecute>
                
                                    
                    <cfcatch type="any">
                                
                    <cfset m="/inc/check_mail_queue.cfm: There was an error checking mail queue">
                    <cfinclude template="error.cfm">
                    <cfabort>   
                                
                    </cfcatch>
                    </cftry>

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
                
                    <cfif #mailQueueStatus# contains "Mail queue is empty">

                    <cfset getqueue.recordcount=0>
                        
                    <cfelse>   
                            


<cffile action="read" file="/opt/hermes/scripts/list_mailqueue.sh" variable="temp">

<cffile action = "write"
    file = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    output = "#REReplace("#temp#","THE-TRANSACTION","#customtrans3#","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
timeout = "60">
</cfexecute>


<cftry>
  
    <cfexecute name = "/opt/hermes/tmp/#customtrans3#_list_mailqueue.sh"
    timeout = "240"
    arguments="-inputformat none">
    </cfexecute>
    
                        
        <cfcatch type="any">
                    
        <cfset m="/inc/check_mail_queue.cfm: There was an error running /opt/hermes/tmp/#customtrans3#_list_mailqueue.sh">
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


<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_mailqueue_list" variable="temp">

<cfloop index="curLine" list="#temp#" delimiters="#chr(10)#">

<!-- CHECK IF MESSAGE IS ON HOLD BY SEEING IF THERE IS ! (EXCLAMATION) IN MESSAGE ID -->
<cfif #trim(curLine)# contains "!">

<!-- REMOVE ! (EXCLAMATION) FROM MESSAGE ID -->
<cfset msgId = reReplace("#trim(curLine)#", "[!]", "", "ALL")>

<!-- INSERT INTO DATABASE AS ON-HOLD QUEUE MESSAGE -->
<cfquery name="insert" datasource="hermes">
insert into postfix_queue
(trans_id, msg_id, queue_type)
values 
('#customtrans3#', '#msgId#', 'ON-HOLD')
</cfquery>

<!-- CHECK IF MESSAGE IS ACTIVE BY SEEING IF THERE IS * (EXCLAMATION) IN MESSAGE ID -->
<cfelseif #trim(curLine)# contains "*">

<!-- REMOVE ! (EXCLAMATION) FROM MESSAGE ID -->
<cfset msgId = reReplace("#trim(curLine)#", "[*]", "", "ALL")>

<!-- INSERT INTO DATABASE AS ACTIVE QUEUE MESSAGE -->
<cfquery name="insert" datasource="hermes">
insert into postfix_queue
(trans_id, msg_id, queue_type)
values 
('#customtrans3#', '#msgId#', 'ACTIVE')
</cfquery>

<cfelse>

<cfquery name="insert" datasource="hermes">
insert into postfix_queue
(trans_id, msg_id, queue_type)
values 
('#customtrans3#', '#trim(curLine)#', 'N/A')
</cfquery>

<!-- /CFIF #trim(curLine)# contains -->
</cfif>

</cfloop>


<!-- delete /opt/hermes/tmp/#customtrans3#_mailqueue_list -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_mailqueue_list">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">

<!--- /CFIF <cfif fileExists(FiletoDelete)> --->
</cfif>

<!-- GET POSTFIX QUEUE FROM DATABASE -->
<cfquery name="getqueue" datasource="hermes">
select msg_id, queue_type from postfix_queue where trans_id = '#customtrans3#'
</cfquery>
    
<!-- DELETE POSTFIX QUEUE FROM DATABASE -->
<cfquery name="deletequeue" datasource="hermes">
delete from postfix_queue where trans_id = '#customtrans3#'
</cfquery>
                        

<!--- /CFIF #mailQueueStatus# contains --->
</cfif>