{% set materialized = 'incremental' %}
{% set increemental_col = 'CREATED_AT' %}

select * from {{ source('staging', 'listings') }}

{% if is_incremental() %}
    where {{ increemental_col }} > (select COALESCE(max({{ increemental_col }}), '1900-01-01') from {{ this }})
{% endif %}
