
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
GENERATE CUSTOMTRANS
Generates a unique random string for use in temporary filenames.
Returns: customtrans3 - an 8 character random string
--->

<cfquery name="customtrans" datasource="hermes" result="getrandom_results">
    SELECT random_letter as random FROM captcha_list_all2 ORDER BY RAND() LIMIT 8
</cfquery>

<cfquery name="inserttrans" datasource="hermes" result="stResult">
    INSERT INTO salt (salt) VALUES ('<cfoutput query="customtrans">#TRIM(random)#</cfoutput>')
</cfquery>

<cfquery name="gettrans" datasource="hermes">
    SELECT salt as customtrans2 FROM salt WHERE id='#stResult.GENERATED_KEY#'
</cfquery>

<cfset customtrans3 = gettrans.customtrans2>

<cfquery name="deletetrans" datasource="hermes">
    DELETE FROM salt WHERE id='#stResult.GENERATED_KEY#'
</cfquery>
