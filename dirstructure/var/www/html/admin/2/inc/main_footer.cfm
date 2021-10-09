<!--- GET VERSION --->
<cfquery name="getversion" datasource="#datasource#">
  SELECT value from system_settings where parameter = 'version_no'
  </cfquery>

<!--- GET BUILD --->
  <cfquery name="getbuild" datasource="#datasource#">
  SELECT value from system_settings where parameter = 'build_no'
  </cfquery>
<cfoutput>

<!-- Main Footer -->
<footer class="main-footer">
    <!-- To the right -->
    <!---
    <div class="float-right d-none d-sm-inline">
    <strong>“Just because you're paranoid doesn't mean they aren't after you.”</strong><br>- Joseph Heller, Catch-22
    </div>
  --->
    <!-- Default to the left -->
    <strong>Hermes Secure Email Gateway #getversion.value# - #getbuild.value# Copyright &copy; 2011-#year(now())# <a href="https://www.deeztek.com">Dionyssios Edwards</a>.</strong> All rights reserved. Portions of this program are covered under the AGPLv3 License.
  </footer>
</div>
</cfoutput>