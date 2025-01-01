SELECT
	s.id,
	t.transaction_day,
	t.happened_at,
	s.country,
	s.city,
	s.store_name,
	d.id AS device_id,
  	d.type AS device_type,
	s.typology,
	t.status,

	-- Calculated fields
	count(distinct t.id) AS num_transactions,
	sum(amount_eur) AS sum_transactions,
	RANK() OVER (PARTITION BY store_id ORDER BY happened_at ASC) AS transaction_rank


FROM {{ ref('stg_store') }} AS s
JOIN {{ ref('stg_device') }} AS d
ON s.id = d.store_id
JOIN {{ ref('stg_transaction') }} AS t
ON d.id = t.device_id
GROUP BY 1,2,3,4,5,6,7,8,9,10