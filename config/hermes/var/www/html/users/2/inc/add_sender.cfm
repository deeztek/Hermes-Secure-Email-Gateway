
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2025. All Rights Reserved.

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

  <cfquery name="getrecipientid" datasource="hermes">
    SELECT id FROM recipients WHERE recipient=<cfqueryparam value="#session.email#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfif getrecipientid.recordcount LT 1>
    <cfset m="/inc/add_sender.cfm: Unable to get recipient id from recipients">
    <cfinclude template="error.cfm">
    <cfabort>
  </cfif>

  <cfset recipient = getrecipientid.id>

  <!--- Resolve or create mailaddr entry for sender --->
  <cfquery name="checksenderemail" datasource="hermes">
    SELECT id FROM mailaddr WHERE email=<cfqueryparam value="#theSender#" cfsqltype="cf_sql_varchar">
  </cfquery>

  <cfif checksenderemail.recordcount LT 1>
    <cfquery name="insertsender" datasource="hermes" result="stSender">
      INSERT INTO mailaddr (email) VALUES (<cfqueryparam value="#theSender#" cfsqltype="cf_sql_varchar">)
    </cfquery>
    <cfset senderMailaddrId = stSender.GENERATED_KEY>
  <cfelse>
    <cfset senderMailaddrId = checksenderemail.id>
  </cfif>

  <!--- Check for duplicate in wblist --->
  <cfquery name="checkexists" datasource="hermes">
    SELECT rid FROM wblist
    WHERE rid=<cfqueryparam value="#recipient#" cfsqltype="cf_sql_integer">
      AND sid=<cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">
  </cfquery>

  <cfif checkexists.recordcount GTE 1>
    <cfset step=0>
    <cfset session.m = 5>
    <cflocation url="view_sender_filters.cfm" addtoken="no">
  </cfif>

  <cfquery datasource="hermes">
    INSERT INTO wblist (rid, sid, wb)
    VALUES (
      <cfqueryparam value="#recipient#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#senderMailaddrId#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#theType#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>

  <cfset step=0>
  <cfset session.m = 4>
  <cflocation url="view_sender_filters.cfm" addtoken="no">
