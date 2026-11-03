-- DQ check 8: line totals that do not equal qty x product price.
-- Lines on missing products are excluded here: query 06 already catches them.
SELECT l.line_id, l.order_id, l.qty, p.price_pkr, l.line_total_pkr,
       l.qty * p.price_pkr AS expected_total
FROM order_lines l JOIN products p ON p.product_id = l.product_id
WHERE l.line_total_pkr <> l.qty * p.price_pkr;
