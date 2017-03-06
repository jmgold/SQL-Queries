SELECT
b.record_id,
b.cataloging_date_gmt::DATE AS cataloging_date_gmt,
p.best_author,
p.best_title,
p.publish_year,
r.record_num,
UPPER( x.call_number_prefix ) as call_number_prefix,
UPPER( COALESCE (i.call_number_norm, x.call_number_prefix) ) as call_number_norm

FROM
sierra_view.bib_record				AS b
JOIN
sierra_view.record_metadata			AS r
  ON r.id = b.record_id
LEFT OUTER JOIN
sierra_view.bib_record_call_number_prefix	AS x
  ON x.bib_record_id = b.record_id
LEFT OUTER JOIN
sierra_view.bib_record_property			AS p
  ON p.bib_record_id = b.record_id
LEFT OUTER JOIN
sierra_view.bib_record_item_record_link	AS l	
  ON l.bib_record_id = b.record_id
LEFT OUTER JOIN
sierra_view.item_record_property		AS i
  ON l.item_record_id = i.item_record_id

WHERE       
b.is_suppressed is FALSE

-- if we want titles from a certain date (like last month for
-- example, we can use these two lines)
AND b.cataloging_date_gmt >= date('2016-07-01 00:00:00') 
-- AND b.cataloging_date_gmt <  date('') AND

-- if we want to do any call number limiting ... we can use 
-- this part of the where clause
-- AND x.call_number_prefix LIKE LOWER('A')

GROUP BY
b.record_id,
cataloging_date_gmt,
p.best_author,
p.best_title,
p.publish_year,
r.record_num,
call_number_prefix,
call_number_norm

ORDER BY
cataloging_date_gmt,
call_number_prefix,
call_number_norm

LIMIT 1000
-- if we get too many results or we want to limit ...
-- LIMIT 1000