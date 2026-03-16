<!---
Hermes Secure Email Gateway - File Extensions Data Include
Queries the files table for custom and system file extensions.
--->

<!--- Custom extensions (non-system, non-custom-expression) --->
<cfquery name="get_custom_extensions" datasource="hermes">
  SELECT id, file, description
  FROM files
  WHERE system = <cfqueryparam value="NO" cfsqltype="cf_sql_varchar">
    AND type <> <cfqueryparam value="CUSTOM-EXPRESSION" cfsqltype="cf_sql_varchar">
  ORDER BY file ASC
</cfquery>

<!--- All EXT and EXT-HIGH extensions (system + custom) --->
<cfquery name="get_all_extensions" datasource="hermes">
  SELECT id, file, description, type, system
  FROM files
  WHERE type IN (<cfqueryparam value="EXT,EXT-HIGH" cfsqltype="cf_sql_varchar" list="true">)
  ORDER BY file ASC
</cfquery>
