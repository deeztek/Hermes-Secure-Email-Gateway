
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
Uses SHA1PRNG for cryptographically secure random numbers - no database queries.
Returns: customtrans3 - a random string (default 8 characters, set _transLength before including for custom length)
--->

<cfif NOT isDefined("_transLength")>
    <cfset _transLength = 8>
</cfif>
<cfset _transChars = "abcdefghijklmnopqrstuvwxyz0123456789">
<cfset customtrans3 = "">
<cfloop from="1" to="#_transLength#" index="_transIdx">
    <cfset customtrans3 = customtrans3 & Mid(_transChars, RandRange(1, Len(_transChars), "SHA1PRNG"), 1)>
</cfloop>
<cfset _transLength = 8>
