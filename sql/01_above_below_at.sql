-- Question: Which partners closed 2026-27 above, below or at their previous AMC value?
WITH changes AS (
  SELECT partner_id, fy, amc_value, status,
         LAG(amc_value) OVER (PARTITION BY partner_id ORDER BY fy) AS prev_value
  FROM amc_renewals
)
SELECT p.partner_name,
       c.prev_value,
       c.amc_value,
       c.amc_value - c.prev_value AS change_rs,
       ROUND((c.amc_value - c.prev_value) * 100.0 / c.prev_value, 1) AS change_pct,
       CASE WHEN c.amc_value > c.prev_value THEN 'Above previous'
            WHEN c.amc_value < c.prev_value THEN 'Below previous'
            ELSE 'At previous' END AS category
FROM changes c
JOIN partners p ON p.partner_id = c.partner_id
WHERE c.fy = '2026-27'
  AND c.status = 'Closed'
  AND c.prev_value IS NOT NULL
ORDER BY change_pct DESC;
