/*
Jeremy Goldstein
Minuteman Library Network
Avg Price paid per item by material type
*/

SELECT
  m.name AS mat_type,
  AVG(p.paid_amount/p.copies)::MONEY AS avg_price_paid

FROM sierra_view.bib_record b
JOIN sierra_view.material_property_myuser m
  ON b.bcode2 = m.code
JOIN sierra_view.bib_record_order_record_link l
  ON b.id = l.bib_record_id
JOIN sierra_view.order_record o
  ON l.order_record_id = o.id
  AND o.order_status_code = 'a'
  AND o.order_date_gmt > (CURRENT_DATE - INTERVAL '1 YEAR')
JOIN sierra_view.order_record_paid p
  ON o.id = p.order_record_id
  
GROUP BY 1
ORDER BY 1