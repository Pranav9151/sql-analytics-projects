-- ======================================
-- Day 8: Customer Lifetime Value (LTV)
-- Business Question:
-- What is the estimated lifetime value of each customer?
-- ======================================

/*
Assumptions:
- Revenue per successful conversion = 100 units
*/

WITH customer_conversions AS (
    SELECT
        c.customer_id,
        c.job,
        c.education,
        COUNT(CASE WHEN r.response = 'yes' THEN 1 END) AS total_conversions
    FROM customers c
    LEFT JOIN responses r
        ON c.customer_id = r.customer_id
    GROUP BY c.customer_id, c.job, c.education
),

customer_ltv AS (
    SELECT
        customer_id,
        job,
        education,
        total_conversions,
        total_conversions * 100 AS estimated_ltv
    FROM customer_conversions
)

SELECT *
FROM customer_ltv
ORDER BY estimated_ltv DESC;
