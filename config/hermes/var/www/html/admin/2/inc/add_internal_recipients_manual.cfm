
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

<!--- GET DEFAULT POLICY STARTS HERE --->
<!--- NOT USED SINCE ADD-INTERNAL-RECIPIENTS TEMPLATE SPECIFIES POLICY --->
<!---
<cfquery name="getdefaultpolicy" datasource="hermes">
select policy_id, default_policy from spam_policies where default_policy='1'
</cfquery>
    
<cfif #getdefaultpolicy.recordcount# GTE 1>
<cfset policy="#getdefaultpolicy.recordcount#">  

<cfelse>
<cfset policy="7">
<!--- #getdefaultpolicy.recordcount# GTE 1 --->
</cfif>
--->

<!--- GET DEFAULT POLICY ENDS HERE --->


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
    

<!---
<cffile action = "write"
file = "/opt/hermes/tmp/#customtrans3#_recipients"
output = "#show_recipient#"> 

<cfoutput>
textarea: #show_recipient#
</cfoutput>



    <cffile action="read" file="/opt/hermes/tmp/#customtrans3#_recipients" variable="therecipients">
--->

    <!---
    <cfset FiletoDelete="/opt/hermes/tmp/#customtrans3#_recipients">

    <cfif fileExists(FiletoDelete)>
        <cffile action = "delete" file = "#FiletoDelete#"> 
        <!--- /CFIF fileExists --->
        </cfif>

    --->

<cfloop index="recipient" list="#show_recipient#" delimiters="#chr(10)#">

    <cfoutput>
    <cfset recipient = #LCase(recipient)#>
    <cfset recipient = #trim(recipient)#>
</cfoutput>

        <cfif #recipient# is not "">
        <cfset step=1>
        <cfelseif #recipient# is "">
        <cfset step=0>
        <cfset errormessage=2>
        <cfset emptyemail=#emptyemail#+1>

        <!--- /CFIF #trim(recipient)# --->
        </cfif>

        <cfif #step# is "1">
        <cfif IsValid("email", recipient)>
        <cfset step=2>

        <cfelseif NOT IsValid("email", recipient)>
        <cfset step=0>
        <cfset errormessage=2>
        <cfset invalidemail=#invalidemail#+1>
        <cfset invalidemailrecipient="#invalidemailrecipient# #recipient#<br>">

         <!--- /CFIF IsValid("email", recipient) --->
        </cfif>
        
        <!--- /CFIF #step# is "1" --->
        </cfif>

        <cfif #step# is "2">
        <cfset domainpart = #ListGetAt(recipient, 2, "@")#>
        
        <cfquery name="checkdomain" datasource="hermes">
        select domain from domains where domain='#domainpart#'
        </cfquery>

        <cfif #checkdomain.recordcount# GTE 1>
        <cfset step=3>
        <cfelseif #checkdomain.recordcount# LT 1>
        <cfset step=0>
        <cfset errormessage=2>
        <cfset invaliddomain=#invaliddomain#+1>
        <cfset invaliddomainrecipient="#invaliddomainrecipient# #recipient#<br>">
        
         <!--- /CFIF #checkdomain.recordcount# --->
        </cfif>

        <!--- /CFIF #step# is "2" --->
        </cfif>
        
        <cfif #step# is "3">
        <cfoutput>
        <cfquery name="checkentry" datasource="hermes">
        select recipient from recipients where recipient='#recipient#'
        </cfquery>
        </cfoutput>

        <cfif #checkentry.recordcount# LT 1>
        <cfset step=4>
        <cfelseif #checkentry.recordcount# LT 1>
        <cfset step=0>
        <cfset errormessage=2>
        <cfset alreadyexists=#alreadyexists#+1>
        <cfset alreadyexistsrecipient="#alreadyexistsrecipient# #recipient#<br>">

         <!--- /CFIF #checkentry.recordcount# --->
        </cfif>

        <!--- /CFIF #step# is "3" --->
        </cfif>

        
        <cfif #step# is "4">
        <cfoutput>
        
        <cfquery name="insert" datasource="hermes">
        insert into recipients
        (policy_id, recipient, status, configured, pdf_enabled, smime_enabled, pgp_enabled, smime_mode, digital_sign, validity, encryption, algorithm)
        values
        ('#show_policy#', '#recipient#', 'OK', '2', '#show_pdf_enabled#', '#show_smime_enabled#', '#show_pgp_enabled#', '1', '#show_sign#', '1825', '4096', 'sha512')
        </cfquery>
        </cfoutput>
                
    <!--- CREATE UNIQUE ID FOR EACH RECIPIENT STARTS HERE --->
    <cfquery name="userrandom" datasource="hermes" result="getrandom_results">
    select random_letter as random from captcha_list_all2 order by RAND() limit 24
    </cfquery>
    
    <cfquery name="inserttrans" datasource="hermes" result="stResult">
    insert into salt
    (salt)
    values
    ('<cfoutput query="userrandom">#TRIM(random)#</cfoutput>')
    </cfquery>
    
    <cfquery name="gettrans" datasource="hermes">
    select salt as userrandom2 from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    <cfset userrandom3=#gettrans.userrandom2#>
    
    <cfquery name="deletetrans" datasource="hermes">
    delete from salt where id='#stResult.GENERATED_KEY#'
    </cfquery>
    
    <!--- CREATE UNIQUE ID FOR EACH RECIPIENT ENDS HERE --->

    <!--- INSERT INTO USER_SETTINGS STARTS HERE --->

    <cfquery name="insertreport" datasource="hermes">
        insert into user_settings
        (id, email, report_enabled, report_frequency, password_set, train_bayes, download_msg)
        values
        ('#userrandom3#', '#recipient#', '#show_reports#', '#show_frequency#', '0', '#show_train_bayes#', '#show_download_msg#')
        </cfquery>

          <!--- INSERT INTO USER_SETTINGS ENDS HERE --->


    <cfset success=#success#+1>
    <cfset successrecipient="#successrecipient# #recipient#<br>">
    
      <!--- /CFIF #step# is "4" --->
    </cfif>

<cfif #pdf_enabled# is "1" OR #smime_enabled# is "1" OR #pgp_enabled# is "1">

<cfinclude template="add_internal_recipients_djigzo.cfm">

<!--- #pdf_enabled# is "1" OR #smime_enabled# is "1" OR #pgp_enabled# is "1" --->
</cfif> 

<!--- /CFLOOP index="recipient" --->
</cfloop>

<!--- CREATE USERS TABLE WITH RECIPIENTS TABLE STARTS HERE --->
<!---
<cfinclude template="../common/stop_postfix.cfm">
<cfinclude template="../common/stop_amavis.cfm">
<cfinclude template="../common/create_users_table_with_recipients_table.cfm">
<cfinclude template="../common/start_postfix.cfm">
<cfinclude template="../common/start_amavis.cfm">
--->

<!--- CREATE USERS TABLE WITH RECIPIENTS TABLE ENDS HERE --->