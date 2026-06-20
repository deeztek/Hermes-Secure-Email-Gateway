<!---
Hermes Secure Email Gateway - Random Transaction ID Generator
Generates a random string using lower case letters and digits.
Uses SHA1PRNG for cryptographically secure random numbers - no database queries.

Output: Sets variable "customtrans3" in the calling scope.

Usage:
    <cfinclude template="generate_customtrans.cfm">
    <!--- customtrans3 is now set (default 8 characters) --->

    <!--- Or set custom length before including: --->
    <cfset _transLength = 64>
    <cfinclude template="generate_customtrans.cfm">
    <!--- customtrans3 is now a 64-character string --->
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
