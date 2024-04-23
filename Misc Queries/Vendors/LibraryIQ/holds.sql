WITH bib_holds AS (
SELECT
  l.bib_record_id,
  COUNT(h.id) AS hold_count

FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id

GROUP BY 1
)

SELECT
  DISTINCT rm.record_type_code||rm.record_num AS "BibRecordID",
  SUBSTRING(h.pickup_location_code,1,3) AS "Branch",
  --does this need to be total holds or total holds at this branch?
  bh.hold_count AS "Number of requests",
  CURRENT_DATE AS "Report Date"
  
FROM
sierra_view.hold h
JOIN
sierra_view.bib_record_item_record_link l
ON
h.record_id = l.bib_record_id OR h.record_id = l.item_record_id
JOIN
sierra_view.record_metadata rm
ON
l.bib_record_id = rm.id
JOIN
bib_holds bh
ON
l.bib_record_id = bh.bib_record_id