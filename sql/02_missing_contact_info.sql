-- DQ check 2: customers missing email or phone (unreachable customers).
SELECT customer_id, name, email, phone FROM customers WHERE email IS NULL OR phone IS NULL;
