-- DQ check 9: orders dated after the dataset's last valid month (Jun 2026).
-- The cutoff is a parameter, not a guess: change it when the dataset grows.
SELECT order_id, customer_id, order_date FROM orders WHERE order_date > '2026-06-30';
