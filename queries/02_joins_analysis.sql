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


-- ======================================
-- 2. Conversion Rate by Job Type
-- ======================================

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

SELECT
    job,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN response = 'yes' THEN 1 END) AS total_converted,
    ROUND(
        COUNT(CASE WHEN response = 'yes' THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS conversion_rate
FROM customer_responses
GROUP BY job
ORDER BY conversion_rate DESC;





-- ======================================
-- 3. Conversion Rate by Balance Segment
-- ======================================

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


SELECT
    CASE
        WHEN balance < 500 THEN 'Low Balance'
        WHEN balance BETWEEN 500 AND 2000 THEN 'Mid Balance'
        ELSE 'High Balance'
    END AS balance_segment,
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN response = 'yes' THEN 1 END) AS total_converted,
    ROUND(
        COUNT(CASE WHEN response = 'yes' THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS conversion_rate
FROM customer_responses
GROUP BY balance_segment
ORDER BY conversion_rate DESC;



