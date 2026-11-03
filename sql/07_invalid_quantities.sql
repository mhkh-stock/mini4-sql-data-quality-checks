-- DQ check 7: line quantities of zero or below (nothing shipped, or a return typed as a sale).
SELECT line_id, order_id, product_id, qty FROM order_lines WHERE qty <= 0;
