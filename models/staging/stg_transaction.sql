{{ config(
    materialized='table',
    partition_by={'field': 'transaction_day', 'data_type': 'DATE'}
) }}

WITH source AS (
	SELECT *

	FROM {{ source('raw_data', 'transaction') }}
)

SELECT
	-- IDs
	id,
	device_id,

	-- Timestamps
    DATE(happened_at) AS transaction_day,
    TIMESTAMP(happened_at) AS happened_at,
    TIMESTAMP(created_at) AS created_at,
    CURRENT_TIMESTAMP AS load_date -- Add load timestamp for traceability

	-- Other columns
	LOWER(product_name) AS product_name,
	product_sku,
	LOWER(category_name) AS category_name,
	amount / 100 as amount_eur,
	status

	{#- Unused columns:
		- card_number
		- cvv
	#}

FROM source
