/*
Jeremy Goldstein
Minuteman Library Network

Identifies bib records where all attached items have a status of billed, missing, withdrawn, etc..
*/
SELECT
rm.record_type_code||rm.record_num||'a' AS bib_number

FROM
sierra_view.bib_record AS b
JOIN
sierra_view.record_metadata AS rm
ON
rm.id = b.record_id
JOIN sierra_view.bib_record_item_record_link l
ON
b.id = l.bib_record_id
JOIN
sierra_view.item_record AS i
ON
l.item_record_id = i.id

-- bib record is not suppressed
WHERE b.bcode3 = '-'

-- group counts by column 1 (Bib Number)
GROUP BY 1
/*
limit result to bibs where all attached items
are no longer available, i.e., where the count
of all attached items equals the count of items
with bad statuses.
*/
HAVING COUNT(i.id) =
SUM(CASE
   -- include the status codes that you consider
   -- 'bad' between the parentheses
   WHEN i.item_status_code IN ('b','g','m','n','r','w','y','z','$')
   THEN 1
   ELSE 0
END)