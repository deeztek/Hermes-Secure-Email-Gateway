<cfsetting requesttimeout="300">

<!---
  Hermes Secure Email Gateway
  SPF -> Postfix mynetworks synchronization

  Reads relay-network SPF sync settings from parameters2. When disabled, this
  task exits without making changes. When enabled, it resolves IPv4 networks
  from the configured SPF root (following include: chains), removes only the
  relay-network rows tagged as auto-managed by this task, inserts the current
  discovered networks, and regenerates Postfix only when the managed set
  actually changed.
--->

<cfset datasourceName = "hermes">
<cfset settingsModule = "relay_networks">
<cfset automationNote = "SPF Sync (Auto)">
<cfset digPath = "/usr/bin/dig">

<cffunction name="normalizeIPv4" returntype="string" output="false">
  <cfargument name="ip" type="string" required="true">
  <cfset var octets = ListToArray(arguments.ip, ".")>
  <cfset var normalized = "">
  <cfloop array="#octets#" index="octet">
    <cfset normalized = ListAppend(normalized, Int(octet), ".")>
  </cfloop>
  <cfreturn normalized>
</cffunction>

<cfquery name="get_spf_sync_settings" datasource="#datasourceName#">
  SELECT parameter, value2
  FROM parameters2
  WHERE module = <cfqueryparam value="#settingsModule#" cfsqltype="cf_sql_varchar">
    AND active = '1'
    AND parameter IN ('spf_sync_enabled', 'spf_sync_server')
</cfquery>

<cfset relaySyncSettings = {}>
<cfloop query="get_spf_sync_settings">
  <cfset relaySyncSettings[get_spf_sync_settings.parameter] = get_spf_sync_settings.value2>
</cfloop>

<cfparam name="relaySyncSettings.spf_sync_enabled" default="0">
<cfparam name="relaySyncSettings.spf_sync_server" default="">

<cfif relaySyncSettings.spf_sync_enabled is not "1">
  <cfoutput>SPF_SYNC_DISABLED</cfoutput>
  <cfabort>
</cfif>

<cfset spfRoot = trim(relaySyncSettings.spf_sync_server)>

<cfif spfRoot is "" OR NOT REFind("^[A-Za-z0-9._-]+$", spfRoot)>
  <cfcontent type="text/plain">
  <cfoutput>
SPF_SYNC_ABORTED
Reason: Invalid SPF root configured.
  </cfoutput>
  <cfabort>
</cfif>

<cfif NOT fileExists(digPath)>
  <cfcontent type="text/plain">
  <cfoutput>
SPF_SYNC_ABORTED
Reason: dig was not found at #digPath#.
  </cfoutput>
  <cfabort>
</cfif>

<cfquery name="get_mynetworks_parent" datasource="#datasourceName#">
  SELECT id
  FROM parameters
  WHERE parameter = 'mynetworks'
    AND child = '2'
  ORDER BY id
  LIMIT 1
</cfquery>

<cfif get_mynetworks_parent.recordcount LT 1>
  <cfcontent type="text/plain">
  <cfoutput>
SPF_SYNC_ABORTED
Reason: Could not find the mynetworks parent row.
  </cfoutput>
  <cfabort>
</cfif>

<cfset mynetworksParentID = get_mynetworks_parent.id>
<cfset domainsToProcess = [spfRoot]>
<cfset processedDomains = {}>
<cfset discoveredNetworks = {}>
<cfset queuePosition = 1>
<cfset discoveryFailed = false>

<cfloop condition="queuePosition LTE ArrayLen(domainsToProcess)">
  <cfset currentDomain = domainsToProcess[queuePosition]>
  <cfset queuePosition = queuePosition + 1>

  <cfif NOT StructKeyExists(processedDomains, LCase(currentDomain))>
    <cfset processedDomains[LCase(currentDomain)] = true>

    <cfset digOutput = "">
    <cfset digError = "">

    <cftry>
      <cfexecute
        name="#digPath#"
        arguments="+short TXT #currentDomain#"
        variable="digOutput"
        errorVariable="digError"
        timeout="20">
      </cfexecute>
      <cfcatch type="any">
        <cfset discoveryFailed = true>
      </cfcatch>
    </cftry>

    <cfif discoveryFailed OR Len(Trim(digOutput)) EQ 0>
      <cfset discoveryFailed = true>
      <cfbreak>
    </cfif>

    <cfset ipv4Matches = REMatchNoCase("ip4:[0-9]{1,3}(\.[0-9]{1,3}){3}(/[0-9]{1,2})?", digOutput)>

    <cfloop array="#ipv4Matches#" index="networkValue">
      <cfset networkValue = REReplace(networkValue, "^ip4:", "")>
      <cfset slashPosition = Find("/", networkValue)>
      <cfset cidrBits = "">
      <cfset ipAddress = networkValue>

      <cfif slashPosition GT 0>
        <cfset ipAddress = Left(networkValue, slashPosition - 1)>
        <cfset cidrBits = Mid(networkValue, slashPosition + 1, Len(networkValue))>
      </cfif>

      <cfset ipParts = ListToArray(ipAddress, ".")>
      <cfset validIPv4 = ArrayLen(ipParts) EQ 4>

      <cfif validIPv4>
        <cfloop array="#ipParts#" index="ipPart">
          <cfif NOT IsNumeric(ipPart) OR Val(ipPart) LT 0 OR Val(ipPart) GT 255>
            <cfset validIPv4 = false>
            <cfbreak>
          </cfif>
        </cfloop>
      </cfif>

      <cfif validIPv4 AND slashPosition GT 0>
        <cfif NOT IsNumeric(cidrBits) OR Val(cidrBits) LT 0 OR Val(cidrBits) GT 32>
          <cfset validIPv4 = false>
        </cfif>
      </cfif>

      <cfif validIPv4>
        <cfset normalizedIP = normalizeIPv4(ipAddress)>
        <cfif slashPosition GT 0>
          <cfset normalizedNetwork = normalizedIP & "/" & Int(cidrBits)>
        <cfelse>
          <cfset normalizedNetwork = normalizedIP>
        </cfif>
        <cfset discoveredNetworks[LCase(normalizedNetwork)] = normalizedNetwork>
      </cfif>
    </cfloop>

    <cfset includeMatches = REMatchNoCase("include:[A-Za-z0-9][A-Za-z0-9._-]*", digOutput)>
    <cfloop array="#includeMatches#" index="includeValue">
      <cfset includeDomain = REReplace(includeValue, "^include:", "")>
      <cfif NOT StructKeyExists(processedDomains, LCase(includeDomain))>
        <cfset ArrayAppend(domainsToProcess, includeDomain)>
      </cfif>
    </cfloop>
  </cfif>
