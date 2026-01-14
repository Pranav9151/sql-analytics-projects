-- ======================================
-- Day 3: Campaign Performance Ranking
-- Business Question:
-- Which campaigns performed best based on conversion rate?
-- ======================================

-- Step 1: Build campaign-level metrics
WITH campaign_metrics AS (
    SELECT
        ca.campaign_id,
        ca.contact,
        ca.month,
        COUNT(r.response_id) AS total_customers,
        COUNT(CASE WHEN r.response = 'yes' THEN 1 END) AS total_conversions,
        ROUND(
            COUNT(CASE WHEN r.response = 'yes' THEN 1 END) * 100.0
            / COUNT(r.response_id),
            2
        ) AS conversion_rate
    FROM campaigns ca
    JOIN responses r
        ON ca.campaign_id = r.campaign_id
    GROUP BY ca.campaign_id, ca.contact, ca.month
)

-- Step 2: Rank campaigns by performance
SELECT
    campaign_id,
    contact,
    month,
    total_customers,
    total_conversions,
    conversion_rate,
    DENSE_RANK() OVER (ORDER BY conversion_rate DESC) AS campaign_rank
FROM campaign_metrics
ORDER BY campaign_rank;
