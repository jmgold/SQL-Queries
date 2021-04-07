SELECT
lower(COALESCE(REGEXP_REPLACE(REGEXP_REPLACE(a.city,'\d','','g'),'\sma$','','i'),'')) AS city,
s.content AS tract,
COUNT(p.id) AS patron_count

FROM
sierra_view.patron_record p
JOIN
sierra_view.subfield s
ON
p.id = s.record_id AND s.field_type_code = 'k' AND s.tag = 't'
JOIN
sierra_view.patron_record_address a
ON
p.id = a.patron_record_id

GROUP BY 1,2
ORDER BY 1