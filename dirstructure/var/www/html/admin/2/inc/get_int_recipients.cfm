<!---
  <cfquery name="getrecipients" datasource="hermes">
    select id, recipient, policy_id, pdf_enabled, smime_enabled, pgp_enabled, digital_sign from recipients where domain is NULL
    </cfquery>
  --->

<cfquery name="getrecipients" datasource="hermes">
select recipients.id, recipients.id as theID, recipients.id as theOtherID, recipients.recipient, policy.policy_name, user_settings.report_enabled as report_enabled, user_settings.report_frequency as report_frequency, if(user_settings.train_bayes = 1, 'YES', 'NO') as train_bayes, if(user_settings.download_msg = 1, 'YES', 'NO') as download_msg, if(recipients.pdf_enabled = 1, 'YES', 'NO') as pdf_enabled, if(recipients.smime_enabled = '1', 'YES', 'NO') as smime_enabled, if(recipients.pgp_enabled = 1, 'YES', 'NO') as pgp_enabled, if(recipients.digital_sign = '1', 'YES', 'NO') as digital_sign, if(recipient_certificates.user_id is NULL, 'NO', 'YES') as cert, if(recipient_keystores.user_id is NULL, 'NO', 'YES') as keystore
from recipients LEFT JOIN policy ON recipients.policy_id = policy.id LEFT JOIN recipient_certificates ON recipients.id = recipient_certificates.user_id  LEFT JOIN recipient_keystores ON recipients.id = recipient_keystores.user_id  LEFT JOIN user_settings ON recipients.recipient = user_settings.email where recipients.domain is NULL group by recipients.id

</cfquery>

    <cfif #getrecipients.recordcount# GTE 1>
           

     <cfoutput>#serializeJSON(getrecipients)#</cfoutput>

        <cfelse>
        
        </cfif>
 