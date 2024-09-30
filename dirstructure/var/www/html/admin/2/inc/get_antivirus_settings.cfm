
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

<cfquery name="getScanMail" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='ScanMail' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getScanArchive" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='ScanArchive' and active = '1' and module='clamav'
    </cfquery>
    
    
    <cfquery name="getArchiveBlockEncrypted" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='ArchiveBlockEncrypted' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getScanPE" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='ScanPE' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getScanOLE2" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='ScanOLE2' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getOLE2BlockMacros" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='OLE2BlockMacros' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getScanPDF" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='ScanPDF' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getScanHTML" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='ScanHTML' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getAlgorithmicDetection" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='AlgorithmicDetection' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getScanELF" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='ScanELF' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getPhishingSignatures" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='PhishingSignatures' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getPhishingScanURLs" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='PhishingScanURLs' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getPhishingAlwaysBlockSSLMismatch" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='PhishingAlwaysBlockSSLMismatch' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getPhishingAlwaysBlockCloak" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='PhishingAlwaysBlockCloak' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getDetectPUA" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='DetectPUA' and active = '1' and module='clamav'
    </cfquery>
    
    <cfquery name="getHeuristicScanPrecedence" datasource="hermes">
    select parameter, value2 from parameters2 where parameter='HeuristicScanPrecedence' and active = '1' and module='clamav'
    </cfquery>
    

    <cfparam name = "ScanMail" default = "#getScanMail.value2#"> 
    <cfif IsDefined("form.ScanMail") is "True">
    <cfif form.ScanMail is not "">
    <cfset ScanMail = form.ScanMail>
    </cfif></cfif>
    
    <cfparam name = "ScanArchive" default = "#getScanArchive.value2#"> 
    <cfif IsDefined("form.ScanArchive") is "True">
    <cfif form.ScanArchive is not "">
    <cfset ScanArchive= form.ScanArchive>
    </cfif></cfif>
    
    <cfparam name = "ArchiveBlockEncrypted" default = "#getArchiveBlockEncrypted.value2#"> 
    <cfif IsDefined("form.ArchiveBlockEncrypted") is "True">
    <cfif form.ArchiveBlockEncrypted is not "">
    <cfset ArchiveBlockEncrypted= form.ArchiveBlockEncrypted>
    </cfif></cfif>
    
    <cfparam name = "ScanPE" default = "#getScanPE.value2#"> 
    <cfif IsDefined("form.ScanPE") is "True">
    <cfif form.ScanPE is not "">
    <cfset ScanPE= form.ScanPE>
    </cfif></cfif>
    
    <cfparam name = "ScanOLE2" default = "#getScanOLE2.value2#"> 
    <cfif IsDefined("form.ScanOLE2") is "True">
    <cfif form.ScanOLE2 is not "">
    <cfset ScanOLE2= form.ScanOLE2>
    </cfif></cfif>
    
    <cfparam name = "OLE2BlockMacros" default = "#getOLE2BlockMacros.value2#"> 
    <cfif IsDefined("form.OLE2BlockMacros") is "True">
    <cfif form.OLE2BlockMacros is not "">
    <cfset OLE2BlockMacros = form.OLE2BlockMacros>
    </cfif></cfif>
    
    <cfparam name = "ScanPDF" default = "#getScanPDF.value2#"> 
    <cfif IsDefined("form.ScanPDF") is "True">
    <cfif form.ScanPDF is not "">
    <cfset ScanPDF = form.ScanPDF>
    </cfif></cfif>
    
    <cfparam name = "ScanHTML" default = "#getScanHTML.value2#"> 
    <cfif IsDefined("form.ScanHTML") is "True">
    <cfif form.ScanHTML is not "">
    <cfset ScanHTML = form.ScanHTML>
    </cfif></cfif>
    
    
    <cfparam name = "AlgorithmicDetection" default = "#getAlgorithmicDetection.value2#"> 
    <cfif IsDefined("form.AlgorithmicDetection") is "True">
    <cfif form.AlgorithmicDetection is not "">
    <cfset AlgorithmicDetection = form.AlgorithmicDetection>
    </cfif></cfif>
    
    <cfparam name = "ScanELF" default = "#getScanELF.value2#"> 
    <cfif IsDefined("form.ScanELF") is "True">
    <cfif form.ScanELF is not "">
    <cfset ScanELF = form.ScanELF>
    </cfif></cfif>
    
    <cfparam name = "PhishingSignatures" default = "#getPhishingSignatures.value2#"> 
    <cfif IsDefined("form.PhishingSignatures") is "True">
    <cfif form.PhishingSignatures is not "">
    <cfset PhishingSignatures = form.PhishingSignatures>
    </cfif></cfif>
    
    <cfparam name = "PhishingScanURLs" default = "#getPhishingScanURLs.value2#"> 
    <cfif IsDefined("form.PhishingScanURLs") is "True">
    <cfif form.PhishingScanURLs is not "">
    <cfset PhishingScanURLs = form.PhishingScanURLs>
    </cfif></cfif>
    
    <cfparam name = "PhishingAlwaysBlockSSLMismatch" default = "#getPhishingAlwaysBlockSSLMismatch.value2#"> 
    <cfif IsDefined("form.PhishingAlwaysBlockSSLMismatch") is "True">
    <cfif form.PhishingAlwaysBlockSSLMismatch is not "">
    <cfset PhishingAlwaysBlockSSLMismatch = form.PhishingAlwaysBlockSSLMismatch>
    </cfif></cfif>
    
    <cfparam name = "PhishingAlwaysBlockCloak" default = "#getPhishingAlwaysBlockCloak.value2#"> 
    <cfif IsDefined("form.PhishingAlwaysBlockCloak") is "True">
    <cfif form.PhishingAlwaysBlockCloak is not "">
    <cfset PhishingAlwaysBlockCloak = form.PhishingAlwaysBlockCloak>
    </cfif></cfif>
    
    <cfparam name = "DetectPUA" default = "#getDetectPUA.value2#"> 
    <cfif IsDefined("form.DetectPUA") is "True">
    <cfif form.DetectPUA is not "">
    <cfset DetectPUA = form.DetectPUA>
    </cfif></cfif>
    
    <cfparam name = "HeuristicScanPrecedence" default = "#getHeuristicScanPrecedence.value2#"> 
    <cfif IsDefined("form.HeuristicScanPrecedence") is "True">
    <cfif form.HeuristicScanPrecedence is not "">
    <cfset HeuristicScanPrecedence = form.HeuristicScanPrecedence>
    </cfif></cfif>



