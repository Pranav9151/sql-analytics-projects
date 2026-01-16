
-- ======================================
-- Day 5: High-Value Customer Targeting
-- Business Question:
-- Which customer segments are most likely to convert?
-- ======================================

WITH customer_behavior AS (
    SELECT
        c.job,
        c.education,
        CASE
            WHEN c.balance < 0 THEN 'Negative Balance'
            WHEN c.balance BETWEEN 0 AND 1000 THEN 'Low Balance'
            WHEN c.balance BETWEEN 1001 AND 5000 THEN 'Medium Balance'
            ELSE 'High Balance'
        END AS balance_segment,
        COUNT(*) AS total_customers,
        COUNT(CASE WHEN r.response = 'yes' THEN 1 END) AS conversions
    FROM customers c
    JOIN responses r
        ON c.customer_id = r.customer_id
    GROUP BY c.job, c.education, balance_segment
),

conversion_scoring AS (
    SELECT
        job,
        education,
        balance_segment,
        total_customers,
        conversions,
        ROUND(conversions * 100.0 / total_customers, 2) AS conversion_rate,
        DENSE_RANK() OVER (
            ORDER BY conversions * 100.0 / total_customers DESC
        ) AS segment_rank
    FROM customer_behavior
    WHERE total_customers >= 30
)

SELECT *
FROM conversion_scoring
ORDER BY segment_rank;
