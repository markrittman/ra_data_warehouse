{% if not var("enable_asana_projects_source") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}

WITH source AS (
  {{ filter_stitch_source('stitch_asana','s_projects','gid') }}
),

renamed AS (
  SELECT
  concat('asana-',gid) as project_id,
  concat('asana-',owner.gid) as lead_user_id,
  concat('asana-',workspace.gid) as company_id,
  name as project_name,
  current_status as project_status,
  notes as project_notes,
  cast (null as string) as project_type,
  cast (null as string) as project_category_description,
  cast (null as string) as project_category_name,
  created_at as project_created_at_ts,
  modified_at as project_modified_at_ts,
  FROM
    source
  where name = 'BI Roadmap for Looker'

)
SELECT
  *
FROM
  renamed
