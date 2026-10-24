WITH seller_rev AS (
    SELECT s.seller_id,
           s.seller_state,
           ROUND(SUM(oi.price), 2) AS revenue
    FROM order_items oi
    JOIN orders o   ON o.order_id  = oi.order_id
    JOIN sellers s  ON s.seller_id = oi.seller_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1, 2
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY seller_state ORDER BY revenue DESC) AS rnk
    FROM seller_rev
)
SELECT seller_state, seller_id, revenue
FROM ranked
WHERE rnk = 1
ORDER BY revenue DESC;
