SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id)  AS orders,
    ROUND(SUM(oi.price), 2)     AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers c    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY revenue DESC
