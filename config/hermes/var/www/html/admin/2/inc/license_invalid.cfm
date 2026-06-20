<!---
Hermes SEG - License Invalid / Bad-State Lockout
Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Rendered by inc/license_check.cfm for non-healthy license states:
  N/A        - No Pro license configured (Community user on a Pro page)
  EXPIRED    - License past expiration date
  REVOKED    - License revoked by the validation server
  INVALID    - License format / signature does not validate
  VIOLATION  - License registered to different hardware (UUID mismatch)

Visual style matches license_pro_required.cfm so all license-locked
pages render the same shape. license_check.cfm cfabort's immediately
after including this file, so this file must also close out the
page layout.
--->

<cfset licState = (StructKeyExists(session, "license") ? session.license : "N/A")>

<cfswitch expression="#licState#">
    <cfcase value="EXPIRED">
        <cfset lockTitle    = "Pro License Expired">
        <cfset lockHeadline = "Your Hermes SEG Pro license has expired.">
        <cfset lockSubtext  = "Pro features are locked until the license is renewed.">
        <cfset lockHelpLabel = "How to Renew">
    </cfcase>
    <cfcase value="REVOKED">
        <cfset lockTitle    = "Pro License Revoked">
        <cfset lockHeadline = "Your Hermes SEG Pro license has been revoked.">
        <cfset lockSubtext  = "Contact sales to resolve the revocation and re-enable Pro features.">
        <cfset lockHelpLabel = "How to Resolve">
    </cfcase>
    <cfcase value="INVALID">
        <cfset lockTitle    = "Pro License Invalid">
        <cfset lockHeadline = "Your Hermes SEG Pro license could not be validated.">
        <cfset lockSubtext  = "The license signature or format does not match what the validation server expects.">
        <cfset lockHelpLabel = "How to Resolve">
    </cfcase>
    <cfcase value="VIOLATION">
        <cfset lockTitle    = "Pro License Violation">
        <cfset lockHeadline = "Your Hermes SEG Pro license is registered to different hardware.">
        <cfset lockSubtext  = "The hardware signature on this host does not match the licensed installation.">
        <cfset lockHelpLabel = "How to Resolve">
    </cfcase>
    <cfdefaultcase>
        <cfset lockTitle    = "Pro License Required">
        <cfset lockHeadline = "This feature is only available with a valid Hermes SEG Pro License.">
        <cfset lockSubtext  = "Upgrade to Pro to unlock content checks, encryption policies, organizational signatures, and more.">
        <cfset lockHelpLabel = "How to Upgrade">
    </cfdefaultcase>
</cfswitch>

<div class="row justify-content-center">
    <div class="col-lg-8 col-xl-6">
        <div class="card card-outline card-warning">
            <div class="card-header text-center">
                <h3 class="card-title w-100">
                    <i class="fas fa-crown text-warning me-2"></i>
                    <cfoutput>#lockTitle#</cfoutput>
                </h3>
            </div>
            <div class="card-body text-center">
                <div class="mb-4">
                    <i class="fas fa-lock fa-5x text-secondary opacity-50"></i>
                </div>

                <h4 class="mb-3"><cfoutput>#lockHeadline#</cfoutput></h4>

                <p class="text-muted mb-4">
                    <cfoutput>#lockSubtext#</cfoutput>
                </p>

                <div class="alert alert-info text-start">
                    <h5><i class="fas fa-info-circle me-2"></i><cfoutput>#lockHelpLabel#</cfoutput></h5>
                    <p class="mb-2">Please contact:</p>
                    <ul class="mb-0">
                        <li>Email: <a href="mailto:sales@hermesseg.io">sales@hermesseg.io</a></li>
                        <li>Website: <a href="https://www.hermesseg.io" target="_blank">www.hermesseg.io</a></li>
                    </ul>
                </div>

                <div class="mt-4">
                    <a href="index.cfm" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Return to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

</div><!-- /.container-fluid -->
</div><!-- /.content -->
</main>

<cfinclude template="./main_footer.cfm" />

</div><!-- /.app-wrapper -->
</body>
</html>
