-- DQ check 1: duplicate customer emails (same email, more than one customer).
SELECT email, COUNT(*) AS customers, GROUP_CONCAT(customer_id) AS ids
FROM customers WHERE email IS NOT NULL GROUP BY email HAVING COUNT(*) > 1;
