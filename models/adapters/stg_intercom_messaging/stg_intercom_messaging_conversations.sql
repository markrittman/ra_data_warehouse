{% if not var("enable_intercom_messaging_source") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}

WITH source AS (
      {{ filter_stitch_source('stitch_intercom','s_conversations','id') }}
  ),
renamed as (
  SELECT
    id as conversation_id,
    user.id AS conversation_user_id,
    conversation_message.author.id AS conversation_author_id,
    conversation_message.author.type AS conversation_author_type,
    user.type AS  conversation_user_type,
    assignee.id AS conversation_assignee_id,
    assignee.type  AS conversation_assignee_state,
    conversation_message.id AS conversation_message_id,
    conversation_message.type AS  conversation_message_type,
    conversation_message.body AS conversation_body,
    conversation_message.subject as  conversation_subject,
    created_at as contact_created_date,
    updated_at as contact_last_modified_date,
    read AS is_conversation_read,
    open AS is_conversation_open
  FROM
    source)
select * from renamed
