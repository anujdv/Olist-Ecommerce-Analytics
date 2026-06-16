-- ============================================
-- OLIST E-COMMERCE ANALYTICS
-- CORE BUSINESS KPIs
-- ============================================

-- Total Revenue

SELECT
    ROUND(SUM(payment_value)::numeric, 2) AS total_revenue
FROM
    olist_order_payments_dataset;

-- Total Customers

SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM
    olist_customers_dataset;

-- Average Order Value

SELECT
    ROUND(
        SUM(payment_value::numeric)
        / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM
    olist_order_payments_dataset;

-- Average Review Score

SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM
    olist_order_reviews_dataset;

-- Orders Per Customer

SELECT
    ROUND(
        COUNT(DISTINCT o.order_id)::numeric
        /
        COUNT(DISTINCT c.customer_unique_id),
        2
    ) AS orders_per_customer
FROM
    olist_orders_dataset o
JOIN
    olist_customers_dataset c
ON
    o.customer_id = c.customer_id;


-- Repeat Customers

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        c.customer_unique_id
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) > 1
) t;



-- Repeat Retention Rate

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM olist_orders_dataset o
    JOIN olist_customers_dataset c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)

SELECT
    ROUND(
        100.0 *
        COUNT(*) FILTER (WHERE total_orders > 1)
        / COUNT(*),
        2
    ) AS repeat_retention_rate
FROM customer_orders;