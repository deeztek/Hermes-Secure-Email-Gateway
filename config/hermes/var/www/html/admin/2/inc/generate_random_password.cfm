<!---
Hermes Secure Email Gateway - Random Password Generator
Generates a 16-character random password using upper/lower case letters and digits.
Uses SHA1PRNG for cryptographically secure random numbers - no database queries.

Output: Sets variable "generatedPassword" in the calling scope.

Usage:
    <cfinclude template="generate_random_password.cfm">
    <!--- generatedPassword is now set --->
--->

<cfset _pwdChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789">
<cfset generatedPassword = "">
<cfloop from="1" to="16" index="_pwdIdx">
    <cfset generatedPassword = generatedPassword & Mid(_pwdChars, RandRange(1, Len(_pwdChars), "SHA1PRNG"), 1)>
</cfloop>
