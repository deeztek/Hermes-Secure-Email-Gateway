
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
    
    <!--- EDIT RECIPIENTS STARTS HERE --->

    <cfquery name="editrecipients" datasource="hermes">
        update recipients 
        set 
        policy_id = '#form.policy#'
        where recipient = '#recipient#'
        </cfquery>
   

     <!--- EDIT RECIPIENT ENDS HERE --->

    <!--- EDIT USER_SETTINGS STARTS HERE --->

    <cfquery name="editusersettings" datasource="hermes">
        update user_settings 
        set 
        report_enabled = '#form.reports#',
        report_frequency = '#form.frequency#', 
        train_bayes = '#form.train_bayes#', 
        download_msg = '#form.download_msg#'
        where email = '#recipient#'
        </cfquery>

          <!--- EDIT USER_SETTINGS ENDS HERE --->

<!---
<cfif #form.pdf_enabled# is "1" OR #form.smime_enabled# is "1" OR #form.pgp_enabled# is "1">
--->

<!---
<cfinclude template="edit_internal_recipients_djigzo.cfm">
--->

<!--- /CFIF pdf_enabled# is "1" OR #smime_enabled# is "1" OR #pgp_enabled# is "1" --->
<!---
</cfif> 
--->

