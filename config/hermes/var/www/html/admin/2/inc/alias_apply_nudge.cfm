<!---
Hermes Secure Email Gateway - what was applied after a hand edit

Included by the manual add / skip / remove alerts on view_network_aliases.cfm.

The ranges changed and the consumers that reference this alias were regenerated
straight away, each independently. This says which, and says plainly when one
failed, because a failure is the case where the operator has to do something.

A consumer that failed is NOT stamped as applied, so it stays listed in the
"not applied yet" callout and on the dashboard until it succeeds. This message
is a convenience; that callout is the thing that persists.

Expects: session.alias_apply_results from inc/alias_apply_consumers.cfm.
Clears it so the report shows once.
--->
<cfif StructKeyExists(session, "alias_apply_results") AND IsArray(session.alias_apply_results)
      AND ArrayLen(session.alias_apply_results)>
  <cfoutput>
    <hr>
    <p class="mb-1"><strong>Applied automatically:</strong></p>
    <ul class="mb-0">
      <cfloop array="#session.alias_apply_results#" index="oneApplied">
        <li>
          <cfif oneApplied.ok>
            #EncodeForHTML(oneApplied.consumer)# <span class="text-success">ok</span>
          <cfelse>
            #EncodeForHTML(oneApplied.consumer)#
            <span class="text-danger"><strong>failed</strong></span><cfif Len(Trim(oneApplied.error))>: #EncodeForHTML(oneApplied.error)#</cfif>
          </cfif>
        </li>
      </cfloop>
    </ul>
  </cfoutput>
</cfif>
<cfset session.alias_apply_results = ArrayNew(1)>
