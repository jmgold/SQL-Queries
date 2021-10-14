--Jeremy Goldstein
--Minuteman Library Network

--Captures snapshot data from items in transit


SELECT
m.record_type_code||m.record_num||'a' AS inumber,
TO_TIMESTAMP(SPLIT_PART(v.field_content,': ',1),'DY Mon DD YYYY HH:MIAM') AS transit_timestamp,
SUBSTRING(SPLIT_PART(v.field_content,'to ',2) FROM 1 FOR 3) AS destination_loc,
i.item_status_code
FROM
sierra_view.varfield v
JOIN sierra_view.record_metadata m
ON
v.record_id = m.id AND m.record_type_code = 'i' AND m.deletion_date_gmt IS NULL
AND v.varfield_type_code = 'm'
AND v.field_content LIKE '%IN TRANSIT%'
JOIN
sierra_view.item_record i
ON
m.id = i.id AND i.location_code !~ '^ntn'
WHERE
SUBSTRING(SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1)FROM 1 FOR 3) = 'ntn'

ORDER BY 2