-- Question: Which partners closed above their previous AMC value in every year we can compare?
WITH changes AS (
  SELECT partner_id, fy, amc_value, status,
         LAG(amc_value) OVER (PARTITION BY partner_id ORDER BY fy) AS prev_value
  FROM amc_renewals
)
SELECT p.partner_name, p.region,
       COUNT(*) AS years_compared,
       SUM(CASE WHEN c.amc_value > c.prev_value THEN 1 ELSE 0 END) AS years_above
FROM changes c
JOIN partners p ON p.partner_id = c.partner_id
WHERE c.status = 'Closed' AND c.prev_value IS NOT NULL
GROUP BY p.partner_id, p.partner_name, p.region
HAVING COUNT(*) = 2
   AND SUM(CASE WHEN c.amc_value > c.prev_value THEN 1 ELSE 0 END) = 2
ORDER BY p.partner_name;
