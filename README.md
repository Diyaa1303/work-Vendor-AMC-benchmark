# Vendor AMC Benchmark

SQL analysis of how partners' AMC (annual maintenance contract) closing values compare with the previous year, built to produce a benchmark list that could inform revenue payout tiers.

**All data is simulated.** It is inspired by the kind of renewal reporting I do in my role, but contains no real company, partner or contract data.

## Business questions

1. Which partners closed above, below or at their previous AMC value?
2. How big is the change, in rupees and in percent?
3. Which regions are growing and which are shrinking?
4. Which partners beat the overall average, and which have grown consistently?

## Data

| Table | What it holds |
|---|---|
| `partners` | 20 partners with region (South, North, West, East) |
| `amc_renewals` | AMC closing value per partner for 2024-25, 2025-26 and 2026-27, with a status of Closed, Pending or Lapsed |

The data is deliberately a little messy, as real data is: one partner lapsed, two are still pending, and one is new with no previous year to compare against. The files are in `sql/00_setup.sql`, `partners.csv` and `amc_renewals.csv`.

## Queries

| File | Question | SQL skills |
|---|---|---|
| `00_setup.sql` | Create and load the tables (safe to re-run) | `CREATE TABLE`, `INSERT`, `DROP TABLE IF EXISTS` |
| `01_above_below_at.sql` | Which partners closed above, below or at the previous value? | CTE, `LAG`, `PARTITION BY`, `CASE WHEN` |
| `02_category_summary.sql` | How many partners and how much rupee change per category? | chained CTEs, `GROUP BY` |
| `03_region_average.sql` | How did each region perform on average? | `JOIN`, `AVG`, `GROUP BY` |
| `04_above_average.sql` | Which partners beat the overall average change? | subquery |
| `05_consistent_growth.sql` | Which partners grew in every year compared? | `SUM(CASE WHEN ...)`, `HAVING` |

## Findings

- Of the 20 partners, 16 closed in 2026-27 with a previous year to compare against: **8 closed above, 3 at, and 5 below** their previous value.
- The 8 growing partners added ₹171,000 in total, but the 5 shrinking ones lost ₹221,000, so the **net change was -₹50,000**.
- Falcon Digital grew the most (+25.1%). Indigo Systems fell the most in percent (-22.1%), and Summit Networks lost the most in rupees (-₹86,000).
- **East** was the only region with clear growth (+8.6% on average across 4 partners). West declined the most, losing ₹102,000 in total.
- **Delta Networks, Horizon Technologies and Lotus Data** grew in both years, making them the strongest candidates for a top benchmark tier. All three are in the East region.

## Who was left out, and why

Four partners are not in the comparison: Apex Systems (lapsed), Cobalt Infosolutions and Everest IT (still pending), and Tidal Computing (new, so no previous value). Deciding who belongs in a benchmark is part of the analysis, and these exclusions should be reviewed before payouts are set.

## Limitations

- The average change is a simple average of percentages, so a small partner counts as much as a large one. A weighted version would be a sensible next step.
- Growth alone doesn't explain *why* a partner grew. Price revisions, equipment changes or one-off deals should be checked before a payout is linked to it.
- The payout thresholds themselves are a business decision, not something the SQL can decide.

## How to run it

1. Open any SQLite tool, for example [sqliteonline.com](https://sqliteonline.com).
2. Paste in `sql/00_setup.sql` and run it once.
3. Clear the editor, then paste and run any other query file.
