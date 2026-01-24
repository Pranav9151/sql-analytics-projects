-------------------------------- RUN EVERY STEP SEPERATELY ------------------------

1️⃣ CREATE INDEXES (RUN ONCE)

-- Index on customer primary key
CREATE INDEX IF NOT EXISTS idx_customers_customer_id
ON customers (customer_id);

-- Index on responses customer reference
CREATE INDEX IF NOT EXISTS idx_responses_customer_id
ON responses (customer_id);

-- Index on responses campaign reference
CREATE INDEX IF NOT EXISTS idx_responses_campaign_id
ON responses (campaign_id);

-- Index on campaigns primary key
CREATE INDEX IF NOT EXISTS idx_campaigns_campaign_id
ON campaigns (campaign_id);

-- Index on response outcome (yes / no)
CREATE INDEX IF NOT EXISTS idx_responses_response
ON responses (response);
------------------------------------

2️⃣ OPTIMIZED CAMPAIGN CONVERSION QUERY

SELECT
    ca.campaign_id,
    COUNT(r.customer_id) AS total_customers,
    SUM(CASE WHEN r.response = 'yes' THEN 1 ELSE 0 END) AS total_conversions,
    ROUND(
        SUM(CASE WHEN r.response = 'yes' THEN 1 ELSE 0 END) * 100.0
        / NULLIF(COUNT(r.customer_id), 0),
        2
    ) AS conversion_rate
FROM campaigns ca
JOIN responses r
    ON ca.campaign_id = r.campaign_id
GROUP BY ca.campaign_id
ORDER BY conversion_rate DESC;


3️⃣ HIGH-VALUE CUSTOMER IDENTIFICATION

SELECT
    c.customer_id,
    c.job,
    SUM(CASE WHEN r.response = 'yes' THEN 1 ELSE 0 END) AS conversions
FROM customers c
JOIN responses r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.job
HAVING SUM(CASE WHEN r.response = 'yes' THEN 1 ELSE 0 END) > 0
ORDER BY conversions DESC;


4️⃣ QUERY PERFORMANCE INSPECTION

EXPLAIN ANALYZE
SELECT
    ca.campaign_id,
    COUNT(*) AS total_responses
FROM campaigns ca
JOIN responses r
    ON ca.campaign_id = r.campaign_id
GROUP BY ca.campaign_id;
