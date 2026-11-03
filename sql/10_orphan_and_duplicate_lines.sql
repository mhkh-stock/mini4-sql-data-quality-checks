-- DQ check 10 (two parts, one discipline): (a) orders with no customer,
-- (b) the same order+product appearing on two lines.
SELECT 'orphan_order' AS issue, order_id, NULL AS product_id, COUNT(*) AS n
FROM orders WHERE customer_id IS NULL GROUP BY order_id
UNION ALL
SELECT 'duplicate_line', order_id, product_id, COUNT(*) FROM order_lines
GROUP BY order_id, product_id HAVING COUNT(*) > 1;
