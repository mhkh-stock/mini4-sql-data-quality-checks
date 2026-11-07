# Mini #4 — SQL Data Quality Checks Pack

**SAMPLE / DEMO data only.** Fictional shop, fictional people, fictional
orders. Never claimed as real client or real business data.

The checks recruiters and clients actually run before they trust a
dataset: duplicates, missing values, impossible prices and quantities,
orphans, arithmetic mismatches, future dates. Each query finds exactly
one defect class — and on this demo data, every query must find its
planted defects, or the check itself is broken. A data-quality check
that finds nothing on dirty data is worse than no check at all.

## Demo dataset

Small on purpose: 6 customers · 6 products · 6 orders · 9 order lines.
13 planted defects across 10 checks (query 10 covers two related issues).
Schema: `data/schema.sql` · Seed: `data/seed.sql` (defects marked
`DEFECT`) · Dictionary: `data/README.md` · Built database:
`data/demo.db` (rebuild any time with `python3 run_queries.py`, which
also verifies every query).

## How to run (3 steps)

1. `cd mini4-sql-data-quality-checks`
2. `python3 run_queries.py` — builds `data/demo.db`, runs all 10
   queries, writes `outputs/*.txt`, and asserts the checks below
3. Run any query by hand, e.g.
   `sqlite3 -header -column data/demo.db < sql/01_duplicate_emails.sql`

Requires Python 3 + SQLite (standard library only). Verified on
Python 3.12.3 + SQLite 3.45.1.

## Queries

| File | Business question | Teaches | Verified output |
|---|---|---|---|
| `sql/01_duplicate_emails.sql` | Which customers share an email? | GROUP BY + HAVING on a non-key column | 1 group: ayesha@example.com (ids 1, 3) |
| `sql/02_missing_contact_info.sql` | Who can't we reach? | NULL checks (OR, not AND) | 1 row: Hira Shah, no email, no phone |
| `sql/03_invalid_prices.sql` | Which products can't be sold as listed? | Range filter on a money column | 2 rows: Broken Kettle −500, Free Notebook 0 |
| `sql/04_duplicate_skus.sql` | Which catalogue codes collide? | GROUP BY + HAVING on SKU | 1 group: SKU-102 (ids 2, 3) |
| `sql/05_orders_with_no_lines.sql` | Which orders sell nothing? | LEFT JOIN anti-join | 1 row: order 6 |
| `sql/06_orphan_lines.sql` | Which lines point at a product that doesn't exist? | LEFT JOIN anti-join, other side | 1 row: line 5, product 99 |
| `sql/07_invalid_quantities.sql` | Which lines ship nothing or less than nothing? | Range filter on qty | 2 rows: line 6 (qty 0), line 7 (qty −1) |
| `sql/08_line_total_mismatches.sql` | Which line totals don't match qty × price? | Join + computed comparison; orphan lines excluded (query 06 owns them) | 1 row: line 8, stored 9,999 vs expected 4,200 |
| `sql/09_future_dated_orders.sql` | Which orders are dated after the dataset ends? | Cutoff as a stated parameter (2026-06-30) | 1 row: order 5, 2027-01-15 |
| `sql/10_orphan_and_duplicate_lines.sql` | Which orders have no customer, and which order+product pairs repeat? | UNION ALL of two checks, one discipline | 2 rows: orphan order 4; duplicate pair order 2 + product 1 (lines 8, 9) |

## Verification (done before delivery)

- All 10 files execute against `data/demo.db` with no errors.
- Every query returns exactly its planted defect count (1, 1, 2, 1, 1,
  1, 2, 1, 1, 2) — 13 defects total, none missed, none double-counted
  across checks (query 08 deliberately excludes query 06's orphan line).
- Verified outputs are saved in `outputs/` (one `.txt` per query);
  `run_queries.py` re-asserts all of the above on every run.

## Limits

- SAMPLE / DEMO data only — fictional shop, Jan–May 2026 plus one
  future-dated order; SQLite only, standard library only.
- The checks detect defects; they do not fix them. `data/demo.db` is
  left dirty on purpose so every check keeps finding its defects.
- Query 09's cutoff (`'2026-06-30'`) is a hard-coded parameter in the
  SQL — change it when the dataset grows.
- Prices and quantities are whole PKR / whole units (INTEGER); no
  decimals, tax, or currency handling.
- The schema declares foreign keys, but SQLite does not enforce them
  unless `PRAGMA foreign_keys = ON` — the runner does not set it,
  which is exactly how the orphan rows in the seed can exist.
- Line 8 appears in two checks (08 and 10) because it carries two
  different defects — a wrong total and a duplicate order+product
  pair — not because one defect is counted twice.

## Note for the publisher

No GitHub repo was created and nothing was pushed, per the task —
the GitHub App cannot create repos, so this mini stays built
locally, verified and ready until its repo exists.
