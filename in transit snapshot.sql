--Jeremy Goldstein
--Minuteman Library Network

--Captures snapshot data from items in transit

WITH transit AS (
SELECT
v.id AS id,
SPLIT_PART(v.field_content,': ',1) AS transit_timestamp,
SUBSTRING(SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1)FROM 1 FOR 3) AS origin_loc,
SUBSTRING(SPLIT_PART(v.field_content,'to ',2) FROM 1 FOR 3) AS destination_loc
FROM
sierra_view.varfield v
JOIN sierra_view.record_metadata m
ON
v.record_id = m.id
WHERE
v.varfield_type_code = 'm'
AND v.field_content LIKE '%IN TRANSIT%'
)

SELECT
origin_loc,
destination_loc,
COUNT(id)
FROM
transit
GROUP BY 1,2
ORDER BY 1,2