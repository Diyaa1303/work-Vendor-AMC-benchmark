-- Question: How did each region perform on average against the previous AMC value?
WITH changes AS (
  SELECT partner_id, fy, amc_value, status,
         LAG(amc_value) OVER (PARTITION BY partner_id ORDER BY fy) AS prev_value
  FROM amc_renewals
)
SELECT p.region,
       COUNT(*) AS partners,
       ROUND(AVG((c.amc_value - c.prev_value) * 100.0 / c.prev_value), 1) AS avg_change_pct,
       SUM(c.amc_value - c.prev_value) AS total_change_rs
FROM changes c
JOIN partners p ON p.partner_id = c.partner_id
WHERE c.fy = '2026-27'
  AND c.status = 'Closed'
  AND c.prev_value IS NOT NULL
GROUP BY p.region
ORDER BY avg_change_pct DESC;
