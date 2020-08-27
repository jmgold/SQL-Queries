--limit to NTN patrons
SELECT
  pv.record_num AS PatronId,
  pv.barcode,
  b.bcode2 AS mat_type, 
  i.itype_code_num AS item_type,
  i.checkout_statistic_group_code_num AS checkout_location, 
  i.location_code AS item_location,  
  c.checkout_gmt AS checkout_time,
  c.renewal_count AS renewals,
  c.due_gmt as duedate
FROM sierra_view.patron_view pv
INNER JOIN sierra_view.checkout c
  ON pv.id = c.patron_record_id
INNER JOIN sierra_view.item_record i
  ON c.item_record_id = i.id
INNER JOIN sierra_view.bib_record_item_record_link l
  ON i.id = l.item_record_id
INNER JOIN sierra_view.bib_record b
  ON l.bib_record_id = b.id
WHERE DATE_PART('day', now()::timestamp - c.checkout_gmt::timestamp) < 7
AND (c.loanrule_code_num BETWEEN '321' AND '331' OR c.loanrule_code_num BETWEEN '762' AND '770')
AND pv.ptype_code = '29'
order by c.checkout_gmt