<!---
Hermes Secure Email Gateway - File Rules Data Include
Queries file_rule_components for distinct rules and their associated file types.
--->

<!--- All distinct file rules with system flag --->
<cfquery name="get_file_rules" datasource="hermes">
  SELECT DISTINCT rule_id, rule_name, system
  FROM file_rule_components
  ORDER BY system ASC, rule_name ASC
</cfquery>

<!--- System file rules (system=1) --->
<cfquery name="get_system_rules" datasource="hermes">
  SELECT DISTINCT rule_id, rule_name
  FROM file_rule_components
  WHERE system = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
  ORDER BY rule_name ASC
</cfquery>

<!--- Custom file rules (system=2) --->
<cfquery name="get_custom_rules" datasource="hermes">
  SELECT DISTINCT rule_id, rule_name
  FROM file_rule_components
  WHERE system = <cfqueryparam value="2" cfsqltype="cf_sql_integer">
  ORDER BY rule_name ASC
</cfquery>

<!--- All file rule components with file type details --->
<cfquery name="get_all_rule_components" datasource="hermes">
  SELECT frc.rule_id, frc.rule_name, frc.file_id, frc.description,
         frc.type, frc.priority, frc.system,
         f.file, f.type AS file_category
  FROM file_rule_components frc
  LEFT JOIN files f ON frc.file_id = f.id
  ORDER BY frc.rule_name ASC, frc.priority ASC
</cfquery>

<!--- Available file types grouped by category --->
<cfquery name="get_files_ext_high" datasource="hermes">
  SELECT id, file, description FROM files
  WHERE type = <cfqueryparam value="EXT-HIGH" cfsqltype="cf_sql_varchar">
  ORDER BY description ASC
</cfquery>

<cfquery name="get_files_file_high" datasource="hermes">
  SELECT id, file, description FROM files
  WHERE type = <cfqueryparam value="FILE-HIGH" cfsqltype="cf_sql_varchar">
  ORDER BY description ASC
</cfquery>

<cfquery name="get_files_mime_high" datasource="hermes">
  SELECT id, file, description FROM files
  WHERE type = <cfqueryparam value="MIME-HIGH" cfsqltype="cf_sql_varchar">
  ORDER BY description ASC
</cfquery>

<cfquery name="get_files_ext" datasource="hermes">
  SELECT id, file, description FROM files
  WHERE type = <cfqueryparam value="EXT" cfsqltype="cf_sql_varchar">
  ORDER BY description ASC
</cfquery>

<cfquery name="get_files_file" datasource="hermes">
  SELECT id, file, description FROM files
  WHERE type = <cfqueryparam value="FILE" cfsqltype="cf_sql_varchar">
  ORDER BY description ASC
</cfquery>

<cfquery name="get_files_mime" datasource="hermes">
  SELECT id, file, description FROM files
  WHERE type = <cfqueryparam value="MIME" cfsqltype="cf_sql_varchar">
  ORDER BY description ASC
</cfquery>

<cfquery name="get_files_other" datasource="hermes">
  SELECT id, file, description FROM files
  WHERE type = <cfqueryparam value="OTHER" cfsqltype="cf_sql_varchar">
  ORDER BY description ASC
</cfquery>

<cfquery name="get_files_custom_expr" datasource="hermes">
  SELECT id, file, description FROM files
  WHERE type = <cfqueryparam value="CUSTOM-EXPRESSION" cfsqltype="cf_sql_varchar">
  ORDER BY description ASC
</cfquery>
