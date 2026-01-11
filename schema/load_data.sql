INSERT INTO customers (age, job, marital, education, balance)
SELECT DISTINCT age, job, marital, education, balance
FROM bank_raw;

INSERT INTO campaigns (contact, month, duration)
SELECT DISTINCT contact, month, duration
FROM bank_raw;

INSERT INTO responses (customer_id, campaign_id, response)
SELECT
    c.customer_id,
    ca.campaign_id,
    b.y
FROM bank_raw b
JOIN customers c
  ON b.age = c.age AND b.balance = c.balance
JOIN campaigns ca
  ON b.contact = ca.contact AND b.month = ca.month;
