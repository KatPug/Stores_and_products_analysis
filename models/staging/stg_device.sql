WITH source AS (
	SELECT *

	FROM {{ source('raw_data', 'device') }}
)

SELECT
	id,
	type,
	store_id,
	CURRENT_TIMESTAMP AS load_date -- Add load timestamp

FROM source
