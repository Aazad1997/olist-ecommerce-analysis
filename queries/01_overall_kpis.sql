SELECT
    COUNT(DISTINCT o.order_id)             AS total_orders,
    COUNT(DISTINCT c.customer_unique_id)   AS unique_customers,
    ROUND(SUM(oi.price), 2)                AS product_revenue,
    ROUND(SUM(oi.freight_value), 2)        AS freight_collected,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers c    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered';
