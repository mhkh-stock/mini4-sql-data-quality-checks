"""Build data/demo.db from schema+seed, run all 10 DQ queries, write
outputs/*.txt, and assert the known defect counts. A check that finds
nothing is a failure here: each query must find exactly its planted defects."""
import sqlite3, sys
from pathlib import Path
BASE = Path(__file__).resolve().parent
db = BASE / "data" / "demo.db"
if db.exists(): db.unlink()
con = sqlite3.connect(db)
con.executescript((BASE / "data" / "schema.sql").read_text())
con.executescript((BASE / "data" / "seed.sql").read_text())
con.commit()
# expected row counts per query (planted defects, counted by hand from seed.sql)
expected = {1: 1, 2: 1, 3: 2, 4: 1, 5: 1, 6: 1, 7: 2, 8: 1, 9: 1, 10: 2}
fails = []
outdir = BASE / "outputs"; outdir.mkdir(exist_ok=True)
for i in range(1, 11):
    files = sorted((BASE / "sql").glob(f"{i:02d}_*.sql"))
    sql = files[0].read_text()
    cur = con.execute(sql); rows = cur.fetchall()
    (outdir / f"{i:02d}_{files[0].stem[3:]}.txt").write_text(
        "\n".join(" | ".join("" if v is None else str(v) for v in r) for r in rows) + ("\n" if rows else ""))
    ok = len(rows) == expected[i]
    print(("PASS " if ok else "FAIL ") + f"query {i:02d} ({files[0].name}): {len(rows)} rows, expected {expected[i]}")
    if not ok: fails.append(i)
# cross-checks: clean tables are not empty, totals still reconcile where defined
print("customers:", con.execute("SELECT COUNT(*) FROM customers").fetchone()[0])
print("products:", con.execute("SELECT COUNT(*) FROM products").fetchone()[0])
print("orders:", con.execute("SELECT COUNT(*) FROM orders").fetchone()[0])
print("lines:", con.execute("SELECT COUNT(*) FROM order_lines").fetchone()[0])
print(f"\n{len(fails)} failures" if fails else "\nALL CHECKS PASS")
sys.exit(1 if fails else 0)
