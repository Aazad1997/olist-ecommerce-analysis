WITH spend AS (
    SELECT c.customer_unique_id,
           SUM(oi.price) AS total_spend
    FROM customers c
    JOIN orders o       ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id   = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
tiered AS (
    SELECT *, NTILE(4) OVER (ORDER BY total_spend DESC) AS tier
    FROM spend
)
SELECT
    tier,
    COUNT(*)                         AS customers,
    ROUND(SUM(total_spend), 2)       AS revenue,
    ROUND(100.0 * SUM(total_spend) / SUM(SUM(total_spend)) OVER (), 1) AS pct_of_revenue
FROM tiered
GROUP BY tier
ORDER BY tier;
