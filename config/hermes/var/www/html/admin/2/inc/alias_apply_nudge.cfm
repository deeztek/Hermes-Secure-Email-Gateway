<!---
Hermes Secure Email Gateway - "now go apply it" nudge for a hand-edited alias

Included by the manual add / skip / remove alerts on view_network_aliases.cfm.

The ranges an alias means just changed and nothing regenerated. That is the same
state the scheduled resolver reports by email, and it needs the same nudge: a
hand edit makes every consumer's rendered file stale exactly as a provider
moving their ranges does. Telling the operator only when the resolver did it
would leave the promise of the feature half kept.

No email here. The operator who made the change is looking at this page, so
mailing them about their own edit in the same session is noise. The resolver
mails because nobody is present when it runs.

Expects: session.alias_touched (alias NAME), and aliasConsumerList from
inc/get_network_aliases.cfm. Clears session.alias_touched so the nudge shows
once. An alias nobody references renders nothing.
--->
<cfif StructKeyExists(session, "alias_touched") AND Len(Trim(session.alias_touched))
      AND StructKeyExists(aliasConsumerList, session.alias_touched)>
  <cfoutput>
    <hr>
    <p class="mb-1">
      <strong>Nothing has been applied.</strong> This alias is referenced by the
      page<cfif ArrayLen(aliasConsumerList[session.alias_touched]) GT 1>s</cfif>
      below. Its ranges there do not change until you apply on each one:
    </p>
    <ul class="mb-0">
      <cfloop array="#aliasConsumerList[session.alias_touched]#" index="oneConsumer">
        <li><a href="#oneConsumer.page#" class="alert-link">#EncodeForHTML(oneConsumer.text)#</a></li>
      </cfloop>
    </ul>
  </cfoutput>
</cfif>
<cfset session.alias_touched = "">
