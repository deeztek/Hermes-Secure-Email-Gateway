<!---
Hermes Secure Email Gateway - CIDR validation with a host-bit check

WHY THIS EXISTS

A CIDR whose host bits are not zero, such as 203.0.113.0/25 written when
203.0.113.0/24 was meant, is syntactically plausible and semantically wrong. A
/23 must start on an even third octet, a /25 on a multiple of 128, and so on. Every
validator in the console checked the octets were 0-255 and the prefix was in
range, and none checked this.

Postfix does not ignore it. In mynetworks it produces

    warning: mynetworks: non-null host address bits in "..."
    warning: postscreen_access_list: permit_mynetworks: mynetworks lookup error
             -- ignoring the remainder of this access list

so one mistyped range discards the ENTIRE postscreen access list, and mail
starts getting 451 Temporary lookup failure. In a cidr: map the affected rule is
skipped. Either way the operator has typed something that looks right, been told
it was accepted, and broken mail flow.

HOW THE CHECK WORKS

Per octet rather than as a 32-bit integer, because CFML's BitAnd is signed
32-bit and any address from 128.0.0.0 up overflows it.

For prefix p: the first int(p/8) octets are network, the next octet keeps its
top (p mod 8) bits, and everything below that must be zero.

IPv6 is validated for shape only. The mail containers filter it out at render
anyway, and doing the arithmetic properly needs full address expansion.

Returns a struct: ok, family ("ip4"/"ip6"/""), cidr (normalized), error, suggest.
A bare address is treated as a host route and given /32 or /128.
--->
<cffunction name="cidrCheck" returntype="struct" output="false">
  <cfargument name="value" type="string" required="true">

  <cfset var r = {ok = false, family = "", cidr = "", error = "", suggest = ""}>
  <cfset var v = Trim(arguments.value)>
  <cfset var parts = "">
  <cfset var addr = "">
  <cfset var prefix = 0>
  <cfset var octets = "">
  <cfset var i = 0>
  <cfset var fullBytes = 0>
  <cfset var restBits = 0>
  <cfset var keepMask = 0>
  <cfset var fixed = []>

  <cfif v is "">
    <cfset r.error = "empty">
    <cfreturn r>
  </cfif>

  <!--- A bare address is a host route; supply the prefix rather than rejecting. --->
  <cfif NOT Find("/", v)>
    <cfif REFind("^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$", v)>
      <cfset v = v & "/32">
    <cfelseif REFindNoCase("^[0-9a-f:]+$", v) AND Find(":", v)>
      <cfset v = v & "/128">
    <cfelse>
      <cfset r.error = "not an IP address or CIDR range">
      <cfreturn r>
    </cfif>
  </cfif>

  <cfset parts = ListToArray(v, "/")>
  <cfif ArrayLen(parts) NEQ 2 OR NOT IsNumeric(parts[2])>
    <cfset r.error = "malformed CIDR">
    <cfreturn r>
  </cfif>
  <cfset addr = parts[1]>
  <cfset prefix = Int(parts[2])>

  <!--- IPv6: shape only --->
  <cfif REFindNoCase("^[0-9a-f:]+$", addr) AND Find(":", addr)>
    <cfif prefix LT 0 OR prefix GT 128>
      <cfset r.error = "IPv6 prefix must be 0 to 128">
      <cfreturn r>
    </cfif>
    <cfset r.ok = true>
    <cfset r.family = "ip6">
    <cfset r.cidr = v>
    <cfreturn r>
  </cfif>

  <cfif NOT REFind("^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$", addr)>
    <cfset r.error = "not an IP address or CIDR range">
    <cfreturn r>
  </cfif>
  <cfif prefix LT 0 OR prefix GT 32>
    <cfset r.error = "IPv4 prefix must be 0 to 32">
    <cfreturn r>
  </cfif>
  <cfset octets = ListToArray(addr, ".")>
  <cfloop index="i" from="1" to="4">
    <cfif NOT IsNumeric(octets[i]) OR octets[i] LT 0 OR octets[i] GT 255>
      <cfset r.error = "octet out of range">
      <cfreturn r>
    </cfif>
    <cfset octets[i] = Int(octets[i])>
  </cfloop>

  <!--- Host bits. Build the corrected address as we go so the message can say
       what the operator almost certainly meant. --->
  <cfset fullBytes = Int(prefix / 8)>
  <cfset restBits  = prefix MOD 8>
  <cfloop index="i" from="1" to="4">
    <cfif i LTE fullBytes>
      <cfset ArrayAppend(fixed, octets[i])>
    <cfelseif i EQ (fullBytes + 1) AND restBits GT 0>
      <!--- keep the top restBits of this octet --->
      <cfset keepMask = 256 - (2 ^ (8 - restBits))>
      <cfset ArrayAppend(fixed, BitAnd(octets[i], keepMask))>
    <cfelse>
      <cfset ArrayAppend(fixed, 0)>
    </cfif>
  </cfloop>

  <cfset r.suggest = ArrayToList(fixed, ".") & "/" & prefix>
  <cfif r.suggest is not (ArrayToList(octets, ".") & "/" & prefix)>
    <cfset r.error = "has host bits set, so Postfix will reject it">
    <cfreturn r>
  </cfif>

  <cfset r.ok = true>
  <cfset r.family = "ip4">
  <cfset r.cidr = ArrayToList(octets, ".") & "/" & prefix>
  <cfset r.suggest = "">
  <cfreturn r>
</cffunction>
