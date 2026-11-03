-- DQ check 5: orders with no lines (an order that sells nothing).
SELECT o.order_id, o.customer_id, o.order_date FROM orders o
LEFT JOIN order_lines l ON l.order_id = o.order_id WHERE l.line_id IS NULL;
