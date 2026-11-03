INSERT INTO customers VALUES
  (1,'Ayesha Khan','ayesha@example.com','0300-1111111','Lahore'),
  (2,'Bilal Ahmed','bilal@example.com','0300-2222222','Karachi'),
  (3,'Ayesha Copy','ayesha@example.com','0300-3333333','Lahore'),  -- DEFECT: duplicate email of id 1
  (4,'Hira Shah',NULL,NULL,'Peshawar'),                              -- DEFECT: missing email + phone
  (5,'Usman Tariq','usman@example.com','0300-5555555','Islamabad'),
  (6,'Fatima Noor','fatima@example.com','0300-6666666','Multan');
INSERT INTO products VALUES
  (1,'SKU-101','LED Desk Lamp',4200),
  (2,'SKU-102','Bluetooth Speaker',6500),
  (3,'SKU-102','Speaker Twin',6500),   -- DEFECT: duplicate SKU of id 2
  (4,'SKU-104','Broken Kettle',-500),  -- DEFECT: negative price
  (5,'SKU-105','Free Notebook',0),     -- DEFECT: zero price
  (6,'SKU-106','Office Chair',18900);
INSERT INTO orders VALUES
  (1,1,'2026-01-05'), (2,2,'2026-02-10'), (3,5,'2026-03-12'),
  (4,NULL,'2026-04-01'),               -- DEFECT: null customer (orphan order)
  (5,6,'2027-01-15'),                  -- DEFECT: future date (dataset ends Jun 2026)
  (6,1,'2026-05-20');                  -- DEFECT: order with no lines (see lines below: no line references 6)
INSERT INTO order_lines VALUES
  (1,1,1,2,8400), (2,1,2,1,6500), (3,2,6,1,18900),
  (4,3,1,1,4200), (5,3,99,1,1000),   -- DEFECT: product 99 does not exist (orphan line)
  (6,4,2,0,0),                        -- DEFECT: qty 0
  (7,5,6,-1,-18900),                  -- DEFECT: negative qty
  (8,2,1,1,9999),                     -- DEFECT: line total != qty*price (1*4200=4200, stored 9999)
  (9,2,1,1,4200);                     -- DEFECT: duplicate order+product pair with line 8 (order 2, product 1 twice)
