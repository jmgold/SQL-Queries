/*
Jeremy Goldstein
Minuteman Library Network
Provides checkin counts broken out by if they were returned to the same location they were checked out from or not
*/

WITH checkouts AS(
  SELECT
    t.transaction_gmt,
    t.patron_record_id,
    t.item_record_id,
    s.location_code AS checkout_location

  FROM sierra_view.circ_trans t
  JOIN sierra_view.statistic_group_myuser s
    ON t.stat_group_code_num = s.code

  WHERE t.op_code = 'o'
)

SELECT
  o.checkout_location,
  COUNT(i.id) FILTER (WHERE o.checkout_location = s.location_code) AS total_returned_to_checkout_location,
  COUNT(i.id) FILTER (WHERE o.checkout_location != s.location_code) AS total_returned_to_different_location

FROM sierra_view.circ_trans i
JOIN checkouts o
  ON i.patron_record_id = o.patron_record_id
  AND i.item_record_id = o.item_record_id
  AND i.transaction_gmt > o.transaction_gmt
JOIN sierra_view.statistic_group_myuser s
  ON i.stat_group_code_num = s.code
  
WHERE i.op_code = 'i'
GROUP BY 1