-- Mini #4 demo schema. Intentional defects are marked DEFECT in seed.sql;
-- every query in sql/ is written to FIND one defect class, never to hide it.
CREATE TABLE customers (
  customer_id INTEGER PRIMARY KEY, name TEXT NOT NULL,
  email TEXT, phone TEXT, city TEXT
);
CREATE TABLE products (
  product_id INTEGER PRIMARY KEY, sku TEXT NOT NULL,
  name TEXT NOT NULL, price_pkr INTEGER NOT NULL
);
CREATE TABLE orders (
  order_id INTEGER PRIMARY KEY, customer_id INTEGER,
  order_date TEXT NOT NULL, FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE order_lines (
  line_id INTEGER PRIMARY KEY, order_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL, qty INTEGER NOT NULL, line_total_pkr INTEGER NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
