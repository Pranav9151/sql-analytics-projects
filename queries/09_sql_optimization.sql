-- ======================================
-- Day 9: SQL Performance Optimization
-- PostgreSQL Compatible
-- ======================================

-- 1️⃣ Create indexes on frequently joined and filtered columns
-- These indexes dramatically improve query performance


CREATE INDEX IF NOT EXISTS idx_customers_customer_id
ON customers (customer_id);

CREATE INDEX IF NOT EXISTS idx_responses_customer_id
ON responses (customer_id);

CREATE INDEX IF NOT EXISTS idx_responses_campaign_id
ON responses (campaign_id);

CREATE INDEX IF NOT EXISTS idx_campaigns_campaign_id
ON campaigns (campaign_id);

CREATE INDEX IF NOT EXISTS idx_responses_response
ON responses (response);

-- --------------------------------------

-- 2️⃣ Optimized conversion analysis query
-- Uses indexed columns and avoids unnecessary calculations

SELECT
    ca.campaign_id,
    COUNT(r.customer_id) AS total_customers,
    COUNT(*) FILTER (WHERE r.response = 'yes') AS total_conversions,
    ROUND(
        COUNT(*) FILTER (WHERE r.response = 'yes') * 100.0
        / COUNT(r.customer_id),
        2
    ) AS conversion_rate
FROM campaigns ca
JOIN responses r
    ON ca.campaign_id = r.campaign_id
GROUP BY ca.campaign_id
ORDER BY conversion_rate DESC;

-- --------------------------------------

-- 3️⃣ Optimized high-value customer query
-- Avoids nested subqueries, uses GROUP BY efficiently

SELECT
    c.customer_id,
    c.job,
    COUNT(*) FILTER (WHERE r.response = 'yes') AS conversions
FROM customers c
JOIN responses r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.job
HAVING COUNT(*) FILTER (WHERE r.response = 'yes') > 0
ORDER BY conversions DESC;

-- --------------------------------------

-- 4️⃣ Analyze query performance (optional but recommended)
-- Run this separately in SQLTools if needed

EXPLAIN ANALYZE
SELECT
    ca.campaign_id,
    COUNT(*) FILTER (WHERE r.response = 'yes') AS conversions
FROM campaigns ca
JOIN responses r
    ON ca.campaign_id = r.campaign_id
GROUP BY ca.campaign_id;
