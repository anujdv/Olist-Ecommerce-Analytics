-- ============================================
-- OLIST E-COMMERCE ANALYTICS
-- CUSTOMER EXPERIENCE ANALYSIS
-- ============================================

-- Product Categories By Customer Satisfaction

SELECT
    t.product_category_name_english AS category_name,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM
    olist_order_reviews_dataset r
JOIN
    olist_order_items_dataset oi
ON
    r.order_id = oi.order_id
JOIN
    olist_products_dataset pr
ON
    oi.product_id = pr.product_id
JOIN
    product_category_name_translation t
ON
    pr.product_category_name = t.product_category_name
GROUP BY
    category_name
HAVING
    COUNT(*) > 100
ORDER BY
    average_review_score DESC;

-- Delivery Delays Vs Customer Satisfaction

SELECT
    CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status,

    ROUND(AVG(r.review_score), 2) AS review_score_average,

    COUNT(*) AS total_orders

FROM
    olist_orders_dataset o
JOIN
    olist_order_reviews_dataset r
ON
    o.order_id = r.order_id

WHERE
    order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL

GROUP BY
    delivery_status;


-- Customers By State

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY total_customers DESC;


-- Review Score By State

SELECT
    c.customer_state,

    ROUND(
        AVG(r.review_score),
        2
    ) AS average_review_score

FROM olist_customers_dataset c
JOIN olist_orders_dataset o
    ON c.customer_id = o.customer_id
JOIN olist_order_reviews_dataset r
    ON o.order_id = r.order_id

GROUP BY c.customer_state

ORDER BY average_review_score DESC;



