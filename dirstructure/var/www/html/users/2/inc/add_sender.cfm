
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

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
    select id, recipient from recipients where recipient='#session.email#'
    </cfquery>

    <cfset recipient = #getrecipientid.id#>

    <cfquery name="checkexists" datasource="hermes">
    SELECT receiver, sender from mailaddr_temp where receiver='#session.email#' and sender='#theSender#'
    </cfquery>

    <cfif #checkexists.recordcount# LT 1>
    
    <cfquery name="checksenderemail" datasource="hermes">
    select id, email from mailaddr where email='#theSender#'
    </cfquery>
    
    <cfif #checksenderemail.recordcount# LT 1>
    
    <cfquery name="insertsender" datasource="hermes" result="stSender">
    insert into mailaddr
    (email)
    values
    ('#theSender#')
    </cfquery>

    <cfquery name="add" datasource="hermes" result="stResult">
    insert into mailaddr_temp
    (recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
    values
    ('#recipient#', '#stSender.GENERATED_KEY#', '#theSender#', '#theTypeText#', 'insert', '#session.email#', '1')
    </cfquery>
    
    <cfquery name="insertwb" datasource="hermes">
    insert into wblist
    (rid, sid, wb)
    values
    ('#recipient#', '#stSender.GENERATED_KEY#', '#theType#')
    </cfquery>

    <cfset step=0>
    <cfset session.m = 4>
    <cflocation url="view_sender_filters.cfm" addtoken="no">


    <cfelseif #checksenderemail.recordcount# GTE 1>

    <cfquery name="add" datasource="hermes" result="stResult">
    insert into mailaddr_temp
    (recipient_id, mailaddr_id, sender, wb, action, receiver, applied)
    values
    ('#recipient#', '#checksenderemail.id#', '#theSender#', '#theTypeText#', 'insert', '#session.email#', '1')
    </cfquery>
    
    <cfquery name="insertwb" datasource="hermes">
    insert into wblist
    (rid, sid, wb)
    values
    ('#recipient#', '#checksenderemail.id#', '#theType#')
    </cfquery>
    
    <cfset step=0>
    <cfset session.m = 4>
    <cflocation url="view_sender_filters.cfm" addtoken="no">
    
    <!--- /CFIF #checksenderemail.recordcount# --->
    </cfif>
    
    
    
    <cfelseif #checkexists.recordcount# GTE 1>

      <cfset step=0>
      <cfset session.m = 5>
      <cflocation url="view_sender_filters.cfm" addtoken="no">
    
    <!--- /CFIF #checkexists.recordcount# --->
    </cfif>
    