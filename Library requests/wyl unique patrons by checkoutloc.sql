/*
Jeremy Goldstein
Minuteman Library Network

Monthly checkouts with unique patron count by ma town
Takes variables for transaction location and unit of time to group the report by
*/

SELECT
  to_char(t.transaction_gmt, 'MM-DD-YY') AS transaction_date,
  l.name AS checkout_location,
  COUNT(t.id) AS total_checkouts,
  COUNT(DISTINCT(t.patron_record_id)) AS total_unique_patrons,
  ROUND(COUNT(t.id)::NUMERIC/COUNT(DISTINCT(t.patron_record_id)),2) AS avg_checkouts_per_patron

  FROM sierra_view.circ_trans t
  JOIN sierra_view.statistic_group_myuser s
    ON t.stat_group_code_num = s.code
  JOIN sierra_view.patron_record p
    ON t.patron_record_id = p.id
  JOIN sierra_view.location_myuser l
    ON s.location_code = l."code"
  
  WHERE t.op_code = 'o'
    AND t.transaction_gmt > NOW()::DATE - INTERVAL '1 month'
    AND p.pcode3 = '115'
  GROUP BY 1,2
