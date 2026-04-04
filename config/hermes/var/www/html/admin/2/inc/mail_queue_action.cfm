<!---
Hermes Secure Email Gateway - Mail Queue Action Handler
Handles hold, unhold, requeue, delete, flush, and settings actions.
Expects: form.action, form.msg_id (comma-separated for message actions)
--->

<cfif action is "hold" OR action is "unhold" OR action is "requeue" OR action is "delete_msg">
  <!--- Message actions require msg_id --->
  <cfif NOT StructKeyExists(form, "msg_id") OR trim(form.msg_id) is "">
    <cfset session.m = 1>
    <cflocation url="view_mail_queue.cfm" addtoken="no">
  </cfif>

  <!--- Map action to postsuper flag and session keys --->
  <cfswitch expression="#action#">
    <cfcase value="hold">
      <cfset psFlag = "-h">
      <cfset mCode = 3>
      <cfset successKey = "successholdmessage">
      <cfset successEmailKey = "successholdmessage_email">
      <cfset failureKey = "failureholdmessage">
      <cfset failureEmailKey = "failureholdmessage_email">
      <cfset actionLabel = "held">
    </cfcase>
    <cfcase value="unhold">
      <cfset psFlag = "-H">
      <cfset mCode = 5>
      <cfset successKey = "successunholdmessage">
      <cfset successEmailKey = "successunholdmessage_email">
      <cfset failureKey = "failureunholdmessage">
      <cfset failureEmailKey = "failureunholdmessage_email">
      <cfset actionLabel = "unheld">
    </cfcase>
    <cfcase value="requeue">
      <cfset psFlag = "-r">
      <cfset mCode = 4>
      <cfset successKey = "successrequeuemessage">
      <cfset successEmailKey = "successrequeuemessage_email">
      <cfset failureKey = "failurerequeuemessage">
      <cfset failureEmailKey = "failurerequeuemessage_email">
      <cfset actionLabel = "re-queued">
    </cfcase>
    <cfcase value="delete_msg">
      <cfset psFlag = "-d">
      <cfset mCode = 6>
      <cfset successKey = "successdeletemessage">
      <cfset successEmailKey = "successdeletemessage_email">
      <cfset failureKey = "failuredeletemessage">
      <cfset failureEmailKey = "failuredeletemessage_email">
      <cfset actionLabel = "deleted">
    </cfcase>
  </cfswitch>

  <!--- Initialize counters --->
  <cfset session[successKey] = 0>
  <cfset session[successEmailKey] = "">
  <cfset session[failureKey] = 0>
  <cfset session[failureEmailKey] = "">

  <!--- Process each selected message via temp script (postsuper outputs to stderr) --->
  <cfinclude template="./generate_customtrans.cfm">

  <cfloop index="msgId" list="#form.msg_id#" delimiters=",">
    <cfset msgId = trim(msgId)>
    <!--- Validate queue ID: hex only, no shell injection --->
    <cfif msgId is not "" AND REFind("^[A-Fa-f0-9]+$", msgId)>
      <cftry>
        <!--- Write temp script to capture stderr --->
        <cfset scriptContent = "##!/bin/bash" & chr(10) & "/usr/local/bin/docker exec hermes_postfix_dkim /usr/sbin/postsuper " & psFlag & " " & msgId & " 2>&1">
        <cfset scriptPath = "/opt/hermes/tmp/#customtrans3#_postsuper.sh">
        <cffile action="write" file="#scriptPath#" output="#scriptContent#" addnewline="no">
        <cfexecute name="/bin/chmod" arguments="+x #scriptPath#" timeout="10" />

        <cfexecute name="#scriptPath#"
          timeout="240"
          variable="psOutput" />

        <!--- Clean up temp script --->
        <cffile action="delete" file="#scriptPath#">

        <!--- postsuper outputs "postsuper: <queueid>: <action>" on success --->
        <cfif psOutput contains msgId>
          <cfset session[successKey] = session[successKey] + 1>
          <cfset session[successEmailKey] = session[successEmailKey] & msgId & "<br>">
        <cfelse>
          <cfset session[failureKey] = session[failureKey] + 1>
          <cfset session[failureEmailKey] = session[failureEmailKey] & msgId & ": " & encodeForHTML(trim(psOutput)) & "<br>">
        </cfif>

        <cfcatch type="any">
          <cfset session[failureKey] = session[failureKey] + 1>
          <cfset session[failureEmailKey] = session[failureEmailKey] & msgId & ": " & encodeForHTML(cfcatch.message) & "<br>">
        </cfcatch>
      </cftry>
    </cfif>
  </cfloop>

  <cfset session.m = mCode>
  <cflocation url="view_mail_queue.cfm" addtoken="no">

<cfelseif action is "flush">
  <cfinclude template="./mail_queue_flush_mailqueue.cfm">
  <cflocation url="view_mail_queue.cfm" addtoken="no">

<cfelseif action is "save_settings">
  <!--- Validate bounce queue --->
  <cfif NOT StructKeyExists(form, "bouncequeue") OR NOT IsValid("integer", form.bouncequeue)>
    <cfset session.m = 20>
    <cflocation url="view_mail_queue.cfm" addtoken="no">
  </cfif>
  <cfif NOT StructKeyExists(form, "maxqueue") OR NOT IsValid("integer", form.maxqueue)>
    <cfset session.m = 20>
    <cflocation url="view_mail_queue.cfm" addtoken="no">
  </cfif>

  <cfinclude template="./mail_queue_set_queue_settings.cfm">
  <cfinclude template="./generate_postfix_configuration.cfm">

  <cfset session.m = 9>
  <cflocation url="view_mail_queue.cfm" addtoken="no">
</cfif>
