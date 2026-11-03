-- DQ check 4: duplicate SKUs (one code, two products — stock counts will double-count).
SELECT sku, COUNT(*) AS products, GROUP_CONCAT(product_id) AS ids
FROM products GROUP BY sku HAVING COUNT(*) > 1;
