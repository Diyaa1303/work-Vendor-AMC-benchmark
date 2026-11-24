-- Question: Which partners grew more than the average partner against their previous AMC value?
WITH changes AS (
  SELECT partner_id, fy, amc_value, status,
         LAG(amc_value) OVER (PARTITION BY partner_id ORDER BY fy) AS prev_value
  FROM amc_renewals
),
growth AS (
  SELECT p.partner_name, p.region, c.prev_value, c.amc_value,
         ROUND((c.amc_value - c.prev_value) * 100.0 / c.prev_value, 1) AS change_pct
  FROM changes c
  JOIN partners p ON p.partner_id = c.partner_id
  WHERE c.fy = '2026-27' AND c.status = 'Closed' AND c.prev_value IS NOT NULL
)
SELECT partner_name, region, prev_value, amc_value, change_pct
FROM growth
WHERE change_pct > (SELECT AVG(change_pct) FROM growth)
ORDER BY change_pct DESC;
