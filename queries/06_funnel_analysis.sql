-- ======================================
-- Day 6: Marketing Funnel Analysis
-- Business Question:
-- Where do customers drop off in the campaign funnel?
-- ======================================

WITH funnel_steps AS (
    SELECT
        ca.campaign_id,
        COUNT(r.customer_id) AS contacted,
        COUNT(CASE WHEN r.response IS NOT NULL THEN 1 END) AS responded,
        COUNT(CASE WHEN r.response = 'yes' THEN 1 END) AS converted
    FROM campaigns ca
    LEFT JOIN responses r
        ON ca.campaign_id = r.campaign_id
    GROUP BY ca.campaign_id
),

funnel_metrics AS (
    SELECT
        campaign_id,
        contacted,
        responded,
        converted,
        ROUND(responded * 100.0 / contacted, 2) AS response_rate,
        ROUND(converted * 100.0 / responded, 2) AS conversion_rate,
        ROUND(converted * 100.0 / contacted, 2) AS overall_conversion_rate
    FROM funnel_steps
)

SELECT *
FROM funnel_metrics
ORDER BY campaign_id;
