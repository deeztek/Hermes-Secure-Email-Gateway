
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

<!--- GET VERSION --->
<cfquery name="getversion" datasource="hermes">
  SELECT value from system_settings where parameter = 'version_no'
</cfquery>

<!--- GET BUILD --->
<cfquery name="getbuild" datasource="hermes">
  SELECT value from system_settings where parameter = 'build_no'
</cfquery>

<!--- GET RANDOM QUOTE --->
<cfquery name="getrandom" datasource="hermes">
  SELECT quote, source from quotes order by rand() limit 1
</cfquery>

<cfoutput>

<!--begin::Footer-->
<footer class="app-footer">
  <div>
    <strong>Hermes SEG | #getversion.value# - #getbuild.value# - #session.edition# | Copyright &copy; 2011-#year(now())# <a href="https://www.hermesseg.io" class="text-decoration-none">Dionyssios Edwards</a>.</strong> All rights reserved. Portions of this program are covered under the AGPLv3 License.
  </div>

  <hr class="hr">

  <div class="text-center">
    <strong>&quot;#getrandom.quote#&quot;</strong><br>
    &##45; #getrandom.source#
  </div>
</footer>
<!--end::Footer-->

</div>
<!--end::App Wrapper-->

</cfoutput>
