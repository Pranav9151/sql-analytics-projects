-- Basic customer distribution analysis
-- Day 1: Customer & Conversion Overview

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_responses
FROM responses;

SELECT
    COUNT(CASE WHEN response = 'yes' THEN 1 END) * 100.0 / COUNT(*) AS conversion_rate
FROM responses;
