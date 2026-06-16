-- ============================================
-- OLIST E-COMMERCE ANALYTICS
-- DATA CLEANING & PREPARATION
-- ============================================

-- Standardize timestamp columns

ALTER TABLE public.olist_orders_dataset
ALTER COLUMN order_approved_at
TYPE timestamp
USING NULLIF(TRIM(order_approved_at), '')::timestamp;

ALTER TABLE public.olist_orders_dataset
ALTER COLUMN order_delivered_carrier_date
TYPE timestamp
USING NULLIF(TRIM(order_delivered_carrier_date), '')::timestamp;

ALTER TABLE public.olist_orders_dataset
ALTER COLUMN order_delivered_customer_date
TYPE timestamp
USING NULLIF(TRIM(order_delivered_customer_date), '')::timestamp;

ALTER TABLE public.olist_orders_dataset
ALTER COLUMN order_estimated_delivery_date
TYPE timestamp
USING NULLIF(TRIM(order_estimated_delivery_date), '')::timestamp;

-- Data Quality Check
-- Check for missing customer zip codes

SELECT
    COUNT(*) AS total_rows
FROM
    olist_customers_dataset
WHERE
    customer_zip_code_prefix IS NULL;