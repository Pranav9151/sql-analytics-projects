-- ======================================
-- Day 4: Campaign ROI & Cost Performance
-- Business Question:
-- Which campaigns generate the highest ROI?
-- ======================================

/*
Assumptions (very common in analytics case studies):
- Cost per customer contacted = 5 units
- Revenue per successful conversion = 100 units
*/

WITH campaign_metrics AS (
    SELECT
        ca.campaign_id,
        ca.contact,
        ca.month,
        COUNT(r.response_id) AS total_customers,
        COUNT(CASE WHEN r.response = 'yes' THEN 1 END) AS total_conversions
    FROM campaigns ca
    JOIN responses r
        ON ca.campaign_id = r.campaign_id
    GROUP BY ca.campaign_id, ca.contact, ca.month
),

campaign_financials AS (
    SELECT
        campaign_id,
        contact,
        month,
        total_customers,
        total_conversions,
        total_customers * 5 AS total_cost,
        total_conversions * 100 AS total_revenue,
        (total_conversions * 100 - total_customers * 5) AS profit,
        ROUND(
            (total_conversions * 100 - total_customers * 5) * 100.0
            / (total_customers * 5),
            2
        ) AS roi_percentage
    FROM campaign_metrics
)

SELECT
    campaign_id,
    contact,
    month,
    total_customers,
    total_conversions,
    total_cost,
    total_revenue,
    profit,
    roi_percentage,
    DENSE_RANK() OVER (ORDER BY roi_percentage DESC) AS roi_rank
FROM campaign_financials
ORDER BY roi_rank;

