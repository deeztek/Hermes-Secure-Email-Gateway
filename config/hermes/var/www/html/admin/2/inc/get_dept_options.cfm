<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.
--->

<!---
DEPARTMENT OPTIONS HELPER (#226 Phase 2B).

Builds a per-domain map of distinct department names from the
mailboxes table. Used by:

  - edit_org_signature.cfm: strict <select> of dept names for the
    selected domain, so admins can only assign Org Sigs to depts
    that already have at least one mailbox in them. JS swaps the
    options when the domain selector changes.

  - view_mailboxes.cfm Edit Mailbox modal: <datalist> typeahead on
    the dept input. Admin can pick an existing dept or type a new
    one (mailbox is the source-of-truth for dept names).

Source query: SELECT DISTINCT department per domain. A department
"exists" once at least one mailbox is assigned to it - no separate
departments table.

Sets:
    variables.deptOptionsByDomain      - struct { "<domain_id>": ["Dept A", "Dept B", ...] }
    variables.deptOptionsByDomainJson  - SerializeJSON(deptOptionsByDomain)

Lucee SerializeJSON uppercases struct keys, but the keys here are
numeric strings so casing is irrelevant. Array values (dept names)
preserve case as expected.
--->

<cfquery name="deptOptionsRaw" datasource="hermes">
    SELECT m.domain_id, m.department
    FROM mailboxes m
    INNER JOIN domains d ON m.domain_id = d.id AND d.type = 'mailbox'
    WHERE m.department IS NOT NULL
      AND TRIM(m.department) != ''
    GROUP BY m.domain_id, m.department
    ORDER BY m.domain_id, m.department
</cfquery>

<cfset variables.deptOptionsByDomain = {}>
<cfloop query="deptOptionsRaw">
    <cfset deptOptDomKey = ToString(domain_id)>
    <cfif NOT StructKeyExists(variables.deptOptionsByDomain, deptOptDomKey)>
        <cfset variables.deptOptionsByDomain[deptOptDomKey] = []>
    </cfif>
    <cfset ArrayAppend(variables.deptOptionsByDomain[deptOptDomKey], Trim(department))>
</cfloop>

<cfset variables.deptOptionsByDomainJson = SerializeJSON(variables.deptOptionsByDomain)>
