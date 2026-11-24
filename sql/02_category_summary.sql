-- Question: For each category, how many partners are in it and what is the total rupee change?
WITH changes AS (
  SELECT partner_id, fy, amc_value, status,
         LAG(amc_value) OVER (PARTITION BY partner_id ORDER BY fy) AS prev_value
  FROM amc_renewals
),
classified AS (
  SELECT partner_id,
         amc_value - prev_value AS change_rs,
         (amc_value - prev_value) * 100.0 / prev_value AS change_pct,
         CASE WHEN amc_value > prev_value THEN 'Above previous'
              WHEN amc_value < prev_value THEN 'Below previous'
              ELSE 'At previous' END AS category
  FROM changes
  WHERE fy = '2026-27' AND status = 'Closed' AND prev_value IS NOT NULL
)
SELECT category,
       COUNT(*) AS partners,
       SUM(change_rs) AS total_change_rs,
       ROUND(AVG(change_pct), 1) AS avg_change_pct
FROM classified
GROUP BY category
ORDER BY avg_change_pct DESC;
