SELECT
DISTINCT SUBSTRING(i.location_code,1,3)||'z' AS locations

FROM
sierra_view.record_metadata rm
JOIN
sierra_view.bib_record_item_record_link l
ON
rm.id = l.bib_record_id
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id

WHERE

rm.record_type_code||rm.record_num = 'b3768257'
AND (
(i.location_code ~ '^win' AND i.itype_code_num IN ('245'))
OR (i.location_code ~ '^dd' AND i.itype_code_num IN ('245'))
OR i.location_code ~ '^wob'
OR i.location_code ~ '^blm'
)