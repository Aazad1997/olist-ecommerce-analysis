SELECT
    COUNT(*) AS delivered_orders,
    ROUND(AVG(EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400)::numeric, 1)
        AS avg_delivery_days,
    ROUND(AVG(EXTRACT(EPOCH FROM (order_estimated_delivery_date - order_delivered_customer_date)) / 86400)::numeric, 1)
        AS avg_days_early,
    ROUND(100.0 * COUNT(*) FILTER (WHERE order_delivered_customer_date > order_estimated_delivery_date)
          / COUNT(*), 1) AS pct_late
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;
