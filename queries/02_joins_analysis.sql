-- ======================================
-- Day 2: Customer Segmentation Analysis
-- Business Question:
-- Which customer segments convert the most?
-- ======================================

-- Step 1: Create a joined dataset of customers and responses
WITH customer_responses AS (
    SELECT
        c.customer_id,
        c.age,
        c.job,
        c.balance,
        r.response
    FROM customers c
    JOIN responses r
        ON c.customer_id = r.customer_id
)

-- ======================================
-- 1. Conversion Rate by Age Group
-- ======================================
SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 45 THEN '30-45'
        ELSE 'Above 45'
    END AS age_group,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN response = 'yes' THEN 1 END) AS total_converted,
    ROUND(
        COUNT(CASE WHEN response = 'yes' THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS conversion_rate
FROM customer_responses
GROUP BY age_group
ORDER BY conversion_rate DESC;


