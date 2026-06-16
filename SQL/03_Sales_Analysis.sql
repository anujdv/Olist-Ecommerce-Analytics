-- ============================================
-- OLIST E-COMMERCE ANALYTICS
-- SALES PERFORMANCE ANALYSIS
-- ============================================

-- Monthly Revenue Trend

SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS month,
    ROUND(SUM(p.payment_value)::numeric, 2) AS revenue
FROM
    olist_orders_dataset o
JOIN
    olist_order_payments_dataset p
ON
    o.order_id = p.order_id
GROUP BY
    month
ORDER BY
    month;

-- Highest Revenue Month

SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS month,
    ROUND(SUM(p.payment_value)::numeric, 2) AS revenue
FROM
    olist_orders_dataset o
JOIN
    olist_order_payments_dataset p
ON
    o.order_id = p.order_id
GROUP BY
    month
ORDER BY
    revenue DESC
LIMIT 1;

-- Revenue By State

SELECT
    c.customer_state,
    ROUND(SUM(p.payment_value)::numeric, 2) AS revenue
FROM
    olist_order_payments_dataset p
JOIN
    olist_orders_dataset o
ON
    p.order_id = o.order_id
JOIN
    olist_customers_dataset c
ON
    o.customer_id = c.customer_id
GROUP BY
    c.customer_state
ORDER BY
    revenue DESC;

-- Top Product Categories By Revenue

SELECT
    t.product_category_name_english AS category,
    ROUND(SUM(oi.price)::numeric, 2) AS revenue
FROM
    olist_order_items_dataset oi
JOIN
    olist_products_dataset pr
ON
    oi.product_id = pr.product_id
JOIN
    product_category_name_translation t
ON
    pr.product_category_name = t.product_category_name
GROUP BY
    category
ORDER BY
    revenue DESC;




-- Revenue Per Customer By State

SELECT
    c.customer_state,

    ROUND(
        SUM(p.payment_value)::numeric
        /
        COUNT(DISTINCT c.customer_unique_id),
        2
    ) AS revenue_per_customer

FROM olist_customers_dataset c
JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id

GROUP BY c.customer_state

ORDER BY revenue_per_customer DESC;