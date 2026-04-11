<!DOCTYPE html>

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

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hermes SEG | Welcome</title>
  <cfinclude template="./inc/html_head.cfm" />
</head>

<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
<div class="app-wrapper">

  <cfinclude template="./inc/top_navbar.cfm" />
  <cfinclude template="./inc/main_sidebar.cfm" />

  <main class="app-main">
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <cfoutput>
            <h1 class="m-0">Welcome #session.theName#!</h1>
            <cfif StructKeyExists(session, "previous_login") AND IsDate(session.previous_login)>
              <small class="text-muted"><i class="fas fa-clock me-1"></i>Last login: #DateTimeFormat(session.previous_login, "yyyy/mm/dd HH:nn")#</small>
            <cfelseif StructKeyExists(session, "previous_login")>
              <small class="text-muted"><i class="fas fa-clock me-1"></i>Last login: First login</small>
            </cfif>
            </cfoutput>
          </div>
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-end">
              <li class="breadcrumb-item"><a href="##">Home</a></li>
              <li class="breadcrumb-item active">Home</li>
            </ol>
          </div>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="container-fluid">

<cfset isMailboxUser = session.theGroups CONTAINS "mailboxes">

<!--- ===== VACATION AUTO-REPLY STATUS ===== --->
<!--- Show a top-of-dashboard banner if the user has an active vacation
     auto-reply, so they can't accidentally leave it on after returning. --->
<cfif isMailboxUser>
    <!--- Active = enabled + within date window. Stored times are user-local
         wall clock; compare against "now in user TZ" for an accurate banner. --->
    <cfinclude template="../../admin/2/inc/get_user_timezone.cfm">
    <cfset bannerUserTz = getUserTimezone(session.email)>
    <cfquery name="getActiveVacation" datasource="hermes">
        SELECT subject, start_date, end_date
        FROM user_vacation
        WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
          AND enabled = 1
    </cfquery>
    <cfset showBanner = false>
    <cfif getActiveVacation.recordcount GTE 1>
        <cfset showBanner = true>
        <cftry>
            <cfset nowUserTz = convertFromUTC(DateConvert("local2utc", Now()), bannerUserTz, "yyyy-MM-dd HH:mm:ss")>
            <cfif IsDate(getActiveVacation.start_date) AND DateCompare(nowUserTz, getActiveVacation.start_date) LT 0>
                <cfset showBanner = false>
            </cfif>
            <cfif IsDate(getActiveVacation.end_date) AND DateCompare(nowUserTz, getActiveVacation.end_date) GT 0>
                <cfset showBanner = false>
            </cfif>
        <cfcatch type="any"></cfcatch>
        </cftry>
    </cfif>
    <cfif showBanner>
        <cfoutput>
        <div class="alert alert-success alert-dismissible">
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
          <h5 class="mb-1"><i class="icon fas fa-paper-plane me-2"></i>Vacation auto-reply is ACTIVE</h5>
          <p class="mb-0">
            <cfif IsDate(getActiveVacation.end_date)>
              Auto-reply is currently being sent to incoming mail until #DateFormat(getActiveVacation.end_date, "yyyy/mm/dd")# #TimeFormat(getActiveVacation.end_date, "HH:mm")# (#bannerUserTz#).
            <cfelse>
              Auto-reply is currently being sent to incoming mail.
            </cfif>
            <a href="view_vacation.cfm" class="alert-link">Manage</a>
          </p>
        </div>
        </cfoutput>
    </cfif>
</cfif>

<!--- ===== GATHER STATS ===== --->

<!--- Quarantined messages (last 24 hours - matches view_message_history default window) --->
<cfset quarantineCount = 0>
<cfif isDefined("session.owner") AND session.owner GT 0>
    <cfquery name="getQuarantineCount" datasource="hermes">
        SELECT COUNT(DISTINCT msgs.mail_id) AS cnt
        FROM msgs
        INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id
        WHERE msgrcpt.rid = <cfqueryparam value="#session.owner#" cfsqltype="cf_sql_integer">
        AND msgs.time_iso >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
        AND msgs.content IN ('S','V','B','U')
    </cfquery>
    <cfif getQuarantineCount.recordcount GTE 1>
        <cfset quarantineCount = getQuarantineCount.cnt>
    </cfif>
</cfif>

<!--- Total messages last 24 hours --->
<cfset totalMessages = 0>
<cfif isDefined("session.owner") AND session.owner GT 0>
    <cfquery name="getTotalMessages" datasource="hermes">
        SELECT COUNT(DISTINCT msgs.mail_id) AS cnt
        FROM msgs
        INNER JOIN msgrcpt ON msgs.mail_id = msgrcpt.mail_id
        WHERE msgrcpt.rid = <cfqueryparam value="#session.owner#" cfsqltype="cf_sql_integer">
        AND msgs.time_iso >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
    </cfquery>
    <cfif getTotalMessages.recordcount GTE 1>
        <cfset totalMessages = getTotalMessages.cnt>
    </cfif>
