
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

<!--- UPDATE ANTIVIRUS --->

<cfquery name="updateScanMail" datasource="hermes">
  update parameters2 set value2='#ScanMail#', applied='1' where parameter='ScanMail' and module='clamav'
  </cfquery>
  
  <cfquery name="updateScanArchive" datasource="hermes">
  update parameters2 set value2='#ScanArchive#', applied='1' where parameter='ScanArchive' and module='clamav'
  </cfquery>
  
  <cfquery name="updateArchiveBlockEncrypted" datasource="hermes">
  update parameters2 set value2='#ArchiveBlockEncrypted#', applied='1' where parameter='ArchiveBlockEncrypted' and module='clamav'
  </cfquery>
  
  <cfquery name="updateScanPE" datasource="hermes">
  update parameters2 set value2='#ScanPE#', applied='1' where parameter='ScanPE' and module='clamav'
  </cfquery>
  
  <cfquery name="updateScanOLE2" datasource="hermes">
  update parameters2 set value2='#ScanOLE2#', applied='1' where parameter='ScanOLE2' and module='clamav'
  </cfquery>
  
  <cfquery name="updateOLE2BlockMacros" datasource="hermes">
  update parameters2 set value2='#OLE2BlockMacros#', applied='1' where parameter='OLE2BlockMacros' and module='clamav'
  </cfquery>
  
  <cfquery name="updateScanPDF" datasource="hermes">
  update parameters2 set value2='#ScanPDF#', applied='1' where parameter='ScanPDF' and module='clamav'
  </cfquery>
  
  <cfquery name="updateScanHTML" datasource="hermes">
  update parameters2 set value2='#ScanHTML#', applied='1' where parameter='ScanHTML' and module='clamav'
  </cfquery>
  
  <cfquery name="updateAlgorithmicDetection" datasource="hermes">
  update parameters2 set value2='#AlgorithmicDetection#', applied='1' where parameter='AlgorithmicDetection' and module='clamav'
  </cfquery>
  
  <cfquery name="updateScanELF" datasource="hermes">
  update parameters2 set value2='#ScanELF#', applied='1' where parameter='ScanELF' and module='clamav'
  </cfquery>
  
  <cfquery name="updatePhishingSignatures" datasource="hermes">
  update parameters2 set value2='#PhishingSignatures#', applied='1' where parameter='PhishingSignatures' and module='clamav'
  </cfquery>
  
  <cfquery name="updatePhishingScanURLs" datasource="hermes">
  update parameters2 set value2='#PhishingScanURLs#', applied='1' where parameter='PhishingScanURLs' and module='clamav'
  </cfquery>
  
  <cfquery name="updatePhishingAlwaysBlockSSLMismatch" datasource="hermes">
  update parameters2 set value2='#PhishingAlwaysBlockSSLMismatch#', applied='1' where parameter='PhishingAlwaysBlockSSLMismatch' and module='clamav'
  </cfquery>
  
  <cfquery name="updatePhishingAlwaysBlockCloak" datasource="hermes">
  update parameters2 set value2='#PhishingAlwaysBlockCloak#', applied='1' where parameter='PhishingAlwaysBlockCloak' and module='clamav'
  </cfquery>
  
  <cfquery name="updateDetectPUA" datasource="hermes">
  update parameters2 set value2='#DetectPUA#', applied='1' where parameter='DetectPUA' and module='clamav'
  </cfquery>
  
  <cfquery name="updateHeuristicScanPrecedence" datasource="hermes">
  update parameters2 set value2='#HeuristicScanPrecedence#', applied='1' where parameter='HeuristicScanPrecedence' and module='clamav'
  </cfquery>
  