</cfloop>

<cfif discoveryFailed OR StructCount(discoveredNetworks) EQ 0>
  <cfcontent type="text/plain">
  <cfoutput>
SPF_SYNC_ABORTED
Reason: SPF discovery failed or returned no IPv4 networks.
  </cfoutput>
  <cfabort>
</cfif>

<cfquery name="existing_relay_networks" datasource="#datasourceName#">
  SELECT id, parameter, note, order1
  FROM parameters
  WHERE parent = <cfqueryparam value="#mynetworksParentID#" cfsqltype="cf_sql_integer">
    AND child = '1'
  ORDER BY order1 ASC, id ASC
</cfquery>

<cfset existingManagedNetworks = {}>
<cfset existingManualNetworks = {}>
<cfset maxOrder = 0>

<cfloop query="existing_relay_networks">
  <cfset currentParameter = Trim(existing_relay_networks.parameter)>

  <cfif IsNumeric(existing_relay_networks.order1) AND Val(existing_relay_networks.order1) GT maxOrder>
    <cfset maxOrder = Val(existing_relay_networks.order1)>
  </cfif>

  <cfif currentParameter is not "">
    <cfif Trim(existing_relay_networks.note) is automationNote>
      <cfset existingManagedNetworks[LCase(currentParameter)] = existing_relay_networks.id>
    <cfelse>
      <cfset existingManualNetworks[LCase(currentParameter)] = true>
    </cfif>
  </cfif>
</cfloop>

<cfset desiredManagedNetworks = []>
<cfset discoveredKeys = StructKeyArray(discoveredNetworks)>
<cfset ArraySort(discoveredKeys, "textnocase")>

<cfloop array="#discoveredKeys#" index="networkKey">
  <cfif NOT StructKeyExists(existingManualNetworks, networkKey)>
    <cfset ArrayAppend(desiredManagedNetworks, discoveredNetworks[networkKey])>
  </cfif>
</cfloop>

<cfset changesRequired = ArrayLen(desiredManagedNetworks) NEQ StructCount(existingManagedNetworks)>

<cfif NOT changesRequired>
  <cfloop array="#desiredManagedNetworks#" index="managedNetwork">
    <cfif NOT StructKeyExists(existingManagedNetworks, LCase(managedNetwork))>
      <cfset changesRequired = true>
      <cfbreak>
    </cfif>
  </cfloop>
</cfif>

<cfif NOT changesRequired>
  <cfoutput>SPF_SYNC_NO_CHANGES</cfoutput>
  <cfabort>
</cfif>

<cfquery datasource="#datasourceName#">
  DELETE FROM parameters
  WHERE parent = <cfqueryparam value="#mynetworksParentID#" cfsqltype="cf_sql_integer">
    AND child = '1'
    AND note = <cfqueryparam value="#automationNote#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfset nextOrder = maxOrder + 1>

<cfloop array="#desiredManagedNetworks#" index="managedNetwork">
  <cfset managedNetworkType = Find("/", managedNetwork) GT 0 ? 1 : 0>
  <cfquery datasource="#datasourceName#">
    INSERT INTO parameters (
      parameter,
      module,
      editable,
      conf_file,
      parent,
      parent_name,
      child,
      order1,
      enabled,
      applied,
      action,
      network_entry,
      note
    ) VALUES (
      <cfqueryparam value="#managedNetwork#" cfsqltype="cf_sql_varchar">,
      'postfix',
      '1',
      'main.cf',
      <cfqueryparam value="#mynetworksParentID#" cfsqltype="cf_sql_integer">,
      'mynetworks',
      '1',
      <cfqueryparam value="#nextOrder#" cfsqltype="cf_sql_decimal">,
      '1',
      '1',
      'NONE',
      <cfqueryparam value="#managedNetworkType#" cfsqltype="cf_sql_integer">,
      <cfqueryparam value="#automationNote#" cfsqltype="cf_sql_varchar">
    )
  </cfquery>
  <cfset nextOrder = nextOrder + 1>
</cfloop>

<cfinclude template="../admin/2/inc/generate_postfix_configuration.cfm">

<cfoutput>SPF_SYNC_UPDATED</cfoutput>