</cfif>

<!--- Sender filter count --->
<cfset senderFilterCount = 0>
<cfif isDefined("session.owner") AND session.owner GT 0>
    <cfquery name="getSenderFilters" datasource="hermes">
        SELECT COUNT(*) AS cnt FROM wblist WHERE rid = <cfqueryparam value="#session.owner#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif getSenderFilters.recordcount GTE 1>
        <cfset senderFilterCount = getSenderFilters.cnt>
    </cfif>
</cfif>

<!--- Mail filter count (mailbox users only) --->
<cfset mailFilterCount = 0>
<cfif isMailboxUser>
    <cfquery name="getMailFilters" datasource="hermes">
        SELECT COUNT(*) AS cnt FROM sieve_rules
        WHERE scope = 'user' AND username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif getMailFilters.recordcount GTE 1>
        <cfset mailFilterCount = getMailFilters.cnt>
    </cfif>
</cfif>

<!--- Mailbox quota usage (mailbox users only) --->
<cfset quotaUsedGb = 0>
<cfset quotaLimitGb = 0>
<cfset quotaPct = 0>
<cfif isMailboxUser>
    <cfquery name="getMailbox" datasource="hermes">
        SELECT quota FROM mailboxes WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif getMailbox.recordcount GTE 1 AND getMailbox.quota GT 0>
        <cfset quotaLimitGb = getMailbox.quota / 1024 / 1024 / 1024>
        <!--- Get used quota from quota2 table (Dovecot quota tracking) --->
        <cftry>
            <cfquery name="getUsed" datasource="hermes">
                SELECT bytes FROM quota2 WHERE username = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
            </cfquery>
            <cfif getUsed.recordcount GTE 1>
                <cfset quotaUsedGb = getUsed.bytes / 1024 / 1024 / 1024>
                <cfif quotaLimitGb GT 0>
                    <cfset quotaPct = Round((quotaUsedGb / quotaLimitGb) * 100)>
                </cfif>
            </cfif>
        <cfcatch type="any">
            <!--- quota2 table may not exist or be populated yet --->
        </cfcatch>
        </cftry>
    </cfif>
</cfif>

<!--- ===== STATS CARDS ===== --->
<cfoutput>
<div class="row">
    <div class="col-lg-3 col-6">
        <div class="small-box text-bg-warning">
            <div class="inner">
                <h3>#quarantineCount#</h3>
                <p>Quarantined (24h)</p>
            </div>
            <span class="small-box-icon"><i class="fas fa-shield-alt"></i></span>
            <a href="view_message_history.cfm" class="small-box-footer link-light link-underline-opacity-0 link-underline-opacity-50-hover">
                View History <i class="fas fa-arrow-circle-right"></i>
            </a>
        </div>
    </div>
    <div class="col-lg-3 col-6">
        <div class="small-box text-bg-success">
            <div class="inner">
                <h3>#totalMessages#</h3>
                <p>Total Messages (24h)</p>
            </div>
            <span class="small-box-icon"><i class="fas fa-envelope"></i></span>
            <a href="view_message_history.cfm" class="small-box-footer link-light link-underline-opacity-0 link-underline-opacity-50-hover">
                View All <i class="fas fa-arrow-circle-right"></i>
            </a>
        </div>
    </div>
    <div class="col-lg-3 col-6">
        <div class="small-box text-bg-info">
            <div class="inner">
                <h3>#senderFilterCount#</h3>
                <p>Sender Filters</p>
            </div>
            <span class="small-box-icon"><i class="fas fa-filter"></i></span>
            <a href="view_sender_filters.cfm" class="small-box-footer link-light link-underline-opacity-0 link-underline-opacity-50-hover">
                Manage <i class="fas fa-arrow-circle-right"></i>
            </a>
        </div>
    </div>
    <cfif isMailboxUser>
    <div class="col-lg-3 col-6">
        <div class="small-box text-bg-primary">
            <div class="inner">
                <h3>#mailFilterCount#</h3>
                <p>Mail Filters</p>
            </div>
            <span class="small-box-icon"><i class="fas fa-cogs"></i></span>
            <a href="view_sieve_rules.cfm" class="small-box-footer link-light link-underline-opacity-0 link-underline-opacity-50-hover">
                Manage <i class="fas fa-arrow-circle-right"></i>
            </a>
        </div>
    </div>
    <cfelse>
    <div class="col-lg-3 col-6">
        <div class="small-box text-bg-secondary">
            <div class="inner">
                <h3>Account</h3>
                <p>Settings &amp; Profile</p>
            </div>
            <span class="small-box-icon"><i class="fas fa-user-cog"></i></span>
            <a href="user_settings.cfm" class="small-box-footer link-light link-underline-opacity-0 link-underline-opacity-50-hover">
                Manage <i class="fas fa-arrow-circle-right"></i>
            </a>
        </div>
    </div>
    </cfif>
