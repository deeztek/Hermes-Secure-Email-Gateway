
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

<!---

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
--->



<!---  GET MESSAGE DATE --->

<cffile action="read" file="/opt/hermes/scripts/get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
output = "#REReplace("#temp#","MESSAGE-ID","#msg_id#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
output = "#REReplace("#temp#","THE-FIELD","Date","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
timeout = "60">
</cfexecute>

<cftry>
  

<cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
timeout = "240"
variable="msgDate"
arguments="-inputformat none">
</cfexecute>
    
                        
<cfcatch type="any">
                    
<cfif #cfcatch.detail# contains "No such file">
<cfset msgDate="">

<cfelse>
<cfset msgDate=REReplace(msgLoc,"#chr(13)#|#chr(9)#|\n|\r","","ALL")>
<cfset msgDate=REReplace(msgLoc,"To","","ALL")>
<cfset msgDate=#trim(msgDate)#>
        
<!--- cfcatch.detail --->
</cfif>
                    
</cfcatch>
</cftry>

<!-- delete /opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

<!---  GET MESSAGE SUBJECT --->

<cffile action="read" file="/opt/hermes/scripts/get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
output = "#REReplace("#temp#","MESSAGE-ID","#msg_id#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
output = "#REReplace("#temp#","THE-FIELD","Subject","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
timeout = "60">
</cfexecute>

<cftry>
  
<cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
timeout = "240"
variable="msgSubject"
arguments="-inputformat none">
</cfexecute>
    
                        
<cfcatch type="any">
                    
<cfif #cfcatch.detail# contains "No such file">
<cfset msgSubject="">
<cfelse>

<cfset msgSubject="#trim(msgSubject)#">

<!--- cfcatch.detail --->
</cfif>
                    
</cfcatch>
</cftry>

<!-- delete /opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>


<!---  GET MESSAGE FROM --->

<cffile action="read" file="/opt/hermes/scripts/get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
output = "#REReplace("#temp#","MESSAGE-ID","#msg_id#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
output = "#REReplace("#temp#","THE-FIELD","From","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
timeout = "60">
</cfexecute>

<cftry>
  
<cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
timeout = "240"
variable="msgFrom"
arguments="-inputformat none">
</cfexecute>
    
                        
<cfcatch type="any">
                    
<cfif #cfcatch.detail# contains "No such file">
<cfset msgFrom="">
<cfelse>

<cfset msgFrom="#trim(msgFrom)#">
        
<!--- cfcatch.detail --->
</cfif>
                    
</cfcatch>
</cftry>

<!-- delete /opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>


<!---  GET MESSAGE FROM --->

<cffile action="read" file="/opt/hermes/scripts/get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
output = "#REReplace("#temp#","MESSAGE-ID","#msg_id#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
output = "#REReplace("#temp#","THE-FIELD","To","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
timeout = "60">
</cfexecute>

<cftry>
  
<cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
timeout = "240"
variable="msgTo"
arguments="-inputformat none">
</cfexecute>
    
                        
<cfcatch type="any">
                    
<cfif #cfcatch.detail# contains "No such file">
<cfset msgTo="">
<cfelse>

<cfset msgTo="#trim(msgFrom)#">
        
<!--- cfcatch.detail --->
</cfif>
                    
</cfcatch>
</cftry>

<!-- delete /opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>


<!---  GET MESSAGE DIAG CODE --->

<cffile action="read" file="/opt/hermes/scripts/get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
output = "#REReplace("#temp#","MESSAGE-ID","#msg_id#","ALL")#" addnewline="no">

<cffile action="read" file="/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh" variable="temp">

<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
output = "#REReplace("#temp#","THE-FIELD","Diagnostic-Code","ALL")#" addnewline="no">

<cfexecute name = "/bin/chmod"
arguments="+x /opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
timeout = "60">
</cfexecute>

<cftry>
  
<cfexecute name = "/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh"
timeout = "240"
variable="msgDiag"
arguments="-inputformat none">
</cfexecute>
    
                        
<cfcatch type="any">
                    
<cfif #cfcatch.detail# contains "No such file">
<cfset msgDiag="">
<cfelse>

<cfset msgDiag="#trim(msgDiag)#">
        
<!--- cfcatch.detail --->
</cfif>
                    
</cfcatch>
</cftry>

<!-- delete /opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh -->
<cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_get_mailqueue_msg.sh">
<cfif fileExists(FiletoDelete)> 
<cffile action="delete" 
file = "#FiletoDelete#">
</cfif>

                   