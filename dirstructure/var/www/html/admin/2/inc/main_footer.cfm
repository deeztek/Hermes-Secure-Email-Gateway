
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
    <strong>Hermes Secure Email Gateway | #getversion.value# - #getbuild.value# - #session.edition# | Copyright &copy; 2011-#year(now())# <a href="https://www.deeztek.com">Dionyssios Edwards</a>.</strong> All rights reserved. Portions of this program are covered under the AGPLv3 License.
  </footer>
</div>
</cfoutput>