</div>
</cfoutput>

<!--- ===== MAILBOX QUOTA (mailbox users only) ===== --->
<cfif isMailboxUser AND quotaLimitGb GT 0>
<cfoutput>
<div class="card card-outline card-info mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-database me-2"></i>Mailbox Storage</h3>
    </div>
    <div class="card-body">
        <div class="d-flex justify-content-between mb-2">
            <span>
                <strong>#NumberFormat(quotaUsedGb, "0.00")# GB</strong> used of
                <strong>#NumberFormat(quotaLimitGb, "0.0")# GB</strong>
            </span>
            <span class="text-muted">#quotaPct#%</span>
        </div>
        <div class="progress" style="height: 20px;">
            <div class="progress-bar
                <cfif quotaPct GTE 90>bg-danger
                <cfelseif quotaPct GTE 75>bg-warning
                <cfelse>bg-success</cfif>"
                role="progressbar"
                style="width: #quotaPct#%;"
                aria-valuenow="#quotaPct#" aria-valuemin="0" aria-valuemax="100">
                #quotaPct#%
            </div>
        </div>
        <cfif quotaPct GTE 90>
        <div class="alert alert-danger mt-3 mb-0">
            <i class="fas fa-exclamation-triangle me-2"></i>
            Your mailbox is almost full. Delete old messages or contact your administrator to increase your quota.
        </div>
        <cfelseif quotaPct GTE 75>
        <div class="alert alert-warning mt-3 mb-0">
            <i class="fas fa-exclamation-circle me-2"></i>
            Your mailbox is filling up. Consider archiving or deleting old messages.
        </div>
        </cfif>
    </div>
</div>
</cfoutput>
</cfif>

<!--- ===== QUICK LINKS - matches sidebar order exactly ===== --->
<div class="card card-outline card-primary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-th-large me-2"></i>Quick Links</h3>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-4 col-sm-6 mb-3">
                <a href="report_settings.cfm" class="btn btn-outline-primary btn-block w-100">
                    <i class="fas fa-bell me-2"></i>Notification Settings
                </a>
            </div>
            <div class="col-md-4 col-sm-6 mb-3">
                <a href="view_sender_filters.cfm" class="btn btn-outline-primary btn-block w-100">
                    <i class="fas fa-filter me-2"></i>Sender Filters
                </a>
            </div>
            <div class="col-md-4 col-sm-6 mb-3">
                <a href="user_settings.cfm" class="btn btn-outline-primary btn-block w-100">
                    <i class="fas fa-cog me-2"></i>Account Settings
                </a>
            </div>
            <div class="col-md-4 col-sm-6 mb-3">
                <a href="view_message_history.cfm" class="btn btn-outline-primary btn-block w-100">
                    <i class="fas fa-history me-2"></i>Message History
                </a>
            </div>
            <cfif isMailboxUser>
            <div class="col-md-4 col-sm-6 mb-3">
                <a href="view_sieve_rules.cfm" class="btn btn-outline-primary btn-block w-100">
                    <i class="fas fa-filter me-2"></i>Mail Filters
                </a>
            </div>
            <div class="col-md-4 col-sm-6 mb-3">
                <a href="/nc/" class="btn btn-outline-primary btn-block w-100">
                    <i class="fas fa-inbox me-2"></i>Login to Webmail
                </a>
            </div>
            </cfif>
        </div>
    </div>
</div>

<!--- ===== ACCOUNT INFO ===== --->
<cfquery name="getAccountInfo" datasource="hermes">
    SELECT auth_type, recipient_type FROM recipients WHERE recipient = <cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfoutput>
<div class="card card-outline card-secondary mb-4">
    <div class="card-header">
        <h3 class="card-title"><i class="fas fa-user-circle me-2"></i>Account Information</h3>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-6">
                <p class="mb-2"><strong>Email:</strong> #session.email#</p>
                <p class="mb-2"><strong>Display Name:</strong> #session.theName#</p>
            </div>
            <div class="col-md-6">
                <p class="mb-2"><strong>Account Type:</strong>
                    <cfif isMailboxUser>
                        <span class="badge bg-primary">Mailbox</span>
                    <cfelse>
                        <span class="badge bg-info">Relay</span>
                    </cfif>
                </p>
                <cfif getAccountInfo.recordcount GTE 1>
                <p class="mb-2"><strong>Authentication:</strong>
                    <cfif getAccountInfo.auth_type EQ "remote">
                        <span class="badge bg-info">Remote (SSO)</span>
                    <cfelse>
                        <span class="badge bg-secondary">Local Password</span>
                    </cfif>
                </p>
                </cfif>
            </div>
        </div>
    </div>
</div>
</cfoutput>

      </div>
    </div>
  </main>

  <cfinclude template="./inc/main_footer.cfm" />

</div>

</body>
</html>
