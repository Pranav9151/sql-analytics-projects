-- ======================================
-- Day 7: Customer Cohort Analysis
-- Business Question:
-- How do customer conversion trends vary by cohort month?
-- ======================================

/*
Cohort definition:
- Customer cohort = month of first campaign contact
*/

WITH customer_first_contact AS (
    SELECT
        r.customer_id,
        MIN(ca.month) AS cohort_month
    FROM responses r
    JOIN campaigns ca
        ON r.campaign_id = ca.campaign_id
    GROUP BY r.customer_id
),

cohort_activity AS (
    SELECT
        fc.cohort_month,
        ca.month AS activity_month,
        COUNT(DISTINCT r.customer_id) AS active_customers,
        COUNT(CASE WHEN r.response = 'yes' THEN 1 END) AS conversions
    FROM customer_first_contact fc
    JOIN responses r
        ON fc.customer_id = r.customer_id
    JOIN campaigns ca
        ON r.campaign_id = ca.campaign_id
    GROUP BY fc.cohort_month, ca.month
),

cohort_metrics AS (
    SELECT
        cohort_month,
        activity_month,
        active_customers,
        conversions,
        ROUND(conversions * 100.0 / active_customers, 2) AS conversion_rate
    FROM cohort_activity
)

SELECT *
FROM cohort_metrics
ORDER BY cohort_month, activity_month;
