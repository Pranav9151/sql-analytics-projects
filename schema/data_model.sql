DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS responses;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    age INT,
    job TEXT,
    marital TEXT,
    education TEXT,
    balance INT
);

CREATE TABLE campaigns (
    campaign_id SERIAL PRIMARY KEY,
    contact TEXT,
    month TEXT,
    duration INT
);

CREATE TABLE responses (
    response_id SERIAL PRIMARY KEY,
    customer_id INT,
    campaign_id INT,
    response TEXT
);


