/*
Jeremy Goldstein
Minuteman Library Network

Identifies titles with longest average wait times to fulfill holds
Limited to titles where a hold has a pickup location of a particular location
*/

WITH
/*
get created date of the oldest attached item as an estimated pub_date for use later
Also limits query to bibs with attached items, thus removing holds on pre-orders
*/
cat_date AS(
SELECT
l.bib_record_id,
MIN(rm.creation_date_gmt::DATE) AS cat_date
FROM
sierra_view.bib_record_item_record_link l
JOIN
sierra_view.record_metadata rm
ON l.item_record_id = rm.id
GROUP BY 1
),

--create an id value for each entry in hold_removed and resolve item level holds to their bib
bib_hold AS(
SELECT
h.patron_record_id::VARCHAR||h.record_id::VARCHAR||h.placed_gmt::VARCHAR AS id,
l.bib_record_id,
rm.record_type_code||rm.record_num||
COALESCE(
    CAST(
        NULLIF(
        (
            ( rm.record_num % 10 ) * 2 +
            ( rm.record_num / 10 % 10 ) * 3 +
            ( rm.record_num / 100 % 10 ) * 4 +
            ( rm.record_num / 1000 % 10 ) * 5 +
            ( rm.record_num / 10000 % 10 ) * 6 +
            ( rm.record_num / 100000 % 10 ) * 7 +
            ( rm.record_num / 1000000 % 10  ) * 8 +
            ( rm.record_num / 10000000 ) * 9
         ) % 11,
         10
         )
  AS CHAR(1)
  ),
  'x'
 ) AS bib_number,
 h.on_holdshelf_gmt::DATE AS end_date,
 h.placed_gmt,
 'removed' AS status

FROM
sierra_view.hold_removed h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id AND h.on_holdshelf_gmt IS NOT NULL
JOIN
sierra_view.record_metadata rm
ON
l.bib_record_id = rm.id

UNION

SELECT
h.id::VARCHAR AS id,
l.bib_record_id,
rm.record_type_code||rm.record_num||
COALESCE(
    CAST(
        NULLIF(
        (
            ( rm.record_num % 10 ) * 2 +
            ( rm.record_num / 10 % 10 ) * 3 +
            ( rm.record_num / 100 % 10 ) * 4 +
            ( rm.record_num / 1000 % 10 ) * 5 +
            ( rm.record_num / 10000 % 10 ) * 6 +
            ( rm.record_num / 100000 % 10 ) * 7 +
            ( rm.record_num / 1000000 % 10  ) * 8 +
            ( rm.record_num / 10000000 ) * 9
         ) % 11,
         10
         )
  AS CHAR(1)
  ),
  'x'
 ) AS bib_number,
CASE
 	WHEN h.on_holdshelf_gmt IS NOT NULL THEN h.on_holdshelf_gmt::DATE
 	ELSE CURRENT_DATE
END AS end_date,
h.placed_gmt,
'active' AS status

FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
(h.record_id = l.bib_record_id OR h.record_id = l.item_record_id) AND h.is_frozen = false
JOIN
sierra_view.record_metadata rm
ON
l.bib_record_id = rm.id
),

/*
Use to limit results to titles with local holds
and gather counts of items owned by the local location
*/
local_info AS(
SELECT
l.bib_record_id,
COUNT(DISTINCT h.id) AS local_holds,
COUNT(DISTINCT i.id) FILTER(WHERE i.location_code ~ '\w') AS local_items

FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
(h.record_id = l.bib_record_id OR h.record_id = l.item_record_id)
AND h.pickup_location_code ~ '\w' AND h.is_frozen = FALSE AND h.placed_gmt::DATE < CURRENT_DATE
JOIN
sierra_view.item_record i
ON
l.item_record_id = i.id

GROUP BY 1
)

SELECT
bh.bib_number,
b.best_title AS title,
b.best_author AS author,
mat.name AS format,
COUNT(bh.id) FILTER (WHERE bh.status = 'active') AS active_holds,
ROUND(AVG(CASE
	WHEN cd.cat_date <= bh.placed_gmt::DATE THEN bh.end_date - bh.placed_gmt::DATE
	ELSE bh.end_date - cd.cat_date
END),2) AS estimated_wait_time,
l.local_items AS item_count

FROM
bib_hold bh
JOIN
cat_date cd
ON
bh.bib_record_id = cd.bib_record_id
JOIN
sierra_view.bib_record_property b
ON
bh.bib_record_id = b.bib_record_id
JOIN
sierra_view.material_property_myuser mat
ON
b.material_code = mat.code
JOIN
local_info l
ON
b.bib_record_id = l.bib_record_id


GROUP BY 1,2,3,4,7
HAVING COUNT(bh.id) FILTER (WHERE bh.status = 'active') > 10
AND AVG(CASE
	WHEN cd.cat_date <= bh.placed_gmt::DATE THEN bh.end_date - bh.placed_gmt::DATE
	ELSE bh.end_date - cd.cat_date
END) > 90
AND l.local_items < 4
ORDER BY 5 DESC