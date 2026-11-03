-- DQ check 6: order lines pointing at a product that does not exist.
SELECT l.line_id, l.order_id, l.product_id FROM order_lines l
LEFT JOIN products p ON p.product_id = l.product_id WHERE p.product_id IS NULL;
