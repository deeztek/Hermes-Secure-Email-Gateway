<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->


<!--- GET POSTMASTER, ADMIN AND CONSOLE HOST FOR NOTIFICATIONS --->
<cfquery name="getpostmaster" datasource="hermes">
    SELECT parameter, value FROM system_settings WHERE parameter='postmaster'
</cfquery>

<cfquery name="getadmin" datasource="hermes">
    SELECT parameter, value FROM system_settings WHERE parameter='admin_email'
</cfquery>

<cfquery name="getconsolehost" datasource="hermes">
    SELECT parameter, value2 FROM parameters2 WHERE parameter='console.host' AND module='console'
</cfquery>

<!--- GET PUSHOVER SETTINGS --->
<cfquery name="getPushoverSettings" datasource="hermes">
    SELECT parameter, value FROM system_settings
    WHERE parameter IN ('pushover_enabled', 'pushover_api_token', 'pushover_user_key')
</cfquery>

<!--- PARSE PUSHOVER SETTINGS --->
<cfset pushoverEnabled = false>
<cfset pushoverApiToken = "">
<cfset pushoverUserKey = "">

<cfloop query="getPushoverSettings">
    <cfswitch expression="#parameter#">
        <cfcase value="pushover_enabled">
            <cfset pushoverEnabled = (value EQ "1" OR value EQ "true")>
        </cfcase>
        <cfcase value="pushover_api_token">
            <cfset pushoverApiToken = value>
        </cfcase>
        <cfcase value="pushover_user_key">
            <cfset pushoverUserKey = value>
        </cfcase>
    </cfswitch>
</cfloop>

<!--- CHECK IF PUSHOVER IS FULLY CONFIGURED --->
<cfset pushoverConfigured = pushoverEnabled AND Len(Trim(pushoverApiToken)) GT 0 AND Len(Trim(pushoverUserKey)) GT 0>

<cftry> 

  <cfexecute name = "/opt/hermes/schedule/health_check_mailqueue.sh"
    arguments="-inputformat none"
    variable="mailqueuecount"
    timeout = "60">
    </cfexecute>

    <cfoutput>The Mail Queue Count: #mailqueuecount#</cfoutput>
    
    <cfcatch type="any">

        <!--- SEND ERROR NOTIFICATION VIA PUSHOVER (if configured) --->
        <cfif pushoverConfigured>
            <cftry>
                <cfhttp url="https://api.pushover.net/1/messages.json" method="POST" result="pushoverResult">
                    <cfhttpparam type="formfield" name="token" value="#pushoverApiToken#">
                    <cfhttpparam type="formfield" name="user" value="#pushoverUserKey#">
                    <cfhttpparam type="formfield" name="title" value="Hermes SEG: Mailqueue Check Error">
                    <cfhttpparam type="formfield" name="message" value="Hermes SEG encountered an error while attempting to check the mailqueue. Error: #cfcatch.message#">
                    <cfhttpparam type="formfield" name="priority" value="1">
                    <cfhttpparam type="formfield" name="sound" value="siren">
                </cfhttp>
            <cfcatch type="any">
                <!--- Pushover failed, continue to email --->
            </cfcatch>
            </cftry>
        </cfif>

        <!--- SEND ERROR NOTIFICATION VIA EMAIL --->
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


<cfif mailqueuecount GT 20>

    <!--- SEND WARNING NOTIFICATION VIA PUSHOVER (if configured) --->
    <cfif pushoverConfigured>
        <cftry>
            <cfhttp url="https://api.pushover.net/1/messages.json" method="POST" result="pushoverResult">
                <cfhttpparam type="formfield" name="token" value="#pushoverApiToken#">
                <cfhttpparam type="formfield" name="user" value="#pushoverUserKey#">
                <cfhttpparam type="formfield" name="title" value="Hermes SEG: Mail Queue Warning">
                <cfhttpparam type="formfield" name="message" value="Mail queue has #mailqueuecount# messages. This could indicate a problem with e-mail delivery. Check System > Mail Queue in the Admin Console.">
                <cfhttpparam type="formfield" name="url" value="https://#getconsolehost.value2#/admin/2/">
                <cfhttpparam type="formfield" name="url_title" value="Open Admin Console">
                <cfhttpparam type="formfield" name="priority" value="1">
                <cfhttpparam type="formfield" name="sound" value="intermission">
            </cfhttp>
        <cfcatch type="any">
            <!--- Pushover failed, continue to email --->
        </cfcatch>
        </cftry>
    </cfif>

    <!--- SEND WARNING NOTIFICATION VIA EMAIL --->
    <cfmail from="#getpostmaster.value#" to="#getadmin.value#" server="hermes_postfix_dkim" subject="[Hermes SEG] Warning Notification: Mail Queue Message Count" port="10026" type="html">
        <div align="center">
            <b>*** Please do not reply to this e-mail. This mailbox is not monitored ***</b><br><br>
            <h2>Hermes SEG Warning Notification</h2>
            Hermes SEG has detected #mailqueuecount# messages in the Mail Queue. This could indicate a problem with e-mail delivery. Please navigate to System --> Mail Queue in the Admin Console to investigate.<br><br>
        </div>
    </cfmail>

</cfif>

