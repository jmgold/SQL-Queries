WITH transit AS (
SELECT
v.record_id AS id,
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
AND SUBSTRING(SPLIT_PART(SPLIT_PART(v.field_content,'from ',2),' to',1)FROM 1 FOR 3) = 'lex'
)

SELECT
DISTINCT id2reckey(h.patron_record_id)||'a',
v.field_content AS email


FROM
sierra_view.hold h
JOIN
transit
ON
h.record_id = transit.id
JOIN
sierra_view.patron_record p
ON
h.patron_record_id = p.id
JOIN
sierra_view.varfield v
ON
p.id = v.record_id AND v.varfield_type_code = 'z'
WHERE
h.pickup_location_code ~ '^lex'
AND h.status = 't'