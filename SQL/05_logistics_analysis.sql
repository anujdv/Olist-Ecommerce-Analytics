-- ============================================
-- OLIST E-COMMERCE ANALYTICS
-- DELIVERY & LOGISTICS ANALYSIS
-- ============================================

-- Average Delivery Time

SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    - order_purchase_timestamp
                )
            ) / 86400
        )::numeric,
        2
    ) AS avg_delivery_days
FROM
    olist_orders_dataset
WHERE
    order_delivered_customer_date IS NOT NULL
    AND order_purchase_timestamp IS NOT NULL;

-- Delivery Performance Analysis

SELECT
    CASE
        WHEN order_delivered_customer_date >
             order_estimated_delivery_date
        THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status,

    COUNT(*) AS total_orders

FROM
    olist_orders_dataset

WHERE
    order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL

GROUP BY
    delivery_status;

-- Regional Delivery Delay Analysis

SELECT
    c.customer_state,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    o.order_delivered_customer_date
                    - o.order_estimated_delivery_date
                )
            ) / 86400
        )::numeric,
        2
    ) AS average_delay

FROM
    olist_customers_dataset c
JOIN
    olist_orders_dataset o
ON
    c.customer_id = o.customer_id

WHERE
    o.order_delivered_customer_date IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
    AND o.order_delivered_customer_date >
        o.order_estimated_delivery_date

GROUP BY
    c.customer_state

HAVING
    COUNT(*) > 50

ORDER BY
    average_delay DESC;