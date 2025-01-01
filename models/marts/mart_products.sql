SELECT
t.transaction_day,
product_name,
product_sku,
category_name,
country,
COUNT(DISTINCT t.id) AS transactions,
SUM(amount_eur) AS transacted_amount
FROM 
{{source('stg_device')}} AS d
JOIN 
{{source('stg_transaction')}} AS t
ON d.id = t.device_id
and t.status = 'accepted'
JOIN
	{{source('stg_store’')}} AS s
	ON s.id = d.store_id
GROUP BY 1, 2, 3, 4, 5
