<!---
Hermes Secure Email Gateway - File Expressions Data Include
Queries the files table for custom file expression entries.
--->

<!--- All custom file expressions --->
<cfquery name="get_file_expressions" datasource="hermes">
  SELECT id, file, description
  FROM files
  WHERE type = <cfqueryparam value="CUSTOM-EXPRESSION" cfsqltype="cf_sql_varchar">
  ORDER BY file ASC
</cfquery>
