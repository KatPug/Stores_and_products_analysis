WITH source AS (
	SELECT *

	FROM {{ source('raw_data', 'store') }}
)

SELECT
	-- IDs
	id,
	customer_id,

	-- Timestamps
	TIMESTAMP(created_at) AS created_at,
    CURRENT_TIMESTAMP AS load_date, -- Add load timestamp

	-- Other columns
    LOWER(name) AS store_name,
    LOWER(city) AS city,
    LOWER(country) AS country,
    LOWER(typology) AS typology

	{#- Unused columns:
		- address
	#}

FROM source
