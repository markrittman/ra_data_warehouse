{% if not var("enable_xero_accounting_source") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}

WITH
  source AS
  (
    {{ filter_stitch_source('xero_accounting','s_bank_transactions','banktransactionid') }}
  ),
renamed as (
  SELECT
      concat('xero-',banktransactionid) as transaction_id,
      lineitems.accountcode as bank_transaction_line_item_account_code,
      lineitems.description as transaction_description,
      currencycode as transaction_currency,
      cast(null as numeric) as transaction_exchange_rate,
      lineitems.lineamount as transaction_gross_amount,
      cast(null as numeric) as transaction_fee_amount,
      lineitems.taxamount as transaction_tax_amount,
      lineitems.lineamount - lineitems.taxamount as transaction_net_amount,
      case when isreconciled then 'Reconciled' else 'Unreconciled' end as transaction_status,
      type as transaction_type,
      date as transaction_created_ts,
      cast(null as timestamp) as transaction_updated_ts
  FROM
    source i,
         UNNEST(i.lineitems) AS lineitems)
select * from renamed
