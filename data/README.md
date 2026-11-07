# Mini #4 data — dictionary

Fictional demo shop, 6 customers · 6 products · 6 orders · 9 order
lines, Jan–May 2026 (plus one deliberately future-dated order).
SAMPLE / DEMO data only — fictional people, products, and orders.

Schema: `schema.sql`. Seed: `seed.sql` — every intentional defect is
marked `DEFECT` with its reason, so a reader can tell a planted defect
from a mistake. Rebuild: `python3 run_queries.py` (also runs the checks).

Note: the schema declares foreign keys, but SQLite does not enforce
them unless `PRAGMA foreign_keys = ON` — the runner does not set it,
which is exactly how the orphan rows below can exist.

## customers (6 rows)

| Column | Type | Meaning |
|---|---|---|
| `customer_id` | INTEGER PK | Customer id |
| `name` | TEXT NOT NULL | Customer name |
| `email` | TEXT, nullable | Contact email. DEFECT: ids 1 and 3 share `ayesha@example.com` (check 01); id 4 (Hira Shah) is NULL (check 02) |
| `phone` | TEXT, nullable | Contact phone. DEFECT: id 4 is NULL (check 02) |
| `city` | TEXT | Customer city (Lahore, Karachi, Peshawar, Islamabad, Multan) |

## products (6 rows)

| Column | Type | Meaning |
|---|---|---|
| `product_id` | INTEGER PK | Product id |
| `sku` | TEXT NOT NULL | Catalogue code. DEFECT: ids 2 and 3 both carry `SKU-102` (check 04) |
| `name` | TEXT NOT NULL | Product name |
| `price_pkr` | INTEGER NOT NULL | Listed price in PKR. DEFECT: id 4 (Broken Kettle) −500, id 5 (Free Notebook) 0 (check 03) |

## orders (6 rows)

| Column | Type | Meaning |
|---|---|---|
| `order_id` | INTEGER PK | Order id |
| `customer_id` | INTEGER, nullable, FK → customers | Who ordered. DEFECT: order 4 is NULL — an order with no customer (check 10) |
| `order_date` | TEXT NOT NULL (`YYYY-MM-DD`) | Order date. DEFECT: order 5 is `2027-01-15`, after the dataset ends Jun 2026 (check 09); order 6 has no lines at all (check 05) |

## order_lines (9 rows)

| Column | Type | Meaning |
|---|---|---|
| `line_id` | INTEGER PK | Line id |
| `order_id` | INTEGER NOT NULL, FK → orders | Parent order |
| `product_id` | INTEGER NOT NULL | Product sold. DEFECT: line 5 points at product 99, which does not exist (check 06) |
| `qty` | INTEGER NOT NULL | Quantity. DEFECT: line 6 is 0, line 7 is −1 (check 07) |
| `line_total_pkr` | INTEGER NOT NULL | Stored line total in PKR. DEFECT: line 8 stores 9,999 but 1 × 4,200 = 4,200 (check 08); lines 8 and 9 are the same order 2 + product 1 pair twice (check 10) |
