{% if not var("enable_harvest_projects_source") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}

with source as (
  {{ filter_stitch_source('harvest_projects','s_projects','id') }}

),

renamed as (
select
       concat('harvest-',p.id)                  as timesheet_project_id,
       concat('harvest-',p.client_id)           as company_id,
       p.name                                   as project_name,
       p.code                                   as project_code,
       p.starts_on                              as project_delivery_start_ts,
       p.ends_on                                as project_delivery_end_ts,
       p.is_active                              as project_is_active,
       p.is_billable                            as project_is_billable,
       p.hourly_rate                            as project_hourly_rate,
       p.cost_budget                            as project_cost_budget,
       p.is_fixed_fee                           as project_is_fixed_fee,
       p.cost_budget_include_expenses           as project_is_expenses_included_in_cost_budget,
       p.fee                                    as project_fee_amount,
       p.budget                                 as project_budget_amount,
       p.over_budget_notification_percentage    as project_over_budget_notification_pct,
       p.budget_by                              as project_budget_by
from source p)
SELECT
  *
FROM
  renamed
