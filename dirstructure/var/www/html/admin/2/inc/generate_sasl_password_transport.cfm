
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

<cfquery name="gettransportauth" datasource="hermes">
select domain, authentication, authentication_username, authentication_password from transport where authentication = 'YES'
</cfquery>

<cffile action="read" file="/opt/hermes/keys/hermes.key" variable="hermeskey">
    
    <cfset FileSasl = "">

    <cfloop query="gettransportauth">

    <cfif #authentication_username# is "" OR #authentication_password# is "">

    <cfset m="generate_sasl_password_transport.cfm: authentication_username OR authentication_password is blank">
    <cfinclude template="./inc/error.cfm">
    <cfabort>
    
    <cfelse>
                     
    <!-- DECRYPT USERNAME -->
    <cfset DecryptedUsername = decrypt(authentication_username, #hermeskey#, "AES", "Base64")>

    <!-- DECRYPT PASSWORD -->
    <cfset DecryptedPassword = decrypt(authentication_password, #hermeskey#, "AES", "Base64")>
                    
    <!-- /CFIF #authentication_username# is "" OR #authentication_password# is ""  -->
    </cfif>

<cfoutput>
<cfset FileSasl = FileSasl & #Chr(91)# & #domain# & #Chr(93)# & #Chr(58)# & #form.destination_port# & #Chr(9)# & #DecryptedUsername# & #Chr(58)# & #DecryptedPassword# & #Chr(13)# & #Chr(10)#>
</cfoutput>

    </cfloop>
    
    <cffile action = "write" file = "/etc/postfix/sasl_passwd" output = "#FileSasl#" addnewline="no">

    <cffile action = "write"
        file = "/opt/hermes/tmp/#customtrans3#_postmap.sh"
        output = "/usr/sbin/postmap /etc/postfix/sasl_passwd" addnewline="no">

        <cfexecute name = "/bin/chmod"
        arguments="+x /opt/hermes/tmp/#customtrans3#_postmap.sh"
        timeout = "60">
        </cfexecute>
        

            <cftry>
  

                <cfexecute name = "/opt/hermes/tmp/#customtrans3#_postmap.sh"
                timeout = "240"
                outputfile ="/dev/null"
                arguments="-inputformat none">
                </cfexecute>
                
                                    
                    <cfcatch type="any">
                                
                    <cfset m="/inc/generate_sasl_password_transport.cfm: There was an error postmapping sasl_passwd">
                    <cfinclude template="error.cfm">
                    <cfabort>   
                                
                    </cfcatch>
                    </cftry>
                
                <cfif FileExists("/opt/hermes/tmp/#customtrans3#_postmap.sh")>
        
                <cffile
                action = "delete"
                file = "/opt/hermes/tmp/#customtrans3#_postmap.sh"> 
        
                <!--- /CFIF FileExists --->
                </cfif>