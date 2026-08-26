# Sample outputs — open these after you have tried it yourself

These are the files the Chapter 11 projects produce. Treat them as an answer key.

    Project ⑥ cleaned   delivery-log-august-clean.csv
    Project ⑦ report    supply-summary-2026-08-single-sheet.xlsx
    Project ⑦ template  supply-summary-2026-09.xlsx
    Project ⑦ finished  supply-summary-2026-08.xlsx   ← 3 sheets + chart + rules
    11.4 taster         supplies.db · rooms.db

Your result does not have to match these word for word. **If the numbers match,
you got it right.** Wording, column widths and colours vary between runs.

---

## What to compare

| Your file | What to check |
|---|---|
| Cleaned CSV | 9 rows (10 − 1 duplicate) · one "return" in the Type column |
| Supply summary | **74 units · 903,500 won** across five items |
| supplies.db | 3 · 3 · 3 rows by department, 903,500 in total |
| rooms.db | Room A 8 bookings 10.0 h · Room B 4 bookings 6.5 h · 1 double booking |

---

## supply-summary-2026-08.xlsx — three sheets

Project ⑦ grows one file over five prompts, and only the last state survives.
So the **intermediate single-sheet version is included separately**.

    supply-summary-2026-08-single-sheet.xlsx   after prompt 07 — 13 formulas
    supply-summary-2026-08.xlsx                through prompts 09, 10, 11 — 26 formulas

The formula counts are the ones printed in the book. Count them if you like.

### Sheet structure

    Raw        9 rows. Not one formula — this is where a person types
    Items      23 formulas. Reads Raw with SUMIFS
    Overview   3 formulas. Reads Items

**Type on the Raw sheet only.** Overwrite a cell on Items or Overview and that
one cell dies while the sheet still looks fine. That is the only way to break
this structure.

### Chain recalculation — try it

On the Raw sheet, change **C2 (Sales 1, A4 paper, qty) from 10 to 20**.

    Items    A4 paper qty      23 → 33
    Items    A4 paper amount   575,000 → 825,000
    Overview total            903,500 → 1,153,500

If all three follow, the formulas are real. Put the value back afterwards.

### Highlight rules

    Raw   · amount 200,000 or more   2 cells (Sales 1 A4 paper 250,000 · HR A4 paper 200,000)
    Items · share above 60%          1 cell  (A4 paper 63.6%)

Both use colour **and bold**, so black-and-white printing still separates them.

### The September template

`supply-summary-2026-09.xlsx` has the qty and unit price cleared. Fill them in
and the amount, total and share appear. A blank Share column is expected while
the sheet is empty.

---

## supplies.db · rooms.db — how to open them

Nothing to install. Ask Claude Code:

    Give me the total request amount by department from supplies.db.
    Check rooms.db for bookings that overlap in time.

`supplies.db` holds one table, **requests**, with 9 records. `rooms.db` holds
one table, **bookings**, with 12. The file *is* the database — copy it and you
have a backup.

---

## Four places these differ from the book

Building them turned up four mistakes in the manuscript. **The files are right.**

| Where | The book | Actual |
|---|---|---|
| Demo 11-14 | HR (224,000) above Gen affairs (227,500) | Sorted by amount, Gen affairs is above |
| Demo 11-8 | `SUMIFS(Raw!$F:$F, …)` | Amount is column E — `$E:$E` |
| Demo 11-8 | `=COUNTA(Raw!A2:A100)-COUNTBLANK(…)` | Counts the note line too, giving 10 |
| Demo 11-6 | Toner unit price 85,000 → 89,000 | It is 89,000 in all three months — only the quantity went up |

These files follow the third column. The row count is
`=COUNT(Raw!$E$2:$E$100)`, which counts only rows that carry an amount.

`supply-summary-cumulative.xlsx` (demo 11-6) is not in the answer set. It is the
file **you** build in practice 6. Its three monthly inputs are in `monthly/`.

    monthly/supply-summary-2026-06.xlsx   9 rows · 723,000
    monthly/supply-summary-2026-07.xlsx   9 rows · 787,500
    monthly/supply-summary-2026-08.xlsx   9 rows · 903,500

Stacked, the three months come to **27 rows**. The August file carries the same
numbers as practice 7's finished workbook — practice 7 turns that raw data into
a report, practice 6 stacks three months of it. Different uses, same source.

Toner's 50% rise comes from **the quantity going 2 to 3**. The unit price is
89,000 in all three months (fourth row of the table above).

---

## One note on the cleaned CSV

The Green Mart A4 paper unit price is `25000` here.

The original is `"25,000"` — a comma inside quotes. Prompt 05 in the book does
not list this one among its instructions, so your own run may well leave it as
`"25,000"`. **Neither is wrong.** But left alone, Excel reads that one cell as
text and the total goes off (Table 11-17), so it is a number here.
