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

  <!--- Process each selected message --->
  <cfloop index="msgId" list="#form.msg_id#" delimiters=",">
    <cfset msgId = trim(msgId)>
    <cfif msgId is not "">
      <cftry>
        <cfexecute name="/usr/local/bin/docker"
          arguments="exec hermes_postfix_dkim /usr/sbin/postsuper #psFlag# #msgId#"
          timeout="240"
          variable="psOutput"
          errorVariable="psError" />

        <cfif psOutput contains "1 message" OR psOutput is "">
          <cfset session[successKey] = session[successKey] + 1>
          <cfset session[successEmailKey] = session[successEmailKey] & msgId & "<br>">
        <cfelse>
          <cfset session[failureKey] = session[failureKey] + 1>
          <cfset session[failureEmailKey] = session[failureEmailKey] & msgId & "<br>">
        </cfif>

        <cfcatch type="any">
          <cfset session[failureKey] = session[failureKey] + 1>
          <cfset session[failureEmailKey] = session[failureEmailKey] & msgId & "<br>">
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
