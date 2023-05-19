
   <!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Pro Edition.

Hermes Secure Email Gateway Pro Edition is NOT free software. It is covered under the Hermes Secure Email Gateway Pro Edition License.

You should have received a copy of the Hermes Secure Email Gateway Pro Edition License along with Hermes Secure Email Gateway Pro Edition Software.  If not, see https://docs.deeztek.com/books/hermes-seg-general-documentation/page/hermes-secure-email-gateway-pro-end-user-license-agreement-eula.
  --->
   
<table class="table table-striped"  style="width:100%">
<thead>
<tr>
  <th>Action</th> 
  <th>Status</th>   
  <th>Release Note</th>
  <th>Build No</th>
  <th>Release Date</th>
  <th>Install Date</th>
  <th>MySQL Root</th>
  <th>DEV Release</th>

</tr>
</thead>
<tbody>



<cfoutput query = "getupdates">

<tr>

<td></td>
<td>Installed</td>

<td>

  <button onClick="window.open('https://updates.deeztek.com/downloads/hermes-#build#-release.txt');" type="button" id="delete" class="btn btn-secondary" data-toggle="modal" data-ip="" data-address="" data-note="" data-hermesadmin="" data-ciphermailadmin=""><i class="fas fa-search"></i></button>
        
  </td>

  <td>#build#</td>

  <td>N/A</td>

  <td>#dateformat(date_installed, "mm/dd/yyyy")#</td>
  <td>N/A</td>
  <td>N/A</td>

</tr>

</cfoutput>






</tbody>

<tfoot>
<tr>

  <th>Action</th>   
  <th>Status</th> 
  <th>Release Note</th> 
  <th>Build No</th>
  <th>Release Date</th>
  <th>Install Date</th>
  <th>MySQL Root</th>
  <th>DEV Release</th>

</tr>
</tfoot>

</table>