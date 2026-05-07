<!---
Hermes SEG - Pro License Required Page
Copyright Dionyssios Edwards. All Rights Reserved.

This component displays a properly formatted "Pro License Required" message
for pages that require the Pro edition.

Usage:
  <cfif NOT isDefined("session.edition") OR session.edition NEQ "Pro">
      <cfset proFeatureName = "RemoteAuth Configuration">
      <cfinclude template="./inc/license_pro_required.cfm">
      <cfabort>
  </cfif>

Required variable:
  proFeatureName - Name of the Pro feature being accessed (e.g., "RemoteAuth Configuration")
--->

<cfparam name="proFeatureName" default="This feature">

<div class="row justify-content-center">
    <div class="col-lg-8 col-xl-6">
        <div class="card card-outline card-warning">
            <div class="card-header text-center">
                <h3 class="card-title w-100">
                    <i class="fas fa-crown text-warning me-2"></i>
                    Pro License Required
                </h3>
            </div>
            <div class="card-body text-center">
                <div class="mb-4">
                    <i class="fas fa-lock fa-5x text-secondary opacity-50"></i>
                </div>

                <h4 class="mb-3"><cfoutput>#proFeatureName#</cfoutput></h4>

                <p class="text-muted mb-4">
                    This feature is only available with a valid Hermes SEG Pro License.
                </p>

                <div class="alert alert-info text-start">
                    <h5><i class="fas fa-info-circle me-2"></i>How to Upgrade</h5>
                    <p class="mb-2">To unlock Pro features, please contact:</p>
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

<cfinclude template="./main_footer.cfm" />

</main>
</div><!-- /.app-wrapper -->
</body>
</html>
