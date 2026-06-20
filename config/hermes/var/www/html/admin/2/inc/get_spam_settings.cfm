
<!---
Hermes Secure Email Gateway - Get Spam Settings
Reads all spam filter configuration from the spam_settings table.
--->

<cfquery name="get_use_bayes" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='use_bayes' AND active='1'
</cfquery>
<cfquery name="get_bayes_auto_learn" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='bayes_auto_learn' AND active='1'
</cfquery>
<cfquery name="get_bayes_spam_threshold" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='bayes_auto_learn_threshold_spam' AND active='1'
</cfquery>
<cfquery name="get_bayes_nonspam_threshold" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='bayes_auto_learn_threshold_nonspam' AND active='1'
</cfquery>
<cfquery name="get_use_dcc" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='use_dcc' AND active='1'
</cfquery>
<cfquery name="get_use_razor2" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='use_razor2' AND active='1'
</cfquery>
<cfquery name="get_use_pyzor" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='use_pyzor' AND active='1'
</cfquery>
<cfquery name="get_spam_subject_tag" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='sa_spam_subject_tag' AND active='1'
</cfquery>
<cfquery name="get_final_virus_destiny" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='final_virus_destiny' AND active='1'
</cfquery>
<cfquery name="get_final_banned_destiny" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='final_banned_destiny' AND active='1'
</cfquery>
<cfquery name="get_final_spam_destiny" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='final_spam_destiny' AND active='1'
</cfquery>
<cfquery name="get_final_bad_header_destiny" datasource="hermes">
  SELECT value FROM spam_settings WHERE parameter='final_bad_header_destiny' AND active='1'
</cfquery>
