SELECT
    COALESCE(t.product_category_name_english,
             p.product_category_name,
             'unknown')                 AS category,
    COUNT(DISTINCT oi.order_id)         AS orders,
    ROUND(SUM(oi.price), 2)             AS revenue
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation t
       ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY revenue desc;
