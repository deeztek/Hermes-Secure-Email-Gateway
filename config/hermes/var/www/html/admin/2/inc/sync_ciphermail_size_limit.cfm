<!---
Hermes Secure Email Gateway - CipherMail message size sync (#396)

CipherMail runs its own Postfix, which ships with a 10 MB limit on the
port Amavis delivers to. Anything larger that Hermes had already accepted
bounced there with "552 5.3.4 message file too big". This sets CipherMail's
limits from the Perimeter Checks message size:

  before filter = Hermes limit + 10% (headers Amavis adds), never below
                  CipherMail's shipped 10240000
  after filter  = 3x before (the ratio CipherMail ships with; encryption
                  and signing grow the message)

The value is also written to /opt/hermes/config/ciphermail_size_limit,
which the CipherMail entrypoint applies at start, because /etc/postfix in
that container is not a volume and a recreate would otherwise bring back
10 MB.

Called from generate_postfix_configuration.cfm, so it runs on every
Perimeter Checks save and on every upgrade. Never fatal: a failure is
logged and Postfix configuration carries on.
--->

<cftry>
    <cfquery name="cmSizeLimit" datasource="hermes">
        SELECT parameter FROM parameters
        WHERE parent_name = <cfqueryparam value="message_size_limit" cfsqltype="cf_sql_varchar"> AND child = '1' AND enabled = '1'
        ORDER BY order1 ASC
        LIMIT 1
    </cfquery>

    <cfif cmSizeLimit.recordcount EQ 1 AND IsValid("integer", Trim(cmSizeLimit.parameter)) AND Trim(cmSizeLimit.parameter) GT 0>
        <cfset cmBefore = Max(10240000, Int(Trim(cmSizeLimit.parameter) * 1.1))>
        <cfset cmAfter = cmBefore * 3>

        <cffile action="write" file="/opt/hermes/config/ciphermail_size_limit" output="#cmBefore#" addnewline="yes" charset="utf-8">

        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_ciphermail postconf -e djigzo_before_filter_message_size_limit=#cmBefore# djigzo_calculated_after_filter_message_size_limit=#cmAfter#"
            variable="cmPostconfOut"
            errorVariable="cmPostconfErr"
            timeout="30" />
        <cfexecute name="/usr/local/bin/docker"
            arguments="exec hermes_ciphermail postfix reload"
            variable="cmReloadOut"
            errorVariable="cmReloadErr"
            timeout="30" />
    <cfelse>
        <cflog file="hermes" type="warning"
               text="sync_ciphermail_size_limit: no valid message_size_limit in parameters; CipherMail left unchanged">
    </cfif>
<cfcatch type="any">
    <cflog file="hermes" type="error"
           text="sync_ciphermail_size_limit: #cfcatch.message#">
</cfcatch>
</cftry>
