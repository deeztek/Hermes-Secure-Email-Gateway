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

<!--- FAILED CERTIFICATE / KEYRING JOBS: RETRY OR DISMISS (#364)

     Include near the top of a page, before any output. Handles
       form.action = "reset_failed_queue"    every failed job back to pending
       form.action = "dismiss_failed_queue"  every failed job closed without retrying
     then redirects back to the page, so a refresh does not repeat it.

     Retry is safe after a certificate was created by hand: the processor
     marks such a job "Skipped - recipient already has ...". Dismissing marks
     the job completed with a note, so it ages out with the completed jobs. --->

<cfif StructKeyExists(form, "action") AND ListFindNoCase("reset_failed_queue,dismiss_failed_queue", form.action)>
    <cftry>
        <cfif form.action EQ "reset_failed_queue">
            <cfquery datasource="hermes">
                UPDATE cert_generation_queue
                SET status = 'pending', error_message = NULL, started_at = NULL
                WHERE status = 'failed'
            </cfquery>
            <cfset session.queueMessage = "reset_success">
        <cfelse>
            <cfquery datasource="hermes">
                UPDATE cert_generation_queue
                SET status = 'completed', completed_at = NOW(), password = NULL,
                    error_message = CONCAT('Dismissed by admin: ', COALESCE(error_message, ''))
                WHERE status = 'failed'
            </cfquery>
            <cfset session.queueMessage = "dismiss_success">
        </cfif>
    <cfcatch type="any">
        <cfset session.queueMessage = "reset_error">
    </cfcatch>
    </cftry>
    <cflocation url="#cgi.script_name#" addtoken="no">
</cfif>
