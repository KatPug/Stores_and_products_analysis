-- Top 10 Stores per Transacted Amount
SELECT
    store_id,
    store_name,
    country,
    city,
    typology,
    SUM(sum_transactions) AS total_transacted_amount
FROM 
    {{ ref('mart_stores') }} 
GROUP BY 
    store_id, store_name, country, city, typology
ORDER BY 
    total_transacted_amount DESC
LIMIT 10;

-- Top 10 products sold
SELECT
    product_name,
    SUM(transactions) AS total_transactions
FROM 
    {{ ref('mart_products') }} 
GROUP BY 
    product_name
ORDER BY 
    total_transactions DESC
LIMIT 10;

-- Average Transacted Amount per Store Typology and Country
SELECT
    country,
    typology,
    AVG(sum_transactions) AS avg_transacted_amount
FROM 
     {{ ref('mart_stores') }} 
GROUP BY 
    country, typology
ORDER BY 
    avg_transacted_amount DESC;

--Percentage of Transactions per Device Type
WITH DeviceTransactionCounts AS (
    SELECT
        device_type,
        SUM(num_transactions) AS total_transactions
    FROM 
        {{ ref('mart_stores') }}
    GROUP BY 
        device_type
),
TotalTransactions AS (
    SELECT 
        SUM(num_transactions) AS overall_transactions
    FROM 
        {{ ref('mart_stores') }}
)
SELECT
    d.device_type,
    d.total_transactions,
    ROUND((d.total_transactions * 100.0) / t.overall_transactions, 2) AS percentage_of_transactions
FROM 
    DeviceTransactionCounts d
CROSS JOIN 
    TotalTransactions t
ORDER BY 
    percentage_of_transactions DESC;

--Average Time for a Store to Perform Its 5 First Transactions
SELECT
    AVG(days_to_fifth_transaction) AS avg_time_to_fifth_transaction
FROM 
    {{ ref('mart_stores') }}
WHERE 
    days_to_fifth_transaction IS NOT NULL; -- Exclude stores without 5 transactions