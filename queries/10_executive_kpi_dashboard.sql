-- ======================================
-- Day 10: Executive KPI Framework
-- SQL Server Compatible Version
-- ======================================

WITH overall_metrics AS (
    SELECT
        COUNT(DISTINCT r.customer_id) AS total_customers_contacted,
        SUM(CASE WHEN r.response = 'yes' THEN 1 ELSE 0 END) AS total_conversions,
        ROUND(
            SUM(CASE WHEN r.response = 'yes' THEN 1 ELSE 0 END) * 100.0
            / COUNT(DISTINCT r.customer_id),
            2
        ) AS overall_conversion_rate
    FROM responses r
),

balance_metrics AS (
    SELECT
        ROUND(AVG(balance), 2) AS avg_customer_balance
    FROM customers
),

campaign_performance AS (
    SELECT
        ca.campaign_id,
        COUNT(r.customer_id) AS total_customers,
        SUM(CASE WHEN r.response = 'yes' THEN 1 ELSE 0 END) AS conversions,
        ROUND(
            SUM(CASE WHEN r.response = 'yes' THEN 1 ELSE 0 END) * 100.0
            / COUNT(r.customer_id),
            2
        ) AS conversion_rate
    FROM campaigns ca
    JOIN responses r
        ON ca.campaign_id = r.campaign_id
    GROUP BY ca.campaign_id
),

top_campaign AS (
    SELECT TOP 1
        campaign_id,
        conversion_rate
    FROM campaign_performance
    ORDER BY conversion_rate DESC
),

high_value_customers AS (
    SELECT
        COUNT(*) AS high_value_customer_count
    FROM (
        SELECT
            c.customer_id,
            SUM(CASE WHEN r.response = 'yes' THEN 1 ELSE 0 END) AS conversions
        FROM customers c
        JOIN responses r
            ON c.customer_id = r.customer_id
        GROUP BY c.customer_id
        HAVING SUM(CASE WHEN r.response = 'yes' THEN 1 ELSE 0 END) >= 2
    ) hv
)

SELECT
    om.total_customers_contacted,
    om.total_conversions,
    om.overall_conversion_rate,
    bm.avg_customer_balance,
    tc.campaign_id AS top_campaign_id,
    tc.conversion_rate AS top_campaign_conversion_rate,
    hv.high_value_customer_count
FROM overall_metrics om
CROSS JOIN balance_metrics bm
CROSS JOIN top_campaign tc
CROSS JOIN high_value_customers hv;
