WITH order_score AS (
    SELECT order_id, AVG(review_score) AS score
    FROM order_reviews
    GROUP BY order_id
),
order_cat AS (
    SELECT DISTINCT
        oi.order_id,
        COALESCE(t.product_category_name_english,
                 p.product_category_name, 'unknown') AS category
    FROM order_items oi
    JOIN orders o   ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
    LEFT JOIN product_category_name_translation t
           ON t.product_category_name = p.product_category_name
    WHERE o.order_status = 'delivered'
)
SELECT
    oc.category,
    COUNT(*)                 AS reviewed_orders,
    ROUND(AVG(s.score), 2)   AS avg_score
FROM order_cat oc
JOIN order_score s ON s.order_id = oc.order_id
GROUP BY oc.category
HAVING COUNT(*) >= 100
ORDER BY avg_score ASC
