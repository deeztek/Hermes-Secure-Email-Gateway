<!---
Shared encryption form fields for editing recipient encryption settings.
Used by both the Edit Recipient modal and Edit Encryption modal
in view_internal_recipients.cfm
--->

<!--- Load Certificate Authorities for S/MIME --->
<cfquery name="getdefaultca" datasource="hermes">
  SELECT id, ca_commonname FROM ca_settings WHERE default2='1'
</cfquery>
<cfquery name="getotherca" datasource="hermes">
  SELECT id, ca_commonname FROM ca_settings WHERE id <> '#getdefaultca.id#' ORDER BY ca_commonname ASC
</cfquery>

<!--- PDF ENCRYPTION --->
<div class="form-group">
  <label><strong>PDF Encryption</strong></label>
  <select class="form-control" name="pdf_enabled" style="width: 100%">
    <option value="2" selected="selected">Disable</option>
    <option value="1">Enable</option>
  </select>
</div>

<!--- S/MIME ENCRYPTION --->
<div class="form-group">
  <label><strong>S/MIME Encryption</strong></label>
  <select class="form-control edit-smime-enabled" name="smime_enabled" style="width: 100%">
    <option value="2" selected="selected">Disable</option>
    <option value="1">Enable</option>
  </select>
</div>

<!--- S/MIME OPTIONS (shown when S/MIME enabled) --->
<div class="edit-smime-options" style="display:none;">

  <div class="form-group">
    <label><strong>Certificate Authority</strong></label>
    <select class="form-control" name="ca" style="width: 100%;">
      <cfoutput><option value="#getdefaultca.id#" selected="selected">#getdefaultca.ca_commonname#</option></cfoutput>
      <cfoutput query="getotherca">
        <option value="#id#">#ca_commonname#</option>
      </cfoutput>
    </select>
  </div>

  <div class="form-group">
    <label><strong>Certificate Validity Period</strong></label>
    <select class="form-control" name="validity" style="width: 100%;">
      <option value="1825" selected="selected">5 Years</option>
      <option value="1460">4 Years</option>
      <option value="1095">3 Years</option>
      <option value="730">2 Years</option>
      <option value="365">1 Year</option>
    </select>
  </div>

  <div class="form-group">
    <label><strong>Certificate Key Length</strong></label>
    <select class="form-control" name="cert_encryption" style="width: 100%;">
      <option value="2048" selected="selected">2048-bit (Recommended)</option>
      <option value="4096">4096-bit (High Security)</option>
    </select>
  </div>

  <div class="form-group">
    <label><strong>Certificate Hash Algorithm</strong></label>
    <select class="form-control" name="cert_algorithm" style="width: 100%;">
      <option value="sha256" selected="selected">SHA-256 (Recommended)</option>
      <option value="sha512">SHA-512 (High Security)</option>
    </select>
  </div>

  <div class="alert alert-info">
    <i class="icon fas fa-info-circle"></i>
    S/MIME certificate options only apply when generating a new certificate. If the recipient already has a certificate, these settings are ignored.
  </div>

</div>
<!--- /S/MIME OPTIONS --->

<!--- S/MIME SIGNATURE --->
<div class="form-group">
  <label><strong>S/MIME Signature</strong></label>
  <p class="help-block">Effective only when S/MIME Certificate present</p>
  <select class="form-control" name="sign" style="width: 100%">
    <option value="2" selected="selected">Sign Encrypted Messages Only</option>
    <option value="1">Sign All Messages</option>
  </select>
</div>

<!--- PGP ENCRYPTION --->
<div class="form-group">
  <label><strong>PGP Encryption</strong></label>
  <select class="form-control edit-pgp-enabled" name="pgp_enabled" style="width: 100%">
    <option value="2" selected="selected">Disable</option>
    <option value="1">Enable</option>
  </select>
</div>

<!--- PGP OPTIONS (shown when PGP enabled) --->
<div class="edit-pgp-options" style="display:none;">

  <div class="form-group">
    <label><strong>PGP Key Size</strong></label>
    <select class="form-control" name="pgp_encryption" style="width: 100%;">
      <option value="2048" selected="selected">2048-bit (Recommended)</option>
      <option value="4096">4096-bit (High Security)</option>
    </select>
  </div>

  <div class="alert alert-info">
    <i class="icon fas fa-info-circle"></i>
    PGP key options only apply when generating a new keyring. If the recipient already has a keyring, these settings are ignored.
    The local part of each recipient's e-mail address will be automatically used as the PGP key Real Name.
  </div>

</div>
<!--- /PGP OPTIONS --->

<script>
// Show/hide S/MIME options when toggled
$(document).on('change', '.edit-smime-enabled', function() {
  var opts = $(this).closest('form').find('.edit-smime-options');
  if ($(this).val() === '1') { opts.show(); } else { opts.hide(); }
});

// Show/hide PGP options when toggled
$(document).on('change', '.edit-pgp-enabled', function() {
  var opts = $(this).closest('form').find('.edit-pgp-options');
  if ($(this).val() === '1') { opts.show(); } else { opts.hide(); }
});
</script>
