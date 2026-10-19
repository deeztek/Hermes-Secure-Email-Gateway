<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
--->

<!---
PRO MILTER HEAL -- the counterpart of pro_milter_enforce.cfm.

pro_milter_enforce.cfm blanks the body-milter dispatch maps on a
server-confirmed license loss. If that loss was a one-off (a single INVALID
followed by VALID on the next check), nothing used to put the maps back:
Link Guard, disclaimers and organizational signatures stayed off until an
admin re-saved each page, usually without noticing.

Run on a VALID license (setsession.cfm after validation; message_cleanup.cfm
as the no-login backstop). For each feature, if its map is empty but the
database says it should have entries, re-run that feature's own
write-and-reload. This also heals maps torn down before this file existed.

Cost when nothing is wrong: three file reads. The database is only queried
when a map is empty, and each feature is rebuilt at most every 10 minutes.

Call with <cfmodule template="pro_milter_heal.cfm">, so the rebuild routines'
variables stay out of the caller's scope. Never throws.
--->

<cfif thisTag.executionMode NEQ "start"><cfexit method="exittag"></cfif>


<cffunction name="healMapEmpty" returntype="boolean" output="false">
    <cfargument name="path" type="string" required="true">
    <cfreturn NOT FileExists(arguments.path) OR Len(Trim(FileRead(arguments.path, "utf-8"))) EQ 0>
</cffunction>

<!--- At most one rebuild per feature per 10 minutes (application scope). --->
<cffunction name="healDue" returntype="boolean" output="false">
    <cfargument name="feature" type="string" required="true">
    <cfset var k = "proMilterHeal_" & arguments.feature>
    <cfif StructKeyExists(application, k) AND DateDiff("n", application[k], Now()) LT 10>
        <cfreturn false>
    </cfif>
    <cfset application[k] = Now()>
    <cfreturn true>
</cffunction>

<cftry>
    <cfset healRoot = "/etc/hermes/body_milter">
    <cfset healNow  = Now()>

    <!--- Link Guard: master switch on + enabled domains, but an empty scope map --->
    <cfif healMapEmpty(healRoot & "/linkguard/linkguard_by_recipient_domain")>
        <cfquery name="healLg" datasource="hermes">
            SELECT
              (SELECT COUNT(*) FROM parameters2 WHERE module = 'linkguard' AND parameter = 'enabled' AND value2 = '1') AS on_flag,
              (SELECT COUNT(*) FROM linkguard_domains WHERE enabled = 1) AS doms
        </cfquery>
        <cfif healLg.on_flag GT 0 AND healLg.doms GT 0 AND healDue("linkguard")>
            <cftry>
                <cfinclude template="linkguard_write_and_reload.cfm">
                <cflog file="hermes_pro_milter" type="information" text="pro_milter_heal: Link Guard scope map was empty; rebuilt">
                <cfcatch type="any">
                    <cflog file="hermes_pro_milter" type="error" text="pro_milter_heal: Link Guard rebuild failed: #cfcatch.message#">
                </cfcatch>
            </cftry>
        </cfif>
    </cfif>

    <!--- Disclaimers: enabled disclaimers, but an empty map --->
    <cfif healMapEmpty(healRoot & "/disclaimers/disclaimer_by_sender")>
        <cfquery name="healDisc" datasource="hermes">
            SELECT COUNT(*) AS n FROM disclaimers WHERE enabled = 1
        </cfquery>
        <cfif healDisc.n GT 0 AND healDue("disclaimers")>
            <cftry>
                <cfinclude template="disclaimer_write_and_reload.cfm">
                <cflog file="hermes_pro_milter" type="information" text="pro_milter_heal: disclaimer map was empty; rebuilt">
                <cfcatch type="any">
                    <cflog file="hermes_pro_milter" type="error" text="pro_milter_heal: disclaimer rebuild failed: #cfcatch.message#">
                </cfcatch>
            </cftry>
        </cfif>
    </cfif>

    <!--- Organizational signatures: enabled org signatures, but no org_ entry in
          the shared signature map (personal entries are free and never torn
          down, so the map itself may not be empty). --->
    <cfset healSigMap = healRoot & "/signatures/signature_by_sender">
    <cfset healSigHasOrg = FileExists(healSigMap) AND Find(Chr(9) & "org_", FileRead(healSigMap, "utf-8")) GT 0>
    <cfif NOT healSigHasOrg>
        <cfquery name="healOrg" datasource="hermes">
            SELECT COUNT(*) AS n FROM org_signatures WHERE enabled = 1
        </cfquery>
        <cfif healOrg.n GT 0 AND healDue("orgsignatures")>
            <cftry>
                <cfset signatureRegenSilent = true>
                <cfinclude template="signature_regen_map.cfm">
                <cflog file="hermes_pro_milter" type="information" text="pro_milter_heal: no organizational signature entries; signature map rebuilt">
                <cfcatch type="any">
                    <cflog file="hermes_pro_milter" type="error" text="pro_milter_heal: signature rebuild failed: #cfcatch.message#">
                </cfcatch>
            </cftry>
        </cfif>
    </cfif>

    <cfcatch type="any">
        <!--- never let healing break login or the scheduled cleanup --->
        <cflog file="hermes_pro_milter" type="error" text="pro_milter_heal: #cfcatch.message#">
    </cfcatch>
</cftry>
