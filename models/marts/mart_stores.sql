WITH FifthTransactionTime AS (
    SELECT
        s_id,
        MAX(happened_at) AS fifth_transaction_time
    FROM {{ ref('int_transactions') }} 
    WHERE transaction_rank = 5
    GROUP BY store_id
)
SELECT
    s.id AS store_id,
    s.store_name,
    s.created_at AS store_created_at,
	d.type AS device_type,
	s.country,
	s.city,
	s.typology,

    -- Calculated fields
    COUNT(DISTINCT t.id) AS num_transactions,
    SUM(CASE WHEN t.status = 'accepted' THEN amount_eur ELSE 0 END) AS sum_transactions,
    DATE_DIFF(ft.fifth_transaction_time, s.created_at, DAY) AS days_to_fifth_transaction

FROM {{ ref('stg_store') }} AS s
JOIN {{ ref('stg_device') }} AS d
ON s.id = d.store_id
JOIN {{ ref('stg_transaction') }} AS t
ON d.id = t.device_id
LEFT JOIN FifthTransactionTime AS ft
ON s.id = ft.store_id
GROUP BY
    s.id, s.store_name, s.created_at, s.country, s.city, s.typology, d.type, ft.fifth_transaction_time
ORDER BY
    s.id;
