<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.

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

<!--- FAILED CERTIFICATE / KEYRING JOBS: BANNER AND ROW LOOKUP (#364)

     Include where the page shows its messages, before the table. Renders the
     result of a retry / dismiss (inc/cert_queue_failures_action.cfm) and, when
     jobs have failed, a banner naming each recipient and the error.

     Sets failedJobMap for the rows: failedJobMap[lcase(email)][job_type] is
     the error message, job_type "smime" or "pgp". A failure used to show only
     as a count on Relay Recipients and not at all on Mailboxes, and the row
     read NO, the same as "never requested". --->

<cfquery name="getFailedJobs" datasource="hermes">
    SELECT recipient_email, job_type, error_message, created_at
    FROM cert_generation_queue
    WHERE status = 'failed'
    ORDER BY created_at DESC
</cfquery>

<cfset failedJobMap = {}>
<cfloop query="getFailedJobs">
    <cfset fjKey = LCase(getFailedJobs.recipient_email)>
    <cfif NOT StructKeyExists(failedJobMap, fjKey)>
        <cfset failedJobMap[fjKey] = {}>
    </cfif>
    <!--- Newest first, so the first error seen per type is the latest. --->
    <cfif NOT StructKeyExists(failedJobMap[fjKey], getFailedJobs.job_type)>
        <cfset failedJobMap[fjKey][getFailedJobs.job_type] = getFailedJobs.error_message>
    </cfif>
</cfloop>

<cfif StructKeyExists(session, "queueMessage")>
    <cfif session.queueMessage EQ "reset_success">
        <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            <h5><i class="icon fa fa-check"></i> Queue Reset</h5>
            Failed jobs have been reset to pending. They will be retried on the next processing cycle.
        </div>
    <cfelseif session.queueMessage EQ "dismiss_success">
        <div class="alert alert-success alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            <h5><i class="icon fa fa-check"></i> Failures Dismissed</h5>
            The failed jobs were closed without retrying.
        </div>
    <cfelseif session.queueMessage EQ "reset_error">
        <div class="alert alert-danger alert-dismissible">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            <h5><i class="icon fa fa-ban"></i> Error</h5>
            Failed to update the queue. Please try again.
        </div>
    </cfif>
    <cfset StructDelete(session, "queueMessage")>
</cfif>

<cfif getFailedJobs.recordcount GT 0>
    <cfset fjShown = Min(getFailedJobs.recordcount, 10)>
    <div class="alert alert-warning">
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
            <div>
                <h5><i class="icon fas fa-exclamation-triangle"></i> Generation Failures</h5>
                <cfoutput>#getFailedJobs.recordcount# certificate(s)/keyring(s) failed to generate.</cfoutput>
            </div>
            <div class="d-flex gap-2">
                <form method="post" action="">
                    <input type="hidden" name="action" value="reset_failed_queue">
                    <button type="submit" class="btn btn-sm btn-outline-dark" onclick="return confirm('Retry all failed jobs? They will run on the next processing cycle. A recipient that already has a certificate or keyring is skipped.')">
                        <i class="fas fa-redo me-1"></i>Retry Failed Jobs
                    </button>
                </form>
                <form method="post" action="">
                    <input type="hidden" name="action" value="dismiss_failed_queue">
                    <button type="submit" class="btn btn-sm btn-outline-dark" onclick="return confirm('Dismiss all failed jobs without retrying them?')">
                        <i class="fas fa-times me-1"></i>Dismiss
                    </button>
                </form>
            </div>
        </div>
        <table class="table table-sm table-borderless mb-0 mt-2" style="background: transparent;">
            <thead><tr><th>Recipient</th><th>Type</th><th>Failed</th><th>Error</th></tr></thead>
            <tbody>
            <cfoutput query="getFailedJobs" maxrows="#fjShown#">
                <tr>
                    <td>#EncodeForHTML(recipient_email)#</td>
                    <td><cfif job_type EQ "smime">S/MIME<cfelse>PGP</cfif></td>
                    <td class="text-nowrap">#DateFormat(created_at, "yyyy-mm-dd")# #TimeFormat(created_at, "HH:mm")#</td>
                    <td><small>#EncodeForHTML(Left(error_message, 200))#</small></td>
                </tr>
            </cfoutput>
            </tbody>
        </table>
        <cfif getFailedJobs.recordcount GT fjShown>
            <cfoutput><small>and #getFailedJobs.recordcount - fjShown# more; the affected rows are marked Failed in the table.</small></cfoutput>
        </cfif>
    </div>
</cfif>
