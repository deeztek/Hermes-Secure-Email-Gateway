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

<!---
DELETE EXTERNAL SENDER BANNER ACTION (#228).

GET ?id=N -> delete the row, then regenerate the body milter file set
to drop its on-disk artifacts. Confirmation happens client-side
on the list page (window.confirm).
--->

<cfparam name="url.id" default="0">

<cfif NOT IsNumeric(url.id) OR Val(url.id) LT 1>
    <cfset session.ext_banner_msg = "<strong>Delete failed.</strong> Invalid id.">
    <cfset session.ext_banner_msg_type = "danger">
    <cflocation url="view_external_banners.cfm" addtoken="no">
</cfif>

<cfquery name="getRow" datasource="hermes">
    SELECT id, recipient_domain
    FROM external_banners
    WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif getRow.recordcount LT 1>
    <cfset session.ext_banner_msg = "<strong>Already gone.</strong> Banner ID ##" & url.id & " was not found.">
    <cfset session.ext_banner_msg_type = "warning">
    <cflocation url="view_external_banners.cfm" addtoken="no">
</cfif>

<cfquery datasource="hermes">
    DELETE FROM external_banners WHERE id = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset variantLabel = Len(Trim(getRow.recipient_domain)) ? getRow.recipient_domain : "system default">
<cfset session.ext_banner_msg = "<strong>Deleted.</strong> External Sender Banner for " & HTMLEditFormat(variantLabel) & " removed.">
<cfset session.ext_banner_msg_type = "success">

<!--- Regenerate the body milter file set. Per-banner subdir for the
     deleted row gets wiped as a side effect of the regen's dir-wipe
     pass. --->
<cfinclude template="inc/external_banner_write_and_reload.cfm" />

<cflocation url="view_external_banners.cfm" addtoken="no">
