-- DQ check 3: products priced at zero or below (cannot be sold as listed).
SELECT product_id, sku, name, price_pkr FROM products WHERE price_pkr <= 0;
